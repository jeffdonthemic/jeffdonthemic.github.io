---
layout: post
title:  Flex DataGrid Casting returning NULL object
description: I began working today on a new Cairngorm application that I copied from an existing application. The main feature of the application was allowing the user to select a row from a DataGrid and update its values. model.currentObj = evt.currentTarget.selectedItem; I had the remoting working fine with my Gateway and CFCs but selecting the row and assinging the object to the Model was not working. I used Mike Nimers Debug component to examine object after casting it but it was returning a null value. 
date: 2007-04-11 12:56:03 +0300
image:  '/images/slugs/flex-datagrid-casting-returning-null-object.jpg'
tags:   ["flex"]
---
<p>I began working today on a new Cairngorm application that I copied from an existing application. The main feature of the application was allowing the user to select a row from a DataGrid and update its values.</p>
{% highlight js %}model.currentObj = evt.currentTarget.selectedItem;
{% endhighlight %}
<p>I had the remoting working fine with my Gateway and CFCs but selecting the row and assinging the object to the Model was not working. I used Mike Nimer's Debug component to examine object after casting it but it was returning a null value. Below is my code that has worked in numerous projects:</p>
<p>After searching Adobe's docs I realized that when object cannot be cast correctly, they simply return a null value. Therefore I set about trying to find <strong>why</strong> my objects weren't being cast correctly. Could it be incorrect members types in the ActionScript and CFCs? Perhaps the CFPRPOERTY tags were in the wrong order?</p>
<p>After a couple of hours I finally realized that the metadata alias in the ActionScript had been fat-fingered. After correcting the package to the code below, the application worked like a champ!</p>
{% highlight js %}[RemoteClass(alias="com.bluemethod.MyVO")]
public class MyVO implements ValueObject
{% endhighlight %}

