---
layout: post
title:  Constructing the Correct Salesforce.com URL?
description: Ive seen this question on the Salesforce.com message boards but have never seen an answer so I thought I would post it here. Heres my dilemma... we are writing some customization that requires us to construct the URL to a Salesforce.com record (e.g. https-//na5.salesforce.com/02u300000000ACi) and send it via email. Ive seen a solution to this using Visualforce but never in Apex. Here is what I came up with but it seems that there must be a better way. The only constant that I could come up with 
date: 2009-04-23 18:48:34 +0300
image:  '/images/slugs/constructing-the-correct-salesforcecom-url.jpg'
tags:   ["2009", "public"]
---
<p>I've seen this question on the Salesforce.com message boards but have never seen an answer so I thought I would post it here. Here's my dilemma... we are writing some customization that requires us to construct the URL to a Salesforce.com record (e.g. <a href="https://na5.salesforce.com/02u300000000ACi">https://na5.salesforce.com/02u300000000ACi</a>) and send it via email. I've seen a solution to this using Visualforce but never in Apex.</p>
<p>Here is what I came up with but it seems that there must be a better way. The only constant that I could come up with is our Production org ID. So my Apex class holds a reference to this ID and then I have a method that checks the current user's org ID and constructs the URL.</p>
{% highlight js %}public class MyCustomClass {

    // set the production org id so we can see what system we are on
    private static final String PRODUCTION_ORG_ID = '00Z990000001ZZZ';

    // returns the correct system url for the current org
    private String orgUrl {
        get {
            return UserInfo.getOrganizationId() == PRODUCTION_ORG_ID ? 'http://na5.salesforce.com' : 'http://cs1.salesforce.com';
        }
        set;
    }

    // write some code that calls orgUrl....

}
{% endhighlight %}

