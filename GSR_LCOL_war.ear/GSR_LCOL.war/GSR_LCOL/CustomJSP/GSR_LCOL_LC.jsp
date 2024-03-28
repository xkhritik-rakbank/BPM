<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 11 (filtered)">
<title></title>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%
			DateFormat dtFormat = new SimpleDateFormat("dd/MM/yy");
			String dateFormat = dtFormat.format(new java.util.Date());			
		%>
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Arabic Transparent";}
@font-face
	{font-family:"Wingdings 2";
	panose-1:5 2 1 2 1 5 7 7 7 7;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Times New Roman";}
h1
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:center;
	page-break-after:avoid;
	direction:rtl;
	unicode-bidi:embed;
	font-size:12.0pt;
	font-family:"Times New Roman";}
h2
	{margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Times New Roman";}
h3
	{margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Times New Roman";}
h5
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:left;
	page-break-after:avoid;
	direction:rtl;
	unicode-bidi:embed;
	font-size:12.0pt;
	font-family:"Times New Roman";}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoTitle, li.MsoTitle, div.MsoTitle
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:center;
	direction:rtl;
	unicode-bidi:embed;
	font-size:14.0pt;
	font-family:"Times New Roman";
	font-weight:bold;
	text-decoration:underline;}
p.MsoBodyText, li.MsoBodyText, div.MsoBodyText
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:right;
	direction:rtl;
	unicode-bidi:embed;
	font-size:12.0pt;
	font-family:"Times New Roman";
	font-weight:bold;}
p.MsoBodyTextIndent, li.MsoBodyTextIndent, div.MsoBodyTextIndent
	{margin-top:6.0pt;
	margin-right:468.85pt;
	margin-bottom:6.0pt;
	margin-left:0in;
	text-align:right;
	direction:rtl;
	unicode-bidi:embed;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoBodyText2, li.MsoBodyText2, div.MsoBodyText2
	{margin:0in;
	margin-bottom:.0001pt;
	text-align:left;
	direction:rtl;
	unicode-bidi:embed;
	font-size:12.0pt;
	font-family:"Times New Roman";
	font-weight:bold;}
p.MsoBodyText3, li.MsoBodyText3, div.MsoBodyText3
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:3.0pt;
	margin-left:0in;
	text-align:justify;
	font-size:10.0pt;
	font-family:"Times New Roman";
	font-weight:bold;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:Tahoma;}
p.BoxedHeading, li.BoxedHeading, div.BoxedHeading
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:6.0pt;
	margin-left:0in;
	border:none;
	padding:0in;
	font-size:11.0pt;
	font-family:"Times New Roman";
	text-transform:uppercase;
	font-weight:bold;}
span.msoIns
	{text-decoration:underline;
	color:teal;}
span.msoDel
	{text-decoration:line-through;
	color:red;}
 /* Page Definitions */
 @page Section1
	{size:595.3pt 841.9pt;
	margin:.25in .9in .25in .9in;}
div.Section1
	{page:Section1;}
 /* List Definitions */
 ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
-->
</style>

</head>

<body lang=EN-US onload="window.print();">

<div class=Section1>
<center><H3><U>LIABILITY CERTIFICATE REQUEST</U></H3></center>
<h3><span lang=EN-GB>The Manager</span></h3>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>The <span style='color:red'>RAK</span>BANK                                                                                             Date:
_<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>_</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>___</span><u><span lang=EN-GB style='font-size:11.0pt;
color:#003300'><%=request.getParameter("BranchCodeName")==null?"":request.getParameter("BranchCodeName")%></span></u><span lang=EN-GB
style='font-size:12.0pt'>__</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>     (Branch)</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Loan Agreement ID ___<%=request.getParameter("AgreementNo")==null?"":request.getParameter("AgreementNo")%>__</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Customer Name __<%=request.getParameter("CustomerName")==null?"":request.getParameter("CustomerName")%>___</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Addressed To__<%=request.getParameter("AddressedToName")==null?"":request.getParameter("AddressedToName")%>__</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Language __<%=request.getParameter("Language")==null?"":request.getParameter("Language")%>___</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>To be delivered to__<%=request.getParameter("ToBeDeliveredTo")==null?"":request.getParameter("ToBeDeliveredTo")%>__</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:27.0pt;text-align:justify;text-indent:
-27.0pt'><span lang=EN-GB style='font-size:11.0pt;font-family:"Wingdings 2"'><span
style='font:7.0pt "Times New Roman"'><input type="checkbox">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span lang=EN-GB style='font-size:11.0pt'>Kindly arrange to issue
a Certificate listing all my direct and indirect liabilities to the Bank,
including any liabilities as a guarantor.</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>I authorise you to recover LC Charge of AED __<%=request.getParameter("Amount")==null?"":request.getParameter("Amount")%>_____
</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB></span><span
lang=EN-GB style='font-size:12.0pt'><input type="checkbox">From my Account Number _<%=request.getParameter("DebitAccount")==null?"":request.getParameter("DebitAccount")%>_(Please
enter your 13 digit account number)</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>OR</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB></span><span
lang=EN-GB style='font-size:12.0pt'><input type="checkbox">I have deposited Cash </span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>OR</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB></span><span
lang=EN-GB style='font-size:12.0pt'><input type="checkbox">I authorise you to accrue the charge on my
loan account and to recover from my next salary</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=631 valign=top style='width:473.4pt;border:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:12.0pt'>&nbsp;</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:12.0pt'>&nbsp;</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:12.0pt'>&nbsp;</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:12.0pt'>_____________________________________                            
  ____________________</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:12.0pt'>                   <b>Customer(s) Signature.</b>                                                     
  <b>Signature verified</b></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='text-align:justify'><b><span lang=EN-GB
style='font-size:12.0pt'>Note:</span></b><span lang=EN-GB style='font-size:
12.0pt'> Please be advised that issuance of Liability Certificate will take
four working days</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><b><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></b></p>

<p class=MsoNormal style='text-align:justify'><b><span lang=EN-GB
style='font-size:12.0pt'>I acknowledge receipt of the Liability Certificate.</span></b></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>_____________________                              ____________            ___________________</span></p>

<div style='border:none;border-bottom:solid windowtext 1.5pt;padding:0in 0in 1.0pt 0in'>

<p class=MsoNormal style='text-align:justify;border:none;padding:0in'><span
lang=EN-GB style='font-size:12.0pt'>     <b>Customer(s) Signature</b>                                      
<b>Date</b>                   <b>Signature Verified</b></span></p>

</div>

<p class=MsoNormal><span lang=EN-GB style='font-size:12.0pt;color:black'> </span></p>

</div>

</body>

</html>
