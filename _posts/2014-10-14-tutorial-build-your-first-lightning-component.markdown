---
layout: post
title:  Tutorial - Build Your First Lightning Component
description: I was fortunate enough to be on the Lightning beta and have spent a considerable amount of time building Lightning components over the past weeks. If you are familiar with JavaScript and possibly frameworks such as AngularJS and Backbone, then building Lightning components should be a snap. > Topcoder  has teamed up with salesforce.com to help drive the development of Lightning components. We are currently running a number of development challenges at lightning.topcoder.com  and have over $20,00
date: 2014-10-14 21:55:55 +0300
image:  '/images/pexels-flash-dantz-7759446.jpg'
tags:   ["2014", "public"]
---
<p>I was fortunate enough to be on the Lightning beta and have spent a considerable amount of time building Lightning components over the past weeks. If you are familiar with JavaScript and possibly frameworks such as AngularJS and Backbone, then building Lightning components should be a snap.</p>
<blockquote>
<p><a href="http://www.topcoder.com">Topcoder</a> has teamed up with salesforce.com to help drive the development of Lightning components. We are currently running a number of development challenges at <a href="http://lightning.topcoder.com">lightning.topcoder.com</a> and have over $20,000 in prize money dedicated to build next generation UI components for Salesforce1. Head on over to <a href="http://lightning.topcoder.com">lightning.topcoder.com</a> and get started today! The challenges should be running for a number of months.</p>
</blockquote>
<p>So let’s get started with some basic concepts. Lightning applications are composed of Lightning components. There’s not much difference the two with the exception that components must live inside an application. Before you proceed with this tutorial, I would suggest you take a look at the <a href="https://developer.salesforce.com/resource/pdfs/Lightning_QuickStart.pdf">Lightning Components Quick Start</a> which has a super simple guide to get a "hello world" up and running quickly. You might want to also check out the the <a href="https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/">Lightning Components Developer’s Guide</a> for a great "Getting Started" expense tracker tutorial. We are going to build something a little more complex so let’s get started. <strong>All of the following code is available <a href="https://gist.github.com/jeffdonthemic/39791ab40112a81f0168">in this gist</a>.</strong></p>
<p>The application we are going to build is an Employee Store where users can redeem their "reward points" for products. From a high level, the app has a picker component that allows the user to choose the product to view from a Custom Object, a product view component that displays the currently selected product from the picker, a cart component that tracks products added to the cart and a small notification component that simply displays the name of the product added to the cart. The app emits an application level event whenever a product is added to the cart that is handled by the various components listening for that event (e.g., the cart and the notification panel).</p>
<p>A component is actually a bundle of a number of files. Only the component or application is actually required but you’ll typically use at least a client-side controller as well. Here’s a breakdown of what’s in a component:</p>
<p>Component or Application (MyComponent.cmp or MyApp.app) - This file contains the declarative markup for the component or app.</p>
<p>Controller (MyComponentController.js) - This file contains the client-side JavaScript controller methods to handle events fired and handled by the components.</p>
<p>CSS Styles (MyComponent.css) - The CSS styles scoped to the component.</p>
<p>Helper (MyComponentHelper.js) - This file contains JavaScript functions that can be called from any JavaScript code in a component’s bundle. Typically you’d move commonly called code from your controllers into a helper for reuse.</p>
<p>Components can also container custom renderers and documentation but that is beyond the scope of this tutorial.</p>
<p>To get started, the first thing you’ll need to do is <a href="https://developer.salesforce.com/signup">signup for a new Winter '15 Developer org</a>. Older orgs are not enabled with Lightning. Next follow steps #2 & #3 in the <a href="https://developer.salesforce.com/resource/pdfs/Lightning_QuickStart.pdf">Lightning Components Quick Start</a>. Make sure in step #3 you also check "Enable Debug Mode".</p>
<p>Now create the two Custom Objects to hold your data. We’ll create a Product__c object and a Product_Size__c object that looks like the following:</p>
{% highlight ruby %}
Product__c
Name (the default name field)
Color__c (text 25)
Description__c (textarea)
Photo__c (url)
Points__c (number 18,0)
{% endhighlight %}
{% highlight ruby %}
Product_Size__c
Name (default name field)
Product__c (master-detail to Product__c)
{% endhighlight %}
<p>Go ahead and populate your objects with some data. I used snorgtees for some funny shirts. Now create the following "AwesomeProductController" Apex Controller that has methods to return a list of all products and a specific product by name:</p>
{% highlight js %}
public class AwesomeProductController {
  @AuraEnabled
  public static List<Product__c> getProducts() {
    return [select id, name, photo__c, description__c, points__c from product__c];
  }
  
