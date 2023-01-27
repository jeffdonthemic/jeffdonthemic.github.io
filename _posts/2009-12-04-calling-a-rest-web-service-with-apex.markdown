---
layout: post
title:  Calling a REST Web Service (XML) with Apex
description: This is a cool little example of calling a REST web service with Apex. You enter your address and the Apex code fetches the geo coordinates from Yahoo! Maps. The service returns the data as XML. If you want to run this demo in your own org, you will need to do the following- 1. Add a Remote Site (Setup -> Security Controls -> Remote Site Setting) with   the URL- http-//local.yahooapis.com  2. Add the XML DOM parser class to your org. It may already be present but if   not you can download it fro
date: 2009-12-04 21:27:13 +0300
image:  '/images/slugs/calling-a-rest-web-service-with-apex.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>This is a cool little example of calling a REST web service with Apex. You enter your address and the Apex code fetches the geo coordinates from Yahoo! Maps. The service returns the data as XML.</p>
<p>If you want to run this demo in your own org, you will need to do the following:</p>
<ol>
 <li>Add a "Remote Site" (Setup -> Security Controls -> Remote Site Setting) with the URL: http://local.yahooapis.com</li>
 <li>Add the XML DOM parser class to your org. It may already be present but if not you can <a href="http://developer.force.com/codeshare/projectpage?id=a0630000002ahp5AAA" target="_blank">download it from Code Share</a>. Ron Hess' class makes life much easier than using the standard XmlReader when dealing with XML files.</li>
</ol>
<a href="https://jeffdouglas-developer-edition.na5.force.com/examples/RestDemo"><img class="alignnone size-full wp-image-1829" title="RestDemo" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399397/restdemo1_freyji.png" alt="" width="544" height="223" /></a>
<p><strong>You can </strong><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/RestDemo" target="_blank"><strong>run this example</strong></a><strong> on my Developer Site.</strong></p>
<p>The Visualforce page above presents the user with address fields that they submit to the controller. The controller calls the REST web service and then displays the resulting geo coordinates to the user.</p>
{% highlight js %}<apex:page controller="RestDemoController" tabStyle="Contact">
 <apex:sectionHeader title="Yahoo Maps Geocoding" subtitle="REST Demo"/>

 <apex:form >
 <apex:pageBlock >

   <apex:pageBlockButtons >
   <apex:commandButton action="{!submit}" value="Submit"
    rerender="resultsPanel" status="status"/>
   </apex:pageBlockButtons>
   <apex:pageMessages />

   This example calls Yahoo! Map geocoding REST service with the address
   you provide below.<p/>

   <apex:pageBlockSection >
    <apex:pageBlockSectionItem >
    <apex:outputLabel for="address">Address</apex:outputLabel>
    <apex:inputText id="address" value="{!address}"/>
    </apex:pageBlockSectionItem>
   </apex:pageBlockSection>

   <apex:pageBlockSection >
    <apex:pageBlockSectionItem >
    <apex:outputLabel for="city">City</apex:outputLabel>
    <apex:inputText id="city" value="{!city}"/>
    </apex:pageBlockSectionItem>
   </apex:pageBlockSection>

   <apex:pageBlockSection >
    <apex:pageBlockSectionItem >
    <apex:outputLabel for="state">State</apex:outputLabel>
    <apex:inputText id="state" value="{!state}"/>
    </apex:pageBlockSectionItem>
   </apex:pageBlockSection><br/>

   <apex:actionStatus id="status" startText="Fetching map..."/>
   <apex:outputPanel id="resultsPanel">
    <apex:outputText value="{!geoAddress}"/>
   </apex:outputPanel>

 </apex:pageBlock>
 </apex:form>

</apex:page>
{% endhighlight %}
<p>The submit method below is invoked from the Visualforce page when the user clicks the submit button. It passes the address info to the getMap method which does the GET call to the REST service. We use the XmlDom class to parse through the results and construct a GeoResult object (from the inner class) and then present the info as a String to the user on the Visualforce page.</p>
{% highlight js %}public class RestDemoController {

 public String geoAddress {get;set;}
 public String address {get;set;}
 public String city {get;set;}
 public String state {get;set;}

  // set the Yahoo Application Id
  private String appId {get;set { appId = 'DaqEkjjV34FCuqDUvZN92rQ9WWVQz58c0WHWo2hRGBuM310.qXefuBVwvJQaf1nnMCxSbg--'; } }

  // method called by the Visualforce page's submit button
  public PageReference submit() {
   List<GeoResult> results = getMap(address,city,state);
   geoAddress = results[0].toDisplayString();
   return null;
  }

  // call the REST service with the address info
 public List<GeoResult> getMap(String street, String city, String state) {

  HttpRequest req = new HttpRequest();
  Http http = new Http();
  List<GeoResult> results = new List<GeoResult>();

  // set the request method
  req.setMethod('GET');

  // set the yahoo maps url with address
  String url = 'http://local.yahooapis.com/MapsService/V1/geocode?appid=' + appId
   + '&amp;street=' + EncodingUtil.urlEncode(street,'UTF-8')
   + '&amp;city=' + EncodingUtil.urlEncode(city,'UTF-8')
   + '&amp;state=' + EncodingUtil.urlEncode(state,'UTF-8');

  // add the endpoint to the request
  req.setEndpoint(url);

  // create the response object
  HTTPResponse resp = http.send(req);

  // create the xml doc that will contain the results of the REST operation
  XmlDom doc = new XmlDom(resp.getBody());

  // process the results
  XmlDom.Element[] elements = doc.getElementsByTagName('Result');
  if (elements != null) {
   for (XmlDom.Element element : elements)
    results.add(toGeoResult(element));
  }

  return results;
 }

 // utility method to convert the xml element to the inner class
 private GeoResult toGeoResult(XmlDom.Element element) {

  GeoResult geo = new GeoResult();
  geo.latitude = element.getValue('Latitude');
  geo.longitude = element.getValue('Longitude');
  geo.address = element.getValue('Address');
  geo.city = element.getValue('City');
  geo.state = element.getValue('State');
  geo.zip = element.getValue('Zip');
  return geo;
 }

 // inner class
 private class GeoResult {

  public String latitude;
  public String longitude;
  public String address;
  public String city;
  public String state;
  public String zip;
  public String toDisplayString() {
   return address + ', '
   + city + ', '
   + state + ', '
   + zip + ' ['
   + latitude + ', '
   + longitude + ']';
  }

 }

}
{% endhighlight %}

