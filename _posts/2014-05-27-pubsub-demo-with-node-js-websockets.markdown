---
layout: post
title:  PubSub Demo with Node.js & WebSockets
description: I started a new series on the  blog called Phasers on Innovate where I simply talk about cool tech stuff and build things. Late last year Heroku started supporting WebSockets so I thought I would take a stab at rewriting our Corona application which currently uses Socket.io. Corona was a nifty little app we had over at CloudSpokes that popped pins on a map in real-time whenever members would login, ask questions, submit for challenges, etc. The app was mesmerizing in that it would show the activ
date: 2014-05-27 13:36:47 +0300
image:  '/images/slugs/pubsub-demo-with-node-js-websockets.jpg'
tags:   ["heroku", "node.js", "phasers on innovate"]
---
<p>I started a new series on the <a href="http://www.topcoder.com/category/phasers-on-innovate/">[topcoder] blog</a> called "Phasers on Innovate where I simply talk about cool tech stuff and build things.</p>
<p>Late last year Heroku started supporting WebSockets so I thought I would take a stab at rewriting our Corona application which currently uses Socket.io. Corona was a nifty little app we had over at CloudSpokes that popped pins on a map in real-time whenever members would login, ask questions, submit for challenges, etc.</p>
<p>The app was mesmerizing in that it would show the activity on the platform by geography and you could literally sit and watch the map all day.</p>
<p>So I put togther a little video on how pubsub works with node and websockets. Hope you find it useful. <strong>You can find the <a href="https://github.com/cloudspokes/corona-server/blob/master/app.js">server</a> and <a href="https://github.com/cloudspokes/corona-server/blob/master/sample-client.js">client</a> code on our github repo</strong>.</p>
<div class="flex-video"><iframe width="640" height="480" src="//www.youtube.com/embed/1ni9-c6vlvs" frameborder="0" allowfullscreen></iframe></div>
