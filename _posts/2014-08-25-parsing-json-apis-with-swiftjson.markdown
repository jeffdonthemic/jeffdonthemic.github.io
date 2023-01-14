---
layout: post
title:  Parsing JSON APIs with SwiftyJSON
description: Parsing JSON using Swift is not a happy task. One of the first things I wanted to do in a Playground was call the topcoder API  and start playing with the returned challenge data. Unfortunately parsing JSON in data is almost akin to chewing glass right now (hopefully it will get better). You would think that since working with JSON is such a fundamental task nowadays, that it would be much easier, but no  . I poked around for awhile and found David Owens blog on JSON parsing  but it was much mor
date: 2014-08-25 08:51:59 +0300
image:  '/images/slugs/parsing-json-apis-with-swiftjson.jpg'
tags:   ["swift"]
---
<p>Parsing JSON using Swift is not a happy task. One of the first things I wanted to do in a Playground was call the <a href="http://api.topcoder.com/v2/develop/challenges?pageSize=2">topcoder API</a> and start playing with the returned challenge data.</p>
<p><img src="http://www.myextralife.com/wp-content/uploads/2009/04/this-is-hard.jpg" alt="" ></p>
<p>Unfortunately parsing JSON in data is almost akin to chewing glass right now (hopefully it will get better). You would think that since working with JSON is such a fundamental task nowadays, that it would be much easier, <a href="https://www.google.com/webhp?sourceid=chrome-instant&ion=1&espv=2&ie=UTF-8#q=swift%20parse%20json">but no</a>. I poked around for awhile and found <a href="http://owensd.io/2014/06/18/json-parsing.html">David Owens' blog on JSON parsing</a> but it was much more time than I wanted to invest in. I think JSON parsing should be simple and I think I finally found something that fits the bill.</p>
<p>I stumbled across the <a href="https://github.com/lingoer/SwiftyJSON">SwiftyJSON</a> repo and it looks promising. It was much easier for me to grok and include in a Playground to test with.</p>
<p>So here a little snippet (thanks to <a href="http://jamesonquave.com/blog/developing-ios-apps-using-swift-tutorial-part-2/">Jameson Quave</a>!) on how to call the topcoder API from Playground. Notice there's a spot in the code below (<a href="https://gist.github.com/jeffdonthemic/d77e6626606ab5fccfd3">also available in this gist</a>) where you simply paste in the SwiftyJSON code to use it.</p>
{% highlight js %}import Foundation
import XCPlayground

XCPSetExecutionShouldContinueIndefinitely()

/**
* Paste all the code from the following file
 - https://github.com/lingoer/SwiftyJSON/blob/master/SwiftyJSON/SwiftyJSON.swift
**/

let urlPath = "http://api.topcoder.com/v2/challenges?pageSize=2"
let url: NSURL = NSURL(string: urlPath)
let session = NSURLSession.sharedSession()
let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
  
  if error != nil {
  // If there is an error in the web request, print it to the console
  println(error.localizedDescription)
  }
  
  var err: NSError?
  var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
  if err != nil {
  // If there is an error parsing JSON, print it to the console
  println("JSON Error \(err!.localizedDescription)")
  }
  
  let json = JSONValue(jsonResult)
  let count: Int? = json["data"].array?.count
  println("found \(count!) challenges")
  
  if let ct = count {
  for index in 0...ct-1 {
  // println(json["data"][index]["challengeName"].string!)
  if let name = json["data"][index]["challengeName"].string {
    println(name)
  }
  
  }
  }
})
task.resume()
{% endhighlight %}
<p>The first thing we need to do is import the XCPlayground framework and add XCPSetExecutionShouldContinueIndefinitely(). This allows for asynchronous operations so that Playground can return the results from the API call after all top levels commands have executed and the process normally ends.</p>
<p>Then, of course, we need to paste the contents of the <a href="https://github.com/lingoer/SwiftyJSON/blob/master/SwiftyJSON/SwiftyJSON.swift">SwiftyJSON</a> source into our Playground so we get all the JSON-parsing goodness.</p>
<p>The next few lines of code just setup our API call to retrieve our challenges JSON payload. We create the task on line 14 and then kick it off on line 42 with task.resume().</p>
<p>The meat of the Playground is the last parameter of dataTaskWithURL which is a closure that gets called upon completion of the request. Then we check for errors and parse the JSON result into a NSDictionary.</p>
<p>Here's where we start using SwiftyJSON, casting the JSON result as it's JSONValue. Now we can access it as a familiar associative array to find the nested values we need. Viola!</p>

