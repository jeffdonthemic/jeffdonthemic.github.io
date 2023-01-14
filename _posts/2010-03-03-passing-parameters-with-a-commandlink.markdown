---
layout: post
title:  Passing Parameters with a CommandLink
description: Heres a small example of how you can pass a value to another method via a command link for Salesforce.com. When the link is clicked, the setter fires for the public member nickName. The button click then calls the processLinkClick method where you can do something like process the variable further with DML statement or running a SOQL query with the value. The Visualforce page that simply displays a link that copies the contacts firstName into the public member nickName via the assignTo attribute
date: 2010-03-03 18:00:00 +0300
image:  '/images/slugs/passing-parameters-with-a-commandlink.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>Here's a small example of how you can pass a value to another method via a command link for Salesforce.com. When the link is clicked, the setter fires for the public member <em>nickName</em>. The button click then calls the processLinkClick method where you can do something like process the variable further with DML statement or running a SOQL query with the value.</p><p style="clear: both">The Visualforce page that simply displays a link that copies the contact's firstName into the public member <em>nickName</em> via the "assignTo" attribute.</p>
{% highlight js %}<apex:page standardController="Contact" extensions="CommandLinkParamController">
  <apex:form >
  <apex:commandLink value="Process Nickname" action="{!processLinkClick}">
  <apex:param name="nickName"
    value="{!contact.firstname}"
    assignTo="{!nickName}"/>
  </apex:commandLink>
  </apex:form>
</apex:page>
{% endhighlight %}
<p>The controller extension used by the Visualforce page. The processLinkClick method is called after the setters fire, performs some processing and returns a null PageReference allowing Visualforce to refresh.</p>
{% highlight js %}public with sharing class CommandLinkParamController {

  // an instance variable for the standard controller
  private ApexPages.StandardController controller {get; set;}
 // the object being referenced via url
  private Contact contact {get;set;}
  // the variable being set from the commandlink
  public String nickName {get; set;}

  // initialize the controller
  public CommandLinkParamController(ApexPages.StandardController controller) {

  //initialize the stanrdard controller
  this.controller = controller;
  // load the current record
  this.contact = (Contact)controller.getRecord();

  }

  // handle the action of the commandlink
  public PageReference processLinkClick() {
  	System.debug('nickName: '+nickName);
  	// now process the variable by doing something...
  	return null;
  }

}
{% endhighlight %}

