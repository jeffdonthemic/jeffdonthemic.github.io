---
layout: post
title:  Using Saleforce DML statements or DML database methods?
description: Salesforce allows you to perform database transactions (insert, update, delete, etc.) using either DML statments or DML database methods. While they perfrom roughly the same functionality (with a few exceptions), DML database methods provide a little more granular control when bulk processing exceptions occur. The Salesforce documentation  is good and extremely detailed but these two approaches overlap in functinality and are sometimes confusing. Ive tried to boil the docs down and point out whe
date: 2009-11-02 19:01:52 +0300
image:  '/images/slugs/using-saleforce-dml-statements-or-dml-database-methods.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>Salesforce allows you to perform database transactions (insert, update, delete, etc.) using either DML statments or DML database methods. While they perfrom roughly the same functionality (with a few exceptions), DML database methods provide a little more granular control when bulk processing exceptions occur.</p>
<p>The <a href="http://www.salesforce.com/us/developer/docs/apexcode/index.htm" target="_blank">Salesforce documentation</a> is good and extremely detailed but these two approaches overlap in functinality and are sometimes confusing. I've tried to boil the docs down and point out where DML statements and DML database methods are different and yet the same. The choices you make for your code is mostly based upon personal preference but may be dictated depending on the transactions you are performing.</p>
<p>The main difference is how bulk exceptions are processed:</p>
<ul>
	<li><strong>DML statements</strong> - when an exception is thrown during bulk DML processing, processing stops immediately and jumps to your catch block.</li>
	<li><strong>DML database methods</strong> - allows partial success of bulk DML operations. Records that fail processing can be inspected and possibly resubmitted if necessary.</li>
</ul>
Here is an Apex example of inserting records using DML database methods. Notice the SaveResult object returned from the insert function and how it is processed outside of the catch block.
{% highlight js %}List<Contact> contacts = new List<Contact>();

for (Integer i = 0; i < 5; i++) {
 contacts.add(new Contact(FirstName='First '+i,LastName='Last '+i,Email='my@email.com'));
}

try {

 Database.SaveResult[] results = Database.insert(contacts,false);
 if (results != null){
 for (Database.SaveResult result : results) {
  if (!result.isSuccess()) {
  Database.Error[] errs = result.getErrors();
  for(Database.Error err : errs)
 System.debug(err.getStatusCode() + ' - ' + err.getMessage());
  }
  }
 }

} catch (Exception e) {
 System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
}

{% endhighlight %}
<p>DML database methods may also contain two optional parameters:</p>
<ol>
	<li><strong>opt_allOrNone</strong> - a Boolean that indicates if the operation should allow partial successes. If false, failing records will not cause subsequent records to fail as well.</li>
	<li><strong>DMLOptions</strong> - an object that provides extra information that is used during the transaction such as string truncations behavior, assignment rules, email processing and locale information.</li>
</ol>
A couple of methods only support one approach or the other:
<ul>
	<li><strong>convertLead</strong> - DML database method only</li>
	<li><strong>merge</strong> - DML statement only</li>
