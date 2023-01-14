---
layout: post
title:  Generate a Visualforce Page from an Existing Page Layout
description: We have a rather large Org with 600+ Page Layouts. When Visualforce came out we had a number of requests from our business units for customized layouts. After about 3 weeks of hand-coding Visualforce pages I soon realized I needed a better way to communicate these change as well as manage the code modifications. Being that I am relatively lazy by nature, I decided that I needed to develop a way to make my computer do the work that I didnt want to do. The C# code that I wrote utilizes the Metadat
date: 2009-02-09 18:00:00 +0300
image:  '/images/slugs/generate-a-visualforce-page-from-an-existing-page-layout.jpg'
tags:   ["code sample", "salesforce", ".net"]
---
<p>We have a rather large Org with 600+ Page Layouts. When Visualforce came out we had a number of requests from our business units for customized layouts. After about 3 weeks of hand-coding Visualforce pages I soon realized I needed a better way to communicate these change as well as manage the code modifications. Being that I am relatively lazy by nature, I decided that I needed to develop a way to make my computer do the work that I didn't want to do.</p>
<img class="alignnone size-full wp-image-446" title="Generate Visualforce Pages" src="http://res.cloudinary.com/blog-jeffdouglas-com/image/upload/v1400399677/scaffolding_gczj3k.png" alt="Generate Visualforce Pages" width="544" height="561" />
<p>The C# code that I wrote utilizes the Metadata API and inspects the Page Layout for a specified Object and Recordtype and generates similar Visualforce code that you can paste into the Force.com IDE. Is it perfect? No. Could it have been done better? Yes. Does it save me time, money and aggravation? Most certainly!</p>
<p>It also saves me time during the change management process. Now when a BA or Project Manager modifies an existing Page Layout that I have used for a Visualforce page, I don't need documentation on what fields have changed, I just point my handy-dandy generator at the Page Layout and regenerate the code.</p>
<p><strong>Default.aspx</strong></p>
{% highlight js %}<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Visualforce_Scaffolding._Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title>Visualforce Scaffolding Generator</title>
	<style type="text/css">
	.style1
	{
	  height: 25px;
	}
	</style>
<link rel='stylesheet' id='wpe-common-css' href='http://blog.jeffdouglas.com/wp-content/mu-plugins/wpengine-common/css/wpe-common.css?ver=2.1.9' type='text/css' media='all' />
<link rel='stylesheet' id='nextgen_gallery_related_images-css' href='http://blog.jeffdouglas.com/wp-content/plugins/nextgen-gallery/products/photocrati_nextgen/modules/nextgen_gallery_display/static/nextgen_gallery_related_images.css?ver=3.9' type='text/css' media='all' />
<link rel='stylesheet' id='open-sans-css' href='//fonts.googleapis.com/css?family=Open+Sans%3A300italic%2C400italic%2C600italic%2C300%2C400%2C600&#038;subset=latin%2Clatin-ext&#038;ver=3.9' type='text/css' media='all' />
<link rel='stylesheet' id='dashicons-css' href='http://blog.jeffdouglas.com/wp-includes/css/dashicons.min.css?ver=3.9' type='text/css' media='all' />
<link rel='stylesheet' id='admin-bar-css' href='http://blog.jeffdouglas.com/wp-includes/css/admin-bar.min.css?ver=3.9' type='text/css' media='all' />
</head>
<body>
	<form id="form1" runat="server">
<div>
<h1>Visualforce Scaffolding Generator</h1>
<asp:Label ID="Label3" runat="server" Text="This page generates the Visualforce code for a specific object and recordtye. The code inspects the page layout for the recordtype and creates a very similar replica of the sections and field layouts as Visualforce code. You can then take this code and paste it into a Visualforce page with minimal changes."/>
<table border="0" cellpadding="2" cellspacing="2">
<tr>
<td><asp:Label ID="Label1" runat="server" Text="Object"></asp:Label></td>
<td><asp:TextBox ID="txtObject" runat="server" Width="200px">Account</asp:TextBox></td>
</tr>
<tr>
<td><asp:Label ID="Label2" runat="server" Text="RecordType ID"></asp:Label></td>
<td><asp:TextBox ID="txtRecordTypeId" runat="server" Width="200px">01260000000Dxxx</asp:TextBox></td>
</tr>
<tr>
<td class="style1">Page Type</td>
<td class="style1">
				<asp:DropDownList ID="ddlMode" runat="server">
				<asp:ListItem Value="Edit">New/Edit</asp:ListItem>
				<asp:ListItem>Display</asp:ListItem>
				</asp:DropDownList></td>
