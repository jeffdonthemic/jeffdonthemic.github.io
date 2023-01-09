---
layout: post
title:  Installing & Running the Force Metadata JDBC Driver for SchemaSpy
description: The Force Metadata JDBC Driver for SchemaSpy is a really cool tool available at  Force.com Code Share that generates ER diagrams for your Salesforce org. Some people have emailed me asking for help installing and running the tool so here are some instructions that supplement what is listed on the projects wiki page . Make sure you download the following files from the Downloads tab - * force-metadata-jdbc-driver-1.4.jar  * generated-sforce-partner-18.jar  * force.properties  * depends.zip  Youll
date: 2010-05-12 15:41:01 +0300
image:  '/images/slugs/running-the-force-metadata-jdbc-driver-for-schemaspy.jpg'
tags:   ["2010", "public"]
---
<p>The Force Metadata JDBC Driver for SchemaSpy is a really cool tool available at <a href="http://developer.force.com/codeshare/apex/projectpage?id=a0630000006KXemAAG" target="_blank">Force.com Code Share</a> that generates ER diagrams for your Salesforce org. Some people have emailed me asking for help installing and running the tool so here are some instructions that supplement what is listed on the <a href="http://code.google.com/p/force-metadata-jdbc-driver/wiki/Useage" target="_blank">project's wiki page</a>. <div>Make sure you download the following files from the <a href="http://code.google.com/p/force-metadata-jdbc-driver/downloads/list" target="_blank">Downloads tab</a>:</div><p style="clear: both"><ul style="clear: both"><li>force-metadata-jdbc-driver-1.4.jar</li><li>generated-sforce-partner-18.jar</li><li>force.properties</li><li>depends.zip</li></ul></p><p style="clear: both">You'll also need to download the schemaSpy_4.1.1.jar file from the <a href="http://sourceforge.net/projects/schemaspy/files/" target="_blank">SchemaSpy files page</a> and install <a href="http://www.graphviz.org/" target="_blank">Graphviz</a> so it can generate the graphs. There is both a Mac and PC version. </p><p style="clear: both">The Partner web service is pointing to www.salesforce.com. If you want to generate your ER diagrams against a Sandbox org, you'll have to make some modifications as outlined on the <a href="http://code.google.com/p/force-metadata-jdbc-driver/wiki/Useage" target="_blank">wiki page</a>. </p><p style="clear: both">I created a folder on my desktop call "run-schemaspy" and dropped all of my files in there. Your folder should look similar to:</p><p style="clear: both"><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/schemaspy1.png" class="image-link" rel="lightbox"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030300/g5hkw0l7hrrsrgj5ktzq.png" height="400" align="left" width="543" style=" display: inline; float: left; margin: 0 10px 10px 0;" /></a><br style="clear: both" /><br />I also created a build file which I dropped in that same directory. Make sure you add your Salesforce username and password/token.</p><p style="clear: both"></p>
{% highlight js %}<project default="document">
 
 <property name="sf.username" value="SALESFORCE_USERNAME"/>
 <property name="sf.password" value="SALESFORCE_PASSWORD_AND_SECURITY_TOKEN"/>

 <target name="document">
 <echo message="Generating SchemaSpy documentation (requires Graphviz to be installed to produce diagrams)"/>
 <delete dir="doc" failonerror="false"/>
 <java classname="net.sourceforge.schemaspy.Main" fork="true" failonerror="true">
   <arg line="-t schemaspy/force"/>
   <arg line="-db Claims"/>
   <arg line="-un ${sf.username}"/>
   <arg line="-pw ${sf.password}"/>
   <arg line="-o doc"/>
   <arg line="-font Arial"/>
   <arg line="-fontsize 8"/>
   <arg line="-hq"/>
   <arg line="-norows"/>
   <arg line='-desc "Extracted from ClaimVantage Claims r${env.SVN_REVISION} on Force.com"'/>
   <arg line="-u fake"/>
   <arg line="-p fake"/>
   <arg line="-host fake"/>
   <classpath>
    <fileset dir="schemaspy" includes="*.jar"/>
   </classpath>
 </java>
 </target>

</project>
{% endhighlight %}
</p><p style="clear: both">You should then be able to open up a terminal, navigate to the directory on your desktop and run ant using the build file (assuming ant is installed correctly). Your terminal should look like the screenshot below. The script will create a doc directory and generate the ER diagrams in this directory. Simply open index.html file in the doc directory and you are golden!</p><p style="clear: both"><a href="http://old.jeffdouglas.com/wp-content/uploads/2010/05/schemaspy2.png" class="image-link" rel="lightbox"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401030424/nsw7sm0iamz8tp7oes52.png" height="450" align="left" width="523" style=" display: inline; float: left; margin: 0 10px 10px 0;" /></a></p><br class="final-break" style="clear: both" />
