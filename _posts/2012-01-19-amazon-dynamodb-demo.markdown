---
layout: post
title:  Amazon DynamoDB Demo
description: Yesterday Amazon announced Amazon DynamoDB  , their Internet-scale NoSQL database service. Back in November we were fortunate enough at CloudSpokes to be invited to participate in a private beta for Amazon DynamoDB . We’ve since then had some time to work it over a bit and I have put together a demo application to show off some functionality. The code for the HomeController is below but you can find source for the entire applications at our GitHub repo for your forking convenience.   Demo applic
date: 2012-01-19 14:48:20 +0300
image:  '/images/slugs/amazon-dynamodb-demo.jpg'
tags:   ["2012", "public"]
---
<p>Yesterday <a href="http://aws.typepad.com/aws/2012/01/amazon-dynamodb-internet-scale-data-storage-the-nosql-way.html" target="_blank">Amazon announced Amazon DynamoDB</a>, their Internet-scale NoSQL database service. Back in November we were fortunate enough at <a href="http://www.cloudspokes.com" target="_blank">CloudSpokes</a> to be invited to participate in a private beta for <a href="http://aws.amazon.com/dynamodb/" target="_blank">Amazon DynamoDB</a>. We’ve since then had some time to “work it over” a bit and I have put together a <a href="http://kivabrowser.elasticbeanstalk.com/" target="_blank">demo application</a> to show off some functionality. The code for the HomeController is below but you can find source for the entire applications at <a href="https://github.com/cloudspokes/Amazon-DynamoDB-Demo" target="_blank">our GitHub repo</a> for your forking convenience.</p>
<p><a href="http://kivabrowser.elasticbeanstalk.com"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327745/kiva-browser-1_hxtmla.png" alt="" title="kiva-browser" width="400" height="321" class="aligncenter size-full wp-image-4327" /></a></p>
<div style="text-align: center;">
<b><a href="http://kivabrowser.elasticbeanstalk.com/" target="_blank">Demo application</a>&nbsp;and <a href="https://github.com/cloudspokes/Amazon-DynamoDB-Demo" target="_blank">source code</a></b></div>
<p>The API is very straight forward and easy to work with. If you’ve used other NoSQL databases then you should have no problem wrapping your head around <a href="http://aws.amazon.com/dynamodb/" target="_blank">Amazon DynamoDB</a>. It has simple storage and query methods, allowing you to store and access data items with a flexible number of attributes using simple “Put” or “Get” web services APIs. Amazon DynamoDB provides a native API for HTTP and SDKs for Java, PHP and .NET. More are reportedly in the works.</p>
<p>What is Amazon DynamoDB and why would I want to use it?</span></p>
<p><a href="http://aws.amazon.com/dynamodb/" target="_blank">Amazon DynamoDB</a> is a fast, highly scalable, highly available, cost-effective non-relational database service that scales automatically without limits or administration. This service is tightly coupled with Amazon S3 andAmazon EC2, collectively providing the ability to store, process and query data sets in the cloud.</p>
<p>If you have massive amounts of highly transactional data then Amazon DynamoDB might be for you:</p>
<ul>
<li>Store Social Graph data for processing</li>
<li>Storing GPS data for devices</li>
<li>Data storage for Hadoop processes</li>
<li>Record user activity logs</li>
<li>NFC processes</li>
<li>Recording clicks for A/B testing</li>
</ul>
<p><b>Blazing Fast</b> - Amazon DynamoDB runs on a new solid state disk (SSD) architecture for low-latency response times. Read latencies average less than 5 milliseconds, and write latencies average less than 10 milliseconds. We found our applications to be extremely responsive.</p>
<p><b>Hands Off Administration</b> - Amazon DynamoDB is a fully managed service – no need to worry about hardware or software provisioning, setup and configuration, software patching, or partitioning data over multiple instances as you scale. For instance, when you create a table, you need to specify the request throughput you want for your table. In the background, Amazon DynamoDB handles the provisioning of resources to meet the requested throughput rate.</p>
<p><b>Auto Scaling</b> - To continue with the “no administration” theme, Amazon DynamoDB can automatically scale machine resources in response to increases in database traffic without the need of client-side partitioning. Alternatively, you can also proactively manage performance with a few simple commands.</p>
<p><b>Security Baked In</b> - Amazon DynamoDB is integrated with AWS Identity and Access Management (access keys and tokens) allowing you to provide access to defined users and groups, assign granular security credentials and user access, much more.</p>
<p><b>Centralized Monitoring</b> - As with most everything in AWS-land, you can easily view metrics for your Amazon DynamoDB table in the AWS Management Console. You can also view your request throughput and latency for each API as well as resource consumption through Amazon CloudWatch.</p>
<h3 id="apioverview">API Overview</h3>
<p>From a high level, Amazon DynamoDB API provides the following functionality:</p>
<ul>
<li>Create a table</li>
<li>Delete a table</li>
<li>Request the current state of a table</li>
<li>Get a list of all of the tables for the current account</li>
<li>Put an item</li>
<li>Get one or more items by primary key</li>
<li>Update the attributes in a single item</li>
<li>Delete an item</li>
<li>Scan a table and optionally filter the items returned using comparison operators</li>
<li>Query for items using a range index and comparison operators</li>
<li>Increment or decrement a numeric value</li>
</ul>
<h3 id="datamodel">Data Model</h3>
<p>Amazon DynamoDB stores data in tables containing items with a collection of name-value pairs (attributes). Items (anaglous to a record) are managed by assigning each item a primary key value. Unlike traditional databases, the table is schemaless and only relies on the primary key. Items can contain combination of attributes. For example:</p>
<p>"Name" = "Member Search with Redis"<br>
"ChallengeId" = 1219<br>
"Categories" = "aws", "ruby", "mobile"<br>
"Ratings" = 17, 36</p>
<p><b>Primary Keys & Indexes</b></p>
<p>When creating a new table, you define the primary key and type of key to be used. Amazon DynamoDB supports a one name/value pair primary key (a hash primary key; string or number) or two name/value pair primary key (a hash-and-range primary key) for index values.</p>
<p>Hash key example: "ChallengeId" = 1219<br>
Hash-and-range key example: "MemberId" = "romin", "MemberNumber" = "976"</p>
<p>Note: the Query API is only available for hash-and-range primary key tables. If you are using a simple hash key, then you need to use the Scan API.</p>
<p><b>Data Types</b></p>
<p>Amazon DynamoDB supports two scalar data types (Number and String) and multi-valued types (String Set and Number Set). Everything is stored in Amazon DynamoDB as a UTF-8 string value. You designate the data as a Number, String, String Set, or Number Set in the request but there is no distinction between an int, long, float, etc. For example:</p>
<p>item.put("member", new AttributeValue().withS("romin"));<br>
item.put("challenge", new AttributeValue().withN("1219"));</p>
<p>Amazon DynamoDB supports both Number Sets and String Sets:</p>
<p>"Challenges":[{<br>
 "members":{"SS":["kenji776, romin, akkishore"]},<br>
 "wins" : {"NS":["14", "10", "8"]}<br>
}]</p>
<p>Amazon DynamoDB uses JSON as the transport protocol. However, the JSON data is parsed and stored nativly on disk.</p>
<p>That’s a quick overview so make sure to check out the DynamoDB documentation for more details. The documentation is very well done and has clear instructions and code samples for Java, PHP and .Net. If you are into database performance, check out the details on provisioned throughput, data consistency, conditional operations, performance factors and more.</p>
<p><span style="font-size: large;">How to get started?</span></p>
<p>Sign up for a new AWS account (if you don’t already have one) and get your AWS Access Key ID and Secret Access Key from your account’s security section. Walk through their <a href="http://docs.amazonwebservices.com/amazondynamodb/latest/developerguide/GettingStartedDynamoDB.html" target="_blank">Getting Started Guide</a> for samples. In your code, just add your credentials to the AWSDynamoDBClient and you are ready to start making requests. All of the API calls are pretty straightforward and work as you would expect them to.</p>
<p>Pricing is, again, pay as you go but Amazon DynamoDB is part of the <a href="http://aws.amazon.com/free/" target="_blank">AWS’s Free Usage Tier</a> so check it out for more info.</p>
{% highlight js %}package com.cloudspokes.dynamodb;

