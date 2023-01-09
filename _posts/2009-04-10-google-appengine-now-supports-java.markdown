---
layout: post
title:  Google App Engine Now Supports Java
description: It only took a year (not bad) but now in addition to Python, Google App Engine now supports Java. This will be a huge boost to App Engine as it opens the service to a wider range of developer. Ive played around with a few apps but I lacked the Python language knowledge to really create anything of substance. I received my confirmation for the Java version yesterday and have just begun to poke around. Some of my favorite features include-  Eclipse Plugin for App Engine * Create applications for b
date: 2009-04-10 16:15:30 +0300
image:  '/images/slugs/google-appengine-now-supports-java.jpg'
tags:   ["2009", "public"]
---
<p><img class="alignleft size-full wp-image-689" title="ae_gwt_java" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399628/ae_gwt_java_zesdmz.png" alt="ae_gwt_java" width="175" height="110" />It only took a year (not bad) but now in addition to Python, Google App Engine now supports Java. This will be a huge boost to App Engine as it opens the service to a wider range of developer. I've played around with a few apps but I lacked the Python language knowledge to really create anything of substance.</p>
<p>I received my confirmation for the Java version yesterday and have just begun to poke around. Some of my favorite features include:</p>
<p><strong>Eclipse Plugin for App Engine</strong></p>
<ul>
	<li>Create applications for both GWT and App Engine</li>
	<li>As-you-type code validation and syntax highlighting</li>
	<li>Run and debug (within Eclipse) applications locally</li>
	<li>App Engine deployment</li>
	<li>Support for JUnit (with datastore also!)</li>
</ul>
<strong>AppEngine Java SDK</strong>
<ul>
	<li>Support for Java 5 & 6 (Awesome!)</li>
	<li>Command line access to Google App Engine</li>
	<li>Dev web server to local testing. The server simulates the runtime functionaltiy of App Engine and all of its services including the datastore</li>
	<li>ANT scripts for common development tasks</li>
	<li>Implementations of JDO and JPI for access to the datastore (includes a query engine)</li>
	<li>Cron and Memcache support</li>
	<li>Authenticate user via Google Accounts</li>
	<li>Uploads via CSV to the datastore</li>
</ul>
I think my first application will be a simple Salesforce.com account browser. I'll see how easy it is to import the Enterprise WSDL and start developing.
<p><strong>Update:</strong> I just found out that the Java Early Look doesn't currently support web services ("We do not currently support JAX-RPC or JAX-WS.") <a href="http://groups.google.com/group/google-appengine-java/web/will-it-play-in-app-engine" target="_blank">Here's a list</a> of what is and is not supported.</p>

