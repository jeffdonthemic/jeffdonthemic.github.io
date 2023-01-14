---
layout: post
title:  Amazon Announces Virtual Private Cloud
description: This morning Amazon announced the support for a Virtual Private Cloud-  We are excited to announce the limited beta of Amazon Virtual Private Cloud (Amazon VPC), a secure and seamless bridge between your existing IT infrastructure and the AWS cloud. Amazon VPC enables you to connect your existing infrastructure to a set of isolated AWS compute resources via a Virtual Private Network (VPN) connection, and to extend your existing management capabilities such as security services, firewalls, and in
date: 2009-08-26 08:31:39 +0300
image:  '/images/slugs/amazon-announces-virtual-private-cloud.jpg'
tags:   ["cloud computing", "amazon ec2"]
---
<p>This morning Amazon <a href="http://aws.amazon.com/vpc/" target="_blank">announced</a> the support for a Virtual Private Cloud:</p>
<blockquote>"We are excited to announce the limited beta of Amazon Virtual Private Cloud (Amazon VPC), a secure and seamless bridge between your existing IT infrastructure and the AWS cloud. Amazon VPC enables you to connect your existing infrastructure to a set of isolated AWS compute resources via a Virtual Private Network (VPN) connection, and to extend your existing management capabilities such as security services, firewalls, and intrusion detection systems to include your AWS resources. Amazon VPC integrates today with Amazon EC2 compute resources, and we will integrate Amazon VPC with other AWS services in the future."</blockquote>
Amazon's VPC functionality:
<ul>
	<li>Create a Virtual Private Cloud on AWS’s scalable infrastructure, and specify its private IP address range from any block you choose.</li>
	<li>Divide your VPC’s private IP address range into one or more subnets in a manner convenient for managing applications and services you run in your VPC.</li>
	<li>Bridge together your VPC and your IT infrastructure via an encrypted VPN connection.</li>
	<li>Add AWS resources, such as Amazon EC2 instances, to your VPC.</li>
	<li>Route traffic between your VPC and the Internet over the VPN connection so that it can be examined by your existing security and networking assets before heading to the public Internet.</li>
	<li>Extend your existing security and management policies within your IT infrastructure to your VPC as if they were running within your infrastructure.</li>
</ul>
To get started you'll need to not only sign up but create a VPN connection to your own network from Amazon's datacenter. You'll need information about your hardware such as its IP address and other networking-related info. More info on Amazon's Virtual Private Cloud is available <a href="http://aws.amazon.com/vpc/" target="_blank">from here</a>.