@Controller
public class HomeController {

 static AmazonDynamoDBClient dynamoDB;
 private String tableName = "kiva-loans";
 // aws keys
 public static final String ACCESSKEY = "YOURKEY";
 public static final String SECRETKEY = "YOURSECRET";

 public HomeController() {
  try {
 setup();
  } catch (Exception e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  }
 }

 /**
  * Displays the list of loans from the table
  */
 @RequestMapping(value = "/loans", method = RequestMethod.GET)
 public String loans(Locale locale,
 @RequestParam(value = "keyword", required = false) String keyword,
 Model model) {

  ArrayList<Loan> loans = new ArrayList<Loan>();
  ScanRequest scanRequest = new ScanRequest(tableName);

  if (keyword != null) {
 HashMap<String, Condition> scanFilter = new HashMap<String, Condition>();
 Condition condition = new Condition().withComparisonOperator(
   ComparisonOperator.EQ.toString()).withAttributeValueList(
   new AttributeValue().withS(keyword));
 scanFilter.put("country", condition);
 scanRequest = new ScanRequest(tableName).withScanFilter(scanFilter);
  }
  ScanResult scanResult = dynamoDB.scan(scanRequest);

  for (int i = 0; i < scanResult.getCount(); i++) {
 HashMap<String, AttributeValue> item = (HashMap<String, AttributeValue>) scanResult
   .getItems().get(i);
 Loan loan = new Loan();
 loan.setActivity(item.get("activity").getS());
 loan.setCountry(item.get("country").getS());
 loan.setFunded_amount(Double.parseDouble(item.get("funded_amount")
   .getN()));
 loan.setId(Integer.parseInt(item.get("id").getN()));
 loan.setName(item.get("name").getS());
 loan.setStatus(item.get("status").getS());
 loan.setUse(item.get("use").getS());
 loans.add(loan);
  }

  model.addAttribute("loans", loans);
  return "loans";
 }

