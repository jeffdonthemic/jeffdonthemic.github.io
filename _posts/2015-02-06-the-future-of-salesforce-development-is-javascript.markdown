---
layout: post
title:  The Future of Salesforce Development is… Javascript?
description: When I started developing with Salesforce back in 2006, s-controls were essentially the only way to customize the application. Youd write a bunch of JavaScript code, upload it to the server and voila customizations!! Then in 2008 Salesforce released Apex and Visualforce and the platform exploded! It was the Renaissance of SaaS development! Now the pendulum of application development is once again in full motion and what was once old may be new again. But first, lets go back to the future of S
date: 2015-02-06 22:27:47 +0300
image:  '/images/pexels-markus-spiske-2004161.jpg'
tags:   ["salesforce"]
---
<p>When I started developing with Salesforce back in 2006, s-controls were essentially the only way to customize the application. Youd write a bunch of JavaScript code, upload it to the server and voila customizations!! Then in 2008 Salesforce released Apex and Visualforce and the platform exploded! It was the Renaissance of SaaS development! Now the pendulum of application development is once again in full motion and what was once old may be new again.</p>
<p>But first, lets go back to the future of Salesforce development for a bit. I remember those halcyon days of pre-framework JavaScript like they were yesterday. I yearn for the time when you could just throw up spaghetti code (thats all you could write back then) and call it enterprise software. But you have to admit, before the advent of Visualforce and Apex, s-controls sounded magical:</p>
<blockquote>
<p>Use s-controls to add your own functionality to your Salesforce organization. Whether you are integrating a hosted application of your own or are extending your current Salesforce user interface, use s-controls to store your code or refer to code elsewhere. Custom s-controls can contain any type of content that you can display in a browser, for example a Java applet, an Active-X control, an Excel file, or a custom HTML Web form.</p>
</blockquote>
<p><img src="images/scontrols-neverforget.jpg" alt="" ></p>
<p>Sadly, I mean, gladly, s-controls were deprecated a few years later as Apex and Visualforce matured. However, over the last couple of years Salesforce has been adding more and more support for JavaScript as their developer base and need for developers grew.</p>
<p>It began by simply providing support for jQuery in Visualforce pages. It was a start but on many occasions I opted to chew glass than to try and reference the DOM ID that was generated for a Visualforce component using jQuery. I even wondered aloud many times, <a href="/2010/08/11/why-is-this-so-dom-hard/">why is this so DOM hard?</a></p>
<p>Then the REST API took off and things went wild. Pat Patterson came on board and developed <a href="https://github.com/developerforce/Force.com-JavaScript-REST-Toolkit">ForceTK</a> which proxied JavaScript calls to Salesforce. You could write JavaScript apps from everywhere now! The toolkit is still maintained today and is one of my favorite ways to get stuff accomplished.</p>
<p>A couple of years later Salesforce released <a href="http://www.salesforce.com/docs/developer/pages/Content/pages_js_remoting.htm">JavaScript Remoting for Apex Controllers</a>. This was probably the defining moment for JavaScript development on the platform. Now you could actually call server-side methods in your Apex controllers directly from JavaScript! Then they went one step further and released <a href="http://www.salesforce.com/docs/developer/pages/Content/pages_remote_objects_using.htm">Remote Objects</a> to make performing database operations, like create, read, update and delete possible without the need for Apex. People went crazy with JavaScript UIs and you started to see less reliance on Visualforce components for development.</p>
<p>JavaScript frameworks began to take off over the last couple of years, especially AngularJS, and Visualforce has almost now become a container to hold your Single Page Apps. Sure, if you are doing some CRUD functionality aimed at internal users, then Visualforce is great. You can get a lot done with out-of-the-box Visualforce components. But if you want a really responsive UI with eye-candy, then you have to go the SPA route, most likely with Angular. In this case the designer has the freedom the create any look and feel they want while the front-end guys make the magic happen with Angular. Your Force.com developers can then focus on the backend Apex, object models and functionality. (BTW, if you can find someone available with all three of these skills hire them. Do not pass go. Forget the $200. Hire them.)</p>
<p>The advantage to this methodology is that it breaks the dependence on the platform lifecycle. Your designers and front-end developers can work on functionality disconnected from the backend using something like <a href="https://github.com/typicode/json-server">json-server</a> or <a href="https://github.com/cloudhead/node-static">node-static</a> to mock up service calls from Salesforce while your Salesforce platform team implements the object model, FLS, sharing rules, workflow and Apex code. We do this daily for our Salesforce challenges on <a href="http://www.topcoder.com">Topcoder</a> and we can churn out mind-blowing applications in no time.</p>
<p><img src="http://memecrunch.com/meme/HKRC/javascript/image.png" alt="" ></p>
<p>Not one to rest on their laurels, Salesforce introduced <a href="https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/">Salesforce1 Lightning Components</a> last fall at Dreamforce. Lightning components give you a client-server framework based up JavaScript that is native to the platform. It comes complete with an event-driven architecture that is optimized for fast Single Page Apps. If you are familiar with frameworks like Backbone or AngularJS (you are building them currently in Visualforce, right?), then building Lightning components should be a snap. Will Lightning applications and components replace Visualforce as the later superseded s-controls? Possibly but time will tell. Should you get started building Lightning components now? Absolutely. <a href="/2014/10/14/tutorial-build-your-first-lightning-component/">See this blog post for a quick tutorial</a>.</p>
<p>So to conclude, if you havent started building SPA in Visualforce and are curious, heres some code to get you started. Its probably the simplest code I could come up with. There are best practices for structuring your Angular code and different ways to access data from Apex, but this is the quickest way to see some results fast. The Visualforce page simply uses AngularJS and Bootstrap to display an Account and its associated Contacts.</p>
<p><img src="images/angular-demo-blog.png" alt="" ></p>
<p>Heres the Apex controller. It simply returns (as JSON) information for an account along with its contacts.</p>
{% highlight js %}global with sharing class AngularDemoController {
  
  // hardcode an account id for demo purposes
  static String accountId = '0017000001CwYz9';
  
  global static String getAccount() {
  return JSON.serialize([select name, billingstreet,
  billingcity, billingstate, billingpostalcode
   from account where id = :accountId][0]);
  }  
  
  global static String getContacts() {
  return JSON.serialize([select id, name, email 
   from contact where accountId = :accountId]);
  }
  
}
{% endhighlight %}
<p>The Visualforce page, once again, is the container for our AngularJS application. The account and contacts scope variables are populated with data from the controller when the page loads. Besides that the page does nothing really special. Feel free to customize and make it awesome!</p>
{% highlight js %}<apex:page standardStylesheets="false" sidebar="false"
 showHeader="false" applyBodyTag="false" applyHtmlTag="false"
 docType="html-5.0" controller="AngularDemoController">

