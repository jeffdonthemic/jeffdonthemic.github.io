---
layout: post
title:  Parsing a Date as a String in Flex
description: The DateField object in ActionScript has a static method called which-  Parses a String object that contains a date, and returns a Date object corresponding to the String. The inputFormat argument contains the pattern in which the valueString String is formatted. It can contain M,D,Y, and delimiter and punctuation characters. The function does not check for the validity of the Date object. If the value of the date, month, or year is NaN, this method returns null. DateField.stringToDate(the_date_
date: 2007-03-16 08:09:33 +0300
image:  '/images/slugs/parsing-a-date-as-a-string-in-flex.jpg'
tags:   ["2007", "public"]
---
<p>The DateField object in ActionScript has a static method called which:</p>
<p>"Parses a String object that contains a date, and returns a Date object corresponding to the String. The inputFormat argument contains the pattern in which the valueString String is formatted. It can contain "M","D","Y", and delimiter and punctuation characters. The function does not check for the validity of the Date object. If the value of the date, month, or year is NaN, this method returns null."</p>
{% highlight js %}DateField.stringToDate(the_date_field.text, "MM/DD/YYYY")
{% endhighlight %}

