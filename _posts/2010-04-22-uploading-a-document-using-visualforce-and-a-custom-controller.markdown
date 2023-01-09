---
layout: post
title:  Uploading a Document using Visualforce and a Custom Controller
description: The Salesforce docs for the inputFile Visualforce component has an example of uploading a document using the Standard Controller. Here is a quick example of using a Custom Controller in case you want to make the upload process part of a larger transaction. Make sure you take a look at the finally block in the controller below. The finally block always executes when the try block exits regardless if an error occurs or not. You need to ensure you clear out documents body (document.body = null) so 
date: 2010-04-22 10:56:00 +0300
image:  '/images/slugs/uploading-a-document-using-visualforce-and-a-custom-controller.jpg'
tags:   ["2010", "public"]
---
<p style="clear: both">The <a href="http://www.salesforce.com/us/developer/docs/pages/Content/pages_compref_inputFile.htm" target="_blank">Salesforce docs</a> for the inputFile Visualforce component has an example of uploading a document using the Standard Controller. Here is a quick example of using a Custom Controller in case you want to make the upload process part of a larger transaction.</p><p>Make sure you take a look at the <strong>finally</strong> block in the controller below. The finally block always executes when the try block exits regardless if an error occurs or not. You need to ensure you clear out document's body (document.body = null) so that the blob is not automatically included in the serialized image of the controller. If you do not clear out the body, you'll get the following view state error:</p><blockquote style="clear: both"><p>Maximum view state size limit (128K) exceeded. Actual viewstate size for this page was...</p></blockquote><p style="clear: both"><strong>FileUploadExample</strong></p><p style="clear: both">
{% highlight js %}<apex:page controller="FileUploadController">
 <apex:sectionHeader title="Visualforce Example" subtitle="File Upload Example"/>

 <apex:form enctype="multipart/form-data">
  <apex:pageMessages />
  <apex:pageBlock title="Upload a File">

 <apex:pageBlockButtons >
  <apex:commandButton action="{!upload}" value="Save"/>
 </apex:pageBlockButtons>

 <apex:pageBlockSection showHeader="false" columns="2" id="block1">

  <apex:pageBlockSectionItem >
   <apex:outputLabel value="File Name" for="fileName"/>
   <apex:inputText value="{!document.name}" id="fileName"/>
  </apex:pageBlockSectionItem>

  <apex:pageBlockSectionItem >
   <apex:outputLabel value="File" for="file"/>
   <apex:inputFile value="{!document.body}" filename="{!document.name}" id="file"/>
  </apex:pageBlockSectionItem>

  <apex:pageBlockSectionItem >
   <apex:outputLabel value="Description" for="description"/>
   <apex:inputTextarea value="{!document.description}" id="description"/>
  </apex:pageBlockSectionItem>

  <apex:pageBlockSectionItem >
   <apex:outputLabel value="Keywords" for="keywords"/>
   <apex:inputText value="{!document.keywords}" id="keywords"/>
  </apex:pageBlockSectionItem>

 </apex:pageBlockSection>

  </apex:pageBlock>
 </apex:form>
</apex:page>
{% endhighlight %}
<p><strong>FileUploadController</strong></p>
{% highlight js %}public with sharing class FileUploadController {

 public Document document {
  get {
 if (document == null)
  document = new Document();
 return document;
  }
  set;
 }

 public PageReference upload() {

  document.AuthorId = UserInfo.getUserId();
  document.FolderId = UserInfo.getUserId(); // put it in running user's folder

  try {
 insert document;
  } catch (DMLException e) {
 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
 return null;
  } finally {
 document.body = null; -- clears the viewstate
 document = new Document();
  }

  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'File uploaded successfully'));
  return null;
 }

}
{% endhighlight %}

