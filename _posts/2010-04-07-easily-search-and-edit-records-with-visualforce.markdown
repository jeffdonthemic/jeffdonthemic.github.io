---
layout: post
title:  Easily Search and Edit Records with Visualforce
description: I tend to over think Visualforce development sometimes and make it harder than it should be. Development with Force.com is surprisingly easy, elegant and quick. For example I recently needed to develop a way for the users to search for records and update specific values. Users should be able to search for records by keyword search, view multiple matching records, update values for multiple records, commit the changes to the database and check for validation errors. Now if I was doing this in Jav
date: 2010-04-07 10:43:04 +0300
image:  '/images/slugs/easily-search-and-edit-records-with-visualforce.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
I tend to over think Visualforce development sometimes and make it harder than it should be. Development with Force.com is surprisingly easy, elegant and quick. For example I recently needed to develop a way for the users to search for records and update specific values. Users should be able to search for records by keyword search, view multiple matching records, update values for multiple records, commit the changes to the database and check for validation errors.

Now if I was doing this in Java I'd need to:

*   Create a JSP for the UI
*   Create a bean to model the data
*   Implement a Javascript framework for form validation
*   Write a DAO layer of to handle the search, retrieval and persisting of records
*   Write a Servlet to control the entire process

Force.com makes developing this type of interface a snap. Using only a single Visualforce page and an Apex controller you can whip up the following in no time.

Force.com provides the data model (custom object), the search functionality (SOQL/SOSL) and the DAO layer (DML) for you so all you have to do is implement the business logic and process flow. One of my favorite features of Visualforce is the baked-in form validation. Gone are the days when you had to implement validation in each page you developed and then always remember to update the rules when changes are made. You simply define the fields at the object level with all of its rules and datatype specifics. When developing your Visualforce page, by simply using the standard components you invoke the validation inherit in the platform as well as some nifty Ajax eye-candy. You can focus on the business requirements and not the low level data integrity requirements.

So here is the code for the Visualforce page and Apex controller in case anyone wants to use it for a starting point.

```html
<apex:page standardController="MyObject__c" extensions="ItemEditController">
  <apex:sectionHeader title="{!MyObject__c.Name}" subtitle="Edit Records"/>
  <apex:form >
    <apex:pageBlock mode="edit" id="block">

      <apex:pageBlockButtons location="both">
        <apex:commandButton action="{!save}" value="Save Records"/>
        <apex:commandButton action="{!cancel}" value="Cancel"/>
      </apex:pageBlockButtons>
      <apex:pageMessages />

      <apex:pageBlockSection >
        <apex:pageBlockSectionItem >
          <apex:outputLabel for="searchText">Keyword</apex:outputLabel>
          <apex:panelGroup >
          <apex:inputText id="searchText" value="{!searchText}"/>
          <apex:commandButton value="Search" action="{!search}" rerender="block" status="status"/>
          </apex:panelGroup>
        </apex:pageBlockSectionItem>
      </apex:pageBlockSection><br/>

      <apex:actionStatus id="status" startText="Searching... please wait..."/>
      <apex:pageBlockSection title="Search Results" id="resultsBlock" columns="1">
        <apex:pageBlockTable value="{!searchResults}" var="item" rendered="{!NOT(ISNULL(searchResults))}">
          <apex:column value="{!item.Name}" headerValue="Item" width="100"/>
          <apex:column headerValue="Value" width="200">
            <apex:inputField value="{!item.Value__c}"/>
          </apex:column>
        </apex:pageBlockTable>
      </apex:pageBlockSection>
    </apex:pageBlock>
  </apex:form>
</apex:page>
```

```javascript
public with sharing class ItemEditController {

  private ApexPages.StandardController controller {get; set;}
  public List<itemObject__c> searchResults {get;set;}
  public string searchText {get;set;}

  // standard controller - could also just use custom controller
  public ItemEditController(ApexPages.StandardController controller) { }

  // fired when the search button is clicked
  public PageReference search() {
    String qry = 'select id, name, value__c from ItemObject__c ' +
      'where name LIKE &#92;'%'+searchText+'%&#92;' order by name';
    searchResults = Database.query(qry);
    return null;
  }

  // fired when the save records button is clicked
  public PageReference save() {

    try {
      update searchResults;
    } Catch (DMLException e) {
      ApexPages.addMessages(e);
      return null;
    }

    return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
  }

  // takes user back to main record
  public PageReference cancel() {
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
  }

}
```
