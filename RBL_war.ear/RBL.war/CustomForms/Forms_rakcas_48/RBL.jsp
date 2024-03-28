<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : RBL         
//File Name					 : RBL.jsp
//Author                     : Sajan Soda
// Date written (DD/MM/YYYY) : 
//Description                : Main Form jsp
//---------------------------------------------------------------------------------------------------->
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %><%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>


<%@ page import="java.util.Iterator"%>
<%@ include file="../RBL_Specific/Log.process"%>
<%@ include file="../header.process" %>
<%@ page import="java.io.*,java.util.*"%>
<%
createLogFile("RBL");
logger.info("parameterMap"+parameterMap);
if (parameterMap != null && parameterMap.size() > 0) {

	String sCabName=customSession.getEngineName();	
	logger.info("sCabName"+sCabName);
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String user_name = customSession.getUserName();

	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	String outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID);
	
WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";

	CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
	LinkedHashMap varIdMap = new LinkedHashMap();
	attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	session = request.getSession(false);
	logger.info("WINAME..."+WINAME);
	
	SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
    Date now = new Date();
    String strDate = sdfDate.format(now);
	
	logger.info("Date is "+strDate);
	
	String strDeferralHeld=((CustomWorkdeskAttribute)attributeMap.get("Deferral_Held")).getAttribValue().toString()==null?"No":((CustomWorkdeskAttribute)attributeMap.get("Deferral_Held")).getAttribValue().toString().trim();
	
	logger.info("StrDeferral Held is "+strDeferralHeld);
	
	//Changes 16012019
	
	String strAECBRequired=((CustomWorkdeskAttribute)attributeMap.get("AECB_Required")).getAttribValue().toString()==null?"No":((CustomWorkdeskAttribute)attributeMap.get("AECB_Required")).getAttribValue().toString().trim();
	
	logger.info("strAECBRequired Held is "+strAECBRequired);
	
	String strCBRBRequired=((CustomWorkdeskAttribute)attributeMap.get("CBRB_Required")).getAttribValue().toString()==null?"No":((CustomWorkdeskAttribute)attributeMap.get("CBRB_Required")).getAttribValue().toString().trim();
	
	logger.info("strCBRBRequired Held is "+strCBRBRequired);
	
	
	
	String strLoanType=((CustomWorkdeskAttribute)attributeMap.get("Loan_type")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("Loan_type")).getAttribValue().toString().trim();
	
	logger.info("Loan Type is "+strLoanType);
	
	String strIndustryCode=((CustomWorkdeskAttribute)attributeMap.get("IndustryCode")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("IndustryCode")).getAttribValue().toString().trim();
	strIndustryCode = strIndustryCode.trim();
	logger.info("IndustryCode is "+strIndustryCode);
	
	String strRMCode=((CustomWorkdeskAttribute)attributeMap.get("RMCode")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("RMCode")).getAttribValue().toString().trim();
	
	logger.info("RM Code is  "+strRMCode);
	
	String strROCode=((CustomWorkdeskAttribute)attributeMap.get("ROCode")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("ROCode")).getAttribValue().toString().trim();
	
	logger.info("RO Code is  "+strROCode);
	
	String strMicro=((CustomWorkdeskAttribute)attributeMap.get("Micro")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("Micro")).getAttribValue().toString().trim();
	strMicro = strMicro.trim();
	logger.info("Micro is "+strMicro);
	
	String strSector=((CustomWorkdeskAttribute)attributeMap.get("Sector")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("Sector")).getAttribValue().toString().trim();
	strSector = strSector.trim();
	logger.info("Sector is "+strSector);
	
	String strCEUDone=((CustomWorkdeskAttribute)attributeMap.get("CEUDone")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("CEUDone")).getAttribValue().toString().trim();
	strCEUDone = strCEUDone.trim();
	logger.info("CEUDone is "+strCEUDone);
	
	String strDelegationAuthority=((CustomWorkdeskAttribute)attributeMap.get("DelegationAuthority")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("DelegationAuthority")).getAttribValue().toString().trim();
	strDelegationAuthority = strDelegationAuthority.trim();
	logger.info("DelegationAuthority is "+strDelegationAuthority);
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<!--<script language="javascript" src="/BAIS/webtop/scripts/clientBAIS.js"></script>
<script language="javascript" src="/BAIS/webtop/scripts/BAIS_Script/loadFormValuesAtNextWS.js"></script>

<script language="javascript" src="/BAIS/webtop/scripts/RBL_Script/FieldValidation.js"></script>

-->
<script language="javaScript" src="/RBL/webtop/scripts/clientRBL.js"></script>
<script language="javaScript" src="/RBL/webtop/scripts/RBL_Script/calendar_RBL.js"></script>
<script language="javaScript" src="/RBL/webtop/scripts/RBL_Script/RBLIntegrate.js"></script>

<script language="javascript" src="/RBL/webtop/scripts/RBL_Script/loadDropDownValues.js"></script>
<script language="javascript" src="/RBL/webtop/scripts/RBL_Script/loadFormValuesAtNextWS.js"></script>
<script language="javascript" src="/RBL/webtop/scripts/RBL_Script/jquery-latest.js"></script>
<script language="javascript" src="/RBL/webtop/scripts/RBL_Script/jquery.autocomplete.js"></script>
<script language="javascript" src="/RBL/webtop/scripts/RBL_Script/FieldValidation.js"></script>
<script src="/RBL/webtop/scripts/RBL_Script/jquery.min.js"></script>
<script src="/RBL/webtop/scripts/RBL_Script/bootstrap.min.js"></script>
<script src="/RBL/webtop/scripts/RBL_Script/jquery-ui.js"></script> 

