
<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 11 (filtered)">
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<title></title>
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Times New Roman";}
h1
	{margin:0in;
	margin-bottom:.0001pt;
	page-break-after:avoid;
	font-size:8.0pt;
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
p.MsoBodyTextIndent, li.MsoBodyTextIndent, div.MsoBodyTextIndent
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.25in;
	margin-bottom:.0001pt;
	text-indent:-.25in;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoBodyTextIndent2, li.MsoBodyTextIndent2, div.MsoBodyTextIndent2
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:6.0pt;
	margin-left:9.35pt;
	text-align:justify;
	text-indent:-9.35pt;
	font-size:10.0pt;
	font-family:"Times New Roman";}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:Tahoma;}
p.Parenthesis, li.Parenthesis, div.Parenthesis
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Times New Roman";}
p.BoxedHeading, li.BoxedHeading, div.BoxedHeading
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:0in;
	border:none;
	padding:0in;
	font-size:9.0pt;
	font-family:"Times New Roman";
	text-transform:uppercase;
	font-weight:bold;}
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
<%
			DateFormat dtFormat = new SimpleDateFormat("dd/MM/yy");
			String dateFormat = dtFormat.format(new java.util.Date());			
		%>
</head>

<body lang=EN-US onload="window.print();">

<div class=Section1>
<center><H3><U>PERSONAL LOAN - EARLY SETTLEMENT FORM</U></H3></center>


<h3 style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;margin-left:
0in'><span lang=EN-GB style='font-size:12.0pt'>The National Bank of Ras
Al-Khaimah                                              </span><span
lang=EN-GB>Date _<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>__</span></h3>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB>Loan Agreement ID ___<%=request.getParameter("AgreementNo")==null?"":request.getParameter("AgreementNo")%>___</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB>Customer Name __<%=request.getParameter("CustomerName")==null?"":request.getParameter("CustomerName")%>__</span></p>

<p class=MsoHeader style='margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
margin-left:0in'><span lang=EN-GB style='font-size:8.0pt'>&nbsp;</span></p>

<div style='border:solid windowtext 1.0pt;padding:1.0pt 4.0pt 1.0pt 4.0pt'>

<p class=BoxedHeading><span lang=EN-GB style='font-size:9.0pt'>Early
settlement – FUll and FINAL SETTLEMENT</span></p>

</div>

<p class=MsoBodyText style='margin-left:0in;text-align:justify;text-indent:
0in;line-height:150%'><input type="checkbox"><span lang=EN-GB style='line-height:150%'>  Plea</span><span
lang=EN-GB style='line-height:150%'>se debit my/our account number ___<%=request.getParameter("DebitAccount")%>____
for an amount of AED ____<%=request.getParameter("AmountReceived")%>____ towards full
settlement of my/our loan including early settlement charges</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='line-height:150%'>OR</span></p>

<p class=MsoBodyText style='margin-left:0in;text-align:justify;text-indent:
0in;line-height:150%'><span lang=EN-GB style='line-height:150%'><input type="checkbox">  </span><span
lang=EN-GB style='line-height:150%'>I am depositing a cheque for an amount of
AED ____<%=request.getParameter("AmountReceived")%>____ towards early settlement of all
my/our outstanding</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='line-height:150%'>I wish to continue with my </span><span lang=EN-GB style='line-height:150%'> </span><span lang=EN-GB style='line-height:
150%'><input type="checkbox">Card No_______________________________</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in;line-height:150%'><span
lang=EN-GB style='line-height:150%'>                                           
</span><span lang=EN-GB style='line-height:150%'> </span><span lang=EN-GB
style='line-height:150%'><input type="checkbox">Auto Loan________________________________</span></p>

<div style='border:solid windowtext 1.0pt;padding:0in 4.0pt 1.0pt 4.0pt'>

<p class=BoxedHeading style='border:none;padding:0in'><span lang=EN-GB
style='font-size:9.0pt'>NO LIABILITY Certificate      </span></p>

</div>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in'><span lang=EN-GB>Kindly
arrange to issue a No Liability certificate addressed to </span><span
lang=EN-GB>__________________________________________, which is to be </span></p>

<p class=MsoBodyText><span lang=EN-GB> <input type="checkbox">Collected from
_____________________Branch, or</span></p>

<p class=MsoBodyText style='line-height:150%'><span
lang=EN-GB style='line-height:150%'> <input type="checkbox">Mailed to _______________________________________________________________________________    
</span></p>



<p class=MsoBodyText style='line-height:150%'><span lang=EN-GB
style='line-height:150%'>Please issue the No Liability letter in
________________________________ language</span></p>

<!-- <p class=MsoBodyText style='margin-left:0in;text-indent:0in'><span lang=EN-GB>&nbsp;</span></p> -->

<p class=MsoBodyText style='margin-left:0in;text-indent:0in'><span lang=EN-GB>I
authorise you to recover the No Liability Certificate charges of AED_________</span></p>

