
<!-------------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : CIFUpdates.jsp
//Author                     : Tanshu Aggarwal	
//Date written (DD/MM/YYYY)  : 05-Feb-2016
//Description                : Initial Header fixed form for CIF Updates
CHANGE HISTORY

---------------------------------------------------------------------------------------------------------------------------------------
Problem No/CR No              Change Date            Changed By             Change Description
-------------------------------------------------------------------------------------------------------------------------------------->

<%@ page import="java.util.Iterator"%>

<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %><%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>






<%@ include file="../header.process" %>

<script language="javascript" src="/CU/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/CU/webtop/scripts/jquery.autocomplete.js"></script>

<%!

public String getTagValues(String sXML, String sTagName) {
	String sTagValues = "";
	String sStartTag = "<" + sTagName + ">";
	String sEndTag = "</" + sTagName + ">";
	String tempXML = sXML;
	try {
		for (int i = 0; i < sXML.split(sEndTag).length - 1; i++) {
			if (tempXML.indexOf(sStartTag) != -1) {
				sTagValues += tempXML.substring(tempXML.indexOf(sStartTag)
				+ sStartTag.length(), tempXML.indexOf(sEndTag));
				tempXML = tempXML.substring(tempXML.indexOf(sEndTag)
				+ sEndTag.length(), tempXML.length());
			}
			if (tempXML.indexOf(sStartTag) != -1) {
				sTagValues += ",";
			}
		}
	} catch (Exception e) {
		System.out.println("Exception: " + e.getMessage());
	}
	return sTagValues;
}
%>
<%
String readOnlyFlag="";
String strHideReadOnly="";
String strDisableReadOnly="";
/*
try{
	readOnlyFlag=wdmodel.getViewMode();//get ReadOnly or not
	WriteLog("readOnlyFlag "+readOnlyFlag);
}catch(Exception e){}
if(readOnlyFlag!=null && readOnlyFlag.equalsIgnoreCase("R"))
{
	strHideReadOnly="style='display:none'";
	strDisableReadOnly="disabled";
}
WriteLog("strHideReadOnly "+strHideReadOnly);
WriteLog("strDisableReadOnly "+strDisableReadOnly);*/

String sCabName=customSession.getEngineName();	
String sSessionId = customSession.getDMSSessionId();
String sJtsIp = customSession.getJtsIp();
int iJtsPort = customSession.getJtsPort();

String colname="";   //Columns to be updated
String colvalues="";  //ColumnValues to be updated
String Query="";
String inputXML="";
String outputXML="";
String inputData="";
String outputData="";
String mainCodeValue="";
WFCustomXmlResponse xmlParserData=null;
WFCustomXmlList objWorkList=null;
WFCustomXmlResponse objXmlParser=null;
String subXML="";	
String documentValues[]=null;
String selectedDocumentValues[]=null;
String Query1="";
String maincode="";
String selectedDocs = "";
String Querycity="";
String Querycountry="";
String inputXMLcity="";
String inputXMLcountry="";
String outputXMLcity="";
String outputXMLcountry="";
String mainCodeValuecity="";
String mainCodeValuecountry="";
String params = "";
int recordcountcountry=0;
WFCustomXmlResponse xmlParserDatacountry=null;




int recordcountcity=0;

WFCustomXmlResponse xmlParserDatacity=null;

WFCustomXmlResponse objXmlParsercity=null;
String subXMLcity="";
String Querystate="";
String inputXMLstate="";
String outputXMLstate="";
String mainCodeValuestate="";
int recordcountstate=0;
WFCustomXmlResponse xmlParserDatastate=null;
WFCustomXmlResponse objXmlParserstate=null;
String subXMLstate="";	
String itemscity="";
String codescity="";
String itemscountry="";
String itemsstate="";
String codescountry="";
String items="";
String codes="";



String key="";
String value="";

	
if (parameterMap != null && parameterMap.size() > 0) {

	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	String outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID);
	
	WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
    attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";

	
	CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
	LinkedHashMap varIdMap = new LinkedHashMap();
	attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	session = request.getSession(false);
	/*Iterator<String> itr = attributeMap.keySet().iterator();
	
	while (itr.hasNext()) {
		key = (String) itr.next();
		 value = ((CustomWorkdeskAttribute) attributeMap.get(key)).getAttribValue().toString();
		out.println(key + " = " + value + "<br>");
	}*/
	
	
	try{
		selectedDocs = ((CustomWorkdeskAttribute)attributeMap.get("Supporting_Docs")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Supporting_Docs")).getAttribValue().toString();
	
		 //WriteLog"selectedDocs "+selectedDocs);
		
		if(selectedDocs!=null && !selectedDocs.equals(""))	
			selectedDocumentValues=selectedDocs.split("-");
			
	}catch(Exception e){}	
	
	
	Query="SELECT documentreq FROM usr_0_CU_requiredDoc WHERE field_name=:field_name";
	params = "field_name==FirstName_Existing";

	inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	
	//WriteLog"inputXML exceptions-->"+inputXML);
	outputXML = WFCustomCallBroker.execute(inputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog"outputXML exceptions-->"+outputXML);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((outputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	

	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
	String document="";
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{ 
			if(document.equals(""))
			{
				document=objWorkList.getVal("documentreq");
			}	
			else 
			{
				 //WriteLog"Unsuccessful");
			}		
		}
	}
	
	Query1="SELECT doc_name FROM usr_0_cu_requireddocmaster with(nolock) where 1=:ONE";
	params = "ONE==1";
	
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query1 + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query1 + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	 //WriteLog"inputData: "+inputData);
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	
	 //WriteLog"outputData: "+outputData);
	
	xmlParserData.setXmlString((outputData));
	maincode = xmlParserData.getVal("MainCode");
	
	if(maincode.equals("0"))
	{
		if(outputData.contains("doc_name"))
		{
			documentValues = getTagValues(outputData, "doc_name").split(",");
			//WriteLog("outputData2");
		}
	}
	
	String wiCurrentDecision="";
	 //WriteLog"here"+WSNAME);
	 //WriteLog"wiCurrentDecision"+wiCurrentDecision);
	String CSODocScanDecision="";
	String PBCreditApprovalDecision="";
	String CropsApprovalDecision="";
	String CBWCDecision="";
	String OPSCheckerReviewDecision="";
	String CBWCControlsDecision="";
	if(WSNAME.equalsIgnoreCase("CSO_Doc_Scan"))
	{
		if(wiCurrentDecision.equalsIgnoreCase("Approved"))
		{
			CSODocScanDecision="Approved";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
		{
			CSODocScanDecision="Rejected";
		}
	}
	else if(WSNAME.equalsIgnoreCase("PB_Credit_Approval"))
	{
		if(wiCurrentDecision.equalsIgnoreCase("Approved"))
		{
			PBCreditApprovalDecision="Approved";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
		{
			PBCreditApprovalDecision="Rejected";
		}
	}	
	else if(WSNAME.equalsIgnoreCase("Crops_Approval"))
	{
		if(wiCurrentDecision.equalsIgnoreCase("Approved"))
		{
			CropsApprovalDecision="Approved";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
		{
			CropsApprovalDecision="Rejected";
		}
	}	
	else if(WSNAME.equalsIgnoreCase("CB_WC"))
	{
		if(wiCurrentDecision.equalsIgnoreCase("Approved"))
		{
			CBWCDecision="Approved";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
		{
			CBWCDecision="Rejected";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Exception Found"))
		{
			CBWCDecision="Exception Found";
		}
	}
	else if(WSNAME.equalsIgnoreCase("OPS_Checker_Review"))
	{
		if(wiCurrentDecision.equalsIgnoreCase("Approved"))
		{
			OPSCheckerReviewDecision="Approved";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
		{
			OPSCheckerReviewDecision="Rejected";
		}
	}	
	else if(WSNAME.equalsIgnoreCase("CB_WC_Controls"))
	{
		if(wiCurrentDecision.equalsIgnoreCase("Approved"))
		{
			CBWCControlsDecision="Approved";
		}
		else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
		{
			CBWCControlsDecision="Rejected";
		}
	}
 %>
<script src="..\..\webtop\scripts\CU_Scripts\moment.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\jquery.min.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\bootstrap.min.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\jquery-ui.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\HandleAjaxRequest.js"></script>
<script src="..\..\webtop\scripts\CU_Scripts\tcal.js"></script>


<HTML>
<head>
<script type="text/javascript">
  	function confirmBackspaceNavigations () {
    
    var backspaceIsPressed = false
    $(document).keydown(function(event){
        if (event.which == 8) {
            backspaceIsPressed = true
        }
    })
    $(document).keyup(function(event){
        if (event.which == 8) {
            backspaceIsPressed = false
        }
    })
    $(window).on('beforeunload', function(){
        if (backspaceIsPressed) {
            backspaceIsPressed = false
            return "Are you sure you want to leave this page?"
        }
    })
}
  //  window.onpaint = confirmBackspaceNavigations();
</script>
	<script language="javascript">	
		document.onkeydown = mykeyhandler;
		
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 			
//Description                 :           To handle functioning of some specific keys

//***********************************************************************************//
		
	
		
		
		function mykeyhandler() {
			var elementType=window.event.srcElement.type;
			var eventKeyCode=window.event.keyCode;
			var isAltKey=window.event.altKey;
			if(eventKeyCode==83 && isAltKey){
				window.parent.workdeskOperations('S');//Save Workitem
			}
			else if(eventKeyCode==73 && isAltKey){
				window.parent.workdeskOperations('I');//Introduce Workitem
			}
			else if (eventKeyCode == 116) {
				window.event.keyCode = 0;
				return false;
			}else if (eventKeyCode == 8 && elementType!='text' && elementType!='textarea' && elementType!='submit' && elementType!='password' ) {
				window.event.keyCode = 0;
				return false;
			}else if (eventKeyCode == 8 && (elementType=='text' || elementType=='textarea'  || elementType=='password' ) && ((window.event.srcElement !== undefined) ? window.event.srcElement.readOnly : window.event.target.readOnly)) {
				window.event.keyCode = 0;
				return false;
			}
		}
		
		document.MyActiveWindows= new Array;

		function openWindow(sUrl,sName,sProps)
		{
			document.MyActiveWindows.push(window.open(sUrl,sName,sProps));
		}	
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 			
//Description                 :           To close all windows on unload

//***********************************************************************************//		
		function closeAllWindows()
		{
			for(var i = 0;i < document.MyActiveWindows.length; i++)
				document.MyActiveWindows[i].close();
		}

		window.onunload = function(){
			closeAllWindows()
		};		
	</script>
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\bootstrap.min.css">
	<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\CIFUpdates.css">
	<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\jquery-ui.css">
	<link rel="stylesheet" href="..\..\webtop\scripts\CU_Scripts\calendar.css">
	<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
	<style>
		#emid {
			border: 1px solid black;
			width: 100%;
			border-collapse: collapse;
    	}
		td {
			background-color : #FEFAEF;
			padding-top:2px;
			padding-left:2px;
			padding-right:2px;
			padding-bottom:2px;
			line-height: 22px;
		}
		th{
			padding-left:5px;
			padding-right:5px;
			padding-top:2px;
			padding-bottom:2px;
		}
		th
		{
			font:9pt Arial; font-size:14px; color:#444; background:#FEFAEF;
		}
		.accordion-heading {			
			padding:2px;
		}		
		.accordion-heading {
			background-color: #980033;
			border : 1px	 solid gray;
		}
		.panel-title > .small, .panel-title > .small > a, .panel-title > a, .panel-title > small, .panel-title > small > a {
			color: white;
		}
	</style>
	<title>CIF Updates</title>
	<style>
		@import url("/CU/webtop/en_us/css/docstyle.css");
	</style>
	<script type="text/javascript" language="javascript" src="eida_webcomponents.js"></script>
	<script>
		var Global = false;
		
		var selectIds = $('#panel1,#panel2,#panel3,#panel4,#panel5,#panel6,#panel7,#panel8,#panel9,#panel10,#panel11,#panel12,#panel13,#panel14,#panel15,#panel16');
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 		  Tanshu
//Description                 :           To show callender

//***********************************************************************************//
		$(function() {
			//$( "#wdesk\\:passportExpDate_new" ).datepicker({minDate: 0,changeYear: true });
			$('#wdesk\\:passportExpDate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 475, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 475+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true

			});
			
			//$( "#wdesk\\:date_join_curr_employer_new" ).datepicker({maxDate: 0,changeYear: true});
			$('#wdesk\\:date_join_curr_employer_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/3);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 3200, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 3200+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},maxDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			//$( "#wdesk\\:trade_lic_exp_date_new" ).datepicker({minDate: 0,changeYear: true}); 
			$('#wdesk\\:trade_lic_exp_date_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					alert("Future Use: use this value to change in code below for trade license expiry date calendar, value:"+($("body").scrollTop()));
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 475, left: rect.left });//need to change later
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 475+(xCenter+input.offsetHeight), left: rect.left });//need to change later
						}, 0);	
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			//$( "#wdesk\\:emiratesidexp_new" ).datepicker({minDate: 0,changeYear: true});
			$('#wdesk\\:emiratesidexp_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 415, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 415+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			//added by shamily to show callender signed date and expiry date
			$('#wdesk\\:SignedDate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 1000, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 600+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
						},maxDate: 0,dateFormat:'dd/mm/yy',changeYear: true //changed to stop future dates
			});
			$('#wdesk\\:ExpiryDate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 1000, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 600+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			$('#wdesk\\:DOB_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 415, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 415+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			
			//$( "#wdesk\\:visaExpDate_new" ).datepicker({minDate: 0,changeYear: true});
			$('#wdesk\\:visaExpDate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 535, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 535+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
						
						
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			//Added by Shamily to add calendar for Marsoon and EMREG dates
			$('#wdesk\\:marsoonExpDate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 535, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 535+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
						
						
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});

			$('#wdesk\\:EMREGExpirydate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 535, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 535+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
						
						
				},minDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			$('#wdesk\\:EMREGIssuedate_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 535, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 535+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},maxDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			//$( "#wdesk\\:wheninuae_new" ).datepicker({maxDate: 0,changeYear: true});
			$('#wdesk\\:wheninuae_new').datepicker({		
				beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 3350, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 3350+(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},maxDate: 0,dateFormat:'dd/mm/yy',changeYear: true
			});
			
			
						
			selectIds.on('show.bs.collapse hidden.bs.collapse', function() {
				$(this).prev().find('.glyphicon').toggleClass('glyphicon-plus glyphicon-minus');				
			});	
			if(window.parent.wiproperty.locked =="Y")			
				$( ".NGReadOnlyView" ).prop('disabled', true);
		});
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 			
//Description                 :           To fetch emirates id on clicking on read button

//***********************************************************************************//		 
		function callEIDA()
		{
			Initialize();
			DisplayPublicDataEx();
			document.getElementById("wdesk:emirates_id").value=fetchEID();
		}			
	</script>
	<script>
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 			
//Description                 :           To Sol Id on load and on clicking on fetch button

//***********************************************************************************//
	function fetchSolID() {
		
		var WSNAME = '<%=WSNAME%>';
		if (!((WSNAME == "CSO" || WSNAME == "PBO") && (document.getElementById("wdesk:SolId").value == "" || document.getElementById("wdesk:SolId").value == null))) {
			return true;
		}
		var xmlDoc;
		var x;
		var username = document.getElementById('username').innerHTML;
		
		var xLen;

		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "/CU/CustomForms/CU_Specific/fetchSolID.jsp";

		var param = "username=" + username;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);

		if (xhr.status == 200 && xhr.readyState == 4) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("SOl Id is not Set for this user.");
				return false;
			}
			document.getElementById("wdesk:SolId").value = ajaxResult;
		} else {
			alert("Problem in getting Sol ID.");
			return false;
		}
		return true;
	}



//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Tanshu
//Description                 :           function is used set combo value in text.

//***********************************************************************************// 
	function selectElement(idDropDown, idInput) {
		
		var elementDrop = document.getElementById(idDropDown);
		var elementSet = document.getElementById(idInput);

		if (elementDrop != null && elementSet != null) {
			var x = elementSet.value;

			if (x != "")
				elementDrop.value = x;
			else
				elementDrop.value = "--Select--";
		} else if (elementDrop != null)
			elementDrop.value = "--Select--";
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Amandeep
//Description                 :           function is used set multi select value in text.

//***********************************************************************************//
	function multiSelectElement(idDropDown, idInput) {
		var elementDrop = document.getElementById(idDropDown);
		var elementSet = document.getElementById(idInput);

		if (elementDrop != null && elementSet != null) {
			var x = elementSet.value;

			if (x != "") {
				var optArr = x.split("^");
				for (var i = 0; i < optArr.length; i++) {
					for (var j = 0; j < elementDrop.options.length; j++) {
						if (elementDrop.options[j].value == optArr[i]) {
							elementDrop.options[j].selected = true;
							break;
						}
					}
				}
			}
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to validate type of fields

//***********************************************************************************//	
	function validateKeys(e, act)
	{
		var re = "";
		if (e.value != "") {
			//Tanshu Aggarwal, to make comparison case independent.
			act = act.toLowerCase()
			switch (act) {
				case "alphabetic":
					re = /[^a-zA-Z ]+/i;
					break;
				case "numeric":
					re = /[^0-9]+/i;
					break;
				case "float":
					re = /[^0-9.-]+/i;
					break;
				case "alpha-numeric":
					re = /[^a-z0-9 ]+/i;
					break;
				case "alpha-numeric1":
					re = /[^a-z0-9- ]+/i;
					break;
				case "alphanumeric2":
					re = /[^a-z0-9-.,+#$%@;'\/\\~^&*()-+<>_!=:? ]+/i;
					break;
				case "alpha-numeric3":
					re = /[^a-z0-9-]+/i;
					break;
				case "alpha-numeric4":
					re = /[^a-z0-9-,]+/i;
					break;
				case "alpha-numeric5":
					re = /[^0-9-, ]+/i;
					break;
				case "alphacomments":
					re = /[^a-zA-Z ]+/i;
					break;
				case "alpha-numeric6":
					re = /[^a-zA-Z0-9 ]+/i;
					break;
				case "decimal":
					re = /[^0-9.]+/i;
					break;
				case "email":
					re = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/i;
					break;						
				case "pan card number":
					re = /[a-z]{3}[cphfatblj][a-z]\d{4}[a-z]/i;
					break;
				case "pincode":
					re = /^([1-9])([0-9]){5}$/i;
					break;
				case "date":
					re = /(0[1-9]|1\d|2\d|3[01])\/(0[1-9]|1[0-2])\/(19|20)\d{2}$/;
					break;
				case "mobile number":
					re = /^\d{10}$/;
					break;
				case "alphanumeric_address":
					re = /[^a-z0-9-.,+;'\/\\~()-+<>_=:? ]+/i;
					break;
					//addded by badri for special characters
			}

			if (re.test(e.value)) {

				if (act == 'alphabetic') {
					alert("This field is" + act);
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
				if (act == 'alpha-numeric') {
					alert("This field can only contain " + act);
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
				if (act == 'alpha-numeric6') {
					alert("This field can only contain alpha-numeric ");
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
				if (act == 'alpha-numeric1') {
					alert("This field can only contain " + act + " and special characters(@,_)");
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
				if (act == 'alphanumeric2') {
					alert("This field can only contain alpha-numeric and special characters(+#$%@;'\/\\~^&*()-+<>_!=:?)");
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
				if (act == 'numeric') {
					alert("This field can only contain " + act);
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}

				if (act == 'decimal') {
					alert("This field can only contain Numeric value or .");
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
				if (act == 'alphanumeric_address') {
					alert("This field can only contain alpha-numeric and special characters(+;'\/\\~()-+<>_=:?)");
					e.value = e.value.replace(re, "");
					e.focus();
					return false;
				}
			} else {
				if (act == "email") {
					alert("please enter valid " + act + " id");
					e.value = '';
					e.focus();
					return false;
				}

				if (act == 'account number') {
					alert("Please enter valid " + act);
					e.value = '';
					e.focus();
					return false;
				}

				if (act == "pan card number") {

					alert("Please enter valid " + act);
					e.value = '';
					e.focus();
					return false;

				}
				if (act == 'pincode') {
					alert("Please enter valid " + act);
					e.value = '';
					e.focus();
					return false;
				}

				if (act == 'date') {
					alert("Please enter valid " + act);
					e.value = '';
					e.focus();
					return false;
				}

				if (act == 'mobile number') {
					alert("Please enter valid " + act);
					e.value = '';
					e.focus();
					return false;
				}

			}

		} else if (act == "float") {
			try {
				if (!(parseFloat(e.value) == e.value)) {
					alert("Invalid float value.");
					e.focus();
					e.select();
					return false;
				}

			} catch (e) {
				alert("Invalid float value.");
				e.focus();
				e.select();
				return false;
			}
		}
		return true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 

//Author                      : 		  Shamily
//Description                 :           to show smart search for state and city 

//***********************************************************************************//
	function expiryDateset()
	{
		var signed_date = document.getElementById("wdesk:SignedDate_new").value; 
		
		
		var expdatemth = signed_date.substring(0,6);
		var expyear = signed_date.substring(6,10);
		expyear = parseInt(expyear,10)+3;
		
		// Start - fix for leap year signed exp date set added on 01032020
		var day = signed_date.substring(0,2);
		var month = signed_date.substring(3,5);
		if (day == 29 && month == 02)
		{
			expdatemth = '28/02/';
		}
		// End - fix for leap year signed exp date set added on 01032020
		
		if((expdatemth+expyear).indexOf("NaN")== -1 && (signed_date!="" && signed_date!=null)) //changed to handle junk
		document.getElementById("wdesk:ExpiryDate_new").value = expdatemth+expyear;
		else
		document.getElementById("wdesk:ExpiryDate_new").value = "";
		
		
	}
	
	<!-- modified to auto populate the city state for UAE country-->
	
	function setAutocompleteData() {
		
		
		var data = "";
		var ele = document.getElementById("AutocompleteValues");
		if (ele)
			data = ele.value;
			//alert('in autocomplete '+data);
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");
			
			$(document).ready(function() {
				$("#wdesk\\:Oecdcity_new").autocomplete({source: values}); //added for OECD City of Birth smart search by Shamily
			});				
		}
		
		data = "";
		if(document.getElementById("office_cntrycode").value == "AE")
		ele = document.getElementById("AutocompleteValuesofficecityAE");
		else if (document.getElementById("office_cntrycode").value != "AE" && document.getElementById("office_cntrycode").value != "--Select--" && document.getElementById("office_cntrycode").value != ""&& document.getElementById("office_cntrycode").value != null)
		ele = document.getElementById("AutocompleteValuesofficecitynotAE");
		else
		
		ele = document.getElementById("AutocompleteValues");
		if (ele)
			data = ele.value;
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");

			$(document).ready(function() {
				$("#wdesk\\:office_city").autocomplete({source: values});
			});				
		}
		
		data = "";
		if(document.getElementById("resi_cntrycode").value == "AE")
		ele = document.getElementById("AutocompleteValuesresicityAE");
		else if (document.getElementById("resi_cntrycode").value != "AE" && document.getElementById("resi_cntrycode").value != "--Select--" && document.getElementById("resi_cntrycode").value != ""&& document.getElementById("resi_cntrycode").value != null)
		ele = document.getElementById("AutocompleteValuesresicitynotAE");
		
		else
		ele = document.getElementById("AutocompleteValues");
		if (ele)
			data = ele.value;
			
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");

			$(document).ready(function() {
				$("#wdesk\\:resi_city").autocomplete({source: values});
			});				
		}
		
		data = "";
		if(document.getElementById("resi_cntrycode").value == "AE")
		ele = document.getElementById("AutocompleteValuesStateAE"); 
		else if (document.getElementById("resi_cntrycode").value != "AE" && document.getElementById("resi_cntrycode").value != "--Select--" && document.getElementById("resi_cntrycode").value != ""&& document.getElementById("resi_cntrycode").value != null)
		ele = document.getElementById("AutocompleteValuesStatenotAE");
		else 
		ele = document.getElementById("AutocompleteValuesState");
		if (ele)
			data = ele.value;
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");

			$(document).ready(function() {
				$("#wdesk\\:resi_state").autocomplete({source: values});
				
			});				
		}
		data = "";
		if(document.getElementById("office_cntrycode").value == "AE")
			ele = document.getElementById("AutocompleteValuesStateoffcAE");	
	 else if (document.getElementById("office_cntrycode").value != "AE" && document.getElementById("office_cntrycode").value != "--Select--" && document.getElementById("office_cntrycode").value != ""&& document.getElementById("office_cntrycode").value != null)
	 ele = document.getElementById("AutocompleteValuesStateoffcnotAE");	
	 
	 else
		ele = document.getElementById("AutocompleteValuesOffcState");
		
	if (ele)
		
			data = ele.value;
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");

			$(document).ready(function() {
				$("#wdesk\\:office_state").autocomplete({source: values});
			});				
		}
		
		
		data = "";
		ele = document.getElementById("AutocompleteValuesCountry");
		if (ele)
			data = "Oecdcountry_new="+ele.value;
			//data = ele.value;
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");
			//added for OECD country smart search by Shamily
			$(document).ready(function() {
				$("#wdesk\\:Oecdcountry_new").autocomplete({source: values});
				$("#wdesk\\:Oecdcountrytax_new").autocomplete({source: values});
				$("#wdesk\\:Oecdcountrytax_new2").autocomplete({source: values});
				$("#wdesk\\:Oecdcountrytax_new3").autocomplete({source: values});
				$("#wdesk\\:Oecdcountrytax_new4").autocomplete({source: values});
				$("#wdesk\\:Oecdcountrytax_new5").autocomplete({source: values});
				$("#wdesk\\:Oecdcountrytax_new6").autocomplete({source: values});
				
			});				
		}
		showlabel('Occupation');
		showlabel('Employement');
		//showlabel('Gender');
		showlabel('USRelation');
		showlabel('abcdelig');
		showlabel('IndustrySeg');
		showlabel('IndustrySubSeg');
		showlabel('marrital');
		//showlabel('E-Statement');
		showlabel('CustomerType');	
		var WSname = '<%=WSNAME%>';
		//Added by Shamily to set OECDUndoc_Flag_new value by default as "NO" 
		if(WSname == 'CSO')
		{
			 document.getElementById("decision").value = 'Approved';
			 document.getElementById("wdesk:Decision").value = 'Approved';
			if(document.getElementById("OECDUndoc_Flag_new").value == '--Select--')
			{
				document.getElementById("OECDUndoc_Flag_new").value = 'No';
				document.getElementById("wdesk:OECDUndoc_Flag_new").value = 'No';
			}
			
			
			//Added By Nikita on 16052018 for CU CRs Start
			/*if(document.getElementById("pref_contact_new").value == '--Select--')
			{
				document.getElementById("pref_contact_new").value = 'Mobile Phone';
			}*/
			//Added By Nikita on 16052018 for CU CRs End
		}
		if(WSname == 'CSO_Rejects')
		{
			if(document.getElementById("OECDUndoc_Flag_new").value == '--Select--')
			{
				document.getElementById("OECDUndoc_Flag_new").value = 'No';
				document.getElementById("wdesk:OECDUndoc_Flag_new").value = 'No';
			}
			
			//Added By Nikita on 16052018 for CU CRs Start
			/*if(document.getElementById("pref_contact_new").value == '--Select--')
			{
				document.getElementById("pref_contact_new").value = 'Mobile Phone';
			}*/
			//Added By Nikita on 16052018 for CU CRs End
		}
		if (WSname == 'OPS%20Maker_DE')
		{
			document.getElementById("OPSMakerDEDecision").value = 'Approve';
			document.getElementById("wdesk:OPSMakerDEDecision").value = 'Approve';
			//Added by Shamily to set OECDUndoc_Flag_new value by default as "NO" 
			if(document.getElementById("OECDUndoc_Flag_new").value == '--Select--')
			{
				document.getElementById("OECDUndoc_Flag_new").value = 'No';
				document.getElementById("wdesk:OECDUndoc_Flag_new").value = 'No';
			}
			
			//Added By Nikita on 16052018 for CU CRs Start
			/*if(document.getElementById("pref_contact_new").value == '--Select--')
			{
				document.getElementById("pref_contact_new").value = 'Mobile Phone';
			}*/
			//Added By Nikita on 16052018 for CU CRs End			
		}
		//added to check e-statement value on load
		document.getElementById("wdesk:E_Stmnt_regstrd_newload").value = document.getElementById("wdesk:E_Stmnt_regstrd_new").value;
		
		if(WSname == 'Reject')
		{
			 document.getElementById("decision").value = 'Reject';
			 document.getElementById("wdesk:Decision").value = 'Reject';
		}
		
	}

	function Citymapping()
	{
	var resi_cntrycode = document.getElementById("resi_cntrycode").value;
		var office_cntrycode = document.getElementById("office_cntrycode").value;
		//alert(resi_cntrycode);
		
			var reqType = 'resi_cntrycodeAE';
			
			var url = '';
			var xhr;
			var ajaxResult;			
			
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/CU/CustomForms/CU_Specific/HandleAjaxRequest.jsp?reqType='+reqType;//workstepname not required for country drop down
			//
			xhr.open("GET",url,false);
			xhr.send(null);
			//alert(xhr.status);
			 if (xhr.status == 200)
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 
			 if(ajaxResult.indexOf("Exception")==0)
			 {
				alert("Unknown Exception while working with request type "+reqType);
				return false;
			 }
			 
			 values = ajaxResult.split(",");
			 if(resi_cntrycode != 'AE' && resi_cntrycode != '--Select--' && resi_cntrycode != ''&& resi_cntrycode != null)
			 {
				document.getElementById("AutocompleteValuesresicitynotAE").value = 'resi_city='+values;
				document.getElementById("AutocompleteValuesStatenotAE").value = 'resi_state='+values;
			 }
			 if(office_cntrycode != 'AE' && office_cntrycode != '--Select--' && office_cntrycode != '' && office_cntrycode != 'AE' && office_cntrycode != null)
			 {
				document.getElementById("AutocompleteValuesofficecitynotAE").value = 'office_city='+values;
				document.getElementById("AutocompleteValuesStateoffcnotAE").value = 'office_state='+values;
				
				/*if((document.getElementById('office_city').value == 'AL AIN' || document.getElementById('office_city').value == 'DUBAI') && document.getElementById('office_cntrycode').value != 'AE')
					{
						document.getElementById('office_cntrycode').value = '--Select--';
						//document.getElementById('wdesk:office_cntrycode').value = '--Select--';
					}*/
				
				//alert(document.getElementById("office_state").value);
				//if(document.getElementById("AutocompleteValuesStateoffcAE").value.indexOf(document.getElementById("office_state").value) != -1)
				//	document.getElementById("office_state").value = "";
					if(document.getElementById("AutocompleteValuesofficecityAE").value.indexOf(document.getElementById("wdesk:office_city").value) != -1 && document.getElementById("wdesk:office_city").value != "" && document.getElementById("wdesk:office_city").value != null)
					{
						document.getElementById('office_cntrycode').value = '--Select--';
						alert('Selected country should be UAE as city belonges to one of Emirates');
					}	
					if(document.getElementById("AutocompleteValuesStateoffcAE").value.indexOf(document.getElementById("wdesk:office_state").value) != -1 && document.getElementById("wdesk:office_state").value != "" && document.getElementById("wdesk:office_state").value != null)
					{
						document.getElementById('office_cntrycode').value = '--Select--';	
						alert('Selected country should be UAE as state belonges to one of Emirates');
					}	
					/*if(document.getElementById("AutocompleteValuesresicityAE").value.indexOf(document.getElementById("resi_city").value) != -1 && document.getElementById("resi_city").value != "" && document.getElementById("resi_city").value != null)
					{
						document.getElementById('resi_city').value = '';	
						alert('Selected country should be UAE as city belonges to one of Emirates');
					}	
					if(document.getElementById("AutocompleteValuesStateAE").value.indexOf(document.getElementById("resi_state").value) != -1&& document.getElementById("resi_state").value != "" && document.getElementById("resi_state").value != null)
					{
						document.getElementById('resi_cntrycode').value = '--Select--';
						alert('Selected country should be UAE as state belonges to one of Emirates');
					}	*/
			 }	
			
		}
		else 
		{
			alert("Error while handling "+reqType+" for the current workstep");
			return false;
		}
	
	
	
	}
	
	
	function Countrymapping(WSNAME)
	{
	if(WSNAME=='CSO' || WSNAME == 'OPS%20Maker_DE' || WSNAME == "CSO_Rejects")
		{
		var resi_cntrycode = document.getElementById("resi_cntrycode").value;
		var office_cntrycode = document.getElementById("office_cntrycode").value;
		//alert(resi_cntrycode);
		
			var reqType = 'resi_cntrycode';
			
			var url = '';
			var xhr;
			var ajaxResult;			
			
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/CU/CustomForms/CU_Specific/HandleAjaxRequest.jsp?reqType='+reqType;//workstepname not required for country drop down
			//
			xhr.open("GET",url,false);
			xhr.send(null);
			//alert(xhr.status);
			 if (xhr.status == 200)
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 
			 if(ajaxResult.indexOf("Exception")==0)
			 {
				alert("Unknown Exception while working with request type "+reqType);
				return false;
			 }
			 
			 values = ajaxResult.split(",");
			 if(resi_cntrycode == 'AE')
			 {
				document.getElementById("AutocompleteValuesresicityAE").value = 'resi_city='+values;
				document.getElementById("AutocompleteValuesStateAE").value = 'resi_state='+values;
			 }
			 if(office_cntrycode == 'AE')
			 {
				document.getElementById("AutocompleteValuesofficecityAE").value = 'office_city='+values;
				document.getElementById("AutocompleteValuesStateoffcAE").value = 'office_state='+values;
				//alert(document.getElementById("office_state").value);
				if(document.getElementById("AutocompleteValuesStateoffcAE").value.indexOf(document.getElementById("wdesk:office_state").value) == -1 && document.getElementById("wdesk:office_state").value != "" && document.getElementById("wdesk:office_state").value != null)
					{
						document.getElementById("wdesk:office_state").value = "";
						alert('Selected state should be one of the Emirates as selected country is UAE');
					}	
					if(document.getElementById("AutocompleteValuesofficecityAE").value.indexOf(document.getElementById("wdesk:office_city").value) == -1 && document.getElementById("wdesk:office_city").value != "" && document.getElementById("wdesk:office_city").value != null)
					{
						document.getElementById("office_city").value = "";
						alert('Selected city should be one of the Emirates as selected country is UAE');
					}if(document.getElementById("AutocompleteValuesofficecityAE").value.indexOf(document.getElementById("wdesk:resi_city").value) == -1  && document.getElementById("wdesk:resi_city").value != "" && document.getElementById("wdesk:resi_city").value != null)
					{
						document.getElementById("wdesk:resi_city").value = "";
						alert('Selected city should be one of the Emirates as selected country is UAE');
					}	if(document.getElementById("AutocompleteValuesofficecityAE").value.indexOf(document.getElementById("wdesk:resi_state").value) == -1  && document.getElementById("wdesk:resi_state").value != "" && document.getElementById("resi_state").value != null)
					{
						document.getElementById("wdesk:resi_state").value = "";
						alert('Selected state should be one of the Emirates as selected country is UAE');
					}	
			 }	
			
		}
		else 
		{
			alert("Error while handling "+reqType+" for the current workstep");
			return false;
		}
	
		Citymapping();
		
	 }
	 setAutocompleteData();
	}


//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to get detail of signature checked status

//***********************************************************************************//
	function insert(str, index, value) {
		return str.substr(0, index) + value + str.substr(index);
	}

	function cifdata_update() {
		document.getElementById("wdesk:cif_data_update").value = "Yes";
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To display description of field based on code.

//***********************************************************************************//	
	function showlabel(req)
	{	
		var url = '';
		var values ="";

		var ajaxResult;	
		
		if(req=="Occupation")
			values = document.getElementById("wdesk:occupation_exist").value;				
		else if(req=="Employement")
			values = document.getElementById("wdesk:emp_type_exis").value;
		else if(req=="Gender")
		{				
			if(document.getElementById("wdesk:gender_exit").value =="F")
				document.getElementById("wdesk:gender_exit").value="Female";
			else if(document.getElementById("wdesk:gender_exit").value =="M")
				document.getElementById("wdesk:gender_exit").value="Male";
		}
		else if(req=="USRelation")
			values = document.getElementById("wdesk:USrelation").value;
		else if(req=="abcdelig")
		{				
			if(document.getElementById("wdesk:abcdelig_exis").value =="Y")
				document.getElementById("wdesk:abcdelig_exis").value="Yes";
			else if(document.getElementById("wdesk:abcdelig_exis").value =="N")
				document.getElementById("wdesk:abcdelig_exis").value="No";
		}
		else if(req=="IndustrySeg")
			values = document.getElementById("wdesk:IndustrySegment_exis").value;
		else if(req=="IndustrySubSeg")
			values = document.getElementById("wdesk:IndustrySubSegment_exis").value;
		else if(req=="marrital")
			values = document.getElementById("wdesk:marrital_status_exis").value;
		else if(req=="E-Statement")
		{				
			if(document.getElementById("wdesk:E_Stmnt_regstrd_exis").value =="Y")
				document.getElementById("wdesk:E_Stmnt_regstrd_exis").value="Yes";
			else if(document.getElementById("wdesk:E_Stmnt_regstrd_exis").value =="N")
				document.getElementById("wdesk:E_Stmnt_regstrd_exis").value="No";			
		}	
		else if(req=="CustomerType")
			values = document.getElementById("wdesk:CustomerType_exis").value;
			else if(req=="office_cntrycode")
			values = document.getElementById("offcCountry1").value;
			else if(req=="resi_country")
			values = document.getElementById("wdesk:resi_countryexis").value;
		






		
		var xhr;
		if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
		url = '/CU/CustomForms/CU_Specific/ShowLabel.jsp';
		
		var param="values="+values+'&req='+req;
		
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');		
		xhr.send(param);

		if (xhr.status == 200 && xhr.readyState == 4)
		{
			ajaxResult=xhr.responseText;
			ajaxResult=ajaxResult.replace(/^\s+|\s+$/gm,'');
			
			if(ajaxResult.indexOf("Exception")==0)
				return false;
			
			if(req == 'Occupation' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:occupation_exist").value=ajaxResult;
			else if(req == 'Employement' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:emp_type_exis").value=ajaxResult;
			else if(req == 'USRelation' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:USrelation").value=ajaxResult;
			else if(req == 'IndustrySeg' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:IndustrySegment_exis").value=ajaxResult;
			else if(req == 'IndustrySubSeg' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:IndustrySubSegment_exis").value=ajaxResult;
			else if(req == 'marrital' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:marrital_status_exis").value=ajaxResult;
			else if(req == 'CustomerType' && ajaxResult !="" && ajaxResult !=null)
				document.getElementById("wdesk:CustomerType_exis").value=ajaxResult;
				else if(req == 'office_cntrycode' && ajaxResult !="" && ajaxResult !=null)
				{
					document.getElementById("office_cntrycode").value=ajaxResult;		
					document.getElementById("wdesk:office_cntrycode").value=ajaxResult;		
					
					}
				else if(req == 'resi_country' && ajaxResult !="" && ajaxResult !=null)
				{
					document.getElementById("resi_cntrycode").value=ajaxResult;		
					document.getElementById("wdesk:resi_cntrycode").value=ajaxResult;		
					
				}



		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to check whether the pdf has been generated.

//***********************************************************************************//	
	function CheckForTemplates(typeDoc) {

		if (typeDoc == "CIF_Update_form")
			document.getElementById("wdesk:validation").value = "Y";
		
		if (typeDoc == "FATCA_Individual")
			document.getElementById("wdesk:validationFatca").value = "Y";
		
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to get check boxes detail

//***********************************************************************************//
	function getCheckboxDetails(Object) {
		var checkboxes = Object.checked;

		if (checkboxes) {
			var ids = Object.id;
			if (ids.indexOf('signatureupdate') != -1) {
				var data_signatureupdate = document.getElementById("signature_update").value;
				if (data_signatureupdate.indexOf("UNCHECK" + ids) != -1) {
					data_signatureupdate = data_signatureupdate.replace("UNCHECK" + ids, "CHECKED" + ids);
				} else
					data_signatureupdate = insert(data_signatureupdate, data_signatureupdate.indexOf(ids), "CHECKED");

				document.getElementById("signature_update").value = data_signatureupdate;
				document.getElementById("wdesk:sign_update").value = "Yes";
			} else if (ids.indexOf('dormancyactivation') != -1) {
				var data_signatureupdate = document.getElementById("dormancy_activation").value;
				if (data_signatureupdate.indexOf("UNCHECK" + ids) != -1) {
					data_signatureupdate = data_signatureupdate.replace("UNCHECK" + ids, "CHECKED" + ids);
				} else
					data_signatureupdate = insert(data_signatureupdate, data_signatureupdate.indexOf(ids), "CHECKED");
				document.getElementById("dormancy_activation").value = data_signatureupdate;
				document.getElementById("wdesk:dorman_activation").value = "Dormancy activation";
				dormancy();

			} else if (ids.indexOf('soletojoint') != -1) {
				var data_signatureupdate = document.getElementById("sole_to_joint").value;
				if (data_signatureupdate.indexOf("UNCHECK" + ids) != -1) {
					data_signatureupdate = data_signatureupdate.replace("UNCHECK" + ids, "CHECKED" + ids);
				} else
					data_signatureupdate = insert(data_signatureupdate, data_signatureupdate.indexOf(ids), "CHECKED");
				document.getElementById("sole_to_joint").value = data_signatureupdate;
				document.getElementById("wdesk:sole_joint").value = "Yes";
				
			} else if (ids.indexOf('jointtosole') != -1) {
				var data_signatureupdate = document.getElementById("joint_to_sole").value;
				if (data_signatureupdate.indexOf("UNCHECK" + ids) != -1) {
					data_signatureupdate = data_signatureupdate.replace("UNCHECK" + ids, "CHECKED" + ids);
				} else
					data_signatureupdate = insert(data_signatureupdate, data_signatureupdate.indexOf(ids), "CHECKED");
				document.getElementById("joint_to_sole").value = data_signatureupdate;
				document.getElementById("wdesk:joint_sole").value = "Yes";
				
			}
		} else {
			var ids = Object.id;
			if (ids.indexOf('signatureupdate') != -1) {
				var data_signatureupdate = document.getElementById("signature_update").value;
				
				data_signatureupdate = data_signatureupdate.replace("CHECKED" + ids, "UNCHECK" + ids);
				document.getElementById("signature_update").value = data_signatureupdate;
				if (data_signatureupdate.indexOf("CHECKED") == -1)
					document.getElementById("wdesk:sign_update").value = "No";
				
			} else if (ids.indexOf('dormancyactivation') != -1) {
				var data_signatureupdate = document.getElementById("dormancy_activation").value;
				data_signatureupdate = data_signatureupdate.replace("CHECKED" + ids, "UNCHECK" + ids);
				document.getElementById("dormancy_activation").value = data_signatureupdate;
				if (data_signatureupdate.indexOf("CHECKED") == -1)
					document.getElementById("wdesk:dorman_activation").value = "No";
				
			} else if (ids.indexOf('soletojoint') != -1) {
				var data_signatureupdate = document.getElementById("sole_to_joint").value;
				data_signatureupdate = data_signatureupdate.replace("CHECKED" + ids, "UNCHECK" + ids);
				document.getElementById("sole_to_joint").value = data_signatureupdate;
				if (data_signatureupdate.indexOf("CHECKED") == -1)
					document.getElementById("wdesk:sole_joint").value = "No";
				
			} else if (ids.indexOf('jointtosole') != -1) {
				var data_signatureupdate = document.getElementById("joint_to_sole").value;
				data_signatureupdate = data_signatureupdate.replace("CHECKED" + ids, "UNCHECK" + ids);
				document.getElementById("joint_to_sole").value = data_signatureupdate;
				if (data_signatureupdate.indexOf("CHECKED") == -1)
					document.getElementById("wdesk:joint_sole").value = "No";

			}
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Tanshu
//Description                 :           to get request type as dormancy activation

//***********************************************************************************//	
	
	function dormancy() {
		if (document.getElementById("wdesk:Request_Type_Master").value != null || document.getElementById("wdesk:Request_Type_Master").value != "" || document.getElementById("wdesk:Request_Type_Master").value != " ") {
			var str = document.getElementById("wdesk:Request_Type_Master").value;
			if (str.indexOf("Dormancy activation") != -1) {
				return;
			} else {
				document.getElementById("wdesk:Request_Type_Master").value = document.getElementById("wdesk:Request_Type_Master").value + "-" + document.getElementById("wdesk:dorman_activation").value;
				return;
			}
		} else
			document.getElementById("wdesk:Request_Type_Master").value = document.getElementById("wdesk:dorman_activation").value;
		
	}

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to trim spaces 

//***********************************************************************************//	
	
	function trim(str) {
		if (undefined == str)
			return "";
		return str.replace(/^\s+|\s+$/g, '');
	}

	function getACTObj() {
		
		if (window.XMLHttpRequest)
			return new XMLHttpRequest


		var
			a = ["Microsoft.XMLHTTP", "MSXML2.XMLHTTP.6.0", "MSXML2.XMLHTTP.5.0", "MSXML2.XMLHTTP.4.0", "MSXML2.XMLHTTP.3.0", "MSXML2.XMLHTTP"];
		for (var c = 0; c < a.length; c++) {
			try {
				return new ActiveXObject(a[c])
			} catch (b) {
		
			}
		}
		return null;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to print data on pdf

//***********************************************************************************//
	function doPostAjax(url, sParams) {
		
		var retval = "-1";
		var req = getACTObj();
		req.onreadystatechange = processRequest;
		req.open("POST", url, false);
		req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		req.send(sParams);
		
		function processRequest() {

			if (req.readyState == 4) {
				if (req.status == 200)
					parseMessages();
				else
					retval = '-1';
			}
		}

		function parseMessages() {
			retval = trim(req.responseText);
			pdfName = retval;
		}
		return retval;
	}

	var sparam = '';
	var pdfName = "";
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to get URL of the file to create pdf

//***********************************************************************************//
	function pausecomp(millis)
	{
		var date = new Date();
		var curDate = null;
		do { curDate = new Date(); }
		while(curDate-date < millis);
	}

	function getURL(option) {
	
		//var WD_UID = document.getElementById('wd_uid').value;
		var url = "";

		if (option == 'SignatureUpdate') {
			var date = new Date(); 
			var branch_name = "RAQ"; //document.getElementById(''); //??????
			var winame = "CU-0000000032";
			var Acc_Number = document.getElementById('wdesk:account_number').value;
			url = 'createPDF.jsp?Date1=' + date + '&Branch_Name=' + branch_name + '&Account_Number=' + Acc_Number + '&wi_name=' + winame + '&option=' + option;
		} else if (option == 'DormancyActivation') {
			//
		} else if (option == 'CIF_Update_form') {
			//added existing fields to display existing fields on the pdf
			var title_exis = document.getElementById('wdesk:title_exis').value;
			var firstname_exis = document.getElementById('wdesk:FirstName_Existing').value;
			var middlename_exis = document.getElementById('wdesk:MiddleName_Existing').value;
			var lastname_exis = document.getElementById('wdesk:LastName_Existing').value;
			var fullname_exis = document.getElementById('wdesk:FullName_Existing').value;
			//var shortname_exis =  document.getElementById('wdesk:ShortName_Existing').value; 
			var emiratesid_exis = document.getElementById('wdesk:emirates_id').value;
			var emiratesex_exis = document.getElementById('wdesk:emiratesidexp_exis').value;
			var passportnum_exis = document.getElementById('wdesk:PassportNumber_Existing').value;
			var passportexp_exis = document.getElementById('wdesk:passportExpDate_exis').value;
			var visa_exis = document.getElementById('wdesk:visa_exis').value;
			var visaexp_exis = document.getElementById('wdesk:visaExpDate_exis').value;
			var mother_exis =  "Data On File"; 
			//added by stutee.mishra for POD/PL changes on RI Form.
			var langOfPref_exis = document.getElementById('wdesk:prefOfLanguage_exis').value;
			var peopleOfDet_exis = document.getElementById('wdesk:peopleOfDeterm_exis').value;
			var podOptions_exis = document.getElementById('wdesk:PODOptions_exis').value;
			var podRemarks_exis = document.getElementById('wdesk:PODRemarks_exis').value.substring(0,134);
			
            //var mother_exis = document.getElementById('wdesk:mother_maiden_name_exis').value;
			//var usnation_exis =  document.getElementById('wdesk:usnatholder_exis').value; 
			//var usresi_exis =  document.getElementById('wdesk:usresi_exis').value; 
			// var usgreen_exis =  document.getElementById('wdesk:usgreencardhol_exis').value; 
			// var ustax_exis =  document.getElementById('wdesk:us_tax_payer_exis').value; 
			//  var uscitizen_exis =  document.getElementById('wdesk:us_citizen_exis').value;                          
			//   var cntrybirth_exis =  document.getElementById('wdesk:nocnofbirth_exis').value; 
			var abcde_exis = document.getElementById('wdesk:abcdelig_exis').value;
			var resiadd_exis = document.getElementById('resiadd_exis').value;
			var officeadd_exis = document.getElementById('office_add_exis').value;
			var prefadd_exis = document.getElementById('wdesk:pref_add_exis').value;
			var primid_exis = document.getElementById('wdesk:prim_email_exis').value;
			var secid_exis = document.getElementById('wdesk:sec_email_exis').value;
			var estate_exis = document.getElementById('wdesk:E_Stmnt_regstrd_exis').value;
			var mobile1_exis = document.getElementById('wdesk:MobilePhone_Existing').value;
			var mobile2_exis = document.getElementById('wdesk:sec_mob_phone_exis').value;
			var hmephn_exis = document.getElementById('wdesk:homephone_exis').value;
			var offcphn_exis = document.getElementById('wdesk:office_phn_exis').value;
			var hmecntryphn_exis = document.getElementById('wdesk:homecntryphone_exis').value;
			var prefcontact_exis = document.getElementById('wdesk:pref_contact_exis').value;
			var emptype_exis = document.getElementById('wdesk:emp_type_exis').value;
			var designation_exis = document.getElementById('wdesk:designation_exis').value;
			var compname_exis = document.getElementById('wdesk:comp_name_exis').value;
			var empname_exis = document.getElementById('wdesk:emp_name_exis').value;
			var department_exis = document.getElementById('wdesk:department_exis').value;
			var empnum_exis = document.getElementById('wdesk:employee_num_exis').value;
			var occupation_exis = document.getElementById('wdesk:occupation_exist').value;
			var nameofbusi_exis = document.getElementById('wdesk:name_of_business_exis').value;
			var totalyrsemp_exis = document.getElementById('wdesk:total_year_of_emp_exis').value;
			var yrsbusi_exis = document.getElementById('wdesk:years_of_business_exis').value;
			var empstatus_exis = document.getElementById('wdesk:employment_status_exis').value;
			var datejoining_exis = document.getElementById('wdesk:date_join_curr_employer_exis').value;
			var marital_exis = document.getElementById('wdesk:marrital_status_exis').value;
			var dependents_exis = document.getElementById('wdesk:no_of_dependents_exis').value;
			//var cntryresi_exis =  document.getElementById('wdesk:country_of_res_exis').value; 
			var nationality_exis = document.getElementById('wdesk:nation_exist').value;
			var wheninuae_exis = document.getElementById('wdesk:wheninuae_exis').value;
			var prevorgan_exis = document.getElementById('wdesk:prev_organ_exis').value;
			var periodorgan_exis = document.getElementById('wdesk:period_organ_exis').value;
			var fax_exis = document.getElementById('wdesk:fax_exis').value;
			//ended here for the existing fields
			
			var Full_Name = document.getElementById('wdesk:FirstName_New').value;
			var Emirates_Id = document.getElementById('wdesk:emiratesid_new').value;
			var Contact = document.getElementById('contact_details').value;
			var title = document.getElementById('title_new').value;
			var MiddleName = document.getElementById('wdesk:MiddleName_New').value;
			var LastName = document.getElementById('wdesk:LastName_New').value;
			var FullName = document.getElementById('wdesk:FullName_New').value;
			//var ShortName =  document.getElementById('wdesk:ShortName_New').value; 
			var Gender = document.getElementById('gender_new').value;
			var passportNum = document.getElementById('wdesk:PassportNumber_New').value;
			var EmiratesidExp = document.getElementById('wdesk:emiratesidexp_new').value;
			var PassExpdate = document.getElementById('wdesk:passportExpDate_new').value;
			var Visa = document.getElementById('wdesk:visa_new').value;
			var VisaExpDate = document.getElementById('wdesk:visaExpDate_new').value;
			var Mother = document.getElementById('wdesk:mother_maiden_name_new').value;
			//added by stutee.mishra for POD/PL changes on RI Form.
			var langOfPref_new = document.getElementById('prefOfLanguage').value;
			if(langOfPref_new == "--Select--")
				langOfPref_new = "";
			var peopleOfDet_new = document.getElementById('peopleOfDeterm').value;
			if(peopleOfDet_new == "--Select--")
				peopleOfDet_new = "";
			var podOptionsCurr_new = document.getElementById('wdesk:PODOptions').value;
			var optionsArr = podOptionsCurr_new.split("|");
			var podOptions_new = "";
			for(var j=0;j<optionsArr.length;j++)
				{
					if(optionsArr[j] == 'HEAR'){
						podOptions_new = podOptions_new+'Hearing'+',';
					}else if(optionsArr[j] == 'COGN'){
						podOptions_new = podOptions_new+'Cognitive'+',';
					}else if(optionsArr[j] == ("NEUR")){
						podOptions_new = podOptions_new+'Neurological'+',';
					}else if(optionsArr[j] == 'PHYS'){
						podOptions_new = podOptions_new+'Physical'+',';
					}else if(optionsArr[j] == 'SPCH'){
						podOptions_new = podOptions_new+'Speech'+',';
					}else if(optionsArr[j] == 'VISL'){
						podOptions_new = podOptions_new+'Visual'+',';
					}else if(optionsArr[j] == 'OTHR'){
						podOptions_new = podOptions_new+'Others'+',';
					}
				}
			podOptions_new = podOptions_new.substring(0,(podOptions_new.length)-1);	
			var podRemarks_new = document.getElementById('wdesk:PODRemarks').value.substring(0,134);
			podRemarks_new = podRemarks_new.replace('&','and');
			//var nation =  document.getElementById('usnatholder_new').value; 
			//var usresi =  document.getElementById('usresi_new').value; 
			//var greencard =  document.getElementById('usgreencardhol_new').value; 
			//var tax =  document.getElementById('us_tax_payer_new').value; 
			//var citizen =  document.getElementById('us_citizen_new').value; 
			//var birth =  document.getElementById('wdesk:nocnofbirth_new').value; 

			var Aecb = document.getElementById('abcdelig_new').value;
			var resi1 = document.getElementById('wdesk:resi_line1').value;
			var resi2 = document.getElementById('wdesk:resi_line2').value;
			var resi3 = document.getElementById('wdesk:resi_line3').value;
			var resi4 = document.getElementById('wdesk:resi_line4').value;
			var resi_type = document.getElementById('resi_restype').options[document.getElementById('resi_restype').selectedIndex].text;
			var resi_po = document.getElementById('wdesk:resi_pobox').value;
			var resi_zip = document.getElementById('wdesk:resi_zipcode').value;
			var resi_country =   document.getElementById('resi_cntrycode').options[document.getElementById('resi_cntrycode').selectedIndex].text;
			var resi_state = document.getElementById('wdesk:resi_state').value;
			var resi_city = document.getElementById('wdesk:resi_city').value;
			var offc1 = document.getElementById('wdesk:office_line1').value;
			var offc2 = document.getElementById('wdesk:office_line2').value;
			var offc3 = document.getElementById('wdesk:office_line3').value;
			var offc4 = document.getElementById('wdesk:office_line4').value;
			var offc_type = document.getElementById('office_restype').options[document.getElementById('office_restype').selectedIndex].text;
			var offc_po = document.getElementById('wdesk:office_pobox').value;
			var offc_zip = document.getElementById('wdesk:office_zipcode').value;
			var offc_country = document.getElementById('office_cntrycode').options[document.getElementById('office_cntrycode').selectedIndex].text;
			var offc_state = document.getElementById('wdesk:office_state').value;
			var offc_city = document.getElementById('wdesk:office_city').value;
			var pref_add = document.getElementById('pref_add_new').value;
			var prim_id = document.getElementById('wdesk:primary_emailid_new').value;
			var sec_id = document.getElementById('wdesk:sec_email_new').value;
			var e_state = document.getElementById('E_Stmnt_regstrd_new').value;
			var mob1 = document.getElementById('wdesk:MobilePhone_New1').value;
			var mob2 = document.getElementById('wdesk:MobilePhone_New').value;
			var mob3 = document.getElementById('wdesk:MobilePhone_New2').value;
			var mob21 = document.getElementById('wdesk:sec_mob_phone_newC').value;
			var mob22 = document.getElementById('wdesk:sec_mob_phone_newN').value;
			var mob23 = document.getElementById('wdesk:sec_mob_phone_newE').value;
			var homephone1 = document.getElementById('wdesk:homephone_newC').value;
			var homephone2 = document.getElementById('wdesk:homephone_newN').value;
			var homephone3 = document.getElementById('wdesk:homephone_newE').value;
			var offc_phn1 = document.getElementById('wdesk:office_phn_newC').value;
			var offc_phn2 = document.getElementById('wdesk:office_phn_new').value;
			var offc_phn3 = document.getElementById('wdesk:office_phn_newE').value;
			var fax1 = document.getElementById('wdesk:fax_newC').value;
			var fax2 = document.getElementById('wdesk:fax_new').value;
			var fax3 = document.getElementById('wdesk:fax_newE').value;
			var home_cntry_phn1 = document.getElementById('wdesk:homecntryphone_newC').value;
			var home_cntry_phn2 = document.getElementById('wdesk:homecntryphone_newN').value;
			var home_cntry_phn3 = document.getElementById('wdesk:homecntryphone_newE').value;
			var pref_contact = document.getElementById('pref_contact_new').value;
			var emp_type = document.getElementById('emp_type_new').options[document.getElementById('emp_type_new').selectedIndex].text;
			var designation = document.getElementById('wdesk:designation_new').value;
			var comp_name = document.getElementById('wdesk:comp_name_new').value;
			var emp_new_name = document.getElementById('wdesk:emp_name_new').value;
			var department = document.getElementById('wdesk:department_new').value;
			var emp_num = document.getElementById('wdesk:employee_num_new').value;
			var occupation =  document.getElementById('occupation_new').options[document.getElementById('occupation_new').selectedIndex].text; 
			var nature_of_busi = document.getElementById('wdesk:naturebusiness_new').value;
			var years_of_emp = document.getElementById('wdesk:total_year_of_emp_new').value;
			var years_of_business = document.getElementById('wdesk:years_of_business_new').value;
			var emp_status = document.getElementById('employment_status_new').options[document.getElementById('employment_status_new').selectedIndex].text;
			var date_joining = document.getElementById('wdesk:date_join_curr_employer_new').value;
			//var marrital =  document.getElementById('wdesk:marrital_status_new').value;  
			var marrital =  document.getElementById('marrital_status_new').options[document.getElementById('marrital_status_new').selectedIndex].text;  
			var dependents = document.getElementById('wdesk:no_of_dependents_new').value;
			//var cntry_res =  document.getElementById('country_of_res_new').value; 
			var nationality = document.getElementById('nation_new').value;
			var uae = document.getElementById('wdesk:wheninuae_new').value;
			var period_prev = document.getElementById('wdesk:period_organ_new').value;
			var prev_organ = document.getElementById('wdesk:prev_organ_new').value;
			var winame = document.getElementById('wdesk:WI_NAME').value;
			var exis_prefemail = document.getElementById('wdesk:pref_email_exis').value;
			var new_prefemail = document.getElementById('pref_email_new').value;
			var cifno = document.getElementById('wdesk:SelectedCIF').value;
			
			// Start - EMREG and Marsoom Details are added in form as part of JIRA SCRCIF-135 added on 04/06/2017
			//var EMREG_exis = document.getElementById('wdesk:EMREG_exis').value;
			//var EMREG_new = document.getElementById('wdesk:EMREG_new').value;
			//var EMREGExpirydate_exis = document.getElementById('wdesk:EMREGExpirydate_exis').value;
			//var EMREGExpirydate_new = document.getElementById('wdesk:EMREGExpirydate_new').value;
			var Marsoon_exis = document.getElementById('wdesk:Marsoon_exis').value;
			var Marsoon_new = document.getElementById('wdesk:Marsoon_new').value;
			//var marsoonExpDate_exis = document.getElementById('wdesk:marsoonExpDate_exis').value;
			//var marsoonExpDate_new = document.getElementById('wdesk:marsoonExpDate_new').value;
			// End - EMREG and Marsoom Details are added in form as part of JIRA SCRCIF-135 added on 04/06/2017

			var today = new Date();
			var dd = today.getDate();
			var mm = today.getMonth() + 1; //January is 0!

			var yyyy = today.getFullYear();
			if (dd < 10) {
				dd = '0' + dd
			}
			if (mm < 10) {
				mm = '0' + mm
			}
			var date = dd + '/' + mm + '/' + yyyy;
			
			try {
				if (title == "--Select--") title = "";
				if (Aecb == "--Select--") Aecb = "";					
				if (occupation=="--Select--") occupation="";
				if (resi_country == "--Select--" || resi_country == "Country") resi_country = "";
				if (offc_type == "Residence Type" || offc_type == "--Select--") offc_type = "";
				if (offc_country == "Country" || offc_country == "--Select--") offc_country = "";
				if (e_state == "--Select--")  e_state = "";
				if (pref_contact == "--Select--")  pref_contact = "";
				if (emp_type == "--Select--") emp_type = "";
				if (emp_status == "--Select--") emp_status = "";
				if (marrital == "--Select--") marrital = "";
				if (nationality == "--Select--") nationality = "";
				if (pref_add == "--Select--") pref_add = "";
				if (new_prefemail == "--Select--") new_prefemail = "";
				if (resi_type == "--Select--") resi_type = "";

				sparam = 'First_Name=' + Full_Name + '&Emirates_Id=' + Emirates_Id + '&Passport_Num=' + passportNum + '&wi_name=' + winame +

					'&Pref_Contact=' + pref_contact + '&title=' + title + '&middle_name=' + MiddleName + '&last_name=' + LastName + '&full_name=' + FullName +'&resi_flat_no=' + resi1 + '&resi_building=' + resi2 + '&resi_street=' + resi3 + '&resi_type=' + resi_type +
					'&landmark=' + resi4 + '&resi_zip_code=' + resi_zip + '&resi_po_box=' + resi_po + '&resi_city=' + resi_city + '&resi_state=' + resi_state + '&resi_country=' + resi_country + '&offc_flat_no=' + offc1 + '&offc_building_name=' + offc2 + '&offc_street=' + offc3 + '&offc_resi_type=' + offc_type + '&offc_landmark=' + offc4 +'&offc_zip_code=' + offc_zip + '&offc_po_box=' + offc_po + '&offc_city=' + offc_city + '&offc_state=' + offc_state + '&offc_country=' + offc_country +
					'&MP1=' + mob1 + '&MP12=' + mob2 + '&MP13=' + mob3 + '&MP2=' + mob21 + '&MP22=' + mob22 + '&MP23=' + mob23 + '&HP1=' + homephone1 +	'&HP2=' + homephone2 + '&HP3=' + homephone3 + '&offc_phn1=' + offc_phn1 + '&offc_phn2=' + offc_phn2 + '&offc_phn3=' + offc_phn3 +'&fax1=' + fax1 + '&fax2=' + fax2 + '&fax3=' + fax3 + '&home_cntry_phn1=' + home_cntry_phn1 + '&home_cntry_phn2=' + home_cntry_phn2 +'&home_cntry_phn3=' + home_cntry_phn3 + '&occupation=' + occupation + '&prev_organ=' + prev_organ + '&period_previous_organization=' + period_prev + '&nationality=' + nationality + '&Emirates_Id_Expiry=' + EmiratesidExp + '&Passport_Exp_Date=' + PassExpdate + '&Visa=' + Visa + '&Visa_Exp_Date=' + VisaExpDate + '&exis_marsoom=' + Marsoon_exis + '&marsoom=' + Marsoon_new +
					'&Mother_maid=' + Mother + '&AECB=' + Aecb + '&Pref_Add=' + pref_add + '&Prim_Email=' + prim_id + '&Sec_Email=' + sec_id +
					'&E-Statement=' + e_state + '&Emp_Type=' + emp_type + '&Designation=' + designation + '&Comp_Name=' + comp_name + '&Name_of_Emp=' + emp_new_name +
					'&Department=' + department + '&Emp_Num=' + emp_num + '&Nature_of_Busi=' + nature_of_busi + '&Total_Yrs_Emp=' + years_of_emp +
					'&Yrs_In_Busi=' + years_of_business + '&Emp_Status=' + emp_status + '&Date_Of_Join=' + date_joining + '&Marital_Satus=' + marrital +
					'&No_Dependents=' + dependents + '&Since_UAE=' + uae + '&Date1=' + date + '&option=' + option + '&exis_title=' + title_exis +
					'&exis_firstname=' + firstname_exis + '&exis_middlename=' + middlename_exis + '&exis_lastname=' + lastname_exis + '&exis_fullname=' + fullname_exis +
					'&exis_emiratesid=' + emiratesid_exis + '&exis_emiratesexp=' + emiratesex_exis + '&exis_passportnum=' + passportnum_exis +
					'&exis_passportexpiry=' + passportexp_exis + '&exis_visa=' + visa_exis + '&exis_visaexpiry=' + visaexp_exis + '&exis_mother=' + mother_exis +
					'&exis_aecb=' + abcde_exis + '&exis_residenceaddress=' + resiadd_exis + '&exis_offcaddress=' + officeadd_exis + '&exis_prefadd=' + prefadd_exis + '&exis_primid=' + primid_exis + '&exis_secid=' + secid_exis +
					'&exis_estatement=' + estate_exis + '&exis_mobile1=' + mobile1_exis + '&exis_mobile2=' + mobile2_exis + '&exis_homephn=' + hmephn_exis + '&exis_offcphn=' + offcphn_exis + '&exis_fax=' + fax_exis + '&exis_homecntryphn=' + hmecntryphn_exis +
					'&exis_prefcontact=' + prefcontact_exis + '&exis_emptype=' + emptype_exis + '&exis_designation=' + designation_exis + '&exis_compname=' + compname_exis + '&exis_nameofemp=' + empname_exis + '&exis_department=' + department_exis + '&exis_empnum=' + empnum_exis + '&exis_occupation=' + occupation_exis + '&exis_naturebusi=' + nameofbusi_exis + '&exis_totalyrsemp=' + totalyrsemp_exis + '&exis_yrsinbusi=' + yrsbusi_exis + '&exis_empstatus=' + empstatus_exis + '&exis_datejoin=' + datejoining_exis + '&exis_previousorgan=' + prevorgan_exis + '&exis_periodorgan=' + periodorgan_exis +
					'&exis_maritalstatus=' + marital_exis + '&exis_dependents=' + dependents_exis + '&exis_nationality=' + nationality_exis + '&exis_inuae=' + wheninuae_exis + '&exis_prefemail=' + exis_prefemail + '&pref_emailid=' + new_prefemail+ '&CifNo=' + cifno +'&prefOfLang_exis=' + langOfPref_exis+ '&peopleOfDetrm_exis=' + peopleOfDet_exis+ '&podOptions_exis=' + podOptions_exis+ '&podRemarks_exis=' + podRemarks_exis +'&prefOfLang=' + langOfPref_new+ '&peopleOfDetrm=' + peopleOfDet_new+ '&podOptions=' + podOptions_new+ '&podRemarks=' + podRemarks_new;
					document.getElementById('wdesk:Generated_Data').value = sparam;
					sparam = sparam.replace('%','`~`');
					
					//alert(document.getElementById('wdesk:Generated_Data').value);
					
			} catch (err) {
				alert("Exception err.message "+err.message);
			}

			url = 'createPDF.jsp?option=' + option;
			
			var retval = "-1";
				var req = getACTObj();
				if (req == null) return;

				req.onreadystatechange = processRequest;
				req.open("POST", url, false);
				req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				req.send(sparam);

				function processRequest() {
					if (req.readyState == 4) {
						if (req.status == 200)
							parseMessages();
						else
							retval = '-1';
					}
				}

				function parseMessages() {
					retval = trim_CU(req.responseText);

					pdfName = retval;

				}

				if (retval != '-1') {
					var PDFurl = "../../PDFTemplates/generated/" + trim_CU(pdfName);
					//var PDFurl="/CAC/PDFTemplates/generated/"+trim_CU(pdfName);		
					window.open(PDFurl);
					pausecomp(2000);
					// start - function called to delete template from server after generating
					window.onunload(deleteTemplateFromServer(trim_CU(pdfName)));
					// end - function called to delete template from server after generating
				}

		} else if (option == 'Conversion from joint to sole account') {
			//					
		} else if (option == 'Conversion from sole to joint account') {
			//
		} else if (option == 'FATCA_Individual') {
			//
			
			var winame = document.getElementById('wdesk:WI_NAME').value;
			var fullname_exis = document.getElementById('wdesk:FullName_Existing').value;
			var cifno = document.getElementById('wdesk:SelectedCIF').value;
			var title_exis = document.getElementById('wdesk:title_exis').value;
			var firstname_exis = document.getElementById('wdesk:FirstName_Existing').value;
			var middlename_exis = document.getElementById('wdesk:MiddleName_Existing').value;
			var lastname_exis = document.getElementById('wdesk:LastName_Existing').value;
		//	var fullname_exis = document.getElementById('wdesk:FullName_Existing').value;
			var resi1 = document.getElementById('wdesk:resi_line1').value;
			var resi2 = document.getElementById('wdesk:resi_line2').value;
			var resi3 = document.getElementById('wdesk:resi_line3').value;
			var resi4 = document.getElementById('wdesk:resi_line4').value;
			var resi_po = document.getElementById('wdesk:resi_pobox').value;
			var resi_city = document.getElementById('wdesk:resi_city').value;
			var resi_state = document.getElementById('wdesk:resi_state').value;
			var offc1 = document.getElementById('wdesk:office_line1').value;
			var offc2 = document.getElementById('wdesk:office_line2').value;
			var offc3 = document.getElementById('wdesk:office_line3').value;
			var offc4 = document.getElementById('wdesk:office_line4').value;
			var offc_po = document.getElementById('wdesk:office_pobox').value;
			var offc_city = document.getElementById('wdesk:office_city').value;
			var offc_state = document.getElementById('wdesk:office_state').value;
			var DOB_exis = document.getElementById('wdesk:DOB_exis').value;
			
			var address_res_OLD=document.getElementById('resaddress1existing').value;;
			var city_res_OLD=document.getElementById('wdesk:resi_cityexis').value;;
			var country_res_OLD=document.getElementById('wdesk:resi_countryexis').value;;
			var Zip_res_OLD=document.getElementById('resi_pobox1').value;;
			var address_off_OLD=document.getElementById('offaddress1existing').value;;
			var city_off_OLD=document.getElementById('offcCity1').value;;
			var country_off_OLD=document.getElementById('offcCountry1').value;;
			var Zip_off_OLD=document.getElementById('offc_pobox1').value;;
			
			var complete_resi_address_new= resi1+""+resi2+""+resi3+""+resi4+""+resi_po;
			var city_state_new=resi_city+""+resi_state;
			var resi_country_new =   document.getElementById('resi_cntrycode').options[document.getElementById('resi_cntrycode').selectedIndex].text;
			var resi_zip_new = document.getElementById('wdesk:resi_zipcode').value;
			var complete_offc_address_new= offc1+""+offc2+""+offc3+""+offc4+""+offc_po;
			var offc_city_state_new=offc_city+""+offc_state;
			var offc_zip_new = document.getElementById('wdesk:office_zipcode').value;
			var offc_country_new = document.getElementById('office_cntrycode').options[document.getElementById('office_cntrycode').selectedIndex].text;
			
			if (resi_country_new == "--Select--") resi_country_new = "";
			if (offc_country_new == "--Select--") offc_country_new = "";
			
			
			var oldaddressvalues=[address_res_OLD,city_res_OLD,country_res_OLD,Zip_res_OLD,address_off_OLD,city_off_OLD,country_off_OLD,Zip_off_OLD];
			var Newaddressvalues=[complete_resi_address_new,city_state_new,resi_country_new,resi_zip_new,complete_offc_address_new,offc_city_state_new,offc_country_new,offc_zip_new];
			
			var updatedaddfields="";
			for(var i=0;i<Newaddressvalues.length;i++)
			{
			
			if(Newaddressvalues[i] == "")
				{
					if(updatedaddfields=="" && i==0)
						updatedaddfields=oldaddressvalues[i];
						
					else
						updatedaddfields=updatedaddfields+"~"+oldaddressvalues[i];
				}
								
				else
				{
					if(updatedaddfields=="" && i==0)
						updatedaddfields=Newaddressvalues[i];
						
					else
						updatedaddfields=updatedaddfields+"~"+Newaddressvalues[i];
				}  
			
			}
			
			var Splittedfieldsaddress = updatedaddfields.split("~");
			var Residenceaddress = Splittedfieldsaddress[0];
			var ResidenceCity = Splittedfieldsaddress[1];
			var ResidenceCountry= Splittedfieldsaddress[2];
			var ResidenceZIp= Splittedfieldsaddress[3];
			var Officeaddress = Splittedfieldsaddress[4];
			var OfficeCity = Splittedfieldsaddress[5];
			var OfficeCountry = Splittedfieldsaddress[6];
			var OfficeZIp = Splittedfieldsaddress[7];
			
			
			var oldFieldvalues=['wdesk:Oecdcity','wdesk:Oecdcountry','wdesk:Oecdcountrytax','wdesk:OecdTin','wdesk:Oecdcountrytax2','wdesk:OecdTin2','wdesk:Oecdcountrytax3','wdesk:OecdTin3','wdesk:OECDtinreason_exist3','wdesk:OECDtinreason_exist2','wdesk:OECDtinreason_exist','wdesk:USrelation'];
			var Newfieldvalues=['wdesk:Oecdcity_new','wdesk:Oecdcountry_new','wdesk:Oecdcountrytax_new','wdesk:OecdTin_new','wdesk:Oecdcountrytax_new2','wdesk:OecdTin_new2','wdesk:Oecdcountrytax_new3','wdesk:OecdTin_new3','OECDtinreason_new3','OECDtinreason_new2','OECDtinreason_new','USrelation_new'];
			var updatedfields="";
			for(var i=0;i<Newfieldvalues.length;i++)
			{
				if(document.getElementById(Newfieldvalues[i]).value == "")
				{
					if(updatedfields=="" && i==0)
						updatedfields=document.getElementById(oldFieldvalues[i]).value;
						
					else
						updatedfields=updatedfields+"~"+document.getElementById(oldFieldvalues[i]).value;
				}
								
				else
				{
					if(updatedfields=="" && i==0)
						updatedfields=document.getElementById(Newfieldvalues[i]).value;
						
					else
						updatedfields=updatedfields+"~"+document.getElementById(Newfieldvalues[i]).value;
				}                                              
							
			}
			var Splittedfields = updatedfields.split("~");
			var Oecdcityfinal = Splittedfields[0];
			var Oecdcountryfinal = Splittedfields[1];
			var Oecdcountrytaxfinal= Splittedfields[2];
			var oecdtinfinal= Splittedfields[3];
			var oecdcountrytax2final = Splittedfields[4];
			var oecdtin2final = Splittedfields[5];
			var oecdcountrytax3final = Splittedfields[6];
			var oecdtin3final = Splittedfields[7];
			var oecdNOTINreason3= Splittedfields[8];
			var oecdNOTINreason2= Splittedfields[9];
			var oecdNOTINreason1= Splittedfields[10];
			var USRelationFinal= Splittedfields[11];
			
			
			if (title_exis == 'MR.')
				title_exis = '&custtitle_MR=Yes';
			else if (title_exis == 'MRS.')
				title_exis = '&custtitle_MRS=Yes';
			else if (title_exis == 'MS.')
				title_exis = '&custtitle_MS=Yes';

			if (USRelationFinal == 'N')
				USRelationFinal = '&usrelation_NNo=Yes';
			else if (USRelationFinal == 'R')
				USRelationFinal = '&usrelation_NNo=Yes';
			else if (USRelationFinal == 'O')
				USRelationFinal = '&usrelation_No=Yes';
				
			if (oecdNOTINreason3 == 'A-NOT ISSUED')
					{
					oecdNOTINreason3='REASON A TIN NOT ISSUED BY RESIDENT COUNTRY';
					var oecdNOTINreason3CHECK = '&notinreasonA3=Yes';
					}
				else if (oecdNOTINreason3 == 'B-UNABLE GET TIN')
					{
					oecdNOTINreason3='REASON B UNABLE TO GET TIN';
					var oecdNOTINreason3CHECK = '&notinreasonB3=Yes';
					}
				else if (oecdNOTINreason3 == 'C-NO TIN REQD')
					{
					oecdNOTINreason3='REASON C NO TIN REQUIRED';
					var oecdNOTINreason3CHECK  = '&notinreasonC3=Yes';	
					}
				else
					{
						var oecdNOTINreason3CHECK="";
					}
				
			if (oecdNOTINreason2 == 'A-NOT ISSUED')
					{
					oecdNOTINreason2='REASON A TIN NOT ISSUED BY RESIDENT COUNTRY';
					var oecdNOTINreason2CHECK = '&notinreasonA2=Yes';
					}
				else if (oecdNOTINreason2 == 'B-UNABLE GET TIN')
					{
					oecdNOTINreason2='REASON B UNABLE TO GET TIN';
					var oecdNOTINreason2CHECK = '&notinreasonB2=Yes';
					}
				else if (oecdNOTINreason2 == 'C-NO TIN REQD')
					{
					oecdNOTINreason2='REASON C NO TIN REQUIRED';
					var oecdNOTINreason2CHECK  = '&notinreasonC2=Yes';	
					}
				else
					{
						var oecdNOTINreason2CHECK="";
					}	
				
			if (oecdNOTINreason1 == 'A-NOT ISSUED')
					{
					oecdNOTINreason1='REASON A TIN NOT ISSUED BY RESIDENT COUNTRY';
					var oecdNOTINreason1CHECK = '&notinreasonA1=Yes';
					}
				else if (oecdNOTINreason1 == 'B-UNABLE GET TIN')
					{
					oecdNOTINreason1='REASON B UNABLE TO GET TIN';
					var oecdNOTINreason1CHECK = '&notinreasonB1=Yes';
					}
				else if (oecdNOTINreason1 == 'C-NO TIN REQD')
					{
					oecdNOTINreason1='REASON C NO TIN REQUIRED';
					var oecdNOTINreason1CHECK  = '&notinreasonC1=Yes';	
					}
				else
					{
						var oecdNOTINreason1CHECK="";
					}		
				
			
			var today = new Date();
			var dd = today.getDate();
			var mm = today.getMonth() + 1; //January is 0!

			var yyyy = today.getFullYear();
			if (dd < 10) {
				dd = '0' + dd
			}
			if (mm < 10) {
				mm = '0' + mm
			}
			var date = dd + '/' + mm + '/' + yyyy;
			document.getElementById('wdesk:SignedDate_new').value = date;
			expiryDateset();
			try {
			
				if (USRelationFinal == "--Select--" || USRelationFinal == "undefined") USRelationFinal = "";
				if (oecdNOTINreason1 == "--Select--" || oecdNOTINreason1 == "undefined") oecdNOTINreason1 = "";
				if (oecdNOTINreason2 == "--Select--" || oecdNOTINreason2 == "undefined") oecdNOTINreason2 = "";
				if (oecdNOTINreason3 == "--Select--" || oecdNOTINreason3 == "undefined") oecdNOTINreason3 = "";
				
			
				//sparam = 'Date1=' + date + '&option=' + option + '&exis_fullname=' + fullname_exis+ '&CifNo=' + cifno;
				
				sparam = 'WINAME=' + winame + '&custlastname=' + lastname_exis + '&custfirstname=' + firstname_exis + '&custmiddlename=' + middlename_exis +'&resi_address=' + Residenceaddress + '&resi_town=' + ResidenceCity + '&resi_country=' + ResidenceCountry + '&resi_zip=' + ResidenceZIp + '&off_address=' + Officeaddress +'&off_town=' + OfficeCity + '&off_country=' + OfficeCountry + '&off_zip=' + OfficeZIp + '&custdob=' + DOB_exis +'&tax_cityofbirth=' + Oecdcityfinal + '&tax_countryofbirth=' + Oecdcountryfinal + '&countryoftaxresidence1=' +Oecdcountrytaxfinal + '&taxpayeridentificationno1=' + oecdtinfinal + '&countryoftaxresidence2=' + oecdcountrytax2final + '&taxpayeridentificationno2=' + oecdtin2final + '&countryoftaxresidence3=' + oecdcountrytax3final + '&taxpayeridentificationno3=' + oecdtin3final + '&notinreasonremark3=' + oecdNOTINreason3 + '&notinreasonremark2=' + oecdNOTINreason2 + '&notinreasonremark1=' + oecdNOTINreason1 + '&Date=' + date + '&P_FullName=' + fullname_exis + USRelationFinal + oecdNOTINreason3CHECK + oecdNOTINreason2CHECK + oecdNOTINreason1CHECK + title_exis +'&CifNo=' + cifno;
				//	document.getElementById('wdesk:Generated_Data').value = sparam;
				//	sparam = sparam.replace('%','`~`');
					//+'&offc_zip_code=' + USRelationFinal 
					//alert(document.getElementById('wdesk:Generated_Data').value);
				
			} catch (err) {
				alert("Inside exception err.message " + err.message);
			}

			url = 'createPDF.jsp?option=' + option;
			
			var retval = "-1";
				var req = getACTObj();
				if (req == null) return;

				req.onreadystatechange = processRequest;
				req.open("POST", url, false);
				req.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				req.send(sparam);

				function processRequest() {
					if (req.readyState == 4) {
						if (req.status == 200)
							parseMessages();
						else
							retval = '-1';
					}
				}

				function parseMessages() {
					retval = trim_CU(req.responseText);

					pdfName = retval;

				}

				if (retval != '-1') {
					var PDFurl = "../../PDFTemplates/generated/" + trim_CU(pdfName);
					//var PDFurl="/CAC/PDFTemplates/generated/"+trim_CU(pdfName);		
					window.open(PDFurl);
					pausecomp(2000);
					// start - function called to delete template from server after generating
					window.onunload(deleteTemplateFromServer(trim_CU(pdfName))); 
					// end - function called to delete template from server after generating
				}
		}

		return url;
	}
	
	
		function trim_CU(str) {
			if (undefined == str)
				return "";
			return str.replace(/^\s+|\s+$/g, '');
		}
		
	function deleteTemplateFromServer (pdfname)
		{
			var url = '/CU/CustomForms/CU_Specific/DeleteGeneratedTemplate.jsp?pdfname='+pdfname;
			var xhr;
			var ajaxResult;	
			
			if(window.XMLHttpRequest)
				 xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
				 xhr=new ActiveXObject("Microsoft.XMLHTTP");

			 xhr.open("GET",url,false); 
			 xhr.send(null);

			// alert(xhr.status);
			 
			if (xhr.status == 200) { //Do nothing
			}
			else
			{
				alert("Error while deleting generated template from server");
				return false;
			}
		}	
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to generate pdf

//***********************************************************************************//
	function generatePDF(option) {

		var url = getURL(option);
		if (url == 'undefined' || url == '') {
			return;
		}
		/*var resultJSON = trim(doPostAjax(url, sparam));
		OpenPdf();
		Global = true;*/
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to Open pdf

//***********************************************************************************//
	function OpenPdf() {
		var url = "/CU/PDFTemplates/generated/" + pdfName;
		window.open(url);
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           this function is used for loading the doctypes for saved fields	

//***********************************************************************************//	
	
	function loadSavedDocTypes(workstepName) {
		var updatedSavedCIF = document.getElementById("wdesk:Updated_CIFNumber").value;
		if (updatedSavedCIF != '') {
		if(workstepName != "Archival_Activity" || workstepName != "Archival_Rejects" || workstepName != "Exit" || workstepName != "Reject" )  //Added by Shamily Dec CR to not call Entity_details at Archival WS
		{
			getEntityDetails();
		}	
			$(function() {
				$(":radio[value=" + updatedSavedCIF + "]").click();
			});
		}
		if (workstepName != 'PBO') {
			ajaxRequest(workstepName, 'office_cntrycode');
			ajaxRequest(workstepName, 'FatcaDocNew');
			ajaxRequest(workstepName, 'FatcaReasonNew');
			ajaxRequest(workstepName, 'TypeOfRelationNew');
			ajaxRequest(workstepName, 'CustomerType_new');
			ajaxRequest(workstepName, 'IndustrySegment_new');
			ajaxRequest(workstepName, 'IndustrySubSegment_new');
			ajaxRequest(workstepName, 'USrelation_new');
			ajaxRequest(workstepName, 'resi_restype');
			ajaxRequest(workstepName, 'emp_type_new');
			ajaxRequest(workstepName, 'employment_status_new');
			ajaxRequest(workstepName, 'marrital_status_new');
			ajaxRequest(workstepName, 'occupation_new');
			//Added by Shamily to fetch tin reason and undoc reason from master table 
			ajaxRequest(workstepName, 'OECDUndocreason_new');
			ajaxRequest(workstepName, 'OECDtinreason_new');
			ajaxRequest(workstepName, 'OECDtinreason_new2');
			ajaxRequest(workstepName, 'OECDtinreason_new3');
			ajaxRequest(workstepName, 'OECDtinreason_new4');
			ajaxRequest(workstepName, 'OECDtinreason_new5');
			ajaxRequest(workstepName, 'OECDtinreason_new6');
			var TypeOfRelation_exis = document.getElementById("wdesk:TypeOfRelation_exis").value;
			if (TypeOfRelation_exis.indexOf("!") != -1) {
				TypeOfRelation_exis = TypeOfRelation_exis.replace(/!/gi, "\n").replace(/^,/, "");;
				document.getElementById("wdesk:TypeOfRelation_exis").value = TypeOfRelation_exis;
			}
			var FatcaDoc = document.getElementById("wdesk:FatcaDoc").value;
			if (FatcaDoc.indexOf("!") != -1) {
				FatcaDoc = FatcaDoc.replace(/!/gi, "\n").replace(/^,/, "");;
				document.getElementById("wdesk:FatcaDoc").value = FatcaDoc;
			}
			<!--Added By Nikita to add fatca Reason-->
			var FatcaReason = document.getElementById("wdesk:FatcaReason").value;
			if (FatcaReason.indexOf("!") != -1) {
			FatcaReason = FatcaReason.replace(/!/gi, "\n").replace(/^,/, "");;
			document.getElementById("wdesk:FatcaReason").value = FatcaReason;
		}
		}
	}

//added by Shamily to optimize all dates 

function optimizedate(reqtype)
	{
		
		var Date1 = "";
		if(reqtype == 'Passportdate')
		{
			Date1 = document.getElementById("wdesk:passportExpDate_new").value;				
		}
		else if(reqtype == 'EmiratesDate')	
		{
			Date1 = document.getElementById("wdesk:emiratesidexp_new").value;
		}else if(reqtype == 'VisaDate')	
		{
			Date1 = document.getElementById("wdesk:visaExpDate_new").value;
		}else if(reqtype == 'UAEdate')	
		{
			Date1 = document.getElementById("wdesk:wheninuae_new").value;
		}else if(reqtype == 'SignedDate')	
		{
			Date1 = document.getElementById("wdesk:SignedDate_new").value;
		}else if(reqtype == 'ExpiryDate')	
		{
			Date1 = document.getElementById("wdesk:ExpiryDate_new").value;
		}
		else if(reqtype == 'Dateofjoining')
        {
			Date1 = document.getElementById("wdesk:date_join_curr_employer_new").value;
        }
		if(Date1.indexOf('/') != -1)
		{
			return true;
		}
		else if(Date1 !="")
		{
			if(Date1.substring(0,2) > 31 || Date1.substring(2,4) >12 || Date1.substring(4,8).length != 4)
			{
				alert("Please enter valid date");
				Date1 = "";
			}
			else
			{
				Date1  = Date1.substring(0,2) +"/"+Date1.substring(2,4) +"/"+ Date1.substring(4,8);
			}	
		}
		
		
		 if(reqtype == 'ExpiryDate')	
		{
			document.getElementById("wdesk:ExpiryDate_new").value =Date1;
		}
		else if(reqtype == 'UAEdate' || reqtype == 'SignedDate'|| reqtype == 'EmiratesDate'|| reqtype == 'VisaDate'|| reqtype == 'Passportdate' || reqtype == 'MarsoonExpirydate'|| reqtype == 'EMREGIssueDate'|| reqtype == 'EMREGExpiryDate'|| reqtype == 'Dateofjoining')	
		{
		
			var currentTime = new Date();
			var dd = currentTime.getDate();
			var mm = currentTime.getMonth() + 1; //January is 0!
			
			var yyyy = currentTime.getFullYear();
			
			var arrStartDate = Date1.split("/");
			
			var date2 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
			var timeDiffPassport = date2.getTime() - currentTime.getTime();
			if(reqtype == 'UAEdate')
			{
				if(timeDiffPassport > 0)
				{
					alert("Since when in UAE can't be a future date");
					document.getElementById("wdesk:wheninuae_new").value = "";
				}
				else
				{
					document.getElementById("wdesk:wheninuae_new").value = Date1;
				}
			}
			else if (reqtype == 'SignedDate')
			{
				if(timeDiffPassport > 0)
				{
					alert("Signed Date can't be a  future date");
					document.getElementById("wdesk:SignedDate_new").value = "";
				}
				else
				{
					document.getElementById("wdesk:SignedDate_new").value = Date1;
				}
			}	
			else if (reqtype == 'EmiratesDate')
			{
				 timeDiffPassport =  currentTime.getTime() - date2.getTime();
				if(timeDiffPassport > 0)
				{
					alert("Emrirates expiry date should be future date");
					document.getElementById("wdesk:emiratesidexp_new").value = "";
				}
				else
				{
					document.getElementById("wdesk:emiratesidexp_new").value = Date1;
				}
			}else if (reqtype == 'VisaDate')
			{
				 timeDiffPassport =  currentTime.getTime() - date2.getTime();
				if(timeDiffPassport > 0)
				{
					alert("Visa expiry date should be future date");
					document.getElementById("wdesk:visaExpDate_new").value = "";
				}
				else
				{
					document.getElementById("wdesk:visaExpDate_new").value = Date1;
				}
			}else if (reqtype == 'Passportdate')
			{
				 timeDiffPassport =  currentTime.getTime() - date2.getTime();
				if(timeDiffPassport > 0)
				{
					alert("Passport expiry date should be future date");
					document.getElementById("wdesk:passportExpDate_new").value = "";
				}
				else
				{
					document.getElementById("wdesk:passportExpDate_new").value = Date1;
				}
			}
			else if (reqtype == 'Dateofjoining')
            {
                if(timeDiffPassport > 0)
                {
					alert("Date of joining Current Employer can't be future date");
                    document.getElementById("wdesk:date_join_curr_employer_new").value = "";
                }
                else
                {
                    document.getElementById("wdesk:date_join_curr_employer_new").value = Date1;
                }
            }
		}
		
	}




//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           this function is used to show documents required for updated field

//***********************************************************************************//
	function docReq(object, field_name, doc_field) {
		if (object.value == "" || object.value == "--Select--") {
			document.getElementById(doc_field).value = "";
		} else {
			field_name = field_name.replace("'", "''");
			var url = '/CU/CustomForms/CU_Specific/requiredDoc.jsp?field_name=' + field_name + "&doc_field=" + doc_field;
			var xhr;
			var ajaxResult;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			xhr.open("GET", url, false);
			xhr.send(null);

			if (xhr.status == 200)
				document.getElementById(doc_field).value = xhr.responseText;
			else {
				alert("Error while fetching required doctypes");
				return false;
			}
		}
		var availdoc = document.getElementById(doc_field).value;
		var reqdoc = document.getElementById("wdesk:Requireddoc").value;
		var reqtemp = "";
		if (availdoc != "") {
			var el = document.getElementById("requiredDoc1");
			while ( el.firstChild ) {
				el.removeChild( el.firstChild )
			}
			
			if(availdoc.indexOf(",") == -1)
			{
				availdoc = availdoc + ',';
			}	
			availdoc = availdoc.split(",");
			for (var i = 0; i < availdoc.length; i++) 	
			{	
				var count1 = occurrences(reqdoc,availdoc[i]);
				if(count1>0 && availdoc[i] != ",")
				{
					availdoc[i] = "";
				}	
				//if(availdoc[i] != "")
				if(reqtemp != "" && availdoc[i] != "" && availdoc[i] != ",")
				document.getElementById("wdesk:Requireddoc").value = reqtemp +availdoc[i]  +',';
				else if(reqdoc == "" && availdoc[i] != "" && availdoc[i] != ",")
				document.getElementById("wdesk:Requireddoc").value = document.getElementById("wdesk:Requireddoc").value +availdoc[i]  +',';
				else if(reqdoc != "" && availdoc[i] != "" && availdoc[i] != ",")
				document.getElementById("wdesk:Requireddoc").value = reqdoc+availdoc[i]  +',';
				
				reqtemp = document.getElementById("wdesk:Requireddoc").value
				
			}
			var reqdoc1 = document.getElementById("wdesk:Requireddoc").value;			
			// document.getElementById("wdesk:Requireddoc").value = "";
			}
				
		
		/*if (availdoc != "") {
			if (reqdoc.substr(reqdoc.length - 1) == ",") {
				reqdoc = reqdoc.replace(reqdoc.substr(reqdoc.length - 1), "")
			}
			if (availdoc.indexOf(reqdoc) != -1) {
		
				availdoc = availdoc.replace(reqdoc, "");
		
				if (availdoc != "" && availdoc != ",") {
					document.getElementById("wdesk:Requireddoc").value = document.getElementById("wdesk:Requireddoc").value + availdoc + ',';
				*/	
					if (document.getElementById("wdesk:Requireddoc").value != '') {
						var reqList = document.getElementById("wdesk:Requireddoc").value.split(",");
						var select = document.getElementById("requiredDoc1");
						for (var i = 0; i < reqList.length; i++) {

							if (reqList[i] != "undefined") {
								var option = document.createElement("option");
								option.text = reqList[i];
								option.value = reqList[i]; //Not required for Internet Explorer - why??
								select.add(option);
								listWidthAuto = true;
							}			
						}
					}			
					
				//}
				if (document.getElementById("requiredDoc1").value == "") {
					document.getElementById("requiredDoc1").style.Width = "75%"
				} else {
					document.getElementById("requiredDoc1").style.Width = "auto";
				}
			//}
		//}
	}

	
	
function occurrences(string, subString, allowOverlapping) {
    string += "";
    subString += "";
    if (subString.length <= 0) return (string.length + 1);
    var n = 0,
        pos = 0,
        step = allowOverlapping ? 1 : subString.length;
    while (true) {
        pos = string.indexOf(subString, pos);
        if (pos >= 0) {
            ++n;
            pos += step;
        } else break;
    }
    return n;
}	
	
	var gridDataTracker = {
		'KYC Update': []
	}

	function trackGridFields(GridName, displayName) {
		var fieldlist = gridDataTracker[GridName];
		var requestTypes = document.getElementById("wdesk:Request_Type_Master").value;
		
		while (fieldlist.length > 0) {
			fieldlist.pop();
		}
		if ($.inArray(displayName, fieldlist) == -1) {
			fieldlist.push(displayName);
			if (document.getElementById("wdesk:Request_Type_Master").value != null || document.getElementById("wdesk:Request_Type_Master").value != "" || document.getElementById("wdesk:Request_Type_Master").value != " ") {
				var str = document.getElementById("wdesk:Request_Type_Master").value;
	
				if (str.indexOf("KYC Update") != -1) {
					//
				} else {
					document.getElementById("wdesk:Request_Type_Master").value = document.getElementById("wdesk:Request_Type_Master").value + "-" + GridName;

				}
			} else
				document.getElementById("wdesk:Request_Type_Master").value = GridName;
			
		}			
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to add CIF Data Update before the name of the fields that are updated	and kept in a table.

//***********************************************************************************//	
	var gridData = {
		'CIF Data Update': []
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to keep the record of fields that are updated

//***********************************************************************************//
	function CIFtrackGridFields(Grid, display) {
		var fieldlist1 = gridData[Grid];
		var requestTypes = document.getElementById("wdesk:CIFReq_Type").value;
	
		if ($.inArray(display, fieldlist1) == -1) {
			fieldlist1.push(display);
			document.getElementById("wdesk:CIFReq_Type").value = requestTypes + Grid + '-' + display + '|';
		}		
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to open decision history and reject reasons windowS

//***********************************************************************************//
	//added by stutee.mishra
	var dialogToOpenType = null;
	var popupWindow = null;
	function setValue(val1) 
	{
	   //you can use the value here which has been returned by your child window
	   popupWindow = val1;
	   if(dialogToOpenType == 'Reject Reasons'){
		   if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
				document.getElementById('rejReasonCodes').value = popupWindow;
	   }
	}
	//ends here.
	
	function openCustomDialog(dialogToOpen, workstepName) {
		if (workstepName != null && workstepName != '') {
			//var popupWindow = null;
			dialogToOpenType = dialogToOpen;
			var sOptions;
			var wi_name = '<%=WINAME%>';

			if (dialogToOpen == 'Save History') {
				var isSysUpdateSuccess = document.getElementById("wdesk:isSysUpdateSuccess").value;
				//window.showModalDialog("/CU/CustomForms/CU_Specific/history.jsp?WINAME="+wi_name+'&isSysUpdateSuccess='+isSysUpdateSuccess,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
				
				//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						window.showModalDialog("/CU/CustomForms/CU_Specific/history.jsp?WINAME="+wi_name,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
					} else {
						window.open("/CU/CustomForms/CU_Specific/history.jsp?WINAME="+wi_name,"",windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
					
			} else if (dialogToOpen == 'Reject Reasons') {

				var WSNAME = '<%=WSNAME%>';
				var rejectReasons = document.getElementById('rejReasonCodes').value;
			
				sOptions = 'dialogWidth:500px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; status:no; scroll:no; help:no; resizable:no';
				
				//popupWindow = window.showModalDialog('/CU/CustomForms/CU_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
				
				//added below to handle window.open/window.showModalDialog according to type of browser starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow=window.showModalDialog('/CU/CustomForms/CU_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
				
					} else {
						popupWindow =window.open('/CU/CustomForms/CU_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, windowParams);
				
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser  ends here.
				
				//Set the response code to the input with id = rejReasonCodes
				/*if (popupWindow!="NO_CHANGE")
					document.getElementById('rejReasonCodes').value = popupWindow;	  */
				if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
				document.getElementById('rejReasonCodes').value = popupWindow;
			}
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to get signature on clicking on view signature button

//***********************************************************************************//
	function getSignature(Object) {
		var popupWindow = null;
		var ws_name = '<%=WSNAME%>';
		/* var sOptions = 'dialogWidth:400px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;'; */
		
		var sOptions = 'left=300,top=200,width=850,height=650,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
		
		var url = "/CU/CustomForms/CU_Specific/OpenImage.jsp?acc_num_new=" + document.getElementById("wdesk:Acc_Number_received").value+"&workstepName="+ws_name;
		popupWindow = window.open(url, "_blank", sOptions);
	}
	
	//added by siva for CU CR's 12092018
	function setSignMatchValues(wsname,signMatchStatus)
	{
		if(wsname == 'OPS_Checker_Review') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		}
	}
	// Added by siva for CU CR's 12092018
	
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to put decison value in hidden decision field

//***********************************************************************************//	
	function changeVal(dropdown, WSNAME) {
		if (dropdown.id == 'decision')
			document.getElementById("wdesk:Decision").value = dropdown.value;
		else 
			document.getElementById("wdesk:"+dropdown.id).value = dropdown.value;
	}
//**********************************************************************************//

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank BPM Upgrade 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to enable POD Options field when POD is Yes

//***********************************************************************************//	
	function enablePODOptions() {
		var PODValueSelected = document.getElementById("wdesk:peopleOfDeterm").value;
		if(PODValueSelected == 'Yes'){
			document.getElementById("PODOptions").disabled = false;
			document.getElementById('addButtonPODOptions').disabled = false;
			document.getElementById('removeButtonPODOptions').disabled = false;
			document.getElementById('PODOptionsSeleceted').disabled = false;
		}else{
			document.getElementById("PODOptions").disabled = true;
			document.getElementById('addButtonPODOptions').disabled = true;
			document.getElementById('removeButtonPODOptions').disabled = true;
			document.getElementById('PODOptionsSeleceted').disabled = true;
		}
			
	}
//**********************************************************************************//

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank BPM Upgrade 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to enable POD remarks field when POD Options is Others

//***********************************************************************************//	
	function enablePODRemarks() {
		var PODOptValueSelected = document.getElementById("wdesk:PODOptions").value;
		if(PODOptValueSelected == 'OTHR')
			document.getElementById("wdesk:PODRemarks").disabled = false;
		else
			document.getElementById("wdesk:PODRemarks").disabled = true;
	}
//**********************************************************************************//

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank BPM Upgrade 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to add multiple POD options

//***********************************************************************************//	
function AddPODOptions(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PODOptions');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a POD option');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PODOptionsSeleceted');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+'POD option is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
						
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
			
			if(selectedValueId=='PODOptionsSeleceted'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PODOptionsSeleceted');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "|";

					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('wdesk:PODOptions').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
			
		}

//**********************************************************************************//

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank BPM Upgrade 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to remove multiple POD options

//***********************************************************************************//
function RemovePODOptions(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PODOptionsSeleceted');

	if(element.options.length==0)
		alert('No POD Option to Remove');
	else if(element.selectedIndex==-1 && element.options.length!=0)
		alert('Select a POD option to remove');
	else
	{
		var len=element.options.length;
		for(i=len-1;i>=0;i--)
		{
			if(element.options[i] != null && element.options[i].selected)
			{
				element.options[i]=null;
			}
		}
	}
	
	if(selectedValueId=='PODOptionsSeleceted'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PODOptionsSeleceted');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('wdesk:PODOptions').value = sDropDownValue;
	 
	}
}
//**********************************************************************************//

//**********************************************************************************//
//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           to show aestrix on conditional mandatory fields

//***********************************************************************************//
	function mandatorycheck(reqtype)
	{
		var str = "*";
		var result = str.fontcolor("red"); 
		
		//commented for not to show emirates id and expiry date mandatory
		/*if(reqtype == 'emirates' || reqtype == '' )
		{
			if(document.getElementById('wdesk:nonResident').value == "NO" )
			{
				document.getElementById('emidc').innerHTML = 'Emirates ID Number<FONT color=red>*</FONT>';
				document.getElementById('EMIDexpdt').innerHTML = 'Emirates ID Expiry Date<FONT color=red>*</FONT>';
			}
			else
			{
				document.getElementById('emidc').innerHTML = 'Emirates ID Number';
	           	document.getElementById('EMIDexpdt').innerHTML = 'Emirates ID Expiry Date';
			}
		}*/
		if(reqtype == 'visa' || reqtype == '')
		{
			if(((document.getElementById("wdesk:comp_name_new").value != "" && document.getElementById("wdesk:comp_name_new").value != null) || (document.getElementById("wdesk:emp_name_new").value != "" && document.getElementById("wdesk:emp_name_new").value != null) || (document.getElementById("occupation_new").value != "--Select--" && document.getElementById("occupation_new").value != null && document.getElementById("occupation_new").value != "") || (document.getElementById("wdesk:naturebusiness_new").value != "" && document.getElementById("wdesk:naturebusiness_new").value != null))) 
			{
				document.getElementById('Visac').innerHTML = 'Visa Number<FONT color=red>*</FONT>';
				document.getElementById('visaexp').innerHTML = 'Visa Expiry Date<FONT color=red>*</FONT>';
			}	
			else
			{
				document.getElementById('Visac').innerHTML = "Visa Number";
				document.getElementById('visaexp').innerHTML = "Visa Expiry Date";
			}
		}
		// code modified for reqtype  == 'address' to set mandatory address fields added by Shamily
		if(reqtype == 'address' || reqtype == '')
		{			
			if(document.getElementById('pref_add_new').value == 'Home')
			{

				if((document.getElementById("wdesk:resi_line2").value == "" || document.getElementById("wdesk:resi_line2").value == null) && (document.getElementById("wdesk:resi_line1").value == "" || document.getElementById("wdesk:resi_line1").value == null) && (document.getElementById("wdesk:resi_line3").value == "" || document.getElementById("wdesk:resi_line3").value == null) && (document.getElementById("resi_restype").value == "" || document.getElementById("resi_restype").value == "--Select--" || document.getElementById("resi_restype").value == null) && (document.getElementById("wdesk:resi_line4").value == "" || document.getElementById("wdesk:resi_line4").value == null) && (document.getElementById("wdesk:resi_zipcode").value == "" || document.getElementById("wdesk:resi_zipcode").value == null) && (document.getElementById("wdesk:resi_pobox").value == "" || document.getElementById("wdesk:resi_pobox").value == null) || (document.getElementById("wdesk:resi_city").value == "" || document.getElementById("wdesk:resi_city").value == null) && (document.getElementById("wdesk:resi_state").value == "" || document.getElementById("wdesk:resi_state").value == null) && (document.getElementById("resi_cntrycode").value != "" && document.getElementById("resi_cntrycode").value != "--Select--" && document.getElementById("resi_cntrycode").value != null))
				{
					document.getElementById('resi_cntrycode').value = '--Select--';
					document.getElementById('wdesk:resi_cntrycode').value = '';
				}
				if(document.getElementById('wdesk:country_of_res_exis').value == 'AE')
				{
					document.getElementById('rpobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
					document.getElementById('rcity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
					//document.getElementById('rcountry').innerHTML = 'Country<FONT color=red>*</FONT>';	

				}
					else{
					document.getElementById('rcity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
					}
			}
			else
			{
				
					document.getElementById('rpobox').innerHTML ="PO Box";
					document.getElementById('rcity').innerHTML ="Emirates/City";
					//document.getElementById('rcountry').innerHTML ="Country";
				
				}			
			
			
			if(document.getElementById('pref_add_new').value == 'Office')
			{

				if(document.getElementById('wdesk:country_of_res_exis').value == 'AE')
				{
					document.getElementById('opobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
					document.getElementById('ocity').innerHTML ='Emirates/City<FONT color=red>*</FONT>';
					document.getElementById('ocountry').innerHTML = 'Country<FONT color=red>*</FONT>';	

				}
				else{
					document.getElementById('ocity').innerHTML ='Emirates/City<FONT color=red>*</FONT>';
					document.getElementById('ocountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
			}
			else
			{
				document.getElementById('ocity').innerHTML ="Emirates/City";
				document.getElementById('opobox').innerHTML ="PO Box";
				document.getElementById('ocountry').innerHTML ="Country";
			}
		}
		if(reqtype == 'nationality' || reqtype == '')
		{
			if(document.getElementById('nation_new').value = 'US')
			{
				document.getElementById('mfatcadoc').innerHTML ='Fatca Document<FONT color=red>*</FONT>';
			}
			else
			{
				document.getElementById('mfatcadoc').innerHTML = 'Fatca Document';
			}
		}
		
		if(reqtype == 'Primarymail' || reqtype == '')
		{
			if((document.getElementById('E_Stmnt_regstrd_new').value == 'Yes') || ((document.getElementById('E_Stmnt_regstrd_new').value == '--Select--' ||document.getElementById('E_Stmnt_regstrd_new').value == '' || document.getElementById('E_Stmnt_regstrd_new').value == null ) &&  document.getElementById('wdesk:E_Stmnt_regstrd_exis').value == 'Y'))
			{
				document.getElementById('mprimarymail').innerHTML = 'Primary Email Id<FONT color=red>*</FONT>';
			}
			else
			{
				document.getElementById('mprimarymail').innerHTML = 'Primary Email Id';
			}
		}
		//mandatory field for employment type as self employed
		if(reqtype =='emp_type'|| reqtype=='emp_typenonmand' )
		{
			
		 if(reqtype =='emp_type')
			{
				
			document.getElementById('Industry_Segment').innerHTML = 'Industry Segment<FONT color=red>*</FONT>';
			document.getElementById('Industry_SubSegment').innerHTML ='Industry SubSegment<FONT color=red>*</FONT>';
			//document.getElementById('DealingCount').innerHTML = 'Dealing With Countries<FONT color=red>*</FONT>';	
			}
			else
				{
				document.getElementById('Industry_Segment').innerHTML = 'Industry Segment';
				document.getElementById('Industry_SubSegment').innerHTML ='Industry SubSegment';
				//document.getElementById('DealingCount').innerHTML = 'Dealing With Countries';	
			}
		} 
		if(reqtype =='Oecd_city')
		{
			var MobilePhone_New1 = document.getElementById('wdesk:MobilePhone_New1').value;
			var sec_mob_phone_newC = document.getElementById('wdesk:sec_mob_phone_newC').value;
			var homephone_newC = document.getElementById('wdesk:homephone_newC').value;
			var office_phn_newC = document.getElementById('wdesk:office_phn_newC').value;
			var homecntryphone_newC = document.getElementById('wdesk:homecntryphone_newC').value;
			var Oecdcity_new = document.getElementById('wdesk:Oecdcity_new').value;
			var offcCountry1 = document.getElementById('offcCountry1').value;
			var office_cntrycode = document.getElementById('office_cntrycode').value;
	
			if((MobilePhone_New1 !="" && MobilePhone_New1 !=null && MobilePhone_New1 != document.getElementById('Phone1CountryCode').value) || (sec_mob_phone_newC !="" && sec_mob_phone_newC !=null && sec_mob_phone_newC != document.getElementById('Phone2CountryCode').value) || (homephone_newC !="" && homephone_newC !=null && homephone_newC != document.getElementById('HomePhoneCountryCode').value) || (office_phn_newC !="" && office_phn_newC !=null && office_phn_newC != document.getElementById('OfficePhoneCountryCode').value)|| (homecntryphone_newC !="" && homecntryphone_newC !=null && homecntryphone_newC != document.getElementById('HomeCountryPhoneCountryCode').value)|| (office_cntrycode != null && office_cntrycode != "" && office_cntrycode != "--Select--" && office_cntrycode != offcCountry1))
			
				
				{	
					document.getElementById('OecdCitym').innerHTML = 'City Of Birth<FONT color=red>*</FONT>';	
					document.getElementById('CRSUndocm').innerHTML = 'CRS Undocumented Flag<FONT color=red>*</FONT>';	
				}
				else
				{
					document.getElementById('OecdCitym').innerHTML = 'City Of Birth';
					document.getElementById('CRSUndocm').innerHTML = 'CRS Undocumented Flag';
				}
				
		}
				
		if(reqtype =='OecdCntryTax1'){
			if( document.getElementById('OECDUndoc_Flag_new').value =="No")
			{
				document.getElementById('OecdCntryTax1').innerHTML = 'Country Of Tax Residence 1<FONT color=red>*</FONT>';	
		
			}
			else{
				document.getElementById('OecdCntryTax1').innerHTML = 'Country Of Tax Residence 1';	
			}
			if (  document.getElementById('OECDUndoc_Flag_new').value == "Yes")
			{
				document.getElementById('CRSUndocReasonm').innerHTML = 'CRS Undocumented Flag Reason <FONT color=red>*</FONT>';	
			
			}
			else{
				document.getElementById('CRSUndocReasonm').innerHTML = 'CRS Undocumented Flag Reason ';	
			}					
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           to put existing flat number,po box,city and country in new corresponding fields if new one are empty based on 									   selected preferred address.

//***********************************************************************************//	
	function autoexisAddrpopulate()
	{
		if(document.getElementById("pref_add_new").value == 'Home')
		{
			if(document.getElementById("wdesk:resi_line1").value == '')
			{
			
				document.getElementById("wdesk:resi_line1").value=document.getElementById("resAddress1").value;
			}if(document.getElementById("wdesk:resi_pobox").value == '')
			{
				document.getElementById("wdesk:resi_pobox").value=document.getElementById("resi_pobox1").value;
			}if(document.getElementById("wdesk:resi_city").value == '')
			{
				document.getElementById("wdesk:resi_city").value=document.getElementById("wdesk:resi_cityexis").value;
			}if(document.getElementById("resi_cntrycode").value == '--Select--' || document.getElementById("resi_cntrycode").value == '')
			{
				//Modified for JIRA BU-353 on 01072018 Start
				var resiCountryExist= document.getElementById("wdesk:resi_countryexis").value;
				if (resiCountryExist !='')
				{
					document.getElementById('resi_cntrycode').options[document.getElementById('resi_cntrycode').selectedIndex].text=resiCountryExist;
					showlabel('wdesk:resi_country');
				}
				else
				{
					document.getElementById("resi_cntrycode").disabled = false;
				}
			}//Modified for JIRA BU-353 on 01072018 End
		
		}
		else if(document.getElementById("pref_add_new").value == 'Office')
		{
			if(document.getElementById("wdesk:office_line1").value == '')
			{
			
				document.getElementById("wdesk:office_line1").value=document.getElementById("OffcAddress1").value;
			}if(document.getElementById("wdesk:office_pobox").value == '')
			{
				document.getElementById("wdesk:office_pobox").value=document.getElementById("offc_pobox1").value;
			}if(document.getElementById("office_city").value == '')
			{
				document.getElementById("office_city").value=document.getElementById("offcCity1").value;
			}if(document.getElementById("office_cntrycode").value == '--Select--' || document.getElementById("office_cntrycode").value == '')
			{
				document.getElementById('office_cntrycode').options[document.getElementById('office_cntrycode').selectedIndex].text=document.getElementById("offcCountry1").value;
					showlabel('office_cntrycode');
			//	alert( document.getElementById("offcCountry1").value);
			//document.getElementById('office_cntrycode').value = document.getElementById("offcCountry1").value;
		//	alert('office_cntrycode'+document.getElementById('office_cntrycode').value);
			//ajaxRequest(workstepName, 'office_cntrycode');
			}
		
		}
		/*else if(document.getElementById("pref_add_new").value == '--Select--' || document.getElementById("pref_add_new").value == '')
		{
			
			document.getElementById("wdesk:resi_line1").value = '';
			document.getElementById("wdesk:office_line1").value='';
			document.getElementById("wdesk:resi_pobox").value = ''
			document.getElementById("wdesk:office_pobox").value = '';
			
			document.getElementById("resi_city").value='';
			document.getElementById("office_city").value = '';
			document.getElementById('resi_cntrycode').options[document.getElementById('resi_cntrycode').selectedIndex].text = '--Select--';
			document.getElementById('office_cntrycode').options[document.getElementById('office_cntrycode').selectedIndex].text = '--Select--';
				
			} */
		
		
	} 
	
	function addselect()
	{
		
		if(document.getElementById('office_cntrycode').options[document.getElementById('office_cntrycode').selectedIndex].text != '--Select--')
		{
			
			document.getElementById('office_cntrycode').options[document.getElementById('office_cntrycode').selectedIndex].text='--Select--';
		}
	
	}

	function DocRequired(FieldName, FieldNameToUpdate, WSNAME) {
	
		if (document.getElementById(FieldName).value) {
			var ajaxReq;
			if (window.XMLHttpRequest) {
				ajaxReq = new XMLHttpRequest();
			} else if (window.ActiveXObject) {
				ajaxReq = new ActiveXObject("Microsoft.XMLHTTP");
			}
			var url = "/CU/CustomForms/CU_Specific/DBOperation.jsp?FieldName=" + FieldName + "&FieldNameToUpdate=" + FieldNameToUpdate + "&WSNAME=" + WSNAME;
	
			ajaxReq.open("POST", url, false);
			ajaxReq.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			ajaxReq.send(null);
			if (ajaxReq.status == 200 && ajaxReq.readyState == 4) {
				document.getElementById(FieldName).value = ajaxReq.responseText;		
			} else {
				alert("some error occured while fetching exception status");
				return -1;
			}
		} else {
			//alert("");
		}
	}

	function delRow() {

		var r = confirm("Do you want to delete the row?");
		if (r == true) {
			var current = window.event.srcElement;
			current = current.parentNode.parentNode;
			current.parentNode.removeChild(current);

			var table = document.getElementById("myTable");

			for (var i = 1, row; row = table.rows[i]; i++) {
				table.rows[i].cells[0].innerHTML = i;
			}
		} else {
			return;
		}
	}

	function toggleTable() {
		if (document.getElementById("myTable").style.display == "table") {
			document.getElementById("myTable").style.display = "none";
			document.getElementById("uidview").value = "Click to View UIDs";
			if (document.getElementById("add_row") != undefined)
				document.getElementById("add_row").style.visibility = "hidden";
		} else {
			document.getElementById("myTable").style.display = "table";
			document.getElementById("uidview").value = "Click to Hide UIDs";
			if (document.getElementById("add_row") != undefined)
				document.getElementById("add_row").style.visibility = "visible";
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           To validate emirates,visa and passport expiry dates on clicking on radio button

//***********************************************************************************//
	function validateDatepassportexpiryCheck() {
		var WSNAME = '<%=WSNAME%>';
		if (WSNAME == "CSO" || WSNAME == "PBO" || WSNAME == "OPS%20Maker_DE" || WSNAME == "CSO_Rejects") {
			var enteredPassportDate = document.getElementById("wdesk:passportExpDate_exis").value;
			var enteredVisaDate = document.getElementById("wdesk:visaExpDate_exis").value;
			var enteredEmiratesDate = document.getElementById("wdesk:emiratesidexp_exis").value;

			var today = new Date();
			var arrStartDate = enteredPassportDate.split("/");
			var date1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);

			var arrStartDate2 = enteredVisaDate.split("/");
			var date2 = new Date(arrStartDate2[2], arrStartDate2[1] - 1, arrStartDate2[0]);

			var arrStartDate3 = enteredEmiratesDate.split("/");
			var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);

			var timeDiffPassport = date1.getTime() - today.getTime();
			var timeDiffVisa = date2.getTime() - today.getTime();
			var timeDiffEmirates = date3.getTime() - today.getTime();
			var alerted=false;
			if (timeDiffPassport < 0) {
				alert("Passport has Expired");
				document.getElementById('Passno').innerHTML = 'Passport Number<FONT color="red">*</FONT>';			
				document.getElementById('passexpdate').innerHTML = 'Passport Expiry Date<FONT color="red">*</FONT>';
				alerted=true;
			} 
			
			if (timeDiffVisa < 0) {
				if(!alerted)
					alert("Visa has Expired");
				document.getElementById('Visac').innerHTML = 'Visa Number<FONT color=red>*</FONT>';
				document.getElementById('visaexp').innerHTML = 'Visa Expiry Date<FONT color=red>*</FONT>';	
				alerted=true;
			} 
			
			if (timeDiffEmirates < 0) {
				if(!alerted)
					alert("Emirates Id has Expired");
				document.getElementById('emidc').innerHTML = 'Emirates ID Number<FONT color=red>*</FONT>';
				document.getElementById('EMIDexpdt').innerHTML = 'Emirates ID Expiry Date<FONT color=red>*</FONT>';
				alerted=true;
			}
		}
		return false;
	}
	function addrow() {
		var table = document.getElementById("myTable");
		var lastRow = table.rows[table.rows.length - 1];
		var row = table.insertRow();

		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);
		var cell3 = row.insertCell(2);
		var cell4 = row.insertCell(3);

		if (lastRow.cells[0].innerHTML == 'S.No')
			cell1.innerHTML = 1;
		else
			cell1.innerHTML = Number(lastRow.cells[0].innerHTML) + 1;
		cell2.innerHTML = "<input type='text' size='35' id='UID' value=''>";
		cell2.innerHTMl = "<input type='text' size='35' id='UID' value=''>";
		cell3.innerHTML = "<input type='text' size='50' id='Remarks' >";
		cell4.innerHTML = "<img src='/CU/webtop/images/delete.gif' style='width:21px;height:21px;border:0;' onclick='delRow();'>";
	}

	function validate(ColumnCopy) {

		try {
			document.getElementById("Fetch").disabled = true;
			var panNo = document.getElementById(ColumnCopy).value;
			var cardNo = replaceAll(panNo, "-", "");

			if (document.getElementById(ColumnCopy).value == "") {
				alert("Card No. is mandatory.");
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled = false;
				return false;
			}
			regex = /^[X0-9]/;
			if (!regex.test(cardNo)) {
				alert("Only numerics are allowed in Card No.");
				document.getElementById(ColumnCopy).value = "";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled = false;
				return false;
			}
			if (cardNo.length != 16) {
				alert("Length of card no. should be exactly 16 digits.");
				document.getElementById(ColumnCopy).value = "";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled = false;
				return false;
			}

			if (!mod10(cardNo)) {
				alert("Invalid Card No.");
				document.getElementById(ColumnCopy).value = "";
				document.getElementById(ColumnCopy).focus();
				document.getElementById("Fetch").disabled = false;
				return false;
			}
			document.getElementById(ColumnCopy).disabled = true;

			var maskedCardNumber = "";

			maskedCardNumber = document.getElementById("d_PANno").value.substring(0, 6) + "XXXXXX" + document.getElementById("d_PANno").value.substring(12, 16);
			maskedCardNumber = maskedCardNumber.substring(0, 4) + "-" + maskedCardNumber.substring(4, 8) + "-" + maskedCardNumber.substring(8, 12) + "-" + maskedCardNumber.substring(12, 16);
			document.getElementById("d_PANno").value = maskedCardNumber;

			return true;
		} catch (e) {
			alert("error==" + e.message + ".");
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           To disable radio buttons at other worksteps except CSO and PBO

//***********************************************************************************//
	
	function disableRadio(WSNAME) {

		if (WSNAME == "CSO_Doc_Scan" || WSNAME == "PBO_Rejects" || WSNAME == "OPS%20Maker_DE" || WSNAME == "OPS_Checker_Review" || WSNAME == "Archival_Activity" || WSNAME == "Archival_Rejects" || WSNAME == "Hold" || WSNAME == "Error" || WSNAME == "CSM_Review") {
			var i = 0;

			var radios = document.getElementsByName("Individual");
			for (i = 0; i < radios.length; i++) {
				radios[i].disabled = true;
			}

			radios = document.getElementsByName("Non-Individual");
			for (i = 0; i < radios.length; i++) {
				radios[i].disabled = true;
			}
		}
		if (WSNAME == "OPS%20Maker_DE") {
			disableProfileFields();
		}
	}

	var lastCIFval = '';
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           To show form on clicking on radio button

//***********************************************************************************//
	function showDivForRadio(Object) {

		document.getElementById("radiaoCheck").value = "Y";
		var WSNAME = '<%=WSNAME%>';

		if (Object.id == "Individual") {
			lastCIFval = Object.value;
			document.getElementById("wdesk:SelectedCIF").value = lastCIFval;
			div = document.getElementById('divCheckbox2');
			div.style.display = "block";
			var main_gridVal = document.getElementById("main_grid").value;
			var main_val = "";
			var cif_id = "";
			var cif_type = "";
			main_gridVal = main_gridVal.split("~");

			for (var i = 0; i < main_gridVal.length - 1; i++) {
				main_val = main_gridVal[i].toString().split("#");
				if (main_val[0].toString() == Object.id.toString()) {
					cif_id = main_val[1].toString();
					cif_type = main_val[2].toString();
					break;
				}
			}
			if (cif_id == "")
				cif_id = lastCIFval;
				
			if(WSNAME != "Archival_Activity" || WSNAME != "Archival_Rejects" || WSNAME != "Exit" || WSNAME != "Reject" )
			{
				getCustDetails("Individual", cif_id, cif_type);    //Added by Shamily Dec CR to not call Entity_details at Archival WS
				//called to fetch Address details added by Shamily
				getCustomerDetails("Individual",cif_id)
			}



			if (WSNAME == 'CSO' || (WSNAME == 'OPS%20Maker_DE' && document.getElementById("wdesk:Channel").value == "Phone Banking") || (WSNAME == "CSO_Rejects" && document.getElementById("wdesk:Channel").value == "Phone Banking"))
				getAccSummary("Individual", cif_id);
			else {
				document.getElementById("PBOHide1").style.display = "none";
				document.getElementById("PBOHide2").style.display = "none";
				document.getElementById("PBOHide3").style.display = "none";
				document.getElementById("PBOHide4").style.display = "none";
				document.getElementById("PBOHide5").style.display = "none";
				document.getElementById("PBOHide6").style.display = "none";
				document.getElementById("PBOHide7").style.display = "none";
				document.getElementById("PBOHide8").style.display = "none";
				document.getElementById("PBOHide9").style.display = "none";
				document.getElementById("PBOHideFormGeneration").style.display = "none";
				document.getElementById("ReadEmiratesID").style.display = "none";
			}
		} else if (Object.id == "Non-Individual") {
			alert("Request cannot be taken for Non-Individual CIF Type");
			$("input[value='" + lastCIFval + "']").prop('checked', 'checked');
			Object.checked = false;

			return false;
			div = document.getElementById('divCheckbox2');
			div.style.display = "none";
			div = document.getElementById('divCheckbox3');
			div.style.display = "block";
		}

		document.getElementById("wdesk:Updated_CIFNumber").value = lastCIFval;
		var TypeOfRelation_exis = document.getElementById("wdesk:TypeOfRelation_exis").value;
		if (TypeOfRelation_exis.indexOf("!") != -1) {

			TypeOfRelation_exis = TypeOfRelation_exis.replace(/!/gi, "\n").replace(/^,/, "");;
			document.getElementById("wdesk:TypeOfRelation_exis").value = TypeOfRelation_exis;
		}
		var FatcaDoc = document.getElementById("wdesk:FatcaDoc").value;
		if (FatcaDoc.indexOf("!") != -1) {

			FatcaDoc = FatcaDoc.replace(/!/gi, "\n").replace(/^,/, "");;
			document.getElementById("wdesk:FatcaDoc").value = FatcaDoc;
		}
		
		if (WSNAME != 'PBO') {
			disableProfileFields();
		}
		showlabel('Occupation');
		showlabel('Employement');
		//showlabel('Gender');
		showlabel('USRelation');
		showlabel('abcdelig');
		showlabel('IndustrySeg');
		showlabel('IndustrySubSeg');
		showlabel('marrital');
		//showlabel('E-Statement');
		showlabel('CustomerType');
		
		if((WSNAME == 'CSO' && document.getElementById('wdesk:Channel').value == 'Customer Initiated') || (WSNAME == 'OPS%20Maker_DE') || (WSNAME == "CSO_Rejects" && document.getElementById('wdesk:Channel').value == 'Customer Initiated' ))
		{
			var str = "*";
			var result = str.fontcolor("red"); 
				
			if(document.getElementById("wdesk:PassportNumber_New").value != '' && document.getElementById("wdesk:PassportNumber_New").value != null)
			{
				document.getElementById('passexpdate').innerHTML = 'Passport Expiry Date<FONT color=red>*</FONT>';			
			}
			else
			{
				document.getElementById('passexpdate').innerHTML = 'Passport Expiry Date';
			}
			
			if(document.getElementById("wdesk:passportExpDate_new").value != "" && document.getElementById("wdesk:passportExpDate_new").value != null)
			{		
	    		document.getElementById('Passno').innerHTML = 'Passport Number<FONT color=red>*</FONT>';		
			}
			else
			{
				document.getElementById('Passno').innerHTML = 'Passport Number';
			}
			
			if((document.getElementById("wdesk:comp_name_new").value != "" && document.getElementById("wdesk:comp_name_new").value != null) || (document.getElementById("wdesk:emp_name_new").value != "" && document.getElementById("wdesk:emp_name_new").value != null) || (document.getElementById("occupation_new").value != "--Select--" && document.getElementById("occupation_new").value != null && document.getElementById("occupation_new").value != "") || (document.getElementById("wdesk:naturebusiness_new").value != "" && document.getElementById("wdesk:naturebusiness_new").value != null))
			{
				document.getElementById('Visac').innerHTML = 'Visa Number<FONT color=red>*</FONT>';
				document.getElementById('visaexp').innerHTML = 'Visa Expiry Date<FONT color=red>*</FONT>';		
			}
			else
			{
				document.getElementById('Visac').innerHTML = 'Visa Number';
				document.getElementById('visaexp').innerHTML = 'Visa Expiry Date';	
			}
			// code modified for reqtype  == 'address' to set mandatory address fields added by Shamily
			if(document.getElementById('pref_add_new').value == 'Home')
			{
				if(document.getElementById('wdesk:country_of_res_exis').value == 'AE')
				{
				document.getElementById('rpobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
				document.getElementById('rcity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
				//document.getElementById('rcountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
				else{
					document.getElementById('rcity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
				}
			}
			else
			{
				document.getElementById('rpobox').innerHTML ="PO Box";
				document.getElementById('rcity').innerHTML ="Emirates/City";
				document.getElementById('rcountry').innerHTML ="Country";
			}
			// code modified for reqtype  == 'address' to set mandatory address fields added by Shamily
			if(document.getElementById('pref_add_new').value == 'Office')
			{
				if(document.getElementById('wdesk:country_of_res_exis').value == 'AE')
				{
				document.getElementById('opobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
				document.getElementById('ocity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
				document.getElementById('ocountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
				else{
					document.getElementById('ocity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
					document.getElementById('ocountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
			}
			else
			{
				document.getElementById('ocity').innerHTML ="Emirates/City";
				document.getElementById('opobox').innerHTML ="PO Box";
				document.getElementById('ocountry').innerHTML ="Country";
			}
			if(document.getElementById('nation_new').value == 'US' || ((document.getElementById('nation_new').value == '--Select--' || document.getElementById('nation_new').value == "" || document.getElementById('nation_new').value == null ) && document.getElementById('wdesk:nation_exist').value == 'US' ))
			{		
				document.getElementById('mfatcadoc').innerHTML ='Fatca Document<FONT color=red>*</FONT>';								
			}
			else
			{
				document.getElementById('mfatcadoc').innerHTML = 'Fatca Document';
			}
			if((document.getElementById('E_Stmnt_regstrd_new').value == 'Yes') || ((document.getElementById('E_Stmnt_regstrd_new').value == '--Select--' ||document.getElementById('E_Stmnt_regstrd_new').value == '' || document.getElementById('E_Stmnt_regstrd_new').value == null ) &&  document.getElementById('wdesk:E_Stmnt_regstrd_exis').value == 'Y'))
			{
				
				document.getElementById('mprimarymail').innerHTML = 'Primary Email Id<FONT color=red>*</FONT>';
				
			}
			else
			{
				document.getElementById('mprimarymail').innerHTML = 'Primary Email Id';
			}
			
			var MobilePhone_New1 = document.getElementById('wdesk:MobilePhone_New1').value;
			var sec_mob_phone_newC = document.getElementById('wdesk:sec_mob_phone_newC').value;
			var homephone_newC = document.getElementById('wdesk:homephone_newC').value;
			var office_phn_newC = document.getElementById('wdesk:office_phn_newC').value;
			var homecntryphone_newC = document.getElementById('wdesk:homecntryphone_newC').value;
			var Oecdcity_new = document.getElementById('wdesk:Oecdcity_new').value;
			var offcCountry1 = document.getElementById('offcCountry1').value;
			var office_cntrycode = document.getElementById('office_cntrycode').value;
	
			if((MobilePhone_New1 !="" && MobilePhone_New1 !=null && MobilePhone_New1 != document.getElementById('Phone1CountryCode').value) || (sec_mob_phone_newC !="" && sec_mob_phone_newC !=null && sec_mob_phone_newC != document.getElementById('Phone2CountryCode').value) || (homephone_newC !="" && homephone_newC !=null && homephone_newC != document.getElementById('HomePhoneCountryCode').value) || (office_phn_newC !="" && office_phn_newC !=null && office_phn_newC != document.getElementById('OfficePhoneCountryCode').value)|| (homecntryphone_newC !="" && homecntryphone_newC !=null && homecntryphone_newC != document.getElementById('HomeCountryPhoneCountryCode').value)|| (office_cntrycode != null && office_cntrycode != "" && office_cntrycode != "--Select--" && office_cntrycode != offcCountry1))
			{
				document.getElementById('OecdCitym').innerHTML = 'City Of Birth<FONT color=red>*</FONT>';	
				document.getElementById('CRSUndocm').innerHTML = 'CRS Undocumented Flag<FONT color=red>*</FONT>';	
			}
			else
			{
				document.getElementById('OecdCitym').innerHTML = 'City Of Birth';
				document.getElementById('CRSUndocm').innerHTML = 'CRS Undocumented Flag';	
			}
			
			if( document.getElementById('OECDUndoc_Flag_new').value =="No")
			{
				document.getElementById('OecdCntryTax1').innerHTML = 'Country Of Tax Residence 1<FONT color=red>*</FONT>';	
				
			}
			else{
				document.getElementById('OecdCntryTax1').innerHTML = 'Country Of Tax Residence 1';	
			}
			 if (  document.getElementById('OECDUndoc_Flag_new').value == "Yes")
			{
				document.getElementById('CRSUndocReasonm').innerHTML = 'CRS Undocumented Flag Reason <FONT color=red>*</FONT>';	
				
			}
			else{
				document.getElementById('CRSUndocReasonm').innerHTML = 'CRS Undocumented Flag Reason ';	
			}
			document.getElementById('OecdCntrym').innerHTML = 'Country Of Birth<FONT color=red>*</FONT>';	
			
			validateemptype();
			validateDatepassportexpiryCheck();
			
			// Start - EnableDisable FatcaField based on USRelation added on 27092017
			if ((WSNAME == 'CSO' && document.getElementById("wdesk:Channel").value == "Customer Initiated" ) || (WSNAME == 'CSO_Rejects' && document.getElementById("wdesk:Channel").value == "Customer Initiated" ))
			{
				EnableDisableFieldChange('USRelation');
				EnableDisableFieldChange('OECDUndoc_Flag');
			}
			// End - EnableDisable FatcaField based on USRelation added on 27092017
			
			//Modified for JIRA BU-353 on 01072018 Start
			var resiCountryExist= document.getElementById("wdesk:resi_countryexis").value;
			if (resiCountryExist == '')
			{
				document.getElementById("resi_cntrycode").disabled = false;
			}
			//************************************************
		}
		
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           To get customer details from entity_details call

//***********************************************************************************//
	function getCustDetails(cif_type, cidf_id, cidf_type) {

		var xmlDoc;
		var x;
		var xLen;
		var request_type = "ENTITY_DETAILS_2";
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		
		var account_number = document.getElementById("wdesk:account_number").value;
		var mobile_number = document.getElementById("wdesk:MobilePhone_Existing").value;
		var emirates_id = document.getElementById("wdesk:emirates_id").value;
		var user_name = '<%=customSession.getUserName()%>';
		var url = "/CU/CustomForms/CU_Specific/CUIntegration.jsp";
		var wi_name = '<%=WINAME%>';
		var param = "request_type=" + request_type + "&cif_type=" + cif_type + "&wi_name=" + wi_name + "&CIF_ID=" + cidf_id + "&cidf_type=" + cidf_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&user_name=" + user_name;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		if (xhr.status == 200 && xhr.readyState == 4) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in fetching getting Customer Details.");
				return false;
			}

			var res = ajaxResult.split("`");
			var newres = "";
			for (var i = 0; i < res.length; i++) {
				newres = res[i].split("~");
				if (newres.length > 1 && document.getElementById(newres[0])) {
					document.getElementById(newres[0]).value = newres[1];
				}
			}
			// validation added on 04032018
			if (document.getElementById('wdesk:abcdelig_exis').value == 'Yes' || document.getElementById('wdesk:abcdelig_exis').value == 'Y')
			{
				document.getElementById('abcdelig_new').value = '--Select--';
				document.getElementById('abcdelig_new').disabled = true;
			} else if (document.getElementById('wdesk:abcdelig_exis').value == 'No' || document.getElementById('wdesk:abcdelig_exis').value == 'N')
			{
				document.getElementById('abcdelig_new').value = 'Yes';
				document.getElementById('wdesk:abcdelig_new').value = 'Yes';
				document.getElementById('abcdelig_new').disabled = true;
			}
			//****************************************
		} else {
			alert("Problem in getting Customer Details.");
			return false;
		}
		//Added by Shamily Dec CR to update Total years of Employment existing and Total years of Employment according to employment status
		
		if(document.getElementById("wdesk:emp_type_exis").value.toUpperCase() == "Salaried".toUpperCase())
		{
			document.getElementById("wdesk:years_of_business_exis").value ='';	
		}
		else if (document.getElementById("wdesk:emp_type_exis").value.toUpperCase() == "Self employed".toUpperCase())
		{
		    document.getElementById("wdesk:total_year_of_emp_exis").value ='';
		}
		else
		{
			document.getElementById("wdesk:total_year_of_emp_exis").value ='';
			document.getElementById("wdesk:years_of_business_exis").value ='';	
		}
		return true;
	}
	//called to fetch Address details added by Shamily
	function getCustomerDetails(cif_type,cif_id) {

		var xmlDoc;
		var x;
		var xLen;
		var request_type = "CUSTOMER_DETAILS";
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		
		//var account_number = document.getElementById("wdesk:account_number").value;
		//var mobile_number = document.getElementById("wdesk:MobilePhone_Existing").value;
		//var emirates_id = document.getElementById("wdesk:emirates_id").value;
		var user_name = '<%=customSession.getUserName()%>';
		var url = "/CU/CustomForms/CU_Specific/CustDetails_AddressFetch.jsp";
		var wi_name = '<%=WINAME%>';
		var param = "request_type=" + request_type  + "&cif_type=" + cif_type + "&wi_name=" + wi_name  + "&user_name=" + user_name+ "&CIF_ID=" + cif_id;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		if (xhr.status == 200 && xhr.readyState == 4) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in fetching getting Customer Details.");
				return false;
			}

			var res = ajaxResult.split("`");
			var newres = "";
			for (var i = 0; i < res.length; i++) {
				newres = res[i].split("~");
				if (newres.length > 1 && document.getElementById(newres[0])) {
					document.getElementById(newres[0]).value = newres[1];
					if(newres[0] == 'wdesk:peopleOfDeterm_exis'){
						if(newres[1] == 'Yes')
							document.getElementById('wdesk:peopleOfDeterm').value = "Yes"
						else
							document.getElementById('wdesk:peopleOfDeterm').value = "No"
					}
				}
			}
			// validation added on 04032018
			if (document.getElementById('wdesk:abcdelig_exis').value == 'Yes' || document.getElementById('wdesk:abcdelig_exis').value == 'Y')
			{
				document.getElementById('abcdelig_new').value = '--Select--';
				document.getElementById('abcdelig_new').disabled = true;
			} else if (document.getElementById('wdesk:abcdelig_exis').value == 'No' || document.getElementById('wdesk:abcdelig_exis').value == 'N')
			{
				document.getElementById('abcdelig_new').value = 'Yes';
				document.getElementById('abcdelig_new').disabled = true;
			}
			//****************************************
		} else {
			alert("Problem in getting Customer Details.");
			return false;
		}
		
		return true;
	}
	
	
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To get data from account_summary call

//***********************************************************************************//	
	function account_post_call(sMappOutPutXML) {
	
		var FetchFINAccountListRes = "";
		if (sMappOutPutXML.indexOf("<FetchFINAccountListRes>") != -1) {
			FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"), sMappOutPutXML.indexOf("</FetchFINAccountListRes>") + "</FetchFINAccountListRes>".length);
		}

		var rowVal = "";
		var account_num = "";
		var account_type = "";
		var product_id = "";
		var modeofoperation = "";
		var account_name = "";
		var signatureUpdate = "";
		var acc_list_str = "";
		var val_main = "";
		var row = 0;
		while (FetchFINAccountListRes.indexOf("<FINAccountDetail>") != -1) {
			row++;
			account_num = "";
			account_type = "";
			product_id = "";
			modeofoperation = "";
			account_name = "";
			rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"), FetchFINAccountListRes.indexOf("</FINAccountDetail>") + "</FINAccountDetail>".length);
			if (rowVal.indexOf("<Acid>") != -1) {
				account_num = rowVal.substring(rowVal.indexOf("<Acid>") + "</Acid>".length - 1, rowVal.indexOf("</Acid>"));
				acc_list_str = rowVal.substring(rowVal.indexOf("<Acid>") + "</Acid>".length - 1, rowVal.indexOf("</Acid>")) + "@" + acc_list_str;
			}
			if (rowVal.indexOf("<AcctType>") != -1)
				account_type = rowVal.substring(rowVal.indexOf("<AcctType>") + "</AcctType>".length - 1, rowVal.indexOf("</AcctType>"));
			if (rowVal.indexOf("<ProductId>") != -1)
				product_id = rowVal.substring(rowVal.indexOf("<ProductId>") + "</ProductId>".length - 1, rowVal.indexOf("</ProductId>"));
			if (rowVal.indexOf("<ModeOfOperation>") != -1)
				modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>") + "</ModeOfOperation>".length - 1, rowVal.indexOf("</ModeOfOperation>"));
			if (rowVal.indexOf("<AccountName>") != -1)
				account_name = rowVal.substring(rowVal.indexOf("<AccountName>") + "</AccountName>".length - 1, rowVal.indexOf("</AccountName>"));

			var nameCheckbox = "row" + row + "_signatureupdate";
			var checkbox_name = "checkbox_signatureupdate";
			var button_name = " button_signatureupdate";
			var fetch = "Fetch Signature";

			var tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)' name=" + "'" + checkbox_name + "'" + " value=" + "'" + nameCheckbox + "'" + " id=" + "'" + nameCheckbox + "'" + "></td>";

			var tempButtonBox = "<td><input type='button' name=" + "'" + button_name + "'" + " value=" + "'" + fetch + "'" + " id=" + "'" + nameCheckbox + "'" + "></td>";

			signatureUpdate = signatureUpdate + "<tr class='EWNormalGreenGeneral1'>" + tempcheckBox + "<td id='accountNum_" + nameCheckbox + "'>" + account_num + "</td><td>" + account_type + "</td><td>" + modeofoperation + "</td>" + tempButtonBox + "</tr>";

			val_main = val_main + nameCheckbox + "#" + account_num + "#" + account_type + "#" + modeofoperation + "~";

			FetchFINAccountListRes = FetchFINAccountListRes.replace(rowVal, "");
		}

		val_main = val_main + "$$";

		var appendStr = "<table id='signatureupdate' border=1 width='100%' ><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Account Number</th><th>Name</th><th>Mode of Operation</th><th>Fetch Signature</th></tr>";

		var outputXml = "";
		outputXml = appendStr + signatureUpdate + "</table>";

		var dormancyActivation = "";
		if (sMappOutPutXML.indexOf("<FetchFINAccountListRes>") != -1) {
			FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"), sMappOutPutXML.indexOf("</FetchFINAccountListRes>") + "</FetchFINAccountListRes>".length);
		}
		row = 0;
		if (FetchFINAccountListRes.indexOf("<DormantSince>") != -1) {
			while (FetchFINAccountListRes.indexOf("<FINAccountDetail>") != -1) {
				row++;
				var DormantSince = "";

				account_num = "";
				account_type = "";
				product_id = "";
				modeofoperation = "";
				account_name = "";
				rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"), FetchFINAccountListRes.indexOf("</FINAccountDetail>") + "</FINAccountDetail>".length);

				if (rowVal.indexOf("<DormantSince>") != -1) {
					if (rowVal.indexOf("<Acid>") != -1)
						account_num = rowVal.substring(rowVal.indexOf("<Acid>") + "</Acid>".length - 1, rowVal.indexOf("</Acid>"));
					if (rowVal.indexOf("<AcctType>") != -1)
						account_type = rowVal.substring(rowVal.indexOf("<AcctType>") + "</AcctType>".length - 1, rowVal.indexOf("</AcctType>"));
					if (rowVal.indexOf("<ProductId>") != -1)
						product_id = rowVal.substring(rowVal.indexOf("<ProductId>") + "</ProductId>".length - 1, rowVal.indexOf("</ProductId>"));
					if (rowVal.indexOf("<ModeOfOperation>") != -1)
						modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>") + "</ModeOfOperation>".length - 1, rowVal.indexOf("</ModeOfOperation>"));
					if (rowVal.indexOf("<DormantSince>") != -1)
						DormantSince = rowVal.substring(rowVal.indexOf("<DormantSince>") + "</DormantSince>".length - 1, rowVal.indexOf("</DormantSince>"));
					var nameCheckbox = "row" + row + "_dormancyactivation";
					var checkbox_name = "checkbox_dormancyactivation";
					var tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)'  name=" + "'" + checkbox_name + "'" + " value=" + "'" + nameCheckbox + "'" + " id=" + "'" + nameCheckbox + "'" + "></td>";
					dormancyActivation = dormancyActivation + "<tr class='EWNormalGreenGeneral1'>" + tempcheckBox + "<td>" + account_num + "</td><td>" + account_type + "</td><td>" + modeofoperation + "</td><td>" + DormantSince + "</td></tr>";

					val_main = val_main + nameCheckbox + "#" + account_num + "#" + account_type + "#" + modeofoperation + "~";
				}
				FetchFINAccountListRes = FetchFINAccountListRes.replace(rowVal, "");
			}

			val_main = val_main + "$$";

			appendStr = "<table id='dormancyactivation' border=1 width='100%'><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Mode of Operation</th><th>Name</th><th>Mode of Operation</th><th>Dormant Since</th></tr>";

			outputXml = outputXml + "~" + appendStr + dormancyActivation + "</table>";
		}

		var jointtosole = "";
		if (sMappOutPutXML.indexOf("<FetchFINAccountListRes>") != -1) {
			FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"), sMappOutPutXML.indexOf("</FetchFINAccountListRes>") + "</FetchFINAccountListRes>".length);
		}

		row = 0;
		if (FetchFINAccountListRes.indexOf("<ModeOfOperation>") != -1) {
			while (FetchFINAccountListRes.indexOf("<FINAccountDetail>") != -1) {

				var DormantSince = "";
				account_num = "";
				account_type = "";
				product_id = "";
				modeofoperation = "";
				account_name = "";
				rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"), FetchFINAccountListRes.indexOf("</FINAccountDetail>") + "</FINAccountDetail>".length);
				var valmodeOfOperation = "";
				if (rowVal.indexOf("<ModeOfOperation>") != -1) {
					modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>") + "</ModeOfOperation>".length - 1, rowVal.indexOf("</ModeOfOperation>"));

					if (modeofoperation == "JOINT") {

						row++;
						if (rowVal.indexOf("<Acid>") != -1)
							account_num = rowVal.substring(rowVal.indexOf("<Acid>") + "</Acid>".length - 1, rowVal.indexOf("</Acid>"));
						if (rowVal.indexOf("<AcctType>") != -1)
							account_type = rowVal.substring(rowVal.indexOf("<AcctType>") + "</AcctType>".length - 1, rowVal.indexOf("</AcctType>"));
						if (rowVal.indexOf("<ProductId>") != -1)
							product_id = rowVal.substring(rowVal.indexOf("<ProductId>") + "</ProductId>".length - 1, rowVal.indexOf("</ProductId>"));

						var nameCheckbox = "row" + row + "_jointtosole";
						var checkbox_name = "checkbox_jointtosole";
						var tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)' name=" + "'" + checkbox_name + "'" + " value=" + "'" + nameCheckbox + "'" + " id=" + "'" + nameCheckbox + "'" + "></td>";
						jointtosole = jointtosole + "<tr class='EWNormalGreenGeneral1'>" + tempcheckBox + "<td>" + account_num + "</td><td>" + account_type + "</td><td>" + modeofoperation + "</td></tr>";

						val_main = val_main + nameCheckbox + "#" + account_num + "#" + account_type + "#" + modeofoperation + "~";
					}
				}

				FetchFINAccountListRes = FetchFINAccountListRes.replace(rowVal, "");
			}

			val_main = val_main + "$$";

			appendStr = "<table id='jointtosole' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th>Select</th><th>CIF Number</th><th>Name</th><th>Mode of Operation</th></tr>";

			outputXml = outputXml + "~" + appendStr + jointtosole + "</table>";			}

		var soletojoint = "";
		if (sMappOutPutXML.indexOf("<FetchFINAccountListRes>") != -1) {
			FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"), sMappOutPutXML.indexOf("</FetchFINAccountListRes>") + "</FetchFINAccountListRes>".length);
		}

		row = 0;
		if (FetchFINAccountListRes.indexOf("<ModeOfOperation>") != -1) {
			while (FetchFINAccountListRes.indexOf("<FINAccountDetail>") != -1) {

				var DormantSince = "";

				account_num = "";
				account_type = "";
				product_id = "";
				modeofoperation = "";
				account_name = "";
				rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"), FetchFINAccountListRes.indexOf("</FINAccountDetail>") + "</FINAccountDetail>".length);
				var valmodeOfOperation = "";
				if (rowVal.indexOf("<ModeOfOperation>") != -1) {
					modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>") + "</ModeOfOperation>".length - 1, rowVal.indexOf("</ModeOfOperation>"));

					if (modeofoperation == "SINGLY") {

						row++;
						if (rowVal.indexOf("<Acid>") != -1)
							account_num = rowVal.substring(rowVal.indexOf("<Acid>") + "</Acid>".length - 1, rowVal.indexOf("</Acid>"));
						if (rowVal.indexOf("<AcctType>") != -1)
							account_type = rowVal.substring(rowVal.indexOf("<AcctType>") + "</AcctType>".length - 1, rowVal.indexOf("</AcctType>"));
						if (rowVal.indexOf("<ProductId>") != -1)
							product_id = rowVal.substring(rowVal.indexOf("<ProductId>") + "</ProductId>".length - 1, rowVal.indexOf("</ProductId>"));

						var nameCheckbox = "row" + row + "_soletojoint";
						var checkbox_name = "checkbox_soletojoint";
						var tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)' name=" + "'" + checkbox_name + "'" + " value=" + "'" + nameCheckbox + "'" + " id=" + "'" + nameCheckbox + "'" + "></td>";
						soletojoint = soletojoint + "<tr class='EWNormalGreenGeneral1'>" + tempcheckBox + "<td>" + account_num + "</td><td>" + account_type + "</td><td>" + modeofoperation + "</td></tr>";
						
						val_main = val_main + nameCheckbox + "#" + account_num + "#" + account_type + "#" + modeofoperation + "~";
					}
				}

				FetchFINAccountListRes = FetchFINAccountListRes.replace(rowVal, "");
			}

			val_main = val_main + "$$";

			appendStr = "<table id='soletojoint' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th>Select</th><th>CIF Number</th><th>Name</th><th>Mode of Operation</th></tr>";

			outputXml = outputXml + "~" + appendStr + soletojoint + "</table>";
		}

		return (outputXml + "^^^" + val_main + ":;:" + acc_list_str);
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           To call account_summary message request

//***********************************************************************************//	
	function getAccSummary(cif_type, cif_id) {
		var xmlDoc;
		var x;
		var xLen;
		var user_name = '<%=customSession.getUserName()%>';
		var wi_name = '<%=WINAME%>';
		var request_type = "ACCOUNT_SUMMARY";
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "/CU/CustomForms/CU_Specific/CUIntegration.jsp";

		var param = "request_type=" + request_type + "&cif_type=" + cif_type + "&wi_name=" + wi_name + "&cif_id=" + cif_id + "&user_name=" + user_name;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);

		if (xhr.status == 200 && xhr.readyState == 4) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in getting Account Summary.");
				return false;
			}
			ajaxResult=account_post_call(ajaxResult);
			var data = ajaxResult.split("^^^");
			var res = data[0].split("~");
			document.getElementById("signatureUpdate_details").innerHTML = res[0];
			document.getElementById("dormancyactivation_details").innerHTML = res[1];
			document.getElementById("soletojoint_details").innerHTML = res[3];
			document.getElementById("jointtosole_details").innerHTML = res[2];

			res = data[1].split("$$");

			document.getElementById("signature_update").value = res[0];
			document.getElementById("dormancy_activation").value = res[1];
			document.getElementById("joint_to_sole").value = res[2];
			document.getElementById("sole_to_joint").value = res[3];
			var acc_num_new = ajaxResult.split(":;:");
			if (acc_num_new.length > 1) {
				document.getElementById("wdesk:Acc_Number_received").value = acc_num_new[1];
			}

		} else {
			alert("Problem in getting getAccSummary.");
			return false;
		}

		return true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           To get grid data

//***********************************************************************************//
	function getGridData(cif_type) {
		var xmlDoc;
		var x;
		var xLen;
		var wi_name = '<%=WINAME%>';
		var request_type = "ACCOUNT_SUMMARY";
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "/CU/CustomForms/CU_Specific/getGridData.jsp";

		var param = "request_type=" + request_type + "&cif_type=" + cif_type + "&wi_name=" + wi_name;;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);

		if (xhr.status == 200 && xhr.readyState == 4) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in fetching account summary.");
				return false;
			}

			var res = ajaxResult.split("`");
			document.getElementById("signatureUpdate_details").innerHTML = res[0];
			document.getElementById("dormancyactivation_details").innerHTML = res[1];
			document.getElementById("soletojoint_details").innerHTML = res[2];
			document.getElementById("jointtosole_details").innerHTML = res[3];

		} else {
			alert("Problem in getting get grid data");
			return false;
		}

		return true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to disable phone banking fields

//***********************************************************************************//	
	
	function enableDisabled(WSNAME) {
		document.getElementById('wdesk:emirates_id').disabled = true;
		document.getElementById('wdesk:card_number').disabled = true;
		document.getElementById('wdesk:loan_agreement_id').disabled = true;
		document.getElementById('wdesk:rak_elite_customer').disabled = true;
		document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
		document.getElementById('wdesk:Segment').disabled = true;
		document.getElementById('wdesk:sub_segment').disabled = true;
		document.getElementById('wdesk:armName').disabled = true;
		document.getElementById('wdesk:SolId').disabled = true;
		document.getElementById('wdesk:account_number').disabled = true;
		document.getElementById('wdesk:FullName_New').disabled = true;
		document.getElementById('wdesk:DOB_new').disabled = true;
		document.getElementById('title_new').disabled = true;
		//document.getElementById('wdesk:ShortName_New').disabled = true;
		document.getElementById('ReadEmiratesID').disabled = true;
		document.getElementById('Fetch').disabled = true;
		document.getElementById('Clear').disabled = true;
		document.getElementById('wdesk:FirstName_New').disabled = true;
		document.getElementById('requiredDoc1').disabled = true;
		document.getElementById('wdesk:MiddleName_New').disabled = true;
		document.getElementById('wdesk:LastName_New').disabled = true;
		document.getElementById('gender_new').disabled = true;
		document.getElementById('wdesk:emiratesid_new').disabled = true;
		document.getElementById('wdesk:emiratesidexp_new').disabled = true;
		document.getElementById('wdesk:PassportNumber_New').disabled = true;
		document.getElementById('wdesk:passportExpDate_new').disabled = true;
		document.getElementById('wdesk:visa_new').disabled = true;
		document.getElementById('wdesk:visaExpDate_new').disabled = true;
		document.getElementById('wdesk:mother_maiden_name_new').disabled = true;
		// document.getElementById('usnatholder_new').disabled = true;
		// document.getElementById('usresi_new').disabled = true;
		// document.getElementById('usgreencardhol_new').disabled = true;
		// document.getElementById('us_tax_payer_new').disabled = true;
		document.getElementById('TypeOfRelationNew').disabled = true;
		//Added for signed date and expiry date property
		document.getElementById('wdesk:SignedDate_new').disabled = true;
		document.getElementById('wdesk:ExpiryDate_new').disabled = true;
		document.getElementById('nonResident_new').disabled = true;
		document.getElementById('USrelation_new').disabled = true;
		document.getElementById('FatcaDocNew').disabled = true;
		<!--Added By Nikita to disable fatca Reason at other queues-->
		document.getElementById('FatcaReasonNew').disabled = true;
		document.getElementById('wdesk:Oecdcity_new').disabled = true;
		document.getElementById('wdesk:Oecdcountry_new').disabled = true;
		document.getElementById('OECDUndoc_Flag_new').disabled = true;
		document.getElementById('OECDUndocreason_new').disabled = true;
		document.getElementById('wdesk:Oecdcountrytax_new').disabled = true;
		document.getElementById('wdesk:OecdTin_new').disabled = true;
		document.getElementById('OECDtinreason_new').disabled = true;
		document.getElementById('wdesk:Oecdcountrytax_new2').disabled = true;
		document.getElementById('OECDtinreason_new2').disabled = true;
		document.getElementById('wdesk:OecdTin_new2').disabled = true;
		document.getElementById('wdesk:Oecdcountrytax_new3').disabled = true;
		document.getElementById('OECDtinreason_new3').disabled = true;
		document.getElementById('wdesk:OecdTin_new3').disabled = true;
		document.getElementById('wdesk:Oecdcountrytax_new4').disabled = true;
		document.getElementById('OECDtinreason_new4').disabled = true;
		document.getElementById('wdesk:OecdTin_new4').disabled = true;
		document.getElementById('wdesk:Oecdcountrytax_new5').disabled = true;
		document.getElementById('OECDtinreason_new5').disabled = true;
		document.getElementById('wdesk:OecdTin_new5').disabled = true;
		document.getElementById('wdesk:Oecdcountrytax_new6').disabled = true;
		document.getElementById('OECDtinreason_new6').disabled = true;
		document.getElementById('wdesk:OecdTin_new6').disabled = true;
		document.getElementById('wdesk:Marsoon_new').disabled = true;
		//document.getElementById('wdesk:marsoonExpDate_new').disabled = true;
		//document.getElementById('wdesk:EMREG_new').disabled = true;
		//document.getElementById('wdesk:EMREGIssuedate_new').disabled = true;
		//document.getElementById('wdesk:EMREGExpirydate_new').disabled = true;
		
		document.getElementById('IndustrySegment_new').disabled = true;
		document.getElementById('IndustrySubSegment_new').disabled = true;
		document.getElementById('CustomerType_new').disabled = true;
		document.getElementById('DealwithCont_new').disabled = true;
		//				 document.getElementById('us_citizen_new').disabled = true;
		//			 document.getElementById('wdesk:nocnofbirth_new').disabled = true;
		document.getElementById('Generate').disabled = true;
		document.getElementById('Generate1').disabled = true;
		//alert("Value 1 "+document.getElementById('wdesk:resi_line1'));
		document.getElementById('wdesk:resi_line1').disabled = true;

		//for showing div before making their fields disable
		// document.getElementById("divCheckbox2").style.display="block";

		//alert("Value "+document.getElementById('wdesk:resi_line2'));

		document.getElementById('wdesk:resi_line2').disabled = true;
		document.getElementById('wdesk:resi_line3').disabled = true;
		document.getElementById('wdesk:resi_line4').disabled = true;
		document.getElementById('resi_restype').disabled = true;
		document.getElementById('wdesk:resi_pobox').disabled = true;
		document.getElementById('wdesk:resi_zipcode').disabled = true;
		document.getElementById('wdesk:resi_state').disabled = true;
		document.getElementById('wdesk:resi_city').disabled = true;
		// document.getElementById('resi_cntrycode').disabled = true;
		document.getElementById('wdesk:office_line1').disabled = true;
		document.getElementById('wdesk:office_line2').disabled = true;
		document.getElementById('wdesk:office_line3').disabled = true;
		document.getElementById('wdesk:office_line4').disabled = true;
		// document.getElementById('office_restype').disabled = true;
		document.getElementById('wdesk:office_pobox').disabled = true;
		document.getElementById('wdesk:office_zipcode').disabled = true;
		document.getElementById('wdesk:office_state').disabled = true;
		document.getElementById('wdesk:office_city').disabled = true;
		// document.getElementById('office_cntrycode').disabled = true;
		document.getElementById('pref_add_new').disabled = true;
		document.getElementById('wdesk:primary_emailid_new').disabled = true;
		document.getElementById('wdesk:sec_email_new').disabled = true;
		document.getElementById('E_Stmnt_regstrd_new').disabled = true;
		document.getElementById('wdesk:MobilePhone_New1').disabled = true;
		document.getElementById('wdesk:MobilePhone_New').disabled = true;
		document.getElementById('wdesk:MobilePhone_New2').disabled = true;
		document.getElementById('wdesk:sec_mob_phone_newC').disabled = true;
		document.getElementById('wdesk:sec_mob_phone_newN').disabled = true;
		document.getElementById('wdesk:sec_mob_phone_newE').disabled = true;
		document.getElementById('wdesk:homephone_newC').disabled = true;
		document.getElementById('wdesk:homephone_newN').disabled = true;
		document.getElementById('wdesk:homephone_newE').disabled = true;
		document.getElementById('wdesk:office_phn_newC').disabled = true;
		document.getElementById('wdesk:office_phn_new').disabled = true;
		document.getElementById('wdesk:office_phn_newE').disabled = true;
		document.getElementById('wdesk:fax_newC').disabled = true;
		document.getElementById('wdesk:fax_new').disabled = true;
		document.getElementById('wdesk:fax_newE').disabled = true;
		document.getElementById('wdesk:homecntryphone_newC').disabled = true;
		document.getElementById('wdesk:homecntryphone_newN').disabled = true;
		document.getElementById('wdesk:homecntryphone_newE').disabled = true;
		document.getElementById('pref_contact_new').disabled = true;
		document.getElementById('emp_type_new').disabled = true;
		document.getElementById('wdesk:designation_new').disabled = true;
		document.getElementById('wdesk:comp_name_new').disabled = true;
		document.getElementById('wdesk:emp_name_new').disabled = true;
		document.getElementById('wdesk:department_new').disabled = true;
		document.getElementById('wdesk:employee_num_new').disabled = true;
		document.getElementById('occupation_new').disabled = true;
		document.getElementById('wdesk:naturebusiness_new').disabled = true;
		document.getElementById('wdesk:total_year_of_emp_new').disabled = true;
		document.getElementById('wdesk:years_of_business_new').disabled = true;
		document.getElementById('employment_status_new').disabled = true;
		document.getElementById('wdesk:date_join_curr_employer_new').disabled = true;
		document.getElementById('marrital_status_new').disabled = true;
		document.getElementById('wdesk:no_of_dependents_new').disabled = true;
		document.getElementById('country_of_res_new').disabled = true;
		document.getElementById('wdesk:wheninuae_new').disabled = true;
		// document.getElementById('wdesk:periodwithprev_emp_new').disabled = true;
		document.getElementById('abcdelig_new').disabled = true;
		document.getElementById('wdesk:Channel').disabled = true;
		document.getElementById('nation_new').disabled = true;
		document.getElementById('viewSign').disabled = true;
		document.getElementById('wdesk:office_curr_years').disabled = true;
		document.getElementById('wdesk:resi_curr_years').disabled = true;
		document.getElementById('pref_email_new').disabled = true;
		// document.getElementById('abcdelig_new').disabled = true;
		document.getElementById('wdesk:prev_organ_new').disabled =true;
		document.getElementById('wdesk:period_organ_new').disabled =true;

			
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           to show selected documents list on load.

//***********************************************************************************//	
	function showSelectedDocumnets() {
		var selectedDocs = document.getElementById("wdesk:Supporting_Docs").value;
		if (selectedDocs != '') {
			var selectedDocsList = selectedDocs.split("-");
			var select = document.getElementById("selectedList");
			for (var i = 0; i < selectedDocsList.length; i++) {

				if (selectedDocsList[i] != "undefined") {
					var option = document.createElement("option");
					option.text = selectedDocsList[i];
					option.value = selectedDocsList[i]; //Not required for Internet Explorer - why??
					select.add(option);
					listWidthAuto = true;
				}
			}
		}
		var listWidthAuto = document.getElementById("wdesk:Supporting_Docs").value;

		if (listWidthAuto == "") {
			document.getElementById("selectedList").style.Width = "75%"
		} else {
			document.getElementById("selectedList").style.Width = "auto";
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           to required documents list on load

//***********************************************************************************//	
	function showrequiredDocumnets() {

		if (document.getElementById("wdesk:Requireddoc").value != '') {
			var reqList = document.getElementById("wdesk:Requireddoc").value.split(",");
			var select = document.getElementById("requiredDoc1");
			for (var i = 0; i < reqList.length; i++) {

				if (reqList[i] != "undefined") {
					var option = document.createElement("option");
					option.text = reqList[i];
					option.value = reqList[i]; //Not required for Internet Explorer - why??
					select.add(option);
					listWidthAuto = true;
				}
			}
		}
		if (document.getElementById("requiredDoc1").value == "") {
			document.getElementById("requiredDoc1").style.Width = "75%"
		} else {
			document.getElementById("requiredDoc1").style.Width = "auto";
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :           to show form data on load

//***********************************************************************************//	
	function showDiv(WSNAME) {
		if ($("#selectedList").innerWidth() < 0) {
			document.getElementById("selectedList").style.Width = "220px";
		}
		if ($("#documentList").innerWidth() < 0) {
			document.getElementById("selectedList").style.Width = "220px";
		}
		showSelectedDocumnets();
		showrequiredDocumnets();
		if (WSNAME != 'PBO') {
			selectElement('abcdelig_new', 'wdesk:abcdelig_new');
			selectElement('gender_new', 'wdesk:gender_new');
			//	selectElement('usnatholder_new','wdesk:usnatholder_new');
			//selectElement('usresi_new','wdesk:usresi_new');
			//	selectElement('usgreencardhol_new','wdesk:usgreencardhol_new');
			//selectElement('us_tax_payer_new','wdesk:us_tax_payer_new');
			//	selectElement('us_citizen_new','wdesk:us_citizen_new');
			multiSelectElement('TypeOfRelationNew', 'wdesk:TypeOfRelation_new');
			selectElement('USrelation_new', 'wdesk:USrelation_new');
			multiSelectElement('FatcaDocNew', 'wdesk:FatcaDoc_new');
			<!--Added By Nikita to set multiselect property for fatcareason-->
			multiSelectElement('FatcaReasonNew','wdesk:FatcaReason_new');
			selectElement('IndustrySegment_new', 'wdesk:IndustrySegment_new');
			selectElement('IndustrySubSegment_new', 'wdesk:IndustrySubSegment_new');
			selectElement('CustomerType_new', 'wdesk:CustomerType_new');
			selectElement('DealwithCont_new', 'wdesk:DealwithCont_new');
			selectElement('nonResident_new', 'wdesk:nonResident_new');
			selectElement('E_Stmnt_regstrd_new', 'wdesk:E_Stmnt_regstrd_new');
			selectElement('emp_type_new', 'wdesk:emp_type_new');
			selectElement('employment_status_new', 'wdesk:employment_status_new');
			selectElement('marrital_status_new', 'wdesk:marrital_status_new');
			selectElement('occupation_new', 'wdesk:occupation_new');
			selectElement('country_of_res_new','wdesk:country_of_res_new');
			selectElement('pref_contact_new', 'wdesk:pref_contact_new');
			selectElement('pref_add_new', 'wdesk:pref_add_new');
			selectElement('title_new', 'wdesk:title_new');
			selectElement('resi_restype', 'wdesk:resi_restype');
			selectElement('resi_cntrycode', 'wdesk:resi_cntrycode');
			selectElement('office_restype', 'wdesk:office_restype');
			selectElement('nation_new', 'wdesk:nation_new');
			selectElement('office_cntrycode', 'wdesk:office_cntrycode');
			selectElement('pref_email_new', 'wdesk:pref_email_new');
			selectElement('OECDUndoc_Flag_new', 'wdesk:OECDUndoc_Flag_new');
			selectElement('OECDUndocreason_new', 'wdesk:OECDUndocreason_new');
			selectElement('OECDtinreason_new', 'wdesk:OECDtinreason_new');
			selectElement('OECDtinreason_new2', 'wdesk:OECDtinreason_new2');
			selectElement('OECDtinreason_new3', 'wdesk:OECDtinreason_new3');
			selectElement('OECDtinreason_new4', 'wdesk:OECDtinreason_new4');
			selectElement('OECDtinreason_new5', 'wdesk:OECDtinreason_new5');
			selectElement('OECDtinreason_new6', 'wdesk:OECDtinreason_new6');
			//added by stutee.mishra regarding POD and PL changes.
			//if(document.getElementById('wdesk:prefOfLanguage').value == "")
				//document.getElementById('wdesk:prefOfLanguage').value = "ENGLISH"
			//if(document.getElementById('wdesk:peopleOfDeterm').value == "")
				//document.getElementById('wdesk:peopleOfDeterm').value = "No"
			selectElement('prefOfLanguage', 'wdesk:prefOfLanguage');
			selectElement('peopleOfDeterm', 'wdesk:peopleOfDeterm');
			//Saved PODOptions handling on load
			if(document.getElementById('wdesk:PODOptions').value != ""){
				var savedPODOptions = document.getElementById('wdesk:PODOptions').value.split("|");
				var a=0;
				for(var j=0;j<savedPODOptions.length;j++)
				{
					var finalist=document.getElementById('PODOptionsSeleceted');
					var value = "";
						//var name = savedPODOptions[j]
						if(savedPODOptions[j] == 'HEAR'){
							value = 'Hearing';
						}else if(savedPODOptions[j] == 'COGN'){
							value = 'Cognitive';
						}else if(savedPODOptions[j] == ("NEUR")){
							value = 'Neurological';
						}else if(savedPODOptions[j] == 'PHYS'){
							value = 'Physical';
						}else if(savedPODOptions[j] == 'SPCH'){
							value = 'Speech';
						}else if(savedPODOptions[j] == 'VISL'){
							value = 'Visual';
						}else if(savedPODOptions[j] == 'OTHR'){
							value = 'Others';
						}
						
						//var value = savedPODOptions[j];
						if(finalist.options.length!=0)
						{
							for(var i=0;i<finalist.options.length;i++)
							{
								//alert(finalist.options[i].value);
								if(finalist.options[i].value==value)
								{		
									alert(value+'POD option is already there');
									a=1;
									break;
								}
							}
							if(a!=1)
							{
								var opt = document.createElement("option");
								opt.text = value;
								opt.value =value;
								finalist.options.add(opt);	
							}
							
						}
						else
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);
						}
					
				 }
			}
			
			//selectElement('PODOptionsSeleceted', 'wdesk:PODOptions');
			//end.
		
		}
		if ((WSNAME == "CSO" || WSNAME == "CSO_Rejects") && (document.getElementById('wdesk:isWMSMECase').value == null || document.getElementById('wdesk:isWMSMECase').value == "")) {
			document.getElementById('wdesk:rak_elite_customer').disabled = true;
			document.getElementById('wdesk:Segment').disabled = true;
			document.getElementById('wdesk:SolId').disabled = true;
			document.getElementById('wdesk:Channel').value = "Customer Initiated";
			document.getElementById('wdesk:Channel').disabled = true;
			document.getElementById('wdesk:sub_segment').disabled = true;
			document.getElementById('wdesk:armName').disabled = true;
			document.getElementById('prefOfLanguage').disabled = false;
			document.getElementById('peopleOfDeterm').disabled = false;
			document.getElementById('PODOptions').disabled = true;
			document.getElementById('addButtonPODOptions').disabled = true;
			document.getElementById('removeButtonPODOptions').disabled = true;
			document.getElementById('PODOptionsSeleceted').disabled = true;
			document.getElementById('wdesk:PODRemarks').disabled = true;
			// Start - EnableDisable FatcaField based on USRelation added on 27092017
			EnableDisableFieldChange('USRelation');
			EnableDisableFieldChange('OECDUndoc_Flag');
			// End - EnableDisable FatcaField based on USRelation added on 27092017
			
		} else if (WSNAME == "CSO" || WSNAME == "CSO_Rejects") {

			document.getElementById('prefOfLanguage').disabled = false;
			document.getElementById('peopleOfDeterm').disabled = false;
			document.getElementById('PODOptions').disabled = true;
			document.getElementById('addButtonPODOptions').disabled = true;
			document.getElementById('removeButtonPODOptions').disabled = true;
			document.getElementById('PODOptionsSeleceted').disabled = true;
			document.getElementById('wdesk:PODRemarks').disabled = true;
			document.getElementById('wdesk:Channel').disabled = true;
			document.getElementById('Fetch').disabled = false;
			document.getElementById('wdesk:emirates_id').disabled = true;
			document.getElementById('wdesk:card_number').disabled = true;
			document.getElementById('wdesk:loan_agreement_id').disabled = true;
			document.getElementById('wdesk:rak_elite_customer').disabled = true;
			document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
			document.getElementById('wdesk:Segment').disabled = true;
			document.getElementById('wdesk:sub_segment').disabled = true;
			document.getElementById('wdesk:armName').disabled = true;
			document.getElementById('wdesk:SolId').disabled = true;
			document.getElementById('wdesk:account_number').disabled = true;
			document.getElementById('wdesk:FullName_New').disabled = true;
			document.getElementById('title_new').disabled = true;
			//document.getElementById('wdesk:ShortName_New').disabled = true;
			document.getElementById('ReadEmiratesID').disabled = true;
			document.getElementById('Clear').disabled = false;
			document.getElementById('wdesk:FirstName_New').disabled = true;
			document.getElementById('requiredDoc1').disabled = true;
			document.getElementById('wdesk:MiddleName_New').disabled = true;
			document.getElementById('wdesk:LastName_New').disabled = true;
			document.getElementById('gender_new').disabled = true;
			document.getElementById('wdesk:emiratesid_new').disabled = true;
			document.getElementById('wdesk:emiratesidexp_new').disabled = true;
			document.getElementById('wdesk:PassportNumber_New').disabled = true;
			document.getElementById('wdesk:passportExpDate_new').disabled = true;
			document.getElementById('wdesk:visa_new').disabled = true;
			document.getElementById('wdesk:visaExpDate_new').disabled = true;
			document.getElementById('wdesk:mother_maiden_name_new').disabled = true;
			//document.getElementById('usnatholder_new').disabled = true;
			//document.getElementById('usresi_new').disabled = true;
			//document.getElementById('usgreencardhol_new').disabled = true;
			//document.getElementById('us_tax_payer_new').disabled = true;
			//document.getElementById('us_citizen_new').disabled = true;
			//document.getElementById('wdesk:nocnofbirth_new').disabled = true;
			document.getElementById('IndustrySubSegment_new').disabled = true;
			document.getElementById('IndustrySegment_new').disabled = true;
			document.getElementById('CustomerType_new').disabled = true;
			document.getElementById('DealwithCont_new').disabled = true;
			document.getElementById('TypeOfRelationNew').disabled = true;
			document.getElementById('nonResident_new').disabled = true;
			document.getElementById('USrelation_new').disabled = true;
			document.getElementById('FatcaDocNew').disabled = true;
			<!--Added By Nikita disable fatcareason for RM initiated cases-->
			document.getElementById('FatcaReasonNew').disabled = true;
			document.getElementById('wdesk:Oecdcity_new').disabled = true;
			document.getElementById('wdesk:Oecdcountry_new').disabled = true;
			document.getElementById('OECDUndoc_Flag_new').disabled = true;
			document.getElementById('OECDUndocreason_new').disabled = true;
			document.getElementById('wdesk:Oecdcountrytax_new').disabled = true;
			document.getElementById('wdesk:OecdTin_new').disabled = true;
			document.getElementById('OECDtinreason_new').disabled = true;
			document.getElementById('wdesk:Oecdcountrytax_new2').disabled = true;
			document.getElementById('OECDtinreason_new2').disabled = true;
			document.getElementById('wdesk:OecdTin_new2').disabled = true;
			document.getElementById('wdesk:Oecdcountrytax_new3').disabled = true;
			document.getElementById('OECDtinreason_new3').disabled = true;
			document.getElementById('wdesk:OecdTin_new3').disabled = true;
			document.getElementById('wdesk:Oecdcountrytax_new4').disabled = true;
			document.getElementById('OECDtinreason_new4').disabled = true;
			document.getElementById('wdesk:OecdTin_new4').disabled = true;
			document.getElementById('wdesk:Oecdcountrytax_new5').disabled = true;
			document.getElementById('OECDtinreason_new5').disabled = true;
			document.getElementById('wdesk:OecdTin_new5').disabled = true;
			document.getElementById('wdesk:Oecdcountrytax_new6').disabled = true;
			document.getElementById('OECDtinreason_new6').disabled = true;
			document.getElementById('wdesk:OecdTin_new6').disabled = true;
			document.getElementById('wdesk:Marsoon_new').disabled = true;
			//document.getElementById('wdesk:marsoonExpDate_new').disabled = true;
			//document.getElementById('wdesk:EMREG_new').disabled = true;
			//document.getElementById('wdesk:EMREGIssuedate_new').disabled = true;
			//document.getElementById('wdesk:EMREGExpirydate_new').disabled = true;
			//Added for signed date and expiry date property
			document.getElementById('wdesk:SignedDate_new').disabled = true;
			document.getElementById('wdesk:ExpiryDate_new').disabled = true;
			document.getElementById('Generate').disabled = true;
			document.getElementById('Generate1').disabled = true;
			document.getElementById('wdesk:resi_line1').disabled = true;
			document.getElementById('wdesk:resi_line2').disabled = true;
			document.getElementById('wdesk:resi_line3').disabled = true;
			document.getElementById('wdesk:resi_line4').disabled = true;
			document.getElementById('resi_restype').disabled = true;
			document.getElementById('wdesk:resi_pobox').disabled = true;
			document.getElementById('wdesk:resi_zipcode').disabled = true;
			document.getElementById('wdesk:resi_state').disabled = true;
			document.getElementById('wdesk:resi_city').disabled = true;
			document.getElementById('resi_cntrycode').disabled = true;
			document.getElementById('wdesk:office_line1').disabled = true;
			document.getElementById('wdesk:office_line2').disabled = true;
			document.getElementById('wdesk:office_line3').disabled = true;
			document.getElementById('wdesk:office_line4').disabled = true;
			document.getElementById('office_restype').disabled = true;
			document.getElementById('wdesk:office_pobox').disabled = true;
			document.getElementById('wdesk:office_zipcode').disabled = true;
			document.getElementById('wdesk:office_state').disabled = true;
			document.getElementById('wdesk:office_city').disabled = true;
			document.getElementById('office_cntrycode').disabled = true;
			document.getElementById('pref_add_new').disabled = true;
			document.getElementById('wdesk:primary_emailid_new').disabled = true;
			document.getElementById('wdesk:sec_email_new').disabled = true;
			document.getElementById('E_Stmnt_regstrd_new').disabled = true;
			document.getElementById('wdesk:MobilePhone_New1').disabled = true;
			document.getElementById('wdesk:MobilePhone_New').disabled = true;
			document.getElementById('wdesk:MobilePhone_New2').disabled = true;
			document.getElementById('wdesk:sec_mob_phone_newC').disabled = true;
			document.getElementById('wdesk:sec_mob_phone_newN').disabled = true;
			document.getElementById('wdesk:sec_mob_phone_newE').disabled = true;
			document.getElementById('wdesk:homephone_newC').disabled = true;
			document.getElementById('wdesk:homephone_newN').disabled = true;
			document.getElementById('wdesk:homephone_newE').disabled = true;
			document.getElementById('wdesk:office_phn_newC').disabled = true;
			document.getElementById('wdesk:office_phn_new').disabled = true;
			document.getElementById('wdesk:office_phn_newE').disabled = true;
			document.getElementById('wdesk:fax_newC').disabled = true;
			document.getElementById('wdesk:fax_new').disabled = true;
			document.getElementById('wdesk:fax_newE').disabled = true;
			document.getElementById('wdesk:homecntryphone_newC').disabled = true;
			document.getElementById('wdesk:homecntryphone_newN').disabled = true;
			document.getElementById('wdesk:homecntryphone_newE').disabled = true;
			document.getElementById('pref_contact_new').disabled = true;
			document.getElementById('emp_type_new').disabled = true;
			document.getElementById('wdesk:designation_new').disabled = true;
			document.getElementById('wdesk:comp_name_new').disabled = true;
			document.getElementById('wdesk:emp_name_new').disabled = true;
			document.getElementById('wdesk:department_new').disabled = true;
			document.getElementById('wdesk:employee_num_new').disabled = true;
			document.getElementById('occupation_new').disabled = true;
			document.getElementById('wdesk:naturebusiness_new').disabled = true;
			document.getElementById('wdesk:total_year_of_emp_new').disabled = true;
			document.getElementById('wdesk:years_of_business_new').disabled = true;
			document.getElementById('employment_status_new').disabled = true;
			document.getElementById('wdesk:date_join_curr_employer_new').disabled = true;
			document.getElementById('marrital_status_new').disabled = true;
			document.getElementById('wdesk:no_of_dependents_new').disabled = true;
			document.getElementById('country_of_res_new').disabled = true;
			document.getElementById('wdesk:wheninuae_new').disabled = true;

			document.getElementById('abcdelig_new').disabled = true;
			document.getElementById('nation_new').disabled = true;
			document.getElementById('viewSign').disabled = false;
			document.getElementById('wdesk:office_curr_years').disabled = true;
			document.getElementById('wdesk:resi_curr_years').disabled = true;
			document.getElementById('pref_email_new').disabled = true;
			document.getElementById('wdesk:prev_organ_new').disabled = true;
			document.getElementById('wdesk:period_organ_new').disabled = true;
			document.getElementById('documentList').disabled = true;
			document.getElementById('addButton').disabled = true;
			document.getElementById('removeButton').disabled = true;
			document.getElementById('selectedList').disabled = true;
			
		}
		else {
			enableDisabled(WSNAME);
			if (WSNAME == "PBO_Rejects") {
				document.getElementById('Workstep').disabled = true;
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:emirates_id').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:auto_loan').disabled = true;
				document.getElementById('wdesk:personal_loan').disabled = true;
				document.getElementById('wdesk:m_loan').disabled = true;
				document.getElementById('wdesk:RF_loan').disabled = true;
				document.getElementById('wdesk:cards').disabled = true;
				document.getElementById('wdesk:In_Pro').disabled = true;
				document.getElementById('wdesk:trade_fin').disabled = true;
				document.getElementById('politically_exposed').disabled = true;
				document.getElementById('non_cash_in').disabled = true;
				document.getElementById('totally_month_credits_amount').disabled = true;
				document.getElementById('total_in').disabled = true;
				document.getElementById('cash_amount').disabled = true;
				document.getElementById('cash_in').disabled = true;
				document.getElementById('total_amount').disabled = true;
				document.getElementById('total_in2').disabled = true;
				document.getElementById('non_cash_amount').disabled = true;
				document.getElementById('Generate').disabled = true;
				document.getElementById('Generate1').disabled = true;
				document.getElementById('marrital_status_new').disabled = true;
				document.getElementById('occupation_new').disabled = true;
				document.getElementById('resi_cntrycode').disabled = true;
				document.getElementById('office_restype').disabled = true;
				document.getElementById('office_cntrycode').disabled = true;
				document.getElementById('wdesk:prev_organ_new').disabled = true;
				document.getElementById('wdesk:period_organ_new').disabled = true;
				//document.getElementById('wdesk:passport_record').disabled =true;
				//document.getElementById('wdesk:emirates_id_record').disabled =true;
				// document.getElementById('wdesk:labourcard_record').disabled =true;
				// document.getElementById('wdesk:family_book_record').disabled =true;
				//document.getElementById('wdesk:employmnt_cert_record').disabled =true;
				// document.getElementById('wdesk:salary_transfer_letter_record').disabled =true;
			} else if (WSNAME == "CSO_Doc_Scan") {
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:account_number').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:FullName_New').disabled = true;
				document.getElementById('wdesk:title_new').disabled = true;
				//document.getElementById('wdesk:ShortName_New').disabled = true;
				document.getElementById('wdesk:card_number').disabled = true;
				document.getElementById('wdesk:loan_agreement_id').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
				document.getElementById('wdesk:emirates_id').disabled = true;
				document.getElementById('totally_month_credits_amount').disabled = true;
				document.getElementById('cash_amount').disabled = true;
				document.getElementById('cash_in').disabled = true;
				document.getElementById('non_cash_amount').disabled = true;
				document.getElementById('total_amount').disabled = true;
				document.getElementById('non_cash_in').disabled = true;
				document.getElementById('total_in2').disabled = true;
				document.getElementById('politically_exposed').disabled = true;
				document.getElementById('total_in').disabled = true;
				//document.getElementById('wdesk:passport_record').disabled = true;
				//document.getElementById('wdesk:emirates_id_record').disabled = true;
				// document.getElementById('wdesk:labourcard_record').disabled = true;
				// document.getElementById('wdesk:family_book_record').disabled = true;
				// document.getElementById('wdesk:KYC').disabled = true;
				// document.getElementById('wdesk:employmnt_cert_record').disabled = true;
				// document.getElementById('wdesk:salary_transfer_letter_record').disabled = true;
				document.getElementById('Generate').disabled = true;
				document.getElementById('Generate1').disabled = true;
				//document.getElementById('Generate2').disabled = true;
				//document.getElementById('Generate3').disabled = true;
				//document.getElementById('Generate4').disabled = true;
				//document.getElementById('Generate5').disabled = true;
				//document.getElementById('Generate6').disabled = true;
				//document.getElementById('Generate7').disabled = true;
				//document.getElementById('Generate8').disabled = true;
				document.getElementById('wdesk:auto_loan').disabled = true;
				document.getElementById('wdesk:personal_loan').disabled = true;
				document.getElementById('wdesk:m_loan').disabled = true;
				document.getElementById('wdesk:RF_loan').disabled = true;
				document.getElementById('wdesk:cards').disabled = true;
				document.getElementById('wdesk:In_Pro').disabled = true;
				document.getElementById('wdesk:trade_fin').disabled = true;
				document.getElementById('nation_new').disabled = true;
				document.getElementById('wdesk:prev_organ_new').disabled = true;
				document.getElementById('wdesk:period_organ_new').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('viewSign').disabled = true;
				document.getElementById('marrital_status_new').disabled = true;
				document.getElementById('occupation_new').disabled = true;
				document.getElementById('resi_cntrycode').disabled = true;
				document.getElementById('office_restype').disabled = true;
				document.getElementById('office_cntrycode').disabled = true;
				document.getElementById('wdesk:office_curr_years').disabled = true;
				document.getElementById('wdesk:resi_curr_years').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('btnRejReason').disabled = true;
				document.getElementById('wdesk:remarks').disabled = true;
				//document.getElementById('dec_history').disabled = true;
				document.getElementById('documentList').disabled = true;
				document.getElementById('addButton').disabled = true;
				document.getElementById('removeButton').disabled = true;
				document.getElementById('selectedList').disabled = true;
					
			} else if (WSNAME == "Reject") {
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:account_number').disabled = true;
				document.getElementById('wdesk:FullName_New').disabled = true;
				document.getElementById('wdesk:title_new').disabled = true;
				//document.getElementById('wdesk:ShortName_New').disabled = true;
				document.getElementById('wdesk:card_number').disabled = true;
				document.getElementById('wdesk:loan_agreement_id').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
				document.getElementById('wdesk:emirates_id').disabled = true;
				document.getElementById('totally_month_credits_amount').disabled = true;
				document.getElementById('cash_amount').disabled = true;
				document.getElementById('cash_in').disabled = true;
				document.getElementById('non_cash_amount').disabled = true;
				document.getElementById('total_amount').disabled = true;
				document.getElementById('non_cash_in').disabled = true;
				document.getElementById('total_in2').disabled = true;
				document.getElementById('politically_exposed').disabled = true;
				document.getElementById('total_in').disabled = true;
				//document.getElementById('wdesk:passport_record').disabled = true;
				//document.getElementById('wdesk:emirates_id_record').disabled = true;
				// document.getElementById('wdesk:labourcard_record').disabled = true;
				// document.getElementById('wdesk:family_book_record').disabled = true;
				// document.getElementById('wdesk:KYC').disabled = true;
				// document.getElementById('wdesk:employmnt_cert_record').disabled = true;
				// document.getElementById('wdesk:salary_transfer_letter_record').disabled = true;
				document.getElementById('Generate').disabled = true;
				document.getElementById('Generate1').disabled = true;
				document.getElementById('Generate2').disabled = true;
				document.getElementById('Generate3').disabled = true;
				document.getElementById('Generate4').disabled = true;
				document.getElementById('Generate5').disabled = true;
				document.getElementById('Generate6').disabled = true;
				document.getElementById('Generate7').disabled = true;
				document.getElementById('Generate8').disabled = true;
				document.getElementById('wdesk:auto_loan').disabled = true;
				document.getElementById('wdesk:personal_loan').disabled = true;
				document.getElementById('wdesk:m_loan').disabled = true;
				document.getElementById('wdesk:RF_loan').disabled = true;
				document.getElementById('wdesk:cards').disabled = true;
				document.getElementById('wdesk:In_Pro').disabled = true;
				document.getElementById('wdesk:trade_fin').disabled = true;
				document.getElementById('nation_new').disabled = true;
				document.getElementById('wdesk:prev_organ_new').disabled = true;
				document.getElementById('wdesk:period_organ_new').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('viewSign').disabled = true;
				document.getElementById('marrital_status_new').disabled = true;
				document.getElementById('occupation_new').disabled = true;
				document.getElementById('resi_cntrycode').disabled = true;
				document.getElementById('office_restype').disabled = true;
				document.getElementById('office_cntrycode').disabled = true;
				document.getElementById('decision').disabled = true;
				document.getElementById('wdesk:office_curr_years').disabled = true;
				document.getElementById('wdesk:resi_curr_years').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('btnRejReason').disabled = true;
				document.getElementById('wdesk:remarks').disabled = true;

			} else if (WSNAME == "OPS%20Maker_DE") {
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				//document.getElementById('title_New').disabled = false;
				document.getElementById('wdesk:FirstName_New').disabled = false;
				document.getElementById('wdesk:MiddleName_New').disabled = false;
				document.getElementById('wdesk:LastName_New').disabled = false;
				document.getElementById('gender_new').disabled = false;
				document.getElementById('wdesk:emiratesid_new').disabled = false;
				document.getElementById('wdesk:emiratesidexp_new').disabled = false;
				document.getElementById('wdesk:PassportNumber_New').disabled = false;
				document.getElementById('wdesk:passportExpDate_new').disabled = false;
				document.getElementById('wdesk:visa_new').disabled = false;
				document.getElementById('wdesk:visaExpDate_new').disabled = false;
				document.getElementById('wdesk:mother_maiden_name_new').disabled = false;
				document.getElementById('TypeOfRelationNew').disabled = false;
				document.getElementById('nonResident_new').disabled = false;
				document.getElementById('USrelation_new').disabled = false;
				document.getElementById('FatcaDocNew').disabled = false;
				<!--Added By Nikita enable fatcareason for OPS%20Maker_DE-->
				document.getElementById('FatcaReasonNew').disabled = false;
				document.getElementById('wdesk:Oecdcity_new').disabled = false;
				document.getElementById('wdesk:Oecdcountry_new').disabled = false;
				document.getElementById('OECDUndoc_Flag_new').disabled = false;
				document.getElementById('OECDUndocreason_new').disabled = false;
				document.getElementById('wdesk:Oecdcountrytax_new').disabled = false;
				document.getElementById('wdesk:OecdTin_new').disabled = false;
				document.getElementById('OECDtinreason_new').disabled = false;
				document.getElementById('wdesk:Oecdcountrytax_new2').disabled = false;
				document.getElementById('OECDtinreason_new2').disabled = false;
				document.getElementById('wdesk:OecdTin_new2').disabled = false;
				document.getElementById('wdesk:Oecdcountrytax_new3').disabled = false;
				document.getElementById('OECDtinreason_new3').disabled = false;
				document.getElementById('wdesk:OecdTin_new3').disabled = false;
				document.getElementById('wdesk:Oecdcountrytax_new4').disabled = false;
				document.getElementById('OECDtinreason_new4').disabled = false;
				document.getElementById('wdesk:OecdTin_new4').disabled = false;
				document.getElementById('wdesk:Oecdcountrytax_new5').disabled = false;
				document.getElementById('OECDtinreason_new5').disabled = false;
				document.getElementById('wdesk:OecdTin_new5').disabled = false;
				document.getElementById('wdesk:Oecdcountrytax_new6').disabled = false;
				document.getElementById('OECDtinreason_new6').disabled = false;
				document.getElementById('wdesk:OecdTin_new6').disabled = false;
				document.getElementById('wdesk:Marsoon_new').disabled = false;
				//document.getElementById('wdesk:marsoonExpDate_new').disabled = false;
				//document.getElementById('wdesk:EMREG_new').disabled = false;
				//document.getElementById('wdesk:EMREGIssuedate_new').disabled = false;
				//document.getElementById('wdesk:EMREGExpirydate_new').disabled = false;
				//Added for signed date and expiry date property
				document.getElementById('wdesk:SignedDate_new').disabled = false;
				//document.getElementById('wdesk:ExpiryDate_new').disabled = false;
				document.getElementById('IndustrySegment_new').disabled = false;
				document.getElementById('IndustrySubSegment_new').disabled = false;
				document.getElementById('CustomerType_new').disabled = false;
				document.getElementById('DealwithCont_new').disabled = false;
				//document.getElementById('usnatholder_new').disabled = false;
				//	document.getElementById('usresi_new').disabled = false;
				//document.getElementById('usgreencardhol_new').disabled = false;
				//	document.getElementById('us_tax_payer_new').disabled = false;
				//				document.getElementById('us_citizen_new').disabled = false;
				//	document.getElementById('wdesk:nocnofbirth_new').disabled = false;
				document.getElementById('Generate').disabled = false; // made editable at cso rejects on 13092018
				document.getElementById('Generate1').disabled = false; // made editable at cso rejects on 13092018
				document.getElementById('wdesk:resi_line1').disabled = false;
				document.getElementById('wdesk:resi_line2').disabled = false;
				document.getElementById('wdesk:resi_line3').disabled = false;
				document.getElementById('wdesk:resi_line4').disabled = false;
				document.getElementById('resi_restype').disabled = false;
				document.getElementById('wdesk:resi_pobox').disabled = false;
				document.getElementById('wdesk:resi_zipcode').disabled = false;
				document.getElementById('wdesk:resi_state').disabled = false;
				document.getElementById('wdesk:resi_city').disabled = false;
				document.getElementById('wdesk:resi_cntrycode').disabled = false;
				document.getElementById('wdesk:office_line1').disabled = false;
				document.getElementById('wdesk:office_line2').disabled = false;
				document.getElementById('wdesk:office_line3').disabled = false;
				document.getElementById('wdesk:office_line4').disabled = false;
				document.getElementById('wdesk:office_restype').disabled = false;
				document.getElementById('wdesk:office_pobox').disabled = false;
				document.getElementById('wdesk:office_zipcode').disabled = false;
				document.getElementById('wdesk:office_state').disabled = false;
				document.getElementById('wdesk:office_city').disabled = false;
				document.getElementById('wdesk:office_cntrycode').disabled = false;
				document.getElementById('pref_add_new').disabled = false;
				document.getElementById('wdesk:primary_emailid_new').disabled = false;
				document.getElementById('wdesk:sec_email_new').disabled = false;
				document.getElementById('E_Stmnt_regstrd_new').disabled = false;
				document.getElementById('wdesk:MobilePhone_New1').disabled = false;
				document.getElementById('wdesk:MobilePhone_New').disabled = false;
				document.getElementById('wdesk:MobilePhone_New2').disabled = false;
				document.getElementById('wdesk:sec_mob_phone_newC').disabled = false;
				document.getElementById('wdesk:sec_mob_phone_newN').disabled = false;
				document.getElementById('wdesk:sec_mob_phone_newE').disabled = false;
				document.getElementById('wdesk:homephone_newC').disabled = false;
				document.getElementById('wdesk:homephone_newN').disabled = false;
				document.getElementById('wdesk:homephone_newE').disabled = false;
				document.getElementById('wdesk:office_phn_newC').disabled = false;
				document.getElementById('wdesk:office_phn_new').disabled = false;
				document.getElementById('wdesk:office_phn_newE').disabled = false;
				document.getElementById('wdesk:fax_newC').disabled = false;
				document.getElementById('wdesk:fax_new').disabled = false;
				document.getElementById('wdesk:fax_newE').disabled = false;
				document.getElementById('wdesk:homecntryphone_newC').disabled = false;
				document.getElementById('wdesk:homecntryphone_newN').disabled = false;
				document.getElementById('wdesk:homecntryphone_newE').disabled = false;
				document.getElementById('pref_contact_new').disabled = false;
				//document.getElementById('emp_type_new').disabled = false;
				document.getElementById('wdesk:designation_new').disabled = false;
				document.getElementById('wdesk:comp_name_new').disabled = false;
				document.getElementById('wdesk:emp_name_new').disabled = false;
				document.getElementById('wdesk:department_new').disabled = false;
				document.getElementById('wdesk:employee_num_new').disabled = false;
				document.getElementById('occupation_new').disabled = false;
				document.getElementById('wdesk:naturebusiness_new').disabled = false;
				document.getElementById('wdesk:total_year_of_emp_new').disabled = false;
				document.getElementById('wdesk:years_of_business_new').disabled = false;
				document.getElementById('employment_status_new').disabled = false;
				document.getElementById('wdesk:date_join_curr_employer_new').disabled = false;
				document.getElementById('marrital_status_new').disabled = false;

				document.getElementById('wdesk:no_of_dependents_new').disabled = false;
				document.getElementById('country_of_res_new').disabled = false;
				document.getElementById('wdesk:wheninuae_new').disabled = false;
				document.getElementById('abcdelig_new').disabled = false;
				document.getElementById('nation_new').disabled = false;
				document.getElementById('viewSign').disabled = false;
				document.getElementById('wdesk:office_curr_years').disabled = false;
				document.getElementById('wdesk:resi_curr_years').disabled = false;
				document.getElementById('pref_email_new').disabled = false;
				//document.getElementById('wdesk:ShortName_New').disabled = false;
				document.getElementById('wdesk:FullName_New').disabled = false;
				document.getElementById('wdesk:title_new').disabled = false;
				document.getElementById('wdesk:prev_organ_new').disabled = false;
				document.getElementById('wdesk:period_organ_new').disabled = false;
				// Start - EnableDisable FatcaField based on USRelation added on 27092017
				EnableDisableFieldChange('USRelation');
				EnableDisableFieldChange('OECDUndoc_Flag');
			// End - EnableDisable FatcaField based on USRelation added on 27092017
			} else if (WSNAME == "OPS_Checker_Review") {
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:account_number').disabled = true;
				document.getElementById('wdesk:FullName_New').disabled = true;
				document.getElementById('wdesk:title_new').disabled = true;
				//document.getElementById('wdesk:ShortName_New').disabled = true;
				document.getElementById('wdesk:card_number').disabled = true;
				document.getElementById('wdesk:loan_agreement_id').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
				document.getElementById('wdesk:emirates_id').disabled = true;
				document.getElementById('totally_month_credits_amount').disabled = true;
				document.getElementById('cash_amount').disabled = true;
				document.getElementById('cash_in').disabled = true;
				document.getElementById('non_cash_amount').disabled = true;
				document.getElementById('total_amount').disabled = true;
				document.getElementById('non_cash_in').disabled = true;
				document.getElementById('total_in2').disabled = true;
				document.getElementById('politically_exposed').disabled = true;
				document.getElementById('total_in').disabled = true;
				/*document.getElementById('wdesk:passport_record').disabled = true;
				document.getElementById('wdesk:emirates_id_record').disabled = true;
				document.getElementById('wdesk:labourcard_record').disabled = true;
				document.getElementById('wdesk:family_book_record').disabled = true;
				document.getElementById('wdesk:KYC').disabled = true;
				document.getElementById('wdesk:employmnt_cert_record').disabled = true;
				document.getElementById('wdesk:salary_transfer_letter_record').disabled = true; */
				document.getElementById('Generate').disabled = true;
				document.getElementById('Generate1').disabled = true;
				document.getElementById('Generate2').disabled = true;
				document.getElementById('Generate3').disabled = true;
				document.getElementById('Generate4').disabled = true;
				document.getElementById('Generate5').disabled = true;
				document.getElementById('Generate6').disabled = true;
				document.getElementById('Generate7').disabled = true;
				document.getElementById('Generate8').disabled = true;
				document.getElementById('wdesk:auto_loan').disabled = true;
				document.getElementById('wdesk:personal_loan').disabled = true;
				document.getElementById('wdesk:m_loan').disabled = true;
				document.getElementById('wdesk:RF_loan').disabled = true;
				document.getElementById('wdesk:cards').disabled = true;
				document.getElementById('wdesk:In_Pro').disabled = true;
				document.getElementById('wdesk:trade_fin').disabled = true;
				document.getElementById('nation_new').disabled = true;
				document.getElementById('wdesk:prev_organ_new').disabled = true;
				document.getElementById('wdesk:period_organ_new').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('viewSign').disabled = false;
				document.getElementById('marrital_status_new').disabled = true;
				document.getElementById('resi_cntrycode').disabled = true;
				document.getElementById('office_restype').disabled = true;
				document.getElementById('office_cntrycode').disabled = true;
				document.getElementById('wdesk:office_curr_years').disabled = true;
				document.getElementById('wdesk:resi_curr_years').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				//document.getElementById('btnRejReason').disabled = true;
				//document.getElementById('wdesk:remarks').disabled = true;
				//document.getElementById('dec_history').disabled = true;
			} else if (WSNAME == "CB_WC" || WSNAME == "Crops_Approval" || WSNAME == "CB_WC_Checker_Review" || WSNAME == "CB_WC_Controls" ||
				WSNAME == "Error" || WSNAME == "Doc_Archival" || WSNAME == "Hold" || WSNAME == "PB_Credit_Approval" ||
				WSNAME == "SME_Credit_Approval" || WSNAME == "Card_Deletion" || WSNAME == "Finacle_DE_Maker" || WSNAME == "Finacle_DE_Checker" || WSNAME == "Compliance" ||
				WSNAME == "OPS%20Maker_DE" || WSNAME == "Archival_Activity" || WSNAME == "PBO_Rejects" || WSNAME == "Archival_Rejects") {
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:account_number').disabled = true;
				document.getElementById('wdesk:FullName_New').disabled = true;
				document.getElementById('wdesk:title_new').disabled = true;
				//document.getElementById('wdesk:ShortName_New').disabled = true;
				document.getElementById('wdesk:card_number').disabled = true;
				document.getElementById('wdesk:loan_agreement_id').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
				document.getElementById('wdesk:emirates_id').disabled = true;
				document.getElementById('totally_month_credits_amount').disabled = true;
				document.getElementById('cash_amount').disabled = true;
				document.getElementById('cash_in').disabled = true;
				document.getElementById('non_cash_amount').disabled = true;
				document.getElementById('total_amount').disabled = true;
				document.getElementById('non_cash_in').disabled = true;
				document.getElementById('total_in2').disabled = true;
				document.getElementById('politically_exposed').disabled = true;
				document.getElementById('total_in').disabled = true;
				//document.getElementById('wdesk:passport_record').disabled = true;
				//document.getElementById('wdesk:emirates_id_record').disabled = true;
				/* document.getElementById('wdesk:labourcard_record').disabled = true;
				 document.getElementById('wdesk:family_book_record').disabled = true;
				 document.getElementById('wdesk:KYC').disabled = true;
				 document.getElementById('wdesk:employmnt_cert_record').disabled = true;
				 document.getElementById('wdesk:salary_transfer_letter_record').disabled = true; */
				document.getElementById('Generate').disabled = true;
				document.getElementById('Generate1').disabled = true;
				document.getElementById('Generate2').disabled = true;
				document.getElementById('Generate3').disabled = true;
				document.getElementById('Generate4').disabled = true;
				document.getElementById('Generate5').disabled = true;
				document.getElementById('Generate6').disabled = true;
				document.getElementById('Generate7').disabled = true;
				document.getElementById('Generate8').disabled = true;
				document.getElementById('wdesk:auto_loan').disabled = true;
				document.getElementById('wdesk:personal_loan').disabled = true;
				document.getElementById('wdesk:m_loan').disabled = true;
				document.getElementById('wdesk:RF_loan').disabled = true;
				document.getElementById('wdesk:cards').disabled = true;
				document.getElementById('wdesk:In_Pro').disabled = true;
				document.getElementById('wdesk:trade_fin').disabled = true;
				document.getElementById('nation_new').disabled = true;
				document.getElementById('wdesk:prev_organ_new').disabled = true;
				document.getElementById('wdesk:period_organ_new').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('viewSign').disabled = true;
				if (WSNAME == "OPS%20Maker_DE")
					document.getElementById('viewSign').disabled = false;
				document.getElementById('marrital_status_new').disabled = true;
				document.getElementById('resi_cntrycode').disabled = true;
				document.getElementById('office_restype').disabled = true;
				document.getElementById('office_cntrycode').disabled = true;
				document.getElementById('wdesk:office_curr_years').disabled = true;
				document.getElementById('wdesk:resi_curr_years').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				//document.getElementById('btnRejReason').disabled = true;
				//document.getElementById('wdesk:remarks').disabled = true;
				//document.getElementById('dec_history').disabled = true;
			} else if (WSNAME == "CSM_Review") {
				document.getElementById('prefOfLanguage').disabled = true;
			    document.getElementById('peopleOfDeterm').disabled = true;
				document.getElementById('PODOptions').disabled = true;
				document.getElementById('addButtonPODOptions').disabled = true;
			    document.getElementById('removeButtonPODOptions').disabled = true;
			    document.getElementById('PODOptionsSeleceted').disabled = true;
				document.getElementById('wdesk:PODRemarks').disabled = true;
				document.getElementById('wdesk:Segment').disabled = true;
				document.getElementById('wdesk:SolId').disabled = true;
				document.getElementById('wdesk:sub_segment').disabled = true;
				document.getElementById('wdesk:armName').disabled = true;
				document.getElementById('wdesk:account_number').disabled = true;
				document.getElementById('wdesk:FullName_New').disabled = true;
				document.getElementById('wdesk:title_new').disabled = true;
				//document.getElementById('wdesk:ShortName_New').disabled = true;
				document.getElementById('wdesk:card_number').disabled = true;
				document.getElementById('wdesk:loan_agreement_id').disabled = true;
				document.getElementById('wdesk:rak_elite_customer').disabled = true;
				document.getElementById('wdesk:CIFNumber_Existing').disabled = true;
				document.getElementById('wdesk:emirates_id').disabled = true;
				document.getElementById('totally_month_credits_amount').disabled = true;
				document.getElementById('cash_amount').disabled = true;
				document.getElementById('cash_in').disabled = true;
				document.getElementById('non_cash_amount').disabled = true;
				document.getElementById('total_amount').disabled = true;
				document.getElementById('non_cash_in').disabled = true;
				document.getElementById('total_in2').disabled = true;
				document.getElementById('politically_exposed').disabled = true;
				document.getElementById('total_in').disabled = true;
				/*document.getElementById('wdesk:passport_record').disabled = true;
				document.getElementById('wdesk:emirates_id_record').disabled = true;
				document.getElementById('wdesk:labourcard_record').disabled = true;
				document.getElementById('wdesk:family_book_record').disabled = true;
				document.getElementById('wdesk:KYC').disabled = true;
				document.getElementById('wdesk:employmnt_cert_record').disabled = true;
				document.getElementById('wdesk:salary_transfer_letter_record').disabled = true; */
				document.getElementById('Generate').disabled = true;
				document.getElementById('Generate1').disabled = true;
				document.getElementById('Generate2').disabled = true;
				document.getElementById('Generate3').disabled = true;
				document.getElementById('Generate4').disabled = true;
				document.getElementById('Generate5').disabled = true;
				document.getElementById('Generate6').disabled = true;
				document.getElementById('Generate7').disabled = true;
				document.getElementById('Generate8').disabled = true;
				document.getElementById('wdesk:personal_loan').disabled = true;
				document.getElementById('nation_new').disabled = true;
				document.getElementById('wdesk:prev_organ_new').disabled = true;
				document.getElementById('wdesk:period_organ_new').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
				document.getElementById('nation_new').disabled = true;
				document.getElementById('wdesk:office_curr_years').disabled = true;
				document.getElementById('wdesk:resi_curr_years').disabled = true;
				document.getElementById('wdesk:Channel').disabled = true;
			}

			if (true) {
				div = document.getElementById('divCheckbox2');
				div.style.display = "block";
				getGridData("Individual");

			} else if (Object.value == "Non-Individual") {
				div = document.getElementById('divCheckbox2');
				div.style.display = "none";
				div = document.getElementById('divCheckbox3');
				div.style.display = "block";
			}
		}
		if((WSNAME == 'CSO' && document.getElementById('wdesk:Channel').value == 'Customer Initiated') || (WSNAME == 'OPS%20Maker_DE') || (WSNAME == "CSO_Rejects" && document.getElementById('wdesk:Channel').value == 'Customer Initiated'))
		{
			var str = "*";
			var result = str.fontcolor("red"); 
			if(document.getElementById("wdesk:PassportNumber_New").value != '' && document.getElementById("wdesk:PassportNumber_New").value != null)
			{
				document.getElementById('passexpdate').innerHTML = 'Passport Expiry Date<FONT color=red>*</FONT>';			
			}
			//commented by ankit for JIRA SCRCIF-141
			/*else
			{
				document.getElementById('passexpdate').innerHTML = 'Passport Expiry Date';
			}*/
			if(document.getElementById("wdesk:passportExpDate_new").value != "" && document.getElementById("wdesk:passportExpDate_new").value != null)
			{		
	    		document.getElementById('Passno').innerHTML = 'Passport Number<FONT color=red>*</FONT>';		
			}
			//commented by ankit for JIRA SCRCIF-141
			/*else
			{
				document.getElementById('Passno').innerHTML = 'Passport Number';
			}*/
			//commented for not to show emirates id and expiry date mandatory
			/*if(document.getElementById('wdesk:nonResident').value == "NO" &&( document.getElementById('nonResident_new').value == '--Select--' ||document.getElementById('nonResident_new').value == '' || document.getElementById('nonResident_new').value == null))
			{
					document.getElementById('emidc').innerHTML = 'Emirates ID Number<FONT color=red>*</FONT>';
					document.getElementById('EMIDexpdt').innerHTML = 'Emirates ID Expiry Date<FONT color=red>*</FONT>';	
			}
			else
			{
				document.getElementById('emidc').innerHTML = 'Emirates ID Number';
				document.getElementById('EMIDexpdt').innerHTML = 'Emirates ID Expiry Date';
			} */
			
			if((document.getElementById("wdesk:comp_name_new").value != "" && document.getElementById("wdesk:comp_name_new").value != null) || (document.getElementById("wdesk:emp_name_new").value != "" && document.getElementById("wdesk:emp_name_new").value != null) || (document.getElementById("occupation_new").value != "--Select--" && document.getElementById("occupation_new").value != null && document.getElementById("occupation_new").value != "") || (document.getElementById("wdesk:naturebusiness_new").value != "" && document.getElementById("wdesk:naturebusiness_new").value != null))
			{
				document.getElementById('Visac').innerHTML = 'Visa Number<FONT color=red>*</FONT>';
				document.getElementById('visaexp').innerHTML = 'Visa Expiry Date<FONT color=red>*</FONT>';		
			}
			//commented by ankit for JIRA SCRCIF-141
			/*else
			{
				document.getElementById('Visac').innerHTML = 'Visa Number';
				document.getElementById('visaexp').innerHTML = 'Visa Expiry Date';	
			}*/
			// code modified for reqtype  == 'address' to set mandatory address fields added by Shamily
			if(document.getElementById('pref_add_new').value == 'Home')
			{
				if(document.getElementById('wdesk:country_of_res_exis').value == 'AE')
				{
					document.getElementById('rpobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
					document.getElementById('rcity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
				//document.getElementById('rcountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
				else{
					document.getElementById('rpobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
					document.getElementById('rcity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
				}
			}
			else
			{
				document.getElementById('rpobox').innerHTML ="PO Box";
				document.getElementById('rcity').innerHTML ="Emirates/City";
				document.getElementById('rcountry').innerHTML ="Country";
			}
			// code modified for reqtype  == 'address' to set mandatory address fields added by Shamily
			if(document.getElementById('pref_add_new').value == 'Office')
			{
				if(document.getElementById('wdesk:country_of_res_exis').value == 'AE')
				{
					document.getElementById('opobox').innerHTML = 'PO Box<FONT color=red>*</FONT>';
					document.getElementById('ocity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
					document.getElementById('ocountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
				else
				{
					document.getElementById('ocity').innerHTML = 'Emirates/City<FONT color=red>*</FONT>';
					document.getElementById('ocountry').innerHTML = 'Country<FONT color=red>*</FONT>';	
				}
			}
			else
			{
				document.getElementById('ocity').innerHTML ="Emirates/City";
				document.getElementById('opobox').innerHTML ="PO Box";
				document.getElementById('ocountry').innerHTML ="Country";
			}
			if(document.getElementById('nation_new').value == 'US' || ((document.getElementById('nation_new').value == '--Select--' || document.getElementById('nation_new').value == "" || document.getElementById('nation_new').value == null ) && document.getElementById('wdesk:nation_exist').value == 'US' ))
			{			
				document.getElementById('mfatcadoc').innerHTML ='Fatca Document<FONT color=red>*</FONT>';					
			}
				else
				{
					document.getElementById('mfatcadoc').innerHTML = 'Fatca Document';
				}
			if((document.getElementById('E_Stmnt_regstrd_new').value == 'Yes') || ((document.getElementById('E_Stmnt_regstrd_new').value == '--Select--' ||document.getElementById('E_Stmnt_regstrd_new').value == '' || document.getElementById('E_Stmnt_regstrd_new').value == null ) &&  document.getElementById('wdesk:E_Stmnt_regstrd_exis').value == 'Y'))
			{
				document.getElementById('mprimarymail').innerHTML = 'Primary Email Id<FONT color=red>*</FONT>';	
			}
			else
			{
				document.getElementById('mprimarymail').innerHTML = 'Primary Email Id';
			}
			var MobilePhone_New1 = document.getElementById('wdesk:MobilePhone_New1').value;
			var sec_mob_phone_newC = document.getElementById('wdesk:sec_mob_phone_newC').value;
			var homephone_newC = document.getElementById('wdesk:homephone_newC').value;
			var office_phn_newC = document.getElementById('wdesk:office_phn_newC').value;
			var homecntryphone_newC = document.getElementById('wdesk:homecntryphone_newC').value;
			var Oecdcity_new = document.getElementById('wdesk:Oecdcity_new').value;
			var offcCountry1 = document.getElementById('offcCountry1').value;
			var office_cntrycode = document.getElementById('office_cntrycode').value;
	
		if((MobilePhone_New1 !="" && MobilePhone_New1 !=null && MobilePhone_New1 != document.getElementById('Phone1CountryCode').value) || (sec_mob_phone_newC !="" && sec_mob_phone_newC !=null && sec_mob_phone_newC != document.getElementById('Phone2CountryCode').value) || (homephone_newC !="" && homephone_newC !=null && homephone_newC != document.getElementById('HomePhoneCountryCode').value) || (office_phn_newC !="" && office_phn_newC !=null && office_phn_newC != document.getElementById('OfficePhoneCountryCode').value)|| (homecntryphone_newC !="" && homecntryphone_newC !=null && homecntryphone_newC != document.getElementById('HomeCountryPhoneCountryCode').value)|| (office_cntrycode != null && office_cntrycode != "" && office_cntrycode != "--Select--" && office_cntrycode != offcCountry1))
		{
				document.getElementById('OecdCitym').innerHTML = 'City Of Birth<FONT color=red>*</FONT>';	
				document.getElementById('CRSUndocm').innerHTML = 'CRS Undocumented Flag<FONT color=red>*</FONT>';	
			}
			else
			{
				document.getElementById('OecdCitym').innerHTML = 'City Of Birth';
				document.getElementById('CRSUndocm').innerHTML = 'CRS Undocumented Flag';	
			}
			
			if(document.getElementById('OECDUndoc_Flag_new').value =="No")
			{
				document.getElementById('OecdCntryTax1').innerHTML = 'Country Of Tax Residence 1<FONT color=red>*</FONT>';	
				
			}
			else{
				document.getElementById('OecdCntryTax1').innerHTML = 'Country Of Tax Residence 1';	
			}
			 if (  document.getElementById('OECDUndoc_Flag_new').value == "Yes")
			{
				document.getElementById('CRSUndocReasonm').innerHTML = 'CRS Undocumented Flag Reason <FONT color=red>*</FONT>';	
				
			}
			else{
				document.getElementById('CRSUndocReasonm').innerHTML = 'CRS Undocumented Flag Reason ';	
			}
			document.getElementById('OecdCntrym').innerHTML = 'Country Of Birth<FONT color=red>*</FONT>';	
			
			validateemptype();
		} 
		
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Amandeep
//Description                 :           to show multi selected values of relation types after selecting 

//***********************************************************************************//	
	

	function getValuereltype() {
		var x = document.getElementById("TypeOfRelationNew");
		var dbValue = "";
		for (var i = 0; i < x.options.length; i++) {
			if (x.options[i].selected == true) {
				if (dbValue == "")
					dbValue = x.options[i].value;
				else
					dbValue += "^" + x.options[i].value;
			}
		}
		document.getElementById("wdesk:TypeOfRelation_new").value = dbValue;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Amandeep
//Description                 :           to show multi selected values of Fatca documents after selecting 

//***********************************************************************************//
	function getValueFatcaDoc() {
		var x = document.getElementById("FatcaDocNew");
		var dbValue = "";
		for (var i = 0; i < x.options.length; i++) {
			if (x.options[i].selected == true) {
				if (dbValue == "")
					dbValue = x.options[i].value;
				else
					dbValue += "^" + x.options[i].value;
			}
		}
		document.getElementById("wdesk:FatcaDoc_new").value = dbValue;
	}
	
	
	function loopSelected()
	{
		var txtSelectedValuesObj = document.getElementById('FatcaDoc_new_doc');
		var selectedArray = new Array();
		var selObj = document.getElementById('FatcaDocNew');
		var i;
		var count = 0;
		var reqdoc = document.getElementById("wdesk:Requireddoc").value;
		for (i=0; i<selObj.options.length; i++) {
			if (selObj.options[i].selected) {
			selectedArray[count] = selObj.options[i].innerHTML;
			count++;
			}
		}
		txtSelectedValuesObj.value = selectedArray;
	}	
	
	function getValueFatcaReason() {
		var x = document.getElementById("FatcaReasonNew");
		var dbValue = "";
		for (var i = 0; i < x.options.length; i++) {
			if (x.options[i].selected == true) {
				if (dbValue == "")
					dbValue = x.options[i].value;
				else
					dbValue += "^" + x.options[i].value;
			}
		}
		document.getElementById("wdesk:FatcaReason_new").value = dbValue;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           to disable profile fields on load

//***********************************************************************************//
	function disableProfileFields() {

		document.getElementById("title_new").disabled = true;
		document.getElementById("wdesk:FirstName_New").disabled = true;
		document.getElementById("wdesk:MiddleName_New").disabled = true;
		document.getElementById("wdesk:LastName_New").disabled = true;
		document.getElementById("wdesk:FullName_New").disabled = true;
		//added by shamily Dec CR to disable gender field
		document.getElementById('gender_new').disabled = true;
		document.getElementById("nation_new").disabled = true;
		document.getElementById("country_of_res_new").disabled=true;
		document.getElementById("resi_cntrycode").disabled=true;
		document.getElementById("wdesk:DOB_new").disabled = true;
		document.getElementById("requiredDoc1").disabled = true;
		document.getElementById("nonResident_new").disabled=true;
		
		document.getElementById("wdesk:naturebusiness_new").disabled=true;
		document.getElementById("IndustrySegment_new").disabled=true;
		document.getElementById("IndustrySubSegment_new").disabled=true;
		document.getElementById("CustomerType_new").disabled=true;
		document.getElementById("DealwithCont_new").disabled=true;
		document.getElementById("wdesk:MobilePhone_New").disabled=true;
		document.getElementById("wdesk:sec_mob_phone_newN").disabled=true;
		document.getElementById("wdesk:homephone_newN").disabled=true;
		document.getElementById("wdesk:office_phn_new").disabled=true;
		document.getElementById("wdesk:fax_new").disabled=true;
		document.getElementById("wdesk:homecntryphone_newN").disabled=true;
		//document.getElementById("wdesk:EMREGExpirydate_new").disabled=true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           to clear fields on clicking on clear button

//***********************************************************************************//
	function ClearFields() {
	
		document.getElementById("Fetch").disabled = false;
		document.getElementById('ReadEmiratesID').disabled = false;
		document.getElementById("wdesk:CIFNumber_Existing").disabled = false;
		document.getElementById("wdesk:account_number").disabled = false;
		document.getElementById("wdesk:loan_agreement_id").disabled = false;
		document.getElementById("wdesk:card_number").disabled = false;
		document.getElementById("wdesk:emirates_id").disabled = false;

		document.getElementById("wdesk:account_number").value = "";
		document.getElementById("wdesk:card_number").value = "";
		document.getElementById("wdesk:emirates_id").value = "";
		
		//Below line Changed by Amandeep on 18 11 2016 from CIFNumber_existing to CIFNumber_Existing
		document.getElementById("wdesk:CIFNumber_Existing").value = "";
		
		//Below lines added by Amandeep on 18 11 2016 from CIFNumber_existing to CIFNumber_Existing
		document.getElementById("wdesk:armName").value = "";		
		document.getElementById("radiaoCheck").value="N";
		
		document.getElementById("wdesk:loan_agreement_id").value = "";
		document.getElementById('wdesk:rak_elite_customer').value = "";
		document.getElementById('wdesk:Segment').value = "";
		document.getElementById('wdesk:sub_segment').value = "";

		document.getElementById('emirates_id').value = "";
		document.getElementById('wdesk:title_exis').value = "";
		document.getElementById('wdesk:gender_exit').value = "";
		document.getElementById('wdesk:pref_email_exis').value = "";
		document.getElementById('wdesk:FirstName_Existing').value = "";
		document.getElementById('wdesk:MiddleName_Existing').value = "";
		document.getElementById('wdesk:LastName_Existing').value = "";
		document.getElementById('wdesk:FullName_Existing').value = "";
		//document.getElementById('wdesk:ShortName_Existing').value=""; 
		document.getElementById('wdesk:emiratesidexp_exis').value = "";
		document.getElementById('wdesk:PassportNumber_Existing').value = "";
		document.getElementById('wdesk:passportExpDate_exis').value = "";
		document.getElementById('wdesk:visa_exis').value = "";
		document.getElementById('wdesk:visaExpDate_exis').value = "";
		document.getElementById('wdesk:mother_maiden_name_exis').value = "";
		document.getElementById('wdesk:DOB_exis').value = "";
		document.getElementById('wdesk:nonResident').value = "";
		document.getElementById('wdesk:USrelation').value = "";
		document.getElementById('wdesk:IndustrySegment_exis').value = "";
		document.getElementById('wdesk:IndustrySubSegment_exis').value = "";
		document.getElementById('wdesk:CustomerType_exis').value = "";
		//document.getElementById('wdesk:usnatholder_exis').value=""; 
		//document.getElementById('wdesk:usresi_exis').value=""; 
		//document.getElementById('wdesk:usgreencardhol_exis').value=""; 
		//document.getElementById('wdesk:us_tax_payer_exis').value=""; 
		//				document.getElementById('wdesk:us_citizen_exis').value="";                          
		//	document.getElementById('wdesk:nocnofbirth_exis').value=""; 
		document.getElementById('wdesk:abcdelig_exis').value = "";
		document.getElementById('resiadd_exis').value = "";
		document.getElementById('office_add_exis').value = "";
		document.getElementById('wdesk:pref_add_exis').value = "";
		document.getElementById('wdesk:prim_email_exis').value = "";
		document.getElementById('wdesk:sec_email_exis').value = "";
		document.getElementById('wdesk:E_Stmnt_regstrd_exis').value = "";
		document.getElementById('wdesk:MobilePhone_Existing').value = "";
		document.getElementById('wdesk:sec_mob_phone_exis').value = "";
		document.getElementById('wdesk:homephone_exis').value = "";
		document.getElementById('wdesk:office_phn_exis').value = "";
		document.getElementById('wdesk:homecntryphone_exis').value = "";
		document.getElementById('wdesk:pref_contact_exis').value = "";
		document.getElementById('wdesk:emp_type_exis').value = "";
		document.getElementById('wdesk:designation_exis').value = "";
		document.getElementById('wdesk:comp_name_exis').value = "";
		document.getElementById('wdesk:emp_name_exis').value = "";
		document.getElementById('wdesk:department_exis').value = "";
		document.getElementById('wdesk:employee_num_exis').value = "";
		document.getElementById('wdesk:occupation_exist').value = "";
		document.getElementById('wdesk:name_of_business_exis').value = "";
		document.getElementById('wdesk:total_year_of_emp_exis').value = "";
		document.getElementById('wdesk:years_of_business_exis').value = "";
		document.getElementById('wdesk:employment_status_exis').value = "";
		document.getElementById('wdesk:date_join_curr_employer_exis').value = "";
		document.getElementById('wdesk:marrital_status_exis').value = "";
		document.getElementById('wdesk:no_of_dependents_exis').value = "";
		//				document.getElementById('wdesk:country_of_res_exis').value=""; 
		document.getElementById('wdesk:nation_exist').value = "";
		document.getElementById('wdesk:wheninuae_exis').value = "";
		document.getElementById('wdesk:prev_organ_exis').value = "";
		document.getElementById('wdesk:period_organ_exis').value = "";
		document.getElementById('wdesk:fax_exis').value = "";
		
		if ('<%=WSNAME%>' != 'PBO') 
		{		
			document.getElementById("title_new").value = "--Select--";
			document.getElementById('wdesk:FullName_New').value = "";
			//document.getElementById('wdesk:ShortName_New').value="";
			document.getElementById('wdesk:FirstName_New').value = "";
			document.getElementById('wdesk:MiddleName_New').value = "";
			document.getElementById('wdesk:LastName_New').value = "";
			document.getElementById('gender_new').value = "--Select--";
			document.getElementById('wdesk:emiratesid_new').value = "";
			document.getElementById('wdesk:emiratesidexp_new').value = "";
			document.getElementById('wdesk:PassportNumber_New').value = "";
			document.getElementById('wdesk:passportExpDate_new').value = "";
			document.getElementById('wdesk:visa_new').value = "";
			document.getElementById('wdesk:visaExpDate_new').value = "";
			document.getElementById('wdesk:mother_maiden_name_new').value = "";
			//document.getElementById('usnatholder_new').value="--Select--";
			//document.getElementById('usresi_new').value="--Select--";
			//document.getElementById('usgreencardhol_new').value="--Select--";
			//document.getElementById('us_tax_payer_new').value="--Select--";
			//			document.getElementById('us_citizen_new').value="--Select--";
			//	document.getElementById('wdesk:nocnofbirth_new').value="";
			document.getElementById('wdesk:resi_line1').value = "";
			document.getElementById('wdesk:resi_line2').value = "";
			document.getElementById('wdesk:resi_line3').value = "";
			document.getElementById('wdesk:resi_line4').value = "";
			document.getElementById('resi_restype').value = "--Select--";
			document.getElementById('wdesk:resi_pobox').value = "";
			document.getElementById('wdesk:resi_zipcode').value = "";
			document.getElementById('wdesk:resi_state').value = "";
			document.getElementById('wdesk:resi_city').value = "";
			document.getElementById('resi_cntrycode').value = "--Select--";
			document.getElementById('wdesk:office_line1').value = "";
			document.getElementById('wdesk:office_line2').value = "";
			document.getElementById('wdesk:office_line3').value = "";
			document.getElementById('wdesk:office_line4').value = "";
			document.getElementById('office_restype').value = "--Select--";
			document.getElementById('wdesk:office_pobox').value = "";
			document.getElementById('wdesk:office_zipcode').value = "";
			document.getElementById('wdesk:office_state').value = "";
			document.getElementById('wdesk:office_city').value = "";
			document.getElementById('office_cntrycode').value = "--Select--";
			document.getElementById('pref_add_new').value = "--Select--";
			document.getElementById('wdesk:primary_emailid_new').value = "";
			document.getElementById('wdesk:sec_email_new').value = "";
			document.getElementById('E_Stmnt_regstrd_new').value = "--Select--";
			document.getElementById('wdesk:MobilePhone_New1').value = "";
			document.getElementById('wdesk:MobilePhone_New').value = "";
			document.getElementById('wdesk:MobilePhone_New2').value = "";
			document.getElementById('wdesk:sec_mob_phone_newC').value = "";
			document.getElementById('wdesk:sec_mob_phone_newN').value = "";
			document.getElementById('wdesk:sec_mob_phone_newE').value = "";
			document.getElementById('wdesk:homephone_newC').value = "";
			document.getElementById('wdesk:homephone_newN').value = "";
			document.getElementById('wdesk:homephone_newE').value = "";
			document.getElementById('wdesk:office_phn_newC').value = "";
			document.getElementById('wdesk:office_phn_new').value = "";
			document.getElementById('wdesk:office_phn_newE').value = "";
			document.getElementById('wdesk:fax_newC').value = "";
			document.getElementById('wdesk:fax_new').value = "";
			document.getElementById('wdesk:fax_newE').value = "";
			document.getElementById('wdesk:homecntryphone_newC').value = "";
			document.getElementById('wdesk:homecntryphone_newN').value = "";
			document.getElementById('wdesk:homecntryphone_newE').value = "";
			document.getElementById('pref_contact_new').value = "--Select--";
			document.getElementById('emp_type_new').value = "--Select--";
			document.getElementById('wdesk:designation_new').value = "";
			document.getElementById('wdesk:comp_name_new').value = "";
			document.getElementById('wdesk:emp_name_new').value = "";
			document.getElementById('wdesk:department_new').value = "";
			document.getElementById('wdesk:employee_num_new').value = "";
			document.getElementById('wdesk:occupation_new').value = "";
			document.getElementById('wdesk:naturebusiness_new').value = "";
			document.getElementById('wdesk:total_year_of_emp_new').value = "";
			document.getElementById('wdesk:years_of_business_new').value = "";
			document.getElementById('employment_status_new').value = "--Select--";
			document.getElementById('wdesk:date_join_curr_employer_new').value = "";
			document.getElementById('marrital_status_new').value = "--Select--";
			document.getElementById('wdesk:no_of_dependents_new').value = "";
			document.getElementById('country_of_res_new').value="";
			document.getElementById('wdesk:wheninuae_new').value = "";
			document.getElementById('abcdelig_new').value = "--Select--";
			document.getElementById('nation_new').value = "";
			document.getElementById('wdesk:office_curr_years').value = "";
			document.getElementById('wdesk:resi_curr_years').value = "";
			document.getElementById('pref_email_new').value = "--Select--";
			document.getElementById('wdesk:prev_organ_new').value = "";
			document.getElementById('wdesk:period_organ_new').value = "";
			document.getElementById('title_new_doc').value = "";
			document.getElementById('wdesk:first_name_new_doc').value = "";
			document.getElementById('middle_name_new_doc').value = "";
			document.getElementById('last_name_new_doc').value = "";
			document.getElementById('full_name_new_doc').value = "";
			//document.getElementById('short_name_new_doc').value="";
			document.getElementById('gender_new_doc').value = "";
			document.getElementById('emiratesid_new_doc').value = "";
			document.getElementById('emiratesidexp_new_doc').value = "";
			document.getElementById('passport_num_new_doc').value = "";
			document.getElementById('passportExpDate_new_doc').value = "";
			document.getElementById('visa_new_doc').value = "";
			document.getElementById('visaExpDate_new_doc').value = "";
			document.getElementById('mother_maiden_name_new_doc').value = "";
			//document.getElementById('usnatholder_new_doc').value="";
			//document.getElementById('usresi_new_doc').value="";
			//	document.getElementById('usgreencardhol_new_doc').value="";
			//	document.getElementById('us_tax_payer_new_doc').value="";
			//			document.getElementById('us_citizen_new_doc').value="";
			//		document.getElementById('nocnofbirth_new_doc').value="";
			document.getElementById('abcdelig_new_doc').value = "";
			document.getElementById('resiadd_new_doc').value = "";
			document.getElementById('officeadd_new_doc').value = "";
			document.getElementById('pref_add_new_doc').value = "";
			document.getElementById('prim_email_new_doc').value = "";
			document.getElementById('secondary_emailid_new_doc').value = "";
			document.getElementById('pref_email_new_doc').value = "";
			document.getElementById('E_Stmnt_regstrd_new_doc').value = "";
			document.getElementById('mob_phone_new_doc').value = "";
			document.getElementById('sec_mob_phone_newN_doc').value = "";
			document.getElementById('homephone_newN_doc').value = "";
			document.getElementById('office_phn_new_doc').value = "";
			document.getElementById('fax_new_doc').value = "";
			document.getElementById('homecntryphone_newN_doc').value = "";
			document.getElementById('pref_contact_new_doc').value = "";
			document.getElementById('emp_type_new_doc').value = "";
			document.getElementById('designation_new_doc').value = "";
			document.getElementById('comp_name_new_doc').value = "";
			document.getElementById('emp_name_new_doc').value = "";
			document.getElementById('department_new_doc').value = "";
			document.getElementById('employee_num_new_doc').value = "";
			document.getElementById('occupation_new_doc').value = "";
			document.getElementById('name_of_business_new_doc').value = "";
			document.getElementById('total_year_of_emp_new_doc').value = "";
			document.getElementById('years_of_business_new_doc').value = "";
			document.getElementById('employment_status_new_doc').value = "";
			document.getElementById('date_join_curr_employer_new_doc').value = "";
			document.getElementById('marrital_status_new_doc').value = "";
			document.getElementById('no_of_dependents_new_doc').value = "";
			document.getElementById('country_of_res_new_doc').value="";
			document.getElementById('nation_new_doc').value = "";
			document.getElementById('wheninuae_new_doc').value = "";
			document.getElementById('prev_organ_new_doc').value = "";
			document.getElementById('period_organ_new_doc').value = "";
		}

		document.getElementById("panel20").style.display = "none";
		document.getElementById("panel3").style.display = "none";
		document.getElementById("PBOHide8").style.display = "none";
		document.getElementById("panel22").style.display = "none";
		document.getElementById("CIF_Data_Updates").style.display = "none";
		document.getElementById("decision_tab").style.display = "none";
		document.getElementById("PBOHide9").style.display = "none";
		document.getElementById("divCheckbox2").style.display = "none";//Added by Amandeep on 188 11 2016
	}

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           to get data from entity_details call

//***********************************************************************************//
	function getEntityDetails() {
		var CIF_ID = document.getElementById("wdesk:CIFNumber_Existing").value;
		var account_number = document.getElementById("wdesk:account_number").value;
		var loan_agreement_id = document.getElementById("wdesk:loan_agreement_id").value;
		var card_number = document.getElementById("wdesk:card_number").value;
		var emirates_id = document.getElementById("wdesk:emirates_id").value;
		var wi_name = '<%=WINAME%>';
		
		if ((CIF_ID == "") && (account_number == "") && (loan_agreement_id == "") && (card_number == "") && (emirates_id == "")) {
			alert("Please enter the Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No. ");
			document.getElementById("wdesk:loan_agreement_id").focus();
			return false;
		} else {
			document.getElementById("Fetch").disabled = true;
			document.getElementById("wdesk:CIFNumber_Existing").disabled = true;
			document.getElementById("wdesk:account_number").disabled = true;
			document.getElementById("wdesk:loan_agreement_id").disabled = true;
			document.getElementById("wdesk:card_number").disabled = true;
			document.getElementById("wdesk:emirates_id").disabled = true;
			var xmlDoc;
			var x;
			var xLen;
			var request_type = "ENTITY_DETAILS";
			var mobile_number = "111111"; //document.getElementById("wdesk:mob_phone_exis").value;
			var account_type = "A";

			//getAccountType for Card
			if (account_number == "") {
				if (card_number != "") {
					account_number = card_number;
					account_type = "C";

				}
				//code change for Loan Agreement ID
				else if (loan_agreement_id != "") {
					account_number = loan_agreement_id;
					account_type = "L";
				} else
					account_type = "";
			}

			var user_name = '<%=customSession.getUserName()%>';
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/CU/CustomForms/CU_Specific/CUIntegration.jsp";

			var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;

			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);

			if (xhr.status == 200 && xhr.readyState == 4) {
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

				if (ajaxResult.indexOf("Exception") == 0) {
					alert("Please enter an valid Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No.");
					document.getElementById("Fetch").disabled = false;
					document.getElementById("wdesk:CIFNumber_Existing").disabled = false;
					document.getElementById("wdesk:account_number").disabled = false;
					document.getElementById("wdesk:loan_agreement_id").disabled = false;
					document.getElementById("wdesk:card_number").disabled = false;
					document.getElementById("wdesk:emirates_id").disabled = false;

					return false;
				}
				ajaxResult = ajaxResult.split("^^^");
				document.getElementById("mainEmiratesId").innerHTML = ajaxResult[0];
				document.getElementById("wdesk:rak_elite_customer").value = ajaxResult[1];
				document.getElementById("wdesk:armName").value = ajaxResult[2];
				document.getElementById("wdesk:Segment").value = ajaxResult[3];
				document.getElementById("wdesk:sub_segment").value = ajaxResult[4];
				
				document.getElementById("Fetch").disabled = true;
				document.getElementById("ReadEmiratesID").disabled = true;
				document.getElementById("panel20").style.display = "block";
				document.getElementById("panel3").style.display = "block";
				document.getElementById("PBOHide8").style.display = "block";
				document.getElementById("panel22").style.display = "block";
				document.getElementById("CIF_Data_Updates").style.display = "block";
				document.getElementById("decision_tab").style.display = "block";
				document.getElementById("PBOHide9").style.display = "block";

			} else {
				alert("Problem in getting Entity Details.");
				return false;
			}
			var TypeOfRelation_exis = document.getElementById("wdesk:TypeOfRelation_exis").value;
			if (TypeOfRelation_exis.indexOf("!") != -1) {
				TypeOfRelation_exis = TypeOfRelation_exis.replace(/!/gi, "\n").replace(/^,/, "");;
				document.getElementById("wdesk:TypeOfRelation_exis").value = TypeOfRelation_exis;
			}
			var FatcaDoc = document.getElementById("wdesk:FatcaDoc").value;
			if (FatcaDoc.indexOf("!") != -1) {
				FatcaDoc = FatcaDoc.replace(/!/gi, "\n").replace(/^,/, "");;
				document.getElementById("wdesk:FatcaDoc").value = FatcaDoc;
			}
			//Added by Shamily Dec CR to update Total years of Employment existing and Total years of Employment according to employment status
			if(document.getElementById("wdesk:emp_type_exis").value.toUpperCase() == "Salaried".toUpperCase())
			{
				document.getElementById("wdesk:years_of_business_exis").value ='';	
			}
			else if (document.getElementById("wdesk:emp_type_exis").value.toUpperCase() == "Self employed".toUpperCase())
			{
			    document.getElementById("wdesk:total_year_of_emp_exis").value ='';
			}
			else
			{
				document.getElementById("wdesk:years_of_business_exis").value ='';	
				document.getElementById("wdesk:total_year_of_emp_exis").value ='';
			}
			return true;
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           Account Number validation is made of 13 digits

//***********************************************************************************//
	
	function validateaccountno() {
		if (document.getElementById("wdesk:account_number").value.length != 13) {
			alert("Account Number should be of 13 digits");
			document.getElementById("wdesk:account_number").value = "";
			document.getElementById("wdesk:account_number").focus();
			return false;
		}
		return true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To replace values of field

//***********************************************************************************//
	function replaceAll(data, searchfortxt, replacetxt) {
		var startIndex = 0;
		while (data.indexOf(searchfortxt) != -1) {
			data = data.substring(startIndex, data.indexOf(searchfortxt)) + data.substring(data.indexOf(searchfortxt) + 1, data.length);
		}
		return data;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To check the validity of card number

//***********************************************************************************//
	function mod10(cardNumber) {
		var clen = new Array(cardNumber.length);
		var n = 0,
			sum = 0;
		for (n = 0; n < cardNumber.length; ++n) {
			clen[n] = parseInt(cardNumber.charAt(n));
		}
		for (n = clen.length - 2; n >= 0; n -= 2) {
			clen[n] *= 2;
			if (clen[n] > 9)
				clen[n] -= 9;
		}

		for (n = 0; n < clen.length; ++n) {
			sum += clen[n];
		}
		return (((sum % 10) == 0) ? true : false);
	}

	function checkBoxHandler(t) {
		if (t.checked)
			t.value = 'Y';
		else
			t.value = 'N';
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To update flag of checkboxes

//***********************************************************************************//
	function checkboxchecked() {
		if (document.getElementById('wdesk:personal_loan').checked)
			document.getElementById('wdesk:isPLProcured').value = "Yes";
		else {
			document.getElementById('wdesk:isPLProcured').value = "No";
		}
		if (document.getElementById('wdesk:auto_loan').checked)
			document.getElementById('wdesk:isALProcured').value = "Yes";
		else {
			document.getElementById('wdesk:isALProcured').value = "No";
		}
		if (document.getElementById('wdesk:m_loan').checked)
			document.getElementById('wdesk:isMLProcured').value = "Yes";
		else {
			document.getElementById('wdesk:isMLProcured').value = "No";
		}
		if (document.getElementById('wdesk:RF_loan').checked)
			document.getElementById('wdesk:isRFLProcured').value = "Yes";
		else {
			document.getElementById('wdesk:isRFLProcured').value = "No";
		}
		if (document.getElementById('wdesk:cards').checked)
			document.getElementById('wdesk:isCardsProcured').value = "Yes";
		else {
			document.getElementById('wdesk:isCardsProcured').value = "No";
		}
		if (document.getElementById('wdesk:trade_fin').checked)
			document.getElementById('wdesk:isTradeFinance').value = "Yes";
		else {
			document.getElementById('wdesk:isTradeFinance').value = "No";
		}
		if (document.getElementById('wdesk:In_Pro').checked)
			document.getElementById('wdesk:isInvestmentProduct').value = "Yes";
		else {
			document.getElementById('wdesk:isInvestmentProduct').value = "No";
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To validate length and data of home phone,office phone and fax number.

//***********************************************************************************//	
	function hmphnstart(reqtype)
	{
	    var fieldId="";
	    var fieldName="";
		
		if(reqtype == 'home phone')
		{
			fieldId="wdesk:homephone_newE";
			fieldName="Home Phone";
		}
		else if(reqtype == 'Office phone')
		{	
			fieldId="wdesk:office_phn_newE";
			fieldName="Office Phone";		
		}
		else if(reqtype == 'Fax')
		{	
			fieldId="wdesk:fax_newE";
			fieldName="Fax";		
		}

		if(fieldId!=""){
			var fieldValue=document.getElementById(fieldId).value;
			if(fieldValue!=null && fieldValue!=""){
				var msg="";
				var fieldStartWith = fieldValue.substring(0,1);				
				
				if(fieldValue.length <8)
					msg="Length of "+fieldName+" number should be 8";
				
				if(fieldStartWith == '0' || fieldStartWith == '1' || fieldStartWith == '8')
					msg=msg+(msg==""?"":"\n")+fieldName+" number should start from 2,3,4,5,6,7 or 9";
				
				if(msg!="")	{
					alert(msg);
					document.getElementById(fieldId).focus();
					return false;
				}
			}
		}
		return true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To validate homephone not to be equal to mobile phone 1 and 2 

//***********************************************************************************//	
	
	function homephnvalidate(reqtype)
	{
		var MobilePhone_Existing =  document.getElementById("wdesk:MobilePhone_Existing").value;
		MobilePhone_Existing =  MobilePhone_Existing.replace('+','');
		MobilePhone_Existing = MobilePhone_Existing.replace('(','');
		MobilePhone_Existing = MobilePhone_Existing.replace(')','');
		
		var sec_mob_phone_exis = document.getElementById("wdesk:sec_mob_phone_exis").value;
		sec_mob_phone_exis = sec_mob_phone_exis.replace('+','');
		sec_mob_phone_exis = sec_mob_phone_exis.replace('(','');
		sec_mob_phone_exis = sec_mob_phone_exis.replace(')','');
		var homephone_newC =  document.getElementById("wdesk:homephone_newC").value;
		var homephone_newN = document.getElementById("wdesk:homephone_newN").value;
		var homephone_newE = document.getElementById("wdesk:homephone_newE").value;
		var HomePhn = homephone_newC +homephone_newN+homephone_newE;
		
		HomePhn = HomePhn.replace(null,'');
		var MobilePhone_New1 = document.getElementById("wdesk:MobilePhone_New1").value;
		var MobilePhone_New = document.getElementById("wdesk:MobilePhone_New").value;
		var MobilePhone_New2 = document.getElementById("wdesk:MobilePhone_New2").value;
		var MobilePhn1 = MobilePhone_New1+MobilePhone_New+MobilePhone_New2;
		MobilePhn1 = MobilePhn1.replace(null,'');
		
		var sec_mob_phone_newC = document.getElementById("wdesk:sec_mob_phone_newC").value;
		var sec_mob_phone_newN = document.getElementById("wdesk:sec_mob_phone_newN").value;
		var sec_mob_phone_newE = document.getElementById("wdesk:sec_mob_phone_newE").value;
		var mobilePhn2 = sec_mob_phone_newC+sec_mob_phone_newN+sec_mob_phone_newE;
		mobilePhn2 = mobilePhn2.replace(null,'');
		
		if(reqtype=='homephn'){
		
			if(MobilePhn1 != "" && HomePhn == MobilePhn1)
			{
				alert("Home Phone should not be equal to mobile phone 1");
				document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			else if ((MobilePhn1 == null || MobilePhn1 == "" ) && MobilePhone_Existing != null && MobilePhone_Existing != "" &&   MobilePhone_Existing == HomePhn)
			{
				alert("Home Phone should not be equal to mobile phone 1");
				document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			
			if(mobilePhn2 != null && mobilePhn2 != ""  && HomePhn == mobilePhn2)
			{
				alert("Home Phone should not be equal to mobile phone 2");
				document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
			else if ((mobilePhn2 == null || mobilePhn2 == "" ) && sec_mob_phone_exis != null && sec_mob_phone_exis != "" && sec_mob_phone_exis == HomePhn)
			{
				alert("Home Phone should not be equal to mobile phone 2");
				document.getElementById("wdesk:homephone_newE").focus();
				return false;
			}
		}	
		else if(reqtype == 'mobphn1')
		{
			if(MobilePhn1!=null && MobilePhn1!="" && (MobilePhn1 == HomePhn))
			{
				alert("Home Phone should not be equal to mobile phone 1");
				document.getElementById("wdesk:MobilePhone_New2").focus();
				return false;
			}
		}
		else if(reqtype == 'mobphn2')
		{
			if(mobilePhn2!=null && mobilePhn2!="" && (mobilePhn2 == HomePhn))
			{
				alert("Home Phone should not be equal to mobile phone 2");
				document.getElementById("wdesk:sec_mob_phone_newE").focus();
				return false;
			}
		}	
	}
	

	// validate function for mobile phone 1 for country of res_exis = UAE 
	
	function mobvalidate(CountryCode,PhoneNumber,PhoneType)
	{
	var MobilePhone_New1 = document.getElementById(CountryCode).value;
	var MobilePhone_New2 = document.getElementById(PhoneNumber).value;
	var country_of_res_exis = document.getElementById("wdesk:country_of_res_exis").value;
	
	if(country_of_res_exis== "AE" )
		{
			if((MobilePhone_New1!= null && MobilePhone_New1 != "" && MobilePhone_New1 != "00971") && (MobilePhone_New2.substring(0,1) != 5 && MobilePhone_New2.substring(0,1) != "" && MobilePhone_New2.substring(0,1) != null ))
			{
				document.getElementById(CountryCode).value = "";
				document.getElementById(PhoneNumber).value = "";
				window.setTimeout(function()
				{
					document.getElementById(CountryCode).focus();
				},0);	
				return false;
			
			}
			
			else if((MobilePhone_New1 != null && MobilePhone_New1 != "" && MobilePhone_New1 != "00971"))
			{
				alert(PhoneType+" Country code for UAE Country of residence should be 00971");
				
				document.getElementById(CountryCode).value = "";
				//setfocus()
				window.setTimeout(function()
				{
					document.getElementById(CountryCode).focus();
				},0);	
				return false;
			}
			
			else if(MobilePhone_New2.substring(0,1) != 5 && MobilePhone_New2.substring(0,1) != "" && MobilePhone_New2.substring(0,1) != null )
			{
				alert(PhoneType+" number for UAE Country of residence should start from 5");
				
				document.getElementById(PhoneNumber).value = "";
				window.setTimeout(function()
				{
					document.getElementById(PhoneNumber).focus();
				},0);
				
				return false;
			}
		
			if(MobilePhone_New2.length !=0 && MobilePhone_New2.length <9)
			{
				alert("Length of "+PhoneType+" number should be 9");
				//document.getElementById("wdesk:MobilePhone_New2").value = "";
				window.setTimeout(function()
				{
					document.getElementById(PhoneNumber).focus();
				},0);
			}
		} 
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To validate that emirates expiry date to be equal to visa expiry date validation

//***********************************************************************************//		
	
	function emidexpdatevaliation(reqtype)
	{
		var visaExpDate_new = document.getElementById("wdesk:visaExpDate_new").value;
		var emiratesidexp_new = document.getElementById("wdesk:emiratesidexp_new").value;
		var visaExpDate_exis = document.getElementById("wdesk:visaExpDate_exis").value;
		var emiratesidexp_exis = document.getElementById("wdesk:emiratesidexp_exis").value;
		var fieldIdToFocus="";
		
		if(reqtype == "Emirates expiry date")
			fieldIdToFocus="wdesk:emiratesidexp_new";
		else
			fieldIdToFocus="wdesk:visaExpDate_new";
		
		if(visaExpDate_new!=null && visaExpDate_new!="" && emiratesidexp_new!=null && emiratesidexp_new!="" ){
			if(visaExpDate_new!=emiratesidexp_new){
				alert("'Emirates ID Expiry Date' and 'Visa Expiry Date' should be same");
				document.getElementById(fieldIdToFocus).focus();
				return false;
			}
		} else if((visaExpDate_new==null || visaExpDate_new=="") && emiratesidexp_new!=null && emiratesidexp_new!="" && visaExpDate_exis!=null && visaExpDate_exis!="" ){
			if(visaExpDate_exis!=emiratesidexp_new){
				alert("'Emirates ID Expiry Date' and 'Visa Expiry Date' should be same");
				document.getElementById(fieldIdToFocus).focus();
				return false;
			}
		} else if(visaExpDate_new!=null && visaExpDate_new!="" && emiratesidexp_exis!=null && emiratesidexp_exis!="" && (emiratesidexp_new==null || emiratesidexp_new=="") ){
			if(visaExpDate_new!=emiratesidexp_exis){
				alert("'Emirates ID Expiry Date' and 'Visa Expiry Date' should be same");
				document.getElementById(fieldIdToFocus).focus();
				return false;
			}
		}
		
		return true;
	}
	
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           //If user updates any field and redo it by doing it blank or select then document required field with document is                                           visible at next workstep .
										 //To overcome changes made in function tosavedocuments() by adding docidvalue='';

//***********************************************************************************//	
	
	var docidvalue = '';

	function tosavedocuments() {
		docidvalue = '';

		if (document.getElementById("gender_new").value != "--Select--") {
			docidvalue = ((document.getElementById("gender_new_doc").id) + "|" + (document.getElementById("gender_new_doc").value)) + "$";
		}
		if (document.getElementById("wdesk:emiratesid_new").value != "") {
			var emiratesdoc = ((document.getElementById("emiratesid_new_doc").id) + "|" + (document.getElementById("emiratesid_new_doc").value)) + "$";
			docidvalue = docidvalue + emiratesdoc;

		}
		if (document.getElementById("wdesk:emiratesidexp_new").value != "") {
			var emiratesexpdoc = ((document.getElementById("emiratesidexp_new_doc").id) + "|" + (document.getElementById("emiratesidexp_new_doc").value)) + "$";
			docidvalue = docidvalue + emiratesexpdoc;
		}
		if (document.getElementById("wdesk:PassportNumber_New").value != "") {
			var passportdoc = ((document.getElementById("passport_num_new_doc").id) + "|" + (document.getElementById("passport_num_new_doc").value)) + "$";
			docidvalue = docidvalue + passportdoc;
		}
		if (document.getElementById("wdesk:passportExpDate_new").value != "") {
			var passportexpdoc = ((document.getElementById("passportExpDate_new_doc").id) + "|" + (document.getElementById("passportExpDate_new_doc").value)) + "$";
			docidvalue = docidvalue + passportexpdoc;
		}
		if (document.getElementById("wdesk:visa_new").value != "") {
			var visadoc = ((document.getElementById("visa_new_doc").id) + "|" + (document.getElementById("visa_new_doc").value)) + "$";
			docidvalue = docidvalue + visadoc;
		}
		if (document.getElementById("wdesk:visaExpDate_new").value != "") {
			var visaexpdoc = ((document.getElementById("visaExpDate_new_doc").id) + "|" + (document.getElementById("visaExpDate_new_doc").value)) + "$";
			docidvalue = docidvalue + visaexpdoc;
		}
		if (document.getElementById("wdesk:mother_maiden_name_new").value != "") {
			var motherdoc = ((document.getElementById("mother_maiden_name_new_doc").id) + "|" + (document.getElementById("mother_maiden_name_new_doc").value)) + "$";
			docidvalue = docidvalue + motherdoc;
		}
		
		if (document.getElementById("abcdelig_new").value != "--Select--") {
			var aecbdoc = ((document.getElementById("abcdelig_new_doc").id) + "|" + (document.getElementById("abcdelig_new_doc").value)) + "$";
			docidvalue = docidvalue + aecbdoc;
		}
		if (document.getElementById("wdesk:resi_pobox").value != "") {
			var residoc = ((document.getElementById("resiadd_new_doc").id) + "|" + (document.getElementById("resiadd_new_doc").value)) + "$";
			docidvalue = docidvalue + residoc;
		}
		if (document.getElementById("wdesk:office_pobox").value != "") {
			var officedoc = ((document.getElementById("officeadd_new_doc").id) + "|" + (document.getElementById("officeadd_new_doc").value)) + "$";
			docidvalue = docidvalue + officedoc;
		}
		if (document.getElementById("pref_add_new").value != "--Select--") {
			var prefadddco = ((document.getElementById("pref_add_new_doc").id) + "|" + (document.getElementById("pref_add_new_doc").value)) + "$";
			docidvalue = docidvalue + prefadddco;
		}
		if (document.getElementById("wdesk:primary_emailid_new").value != "") {
			var primarydoc = ((document.getElementById("prim_email_new_doc").id) + "|" + (document.getElementById("prim_email_new_doc").value)) + "$";
			docidvalue = docidvalue + primarydoc;
		}
		if (document.getElementById("wdesk:sec_email_new").value != "") {
			var secemaildoc = ((document.getElementById("secondary_emailid_new_doc").id) + "|" + (document.getElementById("secondary_emailid_new_doc").value)) + "$";
			docidvalue = docidvalue + secemaildoc;
		}
		if (document.getElementById("pref_email_new").value != "--Select--") {
			var prefemaildoc = ((document.getElementById("pref_email_new_doc").id) + "|" + (document.getElementById("pref_email_new_doc").value)) + "$";
			docidvalue = docidvalue + prefemaildoc;
		}
		if (document.getElementById("E_Stmnt_regstrd_new").value != "--Select--") {
			var estatedoc = ((document.getElementById("E_Stmnt_regstrd_new_doc").id) + "|" + (document.getElementById("E_Stmnt_regstrd_new_doc").value)) + "$";
			docidvalue = docidvalue + estatedoc;
		}
		if (document.getElementById("pref_email_new").value != "--Select--") {
			var prefemaildoc = ((document.getElementById("pref_email_new_doc").id) + "|" + (document.getElementById("pref_email_new_doc").value)) + "$";
			docidvalue = docidvalue + prefemaildoc;
		}
		if (document.getElementById("wdesk:MobilePhone_New1").value != "") {
			var mob1doc = ((document.getElementById("mob_phone_new_doc").id) + "|" + (document.getElementById("mob_phone_new_doc").value)) + "$";
			docidvalue = docidvalue + mob1doc;
		}
		if (document.getElementById("wdesk:sec_mob_phone_newC").value != "") {
			var mob2doc = ((document.getElementById("sec_mob_phone_newN_doc").id) + "|" + (document.getElementById("sec_mob_phone_newN_doc").value)) + "$";
			docidvalue = docidvalue + mob2doc;
		}
		if (document.getElementById("wdesk:homephone_newC").value != "") {
			var homephndoc = ((document.getElementById("homephone_newN_doc").id) + "|" + (document.getElementById("homephone_newN_doc").value)) + "$";
			docidvalue = docidvalue + homephndoc;
		}
		if (document.getElementById("wdesk:office_phn_newC").value != "") {
			var offcphndoc = ((document.getElementById("office_phn_new_doc").id) + "|" + (document.getElementById("office_phn_new_doc").value)) + "$";
			docidvalue = docidvalue + offcphndoc;
		}
		if (document.getElementById("wdesk:fax_newC").value != "") {
			var faxdoc = ((document.getElementById("fax_new_doc").id) + "|" + (document.getElementById("fax_new_doc").value)) + "$";
			docidvalue = docidvalue + faxdoc;
		}
		if (document.getElementById("wdesk:homecntryphone_newC").value != "") {
			var homecntrydoc = ((document.getElementById("homecntryphone_newN_doc").id) + "|" + (document.getElementById("homecntryphone_newN_doc").value)) + "$";
			docidvalue = docidvalue + homecntrydoc;
		}
		if (document.getElementById("pref_contact_new").value != "--Select--") {
			var prefcontactdoc = ((document.getElementById("pref_contact_new_doc").id) + "|" + (document.getElementById("pref_contact_new_doc").value)) + "$";
			docidvalue = docidvalue + prefcontactdoc;
		}
		if (document.getElementById("emp_type_new").value != "--Select--") {
			var emptypedoc = ((document.getElementById("emp_type_new_doc").id) + "|" + (document.getElementById("emp_type_new_doc").value)) + "$";
			docidvalue = docidvalue + emptypedoc;
		}
		if (document.getElementById("wdesk:designation_new").value != "") {
			var designationdoc = ((document.getElementById("designation_new_doc").id) + "|" + (document.getElementById("designation_new_doc").value)) + "$";
			docidvalue = docidvalue + designationdoc;
		}
		if (document.getElementById("wdesk:comp_name_new").value != "") {
			var compdoc = ((document.getElementById("comp_name_new_doc").id) + "|" + (document.getElementById("comp_name_new_doc").value)) + "$";
			docidvalue = docidvalue + compdoc;
		}
		if (document.getElementById("wdesk:emp_name_new").value != "") {
			var empdoc = ((document.getElementById("emp_name_new_doc").id) + "|" + (document.getElementById("emp_name_new_doc").value)) + "$";
			docidvalue = docidvalue + empdoc;
		}
		if (document.getElementById("wdesk:department_new").value != "") {
			var departmentdoc = ((document.getElementById("department_new_doc").id) + "|" + (document.getElementById("department_new_doc").value)) + "$";
			docidvalue = docidvalue + departmentdoc;
		}
		if (document.getElementById("wdesk:employee_num_new").value != "") {
			var empnumdoc = ((document.getElementById("employee_num_new_doc").id) + "|" + (document.getElementById("employee_num_new_doc").value)) + "$";
			docidvalue = docidvalue + empnumdoc;
		}
		if (document.getElementById("wdesk:occupation_new").value != "") {
			var occudoc = ((document.getElementById("occupation_new_doc").id) + "|" + (document.getElementById("occupation_new_doc").value)) + "$";
			docidvalue = docidvalue + occudoc;
		}
		if (document.getElementById("wdesk:total_year_of_emp_new").value != "") {
			var yearsemp = ((document.getElementById("total_year_of_emp_new_doc").id) + "|" + (document.getElementById("total_year_of_emp_new_doc").value)) + "$";
			docidvalue = docidvalue + yearsemp;
		}
		if (document.getElementById("wdesk:years_of_business_new").value != "") {
			var yrsbusidoc = ((document.getElementById("years_of_business_new_doc").id) + "|" + (document.getElementById("years_of_business_new_doc").value)) + "$";
			docidvalue = docidvalue + yrsbusidoc;
		}
		if (document.getElementById("employment_status_new").value != "--Select--") {
			var empstatusdoc = ((document.getElementById("employment_status_new_doc").id) + "|" + (document.getElementById("employment_status_new_doc").value)) + "$";
			docidvalue = docidvalue + empstatusdoc;
		}
		if (document.getElementById("wdesk:date_join_curr_employer_new").value != "") {
			var datejoindoc = ((document.getElementById("date_join_curr_employer_new_doc").id) + "|" + (document.getElementById("date_join_curr_employer_new_doc").value)) + "$";
			docidvalue = docidvalue + datejoindoc;
		}
		if (document.getElementById("marrital_status_new").value != "--Select--") {
			var marritaldoc = ((document.getElementById("marrital_status_new_doc").id) + "|" + (document.getElementById("marrital_status_new_doc").value)) + "$";
			docidvalue = docidvalue + marritaldoc;
		}
		if (document.getElementById("wdesk:no_of_dependents_new").value != "") {
			var dependentsdoc = ((document.getElementById("no_of_dependents_new_doc").id) + "|" + (document.getElementById("no_of_dependents_new_doc").value)) + "$";
			docidvalue = docidvalue + dependentsdoc;
		}
		if (document.getElementById("nation_new").value != "--Select--") {
			var nationdoc = ((document.getElementById("nation_new_doc").id) + "|" + (document.getElementById("nation_new_doc").value)) + "$";
			docidvalue = docidvalue + nationdoc;
		}
		if (document.getElementById("wdesk:wheninuae_new").value != "") {
			var wheninuaedoc = ((document.getElementById("wheninuae_new_doc").id) + "|" + (document.getElementById("wheninuae_new_doc").value)) + "$";
			docidvalue = docidvalue + wheninuaedoc;
		}
		if (document.getElementById("wdesk:prev_organ_new").value != "") {
			var prevorgandoc = ((document.getElementById("prev_organ_new_doc").id) + "|" + (document.getElementById("prev_organ_new_doc").value)) + "$";
			docidvalue = docidvalue + prevorgandoc;
		}
		if (document.getElementById("wdesk:period_organ_new").value != "") {
			var periodorgandoc = ((document.getElementById("period_organ_new_doc").id) + "|" + (document.getElementById("period_organ_new_doc").value));
			docidvalue = docidvalue + periodorgandoc;
		}
		document.getElementById("wdesk:documents").value = docidvalue;
	}

	
	//added by shamily to autopopulate EMREG expiry date 
	function setEMREGexpirydate()
	{
		//var EMREGIssuedate_new = document.getElementById("wdesk:EMREGIssuedate_new").value;
		/*if(EMREGIssuedate_new == "")
		document.getElementById("wdesk:EMREGExpirydate_new").value = "";
		else
		{
				var EMREGExpiryday= EMREGIssuedate_new.substring(0,2);
				var EMREGExpirymnth = EMREGIssuedate_new.substring(3,4);
				if(EMREGExpirymnth == "0")
				EMREGExpirymnth = EMREGIssuedate_new.substring(4,5);
				else
				EMREGExpirymnth = EMREGIssuedate_new.substring(3,5);
				
				EMREGExpirymnth = parseInt(EMREGExpirymnth);
				
				EMREGExpirymnth=EMREGExpirymnth+6;
				
				var EMREGExpiryyear = EMREGIssuedate_new.substring(6,10);
				EMREGExpiryyear = parseInt(EMREGExpiryyear,10);
				
				if(EMREGExpirymnth >12)
				{
					EMREGExpirymnth = EMREGExpirymnth - 12;
					EMREGExpiryyear = EMREGExpiryyear+1;
				}
				
				if(getlength(EMREGExpirymnth)==1)
				EMREGExpirymnth = "0"+EMREGExpirymnth;
				
				if((EMREGExpiryday+EMREGExpirymnth+EMREGExpiryyear).indexOf("NaN") ==-1  && EMREGIssuedate_new != "" &&  EMREGIssuedate_new != null)
				document.getElementById("wdesk:EMREGExpirydate_new").value = EMREGExpiryday+'/'+EMREGExpirymnth+'/'+EMREGExpiryyear;
		}*/
	}
	
	
	function getlength(number){
	return number.toString().length;
	}
	function getEmiratesID() {
		var emirates_id = document.getElementById("wdesk:emirates_id").value;
		var account_number = document.getElementById("wdesk:account_number").value;
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "/CU/CustomForms/CU_Specific/FetchEmiratesId.jsp";

		var param = "Emirates_Id=" + emirates_id + "&Account_Number=" + account_number;
		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);

		if (xhr.status == 200 && xhr.readyState == 4) {
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in getting Emirates ID details.");
				return false;
			}

			document.getElementById("mainEmiratesId").innerHTML = ajaxResult;

		} else {
			alert("Problem in getting getEmiratesID.");
			return false;
		}


		return true;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To update value of checkboxes based on worksteps

//***********************************************************************************//	
	function checkboxcheckinit(WSNAME) {
		if (WSNAME == 'CSO' || WSNAME == "CSO_Rejects") {
			document.getElementById('wdesk:isPLProcured').value = "No";
			document.getElementById('wdesk:isALProcured').value = "No";
			document.getElementById('wdesk:isMLProcured').value = "No";
			document.getElementById('wdesk:isRFLProcured').value = "No";
			document.getElementById('wdesk:isCardsProcured').value = "No";
			document.getElementById('wdesk:isTradeFinance').value = "No";
			document.getElementById('wdesk:isInvestmentProduct').value = "No";
			document.getElementById('wdesk:passport_rec').value = "No";
			document.getElementById('wdesk:emirates_id_rec').value = "No";
			document.getElementById('wdesk:labourcard_rec').value = "No";
			document.getElementById('wdesk:family_book_rec').value = "No";
			document.getElementById('wdesk:know_customer_record').value = "No";
			document.getElementById('wdesk:employmnt_cert_rec').value = "No";
			document.getElementById('wdesk:salary_transfer_letter').value = "No";
			document.getElementById('wdesk:joint_sole').value = "No";
			document.getElementById('wdesk:sole_joint').value = "No";
			document.getElementById('wdesk:sign_update').value = "No";
			document.getElementById('wdesk:dorman_activation').value = "No";
		}
		//wsname=OPS%20Maker_DE removed from here
		//WSNAME = CSO_Rejects removed from here
		if (WSNAME == 'CSO_Doc_Scan' || WSNAME == "CB_WC" || WSNAME == "Crops_Approval" || WSNAME == "CB_WC_Checker_Review" ||
			WSNAME == "CB_WC_Controls" || WSNAME == "OPS_Checker_Review" || WSNAME == "Error" || WSNAME == "Doc_Archival" ||
			WSNAME == "Hold" || WSNAME == "PB_Credit_Approval" || WSNAME == "SME_Credit_Approval" || WSNAME == "Card_Deletion" ||
			WSNAME == "Finacle_DE_Maker" || WSNAME == "Finacle_DE_Checker" || WSNAME == "Compliance" || WSNAME == "CSM_Review" || WSNAME == "Crops_Approval" || WSNAME == "System_Update") {
		
			if (document.getElementById('wdesk:isPLProcured').value == "Yes") {
				document.getElementById("wdesk:personal_loan").checked = true;
				document.getElementById('wdesk:personal_loan').disabled = true;

			} else if (document.getElementById('wdesk:isPLProcured').value == "No") {
				document.getElementById("wdesk:personal_loan").checked = false;
				document.getElementById('wdesk:personal_loan').disabled = true;
			}
			if (document.getElementById('wdesk:isALProcured').value == "Yes") {
				document.getElementById("wdesk:auto_loan").checked = true;
				document.getElementById('wdesk:auto_loan').disabled = true;
			} else if (document.getElementById('wdesk:isALProcured').value == "No") {
				document.getElementById("wdesk:auto_loan").checked = false;
				document.getElementById('wdesk:auto_loan').disabled = true;
			}
			if (document.getElementById('wdesk:isMLProcured').value == "Yes") {
				document.getElementById("wdesk:m_loan").checked = true;
				document.getElementById('wdesk:m_loan').disabled = true;
			} else if (document.getElementById('wdesk:isMLProcured').value == "No") {
				document.getElementById("wdesk:m_loan").checked = false;
				document.getElementById('wdesk:m_loan').disabled = true;
			}

			if (document.getElementById('wdesk:isRFLProcured').value == "Yes") {
				document.getElementById("wdesk:RF_loan").checked = true;
				document.getElementById('wdesk:RF_loan').disabled = true;
			} else if (document.getElementById('wdesk:isRFLProcured').value == "No") {
				document.getElementById("wdesk:RF_loan").checked = false;
				document.getElementById('wdesk:RF_loan').disabled = true;
			}

			if (document.getElementById('wdesk:isCardsProcured').value == "Yes") {
				document.getElementById("wdesk:cards").checked = true;
				document.getElementById('wdesk:cards').disabled = true;
			} else if (document.getElementById('wdesk:isCardsProcured').value == "No") {
				document.getElementById("wdesk:cards").checked = false;
				document.getElementById('wdesk:cards').disabled = true;
			}
			if (document.getElementById('wdesk:isTradeFinance').value == "Yes") {
				document.getElementById("wdesk:trade_fin").checked = true;
				document.getElementById('wdesk:trade_fin').disabled = true;
			} else if (document.getElementById('wdesk:isTradeFinance').value == "No") {
				document.getElementById("wdesk:trade_fin").checked = false;
				document.getElementById('wdesk:trade_fin').disabled = true;
			}
			if (document.getElementById('wdesk:isInvestmentProduct').value == "Yes") {
				document.getElementById("wdesk:In_Pro").checked = true;
				document.getElementById('wdesk:In_Pro').disabled = true;
			} else if (document.getElementById('wdesk:isInvestmentProduct').value == "No") {
				document.getElementById("wdesk:In_Pro").checked = false;
				document.getElementById('wdesk:In_Pro').disabled = true;
			}
			document.getElementById("wdesk:world_check_req").value = "No";
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           form visibility at different worksteps - initiated by cso and pbo 

//***********************************************************************************//	
	
	function formvisibility(WSNAME) {

		if (document.getElementById("wdesk:isPBOCase").value == "No") {
			if (document.getElementById("wdesk:isPBOCase").value == "No") {
				document.getElementById("divCheckbox2").style.display = "block"; //cif
				document.getElementById("PBOHide9").style.display = "block"; //supporting documents
				document.getElementById("PBOHide8").style.display = "block"; //template generation
				document.getElementById("panel22").style.display = "block"; //decision tab		
				
			}


		} else if (document.getElementById("wdesk:isPBOCase").value == "Yes") {
			if (WSNAME == 'PBO' || WSNAME == 'PBO_Rejects' || WSNAME == 'Archival_Activity' || WSNAME == "Archival_Rejects" || WSNAME == "System_SendEmail" || WSNAME == "OPS_Checker_Review" || WSNAME == "Reject" || WSNAME == "OPS%20Maker_DE") {
				document.getElementById("divCheckbox2").style.display = "block"; //cif
				document.getElementById("panel22").style.display = "block"; //decision tab
				document.getElementById("PBOHide6").style.display = "none"; //power of attorney addition
				document.getElementById("PBOHide7").style.display = "none"; //power of attorney deletion
				document.getElementById("PBOHide9").style.display = "block"; //supporting documents
				document.getElementById("PBOHide1").style.display = "none"; //sign     
				document.getElementById("PBOHide2").style.display = "none"; //dormancy
				document.getElementById("PBOHide3").style.display = "none"; //account conversion minor to major
				document.getElementById("PBOHide4").style.display = "none"; //account conversion sole to joint
				document.getElementById("PBOHide5").style.display = "none"; //account conversion joint to sole
				document.getElementById("PBOHide8").style.display = "block"; //template generation
			} else {
				document.getElementById("divCheckbox2").style.display = "block"; //cif
				document.getElementById("loan").style.display = "block"; //loan
				document.getElementById("KYC_tab").style.display = "block"; //KYC_tab
				document.getElementById("panel22").style.display = "block"; //decision tab
				document.getElementById("PBOHide6").style.display = "none"; //power of attorney addition
				document.getElementById("PBOHide7").style.display = "none"; //power of attorney deletion
				document.getElementById("PBOHide9").style.display = "block"; //supporting documents
				document.getElementById("PBOHide1").style.display = "none"; //sign     
				document.getElementById("PBOHide2").style.display = "none"; //dormancy
				document.getElementById("PBOHide3").style.display = "none"; //account conversion minor to major
				document.getElementById("PBOHide4").style.display = "none"; //account conversion sole to joint
				document.getElementById("PBOHide5").style.display = "none"; //account conversion joint to sole
				document.getElementById("PBOHide8").style.display = "block"; //template generation
			}
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To validate primary email id

//***********************************************************************************//
	function checkEmail() {

		var email = document.getElementById('wdesk:primary_emailid_new');
		if (email.value == '') return;
		var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

		if (!filter.test(email.value)) {
			alert('Please provide a valid email address');
			document.getElementById('wdesk:primary_emailid_new').value = "";
			email.focus;
			return false;
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To validate secondary email id

//***********************************************************************************//
	function checkEmail1() {

		var email = document.getElementById('wdesk:sec_email_new');
		if (email.value == '') return;
		var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;

		if (!filter.test(email.value)) {
			alert('Please provide a valid email address');
			document.getElementById('wdesk:sec_email_new').value = "";
			email.focus;
			return false;
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To validate 4,5,6,7 digits of emirates id based on date of birth year 

//***********************************************************************************//
	function validateyear() {
		
		var dob_new = document.getElementById("wdesk:DOB_new").value;
		if (dob_new == "" || dob_new == null) {
			dob_new = document.getElementById("wdesk:DOB_exis").value;
		}
		if (dob_new != "" && dob_new != null) {
			dob_new = dob_new.substring(6, 10);
		}

		if (document.getElementById("wdesk:emiratesid_new").value.indexOf(dob_new) != 3 && document.getElementById("wdesk:emiratesid_new").value !="") {
			alert("4,5,6,7 characters of Emirates ID Number should be year of birth");
			document.getElementById("wdesk:emiratesid_new").value = "";
			document.getElementById("wdesk:emiratesid_new").focus();
			return false;
		}
		return true;
	}



	function validateemptype()
	{
		if(document.getElementById("emp_type_new").value == "Self employed")
		{
			if((document.getElementById('wdesk:office_line1').value !="" && document.getElementById('wdesk:office_line1').value != null) || (document.getElementById('wdesk:office_line2').value !="" && document.getElementById('wdesk:office_line2').value != null )|| (document.getElementById('wdesk:office_line3').value !=""&& document.getElementById('wdesk:office_line3').value != null )||( document.getElementById('wdesk:office_line4').value !=""&& document.getElementById('wdesk:office_line4').value != null )|| (document.getElementById('office_restype').value!= ""&& document.getElementById('office_restype').value!= null && document.getElementById('office_restype').value!= "--Select--")||(document.getElementById('wdesk:office_pobox').value != ""&& document.getElementById('wdesk:office_pobox').value!= null )||(document.getElementById('wdesk:office_zipcode').value != ""&& document.getElementById('wdesk:office_zipcode').value!= null) || (document.getElementById('office_cntrycode').value != ""&& document.getElementById('office_cntrycode').value!= null && document.getElementById('office_cntrycode').value != "--Select--")|| (document.getElementById('wdesk:office_state').value!= "" && document.getElementById('wdesk:office_state').value!= null )|| (document.getElementById('wdesk:office_city').value!= "" &&document.getElementById('wdesk:office_city').value!= null))
			{
				//alert('Industry segment, Industry Subsegment, Deal With country should be mandatory');
				mandatorycheck('emp_type');
				document.getElementById('IndustrySegment_new').disabled = false;
				document.getElementById('IndustrySubSegment_new').disabled = false;
				//document.getElementById('DealwithCont_new').disabled = false;
				return false;
			}
			else
			{
				document.getElementById('IndustrySegment_new').disabled = true;
				document.getElementById('IndustrySubSegment_new').disabled = true;
				//document.getElementById('DealwithCont_new').disabled = true;
				document.getElementById('IndustrySegment_new').value = '--Select--';
				document.getElementById('IndustrySubSegment_new').value = '--Select--';
				document.getElementById('DealwithCont_new').value = '--Select--';
				mandatorycheck('emp_typenonmand');
			}
		}
			
		//Added By Nikita on 16052018 for CU CRs Start
		if(document.getElementById("wdesk:emp_type_exis").value == "SELF EMPLOYED") 
		{
			document.getElementById('wdesk:total_year_of_emp_new').disabled = true;  
		}
		//Added By Nikita on 16052018 for CU CRs End
		
		//Added By Nikita on 16052018 for CU CRs Start
		else if(document.getElementById("wdesk:emp_type_exis").value == "SALARIED")  
		{
			document.getElementById('wdesk:years_of_business_new').disabled = true;
			return false;
		}
		//Added By Nikita on 16052018 for CU CRs End
			
		else if((document.getElementById("emp_type_new").value == "--Select--")|| (document.getElementById("emp_type_new").value == null)||(document.getElementById("emp_type_new").value == ""))
		{
			if(document.getElementById("wdesk:emp_type_exis").value == "SELF EMPLOYED") 
			{
				if((document.getElementById('wdesk:office_line1').value !="" && document.getElementById('wdesk:office_line1').value != null) || (document.getElementById('wdesk:office_line2').value !="" && document.getElementById('wdesk:office_line2').value != null )|| (document.getElementById('wdesk:office_line3').value !=""&& document.getElementById('wdesk:office_line3').value != null )||( document.getElementById('wdesk:office_line4').value !=""&& document.getElementById('wdesk:office_line4').value != null )|| (document.getElementById('office_restype').value!= ""&& document.getElementById('office_restype').value!= null && document.getElementById('office_restype').value!= "--Select--")||(document.getElementById('wdesk:office_pobox').value != ""&& document.getElementById('wdesk:office_pobox').value!= null )||(document.getElementById('wdesk:office_zipcode').value != ""&& document.getElementById('wdesk:office_zipcode').value!= null) || (document.getElementById('office_cntrycode').value != ""&& document.getElementById('office_cntrycode').value!= null && document.getElementById('office_cntrycode').value != "--Select--")|| (document.getElementById('wdesk:office_state').value!= "" && document.getElementById('wdesk:office_state').value!= null )|| (document.getElementById('wdesk:office_city').value!= "" &&document.getElementById('wdesk:office_city').value!= null))
				{	
					
					document.getElementById('IndustrySegment_new').disabled = false;
					document.getElementById('IndustrySubSegment_new').disabled = false;
					//document.getElementById('DealwithCont_new').disabled = false;
					mandatorycheck('emp_type');
					return false;
					
				}
				else
				{
					document.getElementById('IndustrySegment_new').disabled = true;
					document.getElementById('IndustrySubSegment_new').disabled = true;
					//document.getElementById('DealwithCont_new').disabled = true;
					document.getElementById('IndustrySegment_new').value = '--Select--';
					document.getElementById('IndustrySubSegment_new').value = '--Select--';
					document.getElementById('DealwithCont_new').value = '--Select--';
					mandatorycheck('emp_typenonmand');
				}
			}
			else
			{
				document.getElementById('IndustrySegment_new').disabled = true;
				document.getElementById('IndustrySubSegment_new').disabled = true;
				document.getElementById('DealwithCont_new').disabled = true;
				document.getElementById('IndustrySegment_new').value = '--Select--';
				document.getElementById('IndustrySubSegment_new').value = '--Select--';
				document.getElementById('DealwithCont_new').value = '--Select--';
				mandatorycheck('emp_typenonmand');
			}
		}
		else
		{
			document.getElementById('IndustrySegment_new').disabled = true;
			document.getElementById('IndustrySubSegment_new').disabled = true;
			document.getElementById('DealwithCont_new').disabled = true;
			document.getElementById('IndustrySegment_new').value = '--Select--';
			document.getElementById('IndustrySubSegment_new').value = '--Select--';
			document.getElementById('DealwithCont_new').value = '--Select--';
			document.getElementById('wdesk:total_year_of_emp_new').disabled = false;  //Added By Nikita on 16052018 for CU CRs
			document.getElementById('wdesk:years_of_business_new').disabled = false;
			mandatorycheck('emp_typenonmand');
		}
		return true; //added 
	}	
	

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To length emirates id 

//***********************************************************************************//
	function validate_emiratesid(id) {
		if (document.getElementById(id).value.indexOf("784") === 0) {
			if (document.getElementById(id).value.length != 15) {
				alert("Invalid length, must be 15 characters");
				document.getElementById(id).value = "";
				document.getElementById(id).focus();
				return false;
			}
		} /*else if (document.getElementById(id).value.indexOf("800") === 0) {
			if (document.getElementById(id).value.length != 21) {
				alert("Emirates ID starting with 800 should be of 21 characters");
				document.getElementById(id).value = "";
				document.getElementById(id).focus();
				return false;
			}
		}*/ //Removed this validation as part of JIRA CSRCIF-118
		else {
			alert("Emirates ID Number should start with 784 and should be of 15 characters");
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
		return true;
	}
	
	function EMREGNumbervalidation(id)
	{
		/*if (document.getElementById(id).value.indexOf("800") !== 0) {
			alert("EMREG number should start with 800");
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}*/
		if (document.getElementById(id).value.length != 21) {
				alert("EMREG Number should be of 21 characters");
				document.getElementById(id).value = "";
				document.getElementById(id).focus();
				return false;
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To validate emirates id expiry date

//***********************************************************************************//
	function validateDate() {
		var enteredDate = document.getElementById("wdesk:emiratesidexp_new").value;
		var today = new Date();
		
		var arrStartDate = enteredDate.split("/");
		var date1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
		var timeDiff = date1.getTime() - today.getTime();

		var DaysDiff = timeDiff / (1000 * 3600 * 24);
		var yeardiff = (parseInt(DaysDiff) - 1) / 365;
		if (yeardiff > 10) {
			alert("Emirates ID Expiry Date should be not more than 10 years than Current Date");
			document.getElementById("wdesk:emiratesidexp_new").value = "";
		}

		if (DaysDiff < 7) {
			alert("New Emirates ID Number should be accepted only if expiry date should have atleast 7 days to expire");
			document.getElementById("wdesk:emiratesidexp_new").value = "";
		}
	}

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To add and remove document list in selected document list 

//***********************************************************************************//
	
	function move(tbFrom, tbTo, button) {
		var arrFrom = new Array();
		var arrTo = new Array();
		var arrLU = new Array();
		var idTbFrom = tbFrom.id;
		var i;
		for (i = 0; i < tbTo.options.length; i++) {
			arrLU[tbTo.options[i].text] = tbTo.options[i].value;
			arrTo[i] = tbTo.options[i].text;
		}
		var fLength = 0;
		var tLength = arrTo.length;
		for (i = 0; i < tbFrom.options.length; i++) {
			arrLU[tbFrom.options[i].text] = tbFrom.options[i].value;
			if (tbFrom.options[i].selected && tbFrom.options[i].value != "") {
				arrTo[tLength] = tbFrom.options[i].text;
				tLength++;
			} else {
				arrFrom[fLength] = tbFrom.options[i].text;
				fLength++;
			}
		}

		tbFrom.length = 0;
		tbTo.length = 0;
		var ii;

		for (ii = 0; ii < arrFrom.length; ii++) {
			var no = new Option();
			no.text = arrFrom[ii];
			no.value = arrFrom[ii];
			tbFrom[ii] = no;
		}


		for (ii = 0; ii < arrTo.length; ii++) {
			var no = new Option();
			no.text = arrTo[ii];
			no.value = arrTo[ii];
			tbTo[ii] = no;
		}

		//Below Code is being used to fetch selected 'Documents list' to save in database.
		var docList = "";
		if (button.id == "addButton") {
			for (j = 0; j < tbTo.length; j++) {
				if (docList != "") {
					docList = docList + "-" + tbTo[j].value;
				} else {
					docList = tbTo[j].value;
				}
			}
		} else {
			for (j = 0; j < tbFrom.length; j++) {
				if (docList != "") {
					docList = docList + "-" + tbFrom[j].value;
				} else {
					docList = tbFrom[j].value;
				}
			}
		}
		if (idTbFrom == 'selectedList') {
			if (tbFrom.options.length == 0) {
				document.getElementById("selectedList").style.Width = "220px";
			} else {
				document.getElementById("selectedList").style.Width = "auto";
				document.getElementById("documentList").style.Width = "auto";
			}
		}
		if (idTbFrom == 'documentList') {
			if (tbFrom.options.length == 0) {
				document.getElementById("documentList").style.Width = "220px";
			} else {
				document.getElementById("documentList").style.Width = "auto";
				document.getElementById("selectedList").style.Width = "auto";
			}
		}
		document.getElementById("wdesk:Supporting_Docs").value = docList;
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To show list of documents on scrolling

//***********************************************************************************//
	//modified by nikita to enable onscroll property for Fatca Reason
	function OnDivScroll(id) {
		var documentList;
		var FatcaDocNewList;
		var FatcaReasonNewList;
		var TypeOfRelationNewList;
		var requiredDocList;
		if (id == "divDocumentList")
			documentList = document.getElementById("documentList");
		else
			documentList = document.getElementById("selectedList");
		if (id == "FatcaDocNewList") {
			FatcaDocNewList = document.getElementById("FatcaDocNew");
			FatcaDocNewList.size = 6;
		}
		if(id == "FatcaReasonNewList"){
		FatcaReasonNewList = document.getElementById("FatcaReasonNew");
		FatcaReasonNewList.size = 6;
		}
		
		
		if (id == "requiredDocList")
		{
			requiredDocList = document.getElementById("requiredDoc1");
			requiredDocList.size=6;
		} else {
			TypeOfRelationNewList = document.getElementById("TypeOfRelationNew");
			TypeOfRelationNewList.size = 8;
		}

		if (documentList.options.length > 8) {
			documentList.size = documentList.options.length;
		} else {
			documentList.size = 8;
		}
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To validate city entered is among the list of cities provided

//***********************************************************************************//	
	function validatecity(req,cityvalidate)
	{
		
		cityvalidate=cityvalidate.split(",");
		var match ='';
		
		for(var i=0;i<=cityvalidate.length;i++)
		{
			if(document.getElementById(req).value=='(SUWAIHAN) ABU DHABI')
			{
				cityvalidate[0]='(SUWAIHAN) ABU DHABI';
			}
			if(document.getElementById(req).value==cityvalidate[i])
			match='matched';
		}
		if(match !='matched')
		{
			if (req != 'wdesk:Oecdcity_new') // not clearing City Of Birth field since it is free text added on 23042018
				document.getElementById(req).value="";
			return false;
		}
		
	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           
//Description                 :           To validate visa expiry date

//***********************************************************************************//	
	function validateDatevisaexpiry() {
		var enteredDate = document.getElementById("wdesk:visaExpDate_new").value;
		var today = new Date();
		var arrStartDate = enteredDate.split("/");
		var date1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
		var timeDiff = date1.getTime() - today.getTime();

		var DaysDiff = timeDiff / (1000 * 3600 * 24);
		var monthdiff = (parseInt(DaysDiff) + 1) / 12;
		var yeardiff = (parseInt(DaysDiff) - 1) / 365;
		if (yeardiff > 10) {
			alert("Visa Expiry Date should be not more than 10 years than Current Date");
			document.getElementById("wdesk:visaExpDate_new").value = "";
		}

	}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           nikita
//Description                 :           To validate passport enumber and passport expiry date

//***********************************************************************************//
	
	function validatePassportNo(obj)
	{
		var passportNumber=document.getElementById("wdesk:PassportNumber_New").value;
	
		if(obj=='Passno')
		{	
			if (passportNumber != null && passportNumber != "" ) 
			{
				var passportExpDate = document.getElementById("wdesk:passportExpDate_new").value;
			
				if(passportExpDate==null || passportExpDate=="" )
				{
					var str = "*";
					var result = str.fontcolor("red"); 
					document.getElementById('passexpdate').innerHTML ='Passport Expiry Date<FONT color=red>*</FONT>'
					alert("Please Enter the Passport Expiry date.");
					document.getElementById("wdesk:passportExpDate_new").focus();
					return false;
				}
				else
				{
					var today = new Date();
					var arrStartDate3 = passportExpDate.split("/");
					var date3 = new Date(arrStartDate3[2], arrStartDate3[1] - 1, arrStartDate3[0]);
					var timeDiffPassport = date3.getTime() - today.getTime();
					if (timeDiffPassport < 0) {
						alert("Passport date has Expired WorkItem cannot be initiated.");
						return false;
					}
				}	
			}
			else
			{
				document.getElementById('passexpdate').innerHTML = 'Passport Expiry Date';
			}
		}
		else if (obj=='pnoExpirydate')
		{
			if(passportNumber=='' || passportNumber == null)
			{
				var str = "*";
				var result = str.fontcolor("red"); 
				document.getElementById('Passno').innerHTML = 'Passport Number<FONT color=red>*</FONT>';
				alert('Please enter new passport number');
				document.getElementById("wdesk:PassportNumber_New").focus();
			}		
		}
	} 
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      :           Shamily
//Description                 :           To set the frame of form in single alignment

//***********************************************************************************//	
	function setFrameSize()
	{
	
		var widthToSet = document.getElementById("TAB_CifUpdate").offsetWidth;
		var controlName="div_CifUpdate,TAB_CifUpdate,div_CifDataUpdates,TAB_CifDataUpdates,div_SignatureUpdate,div_DormancyActivation,div_SupportingDocumentsReceived,TAB_SupportingDocs,div_FormGeneration,TAB_FormGeneration,div_FormGenerationNew,TAB_FormGenerationNew,divCheckbox3,TAB_Checkbox3,div_Decision,TAB_Decision,emid,mainEmiratesId";
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
	
	function EnableDisableFieldChange(ReqType)
	{
		if (ReqType == 'USRelation')
		{
			var USRelation = document.getElementById("USrelation_new").value;
			if (USRelation == 'O' || USRelation == '--Select--') // 'O' instance for 'No'
			{
				UnSelectMultiSelectedValue("FatcaDocNew");
				document.getElementById("FatcaDocNew").disabled = true;
				UnSelectMultiSelectedValue("FatcaReasonNew");
				document.getElementById("FatcaReasonNew").disabled = true;
			} 
			else
			{
				document.getElementById("FatcaDocNew").disabled = false;
				document.getElementById("FatcaReasonNew").disabled = false;
			}
		}if (ReqType == 'OECDUndoc_Flag')
		{
			var OECDUndoc_Flag = document.getElementById("OECDUndoc_Flag_new").value;
			if (OECDUndoc_Flag == 'No' || OECDUndoc_Flag == '--Select--')
			{
				document.getElementById("OECDUndocreason_new").disabled = true;
				document.getElementById("OECDUndocreason_new").selectedIndex = 0;
				document.getElementById("wdesk:OECDUndocreason_new").value = '';
			} 
			else
			{
				document.getElementById("OECDUndocreason_new").disabled = false;
			}
		}
	}
	
	function UnSelectMultiSelectedValue(MultiFieldName)
	{
		var x = document.getElementById(MultiFieldName).options;
		if (MultiFieldName == 'FatcaDocNew' || MultiFieldName == 'FatcaReasonNew') {
			for (var i = 0; i < x.length; i++) {
				if (x[i].selected == true) {
					x[i].selected = false;
				}
			} 
		}
		if (MultiFieldName == 'FatcaDocNew') {
			document.getElementById("wdesk:FatcaDoc_new").value = '';
		}
		if (MultiFieldName == 'FatcaReasonNew') {
			document.getElementById("wdesk:FatcaReason_new").value = '';
		}
	}
	
	
	/*function enableDisableOptionValue(MultiFieldName,EnableDisable)
	{
		var op = "";
		if (MultiFieldName == 'FatcaDocNew') {
			op = document.getElementById("FatcaDocNew").getElementsByTagName("option");
		}
		if (MultiFieldName == 'FatcaReasonNew') {
			op = document.getElementById("FatcaReasonNew").getElementsByTagName("option");
		}
		if (MultiFieldName == 'OECDUndocreason_new') {
			op = document.getElementById("OECDUndocreason_new").getElementsByTagName("option");
		}
		for (var i = 0; i < op.length; i++) {
			op[i].disabled = true;
		}
	}*/
	</script>
	<script>
		$(document).ready(function()
		{
			$(window).resize(function()
			{		
				setFrameSize();
			});
		});
	</script>
</head>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload ="window.parent.checkIsFormLoaded();
setFrameSize();loadSavedDocTypes('<%=WSNAME%>');javascript:showDiv('<%=WSNAME%>');fetchSolID();checkboxcheckinit('<%=WSNAME%>');formvisibility('<%=WSNAME%>');disableRadio('<%=WSNAME%>');Countrymapping('<%=WSNAME%>');">
	<applet name="EIDAWebComponent" id="EIDAWebComponent" CODE="emiratesid.ae.webcomponents.EIDAApplet" archive="EIDA_IDCard_Applet.jar" width="0" height="0"></applet>		
	
	<form name="wdesk" id="wdesk" method="post">
		
			<div class="accordion-group">
				<div class="accordion-heading" id="div_CifUpdate">
					<h4 class="panel-title" align="center" style="text-align:center;">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel19"><b style="COLOR: white;">CIF Updates</b>
						</a>
					</h4>
				</div>
				<div id="panel19" class="accordion-body collapse in">
					<div class="accordion-inner">
					<table id="TAB_CifUpdate" border='1' cellspacing='1' cellpadding='0' width=100% >
						<tr>
							<td colspan =4 width=100% height=100% align=right valign=center><img src='\CU\webtop\images\bank-logo.gif'></td>
						</tr>
						<tr>
							<td nowrap='nowrap' width="23%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
							<td nowrap='nowrap' width="23%" class='EWNormalGreenGeneral1' height ='22' maxlength = '50' id="username"><%=customSession.getUserName()%></td>
							<td nowrap='nowrap' width="23%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>
							<td nowrap='nowrap' width="24%" class='EWNormalGreenGeneral1' height ='22' maxlength = '50' ><label id="Workstep">&nbsp;&nbsp;&nbsp;&nbsp;<%=WSNAME==null?"":WSNAME.replace("_"," ").replaceAll("%20"," ")%></label></td>
						</tr>
						<tr>							
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;<b>RAK Elite Customer</b></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:rak_elite_customer" id="wdesk:rak_elite_customer"  maxlength = '3' style='width:170px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("RAK_ELITE_CUSTOMER")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RAK_ELITE_CUSTOMER")).getAttribValue().toString()%>' >
								&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' maxlength = '10'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>SOL Id</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:SolId" onkeyup="validateKeys(this,'Alphabetic');" id="wdesk:SolId"  maxlength = '100' style='width:170px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("SolId")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SolId")).getAttribValue().toString()%>' >&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
						</tr>
						<tr>								
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Segment</b>
							</td>							
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:Segment" id="wdesk:Segment"  maxlength = '3' style='width:170px'value='<%=((CustomWorkdeskAttribute)attributeMap.get("Segment")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Segment")).getAttribValue().toString()%>'>&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Channel</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:Channel" id="wdesk:Channel" maxlength = '100' style='width:170px' <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("Channel")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Channel")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
						</tr>
						<tr>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text"  class='NGReadOnlyView' onkeyup="validateKeys(this,'Numeric');" name="wdesk:emirates_id" id="wdesk:emirates_id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Emirates_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Emirates_Id")).getAttribValue().toString()%>' onchange="validate_emiratesid(this.id);" maxlength = '21' style='width:170px'>&nbsp;&nbsp;&nbsp;&nbsp;
								<input name='EmiratesID' type='button'  id='ReadEmiratesID' value='Read' maxlength = '100' class='EWButtonRB NGReadOnlyView' style='width:85px' onclick="callEIDA();return false;">
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Loan Agreement Id</b>
							</td>							
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:loan_agreement_id" onkeyup="validateKeys(this,'Numeric');" id="wdesk:loan_agreement_id"  maxlength = '20' style='width:170px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("loan_agreement_id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("loan_agreement_id")).getAttribValue().toString()%>'>&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
						</tr>							
						<tr>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Card Number</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:card_number" id="wdesk:card_number"onkeyup="validateKeys(this,'Numeric');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Card_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Card_Number")).getAttribValue().toString()%>' maxlength = '16' style='width:170px' >&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>CIF Number</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:CIFNumber_Existing" onkeyup="validateKeys(this,'Numeric');" id="wdesk:CIFNumber_Existing"  maxlength = '7' style='width:170px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIFNumber_Existing")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CIFNumber_Existing")).getAttribValue().toString()%>'>
								&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
						</tr>								
						<tr>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Account Number</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:account_number" onchange="validateaccountno();" onkeyup="validateKeys(this,'Numeric');"  id="wdesk:account_number" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Account_Number")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Account_Number")).getAttribValue().toString()%>' maxlength = '13' style='width:170px' >
								&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>Sub-Segment</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:sub_segment" onkeyup="validateKeys(this,'Numeric');"  id="wdesk:sub_segment" value='<%=((CustomWorkdeskAttribute)attributeMap.get("sub_segment")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sub_segment")).getAttribValue().toString()%>' maxlength = '13' style='width:170px' >
								&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
						</tr>
						<tr>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
								&nbsp;&nbsp;&nbsp;&nbsp;<b>ARMName</b>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input type="text" class='NGReadOnlyView' name="wdesk:armName"   id="wdesk:armName" value='<%=((CustomWorkdeskAttribute)attributeMap.get("armName")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("armName")).getAttribValue().toString()%>' maxlength = '13' style='width:170px' >
								&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td nowrap='nowrap' colspan=2 class='EWNormalGreenGeneral1' height ='22'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
                        						
						<tr>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
							<td style="text-align:right;" nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<input name='Fetch' type='button'  id='Fetch' value='Search' onclick="setFrameSize();getEntityDetails();fetchSolID();" class='EWButtonRB NGReadOnlyView' style='width:85px'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</td>
							<td style="text-align:left;" nowrap='nowrap' class='EWNormalGreenGeneral1'>
								&nbsp;&nbsp;&nbsp;<input name='Clear' id='Clear' type='button'  value='Clear' onclick="ClearFields()" class='EWButtonRB NGReadOnlyView' style='width:85px'>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		<div id="divCheckbox">
			<div class="accordion-group">
				<div id="panel20" class="accordion-body collapse in">				  
					<div class="accordion-inner" id="mainEmiratesId">				
					</div>
				</div>
			</div>
		</div>
		<div id="divCheckbox2" style="display: none;">
			<div class="accordion-group">
				<div class="accordion-heading" id="div_CifDataUpdates">
					<h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel3" id="CIF_Data_Updates" >
							<b style="COLOR: white;">CIF Data Updates</b>
						</a>
					</h4>
				</div>
				<div id="panel3" class="accordion-body collapse in">
					<div class="accordion-inner">								
			<table id="TAB_CifDataUpdates" border='1' cellspacing='1' cellpadding='0' width=100%>
				<tr width=100% >
					<td width=25% style="padding-left: 5px;" nowrap='nowrap' class="EWNormalGreenGeneral1 "  colspan="1"><b><font color="#FF4747">Personal Details</font></b></td>
					<td width=25% style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 "   colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"><b><font color="#FF4747">Existing</font></b></td>
					
					<td width=25% style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 "    colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"><b><font color="#FF4747">New</font></b></td>
					<td width=25% style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 "   colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"><b><font color="#FF4747">Documents Required</font></b></td>
				    
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Title</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'  colspan="1"><input type="text" name="wdesk:title_exis" size="35"  maxlength = '5' id="wdesk:title_exis"   readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("title_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("title_exis")).getAttribValue().toString()%>'>
					</td>				
				
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="title_new" maxlength = '5' name="title_new" style="width: 100%;" onchange="docReq(this,'Title','title_new_doc');CIFtrackGridFields('CIF Data Update','Personal Name Change');changeVal(this,'<%=WSNAME%>')" >
							<option value="--Select--">--Select--</option>
							<option value="Mr.">Mr.</option>
							<option value="Mrs.">Mrs.</option>
							<option value="Ms.">Ms.</option>
						</select>
					</td>
					
					<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="title_new_doc" size="35" id="title_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
				
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">First Name</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:FirstName_Existing" size="35" maxlength = '100' id="wdesk:FirstName_Existing"   readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("FirstName_Existing")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FirstName_Existing")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');" maxlength = '50'  name="FirstName_New" size="35"  id="wdesk:FirstName_New" onchange="docReq(this,'First Name','first_name_new_doc');CIFtrackGridFields('CIF Data Update','Personal Name Change');"  <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("FirstName_New")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FirstName_New")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wdesk:first_name_new_doc" size="35" id="wdesk:first_name_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Middle Name</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:MiddleName_Existing" size="35" maxlength = '100' id="wdesk:MiddleName_Existing"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("MiddleName_Existing")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiddleName_Existing")).getAttribValue().toString()%>'>
					</td>
             	    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');"
 name="MiddleName_New" size="35" onchange="docReq(this,'Middle Name','middle_name_new_doc');CIFtrackGridFields('CIF Data Update','Personal Name Change');"  maxlength = '50' id="wdesk:MiddleName_New" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiddleName_New")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiddleName_New")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="middle_name_new_doc" size="35" id="middle_name_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Last Name</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:LastName_Existing" size="35" maxlength = '50' id="wdesk:LastName_Existing"  readonly disabled=true  class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("LastName_Existing")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("LastName_Existing")).getAttribValue().toString()%>'>
					</td>
                   
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"  class='NGReadOnlyView' style="width: 100%;"  onkeyup="validateKeys(this,'Alphabetic');"
name="LastName_New" size="35" onchange="docReq(this,'Last Name','last_name_new_doc');CIFtrackGridFields('CIF Data Update','Personal Name Change');" maxlength = '100' id="wdesk:LastName_New" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("LastName_New")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("LastName_New")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="last_name_new_doc" size="35" id="last_name_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>	
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Full Name</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:FullName_Existing" size="35" maxlength = '150' id="wdesk:FullName_Existing"   readonly disabled=true class="sizeofbox" value = ''>
					</td>
					  
					<td nowrap='nowrap' maxlength = '100' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');" name="FullName_New" size="35" onchange="docReq(this,'Full Name','full_name_new_doc');CIFtrackGridFields('CIF Data Update','Personal Name Change');"  id="wdesk:FullName_New" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("FullName_New")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FullName_New")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="full_name_new_doc" size="35" id="full_name_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
		
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Gender</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="" name="wdesk:gender_exit" size="35" maxlength = '11' id="wdesk:gender_exit"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("gender_exit")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("gender_exit")).getAttribValue().toString()%>'>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="gender_new" style="width: 100%;" name="gender_new" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','CIF Data Update');docReq(this,'Gender','gender_new_doc');tosavedocuments();">
							<option value="--Select--">--Select--</option>
							<option value="Male">Male</option>
							<option value="Female">Female</option>
						</select>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="gender_new_doc" size="35" id="gender_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Date Of Birth</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:DOB_exis" size="35" maxlength = '20' id="wdesk:DOB_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("DOB_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DOB_exis")).getAttribValue().toString()%>' >
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1,cal1'><input type="text"  class='NGReadOnlyView'   style="width: 100%;" name="wdesk:DOB_new" size="35" maxlength = '20' id="wdesk:DOB_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("DOB_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("DOB_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("DOB_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="DOB_new_doc" size="35" id="DOB_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  id = "emidc" class='EWNormalGreenGeneral1' colspan="1">Emirates ID Number</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text"  name="emirates_id" size="35" maxlength = '100' id="emirates_id"  readonly disabled=true  class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Emirates_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Emirates_Id")).getAttribValue().toString()%>'>
					</td>
                   
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Numeric');" name="wdesk:emiratesid_new" size="35" onchange="docReq(this,'Emirates ID','emiratesid_new_doc');CIFtrackGridFields('CIF Data Update','Emirates Id Update');validate_emiratesid(this.id);tosavedocuments();validateyear();" maxlength = '21' id="wdesk:emiratesid_new"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("emiratesid_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emiratesid_new")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="emiratesid_new_doc" size="35" id="emiratesid_new_doc" readonly disabled=true class="sizeofbox">
					
					</td>
					
				</tr>
			
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id = "EMIDexpdt" class='EWNormalGreenGeneral1' colspan="1">Emirates ID Expiry Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:emiratesidexp_exis" size="35" maxlength = '20' id="wdesk:emiratesidexp_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("emiratesidexp_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emiratesidexp_exis")).getAttribValue().toString()%>' >
					</td>

					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1,cal1'><input type="text"  class='NGReadOnlyView'   style="width: 100%;" name="wdesk:emiratesidexp_new" size="35" onchange="optimizedate('EmiratesDate');docReq(this,'Emirates Id Expiry Date','emiratesidexp_new_doc');CIFtrackGridFields('CIF Data Update','Emirates Id Update');validateDate();tosavedocuments();emidexpdatevaliation('Emirates expiry date');" maxlength = '20' id="wdesk:emiratesidexp_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("emiratesidexp_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("emiratesidexp_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("emiratesidexp_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="emiratesidexp_new_doc" size="35" id="emiratesidexp_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
										
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="Passno" class='EWNormalGreenGeneral1' colspan="1">Passport Number</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:PassportNumber_Existing" size="35" maxlength = '100' id="wdesk:PassportNumber_Existing"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("PassportNumber_Existing")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PassportNumber_Existing")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:PassportNumber_New" size="35"  onkeyup="validateKeys(this,'alpha-numeric6');" onchange="docReq(this,'Passport Number','passport_num_new_doc');CIFtrackGridFields('CIF Data Update','Passport Details Update');tosavedocuments();validatePassportNo('Passno');" maxlength = '20' id="wdesk:PassportNumber_New" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("PassportNumber_New")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PassportNumber_New")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="passport_num_new_doc" size="35" id="passport_num_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td id = "passexpdate" style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Passport Expiry Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<%
					if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
						 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input onkeyup="validateKeys(this,'Date');"  type="date" name="wdesk:passportExpDate_exis" size="35" maxlength = '20' id="wdesk:passportExpDate_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_exis")).getAttribValue().toString()%>'>
					<% }
					else {
						//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input onkeyup="validateKeys(this,'Date');"  type="text" name="wdesk:passportExpDate_exis" size="35" maxlength = '20' id="wdesk:passportExpDate_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_exis")).getAttribValue().toString()%>'>
					<% }
					%>
					</td>
                       
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<%
					if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
						 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="text" class='NGReadOnlyView'   style="width: 100%;" name="wdesk:passportExpDate_new" size="35"  onchange="optimizedate('Passportdate');docReq(this,'Passport Expiry Date','passportExpDate_new_doc');CIFtrackGridFields('CIF Data Update','Passport Details Update');tosavedocuments();validatePassportNo('pnoExpirydate');" maxlength = '20' id="wdesk:passportExpDate_new" <%try{
					%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					<% }
					else {
						//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="text" class='NGReadOnlyView'   style="width: 100%;" name="wdesk:passportExpDate_new" size="35"  onchange="optimizedate('Passportdate');docReq(this,'Passport Expiry Date','passportExpDate_new_doc');CIFtrackGridFields('CIF Data Update','Passport Details Update');tosavedocuments();validatePassportNo('pnoExpirydate');" maxlength = '20' id="wdesk:passportExpDate_new" <%try{
					%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("passportExpDate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					<% }
					%>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="passportExpDate_new_doc" size="35" id="passportExpDate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
			
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id="Visac" class='EWNormalGreenGeneral1' colspan="1">Visa Number</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<%
					if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
						 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="date" name="wdesk:visa_exis" size="35" maxlength = '100' id="wdesk:visa_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("visa_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("visa_exis")).getAttribValue().toString()%>'>
					<% }
					else {
						//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="text" name="wdesk:visa_exis" size="35" maxlength = '100' id="wdesk:visa_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("visa_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("visa_exis")).getAttribValue().toString()%>'>
					<% }
					%>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text" class='NGReadOnlyView' style="width: 100%;"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:visa_new" size="35" onchange="docReq(this,'Visa','visa_new_doc');CIFtrackGridFields('CIF Data Update','Visa Update');tosavedocuments();" maxlength = '20' id="wdesk:visa_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("visa_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("visa_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
				
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="visa_new_doc" size="35" id="visa_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="visaexp" class='EWNormalGreenGeneral1' colspan="1">Visa Expiry Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<%
					if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
						 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="date"  name="wdesk:visaExpDate_exis" size="35" maxlength = '20' id="wdesk:visaExpDate_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_exis")).getAttribValue().toString()%>'>
					<% }
					else {
						//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="text"  name="wdesk:visaExpDate_exis" size="35" maxlength = '20' id="wdesk:visaExpDate_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_exis")).getAttribValue().toString()%>'>
					<% }
					%>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:visaExpDate_new" size="35"  onchange="optimizedate('VisaDate');docReq(this,'Visa Expiry Date','visaExpDate_new_doc');CIFtrackGridFields('CIF Data Update','Visa Update');tosavedocuments();validateDatevisaexpiry();emidexpdatevaliation('Visa Expiry date')" maxlength = '20' id="wdesk:visaExpDate_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("visaExpDate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
						
					</td>					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="visaExpDate_new_doc" size="35" id="visaExpDate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id="Marsoonc" class='EWNormalGreenGeneral1' colspan="1">Marsoom Id</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<%
					if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
						 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="date" name="wdesk:Marsoon_exis" size="35" maxlength = '100' id="wdesk:Marsoon_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Marsoon_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Marsoon_exis")).getAttribValue().toString()%>'>
					<% }
					else {
						//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input type="text" name="wdesk:Marsoon_exis" size="35" maxlength = '100' id="wdesk:Marsoon_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Marsoon_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Marsoon_exis")).getAttribValue().toString()%>'>
					<% }
					%>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text" class='NGReadOnlyView' style="width: 100%;"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:Marsoon_new" size="35" onchange="docReq(this,'Marsoon','Marsoon_new_doc');CIFtrackGridFields('CIF Data Update','Marsoon Update');tosavedocuments();" maxlength = '20' id="wdesk:Marsoon_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("Marsoon_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Marsoon_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
				
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Marsoon_new_doc" size="35" id="Marsoon_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr>
				<!-- Added by Shamily new ID fields -->
				<!--<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Marsoom Id Expiry Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="date"  name="wdesk:marsoonExpDate_exis" size="35" maxlength = '20' id="wdesk:marsoonExpDate_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("marsoonExpDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("marsoonExpDate_exis")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" disabled class='NGReadOnlyView'  style="width: 100%;" name="wdesk:marsoonExpDate_new" size="35"  onchange="docReq(this,'MarsoonExpirydate','marsoonExpDate_new_doc');CIFtrackGridFields('CIF Data Update','Marsoon Update');tosavedocuments();optimizedate('MarsoonExpirydate')" maxlength = '20' id="wdesk:marsoonExpDate_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("marsoonExpDate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("marsoonExpDate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("marsoonExpDate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
						
					</td>					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="marsoonExpDate_new_doc" size="35" id="marsoonExpDate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr>  commented on 27022018, this fields are not required, taken below hidden fields -->
				<input type="date" style="display:none" name="wdesk:marsoonExpDate_exis" id="wdesk:marsoonExpDate_exis" value = ''>
				<input type="text" style="display:none" name="wdesk:marsoonExpDate_new" id="wdesk:marsoonExpDate_new" value=''>
				<input type="text" style="display:none" name="marsoonExpDate_new_doc" id="marsoonExpDate_new_doc" value=''>
				<!--<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id="EMREGM" class='EWNormalGreenGeneral1' colspan="1">EMREG Number</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="date" name="wdesk:EMREG_exis" size="35" maxlength = '100' id="wdesk:EMREG_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EMREG_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EMREG_exis")).getAttribValue().toString()%>'>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:EMREG_new" size="35" onchange="EMREGNumbervalidation('wdesk:EMREG_new');docReq(this,'EMREG','EMREG_new_doc');CIFtrackGridFields('CIF Data Update','EMREG Update');tosavedocuments();mandatorycheck('EMREG');" maxlength = '21' id="wdesk:EMREG_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("EMREG_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EMREG_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
				
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="EMREG_new_doc" size="35" id="EMREG_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr> commented on 27022018, this fields are not required, taken below hidden fields-->
				<input type="date" style="display:none" name="wdesk:EMREG_exis" id="wdesk:EMREG_exis" value = ''>
				<input type="text" style="display:none" name="wdesk:EMREG_new" id="wdesk:EMREG_new" value=''>
				<input type="text" style="display:none" name="EMREG_new_doc" id="EMREG_new_doc" value=''>
				
				<!--<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="EMREGMiss" class='EWNormalGreenGeneral1' colspan="1">EMREG Issue Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="date"  name="wdesk:EMREGIssuedate_exis" size="35" maxlength = '20' id="wdesk:EMREGIssuedate_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EMREGIssuedate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EMREGIssuedate_exis")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:EMREGIssuedate_new" size="35"  onchange="docReq(this,'EMREG','EMREGIssuedate_new_doc');CIFtrackGridFields('CIF Data Update','EMREG Issue Date Update');tosavedocuments();optimizedate('EMREGIssueDate');setEMREGexpirydate();" maxlength = '20' id="wdesk:EMREGIssuedate_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("EMREGIssuedate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("EMREGIssuedate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("EMREGIssuedate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
						
					</td>					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="EMREGIssuedate_new_doc" size="35" id="EMREGIssuedate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr> commented on 27022018, this fields are not required, taken below hidden fields-->
				<input type="date" style="display:none" name="wdesk:EMREGIssuedate_exis" id="wdesk:EMREGIssuedate_exis" value = ''>
				<input type="text" style="display:none" name="wdesk:EMREGIssuedate_new" id="wdesk:EMREGIssuedate_new" value=''>
				<input type="text" style="display:none" name="EMREGIssuedate_new_doc" id="EMREGIssuedate_new_doc" value=''>
				
				<!--<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="EMREGMexp" class='EWNormalGreenGeneral1' colspan="1">EMREG Expiry Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="date"  name="wdesk:EMREGExpirydate_exis" size="35" maxlength = '20' id="wdesk:EMREGExpirydate_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EMREGExpirydate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EMREGExpirydate_exis")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:EMREGExpirydate_new" size="35"  onchange="docReq(this,'EMREG','EMREGExpirydate_new_doc');CIFtrackGridFields('CIF Data Update','EMREG Expiry Date Update');tosavedocuments();optimizedate('EMREGExpiryDate')" maxlength = '20' id="wdesk:EMREGExpirydate_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("EMREGExpirydate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("EMREGExpirydate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("EMREGExpirydate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
						
					</td>					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="EMREGExpirydate_new_doc" size="35" id="EMREGExpirydate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr> commented on 27022018, this fields are not required, taken below hidden fields-->
				<input type="date" style="display:none" name="wdesk:EMREGExpirydate_exis" id="wdesk:EMREGExpirydate_exis" value = ''>
				<input type="text" style="display:none" name="wdesk:EMREGExpirydate_new" id="wdesk:EMREGExpirydate_new" value=''>
				<input type="text" style="display:none" name="EMREGExpirydate_new_doc" id="EMREGExpirydate_new_doc" value=''>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Mother's Maiden Name</td>
					<!-- Validation added to unmask Mother's Maiden Name at OPS%20Maker_DE and OPS_Checker_Review -->
					<%
						if(WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("OPS_Checker_Review"))
						{
					%>
						
						<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:mother_maiden_name_exis" size="35" maxlength = '100' id="wdesk:mother_maiden_name_exis"  readonly disabled=true  class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("mother_maiden_name_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("mother_maiden_name_exis")).getAttribValue().toString()%>'>
					</td>
					<%
						}
					else
					{
					%>	
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="password" name="exis_mother_maiden_name" size="35" maxlength = '100' id="exis_mother_maiden_name"  readonly disabled=true  class="sizeofbox"  value = '********************'>
					</td>
					<input type="hidden" name="wdesk:mother_maiden_name_exis" size="35" maxlength = '100' id="wdesk:mother_maiden_name_exis"  readonly disabled=true  class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("mother_maiden_name_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("mother_maiden_name_exis")).getAttribValue().toString()%>'>
					
						<%
						}
					%>	
				
					<!-- added below for Mail Schedule report added on 11062018 by Angad -->
					<%										
					if(WSNAME.equalsIgnoreCase("OPS_Checker_Review"))
					{
					%>
						<input type='hidden' name="wdesk:ProcessedDateAtChecker" id="wdesk:ProcessedDateAtChecker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ProcessedDateAtChecker")).getAttribValue().toString()%>'/>
					<%
					}
					%>
				
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text"   class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');" name="wdesk:mother_maiden_name_new" size="35"
  					onkeyup="validateKeys(this,'alphabetic');"onchange="docReq(this,'Mother Maiden Name','mother_maiden_name_new_doc');CIFtrackGridFields('CIF Data Update','Mother\'s Maiden Name Update');tosavedocuments();" maxlength='100' id="wdesk:mother_maiden_name_new"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("mother_maiden_name_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("mother_maiden_name_new")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="mother_maiden_name_new_doc" size="35" id="mother_maiden_name_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
				
				</tr>
				<tr>
					
					<textarea  style="width:100%;display:none" rows="3" cols="50"  name="wdesk:TypeOfRelation_exis" size="35" maxlength = '4' id="wdesk:TypeOfRelation_exis" readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("TypeOfRelation_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TypeOfRelation_exis")).getAttribValue().toString()%>'></textarea>
					
					<select style="width:100%;display:none" class='NGReadOnlyView' id="TypeOfRelationNew" name="TypeOfRelationNew"  multiple size="8"  style="width:auto;" onblur="getValuereltype()"></select>
					
					<input type="hidden" name="TypeOfRelation_new_doc" size="35" id="TypeOfRelation_new_doc"  readonly disabled=true class="sizeofbox" >
					
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Non Resident</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:nonResident" size="35" maxlength = '5'id="wdesk:nonResident" readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("nonResident")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("nonResident")).getAttribValue().toString()%>'>
					</td>

						<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
							<select class='NGReadOnlyView' id="nonResident_new" name="nonResident_new"  maxlength = '3' style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');mandatorycheck('emirates');CIFtrackGridFields('CIF Data Update','Non Resident Update');" >
								<option value="--Select--">--Select--</option>
								<option value="Yes">Yes</option>								
								<option value="NO">No</option>
							</select>
						</td>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"  
						name="USrelation_new_doc" size="35" id="nonResident_new_doc"  readonly disabled=true class="sizeofbox" >
						</td>						
					</tr>

				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">US Relation</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:USrelation" size="35" maxlength = '5'id="wdesk:USrelation" readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("USrelation")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("USrelation")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="USrelation_new" name="USrelation_new"  maxlength = '5' style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','US Relation Update');EnableDisableFieldChange('USRelation');" >
					<option value="--Select--">--Select--</option>
						
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"  
					name="USrelation_new_doc" size="35" id="USrelation_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>						
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id = "mfatcadoc" class='EWNormalGreenGeneral1' colspan="1">Fatca Document</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><textarea style="width: 100%;" rows="3" cols="50" style="width: 100%;" rows="6" cols="10" name="wdesk:FatcaDoc" size="35" maxlength = '5'id="wdesk:FatcaDoc" readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("FatcaDoc")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FatcaDoc")).getAttribValue().toString()%>'></textarea>
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<div id='FatcaDocNewList' style="OVERFLOW: auto;WIDTH: 220px;HEIGHT: 100px" onscroll="OnDivScroll(this.id);" >
							<select class='NGReadOnlyView' id="FatcaDocNew" name="FatcaDocNew"  multiple size="6"  style="width:auto;"onblur="getValueFatcaDoc();loopSelected();CIFtrackGridFields('CIF Data Update','Fatca Document')" ></select>
						</div>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="FatcaDoc_new_doc" size="35" id="FatcaDoc_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
				</tr>
				<!--Added By Nikita to add fatca Reason-->
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Fatca Reason/Type of Relation</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><textarea style="width: 100%;" rows="3" cols="50" style="width: 100%;" rows="6" cols="10" name="wdesk:FatcaReason" size="35" maxlength = '5'id="wdesk:FatcaReason" readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("FatcaReason")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FatcaReason")).getAttribValue().toString()%>'></textarea>
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
				<div id='FatcaReasonNewList' style="OVERFLOW: auto;Width :220px:HEIGHT: 100px" onscroll="OnDivScroll(this.id);" >
							<select class='NGReadOnlyView' id="FatcaReasonNew" name="FatcaReasonNew" multiple size="6" style="width:auto;"
							onblur="getValueFatcaReason();CIFtrackGridFields('CIF Data Update','Fatca Reason')" ></select>
						</div>
						</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="FatcaReason_new_doc" size="35" id="FatcaReason_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Signed Date</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<%
					if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
						 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input onkeyup="validateKeys(this,'Date');"  type="date" name="wdesk:SignedDate_exis"  size="35" maxlength = '20' id="wdesk:SignedDate_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("SignedDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SignedDate_exis")).getAttribValue().toString()%>'>
					<% }
					else {
						//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
					%>
					<input onkeyup="validateKeys(this,'Date');"  type="text" name="wdesk:SignedDate_exis"  size="35" maxlength = '20' id="wdesk:SignedDate_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("SignedDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SignedDate_exis")).getAttribValue().toString()%>'>
						<% }
					%>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  onchange = 'docReq(this,"Signed date","SignedDate_new_doc");optimizedate("SignedDate");validateDate();expiryDateset();CIFtrackGridFields("CIF Data Update","Signed Date Update")'  style="width: 100%;" name="wdesk:SignedDate_new" size="35"  maxlength = '20' id="wdesk:SignedDate_new"  <%try{
					%> value='<%=(((CustomWorkdeskAttribute)attributeMap.get("SignedDate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("SignedDate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("SignedDate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="SignedDate_new_doc" size="35" id="SignedDate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
						Expiry Date
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
						<%
						if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
							 //WriteLog("User-Agent: "+request.getHeader("User-Agent"));
						%>
						<input onkeyup="validateKeys(this,'Date');"  type="date" name="wdesk:ExpiryDate_exis" size="35" maxlength = '20' id="wdesk:ExpiryDate_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_exis")).getAttribValue().toString()%>'>
						<% }
						else {
							//WriteLog("User-Agent: "+request.getHeader("User-Agent"));
						%>
						<input onkeyup="validateKeys(this,'Date');"  type="text" name="wdesk:ExpiryDate_exis" size="35" maxlength = '20' id="wdesk:ExpiryDate_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_exis")).getAttribValue().toString()%>'>
						<% }
						%>	
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" class='NGReadOnlyView' disabled  style="width: 100%;" onchange = 'optimizedate("ExpiryDate");validateDate();CIFtrackGridFields("CIF Data Update","Expiry Date");' name="wdesk:ExpiryDate_new" size="35"  maxlength = '20' id="wdesk:ExpiryDate_new" <%try{%> value='<%=(((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>					
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="ExpiryDate_new_doc" size="35" id="ExpiryDate_new_doc"  readonly disabled=true class="sizeofbox">
					</td>					
				</tr>			
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">AECB Eligible?</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:abcdelig_exis" size="35" maxlength = '5'id="wdesk:abcdelig_exis" readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("abcdelig_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("abcdelig_exis")).getAttribValue().toString()%>'>
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="abcdelig_new" name="abcdelig_new"  maxlength = '3' style="width: 100%;"  onchange="docReq(this,'AECB Eligible?','abcdelig_new_doc');changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','AECB Details Update');tosavedocuments();">
							<option value="--Select--">--Select--</option>
							<option value="No">No</option>
							<option value="Yes">Yes</option>
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="abcdelig_new_doc" size="35" id="abcdelig_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>							
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Preference of Language</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:prefOfLanguage_exis" size="35" id="wdesk:prefOfLanguage_exis" readonly disabled=true class="sizeofbox">
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select class='NGReadOnlyView' id="prefOfLanguage" style="width: 100%;" name="prefOfLanguage" onchange="changeVal(this,'<%=WSNAME%>')">
								<option value="--Select--">--Select--</option>
								<option selected="selected" value="ENGLISH">ENGLISH</option>
								<option value="ARABIC">ARABIC</option>
								</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="prefOfLanguage_doc" size="35" id="prefOfLanguage_doc"  readonly disabled=true class="sizeofbox" >
					</td>							
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Special Support Required</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:peopleOfDeterm_exis" size="35" id="wdesk:peopleOfDeterm_exis" readonly disabled=true class="sizeofbox">
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select class='NGReadOnlyView' id="peopleOfDeterm" style="width: 100%;" name="peopleOfDeterm" onchange="changeVal(this,'<%=WSNAME%>');enablePODOptions()">
								<option value="--Select--">--Select--</option>
								<option value="Yes">Yes</option>
								<option selected="selected" value="No">No</option>
								</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="peopleOfDeterm_doc" size="35" id="peopleOfDeterm_doc"  readonly disabled=true class="sizeofbox" >
					</td>							
				</tr>
				<tr width=100% rowspan="5">
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">People of Determination Options</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<textarea class='NGReadOnlyView' style="width: 100%;" rows="3" cols="50" name="wdesk:PODOptions_exis" maxlength="250" id="wdesk:PODOptions_exis" readonly disabled=true></textarea>
					</td> 
					<td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PODOptions" style="width: 100%;" name="PODOptions" onchange="changeVal(this,'<%=WSNAME%>');enablePODRemarks()">
								<option value="HEAR">Hearing</option>
								<option value="COGN">Cognitive</option>
								<option value="NEUR">Neurological</option>
								<option value="PHYS">Physical</option>
								<option value="SPCH">Speech</option>
								<option value="VISL">Visual</option>
								<option value="OTHR">Others</option>
								</select>
					</td>
					<td  nowrap='nowrap' height ='22' width = 25% class='EWNormalGreenGeneral1' valign="middle"> 
						<input type="button" id="addButtonPODOptions" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPODOptions('PODOptions','PODOptionsSeleceted');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPODOptions" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onClick="RemovePODOptions('PODOptions','PODOptionsSeleceted');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PODOptionsSeleceted'  name='PODOptionsSeleceted' multiple='multiple' style="width:150px">
						</select>

					</td>
					
					</tr>	
					</table>
					</td>
						
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="PODOptions_doc" size="35" id="PODOptions_doc"  readonly disabled=true class="sizeofbox" >
					</td>							
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">People of Determination Remarks</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<textarea class='NGReadOnlyView' style="width: 100%;" rows="3" cols="50" name="wdesk:PODRemarks_exis" maxlength="250" id="wdesk:PODRemarks_exis" readonly disabled=true></textarea>
					</td>
						
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><textarea style="width: 100%;" rows="3" cols="50" style="width: 100%;" rows="3" cols="50" name="wdesk:PODRemarks" maxlength = '250' id="wdesk:PODRemarks" disabled=true class='NGReadOnlyView'><%=((CustomWorkdeskAttribute)attributeMap.get("PODRemarks")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PODRemarks")).getAttribValue().toString()%></textarea></td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="PODRemarks_doc" size="35" id="PODRemarks_doc"  readonly disabled=true class="sizeofbox" >
					</td>							
				</tr>
				<!--Added by Shamily to add OECD Details Fields  -->
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1" 
					id="contact_details"><b><font color="#FF4747">OECD Details</font></b></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
		  
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="OecdCitym" class='EWNormalGreenGeneral1' colspan="1">City Of Birth</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcity" size="35" maxlength = '100' id="wdesk:Oecdcity"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcity")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcity")).getAttribValue().toString()%>'>
					</td>
					<td>
					<%
					if(WSNAME.equalsIgnoreCase("CSO") || WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("CSO_Rejects"))
					{
							Querycity="select distinct cityname from USR_0_CU_CityMaster with(nolock) where 1=:ONE order by cityname ASC ";
							 //WriteLog"Query for getting USR_0_CU_CityMaster");
							params = "ONE==1";
							
							inputXMLcity = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Querycity + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
							
							//inputXMLcity = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Querycity + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
							 //WriteLog("inputXMLcity exceptions-->"+inputXMLcity);
							outputXMLcity = WFCustomCallBroker.execute(inputXMLcity, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							 //WriteLog("outputXMLcity exceptions-->"+outputXMLcity);
							
							xmlParserDatacity=new WFCustomXmlResponse();
							xmlParserDatacity.setXmlString((outputXMLcity));
							mainCodeValuecity = xmlParserDatacity.getVal("MainCode");
							
							recordcountcity=Integer.parseInt(xmlParserDatacity.getVal("TotalRetrieved"));
							itemscity="";
							if(mainCodeValuecity.equals("0"))
							{
								objWorkList = xmlParserDatacity.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
								{
									if(itemscity.equals(""))
									{
										itemscity=objWorkList.getVal("cityname").replace("'"," ");
									}	
									else 
									{
										itemscity+=","+objWorkList.getVal("cityname").replace("'"," ");
									}		
								}
								itemscity="{Oecdcity_new="+itemscity+"}";
						%>						
						
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:Oecdcity_new" id="wdesk:Oecdcity_new"  data-toggle='tooltip' size="7" maxlength = '50'   onkeyup="validateKeys(this,'alphanumeric2');" onchange="CIFtrackGridFields('CIF Data Update','OECD Update');docReq(this,'Office Address','officeadd_new_doc');" onblur = "validatecity('wdesk:Oecdcity_new','<%=itemscity%>')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcity_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcity_new")).getAttribValue().toString()%>'>
							</td>		
						<input type=hidden name='AutocompleteValues' id='AutocompleteValues' style='visibility:hidden' value='<%=itemscity%>'>									
						<%
					}
				}	
					else{
					%>
						
						<input type="text" readonly disabled=true class='NGReadOnlyView'  style="width: 100%;" name="wdesk:Oecdcity_new" id="wdesk:Oecdcity_new"  data-toggle='tooltip' size="7" maxlength = '50'   onkeyup="validateKeys(this,'alphanumeric2');" onchange="CIFtrackGridFields('CIF Data Update','OECD Update');docReq(this,'Office Address','officeadd_new_doc');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcity_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcity_new")).getAttribValue().toString()%>'>
							</td>					
					<%
					}
					%>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcity_new_doc" size="35" id="Oecdcity_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  id ="OecdCntrym" class='EWNormalGreenGeneral1' colspan="1">Country Of Birth </td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountry" size="35" maxlength = '100' id="wdesk:Oecdcountry"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountry")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountry")).getAttribValue().toString()%>'>
					</td>
										<%						
						if(WSNAME.equalsIgnoreCase("CSO") || WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("CSO_Rejects"))
						{
							Querycountry="select distinct countryName from USR_0_CU_CountryMaster with(nolock) where 1=:ONE order by countryName ASC";
							params = "ONE==1";
							 //WriteLog"Query for getting USR_0_CU_CityMaster");
							
							inputXMLcountry = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Querycountry + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
							
							//inputXMLcountry = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Querycountry + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
							
							 //WriteLog"inputXMLcountry exceptions-->"+inputXMLcountry);
							outputXMLcountry = WFCustomCallBroker.execute(inputXMLcountry, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							 //WriteLog"outputXMLcountry exceptions-->"+outputXMLcountry);
							
							xmlParserDatacountry=new WFCustomXmlResponse();
							xmlParserDatacountry.setXmlString((outputXMLcountry));
							mainCodeValuecountry = xmlParserDatacountry.getVal("MainCode");
							
							recordcountcountry=Integer.parseInt(xmlParserDatacountry.getVal("TotalRetrieved"));
							itemscountry="";
							if(mainCodeValuecountry.equals("0"))
							{
								objWorkList = xmlParserDatacountry.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
								{
									if(itemscountry.equals(""))
									{
										itemscountry=objWorkList.getVal("countryName").replace("'"," ");
									}	
									else 
									{
										itemscountry+=","+objWorkList.getVal("countryName").replace("'"," ");
									}		
								}
								//itemscountry="{"+itemscountry+"}";
								
					%>
						<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountry_new"    id="wdesk:Oecdcountry_new" onblur = "validatecity('wdesk:Oecdcountry_new','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountry_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountry_new")).getAttribValue().toString()%>' >
					</td>
					<input type=hidden name='AutocompleteValuesCountry' id='AutocompleteValuesCountry' style='visibility:hidden' value='<%=itemscountry%>'>	
					<%
					}
					}
					else
					{
					%>	
					
					<td nowrap='nowrap' readonly disabled=true class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountry_new"    id="wdesk:Oecdcountry_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountry_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountry_new")).getAttribValue().toString()%>' >
					</td>
					<%
					}
					%>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountry_new_doc" size="35" id="Oecdcountry_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id = "CRSUndocm" class='EWNormalGreenGeneral1 ' colspan="1">CRS Undocumented Flag</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDUndoc_Flag" size="35" maxlength = '100' id="wdesk:OECDUndoc_Flag"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OECDUndoc_Flag")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDUndoc_Flag")).getAttribValue().toString()%>'>
					</td>					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' ><select class='NGReadOnlyView' id="OECDUndoc_Flag_new"   name="OECDUndoc_Flag_new" maxlength = '100' style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');mandatorycheck('OecdCntryTax1');CIFtrackGridFields('CIF Data Update','OECD Update');EnableDisableFieldChange('OECDUndoc_Flag');">
						<option value="--Select--">--Select--</option>
						<option value="No">No</option>
						<option value="Yes">Yes</option>
					</select>
					</td>
						
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDUndoc_Flag_new_doc" size="35" id="OECDUndoc_Flag_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
							
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="CRSUndocReasonm" class='EWNormalGreenGeneral1' colspan="1">CRS Undocumented Flag Reason </td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDUndocreason_exist" size="35" maxlength = '100' id="wdesk:OECDUndocreason_exist"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OECDUndocreason_exist")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDUndocreason_exist")).getAttribValue().toString()%>'>
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDUndocreason_new"  name="OECDUndocreason_new" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDUndocreason_new_doc" size="35" id="OECDUndocreason_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  id = 'OecdCntryTax1' class='EWNormalGreenGeneral1' colspan="1">Country Of Tax Residence 1</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountrytax" size="35" maxlength = '100' id="wdesk:Oecdcountrytax"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountrytax_new"  onblur = "validatecity('wdesk:Oecdcountrytax_new','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update');"  id="wdesk:Oecdcountrytax_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountrytax_new_doc" size="35" id="Oecdcountrytax_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Tax Payer Identification Number 1</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OecdTin" size="35" maxlength = '100' id="wdesk:OecdTin"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:OecdTin_new"    id="wdesk:OecdTin_new" onchange = 'CIFtrackGridFields("CIF Data Update","OECD Update")' value='<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new")).getAttribValue().toString()%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OecdTin_new_doc" size="35" id="OecdTin_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">No TIN Reason 1</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDtinreason_exist" size="35" maxlength = '100' id="wdesk:OECDtinreason_exist"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist")).getAttribValue().toString()%>'>
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDtinreason_new"  name="OECDtinreason_new" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update')" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDtinreason_new_doc" size="35" id="OECDtinreason_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Country Of Tax Residence 2</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountrytax2" size="35" maxlength = '100' id="wdesk:Oecdcountrytax2"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax2")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountrytax_new2"    id="wdesk:Oecdcountrytax_new2" onblur = "validatecity('wdesk:Oecdcountrytax_new2','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new2")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountrytax_new_doc2" size="35" id="Oecdcountrytax_new_doc2"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Tax Payer Identification Number 2</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OecdTin2" size="35" maxlength = '100' id="wdesk:OecdTin2"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin2")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:OecdTin_new2"    id="wdesk:OecdTin_new2" onchange = "CIFtrackGridFields('CIF Data Update','OECD Update')" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new2")).getAttribValue().toString()%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OecdTin_new_doc2" size="35" id="OecdTin_new_doc2"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">No TIN Reason 2</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDtinreason_exist2" size="35" maxlength = '100' id="wdesk:OECDtinreason_exist2"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist2")).getAttribValue().toString()%>'>
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDtinreason_new2"  name="OECDtinreason_new2" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDtinreason_new_doc2" size="35" id="OECDtinreason_new_doc2"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Country Of Tax Residence 3</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountrytax3" size="35" maxlength = '100' id="wdesk:Oecdcountrytax3"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax3")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountrytax_new3"    id="wdesk:Oecdcountrytax_new3" onblur = "validatecity('wdesk:Oecdcountrytax_new3','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update')" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new3")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountrytax_new_doc3" size="35" id="Oecdcountrytax_new_doc3"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Tax Payer Identification Number 3</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OecdTin3" size="35" maxlength = '100' id="wdesk:OecdTin3"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin3")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:OecdTin_new3"    id="wdesk:OecdTin_new3"  onchange = "CIFtrackGridFields('CIF Data Update','OECD Update');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new3")).getAttribValue().toString()%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OecdTin_new_doc3" size="35" id="OecdTin_new_doc3"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">No TIN Reason 3</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDtinreason_exist3" size="35" maxlength = '100' id="wdesk:OECDtinreason_exist3"  readonly disabled=true class="sizeofbox"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist3")).getAttribValue().toString()%>'>
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDtinreason_new3"  name="OECDtinreason_new3" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDtinreason_new_doc3" size="35" id="OECDtinreason_new_doc3"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Country Of Tax Residence 4</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountrytax4" size="35" maxlength = '100' id="wdesk:Oecdcountrytax4"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax4")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountrytax_new4"    id="wdesk:Oecdcountrytax_new4"  onblur = "validatecity('wdesk:Oecdcountrytax4','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update')" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new4")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountrytax_new_doc3" size="35" id="Oecdcountrytax_new_doc3"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Tax Payer Identification Number 4</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OecdTin4" size="35" maxlength = '100' id="wdesk:OecdTin4"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin4")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:OecdTin_new4"    id="wdesk:OecdTin_new4" onchange = "CIFtrackGridFields('CIF Data Update','OECD Update');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new4")).getAttribValue().toString()%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OecdTin_new_doc4" size="35" id="OecdTin_new_doc4"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">No TIN Reason 4</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDtinreason_exist4" size="35" maxlength = '100' id="wdesk:OECDtinreason_exist4"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist4")).getAttribValue().toString()%>' >
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDtinreason_new4"  name="OECDtinreason_new4" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDtinreason_new_doc4" size="35" id="OECDtinreason_new_doc4"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Country Of Tax Residence 5</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountrytax5" size="35" maxlength = '100' id="wdesk:Oecdcountrytax5"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax5")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountrytax_new5"    id="wdesk:Oecdcountrytax_new5" onblur = "validatecity('wdesk:Oecdcountrytax_new5','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new5")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountrytax_new_doc5" size="35" id="Oecdcountrytax_new_doc5"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Tax Payer Identification Number 5</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OecdTin5" size="35" maxlength = '100' id="wdesk:OecdTin5"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin5")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:OecdTin_new5"    id="wdesk:OecdTin_new5" onchange = "CIFtrackGridFields('CIF Data Update','OECD Update');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new5")).getAttribValue().toString()%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OecdTin_new_doc5" size="35" id="OecdTin_new_doc5"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">No TIN Reason 5</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDtinreason_exist5" size="35" maxlength = '100' id="wdesk:OECDtinreason_exist5"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist5")).getAttribValue().toString()%>' >
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDtinreason_new5"  name="OECDtinreason_new5" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDtinreason_new_doc5" size="35" id="OECDtinreason_new_doc5"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Country Of Tax Residence 6</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:Oecdcountrytax6" size="35" maxlength = '100' id="wdesk:Oecdcountrytax6"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax6")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:Oecdcountrytax_new6"    id="wdesk:Oecdcountrytax_new6" onblur = "validatecity('wdesk:Oecdcountrytax_new6','<%=itemscountry%>');CIFtrackGridFields('CIF Data Update','OECD Update')" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Oecdcountrytax_new6")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="Oecdcountrytax_new_doc6" size="35" id="Oecdcountrytax_new_doc6"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap'  class='EWNormalGreenGeneral1' colspan="1">Tax Payer Identification Number 6</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OecdTin6" size="35" maxlength = '100' id="wdesk:OecdTin6"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin6")).getAttribValue().toString()%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:OecdTin_new6"    id="wdesk:OecdTin_new6" onchange = "CIFtrackGridFields('CIF Data Update','OECD Update')" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OecdTin_new6")).getAttribValue().toString()%>' >
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OecdTin_new_doc6" size="35" id="OecdTin_new_doc6"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">No TIN Reason 6</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:OECDtinreason_exist6" size="35" maxlength = '100' id="wdesk:OECDtinreason_exist6"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_exist6")).getAttribValue().toString()%>' >
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="OECDtinreason_new6"  name="OECDtinreason_new6" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','OECD Update');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="OECDtinreason_new_doc6" size="35" id="OECDtinreason_new_doc6"  readonly disabled=true class="sizeofbox" >
					</td>
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1" id="contact_details"><b><font color="#FF4747">Contact Details</font></b></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
		  
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>							
				</tr>
			
				<tr width=100%>
					<td  nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="4" 
					id="Residence_details">Residence Address</td>
				</tr>
				<tr width=100%>
					<td>				
						<table border='1' cellspacing='1' cellpadding='0' width=100% style="border-right-style: none; border-left-style: none;">	
							<tr><td nowrap='nowrap' id = "Rflatno" class='EWNormalGreenGeneral1'>Flat Number</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Building Name</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Street Name</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Residence Type</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Landmark</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Zip Code</td></tr>
							<tr><td nowrap='nowrap' id ="rpobox" class='EWNormalGreenGeneral1'>PO Box</td></tr>
							<tr><td nowrap='nowrap' id="rcity" class='EWNormalGreenGeneral1'>Emirates/City</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>State</td></tr>
							<tr><td nowrap='nowrap' id="rcountry"class='EWNormalGreenGeneral1'>Country</td></tr>
						</table>
					</td>
					
					  <td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><textarea style="width: 100%;" rows="6" cols="10"  id="resiadd_exis" name="resiadd_exis" readonly disabled=true onchange="changeVal(this,'<%=WSNAME%>')"><%=((CustomWorkdeskAttribute)attributeMap.get("resiadd_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resiadd_exis")).getAttribValue().toString()%></textarea>
					</td>
									
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:resi_line1" id="wdesk:resi_line1" size="35" maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');" placeholder="Flat No./Designation" onchange="docReq(this,'Residence Address','resiadd_new_doc');CIFtrackGridFields('CIF Data Update','Residence Address Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_line1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_line1")).getAttribValue().toString()%>'>
					<br>
					<input type="text" class='NGReadOnlyView' style="width: 100%;"  name="wdesk:resi_line2" id="wdesk:resi_line2" size="35" maxlength = '50' placeholder="Building Name" onkeyup="validateKeys(this,'alphanumeric_address');"  onchange="docReq(this,'Residence Address','resiadd_new_doc');CIFtrackGridFields('CIF Data Update','Residence Address Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_line2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_line2")).getAttribValue().toString()%>'> 
					<br>
					<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:resi_line3" id="wdesk:resi_line3" size="35" maxlength = '50' placeholder="Street name" onkeyup="validateKeys(this,'alphanumeric_address');"  onchange="docReq(this,'Residence Address','resiadd_new_doc');CIFtrackGridFields('CIF Data Update','Residence Address Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_line3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_line3")).getAttribValue().toString()%>'>					
					<br>					
					<input type="hidden"  style="width: 32%;" name="wdesk:resi_restype" id="wdesk:resi_restype" size="7" placeholder="Residence Type" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_restype")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_restype")).getAttribValue().toString()%>'>
					
					
					<select class='NGReadOnlyView' id="resi_restype"  name="resi_restype" placeholder="Residence Type" maxlength = '50' style="width: 100%;" onkeyup="validateKeys(this,'alphanumeric2');" onchange="docReq(this,'Residence Address','resiadd_new_doc');changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Residence Address Update');">
							<option value="--Select--">--Select--</option>
						</select>					
					<br>
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:resi_line4" id="wdesk:resi_line4" size="35" maxlength = '50' placeholder="Landmark" onkeyup="validateKeys(this,'alphanumeric_address');"  onchange="docReq(this,'Residence Address','resiadd_new_doc');CIFtrackGridFields('CIF Data Update','Residence Address Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_line4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_line4")).getAttribValue().toString()%>'>
					<br>
					
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:resi_zipcode" id="wdesk:resi_zipcode" maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');"  onchange="CIFtrackGridFields('CIF Data Update','Residence Address Update');docReq(this,'Residence Address','resiadd_new_doc');" size="7" placeholder="Zip Code" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_zipcode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_zipcode")).getAttribValue().toString()%>'>
					<br>
					
					<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:resi_pobox" id="wdesk:resi_pobox" maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');"  onchange="CIFtrackGridFields('CIF Data Update','Residence Address Update');docReq(this,'Residence Address','resiadd_new_doc');tosavedocuments();" size="7" placeholder="PO Box" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_pobox")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_pobox")).getAttribValue().toString()%>' >					
					
					<!-- modified to auto populate the city state for UAE country-->
					 <%						
						if(WSNAME.equalsIgnoreCase("CSO") || WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("CSO_Rejects"))
						{
							
								
							%>
					<br>
								<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:resi_city" id="wdesk:resi_city" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value'  maxlength = '50' size="7" onkeyup="validateKeys(this,'alphanumeric2');"  onchange="CIFtrackGridFields('CIF Data Update','Residence Address Update');docReq(this,'Residence Address','resiadd_new_doc');" onblur = "validatecity('wdesk:resi_city','<%=itemscity%>');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_city")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_city")).getAttribValue().toString()%>'>
								
								
								<input type=hidden name='AutocompleteValuesresicityAE' id='AutocompleteValuesresicityAE' style='visibility:hidden' value='<%=itemscity%>'>	
								<input type=hidden name='AutocompleteValuesresicitynotAE' id='AutocompleteValuesresicitynotAE' style='visibility:hidden' value=''>	
											
							<%
							}
						else
						{			
						%>		
							<br>
								<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:resi_city" id="wdesk:resi_city" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value'  maxlength = '50' size="7" onkeyup="validateKeys(this,'alphanumeric2');"  onchange="CIFtrackGridFields('CIF Data Update','Residence Address Update');docReq(this,'Residence Address','resiadd_new_doc');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_city")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_city")).getAttribValue().toString()%>'>	
						<%
						}
						%>
						
						<!-- modified to auto populate the city state for UAE country-->
							<!--<input type="hidden"   name="wdesk:resi_city" id="wdesk:resi_city"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_city")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_city")).getAttribValue().toString()%>'> -->
						<%
						if(WSNAME.equalsIgnoreCase("CSO") || WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("CSO_Rejects"))
						{
							Querystate="select distinct statename from usr_0_cu_statemaster with(nolock) where 1=:ONE order by statename ASC";
							 //WriteLog"Query for getting usr_0_cu_statemaster resi_state");
							params = "ONE==1";
							
							inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Querystate + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
							
							//inputXMLstate = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Querystate + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
							
							 //WriteLog"inputXMLstate exceptions-->"+inputXMLstate);
							outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							 //WriteLog"outputXMLstate exceptions resi_state-->"+outputXMLstate);
							
							xmlParserDatastate=new WFCustomXmlResponse();
							xmlParserDatastate.setXmlString((outputXMLstate));
							mainCodeValuestate = xmlParserDatastate.getVal("MainCode");
							
							
							recordcountstate=Integer.parseInt(xmlParserDatastate.getVal("TotalRetrieved"));
							itemsstate="";

							if(mainCodeValuestate.equals("0"))
							{
								objWorkList = xmlParserDatastate.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
								{
									if(itemsstate.equals(""))
									{
										itemsstate=objWorkList.getVal("statename").replace("'"," ");
									}	
									else 
									{
										itemsstate+=","+objWorkList.getVal("statename").replace("'"," ");
									}		
								}
								itemsstate="{resi_state="+itemsstate+"}";
					
								%>
								
								<br>
										<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:resi_state" id="wdesk:resi_state" size="7" maxlength = '50'  onkeyup="validateKeys(this,'alphanumeric2');"  onchange="CIFtrackGridFields('CIF Data Update','Residence Address Update');docReq(this,'Residence Address','resiadd_new_doc');" onblur="validatecity('wdesk:resi_state','<%=itemsstate%>')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_state")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_state")).getAttribValue().toString()%>'>
								
								<input type=hidden name='AutocompleteValuesState' id='AutocompleteValuesState' style='visibility:hidden' value='<%=itemsstate%>'>
								<input type=hidden name='AutocompleteValuesStateAE' id='AutocompleteValuesStateAE' style='visibility:hidden' value='<%=itemsstate%>'>
								<input type=hidden name='AutocompleteValuesStatenotAE' id='AutocompleteValuesStatenotAE' style='visibility:hidden' value=''>
								
							
								<%
							}
						}	
						else
						{
							%>
							<br>
								<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:resi_state" id="wdesk:resi_state" size="7" maxlength = '50'  onkeyup="validateKeys(this,'alphanumeric2');"  onchange="CIFtrackGridFields('CIF Data Update','Residence Address Update');docReq(this,'Residence Address','resiadd_new_doc');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_state")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_state")).getAttribValue().toString()%>'>								
						<%
						}					
						%>	
						<!--<input type="hidden"   name="wdesk:resi_state" id="wdesk:resi_state"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_state")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_state")).getAttribValue().toString()%>'>	-->					
					<br>
					<input type="hidden"  style="width: 100%;"  name="wdesk:resi_cntrycode" id="wdesk:resi_cntrycode" size="7"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_cntrycode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_cntrycode")).getAttribValue().toString()%>'>
					
					<select class='NGReadOnlyView' id="resi_cntrycode" name="resi_cntrycode" placeholder="Country" maxlength = '50' style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Residence Address Update');Countrymapping('<%=WSNAME%>')">
						<option value="--Select--">--Select--</option>	
					</select>
					
					<input type="hidden"  style="width: 100%;" name="wdesk:resi_curr_years" id="wdesk:resi_curr_years" size="35" maxlength = '3' placeholder="Years Since in Current Address" onkeyup="validateKeys(this,'Numeric');"  <%try{%>value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resi_curr_years")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_curr_years")).getAttribValue().toString()%>'<%}catch(Exception e){}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="resiadd_new_doc" size="35" id="resiadd_new_doc" readonly disabled=true class="sizeofbox" >
					</td>				
				</tr>
				
				<tr width=100%>
					<td  nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="4" 
					id="office_details">Office Address</td>	
				</tr>
				
				<tr width=100%>
					<td>
						<table border='1' cellspacing='1' cellpadding='0' width=100% style="border-right-style: none; border-left-style: none;">	
							<tr><td nowrap='nowrap' id="oflatno" class='EWNormalGreenGeneral1'>Flat No./Designation</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Bldg/Employer Name</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Street/Dep't + Emp Id</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Residence Type</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Landmark</td></tr>
							<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1'>Zip Code</td></tr>
							<tr><td nowrap='nowrap' id="opobox" class='EWNormalGreenGeneral1'>PO Box</td></tr>
							<tr><td nowrap='nowrap' id="ocity" class='EWNormalGreenGeneral1'>Emirates/City</td></tr>
							<tr><td nowrap='nowrap'  class='EWNormalGreenGeneral1'>State</td></tr>
							<tr><td nowrap='nowrap' id="ocountry" class='EWNormalGreenGeneral1'>Country</td></tr>							
						</table>
						
					</td>
				    <td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><textarea style="width: 100%;" rows="6" cols="10"  id="office_add_exis" name="office_add_exis" readonly disabled=true onchange="changeVal(this,'<%=WSNAME%>')"><%=((CustomWorkdeskAttribute)attributeMap.get("office_add_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_add_exis")).getAttribValue().toString()%></textarea>
					</td>				   
						
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:office_line1" id="wdesk:office_line1" size="35" maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');" placeholder="Flat No./Designation"  onchange="docReq(this,'Office Address','officeadd_new_doc');CIFtrackGridFields('CIF Data Update','Office Address Update');validateemptype();" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_line1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_line1")).getAttribValue().toString()%>'>
					<br>
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:office_line2" id="wdesk:office_line2" size="35"  maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');" placeholder="Bldg/Employer Name"   onchange="docReq(this,'Office Address','officeadd_new_doc');CIFtrackGridFields('CIF Data Update','Office Address Update');validateemptype()"value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_line2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_line2")).getAttribValue().toString()%>'> 
					<br>
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:office_line3" id="wdesk:office_line3" size="35" maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');" placeholder="Street/Dep't + Emp Id"  onchange="docReq(this,'Office Address','officeadd_new_doc');CIFtrackGridFields('CIF Data Update','Office Address Update');validateemptype()"value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_line3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_line3")).getAttribValue().toString()%>'>
					<br>
					<input type="hidden"  style="width: 100%;" name="wdesk:office_restype" id="wdesk:office_restype" size="7" placeholder="Country" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_restype")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_restype")).getAttribValue().toString()%>'>
					
					<select class='NGReadOnlyView' id="office_restype"  name="office_restype"  placeholder="Residence Type" maxlength = '50' style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');validateemptype()">							
						<option value="--Select--">--Select--</option>							
						</select>					
					<br>
					<input type="text"  class='NGReadOnlyView' style="width: 100%;" name="wdesk:office_line4" id="wdesk:office_line4" size="35" maxlength = '50' onkeyup="validateKeys(this,'alphanumeric_address');" placeholder="Landmark"  onchange="docReq(this,'Office Address','officeadd_new_doc');CIFtrackGridFields('CIF Data Update','Office Address Update');validateemptype()" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_line4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_line4")).getAttribValue().toString()%>'>
					<br>
					<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:office_zipcode" id="wdesk:office_zipcode" size="7" maxlength = '50' placeholder="Zip Code"   onkeyup="validateKeys(this,'alphanumeric_address');" onchange="CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');tosavedocuments();validateemptype()"value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_zipcode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_zipcode")).getAttribValue().toString()%>'>
					
					<br>
					<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:office_pobox" id="wdesk:office_pobox" size="7" maxlength = '50' placeholder="PO Box"  onkeyup="validateKeys(this,'alphanumeric_address');" onchange="CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');tosavedocuments();validateemptype()" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_pobox")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_pobox")).getAttribValue().toString()%>'>
					<!-- modified to auto populate the city state for UAE country-->
					<%
					if(WSNAME.equalsIgnoreCase("CSO") || WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("CSO_Rejects"))
					{
						%>						
						<br>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:office_city" id="wdesk:office_city"  data-toggle='tooltip' size="7" maxlength = '50'   onkeyup="validateKeys(this,'alphanumeric2');" onchange="CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');validateemptype()" onblur = "validatecity('wdesk:office_city','<%=itemscity%>')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_city")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_city")).getAttribValue().toString()%>'>
							
						<input type=hidden name='AutocompleteValuesofficecityAE' id='AutocompleteValuesofficecityAE' style='visibility:hidden' value='<%=itemscity%>'>		
						<input type=hidden name='AutocompleteValuesofficecitynotAE' id='AutocompleteValuesofficecitynotAE' style='visibility:hidden' value=''>	

						<%
					}
					else{
					%>
						<br>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:office_city" id="wdesk:office_city"  data-toggle='tooltip' size="7" maxlength = '50'   onkeyup="validateKeys(this,'alphanumeric2');" onchange="CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_city")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_city")).getAttribValue().toString()%>'>
												
					<%
					}
					%>
					<!-- modified to auto populate the city state for UAE country-->
				<!--	<input type="hidden"   name="wdesk:office_city" id="wdesk:office_city"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_city")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_city")).getAttribValue().toString()%>'>	 -->
					<%
					if(WSNAME.equalsIgnoreCase("CSO") || WSNAME.equalsIgnoreCase("OPS%20Maker_DE") || WSNAME.equalsIgnoreCase("CSO_Rejects"))
					{					
						%>						
						<br>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:office_state" id="wdesk:office_state" size="7"  data-toggle='tooltip'  maxlength = '50' onkeyup="validateKeys(this,'alphanumeric2');"  onchange="CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');validateemptype()" onblur = "validatecity('wdesk:office_state','<%=itemsstate%>')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_state")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_state")).getAttribValue().toString()%>'>				
				<input type=hidden name='AutocompleteValuesOffcState' id='AutocompleteValuesOffcState' style='visibility:hidden' value='<%=itemsstate%>'>	
				<input type=hidden name='AutocompleteValuesStateoffcAE' id='AutocompleteValuesStateoffcAE' style='visibility:hidden' value='<%=itemsstate%>'>
				<input type=hidden name='AutocompleteValuesStateoffcnotAE' id='AutocompleteValuesStateoffcnotAE' style='visibility:hidden' value=''>						
						<%				
					}	
					
					else
					{
						%>
							<br>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:office_state" id="wdesk:office_state" size="7"  data-toggle='tooltip'  maxlength = '50' onkeyup="validateKeys(this,'alphanumeric2');"  onchange="CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');"value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_state")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_state")).getAttribValue().toString()%>'>
					
					<%
					}
					%>
					
					<!--<input type="hidden"   name="wdesk:office_state" id="wdesk:office_state"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_state")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_state")).getAttribValue().toString()%>'>	-->
					<br>
					<input type="hidden"  style="width: 100%;" name="wdesk:office_cntrycode" id="wdesk:office_cntrycode" size="7" placeholder="Country" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_cntrycode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_cntrycode")).getAttribValue().toString()%>'>
					
					<select class='NGReadOnlyView' id="office_cntrycode"   name="office_cntrycode" placeholder="Country" maxlength = '50' style="width: 100%;"  onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Office Address Update');docReq(this,'Office Address','officeadd_new_doc');Countrymapping('<%=WSNAME%>');validateemptype();mandatorycheck('Oecd_city')"">
							<option value="--Select--">--Select--</option>							
						</select>
					
					<input type="hidden"  style="width: 100%;" name="wdesk:office_curr_years" id="wdesk:office_curr_years" size="35" maxlength = '3' placeholder="Years Since in Current Address" onkeyup="validateKeys(this,'Numeric');" <% try{ %> value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_curr_years")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_curr_years")).getAttribValue().toString()%>' <%} catch(Exception e){}%>>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="officeadd_new_doc" size="35" id="officeadd_new_doc"  readonly disabled=true class="sizeofbox">
					</td>				
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'  colspan="1">Preferred Address</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:pref_add_exis" size="35" maxlength = '100' id="wdesk:pref_add_exis"  readonly disabled=true class="sizeofbox">
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<select class='NGReadOnlyView' id="pref_add_new"  style="width: 100%;" name="pref_add_new" onchange="changeVal(this,'<%=WSNAME%>');docReq(this,'Preferred Address','pref_add_new_doc');CIFtrackGridFields('CIF Data Update','Residence Address Update');tosavedocuments();autoexisAddrpopulate();mandatorycheck('address');">
							<option value="--Select--">--Select--</option>
							<option value="Home">Home</option>
							<option value="Office">Office</option>
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="pref_add_new_doc" size="35" id="pref_add_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
				
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id="mprimarymail" class='EWNormalGreenGeneral1 ' colspan="1">Primary Email ID</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<input type="text" class='NGReadOnlyView' name="wdesk:prim_email_exis" size="35" maxlength = '100' id="wdesk:prim_email_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("prim_email_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("prim_email_exis")).getAttribValue().toString()%>'>
					</td>

							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  onkeyup="validateKeys(this,'alphanumeric2');"  style="width: 100%;"  size="35" maxlength = '50' name="wdesk:primary_emailid_new" id="wdesk:primary_emailid_new"  onchange="docReq(this,'Primary Email ID','prim_email_new_doc');CIFtrackGridFields('CIF Data Update','Email Id Update');checkEmail();tosavedocuments();" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("primary_emailid_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("primary_emailid_new")).getAttribValue().toString()%>'>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="prim_email_new_doc" size="35" id="prim_email_new_doc"  readonly disabled=true class="sizeofbox">
							</td>
							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Secondary Email ID</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:sec_email_exis" size="35" maxlength = '100' id="wdesk:sec_email_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sec_email_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sec_email_exis")).getAttribValue().toString()%>'>
					</td>

							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'alphanumeric2');" name="wdesk:sec_email_new" id ="wdesk:sec_email_new" onchange="docReq(this,'Secondary Email ID','secondary_emailid_new_doc');CIFtrackGridFields('CIF Data Update','Email Id Update');checkEmail1();tosavedocuments();" size="35" maxlength = '50'  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sec_email_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sec_email_new")).getAttribValue().toString()%>'>
							</td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="secondary_emailid_new_doc" size="35" id="secondary_emailid_new_doc"  readonly disabled=true class="sizeofbox">
							</td>
							
				</tr>
				<input type="hidden" name="wdesk:pref_email_exis" size="35" maxlength = '100' id="wdesk:pref_email_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("pref_email_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("pref_email_exis")).getAttribValue().toString()%>'>	
				<input type="hidden" id="pref_email_new"  name="pref_email_new" maxlength = '100' style="width: 100%;" onchange="docReq(this,'Preferred Email ID Type','pref_email_new_doc');CIFtrackGridFields('CIF Data Update','Email Id Update');tosavedocuments();changeVal(this,'<%=WSNAME%>');" >
				<input type="hidden" name="pref_email_new_doc" size="35" id="pref_email_new_doc"  readonly disabled=true class="sizeofbox">
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">E-Statement Registered</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:E_Stmnt_regstrd_exis" size="35" maxlength = '100' id="wdesk:E_Stmnt_regstrd_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("E_Stmnt_regstrd_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("E_Stmnt_regstrd_exis")).getAttribValue().toString()%>'>
					</td>					
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' ><select class='NGReadOnlyView' id="E_Stmnt_regstrd_new"   name="E_Stmnt_regstrd_new" maxlength = '100' style="width: 100%;" onchange="docReq(this,'E-Statement Registered','E_Stmnt_regstrd_new_doc');CIFtrackGridFields('CIF Data Update','E-Statement Activation');tosavedocuments();changeVal(this,'<%=WSNAME%>');mandatorycheck('Primarymail');">
									<option value="--Select--">--Select--</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
							</td>
						
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="E_Stmnt_regstrd_new_doc" size="35" id="E_Stmnt_regstrd_new_doc"  readonly disabled=true class="sizeofbox" >
							</td>
							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Mobile Phone</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">
					<input type="text" name="wdesk:MobilePhone_Existing" size="35" id="wdesk:MobilePhone_Existing"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_Existing")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_Existing")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text"  class='NGReadOnlyView' style="width: 32%;" onkeyup="validateKeys(this,'Numeric');" name="wdesk:MobilePhone_New1" id="wdesk:MobilePhone_New1" size="5" maxlength="5"  onchange = "homephnvalidate('mobphn1');mobvalidate('wdesk:MobilePhone_New1','wdesk:MobilePhone_New2','Mobile Phone 1');mandatorycheck('Oecd_city');CIFtrackGridFields('CIF Data Update','Primary Mobile Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_New1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_New1")).getAttribValue().toString()%>'>
					<input type="text" class='NGReadOnlyView' style="width: 20%;" onchange="docReq(this,'Mobile Phone','mob_phone_new_doc');CIFtrackGridFields('CIF Data Update','Primary Mobile Number Update');tosavedocuments();"onkeyup="validateKeys(this,'Numeric');" name="wdesk:MobilePhone_New" id="wdesk:MobilePhone_New" maxlength="3" size="5"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_New")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_New")).getAttribValue().toString()%>'>
					<input type="text" class='NGReadOnlyView' style="width: 44%;" name="wdesk:MobilePhone_New2" onkeyup="validateKeys(this,'Numeric');" id="wdesk:MobilePhone_New2" size="5" maxlength="15" onchange = "docReq(this,'Mobile Phone','mob_phone_new_doc');homephnvalidate('mobphn1');mobvalidate('wdesk:MobilePhone_New1','wdesk:MobilePhone_New2','Mobile Phone 1');CIFtrackGridFields('CIF Data Update','Primary Mobile Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_New2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MobilePhone_New2")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="mob_phone_new_doc" size="35" id="mob_phone_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Mobile Phone 2</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:sec_mob_phone_exis" size="35" id="wdesk:sec_mob_phone_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_exis")).getAttribValue().toString()%>'>
					</td>
                 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<input type="text" class='NGReadOnlyView' style="width: 32%;"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:sec_mob_phone_newC" id="wdesk:sec_mob_phone_newC"  size="5" maxlength="5" onchange= "homephnvalidate('mobphn2');mobvalidate('wdesk:sec_mob_phone_newC','wdesk:sec_mob_phone_newE','Mobile Phone 2');mandatorycheck('Oecd_city');CIFtrackGridFields('CIF Data Update','Primary Mobile Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_newC")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_newC")).getAttribValue().toString()%>'>
					
					<input type="text" class='NGReadOnlyView' style="width: 20%;" onchange="docReq(this,'Mobile Phone 2','sec_mob_phone_newN_doc');CIFtrackGridFields('CIF Data Update','Primary Mobile Number Update');tosavedocuments();"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:sec_mob_phone_newN"  id="wdesk:sec_mob_phone_newN" maxlength="3" size="12" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_newN")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_newN")).getAttribValue().toString()%>'>
					<input type="text"  class='NGReadOnlyView' style="width: 44%;"  onkeyup="validateKeys(this,'Numeric');"name="wdesk:sec_mob_phone_newE" id="wdesk:sec_mob_phone_newE" size="5" maxlength="15" onchange= "docReq(this,'Mobile Phone 2','sec_mob_phone_newN_doc');homephnvalidate('mobphn2');mobvalidate('wdesk:sec_mob_phone_newC','wdesk:sec_mob_phone_newE','Mobile Phone 2');CIFtrackGridFields('CIF Data Update','Primary Mobile Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_newE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sec_mob_phone_newE")).getAttribValue().toString()%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="sec_mob_phone_newN_doc" size="35" id="sec_mob_phone_newN_doc"  readonly disabled=true class="sizeofbox">
					</td>
							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Home Phone</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:homephone_exis" size="35" maxlength = '100' id="wdesk:homephone_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homephone_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homephone_exis")).getAttribValue().toString()%>'>
					</td>

					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  style="width: 32%;"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:homephone_newC" id="wdesk:homephone_newC" size="5" maxlength="5" onchange = "homephnvalidate('homephn');mandatorycheck('Oecd_city');CIFtrackGridFields('CIF Data Update','Contact Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homephone_newC")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homephone_newC")).getAttribValue().toString()%>'>
					
					<input type="text" class='NGReadOnlyView' style="width: 20%;" onchange="docReq(this,'Home Phone','homephone_newN_doc');CIFtrackGridFields('CIF Data Update','Contact Number Update');tosavedocuments();" onkeyup="validateKeys(this,'Numeric');"  name="wdesk:homephone_newN" id="wdesk:homephone_newN" maxlength="3" size="12"<%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("homephone_newN")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homephone_newN")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>''>
					
					<input type="text" class='NGReadOnlyView' style="width: 44%;" onkeyup="validateKeys(this,'Numeric');"  name="wdesk:homephone_newE"  id="wdesk:homephone_newE" size="5" maxlength="15" onchange = "docReq(this,'Home Phone','homephone_newN_doc');homephnvalidate('homephn');hmphnstart('home phone');CIFtrackGridFields('CIF Data Update','Contact Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homephone_newE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homephone_newE")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="homephone_newN_doc" size="35" id="homephone_newN_doc"  readonly disabled=true class="sizeofbox" >
					</td>
						
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Office Phone</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:office_phn_exis" size="35" maxlength = '100' id="wdesk:office_phn_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_phn_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_phn_exis")).getAttribValue().toString()%>'>
					</td>
				
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 32%;" onchange = "mandatorycheck('Oecd_city');CIFtrackGridFields('CIF Data Update','Contact Number Update');" onkeyup="validateKeys(this,'Numeric');"  id="wdesk:office_phn_newC" name="wdesk:office_phn_newC" size="5"  maxlength="5" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_phn_newC")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_phn_newC")).getAttribValue().toString()%>'>
					
					<input type="text" class='NGReadOnlyView' style="width: 20%;"   onchange="docReq(this,'Office Phone','office_phn_new_doc');CIFtrackGridFields('CIF Data Update','Contact Number Update');tosavedocuments();"  onkeyup="validateKeys(this,'Numeric');" name="wdesk:office_phn_new" id="wdesk:office_phn_new" maxlength="3" size="5" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_phn_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_phn_new")).getAttribValue().toString()%>'>
					
					<input style="width: 44%;" type="text" class='NGReadOnlyView' onkeyup="validateKeys(this,'Numeric');"   name="wdesk:office_phn_newE" id="wdesk:office_phn_newE" size="5" maxlength="15" onchange = "docReq(this,'Office Phone','office_phn_new_doc');hmphnstart('Office phone');CIFtrackGridFields('CIF Data Update','Contact Number Update');"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_phn_newE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_phn_newE")).getAttribValue().toString()%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' ><input type="text" name="office_phn_new_doc" size="35" id="office_phn_new_doc"  readonly disabled=true class="sizeofbox">
					</td>							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Fax</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:fax_exis" size="35" maxlength = '100' id="wdesk:fax_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("fax_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("fax_exis")).getAttribValue().toString()%>'>
					</td>

							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 32%;" onchange = "mandatorycheck('Oecd_city');CIFtrackGridFields('CIF Data Update','Contact Number Update');" onkeyup="validateKeys(this,'Numeric');" name="wdesk:fax_newC" id="wdesk:fax_newC" size="5" maxlength="5"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("fax_newC")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("fax_newC")).getAttribValue().toString()%>'>
							<input type="text" class='NGReadOnlyView' style="width: 20%;" onkeyup="validateKeys(this,'Numeric');"  id="wdesk:fax_new" name="wdesk:fax_new" maxlength="3" size="12" onchange="docReq(this,'Fax','fax_new_doc');CIFtrackGridFields('CIF Data Update','Contact Number Update');tosavedocuments();" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("fax_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("fax_new")).getAttribValue().toString()%>'>
							<input type="text"class='NGReadOnlyView'  style="width: 44%;" onkeyup="validateKeys(this,'Numeric');"  name="wdesk:fax_newE" id="wdesk:fax_newE" size="5" maxlength="15" onchange ="docReq(this,'Fax','fax_new_doc');hmphnstart('Fax');CIFtrackGridFields('CIF Data Update','Contact Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("fax_newE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("fax_newE")).getAttribValue().toString()%>'>
							</td>
							<!--tanshu-->
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="fax_new_doc" size="35" id="fax_new_doc"  readonly disabled=true class="sizeofbox" >
							</td>
							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Home Country Phone</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:homecntryphone_exis" size="35" maxlength = '100' id="wdesk:homecntryphone_exis"  readonly disabled=true class="sizeofbox"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_exis")).getAttribValue().toString()%>'>
					</td>

							<!--tanshu added-->
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 32%;" onkeyup="validateKeys(this,'Numeric');" onchange="mandatorycheck('Oecd_city');CIFtrackGridFields('CIF Data Update','Contact Number Update');" name="wdesk:homecntryphone_newC" id="wdesk:homecntryphone_newC" size="5" maxlength="5" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_newC")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_newC")).getAttribValue().toString()%>'>
							<input type="text" class='NGReadOnlyView' style="width: 20%;" onkeyup="validateKeys(this,'Numeric');" onchange="docReq(this,'Home Country Phone','homecntryphone_newN_doc');CIFtrackGridFields('CIF Data Update','Contact Number Update');tosavedocuments();" name="wdesk:homecntryphone_newN" id="wdesk:homecntryphone_newN" maxlength="3" size="12" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_newN")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_newN")).getAttribValue().toString()%>'>
							<input type="text" class='NGReadOnlyView' style="width: 44%;" onkeyup="validateKeys(this,'Numeric');" name="wdesk:homecntryphone_newE" id="wdesk:homecntryphone_newE" size="5" maxlength="15" onchange = "docReq(this,'Home Country Phone','homecntryphone_newN_doc');CIFtrackGridFields('CIF Data Update','Contact Number Update');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_newE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("homecntryphone_newE")).getAttribValue().toString()%>'>
							</td>
							<!--tanshu-->
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="homecntryphone_newN_doc" size="35" id="homecntryphone_newN_doc"  readonly disabled=true class="sizeofbox">
							</td>
							
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Preferred Contact</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:pref_contact_exis" size="35" maxlength = '100' id="wdesk:pref_contact_exis"  readonly disabled=true class="sizeofbox" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("pref_contact_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("pref_contact_exis")).getAttribValue().toString()%>'>
					</td>

							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="pref_contact_new"  name="pref_contact_new" maxlength = '100' style="width: 100%;" onchange="docReq(this,'Preferred Contact','pref_contact_new_doc');CIFtrackGridFields('CIF Data Update','Contact Number Update');changeVal(this,'<%=WSNAME%>');tosavedocuments();" >
									<option value="--Select--">--Select--</option>
									<option value="Mobile Phone">Mobile Phone</option>
									<option value="Mobile Phone 2">Mobile Phone 2</option>
									<option value="Telephone Office">Office Phone</option>
									
								</select>
							</td>

							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="pref_contact_new_doc" size="35" id="pref_contact_new_doc"  readonly disabled=true class="sizeofbox">
							</td>
							
				</tr>
				
				
				<tr width=100%>
				<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1" id="employment_details"><b><font color="#FF4747">Employment Details</font></b></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
					
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
				
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Employment Type</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:emp_type_exis" size="35" id="wdesk:emp_type_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("emp_type_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emp_type_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                       
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="emp_type_new" style="width: 100%;"  name="emp_type_new" readonly disabled=true maxlength = '100'
					 onchange="docReq(this,'Employment Type','emp_type_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');changeVal(this,'<%=WSNAME%>');tosavedocuments();validateemptype()"  >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="emp_type_new_doc" size="35" id="emp_type_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
			
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Designation</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:designation_exis" size="35" maxlength = '100' id="wdesk:designation_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("designation_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("designation_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                   
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"  class='NGReadOnlyView'  style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');"
					onchange="docReq(this,'Designation','designation_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');tosavedocuments();" name="wdesk:designation_new" size="35" maxlength = '50' id="wdesk:designation_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("designation_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("designation_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="designation_new_doc" size="35" id="designation_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				
				<input type="hidden" name="wdesk:comp_name_exis" size="35" maxlength = '100' id="wdesk:comp_name_exis"  readonly disabled=true class="sizeofbox">
				<input type="hidden" style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');"
				onchange="docReq(this,'Company Name','comp_name_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');tosavedocuments();mandatorycheck('visa');" name="wdesk:comp_name_new" size="35" maxlength = '100' id="wdesk:comp_name_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("comp_name_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("comp_name_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
				<input type="hidden" name="comp_name_new_doc" size="35" id="comp_name_new_doc"  readonly disabled=true class="sizeofbox">
					
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Name of Employer</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:emp_name_exis" size="35" maxlength = '100' id="wdesk:emp_name_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("emp_name_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emp_name_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					  
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');" onchange="docReq(this,'Name of Employer','emp_name_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');mandatorycheck('visa');" name="wdesk:emp_name_new" size="35" maxlength = '100' id="wdesk:emp_name_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("emp_name_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emp_name_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="emp_name_new_doc" size="35" id="emp_name_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				
				<!-- Start - Employer Code field added as part of CR JIRA SCRCIF-78 and mailsubject Employer Code changes added on 06062017 -->
				
				<%
				if(WSNAME.equalsIgnoreCase("OPS_Checker_Review") || WSNAME.equalsIgnoreCase("Error"))
				{ 
					%>						
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Employer Code</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:EmployerCode_exis" size="35" maxlength = '100' id="wdesk:EmployerCode_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					  
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" class='NGReadOnlyView'  style="width: 100%;" onkeyup="validateKeys(this,'alpha-numeric');" name="wdesk:EmployerCode_new" size="35" maxlength = '100' id="wdesk:EmployerCode_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="employer_code_new_doc" size="35" id="employer_code_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
					</tr>

					<%
				} else {
				%>
					<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Employer Code</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:EmployerCode_exis" size="35" maxlength = '100' id="wdesk:EmployerCode_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					  
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" class='NGReadOnlyView' readonly disabled=true style="width: 100%;" onkeyup="validateKeys(this,'alpha-numeric');" name="wdesk:EmployerCode_new" size="35" maxlength = '100' id="wdesk:EmployerCode_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmployerCode_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="text" name="employer_code_new_doc" size="35" id="employer_code_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
					</tr>
					<%
				}
				%>
				<!-- End - Employer Code field added as part of CR JIRA SCRCIF-78 and mailsubject Employer Code changes added on 06062017 -->
			
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Department</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:department_exis" size="35" maxlength = '100' id="wdesk:department_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("department_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("department_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                       
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');" onchange="docReq(this,'Department','department_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');" name="wdesk:department_new" size="35" maxlength = '50' id="wdesk:department_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("department_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("department_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="department_new_doc" size="35" id="department_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Employee Number</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:employee_num_exis" size="35" maxlength = '100' id="wdesk:employee_num_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("employee_num_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("employee_num_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                       
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"class='NGReadOnlyView'  style="width: 100%;" onkeyup="validateKeys(this,'alpha-numeric');" name="wdesk:employee_num_new" onchange="docReq(this,'Employee Number','employee_num_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');" size="35" maxlength = '20' id="wdesk:employee_num_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("employee_num_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("employee_num_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="employee_num_new_doc" size="35" id="employee_num_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Occupation</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:occupation_exist" size="35" maxlength = '100' id="wdesk:occupation_exist"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("occupation_exist")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("occupation_exist")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					 					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="occupation_new"  name="occupation_new" style="width: 100%;" onchange="docReq(this,'Occupation','occupation_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');changeVal(this,'<%=WSNAME%>');mandatorycheck('visa');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="occupation_new_doc" size="35" id="occupation_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Nature of Business</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text"  name="wdesk:name_of_business_exis" size="35" maxlength = '100' id="wdesk:name_of_business_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("name_of_business_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("name_of_business_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>></td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Alphabetic');" name="wdesk:name_of_business_new" size="35" 
					onchange="docReq(this,'Nature of Business','name_of_business_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');"
					maxlength = '50' id="wdesk:naturebusiness_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("name_of_business_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("name_of_business_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="name_of_business_new_doc" size="35" id="name_of_business_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
				
				</tr>
					
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' id ="Industry_Segment" class='EWNormalGreenGeneral1' colspan="1">Industry Segment</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:IndustrySegment_exis"  maxlength='100' size="35" id="wdesk:IndustrySegment_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("IndustrySegment_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IndustrySegment_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="IndustrySegment_new" maxlength='100'  name="IndustrySegment_new" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Industry Segment Update')" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text"  name="IndustrySegment_new_doc" size="35" id="IndustrySegment_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
				
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' id ="Industry_SubSegment" colspan="1">Industry Sub-Segment</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:IndustrySubSegment_exis"  maxlength='100' size="35" id="wdesk:IndustrySubSegment_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("IndustrySubSegment_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IndustrySubSegment_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="IndustrySubSegment_new" maxlength='100'  name="IndustrySubSegment_new" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Industry Sub Update')"  >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="IndustrySubSegment_new_doc" size="35" id="IndustrySubSegment_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
				
				</tr>
				
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Customer Type</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:CustomerType_exis"  maxlength='100' size="35" id="wdesk:CustomerType_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("CustomerType_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CustomerType_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="CustomerType_new" maxlength='100'  name="CustomerType_new" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Customer type Update')" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="CustomerType_new_doc" size="35" id="CustomerType_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'  id ="DealingCount" colspan="1">Dealing With Countries</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:DealwithCont_exis"  maxlength='100' size="35" id="wdesk:DealwithCont_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("DealwithCont_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DealwithCont_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                   
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="DealwithCont_new" maxlength='100'  name="DealwithCont_new" style="width: 100%;" onchange="changeVal(this,'<%=WSNAME%>');CIFtrackGridFields('CIF Data Update','Dealing with  Update')" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="DealwithCont_new_doc" size="35" id="DealwithCont_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>					
				</tr>	
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Total years of Employment</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:total_year_of_emp_exis" size="35" maxlength = '100' id="wdesk:total_year_of_emp_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("total_year_of_emp_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("total_year_of_emp_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Numeric');" name="wdesk:total_year_of_emp_new" onchange="docReq(this,'Total years of Employment','total_year_of_emp_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');" size="35" maxlength = '3' id="wdesk:total_year_of_emp_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("total_year_of_emp_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("total_year_of_emp_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="total_year_of_emp_new_doc" size="35" id="total_year_of_emp_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Years since in Business</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:years_of_business_exis" size="35" maxlength = '100' id="wdesk:years_of_business_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("years_of_business_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("years_of_business_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Numeric');" name="wdesk:years_of_business_new" onchange="docReq(this,'Years since in Business','years_of_business_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');" size="35" maxlength = '3' id="wdesk:years_of_business_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("years_of_business_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("years_of_business_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="years_of_business_new_doc" size="35" id="years_of_business_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Employment Status</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:employment_status_exis"  maxlength='100' size="35" id="wdesk:employment_status_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("employment_status_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("employment_status_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
                    
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="employment_status_new" maxlength='100'  name="employment_status_new" style="width: 100%;" onchange="docReq(this,'Employment Status','employment_status_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');changeVal(this,'<%=WSNAME%>');" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="employment_status_new_doc" size="35" id="employment_status_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Date of Joining Current Employer</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:date_join_curr_employer_exis" size="35" maxlength = '20' id="wdesk:date_join_curr_employer_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("date_join_curr_employer_exis")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("date_join_curr_employer_exis")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("date_join_curr_employer_exis")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:date_join_curr_employer_new" size="35" maxlength = '20'  onchange="docReq(this,'Date of Joining Current Employer','date_join_curr_employer_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');optimizedate('Dateofjoining');"  id="wdesk:date_join_curr_employer_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("date_join_curr_employer_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("date_join_curr_employer_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("date_join_curr_employer_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="date_join_curr_employer_new_doc" size="35" id="date_join_curr_employer_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Marital Status</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:marrital_status_exis" size="35" maxlength = '100' id="wdesk:marrital_status_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("marrital_status_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("marrital_status_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="marrital_status_new" maxlength = '100'  name="marrital_status_new" style="width: 100%;" onchange="docReq(this,'Marital Status','marrital_status_new_doc');CIFtrackGridFields('CIF Data Update','Demographic Details Update');changeVal(this,'<%=WSNAME%>')" >
							<option value="--Select--">--Select--</option>
							
						</select>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="marrital_status_new_doc" size="35" id="marrital_status_new_doc" readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Number of Dependents</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:no_of_dependents_exis" size="35" maxlength = '100' id="wdesk:no_of_dependents_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("no_of_dependents_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("no_of_dependents_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" onkeyup="validateKeys(this,'Numeric');" name="wdesk:no_of_dependents_new" onchange="docReq(this,'Number of Dependents','no_of_dependents_new_doc');CIFtrackGridFields('CIF Data Update','Demographic Details Update');" size="35" maxlength = '2' id="wdesk:no_of_dependents_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("no_of_dependents_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("no_of_dependents_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="no_of_dependents_new_doc" size="35" id="no_of_dependents_new_doc"  readonly disabled=true class="sizeofbox" >
					</td>
					
				</tr>

				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Nationality</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:nation_exist" size="35" maxlength = '100' id="wdesk:nation_exist"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("nation_exist")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("nation_exist")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>>
					</td>
					
					<input type="hidden" id="wdesk:nation_new" name="wdesk:nation_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("nation_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("nation_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<select class='NGReadOnlyView' id="nation_new" name="nation_new"  maxlength = '100' style="width: 100%;" onchange="docReq(this,'Country of Residence/Nationality','nation_new_doc');CIFtrackGridFields('CIF Data Update','Nationality Change');changeVal(this,'<%=WSNAME%>');mandatorycheck('nationality');" >
							<option value="--Select--">--Select--</option>
							<option value="UAE">UAE</option>
							<option value="Others">Other</option>
						</select>
					</td>
					
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="nation_new_doc" size="35" id="nation_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Country Of Residence</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:country_of_res_exis" size="35" maxlength = '100' id="wdesk:country_of_res_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("country_of_res_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("country_of_res_exis")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
					<input type="hidden" id="wdesk:country_of_res_new" name="wdesk:country_of_res_new" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("country_of_res_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("country_of_res_new")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select class='NGReadOnlyView' id="country_of_res_new" name="country_of_res_new"  maxlength = '100' style="width: 100%;" onchange="docReq(this,'Country of Residence/Nationality','nation_new_doc');CIFtrackGridFields('CIF Data Update','Nationality Change');changeVal(this,'<%=WSNAME%>')" >
							<option value="--Select--">--Select--</option>
							<option value="UAE">UAE</option>
							<option value="Others">Other</option>
						</select>
					</td>
					
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="country_of_res_new_doc" size="35" id="country_of_res_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1">Since when in UAE</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:wheninuae_exis" size="35" maxlength = '100' id="wdesk:wheninuae_exis"  readonly disabled=true class="sizeofbox" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("wheninuae_exis")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("wheninuae_exis")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("wheninuae_exis")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView'  style="width: 100%;" name="wdesk:wheninuae_new" size="35" maxlength = '100' onchange="optimizedate('UAEdate');docReq(this,'Since when in UAE','wheninuae_new_doc');CIFtrackGridFields('CIF Data Update','Demographic Details Update');" id="wdesk:wheninuae_new" <%try{%>value='<%=(((CustomWorkdeskAttribute)attributeMap.get("wheninuae_new")).getAttribValue().toString()==null || (((CustomWorkdeskAttribute)attributeMap.get("wheninuae_new")).getAttribValue().toString()).equalsIgnoreCase(""))?"":(((CustomWorkdeskAttribute)attributeMap.get("wheninuae_new")).getAttribValue().toString()).substring(0,10)%>'<%}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
				
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="wheninuae_new_doc" size="35" id="wheninuae_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<!--tanshu-->
				
				
				<!--tanshu-->
					<tr width=100%>
				<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1" id="employment_details"><b><font color="#FF4747">Previous Employment Details</font></b></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
					
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
					<td style="padding-left: 5px;" align="left" class="EWNormalGreenGeneral1 " colspan="1"><input name="Header" style="display: none;" type="text" size="24" readonly="" value="Personal Details"></td>
				
				</tr>

				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Previous Organization In UAE</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:prev_organ_exis" size="35" maxlength = '100' id="wdesk:prev_organ_exis"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("prev_organ_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("prev_organ_exis")).getAttribValue().toString()%>'<%try{}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					  
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:prev_organ_new" size="35" maxlength = '100' onkeyup="validateKeys(this,'Alphabetic');" onchange="docReq(this,'Previous Organization In UAE','prev_organ_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');dateundefined(this);" id="wdesk:prev_organ_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("prev_organ_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("prev_organ_new")).getAttribValue().toString()%>'<%try{}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="prev_organ_new_doc" size="35" id="prev_organ_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr width=100%>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1 ' colspan="1">Period Of Employment In The <br> Previous Organization</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"><input type="text" name="wdesk:period_organ_exis" size="35" maxlength = '100' id="wdesk:period_organ_exis"  readonly disabled=true class="sizeofbox" value='<%=((CustomWorkdeskAttribute)attributeMap.get("period_organ_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("period_organ_exis")).getAttribValue().toString()%>'<%try{}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					 
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' style="width: 100%;" name="wdesk:period_organ_new" size="35" maxlength = '3' onkeyup="validateKeys(this,'Numeric');" onchange="docReq(this,'Period Of Employment In The Previous Organization','period_organ_new_doc');CIFtrackGridFields('CIF Data Update','Employment Details Update');dateundefined(this);" id="wdesk:period_organ_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("period_organ_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("period_organ_new")).getAttribValue().toString()%>'<%try{}catch(Exception e){out.println(e.getMessage());}%>'>
					</td>
					
					
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" name="period_organ_new_doc" size="35" id="period_organ_new_doc"  readonly disabled=true class="sizeofbox">
					</td>
					
				</tr>
				<tr>
				
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
						<input type="button" class='NGReadOnlyView' onclick="getSignature(this);" id="viewSign" value="View Signatures">
					</td>
					
				</tr>
				
			</table>
			</div></div></div>
			
			<div class="accordion-group" id="PBOHide1" style="display:none">
                <div class="accordion-heading" id="div_SignatureUpdate">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel13" id="abc"><b style="COLOR: white;">Signature Update</b></a>
					</h4>
                </div>
			
                <div id="panel13" class="accordion-body collapse">
                    <div class="accordion-inner" id="signatureUpdate_details">		
					</div>
				</div>
			</div>
          
			<div class="accordion-group" id="PBOHide2" style="display:none" >
                  <div class="accordion-heading" id="div_DormancyActivation">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel4"><b style="COLOR: white;">Dormancy Activation</b></a>
					</h4>
                  </div>
                  <div id="panel4" class="accordion-body collapse">
                    <div class="accordion-inner" id="dormancyactivation_details">
			
					</div>
			</div>
			</div>

			<div class="accordion-group" id="PBOHide3" style="display:none">
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel5"><b style="COLOR: white;">Account Conversion(Minor to Major)</b>
					</a>
					</h4>
                  </div>
                  <div id="panel5" class="accordion-body collapse">
                    <div class="accordion-inner">
			<table border='1' cellspacing='1' cellpadding='0' width=100% >
				<tr width=100%>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="10%"><b>Select</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Account Number</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Account Type</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Relationship</b></td>
		    	<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b></b></td>

				</tr>
				<tr>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="checkbox" name="checkbox" value="checkbox"></td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>908231876342</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Current</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Guardian</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>

				</tr>
				<tr>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="checkbox" name="checkbox" value="checkbox"></td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>123654987678</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Super Saver</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Joint First</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>

				</tr>
				<tr>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="checkbox" name="checkbox" value="checkbox"></td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>456789987654</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Amal</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Individual Sole</td>
					<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>

				</tr>
			</table>
			</div>
			</div>
			</div>
			
			<div class="accordion-group" id="PBOHide4"  style="display:none">
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel6"><b style="COLOR: white;">Account Conversion(Sole to Joint)</b>
						</a>
					</h4>
                  </div>
                  <div id="panel6" class="accordion-body collapse">
                    <div class="accordion-inner" id="soletojoint_details">
			
					</div>
				</div>
			</div>
			
			<div class="accordion-group" id="PBOHide5" style="display:none">
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel7"><b style="COLOR: white;">Account Conversion(Joint to Sole)</b>
						</a>
					</h4>
                  </div>
                  <div id="panel7" class="accordion-body collapse">
                    <div class="accordion-inner" id="jointtosole_details">
			
					</div>
				</div>
			</div>
			
			<div class="accordion-group" id="PBOHide6" style="display:none">
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel8"><b style="COLOR: white;">Power of Attorney(Addition)</b></a>
					</h4>
                  </div>
                  <div id="panel8" class="accordion-body collapse">
                    <div class="accordion-inner">
			<table border='1' cellspacing='1' cellpadding='0' width=100% >
				
				<tr width=100%>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="10%"><b>Select</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Account Number</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Account Type</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Relationship</b></td>
					<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Name of Attorney</b></td>
				</tr>				
			</table>
					</div>
				</div>
			</div>
			
			<div class="accordion-group" id="PBOHide7" style="display:none">
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel9"><b style="COLOR: white;">Power of Attorney(Deletion)</b>
						</a>
					</h4>
                  </div>
                  <div id="panel9" class="accordion-body collapse">
                    <div class="accordion-inner">
			<table border='1' cellspacing='1' cellpadding='0' width=100% >
			<tr width=100%>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="10%"><b>Select</b></td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Account Number</b></td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Account Type</b></td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Relationship</b></td>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="22.5%"><b>Name of Attorney</b></td>
			</tr>			
			</table>
					</div>
				</div>
			</div>
			
			<!--tanshu added-->
			
			<div class="accordion-group" id="loan" style="display:none">
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion"  href="#panel14"><b style="COLOR: white;">Loan Product</b>
						</a>
					</h4>
                  </div>
                  <div id="panel14" class="accordion-body collapse">
                    <div class="accordion-inner">
			<table border='1' cellspacing='1' cellpadding='0' width=100% >
			<tr width=100%>
				<td style="text-align:center;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1" width="15%"><b>Outstanding Loan</b></td>
				
				<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:auto_loan" id="wdesk:auto_loan" value="N" onclick="checkboxchecked();">&nbsp;AL</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:personal_loan" id="wdesk:personal_loan" value="N" onclick="checkboxchecked();">&nbsp;PL</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:m_loan" id="wdesk:m_loan" value="N" onclick="checkboxchecked();">&nbsp;ML</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:RF_loan" id="wdesk:RF_loan" value="N" onclick="checkboxchecked();">&nbsp;RFL</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:cards" id="wdesk:cards" value="N" onclick="checkboxchecked();">&nbsp;Cards</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:trade_fin" id="wdesk:trade_fin" value="N" onclick="checkboxchecked();">&nbsp;Trade Finance</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="12%"><input type="checkbox" name="wdesk:In_Pro" id="wdesk:In_Pro" value="N" onclick="checkboxchecked();">&nbsp;Investment Product</td>
			</tr>
			
			</table>
					</div>
				</div>
			</div>
			
			  <div class="accordion-group" id="KYC_tab" style="display:none" >
                  <div class="accordion-heading">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion"   href="#panel15"><b style="COLOR: white;">KYC Update</b>
						</a>
					</h4>
                  </div>
                  <div id="panel15" class="accordion-body collapse">
                    <div class="accordion-inner">
						<table border='1' cellspacing='1' cellpadding='0' width=100% >
						
						<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"  width="27%"><label  width="30%"><font color="red" align="left">Details of Anticipated Transaction</font></label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><label width="20%"></label></td>
							
							</tr>
							
							<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label  width="20%">Total Monthly Credits</label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%">Cash</label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							</tr>
							<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label style="font-weight: 100 !important;"  width="20%">Amount in figures-AED</label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' onchange="trackGridFields('KYC Update','');"  id="totally_month_credits_amount" maxlength='100' name="totally_month_credits_amount" onkeyup="validateKeys(this,'Numeric');" 
			 width="20%"<%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("totally_month_credits_amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("totally_month_credits_amount")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'> </td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label style="font-weight: 100 !important;"  width="20%">Amount in figures-AED</label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' id="cash_amount" name="cash_amount" maxlength='100' onchange="trackGridFields('KYC Update','');" onkeyup="validateKeys(this,'Numeric');" 
			width="20%" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("cash_amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("cash_amount")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'></td>
							</tr>
						 <tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label style="font-weight: 100 !important;"  width="20%">In%</label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' maxlength='100' id="total_in" name="totally_month_credits_in" onchange="trackGridFields('KYC Update','');" onkeyup="validateKeys(this,'Numeric');" 
						  width="20%"<%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("total_in")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("total_in")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'> </td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label style="font-weight: 100 !important;"  width="20%">In%</label></td>
							
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' maxlength='100' onchange="trackGridFields('KYC Update','KYC Update');" id="cash_in" name="cash_in" onchange="trackGridFields('KYC Update','');" onkeyup="validateKeys(this,'Numeric');" width="20%" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("cash_in")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("cash_in")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'></td>
							</tr>

						<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label width="20%">Non Cash(Cheque/EFT/Internal Transfer)</label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><label width="20%"></label></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%">Total</label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							</tr>
							
			<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label style="font-weight: 100 !important;"  width="20%">Amount in figures-AED</label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' maxlength='100' id="non_cash_amount" name="non_cash_amount"  onchange="trackGridFields('KYC Update','');" onkeyup="validateKeys(this,'Numeric');" 
			 width="20%" <%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("non_cash_amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("non_cash_amount")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label style="font-weight: 100 !important;" width="20%">Amount in figures-AED</label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' maxlength='100' onchange="trackGridFields('KYC Update','');"id="total_amount" name="total_amount" onkeyup="validateKeys(this,'Numeric');" 
			 width="20%"<%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("total_amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("total_amount")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'></td>
							</tr>
			<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label style="font-weight: 100 !important;"  width="20%">In%</label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' maxlength='100' id="non_cash_in"  onchange="trackGridFields('KYC Update','');" name="non_cash_in" onkeyup="validateKeys(this,'Numeric');"  width="20%"<%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("non_cash_in")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("non_cash_in")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label style="font-weight: 100 !important;"  width="20%">In%</label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><input type="text" class='NGReadOnlyView' maxlength='100'  onchange="trackGridFields('KYC Update','');" id="total_in2" name="total_in2" onkeyup="validateKeys(this,'Numeric');" 
			 width="20%"<%try{%>value='<%=((CustomWorkdeskAttribute)attributeMap.get("total_in2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("total_in2")).getAttribValue().toString()%>'<%}catch(Exception e){out.println(e.getMessage());}%>'></td>
							</tr>
			<tr width=100%>
						<td  nowrap='nowrap' class='EWNormalGreenGeneral1' ><label  width="20%"><i>Highest Single Amount Expected</i></label></td>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							<td style="text-align:center:"nowrap='nowrap' class='EWNormalGreenGeneral1'><label  width="20%"></label></td>
							</tr>
							
					
						<tr width=100%>
							<td  nowrap='nowrap' class='EWNormalGreenGeneral1' colspan="1"  width="27%"><label  width="30%"><font color="red" align="left">Politically Exposed Person?</font><span  style="font-weight: 100 !important;">(or has any<br> assosciation?)</span></label></td>
								
				<td nowrap='nowrap' class='EWNormalGreenGeneral1'><select  class='NGReadOnlyView' style="width: 138px;" maxlength='100' id="politically_exposed" name="politically_exposed"  onchange="changeVal(this,'<%=WSNAME%>');trackGridFields('KYC Update','');">
											<option value="--Select--">--Select--</option>
											<option value="Yes">Yes</option>
											<option value="No">No</option>
										
										</select>
										</td>
								
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'></td>
								
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'></td>			
							
							</tr>

				
						</table>
					</div>
				</div>
			</div>
			<div class="accordion-group" id="PBOHide9" >
                  <div class="accordion-heading" id="div_SupportingDocumentsReceived">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel11"><b style="COLOR: white;">Supporting Documents Received</b>
					</a>
					</h4>
                  </div>
                  <div id="panel11" class="accordion-body collapse in">
                    <div class="accordion-inner">
					<table id="TAB_SupportingDocs" border='1' cellspacing='1' cellpadding='0' width=100% >
									<tr width="100%">
									<td style="text-align:center; width: 45%;" nowrap='nowrap' class='EWNormalGreenGeneral1'>
											<p><b>Required Documents</b></p>
											<div id='requiredDocList' style="OVERFLOW: auto;WIDTH: 220px;HEIGHT: 147px" onscroll="OnDivScroll(this.id);" >
												<select class='NGReadOnlyView' id="requiredDoc1" multiple size="8" name="requiredDoc1" style="width:auto;">
												</select>
											</div>
										</td>
										<!-- modified by shamily for adding double click property-->
										<td colspan =3 style="text-align:right; width: 45%";" nowrap='nowrap' class='EWNormalGreenGeneral1' style=>
										<p align="right"><b>List of Available Documents&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></p>
										<div id='divDocumentList' style="OVERFLOW: auto;WIDTH: 220px;HEIGHT: 147px" onscroll="OnDivScroll(this.id);" >
											<select class='NGReadOnlyView' multiple size="8" id='documentList' ondblClick="move(this.form.FromLB,this.form.ToLB,this)" name="FromLB" style="width:auto">
												<%
													for(int i=0;i<documentValues.length;i++){
														boolean toAdd=true;
														if(selectedDocumentValues!=null && selectedDocumentValues.length>0)
														{
															//WriteLog("documentValues[i] "+documentValues[i]);
															for(int j=0;j<selectedDocumentValues.length;j++){
																if(selectedDocumentValues[j].equalsIgnoreCase(documentValues[i])) 
																{
																	//WriteLog("selectedDocumentValues[j] "+selectedDocumentValues[j]);
																	toAdd=false;
																	break;
																}		
															}
														}	
														if(!toAdd) continue;	
													%>
												<option value="<%=documentValues[i]%>"><%=documentValues[i]%></option>
												<%}%>
											</select>
										</div>
										</td>
										<td style="text-align:center; width: 10%;" nowrap='nowrap' class='EWNormalGreenGeneral1' valign="middle"> 
											<input type="button" id="addButton" class='EWButtonRB NGReadOnlyView' style='width:100px' onClick="move(this.form.FromLB,this.form.ToLB,this)" 
												value="Add >>"><br />
											<input type="button" id="removeButton" class='EWButtonRB NGReadOnlyView' style='width:100px' onClick="move(this.form.ToLB,this.form.FromLB, this)" 
												value="<< Remove">
										</td>
										<td style="text-align:center; width: 45%;" nowrap='nowrap' class='EWNormalGreenGeneral1'>
											<p><b>List of Collected Documents</b></p>
											<div id='divSelectedList' style="OVERFLOW: auto;WIDTH: 220px;HEIGHT: 147px" onscroll="OnDivScroll(this.id);" >
												<select class='NGReadOnlyView' id="selectedList" ondblclick = "move(this.form.ToLB,this.form.FromLB, this)" multiple size="8" name="ToLB" style="width:auto;">
												</select>
											</div>
										</td>
									</tr>
								</table>
					</div>
				</div>
			</div>
		<!--tanshu-->
			
			<div class="accordion-group" id="PBOHide8">
                  <div class="accordion-heading" id="div_FormGeneration">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel10"><b style="COLOR: white;">Form Generation</b></a>
					</h4>
                  </div>
                  <div id="panel10" class="accordion-body collapse in">
                    <div class="accordion-inner">
						<table id="TAB_FormGeneration" border='1' cellspacing='1' cellpadding='0' width=100% >
						<tr width=100%>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>CIF Update Form</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate' type='button' id='Generate'  class='EWButtonRB NGReadOnlyView' style='width:100px' value="Generate" onclick="CheckForTemplates('CIF_Update_form');generatePDF('CIF_Update_form');">
						</tr>
								<tr width=100%>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Fatca Form</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate' type='button' id='Generate1'  class='EWButtonRB NGReadOnlyView' style='width:100px' value="Generate" onclick="CheckForTemplates('FATCA_Individual');generatePDF('FATCA_Individual');">
						</tr>
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Signature Update Form</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate8' value="Generate" type='button' id='Generate8'  class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('SignatureUpdate');getCheckboxDetails('checkbox_signatureupdate');">
						</tr>	
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Dormancy Activation</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate2' value="Generate" type='button' id='Generate2'   class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('DormancyActivation');getCheckboxDetails('checkbox_dormancyactivation');">
						</tr>	
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Account Conversion(Minor To Major)</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate3'  value="Generate" type='button' id='Generate3'  class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('MinorToMajor');getCheckboxDetails('checkbox_monortomajor');">
						</tr>	
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Account Conversion(Sole To Joint)</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate4' value="Generate" type='button' id='Generate4'  class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('SoleToJoint');getCheckboxDetails('checkbox_soletojoint');">
						</tr>	
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Account Conversion(Joint To Sole)</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate5' value="Generate" type='button' id='Generate5'  class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('JointToSole');getCheckboxDetails('checkbox_jointtosole');">
						</tr>
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Power of Attorney(Addition)</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate6' value="Generate" type='button' id='Generate6'  class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('SignatureUpdate');">
						</tr>
						<tr width=100% style="display:none">
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Power of Attorney(Deletion)</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input onkeyup='validateKeys(this,act)' name='Generate7' value="Generate" type='button' id='Generate7'  class='EWButtonRB NGReadOnlyView' style='width:100px' onclick="generatePDF('SignatureUpdate')">
						</tr>
						</table>
						</div>
					</div>
				</div>
				
				<div class="accordion-group" id="PBOHideFormGeneration" style="display:none;">
                  <div class="accordion-heading" id="div_FormGenerationNew">
                    <h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel16"><b style="COLOR: white;">Form Generation</b></a>
					</h4>
                  </div>
                  <div id="panel16" class="accordion-body collapse in">
                    <div class="accordion-inner">
						<table id="TAB_FormGenerationNew" border='1' cellspacing='1' cellpadding='0' width=100% >
						<tr width=100%>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>CIF Update Form</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate' type='button'  id='Generate'  class='EWButtonRB NGReadOnlyView' style='width:100px' value="Generate" onclick="CheckForTemplates('CIF_Update_form');generatePDF('CIF_Update_form');getCheckboxDetails('checkbox_signatureupdate');"></td>
						</tr>
						<tr width=100%>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'>Fatca Form</td>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1'><input name='Generate' type='button'  id='Generate1'  class='EWButtonRB NGReadOnlyView' style='width:100px' value="Generate" onclick="CheckForTemplates('FATCA_Individual');generatePDF('FATCA_Individual');getCheckboxDetails('checkbox_signatureupdate');">
						</tr>
						
						</table>
						</div>
					</div>
				</div>
				<input type="hidden" id="wdesk:validation" name="wdesk:validation" value="">
				<input type="hidden" id="wdesk:validationFatca" name="wdesk:validationFatca" value="">
				<input type="hidden" id="wdesk:Updated_CIFNumber" name="wdesk:Updated_CIFNumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Updated_CIFNumber")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Updated_CIFNumber")).getAttribValue().toString()%>'>
				<input type="hidden" id="wdesk:documents" name="wdesk:documents" value='<%=attributeMap.get("documents")==null?"":((CustomWorkdeskAttribute)attributeMap.get("documents")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("documents")).getAttribValue().toString()%>' >
				<input type="hidden" id="radiaoCheck" name="radiaoCheck" value="N">
				 <input type='hidden' name='wdesk:dateField' id='wdesk:dateField' value='' />
				<input type="hidden" id="main_grid" name="main_grid">
				
				<!--input type="hidden" name="wdesk:acc_conversn_jointtosole" id="wdesk:acc_conversn_jointtosole" value="No"-->
				
				<input type="hidden" name="wdesk:isALProcured" id="wdesk:isALProcured" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isALProcured")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isALProcured")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:Decision" id="wdesk:Decision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Decision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Decision")).getAttribValue().toString()%>'>
			    <input type="hidden" name="wdesk:Doc_Scan_Dec" id="wdesk:Doc_Scan_Dec" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Doc_Scan_Dec")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Doc_Scan_Dec")).getAttribValue().toString()%>'>
				 <input type="hidden" name="wdesk:Dec_CSM_Review" id="wdesk:Dec_CSM_Review" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CSM_Review")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CSM_Review")).getAttribValue().toString()%>' >
				  <input type="hidden" name="wdesk:OPSMakerDEDecision" id="wdesk:OPSMakerDEDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OPSMakerDEDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OPSMakerDEDecision")).getAttribValue().toString()%>' >
				 
			  <input type="hidden" name="wdesk:Dec_SME_Credit" id="wdesk:Dec_SME_Credit" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_SME_Credit")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_SME_Credit")).getAttribValue().toString()%>' >
				 <input type="hidden" name="wdesk:Dec_Card_Deletion" id="wdesk:Dec_Card_Deletion" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Card_Deletion")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Card_Deletion")).getAttribValue().toString()%>' >
				 <input type="hidden" name="wdesk:Dec_Finacle_Maker" id="wdesk:Dec_Finacle_Maker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Finacle_Maker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Finacle_Maker")).getAttribValue().toString()%>'>
				  <input type="hidden" name="wdesk:Dec_Finacle_Checker" id="wdesk:Dec_Finacle_Checker"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Finacle_Checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Finacle_Checker")).getAttribValue().toString()%>'>
				  <input type="hidden" name="wdesk:Dec_Hold" id="wdesk:Dec_Hold"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Hold")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Hold")).getAttribValue().toString()%>'>
				  <input type="hidden" name="wdesk:Dec_CB_WC_Checker" id="wdesk:Dec_CB_WC_Checker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CB_WC_Checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CB_WC_Checker")).getAttribValue().toString()%>' >
				<input type="hidden" name="wdesk:Dec_OPS_Checker" id="wdesk:Dec_OPS_Checker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_OPS_Checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_OPS_Checker")).getAttribValue().toString()%>' >
				<input type="hidden" name="wdesk:Dec_CB_WC" id="wdesk:Dec_CB_WC" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CB_WC")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CB_WC")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:Dec_CB_WC_Controls" id="wdesk:Dec_CB_WC_Controls" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CB_WC_Controls")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CB_WC_Controls")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:PBORejectDecision" id="wdesk:PBORejectDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("PBORejectDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PBORejectDecision")).getAttribValue().toString()%>'>
				  <input type="hidden" name="wdesk:Dec_Compliance" id="wdesk:Dec_Compliance" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Compliance")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Compliance")).getAttribValue().toString()%>' >
			  <input type="hidden" name="wdesk:Dec_PB_Credit" id="wdesk:Dec_PB_Credit"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_PB_Credit")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_PB_Credit")).getAttribValue().toString()%>' >
			   <input type="hidden" name="wdesk:Dec_Crops_Approval" id="wdesk:Dec_Crops_Approval"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_Crops_Approval")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_Crops_Approval")).getAttribValue().toString()%>' >
			   <input type="hidden" name="wdesk:ArchivalActivityDecision" id="wdesk:ArchivalActivityDecision"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalActivityDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ArchivalActivityDecision")).getAttribValue().toString()%>' >
			    <input type="hidden" name="wdesk:ErrorDecision" id="wdesk:ErrorDecision"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("ErrorDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ErrorDecision")).getAttribValue().toString()%>' >
				<input type="hidden" name="wdesk:ArchivalRejectsDecision" id="wdesk:ArchivalRejectsDecision"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalRejectsDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ArchivalRejectsDecision")).getAttribValue().toString()%>' >
				<input type="hidden" name="wdesk:isSysUpdateSuccess" id="wdesk:isSysUpdateSuccess"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("isSysUpdateSuccess")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isSysUpdateSuccess")).getAttribValue().toString()%>' >
				<input type="hidden" name="wdesk:PBOdecision" id="wdesk:PBOdecision"  value='<%=((CustomWorkdeskAttribute)attributeMap.get("PBOdecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PBOdecision")).getAttribValue().toString()%>' >
				<input type="hidden" name="wdesk:Dec_CSO_Rejects" id="wdesk:Dec_CSO_Rejects" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Dec_CSO_Rejects")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Dec_CSO_Rejects")).getAttribValue().toString()%>'  >
			
				<input type="hidden" name="wdesk:isPLProcured" id="wdesk:isPLProcured" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isPLProcured")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isPLProcured")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:isRFLProcured" id="wdesk:isRFLProcured" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isRFLProcured")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isRFLProcured")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:isMLProcured" id="wdesk:isMLProcured" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isMLProcured")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isMLProcured")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:isCardsProcured" id="wdesk:isCardsProcured" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isCardsProcured")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isCardsProcured")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:isTradeFinance" id="wdesk:isTradeFinance" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isTradeFinance")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isTradeFinance")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:isInvestmentProduct" id="wdesk:isInvestmentProduct" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isInvestmentProduct")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isInvestmentProduct")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:passport_rec" id="wdesk:passport_rec" value='<%=((CustomWorkdeskAttribute)attributeMap.get("passport_rec")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("passport_rec")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:emirates_id_rec" id="wdesk:emirates_id_rec" value='<%=((CustomWorkdeskAttribute)attributeMap.get("emirates_id_rec")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emirates_id_rec")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:labourcard_rec" id="wdesk:labourcard_rec" value='<%=((CustomWorkdeskAttribute)attributeMap.get("labourcard_rec")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("labourcard_rec")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:family_book_rec" id="wdesk:family_book_rec" value='<%=((CustomWorkdeskAttribute)attributeMap.get("family_book_rec")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("family_book_rec")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:employmnt_cert_rec" id="wdesk:employmnt_cert_rec" value='<%=((CustomWorkdeskAttribute)attributeMap.get("employmnt_cert_rec")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("employmnt_cert_rec")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:salary_transfer_letter" id="wdesk:salary_transfer_letter" value='<%=((CustomWorkdeskAttribute)attributeMap.get("salary_transfer_letter")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("salary_transfer_letter")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:know_customer_record" id="wdesk:know_customer_record">
				
				<input type="hidden" name="wdesk:isWMSMECase" id="wdesk:isWMSMECase" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isWMSMECase")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isWMSMECase")).getAttribValue().toString()%>'>
			
			   <input type="hidden" name="wdesk:isPBOCase" id="wdesk:isPBOCase" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isPBOCase")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isPBOCase")).getAttribValue().toString()%>'>
               <input type="hidden" name="wdesk:first_name_new_doc" id="wdesk:first_name_new_doc" value='<%=((CustomWorkdeskAttribute)attributeMap.get("first_name_new_doc")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("first_name_new_doc")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:MailType" id="wdesk:MailType" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MailType")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MailType")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:USrelation_new" id="wdesk:USrelation_new" value='<%=attributeMap.get("USrelation_new")==null?"":((CustomWorkdeskAttribute)attributeMap.get("USrelation_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("USrelation_new")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:FatcaDoc_new" id="wdesk:FatcaDoc_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("FatcaDoc_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FatcaDoc_new")).getAttribValue().toString()%>'>	
				<!-- added  by nikita to set fatcareason value in DB-->
				<input type="hidden" name="wdesk:FatcaReason_new" id="wdesk:FatcaReason_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("FatcaReason_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("FatcaReason_new")).getAttribValue().toString()%>'>
				<input type="hidden" name="wdesk:nonResident_new" id="wdesk:nonResident_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("nonResident_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("nonResident_new")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:IndustrySegment_new" id="wdesk:IndustrySegment_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IndustrySegment_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IndustrySegment_new")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:IndustrySubSegment_new" id="wdesk:IndustrySubSegment_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IndustrySubSegment_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("IndustrySubSegment_new")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:CustomerType_new" id="wdesk:CustomerType_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CustomerType_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CustomerType_new")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:DealwithCont_new" id="wdesk:DealwithCont_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DealwithCont_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DealwithCont_new")).getAttribValue().toString()%>'>	
				<!--<input type="hidden" name="wdesk:SignedDate_new" id="wdesk:SignedDate_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SignedDate_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SignedDate_new")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:ExpiryDate_new" id="wdesk:ExpiryDate_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ExpiryDate_new")).getAttribValue().toString()%>'> -->					
				<input type="hidden" name="wdesk:resi_countryexis" id="wdesk:resi_countryexis" value='<%=((CustomWorkdeskAttribute)attributeMap.get("resi_countryexis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_countryexis")).getAttribValue().toString()%>'>	
				<input type="hidden" name="wdesk:resi_cityexis" id="wdesk:resi_cityexis" value='<%=((CustomWorkdeskAttribute)attributeMap.get("resi_cityexis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resi_cityexis")).getAttribValue().toString()%>'>	 
				<input type="hidden" name="wdesk:SelectedCIF" id="wdesk:SelectedCIF" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SelectedCIF")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SelectedCIF")).getAttribValue().toString()%>'>	 
				<input type="hidden" name="wdesk:SegmentValidFlag" id="wdesk:SegmentValidFlag" value="">	
				<input type="hidden" id="wdesk:Supporting_Docs" name="wdesk:Supporting_Docs" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Supporting_Docs")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Supporting_Docs")).getAttribValue().toString()%>'>
				<input type="hidden" id="wdesk:Requireddoc" name="wdesk:Requireddoc" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Requireddoc")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Requireddoc")).getAttribValue().toString()%>'>
				
				<%if(WSNAME.equals("CSO")|| WSNAME.equals("CSO_Rejects") || WSNAME.equals("OPS%20Maker_DE")){
				%>
				<input type="hidden" id="wdesk:Generated_Data" name="wdesk:Generated_Data" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Generated_Data")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Generated_Data")).getAttribValue().toString()%>'>
				<%}%>
				
				<input type="hidden" id="resAddress1" name="resAddress1" value=''>
				<input type="hidden" id="OffcAddress1" name="OffcAddress1" value=''>				
				<input type="hidden" id="resi_pobox1" name="resi_pobox1" value=''>				
				<input type="hidden" id="offc_pobox1" name="offc_pobox1" value=''>				
				<input type="hidden" id="offcCountry1" name="offcCountry1" value=''>				
				<input type="hidden" id="offcCity1" name="offcCity1" value=''>	
				<!--code added by badri to show address in fatca form-->
				<input type="hidden" id="resaddress1existing" name="resaddress1existing" value=''>
				<input type="hidden" id="offaddress1existing" name="rescityStateexisting" value=''>				
				<!--code added by badri to show address in fatca form-->
				
				
				<!-- added by shamily to fetch existing phone country codes for point 4 CR-->
				<input type="hidden" id="Phone1CountryCode" name="Phone1CountryCode" value=''>				
				<input type="hidden" id="Phone2CountryCode" name="Phone2CountryCode" value=''>				
				<input type="hidden" id="HomePhoneCountryCode" name="HomePhoneCountryCode" value=''>	
				<input type="hidden" id="OfficePhoneCountryCode" name="OfficePhoneCountryCode" value=''>
				<input type="hidden" id="HomeCountryPhoneCountryCode" name="HomeCountryPhoneCountryCode" value=''>	
			
				
			
			<input type="hidden" id="wdesk:title_new" name="wdesk:title_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("title_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("title_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:gender_new" name="wdesk:gender_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("gender_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("gender_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:prefOfLanguage" name="wdesk:prefOfLanguage" value='<%=((CustomWorkdeskAttribute)attributeMap.get("prefOfLanguage")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("prefOfLanguage")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:peopleOfDeterm" name="wdesk:peopleOfDeterm" value='<%=((CustomWorkdeskAttribute)attributeMap.get("peopleOfDeterm")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("peopleOfDeterm")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:PODOptions" name="wdesk:PODOptions" value='<%=((CustomWorkdeskAttribute)attributeMap.get("PODOptions")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PODOptions")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:pref_add_new" id="wdesk:pref_add_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("pref_add_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("pref_add_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:us_citizen_new" name="wdesk:us_citizen_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("us_citizen_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("us_citizen_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:us_tax_payer_new" name="wdesk:us_tax_payer_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("us_tax_payer_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("us_tax_payer_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:usgreencardhol_new" name="wdesk:usgreencardhol_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("usgreencardhol_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("usgreencardhol_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:usresi_new" name="wdesk:usresi_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("usresi_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("usresi_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:usnatholder_new" name="wdesk:usnatholder_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("usnatholder_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("usnatholder_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:ssn_security_num_new" name="wdesk:ssn_security_num_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ssn_security_num_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ssn_security_num_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:resd_type_new" name="wdesk:resd_type_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("resd_type_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resd_type_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:emp_type_new" name="wdesk:emp_type_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("emp_type_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("emp_type_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:employment_status_new" name="wdesk:employment_status_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("employment_status_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("employment_status_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:pref_mail_address_new" name="wdesk:pref_mail_address_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("pref_mail_address_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("pref_mail_address_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:pref_contact_new" name="wdesk:pref_contact_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("pref_contact_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("pref_contact_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:pref_email_new" name="wdesk:pref_email_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("pref_email_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("pref_email_new")).getAttribValue().toString()%>'>
			<!--Added by Shamily to add OECD Details hidden Fields  -->
			<input type="hidden" id="wdesk:OECDUndocreason_new" name="wdesk:OECDUndocreason_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDUndocreason_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDUndocreason_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:OECDtinreason_new" name="wdesk:OECDtinreason_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:OECDtinreason_new2" name="wdesk:OECDtinreason_new2" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new2")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:OECDtinreason_new3" name="wdesk:OECDtinreason_new3" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new3")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:OECDtinreason_new4" name="wdesk:OECDtinreason_new4" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new4")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:OECDtinreason_new5" name="wdesk:OECDtinreason_new5" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new5")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:OECDtinreason_new6" name="wdesk:OECDtinreason_new6" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDtinreason_new6")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:MiscellaniousId1" name="wdesk:MiscellaniousId1" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId1")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId1")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:MiscellaniousId2" name="wdesk:MiscellaniousId2" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId2")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId2")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:MiscellaniousId3" name="wdesk:MiscellaniousId3" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId3")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId3")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:MiscellaniousId4" name="wdesk:MiscellaniousId4" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId4")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId4")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:MiscellaniousId5" name="wdesk:MiscellaniousId5" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId5")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId5")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:MiscellaniousId6" name="wdesk:MiscellaniousId6" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId6")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MiscellaniousId6")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:OECDUndoc_Flag_new" id="wdesk:OECDUndoc_Flag_new"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("OECDUndoc_Flag_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OECDUndoc_Flag_new")).getAttribValue().toString()%>'>	
			
			<input type="hidden" id="wdesk:E_Stmnt_regstrd_new" name="wdesk:E_Stmnt_regstrd_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("E_Stmnt_regstrd_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("E_Stmnt_regstrd_new")).getAttribValue().toString()%>'>
			<!-- Added to get E-statement value on load-->
			<input type="hidden" id="wdesk:E_Stmnt_regstrd_newload" name="wdesk:E_Stmnt_regstrd_newload" value=''>
			<input type="hidden" id="wdesk:del_channel_new" name="wdesk:del_channel_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("del_channel_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("del_channel_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:marrital_status_new" name="wdesk:marrital_status_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("marrital_status_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("marrital_status_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:country_of_res_new" name="wdesk:country_of_res_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("country_of_res_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("country_of_res_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:spl_offr_req_new" name="wdesk:spl_offr_req_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("spl_offr_req_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("spl_offr_req_new")).getAttribValue().toString()%>'>
			<input type="hidden" id="wdesk:occupation_new" name="wdesk:occupation_new" value='<%=((CustomWorkdeskAttribute)attributeMap.get("occupation_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("occupation_new")).getAttribValue().toString()%>'>			
			<input type='hidden' name="wdesk:WI_NAME" id="wdesk:WI_NAME" value='<%=WINAME%>' >			

			<input type="hidden" name="wdesk:abcdelig_new" id="wdesk:abcdelig_new"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("abcdelig_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("abcdelig_new")).getAttribValue().toString()%>'>										
			<input type="hidden" name="wdesk:cif_data_update" id="wdesk:cif_data_update" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("cif_data_update")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("cif_data_update")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:sign_update" id="wdesk:sign_update" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sign_update")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sign_update")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:sole_joint" id="wdesk:sole_joint" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sole_joint")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sole_joint")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:joint_sole" id="wdesk:joint_sole"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("joint_sole")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("joint_sole")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:dorman_activation" id="wdesk:dorman_activation"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("dorman_activation")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("dorman_activation")).getAttribValue().toString()%>'>
			<!--input type="hidden" name="wdesk:KYC_Update" id="wdesk:KYC_Update" value = ''-->
			<!-- <input type="hidden" name="wdesk:resiadd_exis" id="wdesk:resiadd_exis"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("resiadd_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("resiadd_exis")).getAttribValue().toString()%>'> 
			 <input type="hidden" name="wdesk:office_add_exis" id="wdesk:office_add_exis"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("office_add_exis")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("office_add_exis")).getAttribValue().toString()%>'> -->
			<input type="hidden" name="wdesk:TypeOfRelation_new" id="wdesk:TypeOfRelation_new"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("TypeOfRelation_new")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TypeOfRelation_new")).getAttribValue().toString()%>'>
			<input type="hidden" name="wdesk:Estrepltext" id="wdesk:Estrepltext"  value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Estrepltext")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Estrepltext")).getAttribValue().toString()%>'> 			
			<input type="hidden" name="wdesk:world_check_req" id="wdesk:world_check_req" value="No">				
			<input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='<%=WSNAME%>' />	
			<input type='hidden' name="wdesk:wi_name" id="wdesk:wi_name" value='<%=WINAME%>' />	
			<input type="hidden" id="H_CHECKLIST" name="H_CHECKLIST" />
			<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"   />
			<input type="hidden" id="wdesk:Request_Type_Master" name="Request_Type_Master" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Request_Type_Master")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Request_Type_Master")).getAttribValue().toString()%>'>			
			<input type="hidden" id="wdesk:CIFReq_Type" name="CIFReq_Type" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIFReq_Type")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CIFReq_Type")).getAttribValue().toString()%>'>
			<input type="hidden" id="signature_update" name="signature_update">
			<input type="hidden" id="dormancy_activation" name="dormancy_activation">
			<input type="hidden" id="sole_to_joint" name="sole_to_joint">
			<input type="hidden" id="joint_to_sole" name="joint_to_sole">
			<input type="hidden" id="minor_to_major" name="minor_to_major">
			<input type="hidden" id="poa_addition" name="poa_addition">
			<input type="hidden" id="poa_deletion" name="poa_deletion">
			<input type="hidden" name="wdesk:Reject_WS" id="wdesk:Reject_WS" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Reject_WS")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Reject_WS")).getAttribValue().toString()%>'>			
			<!-- <input type="hidden" id="wdesk:armName" name="wdesk:armName" value='<%=((CustomWorkdeskAttribute)attributeMap.get("armName")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("armName")).getAttribValue().toString()%>'>	-->
			<input type="hidden" id="wdesk:CIF_Type" name="wdesk:CIF_Type" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_Type")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CIF_Type")).getAttribValue().toString()%>'>
			
			<input type="hidden" id="phone1" name="phone1" value="<PhnDetails><PhnType>Phone1</PhnType><PhnPrefFlag></PhnPrefFlag><PhnCountryCode></PhnCountryCode><PhnCityCode></PhnCityCode><PhnLocalCode></PhnLocalCode><PhoneNo></PhoneNo><PhnExtn></PhnExtn></PhnDetails>">			
			<input type="hidden" id="phone2" name="phone2" value="<PhnDetails><PhnType>Phone2</PhnType><PhnPrefFlag></PhnPrefFlag><PhnCountryCode></PhnCountryCode><PhnCityCode></PhnCityCode><PhnLocalCode></PhnLocalCode><PhoneNo></PhoneNo><PhnExtn></PhnExtn></PhnDetails>">			
			<input type="hidden" id="HomePhone" name="HomePhone" value="<PhnDetails><PhnType>HomePhone</PhnType><PhnPrefFlag></PhnPrefFlag><PhnCountryCode></PhnCountryCode><PhnCityCode></PhnCityCode><PhnLocalCode></PhnLocalCode><PhoneNo></PhoneNo><PhnExtn></PhnExtn></PhnDetails>">			
			<input type="hidden" id="OfficePhone" name="OfficePhone" value="<PhnDetails><PhnType>OfficePhone</PhnType><PhnPrefFlag></PhnPrefFlag><PhnCountryCode></PhnCountryCode><PhnCityCode></PhnCityCode><PhnLocalCode></PhnLocalCode><PhoneNo></PhoneNo><PhnExtn></PhnExtn></PhnDetails>">			
			<input type="hidden" id="HomeCountryPhone" name="HomeCountryPhone" value="<PhnDetails><PhnType>HomeCountryPhone</PhnType><PhnPrefFlag></PhnPrefFlag><PhnCountryCode></PhnCountryCode><PhnCityCode></PhnCityCode><PhnLocalCode></PhnLocalCode><PhoneNo></PhoneNo><PhnExtn></PhnExtn></PhnDetails>">			
			<input type="hidden" id="Fax" name="Fax" value="<PhnDetails><PhnType>Fax</PhnType><PhnPrefFlag></PhnPrefFlag><PhnCountryCode></PhnCountryCode><PhnCityCode></PhnCityCode><PhnLocalCode></PhnLocalCode><PhoneNo></PhoneNo><PhnExtn></PhnExtn></PhnDetails>">			
			<input type="hidden" id="primaryemail" name="primaryemail" value="<EmailDet><MailIdType>Primary</MailIdType><MailPrefFlag>Y</MailPrefFlag><EmailID></EmailID></EmailDet>">			
			<input type="hidden" id="secondaryemail" name="secondaryemail" value="<EmailDet><MailIdType>Secondary</MailIdType><MailPrefFlag>N</MailPrefFlag><EmailID></EmailID></EmailDet>">			
			<input type="hidden" id="doc_emiratesid" name="doc_emiratesid" value="<DocumentDet><DocType>EmiratesID</DocType><DocId></DocId><DocExpDt></DocExpDt><DocIssDate></DocIssDate><IsDocVerified>Y</IsDocVerified><IssuedOrganisation>DU</IssuedOrganisation></DocumentDet>">			
			<input type="hidden" id="doc_passport" name="doc_passport" value="<DocumentDet><DocType>Passport</DocType><DocId></DocId><DocExpDt></DocExpDt><DocIssDate></DocIssDate><IsDocVerified>Y</IsDocVerified><IssuedOrganisation>DU</IssuedOrganisation></DocumentDet>">			
			<input type="hidden" id="doc_visa" name="doc_visa" value="<DocumentDet><DocType>Visa</DocType><DocId></DocId><DocExpDt></DocExpDt><DocIssDate></DocIssDate><IsDocVerified>Y</IsDocVerified><IssuedOrganisation>DU</IssuedOrganisation></DocumentDet>">							
			<input type="hidden" id="residence_address" name="residence_address" value="<AddrDet><AddressType>RESIDENCE</AddressType><EffectiveFrom>2011-07-20</EffectiveFrom><EffectiveTo>2049-12-31</EffectiveTo><HoldMailFlag>Y</HoldMailFlag><HoldMailBCName>TestBC Name</HoldMailBCName><HoldMailReason>aaaaaaaaaaaaaa</HoldMailReason><ReturnFlag>N</ReturnFlag><AddrPrefFlag>N</AddrPrefFlag><AddrLine1></AddrLine1><AddrLine2></AddrLine2><AddrLine3></AddrLine3><AddrLine4></AddrLine4><ResType></ResType><POBox></POBox><ZipCode/><State></State><City></City><CountryCode></CountryCode></AddrDet>">			
			<input type="hidden" id="office_address" name="office_address" value="<AddrDet><AddressType>OFFICE</AddressType><EffectiveFrom>2011-07-20</EffectiveFrom><EffectiveTo>2049-12-31</EffectiveTo><HoldMailFlag>Y</HoldMailFlag><HoldMailBCName>TestBCName</HoldMailBCName><HoldMailReason>aaaaaaaaaaaaaa</HoldMailReason><ReturnFlag>N</ReturnFlag><AddrPrefFlag>N</AddrPrefFlag><AddrLine1></AddrLine1><AddrLine2></AddrLine2><AddrLine3></AddrLine3><AddrLine4></AddrLine4><ResType></ResType><POBox></POBox><ZipCode/><State></State><City></City><CountryCode></CountryCode></AddrDet>">			
			<input type="hidden" id="wdesk:Acc_Number_received" name="wdesk:Acc_Number_received" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Acc_Number_received")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Acc_Number_received")).getAttribValue().toString()%>'>				
				
			<div class="accordion-group" style="display: none;">
				<div class="accordion-heading">
					<h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel21">
							<b style="COLOR: white;">World Check Details</b>
						</a>
					</h4>
				</div>
                <div id="panel21" class="accordion-body collapse in">
                    <div class="accordion-inner">
						<table border="2" id ="myTable">
							<thead>
							<tr><td width = 20% nowrap='nowrap' class='EWNormalGreenGeneral1'><b>S.No</td><td width = '30%' nowrap='nowrap' class='EWNormalGreenGeneral1'><b>UID</td><td width = '50%' nowrap='nowrap' class='EWNormalGreenGeneral1'><b>Remarks</td><td></td></tr>
							</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td><input type='text' size='35' id='UID_"+k+"' ></td>
								<td><input type='text' size='50' id='wdesk:remarks1'></td>
								<td>
									<img src='\CU\webtop\images\delete.gif' style="width:21px;height:21px;border:0;" onclick='delRow();'>
								</td>
							</tr>
						</tbody>
						</table>
					</div>
				</div>
			</div>			
			<div class="accordion-group">
				<div class="accordion-heading" id="div_Decision">
					<h4 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel22" id="decision_tab"><b style="COLOR: white;">Decision</b></a>
					</h4>
				</div>
                <div id="panel22" class="accordion-body collapse in">
                    <div class="accordion-inner">
						<table id="TAB_Decision" border='1' cellspacing='1' cellpadding='0' width=100% >
							<tr width=100%>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' width="20%">
									<b>Decision</b>
								</td> 
								<%										
								if(WSNAME.equalsIgnoreCase("CSO_Rejects"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_CSO_Rejects" name="Dec_CSO_Rejects" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Resubmit">Resubmit</option>
											<option value="Follow-up">Follow-up</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Hold"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Hold" name="Dec_Hold" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Resubmit">Resubmit</option>
											<option value="Close">Close</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("CB_WC"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_CB_WC" name="Dec_CB_WC" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Match Found">Match Found</option>
											<option value="No Match Found">No Match Found</option>
											<option value="Reject">Reject</option>
										</select>
									</td>										
								<%
								}
								else if(WSNAME.equalsIgnoreCase("PBO_Rejects"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="PBORejectDecision" name="PBORejectDecision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Resubmit">Resubmit</option>
											<option value="Reject">Reject</option>
											<option value="Follow-Up">Follow-Up</option>
										</select>
									</td>										
								<%
								}
								else if(WSNAME.equalsIgnoreCase("OPS_Checker_Review") )
								{
									String channel=((CustomWorkdeskAttribute)attributeMap.get("channel")).getAttribValue().toString();
									if(channel.equalsIgnoreCase("RM Initiated"))
									{
									%>
										<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
											<select class='NGReadOnlyView' id="Dec_OPS_Checker" name="Dec_OPS_Checker" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
												<option value="--Select--">--Select--</option>
												<option value="Approved">Approved</option> 
												<option value="Reject To CSO">Reject To CSO</option>
												<option value="Reject To Maker">Reject To Maker</option> 
											</select>
										</td>												
									<% 
									} 
									else if(channel.equalsIgnoreCase("Customer Initiated") )
									{
									%>
										<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
											<select class='NGReadOnlyView' id="Dec_OPS_Checker" name="Dec_OPS_Checker" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
												<option value="--Select--">--Select--</option>
												<option value="Approved">Approved</option> 
												<option value="Reject To CSO">Reject To CSO</option> 
												<option value="Reject To Maker">Reject To Maker</option> 
											</select>
										</td>
										
										
									<%
									}
									else 
									{
									%>
										<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
											<select class='NGReadOnlyView' id="Dec_OPS_Checker" name="Dec_OPS_Checker" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
												<option value="--Select--">--Select--</option>
												<option value="Approved">Approved</option> 
												<option value="Reject To PBO">Reject To PBO</option>
												<option value="Reject To Maker">Reject To Maker</option>
											</select>
										</td>											
									<%	
									}
								}
								else if(WSNAME.equalsIgnoreCase("Cards_Deletion"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Card_Deletion" name="Dec_Card_Deletion" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Reject To OPS">Reject To OPS</option>
											<option value="Deletion Complete">Deletion Complete</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Finacle_DE_Maker"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Finacle_Maker" name="Dec_Finacle_Maker" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Reject To OPS Checker">Reject To OPS Checker</option>
											<option value="Data Entry Complete">Data Entry Complete</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Finacle_DE_Checker"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Finacle_Checker" name="Dec_Finacle_Checker" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Close">Close</option>
											<option value="Reject">Reject</option>
											
										</select>
									</td>										
								<%
								}
								else if(WSNAME.equalsIgnoreCase("CSO_Doc_Scan"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Doc_Scan_Dec" name="Doc_Scan_Dec" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Submit">Submit</option>
										</select>
									</td>										
								<%
								}
								else if(WSNAME.equalsIgnoreCase("CB_WC_Checker_Review"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_CB_WC_Checker" name="Dec_CB_WC_Checker" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Exception Found">Exception Found</option>
											<option value="Reject To Maker">Reject To Maker</option>
											<option value="Reject To CSO">Reject To CSO</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("CB_WC_Controls"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_CB_WC_Controls" name="Dec_CB_WC_Controls" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Reject To Maker">Reject To Maker</option>
											<option value="Reject To CSO">Reject To CSO</option>
											<option value="Reject to Ops">Reject to Ops</option>
											<option value="Refer To Compliance">Refer To Compliance</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Compliance"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Compliance" name="Dec_Compliance" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Reject To Maker">Reject To Maker</option>
											<option value="Reject To CSO">Reject To CSO</option>
											<option value="Reject to Controls">Reject to Controls</option>
										</select>
									</td>
							
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Card_Deletion"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Card_Deletion" name="Dec_Card_Deletion" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Reject To OPS Checker">Reject To OPS Checker</option>
											<option value="Deletion Complete">Deletion Complete</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("SME_Credit_Approval"))
								{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_SME_Credit" name="Dec_SME_Credit" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Reject">Reject</option>
										</select>
									</td>	
								<%
								}
								else if(WSNAME.equalsIgnoreCase("CSM_Review")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_CSM_Review" name="Dec_CSM_Review" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Reject">Reject</option>
										</select>
									</td>										
								<%
								}
								else if(WSNAME.equalsIgnoreCase("OPS%20Maker_DE")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="OPSMakerDEDecision" name="OPSMakerDEDecision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
										
											<option value="Approve">Approve</option>
											<option value="Reject">Reject</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("PB_Credit_Approval")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_PB_Credit" name="Dec_PB_Credit" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Reject">Reject</option>
										</select>
									</td>										
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Crops_Approval")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="Dec_Crops_Approval" name="Dec_Crops_Approval" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approved">Approved</option>
											<option value="Reject">Reject</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Archival_Activity")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="ArchivalActivityDecision" name="ArchivalActivityDecision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approve">Approve</option>
											<option value="Reject">Reject</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Error")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="ErrorDecision" name="ErrorDecision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Do Not Integrate">Do Not Integrate</option>
											<option value="Re-Integrate">Re-Integrate</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("Archival_Rejects")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="ArchivalRejectsDecision" name="ArchivalRejectsDecision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Resubmit">Resubmit</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("System_Update")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="isSysUpdateSuccess" name="isSysUpdateSuccess" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</td>
								<%
								}
								else if(WSNAME.equalsIgnoreCase("PBO")){
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="PBOdecision" name="PBOdecision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											<option value="--Select--">--Select--</option>
											<option value="Approve">Approve</option>
										</select>
									</td>
								<%
								}										
								else{
								%>
									<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
										<select class='NGReadOnlyView' id="decision" name="decision" style="width: 219px;" onchange="changeVal(this,'<%=WSNAME%>')">
											
											<option value="Approved">Approved</option>
											<option value="Reject">Reject</option>
										</select>
									</td>
								<%}%>
								
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' colspan=2>
									<input type="button" style="width:100px" class='EWButtonRB NGReadOnlyView' id="btnRejReason" onclick="openCustomDialog('Reject Reasons','<%=WSNAME%>');"value="Reject Reasons">
								</td>
							</tr>
							<tr width=100%>
								<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' width="20%">
									Remarks
								</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%">
									<textarea class='NGReadOnlyView' style="width: 100%;" rows="3" cols="50" id="wdesk:remarks"></textarea>
								</td>
								<td style="padding-left: 5px;" colspan=2>
									<input name="dec_history" type="button" id="dec_history" value="Decision History" class="EWButtonRB" style="width:100px" onclick="openCustomDialog('Save History','<%=WSNAME%>');">
								</td>
							</tr>
							<tr width=100%>
							<td style="padding-left: 5px;" nowrap='nowrap' class='EWNormalGreenGeneral1' width="20%"><b>Sign. Verified Ops Checker</b></td>						
							<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' size="19" name="wdesk:sign_matched_checker"  id="wdesk:sign_matched_checker" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_checker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("sign_matched_checker")).getAttribValue().toString()%>' disabled='true'></td>
							<td nowrap='nowrap' class='EWNormalGreenGeneral1' width="40%"></td>
							</tr>
						</table>
					</div>
				</div>
			</div>	
		</div>	
	</form>		
	<script language="JavaScript" src="/CU/webtop/scripts/calendar_SRM.js"></script>		
</body>
</html>
<%
}
%>