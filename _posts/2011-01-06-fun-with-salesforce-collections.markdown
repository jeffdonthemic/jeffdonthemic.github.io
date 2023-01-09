---
layout: post
title:  Fun with Salesforce Collections
description: The Apex language provides developers with three classes (Set, List and Map) that make it easier to handle collections of objects. In a sense these collections work somewhat like arrays, except their size can change dynamically, and they have more advanced behaviors and easier access methods than arrays. If you are familiar with the Java Collections API then these should feel very warm and cozy. Each collection has characteristics that make it applicable in certain situations and well cover thes
date: 2011-01-06 15:51:08 +0300
image:  '/images/pexels-peng-louis-1643456.jpg'
tags:   ["2011", "public"]
---
<p>The Apex language provides developers with three classes (Set, List and Map) that make it easier to handle collections of objects. In a sense these collections work somewhat like arrays, except their size can change dynamically, and they have more advanced behaviors and easier access methods than arrays. If you are familiar with the Java Collections API then these should feel very warm and cozy. Each collection has characteristics that make it applicable in certain situations and we'll cover these in detail. We'll talk about each of the collections, their features, how they are typically used and show some sample code that you can execute in your org.</p>
<p><strong>Note:</strong> Salesforce.com recently made an important change to collections. There is no longer a limit on the number of items a collection can hold. However, there is a general limit on <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_gov_limits.htm#total_heap_size_limit_desc" target="_blank">heap size</a>.</p>
<p>I tried to fit virtually everything that I could about collections onto a single blog post hoping it will make good Evernote fodder. If I left something out, please drop a comment below.</p>
<h3>Set</h3>
<p>A set is a collection of unique, unordered elements. It can contain <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/langCon_apex_primitives.htm" target="_blank">primitive data types</a> (String, Integer, Date, etc) or sObjects. If you need ordered elements use a List instead. You typically see Sets used to store collections of IDs that you want to use in a SOQL query.</p>
<p>The basic syntax for creating a new Set is:</p>
{% highlight js %}Set<datatype> set_name = new Set<datatype>();
Set<datatype> set_name = new Set<datatype>{value [, value2. . .] };
{% endhighlight %}
<p>Examples:</p>
{% highlight js %}Set<String> s = new Set<String>();
Set<String> s = new Set<String>{'Jon', 'Quinton', 'Reid'};
{% endhighlight %}
<p>As mentioned before one of the main characteristics of a Set is the uniqueness of elements. You can safely try to add the same element (e.g., 100, 'c', 125.25) to a Set more than once and it will just disregard the duplicate (without throwing an Exception). However, there is a slight twist when dealing with sObjects. Uniqueness of sObjects is determined by comparing fields in the objects. The following code will result in only one element in the Set.</p>
{% highlight js %}Account acct1 = new account(Name='ACME Corp');
Account acct2 = new account(Name='ACME Corp');
Set<Account> s = new Set<Account>{acct1, acct2}; // Set will only contain 1 element
{% endhighlight %}
<p>Different field values cause the objects to become unique.</p>
{% highlight js %}Account acct1 = new account(Name='ACME Corp', BillingAddress='100 Main');
Account acct2 = new account(Name='ACME Corp');
Set<Account> s = new Set<Account>{acct1, acct2}; // Set will only contain 2 elements
{% endhighlight %}
<p><strong>Set Methods</strong></p>
<p>There are a number Set methods so <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_set.htm" target="_blank">check out the docs</a> for a complete list, but here are some of the more common ones you might use. You can paste the following snippet of code into your browser's System Log and run it anonymously.</p>
{% highlight js %}// create a new set with 3 elements
Set<String> s = new Set<String>{'Jon', 'Quinton', 'Reid'};
// adds an element IF not already present
s.add('Sandeep');
// adds an element IF not already present
s.add('Sandeep'); 
// return the number of elements
System.debug('=== number of elements: ' + s.size()); 
// removes the element if present
s.remove('Reid'); 
 // return the number of elements
