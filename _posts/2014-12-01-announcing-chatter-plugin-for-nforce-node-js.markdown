---
layout: post
title:  Announcing a Node.js Chatter Plugin for nforce
description: After I woke up from my turkey-induced coma on Thanksgiving I wanted to send Chatter to everyone in our Appirio Salesforce org to inform them that I was still alive. Sure, I could have fired up the trusty, ole Chatter app but since I like to work from the command line, I decided to write a Chatter API plugin for my buddy Kevin OHaras #awesome nforce node.js package . Github repo- https-//github.com/jeffdonthemic/nforce-chatter  NPM- https-//www.npmjs.org/package/nforce-chatter  I wrote a nforce-
date: 2014-12-01 16:01:30 +0300
image:  '/images/slugs/announcing-chatter-plugin-for-nforce-node-js.jpg'
tags:   ["2014", "public"]
---
<p>After I woke up from my turkey-induced coma on Thanksgiving I wanted to send Chatter to everyone in our Appirio Salesforce org to inform them that I was still alive.</p>
<p>Sure, I could have fired up the trusty, ole Chatter app but since I like to work from the command line, I decided to write a Chatter API plugin for my buddy Kevin O'Hara's #awesome <a href="https://github.com/kevinohara80/nforce">nforce node.js package</a>.</p>
<p><strong>Github repo: <a href="https://github.com/jeffdonthemic/nforce-chatter">https://github.com/jeffdonthemic/nforce-chatter</a></strong></p>
<p><strong>NPM: <a href="https://www.npmjs.org/package/nforce-chatter">https://www.npmjs.org/package/nforce-chatter</a></strong></p>
<p>I wrote a <a href="https://github.com/jeffdonthemic/nforce-tooling">nforce-tooling plugin</a> for nforce earlier this year and adding another plugin was a snap! One caveat, the Chatter API is #huge so I've only implemented a few methods so far. The plugin is a work in progress so <strong>pull requests are welcome!</strong></p>
<p><a href="https://github.com/jeffdonthemic/nforce-chatter">See the repo</a> for full details, but here's a quick rundown on the 0.0.1 functionality:</p>
<p><strong>userStatistics()</strong></p>
<p>Returns Chatter statistics for a salesforce user.</p>
<ul>
<li><code>id</code>: Required. The id of the user to return statistics for.</li>
</ul>
<p><strong>myNewsFeed()</strong></p>
<p>Returns the context user's news feed.</p>
<p><strong>recordFeed()</strong></p>
<p>Returns the feed for a specified record.</p>
<ul>
<li><code>id</code>: Required. The id of the record to return the feed for.</li>
</ul>
<p><strong>groupFeed()</strong></p>
<p>Returns the feed for a specified group.</p>
<ul>
<li><code>id</code>: Required. The id of the group to return the feed for.</li>
</ul>
<p><strong>postFeedItem()</strong></p>
<p>Posts a new feeditem for a record.</p>
<ul>
<li><code>id</code>: Required. The ID of the parent this feed element is being posted to. This value can be the ID of a user, group, or record, or the string me to indicate the context user.</li>
<li><code>text</code>: Required. The text of the post.</li>
</ul>
<p><strong>postComment()</strong></p>
<p>Posts a new comment on a feeditem.</p>
<ul>
<li><code>id</code>: Required. The id of the feeditem to post the comment</li>
<li><code>text</code>: Required. The text of the comment.</li>
</ul>
<p><strong>likeFeedItem()</strong></p>
<p>Likes the specified feeditem.</p>
<ul>
<li><code>id</code>: Required. The id of the feeditem to like.</li>
</ul>

