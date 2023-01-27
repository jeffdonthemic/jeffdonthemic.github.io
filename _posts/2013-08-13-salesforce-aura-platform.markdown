---
layout: post
title:  First Look - Salesforce.com Aura UI Framework
description: Fun stuff coming out of Salesforce as we ramp up to Dreamforce! I had the opportunity to sit in on the Intro to Aura webinar a few hours ago and I thought I would blog on some key points that I came away with after the whirlwind hour. First of all this is a major initiative for Salesforce.com as it was hosted by Andrew Waite, Josh Kaplan and Doug Chasman (tech lead for aura and one of the Visualforce architects). The project is very  early and probably will not even be in public beta till Spring
date: 2013-08-13 18:33:09 +0300
image:  '/images/slugs/salesforce-aura-platform.jpg'
tags:   ["salesforce"]
---
<p>Fun stuff coming out of Salesforce as we ramp up to Dreamforce! I had the opportunity to sit in on the "Intro to Aura" webinar a few hours ago and I thought I would blog on some key points that I came away with after the whirlwind hour. First of all this is a major initiative for Salesforce.com as it was hosted by Andrew Waite, Josh Kaplan and Doug Chasman (tech lead for aura and one of the Visualforce architects). The project is <i>very</i> early and probably will not even be in public beta till Spring 14 (safe harbor).</p>
<p>First of all what is Aura and why is it so significant? Aura is a UI framework for developing dynamic web apps for mobile and desktop devices (with or without Force.com), while providing a scalable long-lived lifecycle to support building apps engineered for growth. Probably one of the most significant factors is that the project is entirely open source. This is a very big accomplishment for Salesforce.com as I believe it's the first time they will accept external contributions and roll them back into a fully supported Salesforce product. They are really reaching out to the developer community for input and support to make this a success for all of us.</p>
<p>Some key features of aura include:</p>
<ol>
 <li>Tag-based layout & component definition</li>
 <li>Encapsulated UI development with a strongly typed event model</li>
 <li>Object-oriented programming behaviors (extends, implements, abstract)</li>
 <li>Encapsulated bundles with models, controllers, CSS, static resources and markup</li>
 <li>Integrated functional and performance testing (did you expect any less?)</li>
 <li>Mobile, mobile and mobile-ready</li>
</ol>
<p>There are two parts of aura, an open-source package and Force.com package. The open-source package is <a href="https://github.com/forcedotcom/aura">available now on github</a> and you can start playing with an early version of it. Right now the core framework is server side Java but there are adapters for essentially any JVM-based language (Heroku FTW!). Languages such as Node.js and .NET will be a little tougher to implement but Doug seems very open to talking about a road map. There is also an Eclipse plugin but I haven't found reference to it yet.</p>
<p>The Force.com package will have all capabilities of the open source package but will on course be in Apex. Component bundles will saved to the Force.com database and there will be special Salesforce metadata-aware components such as Chatter feeds, inputField and outputFIeld and recordLayout (detail / edit), etc. There will also be some new standard and custom components that can be embedded in standard page layouts, the developer console and even override standard components.</p>
<p>Will aura replace Visualforce tag? No. There is a Visualforce adapter so aura tags will work in Visualforce pages; apparently you can pick and choose which components you use during development. There are also some cool developer tools including enhancements to the Developer Console, plans for integration with the Force.com IDE and the Tooling/Metadata APIs.</p>
<p>Components can be developed independently and dropped into bundles. They are even extensible for maximum reuse. Here's a component from the sample application to give you a quick look:</p>
{% highlight js %}<aura:component extensible="true">
  <aura:attribute name="desc" type="Aura.Component[]"/>
  <aura:attribute name="onclick" type="Aura.Action"/>
  <aura:attribute name="left" type="Aura.Component[]"/>
  <aura:attribute name="right" type="Aura.Component[]"/>
  <li onclick="{!v.onclick}">
  <ui:block>
  <aura:set attribute="left">{!v.left}</aura:set>
  <aura:set attribute="right">{!v.right}</aura:set>
  <h2 class="subject truncate">{!v.body}</h2>
  </ui:block>
  <aura:if isTrue="{!v.desc != null}">
  <p class="desc truncate">{!v.desc}</p>
  </aura:if>
  </li>
</aura:component>
{% endhighlight %}
<p>Aura has been in development for a number of years (it was almost released as "lumen" last August) and is being used for Salesforce Touch, Chatter, Force.com App Builder, Site.com Component Framework and Opportunity Splits (Sales Cloud). Andrew stated they they needed to develop their own framework as opposed to using an existing one due to the multi-tenent nature of the Force.com platform. Makes sense.</p>
<p>So how can you get started? You can certainly take a look at the <a href="https://github.com/forcedotcom/aura">aura project on github</a> but I'd highly recommend forking the <a href="https://github.com/forcedotcom/aura-note">aura-note sample application</a> as it is loaded with some great code to get you started. Also, go ahead and submit issues and ideas as Salesforce.com is very receptive. I submitted an issue last week and Doug had it fixed in no time.</p>

