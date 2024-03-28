<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : initiate_Top.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 13-Oct-2006
//Description                : Takes input from user-Agreement No/Loan Eq No.
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 24-11-2006	 Manish K. Agrawal		Restrict user to introduce WI from Work_Introduction Queue(RKB-RLS-ALS-CMA-0004)
// 24-11-2006	 Manish K. Agrawal		Got/Lost Focus(RKB-RLS-ALS-CMA-0010)
// 24-11-2006	 Manish K. Agrawal		Disable agreement/eq Loan No text box(RKB-RLS-ALS-CMA-0028/RKB-RLS-ALS-CMA-0029)
// 28-11-2006	 Manish K. Agrawal		Disable Backspace button(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)

//----------------------------------------------------------------------------------------------------
//
//---------------------------------------------------------------------------------------------------->


<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="com.newgen.wfdesktop.util.AESEncryption"%>
<%@page import="com.newgen.wfdesktop.cabinet.WDCabinetList"%>
<%@page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@page import="com.newgen.wfdesktop.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.newgen.wfdesktop.baseclasses.PMSInfo"%>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.LinkedHashMap,com.newgen.mvcbeans.controller.helper.*,com.newgen.wfdesktop.util.WDUtility"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>


<HTML>
	<HEAD>

		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>

	</HEAD>

<%
	//Get parameter values
	
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessCode", request.getParameter("ProcessCode"), 1000, true) );
	String ProcessCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessCode);
	//WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessCode"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", request.getParameter("ProcessName"), 1000, true) );
	String ProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessName);
	//WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessName"));
	
	String URLDecoderBranchCode = URLDecoder.decode(request.getParameter("BranchCode"));
	WriteLog("Integration jsp: BranchCode 4: ESAPI "+URLDecoderBranchCode);
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchCode", URLDecoderBranchCode, 1000, true) );
	WriteLog("Integration jsp: URLDecoderBranchCode 1: ESAPI"+input3);
	String DecoderBranchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: DecoderBranchCode: "+DecoderBranchCode);
	
	String URLDecoderBranchName = URLDecoder.decode(request.getParameter("BranchName"));
	WriteLog("Integration jsp: BranchName 4: ESAPI "+URLDecoderBranchName);
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchName", URLDecoderBranchName, 1000, true) );
	WriteLog("Integration jsp: URLDecoderBranchName 1: ESAPI"+input4);
	String DecoderBranchName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	DecoderBranchName=DecoderBranchName.replace("&#x7e;","~");
	WriteLog("Integration jsp: DecoderBranchName: "+DecoderBranchName);
	
	String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strCSMMailId", request.getParameter("strCSMMailId"), 1000, true) );
	String strCSMMailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
	WriteLog("Integration jsp: strCSMMailId: "+strCSMMailId);
	
	String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strBMailId", request.getParameter("strBMailId"), 1000, true) );
	String strBMailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
	WriteLog("Integration jsp: strBMailId: "+strBMailId);
	
	String strBranchCode=DecoderBranchCode;
	WriteLog("strBranchCode :"+strBranchCode);
	String StrBrCode="";
	String strBranchName=DecoderBranchName;
	WriteLog("strBranchName :"+strBranchName);
	String strProcessCode=ProcessCode;
	String strProcessName=ProcessName;
	//String strCSMMailId=request.getParameter("strCSMMailId");
	//String strBMailId=request.getParameter("strBMailId");
	WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
	String suserName = wDUserInfo.getM_strUserName()+"";
//out.println(strBranchCode);

%>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="javascript">

var strDateFormat="<%=DateFormat%>";

//----------------------------------------------------------------------------------------------------
//Function Name                    : validate()
//Date Written (DD/MM/YYYY)        : 13-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Mandatory check on AgreementNo/txtAgreementNo.
//----------------------------------------------------------------------------------------------------

function validate()
{
	try{
	
	  // ---	changed for rakbank change document dated 3-jun
	  /*if(window.document.forms.dataform.Branch.options[window.document.forms.dataform.Branch.selectedIndex].value==""){
			alert("Branch is mandatory.");
			document.forms.dataform.Branch.focus();
			return false;
		}*/

		if(Trim(document.forms.dataform.txtAgreementNo.value)=="" && Trim(document.forms.dataform.txtEquationLoanAccNo.value)==""){
			alert("Please enter either Agreement No. or Equation Loan No.");
			document.forms.dataform.txtAgreementNo.focus();
			return false;
		}
		if(Trim(document.forms.dataform.txtAgreementNo.value).length!=8 ){
			alert("Agreement No. should be of length 8 digits.");
			document.forms.dataform.txtAgreementNo.focus();
			return false;
		}
		/*if(document.forms.dataform.txtEquationLoanAccNo.value==""){
			alert("Please enter Equation Account Loan No.");
			document.forms.dataform.txtEquationLoanAccNo.focus();
			return false;
		}*/
		/*var branchCtrl=window.document.forms.dataform.Branch;
		var branchCtrlSelectedIndex=branchCtrl.options[branchCtrl.selectedIndex];
		document.forms.dataform.BranchCodeName.value=branchCtrlSelectedIndex.value +"_"+branchCtrlSelectedIndex.text;*/
		document.forms.dataform.AgreementNo.value=document.forms.dataform.txtAgreementNo.value;
		document.forms.dataform.EquationLoanAccNo.value=document.forms.dataform.txtEquationLoanAccNo.value;
		document.forms.dataform.strMessage.style.display="inline";
		document.forms.dataform.submit();
		//----------------------------------------------------------------------------------------------------
		// Changed By						:	Manish K. Agrawal
		// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0028/RKB-RLS-ALS-CMA-0029)
		// Change Description				:	Disable Agreement/Eq Loan Non Button
		// Note:							:   After submit, disable them, Because disabled textbox values not submits to next form.
		//----------------------------------------------------------------------------------------------------

		document.forms.dataform.txtAgreementNo.disabled=true;
		document.forms.dataform.txtEquationLoanAccNo.disabled=true;
		document.forms.dataform.OK.disabled=true;

	}catch(e){
		alert(e.message);
	}
}
function fetch()
{
	document.forms.dataform.strMessage.style.display="none";
	document.forms.dataform.OK.disabled=false;
}

