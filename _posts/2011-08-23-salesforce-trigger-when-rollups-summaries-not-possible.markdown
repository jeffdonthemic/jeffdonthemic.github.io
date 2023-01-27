---
layout: post
title:  Salesforce Trigger when Rollups Summaries Not Possible
description: Master-Details relationships in Force.com are very handy but dont fit every scenario. For instance, its not possible to implement a rollup summary on formula field or text fields. Heres a small trigger that you can use for a starter for these types of situations. The code for each class is available at GitHub  for your forking pleasure. So heres the (not very useful) use case. Sales Order is the Master object which can have multiple Sales Order Items (detail object). The Sales Order Item has a 
date: 2011-08-23 10:15:31 +0300
image:  '/images/slugs/salesforce-trigger-when-rollups-summaries-not-possible.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p><a href="http://www.salesforce.com/us/developer/docs/api/Content/relationships_among_objects.htm">Master-Details relationships</a> in Force.com are very handy but don't fit every scenario. For instance, it's not possible to implement a rollup summary on formula field or text fields. Here's a small trigger that you can use for a starter for these types of situations. The code for each class is available at <a href="https://github.com/jeffdonthemic/Blog-Sample-Code">GitHub</a> for your forking pleasure.</p>
<p>So here's the (not very useful) use case. Sales Order is the Master object which can have multiple Sales Order Items (detail object). The Sales Order Item has a "primary" Boolean field and a "purchased country" field. Each time Sales Order Items are inserted or updated, if the Sales Order Item is marked as "primary" then the value of "purchased country" is written into the "primary country" field on the Sales Order. I'm assuming that there can only be one Sales Order Item per Sales Order that is marked as primary.Essentially this is just a quick reference on the Sales Order to see which country is primary on any of the multiple Sales Order Items. Not very useful but illustrative.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327774/sales-order-item_rpyrx4.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327774/sales-order-item_rpyrx4.png" alt="" title="sales-order-item" width="500" class="aligncenter size-full wp-image-4121" /></a></p>
<p>The code is broken down into a Trigger and an Apex "handler" class that implements the actual functionality. It's <a href="/2010/10/21/force-com-programming-best-practices/">best practice</a> to only haveone trigger for each object and to avoid complex logic in triggers. To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic. See <a href="http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx">Mike Leachs excellent trigger template</a> for more info.</p>
<p><strong>SalesOrderItemTrigger</strong> (<a href="https://github.com/jeffdonthemic/Blog-Sample-Code/blob/master/salesforce/src/triggers/SalesOrderItemTrigger.trigger">source on GitHub</a>) -Implements trigger functionality for Sales Order Items. Delegates responsibility to SalesOrderItemTriggerHandler.</p>
{% highlight js %}trigger SalesOrderItemTrigger on Sales_Order_Item__c (after insert, after update) {

 SalesOrderItemTriggerHandler handler = new SalesOrderItemTriggerHandler();
  
 if(Trigger.isInsert && Trigger.isAfter) {
  handler.OnAfterInsert(Trigger.new);
  
 } else if(Trigger.isUpdate && Trigger.isAfter) { 
  handler.OnAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
  
 }

}
{% endhighlight %}
<p><strong>SalesOrderItemTriggerHandler</strong> (<a href="https://github.com/jeffdonthemic/Blog-Sample-Code/blob/master/salesforce/src/classes/SalesOrderItemTriggerHandler.cls">source on GitHub</a>) -Implements the functionality for the sales order item trigger after insert and after update. Looks at each sales order item and if it is marked as primary_item__c then moves the primary_country__c value from the sales order item to the associated sales order's primary_country__c field.</p>
{% highlight js %}public with sharing class SalesOrderItemTriggerHandler {

 // update the primary country when new records are inserted from trigger
 public void OnAfterInsert(List<Sales_Order_Item__c> newRecords){
  updatePrimaryCountry(newRecords); 
 }
 
 // update the primary country when records are updated from trigger 
 public void OnAfterUpdate(List<Sales_Order_Item__c> oldRecords, 
 List<Sales_Order_Item__c> updatedRecords, Map<ID, Sales_Order_Item__c> oldMap, 
 Map<ID, Sales_Order_Item__c> newMap){
  updatePrimaryCountry(updatedRecords); 
 }
 
 // updates the sales order with the primary purchased country for the item
 private void updatePrimaryCountry(List<Sales_Order_Item__c> newRecords) {
  
  // create a new map to hold the sales order id / country values
  Map<ID,String> salesOrderCountryMap = new Map<ID,String>();
  
  // if an item is marked as primary, add the purchased country
  // to the map where the sales order id is the key 
  for (Sales_Order_Item__c soi : newRecords) {
 if (soi.Primary_Item__c)
  salesOrderCountryMap.put(soi.Sales_Order__c,soi.Purchased_Country__c);
  } 
  
  // query for the sale orders in the context to update
  List<Sales_Order__c> orders = [select id, Primary_Country__c from Sales_Order__c 
 where id IN :salesOrderCountryMap.keyset()];
  
  // add the primary country to the sales order. find it in the map
  // using the sales order's id as the key
  for (Sales_Order__c so : orders)
 so.Primary_Country__c = salesOrderCountryMap.get(so.id);
  
  // commit the records 
  update orders;
  
 }

}
{% endhighlight %}
<p><strong>Test_SalesOrderItemTriggerHandler</strong> (<a href="https://github.com/jeffdonthemic/Blog-Sample-Code/blob/master/salesforce/src/classes/Test_SalesOrderItemTriggerHandler.cls">source on GitHub</a>) -Test class for SalesOrderItemTrigger and SalesOrderItemTriggerHandler. Achieves 100% code coverage.</p>
{% highlight js %}@isTest
private class Test_SalesOrderItemTriggerHandler {

