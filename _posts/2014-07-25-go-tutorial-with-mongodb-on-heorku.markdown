---
layout: post
title:  Go Tutorial with MongoDB on Heorku
description: Ive spent the last couple of days digging into Go  and getting the feel for it and so far I really like it. It built a small web app using MongoDB and Heroku and thought I would share the process. Here is the  source code  and you can run the application here  to get a feel for how it works. Its a simple app that allows people to post images or videos of where they work, i.e., their cribs. Go is different than most other languages in a number of ways. Its not about object-oriented programming or
date: 2014-07-25 13:00:01 +0300
image:  '/images/pexels-andrea-piacquadio-3767399-1.jpg'
tags:   ["code sample"]
---
<p>I've spent the last couple of days digging into <a href="http://golang.org/">Go</a> and getting the feel for it and so far I really like it. It built a small web app using MongoDB and Heroku and thought I would share the process. <strong>Here is the <a href="https://github.com/topcoderinc/cribs">source code</a> and you can <a href="http://tc-cribs.herokuapp.com">run the application here</a> to get a feel for how it works.</strong> It's a simple app that allows people to post images or videos of where they work, i.e., their 'cribs'.</p>
<p>Go is different than most other languages in a number of ways. It's not about object-oriented programming or functional programming. It about getting stuff done. Build times are almost negligible and the code runs super fast. It's concurrency model is very powerful and it’s standard library provides almost everything you need out of the box. For a good overview of what Go is, how it was devised and why it is so cool, <a href="http://www.zhubert.com/blog/2014/01/12/introduction-to-go-golang-part-1/">check out this blog post</a>.</p>
<h2 id="learninggolang">Learning Golang</h2>
<p>Here are some links that I found useful. For installation, the <a href="http://golang.org/doc/install">Getting Start</a> docs should work for you but you may want to take a peek at <a href="https://gophercasts.io/lessons/1-getting-started-with-go">this short screencast</a>.</p>
<p>I started off with the interactive <a href="http://tour.golang.org/#1">Tour of Go</a>. The tour is divided into three sections: basic concepts, methods and interfaces, and concurrency. Throughout the tour you will find a series of exercises for you to complete. Click the Run button for each section to compile and run the program on a remote server. No software installation needed to get start playing. If you are feeling adventurous, you can head over to the <a href="http://play.golang.org">Go Playground</a> and run your own code. Great for testing snippet you find or code you want to experiment with.</p>
<p>You definitely want to check out the <a href="http://golang.org/doc/">Go docs</a> and <a href="http://golang.org/ref/spec">language specs</a> next.</p>
<p>I found <a href="http://golang.org/doc/code.html">How to Write Go Code</a> a god start as it demonstrates the development of a simple Go package and introduces the go tool, the standard way to fetch, build, test and install Go packages and commands. However, if you prefer, there is a <a href="http://www.youtube.com/watch?v=XCsL89YtqCs">video version</a> instead.</p>
<p>A must read for any new Go programmer is <a href="http://golang.org/doc/effective_go.html">Effective Go</a>. The document gives tips for writing clear, idiomatic Go code.</p>
<h3 id="books">Books</h3>
<p>If you prefer books (or PDFs of books), I found the following to be really helpful:</p>
<p><a href="http://www.golang-book.com">An Introduction to Programming in Go</a></p>
<p><a href="https://github.com/miekg/gobook">Learning Go</a> - a free PDF for learning the Go language. You can build the code yourself or <a href="http://miek.nl/downloads/Go/">download the PDF</a></p>
<p><a href="http://www.golangbootcamp.com/book/">Go Bootcamp</a> (by Matt Aimonetti) - The PDF is available <a href="https://softcover.s3.amazonaws.com/38/GoBootcamp/ebooks/GoBootcamp.pdf?AWSAccessKeyId=AKIAJMNNDDBSYVXVHGAA&Signature=ZOX3sL7jFrN2D41hJnX9BJIPJ4A%3D&Expires=1406038427">here</a>.</p>
<h3 id="resourcesites">Resource Sites</h3>
<p>I think my favorite site is <a href="http://learnxinyminutes.com/docs/go/">Learn X in Y minutes, Where X=Go</a>. The site has one long Go file with a ton of effective commenting that teaches concepts along the way. <strong>I really love this site.</strong></p>
<p><a href="https://gobyexample.com">Go by Example</a> is a hands-on introduction to Go using annotated example programs.</p>
<p>If you are fan of Railscasts, there a <a href="https://gophercasts.io">Gophercasts</a> with a couple of good videos, especially for Postgres and Martini.</p>
<p>And finally <a href="http://www.giantflyingsaucer.com/blog/?p=4720">Go (Golang) Pointers in 5 Minutes</a> covers of course pointers in Go. Not surprising.</p>
<h2 id="gohelp">Go Help</h2>
<p>If you need a little help now and then, there is of course <a href="http://stackoverflow.com/questions/tagged/go">Stackoverflow</a> and the go-nuts IRC channel, <code>freenode.net#go-nuts</code>. If you are keen on Slack, <a href="http://blog.gopheracademy.com/gophers-slack-community">Gohper Academy just announced a new Slack community</a> you can join.</p>
<h2 id="buildingtopcodercribs">Building Topcoder 'Cribs'</h2>
<p>I learn best by doing so I looked around for something to build. I wanted something a little more than a <code>hello world</code> but definitely not production quality. One thing we want to do with topcoder is allow members to post pictures and video of where they work, i.e., <a href="http://www.mtv.com/shows/cribs/series.jhtml">their cribs</a>.</p>
<p>So the first thing I did was look around for a web framework for Go. There's a great <a href="http://www.reddit.com/r/golang/comments/1yh6gm/new_to_go_trying_to_select_web_framework/">reddit thread</a> with a <strong>ton</strong> of info. The Square Engineering blog also has an <a href="http://corner.squareup.com/2014/05/evaluating-go-frameworks.html">in-depth analysis</a> as well with their winner. I finally decided to use <a href="http://martini.codegangsta.io/">Martini</a> for a couple of reasons: 1) it smells a lot like Express and Sinatra so it was easy for me to grok, has a huge community and seems to be growing by leaps and bounds.</p>
<p>Let's walk through some of the code. Server.go is where all of the action happens. It's pretty small but straight forward and well documented so you can see what's going on.</p>
{% highlight js %}package main

