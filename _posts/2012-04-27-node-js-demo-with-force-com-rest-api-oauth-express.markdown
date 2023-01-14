---
layout: post
title:  Node.js Demo with Force.com REST API, OAuth & Express
description: Weve been working with Node.js quite a bit at CloudSpokes  but I hadnt done anything with Force.com and Node.js using their REST API; weve mostly been using our own API. So I thought I would give it a spin and see what it would take to write a small demo app using Node.js, the Force.com REST API, OAuth, Express and Jade for templating. As it turns out it wasnt that difficult. Salesforce.com has done most of the work writing the REST and OAuth pieces. So initially I started woking from Josh Birk 
date: 2012-04-27 14:00:49 +0300
image:  '/images/slugs/node-js-demo-with-force-com-rest-api-oauth-express.jpg'
tags:   ["salesforce", "node.js"]
---
<p>We've been working with Node.js quite a bit at <a href="http://www.cloudspokes.com">CloudSpokes</a> but I hadn't done anything with Force.com and Node.js using their REST API; we've mostly been using our own API. So I thought I would give it a spin and see what it would take to write a small demo app using Node.js, the Force.com REST API, OAuth, Express and Jade for templating.</p>
<p>As it turns out it wasn't that difficult. Salesforce.com has done most of the work writing the REST and OAuth pieces.</p>
<p>So initially I started woking from <a href="https://twitter.com/#!/joshbirk">Josh Birk</a>'s <a href="https://github.com/joshbirk/FDC-NODEJS-HEROKU">FDC-NODEJS-HEROKU</a> repo (don't use this btw). I should have known from the beginning not to use this as the code hadn't been updated in 9 months. Anyway a spent some time over the weekend getting it to work with Express, adding some middleware and rewriting some stuff. Once I finally got it working, I emailed Josh with a question and he informed me that the code was outdated and not to you use it.</p>
<p>Being the cool guy that Josh is, he pointed me to <a href="https://twitter.com/#!/dcarroll">Dave Carroll</a>'s <a href="https://github.com/dcarroll/rest4dbdotcom">rest4dbdotcom</a> repo for the latest and greatest code. This is definitely the repo you want to watch.</p>
<p>So I put together a small demo that allows you to authorize access to an org, get a list of accounts, create new accounts and update existing ones.</p>
<p><strong>Here's the link to the <a href="https://node-sfdc-demo.herokuapp.com/">live application on heroku</a> and the <a href="https://github.com/jeffdonthemic/Node-Force.com-REST-Demo">github repo with the code</a> for your forking pleasure.</strong></p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/3KE4XkNOzgA?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>Most of the logic for the application is in the main app.js file (below) and you can see that it's pretty straight forward. We set some configuration parameters for OAuth, configure the middleware, create the server and then define the routes that we can call.</p>
{% highlight js %}/**
 * Module dependencies.
 */
var express = require('express')
 , routes = require('./routes')
 , rest = require('./rest.js')
 , oauth = require('./oauth.js')
 , url = require('url');

/**
 * Setup some environment variables (heroku) with defaults if not present
 */
var port = process.env.PORT || 3001; // use heroku's dynamic port or 3001 if localhost
var cid = process.env.CLIENT_ID || "YOUR-REMOTE-ACCESS-CONSUMER-KEY";
var csecr = process.env.CLIENT_SECRET || "YOUR-REMOTE-ACCESS-CONSUMER-SECRET";
var lserv = process.env.LOGIN_SERVER || "https://login.salesforce.com";
var redir = process.env.REDIRECT_URI || "http://localhost:" + port + "/token";

/**
 * Middleware to call identity service and attach result to session
 */
function idcheck() {
 return function(req, res, next) {
  // Invoke identity service if we haven't got one or access token has 
  // changed since we got it
 if (!req.session || !req.session.identity || req.session.identity_check != req.oauth.access_token) {
  rest.api(req).identity(function(data) {
   console.log(data);
   req.session.identity = data;
   req.session.identity_check = req.oauth.access_token;
   next();
  });   
  } else {
 next(); 
  }
 }
}

/**
 * Create the server
 */
var app = express.createServer(
  express.cookieParser(),
  express.session({ secret: csecr }),
  express.query(),
  oauth.oauth({
  clientId: cid,
  clientSecret: csecr,
  loginServer: lserv,
  redirectUri: redir,
  }),
 idcheck()
);

/**
 * Configuration the server
 */
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

/**
 * Routes
 */

 // 'home' page
app.get('/', routes.index);

// list of accounts - see routes/index.js for more info
app.get('/accounts', routes.accounts);

// form to create a new account
app.get('/accounts/new', function(req, res) {
 // call describe to dynamically generate the form fields
 rest.api(req).describe('Account', function(data) {
  res.render('new', { title: 'New Account', data: data })
 });
});

// create the account in salesforce
app.post('/accounts/create', function(req, res) {
 rest.api(req).create("Account", req.body.account, function(results) {
  if (results.success == true) {
 res.redirect('/accounts/'+results.id);
 res.end();
  }
 });
});

// display the account
app.get('/accounts/:id', function(req, res) {
 rest.api(req).retrieve('Account', req.params.id, null, function(data) {
  res.render('show', { title: 'Account Details', data: data });
 });
});

// form to update an existing account
app.get('/accounts/:id/edit', function(req, res) {
 rest.api(req).retrieve('Account', req.params.id, null, function(data) {
  res.render('edit', { title: 'Edit Account', data: data });
 });
});

// update the account in salesforce
app.post('/accounts/:id/update', function(req, res) {
 rest.api(req).update("Account", req.params.id, req.body.account, function(results) {
  res.redirect('/accounts/'+req.params.id);
  res.end();
 }); 
});

app.listen(port, function(){
 console.log("Express server listening on port %d in %s mode", 
  app.address().port, app.settings.env);
});
{% endhighlight %}
<p>I did make a small change for the "/accounts" route in app.js. You'll notice that it delegates to routes/index.js and contains no actual code. When your node application start getting more complex and larger, you'll want to refactor the code out of app.js and into their own routes to make life easier.</p>
{% highlight js %}// only needed if calling the rest api from this file (accounts route)
var rest = rest = require('./../rest.js');

/*
 * GET home page.
 */
exports.index = function(req, res){
 res.render('index', { title: 'Salesforce.com Node.js REST Demo' })
};

/*
 * GET list of accounts - for larger apps, you may want to separate
 * code into different routes for ease of maintenance and logic. 
 * Prevents app.js from becoming huge!
 */
exports.accounts = function(req, res){
 rest.api(req).query("select id, name from account limit 10", function(data) {
  res.render("accounts", { title: 'Accounts', data: data, user: req.session.identity } );
 });
};
{% endhighlight %}

