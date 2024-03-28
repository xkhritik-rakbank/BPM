<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : MQCode.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Contains common code of MQ Integration. It calls from Crops.jsp/Credit_Approver.jsp/Branch_Return.jsp
//------------------------------------------------------------------------------------------------------------------------------------>

<%@ page import="java.lang.String.*"%>

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
	//MQ Integration
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Refresh", request.getParameter("Refresh"), 1000, true) );
	String Refresh = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: Refresh: "+Refresh);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("AgreementNo", request.getParameter("AgreementNo"), 1000, true) );
	String AgreementNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: AgreementNo: "+AgreementNo);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("EqLoanAcNo", request.getParameter("EqLoanAcNo"), 1000, true) );
	String EqLoanAcNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: EqLoanAcNo: "+EqLoanAcNo);
	
	
	String strBranch ="", strCustName = "",strAppLoanAmt = "", strIntRate = "", strTenor = "", strLoanMaturityDate = "", strFundingACNo = "", strProductScheme = "", strOutstandingLoanAmount = "", strNextInstAmount = "", strNextInstallmentDate = "", strRepaymentMode = "",  strDelinquencyString = "", strNPAStage =  "", strInstallmentPastDues = "", strChargesPastDues = "", strTotalPastDues = "", strBucket = "";
	
