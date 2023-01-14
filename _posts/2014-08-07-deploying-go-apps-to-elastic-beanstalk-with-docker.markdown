---
layout: post
title:  Deploying Go Apps to Elastic Beanstalk with Docker
description: In my last Go Tutorial with MongoDB on Heorku post , we built a simple cribs application using Martini  where  topcoder  members can showcase where they work. If you are just jumping in, you can run the application on Heroku  and find the code on our github repo . Today we are going to take that same application, Dockerize  it and deploy it to AWS Elastic Beanstalk . What about Google App Engine, you ask? Unfortunately, I believe that App Engine only supports Docker in closed preview mode at thi
date: 2014-08-07 16:22:14 +0300
image:  '/images/slugs/deploying-go-apps-to-elastic-beanstalk-with-docker.jpg'
tags:   []
---
<p>In my last <a href="/2014/07/25/go-tutorial-with-mongodb-on-heorku/">'Go Tutorial with MongoDB on Heorku' post</a>, we built a simple 'cribs' application using <a href="http://martini.codegangsta.io/">Martini</a> where <a href="http://www.topcoder.com">topcoder</a> members can showcase where they work. If you are just jumping in, you can <a href="http://tc-cribs.herokuapp.com">run the application on Heroku</a> and <a href="https://github.com/topcoderinc/cribs">find the code on our github repo</a>.</p>
<p>Today we are going to take that same application, <a href="http://docs.docker.com/userguide/dockerizing/">Dockerize</a> it and deploy it to <a href="http://aws.amazon.com/elasticbeanstalk/">AWS Elastic Beanstalk</a>. "What about Google App Engine", you ask? Unfortunately, I believe that App Engine only supports Docker in closed "preview" mode at this time so maybe somewhere down the road we can take look at it.</p>
<h2 id="gettingstartedwithdocker">Getting Started with Docker</h2>
<p>Docker's <a href="http://docs.docker.com/">documentation</a> is top notch and they even have a 10 minute <a href="https://www.docker.com/tryit/">"try docker"</a> online tutorial that's completely browser based. Once you are ready to get started you can <a href="http://docs.docker.com/installation/">install docker</a> on your machine and fire it up. I'm not going to go over the basics of Docker, their <a href="http://docs.docker.com/userguide/">User Guide</a> does a great job of getting you up and running.</p>
<p>The first thing we need to do is create our image. We can either:</p>
<ol>
<li>Update a container created from an image and commit the results to an image to customize it.</li>
<li>Use a Dockerfile to specify instructions to create an image.</li>
</ol>
<p>We are going to do the later as it seems much simpler to build an image and easier to share them.</p>
<p><a href="https://github.com/topcoderinc/cribs/blob/master/server.go">Here is our main Go</a> file that we will be Dockerizing. The only difference from our Heroku version is that we've <a href="https://github.com/topcoderinc/cribs/blob/master/server.go#L86">specified port 8080</a> for Amazon. We'll need to add two files to our application:</p>
<ol>
<li><a href="https://github.com/topcoderinc/cribs/blob/master/Dockerfile">Dockerfile</a> - to create a Docker image that contains your source bundle</li>
<li><a href="https://github.com/topcoderinc/cribs/blob/master/Dockerrun.aws.json">Dockerrun.aws.json</a> - to deploy your application to AWS. (Note, I think if you specify your port in the Dockerfile that you don't need the Dockerrun.aws.json file.)</li>
</ol>
<p>Since the Dockerfile is the heart of the Docker process, let take an in-depth look at it:</p>
{% highlight js %}FROM google/golang

WORKDIR /gopath/src/github.com/topcoderinc/cribs
ADD . /gopath/src/github.com/topcoderinc/cribs/

# go get all of the dependencies
RUN go get github.com/codegangsta/martini
RUN go get github.com/codegangsta/martini-contrib/render
RUN go get github.com/codegangsta/martini-contrib/binding
RUN go get labix.org/v2/mgo
RUN go get labix.org/v2/mgo/bson

RUN go get github.com/topcoderinc/cribs

# set env variables to mongo
ENV MONGO_DB YOUR-MONGO-DB
ENV MONGO_URL YOUR-MONGO-URL

EXPOSE 8080
CMD []
ENTRYPOINT ["/gopath/bin/cribs"]
{% endhighlight %}
<p>The first line tells Docker what to use for our source image. In this case Google was kind enough to bundle the latest version of golang installed from golang.org into a <a href="https://registry.hub.docker.com/u/google/golang/">base image</a> for us so we'll gladly use it.</p>
{% highlight js %}FROM google/golang
{% endhighlight %}
<p>Next we'll set the WORKDIR, which sets the working directory for any RUN, CMD and ENTRYPOINT instructions. We are going to set it to the root of our source files.</p>
{% highlight js %}WORKDIR /gopath/src/github.com/topcoderinc/cribs
{% endhighlight %}
<p>We'll next use the ADD instruction to copy our source code to the container's filesystem for our source directory.</p>
{% highlight js %}ADD . /gopath/src/github.com/topcoderinc/cribs/
{% endhighlight %}
<p>There are a number of dependencies that we need for Martini so we'll have <code>go get</code> them and add them to our image:</p>
{% highlight js %}RUN go get github.com/codegangsta/martini
RUN go get github.com/codegangsta/martini-contrib/render
RUN go get github.com/codegangsta/martini-contrib/binding
RUN go get labix.org/v2/mgo
RUN go get labix.org/v2/mgo/bson
{% endhighlight %}
<p>Finally, we'll get our source code and install it.</p>
{% highlight js %}RUN go get github.com/topcoderinc/cribs
{% endhighlight %}
<p>Since our application still uses the MongoDB sitting on Heroku, we'll use the ENV instruction to set our environment variables we'll need to connect to MongoDB. We would have been better off if we would have created a MongoDB container and <a href="https://docs.docker.com/userguide/dockerlinks/">linked to it</a> but we'll fight that battle another day.</p>
<p><strong>Make sure you change these values before building your image.</strong></p>
{% highlight js %}ENV MONGO_DB YOUR-MONGO-DB
ENV MONGO_URL YOUR-MONGO-URL
{% endhighlight %}
<p>Another major difference with Elastic Beanstalk, is that we declare the port we are using for our application:</p>
{% highlight js %}EXPOSE 8080
{% endhighlight %}
<p>Again, <a href="http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/troubleshooting-docker.html">according to the docs</a> you only need to specify the port in the Dockerfile or dockerrun.aws.json.</p>
<p>We don't need to provide defaults for executing the container so we leave our CMD empty and just set the executable for the container to run, which is our cribs application.</p>
{% highlight js %}CMD []
ENTRYPOINT ["/gopath/bin/cribs"]
{% endhighlight %}
<h2 id="buildingrunningourcontainer">Building & Running our Container</h2>
<p>Now that our Dockerfile is all setup, let's build our container and run it locally before deploying it to Elastic Beanstalk. FYI, here's a <a href="https://gist.github.com/wsargent/7049221">great Docker cheatsheet</a> that I found.</p>
<p>Open Terminal, and start boot2docker, the Linux distribution made specifically to run Docker containers:</p>
{% highlight js %}$ boot2docker init # if you haven't downloaded latest image
$ boot2docker start
{% endhighlight %}
<p>Next, change to the directory with your Dockerfile and build the image:</p>
{% highlight js %}$ cd ~/go/github.com/topcoderinc/cribs # my directory
$ docker build -t cribs .
# You'll see a bunch of images being downloaded and built, then finally...
Successfully built 2fd0b5a7bb4d
{% endhighlight %}
<p>Now you can list your Docker images and see that your cribs image exists:</p>
{% highlight js %}$ docker images
REPOSITORY TAG IMAGE ID  CREATED   VIRTUAL SIZE
cribs  latest  2fd0b5a7bb4d  39 seconds ago  570.6 MB
google/golang  latest  fa77fdfe2188  2 weeks ago 556.9 MB
{% endhighlight %}
<p>Start the container in the background for the cribs image with port 49160 mapped to 8080:</p>
{% highlight js %}$ docker run -p 49160:8080 -d cribs
7b12355a9ae83700da09dd26060df751739a2497d7a75f1beca8e085d7768c58
{% endhighlight %}
<p>You can view the details of the container with the following. Take note of the container id and name of the running container as you'll need them later.</p>
{% highlight js %}$ docker ps
CONTAINER ID  IMAGE    COMMAND   CREATED   STATUS   PORTS     NAMES
7b12355a9ae8  cribs:latest  /gopath/bin/cribs  18 hours ago  Up 4 seconds  0.0.0.0:49160->8080/tcp  stupefied_archimedes
{% endhighlight %}
<p>If you run a container with an exposed port, then you should be able to access that server using the IP address reported to you using the following. Typically, it is 192.168.59.103, but it can change as it's dynamically allocated by the VirtualBox DHCP server.</p>
{% highlight js %}$ boot2docker ip
The VM's Host only interface IP address is: 192.168.59.103
{% endhighlight %}
<p>Now you can open up the browser with the following URL and our app should be running:</p>
<p><a href="http://192.168.59.103:49160">http://192.168.59.103:49160</a></p>
<p>If you are curious about what the container is actually doing, you can view the logs with either the container id or name:</p>
{% highlight js %}$ docker logs stupefied_archimedes
[martini] Started GET / for 192.168.59.3:61354
[martini] Completed 200 OK in 259.43934ms
{% endhighlight %}
<p>Once we are done running our container we need to of course shut it down using either the container id or name:</p>
{% highlight js %}$ docker stop stupefied_archimedes
stupefied_archimedes
{% endhighlight %}
<h2 id="deployingtoelasticbeanstalk">Deploying to Elastic Beanstalk</h2>
<p>Deploying our app to Elastic Beanstalk isn't as fast nor as easy as Heroku but it's relatively painless. Once logged into Elastic Beanstalk, click <code>Create New Application</code> in the upper right to get started.</p>
<p>Enter the <code>Application Name</code> and hit <code>Next</code>. For the <code>Environment tier</code> select 'Web Server' and for <code>Predefined configuration</code> select 'Docker'. Hit <code>Next</code>.</p>
<p>Now we need upload our source code. Zip up the Dockerfile, Dockerrun.aws.json, server.go and the /templates directory into <code>app.zip</code>. Now choose the middle radio button, upload the zip file and hit <code>Next</code>.</p>
<p>Just accept the defaults and hit <code>Next</code> for the next four pages. When you are finally done, scroll down to the bottom of the Review page and click <code>Launch</code>. Now wait 10 minutes or so for the little wheel to stop spinning and your environment and application should be configured and deployed successfully!</p>
<p>You can run the cribs application on Elastic Beanstalk at <a href="http://cribs-env.elasticbeanstalk.com">http://cribs-env.elasticbeanstalk.com</a></p>

