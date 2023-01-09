---
layout: post
title:  JDO/JPA Persistence with Google App Engine
description:  I ran across Max Ross blog today (hes a App Engine Engineer working on persistence) and was surprised to find a wealth of articles, code and tips on persistence using JDO and JPA on Google App Engine. Creating A Bidrectional Owned One-To-Many  - Code and demo of an owned, bidirectional, one-to-many relationship showing how you can can persist child objects simply by associating them with their parent objects  Executing Batch Gets - Use batch gets to super-efficiently querying for objects using 
date: 2009-12-24 15:19:06 +0300
image:  '/images/slugs/jdojpa-persistence-with-google-app-engine.jpg'
tags:   ["2009", "public"]
---
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399627/google_appengine_dwcy7t.png"><img class="alignleft size-full wp-image-743" style="padding-right:10px;" title="google_appengine" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399627/google_appengine_dwcy7t.png" alt="" width="175" height="175" /></a>I ran across <a href="http://gae-java-persistence.blogspot.com" target="_blank">Max Ross' blog</a> today (he's a App Engine Engineer working on persistence) and was surprised to find a wealth of articles, code and tips on persistence using JDO and JPA on Google App Engine.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/10/creating-bidrectional-owned-one-to-many.html" target="_blank">Creating A Bidrectional Owned One-To-Many</a> - Code and demo of an owned, bidirectional, one-to-many relationship showing how you can can persist child objects simply by associating them with their parent objects</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/10/executing-batch-gets.html" target="_blank">Executing Batch Gets</a> - Use batch gets to "super-efficiently" querying for objects using filters on the primary key property.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/10/updating-bidrectional-owned-one-to-many.html" target="_blank">Updating A Bidrectional Owned One-To-Many With A New Child</a> - Using "transparent persistent" to modify the persistent state of an object without explicit persistence calls to repersist it.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/10/keys-only-queries.html" target="_blank">Keys Only Queries</a> - Speeding up queries using a keys-only query.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/10/serialized-fields.html" target="_blank">Serialized Fields</a> - Store any class that implements Serializable in a single property.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/10/optimistic-locking-with-version.html" target="_blank">Optimistic Locking With @Version</a> - Using optimistic locking with long-running transactions to prevent users from updating stale data.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/11/unindexed-properties.html" target="_blank">Unindexed Properties</a> - Speed up datastore write operations while reducing CPU time.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/11/case-insensitive-queries.html" target="_blank">Case Insensitive Queries</a> - Performing case-insensitive queries.</p>
<p><a href="http://gae-java-persistence.blogspot.com/2009/12/queries-with-and-in-filters.html" target="_blank">Queries with != and IN filters</a> - Examination of the new support for != and IN query operators in the new SDK release.</p>

