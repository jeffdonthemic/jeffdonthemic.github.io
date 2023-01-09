---
layout: post
title:  INVALIDTAG & ColdFusion
description: We have a content management system that has been in production for a couple of years on the same server running CFMX7. I dont believe weve done anything to the server recently. Today the CMS generated a clients site incorrectly. The Javascript didnt work right nor did any Flash. I poked around the code and a number of script, object and embed tags had been changed to InvalidTag? I serached around and quickly found this post on Ray Camdens site  explaining the situation. So I went into the CFMX 
date: 2007-03-15 14:10:33 +0300
image:  '/images/slugs/invalidtag-coldfusion.jpg'
tags:   ["2007", "public"]
---
<p>We have a <a href="http://www.bluemethod.com/netdango.html" target="_blank">content management system</a> that has been in production for a couple of years on the same server running CFMX7. I don't believe we've done anything to the server recently.</p>
<p>Today the CMS generated a client's site incorrectly. The Javascript didn't work right nor did any Flash. I poked around the code and a number of script, object and embed tags had been changed to <strong>InvalidTag</strong>? I serached around and quickly found <a href="http://ray.camdenfamily.com/index.cfm/2007/1/5/Where-the-heck-is-InvalidTag-coming-from" target="_blank">this post on Ray Camden's site</a> explaining the situation.</p>
<p>So I went into the CFMX admin and unchecked <strong>Enable Global Script Protection</strong>. I recycled CF and generated the site again and still the same problem!</p>
<p>I searched some more and found <a href="http://dzcle.no-ip.com:8080/list.cfm?cat=113" target="_blank">another post</a> explaining how I could alter the internal setting of CF. I tried this and still nothing! I then reset these settings and search further into my application code.</p>
<p>I finally realized that some of the header and footer templates that were used to generate the HTML had the InvalidTag hardcoded into the template. Once I replaced these tags and rebuilt the site it worked like a champ. The setting in the CFMX admin did the trick.</p>

