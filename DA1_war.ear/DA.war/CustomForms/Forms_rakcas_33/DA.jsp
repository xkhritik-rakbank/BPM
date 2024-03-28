<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : blank_withLogo.jsp          
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Shows blank screen with Logo
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.text.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="org.apache.log4j.PropertyConfigurator" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.io.*",java.util.*%>
<%@ include file="../header.process" %>

<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%!


final static Logger logger = Logger.getLogger("CustomLog");

public static void WriteLog(String strMsg) throws Exception
{
	StringBuffer strFilePath = new StringBuffer(50);
	File dir= null;
	FileOutputStream fos = null;
	String sFileName = "CustomLog.Log";
	Writer wrt = null;
	
	DateFormat dtFormat = new SimpleDateFormat("ddMMyyyy");
	String sFName = "CustomLog_RakBank" + dtFormat.format(new java.util.Date())+"_DA.Log";	

    System.out.println(sFName);
	try
	{
		strFilePath.append(System.getProperty("user.dir"));
		
		
		System.out.println(sFileName);
		dir = new File(strFilePath.toString(), "CustomLog");
		if (!dir.exists()) 
		{
			dir.mkdir();
		}
		strFilePath.append(File.separatorChar);
		strFilePath.append("CustomLog");
		strFilePath.append(File.separatorChar);
		strFilePath.append(sFName);
        System.out.println(strFilePath.toString()); 
		java.util.Date objDate=new java.util.Date();
		fos = new FileOutputStream(strFilePath.toString(),true);
		wrt = new BufferedWriter(new OutputStreamWriter(fos));
		wrt.write("[" + objDate.toString() + "]\n" + strMsg + "\n\n" );
		wrt.flush();
		wrt.close();
	}
	catch(Exception e)
	{
	
		System.out.println(e.toString());
	}	
}
%>
<%

//code for esapi implementation starts here.
	String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput",WINAME, 10000, true) );
	String WINAME_esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
	if(WINAME_esapi.indexOf("alert(") > -1)
	{
		WINAME_esapi = WINAME_esapi.replaceAll("alert("," ");
	}
	if(WINAME_esapi.indexOf("'") > -1)
	{
		WINAME_esapi = WINAME_esapi.replaceAll("'"," ");
	}
	
	String input22 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput",WSNAME, 10000, true) );
	String WSNAME_esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input22!=null?input22:"");
	WSNAME_esapi = WSNAME_esapi.replaceAll("&#x25;20"," ");
	if(WSNAME_esapi.indexOf("alert(") > -1)
	{
		WSNAME_esapi = WSNAME_esapi.replaceAll("alert("," ");
	}
	if(WSNAME_esapi.indexOf("'") > -1)
	{
		WSNAME_esapi = WSNAME_esapi.replaceAll("'"," ");
	}
//ends here.
	
if (parameterMap != null && parameterMap.size() > 0) {
 
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	WriteLog("sCabName XML:"+sCabName);
	WriteLog("sSessionId XML:"+sSessionId);
	WriteLog("sJtsIp XML:"+sJtsIp);
	WriteLog("iJtsPort XML:"+iJtsPort);
	
	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	String outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME_esapi, wid, "", "", "", "", "", "", "", activityId, routeID);
	WriteLog("Output XML:"+outputXmlFetch);
	
	WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
    attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";
	
	CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
	LinkedHashMap varIdMap = new LinkedHashMap();
	attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	session = request.getSession(false);
	WriteLog("AttributeMap:"+attributeMap);

%>
<HTML>
<f:view>
<HEAD>
<style>
	@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<TITLE> RAKBANK-Service Request Module</TITLE>

<script src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
<script language="javascript" src="/DA/webtop/scripts/clientDA.js"></script>


<script language="javascript">  
	//document.write("<link type='text/css' rel='stylesheet' href='/webdesktop/webtop/en_us/css/Theme/"+getTheme()+"/docstyle.css'>");
	var message="Function Disabled!"; 
	function clickIE4()
	{
		if (event.button==2)
		{
			alert(message); return false;
		}
	}
 
	function clickNS4(e)
	{
		if (document.layers||document.getElementById&&!document.all)
		{
			if (e.which==2||e.which==3)
			{
				alert(message); 
				return false; 
			}
		} 
	} 
	
		function initialize(eleId) {

			var cal1 = new calendarfn(document.getElementById(eleId));
			cal1.year_scroll = true;
			cal1.time_comp = false;
			cal1.popup();
			return true;
		}
	
	if (document.layers)
	{ 
		document.captureEvents(Event.MOUSEDOWN); document.onmousedown=clickNS4; 
	} 
	else if (document.all&&!document.getElementById)
	{ 
		document.onmousedown=clickIE4; 
	} 
