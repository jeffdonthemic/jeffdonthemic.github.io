---
layout: post
title:  Fun with PHP, MySQL and Drupal
description: I ran into a few more issues getting Drupal up and running and I thought I would share my solutions in case anyone is running into the same problems. I finally got PHP running on one of our Production IIS boxes but was having some more issues getting Drupal to install. Going to the initial install page, I was receiving the following error-  Your web server does not appear to support any common database types. Check with your hosting provider to see if they offer any databases that Drupal support
date: 2007-09-16 11:51:05 +0300
image:  '/images/slugs/fun-with-php-mysql-and-drupal.jpg'
tags:   ["technology"]
---
<p>I ran into a few more issues getting Drupal up and running and I thought I would share my solutions in case anyone is running into the same problems.</p>
<p>I finally got PHP running on one of our Production IIS boxes but was having some more issues getting Drupal to install. Going to the initial install page, I was receiving the following error:</p>
<p><code>"Your web server does not appear to support any common database types. Check with your hosting provider to see if they offer any databases that Drupal supports."</code></p>
<p>I had added the correct extensions for PHP but phpinfo() was still not showing that MySQL was enabled. I found <a href="http://www.peterguy.com/php/install_IIS6.html" target="_blank">How to install PHP 5.x on Windows Server 2003 with IIS 6</a> and the very last item on the page gave me an idea as it related to the libmysql.dll.</p>
<p>On previous installs of PHP, you stuck some files in the WindowsSystem32 directory to get PHP to work. With PHP 5.2, all of the files are in the PHP directory and you add an entry to the PATH variable to point to this directory so Windows can find all of the files at runtime. Well, apparently I had an old version of libmysql.dll in my WindowsSystem32 directory that was conflicting. Once I removed that file and restarted IIS, PHP reported that MySQL was correctly installed!</p>

