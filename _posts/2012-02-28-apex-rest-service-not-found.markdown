---
layout: post
title:  Apex REST Service Not Found?
description: I just deployed an Apex REST service to production and noticed something strange when trying to access it. When calling the URL with my Rails app, I received the error- Could not find a match for URL /v.9/quickquiz/results/today. Strange because the URL worked in my sandbox and there was no difference in the code. I tried with the Apigee Console with the same results. Hmmm.... I was only able to access the URL after  I Ran All Tests in the org. Check out the debug below. 
date: 2012-02-28 17:32:55 +0300
image:  '/images/slugs/apex-rest-service-not-found.jpg'
tags:   ["salesforce"]
---
<p>I just deployed an Apex REST service to production and noticed something strange when trying to access it. When calling the URL with my Rails app, I received the error: "Could not find a match for URL /v.9/quickquiz/results/today". Strange because the URL worked in my sandbox and there was no difference in the code. I tried with the Apigee Console with the same results. Hmmm....</p>
<p>I was only able to access the URL <strong><em>after</em></strong> I "Ran All Tests" in the org. Check out the debug below.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327742/cs-website-_-ruby-_-108_36-1_feltww.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_95,w_300/v1400327742/cs-website-_-ruby-_-108_36-1_feltww.png" alt="" title="cs-website — ruby — 108×36-1" width="300" height="95" class="alignnone size-medium wp-image-4403" /></a></p>

