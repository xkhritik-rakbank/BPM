<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRB
//Module                     : Request-Initiation 
//File Name					 : InitiatemainFrameset.jsp
//Author                     : Deepti Sharma, Aishwarya Gupta
// Date written (DD/MM/YYYY) : 20-Mar-2014
//Description                : Initial Header fixed form for SRB Module

Updations/Modifications :
1. Card number will not be encrypted again but the masked card number will be picked from the table and displayed.

//---------------------------------------------------------------------------------------------------->
<%@ page import="java.util.Iterator"%>
<%@ include file="../header.process" %>
<%@ include file="../SRB_Specific/Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.util.Properties" %>

<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %><%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>


<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>

<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>



<script language="javascript" src="/SRB/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/SRB/webtop/scripts/jquery.autocomplete.js"></script>
<script src="/SRB/webtop/scripts/jquery.min.js"></script>
<script src="/SRB/webtop/scripts/bootstrap.min.js"></script>
<script src="/SRB/webtop/scripts/jquery-ui.js"></script> 
<script language="javascript" src="/SRB/webtop/scripts/PDFGenerate.js"></script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
if (parameterMap != null && parameterMap.size() > 0) {
	
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();

	String outputXmlFetch = "";
	
	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	
	outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID);
	
	WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
	attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";

	CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
	LinkedHashMap varIdMap = new LinkedHashMap();
	attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	session = request.getSession(false);	

	String isMultipleApprovalReq=((CustomWorkdeskAttribute)attributeMap.get("isMultipleApprovalReq")).getAttribValue().toString()==null?"NULL":((CustomWorkdeskAttribute)attributeMap.get("isMultipleApprovalReq")).getAttribValue().toString();
	
	
%>
<HTML>
<f:view>
<HEAD>
<link rel="stylesheet" href="..\..\webtop\scripts\bootstrap.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\jquery-ui.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\docstyle.css">
<style>
	@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<TITLE> RAKBANK-Service Request Module</TITLE>

