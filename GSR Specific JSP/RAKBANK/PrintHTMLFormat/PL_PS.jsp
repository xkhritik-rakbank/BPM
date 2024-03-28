<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 11 (filtered)">
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<style>
<!--
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:12.0pt;
	font-family:"Times New Roman";}
h3
	{margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{margin:0in;
	margin-bottom:.0001pt;
	border:none;
	padding:0in;
	font-size:8.0pt;
	font-family:"Times New Roman";
	color:gray;
	font-style:italic;}
p.MsoBodyText, li.MsoBodyText, div.MsoBodyText
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:3.0pt;
	margin-left:.25in;
	text-indent:-.25in;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.BoxedHeading, li.BoxedHeading, div.BoxedHeading
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:2.0pt;
	margin-left:0in;
	border:none;
	padding:0in;
	font-size:11.0pt;
	font-family:"Times New Roman";
	text-transform:uppercase;
	font-weight:bold;}
 /* Page Definitions */
 @page Section1
	{size:595.3pt 841.9pt;
	margin:.25in .9in .25in .9in;}
div.Section1
	{page:Section1;}
-->
</style>
<%
			DateFormat dtFormat = new SimpleDateFormat("dd/MM/yy");
			String dateFormat = dtFormat.format(new java.util.Date());			
		%>

</head>

<body lang=EN-US onload="window.print();">
<div class=Section1>
<center><H3><U>PERSONAL LOAN - PART SETTLEMENT FORM</U></H3></center>
<p class=MsoHeader><span lang=EN-GB style='font-size:9.0pt'>&nbsp;</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:2.0in;text-indent:.5in'><span lang=EN-GB>                                                                Date
_<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>_</span></p>

<h3 style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;margin-left:
0in'><span lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></h3>

<h3 style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;margin-left:
0in'><span lang=EN-GB style='font-size:12.0pt'>The National Bank of Ras
Al-Khaimah</span></h3>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB>&nbsp;</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB>&nbsp;</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB>&nbsp;</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB style='font-size:12.0pt'>Loan Agreement ID
________<%=request.getParameter("AgreementNo")==null?"":request.getParameter("AgreementNo")%>___</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB style='font-size:12.0pt'>Customer Name______<%=request.getParameter("CustomerName")==null?"":request.getParameter("CustomerName")%>__</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='font-size:12.0pt;line-height:150%'>&nbsp;</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='font-size:12.0pt;line-height:150%'>Please debit my/our
account number _<%=request.getParameter("DebitAccount")%>_ for an amount of AED _<%=request.getParameter("AmountReceived")%>_
towards part settlement of my/our loan.</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='font-size:12.0pt;line-height:150%'>&nbsp;</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='font-size:12.0pt;line-height:150%'>I/We note that the bank
will maintain the same monthly instalment and reduce the loan tenor.</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='font-size:12.0pt;line-height:150%'>&nbsp;</span></p>

<div style='border:solid windowtext 1.0pt;padding:1.0pt 4.0pt 1.0pt 4.0pt'>

<p class=BoxedHeading><span lang=EN-GB style='font-size:12.0pt'>Part Settlement
charges</span></p>

</div>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span lang=EN-GB style='line-height:150%'> </span><span lang=EN-GB style='font-size:
12.0pt;line-height:150%'><input type="checkbox">Part Settlement Charges are included in the amount
mentioned above</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='font-size:12.0pt;line-height:150%'>OR</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span lang=EN-GB style='line-height:150%'> </span><span lang=EN-GB style='font-size:
12.0pt;line-height:150%'><input type="checkbox">Part Settlement Charges to be debited from my/our
account number mentioned above</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<div style='border:solid windowtext 1.0pt;padding:1.0pt 4.0pt 0in 4.0pt'>

<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:12.0pt;text-transform:none;font-weight:normal'>&nbsp;</span></p>

<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:12.0pt;text-transform:none;font-weight:normal'>&nbsp;</span></p>

<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:10.0pt'>____________________
/________________________                          _____________________________         </span></p>

<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:10.0pt;text-transform:none;font-weight:normal'>Customer(s)
Signature</span><span lang=EN-GB style='font-size:10.0pt;text-transform:none;
font-weight:normal'>        </span><span lang=EN-GB style='font-size:10.0pt'>                                                                                                </span><span
lang=EN-GB style='font-size:10.0pt;text-transform:none;font-weight:normal'>Signature
verified</span></p>

</div>

</div>

</body>

</html>
