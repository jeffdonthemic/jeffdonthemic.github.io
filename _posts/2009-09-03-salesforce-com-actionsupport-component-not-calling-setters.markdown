---
layout: post
title:  Salesforce.com ActionSupport Component Not Calling Setters
description: I ran into what I thought was a bug yesterday with the actionSupport Visualforce component but it turned out to be the intended functionality, according to Salesforce.com. Im not sure if I agree as I can envision a number of use cases where it prohibits functionality. The actionSupport component adds AJAX support to another component, allowing the component to be refreshed asynchronously by the server when a particular event occurs, such as a button click or mouseover.   So lets say we build the
date: 2009-09-03 15:18:32 +0300
image:  '/images/slugs/salesforce-com-actionsupport-component-not-calling-setters.jpg'
tags:   ["2009", "public"]
---
<p>I ran into what I thought was a bug yesterday with the actionSupport Visualforce component but it turned out to be the intended functionality, according to Salesforce.com. I'm not sure if I agree as I can envision a number of use cases where it prohibits functionality.</p>
<p>The <a href="http://www.salesforce.com/us/developer/docs/pages/Content/pages_compref_actionSupport.htm" target="_blank">actionSupport component</a> adds AJAX support to another component, allowing the component to be refreshed asynchronously by the server when a particular event occurs, such as a button click or mouseover.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399507/actionsupport_s4iazh.png"><img class="alignnone size-full wp-image-1186" title="actionsupport" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399507/actionsupport_s4iazh.png" alt="actionsupport" width="435" height="332" /></a></p>
<p>So let's say we build the Visualforce page above. The page allows us to choose a contact from a picklist and the form fields populate with the first name, last name and email address from the contact. There are validation rules on all three fields that requires us to enter data.</p>
<p>Here is a code snippet for the Visualforce page with the actionSupport component. When the user changes the value of the picklist, the showContact method is fired and the fields are refreshed with the corresponding data.</p>
{% highlight js %} <apex:pageBlockSectionItem >
  <apex:outputText value="Choose Contact"/>
  <apex:selectList value="{!contactId}" id="theContactId" size="1">
  <apex:selectOptions value="{!contacts}"/>
  <apex:actionSupport event="onchange" rerender="mainBlock" action="{!showContact}"/>
  </apex:selectList>
</apex:pageBlockSectionItem>
{% endhighlight %}
<p>So this works great with one exception. Suppose you have one contact that does not have an email address (in reality the email address should have a value as it's required, but work with me here). When that contact is loaded into the form with a blank email address and the user selects a different contact from the picklist, the validation rule will fire prompting you to enter an email address to continue. Fortunately, Salesforce.com has provided an attribute on the actionSupport component called <strong>immediate</strong> to allow you to bypass the validation rules:</p>
<blockquote>Immediate - A Boolean value that specifies whether the action associated with this component should happen immediately, without processing any validation rules associated with the fields on the page. If set to true, the action happens immediately and validation rules are skipped. If not specified, this value defaults to false.</blockquote>
So now we change our Visualforce page to skip the validation rules when the user changes the picklist value:
{% highlight js %} <apex:pageBlockSectionItem >
  <apex:outputText value="Choose Contact"/>
  <apex:selectList value="{!contactId}" id="theContactId" size="1">
  <apex:selectOptions value="{!contacts}"/>
  <apex:actionSupport immediate="true" event="onchange" rerender="mainBlock" action="{!showContact}"/>
  </apex:selectList>
</apex:pageBlockSectionItem>
{% endhighlight %}
<p>So now here's the real problem. When using the immediate attribute not only does actionSupport skip the validation rules but it also <strong>skips all setter methods</strong>. Our code never receives the Id that our user chose so our SOQL query will never execute correctly.</p>
<p>Andrew Waite, Product Manager - salesforce.com, <a href="http://community.salesforce.com/sforce/board/message?board.id=Visualforce&thread.id=2209" target="_blank">in this forum post</a> states that this is the intended functionality. I ran into two situations yesterday where I needed the actionSupport to skip validation rules <strong>and</strong> fire setters to function correctly. I think this component should be modified to fire setters.</p>
<p><a href="http://ideas.salesforce.com/article/show/10098005/ActionSupport_Visualforce_Component_Should_Run_Setter_Methods" target="_blank">Here's the Idea</a> so please vote early and often.</p>

