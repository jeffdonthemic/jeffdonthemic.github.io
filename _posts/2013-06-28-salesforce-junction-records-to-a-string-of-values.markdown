---
layout: post
title:  Salesforce Junction Records to a String of Values
description:   Salesforce Junction objects  are a convenient way to create a many-to-many relationship in your data model. Accourding to the docs , a many-to-many relationship allows each record of one object to be linked to multiple records from another object and vice versa. For example, you may have a custom object called Bug that relates to the standard case object such that a bug could be related to multiple cases and a case could also be related to multiple bugs. When modeling a many-to-many relationsh
date: 2013-06-28 12:39:59 +0300
image:  '/images/slugs/salesforce-junction-records-to-a-string-of-values.jpg'
tags:   ["salesforce"]
---
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327712/Petticoat_Junction_title_screen_y2ncol.jpg" alt="" ></p>
<p>Salesforce <a href="http://login.salesforce.com/help/doc/en/relationships_manytomany.htm" target="_blank">Junction objects</a> are a convenient way to create a many-to-many relationship in your data model. Accourding to <a href="http://login.salesforce.com/help/doc/en/relationships_manytomany.htm" target="_blank">the docs</a>, a many-to-many relationship allows each record of one object to be linked to multiple records from another object and vice versa. For example, you may have a custom object called Bug that relates to the standard case object such that a bug could be related to multiple cases and a case could also be related to multiple bugs. When modeling a many-to-many relationship, you use a junction object to connect the two objects you want to relate to each other.</p>
<p>While Junction objects are great in threory, in the real-world they are sometimes a little difficult to work with. One issue that always bugs me is that the 'Name' of the record that I am REALLY insterested in is not part of the Junction Object but part of the related object. So I thought to myself, why not add a field to one of the master objects and display a comma separated list of the 'Name' values from the other object in the relationship. These are the values I really want to see. This list would be useful for reporting, exposing via web services, integrations, etc. so you wouldn't have to worry about dealing with the collection of junction records... just their values.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327712/screenshot_totsoq.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327712/screenshot_totsoq.png" alt="" title="screenshot" width="355" height="225" class="alignnone size-full wp-image-4869" /></a></p>
<p>Disclaimer: this is great approach for 2-5 Junction records in the list but after that it gets somewhat unweildly.</p>
<p>So we have this same use case at <a href="http://www.cloudspokes.com" target="_blank">CloudSpokes</a>. We have two objects called <code>Challenge__c</code> and <code>Platform__c</code>. <a href="http://www.cloudspokes.com/challenges"target="_blank">If you look at our site</a>, you'll notice that a challenge can be for multiple platforms.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327711/screenshot2_oaynrc.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327711/screenshot2_oaynrc.png" alt="" title="screenshot2" width="499" height="162" class="alignnone size-full wp-image-4871" /></a></p>
<p>Naturally we achieve this with a Junction object called <code>Challenge_Platform__c</code>. Notice the <code>Name__c</code> field which is a formula to add the value of the Name field from the <code>Platform__c</code> field to the Junction object. This comes in handy in our Apex code as this makes it easier to reference the name then by looking up the reference.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327710/schema_nuj93q.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_189,w_300/v1400327710/schema_nuj93q.png" alt="" title="schema" width="300" height="189" class="alignnone size-medium wp-image-4873" /></a></p>
<p>We are really interested in what platforms a challenge is for and would like to display that at the top of the page instead of making the user scroll down to the related list section. So let's write a Trigger that creates a comma separated list of the current platforms for a challenge each time we insert or delete a new <code>Challenge_Platform__c</code> record(s). We aren't too concerned with updates since there's really nothing to update of value on the Junction object.</p>
<p><strong>ChallengePlatformTrigger</strong></p>
<p>So here's the code for our trigger which fires after new <code>Challenge_Platform__c</code> records are inserted or deleted. The trigger code essentially builds a Set of the Challenge Ids that were affected by the insert/delete operation and passes them off to the ChallengePlatformTriggerHandler.RollupNamesToList method asynchronously to be processed. We process these records asynchronously since we don't need this new list <em>immediately</em> and why make users wait for a process to finish when you could perform it in the background without the delay?</p>
{% highlight js %}/******************************************************************
 Name : ChallengePlatformTrigger
 Created By : Jeff Douglas (jeff@appirio.com)
 Created Date : June 27, 2013
 Description : Trigger to operate for Challenge Platforms. Delegates
 functionality to ChallengePlatformTriggerHandler.
********************************************************************/
trigger ChallengePlatformTrigger on Challenge_Platform__c (after delete, 
 after insert) {
  
 if (Trigger.isInsert && Trigger.isAfter) {
  
  Set<ID> challengeIds = new Set<ID>();
  for (Challenge_Platform__c cp : [select challenge__c from Challenge_Platform__c 
 where id IN :Trigger.newMap.keySet()]) { challengeIds.add(cp.challenge__c); }  
  ChallengePlatformTriggerHandler.RollupNamesToList(challengeIds);
  
 } else if(Trigger.isDelete && Trigger.isAfter) {
  
  Set<ID> challengeIds = new Set<ID>();
  for (Id challengePlatformId : Trigger.oldMap.keySet())
 challengeIds.add(Trigger.oldMap.get(challengePlatformId).Challenge__c);
  ChallengePlatformTriggerHandler.RollupNamesToList(challengeIds);
  
 }
}
{% endhighlight %}
<p><strong>ChallengePlatformTriggerHandler</strong></p>
<p>The ChallengePlatformTriggerHandler does the actual work for us with a little help from the awesome <a href="https://appexchange.salesforce.com/listingDetail?listingId=a0N30000001qoYfEAI" target="_blank">apex-lang package</a> and it's <a href="https://code.google.com/p/apex-lang/source/browse/tags/1.18/src/classes/ArrayUtils.cls#150" target="_blank">pluck method</a>. With pluck, you can pass the method a List of Objects (from a query let's say) and it will return an array with the values from the field you specified. Not sure why pluck isn't part of Apex natively as it's super useful.</p>
<p>On line #17 below we create a map that contains the challenges being affects and the <code>Name__c</code> field of all related Junction objects. Then we iterate through the map by ID and build the string list of names. On line #28 we use the pluck method to return an Object array of the <code>Name__c</code> field values in the related records. Then we update the challenge depending with the new list of platform names or null if all Junction records have been deleted. Notice the Utils.ListToCSVString on line 33. This is a simple helper that takes an array of Objects and returns a comma separated list.</p>
{% highlight js %}/******************************************************************
 Name : ChallengePlatformTriggerHandler
 Created By : Jeff Douglas (jeff@appirio.com)
 Created Date : June 27, 2013
 Description : Updates the challenge with a csv list of
 related platform records.
********************************************************************/
public with sharing class ChallengePlatformTriggerHandler {
 
 @future
 public static void RollupNamesToList(Set<ID> challengeIds) {
  
  // the collection of challenges to eventually update
  List<Challenge__c> challengesToUpdate = new List<Challenge__c>();
  
  // create a map of the affected challenges so we can access them by id
  Map<ID, Challenge__c> challenges = new Map<ID, Challenge__c>([select id, 
 (select name__c from challenge_platforms__r order by name__c) 
 from challenge__c where Id IN :challengeIds]);

  // iterate through the map by id
  for (Id challengeId : challenges.keySet()) {
 
 // process the current challenge record from the map
 Challenge__c challenge = challenges.get(challengeId);
 // returns an object array (of strings) with values from 'name__c' field
 // this will return an object array like: ['Heroku','Salesforce.com']
 List<Object> pluckedNames = 
  ArrayUtils.pluck(challenge.challenge_platforms__r, 'name__c');
 
 if (!pluckedNames.isEmpty()) {
  // update the challenge with the new list of items
  challengesToUpdate.add(new Challenge__c(id=challengeId, 
   platforms__c=Utils.ListToCSVString(pluckedNames)));
 } else {
  // if we deleted all item, then set the field as null
  challengesToUpdate.add(new Challenge__c(id=challengeId, 
   platforms__c=null));
 }
 
  }
  update challengesToUpdate; 
 }
}
{% endhighlight %}
<p><strong>Test_ChallengePlatformTriggerHandler</strong></p>
<p>No application for Force.com is complete with out test case! So here is your test class with 100% coverage.</p>
{% highlight js %}public with sharing class Test_ChallengePlatformTriggerHandler {
 
 static {
  // load our static platform data
  Test.loadData(Platform__c.sObjectType, 'platforms'); 
 } 

 static testMethod void testAddPlatforms() {
  
  // helper method to create a new challenge
  Challenge__c c = TestUtils.createChallenge();
  List<Platform__c> allPlatforms = [select id, name from platform__c];
  List<Challenge_Platform__c> platformsToInsert = new List<Challenge_Platform__c>();
  
  Challenge_Platform__c cp1 = new Challenge_Platform__c();
  cp1.Challenge__c = c.id;
  cp1.Platform__c = allPlatforms.get(1).id;
  platformsToInsert.add(cp1);
  
  Challenge_Platform__c cp2 = new Challenge_Platform__c();
  cp2.Challenge__c = c.id;
  cp2.Platform__c = allPlatforms.get(2).id;
  platformsToInsert.add(cp2);
  
  Test.startTest();
  insert platformsToInsert; 
  Test.stopTest();
  
  System.assertEquals(allPlatforms.get(1).name + ', ' + allPlatforms.get(2).name, 
 [select Platforms__c from challenge__c where id = :c.id].Platforms__c);
  
 }
 
 static testMethod void testDeletePlatforms() {
  
  Challenge__c c = TestSetup_Challenge.createChallenge();
  List<Platform__c> allPlatforms = [select id from platform__c];
  List<Challenge_Platform__c> platformsToInsert = new List<Challenge_Platform__c>();
  
  Challenge_Platform__c cp1 = new Challenge_Platform__c();
  cp1.Challenge__c = c.id;
  cp1.Platform__c = allPlatforms.get(1).id;
  platformsToInsert.add(cp1);
  
  Test.startTest();
  insert platformsToInsert;
  delete [select id from challenge_platform__c where challenge__c = :c.id and 
 platform__c = :allPlatforms.get(1).id];
  Test.stopTest();
  
  System.assertEquals(null, [select Platforms__c from challenge__c where id = :c.id].Platforms__c);
  
 } 
}
{% endhighlight %}

