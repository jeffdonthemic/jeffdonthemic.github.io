---
layout: post
title:  Google Chrome Extension - Force.com Logins
description: One of our brilliant guys in our Appirio Japan office,Toshihiro Takasu, wrote  this really slick Google Chrome Extension  for managing your salesforce.com logins in Chrome- * Keeps your salesforce.com account information (usrename, password, security  token, and description). * Lets you log into the account you selected with new tab. * Lets you log into the account you selected with new window (separate  session). * Groups your account for easy management. * Searches accounts by username for yo
date: 2010-12-15 13:49:57 +0300
image:  '/images/slugs/google-chrome-extension-force-com-logins.jpg'
tags:   ["google", "salesforce"]
---
<p>One of our brilliant guys in our Appirio Japan office,Toshihiro Takasu, wrote <a href="https://chrome.google.com/extensions/detail/ldjbglicecgnpkpdhpbogkednmmbebec#">this really slick Google Chrome Extension</a> for managing your salesforce.com logins in Chrome:</p>
<ul>
<li>Keeps your salesforce.com account information (usrename, password, security token, and description).</li>
<li>Lets you log into the account you selected with new tab.</li>
<li>Lets you log into the account you selected with new window (separate session).</li>
<li>Groups your account for easy management.</li>
<li>Searches accounts by username for you to quickly access the account.</li>
<li>Export and import the account information in XML format.</li>
</ul>
<p><a href="https://chrome.google.com/extensions/detail/ldjbglicecgnpkpdhpbogkednmmbebec#"><strong>You can install the extension here.</strong></a></p>
<p>I've seen a few questions on Twitter regarding the security that is used to store credentials. I spoke with Toshi and he's updated the extension's page to include some more info. Essentially the extension is using Chrome's <a href="http://www.rajdeepd.com/articles/chrome/localstrg/LocalStorageSample.htm">localStorage</a> which is only accessible to the extension itself and the Chrome developer tool. This is the same storage method that Chrome uses internally to save your credentials when you fill out a form. So if you trust Chrome to auto-fill your salesforce.com login credentials then this extension is doing basically the same thing but just making your life a little easier. It's up to you.</p>
