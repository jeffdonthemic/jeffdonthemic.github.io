---
layout: post
title:  OutOfMemoryError PermGen Crash with Force.com IDE 15
description: I upgraded my Windows XP, Windows Vista, Windows 7 (beta VM) and OS X machines with the new Force.com IDE v15 yesterday when it came out. The new IDE runs great on all of my machines except my Mac. It crashed frequenty with the following error-  java.lang.OutOfMemoryError- PermGen space  I poked around the Eclipse.org site and this seems to be a known bug with Eclipse 3.3.x. Here are a couple of links (bug 195897 & bug 203325 ) that outline the issue. Essentially the problem is that the launcher
date: 2009-02-20 15:04:47 +0300
image:  '/images/slugs/outofmemoryerror-force-ide-15.jpg'
tags:   ["apple", "salesforce"]
---
<p>I upgraded my Windows XP, Windows Vista, Windows 7 (beta VM) and OS X machines with the new Force.com IDE v15 yesterday when it came out. The new IDE runs great on all of my machines except my Mac. It crashed frequenty with the following error:</p>
{% highlight js %}java.lang.OutOfMemoryError: PermGen space

{% endhighlight %}
<p>I poked around the Eclipse.org site and this seems to be a known bug with Eclipse 3.3.x. Here are a couple of links (<a href="https://bugs.eclipse.org/bugs/show_bug.cgi?id=195897" target="_blank">bug 195897</a> & <a href="https://bugs.eclipse.org/bugs/show_bug.cgi?id=203325" target="_blank">bug 203325</a>) that outline the issue. Essentially the problem is that the launcher does not correctly identify the Sun JVM on Apple OSX so the correct params are not passed to the JVM.</p>
<p>To fix this issue you'll need to edit the eclipse.ini file ([Eclipse Install Folder]/Eclipse.app/Contents/MacOS/eclipse.ini) and add the following after the <strong>-vmargs</strong> switch. This correctly passed the params to the JVM.</p>
{% highlight js %}-XX:MaxPermSize=256m

{% endhighlight %}
<p>You can set this value to the amount of memory you would like to use.</p>
<p>Note, there may be another eclipse.ini file located at [Eclipse Install Folder]/eclipse.ini so you will want to make the changes here also.</p>

