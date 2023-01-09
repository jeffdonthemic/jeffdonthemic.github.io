---
layout: post
title:  Flex Salesforce.com Tree Control
description: One of the things that Salesforce.com is lacking is a descent tree control to display hierarchical data. I did notice a screenshot on the Winter 09 Developer Screencast of a tree control but according to our Salesforce.com technical reps there are no plans to release this. There is a really good Flex tutorial on developer.force.com concerning this topic, but one of their main takeways is-  > NOTE- You should be very careful when using nested queries as you can easily run into governer limits. We
date: 2008-12-08 20:51:10 +0300
image:  '/images/slugs/flex-salesforcecom-tree-control.jpg'
tags:   ["2008", "public"]
---
<p>One of the things that Salesforce.com is lacking is a descent tree control to display hierarchical data. I did notice a screenshot on the Winter '09 Developer Screencast of a tree control but according to our Salesforce.com technical reps there are no plans to release this.</p>
<p>There is a really <a href="http://wiki.apexdevnet.com/index.php/Using_Browser_Technologies_in_Visualforce_-_Part_3" target="_blank">good Flex tutorial</a> on developer.force.com concerning this topic, but one of their main takeways is:</p>
<blockquote><em>NOTE: You should be very careful when using nested queries as you can easily run into governer limits. </em></blockquote>
We have a large hierarchy with thousands of nodes, so governor limits is certainly a consideration. Therefore, I decided to create a tree that loads the first two levels of the hierarchy and then lazily loads the subsequent level childen when they are clicked on.
<p><strong>You can </strong><a href="http://jeffdouglas-developer-edition.na5.force.com/examples/Tree1" target="_blank"><strong>run this demo</strong></a><strong> on my Developer Site. </strong>You might also want to <a href="/2008/11/12/developing-salesforcecom-applications-with-flex-and-visualforce/">check out this post</a> on the basics of connecting Flex to Salesforce.com.<strong><br>
</strong></p>
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399684/ishot-2_qvxhgt.png" alt="" ></p>
<p>There is a really <a href="http://www.adobe.com/devnet/flex/quickstart/working_with_tree/" target="_blank">good tutorial</a> on Adobe's site that has alot of great information regarding XML and trees if you are interested. I have some plan to add drag and drop capability in the near future.</p>
{% highlight js %}<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"
    backgroundGradientAlphas="[1.0, 1.0]"
    backgroundGradientColors="[#F3F3EC, #F3F3EC]"
    creationComplete="login()"
    layout="horizontal"  
    height="300" width="500">

    <mx:Script>
    <![CDATA[
        import com.salesforce.*;
        import com.salesforce.objects.*;
        import com.salesforce.results.*;
        import mx.collections.ArrayCollection;
        import mx.controls.Alert;
        import mx.collections.XMLListCollection;
        import mx.events.ListEvent;

        [Bindable] private var categoriesXml:XML =
	<list>
              <root>
                <level0 name="Categories" level="0"/>
              </root>                       
          </list>;               

        [Bindable] public var sfdc:Connection = new Connection();
        [Bindable] private var acClicked:ArrayCollection = new ArrayCollection();
        [Bindable] private var categoriesXmlData:XMLListCollection = new XMLListCollection(categoriesXml.root);       

        private function login():void {

            var lr:LoginRequest = new LoginRequest();
            lr.server_url = this.parameters.server_url; 
            lr.session_id = this.parameters.session_id;    
            lr.callback = new AsyncResponder(loginSuccess, loginFault);
            sfdc.login(lr);      

        }               

        // gets all level 1
        private function getLevel1():void
        {

            sfdc.query("Select c.Name, c.Id From Cat1__c c Order by c.Name",
                 new AsyncResponder(
                    function (qr:QueryResult):void {
                        var parent:XMLList = categoriesXml.root.level0.(@name == 'Categories');
                        if (qr.size > 0) {
                            for (var j:int=0;j<qr.size;j++) {
                                var newNode:XML = <level1 level="1"/>;
                                newNode.@id = qr.records[j].Id;
                                newNode.@name = qr.records[j].Name;
                                parent[0].appendChild(newNode);
                                getLevel2(newNode.@id);
                            }
                        }
                    },sfdcFailure
                )
            );  

        }     

        // gets all level 2 nodes for the selected parent
        private function getLevel2(parentId:String):void
        {

            sfdc.query("Select c.Id, c.Name From Cat2__c c Where c.Cat1__c = '"+parentId+"' Order By c.Name",
                 new AsyncResponder(
                    function (qr:QueryResult):void {
                        var parent:XMLList = categoriesXml.root.level0.level1.(@id == parentId);
                        if (qr.size > 0) {
                            for (var j:int=0;j<qr.size;j++) {
                                var newNode:XML = <level2 level="2"/>;
                                newNode.@id = qr.records[j].Id;
                                newNode.@name = qr.records[j].Name;
                                parent[0].appendChild(newNode);
                            }
                        }
                    },sfdcFailure
                )
            );  

        }         

        // gets all level 3 nodes for the selected parent
        private function getLevel3(parentId:String):void
        {

            sfdc.query("Select c.Id, c.Name From Cat3__c c Where Cat2__c = '"+parentId+"' Order By c.Name",
                 new AsyncResponder(
                    function (qr:QueryResult):void {
                        var parent:XMLList = categoriesXml.root.level0.level1.level2.(@id == parentId);
                        if (qr.size > 0) {
                            for (var j:int=0;j<qr.size;j++) {
                                var newNode:XML = <level3 level="3"/>;
                                newNode.@id = qr.records[j].Id;
                                newNode.@name = qr.records[j].Name;
                                parent[0].appendChild(newNode);
                            }
                        }
                    },sfdcFailure
                )
            );  

        }                               

        // queries sfdc when node is clicked
        private function tree_itemClick(evt:ListEvent):void {

            var item:Object = Tree(evt.currentTarget).selectedItem;
            var node:XML = XML(item);
            var nodeName:String = node.@name;

            if (!acClicked.contains(nodeName)) {

                   // fetch the children
                getLevel3(node.@id);

                // add the node to the list of nodes clicked          
                acClicked.addItem(nodeName);

            }

        } 

        private function loginSuccess(result:Object):void {
            getLevel1();
        }                               

        private function sfdcFailure(fault:Object):void {
            Alert.show(fault.faultstring);
        }  

        private function loginFault(fault:Object):void
        {
            Alert.show("Could not log into SFDC: "+fault.fault.faultString,"Login Error");
        }          

    ]]>
    </mx:Script>

    <mx:Tree id="tree"
        dataProvider="{categoriesXmlData}"
        itemClick="tree_itemClick(event)"
        labelField="@name"
        showRoot="false"
        width="100%" height="100%" left="0" top="0"/>

</mx:Application>
{% endhighlight %}

