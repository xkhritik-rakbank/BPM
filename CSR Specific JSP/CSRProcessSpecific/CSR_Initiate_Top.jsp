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


<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
	<HEAD>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>
	</HEAD>

<%

	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessCode", request.getParameter("ProcessCode"), 1000, true) );
	String ProcessCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessCode);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessCode"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", request.getParameter("ProcessName"), 1000, true) );
	String ProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessName);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessName"));
	
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
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strCSMMailId", request.getParameter("strCSMMailId"), 1000, true) );
	String strCSMMailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: strCSMMailId: "+strCSMMailId);
	WriteLog("Integration jsp: strCSMMailId 1: "+request.getParameter("strCSMMailId"));
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strBMailId", request.getParameter("strBMailId"), 1000, true) );
	String strBMailId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: strBMailId: "+strBMailId);
	WriteLog("Integration jsp: strBMailId 1: "+request.getParameter("strBMailId"));
	
	//Get parameter values
	WriteLog("Inside CSR_Initiate_top.jsp");
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

<!-- <script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script> -->
<script language="javascript">

var strDateFormat="<%=DateFormat%>";

if (document.layers)
  document.captureEvents(Event.KEYDOWN);
document.onkeydown =
  function (evt) {
    var keyCode = evt ? (evt.which ? evt.which : evt.keyCode) : event.keyCode;
    if (keyCode == 13) {     
		validate();
        return false;
    }
    else
      return true;
  };


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
/*
		if(Trim(document.forms.dataform.txtAgreementNo.value)=="" && Trim(document.forms.dataform.txtEquationLoanAccNo.value)==""){
			alert("Please enter either Agreement No. or Equation Loan No.");
			document.forms.dataform.txtAgreementNo.focus();
			return false;
		}
		if(Trim(document.forms.dataform.txtAgreementNo.value).length!=8 ){
			alert("Agreement No. should be of length 8 digits.");
			document.forms.dataform.txtAgreementNo.focus();
			return false;
		}*/
		/*if(document.forms.dataform.txtEquationLoanAccNo.value==""){
			alert("Please enter Equation Account Loan No.");
			document.forms.dataform.txtEquationLoanAccNo.focus();
			return false;
		}*/
		/*var branchCtrl=window.document.forms.dataform.Branch;
		var branchCtrlSelectedIndex=branchCtrl.options[branchCtrl.selectedIndex];
		document.forms.dataform.BranchCodeName.value=branchCtrlSelectedIndex.value +"_"+branchCtrlSelectedIndex.text;*/
		/*document.forms.dataform.AgreementNo.value=document.forms.dataform.txtAgreementNo.value;
		document.forms.dataform.EquationLoanAccNo.value=document.forms.dataform.txtEquationLoanAccNo.value;
		document.forms.dataform.strMessage.style.display="inline";
		document.forms.dataform.submit();*/
		//----------------------------------------------------------------------------------------------------
		// Changed By						:	Manish K. Agrawal
		// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0028/RKB-RLS-ALS-CMA-0029)
		// Change Description				:	Disable Agreement/Eq Loan Non Button
		// Note:							:   After submit, disable them, Because disabled textbox values not submits to next form.
		//----------------------------------------------------------------------------------------------------

