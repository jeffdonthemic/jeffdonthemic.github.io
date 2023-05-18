---
layout: post
title:  Salesforce API Transformation to MuleSoft - Part 3
description: Refactoring Apex and building flows
date: 2023-05-18 15:11:23 +0300
image:  '/images/codelive-3.png'
tags:   ["salesforce","mulesoft"]
---

This is the last of a three part series on the [Salesforce Developers](https://www.youtube.com/@SalesforceDevs) codeLive channel where we walk through a lift and shift of functionality from Salesfore Apex to MuleSoft Anypoint Platform.

- Part #1 - [Designing the API Specification](https://www.jeffdouglas.com/part-1-salesforce-api-transformatin-to-mulesoft)
- Part #2 - [Building the API implemtation](https://www.jeffdouglas.com/part-2-salesforce-api-transformatin-to-mulesoft)

In this final part we refactor the Apex code to call our API on CloudHub usng Name Credentials. We then use the new Summer '23 HTTP Callout (beta) action to create a screen flow that allows users to look a flight by code.

### Agenda

- Refacter the Apex code to make a single callout to the new API on CloudHub.
- Create a Permission Set, External Credential and Named Credential for the Apex Callout.
- Create a screen flow that allows users to look up a flight by code using an HTTP Callout action.

See [this repo](https://github.com/jeffdonthemic/flight-finder-salesforce) for all of the code and assets used in the applications.

<p><iframe src="https://www.youtube.com/embed/DUCXGJS8-A4" loading="lazy" frameborder="0" allowfullscreen=""></iframe></p>

## Flight Finder Flow

<p><img src="images/codelive-3-flow.png" alt="Flow" width="500"></p>

### HTTP Callout (beta) action

<p><img src="images/codelive-3-action.png" alt="HTTP Callout action"></p>

## FlowDebug

<p><img src="images/codelive-3-code-input.png" alt="Input screen"></p>

<p><img src="images/codelive-3-display.png" alt="Flight display"></p>










