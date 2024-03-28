<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRO
//Module                     : Service Request Other 
//File Name					 : SRO.jsp
//Author                     : Sajan 
// Date written (DD/MM/YYYY) : 12-10-2018
//Description                : File for the main form view
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.util.Iterator"%>
<%@ include file="../SRO_Specific/Log.process"%>
<%@ include file="../header.process" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>


<%
WriteLog("parameterMap"+parameterMap);
if (parameterMap != null && parameterMap.size() > 0) {

	String sCabName=customSession.getEngineName();	
	WriteLog("sCabName"+sCabName);
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String user_name = customSession.getUserName();

	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	String outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID);
	
	WriteLog("Output XML:"+outputXmlFetch);
	
	WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
    attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";
	WriteLog("attributeData: "+attributeData);
	
	CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
	LinkedHashMap varIdMap = new LinkedHashMap();
	attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	session = request.getSession(false);
	WriteLog("WINAME..."+WINAME);
	
	SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MM/yyyy");
    Date now = new Date();
    String strDate = sdfDate.format(now);
	
	WriteLog("Date is "+strDate);
	
	String strArchivalPath=((CustomWorkdeskAttribute)attributeMap.get("Archival_Path")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Archival_Path")).getAttribValue().toString();
	
	WriteLog("Archival Path is  "+strArchivalPath);
	
	String strTeam=((CustomWorkdeskAttribute)attributeMap.get("Team")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Team")).getAttribValue().toString();
	
	WriteLog("Team is "+strTeam);
	
	String strRemarks=((CustomWorkdeskAttribute)attributeMap.get("Remarks")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Remarks")).getAttribValue().toString();
	
	WriteLog("strRemarks is "+strRemarks);
	
	
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script language="javascript" src="/SRO/webtop/scripts/clientSRO.js"></script>
<script language="javascript" src="/SRO/webtop/scripts/SRO_Script/loadFormValuesAtNextWS.js"></script>
<script language="javascript" src="/SRO/webtop/scripts/SRO_Script/loadDropDownValues.js"></script>
<script language="javascript" src="/SRO/webtop/scripts/SRO_Script/FieldValidation.js"></script>
<script language="javaScript" src="/SRO/webtop/scripts/SRO_Script/calendar_SRO.js"></script>

<script language="javascript" src="/SRO/webtop/scripts/SRO_Script/jquery-latest.js"></script>
<script language="javascript" src="/SRO/webtop/scripts/SRO_Script/jquery.autocomplete.js"></script>
<script src="/SRO/webtop/scripts/SRO_Script/jquery.min.js"></script>
<script src="/SRO/webtop/scripts/SRO_Script/bootstrap.min.js"></script>
<script src="/SRO/webtop/scripts/SRO_Script/jquery-ui.js"></script>
<HTML>
<HEAD>
<link rel="stylesheet" href="..\..\webtop\scripts\SRO_Script\bootstrap.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\SRO_Script\jquery-ui.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\docstyle.css">
<TITLE>Service Request Other</TITLE>
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

//added by stutee.mishra
var dialogToOpenType = null;
var popupWindow=null;
function setValue(val1) 
{
   //you can use the value here which has been returned by your child window
   popupWindow = val1;
   if(dialogToOpenType == 'Reject Reasons'){
	   if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
			{
				var result=popupWindow.split("~");
				//alert(result[0] +result[1]);
				document.getElementById('rejReasonCodes').value = result[0];
				//Added Mail_Init Workstep for Mail Management Changes
				document.getElementById('wdesk:Email_WI_RejectReason').value=result[1];
			}
   }
}
//ends here.
	
function openCustomDialog (dialogToOpen,workstepName)
		{
			if (workstepName!=null &&  workstepName!='')
			{
				dialogToOpenType = dialogToOpen;
				//var popupWindow=null;
				var sOptions;
				if(dialogToOpen=='Decision History')
				{
					var WINAME = '<%=WINAME%>';
					
					//window.showModalDialog("../SRO_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						window.showModalDialog("../SRO_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					} else {
						window.open("../SRO_Specific/history.jsp?WINAME="+WINAME,this,windowParams);
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
				
					sOptions = 'dialogWidth:500px; dialogHeight:500px; dialogLeft:450px; dialogTop:50px; status:no; scroll:no; help:no; resizable:no';
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow = window.showModalDialog('../SRO_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
					} else {
						popupWindow = window.open('../SRO_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					{
					var result=popupWindow.split("~");
					//alert(result[0] +result[1]);
					document.getElementById('rejReasonCodes').value = result[0];
					//Added Mail_Init Workstep for Mail Management Changes
					document.getElementById('wdesk:Email_WI_RejectReason').value=result[1];
					}	
				}				
			}
		}
		function checkRemarks()
		{
			var remarks=document.getElementById("wdesk:Remarks");
			var value=document.getElementById("wdesk:Remarks").value;
			var newLength=value.length;
			var maxLength=2000;
			value=value.replace(/(\r\n|\n|\r)/gm," ");
			value=value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");
			if(newLength>=maxLength){
				value=value.substring(0,maxLength);		
			}
			document.getElementById("wdesk:Remarks").value=value;
		}
		function setFrameSize()
		{
			var widthToSet = document.getElementById("SRO").offsetWidth;
			var controlName="SRO,Decision,UIDGrid,uiddetails,SRODetails";
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
			if(cif.value !='' && cif.value.length!=7)
			{
				alert('CIF should be of exactly 7 digits');
				//cif.value="";
				cif.focus();
				return false;
			}
		}
		function checkECRNLength()
		{
			var ecrn=document.getElementById("wdesk:ERCN_Number");
			if(ecrn.value !='' && ecrn.value.length!=9)
			{
				alert('ECRN Number should be of exactly 9 digits');
				//ecrn.value="";
				ecrn.focus();
				return false;
			}
		}
		
		function enableDisable()
		{
			var workStep='<%=WSNAME%>';
			var serviceRequestType=document.getElementById("ServiceRequestType");
			var archivalPath=document.getElementById("wdesk:Archival_Path");
			var CIFId=document.getElementById("wdesk:CIF_Id");
			var ERCNNumber=document.getElementById("wdesk:ERCN_Number");
			var AgreementNumber=document.getElementById("wdesk:Agreement_Number");
			var PrePaidPackId=document.getElementById("wdesk:Pre_Paid_Pack_Id");
			var addRowButton=document.getElementById("add_row");
			var rejectReasons=document.getElementById("RejectReason");
			var TeamName=document.getElementById("TeamSearchable");
			rejectReasons.disabled=true;
			serviceRequestType.disabled=true;
			archivalPath.disabled=true;
			CIFId.disabled=true;
			ERCNNumber.disabled=true;
			AgreementNumber.disabled=true;
			PrePaidPackId.disabled=true;
			addRowButton.disabled=true;
			TeamName.disabled=true;
			//Added Mail_Init Workstep for Mail Management Changes
			var EmailInitFlag=document.getElementById("wdesk:Email_Initiated_WI_Flag").value;
			//if(EmailInitFlag =='Y' && (workStep=="Mail_Initiation" || workStep=="Initiator_Reject" || workStep=="Mail_Followup" || workStep=="Hold" ))
			//Email TO FROM Visible at all worksteps if it is EMailInitFlag=y 2020-JUNE-10 Changes
			if(EmailInitFlag =='Y' )
			{
			//alert(EmailInitFlag+"hi--"+document.getElementById("MailManagement").style.visibility);
			  //  document.getElementById("MailManagement").style.display='block';
			}
			else{
			//alert(EmailInitFlag+"bye--"+document.getElementById("MailManagement").style.visibility);
			   document.getElementById("MailManagement").style.display='none';
			}
			if(workStep=="Introduction" || workStep=="Mail_Initiation" || workStep=="Initiator_Reject" || workStep=="Mail_Followup" ){
				serviceRequestType.disabled=false;				
				CIFId.disabled=false;
				ERCNNumber.disabled=false;
				AgreementNumber.disabled=false;
				PrePaidPackId.disabled=false;
				archivalPath.disabled=false;
			}
			//Added Mail_Init Workstep for Mail Management Changes
			if(workStep=="Introduction" || workStep=="Mail_Initiation" || workStep=="Initiator_Reject" || workStep=="Maker" || workStep=="Mail_Followup")
				addRowButton.disabled=false;				
				//Added Mail_Init Workstep for Mail Management Changes
			if(workStep == "Introduction" || workStep=="Mail_Initiation" || workStep=="Mail_Followup")
				TeamName.disabled=false;
			//Disabling Ser Req Typ in Init Reject
			if(workStep == "Initiator_Reject")
			serviceRequestType.disabled=true;
		//SRO Mail Management Onload Remarks Empty
		//alert(document.getElementById("wdesk:Remarks").value);
		document.getElementById("wdesk:Remarks").value = '<%=strRemarks%>';
		if(document.getElementById("wdesk:Remarks").value=="NULL")
		{
		//alert('testing');
		document.getElementById("wdesk:Remarks").value ='';
		}
		}
		function trim(str) 
		{
			if (undefined == str)
				return "";
			return str.replace(/^\s+|\s+$/g, '');
		}
		function checkPrePaidPackId()
		{
			var prePaidPackId=document.getElementById("wdesk:Pre_Paid_Pack_Id");
			if(trim(prePaidPackId.value)!=null && trim(prePaidPackId.value)!="")
			{
				if(!prePaidPackId.value.match('^[a-zA-Z]{3}[0-9]{1,}$'))
				{
					alert('First 3 Characters of Pre Paid Pack Id should be Alphabets and last 11 charcters should be numeric');
					//prePaidPackId.value="";
					prePaidPackId.focus();
					return false;	
				}
				if(prePaidPackId.value.length != 14)
				{
					alert('Pre Paid Card Number should be of exactly 14 digits');
					//prePaidPackId.value="";
					prePaidPackId.focus();
					return false;	
				}
			}
		}
function setComboValueToTextBox(dropdown, inputTextBoxId) 
{
	if(dropdown.id=='selectDecision')
	{
		document.getElementById(inputTextBoxId).value = dropdown.value;
	}	
	
	if(document.getElementById('selectDecision').value=='Reject'||document.getElementById('selectDecision').value=='Reject to Maker'||document.getElementById('selectDecision').value=='Reject to Team' ||document.getElementById('selectDecision').value=='Reject to Initiator' 
	||document.getElementById('selectDecision').value=='Cancel' ||document.getElementById('selectDecision').value=='Additional Information Required')
	{
		document.getElementById('RejectReason').disabled = false;
	}
	else{
		document.getElementById('RejectReason').disabled = true;
	}
	
	//Making Team Name Editable & Non Editable based on decision
	var WSNAME = '<%=WSNAME%>';
	//Added Mail_Init Workstep for Mail Management Changes
	if(WSNAME == 'Hold' || WSNAME == 'Initiator_Reject' || WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup')
	{	
		if(document.getElementById("selectDecision").value=='Submit to Team' || document.getElementById("selectDecision").value=='Recommended')
		{
			document.getElementById('TeamSearchable').disabled = false;		
		}
		else
		{
			document.getElementById('TeamSearchable').disabled = true;		
		}
	}
	//Added Mail_Init Workstep for Mail Management Changes
	else if(WSNAME == 'Checker' || WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup')
	{	
		if(document.getElementById("selectDecision").value=='Recommended' ||document.getElementById("selectDecision").value=='Approve to Team' || document.getElementById("selectDecision").value=='Reject to Team')
		{
			document.getElementById('TeamSearchable').disabled = false;		
		}
		else
		{
			document.getElementById('TeamSearchable').disabled = true;		
		}
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
	}

}
</script>
<script>
	$(document).ready(function() {
		$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
		$("div.tooltip-wrapper").mouseover(function() {
			$(this).attr('title', $(this).children().val());
		});
	});
</script>

<BODY onload="window.parent.checkIsFormLoaded();loadUIDGridValues('<%=WSNAME%>','<%=WINAME%>');enableDisable();setFrameSize();loadDecisionFromMaster('<%=WSNAME%>');loadArchivalPathFromMaster('<%=WSNAME%>','<%=strArchivalPath%>');loadDropDownValues('<%=WSNAME%>','<%=customSession.getUserName()%>');DisableFieldinReadOnlyMode();">
<FORM name="wdesk" id="wdesk" method="post" visibility="hidden" onsubmit=''>
<div id = "SRODetails" class='tooltip-wrapper' style="height:193px;border-style: solid;border-width: thin;border-color: #990033;">
<table border='1' id = "SRO" cellspacing='1' cellpadding='0' width='100%'>
	<tr  id = "SRO_Header" width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Service Request Other</font></td>
	</tr>
	
	<tr>
		<td colspan =4 width=100% height=100% align=right valign=center><img src='\SRO\webtop\images\bank-logo.gif'></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Logged In As</td>
		<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%>&nbsp;<%=customSession.getUserName()%></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Workstep</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25% id="Workstep" >&nbsp;<%=WSNAME%></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Workitem Name</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%>&nbsp;<%=WINAME%></td>	
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
	</tr>
		<!-- Mail Management Changes  From To mail IDs visible-->
	<tr  id='MailManagement' >
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Email ID</td>
		<td  ><input disabled="disabled"  type='text' class='NGReadOnlyView' name='wdesk:Email_From' id='wdesk:Email_From' style='width:175px'    value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_From")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_From")).getAttribValue().toString()%>'/>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;RAK Email ID</td>
		<td  ><input disabled="disabled" class='NGReadOnlyView' type='text' name='wdesk:Email_To' id='wdesk:Email_To' style='width:175px'   value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_To")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_To")).getAttribValue().toString()%>'/>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<!--End of Mail Management Changes  From To mail IDs visible-->
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Service Request Type
		</td>
		<td>
		<input type='text' class='NGReadOnlyView' name='ServiceRequestType' id='ServiceRequestType' onkeyup="" onblur = "validateServiceRequest('ServiceRequestType',document.getElementById('AutocompleteValues').value);" style='width:175px' />&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=hidden name='AutocompleteValues' id='AutocompleteValues' style='visibility:hidden' value='' />
		</td>		
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Archival Path
		</td>
		<td>
		<select class='NGReadOnlyView' name='wdesk:Archival_Path' id='wdesk:Archival_Path' onkeyup="" style='width:175px'>
			<option value="">--Select--</option>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;
		</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;CIF Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:CIF_Id' id='wdesk:CIF_Id' onKeyUp='ValidateNumeric("wdesk:CIF_Id");' onblur='checkCIFLength();' maxlength='7' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CIF_Id")).getAttribValue().toString()%>' style='width:175px'/></td>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;ECRN Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:ERCN_Number' id='wdesk:ERCN_Number' style='width:175px' maxlength='9' onkeyup='ValidateNumeric("wdesk:ERCN_Number")' onblur='checkECRNLength();' value='<%=((CustomWorkdeskAttribute)attributeMap.get("ERCN_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ERCN_Number")).getAttribValue().toString()%>'/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Agreement Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Agreement_Number' id='wdesk:Agreement_Number' maxLength='13' onkeyup='ValidateNumeric("wdesk:Agreement_Number");' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Agreement_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Agreement_Number")).getAttribValue().toString()%>' style='width:175px'/></td>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Pre Paid Pack Id</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:Pre_Paid_Pack_Id' id='wdesk:Pre_Paid_Pack_Id' style='width:175px' maxLength='14' onkeyup='ValidateAlphaNumeric("wdesk:Pre_Paid_Pack_Id");' onblur='checkPrePaidPackId();' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Pre_Paid_Pack_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Pre_Paid_Pack_Id")).getAttribValue().toString()%>'/></td>
	</tr>
