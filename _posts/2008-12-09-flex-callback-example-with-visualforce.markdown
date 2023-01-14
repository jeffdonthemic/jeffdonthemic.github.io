---
layout: post
title:  Flex Callback Example with Visualforce
description: I was working on a somewhat complex search interface for Salesforce.com using Flex. I needed to do some communication with Apex so I threw together a little demo to outline the basic functionality of a Flex app communicating with a Visualforce page via a Javascript callback. You can run this example  on my Developer Site.    The Visualforce page that hosts the Flex app. There is a simple controller that just maintains the state of the callbackText property.  function updateHiddenValue(value, eId
date: 2008-12-09 18:00:00 +0300
image:  '/images/slugs/flex-callback-example-with-visualforce.jpg'
tags:   ["code sample", "salesforce", "visualforce", "flex"]
---
<p>I was working on a somewhat complex search interface for Salesforce.com using Flex. I needed to do some communication with Apex so I threw together a little demo to outline the basic functionality of a Flex app communicating with a Visualforce page via a Javascript callback.</p>
<p><strong>You can <a href="http://jeffdouglas-developer-edition.na5.force.com/examples/FlexCallback" target="_blank">run this example</a> on my Developer Site.</strong></p>
{% highlight js %}<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
 layout="absolute" alpha="1.0"
 width="300" height="100"
 backgroundGradientAlphas="[0,0,0,0]" backgroundColor="#F3F3EC"
 creationComplete="init()">

 <mx:Script>
  <![CDATA[
  import flash.external.ExternalInterface;

  [Bindable]
  // the name of the javascript function in the Visualforce page to be called
  private var callbackFunction:String;
  // the dom id of the text field in the Visualforce page
  private var domId:String;

  private function init():void {
   callbackFunction = this.parameters.callbackFunction;
   domId = this.parameters.domId;
  }

  public function changeListener(evt:Event): void {
   ExternalInterface.call(this.callbackFunction,evt.currentTarget.text,this.domId);
  }
  ]]>
 </mx:Script>
 <mx:TextInput x="10" y="10" width="280" change="changeListener(event)"/>
 <mx:Text x="10" y="40" text="Type some text in this box to update the value &#xa;of the box below via Javascript callback.&#xa;&#xa;" width="280" height="50"/>

</mx:Application>

{% endhighlight %}
<p>The Visualforce page that hosts the Flex app. There is a simple controller that just maintains the state of the "callbackText" property.</p>
{% highlight js %}<apex:page controller="FlexCallbackController">
  <script language="JavaScript" type="text/javascript">
  function updateHiddenValue(value, eId){
  var e = document.getElementById(eId);
  e.value = value;
  }
  </script>
 <apex:sectionHeader title="Flex / Javascript Callback Example"/>
 <apex:form >
 <apex:pageBlock id="flexBlock">

   <apex:pageBlockSection title="Flex Section">
  <apex:flash src="{!$Resource.FlexCallback}"
   width="300" height="100"
   flashvars="callbackFunction=updateHiddenValue&domId={!$Component.callbackSection.myField}" />
   </apex:pageBlockSection>

   <apex:pageBlockSection title="Javascript Callback Section" id="callbackSection">
  <apex:inputText id="myField" value="{!callbackText}" />
   </apex:pageBlockSection>

 </apex:pageBlock>
 </apex:form>
</apex:page>

{% endhighlight %}

