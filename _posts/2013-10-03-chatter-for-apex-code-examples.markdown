---
layout: post
title:  Chatter for Apex Code Examples
description: At CloudSpokes.com  we wrap a lot of the challenge process functionality into Chatter. So when we started to add more functionality to our site and org we naturally wanted to leverage the new Chatter in Apex functionality. However, it was a little more difficult that I anticipated. Chatter in Apex is a collection of Apex classes in the ConnectApi namespace that allows you to develop native, social Force.com applications. Perhaps Im dense and a slow learner, but the docs and available recipes  ma
date: 2013-10-03 11:24:17 +0300
image:  '/images/slugs/chatter-for-apex-code-examples.jpg'
tags:   ["salesforce"]
---
<p>At <a href="http://www.cloudspokes.com">CloudSpokes.com</a> we wrap a lot of the challenge process functionality into Chatter. So when we started to add more functionality to our site and org we naturally wanted to leverage the new Chatter in Apex functionality. However, it was a little more difficult that I anticipated. <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/connectAPI_overview.htm">Chatter in Apex</a> is a collection of Apex classes in the ConnectApi namespace that allows you to develop native, social Force.com applications. Perhaps I'm dense and a slow learner, but the docs and available <a href="http://developer.force.com/cookbook/recipe/connect-in-apex-pilot">recipes</a> make it even more confusing. I just wanted an easy "hello chatter" application to get started.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327587/chatter-apex-started_gi5fvv.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327587/chatter-apex-started_gi5fvv.png" alt="" title="chatter for apex" ></a></p>
<p>So after getting some code up and running in production, I thought I'd publish some simple code to get people started. Disclaimer: this is not production code and is for demo only. However, you should be able to drop it in your sandbox and get going. The code has the functionality to make a simple text post, a post with a URL, a post mentioning another user and return a news feed. The <a href="https://gist.github.com/jeffdonthemic/6808389">code is also available at this gist</a> for easy reading.</p>
{% highlight js %}public with sharing class ChatterUtils {

 // makes a simple chatter text post to the specified user from the running user 
 public static void simpleTextPost(Id userId, String postText) { 

  ConnectApi.FeedType feedType = ConnectApi.FeedType.UserProfile;

  ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
  messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

  // add the text segment
  ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
  textSegment.text = postText;
  messageInput.messageSegments.add(textSegment);

  ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
  feedItemInput.body = messageInput;

  // post it
  ConnectApi.ChatterFeeds.postFeedItem(null, feedType, userId, feedItemInput, null); 

 } 

 // makes a chatter post with some text and a link
 public static void simpleLinkPost(Id userId, String postText, String url, String urlName) {  

  ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
  feedItemInput.body = new ConnectApi.MessageBodyInput();

  // add the text segment
  ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
  feedItemInput.body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
  textSegment.text = postText;
  feedItemInput.body.messageSegments.add(textSegment);

  // add the attachment
  ConnectApi.LinkAttachmentInput linkIn = new ConnectApi.LinkAttachmentInput();
  linkIn.urlName = urlName;
  linkIn.url = url;
  feedItemInput.attachment = linkIn;

  // post it!
  ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.News, userId, feedItemInput, null);

 }  

 // makes a simple chatter text post to the specified user from the running user 
 public static void mentionTextPost(Id userId, Id userToMentionId, String postText) { 

  ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
  messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

  // add some text before the mention
  ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
  textSegment.text = 'Hey ';
  messageInput.messageSegments.add(textSegment);

  // add the mention
  ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
  mentionSegment.id = userToMentionId;
  messageInput.messageSegments.add(mentionSegment);

  // add the text that was passed
  textSegment = new ConnectApi.TextSegmentInput();
  textSegment.text = postText;
  messageInput.messageSegments.add(textSegment);

  ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
  input.body = messageInput;

  // post it
  ConnectApi.ChatterFeeds.postFeedItem(null, ConnectApi.FeedType.UserProfile, userId, input, null);

 } 

 // pass the user's id or 'me' to get current running user's news 
 public static ConnectApi.FeedItemPage getNewsFeed(String userId) { 
  return ConnectApi.ChatterFeeds.getFeedItemsFromFeed(null, ConnectApi.FeedType.News, userId);
 } 

}
{% endhighlight %}

