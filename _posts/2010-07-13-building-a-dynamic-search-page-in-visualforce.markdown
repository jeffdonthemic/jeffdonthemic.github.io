---
layout: post
title:  Building a Dynamic Search Page in Visualforce
description: I brushed this code off and thought it might be useful to someone as a starting point for a dynamic search page. It has some cool functionality including passing search criteria via Javascript to the controller, search as you type, sorting of results by clicking on the column header plus much more. Hope you find it useful. You can run this demo at my developer site.  Some of the interesting features of the Visualforce page and Apex controller include- * Instead of the typical overhead of using g
date: 2010-07-13 09:31:34 +0300
image:  '/images/slugs/building-a-dynamic-search-page-in-visualforce.jpg'
tags:   ["2010", "public"]
---
<p>I brushed this code off and thought it might be useful to someone as a starting point for a dynamic search page. It has some cool functionality including passing search criteria via Javascript to the controller, search as you type, sorting of results by clicking on the column header plus much more. Hope you find it useful.</p>
<h3 style="text-decoration:underline"><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/CustomerSearch" target="_blank"><font class="Apple-style-span" color="#000000">You can run this demo at my developer site.</font></a></h3>
<p><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/CustomerSearch"><img src="images/customer-search_wf2df3.png" alt="" title="customer-search" width="500" class="alignnone size-full wp-image-2782" /></a></p>
<p>Some of the interesting features of the Visualforce page and Apex controller include:<p><ul><li>Instead of the typical overhead of using getters/setters in the controller to maintain the variables for the search form, I used <a href="http://blog.sforce.com/sforce/2009/10/passing-javascript-values-to-apex-controller.html" target="_blank">Dave Carroll's blog</a> as an example to pass the variables via Javascript.</li><li>Since I'm using Javascript to pass my parameters, I can get fancy and make the search form more dynamic by running the search as the user types or selects an option in the picklist. No submit button is required.</li><li>Users can click on the column headers to toggle the direction of the search results by using a CommandLink component and passing the column name.</li><li>Build the picklist using Dynamic Apex's <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dynamic_describe_objects_understanding.htm" target="_blank">Describe functionality</a> so that it's maintenance free.</li><li>Perform the search against multiple fields including multi-select picklists using dynamic SOQL and preventing SOQL injection attacks.</li></ul></p>
<p><b>ContactSearchController</b></p>
<p>Take a look at the Apex code below. The search interaction is split up between two separate but integral parts. When the search is fired from the Visualforce page via Javascript, the SOQL is constructed in the runSearch() method and is then passed to the runQuery() method to execute. The SOQL string is persisted so that when the user clicks on the table column the same SOQL can be issued again in the toggleSort() method but ordered by a different field name and sort direction.</p>
{% highlight js %}public with sharing class ContactSearchController {
 
 // the soql without the order and limit
 private String soql {get;set;}
 // the collection of contacts to display
 public List<Contact> contacts {get;set;}
 
 // the current sort direction. defaults to asc
 public String sortDir {
  get { if (sortDir == null) { sortDir = 'asc'; } return sortDir; }
  set;
 }
 
 // the current field to sort by. defaults to last name
 public String sortField {
  get { if (sortField == null) {sortField = 'lastName'; } return sortField; }
  set;
 }
 
 // format the soql for display on the visualforce page
 public String debugSoql {
  get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
  set;
 }

 // init the controller and display some sample data when the page loads
 public ContactSearchController() {
  soql = 'select firstname, lastname, account.name, interested_technologies__c from contact where account.name != null';
  runQuery();
 }
 
 // toggles the sorting of query from asc<-->desc
 public void toggleSort() {
  // simply toggle the direction
  sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
  // run the query again
  runQuery();
 }
 
 // runs the actual query
 public void runQuery() {
  
  try {
 contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
  } catch (Exception e) {
 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
  }

 }
 
 // runs the search with parameters passed via Javascript
 public PageReference runSearch() {
  
  String firstName = Apexpages.currentPage().getParameters().get('firstname');
  String lastName = Apexpages.currentPage().getParameters().get('lastname');
  String accountName = Apexpages.currentPage().getParameters().get('accountName');
  String technology = Apexpages.currentPage().getParameters().get('technology');
  
  soql = 'select firstname, lastname, account.name, interested_technologies__c from contact where account.name != null';
  if (!firstName.equals(''))
 soql += ' and firstname LIKE ''+String.escapeSingleQuotes(firstName)+'%'';
  if (!lastName.equals(''))
 soql += ' and lastname LIKE ''+String.escapeSingleQuotes(lastName)+'%'';
  if (!accountName.equals(''))
 soql += ' and account.name LIKE ''+String.escapeSingleQuotes(accountName)+'%''; 
  if (!technology.equals(''))
 soql += ' and interested_technologies__c includes (''+technology+'')';

  // run the query again
  runQuery();

  return null;
 }
 
 // use apex describe to build the picklist values
 public List<String> technologies {
  get {
 if (technologies == null) {
   
  technologies = new List<String>();
  Schema.DescribeFieldResult field = Contact.interested_technologies__c.getDescribe();
  
  for (Schema.PicklistEntry f : field.getPicklistValues())
   technologies.add(f.getLabel());
   
 }
 return technologies;   
  }
  set;
 }

}
{% endhighlight %}
<p><b>CustomerSearch Visualforce Page</b></p>
<p>The Visualforce page has three sections: 1) a search form, 2) a results blockTable and 3) a debug panel displaying the SOQL that was executed. </p>
<p>The search form has a number of fields that fire the Javascript search using the onkeyup and onchange events. Instead of each form field passing the current values to actionFunction's Javascript method, for ease of use, each form field calls the doSearch() function that gathers up the values and submits them. When the actionFunction renders it creates a Javascript function that POSTs the values to the controller in the same manner as CommandLink or CommandButton. </p>
<p>The search results BlockTable is rerendered when the search is submitted to the controller so that the results display properly. Users can click on the column headers to reorder the results of the query. This uses a CommandLink to pass the sort field to the controller and toggle the sort direction.</p>
{% highlight js %}<apex:page controller="ContactSearchController" sidebar="false">

 <apex:form >
 <apex:pageMessages id="errors" />
 
 <apex:pageBlock title="Find Me A Customer!" mode="edit">
  
 <table width="100%" border="0">
 <tr> 
  <td width="200" valign="top">
 
 <apex:pageBlock title="Parameters" mode="edit" id="criteria">
 
 <script type="text/javascript">
 function doSearch() {
  searchServer(
   document.getElementById("firstName").value,
   document.getElementById("lastName").value,
   document.getElementById("accountName").value,
   document.getElementById("technology").options[document.getElementById("technology").selectedIndex].value
   );
 }
 </script> 
 
 <apex:actionFunction name="searchServer" action="{!runSearch}" rerender="results,debug,errors">
   <apex:param name="firstName" value="" />
   <apex:param name="lastName" value="" />
   <apex:param name="accountName" value="" />
   <apex:param name="technology" value="" />
 </apex:actionFunction>
   
 <table cellpadding="2" cellspacing="2">
 <tr>
  <td style="font-weight:bold;">First Name<br/>
  <input type="text" id="firstName" onkeyup="doSearch();"/>
  </td>
 </tr>
 <tr>
  <td style="font-weight:bold;">Last Name<br/>
  <input type="text" id="lastName" onkeyup="doSearch();"/>
  </td>
 </tr>
 <tr>
  <td style="font-weight:bold;">Account<br/>
  <input type="text" id="accountName" onkeyup="doSearch();"/>
  </td>
 </tr>
 <tr>
  <td style="font-weight:bold;">Interested Technologies<br/>
   <select id="technology" onchange="doSearch();">
  <option value=""></option>
  <apex:repeat value="{!technologies}" var="tech">
   <option value="{!tech}">{!tech}</option>
  </apex:repeat>
   </select>
  </td>
 </tr>
 </table>
 
 </apex:pageBlock>
 
  </td>
  <td valign="top">
  
  <apex:pageBlock mode="edit" id="results">
    
  <apex:pageBlockTable value="{!contacts}" var="contact">
  
  <apex:column >
    <apex:facet name="header">
    <apex:commandLink value="First Name" action="{!toggleSort}" rerender="results,debug">
    <apex:param name="sortField" value="firstName" assignTo="{!sortField}"/>
    </apex:commandLink>
    </apex:facet>
    <apex:outputField value="{!contact.firstName}"/>
  </apex:column>
  
  <apex:column >
    <apex:facet name="header">
    <apex:commandLink value="Last Name" action="{!toggleSort}" rerender="results,debug">
    <apex:param name="sortField" value="lastName" assignTo="{!sortField}"/>
    </apex:commandLink>
    </apex:facet>
    <apex:outputField value="{!contact.lastName}"/>
  </apex:column>
  
  <apex:column >
    <apex:facet name="header">
    <apex:commandLink value="Account" action="{!toggleSort}" rerender="results,debug">
    <apex:param name="sortField" value="account.name" assignTo="{!sortField}"/>
    </apex:commandLink>
    </apex:facet>
    <apex:outputField value="{!contact.account.name}"/>
  </apex:column>
  
  <apex:column >
    <apex:facet name="header">
    <apex:commandLink value="Technologies" action="{!toggleSort}" rerender="results,debug">
    <apex:param name="sortField" value="interested_technologies__c" assignTo="{!sortField}"/>
    </apex:commandLink>
    </apex:facet>
    <apex:outputField value="{!contact.Interested_Technologies__c}"/>
  </apex:column>
  
  </apex:pageBlockTable>
    
  </apex:pageBlock>
  
  </td>
 </tr>
 </table>
 
 <apex:pageBlock title="Debug - SOQL" id="debug">
 <apex:outputText value="{!debugSoql}" />  
 </apex:pageBlock>  
 
 </apex:pageBlock>

 </apex:form>

</apex:page>
{% endhighlight %}