System.debug('=== number of elements: ' + s.size());
// returns true if the set contains the specified element
System.debug('=== set contains element Jon: ' + s.contains('Jon')); 
// output all elements in the set
for (String str : s) 
 // outputs an element
 System.debug('=== element : ' + str); 
// makes a duplicate of the set
Set<String> s1 = s.clone(); 
// displays the contents of the set
System.debug('=== contents of s1: ' + s1); 
// removes all elements
s1.clear(); 
// returns true if the set has zero elements
System.debug('=== is the s1 set empty? ' + s1.isEmpty()); 
{% endhighlight %}
<p>You should see the following (abbreviated) output:</p>
<p>DEBUG|=== number of elements: 4<br>
DEBUG|=== number of elements: 3<br>
DEBUG|=== set contains element Jon: true<br>
DEBUG|=== element : Jon<br>
DEBUG|=== element : Quinton<br>
DEBUG|=== element : Sandeep<br>
DEBUG|=== contents of s1: {Jon, Quinton, Sandeep}<br>
DEBUG|=== is the s1 set empty? true</p>
<p>Commonly you'll see developers construct a Set of IDs from a query, trigger context, etc. and then use it as part of the WHERE clause in their SOQL query:</p>
{% highlight js %}Set<ID> ids = new Set<ID>{'0017000000cBlbwAAC','0017000000cBXCWAA4'};
List<Account> accounts = [Select Name From Account Where Id = :ids];
{% endhighlight %}
<h3>List</h3>
Lists are the mostly widely used collection so learn to love them (I do!!). A List is a collection of primitives, user-defined objects, sObjects, Apex objects or other collections (can be multidimensional up to 5 levels). Use a List (as opposed to a Set) when the sequence of elements is important. You can also have duplicate elements in a List. List are zero-based so the first element in the List is always 0.
<p>The basic syntax for creating a new List is:</p>
{% highlight js %}List <datatype> list_name = new List<datatype>();]
List <datatype> list_name = new List<datatype>{value [, value2. . .]};
{% endhighlight %}
<p>Examples:</p>
{% highlight js %}List<Integer> s = new List<Integer>();
List<String> s = new List<String>{'Jon', 'Quinton', 'Reid'};

// Create a nested List of Sets
List<List<Set<String>>> s2 = new List<List<Set<String>>>();

// Create a List of contact records from a SOQL query 
List<Contacts> contacts = [SELECT Id, FirstName, LastName FROM Contact LIMIT 10]; 
{% endhighlight %}
<p>Lists and Arrays are pretty much interchangeable and you can mix and match them:</p>
{% highlight js %}List<Contact> contacts = newContact[] {new(), newContact()};

