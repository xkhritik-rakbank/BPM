<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank
//Module                     : Request-Initiation 
//File Name					 : RAO.jsp
//Author                     : Amitabh Pandey
// Date written (DD/MM/YYYY) : 20-Oct-2017
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.util.Iterator"%>
<%@ include file="../header.process" %>
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>

<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
if (parameterMap != null && parameterMap.size() > 0) {
	
	String sCabName=customSession.getEngineName();	
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
	
%>

<link rel="stylesheet" href="tabStyling.css">
<script language="javascript" src="/OECD/webtop/scripts/clientOECD.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/table_script.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/loadDropDownValues.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/loadFormValuesAtNextWS.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/FieldTypeValidation.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/OECDIntegrate.js"></script>

<!-- for autocomplete--------------------------------------->
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/jquery-latest.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/jquery.autocomplete.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/jquery.min.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/bootstrap.min.js"></script>
<script language="javascript" src="/OECD/webtop/scripts/OECD_Script/jquery-ui.js"></script>

<HTML>
<HEAD>
<link rel="stylesheet" href="..\..\webtop\scripts\OECD_Script\bootstrap.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\OECD_Script\jquery-ui.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\docstyle.css">
<style>	
.accordion-heading {			
				padding:2px;
			}
			.accordion-heading {
				background-color: #980033;
				border : 1px solid gray;
			}
			.gap{
				width:200px;
				background:none;
				height:5px;
				display:inline-block;
			}
</style>
<TITLE>Retail OECD Update</TITLE>
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

//below function added for the entity detail integration call
function callJSP(){
	//alert("inside CallJSP");
	CIF_ID = document.getElementById("CIF_NUMBER").value;
	var wi_name = '<%=WINAME%>';
	var wsname= '<%=WSNAME%>';
	var user_name = '<%=customSession.getUserName()%>';
	if(wsname!="Attach_Cust_Doc"){
	
		onLoadShowShareHoldersDetails();
		loadChecklistvalue(wsname,wi_name);//added 30102020 as a part of CR
	
	
	/* not to be called as preferred address is coming from digital banking as part of fatca changes
	var request_type = "ENTITY_DETAILS";
	
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/OECD/CustomForms/OECD_Specific/OECDIntegration.jsp";
			
			//var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;
			
			var param = "request_type=" + request_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				var splittedresult = ajaxResult.split("~");
				//alert("prefaddress"+splittedresult[9]+","+splittedresult[10]+","+splittedresult[11]+","+splittedresult[12]+""+splittedresult[13]+","+splittedresult[14]+","+splittedresult[15]);
				var address = splittedresult[0]+","+splittedresult[1]+","+splittedresult[2]+","+splittedresult[3]+","+splittedresult[4]+","+splittedresult[5]+","+splittedresult[6];
				document.getElementById("PREF_ADDRESS").value=address;
				document.getElementById("wdesk:PREF_ADDRESS").value=document.getElementById("PREF_ADDRESS").value;
			
				if (ajaxResult.indexOf("Exception") == 0) 
				{
					alert("Please enter an valid Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No.");
					return false;
				}
		
			}
			else
			{
				alert("Problem in fetching Entity Details Call");
			}
			*/
			
		}
		
	/*if((document.getElementById("wdesk:Share_Holder_Details").value=='' || document.getElementById("wdesk:Share_Holder_Details").value==null) && (wsname=='OPS_Checker'))
	{
		var request_type = "CUSTOMER_SUMMARY";	
			var xhr1;
			var xmlDoc;
			if (window.XMLHttpRequest)
				xhr1 = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr1 = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/OECD/CustomForms/OECD_Specific/CustomerDetail.jsp";
			var param =  "request_type=" + request_type + "&CIF_ID=" + CIF_ID;
			//var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;
			
			var param = "request_type=" + request_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;
			xhr1.open("POST", url, false);
			xhr1.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr1.send(param);
			if (xhr1.status == 200 && xhr1.readyState == 4) 
			{
				
				ajaxResult=xhr1.responseText;
				ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
				if(ajaxResult == 'NoRecord')
				{
					alert("No record found.");
					return false;
				}
				else if(ajaxResult == 'Error')
				{
					alert("Some problem in fetch Customer Summary details.");
					return false;
				}
				else {
					xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
					xmlDoc.async = "false";
					xmlDoc.loadXML(ajaxResult);
						
					var strStatus = xmlDoc.getElementsByTagName("ReturnDesc")[0].childNodes[0].nodeValue;
					
					//var status = $(ajaxResult).find("ReturnDesc").text();
					if(strStatus=='Success'||strStatus=='Successful') {
						showCustomerSummary(ajaxResult);										
					}
					else {
						//alert('There is no related party for this CIF');
					}
				}	
		
			}
			else
			{
				alert("Problem in fetching Customer Summary Call");
				return false;
			}
	
		return true;
			
	}*/
}	
	
	function setFrameSize()
	{
		var widthToSet = document.getElementById("OECD_Update").offsetWidth;
		var controlName="OECD_Update,OECD_update_Header,Req_Initiator,CustDetails,div_ShareHolderDetails,shareholderTab,div_ShareHolderDetails2,shareholderTab2,taxdetail,divchecklistGrid,checklistGrid,OECDGrid,OECDGrid2,ErrorDetails,decisiondetails,EntityInfo,ShareHolderSection,checklistGridHeader";
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
			
			var shareholderTable=document.getElementById("shareholderTab2");
			var table_len=(shareholderTable.rows.length);
			for (var j = 1; j <= table_len; j++) 
			{
				document.getElementById("selected"+j).disabled = false;
			}
		}
	}
	
	function showCustomerSummary(CustomerSummaryResponse)
			{		
				try {
						 var table = document.getElementById("shareholderTab");
						 var rowCount = table.rows.length;
						 for(var i=1; i<rowCount; i++) {
							 var row = table.rows[i];
								 if(rowCount <= 1) {                       
									 break;
								 }
								 table.deleteRow(i);
								 rowCount--;
								 i--;
						 }
						 }catch(e) {
							 alert(e);
						 }
				
				var xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
				xmlDoc.async = "false";
				xmlDoc.loadXML(CustomerSummaryResponse);
				
				var RCIFDetailsTags = xmlDoc.getElementsByTagName("RCIFDetails");
				
				var gridData = "";
				for (var i = 0; i < RCIFDetailsTags.length; i++) 
				{
					var gridRow = "";
					var row=document.getElementById("shareholderTab").insertRow(i+1);
					
					var RCIFRowTags=RCIFDetailsTags[i].childNodes;
					
					var RCIFId="";
					var Fullname="";
					var FName="";
					var MName="";
					var LName="";
					var SubRelationshipStatus="";
					for (var j = 0; j < RCIFRowTags.length; j++) 
					{  				
						if(RCIFRowTags[j].childNodes==null || RCIFRowTags[j].childNodes.length==0 || RCIFRowTags[j].childNodes[0].nodeValue==null)
							continue;
						
						if(RCIFRowTags[j].nodeName=="RCIFId") {
							RCIFId=RCIFRowTags[j].childNodes[0].nodeValue;
						}
						else if(RCIFRowTags[j].nodeName=="FName") {
							FName=RCIFRowTags[j].childNodes[0].nodeValue;
						}
						else if(RCIFRowTags[j].nodeName=="MName") {
							MName=RCIFRowTags[j].childNodes[0].nodeValue;
						}
						else if(RCIFRowTags[j].nodeName=="LName") {
							LName=RCIFRowTags[j].childNodes[0].nodeValue;
						}
						else if(RCIFRowTags[j].nodeName=="SubRelationshipStatus") {
							SubRelationshipStatus=RCIFRowTags[j].childNodes[0].nodeValue;
						}
					}
					
					Fullname=FName+" "+MName+" "+LName;
					
					var cell = row.insertCell(0);
					cell.className="EWNormalGreenGeneral1";
					cell.style.textAlign="center";
					cell.innerHTML = i+1;
					
					cell = row.insertCell(1);
					cell.className="EWNormalGreenGeneral1";
					cell.style.textAlign="center";
					cell.innerHTML = RCIFId;
					
					cell = row.insertCell(2);
					cell.className="EWNormalGreenGeneral1";
					cell.style.textAlign="left";
					cell.innerHTML = Fullname;
					
					cell = row.insertCell(3);
					cell.className="EWNormalGreenGeneral1";
					cell.style.textAlign="center";
					cell.innerHTML = SubRelationshipStatus;			
					
					gridRow = RCIFId + "`" + Fullname + "`" + SubRelationshipStatus;
					if(gridData != "") {
						gridData = gridData + "#" + gridRow;
					}
					else {
						gridData = gridRow;
					}		
				}
				document.getElementById("wdesk:Share_Holder_Details").value = gridData;	
			}
			
			
	function onLoadShowShareHoldersDetails() {
				/*var gridData = document.getElementById("wdesk:Share_Holder_Details").value;
				
				if(gridData != null && gridData != "" && gridData != "null") {
					var values = (gridData).split("#");
					
						var RCIFId="";
						var Fullname="";
						var FName="";
						var MName="";
						var LName="";
						var SubRelationshipStatus="";
					
					for (var i=0 ; i< values.length ; i++) {
						var columns = (values[i]).split("`");				
						var row=document.getElementById("shareholderTab").insertRow(i+1);
						
						RCIFId = columns[0];
						Fullname = columns[1];
						SubRelationshipStatus = columns[2];
					
						var cell = row.insertCell(0);
						cell.className="EWNormalGreenGeneral1";
						cell.style.textAlign="center";
						cell.innerHTML = i+1;
						
						cell = row.insertCell(1);
						cell.className="EWNormalGreenGeneral1";
						cell.style.textAlign="center";
						cell.innerHTML = RCIFId;
						
						cell = row.insertCell(2);
						cell.className="EWNormalGreenGeneral1";
						cell.style.textAlign="left";
						cell.innerHTML = Fullname;
						
						cell = row.insertCell(3);
						cell.className="EWNormalGreenGeneral1";
						cell.style.textAlign="center";
						cell.innerHTML = SubRelationshipStatus;			
					}
				}*/
				
				//Added as part of CR 29102020 for Loading shareholder section
				var gridData = document.getElementById("wdesk:Share_Holder_Details").value;
				var SignatoryDetails=false;
				if(gridData != null && gridData != "" && gridData != "null") //Loading SignatoryDetails for old/existing WI
				{
					 if(gridData.indexOf("#") != -1)
					 {
						 gridData=gridData.split('#');
						 for(var i=0;i<gridData.length;i++)
						 {
							var ajaxResultRow=gridData[i].split('`');
							populateOECDDataInShareHolder(ajaxResultRow,SignatoryDetails);
						 }	
					 }
					 else
					 {
						var ajaxResultRow=gridData.split('`');
						populateOECDDataInShareHolder(ajaxResultRow,SignatoryDetails);								  
					 }
				}
				else //Loading SignatoryDetails for new WI
				{
					SignatoryDetails=true;
					var wi_name = '<%=WINAME%>';
					var xhr;
					if (window.XMLHttpRequest)
						xhr = new XMLHttpRequest();
					else if (window.ActiveXObject)
						xhr = new ActiveXObject("Microsoft.XMLHTTP");

					url = '/OECD/CustomForms/OECD_Specific/DropDownLoad.jsp?reqType=RELATEDPARTYDETAILS_GRID&WINAME='+wi_name;
					xhr.open("GET",url,false);
					xhr.send(null);
					if (xhr.status == 200)
					{
						 ajaxResult = xhr.responseText;
						 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
						 if(ajaxResult=='-1')
						 {
							alert("Error while loading Related Party Details Grid values");
							return false;
						 }				 
						 
						 if(ajaxResult != "")
						 {
							 if(ajaxResult.indexOf("#") != -1)
							 {
								 ajaxResult=ajaxResult.split('#');
								 for(var i=0;i<ajaxResult.length;i++)
								 {
									var ajaxResultRow=ajaxResult[i].split('`');
									populateOECDDataInShareHolder(ajaxResultRow,SignatoryDetails);
								 }	
							 }
							 else
							 {
								var ajaxResultRow=ajaxResult.split('`');
								populateOECDDataInShareHolder(ajaxResultRow,SignatoryDetails);								  
							 }
						 }				 
					}
					else 
					{
						//alert("Error while Loading Drowdown decision.");
						return false;
					}
				}					
			}		
	
