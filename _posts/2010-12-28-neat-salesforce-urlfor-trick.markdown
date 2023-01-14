---
layout: post
title:  Neat Salesforce URLFOR Trick
description: I was working on an app the other day and had written a custom screen allowing the user to add/edit multiple records on the same page. So in the process I wrote a Visualforce page that Overrides the standard New and Edit functions and redirects the user to this new screen. Heres my code that I thought should have worked perfectly.  The code above worked great for the New function but I was receiving the following error for the Edit function-  SObject row was retrieved via SOQL without querying t
date: 2010-12-28 21:39:27 +0300
image:  '/images/slugs/neat-salesforce-urlfor-trick.jpg'
tags:   ["salesforce", "visualforce"]
---
<p>I was working on an app the other day and had written a custom screen allowing the user to add/edit multiple records on the same page. So in the process I wrote a Visualforce page that Overrides the standard New and Edit functions and redirects the user to this new screen. Here's my code that I thought should have worked perfectly.</p>
{% highlight js %}<apex:page standardController=”MyCustomObject__c”
 action=”{!URLFOR($Page.AddEditMultipleRecords,null,
 [id=MyCustomObject__c.SomeRelatedObject__c])}”/>
{% endhighlight %}
<p>The code above worked great for the New function but I was receiving the following error for the Edit function:</p>
<blockquote>SObject row was retrieved via SOQL without querying the requested field: MyCustomObject__c.SomeRelatedObject__c</blockquote>
<p>This is actually a <a href="http://forums.sforce.com/t5/Visualforce-Development/error-referencing-field-using-standard-controller-extension/m-p/83237">well-known "problem"</a> when using a standard controller. The standard controller automatically constructs your SOQL query for you based on the fields that are referenced in your page. So simply including the field on the page, fixes the error.</p>
{% highlight js %}<apex:page standardController=”MyCustomObject__c”
 action=”{!URLFOR($Page.AddEditMultipleRecords,null,
 [id=MyCustomObject__c.SomeRelatedObject__c])}”>
 {!MyCustomObject__c.SomeRelatedObject__c}
</apex:page>
{% endhighlight %}

