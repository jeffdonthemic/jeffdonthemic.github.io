---
layout: post
title:  Amazon Announces Elastic Block Store (EBS) Shared Snapshots
description:   Amazon EBS shared snapshots allow you to back up point-in-time snapshots of your data to Amazon S3 for durable recovery. The ability to share these snapshots makes it easy for you to share this data with your co-workers or others in the Amazon Web Services (AWS) community. With this feature, users that you have authorized can quickly use your Amazon EBS shared snapshots as the basis for creating their own Amazon EBS volumes. If you choose, you can also make your data available publicly to all 
date: 2009-09-24 08:43:17 +0300
image:  '/images/slugs/elastic-block-store-shared-snapshots.jpg'
tags:   ["cloud computing", "amazon ec2"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399501/logo_aws_ydaev7.gif"><img class="alignleft size-full wp-image-1353" style="padding-right:15px;" title="logo_aws" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399501/logo_aws_ydaev7.gif" alt="logo_aws" width="164" height="60" /></a><a href="http://aws.amazon.com/ebs/?ref_=pe_2170_13123330" target="_blank">Amazon EBS shared snapshots</a> allow you to back up point-in-time snapshots of your data to Amazon S3 for durable recovery. The ability to share these snapshots makes it easy for you to share this data with your co-workers or others in the Amazon Web Services (AWS) community.</p>
<p>With this feature, users that you have authorized can quickly use your Amazon EBS shared snapshots as the basis for creating their own Amazon EBS volumes. If you choose, you can also make your data available publicly to all AWS users. Because all the data is stored in the AWS cloud, users don't have to wait for time consuming downloads, and can access it within minutes. New volumes created from existing Amazon S3 snapshots load lazily in the background. This means that once a volume is created from a snapshot, there is no need to wait for all of the data to transfer from Amazon S3 to your Amazon EBS volume before your attached instance can start accessing the volume and all of its data. If your instance accesses a piece of data which hasnt yet been loaded, the volume will immediately download the requested data from Amazon S3, and then will continue loading the rest of the volumes data in the background.</p>
<p>Some cool things you could do with snapshots include:</p>
<ul>
 <li>Quickly and easily move data between development, testing, and production environments</li>
 <li>Mount a volume created from a shared snapshot at startup</li>
 <li>Deliver your customer's results in a more usable format than standard spreadsheets</li>
 <li>Deliver your application in a more granular format</li>
 <li>Share entire setups for troubleshooting and support</li>
</ul>
Amazon EBS is extremely affordable. For example, a medium sized website database might be 100 GB in size and expect to average 100 I/Os per second over the course of a month. This would translate to $10 per month in storage costs (100 GB x $0.10/month), and approximately $26 per month in request costs (~2.6 million seconds/month x 100 I/O per second * $0.10 per million I/O).
