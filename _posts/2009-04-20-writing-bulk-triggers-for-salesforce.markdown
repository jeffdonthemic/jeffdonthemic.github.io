---
layout: post
title:  Writing Bulk Triggers for Salesforce.com
description: Its exciting to see all of the new members on the Salesforce.com message board that are just getting into cloud computing. Some of the most common questions revolve around how to write, test and debug bulk triggers. Programming for a multi-tenant environment is different than developing for a dedicated server and its understandable that developers coming from a Java or .NET background will have some sort of ramp up time. This article does not go over all aspects of triggers or bulk processing, s
date: 2009-04-20 15:20:16 +0300
image:  '/images/slugs/writing-bulk-triggers-for-salesforce.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>It's exciting to see all of the new members on the Salesforce.com message board that are just getting into cloud computing. Some of the most common questions revolve around how to write, test and debug bulk triggers. Programming for a multi-tenant environment is different than developing for a dedicated server and it's understandable that developers coming from a Java or .NET background will have some sort of ramp up time.</p>
<p>This article does not go over all aspects of triggers or bulk processing, so please see the <a href="http://www.salesforce.com/us/developer/docs/apexcode/index.htm" target="_blank">Apex docs</a> for more info. There is some really good documentation and tutorials on writing Apex triggers and unit testing but it seems to be spread out over different documents and wiki pages. My goal is to pull together all of this disparate info together into one tutorial and demonstrate how to write, and not write, triggers for Salesforce.com.</p>
<p>What exactly is a trigger? If you come from a SQL Server or Oracle background you will have some trigger experience, however a trigger in Salesforce.com is slightly different. According to the Apex documentation, a trigger is an Apex script that executes before or after insert, update, or delete events occur, such as before object records are inserted into the database, or after records have been deleted. When a trigger fires it can process anywhere from 1 to 200 records so all triggers should be written to accommodate bulk transactions. Examples of single record and bulk transactions include:</p>
<ul>
 <li>Data import</li>
 <li>Bulk Force.com API calls</li>
 <li>Mass actions, such as record owner changes and deletes</li>
 <li>Recursive Apex methods and triggers that invoke bulk DML statements</li>
</ul>
<strong>First I'm going to outline the wrong way to write triggers.</strong> I think this is important to demonstrate, as it is how must new developers begin. Remember, this is wrong way to write a trigger. Here is the use case for the trigger. Each time an Account is created or updated, you want to fetch the Account owner's "favorite color" from a custom field on their User record and write it into the Account's record.
<p>Coming from a Java or .NET background, I would probably write a trigger something like the following. This would be perfectly acceptable if you only needed to update a single record each time.</p>
{% highlight js %}trigger AddOwnerColor on Account (before insert, before update) {

 /** EXAMPLE OF HOW TO -- NOT -- WRITE A BULK TRIGGER **/

 // iterate over the list of records being processed in the trigger and
 // set the color before being inserted or updated
 for (Account a : Trigger.new)
  a.Owner_Favorite_Color__c = [Select Favorite_Color__c from User Where Id = :a.OwnerId].Favorite_Color__c;

}

{% endhighlight %}
<p>Here is the test class for the trigger. The first unit test (testSingleInsert) runs fine as it does not encounter any governors. The second unit test (testBulkInsert) will fail when trying to insert 200 records with the followning message:</p>
<blockquote>System.DmlException: Insert failed. First exception on row 0; first error: CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY, AddOwnerColor: execution of BeforeInsert
caused by: System.Exception: Too many SOQL queries: 101</blockquote>
There are a number of governors that the Apex runtime engine enforces for specific contexts and entry points (trigger, tests, anonymous block execution, controllers and WSDL methods). You should study "<a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_gov_limits.htm" target="_blank">Understanding Execution Governors and Limits</a>" religiously as it will dictate how you develop for the Force.com platform. It is suggested that you test bulk processing with at least 25 records but I typically use 200. My reasoning is that if you only use 25 records and do not utilize the testing runtime context (Test.startTest) your trigger will run without errors. However, once you put this trigger into Production it will throw an exception when processing the 21st record. The reason is that triggers have a 20 SOQL query limit while in RunTest it has a limit of 100 SOQL queries.
{% highlight js %}@isTest
private class TestAccountColorTrigger {

 static testMethod void testSingleInsert() {

  Profile p = [select id from profile where name='Standard User'];

  User u = new User(alias = 'test123', email='test123@noemail.com',
   emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
   localesidkey='en_US', profileid = p.Id, country='United States',
   Favorite_Color__c='Pretty Pink',
   timezonesidkey='America/Los_Angeles', username='test123@noemail.com');
  insert u;

  Account a = new Account(
   Name = 'Test Account',
   OwnerId = u.Id
  );

  insert a;

  // assert that the color on the account matches the account owner's color on their user record
  System.assertEquals(u.Favorite_Color__c,[Select Owner_Favorite_Color__c From Account Where Id = :a.Id].Owner_Favorite_Color__c);

 }

