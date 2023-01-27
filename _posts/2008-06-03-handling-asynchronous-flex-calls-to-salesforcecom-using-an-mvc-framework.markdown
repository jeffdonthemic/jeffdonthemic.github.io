---
layout: post
title:  Handling asynchronous Flex calls to Salesforce.com using an MVC framework
description: Im working on a Flex applications using the Flex Toolkit for Apex and Model-Glue-Flex as the MVC framework. Ive got my main applications, controllers, models and views working well. One on my requirements is to make a call to Salesforce.com, fetch some user settings and then display a specific canvas depending on the returned values. I dispatch an event, the controller makes the request to Salesforce.com and passes it a responder to process the returned results. However due to the asynchronous n
date: 2008-06-03 08:48:02 +0300
image:  '/images/slugs/handling-asynchronous-flex-calls-to-salesforcecom-using-an-mvc-framework.jpg'
tags:   ["code sample", "salesforce", "flex"]
---
<p>I'm working on a Flex applications using the Flex Toolkit for Apex and Model-Glue:Flex as the MVC framework. I've got my main applications, controllers, models and views working well. One on my requirements is to make a call to Salesforce.com, fetch some user settings and then display a specific canvas depending on the returned values.</p>
<p>I dispatch an event, the controller makes the request to Salesforce.com and passes it a responder to process the returned results. However due to the asynchronous nature of the Flex Toolkit, I don't really know when the results are returned from Salesforce.com. Here's my solutions to notify my application when results are returned by Salesforce.com.</p>
<p>I setup a private member to track the status of the transaction:</p>
{% highlight js %}private var _transactionComplete:Boolean;
{% endhighlight %}
<p>I couldn't use public members as I wanted to listen for changes to _transactionComplete so I had to write getters/setters for the data binding and to process the notifications when the value was set:</p>
{% highlight js %}[Bindable]
public function set transactionComplete (value:Boolean):void
{
 _transactionComplete = value;
}

public function get transactionComplete ():Boolean
{
 if (_transactionComplete == true) {
  showCanvas();
 }
 return _transactionComplete; 
}

public function showCanvas():void {
 if (accountController.user.isAdmin) {
  // do something
 } else {
  // do something else
 }
}
{% endhighlight %}
<p>Since my controller does all of the heavy lifting, I added the following line to the responder which notify my application that the results have returned from Salesforce.com (Of course I have to reset my transactionComplete to false before I make the initial call to Salesforce.com):</p>
{% highlight js %}Application.application.transactionComplete = true;
{% endhighlight %}
<p>I'm not sure if this is the best method, but it solved my issue.</p>