</table>
<table border='1' id = "Decision" cellspacing='1' cellpadding='0' width=100%>
	<tr  id = "RAO_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Decision</font></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Decision </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
		<select  class="NGReadOnlyView" style='width: 175px;' name="selectDecision" id="selectDecision" onchange="setComboValueToTextBox(this,'wdesk:Decision')">
			<option value="">--Select--</option>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Team
		</td>
		<!--<td>
		<select name='TeamSearchable' id='TeamSearchable' onkeyup="" style='width:175px'>
			<option value="">--Select--</option>
		</select>&nbsp;&nbsp;&nbsp;&nbsp;
		</td> -->
		<td>
		<input type='text' class='NGReadOnlyView' name='TeamSearchable' id='TeamSearchable' onkeyup=""  onblur = "validateServiceRequest('TeamSearchable',document.getElementById('AutocompleteValuesTeam').value);" style='width:175px'/>&nbsp;&nbsp;&nbsp;&nbsp;
		<input type=hidden name='AutocompleteValuesTeam' id='AutocompleteValuesTeam' style='visibility:hidden' value='' />
		</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Remarks
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%>
		<textarea maxlength="2000" class='EWNormalGreenGeneral1' style="width:175px;" rows="3" cols="40" id="wdesk:Remarks" name="wdesk:Remarks" onblur="checkRemarks();" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Remarks")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Remarks")).getAttribValue().toString()%>'></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='RejectReason' id="RejectReason" type='button' value='Reject Reason' onclick="openCustomDialog('Reject Reasons','<%=WSNAME%>');" class='EWButtonRBSRM' style='width:175px'>&nbsp;
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;<input name='history' id="history" type='button' value='Decision History' onclick="openCustomDialog('Decision History','<%=WSNAME%>')" class='EWButtonRBSRM' style='width:170px'>&nbsp;
		</td>
	</tr>
