---
layout: post
title:  Restforce Ruby Gem for Salesforce.com
description:   As one of the committers for the Databasedotcom gem , I follow most of the other committers to see what they are working on. I was pleasantly surprised a few months back when Eric Holmes started pushing code for a project called Restforce . I nearly fell out of my seat when I read that it was billed as a lighter weight alternative to the databasedotcom gem. Well, we been using it for a couple of months now to build our new CloudSpokes API , and I have to say that its a pretty impressive gem. E
date: 2013-01-08 14:04:33 +0300
image:  '/images/slugs/restforce-ruby-gem-for-salesforce-com.jpg'
tags:   ["heroku", "ruby", "salesforce"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327736/restforce_l7vo46.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327736/restforce_l7vo46.png" alt="" title="restforce" width="359" height="79" class="alignnone size-full wp-image-4679" /></a></p>
<p>As one of the committers for the <a href="https://github.com/heroku/databasedotcom">Databasedotcom gem</a>, I follow most of the other committers to see what they are working on. I was pleasantly surprised a few months back when <a href="https://github.com/ejholmes">Eric Holmes</a> started pushing code for a project called "<a href="https://github.com/ejholmes/restforce">Restforce</a>". I nearly fell out of my seat when I read that it was billed as a "lighter weight alternative to the databasedotcom gem".</p>
<p>We'll, we been using it for a couple of months now to build our new <a href="https://github.com/cloudspokes/cs-api">CloudSpokes API</a>, and I have to say that it's a pretty impressive gem. Eric has been consistently refactoring and adding features and it extremely responsive. I've submitted a few issues and he's gotten back to me immediately. <a href="https://github.com/ejholmes/restforce">Check out the repo for complete details</a> but here's a high level overview of the features:</p>
<ul>
<li>A clean and modular architecture using Faraday middleware and Hashie::Mash'd responses. Add your own middleware to Restforce!
<li>Multiple OAuth flows.
<li>Support for interacting with multiple users from different orgs.
<li>Support for parent-to-child relationships.
<li>Support for aggregate queries.
<li>Optional bang CRUD methods (create, update, upsert, destroy) that raise salesforce.com exceptions
<li>Support for the Streaming API with EventMachine
<li>Support for blob data types (uploading files)
<li>Support for GZIP compression.
<li>Support for custom Apex REST endpoints. Winning!!
<li>Support for decoding Force.com Canvas signed requests.</ul>
<p>He's written a number of sample applications in rails and sinatra so if you are writing ruby app that you would like to integrate with salesforce.com, I would highly recommend you check out <a href="https://github.com/ejholmes/restforce">Restforce</a>.</p>

