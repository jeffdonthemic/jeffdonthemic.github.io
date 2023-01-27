---
layout: post
title:  Testing Salesforce.com Controller Extensions
description: One thing that salesforce.com is working on is providing developers with a better testing environment. Salesforce.com requires you to write test cases to deploy your code to production but sometimes the process can be painful. Given the lack of something like jUnit you have to implement your own setup and test procedures. Youll need to create all of your test records and test each scenario to ensure your code performs as expected. Heres a small test class for a controller extension using some te
date: 2010-06-02 12:42:03 +0300
image:  '/images/slugs/testing-salesforce-com-controller-extensions.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p style="clear: both">One thing that salesforce.com is working on is providing developers with a better testing environment. Salesforce.com requires you to write test cases to deploy your code to production but sometimes the process can be painful. Given the lack of something like jUnit you have to implement your own setup and test procedures. You'll need to create all of your test records and test each scenario to ensure your code performs as expected.</p><p style="clear: both">Here's a small test class for a controller extension using some techniques from Jason Ouellette's book <a href="http://www.amazon.com/gp/product/0321647734" target="_blank">Development with the Force.com Platform</a>. BTW... if you don't have a copy of this book, get it! It's invaluable!</p><p style="clear: both">I've sanitized the code for your protection but essentially the controller code involves reassigning objects with a master-detail relationship. I didn't include the actual controller but that's not what is important here. The use case is you have an master record with three detail records and you want to create a new master record and move some of the details records to the new record.</p><p style="clear: both">The test class involves a static initializer, a shared init method and two test methods. The static initializer runs the code to perform tasks such as setting up profiles, creating users, deleting data, etc. This is where you essentially setup your test environment. The init method is called by each test method and sets up the required data for that method plus runs any shared code. Each test method then runs different scenarios to complete your code coverage.</p>
{% highlight js %}@isTest
private class Test_MyControllerExtension {

 static MyController ext;
 static MasterObject__c masterObject;
 static PageReference pref;
 static User testUser;

 static {

  Profile p = [select id from profile where name='Some Profile'];

  testUser = new User(alias = 'u1', email='u1@testorg.com',
 emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
 localesidkey='en_US', profileid = p.Id, country='United States',
 timezonesidkey='America/Los_Angeles', username='u1@testorg.com');

  insert testUser;

 }

 private static void init() {

  masterObject = new MasterObject__c(Name='Test Object 1');
  insert masterObject;

  DetailObject__c d1 = new DetailObject__c(
  Name='Detail 1',Status__c='Open',MasterObject__c=masterObject.Id);
  DetailObject__c d2 = new DetailObject__c(
  Name='Detail 2',Status__c='Closed',MasterObject__c=masterObject.Id);
  DetailObject__c d3 = new DetailObject__c(
  Name='Detail 3',Status__c='Declined',MasterObject__c=masterObject.Id);

  List<DetailObject__c> children = new List<DetailObject__c>();
  children.add(d1);
  children.add(d2);
  children.add(d3);
  insert children;

  pref = Page.MoveRecords;
  pref.getParameters().put('id',masterObject.id);
  Test.setCurrentPage(pref);

  ApexPages.StandardController con = new ApexPages.StandardController(masterObject);
  ext = new MyController(con);

 }

 static testMethod void testMoveOpenOnly() {

  init();

  Test.startTest();

  // choose the owner of the new master object
  ext.testUserId = testUser.Id;  
  // indicate that we want to move the closed children
  ext.moveClosed = true;

  // perform some more assertions

  pref = ext.save();
  System.assertEquals(pref.getUrl(),'/'+ext.newMasterObject.Id);

  // ensure the original master object contains 1 child
  System.assertEquals(1, [select count() from DetailObject__c where MasterObject__c = :masterObject.Id]);
  // ensure the new master object contains 2 children
  System.assertEquals(2, [select count() from DetailObject__c where MasterObject__c = :ext.newMasterObject.id]);

  Test.stopTest();

 }
  
 static testMethod void testDoNotReassignDeclined() {

  init();

  Test.startTest();

  // choose the owner of the newmaster object
  ext.salesRepId = salesRep.Id;   
  // indicate that we do NOT want to move the closed children
  ext.moveClosed = false;

  // perform some more assertions

  pref = ext.save();
  System.assertEquals(pref.getUrl(),'/'+ext.newMasterObject.Id);

  // ensure the original master object contains 2 children
  System.assertEquals(2, [select count() from DetailObject__c where MasterObject__c = :masterObject.Id]);
  // ensure the new master object contains 1 child
  System.assertEquals(1, [select count() from DetailObject__c where MasterObject__c = :ext.newMasterObject.id]);

  Test.stopTest();

 }
  
}
{% endhighlight %}

