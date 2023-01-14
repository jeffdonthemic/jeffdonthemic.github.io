---
layout: post
title:  Calling a REST Web Service (JSON) with Apex
description: Cross-posted at the Appirio Tech Blog  . Using JSON RESTful Web Services with Salesforce.com opens up your org to a number third-party integration opportunities (Google, Yahoo!, Flickr, bespoke, etc.). JSON  support isnt baked into the Force.com platform but Ron Hess  at Salesforce.com has created a JSON parser  which will do the heavy lifting for you. Last month I wrote a blog post and example of how to call a REST Web Service with Apex that returns and consumes XML. It was my intention to do t
date: 2010-01-06 12:22:38 +0300
image:  '/images/slugs/calling-a-json-rest-web-service-with-apex.jpg'
tags:   ["appirio", "code sample", "google", "salesforce", "visualforce", "apex"]
---
<p>Cross-posted at the <a href="http://techblog.appirio.com/2010/01/calling-rest-web-service-json-with-apex.html" target="_blank">Appirio Tech Blog</a>.</p>
<p>Using JSON RESTful Web Services with Salesforce.com opens up your org to a number third-party integration opportunities (Google, Yahoo!, Flickr, bespoke, etc.). <a href="http://json.org" target="_blank">JSON</a> support isn't baked into the Force.com platform but <a href="http://twitter.com/vnehess">Ron Hess</a> at Salesforce.com has created a <a href="http://code.google.com/p/apex-library/">JSON parser</a> which will do the heavy lifting for you.</p>
<p>Last month I wrote a <a href="/2009/12/04/calling-a-rest-web-service-with-apex/" target="_blank">blog post</a> and example of how to call a REST Web Service with Apex that returns and consumes XML. It was my intention to do the same demo using JSON, however, I ran into a small sang. I couldn’t get the Apex JSONObject parser to work. I tried on and off for a couple of days but couldn't beat it into submission. I checked around the twitter-verse and no one reported much success using the JSON parser with complex objects. I <a href="/2009/12/28/problems-parsing-json-responses-with-apex/" target="_blank">finally cried "uncle"</a> and called Ron and asked for help. Ron was extremely responsive and over the course of a couple of days we worked worked through some of the <a href="http://code.google.com/p/apex-library/source/detail?r=13" target="_blank">parsing issues</a> and finally updated the Google project with the changes.</p>
<p><a href="https://jeffdouglas-developer-edition.na5.force.com/examples/RestDemoJson" target="_blank"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399351/REST-Json_ccpb02.png" alt="" title="REST-Json" width="500" class="alignnone size-full wp-image-1966" /></a></p>
<p>I put together a small demo where you enter your address and the Apex code fetches the address and coordinates from the Google Maps . The service returns the data as a JSON object. <strong>You can <a href="https://jeffdouglas-developer-edition.na5.force.com/examples/RestDemoJson" target="_blank">run this example</a> on my Developer Site.</strong></p>
<p>To get started, you'll need to <a href=" http://code.google.com/p/apex-library/source/browse/trunk/JSONObject/src/unpackaged/classes/JSONObject.cls" target="_blank">download the JSONObject class</a> and install it into a Developer org or Sandbox. Unfortunately there is no documentation for the parser so you have to extrapolate from the <a href="http://www.json.org/" target="_blank">json.org</a> website.</p>
<p>You'll also need to <a href="http://code.google.com/apis/maps/signup.html" target="_blank">sign up for a Google Maps API key</a> in order to use their geocoding service. I would also recommend that you take a <a href="http://code.google.com/apis/maps/documentation/geocoding/#JSON" target="_blank">look at the docs</a> for Google Maps geocoding service.</p>
<p>Here is the Controller for the demo. The interesting stuff is in the getAddress() and toGeoResult() methods. In getAddress(), the user-entered address is used to construct the URL for the GET call to the geocoding service. Make sure you properly encode the address or you may receive undesirable results returned from Google. One thing to point out is line #58. Google is returning a line feed in their JSON response which causes the JSON parser to choke. I simply replace all like feeds with spaces and that did the trick. Ron was going to look into making this change to the JSONObject class in the near future.</p>
<p>I was also having some problems with the geocoding service so I hard-coded the returned JSON object for testing. I checked around and it seems to be a <a href="http://www.google.com/search?hl=en&q=google+maps+620+error&aq=f&oq=&aqi=g1" target="_blank">common problem</a> that the Google Maps API randomly returns 620 errors when overloaded. <strong>You might want to take a look at the <a href="http://maps.google.com/maps/geo?q=1600+Amphitheatre+Parkway,+Mountain+View,+CA&output=json&sensor=false" target="_blank">JSON response returned</a> for the hard-coded address.</strong> I will give you a little insight for the parsing process.</p>
<p>The toGeoResult() method parses the returned JSON response and populates the GeoResult object with the appropriate data. I chose this Google Maps example because it shows how to parse simple values, nested JSON objects and arrays. The coordinates for the address can either be returned as integers or doubles so I have to check each one.</p>
{% highlight js %}public class RestDemoJsonController {

  public String geoAddress {get;set;}
  public String address {get;set;}
  public String city {get;set;}
  public String state {get;set;}
  public Boolean useGoogle {get;set;}

  // google api key
  private String apiKey {get;set { apiKey = 'ABQIAAAAlI0DHB0p0WGX35GrKEAzQhTwZth5GdZI-P7ekoe_gyhfzl1yZhRAYdM-hb7aEWu30fGchcvGuwuUqg'; } }

  // method called by the Visualforce page's submit button
  public PageReference submit() {

  	if (address.length() == 0) {
  		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Address cannot be blank'));
  	}
  	if (city.length() == 0) {
  		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'City cannot be blank'));
  	}
  	if (state.length() == 0) {
  		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'State cannot be blank'));
  	}

  	if (!ApexPages.hasMessages())
	  	geoAddress = getAddress(address,city,state);

  	return null;
  }

  // call the geocoding service
	private String getAddress(String street, String city, String state) {

		String json;

		// hard-coded returned JSON response from Google
		if (useGoogle) {
			json = '{ "name": "1600 Amphitheatre Parkway, Mountain View, CA", "Status": {  "code": 200,  "request": "geocode" }, "Placemark": [ {  "id": "p1",  "address": "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA",  "AddressDetails": {  "Accuracy" : 8,  "Country" : { "AdministrativeArea" : {   "AdministrativeAreaName" : "CA",   "SubAdministrativeArea" : {  "Locality" : {    "LocalityName" : "Mountain View",    "PostalCode" : {   "PostalCodeNumber" : "94043"    },    "Thoroughfare" : {   "ThoroughfareName" : "1600 Amphitheatre Pkwy"    }  },   '+
			'  "SubAdministrativeAreaName" : "Santa Clara"   } }, "CountryName" : "USA", "CountryNameCode" : "US"  }},  "ExtendedData": { "LatLonBox": {  "north": 37.4251466,  "south": 37.4188514,  "east": -122.0811574,  "west": -122.0874526 }  },  "Point": { "coordinates": [ -122.0843700, 37.4217590, 0 ]  } } ]}	';

		// call the geocoding service live
		} else {

			HttpRequest req = new HttpRequest();
			Http http = new Http();
			// set the method
			req.setMethod('GET');
			// generate the url for the request
			String url = 'http://maps.google.com/maps/geo?q='+ EncodingUtil.urlEncode(street,'UTF-8')+',+'
				+ EncodingUtil.urlEncode(city,'UTF-8')+',+'
				+ EncodingUtil.urlEncode(state,'UTF-8')
				+'&output=json&sensor=false&key='+apiKey;
			// add the endpoint to the request
			req.setEndpoint(url);
			// create the response object
			HTTPResponse resp = http.send(req);
			// the geocoding service is returning a line feed so parse it out
			json = resp.getBody().replace('n', '');

		}

		try {
			JSONObject j = new JSONObject( json );
			return toGeoResult(j).toDisplayString();
		} catch (JSONObject.JSONException e) {
			return 'Error parsing JSON response from Google: '+e;
		}

	}

	// utility method to convert the JSON object to the inner class
	private GeoResult toGeoResult(JSONObject resp) {

		GeoResult geo = new GeoResult();

		try {

			geo.address = resp.getValue('Placemark').values[0].obj.getValue('address').str;
			geo.keys = resp.keys();
			geo.name = resp.getString('name');
			geo.statusCode = resp.getValue('Status').obj.getValue('code').num;

			// set the coordinates - they may either be integers or doubles
			geo.coordinate1 = resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[0].num != NULL ? resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[0].num.format() : resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[0].dnum.format();
			geo.coordinate2 = resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[1].num != NULL ? resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[1].num.format() : resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[1].dnum.format();
			geo.coordinate3 = resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[2].num != NULL ? resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[2].num.format() : resp.getValue('Placemark').values[0].obj.getValue('Point').obj.getValue('coordinates').values[2].dnum.format();

		} catch (Exception e) {
			// #fail
		}

		return geo;
	}

	// inner class
	private class GeoResult {

		public Set<string> keys;
		public Integer statusCode;
		public String name;
		public String coordinate1;
		public String coordinate2;
		public String coordinate3;
		public String address;
		public String toDisplayString() {
			return address + ' ['
			+ coordinate1 + ', '
			+ coordinate2 + ', '
			+ coordinate3 + '] - Status: '
			+ statusCode;
		}

	}

}
{% endhighlight %}
<p>The Visualforce page is fairly simple and presents the user with a form to enter their address. If the geocoding services is experiencing issues, the user can check "Use hard-coded Google JSON response?" and the Controller with use the hard-coded JSON response instead of making the GET call to the geocoding service. Once submitted, the address is processed and the outputPanel is rerendered with the resulting address and coordinates.</p>
{% highlight js %}<apex:page controller="RestDemoJsonController" tabStyle="Contact">
	<apex:sectionHeader title="Google Maps Geocoding" subtitle="REST Demo (JSON)"/>

 <apex:form >
 <apex:pageBlock >

   <apex:pageBlockButtons >
   <apex:commandButton action="{!submit}" value="Submit"
    rerender="resultsPanel" status="status"/>
   </apex:pageBlockButtons>
   <apex:pageMessages />

   This example calls the Google Map geocoding REST service (JSON) with the address
   you provide below.<p/>

   Sometimes the geocoding services stops responding due to service availability. If you are receiving errors
   with the returned JSON object, you can check the "Use hard-coded JSON response" to use a returned JSON
   response hard-coded into the controller from the Googles address.<p/>

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

   <apex:pageBlockSection >
    <apex:pageBlockSectionItem >
    <apex:outputLabel for="useGoogle">Use hard-coded Google JSON response?</apex:outputLabel>
    <apex:inputCheckbox id="useGoogle" value="{!useGoogle}"/>
    </apex:pageBlockSectionItem>
   </apex:pageBlockSection><br/>

   <apex:actionStatus id="status" startText="Fetching map..."/>
   <apex:outputPanel id="resultsPanel">
   		<apex:outputText value="{!geoAddress}"/><br/>
   </apex:outputPanel>

 </apex:pageBlock>
 </apex:form>

</apex:page>
{% endhighlight %}
<p><strong>Unit Testing</strong></p>
<p>Writing unit tests for callouts can present a challenge. Scott Hemmeter has a really good article entitled <a href="http://sfdc.arrowpointe.com/2009/05/01/testing-http-callouts/" target="_blank">Testing HTTP Callouts</a> which should provide you with some useful techniques. You should also check out <a href="http://wiki.developerforce.com/index.php/An_Introduction_to_Apex_Code_Test_Methods" target="_blank">An Introduction to Apex Code Test Methods</a> on the developerforce wiki.</p>
<p>I also found this <a href="http://jsonviewer.stack.hu/">nifty JSON viewer</a> which makes debugging less painful.</p>

