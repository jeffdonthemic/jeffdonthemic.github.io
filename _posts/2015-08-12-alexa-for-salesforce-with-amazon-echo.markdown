---
layout: post
title:  Alexa for Salesforce with Amazon Echo
description: Amazon Echo  is a voice command device with functions including question answering, playing music and controlling smart devices. Echo connects to Alexa, a cloud-based voice service, to provide information, answer questions, play music, read the news, check sports scores or the weather, and more—instantly. All you have to do is ask. Echo begins working as soon as it detects the wake word. The Verge has a really good overview of it. A couple of weeks ago Amazon announced the Alexa Skills Kit for A
date: 2015-08-12 13:46:36 +0300
image:  '/images/alexa-salesforce-lead.jpg'
tags:   ["2015", "public"]
---
<p><a href="http://www.amazon.com/echo">Amazon Echo</a> is a voice command device with functions including question answering, playing music and controlling smart devices. Echo connects to Alexa, a cloud-based voice service, to provide information, answer questions, play music, read the news, check sports scores or the weather, and more—instantly. All you have to do is ask. Echo begins working as soon as it detects the wake word. The Verge has a <a href="http://www.theverge.com/2015/7/8/8913739/amazon-echo-re-review-in-the-real-world">really good overview</a> of it.</p>
<p><img src="images/amazon-echo-alexa-salesforce.jpg" alt="" ></p>
<p>A couple of weeks ago Amazon <a href="https://developer.amazon.com/public/community/post/Tx205N9U1UD338H/Introducing-the-Alexa-Skills-Kit-Enabling-Developers-to-Create-Entirely-New-Voic">announced the Alexa Skills Kit</a> for Amazon Echo to make development of new voice-driven capabilities for Alexa fast and easy. I'd been watching Amazon Echo for awhile but <strong>now</strong> I could tell my wife that I needed one "for work".</p>
<p>Within a matter of hours after the un-boxing, I had dug through the documentation and <a href="https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/docs/using-the-alexa-skills-kit-samples-node">node examples</a> and written my first skill to have Alexa tell my girls whose turn it was to choose a sound machine sound plus provide a random daily affirmation (<a href="https://vimeo.com/135664835">video</a>). It's very addicting to write new skills and I found myself dreaming of all the ways I could automate my life. My wife even said, "I have to admit, I thought Alexa was a stupid idea at first but it's been fun!"</p>
<p>I spent a good portion of last weekend getting my hards dirty with Alexa and building some integration with Salesforce. Most of the node.js documentation and examples are for <a href="https://aws.amazon.com/lambda/">Amazon Lambda</a> so I decided to go that route for development instead of using Heroku as I typically do.</p>
<div class="flex-video"><iframe width="640" height="360" src="https://www.youtube.com/embed/LPhSf7SFFTk" frameborder="0" allowfullscreen></iframe></div>
<p><a href="https://github.com/jeffdonthemic/amazon-echo-salesforce">This github repo</a> has all of the code needed plus setup instructions for AWS Lambda and Alexa. The Alexa Salesforce application has the following functionality:</p>
<h3 id="createanewlead">Create a New Lead</h3>
<p>Alexa can walk the user through the process of creating a (simple) Lead in Salesforce.</p>
<blockquote>
<p>User: "Alexa, ask Salesforce to create a new Lead."<br>
Alexa: "OK, let's create a new Lead. What is the person's first and last name?"<br>
User: "Jeff Douglas"<br>
Alexa: "Got it. the name is Jeff Douglas. What is the company name?"<br>
User: "ACME Corp"<br>
Alexa: "Bingo! I created a new lead for Jeff Douglas with the company name ACME Corp."</p>
</blockquote>
<h3 id="opportunitystatus">Opportunity Status</h3>
<p>You can ask Alexa for the status of any Opportunity by name and she will return the amount, stage and probability.</p>
<blockquote>
<p>User: "Alexa, ask Salesforce for Opportunity United Oil Standby Generators."<br>
Alexa: "I found Opportunity United Oil Standby Generators for $80000, the stage is Value Proposition and the probability is 50%"</p>
</blockquote>
<h3 id="newleadsfortoday">New Leads for Today</h3>
<p>You can ask Alexa for any new Leads entered today.</p>
<blockquote>
<p>User: "Alexa, ask Salesforce for any new Leads."<br>
Alexa: "You have 2 new leads, 1, Jeff Douglas from ABC Company, and 2, Mike Smith from XYZ Corp. Go get them tiger!"</p>
</blockquote>
<h3 id="calendarfortoday">Calendar for Today</h3>
<p>Similar to the baked-in Google calendar integration, you can ask Alexa to check your Salesforce calendar and let you know what is upcoming for today.</p>
<blockquote>
<p>User: "Alexa, ask Salesforce for my calendar for today."<br>
Alexa: "You have 2 events for today. At 10:15 am Follow-up Meeting. At 10:30 am, UI Demo with Tim Barr."</p>
</blockquote>
<h3 id="amazonechoapp">Amazon Echo App</h3>
<p>The Amazon Echo App (iOS, Android & web) allows you to view the cards and information from Alexa. This make it useful if you want to check the results of your skills or provide more information to users.</p>
<p><img src="images/Amazon_Echo.png" alt="" ></p>
<h2 id="development">Development</h2>
<p>If you are familiar with Node.js and <a href="https://github.com/kevinohara80/nforce">nforce</a>, development is fairly straight forward after you grok <a href="https://developer.amazon.com/public/solutions/alexa/alexa-skills-kit/getting-started-guide">invocations and intents</a>. A user invokes intents with their voice and invocations are the name that identifies the capability the user wants. The <a href="https://github.com/jeffdonthemic/amazon-echo-salesforce/blob/master/speechAssets/IntentSchema.json">IntentSchema.json</a> defines the the intents for the applications (along with the "slots" or values that Alexa will send your Lambda function) and <a href="https://github.com/jeffdonthemic/amazon-echo-salesforce/blob/master/speechAssets/SampleUtterances.txt">SampleUtterances.txt</a> provide the mappings between the intents and the typical utterances that invoke those intents in a list of sample utterances. The <a href="https://github.com/jeffdonthemic/amazon-echo-salesforce/blob/master/src/index.js">index.js</a> file is the actual Lambda function that is uploaded to AWS and provides all of the functionality.</p>
<p>The development experience with Alexa is sometimes infuriating. Often Alexa will say it cannot reach the skill and you don't know if there's an error with your code (you have to check the CloudWatch logs) or if Alexa just can't connect to the skill. Sometimes you just have to try the skill a couple of times before it works. I found that using the included test.js file helps in prototyping before adding the code in the Lambda function.</p>
<h2 id="conclusion">Conclusion</h2>
<p>So far this is a good start with Alexa but there's a long way to go. One issue with the Salesforce integration is that it is a single user mode. Each interaction is with a specific named user and there's currently no authentication process. Perhaps that's something I can work on.</p>

