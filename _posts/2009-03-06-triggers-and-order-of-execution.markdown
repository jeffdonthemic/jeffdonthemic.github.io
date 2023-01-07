---
layout: post
title:  Triggers and Order of Execution
description: This topic came up again today in reference to a trigger to modify leadass...
date: 2009-03-06 19:36:24 +0300
image:  '/images/stock/3.jpg'
tags:   ["2009", "public"]
---
<p>This topic came up again today in reference to a trigger to modify lead assignments. It's always important to keep the order of these events in mind when developing as it can cause unintended consequences and a debugging nightmare.</p>
<p>When a record is saved with an insert, update, or upsert statement, the following events occur in order:</p>
<ol>
<li>The original record is loaded from the database (or initialized for an insert statement)</li>
<li>The new record field values are loaded from the request and overwrite the old values</li>
<li>System validation occurs, such as verifying that all required fields have a non-null value, and running any user-defined validation rules</li>
<li>All before triggers execute</li>
<li>The record is saved to the database, but not yet committed</li>
<li>All after triggers execute</li>
<li>Assignment rules execute</li>
<li>Auto-response rules execute</li>
<li>Workflow rules execute</li>
<li>If there are workflow field updates, the record is updated again</li>
<li>If the record was updated with workflow field updates, before and after triggers fire one more time (and only one more time)</li>
<li>Escalation rules execute</li>
<li>All DML operations are committed to the database</li>
<li>Post-commit logic executes, such as sending email</li>
</ol>

