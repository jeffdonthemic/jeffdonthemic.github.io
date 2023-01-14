---
layout: post
title:  Build a Command Line App for Force.com with Ruby & Thor
description: Over at CloudSpokes  we write a lot of ruby code (CloudSpokes.com runs on Heroku in Ruby with Database.com  as the backend) for debugging, data migration, utilities and more. We typically just write a quick ruby class and run it from the command line to execute the script. However, I thought it might be cooler to write a cli for Force.com that I could distribute to the team. So if you know a little ruby, the process isnt that difficult. All you need is the databasedoctom gem  and thor , a simple
date: 2012-05-01 12:17:33 +0300
image:  '/images/slugs/forcedotcom-cli.jpg'
tags:   ["ruby", "salesforce"]
---
<p>Over at <a href="http://www.cloudspokes.com">CloudSpokes</a> we write a lot of ruby code (CloudSpokes.com runs on Heroku in Ruby with <a href="http://www.database.com">Database.com</a> as the backend) for debugging, data migration, utilities and more. We typically just write a quick ruby class and run it from the command line to execute the script. However, I thought it might be cooler to write a cli for Force.com that I could distribute to the team.</p>
<p>So if you know a little ruby, the process isn't that difficult. All you need is the <a href="https://github.com/heroku/databasedotcom">databasedoctom gem</a> and <a href="https://github.com/wycats/thor">thor</a>, a simple tool for building self-documenting command line utilities in ruby. You then write your ruby code in the .thor file and execute if from the command line as you would any other cli.</p>
<p>So here are the available commands for the cli via thor's help command. Feel free to <a href="https://github.com/jeffdonthemic/Force.com-Command-Line">fork the code at github</a>.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327739/commandline_nsfhsg.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327739/commandline_nsfhsg.png" alt="" title="commandline" ></a></p>
<p>This video walks you through the functionality, setup and code for the cli in case you want more detail. The main code is below after the jump.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/b3YV2Fj84yQ?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>Assuming you have ruby installed, you need to install the databasedotcom and thor gems. It's very trivial and the instructions are available from their respective github repos. With thor, you can pass parameters to each task and setup method options. So for instance, in the thor file below, each task has an optional '-c' switch where you specify the connection file to load thus making it easy to connect to different orgs. If you omit the switch, the default databasedotcom.yml file is loaded.</p>
{% highlight js %}require 'databasedotcom'

class Utils < Thor

 desc "query SOQL", "runs a soql query and displays the value of each record's 'name' field"
 method_option :config_file, :type => :string, :default => "databasedotcom.yml", 
  :aliases => "-c", :desc => "The name of the file containing the connection parameters." 
 def query(soql)
  client = authenticate(options[:config_file])
  # execute the soql and iterate over the results to output the name
  client.query("#{soql}").each do |r|
 puts r.Name
  end
 end

 desc "export SOQL FIELDS FILE", "runs a soql query and exports the specified 
  comma separated list of fields to a comma separated file"
 method_option :config_file, :type => :string, :default => "databasedotcom.yml", 
  :aliases => "-c", :desc => "The name of the file containing the connection parameters."
 def export(soql, fields, file)
  client = authenticate(options[:config_file])
  # query for records
  records = client.query("#{soql}")
  # open the file to write (probably local directory)
  File.open(file, 'w') do |f| 
 # interate over the records
 records.each do |r| 
  # create a single line with all field values specified
  line = ''
  fields.split(',').each do |field|
   line += "#{eval("r.#{field}")},"
  end 
  # write each line to the csv file  
  f.puts "#{line}\n"
 end
  end 
 end

 desc "describe OBJECT", "displays the describe info for a particular object"
 method_option :config_file, :type => :string, :default => "databasedotcom.yml", 
  :aliases => "-c", :desc => "The name of the file containing the connection parameters."
 def describe(object)
  client = authenticate(options[:config_file])
  # call describe on the object by name
  sobject = client.describe_sobject(object)
  # output the results -- not very useful (frowny face)
  puts sobject
 end

 desc "get_token", "retreives an access token"
 method_option :config_file, :type => :string, :default => "databasedotcom.yml", 
  :aliases => "-c", :desc => "The name of the file containing the connection parameters."
 def get_token
  client = authenticate(options[:config_file]).oauth_token
  puts "Access token: #{client}"
 end

 desc "show_config", "display the salesforce connection properties"
 method_option :config_file, :type => :string, :default => "databasedotcom.yml", 
  :aliases => "-c", :desc => "The name of the file containing the connection parameters."
 def show_config
  config = YAML.load_file(options[:config_file])
  puts config
 end

 private 

  def authenticate(file_name)
 # load the configuration file with connection parameters
 config = YAML.load_file(file_name)
 # init the databasedotcom gem with the specified yml config file
 client = Databasedotcom::Client.new(file_name)  
 # pass the credentials to authenticate
 client.authenticate :username => config['username'], :password => config['password']
 return client
  end

end
{% endhighlight %}
<p>The connection file is a simple yml file containing the parameters specified by the databasedotcom gem. You can have as many connection files as you would like to for production, developer and sandbox orgs and easily load different files using the '-c' switch. For instance, to run the query task against the org specified in the sandbox.yml file you would run:</p>
{% highlight js %}thor utils:query 'select id, name from account limie 10' -c 'sandbox.yml'
{% endhighlight %}
{% highlight js %}client_id: YOUR-CLIENT-ID
client_secret: YOUR-CLIENT-SECRET
host: test.salesforce.com
debugging: false
username: YOUR-USERNAME
password: YOUR-PASSWORD
{% endhighlight %}