 private static Sales_Order__c so1;
 private static Sales_Order__c so2;

 // set up our data for each test method
 static {
  
  Contact c = new Contact(firstname='test',lastname='test',email='no@email.com');
  insert c;
  
  so1 = new Sales_Order__c(name='test1',Delivery_Name__c=c.id);
  so2 = new Sales_Order__c(name='test2',Delivery_Name__c=c.id);
  
  insert new List<Sales_Order__c>{so1,so2};
  
 }

 static testMethod void testNewRecords() {
 
  Sales_Order_Item__c soi1 = new Sales_Order_Item__c();
  soi1.Sales_Order__c = so1.id;
  soi1.Quantity__c = 1;
  soi1.Description__c = 'test';
  soi1.Purchased_Country__c = 'Germany';
 
  Sales_Order_Item__c soi2 = new Sales_Order_Item__c();
  soi2.Sales_Order__c = so1.id;
  soi2.Quantity__c = 1;
  soi2.Description__c = 'test';
  soi2.Purchased_Country__c = 'France';
  soi2.Primary_Item__c = true;
  
  Sales_Order_Item__c soi3 = new Sales_Order_Item__c();
  soi3.Sales_Order__c = so2.id;
  soi3.Quantity__c = 1;
  soi3.Description__c = 'test';
  soi3.Purchased_Country__c = 'Germany';
  soi3.Primary_Item__c = true;
 
  Sales_Order_Item__c soi4 = new Sales_Order_Item__c();
  soi4.Sales_Order__c = so2.id;
  soi4.Quantity__c = 1;
  soi4.Description__c = 'test';
  soi4.Purchased_Country__c = 'Germany';
  
  Sales_Order_Item__c soi5 = new Sales_Order_Item__c();
  soi5.Sales_Order__c = so2.id;
  soi5.Quantity__c = 1;
  soi5.Description__c = 'test';
  soi5.Purchased_Country__c = 'Italy';
  
  insert new List<Sales_Order_Item__c>{soi1,soi2,soi3,soi4,soi5}; 
 
  System.assertEquals(2,[select count() from Sales_Order_Item__c where Sales_Order__c = :so1.id]);
  System.assertEquals(3,[select count() from Sales_Order_Item__c where Sales_Order__c = :so2.id]); 
  
  System.assertEquals('France',[select primary_country__c from Sales_Order__c where id = :so1.id].primary_country__c);
  System.assertEquals('Germany',[select primary_country__c from Sales_Order__c where id = :so2.id].primary_country__c);
 
 }
 
 static testMethod void testUpdatedRecords() {
  
  Sales_Order_Item__c soi1 = new Sales_Order_Item__c();
  soi1.Sales_Order__c = so1.id;
  soi1.Quantity__c = 1;
  soi1.Description__c = 'test';
  soi1.Purchased_Country__c = 'Germany';
 
  Sales_Order_Item__c soi2 = new Sales_Order_Item__c();
  soi2.Sales_Order__c = so1.id;
  soi2.Quantity__c = 1;
  soi2.Description__c = 'test';
  soi2.Purchased_Country__c = 'France';
  soi2.Primary_Item__c = true;
  
  insert new List<Sales_Order_Item__c>{soi1,soi2}; 
  
  // assert that the country = France
  System.assertEquals('France',[select primary_country__c from Sales_Order__c where id = :so1.id].primary_country__c);
  
  List<Sales_Order_Item__c> items = [select id, purchased_country__c from Sales_Order_Item__c 
 where Sales_Order__c = :so1.id and primary_item__c = true];
  // change the primary country on the sales order item. should trigger update
  items.get(0).purchased_country__c = 'Denmark';
  
  update items;
  // assert that the country was successfully changed to Denmark
  System.assertEquals('Denmark',[select primary_country__c from Sales_Order__c where id = :so1.id].primary_country__c);
 
 }
 
}
{% endhighlight %}

