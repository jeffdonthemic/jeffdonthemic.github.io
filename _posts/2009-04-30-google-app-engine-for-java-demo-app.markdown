---
layout: post
title:  Google App Engine for Java Demo Application
description: Google App Engine for Java was released a couple of weeks ago and I finally...
date: 2009-04-30 14:40:04 +0300
image:  '/images/stock/6.jpg'
tags:   ["2009", "public"]
---
<p>Google App Engine for Java was released a couple of weeks ago and I finally found some time to finish up my first demo application. My original idea was to do a Java version of the <a href="/2009/04/14/forcecom-google-app-engine-python/" target="_blank">Salesforce.com demo that I did in Python on Google App Engine</a>, but I quickly found out that Google App Engine for Java does not support Web services. Hopefully there will be a workaround from Salesforce.com sometime in the near future to make this possible.</p>
<p>This demo has the same functionality as the Python version except that it uses BigTable as the datastore instead of Salesforce.com. <strong></strong></p>
<p><strong>You can run this demo at:</strong></p>
<blockquote><strong><a href="http://jeffdouglas-java1.appspot.com" target="_blank">http://jeffdouglas-java1.appspot.com</a></strong></blockquote>
A couple of observations from this early look:
<ol>
	<li>The <a href="http://code.google.com/appengine/docs/java/overview.html" target="_blank">documentation</a> is pretty good and really gets you up and going quickly.</li>
	<li>If you already have Eclipse running, the Google Plugin for Eclipse is a breeze to install.</li>
	<li>The development environment is really slick. The development server (Jetty) runs your application on your local computer for development and testing. The server simulates the App Engine datastore, services and sandbox restrictions.</li>
	<li>You can access BigTable with JDO or JPA. I choose JDO as most of the documentation uses this implementation. If you are familiar with Hibernate then JDO is fairly simple to grok.</li>
	<li>You can use Google Accounts for account creation and authentication. I didn't use this service but it looks pretty slick.</li>
	<li>Google has included a simple Guestbook app to get you started.</li>
</ol>
The Google App Engine Dashboard is very feature-rich and intuitive. I think it gives the <a href="/2009/01/09/amazons-ec2-console-makes-cloud-computing-fun-and-easy/" target="_blank">Amazon's EC2 Console</a> a run for its money.
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399623/ishot-4_kpfyyx.png"><img class="alignnone size-medium wp-image-821" title="ishot-4" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399623/ishot-4_kpfyyx.png?w=300" alt="ishot-4" width="300" height="198" /></a></p>
<p>The Google Plugin for Eclipse makes deploying the application to Google's servers simple-stupid. If you've ever had to configure Tomcat, JBoss or Websphere, you'll really enjoy the simplicity of the process. However, when creating a new application, make sure you do so through the Dashboard first before deploying it.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399621/ishot-1_sczgq8.png"><img class="alignnone size-medium wp-image-823" title="Eclipse Plugin" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399621/ishot-1_sczgq8.png?w=300" alt="Eclipse Plugin" width="300" height="196" /></a></p>
<p>You can download the source for the application <a href="http://jeffdouglas-java1.appspot.com/Telesales.zip" target="_blank">here</a>, but here is the real meat of the application, the Servlet:</p>
<pre><code>package com.jeffdouglas;

import java.io.IOException;
import javax.servlet.http.*;

import java.util.Date;
import java.util.List;
import java.text.DateFormat;
import javax.servlet.*;
import javax.jdo.PersistenceManager;
import com.jeffdouglas.entity.*;