/*function addrowgrid(arrayDOCRowValues,CurrentWS)
{
	//alert("inside addrowgrid   "+arrayDOCRowValues+"   CurrentWS"+CurrentWS);
		var disabled = '';
		var disabledRemarks = '';
		if (CurrentWS != 'CBWC_Checker')
		{
			disabled = 'disabled';
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'CBWC_Checker')
		{
			disabledRemarks = 'disabled';
		}
		if (CurrentWS == 'Control')
		{
			disabledRemarks = '';
		}		
		
		if(arrayDOCRowValues!='')
		arrayDOCRowValues=arrayDOCRowValues.split("~");
		
		var table = document.getElementById("ShareHolderGrid");
		var table_len=(table.rows.length);
		var lastRow = table.rows[ table.rows.length-1 ];
		var row = table.insertRow();
		
		var cell = row.insertCell(0);
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='SRNo"+table_len+"' onkeyup=''>";
		if(arrayDOCRowValues!='')
		document.getElementById("SRNo"+table_len).value="1";
		
		var cell = row.insertCell(1);
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='originals"+table_len+"' onkeyup=''>";
		if(arrayDOCRowValues!='')
		document.getElementById("originals"+table_len).value=arrayDOCRowValues[1];
	
		var cell = row.insertCell(2);
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='copies"+table_len+"' onkeyup=''>";
		if(arrayDOCRowValues!='')
		document.getElementById("copies"+table_len).value=arrayDOCRowValues[0];
	
		var cell = row.insertCell(3);
		cell.innerHTML="<input type='text' maxlength='20' size='25' id='relationtype"+table_len+"' onkeyup=''>";
		if(arrayDOCRowValues!='')
		document.getElementById("relationtype"+table_len).value=arrayDOCRowValues[2];

		// below block added to apply tooltip on field added on 07032018
		/*$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
		
}*/
			
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED
//Group                       :           Application Projects
//Project                     :           RAKBank RAO
//Date Written                : 		  10-11-2017
//Date Modified               : 		  10-11-2017
//Author                      : 		  Ankit 
//Description                 :           This function is used to open Signature,Exception,Reject reasons and decision history window

