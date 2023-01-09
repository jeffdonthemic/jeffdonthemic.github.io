---
layout: post
title:  Getting Started with React & Flux
description: In the last couple of months youve probably heard talk around the watercooler about React  as a simpler and more maintainable way to build applications. It has received a lot of attention since  Googles Angular 2 announcement last fall  and theres been a noticable increase in the number blog posts, hacker news references and stackoverflow questions regarding it. If you are interested in seeing how you can leverage React for your next project youve come to the right place. There is no time like t
date: 2015-03-12 20:20:05 +0300
image:  '/images/161H.jpg'
tags:   ["2015", "public"]
---
<p>In the last couple of months you've probably heard talk around the watercooler about <a href="http://facebook.github.io/react/">React</a> as a simpler and more maintainable way to build applications. It has received a lot of attention since <a href="http://jaxenter.com/angular-2-0-112094.html">Google's Angular 2 announcement last fall</a> and there's been a noticable increase in the number blog posts, hacker news references and stackoverflow questions regarding it. If you are interested in seeing how you can leverage React for your next project you've come to the right place.</p>
<p>There is no time like the present to learn React and we are going to do so with a series of tutorials to build a banner management application with React, Node and MongoDB. We'll start off slowly with an introduction to React and <a href="http://facebook.github.io/flux/docs/overview.html">Flux</a>, then we'll build a bare-bones React app with Flux so you can see all of the working parts in motion and finally we'll round out the series with a full-fledged production app backed by an API with authentication and data persistence.</p>
<h2 id="whatreactis">What React Is?</h2>
<p><a href="http://facebook.github.io/react/">React</a> is Facebook's UI library for creating interactive, stateful & reusable UI components. It's the "V" in MVC and could care less about the rest of your technology stack. It has a lot of great features such as a Virtual DOM, one-way data flow, client and server-side rendering and more. We'll hit on a number of these topics shortly.</p>
<p>Let's start by clearing up any misconceptions about React right from the start. There's been a lot of talk on the interwebs lately about React as an alternative to Angular, Ember, Backbone or [insert random JavaScript framework]. Comparing React to other JavaScript frameworks, such as Angular, is like comparing Superman to Batman. One can fly, is impervious to harm, has super strength and heat vision while they other is really good with tech. Angular is a complete framework (views, routing, templating, dependency injection, directives, etc.) while React is simply a view layer. You can't build an SPA with React by itself. React needs help from Flux… it needs its Robin.</p>
<p><img src="http://4.bp.blogspot.com/_NLdfbB4o7jA/TLuvsQOrPuI/AAAAAAAAABs/sFOo6ms1vpg/s1600/batman-robin-dogs.png" alt="" ></p>
<p>In React functionality is incapsulated into components. You build components that have their own "properties" and "scope", so you can easily define the functionality of the component and reuse them as many times as you want without conflicting with one another. Each component defines a <code>render</code> function which returns the generated HTML from the component in the browser.</p>
<p>Components can be written in pure JavaScript or what Facebook calls JSX, a Javascript XML syntax. JSX allows you to write HTML inside of Javascript without having to wrap strings around it. Now we've all been conditioned to separate our functionality from our view, but if you think about it, they are actually intrinsic tied to one another. Once you get past the wierd syntax, combining JavaScript and its accompanying markup into a reusable component becomes quite refreshing.</p>
{% highlight js %}var HelloMessage = React.createClass({
 render: function() {
  var name = 'jeffdonthemic';
  return (
 <div>Hello {name}</div>;
  )
 }
});

