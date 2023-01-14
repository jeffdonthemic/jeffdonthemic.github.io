---
layout: post
title:  Salesforce REST API Demo from Cloudstock
description: This is the demo that I put together for the Cloudstock Hackathon  and I tried to throw in as many partner services as possible. I finally ended up with five so it was dubbed the Kitchen Sink demo. I thought some people may find it useful as it shows how to use the Force.com REST API in conjunction with OAuth2 using the Spring MVC framework. Pat Patterson put together a greatGetting Started with the Force.com REST API article but my app is slightly different and IMHO easier, since it uses the Sp
date: 2010-12-17 17:18:16 +0300
image:  '/images/slugs/salesforce-rest-api-demo-from-cloudstock.jpg'
tags:   ["code sample", "salesforce", "java"]
---
<p>This is the demo that I put together for the <a href="http://www.cloudstockevent.com/cloudstockhackathon">Cloudstock Hackathon</a> and I tried to throw in as many partner services as possible. I finally ended up with five so it was dubbed the "Kitchen Sink" demo. I thought some people may find it useful as it shows how to use the Force.com REST API in conjunction with OAuth2 using the Spring MVC framework. Pat Patterson put together a great <a href="http://wiki.developerforce.com/index.php/Getting_Started_with_the_Force.com_REST_API">Getting Started with the Force.com REST API article</a> but my app is slightly different and IMHO easier, since it uses the Spring Framework.</p>
<p>The app is a external-facing recruiting site that advertises the open <a href="http://www.appirio.com/careers">Appirio positions</a>. Please remember that this is a demo and I put most of the code into a couple of controllers to make it easier to show. The code can definitely be refactored in certain places. </p>
<p>Here's how the app uses the partner services:</p>
<p>
<table width="100%"><tr><th>Partner</th><th>How Used?</th></tr><tr><td><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327898/Box_js8fvb.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327898/Box_js8fvb.png" alt="" title="Box" width="96" height="48" class="alignnone size-full wp-image-3365" /></a></td><td>Store pdf job descriptions on Box for download by applicants.</td></tr><tr><td><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327899/Force_lxec3b.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327899/Force_lxec3b.png" alt="" title="Force.com" width="200" height="57" class="alignnone size-full wp-image-3363" /></a></td><td>Use Force.com as the datastore for open jobs. Access to Force.com using OAuth2 and the REST API.</td></tr><tr><td><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327882/Twilio_uniqur.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327882/Twilio_uniqur.png" alt="" title="Twilio" width="180" height="60" class="alignnone size-full wp-image-3368" /></a></td><td>Send a job to a friend via SMS.</td></tr><tr><td><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327881/VMWare_cfatth.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327881/VMWare_cfatth.png" alt="" title="VMWare" width="180" height="28" class="alignnone size-full wp-image-3369" /></a></td><td>Application built using Spring STS, Spring Roo and Spring MVC. The application runs locally on tc Server.</td></tr><tr><td><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327897/MongoDB_ir8uof.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327897/MongoDB_ir8uof.png" alt="" title="MongoDB" width="149" height="48" class="alignnone size-full wp-image-3367" /></a></td><td>Store metrics for jobs on MongoHQ.</td></tr></table>
</p>
<p>Here's a video of the application so you can see it in action plus some explanation of the Spring code. The controller code for the OAuth functionality and interacting with the Job records is following the jump.</p><figure class="kg-card kg-embed-card"><iframe width="200" height="150" src="https://www.youtube.com/embed/TFNJaHYEK3U?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p><strong>OAuthController</strong></p>
{% highlight js %}package com.appirio.jobs.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.WebRequest;

/**
 * @author Jeff Douglas (jeff@appirio.com)
 */
@RequestMapping("/oauth/**")
@Controller
public class OAuthController {

 private static final String ACCESS_TOKEN = "ACCESS_TOKEN";
 private static final String INSTANCE_URL = "INSTANCE_URL";

 private String clientId = null;
 private String clientSecret = null;
 private String redirectUri = null;
 private String environment = null;
 private String authUrl = null;
 private String tokenUrl = null;
 private String accessToken = null;
 
 private void init() {
  
 redirectUri = "http://blog.jeffdouglas.com//AppirioCareers/oauth/_callback";
 environment = "https://na5.salesforce.com";
 // client id and secret from Force.com Remote Access
 clientId = "YOUR-CLIENT-ID";
 clientSecret = "YOUR-CLIENT-SECRET";
  
  try {
 authUrl = environment + "/services/oauth2/authorize?response_type=code&client_id=" 
  + clientId + "&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8");
  } catch (UnsupportedEncodingException e1) {
 // TODO Auto-generated catch block
 e1.printStackTrace();
  }

