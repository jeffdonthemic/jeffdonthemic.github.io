---
layout: post
title:  Integrate Chatter & Twitter on Google App Engine using OAuth
description: Cross-posted at the Appirio Tech Blog  . At Appirio  weve been excited about Salesforce Chatter for quite a while. We firmly believe that Chatter has the potential to bridge the gap between enterprise applications and the way people work. We were luckily enough to receive special prerelease access to Chatter to develop our Social PS Enterprise for the Dreamforce 09 Chatter Keynote and if you missed the demo at Dreamforce 09 you can find it here . Chatter is now in private beta for 100 companies 
date: 2010-03-17 11:37:01 +0300
image:  '/images/slugs/integrate-chatter-twitter-on-google-app-engine-using-oauth.jpg'
tags:   ["2010", "public"]
---
<p>Cross-posted at the <a href="http://techblog.appirio.com/2010/03/integrate-chatter-twitter-on-google-app.html">Appirio Tech Blog</a>.</p>
<p>At <a href="http://www.appirio.com" target="_blank">Appirio</a> we've been excited about Salesforce Chatter for quite a while. We firmly believe that Chatter has the potential to bridge the gap between enterprise applications and the way people work. We were luckily enough to receive special prerelease access to Chatter to develop our Social PS Enterprise for the Dreamforce '09 Chatter Keynote and if you missed the demo at Dreamforce '09 you can <a href="http://www.youtube.com/watch?v=Xu-2ZgrmBhs&feature=player_embedded#" target="_blank">find it here</a>.</p>
<p>Chatter is now in private beta for 100 companies and it is enabled in our production org. We've been using it for couple of weeks now and I find myself logging into our org more and more to check the status of other employees, projects and opportunities. As a developer I really wanted to get my hands on the code and test drive Chatter's functionality. Luckily Quinton Wall has a great <a href="http://wiki.developerforce.com/index.php/An_Introduction_to_Salesforce_Chatter" target="_blank">Intro to Chatter</a> on developer.force.com to get me started. Sure, I could have developed an Apex and Visualforce application for Chatter but I naturally wanted to integrate Chatter with Twitter. So what I came up with is a Chatter/Twitter app running on Google App Engine using OAuth for Twitter authentication.</p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/FqeGxAuFqSM?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p><strong>Understanding Chatter</strong></p>
<p>Initially I was under the assumption that Salesforce.com would release some sort of API for Chatter. However, they've done something even better. Instead of a new API to learn, Salesforce.com exposed Chatter as a series of sObjects allowing you to query for records using the same SOQL that you know and love and manipulate records using DML. Once you get a grip on the Chatter object model and where data lives, developing applications for Chatter is essentially the same as using the Sales or Service Could.</p>
<p>The Chatter model is based upon familiar social networking "Feed Posts". These posts are made up of a series of Feed Items and Feed Types. The FeedPost stores most of the information that you are concerned about such as the body, title and any content related data. The FeedPost object also contains the information for all posts for the User object including profile statuses, news feeds and entity updates (accounts, contacts or custom objects). The Feed Types are dependent on what actions you are performing:</p>
<ul><li> UserStatus - this is the user status update (e.g., "What are you working on?")</li><li> TextPost - a post you make from a record</li><li> LinkPost - a post that contains a URL link (when you click on the link icon)</li><li> ContentPost - a post that contains some type of uploaded content such as a document or graphic</li><li> TrackedChanges - whenever a field on a record (set up during Chatter Feed Tracking configuration) is updated</li></ul>
<p>One thing to understand from the beginning is that you do not query for Feed Posts directly. You must query via the Feed Item which contains a reference to the details of the post. So to get the last status update for the current user, you would issue the following SOQL:</p>
{% highlight js %}SELECT Id, FeedPost.Body FROM UserFeed WHERE ParentId = :Userinfo.getUserId() And Type = 'UserStatus' ORDER BY CreatedDate DESC LIMIT 1
{% endhighlight %}
<p>For more sample Chatter code, check out the <a href="http://wiki.developerforce.com/index.php/Chatter_Code_Recipes" target="_blank">Chatter Code Recipes</a>.</p>
<p><b>Functional Design</b></p>
<p>From a high-level overview, the application is fairly simple. When it initially loads the user is prompted to log into Twitter using OAuth.</p>
<p>Twitter asks you to grant the App Engine application the ability to access and update your Twitter account. I'm currently working on OAuth for Salesforce.com and hope to have both sides of the application using OAuth soon. Currently my Salesforce.com sandbox credentials are hard-coded in the application.</p>
<p>Once you authorize access you are redirected back to the application on Google App Engine and presented the following options:</p>
<ul style="clear: both"><li>Send your latest tweet to Chatter - fetches your last tweet from your timeline and sends it to Chatter as a status update.</li><li>Tweet your latest Chatter status update - queries for you last Chatter update and tweets it. Since Chatter is designed to be private within your org this option isn't recommended for production and I only implemented it for academic purposes.</li><li>Send a status update to both Chatter and Twitter - presents you with a simple form to enter your status update. Once the form is submitted, your status is sent to both Chatter and Twitter.</li></ul>
<p><strong>Technical Design</strong></p>
<p>The application is developed on Google App Engine using the <a href="http://code.google.com/p/sfdc-wsc/" target="_blank">Force.com Web Service Connector (WSC)</a>, Salesfore.com Partner library, and the <a href="http://twitter4j.org/en/index.html" target="_blank">Twitter4j</a> Java library. Since we are using Google App Engine, download the wsc-gae-16_0.jar and partner-library.jar Jars from the <a href="http://code.google.com/p/sfdc-wsc/downloads/list" target="_blank">WSC project</a>. I used Chatter on one of our sandboxes so I had to do a <a href="/2010/03/11/error-compiling-wsc-appengine-partner-jar-for-sandbox/" target="_blank">little tweaking</a> to get the Partner jar running. Now create a new Web Application Project for App Engine and then drop your two jars and the twitter4j jar into the lib directory. You'll also need to add them to your project's build path in Eclipse.</p>
<p>Next you'll have to <a href="http://twitter.com/oauth" target="_blank">register your app</a> with Twitter. This will give you the consumer key, consumer secret and URLs you'll need to authenticate and make requests to Twitter. I'm storing these credentials along with the Salesforce.com sandbox credentials and user id as static variables in a simple credentials class for ease of use.</p>
<p>The application is a series of JSPs and Servlets and if you'd like the code for the entire project, <a href="http://www.twitter.com/jeffdonthemic" target="_blank">send me a message</a>. The interesting parts of the application are described below and hopefully you can extrapolate the rest.</p>
<p><strong>LoginServlet</strong></p>
<p>This is the initial request for the application. The code uses the Twitter credentials and gets the authorization URL for the app and presents it to the users in the JSP page. The user clicks this link and is taken to Twitter to authorize the application.</p>
{% highlight js %}package com.jeffdouglas;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import org.apache.log4j.Logger;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.RequestToken;

