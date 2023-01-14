---
layout: post
title:  OpportunityContactRoles is not a Valid Relationship?
description: This is an interesting feature in Salesforce.com. I deployed a fairly standard Visualforce page from one of our sandboxes to production and it began throwing the following error-  OpportunityContactRoles is not a valid child relationship name for entity Opportunity I thought this was strange as it was working in sandbox and OpportunityContactRoles is a standard relationship. This should not throw an error.We finally solved the problem by adding the related list to the STANDARD page layout for th
date: 2008-12-30 20:22:50 +0300
image:  '/images/slugs/opportunitycontactroles-not-a-valid-relationshi.jpg'
tags:   ["salesforce"]
---
<p>This is an interesting feature in Salesforce.com. I deployed a fairly standard Visualforce page from one of our sandboxes to production and it began throwing the following error:</p>
<blockquote><strong>'OpportunityContactRoles' is not a valid child relationship name for entity Opportunity</strong></blockquote>
I thought this was strange as it was working in sandbox and OpportunityContactRoles is a standard relationship. This should not throw an error.
<p>We finally solved the problem by adding the related list to the <em>STANDARD </em>page layout for the recordtype and this fixed the Visualforce page. Go figure.</p>

