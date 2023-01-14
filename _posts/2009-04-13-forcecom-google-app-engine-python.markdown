---
layout: post
title:  Force.com Demo App on Google App Engine (Python)
description:  When Google announced  the other day that they were supporting Java I started to dream about all of the cool Java / Salesforce.com apps that I could write. Then I read through the Will it play in App Engine page and my heart skipped a beat. There in black and white it stated, We do not currently support JAX-RPC or JAX-WS. How was I supposed to write Salesforce.com integration application when I couldnt invoke web services?  Devastated, I turned my efforts towards building a Force.com applicatio
date: 2009-04-13 16:00:00 +0300
image:  '/images/slugs/forcecom-google-app-engine-python.jpg'
tags:   ["google app engine", "salesforce", "python"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399627/google_appengine_dwcy7t.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399627/google_appengine_dwcy7t.png" alt="" title="google_appengine" width="175" height="175" class="alignleft size-full wp-image-743" /></a>When <a href="/2009/04/10/google-appengine-now-supports-java/" target="_blank">Google announced</a> the other day that they were supporting Java I started to dream about all of the cool Java / Salesforce.com apps that I could write. Then I read through the <a href="http://groups.google.com/group/google-appengine-java/web/will-it-play-in-app-engine?pli=1" target="_blank">Will it play in App Engine</a> page and my heart skipped a beat. There in black and white it stated, "We do not currently support JAX-RPC or JAX-WS." How was I supposed to write Salesforce.com integration application when I couldn't invoke web services?</p>
<p>Devastated, I turned my efforts towards building a Force.com application on Google App Engine with Python. I had written a number of Python applications for Salesforce.com but I had always just called Apex web services when needed. I thought I would take a crack at the <a href="http://developer.force.com/appengine" target="_blank">Python Toolkit</a>. The installation was simple enough and the Toolkit includes a number of examples (unit test) to get you up and running quickly.</p>
<p>I threw together a <a href="https://jeffdouglas-salesforce1.appspot.com/" target="_blank">small demo app</a> that connects to my Developer Org and provides the following functionality:</p>
<ol>
	<li>Create a new Account</li>
	<li>Search for Accounts by keyword</li>
	<li>View an Account and all Opportunities for the Account</li>
	<li>Create a new Opportunity for an Account</li>
</ol>
You can find the demo application and source code at <a href="https://jeffdouglas-salesforce1.appspot.com/" target="_blank">https://jeffdouglas-salesforce1.appspot.com</a>.
<p>During the development process, I started to think of ways to get around the lack of web services functionality in the Java Early Look. Perhaps I could use Python to expose the Force.com platform as REST web services and have the Java Early Look call these services?</p>

