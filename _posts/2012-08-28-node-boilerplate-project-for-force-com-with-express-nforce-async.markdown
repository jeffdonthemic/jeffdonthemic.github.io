---
layout: post
title:  Node Boilerplate Project for Force.com with Express, Nforce & Async
description: I have to say that Im addicted to Node. There are a ton of reasons why Node is awesome  , but I like the fact that it is powerful, extensible and easy to get a new app up and running quickly. Over at CloudSpokes  we actually have more Node apps in production now than we do rails apps and that number is growing. So a couple of months ago I wrote a Node.js demo with Force.com REST API, OAuth & Express which was a good starter app. However, it uses the web server flow which we typically dont use fo
date: 2012-08-28 10:33:58 +0300
image:  '/images/slugs/node-boilerplate-project-for-force-com-with-express-nforce-async.jpg'
tags:   ["heroku", "salesforce", "node.js"]
---
<p>I have to say that I'm addicted to Node. There are a <a href="http://www.eweek.com/c/a/Application-Development/Nodejs-Framework-18-Reasons-Developers-Are-Using-It-for-Cloud-Mobile-415509/">ton of reasons why Node is awesome</a>, but I like the fact that it is powerful, extensible and easy to get a new app up and running quickly. Over at <a href="http://www.cloudspokes.com">CloudSpokes</a> we actually have more Node apps in production now than we do rails apps and that number is growing.</p>
<p>So a couple of months ago I wrote a <a href="/2012/04/27/node-js-demo-with-force-com-rest-api-oauth-express/">Node.js demo with Force.com REST API, OAuth & Express</a> which was a good starter app. However, it uses the web server flow which we typically don't use for production apps. Since then I fallen in love with <a href="https://twitter.com/kevino80">Kevin O'Hara's</a> Node package <a href="https://github.com/kevinohara80/nforce">nforce</a>. Not only did Kevin implement both the web server and username & password flows, but I have to say that I really like way that Kevin implemented other features like support for Express middleware, query streaming and Force.com Streaming API. I've contributed a little to the package not not enough to be proud of myself.</p>
<p>So I modified my simple CRUD boilerplate app to use nforce and <a href="http://caolanmcmahon.com/posts/asynchronous_code_in_node_js/">async</a>. If you are not familiar with async it is an awesome package that makes it easier to work with asynchronous JavaScript events. In the Account show method below, I use async to make calls in parallel to get the Account plus the number of Contacts for the Account.</p>
<p>I've included app.js below for your browsing convenience but you can <strong><a href="https://github.com/jeffdonthemic/node-nforce-demo">fork the code from my github repo</a></strong> and get started on your own app. <strong><a href="http://node-nforce-demo.herokuapp.com">The app is running on heroku so you can test drive it for yourself.</a></strong></p>
{% highlight js %}var express = require('express')
 , routes = require('./routes')
 , util = require('util')
 . async = require('async')
 , nforce = require('nforce');

var port = process.env.PORT || 3001; // use heroku's dynamic port or 3001 if localhost
var oauth;

// use the nforce package to create a connection to salesforce.com
var org = nforce.createConnection({
 clientId: process.env.CLIENT_ID,
 clientSecret: process.env.CLIENT_SECRET,
 redirectUri: 'http://localhost:' + port + '/oauth/_callback',
 apiVersion: 'v24.0', // optional, defaults to v24.0
 environment: 'production' // optional, sandbox or production, production default
});

// authenticate using username-password oauth flow
org.authenticate({ username: process.env.USERNAME, password: process.env.PASSWORD }, function(err, resp){
 if(err) {
  console.log('Error: ' + err.message);
 } else {
  console.log('Access Token: ' + resp.access_token);
  oauth = resp;
 }
});

// create the server
var app = module.exports = express.createServer();

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

// display a list of 10 accounts
app.get('/accounts', function(req, res) {
 org.query('select id, name from account limit 10', oauth, function(err, resp){
  res.render("accounts", { title: 'Accounts', data: resp.records } );
 });
});

// display form to create a new account
app.get('/accounts/new', function(req, res) {
 // call describe to dynamically generate the form fields
 org.getDescribe('Account', oauth, function(err, resp) {
  res.render('new', { title: 'New Account', data: resp })
 });
});

// create the account in salesforce
app.post('/accounts/create', function(req, res) {
 var obj = nforce.createSObject('Account', req.body.account);
 org.insert(obj, oauth, function(err, resp){
  if (err) {
 console.log(err);
  } else {
 if (resp.success == true) {
  res.redirect('/accounts/'+resp.id);
  res.end();
 }
  }
 })
});

// display the account
app.get('/accounts/:id', function(req, res) {
 var async = require('async');
 var obj = nforce.createSObject('Account', {id: req.params.id});

 async.parallel([
 function(callback){
  org.query("select count() from contact where accountid = '" + req.params.id + "'", oauth, function(err, resp){
   callback(null, resp);
  });
 },
 function(callback){
  org.getRecord(obj, oauth, function(err, resp) {
   callback(null, resp);
  });
 },
 ],
 // optional callback
 function(err, results){
  // returns the responses in an array
  res.render('show', { title: 'Account Details', data: results });
 }); 

});

// display form to update an existing account
app.get('/accounts/:id/edit', function(req, res) {
 var obj = nforce.createSObject('Account', {id: req.params.id});
 org.getRecord(obj, oauth, function(err, resp) {
  res.render('edit', { title: 'Edit Account', data: resp });
 });
});

// update the account in salesforce
app.post('/accounts/:id/update', function(req, res) {
 var obj = nforce.createSObject('Account', req.body.account);
 org.update(obj, oauth, function(results) {
  res.redirect('/accounts/'+req.params.id);
  res.end();
 }); 
});

app.listen(port, function(){
 console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
{% endhighlight %}