<HTML>

<HEAD>
<link rel="stylesheet" href="..\..\webtop\scripts\RBL_Script\bootstrap.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\RBL_Script\jquery-ui.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\docstyle.css">
<TITLE>RAK Finance Loan</TITLE>

<script>
	document.onkeydown = mykeyhandler;
	function mykeyhandler() 
	{
				var elementType=window.event.srcElement.type;
				var eventKeyCode=window.event.keyCode;
				var isAltKey=window.event.altKey;
				//alert('eventKeyCode '+eventKeyCode+' elementType '+elementType);
				if (eventKeyCode == 8 && elementType!='text' && elementType!='textarea' && elementType!='submit' && elementType!='password' ) {
					window.event.keyCode = 0;
					return false;
				}
	}
</script>

<script>
//**********************************************************************************//
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank BAIS
//Date Written                : 		  12-01-2018
//Date Modified               : 		  12-01-2018
//Author                      : 		  Sajan Soda
//Description                 :           This function is used to open Signature,Exception,Reject reasons and decision history window

//***********************************************************************************//		
//added by stutee.mishra
var dialogToOpenType = null;
var popupWindow=null;
function setValue(val1) 
{
   //you can use the value here which has been returned by your child window
   popupWindow = val1;
   if(dialogToOpenType == 'Exception History'){
	   if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
			var result = popupWindow.split("@");
			document.getElementById('H_CHECKLIST').value = result[0];
			//alert("the values are " +document.getElementById('H_CHECKLIST').value);
		}
   }else if(dialogToOpenType == 'Reject Reasons'){
		if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]'){
		  document.getElementById('rejReasonCodes').value = popupWindow;
		}
   }		
}
//ends here.
	
	function openCustomDialog (dialogToOpen,workstepName)
		{
			dialogToOpenType = dialogToOpen;
			if (workstepName!=null &&  workstepName!='')
			{
				//var popupWindow=null;
				var sOptions;
				if(dialogToOpen=='Decision History')
				{
					var WINAME = '<%=WINAME%>';
					
					//window.showModalDialog("../RBL_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=1000,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						window.showModalDialog("../RBL_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					} else {
						window.open("../RBL_Specific/history.jsp?WINAME="+WINAME,this,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					//Check if the call is for Ops_Maker and the call is for first time or not
					//if (workstepName=='Ops_Maker')
						//document.getElementById('flagForDecHisButton').value = 'Yes';
				}
				else if (dialogToOpen=='Reject Reasons')
				{
					var WSNAME =  workstepName;
					var WINAME = '<%=WINAME%>';
					
					var rejectReasons = document.getElementById('rejReasonCodes').value;
				
					sOptions = 'dialogWidth:500px; dialogHeight:500px; dialogLeft:450px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
					
					//popupWindow = window.showModalDialog('../RBL_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow = window.showModalDialog('../RBL_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
					} else {
						popupWindow = window.open('../RBL_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					    document.getElementById('rejReasonCodes').value = popupWindow;	
				}
				else if (dialogToOpen=='Exception History') {
					var workstepName = '<%=WSNAME%>';
					var wi_name = '<%=WINAME%>';
					var H_CHECKLIST = document.getElementById('H_CHECKLIST').value;

					sOptions = 'dialogWidth:850px; dialogHeight:500px; dialogLeft:250px; dialogTop:80px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';

					//popupWindow = window.showModalDialog('/RBL/CustomForms/RBL_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow = window.showModalDialog('/RBL/CustomForms/RBL_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
					} else {
						popupWindow = window.open('/RBL/CustomForms/RBL_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.


					//Set the response code to the input with id = H_CHECKLIST
					if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						document.getElementById('H_CHECKLIST').value = result[0];
						//alert("the values are " +document.getElementById('H_CHECKLIST').value);
					}
					
				}				
			}
		}
		function checkRemarks()
		{
			var remarks=document.getElementById("wdesk:Remarks");
			var value=document.getElementById("wdesk:Remarks").value;
			var newLength=value.length;
			var maxLength=3000;
			value=value.replace(/(\r\n|\n|\r)/gm," ");
			value=value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");
			if(newLength>=maxLength){
				value=value.substring(0,maxLength);		
			}
			document.getElementById("wdesk:Remarks").value=value;
		}
		function enableDisable(workstepName)
		{
			var addRowButton=document.getElementById("add_row");
			var addRowDeferral=document.getElementById("add_row_def");
			//var deferralHeld=document.getElementById("wdesk:Deferral_Held");
			var tenorRequested=document.getElementById("wdesk:Requested_Tenor");
			var loanType=document.getElementById("wdesk:Loan_type");
			var rakTrackNumber=document.getElementById("wdesk:RAK_Track_Number");
			var amountRequested=document.getElementById("wdesk:Requested_Amount");
			var cifID=document.getElementById("wdesk:CIF_Id");
			//var priority=document.getElementById("wdesk:Priority");
			var interestRate=document.getElementById("wdesk:Interest_rate");
			var tenorApproved=document.getElementById("wdesk:Approved_Tenor");
			var approvedAmount=document.getElementById("wdesk:Approved_Amount");
			var customerName=document.getElementById("wdesk:Customer_Name");
			
			
			//var interestRate=document.getElementById("Interest_rate");
			var agreementNo=document.getElementById("wdesk:Agreement_Number");
			var TLNumber=document.getElementById("wdesk:TLNumber");
			var rmcode = document.getElementById("wdesk:RMCode");
			//added on 2 August
			var processingFee=document.getElementById("wdesk:Processing_fee");
			
			//added for CRs 13-09-2018
			var visitDate=document.getElementById("wdesk:Visit_Date");
			var BVRDate=document.getElementById("wdesk:BVR_Date");
			var outstandingAmountprop=document.getElementById("wdesk:Outstanding_Amount");
			//Added as part of CR 16-10-2018
			var outstandingAmountapp=document.getElementById("wdesk:Outstanding_Amount_Approval");
			var ROCode = document.getElementById("wdesk:ROCode");
			//Added as part of CR 16-10-2018
			var incrementAmtReq=document.getElementById("wdesk:Incremented_Amt_Req");
			var incrementAmtApp=document.getElementById("wdesk:Incremented_Amt_App");
			var calendarVisitDate=document.getElementById("calendarVisitDate");
			var calendarBVRDate=document.getElementById("calendarBVRDate");
			var interestRateFinal=document.getElementById("wdesk:Interest_Rate_Final");
			var processingFeeFinal=document.getElementById("wdesk:Processing_Fee_Final");
			
			//CRs 16-01-2019
			var AECBRequired=document.getElementById("wdesk:AECB_Required");
			var CBRBRequired=document.getElementById("wdesk:CBRB_Required");
			var IndustryCode=document.getElementById("wdesk:IndustryCode");
			var Micro=document.getElementById("wdesk:Micro");
			var Sector=document.getElementById("wdesk:Sector");
			var FastTrack=document.getElementById("wdesk:FastTrack");
			var PolicyScore=document.getElementById("wdesk:PolicyScore");
			var AECBScore=document.getElementById("wdesk:AECBScore");
			var ChannelCode=document.getElementById("wdesk:ChannelCode");
			
			var CEUDone=document.getElementById("wdesk:CEUDone");
			var DelegationAuthority=document.getElementById("wdesk:DelegationAuthority");
			customerName.disabled=true;
			
			interestRateFinal.disabled=true;
			processingFeeFinal.disabled=true;
			tenorRequested.disabled=true;
			calendarVisitDate.disabled=true;
			calendarBVRDate.disabled=true;
			rakTrackNumber.disabled=true;
			loanType.disabled=true;
			amountRequested.disabled=true;
			cifID.disabled=true;
			//priority.disabled=true;
			processingFee.disabled=true;
			interestRate.disabled=true;
			TLNumber.disabled=true;
			rmcode.disabled=true;			
			tenorApproved.disabled=true;
			approvedAmount.disabled=true;
			document.getElementById('RejectReason').disabled = true;
			CBRBRequired.disabled=true;
			AECBRequired.disabled=true;
			ChannelCode.disabled=true;
			
			//CRs 13-09-2018
			visitDate.disabled=true;
			BVRDate.disabled=true;
			outstandingAmountprop.disabled=true;
			outstandingAmountapp.disabled=true;
			ROCode.disabled=true;
			incrementAmtApp.disabled=true;
			incrementAmtReq.disabled=true;
			agreementNo.disabled=true;
			IndustryCode.disabled=true;
			Micro.disabled=true;
			Sector.disabled=true;
			FastTrack.disabled=true;
			PolicyScore.disabled=true;
			AECBScore.disabled=true;
			CEUDone.disabled=true;
			DelegationAuthority.disabled=true;
			
			
			if(workstepName=='Quality_Control' || workstepName=='Quality_Control_Additional')
			{
				addRowButton.disabled=false;
			}
			else
			{
				addRowButton.disabled=true;
			}
			if(workstepName=="AU_Officer")
			{
				interestRateFinal.disabled=false;
				processingFeeFinal.disabled=false;
				tenorRequested.disabled=false;
				calendarVisitDate.disabled=false;
				calendarBVRDate.disabled=false;
				amountRequested.disabled=false;
				rakTrackNumber.disabled=false;
				loanType.disabled=false;
				cifID.disabled=false;
				//priority.disabled=false;
				processingFee.disabled=false;
				interestRate.disabled=false;
				customerName.disabled=false;
				TLNumber.disabled=false;
				rmcode.disabled=false;
				ROCode.disabled=false;
				visitDate.disabled=false;
				BVRDate.disabled=false;
				outstandingAmountprop.disabled=false;
				incrementAmtApp.disabled=false;
				incrementAmtReq.disabled=false;
				agreementNo.disabled=false;
				IndustryCode.disabled=false;
				Micro.disabled=false;
				Sector.disabled=false;
				FastTrack.disabled=false;
				PolicyScore.disabled=false;
				AECBScore.disabled=false;
				ChannelCode.disabled=false;
				//deferralHeld.disabled=false;
			}
			if(workstepName=="AttachAdditionalDocs")
			{
				visitDate.disabled=false;
				BVRDate.disabled=false;
				outstandingAmountprop.disabled=false;
				incrementAmtReq.disabled=false;
				calendarBVRDate.disabled=false;
				calendarVisitDate.disabled=false;
			}

			
			if(workstepName=="AttachAdditionalDocs" || workstepName=="AU_Analyst" || workstepName=="AU_Doc_Checker")
			{
				rmcode.disabled=false;
				ROCode.disabled=false;
				cifID.disabled=false;
				rakTrackNumber.disabled=false;
				loanType.disabled=false;
				amountRequested.disabled=false;
				tenorRequested.disabled=false;
				customerName.disabled=false;
				if(workstepName=="AU_Analyst" || workstepName=="AU_Doc_Checker")
				{
					TLNumber.disabled=false;
					ChannelCode.disabled=false;
				}
			}
			
			if(workstepName=="Credit_Analyst")
			{
				tenorApproved.disabled=false;
				approvedAmount.disabled=false;
				incrementAmtApp.disabled=false;
				agreementNo.disabled=false;
				interestRateFinal.disabled=false;
				processingFeeFinal.disabled=false;
				processingFee.disabled=false;
				interestRate.disabled=false;
				outstandingAmountapp.disabled=false;
				CEUDone.disabled=false;
				DelegationAuthority.disabled=false;
			}
			if(workstepName=="AU_Data_Entry")
			{
				agreementNo.disabled=false;
				customerName.disabled=false;
				TLNumber.disabled=false;
				IndustryCode.disabled=false;
				Micro.disabled=false;
				Sector.disabled=false;
				FastTrack.disabled=false;
				PolicyScore.disabled=false;
				AECBScore.disabled=false;
				ChannelCode.disabled=false;
			}
			if(workstepName=="AU_Manager")
			{
				customerName.disabled=false;
				TLNumber.disabled=false;
				IndustryCode.disabled=false;
				Micro.disabled=false;
				Sector.disabled=false;
				FastTrack.disabled=false;
				PolicyScore.disabled=false;
				AECBScore.disabled=false;
				agreementNo.disabled=false;
				ChannelCode.disabled=false;
			}
			
			if(workstepName=="Credit_Manager")
			{
				agreementNo.disabled=false;
				interestRateFinal.disabled=false;
				processingFeeFinal.disabled=false;
				outstandingAmountapp.disabled=false;
			}
			if(workstepName=="CROPS_DataEntryMaker")
			{
				agreementNo.disabled=false;
			}
			if(workstepName=="Credit_DocChecker")
			{
				outstandingAmountapp.disabled=false;
			}
			if(workstepName=="AU_Analyst")
			{
				CBRBRequired.disabled=false;
				AECBRequired.disabled=false;
				ChannelCode.disabled=false;
			}
			if(workstepName=="CROPS_DataEntryMaker" || workstepName=="CROPS_DataEntChecker" || workstepName=="CROPS_DocsChecker" || workstepName=="AttachAdditionalDocs" || workstepName=="Attach_Final_Docs")
			{
				addRowDeferral.disabled=false;
			}
			else
			{
				addRowDeferral.disabled=true;
			}
		}
		
		
		function checkDuplicateWorkitemsOnLoadAtNextWorkstep()
		{	
			var ajaxResult;
			var ProcessInstanceId ='<%=WINAME%>';
			var WSNAME =document.getElementById("wdesk:Current_WS").value;
			var Dec_AU_Analyst=document.getElementById("wdesk:Dec_AU_Analyst").value;
			var TLNumber=document.getElementById("wdesk:TLNumber").value;
			var CIF_Id=document.getElementById("wdesk:CIF_Id").value;
			var xhr;
			//if(WSNAME!='CBRB_Maker'||(WSNAME=='CBRB_Maker'&&RORejectFlag){
				if (window.XMLHttpRequest)
					xhr = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr = new ActiveXObject("Microsoft.XMLHTTP");

				var url = "/RBL/CustomForms/RBL_Specific/getDuplicateWorkitems.jsp";

				var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&Dec_AU_Analyst="+Dec_AU_Analyst+"&TLNumber="+TLNumber+"&CIF_Id="+CIF_Id;

				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);
				if (xhr.status == 200 && xhr.readyState == 4) 
				{
						ajaxResult = xhr.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
						if(ajaxResult=="-1")
						{
						 alert("Problem in getting duplicate workitems list."+ajaxResult);
						 return false;
						}
						else if(ajaxResult=="")//Blank means not found any result
						{
						 return true;
						}
						document.getElementById("duplicateWorkitemsId").innerHTML=ajaxResult;
						alert("Duplicates are identified for this request");
				} 
				else 
				{
					alert("Problem in getting duplicate workitems list."+xhr.status);
					return false;
				}	
			//}
		}
		
		function setFrameSize()
		{
			var widthToSet = document.getElementById("BAIS").offsetWidth;
			var controlName="BAIS,duplicateWorkitemsId,Decsion,uiddetails,deferraldetails";
			var fieldArray = controlName.split(",");
			var loopVar=0;
			
			while(loopVar<fieldArray.length)
			{
				if(document.getElementById(fieldArray[loopVar]))
				{
					document.getElementById(fieldArray[loopVar]).style["width"] = widthToSet+"px";
				}				
				loopVar++;	
			}
		}
		
		function checkCIFLength()
		{
			var cif=document.getElementById("wdesk:CIF_Id");
			if(cif.value.length!=7)
			{
				alert('CIF should be of exactly 7 digits');
				cif.value="";
				cif.focus();
				return false;
			}
		}
		
		function DisableFieldinReadOnlyMode()
		{
			if((parent.document.title).indexOf("(read only)")>0)
			{
				var wsname = '<%=WSNAME%>';
				
				//Start - disabling all form fields
				var form = document.getElementById("wdesk");
				var elements = form.elements;
				for (var i = 0, len = elements.length; i < len; ++i) {
				if(elements[i].id!="history")
					elements[i].disabled = true;
				}
				//End - disabling all form fields
				
				if (wsname == 'Exit')
					document.getElementById('Exception_History').disabled=false; 
			}
		}
				
		// below function added to show a tooltip on field
			$(document).ready(function() {
			$("input:text,textarea").wrap("<div class='tooltip-wrapper'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
	</script>
</script>
<BODY onload="window.parent.checkIsFormLoaded(); loadUIDGridValues('<%=WSNAME%>','<%=WINAME%>');loadDeferralGridValues('<%=WSNAME%>','<%=WINAME%>');getSOLIDOfLoggedInUser('<%=WSNAME%>','<%=customSession.getUserName()%>');loadDecisionFromMaster('<%=WSNAME%>');loadLoanTypeFromMaster('<%=WSNAME%>','<%=strLoanType%>');loadIndustryCode('<%=strIndustryCode%>');loadMicroValues('<%=strMicro%>');loadValuesInDropDown('wdesk:Sector','<%=strSector%>');loadValuesInDropDown('wdesk:CEUDone','<%=strCEUDone%>');loadValuesInDropDown('wdesk:DelegationAuthority','<%=strDelegationAuthority%>');loadRMCodeFromMaster('<%=WSNAME%>','<%=strRMCode%>');loadROCodeFromMaster('<%=WSNAME%>','<%=strROCode%>');enableDisable('<%=WSNAME%>');checkDuplicateWorkitemsOnLoadAtNextWorkstep();setFrameSize();DisableFieldinReadOnlyMode();">
<FORM name="wdesk" id="wdesk" method="post" visibility="hidden" onsubmit=''>
<div class='tooltip-wrapper'>
	<table border='1' id = "BAIS" cellspacing='1' cellpadding='0' width=100% >
		<tr  id = "BAIS_Header" width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">RAK Business Loan</font></td>
		</tr>
		<tr>
			<td colspan =4 width=100% height=100% align=right valign=center><img src='\BAIS\webtop\images\bank-logo.gif'></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Logged In As</td>
			<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%>&nbsp;<%=customSession.getUserName()%></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Workstep</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' id="Workstep" width = 25%>&nbsp;<%=WSNAME%></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Workitem Name</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%>&nbsp;<%=WINAME%></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;SOL Id</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' id="loggedInUserComment" width = 25%>&nbsp;</td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;CIF Id</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:CIF_Id' onKeyUp='ValidateNumeric("wdesk:CIF_Id");' onBlur='checkCIFLength();' maxlength='7' id='wdesk:CIF_Id' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CIF_Id")).getAttribValue().toString()%>'/></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;RAK Track Number</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' maxLength='25' onKeyup='ValidateAlphaNumeric("wdesk:RAK_Track_Number")' name='wdesk:RAK_Track_Number' id='wdesk:RAK_Track_Number' value='<%=((CustomWorkdeskAttribute)attributeMap.get("RAK_Track_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RAK_Track_Number")).getAttribValue().toString()%>'/></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Type of Loan
			</td>
			<td>
			<select name='wdesk:Loan_type' id='wdesk:Loan_type' onkeyup="" style='width:155px'>
				<option value="">--Select--</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Name</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' maxLength='100' name='wdesk:Customer_Name' id='wdesk:Customer_Name' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Customer_Name")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Customer_Name")).getAttribValue().toString()%>'/></td>
		</tr>
		<!--Modified The from Layout as part of CR 16-10-2018 Start-->
		<tr>			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;RO Code</td>
			<td>
			<select name='wdesk:ROCode' id='wdesk:ROCode' onkeyup="" style='width:155px'>
				<option value="">--Select--</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;RM Code</td>
			<td>
			<select name='wdesk:RMCode' id='wdesk:RMCode' onkeyup="" style='width:155px'>
				<option value="">--Select--</option>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;CBRB Required</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height='22' width = 25%>
			<select name='wdesk:CBRB_Required' id='wdesk:CBRB_Required' maxlength='100' style='width:155px'  style='width:170px'>
				<option value=''>--Select--</option>
			<%
				if(strCBRBRequired.equalsIgnoreCase("Yes")){
				%>
				<option value='Yes' selected>Yes</option>
				<option value='No'>No</option>
				<%
				}else {
				%>
				<option value='Yes'>Yes</option>
				<option value='No' selected>No</option>
				<% }%>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;AECB Required</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height='22' width = 25%>
			<select name='wdesk:AECB_Required' id='wdesk:AECB_Required' maxlength='100' style='width:155px'  style='width:170px'>
				<option value=''>--Select--</option>
			<%
				if(strAECBRequired.equalsIgnoreCase("Yes")){
				%>
				<option value='Yes' selected>Yes</option>
				<option value='No'>No</option>
				<%
				}else {
				%>
				<option value='Yes'>Yes</option>
				<option value='No' selected>No</option>
				<% }%>
			</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;TL Number</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25><input type='text' name='wdesk:TLNumber' id='wdesk:TLNumber' onKeyup='ValidateAlphaNumeric("wdesk:TLNumber")' maxlength='25' value='<%=((CustomWorkdeskAttribute)attributeMap.get("TLNumber")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TLNumber")).getAttribValue().toString()%>'/>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Agreement Number</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Agreement_Number' id='wdesk:Agreement_Number' onKeyup='ValidateAlphaNumeric("wdesk:Agreement_Number")' maxlength='25' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Agreement_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Agreement_Number")).getAttribValue().toString()%>'/></td>
			
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Amount (Requested)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' onkeyup='ValidateNumeric("wdesk:Requested_Amount");' onblur='onBlurForAmount("wdesk:Requested_Amount");' name='wdesk:Requested_Amount' maxLength='20' id='wdesk:Requested_Amount' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Requested_Amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Requested_Amount")).getAttribValue().toString()%>'/></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Amount (Approved)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Approved_Amount' id='wdesk:Approved_Amount' maxlength='20' onkeyup='ValidateNumeric("wdesk:Approved_Amount");' onblur='onBlurForAmount("wdesk:Approved_Amount");' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Approved_Amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Approved_Amount")).getAttribValue().toString()%>'/></td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Tenor (Requested)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' onKeyUp='ValidateNumeric("wdesk:Requested_Tenor")' maxLength='4' name='wdesk:Requested_Tenor' id='wdesk:Requested_Tenor' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Requested_Tenor")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Requested_Tenor")).getAttribValue().toString()%>'/></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Tenor (Approved)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Approved_Tenor' id='wdesk:Approved_Tenor' onkeyup='ValidateNumeric("wdesk:Approved_Tenor");' maxlength='4' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Approved_Tenor")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Approved_Tenor")).getAttribValue().toString()%>'/></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Interest Rate(Base)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Interest_rate' onkeyup='ValidateNumeric("wdesk:Interest_rate");' id='wdesk:Interest_rate' onblur='onBlurForAmount("wdesk:Interest_rate");' maxlength='5' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Interest_rate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Interest_rate")).getAttribValue().toString()%>'/></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Interest Rate(Final)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Interest_Rate_Final' id='wdesk:Interest_Rate_Final' onkeyup='ValidateNumeric("wdesk:Interest_Rate_Final");' onblur='onBlurForAmount("wdesk:Interest_Rate_Final");' maxlength='5' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Interest_Rate_Final")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Interest_Rate_Final")).getAttribValue().toString()%>'/></td>
		</tr>
		<tr>			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Processing Fee(Base)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Processing_fee' id='wdesk:Processing_fee' onkeyup='ValidateNumeric("wdesk:Processing_fee");' onblur='onBlurForAmount("wdesk:Processing_fee");' maxlength='20' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Processing_fee")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Processing_fee")).getAttribValue().toString()%>'/></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Processing Fee(Final)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Processing_Fee_Final' id='wdesk:Processing_Fee_Final' onkeyup='ValidateNumeric("wdesk:Processing_Fee_Final");' onblur='onBlurForAmount("wdesk:Processing_Fee_Final");' maxlength='20' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Processing_Fee_Final")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Processing_Fee_Final")).getAttribValue().toString()%>'/></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Outstanding Amount (Proposal)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25>
			<input type='text' name='wdesk:Outstanding_Amount' id='wdesk:Outstanding_Amount' onkeyup='ValidateNumeric("wdesk:Outstanding_Amount");' onblur='onBlurForAmount("wdesk:Outstanding_Amount");' maxLength='20' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Outstanding_Amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Outstanding_Amount")).getAttribValue().toString()%>'></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Outstanding Amount (Approval)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25>
			<input type='text' name='wdesk:Outstanding_Amount_Approval' id='wdesk:Outstanding_Amount_Approval' onkeyup='ValidateNumeric("wdesk:Outstanding_Amount_Approval");' onblur='onBlurForAmount("wdesk:Outstanding_Amount_Approval");' maxLength='20' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Outstanding_Amount_Approval")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Outstanding_Amount_Approval")).getAttribValue().toString()%>'></td>			
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Incremental Amount(Requested)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25>
			<input type='text' name='wdesk:Incremented_Amt_Req' id='wdesk:Incremented_Amt_Req' onkeyup='ValidateNumeric("wdesk:Incremented_Amt_Req");' onblur='onBlurForAmount("wdesk:Incremented_Amt_Req");' maxLength='20' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Incremented_Amt_Req")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Incremented_Amt_Req")).getAttribValue().toString()%>'></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Incremental Amount(Approved)</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25>
			<input type='text' name='wdesk:Incremented_Amt_App' id='wdesk:Incremented_Amt_App' onkeyup='ValidateNumeric("wdesk:Incremented_Amt_App");' onblur='onBlurForAmount("wdesk:Incremented_Amt_App");' maxLength='20' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Incremented_Amt_App")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Incremented_Amt_App")).getAttribValue().toString()%>'></td>
			
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Visit Date</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
			
			<%
				if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
					 WriteLog("User-Agent: "+request.getHeader("User-Agent"));
				%>
			<input type='date' name='wdesk:Visit_Date' onBlur="validateDate(this.value,'wdesk:Visit_Date');" id='wdesk:Visit_Date' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Visit_Date")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Visit_Date")).getAttribValue().toString()%>' maxlength = '24'><img src='/RBL/webtop/images/cal.gif' id='calendarVisitDate' onclick="initialize('wdesk:Visit_Date');" width='16' height='16' border='0' alt=''/>
			<% }
				else {
					WriteLog("User-Agent: "+request.getHeader("User-Agent"));
				%>
				<input type='text' name='wdesk:Visit_Date' onBlur="validateDate(this.value,'wdesk:Visit_Date');" id='wdesk:Visit_Date' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Visit_Date")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Visit_Date")).getAttribValue().toString()%>' maxlength = '24'><img src='/RBL/webtop/images/cal.gif' id='calendarVisitDate' onclick="initialize('wdesk:Visit_Date');" width='16' height='16' border='0' alt=''/>
				<% }
				%>
			
			</td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;BVR Date</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
			<%
				if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
					 WriteLog("User-Agent: "+request.getHeader("User-Agent"));
				%>
			<input type='date' name='wdesk:BVR_Date'  id='wdesk:BVR_Date' value='<%=((CustomWorkdeskAttribute)attributeMap.get("BVR_Date")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("BVR_Date")).getAttribValue().toString()%>' maxlength = '24' onBlur="validateDate(this.value,'wdesk:BVR_Date');"><img src='/RBL/webtop/images/cal.gif' id='calendarBVRDate' onclick="initialize('wdesk:BVR_Date');" width='16' height='16' border='0' alt=''/>
			<% }
				else {
					WriteLog("User-Agent: "+request.getHeader("User-Agent"));
				%>
				<input type='text' name='wdesk:BVR_Date'  id='wdesk:BVR_Date' value='<%=((CustomWorkdeskAttribute)attributeMap.get("BVR_Date")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("BVR_Date")).getAttribValue().toString()%>' maxlength = '24' onBlur="validateDate(this.value,'wdesk:BVR_Date');"><img src='/RBL/webtop/images/cal.gif' id='calendarBVRDate' onclick="initialize('wdesk:BVR_Date');" width='16' height='16' border='0' alt=''/>
				<% }
				%>
			</td>
		</tr>
		<!--Modified The Deferral Details Layout By Sajan as part of CR 16-01-2018 End-->
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Macro
			</td>
			<td>
				<select name='wdesk:IndustryCode' id='wdesk:IndustryCode' onkeyup="" style='width:155px'>
					<option value="">--Select--</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Micro
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
				<select name='wdesk:Micro' id='wdesk:Micro' onkeyup="" style='width:155px'>
					<option value="">--Select--</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Sector
			</td>
			<td>
				<select name='wdesk:Sector' id='wdesk:Sector' onkeyup="" style='width:155px'>
					<option value="">--Select--</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Fast Track
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
				<input type='text' name='wdesk:FastTrack' id='wdesk:FastTrack' maxLength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("FastTrack")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FastTrack")).getAttribValue().toString()%>'>
			</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Policy Score
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
				<input type='text' name='wdesk:PolicyScore' id='wdesk:PolicyScore' maxLength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("PolicyScore")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PolicyScore")).getAttribValue().toString()%>'>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;AECB Score
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
				<input type='text' name='wdesk:AECBScore' id='wdesk:AECBScore' maxLength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("AECBScore")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("AECBScore")).getAttribValue().toString()%>'>
			</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Channel Code
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
				<input type='text' disabled name='wdesk:ChannelCode' id='wdesk:ChannelCode' maxLength='50' value='<%=((CustomWorkdeskAttribute)attributeMap.get("ChannelCode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ChannelCode")).getAttribValue().toString()%>'>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;CEU Done</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
				<select disabled name='wdesk:CEUDone' id='wdesk:CEUDone' style='width:155px'>
					<option value="">--Select--</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Delegation Authority
			</td>
			<td>
				<select disabled name='wdesk:DelegationAuthority' id='wdesk:DelegationAuthority' style='width:155px'>
					<option value="">--Select--</option>
				</select>&nbsp;&nbsp;&nbsp;&nbsp;
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
		</tr>
		
		
		<!--*********Defferal Details*****************-->
