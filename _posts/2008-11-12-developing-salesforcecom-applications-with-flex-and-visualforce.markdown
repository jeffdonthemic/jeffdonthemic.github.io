---
layout: post
title:  Developing Salesforce.com Applications with Flex and Visualforce
description: I receive a number of inquiries as to the best way to develop Flex apps for multiple Salesforce.com orgs. My methodology might not be the best but it certainly gets the job done by allowing me to easiy develop locally, test on one of our 10+ sandboxes and deploy to production. Since the code never lies, here is the skeleton that I essentially use for each new project.                          To call this SWF from your Visualforce page, you will need to upload it to your org as a Static Resource
date: 2008-11-12 22:59:57 +0300
image:  '/images/slugs/developing-salesforcecom-applications-with-flex-and-visualforce.jpg'
tags:   ["2008", "public"]
---
<p>I receive a number of inquiries as to the best way to develop Flex apps for multiple Salesforce.com orgs. My methodology might not be the best but it certainly gets the job done by allowing me to easiy develop locally, test on one of our 10+ sandboxes and deploy to production.</p>
<p>Since the code never lies, here is the skeleton that I essentially use for each new project.</p>
{% highlight js %}<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute" width="600" height="300"
    backgroundGradientAlphas="[1.0, 1.0]" backgroundGradientColors="[#FFFFFF, #FFFFFF]"
    creationComplete="init()">

    <mx:Script>
        <![CDATA[
        import com.salesforce.*;
        import com.salesforce.objects.*;
        import com.salesforce.results.*;   

        [Bindable] private var sfdc:Connection = new Connection();
        [Bindable] private var isLoggedIn:Boolean = false;
        [Bindable]private var userId:String;

        //********* DETERMINES DEV/PRD *********//
        private var isDev:Boolean = true;
        //*************************************//   

        private function init():void {
            login();
            if (isDev) {
                // dev/local no flashvars passed to movie
                if (Application.application.parameters.userId == null) {
                    userId = "005600000000000"; // default to my user
                // sandbox - flashvars passed to movie
                } else {
                    userId = Application.application.parameters.userId;
                }
            // production - flashvars passed to movie
            } else {
                userId = Application.application.parameters.userId;
            }
        } 

        private function login():void {

            var lr:LoginRequest = new LoginRequest();

            // hard code values for dev/local
            if (this.parameters.server_url == null) {

                sfdc.serverUrl = "https://test.salesforce.com/services/Soap/u/13.0";
                lr.username = "your_username";
                lr.password = "your_password";                       

            } else {

                // sandbox
                if (isDev) {

                    lr.server_url = this.parameters.server_url;
                    lr.session_id = this.parameters.session_id;

                // production
                } else {

                    lr.server_url = this.parameters.server_url;
                    lr.session_id = this.parameters.session_id;
                }
            }

            lr.callback = new AsyncResponder(loginSuccess, loginFault);
            sfdc.login(lr);       

        }

        private function loginSuccess(result:Object):void
        {
            isLoggedIn = true;
            // start calling methods...
        }

        private function loginFault(fault:Object):void
        {
            mx.controls.Alert.show("Could not log into SFDC: "+fault.fault.faultString,"Login Error");
        }
        ]]>
    </mx:Script>

    <mx:TextArea id="txtLog" left="5" right="5" top="5" bottom="5"/>

</mx:Application>

{% endhighlight %}
<p>To call this SWF from your Visualforce page, you will need to upload it to your org as a Static Resource. You can then call the SWF in your Visualforce page with the following code. Notice that the <strong><em>userId</em></strong> parameter is being passed via the flashvars and then picked up in the <em><strong>init() </strong></em>method. It's only here as an example on how you can pass variables to the SWF and is not actually needed for this demo.</p>
<p>The login method is very interesting as it provides the flexibility for running in different orgs. When the SWF runs locally, the Flex Toolkit logs into the endpoint with the specified username and password. When you upload the SWF to your org and run it from the Visualforce page below, the flashvars attribute passes the current user's session_id and server_url to the SWF allowing it to login and make call back as the authenticated user.</p>
<p>Note: you will want to remove the hardcoded username and password before uplaoding the SWF to your production org as the SWF can be decompiled, thus exposing your credentials.</p>
{% highlight js %}<apex:page >
	<apex:flash src="{!$Resource.Test}"
		width="600" height="300"
		flashvars="userId={!$User.Id}&session_id={!$Api.Session_ID}&server_url={!$Api.Partner_Server_URL_130}" />
</apex:page>

{% endhighlight %}

