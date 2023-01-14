---
layout: post
title:  Displaying Validation Messages with Flex and Salesforce.com
description: I created a small Flex application that outlines how you can return messages (required fields, validation errors, etc) from Salesforce.com. The code is fairly basic and checks the return objects success flag and display error message depending on the value of the flag. You can run this demo  on my Developer Site.  	  	 	 	 		 			 		 		 			 		 		 			 		 		 			 		 	  
date: 2009-08-02 16:00:00 +0300
image:  '/images/slugs/displaying-validation-messages-with-flex-and-salesforce-com.jpg'
tags:   ["code sample", "salesforce", "flex"]
---
<p>I created a small Flex application that outlines how you can return messages (required fields, validation errors, etc) from Salesforce.com. The code is fairly basic and checks the return object's success flag and display error message depending on the value of the flag.</p>
<p><strong>You can </strong><a style="color:#80ae14;text-decoration:underline;margin:0;padding:0;" href="http://jeffdouglas-developer-edition.na5.force.com/examples/FlexValidation" target="_blank"><strong>run this demo</strong></a><strong> on my Developer Site.</strong></p>
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

