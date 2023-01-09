---
layout: post
title:  Tutorial - Building Lightning Components with Spring 15
description: This post is an update of Tutorial - Build Your First Lightning Component released last October during DF15 for the Winter ’15 release. A number of things have changed in Spring ’15 so the code has been revised to reflect them.  Salesforce1 Lightning Developer Week  is in full swing in over 100 cities around the world and I had the pleasure of presenting to the San Diego Salesforce Developer Group  a couple of days ago. Naturally we talked about Lightning Connect, Process Builder and App Builder
date: 2015-03-13 16:25:16 +0300
image:  '/images/pexels-hitesh-choudhary-879109.jpg'
tags:   ["2015", "public"]
---
<blockquote>
<p>This post is an update of <a href="/2014/10/14/tutorial-build-your-first-lightning-component/">Tutorial - Build Your First Lightning Component</a> released last October during DF15 for the Winter ’15 release. A number of things have changed in Spring ’15 so the code has been revised to reflect them.</p>
</blockquote>
<p><a href="https://developer.salesforce.com/developer-week">Salesforce1 Lightning Developer Week</a> is in full swing in over 100 cities around the world and I had the pleasure of presenting to the <a href="http://www.meetup.com/San-Diego-Salesforce-Developer-Group/">San Diego Salesforce Developer Group</a> a couple of days ago.</p>
<p>Naturally we talked about Lightning Connect, Process Builder and App Builder but as developers we focused mostly on the new Lightning Component Framework. I’ve updated this blog post and associated code to reflect the (rapid) changes in the component framework. The overall application still remains the same.</p>
<p><img src="images/sandiego-dug.jpg" alt="" ></p>
<p>So let’s get started with some basic concepts. Lightning applications are composed of Lightning components. There’s not much difference the two with the exception that components must live inside an application. Before you proceed with this tutorial, I would suggest you take a look at the <a href="https://developer.salesforce.com/resource/pdfs/Lightning_QuickStart.pdf">Lightning Components Quick Start</a> which has a super simple guide to get a “hello world” up and running quickly. You might want to also check out the <a href="https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/">Lightning Components Developer’s Guide</a> for a great “Getting Started” expense tracker tutorial. We are going to build something a little more complex so let’s get started. <strong>All of the following code is available <a href="https://gist.github.com/jeffdonthemic/39791ab40112a81f0168">in this gist</a>.</strong></p>
<p>The application we are going to build is an Employee Store (similar to a shopping cart) where users can redeem their “reward points” for products. From a high level, the app has a picker component that allows the user to choose the product to view from a Custom Object, a product view component that displays the currently selected product from the picker, a cart component that tracks products added to the cart and a small notification component that simply displays the name of the last product added to the cart. The app emits an application level event whenever a product is added to the cart that is handled by the various components listening for that event (e.g., the cart and the notification panel).</p>
<div class="flex-video">
 <object id="scPlayer" width="399" height="325" type="application/x-shockwave-flash" data="http://content.screencast.com/users/CloudSpokes/folders/Default/media/b4fb0e58-7093-437e-a5d6-40f3f2595026/bootstrap.swf" >
 <param name="movie" value="http://content.screencast.com/users/CloudSpokes/folders/Default/media/b4fb0e58-7093-437e-a5d6-40f3f2595026/bootstrap.swf" />
 <param name="quality" value="high" />
 <param name="bgcolor" value="#FFFFFF" />
 <param name="flashVars" value="thumb=http://content.screencast.com/users/CloudSpokes/folders/Default/media/b4fb0e58-7093-437e-a5d6-40f3f2595026/FirstFrame.jpg&containerwidth=787&containerheight=641&content=http://content.screencast.com/users/CloudSpokes/folders/Default/media/b4fb0e58-7093-437e-a5d6-40f3f2595026/00000018.swf&blurover=false" />
 <param name="allowFullScreen" value="true" />
 <param name="scale" value="showall" />
 <param name="allowScriptAccess" value="always" />
 <param name="base" value="http://content.screencast.com/users/CloudSpokes/folders/Default/media/b4fb0e58-7093-437e-a5d6-40f3f2595026/" />
 Unable to display content. Adobe Flash is required.