  tokenUrl = environment + "/services/oauth2/token";
  
 }
 
 /* Start the OAuth process if no session with the access token is found. 
  * If a session exists, the redirect the user to the /job/list page. */
 @RequestMapping(value = "/oauth/start", method = RequestMethod.GET)
 public String startOauth(WebRequest req) {
  
  init();
  // check for an access token in the servlet session
  accessToken = (String) req.getAttribute(ACCESS_TOKEN, RequestAttributes.SCOPE_SESSION);

  if (accessToken != null) {
 System.out.println("Session found!! Access token: "+accessToken);
 return "forward:/job/list";
  } else {
 System.out.println("No session... need to auth.");  
 return "redirect:" + authUrl;
  }

 }
 
 /* OAuth callback from Force.com after authrozing the application. */
 @RequestMapping(value = "/oauth/_callback", method = RequestMethod.GET)
 public String endOauth(WebRequest req) {

  init();
  String accessToken = null;
  String instanceUrl = null;
  String code = req.getParameter("code");
  HttpClient http = new HttpClient();
  PostMethod post = new PostMethod(tokenUrl);
  post.addParameter("client_secret", clientSecret);
  post.addParameter("redirect_uri", redirectUri);
  post.addParameter("grant_type", "authorization_code");
  post.addParameter("code", code);
  post.addParameter("client_id", clientId);
  
  try {
 JSONObject json = null;
 http.executeMethod(post);
 String respBody = post.getResponseBodyAsString();
 System.out.println("post response: " + respBody);
 try {
  json = new JSONObject(respBody);
  accessToken = json.getString("access_token");
  instanceUrl = json.getString("instance_url");
 } catch (JSONException e) {
  e.printStackTrace();
 }
 System.out.println("found access token: "+accessToken);
 System.out.println("found instance url: "+instanceUrl);
  } catch (IOException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  } finally {
 post.releaseConnection();
  }
  
  System.out.println("Setting Access token: "+accessToken);
  System.out.println("Setting Instance Url: "+instanceUrl);
  
  /* Set the token and url to the session so other servlets can access it. */
  req.setAttribute(ACCESS_TOKEN, accessToken, RequestAttributes.SCOPE_SESSION);
  req.setAttribute(INSTANCE_URL, instanceUrl, RequestAttributes.SCOPE_SESSION);
  
  return "forward:/job/list";
 }

 @RequestMapping
 public String index() {
  return "oauth/index";
 }
}
{% endhighlight %}
<p><strong>JobController</strong></p>
{% highlight js %}package com.appirio.jobs.web;

import java.io.IOException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod; 
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import com.appirio.jobs.domain.Job;
import com.appirio.jobs.domain.SmsMessage;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.Mongo;
import com.mongodb.MongoException;
import com.twilio.sdk.TwilioRestClient;
import com.twilio.sdk.TwilioRestException;
import com.twilio.sdk.TwilioRestResponse;

/**
 * @author Jeff Douglas (jeff@appirio.com)
 */

@RequestMapping("/job/**")
@Controller
public class JobController {
 
 private static final String ACCESS_TOKEN = "ACCESS_TOKEN";
 private static final String INSTANCE_URL = "INSTANCE_URL";
 private static Mongo m;
 private static DB db;
 private static DBCollection coll;
 private static DBCursor cur;
 private ArrayList<Job> jobs = new ArrayList<Job>();
  
  
  @RequestMapping(value="/job/list", method=RequestMethod.GET)
  public ModelAndView list(WebRequest req) {
 
 // if the job collection is empty then fetch jobs from Force.com
 if (jobs.isEmpty()) {
  
  // fetch the access token and url from the servlet session
  String accessToken = (String) req.getAttribute(ACCESS_TOKEN, RequestAttributes.SCOPE_SESSION);
  String instanceUrl = (String) req.getAttribute(INSTANCE_URL, RequestAttributes.SCOPE_SESSION);
  
  System.out.println("Access token: "+accessToken);
  System.out.println("Instance Url: "+instanceUrl);
   
  jobs = new ArrayList<Job>();
 HttpClient httpclient = new HttpClient();
   GetMethod gm = new GetMethod(instanceUrl + "/services/data/v20.0/query");
   //set the token in the header
   gm.setRequestHeader("Authorization", "OAuth "+accessToken);
   //set the SOQL as a query param
   NameValuePair[] params = new NameValuePair[1];
   //no need to url encode here...it will cause your query to fail
   params[0] = new NameValuePair("q","Select Id, Name, Job_Title__c, Location__c, " +
   "Duties__c, Skills__c, Salary__c, Box_Url__c from Job__c Order by Job_Title__c");
   gm.setQueryString(params);
   
   String respBody = "";
 
   try {
  httpclient.executeMethod(gm);
  respBody = gm.getResponseBodyAsString();
  System.out.println("response body: " + respBody);
 } catch (HttpException e1) {
  // TODO Auto-generated catch block
  e1.printStackTrace();
 } catch (IOException e2) {
  // TODO Auto-generated catch block
  e2.printStackTrace();
 } finally {
   gm.releaseConnection();
   }
 
   try {
   JSONObject json = new JSONObject(respBody);    
   JSONArray results = json.getJSONArray("records");
   
   for(int i = 0; i < results.length(); i++) {
    // add the json payload to a Job object
    Job job = new Job(results.getJSONObject(i).getString("Id"), 
  results.getJSONObject(i).getString("Name"),
  results.getJSONObject(i).getString("Job_Title__c"),
  results.getJSONObject(i).getString("Location__c"),
  results.getJSONObject(i).getString("Duties__c"),
  results.getJSONObject(i).getString("Skills__c"),
  results.getJSONObject(i).getString("Salary__c"),
  results.getJSONObject(i).getString("Box_Url__c"));
    
    // add the job to the collection
    jobs.add(job);
   }
   
   
   } catch (JSONException e) {
   e.printStackTrace();
   }
   
   System.out.println("jobs found: "+jobs.size());

 }
 
 ModelAndView mav = new ModelAndView("job/list");
 mav.addObject("jobs", jobs);
 return mav;
  }
 
