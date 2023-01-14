---
layout: post
title:  AngularJS and Salesforce.com Tutorial
description: A couple of weeks ago I attend the Building Enterprise Apps Rapidly with Salesforce Mobile Packs  webinar with Pat Patterson and Raja Rao. While I think it was a good introduction to AngularJS in general it seemed to lack any specific Force.com integration (probably by design). So for anyone looking to get started with AngularJS and Force.com I put together a small demo application that creates, updates and displays Account records from a Salesforce.com org. Feel free to clone the repo for your 
date: 2013-06-10 12:00:06 +0300
image:  '/images/slugs/angularjs-and-salesforce-com-tutorial.jpg'
tags:   ["salesforce", "angularjs"]
---
<p>A couple of weeks ago I attend the <a href="http://wiki.developerforce.com/page/Webinar:_Building_Enterprise_Apps_Rapidly_with_Salesforce_Mobile_Packs_(2013-May)">Building Enterprise Apps Rapidly with Salesforce Mobile Packs</a> webinar with Pat Patterson and Raja Rao. While I think it was a good introduction to AngularJS in general it seemed to lack any specific Force.com integration (probably by design). So for anyone looking to get started with AngularJS and Force.com I put together a small demo application that creates, updates and displays Account records from a Salesforce.com org. Feel free to clone the repo for your own use, learn from the code or pick it apart to make it better.</p>
<p><a href="http://angularjs-salesforce.herokuapp.com/"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327713/angular-screenshot_wc8tsg.png" alt="" title="angular-screenshot" width="500" class="alignnone size-full wp-image-4807" /></a></p>
<p>I personally like to see an application in action before I dive into the code, so you can run the application yourself at <strong><a href="http://angularjs-salesforce.herokuapp.com">http://angularjs-salesforce.herokuapp.com</a></strong>. <a href="https://github.com/jeffdonthemic/angular-salesforce-demo">The code is hosted at github</a> for your forking pleasure but we'll walk through it in detail below.</p>
<p>The application is <em>technically</em> a Rails application but Ruby is only used for the CRUD operations with Salesforce.com. This eliminates the <a href="http://techblog.constantcontact.com/software-development/using-cors-for-cross-domain-ajax-requests/">CORS issues</a> with multiple domains. I used the awesome <a href="https://github.com/ejholmes/restforce">Restforce gem</a> and expose everything as JSON in the controller. Perhaps a better, pure JavaScript solution would have been to use Node for the backend with the equally as awesome <a href="https://github.com/kevinohara80/nforce">nforce package</a> but I'll leave that to another blog post. I started out using CoffeeScript but switched back to straight JavaScript as I think it is easier for most people to grok.</p>
<p>So let's jump into the application. <strong>The <a href="https://github.com/jeffdonthemic/angular-salesforce-demo">github repo</a> has the instruction for installing and running the application both locally and on Heroku.</strong> First get the application up and running and then continue reading below.</p>
<p>Let's start with the Rails portion of the application since it is fairly simple. The <strong>routes.rb</strong> file simply declares our RESTful accounts resource (for communicating with Force.com) and directs all requests to the index route in the applcation controller. This route will start our Angular app for us.</p>
{% highlight js %}AngularSalesforceDemo::Application.routes.draw do
 resources :accounts
 root to: 'application#index'
end
{% endhighlight %}
<p>We need to add some Angular directives to our <strong>application.html.erb</strong> to make the application work. First, on line 2 we add ng-app="app" to auto-bootstrap our application called (wait for it......) "app"! We also add ng-view to line 11 so that the view will change based upon the current route requested.</p>
{% highlight js %}<!DOCTYPE html>
<html lang="en" ng-app="app">
<head>
 <title>AngularJS Salesforce Demo</title>
 <%= stylesheet_link_tag  "application", :media => "all" %>
 <%= javascript_include_tag "application" %>
 <%= csrf_meta_tags %>
</head>
<body>
<div class="container">
 <div ng-view="ng-view"></div>
</div>
</body>
</html>
{% endhighlight %}
<p>Here is the <strong>ApplicationController</strong> that renders the single page for our application. We just need a place to launch from and this happens to be it. So we have no view (thus :nothing => true) but we still want the layout (since it has the app bootstrap code).</p>
{% highlight js %}class ApplicationController < ActionController::Base
 protect_from_forgery

 # We'll just use this as a launch point for our App
 def index
  # Render just the layout since this application is 
  # Angular driven our layout/application has all 
  # the angular logic and our controllers have no 
  # views for themselves. We just need a place to 
  # launch fromand this happens to be it. So we have 
  # no view (thus :nothing => true) but we 
  # still want the layout (since it has the 
  # App bootstrap code)
  render :layout => 'application', :nothing => true
 end
 
