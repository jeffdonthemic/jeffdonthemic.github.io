---
layout: post
title:  Demo App - Ruby, Rails & Force.com REST API on Heroku
description: So continuing with my learning Ruby series , I finally finished my sample app using the Force.com REST API. I ran into a few issues and fortunately Quinton Wall  and Heroku support came to my rescue. Apparently require Accounts and require accounts arent the same when running on Heroku. Go figure. This is a demo Rails app running on Ruby 1.9.2 and Rails 3.0.5 hosted on Heroku. It uses OAuth2 via OmniAuth  to authorize access to a salesforce.com org. It uses the Force.com REST API to query for re
date: 2011-05-31 16:30:30 +0300
image:  '/images/slugs/telesales-rails-heroku.jpg'
tags:   ["2011", "public"]
---
<p>So continuing with my <a href="/category/ruby/">learning Ruby series</a>, I finally finished my sample app using the Force.com REST API. I ran into a <a href="http://boards.developerforce.com/t5/Perl-PHP-Python-Ruby-Development/Heroku-Crash-No-such-file-to-load-Accounts/td-p/275949">few issues</a> and fortunately <a href="http://twitter.com/quintonwall">Quinton Wall</a> and Heroku support came to my rescue. Apparently <em>require 'Accounts'</em> and <em>require 'accounts'</em> aren't the same when running on Heroku. Go figure.</p>
<p>This is a demo Rails app running on Ruby 1.9.2 and Rails 3.0.5 hosted on Heroku. It uses OAuth2 via <a href="https://github.com/intridea/omniauth">OmniAuth</a> to authorize access to a salesforce.com org. It uses the <a href="http://wiki.developerforce.com/index.php/Getting_Started_with_the_Force.com_REST_API">Force.com REST API</a> to query for records, retreive records to display, create new records and update existing ones. It should be good sample app to get noobs (like me) up and running.</p>
<p>I forked Quinton Wall's (excellent) <a href="https://github.com/quintonwall/omniauth-rails3-forcedotcom/wiki/Build-Mobile-Apps-in-the-Cloud-with-Omniauth,-Httparty-and-Force.com">omniauth-rails3-forcedotcom project</a> to get started. One of the things you have to do when using the Force.com REST API is to configure your server to run under SSL using WEBrick. I found some excellent instruction for OS X <a href="http://www.nearinfinity.com/blogs/chris_rohr/configuring_webrick_to_use_ssl.html">here</a>.</p>
<p><a href="https://telesales-rails.heroku.com/">You can run the app for yourself here.</a></p>
<p>All of the <a href="https://github.com/jeffdonthemic/Telesales-Rails">code for this app is hosted at github</a> so feel free to fork it.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/fRAaodh9jxQ?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p><strong>app/controllers/accounts_controller.rb</strong></p>
<p>The account controller delegates authority to accounts.rb for integration with Force.com and then packages up the returns for the views.</p>
{% highlight js %}require 'accounts'

class AccountsController < ApplicationController
 def index
 end

 def search
  @json = Accounts.search(params[:accountName])
 end

 def show
  @account = Accounts.retrieve(params[:id])
  @opportunities = Accounts.opportunities(params[:id])  
 end

 def create
 @account = Accounts.create
 end

 def edit
 @account = Accounts.retrieve(params[:id])
 end

 def save
  Accounts.save(params)
  redirect_to :action => :show, :id => params[:id]
 end 

 def new_opp 
  @account = Accounts.retrieve(params[:id])
 end

 def save_opp
  Accounts.create_opp(params)
  redirect_to :action => :show, :id => params[:id]
 end

end
{% endhighlight %}
<p><strong>lib/accounts.rb</strong></p>
<p>Accounts.rb does most of the heavy lifting for the app. It prepares the requests to Force.com with the correct headers and makes the actual calls to Force.com with the REST API.</p>
{% highlight js %}require 'rubygems'
require 'httparty'