function clearFrames(){
	try{
		window.parent.frames['frameProcess'].document.location.href="blank.jsp";
		window.parent.frames['frameClose'].document.location.href="blank.jsp";
	}catch(e){
		alert(e.message);
	}
}
 
</script>

<!----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' onkeydown='checkShortcut()' onload='clearFrames()'>
<form name="dataform" action="Initiate_center.jsp" target="frameProcess" method="post" > 
<table width=100% border=0>
	<tr width=100%>
		<td width=60% class="EWLargeLabel" align=right valign=center>Service Request Initiation Module</td>
		<td width=40% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif"></td>
	</tr>
</table>
<table border="1" cellspacing="1" cellpadding="1" width=98.4% >
	<TR class="EWHeader" width=100%>
		<td class="EWLabelRB2" colspan=1>&nbsp;&nbsp;Logged In As <b><%=suserName%></b></td>
		<td class="EWLabelRB2" align=right>
		<%
			DateFormat dtFormat = new SimpleDateFormat(DateFormat + " hh:mm");
			String dateFormat = dtFormat.format(new java.util.Date());
			out.println("<b>"+dateFormat+"</b>");
		%>
		<script>var jsToday="<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>";</script>
		</td>
	</tr>
	<tr>
		<td nowrap width="180" height="16" class="EWLabelRB">Branch</td>
		
	<!--	<select name="Branch" >
		<option value="">----select----</option> -->
		<%
		StringTokenizer stk=new StringTokenizer(strBranchName,"~");
		StringTokenizer stk2=new StringTokenizer(strBranchCode,"~");
		while (stk.hasMoreElements()&&stk2.hasMoreElements()){
			//out.println("<option value=\""+stk2.nextElement()+"\">"+stk.nextElement()+"</option>");
			strBranchName=(String)stk.nextElement();
            strBranchCode=(String)stk2.nextElement();
			}

		%>		
		<!--</select>-->
		
		<td nowrap class=""><b><%=strBranchName%></b>
		<script>var jsBranchName="<%=strBranchName%>"; </script>
		</td>
	
	</TR>
	<TR>
		<td nowrap width="180" height="16" class="EWLabelRB">Service Type-Request Type</td>
		<td nowrap><b><%=strProcessName%>(<%=strProcessCode%>)</b></td>
	</TR>		
	<TR>
        <td nowrap width="180" height="16" class="EWLabelRB">Agreement No.</td>
        <td nowrap><input type="text" name="txtAgreementNo" value='' size="24" maxlength=8 style='width:240px;' onKeyUp=validateKeys(this,'numeric') onblur=validateKeys_OnBlur(this,'numeric')></td>
	</tr>
	<tr>
		<td nowrap width="180" height="16" class="EWLabelRB">Equation Loan Account No.</td>
        <td nowrap><input type="text" name="txtEquationLoanAccNo" size="24" value='' maxlength=15  style='width:240px;' onKeyUp=validateKeys(this,'dashdigitsOnly')  disabled onblur=validateKeys_OnBlur(this,'dashdigitsOnly')></td>
	</tr>   <!-- RLS changes-2--- disable equation loan 23-oct-2007 Sachin Arora-->
	<tr width=100%>
		<td>&nbsp;</td>
		<td width="442" height="16"><input name="OK" type=button value="OK" onclick='validate()' class="EWButtonRB" style='width:60px'>
			<input type=button name="Cancel"  value="Cancel" onclick='window.parent.top.close();' class="EWButtonRB" style='width:60px'>
			<input type="label" name="strMessage" size=40 value="Please wait, Retrieving loan details..." style='display:none;border:none;background-color:#FFFBF0;font:bold;color:blue'  >
		</td>	
	</tr>
	
</table>

<input type=hidden name="BranchCodeName" style="visibility:hidden" value="<%=strBranchCode%>+ '_'+ <%=strBranchName%>">
<input type=hidden name="ProcessCode" style="visibility:hidden" value=<%=strProcessCode%>>
<input type=hidden name="ProcessName" style="visibility:hidden" value=<%=URLEncoder.encode(strProcessName,"UTF-8")%>>
<input type=hidden name="strCSMMailId" style="visibility:hidden" value=<%=strCSMMailId%>>
<input type=hidden name="strBMailId" style="visibility:hidden" value=<%=strBMailId%>>
<input type=hidden name="AgreementNo" style="visibility:hidden" >
<input type=hidden name="EquationLoanAccNo" style="visibility:hidden" >

</form>


</body>
</html>