  @RequestMapping(value="/job/{id}/display", method=RequestMethod.GET)
  public ModelAndView display(@PathVariable String id, Model model) {
 Job job = getJobById(id);
 incrementCount(job.getName(),"views");
 ModelAndView mav = new ModelAndView("job/display");
 mav.addObject(getJobById(id));
 return mav;
  }
  
  @RequestMapping(value="/job/{id}/sms", method=RequestMethod.GET)
  public ModelAndView message(@PathVariable String id, Model model) {
 ModelAndView mav = new ModelAndView("job/sms"); 
 SmsMessage sms = new SmsMessage();
 sms.setPhone("9412274843");
 sms.setMessage("Check out this AWESOME job with Appirio!");
 mav.addObject("smsMessage", sms);
 mav.addObject(getJobById(id));
 return mav;
  }
  
  @RequestMapping(value="/job/{id}/print", method=RequestMethod.GET)
  public String print(@PathVariable String id, Model model) {
 Job job = getJobById(id);
 incrementCount(job.getName(),"downloads");
 System.out.println(job.getBoxUrl());
 return "redirect:"+job.getBoxUrl();
  }
  
  @RequestMapping(value = "/job/{id}/smsSend", method = RequestMethod.POST)
  public ModelAndView smsSubmit(@PathVariable String id, @ModelAttribute SmsMessage sms, Model model) {
 
 Job job = getJobById(id);
 sendSms(job, sms.getPhone(), sms.getMessage());
 incrementCount(job.getName(),"messages");
 
 ModelAndView mav = new ModelAndView("job/smsConfirm"); 
 mav.addObject("phone", sms.getPhone());
 mav.addObject("message", sms.getMessage());
 mav.addObject(job);
 return mav;

  }
  
 private void incrementCount(String name, String type) {
  
  try {
 m = new Mongo("flame.mongohq.com", 27065);
 db = m.getDB("AppirioCareers");
 char[] password = { '4','+','r','E','o','x','x','x','x','x'};
 boolean auth = db.authenticate("jeffdonthemic", password);
 System.out.println("Mongo auth?: "+auth);
 coll = db.getCollection("jobs"); 
  }
  catch (UnknownHostException ex) {
 ex.printStackTrace();
  }
  catch (MongoException ex) {
 ex.printStackTrace();
  }
  
  cur = coll.find(new BasicDBObject("name", name)); 
  while (cur.hasNext()) {
 BasicDBObject doc = (BasicDBObject)cur.next();
 if (type.equals("views"))
  doc.put("views", (Integer)doc.get("views")+1);
 else if (type.equals("messages"))
  doc.put("messages", (Integer)doc.get("messages")+1);
 else
  doc.put("downloads", (Integer)doc.get("downloads")+1);
 coll.update( new BasicDBObject("name", name), doc );
  }
  
 }
  
  private void sendSms(Job job, String phone, String message) {
 
  String AccountSid = "YOUR-ACCOUNT-ID";
  String AuthToken = "YOUR-AUTH-TOKEN";
  String ApiVersion = "2010-04-01";
  
  TwilioRestClient client = new TwilioRestClient(AccountSid, AuthToken, null);
  
  String msg = "n"+message+"n"+job.getJobTitle()+"nhttp://appirio.com/careers";
  
  System.out.println("size: "+msg.length());
  
  //build map of post parameters 
  Map<String,String> params = new HashMap<String,String>();
  params.put("From", "14155992671");
  params.put("To", phone);
  params.put("Body", msg);
  TwilioRestResponse response;
  try {
  response = client.request("/"+ApiVersion+"/Accounts/"+AccountSid+"/SMS/Messages", "POST", params);
  
  if(response.isError())
    System.out.println("Error making outgoing call: "+response.getHttpStatus()+"n"+response.getResponseText());
  else {
    System.out.println(response.getResponseText());

  }
  } catch (TwilioRestException e) {
  e.printStackTrace();
  }
 
  }
  
  private Job getJobById(String id) {
 Job job = null;
 for (Job j : jobs) {
  if (j.getId().equals(id)) {
   job = j;
   break;
  }
 }
 return job;
  }
  
  @RequestMapping
  public String index() {
  return "job/index";
  }
  
}
{% endhighlight %}

