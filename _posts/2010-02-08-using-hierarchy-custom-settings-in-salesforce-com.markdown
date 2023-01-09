---
layout: post
title:  Using Hierarchy Custom Settings in Salesforce.com
description: Last month I posted on the new List Custom Settings feature released in Winter ‘10. Ill finally round out the topic with the other flavor of custom settings- Hierarchy. In Winter ‘10, Salesforce.com introduced Custom Settings which allow you to store custom data sets and associate them on an org-wide, profile or user basis. Custom settings are essentially custom objects that are exposed in the applications cache and are accessible via their own API. Using custom settings is much easier than roll
date: 2010-02-08 10:00:51 +0300
image:  '/images/slugs/using-hierarchy-custom-settings-in-salesforce-com.jpg'
tags:   ["2010", "public"]
---
<p>Last month <a href="/2010/01/07/using-list-custom-settings-in-salesforce-com/" target="_blank">I posted on the new List Custom Settings feature</a> released in Winter '10. I'll finally round out the topic with the other flavor of custom settings: Hierarchy.</p>
<p>In Winter '10, Salesforce.com introduced Custom Settings which allow you to store custom data sets and associate them on an org-wide, profile or user basis. Custom settings are essentially custom objects that are exposed in the applications cache and are accessible via their own API. Using custom settings is much easier than rolling your own solution as they are much faster and easier to access (cached at the application level and accessible via their own interface) and do not count against SOQL limits.</p>
<p>Hierarchy settings allow you to personalize your application for different profiles and/or users. The interface has baked-in logic that drills down into the org, profile, and user level (based upon the current user) and returns the most specific or lowest value in the hierarchy. I've found hierarchy custom settings to be extremely useful for those "one off" occasions. Let's suppose you want to authorize your sales teams to be able to offer a specific discount to customers. You might set up an org-wide custom setting of a 1% discount that everyone is authorized to offer. Now of course you have a set of high-producing sales people that are in their own profile and are able to offer a 5% discount. However (and here is the "one off"), there is that one sales person in that same profile that has lobbied the VP of Sales to be able to offer a 15% discount. With hierarchy custom settings you can accommodate all of these scenarios!!</p>
<p>As with list custom settings, when you create a new hierarchy custom setting, the platform creates a custom object in the background for you (notice the API Name field). You then add additional fields to the custom setting in the same manner that you do for custom objects (you are limited to checkbox, currency, date, date/time, email, number, percent, phone, text, text area and URL fields). I found the management interface for custom settings a little confusing at first and got lost a number of times trying to add fields and/or data.</p>
<p><img src="images/hierarchy-1_vjh80h.png" alt="" ></p>
<p>After you’ve set up your custom settings and added your fields, you can select the Manage link on the custom settings page to add add/edit/delete values for the entire org, a specific profile or individual users. The image below shows the 1% discount for the entire org and then specific settings for the Standard Employees profile and a specific user.</p>
<p><img src="images/hierarchy-2_weq0ug.png" alt="" ></p>
<p>Selecting the View link for the profile displays the settings that apply to users that are part of the "Standard Employees" profile.</p>
<p><img src="images/hierarchy-3_qjd7jk.png" alt="" ></p>
<p>Selecting the View link for the "one off" user, displays the settings that are applicable for that user only.</p>
<p><img src="images/hierarchy-8_kry2b9.png" alt="" ></p>
<h3>Accessing Custom Settings Programmatically</h3>
<p>The cool thing is now you can programmatically access these custom settings based upon the running user and return their most appropriate value (org-wide, profile or user) in formula fields, validation rules, Apex and the Force.com Web Services API with the following interface. Be sure to <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_custom_settings.htm" target="_blank">check out the custom settings docs</a> for more detailed usage.</p>
<p><img src="images/hierarchy-7_t5siq0.png" alt="" ></p>
<p>You can <strong><em>only</em></strong> access hierarchy custom settings in formula field and validation rules. Here is the generic syntax:</p>
{% highlight js %}{!$Setup.CustomSettingName__c.CustomFieldName__c}
{% endhighlight %}
<p><img src="images/hierarchy-6_xtigsp.png" alt="" ></p>
<p>For Apex code there are a number of <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_custom_settings.htm" target="_blank">good examples in the docs</a> so make sure you take a look at them.</p>