  @AuraEnabled
  public static Product__c getProductByName(String name) {
    return [select id, name, photo__c, color__c,
        points__c, description__c,
        (select name from aotpjd__product_sizes__r order by name)
        from product__c where name = :name];
  }
}
{% endhighlight %}
<p>Next, we’ll upload some CSS and JavaScript files that will be needed to make the app look pretty. Upload <a href="https://dl.dropboxusercontent.com/u/640400/blog/lightning-tutorial.zip">these three files</a> and name the resources bootstrap, style and bootstrapjs.</p>
<blockquote>
<p>In all of the your code for this tutorial, replace my namespace, <em>aotpjd</em>, with your own namespace.</p>
</blockquote>
<p>OK, so now we have the "config" portion of our app done, let’s write some code. Currently you can only write Lightning components in Developer Console, so click <b>your_name</b> and then Developer Console. Click File -> New -> Lightning Application, enter the name as "CompanyStore" and click submit.</p>
<p>Now enter the following code for a simple "hello world":</p>
{% highlight js %}
<aura:application>
  <link href='/resource/bootstrap/' rel="stylesheet"/>
  <link href='/resource/style/' rel="stylesheet"/>
  hello world
  <script src="/resource/bootstrapjs"></script>
</aura:application>
{% endhighlight %}
<p>When you open <b>https://[your-pod].lightning.force.com/[your-namespace]/CompanyStore.app</b> in your browser you should see "hello world".</p>
<p>Now replace "hello world" in your component with &#60;aotpjd:ProductViewer/&#62;. This component will display our product and provide the functionality we need.</p>
<p>Now we are going to create the main UI component for our application, ProductViewer. Click File -> New -> Lightning Component, enter the name as "ProductViewer", click submit and paste in the following code:</p>
{% highlight js %}
<aura:component controller="aotpjd.AwesomeProductController">
  <aura:attribute name="product" type="aotpjd.Product__c" default="{'sobjectType': 'aotpjd__Product__c'}"/>
  <aura:attribute name="products" type="aotpjd.Product__c[]"/>
  <aura:handler name="init" value="{!this}" action="{!c.doInit}" />
  <aura:registerEvent name="addToCartEvent" type="aotpjd:AddToCart"/>

  <div class="container">
    <div class="row">
      <div class="col-lg-3 col-md-4 col-sm-5">
        <div class="well">
          <div class="btn-group btn-group-cart">
            <select onchange="{!c.change}">
              <aura:iteration items="{!v.products}" var="p">
                <option>{!p.name}</option>
              </aura:iteration>
            </select>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="container main-container">
    <div class="row">
     <div class="col-lg-3 col-md-3 col-sm-12">

    <div class="col-lg-12 col-md-12 col-sm-12">
     <div class="no-padding">
         <span class="title">{!v.product.name}</span>
        </div>
          <div class="thumbnail col-lg-12 col-md-12 col-sm-6 text-center">
           <a href="detail.html" class="link-p">
                <img src="{!v.product.aotpjd__photo__c}" alt=""/>
           </a>
            <div class="caption prod-caption">
              <p>{!v.product.aotpjd__Description__c}</p>
              <p>
               <div class="btn-group">
                <a href="#" class="btn btn-default">{!v.product.aotpjd__points__c} pts</a>
                <a href="#" onclick="{!c.addToCart}" class="btn btn-primary"><i class="fa fa-shopping-cart"></i> Add</a>
               </div>
              </p>
            </div>
          </div>
    </div>

     </div>

     <div class="clearfix visible-sm"></div>

      <aotpjd:ShoppingCart/>

      <aotpjd:MessageArea/>

    </div>
 </div>
