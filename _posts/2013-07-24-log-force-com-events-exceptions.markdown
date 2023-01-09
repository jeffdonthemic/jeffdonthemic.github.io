---
layout: post
title:  Log Force.com Events & Exceptions
description: Logging in Force.com can be somewhat of a challenge. Since theres no log file you can write to, we need to develop another mechanism to record events and exceptions that we can inspect later. Sending emails with exceptions information is fine, but it may become overwhelming. So lets implement a Custom Object called Log__c that we can dump events and exception info into. We can then run reports, implement workflow, write triggers and do all kinds of cool stuff for this object. Weve been using thi
date: 2013-07-24 10:43:22 +0300
image:  '/images/slugs/log-force-com-events-exceptions.jpg'
tags:   ["2013", "public"]
---
<p>Logging in Force.com can be somewhat of a challenge. Since there's no log file you can write to, we need to develop another mechanism to record events and exceptions that we can inspect later. Sending emails with exceptions information is fine, but it may become overwhelming. So let's implement a Custom Object called <code>Log__c</code> that we can dump events and exception info into. We can then run reports, implement workflow, write triggers and do all kinds of cool stuff for this object. We've been using this methodology (sparingly for certain situations) for a couple of years at <a href="http://www.cloudspokes.com" target="_blank">CloudSpokes</a> and it's worked quite well for us.</p>
<p>Disclaimer: This may not work for all use cases as exceptions will cause all commits to rollback, including your log inserts. Another route may be to insert these log records asynchronously (using @future) but you need to ensure that this method is not being called from another asynchronous method. Also you may bump into some governor limits so <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_annotation_future.htm" target="_blank">check the docs</a> for specifics.</p>
<p>So, first create a Custom Object (<code>Log__c</code>) to hold all of your entries.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327708/log__c_fymz24.png" alt="" ></p>
<p>I added a lookup relationship to our Challenge object as I'm just recording events from these records. The Class__c field simply allows me to record from which Apex class the event or exception occurred. Message__c is the actual message being logged while Priority__c is essentially the severity of the message. You can pass values such as <code>INFO</code>, <code>DEBUG</code>, <code>WARNING</code>, <code>ERROR</code> or <code>FATAL</code> and then write workflow notifications based upon this severity.</p>
<p>So here's a little helper class that you can call from your Apex code to make logging easier. You essentially pass it the info you want to log and it will do the rest for you. You may want to add some exception and bulk handling. In our case at CloudSpokes we ensure that these transactions are not occurring in bulk. You may want to write a log method that accepts an Array of LogMessages or something similar.</p>
{% highlight js %}public class Logger {

 public static String INFO = 'INFO';
 public static String DEBUG = 'DEBUG';
 public static String WARNING = 'WARNING';
 public static String ERROR = 'ERROR';
 public static String FATAL = 'FATAL';

 // insert a generic log entry 
 public static void log(String priority, String className, String message) { 
  insert (new Log__c(priority__c=priority,class__c=className,
 message__c=message));
 }
 
 // insert a log entry for a specific challenge record
 public static void log(String priority, String className, String message, ID challengeId) { 
  insert (new Log__c(priority__c=priority,class__c=className,
 message__c=message,challenge__c=challengeId));
 }

 // test method
 public static testMethod void testLogger() {
  Test.startTest();
  Logger.log(Logger.INFO, 'TestClassName', 'My Test Message');
  Test.stopTest();
  System.assertEquals(1,[select count() from Log__c where class__c = 'TestClassName']);
  // make sure the log info was written correctly
  Log__c log = [select Priority__c, Class__c, Message__c from Log__c where class__c = 'TestClassName'];
  System.assertEquals(Logger.INFO,log.Priority__c);
  System.assertEquals('TestClassName',log.Class__c);
  System.assertEquals('My Test Message',log.Message__c);
 }

}
{% endhighlight %}
<p>So now in your code you can do something like the following to log an event:</p>
{% highlight js %}public virtual Decimal scoreParticipant(String membername) { 
 Logger.log(Logger.INFO, 'ChallengeBase', 
  'Scoring participant: ' + membername, 
  this.challengeId);
 // keep performing awesome Apex code
}
{% endhighlight %}

