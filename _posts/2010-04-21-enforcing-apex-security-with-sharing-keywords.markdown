---
layout: post
title:  Enforcing Apex Security With Sharing Keywords
description: Security is a major foundation of the Force.com platform. Not only is security available declaratively but it is also baked into the Apex language itself. Most Apex scripts run in system context without respect to the current users permissions, sharing rules and field level security. This ensures that triggers and web services have access to all records in the org which is usually a good thing. However, to ensure that you dont expose sensitive data to unauthorized users, you can specify that an 
date: 2010-04-21 16:00:00 +0300
image:  '/images/pexels-cottonbro-3951901.jpg'
tags:   ["salesforce", "apex"]
---
<p>Security is a major foundation of the Force.com platform. Not only is security available declaratively but it is also baked into the Apex language itself. Most Apex scripts run in system context without respect to the current users permissions, sharing rules and field level security. This ensures that triggers and web services have access to all records in the org which is usually a good thing.</p>
<p>However, to ensure that you don't expose sensitive data to unauthorized users, you can specify that an Apex script <strong>does enforce</strong> the running user's row-level security by using the <code>with sharing</code> keywords when declaring your class. This doesnt enforce the user's permissions and field-level security. Apex code always has access to all fields and objects in an organization, ensuring that code wont fail to run because of hidden fields or objects for a user. The <code>with sharing</code> keywords can affect SOQL and SOSL queries as well as DML operations so be careful.</p>
{% highlight js %}public with sharing class MyClass {
 // implement awesome code here
}
{% endhighlight %}
<p>You can also use the <code>without sharing</code> keywords to ensure that Apex scripts <strong>do not enforce</strong> the sharing rules of the running user.</p>
{% highlight js %}public without sharing class MyClass {
 // implement awesome code here
}
{% endhighlight %}
<p>It's best practices to use these keywords with declaring new classes as if they are not used, the current sharing rules remain in effect. For example, if a class without sharing keywords specified is called by another class, then the sharing is enforced by the first class.</p>
<p>You can also declare inner classes and outer classes as with sharing as well. The sharing setting applies to all code contained in the class, including initialization code, constructors, and methods but inner classes do not inherit the sharing setting from their container class.</p>
<p>Once exception is executeAnonymous and Chatter in Apex which always executes using the full permissions of the current user.</p>
<p>See the Apex Developer Guide on <a href="https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_security_sharing_rules.htm">enforcing sharing rules</a> for more info.</p>

