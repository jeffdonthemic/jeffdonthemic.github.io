---
layout: post
title:  Roll-Up Summary Fields With Lookup Relationships – Part 2
description: In the first part of this post I outlined the issues involved with creating a trigger to do roll-up summaries with a lookup relationship. To solve the problem I did what you should always try to do first- let the Force.com platform do the heavy lifting for you. Dont try to code around the platform when the declarative interface will do the trick 99% of the time. Youll be amazed with the things you can do with the platform when you let it. The rule of thumb is to use the point-n-click Builder fir
date: 2009-07-31 22:27:50 +0300
image:  '/images/slugs/roll-up-summary-fields-with-lookup-relationships-part-2.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p>In the <a href="/2009/07/30/roll-up-summary-fields-with-lookup-relationships-part-1/" target="_blank">first part of this post</a> I outlined the issues involved with creating a trigger to do roll-up summaries with a lookup relationship. To solve the problem I did what you should always try to do first: let the Force.com platform do the heavy lifting for you. Don't try to code around the platform when the declarative interface will do the trick 99% of the time. You'll be amazed with the things you can do with the platform when you let it. The rule of thumb is to use the point-n-click Builder first and write code only as a last resort.</p>
<p>So to solve my problem I added another custom object called Shipment Item and created a Master-Detail(Shipment) field that would automatically provide the roll-up summaries. However, since users only interact with the Inventory Items on the shipment they never actually see or use this Shipment Items so there's really no interaction with them; it's simply for the roll-up summaries. I needed a way to allow users to manage the Inventory Items on the shipment but in the background add/move/remove Shipment Items to keep the number of records in synch with the Inventory Items. Here is the trigger that I wrote for the Inventory Items to implement this functionality:</p>
<p><strong>Trigger ShipmentItemProcess.cls</strong></p>
{% highlight js %}/**************************************************************************************
* Keeps inventory items and shipment items in sync. If an inventory item is on a
* shipment, then it ensures that there is a corresponding shipment item record. When
* an inventory item is removed from a shipment, it deletes the shipment item record.
**************************************************************************************/

trigger ShipmentItemProcess on Inventory_Item__c (after update, after insert) {

 if (Trigger.isUpdate) {

  List<inventory_Item__c> invItemsToInsert = new List<inventory_Item__c>();
  Map<id,ID> mapInvItemShipment = new Map<id,ID>();
  Set<id> invItemIdsToUpdate = new Set<id>();
  Set<id> invItemIdsToDelete = new Set<id>();

  // figure out which ones need to be inserted, updated or deleted
  for (Integer i=0;i<trigger.new.size();i++) {

   // if the old is null and the new is NOT null, they are assigning to a shipment - INSERT RECORD
   if (Trigger.old[i].Shipment__c == null & Trigger.new[i].Shipment__c != null) {
    invItemsToInsert.add(Trigger.new[i]);

   // if old is NOT null and new is null, then they are removing from the shipment - DELETE RECORD
   } else if (Trigger.old[i].Shipment__c != null & Trigger.new[i].Shipment__c == null) {
    invItemIdsToDelete.add(Trigger.new[i].id);

   // if they are both NOT null the we need to switch the new one to another shipment
   } else if (Trigger.old[i].Shipment__c != null & Trigger.new[i].Shipment__c != null) {
    if (Trigger.old[i].Shipment__c != Trigger.new[i].Shipment__c) {
     mapInvItemShipment.put(Trigger.new[i].id,Trigger.new[i].Shipment__c);
     invItemIdsToUpdate.add(Trigger.new[i].id);
    }
   }

  }

  // insert the new shipment records
  if (invItemsToInsert.size() > 0) {

   List<shipment_Item__c> shipmentItemsToInsert = new List<shipment_Item__c>();
   for (Inventory_Item__c item : invItemsToInsert) {

    Shipment_Item__c shipItem = new Shipment_Item__c();
    shipItem.Name = item.Name;
    shipItem.Inventory_Item__c = item.Id;
    shipItem.Shipment__c = item.Shipment__c;
    shipmentItemsToInsert.add(shipItem);

   }

   insert shipmentItemsToInsert;
  }

  // delete the corresponding shipment items that were removed
  if (invItemIdsToDelete.size() > 0)
   delete [select id from Shipment_Item__c where Inventory_Item__c IN :invItemIdsToDelete];

  // update ones that have been moved to another shipment
  if (invItemIdsToUpdate.size() > 0) {

   List<shipment_Item__c> itemsToUpdate = [select Id, Inventory_Item__c, Shipment__c from Shipment_Item__c where Inventory_Item__c IN :invItemIdsToUpdate];
   for (Shipment_Item__c item : itemsToUpdate)
    item.Shipment__c = mapInvItemShipment.get(item.Inventory_Item__c);

   update itemsToUpdate;

  }

 } else {

  List<shipment_Item__c> shipmentItemsToInsert = new List<shipment_Item__c>();

  for (Inventory_Item__c item : Trigger.new) {
   if (item.Shipment__c != null) {

    Shipment_Item__c shipItem = new Shipment_Item__c();
    shipItem.Name = item.Name;
    shipItem.Inventory_Item__c = item.Id;
    shipItem.Shipment__c = item.Shipment__c;
    shipmentItemsToInsert.add(shipItem);

   }
  }

  if (shipmentItemsToInsert.size() > 0)
   insert shipmentItemsToInsert;

 }

}
{% endhighlight %}
<p><strong>My test class looks like:</strong></p>
{% highlight js %}@isTest
private class Test_ShipmentItemProcess {

 static ID createShipment(String shipmentName) {

  Shipment__c shipment = new Shipment__c(
   name = shipmentName
  );

  insert shipment;
  return shipment.id;

 }

 static Inventory_Item__c createInventoryItem(String itemName) {

  Inventory_Item__c item = new Inventory_Item__c(
   name = itemName
  );

  insert item;
  return item;

 }

  static testMethod void testInsertAndDelete() {

  ID ship1Id = createShipment('Shipment 1');
  Inventory_Item__c item1 = createInventoryItem('LP100');

  // update the item with the new shipment number
  item1.Shipment__c = ship1Id;
  update item1;

  // fetch the newly created shipment item and make sure it was created correctly
  Shipment_Item__c shipItem1 = [select Id,Shipment__c,Inventory_Item__c from Shipment_Item__c where Inventory_Item__c = :item1.id];

  System.assertEquals(item1.id,shipItem1.Inventory_Item__c);
  System.assertEquals(item1.Shipment__c,shipItem1.Shipment__c);

  // now delete the shipment
  item1.Shipment__c = null;
  update item1;
  // make sure there are no records
  System.assertEquals(0,[select count() from Shipment_Item__c where Inventory_Item__c = :item1.id]);

  }

  static testMethod void testChangeShipment() {

  ID ship1Id = createShipment('Shipment 1');

  Inventory_Item__c item = new Inventory_Item__c(
   name = 'My LP',
   Shipment__c = ship1Id
  );
  insert item;

  Shipment_Item__c si = new Shipment_Item__c();
  si.Inventory_Item__c = item.id;
  si.Name = 'My LP';
  si.Shipment__c = ship1Id;
  insert si;

  ID ship2Id = createShipment('Shipment 2');
  item.Shipment__c = ship2Id;
  update item;

  // fetch the newly created shipment item and make sure it was created correctly
  Shipment_Item__c shipItem2 = [select Id,Shipment__c,Inventory_Item__c from Shipment_Item__c where Inventory_Item__c = :item.id];

  System.assertEquals(ship2Id,shipItem2.Shipment__c);

  }
}
{% endhighlight %}

