---
layout: post
title:  Salesforce Lightning Design System Node Demo
description: Last weekend I started playing around with the new Lightning Design System  and before I knew it, I had an entire app written!! It was as simple as using Bootstrap!  I have a confession to make... I suck at front-end design. I typically stumble over spans and divs and inject all sorts of silly stuff into the DOM when it shouldnt be there. In turn, my Visualforce pages also look terrible. > Disclaimer- the Design System is not completely baked but I found most of the standard elements were dev re
date: 2015-09-03 18:26:16 +0300
image:  '/images/node-nforce-demo.jpg'
tags:   ["2015", "public"]
---
<p>Last weekend I started playing around with the new <a href="https://www.lightningdesignsystem.com">Lightning Design System</a> and before I knew it, I had an entire app written!! It was as simple as using Bootstrap!</p>
<p>I have a confession to make... I suck at front-end design. I typically stumble over spans and divs and inject all sorts of silly stuff into the DOM when it shouldn't be there. In turn, my Visualforce pages also look terrible.</p>
<blockquote>
<p>Disclaimer: the Design System is not completely baked but I found most of the standard elements were dev ready. The ones marked with <code>prototype</code> should be treated as alpha.</p>
</blockquote>
<p>This is the main reason why I love the new Design System. Salesforce has done all of the hard CSS and design work for me so that my apps look beautiful. With the Design System I can now build custom apps with a look and feel that is consistent with Salesforce Lightning Experience core features — without hacking up their styles!</p>
<p><img src="images/node-nforce-demo.png" alt="" ></p>
<p>The node.js app is using handlebars for logic-less templating so the HTML is really clean. You should be able to port it to your favorite app easily. It also uses <a href="https://github.com/petkaantonov/bluebird">bluebird</a> for Promises so there's a good example of getting an account record along with its contacts and opportunities.</p>
<p>Demo: <a href="http://node-nforce-demo.herokuapp.com">http://node-nforce-demo.herokuapp.com</a></p>
<p>The code is available at <a href="https://github.com/jeffdonthemic/node-nforce-demo">https://github.com/jeffdonthemic/node-nforce-demo</a> or you can use the handy-dandy 'Deploy to Heroku' button below to get up and running quickly.</p>
<p><a href="https://heroku.com/deploy?template=https://github.com/jeffdonthemic/node-nforce-demo"><img src="https://www.herokucdn.com/deploy/button.png" alt="Deploy" ></a></p>

