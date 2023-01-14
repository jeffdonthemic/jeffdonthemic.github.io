---
layout: post
title:  Displaying the Required Red Bar for a Control
description: My Visualforce page uses a number of outputLabels and selectLists to create the functionality below. Setting the selectLists required attribute makes the selects value required but does not, by design  , display the red bar next to the label. This is perfect is it does not lock developers into Salesforce.coms look and feel. However, to actually display the required red bar, you have to add some extra code.                                                  
date: 2008-11-16 19:07:30 +0300
image:  '/images/slugs/displaying-the-required-red-bar-for-a-control.jpg'
tags:   ["code sample", "salesforce", "visualforce"]
---
<p>My Visualforce page uses a number of outputLabels and selectLists to create the functionality below. Setting the selectList's required attribute makes the select's value required but does not, <a href="http://community.salesforce.com/sforce/board/message?board.id=Visualforce&message.id=1322">by design</a>, display the red bar next to the label. This is perfect is it does not lock developers into Salesforce.com's look and feel. However, to actually display the required red bar, you have to add some extra code.</p>
<p><img src="images/red-bar_fxu0ng.png" alt="" ></p>
{% highlight js %}<apex:pageBlockSectionItem >
    <apex:outputLabel value="Category 1" for="cbxlevel1"/>
    <apex:outputPanel styleClass="requiredInput" layout="block">
    <apex:outputPanel styleClass="requiredBlock" layout="block"/>
    <apex:selectList value="{!selectedLevel1}" id="cbxlevel1" size="1" required="true">
        <apex:selectOptions value="{!level1items}"/>
        <apex:actionSupport event="onchange" rerender="cbxlevel2"/>
    </apex:selectList>
    </apex:outputPanel>
</apex:pageBlockSectionItem>
{% endhighlight %}

