---
layout: post
title:  Redirecting Users to Different Visualforce Pages
description: We have a large Salesforce.com org with 400+ recordtypes and 600+ page layouts. When Visualforce was released we wanted to start developing customized Visualforce pages for certain recordtypes. Unfortunately, you cannot assign Visualforce pages by recordtype so you have to implement a hack around it. Note- There is currently as issue with Visualforce in that inputFields do not respect recordtypes. So if you have picklists with values for different recordtypes, your picklists on your Visualforce 
date: 2008-11-14 19:53:57 +0300
image:  '/images/slugs/redirecting-users-to-different-visualforce-pages.jpg'
tags:   ["code sample", "salesforce", "visualforce", "apex"]
---
<p>We have a large Salesforce.com org with 400+ recordtypes and 600+ page layouts. When Visualforce was released we wanted to start developing customized Visualforce pages for certain recordtypes. Unfortunately, you cannot assign Visualforce pages by recordtype so you have to implement a hack around it.</p>
<p>Note: There is currently as issue with Visualforce in that inputFields do not respect recordtypes. So if you have picklists with values for different recordtypes, your picklists on your Visualforce pages will show <strong><em>all picklist values</em></strong> and not just those values for that recordtype. There is <a href="http://community.salesforce.com/sforce/board/message?board.id=Visualforce&message.id=6166#M6166" target="_blank">a thread</a> relating to this on the force.com discussion boards but Sam Arjmandi has <a href="http://salesforcesource.blogspot.com/2008/10/picklist-component-for-your-visualforce.html" target="_blank">posted a picklist component</a> for a workaround.</p>
<p>What you need to do is create a "dispatcher" Visualforce page (<code>Dispatcher_Contact_View.page</code>) and accompanying controller extension (DispatcherContactViewController.cls) and then override the appropriate button/link action (view, edit or new) with this new dispatcher Visualforce page. The code is slightly different depending on whether you are doing view, edit or new so I'll be showing them all. When a user clicks the view button/link for appropriate object, it loads the new Visualforce page. The Visualforce page loads the controller extension and perform some logic to determine if the user should be dispatched to your new view page (Contact_View_1) or the standard Salesforce.com view page.</p>
<p>You'll need to override each button to call the specific Visualforce page. <a href="/2009/06/26/overriding-standard-links-with-visualforce-pages/" target="_blank">Here's more info</a> on how to do that.</p>
<p><strong>Dispatcher_Contact_View</strong></p>
{% highlight js %}<apex:page standardController="Contact" extensions="DispatcherContactEditController"
	action="{!nullValue(redir.url, urlFor($Action.Contact.Edit, contact.id, null, true))}">
</apex:page>
{% endhighlight %}
<p><strong>DispatcherContactViewController.cls</strong></p>
{% highlight js %}public class DispatcherContactViewController {

	public DispatcherContactViewController(ApexPages.StandardController controller) {
		this.controller = controller;
	}

	public PageReference getRedir() {

		Contact c = [Select id, recordtypeid From Contact Where Id = :ApexPages.currentPage().getParameters().get('id')];

		PageReference newPage;

		if (c.recordtypeid == '111111111111') {
			newPage = Page.Contact_View_1;
		} else {
			newPage = new PageReference('/' + c.id);
			newPage.getParameters().put('nooverride', '1');
		}

		newPage.getParameters().put('id', c.id);
		return newPage.setRedirect(true);

	}

	private final ApexPages.StandardController controller;

}
{% endhighlight %}
<p>The code is somewhat similar for the edit and new use cases but does have some notable differences.</p>
<p><strong>Dispatcher_Contact_Edit</strong></p>
{% highlight js %}<apex:page standardController="Contact" extensions="DispatcherContactEditController"
	action="{!nullValue(redir.url, urlFor($Action.Contact.Edit, contact.id, null, true))}">
</apex:page>
{% endhighlight %}
<p><strong>DispatcherContactEditController.cls</strong></p>
{% highlight js %}public class DispatcherContactEditController {

  public DispatcherContactEditController(ApexPages.StandardController controller) {
  this.controller = controller;
  }

  public PageReference getRedir() {

  Contact c = [Select id, recordtypeid From Contact Where Id = :ApexPages.currentPage().getParameters().get('id')];

  PageReference newPage;

  if (c.recordtypeid == '111111111111') {
  newPage = Page.Contact_Edit_1;

  } else {
  newPage = new PageReference('/' + c.id + '/e');
  newPage.getParameters().put('nooverride', '1');
  }

  newPage.getParameters().put('id', c.id);

  return newPage.setRedirect(true);
  }

  private final ApexPages.StandardController controller;
}
{% endhighlight %}
<p><strong>Dispatcher_Contact_New</strong></p>
{% highlight js %}<apex:page standardController="Contact" extensions="DispatcherContactNewController"
	action="{!nullValue(redir.url, urlFor($Action.Contact.New, null, null, true))}">
</apex:page>
{% endhighlight %}
<p><strong>DispatcherContactNewController.cls</strong></p>
{% highlight js %}public class DispatcherContactNewController {

	public DispatcherContactNewController(ApexPages.StandardController controller) {
		this.controller = controller;
	}

	public PageReference getRedir() {

		PageReference newPage;

		if (ApexPages.currentPage().getParameters().get('RecordType') == '111111111111') {
			newPage = Page.Contact_New_1;
			return newPage.setRedirect(true);
		} else {
			return null;
		}

	}

	private final ApexPages.StandardController controller;
}
{% endhighlight %}

