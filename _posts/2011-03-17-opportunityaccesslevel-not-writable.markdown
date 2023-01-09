---
layout: post
title:  OpportunityAccessLevel Not Writable
description: I was working on a project the other day where I needed to dynamically add users to an opportunitys Sales Team (OpportunityTeamMember object) so that users who do not normally have access to an opportunity based upon Org-wide security settings can work on the opportunity with other team members. One of the advantages of Sales Teams is that you can specify the level of access that each team member has for the opportunity. Some team members may need read/write access while others may just need rea
date: 2011-03-17 10:40:44 +0300
image:  '/images/slugs/opportunityaccesslevel-not-writable.jpg'
tags:   ["2011", "public"]
---
<p>I was working on a project the other day where I needed to dynamically add users to an opportunity's Sales Team (OpportunityTeamMember object) so that users who do not normally have access to an opportunity based upon Org-wide security settings can work on the opportunity with other team members. One of the advantages of Sales Teams is that you can specify the level of access that each team member has for the opportunity. Some team members may need read/write access while others may just need read-only access.</p>
<p>From the opportunity page layout you can add a new team member and specify their access level and role.</p>
<p><img title="sales-team.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401022422/xfxiglxjvxzoojrztkwu.png" border="0" alt="Sales team" width="500" height="186" /></p>
<p>However, by default when you create a new team member via Apex, the platform grants them read-only access. So I tried to specify grant "Edit" (read/write) access with the following code.</p>
{% highlight js %}OpportunityTeamMember member = new OpportunityTeamMember();
member.OpportunityId = SomeOpp.Id;
member.UserId = SomeUser.Id;
mmember.TeamMemberRole = 'Sales Rep';
member.OpportunityAccessLevel = 'Edit';
{% endhighlight %}
<p>Specifying the OpportunityAccessLevel threw the following error when saving my class:</p>
<blockquote>Save error: Field is not writable: OpportunityTeamMember.OpportunityAccessLevel</blockquote>
<p>To be fair, <a href="http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_objects_opportunityteammember.htm" target="_blank">the docs</a> state that OpportunityAccessLevel is not creatable but it used to be with earlier versions of the API so I <em><strong>really</strong></em> wanted this to work and it was screwing up my day.</p>
<p>So here's the solution that I can up with in case anyone is looking for a answers. You need to add the team members to the opportunity and then update the sharing access to the opportunity for these users.</p>
{% highlight js %}OpportunityTeamMember member = new OpportunityTeamMember();
member.OpportunityId = SomeOpp.Id;
member.UserId = SomeUser.Id;
mmember.TeamMemberRole = 'Sales Rep';

insert member;

// get all of the team members' sharing records
List<OpportunityShare> shares = [select Id, OpportunityAccessLevel, 
 RowCause from OpportunityShare where OpportunityId IN :SomeSetOfOpptyIds 
 and RowCause = 'Team'];
 
// set all team members access to read/write
for (OpportunityShare share : shares) 
 share.OpportunityAccessLevel = 'Edit';

update shares;
{% endhighlight %}