<p class=MsoBodyText style='margin-left:0in;text-indent:0in'><span
lang=EN-GB> <input type="checkbox"> From my Account Number ______________________________ (Please
enter your 13-digit Account Number)</span></p>

<p class=MsoBodyText style='margin:0in;margin-bottom:.0001pt;text-indent:0in'><b><span
lang=EN-GB>OR</span></b></p>

<p class=MsoBodyText style='margin:0in;margin-bottom:.0001pt;text-indent:0in;
line-height:150%'><span lang=EN-GB style='line-height:150%'><input type="checkbox"> I have deposited
cash </span></p>

<div style='border:solid windowtext 1.0pt;padding:1.0pt 4.0pt 0in 4.0pt'>

<!-- <p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:8.0pt;text-transform:none;font-weight:normal'>&nbsp;</span></p>
 -->
<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:8.0pt;text-transform:none;font-weight:normal'>&nbsp;</span></p>

<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:8.0pt'>____________________
/_____________________________                                                            _____________________________</span></p>

<p class=BoxedHeading style='margin-bottom:3.0pt;border:none;padding:0in'><span
lang=EN-GB style='font-size:10.0pt;text-transform:none;font-weight:normal'>Customer(s)
Signature</span><span lang=EN-GB style='font-size:10.0pt;text-transform:none;
font-weight:normal'>        </span><span lang=EN-GB style='font-size:10.0pt'>                                                                                                    
</span><span lang=EN-GB style='font-size:10.0pt;text-transform:none;font-weight:
normal'>Signature verified</span></p>

</div>

<p class=MsoNormal><b><span lang=EN-GB style='font-size:8.0pt'>Note:</span></b><span
lang=EN-GB style='font-size:8.0pt'> <b><i>Please be advised that issuance of No
- Liability Certificate will take seven working days</i></b></span></p>

<p class=MsoNormal style='text-align:justify'><b><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></b></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB>The primary
reason for early settlement of my/our loan(s):</span></p>

<p class=MsoBodyText><span lang=EN-GB><input type="checkbox">EOSB</span></p>

<p class=MsoBodyText><span lang=EN-GB><input type="checkbox">Leaving U.A.E. permanently</span></p>

<p class=MsoBodyText><span lang=EN-GB><input type="checkbox"> Own funds to settle the loan</span></p>

<p class=MsoBodyText><span lang=EN-GB><input type="checkbox"> Takeover of loan from another financial
institution: (Which Bank ______________________________)</span></p>

<p class=MsoBodyText><span lang=EN-GB><input type="checkbox">Not satisfied with the service provided:
(Reason ____________________________________________)</span></p>

<p class=MsoBodyText><span lang=EN-GB><input type="checkbox"> Others:
_____________________________________________________________________________</span></p>

<!-- <p class=MsoBodyText><span lang=EN-GB>&nbsp;</span></p> -->

<div class=MsoNormal align=center style='text-align:center'><b><span
lang=EN-GB style='font-size:12.0pt'>

<hr size=2 width="100%" align=center>

</span></b></div>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB>I acknowledge
receipt of the No Liability Certificate.</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>&nbsp;</span></p>

<p class=MsoNormal style='text-align:justify'><span lang=EN-GB
style='font-size:12.0pt'>_____________________                              ____________            ___________________</span></p>

<div style='border:none;border-bottom:solid windowtext 1.5pt;padding:0in 0in 1.0pt 0in'>

<p class=MsoNormal style='text-align:justify;border:none;padding:0in'><span
lang=EN-GB>    <b>Customer(s) Signature</b>                                        
              <span lang=EN-GB
>&nbsp;<b>Date</b>                         <b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Signature Verified</b></span></span></p>

</div>

<p class=MsoNormal><b><span lang=EN-GB style='font-size:11.0pt'>For bank use
only</span></b><span lang=EN-GB>                                                                                
<b>  Branch                                   </b></span></p>

<p class=MsoHeader><span lang=EN-GB>Account Closure Letter
Taken                                                             _____________                      
</span></p>

<p class=MsoHeader><span lang=EN-GB>ATM Card
Cancelled                                                                         
_____________                       </span></p>

<p class=MsoNormal><span lang=EN-GB>Credit Card
Cancelled                                                                         _____________                      
</span></p>

<p class=MsoNormal><span lang=EN-GB>NLC Charges – </span><span
lang=EN-GB>&nbsp;&nbsp;<input type="checkbox"> Hold</span><span lang=EN-GB> placed </span></p>

<p class=MsoNormal><span lang=EN-GB>                          </span><span lang=EN-GB>  </span><span lang=EN-GB><input type="checkbox">0010-850002-784 account credited
on               __ __/__ __/__________ </span></p>

<p class=MsoNormal><span lang=EN-GB>                          </span><span lang=EN-GB>  </span><span lang=EN-GB><input type="checkbox">Branch Manager
Approval                                 ____________________ </span></p>

</div>

</body>

</html>
