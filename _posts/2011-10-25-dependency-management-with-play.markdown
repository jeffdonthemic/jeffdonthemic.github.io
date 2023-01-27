---
layout: post
title:  Dependency Management with Play!
description: Play! has dependency management baked into it . This allows you to express your applications external dependencies in a single dependencies.yml file. So if your app requires commons-lang or log4j, you can list them in your depencies.yml file and Play! will download them for you and place them in your lib directory. So Im making changes to my Play! demo app for salesforce.com  and am trying to specify the  Force.com Web Service Connector (WSC)  in my dependencies.yml file. However, I think that 
date: 2011-10-25 10:43:39 +0300
image:  '/images/slugs/dependency-management-with-play.jpg'
tags:   ["salesforce", "play!"]
---
<p>Play! has <a href="http://www.playframework.org/documentation/1.2.3/dependency">dependency management baked into it</a>. This allows you to express your applications external dependencies in a single dependencies.yml file. So if your app requires commons-lang or log4j, you can list them in your depencies.yml file and Play! will download them for you and place them in your lib directory.</p>
<p>So I'm making changes to my <a href="/2011/09/26/telesales-play/">Play! demo app for salesforce.com</a> and am trying to specify the <a href="http://code.google.com/p/sfdc-wsc/">Force.com Web Service Connector (WSC)</a> in my dependencies.yml file. However, I think that I'm not referencing them correctly as the module is not being found in mavenscentral and downloaded. I've tried different combinations with the artifactId and groupId but nothing seems to work. Here's my dependencies.yml:</p>
{% highlight js %}require:
  - play
  - force-wsc -> force-wsc
{% endhighlight %}
<p>When I run <em>play dependencies --verbose</em> in Terminal I get the following:</p>
{% highlight js %}:::: WARNINGS
module not found: force-wsc#force-wsc;->
==== mavenCentral: tried
http://repo1.maven.org/maven2/force-wsc/force-wsc/->/force-wsc-->.pom
-- artifact force-wsc#force-wsc;->!force-wsc.jar:
http://repo1.maven.org/maven2/force-wsc/force-wsc/->/force-wsc-->.jar

::::::::::::::::::::::::::::::::::::::::::::::
::   UNRESOLVED DEPENDENCIES   ::
::::::::::::::::::::::::::::::::::::::::::::::
:: force-wsc#force-wsc;->: not found
::::::::::::::::::::::::::::::::::::::::::::::
{% endhighlight %}
<p>Any help with this issue would be greatly appreciated!</p>
<p><font color="red"><b>Update!!</b></font></p>
<p>I worked with <a href="http://twitter.com/jesperfj">@jesperfj</a> this morning and he pointed me in the right direction. I needed to include the groupId and version as well. The correct syntax looks like:</p>
{% highlight js %}require:
  - play
  - com.force.api -> force-wsc 22.0.0
{% endhighlight %}

