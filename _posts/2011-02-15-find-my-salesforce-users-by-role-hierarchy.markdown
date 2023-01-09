---
layout: post
title:  Find My Salesforce Users by Role Hierarchy
description: This is a cool little script that finds everyone who works beneath me in the role hierarchy. So you pass the utility class a User ID and it chugs through all of the level beneath that User in the role hierarchy and returns the IDs of all of the users in those roles. Comes in handy if you need to find all of the uses that report to a particular Sales Manager, for instance. public with sharing class RoleUtils { 	 public static Set getRoleSubordinateUsers(Id userId) { 	   // get requested users rol
date: 2011-02-15 19:28:28 +0300
image:  '/images/slugs/find-my-salesforce-users-by-role-hierarchy.jpg'
tags:   ["2011", "public"]
---
<p>This is a cool little script that finds "everyone who works beneath me in the role hierarchy". So you pass the utility class a User ID and it chugs through all of the level beneath that User in the role hierarchy and returns the IDs of all of the users in those roles. Comes in handy if you need to find all of the uses that report to a particular Sales Manager, for instance.</p>
{% highlight js %}public with sharing class RoleUtils {
	
 public static Set<ID> getRoleSubordinateUsers(Id userId) {
 	
  // get requested user's role
  Id roleId = [select UserRoleId from User where Id = :userId].UserRoleId;
  // get all of the roles underneath the user
  Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
  // get all of the ids for the users in those roles
  Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where 
 UserRoleId IN :allSubRoleIds]);
  // return the ids as a set so you can do what you want with them
  return users.keySet();
 	
 }
	
 private static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
 	
  Set<ID> currentRoleIds = new Set<ID>();
  
  // get all of the roles underneath the passed roles
  for(UserRole userRole :[select Id from UserRole where ParentRoleId 
 IN :roleIds AND ParentRoleID != null])
  currentRoleIds.add(userRole.Id);
  
  // go fetch some more rolls!
  if(currentRoleIds.size() > 0)
 currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));

  return currentRoleIds;
  
 }

}
{% endhighlight %}

