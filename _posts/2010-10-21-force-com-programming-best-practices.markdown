---
layout: post
title:  Force.com Programming Best Practices
description: Wes and I are adding a few more topics to our Salesforce Handbook before we put it to bed and I thought a great topic would be programming best practices. Ive never seen a complete list of best practices so I thought I would put something together based upon my experiences. I know Ive left some out, so if you have any to add, please chime in and we may include them in the book. Apex * Since Apex is case insensitive you can write it however youd like. However,  to increase readability, follow Jav
date: 2010-10-21 10:56:18 +0300
image:  '/images/slugs/force-com-programming-best-practices.jpg'
tags:   ["salesforce", "salesforce handbook", "visualforce", "apex"]
---
<p></p>
<p>Wes and I are adding a few more topics to our <a href="http://salesforcehandbook.wordpress.com/">Salesforce Handbook</a> before we put it to bed and I thought a great topic would be programming best practices. I've never seen a "complete" list of best practices so I thought I would put something together based upon my experiences. I know I've left some out, so if you have any to add, please chime in and we may include them in the book.</p>
<p><strong>Apex</strong></p>
<ul>
<li>Since Apex is case insensitive you can write it however you'd like. However, to increase readability, follow Java capitalization standards and use two spaces instead of tabs for indentation.</li>
<li>Use Asychronous Apex (@future annotation) for logic that does not need to be executed synchronous. </li>
<li>Asychronous Apex should be "bulkified".</li>
<li>Apex code must provide proper exception handling.</li>
<li>Prevent SOQL and SOSL injection attacks by using static queries, binding variables or the escapeSingleQuotes method.</li>
<li>When querying large data sets, use a <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/langCon_apex_SOQL_VLSQ.htm">SOQL "for" loop</a> </li>
<li>Use SOSL over SOQL where possible - it's much faster.</li>
<li>Use Apex Limits Methods to avoid hitting governor exceptions.</li>
<li>No SOQL or SOSL queries inside loops</li>
<li>No DML statements inside loops</li>
<li>No Async (@future) methods inside loops</li>
<li>Do not use hardcoded IDs</li>
</ul>
<p></p>
<p><strong>Triggers</strong></p>
<ul>
<li>There should only be one trigger for each object.</li>
<li>Avoid complex logic in triggers. To simplify testing and resuse, triggers should delegate to Apex classes which contain the actual execution logic. See Mike Leach's <a href="http://www.embracingthecloud.com/2010/07/08/ASimpleTriggerTemplateForSalesforce.aspx">excellent trigger template</a> for more info.</li>
<li>Bulkify any "helper" classes and/or methods.</li>
<li>Trigers should be "bulkified" and be able to process up to 200 records for each call.</li>
<li>Execute DML statements using collections instead of individual records per DML statement.</li>
<li>Use Collections in SOQL "WHERE" clauses to retrieve all records back in single query</li>
<li>Use a consistent naming convention including the object name (e.g., AccountTrigger)</li>
</ul>
<p></p>
<p><strong>Visualforce</strong></p>
<ul>
<li>Do not hardcode picklists in Visualforce pages; include them in the controller instead.</li>
<li>Javascript and CSS should be included as Static Resources allowing the browser to cache them.</li>
<li>Reference CSS at the top and JavaScript a the bottom of Visualforce pages as this provides for faster page loads.</li>
<li>Mark controller variables as "transient" if they are not needed between server calls. This will make your page load faster as it reduces the size of the View State. </li>
<li>Use <apex:repeat> to iterate over large collections.</li>
<li>Use the cache attribute with the <apex:page> component to take advantage CDN caching when appropriate</li>
</ul>
<p></p>
<p><strong>Unit Testing</strong></p>
<ul>
<li>Use a consistent naming convention including "Test" and the name of the class being tested (e.g., Test_AccountTrigger)</li>
<li>Test classes should use the @isTest annotation</li>
<li>Test methods should craete all data needed for the method and not rely on data currently in the Org. </li>
<li>Use System.assert liberally to prove that code behaves as expected.</li>
<li>Test each branch of conditional logic</li>
<li>Write test methods that both pass and fail for certain conditions and test for boundary conditions.</li>
<li>Test triggers to process 200 records - make sure your code is "bulkified" for 200 records and doesn't throw the dreaded "Too many SOQL queries: 21" exception.</li>
<li>When testing for governor limits, use Test.startTest and Test.stopTest and the Limit class instead of hard-coding governor limits.</li>
<li>Use System.runAs() to execute code as a specific user to test for sharing rules (but not CRUD or FLS permissions)</li>
<li>Execute tests with the Force.com IDE and not the salesforce.com UI. We've seen misleading code coverage results when running from the salesforce.com UI.</li>
<li>Run the <a href="http://security.force.com/sourcescanner">Force.com Security Source Scanner</a> to test your Org for a number of security and code quality issues (e.g., Cross Site Scripting, Access Control Issues, Frame Spoofing)</li>
</ul>
<p></p>
