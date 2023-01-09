---
layout: post
title:  Getting Salesforce Field Metadata the Easy Way
description: Im working on some of the Apex REST services for our CloudSpokes  org and needed some code to fetch field level metadata using Apex Describe. I poked around and realized that there isnt really much out there. So I decided to write something up and hopefully people find it useful or instructional. Perhaps it should be part of apex-lang ?  If youve ever worked with Apex Describe before youll quickly realize that its not the easiest thing to work with. Youll want to take a peek at the docs  . Dont 
date: 2011-10-20 17:38:01 +0300
image:  '/images/slugs/getting-salesforce-field-metadata-the-easy-way.jpg'
tags:   ["2011", "public"]
---
<p>I'm working on some of the Apex REST services for our <a href="http://www.cloudspokes.com">CloudSpokes</a> org and needed some code to fetch field level metadata using Apex Describe. I poked around and realized that there isn't really much out there. So I decided to write something up and hopefully people find it useful or instructional. Perhaps it should be part of <a href="http://code.google.com/p/apex-lang/">apex-lang</a>?</p>
<p>If you've ever worked with Apex Describe before you'll quickly realize that it's not the easiest thing to work with. You'll want to <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_methods_system_fields_describe.htm">take a peek at the docs</a>. Don't get me wrong, it's power, fast and very handy. But it is rather confusing and cumbersome to work with at first. So I wanted some code that returns the metadata for specific fields in an object so that I could look at field types and lengths and perform "stuff" accordingly.</p>
<p>So here's what I can up with. You pass the method the DescribeFieldResult for an object and a collection of fields that you want metadata for. The method returns a map where the field names are the keys and the values contain the metadata for the corresponding field. It looks pretty hard but that's the great thing about utility methods, they encapsulate and hide the complexity of the implementation.</p>
{% highlight js %}public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(
 Schema.DescribeSObjectResult dsor, Set<String> fields) {
	
 // the map to be returned with the final data
 Map<String,Schema.DescribeFieldResult> finalMap = 
  new Map<String, Schema.DescribeFieldResult>();
 // map of all fields in the object
 Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
		
 // iterate over the requested fields and get the describe info for each one. 
 // add it to a map with field name as key
 for(String field : fields){
  // skip fields that are not part of the object
  if (objectFields.containsKey(field)) {
 Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
 // add the results to the map to be returned
 finalMap.put(field, dr); 
  }
 }
 return finalMap;
}
{% endhighlight %}
<p>So now in my code I can call this static method in my Utils class and access the field metadata easily by fetching it from the map by it's field name:</p>
{% highlight js %}// field to return -- skips fields not actually part of the sobject
Set<String> fields = new Set<String>{'name','annualrevenue','BADFIELD'};

Map<String, Schema.DescribeFieldResult> finalMap = 
 Utils.getFieldMetaData(Account.getSObjectType().getDescribe(), fields);

// only print out the 'good' fields
for (String field : new Set<String>{'name','annualrevenue'}) {
 System.debug(finalMap.get(field).getName()); // field name
 System.debug(finalMap.get(field).getType()); // field type
 System.debug(finalMap.get(field).getLength()); // field length
}
{% endhighlight %}
<p>So if you run this, you'll see something like:</p>
<p>DEBUG|Name<br>
DEBUG|STRING<br>
DEBUG|255<br>
DEBUG|AnnualRevenue<br>
DEBUG|CURRENCY<br>
DEBUG|0</p>

