---
layout: post
title:  Snow Leopard Breaks Google Web Toolkit
description: I installed Snow Leopard the other day in under 60 minutes without a hitch.... or so I thought. When trying to run my App Engine project with GWT, I received the following fatal error-  You must use a Java 1.5 runtime to use GWT Hosted Mode on Mac OS X. I did a search and quickly found the culprit. Snow Leopard installs with the 64bit version of the Java 6 JVM but GWT only runs with 32bit version of Java 5 JVM (as of now).The good news is that until Google fixes the issue you can downgrade to th
date: 2009-09-01 04:05:05 +0300
image:  '/images/slugs/snow-leopard-breaks-google-web-toolkit.jpg'
tags:   ["apple", "google app engine", "gwt"]
---
<p>I installed Snow Leopard the other day in under 60 minutes without a hitch.... or so I thought.</p>
<p>When trying to run my App Engine project with GWT, I received the following fatal error:</p>
<blockquote><strong>You must use a Java 1.5 runtime to use GWT Hosted Mode on Mac OS X.</strong></blockquote>
I did a search and quickly found the culprit. Snow Leopard installs with the 64bit version of the Java 6 JVM but GWT only runs with 32bit version of Java 5 JVM (as of now).
<p>The good news is that until Google fixes the issue you can downgrade to the 32bit version of the Java 5 JVM. <a href="http://wiki.oneswarm.org/index.php/OS_X_10.6_Snow_Leopard" target="_blank">Here are the instructions</a>. Good luck!</p>

