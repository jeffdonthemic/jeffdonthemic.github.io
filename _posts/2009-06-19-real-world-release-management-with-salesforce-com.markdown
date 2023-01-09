---
layout: post
title:  Real World Release Management with Salesforce.com
description: Weve been working with Salesforce.com on and off for about a year on their release and change management best practices. Weve had a number of calls with them discussing the Metadata APIs functionality (or lack of functionality) and best practices for release management for large, complex orgs. It looks like theyve taken of our suggestions and experiences to heart as they recently  released their Development Lifecycle Guide  . First let me state that we have a complex org and development environm
date: 2009-06-19 21:14:37 +0300
image:  '/images/slugs/real-world-release-management-with-salesforce-com.jpg'
tags:   ["2009", "public"]
---
<p>We've been working with Salesforce.com on and off for about a year on their release and change management best practices. We've had a number of calls with them discussing the Metadata API's functionality (or lack of functionality) and best practices for release management for large, complex orgs. It looks like they've taken of our suggestions and experiences to heart as they recently <a href="http://blog.sforce.com/sforce/2009/06/new-book-the-forcecom-development-lifecycle-guide.html" target="_blank">released their Development Lifecycle Guide</a>.</p>
<p>First let me state that we have a complex org and development environment. We have a global Saleforce.com project team with multiple projects running concurrently in all continents. We have 15 development sandboxes, 5 test sandboxes, 1 full-copy UAT sandbox and 1 Production box. Our production org consists of 40+ distinct and separately functioning companies with over 500 recordtypes to manage access to data.</p>
<p>The guide is fairly thorough and has a lot of best practices and practical info for orgs of all sizes. My one main criticism of the guide is that in a couple of areas they paint a rosy picture of the migration process and the amount of effort required to migrate configuration items and assets. If you've ever done a moderately complex migration you know that not everything is possible via the Metadata API. This leaves you with some manual processes that are grueling, time-consuming and tedious. For instance, Salesforce.com just completed a moderately sized project for us and they scheduled 40 hours to migrate the manual changes to Production.</p>
<p><strong>Scheduling Releases</strong></p>
<p>For change and release management we've broken our development work into four types with different release timeframes:</p>
<ol>
<li>
<p>Project - these are typically large amounts of work for a specific business (or business stream) requiring multiple resources for development, data migration, testing and training. Projects are released on a monthly based once completed.</p>
</li>
<li>
<p>Major Change - these are changes which may include the creation of new objects, tabs, validation rules, workflows, recordtypes or page layouts. They may also require end-user training, integration with other system and data migration. They changes are also released monthly.</p>
</li>
<li>
<p>Minor Change - these changes are released weekly and may include changes to existing page layouts, picklist values, sharing rules or formulas.</p>
</li>
<li>
<p>Incident - these are released immediately into Production as needed. These are typically bug fixes or changes not relating to metadata.</p>
</li>
</ol>
<p>Release management also requires communication and documentation of changes. The best way to accomplish this is to have a dedicated release manager who is responsible for tracking and documenting all proposed and actual changes to Production. This becomes extremely time consuming, but valuable, when tracking down the cause of errors or migrating an entire project. Ideally, this person is also the one that does the migration but that may not be feasible due to the technical nature of Metadata and Apex migrations.</p>
<p><strong>Application Development Strategy</strong></p>
<p>The guide does a good job illustrating the different development scenarios and resources that are available. Our "ideal" methodology is the one illustrated in the "developing enterprise application" section. Coming from the Java and .NET world, this route is the most familiar to our developers.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399539/dev-method1_pmsrsj.png"><img class="alignnone size-medium wp-image-919" title="development methodology 1" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_182,w_300/v1400399539/dev-method1_pmsrsj.png" alt="development methodology 1" width="300" height="182" /></a></p>
<p>However, after much debating and testing, we came to the conclusion that this approach is simply not workable with our available resources for large projects. In a perfect world (i.e. where you can push all code and config cleanly from box to box) this approach is great but there are too many manual, time-consuming processes in the real world. Our businesses (and finance) were demanding us to deliver projects and changes faster with less resources. The proposed process above increased our time to production and the number of resources needed. Until the Metadata API is capable of pushing everything to Production cleanly and reliably, we have come up with the following development and deployment methodology:</p>
<p><strong>Click the image for a larger view.</strong></p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399538/dev-method2_elzti8.png"><img class="alignnone size-medium wp-image-920" title="development methodology 2" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399538/dev-method2_elzti8.png?w=188" alt="development methodology 2" width="188" height="300" /></a></p>
<p>Essentially, we try to do all of the config in Production and then refresh to a sandbox for code and process development. We've run into problems when doing migrations with RecordtypeIds and PricebookEntryId and trying to migrate them. We've found that for security, profile and integration purposes, you should create these in Production and refresh to your development sandbox. Therefore, if you do migrate profiles, page layouts, etc using the Metadata API you will have a much greater chance of success if these IDs are identical.</p>
<p><strong>Learned Lessons</strong></p>
<p>During long development cycles it is very likely that your sandbox(es) will become out of synch. You may have objects from other projects that are required for your sandbox that need to be created, security settings that need to be applied manually due to data integration issues or Salesforce.com upgrades that wipeout or implement new functionality. Another common scenario may be that you need to refresh your full-copy sandbox for UAT testing for a specific project but you have another project preventing this as it has not yet been tested and put into Production.</p>
<p>The Metadata API is not quite ready for this type of development process. Don't get me wrong, I love the Metadata API (it's getting better each release) but there are still some basic things you cannot migrate such as standard picklist values and role hierarchies. Salesforce.com finally came out with a list of things the API can and cannot do. This was a huge step as we had been hounding them for this information for months.</p>
<p>Migration dependencies are one of the frustrating and aggravating aspects of this process. There are many cases where your migration crashes due to a code, static resource or parent-child dependency. We've discovered the hard way that the order of migrations is sometimes the key to success. Unfortunately Salesforce.com does not provide clear examples.</p>
<p><strong>Upcoming Migration Tools</strong></p>
<p>We had a sneak-peak a few weeks ago at a new deployment tool coming this Winter from Salesforce.com which should make everyone much happier. The product manager was quick to point out that this new tool is dependent upon proposed functionality in the Metadata API so hopefully all will be released together.</p>