//***********************************************************************************//

//added by stutee.mishra
	var dialogToOpenType = null;
	var popupWindow=null;
	var workstepNameHere = null;
	function setValue(val1) 
	{
	   //you can use the value here which has been returned by your child window
	   popupWindow = val1;
	   if(dialogToOpenType == 'Exception History'){
		   if(typeof popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						alert('Exp '+result[0]);
						document.getElementById('H_CHECKLIST').value = result[0];						
					}
	   }else if(dialogToOpenType == 'Reject Reasons'){
		   if(popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					{
						//Set the response code to the input with id = rejReasonCodes
						document.getElementById('rejReasonCodes').value = popupWindow;
					}
	   }
	}
//ends here.
	
		function openCustomDialog (dialogToOpen,workstepName,applicantType)
		{
			dialogToOpenType = dialogToOpen;
			workstepNameHere = workstepName;
			if (workstepName!=null &&  workstepName!='')
			{
				//var popupWindow=null;
				var sOptions;
				if(dialogToOpen=='Decision History')
				{
					var WINAME = '<%=WINAME%>';
					//window.showModalDialog("../OECD_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600px,width=650px,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						window.showModalDialog("../OECD_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					} else {
						window.open("../OECD_Specific/history.jsp?WINAME="+WINAME,"",windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					//Check if the call is for Ops_Maker and the call is for first time or not
					/*if (workstepName=='Ops_Maker')
						document.getElementById('flagForDecHisButton').value = 'Yes';*/
				}
				else if (dialogToOpen=='Reject Reasons')
				{
					var WSNAME =  '<%=WSNAME%>';
					var WINAME = '<%=WINAME%>';
					var rejectReasons = document.getElementById('rejReasonCodes').value;
				
					sOptions = 'dialogWidth:500px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; status:no; scroll:no; help:no; resizable:no';
					
					//popupWindow = window.showModalDialog('../OECD_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=400px,width=500px,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow = window.showModalDialog('../OECD_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
					} else {
						popupWindow =window.open('../OECD_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&WINAME=" + WINAME + "&ReasonCodes=" + encodeURIComponent(rejectReasons),null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
					//Set the response code to the input with id = rejReasonCodes
					//alert("popupWindow "+popupWindow);
					if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					    document.getElementById('rejReasonCodes').value = popupWindow;	
				}
				else if (dialogToOpen=='View Signature')
				{
					// validating CIDIF present or not
					var custid = document.getElementById("CIF_NUMBER").value;
					if(custid == "")//When no row added in grid
					{
						alert("Not an existing customer");
						return false;
					}
					
					//******************
					var popupWindow = null;
					var AccountnoSig = fetchAccountDetails(custid);
					
					if (AccountnoSig=='' || AccountnoSig == 'undefined')
						AccountnoSig = '';
						
					var ws_name = '<%=WSNAME%>';
					
					var sOptions = 'left=200,top=50,width=850,height=650,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
					
					var url = "/OECD/CustomForms/OECD_Specific/OpenImage.jsp?acc_num_new="+AccountnoSig+"&ws_name="+ws_name;
					//alert("url"url);
					popupWindow = window.open(url, "_blank", sOptions);
				}
				else if (dialogToOpen=='Exception History') {
					var workstepName = '<%=WSNAME%>';
					var wi_name = '<%=WINAME%>';
					var H_CHECKLIST = document.getElementById('H_CHECKLIST').value;

					sOptions = 'dialogWidth:850px; dialogHeight:500px; dialogLeft:250px; dialogTop:80px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';

					//popupWindow = window.showModalDialog('/OECD/CustomForms/OECD_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
					
					//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=500px,width=850px,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow = window.showModalDialog('/OECD/CustomForms/OECD_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
					} else {
						popupWindow =window.open('/OECD/CustomForms/OECD_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.


					//Set the response code to the input with id = H_CHECKLIST
					if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						alert('Exp '+result[0]);
						document.getElementById('H_CHECKLIST').value = result[0];
						//alert("the values are " +document.getElementById('H_CHECKLIST').value);
					}
					
				}					
			}
		}
		
</script>

<script>
	// below block added to apply tooltip on all static form field added on 07032018
	$(document).ready(function() {
		$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
		$("div.tooltip-wrapper").mouseover(function() {
			$(this).attr('title', $(this).children().val());
		});
	});
</script>

</HEAD>
<body onload = "window.parent.checkIsFormLoaded();loadDropDownValues('<%=WSNAME%>','<%=customSession.getUserName()%>');disableAllFieldsAtNextWorkstep('<%=WSNAME%>');addOECDRow();callJSP();setFrameSize();DisableFieldinReadOnlyMode();">

<form name="wdesk" id="wdesk" method="post" visibility="hidden" >

<table border='1' id = "OECD_Update" cellspacing='1' cellpadding='0' width=100% >
<tr  id = "OECD_update_Header" width=100% class='EWLabelRB2' bgcolor= "#990033">
<input type='text' name='Header' readOnly size='24' style='display:none'>
<td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">OECD Update</font>
</td>
</tr>
<tr>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Logged In As</td>
	<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;<%=customSession.getUserName()%></td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Workstep</td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' id="Workstep" style='width:200px'>&nbsp;<%=WSNAME%></td>
</tr>
<tr>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Workitem Name</td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;<%=WINAME%></td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Channel</td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
	<input  class="NGReadOnlyView"  type='text' style='width:200px' name='CHANNEL' id='CHANNEL'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("CHANNEL")).getAttribValue().toString()%>'>
	</td>
</tr>
</table>
<!--*********Requestor initiator Grid****************-->

<table border='1' id = "Req_Initiator" cellspacing='1' cellpadding='0' width='100%' >
<tr  id = "OECD_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033">
<input type='text' name='Header' readOnly size='24' style='display:none' >
<td nowrap='nowrap' colspan=4 align=left class='EWLabelRB2'><font color="white" size="3">Request Initiator Details</font>
</td>
</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CIF Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView"  type='text' style='width:200px' name='CIF_NUMBER_INI'  id='CIF_NUMBER_INI' maxlength='7'   value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_NUMBER_INI")).getAttribValue().toString()%>' onkeyup="ValidateNumeric('CIF_NUMBER_INI');">
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Name</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='NAME_INI'  style='width:200px' id='NAME_INI' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("NAME_INI")).getAttribValue().toString()%>' onkeyup="ValidateCharacter('NAME_INI');">
		</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Submission Mode</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:SUBMISSION_MODE'  style='width:200px' id='wdesk:SUBMISSION_MODE' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("SUBMISSION_MODE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SUBMISSION_MODE")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Finacle SR Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:FINACLE_SRNUMBER'  style='width:200px' id='wdesk:FINACLE_SRNUMBER' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("FINACLE_SRNUMBER")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FINACLE_SRNUMBER")).getAttribValue().toString()%>'>
		</td>
	</tr>