import (
 "os"
 "github.com/codegangsta/martini"
 "github.com/codegangsta/martini-contrib/render"
 "github.com/codegangsta/martini-contrib/binding"
 "labix.org/v2/mgo"
 "labix.org/v2/mgo/bson"
)

// the Crib struct that we can serialize and deserialize into Mongodb
type Crib struct {
 Handle string `form:"handle"`
 URL string `form:"url"`
 Type string `form:"type"` 
 Description string `form:"description"`
}

/* 
  the function returns a martini.Handler which is called on each request. We simply clone 
  the session for each request and close it when the request is complete. The call to c.Map 
  maps an instance of *mgo.Database to the request context. Then *mgo.Database
  is injected into each handler function.
*/
func DB() martini.Handler {
 session, err := mgo.Dial(os.Getenv("MONGO_URL")) // mongodb://localhost
 if err != nil {
  panic(err)
 }

 return func(c martini.Context) {
  s := session.Clone()
  c.Map(s.DB(os.Getenv("MONGO_DB"))) // local
  defer s.Close()
  c.Next()
 }
}

// function to return an array of all Cribs from mondodb
func All(db *mgo.Database) []Crib {
 var cribs []Crib
 db.C("cribs").Find(nil).All(&cribs)
 return cribs
}

// function to return a specific Crib by handle
func Fetch(db *mgo.Database, handle string) Crib {
 var crib Crib
 db.C("cribs").Find(bson.M{"handle": handle}).One(&crib)
 return crib
}

