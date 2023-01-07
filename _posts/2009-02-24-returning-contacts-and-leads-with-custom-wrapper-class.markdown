---
layout: post
title:  Returning Contacts and Leads with Custom Wrapper Class
description: Unfortunately alot of companies use Leads and Contacts interchangeably. Her...
date: 2009-02-24 18:00:00 +0300
image:  '/images/stock/3.jpg'
tags:   ["2009", "public"]
---
<p>Unfortunately alot of companies use Leads and Contacts interchangeably. Here is a small Apex class that performs a SOSL search across Contacts and Leads by email address. The method then wraps each Contact and Lead as a generic Person object and returns them to the caller as a List.</p>
<pre><code class="language-javascript">public class PersonService {

    public class Person {

        String id;
        String firstName;
        String lastName;
        String company;
        String email;
        String phone;
        String sObjectType;

    }

    public static List searchByEmail(String email) {

        // list of Person objects to return
        List people = new List();

        // issue the sosl search
        List&lt;list&gt; searchResults = [FIND :email IN EMAIL FIELDS RETURNING
            Contact (Id, Account.Name, Email, Phone, FirstName, LastName),
            Lead (Id, Company, FirstName, LastName, Email, Phone)];

        // cast the results by sObjec type
        List contacts = ((List)searchResults[0]);
        List leads = ((List)searchResults[1]);

        // a each contact found as a Person
        for (Integer i=0;i&lt;contacts.size();i++) {
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
        for (Integer i=0;i&lt;leads.size();i++) {
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

</code></pre>

