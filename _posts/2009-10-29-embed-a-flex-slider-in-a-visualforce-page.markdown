---
layout: post
title:  Embed a Flex Slider in a Visualforce Page
description: I did a simple Flex callback with JavaScript about a year ago and I always wanted to follow up with this topic. Somehow I never quite found the time. This is an example of how you can create a Flex component (a horizontal slider in this case), wrap it up as a Visualforce component and then make it reusable in your Visualforce pages. This technique provides you with some great ways to add eye candy to your Visualforce pages without breaking the UI model. You can run this example on my Developer S
date: 2009-10-29 17:45:41 +0300
image:  '/images/slugs/embed-a-flex-slider-in-a-visualforce-page.jpg'
tags:   ["2009", "public"]
---
<p>I did a simple <a href="/2008/12/09/flex-callback-example-with-visualforce/" target="_blank">Flex callback with JavaScript</a> about a year ago and I always wanted to follow up with this topic. Somehow I never quite found the time. This is an example of how you can create a Flex component (a horizontal slider in this case), wrap it up as a Visualforce component and then make it reusable in your Visualforce pages. This technique provides you with some great ways to add "eye candy" to your Visualforce pages without breaking the UI model.</p>
<p><strong>You can </strong><a href="http://jeffdouglas-developer-edition.na5.force.com/examples/flex_slider_example?id=a0H70000002Klmx" target="_blank"><strong>run this example</strong></a><strong> on my Developer Site.</strong></p>
<p><a href="http://jeffdouglas-developer-edition.na5.force.com/examples/flex_slider_example?id=a0H70000002Klmx"><img class="alignnone size-full wp-image-1553" title="FlexSlider" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399473/flexslider_dsnge1.png" alt="FlexSlider" width="544" height="162" /></a></p>
<p>The Flex component is simply a wrapper around the standard HSlider control. It expects some setup values to be passed into it and then when the users moves the slider, it makes a callback to a JavaScript function in the Visualforce page to update the value in the record. It's loosely coupled so that you can pass in the values, the name of the JavaScript function to call and the ID of the DOM property to update.</p>
{% highlight js %}&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;mx:Application xmlns:mx=&quot;http://www.adobe.com/2006/mxml&quot;
	layout=&quot;absolute&quot; alpha=&quot;1.0&quot; backgroundGradientAlphas=&quot;[0,0,0,0]&quot;
	creationComplete=&quot;init()&quot;&gt;

