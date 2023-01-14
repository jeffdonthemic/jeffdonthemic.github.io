---
layout: post
title:  How to Customize Salesforce Attachments
description: The title is a little deceiving as you cant really customize standard Salesforce Attachements but Ill show you how you can pull off some declarative and coding magic to make it look like you can. How do we do this? Well, the video walks through the entire process but in a nutshell heres what we do- 1. Create a new custom object with attachments that will replace the standard   attachments related list on the page layout. 2. Create a Visualforce page (code ) and custom Controller (code ) that all
date: 2014-05-30 18:30:05 +0300
image:  '/images/slugs/how-to-customize-salesforce-attachments.jpg'
tags:   ["salesforce", "phasers on innovate"]
---
<p>The title is a little deceiving as you can't <em>really</em> customize standard Salesforce Attachements but I'll show you how you can pull off some declarative and coding magic to make it look like you can.</p>
<p><img src="images/custom-attachments.png" alt="" ></p>
<p>How do we do this? Well, the video walks through the entire process but in a nutshell here's what we do:</p>
<ol>
<li>Create a new custom object with attachments that will replace the standard attachments related list on the page layout.</li>
<li>Create a Visualforce page (<a href="https://gist.github.com/jeffdonthemic/3f00e51b372a4fa6f855#file-uploadattachment">code</a>) and custom Controller (<a href="https://gist.github.com/jeffdonthemic/3f00e51b372a4fa6f855#file-uploadattachmentcontroller">code</a>) that allows the user to upload documents, images, etc. to your new custom attachments object as if it were a standard attachment.</li>
<li>Remove the standard attachments related list from the page layout.</li>
<li>Add the custom attachments related list to the page layout.</li>
<li>Replace the "New" button on the custom attachments related list with an "Add Attachment" button that opens the new Visualforce page.</li>
</ol>
<div class="flex-video"><iframe width="640" height="360" src="//www.youtube.com/embed/hiC4lKtd-XM" frameborder="0" allowfullscreen></iframe></div>
<p>This approach may not fit everyone's org but at least it's an option if you want to be able to customize attachments and would rather avoid using Content or Documents or Chatter Files for something simple.</p>

