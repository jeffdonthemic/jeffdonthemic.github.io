---
layout: post
title:  SOQL – How I Query With Thee, Let Me Count the Ways
description: Ive been wanting to write this post since the new aggregate functions were announced in Spring 10. With the new 18 version of the API in sandboxes I can finally do a high level overview of SOQL (Salesforce Object Query Language) for all of the newcomers to the Force.com platform. This is definitely not an all-encompassing look as SOQL but something to whet your appetite with examples and screenshots. The Salesforce SOQL docs have a lot of great detailed info, but one of the things that I think i
date: 2010-02-22 19:03:10 +0300
image:  '/images/pexels-yan-krukov-8612931.jpg'
tags:   ["code sample", "salesforce", "starred"]
---
<p>I've been wanting to write this post since the new aggregate functions were announced in Spring 10. With the new 18 version of the API in sandboxes I can finally do a high level overview of SOQL (Salesforce Object Query Language) for all of the newcomers to the Force.com platform. This is definitely not an all-encompassing look as SOQL but something to whet your appetite with examples and screenshots. The Salesforce <a href="http://www.salesforce.com/us/developer/docs/api/index_CSH.htm#sforce_api_calls_soql.htm" target="_blank">SOQL docs</a> have a lot of great detailed info, but one of the things that I think is missing is what the results of the SOQL queries look like. This article does not cover <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dynamic_soql.htm" target="_blank">Dynamic SOQL</a>.</p>
<p>Most developers are familiar with SQL (Structured Query Language) so SOQL isn't much of a stretch. There are some really cool features of SOQL that you will find extremely productive but there are some restrictions that will make you want to pull your hair out. However, as with everything on the Force.com platform, SOQL is evolving and becoming better and better overtime. From a high level, there are a few important differences in the two languages:</p>
<p>With SQL you can retrieve and modify datasets directly. However, with SOQL you can only retrieve datasets. You can then use DML statements with these records to performs inserts, updates, deletes and upserts (creates new records and updates existing records within a single statement).In SQL joins are second-nature to retrieve data from multiple tables. However, with SOQL, one of my favorite features is its support for dot notation to join related objects implicitly. We'll look at both child-to-parent and parent-to-child relationship shortly.The biggest thing to remember is that SOQL is not SQL. SOQL does not support full SQL syntax so you'll have to rethink the way you query for data. With Spring 10 Saleforce.com has added some new aggregate functions (finally!!) and SOQL functions but there will be many times when you'll have to break open the docs to see what you can and can not do with SOQL.</p>
<ol>
<li>
<p>With SQL you can retrieve and modify datasets directly. However, with SOQL you can only retrieve datasets. You can then use <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml.htm" target="_blank">DML statements</a> with these records to performs inserts, updates, deletes and <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_dml_upsert.htm" target="_blank">upserts</a> (creates new records and updates existing records within a single statement).</p>
</li>
<li>
<p>In SQL joins are second-nature to retrieve data from multiple tables. However, with SOQL, one of my favorite features is its support for dot notation to join related objects implicitly. We'll look at both child-to-parent and parent-to-child relationship shortly.</p>
</li>
<li>
<p>The biggest thing to remember is that SOQL is not SQL. SOQL does not support full SQL syntax so you'll have to rethink the way you query for data. With Spring 10 Saleforce.com has added some new aggregate functions (finally!!) and SOQL functions but there will be many times when you'll have to break open the docs to see what you can and can not do with SOQL.</p>
</li>
</ol>
<h3>Relationship Queries</h3>
<p>Relationships are arguably the most powerful feature of SOQL. They allow you to perform joins on multiple objects and traverse the relationship chain to find and return objects. Relationships are available for standard and custom objects in Salesforce. However, their syntax is slightly different. The classic relationship example is accounts and contacts. An account (parent) can have multiple contacts (children).</p>
<p><strong>Child-to-Parent Relationship</strong></p>
<p>This type of query returns child objects (contact) containing parent (account) information:</p></p>
<p><img src="images/img1_vkhn8i.png" alt="" ></p>
<p>For child-to-parent relationships with custom objects the syntax is slightly different but the results are essentially the same. In the query below there is a custom object (<code>Affiliate__c</code>) with a lookup relationship on the Account object. Notice in the query below we use the <code>__r</code> instead of the object's name since this is the name of the relationship. This will be explained shortly in the parent-to-child section below.</p>
<p><img src="images/img2_wmyfvi.png" alt="" ></p>
<p>For each relationship you can specify up to 5 levels. This makes for some really cool queries that let you reach way up the relationship chain to fetch data. For instance you can write a query like this which spans only 4 levels.</p>
<p><img src="images/img31_fehb7u.png" alt="" ></p>
<p><strong>Parent-to-Child Relationships</strong></p>
<p>These types of queries are almost always one-to-many. You specify the relationship using a subquery, where the initial member of the FROM clause is the subquery is related to the initial member of the outer query FROM clause. Here's where the relationship comes into affect. With standard objects you use the plural name of the object in the subquery. Here's how you would find the name of the relationship using Eclipse:</p>
<p><img src="images/img4_fkroe9.png" alt="" ></p>
<p>The following query returns the name for each account and then for each account another collection of contacts containing their first name, last name and email address.</p>
<p><img src="images/img6_ld4zjb.png" alt="" ></p>
<p>For custom objects the relationships are slightly different. When you create a relationship between two objects, the Force.com platform generates a relationship name for you. So if your relationship field name is <code>Foo__c</code> the relationship name would be <code>Foo__r</code>. I've seen some really strange relationship names generated so you can change the name (<a href="/2009/05/13/using-related-lists-in-visualforce-pages/">here are instructions how</a>) if you need to. So a sample query might look like:</p>
<p><img src="images/img7_o0xtvb.png" alt="" ></p>
<p>You can get really crazy with relationships and where clauses in the subqueries and run something like the following.</p>
<p><img src="images/img8_tpx4om.png" alt="" ></p>
<p><strong>Joins</strong><br />SOQL also support semi-joins and anti-joins. Some examples are:</p>
<p><strong>Semi-Joins with IN query</strong></p>
<p><img src="images/img111_vs7pnw.png" alt="" ></p>
<p><strong>ID field Semi-Join</strong></p>
<p><img src="images/img12_ewnzhg.png" alt="" ></p>
<p><strong>ID field Anti-Join</strong></p>
<p><img src="images/img13_my22an-1.png" alt="" ></p>
<p><strong>Multiple Semi-Joins or Anti-Joins</strong></p>
<p><img src="images/img14_hu3a8g.png" alt="" ></p>
<h3>Aggregate Functions</h3>
<p>Aggregate Functions are the long-awaited additions to SOQL for Spring 10. Not all fields are supported so <a href="http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_soql_select_agg_functions_field_types.htm" target="_blank">check out this list</a> for details.</p>
<p><strong>COUNT()</strong> returns the number of rows that match the filtering conditions and COUNT() must be the only element in the select list. The resulting query result size field returns the number of rows and the records will returns null.</p>
<p><img src="images/img15_ndodei.png" alt="" ></p>
<p><strong>COUNT(fieldname)</strong> returns the number of rows that match the filtering conditions and have a non-null value. An AggregateResult object in the records field contains the number of rows. Do not use the size field for the resulting records.</p>
<p><img src="images/img16_vsjr1m.png" alt="" ></p>
<p><strong>COUNT_DISTINCT()</strong> returns the number of distinct non-null field values matching your query criteria.</p>
<p><img src="images/img171_hsr2uv.png" alt="" ></p>
<p><strong>SUM()</strong> returns the total sum of a numeric field based up your query criteria.</p>
<p><img src="images/img18_r38jcj.png" alt="" ></p>
<p><strong>AVG(</strong>) returns the average value of a numeric field based up your query criteria.</p>
<p><img src="images/img19_d4u0tr.png" alt="" ></p>
<p><strong>MIN()</strong> returns the minimum value for a field.</p>
<p><img src="images/img20_gvozxy.png" alt="" ></p>
<p><strong>MAX()</strong> returns the maximum value for a field.</p>
<p><img src="images/img211_u7aoy5.png" alt="" ></p>
<p><strong>GROUP BY</strong><br />As in SQL you can use GROUP BY to summarize and roll up your query results instead of processing records individually. There are a number of options, restrictions and conditions for group by, so <a href="http://www.salesforce.com/us/developer/docs/api/index_CSH.htm#sforce_api_calls_soql_select_groupby.htm" target="_blank">check out the docs</a> for more info.</p>
<p><img src="images/img221_fqnj6p.png" alt="" ></p>
<p>You can also calculate subtotals for aggregate data in query results by using GROUP BY ROLLUP.</p>
<p><img src="images/img23_gviu1f.png" alt="" ></p>
<p><strong>HAVING</strong><br />Using HAVING you can filter the results returned by aggregate functions where you might normally want to use a WHERE clause. For instance, <strong><em>this query will fail</em></strong>:</p>
<p><img src="images/img24_bvsbdo.png" alt="" ></p>
<p>This query will return the correct results:</p>
<p><img src="images/img25_ekjn1x.png" alt="" ></p>
<p><strong>Date Functions</strong></p>
<p>The Force.com platform provides you with a number of date functions that can be used in SOQL to make your life easier. <a href="http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_soql_select_date_functions.htm" target="_blank">Check out the docs</a> for a complete list.</p>
<p><img src="images/img26_zayur0.png" alt="" ></p>

