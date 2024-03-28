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
h4
	{margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:11.0pt;
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
<center><H3><U>NO LIABILITY CERTIFICATE REQUEST</U></H3></center>
<h3><span lang=EN-GB style='font-size:11.0pt;color:#003300'>The Manager</span></h3>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>The RAKBANK                                                                                               Date:
<span class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:49"><%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%></ins></span>_<span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:50"> </ins></span>__<u><span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T17:10"></ins></span></u>___</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>___</span><u><span lang=EN-GB style='font-size:11.0pt;
color:#003300'><%=branchCode==null?"":branchCode%></span></u><span lang=EN-GB
style='font-size:12.0pt'>__</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>  (Branch)</span></p>


<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>Loan Agreement ID ______<span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:48"><ins
cite="mailto:jabha"><%=AgreementNo%></ins></ins></span><span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:47"> </ins></span>___</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>Customer Name __<span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:48"><%=CustomerName==null?"":CustomerName%></ins></span>__
</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>Addressed To___<span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:50"><%=AddressedToName==null?"":AddressedToName%></ins></span>___</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>Language ____<span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:50"><ins
cite="mailto:jabha"><%=Language)==null?"":Language%></ins></ins></span>____</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>To be delivered to_____<span
class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:51"><ins
cite="mailto:jabha"><%=ToBeDeliveredTo==null?"":ToBeDeliveredTo%></ins></ins></span>__</span></p>

<p class=MsoNormal style='margin-bottom:3.0pt;text-align:justify'><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:27.0pt;text-align:justify;text-indent:
-27.0pt'><span lang=EN-GB style='font-size:11.0pt;font-family:"Wingdings 2";
color:#003300'><span style='font:7.0pt "Times New Roman"'><input type="checkbox">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span></span><span lang=EN-GB style='font-size:11.0pt;color:#003300'>Kindly
arrange to issue a No Liability Certificate as my direct and indirect
liabilities to the Bank have been settled.</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>I authorise you to recover NLC Charges
of AED <span class=MsoNormal><ins cite="mailto:xamit" datetime="2007-11-21T16:52">____<%=Amount==null?"":Amount%>_
</ins></span></span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span
lang=EN-GB style='color:#003300'></span><span lang=EN-GB style='font-size:
11.0pt;color:#003300'><input type="checkbox">From my Account Number </span><span lang=EN-GB
style='font-size:12.0pt;color:#003300'><span class=MsoNormal><ins
cite="mailto:xamit" datetime="2007-11-21T16:52">_<%=DebitAccount==null?"":DebitAccount%></ins></span></span><span
lang=EN-GB style='font-size:11.0pt;color:#003300'>_(Please enter your 13 digit
account number)</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>OR</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span
lang=EN-GB style='color:#003300'></span><span lang=EN-GB style='font-size:
11.0pt;color:#003300'><input type="checkbox">I have deposited Cash for issuance of NLC</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=631 valign=top style='width:473.4pt;border:solid windowtext 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:11.0pt;color:#003300'>_____________________________________                            
  ____________________</span></p>
  <p class=MsoNormal style='text-align:justify'><span lang=EN-GB
  style='font-size:11.0pt;color:#003300'>                   <b>Customer(s)
  Signature</b>                                                      <b>Signature
  verified</b></span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='text-align:justify'><b><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>Note:</span></b><span lang=EN-GB
style='font-size:11.0pt;color:#003300'> Please be advised that issuance of No
Liability Certificate will take seven working days</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><b><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>I acknowledge receipt of the No
Liability Certificate.</span></b></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:11.0pt;color:#003300'>_____________________                              ____________                           
___________________</span></p>

<div style='border:none;border-bottom:solid windowtext 1.5pt;padding:0in 0in 1.0pt 0in'>

<p class=MsoNormal style='text-align:justify;border:none;padding:0in'>      <span
lang=EN-GB style='font-size:11.0pt;color:#003300'>    <b>Customer(s) Signature</b>                                       
<b>Date</b>                                     <b>     &nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Signature Verified</b></span></p>

</div>

<p class=MsoNormal><b><span lang=EN-GB style='font-size:11.0pt;color:#003300'> For
bank use
only                                                                       </span><span
lang=EN-GB style='color:#003300'>Branch                             </span></b></p>

<h4><span lang=EN-GB style='color:#003300'>  </span></h4>

<p class=MsoHeader><span lang=EN-GB style='color:#003300'>Account Closure Letter
Taken                                                         
_____________                                                                                         
</span></p>

<p class=MsoNormal><span lang=EN-GB style='color:#003300'>ATM Card
Cancelled                                                                        _____________                      
</span></p>

<p class=MsoHeader><span lang=EN-GB style='color:#003300'>Credit Card
Cancelled                                                                       
_____________                      </span></p>

<p class=MsoNormal><span lang=EN-GB style='color:#003300'>NLC Charges – </span> <span lang=EN-GB style='color:#003300'><input type="checkbox">Hold</span><span lang=EN-GB style='color:#003300'>
placed                                                         _____________                 
</span></p>

<p class=MsoNormal><span lang=EN-GB style='color:#003300'>                         
</span><span lang=EN-GB style='color:#003300'></span><span lang=EN-GB
style='color:#003300'><input type="checkbox">0010-850002-784 account credited on               __
__/__ __/__________ </span></p>

<p class=MsoNormal><span lang=EN-GB style='color:#003300'>                         
</span><span lang=EN-GB style='color:#003300'></span><span lang=EN-GB
style='color:#003300'><input type="checkbox">Branch Manager Approval                                 _____________________</span></p>

<p class=MsoNormal><span lang=EN-GB style='color:#003300'>&nbsp;</span></p>

</div>

</body>

</html>
