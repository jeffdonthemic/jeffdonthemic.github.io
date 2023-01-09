---
layout: post
title:  Roll Your Own Node CLI for Force.com
description: Id like to start off this post with two admissions- 1) I love the Force.com CLI  2) I dont know Go. Fact #2 makes it hard for me to extend the CLI for my own (selfish) purposes. However, I am fairly handy with JavaScript and Node.js so thats where I mostly work. Ive been using a node CLI for the past couple of months when prototyping new features with different Force.com APIs. Its been extremely useful when prototype/testing with the new Tooling API  (heres the gist  of the module Ive been worki
date: 2014-01-14 15:00:09 +0300
image:  '/images/slugs/node-cli-for-force-com.jpg'
tags:   ["2014", "public"]
---
<p>I'd like to start off this post with two admissions: 1) I love the <a href="https://force-cli.heroku.com/">Force.com CLI</a> 2) I don't know Go. Fact #2 makes it hard for me to extend the CLI for my own (selfish) purposes. However, I am fairly handy with JavaScript and Node.js so that's where I mostly work.</p>
<p>I've been using a node CLI for the past couple of months when prototyping new features with different Force.com APIs. It's been extremely useful when prototype/testing with the new <a href="http://wiki.developerforce.com/page/Tooling_API">Tooling API</a> (<a href="https://gist.github.com/jeffdonthemic/8290347">here's the gist</a> of the module I've been working on if you want to add the code). What's makes it so useful is that you just add your connected apps settings, authenticate using <a href="https://github.com/kevinohara80/nforce">nforce</a> (FTW!) and then go ahead making REST calls to Force.com. Super easy!</p>
<p><img src="images/force-cli-node_ev3ntt.png" alt="" ></p>
<p>I thought other might get some use out of it so I ripped out all of my crap code and pushed it to github. There are a couple of sample commands to get you started but feel free to make enhancements. It's also <a href="https://github.com/kriskowal/q">Promise-based</a> which should make life easier when dealing with Force.com APIs.</p>
<p>To get started from terminal, <a href="https://github.com/jeffdonthemic/force-cli-node">clone this repo</a> and run <code>npm install</code> to install the dependencies. You may also have to run <code>chmod 777 ./bin/cli</code> to make the file executable on OS X.</p>
<p>You'll then need to enter your connection parameters into <a href="https://github.com/jeffdonthemic/force-cli-node/blob/master/config.js">config.js</a> for Force.com. To test you connection, simply run <code>bin/cli login</code><br>
which should return a connection object.</p>
<p>To see the available commands run <code>bin/cli --help</code>.</p>
<p>As of right now, each command initially authenticates to Force.com before running. You may want to cache the connection in redis to speed things up. I did not want to add this dependency which would have made it harder to get started.</p>
<p>The code for the CLI is rather small and should be easy to grok. The CLI "executable" uses <a href="https://github.com/visionmedia/commander.js/">commander</a>, is self documenting and simply delegates calls to /lib/force.js.</p>
{% highlight js %}#!/usr/bin/env node

var program = require('commander'),
 force = require("../lib/force.js");

program
 .version('0.0.1')

program
 .command('login')
 .description('Logs into salesforce and returns an access token')
 .action(function(){
  force.login();
});

program
 .command('query [sobject]')
 .description('Queries for 5 records from the specified sObject.')
 .action(function(sobject){
  force.query(sobject);
});

program
 .command('fetch [sobject] [id]')
 .description('Fetches a specific record by id.')
 .action(function(sobject, id){
  force.fetch(sobject, id);
}); 

program
 .command('create [sobject] [name]')
 .description('Inserts a new record with a name only.')
 .action(function(sobject, name){
  force.insert(sobject, name);
});  

program
 .command('update [sobject] [id] [value]')
 .description('Updates a specific record with value as its name.')
 .action(function(sobject, id, value){
  force.update(sobject, id, value);
}); 

program.parse(process.argv);
{% endhighlight %}
<p>The real guts of the CLI is the force.js module which uses nforce to talk to Force.com.</p>
{% highlight js %}var nforce = require("nforce"),
 Q = require("q"),
 request = require('request'),
 config = require("../config.js").config;

var org = nforce.createConnection({
  clientId: config.sfdc.client_id,
  clientSecret: config.sfdc.client_secret,
  redirectUri: 'http://localhost:3000/oauth/_callback', 
  environment: config.sfdc.environment,
  mode: 'multi' 
 });  

// authenticate to force.com and returns connection object
function login() {
 var deferred = Q.defer();
 org.authenticate({ username: config.sfdc.username, password: config.sfdc.password}, function(err, resp){
  if(!err) {
 console.log('Access Token: ' + resp.access_token);
 deferred.resolve(resp);
  } else {
 console.log('Error connecting to Salesforce: ' + err.message);
 deferred.reject(err);
  }
 }); 
 return deferred.promise;
} 

// qeuries for 5 records by the specified sObject
function query(sobject) {

 login()
  .then(function(connection) {

 var q = 'select id, name from '+sobject+' limit 5';
 org.query(q, connection, function(err, resp){
  if(!err) {
   resp.records.forEach(function(item) {
  console.log(item.getId() + " -- " + item.Name); 
   });  
  } 
  if (err) console.log("ERROR: " + err.message); 
 });   

  });

}

// returns a specific record
function fetch(sobject, id) {

 login()
  .then(function(connection) {

 var record = nforce.createSObject(sobject, {id: id});

 org.getRecord(record, connection, function(err, resp){
  if(!err) console.log(resp.getId() + " -- " + resp.Name); 
  if (err) console.log("ERROR: " + err.message); 
 });   

  });

}

// inserts a new record for specified sObject (name field only)
function insert(sobject, name) {

 login()
  .then(function(connection) {

 var record = nforce.createSObject(sobject);
 record.name = name;

 org.insert(record, connection, function(err, resp){
  if(!err) console.log(resp); 
  if (err) console.log("ERROR: " + err.message); 
 });   

  });

}

// updates a specific record with a new name value
function update(sobject, id, newName) {

 login()
  .then(function(connection) {

 var record = nforce.createSObject(sobject, {id: id, name: newName});

 org.update(record, connection, function(err, resp){
  if(!err) console.log("Record updated."); 
  if (err) console.log("ERROR: " + err.message); 
 });   

  });

}

exports.login = login;
exports.query = query;
exports.fetch = fetch;
exports.insert = insert;
exports.update = update;
{% endhighlight %}
<p>Hope you enjoy it and it makes your life easier.</p>

