---
layout: post
title:  Why the Force.com @future Annotation Should Die!
description: First of all I love asynchronously processing in Salesfoce. We use it all  the time at CloudSpokes. I dont actually mean that the @future annotation should die, per se, but I think there is a better approach. I see the annotation rising from the ashes like a phoenix!!! If you agree please take some time and vote for my idea below. The @future annotation is typically used in one of two ways- 1. Create a better user experience - Lets say you have a process that whenever   an Opportunity is created
date: 2013-04-04 12:53:59 +0300
image:  '/images/slugs/why-the-force-com-future-annotation-should-die.jpg'
tags:   ["2013", "public"]
---
<p>First of all I love asynchronously processing in Salesfoce. We use it <strong>all</strong> the time at CloudSpokes. I don't actually mean that the @future annotation should die, per se, but I think there is a better approach. I see the annotation rising from the ashes like a phoenix!!! If you agree please take some time and vote for my idea below.</p>
<p>The @future annotation is typically used in one of two ways:</p>
<ol>
<li>Create a better user experience - Let's say you have a process that whenever an Opportunity is created a number of calculations are made on a custom object. However, since these calculations don't affect what the user is currently doing, why make them wait as these calculations are made? Apex methods marked with the @future annotation are executed asynchronously when Salesforce has available resources. A better solution is to create the Opportunity and call your calculations asynchronously so that the user does not have to wait for them to finish processing.</li><br/>
<li>Calls to external web services - As Force.com applications have taken more of centralized role in the enterprise application architecture, there is an evolving need to keep external systems in sync. Suppose you have a requirement (not uncommon) that each time you update a contact you have to call an external webservice to update the contact in SAP, Siebel, etc. Since callouts are prohibited in triggers, you need to call an Apex class with a @future method that is marked as (callout=true).</li>
</ol>
<p>The @future annotation is a great tool but with great power comes great responsibility. Here are some things you need to keep in the back of your mind when using them:</p>
<ol>
<li>Depending on the number of licenses you have you may bump into some org-wide limits as Salesforce imposes a limit on the number of future method invocations. You can only have 200 method calls per full Salesforce user license or Force.com App Subscription user license, per 24 hours. This is understandable (i.e., limits != evil) but what if you are doing data loading/cleanup or have installed a managed package that puts you over your limit, you simply have to wait for you invocations to reset and somehow reprocess those items that failed.</li><br/>
<li>No more than 10 method calls per Apex invocation. This one is understandable as well but I've seen a number of projects where we've had to implement some other type of system (polling for instance) because the limitation makes this approach technically impossible. The example is, suppose you have a trigger that updates 11 contact records (or 200!) and needs to make a callout for each record. You are screwed unless you have the luxury of being able to rewrite your external webservice to accept a collection of records.</li><br/>
<li>You cannot call a method annotated with @future from a method that also has the @future annotation. We've run into this a number of times as the class hierarchy grows in larger projects. You want to reuse an existing class but what happens if it already calls a @future method? Or what happens if an managed package contains a @future method?</li><br/>
<li>The parameters for a @future method must be primitive data types, arrays of primitive data types, or collections of primitive data types. Not a big deal as you can typically pass the IDs of the affected records and query for them. But doesn't that seem like a waste of resources if the Apex that calls the @future method already holds these records? It would be great if you could pass a collection of sObject or Apex objects.</li><br/>
<li>It's difficult to orchestrate processes with @future annotations because these methods do not necessarily execute in the same order they are called.</li><br/>
<li>Unit tests are difficult to write. Period.</li>
</ol>
<p><strong>Here's my alternative: Apex Queue</strong></p>
<p>I know that you can "work around" most of these issues and believe me most developers do. But wouldn't it be far less effort and more efficient to deprecate the @future annotation and replace it with an "Apex Queue"? Quese are not rocketsurgery and have been around for quite a long time. Let's embrace them for Force.com development. "My kingdom for a queue!!" I say!</p>
<p>Now I'm neither an Engineer at Salesforce nor do I play one on TV but here's what I think implementing a queue would involve. I'm sure there are technical implications that I am unaware of but I'll give it a shot.</p>
<ol>
<li>Apex invocations are simply passed to the queue and processed sequentially when resources are available (i.e., it's a queue). I typically don't care when a process is kicked off but just that it did run and in a certain sequence. Would be great to have some sort of history similar to batch jobs.<br/></li>
<li>Higher limits for callouts would be awesome but there is a tipping point here. You can't allow unlimited callouts but perhaps 200 callouts per invocation would be awesome to accomidate triggers.<br/></li>
<li>Ability to pass complex objects, sObjects and primitives as method parameters to methods in the queue. <br/></li>
<li>Bulk processing with ability to call Batch Apex. I would love to push a call to the queue that in turn kicks off a batch process in the same thread.<br/></li>
<li>No more issues with calling a @future method from a @future method as each call would be replaced by sending the Apex invocation to the queue.<br/></li>
<li>Much easier to test as you don't have to worry about startTest() and stopTest().</li>
</ol>
<p>So there you have it. My idea for Salesforce to implement an "Apex Queue". <a href="https://success.salesforce.com/ideaView?id=08730000000kmjRAAQ" target="_blank">If you like the idea, go vote it up</a>.</p>

