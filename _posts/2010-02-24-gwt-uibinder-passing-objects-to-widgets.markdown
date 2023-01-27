---
layout: post
title:  GWT UiBinder – Passing Objects to Widgets
description:  A couple of weeks ago I wrote a GWT 2.0 tutorial for passing simple values to a widget and this is the (promised) follow up on how to pass an object to a widget. For more info on working with the new UiBinder, see Declarative Layout with UiBinder  at the GWT site. The Entry Point class is fairly simple; it creates a new MyPanel object and adds it to the RootPanel. MyEntryPoint.java  package com.jeffdouglas.client;  import com.google.gwt.core.client.EntryPoint; import com.google.gwt.user.client.
date: 2010-02-24 12:52:45 +0300
image:  '/images/slugs/gwt-uibinder-passing-objects-to-widgets.jpg'
tags:   ["code sample", "gwt"]
---
<p style="clear: both"><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399396/gwt-logo_otoxng.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399396/gwt-logo_otoxng.png" alt="" title="gwt-logo" width="100" height="100" class="alignleft size-full wp-image-1841" /></a>A couple of weeks ago I wrote a GWT 2.0 tutorial for <a href="/2010/02/05/gwt-uibinder-passing-parameters-to-widgets/" target="_blank">passing simple values to a widget</a> and this is the (promised) follow up on how to pass an object to a widget. For more info on working with the new UiBinder, see <a href="http://code.google.com/webtoolkit/doc/latest/DevGuideUiBinder.html" target="_blank">Declarative Layout with UiBinder</a> at the GWT site.</p><p style="clear: both">The Entry Point class is fairly simple; it creates a new MyPanel object and adds it to the RootPanel.</p><p style="clear: both"><strong>MyEntryPoint.java</strong></p><p style="clear: both">
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.ui.RootPanel;

public class MyEntryPoint implements EntryPoint {

 @Override
 public void onModuleLoad() {
  MyPanel p = new MyPanel();
  RootPanel.get().add(p);
 }

}
{% endhighlight %}
</p><p style="clear: both">In the constructor, the MyPanel owner class creates a new SomeObject object with some text and then initializes the widget. <strong><em>The @UiFactory annotation is how you provide arguments for the constructor of the SomeWidget widget.</em></strong> The UiBinder template simply sets up the name space and adds the widget to the HTMLPanel.</p><p style="clear: both"><strong>MyPanel.java</strong></p><p style="clear: both">
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiFactory;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.Widget;

public class MyPanel extends Composite {

 private static MyPanelUiBinder uiBinder = GWT.create(MyPanelUiBinder.class);

 interface MyPanelUiBinder extends UiBinder<widget, MyPanel> {
 }

 private SomeObject someObject;

 public MyPanel() {
  this.someObject = new SomeObject("My object text");
  initWidget(uiBinder.createAndBindUi(this));
 }

 // Add a UI Factory method for the sub-widget & pass object
 @UiFactory
 SomeWidget makeSomeWidget() {
  return new SomeWidget(someObject);
 }

}
{% endhighlight %}
</p><p style="clear: both"><strong>MyPanel.ui.xml</strong></p><p style="clear: both">
```html
<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
 xmlns:g="urn:import:com.google.gwt.user.client.ui"
 xmlns:c="urn:import:com.jeffdouglas.client">
 <g:HTMLPanel>
   <c:SomeWidget/>
 </g:HTMLPanel>
</ui:UiBinder>
```
</p><p style="clear: both">The SomeWidget class is pretty simple also. The constructor accepts SomeObject, sets it to the class member, initializes the widget and then sets the text of the displayText UiField to the name value in the SomeObject.</p><p style="clear: both"><strong>SomeWidget.java</strong></p><p style="clear: both">
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.Widget;

public class SomeWidget extends Composite {

 private static SomeWidgetUiBinder uiBinder = GWT
   .create(SomeWidgetUiBinder.class);

 interface SomeWidgetUiBinder extends UiBinder<widget, SomeWidget> {
 }

 private SomeObject someObject;

 @UiField Label displayText;

 public SomeWidget(SomeObject so) {
  this.someObject = so;
  initWidget(uiBinder.createAndBindUi(this));
  displayText.setText(someObject.getName());
 }

}
{% endhighlight %}
</p><p style="clear: both"><strong>SomeWidget.ui.xml</strong></p><p style="clear: both">
{% highlight js %}<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
  xmlns:g="urn:import:com.google.gwt.user.client.ui">
  <g:HTMLPanel>
  <g:Label ui:field="displayText"/>
  </g:HTMLPanel>
</ui:UiBinder>
{% endhighlight %}
</p><p style="clear: both"><strong>SomeObject.java</strong></p><p style="clear: both">
{% highlight js %}package com.jeffdouglas.client;

public class SomeObject {

 private String name;

 public SomeObject(String name) {
  this.name = name;
 }

 public String getName() {
  return name;
 }

 public void setName(String name) {
  this.name = name;
 }

}
{% endhighlight %}
</p><br class="final-break" style="clear: both" />
