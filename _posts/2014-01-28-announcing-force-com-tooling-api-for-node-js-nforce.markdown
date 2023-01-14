---
layout: post
title:  Announcing Force.com Tooling API for Node.js (nforce)
description: Over Christmas break I stared playing around with the Force.com Tooling API in node.js. We have some ideas over at topcoder for the Tooling API and I wanted to build a POC to see how crazy I was. After a couple of days I started to realize how cool the Tooling API could be and the development impact it could make. Ive always been big fan and user of  Kevin OHara s nforce package so I emailed him to see if he would be interested in including it in nforce. After a few emails we decided to go the  
date: 2014-01-28 17:04:17 +0300
image:  '/images/slugs/announcing-force-com-tooling-api-for-node-js-nforce.jpg'
tags:   ["salesforce", "node.js"]
---
<p><a href="https://github.com/jeffdonthemic/nforce-tooling"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327577/nforce-tooling_jozquk.png" alt="nforce-tooling" width="250" class="alignleft size-full wp-image-5151" /></a>Over Christmas break I stared playing around with the <a href="http://www.salesforce.com/us/developer/docs/api_tooling/index.htm" target="_blank">Force.com Tooling API</a> in node.js. We have some ideas over at <a href="http://www.topcoder.com" target="_blank">topcoder</a> for the Tooling API and I wanted to build a POC to see how crazy I was.</p>
<p>After a couple of days I started to realize how cool the Tooling API could be and the development impact it could make. I've always been big fan and user of <a href="http://developer.force.com/mvp_profile_ohara" target="_blank">Kevin O'Hara</a>'s <a href="https://github.com/kevinohara80/nforce" target="_blank">nforce package</a> so I emailed him to see if he would be interested in including it in nforce. After a few emails we decided to go the <a href="http://passportjs.org/" target="_blank">Passport</a> route and implement the new functionality with plugins that could be developed and maintained independently and not "muddy-up" the core nforce package. Brilliant! My guess is that there are more plugins coming down the road for nforce ;).</p>
<p>So while Kevin essentially rewrote nforce (added plugin functionality, improved performance, simpler signatures, etc), I worked on the <a href="https://github.com/jeffdonthemic/nforce-tooling" target="_blank">nforce-tooling plugin</a>. I did most of the work while on my vacation in Jamaica (you can only lay around in the sun drinking daiquiris for so long!) and finally release version 0.0.1 this morning.</p>
<p><strong>Github repo: <a href="https://github.com/jeffdonthemic/nforce-tooling" target="_blank">https://github.com/jeffdonthemic/nforce-tooling</a></strong></p>
<p>Like anything else with Salesforce.com, it's a work in progress as the Tooling API revs. I'll be adding more features as they become available but please send me any issues or pull requests. I'll be writing a few tutorials in the near future but for some sample code see the <a href="https://github.com/jeffdonthemic/nforce-tooling/tree/master/test" target="_blank">mocha tests</a>. <a href="https://github.com/jeffdonthemic/nforce-tooling" target="_blank">See the github readme for complete info.</a></p>
<p>The 0.0.1 plugin supports the following functionality:</p>
<p><strong>createContainer()</strong> - Creates a container as a package for your workspace that manages working copies of Tooling objects, including collections of objects that should be deployed together.</p>
<p><strong>getContainer()</strong> - Returns a container.</p>
<p><strong>addContainerArtifact()</strong> - Adds an artifact to the container for deployment. The artifact object links the container, to the saved copy of the object (e.g., ApexClass), to the working copy of the object (e.g., ApexClassMember) for deployment.</p>
<p><strong>deployContainer()</strong> - Compiles and deploys a container.</p>
<p><strong>getContainerDeployStatus()</strong> - Returns the deploy status of a container.</p>
<p><strong>deleteContainer()</strong> - Deletes a container.</p>
<p><strong>getObjects()</strong> - Returns a collection of available Tooling API objects and their metadata.</p>
<p><strong>getObject()</strong> - Returns the individual metadata for a specified object.</p>
<p><strong>getRecord()</strong> - Returns high-level metadata for a specific object. For more detailed metadata, use getDescribe().</p>
<p><strong>getDescribe()</strong> - Returns detailed metadata at all levels for a specified object.</p>
<p><strong>getCustomField()</strong> - Returns the metadata on a custom field for a custom object. Includes access to the associated CustomField object in Salesforce Metadata API.</p>
<p><strong>query()</strong> - Executes a query against a Tooling API object and returns data that matches the specified criteria.</p>
<p><strong>insert()</strong> - Creates a new Tooling API object.</p>
<p><strong>update()</strong> - Updates a Tooling API object with the specified data.</p>
<p><strong>delete()</strong> - Deletes a Tooling API object.</p>
<p><strong>executeAnonymous()</strong> - Executes some Apex code anonymously and returns the results.</p>
<p><strong>getApexLog()</strong> - Returns a raw debug log.</p>

