---
layout: post
title:  Uploading an Attachment using Visualforce and a Custom Controller
description: This is a follow up post to Uploading a Document using Visualforce and a Custom Controller showing an example for uploading an attachment for a Contact. The Visualforce page and Controller is very similar with a few exceptions.  Attachments are different than documents and are only available for the following objects- * Account  * Asset  * Campaign  * Case  * Contact  * Contract  * Custom objects  * EmailMessage  * EmailTemplate  * Event  * Lead  * Opportunity  * Product2  * Solution  * Task  Sa
date: 2010-04-28 10:07:11 +0300
image:  '/images/slugs/uploading-an-attachment-using-visualforce-and-a-custom-controller.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p style="clear: both">This is a follow up post to <a href="/2010/04/22/uploading-a-document-using-visualforce-and-a-custom-controller/" target="_blank">Uploading a Document using Visualforce and a Custom Controller</a> showing an example for uploading an attachment for a Contact. The Visualforce page and Controller is very similar with a few exceptions.</p><p style="clear: both"><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401028629/rc4pwheziai51atloqrj.png" class="image-link" rel="lightbox"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401028841/oulwtd7gy4vslvzjfede.png" height="257" align="left" width="550" style=" display: inline; float: left; margin: 0 10px 10px 0;" /></a><br style="clear: both" />Attachments are different than documents and are only available for the following objects:</p><p style="clear: both"><ul style="clear: both"><li>Account</li><li>Asset</li><li>Campaign</li><li>Case</li><li>Contact</li><li>Contract</li><li>Custom objects</li><li>EmailMessage</li><li>EmailTemplate</li><li>Event</li><li>Lead</li><li>Opportunity</li><li>Product2</li><li>Solution</li><li>Task</li></ul></p><p style="clear: both">Salesforce.com restricts an attachment size to a maximum size of 5 MB. For a file attached to a Solution, the limit is 1.5MB. The maximum email attachment size is 3 MB. You can contact Salesforce.com support and possibly have them increase these limits. They should be able to increase the document and attachment size to 25MB. They cannot increase the limits for emails.</p><p style="clear: both">AttachmentUploadExample</p><p style="clear: both">
{% highlight js %}<apex:page controller="AttachmentUploadController">
 <apex:sectionHeader title="Visualforce Example" subtitle="Attachment Upload Example"/>
 
 <apex:form enctype="multipart/form-data">
  <apex:pageMessages />
  <apex:pageBlock title="Upload a Attachment">
 
 <apex:pageBlockButtons >
  <apex:commandButton action="{!upload}" value="Save"/>
 </apex:pageBlockButtons>
 
 <apex:pageBlockSection showHeader="false" columns="2" id="block1">
 
  <apex:pageBlockSectionItem >
   <apex:outputLabel value="File Name" for="fileName"/>
   <apex:inputText value="{!attachment.name}" id="fileName"/>
  </apex:pageBlockSectionItem>
 
  <apex:pageBlockSectionItem >
   <apex:outputLabel value="File" for="file"/>
   <apex:inputFile value="{!attachment.body}" filename="{!attachment.name}" id="file"/>
  </apex:pageBlockSectionItem>
 
  <apex:pageBlockSectionItem >
   <apex:outputLabel value="Description" for="description"/>
   <apex:inputTextarea value="{!attachment.description}" id="description"/>
  </apex:pageBlockSectionItem>
 
 </apex:pageBlockSection>
 
  </apex:pageBlock>
 </apex:form>
</apex:page>
{% endhighlight %}
</p><p style="clear: both">AttachmentUploadController</p><p style="clear: both">
{% highlight js %}public with sharing class AttachmentUploadController {
 
 public Attachment attachment {
 get {
 if (attachment == null)
  attachment = new Attachment();
 return attachment;
  }
 set;
 }
 
 public PageReference upload() {
  
  attachment.OwnerId = UserInfo.getUserId();
  attachment.ParentId = '0037000000lFxcw'; // the record the file is attached to
  attachment.IsPrivate = true;
  
  try {
 insert attachment;
  } catch (DMLException e) {
 ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
 return null;
  } finally {
 attachment = new Attachment(); 
  }
  
  ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
  return null;
 }

}
{% endhighlight %}
</p><p style="clear: both"></p><br class="final-break" style="clear: both" />
