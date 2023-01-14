---
layout: post
title:  Cloud Computing for Java Developers Webinar (VMforce)
description: I attended the Cloud Computing for Java Developers  webinar yesterday, which was essentially an intro to VMforce and the Force.com platform for (non-Force.com) Java developers. Quinton Wall and Jesper Joergensen did a good job with the overview of the platform but I was really looking for some tidbits on VMforce. You can watch the recording of the webinar but here are some things that I found interesting... 1. For accessing the Force.com Database, developers will be able to use JPA   , the new R
date: 2010-09-10 08:46:00 +0300
image:  '/images/slugs/cloud-computing-for-java-developers-webinar-vmforce.jpg'
tags:   ["salesforce", "vmforce", "java"]
---
<p>I attended the <strong>Cloud Computing for Java Developers</strong> webinar yesterday, which was essentially an intro to VMforce and the Force.com platform for (non-Force.com) Java developers. Quinton Wall and Jesper Joergensen did a good job with the overview of the platform but I was really looking for some tidbits on VMforce. You can watch the <a href="http://wiki.developerforce.com/index.php/VMforce_Webinar_Series">recording of the webinar</a> but here are some things that I found interesting...
<ol>
<li>
<p>For accessing the Force.com Database, developers will be able to use <a href="http://en.wikipedia.org/wiki/Java_Persistence_API">JPA</a>, the new REST API and the <a href="http://code.google.com/p/sfdc-wsc/">Force.com WSC</a> (SOAP-based).</p>
</li>
<li>
<p>According to Jesper, VMforce will not be included for all orgs. It will be an additional cost possibly as an additional license or subscription. However, it will be available to developers in DE orgs.</p>
</li>
<li>
<p>The Force.com IDE installs on top of <a href="http://www.springsource.com/developer/sts">SpringSouce Tool Suite</a> (Eclipse)</p>
</li>
<li>
<p>Quinton provided a little more info on the REST API that will be piloted starting Winter 11.</p>
</li>
</ol>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327914/vmforce-webinar6_pzf4ec.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_699,w_1024/v1400327914/vmforce-webinar6_pzf4ec.png" alt="" title="vmforce-webinar6" width="525" class="alignnone size-large wp-image-3243" /></a></p>
<ol start="5">
<li>VMforce apps are built, tested and debugged locally and then deployed to the Force.com tcServer instance as easily as any other web application would be deployed on-premise. To the IDE, Force.com just looks like another server.</li>
</ol>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327915/vmforce-webinar4_f1jgoy.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_699,w_1024/v1400327915/vmforce-webinar4_f1jgoy.png" alt="" title="vmforce-webinar4" width="525" class="alignnone size-large wp-image-3241" /></a></p>
<ol start="6">
<li>Quinton did a quick demo where he created a simple POJO, deployed it to the server and it automatically created a Custom Object for it in Force.com (this auto-generation will probably be configurable in the future). VMforce is using the JPA implementation from <a href="http://www.datanucleus.org/">DataNucleus</a> (same as App Engine). Quinton's provided some code examples where he queried Contact records using JPA and then displayed them in the browser:</li>
</ol>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327913/vmforce-webinar7_wqkcrd.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_699,w_1024/v1400327913/vmforce-webinar7_wqkcrd.png" alt="" title="vmforce-webinar7" width="525 class="alignnone size-large wp-image-3244" /></a></p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327911/vmforce-webinar8_vuip0d.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_699,w_1024/v1400327911/vmforce-webinar8_vuip0d.png" alt="" title="vmforce-webinar8" width="525" class="alignnone size-large wp-image-3245" /></a></p>
<p>The summary slide wrapped up the webinar.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327910/vmforce-webinar11_h7cp42.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_699,w_1024/v1400327910/vmforce-webinar11_h7cp42.png" alt="" title="vmforce-webinar11" width="525" class="alignnone size-large wp-image-3246" /></a></p></p>