&lt;mx:Script&gt;
	&lt;![CDATA[
		import flash.external.ExternalInterface;
		import mx.events.SliderEvent;

		// bind the variables so that can be notified of value updates
  [Bindable] private var slideInterval:int;
  [Bindable] private var minSliderValue:int;
  [Bindable] private var maxSliderValue:int;
  [Bindable] private var sliderLabels:Array = new Array();
  [Bindable] private var sliderTickValues:Array = new Array();
  [Bindable] private var callbackFunction:String;
  private var startSliderValue:int;
  private var boundDomId:String;

		// method to be called immediately after component is created
		private function init():void {

			// set some values passed in from the Visualforce page
			startSliderValue = this.parameters.startSliderValue;
			minSliderValue = this.parameters.minSliderValue;
			maxSliderValue = this.parameters.maxSliderValue;
			slideInterval = this.parameters.slideInterval;
			// add the min &amp; max as the slider labels
			sliderLabels.push(minSliderValue,maxSliderValue);
			// add the min &amp; max as the slider values
			sliderTickValues.push(minSliderValue,maxSliderValue);

			// set name of the callback javascript function
			callbackFunction = this.parameters.callbackFunction;
			// set the id of the DOM element attached to the slider so we can reference it
			boundDomId = this.parameters.boundDomId;

			// set the values initially for the component
			mySlider.tickValues = sliderTickValues;
			mySlider.labels = sliderLabels;
			mySlider.value = startSliderValue;

			// set the background color of the flex component so it matches the page
			Application.application.setStyle(&quot;backgroundColor&quot;,this.parameters.bgColor ? this.parameters.bgColor : &quot;#F3F3EC&quot;);

		}

		// notify the external interface that the slider was changed
		public function handleSliderChange(evt:SliderEvent):void {
			ExternalInterface.call(this.callbackFunction,evt.currentTarget.value,this.boundDomId);
		}
	]]&gt;
&lt;/mx:Script&gt;

&lt;mx:HSlider
	id=&quot;mySlider&quot;
	minimum=&quot;{minSliderValue}&quot;
	maximum=&quot;{maxSliderValue}&quot;
	snapInterval=&quot;{slideInterval}&quot;
	tickValues=&quot;{sliderTickValues}&quot;
	labels=&quot;{sliderLabels}&quot;
	allowTrackClick=&quot;false&quot;
	liveDragging=&quot;false&quot;
	change=&quot;handleSliderChange(event)&quot;/&gt;

&lt;/mx:Application&gt;

{% endhighlight %}
<p>So that I can reuse slider, I created a Visualforce component with it that can be embedded into other Visualforce pages. I've included a default JavaScript function but you can override it with your own in the embedded Visualforce page if needed. There are a number of attributes included which make for handy syntax coding in the browser and Eclipse.</p>
{% highlight js %}&lt;apex:component &gt;

  &lt;script language=&quot;JavaScript&quot; type=&quot;text/javascript&quot;&gt;
  function updateHiddenValue(value, eId){
  var e = document.getElementById(eId);
  e.value = value;
  }
  &lt;/script&gt;

  &lt;apex:attribute name=&quot;minSliderValue&quot; description=&quot;Minimum slider value&quot; type=&quot;Integer&quot; required=&quot;true&quot;/&gt;
  &lt;apex:attribute name=&quot;maxSliderValue&quot; description=&quot;Maximum slider value&quot; type=&quot;Integer&quot; required=&quot;true&quot;/&gt;
  &lt;apex:attribute name=&quot;startSliderValue&quot; description=&quot;Starting value of the slider&quot; type=&quot;Integer&quot; required=&quot;false&quot; /&gt;
  &lt;apex:attribute name=&quot;slideInterval&quot; description=&quot;The tick interval that the slider can be moved&quot; type=&quot;Integer&quot; default=&quot;1&quot; required=&quot;false&quot; /&gt;
  &lt;apex:attribute name=&quot;callbackFunction&quot; description=&quot;The name of the JavaScript function that is called by the Flex components and passes the bound value of the slider. By default the component uses updateHiddenField but you can override it with your own.&quot; type=&quot;String&quot; default=&quot;updateHiddenValue&quot; required=&quot;false&quot; /&gt;
  &lt;apex:attribute name=&quot;boundDomId&quot; description=&quot;The $Component id of the DOM element bound to the slider value's. The slider's change event passes the value of boundDomId back to the JavaScript function.&quot; type=&quot;String&quot; required=&quot;false&quot;/&gt;
  &lt;apex:attribute name=&quot;height&quot; description=&quot;The height of the slider&quot; type=&quot;Integer&quot; default=&quot;50&quot; required=&quot;false&quot; /&gt;
  &lt;apex:attribute name=&quot;width&quot; description=&quot;The width of the slider&quot; type=&quot;Integer&quot; default=&quot;200&quot; required=&quot;false&quot; /&gt;
  &lt;apex:attribute name=&quot;bgColor&quot; description=&quot;The background color of the flex component so it matches the page. Defaults to Salesforce gray.&quot; type=&quot;String&quot; default=&quot;#F3F3EC&quot; required=&quot;false&quot; /&gt;

  &lt;apex:flash src=&quot;{!$Resource.FlexSlider}&quot;
  height=&quot;{!height}&quot;
  width=&quot;{!width}&quot;
  flashVars=&quot;minSliderValue={!minSliderValue}&amp;maxSliderValue={!maxSliderValue}
    &amp;startSliderValue={!startSliderValue}&amp;slideInterval={!slideInterval}
    &amp;callbackFunction={!callbackFunction}&amp;boundDomId={!boundDomId}&amp;bgColor={!bgColor}&quot; /&gt;

&lt;/apex:component&gt;

{% endhighlight %}
<p>So now that you have your Flex slider built and uploaded as a Static Resource you can build your Visualforce page using your new component. If you want to pass more parameters into the component from your Visualforce page, you add them to the FlexSliderComponent attributes based up what is available from the component itself.</p>
<p>So now when you move the slider in the Flex component, it makes a callback to your Visualforce page to a JavaScript function which updates the value of the "geek factor" field in the record. When you save the record, that value is update.</p>
<p>When using the demo link above, after submitting the form you will see a white page. This is because I am lazy. You'll have to go back and reload the form to see the value change.</p>
{% highlight js %}&lt;apex:page standardController=&quot;Person__c&quot;&gt;

 &lt;apex:sectionHeader title=&quot;{!Person__c.First_Name__c} {!Person__c.Last_Name__c}&quot; subtitle=&quot;Flex Slider Example&quot;/&gt;

 &lt;apex:form id=&quot;myForm&quot;&gt;
  &lt;apex:pageBlock title=&quot;Geek Rating&quot; id=&quot;myBlock&quot; mode=&quot;edit&quot;&gt;
  &lt;apex:pageBlockButtons &gt;
    &lt;apex:commandButton value=&quot;Save&quot; action=&quot;{!save}&quot;/&gt;
    &lt;apex:commandButton value=&quot;Cancel&quot; action=&quot;{!cancel}&quot; /&gt;
  &lt;/apex:pageBlockButtons&gt;
  &lt;apex:pageMessages /&gt;

  &lt;apex:pageBlockSection id=&quot;ratings&quot; showHeader=&quot;true&quot; title=&quot;Contact Info&quot; columns=&quot;2&quot;&gt;

    &lt;apex:inputField value=&quot;{!Person__c.First_Name__c}&quot;/&gt;
    &lt;apex:pageBlockSectionItem &gt;
    &lt;apex:outputLabel value=&quot;Geek Factor Slider&quot;/&gt;
    &lt;c:FlexSliderComponent minSliderValue=&quot;0&quot; maxSliderValue=&quot;10&quot;
       startSliderValue=&quot;{!Person__c.Geek_Factor__c}&quot;
       boundDomId=&quot;{!$Component.ratings.geekfactor}&quot; /&gt;
    &lt;/apex:pageBlockSectionItem&gt;

    &lt;apex:inputField value=&quot;{!Person__c.Last_Name__c}&quot;/&gt;
    &lt;apex:inputField id=&quot;geekfactor&quot; value=&quot;{!Person__c.Geek_Factor__c}&quot; /&gt;

  &lt;/apex:pageBlockSection&gt;
  &lt;/apex:pageBlock&gt;
 &lt;/apex:form&gt;

&lt;/apex:page&gt;

{% endhighlight %}

