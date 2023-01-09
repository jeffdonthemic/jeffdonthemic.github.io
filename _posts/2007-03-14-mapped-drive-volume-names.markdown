---
layout: post
title:  Mapped Drive Volume Names
description: Im new to this whole Mac-thing. I run on a Windows network and have a couple of mapped drives setup on my DEV server where my projets and source code lives for Eclipse. For some reason when I Connect to Server... in Finder and choose my mapped drive, it connects as the wrong Volume name and fries all of my projects. Eclipse complains that it cant find the .project files. Apprently there is a Volume with the same name that already exists (dont know how?) so it appends -1 to the Volume name. For t
date: 2007-03-14 17:33:10 +0300
image:  '/images/slugs/mapped-drive-volume-names.jpg'
tags:   ["2007", "public"]
---
<p>I'm new to this whole Mac-thing. I run on a Windows network and have a couple of mapped drives setup on my DEV server where my projets and source code lives for Eclipse.</p>
<p>For some reason when I "Connect to Server..." in Finder and choose my mapped drive, it connects as the wrong Volume name and fries all of my projects. Eclipse complains that it can't find the .project files. Apprently there is a Volume with the same name that already exists (don't know how?) so it appends "-1" to the Volume name.</p>
<p>For the life of me I couldn't find the Volumes folder Finder but I could see them in Eclipse. I finally realized it was because Finder hides system file. I had to run the following command from Terminal:</p>
{% highlight js %}defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder
{% endhighlight %}
<p>Then once I launched Finder I could see the Volumes folder, delete the Volume and then connect to the server again.</p>
<p>To hide the files again, simply run the command in Terminal again but set TRUE to FALSE.</p>