</table>
<div id="uiddetails"  style="height:200px;border-style: solid;border-width: thin;border-color: #990033;">
<table border='1'cellspacing='1' cellpadding='0' width=100% id ='UIDGrid'>
	<tr id = "UIDGrid_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033">
		<input type='text' name='Header' readOnly style='display:none' />
		<td colspan='6' align='center' class='EWLabelRB2'><font color="white" size="4">UID Details</font></td>
	</tr>
	<tr>
		<td colspan='6'><input type = 'button' id = 'add_row' value='Add Rows' class='EWButtonRBSRM' style='width:150px' onclick='addrowUID("","<%=WSNAME%>")'/></td>
	</tr>	
	<tr bgcolor= "#990033" >
		<td width = '5%' class='EWNormalGreenGeneral1'><font color="white">Sr No</font></td>
		<td width ='15%' class='EWNormalGreenGeneral1'><font color="white">UID</font></td>
		<td width ='25%' class='EWNormalGreenGeneral1'><font color="white">Initiator Remarks</font></td>
		<td width ='25%' class='EWNormalGreenGeneral1'><font color="white">Maker Remarks</font></td>
		<td width ='25%' class='EWNormalGreenGeneral1'><font color="white">Checker Remarks</font></td>
		<td width='5%' class='EWNormalGreenGeneral1'><font color="white">Delete</font></td>
	</tr>
