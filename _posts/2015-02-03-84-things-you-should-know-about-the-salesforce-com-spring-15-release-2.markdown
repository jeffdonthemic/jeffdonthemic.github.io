---
layout: post
title:  84 Things You Should Know about the salesforce.com Spring ’15 Release
description: The Spring 15 Release  should be hitting boxes soon with 250+ new and improved features! With over 300 page of documentation there are plenty of goodies for everyone. Salesforce continues to give us what we ask for with 5 pages of features implemented from user submissions on the IdeaExchange. Im happy to say that one of them  was mine!  Of course there are a ton in the release notes , but Ive pulled out my favorites in this handy-dandy list. There will be no test afterwards so peruse at your le
date: 2015-02-03 23:28:17 +0300
image:  '/images/spring15-logo.png'
tags:   ["salesforce"]
---
<p>The <a href="http://www.salesforce.com/customer-resources/releases/spring15/">Spring '15 Release</a> should be hitting boxes soon with 250+ new and improved features! With over 300 page of documentation there are plenty of goodies for everyone. Salesforce continues to give us what we ask for with 5 pages of features implemented from user submissions on the IdeaExchange. I'm happy to say that <a href="https://success.salesforce.com/ideaView?id=08730000000kmjRAAQ">one of them</a> was mine!</p>
<p>Of course there are a ton in the <a href="http://www.salesforce.com/customer-resources/releases/spring15/">release notes</a>, but I've pulled out my favorites in this handy-dandy list. There will be no test afterwards so peruse at your leisure.</p>
<h2 id="generalenhancements">General Enhancements</h2>
<ul>
<li>IE 7 & 8 are no longer supported. Good riddance I say!</li>
<li>Duplicate Alerts and Blocking allows you to control whether and when you allow users to create duplicate records inside Salesforce (does not require a Data.com license BTW).</li>
<li>Improved "Import My Accounts & Contacts" from social data sources.</li>
<li>Better HTML Editor for Rich Text fields.</li>
<li>Flexible Pages have been renamed Lightning Pages throughout the Salesforce documentation and user interface. They are still known as FlexiPages in the API, however.</li>
<li>Users can subscribe to receive report notifications to stay up-to-date on the reports and metrics that matter to them.</li>
</ul>
<h2 id="forcecomcodeenhancements">Force.com 'Code' Enhancements</h2>
<ul>
<li>Deploy to production without running all tests with Quick Deploy. You can now deploy components to production by skipping the execution of all Apex tests for components that have been validated within the last four days (that sound you just heard was me falling off my chair).</li>
<li>New Visualforce attributes for <a href="flow:interview">flow:interview</a></li>
<li>Visualforce map component displays locations more precisely.</li>
<li>The URLFOR function has been optimized for use with attachments in Visualforce.</li>
<li>Submit more batch jobs with Apex Flex Queue. This was actually (<a href="https://success.salesforce.com/ideaView?id=08730000000kmjRAAQ">my idea</a>). Thanks Josh Kaplan!</li>
<li>Use asynchronous callouts to make long-running requests from a Visualforce page to an external Web service and process responses with callback methods (aka, Long-Running Callouts).</li>
<li>Setup test data for an entire test class and then access them in every test method in the test class using the new @testSetup annotation.</li>
<li>Queueable Apex can now chain a job to another job an unlimited number of times.</li>
<li>The Apex callout size limit for requests and responses has been increased to the heap size limit.</li>
<li>List Apex classes and triggers with a Tooling API endpoint. I plan on adding this to <a href="https://github.com/jeffdonthemic/nforce-tooling">my nforce tooling plugin</a>.</li>
<li>If you use ConnectApi (Chatter in Apex) there are an <strong>extremely</strong> large number of enhancements to checkout.</li>
<li>There is a number of new and modified Apex classes and interfaces so see the docs for details.</li>
<li>API v33.0 has a large number of new and changed objects for you to pore over. The REST API now supports insert/update of BLOB data plus CORS support! Hurrah!!</li>
<li>The Streaming API now supports generic streaming for events that arent tied to Salesforce data changes.</li>
<li>The Tooling API adds SOSL support and a few new objects and new fields on existing objects.</li>
<li>For ISV there are also a number of enhancements that will make you happy and your jobs easier.</li>
</ul>
<h2 id="forcecomclicksenhancements">Force.com 'Clicks' Enhancements</h2>
<ul>
<li>Publisher actions are now called "quick actions" and record actions are now called "productivity actions".</li>
<li>You can now create or edit records owned by inactive users. This should make data migration much easier.</li>
<li>Expanded Setup search for assignment rules, custom buttons, custom links and more, but sadly, in beta.</li>
<li>Geolocation fields are GA but with some limitations so see the docs.</li>
<li>You can now retain field history for up to 10 years with some configuration.</li>
<li>The Lightning Process Builder has been released which is a workflow tool to automate everything from simply daily tasks to more processes. Definitely check out the docs for this as there are a bunch of changes since the beta. Now you can create versions of a process, call Apex, customize conditional logic, trigger multiple processes in a single transaction and more.</li>
<li>If you use Visual Workflow, you can now pause a flow, customize conditional logic, create dynamic labels, make Apex classes accessible to flows and much, much, much more.</li>
</ul>
<h2 id="security">Security</h2>
<p>It looks like @cmort has been busy as usual for this release as there are tons (literally, not figuratively) of enhancements.</p>
<ul>
<li>Monitor Your Users Login and Logout Activity</li>
<li>Configure a Google Authentication Provider</li>
<li>Customize SAML Just-in-Time User Provisioning with an Apex Class</li>
<li>Use Multiple Callback URLs for Connected</li>
<li>Improve Security with Session Domain Locking</li>
<li>Edit Authorize, Token, and User Info Endpoints for Facebook Auth. Provider</li>
<li>Create Named Credentials to Define Callout Endpoints and Their Authentication Settings</li>
<li>Track Login History by ID with Session Context</li>
<li>Track Data Loader Logins with Login History</li>
<li>Use Login Forensics (Pilot) to identify unusual behavior within your organization.</li>
<li>Sign SAML Single Sign-On Requests with RSA-SHA256</li>
<li>Choose the Logout Page for Social Sign-On Users</li>
<li>Provide Code Challenge and Verifier Values for OAuth 2.0 Web Server Flow</li>
<li>Control Individual API Client Access to Your Salesforce Organization</li>
<li>Provision Users in Third-Party Applications Using Connected Apps (Beta)</li>
</ul>
<h2 id="analytics">Analytics</h2>
<ul>
<li>Salesforce Wave was introduced so <a href="http://appirio.com/category/business-blog/2014/10/diving-salesforce-wave/">See blog post</a> for details and a demo.</li>
<li>Salesforce Analytics for iOS released</li>
</ul>
<h2 id="salesforce1mobile">Salesforce1 Mobile</h2>
<p>There are a number of enhancements and they breakdown by Android, iOS, mobile browser and full site. Make sure you check the docs for specifics.</p>
<ul>
<li>Improved offline caching.</li>
<li>Salesforce Today now includes the following cards: Current Event, Agenda, My Tasks, My Recent Records, To Me Feed, Account News, and Dashboard.</li>
<li>In-App notifications regarding subscribed to reports.</li>
<li>Records with standard address fields now display a Google Maps image of the address.</li>
<li>You can now add attachments directly from the New Post Page.</li>
<li>View multiple record updates bundled into one post.</li>
<li>View, upload, and delete group photos and add announcements & records to Chatter Groups.</li>
<li>There are a number of new Salesforce Files filters.</li>
<li>Browse and share external Files.</li>
<li>Import Contacts from mobile device native contacts.</li>
<li>Guide sales reps through the sales cycle with Sales Path.</li>
<li>Convert qualified leads to contacts and create opportunities (Beta).</li>
</ul>
<h2 id="communities">Communities</h2>
<p>Luckily Communities have really been enhanced for this release!</p>
<ul>
<li>Community Management is now a one-stop shop for setting up and managing communities. Flag files, manage & translate topics, change templates and more from one place. #fabulous</li>
<li>Community Builder simplifies the community design experience (templates, colors, branding, etc), implements a page editor (with previews), allows for easy navigation and more. Check out the docs for all of the goodies.</li>
</ul>
<h2 id="sales">Sales</h2>
<ul>
<li>Sales Path guides sales reps through the sales cycle to close deals faster. It has a slick UI.</li>
<li>Historically, Territory Management has always been a huge PITA but it's definitely getting <strong>much</strong> better with Enterprise Territory Management. The latest features offer more options for assigning and managing relationships among accounts, territories, and opportunities, greater insight into territory characteristics through custom fields on list views and records, and additional territory information on select reports. New APIs to boot!</li>
<li>Tack all the deals in your sales pipeline with Opportunities and Collaborative Forecasting. Now with owner adjustments and product field history!</li>
<li>If you are using Salesforce for Outlook, there are a ton of new features for syncing, importing and connecting to Office 365.</li>
</ul>
<h2 id="service">Service</h2>
<ul>
<li>Support agents who use Case Feed now can run macros to automagically complete repetitive tasks.</li>
<li>The Assets Object has ben redesigned as a Standard Object with all kinds of goodies (sharing rules, record types, field history, etc.).</li>
<li>Agents and Salesforce Knowledge managers can now see a list of cases an article is attached to.</li>
<li>When using Knowledge One, agents can send an email with an articles contents embedded in the body of the email (Beta).</li>
<li>Salesforce no longer supports Salesforce CTI Toolkit. Long live Open CTI!</li>
<li>Create cases from questions in Chatter with Question-to-Case.</li>
<li>Social Customer Service Starter Pack connects FB and Twitter accounts to Salesforce (without a Radian6 contract) allowing you to like, tweet and post all from with the Case feed. There are even Google+ and Sina Weibo Social Customer Service pilots.</li>
</ul>
<h2 id="chatterfiles">Chatter & Files</h2>
<ul>
<li>Chatter Dashboards Package provides insight and metrics from your Chatter posts.</li>
<li>Additional group collaboration including add records, post via email with non-unique addresses and more.</li>
<li>A new setup section for Salesforce Files and Content.</li>
<li>Sync shared Files from <strong>other</strong> users.</li>
<li>Integrate with Microsoft OneDrive for Business for file sharing.</li>
<li>Call Salesforce or third-party API from Chatter Posts with Action Links.</li>
<li>OMG! They added Emoticons to Chatter Feeds!!</li>
<li>The ChatterMessage object now supports triggers.</li>
</ul>
<h2 id="pilotsbetasohmy">Pilots & Betas (Oh My!!)</h2>
<ul>
<li>The Lightning Component framework is in beta but has a number of new components and events. See <a href="/2014/10/14/tutorial-build-your-first-lightning-component/">this blog post</a> to get started building components.</li>
<li>Build powerful queries for Wave using Salesforce Analytics Query Language (SAQL) for ad hoc analysis.</li>
<li>Exchange Sync which syncs your users contacts and events between Exchange-based email systems and Salesforce.</li>
<li>Manage Customer Data with Data Pipelines to leverage the power of custom Apache Pig scripts on Hadoop to process large-scale data thats stored in Salesforce.</li>
</ul>