<!-- <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script> -->
<script type="text/javascript" language="javascript" src="eida_webcomponents.js"></script>
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
	<script language="javascript">

		window.parent.top.resizeTo(window.screen.availWidth,window.screen.availHeight);
		window.parent.top.moveTo(0,0);
		//added by shamily to all occurences of a string 
		String.prototype.replaceAll1 = function(search, replacement) {
			var target = this;
			return target.replace(new RegExp(search, 'g'), replacement);
		};

	</script>
	<script>
		// below function added to show a tooltip on field
		$(document).ready(function() {
			$("input:text,textarea").wrap("<div class='tooltip-wrapper'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
	</script>
</HEAD>
<script language="javascript" src="/webdesktop/webtop/scripts/SRM_Scripts/aes.js"></script>
<script language="JavaScript" src="/SRB/webtop/scripts/SRB_Scripts/calendar_SRB.js"></script>
<script language="javascript">
	function whichButton(eventname, event) 
	{
		
		if(event.keyCode == 8)
		{
			event.keyCode=10; 
			return (event.keyCode);
		}
		else if(event.keyCode == 90)
		{
			if(event.ctrlKey)
			{
				event.keyCode=10; 
				return (event.keyCode);
			}	
		}
		else if(event.keyCode == 82)
		{
		
			if(event.ctrlKey)
			{
				event.returnValue = false;    
				event.keyCode = 0;
				return (event.keyCode);
			}	
		}
		else if(event.keyCode == 37 || event.keyCode == 39)
		{
			if(event.altKey)
			{
				event.returnValue = false;    
				return (event.keyCode);
			}	
		}		
	}
	//***********************************************************************************//
		function initialize(eleId) {

			var cal1 = new calendarfn(document.getElementById(eleId));
			cal1.year_scroll = true;
			cal1.time_comp = false;
			cal1.popup();
			return true;
		}
	function setAutocompleteData() 
	{
	
		var data = "";
		var ele = document.getElementById("AutocompleteValues");
		if (ele)
		
			data = "SubCategory_search="+ele.value;
			//alert('in autocomplete '+data);
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");
			
			
			$(document).ready(function() {
				$("#SubCategory_search").autocomplete({source: values}); 
			});				
		}
	
	}
	
	function setAutocompleteDataServiceRequest()
	{
		var data = "";
		var ele = document.getElementById("AutocompleteValuesServiceRequest");
		if (ele)
			data = ele.value;			
		if (data != null && data != "") {
			var temp = data.split("=");
			var values = temp[0].split("~");
			$(document).ready(function() {
				var iframe = document.getElementById("frmData");
				var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
				var id=iframeDocument.getElementById("135_ServiceRequestType");
				$(id).autocomplete({source: values});
			});
			
			$(document).ready(function() {
				var iframe = document.getElementById("frmData");
				var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
				var id=iframeDocument.getElementById("136_ServiceRequestType");
				$(id).autocomplete({source: values});
			});
			
		}		
	}
	
	
function eida_read(){
	//alert ("EIDA READ Clicked");
	var result = Initialize();
	if(result==""){
		alert("Error in EIDA Initialize");
	}
	else{
		//alert("Initialize successful "+result);
		var resultData= DisplayPublicData();
		if(resultData==""){
			alert("Error in EIDA DisplayPublicData");
		} else {
			//alert("Data for EIDA DisplayPublicData "+resultData);
		}
	
	
		// Start - Parsing data from Card Read Result
		//EIDA_no:784197452909811@%#EIDA_issue_date:13/12/2016@%#EIDA_exp_date:05/10/2019@%#Title:@%#full_name:Amritha,Kumaran,,,Vellantapoyil@%#nationality:India@%#sex:M@%#DOB:01/09/1974@%#ppt_no:PS-2016121304@%#ppt_expdate:24/09/2021@%#visa_no:2016121304@%#visa_issue_date:13/12/2016@%#visa_exp_date:05/10/2019@%#mothers_name:Jameelah@%#mobile_no:@%#PlaceOfBirth:Delhi@%#Occupation:Health and social work@%#CompanyName:Noor Hospital@%#MaritalStatus:01@%#PassportCountryDescription:India@%#HomeAddressCityDescription:Jebel Ali@%#HomeAddressStreet:Shaikh Zayed Street@%#HomeAddressPOBox:-@%#HomeAddressBuildingName:Marjan Plaza@%#HomeAddressFlatNo:1112@%#HomeAddressMobilePhoneNumber:@%#HomeAddressEmail:@%#encry_data:PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PElEX1ZHX1Jlc3BvbnNlPjxSZXN1bHQ+PFN1YmplY3RETj5DTj0iVmVsbGFudGFwb3lpbCBBbXJpdGhhIEt1bWFyYW4gIiwgU0VSSUFMTlVNQkVSPTc4NDE5NzQ1MjkwOTgxMS8wMDAwMTM2NDAsIEM9SU48L1N1YmplY3RETj48VXNlcklETj43ODQxOTc0NTI5MDk4MTE8L1VzZXJJRE4+PENhcmROdW1iZXI+MDAwMDEzNjQwPC9DYXJkTnVtYmVyPjxUcmFuc2FjdGlvblR5cGU+Q2FyZFN0YXR1czwvVHJhbnNhY3Rpb25UeXBlPjxTdGF0dXM+U3VjY2VzczwvU3RhdHVzPjwvUmVzdWx0PjxWYWxpZGl0eT4xODA8L1ZhbGlkaXR5PjxTaWduYXR1cmVUaW1lPjxkYXRlPjIwMTcxMjI3PC9kYXRlPjx0aW1lPjEzOjQ3OjM5OjQzMzwvdGltZT48L1NpZ25hdHVyZVRpbWU+PFNpZ25hdHVyZSB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFNpZ25lZEluZm8+PENhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy9UUi8yMDAxL1JFQy14bWwtYzE0bi0yMDAxMDMxNSNXaXRoQ29tbWVudHMiLz48U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxkc2lnLW1vcmUjcnNhLXNoYTI1NiIvPjxSZWZlcmVuY2UgVVJJPSIiPjxUcmFuc2Zvcm1zPjxUcmFuc2Zvcm0gQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjZW52ZWxvcGVkLXNpZ25hdHVyZSIvPjwvVHJhbnNmb3Jtcz48RGlnZXN0TWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS8wNC94bWxlbmMjc2hhMjU2Ii8+PERpZ2VzdFZhbHVlPjVBczZ4eGgwcEcwNTk5SXZ4T2RSTVAzVmpYOVczL2RIRGl0ZTFTdzdmZG89PC9EaWdlc3RWYWx1ZT48L1JlZmVyZW5jZT48L1NpZ25lZEluZm8+PFNpZ25hdHVyZVZhbHVlPlNGaXc5MHV6YWg0L2NRY1oyUjhkbmFMRncrVTZ0alM4cUFkWTJzNkJhaWJJZ2lydGltZkVlT0htdzdPemVRSmxZQm5hZEpvTkhzVDYNCmN4QlI0U3RoM0FtTGhOSzFnMm5HdXlqNDJXTmc2SHVySTZ1MU5IZUJLVWFIOW5HVlVOam9xNllZR0lGNmNFSzF0VkwyOWxXS0tscnQNCmZUb05qb1lhS1p3WUR2cmVURjFwUTFwam5YQ05MYVZZcmF4VzN2VmZkYnV1SEdFUnVhQ0FULzlXVVkyVUxKVHBoM1FONzdtUWl5MjkNCnVIUWpINFYwN2lEY3Y3aXRwSGpLMnNhUm5zT2JvcFRnWStFUU5NZnZ4MUtOUGprVnRhWDhyb1lEaWxLbEwrNGF3a0M4d2Y4Sis3QmYNCkZtSWdIaHQxYjZmbUM0ZHRpZ242eE91TVJnNmdIUVg0c21kK0JBPT08L1NpZ25hdHVyZVZhbHVlPjxLZXlJbmZvPjxYNTA5RGF0YT48WDUwOUNlcnRpZmljYXRlPk1JSURLakNDQXBPZ0F3SUJBZ0lRQy9ZMStzTXRYRFBzUDFRV3B5TE56REFOQmdrcWhraUc5dzBCQVFzRkFEQm1NUnd3R2dZRFZRUUQNCkRCTkZiV2x5WVhSbGN5QkpSQ0JUWlhKMlpYSnpNUTR3REFZRFZRUUxEQVZRVWtsRVF6RWRNQnNHQTFVRUNnd1VUV2x1YVhOMGNua2cNCmIyWWdTVzUwWlhKcGIzSXhDekFKQmdOVkJBWVRBa0ZGTVFvd0NBWURWUVFFREFFMU1CNFhEVEUzTURReU16RXhORFExTWxvWERUSXcNCk1EUXlNekV4TkRRMU1sb3dhREVqTUNFR0ExVUVBd3dhVm1Gc2FXUmhkR2x2YmlCSFlYUmxkMkY1SUZObGNuWnBZMlV4RGpBTUJnTlYNCkJBc01CVkJTU1VSRE1TUXdJZ1lEVlFRS0RCdEZiV2x5WVhSbGN5QkpaR1Z1ZEdsMGVTQkJkWFJvYjNKcGRIa3hDekFKQmdOVkJBWVQNCkFrRkZNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXgwczdsYzRxMnY5WDVRZmw4MjgwTWZWc09NSy8NCjU0aWxRR0YxaHM5VTNlVEg2bmlTQzZaYW5DWlJZSnRxaVVlVFd5NGR1ZXpoWFljUCtka2ZoTlh4d0h0amhqZStONC9nZHVWSk5sbFMNCjBIVXM4c3Y2cmZxOFJnVnhpVlZweFlmVy9ucENlWlBickQwRys2WlVRbFlMQXV0THdURjlTdlBaN0FlV2psMTZzczJWeHJlUVFlS0gNCjRUUmY0RVdRSTVGdVZtcWxGaXo1U0JRa0RXWXFsVlQyU2Jmampvdi85SGMzenZPcVZzaHdLUkhiS1FuRHdaN1dvWkMxMzRGbWJCRHINCjZ4M1JjVDM1K2EvMkpmZGZiWWNmN2lQc0V5dTR2eDBNNjhiU3dwV1kyNGVocVkvcFJTVXJVOGtGSEFJY3VIRlJZYkp6cGxGRXB4VnQNCnVvUUdwc0Zaa3dJREFRQUJvMU13VVRBTEJnTlZIUThFQkFNQ0JzQXdIZ1lEVlIwT0FRSC9CQlFFRW5SbGJYQnZjbUZ5ZVZCMVlteHANClkwdGxlVEFpQmdOVkhTTUJBZjhFR0RBV2dCUjh2ay8vNnIrREpKMGswVDJNSWFIeW5zYjBnekFOQmdrcWhraUc5dzBCQVFzRkFBT0INCmdRQ1dBejRSWWRSbHZ3bTB5a0QwZTlGUVhXYjE0QnVsTlhYeEsxUFNVYzVZSWpWQUZCUWI0cXhzRVZZSVNaMFRhWXVib1F4WEYwUkQNCktFTWpma1l6K0JuMkF6OXRkV3lLT3laOUYyU25FVDlvK2VsR0NCdU5tK1kvVTZoZUZPZXRTdW5GZEdRQjRUSjVtMzVTR1BQQzRINUQNCnpGSFJhUkJpczM4SGJiQ3FYYVdCWXc9PTwvWDUwOUNlcnRpZmljYXRlPjwvWDUwOURhdGE+PC9LZXlJbmZvPjwvU2lnbmF0dXJlPjwvSURfVkdfUmVzcG9uc2U+@%#cust_photo:FF D8 FF E0 00 10 4A 46 49 46 00 01 01 01 00 48 00 48 00 00 FF DB 00 43 00 14 0E 0F 12 0F 0D 14 12 11 12 17 16 14 18 1F 33 21 1F 1C 1C 1F 3F 2D 2F 25 33 4A 41 4E 4D 49 41 48 46 52 5C 76 64 52 57 6F 58 46 48 66 8C 68 6F 7A 7D 84 85 84 4F 63 91 9B 8F 80 9A 76 81 84 7F FF DB 00 43 01 16 17 17 1F 1B 1F 3C 21 21 3C 7F 54 48 54 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F 7F FF C0 00 11 08 00 9A 00 82 03 01 22 00 02 11 01 03 11 01 FF C4 00 19 00 01 01 01 01 01 01 00 00 00 00 00 00 00 00 00 00 00 01 03 04 02 05 FF C4 00 25 10 01 01 00 02 01 05 00 02 02 03 01 00 00 00 00 00 00 01 02 11 03 04 12 21 31 41 13 51 22 61 32 33 42 91 FF C4 00 19 01 01 01 01 01 01 01 00 00 00 00 00 00 00 00 00 00 00 01 02 04 03 05 FF C4 00 1E 11 01 01 01 01 00 02 03 01 01 00 00 00 00 00 00 00 00 01 02 11 03 21 04 12 31 13 41 FF DA 00 0C 03 01 00 02 11 03 11 00 3F 00 D8 51 5C 60 00 00 00 A8 80 A8 A0 00 A0 00 00 00 1B FE 80 48 00 00 00 A8 A0 22 A0 28 8A 08 45 00 00 00 00 00 1E 55 14 00 00 50 01 05 04 54 50 00 00 00 00 00 40 11 50 05 11 40 00 00 00 54 01 44 01 40 00 40 17 FF 00 04 01 04 50 00 00 00 15 00 15 14 00 50 10 05 01 04 51 00 48 96 E9 59 E7 7C A2 BD F7 2C F2 C3 6D 30 C8 E8 D0 05 44 93 2C AE B1 8F 57 87 96 4D DC 5D 1D 3C 92 46 FA DC DB 1D AE DC FC 69 CF 6F 9D 1E 9E FA 8C 3B 72 EE 9E AB 36 A5 EB 97 79 B9 BC AA F5 86 3D F9 48 F0 F7 C5 75 99 5A F1 66 6B 52 57 4C E9 B0 D7 DD B1 E6 E1 EC F3 3C C7 66 17 BA 32 E4 9B 9A 67 BC 76 6F C3 9B 3D 47 10 F5 67 6D D3 CB 6F 9F 67 3D 00 08 8C B9 27 96 B1 E7 39 B8 95 58 AE 37 55 2F 8A 20 DF 1B B8 F4 C7 8E B6 51 A7 06 7A BA FD 3B 26 7E 35 5F 3A 5E CC B7 F1 D9 85 EE 8C FE 3E 97 8B 7F 6C CA B9 E3 32 96 7E DC 53 C7 8B F1 DB E6 D7 2F 34 D6 7B 84 79 7C 9C 76 76 3C 92 EB 29 50 BE B4 D5 72 63 5F 5D 4A EC E3 CB D5 95 EF 2B BB B6 1D 3E 5B C7 CB 7B 18 7D 4E CA E6 E7 9F 58 BA 79 B5 71 73 B5 97 07 C8 CF 35 D0 06 9E 0F 2B 52 28 31 CE 6A BC B5 E4 9B 8C 59 A2 CB E5 BE 19 6E 39 DA 61 74 41 AD 9B 8D 7A 7E 4D CD 7D 65 EE 2F 05 EC E6 D7 EC D3 DF C1 AE 5E 3B E7 1D BE FD 3C F2 F1 63 96 16 36 C7 2D C7 9A CB B2 FB FD 7C EB 35 6C BE E2 36 EA 31 ED CF BA 7A AC 5B 9E E3 E7 EF 3F 5D 71 EB 8B 7F 93 52 FB 76 E1 84 B3 CD DD 70 E3 75 9C 77 61 76 CD FD 76 78 6F 71 16 E1 24 F4 E2 E5 C7 B7 3A EF BE 63 9B A8 C3 C6 D2 5E 54 F3 67 ED 97 38 68 7A 38 1E 60 8A 29 7C C6 19 4D 56 EC F9 22 51 9A CB A4 10 6F 85 DC 32 FE 36 65 FA 65 8E 5A 6B 6E F1 5F D8 B9 BC BD 7D 0E 1E 4E EC 25 FE 9E F7 B7 CF E9 FA 89 C7 85 99 DF 11 B7 0F 2E 7C FE 67 F1 C7 E3 CD F4 73 7B 1A 73 E3 2E 2E 47 77 67 7F F1 B5 CF CF C1 F8 FD 7A 59 5E 1E 6C 76 76 39 F3 BA C7 7F A7 6F 0E 53 2C 7D B8 EC DC D3 6E 93 19 64 F2 BA 3E 3D F5 63 AF BA 32 E5 CB 78 D9 26 DD 13 0C 74 B7 0C 64 F1 19 74 5F 6F 9B AA 3A EF 1C DD 1A FB 39 7F 83 82 09 8F D2 B6 E6 2E 4F 39 5D A6 5E 9E 50 40 10 1E BB 9E 7E C3 E0 30 EA B7 AD F9 D5 F6 FA 9D 26 73 B2 69 F3 B9 FF 00 D7 93 A3 A1 B7 F1 E3 E5 8F F5 DB F1 F5 D8 FA D3 59 3C 72 CC EE 36 78 BB 4E 36 D5 6B A2 C8 F9 B7 8B 39 7F C5 7A 7C AF 16 57 BA 6A 5B F5 DB 7E B0 CF D4 66 EA BC 73 E3 99 BD 8D F1 E6 C6 FF 00 D4 7B EE 97 EB 9F 09 35 7C 3D 5F 47 5B EB 5F 1F B1 88 BD 4E BF FF D9//  sample data from Card Reader
		var  EIDA_no,EIDA_issue_date,EIDA_exp_date,full_name,nationality,sex,DOB,ppt_no,ppt_expdate,visa_no,visa_issue_date,visa_exp_date,mothers_name,mobile_no,PlaceOfBirth,Occupation,CompanyName,MaritalStatus,PassportCountryDescription,HomeAddressCityDescription,HomeAddressStreet,HomeAddressPOBox,HomeAddressBuildingName,HomeAddressFlatNo,HomeAddressMobilePhoneNumber,HomeAddressEmail,encry_data,cust_photo;
		resultData = resultData.split(":").join("~"); // replacing the characters
		//alert("resultData split: "+resultData)
		var resultDataSplitted = resultData.split("@%#");
		
		for(var i=0;i<resultDataSplitted.length;i++)
		{
			var innerData = resultDataSplitted[i].split("~");
			//alert ("innerData[0]: "+innerData[0]+" , innerData[1]: "+innerData[1]);
			if (innerData[0] == "EIDA_no")
					EIDA_no = innerData[1];
			else if (innerData[0] == "EIDA_issue_date")
					EIDA_issue_date = innerData[1];
			else if (innerData[0] == "EIDA_exp_date")
					EIDA_exp_date = innerData[1];
			else if (innerData[0] == "full_name")
					full_name = innerData[1];
			else if (innerData[0] == "nationality")
					nationality = innerData[1];
			else if (innerData[0] == "sex")
			{
				if (innerData[1] == "M")
					sex = "Male";
				if (innerData[1] == "F")
					sex = "Female";
			}
			else if (innerData[0] == "DOB")
					DOB = innerData[1];
			else if (innerData[0] == "ppt_no")
					ppt_no = innerData[1];
			else if (innerData[0] == "ppt_expdate")
					ppt_expdate = innerData[1];
			else if (innerData[0] == "visa_no")
					visa_no = innerData[1];
			else if (innerData[0] == "visa_issue_date")
					visa_issue_date = innerData[1];
			else if (innerData[0] == "visa_exp_date")
					visa_exp_date = innerData[1];
			else if (innerData[0] == "mothers_name")
					mothers_name = innerData[1];
			else if (innerData[0] == "mobile_no")
					mobile_no = innerData[1];
			else if (innerData[0] == "PlaceOfBirth")
					PlaceOfBirth = innerData[1];
			else if (innerData[0] == "Occupation")
					Occupation = innerData[1];
			else if (innerData[0] == "CompanyName")
					CompanyName = innerData[1];
			else if (innerData[0] == "MaritalStatus")
					MaritalStatus = innerData[1];
			else if (innerData[0] == "PassportCountryDescription")
					PassportCountryDescription = innerData[1];
			else if (innerData[0] == "HomeAddressCityDescription")
					HomeAddressCityDescription = innerData[1];
			else if (innerData[0] == "HomeAddressStreet")
					HomeAddressStreet = innerData[1];
			else if (innerData[0] == "HomeAddressPOBox")
					HomeAddressPOBox = innerData[1];
			else if (innerData[0] == "HomeAddressBuildingName")
					HomeAddressBuildingName = innerData[1];
			else if (innerData[0] == "HomeAddressFlatNo")
					HomeAddressFlatNo = innerData[1];
			else if (innerData[0] == "HomeAddressMobilePhoneNumber")
					HomeAddressMobilePhoneNumber = innerData[1];
			else if (innerData[0] == "HomeAddressEmail")
					HomeAddressEmail = innerData[1];
			/*else if (innerData[0] == "encry_data")
					encry_data = innerData[1];*/
			else if (innerData[0] == "cust_photo")
					cust_photo = innerData[1];
		}  
		// End - Parsing data from Card Read Result
	
		if (true)
		{
			document.getElementById("EmiratesID").value = EIDA_no;
			document.getElementById("EmiratesIDHidden").value = EIDA_no;
			document.getElementById("EmiratesIDHolderNameHidden").value = full_name;
			document.getElementById("EmiratesIDExpDateHidden").value = EIDA_exp_date;
			//document.getElementById("EmiratesIDExpDateHidden").value = nationality;
			
			// below function called to generate EMID Document as PDF
			generateEMIDAsPDF(cust_photo,EIDA_no,DOB,sex,full_name,EIDA_exp_date,nationality,'<%=WINAME%>')
			
		}
	}
}	
	//added by Sowmya
		function checkRemarks()
		{
			var value=document.getElementById("remarks").value;
			value=value.replace(/(\r\n|\n|\r)/gm," ");
			value=value.replace(/[^a-zA-Z0-9_.,&:;!@#$%*()={}\/\-\\" ]/g,"");
			document.getElementById("remarks").value=value;
			
		}
	
	function checkValueForModOfDelivery()
	{
		var strMod = document.getElementById("modeofdelivery");
		var strSelectedValue =  strMod.options[strMod.selectedIndex].value;
		
		if(strSelectedValue == 'Branch')
		{
			document.getElementById("branchDeliveryMethod").disabled=false;
			document.getElementById("doccollectionbranch").disabled=false;
			document.getElementById("wdesk:BranchAWBNumber").disabled=false;
			document.getElementById("wdesk:CourierAWBNumber").disabled=true;
			document.getElementById("wdesk:CourierCompName").disabled=true;
			document.getElementById("wdesk:AuthorizedPersonName").disabled=true;
			document.getElementById("wdesk:AuthorizedPersonMobNumber").disabled=true;
			document.getElementById("wdesk:AuthorizedPersonEmid").disabled=true;
		}
		if(strSelectedValue =='Courier' || strSelectedValue =='Courier Self' || strSelectedValue =='Courier Authorised Person' || strSelectedValue =='Courier to Office Address')
		{
			document.getElementById("wdesk:CourierAWBNumber").disabled=false;
			document.getElementById("wdesk:CourierCompName").disabled=false;
			document.getElementById("branchDeliveryMethod").disabled=true;
			document.getElementById("doccollectionbranch").disabled=true;
			document.getElementById("wdesk:BranchAWBNumber").disabled=true;
			document.getElementById("wdesk:AuthorizedPersonName").disabled=true;
			document.getElementById("wdesk:AuthorizedPersonMobNumber").disabled=true;
			document.getElementById("wdesk:AuthorizedPersonEmid").disabled=true;
			if(strSelectedValue =='Courier Authorised Person')
			{
				document.getElementById("wdesk:AuthorizedPersonName").disabled=false;
				document.getElementById("wdesk:AuthorizedPersonMobNumber").disabled=false;
				document.getElementById("wdesk:AuthorizedPersonEmid").disabled=false;
			}
		}
	}
	
	function validatesubcat(req,subcatvalidate)
	{
		subcatvalidate = subcatvalidate.replaceAll1(", ", ",");
		subcatvalidate=subcatvalidate.split(",");
		var match ='';
		document.getElementById(req).value = myTrim(document.getElementById(req).value);
		for(var i=0;i<=subcatvalidate.length;i++)
		{
				if(document.getElementById(req).value==subcatvalidate[i])
				match='matched';
			
		}
		if(match !='matched')
		{
			document.getElementById(req).value="";
			return false;
		}
		
	}
	function setcategory(subcat,values1)
	{
		//var subcat = document.getElementById("SubCategory_search").value;
		
		var temp1 = values1.split("~");
		for(var i = 0;i < temp1.length;i++)
		{
			if(temp1[i].indexOf(subcat)!=-1)
			{
				document.getElementById("Category").value = temp1[i].substring(0,temp1[i].indexOf('#'));	
				var Category123 = document.getElementById("Category").value;
				
			}	
		}
		if(subcat=="" || subcat==null)
		document.getElementById("Category").value = '--Select--';
		 Category123 =document.getElementById("Category").value;
	}
	function setFrameSize()
	{
		var widthToSet = document.getElementById("DeferralDetails").offsetWidth;
		var controlName="TAB_SRB,SRB_Header,Req_details,CIF_Search,SRBSearch,frmData,accountdet11,divCheckbox,dispatchHeader,DeferralDetails,waiverdetails,dispatchDtl,decisiondetails";
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
	//**********************************************************************************//
	function ValidateNumericMain(id,labelName)
	{
		var inputtxt=document.getElementById(id);
		
		if(inputtxt.value=='')
		return;
		var inputtxt=document.getElementById(id);
		var numbers = /^[0-9]+$/; 
		if(inputtxt.value.match(numbers)) 
		return true; 
		else 
		{ 
			alert('Please input numeric characters only in '+labelName+".");
			document.getElementById(id).value="";
			document.getElementById(id).focus();
			return false; 
		}
	}
	
	function ValidateMobileNumber(id,labelName)
	{
		var inputtxt=document.getElementById(id);
		
		if(inputtxt.value=='')
		return;
		var inputtxt=document.getElementById(id);
		var numbers = /^[0-9 +]+$/; 
		if(inputtxt.value.match(numbers)) 
		return true; 
		else 
		{ 
			alert('Please input numeric characters only in '+labelName+".");
			document.getElementById(id).value="";
			document.getElementById(id).focus();
			return false; 
		}
	}
	
	function ValidateAlphaNumeric(id,labelName)
	{
		var array=labelName.split("#");
		var labelName=array[0];
		var minLength=array[1];
		var inputtxt=document.getElementById(id);
		
		if(inputtxt.value=='')
		return;
		var inputtxt=document.getElementById(id);
		//var numbers = "^[a-zA-Z0-9]*$";
		if(inputtxt.value.match("^[a-zA-Z0-9]*$"))
		return true;	 
		else 
		{ 
			alert('Please input alphanumeric only in '+labelName+".");
			document.getElementById(id).value="";
			document.getElementById(id).focus();
			return false; 
		}
	}
	function ValidateCharacterMain(id,labelName)
	{
		var inputtxt=document.getElementById(id);
		
		if(inputtxt.value=='')
		return;
		var inputtxt=document.getElementById(id);
		var characters = /^[a-zA-Z ]*$/; 
		if(inputtxt.value.match(characters)) 
		return true; 
		else 
		{ 
			alert('Please input characters only in '+labelName+".");
			document.getElementById(id).value="";
			document.getElementById(id).focus();
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
					document.getElementById('rejReasonCodes').value = popupWindow;
				}
	   }
	}
	//ends here.

	//added by shamily to show reject reasons 
	function openCustomDialog(dialogToOpen, workstepName) 
	{
		dialogToOpenType = dialogToOpen;
		if (dialogToOpen == 'Reject Reasons') {

				//var WSNAME = '<%=WSNAME%>';
				if(workstepName=='Print and Dispatch') //to handle &
				workstepName = 'Print Dispatch';
				var WSNAME =  workstepName;
				var wi_name = '<%=WINAME%>';
				//var rejectReasons = document.getElementById('wdesk:remarks1').value;
				var rejectReasons = document.getElementById('rejReasonCodes').value;
				//var rejectReasonopsmaker = document.getElementById('wdesk:rejectreasonsops').value;
				//document.getElementById("wdesk:rejectreasonsops").value = document.getElementById("RejectReasonsList").value  
			
				sOptions = 'dialogWidth:500px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
				
				//popupWindow = window.showModalDialog('/SRB/CustomForms/SRB_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
				
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
				/***********************************************************/
				var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
				if (window.showModalDialog) {
					popupWindow = window.showModalDialog('/SRB/CustomForms/SRB_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
				} else {
					popupWindow = window.open('/SRB/CustomForms/SRB_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null,windowParams);
				}
				/************************************************************/
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
				
				//Set the response code to the input with id = rejReasonCodes
				//alert("popupWindow "+popupWindow);
				if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
					document.getElementById('rejReasonCodes').value = popupWindow;				
			}
			
		if (dialogToOpen == 'Print Report') {

				//var WSNAME = '<%=WSNAME%>';
				if(workstepName=='Print and Dispatch') //to handle &
				workstepName = 'Print Dispatch';
				var WSNAME =  workstepName;
				var wi_name = '<%=WINAME%>';
				var solid = '<%=((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()%>';
				var username = '<%=customSession.getUserName()%>';
				var loggedinuser = document.getElementById('loggedinuser').value;
				var Workstep = document.getElementById('Workstep').value;
				var CifId = document.getElementById('wdesk:CifId').value;
				var Name = document.getElementById('wdesk:Name').value;
				var SubSegment = document.getElementById('wdesk:SubSegment').value;
				var ARMCode = document.getElementById('wdesk:ARMCode').value;
				var RAKElite = document.getElementById('wdesk:RAKElite').value;
				var Channel = document.getElementById('Channel').value;
				var EmiratesIDHeader = document.getElementById('wdesk:EmiratesIDHeader').value;
				var EmratesIDExpDate = document.getElementById('wdesk:EmratesIDExpDate').value;
				var TLIDHeader = document.getElementById('wdesk:TLIDHeader').value;
				var TLIDExpDate = document.getElementById('wdesk:TLIDExpDate').value;
				var PrimaryEmailId = document.getElementById('wdesk:PrimaryEmailId').value;
				var ApplicationDate = document.getElementById('wdesk:ApplicationDate').value;
				var Category = document.getElementById('wdesk:Category').value;
				var subCategoryCode = document.getElementById('wdesk:ServiceRequestCode').value;
				var cat_Subcat = document.getElementById('wdesk:SubCategory').value;
				var TEMPWINAME=document.getElementById('wdesk:Temp_WI_NAME').value;
				var frmData = document.getElementById("frmData").value;
				var workstepcode= document.getElementById('wdesk:WS_NAME').value;
				var modeofdelivery = document.getElementById('modeofdelivery').value;
				var doccollectionbranch = document.getElementById('doccollectionbranch').value;
				var branchDeliveryMethod = document.getElementById('branchDeliveryMethod').value;
				var CourierAWBNumber = document.getElementById('wdesk:CourierAWBNumber').value;
				var CourierCompName = document.getElementById('wdesk:CourierCompName').value;
				var Decision = document.getElementById('wdesk:Decision').value;
				
				if (workstepcode == 'CSO')
				{
				workstepcode= 'Introduction';
				}
				//alert("workstepcode : "+workstepcode);
				//var rejectReasons = document.getElementById('rejReasonCodes').value;
				//var rejectReasons = document.getElementById('rejReasonCodes').value;
				
			
				sOptions = 'dialogWidth:1000px; dialogHeight:500px; dialogLeft:200px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
				
				//popupWindow = window.showModalDialog('/SRB/CustomForms/SRB_Specific/PrintReport.jsp?workstepName=' +WSNAME+ "&wi_name=" +wi_name+ "&SOLID=" +solid+  "&USERNAME=" +username+ "&CifIdnumber=" +CifId+ "&Name=" +Name+ "&SubSegment=" +SubSegment+ "&ARMCode=" +ARMCode+ "&RAKElite=" +RAKElite+ "&Channel=" +Channel+ "&EmiratesIDHeader=" +EmiratesIDHeader+ "&TLIDHeader=" +TLIDHeader+ "&TLIDExpDate=" +TLIDExpDate+ "&PrimaryEmailId=" +PrimaryEmailId+ "&ApplicationDate=" +ApplicationDate+ "&CATEGORY=" +Category+ "&Subcat=" +cat_Subcat+ "&TEMPWINAME=" +TEMPWINAME+ "&frmData=" +frmData+ "&subCategoryCode=" +subCategoryCode+ "&workstepcode=" +workstepcode+ "&modeofdelivery=" +modeofdelivery+ "&doccollectionbranch=" +doccollectionbranch+ "&branchDeliveryMethod=" +branchDeliveryMethod+ "&CourierAWBNumber=" +CourierAWBNumber+ "&CourierCompName=" +CourierCompName+ "&Decision=" +Decision, null, sOptions);
				
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
				/***********************************************************/
				var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
				if (window.showModalDialog) {
					popupWindow = window.showModalDialog('/SRB/CustomForms/SRB_Specific/PrintReport.jsp?workstepName=' +WSNAME+ "&wi_name=" +wi_name+ "&SOLID=" +solid+  "&USERNAME=" +username+ "&CifIdnumber=" +CifId+ "&Name=" +Name+ "&SubSegment=" +SubSegment+ "&ARMCode=" +ARMCode+ "&RAKElite=" +RAKElite+ "&Channel=" +Channel+ "&EmiratesIDHeader=" +EmiratesIDHeader+ "&TLIDHeader=" +TLIDHeader+ "&TLIDExpDate=" +TLIDExpDate+ "&PrimaryEmailId=" +PrimaryEmailId+ "&ApplicationDate=" +ApplicationDate+ "&CATEGORY=" +Category+ "&Subcat=" +cat_Subcat+ "&TEMPWINAME=" +TEMPWINAME+ "&frmData=" +frmData+ "&subCategoryCode=" +subCategoryCode+ "&workstepcode=" +workstepcode+ "&modeofdelivery=" +modeofdelivery+ "&doccollectionbranch=" +doccollectionbranch+ "&branchDeliveryMethod=" +branchDeliveryMethod+ "&CourierAWBNumber=" +CourierAWBNumber+ "&CourierCompName=" +CourierCompName+ "&Decision=" +Decision, null, sOptions);
				} else {
					popupWindow = window.open('/SRB/CustomForms/SRB_Specific/PrintReport.jsp?workstepName=' +WSNAME+ "&wi_name=" +wi_name+ "&SOLID=" +solid+  "&USERNAME=" +username+ "&CifIdnumber=" +CifId+ "&Name=" +Name+ "&SubSegment=" +SubSegment+ "&ARMCode=" +ARMCode+ "&RAKElite=" +RAKElite+ "&Channel=" +Channel+ "&EmiratesIDHeader=" +EmiratesIDHeader+ "&TLIDHeader=" +TLIDHeader+ "&TLIDExpDate=" +TLIDExpDate+ "&PrimaryEmailId=" +PrimaryEmailId+ "&ApplicationDate=" +ApplicationDate+ "&CATEGORY=" +Category+ "&Subcat=" +cat_Subcat+ "&TEMPWINAME=" +TEMPWINAME+ "&frmData=" +frmData+ "&subCategoryCode=" +subCategoryCode+ "&workstepcode=" +workstepcode+ "&modeofdelivery=" +modeofdelivery+ "&doccollectionbranch=" +doccollectionbranch+ "&branchDeliveryMethod=" +branchDeliveryMethod+ "&CourierAWBNumber=" +CourierAWBNumber+ "&CourierCompName=" +CourierCompName+ "&Decision=" +Decision, null,windowParams);
				}
				/************************************************************/
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
				
				
				//var url = "../SRB_Specific/PrintReport.jsp?workstepName=" +WSNAME+ "&wi_name=" +wi_name+ "&SOLID=" +solid+  "&USERNAME=" +username+ "&CifIdnumber=" +CifId+ "&Name=" +Name+ "&SubSegment=" +SubSegment+ "&ARMCode=" +ARMCode+ "&RAKElite=" +RAKElite+ "&Channel=" +Channel+ "&EmiratesIDHeader=" +EmiratesIDHeader+ "&TLIDHeader=" +TLIDHeader+ "&TLIDExpDate=" +TLIDExpDate+ "&PrimaryEmailId=" +PrimaryEmailId+ "&ApplicationDate=" +ApplicationDate+ "&CATEGORY=" +Category+ "&Subcat=" +cat_Subcat;
				
				//alert("url : "+url);
				//popupWindow = window.open(url, null , sOptions);	
					
				
				
				
				
		}	
		
	}
	function setComboValueToTextBox(dropdown, inputTextBoxId) 
	{
			var WSNAME = '<%=WSNAME%>';
			document.getElementById(inputTextBoxId).value = dropdown.value;
			if(WSNAME=='Introduction')
			{
				if(inputTextBoxId=='wdesk:WaiverHeld')
				{
					if(document.getElementById(inputTextBoxId).value=='Y')
					{
					document.getElementById("wdesk:DocumentTypeWaivered").disabled=false;
					document.getElementById("wdesk:ApprovingAuthorityWaiver").disabled=false;
					}
					else
					{
					document.getElementById("wdesk:ApprovingAuthorityWaiver").disabled=true;
					document.getElementById("wdesk:ApprovingAuthorityWaiver").value='';
					document.getElementById("wdesk:DocumentTypeWaivered").disabled=true;
					document.getElementById("wdesk:DocumentTypeWaivered").value='';
					}
				}
				if(inputTextBoxId=='wdesk:DeferralWaiverHeld')
				{
					if(document.getElementById(inputTextBoxId).value=='Y')
					{
					document.getElementById("wdesk:ApprovingAuthority").disabled=false;
					document.getElementById("wdesk:DocumentTypedeferred").disabled=false;
					document.getElementById("wdesk:DeferralExpiryDate").disabled=false;
					document.getElementById("DeferralExpiryDateCalImg").disabled=false;
					}
					else
					{
					document.getElementById("wdesk:ApprovingAuthority").disabled=true;
					document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
					document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
					document.getElementById("DeferralExpiryDateCalImg").disabled=true;
					document.getElementById("wdesk:ApprovingAuthority").value='';
					document.getElementById("wdesk:DocumentTypedeferred").value='';
					document.getElementById("wdesk:DeferralExpiryDate").value='';
					}
				}
			}
			
			//document.getElementById("wdesk:PreviousRejectedBy").value ='';
			if(WSNAME=='Q11')//Q11=Card Settlement Maker
			{
				document.getElementById("wdesk:CardSettlementMakerDecision").value = dropdown.value;//Hidden field Added by siva for the newly added ws for 21 service request
					if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Card Settlement Maker';
					else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			if(WSNAME=='Q12')//Q12=Card Settlement Checker
			{
				//Added by siva for 21 service request start
				if(document.getElementById("selectDecision").value=='Approve')
				{
					if(document.getElementById("wdesk:CardSettlementMakerDecision").value=='Reject to CSO')
					{
						alert("Decision 'Approve' is not allowed if Card Settlement Maker Decision was Reject to CSO");
						document.getElementById("selectDecision").value='--Select--';
						document.getElementById("selectDecision").focus();
					}
				}
				//Added by siva for 21 service request end
				
				if(document.getElementById("selectDecision").value=='Reject to Card Settlement Maker' || document.getElementById("selectDecision").value=='Reject to CSO')
				document.getElementById("wdesk:PreviousRejectedBy").value ='Card Settlement checker';
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			if(WSNAME=='Q1')//Q1=CSM Approval
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
				document.getElementById("wdesk:PreviousRejectedBy").value ='CSM';
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			if(WSNAME=='Q2')//Q2=OSP Maker
			{
				document.getElementById("wdesk:OPSMakerDecision").value = dropdown.value;
				if(document.getElementById("selectDecision").value=='Reject to CSO' || document.getElementById("selectDecision").value=='Reject to Card Settlement')
				{
				 document.getElementById("wdesk:PreviousRejectedBy").value ='OPS Maker';
				}
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';	
			}
			if(WSNAME=='Q7')//Q7=Archival Queue
			{
				//alert("WSNAME "+WSNAME+" "+document.getElementById("selectDecision").value);
				document.getElementById("wdesk:ArchivalDecision").value = dropdown.value;
				if(document.getElementById("selectDecision").value=='Reject to CSO')
				{
				 //alert("inside");
				 document.getElementById("wdesk:PreviousRejectedBy").value ='Archival';
				}
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			if(WSNAME=='Q3')//Q3=Cso Reject
			{
				if(document.getElementById("wdesk:ArchivalDecision").value=='Reject to CSO')
				{
					if(document.getElementById("selectDecision").value!='Rectification Provided')
					{
						alert("Only Rectification Provided decision is allowd if CSO Reject Decision was Reject to CSO");
						document.getElementById("selectDecision").value='--Select--';
						document.getElementById("selectDecision").focus();
					}
				}
				document.getElementById("wdesk:ArchivalDecision").value = dropdown.value;
			}
			if(WSNAME=='Q4')//Q4==OPS Checker
			{
			
				if(document.getElementById("selectDecision").value=='Approve - Sign Verified' || document.getElementById("selectDecision").value=='Approve')
				{
					if(document.getElementById("wdesk:OPSMakerDecision").value=='Reject to CSO' || document.getElementById("wdesk:OPSMakerDecision").value=='Reject to Card Settlement')
					{
						alert("Decision 'Approve' is not allowed if OPS Maker Decision was Reject to CSO or Reject to Card Settlement");
						document.getElementById("selectDecision").value='--Select--';
						document.getElementById("selectDecision").focus();
					}
				}
				if(document.getElementById("selectDecision").value=='Reject to CSO' || document.getElementById("selectDecision").value=='Reject to Maker')
				{
				 document.getElementById("wdesk:PreviousRejectedBy").value ='OPS checker';
				}
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';
				
				
				
			}
			
			//Added by siva for the newly added ws for 21 service request start
			
			if(WSNAME=='Q17')//Q17=Card Maintenance Maker
			{
				document.getElementById("wdesk:CardMaintenanceMakerDecision").value = dropdown.value;
					if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Card Maintenance Maker';
					else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			if(WSNAME=='Q18')//Q18=Card Maintenance Checker
			{
				if(document.getElementById("selectDecision").value=='Approve')
				{
					if(document.getElementById("wdesk:CardMaintenanceMakerDecision").value=='Reject to CSO')
					{
						alert("Decision 'Approve' is not allowed if Card Maintenance Maker Decision was Reject to CSO");
						document.getElementById("selectDecision").value='--Select--';
						document.getElementById("selectDecision").focus();
					}
				}
				
				if(document.getElementById("selectDecision").value=='Reject to Card Maintenance Maker' || document.getElementById("selectDecision").value=='Reject to CSO')
				document.getElementById("wdesk:PreviousRejectedBy").value ='Card Maintenance checker';
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			
			if(WSNAME=='Q20')//Q20=Card Dispatch Maker
			{
				document.getElementById("wdesk:CardDispatchMakerDecision").value = dropdown.value;
					if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Card Dispatch Maker';
					else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			if(WSNAME=='Q21')//Q21=Card Dispatch Checker
			{
				if(document.getElementById("selectDecision").value=='Approve')
				{
					if(document.getElementById("wdesk:CardDispatchMakerDecision").value=='Reject to CSO')
					{
						alert("Decision 'Approve' is not allowed if Card Dispatch Maker Decision was Reject to CSO");
						document.getElementById("selectDecision").value='--Select--';
						document.getElementById("selectDecision").focus();
					}
				}
				
				if(document.getElementById("selectDecision").value=='Reject to Maker' || document.getElementById("selectDecision").value=='Reject to CSO' || document.getElementById("selectDecision").value=='Reject to Card Dispatch')
				document.getElementById("wdesk:PreviousRejectedBy").value ='Card Dispatch checker';
				else
				document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			
			//Added by siva for the newly added ws for 21 service request end
			
			//added by nikita for the loan service request start
			if(WSNAME=='Q23')//Q23=Loan Services Maker
			{
				var iframe = document.getElementById("frmData");
				var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
				var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
				document.getElementById("SubCategoryID").value=SubCategoryID;
				var id = SubCategoryID+"_IslamicOrConventional";
				
				var islamic_conventional = window.parent.frames['customform'].frmData.document.getElementById(id).value;
				document.getElementById("islamic_conventional").value=islamic_conventional;
				
				if((document.getElementById("selectDecision").value=='Islamic / Conventional category changed') && (document.getElementById("wdesk:IslamicConvention").value == islamic_conventional))
				{
					alert("Please change value of Islamic field");
				}
								
					document.getElementById("wdesk:LoanServicesMakerDecision").value = dropdown.value;
					if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Loan Services Maker';
					else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			
			if(WSNAME=='Q24')//Q24=Loan Services Checker
			{
				if(document.getElementById("selectDecision").value=='Approve')
				{
					if(document.getElementById("wdesk:LoanServicesMakerDecision").value=='Reject to CSO')
					{
						alert("Decision 'Approve' is not allowed if Loan Services Maker Decision was Reject to CSO");
						document.getElementById("selectDecision").value='--Select--';
						document.getElementById("selectDecision").focus();
					}
				}
					
					if(document.getElementById("selectDecision").value=='Reject to Loan Services Maker' || document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Loan Services Checker';
					else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			//added by nikita for the loan service request end
			if(WSNAME=='Q13')//Q13=OPS Hold
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='OPS Hold';
				else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			else if(WSNAME=='Q16')//Q16=Card Settlement Hold
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Card Settlement Hold';
				else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			else if(WSNAME=='Q19')//Q19=Card Maintenance Hold
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Card Maintenance Hold';
				else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			else if(WSNAME=='Q22')//Q22=Card Dispatch Hold
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Card Dispatch Hold';
				else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			else if(WSNAME=='Q25')//Q25=Loan Services Hold
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviousRejectedBy").value ='Loan Services Hold';
				else
					document.getElementById("wdesk:PreviousRejectedBy").value ='';
			}
			//*************************************************
			
			//updating previous rejected by on all hold queues
			
			//Added by Nikita on 03042018 for the retention date validation
			if(WSNAME=='Q26')//Q24=Deliverables Retention Expired
			{
			 if(document.getElementById("selectDecision").value=='Retention Extended')
			 {
			 document.getElementById("wdesk:RetentionExpiryDate").disabled =false;
			 document.getElementById("CalRetExpiryDate").disabled = false;
			 document.getElementById("wdesk:RetentionExpiryDate").value ="";
			 }
			 else
			 {
			 document.getElementById("wdesk:RetentionExpiryDate").disabled =true;
			 document.getElementById("CalRetExpiryDate").disabled = true;
			 
			 }
			}
			
			// Enabling Hold till date when Decision is selected as Hold.
			if(WSNAME=='Q2' || WSNAME=='Q4'|| WSNAME=='Q11'|| WSNAME=='Q12'|| WSNAME=='Q17'|| WSNAME=='Q18'|| WSNAME=='Q20'|| WSNAME=='Q21'||WSNAME=='Q23' || WSNAME=='Q24')//Q2==OPS Maker,Q4==OPS Checker, Q11=Card Settlement Maker, Q12=Card Settlement Checker, Q17=Card Maintenance Maker, Q18=Card Maintenance Checker, Q20=Card Dispatch Maker, Q21=Card Dispatch Checker,Q23=Loan Services Maker,Q24=Loan Services Checker
			{
				if(document.getElementById("selectDecision").value=='Hold')
				{
					document.getElementById("wdesk:HoldTillDate").disabled = false;
					document.getElementById("CalHoldTillDate").disabled = false;
				} else {
					document.getElementById("wdesk:HoldTillDate").disabled = true;
					document.getElementById("CalHoldTillDate").disabled = true;
					document.getElementById("wdesk:HoldTillDate").value = '';
				}		
			}
			//Added by Akshaya for enabling doccollectionbranch at Q6 workstep
			if(WSNAME=='Q6')
			{
				//alert("document.getElementById('wdesk:Decision')  "+document.getElementById(inputTextBoxId).value);
				//alert("document.getElementById('selectDecision')  "+document.getElementById('selectDecision').value);
				document.getElementById(inputTextBoxId).value=dropdown.value;
				if(inputTextBoxId=='wdesk:Decision')
				{
					if(document.getElementById(inputTextBoxId).value=='Branch Transfer')
					{				
						//alert("Enabling DocumentCollectionBranch");
						document.getElementById("doccollectionbranch").disabled = false;	
					} 
					else
						document.getElementById("doccollectionbranch").disabled = true;
				
					//Added by Nikita for SRB CR 22032018
					if(document.getElementById("selectDecision").value=='Sent by Courier')
					{
						//alert("Enabling Branch AWB Number");	
						document.getElementById('wdesk:BranchAWBNumber').disabled=false;
					}
					else
						document.getElementById('wdesk:BranchAWBNumber').disabled=true;
				}
				
				//enabling Read Emirates Id button when type of id is selected as 'Emirates ID'
				if(inputTextBoxId=='wdesk:type_of_id')
				{
					if(document.getElementById(inputTextBoxId).value=='Emirates ID')
					{				
						document.getElementById("ReadEmiratesIDForGenAck").disabled = false;	
					} 
					else
						document.getElementById("ReadEmiratesIDForGenAck").disabled = true;	
				}
			}
	
	}
	function setPrimaryField()
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
	
		var CategoryID = iframeDocument.getElementById("CategoryID").value;
		document.getElementById("CategoryID").value=CategoryID;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		document.getElementById("SubCategoryID").value=SubCategoryID;
		var ws_name = iframeDocument.getElementById("WS_NAME").value;
		var cardNum = iframeDocument.getElementById("PANno").value;
		document.getElementById("wdesk:encryptedkeyid").value = cardNum;
		var WS_LogicalName = iframeDocument.getElementById("WS_LogicalName").value; 	
		document.getElementById("Workstep").innerHTML ="&nbsp;<b>"+WS_LogicalName+"</b>";
        
		//Added below for Dynamic Title of webpage
		var readOnly = "";
		if((parent.document.title).indexOf("(read only)")>0)
			readOnly="(read only)";
		
		parent.document.title = 'Workdesk - '+document.getElementById("wdesk:WI_NAME").value+" ["+WS_LogicalName+"]  "+readOnly;
		
		if(ws_name=="Introduction" && document.getElementById("savedFlagFromDB").value=="")
		{
			if(CategoryID==1 && (document.getElementById("d_PANno").value).indexOf("X")==-1)
			{
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,6)+"XXXXXX"+document.getElementById("d_PANno").value.substring(12,16);
				document.getElementById("d_PANno").value=document.getElementById("d_PANno").value.substring(0,4)+"-"+document.getElementById("d_PANno").value.substring(4,8)+"-"+document.getElementById("d_PANno").value.substring(8,12)+"-"+document.getElementById("d_PANno").value.substring(12,16);
			}
		}
		else
		{
			if(CategoryID==1)
			{
				document.getElementById("d_PANno").value=iframeDocument.getElementById(SubCategoryID+"_Cardno_Masked").value;
			}

			document.getElementById("d_PANno").readOnly=true;
		}
		
		
		return true;
		
	}
	function sah() 
	{
        sah1(document.getElementById("mainEmiratesId"));
    }
    function sah1(el) 
	{
        try {
            el.disabled = el.disabled ? false : true;
        } catch (E) {}
        if (el.childNodes && el.childNodes.length > 0) {
            for (var x = 0; x < el.childNodes.length; x++) {
                sah1(el.childNodes[x]);
            }
        }
    }
	function validateAppDate(value,field)
	{
		if(value=='')
		return;
		var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		if (!pattern.test(value)) 
		{
			alert("Invalid date format.");
			
			if (field == "wdesk:ApplicationDate") {
			document.getElementById("wdesk:ApplicationDate").value = "";
			}
			else if (field == "wdesk:HoldTillDate"){
			document.getElementById("wdesk:HoldTillDate").value = "";
			}
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
			if (field == "wdesk:ApplicationDate") {
				if(timeDiffPassport > 0) 
				{
					alert("Application date should not be future date.");
					document.getElementById("wdesk:ApplicationDate").value = "";
					return false;			
				}
			}
			if (field == "wdesk:HoldTillDate") {
				if(timeDiffPassport < 0) 
				{
					alert("Hold Till Date should be future date.");
					document.getElementById("wdesk:HoldTillDate").value = "";
					return false;			
				}
			}
		}
	}
	
	//Added By Nikita on 04042018 for the Rentention Expiry Date Validation for SRB CR
	function validateRetExpiryDate(value)
	{
	 if(value=='')
		return;
		var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		if (!pattern.test(value)) 
		{
			alert("Invalid date format.");
			document.getElementById("wdesk:RetentionExpiryDate").value = "";
		}
		else
		{
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!            
		var yyyy = today.getFullYear();
			if(dd<10)
			{
			dd = '0'+dd;
			}
			if(mm<10)
			{
			mm='0'+mm;
			}
			var todaydate = dd+'/'+mm+'/'+yyyy;
			var todaydateftersplit = todaydate.split("/");
			var date2 = new Date(todaydateftersplit[2], todaydateftersplit[1] - 1, todaydateftersplit[0]);
			//alert("todaydate"+todaydate);
			var dd1 = today.getDate() + 1;
			if(dd1<10)
			dd1= '0'+dd1;
			
			var nextdate = dd1 + '/'+ mm +'/'+yyyy;
			var nextdatesplit = nextdate.split("/");
			var date3 = new Date(nextdatesplit[2], nextdatesplit[1] - 1, nextdatesplit[0]);
			
			var currentdate = today.getDate() + 15 + '/'+ mm +'/'+yyyy;
			var currentdatesplit = currentdate.split("/");
			var date4 = new Date(currentdatesplit[2], currentdatesplit[1] - 1, currentdatesplit[0]);
		
			var retentionexpirydate = document.getElementById("wdesk:RetentionExpiryDate").value;
			var entereddate = retentionexpirydate.split("/");
			var date1 = new Date(entereddate[2], entereddate[1] - 1, entereddate[0]);
			
			if(date1 <= date2){
			alert("Retention Expiry Date should be future date");
			document.getElementById("wdesk:RetentionExpiryDate").value="";
			}
			
			else if(date1 <= date3 || date1 >= date4)
			{
			alert("Retention Expiry Date should be between next date and current date plus 15");
			document.getElementById("wdesk:RetentionExpiryDate").value= "";
			
			}
	
		}
	
	}
	
	function validatedefexpirydate(id)
	{
			var enteredDOB = document.getElementById(id).value;
				var today = new Date();
				var arrStartDate = enteredDOB.split("/");
				var date1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
				var timeDiffDOB = date1.getTime() - today.getTime();
				if (timeDiffDOB < 0) {
					alert("Deferral Expiry Date should be greater than current Date.");
					document.getElementById(id).value = "";
					return false;
				}
	
	}
	//Validate Expiry Date nikita 20/03/2017
	
	// function added to validate Statement From Date and Statement To Date added on 08/06/2017
	function validateStatementDate(field,value,Object)
	{
		if(value=='')
		return;
		var pattern = /^([0-9]{2})\/([0-9]{2})\/([0-9]{4})$/;
		if (!pattern.test(value)) 
		{
			alert("Invalid date format.");
			document.getElementById(Object).value = "";
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
			
			var iframe = document.getElementById("frmData");
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			var selects = iframeDocument.getElementsByTagName("select");
			var inputs = iframeDocument.getElementsByTagName("input");
			
			if (field == "FromDate") {
					try 
					{
						var todate = "";
						for (x = 0; x < inputs.length; x++) 
						{
							myname = inputs[x].getAttribute("id");
							if (myname == null||myname == '')
							continue;
							if(myname.indexOf("StatementRequestToDate")!=-1)
							{
								todate = iframeDocument.getElementById(myname).value;
								break;
							}
						}
						for (x = 0; x < inputs.length; x++) 
						{
							myname = inputs[x].getAttribute("id");
							if (myname == null||myname == '')
							continue;
							if(myname.indexOf("StatementRequestFromDate")!=-1)
							{
								if(timeDiffPassport > 0) 
								{
									alert("Statement Request From Date should not be future date.");
									iframeDocument.getElementById(myname).value = "";
									return false;	
								}
								if (todate!='')
								{
									var arrStartDate = todate.split("/");            
									var ToDate1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
									var timeDiff = date2.getTime() - ToDate1.getTime();
									if(timeDiff > 0) 
									{
										alert("Statement Request From Date should not be Greater than Statement Request To Date.");
										iframeDocument.getElementById(myname).value = "";
										return false;	
									}
								}
							}
						}
						//Added by siva for newly added 21 card service request start for From Date 09102017
						for (x = 0; x < inputs.length; x++) 
						{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if(myname.indexOf("ToDate")!=-1)
						{
							todate = iframeDocument.getElementById(myname).value;
							break;
						}
						}	
						for (x = 0; x < inputs.length; x++) 
						{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if(myname.indexOf("FromDate")!=-1)
						{
							if(timeDiffPassport > 0) 
							{
								alert("From Date should not be future date.");
								iframeDocument.getElementById(myname).value = "";
								return false;
							}
							if (todate!='')
							{
								var arrStartDate = todate.split("/");            
								var ToDate1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
								var timeDiff = date2.getTime() - ToDate1.getTime();
								if(timeDiff > 0) 
									{
									alert("From Date should not be Greater than To Date.");
									iframeDocument.getElementById(myname).value = "";
									return false;	
									}
								}
							}							
						}
						//Added by siva for newly added 21 card service request end  for From Date 09102017
					} 
					catch (err) 
					{
						return "exception";
					}
					return true;			
				
			}
			if (field == "ToDate") {
				try 
				{
					var fromdate = "";
					for (x = 0; x < inputs.length; x++) 
					{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if(myname.indexOf("StatementRequestFromDate")!=-1)
						{
							fromdate = iframeDocument.getElementById(myname).value;
							break;
						}
					}	
					for (x = 0; x < inputs.length; x++) 
					{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if(myname.indexOf("StatementRequestToDate")!=-1)
						{
							if(timeDiffPassport > 0) 
							{
								alert("Statement Request To Date should not be future date.");
								iframeDocument.getElementById(myname).value = "";
								return false;
								break;
							}
							if (fromdate!='')
							{
								var arrStartDate = fromdate.split("/");            
								var fromdate1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
								var timeDiff = date2.getTime() - fromdate1.getTime();
								if(timeDiff < 0) 
								{
									alert("Statement Request To Date should not be lesser than Statement Request From Date.");
									iframeDocument.getElementById(myname).value = "";
									return false;	
									break;
								}
							}
						}							
					}
					//Added by siva for newly added 21 card service request start for To date 09102017
					for (x = 0; x < inputs.length; x++) 
					{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if(myname.indexOf("FromDate")!=-1)
						{
							fromdate = iframeDocument.getElementById(myname).value;
							break;
						}
					}	
					for (x = 0; x < inputs.length; x++) 
					{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if(myname.indexOf("ToDate")!=-1)
						{
							if(timeDiffPassport > 0) 
							{
								alert("To Date should not be future date.");
								iframeDocument.getElementById(myname).value = "";
								return false;
								break;
							}
							if (fromdate!='')
							{
								var arrStartDate = fromdate.split("/");            
								var fromdate1 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
								var timeDiff = date2.getTime() - fromdate1.getTime();
								if(timeDiff < 0) 
								{
									alert("To Date should not be lesser than From Date.");
									iframeDocument.getElementById(myname).value = "";
									return false;	
									break;
								}
							}
						}							
					}
					//Added by siva for newly added 21 card service request end for To date 09102017
				} 
				catch (err) 
				{
					return "exception";
				}
			}
		}
	}
	
	

	//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	//Group                       :           Application Projects
	//Project                     :           RAKBank eForms Phase-I 
	//Date Written                : 
	//Date Modified               : 
	//Author                      :           
	//Description                 :           function is used to remove time from date field.

	//***********************************************************************************// 		
		function setDateOnly(id){
			document.getElementById(id).value = document.getElementById(id).value.substring(0, 10);
		}
//*
	function setSubCategory(selectedValue,SubCategory,cat_Subcat)
	{
		/*if(selectedValue=='--Select--')
		{
			document.getElementById(SubCategory).disabled=true;
			document.getElementById(SubCategory).selectedIndex=0;
			return;
		}
		document.getElementById(SubCategory).innerHTML = "";
		var select = document.getElementById(SubCategory);

		document.getElementById(SubCategory).disabled=false;
		var arr=cat_Subcat.split('~');
		for(var i = 0; i < arr.length; i++)
		{
			var temp=arr[i].split('#');
			var Cat=temp[0];
			var SubCat=temp[1];
			if(Cat==selectedValue)
			{
				var temp1=SubCat.split(',');
				select.options[select.options.length] = new Option('--Select--', '--Select--');	
				for(var j = 0; j < temp1.length; j++)
				{	
					if(temp1[j]!="")
						select.options[select.options.length] = new Option(temp1[j],temp1[j]);					
				}
				break;
			}
		
		}*/
		document.getElementById(SubCategory).value=selectedValue;
	
	}
	
	//handled by shamily for fetching of decision on the basis of ws name and route category start
	
	function setdecision()
	{
		
		var xhr;
		var ajaxResult;
		ajaxResult = "";
		var reqType = "fetchdecision";

		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");
		var ROUTECATEGORY = document.getElementById("wdesk:ROUTECATEGORY").value;
		var selectDecision = document.getElementById("selectDecision");
		var WSNAME = '<%=WSNAME%>';
		var wi_name = '<%=WINAME%>';
		
		if(WSNAME == 'Introduction')
			WSNAME = 'CSO';
			
				var url = '/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp?wi_name=' + wi_name + "&reqType=" + reqType+ "&WSNAME=" + WSNAME+ "&ROUTECATEGORY=" + ROUTECATEGORY;
			
		
		xhr.open("GET", url, false);
		xhr.send(null);
	
		if (xhr.status == 200) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			
			ajaxResult = '--Select--,'+ajaxResult;
			if (ajaxResult.indexOf("Error") == 0) {
				alert("Some problem in fetching getOPSRejectRemarks.");
				return false;
			}
			
			else
			{
		
				values = ajaxResult.split(",");
				
				for(i = selectDecision.options.length-1; i >=0; i--) {
				
					//if (selectDecision.options[i].selected) {
				
						selectDecision.remove(i);
					//}
				}
				
				for (var i=0 ; i< values.length ; i++) {
				var opt = document.createElement('option');
				
				opt.innerHTML = values[i];
				opt.value = values[i];
				opt.length = values[i].length;
				opt.className="EWNormalGreenGeneral1";
				selectDecision.appendChild(opt);
				}
			
			}
			}
		
	}
	
	//handled by shamily for fetching of decision on the basis of ws name and route category end
	
	function HistoryCaller()
	{
		//For loading history
		var hist_table="usr_0_srm_wihistory";
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
		//var Category=document.getElementById("wdesk:Category").value;
		//var SubCategory=document.getElementById("wdesk:SubCategory").value;
		openWindow("../SRB_Specific/history.jsp?WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&hist_table="+hist_table,'wihistory','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,resizable=no,width=800,height=400');
		var WSNAME = '<%=WSNAME%>'; //added by shamily to fetch opsmaker remarks
		if (WSNAME=='Q4')
		document.getElementById('flagForDecHisButton').value = 'Yes';
		
	}

	function validate(ColumnCopy)
	{ //alert('Testing');
		try{	
			//document.getElementById("Fetch").disabled=true;
			document.getElementById("wdesk:Category").value=document.getElementById("Category").value;
			//document.getElementById("wdesk:CifId").value=document.getElementById("Cifnumber").value;
			document.getElementById("wdesk:SubCategory").value=document.getElementById("SubCategory").value;
			document.getElementById("wdesk:Channel").value=document.getElementById("Channel").value;
			var panNo=document.getElementById(ColumnCopy).value;
			var CIF_ID="";
			var SavedCIF = document.getElementById("wdesk:CifId").value;
			if(SavedCIF!='')
			CIF_ID=SavedCIF;
			else
			CIF_ID = document.getElementById("Cifnumber").value;
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("EmiratesID").value;
			if(document.getElementById("Channel").value=="--Select--")
			{
				alert("Channel is Mandatory");
				document.getElementById("Channel").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if(document.getElementById("Category").value=="--Select--")
			{
				alert("Category is Mandatory");
				document.getElementById("Category").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if(document.getElementById("SubCategory").value=="--Select--")
			{
				alert("Sub Category is Mandatory");
				document.getElementById("SubCategory").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if ((CIF_ID == "") && (account_number == "") && (loan_agreement_id == "") && (card_number == "") && (emirates_id == "")) 
			{
			alert("Please enter the Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No. ");
			return false;
			}
		/*	if(emirates_id!=''&&emirates_id.length!=21)  //commented by shamily as therre is no length validation on emirates id in srs 
			{
				alert("Emirates ID.Emirates ID should be exactly of 21 digit");	
				document.getElementById("emiratesid").value='';
				document.getElementById("emiratesid").focus();
				return false;
			} */
			if(CIF_ID!=''&&CIF_ID.length!=7)
			{
				alert("Invalid CIF Number.CIF Number should be exactly of 7 digit");	
				document.getElementById("Cifnumber").value='';
				document.getElementById("Cifnumber").focus();
				return false;
			}
			if(account_number!=''&&account_number.length!=13)
			{
				alert("Invalid Account Number.Account Number should be exactly of 13 digit");	
				document.getElementById("accountNo").value='';
				document.getElementById("accountNo").focus();
				return false;
			}
			if(card_number!=''&&card_number.length!=16)
			{
				alert("Invalid Card Number.Card Number should be exactly of 16 digit");	
				document.getElementById("cardno").value='';
				document.getElementById("cardno").focus();
				return false;
			}
			if(loan_agreement_id!=''&&loan_agreement_id.length!=8)
			{
				alert("Invalid Loan Agreement Number.Loan Agreement Number should be exactly of 8 digit");	
				document.getElementById("loanaggno").value='';
				document.getElementById("loanaggno").focus();
				return false;
			}
			
			document.getElementById("Category").disabled=true;
			document.getElementById("SubCategory").disabled=true;
			document.getElementById("Channel").disabled=true;
			document.getElementById(ColumnCopy).disabled=true;
			
			//Getting all hidden parameter from database			
			if(!loadAllHiddenParamForServiceRequest())
			return false;
			//*****************************************	
			
			// getting decision based on Route Category
			setdecision();
			//*****************************************
			
			// below function is called to get Mode of delivery based on service request type	
			if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
			{
				LoadModeOfDelivery();
				if(document.getElementById('wdesk:ModeOfDelivery').value!='')
				{
					selectitems();
				}
				disableDeliveryMode();
			}
			
			//alert("ColumnCopy2");
			var WINAME=document.getElementById("wdesk:WI_NAME").value;
			var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
			//var WS=document.getElementById("wdesk:WS_NAME").value;
			var WS='<%=WSNAME%>';
			var category = document.getElementById("wdesk:Category").value;
			var subCategory  = document.getElementById("wdesk:SubCategory").value;
			var subCategoryCode  = document.getElementById("wdesk:ServiceRequestCode").value;
			var frmData = document.getElementById("frmData");
			//alert("ColumnCopy3");
			if(category=='Cards')
			{	
				//alert("ColumnCopy4");
				//alert("before"+panNo);
				panNo = Encrypt(panNo);
				document.getElementById("wdesk:encryptedkeyid").value = panNo;
				//alert(panNo);
			}
			//alert("ColumnCopy5");
			var sUrl="../SRB_Specific/BPM_CommonBlocksDebitCard.jsp?load=firstLoad&panNo="+panNo+"&WS="+WS+"&Category="+category+"&SubCategory="+subCategory+"&WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&FlagValue=N"+"&subCategoryCode="+subCategoryCode;
			//alert("sUrl : "+sUrl);
			var frmData = document.getElementById("frmData");
			frmData.style.display ='block';
			frmData.src = replaceUrlChars(sUrl);
			//alert("returned sUrl"+sUrl);
			return true;
		}
		catch(e)
		{
			alert("error=="+e.message);
			return false;
		}
		
	}
	
	function validateFieldLength(value,FieldName)
	{
		if (FieldName == 'Additional Sign Account')
		{
			if(value!='' && value.length!=13)
			{
				alert("Invalid Account Number. Addition Sign Account Number should be exactly of 13 digit");	
				document.getElementById("wdesk:AdditionalSignAccount").focus();
				return false;
			}
		}
	}
	
	function ClearFields(savedFlagFromDB)
	{
		//alert("document.getElementById(IsSavedFlag).value="+document.getElementById("IsSavedFlag").value);
		if(!(savedFlagFromDB=='Y' || document.getElementById("IsSavedFlag").value=='Y'))
		{
			//document.getElementById("Category").disabled=false;
			document.getElementById("Category").selectedIndex=0;
			document.getElementById("SubCategory").disabled=true;
			document.getElementById("SubCategory").selectedIndex=0;
			//document.getElementById("Channel").disabled=false;
			//document.getElementById("Channel").selectedIndex=0;
			document.getElementById("Cifnumber").disabled=false;
			document.getElementById("Cifnumber").readOnly=false;
			document.getElementById("Cifnumber").value="";
			document.getElementById("Fetch").disabled=false;
			document.getElementById("Fetch").disabled=false;
			document.getElementById("EmiratesID").value="";
			document.getElementById("Cifnumber").value="";
			document.getElementById("accountNo").value="";
			document.getElementById("cardno").value="";
			document.getElementById("loanaggno").value="";	
			document.getElementById("SubCategory_search").value="";	
			document.getElementById("SubCategory_search").disabled=false;	
			
			document.getElementById("wdesk:CifId").value="";
			document.getElementById("wdesk:Name").value="";
			document.getElementById("wdesk:SubSegment").value="";
			document.getElementById("wdesk:ARMCode").value="";
			document.getElementById("wdesk:RAKElite").value="";	
			document.getElementById("wdesk:EmiratesIDHeader").value="";	
			document.getElementById("wdesk:EmratesIDExpDate").value="";	
			document.getElementById("wdesk:TLIDHeader").value="";	
			document.getElementById("wdesk:TLIDExpDate").value="";	
			document.getElementById("wdesk:PrimaryEmailId").value="";	
			document.getElementById("wdesk:ApplicationDate").value="";	
			
			document.getElementById("EmiratesID").disabled=false;;
			document.getElementById("Cifnumber").disabled=false;;
			document.getElementById("accountNo").disabled=false;;
			document.getElementById("cardno").disabled=false;;
			document.getElementById("loanaggno").disabled=false;;	
			
			document.getElementById("dispatchHeader").style.display="none";
			
			var frmData = document.getElementById("frmData");
			frmData.src="../SRB_Specific/BPM_blank.jsp";
			document.getElementById("mainEmiratesId").innerHTML=""; 
			document.getElementById("duplicateWorkitemsId").innerHTML=""; 
			frmData.style.display ='none';
		}
		else
		{
		alert("This case has been saved. It cannot be cleared!");
		document.getElementById("Clear").disabled=true;
		}
	}
	function DiscardWI()
	{
		//alert(document.getElementById("SubCategory").value);
		if(document.getElementById("SubCategory").value!='Balance Transfer' && document.getElementById("SubCategory").value!='Credit Card Cheque'    && document.getElementById("SubCategory").value!='Blocking of Cards')
		{
			document.getElementById("wdesk:IsRejected").value="Y";
			var opener;
			if (window.dialogArguments) 
			{ 
				opener = window.dialogArguments;
			} 
			else 
			{
				if(parent)
				{
					opener=parent;
				}
				else if (window.top.opener) 
				{
					opener = window.top.opener; 
				}
			}  
			opener.introduceWI();
	}else{
	
	//alert();
	alert("Case cannot be discarded for " + document.getElementById("SubCategory").value);
	document.getElementById("Discard").disabled=true;
	}
	
	}
	function replaceUrlChars(sUrl)
	{	
		//alert("inside replaceUrlChars");
		return sUrl.split("+").join("ENCODEDPLUS");
	
	}
	function CallJSP(WSNAME,Flag,ViewMode)
	{
		//alert("test");
		//$(#wdesk.input).attr("disabled","disabled");
		
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
		
		if(WSNAME=="Introduction")
			setSubCategory(document.getElementById("wdesk:Category").value, 'SubCategory', document.getElementById("cat_Subcat").value);
		//alert("Inside calljsp2");
		document.getElementById("SubCategory").value=document.getElementById("wdesk:SubCategory").value;
		document.getElementById("SubCategory_search").value=document.getElementById("wdesk:SubCategory").value;
		document.getElementById("Category").value=document.getElementById("wdesk:Category").value;
		document.getElementById("Channel").value=document.getElementById("wdesk:Channel").value;
		document.getElementById("Channel").selectedIndex=1;
		//document.getElementById("CifId").value=document.getElementById("wdesk:CifId").value;	
		var category = document.getElementById("wdesk:Category").value.split(' ').join('_');
		var subCategory  = document.getElementById("wdesk:SubCategory").value.split(' ').join('_');
		
		var frmData = document.getElementById("frmData");
		var iframeDocument = (frmData.contentDocument) ? frmData.contentDocument : frmData.contentWindow.document;
		document.getElementById("Category").disabled=true;
		document.getElementById("SubCategory").disabled=true;
		// making SubCategory search field enable when item submitted from omniscan without selecting SubCategry
		if(WSNAME=="Introduction" && document.getElementById("SubCategory_search").value == "--Select--")
		{
			document.getElementById("SubCategory_search").disabled=false;
			document.getElementById("SubCategory_search").value='';
			setAutocompleteData();
		} else {
			document.getElementById("SubCategory_search").disabled=true;
		}
		document.getElementById("Channel").disabled=true;
		
		//added for making branch delivery and courier awr number disabled on 2nd load
		document.getElementById("branchDeliveryMethod").disabled=true;
		document.getElementById("wdesk:CourierAWBNumber").disabled=true;
		document.getElementById("wdesk:CourierCompName").disabled=true;
		document.getElementById("doccollectionbranch").disabled=true;
		
		// Making deferral weiver field disbale if its selected as NO on second load added on 27032018
		if (document.getElementById("wdesk:DeferralWaiverHeld").value == 'N')
		{
			document.getElementById("wdesk:ApprovingAuthority").disabled=true;
			document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
			document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
			document.getElementById("DeferralExpiryDateCalImg").disabled=true;
		}
		if (document.getElementById("wdesk:WaiverHeld").value == 'N')
		{
			document.getElementById("wdesk:ApprovingAuthorityWaiver").disabled=true;
			document.getElementById("wdesk:DocumentTypeWaivered").disabled=true;
		}
		/*if(WSNAME!="Introduction")
		{
		onloadmodeofdeliveryatnextws();
		}*/
		//********************************************
		
		//Below condition is for when case will be initiated by omniscan in case data will be already saved in database hence callJsp will be called and it fetch data without CIFID provided
		if(document.getElementById("wdesk:CifId").value=='' && WSNAME=="Introduction")
		return false;
		//*****************************************************
		
		if(WSNAME=="Introduction" && ViewMode!="R")
			document.getElementById("Fetch").disabled=true;
		var WSNAME='<%=WSNAME%>';
		
		if(WSNAME=="Introduction")
			reloadCifGridBySavedCifid();
		var subCategoryCode  = document.getElementById("wdesk:ServiceRequestCode").value;
		frmData.src = "../SRB_Specific/BPM_CommonBlocksDebitCard.jsp?load=SecondLoad&WS="+WSNAME+"&WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&Category="+category+"&SubCategory="+subCategory+"&FlagValue="+Flag+"&ViewMode="+ViewMode+"&subCategoryCode="+subCategoryCode;
		
		//SelectDecisioncheker();
		SelectElement();
		disableAllFieldsAtNextWorkstep();
		if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
		{
			document.getElementById("dispatchHeader").style.display="block";
		}
		//point 58 drop 2
		if(WSNAME=='Q4'){
			getOPSRejectRemarks(document.getElementById("wdesk:OPSMakerDecision").value); // calling function to get Remarks and Reject Reason entered at OPS Maker
		}
		//added by shamily for BAT_SRB CR point 13
		if(WSNAME == 'Q2')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_maker").value = '';
			}
			
			if(document.getElementById("modeofdelivery").value=='Courier' || document.getElementById("modeofdelivery").value =='Courier Self' || document.getElementById("modeofdelivery").value =='Courier Authorised Person' || document.getElementById("modeofdelivery").value =='Courier to Office Address')
			{
				document.getElementById("branchDeliveryMethod").disabled = true;
			
			}else
			{
				document.getElementById("branchDeliveryMethod").disabled = false;
				document.getElementById("branchDeliveryMethod").focus();
			}
		}
		else if (WSNAME == 'Q4')
		{
		
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_checker").value = '';
			}
		}
		//added by badri for card CR'S
		else if (WSNAME == 'Q11')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_maker").value = '';
			}
		}
		else if (WSNAME == 'Q12')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_checker").value = '';
			}
		}
		else if (WSNAME == 'Q17')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_maker").value = '';
			}
		}
		else if (WSNAME == 'Q18')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_checker").value = '';
			}
		}
		else if (WSNAME == 'Q20')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_maker").value = '';
			}
		}
		else if (WSNAME == 'Q21')
		{
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_checker").value = '';
			}
		}
		
		//added by badri for card CR'S
		
		// enabling Additional Sign Account fields at all maker queue
		if (WSNAME == 'Q2' || WSNAME == 'Q11' || WSNAME == 'Q17' || WSNAME == 'Q20' || WSNAME == 'Q23')
		{
			document.getElementById("wdesk:AdditionalSignAccount").disabled=false;
		}
		
		if(WSNAME!="Introduction")
		{
			if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
			{
				LoadModeOfDelivery();
				if(document.getElementById('wdesk:ModeOfDelivery').value!='')
				{
					selectitems();
				}
				disableDeliveryMode();
			}
			if (WSNAME == 'Q6')
			{
				document.getElementById("ExistingDocCollBranch").value = document.getElementById("wdesk:DocumentCollectionBranch").value; 
			}
		}	
		
		if(document.getElementById("wdesk:printDispatchRequired").value=='Y' && WSNAME=="Introduction")
		{
			checkValueForModOfDelivery(); //added by ankit as part of making mode of delivery non mandatory
		}
		return true;
		
		
	}
	
	function getOPSRejectRemarks(OPSMakerDecision)
	{
		var wi_name = '<%=WINAME%>';

		var xhr;
		var ajaxResult;
		ajaxResult = "";
		var reqType = "GetOpsRejectRemarks";

		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = '/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp?wi_name=' + wi_name + "&reqType=" + reqType;

		xhr.open("GET", url, false);
		xhr.send(null);
		//added by badri to show decision,remarks and reject reason of maker
		if (xhr.status == 200) {
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

			if (ajaxResult.indexOf("Exception") == 0) {
				alert("Some problem in fetching getOPSRejectRemarks.");
				return false;
			}
			ajaxResult = ajaxResult.split("~");
			if(document.getElementById("wdesk:OPSMakerDecision").value=='Reject to CSO')//Q4==OPS Checker
			{
				document.getElementById("remarksops").value = ajaxResult[0];
				var text = ajaxResult[1];
				var re = /<br *\/?>/gi;
				document.getElementById("wdesk:rejectreasonsops").value  = text.replace(re, '\n');
				//document.getElementById("rejReasonCodes").value = ajaxResult[2];
			}
			/*if (text= "1. null")
			{
			document.getElementById("wdesk:rejectreasonsops").value  = ""
			}*/
				
			var WSNAME='<%=WSNAME%>';
			if(WSNAME=='Q4')//Q4==OPS Checker
			{
				document.getElementById("remarks").value = ajaxResult[0];
				document.getElementById('selectDecision').value = document.getElementById('wdesk:OPSMakerDecision').value;
				setComboValueToTextBox(this,'wdesk:Decision');
				document.getElementById('wdesk:Decision').value = document.getElementById('selectDecision').value ;
				//document.getElementById("").value = text.replace(re, '\n');
			}
		} else {
			alert("Error while getting getOPSRejectRemarks");
			return "";
		}
	}
	
	function disableAllFieldsAtNextWorkstep()
	{
			//alert("inside load 2");
			document.getElementById("EmiratesID").disabled=true;
			document.getElementById("Cifnumber").disabled=true;
			document.getElementById("accountNo").disabled=true;
			document.getElementById("cardno").disabled=true;
			document.getElementById("loanaggno").disabled=true;
			document.getElementById("Fetch").disabled=true;
			document.getElementById("Channel").disabled=true;	
			
			if('<%=WSNAME%>'=="Q1"||'<%=WSNAME%>'=="Q3"||'<%=WSNAME%>'=="Q4"||'<%=WSNAME%>'=="Q5"||'<%=WSNAME%>'=="Q6"||'<%=WSNAME%>'=="Q7"||'<%=WSNAME%>'=="Q8"||'<%=WSNAME%>'=="Q9"||'<%=WSNAME%>'=="Q10"||'<%=WSNAME%>'=="Q12"||'<%=WSNAME%>'=="Q13"||'<%=WSNAME%>'=="Q14"||'<%=WSNAME%>'=="Q15" || '<%=WSNAME%>'=="Q16" || '<%=WSNAME%>'=="Q17" || '<%=WSNAME%>'=="Q18" || '<%=WSNAME%>'=="Q19" || '<%=WSNAME%>'=="Q20" || '<%=WSNAME%>'=="Q21" || '<%=WSNAME%>'=="Q22" || '<%=WSNAME%>'=="Q23" || '<%=WSNAME%>'=="Q24"||'<%=WSNAME%>'=="Q25" || '<%=WSNAME%>'=="Q26")
			{	//Q26 is Deliverable Retention Expired Queue added by Siva
				document.getElementById("Clear").disabled=true;
				if('<%=WSNAME%>'!="Q4" && '<%=WSNAME%>'!="Q11" && '<%=WSNAME%>'!="Q12" && '<%=WSNAME%>'!="Q17" && '<%=WSNAME%>'!="Q18" && '<%=WSNAME%>'!="Q20" && '<%=WSNAME%>'!="Q21" && '<%=WSNAME%>'!="Q23" && '<%=WSNAME%>'!="Q24")   //added by shamily to make view signatures button enable
				{
					document.getElementById("viewSign").disabled=true;
				}	
				document.getElementById("ReadEmiratesID").disabled=true;
				if('<%=WSNAME%>'=="Q6") 
				{
					document.getElementById("Generate Acknowledgement").disabled=false;
					document.getElementById("type_of_idCombo").disabled=false;
				}
				if('<%=WSNAME%>'=="Q3")
				{
					document.getElementById("modeofdelivery").disabled=false;
				}
				else
					document.getElementById("modeofdelivery").disabled=true;
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("branchDeliveryMethod").disabled=true;
				document.getElementById("wdesk:CourierAWBNumber").disabled=true;
				document.getElementById("wdesk:CourierCompName").disabled=true;
				document.getElementById("wdesk:BranchAWBNumber").disabled=true;
				document.getElementById("wdesk:ApplicationDate").disabled=true;	
				document.getElementById("CalApplicationDate").disabled=true;	
				document.getElementById("DeferralWaiverHeldCombo").disabled=true;
				document.getElementById("WaiverHeldCombo").disabled=true;
				document.getElementById("wdesk:ApprovingAuthority").disabled=true;
				document.getElementById("wdesk:ApprovingAuthorityWaiver").disabled=true;
				document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
				document.getElementById("wdesk:DocumentTypeWaivered").disabled=true;
				document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
				sah();
				checkDuplicateWorkitemsOnLoadAtNextWorkstep();
				//$(frmData).find('input').attr('disabled', 'disabled');
				
				/*var frameEl=parent.frames['frmData'];
				var inputs=frameEl.document.getElementsByTagName('input');
				for(var i=0;i<=inputs.length;i++)
				{
					inputs[i].disabled=true;				
				}*/
			}
			if('<%=WSNAME%>'=="Q2"||'<%=WSNAME%>'=="Q11") //Q2 is OPS maker and Q11 is card settlement maker
			{
				document.getElementById("Clear").disabled=true;
				/*if('<%=WSNAME%>'!="Q2")  //added by shamily to make view signatures button enable
				{
					document.getElementById("viewSign").disabled=true;
				}	*/
				document.getElementById("ReadEmiratesID").disabled=true;
				document.getElementById("modeofdelivery").disabled=true;
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("branchDeliveryMethod").disabled=false;
				document.getElementById("wdesk:CourierAWBNumber").disabled=false;
				document.getElementById("wdesk:CourierCompName").disabled=false;
				document.getElementById("wdesk:BranchAWBNumber").disabled=false;
				document.getElementById("wdesk:ApprovingAuthority").disabled=true;
				document.getElementById("DeferralWaiverHeldCombo").disabled=true;
				document.getElementById("WaiverHeldCombo").disabled=true;
				document.getElementById("wdesk:ApplicationDate").disabled=true;
				document.getElementById("CalApplicationDate").disabled=true;
				document.getElementById("wdesk:ApprovingAuthorityWaiver").disabled=true;
				document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
				document.getElementById("wdesk:DocumentTypeWaivered").disabled=true;
				document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
				
				sah();
				checkDuplicateWorkitemsOnLoadAtNextWorkstep();
			}
			
			document.getElementById("ReadEmiratesID").disabled=true;
			setDateOnly("wdesk:ApplicationDate");
			setDateOnly("wdesk:DeferralExpiryDate");
			setDateOnly("wdesk:HoldTillDate");
			
	}
	function checkDuplicateWorkitemsOnLoadAtNextWorkstep()
	{	
			var ProcessInstanceId =document.getElementById("wdesk:WI_NAME").value;
			var WSNAME =document.getElementById("wdesk:WS_NAME").value;
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/SRB/CustomForms/SRB_Specific/getDuplicateWorkitems.jsp";

			var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME;

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
	}
	
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                       :           Application Projects
//Project                     :           RAKBank eForms Phase-I 
//Date Written                : 
//Date Modified               : 
//Author                      : 
//Description                 :          This function is used to validate that signature should be viewed 

//***********************************************************************************//				
	//added by badri for CARD CR's
	function setSignMatchValues(wsname,signMatchStatus)
	{
		if(wsname == 'Q2') 
		{
			document.getElementById('wdesk:sign_matched_maker').value = signMatchStatus;
		}
		else if(wsname == 'Q4') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		}
		else if(wsname == 'Q11') 
		{
			document.getElementById('wdesk:sign_matched_maker').value = signMatchStatus;
		}
		else if(wsname == 'Q12') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		}
		else if(wsname == 'Q17') 
		{
			document.getElementById('wdesk:sign_matched_maker').value = signMatchStatus;
		}
		else if(wsname == 'Q18') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		}
		else if(wsname == 'Q20') 
		{
			document.getElementById('wdesk:sign_matched_maker').value = signMatchStatus;
		}
		else if(wsname == 'Q21') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		}
		else if(wsname == 'Q23') 
		{
			document.getElementById('wdesk:sign_matched_maker').value = signMatchStatus;
		}
		else if(wsname == 'Q24') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		}
	}
		// Added by Badri for card CR
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
	function validateCCN(cntrl)
	{	
		var keycode=event.keyCode;
		
		var cntrlValue=cntrl.value;
	
		if(keycode!=46&&keycode!=8&&(cntrlValue.length==4||cntrlValue.length==9||cntrlValue.length==14))
			cntrl.value=cntrlValue+"-";
		
	}

	function validateCCNDataOnKeyUp(cntrl)
	{

		var regex=/^[0-9]{16}$/;
			if(regex.test(document.getElementById(ColumnCopy).value))
			{
				var vCCN=document.getElementById(ColumnCopy).value;
				document.getElementById(ColumnCopy).value=vCCN.substring(0,4)+"-"+vCCN.substring(4,8)+"-"+vCCN.substring(8,12)+"-"+vCCN.substring(12,16);
				return false;
			}		

		var	regex = /^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$/;	

		var keycode=event.keyCode;
		if(!(keycode>95&&keycode<106)&&!(keycode>47&&keycode<58)&&keycode!=8&&keycode!=145&&keycode!=19&&keycode!=45&&keycode!=33&&keycode!=34&&keycode!=35&&keycode!=36&&keycode!=37&&keycode!=38&&keycode!=39&&keycode!=40&&keycode!=46&&cntrl.value!=""&&!regex.test(cntrl.value))
			{
			alert("Invalid Credit Card No. Format");
			cntrl.value="";
			cntrl.focus();
			return false;
			}		
	}
	function formLoad()
	{
		document.getElementById('wdesk:DeferralWaiverHeld').value='N';//Default value of this field is N
		document.getElementById('wdesk:WaiverHeld').value='N';//Default value of this field is N	
		document.getElementById("Channel").disabled=true;
		document.getElementById("wdesk:ApprovingAuthority").disabled=true;
		document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
		document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
		document.getElementById("DeferralExpiryDateCalImg").disabled=true;
		document.getElementById("wdesk:ApprovingAuthorityWaiver").disabled=true;
		document.getElementById("wdesk:DocumentTypeWaivered").disabled=true;
		
		document.getElementById("branchDeliveryMethod").disabled=true;
		document.getElementById("wdesk:CourierAWBNumber").disabled=true;
		document.getElementById("wdesk:BranchAWBNumber").disabled=true;
		document.getElementById("wdesk:CourierCompName").disabled=true;
		document.getElementById("doccollectionbranch").disabled=true;

		//document.getElementById("Category").selectedIndex=1;
		setSubCategory(document.getElementById("Category").value,'SubCategory',document.getElementById("cat_Subcat").value.replace(", ", ","));
		document.getElementById("Channel").selectedIndex=1;
	}
	function selectitems() 
	{
		  var select = document.getElementById("modeofdelivery");
		  var savedValue=document.getElementById('wdesk:ModeOfDelivery').value;
		  if(savedValue.indexOf('&')<0)
		  {
			for(i=0; i<select.options.length; i++)
			{
			  if(select.options[i].value ==savedValue) 
			  {
				select.options[i].selected="selected";
			  }
			}  
		  }
		  else
		  {
			var array = savedValue.split("&");
			 for(var count=0; count<array.length; count++) 
			  {
				for(var i=0; i<select.options.length; i++)
				{
				  if(select.options[i].value == array[count]) 
				  {
					select.options[i].selected="selected";
				  }
				}
			  }
		  }
	}
	 
	function onloadmodeofdeliveryatnextws()
	{
		var savedValue = document.getElementById('wdesk:ModeOfDelivery').value;
		if(savedValue.indexOf('&')<0)
		  {
		  
		   var opt = document.createElement("option");
			 opt.text = savedValue;
			 opt.value =savedValue;
			document.getElementById("modeofdelivery").options.add(opt);
		  }
		  else
		  {
			var value = savedValue.split("&");
			for(var i=0;i<value.length;i++)
			{
			if(value[i]!='')
			 {
			 var opt = document.createElement("option");
			 opt.text = value[i];
			 opt.value =value[i];
			 document.getElementById("modeofdelivery").options.add(opt);
			 }
			}
			}
	}
	function SelectElement()
	{    
		//Setting combo values on load if it is saved in databse
		var WSNAME='<%=WSNAME%>';
		var elementmodeofdelivery = document.getElementById('modeofdelivery');
		if(document.getElementById('wdesk:ModeOfDelivery').value!='')
		{
			selectitems();
		}
		//elementmodeofdelivery.value = document.getElementById('wdesk:ModeOfDelivery').value;
		
		var elementdoccollectionbranch = document.getElementById('doccollectionbranch');
		if(document.getElementById('wdesk:DocumentCollectionBranch').value!='')
		elementdoccollectionbranch.value = document.getElementById('wdesk:DocumentCollectionBranch').value;
		
		var elementbranchDeliveryMethod = document.getElementById('branchDeliveryMethod');
		if(document.getElementById('wdesk:BranchDeliveryMethod').value!='')
		elementbranchDeliveryMethod.value = document.getElementById('wdesk:BranchDeliveryMethod').value;
		
		var elementDeferralWaiverHeldCombo = document.getElementById('DeferralWaiverHeldCombo');
		if(document.getElementById('wdesk:DeferralWaiverHeld').value!='')
		{	if(document.getElementById('wdesk:DeferralWaiverHeld').value=='N')
			elementDeferralWaiverHeldCombo.value ='N';
			if(document.getElementById('wdesk:DeferralWaiverHeld').value=='Y')
			elementDeferralWaiverHeldCombo.value ='Y';
			else
			elementDeferralWaiverHeldCombo.value =document.getElementById('wdesk:DeferralWaiverHeld').value;
		}
		var elementWaiverHeldCombo = document.getElementById('WaiverHeldCombo');
		if(document.getElementById('wdesk:WaiverHeld').value!='')
		{	if(document.getElementById('wdesk:WaiverHeld').value=='N')
			elementWaiverHeldCombo.value ='N';
			if(document.getElementById('wdesk:WaiverHeld').value=='Y')
			elementWaiverHeldCombo.value ='Y';
			else
			elementWaiverHeldCombo.value =document.getElementById('wdesk:WaiverHeld').value;
		}
		
		var type_of_idCombo = document.getElementById('type_of_idCombo');
		if(document.getElementById('wdesk:type_of_id').value!='')
		{
			type_of_idCombo.value = document.getElementById('wdesk:type_of_id').value;
			if(WSNAME=="Q6")//Branch Hold
			{
				if (type_of_idCombo.value == 'Emirates ID')
					document.getElementById("ReadEmiratesIDForGenAck").disabled=false;	
			}
		}
		
		if(WSNAME=="Q8")//Branch Hold
		{
			//select the decision Submit by default.
			document.getElementById("selectDecision").value='Submit';	
			document.getElementById("wdesk:Decision").value='Submit';	
			document.getElementById("selectDecision").disabled=true;			
		}
	}

	function reloadCifGridBySavedCifid()
	{
	   var SavedCIF=document.getElementById("wdesk:CifId").value;
	   var SavedCIFValues = document.getElementById("wdesk:CifId").value+"#"+document.getElementById("wdesk:Name").value+"#"+document.getElementById("wdesk:SubSegment").value+"#"+document.getElementById("wdesk:ARMCode").value+"#"+document.getElementById("wdesk:RAKElite").value;
	   //alert("SavedCIF "+SavedCIF);
	   //alert("SavedCIFValues "+SavedCIFValues);
		if (SavedCIF != '') 
		{
			getEntityDetailsCallAfterCifIdSaved();
			/*$(function() {
				$(":radio[value=" + SavedCIFValues + "]").click();
			});*/
		}
	}
	
	

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
		var AccountnoSig = document.getElementById("wdesk:AccountNo").value;   //added by shamily for view signature
		var AdditionalSignAccount = document.getElementById("wdesk:AdditionalSignAccount").value;   //taking additional sign account for view signature
		if (AccountnoSig != '' && AdditionalSignAccount !='')
			AccountnoSig = AccountnoSig + AdditionalSignAccount + '@';
		else if (AccountnoSig == '' && AdditionalSignAccount !='')
			AccountnoSig = AdditionalSignAccount + '@';
		
		var ws_name = '<%=WSNAME%>';
		//var sOptions = 'width=950px;height=650px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
		
		//fine
		//var sOptions = 'dialogWidth:450px; dialogHeight:450px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
		
		//perfectly fine
		//var sOptions = 'width=950px;height=650px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
		
		
		var sOptions = 'left=300,top=200,width=850,height=650,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
		
		var url = "/SRB/CustomForms/SRB_Specific/OpenImage.jsp?acc_num_new="+AccountnoSig+"&ws_name="+ws_name;
		popupWindow = window.open(url, "_blank", sOptions);
	}
