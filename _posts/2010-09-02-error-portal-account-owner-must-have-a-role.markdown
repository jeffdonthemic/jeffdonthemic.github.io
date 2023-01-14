---
layout: post
title:  Error - Portal account owner must have a role??
description: I wrote the following test class for a PRM deployment and received this crazy error when running the test-  System.DmlException- Insert failed. First exception on row 0; first error- UNKNOWN_EXCEPTION, portal account owner must have a role- .id; user.EmailEncodingKey = ISO-8859-1; user.LanguageLocaleKey = en_US; user.TimeZoneSidKey = America/New_York; user.LocaleSidKey = en_US; user.FirstName = first; user.LastName = last; user.Username = test@appirio.com;  user.CommunityNickname = testUser123; 
date: 2010-09-02 13:05:08 +0300
image:  '/images/slugs/error-portal-account-owner-must-have-a-role.jpg'
tags:   ["salesforce", "apex"]
---
<p>I wrote the following test class for a PRM deployment and received this crazy error when running the test:</p>
<p><em><strong>System.DmlException: Insert failed. First exception on row 0; first error: UNKNOWN_EXCEPTION, portal account owner must have a role: []</strong></em></p>
<p>I searched the message boards but couldn't find any reference to the real culprit. My original thought was that the user being created was causing an error somehow. However, <strong>the real problem was that <em>my</em> user was not assigned a role</strong>. Hopefully this post saves someone some time tracking down the solution.</p></p>
{% highlight js %} Account a = new Account(Name='Test Account Name');
 insert a;

 Contact c = new Contact(LastName = 'Contact Last Name', AccountId = a.id);
 insert c;

 User user = new User();
 user.ProfileID = [Select Id From Profile Where Name='Some Profile'].id;
 user.EmailEncodingKey = 'ISO-8859-1';
 user.LanguageLocaleKey = 'en_US';
 user.TimeZoneSidKey = 'America/New_York';
 user.LocaleSidKey = 'en_US';
 user.FirstName = 'first';
 user.LastName = 'last';
 user.Username = 'test@appirio.com';  
 user.CommunityNickname = 'testUser123';
 user.Alias = 't1';
 user.Email = 'no@email.com';
 user.IsActive = true;
 user.ContactId = c.Id;
 
 insert user;

 System.RunAs(user) {
  // do all of my tests
 }
{% endhighlight %}
<p>You will also see this same error (for the same reason) when trying to enable a contact as a partner or customer portal user.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327935/portal-user-error_qdinl7.png" alt="" ></p>