</table>
<!--*********Customer details Grid****************-->

<table border='1' cellspacing='1' cellpadding='0' width='100%' id ="CustDetails">
<tr  width='100%' class='EWLabelRB2' bgcolor= "#990033">
<input type='text' name='Header' readOnly size='24' style='display:none' >
<td colspan=4 align=left class='EWLabelRB2'><font color="white" size="3">Customer Details</font>
</td>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CIF Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='CIF_NUMBER' style='width:200px' id='CIF_NUMBER' maxlength='7'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_NUMBER")).getAttribValue().toString()%>' onkeyup="ValidateNumeric('CIF_NUMBER');">
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;RM Code</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:RM_CODE'  style='width:200px' id='wdesk:RM_CODE' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("RM_CODE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RM_CODE")).getAttribValue().toString()%>'>
		</td>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CIF Type</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='CIF_TYPE' style='width:200px' id='CIF_TYPE' maxlength='100'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_TYPE")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Name</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='CUST_NAME' style='width:200px' id='CUST_NAME' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CUST_NAME")).getAttribValue().toString()%>' maxlength='80'  onkeyup="ValidateCharacter('CUST_NAME');">
		</td>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Customer Segment</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='CUST_SEGMENT' style='width:200px'  id='CUST_SEGMENT' maxlength='100'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("CUST_SEGMENT")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Customer Sub-Segment</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView" type='text' name='CUST_SUBSEGMENT' style='width:200px' id='CUST_SUBSEGMENT' maxlength='100'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("CUST_SUBSEGMENT")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Country of Origin of CCIF</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='NATIONALITY' style='width:200px' id='NATIONALITY' value='<%=((CustomWorkdeskAttribute)attributeMap.get("NATIONALITY")).getAttribValue().toString()%>' maxlength='100'  onkeyup="ValidateCharacter('NATIONALITY');">
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Business Incorporation<br/>&nbsp;&nbsp;&nbsp;&nbsp;Date</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView" type='text' name='DOB' style='width:200px' id='DOB' value='<%=((CustomWorkdeskAttribute)attributeMap.get("DOB")).getAttribValue().toString()%>' maxlength='100' >
		</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Country of Incorporation <br/>&nbsp;&nbsp;&nbsp;&nbsp;or Organization</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView" type='text' name='Country_of_Incorp' style='width:200px' id='Country_of_Incorp' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Country_of_Incorp")).getAttribValue().toString()%>' maxlength='100' >
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Corporation FATCA Type</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='NFE_TYPE' style='width:200px' id='NFE_TYPE' maxlength='100'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("NFE_Type")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Sanction Declaration Status</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input class="NGReadOnlyView" type='text' disabled name='SANCTIONDECLARATIONSTATUS' style='width:200px' id='SANCTIONDECLARATIONSTATUS' value='<%=((CustomWorkdeskAttribute)attributeMap.get("SANCTIONDECLARATIONSTATUS")).getAttribValue().toString()%>' maxlength='50'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;DNFB Declaration Status</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input class="NGReadOnlyView" type='text' disabled name='DNFBDECLARATIONSTATUS' style='width:200px' id='DNFBDECLARATIONSTATUS' maxlength='100' value='<%=((CustomWorkdeskAttribute)attributeMap.get("DNFBDECLARATIONSTATUS")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Preferred/Current Address</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<textarea  class="NGReadOnlyView" type='text' cols="23" name='PREF_ADDRESS'  id='PREF_ADDRESS' value='<%=((CustomWorkdeskAttribute)attributeMap.get("PREF_ADDRESS")).getAttribValue().toString()%>' maxlength='2000' ></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
	</tr>
	<!--Below Address section is added as part of CR 28102020***************************************************-->
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><font color="red">&nbsp;&nbsp;&nbsp;&nbsp;Permanent Address</font></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><font color="red">&nbsp;&nbsp;&nbsp;&nbsp;Mailing Address</font></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 1</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:PERMANENT_ADDR_LINE1'  style='width:200px' id='wdesk:PERMANENT_ADDR_LINE1' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDR_LINE1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDR_LINE1")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 1</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:MAILING_ADDR_LINE1'  style='width:200px' id='wdesk:MAILING_ADDR_LINE1' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDR_LINE1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDR_LINE1")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 2</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:PERMANENT_ADDR_LINE2'  style='width:200px' id='wdesk:PERMANENT_ADDR_LINE2' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDR_LINE2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDR_LINE2")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 2</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:MAILING_ADDR_LINE2'  style='width:200px' id='wdesk:MAILING_ADDR_LINE2' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDR_LINE2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDR_LINE2")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;City/Town</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:PERMANENT_ADDRCITY'  style='width:200px' id='wdesk:PERMANENT_ADDRCITY' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRCITY")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRCITY")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;City/Town</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:MAILING_ADDRCITY'  style='width:200px' id='wdesk:MAILING_ADDRCITY' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRCITY")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRCITY")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Province/State/Country</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:PERMANENT_ADDRSTATE'  style='width:200px' id='wdesk:PERMANENT_ADDRSTATE' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRSTATE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRSTATE")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Province/State/Country</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:MAILING_ADDRSTATE'  style='width:200px' id='wdesk:MAILING_ADDRSTATE' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRSTATE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRSTATE")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Postal Code/Zip Code</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:PERMANENT_ADDRPOBOX'  style='width:200px' id='wdesk:PERMANENT_ADDRPOBOX' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRPOBOX")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRPOBOX")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Postal Code/Zip Code</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:MAILING_ADDRPOBOX'  style='width:200px' id='wdesk:MAILING_ADDRPOBOX' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRPOBOX")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRPOBOX")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Country</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:PERMANENT_ADDRCOUNTRY'  style='width:200px' id='wdesk:PERMANENT_ADDRCOUNTRY' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRCOUNTRY")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PERMANENT_ADDRCOUNTRY")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Country</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:MAILING_ADDRCOUNTRY'  style='width:200px' id='wdesk:MAILING_ADDRCOUNTRY' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRCOUNTRY")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MAILING_ADDRCOUNTRY")).getAttribValue().toString()%>'>
		</td>
	</tr>
	<!--CR 28102020 end**********************************************************************-->
