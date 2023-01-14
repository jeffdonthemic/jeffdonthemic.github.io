---
layout: post
title:  Learning Ruby for Force.com Developers - Part 1
description:   With salesforce.coms recent purchase of Heroku  , Ruby just got more interesting. Ive never dabbled in Ruby (although Ive wanted to!) so this is an excellent reason to dig into the language and see what its all about. Since Im learning Ruby I thought some people might also benefit from the experience and make the learning curve a little less steep. So today Im kicking off a multi-part series on getting started with Ruby and Heroku. Im not sure how many posts there will be but I hope to post so
date: 2010-12-30 13:34:24 +0300
image:  '/images/slugs/learning-ruby-for-force-com-developers-part-1.jpg'
tags:   ["heroku", "ruby", "salesforce"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327875/ruby-lang_qvmr4g.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_97,w_300/v1400327875/ruby-lang_qvmr4g.png" alt="" title="ruby-lang" width="250" class="alignleft size-medium wp-image-3452" /></a></p>
<p>With salesforce.com's <a href="http://www.zdnet.com/blog/btl/salesforce-buy-heroku-for-212-million-eyes-ruby-developers/42495">recent purchase of Heroku</a>, Ruby just got more interesting. I've never dabbled in Ruby (although I've wanted to!) so this is an excellent reason to dig into the language and see what it's all about. Since I'm learning Ruby I thought some people might also benefit from the experience and make the learning curve a little less steep.</p>
<p>So today I'm kicking off a multi-part series on getting started with Ruby and Heroku. I'm not sure how many posts there will be but I hope to post something every week on the subject. I welcome <strong>any</strong> input you might have to make my journey easier. I know there are some Ruby experts in the salesforce.com community so please keep me honest and on the right track. Here are my goals of the series:</p>
<ul>
<li>Learn Ruby</li>
<li>Develop an app locally using Ruby on Rails and the default SQLite database</li>
<li>Modify the app to use Database.com and the Force.com Toolkit for Ruby</li>
<li>Deploy the app to <a href="http://heroku.com/">Heroku</a></li>
<li>Modify the app to use Database.com and the REST API</li>
</ul>
<p><strong>Assumptions</strong></p>
<p>For this series I'm assuming that you have some type of basic programming background, have <strong>no knowledge</strong> of Ruby (I certainly don't), are using a Mac (sorry PC guys/gals but most of the difference is simply setup and configuration) and have a little time to experiment and learn.</p>
<p><strong>Technology Overview</strong></p>
<p>So with any new technology there is a lot of stuff to learn and digest. Here are some key aspects that you should know:</p>
<p><strong>Ruby</strong> - <a href="http://www.ruby-lang.org/en/about/">Ruby</a> is an object-oriented interpreted scripting language created by Yukihiro Matsumoto (more affectionately known as Matz) in Japan starting in 1993. Ruby is an interpreted language (similar to PHP, Python and JavaScript) that is compiled when it is executed. Languages like Java and C++ are pre-compiled into a binary before being executed. Ruby is very portable, elegant and somewhat easier to learn. The disadvantage, since it is an interpreted language, is that it runs slower than equivalent compiled applications and your source code is visible to anyone using your application. <a href="http://en.wikipedia.org/wiki/Ruby_(programming_language)">Wikipedia</a> has a really good, quick overview of the language and syntax.</p>
<p><strong>RubyGems</strong> - <a href="http://rubygems.org/">RubyGems</a> is a package manager for the Ruby programming language that provides a standard format for distributing Ruby programs and libraries (in a self-contained format called a "gem"), a tool designed to easily manage the installation of gems, and a server for distributing them. You will use RubyGems to install new programs and libraries on your computer.</p>
<p><strong>Ruby on Rails</strong> - <a href="http://rubyonrails.org/">RoR</a> is an open source web application framework developed by <a href="http://37signals.com/">37Signals</a> of BaseCamp fame. Like many web frameworks, RoR uses the Model-View-Controller (MVC) architecture pattern to organize application programming. RoR includes tools that make common development tasks easier "out of the box", such as scaffolding that can automatically construct some of the models and views needed for a basic website. Also included are <a href="http://en.wikipedia.org/wiki/WEBrick">WEBrick</a>, a simple Ruby web server that is distributed with Ruby, and <a href="http://rake.rubyforge.org/">Rake</a>, a build system, distributed as a gem. RoR also uses <a href="http://en.wikipedia.org/wiki/ActiveRecord_(Rails)#Implementations">ActiveRecord</a> (an object-relational mapping system) for database access.</p>
<p><strong>Git</strong> - <a href="http://git-scm.com/">Git</a> is a distributed revision control system <em>similar</em> to Subversion or CVS. You don't need Git to develop Ruby applications however I believe you will need Git to push your application to Heroku. Git is really gaining ground lately and I believe that saleforce.com is moving Code Share to <a href="http://www.github.com">github.com</a>.</p>
<p><strong>Installing Ruby</strong></p>
<p>Depending on your platform, Ruby may or may not be installed already. If you are using a somewhat newer Mac then Ruby should be installed. Open Terminal and type <span style="font-family: 'Lucida Console';"><strong>ruby --version</strong></span>.</p>
<p>The current stable version of Ruby is 1.9.2 but I have 1.8.7 installed and it seems to be working fine for now. If you'd like to download a newer version you can do so from <a href="http://www.ruby-lang.org/en/downloads/">here</a>. If you are on a PC, then you can use the <a href="http://rubyinstaller.org/">RubyInstaller</a>. (I actually just upgraded to 1.9.2 and followed the <a href="http://hivelogic.com/articles/compiling-ruby-rubygems-and-rails-on-snow-leopard/" target="_blank">instructions for Snow Leopard</a> (it was a painless intall) but there are also <a href="http://hivelogic.com/articles/ruby-rails-leopard">instructions for Leopard</a> for those needing it.)</p>
<p><strong>Interactive Ruby</strong></p>
<p>Now that you have Ruby installed it's time to start getting serious. Ruby comes with a program called "Interactive Ruby" (IRB) that will show the results of any Ruby statements you provide it. Playing with Ruby using IRB like this is a great way to learn the language. To get started open Terminal and type <span style="font-family: 'Lucida Console';"><strong>irb</strong></span>. On Windows, open <span style="font-family: 'Lucida Console';"><strong>fxri</strong></span> from the Ruby section of your Start Menu.</p>
<p>Now for the obligatory "Hello World". Type <span style="font-family: 'Lucida Console';"><strong>puts "Hello World"</strong></span> and hit enter. There you go. Your first Ruby program.</p>
<p><strong>Dig into Ruby</strong></p>
<p>Now it's time to really dig into the Ruby language. Here are some links that I've found helpful in order that I would recommend.</p>
<ul>
<li><a href="http://www.ruby-lang.org/en/documentation/quickstart/">Ruby in Twenty Minutes</a> - I would start with this intro first.</li>
<li><a href="http://tryruby.org/">Try Ruby</a> - An interactive tutorial that lets you try out Ruby right in your browser. This is a cool tutorial but it "seemed" to crash on me a number of times.</li>
<li><a href="http://rubylearning.com/satishtalim/tutorial.html" target="_blank">Ruby Tutorial</a> - a really good tutorial for core Ruby programming</li>
<li><a href="http://www.techotopia.com/index.php/Ruby_Essentials">Ruby Essentials</a> - a free on-line book designed to provide a concise and easy to follow guide to learning Ruby.</li>
<li><a href="http://rubykoans.com/">Ruby Koans</a> - These are a series of files that you download and run locally to learn the language, syntax and structure.</li>
<li><a href="http://hackety-hack.com/">Hackety Hack</a> - A fun and easy way to learn about programming (through Ruby) using the Shoes GUI Toolkit.</li>
<li><a href="http://www.ruby-lang.org/en/documentation/">Ruby Documentation</a> - A great list of Ruby references. Pick and choose from here.</li>
</ul>
<p>If anyone has any suggestions for other helpful sites please chime in. Spend some time using Ruby and I think next time we'll get into Ruby on Rails.</p>
