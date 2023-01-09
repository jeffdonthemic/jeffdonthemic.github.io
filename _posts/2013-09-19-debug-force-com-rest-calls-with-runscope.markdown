---
layout: post
title:  Debug Force.com REST Calls with Runscope
description: I love APIs. I love to build them, cURL them, read their source code and talk about them. One of the aspects that I havent loved so much is debugging them. That is until I found Runscope . Weve been using the service for a couple of months and its made debugging, testing and/or inspecting APIs sooo much easier. Of course Runscope works for all languages and essentially any REST API but weve found it especially helpful to build, test and debug Force.com REST calls. Runscope was co-founded by John
date: 2013-09-19 12:56:11 +0300
image:  '/images/slugs/debug-force-com-rest-calls-with-runscope.jpg'
tags:   ["2013", "public"]
---
<p>I love APIs. I love to build them, cURL them, read their source code and talk about them. One of the aspects that I haven't loved so much is debugging them. That is until I found <a href="http://www.runscope.com" target="_blank">Runscope</a>. We've been using the service for a couple of months and it's made debugging, testing and/or inspecting APIs sooo much easier. Of course Runscope works for all languages and essentially any REST API but we've found it especially helpful to build, test and debug Force.com REST calls.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_300,w_257/v1400327589/keep-calm-and-love-apis-8_brcv2f.png" alt="" ></p>
<p>Runscope was co-founded by John Sheehan who also loves APIs. I've know John since his Twilio days and he's done an awesome with Runscope. The interface is very clean and service is intuitive and easy to use. If you are interested in APIs, you should subscribe to his <a href="http://apidigest.com/" target="_blank">API Digest newsletter</a>.</p>
<p>Check out the video below on how to use Runscope with your Force.com REST APIs but in a nutshell here's how it works. It's a pretty simple process:</p>
<ol>
	<li>Sign up for a free Runscope account</li>
	<li>Use the Runscope URL for the REST calls in your application to Force.com. For instance, your calls to http://cs8.salesforce.com will look something like http://cs8-salesforce-com-g0aderfwxe.runscope.net</li>
	<li>Once requests are captured, view your calls to Force.com in detail with the Traffic Inspector. Complete request and response data (URL, querystring parameters, form data, status, etc.) is available. There's also a sweet little inspector where you can compare the deltas of two different calls!</li>
	<li>You can also create a shareable link to give to someone else to send, view, and comment on any of your API calls.</li>
</ol>
<p>If you sign up for the paid version, you can use their Passageway service which allows you and your team to temporarily share your local development web server with others via a public URL. You can then of course run requests for localhost through Runscope and inspect traffic. Brillant!</p>
<div class="flex-video"><iframe width="560" height="315" src="//www.youtube.com/embed/jbIzoPXghWs" frameborder="0" allowfullscreen></iframe></div>

