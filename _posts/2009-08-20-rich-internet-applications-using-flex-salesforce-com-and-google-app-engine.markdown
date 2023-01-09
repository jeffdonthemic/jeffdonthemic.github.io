---
layout: post
title:  Rich Internet Applications Using Flex, Salesforce.com and Google App Engine
description: Cross-posted at the Appirio Technology Blog It’s fairly common these days to see Flex applications running inside Salesforce.com. But what if youd like to run your Flex applications on another SaaS provider like Google App Engine or Amazon EC2. We are going to set up a simple Flex application that fetches Accounts and Opportunities from Salesforce.com using an open source remoting library that runs on Google App Engine. Here a quick peak at the final application-  You can run this demo at-  http
date: 2009-08-20 14:06:27 +0300
image:  '/images/slugs/rich-internet-applications-using-flex-salesforce-com-and-google-app-engine.jpg'
tags:   ["2009", "public"]
---
<p>Cross-posted at the <a href="http://techblog.appirio.com/2009/08/rich-internet-applications-using-flex.html" target="_blank">Appirio Technology Blog</a></p>
<p>It’s fairly common these days to see Flex applications running inside Salesforce.com. But what if you'd like to run your Flex applications on another SaaS provider like Google App Engine or Amazon EC2. We are going to set up a simple Flex application that fetches Accounts and Opportunities from Salesforce.com using an open source remoting library that runs on Google App Engine. Here a quick peak at the final application:</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399511/flex-graniteds-screenshot_d9pepz.png"><img class="alignnone size-medium wp-image-1116" title="flex-graniteDS-screenshot" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_211,w_300/v1400399511/flex-graniteds-screenshot_d9pepz.png" alt="flex-graniteDS-screenshot" width="300" height="211" /></a></p>
<p><strong>You can run this demo at: </strong><a href="http://jeffdouglas-sfdc-graniteds.appspot.com/main.html" target="_blank"><strong>http://jeffdouglas-sfdc-graniteds.appspot.com/main.html</strong></a></p>
<p>Flex can communicate with a Java backend using HTTP, SOAP-based web services or Adobe’s proprietary AMF format. There are a number of open source AMF implementations including Aodobe BlazeDS, WebORB and GraniteDS. These implementations allow you to communicate via JMS or Flex remoting and are more efficient and exponentially faster than using XML across the wire. For this application we are going to be utilizing <a href="http://sourceforge.net/projects/granite/" target="_blank">GraniteDS</a>. The GraniteDS remoting service is a high performance data transfer service that allows your Flex applications to directly invoke Java object methods on your application and consume the return values natively. The objects returned from the server-side methods are automatically deserialized into either dynamic or typed ActionScript objects.</p>
<p><strong>Setting Up Your Environment</strong></p>
<p>To get started you'll need to <a href="http://www.adobe.com/cfusion/entitlement/index.cfm?e=flexbuilder3" target="_blank">download</a> the Adobe Flex 3.0 Builder 3 or Flex 3 Builder Plug-In. There’s a 60 day trial if you don’t already have a license. Installation is pretty straight-forward if you are familiar with the Eclipse installation process. The plug-in is a little easier and quicker to install.</p>
<p>If you don't have a Google App Engine account, you can create one <a href="http://appengine.google.com" target="_blank">here</a>. You'll also need to download and install the Google App Engine SDK and Eclipse plug-in. You can find details on this process <a href="http://code.google.com/appengine/downloads.html" target="_blank">here</a>.</p>
<p><strong>Creating Your Project</strong></p>
<p>Now that our environment is setup, create a new Web Application Project and uncheck “Use Google Web Toolkit”. Since we are going to be using Flex as the front end for our application you will want to add the Flex Project Nature to your project. Right click on the project name in the left panel and select Flex Project Nature -> Add Flex Project Nature. Choose “Other” as the application server and click Next and then Finish. This will automatically create your Flex main.mxml file for you in the src directory.</p>
<p>After the file has been created you should see the following error message in the Eclipse Problems tab, "Cannot create HTML wrapper. Right-click here to recreate folder html-template." To fix this simply right click on the error message and select “Recreate HTML Templates”.</p>
<p><strong>Adding Required Libraries</strong></p>
<p>There are a number of libraries that we are going to need for Salesforce.com and GraniteDS. Download the latest version of GraniteDS from <a href="http://sourceforge.net/projects/granite/files/" target="_blank">here</a>, unzip the files, find the granite.jar in the graniteds/build/ directory and place it into your project’s /WEB-INF/lib/ directory.</p>
<p>You’ll also need to get the latest version of Xalan-J from <a href="http://www.apache.org/dyn/closer.cgi/xml/xalan-j" target="_blank">here</a>. Unzip the files and copy serializer.jar and xalan.jar into your project’s /WEB-INF/lib directory.</p>
<p>There are two jar files you will need for the Salesforce.com integration. Download the Force.com Web Service Connector files from <a href="http://code.google.com/p/sfdc-wsc/downloads/list" target="_blank">here</a> and copy them to your project's /WEB-INF/lib directory:</p>
<ul>
	<li>partner-library.jar - the objects and methods from the Force.com partner WSDL</li>
	<li>wsc-gae-16_0.jar - the Web Service parsing and transport for GAE-Java</li>
