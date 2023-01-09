---
layout: post
title:  Apex Deep Clone Controller
description: I wrote the following code at the Admin To Hero App Building Workshop and it was very popular. I think we used the code on 3 or 4 projects that day so I thought Id post it to help everyone out. Essentially it is a Visualforce page and Apex Controller that allows you to do a deep clone of an object and its line items for a master-detail relationship. So I created a Clone with Items custom button on a page layout that invokes the Visualforce page that clones a purchase order header and its line it
date: 2009-11-19 21:29:34 +0300
image:  '/images/slugs/apex-deep-clone-controller.jpg'
tags:   ["2009", "public"]
---
<p>I wrote the following code at the <a href="/2009/11/18/admin-to-hero-app-building-workshop/" target="_blank">Admin To Hero App Building Workshop</a> and it was very popular. I think we used the code on 3 or 4 projects that day so I thought I'd post it to help everyone out.</p>
<p>Essentially it is a Visualforce page and Apex Controller that allows you to do a "deep clone" of an object and it's line items for a master-detail relationship. So I created a "Clone with Items" custom button on a page layout that invokes the Visualforce page that clones a purchase order header and its line items.</p>
<p><strong>PurchaseOrderClone - Visualforce page</strong></p>
{% highlight js %}<apex:page standardController="Purchase_Order__c"
 extensions="PurchaseOrderCloneWithItemsController"
 action="{!cloneWithItems}">
 <apex:pageMessages />
</apex:page>

{% endhighlight %}
<p><strong>PurchaseOrderCloneWithItemsController - Apex controller</strong></p>
{% highlight js %}public class PurchaseOrderCloneWithItemsController {

  //added an instance varaible for the standard controller
  private ApexPages.StandardController controller {get; set;}
 // add the instance for the variables being passed by id on the url
  private Purchase_Order__c po {get;set;}
  // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
  public ID newRecordId {get;set;}

  // initialize the controller
  public PurchaseOrderCloneWithItemsController(ApexPages.StandardController controller) {

  //initialize the stanrdard controller
  this.controller = controller;
  // load the current record
  po = (Purchase_Order__c)controller.getRecord();

  }

  // method called from the VF's action attribute to clone the po
  public PageReference cloneWithItems() {

   // setup the save point for rollback
   Savepoint sp = Database.setSavepoint();
   Purchase_Order__c newPO;

   try {

   //copy the purchase order - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
   po = [select Id, Name, Ship_To__c, PO_Number__c, Supplier__c, Supplier_Contact__c, Date_Needed__c, Status__c, Type_of_Purchase__c, Terms__c, Shipping__c, Discount__c from Purchase_Order__c where id = :po.id];
   newPO = po.clone(false);
   insert newPO;

   // set the id of the new po created for testing
    newRecordId = newPO.id;

   // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
   List<Purchased_Item__c> items = new List<Purchased_Item__c>();
   for (Purchased_Item__c pi : [Select p.Id, p.Unit_Price__c, p.Quantity__c, p.Memo__c, p.Description__c From Purchased_Item__c p where Purchase_Order__c = :po.id]) {
   Purchased_Item__c newPI = pi.clone(false);
   newPI.Purchase_Order__c = newPO.id;
   items.add(newPI);
   }
   insert items;

   } catch (Exception e){
   // roll everything back in case of error
  Database.rollback(sp);
  ApexPages.addMessages(e);
  return null;
   }

  return new PageReference('/'+newPO.id+'/e?retURL=%2F'+newPO.id);
  }

}
{% endhighlight %}
<p><strong>TestPurchaseOrderCloneWithController - Test class</strong></p>
{% highlight js %}@isTest
private class TestPurchaseOrderCloneWithController {

  static testMethod void testPOCloneController() {

  // setup a reference to the page the controller is expecting with the parameters
  PageReference pref = Page.PurchaseOrderClone;
  Test.setCurrentPage(pref);

  // setup a ship to account
  Account shipTo = new Account();
  shipTo.Name = 'PSAV 6FOO';
  shipTo.Type = 'Supplier';
  insert shipTo;

  // create new po record
  Purchase_Order__c po = new Purchase_Order__c();
  po.Date_Needed__c = Date.newInstance(2020,01,01);
  po.Ship_To__c = shipTo.id;
  insert po;

  // create a line item for the po
  Purchased_Item__c pi1 = new Purchased_Item__c();
  pi1.Description__c = 'My item';
  pi1.Purchase_Order__c = po.id;
  pi1.Quantity__c = 1;
  pi1.Unit_Price__c = 10;
  insert pi1;

  // Construct the standard controller
  ApexPages.StandardController con = new ApexPages.StandardController(po);

  // create the controller
  PurchaseOrderCloneWithItemsController ext = new PurchaseOrderCloneWithItemsController(con);

  // Switch to test context
  Test.startTest();

  // call the cloneWithItems method
  PageReference ref = ext.cloneWithItems();
  // create the matching page reference
  PageReference redir = new PageReference('/'+ext.newRecordId+'/e?retURL=%2F'+ext.newRecordId);

  // make sure the user is sent to the correct url
  System.assertEquals(ref.getUrl(),redir.getUrl());

  // check that the new po was created successfully
  Purchase_Order__c newPO = [select id from Purchase_Order__c where id = :ext.newRecordId];
  System.assertNotEquals(newPO, null);
  // check that the line item was created
  List<Purchased_Item__c> newItems = [Select p.Id From Purchased_Item__c p where Purchase_Order__c = :newPO.id];
  System.assertEquals(newItems.size(),1);

  // Switch back to runtime context
  Test.stopTest();

  }

}

{% endhighlight %}

