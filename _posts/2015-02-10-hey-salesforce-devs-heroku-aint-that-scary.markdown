---
layout: post
title:  Hey Salesforce Devs! Heroku Ain’t that Scary!
description: I run the Heroku CoE at Appirio  and therefore get pulled into a number of pre-sales calls that involve salesforce.com and Heroku. Typically once a week I’ll get the following reaction when talking to Salesforce developers about Heroku-  Theyll say something like,  > Were really good at Force.com development but that Heroku stuff is scary! Au contraire, I tell them, development on Heroku is easier than you think. If you are already familar with Force.com it’s not that difficult to dip your toes 
date: 2015-02-10 22:06:02 +0300
image:  '/images/scary-night.jpg'
tags:   ["2015", "public"]
---
<p>I run the Heroku CoE at <a href="http://www.appirio.com">Appirio</a> and therefore get pulled into a number of pre-sales calls that involve salesforce.com and Heroku. Typically once a week I’ll get the following reaction when talking to Salesforce developers about Heroku:</p>
<p><img src="http://static.fjcdn.com/gifs/Scared_510c77_1821960.gif" alt="" ></p>
<p>They'll say something like,</p>
<blockquote>
<p>We're really good at Force.com development but that Heroku stuff is scary!</p>
</blockquote>
<p>Au contraire, I tell them, development on Heroku is easier than you think. If you are already familar with Force.com it’s not that difficult to dip your toes in the Heroku water. There are a <a href="/2015/01/16/strategies-for-building-customer-facing-apps-with-salesforce-com/">number of strategies for building customer facing apps</a> but here’s a super <a href="https://github.com/jeffdonthemic/node-nforce-demo">simple app to get you started using NodeJS on Heroku</a> in less than 5 minutes. The app has sample code for your hacking enjoyment that provides the functionality to query for and CRUD records in Salesforce.</p>
<p>To get started you need to <a href="https://signup.heroku.com/">signup for a free Heroku account</a> and then <a href="https://toolbelt.heroku.com/">install the Heroku Toolbelt</a>. The Heroku Toolbelt provides you with the command line client, Git for version control and pushing your code to Heroku, and foreman for running your app locally. See the <a href="https://devcenter.heroku.com/start">Getting Started on Heroku page</a> for step-by-step instructions if you have issues.</p>
<p>The following video walks through the entire process of deploying the app to Heroku using the "Deploy to Heroku" button, cloning the repo locally, making changes and pushing those back to Heroku for your app. Check out the <a href="https://github.com/jeffdonthemic/node-nforce-demo">code for the application on github</a> or just click the button below to deploy the app directly to Heroku.</p>
<p><a href="https://heroku.com/deploy?template=https://github.com/jeffdonthemic/node-nforce-demo"><img src="https://www.herokucdn.com/deploy/button.png" alt="Deploy" ></a></p>
<p>The following video walks through setting up a Connected App in Salesforce (you'll need this in order to deploy your code to Heroku), using the Deploy to Heroku button and pulling the code down from Heroku so that you can make changes. It also shows how to add <a href="https://addons.heroku.com/">Add-ons</a> to your app and use various parts of the Heroku Dashboard UI.</p>
<div class="flex-video"><iframe width="640" height="360" src="https://www.youtube.com/embed/-5WbjZ4sF5Y" frameborder="0" allowfullscreen></iframe></div>
