---
layout: post
title:  Modifying Salesforce.com System Fields during Data Migration
description: Typically CreatedBy, CreatedDate, LastModifiedByID, LastModifiedDate, and a number of other fields on most objects are read-only for valid business and data-integrity reasons. However, during data migrations is it sometimes desirable to insert records with legacy dates and ids to match the source system. You can contact Salesforce Support and they will enable this functionality for you for a limited time. Tell them you would like to enable Create Audit Fields on your org. This allows you to inse
date: 2009-04-27 13:12:04 +0300
image:  '/images/slugs/modifying-salesforcecom-system-fields.jpg'
tags:   ["salesforce"]
---
<p>Typically CreatedBy, CreatedDate, LastModifiedByID, LastModifiedDate, and a number of other fields on most objects are read-only for valid business and data-integrity reasons. However, during data migrations is it sometimes desirable to insert records with legacy dates and ids to match the source system.</p>
<p>You can contact Salesforce Support and they will enable this functionality for you for a limited time. Tell them you would like to enable "Create Audit Fields" on your org. This allows you to insert new records (not on update though) with dates and/or ids that you specify. They will typically only allow this functionality for a limited period of time (probably 2 weeks) but in some cases such as routinely copying data from external systems, they may enable this functionality permanently.</p>
<p>The objects that you can edit these fields on are:</p>
<ul>
 <li>Account</li>
 <li>Opportunity</li>
 <li>Contact</li>
 <li>Lead</li>
 <li>Case</li>
 <li>Task</li>
 <li>Event</li>
 <li>Custom Objects</li>
</ul>