</aura:component>
{% endhighlight %}
<p>The first few lines in the component are really important so let's dive into them. In line #1, we define that our component will use the AwesomeProductController so that we’ll be able to use the two methods in it and retreive our records from the database.</p>
<p>Lines #2 & #3 are attributes of the component. Component attributes are like member variables in an Apex class. They are typed fields that are set on a specific instance of a component, and can be referenced from within the component's markup using an expression syntax. We’ll need the <b>product</b> attribute to reference the current product record we are displaying and the <b>products</b> attribute so we can display all of the products in the database in the select list.</p>
<p>In line #4 we specify a handler in the JavaScript controller that fires when the component initializes. This init handler triggers the <b>doInit</b> method in the client-side controller, which calls the Apex controller to populate the component with initial data. We’ll write this code in a second.</p>
<p>Line #5 uses aura:registerEvent to declare that the component may fire an event (in the JavaScript controller) called <b>addToCartEvent</b>. We’ll look at the configuration of that event in a second.</p>
<p>Most of this file is HTML markup but there are some other important pieces to point out. Lines #12-14 setup a select list with data from the database. This way you can easily switch and display different products (mostly for demo purposes). We use the builtin <b>&#60;aura:iteration&#62;</b> element to iterate the collection of product records returned from the database. The name of that attribute is <b>products</b>, while <b>v.</b> is the value provider for a component's attribute set, which represents the view. We also have an onchange handler that calls the <b>change</b> function in the JavaScript controller whenever the select list value changes.</p>
<p>Interspersed in the HTML we display values such as name, color and description from the database with the <b>product</b> attribute. Notice in line #29 we output standard fields with <b>{!v.product.name}</b> while custom fields use the namespace, <b>{!v.product.aotpjd__photo__c}</b>.</p>
<p>Lightning has a bunch of extremely useful core UI components for inputText, inputDate, InputCheckbox, button, etc. but in line #40 we use a simple onclick action to call the <b>addToCart</b> function in the JavaScript controller.</p>
<p><strong>Events == #AWESOME</strong></p>
<p>One of the core concepts of Lightning is the ability for components to fire and handle event that occur when, for instance, a user clicks a button or the underlying data of a component changes. In this tutorial we’ll just concern ourselves with user generated events. Events add an interactive layer to your app by enabling you to share data between components. This allows you to quickly assemble loosely coupled components that communicate and share data via events.</p>
<p>In line #5 of our ProductViewer component, we declared that the component may fire an event called <b>addToCartEvent</b>. Create this new event by clicking File -> New -> Lightning Event, entering the name "AddToCart", hitting submit and entering the following code:</p>
{% highlight js %}
<aura:event type="APPLICATION" description="Add to cart event.">
  <aura:attribute name="product" type="aotpjd.Product__c"/>
