---
layout: post
title:  Apex Search with Checkbox Results
description: This demo is a single Apex custom controller, two Visualforce pages and a wrapper class allowing the user to search an object by keyword (via Dynamic SOQL) and return the results in a page block table with corresponding checkboxes. Selecting one or more checkboxes and clicking the See Results button displays the list of the selected items. This is a very common function as you typically want to search for stuff and then process some selected stuff. You can run this demo  on my developer site. Cu
date: 2009-01-13 18:00:00 +0300
image:  '/images/slugs/apex-search-with-checkbox-results.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>This demo is a single Apex custom controller, two Visualforce pages and a wrapper class allowing the user to search an object by keyword (via Dynamic SOQL) and return the results in a page block table with corresponding checkboxes. Selecting one or more checkboxes and clicking the 'See Results' button displays the list of the selected items.</p>
<p>This is a very common function as you typically want to search for stuff and then process some selected stuff.</p>
<p><strong>You can <a href="http://jeffdouglas-developer-edition.na5.force.com/examples/category_search" target="_blank">run this demo</a> on my developer site.</strong></p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_201,w_300/v1400399680/cat-screenshot_aoxwkj.png" alt="" ></p>
<p><strong>Custom Controller - CategorySearchController<br>
</strong></p>
{% highlight js %}public class CategorySearchController {

 // the results from the search. do not init the results or a blank rows show up initially on page load
 public List<categoryWrapper> searchResults {get;set;}
 // the categories that were checked/selected.
 public List<categoryWrapper> selectedCategories {
  get {
   if (selectedCategories == null) selectedCategories = new List<categoryWrapper>();
   return selectedCategories;
  }
  set;
 }

 // the text in the search box
 public string searchText {
  get {
   if (searchText == null) searchText = 'Category'; // prefill the serach box for ease of use
   return searchText;
  }
  set;
 }

 // constructor
 public CategorySearchController() {}

 // fired when the search button is clicked
 public PageReference search() {

  if (searchResults == null) {
   searchResults = new List<categoryWrapper>(); // init the list if it is null
  } else {
   searchResults.clear(); // clear out the current results if they exist
  }
  // Note: you could have achieved the same results as above by just using:
  // searchResults = new List<categoryWrapper>();

  // dynamic soql for fun
 String qry = 'Select c.Name, c.Id From Cat3__c c Where c.Name LIKE '%'+searchText+'%' Order By c.Name';
 // may need to modify for governor limits??
 for(Cat3__c c : Database.query(qry)) {
  // create a new wrapper by passing it the category in the constructor
  CategoryWrapper cw = new CategoryWrapper(c);
  // add the wrapper to the results
 searchResults.add(cw);
  }
  return null;
 }

 public PageReference next() {

  // clear out the currently selected categories
  selectedCategories.clear();

  // add the selected categories to a new List
  for (CategoryWrapper cw : searchResults) {
   if (cw.checked)
    selectedCategories.add(new CategoryWrapper(cw.cat));
  }

  // ensure they selected at least one category or show an error message.
  if (selectedCategories.size() > 0) {
   return Page.Category_Results;
  } else {
   ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Category.'));
  return null;
  } 

 } 

 // fired when the back button is clicked
 public PageReference back() {
  return Page.Category_Search;
 } 

}

{% endhighlight %}
<p><strong>Visualforce Search Page - Category_Search</strong></p>
{% highlight js %}<apex:page controller="CategorySearchController">
 <apex:form >
  <apex:pageBlock mode="edit" id="block">

   <apex:pageBlockButtons >
    <apex:commandButton action="{!next}" value="See Results" disabled="{!ISNULL(searchResults)}"/>
   </apex:pageBlockButtons>
   <apex:pageMessages />

   <apex:pageBlockSection >
    <apex:pageBlockSectionItem >
     <apex:outputLabel for="searchText">Search for Categories</apex:outputLabel>
     <apex:panelGroup >
     <apex:inputText id="searchText" value="{!searchText}"/>
     <!-- We could have rerendered just the resultsBlock below but we want the -->
     <!-- 'See Results' button to update also so that it is clickable. -->
     <apex:commandButton value="Search" action="{!search}" rerender="block" status="status"/>
     </apex:panelGroup>
    </apex:pageBlockSectionItem>
   </apex:pageBlockSection>

   <apex:actionStatus id="status" startText="Searching... please wait..."/>
   <apex:pageBlockSection title="Search Results" id="resultsBlock" columns="1">
    <apex:pageBlockTable value="{!searchResults}" var="c" rendered="{!NOT(ISNULL(searchResults))}">
     <apex:column width="25px">
      <apex:inputCheckbox value="{!c.checked}"/>
     </apex:column>
     <apex:column value="{!c.cat.Name}" headerValue="Name"/>
    </apex:pageBlockTable>
   </apex:pageBlockSection>
  </apex:pageBlock>
 </apex:form>
</apex:page>

{% endhighlight %}
<p><strong>Visualforce Results Page - Category_Results</strong></p>
{% highlight js %}<apex:page controller="CategorySearchController">
 <apex:form >
  <apex:pageBlock >

   <apex:pageBlockButtons >
    <apex:commandButton action="{!back}" value="Back"/>
   </apex:pageBlockButtons>
   <apex:pageMessages />

   <apex:pageBlockSection title="You Selected" columns="1">
    <apex:pageBlockTable value="{!selectedCategories}" var="c">
     <apex:column value="{!c.cat.Name}"/>
    </apex:pageBlockTable>
   </apex:pageBlockSection>  

  </apex:pageBlock>
 </apex:form>
</apex:page>

{% endhighlight %}
<p><strong>Wrapper Class - CategoryWrapper</strong></p>
{% highlight js %}public class CategoryWrapper {

 public Boolean checked{ get; set; }
 public Cat3__c cat { get; set;}

 public CategoryWrapper(){
 cat = new Cat3__c();
 checked = false;
 }

 public CategoryWrapper(Cat3__c c){
 cat = c;
 checked = false;
 }

 public static testMethod void testMe() {

  CategoryWrapper cw = new CategoryWrapper();
  System.assertEquals(cw.checked,false); 

  CategoryWrapper cw2 = new CategoryWrapper(new Cat3__c(name='Test1'));
  System.assertEquals(cw2.cat.name,'Test1');
  System.assertEquals(cw2.checked,false); 

 }

}

{% endhighlight %}