</table>
</div>
<div id="deferraldetails"  style="overflow-y:scroll;height:250px;border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1'cellspacing='1' cellpadding='0' width=100% id ='DeferralGrid'>
		<tr id = "Deferral_Grid_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033">
			<input type='text' name='Header' readOnly style='display:none' />
			<td colspan='6' align='center' class='EWLabelRB2'><font color="white" size="4">Deferral Details</font></td>
		</tr>
		<tr>
			<td colspan='6'><input type = 'button' id = 'add_row_def' value='Add Deferrals' class='EWButtonRBSRM' style='width:150px' onclick='addrowDeferral("","<%=WSNAME%>");'/></td>
		</tr>	
		<tr bgcolor= "#990033" >
			<td width = '7%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Sr No</font></td>
			<td width ='20%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Document Type</font></td>
			<td width ='30%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Approving Authority(Name)</font></td>
			<td width ='20%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Deferral Expiry Date</font></td>
			<td width ='16%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Status</font></td>
			<td width='7%' class='EWNormalGreenGeneral1'></td>
		</tr>
	</table>
</div>
		
		
<!--*********Duplicate WorkItems Grid*****************-->
<div id="">  
	<div class="accordion-inner" id="duplicateWorkitemsId"></div>
</div>

<!--*********Decision header*****************-->
<table border='1' id = "Decsion" cellspacing='1' cellpadding='0' width=100%>
<tr  id = "RAO_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Decision</font></td>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Decision </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
		<select  class="NGReadOnlyView" style='width: 174px;' name="selectDecision" id="selectDecision" onchange="setComboValueToTextBox(this,'wdesk:Decision');">
			<option value="">--Select--</option>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='RejectReason' id="RejectReason" type='button' value='Reject Reason'  class='EWButtonRBSRM' style='width:150px' onclick="openCustomDialog('Reject Reasons','<%=WSNAME%>')">&nbsp;
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;<input name='history' id="history" type='button'value='Decision History'  class='EWButtonRBSRM' style='width:150px'  onclick="openCustomDialog('Decision History','<%=WINAME%>')" >&nbsp;
		</td>
		
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Remarks
		</td>
		<td nowrap='nowrap' colspan='2' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 50%>
		<textarea maxlength="3000" class='EWNormalGreenGeneral1' style="width:340px;white-space:pre-wrap;" rows="3" cols="50" id="wdesk:Remarks" onblur="checkRemarks();"></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = '25'>&nbsp;&nbsp;<input name='Exception_History' id="Exception_History" type='button' value='Exception History' class='EWButtonRBSRM' style='width:150px' onclick="openCustomDialog('Exception History','<%=WINAME%>')" >&nbsp;
		</td>
