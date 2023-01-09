---
layout: post
title:  Managing the Heap in Salesforce.com
description:   With the Spring 10 release, Salesforce.com removed the limit on the number of items a collection can hold. So now, instead of ensuring that your collections contain no more than 1000 items, you have to monitor your heap size. Here are some strategies on how to write Apex scripts that run within these limits. First of all, what is the heap? Dynamic memory allocation (also known as heap-based memory allocation) is the allocation of memory storage for use in a computer program during the runtime 
date: 2010-08-16 10:42:50 +0300
image:  '/images/slugs/managing-the-heap-in-salesforce-com.jpg'
tags:   ["2010", "public"]
---
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327948/heap1_equdvf.jpg" alt="" ></p>
<p>With the <a href="/2010/01/12/my-favorite-salesforce-com-spring-10-features/" target="_blank">Spring '10</a> release, Salesforce.com removed the limit on the number of items a collection can hold. So now, instead of ensuring that your collections contain no more than 1000 items, you have to monitor your heap size. Here are some strategies on how to write Apex scripts that run within these limits.</p>
<p>First of all, what is the heap? Dynamic memory allocation (also known as heap-based memory allocation) is the allocation of memory storage for use in a computer program during the runtime of that program. In Apex the heap is the reference to the amount of memory used by your reachable objects for a given script and request. When you create objects in your Apex code, memory is allocated to store these objects.</p>
<p>As with many other things in Force.com, there are <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_gov_limits.htm" target="_blank">governors and limits</a> that prevent you from hijacking the heap and degrading the performance of other running applications. The heap limit is calculated at runtime and differs on how your code is invoked:</p><ul><li>Triggers - 300,000 bytes</li><li>Anonymous Blocks, Visualforce Controllers, or WSDL Methods - 3,000,000 bytes</li><li>Tests - 1,500,000 bytes</li></ul><p>These limits also scale with trigger batch sizes:</p><ul><li>For 1-40 records, the normal limits apply</li><li>For 41-80 records, two times the normal limits apply</li><li>For 81-120 records, three times the normal limits apply</li><li>For 121-160 records, four times the normal limits apply</li><li>For 161 or more records, five times the normal limits apply</li></ul><p>Luckily Salesforce.com increased the heap size limits in <a href="/2010/07/07/my-favorite-salesforce-com-summer-10-features/" target="_blank">Summer '10</a> but you still may run into some issues. Here are a few things you can do to write heap-friendly code.</p>
<p><strong>Watch the Heap</strong></p>
<p>When your scripts run you can view the heap size in the debug logs. If you notice your heap approaching the limit, you will need to investigate why and try to refactor your code accordingly.</p>
<img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401028666/w12cpqkwmftom8tm48xs.png" alt="" width="290" height="241" />
<p><strong>Use the Transient Keyword</strong></p>
<p>Try using the "Transient" keyword with variables in your controllers and extensions. The transient keyword is used to declare instance variables that cannot be saved, and shouldn't be transmitted as part of the view state for a Visualforce page.</p>
<p><strong>Use Limit Methods</strong></p>
<p>Use heap limits methods in your Apex code to monitor/manage the heap during execution.</p><ul><li><strong>Limits.getHeapSize()</strong> - Returns the approximate amount of memory (in bytes) that has been used for the heap in the current context.</li><li><strong>Limits.getLimitHeapSize()</strong> - Returns the total amount of memory (in bytes) that can be used for the heap in the current context.</li></ul><p><br>
// check the heap size at runtime<br>
if (Limits.getHeapSize > 275000) {<br>
     // implement logic to reduce<br>
}</p>
<p>One strategy to reduce heap size during runtime is to remove items from the collection as you iterate over it.</p>
<p><strong>Put Your Objects on a Diet</strong></p>
<p>If the objects in your collection contain related objects (i.e., Account objects with a number of related Contacts for each) make sure the related objects only contain the fields that are actually needed by your script.</p>
<p><strong>Use SOQL For Loops</strong></p>
<p>SOQL "for" loops differ from standard SOQL statements because of the method they use to retrieve sObjects. To avoid heap size limits, developers should always use a SOQL "for" loop to process query results that return many records. SOQL "for" loops retrieve all sObjects in a query and process multiple batches of records through the use of internal calls to query and queryMore.</p>
{% highlight js %}for (List<Contact> contacts : [select id, firstname, lastname 
 from contact where billingState = 'NY']) {

 // implement your code to modify records in this batch

 // commit this batch of 200 records
 update contacts;
}
{% endhighlight %}
<p><strong>Note:</strong> There used to be a strategy for dealing with heap intensive scripts by moving them asynchronous, @Future methods. However, since the heap limits were increased in Summer '10 this is no longer a reason to simply use @Future method as the limits are the same.</p>
<p>Any other ideas on how to effectively manage the heap?</p>

