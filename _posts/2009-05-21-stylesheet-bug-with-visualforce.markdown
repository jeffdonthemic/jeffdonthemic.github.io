---
layout: post
title:  Stylesheet Bug with Visualforce
description: I was finishing up our Sites pilot project the other day and was having an issue with the color for the apex-page component not displaying correctly. The following code worked correctly and my page displayed with the correct colors and tab.   However, our Sites project uses its own custom template so I did not want to display the standard Salesforce.com header but wanted to keep the rest of the look and feel. I assumed the following code would work but it rendered the page black instead of the e
date: 2009-05-21 17:36:02 +0300
image:  '/images/slugs/stylesheet-bug-with-visualforce.jpg'
tags:   ["2009", "public"]
---
<p>I was finishing up our Sites pilot project the other day and was having an issue with the color for the apex:page component not displaying correctly. The following code worked correctly and my page displayed with the correct colors and tab.</p>
{% highlight js %}<apex:page controller="MyController" showHeader="true" tabStyle="Account"> 
{% endhighlight %}
<p>However, our Sites project uses its own custom template so I did not want to display the standard Salesforce.com header but wanted to keep the rest of the look and feel. I assumed the following code would work but it rendered the page black instead of the expected blue for Accounts.</p>
{% highlight js %}<apex:page controller="MyController" showHeader="false" standardStylesheets="true" tabStyle="Account">
{% endhighlight %}
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399540/vfstylesheet1_tktbs1.png"><img class="alignnone size-medium wp-image-890" title="vfstylesheet1" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_177,w_300/v1400399540/vfstylesheet1_tktbs1.png" alt="vfstylesheet1" width="300" height="177" /></a></p>
<p>What threw me off track was this is not a Sites issue but a Visualforce issue. I posted the problem to the Sites Pilot message board and <a href="http://community.salesforce.com/sforce/profile?user.id=11821" target="_blank">Bulent</a>, the Sites Product Manager, promptly posted a<a href="http://community.salesforce.com/sforce/board/message?board.id=Visualforce&message.id=5366#M5366"> link to the a thread outlining the problem</a>.</p>
<p>I'm not sure if this bug will be fixed in Summer '09 but here is a work around in the meantime. In your code specify the class you want to use for your styling:</p>
{% highlight js %}<body class="accountTab">
{% endhighlight %}
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399539/vfstylesheet2_y0ipjm.png"><img class="alignnone size-medium wp-image-895" title="vfstylesheet2" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399539/vfstylesheet2_y0ipjm.png?w=300" alt="vfstylesheet2" width="300" height="177" /></a>```</p>

