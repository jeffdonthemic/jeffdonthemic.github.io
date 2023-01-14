---
layout: post
title:  Build a Bulk Emailer for Salesforce with App Engine
description: Sometimes you just want to send a crapload of email from Salesforce.com. However, like every PaaS platform there are limits baked into the multi-tenant environment so you dont stomp on other tenants resources. Salesforce.com limits you to 2000 emails per day for each Salesforce license. So if you dont have a lot of Salesforce licenses or a different kind of license, you may be out of luck if you want to send out large volumes. There are a few AppExchange products but they seem more targeted towa
date: 2011-08-25 13:01:19 +0300
image:  'http://zoomcopy.com/wp-content/uploads/2009/06/bulk_mail-house.jpg'
tags:   ["code sample", "google app engine", "salesforce"]
---
<p>Sometimes you just want to send a crapload of email from Salesforce.com. However, like every PaaS platform there are limits baked into the multi-tenant environment so you don't stomp on other tenants' resources. Salesforce.com limits you to 2000 emails per day for each Salesforce license. So if you don't have a lot of Salesforce licenses or a different kind of license, you may be out of luck if you want to send out large volumes. There are a few AppExchange products but they seem more targeted towards marketing purposes.</p>
<p><a href="http://code.google.com/appengine/">Google App Engine</a> may be a good solution in this case. With <a href="http://code.google.com/appengine/docs/quotas.html#Mail">Google App Engine quotas</a> you get 7,000 Mail API calls per day free and can bump that up as high as 1.7M with a paid account.</p>
<p>Here's how to roll your own basic bulk emailer using Google App Engine. Take a look at the video below, but it essentially queries Force.com for records, uses the Google Mail Java API to send out individual emails and then send an administrator a notification via Jabber (Google Talk). You can schedule your application (essentially a Servlet) to run on a timed basis using the <a href="http://code.google.com/appengine/docs/java/config/cron.html">cron service</a>.</p>
<p>All of this code is at <a href="https://github.com/jeffdonthemic/Salesforce-Bulk-Emailer">this GitHub repo.</a></p>
<figure class="kg-card kg-embed-card"><iframe width="200" height="113" src="https://www.youtube.com/embed/D4-RXAB9fH4?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></figure><p>Most of the important code is in the <a href="https://github.com/jeffdonthemic/Salesforce-Bulk-Emailer/blob/master/src/com/jeffdouglas/emailer/MailServlet.java">MailServlet class</a>.</p>
{% highlight js %}package com.jeffdouglas.emailer;

[removed imports]

/**
 * MailServlet.java - a simple, schedulable servlet for sending mail
 * with salesforce.com
 * @author Jeff Douglas
 * @version 1.0
 * @see http://code.google.com/appengine/docs/java/mail/overview.html
 * for more details on using Mail with App Engine
 */

@SuppressWarnings("serial")
public class MailServlet extends HttpServlet {

  private static final Logger logger = Logger.getLogger(ConnectionManager.class.getName());
  private String jabberRecipient = "jeffdonthemic@gmail.com";

  public void doGet(HttpServletRequest req, HttpServletResponse resp)
  throws IOException {

  resp.setContentType("text/html");
  String mailerMsg = "No contact found to email!!";
  QueryResult result = null;

  // get a reference to the salesforce connection
  PartnerConnection connection = ConnectionManager.getConnectionManager().getConnection();

  try {
  // query for contacts based upon some criteria -- emailNotSent boolean
  result = connection.query("Select Id, FirstName, LastName, Email " +
    "FROM Contact Where Email = 'jeff@jeffdouglas.com' Limit 1");
  } catch (ConnectionException e) {
  e.printStackTrace();
  logger.severe(e.getCause().toString());
  } catch (NullPointerException npe) {
  npe.printStackTrace();
  logger.severe(npe.getCause().toString());
  }

  // if records were returned then send out email
  if (result != null) {

   for (SObject contact : result.getRecords()) {

  // construct the 'name' for the email recipient
  String contactName = contact.getField("FirstName").toString() + " " + 
   contact.getField("LastName").toString();

  logger.info("Sending emil to " + contactName + " at " + 
   contact.getField("Email").toString());

  /// send the email
  mailerMsg = sendMail(contact.getField("Email").toString(), contactName);

  // send a jabber notification of the status
  sendJabberNotification(jabberRecipient, mailerMsg);

   }

   // TODO - make a call back into salesforce and update these records
   // as having their emails sent. Implementation is up to you.

  } else {
   logger.warning("No results returned from salesforce");
  }

  resp.getOutputStream().println(mailerMsg);

  } 

  /** 
 * Sends an email
 * @param toAddress the email address of the recipient
 * @param toName the name that appears for the recipeint in their email client 
 * @return A String representing the status of the email sent 
 */ 
  private String sendMail(String toAddress, String toName) {

 String msg = "Email sent successfully to " + toAddress;
 Properties props = new Properties();
 Session session = Session.getDefaultInstance(props, null); 

 String messageBody = "This is the body of my email";

 try {

   Message emailMessage = new MimeMessage(session);
   // must be the email address of an administrator for the application. see docs
   emailMessage.setFrom(new InternetAddress("jeffdonthemic@gmail.com","Jeff Douglas"));
   emailMessage.addRecipient(Message.RecipientType.TO, 
  new InternetAddress(toAddress, toName));
   emailMessage.setSubject("My Email Subject");
   emailMessage.setText(messageBody);
   Transport.send(emailMessage);

 } catch (AddressException e) {
   msg = e.toString();
 } catch (MessagingException e) {
   msg = e.toString();
 } catch (UnsupportedEncodingException e) {
   msg = e.toString();
 }

 return msg;
  }

  /** 
 * Sends a message to any XMPP-compatible chat messaging service (google talk). 
 * See http://code.google.com/appengine/docs/java/xmpp/overview.html
 * for more detils
 * @param recipient the jid of the jabber recipient of the notification
 * @param msgBody the body of the message to be sent 
 */ 
  private void sendJabberNotification(String recipient, String msgBody) {

 JID jid = new JID(recipient);

 com.google.appengine.api.xmpp.Message msg = new MessageBuilder()
   .withRecipientJids(jid)
   .withBody(msgBody)
   .build();

 boolean messageSent = false;
 XMPPService xmpp = XMPPServiceFactory.getXMPPService();

 if (xmpp.getPresence(jid).isAvailable()) {
   SendResponse status = xmpp.sendMessage(msg);
   messageSent = (status.getStatusMap().get(jid) == SendResponse.Status.SUCCESS);
 }

 logger.info("Jabber notifiation sent: " + messageSent);

  }

}
{% endhighlight %}

