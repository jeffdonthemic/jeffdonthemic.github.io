---
layout: post
title:  Salesforce Chatter for Android
description: My blog has been a little quiet since I left for Google IO  a few weeks ago and this is primarily the reason why. In addition to my day job Ive been working on getting up-to-speed on Android development. Google sent me a Droid about a month before the conference and I started playing around with some tutorials and writing a few apps before IO (smart idea to send out 5K Droids to spur development). I really caught the Android bug at the event and thought that the Chatter Developer Challenge would
date: 2010-06-06 14:25:23 +0300
image:  '/images/slugs/salesforce-chatter-for-android.jpg'
tags:   ["2010", "public"]
---
<p>My blog has been a little quiet since I left for <a href="http://www.youtube.com/user/GoogleDevelopers#p/a">Google IO</a> a few weeks ago and this is primarily the reason why. In addition to my day job I've been working on getting up-to-speed on Android development. Google sent me a Droid about a month before the conference and I started playing around with some tutorials and writing a few apps before IO (smart idea to send out 5K Droids to spur development). I really caught the Android bug at the event and thought that the <a href="http://developer.force.com/chatter_developer_challenge">Chatter Developer Challenge</a> would be a great way to kill two birds with the proverbial one stone.</p>
<p>So here is the demo of the application that I just submitted for the Chatter Developer Challenge. It is a Salesforce Chatter for Android app running on a combination of the <a href="http://www.salesforce.com/platform/">Force.com platform</a>, <a href="http://code.google.com/appengine/">Google App Engine</a> and a <a href="http://www.android.com/">Google Android</a> mobile handset. It utilizes F<a href="http://developer.force.com/releases/release_feature?key=Remote+Access+Applications+with+OAuth">orce.com Remote Access Applications</a> with <a href="http://hueniverse.com/oauth/guide/terminology/">3-legged OAuth</a> for security. The Android application has the following functionality:</p>
<ul>
<li>Display your Chatter NewsFeed</li>
<li>Update your User status</li>
<li>Refresh your Chatter NewsFeed and store it in the local SQLite database</li>
<li>Choose a project (custom object) that you are following and view its Chatter Feed</li>
<li>Update the project's status</li>
<li>Refresh the Chatter Feed for the project (including field changes to the record) and store it in the local SQLite database</li>
</ul>
<p>The app does not include the functionality to reply to posts. Since Chatter is running in a Developer Edition and they are only allowed to have 1 user, it seemed rather pointless to respond to my own posts.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/2KggRjco6bs?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>I use Google App Engine to tie all of this applications together and provide a coherent security model. So I wrote <a href="http://chatter-android.appspot.com">a small App Engine app</a> that uses OAuth to authorize access to Force.com and my Chatter feeds using Force.com Remote Access Application. Once authorized the Force.com Web Services Connector, running on App Engine, performs the interactions with SFDC such as submitting new status updates, fetching my feeds and displaying them as JSON objects.</p>
<p>App Engine recently started supporting 2-legged <a href="http://code.google.com/appengine/docs/java/oauth/overview.html">OAuth in combination with Google Accounts</a> so that any App Engine application can become an OAuth service provider. Since OAuth support is baked into the Android platform I tried to hook up the Android handset as an OAuth consumer but could not finish in time to submit my entry to the Developer Challenge.</p>
<p><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/06/Chatter_Android4.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030433/tpynphfsqiqj67eilnxg.png" alt="" ></a><br>
Since Android doesn't play well with SOAP-based Web Services I think this approach in combination with JSON makes an appealing option. If you have any ideas, I'd love to hear them. I expect to write some more apps for Salesforce.com as the Android platform is fairly easy to grok. If you are familiar with using Eclipse with Force.com, App Engine, GWT or Java in general it seems much faster to get an app up and running with Android than with Objective-C for the iPhone. Just my $.02.</p>

