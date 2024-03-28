<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 11 (filtered)">
<title></title>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
			DateFormat dtFormat = new SimpleDateFormat("dd/MM/yy");
			String dateFormat = dtFormat.format(new java.util.Date());	
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
			String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: branchCode: "+branchCode);

			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("AgreementNo", request.getParameter("AgreementNo"), 1000, true) );
			String AgreementNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: AgreementNo: "+AgreementNo);			

			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CustomerName", request.getParameter("CustomerName"), 1000, true) );
			String CustomerName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("Integration jsp: CustomerName: "+CustomerName);			

			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("AddressedToName", request.getParameter("AddressedToName"), 1000, true) );
			String CustomerName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("Integration jsp: AddressedToName: "+AddressedToName);	

			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Language", request.getParameter("Language"), 1000, true) );
			String Language = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("Integration jsp: Language: "+Language);			

			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ToBeDeliveredTo", request.getParameter("ToBeDeliveredTo"), 1000, true) );
			String Language = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			WriteLog("Integration jsp: ToBeDeliveredTo: "+ToBeDeliveredTo);

			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Amount", request.getParameter("Amount"), 1000, true) );
			String Amount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			WriteLog("Integration jsp: Amount: "+Amount);			

			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DebitAccount", request.getParameter("DebitAccount"), 1000, true) );
			String DebitAccount = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			WriteLog("Integration jsp: DebitAccount: "+DebitAccount);			
			




			
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
color:#003300'><%=branchCode==null?"":branchCode%></span></u><span lang=EN-GB
style='font-size:12.0pt'>__</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>     (Branch)</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Loan Agreement ID ___<%=AgreementNo==null?"":AgreementNo%>__</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Customer Name __<%=CustomerName==null?"":CustomerName%>___</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Addressed To__<%=AddressedToName==null?"":AddressedToName%>__</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>Language __<%=Language==null?"":Language%>___</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:12.0pt'>To be delivered to__<%=ToBeDeliveredTo==null?"":ToBeDeliveredTo%>__</span></p>

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
style='font-size:12.0pt'>I authorise you to recover LC Charge of AED __<%=Amount==null?"":Amount%>_____
</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB></span><span
lang=EN-GB style='font-size:12.0pt'><input type="checkbox">From my Account Number _<%=DebitAccount==null?"":DebitAccount%>_(Please
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