end
{% endhighlight %}
<p>Lastly is the workhorse of the application, the <strong>AccountsController</strong>. This controller performs all of the interaction with Force.com using the Restforce gem (the private 'client' method on line #43) and is designed to only return JSON data. The code is commented below but there are actions to query for account records (index), return a specific account by id (show), create a new account in Salesforce.com (create) and update an existing account in Salesforce.com (update).</p>
{% highlight js %}class AccountsController < ApplicationController
 respond_to :json

 def index
  # simply return the query as json
  respond_with client.query('select id, name, type, billingstate from account 
 order by lastmodifieddate desc limit 5')
 end

 def show
  # return the requested record as json
  respond_with client.query("select id, name, type, billingstate from account 
 where id = '#{params[:id]}'").first
 end	

 # create a new record in salesforce. Use the following command for testing:
 #  curl -v -H "Content-type: application/json" -X POST -d '{"name": "some test name"}' http://localhost:3000/accounts
 def create
  # create the account in salesforce and get the new id
  id = client.create!('Account', Name: params[:name], Type: 'Prospect', BillingState: 'NY')
  # query for the newly created account
  account = client.query("select id, name, type from account where id = '#{id}'").first
  # return the resource so it can be added to the collection
  respond_with(account, :status => :created, :location => account_url(account))
 end		

 def update
  # update only two of the fields in salesforce and return the record
  client.update!('Account', Id: params[:account][:Id], Name: params[:account][:Name], 
 Type: params[:account][:Type])
  respond_with client.query("select id, name, type, billingstate from account 
 where id ='#{params[:account][:Id]}'")
 end		

 private

  # define the restforce client and authenticate
  def client
 client = Restforce.new :username => ENV['SFDC_USERNAME'],
  :password  => ENV['SFDC_PASSWORD'],
  :client_id => ENV['SFDC_CLIENT_ID'],
  :client_secret => ENV['SFDC_CLIENT_SECRET'],
  :host  => ENV['SFDC_HOST']
 client.authenticate!
 client
  end

end
{% endhighlight %}
<p>Now the fun stuff... AngularJS! This isn't a "how to learn AngularJS" post so be sure to check out <a href="http://egghead.io">egghead.io</a> and the <a href="http://docs.angularjs.org/tutorial">AngularJS tutorial</a> to really dig into the framework. There are four main parts of the app under the <a href="https://github.com/jeffdonthemic/angular-salesforce-demo/tree/master/app/assets/javascripts/angular">app/assets/javascripts/angular directory</a></p>
<p>The <strong>app.js</strong> file is the launcher for our entire application and defines our module called "app". It contains our routing information which tells Angular which controller and view template to load based upon the route being requested (home page with the list of accounts or account details page). We also inject the ngResource dependency so that our application can take advantage of our RESTful resources in our rails controller.</p>
{% highlight js %}'use strict';
/*
  This is our main launch point from Angular. 
  We'll put anything to do with the
  general well being of our app in this file. 
  For now it'll basically just contain
  the routing information.

  Our module will be called 'app'.
 */
angular.module('app', ['ngResource'])
 .config(['$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
  $routeProvider
 .when('/', {
  controller: 'AccountListCtrl', 
  templateUrl: '/assets/angular/templates/index.html'
 })
 .when('/accounts/:id', {
  controller: 'AccountDetailCtrl', 
  templateUrl: '/assets/angular/templates/details.html'
 })
 .otherwise({redirectTo: '/'});
}]);
{% endhighlight %}
<p>The services directory has a single <strong>models.js</strong> file which defines our Account resource to communicate with Force.com via the RESTful routes. We pass in the URL to the resource, "/accounts", and an optional :id parameter. Angular will use the id parameter if present and call the show action in the controller, otherwise it will call the index route to return all accounts. Since, by default, the <a href="http://docs.angularjs.org/api/ngResource.$resource">Angular $resource</a> does not support an update method, we need to declare an additional action (i.e., update) that we can call on the Account resource.</p>
{% highlight js %}'use strict';

var app = angular.module('app');

app.factory('Account', ['$resource', function($resource) {
  return $resource('/accounts/:id', {id: '@id'}, {update: {method: "PUT"}});
}]);
{% endhighlight %}
<p>Since controllers and views work hand-in-hand, let take a look at them together as part of the route.</p>
<p><strong>Home Page</strong></p>
<p>When the user visits the root page in our application (i.e., "/"), Angular loads the <strong>AccountListCtrl</strong> controller and the index.html view template. In line #5 we inject the Account resource into our controller so that our RESTful routes are available. Line #6 defines a scope variable called "accounts" which contains an array of Accounts by returning '/accounts.json' via Account.query().</p>
<p>We also define an "add" function that is used when the user submits the form to create a new Account. This function creates a new Account resource, calls $save on the resource (POSTs the data to our create action in our controller to insert it into Salesforce.com), adds the new Account resource to the array of all "accounts" and then clears out the form for reuse.</p>
{% highlight js %}'use strict';

var app = angular.module('app');

app.controller('AccountListCtrl', function($scope, Account) {
 $scope.accounts = Account.query();

 $scope.add = function() {
  var account = new Account({name:$scope.newAccount.name});
  account.$save(function() {
 $scope.accounts.push(account)
 $scope.newAccount = {}
  });
 } 
});
{% endhighlight %}
<p>In the <strong>index.html</strong> template, the ng-controller directive declares the controller to be used for the section of code (you can use multiple controllers in the same template). We first have a form that allows the user to add a new Account. The ng-submit directive defines the function in the controller to execute when the form is submitted. The ng-model directive tells Angular to do two-way data binding with our newAccount object so that it can easily be used in our controller.</p>
<p>Next we simply output our five Accounts from Salesforce.com using the ng-repeat directive.</p>
{% highlight js %}<h1>AngularJS Demo with Salesforce.com</h1>

<span class="lead" style="padding-bottom:10px">By Jeff Douglas (<a href="http://www.twitter.com/jeffdonthemic" target="_blank">@jeffdonthemic</a>). You can find the accompanying blog post at <a href="http://blog.jeffdouglas.com/?p=4800" target="_blank">blog.jeffdouglas.com</a>. This demo connects to Salesforce.com using Ruby on Rails. The application allows you to create, update and display Account records from Salesforce.com.</span>

<div ng-controller="AccountListCtrl">

 <h2>Create a New Account</h2>
 <form name="frm" ng-submit="add()">
  <input type="text" class="input-xlarge" ng-model="newAccount.name" required><br/>
  <button type="Submit" class="btn btn-primary">Add Account</button>
 </form><br/>

 <h2>Last 5 Modified Accounts</h2>

 <table class="table table-striped">
 <thead>
  <tr>
 <th>Account Name</th>
 <th>Type</th>
 <th>State</th>
  </tr>
 </thead>
 <tbody>
  <tr ng-repeat="account in accounts">
 <td><a href="#/accounts/{{account.Id}}">{{account.Name}}</a></td>
 <td>{{account.Type}}</td>
 <td>{{account.BillingState}}</td>
  </tr>
 </tbody>
 </table>

</div>
{% endhighlight %}
<p><strong>Account Details & Edit Page</strong></p>
<p>The final part of our application is the account details page. The <strong>AccountDetailCtrl</strong> controller is loaded and the details.html template is displayed when the details route (/accounts/:id) is requested. This page has a little more going on as it not only displays the details of the page but also provides the functionality for updating the Account in Salesforce.com.</p>
<p>Once again, we inject the Account resource into the controller and fetch the Account from Salesforce.com with "/accounts/:id.json" via Account.get(). We also set the $scope variable mode to 'display' so that the page initially displays the details of the Account instead of the edit form. The update function at the bottom PUTS our data to "/accounts/:id.json" via Account.update() to update the Account in Salesforce.com.</p>
{% highlight js %}'use strict';

var app = angular.module('app');

app.controller('AccountDetailCtrl', function($scope, $routeParams, Account) {

 $scope.account = Account.get({id:$routeParams.id});
 $scope.mode = 'display';

 $scope.edit = function() {
  $scope.mode = 'edit'; 
 }

 $scope.cancel = function() {
  $scope.mode = 'display'; 
 } 

 $scope.update = function() {
  $scope.mode = 'display'; 
  Account.update({id:$routeParams.id}, $scope.account, function() {
 // performs some operation when the callback completes like error checking
 console.log('Callback completed!');
  });

 }  

});
{% endhighlight %}
<p>The <strong>details.html</strong> template has two sections; one for displaying the Account and a form for updating the account. These sections display based upon the value of 'mode' in the ng-show directive. The update form uses the ng-model directive to display the values of the model attributes. The two-way binding updates the model immediately. For example, each change you make to the Account name in the text field will immediately update the Account name at the top of the page as they are both bound to the same model.</p>
{% highlight js %}<a class="btn" href="/#" style="margin-top:15px;margin-bottom:15px"><i class="icon-home"></i> Back</a>

<div ng-controller="AccountDetailCtrl">

<h1>{{account.Name}}</h1>

<span ng-show="mode == 'display'">

 <table class="table" style="width:50%">
  <tbody>
  <tr>
 <td width="20%">Type:</td>
 <td>{{account.Type}}</td>
  </tr>
  <tr>
 <td>State:</td>
 <td>{{account.BillingState}}</td>
  </tr>  
  <tr>
 <td></td>
 <td></td>
  </tr> 
  </tbody>
 </table>

 <button type="button" class="btn btn-primary" ng-click="edit(account)">Edit Account</button>
</span>

<span ng-show="mode == 'edit'">

 <form name="editForm" ng-submit="update()">
  <fieldset>
  <legend>Edit Account</legend>

  <label>Account name</label>
  <input type="text" ng-model="account.Name" required><br/>

  <label>Type</label>
  <input type="text" ng-model="account.Type" required><br/>

  <button type="submit" class="btn btn-primary">Submit</button> 
  <button type="button" class="btn" ng-click="cancel()">Cancel</button>

  </fieldset>
 </form>

</span>

</div>
{% endhighlight %}
<p>So there you have a nice little AngularJS application that you can reference for your next project! Enjoy!</p>

