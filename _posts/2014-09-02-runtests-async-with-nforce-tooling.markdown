---
layout: post
title:  RunTests Async with nforce-tooling
description: What do you get when you mix a long holiday weekend with a guy afflicted with ADSO (attention deficit...oh! shiny object)? You get new code for the  Salesforce Tooling API ! Thats right, I added the following functionality over the weekend to the  nforce-tooling plugin for  nforce . So now you can run the following from your node.js code- 1. ApexOrgWideCoverage - returns code coverage test results for an entire org. 2. ApexCodeCoverage - returns code coverage test results for an Apex class or   
date: 2014-09-02 18:47:42 +0300
image:  '/images/slugs/runtests-async-with-nforce-tooling.jpg'
tags:   ["salesforce", "nforce-tooling"]
---
<p>What do you get when you mix a long holiday weekend with a guy afflicted with ADSO (attention deficit...oh! shiny object)? You get new code for the <a href="http://www.salesforce.com/us/developer/docs/api_toolingpre/api_tooling.pdf">Salesforce Tooling API</a>! That's right, I added the following functionality over the weekend to the <a href="https://github.com/jeffdonthemic/nforce-tooling">nforce-tooling</a> plugin for <a href="https://github.com/kevinohara80/nforce">nforce</a>. So now you can run the following from your node.js code:</p>
<ol>
<li>ApexOrgWideCoverage - returns code coverage test results for an entire org.</li>
<li>ApexCodeCoverage - returns code coverage test results for an Apex class or trigger including the percent covered, the number of lines covered and uncovered by tests and the actual line numbers of uncovered the code.</li>
<li>RunTestsAsynchronous - executes the tests for specified classes and returns test coverage status of tests.</li>
</ol>
<p>For example, <a href="https://github.com/jeffdonthemic/nforce-tooling/blob/master/examples/runTests.js">here is a test script</a> that deploys 2 Apex class and their accompanying test classes and then runs all tests asychronously to return the results. It then cleans up after itself by deleting the classes that were deployed. The output looks something like:</p>
{% highlight js %}$ node examples/runTests.js
*** Running tests asynchronously. I know. This is awesome!! ***
Inserted ApexClass ToolingTest1
Inserted ApexClass ToolingTest2
Inserted ApexClass ToolingTest2_Test
Inserted ApexClass ToolingTest1_Test
Started async runTests job 707o000000AmuQD
Checking status of runTests job 707o000000AmuQD repeatedly until all tests complete.
All tests have completed! W00t!
========================================
** TEST RESULTS **
========================================
Results for ToolingTest2_Test: Fail
  System.AssertException: Assertion Failed
  Class.df14jeff.ToolingTest2_Test.assertName: line 7, column 1
========================================
Results for ToolingTest1: Pass
  Percentage covered by tests: 0.3333333333333333
  Lines covered / uncovered: 2 / 4
  Uncovered lines: 7, 8, 11, 12
========================================
Everything complete! Resetting the test environment.
Deleted ApexClass 01po0000001k9QzAAI
Deleted ApexClass 01po0000001k9QtAAI
Deleted ApexClass 01po0000001k9QyAAI
Deleted ApexClass 01po0000001k9R3AAI
{% endhighlight %}
<p>I'm working on some cool stuff for the tooling plugin and hope to have something to show in the next couple of weeks.</p>

