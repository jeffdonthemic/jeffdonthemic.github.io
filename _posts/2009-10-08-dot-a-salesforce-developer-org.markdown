---
layout: post
title:  DOT a Salesforce Developer Org
description: Salesforce doesnt publish this but you can essentially refresh your production org to a Developer org instead of a Sandbox. There may be only a few case in which you might want to do this and Salesforce wont approve your request easily. If they do, it may take up to a week or more to DOT the org. A DOT or a Default Organizational Template is typically used by ISVs to distribute their applications. It allows them to set up new orgs quickly and efficiently with their products installed. Its effect
date: 2009-10-08 21:54:22 +0300
image:  '/images/slugs/dot-a-salesforce-developer-org.jpg'
tags:   ["2009", "public"]
---
<p>Salesforce doesn't publish this but you <em>can </em>essentially refresh your production org to a Developer org instead of a Sandbox. There may be only a few case in which you might want to do this and Salesforce won't approve your request easily. If they do, it may take up to a week or more to DOT the org.</p>
<p>A "DOT" or a Default Organizational Template is typically used by ISVs to distribute their applications. It allows them to set up new orgs quickly and efficiently with their products installed. It's effectively a config-only refresh; your data doesn't come across. You can find more info how DOTs are typically used <a href="http://wiki.developerforce.com/index.php/Trialforce" target="_blank">here</a>.</p>
<p>One case in which you may want to DOT a Developer org is if you want to move your Production configuration to a Developer org so that you can create some type of managed package. We ran across the need to DOT a org recently when a customer ran out of sandboxes and then needed an older release to develop in due to new features released (their Sandboxes had been upgraded to a new release but Production had not). We DOT'd a Developer org from Production and went about our business.</p>

