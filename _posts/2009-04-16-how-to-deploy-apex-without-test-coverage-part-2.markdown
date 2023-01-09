---
layout: post
title:  How to deploy Apex without test coverage (part 2)
description: Ive spent the better part of the last two days deploying a custom lead assignment application to Production. Deployment is always an adventure due to circular code dependencies, code coverage requirements  and the actual amount of time involved in the process. One of the things that I always find interesting is that if you Run Tests from Eclipse and from the Salesforce.com Builder, you sometimes get different code coverage results?  Last month I blogged about my experience  deploying code to Pro
date: 2009-04-16 19:44:56 +0300
image:  '/images/slugs/how-to-deploy-apex-without-test-coverage-part-2.jpg'
tags:   ["2009", "public"]
---
<p>I've spent the better part of the last two days deploying a custom lead assignment application to Production. Deployment is always an adventure due to circular code dependencies, code coverage requirements  and the actual amount of time involved in the process. One of the things that I always find interesting is that if you Run Tests from Eclipse and from the Salesforce.com Builder, you sometimes get different code coverage results?</p>
<p>Last month <a href="/2009/03/04/how-to-deploy-apex-without-test-coverage/" target="_blank">I blogged about my experience</a> deploying code to Production with 0% test coverage. I think the documentation surrounding code coverage is confusing and sometimes contradictory.</p>
<p><a href="http://community.salesforce.com/sforce/board/message?board.id=apex&message.id=14931#M14931" target="_blank">My thread on the Salesforce.com message board</a> has a post from Andrew (Product Manager) that explains how the code coverage measurement works. However, someone just posted a comment that appears to be a contradiction:</p>
<blockquote>"I'm looking at a production instance (enterprise) which has 16 Apex classes and no test coverage at all. When I run all tests it shows 0% test coverage but that doesn't seem to interfere with the operation of any of this Apex code. From the eclipse ide I can modify these classes or create new Apex classes freely just by saving (not deploying)."</blockquote>