String suserName = wDUserInfo.getM_strUserName()+"";

	//Execute only when refresh button clicked
	if(Refresh.equals("1")){	
		String strCompCode="",strReasonCode="";	
		//DateFormat dt = new SimpleDateFormat(DateFormat + " hh:mm:ss:SS");
		//String strDate = dt.format(new java.util.Date());
		
		//String msgID=wfsession.getUserName()+"_"+AgreementNo+"_"+strDate;	
		
		//msgID="supervisor_1223_14/09/2006 04:57:57:717";
		sInputXML =	"?xml version=\"1.0\"?>\n" +
		"<APAPMQPutGetMessage_Input>\n" +
		"<Option>APMQPutGetMessage</Option>\n" +
		"<UserID>"+suserName+"</UserID>";

		if (AgreementNo!="" && AgreementNo.length()!=0){
			sInputXML =	sInputXML + "<AgreementNo>"+AgreementNo+"</AgreementNo>";
		}else{
			sInputXML =	sInputXML + "<AgreementNo>"+EqLoanAcNo+"</AgreementNo>";
		}

		sInputXML =	sInputXML + "<SessionId>"+sSessionId+"</SessionId>\n"+
		"<EngineName>"+sCabname+"</EngineName>\n" +
		"</APAPMQPutGetMessage_Input>\n";

		WriteLog(sInputXML);
		String responseMsg="";
		try{
			responseMsg= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(responseMsg);	
				
			strCompCode	= responseMsg.substring(responseMsg.indexOf("<CompletionCode>")+16,responseMsg.indexOf("</CompletionCode>"));	
			strReasonCode= responseMsg.substring(responseMsg.indexOf("<ReasonCode>")+12,responseMsg.indexOf("</ReasonCode>"));
			if(!(strCompCode.equals("0")) || !(strReasonCode.equals("0")))
			{
				out.println("<table border='1' cellspacing='1' cellpadding='1' width=100% >");
				out.println("<TR>");
				out.println("<td width=20% height='16' ><b><font color='red'>Error Codes:</font></B></td>");		
				out.println("<td width=50% height='16' ><b><font color='red'>Completion Code:"+strCompCode+"</font></B></td>");
				out.println("<td width=30% height='16' ><b><font color='red'>Reason Code:"+strReasonCode+"</font></B></td>");
				out.println("</tr>");
				out.println("<TR>");
				out.println("<td width=20% height='16' ><b><font color='red'>Error Description:</font></B></td>");		
				out.println("<td width=50% height='16' ><b><font color='red'>&nbsp;"+responseMsg.substring(responseMsg.indexOf("<Description>")+13,responseMsg.indexOf("</Description>"))+"</font></B></td>");
				out.println("<td width=30% height='16'><b><font color='red'>&nbsp;"+responseMsg.substring(responseMsg.indexOf("<ErrorMessageReasonCode>")+24,responseMsg.indexOf("</ErrorMessageReasonCode>"))+"</font></B></td>");
				out.println("</tr>");
				out.println("</table>");				
			}
		}
		catch(Exception exp){
			WriteLog("MQ Error:"+exp.toString());		
		}
		WriteLog("Output XML:"+responseMsg);


		try{
			if(strCompCode.equals("0") && strReasonCode.equals("0")){
				//strBranch = responseMsg.substring(responseMsg.indexOf("<Branch>")+8,responseMsg.indexOf("</Branch>"));
				strCustName = responseMsg.substring(responseMsg.indexOf("<APPLICANTNAME>")+15,responseMsg.indexOf("</APPLICANTNAME>"));
				strAppLoanAmt = responseMsg.substring(responseMsg.indexOf("<REQUESTEDLNAMT>")+16,responseMsg.indexOf("</REQUESTEDLNAMT>"));
				strIntRate = responseMsg.substring(responseMsg.indexOf("<INTERESTRATE>")+14,responseMsg.indexOf("</INTERESTRATE>"));
				strTenor = responseMsg.substring(responseMsg.indexOf("<TENOR>")+7,responseMsg.indexOf("</TENOR>"));
				strLoanMaturityDate = responseMsg.substring(responseMsg.indexOf("<LOANMATURITYDATE>")+18,responseMsg.indexOf("</LOANMATURITYDATE>"));
				strFundingACNo = responseMsg.substring(responseMsg.indexOf("<FUNDINGACCOUNT>")+16,responseMsg.indexOf("</FUNDINGACCOUNT>"));
				strProductScheme = responseMsg.substring(responseMsg.indexOf("<SCHEMEDESC>")+12,responseMsg.indexOf("</SCHEMEDESC>")); // RLS changes-2 ---- 23-oct-2007  -------  by sachin arora    mapping with SCHEMEDESC instead of PRODUCTCODE
				strOutstandingLoanAmount = responseMsg.substring(responseMsg.indexOf("<UNMATUREDPRINCIPAL>")+20,responseMsg.indexOf("</UNMATUREDPRINCIPAL>"));
				strNextInstAmount = responseMsg.substring(responseMsg.indexOf("<NEXTINSTLAMT>")+14,responseMsg.indexOf("</NEXTINSTLAMT>"));
				strNextInstallmentDate = responseMsg.substring(responseMsg.indexOf("<NEXTINSTLDATE>")+15,responseMsg.indexOf("</NEXTINSTLDATE>"));
				strRepaymentMode = responseMsg.substring(responseMsg.indexOf("<REPAYMENTMODE>")+15,responseMsg.indexOf("</REPAYMENTMODE>"));
				strDelinquencyString ="";
		//		strDelinquencyString = responseMsg.substring(responseMsg.indexOf("<DelinquencyString>")+19,responseMsg.indexOf("</DelinquencyString>"));
				strNPAStage = "";
				//strNPAStage = responseMsg.substring(responseMsg.indexOf("<NPAStage>")+10,responseMsg.indexOf("</NPAStage>"));
				//strInstallmentPastDues = "";
				//strInstallmentPastDues = responseMsg.substring(responseMsg.indexOf("<InstallmentPastDues>")+21,responseMsg.indexOf("</InstallmentPastDues>"));
				strChargesPastDues = "";
				//strChargesPastDues = responseMsg.substring(responseMsg.indexOf("<ChargesPastDues>")+17,responseMsg.indexOf("</ChargesPastDues>"));
				//-------------------------------------------------------
				try{
					//strChargesPastDues = Float.toString(Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PENALTY_LPI_LEVIED>")+20,responseMsg.indexOf("</PENALTY_LPI_LEVIED>"))) - Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PENALTYRECEIVED>")+17,responseMsg.indexOf("</PENALTYRECEIVED>"))) + Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<TOTALRECEIVABLECHARGES>")+24,responseMsg.indexOf("</TOTALRECEIVABLECHARGES>"))) -		Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<TOTALAMTRECVDAGNSTCHRGS>")+25,responseMsg.indexOf("</TOTALAMTRECVDAGNSTCHRGS>"))));
					DecimalFormat ab =new DecimalFormat("0.00");
					strChargesPastDues = ab.format(Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PENALTY_LPI_LEVIED>")+20,responseMsg.indexOf("</PENALTY_LPI_LEVIED>"))) - Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PENALTYRECEIVED>")+17,responseMsg.indexOf("</PENALTYRECEIVED>"))) + Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<TOTALRECEIVABLECHARGES>")+24,responseMsg.indexOf("</TOTALRECEIVABLECHARGES>"))) -	Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<TOTALAMTRECVDAGNSTCHRGS>")+25,responseMsg.indexOf("</TOTALAMTRECVDAGNSTCHRGS>"))));
					WriteLog("strChargesPastDues: "+ strChargesPastDues);
				}catch(Exception e){
					WriteLog("strChargesPastDues: "+ e.toString());
				}
				strTotalPastDues = "";
				//strTotalPastDues = responseMsg.substring(responseMsg.indexOf("<TotalPastDues>")+15,responseMsg.indexOf("</TotalPastDues>"));
				try{
					//strTotalPastDues = Float.toString(Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<MATUREDPRINCIPAL>")+18,responseMsg.indexOf("</MATUREDPRINCIPAL>"))) - Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PRINCIPALPAID>")+15,responseMsg.indexOf("</PRINCIPALPAID>"))) + Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<MATUREDINTEREST>")+17,responseMsg.indexOf("</MATUREDINTEREST>"))) -		Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<INTERESTPAID>")+14,responseMsg.indexOf("</INTERESTPAID>"))));
                   DecimalFormat ab2 =new DecimalFormat("0.00");
                   strTotalPastDues = ab2.format(Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<MATUREDPRINCIPAL>")+18,responseMsg.indexOf("</MATUREDPRINCIPAL>"))) - Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PRINCIPALPAID>")+15,responseMsg.indexOf("</PRINCIPALPAID>"))) + Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<MATUREDINTEREST>")+17,responseMsg.indexOf("</MATUREDINTEREST>"))) -	Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<INTERESTPAID>")+14,responseMsg.indexOf("</INTERESTPAID>"))));
  				   WriteLog("ZZ_strTotalPastDues: "+ strTotalPastDues);
				}catch(Exception e){
					WriteLog("strTotalPastDues: "+ e.toString());
				}
				strBucket = responseMsg.substring(responseMsg.indexOf("<BUCKET>")+8,responseMsg.indexOf("</BUCKET>"));
			}
		}catch(Exception e)	
		{
		
		}
	}
