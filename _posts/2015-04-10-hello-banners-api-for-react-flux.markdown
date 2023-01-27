---
layout: post
title:  Hello Banners API for React & Flux
description: Welcome to part three of our Building with React & Flux series. Check out the  Getting Started  and Hello React Banners  posts to get up to speed on React  and Flux  if you are new to it. To recap, we are going to build a simple app to manage banner ads using React and RefluxJS , one of the many implementations of Flux. My goal is to make this application as simple as possible while demonstrating the basics of React and Reflux. Last week we built a simple app that looks like the following- 1. Th
date: 2015-04-10 21:39:40 +0300
image:  '/images/react-api.jpg'
tags:   ["react", "flux", "javascript"]
---
<p>Welcome to part three of our Building with React & Flux series. Check out the <a href="/2015/03/12/building-with-react-flux-getting-started/">Getting Started</a> and <a href="/2015/03/24/building-with-react-flux-hello-react-banners/">Hello React Banners</a> posts to get up to speed on <a href="http://facebook.github.io/react/">React</a> and <a href="http://facebook.github.io/flux/docs/overview.html">Flux</a> if you are new to it.</p>
<p>To recap, we are going to build a simple app to manage banner ads using React and <a href="https://github.com/spoike/refluxjs">RefluxJS</a>, one of the many implementations of Flux. My goal is to make this application as simple as possible while demonstrating the basics of React and Reflux. Last week we built a simple app that looks like the following:</p>
<ol>
<li>The 'home page which displays a table of all banners</li>
<li>A form to add a new banner</li>
<li>A view that displays a banner and provides the functionality to toggle the display status of the banner</li>
</ol>
<p><img src="images/ezgif-432990992-1.gif" alt="" ></p>
<p>Today we're going to build a super-simple API and then tie everthing together next week with a nice look UI.</p>
<p>Our API is going to be using <a href="http://expressjs.com/">Express</a> and <a href="https://www.mongodb.org/">MongoDB</a> for persistence. It's a basic Express app that I created using the command line app generator. I just added in MongoDB and the basic CRUD functionality to the routes. Security for the API is beyond the scope of this post. <strong><a href="https://github.com/jeffdonthemic/hello-react-banners-api">You can find all of the code for the API on this github repo.</a></strong></p>
<h3 id="gettingstarted">Getting Started</h3>
<p>To run the application locally, simply clone this repo</p>
{% highlight js %}git@github.com:jeffdonthemic/hello-react-banners-api.git
{% endhighlight %}
<p>Then install all of the dependencies for the project defined in package.json:</p>
{% highlight js %}npm install
{% endhighlight %}
<p>Start Mongo locally (assuming it running on the default port of 27017) and then:</p>
{% highlight js %}npm start
{% endhighlight %}
<p>You should now be able to open up <a href="http://localhost:3000">http://localhost:3000</a> and see an empty array returned. You can use the POST route to add some data based upon the model below.</p>
<h3 id="model">Model</h3>
<p>Our model is pretty simple as we only have 4 properties for our banner object:</p>
{% highlight js %}var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var Banner = new Schema({
 name: {
  type: String,
  required: true
 },
 imageUrl: {
  type: String,
  required: true
 },
 targetUrl: {
  type: String,
  required: true
 },
 active: {
  type: String,
  required: true,
  default: 'Yes'
 }
});

module.exports = mongoose.model('Banner', Banner);
{% endhighlight %}
<h3 id="route">Route</h3>
<p>The bulk of the application is in the <a href="https://github.com/jeffdonthemic/hello-react-banners-api/blob/master/routes/index.js">routes/index.js</a> file. This is where we add all of the functionality to return all banner records, return a banner by its ID, create a new banner and of course update an existing banner. It's pretty much standard boilerplate CRUD functionality for MongoDB so it should be pretty straightforward looking at the code below.</p>
{% highlight js %}var express = require('express');
var router = express.Router();
var _ = require('lodash');
var Banner = require('../models/banner');

/* GET all banners */
router.get('/', function(req, res) {
 Banner.find({}, function(err, banners) {
  if (err)
 res.status(500).json(err);
  res.json(banners);
 })
});

/* POST create banner */
router.post('/', function(req, res) {
 var banner = new Banner(req.body);
 banner.save(function(err, banner) {
  if (err)
 res.send(err);
  res.json(banner);
 });
});

/* PUT update a banner by id */
router.put('/:id', function(req, res) {
 Banner.findById(req.params.id, function (err, banner) {
  if (err) {
 res.send(err);
  } else {
 // assign submitted properties to object for updates
 _.extend(banner, req.body);
 banner.save(function(err, banner) {
  if (err)
   res.send(err);
  res.json(banner);
 });
  }
 });
});

/* GET banner by id */
router.get('/:id', function(req, res) {
 Banner.findById(req.params.id, function (err, banner) {
  if (err)
 res.send(err);
  res.json(banner);
 });
});

module.exports = router;
{% endhighlight %}
<h3 id="conclusion">Conclusion</h3>
<p>Now that we have our API done, we are ready to implement our React components with a nice looking layout and wire them up the to API. We'll take a crack at this in next week's final post in this series.</p>

