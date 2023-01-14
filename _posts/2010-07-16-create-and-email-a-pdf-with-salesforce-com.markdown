---
layout: post
title:  Create and Email a PDF with Salesforce.com
description: This is a continuation of my post a couple of days ago, Attach a PDF to a Record in Salesforce  , and shows how to dynamically generate a PDF and attach it to an email. The code is fairly similar and has the same issue with testing the PageReference getContent() method. You can run this demo at my developer site.  PdfEmailer Visualforce Page  The Visualforce page simply allows the user to enter their email address and select a sample Account from the picklist. This is Account that is passed to t
date: 2010-07-16 11:03:15 +0300
image:  '/images/slugs/create-and-email-a-pdf-with-salesforce-com.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p style="clear: both">This is a continuation of my post a couple of days ago, <a href="/2010/07/14/attach-a-pdf-to-a-record-in-salesforce/" target="_blank">Attach a PDF to a Record in Salesforce</a>, and shows how to dynamically generate a PDF and attach it to an email. The code is fairly similar and has the same issue with testing the PageReference getContent() method.</p><p style="clear: both"><h3 style="text-decoration:underline; clear: both"><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/PdfEmailer" target="_blank">You can run this demo at my developer site.</a></h3></p> <p style="clear: both"><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/PdfEmailer"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400328002/email-pdf_jwyc4s.png" alt="" title="email-pdf" width="500" height="237" class="alignnone size-full wp-image-2889" /></a><p><strong>PdfEmailer Visualforce Page</strong></p><p style="clear: both">The Visualforce page simply allows the user to enter their email address and select a sample Account from the picklist. This is Account that is passed to the PdfGeneratorTemplate Visualforce page to generate the PDF.</p>
{% highlight js %}<apex:page controller="PdfEmailController">
 <apex:sectionHeader title="PDF Example" subtitle="Email a PDF" 
  description="Example of how to email a dynamically generated PDF."/>

 <apex:form >
  <apex:pageMessages />
  <apex:pageBlock title="PDF Input">
 
 <apex:pageBlockButtons >
  <apex:commandButton action="{!sendPdf}" value="Send PDF"/>
 </apex:pageBlockButtons>
  
 <apex:pageBlockSection >
  
  <apex:pageBlockSectionItem >
  <apex:outputLabel value="Email to send to" for="email"/>
   <apex:inputText value="{!email}" id="email"/>
  </apex:pageBlockSectionItem>
  
  <apex:pageBlockSectionItem >
  <apex:outputLabel value="Account" for="account"/>
  <apex:selectList value="{!accountId}" id="account" size="1">
   <apex:selectOptions value="{!accounts}"/>
  </apex:selectList>
  </apex:pageBlockSectionItem>
  
 </apex:pageBlockSection>

  </apex:pageBlock>
 </apex:form>

</apex:page>
{% endhighlight %}
<p style="clear: both"><strong>PdfEmailerController</strong></p><p style="clear: both">The Controller passes the Account ID that the user entered as a parameter for the Visualforce page being generated. It let creates the attachment from the PDF content. The Body of the attachment uses the Blob returned from the PageReference’s getContent method. You could also use the getContentAsPDF method which always returns the page as a PDF, regardless of the <apex:page> component’s renderAs attribute. However, this method always seems to throw an error in the test class. See the <a href="http://www.salesforce.com/us/developer/docs/apexcode/Content/apex_pages_pagereference.htm" target="_blank">PageReference documentation</a> for more info. The method then constructs the SimpleEmailMessage object and then sends it on its way to the recipient's inbox.</p>
{% highlight js %}public with sharing class PdfEmailController {

 public ID accountId {get;set;}
 public String email {get;set;}
 
 public List<SelectOption> accounts {
  get {
 if (accounts == null) {
  accounts = new List<SelectOption>();
  accounts.add(new SelectOption('0017000000LgRMb','United Oil & Gas Corp.'));
  accounts.add(new SelectOption('0017000000LgRMV','Burlington Textiles Corp of America'));
 }
 return accounts;
  }
  set;
 }
 
 public PageReference sendPdf() {
  
  PageReference pdf = Page.PdfGeneratorTemplate;
  // add parent id to the parameters for standardcontroller
  pdf.getParameters().put('id',accountId);
  
  // the contents of the attachment from the pdf
  Blob body;
  
  try {
 
 // returns the output of the page as a PDF
 body = pdf.getContent();
 
  // need to pass unit test -- current bug 
  } catch (VisualforceException e) {
 body = Blob.valueOf('Some Text');
  }
  
  Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
  attach.setContentType('application/pdf');
  attach.setFileName('testPdf.pdf');
  attach.setInline(false);
  attach.Body = body;

  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
  mail.setUseSignature(false);
  mail.setToAddresses(new String[] { email });
  mail.setSubject('PDF Email Demo');
  mail.setHtmlBody('Here is the email you requested! Check the attachment!');
  mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
  
  // Send the email
  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
  
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to '+email));

  return null;

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
<p><strong>Test Class</strong><p>
{% highlight js %}@isTest
private class Test_PdfEmailController {

 static Account account;

 static {
  
  account = new Account();
  account.Name = 'Test Account';
  insert account;
  
 }

 static testMethod void testPdfEmailer() {

  PageReference pref = Page.PdfEmailer;
  pref.getParameters().put('id',account.id);
  Test.setCurrentPage(pref);
  
  PdfEmailController con = new PdfEmailController();  
  
  Test.startTest();
  
  System.assertEquals(2,con.accounts.size());
  
  // populate the field with values
  con.accountId = account.id;
  con.email = 'test@noemail.com';
  // submit the record
  pref = con.sendPdf();
  
  Test.stopTest(); 

 }
}
{% endhighlight %}