</script>

	 <script>
		if (typeof window.event != 'undefined'){ // IE
			document.onkeydown = function(e) // IE
			{
				var t=event.srcElement.type;
				var kc=event.keyCode;
				if(event.keyCode==83 && event.altKey){
					window.parent.workdeskOperations('S');
				}
				else if(event.keyCode==73 && event.altKey){
					window.parent.workdeskOperations('I');
				}
				else if (kc == 116) {
					window.event.keyCode = 0;
					return false;
				}
				else
					return ((kc != 8 ) || ( t == 'text') || (t == 'textarea') || ( t == 'submit') ||  (t == 'password'))
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
			if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]'){
			  document.getElementById('rejReasonCodes').value = popupWindow;
			}
	   }		
	}
	//ends here.
	//added by siva to show reject reasons 
	function openCustomDialog(dialogToOpen, workstepName) 
	{
		dialogToOpenType = dialogToOpen;
		if (dialogToOpen == 'Reject Reasons') {

				var WSNAME = '<%=WSNAME_esapi%>';
				var wi_name = '<%=WINAME_esapi%>';
				var rejectReasons = document.getElementById('rejReasonCodes').value;
				
				sOptions = 'dialogWidth:500px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; status:no; scroll:no; help:no; resizable:no';
				
				var username = '';
				//var popupWindow = window.showModalDialog('../DA_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons)+ "&username=" + username, null, sOptions);
				//var popupWindow;
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
				/***********************************************************/
				var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
				if (window.showModalDialog) {
					var popupWindow = window.showModalDialog('../DA_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons)+ "&username=" + username, null, sOptions);
				} else {
					popupWindow = window.open('../DA_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons)+ "&username=" + username, null,windowParams);
				}
				/************************************************************/
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
				
				//Set the response code to the input with id = rejReasonCodes
				
				if(popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					document.getElementById('rejReasonCodes').value = popupWindow;	
				
			}
		
	}
	
	function setComboValueToTextBox(dropdown, inputTextBoxId) 
	{
			var WSNAME = '<%=WSNAME_esapi%>';
			document.getElementById(inputTextBoxId).value = dropdown.value;
			if(dropdown.value=='Reject & Partial Acknowledged' || dropdown.value=='Hold')
			document.getElementById("RejectReason").disabled= false;
			else
			document.getElementById("RejectReason").disabled= true;
			
			// Added for decision onchange enable the reject reason button added by sharan 23-20-2020
			
			if(dropdown.id=='selectDecision')
			{
			onChangeDecision(dropdown);
			}
			
			// Added for AutoLoan CR_03022018
			if(dropdown.id=='selectArchivalType')
			{
				onChangeArchivalType(dropdown);
				
				if(WSNAME=='Archival Document Reject' || WSNAME=='Archival Document Initiation')
				{
					setdecisionForArchType(WSNAME);
				}				
			}
			//*******************************
			if(WSNAME=='OPS Maker')
			{
				if(document.getElementById('selectCustomer_Type').value == 'Customer - Individual' || document.getElementById('selectCustomer_Type').value == 'Customer - Business')
				{
					document.getElementById('wdesk:CIFNumber').disabled = false;
				} else 
				{
					document.getElementById('wdesk:CIFNumber').disabled = true;
				}
			}
	}
	// Added for AutoLoan CR_03022018
	//Condition Modified on 19/04/2019. 
	function onChangeArchivalType(dropdown)
	{
		var WSNAME = '<%=WSNAME_esapi%>';	
		if(dropdown.value=='Auto Loan' ||dropdown.value=='Mortgage Loan' || dropdown.value=='Credit Card' || dropdown.value=='Personal Loan')
		{
					document.getElementById("wdesk:Processed_date").disabled=true;	
					document.getElementById("processed_dateCal").disabled=true;
					document.getElementById("wdesk:ProfileChangeWINumber").disabled=true;	
					document.getElementById("wdesk:Processed_date").value='';	
					document.getElementById("wdesk:ProfileChangeWINumber").value='';	
					
					document.getElementById("wdesk:CustomerName").disabled=false; 
					if (dropdown.value=='Personal Loan')
					{
						if(WSNAME=='Archival Document Initiation' || WSNAME=='Data Entry')
							document.getElementById("wdesk:CIFNumber").disabled=false; 
						else
							document.getElementById("wdesk:CIFNumber").disabled=true; 
					} else
						document.getElementById("wdesk:CIFNumber").disabled=false; 
					document.getElementById("wdesk:SRNumber").disabled=false; 
					document.getElementById("wdesk:Description").disabled=false; 
						
		}
		else if(dropdown.value=='Service Request Branch' || dropdown.value=='CIF Update')
		{
			document.getElementById("wdesk:Processed_date").disabled=false;	
			document.getElementById("processed_dateCal").disabled=false; 
			
			document.getElementById("wdesk:CustomerName").disabled=true; 
			document.getElementById("wdesk:CIFNumber").disabled=true;
			document.getElementById("wdesk:SRNumber").disabled=true;
			document.getElementById("wdesk:Description").disabled=true;
			document.getElementById("wdesk:ProfileChangeWINumber").disabled=true;
			
			document.getElementById("wdesk:CustomerName").value=''
			document.getElementById("wdesk:CIFNumber").value='';
			document.getElementById("wdesk:SRNumber").value='';
			document.getElementById("wdesk:Description").value='';			
			document.getElementById("wdesk:ProfileChangeWINumber").value='';			
		}
		else if(dropdown.value=='Profile Change')
		{
			document.getElementById("wdesk:Processed_date").disabled=false;	
			document.getElementById("processed_dateCal").disabled=false; 
			document.getElementById("wdesk:ProfileChangeWINumber").disabled=false; 
			
			document.getElementById("wdesk:CustomerName").disabled=true; 
			document.getElementById("wdesk:CIFNumber").disabled=true;
			document.getElementById("wdesk:SRNumber").disabled=true;
			document.getElementById("wdesk:Description").disabled=true;
			
			document.getElementById("wdesk:CustomerName").value=''
			document.getElementById("wdesk:CIFNumber").value='';
			document.getElementById("wdesk:SRNumber").value='';
			document.getElementById("wdesk:Description").value='';			
		}	
		/*below fields disabled on select the dropdown value is Court Instructions and Other Police letters added by sharan CR development 22-01-2020*/
		else if(dropdown.value=='Court Instructions and Other Police Letters')
		{
			document.getElementById("wdesk:Processed_date").disabled=true;	
			document.getElementById("processed_dateCal").disabled=true;
			document.getElementById("wdesk:CustomerName").disabled=true; 
			document.getElementById("wdesk:CIFNumber").disabled=true;
			document.getElementById("wdesk:SRNumber").disabled=true;
			document.getElementById("wdesk:Description").disabled=true;
			document.getElementById("wdesk:ProfileChangeWINumber").disabled=true;
		}
		else if(dropdown.value=='--Select--')
		{
			document.getElementById("wdesk:Processed_date").disabled=true;	
			document.getElementById("processed_dateCal").disabled=true;
			document.getElementById("wdesk:CustomerName").disabled=true; 
			document.getElementById("wdesk:CIFNumber").disabled=true;
			document.getElementById("wdesk:SRNumber").disabled=true;
			document.getElementById("wdesk:Description").disabled=true;
			document.getElementById("wdesk:ProfileChangeWINumber").disabled=true;
		}
		
	}
	
	// Added for decision onchange enable the reject reason button added by sharan 23-20-2020
	function onChangeDecision(dropdown)
	{
		var WSNAME1 = '<%=WSNAME_esapi%>';	
		//alert("dropdown.value --"+dropdown.value);
		if(dropdown.value=='Reject to Collection Maker')
		{
			if(WSNAME1=='Collection Checker')
			{
				document.getElementById("RejectReason").disabled=false;	
			}
		}	
	}
	
	
	function HistoryCaller()
	{
		//For loading history
		
		var hist_table="usr_0_da_wihistory";
		var WINAME=document.getElementById("wdesk:wi_name").value;
		var WSNAME=document.getElementById("wdesk:Ws_name").value;
	
		openWindow("../DA_Specific/history.jsp?WINAME="+WINAME+"&WSNAME="+WSNAME+"&hist_table="+hist_table,'wihistory','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,resizable=no,width=800,height=400');
	}
	
	document.MyActiveWindows= new Array;
	
	function openWindow(sUrl,sName,sProps)
	{
		//alert(sUrl);
		document.MyActiveWindows.push(window.open(sUrl,sName,sProps));
	}
	
	function CallJSP()
	{
	
		if(document.getElementById("wdesk:Archival_Type").value!="")
		document.getElementById("selectArchivalType").value=document.getElementById("wdesk:Archival_Type").value;
		else
		document.getElementById("selectArchivalType").value='--Select--';
		
		if(document.getElementById("wdesk:Ws_name").value!='Archival Document Initiation')
		{
			document.getElementById("wdesk:sol_Id").disabled = true;
			if(document.getElementById("wdesk:Ws_name").value!='Archival Document Reject')
			{
				document.getElementById("selectArchivalType").disabled = true;
				document.getElementById("wdesk:Processed_date").disabled = true;
			}
		}
		var Processed_date = document.getElementById("wdesk:Processed_date").value;
		if(Processed_date != "" && Processed_date!=null)
		{
			Processed_date = Processed_date.substring(0,10);
			document.getElementById("wdesk:Processed_date").value =Processed_date;
		
			
		}
		// Added for AutoLoan CR_03022018
		onChangeArchivalType(document.getElementById("selectArchivalType"));
		
		//added for onchange decision CR added by sharan 23-01-2020
		//alert("document.getElementById(selectDecision) :"+document.getElementById("selectDecision"));
		onChangeDecision(document.getElementById("selectDecision"));
		//alert(" --document.getElementById(selectDecision) :"+document.getElementById("selectDecision"));
		disableEnableFields();
		//***************************
		
		// disabling all form field if wotkitem is open in Read Only Mode
		if((parent.document.title).indexOf("(read only)")>0)
		{
			readOnly="(read only)";
			var form = document.getElementById("wdesk");
			var elements = form.elements;
			for (var i = 0, len = elements.length; i < len; ++i) {
			
			if(elements[i].id!="history")
			elements[i].disabled = true;
			}
			document.getElementById("processed_dateCal").disabled = true;	
			
		}
		
	}
	// Added for AutoLoan CR_03022018
	function disableEnableFields()
	{
		if(document.getElementById("wdesk:Ws_name").value=='Internal Credit')
		{
			document.getElementById("wdesk:Processed_date").disabled=true;	
			document.getElementById("processed_dateCal").disabled=true;
			document.getElementById("wdesk:CustomerName").disabled=true;
		}	
		if(document.getElementById("wdesk:Ws_name").value=='External Credit')
		{
			document.getElementById("wdesk:Processed_date").disabled=true;	
			document.getElementById("processed_dateCal").disabled=true;
			document.getElementById("wdesk:CustomerName").disabled=true;
		}	
		if(document.getElementById("wdesk:Ws_name").value=='CPV')
		{
			document.getElementById("wdesk:Processed_date").disabled=true;	
			document.getElementById("processed_dateCal").disabled=true;
			document.getElementById("wdesk:CustomerName").disabled=true;
		}
		
		if(document.getElementById("wdesk:Ws_name").value=='Archival Document Receipt')
		{
			/*document.getElementById("wdesk:Processed_date").disabled=true;	
			document.getElementById("processed_dateCal").disabled=true;
			document.getElementById("wdesk:CustomerName").disabled=true;
			document.getElementById("wdesk:CIFNumber").disabled=false;
			document.getElementById("wdesk:SRNumber").disabled=false;
			document.getElementById("wdesk:Description").disabled=false;*/
		}	
		
		/* below validation added by sharan on 21-01-2020 CR development */
		
		if(document.getElementById("wdesk:Customer_Type").value!="")
		document.getElementById("selectCustomer_Type").value=document.getElementById("wdesk:Customer_Type").value;
		else
		document.getElementById("selectCustomer_Type").value='--Select--';
		
		if(document.getElementById("wdesk:Ws_name").value=='OPS Maker')
		{
			if(document.getElementById("wdesk:Archival_Type").value=='Court Instructions and Other Police Letters')
			{
				document.getElementById("selectCustomer_Type").disabled=false;	
				if(document.getElementById('selectCustomer_Type').value == 'Customer - Individual' || document.getElementById('selectCustomer_Type').value == 'Customer - Business')
				{
					document.getElementById('wdesk:CIFNumber').disabled = false;
				} else 
				{
					document.getElementById('wdesk:CIFNumber').disabled = true;
				}
			}
		}
		else if(document.getElementById("wdesk:Ws_name").value=='OPS Checker')
		{
			if(document.getElementById("wdesk:Archival_Type").value=='Court Instructions and Other Police Letters')
			{
				document.getElementById("wdesk:Court_Order_No").disabled=false;
				document.getElementById("wdesk:Letter_Reference").disabled=false;
			}
		}		
	}
	function ValidateAlphaNumeric(id,maxLength)
	{
		var value=document.getElementById(id).value;
		var newLength=value.length;
		//value=value.replace(/(\r\n|\n|\r)/gm," ");
		value=value.replace(/[^a-zA-Z0-9_.,&:;!@#$%*()={}\/\-\\" \r\n|\n|\r]/g,"");
		if(newLength>=maxLength){
			value=value.substring(0,maxLength);		
		}
		value=value.replace(/&/g,' and ');
		document.getElementById(id).value=value;
	}
	
	function validateProcessedDate(value)
	{
		if(value=='')
		return;
		var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		if (!pattern.test(value)) 
		{
			alert("Invalid date format.");
			document.getElementById("wdesk:Processed_date").value = "";
			return false;
		}
		else 
		{
			var currentTime = new Date();
            var dd = currentTime.getDate();
            var mm = currentTime.getMonth() + 1; //January is 0!            
            var yyyy = currentTime.getFullYear();            
            var arrStartDate = value.split("/");            
            var date2 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
            var timeDiffPassport = date2.getTime() - currentTime.getTime();
			if(timeDiffPassport > 0) 
			{
				alert("Processed date should not be future date.");
				document.getElementById("wdesk:Processed_date").value = "";
				return false;			
			}
		}
	}
	// Added for AutoLoan CR_03022018
	function ValidateCharacter(id) 
	{
		var inputtxt = document.getElementById(id).value;
		if (inputtxt == '')
			return;
		/*var inputtxt = document.getElementById(id);
		var characters = /^[0-9a-zA-Z \/]*$/;
		if (inputtxt.value.match(characters))
			return true;
		else {
			alert('Please input Alpha-Numeric only');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}*/
		
		inputtxt=inputtxt.replace(/(\r\n|\n|\r)/gm," ");
		inputtxt=inputtxt.replace(/[^0-9a-zA-Z \/]/g,"");
		document.getElementById(id).value=inputtxt;
	}
	// Added for AutoLoan CR_03022018
	function ValidateNumeric(id) 
	{
		var inputtxt = document.getElementById(id);
		if (inputtxt.value == '')
			return;
		var inputtxt = document.getElementById(id);
		var numbers = /^[0-9]+$/;
		if (inputtxt.value.match(numbers))
			return true;
		else {
			alert('Please enter numbers only');
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	// Added for AutoLoan CR_03022018
	function setdecisionForArchType(WSNAME)
	{
		var xhr;
		var ajaxResult;
		ajaxResult = "";
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		var archType = document.getElementById("wdesk:Archival_Type").value;
		var url = '../DA_Specific/GetDecisionByArchType.jsp?archType=' + archType +'&WSNAME='+WSNAME;
		xhr.open("GET", url, false);
		xhr.send(null);
		if (xhr.status == 200) 
		{
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			if (ajaxResult=='-1') 
			{
				alert("Error fetching data for decisions.");
				return false;
			}
			else
			{
				values = ajaxResult.split("|");
				document.getElementById("selectDecision").options.length=0;
				var opt = document.createElement('option');
				opt.text ='--Select--';
				opt.value ='--Select--';
				document.getElementById("selectDecision").options.add(opt);
				for (var i=0 ; i< values.length ; i++) 
				{
					var opt = document.createElement('option');
					opt.text = values[i];
					opt.value = values[i];
					document.getElementById("selectDecision").options.add(opt);
				}			
			}
		}
	}	
	  
	function enableCIFBasedOnCustomerType(id)
	{
		if (id.value == 'Customer - Individual' || id.value == 'Customer - Business')
		{
			document.getElementById("wdesk:CIFNumber").disabled = false;
		} 
		else
		{
			document.getElementById("wdesk:CIFNumber").disabled = true;
			document.getElementById("wdesk:CIFNumber").value = "";
		}
	}
	
	function closeAllWindows()
	{
		//alert("hi");
		for(var i = 0;i < document.MyActiveWindows.length; i++)
			document.MyActiveWindows[i].close();
	}
	</script>
		
	<script language="javascript">

		window.parent.top.resizeTo(window.screen.availWidth,window.screen.availHeight);
		window.parent.top.moveTo(0,0);

	</script>
</HEAD>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/aes.js"></script>
<script language="JavaScript" src="/DA/webtop/scripts/DA_Scripts/calendar_DA.js"></script>
<script language="javascript" src="/DA/webtop/scripts/clientDA.js"></script>
<!-- Added for AutoLoan CR_03022018 -->
<script language="javascript">
	//window.onunload = function(){closeAllWindows()};
	//WriteLog("REDDY");
	window.onbeforeunload = function(){closeAllWindows()};
	
</script>    

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "CallJSP();window.parent.checkIsFormLoaded();">

<form name="wdesk" id="wdesk" method="post" visibility="hidden" >
<table border='1' cellspacing='1' cellpadding='0' width=100% >
<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=left class='EWLabelRB2'><b>Document Archival Request</b></td>
</tr>
<tr>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;<%=customSession.getUserName()%></b><input type='hidden' name="wdesk:LoggedIn_as" id="wdesk:LoggedIn_as" value='<%=customSession.getUserName()%>'/></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Workstep"><b>&nbsp;<%=WSNAME_esapi%></b></label><input type='hidden' name="wdesk:Ws_name" id="wdesk:Ws_name" value='<%=WSNAME_esapi%>'/></td>
</tr>
<tr>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workitem Name</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;<%=WINAME_esapi%></b><input type='hidden' name="wdesk:wi_name" id="wdesk:wi_name" value='<%=WINAME_esapi%>'/></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>SOL Id</b></td>

<%
	//System.out.println("Inside DA.jsp");
	WriteLog("WSNAME is:"+WSNAME_esapi);
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlList objWorkList=null;
	String inputData="";
	String outputData="";
	String Query="";
	String maincode="";
	String params="";
	String solId=((CustomWorkdeskAttribute)attributeMap.get("sol_Id")).getAttribValue().toString();
	WriteLog("solId is:"+solId);
	
	if(WSNAME_esapi.equals("Archival Document Initiation"))
	{
		params="userName=="+userName;
		Query="SELECT comment FROM PDBUser with (nolock) WHERE UserName=:userName";
	}
	else if((WSNAME_esapi.equals("Archival Document Receipt") && solId.equals("")) || (WSNAME_esapi.equals("Internal Credit") && solId.equals("")))
	{
		WriteLog("Getting sol id as initiated by omniscan");
		params="winame=="+WINAME_esapi;
		Query="SELECT comment FROM PDBUser pdb,usr_0_da_wihistory hist with (nolock) WHERE hist.username=pdb.userName and hist.wsname='DA_Omniscan' and  winame=:winame";
	}
		
	if(WSNAME_esapi.equals("Archival Document Initiation") || (WSNAME_esapi.equals("Archival Document Receipt") && solId.equals("")) || (WSNAME_esapi.equals("Internal Credit") && solId.equals("")))
	{		
		inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";

			
		WriteLog("Query For Get Sol Id From Pdbuser-->"+inputData);		
		outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		WriteLog("Output Of Get Sol ID-->"+outputData);
		System.out.println("Output Of Get Sol ID-->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		maincode = WFCustomXmlResponseData.getVal("MainCode");
		
		int recordcountForSolId=1;
		try {  
                recordcountForSolId = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
        }catch(NumberFormatException ex){  
            System.err.println("Invalid string in argumment");  
        }  
		//recordcountForSolId=1;
		WriteLog("recordcountForSolId"+recordcountForSolId);
		if(maincode.equals("0"))
		{
			if(recordcountForSolId>0)
			{
			 %>	
			 <td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
			 <input type='hidden' name="wdesk:sol_Id" disabled id="wdesk:sol_Id" value='<%=WFCustomXmlResponseData.getVal("comment")%>'/>
			 <input type='text' name="SolID" disabled id="SolID" value='<%=WFCustomXmlResponseData.getVal("comment")%>'/>
			 </td>
			 
			  <%
			}		
		}
	} else {
		%>	
		 <td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		 <input type='text' name="wdesk:sol_Id" disabled id="wdesk:sol_Id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("sol_Id")).getAttribValue().toString()%>'/>
		 </td>
		 <%
	}
%>
</tr>
<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=left class='EWLabelRB2'><b>Archival Details </b></td>
</tr>
<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Archival Type</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><select  class="NGReadOnlyView" style='width:79%' name="selectArchivalType" id="selectArchivalType" onchange="setComboValueToTextBox(this,'wdesk:Archival_Type')">
						<option value="--Select--" selected="selected">--Select--</option>
						<%
																			
							Query="select ArchivalType from usr_0_da_Archival_Type with(nolock) where 1=:ONE";
							params = "ONE==1";
							String ArchivalType="";	
							String codeDecision="";
														
							inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
									
							WriteLog("Query For ArchivalType Input-->"+inputData);		
							outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							WriteLog("Query For ArchivalType Output-->"+outputData);
							WFCustomXmlResponseData=new WFCustomXmlResponse();
							WFCustomXmlResponseData.setXmlString((outputData));
							codeDecision = WFCustomXmlResponseData.getVal("MainCode");
							
							//int recordcountDecision = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
							
							try {  
                                    int recordcountDecision = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
                                 }catch(NumberFormatException ex){  
                                    System.err.println("Invalid string in argumment");  
                                }   
							//recordcountDecision = 1;
							if(codeDecision.equals("0"))
							{	
								objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
									{ 
										ArchivalType = objWorkList.getVal("ArchivalType");
										WriteLog("ArchivalType Is-->"+ArchivalType);
										%>
										<option value='<%=ArchivalType%>'><%=ArchivalType%></option>
										<%
									}
							}	
						%>
						</select>
<input type='hidden' name="wdesk:Archival_Type" id="wdesk:Archival_Type" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Archival_Type")).getAttribValue().toString()%>'/>
</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Processed Date</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
 <input type='text' class="NGReadOnlyView" name="wdesk:Processed_date" id="wdesk:Processed_date" onblur="validateProcessedDate(this.value);" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Processed_date")).getAttribValue().toString()%>'/>
 <img id = 'processed_dateCal' style="cursor:pointer" src='/DA/webtop/images/images/cal.gif' style="float:center;" onclick = "initialize('wdesk:Processed_date');" width='16' height='16' border='0' alt=''>
</td>
</tr>	
<!-- Added for AutoLoan CR_03022018 -->
<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Customer Name</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
<input type='text' class="NGReadOnlyView" maxlength="100" onkeyup="ValidateCharacter('wdesk:CustomerName');" name="wdesk:CustomerName" id="wdesk:CustomerName" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CustomerName")).getAttribValue().toString()%>'/>
</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>CIF Number</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
 <input type='text' class="NGReadOnlyView" maxlength="7" onkeyup="ValidateNumeric('wdesk:CIFNumber');" name="wdesk:CIFNumber" id="wdesk:CIFNumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIFNumber")).getAttribValue().toString()%>'/>
</td>
</tr>

<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>SR Number</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
<input type='text' class="NGReadOnlyView" maxlength="20" onkeyup="ValidateCharacter('wdesk:SRNumber');" name="wdesk:SRNumber" id="wdesk:SRNumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SRNumber")).getAttribValue().toString()%>'/>
</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Description</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
 <textarea name="wdesk:Description" class="NGReadOnlyView" id="wdesk:Description"><%=((CustomWorkdeskAttribute)attributeMap.get("Description")).getAttribValue().toString()%></textarea>
</td>
</tr>
<!-- New fields added by sharan Customer Type & Court Order No & Letter Reference CR on 21-01-2020-->
<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Profile Change WINumber</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
<input type='text' class="NGReadOnlyView" maxlength="20" name="wdesk:ProfileChangeWINumber" id="wdesk:ProfileChangeWINumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ProfileChangeWINumber")).getAttribValue().toString()%>'/>
</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Customer Type</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><select  class="NGReadOnlyView" disabled style='width:62%' name="selectCustomer_Type" id="selectCustomer_Type" onchange="setComboValueToTextBox(this,'wdesk:Customer_Type');enableCIFBasedOnCustomerType(this)">
<option value="--Select--" selected="selected">--Select--</option>
<option value="Customer - Individual">Customer - Individual</option>
<option value="Customer - Business">Customer - Business</option>
<option value="Non Customer">Non Customer</option>
</select>
<input type='hidden' name="wdesk:Customer_Type" id="wdesk:Customer_Type" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Customer_Type")).getAttribValue().toString()%>'/>
</td>
</tr>

<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Court Order No.</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
<input type='text' disabled class="NGReadOnlyView" maxlength="100" onkeyup="ValidateCharacter('wdesk:Court_Order_No');" name="wdesk:Court_Order_No" id="wdesk:Court_Order_No" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Court_Order_No")).getAttribValue().toString()%>'/>
</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Letter Reference</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
<input type='text' disabled class="NGReadOnlyView" maxlength="100" onkeyup="ValidateCharacter('wdesk:Letter_Reference');" name="wdesk:Letter_Reference" id="wdesk:Letter_Reference" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Letter_Reference")).getAttribValue().toString()%>'/>
</td>
</tr>


		<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=left class='EWLabelRB2'><b>Decision</b></td>
		</tr>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Decision</b></td><td><select  class="NGReadOnlyView" style='width:79%' name="selectDecision" id="selectDecision" onchange="setComboValueToTextBox(this,'wdesk:decision')">
						<option value="--Select--">--Select--</option>
							
						<%
							// Added for AutoLoan CR_03022018
							String archivalType=((CustomWorkdeskAttribute)attributeMap.get("Archival_Type")).getAttribValue().toString();
							WriteLog("archivalType-->"+archivalType);
							WriteLog("WSNAME-->"+WSNAME_esapi);
							
							//Modified on 17/04/2019. if condtion modified.
							if(WSNAME_esapi.equals("Archival Document Reject") || WSNAME_esapi.equals("Archival Document Initiation")||WSNAME_esapi.equals("External Credit"))
							{
							Query="select DECISION from USR_0_DA_DECISION_MASTER WHERE WORKSTEP_NAME=:WORKSTEP_NAME AND ARCHIVAL_TYPE LIKE '"+"%"+archivalType+"%"+"'";
								params="WORKSTEP_NAME=="+WSNAME_esapi;
							}
							else
							{
								Query="select DECISION from USR_0_DA_DECISION_MASTER WHERE WORKSTEP_NAME=:WORKSTEP_NAME";
								params="WORKSTEP_NAME=="+WSNAME_esapi;
							}
							String DECISION="";	
							String maincodeDecision="";
							
								inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" +customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";		
									
							WriteLog("Query For Workstep Input-->"+inputData);		
							outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							WriteLog("Query For Workstep Output-->"+outputData);
							WFCustomXmlResponseData=new WFCustomXmlResponse();
							WFCustomXmlResponseData.setXmlString((outputData));
							maincodeDecision = WFCustomXmlResponseData.getVal("MainCode");
							
							//int countDecision = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
							try {  
                                  int countDecision = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
                                 }catch(NumberFormatException ex){  
                                   System.err.println("Invalid string in argumment");  
                                }  
							//countDecision = 1;
							if(maincodeDecision.equals("0"))
							{	
								objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
									{ 
										DECISION = objWorkList.getVal("DECISION");
										WriteLog("DECISION Is-->"+DECISION);
										%>
										<option value='<%=DECISION%>'><%=DECISION%></option>
										<%
									}
							}
							// Added for AutoLoan CR_03022018
							String Description=((CustomWorkdeskAttribute)attributeMap.get("Description")).getAttribValue().toString();
							WriteLog("Description-->"+Description);
						%>
										
		</select><input type='hidden' name="wdesk:decision" id="wdesk:decision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("decision")).getAttribValue().toString()%>' /></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 10%><input name='RejectReason' disabled id="RejectReason" type='button' value='Reject Reason'onclick="openCustomDialog('Reject Reasons','<%=WSNAME_esapi%>');" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
		</tr>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Remarks</b></td><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 10%><textarea maxlength="2000" class='EWNormalGreenGeneral1 NGReadOnlyView'  onkeyup ="ValidateAlphaNumeric('wdesk:remarks','2000');" style="width: 79%; text-align: left;" rows="3" cols="100" id="wdesk:remarks" name="wdesk:remarks" value = "<%=((CustomWorkdeskAttribute)attributeMap.get("remarks")).getAttribValue().toString().trim()%>" ></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input name='history' id="history" type='button' value='Decision History' onclick='HistoryCaller();' class='EWButtonRBSRM' style='width:150px'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
		</tr>
</table>

<!--added by siva to show reject reasons -->
<input type="hidden" id="wdesk:ReceivedDate" name="wdesk:ReceivedDate"/>
<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
</form>

    </body>
</f:view>
</html>
<%
}
%>