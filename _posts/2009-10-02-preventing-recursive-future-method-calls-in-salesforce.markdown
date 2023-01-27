---
layout: post
title:  Preventing Recursive Future Method Calls in Salesforce
description: Governor limits are runtime limits enforced by the Force.com platform to ensure that your code doesnt, among other things, hog memory resources, lock up the database with an excessive amount of calls or create infinite code loops. Working within governor limits requires you to sometimes become creative when writing Apex. One way to work within Force.com platform limits as to use asynchronous Apex methods with the future annotation. Calls to these methods execute asynchronously when the server ha
date: 2009-10-02 12:56:48 +0300
image:  '/images/pexels-godisable-jacob-944762.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>Governor limits are runtime limits enforced by the Force.com platform to ensure that your code doesn't, among other things, hog memory resources, lock up the database with an excessive amount of calls or create infinite code loops. Working within governor limits requires you to sometimes become creative when writing Apex.</p>
<p>One way to work within Force.com platform limits as to use asynchronous Apex methods with the future annotation. Calls to these methods execute asynchronously when the server has available resources and are subject to their own additional limits:</p>
<ul>
 <li>No more than 10 method calls per Apex invocation</li>
 <li>No more than 200 method calls per Salesforce.com license per 24 hours</li>
 <li>The parameters specified must be primitive dataypes, arrays of primitive datatypes, or collections of primitive datatypes.</li>
 <li>Methods with the future annotation cannot take sObjects or objects as arguments.</li>
 <li>Methods with the future annotation cannot be used in Visualforce controllers in either getMethodName or setMethodName methods, nor in the constructor.</li>
 <li>You cannot call a method annotated with future from a method that also has the future annotation. Nor can you call a trigger from an annotated method that calls another annotated method.</li>
</ul>
One issue that you can run into when using future methods is writing a trigger with a future method that calls itself recursively. Here is a simple scenario. You have a trigger that inserts/updates a record (or a batch of them) and then makes a future method call that performs more processing on the <em>same record(s)</em>. The issue is that this entire process becomes recursive in nature and you receive the error, "System.AsyncException: Future method cannot be called from a future method..." Here is what it looks like:
<p style="text-align:center;"><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399498/mockup_zzegcj.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399498/mockup_zzegcj.png" alt="" title="mockup" width="550" class="alignnone size-full wp-image-1408" /></a></p>
There are a couple of ways to prevent this recursive behavior.
<p><strong>1. Add a new field to the object so the trigger can inspect the record to see if it is being called by the future method.</strong></p>
<p>The trigger checks the value of IsFutureContext__c in the list of Accounts passed into the trigger. If the IsFutureContext__c value is true then the trigger is being called from the future method and the record shouldn't be processed. If the value of IsFutureContext__c is false, then the trigger is being called the first time and the future method should be called and passed the Set of unique names.</p>
{% highlight js %}trigger ProcessAccount on Account (before insert, before update) {
 Set&lt;String&gt; uniqueNames = new Set&lt;String&gt;();
 for (Account a : Trigger.new) {
   if (a.IsFutureContext__c) {
    a.IsFutureContext__c = false;
   } else {
   uniqueNames.add(a.UniqueName__c);
   }
 }
 if (!uniqueNames.isEmpty())
   AccountProcessor.processAccounts(uniqueNames);
}
{% endhighlight %}
<p>The AccountProcessor class contains the static method with the future annotation that is called by the trigger.The method processes each Account and sets the value of IsFutureContext__c to false before committing. This prevents the trigger from calling the future method once again.</p>
{% highlight js %}public class AccountProcessor {

 @future
 public static void processAccounts(Set&lt;String&gt; names) {
   // list to store the accounts to update
   List&lt;Account&gt; accountsToUpdate = new List&lt;Account&gt;();
   // iterate through the list of accounts to process
   for (Account a : [Select Id, Name, IsFutureContext__c From Account where UniqueName__c IN :names]) {
    // ... do you account processing
    // set the field to true, since we are about to fire the trigger again
    a.IsFutureContext__c = true;
    // add the account to the list to update
    accountsToUpdate.add(a);
   }
   // update the accounts
   update accountsToUpdate;
 }

}

{% endhighlight %}
<p><strong>2. Use a static variable to store the state of the trigger processing. </strong></p>
<p>According to the <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_static.htm?SearchType=Stem" target="_blank">Apex docs</a>, static variables are used to store information that is shared within the confines of a class. All instances of the same class share a single copy of the static variable. All triggers that are spawned by the same request can communicate with each other by referencing static variables in a related class. A recursive trigger can use the value of this class variable to determine when to exit the recursion. I've used this method many times before and was pleasantly surprised to find that this class is also shared when calling a method annotated as future.</p>
<p>The shared ProcessControl class with the static variable that is shared by the trigger and used to determine when to exit the process.</p>
{% highlight js %}public class ProcessorControl {
 public static boolean inFutureContext = false;
}
{% endhighlight %}
<p>In this case the trigger inspects the current value of the static variable ProcessorControl.inFutureContext to determine whether to process the records. If the value is false, then the trigger is being called the first time and the future method should be called and passed the Set of unique names. If the value is true then the trigger is being called from the future method and the records should not be processed.</p>
{% highlight js %}trigger ProcessAccount on Account (before insert, before update) {
 Set&lt;String&gt; uniqueNames = new Set&lt;String&gt;();
 if (!ProcessorControl.inFutureContext) {
  for (Account a : Trigger.new)
   uniqueNames.add(a.UniqueName__c);

  if (!uniqueNames.isEmpty())
   AccountProcessor.processAccounts(uniqueNames);
 }
}
{% endhighlight %}
<p>With this methodology, the method with the future annotation processes each Account and sets the value of the shared static variable to false before committing the records. This prevents the trigger from calling the future method once again.</p>
{% highlight js %}public class AccountProcessor {

 @future
 public static void processAccounts(Set&lt;String&gt; names) {
   // list to store the accounts to update
   List&lt;Account&gt; accountsToUpdate = new List&lt;Account&gt;();
   // iterate through the list of accounts to process
   for (Account a : [Select Id, Name From Account where UniqueName__c IN :names]) {
    // ... do your account processing
    // add the account to the list to update
    accountsToUpdate.add(a);
   }
   ProcessorControl.inFutureContext = true;
   // update the accounts
   update accountsToUpdate;
 }

}
{% endhighlight %}
<p>One of these examples should work in most cases with one caveat. With the increased usage of future method in installed packages, you may run into problems if your trigger is called from <em>another package's future method</em>. You'll again run into the "System.AsyncException: Future method cannot be called from a future method..." error. What Salesforce needs is an Apex function that determines whether the method is currently executing in a future call.</p>
<table border="0" cellspacing="5" cellpadding="5">
<tbody>
<tr>
<td><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399629/ideas-logo_mznx6v.gif"><img class="alignnone size-full wp-image-680" title="ideas-logo" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399629/ideas-logo_mznx6v.gif" alt="ideas-logo" width="80" height="60" /></a></td>
<td>
<h4>Vote for this Idea</h4>
<a href="http://ideas.salesforce.com/article/show/10093939/ISFUTURE_Function_in_APEX" target="_blank">ISFUTURE Function in APEX</a></td>
</tr>
</tbody></table>
Please Note: In the case our Account object contains a unique string field thereby making it easy to call the same code from an insert or update. Your org will probably not have this field so you will need to make some change to pass the IDs to the future method based upon whether you are doing an insert or update.