%>


<TABLE border="1" cellspacing="1" cellpadding="1" id="loanDetails" width=100%>
	<tr class="EWHeader" >
		<td colspan=6 align=left class="EWLabelRB3" width=100%>
			<b>Loan Details</b>
		</td>
	</tr>	

	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22">Customer Name</td>
		<td nowrap width="140" height="22"><input type="text" name="CUSTOMERNAME" size="24" id="T" maxlength="300"  readOnly class="disb" value="<%=strCustName%>" ></td>
		<td class="EWLabelRB2" nowrap width="140" height="22">Product/Scheme</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="PRODUCTORSCHEME" size="24"  maxlength="8"  id="T" readOnly value="<%=strProductScheme%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22">NPA Stage</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="NPASTAGE" size="24"  maxlength="256" id="T" readOnly value="<%=strNPAStage%>" ></td>
	</tr>
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22">Approved Loan Amount</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="APPLOANAMT" size="24" maxlength="8"  id="T" readOnly value="<%=strAppLoanAmt%>"></td>

		<input  type="text" name="APPLOANAMT1" size="24" maxlength="8"  id="T" style='display:none' value="<%=strAppLoanAmt%>">                                                       

		<td class="EWLabelRB2" nowrap width="140" height="22">Outstanding Loan Amount</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="OUTSTANDINGLOANAMT" size="24" maxlength="22" id="T" readOnly value="<%=strOutstandingLoanAmount%>"></td>

        <input type="text" name="OUTSTANDINGLOANAMT1" size="24" maxlength="22" id="T" style='display:none' value="<%=strOutstandingLoanAmount%>">


		<!--<td class="EWLabelRB2" nowrap width="140" height="22">Installment Pastdues</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="INSTPastdues" size="24" id="T" readOnly></td>-->
		<td class="EWLabelRB2" nowrap width="140" height="22">Interest Rate</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="INTERESTRATE" size="24"  maxlength="12"  id="T" readOnly value="<%=strIntRate%>"></td>
	</tr>
	<tr>
		<td  nowrap width="140" height="22" class="EWLabelRB2">Next Inst. Amount</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="NEXTINSTAMT" size="24" maxlength="22"  id="T" readOnly value="<%=strNextInstAmount%>"></td>
        <input  type="text" name="NEXTINSTAMT1" size="24" maxlength="22"  id="T" style='display:none' value="<%=strNextInstAmount%>"> 

		<td class="EWLabelRB2" nowrap width="140" height="22">Charges Pastdues</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="CHARGESPastdues" size="24" maxlength="256" id="T" readOnly value="<%=strChargesPastDues%>"> </td>
        
		<input  type="text" name="CHARGESPastdues1" size="24" maxlength="256" id="T" style='display:none' value="<%=strChargesPastDues%>"> 

		<td class="EWLabelRB2" nowrap width="140" height="22">Tenor</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="TENOR" size="24"  maxlength="3"  id="T" readOnly value="<%=strTenor%>"></td>
	</tr>
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22">Next Installment Date</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="NEXTINSTDATE" size="24" maxlength="10"  id="D" readOnly value="<%=strNextInstallmentDate%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22">Total Pastdues</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="TOTALPastdues" size="24" maxlength="256"  id="T" readOnly value="<%=strTotalPastDues%>"></td>
		<input type="text" name="TOTALPastdues1" size="24" maxlength="256"  id="T" style='display:none' value="<%=strTotalPastDues%>">
		<!--------------- hidden fields for amount comma change   rakbak changes 04/07/2007-->

		<td class="EWLabelRB2" nowrap width="140" height="22">Loan Maturity Date</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="LOANMATURITYDATE" size="24"  maxlength="10" id="D" readOnly value="<%=strLoanMaturityDate%>"></td>
	</tr>
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22">Repayment Mode</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="REPAYMENTMODE" size="24"  maxlength="12" id="T" readOnly value="<%=strRepaymentMode%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22">Bucket</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="BUCKET" size="24"  maxlength="3"  id="T" readOnly value="<%=strBucket%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22">Funding A/C No.</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="FUNDINGACNO" size="24"  maxlength="15" id="T" readOnly value="<%=strFundingACNo%>"></td>
	</tr>
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22">Delinquency String</td>
		<td nowrap width="140" height="22"><input class="disb" type="text" name="DELINQUENCY" size="24"  maxlength="256"  id="T" readOnly value="<%=strDelinquencyString%>"></td>
		<td  nowrap width="140" height="20">&nbsp;</td>
		<td nowrap width="140" height="20">&nbsp;</td>
		<td nowrap width="140" height="20">&nbsp;</td>
		<td nowrap width="140" height="20">&nbsp;</td>
	</tr>
</table>
<script>
// rakbank changes 04/07/2007
dollarAmount(document.forms[0].APPLOANAMT1);
dollarAmount(document.forms[0].OUTSTANDINGLOANAMT1);
dollarAmount(document.forms[0].NEXTINSTAMT1);
dollarAmount(document.forms[0].CHARGESPastdues1);
dollarAmount(document.forms[0].TOTALPastdues1);



</script>

