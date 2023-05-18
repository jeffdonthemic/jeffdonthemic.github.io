---
layout: post
title:  Salesforce API Transformation to MuleSoft - Part 1
description: Designing the API specification
date: 2023-04-14 11:56:12 +0300
image:  '/images/codelive-1.png'
tags:   ["salesforce","mulesoft"]
---

This is the first of a three part series on the [Salesforce Developers](https://www.youtube.com/@SalesforceDevs) codeLive channel where we walk through a lift and shift of functionality from Salesfore Apex to MuleSoft Anypoint Platform.

- Part #2 - [Building the API implemtation](https://www.jeffdouglas.com/part-2-salesforce-api-transformatin-to-mulesoft)
- Part #3 - [Refactoring Apex & Building Flows](https://www.jeffdouglas.com/part-3-salesforce-api-transformatin-to-mulesoft)

See [this repo](https://github.com/jeffdonthemic/flight-finder-salesforce) for all of the code and assets used in the applications.

<p><iframe src="https://www.youtube.com/embed/9P0xWswm6Cc" loading="lazy" frameborder="0" allowfullscreen=""></iframe></p>

The scenario for the demo is that your Salesforce org has an existing application to search for Delta and United flights. It consists of a simple Lighting Web Component, a controller and a service class that makes callouts to a Delta SOAP service and a United REST service.

<p><img src="images/codelive-lwc.png" alt="LWC interface" ></p>

<p><img src="images/codelive-current-architecture.png" alt="Current architecture" ></p>

Your new boss loves the service but wants you to make a number of enhancements:

- It needs to be easily discoverable by IT and other developers within your organization.
- She wants to use the service on the company website and by mobile applications so it needs to be easily accessible, consumable and reusable by IT and other developers.
- Since it will be used by other applications you'll need to implement centralized governance and compliance.
- You'll need to implement SLAs with monitoring, security and scalability.
- It will need to be extensible for future enhancements, including a current request to add a PostgreSQL DB for American Airlines.

To meet these requirements, your approach is to create an API on MuleSoft Anypoint Platform and move the callouts from the Apex class and this API implementation.  

<p><img src="images/codelive-proposed-architecture.png" alt="Proposed architecture" ></p>

In the first day's video we:

- Examine the existing Salesforce code
- Define the API with RAML, the Restful API Modeling Language
- Mock the API to test its design before building
- Make the API discoverable by adding it to the private Anypoint Exchange








