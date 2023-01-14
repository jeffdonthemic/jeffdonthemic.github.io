---
layout: post
title:  Building Single Page Apps with React & Reflux for Salesforce
description: We are taking a slight detour in our Building with React & Flux series to show how straight forward it is to write Single Page Applications (SPA) with React and Reflux for Salesforce. If you are just hopping into this series then definitely check out the Building with React & Flux- Getting Started  to get up to speed on React  and Flux . In the last post  we built a simple app to manage banner ads using React and RefluxJS , an implementation of Flux. I thought to myself, ...self, lets take this 
date: 2015-04-03 16:53:37 +0300
image:  '/images/189H.jpg'
tags:   ["salesforce", "react", "javascript"]
---
<p>We are taking a slight detour in our Building with React & Flux series to show how straight forward it is to write Single Page Applications (SPA) with React and Reflux for Salesforce. If you are just hopping into this series then definitely check out the <a href="https://www.topcoder.com/blog/building-with-react-flux-getting-started/">Building with React & Flux: Getting Started</a> to get up to speed on <a href="http://facebook.github.io/react/">React</a> and <a href="http://facebook.github.io/flux/docs/overview.html">Flux</a>.</p>
<p>In the <a href="https://www.topcoder.com/blog/building-with-react-flux-hello-react-banners/">last post</a> we built a simple app to manage banner ads using React and <a href="https://github.com/spoike/refluxjs">RefluxJS</a>, an implementation of Flux. I thought to myself, "...self, let's take this same app and build it in Salesforce and see what it takes." Fortunately, given Salesforce's support for JavaScript with <a href="https://www.salesforce.com/us/developer/docs/pages/index_Left.htm#CSHID=pages_remote_objects.htm%7CStartTopic=Content%2Fpages_remote_objects.htm%7CSkinName=webhelp">Visualforce Remote Objects</a>, it wasn't that much of an effort to get something very similar on the Force.com platform in no time.</p>
<p><strong>See the video at the bottom for a complete demo or <a href="https://github.com/jeffdonthemic/react-banners-salesforce">grab the code from github</a>.</strong></p>
<p>The application isn't a game-changer and aims to demonstrate the basics of React and Reflux on Force.com. It consists of the following:</p>
<ol>
<li>The 'home' page shows a simple table of banners from the Banner__c custom object.</li>
<li>An HTML form to add a new banner that is of course inserted into the Banner__c custom object.</li>
<li>A page that displays a banner and toggles its display status. Of course this updates the actual record in the custom object.</li>
</ol>
<p><img src="images/ezgif-432990992-1.gif" alt="" ></p>
<h2 id="introtoreflux">Intro to Reflux</h2>
<p>Before we get started let's take a look at <a href="https://github.com/spoike/refluxjs">RefluxJS</a>, one of the many <a href="https://www.google.com/search?q=flux+framework&oq=flux+framework&aqs=chrome..69i57j0l4.1736j0j7&sourceid=chrome&es_sm=91&ie=UTF-8#q=flux+frameworks">Flux implementations</a>. In general, I found Flux difficult to grok and apparently I'm not alone. I read the FB docs, waded through various blog posts (<a href="http://blog.andrewray.me/flux-for-stupid-people/">Flux For Stupid People</a> and <a href="https://scotch.io/tutorials/getting-to-know-flux-the-react-js-architecture">Getting to Know Flux</a>) and even watched all of the <a href="https://egghead.io/technologies/react">egghead.io React and Flux videos</a> but I honestly didn't like it. Luckily I stumbled across <a href="http://blog.krawaller.se/posts/react-js-architecture-flux-vs-reflux/">React.js architecture - Flux VS Reflux</a> and it spoke to me. While Flux seemed architecturally complex and bloated with boilerplate code, Reflux seemed streamlined and succinct. I like its simplicity and use of mixins to add functionality. It drastically simplified the process of listening to changes in stores, made working with actions easier and less verbose and got rid of the Dispatcher entirely!! If you are interested in a comparison of the two then take some time to check out this <a href="http://blog.krawaller.se/posts/react-js-architecture-flux-vs-reflux/">blog post for a complete rundown</a>.</p>
<h2 id="gettingstarted">Getting Started</h2>
<p>We are going to the existing code from the previous post and modify it to run inside a Visualforce page. We'll use some of the same tools as last time but with a few tweaks. You won't be able to run the application locally but we will still minify our assets using gulp before upload them as static resources in Salesforce. First, clone the following repo to grab the code:</p>
{% highlight js %}git clone git@github.com:jeffdonthemic/react-banners-salesforce.git
{% endhighlight %}
<p>Then install all of the dependencies for the project defined in package.json:</p>
{% highlight js %}npm install
{% endhighlight %}
<h2 id="salesforceconfiguration">Salesforce Configuration</h2>
<p>The only real config we need to do is to create the following Banner__c custom object and expose a tab for it (if you'd like).</p>
<img src="images/_na16__Custom_Object__Banner___salesforce_com_-_Developer_Edition.png" width="500">
<p>The application uses <a href="https://www.codefellows.org/blog/quick-intro-to-gulp-js">gulp</a> to process and minify styles, concat JavaScript files and move processed files to a distribution directory so it's easier to upload them as Static Resource. Check out gulpfile.js for more details but essentially the only command we'll need is <code>gulp watch</code> so run that at the command like:</p>
{% highlight js %}gulp watch
{% endhighlight %}
<p>You should now see a couple of folders appear in the <code>/dist</code> directory. Zip up these <code>scripts</code> and <code>styles</code> folders and create a Static Resource in Salesforce named <code>banners</code> with that zip. This will get all of the JavaScript code that we are going to talk about in a second hosted on the platform. We'll reference these files in our Visualforce page.</p>
<h2 id="codewalkthrough">Code Walkthrough</h2>
<p>Let's take a look at the important files in the application. I won't cover everything but the great thing about React and Reflux is that it's rather straightforward and easy to follow. The SPA consists of a single Visualforce page. That's it. No controller. No Apex code at all. We'll be using <a href="https://www.salesforce.com/us/developer/docs/pages/index_Left.htm#CSHID=pages_remote_objects.htm%7CStartTopic=Content%2Fpages_remote_objects.htm%7CSkinName=webhelp">Visualforce Remote Objects</a> which create proxy objects that enable basic DML operations on sObjects directly from JavaScript. All of our logic and functionality resides in the JavaScript!</p>
<h3 id="bannerspage">Banners.page</h3>
<p>Since Visualforce is hosting our SPA, Banners.page is the only page that we'll need. It's mostly bootstrap markup with navigation, a title and a div <code>(id="app")</code> where React will render our application. Notice the script and style tags that reference the <code>banners</code>	 static resource we just uploaded.</p>
{% highlight js %}<apex:page standardStylesheets="false" sidebar="false"
  showHeader="false" applyBodyTag="false" applyHtmlTag="false"
  docType="html-5.0">
 <apex:remoteObjects jsNamespace="RemoteObjectModel">
 <apex:remoteObjectModel
  name="Banner__c"
  jsShorthand="Banner"
  fields="Id,Name,Image_URL__c,Target_URL__c,Active__c"/>
 </apex:remoteObjects>
 <html lang="en">
 <head>
 <meta charset="utf-8"/>
 <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
 <meta name="viewport" content="width=device-width, initial-scale=1"/>
 <meta name="description" content="A simple banner manager"/>
 <meta name="author" content="Jeff Douglas"/>
  <title>Banner Manager</title>
 <link rel="stylesheet" href="/resource/banners/styles/bootstrap.min.css"/>
 </head>
 <body>
  <div class="container">
 <div class="header" style="padding-bottom:25px">
  <nav>
   <ul class="nav nav-pills pull-right">
  <li role="presentation"><a href="#">Home</a></li>
  <li role="presentation"><a href="#/add">New Banner</a></li>
   </ul>
  </nav>
  <h3 class="text-muted">Banner Manager</h3>
 </div>
 <div class="row">
  <div class="col-lg-6">
   <div id="app"></div>
  </div>
 </div>
  </div>
  <script src="/resource/banners/scripts/app.js"></script>
 </body>
</html>
</apex:page>
{% endhighlight %}
<p>Perhaps the most important part of the Visualforce page are the apex tags at the top where we add the Remote Objects that the application will use. We define our remoteObjectModel and specify that it will proxy for the <code>Banner__c</code> custom object and give it an alias of Banner (for ease of use in JavaScript). We also specify the fields that the proxy will have access to in the custom object.</p>
<h3 id="appjs">App.js</h3>
<p>The app.js file is almost identical to the previous version. It sets up our application, defines the routes and renders the app. For our application we'll be using <a href="https://github.com/rackt/react-router">react-router</a> which provides... wait for it... wait for it... routing for our application. The <code>routes</code> variable defines the view hierarchy for our application. We then declare a view hierarchy with nested <code><Route/></code>s and provide them with a React element to handle the route when it's active.</p>
{% highlight js %}/** @jsx React.DOM */
var React   = require('react');
var Reflux  = require('reflux');
// routing
var Router  = require('react-router');
var RouteHandler = Router.RouteHandler;
var Route   = Router.Route;
var DefaultRoute = Router.DefaultRoute;
// view components
var ViewBanner  = require('./components/view');
var AddBanner = require('./components/add');
var Banners  = require('./components/banners');
// store
var BannersStore = require('./stores/bannersStore');

var routes = (
 <Route handler={ BannerManager }>
  <Route name="banner" path="/banner/:id" handler={ ViewBanner } />
  <Route name="add" path="/add" handler={ AddBanner } />
  <DefaultRoute name="home" handler={ Banners } />
 </Route>
);

var BannerManager = React.createClass({
 render: function() {
  return (
 <RouteHandler/>
  );
 }
});

Router.run(routes, function(Handler) {
 React.render(<Handler/>, document.getElementById('app'));
});
{% endhighlight %}
<p>The React component simply renders the <code><RouteHandler/></code> component that, in turn, renders the currently active child route for the application. The last section, <code>Router.run</code>, is somewhat magical. When the user selects a route, the <code>run</code> callback receives <code>Handler</code>, that has all of its appropriate information wrapped up in it. If our app would be managing some type of state, we could pass this state down the view hierarchy. For our use case, we simply use the standard boilerplate and render our application into the <code>app</code> div.</p>
<h3 id="bannerstorejs">BannerStore.js</h3>
<p>The heart of the application is the Reflux store which holds all of the model, business logic and interactions with the Force.com platform. <a href="https://github.com/jeffdonthemic/react-banners-salesforce/blob/master/src/scripts/stores/bannersStore.js">Here is the complete code.</a> The store holds a private <code>data</code> object which the users interact with through various calls from components (e.g., getBanners(), getBanner(id), etc.). The store loads this initial state as an empty array of banners.</p>
{% highlight js %}init: function() {

 var salesforce = new RemoteObjectModel.Banner();
 // fetch 5 record from the Banner__c custom object
 salesforce.retrieve({ limit: 5 }, function(err, records, event){
  if (err) console.log('Darn error: ' + err);
  if (!err) {
 records.forEach(function(record) {
  var banner = {
   "id": record.get("Id"),
   "name": record.get("Name"),
   "imageUrl": record.get("Image_URL__c"),
   "targetUrl": record.get("Target_URL__c"),
   "active": record.get("Active__c")
  }
  this.data.banners.push(banner);
 }.bind(this));
 // set scope
 this.trigger();
  }
 }.bind(this));

 // register addBanner action & bind to addBanner function
 this.listenTo(actions.addBanner, this.addBanner);
 // register toggleStatus action & bind to togggle function
 this.listenTo(actions.toggleStatus, this.toggle);
},
{% endhighlight %}
<p>In our <code>init</code> function we are using the <code>Banner</code> remote object to query the Banner__c custom object for up to 5 records. In the callback we create a banner object with simpler properties and push each one to the state's array of banners. Then we trigger the DOM update to display the records in the HTML table. We also register some actions (<code>toggleStatus</code> and <code>addBanner</code>) that the store listens for and binds them to individual function that handle the appropriate logic.</p>
{% highlight js %}// creates banner in sfdc & pushes it to the state of banners
addBanner: function(banner) {
 // construct the object for salesforce
 var details = {
  Name: banner.name,
  Image_URL__c: banner.imageUrl,
  Target_URL__c: banner.targetUrl,
  Active__c: 'Yes'
 }

 var sfdcBanner = new RemoteObjectModel.Banner();
 sfdcBanner.create(details, function(err) {
  if (err) console.log('Darn error: ' + err);
  if (!err) {
 banner.id = sfdcBanner.get('Id');
 this.data.banners.push(banner);
 this.trigger();
  }
 }.bind(this));
},
{% endhighlight %}
<p>The <code>addBanner</code> function is called whenever the store hears the <code>addBanner</code> action (i.e., the user submitted the add banner form). We use the remote object again and create a new record in the Banner__c custom object using the details from the banner object passed to the function. If the record was inserted correctly, it pushes the new banner object to the array of banners in the state and updates the DOM to display the new row in the HTML table. Magic!</p>
{% highlight js %}// callback for toggle action to update in sfdc
toggle: function(bannerId) {
 var banner = _.where(this.data.banners, { 'id': bannerId })[0];
 // toggle the banner status in the obect
 banner.active = banner.active === 'Yes' ? 'No' : 'Yes';
 // update the banner in sfdc
 var sfdcBanner = new RemoteObjectModel.Banner({
  Id: bannerId,
  Active__c: banner.active
 });
 sfdcBanner.update(function(err, ids) {
  if (err) console.log('Darn error: ' + err);
 });
 // pass the data on to any listeners -- see toggleStatus in view.js)
 this.trigger();
}
{% endhighlight %}
<p>The <code>toggle</code> function is called whenever the store hears a <code>toggleStatus</code> action. This function fetches the appropriate banner in the state array by its ID and then toggles its <code>active</code> property. The remote object is then used to update the record in the custom object. The trigger method passes the change notification to any listeners to update the DOM.</p>
<h3 id="actionsjs">Actions.js</h3>
<p>The action.js, since it uses Reflux, is much smaller and simpler than the standard <a href="http://facebook.github.io/flux/docs/dispatcher.html">Flux Dispatcher</a>. It simply defines the actions that our app will broadcast. Not much to see here. Simplicity is good!</p>
{% highlight js %}/** @jsx React.DOM */
var Reflux = require('reflux');

var actions = Reflux.createActions({
  'toggleStatus': {},
  'addBanner': {}
});

module.exports = actions;
{% endhighlight %}
<h3 id="bannersjs">Banners.js</h3>
<p>This view component is responsible for displaying our table of banner data. When initialized, the <code>getInitialState</code> method is called and loads the banner data from the store into the state. When the component renders, it first creates a variable of <code>rows</code> that is used to display the actual data in the table rows.</p>
{% highlight js %}/** @jsx React.DOM */
var React = require('react');
var Reflux = require('reflux');
var BannersStore = require('../stores/bannersStore');

var Link = require('react-router').Link;

function getBanners() {
 return { banners: BannersStore.getBanners() }
}

var Banners = React.createClass({

 // There appears to be a bug with trigger() when
 // used async. Use ListenerMixin to manually
 // listen for the store change. See
 // https://github.com/spoike/refluxjs/issues/226
 mixins: [Reflux.ListenerMixin],

 componentDidMount: function() {
  this.listenTo(BannersStore, this.refreshTable);
 },

 refreshTable: function() {
  this.setState({
  banners: BannersStore.getBanners()
  });
 },
 // end bug-related code

 getInitialState: function() {
  return getBanners();
 },

 render: function() {

  var rows = this.state.banners.map(function(banner, i) {
 return (
  <tr key={i}>
   <td><Link to="banner" params={{ id: banner.id }}>{banner.name}</Link></td>
   <td>{banner.imageUrl}</td>
   <td>{banner.targetUrl}</td>
   <td>{banner.active}</td>
  </tr>
 )
  });

  return (
 <div>
  <table className="table table-striped">
   <thead>
  <tr>
   <th>Name</th>
   <th>Image</th>
   <th>URL</th>
   <th>Active?</th>
  </tr>
   </thead>
   <tbody>
  { rows }
   </tbody>
  </table>
 </div>
  )
 }

});

module.exports = Banners;
{% endhighlight %}
<p>Note: there is a <a href="https://github.com/spoike/refluxjs/issues/226">slight bug</a> I ran across in the Reflux store when calling code asynchronously which seems to loose the reference to its state. It works fine when called synchronously, but doesn't render properly otherwise. The code I used ensures that the component listens to changes in the store and updates its state appropriately as a workaround.</p>
<h3 id="viewjs">View.js</h3>
<p>The view.js file is pretty interesting and has a lot going on. First, the class uses an array of mixins to add functionality to the component. When the component initially mounts, is uses Reflux's <code>ListenerMixin</code> to listen for changes in the BannerStore and act accordingly. The <code>getInitialState</code> method grabs the ID of the banner being viewed and calls the BannerStores' <code>getBanner</code> method and adds it to the state. When the component renders, it displays this state data on the page.</p>
{% highlight js %}/** @jsx React.DOM */
var React = require('react');
var Router = require('react-router');
var Reflux = require('reflux');
var BannersStore = require('../stores/bannersStore');
var actions = require('../actions/actions');

var Display = React.createClass({

 mixins: [
  Router.Navigation,
  Router.State,
  Reflux.ListenerMixin
 ],

 componentDidMount: function() {
  this.listenTo(BannersStore, this.toggleStatus);
 },

 getInitialState: function() {
  var bannerId = this.getParams().id;
  return {
 banner: BannersStore.getBanner(bannerId)
  }
 },

 toggleStatus: function() {
  this.setState({
  banner: BannersStore.getBanner(this.getParams().id)
  });
 },

 render: function() {
  return (
 <div>
  <dl className="dl-horizontal">
   <dt>Name</dt>
   <dd>{this.state.banner.name}</dd>
   <dt>Image</dt>
   <dd>{this.state.banner.imageUrl}</dd>
   <dt>Target URL</dt>
   <dd>{this.state.banner.targetUrl}</dd>
   <dt>Active?</dt>
   <dd>{this.state.banner.active}</dd>
  </dl>
  <div className="col-sm-offset-2">
   <button type="button" className="btn btn-primary" onClick={ actions.toggleStatus.bind(this, this.state.banner.id) }>Toggle Active</button>
  </div>
 </div>
  );
 }

});

module.exports = Display;
{% endhighlight %}
<p>There is also a 'Toggle Active' button that, when clicked, broadcasts <code>actions.toggleStatus</code> and passes the ID of the banner. The BannerStore is responsible for toggling the Yes/No status of the banner and then notifies any listeners that there has been a change. This view component listens for any change to the BannerStore and then calls <code>toggleStatus</code> to change the state and update the DOM.</p>
<h3 id="addjs">Add.js</h3>
<p>Our final component displays a form for entering a new banner. IMHO it takes more work that I think it should. I tried to implement a couple of libraries such as <a href="http://prometheusresearch.github.io/react-forms/">react-froms</a> and <a href="http://react-bootstrap.github.io/">react-bootstrap</a> but had much better luck rolling my own for this simple application.</p>
{% highlight js %}/** @jsx React.DOM */
var React = require('react');
var Router = require('react-router');
var _ = require('lodash');
var BannersStore = require('../stores/bannersStore');

var AddForm = React.createClass({

 mixins: [
  require('react-router').Navigation, // needed for transitionto
 ],

 getInitialState: function() {
  return {
 banner: {
  id: '',
  name: '',
  imageUrl: 'http://yet-anothergif.com',
  targetUrl: 'http://www.topcoder.com',
  active: 'Yes'
 },
 errors: {}
  }
 },

 renderTextInput: function(id, label, help) {
  return this.renderField(id, label, help,
 <input type="text" className="form-control" id={id} ref={id} key={id} value={this.state.banner[id]} onChange={this.handleChange.bind(this, id)}/>
  )
 },

 renderField: function(id, label, help, field) {
  return <div className={$c('form-group', {'has-error': id in this.state.errors})}>
 <label htmlFor={id} className="col-sm-2 control-label">{label}</label>
 <div className="col-sm-6">
  {field} <span className="help-block m-b-none">{help}</span>
 </div>
  </div>
 },

 // update the state when they type stuff a the text box
 handleChange: function(field, e) {
  var thisBanner = this.state.banner;
  thisBanner[field] = e.target.value;
  this.setState({banner: thisBanner});
 },

 handleSubmit: function(e) {
  e.preventDefault();
  var errors = {}
  var required = ['name', 'imageUrl', 'targetUrl'];
  // check for required fields
  required.forEach(function(field) {
 if (!this.state.banner[field]) {
  errors[field] = 'This field is required.'
 }
  }.bind(this));
  // update the state with any errors
  this.setState({errors: errors});
  // if no errors, emit action to add it
  if (_.keys(errors).length === 0) {
 BannersStore.addBanner(this.state.banner);
 // refresh the form and errors
 this.setState({
  banner: {},
  errors: {}
 });
 this.transitionTo('home');
  }
 },

 render: function() {

  return (
 <div>
  <div className="row">
   <div className="col-lg-8">
  <div className="ibox float-e-margins">
   <div className="ibox-content">

    <form onSubmit={ this.handleSubmit } className="form-horizontal">
   {this.renderTextInput('name', 'Name', '')}
   {this.renderTextInput('imageUrl', 'Image URL', '')}
   {this.renderTextInput('targetUrl', 'Target URL', 'The URL to the person is taken to when clicking.')}
   <div className="form-group">
     <div className="col-sm-4 col-sm-offset-2">
     <button className="btn btn-primary" type="submit">Add Banner</button>
     </div>
   </div>

    </form>
   </div>
  </div>
   </div>
  </div>
 </div>
  )

 }

});

module.exports = AddForm;

function $c(staticClassName, conditionalClassNames) {
 var classNames = []
 if (typeof conditionalClassNames == 'undefined') {
  conditionalClassNames = staticClassName
 }
 else {
  classNames.push(staticClassName)
 }
 for (var className in conditionalClassNames) {
  if (!!conditionalClassNames[className]) {
 classNames.push(className)
  }
 }
 return classNames.join(' ')
}
{% endhighlight %}
<p>When the component initializes, <code>getInitialState</code> sets up the state with default error and banner objects. The errors object be will used to notify the user that a field is required when submitting while the banner object will default in some data to the form fields.</p>
<p>When the component renders it calls <code>renderTextInput</code> for each of the three form fields. This adds the appropriate HTML to the DOM to make the field look pretty and sets up any error notifications when the form is submitted. The value of the form field is bound to the banner in the state and fires the <code>handleChange</code> event whenever the user changes the text (i.e., typing). The <code>handleChange</code> function updates the state which re-renders the DOM node for the form field.</p>
<p>When the user clicks the submit button, the form's <code>onSubmit</code> handler calls the <code>handleSubmit</code> function which check to make sure all fields are filled out. If a required field is blank, it adds this to the state's error object which display the field in a red box. If everything is filled out correctly, it calls the BannerStore's <code>addBanner</code> method with the new banner data, resets the component's state and display the home page which show the newly added banner in the table.</p>
<h2 id="conclusion">Conclusion</h2>
<p>So there you have it, a minimal SPA written in React and Reflux on Force.com that you can use as a starter for your own project!</p>
<div class="flex-video"><iframe width="640" height="360" src="https://www.youtube.com/embed/pJkxKnj_zzY" frameborder="0" allowfullscreen></iframe></div>

