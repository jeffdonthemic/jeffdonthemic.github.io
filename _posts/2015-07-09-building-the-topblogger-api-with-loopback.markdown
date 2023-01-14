---
layout: post
title:  Building the TopBlogger API with LoopBack
description: Last week I published an article  outling how I rewrote an existing Express API using Loopback, resulting in 75% less code. I described how we initially utilized the topcoder community to design and build the API and the benefits of LoopBack versus simply using Express  and  Mongoose . In this post, Ill walk through the process of building the TopBlogger API with LoopBack and where it saved time and made code obselete. > Ill trying cover the application from the ground up, but you might want to 
date: 2015-07-09 20:42:55 +0300
image:  '/images/building-with-loopback.jpg'
tags:   []
---
<p><a href="/2015/07/07/roll-your-own-api-vs-loopback/">Last week I published an article</a> outling how I <strong>rewrote an existing Express API using Loopback, resulting in 75% less code</strong>. I described how we initially utilized the topcoder community to design and build the API and the benefits of LoopBack versus simply using <a href="http://expressjs.com/">Express</a> and <a href="http://mongoosejs.com/">Mongoose</a>. In this post, I'll walk through the process of building the "TopBlogger" API with LoopBack and where it saved time and made code obselete.</p>
<blockquote>
<p>I'll trying cover the application from the ground up, but you might want to <a href="/2015/07/07/roll-your-own-api-vs-loopback/">peek at the previous post</a> for the complete details. You can find all of the code referenced in this article <a href="https://github.com/topcoderinc/TopBlogger-Loopback">at this repo</a>.</p>
</blockquote>
<h2 id="requirements">Requirements</h2>
<p>The TopBlogger application has two models: Blog and Comment. We'll be using the LoopBack provided User object for authentication and authorization but you can extend this if you'd like more functionality. It works just fine out of the box for what we need. The models have the following relations:</p>
<ul>
<li>A blog belongs to a user</li>
<li>A blog can have many comments</li>
<li>A comment belongs to a user</li>
</ul>
<p>The functional requirements for the blogging API are fairly straight forward. When blogging, everyone can typically view blogs and comments but any meaningful interaction requires authentication. Once logged in users can create new blogs, edit blogs that they authored, delete an unpublished blog that they authored, up or down-vote blogs not authored by themselves, comment on blogs and like or dislike comments not authored by themselves. No one is allowed to delete comments. That would just be crazy.</p>
<p>Given that people want to find and read blog entries, a fair amount of work is needed for discovery. We need endpoints for keyword search, newest blogs, trending blogs, most popular blogs and blogs by author and tags. All of this of course with pagination. We also want permalinks so that people can access a blog by the author username and slug (e.g., <a href="http://topblogger.com/jeffdonthemic/hello-world">http://topblogger.com/jeffdonthemic/hello-world</a>).</p>
<h2 id="scaffoldtheapplication">Scaffold the Application</h2>
<p>The first thing we need to do is install the LoopBack CLI. Run <code>npm install -g strongloop</code>, then get up and grab a cup of coffee, watch some cat videos or take a run. The install takes a while.</p>
<p>Now we are ready to create a new application. Run <code>slc loopback</code> to start the generator and enter <code>topblogger</code> for the name of the application and directory. This will scaffold the API and run npm install. To smoke test just change to the new directory and run <code>node .</code> You should see the running application at <a href="http://localhost:3000">http://localhost:3000</a>!</p>
<h2 id="addmongodbdatabase">Add MongoDB Database</h2>
<p>LoopBack offers a number of data providers, in memory being the simpliest, but we're going to be using MongoDB. We can use the <a href="http://docs.strongloop.com/display/public/LB/Data+source+generator">Data source generator</a> to set this up for us.</p>
{% highlight js %}npm install loopback-connector-mongodb --save
slc loopback:datasource
{% endhighlight %}
<p>Enter <code>topblogger</code> as the name and choose the MongoDB connector. Next we'll need to add our connection parameters. Assuming you are running MongoDB locally, edit your <code>server/datasources.json</code> file so that it looks something like:</p>
{% highlight js %}{
 "db":{
  "name":"db",
  "connector":"memory"
 },
 "topblogger":{
  "host":"localhost",
  "port":27017,
  "database":"topblogger",
  "username":"",
  "password":"",
  "name":"topblogger",
  "connector":"mongodb"
 }
}
{% endhighlight %}
<h2 id="definingmodels">Defining Models</h2>
<p>Models are at the heart of LoopBack. When you connect a model to a persistent data source, LoopBack implements all of the CRUD operations needed to interact with the database and exposes the REST endpoints automatically. No need to write handlers for each endpoint! We can then add application logic to models, boot scripts or middleware to round out our functionality!</p>
<p>Use the LoopBack model generator to build the Blog and Comment models below.</p>
{% highlight js %}slc loopback:model
? Enter the model name: Blog
? Select the data-source to attach Blog to: topblogger (mongodb)
? Select model's base class: PersistedModel
? Expose Blog via the REST API? Yes
? Custom plural form (used to build REST URL): blogs
{% endhighlight %}
<p>Follow the prompts to create the properties below. Create the Comment model the same way along with its properties. It's not rocket surgery.</p>
<h3 id="blog">Blog</h3>
<ul>
<li>title (string)</li>
<li>content (string)</li>
<li>tags (array of strings)</li>
<li>slug (string)</li>
<li>numberOfUpVotes (number)</li>
<li>numberOfDownVotes (number)</li>
<li>numberOfViews (number)</li>
<li>upvotes (array of strings)</li>
<li>downvotes (array of strings)</li>
<li>isPublished (boolean)</li>
<li>createdDate (date)</li>
<li>lastUpdatedDate (date)</li>
</ul>
<h3 id="comment">Comment</h3>
<ul>
<li>content (string)</li>
<li>numOfLikes (number)</li>
<li>numOfDislikes (number)</li>
<li>likes (array of strings)</li>
<li>dislikes (array of strings)</li>
<li>createdDate (date)</li>
<li>lastUpdatedDate (date)</li>
</ul>
<h2 id="createtherelations">Create the Relations</h2>
<p>One of the great things about Rails is the functionality to easily implement and use relations between models. LoopBack offers similar functionality. The framework offers BelongsTo, HasMany, HasManyThrough, HasAndBelongsToMany, Polymorphic and Embedded relations that allow you to connect, query, expose endpoints and perform all sorts of nifty functional with models.</p>
<p>Since users write blogs, create a BelongsTo relation to User to define the "author" of each Blog.</p>
{% highlight js %}[topblogger]$ slc loopback:relation
? Select the model to create the relationship from: Blog
? Relation type: belongs to
? Choose a model to create a relationship with: User
? Enter the property name for the relation: author
? Optionally enter a custom foreign key:
{% endhighlight %}
<p>Readers love commenting on blogs so we need to allow a blog to have many comments. Create a HasMany relation so that we can associate an array of Comments to a Blog.</p>
{% highlight js %}[topblogger]$ slc loopback:relation
? Select the model to create the relationship from: Blog
? Relation type: has many
? Choose a model to create a relationship with: Comment
? Enter the property name for the relation: comments
? Optionally enter a custom foreign key:
? Require a through model? No
{% endhighlight %}
<p>And lastly we'll need to create the same type of author relation for Comments that we did for the Blog above. Every comment must be authored by a user.</p>
{% highlight js %}[topblogger]$ slc loopback:relation
? Select the model to create the relationship from: Comment
? Relation type: belongs to
? Choose a model to create a relationship with: User
? Enter the property name for the relation: author
? Optionally enter a custom foreign key:
{% endhighlight %}
<h2 id="implementingaccesscontrol">Implementing Access Control</h2>
<p>One of the most powerful features of LoopBack is access control. LoopBack applications access data through models, so controlling access to data means putting restrictions on models. LoopBack access controls are determined by access control lists or ACLs which specify who or what can read or write data and execute methods.  Our application only consists of the two following types of users:</p>
<h3 id="unauthenticated">Unauthenticated</h3>
<p>Unauthenticated users can only view blogs and comments.</p>
<h3 id="authenticated">Authenticated</h3>
<p>LoopBack provides all sorts of user related functionality for us like signup, login, logout, forgot password and much more. We'll gladly use this! Once logged in, users have the same functionality as unauthenticated user plus the ability to:</p>
<ul>
<li>Create a new blog</li>
<li>Edit blogs where they are the author</li>
<li>Publish a blog where they are the author</li>
<li>Upvote a blog where they are not the author</li>
<li>Downvote a blog where they are not the author</li>
<li>Create a comment for a blog</li>
<li>Edit a comment where they are the author</li>
<li>Like a comment where they are not the author</li>
<li>Unlike a comment where they are not the author</li>
</ul>
<p>We start by <strong>denying access to all endpoints to everyone</strong> for Blogs and Comments. Then we'll go through and authorize select endpoints where appropriate.</p>
{% highlight js %}[topblogger]$ slc loopback:acl
? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: All methods and properties
? Select the access type: All (match all types)
? Select the role: All users
? Select the permission to apply: Explicitly deny access

[topblogger]$ slc loopback:acl
? Select the model to apply the ACL entry to: Comment
? Select the ACL scope: All methods and properties
? Select the access type: All (match all types)
? Select the role: All users
? Select the permission to apply: Explicitly deny access
{% endhighlight %}
<p>Allow everyone read access to Blogs and Comments.</p>
{% highlight js %}? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: All methods and properties
? Select the access type: Read
? Select the role: All users
? Select the permission to apply: Explicitly grant access

? Select the model to apply the ACL entry to: Comment
? Select the ACL scope: All methods and properties
? Select the access type: Read
? Select the role: All users
? Select the permission to apply: Explicitly grant access
{% endhighlight %}
<p>Only authenticated users can create new Blog records.</p>
{% highlight js %}? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: All methods and properties
? Select the access type: Write
? Select the role: Any authenticated user
? Select the permission to apply: Explicitly grant access
{% endhighlight %}
<p>Make sure that only a Blog's author can edit and publish it. The <code>publish</code> method is a custom remote method that we'll add to the Blog model later.</p>
{% highlight js %}? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: All methods and properties
? Select the access type: Write
? Select the role: The user owning the object
? Select the permission to apply: Explicitly grant access

? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: A single method
? Enter the method name: publish
? Select the role: The user owning the object
? Select the permission to apply: Explicitly grant access
{% endhighlight %}
<p>We'll define <code>upvote</code> and <code>downvote</code> remote methods later but we'll add the security now by first blocking all access to the endpoints and then letting any authenticated user have access to them. We also have a requirement that users cannot upvote/downvote their own Blog but we'll handle that outside of the ACL in code.</p>
{% highlight js %}? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: A single method
? Enter the method name: upvote
? Select the role: All users
? Select the permission to apply: Explicitly deny access

? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: A single method
? Enter the method name: upvote
? Select the role: Any authenticated user
? Select the permission to apply: Explicitly grant access

? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: A single method
? Enter the method name: downvote
? Select the role: All users
? Select the permission to apply: Explicitly deny access

? Select the model to apply the ACL entry to: Blog
? Select the ACL scope: A single method
? Enter the method name: downvote
? Select the role: Any authenticated user
? Select the permission to apply: Explicitly grant access
{% endhighlight %}
<p>And finally, we'll specify that only authenticated users can create and edit Comments.</p>
{% highlight js %}? Select the model to apply the ACL entry to: Comment
? Select the ACL scope: All methods and properties
? Select the access type: Write
? Select the role: Any authenticated user
? Select the permission to apply: Explicitly grant access
{% endhighlight %}
<p>Now that were done, take a peek at Blog and Comment JSON files in <code>common/models</code> to see how LoopBack generated the ACL section.</p>
<h2 id="addingcustomremotemethods">Adding Custom Remote Methods</h2>
<p>LoopBack exposes models endpoints automatically but at some point you'll want provide additional functionalty besides just CRUDing records. LoopBack makes this extremely simple with <a href="http://docs.strongloop.com/display/public/LB/Remote+methods">remote methods</a>. For the Blog model we need to expose <code>/blogs/:id/publish</code>, <code>/blogs/:id/upvote</code> and <code>/blogs/:id/downvote</code> endpoints. I'll just touch on the important pieces so be sure to <a href="https://github.com/topcoderinc/TopBlogger-Loopback/blob/master/common/models/blog.js">check out the /common/models/blog.js file</a> for all of the code.</p>
<p>We start off the remote method by register a PUT method called <code>publish</code> that accepts the blog's ID in the query string and returns the updated blog object. This code also sets up the method in the Swagger Explorer for easy testing. The <code>Blog.publish</code> function handles the actual request for the endpoint. It simply finds the blog record in MongoDB, sets a few properties and commits it. The security for the endpoint was setup earlier in the ACL.</p>
{% highlight js %}// Register a 'publish' remote method: /blogs/:id/publish
Blog.remoteMethod(
 'publish',
 {
  http: {path: '/:id/publish', verb: 'put'},
  accepts: {arg: 'id', type: 'string', required: true, http: { source: 'path' }},
  returns: {root: true, type: 'object'},
  description: 'Marks a blog as published.'
 }
);

// the actual function called by the route to do the work
Blog.publish = function(id, cb) {
 Blog.findById(id, function(err, record){
  record.updateAttributes({isPublished: true, publishedDate: new Date()}, function(err, instance) {
 if (err) cb(err);
 if (!err) cb(null, instance);
  })
 })
};
{% endhighlight %}
<p>The <code>upvote</code> remote method is similar but has a little more substance to it. This time we register a POST method that, again, accepts the blog's ID in the query string and returns a the updated blog object. However, we added a <a href="http://docs.strongloop.com/display/public/LB/Remote+hooks">remote hook</a> that runs before the remote method is called. If the caller is either the author of the blog or has already upvoted the blog, then it returns a 403 error. Else it executes the remote method to increment the number of upvotes and adds the caller to the array of users that upvoted the blog.</p>
{% highlight js %}Blog.remoteMethod(
 'upvote',
 {
  http: {path: '/:id/upvote', verb: 'post'},
  accepts: {arg: 'id', type: 'string', required: true, http: { source: 'path' }},
  returns: {root: true, type: 'object'},
  description: 'Marks a blog as upvoted.'
 }
);

// Remote hook called before running function
Blog.beforeRemote('upvote', function(ctx, user, next) {
 Blog.findById(ctx.req.params.id, function(err, record){
  // do not let the user upvote their own record
  if (record.authorId === ctx.req.accessToken.userId) {
 var err = new Error("User cannot upvote their own blog post.");
 err.status = 403;
 next(err);
  // do no let the user upvote a comment more than once
  } else if (record.upvotes.indexOf(ctx.req.accessToken.userId) != -1) {
 var err = new Error("User has already upvoted the blog.");
 err.status = 403;
 next(err);
  } else {
 next();
  }
 })
});

// the actual function called by the route to do the work
Blog.upvote = function(id, cb) {
 // get the current context
 var ctx = loopback.getCurrentContext();
 Blog.findById(id, function(err, record){
  // get the calling user who 'upvoted' it from the context
  record.upvotes.push(ctx.active.accessToken.userId);
  record.updateAttributes({numOfUpVotes: record.upvotes.length, upvotes: record.upvotes}, function(err, instance) {
 if (err) cb(err);
 if (!err) cb(null, instance);
  })
 })
};
{% endhighlight %}
<h2 id="removingfunctionality">Removing Functionality</h2>
<p>With LoopBack its super simply to hide methods and endpoints. Since we don't want anyone to be able to delete comments, we simply add the following to the <a href="https://github.com/topcoderinc/TopBlogger-Loopback/blob/master/common/models/comment.js#L6">Comment model</a>:</p>
{% highlight js %}Comment.disableRemoteMethod('deleteById', true);
{% endhighlight %}
<h2 id="addingcustomexpressroutes">Adding Custom Express Routes</h2>
<p>Our last requirement is enable permalinks so that people can access a blog by the author's username and slug (e.g., <a href="http://topblogger.com/jeffdonthemic/hello-world">http://topblogger.com/jeffdonthemic/hello-world</a>) instead of by Blog ID. However, since the endpoint is not directly tied to a model we'll need to use a <a href="http://docs.strongloop.com/display/public/LB/Add+a+custom+Express+route">boot script</a> to add our new custom route.</p>
<p>The <a href="https://github.com/topcoderinc/TopBlogger-Loopback/blob/master/server/boot/routes.js">/server/boot/routes.js</a> file holds all of the custom routes (all one of them) and is loaded when the applications starts. Looking very similar to an Express route (because it is), this GET method uses the user and slug values from the query string, finds the record and its associated comments in MongoDB and returns it the same way it would if fetched by Blog ID.</p>
{% highlight js %} app.get('/:user/:slug', function(req, res) {
  Blog.findOne({ where: {authorId: req.params.user, slug:req.params.slug}, include: 'comments'}, function(err, record){
 if (err) res.send(err);
 if (!err && record) {
  res.send(record);
 } else {
  res.send(404);
 }
  });
 });
{% endhighlight %}
<h2 id="codecomparison">Code Comparison</h2>
<p>So just exactly where did LoopBack save us time? Well, for instance, the LoopBack <a href="https://github.com/topcoderinc/TopBlogger-Loopback/blob/master/common/models/blog.js">blog model code</a> looks much more succinct and pleasing to the eye than the <a href="https://github.com/topcoderinc/TopBlogger/blob/master/api/controller/blog.js">original blog model code</a>. The original code handles CRUD functional and is explicitly checking for access and returning status codes (400, 401, 403, 404, etc.) that LoopBack handles. <strong>My custom code decreased from 1,272 lines to 314 lines!</strong> Wow!</p>
<p>Testing was <em>much</em> simplier with LoopBack. <strong>Our mocha tests went from 1,599 lines to 380 lines.</strong> This substantial reduction in test code will make life much easier in the future for enhancements and debugging! Based upon my requirements, I simply set up my tests for both <a href="https://github.com/topcoderinc/TopBlogger-Loopback/blob/master/test/unauthenticated.js">unauthenticated</a> and <a href="https://github.com/topcoderinc/TopBlogger-Loopback/blob/master/test/authenticated.js">authenticated</a> users.</p>
<ul>
<li>The original <a href="https://github.com/topcoderinc/TopBlogger/blob/master/api/test/auth.js">authorization test code</a> was no longer needed. LoopBack provides this out of the box.</li>
<li>The original <a href="https://github.com/topcoderinc/TopBlogger/blob/master/api/test/getBlogs.js">discovery test code</a> to find blog was no longer needed. LoopBack has elegant support for finding data; related or not!</li>
<li>Most of the <a href="https://github.com/topcoderinc/TopBlogger/blob/master/api/test/blog.js">blog and comment model test code</a> was no longer needed.</li>
</ul>
<h2 id="conclusion">Conclusion</h2>
<p>LoopBack is great for building APIs and it's a huge productivity gain. However, coupled with the other services StrongLoop offers, it's an impressive suite of tools with which to build applications.</p>

