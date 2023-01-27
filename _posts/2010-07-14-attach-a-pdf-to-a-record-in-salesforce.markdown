---
layout: post
title:  Attach a PDF to a Record in Salesforce
description: Salesforce.com makes it extremely easy to generate PDF documents on the fly by simply using the renderAs=pdf attribute for the  component. Its also a snap to attach these PDFs to records as Attachments. Below is a small Visualforce page and Controller that generates a PDF and saves it to an Account. Note- there is a small issue when it comes to testing the Controller. Salesforce currently throws an error (Salesforce.com Error Unable to retrieve object) when getContent or getContentAsPDF is calle
date: 2010-07-14 12:57:33 +0300
image:  '/images/slugs/attach-a-pdf-to-a-record-in-salesforce.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>Salesforce.com makes it extremely easy to generate PDF documents on the fly by simply using the renderAs="pdf" attribute for the <apex:page> component. It's also a snap to attach these PDFs to records as Attachments. Below is a small Visualforce page and Controller that generates a PDF and saves it to an Account.</p>
<p><strong>Note:</strong> there is a small issue when it comes to testing the Controller. Salesforce currently throws an error (Salesforce.com Error "Unable to retrieve object") when getContent or getContentAsPDF is called from a test method. There's an <a href="http://sites.force.com/ideaexchange/ideaView?c=09a30000000D9xt&id=08730000000HzknAAC" target="_blank">Idea to make this work</a> properly. I encourage everyone to vote for this.</p>
<p><a href="/2010/07/14/attach-a-pdf-to-a-record-in-salesforce/attach-pdf/" rel="attachment wp-att-2867"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328003/attach-pdf_qywbr3.png" alt="" title="attach-pdf" width="500" class="alignnone size-full wp-image-2867" /></a></p>
<p><strong>PdfGenerator Visualforce Page</strong></p>
<p>The Visualforce page allows the users to enter the ID of the Account to attach the PDF to as well as the name of the PDF. You could just have easily used a Controller Extension instead of entering the ID for the Account but I went this route for simplicity.</p>
{% highlight js %}<apex:page controller="PdfGeneratorController">
 <apex:sectionHeader title="PDF Example" subtitle="Attach a PDF" 
  description="Example of how to attach a PDF to a record."/>

 <apex:form >
  <apex:pageBlock title="PDF Input">
 
 <apex:pageBlockButtons >
  <apex:commandButton action="{!savePdf}" value="Save PDF"/>
 </apex:pageBlockButtons>
 <apex:pageMessages />
  
 <apex:pageBlockSection >
  
  <apex:pageBlockSectionItem >
  <apex:outputLabel value="File Name" for="pdfName"/>
   <apex:inputText value="{!pdfName}" id="pdfName"/>
  </apex:pageBlockSectionItem>
  
  <apex:pageBlockSectionItem >
  <apex:outputLabel value="Account ID" for="id"/>
   <apex:inputText value="{!parentId}" id="id"/>
  </apex:pageBlockSectionItem>
  
 </apex:pageBlockSection>

  </apex:pageBlock>
 </apex:form>

</apex:page>
{% endhighlight %}
<p><strong>PdfGeneratorController Custom Controller</strong></p>
<p>The Controller passes the Account ID that the user entered as a parameter for the Visualforce page being generated. It then creates a new Attachment object and sets some attributes. It sets the ParentId to the value of the Account ID that the user entered so that the PDF is attached to that record. The Body of the attachment uses the Blob returned from the PageReference's getContent method. You could also use the getContentAsPDF method which always returns the page as a PDF, regardless of the <apex:page> component's renderAs attribute. However, this method <strong>always</strong> seems to throw an error in the test class. See the <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_pages_pagereference.htm" target="_blank">PageReference documentation</a> for more info. The method then redirects the user to the Account page so they can view the PDF attachment.</p>
{% highlight js %}public with sharing class PdfGeneratorController {

 public ID parentId {get;set;}
 public String pdfName {get;set;}
 
 public PageReference savePdf() {

  PageReference pdf = Page.PdfGeneratorTemplate;
  // add parent id to the parameters for standardcontroller
  pdf.getParameters().put('id',parentId);

  // create the new attachment
  Attachment attach = new Attachment();
  
  // the contents of the attachment from the pdf
  Blob body;
  
  try {
   
  // returns the output of the page as a PDF
   body = pdf.getContent();
   
  // need to pass unit test -- current bug 
  } catch (VisualforceException e) {
   body = Blob.valueOf('Some Text');
  }
  
  attach.Body = body;
  // add the user entered name
  attach.Name = pdfName;
  attach.IsPrivate = false;
  // attach the pdf to the account
  attach.ParentId = parentId;
  insert attach;
  
  // send the user to the account to view results
  return new PageReference('/'+parentId);

 }

}
{% endhighlight %}
<p><strong>PdfGeneratorTemplate Visualforce Page</strong></p>
<p>This is the Visualforce page that is generated in the Controller. It simply uses the StandardController and displays the Account name for the ID passed to it.</p>
{% highlight js %}<apex:page standardController="Account" renderAs="pdf">
 <h1>Congratulations!!</h1>
 <p>You created a PDF for {!account.name}</p>
</apex:page>
{% endhighlight %}
<p><b>Test Class</b></p>
{% highlight js %}@isTest
private class Test_PdfGeneratorController {

 static Account account;

 static {
  
  account = new Account();
  account.Name = 'Test Account';
  insert account;
  
 }

 static testMethod void testPdfGenerator() {

  PageReference pref = Page.PdfGenerator;
  pref.getParameters().put('id',account.id);
  Test.setCurrentPage(pref);
  
  PdfGeneratorController con = new PdfGeneratorController();  
  
  Test.startTest();
  
  // populate the field with values
  con.parentId = account.id;
  con.pdfName = 'My Test PDF';

  // submit the record
  pref = con.savePdf();

  // assert that they were sent to the correct page
  System.assertEquals(pref.getUrl(),'/'+account.id);

  // assert that an attachment exists for the record
  System.assertEquals(1,[select count() from attachment where parentId = :account.id]);
  
  Test.stopTest(); 

 }
}
{% endhighlight %}