</aura:event>
{% endhighlight %}
<p>The event itself contains an attribute called <b>product</b> which is a reference to a <b>Product__c</b> record. In a nutshell, the JavaScript controller will wrap up the product record in the event, fire the event and any component listening for that event will have access to the product record and can act on it accordingly.</p>
<p>An event can scoped either to a "component" or "application" level. According to the docs:</p>
<ol>
<li>A component event can be handled by a component itself or by a component that instantiates or contains the component.</li>
<li>Application events follow a traditional publish-subscribe model. An application event is fired from an instance of a component. All components that provide a handler for the event are notified.</li>
</ol>
<blockquote>
<p>I’ve always used application events and don’t see the real difference between the two. I’ve had a number of conversations with the Dev Evangelism team and we couldn’t really come up with a good use case of when to use component over application events. Perhaps, if you want to tie a single event to a single component that listens and handles it? Perhaps someone smarter than me can clue me in.</p>
</blockquote>
<p>Now we need to add the client-side JavaScript controller for the component which reacts to action from the UI. On the right side of the ProductViewer.cmp, click the "Controller" bar to create the ProductViewerController.js file for you. Paste in the following code:</p>
{% highlight js %}({
  doInit : function(component, event, helper) {
    // for demo, just grab this product by name
    helper.getProduct(component, 'Always Be Yourself');
    helper.getProducts(component);
  },
  change : function(component, event, helper) {
    // get the value of the select option
    selectedName = event.target.value;
    helper.getProduct(component, selectedName);
  },  
  addToCart : function(component, event, helper) {
    var product = component.get("v.product");
    var evt = $A.get("e.aotpjd:AddToCart");
    evt.setParams({
    "product": product
    });
    evt.fire();
  },
})
{% endhighlight %}
<p>The controller contains three functions. The first one, <b>doInit</b>, is called when the component initializes and loads the component with data. We’ve moved that code to a helper file to promote code reuse and we’ll look at that file in a second. The <b>change</b> function gets the value of the currently select picklist value (after onchange has been fired) and calls the helper function to actually change which product record from the database is currently being displayed in the UI. We’ll look at that code in a second as well ... it’s the same as above (code reuse!).</p>
<p>The meat of the controller is the <b>AddToCart</b> function which fires our <b>AddToCart</b> method that notifies our other components that a product has been added to our cart. Line #13 grabs a reference to the currently displaying product from the attribute and line #14 gets an instance of the AddToCart event. We then set the currently displaying product to the <b>product</b> param and then fire the event for all of the components to hear.</p>
<p>Our component helper, again, contains function that are used in multiple parts of our controller. You aren’t required to use a helper, everything can go in the controller, but it makes life easier. On the right side of the ProductViewer.cmp, click the "Helper" bar to create the ProductViewerHelper.js file for you. Paste in the following code:</p>
{% highlight js %}({
  getProducts: function(component) {
    var action = component.get("c.getProducts");
    var self = this;
    action.setCallback(this, function(a) {
      component.set("v.products", a.getReturnValue());
    });
    $A.enqueueAction(action);
  },
  getProduct: function(component, productName) {
    var action = component.get("c.getProductByName");
    action.setParams({
     "name": productName
    });
    var self = this;
    action.setCallback(this, function(a) {
      // display the product to the chrome dev console
      console.log(a.getReturnValue());
      component.set("v.product", a.getReturnValue());
    });
    $A.enqueueAction(action);
  },
})
{% endhighlight %}
<p>We have two function in the helper, one to return all records in the database to the component (for the select list) and one to return a specific record to the component by name (the currently viewing product record). Lline #2 returns an instance of the server-side method <b>getProducts</b> in the Apex controller. Line #5, passes in a function to be called after the server responds. When the Apex controller returns the list of product records, line #6 sets the list to the value of the products attribute.</p>
<p>The <b>getProduct</b> function is similar but is passed the value of the record name and passes that to the Apex controller method so that it knows which record to return in the SOQL query.</p>
<p>Now we need to add the last major part of the application, the cart component that tracks which products the person wants to receive. Click File -> New -> Lightning Component, enter the name as "ShoppingCart", click submit and paste in the following code:</p>
{% highlight js %}
<aura:component>
  <aura:attribute name="items" type="aotpjd.Product__c[]"/>
  <aura:attribute name="total" type="Integer" default="0"/>
  <aura:handler event="aotpjd:AddToCart" action="{!c.handleAddToCartEvent}"/>

  <div class="col-lg-9 col-md-9 col-sm-12">
    <div class="col-lg-12 col-sm-12">
      <span class="title">COMPANY STORE BASKET</span>
    </div>
    <aura:renderIf isTrue="{!v.items.length > 0}">
    <div class="col-lg-12 col-sm-12 hero-feature">
      <table class="table table-bordered tbl-cart">
        <thead>
          <tr>
            <td class="hidden-xs">Image</td>
            <td>Product Name</td>
            <td>Size</td>
            <td>Color</td>
            <td>Points</td>
          </tr>
        </thead>
        <tbody>
          <aura:iteration items="{!v.items}" var="item">
          <tr>
            <td class="hidden-xs"><img src="{!item.aotpjd__photo__c}" alt="{!item.name}" title="" width="47" height="47" /></td>
            <td>{!item.name}
            </td>
            <td>
              <select>
                <aura:iteration items="{!item.aotpjd__Product_Sizes__r}" var="size">
                  <option>{!size.name}</option>
                </aura:iteration>
              </select>
            </td>
            <td>{!item.aotpjd__color__c}</td>
            <td>{!item.aotpjd__points__c}</td>
          </tr>
          </aura:iteration>
          <tr>
            <td colspan="3" align="right">Total Points</td>
            <td class="total" colspan="2"><b>{!v.total}</b>
            </td>
          </tr>
        </tbody>
      </table>
      <a href="#" class="btn btn-primary"><i class="fa fa-shopping-cart"></i> Confirm your order</a>

    </div>
    </aura:renderIf>
    <aura:renderIf isTrue="{!v.items.length == 0}">
      <div class="col-lg-12 col-sm-12 hero-feature">
        <p>Your basket is empty. So sad. Use your points to redeem something #awesome!</p>
      </div>
    </aura:renderIf>
  </div>
