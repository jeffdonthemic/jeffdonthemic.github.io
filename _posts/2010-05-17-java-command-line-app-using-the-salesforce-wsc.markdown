---
layout: post
title:  Java Command Line App Using the Salesforce WSC
description:   Force.com Web Service Connector (WSC) is a high performance web services stack that is much easier to implement than the tried and true Force.com Web Services API . Heres a quick command line app you can use as a starter application. This class simply creates a new Account and then queries for the 5 newest Accounts by created date. To get started, download wsc-18.jar from the WSC projects download page  to your desktop (any location will do). Now log into your Developer org and download the Pa
date: 2010-05-17 11:42:27 +0300
image:  '/images/slugs/java-command-line-app-using-the-salesforce-wsc.jpg'
tags:   ["2010", "public"]
---
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328494/wsc-logo_yswghf.png" alt="" ></p>
<p>Force.com Web Service Connector</a> (WSC) is a high performance web services stack that is much easier to implement than the "tried and true" <a href="http://www.salesforce.com/us/developer/docs/api/index.htm" target="_blank">Force.com Web Services API</a>. Here's a quick command line app you can use as a starter application. This class simply creates a new Account and then queries for the 5 newest Accounts by created date.</p>
<p>To get started, download wsc-18.jar from the <a href="http://code.google.com/p/sfdc-wsc/downloads/list" target="_blank">WSC project's download page</a> to your desktop (any location will do). Now log into your Developer org and download the Partner WSDL (Setup -> App Setup -> Develop -> API) to your desktop as "partner.wsdl". Now we'll need to generate the stub code from the Partner WSDL. Make sure you have Java 1.6 installed and open a command prompt. Now run wsdlc on the Partner WSDL you just downloaded (detailed instruction are <a href="http://code.google.com/p/sfdc-wsc/wiki/GettingStarted" target="_blank">here</a>):</p>
<blockquote>java -classpath wsc-18.jar com.sforce.ws.tools.wsdlc partner.wsdl partner.jar</blockquote>
<p>This will create a "partner.jar" file on your desktop. If you are using a Sandbox instead of a Developer or Production org, <a href="/2010/03/11/error-compiling-wsc-appengine-partner-jar-for-sandbox/" target="_blank">here are instructions</a> for running wsdlc as there are a few issues. Your console should look similar to:</p>
<p><a href="/2010/05/17/java-command-line-app-using-the-salesforce-wsc/wsc-console/" rel="attachment wp-att-2570"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328493/wsc-console_jyxslk.png" alt="" title="wsc-console" width="550" class="alignnone size-full wp-image-2570" /></a></p>
<p>Note: You can also simply download the partner-18.jar and bypass the steps above to generate the partner.jar.</p>
<p>Now create a new Java project in Eclipse, add the wsc-18.jar and partner.jar files to your build path and copy the code below. You'll need to add your username and password/security token before you run the code. Running the code should produce output similar to:</p>
<p><a href="/2010/05/17/java-command-line-app-using-the-salesforce-wsc/wsc-run/" rel="attachment wp-att-2583"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328492/wsc-run_f0hkof.png" alt="" title="wsc-run" width="402" height="169" class="alignnone size-full wp-image-2583" /></a></p>
<p>Here's the starter code for the application.</p>
{% highlight js %}package com.jeffdouglas;

import com.sforce.soap.partner.*;
import com.sforce.soap.partner.sobject.*;
import com.sforce.ws.*;

public class Main {

 public static void main(String[] args) {

  ConnectorConfig config = new ConnectorConfig();
  config.setUsername("YOUR-USERNAME");
  config.setPassword("YOUR-PASSWORD-AND-SECURITYTOKEN");

  PartnerConnection connection = null;
  
  try {
 
 // create a connection object with the credentials
 connection = Connector.newConnection(config);
 
 // create a new account
 System.out.println("Creating a new Account...");
 SObject account = new SObject();
 account.setType("Account");
 account.setField("Name", "ACME Account 1");
 SaveResult[] results = connection.create(new SObject[] { account });
 System.out.println("Created Account: " + results[0].getId());
 
 // query for the 5 newest accounts
 System.out.println("Querying for the 5 newest Accounts...");
 QueryResult queryResults = connection.query("SELECT Id, Name from Account " +
   "ORDER BY CreatedDate DESC LIMIT 5");
 if (queryResults.getSize() > 0) {
  for (SObject s: queryResults.getRecords()) {
   System.out.println("Id: " + s.getField("Id") + " - Name: "+s.getField("Name"));
  }
 }
 
  } catch (ConnectionException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  }

 }

}
{% endhighlight %}

