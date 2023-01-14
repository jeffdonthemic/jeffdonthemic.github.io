---
layout: post
title:  EnhancedList Visualforce Component
description: The enhancedList  Visualforce component is an awesome little tag that allows you to display a list view on a Visualforce page. One of the cool features is that you create a custom list view, e.g., Super Special Contacts, and just show those records in the list view by specifying the ID of the list view listId  attribute. That way you can setup a tab that just displays this specific list view and not allow the user to select other list views from the picklist (it doesnt display). The only problem
date: 2014-12-12 15:23:48 +0300
image:  '/images/slugs/enhancedlist-visualforce-component.jpg'
tags:   ["salesforce"]
---
<p>The <a href="http://www.salesforce.com/us/developer/docs/pages/Content/pages_compref_enhancedList.htm">enhancedList</a> Visualforce component is an awesome little tag that allows you to display a list view on a Visualforce page. One of the cool features is that you create a custom list view, e.g., "Super Special Contacts", and just show those records in the list view by specifying the ID of the list view <code>listId</code> attribute. That way you can setup a tab that just displays this specific list view and not allow the user to select other list views from the picklist (it doesn't display).</p>
<p>The only problem with this approach is that the <code>id</code> for the custom list view that you enter in the <code>listId</code> will most likely change during deployments or in a managed pacakge.</p>
<p>So I created the following Visualforce componenet that you can throw in your Visualforce page and use the <code>name</code> of the custom list view instead of the <code>id</code>. All of the code is <a href="https://gist.github.com/jeffdonthemic/e9f06eaa2541bf716f3e">available in this gist</a>. Enjoy!</p>
<h3 id="contactlistviewcomponentcomponent">ContactListViewComponent.component</h3>
<p>This is the component that provides the enhanced list view functionality. It uses the Apex Controller below.</p>
{% highlight js %}<apex:component controller="ContactListViewController">
 <apex:attribute name="listViewName" type="String" required="true" 
  description="The name of the listview." assignTo="{!listName}"/>	

 <apex:enhancedList height="400" rowsPerPage="25" id="ContactList"
  listId="{!listId}" rendered="{!listId != null}" />

 <apex:outputText rendered="{!listId == null}" value="Could not find requewed ListView: '{!listName}'. Please contact your administrator."/>

</apex:component>
{% endhighlight %}
<h3 id="contactlistviewcontrollercls">ContactListViewController.cls</h3>
<p>The Apex Controller for the component simply looks up the Id of the list view by name and returns the Id.</p>
{% highlight js %}public with sharing class ContactListViewController {
  
 public String listName {
  get;
  set {
  listName = value;
  String qry = 'SELECT Name FROM Contact LIMIT 1';
  ApexPages.StandardSetController ssc = 
  new ApexPages.StandardSetController(Database.getQueryLocator(qry));
  List<SelectOption> allViews = ssc.getListViewOptions();
  for (SelectOption so : allViews) {
   if (so.getLabel() == listName) {
  // for some reason, won't work with 18 digit ID
  listId = so.getValue().substring(0,15);
  break;
   }
  }   
  } 
 }
 public String listId {get;set;}
  
}
{% endhighlight %}
<h3 id="specialcontactslistviewpage">SpecialContactsListView.page</h3>
<p>Here's a sample Visualforce page using the component.</p>
{% highlight js %}<apex:page>
 <c:ContactListViewComponent listViewName="Super Special Contacts"/>
</apex:page>
{% endhighlight %}
<h3 id="test_contactlistviewcontrollercls">TEST_ContactListViewController.cls</h3>
<p>And finally, no Salesforce code would be complete without test cases so ...</p>
{% highlight js %}@isTest
private class TEST_ContactListViewController {
 private testMethod static void testSuccess() {
  ContactListViewController con = new ContactListViewController();
  con.listName = 'Super Special Contacts';
  System.assert(con.listId != null);
 }
 
 private testMethod static void testFailure() {
  ContactListViewController con = new ContactListViewController();
  con.listName = 'BADLISTNAME';
  System.assert(con.listId == null);
 }  
}
{% endhighlight %}

