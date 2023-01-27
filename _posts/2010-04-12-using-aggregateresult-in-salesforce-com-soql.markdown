---
layout: post
title:  Using AggregateResult in Salesforce.com SOQL
description: In Spring 10 , Salesforce.com released new Apex functionality for aggregate functions in SOQL. These queries return an AggregateResult object which can be somewhat confusing at first. Ive noticed quite a people searching my blog for this topic so I thought Id throw some examples together. So the functions count(fieldname), count_distinct(), sum(), avg(), min() and max() return an AggregateResult object (if one row is returned from the query) or a List of AggregateResult objects (if multiple row
date: 2010-04-12 11:18:52 +0300
image:  '/images/slugs/using-aggregateresult-in-salesforce-com-soql.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p style="clear: both">In <a href="http://sites.force.com/features/ideaHome?c=09a30000000DCUV" target="_blank">Spring '10</a>, Salesforce.com released new Apex functionality for <a href="http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_soql_select_agg_functions.htm" target="_blank">aggregate functions</a> in SOQL. These queries return an AggregateResult object which can be somewhat confusing at first. I've noticed quite a people searching my blog for this topic so I thought I'd throw some examples together.</p><p style="clear: both">So the functions count(fieldname), count_distinct(), sum(), avg(), min() and max() return an AggregateResult object (if one row is returned from the query) or a List of AggregateResult objects (if multiple rows are returned from the query). You access values in the AggregateResult object much like a map calling a "get" method with the name of the column. In the example below you can see how you can access a column name (leadsource), alias (total) and an unnamed column (expr0). If you have multiple unnamed columns you reference in the order called with expr0, expr1, expr2, etc.</p><p style="clear: both">
{% highlight js %}List<aggregateResult> results = [select leadsource, count(name) total, count(state) from lead group by leadsource ];

for (AggregateResult ar : results) {
 System.debug(ar.get('leadsource')+'-'+ar.get('total')+'-'+ar.get('expr0'));
}

{% endhighlight %}
</p><p style="clear: both">The AggregateResult returns the value as an object. So for some operations you will need to cast they value to assign them appropriately.</p><p style="clear: both">
{% highlight js %}Set<id> accountIds = new Set<id>();
for (AggregateResult results : [select accountId from contact group by accountId]) {
 accountIds.add((ID)results.get('accountId'));
}
{% endhighlight %}
</p><p style="clear: both">One this to be aware of is that the count() function <strong>does not</strong> return an AggregateResult object. The resulting query result size field returns the number of rows:</p><p style="clear: both">
{% highlight js %}Integer rows = [select count() from contact];
System.debug('rows: ' + rows);
{% endhighlight %}
</p><p style="clear: both">You can also do some cool things like embed the SOQL right in your expression:</p><p style="clear: both">
{% highlight js %}if ([select count() from contact where email = null] > 0) {
 // do some sort of processing...
}
{% endhighlight %}
</p><p style="clear: both">I run across this error once in awhile: <strong>Invalid type: AggregateResult</strong>. The error happens when you execute the code in a tool that is not using the 18 API. This happens to me frequently when I execute code anonymously in Eclipse. Try opening the System Log in Salesforce.com and running your code there.</p><br class="final-break" style="clear: both" />
