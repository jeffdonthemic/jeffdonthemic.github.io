---
layout: post
title:  Learning Ruby for Force.com Developers – Part 3
description: This is part #3 of my adventures of learning Ruby for Force.com developers. If you missed parts#1 and #2 you might want to take a look at those just to get up to speed. Again, these are my goals for this series- * Learn Ruby  * Develop an app locally using Ruby on Rails and the default SQLite database  (this is where we are at right now)  * Modify the app to use Database.com and the Force.com Toolkit for Ruby instead  of the SQLite database  * Deploy the app to Heroku * Modify the app to use Dat
date: 2011-02-03 11:41:43 +0300
image:  '/images/slugs/learning-ruby-for-force-com-developers-e28093-part-3.jpg'
tags:   ["code sample", "ruby", "salesforce"]
---
<p>This is part #3 of my adventures of learning Ruby for Force.com developers. If you missed parts <a href="/2010/12/30/learning-ruby-for-force-com-developers-part-1/">#1</a> and <a href="/2011/01/11/learning-ruby-for-force-com-developers-%E2%80%93-part-2/">#2</a> you might want to take a look at those just to get up to speed. Again, these are my goals for this series:</p>
<ul>
<li>Learn Ruby</li>
<li>Develop an app locally using Ruby on Rails and the default SQLite database (this is where we are at right now)</li>
<li>Modify the app to use Database.com and the Force.com Toolkit for Ruby instead of the SQLite database</li>
<li>Deploy the app to <a href="http://heroku.com/">Heroku</a></li>
<li>Modify the app to use Database.com and the REST API</li>
</ul>
<p>In this post we'll get started building a web app using Ruby on Rails and SQLite. In a nutshell we'll be building a shopping cart app with a little twist. I do a lot of work for <a href="http://www.medisend.org">Medisend International</a>, which is a non-profit that ships medical supplies to developing countries (among other things). They have an (old) international aid self-service portal that allows aid recipients (typically hospital administrators or local NGOs) to create a shipment and select medical supplies to be shipped to their country. We'll be building a replacement with Ruby on Rails.</p>
<p>Before you get started you might want to go through <a href="http://guides.rubyonrails.org/getting_started.html">Get Started with Rails</a> which has a lot of great stuff. I'm only using a subset of the functionality outlined in this guide so you'll definitely want to go through this entire article. I'll zip up all of the code for this part so you can <a href="http://www.jeffdouglas.com/download/ruby-part3-code.zip">download it</a> and pick it apart.</p>
<p>The first thing we'll want to do is install our software needed for Rails. I had some issues during some of the installations but unfortunately I can't help out much so hopefully things go well for you. First, open Terminal and run the following lines:</p>
{% highlight js %}sudo gem update --system
sudo gem install rails
sudo bundle install
sudo gem update rake
sudo gem update sqlite3-ruby
{% endhighlight %}
<p>Now that all of your software is (hopefully) installed let's start building the app using SQLite to store data. Open Terminal and change to the directory where you want to store your files (~/Documents/Programming/Ruby in my case) and run the following command to create the application:</p>
{% highlight js %}rails new mediaid-sqlite
{% endhighlight %}
<p>This will create a Rails application called MediaidSqlite in a directory called mediaid-sqlite. Now switch to this new directory:</p>
{% highlight js %}cd mediaid-sqlite
{% endhighlight %}
<p>Rails created an entire directory structure for us with all of the files we need to begin building out the app. Feel free to take a look. We'll mainly be working in the app directory. Since we'll be using SQLite, run the following command to create an empty database:</p>
{% highlight js %}rake db:create
{% endhighlight %}
<p>This will create both a development and test SQLite databases inside the db/ folder. You now have a fully functional Rails application. To see it in action, fire up the web server on your local development machine by running:</p>
{% highlight js %}rails server
{% endhighlight %}
<p>If all goes well, when you point your browser to <a href="http://localhost:3000">http://localhost:3000</a> you should see the following:</p>
<p><img src="images/atdtdblnd4fgfdqkabfa.png" alt="" ></p>
<p>To stop the web server, simply hit Ctrl+C in the same Terminal window. I typically have at least two Terminal tabs open; one for the server and one for running commands. When running in development mode, Rails does not generally require you to bounce the server when changes are made; changes and files will be automatically picked up by the server.</p>
<p>For the required "Hello World" for the home page, you need to create at minimum a controller and a view. Fortunately, you can do that in a single command. Run the following command in Terminal:</p>
{% highlight js %}rails generate controller home index
{% endhighlight %}
<p>Now we need to delete the default page from your application so Rails will not load it by default. We need to do this as Rails will deliver any static file in the public directory in preference to any dynamic contact we generate from the controllers:</p>
{% highlight js %}rm public/index.html
{% endhighlight %}
<p>Now, you have to tell Rails where the new home page is located. Open the file config/routes.rb in Textmate or your favorite editor. This is your application’s routing file which holds entries in a special DSL that tells Rails how to route incoming requests to your controllers and actions. This file contains many commented out sample routes, and one of them actually shows you how to connect the root of your site to a specific controller and action. Find the line beginning with <em>:root to</em> towards the end of the file, uncomment it so that is looks like the following:</p>
{% highlight js %}root :to =&gt; "home#index"
{% endhighlight %}
<p>One of the cool thing about Rails is the scaffolding. Rails scaffolding is a quick and easy way to generate some of the major pieces of an application such as models, views, and controllers for a new resource. It provides the basic functionality and UI to CRUD records. We can create the scaffolding for Shipment and InventoryItem with just a few easy commands. The command below creates the scaffolding for the Shipment resource and specifies the fields for the model:</p>
{% highlight js %}rails generate scaffold Shipment name:string country:string shipmentType:string status:string shipDate:date items:integer selected:integer reserved:integer
{% endhighlight %}
<p>One of the outputs of the rails generate scaffold command is a database migration script. Migrations are Ruby classes that are designed to make it simple to create and modify database tables. Rails uses rake commands to run migrations, and it’s possible to undo a migration after it’s been applied to your database. Migration filenames include a timestamp to ensure that they’re processed in the order that they were created. Now use the following rake command to run the migration:</p>
{% highlight js %}rake db:migrate
{% endhighlight %}
<p>Now we need the InventoryItems to add to our Shipments. Run the following rails generated scaffold command to create the InventoryItems scaffolding:</p>
{% highlight js %}rails generate scaffold InventoryItem name:string itemNumber:string category:string status:string shipment:integer
{% endhighlight %}
<p>Now run the rake command to perform the database migration for InventoryItems:</p>
{% highlight js %}rake db:migrate
{% endhighlight %}
<p>So now we have our database setup and the basic functionality generated for us by Rails. Some people don't like the scaffolding and prefer to code from scratch but I'm going to simply modify the code generated by the scaffolding. The application consists of essentially 6 view and one controller. We'll look at the views first and then dig into the controller.</p>
<p><strong>Home Page</strong></p>
<p>The home page displays a summary of the available shipments and allows the user to select a shipment to process. There are also links at the bottom to access the auto-generated UI to CRUD records for both shipments and inventory items.</p>
<p><img src="images/wo1aoodqpyfcpew85ovk.png" alt="" ></p>
{% highlight js %}<h3>Welcome to MediSend's MediAid!</h3>