</table>
<!--*********Entity Related Information Grid*****************-->

<table border='1' cellspacing='1' cellpadding='0' width=100% id ='EntityInfo'>
<tr  id = "RAO_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 class='EWLabelRB2'><font color="white" size="3">Entity Related Information</font></td>

	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;US Relation</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'><input  class="NGReadOnlyView" type='text' name='wdesk:USRELATIONMAIN'  id='wdesk:USRELATIONMAIN' style='width:200px' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("USRELATIONMAIN")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("USRELATIONMAIN")).getAttribValue().toString()%>'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Financial Entity</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
		<input  class="NGReadOnlyView"   type='text' name='wdesk:FINANCIAL_ENTITY'  style='width:200px' id='wdesk:FINANCIAL_ENTITY' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("FINANCIAL_ENTITY")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FINANCIAL_ENTITY")).getAttribValue().toString()%>'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;GIIN</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView"   type='text' name='wdesk:GIIN'  style='width:200px' id='wdesk:GIIN' maxlength='80'  value='<%=((CustomWorkdeskAttribute)attributeMap.get("GIIN")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("GIIN")).getAttribValue().toString()%>'>
		</td>
	</tr>		
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >&nbsp;&nbsp;&nbsp;&nbsp;FATCA Entity Type</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'><input  class="NGReadOnlyView" type='text' name='wdesk:FATCA_ENTITY_TYPE'  id='wdesk:FATCA_ENTITY_TYPE' style='width:200px' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("FATCA_ENTITY_TYPE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FATCA_ENTITY_TYPE")).getAttribValue().toString()%>'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >&nbsp;&nbsp;&nbsp;&nbsp;Name Of Securities Market</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'><input  class="NGReadOnlyView" type='text' name='wdesk:NAMEOFSECURITYMARKET'  id='wdesk:NAMEOFSECURITYMARKET' style='width:200px' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("NAMEOFSECURITYMARKET")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("NAMEOFSECURITYMARKET")).getAttribValue().toString()%>'></td>	
	</tr>
	<tr>		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Name Of Traded</br>&nbsp;&nbsp;&nbsp;&nbsp;Corporation</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='wdesk:NAMETRADEDCORPORATION' style='width:200px' id='wdesk:NAMETRADEDCORPORATION' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("NAMETRADEDCORPORATION")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("NAMETRADEDCORPORATION")).getAttribValue().toString()%>'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
	</tr>
	<tr>						
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Controlling Person US</br>&nbsp;&nbsp;&nbsp;&nbsp;Relationship</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='wdesk:CONTROLLINGPERSONUSRELATIONSHIP' style='width:200px' id='wdesk:CONTROLLINGPERSONUSRELATIONSHIP' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CONTROLLINGPERSONUSRELATIONSHIP")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CONTROLLINGPERSONUSRELATIONSHIP")).getAttribValue().toString()%>'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
	</tr>