</tr>
</table >
<!--*********UID Details Grid*********-->
<div id="uiddetails"  style="height:200px;border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1'cellspacing='1' cellpadding='0' width=100% id ='UIDGrid'>
		<tr id = "UIDGrid_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033">
			<input type='text' name='Header' readOnly style='display:none' />
			<td colspan='4' align='center' class='EWLabelRB2'><font color="white" size="4">UID Details</font></td>
		</tr>
		<tr>
			<td colspan='4'><input type = 'button' id = 'add_row' value='Add Rows' class='EWButtonRBSRM' style='width:150px' onclick='addrowUID("","<%=WSNAME%>")'/></td>
		</tr>	
		<tr bgcolor= "#990033" >
			<td width = '10%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Sr No</font></td>
			<td width ='35%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">UID</font></td>
			<td width ='45%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Remarks</font></td>
			<td class='EWNormalGreenGeneral1'></td>
		</tr>
	</table>
</div>
<input type='hidden' id='currentDate' name='currentDate' value='<%=strDate%>'/>
<input type='hidden' id='CurrentUserName' name='CurrentUserName' value='<%=user_name%>'/>
<input type="hidden" id="wdesk:WI_NAME" name="wdesk:WI_NAME" value='<%=WINAME%>'/>
<input type='hidden' name="wdesk:Current_WS" id="wdesk:Current_WS" value='<%=WSNAME%>'/>
<input type="hidden" id="wdesk:Sol_Id" name="wdesk:Sol_Id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Sol_Id")).getAttribValue().toString()%>'>
<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
<input type="hidden" id="H_CHECKLIST" name="H_CHECKLIST"/>
<input type="hidden" id="H_CHECKLIST_TEMP" name="H_CHECKLIST_TEMP"/>
<input type='hidden' name="wdesk:Decision" id="wdesk:Decision"/>
<input type='hidden' name="wdesk:Maker_Done_On" id="wdesk:Maker_Done_On" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Maker_Done_On")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:AECB_Done_On" id="wdesk:AECB_Done_On" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AECB_Done_On")).getAttribValue().toString()%>'/>
<%
if(WSNAME.equalsIgnoreCase("Credit_Analyst") || WSNAME.equalsIgnoreCase("Credit_Manager")){
%>
<input type='hidden' name="wdesk:Dec_CreditManager" id="wdesk:Dec_CreditManager" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CreditManager")).getAttribValue().toString()%>'/>
<%}
if(WSNAME.equalsIgnoreCase("AttachAdditionalDocs") || WSNAME.equalsIgnoreCase("AU_Analyst") || WSNAME.equalsIgnoreCase("AU_Officer") || WSNAME.equalsIgnoreCase("AU_Doc_Checker") || WSNAME.equalsIgnoreCase("Business_Rejects")){
%>
<input type='hidden' name="wdesk:RM_MailId" id="wdesk:RM_MailId" value='<%=((CustomWorkdeskAttribute)attributeMap.get("RM_MailId")).getAttribValue().toString()%>'/>
<%}%>

