---
layout: post
title:  Node.js Demo with Force.com Streaming API & Socket.io
description: Apex Callouts and Outbound Messaging are great ways to get your data outside of salesforce.com for integration with external system. However, there are times when you are going to bump into  Callout Limits or would like to use Outbound Messaging with non-SOAP endpoints. Never fear, for these types of situations the Force.com Streaming API comes to your rescue!  The Force.com Streaming API lets you expose a near real-time stream of data from the Force.com platform in a secure and scalable way to 
date: 2012-09-07 11:44:33 +0300
image:  '/images/slugs/node-demo-with-force-com-streaming-api-socket-io.jpg'
tags:   ["2012", "public"]
---
<p><a href="http://wiki.developerforce.com/page/Apex_Web_Services_and_Callouts#Apex_Callouts">Apex Callouts</a> and <a href="http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_om_outboundmessaging.htm">Outbound Messaging</a> are great ways to get your data outside of salesforce.com for integration with external system. However, there are times when you are going to bump into <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_callouts_timeouts.htm">Callout Limits</a> or would like to use Outbound Messaging with non-SOAP endpoints. Never fear, for these types of situations the <a href="http://wiki.developerforce.com/page/Getting_Started_with_the_Force.com_Streaming_API">Force.com Streaming API</a> comes to your rescue!</p>
<p>The <a href="http://www.salesforce.com/us/developer/docs/api_streaming/api_streaming.pdf">Force.com Streaming API</a> lets you expose a near real-time stream of data from the Force.com platform in a secure and scalable way to external applications. From the docs,</p>
<blockquote>
<p>The Force.com Streaming API uses a publish/subscribe model where administrators create one or more named topics, each of which is associated with a SOQL query. Applications may subscribe to one or more topics, using the Bayeux protocol. As relevant data is updated, the platform re-evaluates the query and, when a change occurs that alters the results of the query, the platform publishes a notification to subscribed applications.</p>
</blockquote>
<p>I've put together a <a href="http://www.youtube.com/watch?v=rOiO8l4xCJQ&feature=plcp">video</a> and demo application (see below) that walks you through the entire process. Feel free to <a href="https://github.com/jeffdonthemic/node-streaming-socketio">clone the github repo</a> and use the code for your own project. All of the instructions to setup and run the application are on the repo.</p>
<p>Here's an overview of the application. I setup a PushTopic in salesforce.com that streams newly created Account records to a Node application running on heroku using <a href="http://faye.jcoglan.com/">faye</a> (a publish-subscribe messaging system based on the Bayeux protocol) to listen for new records. When a new record is received, it is written to the browser using <a href="http://www.socket.io">socket.io</a> without a page refresh (I know.... magic!!). You could use this same paradigm to send the records to an external HR system, account system or possibly email server. The sky's the limit.</p>
<p><strong>Run the Demo Application</strong></p>
<p>Feel free to watch the entire <a href="http://www.youtube.com/watch?v=rOiO8l4xCJQ&feature=plcp">video at Youtube</a> or embedded below, but here's how to run the demo yourself:</p>
<ol>
<li><a href="http://node-nforce-demo.herokuapp.com/accounts/new">Open this page</a> in another browser window. This is a simple Node app that allows you to create a new Account record in my DE org.</li>
<li><a href="http://node-streaming-socketio.herokuapp.com">Open the demo app</a> in another browser window. This page will initially be blank but as you (or anyone else) adds new Account records in the first app, they will appear on this page.</li>
</ol>
<p>Here's a video of the entire process but you can <a href="http://www.youtube.com/watch?v=rOiO8l4xCJQ&feature=plcp">watch it on Youtube</a> if that's more convenient.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/rOiO8l4xCJQ?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>Like code? If so, here's the <a href="https://github.com/jeffdonthemic/node-streaming-socketio/blob/master/app.js">main app.js</a> from the repo:</p>
{% highlight js %}
/**
 * Module dependencies.
 */
