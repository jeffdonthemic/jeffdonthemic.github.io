---
layout: post
title:  Demo App - Salesforce on Heroku (Java) with Play! Framework
description: At Dreamforce a couple of weeks ago, Heroku announced the public beta for the Play! Framework on their cedar stack. So if you love Java but hate the pain associated with developing web apps, then the Play Framework is for you. Its essentially a Ruby on Rails framework for Java. It makes Java development fun again!  To get started, check out the Play! on Heroku blog post as it has everything you need to get started with a simple Hello World app. Theres also a Getting Started with Play! on Heroku/
date: 2011-09-26 13:33:23 +0300
image:  '/images/slugs/telesales-play.jpg'
tags:   ["2011", "public"]
---
<p>At Dreamforce a couple of weeks ago, <a href="http://blog.heroku.com/archives/2011/8/29/play/">Heroku announced the public beta</a> for the <a href="http://www.playframework.org/">Play! Framework</a> on their cedar stack. So if you love Java but hate the pain associated with developing web apps, then the Play Framework is for you. It's essentially a Ruby on Rails framework for Java. It makes Java development fun again!</p>
<p>To get started, check out the <a href="http://blog.heroku.com/archives/2011/8/29/play/">Play! on Heroku blog post</a> as it has everything you need to get started with a simple Hello World app. There's also a <a href="http://devcenter.heroku.com/articles/play">Getting Started with Play! on Heroku/Cedar article</a> for more info.</p>
<p>Once again, this is a demo Java app running on Heroku using the Play! Framework. It uses the Force.com Web Service Connector (WSC) and the Partner jar to connect to a DE salesforce.com org. It uses the web services API to query for records, retrieve records to display, create new records and update existing ones. It should be good fodder for anyone wanting to start out with Play! and Force.com.</p>
<p><span style="font-size:x-large"><a href="http://telesales-play.herokuapp.com/">You can run the app for yourself here.</a></span></p>
<p>All of the <a href="https://github.com/jeffdonthemic/Telesales-Play">code for this app is at github</a> so fork awey. I’ve pulled out some of the more important parts of the app for a quick peek. There's also an overview of one of the important classes to give you something to look at.</p>
<p><strong>app/controllers/Account.java</strong></p>
<p>The account controller contains all of the business logic for integration with Force.com and then packages up the returns for the views.</p>
{% highlight js %}package controllers;

import play.*;
import play.mvc.*;
import java.util.*;

import models.*;
import service.*;
import com.sforce.soap.partner.*;
import com.sforce.ws.ConnectionException;
import com.sforce.soap.partner.sobject.SObject;

public class Account extends Controller {

 public static void create() {
  render();
 }
 
 // create the record in salesforce
 public static void createSubmit() {
 
  SaveResult[] results = null;
   
  // populate the new opportunity
  SObject a = new SObject();
  a.setType("Account");
  a.setField("Name", params.get("name"));
  a.setField("BillingCity", params.get("city"));
  a.setField("BillingState", params.get("state"));
  a.setField("Phone", params.get("phone"));
  a.setField("Website", params.get("website"));
  
  SObject[] accounts = {a};
  
  // get a reference to the connection
  PartnerConnection connection = ConnectionManager.getConnectionManager().getConnection();
  
  try {
 results = connection.create(accounts);
 
 // check for any errors
 if ( results[0].isSuccess() ) {
   System.out.println("Successfully created Account: " + results[0].getId());
 } else {
   System.out.println("Error: could not create Accout: " + results[0].getErrors()[0].getMessage());
 }
 
  } catch (ConnectionException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  }
  
  redirect("/account/"+results[0].getId() );
 }

 // fetch the account and all related opportunities to display
 public static void display() {

  if (params.get("id") != null) {
 
 // add the account id to the array to be retrieved
 String[] accountIds = { params.get("id") };

 SObject[] accounts = null;
 QueryResult result = null;
 
 // get a reference to the connection
 PartnerConnection connection = ConnectionManager.getConnectionManager().getConnection();
 
 try {
  accounts = connection.retrieve("Id, Name, Phone, BillingCity, BillingState, Website","Account", accountIds);
  result = connection.query("Select id, name, stagename, amount, closeDate, probability, ordernumber__c from Opportunity where AccountId = '"+params.get("id")+"'");
 } catch (ConnectionException e) {
  e.printStackTrace();
 } catch (NullPointerException npe) {
  System.out.println("NullPointerException: "+npe.getCause().toString());
 }
 
 renderArgs.put("account", accounts[0]);
 renderArgs.put("opportunities", result.getRecords());

  }

  render();
 }

