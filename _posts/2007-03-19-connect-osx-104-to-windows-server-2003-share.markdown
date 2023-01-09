---
layout: post
title:  Connect OSX 10.4 to Windows Server 2003 Share
description: We run a Windows network at work with mostly XP clients. We have a few OSX users that need to connect to the shares on the Windows Server 2003 Domain Controler/File Server. I was unable to connect via smb-//IP_ADDRESS until I made a few modifications on the server. This affects how Windows encrypts information sent to and from it. Run regedit (Start > Run > Regedit {return}) and type the following-  HKEY_LOCAL_MACHINE System CurrentControlSet Services LanManServer Parameter  Then double click on
date: 2007-03-19 14:08:15 +0300
image:  '/images/slugs/connect-osx-104-to-windows-server-2003-share.jpg'
tags:   ["2007", "public"]
---
<p>We run a Windows network at work with mostly XP clients. We have a few OSX users that need to connect to the shares on the Windows Server 2003 Domain Controler/File Server. I was unable to connect via smb://IP_ADDRESS until I made a few modifications on the server. This affects how Windows encrypts information sent to and from it.</p>
<p>Run "regedit" (Start > Run > "Regedit" {return}) and type the following:</p>
<p>HKEY_LOCAL_MACHINE System CurrentControlSet Services LanManServer Parameter</p>
<p>Then double click on RequireSecuritySignature and set its value to "0" {zero}.</p>
<p>If your server is also a domain controller, you need to open the Domain Controller Security Policy option from Administrator Tools (Administrative Tools > Domain Controller Security Policy) once there, navigate to Local Policies > Security Options and disable the following two options:</p>
<ul>
	<li>Microsoft network server: Digitally sign communications (always)</li>
	<li>Microsoft network server: Digitally sign communications (if client agrees)</li>
</ul>
Rebot your server and you should be all set.
