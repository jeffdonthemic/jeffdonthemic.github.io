---
layout: post
title:  Dynamically Group & Display Query Results
description: I was working on a Visualforce page that displays the results of a query in separate PageBlock sections based upon a value in the query results. I ran into a small issue which took about an hour or so to solve, so I thought it might make descent blog fodder.  The requirement for the page was to query for records and then display them grouped in sections in a Visualforce page based upon whatever values (in this case BillingState) are returned in the results. If additional states were added, then 
date: 2011-03-02 10:55:14 +0300
image:  '/images/slugs/dynamically-group-display-query-results.jpg'
tags:   ["2011", "public"]
---
<p>I was working on a Visualforce page that displays the results of a query in separate PageBlock sections based upon a value in the query results. I ran into a small issue which took about an hour or so to solve, so I thought it might make descent blog fodder. </p>
<p>The requirement for the page was to query for records and then display them grouped in sections in a Visualforce page based upon whatever values (in this case BillingState) are returned in the results. If additional states were added, then the Visualforce page should be able to add those new sections without changes to the code. Here's a screenshot of the sample solution that I came up with but you can also<a href="http://jeffdouglas-developer-edition.na5.force.com/examples/DisplaySections" target="_blank"> run this sample on my Developer Site</a>:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327812/group-by-value_wnzatl.png" alt="" ></p>
<p>Here's the code for the Visualforce page. I've made it as bare as possible but you can see that it iterates over the array of states to display the pageBlock sections and then displays the record if the state matches the current blockSection's state.</p>
{% highlight js %}<apex:page controller="DisplaySectionsController" action="{!load}" sidebar="false">
 <apex:sectionHeader title="My Sample Display Page" subtitle="Group by States" 
  description="This page shows how you can dynamically group results by field value."/>

 <apex:repeat value="{!states}" var="state">

  <apex:pageBlock title="{!state}">

 <apex:repeat value="{!accounts}" var="account"> 
 
  <apex:outputPanel rendered="{!IF(state=account.BillingState,true,false)}">
  {!account.Name} - {!account.BillingState}<br/>
  </apex:outputPanel>

 </apex:repeat>

  </apex:pageBlock>

 </apex:repeat>

</apex:page>
{% endhighlight %}
<p>The Controller exposes two collections to the Visualforce page: the list of Accounts and the array of States. Here's the issue that I ran into. Since I wanted to have a collection of unique state names, I originally added each state to a Set and simply returned the Set to the Visualforce page (instead of the array) to display the pageBlock sections. However, returning the Set gave me a compile error at line 11 in the Visualforce page:</p>
<blockquote>Save error: Incorrect parameter for operator '='. Expected Text, received Object</blockquote>
<p>The problem is that even though the Set is a collection of Strings, it is actually an object underneath the covers and throws a comparison error. Therefore you have to return the states as an array of strings for the code to compile and run properly.
{% highlight js %}public with sharing class DisplaySectionsController {

 public List<Account> accounts {get;set;} 
 public String[] states {get;set;}
 
 public void load() {
  
  // for demo purposes limit the states 
  accounts = [Select ID, Name, BillingState From Account 
 Where BillingState IN ('CA','NY','FL')];
  
  // dynamically create set of unique states from query
  Set<String> stateSet = new Set<String>();
  for (Account a : accounts)
 stateSet.add(a.BillingState);
 
  // convert the set into a string array 
  states = new String[stateSet.size()];
  Integer i = 0;
  for (String state : stateSet) { 
 states[i] = state;
 i++;
  }
  
 }

}
{% endhighlight %}

