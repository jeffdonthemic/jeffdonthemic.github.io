---
layout: post
title:  Virtual File System for Google App Engine
description: App Engine has a number of security restrictions that it imposes on applications. One that is often cited as a major source of frustration is the inability to read/write to a local file system. It looks like the developer community may have developed a workaround. Kyle Roche sent me a link to a GaeVFS , a distributed, writeable virtual file system for Google App Engine Java. It doesnt actually use the local file system but simulates it using the datastore and memcache. GaeVFS is an Apache Common
date: 2009-10-23 12:01:25 +0300
image:  '/images/slugs/virtual-file-system-for-google-app-engine.jpg'
tags:   ["cloud computing", "google app engine", "gae/j", "java"]
---
<p>App Engine has a number of <a href="http://code.google.com/appengine/docs/whatisgoogleappengine.html" target="_blank">security restrictions</a> that it imposes on applications. One that is often cited as a major source of frustration is the inability to read/write to a local file system. It looks like the developer community may have developed a workaround.</p>
<p><a href="http://www.kyleroche.com" target="_blank">Kyle Roche</a> sent me a link to a <a href="http://code.google.com/p/gaevfs/" target="_blank">GaeVFS</a>, a distributed, writeable virtual file system for Google App Engine Java. It doesn't actually use the local file system but simulates it using the datastore and memcache.</p>
<blockquote>"GaeVFS is an Apache Commons VFS plug-in that implements a distributed, writeable virtual file system for Google App Engine (GAE) for Java. GaeVFS is implemented using the GAE datastore and memcache APIs. The primary goal of GaeVFS is to provide a portability layer that allows you to write application code to access the file system--both reads and writes--that runs unmodified in either GAE or non-GAE servlet environments."</blockquote>
I'm not sure if we have enough time to get this added to <a href="http://links.jeffdouglas.com/book" target="_blank">our book</a> but it may be interesting.