 // fetch the account so we can show the edit form with data
 public static void edit() {

  if (params.get("id") != null) {
 
 // add the account id to the array to be retrieved
 String[] accountIds = { params.get("id") };
 SObject[] accounts = null;
 
 // get a reference to the connection
 PartnerConnection connection = ConnectionManager.getConnectionManager().getConnection();
 
 try {
  accounts = connection.retrieve("Id, Name, Phone, BillingCity, BillingState, Website","Account", accountIds);
 } catch (ConnectionException e) {
  e.printStackTrace();
 } catch (NullPointerException npe) {
  System.out.println("NullPointerException: "+npe.getCause().toString());
 }
 
 renderArgs.put("account", accounts[0]);

  }

  render();
 }

 // update the record in salesforce
 public static void editSubmit() {
   
  SaveResult[] results = null;
 
  // populate the account to update
  SObject a = new SObject();
  a.setType("Account");
  a.setId(params.get("id"));
  a.setField("Billingcity", params.get("BillingCity"));
  
  SObject[] accounts = {a};
  
  // get a reference to the connection
  PartnerConnection connection = ConnectionManager.getConnectionManager().getConnection();
  
  try {
 results = connection.update(accounts);
 
 // check for any errors
 if ( results[0].isSuccess() ) {
   System.out.println("Successfully updated Account: " + results[0].getId());
 } else {
   System.out.println("Error: could not update Account: " + results[0].getErrors()[0].getMessage());
 }
 
  } catch (ConnectionException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  }
 
  redirect("/account/"+params.get("id") );
 }

}
{% endhighlight %}
<p><strong>app/views/display.html</strong></p>
<p>The account display view displays the account details and any related opportunities.</p>
{% highlight js %}#{extends 'main.html' /}
#{set title:'Account Details' /}

<span class="nav"><a href="/opportunity">Search</a></span><p/>
<span class="title">Account Display</span>
<p/>

<table id="fancytable">
 <tr>
  <td class="label">Name</td>
  <td>${ account.getField("Name") }</td>
 </tr>
 <tr>
  <td class="label">City</td>
  <td>${ account.getField("BillingCity") }</td>
 </tr>
 <tr>
  <td class="label">State</td>
  <td>${ account.getField("BillingState") }</td>
 </tr>
 <tr>
  <td class="label">Phone</td>
  <td>${ account.getField("Phone") }</td>
 </tr>
 <tr>
  <td class="label">Website</td>
  <td>${ account.getField("Website") }</td>
 </tr> 
</table>
  
<br><a href="/opportunity/create/${ account.getField("Id") }">Create a new Opportunity</a> 
or <a href="/account/${ account.getField("Id") }/edit">edit this Account</a><p/> 

%{ if (opportunities.length > 0) { }%

 <p/><span class="heading">Opportunities for ${ account.getField("Name") }</span><br><p/>
 
 <table id="fancytable">
 <tr>
  <td class="label">Name</td>
  <td class="label">Amount</td>
  <td class="label">Stage</td>
  <td class="label">Probability</td>
  <td class="label">Close Date</td>
  <td class="label">Order</td>
 </tr>
 #{list items:opportunities, as:'o' }
  <tr>
 <td nowrap>${ o.getField("Name") }</td>
 <td>$${ o.getField("Amount") }</td>
 <td>${ o.getField("StageName") }</td>
 <td>${ o.getField("Probability") }</td>
 <td>${ o.getField("CloseDate") }</td>
 <td>${ o.getField("OrderNumber__c") }</td>
  </tr>
 #{/list}
 </table>

%{ } else { }%
 <p/><span class="heading">No Opportunities found for ${ account.getField("Name") }</span>
%{ } }%
{% endhighlight %}

