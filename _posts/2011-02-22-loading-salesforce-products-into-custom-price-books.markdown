---
layout: post
title:  Loading Salesforce Products into Custom Price Books
description: This topic has come up frequently on the salesforce.com message boards recently and with good reason. Products, price books and price book entries are somewhat confusing. Products are the actual items that you sell on your opportunities and quotes. Products are associated to one or more price books to create price book entries. Products can exist in multiple price books with many different prices. For example, you may have a North American price book with one set of prices for your products and 
date: 2011-02-22 15:30:20 +0300
image:  '/images/slugs/loading-salesforce-products-into-custom-price-books.jpg'
tags:   ["2011", "public"]
---
<p>This topic has come up frequently on the <a href="http://boards.developerforce.com/sforce/?category.id=developers" target="_blank">salesforce.com message boards</a> recently and with good reason. Products, price books and price book entries are somewhat confusing.</p>
<p>Products are the actual items that you sell on your opportunities and quotes. Products are associated to one or more price books to create price book entries. Products can exist in multiple price books with many different prices. For example, you may have a "North American" price book with one set of prices for your products and a "South American" price book with a different set of prices.</p>
<p>You can use the standard price book that comes with salesforce.com or create custom price books. The standard price book is automatically generated to contain a master list of all products and standard prices regardless of the custom price books that also contain them. When users add products to their opportunities or quotes, they first have to select the price book. Administrators can restrict access to specific price books for users to limit their ability to add certain types of products.</p>
<p>Products live in the Product2 object while price books live in the Pricebook2 object. The PricebookEntry object is the junction object that users interact with that contains the price, currency, product code, etc for each of the price book and product combinations.</p>
<p>Loading products can be confusing as you must also import the associated price book entries. When you are using custom price books, you must also add the product to the standard price book in addition to the custom price book. So you first load the products into the Product2 object and then load the associated products twice into the PricebookEntry object; once for the standard price book and once for the custom price book (or as many custom price books as you have).</p>
<p>You need to have two separate CSV files to import with the Data Loader for price book entries. So a single row in the import CSV for the standard price book would contain:</p>
<ul>
<li>Product2ID: the ID of the product from the Product2 object</li>
<li>PriceBook2ID: the ID of the price book marked IsStandard = TRUE in the Pricebook2 object</li>
<li>CurrencyIsoCode: the currency symbol if Multi-Currency is enabled</li>
<li>Unit Price: the list price/standard price for the product</li>
<li>UseStandardPrice: FALSE</li>
<li>IsActive: TRUE</li>
</ul>
<p>A single row in the import CSV for the custom price book would contain:</p>
<ul>
<li>Product2ID: the ID of the product from the Product2 object</li>
<li>PriceBook2ID: the ID of the custom price book in the Pricebook2 object</li>
<li>CurrencyIsoCode: the currency symbol if Multi-Currency is enabled</li>
<li>Unit Price: the list price/standard price for the product</li>
<li>UseStandardPrice: FALSE -- FALSE - means you will use the Unit Price from the custom Price Book and NOT the Unit Price from the Standard Price Book. TRUE - this option only works if this Product has been added to the Standard Price Book. This choice will use the Unit Price from the Standard Price Book</li>
<li>IsActive: TRUE</li>
</ul>
<p>For more detailed info, check out the salesforce Knowledge article, <a href="https://help.salesforce.com/apex/HTViewSolution?id=98365&language=en" target="_blank">How to insert/upload new Products, Price Books & Opportunity Line Item via Data Loader?</a></p>