//**********************************************************************************//
	function getEntityDetailsCallAfterCifIdSaved()
	{
			var CIF_ID="";
			var SavedCIF = document.getElementById("wdesk:CifId").value;
			if(SavedCIF!='')
			CIF_ID=SavedCIF;
			else
			CIF_ID = document.getElementById("Cifnumber").value;
		
			//Getting all hidden parameter from database			
			if(!loadAllHiddenParamForServiceRequest())
			return false;
			//*****************************************	
			
			// getting decision based on Route Category
			setdecision();
			//*****************************************
				
			// below function is called to get Mode of delivery based on service request type	
			if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
			{
				LoadModeOfDelivery();
				if(document.getElementById('wdesk:ModeOfDelivery').value!='')
				{
					selectitems();
				}
				disableDeliveryMode();
			}
				
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("EmiratesID").value;
			var wi_name = '<%=WINAME%>';
			var xmlDoc;
			var x;
			var xLen;
			var request_type = "ENTITY_DETAILS";
			var mobile_number = ""; //document.getElementById("wdesk:mob_phone_exis").value;
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

			var url = "SRBIntegration.jsp";

			var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;

			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
		

			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				
				if (ajaxResult.indexOf("Exception") == 0) 
				{
					alert("Please enter an valid Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No.");
					return false;
				}
				ajaxResult = ajaxResult.split("^^^");
				document.getElementById("mainEmiratesId").innerHTML = ajaxResult[0];
				document.getElementById("dispatchDtl").style.display ="block";
				
			} 
			else 
			{
				alert("Problem in getting Entity Details.");
				return false;
			}
	}
	
	function fetchAccountDetails(selectedCifId)
	{		
			if(document.getElementById("wdesk:ServiceRequestCode").value=='SRB136' || document.getElementById("wdesk:ServiceRequestCode").value=='SRB135')
			{
				return;
			}
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "FetchAccounts.jsp";
			var AccountIndicator = document.getElementById("AccountIndicator").value; //added by angad to fetch AccountIndicator and FetchClosedAcct
			var FetchClosedAcct = document.getElementById("FetchClosedAcct").value; //added by angad to fetch AccountIndicator and FetchClosedAcct
			var AccToBeFetched = document.getElementById("AccToBeFetched").value; //added by angad to call AccountSummary based on AccToBeFetched 
			var param = "CIFID=" + selectedCifId + "&AccountIndicator=" + AccountIndicator + "&FetchClosedAcct=" + FetchClosedAcct + "&AccToBeFetched=" + AccToBeFetched; //added by angad to fetch AccountIndicator and FetchClosedAcct

			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			
		   // alert("xhr.status "+xhr.status);
			
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				//alert("Response "+ajaxResult);
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				
				var arrayAjaxResult=ajaxResult.split("~");
				/*if(arrayAjaxResult[0]=='CINF362')   //added by shamily to show alert when account details not available in finacle
				{
				  alert("Account Details Not Found for the Given Data");
				  return;
				}
				else if(arrayAjaxResult[0]!='0000' && arrayAjaxResult[0]!='CINF362')
				{
				  alert("Error in fetching account nos.");
				  return;
				}*/
					
					var accountNo='';
					
					//below added by ankit for card list 02052018
					var cardListDet = '';
					var serviceCode = document.getElementById("wdesk:ServiceRequestCode").value;
					if(serviceCode == "SRB065" || serviceCode == "SRB066" || serviceCode == "SRB067" || serviceCode == "SRB068"|| serviceCode == "SRB069" || serviceCode == "SRB070" || serviceCode == "SRB168" || serviceCode == "SRB169")
					{
						var Number = '';
						var CardType = '';
						if (serviceCode=='SRB065' || serviceCode=='SRB066' || serviceCode=='SRB067')
						{
							Number = 'C'+selectedCifId;
							CardType = 'Credit';
						}
						if (serviceCode=='SRB068' || serviceCode=='SRB069' || serviceCode=='SRB070' || serviceCode == "SRB168" || serviceCode == "SRB169")
						{
							Number = 'D'+selectedCifId;
							CardType = 'Debit';
						}
						cardListDet = getCardListDetails(document.getElementById("wdesk:CifId").value, Number, CardType);
						cardListDet = cardListDet.split("~");
						cardListDet = cardListDet[1];
						
						accountNo = cardListDet; // populating card number only from Card List call for above service requests
					}
					 //added by ankit for card list 02052018
					else
					{
						if(arrayAjaxResult[0]=='CINF362')   //added by shamily to show alert when account details not available in finacle
						{
						  alert("Account Details Not Found for the Given Data");
						  return;
						}
						else if(arrayAjaxResult[0]!='0000' && arrayAjaxResult[0]!='CINF362')
						{
						  alert("Error in fetching account nos.");
						  return;
						}
						accountNo=arrayAjaxResult[1]; // taking data received from Account Summary call only
					}
					
					if (accountNo.length == 0)
					{
					  alert("No Account/Card Details Found for the Given Data");
					  return;
					}
					
					//*****************
					var accountNoForSig = arrayAjaxResult[3];
					var arrayaccountnosig = accountNoForSig.split("#");
					var iframe1 = document.getElementById("frmData");
					var iframeDocument1 = (iframe1.contentDocument) ? iframe1.contentDocument : iframe1.contentWindow.document;
					//Add below code for adding values in dropdown from integration call
					var selects1 = iframeDocument1.getElementsByTagName("select");
					try 
					{
						for (x = 0; x < selects1.length; x++) 
						{
							eleName2 = selects1[x].getAttribute("name");
							if (eleName2 == null)
								continue;
							eleName2 += "#select";
							myname = selects1[x].getAttribute("id");
							if (myname == null)
								continue;
							else if(myname.indexOf("TransAccNoForDebit")!=-1)
							{
								//***********************************************************************************************
								iframeDocument1.getElementById(myname).options.length=0;//To clear the dropdown before add records.
								var optSelect = document.createElement("option");
								optSelect.text = '--Select--';
								optSelect.value ='--Select--';
								iframeDocument1.getElementById(myname).disabled = false;
								iframeDocument1.getElementById(myname).options.add(optSelect);
								for(var i=0;i<arrayaccountnosig.length;i++)
								{
									var opt = document.createElement("option");
									opt.text = arrayaccountnosig[i];
									opt.value =arrayaccountnosig[i];
									iframeDocument1.getElementById(myname).options.add(opt);
								}
								break;
							}	
						}
					}
					catch(err)
					{
						return "exception";
					}
					//*****************
					
					document.getElementById("AccountnoDetails").value=arrayAjaxResult[2]; 
					var arrayAccountNo=accountNo.split("#");
					var iframe = document.getElementById("frmData");
					var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
					//Add below code for adding values in dropdown from integration call
					var NameData='';
					var selects = iframeDocument.getElementsByTagName("select");
					var inputs = iframeDocument.getElementsByTagName("input");
					try 
					{
						for (x = 0; x < selects.length; x++) 
						{
							eleName2 = selects[x].getAttribute("name");
							if (eleName2 == null)
								continue;
							eleName2 += "#select";
							myname = selects[x].getAttribute("id");
							if (myname == null)
								continue;
							else if(myname.indexOf("AgreementNumber")!=-1)//AgreementNumber for LoanServices routecategory aaded by siva 01052018
							{
								//***********************************************************************************************
								iframeDocument.getElementById(myname).options.length=0;//To clear the dropdown before add records.
								var optSelect = document.createElement("option");
								optSelect.text = '--Select--';
								optSelect.value ='--Select--';
								iframeDocument.getElementById(myname).disabled = false;
								iframeDocument.getElementById(myname).options.add(optSelect);
								for(var i=0;i<arrayAccountNo.length;i++)
								{
									var opt = document.createElement("option");
									opt.text = arrayAccountNo[i];
									opt.value =arrayAccountNo[i];
									iframeDocument.getElementById(myname).options.add(opt);
								}
								break;
							}	
							else if(myname.indexOf("AccountNumber")!=0)
							{
								if(myname.indexOf("IslamicOrConventional")==-1)//Condition for ignoring this field under LoanServices routecategory added by siva 01052018
								{
									//***********************************************************************************************
									iframeDocument.getElementById(myname).options.length=0;//To clear the dropdown before add records.
									var optSelect = document.createElement("option");
									optSelect.text = '--Select--';
									optSelect.value ='--Select--';
									iframeDocument.getElementById(myname).disabled = false;
									iframeDocument.getElementById(myname).options.add(optSelect);
									for(var i=0;i<arrayAccountNo.length;i++)
									{
										var opt = document.createElement("option");
										opt.text = arrayAccountNo[i];
										opt.value =arrayAccountNo[i];
										iframeDocument.getElementById(myname).options.add(opt);
									}
									break;
								}
							}							
						}
						//added by shamily for view signature
						var accountNosign=arrayAjaxResult[3]; // Fetching Account Number to be shown on View Signature Page - 14082017
						var AccountnoSig=accountNosign+'@';  
						document.getElementById("wdesk:AccountnoSig").value = AccountnoSig.replaceAll1('#','@');
						AccountnoSig = document.getElementById("wdesk:AccountnoSig").value;
						document.getElementById("wdesk:AccountNo").value = document.getElementById("wdesk:AccountnoSig").value;
					} 
					catch (err) 
					{
						return "exception";
					}
					
					// calling function to default Transaction in suspense account for  Loan Services added on 27032018 by Angad
					if (document.getElementById("wdesk:ROUTECATEGORY").value == 'LoanServices')
					{
						var stats = defaultDynamicField('TransInSuspenseAccount');
					}
					//******************************************************
			} 
			else 
			{
				alert("Problem in Fetching AccountDetails.");
				return false;
			}
	}
	
	function getCardListDetails(selectedCifId, Number, CardType)
	{
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else if (window.ActiveXObject)
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var url = "GetCardList.jsp";
		
		var param = "CIFID=" + selectedCifId + "&Number="+Number+"&CardType="+CardType;

		xhr.open("POST", url, false);
		xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
		xhr.send(param);
		
		//alert("xhr.status "+xhr.status);
		
		if (xhr.status == 200 && xhr.readyState == 4) 
		{
			//alert("Response "+ajaxResult);
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
			return ajaxResult;
		} 
		else 
		{
			alert("Problem in getting card list.");
			return false;
		}
	}
	
	document.MyActiveWindows= new Array;

	function openWindow(sUrl,sName,sProps)
	{
		document.MyActiveWindows.push(window.open(sUrl,sName,sProps));
	}

	function closeAllWindows()
	{
		//alert("hi");
		for(var i = 0;i < document.MyActiveWindows.length; i++)
			document.MyActiveWindows[i].close();
	}
	function resizeIframe(obj) 
	{
		try{
		obj.style.height = obj.contentWindow.document.body.scrollHeight + 'px';
		//obj.style.height ='50px';
		}catch(err){}
	}
	function csufetch()
	{
		//alert("Inside CSU fetch");
		//alert("encrypted card number "+encryptedcardnumber);
		var fetchURL="/webdesktop/CustomForms/SRB_Specific/CBR_CSU_Fetch.jsp?cardnumber="+document.getElementById("wdesk:encryptedkeyid").value;
		fetchURL = replaceUrlChars(fetchURL);
		//window.open(fetchURL);
		var xhr;
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 xhr.open("GET",fetchURL,false); 
		 xhr.send(null);
		//alert(xhr.status);		
		if (xhr.status == 200 && xhr.readyState == 4)
		{
			var ajaxResult=xhr.responseText;
			//alert(ajaxResult);
			ajaxResult=myTrim(ajaxResult);
			
			var returnvars = ajaxResult.split("~");
			var cardstatus = returnvars[0];
			var cbEligibleAmt = returnvars[1];
			var mobileNo = returnvars[2];
			var exception = returnvars[3];
			if(exception == '111')
			{
				alert("There is some error during refreshing the data");
				return false;
			}
			var iframe = document.getElementById("frmData");
			var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
			
			iframeDocument.getElementById("1_CCI_CStatus").value=cardstatus;
			iframeDocument.getElementById("1_Cash_Back_Eligible_Amount").value=cbEligibleAmt;
			iframeDocument.getElementById("1_CCI_MONO").value=mobileNo;
			
		}
		else
		{
			alert("Problem in Fetching the data");
			return false;
		}
		document.getElementById("IsCSURefreshClicked").value="clicked";
		
	}
	//Group                       :           Application Projects
	//Project                     :           RAKBank eForms Phase-I 
	//Date Written                : 
	//Date Modified               : 
	//Author                      : 		  Amitabh Pandey
	//Description                 :           To show form on clicking on radio button

	//***********************************************************************************//
	function showDivForRadio(Object) 
	{
		var hashSepratedValues=Object.value.split("#");
		try
		{
			//Validation for if user tries to add account no for multiple CIF
            var headerCIF=document.getElementById("wdesk:CifId").value;
            var selectedRadioCIF=hashSepratedValues[0];
            var iframe = document.getElementById("frmData");
            var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
            var header=iframeDocument.getElementById("Header").value;
            var gridTable=header+"_GridTable";
            if (iframeDocument.getElementById(gridTable)) 
            {
                var tableRowCount=iframeDocument.getElementById(gridTable).rows.length;
                //alert(tableRowCount);
                if(headerCIF!='' && headerCIF!=selectedRadioCIF && tableRowCount!=1)
                {
                    alert("Accounts no(s) for CIF "+headerCIF+" are already added in the grid\n.You can add only one CIF's account no(s).Please delete the account no from grid.");
                  return false;
                }
            }            
            //*******************************************************************
			
			// Calling Entity Detail on Related CIF Radio Click added on 29052017
			var ResponseData = getEntityDetailsOnRadioClick(selectedRadioCIF);
			ResponseData=ResponseData.split("~");
			document.getElementById("wdesk:CifId").value=ResponseData[0];
			//alert("Inside fn after name"+ResponseData[1]);
			document.getElementById("wdesk:Name").value=ResponseData[1];
			//alert("Inside fn after name");
			document.getElementById("wdesk:SubSegment").value=ResponseData[2];
			document.getElementById("wdesk:ARMCode").value=ResponseData[3];
			document.getElementById("wdesk:RAKElite").value=ResponseData[4];	
			document.getElementById("wdesk:PrimaryEmailId").value=ResponseData[5];
			document.getElementById("wdesk:EmiratesIDHeader").value=ResponseData[6];
			document.getElementById("wdesk:EmratesIDExpDate").value=ResponseData[7];
			document.getElementById("wdesk:CIFTYPE").value=ResponseData[8];
			//alert(document.getElementById("wdesk:CIFTYPE").value);
			document.getElementById("wdesk:TLIDHeader").value=ResponseData[9];
			document.getElementById("wdesk:TLIDExpDate").value=ResponseData[10];
			document.getElementById("wdesk:ResidentCountry").value=ResponseData[11];
			//added by badri to save ECRN number
			document.getElementById("wdesk:ECRNumber").value=ResponseData[12];
			//alert("ARMCode ");
			var ws_name = '<%=WSNAME%>';
			
			//alert("ARMCode 2");
			//alert("ARMCode "+hashSepratedValues[3].length);
			//Calling fetch Account Details Call By Selected CIF id
			if(ws_name=='Introduction')
			{
				if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
				{
					disableDeliveryMode();
				}
				if(document.getElementById("wdesk:CifId").value!='')
				{
					// Start - IsRetailCust validation for Liability Certificate Request added on 20082017
					if (document.getElementById("wdesk:ServiceRequestCode").value == "SRB086" || document.getElementById("wdesk:ServiceRequestCode").value == "SRB087") // Liability Certificate Request - Corporate, No Liability Certificates - Corporate
					{
						if (document.getElementById("wdesk:CIFTYPE").value =="Individual")
						{
							alert("Retails CIF cannot be selected for this Service Request");
							return false;
						}
					} else if (document.getElementById("wdesk:ServiceRequestCode").value == "SRB018" || document.getElementById("wdesk:ServiceRequestCode").value == "SRB020") // Liability Certificate Request - Retail, No Liability Certificates - Retail
					{
						if (document.getElementById("wdesk:CIFTYPE").value == "Non-Individual")
						{
							alert("Corporate CIF cannot be selected for this Service Request");
							return false;
						}
					}
					
					//Added By Nikita for the two new Service request on 29032018 End
					if(document.getElementById("wdesk:ServiceRequestCode").value == "SRB135"
					|| document.getElementById("wdesk:ServiceRequestCode").value == "SRB136")
					{
						searchableservicerequest();//for calling searchable functionality for service request field
						setAutocompleteDataServiceRequest();
				
					}
					 
					 
					// End - IsRetailCust validation for Liability Certificate Request added on 20082017
				 //alert("ID "+document.getElementById("wdesk:CifId").value);
				 fetchAccountDetails(document.getElementById("wdesk:CifId").value);
				}
				else
				alert("CIF ID is mandatory for FetchAccount deatil call.");
			}		
		}
		catch(err)
		{
		    alert("Problem in populating details from entity detail call."+err.message);
		}
	}
	//This function will be called after record is already saved on CSO workstep and user are reloading data.
	function showDivForRadioAfterSaved() 
	{
		try
		{
			var ws_name = '<%=WSNAME%>';
			//alert('ws_name'+ws_name);
			if(ws_name=='Introduction')
			{
				if(document.getElementById("wdesk:CifId").value!='')
				{
					// Start - IsRetailCust validation for Liability Certificate Request added on 20082017
					if (document.getElementById("wdesk:ServiceRequestCode").value == "SRB086" || document.getElementById("wdesk:ServiceRequestCode").value == "SRB087") // Liability Certificate Request - Corporate, No Liability Certificates - Corporate
					{
						if (document.getElementById("wdesk:CIFTYPE").value =="Individual")
						{
							alert("Retails CIF cannot be selected for this Service Request");
							return false;
						}
					} else if (document.getElementById("wdesk:ServiceRequestCode").value == "SRB018" || document.getElementById("wdesk:ServiceRequestCode").value == "SRB020") // Liability Certificate Request - Retail, No Liability Certificates - Retail
					{
						if (document.getElementById("wdesk:CIFTYPE").value == "Non-Individual")
						{
							alert("Corporate CIF cannot be selected for this Service Request");
							return false;
						}
					}	
					// End - IsRetailCust validation for Liability Certificate Request added on 20082017
				 //alert("ID "+document.getElementById("wdesk:CifId").value);
				 fetchAccountDetails(document.getElementById("wdesk:CifId").value);
				}
				else
				alert("CIF ID is mandatory for FetchAccount deatil call.");
			}		
		}
		catch(err)
		{
		    alert("Problem in populating details from entity detail call."+err.message);
		}
	}
	//added by shamily for SRB 21 service requests CR start
	
	function onBlurForAmount(Object)
	{
		var numbers = /^\d+(\.\d{0,2})?$/;
		if(Object.value!='')
		{
			if(!Object.value.match(numbers)) 
			{
			 alert("Please enter a valid amount");
			 Object.value='';
			 Object.focus();
			 return false;
			}
			//for Service Request SRB074 - Request to transfer the excess balance/issuance of mangers cheque
			if (document.getElementById("wdesk:ServiceRequestCode").value == "SRB074")
			{
				if (Object.value < 100)
				{
					 alert("Please enter a valid amount, Amount should not be less than 100");
					 Object.value='';
					 Object.focus();
					 return false;
				}
			}
			
			var CommaSeparated = Number(parseFloat(Object.value).toFixed(2)).toLocaleString('en', {
			minimumFractionDigits: 2});
			Object.value=CommaSeparated;
		}		
	}
	
	// below function added only for Service Request - Request to transfer the excess balance/issuance of mangers cheque
	function onBlurForAmountlessthan(Object)
	{
		var numbers = /^\d{3,}$/; 
		if(Object.value!='')
		{
			if(!Object.value.match(numbers)) 
			{
			 alert("Please enter a valid amount.Amount should not be less than 100");
			 Object.value='';
			 Object.focus();
			 return false;
			}
			/*var CommaSeparated = Number(parseFloat(Object.value).toFixed(2)).toLocaleString('en', {
			minimumFractionDigits: 2});
			Object.value=CommaSeparated;*/
		}		
	}
	//Added by badri to validate card number for prepaid card services
	function onBlurForcardnumber(Object)
	{
		//var numbers = /^[0-9]+$/; 
		//^\d+(\.\d{0,2})?$/
		var numbers = /^\d{16}$/; 
		if(Object.value!='')
		{
			if(!Object.value.match(numbers)) 
			{
			 alert("Card Number Should be 16 digits");
			 Object.value='';
			 Object.focus();
			 return false;
			}
		}		
	}
	
	function onBlurForaccountnumber(Object)
	{
		
		var numbers = /^\d+$/;
		
		
		if(Object.value!='')
		{
			
			if(!(Object.value.match(numbers) && Object.value.substring(0,1) == '0'))
			{ 
				//alert('Please enter valid account number starting from 0');
				 Object.value='';
				 Object.focus();
				return false; 
			}
	
		}		
	}
	//added by shamily for SRB 21 service requests CR end
	
	function ValidateOnlyNumbers(Object)
	{
		var numbers = /^\d+$/;
		if(Object.value!='')
		{
			if(!Object.value.match(numbers))
			{ 
				alert('Please enter valid Number');
				 Object.value='';
				 Object.focus();
				return false; 
			}
		}		
	}
	
	//Added by badri to validate card pack ID for prepaid card services
	function onBlurForcardpackID(Object)
	{
		
		//var numbers = /^\d{14}$/;
		var numbers =/^[a-zA-Z]{3}[0-9]{11}$/;
		
		
		if(Object.value!='')
		{
			
			if(!(Object.value.match(numbers)))
			{ 
				alert('Please enter valid Card Pack ID');
				 Object.value='';
				 Object.focus();
				return false; 
			}
	
		}		
	}
	
	function onChangeFromToDate(Object)
	{
		if(Object.value!='')
		var day = Object.value.substring(0,2);
		//alert(day);
		var month = Object.value.substring(3,5);
		//alert(month);
		var year = Object.value.substring(6,12);
		//alert(year);
		var date = month+'/'+day+'/'+year;
		Object.value = date;
		//alert(Object.value);
	
	}
	function pupulateAccDts(Object)
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		//Add below code for adding values in textbox from integration call
		var NameData='';
		var inputs = iframeDocument.getElementsByTagName("input");
		var AccountnoDetails = document.getElementById("AccountnoDetails").value;
		var AccNoSelected = Object.value;
		try 
			{
				for (x = 0; x < inputs.length; x++) 
				{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if((myname.indexOf("AccountName")!=-1) && !(myname.indexOf("grid")!=-1))
						{
						
							arrayAccountDetails=AccountnoDetails.split("`");
							for(var i=0;i<arrayAccountDetails.length;i++)
							{
								var arrayAccountDetailscount = arrayAccountDetails[i];
								var arrayaccount=arrayAccountDetailscount.split("|");
								if(Object.value==arrayaccount[0])
								{
									iframeDocument.getElementById(myname).value=arrayaccount[2];
								}	
									//var arrayaccountname=arrayaccount[2];
								
							} 
							//iframeDocument.getElementById(myname).value=document.getElementById("accountName").value;
							
							if (AccNoSelected == "--Select--" || AccNoSelected == "")
								iframeDocument.getElementById(myname).value = "";
							continue;
						}
						if(myname.indexOf("AccountType")!=-1 && !(myname.indexOf("grid")!=-1))
						{
							arrayAccountDetails=AccountnoDetails.split("`");
							for(var i=0;i<arrayAccountDetails.length;i++)
							{
								var arrayAccountDetailscount = arrayAccountDetails[i];
								var arrayaccount=arrayAccountDetailscount.split("|");
								if(Object.value==arrayaccount[0])
								{
									iframeDocument.getElementById(myname).value=arrayaccount[1];
								}	//iframeDocument.getElementById(myname).value=document.getElementById("accountType").value;
								
							}
							if (AccNoSelected == "--Select--" || AccNoSelected == "")
								iframeDocument.getElementById(myname).value = "";
							continue;
						}		
				}
			} 
			catch (err) 
			{
				return "exception";
			}  
	}
	
	function populateservicerequest()
	{	
		var code = document.getElementById('wdesk:ServiceRequestCode').value;
		if(code=='SRB135')
		{
			validateservice('135_ServiceRequestType',document.getElementById('AutocompleteValuesServiceRequest').value);
		
		}
		else if(code=='SRB136')
		{
		    validateservice('136_ServiceRequestType',document.getElementById('AutocompleteValuesServiceRequest').value);
		}
		getwiname();
	}
	
	
	function islamic()
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		document.getElementById("SubCategoryID").value=SubCategoryID;
		var id = SubCategoryID+"_IslamicOrConventional";
		document.getElementById("islamic_conventional").value=window.parent.frames['customform'].frmData.document.getElementById(id).value;
			if(window.parent.frames['customform'].frmData.document.getElementById(id).value!=document.getElementById("wdesk:IslamicConvention").value)
			{
				if(document.getElementById('selectDecision').value !="Islamic / Conventional category changed")
				{
					alert("Please select 'Islamic / Conventional category changed' as decision if the value is modified");
				
				}
			}
	}	
	function setCurrency()
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		var id=SubCategoryID+"_TransInSuspenseAccount";
		var transInSus=iframeDocument.getElementById(id).value;
		document.getElementById("isTransInSusAccount").value=transInSus;
		var currId=SubCategoryID+"_Currency";
		if(transInSus=="Yes")
		{
			iframeDocument.getElementById(currId).value="AED";
			document.getElementById("currencySelected").value="AED";
		}
	}
	function getCurrency()
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		var currId=SubCategoryID+"_Currency";
		var currencySelected=iframeDocument.getElementById(currId).value;
		document.getElementById("currencySelected").value=currencySelected;
		//alert("Currency value in hidden field");
	}
	
	//Added by Nikita for saving the islamic field value at CSO Ws for the onchange of the field
	function islamicval()
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var SubCategoryID = iframeDocument.getElementById("SubCategoryID").value;
		var id=SubCategoryID+"_IslamicOrConventional";
		var islamic = iframeDocument.getElementById(id).value;
		document.getElementById("wdesk:IslamicConvention").value  = islamic;	
	}
	
	//change by badri to show CRN number as nickname
	function pupulateAccDtsforcards(Object)
	{
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		//Add below code for adding values in textbox from integration call
		var NameData='';
		var inputs = iframeDocument.getElementsByTagName("input");
		var AccountnoDetails = document.getElementById("AccountnoDetails").value;
		var AccNoSelected = Object.value;
		try 
			{
				for (x = 0; x < inputs.length; x++) 
				{
						myname = inputs[x].getAttribute("id");
						if (myname == null||myname == '')
						continue;
						if((myname.indexOf("CustomerRelationshipNumber")!=-1) && !(myname.indexOf("grid")!=-1))
						{
						
							arrayAccountDetails=AccountnoDetails.split("`");
							for(var i=0;i<arrayAccountDetails.length;i++)
							{
								var arrayAccountDetailscount = arrayAccountDetails[i];
								var arrayaccount=arrayAccountDetailscount.split("|");
								if(Object.value==arrayaccount[0])
								{
									iframeDocument.getElementById(myname).value=arrayaccount[2];
								}	
									
							} 
							
							if (AccNoSelected == "--Select--" || AccNoSelected == "")
								iframeDocument.getElementById(myname).value = "";
							continue;
						}		
				  }
			} 
			catch (err) 
			{
				return "exception";
			}  
	}
	
	function onChangeFromToDate(Object)
	{
		if(Object.value!='')
		var day = Object.value.substring(0,2);
		//alert(day);
		var month = Object.value.substring(3,5);
		//alert(month);
		var year = Object.value.substring(6,12);
		//alert(year);
		var date = month+'/'+day+'/'+year;
		Object.value = date;
		//alert(Object.value);
	
	}
		
	function ValidateNumericForCommonJsp(Object)
	{
		if(Object.value=='')
		return;
		var numbers = /^[0-9]+$/; 
		if(Object.value.match(numbers)) 
		return true; 
		else 
		{ 
			alert('Please input numeric characters only.');
			Object.value="";
			Object.focus();
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
//Description                 :           Function added to get cut off time
//***********************************************************************************//
		function sendSMS() {
			var wi_name = '<%=WINAME%>';
			var wsname ='<%=WSNAME%>';
			var decision = document.getElementById("wdesk:Decision").value;
			var processname ='SRB';
			
			var xhr;
			var ajaxResult;
			ajaxResult = "";
			var reqType = "SendSMS";

			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = '/SRB/CustomForms/SRB_Specific/HandleAjaxProcedures.jsp?wi_name='+wi_name+"&reqType="+reqType+"&wsname="+ wsname+"&decision="+decision+"&processname="+processname;

			xhr.open("GET", url, false);
			xhr.send(null);

			if (xhr.status == 200) {
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

				if (ajaxResult.indexOf("Exception") == 0) {
					alert("Some problem in sending SMS.");
					return false;
				}
				//ajaxResult=ajaxResult.replaceall('-','/');
			} else {
				alert("Error while sending SMS");
				return "";
			}
			
		}
		
		
	//**********************************************************************************//

	//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

	//Group                       :           Application Projects
	//Project                     :           RAKBank eForms Phase-I 
	//Date Written                : 
	//Date Modified               : 
	//Author                      :           Amitabh Pandey
	//Description                 :           Below method is used for get data from Entity Detail call

	//***********************************************************************************//
	function getEntityDetails() 
	{
			
			var CIF_ID="";
			var SavedCIF = document.getElementById("wdesk:CifId").value;
			if(SavedCIF!='')
			CIF_ID=SavedCIF;
			else
			CIF_ID = document.getElementById("Cifnumber").value;
			
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("EmiratesID").value;
			var wi_name = '<%=WINAME%>';
			
			
			var flag=validate('cardno');
			if(!flag)
			return false;
			
			//Getting expiry parameters from database			
			if(!getExpiryTime())
			return false;
			//*******************************************
			
			var xmlDoc;
			var x;
			var xLen;
			var request_type = "ENTITY_DETAILS";
			var mobile_number = ""; //document.getElementById("wdesk:mob_phone_exis").value;
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

			var url = "SRBIntegration.jsp";

			var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;

			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
		

			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				
				if (ajaxResult.indexOf("Exception") == 0) 
				{
					alert("Please enter an valid Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No.");
					/*document.getElementById("Fetch").disabled = false;
					document.getElementById("wdesk:CIFNumber_Existing").disabled = false;
					document.getElementById("wdesk:account_number").disabled = false;
					document.getElementById("wdesk:loan_agreement_id").disabled = false;
					document.getElementById("wdesk:card_number").disabled = false;
					document.getElementById("wdesk:emirates_id").disabled = false;*/

					return false;
				}
					ajaxResult = ajaxResult.split("^^^");
					document.getElementById("mainEmiratesId").innerHTML = ajaxResult[0];
					//After fetching data from entity details calls disabling all search fields
					document.getElementById("dispatchDtl").style.display ="block";
					document.getElementById("EmiratesID").disabled=true;
					document.getElementById("accountNo").disabled=true;
					document.getElementById("loanaggno").disabled=true;
					document.getElementById("Cifnumber").disabled=true;
					document.getElementById("SubCategory_search").disabled=true;
			} 
			else 
			{
				alert("Problem in getting Entity Details.");
				return false;
			}
			
			//Added by amitabh for searchable text CR
			
	}
	
	//Function Added by Nikita for the two new service request for SRB CR points start
	function getwiname()
	{
		var selectedRadioCIF =document.getElementById("selectedcifid").value;
		var code = document.getElementById("wdesk:ServiceRequestCode").value;
		var text='';
		var servicereqselected = "";
		if(code == 'SRB135'){
			servicereqselected = window.parent.frames['customform'].frmData.document.getElementById('135_ServiceRequestType').value;
		}
		if(code == 'SRB136'){
			servicereqselected = window.parent.frames['customform'].frmData.document.getElementById('136_ServiceRequestType').value;
		}
		var subcategory = document.getElementById("wdesk:SubCategory").value;
		//alert("subcategory----------nikita-------"+subcategory);
		
		if(subcategory == 'Returned Courier / Post' || subcategory =='Retrieve Archived Document')
		{
		
			if(servicereqselected!='' && servicereqselected!= null)
			{
				//for the dynamic field value
				var xhr1;
				var ajaxResult;
				ajaxResult = "";
				var reqType = "Load_Dynamicfieldwi";

				if (window.XMLHttpRequest)
					xhr1 = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr1 = new ActiveXObject("Microsoft.XMLHTTP");
				var url = '/SRB/CustomForms/SRB_Specific/PrintWindow.jsp?subCategory='+servicereqselected+ "&cifid="+selectedRadioCIF+ "&reqType="+reqType;
				//alert("url"+url);

				xhr1.open("POST", url, false);
				xhr1.send();

				if (xhr1.status == 200) 
				{
					ajaxResult = xhr1.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
					
					if (ajaxResult.indexOf("Exception") == 0) {
						alert("Some problem in Loading conditional workitem number");
						return false;
					}
			
					ajaxResult = ajaxResult.split("~");
					var iframe = document.getElementById("frmData");
					var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
					//Add below code for adding values in dropdown from integration call
					var NameData='';
					var selects = iframeDocument.getElementsByTagName("select");
				
					for (x = 0; x < selects.length; x++) 
					{
						eleName2 = selects[x].getAttribute("name");
						if (eleName2 == null)
							continue;
						eleName2 += "#select";
						myname = selects[x].getAttribute("id");
						if (myname == null)
							continue;
						else if(myname.indexOf("WorkItemNumber")!=0)
						{
							//***********************************************************************************************
							iframeDocument.getElementById(myname).options.length=0;//To clear the dropdown before add records.
							var optSelect = document.createElement("option");
							optSelect.text = '--Select--';
							optSelect.value ='--Select--';
							iframeDocument.getElementById(myname).disabled = false;
							iframeDocument.getElementById(myname).options.add(optSelect);
							for(var i=0;i<ajaxResult.length;i++)
							{
								var opt = document.createElement("option");
								opt.text =ajaxResult [i];
								opt.value =ajaxResult [i];
								iframeDocument.getElementById(myname).options.add(opt);
							}
						}	
					}
				} 
				else {
					alert("Error while Loading Dynamic field value");
				}
			}
		}
	}
	//Added By Nikita for the SRB CR points End
	
	function LoadModeOfDelivery()
	{
		//Added By Nikita for autopopulating mode of delivery value based on the service request type selected
			var subcategory = document.getElementById("wdesk:SubCategory").value;
			//alert("subcategory--  "+subcategory);
			var WSNAME='<%=WSNAME%>';
			var xhr1;
			var ajaxResult;
			ajaxResult = "";
			var reqType = "Load_ModeOfDelivery";

			if (window.XMLHttpRequest)
				xhr1 = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr1 = new ActiveXObject("Microsoft.XMLHTTP");

			var url = '/SRB/CustomForms/SRB_Specific/PrintWindow.jsp?subCategory='+subcategory+ "&reqType="+reqType;
			//alert("url"+url);

			xhr1.open("POST", url, false);
			xhr1.send();

			if (xhr1.status == 200) {
				ajaxResult = xhr1.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				//alert("ajaxResult---"+ajaxResult);

				if (ajaxResult.indexOf("Exception") == 0) {
					alert("Some problem in Loading Mode Of Delivery Values");
					return false;
				}
				//Clear the ModeOfDelivery Field
				document.getElementById("modeofdelivery").innerText="";
				//Adding values to ModeOfDelivery Field
				var values = ajaxResult.split("~");				
				for(var j=0;j<values.length;j++)
				 {
					 if(values[j]!='')
					 {
						 var opt = document.createElement("option");
						 opt.text = values[j];
						 opt.value =values[j];
						 // Selecting courier by default for below services added on 27/09/2020
						 if(WSNAME=='Introduction')
						 {
							 if(document.getElementById("wdesk:ServiceRequestCode").value == 'SRB053' || document.getElementById("wdesk:ServiceRequestCode").value == 'SRB055')
							 {
								if(values[j] == 'Courier')
								opt.selected="selected";
								document.getElementById("wdesk:CourierAWBNumber").disabled=false;
								document.getElementById("wdesk:CourierCompName").disabled=false;
							 } else {
								document.getElementById("wdesk:CourierAWBNumber").disabled=true;
								document.getElementById("wdesk:CourierCompName").disabled=true;
							 }
						 }
						 //////////////////////////////////
						 document.getElementById("modeofdelivery").options.add(opt);
					 }
				 }
					 var e = document.getElementById("modeofdelivery");
					//var strUser = e.options[e.selectedIndex].value;	
					//alert("mode of delivery value"+ strUser);	
				//ajaxResult=ajaxResult.replaceall('-','/');
				return true;
			} else {
				alert("Error while Loading Mode Of Delivery Values");
				//return "";
			}
	}
	
	function disableDeliveryMode()
	{
		var ws_name = '<%=WSNAME%>';
		if (ws_name == 'Introduction')
		{
			var x = document.getElementById("modeofdelivery");
			for (var i = 0; i < x.options.length; i++) 
			{
				if(x.options[i].value=='Courier to Office Address')
				{
					if (document.getElementById("wdesk:CIFTYPE").value =='Individual' || document.getElementById("wdesk:CIFTYPE").value =='') 
						x.options[i].disabled = true;
					else 	
						x.options[i].disabled = false;
				}
				/*if(x.options[i].value=='Courier') // Disabling courier option permanantly added on 27/01/2020 added by Angad
				{
					x.options[i].disabled = true;
				}*/
			}
		}
	}
	
	function getEntityDetailsOnRadioClick(selectedRadioCIF) 
	{
			
			var CIF_ID=selectedRadioCIF;
			document.getElementById("selectedcifid").value =selectedRadioCIF; //Added By Nikita on 11042018			
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("EmiratesID").value;
			var wi_name = '<%=WINAME%>';
			
			var xmlDoc;
			var x;
			var xLen;
			var request_type = "ENTITY_DETAILS_RADIOCLICK";
			var mobile_number = ""; //document.getElementById("wdesk:mob_phone_exis").value;
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

			var url = "SRBIntegration.jsp";

			var param = "request_type=" + request_type + "&Account_Number=" + account_number + "&mobile_number=" + mobile_number + "&Emirates_Id=" + emirates_id + "&account_type=" + account_type + "&CIF_ID=" + CIF_ID + "&user_name=" + user_name+ "&wi_name=" + wi_name;

			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
		

			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				
				if (ajaxResult.indexOf("Exception") == 0) 
				{
					alert("Please enter an valid Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No.");
					return false;
				}
					return ajaxResult;
			} 
			else 
			{
				alert("Problem in getting Entity Details on radio click.");
				return false;
			}
	}
	
	function loadAllHiddenParamForServiceRequest()
	{
			var xhr;
			var param = "";
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");
			var ServiceRequestType=document.getElementById("SubCategory").value;
			param = "ServiceRequest="+ServiceRequestType;
			try
			{
					var url = "GetAllHiddenParamsForRequest.jsp";
					xhr.open("POST", url, false);
					xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
					xhr.send(param);
					if (xhr.status == 200 && xhr.readyState == 4) 
					{
						ajaxResult = xhr.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
						//alert("ajaxResult"+ajaxResult);
						//alert("ajaxResult indexOf"+ajaxResult.indexOf("0"));
						var arrayAjaxResult=ajaxResult.split("#");
						
						if (arrayAjaxResult[0]!="0") 
						{
							alert("Problem in reading service request parameters.");
							return false;
						}
						else
						{
								var parameters=arrayAjaxResult[1];
								var arrayParameters=parameters.split("~");
								document.getElementById("DubplicateWorkitemVisible").value=arrayParameters[0];
								document.getElementById("wdesk:printDispatchRequired").value=arrayParameters[1];
								document.getElementById("wdesk:CSMApprovalRequire").value=arrayParameters[2];
								document.getElementById("wdesk:CardSettlementProcessingRequired").value=arrayParameters[3];
								document.getElementById("wdesk:OriginalRequiredatOperations").value=arrayParameters[4];
								document.getElementById("DuplicateCheckLogic").value=arrayParameters[5];
								document.getElementById("AccountIndicator").value=arrayParameters[6];
								document.getElementById("FetchClosedAcct").value=arrayParameters[7];
								document.getElementById("wdesk:OriginalRequiredbyOPSforProcessing").value=arrayParameters[8];
								var archivalPathInMaster=arrayParameters[9];
								document.getElementById("wdesk:isSMSMailToBeSend").value=arrayParameters[10];
								document.getElementById("AccToBeFetched").value=arrayParameters[11];
								document.getElementById("wdesk:ServiceRequestCode").value=arrayParameters[12];
								document.getElementById("isEMIDExpiryChkReq").value=arrayParameters[13];
								document.getElementById("wdesk:MANDATE_NONMANDATE").value=arrayParameters[14];
								document.getElementById("wdesk:ROUTECATEGORY").value=arrayParameters[15];
								document.getElementById("wdesk:StaleDateRestrictionDays").value=arrayParameters[16];
								document.getElementById("wdesk:isMultipleApprovalReq").value=arrayParameters[17];
								
								if(document.getElementById("wdesk:printDispatchRequired").value=='Y')
								document.getElementById("dispatchHeader").style.display="block";
								
								if(archivalPathInMaster=='path1')
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\CentralOperation\\&<CifId>&\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\CentralOperation\\&<CifId>&\\Rejected\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
								}
								else if(archivalPathInMaster=='path2')
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\FinancialFolder\\&<CifId>&\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\FinancialFolder\\&<CifId>&\\Rejected\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
								}
								else if(archivalPathInMaster=='path3')
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\FinancialFolder\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\FinancialFolder\\Rejected\\&<SubCategory>&\\&<WI_NAME>&';
									<!--CR23082017-->
								}
								else if(archivalPathInMaster=='path4') // Archival Path added for Cards Services on 11012017
								{
									document.getElementById("wdesk:ARCHIVALPATH").value='Omnidocs\\CreditCards\\CardService\\&<WI_NAME>&';
									
									document.getElementById("wdesk:ARCHIVALPATHREJECT").value='Omnidocs\\CreditCards\\CardService\\Rejected\\&<WI_NAME>&';
									
								}
								else if(archivalPathInMaster=='path5') // Archival Path added for Loan Services 
								{
									// this path configured for LoanServices- getting calculated on introduce 
								}
								else
								{
								 alert("Archival path is not configured in master.");
								 return false;
								}
								
								return true;
						}
					} 
					else 
					{
						alert("Exception in reading service request parameters from jsp.");
						return false;
					}
			}
			catch(e)
			{
				alert("Exception in reading service request parameters.");
				return false;
			}
	}
	function getExpiryTime()
	{
			var xhr;
			var param = "";
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");
			var ServiceRequestType=document.getElementById("SubCategory").value;
			param = "ServiceRequest="+ServiceRequestType;
			try
			{
					var url = "GetExpiryTimeFromMaster.jsp";
					xhr.open("POST", url, false);
					xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
					xhr.send(param);
					if (xhr.status == 200 && xhr.readyState == 4) 
					{
						ajaxResult = xhr.responseText;
						ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
						//alert("ajaxResult"+ajaxResult);
						//alert("ajaxResult indexOf"+ajaxResult.indexOf("0"));
						var arrayAjaxResult=ajaxResult.split("#");
						
						if (arrayAjaxResult[0]=="-1") 
						{
							alert("Problem in reading service request parameters.");
							return false;
						}
						else if(arrayAjaxResult[0]=="00")
						{
						  //no record found..
						  return true;
						}
						else
						{
								var parameters=arrayAjaxResult[1];
								var arrayParameters=parameters.split("~");
								document.getElementById("wdesk:UndeliveredDocExpiryForBranch").value=arrayParameters[0];
								document.getElementById("wdesk:RectificationPendingExpiryForBanch").value=arrayParameters[1];
								document.getElementById("wdesk:DiscrepantPhyDocRejByArchivalExpiry").value=arrayParameters[2];
								document.getElementById("wdesk:ProcessedPhyDocPenToBeSentToArchivalExpiry").value=arrayParameters[3];
								return true;
						}
					} 
					else 
					{
						alert("Exception in reading service request parameters from jsp.");
						return false;
					}
			}
			catch(e)
			{
				alert("Exception in reading service request parameters.");
				return false;
			}
	}
	function callEIDA() 
	{
				//document.getElementById("emiratesid").value="784-1968-6570305-0";
				//Below to be uncommented on UAT server
				Initialize();
				DisplayPublicDataEx();
				document.getElementById("EmiratesID").value = fetchEID();
	}
	function attachTemplateCustom(fileString,listData)
	{
		
	}

