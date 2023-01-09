---
layout: post
title:  Visualforce Row Counter for Iteration Components
description: I have been working on a Visualforce page that displays a list of items from a collection and I want to display the current row number next to each item. I found this post that describes a solution but I think there may be a bug in one of the components so here is proposed work around. I want to display a collection like this-  It seems that there may be a bug in the way method works with the dataTable component. It works correctly with the following components. Repeat Component - DataList Compo
date: 2010-04-02 13:21:42 +0300
image:  '/images/slugs/visualforce-row-counter-for-iteration-components.jpg'
tags:   ["2010", "public"]
---
<p>I have been working on a Visualforce page that displays a list of items from a collection and I want to display the current row number next to each item. I found <a href="http://community.salesforce.com/t5/Visualforce-Development/find-counter-for-repeat-component/m-p/139123/message-uid/139123" target="_blank">this post</a> that describes a solution but I think there may be a bug in one of the components so here is proposed work around. I want to display a collection like this:</p>
<p><strong>It seems that there may be a bug in the way method works with the dataTable component.</strong> It works correctly with the following components.</p>
<p><strong>Repeat Component</strong></p>
{% highlight js %}<apex:variable value="{!1}" var="rowNum"/>

<apex:repeat value="{!myCollection}" var="item">
 <apex:outputText value="{!FLOOR(rowNum)}"/> - <apex:outputField value="{!item.Name}"/><br/>
 <apex:variable var="rowNum" value="{!rowNum + 1}"/>
</apex:repeat>
{% endhighlight %}
<p><strong>DataList Component</strong></p>
{% highlight js %}<apex:variable value="{!1}" var="rowNum"/>

<apex:dataList value="{!myCollection}" var="item">
 <apex:outputText value="{!FLOOR(rowNum)}"/> - <apex:outputField value="{!item.Name}"/>
 <apex:variable var="rowNum" value="{!rowNum + 1}"/>
</apex:dataList>
{% endhighlight %}
<p><strong>DataTable Component</strong> - Does not work??</p>
{% highlight js %}<apex:variable value="{!1}" var="rowNum"/>

<apex:dataTable value="{!myCollection}" var="item">
 <apex:column>
  <apex:outputText value="{!FLOOR(rowNum)}"/>
 </apex:column>
 <apex:column >
  <apex:outputField value="{!item.Name}"/>
 </apex:column>
 <apex:variable var="rowNum" value="{!rowNum + 1}"/>
</apex:dataTable>
{% endhighlight %}
<p style="clear: both">So the solution that I came up with is to wrap my collection in an wrapper class implemented as an inner class in the controller.</p><p style="clear: both"><strong>Controller fragment</strong></p>
{% highlight js %}private void myMethod() {
 Integer counter = 0;
 for ((SomeObject__c item : [Select Name from SomeObject__c]) {
  counter = counter + 1;
  // add the wrapper to the collection
  myCollection.add(new DataTableWrapper(item, counter));
 }
}

// inner class
class DataTableWrapper {

 public Integer counter { get; set; }
 public SomeObject__c item { get; set;}

 public DataTableWrapper(SomeObject__c item, Integer counter) {
  this.item = item;
  this.counter = counter;
 }

}
{% endhighlight %}
<p><strong>Visualforce fragment</strong></p>
{% highlight js %}<apex:dataTable value="{!myCollection}" var="wrapper" columns="2">
 <apex:column>
  <apex:outputText value="{!wrapper.counter}."/>
 </apex:column>
 <apex:column>
  <apex:outputField value="{!wrapper.item.Name}"/>
 </apex:column>
</apex:dataTable>
{% endhighlight %}
</p><br class="final-break" style="clear: both" />
