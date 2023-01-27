---
layout: post
title:  Using Related Lists in Visualforce Pages
description: Lets face it, coding Visualforce pages is sometimes too easy. The tag-based syntax allows you to design effective UIs with very little effort. One of the more powerful components is the relatedList which lets you display a list of related records based upon a lookup or master-detail relationship. One of the major benefits of this tag, as opposed to writing your own with a dataTable, is that you can visually edit the related list with the Salesforce.com page layout editor. Any changes you make to
date: 2009-05-13 18:14:33 +0300
image:  '/images/slugs/using-related-lists-in-visualforce-pages.jpg'
tags:   ["salesforce", "visualforce"]
---
<p>Let's face it, coding Visualforce pages is sometimes too easy. The tag-based syntax allows you to design effective UIs with very little effort. One of the more powerful components is the relatedList which lets you display a list of related records based upon a lookup or master-detail relationship. One of the major benefits of this tag, as opposed to writing your own with a dataTable, is that you can visually edit the related list with the Salesforce.com page layout editor. Any changes you make to the related list in the page layout editor (columns, sorting, etc.) will automatically be reflected in your Visualforce page.</p>
<p>One of the questions that I see often on the message boards is how to find the relationship name of the related list so that it can be coded in the Visualforce page. The related list portion of an Opportunity display Visualforce page may look like this:</p>
{% highlight js %}<apex:relatedList list="OpportunityLineItems"/>
<apex:relatedList list="R00NR0000000URnZAGQ"/>
<apex:relatedList list="OpportunityContactRoles"/>
<apex:relatedList list="OpportunityTeamMembers"/> 
<apex:relatedList list="OpenActivities"/>
{% endhighlight %}
<p>So let's say you have an custom object named "Opportunity Thing" that has a lookup relationship to Opportunities (called <code>Opportunity__c</code>) and you would like to display this related list on the Opportunity display Visualforce page. To find relationship name, go to the Opportunity Thing custom object, click on Fields and then click your Opportunity field. You will see the lookup options at the bottom right of the screen.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399542/relationship1_rqdlbt.png"><img class="alignnone size-full wp-image-863" title="relationship1" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399542/relationship1_rqdlbt.png" alt="relationship1" width="490" height="36" /></a></p>
<p>The Child Relationship Name is the name of the list attribute for the relatedList tag with <code>__r</code> appended to it. So your relatedList tag would look like:</p>
{% highlight js %}<apex:relatedList list="Opportunity_Things__r"/>
{% endhighlight %}
<p>You can also click the edit button at the top of the page and change the name of the relationship if you would like something a little friendlier.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399541/relationship2_okklnl.png" alt="" ></p>