 static testMethod void testBulkInsert() {

  List<account> accounts = new List<account>();
  Profile p = [select id from profile where name='Standard User'];

  User u = new User(alias = 'test123', email='test1234@noemail.com',
   emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
   localesidkey='en_US', profileid = p.Id, country='United States',
   Favorite_Color__c='Pretty Pink',
   timezonesidkey='America/Los_Angeles', username='test1234@noemail.com');
  insert u;

  for (Integer i=0;i<200;i++) {

   Account a = new Account(
    Name = 'Test Account',
    OwnerId = u.Id
   );
   accounts.add(a);

  }

  insert accounts;

 }
}

{% endhighlight %}
<p><strong>Writing the Bulk Safe Trigger</strong></p>
<p>To write bulk safe triggers, it is critical that you understand and utilize sets and maps. Sets are used to isolate distinct records, while maps are name-value pairs that hold the query results retrievable by record id. So here is the bulk safe trigger code. When the trigger fires we initially create a set containing all of the distinct OwnerIds for the records being processed (1 -> 200). Then we query to find all of the User records for the OwnerIds in the set. This returns a map with the UserId as the key and the User object as the value. We then iterate over the list of Accounts in the trigger, use the map's get method to fetch the correct User object by its OwnerId and write the User's favorite color into a custom field (Owner_Favorite_Color__c) on the Account. When the records are committed to the database, the User's color auto-magically appears!</p>
{% highlight js %}trigger AddOwnerColor on Account (before insert, before update) {

 // create a set of all the unique ownerIds
 Set<id> ownerIds = new Set<id>();
 for (Account a : Trigger.new)
 ownerIds.add(a.OwnerId);

 // query for all the User records for the unique userIds in the records
 // create a map for a lookup / hash table for the user info
 Map<id, User> owners = new Map<id, User>([Select Favorite_Color__c from User Where Id in :ownerIds]);

 // iterate over the list of records being processed in the trigger and
 // set the color before being inserted or updated
 for (Account a : Trigger.new)
  a.Owner_Favorite_Color__c = owners.get(a.OwnerId).Favorite_Color__c;

}

{% endhighlight %}
<p>To test the trigger, we've made a few modifications to test for governor limits. You can use the system static startTest and stopTest methods to ensure your code runs properly in the runtime context. You should set up all of your variables, data structures, etc and then call startTest. After you call this method, the limits that get applied are based on your first DML statement (INSERT, UPSERT, etc). The stopTest method marks the point in your test code when your test ends and any post assertions are done in the original context. The graphic below displays the resource summary in both the RunTest context as well testing context.</p>
<p><img src="images/user-context_tita6e.png" alt="" ></p>
<p>We've also added the modification to allow the DML statement to run as a specific user. According to the Apex docs, generally all Apex scripts run in system mode, and the permissions and record sharing of the current user are not taken into account. The system method runAs enables you to write test methods that change user contexts to either an existing user or a new user. All of that user's record sharing is then enforced.</p>
{% highlight js %}@isTest
private class TestAccountColorTrigger {

 static testMethod void testBulkInsert() {

  List<account> accounts = new List<account>();

  Profile p = [select id from profile where name='Marketing User'];
  // create a user to run the test as
  User u = new User(alias = 'test123', email='test1234@noemail.com',
   emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
   localesidkey='en_US', profileid = p.Id, country='United States',
   Favorite_Color__c='Buttercup Yellow',
   timezonesidkey='America/Los_Angeles', username='test1234@noemail.com');
  insert u;

  Profile p1 = [select id from profile where name='Standard User'];
  // create a user to own the account
  User u1 = new User(alias = 'test123', email='test12345@noemail.com',
   emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
   localesidkey='en_US', profileid = p1.Id, country='United States',
   Favorite_Color__c='Pretty Pink',
   timezonesidkey='America/Los_Angeles', username='test12354@noemail.com');
  insert u1;

  // add 200 accounts to the list to be inserted
  for (Integer i=0;i<200;i++) {

   Account a = new Account(
    Name = 'Test Account',
    OwnerId = u1.Id
   );
   accounts.add(a);

  }

  // Switch to the runtime context
 Test.startTest();

 // run as a different user to test security and rights
 System.runAs(u) {
   insert accounts;
 }

 // Switch back to the original context
 Test.stopTest();

  // query for all accounts created and assert that the color was added correctly
  for (Account acct : [Select Owner_Favorite_Color__c from Account Where OwnerId = :u1.Id])
   System.assertEquals(acct.Owner_Favorite_Color__c,'Pretty Pink');

 }
}

{% endhighlight %}
<p>When you run your tests you should see the following:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399625/test-results_cthxxg.png" alt="" ></p>

