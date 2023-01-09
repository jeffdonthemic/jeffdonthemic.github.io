---
layout: post
title:  Flex 3 Remoting Error - Channel.Call.Failed
description: I was setting up a new Flex3 project on my Mac using ColdFusion 8 and Flash Remoting and ran into the following error when calling the remote object- The call and path to the CFCs was correct so I thought it might have something to do with server configuration. I searched the internets for a similar error message but could not find any relevant results.I was stumped as I have other Flex 3 / Flash Remoting projects running on the same machine. I setup a test project and moved the CFC to a directo
date: 2008-05-27 16:00:00 +0300
image:  '/images/slugs/flex-3-remoting-error-channelcallfailed.jpg'
tags:   ["2008", "public"]
---
<p>I was setting up a new Flex3 project on my Mac using ColdFusion 8 and Flash Remoting and ran into the following error when calling the remote object:</p>
<blockquote>[RPC Fault faultString="error" faultCode="Channel.Call.Failed" faultDetail="NetConnection.Call.Failed: HTTP: Failed"]</blockquote>
The call and path to the CFCs was correct so I thought it might have something to do with server configuration. I searched the internets for a similar error message but could not find any relevant results.
<p>I was stumped as I have other Flex 3 / Flash Remoting projects running on the same machine. I setup a test project and moved the CFC to a directory that worked with another project and the call was successful. Since the CFC and Flash Remoting was working properly the issue had something to do with the directory I was using. I then realized that the CFCs were buried within an existing ColdFusion project and there were perhaps some security issues.</p>
<p>Solution: I added a blank application.cfm file into the directory where my CFC lived and that did the trick.</p>

