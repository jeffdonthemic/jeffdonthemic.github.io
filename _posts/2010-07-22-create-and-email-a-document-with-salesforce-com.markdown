---
layout: post
title:  Email a Document with Salesforce.com
description: After my last post, Create and Email a PDF with Salesforce.com  , I received a few comments whether it was possible to do the same with Document stored in Salesforce.com. Could you choose a Document and then send it via email as an attachment? The short answer is yes! However, I tried to do it from a Force.com Sites page but was not able to get it to work. The document is not marked for internal use and it is marked as an externally available image. I also made sure that the public settings for 
date: 2010-07-22 09:39:28 +0300
image:  '/images/slugs/create-and-email-a-document-with-salesforce-com.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p style="clear: both">After my last post, <a href="/2010/07/16/create-and-email-a-pdf-with-salesforce-com/" target="_blank">Create and Email a PDF with Salesforce.com</a>, I received a few comments whether it was possible to do the same with Document stored in Salesforce.com. Could you choose a Document and then send it via email as an attachment? The short answer is yes! However, I tried to do it from a Force.com Sites page but was not able to get it to work. The document is not marked for internal use and it is marked as an externally available image. I also made sure that the public settings for my Site included read access to documents but still the query for the document returns no results. No time to look at it in depth right now so if anyone has an idea, please send it my way.</p><p style="clear: both"><a href="/2010/07/22/create-and-email-a-document-with-salesforce-com/email-doc/" rel="attachment wp-att-2896"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328000/email-doc_wuheya.png" alt="" title="email-doc" width="500" class="alignnone size-full wp-image-2896" /></a></p><p style="clear: both"><strong>DocumentEmailer Visualforce Page</strong></p><p style="clear: both">
{% highlight js %}<apex:page controller="DocumentEmailController">
 <apex:sectionHeader title="Document Example" subtitle="Email a Document" 
  description="Example of how to email a Document."/>

 <apex:form >
  <apex:pageMessages />
  <apex:pageBlock title="Document Input">
 
 <apex:pageBlockButtons >
  <apex:commandButton action="{!sendDoc}" value="Send Document"/>
 </apex:pageBlockButtons>
  
 <apex:pageBlockSection >
  
  <apex:pageBlockSectionItem >
  <apex:outputLabel value="Email to send to" for="email"/>
   <apex:inputText value="{!email}" id="email"/>
  </apex:pageBlockSectionItem>
  
  <apex:pageBlockSectionItem >
  <apex:outputLabel value="Document" for="document"/>
  <apex:selectList value="{!documentId}" id="document" size="1">
   <apex:selectOptions value="{!documents}"/>
  </apex:selectList>
  </apex:pageBlockSectionItem>
  
 </apex:pageBlockSection>

  </apex:pageBlock>
 </apex:form>

</apex:page>
{% endhighlight %}
</p><p style="clear: both"><strong>DocumentEmailController</strong></p><p style="clear: both">
{% highlight js %}public with sharing class DocumentEmailController {

 public ID documentId {get;set;}
 public String email {get;set;}
 
 public List<SelectOption> documents {
  get {
 if (documents == null) {
  documents = new List<SelectOption>();
  documents.add(new SelectOption('01570000001NZDn','Cup of Coffee? - DOC'));
  documents.add(new SelectOption('01570000001NZDi','Workflow Cheatsheet - PDF'));
 }
 return documents;
  }
  set;
 }
 
 public PageReference sendDoc() {

  Document doc = [select id, name, body, contenttype, developername, type 
 from Document where id = :documentId];
  
  Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
  attach.setContentType(doc.contentType);
  attach.setFileName(doc.developerName+'.'+doc.type);
  attach.setInline(false);
  attach.Body = doc.Body;

  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setUseSignature(false);
  mail.setToAddresses(new String[] { email });
  mail.setSubject('Document Email Demo');
  mail.setHtmlBody('Here is the email you requested: '+doc.name);
  mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
  
  // Send the email
  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with Document sent to '+email));

  return null;

 }

}
{% endhighlight %}
</p><p style="clear: both"><strong>Test Class</strong></p><p style="clear: both">
{% highlight js %}@isTest
private class Test_DocumentEmailer {

 static Document document;

 static {
  
  document = new Document();
  document.Body = Blob.valueOf('Some Text');
  document.ContentType = 'application/pdf';
  document.DeveloperName = 'my_document';
  document.IsPublic = true;
  document.Name = 'My Document';
  document.FolderId = [select id from folder where name = 'My Test Docs'].id;
  insert document;
  
 }

 static testMethod void testDocumentEmailer() {

  PageReference pref = Page.DocumentEmailer;  
  DocumentEmailController con = new DocumentEmailController();  
  
  Test.startTest();
  
  System.assertEquals(2,con.documents.size());
  
  // populate the field with values
  con.documentId = document.id;
  con.email = 'test@noemail.com';
  // submit the request
  pref = con.sendDoc();
  
  Test.stopTest(); 

 }
}
{% endhighlight %}
</p><br class="final-break" style="clear: both" />
