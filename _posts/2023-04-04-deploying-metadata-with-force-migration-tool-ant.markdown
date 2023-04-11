---
layout: post
title:  Deploying Metadata with the Force.com Migration Tool (ANT)
description: How to install, use to retrieve metadata, deploy metadata from one org to another and delete metadata using the Force.com Migration Tool.
date: 2023-04-04 11:56:12 +0300
image:  '/images/force-migration-tool-ant.jpg'
tags:   ["salesforce"]
---

This is a video I put together in 2016 for the [Trailhead Data Integration Specialist superbadge](https://trailhead.salesforce.com/content/learn/superbadges/superbadge_integration). It's a walkthrough of the Force.com Migration Tool, specifically how to install, use to retrieve metadata, deploy metadata from one org to another and delete metadata. 

The Ant Migration Tool is a Java/Ant-based command-line utility for moving metadata between a local directory and a Salesforce org. The Ant Migration Tool is especially useful in the following scenarios.

- Development projects for which you need to populate a test environment with a lot of setup changes—Making these changes using a web interface can take a long time.
- Multistage release processes—A typical development process requires iterative building, testing, and staging before releasing to a production environment. Scripted retrieval and deployment of components can make this process much more efficient.
- Repetitive deployment using the same parameters—You can retrieve all the metadata in your organization, make changes, and deploy a subset of components. If you need to repeat this process, it’s as simple as calling the same deployment target again.
- When migrating from stage to production is done by IT—Anyone that prefers deploying in a scripting environment will find the Ant Migration Tool a familiar process.
- Scheduling batch deployments—You can schedule a deployment for midnight to not disrupt users. Or you can pull down changes to your Developer Edition org every day. 

<p><iframe src="https://www.youtube.com/embed/YW9aPrxvK3A" loading="lazy" frameborder="0" allowfullscreen=""></iframe></p>

Helpful links:

- [Installing the Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool_container_install.htm)
- [Using the Ant Migration Tool](https://developer.salesforce.com/docs/atlas.en-us.daas.meta/daas/forcemigrationtool.htm)

