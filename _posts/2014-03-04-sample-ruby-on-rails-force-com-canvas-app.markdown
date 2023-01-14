---
layout: post
title:  Sample Ruby on Rails Force.com Canvas App
description: Force.com Canvas apps are a great way to extend the Force.com platform with existing legacy apps or to take advantage of existing packages and libraries on other platforms. Lately Ive been writing a lot of node.js apps but needed to whip up a quick demo using Rails and found it a little more difficult than I would have liked due to the restriction that Canvas apps need to run on https. So I put together a sample Force.com Canvas application using rails 4, restforce  and  tunnels  so you can run 
date: 2014-03-04 14:43:56 +0300
image:  '/images/slugs/sample-ruby-on-rails-force-com-canvas-app.jpg'
tags:   ["ruby", "salesforce"]
---
<p>Force.com Canvas apps are a great way to extend the Force.com platform with existing legacy apps or to take advantage of existing packages and libraries on other platforms. Lately I've been writing a lot of node.js apps but needed to whip up a quick demo using Rails and found it a little more difficult than I would have liked due to the restriction that Canvas apps need to run on https.</p>
<p>So I put together a sample <a href="http://www.salesforce.com/us/developer/docs/platform_connect/canvas_framework.pdf">Force.com Canvas</a> application using rails 4, <a href="https://github.com/ejholmes/restforce">restforce</a> and <a href="https://github.com/jugyo/tunnels">tunnels</a> so you can run https from localhost. <strong><a href="https://github.com/jeffdonthemic/rails-canvas">You can grab the code here.</a></strong></p>
<h3 id="connectedappsetup">Connected app setup</h3>
<p>The first thing we need to do is create a new Connected App for our Canvas application. Log into your DE org and go to Setup -> Build -> Create -> Apps and click the <em>New</em> button at the bottom in the Connected Apps section.</p>
<p>Enter the <em>Connected App Name</em> (this is the display name for your app), <em>API Name</em> (this is how you'll reference your app) and your <em>Contact Email</em>.</p>
<p>Check the <em>Enable OAuth Setting</em> checkbox and enter your <em>Callback URL</em> as <strong><a href="https://localhost">https://localhost</a></strong> and for the <em>Selected OAuth Scopes</em>, select <strong>Full access (full)</strong>.</p>
<p>In the Canvas App Settings section, check the <em>Force.com Canvas</em> checkbox, enter <strong><a href="https://localhost/canvas">https://localhost/canvas</a></strong> for <em>Canvas App URL</em>, set <em>Access Method</em> to <strong>Signed Request (POST)</strong> and select <strong>Chatter Tab</strong> for <em>Locations</em>.</p>
<p>Your resulting app should look something like:</p>
<p><img src="images/canvas-app_helinn.png" alt="" ></p>
<p>Now we need to give your user access to this new app. Go to Setup -> Administrator -> Manage Apps -> Connected App and click the <em>Edit</em> link for your new app. Select <strong>Admin approved users are pre-authorized</strong> for <em>Permitted Users</em> and save the app.</p>
<p>The last step is to give your profile access to the app so that it will show up on the Chatter tab. Go to Setup -> Administer -> Manage Users -> Profiles and click the Edit link next to your profile (assumed it's SysAdmin). Now check the box next to your new app in the <em>Connected App Access</em> section and save the page.</p>
<p>Now if you click the Chatter tab, you should see your new app in the left sidebar.</p>
<h3 id="installtherailscanvasapp">Install the rails-canvas app</h3>
<p>Now for the fun part. Let's clone the repo and setup the rails app.</p>
{% highlight js %}# clone this repo
git clone git@github.com:jeffdonthemic/rails-canvas.git
cd rails-canvas
# install the required gems
bundle
{% endhighlight %}
<p>Now we need to add our the <em>Consumer Secret</em> from our Connected app. Go back to your app and click on the <strong>Click to reveal</strong> link to display the secret. Now add this as your client secret for the app in terminal:</p>
{% highlight js %}# add the app's secret to the environment
export CLIENT_SECRET=YOUR-SECRET
{% endhighlight %}
<h3 id="starttheapplication">Start the application</h3>
<p>Canvas apps need to run on https but this makes it difficult to develop and test on your local machine. However, with ruby you can use <a href="https://github.com/jugyo/tunnels">tunnels</a> to proxy from https from http. In terminal, start your rails server:</p>
{% highlight js %}rails s
{% endhighlight %}
<p>Now open another tab in terminal and fire up tunnels:</p>
{% highlight js %}sudo tunnels 443 3000
{% endhighlight %}
<p>I had some issues using tunnels due to rvm, so I had to use:</p>
{% highlight js %}rvmsudo tunnels 443 3000
{% endhighlight %}
<p>After enter your password, you should see:</p>
<p><strong>127.0.0.1:443 --(--)--> 127.0.0.1:3000</strong></p>
<p>You'll want to visit <a href="https://localhost">https://localhost</a> in your browser and accept any warning due to a perceived certificate error. This will block your Canvas app from running.</p>
<p><img src="images/canvas-app1_bd79hv.png" alt="" ></p>
<p>Now you can go to the Chatter tab and access your application from the left sidebar. If everything works correctly, you should see a list of 10 contacts. There's also a page that displays your connection from Force.com.</p>

