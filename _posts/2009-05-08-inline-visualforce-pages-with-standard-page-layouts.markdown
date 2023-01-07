---
layout: post
title:  Use an Inline Visualforce Page with Standard Page Layouts
description: Let's face it, using standard page layouts is easy. Throw some field on the...
date: 2009-05-08 16:00:00 +0300
image:  '/images/stock/1.jpg'
tags:   ["2009", "public"]
---
<p>Let's face it, using standard page layouts is easy. Throw some field on the page, arrange some related lists and then essentially forget about the page. However, if you really need to customize the user experience you are almost always forced to write a custom Visualforce page that may require maintenance in the future. But what if you just want to tweak the page layout and give it a little Visualforce bling? Perhaps a custom related list from multiple objects, a Flickr mashup or a Google map of your canary's current location?</p>
<p>You can now add Visualforce pages to stardard page layouts basically in the same way you can S-Controls. The use case is that you have accounts with hundreds of opportunities each and users are getting tired of scrolling through pages and pages of records to find the ones that they need. Let's develop a Visualforce page and controller extension that provides them with a opportunity search interface on the account details page.</p>
<p>Here's what the final application looks like:</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399544/inline-vf1_mk5nas.png"><img class="alignnone size-medium wp-image-850" title="inline-vf1" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/h_194,w_300/v1400399544/inline-vf1_mk5nas.png" alt="inline-vf1" width="300" height="194" /></a></p>
<p>First we need to create the Visualforce page and controller extension. Our Visualforce page must use the standard Account controller or it will not show up on the list of available Visualforce pages on the page layout.</p>
<p><strong>OpportunitySearchController</strong></p>
<pre><code class="language-javascript">public class OpportunitySearchController {

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
    // the actual account
    private Account a;
	// the results from the search. do not init the results or a blank rows show up initially on page load
    public List&lt;opportunity&gt; searchResults {get;set;}

	// the text in the search box
    public string searchText {
    	get {
    		if (searchText == null) searchText = 'Acme'; // prefill the serach box for ease of use
    		return searchText;
    	}
    	set;
	}

    public OpportunitySearchController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        this.a = (Account)controller.getRecord();

    }

	// fired when the search button is clicked
	public PageReference search() {
		if (searchResults == null) {
			searchResults = new List&lt;opportunity&gt;(); // init the list if it is null
		} else {
			searchResults.clear(); // clear out the current results if they exist
		}
		// Note: you could have achieved the same results as above by just using:
		// searchResults = new List&lt;categoryWrapper&gt;();

		// use some dynamic soql to find the related opportunities by name
		String qry = 'Select o.Id, o.Name, o.StageName, o.CloseDate, o.Amount from Opportunity o Where AccountId = ''+a.Id+'' And o.Name LIKE '%'+searchText+'%' Order By o.Name';
		searchResults = Database.query(qry);
		return null;
	}

}

</code></pre>
<p><strong>Inline_Opportunity_Search</strong></p>
<pre><code class="language-html">&lt;apex:page standardController=&quot;Account&quot; extensions=&quot;OpportunitySearchController&quot;&gt;
	&lt;style type=&quot;text/css&quot;&gt;
		body {background: #F3F3EC; padding-top: 15px}
	&lt;/style&gt;

	&lt;apex:form &gt;
		&lt;apex:pageBlock title=&quot;Search for Opportunities by Keyword&quot; id=&quot;block&quot; mode=&quot;edit&quot;&gt;
			&lt;apex:pageMessages /&gt;

			&lt;apex:pageBlockSection &gt;
				&lt;apex:pageBlockSectionItem &gt;
					&lt;apex:outputLabel for=&quot;searchText&quot;&gt;Keyword&lt;/apex:outputLabel&gt;
					&lt;apex:panelGroup &gt;
					&lt;apex:inputText id=&quot;searchText&quot; value=&quot;{!searchText}&quot;/&gt;
					&lt;apex:commandButton value=&quot;Search&quot; action=&quot;{!search}&quot; rerender=&quot;resultsBlock&quot; status=&quot;status&quot;/&gt;
					&lt;/apex:panelGroup&gt;
				&lt;/apex:pageBlockSectionItem&gt;
			&lt;/apex:pageBlockSection&gt;
			&lt;apex:actionStatus id=&quot;status&quot; startText=&quot;Searching... please wait...&quot;/&gt;
			&lt;apex:pageBlockSection id=&quot;resultsBlock&quot; columns=&quot;1&quot;&gt;
				&lt;apex:pageBlockTable value=&quot;{!searchResults}&quot; var=&quot;o&quot; rendered=&quot;{!NOT(ISNULL(searchResults))}&quot;&gt;
		            &lt;apex:column headerValue=&quot;Name&quot;&gt;
		                &lt;apex:outputLink value=&quot;/{!o.Id}&quot;&gt;{!o.Name}&lt;/apex:outputLink&gt;
		            &lt;/apex:column&gt;
					&lt;apex:column value=&quot;{!o.StageName}&quot;/&gt;
					&lt;apex:column value=&quot;{!o.Amount}&quot;/&gt;
					&lt;apex:column value=&quot;{!o.CloseDate}&quot;/&gt;
				&lt;/apex:pageBlockTable&gt;
			&lt;/apex:pageBlockSection&gt;

		&lt;/apex:pageBlock&gt;
	&lt;/apex:form&gt;
&lt;/apex:page&gt;

</code></pre>
<p>Now all you simply have to do is add this new Visalforce page to your page layout and you're a hero!</p>
<p><img src="images/inline-vf2_kbdv3u.png" alt="" ></p>

