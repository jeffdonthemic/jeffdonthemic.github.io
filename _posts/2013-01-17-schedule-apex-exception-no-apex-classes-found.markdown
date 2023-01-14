---
layout: post
title:  Schedule Apex Exception - No Apex Classes Found?
description: So I ran across this issue a couple of months ago and forgot to blog about it for my reference and anyone else that runs across this problem. So heres the issue, I have an Apex class scheduled in production that runs another Apex class. Ive made some changes to this second class and need to deploy it to production. Before you do that, for Force.com platform requires you to delete the scheduled job for that class since they are related. No problem. So I deleted the scheduled class, pushed my new 
date: 2013-01-17 20:59:12 +0300
image:  '/images/slugs/schedule-apex-exception-no-apex-classes-found.jpg'
tags:   ["salesforce"]
---
<p>So I ran across this issue a couple of months ago and forgot to blog about it for my reference and anyone else that runs across this problem. So here's the issue, I have an Apex class scheduled in production that runs another Apex class. I've made some changes to this second class and need to deploy it to production. Before you do that, for Force.com platform requires you to delete the scheduled job for that class since they are related.</p>
<p>No problem. So I deleted the scheduled class, pushed my new code to production (passes all tests! w00t!) and went back to schedule this class to run and saw this error:</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327719/schedule1_aeq7ml.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327719/schedule1_aeq7ml.png" alt="" title="schedule1" width="525" class="alignnone size-full wp-image-4714" /></a></p>
<p>I went and looked at the class and noticed that it was no longer valid:</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327718/schedule2_glgbcx.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327718/schedule2_glgbcx.png" alt="" title="schedule2" width="430" height="176" class="alignnone size-full wp-image-4718" /></a></p>
<p>So here's how you fix the issue so that the class can be scheduled. You have to simply have to make salesforce recompile the classes and then it will be available to schedule.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327717/schedule3_g387ny.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327717/schedule3_g387ny.png" alt="" title="schedule3" width="525" class="alignnone size-full wp-image-4721" /></a></p>