 /**
  * Displays a loan item
  */
 @RequestMapping(value = "/show/{id}", method = RequestMethod.GET)
 public String show(@PathVariable String id, Locale locale, Model model) {
  model.addAttribute("loan", getLoan(id));
  return "show";
 }

 /**
  * Displays a form to create a new loan item
  */
 @RequestMapping(value = "/new", method = RequestMethod.GET)
 public String newLoan(Locale locale, Model model) {
  model.addAttribute("loan", new Loan());
  return "new";
 }

 /**
  * Inserts a new loan item into dynamodb
  */
 @RequestMapping(value = "/new", method = RequestMethod.POST)
 public String addLoan(@ModelAttribute("loan") Loan loan,
 BindingResult result) {

  // populate an item with the data to put
  HashMap<String, AttributeValue> item = new HashMap<String, AttributeValue>();
  item.put("id", new AttributeValue().withN(String.valueOf(loan.getId())));
  item.put("activity", new AttributeValue().withS(loan.getActivity()));
  item.put("country", new AttributeValue().withS(loan.getCountry()));
  item.put("funded_amount", new AttributeValue().withN(String
  .valueOf(loan.getFunded_amount())));
  item.put("name", new AttributeValue().withS(loan.getName()));
  item.put("status", new AttributeValue().withS(loan.getStatus()));
  item.put("use", new AttributeValue().withS(loan.getUse()));

  // put the item to the table
  try {
 PutItemRequest req = new PutItemRequest(tableName, item);
 PutItemResult res = dynamoDB.putItem(req);
  } catch (AmazonServiceException ase) {
 System.err.println("Failed to create item in " + tableName);
  }

  return "redirect:show/" + loan.getId();
 }

 /**
  * Displays the item for editing
  */
 @RequestMapping(value = "/edit/{id}", method = RequestMethod.GET)
 public String editLoan(@PathVariable String id, Locale locale, Model model) {
  model.addAttribute("loan", getLoan(id));
  return "edit";
 }

 /**
  * Submits the updates loan data to dynamodb
  */
 @RequestMapping(value = "/edit/{id}", method = RequestMethod.POST)
 public String updateLoan(@PathVariable String id,
 @ModelAttribute("loan") Loan loan, BindingResult result) {

  Key key = new Key().withHashKeyElement(new AttributeValue().withN(id));
  HashMap<String, AttributeValueUpdate> updates = new HashMap<String, AttributeValueUpdate>();

  AttributeValueUpdate update = new AttributeValueUpdate().withValue(
  new AttributeValue(loan.getStatus())).withAction("PUT");
  updates.put("status", update);

  // update the item to the table
  try {
 UpdateItemRequest req = new UpdateItemRequest(tableName, key,
   updates);
 UpdateItemResult res = dynamoDB.updateItem(req);
  } catch (AmazonServiceException ase) {
 System.err.println("Failed to update item: " + ase.getMessage());
  }

  return "redirect:../show/" + id;
 }

