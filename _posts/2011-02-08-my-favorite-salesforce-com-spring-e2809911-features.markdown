---
layout: post
title:  My Favorite Salesforce.com Spring ’11 Features
description:   The salesforce.com Spring 11 release is set to start rolling onto orgs in the next few days. Are you ready? This release is packed with all kinds of platform #superfrickinawesome-ness!! Once again, Ive scoured through all 88 pages of the  release notes and pulled out my favorite features.I didnt hit all of the items in the release notes so make sure you pull up the PDF and check out all of the goodies for this release. Also check out the Spring 11 Force.com Platform Release Preview page  fo
date: 2011-02-08 14:12:58 +0300
image:  '/images/slugs/my-favorite-salesforce-com-spring-e2809911-features.jpg'
tags:   ["salesforce"]
---
<p><img style="float: left;" title="spring-11-logo.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027582/a2zzwwfh7byuxw1ia0rk.png" border="0" alt="Spring 11 logo" width="200" height="245" /></p>
<p>The salesforce.com Spring '11 release is set to start rolling onto orgs in the next few days. Are you ready? This release is packed with all kinds of platform #superfrickinawesome-ness!! Once again, I've scoured through all 88 pages of the <a href="https://na1.salesforce.com/help/doc/en/salesforce_spring11_release_notes.pdf" target="_blank">release notes</a> and pulled out my favorite features.I didnt hit all of the items in the release notes so make sure you <a href="https://na1.salesforce.com/help/doc/en/salesforce_spring11_release_notes.pdf" target="_blank">pull up the PDF</a> and check out all of the goodies for this release. Also check out the <a href="http://developer.force.com/releases/release/Spring11" target="_blank">Spring 11 Force.com Platform Release Preview page</a> for any last minute info. I've tried to link the features below to the appropriate section in the preview site for more info.</p>
<p>There are a number of new enhancements across the platform but developers really come out ahead with this release. Last fall I named the Winter '11 release, "<em>OMG! We Love Outlook!</em>" due to the heavy emphasis on Salesforce for Outlook. I've aptly named the Spring '11 release "<a href="http://www.youtube.com/watch?v=8To-6VIJZRE" target="_blank">Developers! Developers! Developers!</a>". You'll see why as the article progresses.</p>
<p><strong>Google Chrome Support</strong></p>
<ul>
<li>Hurrah! Salesforce now supports Google Chrome version 8.0.x and Google Chrome Frame plug-in for Microsoft Internet Explorer.</li>
<li>Now there's no reason why you shouldn't be using my kick-ass Chrome plugin, the <a href="/force-com-utility-belt/" target="_blank">Force.com Utility Belt</a>. </li>
</ul>
<p><strong>Chatter Enhancements</strong></p>
<ul>
<li><strong>Like</strong> - Finally.. I was getting so sick of typing "Like" into my Chatter comments! You can now Like and unLike posts but not comments.</li>
<li><strong>@Mentions</strong> - You can now mention a person's name to ensure that the person sees the update.</li>
<li><strong>Posting Comments via Email Replies</strong> - You can now reply to Chatter posts and comments by simply replying to the email notification. #Awesome!</li>
<li><strong>Trending Topics</strong> - The Chatter tab now includes Trending Topics to show what people in your company are talking about.</li>
<li><strong>Follow Dashboard Components</strong> -Only metrics and gauges with conditional highlighting are eligible.</li>
<li><strong>Live Updates</strong> - You can now click <em>You have new updates</em> at the top of a feed to see updates added to your Chatter feed since your last refresh.</li>
<li><strong>Private File Sharing</strong> - Privately share a file with specific Chatter users. There are a bunch of settings around this such as email notifications after sharing, see where a file is shared, view and search for files shared by me, upload a new version, file sharing settings and permission. Check out the docs for more details.</li>
<li><strong>Private Group Requests by Email</strong> - You can now click a button to automatically send an email to a group's owner and managers requesting permission to join a Chatter group.</li>
<li><strong>Recommend People and Records</strong> - Chatter now recommends records for you to follow as well aspeople based on a shared interest in records.</li>
<li><strong>Searchable Chatter Fields</strong> - The Global Search now includes Chatter feed results.</li>
<li><strong>Chatter Desktop</strong> - New version of Chatter Desktop for Adobe Air</li>
<li><strong>Chatter Mobile</strong> - Available for iPhone, iPad and BlackBerry devices. The Chatter mobile app does not have all of the functionality of Chatter in Salesforce.</li>
<li>Chatter Triggers - You can now write triggers for theFeedComment and FeedItem objects. <a href="http://blog.sforce.com/sforce/2011/01/chatter-triggers-in-spring-11.html" target="_blank">More details here.</a> Thanks Sandeep!</li>
</ul>
<p><strong>Sales Cloud</strong></p>
<ul>
<li>The Cloud Scheduler is now enabled by default for all organizations.</li>
<li>The Attachments related list is now automatically added to task and event records for new orgs. You'll need to add it manually for existing orgs.</li>
<li>Attachments are now searchable for tasks and events.</li>
<li>Attachments on emails that are sent using Email to Salesforce or Salesforce for Outlook can now be saved with the email's task record in Salesforce.</li>
<li>Salesforce for Outlook now uses OAuth-based authentication to securely store user login information.</li>
</ul>
<p><strong>Service Cloud</strong></p>
<ul>
<li>Salesforce Knowledge now supports multiple languages</li>
<li>Salesforce Knowledge Sidebar for the Service Cloud Console automatically searches and returns articles from your knowledge base that matches any of the words in the Subject of a case.</li>
<li>Global Search is the sole search tool for the Service Cloud Console</li>
</ul>
<p><strong>Report Builder Enhancements </strong></p>
<ul>
<li>New chart type for reports - scatter charts</li>
<li>Report builder is now available to users with Force.com and Salesforce Platform licenses</li>
<li>Group and Professional Edition orgs can now use report builder</li>
<li>All profiles get access to the report builder by default</li>
<li><a href="http://developer.force.com/releases/release/Spring11/Real+Report+Builder" target="_blank">More info here</a>.</li>
</ul>
<p><strong>Dashboard Enhancements</strong></p>
<ul>
<li>Dashboard builder is automatically enabled for all users</li>
<li>More Dynamic Dashboards per edition: EE-up to five per org, UE-up to 10 per org, DE-up to three per org. I've also heard that there might be a black tab to increase these numbers.</li>
<li>Post a snapshot of a dashboard component to a user's Chatter feeds</li>
<li>You can show Chatter user and group photos in horizontal bar charts and tables in dashboards</li>
</ul>
<p><strong>Revised Apex Governor Limits</strong></p>
<ul>
<li>There is now a single context for all governor limits! Be still my beating heart!! All governor limits have the same amount of resources allocated to them, regardless if you're calling it from trigger, an anonymous block, a test, and so on.</li>
<li>The total number of DML statements issued for a process has gone from 20 for triggers, and 100 for everything else, to 150 for all contexts. </li>
<li>Total number of records retrieved by SOQL queries has gone from 10K to 50K</li>
<li><a href="http://developer.force.com/releases/release/Spring11/Revised+Apex+Governor+Limits" target="_blank">More info here</a>.</li>
</ul>
<p><strong>REST API</strong> - Develop mobile and external apps in Java, Ruby, Python, PHP etc. using the REST API as an alternative to the SOAP-basedAPI. The REST API is a simplified approach for developers, using code that is much less verbose and easy to write. <a href="http://developer.force.com/releases/release/Spring11/REST+API" target="_blank">More info here</a>.</p>
<p><strong>Criteria-Based Sharing Rules</strong> - Instead of using Triggers to create and delete sharing rules, you can now declaratively create sharing rules based upon some criteria of the record (i.e. when BillingState = 'NY'). You can create criteria-based sharing rules for accounts, opportunities, cases, contacts, and custom objects. There is a limit of 10 criteria-based sharing rules per object. <a href="http://developer.force.com/releases/release/Spring11/Criteria+Based+Sharing" target="_blank">More info here</a>.</p>
<p><strong>Visualforce Inline Editing</strong> - A single component, <apex:inlineEditingSupport>, provides inline editing support in your Visualforce details pages. Now users will have the same editing experience in your Visualforce page that they get in standard page layouts. Inline editing is supported by 8 components so check out the docs for more details. Inline editing is not supported for rich text areas or dependent picklists. <a href="http://developer.force.com/releases/release/Spring11/Visualforce+Inline+Editing" target="_blank">More info here</a>.</p>
<p><strong>Visualforce Dynamic Bindings</strong> - This feature allows you to write generic Visualforce pages that display information about records without necessarily knowing which fields to show. Administrators/developers can create fields sets that determine at runtime the files to be displayed. Therefore, when at you need to modify the fields on a Visualforce page you simply modify the associated field set instead of modifying the Apex controller and Visualforce page. <a href="http://developer.force.com/releases/release/Spring11/Visualforce+Dynamic+Binding" target="_blank">More info here</a> along with a <a href="http://blog.sforce.com/sforce/2011/02/using-field-sets-in-spring-11.html" target="_blank">blog post</a>.</p>
<p><strong>Change Sets</strong> - This admin features allows you to package up a number of configuration changes in one org and send them to another org to be deployed. Essentially the same as deploying with the Force.com IDE but you can now give administrators (non-developers) access to install modifications from sandbox. <a href="http://developer.force.com/releases/release/Spring11/Change+Sets" target="_blank">More info here</a>.</p>
<p><strong>Force.com Flow</strong> - Formerly Visual Process Manager, this is a client-side tool that allows you to design complex, robust scripting processes that you can embed in your Visualforce pages. You can also embed Flows in Visualforce pages to be used with Force.com Sites, the Customer Portal and the partner portal. This is gonna be big!! <a href="http://developer.force.com/releases/release/Spring11/Visual+Workflow" target="_blank">More info here</a>.</p>
<p><strong>System Log Console Execution Summary</strong> - The system log contains a new tab to highlight the duration and composition of a request so you can identify and isolate execution bottlenecks. There is also a new section that details the value of variables during a request. <a href="http://developer.force.com/releases/release/Spring11/System+Log+Console+Execution+Summary" target="_blank">More info here</a>.</p>
<p><strong>Daily Limit on Workflow Alert Emails</strong> - To prevent abuse of email limits, the daily limit for emails sent from workflow and approval-related email alerts is 1,000 per standard Salesforce license per organization. The overall organization limit is 2 million.</p>
<p><strong>Web Service Connector</strong> - The <a href="http://code.google.com/p/sfdc-wsc/" target="_blank">WSC</a> replaces Apache Axis 1.3 as the preferred SOAP Java client framework. WSC is an open-source project and contains a command utility that generates Java source and bytecode files from WSDL files.</p>
<p><strong>New & Modified API Objects</strong></p>
<ul>
<li>LoginHistory - Represents the login history for all successful and failed login attempts for organizations and enabled portals.</li>
<li>ContentDocumentLink - Represents the link between a Salesforce CRM Content document or Chatter file and where it's shared.</li>
<li>FeedLike - Indicates that a user has liked a feed item.</li>
<li>CollaborationGroupMemberRequest - Represents a request to join a private Chatter group.</li>
<li>DashboardComponent - Represents a dashboard component (read-only)</li>
<li>DashboardComponentFeed - Represents a single feed item in the feed displayed on a dashboard component.</li>
<li>A number of Chatter and Metadata API objects have been changed in API version 21.0 so check out the docs for details.</li>
</ul>
<p><strong style="font-size:14pt">Pilot and Developer Previews</strong></p>
<p><strong>Javascript Remoting for Apex Controllers - Developer Preview</strong> -This new feature allows you to integrate Apex and Visualforce pages with JavaScript libraries. It provides support for some methods in Apex controllers to be called via Javascript using the @RemoteAction annotation. <a href="http://developer.force.com/releases/release/Spring11/JavaScript+Remoting" target="_blank">More info here</a>.</p>
<p><br /><strong>Apex Test Framework - Pilot</strong> -Run just one, a set, or all the tests in your organization. Tests are run asynchronously: start them, then go work on other things. You can then monitor the tests, add more tests to the ones that are running, or abort running tests. Once a test finishes running, you can see additional information about that test run.</p>
<p><br /><strong>ReadOnly Annotation - Pilot</strong> -The @ReadOnly annotation provides developers the ability to perform unrestricted queries against the Force.com database. The annotation removes the limit of the number of returned rows for a request but also blocks any DML statements within the request. The @ReadOnly annotation is only available for Web services and the schedulable interface.</p>
<p><br /><strong>Chatter for Mobile Browsers - Pilot</strong> -In addition to the Chatter mobile app for Apple and BlackBerry devices, salesforce.com provides a mobilized Web version of Chatter that you can access from a mobile device browser without installing an app.</p>
