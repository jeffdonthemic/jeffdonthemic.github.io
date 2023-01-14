---
layout: post
title:  GWT UiBinder Hello World Tutorial
description: Ive been working on a new project the past couple of weeks that (fortunately) requires Google Web Toolkit  (GWT) and I wanted to use the new UiBinder  that was released with GWT 2.0 in early December for a number of reasons (clean separation of UI and code, easier collaboration with designers, easier testing, etc ). However, I was having a hard time getting my head wrapped around it given that the GWT site has very little documentation and only a few examples. Ive combed through the message boar
date: 2010-01-19 23:26:03 +0300
image:  '/images/slugs/gwt-uibinder-hello-world-tutorial.jpg'
tags:   ["code sample", "google", "google app engine", "gwt"]
---
<p style="clear: both">I've been working on a new project the past couple of weeks that (fortunately) requires <a href="http://code.google.com/webtoolkit" title="GWT" target="_blank">Google Web Toolkit</a> (GWT) and I wanted to use the new <a href="http://code.google.com/webtoolkit/doc/latest/DevGuideUiBinder.html" title="UiBinder" target="_blank">UiBinder</a> that was released with GWT 2.0 in early December for a number of reasons (clean separation of UI and code, easier collaboration with designers, easier testing, etc ). However, I was having a hard time getting my head wrapped around it given that the GWT site has very little documentation and only a few examples. I've combed through the message boards, the docs and the sample Mail application that comes with the SDK and after finally groking the new functionality, I put together a little Hello World app, the kind that would have helped me out originally. </p> <p style="clear: both">So I'm making some assumptions that you already have the GWT SDK and Eclipse Plugin installed and are familiar with both of them. If you are not, take a look at the <a href="http://code.google.com/webtoolkit" target="_blank">GWT site</a> for more info.</p> <p style="clear: both">To get started, create a new Web Application Project called "HelloUiBinder" in the package of your choice but do not check "Use Google App Engine".</p> <p style="clear: both"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400928639/bb0sx4coyjc80vbzvmgx.png" height="575" align="left" width="509" style=" display: inline; float: left; margin: 0 10px 10px 0;" /><br style="clear: both" />Now create a new UiBinder template and owner class (File -> New -> UiBinder). Choose the client package for the project and then name it <em>MyBinderWidget</em>. Leave all of the other defaults. When you click Finish the plugin will create a new UiBinder template and owner class.</p> <p style="clear: both"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400928686/dofiy33uukthxfmtoee9.png" height="500" align="left" width="530" style=" display: inline; float: left; margin: 0 10px 10px 0;" /><br style="clear: both" />Open the <em>MyBinderWidget.ui.xml</em> template and add the following code. With GWT you can define your styles either in your template where you need them or externally. I've added a small style inline that adds some pizzaz to the label. Notice the field name <em>myPanelContent</em> in the template. You can programmatically read and write to this field from the template's owner class. So when the owner class runs, it construct a new VerticalPanel, does something with it (probably add some type of content) and then fill this field with it.</p> <p style="clear: both">Attributes for the elements (the text attribute in the Label element for example) correspond to a setter method for the widget. Unfortunately there is no code completion to get a list of these attributes in Eclipse when you hit the space bar so you either have to know the setters or refer to the JavaDocs each time. A painful process.</p> 
{% highlight js %}<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
 xmlns:g="urn:import:com.google.gwt.user.client.ui">
 <ui:style>
   .bolder { font-weight:bold; }
 </ui:style>
 <g:HTMLPanel>
   <g:Label styleName="{style.bolder}" text="This is my label in bold!"/>
   <g:VerticalPanel ui:field="myPanelContent" spacing="5"/>
 </g:HTMLPanel>
</ui:UiBinder>
{% endhighlight %}
<p>For the owner class, <em>MyBinderWidget.java</em>, add the following code. In this class, a field with the same name, <em>myPanelContent</em>, is marked with the @UiField annotation. When uiBinder.createAndBindUi(this) is run, the content is created for the VerticalPanel and the template field is filled with the new instance.</p>
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.Widget;

public class MyBinderWidget extends Composite {

 private static MyBinderWidgetUiBinder uiBinder = GWT
    .create(MyBinderWidgetUiBinder.class);

 interface MyBinderWidgetUiBinder extends UiBinder<widget, MyBinderWidget> { }

 @UiField VerticalPanel myPanelContent;