 /**
  * Fetches loan data from Kiva an inserts it into dynamodb
  */
 @RequestMapping(value = "/loadData", method = RequestMethod.GET)
 public String loadData(Locale locale, Model model) {

  // delete all of the current loans
  deleteAllLoans();

  // make the REST call to kiva
  DefaultHttpClient httpClient = new DefaultHttpClient();
  HttpGet getRequest = new HttpGet(
  "http://api.kivaws.org/v1/loans/newest.json");
  getRequest.addHeader("accept", "application/json");
  HttpResponse response;
  String payload = "";

  try {
 response = httpClient.execute(getRequest);

 if (response.getStatusLine().getStatusCode() != 200) {
  throw new RuntimeException("Failed : HTTP error code : "
  + response.getStatusLine().getStatusCode());
 }

 BufferedReader br = new BufferedReader(new InputStreamReader(
   (response.getEntity().getContent())));
 payload = br.readLine();
  } catch (ClientProtocolException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  } catch (IOException e) {
 // TODO Auto-generated catch block
 e.printStackTrace();
  }

  JSONObject json = (JSONObject) JSONSerializer.toJSON(payload);
  // get the array of loans
  JSONArray loans = json.getJSONArray("loans");

  for (int i = 0; i < loans.size(); ++i) {
 JSONObject loan = loans.getJSONObject(i);
 // populate an item with the data to put
 HashMap<String, AttributeValue> item = new HashMap<String, AttributeValue>();
 item.put("id", new AttributeValue().withN(loan.getString("id")));
 item.put("name", new AttributeValue().withS(loan.getString("name")));
 item.put("status",
   new AttributeValue().withS(loan.getString("status")));
 item.put("funded_amount",
   new AttributeValue().withN(loan.getString("funded_amount")));
 item.put("activity",
   new AttributeValue().withS(loan.getString("activity")));
 item.put("use", new AttributeValue().withS(loan.getString("use")));
 item.put("country", new AttributeValue().withS(loan.getJSONObject(
   "location").getString("country")));

 try {
  PutItemRequest req = new PutItemRequest(tableName, item);
  PutItemResult res = dynamoDB.putItem(req);
  System.out.println("Put result: " + res);
 } catch (AmazonServiceException ase) {
  System.err.println("Failed to create item in " + tableName);
 }

  }

  httpClient.getConnectionManager().shutdown();

  return "redirect:loans";
 }

 /**
  * Displays the home page
  */
 @RequestMapping(value = "/", method = RequestMethod.GET)
 public String home(Locale locale, Model model) {
  return "home";
 }

 /**
  * Fetches a specific loan item
  */
 private Loan getLoan(String id) {
  Key key = new Key().withHashKeyElement(new AttributeValue().withN(id));
  GetItemRequest req = new GetItemRequest(tableName, key);
  GetItemResult res = dynamoDB.getItem(req);
  HashMap<String, AttributeValue> item = (HashMap<String, AttributeValue>) res
  .getItem();

  Loan loan = new Loan();
  loan.setActivity(item.get("activity").getS());
  loan.setCountry(item.get("country").getS());
  loan.setFunded_amount(Double.parseDouble(item.get("funded_amount")
  .getN()));
  loan.setId(Integer.parseInt(item.get("id").getN()));
  loan.setName(item.get("name").getS());
  loan.setStatus(item.get("status").getS());
  loan.setUse(item.get("use").getS());
  return loan;
 }

 /**
  * Deletes all items from dynamodb
  */
 private void deleteAllLoans() {
  ScanRequest scanRequest = new ScanRequest(tableName);
  ScanResult scanResult = dynamoDB.scan(scanRequest);
  for (int i = 0; i < scanResult.getItems().size(); i++) {
 HashMap<String, AttributeValue> item = (HashMap<String, AttributeValue>) scanResult
   .getItems().get(i);
 try {
  Key key = new Key()
  .withHashKeyElement(new AttributeValue("id"))
  .withHashKeyElement(item.get("id"));
  DeleteItemRequest request = new DeleteItemRequest(tableName,
  key);
  DeleteItemResult result = dynamoDB.deleteItem(request);
  System.out.println("Result: " + result);
 } catch (AmazonServiceException ase) {
  System.err.println("Failed to delete item in " + tableName);
 }
  }
 }

 private void setup() throws Exception {
  BasicAWSCredentials creds = new BasicAWSCredentials(ACCESSKEY,
  SECRETKEY);
  dynamoDB = new AmazonDynamoDBClient(creds);
  dynamoDB.setEndpoint("http://dynamodb.us-east-1.amazonaws.com");
 }

}
{% endhighlight %}