React.render(<HelloMessage/>, document.body);
{% endhighlight %}
<p>You can either transform JSX into JavaScript at runtime in the browser but this is not recommended for production as it slows down page loads. You can use something like gulp or grunt to setup preprocess build tasks to do this for you.</p>
<p><strong>React is just a view layer. That's it. All React does is render HTML for you.</strong></p>
<p><img src="https://www.topcoder.com/wp-content/uploads/2015/03/one-does-not-react.jpg" alt="one-does-not-react" ></p>
<h2 id="whyreactissoawesome">Why React is so awesome</h2>
<p>React concepts are very easy to graps and the code, being simply JavaScript, is readable and easy to maintain. Once you understand the difference between properties and state you've got half the battle won. React implements a one-way data flow pattern which reduces boilerplate and make it easier to follow the flow of your application logic. (Side note: Angular 2 will also implement unidirectional data flow.)</p>
<p>React's main strength is that it is super fast at rendering markup. It uses a concept called the Virtual DOM that selectively renders DOM nodes based upon state changes for the component. So if you have a large HTML table and your state changes in only one row, React simply update the DOM for that single row instead of rewriting the entire DOM. Its diff algorithm does the least amount of DOM manipulation possible in order to keep your view up to date. (Side note: Angular 2 will also implement a Shadow DOM.)</p>
<p>React runs JavaScript on both the client & server in what is called <a href="http://berzniz.com/post/99158163051/isomorphic-javascript-angular-js-is-not-the">Isomorphic JavaScript</a>. While most frameworks use client-side DOM rendering, React provides a better experience by performing these actions server-side. Not only is it faster and easier to maintain, but code is indexable by search engines as well.</p>
<h2 id="reacttutorials">React Tutorials</h2>
<p>There are a ton of great resources for learning React so I'm not going to reinvent the wheel. My favorites are Ryan Clark's <a href="http://ryanclark.me/getting-started-with-react/">Getting started with React</a> (great overview), the <a href="https://egghead.io/technologies/react?order=ASC">egghead.io React tutorials</a> (don't skip these!!) and the <a href="https://scotch.io/tutorials/learning-react-getting-started-and-concepts">scotch.io Learning React.js</a> series. You also <strong>need</strong> to check out this <a href="https://github.com/enaqx/awesome-react#flux-tutorials">collection of awesome React libraries, resources and shiny things</a>. Tons of great stuff!</p>
<h2 id="whatisflux">What is Flux?</h2>
<p>Like I said, you cannot build a SPA simply with React. Every superhero needs a sidekick to do the dirty work, and in this case React's Robin is Flux. The main thing to understand is that Flux is an <em>architectural pattern</em> for building applications with React. Flux is not a framework nor a library nor any type of MVC paradigm.</p>
<p><a href="http://jonathancreamer.com/what-the-flux/">What the Flux?</a> has a far better explanation of this, but The Flux Application Architcture is composed of the following parts.</p>
<p><img src="http://blog.krawaller.se/img/flux-diagram.png" alt="" ></p>
<ol>
<li>Views - the rendered HTML from your component</li>
<li>Action Creators - dispatcher help methods that get more "stuff"</li>
<li>Actions - perform some type of action on the "stuff"</li>
<li>Dispatcher - notifies listeners that there is new "stuff"</li>
<li>Store - a singleton that holds state and business logic for your stuff</li>
</ol>
<p>So the flow is that your component's view triggers an event (e.g., user types text in a form field), that fires an event to update the model, then the model triggers an event and the component responds by re-rendering the view with the latest data. Simple!? Another great article you should read is <a href="http://blog.andrewray.me/flux-for-stupid-people/">Flux For Stupid People</a>.</p>
<p>Now, I'm not a rocket surgeon nor do I play one on TV but this looks like a lot of work and is pretty damn confusing when you look at some sample Flux code. Since Facebook doesn't provide a Flux library the community has implemented a number of their own including <a href="https://github.com/compose-ui/flux-dispatcher">Flux Dispatcher</a>, <a href="https://github.com/BinaryMuse/fluxxor">Fluxxor</a>, <a href="https://github.com/kjda/ReactFlux">ReactFlux</a>, <a href="https://www.npmjs.com/package/flux-action">Flux-Action</a> and <a href="https://github.com/spoike/refluxjs">RefluxJS</a>. I'll be using Reflux for this series. I found it much easier to grok then the other libraries, it has a "strong" community on github and is very straightforward to implement. <a href="http://blog.krawaller.se/posts/react-js-architecture-flux-vs-reflux/">React.js architecture - Flux VS Reflux</a> is a great article you should read regarding the differences and advantages of Reflux.</p>
<p>So that wraps up our first post in the series. In our next one we'll build a very simple React application with Reflux to demonstrate how this process works.</p>
<p><a href="https://www.topcoder.com/blog/building-with-react-flux-getting-started/">Crossposted from topcoder.</a></p>