<p>MediAid is an international aid, self-service portal for
 inventory selection, processing and information centralization.</p>

<p>The following shipments are available for your aid case:</p>

<table width="75%" cellpadding="2" cellspacing="2">
<tr>
 <th align="left">Shipment</th>
 <th align="left">Type</th>
 <th align="left">Status</th>
</tr>
<% @shipments.each do |shipment| %>
<tr>
 <td><%= link_to shipment.name, shipment %></td>
 <td><%= shipment.shipmentType %></td>
 <td><%= shipment.status %></td>
</tr>
<% end %>
</table>


<br/>The following options are also available:

<ul>
 <li><%= link_to "Maintain Shipments", shipments_path %></li>
 <li><%= link_to "Maintain Inventory Items", inventory_items_path %></li>
</ul>
{% endhighlight %}
<p><strong>Shipment Display</strong></p>
<p>This page is where most of the work is done for a shipment. It provides the relevant info on the shipment and allows the users to manage the shipment's contents.</p>
<p><img src="images/t864658s69pcty6buvql.png" alt="" ></p>
{% highlight js %}<p id="notice"><%= notice %></p>

<script type="text/javascript">
function confirmDelete() {
 var answer = confirm("Are you sure you want to remove all items from this shipment?")
 if (answer) window.location = "/shipments/<%= @shipment.id %>/remove";
}

