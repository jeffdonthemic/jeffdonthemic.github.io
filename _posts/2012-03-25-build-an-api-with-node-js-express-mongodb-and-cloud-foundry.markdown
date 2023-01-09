---
layout: post
title:  Build an API with Node.js, Express, MongoDB and Cloud Foundry
description: I was finalist in the LinkedIn Hackday hackathon  last November with my Mobile Chow Finder app using jQuery Mobile, Database.com and Ruby on Rails on Heroku. I really liked the Chow Finder use case but wanted to make it more of a finished application; not just something I threw together in a matter of hours. So I decided to start off by writing an API with Node.js and MongoDB and host it on Cloud Foundry. Im going to build a website running off that API with something like Sinatra or Rails. I al
date: 2012-03-25 16:00:00 +0300
image:  '/images/slugs/build-an-api-with-node-js-express-mongodb-and-cloud-foundry.jpg'
tags:   ["2012", "public"]
---
<p>I was <a href="http://veterans2011.linkedin.com/#gallery">finalist in the LinkedIn Hackday hackathon</a> last November with my "Mobile Chow Finder" app using jQuery Mobile, Database.com and Ruby on Rails on Heroku. I really liked the Chow Finder use case but wanted to make it more of a finished application; not just something I threw together in a matter of hours. So I decided to start off by writing an API with Node.js and MongoDB and host it on Cloud Foundry. I'm going to build a website running off that API with something like Sinatra or Rails. I also want to eventually build HTML5, Android and iOS applications running off this API too.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327750/chow-finder1_etamho.png" alt="" ></p>
<p>So I put together a video of the initial process of building the API. It's definitely a work in progress. You can <a href="https://github.com/jeffdonthemic/Chow-Finder-API">clone the code from this repo</a> if you find it useful. It assumes that you have <a href="http://nodejs.org/#download">Node.js</a>, <a href="http://www.mongodb.org/display/DOCS/Quickstart">MongoDB</a>, <a href="http://expressjs.com/guide.html">Express</a> and the Cloud Foundry <a href="http://start.cloudfoundry.com/tools/vmc/installing-vmc.html">Command-Line Interface</a> (vmc) installed.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/3AKaGShTHpo?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>The API has the following methods around two objects: locations and facilities.</p>
<p>GET	/locations	-- returns a list of locations<br>
GET	/locations/:id -- returns a location<br>
POST	/locations	-- creates a location<br>
GET	/locations/favorites	-- returns list of favorite locations for a user<br>
POST	/locations/favorites	-- creates a new favorite for a user<br>
GET	/locations/:id/facilities -- returns a list of facilities for a location<br>
POST	/locations/:id/facilities -- creates a new facility for a location<br>
GET	/locations/:id/facilities/:id -- returns a facility<br>
PUT	/locations/:id/facilities/:id -- updates a facility</p>
<p>You can <a href="https://github.com/jeffdonthemic/Chow-Finder-API/blob/master/app.js">check out code for app.js on github</a>, but most of the interesting stuff is around the connection to MongoDB and the code for the actual methods.</p>
<p>Once you installed the <a href="https://github.com/christkv/node-mongodb-native">MongoDB native Node.js driver</a>, you just need to create your connection to either your localhost or Mongo running on Cloud Foundry in app.js.</p>
{% highlight js %}if(process.env.VCAP_SERVICES){
 var env = JSON.parse(process.env.VCAP_SERVICES);
 var mongo = env['mongodb-1.8'][0]['credentials'];
}
else{
 var mongo = {
  "hostname":"localhost",
  "port":27017,
  "username":"",
  "password":"",
  "name":"",
  "db":"db"
 }
}

var generate_mongo_url = function(obj){
 obj.hostname = (obj.hostname || 'localhost');
 obj.port = (obj.port || 27017);
 obj.db = (obj.db || 'test');

 if(obj.username && obj.password){
  return "mongodb://" + obj.username + ":" + obj.password + "@" + obj.hostname + ":" + obj.port + "/" + obj.db;
 }
 else{
  return "mongodb://" + obj.hostname + ":" + obj.port + "/" + obj.db;
 }
}

var mongourl = generate_mongo_url(mongo);
{% endhighlight %}
<p>Now the API itself. What's great about Node and Mongo are that they both talk JSON. So in this method, we POST some JSON and simply insert it into the 'locations' collection.</p>
{% highlight js %}// creates a location in the 'locations' collection
app.post('/v.1/locations', function(req, res){
 require('mongodb').connect(mongourl, function(err, conn){
  conn.collection('locations', function(err, coll){
 coll.insert( req.body, {safe:true}, function(err){
 res.writeHead(200, {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*"
 });
 res.end(JSON.stringify(req.body));
 });
  });
 });
 });
{% endhighlight %}
<p>To return all of the locations in the collection, we issue the find() command which returns a cursor object to the callback which is passed to the responses as an array of documents.</p>
{% highlight js %}// returns list of locations
app.get('/v.1/locations', function(req, res){

 require('mongodb').connect(mongourl, function(err, conn){
  conn.collection('locations', function(err, coll){
 coll.find(function(err, cursor) {
 cursor.toArray(function(err, items) {
  res.writeHead(200, {
   "Content-Type": "application/json",
   "Access-Control-Allow-Origin": "*"
  });
  res.end(JSON.stringify(items));
 });
 });
  });
 });

});
{% endhighlight %}
<p>To return a specific location (as a document) from Mongo, we use the findOne() command and pass in the location's id from the URL.</p>
{% highlight js %}// returns a specific location by id
app.get('/v.1/locations/:location_id', function(req, res){

 var ObjectID = require('mongodb').ObjectID;

 require('mongodb').connect(mongourl, function(err, conn){
  conn.collection('locations', function(err, coll){
 coll.findOne({'_id':new ObjectID(req.params.location_id)}, function(err, document) {
 res.writeHead(200, {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*"
 });
 res.end(JSON.stringify(document));
 });
  });
 });

});
{% endhighlight %}
<p>To create a facility for a location, we POST the entire JSON for the facility and then add the id for the parent location from the URL before inserting it into the collection.</p>
{% highlight js %}// creates a new facility for a location
app.post('/v.1/locations/:location_id/facilities', function(req, res){

 // add the location id to the json
 var facility = req.body;
 facility['location'] = req.params.location_id;

 require('mongodb').connect(mongourl, function(err, conn){
  conn.collection('facilities', function(err, coll){
 coll.insert( facility, {safe:true}, function(err){
 res.writeHead(200, {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*"
 });
 res.end(JSON.stringify(facility));
 });
  });
 });

});
{% endhighlight %}
<p>The last method updates a facility document with the findAndModify() method. The method finds the facility by id and updates the data PUT in the JSON payload.</p>
{% highlight js %}// updates a facility
app.put('/v.1/locations/:location_id/facilities/:facility_id', function(req, res){

 var ObjectID = require('mongodb').ObjectID;

 require('mongodb').connect(mongourl, function(err, conn){
  conn.collection('facilities', function(err, coll){
 coll.findAndModify({'_id':new ObjectID(req.params.facility_id)}, [['name','asc']], { $set: req.body }, {}, function(err, document) {
 res.writeHead(200, {
  "Content-Type": "application/json",
  "Access-Control-Allow-Origin": "*"
 });
 res.end(JSON.stringify(document));
 });
  });
 });

});
{% endhighlight %}

