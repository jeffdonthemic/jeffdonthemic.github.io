---
layout: post
title:  Locking sObject Records
description: I dont see this discussed often, but Salesforce.com has the ability to lock sObject records while they are being updated to prevent threading problems and race conditions. To lock records, simply use the FOR UPDATE keywords in your SOQL statements. You do not have to manually commit the records so if your Apex script finishes successfully the changes are automatically committed to the database and the locks are released. If your Apex script fails, any database changes are rolled back and the loc
date: 2010-03-09 12:30:34 +0300
image:  '/images/slugs/locking-sobject-records.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>I don't see this discussed often, but Salesforce.com has the ability to lock sObject records while they are being updated to prevent threading problems and race conditions.</p><p style="clear: both">To lock records, simply use the <strong>FOR UPDATE</strong> keywords in your SOQL statements. You do not have to manually commit the records so if your Apex script finishes successfully the changes are automatically committed to the database and the locks are released. If your Apex script fails, any database changes are rolled back and the locks are also released.</p>
{% highlight js %}for (List<opportunity> ops : [select id from Opportunity
  where stagename = 'Closed Lost' for update]) {
	// process the records and issue DML
}
{% endhighlight %}
<p style="clear: both">The Apex runtime engine locks not only the parent sObject record but all child records as well. So if you lock an Opportunity sObject all of its Opportunity Line Items will be locked as well. Other users will be able to read these records but not make changes to them while the lock is in place.</p><p style="clear: both">If your record is locked and another thread tries to commit changes, the platform will retry for roughly 5 -10 seconds before failing with a "Resource Unavailable" error. For end users, I <em>believe</em> if they try to save a locked record from the Salesforce.com UI, they will receive an error message stating that the record has been changed and that they should reload the page. I can't confirm but I've seen this in the past.</p><br class="final-break" style="clear: both" />
