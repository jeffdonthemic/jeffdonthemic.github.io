---
layout: post
title:  ActionSupport Example using Facets and JavaScript
description: You can make your UI much easier on your users by giving them clues on what is taking place when they click buttons, enter text or choose items in a picklist. This example shows how you can notify a user that something is taking place in the background when you are performing actions asynchronously. For the sake of example, it uses both facets and JavaScript. You can run this example on my Developer Site. In this example the user simply enters their name in the text box. In the code below weve a
date: 2009-11-06 17:35:22 +0300
image:  '/images/slugs/actionsupport-example-using-facets-and-javascript.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>You can make your UI much easier on your users by giving them clues on what is taking place when they click buttons, enter text or choose items in a picklist. This example shows how you can notify a user that something is taking place in the background when you are performing actions asynchronously. For the sake of example, it uses both facets and JavaScript.</p>
<p><strong>You can </strong><a href="http://jeffdouglas-developer-edition.na5.force.com/examples/ActionSupportExample" target="_blank"><strong>run this example</strong></a><strong> on my Developer Site.</strong></p>
<p>In this example the user simply enters their name in the text box. In the code below we've added an actionSupport component to the inputText component. This allows us to invoke a method (specified in the action attribute) in the controller as the result of a JavaScript event.</p>
<p>The attributes for the actionSupport component indicate:</p>
<blockquote><strong>action</strong> - the method to be invoked in the controller
<p><strong>event</strong> - the JavaScript event that invokes the method</p>
<p><strong>reRender</strong> - the IDs of the components that are redrawn as a result of the AJAX update request returned from the controller</p>
<p><strong>status</strong> - the ID of the component that displays the status of the AJAX update request</blockquote><br>
So when the user enters their name and removes focus from the text box, the JavaScript event fires and invokes the method in the controller. The status component is also invoked to display the messages to the user. In this case the start attribute calls the JavaScript start(); method which dynamically modifies HTML elements on the page.</p>
<p>When the AJAX call returns from the controller, the actionStatus component specifies that the stop facet should be displayed as well as the stop(); JavaScript method. This modifies HTML elements and displays messages to the user. The actionSupport component reRenders the pageMessage and thankyou outputPanels so that our new messages from the controller display properly.</p>
{% highlight js %}<apex:page controller="ActionSupportExampleController">
 
 <script type="text/javascript">
  function start() {
 document.getElementById("processingStatus").innerHTML = "Process started...";
 document.getElementById("thankyouDiv").innerHTML = "";
  }
  function stop() {
 document.getElementById("processingStatus").innerHTML = "";
 document.getElementById("thankyouDiv").innerHTML = "Processing complete";
  }
 </script>
 
 <apex:outputPanel id="pageMessage">
  <PageMessages />
 </apex:outputPanel>
 
 <apex:actionStatus id="status" onStart="start();" onStop="stop,stop();">
  <apex:facet name="stop">
 <h1>Idle... waiting...</h1>
  </apex:facet>
 </apex:actionStatus>
 
 <div id="processingStatus"></div>
 
 <apex:form >
 
  Please enter your name and click off of the text box:
  <apex:inputText value="{!yourName}" >
 <apex:actionSupport action="{!processName}"
  event="onblur" reRender="pageMessage,thankyou" status="status"/>
  </apex:inputText>
 
 </apex:form>
 
 <div id="thankyouDiv"></div>
 
 <apex:outputPanel id="thankyou">
  <apex:outputText value="{!thankYouMsg}"/>
 </apex:outputPanel>
 
</apex:page>
{% endhighlight %}
<p>The controller for this example is fairly simple. The constructor simply initializes the value of counter to 0 when initially loaded. Each time that the user removes focus from the textbox, the processName method is called. This method increments the counter and then hands off some text to the addThankYou and addPageMessage methods. These methods construct the text for the messages displayed to the user.</p>
{% highlight js %}public class ActionSupportExampleController {
 
 public String thankYouMsg {get;set;}
 public String yourName {get;set;}
 private Integer counter {get;set;}
 
 public ActionSupportExampleController() {
  counter = 0;
 }
 
 public PageReference processName() {
  counter += 1;
  addThankYou(yourName);
  addPageMessage('Your name is: '+ yourName);
  return null;
 }
 
 private void addPageMessage(String t) {
  ApexPages.addMessage(new ApexPages.Message(
 ApexPages.Severity.INFO, t));
 }
 
 private void addThankYou(String t) {
  thankYouMsg = 'Thanks ' + t + '. You are a peach. You have loaded this page ' +
 counter + ' times.';
 }
 
}
{% endhighlight %}
<p>FYI... not every Visualforce component support partial page refreshes. If you are using one that is not supported, you can wrap it in an outputPanel component so that it can be reRendered.</p>