</ul>
You'll need to add these new jar files to your Java build path in Eclipse by right clicking on the project name and selecting Properties. Select Java Build Path -> Libraries and add your jars from the lib directory.
<p><strong>Server Configuration</strong></p>
<p>So now that we have all of requirements in place we can start configuring our application. Place the following code into your /WEB-INF/web-xml file between the tags to tell App Engine which classes GraniteDS utilizes.</p>
{% highlight js %}<!-- GraniteDS -->
	<listener>
	<listener-class>org.granite.config.GraniteConfigListener</listener-class>
</listener>

<!-- handle AMF requests serialization and deserialization -->
<filter>
 <filter-name>AMFMessageFilter</filter-name>
 <filter-class>org.granite.messaging.webapp.AMFMessageFilter</filter-class>
</filter>
<filter-mapping>
 <filter-name>AMFMessageFilter</filter-name>
 <url-pattern>/graniteamf/*</url-pattern>
</filter-mapping>

<!-- processes AMF requests -->
<servlet>
 <servlet-name>AMFMessageServlet</servlet-name>
 <servlet-class>org.granite.messaging.webapp.AMFMessageServlet</servlet-class>
 <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
 <servlet-name>AMFMessageServlet</servlet-name>
 <url-pattern>/graniteamf/*</url-pattern>
</servlet-mapping>

{% endhighlight %}
<p>You'll also want to change the welcome-file to specify main.html instead of the generated index.html file.</p>
<p>GraniteDS communicates with the servlet container via a remoting destination. A Remoting destination exposes a Java class that your Flex application can invoke remotely. The destination id is the logical name that your Flex application uses to refer to the remote class. This eliminates the need to hardcode a reference to the fully qualified Java class name. This logical name is mapped to the Java class name as part of the destination configuration in services-config.xml. Create a new folder under /WEB-INF/ called “flex” and create the following services-config.xml file.</p>
{% highlight js %}<?xml version="1.0" encoding="UTF-8"?>
<services-config>
 <services>
   <service
    id="granite-service"
    class="flex.messaging.services.RemotingService"
    messageTypes="flex.messaging.messages.RemotingMessage">
    <destination id="Gateway">
    <channels>
     <channel ref="my-graniteamf"/>
    </channels>
<properties>
     <scope>application</scope>
     <source>com.appirio.Gateway</source>
    </properties>
    </destination>
   </service>
 </services>

 <channels>
   <channel-definition id="my-graniteamf" class="mx.messaging.channels.AMFChannel">
    <endpoint
    uri="/graniteamf/amf"
    class="flex.messaging.endpoints.AMFEndpoint"/>
   </channel-definition>
 </channels>
</services-config>

{% endhighlight %}
<p>Our remoting destination points to a class called Gateway that we will create shortly. Now we need to tell the Flex compiler where to find the services file that defines our remoting destination. Right click on the project name in the left panel and select Properties -> Flex Compiler. Replace your compiler arguments with the following:</p>
<blockquote>-locale en_US -services ../war/WEB-INF/flex/services-config.xml</blockquote>
<strong>Client-Side Code</strong>
<p>Now that our server is configured we can start working on the Flex client. Our client is fairly simple and allows a user select an Account and view/create Opportunities for it. The Flex portion of the application is represented by a single MXML file. For larger applications you would typically break your application into an MVC model and possibly use some sort of Flex framework like Cairngorm, Mate or PureMVC. Since our application is so small there is really no need to implement any sort of framework.</p>
<p>One of the most important parts of this file is the RemoteObject tag at the top. The id of the tag (gateway) is used by the application to reference the object while the destination (Gateway) is same destination we set up in our services-config.xml file specifying our remoting destination of com.appirio.Gateway.</p>
<p>The individual methods specified by the RemoteObject tag map directly to methods in the Gateway class that we are about to define.</p>
{% highlight js %}<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
	layout="absolute"
	creationComplete="gateway.getAccounts()">

 <mx:RemoteObject id="gateway" destination="Gateway" fault="Alert.show(event.fault.toString());">
   <mx:method name="getAccounts" result="storeAccounts(event)" fault="Alert.show(event.fault.faultString);" />
   <mx:method name="getOpportunities" result="storeOpportunities(event)" fault="Alert.show(event.fault.faultString);" />
   <mx:method name="createOpportunity" result="fetchOpportunities(event)" fault="Alert.show(event.fault.faultString);" />
 </mx:RemoteObject>

	<mx:Script>
	<![CDATA[
		import mx.controls.Alert;
		import mx.collections.ArrayCollection;
		import mx.rpc.events.ResultEvent;

		[Bindable] private var accounts:ArrayCollection;
		[Bindable] private var opportunities:ArrayCollection;
		[Bindable] private var selectedAccount:Account;

		// store the accounts returned from Salesforce.com, select the first account as
		// the currently selected one and then fetch its opportunities from Salesforce.com
		private function storeAccounts(event:ResultEvent):void {
			accounts = event.result as ArrayCollection;
			selectedAccount = accounts.getItemAt(0) as Account;
			gateway.getOpportunities(selectedAccount.id);
		}

		// store the list of opportunities returned from Salesforce.com
		private function storeOpportunities(event:ResultEvent):void {
			opportunities = event.result as ArrayCollection;
		}

		// fetch the opportunities from Salesforce.com after a new opportunities has been created
		// and returned from the createOpportunity() remote object method
		private function fetchOpportunities(event:ResultEvent):void {
			gateway.getOpportunities(selectedAccount.id);
		}

		private function changeAccount():void {
			opportunities = null;
			selectedAccount = cbxAccount.selectedItem as Account;
			gateway.getOpportunities(selectedAccount.id);
		}

		private function saveOpportunity():void {

			var opp:Opportunity = new Opportunity();
			opp.accountId = selectedAccount.id;
			opp.probability = frmProbability.text;
			opp.stageName = frmStage.text;
			opp.amount = frmAmount.text;
			opp.closeDate = dateFormatter.format(frmCloseDate.selectedDate);
			opp.name = frmName.text;
			opp.orderNumber = frmOrder.text;

			// create the opportunity
			gateway.createOpportunity(opp);

			// reset the form
			frmProbability.selectedIndex = 0;
			frmStage.selectedIndex = 0;
			frmAmount.text = null;
			frmCloseDate.selectedDate = null;
			frmName.text = null;
			frmOrder.text = null;

		}

	]]>
	</mx:Script>

	<mx:DateFormatter id="dateFormatter" formatString="MM/DD/YYYY"/>

	<mx:Label x="10" y="14" text="Telesales Demo with Salesforce.com, GraniteDS and Google App Engine" fontSize="18" color="#FFFFFF"/>

	<mx:VBox top="50" bottom="10" left="10" right="10">
		<mx:HBox width="100%" height="50%">
			<mx:Panel width="50%" height="100%" layout="absolute" title="Account Display">
				<mx:Form width="100%" height="100%">
					<mx:FormItem label="Account">
						<mx:ComboBox
							id="cbxAccount"
							dataProvider="{accounts}"
							labelField="name"
							change="changeAccount()"/>
					</mx:FormItem>
					<mx:FormItem label="City">
						<mx:Text text="{selectedAccount.city}"/>
					</mx:FormItem>
					<mx:FormItem label="State">
						<mx:Text text="{selectedAccount.state}"/>
					</mx:FormItem>
					<mx:FormItem label="Phone">
						<mx:Text text="{selectedAccount.phone}"/>
					</mx:FormItem>
					<mx:FormItem label="Website">
						<mx:Text text="{selectedAccount.website}"/>
					</mx:FormItem>
				</mx:Form>
			</mx:Panel>
			<mx:Panel width="50%" height="100%" layout="absolute" title="New Opportunity for {selectedAccount.name}">
				<mx:Form width="100%" height="100%">
					<mx:FormItem label="Name">
						<mx:TextInput id="frmName"/>
					</mx:FormItem>
					<mx:FormItem label="Amount">
						<mx:TextInput id="frmAmount"/>
					</mx:FormItem>
					<mx:FormItem label="Stage">
						<mx:ComboBox id="frmStage">
							<mx:dataProvider>
								<mx:String>Prospecting</mx:String>
								<mx:String>Qualifications</mx:String>
								<mx:String>Value Proposition</mx:String>
							</mx:dataProvider>
						</mx:ComboBox>
					</mx:FormItem>
					<mx:FormItem label="Probability">
						<mx:ComboBox id="frmProbability">
							<mx:dataProvider>
								<mx:String>10</mx:String>
								<mx:String>25</mx:String>
								<mx:String>50</mx:String>
								<mx:String>75</mx:String>
							</mx:dataProvider>
						</mx:ComboBox>
					</mx:FormItem>
					<mx:FormItem label="Close Date">
						<mx:DateField id="frmCloseDate"/>
					</mx:FormItem>
					<mx:FormItem label="Order">
						<mx:TextInput id="frmOrder"/>
					</mx:FormItem>
					<mx:FormItem>
						<mx:Button label="Save Opportunity" click="saveOpportunity()"/>
					</mx:FormItem>
				</mx:Form>
			</mx:Panel>
		</mx:HBox>
		<mx:Panel width="100%" height="50%" layout="absolute" title="Opportunities for {selectedAccount.name}">
			<mx:DataGrid width="100%" height="100%" id="dgOpps" dataProvider="{opportunities}">
				<mx:columns>
					<mx:DataGridColumn headerText="Name" dataField="name"/>
					<mx:DataGridColumn headerText="Amount" dataField="amount"/>
					<mx:DataGridColumn headerText="Stage" dataField="stageName"/>
					<mx:DataGridColumn headerText="Probability" dataField="probability"/>
					<mx:DataGridColumn headerText="Close Date" dataField="closeDate"/>
					<mx:DataGridColumn headerText="Order" dataField="orderNumber"/>
				</mx:columns>
			</mx:DataGrid>
		</mx:Panel>
	</mx:VBox>

</mx:Application>

{% endhighlight %}
<p>One last thing we need for the front end are Account and Opportunity value objects. Right-click the src folder and select New -> ActionScript Class. Enter the class name as and click Finish. Add the following code to these classes. Notice that the code uses the [RemoteClass(alias=" com.appirio.Account")] annotation to map the ActionScript version of the Account class (Account.as) to the Java version (Account.java). As a result, Account objects returned by methods of the Java object in the service layer that are deserialized into instances of the ActionScript Account class automatically for you.</p>
{% highlight js %}package
{
	[Bindable]
	[RemoteClass(alias="com.appirio.Account")]
	public class Account
	{

		public var id:String;
		public var name:String;
		public var city:String;
		public var state:String;
		public var phone:String;
		public var website:String;

	}
}

{% endhighlight %}
{% highlight js %}package
{
	[Bindable]
	[RemoteClass(alias="com.appirio.Opportunity")]
	public class Opportunity
	{

		public var id:String;
		public var name:String;
		public var amount:String;
		public var stageName:String;
		public var probability:String;
		public var closeDate:String;
		public var orderNumber:String;
		public var accountId:String;

	}
}

{% endhighlight %}
<p><strong>Server-Side Code</strong></p>
<p>So now back to the server-side to finish up our application. We need to add the POJOs to model our Account and Opportunity object returned from Salesforce.com. These classes will consist of the same members as the ActionScript classes so that GraniteDS can translate them back and forth for us.</p>
{% highlight js %}package com.appirio;

public class Account {

	private String id;
	private String name;
	private String city;
	private String state;
	private String phone;
	private String website;

	public Account(String id, String name, String city, String state, String phone, String website) {
		this.id = id;
		this.name = name;
		this.city = city;
		this.state = state;
		this.phone = phone;
		this.website = website;
	}

	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getWebsite() {
		return website;
	}
	public void setWebsite(String website) {
		this.website = website;
	}
}

{% endhighlight %}
{% highlight js %}package com.appirio;

public class Opportunity {

	private String id;
	private String name;
	private String amount;
	private String stageName;
	private String probability;
	private String closeDate;
	private String orderNumber;
	private String accountId;

	public Opportunity(String id, String name, String amount, String stageName, String probability, String closeDate, String orderNumber) {
		this.id = id;
		this.name = name;
		this.amount = amount;
		this.stageName = stageName;
		this.probability = probability;
		this.closeDate = closeDate;
		this.orderNumber = orderNumber;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}

	public String getStageName() {
		return stageName;
	}

	public void setStageName(String stageName) {
		this.stageName = stageName;
	}

	public String getProbability() {
		return probability;
	}

	public void setProbability(String probability) {
		this.probability = probability;
	}

	public String getCloseDate() {
		return closeDate;
	}

	public void setCloseDate(String closeDate) {
		this.closeDate = closeDate;
	}

	public String getOrderNumber() {
		return orderNumber;
	}

	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

}

{% endhighlight %}
<p>The last part of our application is the Gateway class that GraniteDS uses as the remoting endpoint. This class contains the methods that our Flex front-end calls via the RemoveObject tag.</p>
{% highlight js %}package com.appirio;

import java.text.DateFormat;
import java.util.logging.Logger;
import java.util.Date;
import java.util.Vector;

import com.sforce.soap.partner.Connector;
import com.sforce.soap.partner.PartnerConnection;
import com.sforce.soap.partner.QueryResult;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;
import com.sforce.soap.partner.sobject.SObject;

public class Gateway {

	private static final Logger log = Logger.getLogger(Gateway.class.getName());
	private String username = "YOUR-SALESFORCE-USERNAME";
	private String password = "YOUR-SALESFORCE-PASSWORD-AND-TOKEN";
	private PartnerConnection connection;

	// query for 10 accounts in Salesforce.com
	public Vector<account> getAccounts() {

		// get a new connection to Salesforce.com ising the Force.com Web Service Connector (WSC) toolkit
		getConnection();

		QueryResult result = null;
		Vector<account> accounts = new Vector<account>();

		try {
			result = connection.query("Select Id, Name, Phone, BillingCity, BillingState, website from Account LIMIT 10");

			if (result.getSize() > 0) {

				for (SObject account : result.getRecords()) {
					Account a = new Account(
							(String)account.getField("Id"),
							(String)account.getField("Name"),
							(String)account.getField("BillingCity"),
							(String)account.getField("BillingState"),
							(String)account.getField("Phone"),
							(String)account.getField("website")
						);
					accounts.add(a);

				}

			}

		} catch (ConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return accounts;

	}

	// query for all opportunities for an account
	public Vector<opportunity> getOpportunities(String accountId) {

		// get a new connection to Salesforce.com ising the Force.com Web Service Connector (WSC) toolkit
		getConnection();

		QueryResult result = null;
		Vector<opportunity> opportunities = new Vector<opportunity>();

		try {
			result = connection.query("Select id, name, stagename, amount, closeDate, probability, ordernumber__c from Opportunity where AccountId = '"+accountId+"'");

			if (result.getSize() > 0) {

				for (SObject opp : result.getRecords()) {
					Opportunity o = new Opportunity(
							(String)opp.getField("Id"),
							(String)opp.getField("Name"),
							(String)opp.getField("Amount"),
							(String)opp.getField("StageName"),
							(String)opp.getField("Probability"),
							(String)opp.getField("CloseDate"),
							(String)opp.getField("OrderNumber__c")
						);
					opportunities.add(o);
				}

			}

		} catch (ConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return opportunities;

	}

	// create a new opportunity in Salesforce.com
	public Boolean createOpportunity(Opportunity o) {

		// get a new connection to Salesforce.com ising the Force.com Web Service Connector (WSC) toolkit
		getConnection();

		Boolean success = true;
		Date closeDate = new Date();

		// try and parse the date
  try {
  	DateFormat df = DateFormat.getDateInstance(3);
  	closeDate = df.parse(o.getCloseDate());
  } catch(java.text.ParseException pe) {
  System.out.println("Exception " + pe);
  }

  // populate the new opportunity
  SObject opp = new SObject();
  opp.setType("Opportunity");
  opp.setField("Name", o.getName());
  opp.setField("Amount", new Double(o.getAmount()).doubleValue());
  opp.setField("StageName", o.getStageName());
  opp.setField("Probability", new Double(o.getProbability()).doubleValue());
  opp.setField("CloseDate", closeDate);
  opp.setField("OrderNumber__c", o.getOrderNumber());
  opp.setField("AccountId", o.getAccountId());

  SObject[] opportunities = {opp};

		try {
			connection.create(opportunities);
		} catch (ConnectionException e) {
			// TODO Auto-generated catch block
  	success = false;
			e.printStackTrace();
		}

		return success;

	}

 	void getConnection() {
		try {
		  if ( connection == null ) {
			  log.info("Fetching new connection....");
			  // login to salesforce
			  ConnectorConfig config = new ConnectorConfig();
			  config.setUsername(username);
			  config.setPassword(password);
			  connection = Connector.newConnection(config);
		  } else {
			  log.info("Reusing existing connection....");
		  }
		} catch ( ConnectionException ce) {
			log.warning("ConnectionException " +ce.getMessage());
		}

	}

}
{% endhighlight %}
<p>Our last step before uploading our application to Google App Engine is to build and export for deployment. Right click on the project name in the left panel and select Export. Choose Flex Builder folder -> Release Build -> Next. In the Export to folder section browse to your war for the project. We want to build our Flex application to this folder so that the App Engine plug-in will deploy this code to App Engine along with our Java code.</p>
<p>Our last step it is to create a new App Engine application and upload our code to Google's servers. There is detailed help for uploading with the Eclipse plug-in <a href="http://code.google.com/appengine/docs/java/tools/eclipse.html" target="_blank">here</a>.</p>