func main() {

 m := martini.Classic()
 // specify the layout to use when rendering HTML
 m.Use(render.Renderer(render.Options {
  Layout: "layout",
 }))
 // use the Mongo middleware
 m.Use(DB())

 // list of all cribs
 m.Get("/", func(r render.Render, db *mgo.Database) {
  r.HTML(200, "list", All(db))
 }) 

 /* 
  create a new crib the form submission. Contains some martini magic. The call 
  to binding.Form(Crib{}) parses out form data when the request comes in. 
  It binds the data to the struct, maps it to the request context and
  injects into our next handler function to insert into Mongodb.
 */  
 m.Post("/", binding.Form(Crib{}), func(crib Crib, r render.Render, db *mgo.Database) {
  db.C("cribs").Insert(crib)
  r.HTML(200, "list", All(db))
 }) 

 // display the crib for a specific user
 m.Get("/:handle", func(params martini.Params, r render.Render, db *mgo.Database) {
  r.HTML(200, "display", Fetch(db, params["handle"]))  
 })  

 m.Run()

}
{% endhighlight %}
<p>Here is the layout template the all of the views use. The HTML for each view is injected into the layout.</p>
{% highlight js %}<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Topcoder Cribs</title>
  <link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.5.0/pure-min.css">
</head>

<body style="margin: 20px;">
<h1>Topcoder Cribs!</h1>
{{ yield }}
</body>
</html>
{% endhighlight %}
<p>The home page iterates over the array of all returned Cribs from mongodb and links them to the display page. It also contains a form to post new Cribs.</p>
{% highlight js %}<h2>Members' Cribs</h2>
<ul>
{{range .}}
 <li><a href="/{{.Handle}}">{{.Handle}}</a></li>
{{ end }}
</ul>

<form class="pure-form pure-form-stacked" style="padding-top:25px" action="/" method="POST">
  <fieldset>
  <legend>Add Your Crib!</legend>

  <label for="handle">Handle</label>
  <input id="handle" name="handle" type="text" placeholder="Your handle">

  <label for="url">URL</label>
  <input id="url" name="url" type="text" placeholder="Complete URL for images or just the ID for videos" style="width: 400px">


  <label for="type">Type</label>
  <select id="type" name="type">
  <option>Image</option>  
  <option>Youtube</option>
  <option>Vimeo</option>
  </select>  

  <label for="description">Description</label>
  <textarea id="description" name="description" rows="5" cols="50"></textarea>

  <button type="submit" class="pure-button pure-button-primary">Submit</button>
  </fieldset>
</form>
{% endhighlight %}
<p>Any finally the display page shows an image, youtube video or vimeo video based upon the type of Crib.</p>
{% highlight js %}<h2>{{.Handle}}'s Crib</h2>

{{ if eq .Type "Youtube" }} 
 <iframe width="560" height="315" src="//www.youtube.com/embed/{{ .URL }}" frameborder="0" allowfullscreen></iframe>
{{ else if eq .Type "Vimeo" }} 
 <iframe src="//player.vimeo.com/video/{{ .URL }}" width="500" height="281" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
{{ else }}
 <img src="{{ .URL }}">
{{end}}

<p>{{ .Description }}</p>
{% endhighlight %}
<h2 id="deployingtoheorku">Deploying to Heorku</h2>
<p>If you are deploying to Heroku you'll need to add the following files. The Heroku buildpack needs to know where to put your code in the image. Add the .godir file in your project root with your directory structure:</p>
{% highlight js %}github.com/topcoderinc/cribs
{% endhighlight %}
<p>You'll also need a Procfile in your project root so heroku knows what type of dyno to spin up:</p>
{% highlight js %}web: cribs -port=$PORT
{% endhighlight %}
<p>Finally, when creating your application add the buildpack flag and don't forget to add the Mongodb and environment variables:</p>
{% highlight js %}// create
heroku create -b https://github.com/kr/heroku-buildpack-go.git my-app

// add the mongolabs addon
heroku addons:add mongolab

// add the envrironment variables for mongolab. see environment.sh
{% endhighlight %}
<h2 id="wrapup">Wrapup</h2>
<p>So now I have my <a href="http://tc-cribs.herokuapp.com/">first Go application</a> running and am fairly happy with it. <strong>However</strong>, after building the app, <a href="http://stephensearles.com/?p=254">reading this rebuttal of Martini</a> and talking with a couple of Appirians that use Go, I'm thinking of scrapping Martini and using simply the standard Go library. <a href="http://blog.joshsoftware.com/2014/02/28/a-simple-go-web-app-on-heroku-with-mongodb-on-mongohq/">Here's an interesting blog post</a> that I have been looking at regarding this.</p>
<p>In the next blog post, I plan on deploying my app to AWS with Docker.</p>

