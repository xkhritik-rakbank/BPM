<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : initiate_center.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Display Loan/Request Detail sections dynamically.
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 24-11-2006	 Manish K. Agrawal		Lost/Got Focus Problem(RKB-RLS-ALS-CMA-0010/RKB-RLS-ALS-CMA-0011)
// 28-11-2006	 Manish K. Agrawal		Disable Backspace button(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// 28-11-2006	 Manish K. Agrawal		Session Expires, Handling(RKB-RLS-ALS-CMA-0054/RKB-RLS-ALS-CMA-0055/RKB-RLS-ALS-CMA-0056/RKB-RLS-ALS-CMA-0057/RKB-RLS-ALS-CMA-0058)
// 28-11-2006	 Manish K. Agrawal		Validation (RKB-RLS-ALS-CMA-0065/RKB-RLS-ALS-CMA-0067/RKB-RLS-ALS-CMA-0069/RKB-RLS-ALS-CMA-0071/RKB-RLS-ALS-CMA-0073/RKB-RLS-ALS-CMA-0077/RKB-RLS-ALS-CMA-0078) 
// 30-11-2006	 Manish K. Agrawal		Minimizing the window.(RKB-RLS-ALS-CMA-0083/RKB-RLS-ALS-CMA-0104)
// 30-11-2006	 Manish K. Agrawal		Session handling.(RKB-RLS-ALS-CMA-0084/RKB-RLS-ALS-CMA-0085)
// 05-12-2006	 Manish K. Agrawal		Charge Amt should be default to 0.(RKB-RLS-ALS-CRF-0005)
// 05-12-2006	 Manish K. Agrawal		Debit Account is conditionally mandatory.(RKB-RLS-ALS-CRF-0007)
// 05-12-2006	 Manish K. Agrawal		PDC's...field is non mandatory.(RKB-RLS-ALS-CRF-0008/RKB-RLS-PL-CLD-0001/RKB-RLS-PL-CLD-0002)
// 05-12-2006	 Manish K. Agrawal		validation on No.of cheques.(RKB-RLS-ALS-CRF-0021)
// 05-12-2006	 Manish K. Agrawal		Format of No.of cheques.(RKB-RLS-ALS-CRF-0002)
// 07-12-2006	 Manish K. Agrawal		Notes field.(RKB-RLS-ALS-CRF-0010)
// 20-12-2006	 Manish K. Agrawal		Notes field.(RKB-RLS-GSR-LCOL-0001)
// 26-12-2006	 Manish K. Agrawal		Debit acc is mandatory only if mode=ac acredit.(RKB-RLS-PL-PD-0002)
// 26-12-2006	 Manish K. Agrawal		Debit acc is mandatory only if mode=ac acredit.(RKB-RLS-PL-PD-0011)
// 22-02-2006	 Manish K. Agrawal		Payment Mode picklist shows A/C Credit instead of A/C Debit, it should be A/C Debit as per FSD. (RLS-OF_Defect_AL_PD_C1_07.xls)
// 24-02-2006	 Manish K. Agrawal		Clear All button clears Next Installment Date & Loan Maturity Date along with the Request details field values.(RLS-OF_Defect_AL_PD_C1_26.xls)
// 1-03-2006	 Manish K. Agrawal		The validation in FS says "· If Payment for Security is “RAKBANK Salaried Guarantor” then Input of Account of Salaried Guarantor is mandatory". Whereas it doesn’t ask for that, it just asks for the name of the Guarantor in the message box to fill in the field "RAKBank Salaried Guarantor". (RLS-OF_Defect_AL_TRL_C1_01.xls)
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<!--<%@page import="com.newgen.wfdesktop.util.AESEncryption"%>-->
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<%@page import="java.io.*"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>

<%@page import="java.io.DataInputStream"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="com.ibm.mq.MQMessage"%>
<%@page import="java.net.*"%>
<%@page import="java.io.InputStream"%>

<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>


<!--File contains function for reading dateformat from webdesktop.ini-->
<%@ include file="/CustomForms/RAKBANK/CommonJsp.jsp"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
	<HEAD>

		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>

	</HEAD>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/RBCommon.js"></script>
<script language="JavaScript" src="/webdesktop/webtop/scripts/calendar1.js"></script>

<%
	//Get parameter values
	
	String URLDecoderBranchCodeName=URLDecoder.decode(request.getParameter("BranchCodeName"));
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchCodeName", URLDecoderBranchCodeName, 1000, true) );
	String DecoderBranchCodeName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	
	String URLDecoderProcessCode=URLDecoder.decode(request.getParameter("ProcessCode"));
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessCode", URLDecoderProcessCode, 1000, true) );
	String DecoderProcessCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	
	String URLDecoderProcessName=URLDecoder.decode(request.getParameter("ProcessName"));
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderProcessName, 1000, true) );
	String DecoderProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("AgreementNo", request.getParameter("AgreementNo"), 1000, true) );
	String AgreementNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: AgreementNo: "+AgreementNo);
	//WriteLog("Integration jsp: AgreementNo 1: "+request.getParameter("AgreementNo"));
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("EquationLoanAccNo", request.getParameter("EquationLoanAccNo"), 1000, true) );
	String EquationLoanAccNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: EquationLoanAccNo: "+AgreementNo);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Branch", request.getParameter("Branch"), 1000, true) );
	String Branch = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("Integration jsp: Branch: "+Branch);
	
	String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strCSMMailId", request.getParameter("strCSMMailId"), 1000, true) );
	String strCSMMailId_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
	WriteLog("Integration jsp: strCSMMailId: "+strCSMMailId_1);
	
	String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("strBMailId", request.getParameter("strBMailId"), 1000, true) );
	String strBMailId_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
	WriteLog("Integration jsp: strBMailId: "+strBMailId_1);
	
	String strBranchCode="", strBranchName="", Temp="",strProcessCode="", strProcessName="",strAgrNo="", strEqLoanACNo="",strCSMMailId="",strBMailId="";
	int len=0;
	Temp=DecoderBranchCodeName;
	if(Temp.indexOf("_") != -1)
	{
	strBranchCode=Temp.substring(0,Temp.indexOf("_"));
	len=Temp.length()-strBranchCode.length();
	strBranchName=Temp.substring(Temp.indexOf("_")+1,Temp.length());
	}

	strProcessCode=DecoderProcessCode;
	strProcessName=DecoderProcessName;
	strAgrNo=AgreementNo;
	strEqLoanACNo=EquationLoanAccNo;

	strCSMMailId=strCSMMailId_1;
	strBMailId=strBMailId_1;
	
	//DateFormat dtFormat = new SimpleDateFormat( DateFormat+ " hh:mm:ss");
	DateFormat dtFormat = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss");
	String dateFormat = dtFormat.format(new java.util.Date());
%>

<script language="javascript">

	var strDateFormat="dd/MM/yyyy";
	//var strDateFormat="<%=DateFormat%>";
	window.parent.top.resizeTo(window.screen.availWidth,window.screen.availHeight);
	window.parent.top.moveTo(0,0);
	try{
		window.parent.frames['frameClose'].document.location.href="initiate_bottom.jsp";
	}catch(e){
		alert(e.message);
	}

//----------------------------------------------------------------------------------------------------
//Function Name                    : initialise(TxtboxInputID)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : Textbox as object
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : returns date.
//----------------------------------------------------------------------------------------------------

function initialise(TxtboxInputID)
{	
	document.getElementById(TxtboxInputID).value='';
	var cal1 = new calendar1(document.getElementById(TxtboxInputID));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();						
	return true;
}

function maxlengthchk(e){
	var i = e.maxlength;
	//alert(i);
	//alert(e.value.length);
	if (e.value.length>i){
	e.value = e.value.substring(0,i-1);
	}
}


function enableDisableCombo(){               //sachin arora to disable combo

	var objDataForm=document.forms["dataform"];

	if (objDataForm.ServiceType.options[objDataForm.ServiceType.selectedIndex].value.toUpperCase()=='ADVANCE REPAYMENT'){
		
	    if(document.forms.dataform.ModeOfPayment.value=='A/C Debit')
			{
            document.forms.dataform.DebitAccount.disabled = false ; 
			} else{	
			document.forms.dataform.DebitAccount.value='';	
            document.forms.dataform.DebitAccount.disabled = true ; 
			}

		objDataForm.LoanRestructure.selectedIndex=0;
		objDataForm.LoanRestructure.disabled=true;
        objDataForm.ChargesReceived.value='0';
		objDataForm.NoOfInstallments.disabled=false;
        
		objDataForm.ChargesReceived.disabled=true;
		window.parent.frames['frameClose'].document.forms[0].Print.disabled=true;
	}
	else if(objDataForm.ServiceType.options[objDataForm.ServiceType.selectedIndex].value.toUpperCase()=='PART SETTLEMENT') {
		document.forms.dataform.DebitAccount.disabled = false ; 
		objDataForm.ChargesReceived.disabled=false;
		objDataForm.LoanRestructure.disabled=false;
		objDataForm.NoOfInstallments.value='';
		objDataForm.NoOfInstallments.disabled=true;
        objDataForm.LoanRestructure.selectedIndex=1;
		window.parent.frames['frameClose'].document.forms[0].Print.disabled=false;

	}
}

//----------------------------------------------------------------------------------------------------
//Function Name                    : setValue(object)
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : Combobox as object
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : initializes and alerting user to enter mandatory values.
//----------------------------------------------------------------------------------------------------

function setValue(obj){
	try{
		
		if (obj.name=='ModeOfPayment') {
         //alert(document.forms.dataform.ServiceType.value);
			if (obj.value=='A/C Debit'){
			 if((document.forms.dataform.ProcessCode.value=='PL_PS' && document.forms.dataform.ServiceType.value=='Advance Repayment') || (document.forms.dataform.ProcessCode.value=='PL_ES') || (document.forms.dataform.ProcessCode.value=='PL_PD'))
			{
              document.forms.dataform.DebitAccount.disabled = false ; 
			  var debitAcc = document.forms.dataform.FundingACNo.value;
				if(debitAcc.length!=0 && debitAcc.length==13){
					debitAcc = debitAcc.substring(0,4)+"-"+debitAcc.substring(4,10)+"-"+debitAcc.substring(10);
				}
				document.forms.dataform.DebitAccount.value =debitAcc;

			}
				
				document.forms.dataform.DebitAccount.value =document.forms.dataform.FundingACNo.value;		
			}else{
				
		if((document.forms.dataform.ProcessCode.value=='PL_PS' && document.forms.dataform.ServiceType.value=='Advance Repayment') || (document.forms.dataform.ProcessCode.value=='PL_ES') || (document.forms.dataform.ProcessCode.value=='PL_PD') )
			{
			
             document.forms.dataform.DebitAccount.disabled = true ; 
			}
				document.forms.dataform.DebitAccount.value = '' ;		
			}
		}
	}catch(e){
		//keep silence
	}
	try{ //For AL_CVD
		if (obj.name=='MDPAY'){
			if (obj.value=='A/C Debit'){
				document.forms.dataform.DebitAccount_ForCharge.value =document.forms.dataform.FundingACNo.value;		
			}else{
				document.forms.dataform.DebitAccount_ForCharge.value = '' ;		
			}
		}
	}catch(e){
		//keep silence
	}
	try{ //For AL_TRL
		if (obj.name=='PAYMOD'){
			if (obj.value=='A/C Debit'){
				document.forms.dataform.DBTACCCHRG.value =document.forms.dataform.FundingACNo.value;	
				//document.forms.dataform.RBGUA.value =document.forms.dataform.FundingACNo.value;	
	
			}else{
				document.forms.dataform.DBTACCCHRG.value = '' ;		
//				document.forms.dataform.RBGUA.value = '' ;		
			}
		}
	}catch(e){
		//keep silence
	}
	try{ //For AL_RTRL
		if (obj.name=='RepaymentModeFrom'){
			if (obj.value=='A/C Credit'){
				document.forms.dataform.AcToCredit.value =document.forms.dataform.FundingACNo.value;		
			}else{
				document.forms.dataform.AcToCredit.value = '' ;		
			}
		}
	}catch(e){
		//keep silence
	}
	try{ //For AL_RSD
		if (obj.name=='RepaymentModeFrom'){
			if (obj.value=='A/C Credit'){
				document.forms.dataform.AccountNo.value =document.forms.dataform.FundingACNo.value;		
			}else{
				document.forms.dataform.AccountNo.value = '' ;		
			}
		}
	}catch(e){
		//keep silence
	}
	try{ //For AL_RSD
		if (obj.name=='MDPAY'){
			if (obj.value=='A/C Debit'){
				document.forms.dataform.DBTACC.value =document.forms.dataform.FundingACNo.value;		
			}else{
				document.forms.dataform.DBTACC.value = '' ;		
			}
		}
	}catch(e){
		//keep silence
	}
	// RLS changes-2, Date:29/10/2007, By: Piyush Kumar
	try{
		
		if (obj.name=='CHARGESTOBERECFROM') {
         //alert(document.forms.dataform.ServiceType.value);
			if (obj.value=='A/C Debit'){
			 if(document.forms.dataform.ProcessCode.value=='GSR_LCOL')
			{
              document.forms.dataform.DebitAccount.disabled = false ; 
			}
				var debitAcc = document.forms.dataform.FundingACNo.value;
				if(debitAcc.length!=0 && debitAcc.length==13){
					debitAcc = debitAcc.substring(0,4)+"-"+debitAcc.substring(4,10)+"-"+debitAcc.substring(10);
				}
				document.forms.dataform.DebitAccount.value =debitAcc;	
			}else{
				
		if(document.forms.dataform.ProcessCode.value=='GSR_LCOL')
			{
			 document.forms.dataform.DebitAccount.value = '' ;
             document.forms.dataform.DebitAccount.disabled = true ; 
			}
						
			}
		}
	}catch(e){
		//keep silence
	}//changes end

	//RLS Changes(OnSite) by Manish Shukla.,Date:20/11/2007

	if(document.forms.dataform.ProcessCode.value.toUpperCase()=='GSR_EMPADD')
	{
		if(obj.name.toUpperCase()=='CHANGEINEMPLOYER')
		{
			if(obj.options[obj.selectedIndex].text.toUpperCase()=="YES")
			{
				document.forms.dataform.NewEmployerName.disabled=false;
			}
			else
			{
				document.forms.dataform.NewEmployerName.value="";
				document.forms.dataform.NewEmployerName.disabled=true;
			}
		}
	}

}