</table>
<!--**********Shareholder/signatory/Beneficiary Details-->
<div class="accordion-group" style='display:none'>
<div class="accordion-heading" id="div_ShareHolderDetails">
	<tr id = "OECD_Header" width=100% class='EWLabelRB2' bgcolor= "#990033">
		<input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 class='EWLabelRB2'><font color="white" size="3">Shareholder / Signatory / Beneficiary Details</font></td>
	</tr>
</div>
	<div class="accordion-inner">
		<table id="shareholderTab" border='1' cellspacing='1' cellpadding='0' width=100% >
			<tr>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="10%" >S.No.</td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="30%">CIF ID</td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="30%">Name</td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="30%">Relationship Type</td>
			</tr>
		</table>
	</div>

</div>
<!--*********OECD details Grid*****************-->

<table border='1' cellspacing='1' cellpadding='0' width=100% id ='taxdetail'>
<tr  id = "RAO_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 class='EWLabelRB2'><font color="white" size="3">OECD Details</font></td>

<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;City of Birth</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'><input  class="NGReadOnlyView" type='text' name='CITY_OF_BIRTH'  id='CITY_OF_BIRTH' style='width:200px' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CITY_OF_BIRTH")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CITY_OF_BIRTH")).getAttribValue().toString()%>'></td>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >&nbsp;&nbsp;&nbsp;&nbsp;Country of Birth</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'><input  class="NGReadOnlyView" type='text' name='COUNTRY_OF_BIRTH'  id='COUNTRY_OF_BIRTH' style='width:200px' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("COUNTRY_OF_BIRTH")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("COUNTRY_OF_BIRTH")).getAttribValue().toString()%>'></td>
</tr>
<tr>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CRS Undocumented Flag	</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='CRS_UNDOCUMENTED_FLAG' style='width:200px' id='CRS_UNDOCUMENTED_FLAG' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CRS_UNDOCUMENTED_FLAG")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CRS_UNDOCUMENTED_FLAG")).getAttribValue().toString()%>'></td>
						
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CRS Undocumented <br/>&nbsp;&nbsp;&nbsp;&nbsp;Reason</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<input  class="NGReadOnlyView" type='text' name='CRS_UNDOCUMENTED_REASON' style='width:200px' id='CRS_UNDOCUMENTED_REASON' maxlength='100'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CRS_UNDOCUMENTED_REASON")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CRS_UNDOCUMENTED_REASON")).getAttribValue().toString()%>'></td>
</tr>
</table>	

