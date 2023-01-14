---
layout: post
title:  Passing Values to JavaScript from Apex Controller Method
description: Im working on a port of an existing Java app to Salesforce.com and I ran into a Visualforce page that gave me some problems. The current JSP page allows the user to fill out a form, submit a new record to the database and then pop-up a new window to show some results while keeping the users on the same page with the form. This is actually somewhat difficult to do with Apex and Visualforce. I searched the message boards but couldnt find anything comparable. LuckilyWes Nolte  came to the rescue wi
date: 2011-01-17 18:00:00 +0300
image:  '/images/slugs/passing-values-to-javascript-from-apex-controller-method.jpg'
tags:   ["code sample", "salesforce"]
---
<p>I'm working on a port of an existing Java app to Salesforce.com and I ran into a Visualforce page that gave me some problems. The current JSP page allows the user to fill out a form, submit a new record to the database and then pop-up a new window to show some results while keeping the users on the same page with the form.</p>
<p>This is actually somewhat difficult to do with Apex and Visualforce. I searched the message boards but couldn't find anything comparable. Luckily <a href="http://th3silverlining.com">Wes Nolte</a> came to the rescue with his mad JavaScript skillz to point me in the right direction.</p>
<p>Typically you save a record with a commandButton that invokes a method in the Controller specified by the action attribute. However, this method returns a PageReference which, if not null, will redirect the user to a new page. However, I wanted the Controller method to notify the Visualforce page that the insert was successful and then pop open a new window via JavaScript that loaded another page.</p>
<p>Here's something similar to what I came up with.<strong> <a href="http://jeffdouglas-developer-edition.na5.force.com/examples/ActionFunctionDemo">You can run this example on my developer site.</a></strong></p>
<p><strong>ActionFunctionDemoController</strong></p>
<p>The Controller exposes a public 'message' attribute that is used by the Visualforce page to display the results of the submission. The <strong>save()</strong> method inserts the record and set the value of the 'message' attribute if no error. If an error occurred, it set the error message to the 'message' attribute instead.</p>
{% highlight js %}public with sharing class ActionFunctionDemoController {
 
 public Cat3__c cat {get;set;}
 public String message {get;set;}
 
 public ActionFunctionDemoController() {
  cat = new Cat3__c(name='Some Value',Cat2__c='a0B70000002PuK2EAK');
  message = 'Try again!!'; // initial message.
 }
 
 public PageReference save() { 
  try {
 insert cat;
 message = 'Insert successful! -- ' + cat.id;
  } catch (Exception e) {
 ApexPages.addMessages(e);
 message = 'Whoops! An error occurred -- ' + e.getMessage(); 
  }
  return null;
 }

}
{% endhighlight %}
<p><strong>ActionFunctionDemo</strong></p>
<p>The Visualforce page has a number of interesting aspects. First it defines an actionFunction which allows us to invoke a controller action method from JavaScript. The component's name is <strong>doControllerSave</strong> and it calls the <strong>save()</strong> method in the Controller. Instead of using the action attribute, the commandButton component instead uses the onclick method to call the <strong>doControllerSave</strong> JavaScript method (which in turn calls <strong>save()</strong> action method in the Controller) and then specifies that the <strong>onControllerReturn</strong> JavaScript method should be called when the Ajax request completes on the client. The magic here is that we wrap the entire <strong>onControllerReturn</strong> function in an outputPanel which is rerendered by the ActionFunction. Without the outputPanel this entire operation doesn't work at all.</p>
{% highlight js %}<apex:page controller="ActionFunctionDemoController">
 <apex:sectionHeader title="Action Function Demo" 
 subtitle="Save a New Record"/>

 <apex:form >
 
 <apex:outputPanel id="jspanel"> 
 <script> 
 function onControllerReturn() {
  alert('{!message}')
 }
 </script>
 </apex:outputPanel>
 
 <apex:actionFunction name="doControllerSave" action="{!save}" 
  rerender="jspanel"/>
 
 <apex:pageBlock id="blockSection">

 <apex:pageBlockButtons >
  <apex:commandButton onclick="doControllerSave();" 
 oncomplete="onControllerReturn()" value="Save"/>
 </apex:pageBlockButtons>
 <apex:pageMessages />

 <apex:pageBlockSection columns="1">
  <apex:inputField value="{!cat.name}"/> 
  <apex:inputField value="{!cat.Cat2__c}"/> 
 </apex:pageBlockSection>

 </apex:pageBlock>
 </apex:form>
 
 Submit the form to successfully create a record. To generate an error, 
 remove the value for 'Cat2' and save.

</apex:page>
{% endhighlight %}

