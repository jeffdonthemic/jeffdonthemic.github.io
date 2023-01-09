---
layout: post
title:  Overriding Standard Links with Visualforce Pages
description: One of my most visited blog entries is Redirecting Users To Different Visualforce Pages which shows how you can override the standard Salesforce.com page layouts with your custom Visualforce pages. Based upon a number of emails, it appears that Ive omitted the process of overriding the standard links with these new Visualforce pages. So you have your shiny, new Opportunity display Visualforce page and now you need to tell Salesforce.com to use this new Visualforce page instead of the standard Op
date: 2009-06-26 09:19:58 +0300
image:  '/images/slugs/overriding-standard-links-with-visualforce-pages.jpg'
tags:   ["2009", "public"]
---
<p>One of my most visited blog entries is <a href="/2008/11/14/redirecting-users-to-different-visualforce-pages/" target="_blank">Redirecting Users To Different Visualforce Pages</a> which shows how you can override the standard Salesforce.com page layouts with your custom Visualforce pages. Based upon a number of emails, it appears that I've omitted the process of overriding the standard links with these new Visualforce pages.</p>
<p>So you have your shiny, new Opportunity display Visualforce page and now you need to tell Salesforce.com to use this new Visualforce page instead of the standard Opportunity display page. Salesforce.com provides a handy way to do this so that the platform uses your new Visualforce page whenever someone tries to view an Opportunity.</p>
<p>You can access the list of Standard Links and Buttons for the Opportunity by going to Setup -> Customize -> Opportunity -> Buttons and Links.</p>
<p>Now click the Override link next to the link you would like to override with your Visualforce page.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399535/opportunity-override-list_y80h3o.png"><img class="size-full wp-image-979 alignnone" title="opportunity-override-list" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399535/opportunity-override-list_y80h3o.png" alt="opportunity-override-list" width="435" height="151" /></a></p>
<p>In the Override Properties section, select the Visualforce Page radio button to display the list of available Visualforce pages for the Opportunity object. <em>Only Visualforce pages that implement the Opportunity standard controller will be displayed in this list.</em></p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399534/opportunity-override-details_n1ipcf.png"><img class="size-full wp-image-983 alignnone" title="opportunity-override-details" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399534/opportunity-override-details_n1ipcf.png" alt="opportunity-override-details" width="435" height="126" /></a></p>
<p>The list of buttons and links for Opportunities should now show that your Visualforce page is being used instead of the default Salesfore.com display page.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399533/opportunity-override-list2_koptdc.png"><img class="alignnone size-full wp-image-984" title="opportunity-override-list2" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399533/opportunity-override-list2_koptdc.png" alt="opportunity-override-list2" width="435" height="171" /></a></p>

