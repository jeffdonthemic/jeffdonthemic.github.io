---
layout: post
title:  Roll Your Own Salesforce Lookup Popup Window
description: Lets talk about the standard salesforce.com lookup popup window for a few minutes. You know what Im talking about.. this button right here  Its a handy little button that pops up whenever you need to search for related records. It does a pretty good job but it has some serious drawbacks- 1. Its virtually impossible to modify your search criteria. What if you want   your users to do some crazy search based upon custom logic or search a field   that is not typically available? Sorry... you are out
date: 2011-08-12 11:18:48 +0300
image:  '/images/slugs/roll-your-own-salesforce-lookup-popup-window.jpg'
tags:   ["salesforce", "visualforce", "apex"]
---
<p>Let's talk about the standard salesforce.com "lookup" popup window for a few minutes. You know what I'm talking about.. this button right here</p>
<p><img src="images/1_roll-1.png" alt="" ></p>
<p>It's a handy little button that pops up whenever you need to search for related records. It does a pretty good job but it has some serious drawbacks:</p>
<ol>
<li>It's virtually impossible to modify your search criteria. What if you want your users to do some crazy search based upon custom logic or search a field that is not typically available? Sorry... you are out of luck. Not possible.</li>
<li>It's terrible for creating new records. Let's say that a user searches for a specific related record and it (absolutely) doesn't exist. To create the new record they need to close the lookup window, navigate to the tab to create the new related record, create the new record, then go back to the original record they were either editing or creating, pop up the lookup window again and find their newly created record. Wow! That's a lot of work.3. "Quick Create" is evil! You can enable the "Quick Create" option for an entire org but don't do it! It displays, by default, on the tab home pages for leads, accounts, contacts, forecasts, and opportunities! The major problems are that you can only create new records for these 5 objects (what about the other ones!?), you can't customize the fields on the page and validation rules don't fire (can you say, "bad data").</li>
</ol>
<p><img src="images/2_roll.png" alt="" ></p>
<h3 id="heresthesolution">Here's the Solution!</h3>
<p>I have some good news and some bad news. For standard page layouts I can't help you. Go vote for <a href="http://success.salesforce.com/ideaView?id=08730000000IYRFAA4">this idea</a> and <a href="http://success.salesforce.com/ideaview?id=08730000000IYB1AAO">this idea</a>.However, for Visualforce page I have a solution to all of these problems with code!</p>
<p><img src="images/3_roll.png" alt="" ></p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/CGeFt6hdgRY?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>Here's the code you need to accomplish this and it's also available <a href="https://gist.github.com/jeffdonthemic/4f2feb55a16b95a37798">on this gist</a>. You need two Visualforce pages (the record you are editing and the popup window) and two Apex controllers (a simple one for the record you are editing and the controller for the search and new record popup).</p>
<p><strong>MyCustomLookupController</strong></p>
<p>Here's the Apex controller for the record you are either creating or editing. This is an extremely simple controller that just creates a new contact so you can use the lookup for the related account field.</p>
{% highlight js %}public with sharing class MyCustomLookupController {
  
 public Contact contact {get;set;}
 
 public MyCustomLookupController() {
  contact = new Contact();
 }
  
}
{% endhighlight %}
<p><strong>MyCustomLookup</strong></p>
<p>This is the "magical" Visualforce page that uses jQuery to intercept the popup and instead of showing the standard salesforce.com pop, shows our custom popup instead. The user experience is seamless.</p>
{% highlight js %}<apex:page controller="MyCustomLookupController" id="Page" tabstyle="Contact">

 <script type="text/javascript"> 
 function openLookup(baseURL, width, modified, searchParam){
  var originalbaseURL = baseURL;
  var originalwidth = width;
  var originalmodified = modified;
  var originalsearchParam = searchParam;
  
  var lookupType = baseURL.substr(baseURL.length-3, 3);
  if (modified == '1') baseURL = baseURL + searchParam;
  
  var isCustomLookup = false;
  
  // Following "001" is the lookup type for Account object so change this as per your standard or custom object
  if(lookupType == "001"){
 
 var urlArr = baseURL.split("&");
 var txtId = '';
 if(urlArr.length > 2) {
  urlArr = urlArr[1].split('=');
  txtId = urlArr[1];
 }
 
 // Following is the url of Custom Lookup page. You need to change that accordingly
 baseURL = "/apex/CustomAccountLookup?txt=" + txtId;
 
 // Following is the id of apex:form control "myForm". You need to change that accordingly
 baseURL = baseURL + "&frm=" + escapeUTF("{!$Component.myForm}");
 if (modified == '1') {
  baseURL = baseURL + "&lksearch=" + searchParam;
 }
 
 // Following is the ID of inputField that is the lookup to be customized as custom lookup
 if(txtId.indexOf('Account') > -1 ){
  isCustomLookup = true;
 }
  }
  
  
  if(isCustomLookup == true){
 openPopup(baseURL, "lookup", 350, 480, "width="+width+",height=480,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true);
  }
  else {
 if (modified == '1') originalbaseURL = originalbaseURL + originalsearchParam;
 openPopup(originalbaseURL, "lookup", 350, 480, "width="+originalwidth+",height=480,toolbar=no,status=no,directories=no,menubar=no,resizable=yes,scrollable=no", true);
  } 
 }
</script>

<apex:sectionHeader title="Demo" subtitle="Custom Lookup" />

 <apex:form id="myForm"> 
  <apex:PageBlock id="PageBlock">  
 <apex:pageBlockSection columns="1" title="Custom Lookup">
  <apex:inputField id="Account" value="{!contact.AccountId}" />
 </apex:pageBlockSection>
  </apex:PageBlock>
 </apex:form>
  
</apex:page>
{% endhighlight %}
<p><strong>CustomAccountLookupController</strong></p>
<p>The Apex controller for the custom popup window is yours to customize. I know what you are thinking, "Free at last! Free at last! Thank God Almighty, we are free at last!" This class has all of your custom search functionality plus the method to create a new account. This is demo code so the search is very limited and does not prevent <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dynamic_soql.htm">soql injections</a>.</p>
{% highlight js %}public with sharing class CustomAccountLookupController {
 
 public Account account {get;set;} // new account to create
 public List<Account> results{get;set;} // search results
 public string searchString{get;set;} // search keyword
 
 public CustomAccountLookupController() {
  account = new Account();
  // get the current search string
  searchString = System.currentPageReference().getParameters().get('lksrch');
  runSearch(); 
 }
  
 // performs the keyword search
 public PageReference search() {
  runSearch();
  return null;
 }
 
 // prepare the query and issue the search command
 private void runSearch() {
  // TODO prepare query string for complex serarches & prevent injections
  results = performSearch(searchString);    
 } 
 
 // run the search and return the records found. 
 private List<Account> performSearch(string searchString) {

  String soql = 'select id, name from account';
  if(searchString != '' && searchString != null)
 soql = soql + ' where name LIKE &#92;'%' + searchString +'%&#92;err!.localizedDescription'';
  soql = soql + ' limit 25';
  System.debug(soql);
  return database.query(soql); 

 }
 
 // save the new account record
 public PageReference saveAccount() {
  insert account;
  // reset the account
  account = new Account();
  return null;
 }
 
 // used by the visualforce page to send the link to the right dom element
 public string getFormTag() {
  return System.currentPageReference().getParameters().get('frm');
 }
  
 // used by the visualforce page to send the link to the right dom element for the text box
 public string getTextBox() {
  return System.currentPageReference().getParameters().get('txt');
 }
 
}
{% endhighlight %}
<p><strong>CustomAccountLookup</strong></p>
<p>Any finally the Visualforce page for the popup itself. It contains a tabbed interface easily allowing a user to search for records and create new ones. Make sure you look at the code for the second tab for creating a new record. I have better things to do than change the fields on the input form every time a new field is created or something is made required. The solution is to use<a href="http://www.salesforce.com/us/developer/docs/pages/Content/pages_dynamic_vf_field_sets.htm">field sets</a>! So when an administrator makes a change, they can simply update the field set and the popup reflects the change accordingly. Life is good.</p>
{% highlight js %}<apex:page controller="CustomAccountLookupController"
 title="Search" 
 showHeader="false" 
 sideBar="false" 
 tabStyle="Account" 
 id="pg">
 
 <apex:form >
 <apex:outputPanel id="page" layout="block" style="margin:5px;padding:10px;padding-top:2px;">
  <apex:tabPanel switchType="client" selectedTab="name1" id="tabbedPanel">
  
 <!-- SEARCH TAB -->
 <apex:tab label="Search" name="tab1" id="tabOne">
   
  <apex:actionRegion > 
   <apex:outputPanel id="top" layout="block" style="margin:5px;padding:10px;padding-top:2px;">
  <apex:outputLabel value="Search" style="font-weight:Bold;padding-right:10px;" for="txtSearch"/>
  <apex:inputText id="txtSearch" value="{!searchString}" />
   <span style="padding-left:5px"><apex:commandButton id="btnGo" value="Go" action="{!Search}" rerender="searchResults"></apex:commandButton></span>
   </apex:outputPanel>
 
   <apex:outputPanel id="pnlSearchResults" style="margin:10px;height:350px;overflow-Y:auto;" layout="block">
  <apex:pageBlock id="searchResults"> 
   <apex:pageBlockTable value="{!results}" var="a" id="tblResults">
    <apex:column >
   <apex:facet name="header">
    <apex:outputPanel >Name</apex:outputPanel>
   </apex:facet>
    <apex:outputLink value="javascript:top.window.opener.lookupPick2('{!FormTag}','{!TextBox}_lkid','{!TextBox}','{!a.Id}','{!a.Name}', false)" rendered="{!NOT(ISNULL(a.Id))}">{!a.Name}</apex:outputLink> 
    </apex:column>
   </apex:pageBlockTable>
  </apex:pageBlock>
   </apex:outputPanel>
  </apex:actionRegion>
   
 </apex:tab>
 
 <!-- NEW ACCOUNT TAB -->
 <apex:tab label="New Account" name="tab2" id="tabTwo">

  <apex:pageBlock id="newAccount" title="New Account" >
  
   <apex:pageBlockButtons >
  <apex:commandButton action="{!saveAccount}" value="Save"/>
   </apex:pageBlockButtons>
   <apex:pageMessages />
  
   <apex:pageBlockSection columns="2">
  <apex:repeat value="{!$ObjectType.Account.FieldSets.CustomAccountLookup}" var="f">
   <apex:inputField value="{!Account[f]}"/>
  </apex:repeat>
   </apex:pageBlockSection> 
  </apex:pageBlock>
   
 </apex:tab>
  </apex:tabPanel>
 </apex:outputPanel>
 </apex:form>
</apex:page>
{% endhighlight %}

