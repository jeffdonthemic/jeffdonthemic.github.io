---
layout: post
title:  AWS Lambda aka Node.js meets IFTTT as a service!
description:   Amazon Lambda  was announced last November at re-Invent and billed as an event-driven computing service for dynamic applications. What does that mean? AWS will run a chunk of JavaScript (i.e., Lambda function) whenever one of the following events occurs- * a table is updated in Amazon DynamoDB  * an object in an Amazon S3 bucket is modified  * a message arrives in an Amazon Kinesis stream  * a custom event is received from another app or service  This is Amazons way of delivering a microservic
date: 2015-01-29 22:49:26 +0300
image:  '/images/slugs/aws-lambda-aka-node-js-meets-ifttt-as-a-service.jpg'
tags:   ["aws", "node.js", "aws"]
---
<p><a href="http://aws.amazon.com/lambda/">Amazon Lambda</a> was announced last November at re:Invent and billed as “an event-driven computing service for dynamic applications”. What does that mean? AWS will run a chunk of JavaScript (i.e., Lambda function) whenever one of the following events occurs:</p>
<ul>
<li>a table is updated in Amazon DynamoDB</li>
<li>an object in an Amazon S3 bucket is modified</li>
<li>a message arrives in an Amazon Kinesis stream</li>
<li>a custom event is received from another app or service</li>
</ul>
<p>This is Amazon's way of delivering a <a href="https://blog.heroku.com/archives/2015/1/20/why_microservices_matter">microservices</a> framework far ahead of its competitors. Currently only Node.js is supported for the preview but there are plans to offer more languages and events as the service matures.</p>
<p>So the next logical question is, when should I use AWS Lambda over EC2 or Beanstalk? The <a href="http://aws.amazon.com/lambda/faqs/">FAQ</a> is chock-full of info but I think the docs do a great job explaining this:</p>
<blockquote>
<p>When you use Amazon EC2 instances directly, you are responsible for provisioning capacity, monitoring fleet health and performance, and using Availability Zones for fault tolerance. AWS Elastic Beanstalk offers an easy-to-use service for deploying and scaling web applications in which you retain ownership and full control over the underlying Amazon EC2 instances. AWS Lambda is a higher-level service that offers convenience in executing code in exchange for flexibility. You cannot log onto compute instances, customize the operating system or language runtime, or store data on local drives after your function completes execution. In exchange for giving up the flexibility of Amazon EC2, AWS Lambda performs operational and administrative activities for you, including capacity provisioning, monitoring fleet health, applying security patches, deploying your code, running a web service front end, and monitoring and logging your functions. AWS Lambda provides easy scaling and high availability to your code without additional effort on your part.</p>
</blockquote>
<p><strong>Demo Use Case</strong></p>
<p>There’s been a lot of talk at <a href="http://www.appirio.com">Appirio</a> and <a href="http://www.topcoder.com">Topcoder</a> about Lambda and how it can be leveraged for scalable, on-demand compute resources. I wanted to explore using Lambda as a queue to kick off the processing of code submissions. So when a member uploads code for a challenge to S3, the Lambda function grabs the code and pushes it to a github repo for further processing. The video and code below walks through this use case.</p>
<p><strong>'Github Pusher’ Lambda Function</strong></p>
<p>To interact with Lambda functions you can either use the handy-dandy <a href="https://console.aws.amazon.com/lambda/home">AWS Lambda (web) console</a> or the <a href="http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-set-up.html">AWS CLI</a>. For this demo we are going to create and run a Lambda function uisng the console. It’s just easier to demo.</p>
<p><strong>Disclaimer:</strong> This is not production quality code and is meant for demo purposes only. Some values have been hardcoded to make it easier to grok. For setup, configuration and security of AWS resources, please <a href="http://aws.amazon.com/documentation/lambda/">see the docs</a>.</p>
<p>One of the benefits of Lambda is that you don’t have to scale your Lambda functions as usage increases, AWS does this for you. In order for AWS to spin up new instances “within a few milliseconds”, Lambda functions are stateless and must have all the required libraries as part of the uploaded code (in your node_modules directory). It is possible to use native libraries but you’ll need to <a href="https://aws.amazon.com/blogs/compute/nodejs-packages-in-lambda/">build them against the Amazon Linux libraries</a>. I initially tried to use <a href="https://github.com/nodegit/nodegit">nodegit</a> but encountered too many errors while trying to run the code on an EC2 instance. I didn't have a lot of confidence that if I did fix the issue on EC2 the Lambda instance would work.</p>
<div class="flex-video"><iframe width="640" height="360" src="https://www.youtube.com/embed/m7egclrPzSg" frameborder="0" allowfullscreen></iframe></div>
<p>The code for the Lambda function (index.js). There are a few included libraries but this is the bulk of the code.</p>
{% highlight js %}var githubapi = require("github"),
 async = require("async"),
 AWS = require('aws-sdk'),
 secrets = require('./secrets.js');

