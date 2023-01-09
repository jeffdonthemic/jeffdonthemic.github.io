---
layout: post
title:  Google I/O 2010 Recap
description: Im back from Google I/O 2010  in San Francisco and am finally able to take a breath. There were over 5,000 developers, 90+ technical sessions, over 180 companies peddling their tech in the Sandbox and a steady stream of product and technology announcements. It was two action-packed days of deep technical content featuring Android, Google Chrome, Google APIs, GWT, App Engine, open web technologies and much, much more. Im so glad to be working in the cloud with all of this new crap to play with! H
date: 2010-05-24 16:00:00 +0300
image:  '/images/slugs/google-io-2010-recap.jpg'
tags:   ["2010", "public"]
---
<p>I'm back from <a href="http://code.google.com/events/io/2010/">Google I/O 2010</a> in San Francisco and am finally able to take a breath. There were over 5,000 developers, 90+ technical sessions, over 180 companies peddling their tech in the Sandbox and a steady stream of product and technology announcements. It was two action-packed days of deep technical content featuring Android, Google Chrome, Google APIs, GWT, App Engine, open web technologies and much, much more. I'm so glad to be working in the cloud with all of this new crap to play with! Here's a short list of things that stuck out the most for me.</p>
<p>Vic Gundotra (Vice President, Engineering) stated that "I/O" represented "Innovation" and "Openness" and that was the theme throughout the two day event. Google relentlessly bashed Apple for their stance on a number of issues (no Flash, AT&T only, policed App Store, etc) and cemented their "kumbayah" of inclusiveness and standards. Google drove home their support for HTML5, Flash and a new open-source, royalty-free video format called <a href="http://www.webmproject.org/about/">WebM</a>.</p>
<p><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/froyo.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030427/v6mww6ymkvek9xww6cve.png" alt="" ></a><strong>Android, Android and more Android</strong><br>
This might have well been called the "Android Developer's Conference" as most of the emphasis was on their mobile platform. I have to admit that they didn't disappoint. All of Android sessions and labs were packed and some even turned away people. I attended a couple of hacker sessions including development best practices, game development and building REST clients.</p>
<p>Last year Google gave every attendee a Nexus One at the event. This year they were smart and shipped everyone a Nexus One or Droid a month before the event to help them get up and running on the Android platform. Then, to everyone's surprise, they gave everyone on day 2 <strong><em><u>another</u></em></strong> Android device; the <a href="http://now.sprint.com/evo/">Sprint HTC EVO</a> that ships next month. I'm seriously in love with this phone and am considering giving up my iPhone.</p>
<p>The major announcement was the release of Android 2.2 Froyo (Frozen Yogurt). Some of the highlight include:</p>
<ul>
<li>2-5x speed increase with devices running the Dalvik just-in-time (JIT) compiler</li>
<li>2-3x browser speed improvement with the Chrome V8 engine*  Support for Microsoft Exchange</li>
<li>Flash support</li>
<li>Tethering and Portable Hotspot</li>
<li>App Storage on SD - run app directly from the SD card</li>
<li>Update All and Auto-update for applications</li>
</ul>
<p><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/appengine4.jpg"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030509/rbaxgv2hain8cnbe9axw.jpg" alt="" ></a><strong>App Engine for Business</strong><br>
After two years, Google finally announced a service target specifically at small businesses. The service adds management and support features tailored specifically for the enterprise allowing them to take advantage of the core benefits of Google App Engine: easy development using familiar languages (Java and Python); simple administration, with no need to worry about hardware, patches or backups; and effortless scalability. However, some of the details, especially pricing, were fuzzy. My favorite was announced support for SQL databases (presumably MySQL).</p>
<ul>
<li>Centralized administration: A new, company-focused administration console lets companies manage all the applications in their domain.</li>
<li>Reliability and support: 99.9% uptime service level agreement, with premium developer support available.</li>
<li>Secure by default: Only users from the Google Apps domain can access applications and corporate security policies are enforced on every app.</li>
<li>Pricing that makes sense: Each application costs just $8 per user, per month up to a maximum of $1000 a month. This is the part I didn't quite understand as it must be for non-domain users.</li>
<li>Enterprise features: Coming later this year, hosted SQL databases, SSL on the company’s domain for secure communications, and access to advanced Google services.</li>
</ul>
<p><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/wavelogo.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030581/gvi2e46ucvennrrugfoo.png" alt="" ></a><strong>Google Wave</strong><br>
Over the last number of months the Wave team has made a number of enhancements to the service. They've added an <a href="http://googlewave.blogspot.com/2010/05/discover-your-favorite-extension-today.html">extensions gallery</a>, <a href="http://googlewavedev.blogspot.com/2010/03/introducing-robots-api-v2-rise-of.html">Robots API v2</a>, Active Robot API and an <a href="http://googlewavedev.blogspot.com/2010/04/embed-api-improvements-viewing-public.html">anonymous read-only access for embedded waves</a>. They made the statement in a number of sessions that if you tried Wave in the past to please come back and take a look at Wave now given the number of enhancements. Google also went so far as to make Wave available for Google Apps (Standard, Premier and Education Editions). Some features announced at I/O include:</p>
<ul>
<li>Run robots on any server -- not just App Engine. They also announced that you can program robots in <a href="http://code.google.com/p/go/">Google Go</a>.</li>
<li>Use a robot to manipulate and retrieve attachments within a wave</li>
<li>Use the "Wave This" service to let your website's visitors easily create waves out of the content on your site.*  Fetch waves on behalf of users with Wave data APIs</li>
</ul>
<p><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/gwt-logo.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030647/owlacbx0s7zctvvvftqe.png" alt="" ></a><strong>Google Web Toolkit</strong><br>
GWT sessions were quite numerous and popular and the Day 1 keynote revealed some exciting new features. VMware and Google announced a collaboration centered around the Spring programming model, <a href="tp://www.springsource.com/products/sts">SpringSource Tool Suite</a> and <a href="http://www.springsource.org/roo">Spring Roo</a>. The highlights of the announcement include:</p>
<ul>
<li>Tight integration with SpringSource Tool Suite and Spring Roo to provide a polished, productive developer experience</li>
<li>Innovative, close integration between Spring and Google Web Toolkit offering the ability to build rich applications with amazing speed</li>
<li>The ability to easily target Spring applications to Google App Engine</li>
<li>A compelling integration between Spring Insight and Google Speed Tracer to provide insight into the performance of Spring applications from browser to database</li>
</ul>
<p><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/tv_logo.gif"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030714/cjzqgbhowqxkbp2jzfzp.gif" alt="" ></a><strong>Google TV</strong><br>
This was the main announcement of the second half of the Day 2 keynote. A lot of people were surprised as there were talks of a Google tablet in the air. The keynote demo was very interesting as they ran into a number of glitches involving Bluetooth connectivity between the keyboard and set top box (no one thought of bringing a standard keyboard with a cable?). The idea is not new but they are bringing together some industry powerhouses (Sony, Intel, Adobe, Best Buy, Logitech and Dish Network) to bring the concept to market by this Christmas. TechCrunch has a <a href="http://techcrunch.com/2010/05/20/google-tv/">really good review</a> of Google TV.</p>
<p>Some other interesting announcements were:</p>
<ul>
<li><a href="http://code.google.com/apis/storage/">Google Storage for Developers</a> - store your data in Google's cloud</li>
<li><a href="https://chrome.google.com/webstore">Chrome Web Store</a> - an app store for websites</li>
<li><a href="http://code.google.com/apis/predict/">Google Prediction API</a> - machine learning algorithms to analyze your historic data and predict likely future outcomes</li>
<li><a href="http://googlecode.blogspot.com/2010/05/introducing-webfont-loader-in.html">WebFont API</a> - support for web fonts</li>
<li><a href="http://googlecode.blogspot.com/2010/05/introducing-google-buzz-api.html">Google Buzz API</a> - access to the Buzz platform</li>
<li><a href="http://googlecode.blogspot.com/2010/05/with-new-google-latitude-api-build.html">Latitude API</a> - a simple way to share your location with whomever you like</li>
</ul>

