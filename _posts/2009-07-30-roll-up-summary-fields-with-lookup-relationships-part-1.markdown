---
layout: post
title:  Roll-Up Summary Fields with Lookup Relationships – Part 1
description: Roll-Up summary fields are a great way to perform calculations on a set of detail records in a master-detail relationship. For instance, if you have a sales order you can create a roll-up summary field to display the sum total of all sales order items (related detail records) for the sales order. The one drawback regarding roll-up summary fields is that they only work for master-details relationships. If you have a lookup relationship to your detail records from your sales order, then roll-up su
date: 2009-07-30 19:48:06 +0300
image:  '/images/slugs/roll-up-summary-fields-with-lookup-relationships-part-1.jpg'
tags:   ["2009", "public"]
---
<p>Roll-Up summary fields are a great way to perform calculations on a set of detail records in a master-detail relationship. For instance, if you have a sales order you can create a roll-up summary field to display the sum total of all sales order items (related detail records) for the sales order. The one drawback regarding roll-up summary fields is that they only work for master-details relationships. If you have a lookup relationship to your detail records from your sales order, then roll-up summary fields are not available.</p>
<p>So how do you perform this same type of functionality if you only have a lookup relationship? I ran across this same problem while doing some non-profit work for <a href="http://www.medisend.org" target="_blank">Medisend International</a> and the solution (with a caveat) is to write a trigger to perform the roll-up.</p>
<p>Medisend ships medical products overseas to developing countries. Medisend has a Shipment custom object that has a related list of Inventory Items which are the actual products on the shipment. In their scenario, the Inventory Items cannot be a master-detail relationship since these items can live on their own until they are assigned to a shipment. So to display the total number of items on the shipment to the case managers, I created a numeric filed on the shipment and wrote a trigger to sum the total number of items assigned to the shipment each time an Inventory Item is added or removed from the shipment.</p>
<p>However, there is one caveat due to governor limits. If the shipment contains more than 1000 items, then the trigger will throw an error at line 19 below. This is due to governor limits specifying that a List can only contain 1000 records. There is an <a href="http://ideas.salesforce.com/article/show/10089055/Count_the_SOQL_count_query_as_a_single_row_query" target="_blank">Idea regarding this functionality</a> so please vote for it. However if you are confident that your collection will never contain more than 1000 records, this solution should work for you.</p>
<p>This solution didn't work for Medisend due to the number of possible items on a shipment, so I had to structure the solution a little differently. I'll outline my final approach in my next post.</p>
<p><strong>Trigger InventoryItemRollup.trigger</strong></p>
{% highlight js %}trigger InventoryItemRollup on Inventory_Item__c (after delete, after insert, after update) {

	Set<id> shipmentIds = new Set<id>();
	List<shipment__c> shipmentsToUpdate = new List<shipment__c>();

	for (Inventory_Item__c item : Trigger.new)
		shipmentIds.add(item.Shipment__c);

	if (Trigger.isUpdate || Trigger.isDelete) {
		for (Inventory_Item__c item : Trigger.old)
			shipmentIds.add(item.Shipment__c);
	}

	// get a map of the shipments with the number of items
	Map<id,Shipment__c> shipmentMap = new Map<id,Shipment__c>([select id, items__c from Shipment__c where id IN :shipmentIds]);

	// query the shipments and the related inventory items and add the size of the inventory items to the shipment's items__c
	for (Shipment__c ship : [select Id, Name, items__c,(select id from Inventory_Items__r) from Shipment__c where Id IN :shipmentIds]) {
		shipmentMap.get(ship.Id).items__c = ship.Inventory_Items__r.size();
		// add the value/shipment in the map to a list so we can update it
		shipmentsToUpdate.add(shipmentMap.get(ship.Id));
	}

	update shipmentsToUpdate;

}

{% endhighlight %}
<p><strong>Unit Test - Test_InventoryItemRollup.cls</strong></p>
{% highlight js %}@isTest
private class Test_InventoryItemRollup {

	static Shipment__c createShipment(String name, ID caseId) {

  	Shipment__c s = new Shipment__c();
  	s.Name = name;
  	s.Aid_Case__c = caseId;
  	insert s;

		return s;

	}

  static testMethod void addItems() {

  	Set<id> shipmentIds = new Set<id>();
  	Integer shipment1ItemCount = 10;
  	Integer shipment2ItemCount = 7;

 		Aid_Case__c case1 = new Aid_Case__c();
 		case1.Name = 'ZZZ0101';
 		insert case1;

  	// create test shipments
  	Shipment__c shipment1 = createShipment('Shipment 1',case1.id);
  	Shipment__c shipment2 = createShipment('Shipment 2',case1.id);

  	List<inventory_Item__c> items = new List<inventory_Item__c>();

  	for (Integer i=0;i<shipment1ItemCount;i++) {

			Inventory_Item__c item = new Inventory_Item__c();
			item.Name__c = 'LP'+i;
			item.Shipment__c = shipment1.Id;

			items.add(item);

  	}

  	for (Integer i=0;i<shipment2ItemCount;i++) {

			Inventory_Item__c item = new Inventory_Item__c();
			item.Name__c = 'LP10'+i;
			item.Shipment__c = shipment2.Id;

			items.add(item);

  	}

  	insert items;

  	// fetch the shipments
  	shipmentIds.add(shipment1.Id);
  	shipmentIds.add(shipment2.Id);

  	// query for the shipments
  	Map<id,Shipment__c> shipmentMap = new Map<id,Shipment__c>([select Id, Name, items__c from Shipment__c where Id IN :shipmentIds]);

  	System.assertEquals(shipment1ItemCount,shipmentMap.get(shipment1.Id).Items__c);
  	System.assertEquals(shipment2ItemCount,shipmentMap.get(shipment2.Id).Items__c);

  	// now update an inventory item
  	items.get(0).Shipment__c = null;
  	update items.get(0);

  	// query the shipment to find out the total items now
  	Shipment__c shipment3 = [select items__c from Shipment__c where Id = :shipment1.id];

  	// assert that the shipment is one less than the original
  	System.assertEquals(shipment1ItemCount-1,shipment3.Items__c);

  }

}

{% endhighlight %}

