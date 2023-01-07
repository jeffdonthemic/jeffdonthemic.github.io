---
layout: post
title:  Salesforce.com with Flex and BlazeDS Tutorial
description: It’s fairly common these days to see Flex applications running insideSal...
date: 2009-03-26 18:08:45 +0300
image:  '/images/stock/1.jpg'
tags:   ["2009", "public"]
---
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399674/blaze-app_sxcicv.png" alt="" ></p>
<p>It’s fairly common these days to see Flex applications running inside Salesforce.com. We use Apex and Visualforce for a large majority of our custom UIs but there are some instances that just work better with Flex (drag and drop, trees, tabbed interfaces, etc.).</p>
<p>But what if you have a shiny, new Flex application running on your corporate website and your CEO decides he wants to display some data stored in Salesforce.com? Better yet, he wants a mashup using Salesforce.com, Google Maps, Flickr and YouTube?</p>
<p>As of right now you have the following options:</p>
<ul>
	<li>Expose your Apex class as a Web service and call it from your Flex application. This is a perfectly suitable solution if you only have to make a few calls to Salesforce.com. Web service integration with Flex is not the speediest for a number of reasons.</li>
	<li>Utilize the <a href="http://wiki.developerforce.com/index.php/Flex_Toolkit" target="_blank">Force.com Toolkit for Adobe Air and Flex</a> providing asynchronous access to the Force.com Web services API.</li>
	<li>Implement a solutions using Adobe’s <a href="http://www.adobe.com/devnet/flashremoting/" target="_blank">Flash Remoting</a> technology on a variety of platforms and technologies.</li>
	<li>Hosting your Flex applications on Force.com Sites (when it becomes generally available this year)</li>
	<li>Develop a high performance data transfer service using Adobe’s <a href="http://opensource.adobe.com/wiki/display/blazeds/BlazeDS" target="_blank">BlazeDS</a> open source Java remoting and messaging technology.</li>
</ul>
<p>This tutorial will focus on the installation, configuration and development of a simple Flex application that fetches Accounts from Salesforce.com using the BlazeDS Remoting Service. The Remoting Service is a high performance data transfer service that allows your Flex application to directly invoke Java object methods on your application server (in this case Tomcat) and consume the return values natively. The objects returned from the server-side methods (primitive data types, objects, collections, etc) are automatically deserialized into either dynamic or typed ActionScript objects.</p>
<p>This tutorial requires that you have the following installed:</p>
<ul>
	<li>A recent version of Tomcat (5.5+) with JDK 1.5 or higher installed</li>
	<li><a href="http://www.eclipse.org/downloads/" target="_blank">Eclipse IDE for Java Developers</a> (or Eclipse Classic)</li>
	<li>Adobe <a href="http://www.adobe.com/cfusion/entitlement/index.cfm?e=flex3email" target="_blank">Flex 3.0 Builder 3 or Flex 3 Builder Plug-In</a></li>
