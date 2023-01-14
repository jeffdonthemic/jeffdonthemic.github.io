---
layout: post
title:  Forcifier Node.js Package for Force.com
description: I just published a port of my Forcifier Ruby gem to Node.js. You can find the  package on npm and the source on github . So why should you use forcifier for your Node.js application? Well, if you are using the awesome nforce package , forcifier can make your life much easier. Forcifier provides utility functions for dealing with Force.com fields to make them pretty and easier to work with. Since Force.com is case insensitive, REST calls may return JSON with keys such as Country_code_AND_City__c.
date: 2013-06-24 11:09:08 +0300
image:  '/images/slugs/forcifier-node-js-package-for-force-com.jpg'
tags:   ["salesforce"]
---
<p>I just published a port of my <a href="https://github.com/jeffdonthemic/forcifier">Forcifier Ruby gem</a> to Node.js. You can find the <a href="https://npmjs.org/package/forcifier">package on npm</a> and the <a href="https://github.com/jeffdonthemic/forcifier-node">source on github</a>.</p>
<p>So why should you use forcifier for your Node.js application? Well, if you are using the awesome <a href="https://github.com/kevinohara80/nforce">nforce package</a>, forcifier can make your life much easier.</p>
<p>Forcifier provides utility functions for dealing with Force.com fields to make them pretty and easier to work with. Since Force.com is case insensitive, REST calls may return JSON with keys such as <code>Country_code_AND_City__c</code>. The forcifier package will convert JSON keys and list of fields into something like <code>country_code_and_city</code> which makes life much easier when writing applications in Node.js.</p>
<p>For example, it "deforces" JSON keys from Force.com so that all keys will be lowercase and will have <code>__c</code> removed. For example, the following JSON returned by nforce will look like:</p>
{% highlight js %}{
 "totalSize": 2,
 "done": true,
 "records": [
  {
 "attributes": {
  "type": "Account",
  "url": "/services/data/v27.0/sobjects/Account/001K000000f9XMDIA2"
 },
 "Id": "001K000000f9XMDIA2",
 "Name": "ACME Corp Ltd.",
 "Logo__c": "logo-big.jpg"
  },
  {
 "attributes": {
  "type": "Account",
  "url": "/services/data/v27.0/sobjects/Account/001K000000f8R8aIAE"
 },
 "Id": "001K000000f8R8aIAE",
 "Name": "XYZ Corp",
 "Logo__c": "logo.png"
  }
 ]
}
{% endhighlight %}
<p>Calling forcifier.deforceJson() on the payload above will remove the trailing <code>__c</code> from all keys and change them to lowercase. The resulting JSON will look like:</p>
{% highlight js %}{
 "totalsize": 2,
 "done": true,
 "records": {
  "0": {
 "attributes": {
  "type": "Account",
  "url": "/services/data/v27.0/sobjects/Account/001K000000f9XMDIA2"
 },
 "id": "001K000000f9XMDIA2",
 "name": "ACME Corp Ltd.",
 "logo": "logo-big.jpg"
  },
  "1": {
 "attributes": {
  "type": "Account",
  "url": "/services/data/v27.0/sobjects/Account/001K000000f8R8aIAE"
 },
 "id": "001K000000f8R8aIAE",
 "name": "XYZ Corp",
 "logo": "logo.png"
  }
 }
}
{% endhighlight %}
<p>There are also methods for adding <code>__c</code> to keys in JSON plus the same type of functionality for dealing with list of fields. Check it out and see if it makes your next Node.js application with Force.com a more enjoyable experience.</p>

