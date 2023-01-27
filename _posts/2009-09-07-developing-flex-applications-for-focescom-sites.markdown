---
layout: post
title:  Developing Flex Applications for Force.com Sites
description: Developing Flex applications for a Force.com Site is a little different than developing Flex applications that run inside the standard Salesforce.com UI. Since visitors are not required to log in to your Force.com Site there is no concept of an actual user. All visitors simply run as a specific profile under the Guest license. Since there is no named user for Sites, there is no associated session to pass to your Flex application. Therefore, you need to explicitly code a username and password to 
date: 2009-09-07 15:19:14 +0300
image:  '/images/slugs/developing-flex-applications-for-focescom-sites.jpg'
tags:   ["code sample", "salesforce", "visualforce", "flex"]
---
<p>Developing Flex applications for a Force.com Site is a little different than developing Flex applications that run inside the standard Salesforce.com UI. Since visitors are not required to log in to your Force.com Site there is no concept of an actual user. All visitors simply run as a specific profile under the Guest license.</p>
<p>Since there is no named user for Sites, there is no associated session to pass to your Flex application. Therefore, you need to explicitly code a username and password to log into Salesforce.com in your Flex application. This is a similar concept to authenticating via web services to Salesforce.com.</p>
<p>Here's a quick example of a Flex application running on my developer Site. <strong>You can </strong><a style="color:#80ae14;text-decoration:underline;margin:0;padding:0;" href="http://jeffdouglas-developer-edition.na5.force.com/examples/FlexValidation" target="_blank"><strong>run this demo</strong></a><strong> on my Developer Site.</strong></p>
<p>Here is the Visualforce page running in my developer Site.</p>
{% highlight js %}<apex:page>
  <apex:sectionHeader title="Required Field and Validation Example"/>
  <apex:pageBlock >

 <apex:flash src="{!$Resource.DisplayValidation}"
  width="500" height="300"/>

 </apex:pageBlock>
</apex:page>

{% endhighlight %}
<p>The Flex application specifying the username and password with which the application authenticates.</p>
{% highlight js %}<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
  backgroundGradientAlphas="[1.0, 1.0]"
  backgroundGradientColors="[#F3F3EC, #F3F3EC]"
  creationComplete="login()"
  layout="vertical"
  height="300" width="500">

 <mx:Script>
  <![CDATA[
  import com.salesforce.*;
  import com.salesforce.objects.*;
  import com.salesforce.results.*;
  import mx.controls.Alert;

  [Bindable] public var sfdc:Connection = new Connection();

  private function login():void {

  var lr:LoginRequest = new LoginRequest();
  sfdc.protocol = "http";
  sfdc.serverUrl = "http://na5.salesforce.com/services/Soap/u/14.0";
  lr.username = "YOUR_USERNAME";
  lr.password = "YOUR_PASSWORD_AND_TOKEN";
  lr.callback = new AsyncResponder(loginSuccess, loginFault);
  sfdc.login(lr);

  }

  private function submitForm():void {

   var aSo:Array = new Array();
   var so:SObject = new SObject("Contact");
   so.FirstName = firstName.text;
   so.LastName = lastName.text;
   so.Email = email.text;

   aSo.push(so);

   sfdc.create(aSo,
    new AsyncResponder(
     function (obj:Object):void {
      if (obj[0].success == true) {
       Alert.show("Created record: "+obj[0].id);
      } else {
       Alert.show(obj[0].errors[0].message)
      }
     }, sfdcFailure
    )
   );

  }

  private function loginSuccess(result:Object):void {
   contactForm.enabled = true;
  }

  private function sfdcFailure(fault:Object):void {
  Alert.show(fault.faultstring);
  }

  private function loginFault(fault:Object):void
  {
  Alert.show("Could not log into SFDC: "+fault.fault.faultString,"Login Error");
  }

  ]]>
 </mx:Script>
 <mx:Text text="To create a new Contact, Last Name is required by Salesforce.com while Email is required via a custom validation rule. &#xd;&#xd;Submit the form with different combinations to view the resulting messages returned from Salesforce.com.&#xd;" width="449"/>
 <mx:Form id="contactForm" width="100%" height="100%" enabled="false">
  <mx:FormItem label="First Name">
   <mx:TextInput id="firstName"/>
  </mx:FormItem>
  <mx:FormItem label="Last Name">
   <mx:TextInput id="lastName"/>
  </mx:FormItem>
  <mx:FormItem label="Email">
   <mx:TextInput id="email"/>
  </mx:FormItem>
  <mx:FormItem>
   <mx:Button label="Submit" click="submitForm()"/>
  </mx:FormItem>
 </mx:Form>

</mx:Application>
{% endhighlight %}

