---
layout: post
title:  Problems Parsing JSON Responses with Apex
description: A couple of weeks ago I wrote an article and small demo of a REST web service call returning XML. It was my intention to do the same demo using JSON. However, I ran into a small sang; I couldnt get the Apex JSONObject to work. I worked on the code for most of the week before Christmas but couldnt beat it into submission. I may be a tad dense but I looked through the code, made a couple of changes but couldnt get the thing to work. I was able to parse some simple JSON objects but complex objects 
date: 2009-12-28 20:52:37 +0300
image:  '/images/slugs/problems-parsing-json-responses-with-apex.jpg'
tags:   ["2009", "public"]
---
<p>A couple of weeks ago I wrote an <a href="/2009/12/04/calling-a-rest-web-service-with-apex/" target="_blank">article and small demo</a> of a REST web service call returning XML. It was my intention to do the same demo using JSON. However, I ran into a small sang; I couldn't get the Apex JSONObject to work. I worked on the code for most of the week before Christmas but couldn't beat it into submission. I may be a tad dense but I looked through the code, made a couple of changes but couldn't get the thing to work.</p>
<p>I was able to parse some simple JSON objects but complex objects did not want to cooperate. I received a couple of responses from Twitter and not many people have had much luck using the JSONObject with complex responses.</p>
<p>I started by downloading the JSONObject class <a href="http://code.google.com/p/apex-library/source/browse/trunk/JSONObject/src/unpackaged/classes/JSONObject.cls" target="_blank">from here</a> and installed it into my Developer org. Then to use the Google Maps API Services I <a href="http://code.google.com/apis/maps/signup.html" target="_blank">signed up</a> for an API key and then took a look at their <a href="http://code.google.com/apis/maps/documentation/geocoding/#JSON" target="_blank">geocoding docs for JSON</a>.</p>
<p>I started off by trying to parse the JSON response from their <a href="http://maps.google.com/maps/geo?q=1600+Amphitheatre+Parkway,+Mountain+View,+CA&output=json&sensor=false" target="_blank">example URL</a>. I executed the following code anonymously:</p>
{% highlight js %}JSONObject jsonObject;
HttpRequest req = new HttpRequest();
Http http = new Http();
req.setMethod('GET');

String url = 'http://maps.google.com/maps/geo?q=1600+Amphitheatre+Parkway,+Mountain+View,+CA&amp;output=json&amp;sensor=false&amp;key=MY_API_KEY';

req.setEndpoint(url);
HTTPResponse resp = http.send(req);
JSONObject j = new JSONObject( resp.getBody() );
{% endhighlight %}
<p>This produced the error:</p>
<blockquote>System.TypeException: Invalid integer: -122.0843700</blockquote>
The JSON parser was supposed to return a string when it was not able to parse a value but it appeared to be choking on non-integers. I added the following to line 1374 before the value was returned:
<blockquote>new value( Integer.valueof(s) );</blockquote>
That at least seemed to fix the parsing problem, but now line 1335 was throwing a new error:
<blockquote>"Missing value"</blockquote>
I gave up hope using the Google Maps geocoding and thought I'd try a different approach. <a href="http://developer.yahoo.com/common/json.html" target="_blank">Yahoo! Web Services</a> has really good JSON service so I thought I would try and use this <a href="http://search.yahooapis.com/ImageSearchService/V1/imageSearch?appid=YahooDemo&query=jeffdouglas&output=json" target="_blank">JSON response</a>. My code executed successfully and I didn't receive any errors parsing the JSON response. My only problem was that I couldn't really debug it much as I received the following message due to all of the parsing of the values:
<blockquote>*********** MAXIMUM DEBUG LOG SIZE REACHED ***********</blockquote>
So now I'm kind of stuck. Ron Hess offered to help out and take a look. I'm sure other people would like to use the JSONObject Apex class!
