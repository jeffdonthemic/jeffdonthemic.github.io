---
layout: post
title:  Node-RED for Salesforce
description: I happened across Node-RED  last week while prepping for a topcoder  challenge and became obsessed with it. If you are not familiar with it, Node-RED is an open source IBM technology for wiring together hardware devices, APIs and online services in new and interesting ways. Since Node-RED is built on Node.js, this makes it ideal to run at the edge of the network on low-cost hardware such as an Arduino or Raspberry Pi as well as in the cloud. There are even a couple of Heroku Buttons  to get you 
date: 2015-07-29 15:58:39 +0300
image:  '/images/node-red-salesforce-hero.jpg'
tags:   ["2015", "public"]
---
<p>I happened across <a href="http://www.nodered.org">Node-RED</a> last week while prepping for a <a href="http://www.topcoder.com">topcoder</a> challenge and became obsessed with it. If you are not familiar with it, Node-RED is an open source IBM technology for “wiring together hardware devices, APIs and online services in new and interesting ways”. Since Node-RED is built on Node.js, this makes it ideal to run at the edge of the network on low-cost hardware such as an Arduino or Raspberry Pi as well as in the cloud. There are even a couple of <a href="https://buttons.heroku.com/">Heroku Buttons</a> to get you started however local installation is a snap.</p>
<blockquote>
<p>See yesterday's post on <a href="/2015/07/28/node-red-for-topcoder-challenges-with-ibm-bluemix-watson/">Node-RED for Topcoder Challenges with IBM Bluemix & Watson</a> for a complete walkthrough.</p>
</blockquote>
<p><strong>Naturally</strong> I wanted to see how I could connect Node-RED to Salesforce so I poked around the internetwebs for awhile. I found <a href="https://github.com/ReidCarlberg/Node-Red-Salesforce">some work</a> done by my buddy <a href="https://twitter.com/reidcarlberg">Reid Carlberg</a> with Push Topics but that was about it. Flabbergast, I decided to write some Salesforce nodes over the weekend.</p>
<p><img src="images/node-red-contrib-salesforce.png" alt="" ></p>
<p><strong>The code is available on github at <a href="https://github.com/jeffdonthemic/node-red-contrib-salesforce">node-red-contrib-salesforce</a> and installs as an <a href="https://www.npmjs.com/package/node-red-contrib-salesforce">npm package</a>.</strong></p>
<p>The nodes are easy to install and once you've set up your <a href="https://help.salesforce.com/apex/HTViewHelpDoc?id=connected_app_create.htm">Connected App</a> it's a breeze to get going. The following nodes are available:</p>
<ul>
<li>SOQL - Executes a SOQL query.</li>
<li>SOSL - Executes a SOSL query.</li>
<li>DML - Executes an insert, update, upsert or delete DML statement.</li>
</ul>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/ofa3O4NORVA?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure>
