---
layout: post
title:  Catching Salesforce Outbound Messages with NodeJS
description: When building applications that are integrated with Salesforce  , one of the choices you have to make is how you get data out of Salesforce and into your app. You can use one of the many ETL tools  on the market, you can poll for changed records, use the Force.com Streaming API  , use Apex HTTP Callouts from Salesforce or Outbound Messages . Ive covered most of these approaches in the past but have purposefully overlooked Outbound Messages. Why? Because, in general, I hate working with XML. Perh
date: 2015-02-13 18:37:17 +0300
image:  '/images/pexels-quang-nguyen-vinh-6875132.jpg'
tags:   ["salesforce", "node.js"]
---
<p>When <a href="https://www.topcoder.com/blog/strategies-for-building-customer-facing-apps-with-salesforce-com/">building applications that are integrated with Salesforce</a>, one of the choices you have to make is <strong>how</strong> you get data out of Salesforce and into your app. You can use <a href="http://suyati.com/top-10-etl-tools-salesforce-data-migration/">one of the many ETL tools</a> on the market, you can poll for changed records, use the <a href="http://appirio.com/category/tech-blog/2013/07/the-salesforce-streaming-api-with-example/">Force.com Streaming API</a>, use <a href="https://developer.salesforce.com/page/Apex_Callouts">Apex HTTP Callouts</a> from Salesforce or <a href="https://developer.salesforce.com/page/Outbound_Messaging">Outbound Messages</a>.</p>
<p>I've covered most of these approaches in the past but have purposefully<br>
overlooked Outbound Messages. Why? Because, in general, I hate working with XML. Perhaps it harkens back to my SAP days but every time I have to traverse an XML structure, I think a kitten dies somewhere.</p>
<p><img src="images/grumpy-xml.jpg" alt="" ></p>
<p>However, with that said, Outbound Messages are quite magical. You hook them up as an action to your <a href="https://developer.salesforce.com/page/Workflow_Rules">Workflow Rule</a>, so that whenever a record is, for example, created or updated in some manner, the platform will fire off some record data to the endpoint specified in the Outbound Message. My only issue with them is that they only support XML and most web languages like Ruby, JavaScript, Go, etc. prefer JSON (and so do I). So here's a simple NodeJS app that will receive the XML from your Outbound Message and convert it into a JavaScript object that you can then use to do all sorts of awesome stuff!</p>
<p><strong>You can find all of the <a href="https://github.com/jeffdonthemic/salesforce-obm-catcher">code for this application at my github repo</a>.</strong> What follows is the interesting part that catches the XML and parses it in <a href="https://github.com/jeffdonthemic/salesforce-obm-catcher/blob/master/routes/obm.js">routes/obm.js</a>.</p>
{% highlight js %}var express = require('express');
var _ = require("lodash");
var router = express.Router();

router.post('/', function(req, res) {
 // get the obm as an object
 var message = unwrapMessage(req.body);
 if (!_.isEmpty(message)) {
  // some something #awesome with message
  console.log(message);
  // return a 'true' Ack to Salesforce
  res.send(
 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:out="http://soap.sforce.com/2005/09/outbound"><soapenv:Header/><soapenv:Body><out:notificationsResponse><out:Ack>true</out:Ack></out:notificationsResponse></soapenv:Body></soapenv:Envelope>'
  );
 } else {
  // return a 'false' Ack to Salesforce
  res.send(
 '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:out="http://soap.sforce.com/2005/09/outbound"><soapenv:Header/><soapenv:Body><out:notificationsResponse><out:Ack>false</out:Ack></out:notificationsResponse></soapenv:Body></soapenv:Envelope>'
  );
 }

});

// unwrap the xml and return object
unwrapMessage = function(obj) {
 try {

  var orgId = obj['soapenv:envelope']['soapenv:body'][0].notifications[0].organizationid[0];
  var contactId = obj['soapenv:envelope']['soapenv:body'][0].notifications[0].notification[0].sobject[0]['sf:id'][0];
  var mobilePhone = obj['soapenv:envelope']['soapenv:body'][0].notifications[0].notification[0].sobject[0]['sf:mobilephone'][0];

  return {
 orgId: orgId,
 contactId: contactId,
 mobilePhone: mobilePhone
  };

 } catch (e) {
  console.log('Could not parse OBM XML', e);
  return {};
 }
};

module.exports = router;
{% endhighlight %}
<p>Now we need to setup the Workflow and Outbound Message that will send the data to your NodeJS application. You'll want to change the Workflow to meet your criteria as this one fires every time a Contact record is created or updated and the mobile phone is not blank.</p>
<p><img src="images/obm-workflow.png" alt="" ></p>
<p>The actual Outbound Message below defines the endpoint (you'll notice I'm running it locally using ngrok), the fields from the record to include in the message (the record Id and MobilePhone) and finally "Send Session ID" is checked. You'll probably want to include the Session ID so that you can grab it from the message and use it to quickly make calls back into Salesforce using something like <a href="https://github.com/kevinohara80/nforce">nforce</a>.</p>
<p><img src="images/obm-message.png" alt="" ></p>
<p>If you want to test the application locally you can use something like <a href="https://ngrok.com/">ngrok</a> to securely expose your local web server. Salesforce (thankfully) requires that all endpoints use HTTPS so ngrok comes in handy.</p>
<p>Now if you modify a Contact record in Salesforce, you should see the following in your terminal if everything is configured correctly:</p>
<p><img src="images/obm-terminal.png" alt="" ></p>
<p>There's also a <a href="https://github.com/jeffdonthemic/salesforce-obm-catcher/blob/master/test/obm.js">mocha test</a> you can run to ensure that the XML is being parsed correctly.</p>
<p>There you have it... a simple NodeJS app to get you started using Outbound Messages from Salesforce.</p>
<p><a href="https://www.topcoder.com/blog/catching-salesforce-outbound-messages-with-nodejs/">Cross-posted from the topcoder blog.</a></p>