// this function is added to Default any value for anyone of Dynamic Field added on 27032018 by Angad
function defaultDynamicField(dynamicFieldName)
{
	var iframe1 = document.getElementById("frmData");
	var iframeDocument1 = (iframe1.contentDocument) ? iframe1.contentDocument : iframe1.contentWindow.document;
	var selects1 = iframeDocument1.getElementsByTagName("select");
	try 
	{
		for (x = 0; x < selects1.length; x++) 
		{
			eleName2 = selects1[x].getAttribute("name");
			if (eleName2 == null)
				continue;
			eleName2 += "#select";
			myname = selects1[x].getAttribute("id");
			if (myname == null)
				continue;
			else if(myname.indexOf(dynamicFieldName)!=-1)
			{
				if (iframeDocument1.getElementById(myname).value == '' || iframeDocument1.getElementById(myname).value == '--Select--')
				{
					iframeDocument1.getElementById(myname).value = 'No';
				}
				break;
			}	
		}
	}
	catch(err)
	{
		return "exception";
	}
}
//****************************************
	
function myTrim(x) 
{
    return x.replace(/^\s+|\s+$/gm,'');
}
	$(function() {	if(window.parent.wiproperty.locked =="Y")			
				$( ".NGReadOnlyView" ).prop('disabled', true);
		});
	
	window.onunload = function(){closeAllWindows()};

		//Function added by Nikita for searchable Dynamic field corresponding to the 2 new service request
