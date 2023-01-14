---
layout: post
title:  Updating a Record When Viewed using Std Page Layout
description:   I recently had a scenario where I wanted to track the last time a Lead record was viewed in Salesforce for auditing purposes. I added a simple Last_Viewed__c  date field to the Lead object and then set about updating it every time the record was displayed in the standard page layout. I poked around the interwebs  a bit to see if anyone had any success implementing this but no luck. There was a lot of talk about overriding the entire standard page layout with a new Visualforce page but I really
date: 2014-04-01 12:11:02 +0300
image:  '/images/slugs/updating-a-record-when-viewed-using-standard-page-layout.jpg'
tags:   ["salesforce"]
---
<p><img src="images/forcetk-meme_f2vwlp.jpg" alt="" ></p>
<p>I recently had a scenario where I wanted to track the last time a Lead record was viewed in Salesforce for auditing purposes. I added a simple <code>Last_Viewed__c</code> date field to the Lead object and then set about updating it every time the record was displayed in the standard page layout.</p>
<p>I poked around the <a href="http://www.urbandictionary.com/define.php?term=interwebs">interwebs</a> a bit to see if anyone had any success implementing this but no luck. There was a lot of talk about overriding the entire standard page layout with a new Visualforce page but I really didn't want to go that route. So I think I came up with a solution that is pretty simple to implement. In a nutshell, you create an inline Visualforce page that uses <a href="https://twitter.com/metadaddy">Pat Patterson's</a> super-awesome <a href="https://github.com/developerforce/Force.com-JavaScript-REST-Toolkit">ForceTK JavaScript library</a> to update the record on page load using the REST API.</p>
<p>The first thing you need to do is download the <a href="https://github.com/developerforce/Force.com-JavaScript-REST-Toolkit/blob/master/forcetk.js">forcetk.js</a> libaray and <a href="http://jquery.com/download/">jQuery</a>. It has been tested on jQuery 1.4.4 and 1.5.2, but other versions may also work. I used 1.5.2. Next upload these two files as static resources with the names "forcetk" and "jquery152".</p>
<p>Next, you need to add the correct REST endpoint hostname for your instance (i.e. <a href="https://na1.salesforce.com/">https://na1.salesforce.com/</a> or similar) as a remote site in <em>Your Name > Administration Setup > Security Controls > Remote Site Settings</em>.</p>
<p>Now create a Visualforce page that has no display and only calls the REST API with forcetk. Make sure you use the standardController attribute so that you can embed it into your page layout. One thing to note on the code below. On line 12 when calling the <em>update</em> method, the last argument is a callback function. I've set this to null since I don't really care about the outcome but you may want to display the response for debugging or some other purpose.</p>
{% highlight js %}<apex:page standardController="Lead">
 <apex:includeScript value="{!$Resource.jquery152}" />
 <apex:includeScript value="{!$Resource.forcetk}" />
 <script type="text/javascript">
 // Get a reference to jQuery as forcetk needs it 
 $j = jQuery.noConflict();
 // create an instance of the REST API client
 var client = new forcetk.Client();
 // set the session ID to your current session ID
 client.setSessionToken('{!$Api.Session_ID}');
 // make you call to update the record!
 client.update("Lead", '{!Lead.Id}', 
  {Last_Viewed__c: new Date()}, null); 
 </script>
</apex:page>
{% endhighlight %}
<p>The last step is to add this Visualforce page to your standard page layout. In the page layout editor, drag the Visualforce page to a section that is not collapsable (so it's sure to be called), I added mine under the Created By field, and set the Visualforce Page Properties to 0px width and 0px height. This way it will not appear on the page to the user. Now, after the page finishes loading, the REST API will be called to update the <code>Last_Viewed__c</code> field with the current date! Viola!</p>

