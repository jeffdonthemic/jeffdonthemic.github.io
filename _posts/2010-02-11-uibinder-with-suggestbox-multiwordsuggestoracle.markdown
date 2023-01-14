---
layout: post
title:  UiBinder with SuggestBox & MultiWordSuggestOracle
description: Ive been working on a somewhat large and complex GWT  project using UiBinder  over the past couple of weeks. Ive built a number of widgets that use the SuggestBox and MultiWordSuggestOracle but I created a new UiBinder, populated the suggestions but they came up blank in the type-ahead. After about a half hour of scratching my head I looked back at some other code and figured it out. There are very few examples of the SuggestBox with UiBinder so I thought this might help someone out. The UiBinde
date: 2010-02-11 05:08:07 +0300
image:  '/images/slugs/uibinder-with-suggestbox-multiwordsuggestoracle.jpg'
tags:   ["code sample", "gwt"]
---
<p style="clear: both">I've been working on a somewhat large and complex <a href="http://code.google.com/webtoolkit" target="_blank">GWT</a> project using <a href="http://code.google.com/webtoolkit/doc/latest/DevGuideUiBinder.html" target="_blank">UiBinder</a> over the past couple of weeks. I've built a number of widgets that use the SuggestBox and MultiWordSuggestOracle but I created a new UiBinder, populated the suggestions but they came up blank in the type-ahead. After about a half hour of scratching my head I looked back at some other code and figured it out. There are very few examples of the SuggestBox with UiBinder so I thought this might help someone out.</p><p style="clear: both">The UiBinder template (MyWidget.ui.xml) is fairly simple:</p><p style="clear: both">
{% highlight js %}<!DOCTYPE ui:UiBinder SYSTEM "http://dl.google.com/gwt/DTD/xhtml.ent">
<ui:UiBinder xmlns:ui="urn:ui:com.google.gwt.uibinder"
  xmlns:g="urn:import:com.google.gwt.user.client.ui">
  <g:HTMLPanel>
  <g:SuggestBox ui:field="mySuggestBox"/>
  </g:HTMLPanel>
</ui:UiBinder>
{% endhighlight %}
</p><p style="clear: both">The owner class (MyWidget.java) is where you need to make sure you have things correct. On line #20 you need to ensure you have <strong>(provided = true)</strong> or your suggestions will not show in the type-ahead. You also need to create your SuggestBox before you initialize the UiBinder;</p><p style="clear: both">
{% highlight js %}package com.jeffdouglas;

import com.google.gwt.core.client.GWT;
import com.google.gwt.uibinder.client.UiBinder;
import com.google.gwt.uibinder.client.UiField;
import com.google.gwt.user.client.ui.Composite;
import com.google.gwt.user.client.ui.MultiWordSuggestOracle;
import com.google.gwt.user.client.ui.SuggestBox;
import com.google.gwt.user.client.ui.Widget;

public class MyWidget extends Composite {

 private static MyWidgetUiBinder uiBinder = GWT.create(MyWidgetUiBinder.class);

 interface MyWidgetUiBinder extends UiBinder<widget, MyWidget> {
 }

 private final MultiWordSuggestOracle mySuggestions = new MultiWordSuggestOracle();

 @UiField(provided = true) // MAKE SURE YOU HAVE THIS LINE
 SuggestBox mySuggestBox;

 public MyWidget() {
  mySuggestBox = new SuggestBox(mySuggestions);
  initWidget(uiBinder.createAndBindUi(this));
  getSuggestions();
 }

 private void getSuggestions() {
  // call some service to load the suggestions
  mySuggestions.add("Suggestion #1");
  mySuggestions.add("Suggestion #2");
  mySuggestions.add("Suggestion #3");
 }

}
{% endhighlight %}
</p><br class="final-break" style="clear: both" />
