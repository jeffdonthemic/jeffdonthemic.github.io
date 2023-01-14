---
layout: post
title:  Writing Unit Tests for v24 Apex REST Services
description: With the Spring 12 release, salesforce.com made some great enhancements  to Apex REST services (v24)- * Apex REST automatically provides the REST request and response in your Apex  REST methods via a static RestContext object. You no longer need to declare a  RestRequest or RestResponse parameter in your method. * User-defined types are now allowed as Apex REST parameter types. * Apex REST methods are now supported in managed and unmanaged packages. * The order of elements in the JSON or XML res
date: 2012-03-21 11:42:05 +0300
image:  '/images/slugs/writing-unit-tests-for-v24-apex-rest-services.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>With the Spring '12 release, salesforce.com made some <a href="http://developer.force.com/releases/release/Spring12/apex+rest+updates">great enhancements</a> to Apex REST services (v24):</p>
<ul>
<li>Apex REST automatically provides the REST request and response in your Apex REST methods via a static RestContext object. You no longer need to declare a RestRequest or RestResponse parameter in your method.
<li>User-defined types are now allowed as Apex REST parameter types.
<li>Apex REST methods are now supported in managed and unmanaged packages.
<li>The order of elements in the JSON or XML response data no longer has to match the Apex REST method parameter order.</ul>
<p>My favorite is the user-defined types. My REST services can now pass back a wrapper class with error messages along with the actual data. Here's what my new REST service looks like:</p>
{% highlight js %}@RestResource(urlMapping='/v.9/member/*/results/*') 
global with sharing class MemberRestSvc {
 
 @HttpGet 
 global static ReturnClass doGet() {
 
  String[] uriKeys = RestContext.request.requestURI.split('/');
  // get the member name from the uri
  String memberName = uriKeys.get(uriKeys.size()-3);

  // do awesome programming stuff here & catch any exceptions
  try {
 
 List<Contact> contacts = [Select Id From Contact where member_name__c = :memberName];
 return new ReturnClass('true', 'Query executed successfully.', contacts);
  
  } catch (Exception e) {
 return new ReturnClass('false', e.getMessage(), null);
  }

 }

 global class ReturnClass {
  
  global String success;
  global String message;
  global List<Contact> records;
  
  global ReturnClass(String success, String message, List<Contact> records) {
 this.success = success;
 this.message = message;
 this.records = records;
  }
  
 }
  
}
{% endhighlight %}
<p>So now that I have my service written and running like a champ, I just need to write my unit tests. If I was writing the unit test with the <em><strong>previous API (v23)</strong></em>, I would write my unit test like:</p>
{% highlight js %}@isTest
private class Test_MemberRestSvc {
 
 static {
  // setup test data 
 }
 
 static testMethod void testDoGet() {
  
  RestRequest req = new RestRequest(); 
  RestResponse res = new RestResponse();

  // pass the req and resp objects to the method 
  req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today'; 
  req.httpMethod = 'GET';

  MemberRestSvc.ReturnClass results = MemberRestSvc.doGet(req,res);
  
  System.assertEquals('true', results.success);
  System.assertEquals(10, results.records.size());
  System.assertEquals('Query executed successfully.', results.message);
 
 }
 
}
{% endhighlight %}
<p>Since v24 now includes a static RestContext object, testing is a little different as you no longer need to pass a Request and Response object to the method. I searched the <a href="http://www.salesforce.com/us/developer/docs/apexcode/index.htm">Apex docs</a> but there was no mention of writing unit tests. Pat Patterson has a <a href="http://blogs.developerforce.com/developer-relations/2012/02/quick-tip-public-restful-web-services-on-force-com-sites.html">good blog post</a> for Apex REST but no mention of unit testing either.</p>
<p>So I tried a few routes for an hour or so to no avail. I finally IM'd Pat and begged for help. I <a href="http://boards.developerforce.com/t5/REST-API-Integration/How-to-unit-test-v24-Apex-REST-classes/td-p/414759">posted the question on the Force.com Discussion Boards</a> and Pat went to work. However, before Pat could finish his investigation and provide a solution, <a href="http://boards.developerforce.com/t5/user/viewprofilepage/user-id/57763">Kartik</a> beat him to it (thanks!!).</p>
<p>So here's what the unit test looks like for a v24 Apex REST service. Notice that you pass a request and response object to the RestContext but that's it. Doesn't seem very intuitive?</p>
{% highlight js %}@isTest
private class Test_MemberRestSvc {
 
 static {
  // setup test data 
 }
 
 static testMethod void testDoGet() {
  
  RestRequest req = new RestRequest(); 
  RestResponse res = new RestResponse();
 
  req.requestURI = 'https://cs9.salesforce.com/services/apexrest/v.9/member/me/results/today'; 
  req.httpMethod = 'GET';
  RestContext.request = req;
  RestContext.response = res;

  MemberRestSvc.ReturnClass results = MemberRestSvc.doGet();
  
  System.assertEquals('true', results.success);
  System.assertEquals(10, results.records.size());
  System.assertEquals('Query executed successfully.', results.message);
 
 }
 
}
{% endhighlight %}

