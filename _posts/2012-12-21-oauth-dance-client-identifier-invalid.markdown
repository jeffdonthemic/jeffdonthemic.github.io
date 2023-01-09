---
layout: post
title:  OAuth Dance -- client identifier invalid with Salesforce.com
description: So over at CloudSpokes we use OAuth for everyone that logs into our Database.com (Salesforce) org. Its been working fine for over a year but the last couple of days the OAuth dance have been failing randomly (5% of the time?) for one our our rails apps with the following error-  client identifier invalid  What made it so strange was that it had been working for quite awhile without any code changes for thousands of logins per day. I Googled around for the answer (couldnt find much at all) and ev
date: 2012-12-21 14:37:31 +0300
image:  '/images/slugs/oauth-dance-client-identifier-invalid.jpg'
tags:   ["2012", "public"]
---
<p>So over at <a href="http://www.cloudspokes.com">CloudSpokes</a> we use OAuth for everyone that logs into our Database.com (Salesforce) org. It's been working fine for over a year but the last couple of days the OAuth dance have been failing randomly (5% of the time?) for one our our rails apps with the following error:</p>
<p><em>client identifier invalid</em></p>
<p>What made it so strange was that it had been working for quite awhile without any code changes for thousands of logins per day. I Googled around for the answer (couldn't find much at all) and even posted to the <a href="http://boards.developerforce.com/t5/Security/OAuth-Dance-Randomly-Failing-with-quot-client-identifier-invalid/td-p/547515">Developerforce security board</a> with no luck (or replies).</p>
<p>I raised the question to E<a href="https://github.com/ejholmes">ric Holmes</a>, one of the other committers for the databasedotcom gem, and he had the bright idea to specify the actual pod in the host instead of the generic "login.salesforce.com". After I switched the host to our pod, "na7.salesforce.com", I stopped receiving the oauth errors. I thought I might blog about this in case some else runs across the same issue.</p>

