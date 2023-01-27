---
layout: post
title:  My Favorite Winter '10 Features
description:  For those that dont have time to weed through all 124 pages of the Winter 10 Release Notes , Ive pulled out a few of my favorites for your viewing pleasure-  Enhanced Profile Management Administrators can create lists of profiles and use them to compare profile settings, print lists of profiles, and make mass updates across multiple profiles. Be still my beating heart! Profile management on large orgs is (was?) such a nightmare. Web to Lead Campaign Member Creation Update Salesforce.com will ev
date: 2009-09-11 11:45:38 +0300
image:  '/images/slugs/my-favorite-winter-10-features.jpg'
tags:   ["salesforce"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399506/winter10_logo_sxbcom.png"><img class="alignleft size-full wp-image-1242" style="padding-right:10px;" title="winter10_logo" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399506/winter10_logo_sxbcom.png" alt="winter10_logo" width="208" height="159" /></a>For those that don't have time to weed through all 124 pages of the <a href="http://na1.salesforce.com/help/doc/en/salesforce_winter10_release_notes.pdf" target="_blank">Winter '10 Release Notes</a>, I've pulled out a few of my favorites for your viewing pleasure:</p>
<p><strong>Enhanced Profile Management</strong><br>
Administrators can create lists of profiles and use them to compare profile settings, print lists of profiles, and make mass updates across multiple profiles. Be still my beating heart! Profile management on large orgs is (was?) such a nightmare.</p>
<p><strong>Web to Lead Campaign Member Creation Update</strong><br>
Salesforce.com will evaluate triggers, validation rules, and workflow rules for campaign members created using Web-to-Lead and the Campaign field when you create or clone a lead. When you activate this update, workflow runs automatically and custom fields are automatically populated for campaign members created using these methods. This is a Critical Update that must be activiated manually.</p>
<p><strong>Analytics</strong><br>
Wow! A ton of new chart, graph and dashboard enhancements.</p>
<p><strong>Formula Enhancements</strong><br>
A ton of these also so see the docs for more info.</p>
<p><strong>Support for Microsoft Office 2007 Full-Text Search</strong><br>
The Salesforce CRM Content search engine supports full-text search for all Microsoft Office 2007 Word, Excel, and PowerPoint files.</p>
<p><strong>New "Community" Application</strong><br>
This new application replaces the Ideas application in the Force.com app menu and includes both the Ideas and Answers (currently in pilot) tabs.</p>
<p><strong>Remote Access Application</strong><br>
Salesforce.com will support the OAuth protocol for authenticating Web applications that access data in a Salesforce.com instance.</p>
<h2 style="font-size:24pt;">Email Enhancements</h2>
<strong>Routing Error Emails to a Chosen Email Address</strong>
When Salesforce.com email services cannot process an incoming email message, you can now send the resulting error email message to a chosen address instead of notifying the sender.
<p><strong>Enhanced Security for Outbound Email Messages</strong><br>
Salesforce.com now supports Transport Layer Security (TLS) options for outbound email messages to chosen domains.</p>
<p><strong>Notification When Mass Email Completes</strong><br>
You can now choose whether you want Salesforce.com to notify senders when mass emails complete.</p>
<p><strong>Workflow Email Alerts</strong><br>
You can now customize each email alert to replace the user's From email address with a standard organization-wide email address. Recipients of the email alert then reply to the global email address instead of to the Salesforce.com user who updated the record.</p>
<h2 style="font-size:24pt;">API Enhancements</h2>
<strong>New Bulk API</strong>
The new Bulk API that is optimized to insert, update, or upsert a large number of records asynchronously. The new Bulk API allows you to load large batches of data that are processed in the background. You can develop REST-like clients using the Web Service Connector (WSC) Java toolkit. Also includes support for monitoring the status of jobs. Yipee!
<p><strong>Force.com Web Services API Enhancements</strong><br>
A number of modification and changed calls plus new objects including CronTrigger, Question, Reply and a number of Content objects. The v16 of the API will no longer be available after the release of v17. Instead, all requests for a v16 WSDL returns a 17.0 version. (Thanks for the clarification Alex Sutherland!!)</p>
<p><strong>Metadata API Enhancements</strong><br>
In addition to a number of fields that have been changed or deleted, there is support for list views for standard objects, picklist value translations for standard fields and standard object tab visibility in profiles.</p>
<p><strong>Content API Support for Bulk Insert and Update with the Force.com Data Loader and Excel Connector</strong><br>
Bulk insert and update documents into Salesforce CRM Content via the API and the Force.com Data Loader or Excel Connector.</p>
<h2 style="font-size:24pt;">Apex Enhancements</h2>
<strong>Apex Triggers for Case Comments and Email Messages</strong>
Now you can define Apex triggers associated with case comments. For example, you can set a trigger so that whenever a user adds a case comment, that user is added to the case team so that they can receive notices set up for team members. Now you can define Apex triggers associated with email messages.
<p><strong>Batch Apex</strong><br>
Batch Apex provides developers the ability to operate over large amounts of data by chunking the job into smaller parts, thereby keeping within the governor limits. Using batch Apex, a developer can build complex, long-running processes on the Force.com platform.</p>
<p><strong>Custom Setting</strong>s<br>
Custom settings provide developers a mechanism to deliver application metadata and associate this data at the organization, profile, and user level.</p>
<h2 style="font-size:24pt;">Limited and Beta Features</h2>
<strong>Apex Schedule - Limited Release</strong>
You can schedule Apex classes to run at specific times. Used in conjunction with Batch Apex you can create powerful cleanup and data integrity nightly jobs. The Apex scheduler is currently available through a limited release program so contact your Salesforce.com rep for more info.
<p><strong>Cloud Deploy - Beta Release</strong><br>
Cloud Deploy allows you to move and monitor metadata deployments between organizations. Use change sets to move configuration changes using the Web interface. Migrate Sandbox <-> Sandbox or Sandbox <-> Production. This will be a huge enhancement to release management. <a href="/2009/06/29/two-new-pilot-programs-for-winter-09/" target="_blank">I got busted in June </a>for letting this one out of the bag too soon.</p>
<p><strong>Lookup Filters - Beta Release</strong><br>
Lookup filters are administrator settings on lookup, master-detail, and hierarchical relationship fields that restrict the valid values and lookup dialog results for the field. Currently in beta and definitely needs more time to cook.</p>

