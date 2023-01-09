---
layout: post
title:  How to deploy Apex without test coverage
description: A couple of weeks ago I had written some Apex controllers and Visualforce pages for one of our business units. The new code went through release management and I decided to deploy it Friday night (the business unit is located in the UK) before I left for the weekend. I used Eclipse as usual and my deployment validated successfully and the assets were pushed to production. I logged in and ran the new processes successfully. While running All Test on one of our dev sandboxes on Monday morning, I r
date: 2009-03-04 19:05:44 +0300
image:  '/images/slugs/how-to-deploy-apex-without-test-coverage.jpg'
tags:   ["2009", "public"]
---
<p>A couple of weeks ago I had written some Apex controllers and Visualforce pages for one of our business units. The new code went through release management and I decided to deploy it Friday night (the business unit is located in the UK) before I left for the weekend.</p>
<p>I used Eclipse as usual and my deployment validated successfully and the assets were pushed to production. I logged in and ran the new processes successfully.</p>
<p>While running All Test on one of our dev sandboxes on Monday morning, I realized that I had totally forgotten to write the unit tests for the code I had deployed on Friday. I was shocked that the code had successfully deployed as <strong><em>everyone</em></strong> know that 75% code coverage is required.</p>
<p>I submitted a case to our Premier Support rep which he quickly escalated to Level 3 support. I also decided to post the question to the Salesforce.com message boards. Shortly thereafter, I received the <a href="http://community.salesforce.com/sforce/board/message?board.id=apex&message.id=12723">following message from Andrew</a>, a product manager at Salesforce.com:</p>
<blockquote>"Code coverage is measured across all of your apex classes and triggers. Triggers are the only logical blocks that specifically require >0% coverage because we know they are in use. The same can not be said for classes so there is no class-level coverage requirement in place at this time.
<p>When you deploy your code using eclipse the existing tests are run and if the coverage is sufficient your deployment will succeed. I presume you had code deployed already and that the additional (untested) controller code you deployed did not drop your overall coverage below the minimum level.  If you do a global run all tests you should still find yourself above the minimum. If that's not the case please update your case with that information."</blockquote><br>
Very interesting. I showed this to our Premier Support rep and he was preplexed to say the least.</p>