import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@SuppressWarnings(&quot;serial&quot;)
public class TelesalesServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // create the persistence manager instance
        PersistenceManager pm = PMF.get().getPersistenceManager();

        // display the lookup form
        if(request.getParameter(&quot;action&quot;).equals(&quot;accountLookup&quot;)) {

            // query for the entities by name
            String query = &quot;select from &quot; + Account.class.getName() + &quot; where name == '&quot;+request.getParameter(&quot;accountName&quot;)+&quot;'&quot;;
            List accounts = (List) pm.newQuery(query).execute();   

            // pass the list to the jsp
            request.setAttribute(&quot;accounts&quot;, accounts);
            // forward the request to the jsp
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(&quot;/accountLookup.jsp&quot;);
            dispatcher.forward(request, response);   

        // display the create new account form   
        } else if(request.getParameter(&quot;action&quot;).equals(&quot;accountCreate&quot;)) {
            response.sendRedirect(&quot;/accountCreate.jsp&quot;);

        // process the new account creation and send them to the account display page   
        } else if(request.getParameter(&quot;action&quot;).equals(&quot;accountCreateDo&quot;)) {

            // create the new account
            Account a = new Account(
                    request.getParameter(&quot;name&quot;),
                    request.getParameter(&quot;billingCity&quot;),
                    request.getParameter(&quot;billingState&quot;),
                    request.getParameter(&quot;phone&quot;),
                    request.getParameter(&quot;website&quot;)
                );

            // persist the entity
            try {
                pm.makePersistent(a);
            } finally {
                pm.close();
            }

            response.sendRedirect(&quot;telesales?action=accountDisplay&amp;accountId=&quot;+a.getId());

        // display the account details and opportunities   
        } else if(request.getParameter(&quot;action&quot;).equals(&quot;accountDisplay&quot;)) {

            // fetch the account
            Key k = KeyFactory.createKey(Account.class.getSimpleName(), new Integer(request.getParameter(&quot;accountId&quot;)).intValue());
            Account a = pm.getObjectById(Account.class, k);

            // query for the opportunities
            String query = &quot;select from &quot; + Opportunity.class.getName() + &quot; where accountId == &quot;+request.getParameter(&quot;accountId&quot;);
            List opportunities = (List) pm.newQuery(query).execute();   

            // pass the list to the jsp
            request.setAttribute(&quot;account&quot;, a);
            // pass the list to the jsp
            request.setAttribute(&quot;opportunities&quot;, opportunities);

            // forward the request to the jsp
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(&quot;/accountDisplay.jsp&quot;);
            dispatcher.forward(request, response);   

        // display the create new opportunity form   
        } else if(request.getParameter(&quot;action&quot;).equals(&quot;opportunityCreate&quot;)) {

            Key k = KeyFactory.createKey(Account.class.getSimpleName(), new Integer(request.getParameter(&quot;accountId&quot;)).intValue());
            Account a = pm.getObjectById(Account.class, k);

            // pass the account name to the jsp
            request.setAttribute(&quot;accountName&quot;, a.getName());
            // forward the request to the jsp
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(&quot;/opportunityCreate.jsp&quot;);
            dispatcher.forward(request, response);

        // process the new opportunity creation and send them to the account display page 
        } else if(request.getParameter(&quot;action&quot;).equals(&quot;opportunityCreateDo&quot;)) {

            Date closeDate = new Date();

            // try and parse the date
            try {
                DateFormat df = DateFormat.getDateInstance(3);
                closeDate = df.parse(request.getParameter(&quot;closeDate&quot;));
            } catch(java.text.ParseException pe) {
                System.out.println(&quot;Exception &quot; + pe);
            }

            // create the new opportunity
            Opportunity opp = new Opportunity(
                request.getParameter(&quot;name&quot;),
                new Double(request.getParameter(&quot;amount&quot;)).doubleValue(),
                request.getParameter(&quot;stageName&quot;),
                new Integer(request.getParameter(&quot;probability&quot;)).intValue(),
                closeDate,
                new Integer(request.getParameter(&quot;orderNumber&quot;)).intValue(),
                new Long(request.getParameter(&quot;accountId&quot;))
            );

            // persist the entity
            try {
                pm.makePersistent(opp);
            } finally {
                pm.close();
            }

            response.sendRedirect(&quot;telesales?action=accountDisplay&amp;accountId=&quot;+request.getParameter(&quot;accountId&quot;));

        }

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

}
</code></pre>

