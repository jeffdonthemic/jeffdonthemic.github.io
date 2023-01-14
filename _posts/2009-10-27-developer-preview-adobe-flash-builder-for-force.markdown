---
layout: post
title:  Developer Preview of the Adobe® Flash® Builder™ for Force.com
description: Cross-posted at theAppirio Technology Blog Yesterday Salesforce.com released a developer preview of the Adobe® Flash® Builder™ for Force.com allowing developers to create powerful, engaging offline applications running on the Force.com platform. I had a chance to download the software, build a sample application and really go through all of the documentation. The product, codename Stratus, is a jointly developed Eclipse-based IDE that combines the Force.com IDE, Flex 4 Builder beta, Flash 4 beta
date: 2009-10-27 13:32:53 +0300
image:  '/images/slugs/developer-preview-adobe-flash-builder-for-force.jpg'
tags:   ["appirio", "salesforce", "flex"]
---
<p>Cross-posted at the <a href="http://techblog.appirio.com/2009/10/developer-preview-of-adobe-flash.html" target="_blank">Appirio Technology Blog</a></p>
<p>Yesterday Salesforce.com <a href="http://developer.force.com/flashbuilder">released a developer preview</a> of the Adobe® Flash® Builder™ for Force.com allowing developers to create powerful, engaging offline applications running on the Force.com platform. I had a chance to download the software, build a sample application and really go through all of the documentation.</p>
<p>The product, codename Stratus, is a jointly developed Eclipse-based IDE that combines the Force.com IDE, Flex 4 Builder beta, Flash 4 beta and LiveCycle Data Services and is tightly integrated with Force.com Connect Offline. It also includes a SQLite database embedded within the Adobe AIR runtime that provides the offline data cache of Salesforce.com data. There is no pricing available yet and Salesforce.com expects final delivery in the first half of 2010.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399474/fig01_poc8ro.jpg"><img class="alignnone size-full wp-image-1548" title="Adobe Flash Builder for Force.com" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399474/fig01_poc8ro.jpg" alt="Adobe Flash Builder for Force.com" width="544" height="198" /></a></p>
<p>Salesforce.com states that you can create both Flex and Air applications with the new offering but it is apparent from their marketing materials, documentation and tutorials that it is squarely aimed for developing offline Air applications. I emailed Dave Carroll and he confirmed that the <a href="http://developer.force.com/flextoolkit">Force.com Toolkit for Adobe AIR and Flex</a> is part of Stratus so you can use the same tool to build offline applications as well as applications that run inside the browser.</p>
<p>Stratus is a new data access and synchronization framework that ships with the offering. Stratus builds on the client-side data management included in Adobe LiveCycle Data Services, but does not include the LCDS server-side data management functionality. A LCDS license is included for Force.com but if you would like to connect to other backend system you'll have to contact Adobe for additional pricing. Stratus provides login functionality, network detection and online and offline data synchronization, a conflict resolution service, and UI components that look and act just like data input fields on Salesforce.com.</p>
<p>The framework includes:</p>
<ul>
	<li>Login functionality including a UI and error messages.</li>
	<li>An API for making multiple, asynchronous, web service requests to the Force.com cloud to retrieve, save, or delete records.</li>
	<li>UI components and data classes for displaying, editing, and managing local data changes.</li>
	<li>The automatic creation and management of a local data store of salesforce.com data for offline support. When importing the Salesforce.com Enterprise WSDL, Stratus generates ActionScript classes for your objects on the Force.com platform.</li>
	<li>An API for saving changes to both the local store and the Force.com cloud.</li>
	<li>Automatic periodic synchronization of data between the local data store and the Force.com cloud.</li>
	<li>Online and offline data synchronization and management.</li>
	<li>Support for "select *" SOQL queries.</li>
</ul>
Dave Carroll has built a <a href="http://wiki.developerforce.com/index.php/Video_building_flash_builder_app">great video</a> on installing, setting up a briefcase for offline data access and creating your first Adobe® Flash® Builder™ for Force.com application.
<p>Adobe has created a <a href="http://www.adobe.com/devnet/salesforce/">developer site</a> with links to relevant info as well as a tutorial <a href="http://www.adobe.com/devnet/salesforce/articles/salesforce_desktop_quickstart.html">Quick start: Create your first Force.com Flex desktop application</a>. If you are interested in the architectural aspects of the offering, you should look at <a href="http://www.adobe.com/devnet/salesforce/articles/salesforce_architecture_overview.html">Understanding data management in applications built with Adobe Flash Builder for Force.com</a>.</p>