var config = require('./config.js');
var express = require('express')
 , faye  = require('faye')
 , nforce = require('nforce')
 , util = require('util')
 , routes = require('./routes');

var app = module.exports = express.createServer();

// attach socket.io and listen 
var io = require('socket.io').listen(app);
// get a reference to the socket once a client connects
var socket = io.sockets.on('connection', function (socket) { }); 

// Bayeux server - mounted at /cometd
var fayeServer = new faye.NodeAdapter({mount: '/cometd', timeout: 60 });
fayeServer.attach(app);

var sfdc = nforce.createConnection({
 clientId: config.CLIENT_ID,
 clientSecret: config.CLIENT_SECRET,
 redirectUri: config.CALLBACK_URL + '/oauth/_callback',
 apiVersion: 'v24.0', // optional, defaults to v24.0
 environment: config.ENVIRONMENT // optional, sandbox or production, production default
});

// Configuration
app.configure(function(){
 app.set('views', __dirname + '/views');
 app.set('view engine', 'jade');
 app.use(express.bodyParser());
 app.use(express.methodOverride());
 app.use(app.router);
 app.use(express.static(__dirname + '/public')); 
});

app.configure('development', function(){
 app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
 app.use(express.errorHandler());
});

// Routes
app.get('/', routes.index);

app.listen(config.PORT, function(){
 console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});

// authenticates and returns OAuth -- used by faye
function getOAuthToken(callback) {

 if(config.DEBUG) console.log("Authenticating to get salesforce.com access token...");

 sfdc.authenticate({ username: config.USERNAME, password: config.PASSWORD }, function(err, resp){
  if(err) {
 console.log('Error authenticating to org: ' + err.message);
  } else {
 if(config.DEBUG) console.log('OAauth dance response: ' + util.inspect(resp));
 callback(resp);
  }
 });

}

// get the access token from salesforce.com to start the entire polling process
getOAuthToken(function(oauth) { 

 // cometd endpoint
 var salesforce_endpoint = oauth.instance_url +'/cometd/24.0';
 if(config.DEBUG) console.log("Creating a client for "+ salesforce_endpoint);

 // add the client listening to salesforce.com
 var client = new faye.Client(salesforce_endpoint);

 // set header with OAuth token
 client.setHeader('Authorization', 'OAuth '+ oauth.access_token);

 // monitor connection down and reset the header
 client.bind('transport:down', function(client) {
  // get an OAuth token again
  getOAuthToken(function(oauth) {
 // set header again
 upstreamClient.setHeader('Authorization', 'OAuth '+ oauth.access_token);
  });
 });

 // subscribe to salesforce.com push topic
 if(config.DEBUG) console.log('Subscribing to '+ config.PUSH_TOPIC);
 var upstreamSub = client.subscribe(config.PUSH_TOPIC, function(message) {
  // new inserted/updated record receeived -- do something with it
  if(config.DEBUG) console.log("Received message: " + JSON.stringify(message)); 
  socket.emit('record-processed', JSON.stringify(message));
  /**
  * NOW WE HAVE A RECORD FROM SALESFORCE.COM! PROCESS IT ANYWAY YOU'D LIKE!!
  **/
 });

 // log that upstream subscription is active
 client.callback(function() {
  if(config.DEBUG) console.log('Upstream subscription is now active');  
 });

 // log that upstream subscription encounters error
 client.errback(function(error) {
  if(config.DEBUG) console.error("ERROR ON Upstream subscription Attempt: " + error.message);
 });

 // just for debugging I/O, an extension to client -- comment out if too chatty
 client.addExtension({
  outgoing: function(message, callback) {  
 if(config.DEBUG) console.log('OUT >>> '+ JSON.stringify(message));
 callback(message);  
  },
  incoming: function(message, callback) {  
 if(config.DEBUG) console.log('IN >>>> '+ JSON.stringify(message));
 callback(message);  
  }  
 }); 

});
{% endhighlight %}

