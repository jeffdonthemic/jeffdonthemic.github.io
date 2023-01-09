---
layout: post
title:  Relationship Lookup Objects in Triggers are NULL?
description: I see this question once in awhile on the Salesforce.com message boards  so I thought Id put something together. So in this scenario you have a Sales_Order__c custom object which has a lookup relationship to Opportunity. When processing the  Sales_Order__c records in your trigger, you want to access some fields on the Opportunity via the relationship. Your trigger might look something like this-  trigger SalesOrderUpdate on Sales_Order__c (before update) {   for (Sales_Order__c so - Trigger.new)
date: 2010-02-23 12:31:37 +0300
image:  '/images/slugs/relationship-lookup-objects-in-triggers-are-null.jpg'
tags:   ["2010", "public"]
---
<p>I see this question once in awhile on the <a href="http://community.salesforce.com/sforce/board?board.id=apex">Salesforce.com message boards</a> so I thought I'd put something together. So in this scenario you have a <code>Sales_Order__c</code> custom object which has a lookup relationship to Opportunity. When processing the <code>Sales_Order__c</code> records in your trigger, you want to access some fields on the Opportunity via the relationship. Your trigger might look something like this:</p>
{% highlight js %}trigger SalesOrderUpdate on Sales_Order__c (before update) {

 for (Sales_Order__c so : Trigger.new) {
   System.debug('Opportuny Id: '+so.Opportunity__c);
   // Opportunity__r will be NULL
   System.debug('Opportuny: '+so.Opportunity__r.StageName);
 }

}
{% endhighlight %}
<p>However, every time you run the Trigger, the Opportunity is null even though there is a valid Id in <code>Opportunity__c</code>. The reason is that for scalability, the Force.com platform doesn't perform an in-memory lookup for each relationship in your object. You need to do that yourself. The good thing is that the solution is relatively painless and is safe for bulk transactions.</p>
<p>In the trigger below you first want to create a set of unique Opportunity Ids that are in the trigger context. You then use those Ids to query and create a map with the Opportunity Id as the key and the Opportunity object as the value. Then when you process your <code>Sales_Order__c</code> records you can access the Opportunity object from the map by its Id (line 14).</p>
{% highlight js %}trigger SalesOrderUpdate on Sales_Order__c (before update) {

 // create a set of all the unique opportunity ids for SOQL below
  Set<id> oppIds = new Set<id>();
  for (Sales_Order__c so : Trigger.new)
   oppIds.add(so.Opportunity__c);

 // create a map so that Opportunity is locatable by its Id (key)
 Map<id, Opportunity> oppsMap = new Map<id, Opportunity>(
   [SELECT Amount, StageName FROM Opportunity WHERE Id IN :oppIds]);

 for (Sales_Order__c so : Trigger.new) {
   // fetch the Opportunity from the map by its Id
   System.debug('Opportunity: '+oppsMap.get(so.Opportunity__c).StageName);
   // perform some type of business operation now...
 }

}
{% endhighlight %}

