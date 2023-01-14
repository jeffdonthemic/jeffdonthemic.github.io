---
layout: post
title:  Google App Engine for Java Demo Application
description: Google App Engine for Java was released a couple of weeks ago and I finally found some time to finish up my first demo application. My original idea was to do a Java version of the Salesforce.com demo that I did in Python on Google App Engine , but I quickly found out that Google App Engine for Java does not support Web services. Hopefully there will be a workaround from Salesforce.com sometime in the near future to make this possible. This demo has the same functionality as the Python version e
date: 2009-04-30 14:40:04 +0300
image:  '/images/slugs/google-app-engine-for-java-demo-app.jpg'
tags:   ["google app engine", "salesforce", "java"]
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
{% highlight js %}package com.jeffdouglas;

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

@SuppressWarnings("serial")
public class TelesalesServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // create the persistence manager instance
        PersistenceManager pm = PMF.get().getPersistenceManager();

        // display the lookup form
        if(request.getParameter("action").equals("accountLookup")) {

            // query for the entities by name
            String query = "select from " + Account.class.getName() + " where name == '"+request.getParameter("accountName")+"'";
            List accounts = (List) pm.newQuery(query).execute();   

            // pass the list to the jsp
            request.setAttribute("accounts", accounts);
            // forward the request to the jsp
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/accountLookup.jsp");
            dispatcher.forward(request, response);   

        // display the create new account form   
        } else if(request.getParameter("action").equals("accountCreate")) {
            response.sendRedirect("/accountCreate.jsp");

        // process the new account creation and send them to the account display page   
        } else if(request.getParameter("action").equals("accountCreateDo")) {

            // create the new account
            Account a = new Account(
                    request.getParameter("name"),
                    request.getParameter("billingCity"),
                    request.getParameter("billingState"),
                    request.getParameter("phone"),
                    request.getParameter("website")
                );

            // persist the entity
            try {
                pm.makePersistent(a);
            } finally {
                pm.close();
            }

            response.sendRedirect("telesales?action=accountDisplay&accountId="+a.getId());

        // display the account details and opportunities   
        } else if(request.getParameter("action").equals("accountDisplay")) {

            // fetch the account
            Key k = KeyFactory.createKey(Account.class.getSimpleName(), new Integer(request.getParameter("accountId")).intValue());
            Account a = pm.getObjectById(Account.class, k);

            // query for the opportunities
            String query = "select from " + Opportunity.class.getName() + " where accountId == "+request.getParameter("accountId");
            List opportunities = (List) pm.newQuery(query).execute();   

            // pass the list to the jsp
            request.setAttribute("account", a);
            // pass the list to the jsp
            request.setAttribute("opportunities", opportunities);

            // forward the request to the jsp
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/accountDisplay.jsp");
            dispatcher.forward(request, response);   

        // display the create new opportunity form   
        } else if(request.getParameter("action").equals("opportunityCreate")) {

            Key k = KeyFactory.createKey(Account.class.getSimpleName(), new Integer(request.getParameter("accountId")).intValue());
            Account a = pm.getObjectById(Account.class, k);

            // pass the account name to the jsp
            request.setAttribute("accountName", a.getName());
            // forward the request to the jsp
            RequestDispatcher dispatcher = getServletContext().getRequestDispatcher("/opportunityCreate.jsp");
            dispatcher.forward(request, response);

        // process the new opportunity creation and send them to the account display page 
        } else if(request.getParameter("action").equals("opportunityCreateDo")) {

            Date closeDate = new Date();

            // try and parse the date
            try {
                DateFormat df = DateFormat.getDateInstance(3);
                closeDate = df.parse(request.getParameter("closeDate"));
            } catch(java.text.ParseException pe) {
                System.out.println("Exception " + pe);
            }

            // create the new opportunity
            Opportunity opp = new Opportunity(
                request.getParameter("name"),
                new Double(request.getParameter("amount")).doubleValue(),
                request.getParameter("stageName"),
                new Integer(request.getParameter("probability")).intValue(),
                closeDate,
                new Integer(request.getParameter("orderNumber")).intValue(),
                new Long(request.getParameter("accountId"))
            );

            // persist the entity
            try {
                pm.makePersistent(opp);
            } finally {
                pm.close();
            }

            response.sendRedirect("telesales?action=accountDisplay&accountId="+request.getParameter("accountId"));

        }

    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }

}
{% endhighlight %}

