---
layout: post
title:  Ruby 1.9.2 Install Errors with Mac OS X Lion and RVM
description: I got my shiny new MBP on Friday and spent a good part of the weekend installing software. I ran into a installation issue with RVM and Ruby and just want to post a fix in case anyone runs across it. Just to be clear, the issue seems to be with Lion and not Ruby in general. I successfully installed RVM (Ruby Version Manager) but received a nasty error when installing Ruby 1.9.2. My error log looked like- ./configure --prefix=/Users/Jeff/.rvm/usr checking for a BSD-compatible install... /usr/bin/
date: 2011-08-01 12:21:23 +0300
image:  '/images/slugs/ruby-1-9-2-install-errors-with-mac-os-x-lion-and-rvm.jpg'
tags:   ["2011", "public"]
---
<p>I got my shiny new MBP on Friday and spent a good part of the weekend installing software. I ran into a installation issue with RVM and Ruby and just want to post a fix in case anyone runs across it. Just to be clear, the issue seems to be with Lion and not Ruby in general.</p>
<p>I successfully installed <a href="https://rvm.beginrescueend.com/">RVM</a> (Ruby Version Manager) but received a nasty error when installing Ruby 1.9.2. My error log looked like:</p>
<p>[2011-07-30 16:52:07] ./configure --prefix="/Users/Jeff/.rvm/usr"<br>
checking for a BSD-compatible install... /usr/bin/install -c<br>
checking whether build environment is sane... yes<br>
checking for a thread-safe mkdir -p... config/install-sh -c -d<br>
checking for gawk... no<br>
checking for mawk... no<br>
checking for nawk... no<br>
checking for awk... awk<br>
checking whether make sets $(MAKE)... no<br>
checking for gcc... /usr/bin/gcc-4.2<br>
checking whether the C compiler works... no<br>
configure: error: in <code>/Users/Jeff/.rvm/src/yaml-0.1.4': configure: error: C compiler cannot create executables See </code>config.log' for more details</p>
<p>Essentially it means that "no acceptable compiler could be found." There are a couple of problems with OS X Lion and Ruby. First, if you read the installation notes for RVM you'll see the following:</p>
<blockquote>For Lion, Rubies should be built using gcc rather than llvm-gcc. Since /usr/bin/gcc is now linked to /usr/bin/llvm-gcc-4.2, add the following to your shell's start-up file: export CC=gcc-4.2</blockquote>
Lion sets the default compiler to LLVM so you'll need to change it to gcc for Ruby to compile sucessfully. Open .bash_profile and add:
<p><strong>export CC=/usr/bin/gcc-4.2</strong></p>
<p>The second problem seems to be with Xcode. Just becuase I "installed" Xcode 4.1 from the App Store doesn't mean that it actually installed. To get Ruby to compile I had to launch Xcode and actually install Xcode. After that it compiled with no problem.</p>

