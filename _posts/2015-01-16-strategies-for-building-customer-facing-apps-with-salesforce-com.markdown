---
layout: post
title:  Strategies for Building Customer Facing Apps with Salesforce.com
description: There comes a time in almost every Salesforce orgs life when you want to get some data from your org on to the web for customers to interact with. Lets say that you run a non-profit and you want to allow customers to sign up for volunteer sites and times nationwide to donate their time and services. We are going to explore a number of different ways to accomplish this goal but we are going to exclude Communities  from this use case since these donors may not fit the typical customer or partner r
date: 2015-01-16 20:31:46 +0300
image:  '/images/pexels-yan-krukov-8612921.jpg'
tags:   ["2015", "public"]
---
<p>There comes a time in almost every Salesforce org's life when you want to get some data from your org on to the web for customers to interact with. Let's say that you run a non-profit and you want to allow "customers" to sign up for volunteer sites and times nationwide to donate their time and services.</p>
<p>We are going to explore a number of different ways to accomplish this goal but we are going to exclude <a href="http://www.salesforce.com/communities/overview/">Communities</a> from this use case since these donors may not fit the typical customer or partner role. You may argue differently but that's for another debate.</p>
<h2 id="forcecomsites">Force.com Sites</h2>
<p>The easiest way to get started with customer facing apps is with <a href="https://developer.salesforce.com/page/Sites">Force.com Sites</a>. With Sites you can create public web apps that run natively on the Force.com platform with your own domain. Your app will consist of Visualforce pages and Apex controllers that provide its functionality.</p>
<p>Force.com Sites advantages:</p>
<ul>
<li>Quick and easy to get started. You are already using Salesforce!!</li>
<li>You can leverage exiting data, content and logic already in your org.</li>
<li>"One environment to rule them all" means no need for a separate server or environment to maintain.</li>
<li>You can utilize your existing Apex & Visualforce resources to build and maintain your site.</li>
<li>You can utilize the same build, test and deploy processes that you currently have in place.</li>
</ul>
<p>Force.com Sites disadvantages:</p>
<ul>
<li>Your application must be written in Visualforce and Apex using the platform's features. You may find yourself wanting to implement functionality that the platform doesn't offer.</li>
<li>Be careful that you don't expose records and fields by mistake to external users. One wrong checkbox and you could leak sensitive data.</li>
<li>Authenticated users is only available with customer portal. So if you want to require your customers to login, that's going to cost you extra money (i.e., portal licenses).</li>
<li>Integration with third party apps, services and APIs can be a "challenge" due to callout limits.</li>
<li>Daily limits to your site include the number of bytes of data in/out of your site and total time spent generating pages on the server. High traffic or long running processes can temporarily put your site over the limit and offline until your limits reset.</li>
</ul>
<p>Force.com Sites a quick, easy and inexpensive option if your site doesn't require a login, has traffic and processing times that stays under the limits and you have development resources that know and love Visualforce and Apex. It's a snap to setup and just runs.</p>
<h2 id="externallyhostedapps">Externally Hosted Apps</h2>
<p>If you have development resources that are comfortable with Java, JavaScript, PHP, Ruby or [insert almost any other language] then an application sitting on Heroku, AWS, Google App Engine, DigitalOcean or bare metal is an excellent way to a build powerful and engaging apps with Salesforce as your backend.</p>
<p>A customer facing app sitting on Heroku, for example, gives you the power and flexibility to built anything you want. Building apps on Heroku is not as scary as you think. There tons of <a href="https://addons.heroku.com/">addons-on</a> for databases, messaging, queueing, caching and more to make development a snap.</p>
<p>With an externally hosted application, you'll need a way to access the data in your org by using either the Salesforce SOAP or REST APIs. You can use SOAP (why?) but REST is typically the preferred method with customer facing apps. There are a number of wrappers around the REST API including <a href="https://github.com/kevinohara80/nforce">nforce for Node.js</a> and <a href="https://github.com/ejholmes/restforce">restforce for Ruby</a> that make life easier, but they are not required.</p>
<p>If you prefer keeping your logic in Salesforce to leverage existing code, you can even write <a href="/2011/07/21/video-tutorial-building-apis-with-salesforce-com-apex-rest-services/">Apex REST services</a>. These services allow you to maximize code reuse and even perform multiple transactions (e.g., find a record, validate data, update records in multiple objects and return a boolean to indicate success) instead of just operating on a single record. They are super fast and easy to build.</p>
<p>Along with access comes authentication and authorization. OAuth is a snap with Salesforce but you need to choose if you want your app to connect via a single "api" user or if each logged in user will connect to your org as their own named Salesforce user. Even though the former is drastically cheaper, a named Salesforce user gives you all kinds of goodie like record and field level security, chatter, audit trails and more.</p>
<p>You'll also need to choose where your data lives. There are a couple of roads that you can take. You can keep everything in Salesforce and have your app fetch it when requested or sync some data selectively to a local data store.</p>
<h4 id="backendasaservice">Backend as a Service</h4>
<p>We took the first approach at CloudSpokes a couple of years ago and it really worked well for us. All of our data and business logic lived in Salesforce and each page request would call Salesforce to retrieve needed data. Salesforce was our "Backend as a Service" and we only needed to concentrate on the client side. Plus, we didn't have to build an admin section for our site as Salesforce provided it for us... out of the box. Talk about saving time and money!!</p>
<div class="flex-video"><iframe src="http://www.slideshare.net/slideshow/embed_code/28525333" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe></div>
<p>There are a couple of issues with this approach.</p>
<ul>
<li>Depending on your site's traffic, you may bump in the limit on the number of API calls per day. With an <a href="https://help.salesforce.com/HTViewHelpDoc?id=integrate_api_rate_limiting.htm">Enterprise license</a> you can only make 1,000 API calls per day per user license. So spikes in traffic or search engine spiders can potentially bring your site to a screeching halt.</li>
<li>Your site will be down during Salesforce maintenance downtime. No Salesforce. No site.</li>
<li>It's very difficult to write unit tests for your website against sandbox environments as your org doesn't "know" that your site is in test mode.</li>
</ul>
<h4 id="hybridbackendasaservice">Hybrid Backend as a Service</h4>
<p>Over the last couple of years Salesforce has implemented services to make a "hybrid" approach possible. With this approach you minimize your site's reliance on Salesforce by copying select data from Salesforce to a local datastore (Postgres, MongoDB, etc.) for your site. With this strategy, you essentially read from the local database and write to Salesforce. For instance, for your non-profit volunteering app you may want to "move" volunteer, location, position and sponsorship data to the local database for reads. Inserts or updates to Salesforce would trigger a refresh of the local database. There are a number of ways to update the local database depending on how fast you need the data reflected from Salesforce.</p>
<ul>
<li><a href="/2013/01/16/force-com-streaming-api-with-ruby/">Streaming API</a> - You can use this API to stream any changes made to records to your application. So if a volunteer record is updated from the results of an action inside Salesforce or from your app, the platform will stream the changes to your app which can then update the local database accordingly.</li>
<li>Periodic - You could use a cron job to check for records that need to be updated (based up last modified date) or some sort of <a href="https://developer.salesforce.com/page/Data_Loader">data loader service</a> to refresh data.</li>
<li>As Needed - Your app could "know" when to update data. For instance, when your user logs in you could refresh their data or every time a record is inserted/updated in Salesforce you could update it locally from Salesforce.</li>
</ul>
<h2 id="herokuconnect">Heroku Connect</h2>
<p><a href="https://www.heroku.com/connect">Heroku Connect</a> was released last year and IMHO this is the best way to implement a Hybrid Backend as a Service. Heroku Connect is a native bi-directional data sync service between Salesforce and Heroku Postgres. It solves some of the difficulties outlined above keeping data in sync. There are a few kinks right now but if Salesforce can work out the correct licensing model it will be a killer service for building customer facing apps on Heroku.</p>
<div class="flex-video"><iframe src="http://www.slideshare.net/slideshow/embed_code/40354424" width="425" height="355" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe></div>