function searchableservicerequest()
	{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
			url = '/SRB/CustomForms/SRB_Specific/DropDownServiceRequest.jsp';
			xhr.open("GET",url,false);
			xhr.send(null);
			if (xhr.status == 200)
			{	
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult.indexOf("Exception")==0)
				 {
					alert("Unknown Exception while working with request type "+reqType);
					return false;
				 }							 
				document.getElementById("AutocompleteValuesServiceRequest").value=ajaxResult;
			}
			else 
			{
				alert("Error while Loading Drowdown "+reqType+" for the current workstep");
				return false;
			}
    }
	
	// Function added by Nikita for Dynamic field corresponding to the 2 new service request.
	function validateservice(req,servicevalidate)
	{
		//servicevalidate = servicevalidate.replaceAll1(", ", ",");
			servicevalidate=servicevalidate.split("~");
		//alert("servicevalidate"+servicevalidate);
			var match ='';
			window.parent.frames['customform'].frmData.document.getElementById(req).value = myTrim(window.parent.frames['customform'].frmData.document.getElementById(req).value);
			for(var i=0;i<servicevalidate.length;i++)
			{
			//alert("nikita---"+iframeDocument.getElementById(myname).value);
			if(window.parent.frames['customform'].frmData.document.getElementById(req).value==servicevalidate[i]);
			match='matched';
			} 
			if(match !='matched')
			{
				window.parent.frames['customform'].frmData.document.getElementById(req).value="";
				return false;
			}	
		
	}
	
	//Function Added By Nikita for 2 new Service Request on 28032018