 public MyBinderWidget() {
   initWidget(uiBinder.createAndBindUi(this));

   HTML html1 = new HTML();
   html1.setHTML("<a href='http://www.google.com'>Click me!</a>");
   myPanelContent.add(html1);
   HTML html2 = new HTML();
   html2.setHTML("This is my sample <b>content</b>!");
   myPanelContent.add(html2);

 }

}
{% endhighlight %}
<p>Now change the entry point class to look like the following.</p>
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.ui.RootPanel;

public class HelloUiBinder implements EntryPoint {

 public void onModuleLoad() {
   MyBinderWidget w = new MyBinderWidget();
   RootPanel.get().add(w);
 }
}
{% endhighlight %}
<p style="clear: both">Now open <em>HelloUiBinder.html</em> and remove all of the HTML content between the </noscript> and and </body> save it. Once you run the application, copy the development URL and run paste it into your favorite supported browser, you should see the following.</p> <p style="clear: both"><img class="linked-to-original" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400928714/gri2uwnnrs1bduskf5zi.png" height="117" align="left" width="265" style=" display: inline; float: left; margin: 0 10px 10px 0;" /><br style="clear: both" />Now suppose you wanted to nest a widget inside your MyBinderWidget that did something when a button was clicked. We'll create a small series of checkboxes that allows the user to select their favorite colors and display them when the button is clicked. Create a new UiBinder called <em>FavoriteColorWidget</em> in the client package. Add the following code to the <em>FavoriteColorWidget.ui.xml</em> template.</p> 
{% highlight js %}<ui:UiBinder xmlns:ui='urn:ui:com.google.gwt.uibinder'
  xmlns:g='urn:import:com.google.gwt.user.client.ui'>
  <g:VerticalPanel>
 <g:Label ui:field="greeting"/>
 <g:Label>Choose your favorite color(s):</g:Label>
 <g:CheckBox ui:field="red" formValue="red">Red</g:CheckBox>
 <g:CheckBox ui:field="white" formValue="white">White</g:CheckBox>
 <g:CheckBox ui:field="blue" formValue="blue">Blue</g:CheckBox>
 <g:Button ui:field="button">Submit</g:Button>
  </g:VerticalPanel>
</ui:UiBinder>
{% endhighlight %}
<p style="clear: both">Now add the click handler in the <em>FavoriteColorWidget.java</em> owner class.</p> 
{% highlight js %}package com.jeffdouglas.client;

import java.util.ArrayList;
import com.google.gwt.core.client.GWT;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.CheckBox;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.Widget;

public class FavoriteColorWidget extends Composite {

 private static FavoriteColorWidgetUiBinder uiBinder = GWT
    .create(FavoriteColorWidgetUiBinder.class);

 interface FavoriteColorWidgetUiBinder extends
    UiBinder<widget, FavoriteColorWidget> {
 }

 @UiField Label greeting;
 @UiField CheckBox red;
 @UiField CheckBox white;
 @UiField CheckBox blue;
 @UiField Button button;

 public FavoriteColorWidget() {
   initWidget(uiBinder.createAndBindUi(this));

   // add a greeting
   greeting.setText("Hello Jeff!!");

   final ArrayList<checkBox> checkboxes = new ArrayList<checkBox>();
   checkboxes.add(red);
   checkboxes.add(white);
   checkboxes.add(blue);

   // add a button handler to show the color when clicked
   button.addClickHandler(new ClickHandler() {
    public void onClick(ClickEvent event) {
    String t = "";
    for(CheckBox box : checkboxes) {
     // if the box was checked
     if (box.getValue()) {
     t += box.getFormValue() + ", ";
     }
    }
    Window.alert("Your favorite color/colors are: "+ t);
    }
   });

 }

}
{% endhighlight %}
<p style="clear: both">The last thing we'll need to do is add our new widget to the MyBinderWidget template. Open <em>MyBinderWidget.ui.xml</em> and add the custom namespace reference and the FavoriteColorWidget.</p> 
{% highlight js %}<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">;
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
 xmlns:g="urn:import:com.google.gwt.user.client.ui"
 xmlns:c="urn:import:com.jeffdouglas.client">
 <ui:style>
   .bolder { font-weight:bold; }
 </ui:style>
 <g:HTMLPanel>
   <g:Label styleName="{style.bolder}" text="This is my label in bold!"/>
   <g:VerticalPanel ui:field="myPanelContent" spacing="5"/>
   <c:FavoriteColorWidget/>
 </g:HTMLPanel>
</ui:UiBinder>
{% endhighlight %}
<p><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400928746/mrsb6ccocjrbajfhy4mg.png" alt="" ></p>