/*		document.forms.dataform.txtAgreementNo.disabled=true;
		document.forms.dataform.txtEquationLoanAccNo.disabled=true;
		document.forms.dataform.OK.disabled=true;*/		
		if(document.forms["dataform"].txtCreditCardNo.value=="")
		{
			alert("Credit Card No is Mandatory");
			document.forms["dataform"].txtCreditCardNo.focus();
			return false;
		}		
		regex=/^[0-9]{16}$/;
		if(regex.test(document.forms["dataform"].txtCreditCardNo.value))
		{
			//alert("Only Numerics are allowed in Credit Card No");

			var vCCN=document.forms["dataform"].txtCreditCardNo.value;
			document.forms["dataform"].txtCreditCardNo.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
			return false;
		}		

		regex=/^[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{4}$/;
		if(!regex.test(document.forms["dataform"].txtCreditCardNo.value))
		{
			alert("Invalid Credit Card No Format");
			document.forms["dataform"].txtCreditCardNo.value="";
			return false;
		}		
		regex=/^[0-9]{16}$/;
		
		if(!regex.test(replaceAll(document.forms["dataform"].txtCreditCardNo.value,"-","")))
		{
			alert("Length Of Credit Card No Should be exactly 16 digits.");
			document.forms["dataform"].txtCreditCardNo.value="";
			document.forms["dataform"].txtCreditCardNo.focus();
			return false;
		}		
		if(!mod10( replaceAll(document.forms["dataform"].txtCreditCardNo.value,"-","")))
		{
			alert("Invalid Credit Card No.");
			document.forms["dataform"].txtCreditCardNo.value="";
			document.forms["dataform"].txtCreditCardNo.focus();
			return false;
		}
		document.forms["dataform"].CreditCardNo.value=replaceAll(document.forms["dataform"].txtCreditCardNo.value,"-","");
		document.forms.dataform.submit();
		return true;
	}catch(e){
		alert(e.message);
	}
}
function replaceAll(data,searchfortxt,replacetxt)
{
	var startIndex=0;
	while(data.indexOf(searchfortxt)!=-1)
	{
		data=data.substring(startIndex,data.indexOf(searchfortxt))+data.substring(data.indexOf(searchfortxt)+1,data.length);
	}	
	return data;
}

function mod10( cardNumber ) 
{ 	
           var clen = new Array( cardNumber.length ); 
           var n = 0,sum = 0; 
           for( n = 0; n < cardNumber.length; ++n ) 
		      { 
                      clen [n] = parseInt ( cardNumber.charAt(n) ); 
			  } 
          for( n = clen.length -2; n >= 0; n-=2 ) 
				{
					  clen [n] *= 2; 	
			          if( clen [n] > 9 ) 
				          clen [n]-=9; 
				}

	     for( n = 0; n < clen.length; ++n ) 
		        { 
					  sum += clen [n]; 
		        } 
		 return(((sum%10)==0)?true : false);
}

function fetch()
{
	document.forms.dataform.strMessage.style.display="none";
	document.forms.dataform.OK.disabled=false;
}

function clearFrames(){
	try{
		window.parent.frames['frameProcess'].document.location.href="CSR_blank.jsp";
		window.parent.frames['frameClose'].document.location.href="CSR_blank.jsp";
	}catch(e){
		alert(e.message);
	}
}

function validateCCN(cntrl)
{
//	
	var keycode=event.keyCode;
	//var charcode=event.charCode
	var cntrlValue=cntrl.value;
//	var regex=/^[0-9]*$/;
/*if(keycode!=16)
	{
alert(keycode);
alert(charcode);
	}*/
//alert(eval('(keycode>=48&&keycode<=57)'));
	/*if(keycode!=8&&keycode!=9&&keycode!=46&&keycode!=37&&keycode!=39&&keycode!=35&&keycode!=13&&!(keycode>=96&&keycode<=105)&&!(keycode>=48&&keycode<=57))             //&&!(keycode==86)&&!(keycode==189))
	{
		alert("Only Numerics are allows in Credit Card No.");
		cntrl.value=cntrl.value.substring(0,cntrl.value.length-1);
		cntrl.focus();
		return false;
	}*/
	/*regex = /^([0-9]{4}|[0-9]{4}-|[0-9]{4}-[0-9]{4})$/;	
	for(i=0;i<cntrlValue.length;i++)
	{
		if()
	alert();
	}*/
/*
	if((keycode>=33&&keycode<=47)||(keycode>=58&&keycode<=126))             //&&!(keycode==86)&&!(keycode==189))
	{
		alert("Only Numerics are allows in Credit Card No.");
		cntrl.value="";
		cntrl.focus();
		return false;
	}*/

//	alert(keycode);
	if(keycode!=46&&keycode!=8&&(cntrlValue.length==4||cntrlValue.length==9||cntrlValue.length==14))
		cntrl.value=cntrlValue+"-";
	//return;
}