function confirmReserve() {
 var answer = confirm("Are you sure you want to update all of the items in this shipment as reserved?")
 if (answer) window.location = "/shipments/<%= @shipment.id %>/reserve";
}
</script>

<h3>Shipment <%= @shipment.name %></h3>

Status: <%= @shipment.status %><br/>
Type: <%= @shipment.shipmentType %><br/>
Country: <%= @shipment.country %><br/>
Items: <%= @shipment.items %><br/>
Selected: <%= @shipment.selected %><br/>
Reserved: <%= @shipment.reserved %>

Available options for this shipment:
<ol>
 <li><%= link_to 'View items in this shipment', items_shipment_path(@shipment) %></li>
 <li><%= link_to 'Add items by product category to this shipment', additems_shipment_path(@shipment) %></li>
 <li><a href="#" onclick="return confirmReserve();">Mark all items as "reserved" for this shipment</a></li>
 <li><a href="#" onclick="return confirmDelete();">Remove all items from this shipment</a></li>
 <li><%= link_to 'View this shipment\'s manifest', manifest_shipment_path(@shipment) %></li>
</ol>

<%= link_to 'Edit', edit_shipment_path(@shipment) %> |
<%= link_to 'Back', shipments_path %>
{% endhighlight %}
<p><strong>Add Inventory Items</strong></p>
<p>The add items pages displays the number of available inventory items by category and if there is at least one available, provides the user with a link to add all of the available items. Clicking the link runs the addAll route to add the items to the shipment and then redirect the user back to the shipment display page.</p>
<img title="ruby3-3.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027923/rnrqwvvpxmqmq5tvnpqt.png" border="0" alt="Ruby3 3" width="550" height="347" />
{% highlight js %}<h3>Add Inventory by Category</h3>

<table width="100%" cellpadding="2" cellspacing="2">
<tr>
 <th align="left">Category</th>
 <th align="left">Available</th>
 <th align="left">Add All</th>
</tr>
<tr>
 <td>Surgical Gloves</td>
 <td><%= @gloves %></td>
 <td><% if @gloves > 0 %><a href="/shipments/<%= @shipment.id %>/addAll?category=Gloves">Add All</a><% else %>Add All<% end %></td>
</tr>
<tr>
 <td>Nebulizer Accessory Kits</td>
 <td><%= @nebulizer %></td>
 <td><% if @nebulizer > 0 %><a href="/shipments/<%= @shipment.id %>/addAll?category=Nebulizer">Add All</a><% else %>Add All<% end %></td>
</tr>
<tr>
 <td>Hyperinflation Systems</td>
 <td><%= @hyperinflation %></td>
 <td><% if @hyperinflation > 0 %><a href="/shipments/<%= @shipment.id %>/addAll?category=Hyperinflation">Add All</a><% else %>Add All<% end %></td>
</tr>
<tr>
 <td>Breathing Circuits</td>
 <td><%= @circuit %></td>
 <td><% if @circuit > 0 %><a href="/shipments/<%= @shipment.id %>/addAll?category=Circuits">Add All</a><% else %>Add All<% end %></td>
</tr>
<tr>
 <td>Armboards</td>
 <td><%= @armboard %></td>
 <td><% if @armboard > 0 %><a href="/shipments/<%= @shipment.id %>/addAll?category=Armboards">Add All</a><% else %>Add All<% end %></td>
</tr>
</table>

<br/><%= link_to 'Back', shipment_path(@shipment) %>
{% endhighlight %}
<p><strong>View Shipment Inventory Items</strong></p>
<p>The page simply displays the inventory items currently assigned to this shipment.</p>
<img title="ruby3-4.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027929/zpackff2uhuen2ixvkrv.png" border="0" alt="Ruby3 4" width="550" height="347" />
{% highlight js %}<h3>Items for Shipment <%= @shipment.name %></h3>

