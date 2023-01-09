---
layout: post
title:  Open BlueDragon Up and Running in Under 30 Minutes!
description: I had a few minutes to spare this morning so I thought I would install Open BlueDragon on one of our dev servers. In case you dont know, Open BlueDragon is an open source version of BlueDragon , an alternative J2EE CFML engine to Adobe ColdFusion. We have the commercial version of BlueDragon installed on a couple of boxes but this was my first experience with the open source version. Installation was quite simple and fast and my application was up and running in under 30 minutes. After installin
date: 2008-11-20 16:38:14 +0300
image:  '/images/slugs/open-bluedragon-up-and-running-in-under-30-minutes.jpg'
tags:   ["2008", "public"]
---
<p>I had a few minutes to spare this morning so I thought I would install <a href="http://www.openbluedragon.org" target="_blank">Open BlueDragon</a> on one of our dev servers. In case you don't know, Open BlueDragon is an open source version of <a href="http://www.newatlanta.com/products/bluedragon/index.cfm" target="_blank">BlueDragon</a>, an alternative J2EE CFML engine to Adobe ColdFusion. We have the commercial version of BlueDragon installed on a couple of boxes but this was my first experience with the open source version.</p>
<p>Installation was quite simple and fast and my application was up and running in under 30 minutes. After installing the latest JRE on the server, my biggest decision was which version of Open BlueDragon to install:</p>
<ol>
	<li>J2EE WAR - Drop this into your favorite J2EE server (JBoss, Weblogic, Tomcat, etc.) and you are off and running.</li>
	<li>Jetty/OpenBD - Open BlueDragon preconfigured with the Jetty web server. You can basically drop the folder onto your server, make a few configuration changes and start java.</li>
	<li>Amazon EC2 - A pre-configured AMI (CentOS, Open BlueDragon, Jetty, and MySQL) to be used with Amazon's EC2 service.</li>
	<li>VMware - A pre-configured virtual (CentOS, Open BlueDragon, Jetty, and MySQL) that can be imported into VMware.</li>
</ol>
I chose the Jetty/OpenBD option and the process was very smooth and somewhat simple. Since there is no Administrator, everything is done through the jetty.xml configuration file. They provide a sample, documented configuration file that provided me with the syntax for adding a new datasource.
<p>I think my next step is to setup an EC2 instance of Open BlueDragon and see if I can run my personal website off of it.</p>

