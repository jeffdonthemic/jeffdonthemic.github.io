---
layout: post
title:  Attaching a Document to a Record in Salesforce.com (Java)
description: The follow code allows you to upload a physical file to Salesforce.com and attach it to a record. /**   * See the following-  * API Docs- http-//www.salesforce.com/us/developer/docs/sforce70/wwhelp/wwhimpl/js/html/wwhelp.htmhref=sforce_API_objects_Attachment.html  * Example- http-//community.salesforce.com/sforce/board/messageboard.id=JAVA_development&message.id=4223  */  try {      File f = new File(c-\java\test.docx);     InputStream is = new FileInputStream(f);     byte;             is.read(i
date: 2008-10-10 18:37:00 +0300
image:  '/images/slugs/attaching-a-document-to-a-record-in-salesforcecom-java.jpg'
tags:   ["code sample", "salesforce", "java"]
---
<p>The follow code allows you to upload a physical file to Salesforce.com and attach it to a record.</p>
{% highlight js %}/** 
 * See the following:
 * API Docs: http://www.salesforce.com/us/developer/docs/sforce70/wwhelp/wwhimpl/js/html/wwhelp.htmhref=sforce_API_objects_Attachment.html
 * Example: http://community.salesforce.com/sforce/board/messageboard.id=JAVA_development&message.id=4223
 */

try {

    File f = new File("c:\java\test.docx");
    InputStream is = new FileInputStream(f);
    byte[] inbuff = new byte[(int)f.length()];        
    is.read(inbuff);

    Attachment attach = new Attachment();
    attach.setBody(inbuff);
    attach.setName("test.docx");
    attach.setIsPrivate(false);
    // attach to an object in SFDC 
    attach.setParentId("a0f600000008Q4f");

    SaveResult sr = binding.create(new com.sforce.soap.enterprise.sobject.SObject[] {attach})[0];
    if (sr.isSuccess()) {
        System.out.println("Successfully added attachment.");
    } else {
        System.out.println("Error adding attachment: " + sr.getErrors(0).getMessage());
    }
    

} catch (FileNotFoundException fnf) {
    System.out.println("File Not Found: " +fnf.getMessage());
    
} catch (IOException io) {
    System.out.println("IO: " +io.getMessage());            
}
{% endhighlight %}

