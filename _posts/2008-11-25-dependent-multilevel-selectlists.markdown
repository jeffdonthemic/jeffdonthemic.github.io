---
layout: post
title:  Dependent Multilevel Selectlists
description: Ive had a number of follow-up emails regarding the code I used for my  Displaying the Required Red Bar for a Control post. We assign a number of values to an Opportunity based upon a hierarchy modeled by 3 objects (you could also use just one object with a level indicator). Visualforce Page-                                                                                                                                                                                                                
date: 2008-11-25 19:28:43 +0300
image:  '/images/slugs/dependent-multilevel-selectlists.jpg'
tags:   ["2008", "public"]
---
<p>I've had a number of follow-up emails regarding the code I used for my <a href="/2008/11/16/displaying-the-required-red-bar-for-a-control/" target="_blank">Displaying the Required Red Bar for a Control</a> post. We assign a number of values to an Opportunity based upon a hierarchy modeled by 3 objects (you could also use just one object with a level indicator).</p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399704/red-bar_fxu0ng.png" alt="" ></p>
<p>Visualforce Page:</p>
{% highlight js %}<apex:page standardController="Opportunity" extensions="MultiSelectController">
     <apex:sectionHeader title="Opportunity" subtitle="{!opportunity.name}"/>
     <apex:form >
     <apex:pageBlock title="Opportunity" mode="edit">

         <apex:outputText value="{!opportunity.Cat1__c}" rendered="false"/>
         <apex:outputText value="{!opportunity.Cat2__c}" rendered="false"/>
         <apex:outputText value="{!opportunity.Cat3__c}" rendered="false"/>

          <apex:pageBlockButtons location="both">
               <apex:commandButton value="Save" action="{!save}" />
               <apex:commandButton value="Cancel" action="{!cancel}" />
          </apex:pageBlockButtons>
          <apex:pageMessages />       

          <apex:pageBlockSection title="Master Categories" columns="1">

                <apex:pageBlockSectionItem >
                    <apex:outputLabel value="Category 1" for="cbxlevel1"/>
                    <apex:outputPanel styleClass="requiredInput" layout="block">
                    <apex:outputPanel styleClass="requiredBlock" layout="block"/>
                    <apex:selectList value="{!selectedLevel1}" id="cbxlevel1" size="1" required="true">
                        <apex:selectOptions value="{!level1items}"/>
                        <apex:actionSupport event="onchange" rerender="cbxlevel2"/>
                    </apex:selectList>
                    </apex:outputPanel>
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem >
                    <apex:outputLabel value="Category 2" for="cbxlevel2"/>
                    <apex:selectList value="{!selectedLevel2}" id="cbxlevel2" size="1">
                        <apex:selectOptions value="{!level2items}"/>
                        <apex:actionSupport event="onchange" rerender="cbxlevel3"/>
                    </apex:selectList>
                </apex:pageBlockSectionItem>

                <apex:pageBlockSectionItem >
                    <apex:outputLabel value="Category 3" for="cbxlevel3"/>
                    <apex:selectList value="{!selectedLevel3}" id="cbxlevel3" size="1">
                        <apex:selectOptions value="{!level3items}"/>
                    </apex:selectList>
                </apex:pageBlockSectionItem>

          </apex:pageBlockSection>

     </apex:pageBlock>
     </apex:form>   

</apex:page>
{% endhighlight %}
<p>Controller Extension:</p>
{% highlight js %}public class MultiSelectController {

    // reference for the standard controller
    private ApexPages.StandardController controller {get; set;}

    // the record that is being edited
    private Opportunity opp;

    // the values of the selected items
    public string selectedLevel1 {get; set;}
    public string selectedLevel2 {get; set;}
    public string selectedLevel3 {get; set;}

    public List<selectOption> level1Items {
        get {
            List<selectOption> options = new List<selectOption>();

                options.add(new SelectOption('','-- Choose a Category --'));
                for (Cat1__c cat : [select Id, Name from Cat1__c Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));

            return options;           
        }
        set;
    }

    public List<selectOption> level2Items {
        get {
            List<selectOption> options = new List<selectOption>();

            if (selectedLevel1 != NULL) {
                options.add(new SelectOption('','-- Choose a Category --'));
                for (Cat2__c cat : [select Id, Name from Cat2__c Where Cat1__c = :selectedLevel1 Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));
            }

            return options;           
        }
        set;
    }   

    public List<selectOption> level3Items {
        get {
            List<selectOption> options = new List<selectOption>();

            if (selectedLevel2 != NULL) {
                options.add(new SelectOption('','-- Choose a Category --'));
                for (Cat3__c cat : [select Id, Name from Cat3__c Where Cat2__c = :selectedLevel2 Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));
            }

            return options;           
        }
        set;
    }       

    public MultiSelectController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the record
        this.opp = (Opportunity)controller.getRecord();

        // preselect the current values for the record
        selectedLevel1 = opp.Cat1__c;
        selectedLevel2 = opp.Cat2__c;
        selectedLevel3 = opp.Cat3__c; 

    }          

    public PageReference save() {

        // set the selected values to the record before saving
        opp.Cat1__c = selectedLevel1;
        opp.Cat2__c = selectedLevel2;
        opp.Cat3__c = selectedLevel3;

        try {
            upsert(opp);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return (new ApexPages.StandardController(opp)).view();
    }        

}
{% endhighlight %}

