---
layout: post
title:  Deploying with the Force.com Migration Tool (ANT)
description: The Force.com Migration Tool is a Java/Ant-based command-line utility for moving metadata between a local directory and a Force.com organization. It runs essentially the same as the Eclipse version  but provides a little more granular control. Setting up Eclipse with Ant. Initially was getting the following error during the build process Problem- failed to create task or type. I had to add the ant-saleforce.jar to the Ant runtime classpath (Window > Preferences > Ant > Runtime). These are instru
date: 2008-08-06 16:55:53 +0300
image:  '/images/slugs/deploying-with-the-forcecom-migration-tool-ant.jpg'
tags:   ["salesforce", "java"]
---
<p>The Force.com Migration Tool is a Java/Ant-based command-line utility for moving metadata between a local directory and a Force.com organization. It runs essentially the same as the <a href="http://jeffdonthemic.wordpress.com/2008/07/15/migrating-salesforcecom-configurations-with-the-metadata-api-forcecom-migration-tool/">Eclipse version</a> but provides a little more granular control.</p>
<p><strong>Setting up Eclipse with Ant.</strong></p>
<p>Initially was getting the following error during the build process "Problem: failed to create task or type". I had to add the ant-saleforce.jar to the Ant runtime classpath (Window > Preferences > Ant > Runtime).</p>
<p>These are instructions for setting up a new project for "Sandbox1"</p>
<ol>
	<li>Created a new project in Eclipse called "Deploy" for all of the deployment operations.</li>
	<li>Set the salesforce.com username, password and serverurl in the build.properties file.</li>
	<li>Created a folder under src for the sandbox (eg Sandbox1, Sun), so the resulting folder was Deploy/src/Sandbox1.</li>
	<li>In the Sandbox1 folder put package.xml which specifies the components that will be downloaded from the target instance. You can download all or specify the file names for each type. A sample package.xml is below. Objects will be downloaded to src/Sandbox1/src directory.</li>
</ol>
{% highlight js %}<types>
 <members>CreateCampaignStatusesTriggerTest</members>
 <name>ApexClass</name>
</types>
<types>
 <members>*</members>
 <name>ApexTrigger</name>
</types>
{% endhighlight %}
<p><strong>Retrieve Command</strong></p>
<p>You can download any files/folders from the target instance and delete them as needed.</p>
<p><strong>Deploy</strong></p>
<p>When you deploy to the target it using the deployRoot of 'Sandbox1/src', Ant looks at the package.xml file in the 'Sandbox1/src' folder to determine which objects to deploy. It appears that the package must contain a reference to all of the files that are in the directories or else it will fail.</p>
<p>If you try to deploy to one of the sandboxes that doesn't have enough code coverage, then the deploy operation will fail.</p>
<p>To deploy them all to prodcution, just change the build.properties setting and run deployRunAllTests or deployRunNamedTests for the desired sandbox files.</p>
<p><strong>Sample package.xml file</strong></p>
{% highlight js %}<?xml version="1.0" encoding="UTF-8"?>
<package xmlns="http://soap.sforce.com/2006/04/metadata">
    <types>
        <members>*</members>
        <name>ApexClass</name>
    </types>
    <types>
        <members>*</members>
        <name>ApexComponent</name>
    </types>
    <types>
        <members>*</members>
        <name>ApexPage</name>
    </types>
    <types>
        <members>*</members>
        <name>ApexTrigger</name>
    </types>
    <types>
        <members>*</members>
        <name>CustomApplication</name>
    </types>
    <types>
        <members>*</members>
        <members>Account</members>
        <name>CustomObject</name>
    </types>
    <types>
        <members>*</members>
        <name>CustomTab</name>
    </types>
    <types>
        <members>*</members>
        <name>HomePageComponent</name>
    </types>
    <types>
        <members>*</members>
        <name>HomePageLayout</name>
    </types>
    <types>
        <members>*</members>
        <name>Letterhead</name>
    </types>
    <types>
        <members>*</members>
        <name>Profile</name>
    </types>
    <types>
        <members>*</members>
        <name>Scontrol</name>
    </types>
    <types>
        <members>*</members>
        <name>StaticResource</name>
    </types>
    <version>13.0</version>
</package>
{% endhighlight %}