</ul>
You will also need a Free Developer Edition of Salesforce.com. There is a link in the upper left underneath the search box on <a href="http://developer.force.com" target="_blank">developer.force.com</a>.
<p>It is also assumed that you have some experience with Flex, Java and Eclipse.</p>
<p>Some of this information comes from a great tutorial from Christopher Coenraets called, <a href="http://www.adobe.com/devnet/livecycle/articles/blazeds_gettingstarted.html" target="_blank">Getting started with BlazeDS</a>.</p>
<h2 style="padding-top:20px;">Demo and Code</h2>
<p>You can <em><strong>run the working demo</strong></em> of this tutorial at: <a href="http://demo.jeffdouglas.com:8080/sfdc-blazeds/sfdc-client/main.html" target="_blank">http://demo.jeffdouglas.com:8080/sfdc-blazeds/sfdc-client/main.html</a></p>
<p>You can <em><strong>download the code</strong></em> for this tutorial at: <a href="http://demo.jeffdouglas.com:8080/sfdc-blazeds/sfdc-blazeds-code.zip" target="_blank">http://demo.jeffdouglas.com:8080/sfdc-blazeds/sfdc-blazeds-code.zip</a></p>
<h2 style="padding-top:20px;">Install BlazeDS</h2>
<p>You can download the latest release build of the binary distribution or the turnkey distribution (contains tomcat 6 already) from the <a href="http://opensource.adobe.com/wiki/display/blazeds/Downloads" target="_blank">BlazeDS download page</a>.</p>
<p>Unzip the file and place the war file into your <strong>webapps</strong> directory in Tomcat. If the war doesn't automatically explode then you will need to restart Tomcat. Your <strong>WEB-INF</strong> directory should look like the following:</p>
<img class="alignnone size-full wp-image-576" title="blaze-tutorial-1" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399673/blaze-tutorial-11_dkwsvs.png" alt="blaze-tutorial-1" width="544" height="297" />
<h2 style="padding-top:20px;">Create Your Java Server Project</h2>
<p>You will need to a Java project to develop the server-side components of this tutorial. Create a new Java project in Eclipse (File -&gt; New -&gt; Java Project. On the next screen enter your Project name as &quot;sfdc-blaze-server&quot;. Your screen should look like the following. After you confirm the settings, click Next.</p>
<img class="alignnone size-full wp-image-580" title="blaze-tutorial-31" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399671/blaze-tutorial-31_hom4s9.png" alt="blaze-tutorial-31" width="544" height="609" />
<p>On the next screen make sure the Default output folder is &quot;sfdc-blaze-server/bin&quot; and click Finish.</p>
<p>To make life a little easier we’ll create a new folder in the project and link it to the Tomcat <strong>classes</strong> directory. Right click on your Eclipse project and select New -&gt; Folder. Name the folder &quot;classes&quot;, click the Advanced button and link it to the <strong>classes</strong> folder in the Tomcat application. Your screen should look like the following:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399670/blaze-tutorial-5_jujlpl.png" alt="" ></p>
<p>Now from the Eclipse menu, select Project -&gt; Properties and change your Java Build Path to &quot;sfdc-blaze-server/classes&quot;. This will compile your classes directly into your <strong>WEB-INF/classes</strong> directory for you. Your screen should look like the following:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399669/blaze-tutorial-6_pjza6o.png" alt="" ></p>
<h2 style="padding-top:20px;">Import the Salesforce.com WSDL</h2>
<p>For your Java application to connect with  SFDC we need to download the Salesforce.com WDSL. Log into your Developer org and go to Setup -&gt; Develop -&gt; API. You can download either the Enterprise or Developer WSDL but for this tutorial we’ll use the Enterprise WDSL as it makes life a little easier. Save this file in your Eclipse project as &quot;enterprise.wsdl&quot;.</p>
<p>To create the Java code, right click on enterprise.wsdl and choose Web Services -&gt; Generate Client. Select the defaults on the screen and click Finish. This runs WSDL2Java and generates the source for Salesforce.com and compiles it into your <strong>classes</strong> directory underneath Tomcat. Your Eclipse project should look like the image below:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399638/blaze-tutorial-7_ynyax4.png" alt="" ></p>
<h2 style="padding-top:20px;">Add Additional Jars for Web Services</h2>
<p>For the web services integration with Salesforce.com, you will need to add the following jar files to your <strong>sfdc-blazeds/WEB-INF/lib</strong> directory in Tomcat. These jars are all contained in the code for this tutorial.</p>
<ul>
	<li>activation.jar</li>
	<li>axis.jar</li>
	<li>commons-discovery-0.2.jar</li>
	<li>jaxrpc.jar</li>
	<li>log4j-1.2.15.jar</li>
	<li>mailer.jar</li>
	<li>saaj.jar</li>
	<li>wsdl4j-1.5.1.jar</li>
</ul>
<h2 style="padding-top:20px;">Create your Java Objects</h2>
<p>The server-side portion of this application implements a simple service layer and value object patterns:</p>
<ul>
	<li>SfdcService – the service class that provides the connection to Salesforce.com and data access logic to fetch the Accounts</li>
	<li>Company – a simple POJO that is transferred between the server and client.</li>
</ul>
<h2 style="padding-top:20px;">Create your Service Object</h2>
<p>Click on File -&gt; New -&gt; Class, enter your package name (com.jeffdouglas.flex), class name (SfdcService) and click Finish. Add the following code for the class. Be sure to add your Salesforce.com Developer username and password (and security token if needed) into your code.</p>
<pre><code>package com.jeffdouglas.flex;

import com.sforce.soap.enterprise.*;
import com.sforce.soap.enterprise.SessionHeader;
import com.sforce.soap.enterprise.SforceServiceLocator;
import com.sforce.soap.enterprise.SoapBindingStub;
import com.sforce.soap.enterprise.fault.*;
import com.sforce.soap.enterprise.sobject.*;
import java.rmi.RemoteException;
import java.util.Vector;

public class SfdcService {

    private SoapBindingStub binding;
    private LoginResult loginRes = null;

    private final String SFDC_USERNAME = &quot;YOUR_USERNAME&quot;;
    private final String SFDC_PASSWORD = &quot;YOUR_PASSWORD&quot;; // may need your security token

    // fetch 10 accounts and return as a vector of Companies
    public Vector&lt;company&gt; getAccounts() {

        Vector&lt;company&gt; v = new Vector&lt;company&gt;();
        QueryResult qr = null;

        // log into Salesforce.com
        if (login()) {

            try {
                qr = binding.query(&quot;Select Id, Name From Account Limit 10&quot;);
                if (qr.getSize() &gt; 0){
                    for (int i=0;i&lt;qr.getRecords().length;i++) {
                        Account a = (Account)qr.getRecords(i);
                        Company c = new Company();
                        c.setId(a.getId());
                        c.setName(a.getName());
                        v.add(c);
                    }
                }
            } catch (Exception e) {
                System.out.println(e.toString());
            }

        } else {
            System.out.println(&quot;Not logged into Salesforce.com&quot;);
        }

        return v;

    }

    // helper method to test the remoting
    public String sayHello() {
        return &quot;Hello World!&quot;;
    }

    // log into Salesforce.com
    private boolean login() {
        try {

            //Provide feed back while we create the web service binding
            System.out.println(&quot;Creating the binding to the web service...&quot;);

            //Create the binding to the sforce service
            binding = (SoapBindingStub) new SforceServiceLocator().getSoap();

            //Time out after a minute
            binding.setTimeout(60000);

            try {
                //Attempt the login giving the user feedback
                System.out.println(&quot;LOGGING IN NOW....&quot;);
                loginRes = binding.login(SFDC_USERNAME, SFDC_PASSWORD);
            } catch (LoginFault ex2) {
                System.out.println(&quot;Login failure: &quot;+ex2.getExceptionMessage());
                return false;
            } catch (RemoteException ex2) {
                System.out.println(&quot;Remote Login failure: &quot;+ex2.getMessage());
                return false;
            }

            System.out.println(&quot;The session id is:&quot; + loginRes.getSessionId());
            System.out.println(&quot;The new server url is:&quot; + loginRes.getServerUrl());

            binding._setProperty(SoapBindingStub.ENDPOINT_ADDRESS_PROPERTY, loginRes.getServerUrl());
            // Create a new session header object
            SessionHeader sh = new SessionHeader();
            // add the session ID returned from the login
            sh.setSessionId(loginRes.getSessionId());
            //.Set the session header for subsequent call authentication
            binding.setHeader(new SforceServiceLocator().getServiceName().getNamespaceURI(),&quot;SessionHeader&quot;, sh); 

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return true;
    }

}

</code></pre>
<h2 style="padding-top:20px;">Create your Value Object</h2>
<p>Create your Value Object to hold the Account’s id and name. Click on File -&gt; New -&gt; Class, enter your package name (com.jeffdouglas.flex), class name (Company) and click Finish. Add the following code for the class:</p>
<pre><code>package com.jeffdouglas.flex;

public class Company {

	private String Id;
	private String Name;

	public String getId() {
		return Id;
	}
	public void setId(String id) {
		Id = id;
	}
	public String getName() {
		return Name;
	}
	public void setName(String name) {
		Name = name;
	}

}

</code></pre>
<h2 style="padding-top:20px;">Create your Remoting Destination</h2>
<p>A Remoting destination exposes a Java class that your Flex application can invoke remotely. The destination id is a logical name that your Flex application uses to refer to the remote class, which eliminates the need to hardcode a reference to the fully qualified Java class name. This logical name is mapped to the Java class name as part of the destination configuration in remoting-config.xml. Open the remoting-config.xml file in your WEB-INF/flex directory and add the following destination:</p>
<pre><code>&lt;destination id=&quot;sfdcService&quot;&gt;
&lt;properties&gt;
        &lt;source&gt;com.jeffdouglas.flex.SfdcService&lt;/source&gt;
    &lt;/properties&gt;
&lt;/destination&gt;
</code></pre>
<p>Your remoting-config.xml file should look like:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399637/blaze-tutorial-21_c0y8r4.png" alt="" ></p>
<h2 style="padding-top:20px;">Create your Flex Project</h2>
<p>Create your Flex application by selecting File -&gt; New -&gt; Flex Project in the Eclipse menu. Enter “sfdc-client” as the project name and configure it based upon the images below. Click Next.</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399636/blaze-tutorial-8_yb6wjv.png" alt="" ></p>
<p>Make sure the root folder for LiveCycle Data Services matches the root folder of your BlazeDS web application. The settings should look similar to these:</p>
<p>Root Folder: /Applications/apache-tomcat-5.5.25/webapps/blazeds<br>
Root URL: <a href="http://localhost:8080/blazeds">http://localhost:8080/blazeds</a><br>
Context Root: /blazeds</p>
<p>Click Validate Configuration and then Finish. Your screen should look similar to the one below:</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399635/blaze-tutorial-9_cwovim.png" alt="" ></p>
<p>Once your project has been created, open main.mxml and add the following code:</p>
<pre><code class="language-javascript">&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;mx:Application xmlns:mx=&quot;http://www.adobe.com/2006/mxml&quot;
	layout=&quot;absolute&quot; width=&quot;600&quot; height=&quot;400&quot;&gt;

	&lt;mx:RemoteObject id=&quot;sfdc&quot;
		destination=&quot;sfdcService&quot;
		showBusyCursor=&quot;true&quot;&gt;
		&lt;mx:method name=&quot;sayHello&quot; result=&quot;helloHandler(event)&quot; fault=&quot;faultHandler(event)&quot; /&gt;
		&lt;mx:method name=&quot;getAccounts&quot; result=&quot;accountsHandler(event)&quot; fault=&quot;faultHandler(event)&quot; /&gt;
	&lt;/mx:RemoteObject&gt;

	&lt;mx:Script&gt;
		&lt;![CDATA[
		import mx.controls.Alert;
		import mx.collections.ArrayCollection;
		import mx.rpc.events.FaultEvent;
		import mx.rpc.events.ResultEvent;

		[Bindable]
		private var companies:ArrayCollection;

		private function helloHandler(event:ResultEvent):void {
			Alert.show(event.result.toString());
		}

		private function accountsHandler(event:ResultEvent):void {
			companies = event.result as ArrayCollection;
		}

		private function faultHandler(event:FaultEvent):void {
			Alert.show(event.fault.faultString);
		}
		]]&gt;
	&lt;/mx:Script&gt;

	&lt;mx:Label x=&quot;10&quot; y=&quot;10&quot; text=&quot;Salesforce.com / BlazeDS Account Demo&quot; color=&quot;#FFFFFF&quot; fontSize=&quot;25&quot;/&gt;
	&lt;mx:Button x=&quot;10&quot; y=&quot;70&quot; label=&quot;Fetch Accounts from Salesforce.com&quot; click=&quot;sfdc.getAccounts()&quot;/&gt;
	&lt;mx:Button x=&quot;482&quot; y=&quot;70&quot; label=&quot;Say Hello&quot; click=&quot;sfdc.sayHello()&quot;/&gt;
	&lt;mx:DataGrid id=&quot;dg&quot; dataProvider=&quot;{companies}&quot; left=&quot;10&quot; right=&quot;10&quot; bottom=&quot;10&quot; top=&quot;100&quot;&gt;
		&lt;mx:columns&gt;
			&lt;mx:DataGridColumn headerText=&quot;Id&quot; dataField=&quot;id&quot;/&gt;
			&lt;mx:DataGridColumn headerText=&quot;Name&quot; dataField=&quot;name&quot;/&gt;
		&lt;/mx:columns&gt;
	&lt;/mx:DataGrid&gt;
&lt;/mx:Application&gt;

</code></pre>
<h2 style="padding-top:20px;">Create your ActionScript Value Object</h2>
<p>Right-click the src folder in the sfdc-client project and select New -&gt; ActionScript Class. Enter the class name as “Company” and click Finish. Add the following code:</p>
<pre><code class="language-javascript">package
{
    [Bindable]
    [RemoteClass(alias=&quot;com.jeffdouglas.flex.Company&quot;)]
    public class Company
    {

        public var Id:String;
        public var Name:String;

    }
}

</code></pre>
<p>Notice that the code uses the [RemoteClass(alias=&quot; com.jeffdouglas.flex.Company&quot;)] annotation to map the ActionScript version of the Company class (Company.as) to the Java version (Company.java). As a result, Company objects returned by the getAccounts() method of the service layer are deserialized into instances of the ActionScript Company classes automatically for you.</p>
<h2 style="padding-top:20px;">Run the Application</h2>
<p>Now compile, run and test your application.</p>

