---
layout: post
title:  Cool Code at Lunch Webinar – Flex & Salesforce
description: I was the guest speaker on our Cool Code at Lunch webinar yesterday where I showed the basics of developing, upload and running a Flex application on Salesforce with the Force.com Toolkit for Adobe AIR and Flex. The example app was a simple DataGrid populated with Contacts.   The application turned out to be a really good starting point for most Flex applications so I thought Id post it and see if it helps anyone out. I has methods for querying, creating and deleting data. Youll need to download
date: 2009-09-25 18:57:31 +0300
image:  '/images/slugs/cool-code-at-lunch-webinar-flex-salesforce.jpg'
tags:   ["appirio", "code sample", "salesforce", "visualforce", "flex"]
---
<p>I was the guest speaker on our "Cool Code at Lunch" webinar yesterday where I showed the basics of developing, upload and running a Flex application on Salesforce with the Force.com Toolkit for Adobe AIR and Flex. The example app was a simple DataGrid populated with Contacts.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399500/coolcode-flex_nvzdtm.png"><img class="alignnone size-full wp-image-1372" title="CoolCode-Flex" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399500/coolcode-flex_nvzdtm.png" alt="CoolCode-Flex" width="544" height="290" /></a></p>
<p>The application turned out to be a really good starting point for most Flex applications so I thought I'd post it and see if it helps anyone out. I has methods for querying, creating and deleting data.</p>
<p>You'll need to download the Force.com Toolkit for Adobe AIR and Flex toolkit <a href="http://developer.force.com/flextoolkit" target="_blank">here</a> to run this example.</p>
<p><strong>Flex Application - main.mxml</strong></p>
{% highlight js %}&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;mx:Application xmlns:mx=&quot;http://www.adobe.com/2006/mxml&quot; layout=&quot;absolute&quot; width=&quot;600&quot; height=&quot;300&quot;
  backgroundGradientAlphas=&quot;[1.0, 1.0]&quot; backgroundGradientColors=&quot;[#FFFFFF, #FFFFFF]&quot; creationComplete=&quot;init()&quot;&gt;

 &lt;mx:Script&gt;
  &lt;![CDATA[

  import mx.collections.ArrayCollection;
  import mx.controls.Alert;
  import com.salesforce.*;
  import com.salesforce.objects.*;
  import com.salesforce.results.*;

  [Bindable] private var sfdc:Connection = new Connection();
  [Bindable] private var isLoggedIn:Boolean = false;
  [Bindable] private var contacts:ArrayCollection = new ArrayCollection();
  [Bindable] private var userId:String;

  private function init():void {
   login();
   if (Application.application.parameters.userId == null) {
     userId = &quot;005600000000000&quot;;
   } else {
     userId = Application.application.parameters.userId;
   }
  }

  private function getContacts():void
  {

  sfdc.query(&quot;select id, name, email from contact&quot;,
   new AsyncResponder(
    function (qr:QueryResult):void {
    if (qr.size &gt; 0) {
      for (var i:int=0;i&lt;qr.size;i++) {

       // create a new object to hold the data
       var c:Contact = new Contact();
       c.email = qr.records[i].Email;
       c.id = qr.records[i].Id;
       c.name = qr.records[i].Name;

       // add the object to the array collection
       contacts.addItem(c);

      }
    }
    },sfdcFailure
    )
  );

  }

  private function createContact(c:Contact):void {

   // create an array to send to sfdc
   var aSo:Array = new Array();

   // create a new contact sObject to populate with data
   var so:SObject = new SObject(&quot;Contact&quot;);
   so.FirstName = c.first;
   so.LastName = c.last;
   so.Email = c.email;

   // add the sObject to the array
   aSo.push(so);

   sfdc.create(aSo,
    new AsyncResponder(
     function createResults(obj:Object):void {
      if (obj[0].success == false) {
       Alert.show(obj[0].errors[0].message.toString(),&quot;Error creating new contact&quot;);
      } else {
       // do something like update the collection
      }
     }, sfdcFailure
    )
   );

  }

  public function updateContact(c:Contact):void {

   // create an array to send to sfdc
   var aSo:Array = new Array();

   // create a new contact sObject to populate with data
   var so:SObject = new SObject(&quot;Contact&quot;);
   so.Id = c.id;
   so.FirstName = c.first;
   so.LastName = c.last;
   so.Email = c.email;

   // add the sObject to the array
   aSo.push(so);

   sfdc.update(aSo,
    new AsyncResponder(
     function updateResults(obj:Object):void {
      if (obj[0].success == false) {
       mx.controls.Alert.show(obj[0].errors[0].message.toString(),&quot;Error updating contact&quot;);
      } else {
       // do something like update the collection
      }
     }, sfdcFailure
    )
   );
  }

  private function login():void {

  var lr:LoginRequest = new LoginRequest();

  // hard code values for dev/local
  if (this.parameters.server_url == null) {

   //sfdc.protocol = &quot;http&quot;;
   sfdc.serverUrl = &quot;http://na5.salesforce.com/services/Soap/u/14.0&quot;;
   lr.username = &quot;YOUR_USERNAME&quot;;
   lr.password = &quot;YOUR_PASSWORD&amp;YOUR_TOKEN&quot;;

  } else {

    lr.server_url = this.parameters.server_url;
    lr.session_id = this.parameters.session_id;
  }

  lr.callback = new AsyncResponder(loginSuccess, loginFault);
  sfdc.login(lr);

  }

  private function loginSuccess(result:Object):void {
  isLoggedIn = true;
  // start calling methods...
  getContacts();
  }

  private function loginFault(fault:Object):void {
  mx.controls.Alert.show(&quot;Could not log into SFDC: &quot;+fault.fault.faultString,&quot;Login Error&quot;);
  }

  private function sfdcFailure(fault:Object):void {
  Alert.show(fault.toString());
  }
  ]]&gt;
 &lt;/mx:Script&gt;

 &lt;mx:DataGrid left=&quot;5&quot; right=&quot;5&quot; top=&quot;5&quot; bottom=&quot;5&quot; id=&quot;dg&quot; dataProvider=&quot;{contacts}&quot;&gt;
  &lt;mx:columns&gt;
   &lt;mx:DataGridColumn headerText=&quot;Id&quot; dataField=&quot;id&quot;/&gt;
   &lt;mx:DataGridColumn headerText=&quot;Name&quot; dataField=&quot;name&quot;/&gt;
   &lt;mx:DataGridColumn headerText=&quot;Email&quot; dataField=&quot;email&quot;/&gt;
  &lt;/mx:columns&gt;
 &lt;/mx:DataGrid&gt;

&lt;/mx:Application&gt;

{% endhighlight %}
<p><strong> Contact Value Object - Contact.as</strong></p>
{% highlight js %}package
{
 public class Contact
 {
  public var id:String;
  public var first:String;
  public var last:String;
  public var name:String;
  public var email:String

 }
}
{% endhighlight %}
<p><strong> Visualforce page - MyPage.page</strong></p>
{% highlight js %}<apex:page>
  &lt;apex:flash src=&quot;{!$Resource.CoolCode}&quot;
  width=&quot;600&quot; height=&quot;300&quot;
  flashvars=&quot;userId={!$User.Id}&amp;session_id={!$Api.Session_ID}&amp;server_url={!$Api.Partner_Server_URL_130}&quot; /&gt;
</apex:page>
{% endhighlight %}

