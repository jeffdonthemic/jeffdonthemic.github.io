---
layout: post
title:  Using PHP to call an Apex Web Service
description: I had the pleasure the other day of integrating Drupal with Salesforce.com using PHP. I didnt want to write all of my SOQL queries and business logic in my PHP scripts so I whipped up a quick Apex class and exposed it as a web service. I found a great blog post by Scott Hemmeter that really helped me out calling the service with PHP so I thought I would share the code and other observations. First you will need to download the PHP Toolkit . The toolkit contains all of the PHP code necessary to m
date: 2009-04-05 16:00:00 +0300
image:  '/images/slugs/using-php-to-call-an-apex-web-service.jpg'
tags:   ["2009", "public"]
---
<p>I had the 'pleasure' the other day of integrating Drupal with Salesforce.com using PHP. I didn't want to write all of my SOQL queries and business logic in my PHP scripts so I whipped up a quick Apex class and exposed it as a web service. I found a <a href="http://sfdc.arrowpointe.com/2008/12/05/calling-apex-web-services-from-php/" target="_blank">great blog post by Scott Hemmeter</a> that really helped me out calling the service with PHP so I thought I would share the code and other observations.</p>
<p>First you will need to download the <a href="http://wiki.developerforce.com/index.php/PHP_Toolkit" target="_blank">PHP Toolkit</a>. The toolkit contains all of the PHP code necessary to make web service calls against your org. Please note that the contained Partner and Enterprise WSDLs are for Production/Developer orgs, so if you are running against a Sandbox, you will need to download the appropriate WSDL from that Sandbox.</p>
<p>For this example, I took my <a href="/2009/02/24/returning-contacts-and-leads-with-custom-wrapper-class/" target="_blank">Person wrapper class</a> and exposed it as a web serivce. It exposes a method that allows you to search for Contacts and Leads by email address and returns a List of generic Person objects.</p>
{% highlight js %}global class PersonService {

    global class Person {

        webservice String id;
        webservice String firstName;
        webservice String lastName;
        webservice String company;
        webservice String email;
        webservice String phone;
        webservice String sObjectType;

    }

    webService static List<person> searchByEmail(String email) {

        // list of Person objects to return
        List<person> people = new List<person>();

        // issue the sosl search
        List<list<sobject>> searchResults = [FIND :email IN EMAIL FIELDS RETURNING
            Contact (Id, Account.Name, Email, Phone, FirstName, LastName),
            Lead (Id, Company, FirstName, LastName, Email, Phone)];

        // cast the results by sObjec type
        List<contact> contacts = ((List<contact>)searchResults[0]);
        List<lead> leads = ((List<lead>)searchResults[1]);

        // a each contact found as a Person
        for (Integer i=0;i<contacts.size();i++) {
            Person p = new Person();
            p.id = contacts[i].Id;
            p.firstName = contacts[i].FirstName;
            p.lastName = contacts[i].LastName;
            p.company = contacts[i].Account.Name;
            p.email = contacts[i].Email;
            p.phone = contacts[i].Phone;
            p.sObjectType = 'Contact';
            people.add(p);
        }

        // a each lead found as a Person
        for (Integer i=0;i<leads.size();i++) {
            Person p = new Person();
            p.id = leads[i].Id;
            p.firstName = leads[i].FirstName;
            p.lastName = leads[i].LastName;
            p.company = leads[i].Company;
            p.email = leads[i].Email;
            p.phone = leads[i].Phone;
            p.sObjectType = 'Lead';
            people.add(p);
        }

        System.debug('Returning people: '+people);

        return people;

    }
}

{% endhighlight %}
<p>Log into Salesforce.com and donwload the WSDL file for the PersonService class (Setup -> Develop -> Apex Classes). Also, make sure the profile calling the Web servcie has access to this class.</p>
<p>The PHP page looks like the following:</p>
{% highlight js %}<?PHP

require_once ('sfdc/SforcePartnerClient.php');
require_once ('sfdc/SforceHeaderOptions.php');

// Salesforce.com credentials
$sfdcUsername = "YOUR-USERNAME";
$sfdcPassword = "YOUR-PASSWORD";
$sfdcToken = "YOUR-SECURITYTOKEN";
// the email address to search for. could also use a post/get variable
$searchEmail = 'phpblogtest@noemail.com';

$sfdc = new SforcePartnerClient();
// create a connection using the partner wsdl
$SoapClient = $sfdc->createConnection("sfdc/partner.wsdl.xml");
$loginResult = false;

try {
    // log in with username, password and security token if required
    $loginResult = $sfdc->login($sfdcUsername, $sfdcPassword.$sfdcToken);
} catch (Exception $e) {
    global $errors;
    $errors = $e->faultstring;
    echo "Fatal Login Error <b>" . $errors . "</b>";
    die;
}

// setup the SOAP client modify the headers
$parsedURL = parse_url($sfdc->getLocation());
define ("_SFDC_SERVER_", substr($parsedURL['host'],0,strpos($parsedURL['host'], '.')));
define ("_WS_NAME_", "PersonService");
define ("_WS_WSDL_", "sfdc/" . _WS_NAME_ . ".wsdl.xml");
define ("_WS_ENDPOINT_", 'https://' . _SFDC_SERVER_ . '.salesforce.com/services/wsdl/class/' . _WS_NAME_);
define ("_WS_NAMESPACE_", 'http://soap.sforce.com/schemas/class/' . _WS_NAME_);

$client = new SoapClient(_WS_WSDL_);
$sforce_header = new SoapHeader(_WS_NAMESPACE_, "SessionHeader", array("sessionId" => $sfdc->getSessionId()));
$client->__setSoapHeaders(array($sforce_header));

echo _SFDC_SERVER_."br";
echo _WS_NAME_."br";
echo _WS_WSDL_."br";
echo _WS_ENDPOINT_."br";
echo _WS_NAMESPACE_."p";

try {

    // call the web service via post
    $wsParams=array('email'=>$searchEmail);
    $response = $client->searchByEmail($wsParams);
    // dump the response to the browser
    print_r($response);

// this is really bad.
} catch (Exception $e) {
    global $errors;
    $errors = $e->faultstring;
    echo "Ooop! Error: <b>" . $errors . "</b>";
    die;
}

?>

{% endhighlight %}
<p>The PHP page should look something like the following:</p>
<img class="alignnone size-full wp-image-648" title="php-webservice" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399631/php-webservice_ax7qbi.png" alt="php-webservice" width="544" height="182" />
