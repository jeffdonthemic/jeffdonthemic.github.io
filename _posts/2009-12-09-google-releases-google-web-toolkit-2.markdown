---
layout: post
title:  Google Releases Google Web Toolkit 2.0
description: Google releasedGoogle Web Toolkit 2.0  (GWT) yesterday with some really cool features and improvements. For those of you not familiar with GWT, it is a development toolkit for building and optimizing complex browser-based applications. You write your front-end code in Java and it is auto-magically compiled into cross browser, optimized JavaScript. GWT is used by many products at Google, including Google Wave and Google AdWords. Its open source, completely free, and used by thousands of developer
date: 2009-12-09 13:12:29 +0300
image:  '/images/slugs/google-releases-google-web-toolkit-2.jpg'
tags:   ["google", "gwt"]
---
<p>Google released <a href="http://code.google.com/gwt" target="_blank">Google Web Toolkit 2.0</a> (GWT) yesterday with some really cool features and improvements. For those of you not familiar with GWT, it is a development toolkit for building and optimizing complex browser-based applications. You write your front-end code in Java and it is auto-magically compiled into cross browser, optimized JavaScript.</p>
<p>GWT is used by many products at Google, including Google Wave and Google AdWords. It's open source, completely free, and used by thousands of developers around the world.</p>
<p>The video below does a really nice feature overview but here are some of my bullet points from the video. You can <a href="http://code.google.com/webtoolkit/doc/latest/ReleaseNotes.html" target="_blank">find more detailed info on the new features here</a>.</p>
<ul>
	<li><strong>Declarative User Interface</strong> - gone are the days of programmatically laying out your application in a Swing type manner. Similar to Adobe Flex, the new <strong>UiBinder</strong> allows you to lay out your user interface in an XML file and then bind that to a Java class that contains applications logic. This is my favorite new feature!</li>
	<li><strong>Speed Tracer</strong> - a new tool that helps you analyze the performance of any web page and understand where the various sources of latency are.</li>
	<li><strong>Easier Styling</strong> - with the new <strong>UiStyle</strong> feature you can write CSS styles and bundle them directly in the template. You get the speed benefit of no extra http roundtrip to fetch an external the stylesheet and prevent name conflicts across your application when using widgets.</li>
	<li><strong>Predictable Performance</strong> - provide a consistent look and feel with improved layout panels that behave predictably and load quickly.</li>
	<li><strong>Debug in any Browser</strong> - no more requirement to use the embedded browser when debugging Java source code. You can now debug in essentially any browser and use development tools for that browser like Firebug in Firefox.</li>
	<li><strong>Faster Load Times</strong> - Developer-guided code splitting allows you to chunk your GWT code into multiple fragments for faster startup.</li>
	<li><strong>Improved IDE Support</strong> - the new Eclipse plugin provides support for the UiBinder, client bundling, RPC refactoring, wizards to generate boilerplate code and the new development mode.</li>
</ul>
There are a ton of additional features and you can <a href="http://code.google.com/webtoolkit/doc/latest/ReleaseNotes.html" target="_blank">check them out here</a>. Download GWT today and get started building some kickass apps!<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/uExEw3OVMd0?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure>
