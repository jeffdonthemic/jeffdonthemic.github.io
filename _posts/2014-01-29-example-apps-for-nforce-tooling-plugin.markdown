---
layout: post
title:  Example Apps for nforce-tooling Plugin
description: Yesterday I released the nforce-tooling plugin for nforce so today I thought I would follow up with some sample demos and a video walking through the process of using the plugin. The video walks through two demos. The first is for standard functions like describe, querying tooling objects and creating/deleting records. The second demo show how to deploy a new Apex class to your org. You can find the code for these demos in the examples directory for the plugin. To give you something to look at, 
date: 2014-01-29 15:52:03 +0300
image:  '/images/slugs/example-apps-for-nforce-tooling-plugin.jpg'
tags:   ["salesforce", "node.js"]
---
<p>Yesterday I released the <a href="https://github.com/jeffdonthemic/nforce-tooling">nforce-tooling plugin</a> for <a href="https://github.com/kevinohara80/nforce">nforce</a> so today I thought I would follow up with some sample demos and a video walking through the process of using the plugin.</p>
<p>The video walks through two demos. The first is for standard functions like describe, querying tooling objects and creating/deleting records. The second demo show how to deploy a new Apex class to your org. You can find the code for these demos in the <a href="https://github.com/jeffdonthemic/nforce-tooling/tree/master/examples">examples directory</a> for the plugin.</p>
<div class="flex-video"><iframe width="640" height="480" src="//www.youtube.com/embed/Ip6GBI5Vczk" frameborder="0" allowfullscreen></iframe></div>
<p>To give you something to look at, here is the <a href="https://github.com/jeffdonthemic/nforce-tooling/blob/master/examples/deploy.js">deploy.js code</a>.</p>
{% highlight js %}var nforce = require('nforce'),
 tooling = require('nforce-tooling')(nforce),
 Q = require("q");

var sfuser = process.env.SFUSER;
var sfpass = process.env.SFPASS;

// for the example, create a new class use the id here
var apexClassId = 'YOUR-APEX-CLASS-ID';
// the new code to update the class above with
var newApexCode = "public class ToolingDemo {\n String s = 's';\n}";
// we need this so we can clean up after ourselves
var metadataContainerId;

var org = nforce.createConnection({
 clientId: process.env.CLIENTID,
 clientSecret: process.env.CLIENTSECRET,
 redirectUri: 'http://localhost:3000/oauth/_callback',
 mode: 'single',
 plugins: ['tooling']
});

org.authenticate({ username: sfuser, password: sfpass}, function(err, resp){
 if(!err) {
  console.log('*** Starting Apex class deployment process... Hold tight. This is gonna be awesome. ***')
  createContainer('ExampleDeployContainer')
 .then(addUpdatedCode)
 .then(deploy) 
 .then(getDeployStatus)
 .fail(function(err) {
  console.log("== failure: " + err);
 });
 } else {
  console.log('Error connecting to Salesforce: ' + err.message);
 }
}); 

function createContainer(name) {
 var deferred = Q.defer();
 org.tooling.createContainer({name: name}, function(err, container) {
  // return the id of the newly created container
  if (!err) deferred.resolve(container.id);  
  if (err) deferred.reject(err);
 });   
 return deferred.promise;
}

function addUpdatedCode(containerId) {
 var deferred = Q.defer();

 // create the artifact that references the saved class and new code
 var artifact = org.tooling.createDeployArtifact('ApexClassMember', 
  {body: newApexCode, contentEntityId: apexClassId});

 org.tooling.addContainerArtifact({id: containerId, artifact: artifact}, function(err, resp) {
  // return the id of the container again
  if (!err) deferred.resolve(containerId)  
  if (err) deferred.reject(err);
 });   
 return deferred.promise;
}

function deploy(containerId) {
 var deferred = Q.defer();
 // so we can clean up
 metadataContainerId = containerId;
 org.tooling.deployContainer({id: containerId, isCheckOnly: false}, function(err, asnycContainer) {
  console.log('Deploying code...');
  // return the async container's id so we can check it's status
  if (!err) deferred.resolve(asnycContainer.id);
  if (err) deferred.reject(err);
 });
 return deferred.promise;
}

function getDeployStatus(asnycContainerId) {
 org.tooling.getContainerDeployStatus({id: asnycContainerId}, function(err, resp) {

  console.log('Checking status of the deployment...');
  if (resp.State === "Queued") {
 console.log("Status is currently queued. Checking deploy state again.");
 getDeployStatus(asnycContainerId);
  } else {
 if (resp.State === "Completed") {
  console.log("W00t! Code successfully deployed");
 } else if (resp.State === "Failed") {
  console.log("Deployment failed with: ");
  console.log(resp.CompilerErrors);
 } else if (resp.State === "Error") {
  console.log("Deployment failed with error: ");
  console.log(resp.ErrorMsg);
 } else {
  console.log("Deploy finished with a status of: " + resp.State);  
  console.log(resp);  
 }

 // delete the metadata container
 org.tooling.delete({type: 'MetadataContainer', id: metadataContainerId}, function(err, resp) {
  if (err) {
   console.log("Error deleting deployment container: " + metadataContainerId);
   console.log(err);
  }
 });  

  }
 });  
}
{% endhighlight %}

