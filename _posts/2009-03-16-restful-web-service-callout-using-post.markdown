---
layout: post
title:  RESTful Web Service Callout using POST with Salesforce.com
description: The addition of asynchronous Web service callouts to external services is a feature that developers have been requesting for quite awhile in Salesforce.com. Using the new @future annotation, your methods execute the callout when Salesforce.com has resources available. One of the great benefits is that it allows you to perform callouts during trigger executions. One method of performing callouts is to import your WSDL and let Apex do all of the heavy lifting (WSDL2Apex). The major problem that I 
date: 2009-03-16 19:27:35 +0300
image:  '/images/slugs/restful-web-service-callout-using-post.jpg'
tags:   ["2009", "public"]
---
<p>The addition of asynchronous Web service callouts to external services is a feature that developers have been requesting for quite awhile in Salesforce.com. Using the new @future annotation, your methods execute the callout when Salesforce.com has resources available. One of the great benefits is that it allows you to perform callouts during trigger executions.</p>
<p>One method of performing callouts is to import your WSDL and let Apex do all of the heavy lifting (WSDL2Apex). The major problem that I found is that Apex does not support RPC/encoded services at this time. Apex does support HTTP Service classes which will allow you to create RESTful services as an alternative. For more information and example code there is a great article entitled <a href="http://wiki.developerforce.com/index.php/Apex_Web_Services_and_Callouts" target="_blank">Apex Web Services and Callouts</a>.</p>
<p>The <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_restful_http_httpresponse.htm" target="_blank">HttpResponse class</a> provides a simple GET example but it was hard to find any examples using POST so I thought I'd throw something together.</p>
{% highlight js %}public class WebServiceCallout {

    @future (callout=true)
    public static void sendNotification(String name, String city) {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('http://my-end-point.com/newCustomer');
        req.setMethod('POST');
        req.setBody('name='+EncodingUtil.urlEncode(name, 'UTF-8')+'&city='+EncodingUtil.urlEncode(city, 'UTF-8'));
        req.setCompressed(true); // otherwise we hit a limit of 32000

        try {
            res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
        }

    }

    // run WebServiceCallout.testMe(); from Execute Anonymous to test
    public static testMethod void testMe() {
        WebServiceCallout.sendNotification('My Test Customer','My City');
    }

}

{% endhighlight %}
<p>You can execute your callout in a trigger with the following example:</p>
{% highlight js %}trigger AccountCallout on Account (after insert) {

	for (Account a : Trigger.new) {
		// make the asynchronous web service callout
		WebServiceCallout.sendNotification(a.Name, a.BillingCity);
	}

}

{% endhighlight %}
<p>A couple of things to remember when using the future annotation:</p>
<ol>
	<li>No more than 10 method calls per Apex invocation</li>
	<li>No more than 200 method calls per Salesforce license per 24 hours</li>
	<li>The parameters specified must be primitive dataypes, arrays of primitive datatypes, or collections of primitive datatypes.</li>
	<li>Methods with the future annotation cannot take sObjects or objects as arguments.</li>
	<li>Methods with the future annotation cannot be used in Visualforce controllers in either getMethodName or setMethodName methods, nor in the constructor.</li>
</ol>
