---
layout: post
title:  GWT UiBinder – Passing Parameters to Widgets
description:  I received a number of emails regarding my last post, GWT UiBinder Hello World Tutorial , specifically how to pass values into widgets using the new GWT 2.0 UiBinder . Heres a small tutorial on one of the ways in which you could do that. I plan on another tutorial on passing multiple objects using the @UiFactory method. So here is the Entry Point class. When the module loads, it creates a new MyPanel object, passes the text Random Text to the constructor and then adds the panel to the RootPanel
date: 2010-02-05 15:02:38 +0300
image:  '/images/slugs/gwt-uibinder-passing-parameters-to-widgets.jpg'
tags:   ["2010", "public"]
---
<p style="clear: both"><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399396/gwt-logo_otoxng.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399396/gwt-logo_otoxng.png" alt="" title="gwt-logo" width="100" height="100" class="alignleft size-full wp-image-1841" /></a>I received a number of emails regarding my last post, <a href="/2010/01/19/gwt-uibinder-hello-world-tutorial/" target="_blank">GWT UiBinder Hello World Tutorial</a>, specifically how to pass values into widgets using the new <a href="http://code.google.com/webtoolkit/doc/latest/DevGuideUiBinder.html" target="_blank">GWT 2.0 UiBinder</a>. Here's a small tutorial on one of the ways in which you could do that. I plan on another tutorial on passing multiple objects using the @UiFactory method.</p><p style="clear: both">So here is the Entry Point class. When the module loads, it creates a new MyPanel object, passes the text "Random Text" to the constructor and then adds the panel to the RootPanel.</p>
<p><strong>MyEntryPoint.java</strong></p>
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.ui.RootPanel;

public class MyEntryPoint implements EntryPoint {

	public void onModuleLoad() {
		MyPanel p = new MyPanel("Random Text");
		RootPanel.get().add(p);
	}

}
{% endhighlight %}
</p><p style="clear: both">The MyPanel owner class defines a new constructor that accepts the passed string value (i.e. "Random Text") and sets the value of hidden field called <em>myField</em> in the UiBinder template to this text.</p>
<p><strong>MyPanel.java</strong></p>
{% highlight js %}package com.jeffdouglas.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.Hidden;
import com.google.gwt.user.client.ui.Widget;

public class MyPanel extends Composite {

	private static MyPanelUiBinder uiBinder = GWT.create(MyPanelUiBinder.class);

	interface MyPanelUiBinder extends UiBinder<widget, MyPanel> {
	}

	@UiField(provided=true)
	Hidden myField;

	public MyPanel(String someText) {
		Hidden myField = new Hidden();
		myField.setValue(someText);
		initWidget(uiBinder.createAndBindUi(this));
	}

}
{% endhighlight %}
<p style="clear: both">When the UiBinder template runs, its owner class loads the value ("Random Text") into the Hidden field which then passes this same value into the SomeWidget widget.</p>
<p><strong>MyPanel.ui.xml</strong></p>
{% highlight js %}<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
	xmlns:g="urn:import:com.google.gwt.user.client.ui"
	xmlns:c="urn:import:com.jeffdouglas.client">
	<g:HTMLPanel>
	  <g:Hidden ui:field="myField"/>
	  <c:SomeWidget myField="{myField.getValue}"/>
	</g:HTMLPanel>
</ui:UiBinder>
{% endhighlight %}
<p style="clear: both">The SomeWidget owner class is fairly straight forward. There is a setter method for MyField which runs after the constructor, receives the text ("Random Text") and writes it to the <em>displayText</em> field in the UiBinder template.</p>
<p><strong>SomeWidget.java</strong></p>
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

	@UiField Label displayText;

	public void setMyField(String t) {
		displayText.setText(t);
	}

	public SomeWidget() {
		initWidget(uiBinder.createAndBindUi(this));
	}

}
{% endhighlight %}
<p>The UiBinder template simply displays the text in an HTMLPanel.</p>
<p><strong>SomeWidget.ui.xml</strong></p>
{% highlight js %}<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
	xmlns:g="urn:import:com.google.gwt.user.client.ui">
	<g:HTMLPanel>
	  <g:Label ui:field="displayText"/>
	</g:HTMLPanel>
</ui:UiBinder>
{% endhighlight %}