</object> 
</div>
<p>A Lightning component is actually a bundle of a number of files. Only the component or application is actually required but you’ll typically use at least a client-side controller as well. Here’s a breakdown of what’s in a component:</p>
<p>Component or Application (MyComponent.cmp or MyApp.app) - This file contains the declarative markup for the component or app.</p>
<p>Controller (MyComponentController.js) - This file contains the client-side JavaScript controller methods to handle events fired and handled by the components.</p>
<p>CSS Styles (MyComponent.css) - The CSS styles scoped to the component.</p>
<p>Helper (MyComponentHelper.js) - This file contains JavaScript functions that can be called from any JavaScript code in a component’s bundle. Typically you’d move commonly used code from your controllers into a helper for reuse.</p>
<p>Components can also contain custom renderers and documentation but that is beyond the scope of this tutorial.</p>
<h2 id="orgsetup">Org Setup</h2>
<p>To get started, the first thing you’ll need to do is <a href="https://developer.salesforce.com/signup">signup for a new Spring '15 Developer org</a> and enable Lightning components. Older orgs have namespace requirements and/or may not be enabled for Lightning. Once you’ve logged in, click Develop -> Lightning Components and select the “Enable Lightning Components” and “Enable Debug Mode” checkboxes and click Save.</p>
<h2 id="applicationsetup">Application Setup</h2>
<p>Create the two Custom Objects to hold your data product data. We’ll create a <code>Product__c</code> object and a <code>Product_Size__c</code> object that looks like the following. You can either follow the steps manually below or use <a href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04tj0000001ZZWO">this unmanaged package</a> to install the Custom Objects and Apex Controller.</p>
<p><a href="https://gist.github.com/jeffdonthemic/39791ab40112a81f0168#file-product__c-object">Product__c</a><br>
<code>Name</code> (the default name field)<br>
<code>Color__c</code> (text 25)<br>
<code>Description__c</code> (textarea)<br>
<code>Photo__c</code> (url)<br>
<code>Points__c</code> (number 18,0)</p>
<p><a href="https://gist.github.com/jeffdonthemic/39791ab40112a81f0168#file-product_size__c-object">Product_Size__c</a><br>
<code>Name</code> (default name field)<br>
<code>Product__c</code> (master-detail to Product__c)</p>
<p>Go ahead and populate your objects with 3–4 records. <strong>Make sure one of the Products is named, “Always Be Yourself”</strong> as this is hard-coded for the demo. I used <a href="http://www.snorgtees.com/">snorgtees</a> for some funny shirts but use whatever you’d like.</p>
<p>Now create the following <code>AwesomeProductController</code> Apex Controller that has methods to return a list of all products and a specific product by name. The <code>@AuraEnabled</code> annotation is needed so that these method are available to Lightning components.</p>
{% highlight js %}public class AwesomeProductController {
  @AuraEnabled
  public static List<Product__c> getProducts() {
  return [select id, name, photo__c, description__c, points__c from product__c];
  }

  @AuraEnabled
  public static Product__c getProductByName(String name) {
  return [select id, name, photo__c, color__c,
    points__c, description__c,
    (select name from product_sizes__r order by name)
    from product__c where name = :name];
  }
}
{% endhighlight %}
<p>Finally, we’ll upload some CSS and JavaScript files that will be needed to make the app look pretty (as pretty as I can make it). Upload the <a href="https://www.dropbox.com/s/62dccqxor844xn2/companystore.zip?dl=0">companystore.zip</a> as a Static Resource and name it <code>companystore</code>.</p>
<blockquote>
<p>One of the changes in Spring ’15 is that the namespace requirement for you code has been removed. Now you can simply use the default 'c’ namespace! The code for this tutorial uses the default namespace, so if you have a custom namespace, replace 'c’ with your own namespace.</p>
</blockquote>
<h2 id="writeawesomecode">Write Awesome Code</h2>
<p>OK, so now we have the “setup” portion of our app done, let’s write some code. Currently you can only write Lightning components in the Developer Console or using <a href="https://github.com/dcarroll/sublime-lightning">Dave Carroll’s Sublime Text plugin</a>. We’re going to use the Developer Console so click <your_name> and then Developer Console to open it up.</p>
<p>Lightning executes most operations asynchronously, including the loading static resources (CSS, JavaScript, etc.). This has caused a <a href="http://blog.enree.co/2014/10/salesforce-lightning-loading-scripts.html">number of headaches with developers</a>. We’ll be using Raja Rao’s <a href="https://github.com/rajaraodv/loadcomponent">load component</a> to load static resources in series due to jQuery and Bootstrap dependencies. We’ll need to create the load component and the event that it emits. Create the event first by clicking File -> New -> Lightning Event, entering the name “staticResourcesLoaded”. For our application this file will need no further modifications; you can simply close it. Next, create the load component by clicking File -> New -> Lightning Component and naming it “load”. After submitting, enter the following code for the component:</p>
{% highlight js %}<aura:component >
  <aura:attribute name="filesInSeries" type="String[]"/>
  <aura:attribute name="filesInParallel" type="String[]"/>
	<aura:handler name="init" value="{!this}" action="{!c.init}"/>
  <aura:registerEvent name="staticResourcesLoaded" type="c:staticResourcesLoaded"/>
