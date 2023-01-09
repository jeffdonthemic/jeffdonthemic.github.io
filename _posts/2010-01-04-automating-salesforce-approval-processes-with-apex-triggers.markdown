---
layout: post
title:  Automating Salesforce Approval Processes with Apex Triggers
description: This question came up on LinkedIn asking how to automatically fire off an approval process when an Opportunity reaches 30% probability. This example was on my to do list so I thought I would knock it out quickly. The trigger fires when an Opportunity is updated and is submitted for approval if the Opportunitys probability has moved from less than 30% to greater than or equal to 30%. For the trigger to work you need to have an approval process with matching criteria. Mine is fairly simple and is 
date: 2010-01-04 10:19:26 +0300
image:  '/images/slugs/automating-salesforce-approval-processes-with-apex-triggers.jpg'
tags:   ["2010", "public"]
---
<p>This question came up on LinkedIn asking how to automatically fire off an approval process when an Opportunity reaches 30% probability. This example was on my to do list so I thought I would knock it out quickly.</p>
<p>The trigger fires when an Opportunity is updated and is submitted for approval if the Opportunity's probability has moved from less than 30% to greater than or equal to 30%.</p>
<p>For the trigger to work you need to have an approval process with matching criteria. Mine is fairly simple and is where the Opportunity owner is the current user (there is only one user in a DE org). The trigger makes no attempt to trap for errors if an approval process doesn't exist as I didn't have time.</p>
{% highlight js %}trigger OpportunitySubmitForApproval on Opportunity (after update) {

	for (Integer i = 0; i < Trigger.new.size(); i++) {

		if (Trigger.old[i].Probability < 30 && Trigger.new[i].Probability >= 30) {

			// create the new approval request to submit
			Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
			req.setComments('Submitted for approval. Please approve.');
			req.setObjectId(Trigger.new[i].Id);
			// submit the approval request for processing
			Approval.ProcessResult result = Approval.process(req);
			// display if the reqeust was successful
			System.debug('Submitted for approval successfully: '+result.isSuccess());

		}

	}

}
{% endhighlight %}
<p>Here is the test class but you might want to enhance it to handle bulk operations and Opportunities that are not submitted for approval because their probability is not greater than 30%.</p>
{% highlight js %}@isTest
private class TestOpportunitySubmitForApproval {

  static testMethod void testApprovalSuccess() {

  Opportunity opp = new Opportunity();
  opp.Name = 'Test Opp';
  opp.Amount = 100;
  opp.CloseDate = Date.today();
  opp.Probability = 10;
  opp.StageName = 'Prospecting';
  // insert the new opp
  insert opp;
  // change the probability of the opp so the trigger submits it for approval
	opp.Probability = 40;
	// update the opp which should submit it for approval
	update opp;

  // ensure that the opp was submitted for approval
  List&lt;ProcessInstance&gt; processInstances = [select Id, Status from ProcessInstance where TargetObjectId = :opp.id];
	System.assertEquals(processInstances.size(),1);

  }

}
{% endhighlight %}