</aura:component>
{% endhighlight %}
<p>This component contains two attributes</p>
<ol>
<li>items - the array of current product items in the cart</li>
<li>total - the current total of points for all items in the cart</li>
</ol>
<p>Line #4 is the important part of this component. This <b>handleAddToCartEvent</b> event handler in the JavaScript controller (which we’ll write in a second) runs when the <b>AddToCart</b> application event you created is fired. In this component we display a standard shopping cart. The functionality in this component is similar enough from the other components that it doesn’t require much explanation. We do however, render the cart only in line #10 if there are at least one item in the cart.</p>
<p>The controller contains the handler that listens for our application event so let's create it. On the right side of the ShoppingCart.cmp, click the "Controller" bar to create the ShoppingCartController.js file for you. Paste in the following code:</p>
{% highlight js %}({
  handleAddToCartEvent : function(component, event, helper) {
    var product = event.getParam("product");
    var items = component.get("v.items");
    if (!items) items = []; 
    items.push(product);
    component.set("v.total", parseInt(component.get("v.total")) + product.aotpjd__Points__c);
    component.set("v.items", items);
  },
})
{% endhighlight %}
<p>The <b>handleAddToCartEvent</b> function fires whenever it receives an <b>AddToCart</b> application event. In line #3 it gets the product sent over with the event and gets the array of items from the component. Then starting in line #6, it adds the product to the array of items and updates the total number of items and items themselves in the component which rerenders the UI.</p>
<p>The final piece of the application is nothing special but I added it to demonstrate multiple components listening for events. Create the MessageArea component and its associated controller. This component simply listens for the AddToCart application event and displays the name of the added product. Nothing fantastically awesome.</p>
{% highlight js %}
<aura:component>
  <aura:attribute name="message" type="String"/>
  <aura:handler event="aotpjd:AddToCart" action="{!c.handleShowMessage}"/>
  <div class="text-center" style="padding-bottom:25px">
    {!v.message}
  </div>
</aura:component>
{% endhighlight %}
{% highlight js %}({
  handleShowMessage : function(component, event, helper) {
    var product = event.getParam("product");
    component.set('v.message', 'Thanks for adding ' + product.Name);
  },
})
{% endhighlight %}
<p>So there’s your application that includes multiple components talking to each other with events and displaying data from an Apex controller. There is, of course, some functionality missing and some coding that could have been done differently but I thought this was the best route for a 'getting started' tutorial.</p>