public class LoginServlet extends HttpServlet {

 private static final Logger log = Logger.getLogger(LoginServlet.class);

 public void doGet(HttpServletRequest req, HttpServletResponse resp)
 throws IOException {

  HttpSession session = req.getSession();
  Twitter twitter = new TwitterFactory().getInstance();
  twitter.setOAuthConsumer(Credentials.TWITTER_CONSUMERKEY,Credentials.TWITTER_CONSUMERSECRET);
  RequestToken requestToken = null;

  try {
 requestToken = twitter.getOAuthRequestToken();
  } catch (TwitterException e) {
 log.error(e.toString());
  }

  // get the token and tokenSecret
  String token = (String)requestToken.getToken();
  String tokenSecret = (String)requestToken.getTokenSecret();
  // store the token and tokenSecret in the session
  session.setAttribute("token", token);
  session.setAttribute("tokenSecret", tokenSecret);

  // get the url that the user must click to authenticate w/OAuth
  String authUrl = requestToken.getAuthorizationURL();
  req.setAttribute("authUrl", authUrl);
  RequestDispatcher rd = req.getRequestDispatcher("login.jsp");

  try {
 rd.forward(req, resp);
  } catch (ServletException e) {
 log.error(e.toString());
  }

 }
}
{% endhighlight %}
<p><strong>SendChatterServlet</strong></p>
<p>This Servlet runs when the user clicks the Twitter -> Chatter link. The code grabs the user's last tweet and the uses the Partner Web Services API to submit the sObject with the new Chatter status to Salesforce.com.</p>
{% highlight js %}package com.jeffdouglas;

import java.io.IOException;
import java.util.List;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;

import com.sforce.ws.*;
import com.sforce.soap.partner.*;
import com.sforce.soap.partner.sobject.SObject;

public class SendChatterServlet extends HttpServlet {

 private static final Logger log = Logger.getLogger(SendTweetServlet.class);