<!---OECD Grid-->
<table border='1' cellspacing='1' width=100% cellpadding='0' id ='OECDGrid' colspan=4 style="height:10px;border-style: solid;border-width: thin;border-color: #990033;">		
	<tr bgcolor= "#990033" >
	<td width = '25%' class='EWLabelRB2'><font color="white">Country Of Tax Residence</font></td>
	<td width = '25%' class='EWLabelRB2'><font color="white">Tax Payer Identification No</font></td>
	<td width = '25%' class='EWLabelRB2'><font color="white">No TIN Reason</font></td>
	<td width = '25%' class='EWLabelRB2'><font color="white">Reason B : Remarks</font></td>
	</tr>
</table>
<!--**********New Shareholder/signatory/Beneficiary Details added as part of CR 28102020-->
<div class="accordion-group">
<div class="accordion-heading" id="div_ShareHolderDetails2">
	<tr id = "OECD_Header2" width=100% class='EWLabelRB2' bgcolor= "#990033">
		<input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 class='EWLabelRB2'><font color="white" size="3">Shareholder / Signatory / Beneficiary / Controlling Person Details</font></td>
	</tr>
</div>
<div class="accordion-inner">
	
	<table border='1' cellspacing='1' width=100% cellpadding='0' id ='shareholderTab2' colspan=5 style="height:10px;border-style: solid;border-width: thin;border-color: #990033;">					
		<tr bgcolor= "#990033" >
			<td width = '5%' style="text-align:center" class='EWLabelRB2'><font color="white">S.No.</font></td><input type='hidden' name='rowidselected' id='rowidselected' value=''/>
			<td width ='20%' style="text-align:center" class='EWLabelRB2'><font color="white">CIF ID</font></td>
			<td width ='30%' style="text-align:center" class='EWLabelRB2'><font color="white">Name</font></td>
			<td width ='22%' style="text-align:center" class='EWLabelRB2'><font color="white">Relationship Type</font></td>
			<td width ='22%' style="text-align:center" class='EWLabelRB2'><font color="white">Controlling Person Type</font></td>
		</tr>
	</table>
	
		
</div>
	<table border='1' cellspacing='1' cellpadding='0' width=100% id = "ShareHolderSection">
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CIF ID</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><input  class="NGReadOnlyView" type='text' name='cifid' style='width:200px' id='cifid' value='' maxlength='100'  onkeyup=""></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Financial Detail ID</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><input  class="NGReadOnlyView" type='text' name='financialdetailId' style='width:200px' id='financialdetailId' value='' maxlength='100'  onkeyup=""></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Name</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><input  class="NGReadOnlyView" type='text' name='name' style='width:200px' id='name' value='' maxlength='100'  onkeyup=""></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Relationship Type</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><input  class="NGReadOnlyView" type='text' name='relationshiptype' style='width:200px' id='relationshiptype' value='' maxlength='100'  onkeyup=""></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><font color="red">&nbsp;&nbsp;&nbsp;&nbsp;Current Residence Address</font></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'><font color="red">&nbsp;&nbsp;&nbsp;&nbsp;Mailing Address</font></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 1</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residenceaddrline1'  style='width:200px' id='residenceaddrline1' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 1</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='mailingaddrline1'  style='width:200px' id='mailingaddrline1' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 2</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residenceaddrline2'  style='width:200px' id='residenceaddrline2' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Address Line 2</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='mailingaddrline2'  style='width:200px' id='mailingaddrline2' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;City/Town</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residencecity'  style='width:200px' id='residencecity' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;City/Town</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='mailingcity'  style='width:200px' id='mailingcity' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Province/State/Country</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residencestate'  style='width:200px' id='residencestate' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Province/State/Country</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='mailingstate'  style='width:200px' id='mailingstate' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Postal Code/Zip Code</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residencezipcode'  style='width:200px' id='residencezipcode' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Postal Code/Zip Code</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='mailingzipcode'  style='width:200px' id='mailingzipcode' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Country</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residencecountry'  style='width:200px' id='residencecountry' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Country</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='mailingcountry'  style='width:200px' id='mailingcountry' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;U.S Citizenship / Residency details</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='residenceuscitizenship'  style='width:200px' id='residenceuscitizenship' maxlength='80'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Controlling Person Type</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='controllingpersontype'  style='width:200px' id='controllingpersontype' maxlength='80'  value=''>
			</td>
		</tr>
		<tr>		
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;CRS Undocumented Flag</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px' >
			<input  class="NGReadOnlyView"   type='text' name='crsundocumentedflag'  style='width:200px' id='crsundocumentedflag' maxlength='100'  value=''>
			</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;CRS Undocumented Reason</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
			<input  class="NGReadOnlyView"   type='text' name='crsundocumentedreason'  style='width:200px' id='crsundocumentedreason' maxlength='100'  value=''>
			</td>
		</tr>
	</table>
	
	<table border='1' cellspacing='1' width=100% cellpadding='0' id ='OECDGrid2' colspan=4 style="height:10px;border-style: solid;border-width: thin;border-color: #990033;">					
		<tr bgcolor= "#990033" >
		<td width = '25%' class='EWLabelRB2'><font color="white">Country Of Tax Residence</font></td>
		<td width = '25%' class='EWLabelRB2'><font color="white">Tax Payer Identification No</font></td>
		<td width = '25%' class='EWLabelRB2'><font color="white">No TIN Reason</font></td>
		<td width = '25%' class='EWLabelRB2'><font color="white">Reason B : Remarks</font></td>
		</tr>
	</table>
</div>

<div class ="gap">
</div>