function openwi()
{
	//setAutocompleteDataServiceRequest();
	var session= '<%=customSession.getDMSSessionId()%>';
	var username= '<%=customSession.getUserName()%>';
	var cabinetname ='<%=customSession.getEngineName()%>';
	var code = document.getElementById("wdesk:ServiceRequestCode").value;
	var text='';
	if(code == 'SRB135'){
	var wiselected = window.parent.frames['customform'].frmData.document.getElementById('135_WorkItemNumber').value;
	}
	if(code == 'SRB136')
	{
	var wiselected = window.parent.frames['customform'].frmData.document.getElementById('136_WorkItemNumber').value;
	}
   
    
    window.open("https://omnidocssrmtst.rakbanktst.ae/webdesktop/login/Controller.jsp?ProcessInstanceId="+wiselected+"&WorkitemId=1&SessionId="+session+"&UserIndex=1&UserName="+username+"&EngineName="+cabinetname, "_blank", "toolbar=yes, scrollbars=yes, resizable=yes, top=300, left=500, width=400, height=400");
  
}
//below code added for part of CR 20102018
function CheckApprovalReq(Object)
{
	var MultipleApprovalCount = document.getElementById("wdesk:MultipleApprovalCount").value;
	if(Object.value != '')
	{
		if(parseInt(MultipleApprovalCount) != 0 && Object.value <= parseInt(MultipleApprovalCount))
		{		
			alert('No Of Approval Required cannot be reduced as current iteration is '+(parseInt(MultipleApprovalCount)+1));
			 Object.value= parseInt(MultipleApprovalCount)+1;
			 Object.focus();
			return false; 
		}		
	}
}	
	
