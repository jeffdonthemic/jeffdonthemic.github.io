---
layout: post
title:  Force.com Demo with Twilio
description: Cross-posted at the Appirio Tech Blog . During Dreamforce 09 Kyle Roche  and I participated in the Developer Hackathon . We hacked-up an application using Force.com and Twilio  for inbound and outbound calling. We were only allotted two hours so we were not able to finish off the application during the hackathon. Here is the final demo with all of the major working pieces. The application has two major parts- 1. Kyles part (much harder and more glamourous) uses the Twilioforce  toolkit to make o
date: 2009-11-27 18:00:00 +0300
image:  '/images/slugs/force-demo-with-twilio.jpg'
tags:   ["2009", "public"]
---
<p>Cross-posted at the <a href="http://techblog.appirio.com/2009/11/forcecom-demo-with-twilio.html" target="_blank">Appirio Tech Blog</a>.</p>
<p>During Dreamforce 09 <a href="http://www.kyleroche.com" target="_blank">Kyle Roche</a> and I participated in the <a href="http://developer.force.com/hackathon" target="_blank">Developer Hackathon</a>. We hacked-up an application using Force.com and <a href="http://www.twilio.com" target="_blank">Twilio</a> for inbound and outbound calling. We were only allotted two hours so we were not able to finish off the application during the hackathon.</p>
<p>Here is the final demo with all of the major working pieces. The application has two major parts:</p>
<ol>
	<li>Kyle's part (much harder and more glamourous) uses the <a href="http://developer.force.com/codeshare/projectpage?id=a06300000059aEWAAY" target="_blank">Twilioforce</a> toolkit to make outbound calls from a contact in Salesforce. The user clicks the contact's phone number and the Force.com platform makes an outbound call to the contact using Twilio. Once the contact picks up Twilio then calls the phone number on the user's record and connects the two calls together.</li>
	<li>My part of the application uses Twilio with a Sites application for inbound calling. The person calls a phone number that reads a script generated from a Force.com Sites page. The greeting welcomes the person, plays an MP3 and then prompts them to records a message. After they are finished with the message it posts the results to another Sites page with attaches the message to the contact's record in Salesforce. It looks up the contact record based upon the incoming phone number.</li>
</ol><figure class="kg-card kg-embed-card"><iframe width="200" height="150" src="https://www.youtube.com/embed/fLhEY6IrTjc?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>The code for Kyle's part is somewhat similar to the <a href="http://techblog.appirio.com/2009/11/twilioforce-click-to-call-demo.html" target="_blank">Click to Call demo</a> he posted on the Appirio Tech Blog. Here's the code for my part of the application. The Twilio phone number is setup so that when you call it, it reads the script from the Answer_Call Visualforce Sites page below. Twilio reads the <Say> script and then plays the mp3 in the <Play> section. It then record a message for 5 seconds and posts the results to Record_Call.</p>
{% highlight js %}<apex:page showHeader="false" contentType="text/xml">
<Response>
  <Say>Thank you for calling the hackathon hotline. Leave a message after the monkey tone.</Say>
  <Play>http://demo.twilio.com/hellomonkey/monkey.mp3</Play>
  <Record maxLength="5" action="http://kyle-twilio-developer-edition.na7.force.com/Record_Call" />
</Response>
</apex:page>
{% endhighlight %}
<p>Most of the work in the Record_Call Visualforce page is done by the RecordCallController Apex Controller. When the page initially loads, the saveMessage() method is called in the Apex script below. The page is rendered and Twilio reads the <Say> script and then plays the recording back to the caller.</p>
{% highlight js %}<apex:page controller="RecordCallController" action="{!saveMessage}"
	showHeader="false"
	contentType="text/xml">
<Response>
  <Say>Thanks for howling {!callerName}. Take a listen to your message.</Say>
  <Play>{!recordingUrl}</Play>
  <Say>Goodbye</Say>
</Response>
</apex:page>
{% endhighlight %}
<p>The RecordCallController Apex Controller does all of the heavy lifting. The constructor grabs the URL of the recording that is posted back as well as the caller's phone number. The constructor then tries to find the contact associated with the caller's phone number. The saveMessage() method inserts a record into Twilio_Message__c custom object so that the message can be replayed back from the contact's related list. If a contact was not found by the caller's phone number, we should probably create a task to create a new contact at a later time.</p>
{% highlight js %}public with sharing class RecordCallController {

  private Contact contact {get;set;}
  private ID callerId {get;set;}
  public String recordingUrl {get;set;}
  public String callerName {get;set;}

 // initialize the controller
  public RecordCallController() {

  	try {

			recordingUrl = ApexPages.currentPage().getParameters().get('RecordingUrl');

			List<Contact> callers = [select id, name from contact where
				twilio_number__c = :ApexPages.currentPage().getParameters().get('Caller')];

			if (callers.size() > 0) {
				contact = callers.get(0);
				callerName = contact.Name;
				callerId = contact.Id;
			} else {
				callerName = 'Unknown Caller';
			}

  	} catch (Exception e) {
			System.debug('====================== exception: '+e);
  	}

  }

  public PageReference saveMessage() {

  	if (contact != null) {

	  		try {

	   Twilio_Message__c m = new Twilio_Message__c();
	   m.contact__c = contact.Id;
	   m.message__c = recordingUrl;
	   insert m;

			} catch (Exception e) {
				System.debug('====================== exception: '+e);
			}

  	} else {
  		// create a follow up task if contact was not found
  	}

  	return null;

  }

}
{% endhighlight %}

