---
layout: post
title:  Salesforce.com Data Synchronization Tool?
description: Weve been using Relational Junction for a couple of years for data replications from Salesforce.com to SQL Server. Even though it works well weve been exploring other offerings namely Informatica , Reflection  and Apatar . While all of these do a good job at replicating data, we cant seem to find a service that will provide synchronization between two data stores. Heres a fictional example of what we are looking for-  Lets say we replicate some of our Account and Contact data to SQL Server for u
date: 2009-03-30 17:56:14 +0300
image:  '/images/slugs/salesforcecom-data-synch-too.jpg'
tags:   ["salesforce"]
---
<p>We've been using <a href="http://www.sesamesoftware.com/rj4salesforce.html" target="_blank">Relational Junction</a> for a couple of years for data replications from Salesforce.com to SQL Server. Even though it works well we've been exploring other offerings namely <a href="http://www.informatica.com" target="_blank">Informatica</a>, <a href="http://sites.force.com/appexchange/apex/listingDetail?listingId=a0N300000016aGEEAY" target="_blank">Reflection</a> and <a href="http://www.apatar.com" target="_blank">Apatar</a>. While all of these do a good job at replicating data, we can't seem to find a service that will provide synchronization between two data stores. Here's a fictional example of what we are looking for:</p>
<p>Let's say we replicate some of our Account and Contact data to SQL Server for use on our corporate website. When someone updates a person's email address in Salesforce.com we'd like the service to make this change in SQL Server. When a change to a person's email address is made in SQL Server we'd like this change to be reflected in Salesforce.com. Obviously there are issues surrounding which fields are overwritten, but for simplicity we'd like the service to determine which system date is the most recent and then update the other data store with the changes.</p>
<p>Does anyone know of a service that performs this type of functionality?</p>

