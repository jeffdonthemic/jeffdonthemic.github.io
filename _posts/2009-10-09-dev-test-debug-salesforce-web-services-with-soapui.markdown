---
layout: post
title:  Dev, Test and Debug Salesforce Web Services with soapUI
description:  If you are doing any type of work with one of the Salesforce web services APIs (enterprise, partner, metadata, etc.), soapUI is an invaluable tool. Its a feature-rich , Java Swing application that runs on your desktop that allows you to inspect, invoke, simulate and test web services. Eviware offers a free version and a commercial version with all of the bells and whistles for $349 per year. You can integrate the soapUI classes in your own Java applications, run it from the command-line or use 
date: 2009-10-09 09:18:03 +0300
image:  '/images/slugs/dev-test-debug-salesforce-web-services-with-soapui.jpg'
tags:   ["2009", "public"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399497/soapui-logo_tuisfz.png"><img class="alignleft size-thumbnail wp-image-1465" style="padding-right:15px;" title="soapui-logo" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/c_crop,h_61,w_150,x_38,y_0/v1400399497/soapui-logo_tuisfz.png" alt="soapui-logo" width="150" height="40" /></a>If you are doing any type of work with one of the Salesforce <a href="http://wiki.developerforce.com/index.php/Web_Services_API" target="_blank">web services APIs</a> (enterprise, partner, metadata, etc.), <a href="http://www.soapui.org" target="_blank">soapUI</a> is an invaluable tool. It's a <a href="http://www.soapui.org/features.html" target="_blank">feature-rich</a>, Java Swing application that runs on your desktop that allows you to inspect, invoke, simulate and test web services.</p>
<p>Eviware offers a free version and a commercial version with all of the bells and whistles for $349 per year. You can integrate the soapUI classes in your own Java applications, run it from the command-line or use it in one of your favorite IDEs (Eclipse, NetBeans or IntelliJ IDEA).</p>
<p>Using soapUI with Salesforce web services is fairly straightforward. Download the WSDL for your favorite web service and create a new soapUI project referencing that WSDL. SoapUI will load all of the methods in the left panel and provide sample requests for each service. You can then run each method against your target org. I typically create test suites of multiple calls (e.g., login, retrieve records, update records and logout) to test my processes.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399477/soapui_nfftaj.png"><img class="aligncenter size-full wp-image-1468" title="soapUI" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399477/soapui_nfftaj.png" alt="soapUI" width="544" height="335" /></a></p>
<p>Some of the main features of the free and commercial versions of soapUI include:</p>
<ul>
	<li>Inspect WSDL and REST web services - includes schema and table inspectors, form output editor, SOAP monitor, JSON viewer and HTML generator for documentation.</li>
	<li>WSDL and REST service invocation - automatically generate requests from associated schemas for multiple endpoints.</li>
	<li>Development and validation - generates server and client code for some of the most popular Web Service toolkits including JBossWS, JWSDP (JAX-WS/JAX-RPC), Axis 1, Axis 2, CXF, XFire, Oracle, .NET and GSoap.</li>
	<li>Load testing - stress test your services and export results, statistics, logs, diagram data, etc. for external processing.</li>
	<li>Simulate web service calls - During your development process you can create mock services and run your processes against them.</li>
</ul>
