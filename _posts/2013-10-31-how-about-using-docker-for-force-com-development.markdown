---
layout: post
title:  How about using Docker for Force.com Development?
description: Docker is an open-source engine that automates the deployment of any application as a lightweight, portable, self-sufficient container that will run virtually anywhere. The great thing about these containers is that they encapsulate any payload and runtime dependencies, and will run consistently on and between virtually any server.   Id heard about Docker a couple of months ago (their github repo is on fire!) and actually met up with a couple of their guys at Monktoberfest. Weve been playing aro
date: 2013-10-31 13:15:30 +0300
image:  '/images/slugs/how-about-using-docker-for-force-com-development.jpg'
tags:   ["2013", "public"]
---
<p><a href="http://www.docker.io/">Docker</a> is an open-source engine that automates the deployment of any application as a lightweight, portable, self-sufficient container that will run virtually anywhere. The great thing about these containers is that they encapsulate any payload and runtime dependencies, and will run consistently on and between virtually any server.</p>
<p><a href="http://www.docker.io/"><img alt="" src="https://www.docker.io/static/img/homepage-docker-logo.png" class="aligncenter" width="400" height="331" /></a></p>
<p>I'd heard about Docker a couple of months ago (their github repo is on fire!) and actually met up with a couple of their guys at Monktoberfest. We've been playing around with Docker at CloudSpokes for a number possible scenarios and that got me thinking: wouldn't it be great if you could use Docker for Force.com development? You could develop locally, deploy the container to a sandbox for testing and then finally deploy it to production once it's ready for primetime. This would be soooo much easier and more efficient than using change sets or ANT.</p>
<p>Docker has an <a href="https://index.docker.io/">index of community runtimes</a> so that you can browse and find Docker container images. I know it's a lot of work, but in theory, Salesforce could push a container with a stripped down version of Force.com with perhaps just what is required to write Apex and Visualforce. Since most of everything on Force.com is Java maybe include some additional jars for workflow, validation, running tests, etc. I know there are A LOT of technical hurdles to jump but this would be a boon to development on Force.com. No longer would you be tied to the internet to write code and test.</p>
<p><strong>I've created <a href="https://success.salesforce.com/ideaView?id=08730000000kxA1AAI">this Idea</a> so please go vote it up if you think this would be a good feature. You know it would be.</strong></p>

