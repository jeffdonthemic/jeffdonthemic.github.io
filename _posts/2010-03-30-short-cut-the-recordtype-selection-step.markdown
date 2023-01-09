---
layout: post
title:  Short Cut the Recordtype Selection Step
description: In larger orgs you may have tens or hundreds of recordtypes. For instance, when a user creates a new Opportunity, the first step in the process is to select the correct recordtype from a list of x choices. However, what if, for instance, you have a low-level user that only uses a single recordtype? They dont want to go through that step of selecting the same recordtype each time. To make this users life easier, you can make a custom button that bypasses this recordtype selection screen and takes
date: 2010-03-30 12:03:59 +0300
image:  '/images/slugs/short-cut-the-recordtype-selection-step.jpg'
tags:   ["2010", "public"]
---
<p>In larger orgs you may have tens or hundreds of recordtypes. For instance, when a user creates a new Opportunity, the first step in the process is to select the correct recordtype from a list of x choices. However, what if, for instance, you have a low-level user that only uses a single recordtype? They don't want to go through that step of selecting the same recordtype each time.</p>
<p>To make this user's life easier, you can make a custom button that bypasses this recordtype selection screen and takes them directly to the new Opportunity page for the correct recordtype. Simply create a new custom button with the following code and place it on the page layout for the user's profile instead of the standard new Opportunity button.</p>
{% highlight js %}/006/e?retURL=%2F{!Account.Id}&accid={!Account.Id}
&RecordType=YOUR-RECORDTYPE&cancelURL=%2F{!Account.Id}
{% endhighlight %}

