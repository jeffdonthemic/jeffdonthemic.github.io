---
layout: post
title:  How to Unit Test Sending Mail in Apex
description: I ran into an issue the other day where I wanted to send out an email notification as part of a trigger. The code itself was no problem but, like most days, my problems began as I tried to write the unit test. I couldnt get the required test coverage on those lines of code. Please Salesforce.com, provide some better documentation on writing test cases. Unit tests are mandatory to deploy Apex to production but the documentation on unit testing is extremely lacking. Everyone on the message boards 
date: 2008-10-15 22:45:48 +0300
image:  '/images/slugs/how-to-unit-test-sending-mail-in-apex.jpg'
tags:   ["2008", "public"]
---
<p>I ran into an issue the other day where I wanted to send out an email notification as part of a trigger. The code itself was no problem but, like most days, my problems began as I tried to write the unit test. I couldn't get the required test coverage on those lines of code.</p>
<p><rant>Please Salesforce.com, provide some better documentation on writing test cases. Unit tests are mandatory to deploy Apex to production but the documentation on unit testing is extremely lacking. Everyone on the message boards are screaming this lack of support</rant>.</p>
<p>I contacted our support development rep and he suggested moving the mail functions into their own class and then pass the required parameters to send the mail. This is what I came up with:</p>
{% highlight js %}public class MailerUtils {

    public static void sendMail(string message) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'me@email1.com','you@email2.com'};
        mail.setToAddresses(toAddresses);

        mail.setSubject('My Subject');

        mail.setUseSignature(false);
        mail.setHtmlBody(message);

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }   

    public static testMethod void testSendMail() {
        sendMail('This is my email message');
    }

}

{% endhighlight %}
<p>Here is a trigger that would fire after insert and send an email:</p>
{% highlight js %}trigger TestEmail on Contact (after insert) {

  for (Contact c : Trigger.new) {
		MailerUtils.sendMail('Welcome ' + c.Name);
  }

}
{% endhighlight %}

