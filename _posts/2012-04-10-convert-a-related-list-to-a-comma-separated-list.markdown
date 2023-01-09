---
layout: post
title:  Convert a Related List to a Comma Separated List
description: Sure, picklists and (sometimes) multi-select picklists are a great way to store data for Salesforce.com objects but related list are much more powerful and flexible. Heres a great little trick to keep the power of related objects but still have the ease of use of a quasi-picklist for reporting, creating formulas, displaying values to users, external applications (iterating through a collection to display a comma separated list is tiresome!), etc.   The use case is that Accounts can operate in ma
date: 2012-04-10 13:49:02 +0300
image:  '/images/slugs/convert-a-related-list-to-a-comma-separated-list.jpg'
tags:   ["2012", "public"]
---
<p>Sure, picklists and (sometimes) multi-select picklists are a great way to store data for Salesforce.com objects but related list are much more powerful and flexible. Here's a great little trick to keep the power of related objects but still have the ease of use of a quasi-picklist for reporting, creating formulas, displaying values to users, external applications (iterating through a collection to display a comma separated list is tiresome!), etc.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327741/csv-list_kw31cv.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327741/csv-list_kw31cv.png" alt="" title="csv-list" width="500" class="aligncenter size-full wp-image-4467" /></a></p>
<p>The use case is that Accounts can operate in many regions so we need a way to tie Accounts and Regions together. Typically you would create a new custom object (i.e., a junction object) with a master-detail relationship to Account and a master-detail relationship to Region. This allows you to map multiple Accounts to multiple Regions.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327740/cvs-list-erd_fhnhlh.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327740/cvs-list-erd_fhnhlh.png" alt="" title="cvs-list-erd" width="500" class="aligncenter size-full wp-image-4477" /></a></p>
<p>However, for ease of use, let's put a single textarea field on the Account object and show the names of the regions as a simple comma separated list of values. We do this by creating a trigger that updates the Account each time the junction object (<code>Account_Region__c</code>) records are inserted, updated or deleted.</p>
<p>The trigger below fires whenever an <code>Account_Region__c</code> records is inserted, updated or deleted and simply passes the IDs for the Accounts that are affected to the AccountRegionTriggerHandler class for processing.</p>
{% highlight js %}trigger AccountRegionTrigger on Account_Region__c (after delete, after insert, after update) {
 
 // fires after both insert and update
 if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
  
  // find the ids of all accounts that were affected
  Set<Id> accountIds = new Set<Id>();
  for (Account_Region__c ar : [select Id, Account__c from Account_Region__c 
 where Id IN :Trigger.newMap.keySet()])
 accountIds.add(ar.Account__c);
  
  // process the accounts 
  AccountRegionTriggerHandler.ProcessRegionsAsync(accountIds);
  

 // fires when records are deleted. may want to do undelete also?
 } else if(Trigger.isDelete && Trigger.isAfter){
  
  // find the ids of all accounts that were affected
  Set<Id> accountIds = new Set<Id>();
  for (ID id : Trigger.oldMap.keySet())
 accountIds.add(Trigger.oldMap.get(id).Account__c);
  
  // process the accounts
  AccountRegionTriggerHandler.ProcessRegionsAsync(accountIds);

 }

}
{% endhighlight %}
<p>The AccountRegionTriggerHandler does all of the heaving lifting. For the Accounts in context, it queries for all of the Regions for each account, builds a comma separated list of region names and then updates the accounts with this list of regions.</p>
{% highlight js %}public with sharing class AccountRegionTriggerHandler {
 
 @future 
 public static void ProcessRegionsAsync(Set<ID> accountIds){
  
  // holds a map of the account id and comma separated regions to build
  Map<Id, String> accountRegionMap = new Map<Id, String>();
 
  // get ALL of the regions for all affected accounts so we can build
  List<Account_Region__c> accountRegions = [select id, Account__c, 
 Region__r.Name from Account_Region__c 
 where Account__c IN :accountIds order by Region__r.Name];
 
  for (Account_Region__c ar : accountRegions) {
 if (!accountRegionMap.containsKey(ar.Account__c)) {
  // if the key (account) doesn't exist, add it with region name
  accountRegionMap.put(ar.Account__c,ar.Region__r.Name);
 } else {
  // if the key (account) already exist, add ", region-name"
  accountRegionMap.put(ar.Account__c,accountRegionMap.get(ar.Account__c) + 
   ', ' + ar.Region__r.Name);
 }
  }
  
  // get the account that were affected
  List<Account> accounts = [select id from Account where Id IN :accountIds];
  
  // add the comma separated list of regions
  for (Account a : accounts)
 a.Regions__c = accountRegionMap.get(a.id);
  
  // update the accounts
  update accounts;
  
 } 
 
}
{% endhighlight %}
<p>And finally, here's the unit tests for the trigger handler.</p>
{% highlight js %}@isTest
private class Test_AccountRegionTriggerHandler {
 
 static List<Region__c> regions = new List<Region__c>();
 
 static {
 
  // insert some regions
  Region__c r1 = new Region__c(name='Region 1');
  Region__c r2 = new Region__c(name='Region 2');
  Region__c r3 = new Region__c(name='Region 3');
  Region__c r4 = new Region__c(name='Region 4');
  regions.add(r1);
  regions.add(r2);
  regions.add(r3);
  regions.add(r4);
  insert regions;
  
 }
 
 private static void testInsertRecords() {
  
  List<Account> accounts = new List<Account>();
  List<Account_Region__c> accountRegions = new List<Account_Region__c>();
  
  // insert some accounts
  Account a1 = new Account(name='Account 1');
  Account a2 = new Account(name='Account 2');
  accounts.add(a1);
  accounts.add(a2);
  insert accounts;
  
  Test.startTest();
  
 accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(0).Id));
 accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(1).Id));
 accountRegions.add(new Account_Region__c(Account__c=a2.Id, Region__c=regions.get(2).Id));
 accountRegions.add(new Account_Region__c(Account__c=a2.Id, Region__c=regions.get(3).Id));
 
 insert accountRegions;
  
  Test.stopTest();
  
  // since async, check for the accounts AFTER tests stop
  List<Account> updatedAccounts = [select id, name, regions__c from account where id IN :accounts];
  System.assertEquals('Region 1, Region 3',updatedAccounts.get(0).Regions__c);
  System.assertEquals('Region 2, Region 4',updatedAccounts.get(1).Regions__c);
  
 }
 
 private static void testDeleteRecords() {
  
  List<Account> accounts = new List<Account>();
  List<Account_Region__c> accountRegions = new List<Account_Region__c>();
  
  // insert an account
  Account a1 = new Account(name='Account 1');
  accounts.add(a1);
  insert accounts;
  
  Test.startTest();
  
 accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(0).Id)); 
 accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(1).Id));
 accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(2).Id));
 accountRegions.add(new Account_Region__c(Account__c=a1.Id, Region__c=regions.get(3).Id));
 
 insert accountRegions;
  
 // now delete a record
 delete accountRegions.get(3);
  
  Test.stopTest();
  
  List<Account> updatedAccounts = [select id, name, regions__c from account where id IN :accounts];
  System.assertEquals('Region 1, Region 2, Region 3',updatedAccounts.get(0).Regions__c);
  
 }
 
}
{% endhighlight %}
<p>A couple of caveats:</p>
<ol>
<li>Since textarea fields only hold 255 characters, this may not be the best approach for extremely long lists of values.
<li>You may want give profiles read-only access to the field holding the list of values so that they cannot edit it. The trigger runs in system mode so that it has read-write access to this field.
</ol>
