---
layout: post
title:  Force.com Streaming API with Ruby
description: I must publicly confess my love with the Force.com Streaming API . (Dont tell my wife.) Last September I wrote a blog post entitled, Node.js Demo with Force.com Streaming API & Socket.io that showed how to stream events from Saleforce.com to the browser using Node.js. It was a pretty cool app if you are familiar with Node.js. Then at Dreamforce 12 I did an Un-Conference session called, Log Force.com Events in REALTIME with Papertrail which was a knock-off but showed how to create an external log
date: 2013-01-16 14:51:39 +0300
image:  'http://articulate-wom.s3.amazonaws.com/blog/wp-content/uploads/2013/09/elearning-firehose.jpg'
tags:   ["2013", "public"]
---
<p>I must publicly confess my love with the <a href="http://www.salesforce.com/us/developer/docs/api_streaming/index.htm">Force.com Streaming API</a>. (Don't tell my wife.) Last September I wrote a blog post entitled, <a href="/2012/09/07/node-demo-with-force-com-streaming-api-socket-io/">Node.js Demo with Force.com Streaming API & Socket.io</a> that showed how to stream events from Saleforce.com to the browser using Node.js. It was a pretty cool app if you are familiar with Node.js.</p>
<p>Then at Dreamforce '12 I did an Un-Conference session called, "Log Force.com Events in REALTIME with Papertrail" which was a knock-off but showed how to create an external logger for Salesforce using the Force.com Streaming API. Pretty slick stuff but again in Node.js.</p>
<p>Well I've found a much easier way to use the Force.com Streaming API than my previous attempts thanks to the <a href="https://github.com/ejholmes/restforce">Restforce ruby gem</a>. According to <a href="https://github.com/ejholmes/restforce#streaming">the docs</a> "... the Restforce gem makes implementing pub/sub with Salesforce a trivial task". A bold statement but entirely true.</p>
<p>So I put together a sample rails app that you can use as a starter with the Force.com Streaming API. Just <strong><a href="https://github.com/jeffdonthemic/sfdc-rails-papertrail-logger">fork this repo</a></strong>, watch the video below and then follow the simple, step-by-step instructions on the repo to get started. The demo app streaming events from a "Log__c" custom object to the rails app with in turn uses <a href="http://papertrailapp.com">Papertrail</a> as a logger.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="150" src="https://www.youtube.com/embed/h1h_vGuIC2U?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>Here's the file that does the heavy lifting for you. It connects to your org with the Restforce client, starts listening for events on the "LogEntries" channel and then once it receives it, outputs it to Papertrail through "puts".</p>
{% highlight js %}require 'restforce'
require 'faye'

# Initialize a client with your username/password.
client = Restforce.new :username => ENV['SFDC_USERNAME'],
 :password  => ENV['SFDC_PASSWORD'],
 :security_token => ENV['SFDC_SECURITY_TOKEN'],
 :client_id => ENV['SFDC_CLIENT_ID'],
 :client_secret => ENV['SFDC_CLIENT_SECRET']

# simply for debugging
puts client.to_yaml

begin

 client.authenticate!
 puts 'Successfully authenticated to salesforce.com'

 EM.next_tick do
  client.subscribe 'LogEntries' do |message|
 puts "[#{message['sobject']['Level__c']}] #{message['sobject']['Class__c']} - #{message['sobject']['Short_Message__c']} (#{message['sobject']['Name']})"
  end
 end

rescue
 puts "Could not authenticate. Not listening for streaming events."
end
{% endhighlight %}

