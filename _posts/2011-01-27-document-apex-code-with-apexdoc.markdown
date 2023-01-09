---
layout: post
title:  Document Apex Code with ApexDoc
description: My fellow Appirian and resident super-smart guy, Aslam Bari has created a super slick tool to document Apex code. ApexDoc is essentially JavaDocs for Apex. You add comments to your source code in the JavaDoc fashion (@author, @date, @param, etc) and ApexDoc reads these and generates a nice set of HTML files that allows you to browse your class structure. Heres a short video on the entire process. Generating the ApexDocs is fairly simple. Just point to your source code, an option output file, an 
date: 2011-01-27 15:04:46 +0300
image:  '/images/slugs/document-apex-code-with-apexdoc.jpg'
tags:   ["2011", "public"]
---
<p><img style="float: left;padding-right:15px;padding-bottom:10px" title="apex_doc_logo.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027982/qp8oo9em7wevycjzd8aq.png" border="0" alt="apex_doc_logo.png" width="147" height="80" /></p>
<p>My fellow Appirian and resident super-smart guy, <a href="http://techsahre.blogspot.com/" target="_blank">Aslam Bari</a> has created a super slick tool to document Apex code. ApexDoc is essentially JavaDocs for Apex. You add comments to your source code in the JavaDoc fashion (@author, @date, @param, etc) and ApexDoc reads these and generates a nice set of HTML files that allows you to browse your class structure. <a href="http://www.aslambari.com/apexdoc.html" target="_blank">Here's a short video</a> on the entire process.</p>
<p>Generating the ApexDocs is fairly simple. Just point to your source code, an option output file, an optional file containing the HMTL for the right Home frame (project name, description, etc) and an optional file containing author information. Sample command syntax is:</p>
<p><em>apexdoc <source_directory> [<target_directory?>] [<homefile>] [<authorfile>]</em></p>
<p><a href="http://techsahre.blogspot.com/2011/01/apexdoc-salesforce-code-documentation.html" target="_blank">Download ApexDoc here</a> along with more detailed info and feedback. </p>
<p><img title="apexdoc-screenshot.png" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1401027987/kb8x2bl0joc0irly4mr0.png" border="0" alt="apexdoc-screenshot.png" width="550" height="380" /></p>
<p><strong>Update</strong>: Aslam and I worked on a bug affecting Mac and Unix users. <a href="http://www.aslambari.com/apexdoc.html" target="_blank">Download the latest version</a> of the files to get the fix. Also, here are some screenshots that may help out Mac users.</p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327866/apexdoc-filesystem_pipasj.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327866/apexdoc-filesystem_pipasj.png" alt="" title="apexdoc-filesystem" width="500" class="alignnone size-full wp-image-3594" /></a></p>
<p><a href="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327852/apexdoc-terminal_utjacd.png"><img src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400327852/apexdoc-terminal_utjacd.png" alt="" title="apexdoc-terminal" width="500" class="alignnone size-full wp-image-3595" /></a></p>