<input type='hidden' name="wdesk:Dec_Control_Maker" id="wdesk:Dec_Control_Maker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Control_Maker")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:Dec_Control_Checker" id="wdesk:Dec_Control_Checker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Control_Checker")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:Dec_AU_Analyst" id="wdesk:Dec_AU_Analyst" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_AU_Analyst")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:UID_Exp_Flag" id="wdesk:UID_Exp_Flag"/>
<input type='hidden' name="wdesk:duplicateLogicFlag" id="wdesk:duplicateLogicFlag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("duplicateLogicFlag")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:qDecision" id="wdesk:qDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("qDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Deferral_Held" id="wdesk:Deferral_Held" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Deferral_Held")).getAttribValue().toString()%>'/>

<input type='hidden' name='UIDTableLength' id='UIDTableLength'>
<input type='hidden' name='DeferralTableLength' id='DeferralTableLength'>

<input type='hidden' name="performcheckdays_CBRB" id="performcheckdays_CBRB"/>
<input type='hidden' name="performcheckdays_AECB" id="performcheckdays_AECB"/>

<input type='hidden' name="wdesk:q_IsDistributed" id="wdesk:q_IsDistributed" value='<%=((CustomWorkdeskAttribute)attributeMap.get("q_IsDistributed")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Dec_CreditAnalyst" id="wdesk:Dec_CreditAnalyst" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CreditAnalyst")).getAttribValue().toString()%>'/>

</FORM>
</BODY>
</HEAD>
</HTML>
<%
}
%>