</table>
</div>
</div>
<input type="hidden" id="wdesk:WI_NAME" name="wdesk:WI_NAME" value='<%=WINAME%>'/>
<input type='hidden' name="wdesk:Current_WS" id="wdesk:Current_WS" value='<%=WSNAME%>'/>
<input type='hidden' name='UIDTableLength' id='UIDTableLength'/>
<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
<input type='hidden' name="wdesk:Decision" id="wdesk:Decision"/>

<input type="hidden" id="wdesk:Success_Path" name="wdesk:Success_Path" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Success_Path")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Success_Path")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Failure_Path" name="wdesk:Failure_Path" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Failure_Path")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Failure_Path")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:DataClass" name="wdesk:DataClass" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DataClass")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DataClass")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Service_Request_Code" name="wdesk:Service_Request_Code" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Service_Request_Code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Service_Request_Code")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:TeamCode" name="wdesk:TeamCode" value='<%=((CustomWorkdeskAttribute)attributeMap.get("TeamCode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TeamCode")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Team" name="wdesk:Team" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Team")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Team")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Service_Request_Type" name="wdesk:Service_Request_Type" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Service_Request_Type")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Service_Request_Type")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Dec_Maker" name="wdesk:Dec_Maker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Maker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Maker")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Archival_Code" name="wdesk:Archival_Code" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Archival_Code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Archival_Code")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:ArchivalDate" name="wdesk:ArchivalDate" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ArchivalDate")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:IntiatorUserGroup" name="wdesk:IntiatorUserGroup" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IntiatorUserGroup")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IntiatorUserGroup")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Email_WI_RejectReason" name="wdesk:Email_WI_RejectReason" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_WI_RejectReason")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_WI_RejectReason")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Email_Initiated_WI_Flag" name="wdesk:Email_Initiated_WI_Flag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_Initiated_WI_Flag")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_Initiated_WI_Flag")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:Email_WI_Init_Flag" name="wdesk:Email_WI_Init_Flag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_WI_Init_Flag")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_WI_Init_Flag")).getAttribValue().toString()%>'/>
<%-- <input type="hidden" id="wdesk:Email_Create_Trigger" name="wdesk:Email_Create_Trigger" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_Create_Trigger")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_Create_Trigger")).getAttribValue().toString()%>'/> --%>

