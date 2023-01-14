---
layout: post
title:  Talend Open Studio
description: So Im back on the ETL intro bandwagon with Talend Open Studio . Talend is essentially an EAI tool with connectors to numerous backend systems (SAP, Oracle, SQL Server, Salesforce.com, XML, etc) that generates Java code that is executed to perform the actual job. One cool feature is that you can create a jar of all of the jobs and deploy it to a computer running Java. This code can then be executed to run on a schedule basis to perform migrations. This video shows how to create a job in Talend th
date: 2009-12-02 18:00:00 +0300
image:  '/images/slugs/video-talend-open-studio.jpg'
tags:   ["salesforce"]
---
<p>So I'm back on the ETL intro bandwagon with <a href="http://www.talend.com/products-data-integration/talend-open-studio.php" target="_blank">Talend Open Studio</a>. Talend is essentially an EAI tool with connectors to numerous backend systems (SAP, Oracle, SQL Server, Salesforce.com, XML, etc) that generates Java code that is executed to perform the actual job. One cool feature is that you can create a jar of all of the jobs and deploy it to a computer running Java. This code can then be executed to run on a schedule basis to perform migrations.</p>
<p>This video shows how to create a job in Talend that extracts records from SQL Server and pushes them into Salesforce.com. Another great feature of Talend (I didn't have time to show it) is that you can perform transformations during the job. For instance, how many times have you received a spreadsheet of accounts and their associated contacts to import? With the Data Loader you have to import the accounts and then add the account ids to the contacts before uploading them. With Talend, you can write a transformation that does this look up for you automatically.</p>
<p>One of my fellow Appirians, Ward Loving, did a <a href="http://techblog.appirio.com/2009/08/using-talend-to-export-data-from.html" target="_blank">great tutorial</a> on setting up Talend on the Appirio Tech Blog.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="150" src="https://www.youtube.com/embed/2xYM0ZtaTBM?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure>
