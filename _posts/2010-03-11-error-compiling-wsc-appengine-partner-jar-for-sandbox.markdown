---
layout: post
title:  Error Compiling WSC AppEngine Partner Jar for Salesforce.com Sandbox
description: Im working on a demo for Google App Engine that connects to one of our Salesforce.com Sandboxes (hope to be done tomorrow or Monday). The Force.com Web Service Connector (WSC) project  has a partner-library.jar that you can download and add to your project to get up and running quickly. However, if you want to connect to a Sandbox you have to download your Partner WSDL from your Sandbox and compile it with the wsc-gae-160.jar to generate the stub code. To generate the stub code, run the followin
date: 2010-03-11 21:59:41 +0300
image:  '/images/slugs/error-compiling-wsc-appengine-partner-jar-for-sandbox.jpg'
tags:   ["2010", "public"]
---
<p style="clear: both">I'm working on a demo for Google App Engine that connects to one of our Salesforce.com Sandboxes (hope to be done tomorrow or Monday). The <a href="http://code.google.com/p/sfdc-wsc/" target="_blank">Force.com Web Service Connector (WSC) project</a> has a partner-library.jar that you can download and add to your project to get up and running quickly. However, if you want to connect to a Sandbox you have to download your Partner WSDL from your Sandbox and compile it with the wsc-gae-160.jar to generate the stub code.</p><p style="clear: both">To generate the stub code, run the following from the terminal:</p>
<blockquote style="clear: both"><p><strong>java -classpath wsc.jar com.sforce.ws.tools.wsdlc wsdl jar.file</strong></p></blockquote><p style="clear: both">Where <strong>wsdl</strong> is the name of the partner WSDL file you downloaded and <strong>jar.file</strong> is the output jar file that is generated.</p><p style="clear: both">The problem is that seems to throw an exception on a Mac:</p>
{% highlight js %}Exception in thread "main" java.lang.NullPointerException at
com.sforce.ws.tools.wsdlc.checkTargetFile(wsdlc.java:115) at 
com.sforce.ws.tools.wsdlc.<init>(wsdlc.java:66) at
com.sforce.ws.tools.wsdlc.run(wsdlc.java:288) at
com.sforce.ws.tools.wsdlc.main(wsdlc.java:279)
{% endhighlight %}
<p style="clear: both"><br />The fix is documented <a href="http://code.google.com/p/sfdc-wsc/wiki/GettingStarted" target="_blank">here</a> but you essentially need to supply the entire path for the outputted jar file:</p><blockquote style="clear: both"><p><strong>java -classpath wsc-gae-16_0.jar com.sforce.ws.tools.wsdlc chatter-sandbox-partner.wsdl /users/jeff/desktop/chatter-sandbox-partner.jar</strong></p></blockquote><p style="clear: both"></p><br class="final-break" style="clear: both" />