</ul>
<h2>Insert Method</h2>
<p>DML Statement Syntax</p>
{% highlight js %}insert sObject
insert sObject[]
{% endhighlight %}
<p>DML Database Method Syntax</p>
{% highlight js %}SaveResult Database.insert(sObject recordToInsert, Boolean opt_allOrNone | database.DMLOptions
opt_DMLOptions)
SaveResult[] Database.insert(sObject[] recordsToInsert, Boolean opt_allOrNone | database.DMLOptions
opt_DMLOptions)
{% endhighlight %}
<h2>Update Method</h2>
DML Statement Syntax
{% highlight js %}update sObject
update sObject[]
{% endhighlight %}
<p>DML Database Method Syntax</p>
{% highlight js %}UpdateResult Update(sObject recordToUpdate, Boolean opt_allOrNone | database.DMLOptions opt_DMLOptions)
UpdateResult[] Update(sObject[] recordsToUpdate[], Boolean opt_allOrNone | database.DMLOptions
opt_DMLOptions)
{% endhighlight %}
<h2>Upsert Method</h2>
Upsert either creates new sObject records or updates existing sObject records within a single statement, and can also utilize a custom field to determine the presence of existing objects. The custom field must be created with the "External Id" attribute. If the opt_external_id is not specified, then the record id of the sObject is used by default.
<p>DML Statement Syntax</p>
{% highlight js %}upsert sObject opt_external_id
upsert sObject[] opt_external_id
{% endhighlight %}
<p>DML Database Method Syntax</p>
{% highlight js %}UpsertResult Database.Upsert(sObject recordToUpsert, Schema.SObjectField External_ID_Field, Boolean opt_allOrNone)
UpsertResult[] Database.Upsert(sObject[] recordsToUpsert, Schema.SObjectField External_ID_Field, Boolean opt_allOrNone)
{% endhighlight %}
<h2>Delete Method</h2>
<p>DML Statement Syntax</p>
{% highlight js %}delete sObject
delete id
{% endhighlight %}
<p>DML Database Method Syntax</p>
{% highlight js %}DeleteResult Database.Delete((sObject recordToDelete | RecordID ID), Boolean opt_allOrNone)
DeleteResult[] Database. Delete((sObject[] recordsToDelete | RecordIDs LIST:IDs{}), Boolean opt_allOrNone)
{% endhighlight %}
<h2>Undelete Method</h2>
<p>Restores one or more existing sObject records from the Recycle Bin.</p>
<p>DML Statement Syntax</p>
{% highlight js %}undelete sObject
undelete id
undelete sObject[]
undelete LIST:id[]
{% endhighlight %}
<p>DML Database Method Syntax</p>
{% highlight js %}UndeleteResult Database.Undelete((sObject recordToUndelete | RecordID ID), Boolean opt_allOrNone)
UndeleteResult[] Database.Undelete((sObject[] recordsToUndelete | RecordIDs LIST:IDs{}), Boolean
opt_allOrNone)
{% endhighlight %}
<h2>Merge Method (DML statement only)</h2>
<p>Merges up to three records of the same sObject type into one of the records, deleting the others, and re-parenting any related records.</p>
{% highlight js %}merge sObject sObject
merge sObject sObject[]
merge sObject ID
merge sObject ID[]
{% endhighlight %}
<h2>ConvertLead Method (DML database method only)</h2>
<p>Converts a lead into an account and contact, as well as an opportunity (optional).</p>
{% highlight js %}LeadConvertResult Database.convertLead(LeadConvert leadToConvert, Boolean opt_allOrNone)
LeadConvertResult[] Database.convertLead(LeadConvert[] leadsToConvert, Boolean opt_allOrNone)
{% endhighlight %}
<h2>With or Without Sharing</h2>
<p>Most DML operations run in system context. This ignores the running user's profile permissions, sharing rules, field level security, org-wide defaults and their position in the role hierarchy. If you want to enforce sharing rules for the running user, use the "with sharing" keywords with the class definition.</p>
<h2>Setup Object</h2>
<p>Some sObjects (called setup objects) will not let you perform DML operations with other sObjects in the same transaction. For example, if you try to insert a new user and a new contact in the same transaction, you'll receive the following exception: "<strong>MIXED_DML_OPERATION, DML operation on setup object is not permitted after you have updated a non-setup object</strong>". There is a potential workaround <a href="http://community.salesforce.com/sforce/board/message?board.id=apex&thread.id=5745" target="_blank">posted here</a> but you can also try to use a @future method to perform the processing of the second sObject.</p>
<ul>
	<li>Group3</li>
	<li>GroupMember</li>
	<li>QueueSObject</li>
	<li>User4</li>
	<li>UserRole</li>
	<li>UserTerritory</li>
	<li>Territory</li>
</ul>
<h2>Not DML Supported Objects</h2>
<p>This catches people once in awhile, but the following sObjects do not support <em>any type</em> of DML operations:</p>
<ul>
	<li>AccountTerritoryAssignmentRule</li>
	<li>AccountTerritoryAssignmentRuleItem</li>
	<li>ApexComponent</li>
	<li>ApexPage</li>
	<li>BusinessHours</li>
	<li>BusinessProcess</li>
	<li>CategoryNode</li>
	<li>CurrencyType</li>
	<li>DatedConversionRate</li>
	<li>ProcessInstance</li>
	<li>Profile</li>
	<li>RecordType</li>
	<li>SelfServiceUser</li>
	<li>StaticResource</li>
	<li>UserAccountTeamMember</li>
	<li>UserTerritory</li>
	<li>WebLink</li>
</ul>
