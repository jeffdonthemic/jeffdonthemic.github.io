---
layout: post
title:  Why is this so DOM Hard?
description: Let me start out right away by saying I am not a DOM or CSS master. Ive typically had employees or co-workers to perform these functions for my so Ive (unfortunately) let me skills wane. However, Im not totally clueless. I was trying to build the following Visualforce page a couple of days ago and working with the DOM and Visualforce components seems to be much harder than what it should be. Perhaps Im doing something wrong? Luckily Wes Nolte  and Joel Dietz  are  experts and they both have a nu
date: 2010-08-11 11:27:01 +0300
image:  '/images/slugs/why-is-this-so-dom-hard.jpg'
tags:   ["2010", "public"]
---
<p>Let me start out right away by saying I am not a DOM or CSS master. I've typically had employees or co-workers to perform these functions for my so I've (unfortunately) let me skills wane. However, I'm not totally clueless. I was trying to build the following Visualforce page a couple of days ago and working with the DOM and Visualforce components seems to be much harder than what it should be. Perhaps I'm doing something wrong? Luckily <a href="http://th3silverlining.com" target="_blank">Wes Nolte</a> and <a href="http://d3developer.com/" target="_blank">Joel Dietz</a> <strong>are</strong> experts and they both have a number of great blog posts on this subject.</p>
<p>I was trying to create the following Visualforce page that contains a simple SelectList (I've sanitized the code for your protection).</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401028662/i6ry5gnbshgnijtzzpre.png" alt="" ></p>
<p>When the user submits the form, the value of the currently selected option is fired off via JavaScript. Shouldn't be a big deal, right? Based upon the Visualforce docs for <a href="http://www.salesforce.com/us/developer/docs/pages/Content/pages_access.htm?SearchType=Stem&Highlight=DOM" target="_blank">Using JavaScript to Reference Components</a>, I thought this code would work using the $Component variable (line #5).</p>
{% highlight js %}<apex:page controller="MyController" showHeader="false" id="thePage">
 
 <script language="javascript">
 function doSubmit() {
  alert(document.getElementById("{!$Component.theSelectList}").value);
 }
 </script>
 
 <apex:form id="theForm">
  <apex:pageblock id="thePageBlock">
 <apex:pageblockSection id="thePageBlockSection">
  <apex:pageBlockSectionItem id="thePageBlockItem">
   <apex:selectList value="{!selectedContentId}" size="1" id="theSelectList">
  <apex:selectOptions value="{!contentOptions}"/> 
   </apex:selectList>
  </apex:pageBlockSectionItem>
  <input type="button" value="Submit" onclick="doSubmit()" />
 </apex:pageblockSection>
  </apex:pageblock>
 </apex:form>
 
</apex:page>
{% endhighlight %}
<p>Unfortunately Firebug choked with s null pointer for the object's reference.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401028831/orrrgatdicdwmdfrl2d1.png" alt="" ></p>
<p>I found Wes' great post, <a href="http://th3silverlining.com/2009/06/17/visualforce-component-ids-javascript/" target="_blank">VisualForce Component Ids & Javascript</a>, and took a look at the element Id that Salesforce generated for the SelectList component. Based upon the other elements in the DOM hierarchy, I hard-coded my JavaScript to use the id that Salesforce was generating and the method worked correctly!</p>
{% highlight js %}<script language="javascript">
 function doSubmit() {
 alert(document.getElementById("thePage:theForm:thePageBlock:thePageBlockSection:thePageBlockItem:theSelectList").value);
 }
</script>
{% endhighlight %}
<img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401028864/pal2trtjvg6ohgf2zfxp.png" alt="" width="570" height="156" />
<p>So now I was confused. I dug deeper into Wes' post, the code and comments. Wes' solution was to assign the element value to a JavaScript variable just after it appears on the page (or at the same level within the page tree). My final (working) code looks like the following. Notice line #16 where I set the local JavaScript variable and then line #5 where I reference it's currently selected value.</p>
{% highlight js %}<apex:page controller="MyController" showHeader="false" id="thePage">
 
 <script language="javascript"> 
 function doSubmit() {
  alert(options.value);
 }
 </script>
 
 <apex:form id="theForm">
  <apex:pageblock id="thePageBlock">
 <apex:pageblockSection id="thePageBlockSection">
   <apex:pageBlockSectionItem id="thePageBlockItem">
  <apex:selectList value="{!selectedContentId}" size="1" id="theSelectList">
   <apex:selectOptions value="{!contentOptions}"/>  
  </apex:selectList>
  <script> var options = document.getElementById("{!$Component.theSelectList}"); </script>
   </apex:pageBlockSectionItem>
  <input type="button" value="Submit" onclick="doSubmit()" />
 </apex:pageblockSection>
  </apex:pageblock>
 </apex:form> 
 
</apex:page>
{% endhighlight %}
<p>Wes states that this solution is simple as well as flexible. However, what happens if you have 20+ form fields that you need to process in this manner? Does accessing the DOM seem too hard with Visualforce components? Let me know if I am doing something wrong?</p>