<table width="100%" cellpadding="2" cellspacing="2">
<tr>
 <th align="left">Item</th>
 <th align="left">Name</th>
 <th align="left">Category</th>
 <th align="left">Status</th>
</tr>
<% @items.each do |item| %>
<tr>
 <td><%= item.itemNumber %></td>
 <td><%= item.name %></td>
 <td><%= item.category %></td>
 <td><%= item.status %></td>
</tr>
<% end %>
</table>

<br/><%= link_to 'Back', shipment_path(@shipment) %>
{% endhighlight %}
<p><strong>Mark Items as Reserved</strong></p>
<p>Items that have been added to the shipment need to be marked as reserved so that they can be processed for shipping. Clicking "OK" runs the reserve route to mark the items in the shipment as reserved and then redirect the user back to the shipment display page.</p>
<img title="ruby3-5.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027934/wlne60saloiwsmulfcry.png" border="0" alt="Ruby3 5" width="550" height="347" />
<p><strong>Remove Items from Shipment</strong></p>
<p>Users may want to remove all of the items from their shipment and begin the process anew. Clicking "OK" runs the remove route which removes all of the items from the shipment, making them available again, and then redirects the user back to the shipment display page.</p>
<img title="ruby3-6.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027939/prbifamjwxxs7rep7m8k.png" border="0" alt="Ruby3 6" width="550" height="347" />
<p><strong>Routes</strong></p>
<p>To process the flow of our application we need to modify app/routes.rb to include our new pages. Here's a snippet from the beginning of the file:</p>
{% highlight js %}resources :inventory_items

resources :shipments do
 member do
  get 'additems' # /shipments/1/additems
  get 'addAll'  # /shipments/1/addAll
  get 'items'  # /shipments/1/items
  get 'remove'  # /shipments/1/remove
  get 'reserve' # /shipments/1/reserve
  get 'manifest' # /shipments/1/manifest
 end
end 

