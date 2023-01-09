---
layout: post
title:  Visualforce Export to Excel / IE Bug
description: There is a very nice article on how to export data to Excel using Visualforce. The only problem is that there is a  known issue  when using Internet Explorer that prevents it from working correctly. Here is the workaround and I have asked our support rep to check on the status of the bug.  	 		 			 			 		 	 
date: 2008-12-29 16:50:09 +0300
image:  '/images/slugs/visualforce-export-to-excel-ie-bug.jpg'
tags:   ["2008", "public"]
---
<p>There is a <a href="http://blog.sforce.com/sforce/2008/12/visualforce-to-excel.html">very nice article</a> on how to export data to Excel using Visualforce. The only problem is that there is a <a href="http://community.salesforce.com/sforce/board/message?board.id=Visualforce&thread.id=757&view=by_date_ascending&page=2">known issue</a> when using Internet Explorer that prevents it from working correctly.</p>
<p>Here is the workaround and I have asked our support rep to check on the status of the bug.</p>
{% highlight js %}<apex:page controller="YOURCONTROLLER" contentType="application/vnd.ms-excel#FILENAME.xls" cache="true">
	<apex:pageBlock title="Export Results" >
		<apex:pageBlockTable value="{!results}" var="c">
			<apex:column value="{!c.FirstName}"/>
			<apex:column value="{!c.LastName}"/>
		</apex:pageBlockTable>
	</apex:pageBlock>
</apex:page>
{% endhighlight %}