List<String> s = new List<String>{'Jon', 'Quinton', 'Reid'};
String[] s1 = new String[]{'Jon', 'Quinton', 'Reid'};
System.debug('=== ' + s.get(0));
System.debug('=== ' + s1.get(0));
System.debug('=== ' + s[0]);
System.debug('=== ' + s1[0]);
{% endhighlight %}
<p>You should see the following (abbreviated) output:</p>
<p>DEBUG|=== Jon<br>
DEBUG|=== Jon<br>
DEBUG|=== Jon<br>
DEBUG|=== Jon</p>
<p><strong>List Methods</strong></p>
<p>There are a number List methods so <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_list.htm" target="_blank">check out the docs</a> for a complete list, but here are some of the more common ones you might use. You can paste the following snippet of code into your browser's System Log and run it anonymously.</p>
{% highlight js %}List<String> s = new List<String>{'Jon', 'Quinton', 'Reid'};
// adds an element
s.add('Sandeep'); 
// adds an element
s.add('Sandeep'); 
// return the number of elements
System.debug('=== number of elements: ' + s.size());
// displays the first element 
System.debug('=== first element: ' + s.get(0)); 
// removes the first element
s.remove(0); 
// return the number of elements
System.debug('=== number of elements: ' + s.size()); 
// makes a duplicate of the set
List<String> s1 = s.clone(); 
// displays the contents of the set
System.debug('=== contents of s1: ' + s1); 
// replace the last instance of 'Sandeep' with 'Pat'
s1.set(3,'Pat'); // displays the contents of the set
System.debug('=== contents of s1: ' + s1); 
// sorts the items in ascending (primitave only)
s1.sort(); 
// displays the contents of the set
System.debug('=== sorted contents of s1: ' + s1); 
// removes all elements
s.clear(); 
// returns true if the set has zero elements
System.debug('=== is the list empty? ' + s.isEmpty()); 
{% endhighlight %}
<p>You should see the following (abbreviated) output:</p>
<p>DEBUG|=== number of elements: 5<br>
DEBUG|=== first element: Jon<br>
DEBUG|=== number of elements: 4<br>
DEBUG|=== contents of s1: (Quinton, Reid, Sandeep, Sandeep)<br>
DEBUG|=== contents of s1: (Quinton, Reid, Sandeep, Pat)<br>
DEBUG|=== sorted contents of s1: (Pat, Quinton, Reid, Sandeep)<br>
DEBUG|=== is the list empty? true</p>
<p>You can use a List of Strings in the same sort of way you would a Set as part of a SOQL query:</p>
{% highlight js %}List<String> ids = new List<String>{'0017000000cBlbwAAC','0017000000cBXCWAA4'};
List<Account> accounts = [Select Name From Account Where Id IN :ids];
{% endhighlight %}
<p>Since SOQL queries return Lists of records, you can use them directly for iteration:</p>
{% highlight js %}for (Account a : [Select Id, Name From Account Limit 2]) {
System.debug('=== ' + a.Name);
}
{% endhighlight %}
<p>You can also use the List in a traditional for loop:</p>
{% highlight js %}List<Account> accounts = [Select Id, Name From Account Limit 2];
for (Integer i=0;i<accounts.size();i++) {
System.debug('=== ' + accounts.get(i).Name);
}
{% endhighlight %}
<h3>Map</h3>
<p>A Map is a collection of key-value pairs. Keys can be any primitive data type while values can include primitives, Apex objects, sObjects and other collections. Use a map when you want to quickly find something by a key. Each key must be unique but you can have duplicate values in your Map.</p>
<p>The basic syntax for creating a new Map is:</p>
{% highlight js %}Map<key_datatype, value_datatype> map_name = new map<key_datatype, value_datatype>();