class Accounts
 include HTTParty
 #doesn't seem to pick up env variable correctly if I set it here
 #headers 'Authorization' => "OAuth #{ENV['sfdc_token']}"
 format :json
 # debug_output $stderr

 def self.set_headers
  headers 'Authorization' => "OAuth #{ENV['sfdc_token']}"
 end

 def self.root_url
  @root_url = ENV['sfdc_instance_url']+"/services/data/v"+ENV['sfdc_api_version']
 end

 def self.search(keyword)
  Accounts.set_headers
  soql = "SELECT Id, Name, BillingCity, BillingState, Phone from Account Where Name = '#{keyword}'"
  get(Accounts.root_url+"/query/?q=#{CGI::escape(soql)}")
 end

 def self.create()
  Accounts.set_headers
  headers 'Content-Type' => "application/json"

  options = {
 :body => {
   :Name => "1234"
 }.to_json
  }
  response = post(Accounts.root_url+"/sobjects/Account/", options)
  # puts response.body, response.code, response.message
 end

 def self.save(params)
  Accounts.set_headers
  headers 'Content-Type' => "application/json"

  options = {
 :body => {
   :billingcity => params[:BillingCity]
 }.to_json
  }
  p options
  response = post(Accounts.root_url+"/sobjects/Account/#{params[:id]}?_HttpMethod=PATCH", options)
  # 201 response.body equals success
  # puts response.body, response.code, response.message
 end

 def self.retrieve(id)
  Accounts.set_headers
  get(Accounts.root_url+"/sobjects/Account/#{id}?fields=Id,Name,BillingCity,BillingState,Phone,Website") 
 end

 def self.opportunities(accountId)
  Accounts.set_headers
  soql = "SELECT Id, Name, Amount, StageName, Probability, CloseDate from Opportunity where AccountId = '#{accountId}'"
  get(Accounts.root_url+"/query/?q=#{CGI::escape(soql)}")
 end

 def self.create_opp(params)
  Accounts.set_headers
  headers 'Content-Type' => "application/json"

  options = {
 :body => {
   :name => params[:name],
   :amount => params[:amount],
   :accountId => params[:id],
   :amount => params[:amount],
   :closeDate => params[:closeDate],
   :stageName => params[:stageName]
 }.to_json
  }
  response = post(Accounts.root_url+"/sobjects/Opportunity/", options)
  # 201 response.body equals success
  # puts response.body, response.code, response.message
 end

end
{% endhighlight %}
<p><strong>app/views/search.html.erb</strong></p>
<p>The search view allows the user to search for an account and display the results.</p>
{% highlight js %}<span class="title">Welcome to the ACME Telesales Application (RoR on Heroku)</span>

<p>This demo shows you how to query, retrieve, create and edit records in salesforce.com.

Search for an Account to view all of its Opportunities or to create a new one.

<p/>
<form method="post" action="search">
 <span class="heading">Search by Account Name:</span><p/>
 <input type="text" name="accountName" value="<%= params[:accountName] %>" style="width: 300px"/>
 <input type="submit" value="Search"/>
</form>
<p/>

<span class="heading"><%= @json["records"].length %> accounts matching your search criteria:</span>

<p/>
<table border="0" cellspacing="1" cellpadding="5" bgcolor="#CCCCCC" width="50%">
<tr bgcolor="#407BA8">
 <td style="color: #ffffff; font-weight: bold;">Name</td>
 <td style="color: #ffffff; font-weight: bold;">City</td>
 <td style="color: #ffffff; font-weight: bold;">State</td>
 <td style="color: #ffffff; font-weight: bold;">Phone</td>
</tr>
<% @json["records"].each do |record| %>
 <tr style="background:#ffffff" onMouseOver="this.style.background='#eeeeee';" onMouseOut="this.style.background='#ffffff';">
  <td>["><%= record["Name"] %>](/accounts/<%= record[)</td>
  <td><%= record["BillingCity"] %></td>
  <td><%= record["BillingState"] %></td>
  <td><%= record["Phone"] %></td>
 </tr>
<% end %>
</table>
{% endhighlight %}

