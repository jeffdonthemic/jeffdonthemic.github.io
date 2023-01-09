---
layout: post
title:  Create a New Record in Force.com Sites
description: So someone asked me yesterday for some code to allow external users to create contact records in Salesforce.com. They needed a simple form where people could enter the details and once submitted receive a confirmation of what information was entered. Heres what the final page that was developed looks like. You can  try the code out on my developer site  to see how it runs. If this solution was meant to run inside the Salesforce.com UI, you would simply need a single Visualforce page that utilize
date: 2010-04-27 11:00:09 +0300
image:  '/images/slugs/create-a-new-record-in-force-com-sites.jpg'
tags:   ["2010", "public"]
---
<p style="clear: both">So someone asked me yesterday for some code to allow external users to create contact records in Salesforce.com. They needed a simple form where people could enter the details and once submitted receive a confirmation of what information was entered. Here's what the final page that was developed looks like. You can <a href="http://jeffdouglas-developer-edition.na5.force.com/examples /Contact_Create" target="_blank">try the code out on my developer site</a> to see how it runs.</p><p style="clear: both"><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/04/conact-create.png" class="image-link" rel="lightbox"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030296/t5me97exe0rklcesccn8.png" height="240" align="left" width="530" style=" display: inline; float: left; margin: 0 10px 10px 0;" /></a><br style="clear: both" />If this solution was meant to run inside the Salesforce.com UI, you would simply need a single Visualforce page that utilizes the standard controller for Contact. Once submitted, the standard controller would insert the new record and relocate the user to the display page for the new record. </p><p style="clear: both">However, since this is an external page we have to do a little more work. We need two Visualforce pages (one for the form and one for the confirmation page) and a custom controller to submit the new contact record and show the user the confirmation page. You'll also need to set up a new Force.com Site and add the two new Visualforce pages to the site so they are accessible externally. You'll also need to modify the Public Access Settings for the site to allow Read access to the Contact object.</p><p style="clear: both">Your code should look like the following:</p><p style="clear: both"><strong>Contact_Create Visualforce Page</strong></p>
{% highlight js %}<apex:page controller="ContactCreateController">
 <apex:sectionHeader title="Visualforce Example" subtitle="Create a Contact"/>

 <apex:form >
  <apex:pageMessages /> <!-- this is where the error messages will appear -->
  <apex:pageBlock title="Contact Info">
  
 <apex:pageBlockButtons >
  <apex:commandButton action="{!save}" value="Save"/>
 </apex:pageBlockButtons>
 
 <apex:pageBlockSection showHeader="false" columns="2">
  <apex:inputField value="{!contact.firstName}" />
  <apex:inputField value="{!contact.lastName}" />
  <apex:inputField value="{!contact.email}" />
 </apex:pageBlockSection>

  </apex:pageBlock>
 </apex:form>
</apex:page>
{% endhighlight %}
<p><strong>Contact_Create_Thankyou Visualforce Page</strong></p>
{% highlight js %}<apex:page controller="ContactCreateController">
 <apex:sectionHeader title="Visualforce Example" subtitle="Thank You"/>

 <apex:form >
  <apex:pageBlock title="Contact Info">
   
 <apex:pageBlockSection showHeader="false" columns="2">
  <apex:outputField value="{!contact.firstName}" />
  <apex:outputField value="{!contact.lastName}" />
  <apex:outputField value="{!contact.email}" />
 </apex:pageBlockSection>

  </apex:pageBlock>
 </apex:form>
</apex:page>
{% endhighlight %}
<p><strong>Apex Controller</strong></p>
{% highlight js %}public with sharing class ContactCreateController {

 // the contact record you are adding values to
 public Contact contact {
  get {
 if (contact == null)
  contact = new Contact();
 return contact;
  }
  set;
 }

 public ContactCreateController() {
  // blank constructor
 }
 
 // save button is clicked
 public PageReference save() {
 
  try {
 insert contact; // inserts the new record into the database
  } catch (DMLException e) {
 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error creating new contact.'));
 return null;
  }
  
  // if successfully inserted new contact, then displays the thank you page.
  return Page.Contact_Create_Thankyou;
 }

}
{% endhighlight %}