<html lang="en" ng-app="demoApp">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>Angular Demo</title>
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css"/>
  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.11/angular.min.js"></script>

  <script>
 // define the app
 var demoApp = angular.module('demoApp', []);
 // add the controller
 demoApp.controller('DemoCtrl', function ($scope) {
   $scope.account = {!account}
   $scope.contacts = {!contacts}
 });
  </script>

</head>
<body class="container" ng-controller="DemoCtrl">

  <h1>{{account.Name}}</h1>
  
  <p class="lead">
  {{account.BillingStreet}}<br/>
  {{account.BillingCity}}, {{account.BillingState}}
  {{account.BillingPostalCode}}
  </p>
  
  <table class="table table-bordered">
 <tr>
  <th>Name</th>
  <th>Email</th>
  <th>Id</th>
 </tr>
 <tr ng-repeat="contact in contacts">   
  <td>{{contact.Name}}</td>
  <td>{{contact.Email}}</td>
  <td>{{contact.Id}}</td>
 </tr>
  </table>

</body>
</html>

</apex:page>
{% endhighlight %}
<p>Start learning Javascript today. It's the future.</p>
<p>Cross-posted from the <a href="https://www.topcoder.com/blog/the-future-of-salesforce-development-is-javascript/">topocoder blog</a>.</p>

