---
layout: post
title:  Custom Setting 'Null' After Sandbox Refresh?
description: The Summer 13 release for Salesforce.com included an awesome feature that many developers were clamoring for. When refreshing a sandbox, the platform (pre-Summer 13) simply copied the metadata for custom settings. With Summer 13 you also got the data!  I just refreshed one of our sandboxes and indeed the custom settings data copied successfully. I could query the custom object for a specific setting and it was definitely there. However, when I ran all of my unit tests a number of them failed. Up
date: 2013-06-21 10:31:03 +0300
image:  '/images/slugs/custom-setting-null-after-sandbox-refresh.jpg'
tags:   ["2013", "public"]
---
<p>The Summer '13 release for Salesforce.com included an awesome feature that many developers were clamoring for. When refreshing a sandbox, the platform (pre-Summer 13) simply copied the metadata for custom settings. With Summer '13 you also got the data!</p>
<p>I just refreshed one of our sandboxes and indeed the custom settings data copied successfully. I could query the custom object for a specific setting and it was definitely there. However, when I ran all of my unit tests a number of them failed. Upon further investigation I discovered that the following returned <code>null</code>:</p>
{% highlight js %}Platform_Settings__c p = Platform_Settings__c.getInstance('SOME-NAME');
{% endhighlight %}
<p>Strange because the data was definitely there. I ran the following and all of my settings indeed came back.</p>
{% highlight js %}System.debug(Platform_Settings__c.getAll());
{% endhighlight %}
<p>So in the end I had to copy the values from my existing custom setting and into a new one. Only then were my test cases able to run successfully. Has anyone else seen this issue?</p>

