---
layout: post
title:  Enhancing the Lead Conversion Process in Salesforce.com
description: During the Salesforce.com lead conversion process, you can create an account, contact and opportunity for the lead that is being converted. The process is pretty straightforward and Salesforce.com provides some tools for customizing it- 1. Salesforce.com allows you to automatically map standard and custom lead   fields to account, contact, and opportunity fields. 2. Apex triggers are fired and universally required custom fields and   validation rules are enforced only if validation and triggers 
date: 2009-02-13 21:34:34 +0300
image:  '/images/slugs/enhancing-the-lead-convert-process-in-salesforce.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>During the Salesforce.com lead conversion process, you can create an account, contact and opportunity for the lead that is being converted. The process is pretty straightforward and Salesforce.com provides some tools for customizing it:</p>
<ol>
 <li>Salesforce.com allows you to automatically map standard and custom lead fields to account, contact, and opportunity fields.</li>
 <li><span>Apex</span> triggers are fired and universally required custom fields and validation rules are enforced only if <strong>validation and triggers for lead convert</strong> are enabled in your organization.</li>
</ol>
However, there may be some instances when a use case requires more complex processing. For instance:
<ol>
 <li>Whenever a new contact is created from a lead, a custom object is created that is associated to the contact.</li>
 <li>Whenever a new account is created, a callout is made to an external webservice.</li>
 <li>Whenever a new opportunity is created, a number of standard products are added to the opportunity.</li>
</ol>
Here is a sample trigger that, for simplicity, does not operate for bulk inserts but gives you a good head start. The documentation on the conversion process is <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml_convertLead.htm" target="_blank">located here</a>.
{% highlight js %}trigger LeadConvert on Lead (after update) {
 
 // no bulk processing; will only run from the UI
 if (Trigger.new.size() == 1) {

  if (Trigger.old[0].isConverted == false && Trigger.new[0].isConverted == true) {

 // if a new account was created
 if (Trigger.new[0].ConvertedAccountId != null) {

  // update the converted account with some text from the lead
  Account a = [Select a.Id, a.Description From Account a Where a.Id = :Trigger.new[0].ConvertedAccountId];
  a.Description = Trigger.new[0].Name;
  update a;

 }   

 // if a new contact was created
 if (Trigger.new[0].ConvertedContactId != null) {

  // update the converted contact with some text from the lead
  Contact c = [Select c.Id, c.Description, c.Name From Contact c Where c.Id = :Trigger.new[0].ConvertedContactId];
  c.Description = Trigger.new[0].Name;
  update c;

  // insert a custom object associated with the contact
  MyObject obj = new MyObject();
  obj.Name = c.Name;
  obj.contact__c = Trigger.new[0].ConvertedContactId;
  insert obj;

 }

 // if a new opportunity was created
 if (Trigger.new[0].ConvertedOpportunityId != null) {

  // update the converted opportunity with some text from the lead
  Opportunity opp = [Select o.Id, o.Description from Opportunity o Where o.Id = :Trigger.new[0].ConvertedOpportunityId];
  opp.Description = Trigger.new[0].Name;
  update opp;

  // add an opportunity line item
  OpportunityLineItem oli = new OpportunityLineItem();
  oli.OpportunityId = opp.Id;
  oli.Quantity = 1;
  oli.TotalPrice = 100.00;
  oli.PricebookEntryId = [Select p.Id From PricebookEntry p Where CurrencyIsoCode = 'USD' And IsActive = true limit 1].Id;
  insert oli;

 }   

  }

 } 

}

{% endhighlight %}