get "home/index"
{% endhighlight %}
<p><strong>ShipmentController</strong></p>
<p>Last but not least is the ShipmentController. Controllers provide the “glue” between models and views. In Rails, controllers are responsible for processing the incoming requests from the web browser, interrogating the models for data, and passing that data on to the views for presentation. Take a look at the following code which should explain quite a bit. Since the controller contains code both generated by Rails and added by me, I've annotated it for your viewing ease.</p>
{% highlight js %}class ShipmentsController < ApplicationController
 # GET /shipments
 # GET /shipments.xml
 def index
  @shipments = Shipment.all

  respond_to do |format|
 format.html # index.html.erb
 format.xml { render :xml => @shipments }
  end
 end

 # GET /shipments/1
 # GET /shipments/1.xml
 def show
  @shipment = Shipment.find(params[:id])

  respond_to do |format|
 format.html # show.html.erb
 format.xml { render :xml => @shipment }
  end
 end

 # GET /shipments/new
 # GET /shipments/new.xml
 def new
  @shipment = Shipment.new

  respond_to do |format|
 format.html # new.html.erb
 format.xml { render :xml => @shipment }
  end
 end

 # GET /shipments/1/edit
 def edit
  @shipment = Shipment.find(params[:id])
 end

 # CUSTOM
 # GET /shipments/1/additems
 def additems
  @shipment = Shipment.find(params[:id])

  # get a a count of the available inventory by category
  @gloves = InventoryItem.where(:category => 'Gloves', :status => 'Available').count
  @nebulizer = InventoryItem.where(:category => 'Nebulizer', :status => 'Available').count
  @hyperinflation = InventoryItem.where(:category => 'Hyperinflation', :status => 'Available').count
  @circuit = InventoryItem.where(:category => 'Circuits', :status => 'Available').count
  @armboard = InventoryItem.where(:category => 'Armboards', :status => 'Available').count
 end

 # CUSTOM
 # GET /shipments/1/addAll
 def addAll
  @shipment = Shipment.find(params[:id])

  # add all of the avaiilable items for the category to the shipment as 'selected'
  InventoryItem.where(:category => params[:category], :status => 'Available').each do |item|
 # assign the item to the shipment
 item.shipment = @shipment.id
 # set the status as 'selected'
 item.status = 'Selected'
 item.save
  end
  # update the shipment with total number of items on it
  @shipment.items = InventoryItem.where(:shipment => @shipment.id).count
  # update the shipment with the total number of 'selected' items
  @shipment.selected = InventoryItem.where(:shipment => @shipment.id, :status => 'Selected').count
  @shipment.save
  respond_to do |format|
 format.html { redirect_to(@shipment, :notice => 'Items have been successfully added.') }
 format.xml { head :ok }
  end
 end

 # CUSTOM
 # GET /shipments/1/items
 def items
  @shipment = Shipment.find(params[:id])

  # fetch all of the items on the shipment regardless of status
  @items = InventoryItem.where(:shipment => @shipment.id).order(:name)
 end

 # CUSTOM
 # GET /shipments/1/manifest
 def manifest
  @shipment = Shipment.find(params[:id])

  # fetch all of the items on the shipment regardless of status
  @items = InventoryItem.where(:shipment => @shipment.id).order(:name)
 end

 # CUSTOM
 # GET /shipments/1/remove
 def remove
  @shipment = Shipment.find(params[:id])

  # remove all items on the shipment
  InventoryItem.where(:shipment => @shipment.id).each do |item|
 # remove it from the shipment
 item.shipment = nil
 # mark the item as available
 item.status = 'Available'
 item.save
  end

  # update the shipment with the correct counts
  @shipment.items = 0
  @shipment.reserved = 0
  @shipment.selected = 0
  @shipment.save
  respond_to do |format|
 format.html { redirect_to(@shipment, :notice => 'All items removed from the shipment.') }
 format.xml { head :ok }
  end
 end

 # CUSTOM
 # GET /shipments/1/reserve
 def reserve
  @shipment = Shipment.find(params[:id])

  # mark all items on the shipment as reserved
  InventoryItem.where(:shipment => @shipment.id).each do |item|
 item.status = 'Reserved'
 item.save
  end

  # get a count of the number of reserved items on the shipment
  @shipment.reserved = InventoryItem.where(:shipment => @shipment.id).count
  @shipment.save
  respond_to do |format|
 format.html { redirect_to(@shipment, :notice => 'All items were successfully marked as reserved.') }
 format.xml { head :ok }
  end
 end

 # POST /shipments
 # POST /shipments.xml
 def create
  @shipment = Shipment.new(params[:shipment])

  respond_to do |format|
 if @shipment.save
  format.html { redirect_to(@shipment, :notice => 'Shipment was successfully created.') }
  format.xml { render :xml => @shipment, :status => :created, :location => @shipment }
 else
  format.html { render :action => "new" }
  format.xml { render :xml => @shipment.errors, :status => :unprocessable_entity }
 end
  end
 end

 # PUT /shipments/1
 # PUT /shipments/1.xml
 def update
  @shipment = Shipment.find(params[:id])

  respond_to do |format|
 if @shipment.update_attributes(params[:shipment])
  format.html { redirect_to(@shipment, :notice => 'Shipment was successfully updated.') }
  format.xml { head :ok }
 else
  format.html { render :action => "edit" }
  format.xml { render :xml => @shipment.errors, :status => :unprocessable_entity }
 end
  end
 end

 # DELETE /shipments/1
 # DELETE /shipments/1.xml
 def destroy
  @shipment = Shipment.find(params[:id])
  @shipment.destroy

  respond_to do |format|
 format.html { redirect_to(shipments_url) }
 format.xml { head :ok }
  end
 end
end
{% endhighlight %}
<p><strong>Summary</strong></p>
<p>That's our application in a nutshell. <a href="http://www.jeffdouglas.com/download/ruby-part3-code.zip">You can download a zip of the entire project from here</a>. In the next part of the series we'll dive into the <a href="http://wiki.developerforce.com/index.php/Getting_Started_with_the_Force.com_Toolkit_for_Ruby">Force.com Toolkit for Ruby</a> and really start to integrate with the platform.</p>
<p><strong>Related Posts:</strong></p>
<ul>
<li><a href="/2010/12/30/learning-ruby-for-force-com-developers-part-1/">Learning Ruby for Force.com Developers – Part 1</a></li>
<li><a href="/2011/01/11/learning-ruby-for-force-com-developers-%E2%80%93-part-2/">Learning Ruby for Force.com Developers – Part 2</a></li>
</ul>

