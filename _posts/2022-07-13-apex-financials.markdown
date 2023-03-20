---
layout: post
title:  Apex Financial Calculations for Salesforce
description: An Apex implementation of RATE, PV, PMT, FV, IPMT & PPMT Excel functions.
date: 2022-07-13 13:56:12 +0300
image:  '/images/apex-financials.jpg'
tags:   ["apex"]
---
[Apex Financial Calculations for Salesforce](https://github.com/jeffdonthemic/apex-financials) is an open-source project that provides a set of financial Excel functions for use in Salesforce financial applications. The project includes an Apex class with functions and unit tests for calculating financial metrics such as the interest rate per period of an annuity, the present value of a loan or investment, the payment for a loan based on constant payments and interest rate, the future value of an investment based on a constant interest rate, and the interest payment and payment on the principal for a given period.

The code is available at [https://github.com/jeffdonthemic/apex-financials](https://github.com/jeffdonthemic/apex-financials)

The project's Apex class is well documented and has been tested against Excel and Google Spreadsheets to ensure that it produces accurate results.

It includes the following financial Excel functions:

1. **RATE** - Calculates the interest rate per period of an annuity.
2. **PV** - Calculates the present value of a loan or an investment, based on a constant interest rate.
3. **PMT** - Calculates the payment for a loan based on constant payments and a constant interest rate.
4. **FV** - Calculates the future value of an investment based on a constant interest rate.
5. **IPMT** - Calculates the interest payment for a given period for an investment based on periodic, constant payments and a constant interest rate.
6. **PPMT** - Calculates the payment on the principal for a given period for an investment based on periodic, constant payments and a constant interest rate.

 The class is easy to use and has been tested to produce accurate results. It is a great resource for developers who want to integrate financial calculations into their Salesforce applications quickly.
