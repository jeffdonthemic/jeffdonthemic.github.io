---
layout: post
title:  Salesforce.com Critical Update - Workflow Rule and Roll-Up Summary Field Evaluations Up
description: On April 6, Salesforce.com is releasing an update that may affect your org if you have an after update or after insert Trigger that affects workflow or summary rollup fields. The critical update affects the way the Force.com platform evaluates workflow rules and roll-up summary fields on objects that fire Apex triggers. The update aims to improve the accuracy of data and prevent the reevaluation of workflow rules in the event of recursive operation. Recursion is a situation in which a part of yo
date: 2009-04-04 12:10:05 +0300
image:  '/images/slugs/critical-update-workflow-rule-and-roll-up-summary-field-evaluations.jpg'
tags:   ["salesforce"]
---
<p>On April 6, Salesforce.com is <a href="http://blog.sforce.com/sforce/2009/04/critical-update-workflow-rule-and-rollup-summary-field-evaluations-update.html" target="_blank">releasing an update</a> that may affect your org if you have an "after update" or "after insert" Trigger that affects workflow or summary rollup fields.</p>
<p>The critical update affects the way the Force.com platform evaluates workflow rules and roll-up summary fields on objects that fire Apex triggers. The update aims to improve the accuracy of data and prevent the reevaluation of workflow rules in the event of recursive operation. Recursion is a situation in which a part of your Apex trigger logic causes the Force.com platform to execute other logic (a workflow or roll-up summary field) twice when saving a record. We ran into this issue when developing our own custom lead assignment processes and studied <a href="/2009/03/06/triggers-and-order-of-execution/" target="_blank">the trigger and order of execution</a> internal event processing.</p>
<p>It looks like the update may affect alot of customers based upon the criteria of the "after update" or "after insert" trigger that performs any of the following operations:</p>
<ol>
	<li>Updates the current record</li>
	<li>Updates any child record of the current record, and there is a roll-up summary field on the current record</li>
	<li>Updates any unrelated object that has an Apex trigger which updates the current record</li>
</ol>
