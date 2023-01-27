---
layout: post
title:  Node-RED for Topcoder Challenges with IBM Bluemix & Watson
description: For the past week Ive been obsessed with Node-RED . If you are not familiar with it, Node-RED is an open source IBM technology for wiring together hardware devices, APIs and online services in new and interesting ways. Since Node-RED is built on Node.js, this makes it ideal to run at the edge of the network on low-cost hardware such as an Arduino or Raspberry Pi as well as in the cloud. Similar in methodology to Yahoo! Pipes, Node-RED initially started as a visual tool for wiring IoT but has de
date: 2015-07-28 20:40:18 +0300
image:  '/images/node-red-bluemix.png'
tags:   ["node-red"]
---
<p>For the past week Ive been obsessed with <a href="http://nodered.org">Node-RED</a>. If you are not familiar with it, Node-RED is an open source IBM technology for wiring together hardware devices, APIs and online services in new and interesting ways. Since Node-RED is built on Node.js, this makes it ideal to run at the edge of the network on low-cost hardware such as an Arduino or Raspberry Pi as well as in the cloud.</p>
<p>Similar in methodology to Yahoo! Pipes, Node-RED initially started as a visual tool for wiring IoT but has developed into a service that can do all sorts of crazy things. Installation is simple but to make life easier, <a href="https://console.ng.bluemix.net/">IBM Bluemix</a> offers a Node-RED template so you can get a web app up and running in no time.</p>
<p>I went through the create your first flows <a href="http://nodered.org/docs/getting-started/first-flow.html">tutorials</a> but I wanted to make something more substantial utilizing some of the super sweet <a href="http://www.ibm.com/smarterplanet/us/en/ibmwatson/">IBM Watson services</a>. Heres what I created, and in the end, it was ridiculously simple to build.</p>
<div class="flex-video"><iframe width="640" height="360" src="https://www.youtube.com/embed/mXdIbHkdQ2E" frameborder="0" allowfullscreen></iframe></div>
<p>Here's an overview of the Node-RED flow:</p>
<ul>
<li>Calls the topcoder RSS feed for JavaScript challenges every hour.</li>
<li>For each new challenge, call the challenge API to get its details.</li>
<li>The flow only processes challenges where the type is 'Assembly Competition and the total prize money is greater than $1500.</li>
<li>Translate the name of the challenges and its requirements into Spanish using the Watson Machine Translation service.</li>
<li>Save the Spanish overview of the challenge to MongoDB.</li>
<li>Tweet the challenge name (in Spanish) and a link to this application so that the Spanish requirements can be viewed.</li>
</ul>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-flow.png" alt="node-red" ></p>
<p>The flow tweets a link to the app (<a href="http://jeffdonthemic-node-red.mybluemix.net/challenge?id=:id">http://jeffdonthemic-node-red.mybluemix.net/challenge?id=:id</a>) so that people can view the Spanish version of the challenge. Building the REST endpoint was almost laughable. Node-RED provides input and output node for http request/response, allowing for the creation of simple web services. My endpoint does the following:</p>
<ul>
<li>Fetches the challenge from MongoDB using the challenge id passed.</li>
<li>Generates output HTML with the Spanish data using a mustache template.</li>
<li>Writes the template to the output stream displaying the Spanish challenge content in the browser.</li>
</ul>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-rest.png" alt="node-red" ></p>
<h2 id="ibmbluemixsetup">IBM Bluemix Setup</h2>
<p>Login to your <a href="https://console.ng.bluemix.net/">IBM Bluemix console</a> and create a new Cloud Foundry App using the <strong>Node-RED Starter</strong> boilerplate. Ensure you add a MongoDB service (I chose MongoLab) and the Watson Language Translation service. Youll need the credentials from the Language Translation service when building the flow so click the Show Credentials link and keep them handy.</p>
<h2 id="buildingtheflow">Building the Flow</h2>
<p>Our application is simply built by finding a node in the left panel, dragging it onto the tab and connecting them together.</p>
<p>To get started, add a Feedparse node for the topcoder RSS feed and enter <a href="https://www.topcoder.com/challenges/feed?list=active&contestType=develop&technologies=JavaScript">this URL</a> for the feed URL.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-1.png" alt="node-red" ></p>
<p>The feedparse node passes a <code>msg.topic</code> for each entry so parse the ID of the challenge and build the <code>msg.url</code> to pass to the next node.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-2.png" alt="node-red" ></p>
<p>Make a GET request to the url passed in <code>msg.url</code> (instead of in the URL form field) and pass the response to the next node as a parsed JSON object.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-3.png" alt="node-red" ></p>
<p>Add a Switch node so that we only process flows where the challenge type is 'Assembly Competition.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-4.png" alt="node-red" ></p>
<p>Add a Function node that calculates the total prize amount and passes it along in the message.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-5.png" alt="node-red" ></p>
<p>Now we add another Switch node which continues the flow only if the total prize money is greater than $1500.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-6.png" alt="node-red" ></p>
<p>Add another all purpose Function node and prep the challenge data for translation. Add the challenge object to the payload and challenge name itself to the payload for the next node (Watson Translation).</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-7.png" alt="node-red" ></p>
<p>Add the Watson Translation node and enter your credentials for the service. The node translates the name and passes it to the next node as its payload.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-8.png" alt="node-red" ></p>
<p>Add another function node and set the challenge name to the newly translated challenge name and add the requirement payload so that they can be translated.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-9.png" alt="node-red" ></p>
<p>Add another Watson Translation node and translate the requirements into Spanish.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-10.png" alt="node-red" ></p>
<p>Add a final Function node and prep the payload to be saved in MongoDB and tweeted. First we replace the English requirements with the newly translated Spanish ones and create two object for the outputs. We then wire these two outputs to their corresponding nodes.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-11.png" alt="node-red" ></p>
<p>Add a mongo output node to save the <code>msg.payload</code> object to the challenges collection. Connect the top output in the previous node to this one.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-12.png" alt="node-red" ></p>
<p>Lastly, add a twitter out node, connect the bottom output from the previous node to it and then authenticate with your twitter credentials.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-13.png" alt="node-red" ></p>
<p>If you deploy the workspace now it should run the Feedparse and automagically persist data to MongoDB and tweet assuming everything is setup properly.</p>
<h2 id="buildingthewebservice">Building the Web Service</h2>
<p>Now we need to build our web service so that when people click on the link in the tweet, it displays the challenge information in Spanish in their browser.</p>
<p>Add a new sheet to your workspace, drag an http input node onto it and setup the method and URL. When the /challenges endpoint receives a request it passes it to the next node.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-rest-1.png" alt="node-red" ></p>
<p>Add a Function node that simply parses the challenge id from the URL string and adds it to the payload.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-rest-2.png" alt="node-red" ></p>
<p>Then use a MongoDB node to find the challenge record by id in the challenges collection.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-rest-3.png" alt="node-red" ></p>
<p>Add another Function node that simply uses the first record returned in the array from MongoDB and adds it to the <code>msg.payload</code>. This is done to make it easier to work with in the templating node.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-rest-4.png" alt="node-red" ></p>
<p>Lastly, we want to make the HTML for the user (somewhat) pretty so we use a Template node and use mustache to format the <code>msg.payload</code>.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-rest-5.png" alt="node-red" ></p>
<p>Then we simply use an http response node to send the HTML response back to the initial http request and we are done!</p>
<h2 id="results">Results</h2>
<p>Now when the flow receives new challenge entries in the RSS feed, it will run the flow then tweet the challenge info in Spanish and display the Spanish version of the challenge on the web page for users to view.</p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-tweet.png" alt="node-red" ></p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/07/node-red-webpage.png" alt="node-red" ></p>