 public void doGet(HttpServletRequest req, HttpServletResponse resp)
 throws IOException {

  PartnerConnection connection = null;
  // get the user's last tweet
  String tweet = getLastTweet(req,resp);

  if (tweet != null) {

 try {
  if (connection == null) {
   ConnectorConfig config = new ConnectorConfig();
   config.setUsername(Credentials.SFDC_USERNAME);
   config.setPassword(Credentials.SFDC_PASSWORD);
   connection = Connector.newConnection(config);
  }

  // create the sobject to hold the post
  SObject post = new SObject();
  post.setType("FeedPost");
  post.setField("ParentId", Credentials.SFDC_USERID);
  post.setField("Body", tweet);
  // submit the update to Salesforce.com
  connection.create(new SObject[]{post});

 } catch (ConnectionException ce) {
  log.error(ce.toString());
 }

 resp.getWriter().println("Tweet sent to Chatter: "+tweet);
  } else {
 resp.getWriter().println("Could not fetch the lastes update from Twitter. Nothing sent to Chatter.");
  }

 }

 private String getLastTweet(HttpServletRequest req, HttpServletResponse resp) {

  String tweet = null;
  HttpSession session = req.getSession();
  Twitter twitter = new TwitterFactory().getInstance();

  twitter.setOAuthConsumer(Credentials.TWITTER_CONSUMERKEY,
  Credentials.TWITTER_CONSUMERSECRET);

  // if the access token is present in the session
  if (session.getAttribute("accessToken") == null){
  // get the request token from the session
  String token = (String) session.getAttribute("token");
  String tokenSecret = (String)session.getAttribute("tokenSecret");

  // get the access token from twitter
  AccessToken accessToken = null;
  try {
   accessToken = twitter.getOAuthAccessToken(token, tokenSecret);
  } catch (TwitterException e) {
   log.error(e.toString());
  }
  twitter.setOAuthAccessToken(accessToken);

  // save the access token, that are different from request token
  session.setAttribute("accessToken", accessToken.getToken());
  session.setAttribute("accessTokenSecret", accessToken.getTokenSecret());

  } else {
  // use the access token from the session
  twitter.setOAuthAccessToken((String)session.getAttribute("accessToken"),
  (String)session.getAttribute("accessTokenSecret"));
  }

  List<status> statuses = null;
  try {
 // get the user's timeline
 statuses = twitter.getUserTimeline();
 // set their last tweet to return
 tweet = statuses.get(0).getText();
  } catch (TwitterException e) {
 log.error(e.toString());
  }

  return tweet;

 }

}
{% endhighlight %}
<p><strong>SendTweetServlet</strong></p>
<p>When the user clicks the Chatter -> Twitter link, this Servlet queries Salesforce.com for the user's most recent status update, finds the status in the returned XML results and then sends the status out as a tweet.</p>
{% highlight js %}package com.jeffdouglas;

import java.io.IOException;
import java.util.Iterator;
import javax.servlet.http.*;
import org.apache.log4j.Logger;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;

import com.sforce.ws.*;
import com.sforce.ws.bind.XmlObject;
import com.sforce.soap.partner.*;
import com.sforce.soap.partner.sobject.SObject;

public class SendTweetServlet extends HttpServlet {

 private static final Logger log = Logger.getLogger(SendTweetServlet.class);

 public void doGet(HttpServletRequest req, HttpServletResponse resp)
 throws IOException {

  PartnerConnection connection = null;
  String feedPost = null;

  try {
 if (connection == null) {
  ConnectorConfig config = new ConnectorConfig();
  config.setUsername(Credentials.SFDC_USERNAME);
  config.setPassword(Credentials.SFDC_PASSWORD);
  connection = Connector.newConnection(config);
 }

 QueryResult results = connection
   .query("SELECT Id, FeedPost.Body FROM UserFeed WHERE "
   + "ParentId = '" + Credentials.SFDC_USERID + "'"
   + " And Type = 'UserStatus' ORDER BY CreatedDate DESC LIMIT 1");

 // in this case there will only be 1 record returned, but....
 for (int i = 0; i < results.getRecords().length; i++) {
  SObject feed = results.getRecords()[i];
  feedPost = getFeedBody(feed);
 }

  } catch (ConnectionException ce) {
 log.error(ce.toString());
  }

  if (feedPost != null) {
 sendTweet(feedPost, req, resp);
 resp.getWriter().println("Chatter message sent to Twitter: " + feedPost);
  } else {
 resp.getWriter().println("Nothing sent to Twitter");
  }

 }