</script>      
<%
			 
	String Query="";
	String inputData="";
	String outputData="";
	String maincode="";
	String FlagValue="";
	String TEMPWINAME = "";
	String logicalWsName="";
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlResponse objWFCustomXmlResponse=null;
	WFCustomXmlList objWorkList=null;	
	String subXML="";
	//String subcategory="";
	String channel="";
	int counter=0;
	WFCustomXmlResponse xmlParserDatacountry=null;
	String Querycountry="";
	String inputXMLcountry="";
	String outputXMLcountry="";
	String mainCodeValuecountry="";
	int recordcountcountry=0;
	String itemscountry="";
	String params = "";
	ViewMode="W";//wdmodel.getViewMode();
	
	WriteLog("WINAME-->"+WINAME);
	String EmidExpirydate_param = "";
	WriteLog("WINAME-->"+WINAME);
	String query1 = "Select CONST_FIELD_VALUE from USR_0_BPM_CONSTANTS where CONST_FIELD_NAME =:CONST_FIELD_NAME";
	params = "CONST_FIELD_NAME==SRB_Emid_Expiry_dateParameter";
	
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";		
	
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString(outputData);
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	
	if(maincode.equals("0"))
	{	EmidExpirydate_param = WFCustomXmlResponseData.getVal("CONST_FIELD_VALUE");
	
	}
	WriteLog("EmidExpirydate_param--"+EmidExpirydate_param);
	
	CustomWorkdeskAttribute tempWIAttrib=((CustomWorkdeskAttribute)attributeMap.get("TEMP_WI_NAME"));
	String tempWIName=tempWIAttrib==null?"":tempWIAttrib.getAttribValue()==null?"":tempWIAttrib.getAttribValue().toString();
	
	Query="select count(*) as count from RB_SRB_EXTTABLE where WI_NAME=:WI_NAME";
	params = "WI_NAME=="+WINAME;
	WriteLog("Query SRB-->"+Query);
				
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";		
	//WriteLog("test inputData--"+inputData);
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("External Table Count Output-->"+outputData);
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString(outputData);
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	
	if(maincode.equals("0"))
	{	counter = Integer.parseInt(WFCustomXmlResponseData.getVal("count"));
		if(counter!=0)
		FlagValue ="Y";
		WriteLog("FlagValue"+FlagValue);		
	}
%>
<% if(WSNAME.equals("Introduction")&&!FlagValue.equals("Y"))
{
%>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "window.parent.checkIsFormLoaded();setFrameSize();formLoad();setAutocompleteData();" onkeydown="whichButton('onkeydown',event)">
<%
}
else
{
WriteLog("Inside Else ");
%>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="window.parent.checkIsFormLoaded();setFrameSize();CallJSP('<%=WSNAME%>', '<%=FlagValue%>','<%=ViewMode%>');" onkeydown="whichButton('onkeydown',event);" >
<%
}
%>


<applet name="PublicDataWebComponent" id="PublicDataWebComponent" CODE="emiratesid.jio.webcomponents.PublicDataReader" archive="PublicDataApplet-Sagem.jar" width="0" height="0">
	<param name="EncryptParameters" value="false"/>
	<param name="RelativeCertPath" value="certs"/>

</applet>

<!--<applet name="EIDAWebComponent" id="EIDAWebComponent" CODE="emiratesid.ae.webcomponents.EIDAApplet" archive="EIDA_IDCard_Applet.jar" width="0" height="0"></applet> -->

<form name="wdesk" id="wdesk" method="post" visibility="hidden" >
<table border='1' id = "TAB_SRB" cellspacing='1' cellpadding='0' width=100% >
<tr  id = "SRB_Header" width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=center class='EWLabelRB2'><b>Service Request Module </b></td>
</tr>
<tr>
<td nowrap='nowrap' id='loggedinuserHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;&nbsp;<%=customSession.getUserName()%></b></td>
<td nowrap='nowrap' id='WorkstepHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>

<%
	params = "";
	Query="SELECT Logical_Name FROM USR_0_SRB_WORKSTEPS WHERE Workstep_Name=:Workstep_Name";
	params = "Workstep_Name=="+WSNAME;
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
			
	//WriteLog("Input For Get Logical workstep Name From Table-->"+inputData);		
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("Output For Get Logical workstep Name From Table-->"+outputData);
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputData));
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	
	int recordcountLogical_Name = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
	if(maincode.equals("0"))
	{
		if(recordcountLogical_Name==1)
		{
			logicalWsName=WFCustomXmlResponseData.getVal("Logical_Name");
			//WriteLog("logicalWsName--"+logicalWsName);
			//WriteLog("Logical Workstep Name "+WSNAME);
			if(logicalWsName.equalsIgnoreCase("CSO"))
			{
				WSNAME="CSO";
				//WriteLog("Logical Workstep Name "+WSNAME);
			}
			WriteLog("Final Workstep Name "+WSNAME);
		}
	}
%>



<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Workstep"><b>&nbsp;<%=logicalWsName%></b></label></td>
</tr>
<!-- drop 2 point 71 -->
<% if(WSNAME.equals("Q4")){%>
<tr>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workitem Name</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;<%=WINAME%></b></td>

<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>OPS Maker User</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="OPSMakerUser"><b>&nbsp;<%=((CustomWorkdeskAttribute)attributeMap.get("OPSMakerUser")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("OPSMakerUser")).getAttribValue().toString()%></b></label></td>
</tr>
<tr>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>SOL Id</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Sol_id"><b>&nbsp;<%=((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()%></b></label></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%></td>
 </tr>
<%} else { %>
<tr>
<td nowrap='nowrap' id='WinameHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Workitem Name</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><b>&nbsp;<%=WINAME%></b></td>
<td nowrap='nowrap' id='SolIDHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>SOL Id</b></td>

<%
	if(WSNAME.equals("CSO")||WSNAME.equals("Introduction"))
	{
		params = "";
		Query="SELECT comment FROM PDBUser with(nolock) WHERE UserName=:UserName";
	params = "UserName=="+userName;
	
		
	 inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";		
	
	WriteLog("Query For Get Sol Id From Pdbuser-->"+inputData);	

	WriteLog("customSession.getJtsIp-->"+customSession.getJtsIp());
		
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	WriteLog("Output Of Get Sol ID-->"+outputData);
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputData));
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	
	int recordcountForSolId = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
	if(maincode.equals("0"))
	{
		if(recordcountForSolId>0)
		{
		 %>	
		 <input type='hidden' name="wdesk:SOLID" id="wdesk:SOLID" value='<%=WFCustomXmlResponseData.getVal("comment")%>'/>
		 <td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Sol_id"><b>&nbsp;<%=WFCustomXmlResponseData.getVal("comment")%></b></label></td>
		  <%
		}		
	}
	}
	else
	{
%>
 <td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Sol_id"><b>&nbsp;<%=((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()%></b></label></td>
 <%
 }
 %>
</tr>
<%}%>

<tr>
<td nowrap='nowrap' id='CifIdHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>CIF Number</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" disabled name="wdesk:CifId" id="wdesk:CifId" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CifId")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CifId")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='CustnameHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Customer Name</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:Name" id="wdesk:Name" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Name")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Name")).getAttribValue().toString()%>'/></td>
</tr>

<tr>
<td nowrap='nowrap' id='SubSegmentHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Sub Segment</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:SubSegment" id="wdesk:SubSegment" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("SubSegment")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SubSegment")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='ARMCodeHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>ARM Code</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:ARMCode" id="wdesk:ARMCode" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("ARMCode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ARMCode")).getAttribValue().toString()%>'/></td>
</tr>

<tr>
<td nowrap='nowrap' id='RAKEliteHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Rak Elite</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="5" disabled name="wdesk:RAKElite" id="wdesk:RAKElite" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("RAKElite")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RAKElite")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='ChannelHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Channel</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><%if(WSNAME.equals("CSO")){%><select width='300' name='Channel' id='Channel' style='width:167px'  >
<option value='--Select--'>--Select--</option>
<%
	params = "";
	Query="select Channel from USR_0_SRB_CHANNELMAP where IsActive=:IsActive order by Channel desc";
	params = "IsActive==Y";
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
			
	WriteLog("Query For Channel Input-->"+inputData);		
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	WriteLog("List of channel Output-->"+outputData);
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputData));
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	
	int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
	if(maincode.equals("0"))
	{	
		objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{ 
			    channel = objWorkList.getVal("Channel");
			    WriteLog("channel Is-->"+channel);
				%>
				<option value='<%=channel%>'><%=channel%></option>
				<%
		    }
	}	
%>
</select><%}else{%><input type='text' name="Channel" id="Channel" style='width:167px' disabled='disabled' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Channel")).getAttribValue()%>'/><%}%></td>
</tr>

<tr>
<td nowrap='nowrap' id='EIDHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:EmiratesIDHeader" id="wdesk:EmiratesIDHeader" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EmiratesIDHeader")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmiratesIDHeader")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='EIDExpiryDtHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID Expiry Date</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateExpiryDate(this.value);" type='text' size="22" maxlength="10" disabled name="wdesk:EmratesIDExpDate" id="wdesk:EmratesIDExpDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EmratesIDExpDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmratesIDExpDate")).getAttribValue().toString()%>'/></td>
</tr>
<tr>
<td nowrap='nowrap' id='TradeLicenseHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Trade License</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:TLIDHeader" id="wdesk:TLIDHeader" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("TLIDHeader")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TLIDHeader")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='TradeLicenseExpDtHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Trade License Expiry Date</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateExpiryDate(this.value);" type='text' size="22" maxlength="10" disabled name="wdesk:TLIDExpDate" id="wdesk:TLIDExpDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("TLIDExpDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TLIDExpDate")).getAttribValue().toString()%>'/></td>
</tr>
<tr>
<td nowrap='nowrap' id='PrimaryEmailIdHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Primary Email Id</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="wdesk:PrimaryEmailId" id="wdesk:PrimaryEmailId" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("PrimaryEmailId")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PrimaryEmailId")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='ApplicationDateHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b> Application Date</b></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input class = 'NGReadOnlyView'  onblur="validateAppDate(this.value,'wdesk:ApplicationDate');" type='text' size="22" maxlength="100"  name="wdesk:ApplicationDate" id="wdesk:ApplicationDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("ApplicationDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ApplicationDate")).getAttribValue().toString()%>'/>
<img class = 'NGReadOnlyView' id = 'CalApplicationDate' style="cursor:pointer" src='/SRB/webtop/images/images/cal.gif' style="float:center;" onclick = "initialize('wdesk:ApplicationDate');" width='16' height='16' border='0' alt=''></td>
</tr>

</table>

<table id = "Req_details" border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Request Details</b></td>
	</tr>
<tr>

	<%
	params = "";
	Query="select distinct t.[CategoryName], STUFF((SELECT distinct ', ' + convert(nvarchar(255),t1.subcategoryName) from usr_0_srb_subcategory t1 where t.[CategoryIndex] = t1.[parentCategoryIndex] and t1.isactive=:isactive1 FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'),1,2,'') subcategoryName from usr_0_srb_category t where t.IsActive =:IsActive2";

	params = "isactive1==Y"+"~~"+"IsActive2==Y";
	 inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
			
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("outputData Initiate-->"+outputData);
	String subcat_search="";
	String cat_Subcat="";
	String temp[] = null;
	ArrayList<String> category = new ArrayList<String>();
	ArrayList<String> subCategory = new ArrayList<String>();
	
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputData));
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
	if(maincode.equals("0"))
	{	
		objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{ 		category.add(objWorkList.getVal("CategoryName"));
				subcat_search=  subcat_search+objWorkList.getVal("subcategoryName")+","; // added by shamily to get all subcategories fetched
				temp = objWorkList.getVal("subcategoryName").split(",");
				cat_Subcat+=objWorkList.getVal("CategoryName")+"#"+objWorkList.getVal("subcategoryName")+"~";
				for(int i=0; i<temp.length; i++)
				{
					subCategory.add(temp[i]);
				}	
		}
		cat_Subcat=cat_Subcat.substring(0,(cat_Subcat.lastIndexOf("~")));
	}
//WriteLog("sumit :"+cat_Subcat);
%>	
<!--modify category and subcategory types added by shamily start-->
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Request Category</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><%if(WSNAME.equals("CSO")){%><select disabled="disabled" onchange="javascript:setSubCategory(this.value,'SubCategory','<%=cat_Subcat.replaceAll(", ", ",")%>');" width='300' name='Category' id='Category' style='width:167px'><option value='--Select--'>--Select--</option><%for(int i=0; i<category.size(); i++){%><option value='<%=category.get(i)%>'><%=category.get(i)%></option>
	<%}%>
		</select><%}else{%><input type='text' name="Category" id="Category" disabled='disabled' style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Category")).getAttribValue().toString()%>'/><%}%></td>
			<input type=hidden name="cat_Subcat" id="cat_Subcat" style="visibility:hidden" value='<%=cat_Subcat.replaceAll(", ", ",")%>'>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Service Request Type</b></td>
	
								
								<td nowrap='nowrap' style="display:none" class='EWNormalGreenGeneral1' width = 25%><%if(WSNAME.equals("CSO")){%><select width='300' name='SubCategory' id='SubCategory' style='width:167px' ><option value='--Select--'>--Select--</option><option value='Test'>Test</option><%for(int i=0; i<subCategory.size(); i++){%><option value='<%=subCategory.get(i).trim()%>'><%=subCategory.get(i).trim()%></option><%}%></select><%}else{%><input type='text' name="SubCategory" id="SubCategory" disabled='disabled' style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("SubCategory")).getAttribValue().toString()%>'/><%}%>
								</td>
								
								<td nowrap='nowrap'  class='EWNormalGreenGeneral1' width = 25%><%if(WSNAME.equals("CSO")){%><input type='text' name="SubCategory_search" id="SubCategory_search" onblur = "validatesubcat('SubCategory_search','<%=subcat_search%>'),setcategory(this.value,'<%=cat_Subcat.replaceAll(", ", ",")%>'),setSubCategory(this.value,'SubCategory','');" style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("SubCategory")).getAttribValue().toString()%>'/>
								
								<input type=hidden name='AutocompleteValues' id='AutocompleteValues' style='visibility:hidden' value='<%=subcat_search%>'>
								<%
								}
								
								else{%><input type='text' name="SubCategory_search" id="SubCategory_search" disabled='disabled' style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("SubCategory")).getAttribValue().toString()%>'/><%}%>
								</td>
								</tr>
								<!--modify category and subcategory types added by shamily end-->
</table>


<table id ="CIF_Search" border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>CIF Search</b></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Emirates ID</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 24%><input type='text' name='EmiratesID'  onkeyup="ValidateAlphaNumeric('EmiratesID','Emirates ID');" id='EmiratesID' value='<%=((CustomWorkdeskAttribute)attributeMap.get("EmiratesID")).getAttribValue().toString()%>' size="20" maxlength = '21' style='width:167px'><input name='ReadEmiratesID' type='button' id='ReadEmiratesID' value='Read' onclick="eida_read();return false;" class='EWButtonRB NGReadOnlyView' style='width:35px'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>CIF Number</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='number' onkeyup="ValidateNumericMain('Cifnumber','CIF Number');" name='Cifnumber'  id='Cifnumber' value = '' maxlength='7' style='width:167px'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>

<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Account No.</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='text' onkeyup="ValidateNumericMain('accountNo','Account No');" name='accountNo'  id='accountNo' value = '' maxlength = '13' style='width:168px' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Card Number</b></td>

		<% if(! ViewMode.equals("R")){%>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='text' onkeyup="ValidateNumericMain('cardno','Card Number');" name='cardno' id='cardno' value = '' maxlength = '16' style='width:167px' >&nbsp;&nbsp;&nbsp;&nbsp;
		<%}else{%>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='text' onkeyup="ValidateNumericMain('cardno','Card Number');" name='cardno' readonly id='cardno' value = '' maxlength = '20' style='width:167px' >&nbsp;&nbsp;&nbsp;&nbsp;
		<% }
		if((WSNAME.equals("Introduction")||!FlagValue.equals("Y")) &&(! ViewMode.equals("R")))
		{

		%>
		</td>
		<%
		}
		else
		{
		%>
		</td>
		<%
		}
		%>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Loan Agreement ID</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' onkeyup="ValidateNumericMain('loanaggno','Loan Agreement ID');" name='loanaggno'  id='loanaggno' value = '' maxlength = '24' style='width:168px' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td  nowrap='nowrap' class='EWNormalGreenGeneral1'>
		<input name='Fetch' type='button'  id='Fetch' value='Search' onclick="getEntityDetails();setFrameSize();" class='EWButtonRB NGReadOnlyView' style='width:70px'>
		&nbsp;<input name='Clear' id="Clear" type='button' value='Clear' onclick="ClearFields();setAutocompleteData();" class='EWButtonRBSRM NGReadOnlyView' style='width:50px'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
		<input type='text' disabled maxlength = '13' style='width:168px' onkeyup="ValidateNumericMain('wdesk:AdditionalSignAccount','Additional Sign Account');" onblur="validateFieldLength(this.value,'Additional Sign Account');" name='wdesk:AdditionalSignAccount'  id='wdesk:AdditionalSignAccount' value = '<%=((CustomWorkdeskAttribute)attributeMap.get("AdditionalSignAccount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("AdditionalSignAccount")).getAttribValue().toString()%>'>
		<input name='viewSign' id="viewSign" type='button' value='View Signature' onclick="getSignature(this);" class='EWButtonRBSRM NGReadOnlyView' style='width:168px'>
		
		</td>
</tr>
</table>
<div id="divCheckbox">  
	<div class="accordion-inner" id="mainEmiratesId">				
	</div>
</div>
<iframe border=0 src="../SRB_Specific/BPM_blank.jsp" id="frmData" name="frmData" width="100%" scrolling = "no" onload='javascript:resizeIframe(this);' onresize='javascript:resizeIframe(this);'></iframe> 
<!---Dispatch Details details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id="dispatchHeader" style="display:none">
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Dispatch Details</b></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 27%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Mode of Delivery</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select class = 'NGReadOnlyView' multiple="multiple" onclick = "checkValueForModOfDelivery();" width='300' name='modeofdelivery' id='modeofdelivery' style='width:170px; height:100px'>
		

			
			<!--<option value='Email'>Email</option>-->
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Document Collection Branch</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select class = 'NGReadOnlyView' onchange="setComboValueToTextBox(this,'wdesk:DocumentCollectionBranch')" width='300' name='doccollectionbranch' id='doccollectionbranch' style='width:170px'>
			<option value='--Select--'>--Select--</option>
			<%
			Query="select BRANCHNAME from RB_BRANCH_MASTER with(nolock) where DeliveryBranch ='Y' order by BRANCHNAME asc";
			String branch="";	
			inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
					
			//WriteLog("Query For BRANCHNAME Input-->"+inputData);		
			outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
			//WriteLog("List of BRANCHNAME Output-->"+outputData);
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString((outputData));
			maincode = WFCustomXmlResponseData.getVal("MainCode");
			
			int recordcountBranch = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
			if(maincode.equals("0"))
			{	
				objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
					{ 
						branch = objWorkList.getVal("BRANCHNAME");
						//WriteLog("Branch Is-->"+branch);
						%>
						<option value='<%=branch%>'><%=branch%></option>
						<%
					}
			}	
		%>
		</select>
		</td>
	</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 27%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Branch Delivery Method</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select class = 'NGReadOnlyView' onchange="setComboValueToTextBox(this,'wdesk:BranchDeliveryMethod')" width='300' name='branchDeliveryMethod' id='branchDeliveryMethod' style='width:170px'>
			<option value='--Select--'>--Select--</option>
			<option value='Internal Mail'>Internal Mail</option>
			<option value='Attachment'>Attachment</option>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Courier AWB Number
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input class = 'NGReadOnlyView' type='text' name='wdesk:CourierAWBNumber'  id='wdesk:CourierAWBNumber' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CourierAWBNumber")).getAttribValue().toString()%>' maxlength='100' style='width:170px' onkeyup="ValidateAlphaNumeric('wdesk:CourierAWBNumber','Courier AWB Number');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Courier Company Name
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input class = 'NGReadOnlyView' type='text' name='wdesk:CourierCompName'  id='wdesk:CourierCompName' value='<%=((CustomWorkdeskAttribute)attributeMap.get("CourierCompName")).getAttribValue().toString()%>' maxlength='100' style='width:170px'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Branch AWB Number
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%><input class = 'NGReadOnlyView' type='text' name='wdesk:BranchAWBNumber'  id='wdesk:BranchAWBNumber' value='<%=((CustomWorkdeskAttribute)attributeMap.get("BranchAWBNumber")).getAttribValue().toString()%>' maxlength='100' style='width:170px' onkeyup="ValidateAlphaNumeric('wdesk:BranchAWBNumber','Branch AWB Number');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>

<!-- Start - Mode of del related changes, added on 09092019 -->
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Authorized Person Name
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input class = 'NGReadOnlyView' type='text' name='wdesk:AuthorizedPersonName' disabled id='wdesk:AuthorizedPersonName' maxlength='100' style='width:170px' onkeyup="ValidateCharacterMain('wdesk:AuthorizedPersonName','Authorized Person Name');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AuthorizedPersonName")).getAttribValue().toString()%>' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Authorized Person<br/>&nbsp;&nbsp;&nbsp;&nbsp;Mobile Number
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%><input class = 'NGReadOnlyView' type='text' name='wdesk:AuthorizedPersonMobNumber' disabled id='wdesk:AuthorizedPersonMobNumber' maxlength='20' style='width:170px' onkeyup="ValidateMobileNumber('wdesk:AuthorizedPersonMobNumber','Authorized Person Mobile Number');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AuthorizedPersonMobNumber")).getAttribValue().toString()%>' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>

<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Authorized Person<br/>&nbsp;&nbsp;&nbsp;&nbsp;Emirates ID</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input class = 'NGReadOnlyView' type='text' name='wdesk:AuthorizedPersonEmid' disabled id='wdesk:AuthorizedPersonEmid' maxlength='100' style='width:170px' onkeyup="ValidateMobileNumber('wdesk:AuthorizedPersonEmid','Authorized Person EMID');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AuthorizedPersonEmid")).getAttribValue().toString()%>' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%></td>
</tr>
<!-- End - Mode of del related changes, added on 09092019 -->

<tr>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Type of ID</b></td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
	<select  class="NGReadOnlyView" disabled onchange="setComboValueToTextBox(this,'wdesk:type_of_id');" width='300' name='type_of_idCombo' id='type_of_idCombo' style='width:170px'>
			<option value=''>--Select--</option>
			<option value='Emirates ID'>Emirates ID</option>
			<option value='Passport'>Passport</option>
		</select>
		</td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 24%><input name='ReadEmiratesIDForGenAck' disabled type='button' id='ReadEmiratesIDForGenAck' value='Read Emirates ID' onclick="eida_read();return false;" class='EWButtonRBSRM' style='width:150px'></td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%>&nbsp;<input name='Generate Acknowledgement' disabled id="Generate Acknowledgement" type='button' value='Generate Acknowledgement' onclick="generatePDF('Generate_Acknowledgement');" class='EWButtonRBSRM' style='width:180px'></td>
</tr>
</table>
<!---Deferral Details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="DeferralDetails" >
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Deferral Details</b></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Deferral Held </b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" onchange="setComboValueToTextBox(this,'wdesk:DeferralWaiverHeld');" width='300' name='DeferralWaiverHeldCombo' id='DeferralWaiverHeldCombo' style='width:170px'>
			<option value=''>--Select--</option>
			<option value='Y'>Yes</option>
			<option value='N' selected >No</option>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Approving Authority (Name)</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input  class="NGReadOnlyView" type='text' name='wdesk:ApprovingAuthority'  id='wdesk:ApprovingAuthority' value='<%=((CustomWorkdeskAttribute)attributeMap.get("ApprovingAuthority")).getAttribValue().toString()%>' maxlength='100' style='width:170px' onkeyup="ValidateCharacterMain('wdesk:ApprovingAuthority','Approving Authority');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Document Type deferred</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input  class="NGReadOnlyView" type='text' name='wdesk:DocumentTypedeferred'  id='wdesk:DocumentTypedeferred' value='<%=((CustomWorkdeskAttribute)attributeMap.get("DocumentTypedeferred")).getAttribValue().toString()%>' maxlength='100' style='width:170px' onkeyup="ValidateCharacterMain('wdesk:DocumentTypedeferred','Document Type deferred');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Deferral Expiry Date 
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input  class="NGReadOnlyView" type='text' name='wdesk:DeferralExpiryDate'  id='wdesk:DeferralExpiryDate' onblur = "validatedefexpirydate('wdesk:DeferralExpiryDate');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DeferralExpiryDate")).getAttribValue().toString()%>' maxlength = '24' style='width:170px' ><img style="cursor:pointer" src='/SRB/webtop/images/images/cal.gif' style="float:center;" onclick ="initialize('wdesk:DeferralExpiryDate');" id='DeferralExpiryDateCalImg' width='16' height='16' border='0' alt=''>
		</td>
	</tr>
