---
layout: post
title:  Publishing with the Force.com Toolkit for Facebook
description: When Sandeep and I demoed the Force.com Toolkit for Facebook at Dreamforce 2010 last December the Toolkit only contained the functionality to fetch data from Facebook using the Graph API . Fortunately a number of the Force.com toolkits are available on github so if you want to fork a project and add functionality or fix a bug, you are more that welcome to! Its actually encouraged.   Ive been working on a Facebook app for CloudSpokes  and wanted to have the ability to publish info to Facebook. So
date: 2011-03-25 14:43:56 +0300
image:  '/images/slugs/publishing-with-the-force-com-toolkit-for-facebook.jpg'
tags:   ["facebook", "salesforce"]
---
<p>When Sandeep and I <a href="http://www.youtube.com/watch?v=1fd5UUmCHNo&hd=1">demoed the Force.com Toolkit for Facebook</a> at Dreamforce 2010 last December the Toolkit only contained the functionality to fetch data from Facebook using the <a href="http://developers.facebook.com/docs/reference/api/">Graph API</a>. Fortunately a number of the Force.com toolkits are available on <a href="https://github.com">github</a> so if you want to fork a project and add functionality or fix a bug, you are more that welcome to! It's actually encouraged.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327809/cloudspokes-fb_ikuxnp.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327809/cloudspokes-fb_ikuxnp.png" alt="" title="cloudspokes-fb" width="350" class="alignleft size-full wp-image-3812" /></a></p>
<p>I've been working on a Facebook app for <a href="http://www.cloudspokes.com">CloudSpokes</a> and wanted to have the ability to publish info to Facebook. So I simply forked the <a href="https://github.com/developerforce/Force.com-Toolkit-for-Facebook">the toolkit project</a> and went to work. I just finished up writing test coverage yesterday and committed my changes to my forked version. I sent Quinton a Pull Request so that he can merge my code with the toolkit when he has time. The toolkit should come out of "beta" once the JSON parser is native on the platform. Hopefully that will be the next release (Summer 11).</p>
<p>Here's the functionality that I added:</p>
<ul>
<li>Publish a new post on a given profile's feed/wall</li>
<li>'Like' a given object</li>
<li>Comment on a given object</li>
<li>Publish a link on a given profile</li>
<li>Publish a note on a given profile</li>
<li>Create an event</li>
<li>Create a checkin at a location represented by a Page </li>
</ul>
<p>It's interesting to see which projects that people are forking and potentially working on. If you'd like to contribute to one of the Force.com toolkit, hop on over to github and fork away!</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401022375/lhwg2qccrouqyir01c3t.png" border="0" alt="Github developerforce" width="500" height="401" /></p>