</tr>
<tr>
<td></td>
<td><asp:Button ID="Button1" runat="server" Text="Generate Code" onclick="Button1_Click" /></td>
</tr>
</table>
</div>
<asp:Literal ID="Code" runat="server"></asp:Literal>

	</form>
</body>
</html>
{% endhighlight %}
<p><strong>Here is the code behind for Default.aspx.cs</strong></p>
{% highlight js %}using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using Visualforce_Scaffolding.sforce;

namespace Visualforce_Scaffolding
{
  public partial class _Default : System.Web.UI.Page
  {

  private string username;
  private string password;
  private string sessionId;
  private string serverUrl;
  private SforceService proxy;

  protected void Page_Load(object sender, EventArgs e)
  {
  proxy = new sforce.SforceService();
  if (Request.QueryString["sessionId"] != null)
  {
    sessionId = Request.QueryString["sessionId"].ToString();
    serverUrl = Request.QueryString["url"].ToString();
  }
  else
  {
    // hardcode the u/p for development
    username = "YOUR_USERNAME";
    password = "YOUR_PASSWORD";
  }
  }

  private void output(string s, int tabs)
  {
  // fix some characters for html output
  s = s.Replace("<", "&#60");
  s = s.Replace(">", "&#62");

  for (int j = 0; j < tabs; j++)
  {
    Code.Text = Code.Text + ("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
    //Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
  }

  Code.Text = Code.Text + (s);
  Code.Text = Code.Text + ("[br]");
  }

  public void generateDisplayPageLayout(string objectToDescribe, string recordType)
  {
  output("<apex:page standardController="" + txtObject.Text + "">", 0);
  output("<apex:sectionHeader title="" + txtObject.Text + "" subtitle="{!" + txtObject.Text.ToLower() + ".name}"/>", 1);
  output("<apex:pageBlock title="" + txtObject.Text + "">", 1);

  try
  {
    sforce.DescribeLayoutResult dlr = proxy.describeLayout(objectToDescribe, new string[] { recordType });

    // get all of the fields that are in this layout
    for (int i = 0; i < dlr.layouts.Length; i++)
    {
    sforce.DescribeLayout layout = dlr.layouts[i];
    if (layout.editLayoutSections != null)
    {
    for (int j = 0; j < layout.editLayoutSections.Length; j++)
    {
      sforce.DescribeLayoutSection els = layout.editLayoutSections[j];

      output("", 2);
      output("<apex:pageBlockSection title="" + els.heading + "" columns="" + els.columns + "">", 2);

      for (int k = 0; k < els.layoutRows.Length; k++)
      {
      sforce.DescribeLayoutRow lr = els.layoutRows[k];
      for (int h = 0; h < lr.layoutItems.Length; h++)
      {
      sforce.DescribeLayoutItem li = lr.layoutItems[h];
      if (li.layoutComponents != null)
      {
        output("<apex:outputField title="" + li.label + "" value="{!" + txtObject.Text.ToLower() + "." + li.layoutComponents[0].value + "}"/>", 3);
        //Response.Write(" " + h + " " + li.layoutComponents[0].value + "(editable: " + li.editable + ") label: " + li.label + " required: " + li.required + "[br]");
      }

      }
      }

      output("</apex:pageBlockSection>", 2);

    }
    }
    }

  }
  catch (Exception e)
  {
    Response.Write("An exceptions was caught: " + e.Message + "[br]");
  }

  output("</apex:pageBlock>", 1);
  output("</apex:page>", 0);

  }

  public void generateEditPageLayout(string objectToDescribe, string recordType)
  {
  output("<apex:page standardController="" + txtObject.Text + "">", 0);
  output("<apex:sectionHeader title="" + txtObject.Text + " Edit" subtitle="{!" + txtObject.Text.ToLower() + ".name}"/>", 1);
  output("<apex:form>", 1);
  output("<apex:pageBlock title="" + txtObject.Text + " Edit" mode="edit">", 1);

  output("", 2);

  output("<apex:pageBlockButtons location="top">", 2);
  output("<apex:commandButton value="Save" action="{!save}" />", 3);
  output("<apex:commandButton value="Save & New" action="{!save}" />", 3);
  output("<apex:commandButton value="Cancel" action="{!cancel}" />", 3);
  output("</apex:pageBlockButtons>", 2);

  output("<apex:pageBlockButtons location="bottom">", 2);
  output("<apex:commandButton value="Save" action="{!save}" />", 3);
  output("<apex:commandButton value="Save & New" action="{!save}" />", 3);
  output("<apex:commandButton value="Cancel" action="{!cancel}" />", 3);
  output("</apex:pageBlockButtons>", 2);

  try
  {
    sforce.DescribeLayoutResult dlr = proxy.describeLayout(objectToDescribe, new string[] { recordType });

    // get all of the fields that are in this layout
    for (int i = 0; i < dlr.layouts.Length; i++)
    {
    sforce.DescribeLayout layout = dlr.layouts[i];
    if (layout.editLayoutSections != null)
    {
    for (int j = 0; j < layout.editLayoutSections.Length; j++)
    {
      sforce.DescribeLayoutSection els = layout.editLayoutSections[j];

      output("", 2);
      output("<apex:pageBlockSection title="" + els.heading + "" columns="" + els.columns + "">", 2);

      for (int k = 0; k < els.layoutRows.Length; k++)
      {
      sforce.DescribeLayoutRow lr = els.layoutRows[k];
      for (int h = 0; h < lr.layoutItems.Length; h++)
      {
      sforce.DescribeLayoutItem li = lr.layoutItems[h];
      if (li.layoutComponents != null)
      {
        output("<apex:inputField value="{!" + txtObject.Text.ToLower() + "." + li.layoutComponents[0].value + "}" required="" + li.required.ToString().ToLower() + ""/>", 3);
        //Response.Write(" " + h + " " + li.layoutComponents[0].value + "(editable: " + li.editable + ") label: " + li.label + " required: " + li.required + "[br]");
      }

      }
      }

      output("</apex:pageBlockSection>", 2);

    }
    }
    }

  }
  catch (Exception e)
  {
    Response.Write("An exceptions was caught: " + e.Message + "[br]");
  }

  output("</apex:pageBlock>", 1);
  output("</apex:form>", 1);
  output("</apex:page>", 0);

  }

  public bool login()
  {

  // use the existing session from the org
  if (sessionId != null)
  {

    try
    {
    Response.Write("Using existing session[br]");
    proxy.Url = serverUrl;
    proxy.SessionHeaderValue = new sforce.SessionHeader();
    proxy.SessionHeaderValue.sessionId = sessionId;

    GetUserInfoResult userInfo = proxy.getUserInfo();
    Response.Write("Logged in as " + userInfo.userFullName + " - " + userInfo.userName + "<hr />");

    }
    catch (Exception ex)
    {
    Response.Write("Error logging in with session: " + ex.Message + "[br]");
    return false;
    }

    return true;

  }
  else
  {

    // this is for development
    Response.Write("Logging in with u/p[br]");
    sforce.LoginResult lr = proxy.login(username, password);
    if (!lr.passwordExpired)
    {
    // Reset the SOAP endpoint to the returned server URL
    proxy.Url = lr.serverUrl;
    // Create a new session header object and add the session ID returned from the login
    proxy.SessionHeaderValue = new sforce.SessionHeader();
    proxy.SessionHeaderValue.sessionId = lr.sessionId;

    GetUserInfoResult userInfo = lr.userInfo;
    Response.Write("Logged in as " + userInfo.userFullName + " - " + userInfo.userName + "<hr />");
    }
    else
    {
    Response.Write("Your password is expired.[br]");
    return false;
    }
    return true;
  }
  }

  protected void Button1_Click(object sender, EventArgs e)
  {
  Code.Text = "";
  if (login())
  {
    Code.Text = Code.Text + "<hr />";
    if (ddlMode.Text == "Edit")
    {
    generateEditPageLayout(txtObject.Text, txtRecordTypeId.Text);
    }
    else
    {
    generateDisplayPageLayout(txtObject.Text, txtRecordTypeId.Text);
    }
  }
  }

  }
}
{% endhighlight %}

