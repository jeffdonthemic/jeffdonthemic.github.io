---
layout: post
title:  Using List Custom Settings in Salesforce.com
description: Salesforce.com recently introduced Custom Settings in Winter 10 which allows you to store custom data sets and associate them on an org-wide, profile or user basis. Custom Settings are essentially custom objects that are exposed in the applications cache and are accessible via their own API. You can certainly build your own custom objects to store settings but using custom settings is much quicker (again they are stored in the application cache) and do not count against SOQL limits when fetched.
date: 2010-01-07 14:04:10 +0300
image:  '/images/slugs/using-list-custom-settings-in-salesforce-com.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>Salesforce.com recently introduced Custom Settings in Winter '10 which allows you to store custom data sets and associate them on an org-wide, profile or user basis. Custom Settings are essentially custom objects that are exposed in the applications cache and are accessible via their own API.</p>
<p>You can certainly build your own custom objects to store settings but using custom settings is much quicker (again they are stored in the application cache) and do not count against SOQL limits when fetched. You can also use custom settings in formula fields, validation rules, Apex code and the Web Services API.</p>
<p>Custom settings come in two flavors: list and hierarchy. This post will focus on list custom settings which is the simpler of the two to grok. List custom settings allow you to store org-wide static data that is frequently used. For instance, Salesforce.com does not have ISO country codes baked into the platform. At my last company we maintained this list of countries and their ISO codes in a separate custom object. Whenever we needed the data we'd have to query this custom object which brought with it additional overhead pertaining to the SOQL limits. Using a list custom setting you can now store these codes and use them virtually anywhere needed.</p>
<p>When you create a new custom settings the platform creates a custom object in the background for you (notice the API Name field). You then add additional fields to the custom setting in the same manner that you do for custom objects (you are limited to checkbox, currency, date, date/time, email, number, percent, phone, text, text area and URL fields). I found the management interface for custom settings a little confusing at first and got lost a number of times trying to add fields and/or data.</p>
<p><a href="images/plxkqalxtxu2kb0d61vy.png"><img src="images/plxkqalxtxu2kb0d61vy.png" alt="" ></a></p>
<p>After you've setup your custom settings and added your fields, you can select the Manage link on the Custom Settings page to add add/edit/delete values. It's very similar to maintaining other records in Salesforce.com.</p>
<p><a href="images/cdag6oekdz3vfupwwy4e.png"><img src="images/cdag6oekdz3vfupwwy4e.png" alt="" ></a></p>
<p>Once you've finished adding fields and values to your custom settings, you can query it like any other custom object (if you like).</p>
<p><a href="g/content/images/2014/Jun/qat87jadsdh96wkqbcn3.png"><img src="images/qat87jadsdh96wkqbcn3.png" alt="" ></a></p>
<p>Custom settings have their <a href="http://www.salesforce.com/us/developer/docs/apexcode/index.htm" title="Developer Docs">own instance methods</a> to allow easy access. It looks like the getInstance() and getValues() method returns the same object. I typically use the getInstance() method as it makes more sense to me. You access a record by using the value in the Name column (you cannot use the ID or other columns):</p>
{% highlight js %}ISO_Country__c code = ISO_Country__c.getInstance('AFGHANISTAN');
{% endhighlight %}
<p>To return a map of data sets defined for the custom object (all records in the custom object), you would use:</p>
{% highlight js %}Map<string,ISO_Country__c> mapCodes = ISO_Country__c.getAll();
// display the ISO code for Afghanistan
System.debug('ISO Code: '+mapCodes.get('AFGHANISTAN').ISO_Code__c);
{% endhighlight %}
<p>Alternatively you can return the map as a list:</p>
{% highlight js %}List<iso_Country__c> listCodes = ISO_Country__c.getAll().values();
{% endhighlight %}
<p><a href="images/ntfmab1dprn7759zgnwt.png"><img src="images/ntfmab1dprn7759zgnwt.png" alt="" ></a></p>
<p>I put together a quick demo on how to use the ISO Countries custom setting in a Visualforce page for a picklist. <strong>You can <a href="https://jeffdouglas-developer-edition.na5.force.com/examples/CustomSettingsList">run this example</a> on my Developer Site.</strong></p>
<p><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/CustomSettingsList"><img src="images/janik0qdhfaw1mnykgk4.png" alt="" ></a></p>
<p><strong>Apex Controller - CustomSettingsListController</strong></p>
{% highlight js %}public with sharing class CustomSettingsListController {

 public String selectedIso {get;set;}

 public List<selectOption> isoCodes {
  get {
 List<selectOption> options = new List<selectOption>();

 for (ISO_Country__c iso : ISO_Country__c.getAll().values())
  options.add(new SelectOption(iso.ISO_Code__c,iso.Name+' - '+iso.ISO_Code__c));
 return options;

  }
  set;
 }

}
{% endhighlight %}
<p><strong>Visualforce Page - CustomSettingsList</strong></p>
{% highlight js %}<apex:page controller="CustomSettingsListController">
 <apex:sectionHeader title="Custom Settings" subtitle="List Demo"/>

 <apex:form >
  <apex:pageBlock >

   <apex:selectList value="{!selectedIso}" size="1">
   <apex:selectOptions value="{!isoCodes}"/>
   </apex:selectList>

  </apex:pageBlock>
 </apex:form>
</apex:page>
{% endhighlight %}
<p>Note: If you include custom settings in your distributed package you'll need to build in some scripts which populate the settings with data after the package has been installed.</p>

