---
layout: post
title:  BlazeDS - ReferenceError- Error #1056
description: I have been doing Flash Remoting with Flex and ColdFusion for a number of years but wanted to do something with a pure Java solution. I decided to setup BlazeDS (Adobes open source server-based Java remoting and web messaging technology) on my EC2 instance for fun. I found a great tutorial (Getting started with BlazeDS) from Christopher Coenraets that walks you through the entire process. I downloaded the BlazeDS war, dropped it into Tomcat, configured my destinations in the config file and crea
date: 2008-12-05 14:36:11 +0300
image:  '/images/slugs/blazeds-referenceerror.jpg'
tags:   ["flex", "java"]
---
<p>I have been doing Flash Remoting with Flex and ColdFusion for a number of years but wanted to do something with a pure Java solution. I decided to setup <a href="http://opensource.adobe.com/wiki/display/blazeds/BlazeDS/" target="_blank">BlazeDS</a> (Adobe's open source server-based Java remoting and web messaging technology) on my EC2 instance for fun.</p>
<p>I found a <a href="http://www.adobe.com/devnet/livecycle/articles/blazeds_gettingstarted.html" target="_blank">great tutorial</a> ("Getting started with BlazeDS") from Christopher Coenraets that walks you through the entire process. I downloaded the BlazeDS war, dropped it into Tomcat, configured my destinations in the config file and created my Java DAOs and POJOs. I was up and running in less than an hour and developing a POC application. The Java part went along smoothly but I ran into a small snag with my Flex app.</p>
<p>I wrote a small Flex app that calls the DAOs as RemoteObjects and returns ActionScript TransferObject from my POJO instances. Here is my initial code:</p>
<p><strong>POJO - MyObject.java</strong></p>
{% highlight js %}package com.jeffdouglas;

public class MyObject {

    private int id;
    private String name;

    /**
     * @return the id
     */
    public int getId() {
        return id;
    }
    /**
     * @param id the id to set
     */
    public void setId(int id) {
        this.id = id;
    }
    /**
     * @return the name
     */
    public String getName() {
        return name;
    }
    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

}
{% endhighlight %}
<p><strong>ActionScript Transfer Object - MyObjectTO</strong></p>
{% highlight js %}package com.jeffdouglas.model
{

    [Bindable]
    [RemoteClass(alias="com.jeffdouglas.MyObject")]
    public class MyObjectTO
    {
        public var Id:Number;
        public var Name:String;
    }

}
{% endhighlight %}
<p><strong>Flex Application - main.mxml</strong></p>
{% highlight js %}<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml" layout="absolute">

    <mx:RemoteObject id="blazeRo" destination="myDao"
        result="resultMyObject(event)"
        fault="faultHandler(event)"/>               

    <mx:Script>
    <![CDATA[
    import mx.controls.Alert;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.utils.ObjectUtil;
    import com.jeffdouglas.model.*;

    private function myObjectListener():void
    {
        blazeRo.getMyObject();
    }   

    private function resultMyObject(event:ResultEvent):void
    {
        var m:MyObjectTO = event.result as MyObjectTO;
        Alert.show(ObjectUtil.toString(m));
    }   

    private function faultHandler(event:FaultEvent):void
    {
        Alert.show(event.fault.faultString);
    }
    ]]>
    </mx:Script>

    <mx:Button label="Get MyObject" click="myObjectListener()"/>

</mx:Application>
{% endhighlight %}
<p>My problem was that the TO was not being populated by the POJO correctly. All of the members were null in the debugger. I looked in Eclipse and found the following error message:</p>
<blockquote>ReferenceError: Error #1056: Cannot create property id on com.jeffdouglas.model.MyObjectTO.
ReferenceError: Error #1056: Cannot create property name on com.jeffdouglas.model.MyObjectTO.</blockquote>
Here's how I fixed the problem:
<ol>
	<li>I changed the members in my POJO from private to public (not a great solution, but it worked. I am still investigating this.)</li>
	<li>Made sure the members in both the POJO and TO were in the same order.</li>
	<li>Made sure the member names in the POJO and TO were the same case. I had used "Name" and "Id" in the TO and "name" and "id" in the POJO.</li>
</ol>
After these changes were made the POC worked like a champ and the development resumed.