// the 'handler' that lambda calls to execute our code
exports.handler = function(event, context) {

 // config the sdk with our credentials
 // http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-configuring.html
 AWS.config.loadFromPath('./config.json');

 // variables that are populated via async calls to github
 var referenceCommitSha,
  newTreeSha, newCommitSha, code;

 // s3 bucket and file info to fetch -- from event passed into handler
 var bucket = event.Records[0].s3.bucket.name;
 var file = event.Records[0].s3.object.key;

 // github info
 var user = 'jeffdonthemic';
 var password = secrets.password;
 var repo = 'github-pusher';
 var commitMessage = 'Code commited from AWS Lambda!';

 // apis for s3 and github
 var s3 = new AWS.S3();
 var github = new githubapi({version: "3.0.0"});

 github.authenticate({
  type: "basic",
  username: user,
  password: password
 });

 async.waterfall([

  // get the object from s3 which is the actual code
  // that needs to be pushed to github
  function(callback){

 console.log('Getting code from S3...');
 s3.getObject({Bucket: bucket, Key: file}, function(err, data) {
  if (err) console.log(err, err.stack);
  if (!err) {
   // code from s3 to commit to github
   code = data.Body.toString('utf8');
   callback(null);
  }
 });

  },

  // get a reference to the master branch of the repo
  function(callback){

 console.log('Getting reference...');
 github.gitdata.getReference({
  user: user,
  repo: repo,
  ref: 'heads/master'
  }, function(err, data){
   if (err) console.log(err);
   if (!err) {
  referenceCommitSha = data.object.sha;
  callback(null);
   }
 });

  },

  // create a new tree with our code
  function(callback){

 console.log('Creating tree...');
 var files = [];
 files.push({
  path: file,
  mode: '100644',
  type: 'blob',
  content: code
 });

 github.gitdata.createTree({
  user: user,
  repo: repo,
  tree: files,
  base_tree: referenceCommitSha
 }, function(err, data){
  if (err) console.log(err);
  if (!err) {
   newTreeSha = data.sha;
   callback(null);
  }
 });

  },

  // create the commit with our new code
  function(callback){

 console.log('Creating commit...');
 github.gitdata.createCommit({
  user: user,
  repo: repo,
  message: commitMessage,
  tree: newTreeSha,
  parents: [referenceCommitSha]
 }, function(err, data){
  if (err) console.log(err);
  if (!err) {
   newCommitSha = data.sha;
   callback(null);
  }
 });

  },

  // update the reference to point to the new commit
  function(callback){

 console.log('Updating reference...');
 github.gitdata.updateReference({
  user: user,
  repo: repo,
  ref: 'heads/master',
  sha: newCommitSha,
  force: true
 }, function(err, data){
  if (err) console.log(err);
  if (!err) callback(null, 'done');
 });

  }

 // optional callback for results
 ], function (err, result) {
  if (err) context.done(err, "Drat!!");
  if (!err) context.done(null, "Code successfully pushed to github.");
 });

};
{% endhighlight %}
<p>There you have it... "Node.js meets IFTTT as a service" as <a href="https://twitter.com/adrianco">Adrian Cockcroft</a> put it in a recent <a href="http://venturebeat.com/2014/11/15/aws-lambda-analysis/">VentureBeat article</a>.</p>