Map<key_datatype, value_datatype> map_name = new map<key_datatype, value_datatype>{key1_value => value1_value [, key2_value => value2_value. . .]};
{% endhighlight %}
<p>Examples:</p>
{% highlight js %}Map<Integer, String> m = new Map<Integer, String>{5 => 'Jon', 6 => 'Quinton', 1 => 'Reid'};
Map<ID, Set<String>> m = new Map<D, Set<String>>();
// creates a map where the key is the ID of the record
Map<Id,Account> aMap = new Map<Id, Account>([Select Id, Name From Account LIMIT 2]);
{% endhighlight %}
<p><strong>Map Methods</strong></p>
<p>There are a number Map methods so <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_map.htm" target="_blank">check out the docs</a> for a complete list, but here are some of the more common ones you might use. You can paste the following snippet of code into your browser's System Log and run it anonymously.</p>
{% highlight js %}Map m = new Map{5 => 'Jon', 6 => 'Quinton', 1 => 'Reid'};
// displays all keys
System.debug('=== all keys in the map: ' + m.keySet()); 
// displays all values
System.debug('=== all values in the map (as a List): ' + m.values()); 
// does the key exist?
System.debug('=== does key 6 exist?: ' + m.containsKey(6)); 
// fetches the value for the key
System.debug('=== value for key 6: ' + m.get(6)); 
// adds a new key/value pair
m.put(3,'Dave'); 
// returns the number of elements
System.debug('=== size after adding Dave: ' + m.size()); 
// removes an element
m.remove(5); 
System.debug('=== size after removing Jon: ' + m.size());
// clones the map
Map m1 = m.clone(); 
System.debug('=== cloned m1: ' + m1);
// removes all elements
m.clear(); 
// returns true if zero elements
System.debug('=== is m empty? ' + m.isEmpty()); 
{% endhighlight %}
<p>You should see the following (abbreviated) output:</p>
<p>DEBUG|=== all keys in the map: {1, 5, 6}<br>
DEBUG|=== all values in the map (as a List): (Reid, Jon, Quinton)<br>
DEBUG|=== does key 6 exist?: true<br>
DEBUG|=== value for key 6: Quinton<br>
DEBUG|=== size after adding Dave: 4<br>
DEBUG|=== size after removing Jon: 3<br>
DEBUG|=== cloned m1: {1=Reid, 3=Dave, 6=Quinton}<br>
DEBUG|=== is m empty? true</p>
<p>Maps are used very frequently to store records that you want to process or as containers for "lookup" data. It's very common to query for records and store them in a Map so that you can "do something" with them. The query below creates a Map for you where the key is the ID of the record. This makes it easy to find the record in the Map based upon the ID. You can paste the following snippet of code into your browser's System Log and run it anonymously.</p>
{% highlight js %}Map<Id,Account> accountMap = new Map<Id, Account>(
 [Select Id, Name From Account LIMIT 2]);
System.debug('=== ' + accountMap);
// keySet() returns a Set we can iterate through
for (Id id : accountMap.keySet()) {
 System.debug('=== ' + accountMap.get(id).Name);
}
{% endhighlight %}
<p>You'll use Maps quite a bit when writing triggers. For before update and after update triggers there are two trigger context variables named oldMap and newMap. The oldMap contains a list of sObject before they were modified. The newMap contains a list of sObject with the updated values. You typically use these Maps to make some sort of comparison inside the trigger:</p>
{% highlight js %}for (Id id : Trigger.newMap.keySet()) {
 if (Trigger.oldMap.get(id).LastName != Trigger.newMap.get(id).LastName) {
  System.debug('=== the last name has changed!!');
  // handle the name change somehow  
 }
}
{% endhighlight %}
<p>Maps are also used extensively to stay within governors and limits. The following is code from <a href="/2009/04/20/writing-bulk-triggers-for-salesforce/" target="_blank">Writing Bulk Triggers in Salesforce.com</a>:</p>
{% highlight js %}trigger AddOwnerColor on Account (before insert, before update) {

 // create a set of all the unique ownerIds
 Set<id> ownerIds = new Set<id>();
 for (Account a : Trigger.new)
 ownerIds.add(a.OwnerId); 

 // query for all the User records for the unique userIds in the records
 // create a map for a lookup / hash table for the user info
 Map<id, User> owners = new Map<id, User>([Select Favorite_Color__c from User Where Id in :ownerIds]); 

 // iterate over the list of records being processed in the trigger and
 // set the color before being inserted or updated
 for (Account a : Trigger.new)
 a.Owner_Favorite_Color__c = owners.get(a.OwnerId).Favorite_Color__c;
 
}
{% endhighlight %}
<p><strong>Modifying Collection Elements</strong><br>
Modifying a collection's elements while iterating through that collection is not supported and will throw an error. To add or remove elements for a collection, while iterating over the collection, create a new temporary list with these elements. Then simply add or remove them after you are finished iterating the collection.</p>
<p><strong>Custom Iterators</strong><br>
Apex has the ability to create <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_classes_iterable.htm" target="_blank">custom Iterators</a> but that is a little beyond the scope of this post.</p>