<!-- Start - Added checklist details grid on 28102020 as part of CR -->
<div>
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="checklistGridHeader">
		<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><b><font color="white">Checklist Details</font></b></td>
		</tr>
		<tr><th  width='5%' class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">SR No</font></b></th><th  width='45%' class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Description</font></b></th><th  width='20%'class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Option</font></b></th></tr>
	</table>
	<div style="height:50px;border-style: solid;border-width: thin;border-color: #990033;" id="divchecklistGrid">
		<table border='1' cellspacing='1' cellpadding='0' width=100% id ='checklistGrid'>
		</table>
	</div>
</div>
<!-- End - Added checklist details grid on 28102020 as part of CR -->

<!--*********Error details header*****************-->
<%if((WSNAME.equals("Error_Handling"))){%>
<table border='1' cellspacing='1' cellpadding='0' width=100% id = "ErrorDetails">
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input  class="NGReadOnlyView" type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align="left" class='EWLabelRB2'><font color="white">Error Details</font></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Failed Integration Call
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView" disabled type='text' name='FAILEDINTEGRATIONCALL' style='width:200px' id='FAILEDINTEGRATIONCALL' value='<%=((CustomWorkdeskAttribute)attributeMap.get("FAILEDINTEGRATIONCALL")).getAttribValue().toString()%>' maxlength='100'  onkeyup="">
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Error Message/<br/>&nbsp;&nbsp;&nbsp;&nbsp;Description from MW</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>
		<input  class="NGReadOnlyView" disabled type='text' style='width:200px' name='MW_ERRORDESC'  id='MW_ERRORDESC' value='<%=((CustomWorkdeskAttribute)attributeMap.get("MW_ERRORDESC")).getAttribValue().toString()%>' maxlength=''  onkeyup="">
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;</td>
	</tr>
</table>
<%}%>
<!--*********Decision Header*****************-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id = "decisiondetails" >
		<tr  width=100% class='EWLabelRB2' bgcolor= "#990033">
		<input type='text' name='Header' readOnly size='24' style='display:none'><td colspan=4 align="left" class='EWLabelRB2'><font color="white" size="3">Decision</font></td>
		</tr>
		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px'>&nbsp;&nbsp;&nbsp;&nbsp;Decision </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' style='width:200px'>
		<select  class="NGReadOnlyView"  name="selectDecision" id="selectDecision" style='width:200px'  onchange="setComboValueToTextBox(this,'wdesk:DECISION')">
			<option value="">--Select--</option>
			
						

			
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:400px'>&nbsp;&nbsp;&nbsp;&nbsp;
		<input name='history' id="history"  type='button' value='Decision History' style='width:150px' onclick="openCustomDialog('Decision History','<%=WINAME%>','')" class='EWButtonRBSRM' >
		</td>
		
		</tr>
		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:200px' >&nbsp;&nbsp;&nbsp;&nbsp;Remarks
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' style='width:200px'>
		<textarea maxlength="3000" class='EWNormalGreenGeneral1'   rows="3"  style='width:200px' id="remarks" name="remarks"  onkeyup="ValidateAlphaNumeric('remarks');"></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' style='width:400px'>&nbsp;&nbsp;&nbsp;&nbsp;
		<input name='RejectReason' id="RejectReason" type='button' value='Reject Reason' style='width:150px' onclick="openCustomDialog('Reject Reasons','<%=WINAME%>','');" class='EWButtonRBSRM NGReadOnlyView'>&nbsp;&nbsp;&nbsp;&nbsp;
		<input name='ViewSignature' id="ViewSignature" type='button' style="width:150px" value='View Signature' onclick="openCustomDialog('View Signature','<%=WINAME%>','');" class='EWButtonRBSRM NGReadOnlyView' >
		</td>
		</tr>	
		
</table>

<!--*********all hidden fields*****************-->
<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
<input type="hidden" id="H_CHECKLIST" name="H_CHECKLIST"/>
<input type="hidden" id="wdesk:SOLID" name="wdesk:SOLID" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()%>'>
<input type="hidden" id="wdesk:WINAME" name="wdesk:WINAME" value='<%=WINAME%>'>
<input type='hidden' name="wdesk:CURRENT_WS" id="wdesk:CURRENT_WS" value='<%=WSNAME%>'/>
<input type="hidden" id="wdesk:INTRODUCED_BY" name="wdesk:INTRODUCED_BY" value='<%=customSession.getUserName()%>'>
<input type="hidden" id="wdesk:DECISION" name="wdesk:DECISION" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DECISION")).getAttribValue().toString()%>'>
<input type="hidden" id="wdesk:IS_DOC_ATTACHED" name="wdesk:IS_DOC_ATTACHED" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IS_DOC_ATTACHED")).getAttribValue().toString()%>'>
<input type='hidden' name="wdesk:AccountnoSig" id="wdesk:AccountnoSig"/>  
<input type='hidden' name="wdesk:ACCOUNTNO" id="wdesk:ACCOUNTNO" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ACCOUNTNO")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:SIGN_MATCHED_MAKER" id="wdesk:SIGN_MATCHED_MAKER" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SIGN_MATCHED_MAKER")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:SIGN_MATCHED_CHECKER" id="wdesk:SIGN_MATCHED_CHECKER" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SIGN_MATCHED_CHECKER")).getAttribValue().toString()%>'/>
<input type="hidden" id="wdesk: " name="wdesk:PREF_ADDRESS" value=''/>
<input type='hidden' name="wdesk:Share_Holder_Details" id="wdesk:Share_Holder_Details" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Share_Holder_Details")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:MainCIFUpdateStatus" id="wdesk:MainCIFUpdateStatus" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MainCIFUpdateStatus")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MainCIFUpdateStatus")).getAttribValue().toString()%>'/>



<!--*****************************************************************************************************************************************************-->


</form>
</body>
</html>
<%
}
%>
