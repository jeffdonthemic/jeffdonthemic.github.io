---
layout: post
title:  How to copy an ArrayCollection by value
description: I came across the requirement to copy an ArrayCollection by value instead of by reference. Here is the solutions I used-  private var myCollection-ArrayCollection = new ArrayCollection();  for (var k-Number = 0; k < myCurrentCollection.length; k++) {   myCollection.addItem(mx.utils.ObjectUtil.copy(myCurrentCollection)); }
date: 2008-03-21 16:56:57 +0300
image:  '/images/slugs/how-to-copy-an-arraycollection-by-value.jpg'
tags:   ["2008", "public"]
---
<p>I came across the requirement to copy an ArrayCollection by value instead of by reference. Here is the solutions I used:</p>
{% highlight js %}private var myCollection:ArrayCollection = new ArrayCollection();

for (var k:Number = 0; k < myCurrentCollection.length; k++) { 
 myCollection.addItem(mx.utils.ObjectUtil.copy(myCurrentCollection[k]));
}
{% endhighlight %}

