---
layout: post
title:  Passing Parameters with a CommandButton
description: This post is a slight tweak of yesterdays post, Passing Parameters with a CommandLink  . In theory you should just be able to switch out the CommandLink component with a CommandButton component and be golden. However, not so fast. There seem to  still be a bug with the CommandButton component. Here is the Visualforce page with the CommandButton instead of the CommandLink-     As with the CommandLink, when the user clicks the button the setters should fire and then call the processButtonClick() m
date: 2010-03-04 11:13:24 +0300
image:  '/images/slugs/passing-parameters-with-a-commandbutton.jpg'
tags:   ["2010", "public"]
---
<p style="clear: both">This post is a slight tweak of yesterday's post, <a href="/2010/03/03/passing-parameters-with-a-commandlink/" target="_blank">Passing Parameters with a CommandLink</a>. In theory you should just be able to switch out the CommandLink component with a CommandButton component and be golden. However, not so fast. There seem to <em><strong>still</strong></em> be a bug with the CommandButton component.</p><p style="clear: both">Here is the Visualforce page with the CommandButton instead of the CommandLink:</p><p style="clear: both">
{% highlight js %}<apex:page standardController="Contact" extensions="CommandButtonParamController">
  <apex:form >

  <apex:commandButton value="Process Nickname" action="{!processButtonClick}">
  <apex:param name="nickName"
    value="{!contact.firstname}"
    assignTo="{!nickName}"/>
  </apex:commandButton>

  </apex:form>
</apex:page>
{% endhighlight %}
</p><p style="clear: both">As with the CommandLink, when the user clicks the button the setters should fire and then call the processButtonClick() method to allow further publishing. <strong>However, the setter for </strong><em><strong>nickName</strong></em><strong> is never called!</strong></p><p style="clear: both">
{% highlight js %}public with sharing class CommandButtonParamController {

  // an instance varaible for the standard controller
  private ApexPages.StandardController controller {get; set;}
 // the object being referenced via url
  private Contact contact {get;set;}
  // the variable being set from the commandbutton
  public String nickName {
  	get;
  	// *** setter is NOT being called ***
  	set {
  		nickName = value;
  		System.debug('value: '+value);
  	}
  }

  // initialize the controller
  public CommandButtonParamController(ApexPages.StandardController controller) {

  //initialize the stanrdard controller
  this.controller = controller;
  // load the current record
  this.contact = (Contact)controller.getRecord();

  }

  // handle the action of the commandButton
  public PageReference processButtonClick() {
  	System.debug('nickName: '+nickName);
  	// now process the variable by doing something...
  	return null;
  }

}
{% endhighlight %}
</p><p style="clear: both"><a href="http://twitter.com/weesildotn/"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328732/weesildotn_wh5nt4.jpg" alt="" title="weesildotn" width="73" height="73" class="alignleft size-full wp-image-2295" /></a><a href="http://twitter.com/weesildotn/">Wes Nolte</a> has done a great job <a href="http://developinthecloud.wordpress.com/2009/06/12/salesforce-bugs-you/" target="_blank">on his blog</a> and the <a href="http://community.salesforce.com/sforce/board/message?message.uid=72192" target="_blank">Salesforce.com message boards</a> pointing out the problem and workarounds. A popular option is using the CommandLink but styling it to look like a CommandButton.</p><p style="clear: both">You <strong>can</strong> make the CommandButton function as advertised if you use a rerender attribute and hidden pageBlock component. If you run the Visualforce page below with these modifications the setter will actually fire and set the value of nickName correctly.</p><p style="clear: both">
{% highlight js %}<apex:page standardController="Contact" extensions="CommandButtonParamController">
  <apex:form >

  <apex:commandButton value="Process Nickname" action="{!processButtonClick}" rerender="hiddenBlock">
  <apex:param name="nickName"
    value="{!contact.firstname}"
    assignTo="{!nickName}"/>
  </apex:commandButton>

  <apex:pageBlock id="hiddenBlock" rendered="false"></apex:pageBlock>

  </apex:form>
</apex:page>
{% endhighlight %}
</p>
