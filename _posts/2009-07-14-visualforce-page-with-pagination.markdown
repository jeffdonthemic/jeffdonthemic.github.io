---
layout: post
title:  Visualforce Page with Pagination
description: Salesforce.com introduced the StandardSetController in Winter 09 and Im finally getting a chance to put it into use. The new pagination feature is pretty powerful and easy to use with standard as well as custom objects. Even though Jon Mountjoy has a good blog post here , there appears to be very little documentation or examples for pagination. I threw together a small demo that allows you to page through the query results and select multiple items to process. Instead of simply returning the lis
date: 2009-07-14 16:00:00 +0300
image:  '/images/slugs/visualforce-page-with-pagination.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>Salesforce.com introduced the StandardSetController in Winter '09 and I'm finally getting a chance to put it into use. The new pagination feature is pretty powerful and easy to use with standard as well as custom objects. Even though Jon Mountjoy has a <a href="http://blog.sforce.com/sforce/2008/09/visualforce-pag.html" target="_blank">good blog post here</a>, there appears to be very little documentation or examples for pagination.</p>
<p>I threw together a small demo that allows you to page through the query results and select multiple items to process. Instead of simply returning the list of sObjects from the query locator's current set, a collection of wrapper objects are returned enabling the user to check items for processing.</p>
<p><strong>You can </strong><a href="http://jeffdouglas-developer-edition.na5.force.com/examples/category_paging" target="_blank"><strong>run this demo</strong></a><strong> on my developer site.</strong></p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399531/paging1_zs6vhq.png"><img class="alignnone size-full wp-image-1015" title="paging1" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399531/paging1_zs6vhq.png" alt="paging1" width="544" height="179" /></a></p>
<p><strong>PagingController.cls - Custom Controller</strong></p>
{% highlight js %}public with sharing class PagingController {

	List<categoryWrapper> categories {get;set;}

	// instantiate the StandardSetController from a query locator
	public ApexPages.StandardSetController con {
		get {
			if(con == null) {
				con = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, Name FROM Cat3__c Order By Name limit 100]));
				// sets the number of records in each page set
				con.setPageSize(5);
			}
			return con;
		}
		set;
	}

	// returns a list of wrapper objects for the sObjects in the current page set
	public List<categoryWrapper> getCategories() {
		categories = new List<categoryWrapper>();
		for (Cat3__c category : (List<cat3__c>)con.getRecords())
			categories.add(new CategoryWrapper(category));

		return categories;
	}

	// displays the selected items
 	public PageReference process() {
 		for (CategoryWrapper cw : categories) {
 			if (cw.checked)
 				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,cw.cat.name));
 		}
 		return null;
 	}

	// indicates whether there are more records after the current page set.
	public Boolean hasNext {
		get {
			return con.getHasNext();
		}
		set;
	}

	// indicates whether there are more records before the current page set.
	public Boolean hasPrevious {
		get {
			return con.getHasPrevious();
		}
		set;
	}

	// returns the page number of the current page set
	public Integer pageNumber {
		get {
			return con.getPageNumber();
		}
		set;
	}

	// returns the first page of records
 	public void first() {
 		con.first();
 	}

 	// returns the last page of records
 	public void last() {
 		con.last();
 	}

 	// returns the previous page of records
 	public void previous() {
 		con.previous();
 	}

 	// returns the next page of records
 	public void next() {
 		con.next();
 	}

 	// returns the PageReference of the original page, if known, or the home page.
 	public void cancel() {
 		con.cancel();
 	}

}
{% endhighlight %}
<p><strong>CategoryWrapper.cls - Wrapper class for the Categories</strong></p>
{% highlight js %}public class CategoryWrapper {

  public Boolean checked{ get; set; }
  public Cat3__c cat { get; set;}

  public CategoryWrapper(){
  cat = new Cat3__c();
  checked = false;
  }

  public CategoryWrapper(Cat3__c c){
  cat = c;
  checked = false;
  }

  public static testMethod void testMe() {

  	CategoryWrapper cw = new CategoryWrapper();
  	System.assertEquals(cw.checked,false);

  	CategoryWrapper cw2 = new CategoryWrapper(new Cat3__c(name='Test1'));
  	System.assertEquals(cw2.cat.name,'Test1');
  	System.assertEquals(cw2.checked,false);

  }

}
{% endhighlight %}
<p><strong>Category_Paging.page - Visualforce page</strong></p>
{% highlight js %}<apex:page controller="PagingController">
 <apex:form >
  <apex:pageBlock title="Paging through Categories of Stuff">

 <apex:pageBlockButtons location="top">
  <apex:commandButton action="{!process}" value="Process Selected"/>
  <apex:commandButton action="{!cancel}" value="Cancel"/>
 </apex:pageBlockButtons>
 <apex:pageMessages />

 <apex:pageBlockSection title="Category Results - Page #{!pageNumber}" columns="1">
  <apex:pageBlockTable value="{!categories}" var="c">
   <apex:column width="25px">
  <apex:inputCheckbox value="{!c.checked}"/>
   </apex:column>
   <apex:column value="{!c.cat.Name}" headerValue="Name"/>
  </apex:pageBlockTable>
 </apex:pageBlockSection>
  </apex:pageBlock>

  <apex:panelGrid columns="4">
  <apex:commandLink action="{!first}">First</apex:commandlink>
  <apex:commandLink action="{!previous}" rendered="{!hasPrevious}">Previous</apex:commandlink>
  <apex:commandLink action="{!next}" rendered="{!hasNext}">Next</apex:commandlink>
  <apex:commandLink action="{!last}">Last</apex:commandlink>
  </apex:panelGrid>

 </apex:form>
</apex:page>
{% endhighlight %}