//----------------------------------------------------------------------------------------------------
//Function Name                    : introduce()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Alerting user to enter mandatory values.
//								   : Validations
//								   : Submit the form.
//----------------------------------------------------------------------------------------------------
var processName='<%=URLDecoderProcessCode%>';
function introduce()
{
	//window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', true);
	
	try{
	var dataForm=parent.window.dialogArguments;	

	//Start: Mandatory Check
	var flag=false;
	for(var i=0;i<dataForm.elements.length;i++)	{
		if(dataForm.elements[i].name == 'Header' )		{
			if(dataForm.elements[i].value == 'Request Details')			{
				flag = true;
			}else{
				flag = false;
			}
		}
		if (flag){ // Check for request detail section
			//Numeric fields must be mandatory and greater than zero
			if((dataForm.ProcessCode.value=='AL_CRF' && (dataForm.elements[i].name=='NoOfCheques' || dataForm.elements[i].name=='ChargeAmount')) || (dataForm.ProcessCode.value=='AL_CRM' && (dataForm.elements[i].name=='ChargeAmount' )) || (dataForm.ProcessCode.value=='AL_CVD' && (dataForm.elements[i].name=='DepositAmount' || dataForm.elements[i].name=='CHARGESRECEIVED' )) || (dataForm.ProcessCode.value=='AL_CVDE' && (dataForm.elements[i].name=='DepositAmount' || dataForm.elements[i].name=='CHARGESAMOUNT' )) || (dataForm.ProcessCode.value=='AL_EPS' && (dataForm.elements[i].name=='OUTSTANDINGLOANAMOUNT' )) || (dataForm.ProcessCode.value=='AL_ES' && (dataForm.elements[i].name=='AmountReceived' )) || (dataForm.ProcessCode.value=='AL_IPA' && (dataForm.elements[i].name=='NoOfInstallments' || dataForm.elements[i].name=='AmountReceived' || dataForm.elements[i].name=='ChargesReceived' )) || (dataForm.ProcessCode.value=='AL_PD' && ( dataForm.elements[i].name=='ChargesReceived' ))  || (dataForm.ProcessCode.value=='AL_RSD' && (dataForm.elements[i].name=='SecurityDepRef' )) || (dataForm.ProcessCode.value=='AL_RTRL' && (dataForm.elements[i].name=='SecurityDepRef' )) || (dataForm.ProcessCode.value=='AL_TOO' && (dataForm.elements[i].name=='DepositAmount'  || dataForm.elements[i].name=='CHARGESAMOUNT' || dataForm.elements[i].name=='AgeOfNewReg' )) || (dataForm.ProcessCode.value=='AL_TRL' && ( dataForm.elements[i].name=='INSREM' || dataForm.elements[i].name=='NOCARFIN' || dataForm.elements[i].name=='RETUAE' || dataForm.elements[i].name=='DEPAMT' || dataForm.elements[i].name=='CHRGAMT' )) || (dataForm.ProcessCode.value=='GSR_AC' && /*(dataForm.elements[i].name=='ChargeAmount')) || (dataForm.ProcessCode.value=='GSR_LCOL' &&*/ (dataForm.elements[i].name=='Amount'))  || (dataForm.ProcessCode.value=='LAI_BC' && (dataForm.elements[i].name=='LoanOutstandingBalance'))  || (dataForm.ProcessCode.value=='LAI_ES' && (dataForm.elements[i].name=='AmountReceived')) || (dataForm.ProcessCode.value=='LAI_PS' && (dataForm.elements[i].name=='ChargesReceived'))  || (dataForm.ProcessCode.value=='ML_ES' && (dataForm.elements[i].name=='AmtReceived' || dataForm.elements[i].name=='ChargesReceived')) || (dataForm.ProcessCode.value=='ML_MP' && (dataForm.elements[i].name=='ChargesReceived'))  || (dataForm.ProcessCode.value=='ML_PD' && (dataForm.elements[i].name=='ChargesRecvd'))  || (dataForm.ProcessCode.value=='PL_ES' && (dataForm.elements[i].name=='AmountReceived' )) || (dataForm.ProcessCode.value=='PL_IHR' && (dataForm.elements[i].name=='AmountOnHold' )) || (dataForm.ProcessCode.value=='PL_IPDR' && (dataForm.elements[i].name=='InstallmentAmount' )) || /*(dataForm.ProcessCode.value=='PL_PD' && (dataForm.elements[i].name=='ChargesRecvd' )) || RLS-2 Changes sachin arora */   /*(dataForm.ProcessCode.value=='PL_PS' && (dataForm.elements[i].name=='ChargesReceived' ))  ||*/ (dataForm.ProcessCode.value=='RAKF_ES' && (dataForm.elements[i].name=='AmountReceived' )) || (dataForm.ProcessCode.value=='RAKF_PS' && (dataForm.elements[i].name=='ChargesReceived' ))  ){

				if(Number(Trim(dataForm.elements[i].value))==0 || Trim(dataForm.elements[i].value)==''){
					alert(document.getElementById(dataForm.elements[i].name).innerHTML +' can not be zero and can not be left blank.');
					dataForm.elements[i].focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;

				}				
			}

			if(dataForm.ProcessCode.value=='GSR_LCOL'){			
				if(dataForm.CHARGESTOBERECFROM.options[dataForm.CHARGESTOBERECFROM.selectedIndex].value=="Accrue Charges"&&dataForm.CertificateType.options[dataForm.CertificateType.selectedIndex].value=='No Liability Certificate'){
				alert("Accrue Charges is not a valid payment Mode for this request type.");
				dataForm.CHARGESTOBERECFROM.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
				}
			}

		//Changes by Namrata
	
		if(dataForm.ProcessCode.value=='PL_IPDR' || dataForm.ProcessCode.value=='PL_PS' || dataForm.ProcessCode.value=='PL_ES' || dataForm.ProcessCode.value=='PL_PD' || dataForm.ProcessCode.value=='PL_CLD'){
		if((dataForm.ProductOrScheme.value.indexOf('P')!= 0)&&(dataForm.ProductOrScheme.value.substring(0,6)!='AMAL_P')){
		alert(document.getElementById(dataForm.ProductOrScheme.name).innerHTML + ' does not match with Process. ');
		dataForm.ProductOrScheme.focus();
		window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
		
		return false;

		}
		
		} 
			if(dataForm.ProcessCode.value=='ML_CLD' && (dataForm.elements[i].name=='TNRFR' || dataForm.elements[i].name=='TNRTO')){
				if (dataForm.CHGINTNR[dataForm.CHGINTNR.selectedIndex].value=='Yes' && (Trim(dataForm.TNRFR.value)=='' || Number(Trim(dataForm.TNRFR.value))==0 )) {
					alert(document.getElementById(dataForm.TNRFR.name).innerHTML +' can not be zero and can not be left blank.');
					dataForm.TNRFR.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
				if (dataForm.CHGINTNR[dataForm.CHGINTNR.selectedIndex].value=='Yes' && (Trim(dataForm.TNRTO.value)=='' || Number(Trim(dataForm.TNRTO.value))==0 )) {
					alert(document.getElementById(dataForm.TNRTO.name).innerHTML +' can not be zero and can not be left blank.');
					dataForm.TNRTO.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
				if (dataForm.CHGINTNR[dataForm.CHGINTNR.selectedIndex].value=='Yes' && (Trim(dataForm.TNRFR.value)==Trim(dataForm.TNRTO.value))) {
					alert('Tenor From and Tenor To can not be same.');
					dataForm.TNRTO.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}				
			}

			if(dataForm.ProcessCode.value=='ML_CLD' && (dataForm.elements[i].name=='CHGINREPAYMD' || dataForm.elements[i].name=='CHGINTNR' || dataForm.elements[i].name=='CHGINREPAYDT' || dataForm.elements[i].name=='CHGINFAC' || dataForm.elements[i].name=='CHGINPUR' || dataForm.elements[i].name=='CHGINNMTOPROP' || dataForm.elements[i].name=='CHANGEINEMPLOYER' || dataForm.elements[i].name=='CHGINLNST' || dataForm.elements[i].name=='CHGINLIFEINS' )){
				if (dataForm.elements[i].selectedIndex==0){
					alert('Please select the value '+ document.getElementById(dataForm.elements[i].name).innerHTML + '.');
					document.forms.dataform.elements[i].focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}
			if (dataForm.elements[i].name=='CHGINREPAYMD' || dataForm.elements[i].name=='REPAYMDFR4' || dataForm.elements[i].name=='REPAYMDTO4' || dataForm.elements[i].name=='CHGINREPAYDT' || dataForm.elements[i].name=='REPAYDTFR' || dataForm.elements[i].name=='REPAYDTTO' || dataForm.elements[i].name=='CHGINFAC' || dataForm.elements[i].name=='FACFR' || dataForm.elements[i].name=='FACTO' || dataForm.elements[i].name=='CHGINPUR' || dataForm.elements[i].name=='PURFR' || dataForm.elements[i].name=='PURTO' || dataForm.elements[i].name=='CHGINNMTOPROP' || dataForm.elements[i].name=='ADDOFNMTOPROPFR' || dataForm.elements[i].name=='ADDOFNMTOPROPTO' || dataForm.elements[i].name=='CHANGEINEMPLOYER' || dataForm.elements[i].name=='EMPDETFR' || dataForm.elements[i].name=='EMPDETTO' || dataForm.elements[i].name=='CHGINLNST' || dataForm.elements[i].name=='LNSTEX' || dataForm.elements[i].name=='LNSTNEW')
			{
				try{
					if (dataForm.elements[i][dataForm.elements[i].selectedIndex].value=='Yes')
					{  						
						if(dataForm.elements[i+1].type=='text' )
						{
							if(Trim(dataForm.elements[i+1].value) =='' ) 
							{
								alert('Please enter the value in '+document.getElementById(dataForm.elements[i+1].name).innerHTML+'.');
								document.forms.dataform.elements[i+1].focus();
								window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
								
								return false;
							}
							if(Trim(dataForm.elements[i+2].value)=='') 
							{
								alert('Please enter the value in '+document.getElementById(dataForm.elements[i+2].name).innerHTML+' .');
								document.forms.dataform.elements[i+2].focus();
								window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
								
								return false;
							}
							if(Trim(dataForm.elements[i+1].value.toUpperCase()) == Trim(dataForm.elements[i+2].value.toUpperCase())) {
								alert(document.getElementById(dataForm.elements[i+1].name).innerHTML+' and '+document.getElementById(dataForm.elements[i+2].name).innerHTML+' should not be same.');
								document.forms.dataform.elements[i+1].focus();
								window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
								
								return false;
							}

						}
						if(dataForm.elements[i+1].type=='select-one' )
						{
							if(Trim(dataForm.elements[i+1][dataForm.elements[i+1].selectedIndex].value) =='' )
							{
								alert('Please enter the value in '+document.getElementById(dataForm.elements[i+1].name).innerHTML+'.');
								dataForm.elements[i+1].focus();
								window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
								
								return false;
							}
							if(Trim(dataForm.elements[i+2][dataForm.elements[i+2].selectedIndex].value) =='')
							{
								alert('Please enter the value in '+document.getElementById(dataForm.elements[i+2].name).innerHTML+'.');
								dataForm.elements[i+2].focus();
								window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
								
								return false;
							}
							if(dataForm.elements[i+1][dataForm.elements[i+1].selectedIndex].value== dataForm.elements[i+2][dataForm.elements[i+2].selectedIndex].value)
							{
								alert(document.getElementById(dataForm.elements[i+1].name).innerHTML+' and '+document.getElementById(dataForm.elements[i+2].name).innerHTML+' should not be same.');
								dataForm.elements[i+1].focus();
								window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
								
								return false;
							}
						}
					}						
				}catch(e){
					
					//keep silence
				}
			}else if (dataForm.elements[i].name=='CHGINLIFEINS' || dataForm.elements[i].name=='LIFEINS')
			{
				try{ //For ML_CLD				
					if (dataForm.elements[i].options[dataForm.elements[i].selectedIndex].value=='Yes')
					{
						if(dataForm.LIFEINS.selectedIndex==0)
						{
							alert('Please select the Life Insurance.');
							document.forms.dataform.LIFEINS.focus();
							window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
							
							return false;
						}
					}
				}catch(e){			
					
					//keep silence	
				}
		
			}else if(dataForm.ProcessCode.value=='AL_RTRL' && dataForm.elements[i].name=='AcToCredit'){
				if (dataForm.RepaymentModeFrom.value=='A/C Credit' && Trim(dataForm.AcToCredit.value)=='' ){
					alert('Please enter the account no.');
					dataForm.AcToCredit.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if((dataForm.ProcessCode.value=='AL_PD' || dataForm.ProcessCode.value=='ML_PD') && dataForm.elements[i].name=='DebitAccount'){
				if (dataForm.ModeOfPayment.value=='A/C Debit' && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_TOO' && dataForm.elements[i].name=='DebitAccount_ForCharge'){
				if ((dataForm.MDPAY.value=='A/C Debit' ||  dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.DebitAccount_ForCharge.value)=='' ){
					alert('Please enter the account no.');
					dataForm.DebitAccount_ForCharge.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_TOO' && dataForm.elements[i].name=='DebitAccount'){
				if ((dataForm.ModeOfPayment.value=='A/C Debit' ||  dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_TRL' && dataForm.elements[i].name=='DBTACCCHRG'){
				//----------------------------------------------------------------------------------------------------
				// Changed By						:	Manish K. Agrawal
				// Reason / Cause (Bug No if Any)	:	(RLS-OF_Defect_AL_PD_C1_26.xls)
				// Change Description				:	The validation in FS says "· If Payment for Security is “RAKBANK Salaried Guarantor” then Input of Account of Salaried Guarantor is mandatory". Whereas it doesn’t ask for that, it just asks for the name of the Guarantor in the message box to fill in the field "RAKBank Salaried Guarantor". (RLS-OF_Defect_AL_TRL_C1_01.xls)
				//----------------------------------------------------------------------------------------------------

				if ((dataForm.PAYMOD.value=='A/C Debit' || dataForm.PAYMOD.value=='RAKBank Salaried Guarantor' ) && Trim(dataForm.DBTACCCHRG.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DBTACCCHRG.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}

			/*}else if(dataForm.ProcessCode.value=='AL_TRL' && dataForm.elements[i].name=='RBGUA'){
				if (dataForm.PAYMOD.value=='RAKBank Salaried Guarantor' && Trim(dataForm.RBGUA.value)=='' ){
					alert('Please enter the RAKBank Salaried Guarantor.');
					dataForm.RBGUA.focus();
					return false;
				}*/
			}else if(dataForm.ProcessCode.value=='AL_TRL' && dataForm.elements[i].name=='DBTACC'){
				if (dataForm.MDPAY.value=='A/C Debit' && Trim(dataForm.DBTACC.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DBTACC.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CVD' && dataForm.elements[i].name=='DebitAccount'){
				if ((dataForm.ModeOfPayment.value=='A/C Debit' || dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CVD' && dataForm.elements[i].name=='DebitAccount_ForCharge'){
				if ((dataForm.MDPAY.value=='A/C Debit'  || dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.DebitAccount_ForCharge.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount_ForCharge.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CVDE' && dataForm.elements[i].name=='DebitAccount'){
				if ((dataForm.ModeOfPayment.value=='A/C Debit'  || dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}
			//----------------------------------------------------------------------------------------------------
			// Changed By						:	Manish K. Agrawal
			// Reason / Cause (Bug No if Any)	:	Debit Account is conditionally mandatory.(RKB-RLS-ALS-CRF-0007)
			// Change Description				:	Debit Account is conditionally mandatory.
			//----------------------------------------------------------------------------------------------------

			else if(dataForm.ProcessCode.value=='AL_CRF' && dataForm.elements[i].name=='DebitAccount'){
				if ((dataForm.PMODE.value=='A/C Credit' || dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_RSD' && dataForm.elements[i].name=='AccountNo'){
				if ((dataForm.RepaymentModeFrom.value=='A/C Credit' || dataForm.RepaymentMode.value=='A/C Credit') && Trim(dataForm.AccountNo.value)=='' ){
					alert('Please enter the account no.');
					dataForm.AccountNo.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
/*			}
			//----------------------------------------------------------------------------------------------------
			// Changed By						:	Manish K. Agrawal
			// Reason / Cause (Bug No if Any)	:	validation on No.of cheques.(RKB-RLS-ALS-CRF-0021)
			// Change Description				:	validation on No.of cheques.
			//----------------------------------------------------------------------------------------------------

			else if(dataForm.ProcessCode.value=='AL_CRF' && dataForm.elements[i].name=='NoOfCheques'){
				if (parseInt(Trim(dataForm.NoOfCheques.value))==0 || Trim(dataForm.NoOfCheques.value)=='' ){
					alert('No.of cheques can not be zero and can not be left blank.');
					dataForm.NoOfCheques.focus();
					return false;
				}
				//----------------------------------------------------------------------------------------------------
				// Changed By						:	Manish K. Agrawal
				// Reason / Cause (Bug No if Any)	:	format of No.of cheques.(RKB-RLS-ALS-CRF-0002)
				// Change Description				:	format of No.of cheques.
				//----------------------------------------------------------------------------------------------------

				if (dataForm.NoOfCheques.value.indexOf('.')!=-1){
					alert('Invalid value of No.of cheques has entered.');
					dataForm.NoOfCheques.focus();
					return false;
				}				*/
			}else if(dataForm.ProcessCode.value=='AL_CVDE' && dataForm.elements[i].name=='DebitAccount_ForCharge'){
				if ((dataForm.MDPAY.value=='A/C Debit' ) && Trim(dataForm.DebitAccount_ForCharge.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount_ForCharge.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CVDE' && dataForm.elements[i].name=='EMIRATESNEW'){
				if(dataForm.EMIRATESNEW.selectedIndex==0){
					alert('Emirates(New) is mandatory field.');
					dataForm.EMIRATESNEW.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
				if (dataForm.EMIRATESEXISTING.value== dataForm.EMIRATESNEW.value){
					alert('Emirates(Existing) and Emirates(New) should not be same.');
					dataForm.EMIRATESNEW.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CRM' && dataForm.elements[i].name=='FundingAccount'){
				if (dataForm.TrnsfrmNB2B.value=='Yes' && Trim(dataForm.FundingAccount.value)=='' ){
					alert('Please enter the funding account no.');
					dataForm.FundingAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CRM' && dataForm.elements[i].name=='DebitAccount'){
				if (dataForm.ModeOfPayment.value=='A/C Debit' && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_PDRL' && dataForm.elements[i].name=='Charges'){
				if (dataForm.DupPRRequest.value=='Yes' && (Trim(dataForm.Charges.value)=='' || Number(Trim(dataForm.Charges.value))==0 )) {
					alert('Charges can not be zero and can not be left blank.');
					dataForm.Charges.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_PDRL' && dataForm.elements[i].name=='InsuranceCompanyName'){
				if (dataForm.PRAgainstUndertaking.value=='Yes' && Trim(dataForm.InsuranceCompanyName.value)=='' ){
					alert('Please enter the insurance company name.');
					dataForm.InsuranceCompanyName.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}			
			}else if(dataForm.ProcessCode.value=='AL_PDRL' && dataForm.elements[i].name=='DealerName'){
				if (dataForm.PRAgainstUndertaking.value=='Yes' && Trim(dataForm.DealerName.value)=='' ){
					alert('Please enter the dealer name.');
					dataForm.DealerName.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}			
			}else if(dataForm.ProcessCode.value=='AL_PDRL' && dataForm.elements[i].name=='DebitAccount'){
				if ((dataForm.ModeOfPayment.value=='A/C Debit'  )  && Trim(dataForm.DebitAccount.value)=='' ){
					alert('Please enter the debit account no.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value=='AL_CMA' && (dataForm.elements[i].name=='EmployerName' || dataForm.elements[i].name=='FaxNo' || dataForm.elements[i].name=='OfficeNo'  || dataForm.elements[i].name=='Town_Emirate' )){
				//----------------------------------------------------------------------------------------------------
				// Changed By						:	Manish K. Agrawal
				// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0010/RKB-RLS-ALS-CMA-0011/RKB-RLS-ALS-CMA-0065/RKB-RLS-ALS-CMA-0067/RKB-RLS-ALS-CMA-0069/RKB-RLS-ALS-CMA-0071/RKB-RLS-ALS-CMA-0073/RKB-RLS-ALS-CMA-0077/RKB-RLS-ALS-CMA-0078 )
				// Change Description				:	Got/Lost focus problem
				//----------------------------------------------------------------------------------------------------
				if (dataForm.ChangeInEmployment.value=='Yes'){
					if(Trim(dataForm.EmployerName.value)=='' ){
						alert('Employer Name is mandatory.');
						dataForm.EmployerName.focus();
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;
					}
					if(Trim(dataForm.Town_Emirate.value)=='' ){
						alert('Town/Emirate is mandatory.');
						dataForm.Town_Emirate.focus();
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;
					}
					if(Trim(dataForm.OfficeNo.value)=='' ){
						alert('Office No is mandatory.');
						dataForm.OfficeNo.focus();
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;
					}
					if(Trim(dataForm.FaxNo.value)=='' ){
						alert('Fax No is mandatory.');
						dataForm.FaxNo.focus();
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;
					}
				}
			}else if(dataForm.ProcessCode.value=='AL_CMA' && (dataForm.elements[i].name=='ResiNo' || dataForm.elements[i].name=='MobNo')){
				if (Trim(dataForm.ResiNo.value)=='' && Trim(dataForm.MobNo.value)=='' ){
					alert('Either residence no or mobile no is mandatory.');
					dataForm.ResiNo.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if((dataForm.ProcessCode.value=='AL_TRL' || dataForm.ProcessCode.value=='ML_CLD') && (dataForm.elements[i].name=='RESNO' || dataForm.elements[i].name=='MOB')){
				if (Trim(dataForm.RESNO.value)=='' && Trim(dataForm.MOB.value)=='' ){
					alert('Either residence no or mobile no is mandatory.');
					dataForm.RESNO.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if((dataForm.ProcessCode.value=='AL_PDRL' || dataForm.ProcessCode.value=='AL_CVDE' || dataForm.ProcessCode.value=='AL_CVD' || dataForm.ProcessCode.value=='AL_PD' || dataForm.ProcessCode.value=='AL_TOO') && (dataForm.elements[i].name=='ResidenceNo' || dataForm.elements[i].name=='Mobile')){
				if (Trim(dataForm.ResidenceNo.value)=='' && Trim(dataForm.Mobile.value)=='' ){
					alert('Either residence no or mobile no is mandatory.');
					dataForm.ResidenceNo.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if((/*dataForm.ProcessCode.value=='PL_ES' ||*/ dataForm.ProcessCode.value=='RAKF_ES' || dataForm.ProcessCode.value=='LAI_ES' || dataForm.ProcessCode.value=='AL_ES') && (
				dataForm.elements[i].name=='ChargesReceived' || dataForm.elements[i].name=='ModeOfPayment' || dataForm.elements[i].name=='ISSUERELEASEORGSALEAGMT' || dataForm.elements[i].name=='TAKEOVERBYOOTHERBANK' || dataForm.elements[i].name=='MDPAY' )){
				//do nothing (Non mandatory fields)  //rls-2 pl_es mode of payment is mandatory...               26-oct-2007   Sachin Arora
			//----------------------------------------------------------------------------------------------------
			// Changed By						:	Manish K. Agrawal
			// Reason / Cause (Bug No if Any)	:	Non-mandatory.(RKB-RLS-ALS-CRF-0008/RKB-RLS-PL-CLD-0001/RKB-RLS-PL-CLD-0002)
			// Change Description				:	Non- mandatory.
			//----------------------------------------------------------------------------------------------------
			}else if(dataForm.ProcessCode.value.toUpperCase()=='GSR_EMPADD' && dataForm.elements[i].name=='NewEmployerName' ){
				if (dataForm.ChangeInEmployer.value=='Yes' && Trim(dataForm.NewEmployerName.value)==''){
					alert('New employer name is mandatory.');
					dataForm.NewEmployerName.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if(dataForm.ProcessCode.value.toUpperCase()=='GSR_EMPADD' && dataForm.elements[i].name=='NewGuarantorName' ){
				if (dataForm.ChangeInGuarantor.value=='Yes' && Trim(dataForm.NewGuarantorName.value)==''){
					alert('New guarantor a/c number is mandatory.');
					dataForm.NewGuarantorName.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if((dataForm.ProcessCode.value=='AL_CRF' || dataForm.ProcessCode.value=='AL_RSD')&& (dataForm.elements[i].name=='LETTERTOBESENTTO'	)){
				//do nothing (Non mandatory fields)
			}else if((dataForm.ProcessCode.value=='ML_CLD')&& (dataForm.elements[i].name=='CHGINTNR' ||	dataForm.elements[i].name=='TNRFR' ||	dataForm.elements[i].name=='TNRTO')){
				//do nothing (Non mandatory fields)
			}else if((dataForm.ProcessCode.value=='AL_TRL') && (dataForm.elements[i].name=='BKGUARAMT' || dataForm.elements[i].name=='BKNAME' || dataForm.elements[i].name=='BKSECCHQFRM' || dataForm.elements[i].name=='LTRADDTO' || dataForm.elements[i].name=='LTRSENTTO' || dataForm.elements[i].name=='BKGUARISSDT' || dataForm.elements[i].name=='BKGUAREXPDT' || dataForm.elements[i].name=='SECCHQAMT')){
				//do nothing (Non mandatory fields)
			}else if(dataForm.ProcessCode.value.toUpperCase()=='GSR_EMPADD' && (dataForm.elements[i].name=='TakeOverBankName' || dataForm.elements[i].name=='RetProcessComp' || dataForm.elements[i].name=='WaiverOnEarlySetFees' || dataForm.elements[i].name=='WaiverAmount'  || dataForm.elements[i].name=='WaiverApprovedBy' || dataForm.elements[i].name=='NewProvideDocuments'  || dataForm.elements[i].name=='REVOFINST' || dataForm.elements[i].name=='CHGININSTDT' || dataForm.elements[i].name=='CHGINFINSTDATE' )){
				//do nothing (Non mandatory fields)
			}else if((dataForm.ProcessCode.value=='PL_PD' || dataForm.ProcessCode.value=='ML_PD' ) && (dataForm.elements[i].name=='NextInstDate'	)){
				//do nothing (Non mandatory fields)
			}else if(dataForm.ProcessCode.value=='AL_PDRL' && (dataForm.elements[i].name=='LASTRELLETISSUEDATE' || dataForm.elements[i].name=='REASON_2' || dataForm.elements[i].name=='LETTERTOBESENTTO'  || dataForm.elements[i].name=='LETTERADDRESSEDTO' 	)){
				//do nothing (Non mandatory fields)
			}else if(dataForm.ProcessCode.value=='AL_CRM' && (dataForm.elements[i].name=='CUSTREQOLDCHQPDC' || dataForm.elements[i].name=='NUMOFCHQTOBEREP' || dataForm.elements[i].name=='SECURITYCHEQUES')){
				//do nothing (Non mandatory fields)
			}else if(dataForm.ProcessCode.value=='GSR_LCOL' && (dataForm.elements[i].name=='Name' 
				|| dataForm.elements[i].name=='ResidenceNo' || dataForm.elements[i].name=='Mobile' )){
				//do nothing (Non mandatory fields)
			}else if((dataForm.ProcessCode.value=='AL_CVD' || dataForm.ProcessCode.value=='AL_CVDE')  && (dataForm.elements[i].name=='LETTERADDRESSEDTO'  || dataForm.elements[i].name=='LETTERTOBESENTTO')){
				//do nothing (Non mandatory fields)
			}else if(dataForm.ProcessCode.value=='AL_RTRL' && (dataForm.elements[i].name=='BANKNAME'  || dataForm.elements[i].name=='BANKGUARAMT' || dataForm.elements[i].name=='BANKGUARISSUEDATE' || dataForm.elements[i].name=='BANKGUAREXPDATE' || dataForm.elements[i].name=='SECCHQREQ' || dataForm.elements[i].name=='BANKSECCHQFRM' || dataForm.elements[i].name=='SECCHQAMT' || dataForm.elements[i].name=='LETTERADDRESSEDTO' || dataForm.elements[i].name=='LETTERTOBESENTTO')){
				//do nothing (Non mandatory fields)

			//----------------------------------------------------------------------------------------------------
			// Changed By								:	Manish K. Agrawal
			// Reason / Cause (Bug No if Any)	:	validation on No.of cheques.(RKB-RLS-PL-PD-0002)
			// Change Description					:	Debit acc is mandatory only if mode=ac acredit.(RKB-RLS-PL-PD-0002)
			//----------------------------------------------------------------------------------------------------

			}else if((dataForm.ProcessCode.value=='PL_PD' || dataForm.ProcessCode.value=='PL_ES') && dataForm.elements[i].name=='DebitAccount' ){
				if (dataForm.ModeOfPayment.value=='A/C Debit' && Trim(dataForm.DebitAccount.value)==''){
					alert('Debit account is mandatory.');
					dataForm.DebitAccount.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else if((dataForm.ProcessCode.value=='LAI_PS' || dataForm.ProcessCode.value=='RAKF_PS' || dataForm.ProcessCode.value=='ML_MP' ) && (dataForm.elements[i].name=='NoOfInstallments' || dataForm.elements[i].name=='AmountReceived' )){
				if(dataForm.ISAMTREC.value=='Yes'){
					if (Trim(dataForm.elements[i].value)=='' || Number(Trim(dataForm.elements[i].value))==0){
						alert(document.getElementById(dataForm.elements[i].name).innerHTML  + ' can not be zero and can not be left blank.');
						dataForm.elements[i].focus();
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;
					}    // rakbank pl_ps isamtchk field to be removed   sachin 09/07/2007
				}
			}else if(dataForm.ProcessCode.value=='AL_TRL' && dataForm.elements[i].name=='INSPD' ){
				if (Trim(dataForm.INSPD.value)==''){
					alert('Installments Paid is mandatory.');
					dataForm.INSPD.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
			}else{
				if(dataForm.elements[i].style.display!='none'){
					if(dataForm.elements[i].type=='text' ){
						if (dataForm.elements[i].name!='CREDITCARDNO' && dataForm.elements[i].name!='SETTLEMENTFEEPERCENT' &&  dataForm.elements[i].name!='EQUATIONMASTER' && (Trim(dataForm.elements[i].value)=='') && (dataForm.elements[i].disabled!=true))
									
						{
                          if(!((dataForm.ProcessCode.value=='PL_IPDR') && (dataForm.elements[i].name=='MobileNo' || dataForm.elements[i].name=='LandlineNo'))){                 //rls-2 changes sachin arora 30-oct-2007
							alert(document.getElementById(dataForm.elements[i].name).innerHTML  + ' is mandatory field.');
							dataForm.elements[i].focus();
							window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
							
							return false;
						 }
						}
						else if	((dataForm.elements[i].name=='SETTLEMENTFEEPERCENT')&&((dataForm.elements[i].value==''))&&(Trim(dataForm.elements['WAIVEROFESFEESAPPBY'][dataForm.elements['WAIVEROFESFEESAPPBY'].selectedIndex].value)==''))
						{
                           alert(document.getElementById(dataForm.elements[i].name).innerHTML  + ' is mandatory field.');
							dataForm.elements[i].focus();
							window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
							
							return false;
						}

					}
					if(dataForm.elements[i].type=='select-one'){
//sachin 09/07/2007 rak bank changes
                  

						if (Trim(dataForm.elements[i][dataForm.elements[i].selectedIndex].value)==''){
                         // alert(dataForm.elements[i].name);
					 	if (!((dataForm.ProcessCode.value=='PL_PS' &&  dataForm.elements[i].name=='LoanRestructure' && dataForm.elements[i].disabled==true) || /*(dataForm.ProcessCode.value=='GSR_LCOL' && dataForm.elements[i].name== 'CHARGESTOBERECFROM') || commented under RLS change-2, 30/10/2007,by: Piyush*/ (dataForm.ProcessCode.value=='PL_ES' && dataForm.elements[i].name== 'WAIVEROFESFEESAPPBY') )) 
								{

							alert(document.getElementById(dataForm.elements[i].name).innerHTML  + ' is mandatory field.');
							dataForm.elements[i].focus();
							window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
							
							return false;
							}
						}
					}
				}
			}
		} //end flag condition
	}// End For
	


/*	if(dataForm.ProcessCode.value=='ML_CLD'){ //At least one change request must be selected.
		if ((Trim(dataForm.CHGINREPAYMD.value)=='' || dataForm.CHGINREPAYMD.value=='No') && (Trim(dataForm.CHGINTNR.value)=='' || dataForm.CHGINTNR.value=='No' ) && (Trim(dataForm.CHGINREPAYDT.value)=='' || dataForm.CHGINREPAYDT.value=='No' ) && (Trim(dataForm.CHGINFAC.value)=='' || dataForm.CHGINFAC.value=='No' ) && (Trim(dataForm.CHGINPUR.value)=='' || dataForm.CHGINPUR.value=='No' ) && (Trim(dataForm.CHGINNMTOPROP.value)=='' || dataForm.CHGINNMTOPROP.value=='No' ) && (Trim(dataForm.CHANGEINEMPLOYER.value)=='' || dataForm.CHANGEINEMPLOYER.value=='No') && (Trim(dataForm.CHGINLIFEINS.value)=='' || dataForm.CHGINLIFEINS.value=='No')){
			alert('Please select atleast one change request.');
			return false;
		}
	}*/
	/*(Trim(dataForm.ChangeInGuarantor.value)=='' || dataForm.ChangeInGuarantor.value=='No' ) &&    rak bank changes  Sachin arora*/ 

	if(dataForm.ProcessCode.value.toUpperCase()=='GSR_EMPADD'){ //At least one change request must be selected.
		if ((Trim(dataForm.ChangeInEmployer.value)=='' || dataForm.ChangeInEmployer.value=='No') && (Trim(dataForm.ChangeInContacts.value)=='' || dataForm.ChangeInContacts.value=='No')){
			alert('Please select atleast one change request.');
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
		
		//window.document.forms["dataform"].q_mobileno.value=dataForm.MOBILENO.value;		//filter error sachin
		//window.document.forms["dataform"].q_landlineno.value=dataForm.LANDLINENO.value;
	}
	
	try{//PL_PD
		if(Number(Trim(dataForm.Bucket.value))>0){
			if(dataForm.CustomerOverDue.options[dataForm.CustomerOverDue.selectedIndex].value.toUpperCase()!='YES'){
				alert('Customer Overdue flag must be equal to Yes because bucket is greater than 0.');	
				dataForm.CustomerOverDue.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	}catch(e){
		
		//keep silence
	}
	
	try{//PL_PD  
		 var retVal = Comparedates(dataForm.DeferInstDueOn.value, dataForm.NextInstDate.value, strDateFormat);
		if(retVal==0) {
			alert('The Defer Installment Date should be greater or equal to the Next Installment Date.');
			dataForm.DeferInstDueOn.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
		retVal = Comparedates(dataForm.DeferInstDueOn.value,dataForm.LoanMaturityDate.value, strDateFormat);
		if(retVal!=0) {
			alert('The Defer Installment Date should be less than Loan Maturity Date.');
			dataForm.DeferInstDueOn.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
		retVal = Comparedates(dataForm.LoanMaturityDate.value,dataForm.NextInstDate.value, strDateFormat);
		if(retVal==0) {
			alert('The Next Installment Date should be less than Loan Maturity Date.');
			dataForm.NextInstDate.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}  
		//----------------------------------------------------------------------------------------------------
		// Changed By								:	Manish K. Agrawal
		// Reason / Cause (Bug No if Any)	:	No need of this validation.(RKB-RLS-PL-PD-0011)
		// Change Description					:	No need of this validation.(RKB-RLS-PL-PD-0011)
		//----------------------------------------------------------------------------------------------------

	/*	var strDate = getCurrentDateTimeInLocalFormat(strDateFormat);
		var retVal = Comparedates(strDate,dataForm.NextInstDate.value, strDateFormat);
		if(retVal!=0) {
			alert('The New Next Installment Date should be greater than todays Date.');
			dataForm.NextInstDate.focus();
			return false;
		}	*/

	}catch(e){
		
	}   
	/*try{//PL_PD, ML_PD, AL_PD
		var strDate = getCurrentDateTimeInLocalFormat(strDateFormat);
		var retVal = Comparedates(strDate,dataForm.DeferInstDueOn.value, strDateFormat);
		if(retVal!=0) {
			alert('The Defer Installment Date should be greater than todays Date.');
			dataForm.DeferInstDueOn.focus();
			return false;
		}		
	}catch(e){
	}*/
	if (dataForm.ProcessCode.value=='ML_CLD' ){
		if(dataForm.CHGINREPAYDT.value=='Yes' && Trim(dataForm.REPAYDTFR.value)!='' && Trim(dataForm.REPAYDTTO.value)!=''){
			var retVal = Comparedates(dataForm.REPAYDTFR.value,dataForm.REPAYDTTO.value, strDateFormat);
			if(retVal!=0) {
				alert('The From Repayment Date should be less than To Repayment Date.');
				dataForm.REPAYDTTO.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	}

	try{
		var ret = Comparedates(dataForm.FROMDATETIME.value,dataForm.TODATETIME.value, strDateFormat);
		if(ret==-1) {
			alert('The TO Date should be greater or equal to From Date.');
			dataForm.TODATETIME.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
	}catch(e){
	}
	try{//AL_RTRL
		if(dataForm.BANKGUARISSUEDATE.value != '' && dataForm.BANKGUAREXPDATE.value !='' ){
			var ret = Comparedates(dataForm.BANKGUARISSUEDATE.value,dataForm.BANKGUAREXPDATE.value, strDateFormat);
			if(ret!=0) {
				alert('The Bank Guarantee Expiry Date should be greater than Bank Guarantee Issue Date.');
				dataForm.BANKGUAREXPDATE.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	}catch(e){
	}

	try{//AL_TRL
	    if (Number(GetDateDiff(dataForm.DTTRVL.value,dataForm.DTRTN.value, strDateFormat))>Number(Trim(dataForm.RETUAE.value))){
			alert('Difference between date of travel and date of return should not be greater than return to UAE value.');
			dataForm.RETUAE.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}

		if (!futureDateValidation(dataForm.DTTRVL.value)){
				alert('Past Date is not allowed in date of travel');
				dataForm.DTTRVL.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		if (!futureDateValidation(dataForm.DTRTN.value)){
				alert('Past Date is not allowed in date of return ');
				dataForm.DTRTN.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
	}catch(e){
		//Keep Silence
	}
	try{//AL_TRL
		var ret = Comparedates(dataForm.DTTRVL.value,dataForm.DTRTN.value, strDateFormat);
		if(ret!=0) {
			alert('The Date of Return should be greater than Date of Travel.');
			dataForm.DTRTN.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
		if(dataForm.BKGUARISSDT.value!='' && dataForm.BKGUAREXPDT.value!=''){
			ret = Comparedates(dataForm.BKGUARISSDT.value,dataForm.BKGUAREXPDT.value, strDateFormat);
			if(ret!=0) {
				alert('The Bank Guarantee Expiry Date should be greater than Bank Guarantee Issue Date.');
				dataForm.BKGUAREXPDT.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	}catch(e){
	}
	try{//AL_CRM
		var ret = Comparedates(dataForm.CurrentDueDate.value,dataForm.NewDueDate.value, strDateFormat);
		if(ret==-1) {
			alert('The New Due Date should be greater or equal to Current Due Date.');
			dataForm.NewDueDate.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
	}catch(e){
		
	}

/*	try{
		ret = Comparedates(dataForm.RepaymentDateFrom.value,dataForm.RepaymentDateTO.value, strDateFormat);
		if(ret!=0) {
			alert('The From Repayment Date should be less than to To Repayment Date.');
			dataForm.RepaymentDateTO.focus();
			return false;
		}
	}catch(e){
	
	}*/
	try{//PL_PS
		if(dataForm.ProcessCode.value=='PL_PS' || dataForm.ProcessCode.value=='LAI_PS' || dataForm.ProcessCode.value=='RAKF_PS'){ 
			if(dataForm.ISAMTREC.value=='Yes'){
				if(Number(Trim(dataForm.NoOfInstallments.value))<=0){
					alert('Please fill the no. of installment.');
					dataForm.NoOfInstallments.focus();
					window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
					
					return false;
				}
		}
		if(dataForm.ProcessCode.value!='ML_ES' ){			
			if(Number(Trim(dataForm.AmountReceived.value))>=Number(Trim(dataForm.OutstandingLoanAmt.value))){
				alert('The Amount received should be less than Outstanding Loan Amount.');	
				dataForm.AmountReceived.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
		}
	}catch(e){
		
		//keep silence
	}
	if(dataForm.ProcessCode.value=='AL_IPA' || dataForm.ProcessCode.value=='ML_MP' ){
		if(Number(Trim(dataForm.AmountReceived.value))>=Number(Trim(dataForm.OutstandingLoanAmt.value))){
			alert('The Amount received should be less than Outstanding Loan Amount.');	
			dataForm.AmountReceived.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
	}
	if(dataForm.ProcessCode.value=='ML_ES' ){
		if(Number(Trim(dataForm.AmtReceived.value))>Number(Trim(dataForm.OutstandingLoanAmt.value))){
			alert('The Amount received should be less than or equal to Outstanding Loan Amount.');	
			dataForm.AmtReceived.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
	}
	try{
		if(dataForm.AdvanceRepayment.value=='Yes'){
			if(Number(dataForm.NoOfInstallments.value)>Number(dataForm.Tenor.value)){
				alert('Advance Repayment is selected as Yes then No. of Installments should not exceed the Balance Tenor.');	
				dataForm.NoOfInstallments.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	}catch(e){
		
		//keep silence
	}
	
	try{
		if(dataForm.RepaymentMode.value=='P'){
			if(dataForm.RetPDCToCust.options[dataForm.RetPDCToCust.selectedIndex].value!='Yes'){
				alert('Return PDC to Customer should be YES because Repayment Mode is PDC.');	
				dataForm.RetPDCToCust.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	}catch(e){
		
		//keep silence
	}
	for(var i=0;i<dataForm.elements.length;i++)
	{
		if(dataForm.elements[i].type=='text' )
		{
			if(dataForm.elements[i].id=='D')
			{
				if(Trim(dataForm.elements[i].value)!="")
				{
					var var1=dataForm.elements[i];
					if(!chkdate(var1, strDateFormat))
					{
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;
					}
				}
			}
			else if(dataForm.elements[i].id.substring(0,1)=='F')
			{
				var sFloat=dataForm.elements[i].id;
				var sInt=sFloat.substring(2,sFloat.indexOf(","));
				var sDec=sFloat.substring(sFloat.indexOf(",")+1,dataForm.elements[i].id.length);
				
				if(Trim(dataForm.elements[i].value)!="")
				{
					if(dataForm.elements[i].value.indexOf(".")==-1)
					{
						if(dataForm.elements[i].value.length>sInt)
						{
							alert("The format of "+ dataForm.elements[i].name + " should be " + sInt + "," + sDec + ".");
							dataForm.elements[i].focus();
							window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
							
							return false;
						}
					}
					else if((dataForm.elements[i].value.substring(dataForm.elements[i].value.indexOf(".")+1, dataForm.elements[i].value.length).length>sDec))
					{
						alert("The format of "+ dataForm.elements[i].name + " should be " + sInt + "," + sDec + ".");
						dataForm.elements[i].focus();
						window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
						
						return false;

					}
				
					else
					{
						if(dataForm.elements[i].value.indexOf(".")>(sInt+4) || (dataForm.elements[i].value.length-dataForm.elements[i].value.indexOf("."))>(sInt+4) || !(dataForm.elements[i].value.indexOf(".")==dataForm.elements[i].value.lastIndexOf(".")) || (dataForm.elements[i].value.length==dataForm.elements[i].value.indexOf(".")+1))
						{
							alert("The format of "+ dataForm.elements[i].name + " should be " + sInt + "," + sDec + ".");					
							dataForm.elements[i].focus();
							window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
							
							return false;
						}
					}



				}
			}
		}
		
	}
	// RLS Changes-2, Date: 29/10/2007, By: Piyush Kumar.
	if(document.forms.dataform.ProcessCode.value=='GSR_LCOL'){
		if(dataForm.CHARGESTOBERECFROM.options[dataForm.CHARGESTOBERECFROM.selectedIndex].value=='A/C Debit'){
			if(dataForm.DebitAccount.value==''){
				alert("Debit Account is mendatory.");
				dataForm.DebitAccount.focus();
				window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
				return false;
			}
		}
	
	if((dataForm.CHARGESTOBERECFROM.options[dataForm.CHARGESTOBERECFROM.selectedIndex].value=='Accrue Charges')&& (dataForm.CertificateType.options[dataForm.CertificateType.selectedIndex].value=='No Liability Certificate')){
			alert("Accrue Charges is not a valid payment Mode for this request type.");
			dataForm.CHARGESTOBERECFROM.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
	}
	// changes end- 29/10/2007
	// RLS Changes-2 for PS. Date:31/10/2007, By: Piyush Kumar
	if(document.forms.dataform.ProcessCode.value=='PL_PS'){
		
		if((dataForm.ServiceType.options[dataForm.ServiceType.selectedIndex].value=='Part Settlement')&& (dataForm.ModeOfPayment.options[dataForm.ModeOfPayment.selectedIndex].value=='Cash')){
			alert("for Service Type 'Part Settlement ' Payment Mode can not be Cash");
			dataForm.ServiceType.focus();
			window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
			
			return false;
		}
	}
	// end RLS Changes-2 for PS
	}catch(e)
	{
		
		//alert(e.message);

	}

	//----------------------------------------------------------------------------------------------------
	// Changed By						:	Manish K. Agrawal
	// Reason / Cause (Bug No if Any)	:	Minimizing the window.(RKB-RLS-ALS-CMA-0083/RKB-RLS-ALS-CMA-0104)
	// Change Description				:	Minimizing the window.
	//----------------------------------------------------------------------------------------------------

	//var sFeatures="dialogHeight:50px; dialogWidth:50px; center=yes; status:no; ";
		//alert("before I12345 "+dataForm.q_mobileno.value);
	var sFeatures="dialogHeight:0px; dialogWidth:0px; center=yes; dialogLeft:1500;dialogTop:1500;status:yes; ";
	var sResult;
	//var sResult = window.showModalDialog('WIIntroduceFrameset.jsp',document.forms.dataform,sFeatures);
	
	//*********************************************************************************************************
	var windowParams="height=0px,width=0px,toolbar=no,directories=no,status=yes,center=yes";
	//to get Wi data
	var dataForm=window.document.forms['dataform'];
	for(var i=0;i<dataForm.elements.length;i++)
		{
			//dataForm.elements[i].value=escape(dataForm.elements[i].value);
			if(dataForm.elements[i].type=='text'  || dataForm.elements[i].type=='textarea')
			{
				//if(dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'TypeName' && dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'TypeID' && dataForm.elements[i].name!='RequestName' && dataForm.elements[i].name != 'RequestID' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined && dataForm.elements[i].value!='')

				if(dataForm.elements[i].name!='Header' && dataForm.elements[i].name != 'ServiceTypeName' && dataForm.elements[i].name!='BranchNameForPrinting' && dataForm.elements[i].name != 'ProcessCode' && dataForm.elements[i].name != '' && dataForm.elements[i].name != undefined )
				{
					//dataForm.elements[i].value=replaceAll(dataForm.elements[i].value ,"'","''");
					//if(dataForm.elements[i].id=='D')
					/*if(dataForm.elements[i].id.indexOf('Date_')!=-1)
					{
						
						//var str = replaceAll(dataForm.elements[i].value,'-','/'); //pass date in DD/MM/YYYY format
						document.forms.dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + LocalToDB(dataForm.elements[i].value, strDateFormat) + '\31' ;
					}
					else
					{
						if(dataForm.elements[i].id.indexOf('F_')!=-1)
						{
					
						  dataForm.elements[i].value =replaceAll (dataForm.elements[i].value,',','') ;
						 // alert( dataForm.elements[i].value);
						}*/
						var svar=replaceAll(dataForm.elements[i].value,"-","");
						svar=replaceAll(dataForm.elements[i].value,",","");						
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
					//}
				}
				
			}

			if(dataForm.elements[i].type=='select-one')
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					//alert(dataForm.elements[i].name+"------"+dataForm.elements[i][dataForm.elements[i].selectedIndex].value);
					var svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,"-","");
						svar=replaceAll(dataForm.elements[i][dataForm.elements[i].selectedIndex].value,",","");	
					dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + svar + '\31' ;
				}
					
			}
			if(dataForm.elements[i].type=='checkbox')
			{
				if(dataForm.elements[i].name != undefined && dataForm.elements[i].name != '')
				{
					if(dataForm.elements[i].checked==true)
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + "Y" + '\31' ;
					else
						dataForm.WIData.value +=  dataForm.elements[i].name + '\25' + "N" + '\31' ;
				}					
			}
		}
	
	//alert('1');
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	var WSNAME = "";//customform.document.getElementById("wdesk:Current_WS").value; // unnecessary this was passed which was creating issue at DataEntry maker and Checker, fixed it in Standalone, need to check in cluster and in prod
	url = "/webdesktop/CustomForms/RAKBANK/WIIntroduce.jsp";
	//alert('2');
	var param="&ProcessName="+processName+"&WIData="+window.document.getElementById("WIData").value;
	//alert(param);
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		//alert('3');
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 
		 		sResult = 	 ajaxResult;
		// return ajaxResult;
	}
	//*****************************************************************************************************************************
	
	if(sResult == undefined)
	{
		//window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
		
//		alert("Error");
	}
	else
	{
		
		alert(sResult);
		if (sResult.indexOf('Created')==-1)
		{
			window.parent.close();
		}
		window.parent.frames['frameClose'].document.forms[0].elements["Introduce"].setAttribute('disabled', false);
				
	}

}

//----------------------------------------------------------------------------------------------------
//Function Name                    : ClearAll()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Clear all the textboxes and comboboxes.
//----------------------------------------------------------------------------------------------------

function ClearAll()
{
	var dataForm=document.forms.dataform;

	for(var i=0;i<dataForm.elements.length;i++){
		if(dataForm.elements[i].type=='text'){
			if(!dataForm.elements[i].readOnly){
				dataForm.elements[i].value="";
			}
			else if(dataForm.elements[i].id.indexOf('Date_')!=-1){//Clear date fields
				//----------------------------------------------------------------------------------------------------
				// Changed By						:	Manish K. Agrawal
				// Reason / Cause (Bug No if Any)	:	(RLS-OF_Defect_AL_PD_C1_26.xls)
				// Change Description				:	Clear All button clears Next Installment Date & Loan Maturity Date along with the Request details field values.
				//----------------------------------------------------------------------------------------------------

				if(dataForm.elements[i].name!='NextInstDate' && dataForm.elements[i].name!='LoanMaturityDate')
					dataForm.elements[i].value='';
			}
		}else if(dataForm.elements[i].type=='select-one'){
			dataForm.elements[i].selectedIndex=0;
		}else if(dataForm.elements[i].type=='textarea'){
			dataForm.elements[i].value="";
		}
	}	
}

//----------------------------------------------------------------------------------------------------
//Function Name                    : Load()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Loads the default values.
//----------------------------------------------------------------------------------------------------

function load(){
	
	document.forms.dataform.BRANCHDATETIME.value=LocalToDB(document.forms.dataform.BRANCHDATETIME.value, strDateFormat +" hh:mm:ss");
	try{
		var debitAcc = document.forms.dataform.FundingACNo.value;
		if(debitAcc.length!=0 && debitAcc.length==13){
			debitAcc = debitAcc.substring(0,4)+"-"+debitAcc.substring(4,10)+"-"+debitAcc.substring(10);
		}
		document.forms.dataform.DebitAccount.value =debitAcc;	
		//document.forms.dataform.DebitAccount.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}
	try{
		document.forms.dataform.DebitAccount_ForCharge.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}
	try{
		document.forms.dataform.AcToCredit.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}
	try{
		document.forms.dataform.AccountNo.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}	
	try{
		document.forms.dataform.FundingAccount.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}	
	try{
		document.forms.dataform.DBTACCCHRG.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}
	try{
		document.forms.dataform.RBGUA.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}
	try{
		document.forms.dataform.DBTACC.value = document.forms.dataform.FundingACNo.value;
	}catch(e){		
	}
	try{
		if(document.forms.dataform.ProcessCode.value=='AL_TOO' || document.forms.dataform.ProcessCode.value=='AL_CVDE' ){

			document.getElementById('C_CHARGESRECEIVED').style.display='none';
			document.getElementById('CHARGESRECEIVED').style.display='none';			
		}
	}catch(e){}
	try{
		if(document.forms.dataform.ProcessCode.value=='AL_TRL'){

			document.getElementById('C_CHRGREC').style.display='none';
			document.getElementById('CHRGREC').style.display='none';
			
		}
	}catch(e){}
	//RLS Change-2, Date: 30/10/2007, By: Piyush Kumar
	try{
		if(document.forms.dataform.ProcessCode.value=='GSR_LCOL' ){

			document.forms.dataform.DebitAccount.disabled=true;			
		}
	}catch(e){}
	// changes end.
	//----------------------------------------------------------------------------------------------------
	// Changed By						:	Manish K. Agrawal
	// Reason / Cause (Bug No if Any)	:	Charge Amt should be default to 0.(RKB-RLS-ALS-CRF-0005)
	// Change Description				:	Charge Amt should be default to 0.
	//----------------------------------------------------------------------------------------------------
	try{
		document.forms.dataform.ChargeAmount.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.SecurityDepRef.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.DepositAmount.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.CHARGESAMOUNT.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.AmountReceived.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.AmtReceived.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.ChargesReceived.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.ChargesRecvd.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.Charges.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.DEPAMT.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.CHRGAMT.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.LoanOutstandingBalance.value = document.forms.dataform.OutstandingLoanAmt.value;
	}catch(e){		
	}

	//----------------------------------------------------------------------------------------------------
	// Changed By						:	Manish K. Agrawal
	// Reason / Cause (Bug No if Any)	:	Charge Amt should be default to 0.(RKB-RLS-GSR-LCOL-0001)
	// Change Description				:	Charge Amt should be default to 0.
	//----------------------------------------------------------------------------------------------------

	try{
		document.forms.dataform.Amount.value = "0";
	}catch(e){		
	}
	try{
		document.forms.dataform.AmountOnHold.value = "0";
	}catch(e){		
	}
   
}

//----------------------------------------------------------------------------------------------------
//Function Name                    : Print()
//Date Written (DD/MM/YYYY)        : 17-Oct-2006
//Author                           : Manish K. Agrawal
//Input Parameters                 : NA
//Output Parameters                : NA
//Return Values                    : NA
//Description                      : Print the request.
//----------------------------------------------------------------------------------------------------

function Print()
{
	var sFeatures="dialogHeight:1000px, dialogWidth:1200px, center=yes,resizable=1 ";
	//var sResult = window.showModalDialog('Print.jsp',document.forms.dataform,sFeatures);
	var sResult = window.open('Print.jsp','','center=yes,resizable=0, width=776,height=600,scrollbars=1');
	if(sResult == undefined)
	{
		alert("Error");
	}
}

</script>


<!----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0049/RKB-RLS-ALS-CMA-0050)
// Change Description				:	add event onkeydown='checkShortcut()' on body load to disable Backspace button
//---------------------------------------------------------------------------------------------------->
<BODY topmargin=0 leftmargin=15 onload='load()' class='EWGeneralRB' onkeydown='checkShortcut()'>

<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;

//----------------------------------------------------------------------------------------------------
// Changed By						:	Manish K. Agrawal
// Reason / Cause (Bug No if Any)	:	(RKB-RLS-ALS-CMA-0054/RKB-RLS-ALS-CMA-0055/RKB-RLS-ALS-CMA-0056/RKB-RLS-ALS-CMA-0057/RKB-RLS-ALS-CMA-0058/RKB-RLS-ALS-CMA-0084/RKB-RLS-ALS-CMA-0085)
// Change Description				:	Session Expires, Handling(RKB-RLS-ALS-CMA-0054)
//---------------------------------------------------------------------------------------------------->
	String a="";
	String b="";
	
	try{
	
	    WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		WriteLog("sCabname :"+sCabname);
        sSessionId    = wDUserInfo.getM_strSessionId();
		WriteLog("sSessionId :"+sSessionId);
		sJtsIp = wDCabinetInfo.getM_strServerIP();
        iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
		WriteLog("iJtsPort :"+iJtsPort);
		
	}catch(WFException ignore){
		a=ignore.getMainCode();
		b=ignore.getSource();
	}
  
  if (a.equals("-50146") || a.equals("4002") || a.equals("11") || a.equals("4020"))
  {
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); //Close the browser
		out.println("</script>");
		return;
  }

	//MQ Integration
	String strCompCode="",strReasonCode="";	
//	DateFormat dt = new SimpleDateFormat(DateFormat + " hh:mm:ss:SS");
//	String strDate = dt.format(new java.util.Date());

//	String msgID=wfsession.getUserName()+"_"+strAgrNo+"_"+strDate;	//msgID="supervisor_1223_14/09/2006 04:57:57:717";
        WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		String suserName = wDUserInfo.getM_strUserName()+"";
	String sInputXML =	"<?xml version=\"1.0\"?>\n" +
	"<APMQPutGetMessage_Input>\n" +
	"<Option>APMQPutGetMessage</Option>\n" +
	"<UserID>"+suserName+"</UserID>";	
	if (strAgrNo.equals("") || strAgrNo==null){
		sInputXML =	sInputXML + "<AgreementNo>"+strEqLoanACNo+"</AgreementNo>";
	}else{
		sInputXML =	sInputXML + "<AgreementNo>"+strAgrNo+"</AgreementNo>";
	}
	sInputXML =	sInputXML + "<SessionId>"+sSessionId+"</SessionId>\n"+
	"<EngineName>"+sCabname+"</EngineName>\n" +
	"</APMQPutGetMessage_Input>\n";
	
	

	WriteLog(sInputXML);
	String responseMsg="";
	
	try{
		//responseMsg= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		responseMsg = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
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
			out.println("<td width=50% height='16' ><b><font color='red'>"+responseMsg.substring(responseMsg.indexOf("<Description>")+13,responseMsg.indexOf("</Description>"))+"</font></B></td>");
			out.println("<td width=30% height='16'><b><font color='red'>&nbsp;"+responseMsg.substring(responseMsg.indexOf("<ErrorMessageReasonCode>")+24,responseMsg.indexOf("</ErrorMessageReasonCode>"))+"</font></B></td>");
			out.println("</tr>");
			out.println("</table>");				
		}
	}
			
	catch(Exception exp){
		WriteLog(exp.toString());		
	}
	

//String strInpXML = "?xml version=\"1.0\"?><AgreementNo>" + strAgrNo + "</AgreementNo><EquationLoanAccountNo>" + strEqLoanACNo + "</EquationLoanAccountNo>";
//WriteLog("Input XML"+strInpXML);
//String responseMsg="";

//Put Message
//try{
//	mqGetPutMessage objGetPutMsg= new mqGetPutMessage();
//	objGetPutMsg.mqConnect();
//	objGetPutMsg.mqPutMsg(strAgrNo + "_" + strEqLoanACNo,strInpXML);
//	objGetPutMsg.mqDisconnect();
//}
//catch(Exception ignore){
//	WriteLog(ignore.toString());
//}
//Get Message
//try{
//	mqGetPutMessage objGetPutMsg= new mqGetPutMessage();
//	objGetPutMsg.mqConnect();
//	responseMsg = objGetPutMsg.mqGetMsg("A_" + strAgrNo + "_" + strEqLoanACNo);
//	objGetPutMsg.mqDisconnect();
//}
//catch(Exception ignore){
//	WriteLog(ignore.toString());
//}

//Added for Testing in Offshore
/*responseMsg =	"<?xml version=\"1.0\"?>\n" +
	"<APAPMQPutGetMessage_Output>\n" +
	"<Option>APMQPutGetMessage</Option>\n" +
	"<CompletionCode>0</CompletionCode>\n"+
	"<ReasonCode>0</ReasonCode>\n"+
	"<APPLICANTNAME>ABCD</APPLICANTNAME>\n"+
	"<REQUESTEDLNAMT>100000</REQUESTEDLNAMT>\n"+
	"<INTERESTRATE>7.5</INTERESTRATE>\n"+
	"<TENOR>120</TENOR>\n"+
	"<LOANMATURITYDATE>21/07/2025</LOANMATURITYDATE>\n"+
	"<FUNDINGACCOUNT>546434646341324</FUNDINGACCOUNT>\n"+
	"<SCHEMEDESC>AMAL_P</SCHEMEDESC>\n"+
	"<UNMATUREDPRINCIPAL>56612</UNMATUREDPRINCIPAL>\n"+
	"<NEXTINSTLAMT>35000</NEXTINSTLAMT>\n"+
	"<NEXTINSTLDATE>08/09/2020</NEXTINSTLDATE>\n"+
	"<REPAYMENTMODE>R</REPAYMENTMODE>\n"+
	"<DelinquencyString>T24</DelinquencyString>\n"+
	"<NPAStage>F</NPAStage>\n"+
	"<InstallmentPastDues>0</InstallmentPastDues>\n"+
	"<ChargesPastDues>500</ChargesPastDues>\n"+
	"<PENALTY_LPI_LEVIED>10</PENALTY_LPI_LEVIED>\n"+
	"<PENALTYRECEIVED>0</PENALTYRECEIVED>\n"+
	"<TOTALRECEIVABLECHARGES>12458</TOTALRECEIVABLECHARGES>\n"+
	"<TOTALAMTRECVDAGNSTCHRGS>1258</TOTALAMTRECVDAGNSTCHRGS>\n"+
	"<TotalPastDues>1245</TotalPastDues>\n"+
	"<MATUREDPRINCIPAL>10000</MATUREDPRINCIPAL>\n"+
	"<PRINCIPALPAID>15000</PRINCIPALPAID>\n"+
	"<MATUREDINTEREST>7</MATUREDINTEREST>\n"+
	"<INTERESTPAID>7.1</INTERESTPAID>\n"+
	"<BUCKET>52</BUCKET>\n"+
	"</APAPMQPutGetMessage_Output>\n";*/
	
WriteLog("Output XML:"+responseMsg);

strCompCode	= responseMsg.substring(responseMsg.indexOf("<CompletionCode>")+16,responseMsg.indexOf("</CompletionCode>"));	
strReasonCode= responseMsg.substring(responseMsg.indexOf("<ReasonCode>")+12,responseMsg.indexOf("</ReasonCode>"));

String strBranch ="", strCustName = "",strAppLoanAmt = "", strIntRate = "", strTenor = "", strLoanMaturityDate = "", strFundingACNo = "", strProductScheme = "", strOutstandingLoanAmount = "", strNextInstAmount = "", strNextInstallmentDate = "", strRepaymentMode = "",  strDelinquencyString = "", strNPAStage =  "", strInstallmentPastDues = "", strChargesPastDues = "", strTotalPastDues = "", strBucket = "";

try{
	if(strCompCode.equals("0") && strReasonCode.equals("0")){
		//strBranch = responseMsg.substring(responseMsg.indexOf("<Branch>")+8,responseMsg.indexOf("</Branch>"));
		strCustName = responseMsg.substring(responseMsg.indexOf("<APPLICANTNAME>")+15,responseMsg.indexOf("</APPLICANTNAME>"));
		strAppLoanAmt = responseMsg.substring(responseMsg.indexOf("<REQUESTEDLNAMT>")+16,responseMsg.indexOf("</REQUESTEDLNAMT>"));
		strIntRate = responseMsg.substring(responseMsg.indexOf("<INTERESTRATE>")+14,responseMsg.indexOf("</INTERESTRATE>"));
		strTenor = responseMsg.substring(responseMsg.indexOf("<TENOR>")+7,responseMsg.indexOf("</TENOR>"));
		strLoanMaturityDate = responseMsg.substring(responseMsg.indexOf("<LOANMATURITYDATE>")+18,responseMsg.indexOf("</LOANMATURITYDATE>"));
		strFundingACNo = responseMsg.substring(responseMsg.indexOf("<FUNDINGACCOUNT>")+16,responseMsg.indexOf("</FUNDINGACCOUNT>"));
		strProductScheme = responseMsg.substring(responseMsg.indexOf("<SCHEMEDESC>")+12,responseMsg.indexOf("</SCHEMEDESC>"));
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
			//strChargesPastDues = Double.toString(Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<PENALTY_LPI_LEVIED>")+20,responseMsg.indexOf("</PENALTY_LPI_LEVIED>"))) - Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<PENALTYRECEIVED>")+17,responseMsg.indexOf("</PENALTYRECEIVED>"))) + Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<TOTALRECEIVABLECHARGES>")+24,responseMsg.indexOf("</TOTALRECEIVABLECHARGES>"))) -	Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<TOTALAMTRECVDAGNSTCHRGS>")+25,responseMsg.indexOf("</TOTALAMTRECVDAGNSTCHRGS>"))));
                   DecimalFormat ab =new DecimalFormat("0.00");
                  strChargesPastDues = ab.format(Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PENALTY_LPI_LEVIED>")+20,responseMsg.indexOf("</PENALTY_LPI_LEVIED>"))) - Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PENALTYRECEIVED>")+17,responseMsg.indexOf("</PENALTYRECEIVED>"))) + Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<TOTALRECEIVABLECHARGES>")+24,responseMsg.indexOf("</TOTALRECEIVABLECHARGES>"))) -	Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<TOTALAMTRECVDAGNSTCHRGS>")+25,responseMsg.indexOf("</TOTALAMTRECVDAGNSTCHRGS>"))));
		}catch(Exception e){
			WriteLog("strChargesPastDues: "+ e.toString());
		}

		//-------------------------------------------------------
		strTotalPastDues = "";
		//strTotalPastDues = responseMsg.substring(responseMsg.indexOf("<TotalPastDues>")+15,responseMsg.indexOf("</TotalPastDues>"));
		//-------------------------------------------------------
		try{
			//strTotalPastDues = Double.toString(Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<MATUREDPRINCIPAL>")+18,responseMsg.indexOf("</MATUREDPRINCIPAL>"))) - Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<PRINCIPALPAID>")+15,responseMsg.indexOf("</PRINCIPALPAID>"))) + Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<MATUREDINTEREST>")+17,responseMsg.indexOf("</MATUREDINTEREST>"))) -	Double.parseDouble(responseMsg.substring(responseMsg.indexOf("<INTERESTPAID>")+14,responseMsg.indexOf("</INTERESTPAID>"))));
                   DecimalFormat ab2 =new DecimalFormat("0.00");
                  strTotalPastDues = ab2.format(Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<MATUREDPRINCIPAL>")+18,responseMsg.indexOf("</MATUREDPRINCIPAL>"))) - Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<PRINCIPALPAID>")+15,responseMsg.indexOf("</PRINCIPALPAID>"))) + Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<MATUREDINTEREST>")+17,responseMsg.indexOf("</MATUREDINTEREST>"))) -	Float.parseFloat(responseMsg.substring(responseMsg.indexOf("<INTERESTPAID>")+14,responseMsg.indexOf("</INTERESTPAID>"))));
			WriteLog("strTotalPastDues: "+ strTotalPastDues);
		}catch(Exception e){
			WriteLog("strTotalPastDues: "+ e.toString());
		}
		//-------------------------------------------------------
		strBucket = responseMsg.substring(responseMsg.indexOf("<BUCKET>")+8,responseMsg.indexOf("</BUCKET>"));
	}
}catch(Exception e){

}

String sComboFields="";

%>

<form name="dataform"  method="Post" > 
<!--Use following header just for printing purpose--->
<input type="text" name="Header" readOnly size="24" style='display:none' value='RLS Request'>
<table border="0" cellspacing="1" cellpadding="1" style='display:none'>
	<TR>
        <td colspan=2 class="EWLabelBlue" id="ServiceTypeName" >Service-Request Type</td>
        <td><input type="text" name="ServiceTypeName" id="ServiceTypeName" readOnly size="100" value='<%=strProcessName%>' style='border:none' class="EWLabel"></td>
	</tr>
	<tr>
		<td colspan=2 class="EWLabelBlue" id="BranchNameForPrinting" >Branch</td>
        <td><input type="text" name="BranchNameForPrinting" id="BranchNameForPrinting" readOnly size="100" value='<%=strBranchName%>' style='border:none' class="EWLabel"></td>
	</tr>
	<tr>
		<td colspan=2 class="EWLabelBlue" id="AgreementNo" >Agreement No</td>
        <td><input type="text" name="AgreementNo" id="AgreementNo" readOnly size="100" value='<%=strAgrNo%>' style='border:none' class="EWLabel"></td>
	</tr>
	<tr>
		<td colspan=2 class="EWLabelBlue" id="EquationLoanAccNo" >Equation Loan A/C No</td>
        <td><input type="text" name="EquationLoanAccNo" id="EquationLoanAccNo" readOnly size="100" value='<%=strEqLoanACNo%>' style='border:none' class="EWLabel"></td>
	</tr>
</table>

<table border="1" cellspacing="1" cellpadding="1" id="loanDetails" width=100%>
	<tr class="EWHeader" width=100% class="EWLabelRB2">
		<td colspan=6 align=left class="EWLabelRB3"><b>Loan Details</b></td>
	</tr>
	<!--<tr>
		<td class="EWLabel1">Branch</td>
		<td><input type="text" name="Branch" size="24" readOnly value="<%=Branch%>" style='border:none' class="EWLabel" ></td>
        <td class="EWLabel1">Agreement No.:</td>
        <td><input type="text" name="AgreementNo" size="24" readOnly value="<%=AgreementNo%>" style='border:none' class="EWLabel"></td>
		<td class="EWLabel1">Equation Loan Account No.:</td>
        <td><input type="text" name="EquationLoanAccNo" size="24" readOnly value="<%=EquationLoanAccNo%>" style='border:none' class="EWLabel"></td>
	</tr>-->
	<tr>
		<input type="text" name="Header" readOnly size="24" style='display:none' value='Loan Details'>
		<td class="EWLabelRB2" nowrap width="140" height="22" id ="CustomerName">Customer Name</td>
		<td nowrap width="140" height="22"><input type="text" name="CustomerName" size="24" maxlength="300" id="T" readOnly value="<%=strCustName%>" ></td>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="ProductOrScheme">Product/Scheme</td>
		<td nowrap width="140" height="22"><input type="text" name="ProductOrScheme" size="35" id="T" maxlength="8" readOnly value="<%=strProductScheme%>"></td>
	</tr>


	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="NPAStage">NPA Stage</td>
		<td nowrap width="140" height="22"><input type="text" name="NPAStage" size="24" id="T" maxlength="256" readOnly value="<%=strNPAStage%>" ></td>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="AppLoanAmt">Approved Loan Amount</td>
		<td nowrap width="140" height="22"><input type="text" name="AppLoanAmt" size="24" id="F_" maxlength="8" readOnly value="<%=strAppLoanAmt%>"></td>
	</tr>
         
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22"  id="OutstandingLoanAmt">Outstanding Loan Amount</td>
		<td nowrap width="140" height="22"><input type="text" name="OutstandingLoanAmt" size="24" id="F_" maxlength="22" readOnly value="<%=strOutstandingLoanAmount%>"></td>
		<!--<td class="EWLabelRB2" nowrap width="140" height="22" id="InstPostDues">Installment PastDues</td>
		<td nowrap width="140" height="22"><input type="text" name="InstPastDues" size="24" id="T" readOnly value="<%=strInstallmentPastDues%>"></td>-->
		<td class="EWLabelRB2" nowrap width="140" height="22"  id="InterestRate">Interest Rate</td>
		<td nowrap width="140" height="22"><input type="text" name="InterestRate" size="24" id="T" maxlength="12" readOnly value="<%=strIntRate%>"></td>
	</tr>
	<tr>
		<td  nowrap width="140" height="22" class="EWLabelRB2"  id="NextInstAmt">Next Inst. Amount</td>
		<td nowrap width="140" height="22"><input type="text" name="NextInstAmt" size="24" id="F_" maxlength="22" readOnly value="<%=strNextInstAmount%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="ChargesPostDues">Charges PastDues</td>
		<td nowrap width="140" height="22"><input type="text" name="ChargesPostDues" size="24" id="T" maxlength="256" readOnly value="<%=strChargesPastDues%>"></td>
	</tr>
	<tr>		
		<td class="EWLabelRB2" nowrap width="140" height="22"  id="Tenor">Tenor</td>
		<td nowrap width="140" height="22"><input type="text" name="Tenor" size="24" id="T" maxlength="3" readOnly value="<%=strTenor%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="NextInstDate">Next Installment Date</td>
		<td nowrap width="140" height="22"><input type="text" name="NextInstDate" id="Date_NextInstDate" size="24" id="D" maxlength="10" readOnly value="<%=strNextInstallmentDate%>"></td>
		<!--<td nowrap width="140" height="22"><input type="text" name="NextInstDate" id="Date_NextInstDate" size="24" id="D" maxlength="10" readOnly value=""></td>-->
	</tr>
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22"  id="TotalPostDues">Total PastDues</td>
		<td nowrap width="140" height="22"><input type="text" name="TotalPostDues" size="24" id="F_" maxlength="256" readOnly value="<%=strTotalPastDues%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="LoanMaturityDate">Loan Maturity Date</td>
		<td nowrap width="140" height="22"><input type="text" name="LoanMaturityDate" id="Date_LoanMaturityDate" size="24" id="D" maxlength="10" readOnly value="<%=strLoanMaturityDate%>"></td>
		<!--<td nowrap width="140" height="22"><input type="text" name="LoanMaturityDate" id="Date_LoanMaturityDate" size="24" id="D" maxlength="10" readOnly value=""></td>-->
	</tr>	
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="RepaymentMode">Repayment Mode</td>
		<td nowrap width="140" height="22"><input type="text" name="RepaymentMode" size="24" id="T" maxlength="12" readOnly value="<%=strRepaymentMode%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="Bucket">Bucket</td>
		<td nowrap width="140" height="22"><input type="text" name="Bucket" size="24" id="T" maxlength="3" readOnly value="<%=strBucket%>"></td>		
	</tr>
	<tr>
		<td class="EWLabelRB2" nowrap width="140" height="22" id="FundingACNo">Funding A/C No.</td>
		<td nowrap width="140" height="22"><input type="text" name="FundingACNo" size="24" id="T"  maxlength="15" readOnly value="<%=strFundingACNo%>"></td>
		<td class="EWLabelRB2" nowrap width="140" height="22"  id="Delinquency">Delinquency String</td>
		<td nowrap width="140" height="22"><input type="text" name="Delinquency" size="24" id="T"  maxlength="256" readOnly value="<%=strDelinquencyString%>"></td>
	</tr>

</table>

<%
	boolean bError=false;	
	sInputXML =	"<?xml version=\"1.0\"?>\n" +
	"<APProcedure_Input>\n" +
	"<Option>APProcedure</Option>\n" +
	"<ProcName>RB_GETFORMFIELDS</ProcName>" +
	"<Params>'"+ strProcessCode +"'</Params>\n" +
	//"<NoOfCols>1</NoOfCols>" +
	"<SessionId>"+sSessionId+"</SessionId>\n"+
	"<EngineName>"+sCabname+"</EngineName>\n" +
	"</APProcedure_Input>";
	
	/*sInputXML ="<?xml version=\"1.0\"?>" + 				
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>RB_GETFORMFIELDS</ProcName>" +						
						"<Params>'"+strProcessCode+"'</Params>" +  
						"<NoOfCols>4</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabname+"</EngineName>" +
						"</APProcedure2_Input>";*/
	
	WriteLog("APProcedure_Input: "+sInputXML);
	String sOutputXML="";
	try{
		//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog("RB_GETFORMFIELDS output: "+sOutputXML);		
		if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0){
			bError= true;
		}
	}catch(Exception exp){
		bError=true;
		WriteLog(exp.toString());		
	}
	
	if (Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))==11){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); //Close the browser
		out.println("</script>");
	}


	if(sOutputXML.indexOf("<Record>") == -1){
		WriteLog("No Record Found.");		
	}else {
		out.println("<table width='100%' border=1 cellspacing=1 cellpadding=1>");
		out.println("<input type='text' name='Header' readOnly size='24' style='display:none' value='Request Details'>");
		out.println("<tr class=EWHeader width='100%'><td colspan=4 align=left class='EWLabelRB3'><b>Request Details</b></td></tr>");
		try{
			int iCols=0; //Display fields in two columns
			WFXmlResponse xmlResponse = new WFXmlResponse(sOutputXML);
			WFXmlList RecordList;
			for (RecordList =  xmlResponse.createList("Records", "Record");RecordList.hasMoreElements(); RecordList.skip()){
				if (iCols%2==0){
					out.println("<tr>");
					out.println("<td class=EWLabelRB nowrap width=170 height=22 id="+RecordList.getVal("FIELD_NAME")+">"+RecordList.getVal("FIELD_DESC")+"</td>");
				}else{
					out.println("<td class=EWLabelRB nowrap width=170 height=22 id="+RecordList.getVal("FIELD_NAME")+">"+RecordList.getVal("FIELD_DESC")+"</td>");
				}

				if(RecordList.getVal("FIELD_TYPE").equals("C")){            //rakbank change for enable disable combo 09/07/2007 sachin arora
					        
					sComboFields=sComboFields+",'"+RecordList.getVal("FIELD_NAME")+"'";

					if (strProcessCode.equals("PL_PS") && RecordList.getVal("FIELD_NAME").equals("ServiceType")){
                    out.println("<td ><select name="+RecordList.getVal("FIELD_NAME")+" id=C_"+RecordList.getVal("FIELD_NAME")+" style='width:170px' onClick=setValue(this)    onblur=enableDisableCombo()>");
					out.println("<option>---------------Select------------</option>");
					out.println("</select></td>");
					}
                else {
					out.println("<td ><select name="+RecordList.getVal("FIELD_NAME")+" id=C_"+RecordList.getVal("FIELD_NAME")+" style='width:170px' onchange=setValue(this)>");
					out.println("<option>---------------Select------------</option>");
					out.println("</select></td>");
				}
				}
				else if(RecordList.getVal("FIELD_TYPE").equals("D"))
				{
					//pass id of text to initialize function that will return date to the same control. so id must be different.
					out.println("<td ><input size=24 type=text name="+RecordList.getVal("FIELD_NAME")+" id='Date_"+RecordList.getVal("FIELD_NAME")+"' maxlength="+RecordList.getVal("FIELD_LENGTH")+" style='width:170px' readonly><a href='1' onclick = \"initialise('Date_"+RecordList.getVal("FIELD_NAME")+"');return false;\" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a></td>");
				}
				else if(RecordList.getVal("FIELD_TYPE").equals("T"))
				{
					out.println("<td ><input size=24 type=text name="+RecordList.getVal("FIELD_NAME")+" id=T maxlength="+RecordList.getVal("FIELD_LENGTH")+"  onkeydown=validateCCN(this) onKeyUp=validateKeys(this,'alphanumeric') onblur=\"validateKeys_OnBlur(this,'alphanumeric');CheckFormat(this)\" style='width:170px'></td>");//;CheckFormat(this);
				}
				else if(RecordList.getVal("FIELD_TYPE").equals("A"))        // rakbank changes 02/07/2007
				{
					out.println("<td ><textarea rows=3 cols=20 name="+RecordList.getVal("FIELD_NAME")+" id=A maxlength="+RecordList.getVal("FIELD_LENGTH")+" onKeyUp=maxlengthchk(this) ></textarea></td>");//;CheckFormat(this);
				}


				else if(RecordList.getVal("FIELD_TYPE").equals("N"))
				{
					out.println("<td><input size=24 type=text name="+RecordList.getVal("FIELD_NAME")+" id=N maxlength="+RecordList.getVal("FIELD_LENGTH")+" style='width:170px' onKeyUp=validateKeys(this,'numeric') onblur=validateKeys_OnBlur(this,'numeric')></td>");
				}
                  
				else if(RecordList.getVal("FIELD_TYPE").equals("F"))
				{
					int iInt = Integer.parseInt(RecordList.getVal("FIELD_LENGTH").substring(0,RecordList.getVal("FIELD_LENGTH").indexOf(",")));
					int iDec = Integer.parseInt(RecordList.getVal("FIELD_LENGTH").substring(RecordList.getVal("FIELD_LENGTH").indexOf(",")+1));

					int iLength=iInt+iDec+1;
					
					out.println("<td><input size=24 type=text name="+RecordList.getVal("FIELD_NAME")+" id=F_"+RecordList.getVal("FIELD_LENGTH")+" style='width:170px' maxlength="+iLength+" onKeyUp=validateKeys(this,'float') onblur=validateKeys_OnBlur(this,'float',"+RecordList.getVal("FIELD_LENGTH")+")></td>");

				}
				if ((iCols%2)==1){
					out.println("</tr>");	
				}
				iCols=iCols+1;
				}

				if(!sComboFields.equals(""))
				{
					//----------------------------------------------------------------------------------------------------
					// Changed By						:	Manish K. Agrawal
					// Reason / Cause (Bug No if Any)	:	(RLS-OF_Defect_AL_PD_C1_07.xls)
					// Change Description				:	Payment Mode picklist shows A/C Credit instead of A/C Debit, it should be A/C Debit as per FSD.

					//----------------------------------------------------------------------------------------------------

					//String Query="select FIELD_NAME, FIELD_VALUE from RB_MASTER with(nolock) Where PROCESS_NAME='" + strProcessCode + "' and FIELD_NAME IN  ("+sComboFields.substring(1,sComboFields.length())+") order by Field_Value";
					
					
					String Query="select FIELD_NAME, FIELD_VALUE from RB_MASTER with(nolock) Where PROCESS_NAME=:PROCESS_NAME and FIELD_NAME IN  ("+sComboFields.substring(1,sComboFields.length())+") order by Field_Value";
					
					
					String params ="PROCESS_NAME==" + strProcessCode;
					
					//String sInputXML1 ="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + Query + "</Query><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					
					String sInputXML1 ="<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
					
					WriteLog(sInputXML1);
					String sOutputXML1="";
					try{
						//sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
						sOutputXML1 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML1);
						WriteLog(sOutputXML1);
						if(sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))!=0)
						{
							
						}
						else{
							if(sOutputXML1.indexOf("<Record>")!=-1)
							{
								WFXmlResponse xmlResponse1 = new WFXmlResponse(sOutputXML1);
								WFXmlList RecordList1;
								for (RecordList1 =  xmlResponse1.createList("Records", "Record");RecordList1.hasMoreElements();RecordList1.skip())
								{
									//String sFieldName=RecordList1.getVal("tr").substring(RecordList1.getVal("tr").indexOf("<td>")+4,RecordList1.getVal("tr").indexOf("</td>"));
									//String sFieldValue=RecordList1.getVal("tr").substring(RecordList1.getVal("tr").lastIndexOf("<td>")+4,RecordList1.getVal("tr").lastIndexOf("</td>"));

									String sFieldName=RecordList1.getVal("FIELD_NAME");
									String sFieldValue=RecordList1.getVal("FIELD_VALUE");
									
									out.println("<script>");
									out.println("try{");
									out.println("var optn=document.createElement('option');");
									out.println("var obj=document.getElementById('C_"+sFieldName+"');");
									out.println("optn.text='"+sFieldValue+"';");
									out.println("optn.value='"+sFieldValue+"';");
									out.println("obj.options.add(optn);");
									out.println("}catch(e){}");
									out.println("</script>");

								}
							
							}
						}
					}
					catch(Exception exp){
						WriteLog(exp.toString());
					}
				}
			}catch(Exception ex){
				WriteLog(ex.toString());
			}
			out.println("</table>")	;
		}
//		document.forms.dataform.OK.disabled=true;
		out.println("<script>");
		out.println("window.parent.frames['frmData'].fetch()");
		out.println("</script>");

//		Fetching Collection Branch
		String sCollectionBranch="";
		String sCollectionBranchQuery="Select branchid from RB_Branch_Details where iscollectionrequired=:iscollectionrequired";
		String params = "iscollectionrequired==Y";
		//String sInputXML1 ="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + sCollectionBranchQuery + "</Query><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
		
		String sInputXML1 ="<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + sCollectionBranchQuery + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
		
		//out.println(sInputXML1);
					WriteLog(sInputXML1);
					String sOutputXML1="";
					try{
						//sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
						sOutputXML1 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML1);
						WriteLog(sOutputXML1);
						sCollectionBranch=sOutputXML1.substring(sOutputXML1.indexOf("<td>")+4,sOutputXML1.indexOf("</td>"));											}
					catch(Exception e)
					{
						WriteLog(e.getMessage());
					}
%>



<!--Pass these values to WIForm.JSP to save it in database using WIUpload call--->
<input type=text readOnly name="ProcessCode" id="ProcessCode" value='<%=strProcessCode%>' style='display:none'>
<input type=text readOnly name="Branch" id="Branch" value='<%=strBranchCode%>' style='display:none'>

<input type=text readOnly name="q_landlineno" id="q_landlineno" value="" style='display:none' > 
<input type=text readOnly name="q_mobileno" id="q_mobileno" value="" style='display:none'> 
<input type=text readOnly name="LANDLINENP" id="LANDLINENP" value="" style='display:none'>
<input type=text readOnly name="MOBILENP" id="MOBILENP" value="" style='display:none'>
<!-- rak bank changes donr by Sachin....   mobileno, landlineno substring-->

<!--<input type=text readOnly name="AgreementNo" id="AgreementNo" value='<%=strAgrNo%>' style='display:none'>-->
<!--<input type=text readOnly name="EquationLoanAccNo" id="EquationLoanAccNo" value='<%=strEqLoanACNo%>' style='display:none'>-->
<input type=text readOnly name="BranchUSERNAME" id="BranchUSERNAME" value=<%=suserName%> style='display:none'>
<input type=text readOnly name="BRANCHDATETIME" id="BRANCHDATETIME" value='<%=dateFormat%>' style='display:none'>

<!---Save Queue Variables--->
<input type=text readOnly name="Q_AGREEMENT_NO"       id="Q_AGREEMENT_NO" value='<%=strAgrNo%>' style='display:none'>
<input type=text readOnly name="Q_EQUATION_LOAN_NO"   id="Q_EQUATION_LOAN_NO" value='<%=strEqLoanACNo%>' style='display:none'>
<input type=text readOnly name="Q_CUSTOMER_NAME"      id="Q_CUSTOMER_NAME" value='<%=strCustName%>' style='display:none'>
<input type=text readOnly name="Q_BRANCH"             id="Q_BRANCH" value='<%=strBranchCode%>' style='display:none'>
<input type=text readOnly name="Q_SERVICE_REQUEST"    id="Q_SERVICE_REQUEST" value='<%=strProcessCode%>' style='display:none'>
<!--set Q_CURRENT_WORKSTEP from entry setting of next workstep-->
<!--<input type=text readOnly name="Q_CURRENT_WORKSTEP"   id="Q_CURRENT_WORKSTEP" value='' style='display:none'>-->
<input type=text readOnly name="Q_PREVIOUS_WORKSTEP"  id="Q_PREVIOUS_WORKSTEP" value='Work Introduction' style='display:none'>
<input type=text readOnly name="CSM_MAIL_ID"  id="CSM_MAIL_ID" value='<%=strCSMMailId%>' style='display:none'>
<input type=text readOnly name="BM_MAIL_ID"  id="BM_MAIL_ID" value='<%=strBMailId%>' style='display:none'>

<input type=text readOnly name="COLLECTIONBRANCH"  id="COLLECTIONBRANCH" value='<%=sCollectionBranch%>' style='display:none'>
<input type=text readOnly name="BRANCHOFINITIATION"  id="BRANCHOFINITIATION" value='<%=strBranchCode%>' style='display:none'>
<input type='text' style='display:none' id='WIData'>
</form>

</body>
</html>