<%-- <input type="hidden" id="wdesk:Email_Approve_Trigger" name="wdesk:Email_Approve_Trigger" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_Approve_Trigger")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_Approve_Trigger")).getAttribValue().toString()%>'/> --%>

<%-- <input type="hidden" id="wdesk:Email_Reject_Trigger" name="wdesk:Email_Reject_Trigger" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_Reject_Trigger")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_Reject_Trigger")).getAttribValue().toString()%>'/> --%>

<%-- <input type="hidden" id="wdesk:Email_Cancel_Trigger" name="wdesk:Email_Cancel_Trigger" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_Cancel_Trigger")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_Cancel_Trigger")).getAttribValue().toString()%>'/> --%>

<%-- <input type="hidden" id="wdesk:Email_RequestInfo_Trigger" name="wdesk:Email_RequestInfo_Trigger" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_RequestInfo_Trigger")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_RequestInfo_Trigger")).getAttribValue().toString()%>'/> --%>

<%-- <input type="hidden" id="wdesk:Email_FinalReject_Trigger" name="wdesk:Email_FinalReject_Trigger" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_FinalReject_Trigger")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_FinalReject_Trigger")).getAttribValue().toString()%>'/> --%>


 <input type="hidden" id="wdesk:Mail_Initiation_User" name="wdesk:Mail_Initiation_User" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Mail_Initiation_User")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Mail_Initiation_User")).getAttribValue().toString()%>'/> 

<%-- <input type="hidden" id="wdesk:MailFollowup_expiry_days" name="wdesk:MailFollowup_expiry_days" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MailFollowup_expiry_days")) ==null? null:((CustomWorkdeskAttribute)attributeMap.get("MailFollowup_expiry_days")) %>'/> --%>


<%-- <input type="hidden" id="wdesk:Email_MailInit_User_Code" name="wdesk:Email_MailInit_User_Code" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Email_MailInit_User_Code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Email_MailInit_User_Code")).getAttribValue().toString()%>'/> --%>


</FORM>
</BODY>
</HEAD>
</HTML>
<%}%>