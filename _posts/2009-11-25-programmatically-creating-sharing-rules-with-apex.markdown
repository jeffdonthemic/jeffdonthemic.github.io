---
layout: post
title:  Programmatically Creating Sharing Rules with Apex
description: Heres a small Apex Trigger that demonstrates how to programmatically create sharing rules for objects with a private sharing model. It came in handy on a project about a year ago so I thought Id post it. So the scenario is that the object has a private sharing model (Contacts in this case) so that only the record owner and users higher in the role hierarchy have access to it. I added a checkbox to the Contact object called Make Public that when set to TRUE, creates a sharing record for a specifi
date: 2009-11-25 11:00:19 +0300
image:  '/images/slugs/programmatically-creating-sharing-rules-with-apex.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>Here's a small Apex Trigger that demonstrates how to programmatically create sharing rules for objects with a private sharing model. It came in handy on a project about a year ago so I thought I'd post it.</p>
<p>So the scenario is that the object has a private sharing model (Contacts in this case) so that only the record owner and users higher in the role hierarchy have access to it. I added a checkbox to the Contact object called "Make Public" that when set to TRUE, creates a sharing record for a specific group (e.g., All Internal Users). When set to FALSE, it deletes all manual sharing rules for the record. You can modify this to add multiple groups or even make it operate on the reverse (public by default and then remove the sharing rules).</p>
<p><strong>ContactMakePublicTrigger</strong></p>
{% highlight js %}trigger ContactMakePublicTrigger on Contact (after insert, after update) {

 // get the id for the group for everyone in the org
 ID groupId = [select id from Group where Type = 'Organization'].id;

 // inserting new records
 if (Trigger.isInsert) {

  List<ContactShare> sharesToCreate = new List<ContactShare>();

  for (Contact contact : Trigger.new) {
 if (contact.Make_Public__c == true) {

  // create the new share for group
  ContactShare cs = new ContactShare();
  cs.ContactAccessLevel = 'Edit';
  cs.ContactId = contact.Id;
  cs.UserOrGroupId = groupId;
  sharesToCreate.add(cs);

 }
  }

  // do the DML to create shares
  if (!sharesToCreate.isEmpty())
 insert sharesToCreate;

 // updating existing records
 } else if (Trigger.isUpdate) {

  List<ContactShare> sharesToCreate = new List<ContactShare>();
  List<ID> shareIdsToDelete = new List<ID>();

  for (Contact contact : Trigger.new) {

 // if the record was public but is now private -- delete the existing share
 if (Trigger.oldMap.get(contact.id).Make_Public__c == true &amp;&amp; contact.Make_Public__c == false) {
  shareIdsToDelete.add(contact.id);

 // if the record was private but now is public -- create the new share for the group
 } else if (Trigger.oldMap.get(contact.id).Make_Public__c == false &amp;&amp; contact.Make_Public__c == true) {

  // create the new share with read/write access
  ContactShare cs = new ContactShare();
  cs.ContactAccessLevel = 'Edit';
  cs.ContactId = contact.Id;
  cs.UserOrGroupId = groupId;
  sharesToCreate.add(cs);

 }

  }

  // do the DML to delete shares
  if (!shareIdsToDelete.isEmpty())
 delete [select id from ContactShare where ContactId IN :shareIdsToDelete and RowCause = 'Manual'];

  // do the DML to create shares
  if (!sharesToCreate.isEmpty())
 insert sharesToCreate;

 }

}
{% endhighlight %}
<p><strong> TestContactMakePublicTrigger</strong></p>
{% highlight js %}@isTest
private class TestContactMakePublicTrigger {

  // test that newly inserted records marked as pubic=true have corresponding shares created
  static testMethod void testAddShares() {

  Set<ID> ids = new Set<ID>();
  List<Contact> contacts = new List<Contact>();

  for (Integer i=0;i<50;i++)
 contacts.add(new Contact(FirstName='First ',LastName='Name '+i,
  Email='email'+i+'@email.com',Make_Public__c=true));

  insert contacts;

  // get a set of all new created ids
  for (Contact c : contacts)
 ids.add(c.id);

  // assert that 50 shares were created
  List<ContactShare> shares = [select id from ContactShare where 
 ContactId IN :ids and RowCause = 'Manual'];
  System.assertEquals(shares.size(),50);

  }

  // insert records and switch them from public = true to public = false
  static testMethod void testUpdateContacts() {

  Set<ID> ids = new Set<ID>();
  List<Contact> contacts = new List<Contact>();

  for (Integer i=0;i<50;i++)
 contacts.add(new Contact(FirstName='First ',LastName='Name '+i,
  Email='email'+i+'@email.com',Make_Public__c=false));

  insert contacts;

  for (Contact c : contacts)
 ids.add(c.id);

  update contacts;

  // assert that 0 shares exist
  List<ContactShare> shares = [select id from ContactShare where 
 ContactId IN :ids and RowCause = 'Manual'];
  System.assertEquals(shares.size(),0);

  for (Contact c : contacts)
 c.Make_Public__c = true;

  update contacts;

  // assert that 50 shares were created
  shares = [select id from ContactShare where ContactId IN :ids and RowCause = 'Manual'];
  System.assertEquals(shares.size(),50);

  for (Contact c : contacts)
 c.Make_Public__c = false;

  update contacts;

  // assert that 0 shares exist
  shares = [select id from ContactShare where ContactId IN :ids and RowCause = 'Manual'];
  System.assertEquals(shares.size(),0);

  }
}
{% endhighlight %}
<p>One thing to remember. When transferring accounts and their related data, all existing sharing rules will be removed. Any relevant sharing rules are then applied to the records based upon the new owners. You may need to manually share these accounts and opportunities to grant access to certain users and/or groups.</p>