function validateCCNDataOnKeyUp(cntrl)
{

	var regex=/^[0-9]{16}$/;
		if(regex.test(document.forms["dataform"].txtCreditCardNo.value))
		{
			//alert("Only Numerics are allowed in Credit Card No");

			var vCCN=document.forms["dataform"].txtCreditCardNo.value;
			document.forms["dataform"].txtCreditCardNo.value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
			return false;
		}		

	var	regex = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;	

	var keycode=event.keyCode;
//	alert(keycode);
	if(!(keycode>95&&keycode<106)&&!(keycode>47&&keycode<58)&&keycode!=8&&keycode!=145&&keycode!=19&&keycode!=45&&keycode!=33&&keycode!=34&&keycode!=35&&keycode!=36&&keycode!=37&&keycode!=38&&keycode!=39&&keycode!=40&&keycode!=46&&cntrl.value!=""&&!regex.test(cntrl.value))
		{
		alert("Invalid Credit Card No. Format");
		cntrl.value="";
		cntrl.focus();
		return false;
		}		
}
 
</script>

<!----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' onload='clearFrames()'>
<form name="dataform" action="CSR_Initiate_center.jsp" target="frameProcess" method="post" > 
<table width=100% border=0>
	<tr width=100%>
		<td width=60% class="EWLargeLabel" align=right valign=center>Card Service Request Initiation Module</td>
		<td width=40% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif"></td>
	</tr>
</table>
<table border="1" cellspacing="1" cellpadding="1" width=98.4% >
	<TR class="EWHeader" width=100%>
		<td class="EWLabelRB2" colspan=1>&nbsp;&nbsp;Logged In As <b><%=suserName%></b></td>
		<td class="EWLabelRB2" align=right colspan=3>
		<%
			DateFormat dtFormat = new SimpleDateFormat(DateFormat + " hh:mm");
			String dateFormat = dtFormat.format(new java.util.Date());
			//out.println("<b>"+dateFormat+"</b>");
		%>
		<script>var jsToday="<%=new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date())%>";</script>
		</td>
	</tr>
	<tr>
		<td nowrap width="180" height="16" class="EWLabelRB">Branch Id</td>
		
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
		
		<td nowrap class="" colspan=3><b><%=strBranchName%></b>
		<script>var jsBranchName="<%=strBranchName%>"; </script>
		</td>

	</TR>	
	<TR>
		<td nowrap width="180" height="16" class="EWLabelRB">Service Type-Request Type</td>
		<td nowrap colspan=3><b><%=strProcessName%>(<%=strProcessCode%>)</b></td>
	</TR>		
	<TR>
        <td nowrap width="180" height="16" class="EWLabelRB">Credit Card No.</td>
        <td nowrap colspan=3><input type="text" name="txtCreditCardNo" onKeyUp="validateCCNDataOnKeyUp(this);"    
 onkeydown="validateCCN(this);" value='' size="20" maxlength=19 style='width:150px;'> &nbsp;&nbsp;&nbsp;&nbsp;<input name="REFRESH" type=button value="REFRESH" onclick="validate()" class="EWButtonRB" style='width:60px'></td>
	</tr>
	
</table>




<input type=hidden name="BranchCodeName" style="visibility:hidden" value=<%=strBranchCode%>>
<input type=hidden name="ProcessCode" style="visibility:hidden" value=<%=strProcessCode%>>
<input type=hidden name="ProcessName" style="visibility:hidden" value=<%=URLEncoder.encode(strProcessName,"UTF-8")%>>
<input type=hidden name="strCSMMailId" style="visibility:hidden" value=<%=strCSMMailId%>>
<input type=hidden name="strBMailId" style="visibility:hidden" value=<%=strBMailId%>>
<input type=hidden name="CreditCardNo" style="visibility:hidden" >
<input type=hidden name="EquationLoanAccNo" style="visibility:hidden" >
</form>


</body>
</html>