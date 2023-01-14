---
layout: post
title:  Start Writing ES6 JavaScript in your Node.js Apps Today!
description: ECMAScript 6 (the next version of JavaScript) should be rolling out in browsers sometime this year. If you want to start using the awesome features of ES6  now  you have a couple of choices- 1. Use the Node.js Harmony flag ala node --harmony app.js  to enable the new   ES6 features in the language. 2. Run io.js which includes all stable ES6 features by default. 3. Write your code using ES6 and transpile it to ES5 using something like Babel   (formerly 6to5) or Traceur   . If you are like me and 
date: 2015-05-06 19:55:51 +0300
image:  '/images/pexels-pixabay-209620.jpg'
tags:   ["javascript"]
---
<p>ECMAScript 6 (the next version of JavaScript) should be rolling out in browsers sometime this year. If you want to start using <a href="http://es6-features.org/#Constants">the awesome features of ES6</a> <strong>now</strong> you have a couple of choices:</p>
<ol>
<li>Use the Node.js Harmony flag ala <code>node --harmony app.js</code> to enable the new ES6 features in the language.</li>
<li>Run io.js which includes all stable ES6 features by default.</li>
<li>Write your code using ES6 and transpile it to ES5 using something like <a href="https://babeljs.io">Babel</a> (formerly 6to5) or <a href="https://github.com/google/traceur-compiler">Traceur</a>.</li>
</ol>
<p>If you are like me and want to dip our toes into the ES6 water instead of making the plunge, here’s how you can build a simple Express app with parts of it, let’s say your modules, written using ES6 and then transpile them to ES5 like the rest of your code.</p>
<p>The most popular transpiler right now is <a href="https://babeljs.io/">Babel</a>. It does a really good job of generating vanilla ES5 JavaScript, supports a multitude of browsers and has great docs! You can use the require hook (e.g., <code>require("babel/register")</code>) to transpile your code at runtime but I prefer to deploy transpiled code instead. If you are using something like grunt, gulp, brocolli or [insert JS community’s build tool of the day], there are plugins to transpile your code as part of your current workflow. We’re going to use the (simple) Babel CLI to transpile our code.</p>
<p>First thing we’ll do is use the <a href="http://expressjs.com/starter/generator.html">Express Generator</a> to scaffold a basic app for us.</p>
{% highlight js %}express my-es6-app
{% endhighlight %}
<p>Now create the source file for your ES6 code. This is the module we’ll write that will be transpiled to ES5.</p>
{% highlight js %}mkdir lib
mkdir lib/src
touch lib/src/greet.es6
{% endhighlight %}
<p>The code for our ES6 module (lib/src/greet.es6) is <strong>ridiculously simple</strong>.</p>
{% highlight js %}export default class Greeter {
 constructor(name) {
  this.name = name;
 }
 sayHello() {
  return "Hello " + this.name;
 }
}
{% endhighlight %}
<p>Now that we have our ES6 code in place we’ll need to install Babel and have it perform the work on transpiling it.</p>
{% highlight js %}npm install --global babel
{% endhighlight %}
<p><a href="https://babeljs.io/docs/usage/cli/">There many ways to transpile your code</a> but I like to set up a watch so that whenever my code changes it is automatically compiled into the correct file structure.</p>
{% highlight js %}babel lib/src/greet.es6 --out-file lib/greet.js --watch
{% endhighlight %}
<p>So now we’re all set. We’ve written our ES6 code and used Babel to transpile it into vanilla ES5. All we need to do now is use it in our application. So let’s add it to the route for our home page in <code>/routes/index.js</code>.</p>
{% highlight js %}var express = require('express');
var router = express.Router();
// require our module
var Greeter = require("../lib/greet.js");
// call the sayHello function
var greeting = new Greeter('Jeff').sayHello();

/* GET home page. */
router.get('/', function(req, res) {
 // display the greetings as the title of the app
 res.render('index', { title: greeting });
});

module.exports = router;
{% endhighlight %}
<p>So now you have a simple way to use ES6 features in your ES5 app today!!</p>