 private void sendTweet(String tweet, HttpServletRequest req, HttpServletResponse resp) {

  HttpSession session = req.getSession();
  Twitter twitter = new TwitterFactory().getInstance();

  twitter.setOAuthConsumer(Credentials.TWITTER_CONSUMERKEY,
  Credentials.TWITTER_CONSUMERSECRET);

  // if the access token is present in the session
  if (session.getAttribute("accessToken") == null){
  // get the request token from the session
  String token = (String) session.getAttribute("token");
  String tokenSecret = (String)session.getAttribute("tokenSecret");

  // get the access token from twitter
  AccessToken accessToken = null;
  try {
   accessToken = twitter.getOAuthAccessToken(token, tokenSecret);
  } catch (TwitterException e) {
   log.error(e.toString());
  }
  twitter.setOAuthAccessToken(accessToken);

  // save the access token, that are different from request token
  session.setAttribute("accessToken", accessToken.getToken());
  session.setAttribute("accessTokenSecret", accessToken.getTokenSecret());

  } else {
  // use the access token from the session
  twitter.setOAuthAccessToken((String)session.getAttribute("accessToken"),
  (String)session.getAttribute("accessTokenSecret"));
  }

  try {
 // update the user's twitter status
 twitter.updateStatus(tweet);
  } catch (TwitterException e) {
 log.error(e.toString());
  }

 }

 private String getFeedBody(SObject feed) {
  String feedBody = "";
  Iterator<xmlObject> feedPost = feed.getChildren();
  while (feedPost.hasNext()) {
 XmlObject post = feedPost.next();
 if (post.getValue() == null) {
  Iterator<xmlObject> body = post.getChildren();
  while (body.hasNext()) {
   XmlObject child = body.next();
   if (child.getName().toString().equals(
   "{urn:sobject.partner.soap.sforce.com}Body")) {
  feedBody = child.getValue().toString();
  break;
   }
  }
 }
  }
  return feedBody;
 }
}
{% endhighlight %}
<p><strong>SendBothServlet</strong></p>
<p>This Servlet loads the HTML form presenting the user with a textbox to enter their new status. When the form is posted, the status is sent out to both Chatter and Twitter.</p>
{% highlight js %}package com.jeffdouglas;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.http.AccessToken;

import com.sforce.soap.partner.Connector;
import com.sforce.soap.partner.PartnerConnection;
import com.sforce.soap.partner.sobject.SObject;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

public class SendBothServlet extends HttpServlet {

 private static final Logger log = Logger.getLogger(SendTweetServlet.class);

 private void sendToChatter(String status) {

  PartnerConnection connection = null;

 try {
  if (connection == null) {
   ConnectorConfig config = new ConnectorConfig();
   config.setUsername(Credentials.SFDC_USERNAME);
   config.setPassword(Credentials.SFDC_PASSWORD);
   connection = Connector.newConnection(config);
  }

  // create the sobject to hold the post
  SObject post = new SObject();
  post.setType("FeedPost");
  post.setField("ParentId", Credentials.SFDC_USERID);
  post.setField("Body", status);
  // submit the update to Salesforce.com
  connection.create(new SObject[]{post});

 } catch (ConnectionException ce) {
  log.error(ce.toString());
 }

 }

 private void sendToTwitter(String status, HttpServletRequest req) {

  HttpSession session = req.getSession();
  Twitter twitter = new TwitterFactory().getInstance();

  twitter.setOAuthConsumer(Credentials.TWITTER_CONSUMERKEY,
  Credentials.TWITTER_CONSUMERSECRET);

  // if the access token is present in the session
  if (session.getAttribute("accessToken") == null){
  // get the request token from the session
  String token = (String) session.getAttribute("token");
  String tokenSecret = (String)session.getAttribute("tokenSecret");

  // get the access token from twitter
  AccessToken accessToken = null;
  try {
   accessToken = twitter.getOAuthAccessToken(token, tokenSecret);
  } catch (TwitterException e) {
   log.error(e.toString());
  }
  twitter.setOAuthAccessToken(accessToken);

  // save the access token, that are different from request token
  session.setAttribute("accessToken", accessToken.getToken());
  session.setAttribute("accessTokenSecret", accessToken.getTokenSecret());

  } else {
  // use the access token from the session
  twitter.setOAuthAccessToken((String)session.getAttribute("accessToken"),
  (String)session.getAttribute("accessTokenSecret"));
  }

  try {
 // update the user's twitter status
 twitter.updateStatus(status);
  } catch (TwitterException e) {
 log.error(e.toString());
  }

 }

 public void doPost(HttpServletRequest req, HttpServletResponse resp)
 throws IOException {

  sendToChatter(req.getParameter("status"));
  sendToTwitter(req.getParameter("status"),req);

  resp.getWriter().println("Sent the following to both Chatter and Twitter: "+req.getParameter("status"));

 }

 public void doGet(HttpServletRequest req, HttpServletResponse resp)
 throws IOException {

  try {
 RequestDispatcher rd = req.getRequestDispatcher("post.jsp");
 rd.forward(req, resp);
  } catch (ServletException e) {
 log.error(e.toString());
  }

 }

}
{% endhighlight %}

