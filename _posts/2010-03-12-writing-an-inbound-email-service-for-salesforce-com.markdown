---
layout: post
title:  Writing an Inbound Email Service for Salesforce.com
description: Creating an inbound email service for Salesforce.com is a relatively straight forward process but there are a few thing to explain to make your life easier. The email service is an Apex class that implements the Messaging.InboundEmailHandler interface which allows you to process the email contents, headers and attachments. Using the information in the email, you could for instance, create a new contact if one does not exists with that email address, receive job applications and attached the pers
date: 2010-03-12 12:07:46 +0300
image:  '/images/slugs/writing-an-inbound-email-service-for-salesforce-com.jpg'
tags:   ["code sample", "salesforce", "apex"]
---
<p style="clear: both">Creating an inbound email service for Salesforce.com is a relatively straight forward process but there are a few thing to explain to make your life easier. The email service is an Apex class that implements the Messaging.InboundEmailHandler interface which allows you to process the email contents, headers and attachments. Using the information in the email, you could for instance, create a new contact if one does not exists with that email address, receive job applications and attached the person's resume to their record or have an integration process that emails data files for processing.</p><p style="clear: both">You access email services from Setup -> Develop -> Email Services. This page contains the basic code you will <strong>always</strong> use to start your Apex class. Simply copy this code and create your new class with it. Click the "New Email Service" button to get started and fill out the form. There are a number of options so make sure you read carefully and <a href="https://cs3.salesforce.com/help/doc/en/code_email_services_editing.htm" target="_blank">check out the docs</a>. One handy option is the "Enable Error Routing" which will send the inbound email to an alternative email address when the processing fails. You can can also specify email address(es) to accept mail from. This works great if you have some sort of internal process that emails results or file for import into Salesforce.com. Just like Workflow, make sure you mark it as "Active" or you will pull your hair out during testing.</p><p style="clear: both">After you save the new email service, you will need to scroll down to the bottom of the page and create a new email address for the service. An email service can have multiple email addresses and therefore process the same message differently for each address. When you create a new email service address you specify the "Context User" and "Accept Email From". The email service uses the permissions of the Context User when processing the inbound message. So you could, for example, have the same email service that accepts email from US accounts and processes them with a US context user and another address that accepts email from EMEA accounts and processes them with an EMEA context user. After you submit the from the Force.com platform will create a unique email address like the following. This is the address you send your email to for processing.</p><p style="clear: both"><strong>testemailservice@8q8zrtgg1w37vpomrhpqftj25.in.sandbox.salesforce.com</strong></p><p style="clear: both">Now that the email service is configured we can get down to writing the Apex code. Here's a simple class the creates a new contact and attaches any documents to the record. </p>
{% highlight js %}global class ProcessJobApplicantEmail implements Messaging.InboundEmailHandler {

 global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
 
 Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
 
 Contact contact = new Contact();
 contact.FirstName = email.fromname.substring(0,email.fromname.indexOf(' '));
 contact.LastName = email.fromname.substring(email.fromname.indexOf(' '));
 contact.Email = envelope.fromAddress;
 insert contact;
 
 System.debug('====> Created contact '+contact.Id);
 
 if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
   for (integer i = 0 ; i < email.binaryAttachments.size(); i++) {
   Attachment attachment = new Attachment();
   // attach to the newly created contact record
   attachment.ParentId = contact.Id;
   attachment.Name = email.binaryAttachments[i].filename;
   attachment.Body = email.binaryAttachments[i].body;
   insert attachment;
  }
 }
 return result;
  }
}
{% endhighlight %}
<p style="clear: both">One of the difficult thing about email service is debugging them. You can either create a test class for this or simply send the email and check the debug logs. Any debug statements you add to your class will show in the debug logs. Go to Setup -> Administration Setup -> Monitoring -> Debug Logs and add the Context User for the email service to the debug logs. Simply send an email to the address and check the debug log for that user.</p><p style="clear: both">One thing I wanted to see was the actual text and headers that are coming through in the service. Here's an image of virtually all fields and headers in a sample email. Click for more details.</p><p style="clear: both">The following unit test will get you 100% code coverage.</p>
{% highlight js %}static testMethod void testMe() {

 // create a new email and envelope object
 Messaging.InboundEmail email = new Messaging.InboundEmail() ;
 Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

 // setup the data for the email
 email.subject = 'Test Job Applicant';
 email.fromname = 'FirstName LastName';
 env.fromAddress = 'someaddress@email.com';

 // add an attachment
 Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
 attachment.body = blob.valueOf('my attachment text');
 attachment.fileName = 'textfile.txt';
 attachment.mimeTypeSubType = 'text/plain';

 email.binaryAttachments =
  new Messaging.inboundEmail.BinaryAttachment[] { attachment };

 // call the email service class and test it with the data in the testMethod
 ProcessJobApplicantEmail emailProcess = new ProcessJobApplicantEmail();
 emailProcess.handleInboundEmail(email, env);

 // query for the contact the email service created
 Contact contact = [select id, firstName, lastName, email from contact
  where firstName = 'FirstName' and lastName = 'LastName'];

 System.assertEquals(contact.firstName,'FirstName');
 System.assertEquals(contact.lastName,'LastName');
 System.assertEquals(contact.email,'someaddress@email.com');

 // find the attachment
 Attachment a = [select name from attachment where parentId = :contact.id];

 System.assertEquals(a.name,'textfile.txt');

}
{% endhighlight %}
<p style="clear: both">Here are a few links that may be helpful:</p><p style="clear: both"><ul style="clear: both"><li><a href="http://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#StartTopic=Content%2Fapex_classes_email_inbound.htm|SkinName=webhelp" target="_blank">Inbound Email docs with object definitions</a></li><li><a href="http://www.salesforce.com/us/developer/docs/cookbook/index_Left.htm#StartTopic=Content%2Fmessaging_inbound_attachments.htm|SkinName=webhelp" target="_blank">Retrieving Information from Incoming Email Messages (Force.com Cookbook)</a></li><li><a href="http://wiki.developerforce.com/index.php/Force.com_Email_Services_Unsubscribe" target="_blank">Force.com Email Services Unsubscribe</a></li><li><a href="http://www.salesforce.com/us/developer/docs/apexcode/index_Left.htm#StartTopic=Content%2Fapex_methods_system_string.htm|SkinName=webhelp" target="_blank">String methods</a></li></ul><br /><br /></p><p style="clear: both"></p><br class="final-break" style="clear: both" />