</aura:component>
{% endhighlight %}
<p>Now click the “Controller” bar on the right side and enter the following JavaScript code:</p>
{% highlight js %}({

 init: function(component, event, helper) {

  //Modified version of https://github.com/malko/l.js to support resource files without JS or CSS extensions.
  !(function(t,e){var r=function(e){(t.execScript||function(e){t["eval"].call(t,e)})(e)},i=function(t,e){return t instanceof(e||Array)},s=document,n="getElementsByTagName",a="length",c="readyState",l="onreadystatechange",u=s[n]("script"),o=u[u[a]-1],f=o.innerHTML.replace(/^\s+|\s+$/g,"");if(!t.ljs){var h=o.src.match(/checkLoaded/)?1:0,d=s[n]("head")[0]||s.documentElement,p=function(t){var e={};e.u=t.replace(/#(=)?([^#]*)?/g,function(t,r,i){e[r?"f":"i"]=i;return""});return e},v=function(t,e,r){var i=s.createElement(t),n;if(r){if(i[c]){i[l]=function(){if(i[c]==="loaded"||i[c]==="complete"){i[l]=null;r()}}}else{i.onload=r}}for(n in e){e[n]&&(i[n]=e[n])}d.appendChild(i)},m=function(t,e){if(this.aliases&&this.aliases[t]){var r=this.aliases[t].slice(0);i(r)||(r=[r]);e&&r.push(e);return this.load.apply(this,r)}if(i(t)){for(var s=t[a];s--;){this.load(t[s])}e&&t.push(e);return this.load.apply(this,t)}if(t.match(/\.js\b/)||t.match(/\.sfjs\b/)){t=t.replace(".sfjs","");return this.loadjs(t,e)}else if(t.match(/\.css\b/)||t.match(/\.sfcss\b/)){t=t.replace(".sfcss","");return this.loadcss(t,e)}else{return this.loadjs(t,e)}},y={},g={aliases:{},loadjs:function(t,r){var i=p(t);t=i.u;if(y[t]===true){r&&r();return this}else if(y[t]!==e){if(r){y[t]=function(t,e){return function(){t&&t();e&&e()}}(y[t],r)}return this}y[t]=function(e){return function(){y[t]=true;e&&e()}}(r);r=function(){y[t]()};v("script",{type:"text/javascript",src:t,id:i.i,onerror:function(t){if(i.f){var e=t.currentTarget;e.parentNode.removeChild(e);v("script",{type:"text/javascript",src:i.f,id:i.i},r)}}},r);return this},loadcss:function(t,e){var r=p(t);t=r.u;y[t]||v("link",{type:"text/css",rel:"stylesheet",href:t,id:r.i});y[t]=true;e&&e();return this},load:function(){var t=arguments,r=t[a];if(r===1&&i(t[0],Function)){t[0]();return this}m.call(this,t[0],r<=1?e:function(){g.load.apply(g,[].slice.call(t,1))});return this},addAliases:function(t){for(var e in t){this.aliases[e]=i(t[e])?t[e].slice(0):t[e]}return this}};if(h){var j,b,x,A;for(j=0,b=u[a];j** 0) {
 loadInParallel(filesInParallel, function() {
  if (filesInSeries.length > 0) {
   loadInSeries(filesInSeries, finalCB);
  } else {
   finalCB();
  }
 });
  } else if (filesInSeries.length > 0) {
 loadInSeries(filesInSeries, finalCB);
  }
 }

})
{% endhighlight %}
<p>Now choose File -> Save All and we’ll have all the code we need to load our static resources successfully.</p>
<p>Now we can really get started coding. Click File -> New -> Lightning Application, enter the name as “CompanyStore” and click submit. This is our Lightning app which will contain all of our components. Now enter the following code for a simple “hello world”:</p>
{% highlight js %}<aura:application > 
  <c:load filesInSeries="/resource/companystore/jquery-1.11.2.min.js,/resource/companystore/bootstrap/bootstrap.js,/resource/companystore/bootstrap/bootstrap.css,/resource/companystore/style.css"/>  
  hello world
</aura:application>
{% endhighlight %}
<p>When you open <code>https://[your-pod].lightning.force.com/c/CompanyStore.app</code> in your browser you should see an awesome “hello world”.</p>
<p>To make development a little easier, we’re going to create some blank components and then fill them in with code as we go along. This makes life easier when working with dependencies. Create the following 3 components by clicking File -> New -> Lightning Component, enter the names as below:</p>
<ol>
<li>ProductViewer</li>
<li>ShoppingCart</li>
<li>MessageArea</li>
</ol>
<p>Now replace “hello world” in your component with <code><c:ProductViewer/></code>. This is the main UI component and functionality for our application. Refresh your app and it should display a blank screen now. Now let’s add some code. Open the ProductView component and add the following code:</p>
{% highlight js %}<aura:component controller="AwesomeProductController">
  <aura:attribute name="product" type="Product__c" default="{'sobjectType': 'Product__c'}"/>
  <aura:attribute name="products" type="Product__c[]"/>
  <aura:handler name="init" value="{!this}" action="{!c.doInit}" />

  <div class="container"> 
  <div class="row">
  <div class="col-lg-3 col-md-4 col-sm-5">
    <div class="well">
    <div class="btn-group btn-group-cart">
    <select onchange="{!c.change}">
      <aura:iteration items="{!v.products}" var="p">
      <option>{!p.Name}</option>
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
	  		<span class="title">{!v.product.Name}</span>
	  	</div>
		    <div class="thumbnail col-lg-12 col-md-12 col-sm-6 text-center">
		    	[
      ![]({!v.product.Photo__c})
		    	](detail.html)
		    <div class="caption prod-caption">

{!v.product.Description__c}

		    	<div class="btn-group">
			    	[{!v.product.Points__c} pts](#)
			    	[ Add](#)
		    	</div>

		    </div>
		    </div>
				</div>

  	</div>

  	<div class="clearfix visible-sm"></div>

  <c:ShoppingCart />

  <c:MessageArea />

  </div>
	</div>
</aura:component>
{% endhighlight %}
<p>The first few lines in the component are really important so let’s dive into them. In line #1, we define that our component will use the <code>AwesomeProductController</code> so that we’ll be able to use the two methods in it and retrieve our records from the database.</p>
<p>Lines #2 & #3 are attributes of the component. Component attributes are similar to member variables in Apex classes. They are typed fields that are set on a specific instance of a component, and can be referenced from within the component’s markup using an expression syntax. We’ll need the <code>product</code> attribute to reference the current product record we are displaying and the <code>products</code> attribute so we can display all of the products in the database in the select list.</p>
<p>In line #4 we specify a handler in the JavaScript controller that fires when the component initializes. This init handler triggers the <code>doInit</code> method in the client-side controller, which calls the Apex controller to query the database and populate the component with initial data. We’ll write this code in a second.</p>
<p>Most of this file is HTML markup with bootstrap but there are some other important pieces to point out. Lines #11–15 setup a select list with data from the database. This way you can easily switch and display different products (mostly for demo purposes). We use the builtin <code>aura:iteration></code> element to iterate the collection of product records returned from the database. The name of that attribute is <code>products</code>, while <code>v.</code> is the value provider for a component’s attribute set, which represents the view. We also have an onchange handler that calls the <code>change</code> function in the JavaScript controller whenever the select list value changes.</p>
<p>Interspersed in the HTML we display values such as name, color and description from the database with the <code>product</code> attribute. Notice in line #29 we output standard fields with <code>{!v.product.Name}</code> while custom fields use the namespace, <code>{!v.product.yourname__Photo__c}</code> if you are using a namespace. If not, you can simply use <code>{!v.product.yourname__Photo__c}</code>.</p>
<blockquote>
<p>Unlike Apex, JavaScript is case sensitive. Therefore, the fields referenced in your expressions must be the same case as they are on the object. Notice I used <code>{!v.product.Name}</code> and <code>{!v.product.Photo__c}</code>.</p>
</blockquote>
<p>Lightning has a bunch of extremely useful core UI components for inputText, inputDate, InputCheckbox, button, etc. but in line #40 we use a simple onclick action to call the <code>addToCart</code> function in the JavaScript controller. Now we need to add this functionality to add items to the cart.</p>
<h2 id="eventsawesome">Events === #AWESOME</h2>
<p>One of the core concepts of Lightning is the ability for components to fire and handle event that occur when, for instance, a user clicks a button or the underlying data of a component changes. In this tutorial we’ll just concern ourselves with user generated events. Events add an interactive layer to your app by enabling you to share data between components. This allows you to quickly assemble loosely coupled components that communicate and share data via events.</p>
<p>Add the following line of code in ProductViewer.cmp right after the init handler.</p>
{% highlight js %}<aura:registerEvent name="addToCartEvent" type="c:AddToCart"/>
{% endhighlight %}
<p>With this line we declared that the component may fire an event called <code>addToCartEvent</code>. Create this new event by clicking File -> New -> Lightning Event, entering the name “AddToCart”, hitting submit and entering the following code:</p>
{% highlight js %}<aura:event type="APPLICATION" description="Add to cart event.">
  <aura:attribute name="product" type="Product__c"/>
</aura:event>
{% endhighlight %}
<p>The event itself is pretty basic and only contains an attribute called <code>product</code> which is a reference to a <code>Product__c</code> record. In a nutshell, the JavaScript controller will wrap up the product record in the event, fire the event and any component listening for that event will have access to the product record and can act on it accordingly. We’ll write this JavaScript in a second but first let’s talk about events and their scope.</p>
<p>An event can scoped either to a “component” or “application” level. According to the docs:</p>
<ol>
<li>A component event can be handled by a component itself or by a component that instantiates or contains the component.</li>
<li>Application events follow a traditional publish-subscribe model. An application event is fired from an instance of a component. All components that provide a handler for the event are notified.</li>
</ol>
<blockquote>
<p>I’ve always used application events and don’t see the real difference between the two. I’ve had a number of conversations with the Dev Evangelism team and we couldn’t really come up with a good use case of when to use component over application events. Perhaps, if you want to tie a single event to a single component that listens and handles it? Perhaps someone smarter than me can clue me in.</p>
</blockquote>
<p>Now we need to add the client-side JavaScript controller for the component which reacts to action from the UI. On the right side of the ProductViewer.cmp, click the “Controller” bar to create the ProductViewerController.js file for you. Paste in the following code:</p>
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
  var evt = $A.get("e.c:AddToCart");
  evt.setParams({
  "product": product
  });
  evt.fire();
  },
})
{% endhighlight %}
<p>The controller contains three functions. The first one, <code>doInit</code>, is called when the component initializes and loads the component with data. We’ve moved that code to a helper file to promote code reuse and we’ll look at that file in a second. The <code>change</code> function gets the value of the currently select picklist value (after onchange has been fired) and calls the helper function to actually change which product record from the database is currently being displayed in the UI. We’ll look at that code in a second as well … it’s the same as above (code reuse!).</p>
<p>The meat of the controller is the <code>AddToCart</code> function which fires our <code>AddToCart</code> method that notifies our other components that a product has been added to our cart. Line #13 grabs a reference to the currently displaying product from the attribute and line #14 gets an instance of the AddToCart event. We then set the currently displaying product to the <code>product</code> param in the event and then fire the event for all of the components to hear.</p>
<p>Our component helper, once again, contains functions that are used in multiple parts of our controller. You aren’t required to use a helper, everything can go in the controller, but it makes life easier. On the right side of the ProductViewer.cmp, click the “Helper” bar to create the ProductViewerHelper.js file for you. Paste in the following code:</p>
{% highlight js %}({
  getProducts: function(component) {
  var action = component.get("c.getProducts");
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
  action.setCallback(this, function(a) {
  // display the product to the chrome dev console (for fun)
  console.log(a.getReturnValue());
  component.set("v.product", a.getReturnValue());
  });
  $A.enqueueAction(action);
  },
})
{% endhighlight %}
<p>We have two function in the helper, one to return all records in the database to the component (for the select list) and one to return a specific record to the component by name (the currently viewing product record). Line #3 returns an instance of the server-side method <code>getProducts</code> in the Apex controller. Line #4, passes in a function to be called after the server responds (the callback). When the Apex controller returns the list of product records, line #5 sets the list to the value of the products attribute.</p>
<p>The <code>getProduct</code> function is similar but is passed the value of the record name (e.g., “Always Be Yourself”) and passes that to the Apex controller method so that it knows which record to return in the SOQL query.</p>
<p>Now we need to add the last major part of the application, the cart component that tracks which products the person wants to receive. Open the ShoppingCart component we create earlier and paste in the following code:</p>
{% highlight js %}<aura:component >
  <aura:attribute name="items" type="Product__c[]"/>
  <aura:attribute name="total" type="Integer" default="0"/>
  <aura:handler event="c:AddToCart" action="{!c.handleAddToCartEvent}"/>

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
    <td class="hidden-xs">![{!item.Name}]({!item.Photo__c})</td>
    <td>{!item.Name}
    </td>
    <td>
      <select>
      <aura:iteration items="{!item.Product_Sizes__r}" var="size">
      <option>{!size.Name}</option>
      </aura:iteration>
      </select>
    </td>
    <td>{!item.Color__c}</td>
    <td>{!item.Points__c}</td>
    </tr>
    </aura:iteration>
    <tr>
    <td colspan="3" align="right">Total Points</td>
    <td class="total" colspan="2"><b>{!v.total}**
    </td>
    </tr>
    </tbody>
  </table>
  [ Confirm your order](#)

  </div>
  </aura:renderIf>
  <aura:renderIf isTrue="{!v.items.length == 0}">
  <div class="col-lg-12 col-sm-12 hero-feature">

Your basket is empty. So sad. Use your points to redeem something #awesome!

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
<p>Line #4 is the important part of this component. This <code>handleAddToCartEvent</code> event handler in the JavaScript controller (which we’ll write in a second) runs when the <code>AddToCart</code> application event you created is received. In this component we display a standard shopping cart. The functionality in this component is similar enough from the other components that it doesn’t require much explanation. We do however, render the cart only in line #10 if there are at least one item in the cart.</p>
<p>The JavaScript controller contains the handler that listens for our application event so let’s create it. On the right side of the ShoppingCart.cmp, click the “Controller” bar to create the ShoppingCartController.js file for you. Paste in the following code:</p>
{% highlight js %}({
  handleAddToCartEvent : function(component, event, helper) {
  var product = event.getParam("product");
  var items = component.get("v.items");
  if (!items) items = []; 
  items.push(product);
  component.set("v.total", parseInt(component.get("v.total")) + product.Points__c);
  component.set("v.items", items);
  },
})
{% endhighlight %}
<p>The <code>handleAddToCartEvent</code> function fires whenever it receives an <code>AddToCart</code> application event. In line #3 it grabs the product sent over with the event and retrieves the array of items from the component. Then starting in line #6, it adds the product to the array of items in the cart and updates the total number of items and items themselves in the component which rerenders the UI.</p>
<p>The final piece of the application is nothing special but I added it to demonstrate multiple components listening for events. Open the MessageArea component and add the code below. This component simply listens for the AddToCart application event and calls the handleShowMessage method in the controller.</p>
{% highlight js %}<aura:component >
  <aura:attribute name="message" type="String"/>
  <aura:handler event="c:AddToCart" action="{!c.handleShowMessage}"/>
  <div class="text-center" style="padding-bottom:25px">
  {!v.message}
  </div>
</aura:component>
{% endhighlight %}
<p>The controller simply displays the name of the added product in the message. Nothing fantastically awesome.</p>
{% highlight js %}({
  handleShowMessage : function(component, event, helper) {
  var product = event.getParam("product");
  component.set('v.message', 'Thanks for adding ' + product.Name);
  },
})
{% endhighlight %}
<p><strong>Refresh the application and enjoy the magic of Salesforce1 Lightning!</strong></p>
<p>So there’s your Lightning application that includes multiple components talking to each other with events and displaying data from an Apex controller. There is, of course, some functionality missing and some coding that could have been done differently but I thought this was the best route for a 'getting started’ tutorial.</p>