</table>

<!---Waiver Details details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id = "waiverdetails">
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input  class="NGReadOnlyView" type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Waiver Details</b></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Waiver Held </b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" onchange="setComboValueToTextBox(this,'wdesk:WaiverHeld')" width='300' name='WaiverHeldCombo' id='WaiverHeldCombo' style='width:170px'>
			<option value=''>--Select--</option>
			<option value='Y'>Yes</option>
			<option value='N' selected >No</option>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Approving Authority (Name)</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input  class="NGReadOnlyView" type='text' name='wdesk:ApprovingAuthorityWaiver'  id='wdesk:ApprovingAuthorityWaiver' value='<%=((CustomWorkdeskAttribute)attributeMap.get("ApprovingAuthorityWaiver")).getAttribValue().toString()%>' maxlength='100' style='width:170px' onkeyup="ValidateCharacterMain('wdesk:ApprovingAuthorityWaiver','Waiver Approving Authority');">&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Document Type Waivered 
		</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input  class="NGReadOnlyView" type='text' name='wdesk:DocumentTypeWaivered'  id='wdesk:DocumentTypeWaivered' value='<%=((CustomWorkdeskAttribute)attributeMap.get("DocumentTypeWaivered")).getAttribValue().toString()%>' maxlength = '100' style='width:170px' onkeyup="ValidateCharacterMain('wdesk:DocumentTypeWaivered','Document Type waivered');">
		</td>
	</tr>
</table>

<div id="">  
	<div class="accordion-inner" id="duplicateWorkitemsId">				
	</div>
</div>
<!---
Decision Header Start**********************************************************************************************************
-->
<div id="dispatchDtl" style='display:block'> 
	<table border='1' cellspacing='1' cellpadding='0' width=100% id = "decisiondetails" >
		<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Decision</b></td>
		</tr>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Decision </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
		<select  class="NGReadOnlyView" style='width: 170px;' name="selectDecision" id="selectDecision" onchange="setComboValueToTextBox(this,'wdesk:Decision')">
						<option value="--Select--">--Select--</option>
							<%
							
			//modified by shamily for fetching decision on the basis of ws name and route category start
							CustomWorkdeskAttribute ROUTE_CATEGORY=((CustomWorkdeskAttribute)attributeMap.get("ROUTECATEGORY"));
							String ROUTECATEGORY=ROUTE_CATEGORY==null?"":ROUTE_CATEGORY.getAttribValue()==null?"":ROUTE_CATEGORY.getAttribValue().toString();
							if(ROUTECATEGORY!=null && ROUTECATEGORY != "")
							{
							params = "";
							
							//WriteLog("ROUTECATEGORY  shamily-->"+ROUTECATEGORY);		
							Query="select DECISION from USR_0_SRB_DECISION_MASTER WHERE WORKSTEP_NAME=:WORKSTEP_NAME and ROUTECATEGORY =:ROUTE_CATEGORY and isActive='Y'";
							
							// not taking Activity Verified decision when multipleApproval not required added by Angad on 01102018
							if(!isMultipleApprovalReq.equalsIgnoreCase("Y") && (WSNAME.equalsIgnoreCase("Q4") || WSNAME.equalsIgnoreCase("Q12") || WSNAME.equalsIgnoreCase("Q18") || WSNAME.equalsIgnoreCase("Q21") || WSNAME.equalsIgnoreCase("Q24")))
							{
								Query="select DECISION from USR_0_SRB_DECISION_MASTER WHERE WORKSTEP_NAME=:WORKSTEP_NAME and ROUTECATEGORY =:ROUTE_CATEGORY and isActive='Y' and DECISION!='Activity Verified'";
							}
							
							params = "WORKSTEP_NAME=="+WSNAME+"~~"+"ROUTE_CATEGORY=="+ROUTECATEGORY;
							
			//modified by shamily for fetching decision on the basis of ws name and route category end			
							
							
							String DECISION="";	
							String maincodeDecision="";
							 inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
									
							//WriteLog("Query For Workstep Input-->"+inputData);		
							outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							//WriteLog("Query For Workstep Output-->"+outputData);
							WFCustomXmlResponseData=new WFCustomXmlResponse();
							WFCustomXmlResponseData.setXmlString((outputData));
							maincodeDecision = WFCustomXmlResponseData.getVal("MainCode");
							
							int recordcountDecision = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
							if(maincodeDecision.equals("0"))
							{	
								objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
									{ 
										DECISION = objWorkList.getVal("DECISION");
										//WriteLog("DECISION Is-->"+DECISION);
										%>
										<option value='<%=DECISION%>'><%=DECISION%></option>
										<%
									}
							}
		}							
						%>
		</select></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='history' id="history" type='button' value='Decision History' onclick='HistoryCaller();' class='EWButtonRBSRM' style='width:150px'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%></td>
		</tr>
		<%
		if((WSNAME.equals("Q2") || WSNAME.equals("Q4") || WSNAME.equals("Q11") || WSNAME.equals("Q12") || WSNAME.equals("Q17") || WSNAME.equals("Q18") || WSNAME.equals("Q20") || WSNAME.equals("Q21") || WSNAME.equals("Q23") || WSNAME.equals("Q24")) && isMultipleApprovalReq.equalsIgnoreCase("Y"))
		{
		%>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>No.Of Approval Required</b></td>
			<%
			if(WSNAME.equals("Q2") || WSNAME.equals("Q11") || WSNAME.equals("Q17") || WSNAME.equals("Q20") || WSNAME.equals("Q23"))
			{
			%>
				<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 22%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' style='width: 170px;' onblur="ValidateOnlyNumbers(this);CheckApprovalReq(this);" maxlength='1' name="wdesk:NoOfApprovalRequired"  id="wdesk:NoOfApprovalRequired" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("NoOfApprovalRequired")).getAttribValue().toString()%>'></td>
			<%
			} else {
			%>
				<td nowrap='nowrap' disabled class='EWNormalGreenGeneral1 NGReadOnlyView' width = 22%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' style='width: 170px;' maxlength='1' name="wdesk:NoOfApprovalRequired"  id="wdesk:NoOfApprovalRequired" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("NoOfApprovalRequired")).getAttribValue().toString()%>'></td>
			<%
			}
			%>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%></td>
			<input type='hidden' name="wdesk:MultipleApprovalCount" id="wdesk:MultipleApprovalCount" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MultipleApprovalCount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MultipleApprovalCount")).getAttribValue().toString()%>'/>
			
		</tr>
		<%
		}
		%>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Remarks
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%>
		<textarea maxlength="3000" class='EWNormalGreenGeneral1'  style="width: 170px;" rows="3" cols="50" id="remarks" name="remarks" onblur="checkRemarks();"></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 10%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='RejectReason' id="RejectReason" type='button' value='Reject Reason' onclick="openCustomDialog('Reject Reasons','<%=logicalWsName%>');" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 10%>
		</td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Sign. Verified Ops Maker</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' size="19" name="wdesk:sign_matched_maker"  id="wdesk:sign_matched_maker" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_maker")).getAttribValue().toString()%>' disabled='true'></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Sign. Verified Ops Checker</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' size="20" name="wdesk:sign_matched_checker"  id="wdesk:sign_matched_checker" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_checker")).getAttribValue().toString()%>' disabled='true'></td>
		</tr>
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Hold Till Date</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%><input class = 'NGReadOnlyView' onblur="validateAppDate(this.value,'wdesk:HoldTillDate');" type='text' size="22" maxlength="100"  name="wdesk:HoldTillDate" id="wdesk:HoldTillDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("HoldTillDate")).getAttribValue().toString()%>' disabled='true'/>
			<img class = 'NGReadOnlyView' id = 'CalHoldTillDate' style="cursor:pointer" src='/SRB/webtop/images/images/cal.gif' style="float:center;" onclick = "initialize('wdesk:HoldTillDate');" width='16' height='16' border='0' alt='' disabled='true'></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Retention Expiry Date</b></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%><input class = 'NGReadOnlyView' onblur="validateRetExpiryDate(this.value,'wdesk:RetentionExpiryDate');" type='text' size="22" maxlength="100"  name="wdesk:RetentionExpiryDate" id="wdesk:RetentionExpiryDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("RetentionExpiryDate")).getAttribValue().toString()%>' disabled='true'/>
			<img class = 'NGReadOnlyView' id = 'CalRetExpiryDate' style="cursor:pointer" src='/SRB/webtop/images/cal.gif' style="float:center;" onclick = "initialize('wdesk:RetentionExpiryDate');" width='16' height='16' border='0' alt='' disabled='true'></td>
		</tr>
		
		<!-- added by shamily for opsmaker reject and remarks point 58 drop 2-->
		<%
		if(WSNAME.equals("Q4"))
		{
		%>
		<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 15%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Reject Remarks by OPS Maker</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%><textarea  readonly class='EWNormalGreenGeneral1 NGReadOnlyView'  style="width: 170px;color: #999;background:#D3D3D3"rows="3" cols="50"  id="remarksops" name="remarksops"></textarea>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 15%>&nbsp;&nbsp;&nbsp;&nbsp;<b>Reject Reasons by OPS Maker</b></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%><textarea readonly  class='EWNormalGreenGeneral1 NGReadOnlyView'  style="width: 170px;color: #999;background:#D3D3D3" rows="3" cols="50"  id="wdesk:rejectreasonsops" name="wdesk:rejectreasonsops"></textarea>
		</td>
		</tr>
		
		<%
		}
		%>
		
	</table>
</div>
<!---
Decision Header End**********************************************************************************************************
-->
<!--added by shamily to show reject reasons -->
<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
<input type='hidden' name='AutocompleteValuesServiceRequest' id='AutocompleteValuesServiceRequest' style='visibility:hidden' value=''>
<input type="hidden" id="DubplicateWorkitemVisible" name="DubplicateWorkitemVisible"/>
<input type="hidden" id="DuplicateCheckLogic" name="DuplicateCheckLogic"/>
<input type="hidden" id="AccountIndicator" name="AccountIndicator"/>
<input type="hidden" id="FetchClosedAcct" name="FetchClosedAcct"/>
<input type="hidden" id="AccToBeFetched" name="AccToBeFetched"/>
<table><tr><td><input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='<%=WSNAME%>'/></td></tr></table>
<input type='hidden' name="wdesk:ProcessName" id="wdesk:ProcessName" value='<%=customSession.getRouteName()%>'/>
<input type='hidden' name="wdesk:WI_NAME" id="wdesk:WI_NAME" value='<%=WINAME%>'/>
<%
//WriteLog("Inside Setting CIFTYPE-->"+WSNAME);
if((WSNAME.equals("CSO")))
{
	//WriteLog("Inside Setting CIFTYPE-->");
		%>
		<input type='hidden' name="wdesk:CIFTYPE" id="wdesk:CIFTYPE" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIFTYPE")).getAttribValue().toString()%>'/>
		
		<input type='hidden' name="wdesk:ARCHIVALPATH" id="wdesk:ARCHIVALPATH" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ARCHIVALPATH")).getAttribValue().toString()%>'/>
		<!--CR23082017-->
		<input type='hidden' name="wdesk:MANDATE_NONMANDATE" id="wdesk:MANDATE_NONMANDATE" value='<%=((CustomWorkdeskAttribute)attributeMap.get("MANDATE_NONMANDATE")).getAttribValue().toString()%>'/>
				
		<input type='hidden' name="wdesk:ARCHIVALPATHREJECT" id="wdesk:ARCHIVALPATHREJECT" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ARCHIVALPATHREJECT")).getAttribValue().toString()%>'/>
		
		<input type='hidden' name="wdesk:ResidentCountry" id="wdesk:ResidentCountry" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ResidentCountry")).getAttribValue().toString()%>'/>
		<!--added by badri to save ECRN number-->
		<input type='hidden' name="wdesk:ECRNumber" id="wdesk:ECRNumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ECRNumber")).getAttribValue().toString()%>'/>
		<!--Start - Saving queue variables value on introduction for slowness in filter added on 19012018-->
		<input type='hidden' name="wdesk:q_SOLID" id="wdesk:q_SOLID" value='<%=((CustomWorkdeskAttribute)attributeMap.get("q_SOLID")).getAttribValue().toString()%>'/>
		
		<input type='hidden' name="wdesk:q_DocumentCollectionBranch" id="wdesk:q_DocumentCollectionBranch" value='<%=((CustomWorkdeskAttribute)attributeMap.get("q_DocumentCollectionBranch")).getAttribValue().toString()%>'/>
		
		<input type='hidden' name="wdesk:q_ServiceRequestCode" id="wdesk:q_ServiceRequestCode" value='<%=((CustomWorkdeskAttribute)attributeMap.get("q_ServiceRequestCode")).getAttribValue().toString()%>'/>
		
		<input type='hidden' name="wdesk:StaleDateRestrictionDays" id="wdesk:StaleDateRestrictionDays" value=''/>
		
		<input type='hidden' name="wdesk:LoanProductType" id="wdesk:LoanProductType" value='<%=((CustomWorkdeskAttribute)attributeMap.get("LoanProductType")).getAttribValue().toString()%>'/>
		
		<input type='hidden' name="wdesk:AgreementNumber" id="wdesk:AgreementNumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AgreementNumber")).getAttribValue().toString()%>'/>
		<!--CR23082017-->
        <%		
}
%>

		<input type='hidden' name="wdesk:ROUTECATEGORY" id="wdesk:ROUTECATEGORY" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ROUTECATEGORY")).getAttribValue().toString()%>'/>
		
<input type='hidden' name="wdesk:UndeliveredDocExpiryForBranch" id="wdesk:UndeliveredDocExpiryForBranch" value='<%=((CustomWorkdeskAttribute)attributeMap.get("UndeliveredDocExpiryForBranch")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:RectificationPendingExpiryForBanch" id="wdesk:RectificationPendingExpiryForBanch" value='<%=((CustomWorkdeskAttribute)attributeMap.get("RectificationPendingExpiryForBanch")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:DiscrepantPhyDocRejByArchivalExpiry" id="wdesk:DiscrepantPhyDocRejByArchivalExpiry" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DiscrepantPhyDocRejByArchivalExpiry")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ProcessedPhyDocPenToBeSentToArchivalExpiry" id="wdesk:ProcessedPhyDocPenToBeSentToArchivalExpiry" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ProcessedPhyDocPenToBeSentToArchivalExpiry")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:PreviousRejectedBy" id="wdesk:PreviousRejectedBy" value='<%=((CustomWorkdeskAttribute)attributeMap.get("PreviousRejectedBy")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CUTOFFDATETIME" id="wdesk:CUTOFFDATETIME" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CUTOFFDATETIME")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:OPSMakerDecision" id="wdesk:OPSMakerDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OPSMakerDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CardSettlementMakerDecision" id="wdesk:CardSettlementMakerDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CardSettlementMakerDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CardMaintenanceMakerDecision" id="wdesk:CardMaintenanceMakerDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CardMaintenanceMakerDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CardDispatchMakerDecision" id="wdesk:CardDispatchMakerDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CardDispatchMakerDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:LoanServicesMakerDecision" id="wdesk:LoanServicesMakerDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("LoanServicesMakerDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ArchivalDecision" id="wdesk:ArchivalDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:printDispatchRequired" id="wdesk:printDispatchRequired" value='<%=((CustomWorkdeskAttribute)attributeMap.get("printDispatchRequired")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CSMApprovalRequire" id="wdesk:CSMApprovalRequire" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CSMApprovalRequire")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CardSettlementProcessingRequired" id="wdesk:CardSettlementProcessingRequired" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CardSettlementProcessingRequired")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:OriginalRequiredatOperations" id="wdesk:OriginalRequiredatOperations" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OriginalRequiredatOperations")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:DeferralWaiverHeld" id="wdesk:DeferralWaiverHeld" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DeferralWaiverHeld")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ModeOfDelivery" id="wdesk:ModeOfDelivery" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ModeOfDelivery")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:DocumentCollectionBranch" id="wdesk:DocumentCollectionBranch" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DocumentCollectionBranch")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:BranchDeliveryMethod" id="wdesk:BranchDeliveryMethod" value='<%=((CustomWorkdeskAttribute)attributeMap.get("BranchDeliveryMethod")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:TEMP_WI_NAME" id="wdesk:TEMP_WI_NAME" value='<%=((CustomWorkdeskAttribute)attributeMap.get("TEMP_WI_NAME")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:IntegrationStatus" id="wdesk:IntegrationStatus" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IntegrationStatus")).getAttribValue().toString()%>'/> 
<input type='hidden' name="wdesk:IntoducedBy" id="wdesk:IntoducedBy" value='<%=customSession.getUserName()%>'/>
<input type='hidden' name="CategoryID" id="CategoryID" value=''/>
<input type='hidden' name="SubCategoryID" id="SubCategoryID" value=''/>
<input type='hidden' name="wdesk:ServiceRequestCode" id="wdesk:ServiceRequestCode" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ServiceRequestCode")).getAttribValue().toString()%>'/>
<input type='hidden' name="isEMIDExpiryChkReq" id="isEMIDExpiryChkReq" value=''/>
<input type='hidden' name='isTransInSusAccount' id='isTransInSusAccount' value=''/>
<input type='hidden' name='currencySelected' id='currencySelected' value=''/>
<input type='hidden' name="savedFlagFromDB" id="savedFlagFromDB" value='<%=FlagValue%>'/>
<input type='hidden' name="wdesk:SubCategory" id="wdesk:SubCategory" value='<%=((CustomWorkdeskAttribute)attributeMap.get("SubCategory")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Category" id="wdesk:Category" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Category")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Channel" id="wdesk:Channel" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Channel")).getAttribValue().toString()%>'/>
<!--<input type='hidden' name="accountName" id="accountName" value='Amitabh'/>
<input type='hidden' name="accountType" id="accountType" value='Saving'/> -->
<input type='hidden' name="wdesk:IsRejected" id="wdesk:IsRejected" value=''/>
<input type='hidden' name="wdesk:PBODateTime" id="wdesk:PBODateTime" />
<input type='hidden' name="wdesk:mw_errordesc" id="wdesk:mw_errordesc" value='' />
<table><tr><td><input type='hidden' name="wdesk:Decision" id="wdesk:Decision" />
<input type='hidden' name="wdesk:IsSTP" id="wdesk:IsSTP" value=''/>
<input type='hidden' name="wdesk:IsError" id="wdesk:IsError" value=''/>
<input type='hidden' name="IsSavedFlag" id="IsSavedFlag" value=''/>
<input type='hidden' name="IsCSURefreshClicked" id="IsCSURefreshClicked" value=''/>
<input type='hidden' name="selectedcifid" id="selectedcifid" value = ''/>
<input type='hidden' name="wdesk:AccountnoSig" id="wdesk:AccountnoSig"/>
<input type='hidden' name="wdesk:AccountNo" id="wdesk:AccountNo" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AccountNo")).getAttribValue().toString()%>'/>
<input type='hidden' name="AccountnoDetails" id="AccountnoDetails" value=''/>
<%if(((CustomWorkdeskAttribute)attributeMap.get("wdesk:Current_Workstep"))==null || ((CustomWorkdeskAttribute)attributeMap.get("wdesk:Current_Workstep")).getAttribValue().toString().equals("")){  %>
<input type='hidden' name="wdesk:Current_Workstep" id="wdesk:Current_Workstep" value='Not Introduced'/>
<%}%>
<input type='hidden' name="wdesk:encryptedkeyid" id="wdesk:encryptedkeyid" value=''/>
<input type="hidden" name="flagForDecHisButton" id="flagForDecHisButton" value=''>
<input type='hidden' name="EmidExpirydate_param" id="EmidExpirydate_param" value='<%=EmidExpirydate_param%>'/>
<input type='hidden' name="wdesk:WaiverHeld" id="wdesk:WaiverHeld" value='<%=((CustomWorkdeskAttribute)attributeMap.get("WaiverHeld")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:OriginalRequiredbyOPSforProcessing" id="wdesk:OriginalRequiredbyOPSforProcessing" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OriginalRequiredbyOPSforProcessing")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:isSMSMailToBeSend" id="wdesk:isSMSMailToBeSend" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isSMSMailToBeSend")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Retention_Period" id="wdesk:Retention_Period" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Retention_Period")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:IslamicConvention" id="wdesk:IslamicConvention" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("IslamicConvention")).getAttribValue().toString()%>'/>  
<input type='hidden' name="islamic_conventional" id="islamic_conventional" value = ''/>

<!-- Drop 2 point 79 and 80-->
<!--added by badri for card CR'S-->
<%if(WSNAME.equals("Q2") || WSNAME.equals("Q4") || WSNAME.equals("Q11") || WSNAME.equals("Q12") || WSNAME.equals("Q17") || WSNAME.equals("Q18") || WSNAME.equals("Q20") || WSNAME.equals("Q21")){%>
<input type='hidden' name="wdesk:OPSMakerRejectFlag" id="wdesk:OPSMakerRejectFlag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OPSMakerRejectFlag")).getAttribValue().toString()%>'/>
<%}%>
<!--added by badri for card CR'S -->
<!-- Drop 2 point 71 -->
<%if((WSNAME.equals("Q2"))){%>
<input type='hidden' name="wdesk:OPSMakerUser" id="wdesk:OPSMakerUser" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OPSMakerUser")).getAttribValue().toString()%>'/>
<%}%>

<!-- ProcessedDateAtChecker field at OPS Checker on 23072017 -->
<%if(WSNAME.equals("Q4") || WSNAME.equals("Q12") || WSNAME.equals("Q18") || WSNAME.equals("Q21") || WSNAME.equals("Q24")){%>
<input type='hidden' name="wdesk:ProcessedDateAtChecker" id="wdesk:ProcessedDateAtChecker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ProcessedDateAtChecker")).getAttribValue().toString()%>'/>
<%}%>

<!-- Retention_Period_Flag hidden field at PrintDispatch WS on 06042018 -->
<%if(WSNAME.equals("Q6")){%>
<input type='hidden' name="wdesk:Retention_Period_Flag" id="wdesk:Retention_Period_Flag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Retention_Period_Flag")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Retention_Period_Flag")).getAttribValue().toString()%>'/>
<%}%>

<input type="hidden" name="ExistingDocCollBranch" id="ExistingDocCollBranch" value=''>

<input type='hidden' name="wdesk:type_of_id" id="wdesk:type_of_id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("type_of_id")).getAttribValue().toString()%>'/>
<input type="hidden" name="EmiratesIDHidden" id="EmiratesIDHidden" value=''>
<input type="hidden" name="EmiratesIDHolderNameHidden" id="EmiratesIDHolderNameHidden" value=''>
<input type="hidden" name="EmiratesIDExpDateHidden" id="EmiratesIDExpDateHidden" value=''>

<input type='hidden' name="wdesk:isMultipleApprovalReq" id="wdesk:isMultipleApprovalReq" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isMultipleApprovalReq")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isMultipleApprovalReq")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:isDoc_KYC_Risk_PEP_Attached" id="wdesk:isDoc_KYC_Risk_PEP_Attached" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isDoc_KYC_Risk_PEP_Attached")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isDoc_KYC_Risk_PEP_Attached")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:isDoc_Dormancy_BankStmt_Contract_Invoices_Attached" id="wdesk:isDoc_Dormancy_BankStmt_Contract_Invoices_Attached" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isDoc_Dormancy_BankStmt_Contract_Invoices_Attached")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isDoc_Dormancy_BankStmt_Contract_Invoices_Attached")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:isDoc_POA_Attached" id="wdesk:isDoc_POA_Attached" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isDoc_POA_Attached")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("isDoc_POA_Attached")).getAttribValue().toString()%>'/>

</td></tr></table>

</form>

    </body>
</f:view>
</html>
<%
}
%>