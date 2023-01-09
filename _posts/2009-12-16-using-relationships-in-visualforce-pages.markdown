---
layout: post
title:  Using Relationships in Visualforce Pages
description: The topic of relationships in Visualforce pages came up on the Salesforce developer discussion boards the other day so I thought Id throw something together to expand on the topic. Lets say you want to print off a Sales Order or Purchase Order as a PDF. You can use the parent and child relationships inherent in Salesforce to display this information using the standard Apex Controller. (Its amazing some of the things that you can create in Visualforce without the use of a custom controller or con
date: 2009-12-16 20:10:11 +0300
image:  '/images/slugs/using-relationships-in-visualforce-pages.jpg'
tags:   ["2009", "public"]
---
<p>The topic of relationships in Visualforce pages came up on the Salesforce developer discussion boards the other day so I thought I'd throw something together to expand on the topic.</p>
<p>Let's say you want to print off a Sales Order or Purchase Order as a PDF. You can use the parent and child relationships inherent in Salesforce to display this information using the standard Apex Controller. (It's amazing some of the things that you can create in Visualforce without the use of a custom controller or controller extension!)</p>
<p><strong>You can </strong><a href="http://jeffdouglas-developer-edition.na5.force.com/examples/OpportunityPDF?id=0017000000LgRMV" target="_blank"><strong>run this example</strong></a><strong> on my Developer Site. It will open a PDF so watch for any download.</strong></p>
<p>Originally I was going to display an Opportunity and its LineItems but they are not accessible in Sites so I opted to display an Account and its Contacts. The renderAs attribute specifies that the page is to be generated as a PDF. The account names traverse the parent relationships to display the various names associated with them. We then display all off the associate contacts by iterating over the collection (account.contacts <-- notice the "s").</p>
{% highlight js %}<apex:page standardController="Account" showHeader="false" renderAs="pdf">

	<img src="{!URLFOR($Resource.AppirioLogo)}" border="0"/><p/>

	Name: {!account.name}<br/>
	Regional Parent: {!account.parent.name}<br/>
	Corp Parent: {!account.parent.parent.name}<p/>

  <table width="100%" cellpadding="2" cellspacing="2">
  <tr>
  <td><b>First</b></td>
  <td><b>Last</b></td>
  <td><b>Email</b></td>
  </tr>
  <apex:repeat value="{!account.contacts}" var="contact">
  <tr>
  	<td>{!contact.firstname}</td>
  	<td>{!contact.lastname}</td>
  	<td>{!contact.email}</td>
  </tr>
  </apex:repeat>
  </table>

</apex:page>
{% endhighlight %}

