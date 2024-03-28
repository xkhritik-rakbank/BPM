
<%@ page import="java.util.Iterator"%>
<%@ include file="../header.process" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.util.Properties" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>

<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.wfdesktop.baseclasses.*"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.*, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ include file="../TF_Specific/Log.process"%>

<script language="javascript" src="/TF/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/TF/webtop/scripts/jquery.autocomplete.js"></script>
<script src="/TF/webtop/scripts/jquery.min.js"></script>
<script src="/TF/webtop/scripts/bootstrap.min.js"></script>
<script src="/TF/webtop/scripts/jquery-ui.js"></script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%
if (parameterMap != null && parameterMap.size() > 0) {
	
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();

	WFCustomWorkitem WFWorkitem = new WFCustomWorkitem();
	String outputXmlFetch = WFWorkitem.WMFetchWorkItemAttribute(jtsIP, jtsPort, debugValue, engineName, sessionId, WINAME, wid, "", "", "", "", "", "", "", activityId, routeID);
	
	WFCustomXmlResponse wfXmlResponse = new WFCustomXmlResponse(outputXmlFetch);
	attributeData = "<Attributes>" + wfXmlResponse.getVal("Attributes") + "</Attributes>";
	CustomWiAttribHashMap structureMap = new CustomWiAttribHashMap();
	
	LinkedHashMap varIdMap = new LinkedHashMap();
	attributeMap = WFCustomAttribParser.fillDataStructure(attributeData, structureMap, varIdMap, dateFormat);
	session = request.getSession(false);		
	
%>
<HTML>
<f:view>
<HEAD>

<META content="IE=5.0000" http-equiv="X-UA-Compatible">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<!--<link rel="stylesheet" href="..\..\webtop\scripts\bootstrap.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\jquery-ui.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\jquery.autocomplete.css">
<link rel="stylesheet" href="..\..\webtop\en_us\css\docstyle.css">
<link rel="stylesheet" href="..\..\webtop\scripts\DatePicker\jquery-ui.css">-->

<link rel="stylesheet" href="\TF\webtop\scripts\bootstrap.min.css">
<link rel="stylesheet" href="\TF\webtop\scripts\jquery-ui.css">
<link rel="stylesheet" href="\TF\webtop\en_us\css\jquery.autocomplete.css">
<link rel="stylesheet" href="\TF\webtop\en_us\css\docstyle.css">
<link rel="stylesheet" href="\TF\webtop\scripts\DatePicker\jquery-ui.css">

<style>
	@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<TITLE> RAKBANK-Trade Finance Request</TITLE>

<!-- <script src="http://code.jquery.com/jquery-1.9.1.min.js"></script> -->
<script type="text/javascript" language="javascript" src="eida_webcomponents.js"></script>
<script language="JavaScript" src="/TF/webtop/scripts/TF_Script/loadFormValuesAtNextWS.js"></script>
<script language="javascript" src="/TF/webtop/scripts/TF_Script/table_script.js"></script>
<script language="javascript" src="/TF/webtop/scripts/clientTF.js"></script>
<script src="/TF/webtop/scripts/TF_Script/loadDropDownValues.js"></script> 
<script language="javascript" src="/TF/webtop/scripts/TF_Script/PDFGenerate.js"></script> 
<script language="javascript" src="/TF/webtop/scripts/TF_Script/FieldValidation.js"></script>
<!-- for date picker--------------------------------------->
<script language="JavaScript" src="/TF/webtop/scripts/DatePicker/jquery-1.10.2.js"></script>
<script language="JavaScript" src="/TF/webtop/scripts/DatePicker/jquery-ui.js"></script>

<!----------------------------- for RICH TEXT --------------------------------------->
<!--<script src="/TF/webtop/scripts/TF_Script/jquery.min.map"></script> -->
<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/jquery.min.js"></script>-->
<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/json3.min.js"></script>-->

<!--<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/codemirror.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/xml.min.js"></script>

<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/froala_editor.min.js" ></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/align.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/char_counter.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/code_beautifier.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/code_view.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/colors.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/draggable.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/emoticons.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/entities.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/file.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/font_size.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/font_family.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/fullscreen.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/image.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/image_manager.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/line_breaker.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/inline_style.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/link.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/lists.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/paragraph_format.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/paragraph_style.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/quick_insert.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/quote.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/table.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/save.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/url.min.js"></script>
<script type="text/javascript" src="/TF/webtop/scripts/TF_Script/froala_editor/js/plugins/video.min.js"></script>


<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\font-awesome.min.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\froala_editor.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\froala_style.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\code_view.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\colors.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\emoticons.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\image_manager.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\image.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\line_breaker.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\table.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\char_counter.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\video.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\fullscreen.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\file.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\plugins\quick_insert.css">
<link rel="stylesheet" href="..\..\webtop\scripts\TF_Script\froala_editor\css\codemirror.min.css">-->

<!--<style>
      body {
          text-align: center;
      }

      div#editor {
          width: 81%;
          margin: auto;
          text-align: left;
      }

      .class1 {
        border-radius: 10%;
        border: 2px solid #efefef;
      }

      .class2 {
        opacity: 0.5;
      }
</style>-->



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
		
		$(function () {
		$("#LodgementDate").datepicker({
		beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 80, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 50 +(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},
            dateFormat: "dd/mm/yy",
            showOtherMonths: true,
            selectOtherMonths: true,
            autoclose: true,
            changeMonth: true,
            changeYear: true,
			yearRange: "-100:+0"
			     //gotoCurrent: true,
        });
		
        $("#ApplicationDate").datepicker({
		beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 80, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 50 +(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},
            dateFormat: "dd/mm/yy",
            showOtherMonths: true,
            selectOtherMonths: true,
            autoclose: true,
            changeMonth: true,
            changeYear: true,
			yearRange: "-100:+0"
			     //gotoCurrent: true,
        });
		//Below function added to show default date as today's date
		$('#ApplicationDate').datepicker('setDate',new Date());
		
		 $("#HoldtillDate").datepicker({
		beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 1015, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 990 +(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},
            dateFormat: "dd/mm/yy",
            showOtherMonths: true,
            selectOtherMonths: true,
            autoclose: true,
            changeMonth: true,
            changeYear: true,
			yearRange: "-100:+0"
			     //gotoCurrent: true,
        });
		
		 $("#RetentionExpDate").datepicker({
		beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 1015, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 990 +(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},
            dateFormat: "dd/mm/yy",
            showOtherMonths: true,
            selectOtherMonths: true,
            autoclose: true,
            changeMonth: true,
            changeYear: true,
			yearRange: "-100:+0"
			     //gotoCurrent: true,
        });
		
		 $("#communicationDate").datepicker({
		beforeShow: function(input, instance)
				{
					var rect = input.getBoundingClientRect();					 
					var xCenter=($("body").height()/2);
					
					if(rect.top > xCenter)
						setTimeout(function () {
							instance.dpDiv.css({ top: 1090, left: rect.left });
						}, 0);
					else
						setTimeout(function () {
							instance.dpDiv.css({ top: 820 +(xCenter+input.offsetHeight), left: rect.left });
						}, 0);
				},
            dateFormat: "dd/mm/yy",
            showOtherMonths: true,
            selectOtherMonths: true,
            autoclose: true,
            changeMonth: true,
            changeYear: true,
			yearRange: "-100:+0"
			     //gotoCurrent: true,
        });
		
		
});
	
	
	</script>
</HEAD>
<script language="JavaScript" src="/TF/webtop/scripts/TF_Script/calendar_TF.js"></script>

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
		//alert("ele---"+ele);
		if (ele)		
			data = "ProductType_search="+ele.value;
			//alert('in autocomplete '+data);
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split(",");
			//alert("values--"+values);			
			
			$(document).ready(function() {
				$("#ProductType_search").autocomplete({source: values}); 
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

	
	function sendreport()
{	
	var modeofcommuni = document.getElementById("modeofcommunicationcombo").value;
		if (modeofcommuni == 'Email')
		{
			document.getElementById("GenerateTemplate").disabled=false;
			document.getElementById("templatecombo").value='Report';
		}
		else
		{
			document.getElementById("GenerateTemplate").disabled=true;
			document.getElementById("templatecombo").value='';
		}
}	
 
	function checkValueForModOfDelivery()
	{	
		var strMod = document.getElementById("modeofdelivery");
		var strSelectedValue =  strMod.options[strMod.selectedIndex].value;
		var WSNAME = '<%=WSNAME%>';
		if(WSNAME =="TF_Maker")
			{
				//alert("strSelectedValue--"+strSelectedValue);
				if(strSelectedValue == 'Branch')
				{
				document.getElementById("branchDeliveryMethod").disabled=false;
				document.getElementById("doccollectionbranch").disabled=false;
				document.getElementById("wdesk:CourierAWBNumber").value="";
				document.getElementById("wdesk:CourierCompanyName").value="";	
				document.getElementById("wdesk:CourierAWBNumber").disabled=true;
				document.getElementById("wdesk:CourierCompanyName").disabled=true;	
				}
				if(strSelectedValue =='Courier')
				{
				document.getElementById("branchDeliveryMethod").disabled=true;
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("doccollectionbranch").value="--Select--";
				document.getElementById("branchDeliveryMethod").value="--Select--";
				document.getElementById("wdesk:CourierAWBNumber").disabled=false;
				document.getElementById("wdesk:CourierCompanyName").disabled=false;	
				document.getElementById("wdesk:DocumentCollectionBranch").value="";
				document.getElementById("wdesk:BranchDeliveryMethod").value="";				
				}
				document.getElementById("wdesk:BranchAWBNumber").disabled=true;
				/* if(strSelectedValue =='Branch' && strSelectedValue =='Courier' )
				{
					document.getElementById("wdesk:CourierAWBNumber").disabled=false;
					document.getElementById("branchDeliveryMethod").disabled=false;
					//document.getElementById("wdesk:BranchAWBNumber").disabled=true;
					document.getElementById("doccollectionbranch").disabled=false;				  
				} */
			}
		else if(WSNAME =="CSO")
			{
				if(strSelectedValue == 'Branch')
				{
				document.getElementById("doccollectionbranch").disabled=false;
				document.getElementById("branchDeliveryMethod").disabled=false;				
				}
				else if(strSelectedValue == 'Courier')
				{
				//alert("inside else");
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("doccollectionbranch").value="--Select--";
				document.getElementById("branchDeliveryMethod").disabled=true;
				document.getElementById("branchDeliveryMethod").value="--Select--";
				document.getElementById("wdesk:DocumentCollectionBranch").value="";
				document.getElementById("wdesk:BranchDeliveryMethod").value="";
				}
				else
				{
				//alert("inside else");
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("branchDeliveryMethod").disabled=true;
				}
				document.getElementById("wdesk:CourierAWBNumber").disabled=true;
				document.getElementById("wdesk:CourierCompanyName").disabled=true;
				document.getElementById("wdesk:BranchAWBNumber").disabled=true;
				//document.getElementById("branchDeliveryMethod").disabled=true;
			}
		else if(WSNAME =="Print_and_Dispatch")
			{
				if(strSelectedValue == 'Branch')
				{
				document.getElementById("doccollectionbranch").disabled=false;			
				document.getElementById("wdesk:BranchAWBNumber").disabled=false;				
				}
				else if(strSelectedValue == 'Courier')
				{
				//alert("inside else");
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("doccollectionbranch").value="--Select--";
				document.getElementById("branchDeliveryMethod").disabled=true;
				document.getElementById("branchDeliveryMethod").value="--Select--";
				document.getElementById("wdesk:DocumentCollectionBranch").value="";
				document.getElementById("wdesk:BranchDeliveryMethod").value="";
				}
				else
				{
				//alert("inside else");
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("branchDeliveryMethod").disabled=true;
				}
				document.getElementById("wdesk:CourierAWBNumber").disabled=true;
				document.getElementById("wdesk:CourierCompanyName").disabled=true;
				document.getElementById("branchDeliveryMethod").disabled=true;
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
		//var subcat = document.getElementById("ProductType_search").value;
		
		var temp1 = values1.split("~");
		for(var i = 0;i < temp1.length;i++)
		{
			if(temp1[i].indexOf(subcat)!=-1)
			{
				document.getElementById("Product_Category").value = temp1[i].substring(0,temp1[i].indexOf('#'));	
				var Category123 = document.getElementById("Product_Category").value;
				
			}	
		}
		if(subcat=="" || subcat==null)
		document.getElementById("Product_Category").value = '--Select--';
		 Category123 =document.getElementById("Product_Category").value;
	}
	function setFrameSize()
	{
		var widthToSet = document.getElementById("evntDetails").offsetWidth;
		var controlName="TAB_TF,TF_Header,Req_details,CIF_Search,frmData,divCheckbox,dispatchHeader,dispatchDtl,decisiondetails,ChecklistTable,divchecklistGrid,DocumentTable,DocGrid,Invoicedtls,invcdtls,Invoicegrid,Invoicegridadd,evntDetails,EventGrid,EventDetailsGrid,CummDetails,cummunidtls,communicationaddgrid,communicationgridheader,QueryDtls_Header,QueryGrid,Query_Details_Grid,UTCDetailsHeader,UTCDtlsGrid1,UTCDetailsGrid,UTCDtlsButtonGrid,UTCDtlsGrid2,DeferralDetails,UTCDetailsDivHeader1,UTCDetailsDivHeader2,UTCDetailsDivHeader3,Firco_Details_Grid,FircoFetch_Details_Grid,FircoDtls_Header,FircoGrid";
		//invcdtls,Invoicedtls,grid,DocumentGRid,DocumentTable,checklistGrid,ChecklistTable,QueryDetailsGrid
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
	function setValue(val1) 
	{
	   //you can use the value here which has been returned by your child window
	   popupWindow = val1;
	   if(dialogToOpenType == 'Reject Reasons'){
		   if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
				document.getElementById('rejReasonCodes').value = popupWindow;
	   }else if(dialogToOpenType == 'Reject Reasons'){
		   if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						document.getElementById('H_CHECKLIST').value = result[0];
						//alert("the values are " +document.getElementById('H_CHECKLIST').value);
			}
	   }
	}
	//ends here.
	
	//added by shamily to show reject reasons 
	function openCustomDialog(dialogToOpen, workstepName) 
	{
		if (dialogToOpen == 'Reject Reasons') {

				//var WSNAME = '<%=WSNAME%>';
				dialogToOpenType = dialogToOpen;
				if(workstepName=='Print & Dispatch') //to handle &
				workstepName = 'Print Dispatch';
				var WSNAME =  workstepName;
				var wi_name = '<%=WINAME%>';
				//var rejectReasons = document.getElementById('wdesk:remarks1').value;
				var rejectReasons = document.getElementById('rejReasonCodes').value;
				//var rejectReasonopsmaker = document.getElementById('wdesk:rejectreasonsops').value;
				//document.getElementById("wdesk:rejectreasonsops").value = document.getElementById("RejectReasonsList").value  
			
				sOptions = 'dialogWidth:500px; dialogHeight:400px; dialogLeft:450px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
				
				//popupWindow = window.showModalDialog('/TF/CustomForms/TF_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
				
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
				/***********************************************************/
				var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
				if (window.showModalDialog) {
					popupWindow = window.showModalDialog('/TF/CustomForms/TF_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null, sOptions);
				} else {
					popupWindow = window.open('/TF/CustomForms/TF_Specific/Reject_Reasons.jsp?workstepName=' + WSNAME + "&wi_name=" + wi_name + "&ReasonCodes=" + encodeURIComponent(rejectReasons), null,windowParams);
				}
				/************************************************************/
				//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
				
				//Set the response code to the input with id = rejReasonCodes
				//alert("popupWindow "+popupWindow);
				if (popupWindow!="NO_CHANGE" && popupWindow!='[object Window]')
				document.getElementById('rejReasonCodes').value = popupWindow;				
			}
			else if (dialogToOpen=='Exception History') {
					dialogToOpenType = dialogToOpen;
					var workstepName = workstepName;
					var wi_name = '<%=WINAME%>';
					var H_CHECKLIST = document.getElementById('H_CHECKLIST').value;

					sOptions = 'dialogWidth:850px; dialogHeight:500px; dialogLeft:250px; dialogTop:80px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';

					//popupWindow = window.showModalDialog('/TF/CustomForms/TF_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
					
					//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
					/***********************************************************/
					var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
					if (window.showModalDialog) {
						popupWindow = window.showModalDialog('/TF/CustomForms/TF_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,sOptions);
					} else {
						popupWindow = window.open('/TF/CustomForms/TF_Specific/Exception_Checklist.jsp?workstepName='+workstepName+"&wi_name="+wi_name+"&H_CHECKLIST="+encodeURIComponent(H_CHECKLIST),null,windowParams);
					}
					/************************************************************/
					//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.


					//Set the response code to the input with id = H_CHECKLIST
					if(popupWindow != 'undefined' && popupWindow!=null && popupWindow!="NO_CHANGE" && popupWindow!='[object Window]') {
						var result = popupWindow.split("@");
						document.getElementById('H_CHECKLIST').value = result[0];
						//alert("the values are " +document.getElementById('H_CHECKLIST').value);
					}
					
				}
			else if (dialogToOpen=='Rich Text')
				{
					
					var WINAME = '<%=WINAME%>';
					var sOptions = 'left=200,top=50,width=1050,height=950,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
					
					var url = "/TF/CustomForms/TF_Specific/RichText.jsp";
					//alert("url"url);
					popupWindow = window.open(url, "_blank", sOptions);
				}	
				
		
	}
	 function mandatorycheck(id)
	 {
		 if(document.getElementById(id).value=="--Select--")
		 {
		 if(document.getElementById("modeofdelivery").value=='Branch')
			 {
			 alert("Please select valid value for Document Collection Branch");
			 }
		}	 
	 
	 }
	
	function setComboValueToTextBox(dropdown, inputTextBoxId) 
	{
			var WSNAME = '<%=WSNAME%>';
			document.getElementById(inputTextBoxId).value = dropdown.value;
			if(WSNAME=='CSO')
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
				if(inputTextBoxId=='wdesk:ModeOfDelivery')
				{
					if(document.getElementById(inputTextBoxId).value=='Branch'|| document.getElementById(inputTextBoxId).value=='Branch~Email' )
					{
								document.getElementById("doccollectionbranch").disabled=false;
					            document.getElementById("branchDeliveryMethod").disabled=false;
								 document.getElementById("wdesk:CourierAWBNumber").disabled=true;
								  document.getElementById("wdesk:CourierCompanyName").disabled=true;
						
					}
					else
					{
						document.getElementById("wdesk:DocumentCollectionBranch").disabled=true;
					    document.getElementById(" wdesk:BranchDeliveryMethod").disabled=true;
						 document.getElementById("wdesk:CourierAWBNumber").disabled=false;
						document.getElementById("wdesk:CourierCompanyName").disabled=false;
					}
					
				}
			/*	if(inputTextBoxId=='wdesk:DeferralWaiverHeld')
				{
					if(document.getElementById(inputTextBoxId).value=='Y')
					{
					document.getElementById("wdesk:ApprovingAuthority").disabled=false;
					document.getElementById("wdesk:DocumentTypedeferred").disabled=false;
					}
					else
					{
					document.getElementById("wdesk:ApprovingAuthority").disabled=true;
					document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
					document.getElementById("wdesk:ApprovingAuthority").value='';
					document.getElementById("wdesk:DocumentTypedeferred").value='';
					}
				}  */
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
			if(WSNAME=='RM'||WSNAME=='UM'||WSNAME=='SM'||WSNAME=='MD'||WSNAME=='HOD')
			{
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
			//document.getElementById("wdesk:PreviouslyRejectedBy").value ='';
			if(WSNAME=='TF_Call_Back')
			{
				//document.getElementById("wdesk:CardSettlementMakerDecision").value = dropdown.value;//Hidden field Added by siva for the newly added ws for 21 service request
					if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
					else
					document.getElementById("wdesk:PreviouslyRejectedBy").value ='';
			}
			else if(WSNAME=='CSM_Approval')
			{
				if(document.getElementById("selectDecision").value=='Reject to CSO')
				document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
				else
				document.getElementById("wdesk:PreviouslyRejectedBy").value ='';
			}
			else if(WSNAME=='TF_Maker')
			{
				//Saving TFMaker decision on TFMaker WS
				document.getElementById("wdesk:TFMakerDecision").value = document.getElementById("selectDecision").value;
				
				if(document.getElementById("selectDecision").value=='Reject to CSO' || document.getElementById("selectDecision").value=='Reject to TF Approve')
					document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
				
				else
					document.getElementById("wdesk:PreviouslyRejectedBy").value ='';		

				if(document.getElementById("selectDecision").value=='Hold-Internal' || document.getElementById("selectDecision").value=='Hold-External')
					document.getElementById("wdesk:HoldBy").value =WSNAME;
				else
					document.getElementById("wdesk:HoldBy").value ='';
			}
			
			else if(WSNAME=='TF_Document_Approver')
			{
				//document.getElementById("wdesk:OPSMakerDecision").value = dropdown.value;
				if(document.getElementById("selectDecision").value=='Reject to CSO' || document.getElementById("selectDecision").value=='Reject to TF Approve')
				{
				 document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
				}
				else
				document.getElementById("wdesk:PreviouslyRejectedBy").value ='';

				if(document.getElementById("selectDecision").value=='Hold-Internal' || document.getElementById("selectDecision").value=='Hold-External')
					document.getElementById("wdesk:HoldBy").value =WSNAME;
				else
					document.getElementById("wdesk:HoldBy").value ='';
			}
			else if(WSNAME=='TF_Checker')
			{
				//alert("WSNAME "+WSNAME+" "+document.getElementById("selectDecision").value);
				//document.getElementById("wdesk:ArchivalDecision").value = dropdown.value;
				if(document.getElementById("selectDecision").value=='Reject to CSO' || document.getElementById("selectDecision").value=='Reject to TF Approve' || document.getElementById("selectDecision").value=='Reject to TF Maker')
				{
				 //alert("inside");
				 document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
				}
				else
				document.getElementById("wdesk:PreviouslyRejectedBy").value ='';
			
				if(document.getElementById("selectDecision").value=='Hold-Internal' || document.getElementById("selectDecision").value=='Hold-External')
					document.getElementById("wdesk:HoldBy").value =WSNAME;
				else
					document.getElementById("wdesk:HoldBy").value ='';
			}
			else if(WSNAME=='TF_Hold')
			{
				//document.getElementById("wdesk:CardMaintenanceMakerDecision").value = dropdown.value;
					if(document.getElementById("selectDecision").value=='Reject to CSO')
						document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
					else
						document.getElementById("wdesk:PreviouslyRejectedBy").value ='';					
			}
			else if(WSNAME=='Returned_Doc_Maker')
			{
				//document.getElementById("wdesk:CardMaintenanceMakerDecision").value = dropdown.value;
					if(document.getElementById("selectDecision").value=='Reject to CSO')
						document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
					else
						document.getElementById("wdesk:PreviouslyRejectedBy").value ='';					
			}
			else if(WSNAME=='Returned_Doc_Checker')
			{
				//document.getElementById("wdesk:CardMaintenanceMakerDecision").value = dropdown.value;
					if(document.getElementById("selectDecision").value=='Reject to CSO')
						document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
					else
						document.getElementById("wdesk:PreviouslyRejectedBy").value ='';					
			}
			else if(WSNAME=='TF_Archival')
			{				
				document.getElementById("wdesk:ArchivalDecision").value = document.getElementById("selectDecision").value;
				if(document.getElementById("selectDecision").value=='Reject to CSO')
					document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
				else
					document.getElementById("wdesk:PreviouslyRejectedBy").value ='';					
			}
			// added by sowmya for new WS
			else if ( WSNAME=='RM' || WSNAME=='UM' || WSNAME=='SM' || WSNAME=='HOD' || WSNAME=='MD' || WSNAME=='CROPS_Admin_Checker' || WSNAME=='CROPS_Doc_Checker' || WSNAME=='Credit_Checker' || WSNAME=='CreditApp_OR_Analyst' || WSNAME=='Director_Credit'|| WSNAME=='Chief_Credit_Officer')
			{
				if(document.getElementById("selectDecision").value=='Reject to Initiator')
				{
				 document.getElementById("wdesk:PreviouslyRejectedBy").value =WSNAME;
				}
			/*	else
				document.getElementById("wdesk:PreviouslyRejectedBy").value =''; */

			}
			
			//added by sowmya for Reject to Initiator case
			if(document.getElementById('selectDecision').value=='Reject' || document.getElementById('selectDecision').value=='Reject to CSO' || document.getElementById('selectDecision').value=='Hold-Internal' || document.getElementById('selectDecision').value=='Hold-External' || document.getElementById('selectDecision').value=='Reject to TF Approve' || document.getElementById('selectDecision').value=='Reject to Initiator' || document.getElementById("selectDecision").value=='Send for Business Approval' || document.getElementById("selectDecision").value=='Send for CROPS Action' || document.getElementById("selectDecision").value=='Send to Business and CROPS')
			{
			document.getElementById('RejectReason').disabled = false;
			}
			else{
			document.getElementById('RejectReason').disabled = true;
			}
						
			
			//below block added for enable HoldTilldate field based on Decision 29112018
			if(inputTextBoxId=='wdesk:Decision')
			{
				if(document.getElementById(inputTextBoxId).value == "Hold-Internal" || document.getElementById(inputTextBoxId).value == "Hold-External")
					document.getElementById("HoldtillDate").disabled=false;
					
				else
					document.getElementById("HoldtillDate").disabled=true;
			}
			
			// CR--added by Sowmya
			if(inputTextBoxId=='wdesk:Decision' || inputTextBoxId =='wdesk:Queue_Values')
			{
		
				if(document.getElementById("wdesk:Decision").value == "Send within Credit" || document.getElementById("wdesk:Decision").value == "Send to Business" || document.getElementById("wdesk:Decision").value == "Send within Business")
				{
				
					document.getElementById("selectQueue").disabled=false;
				}
				else
				{
					document.getElementById("selectQueue").disabled=true;
					document.getElementById("selectQueue").value='--Select--';
					document.getElementById("wdesk:Queue_Values").value = '';
				}
				
				if(document.getElementById("wdesk:Decision").value == "Send within Credit" && document.getElementById("wdesk:Queue_Values").value == "CreditApp_OR_Analyst")
				{ 
					
					document.getElementById("selectUser").disabled=false;
				}
				else
				{
					document.getElementById("selectUser").disabled=true;
					document.getElementById("selectUser").value='--Select--';
					document.getElementById("wdesk:User_Values").value=''; 
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
		//alert("SubCategoryID"+SubCategoryID);
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
			document.getElementById(field).value = "";			
			return false;
		}
		else 
		{   
			var currentTime = new Date();
			var dd=currentTime.getDate();
            var mm = currentTime.getMonth() + 1; //January is 0!            
            var yyyy = currentTime.getFullYear();            
            var arrStartDate = value.split("/");            
            var date2 = new Date(arrStartDate[2], arrStartDate[1] - 1, arrStartDate[0]);
			
			//var date3 = new Date(arrAppDate[2] - arrAppDate[1] - arrAppDate[0]);
			//date3.toLocaleDateString();
			//alert(date3);
            var timeDiffPassport = date2.getTime() - currentTime.getTime();
			//var timeDiffPassport1= date2.getTime() - date3.getTime();
			
			if (field == "wdesk:ApplicationDate") {
				if(timeDiffPassport > 0) 
				{
					alert("Application date should not be future date.");
					document.getElementById(field).value = "";
					return false;			
				}
			}
			
			else if (field == "communicationDate") {
				if(timeDiffPassport > 0) 
				{
					alert("Communication date should not be future date.");
					document.getElementById(field).value = "";
					return false;			
				}
			}
			
			else if (field == "HoldtillDate") {
				if(timeDiffPassport < 0) 
				{
					alert("Hold Till Date should be future date.");
					document.getElementById(field).value = "";
					return false;			
				}
			}
			else if(field == "RetentionExpDate")
			{
				if(timeDiffPassport < 0) 
				{
					alert("Retention Expiry Date should be future date.");
					document.getElementById(field).value = "";
					return false;			
				}
			}
		}
	}
	function validateTime(value,field)
	{
		if(value=='')
		return;
		var pattern = /^([0-9]|0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$/;
		if (!pattern.test(value)) 
		{
			alert("Invalid Time format. The format should be HH:MM:SS");
			
			/*if (field == "ApplicationDate") {
			document.getElementById("ApplicationDate").value = "";
			}
			else if (field == "HoldtillDate"){*/
			document.getElementById(field).value = "";
			//}
			return false;
		}
	}
	
	function validateSpecialCharactersRemarks(field)
	{
		//var remarks=document.getElementById("remarks");
		var value=document.getElementById(field).value;
		var newLength=value.length;
		var maxLength=3000;
		value=value.replace(/(\r\n|\n|\r)/gm," ");
		value=value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");
		if(newLength>=maxLength){
			value=value.substring(0,maxLength);        
		}
		document.getElementById(field).value=value;
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
	function validateChequeDate(field,value,Object)
	{
		//alert("inside validate cheque date");
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
			
			if (field == "Date") {
					try 
					{
						//alert("inside try");
						var todate = "";
						for (x = 0; x < inputs.length; x++) 
						{
							myname = inputs[x].getAttribute("id");
							if (myname == null||myname == '')
							continue;
							if(myname.indexOf("Cheque_Due_date")!=-1)
							{
								if(timeDiffPassport < 0) 
								{
									alert(" ChequeDuedate should be future date.");
									iframeDocument.getElementById(myname).value = "";
									return false;	
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
	function setSubCategory(selectedValue,ProductType,cat_Subcat)
	{
		/*if(selectedValue=='--Select--')
		{
			document.getElementById(ProductType).disabled=true;
			document.getElementById(ProductType).selectedIndex=0;
			return;
		}
		document.getElementById(ProductType).innerHTML = "";
		var select = document.getElementById(ProductType);

		document.getElementById(ProductType).disabled=false;
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
		document.getElementById(ProductType).value=selectedValue;
	
	}
	
	function HistoryCaller()
	{
		//For loading history
		var hist_table="usr_0_tf_wihistory";
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
		//var ProductCategory=document.getElementById("wdesk:ProductCategory").value;
		//var ProductType=document.getElementById("wdesk:Product_Category").value;
		openWindow("../TF_Specific/history.jsp?WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&hist_table="+hist_table,'wihistory','directories=no,titlebar=no,toolbar=no,location=no,status=no,menubar=no,resizable=no,width=800,height=400');
		var WSNAME = '<%=WSNAME%>'; //added by shamily to fetch opsmaker remarks
		if (WSNAME=='Q4')
			document.getElementById('flagForDecHisButton').value = 'Yes';
		
		document.getElementById('DecisionHistoryFlag').value = 'true';
		
	}		
	function validate(ColumnCopy)
	{ //alert('Testing');
		try{	
			//document.getElementById("Fetch").disabled=true;
			document.getElementById("wdesk:Product_Category").value=document.getElementById("Product_Category").value;
			//document.getElementById("wdesk:CIF_ID").value=document.getElementById("Cifnumber").value;
			document.getElementById("wdesk:Product_Type").value=document.getElementById("Product_Type").value;
			document.getElementById("wdesk:Channel").value=document.getElementById("Channel").value;
			var panNo=document.getElementById(ColumnCopy).value;
			var CIF_ID="";
			var SavedCIF = document.getElementById("wdesk:CIF_ID").value;
			if(SavedCIF!='')
			CIF_ID=SavedCIF;
			else
			CIF_ID = document.getElementById("Cifnumber").value;
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("emiratesid").value;
			/*if(document.getElementById("Channel").value=="--Select--")
			{
				alert("Channel is Mandatory");
				document.getElementById("Channel").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}*/
/* 			if(document.getElementById("Product_Category").value=="--Select--")
			{
				alert("ProductCategory is Mandatory");
				document.getElementById("Product_Category").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			} */
			if(document.getElementById("ProductType_search").value=="" && document.getElementById("Product_Category").value=="--Select--")
			{
				alert("ProductType is Mandatory");
				document.getElementById("ProductType_search").focus();
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			if ((CIF_ID == "") && (account_number == "") && (loan_agreement_id == "") && (card_number == "") && (emirates_id == "")) 
			{
			alert("Please enter the Emirates ID/Loan Agreement Id/Card Number/CIF Number/ A/c No. ");
			document.getElementById("Fetch").disabled=false;
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
			
			document.getElementById("Product_Category").disabled=true;
			document.getElementById("ProductType_search").disabled=true;
			document.getElementById("Channel").disabled=true;
		    //document.getElementById(ColumnCopy).disabled=true;			
			
			//Getting all hidden parameter from database			
			if(!loadAllHiddenParamForServiceRequest())
			return false;
			//*****************************************	
			if(document.getElementById("wdesk:DOCUMENT_TYPE").value =='' || document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value =='')
			{
				document.getElementById("wdesk:DOCUMENT_TYPE").value='INVOICE';	
				document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value='INVOICE';							
			}
			
			document.getElementById("Fetch").disabled=true;
			
			// getting decision based on Route ProductCategory
			//setdecision();
			//*****************************************
			var ProductType  = document.getElementById("wdesk:Product_Type").value;
			var subCategoryCode  = document.getElementById("wdesk:ServiceRequestCode").value;
			//Load Document Grid on CSO WS based on ServiceRequest
			loadDocuments('<%=WSNAME%>',subCategoryCode);			
			
			//Load ChecklistCombo Value on CSO WS based on ServiceRequest
			loadChecklistCombo('<%=WSNAME%>',subCategoryCode);
			
			var WINAME=document.getElementById("wdesk:WI_NAME").value;
			//Highlightning the selected CheckListCombo value
			//setting the default value as branch on CIF search
			document.getElementById("Checklist_For").value="Branch";
			document.getElementById("wdesk:ChecklistFor").value=document.getElementById("Checklist_For").value;	
			selectitemschecklist();
			loadChecklistdropdown(WINAME,'<%=WSNAME%>',document.getElementById("wdesk:ChecklistFor").value);	
			
			//alert("ColumnCopy2");
			
			var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;
			//var WS=document.getElementById("wdesk:WS_NAME").value;
			var WS='<%=WSNAME%>';
			var ProductCategory = document.getElementById("wdesk:Product_Category").value;			
			var frmData = document.getElementById("frmData");
			//alert("ColumnCopy3");
			if(ProductCategory=='Cards')
			{	
				//alert("ColumnCopy4");
				//alert("before"+panNo);
				panNo = Encrypt(panNo);
				document.getElementById("wdesk:encryptedkeyid").value = panNo;
				//alert(panNo);
			}
			//alert("ColumnCopy5");
			var sUrl="../TF_Specific/BPM_CommonBlocksDebitCard.jsp?load=firstLoad&panNo="+panNo+"&WS="+WS+"&ProductCategory="+ProductCategory+"&ProductType="+ProductType+"&WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&FlagValue=N"+"&subCategoryCode="+subCategoryCode;
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
	function ClearFields(savedFlagFromDB)
	{
		//alert("document.getElementById(IsSavedFlag).value="+document.getElementById("IsSavedFlag").value);
		if(!(savedFlagFromDB=='Y' || document.getElementById("IsSavedFlag").value=='Y'))
		{
			//alert("inside(IsSavedFlag).value=");
			//document.getElementById("ProductCategory").disabled=false;
			document.getElementById("Product_Category").selectedIndex=0;
			document.getElementById("Product_Type").disabled=true;
			document.getElementById("Product_Type").selectedIndex=0;
			//document.getElementById("Channel").disabled=false;
			//document.getElementById("Channel").selectedIndex=0;
			document.getElementById("Cifnumber").disabled=false;
			document.getElementById("Cifnumber").readOnly=false;
			document.getElementById("Cifnumber").value="";			
			document.getElementById("Fetch").disabled=false;
			document.getElementById("Event_Button").disabled=false;
			document.getElementById("emiratesid").value="";
			document.getElementById("Cifnumber").value="";
			document.getElementById("accountNo").value="";
			document.getElementById("cardno").value="";
			document.getElementById("loanaggno").value="";	
			document.getElementById("ProductType_search").value="";	
			document.getElementById("ProductType_search").disabled=false;	
			document.getElementById("InitiationSource").value="";
			
			document.getElementById("wdesk:CIF_ID").value="";
			document.getElementById("wdesk:Name").value="";
			document.getElementById("wdesk:SubSegment").value="";
			document.getElementById("wdesk:ARMCode").value="";
			document.getElementById("wdesk:RakElite").value="";	
			document.getElementById("wdesk:EmiratesIDHeader").value="";	
			document.getElementById("wdesk:EmiratesIdExpDate").value="";	
			document.getElementById("wdesk:TLIDHeader").value="";	
			document.getElementById("wdesk:TLIDExpDate").value="";	
			document.getElementById("PrefAddress").value="";	
			document.getElementById("Channel").value="--Select--";	
			document.getElementById("wdesk:MobileNo").value="";	
			document.getElementById("LodgementDate").value="";
			document.getElementById("wdesk:ApplicationDate").value="";
			document.getElementById("IslamicOrconventions").value="";
			document.getElementById("wdesk:PrimaryEmailId").value="";	
			document.getElementById("doccollectionbranch").value="--Select--";	
			document.getElementById("branchDeliveryMethod").value="--Select--";	
			//document.getElementById("ApplicationDate").value="";	
			document.getElementById("wdesk:Secondary_RM_Code").value="";	
			document.getElementById("wdesk:SM").value="";	
						
			
			document.getElementById("emiratesid").disabled=false;;
			document.getElementById("Cifnumber").disabled=false;;
			document.getElementById("accountNo").disabled=false;;
			document.getElementById("cardno").disabled=false;;
			//document.getElementById("loanaggno").disabled=false;;	
			
			document.getElementById("dispatchHeader").style.display="none";
			//document.getElementById("DocumentTable").style.display="none";
			//document.getElementById("DocumentGRid").style.display="none";
			
			//For UTC Grid
			document.getElementById("UTCDetailsHeader").style.display="none";
			document.getElementById("UTCDtlsGrid1").style.display="none"; 	
			document.getElementById("UTCDetailsGrid").style.display="none"; 	
			document.getElementById("UTCDtlsButtonGrid").style.display="none"; 	
			document.getElementById("UTCDtlsGrid2").style.display="none";
			document.getElementById("UTCDetailsDivHeader1").style.display="none";
			document.getElementById("UTCDetailsDivHeader2").style.display="none";
			document.getElementById("UTCDetailsDivHeader3").style.display="none";
			
			//Clearing Checklist Field
			document.getElementById('Checklist_For').length=0;
			values ="--Select--";				 
			var opt = document.createElement("option");
			opt.text = values;
			opt.value =values;
			document.getElementById('Checklist_For').options.add(opt);
			//Clearing CheckList Grid Values
			var table = document.getElementById("checklistGrid");
			var rowCount = table.rows.length;
			if(rowCount!=1)
			{
				for(var i=1;i<rowCount;i++)
				{				
					table.deleteRow(1); //Just delete the row					
				}
			}
			
			//Clearing NoOfPagesScanned field
			document.getElementById("wdesk:NoOfPagesScanned").value="";
			//Clearing Document Grid Values
			var table = document.getElementById("DocumentGRid");			
			var rowCount = table.rows.length;
			if(rowCount!=1)
			{
				for(var i=1;i<rowCount;i++)
				{				
					table.deleteRow(1); //Just delete the row					
				}
			}
			
			//Clearing event detials Grid Values
			var table = document.getElementById("EventDetailsGrid");
			var rowCount = table.rows.length;
			if(rowCount!=1)
			{
				for(var i=1;i<rowCount;i++)
				{				
					table.deleteRow(1); //Just delete the row					
				}
			}
			document.getElementById("EventGrid").style.height="50px";
			//*********************************
					
			var frmData = document.getElementById("frmData");
			frmData.src="../TF_Specific/BPM_blank.jsp";
			document.getElementById("mainEmiratesId").innerHTML=""; 
			document.getElementById("duplicateWorkitemsId").innerHTML=""; 
			frmData.style.display ='none';
			
			// clearing below fields value on clear button, values will be set onblur of below fields
			document.getElementById("wdesk:ReferenceNumber").value="";
			document.getElementById("wdesk:Currency").value="";
			document.getElementById("wdesk:Amount").value="";
			document.getElementById("wdesk:CCY_Amount").value="";
			document.getElementById("wdesk:Issuance_LinkWorkItem").value="";
			
		}
		else
		{
		alert("This case has been saved. It cannot be cleared!");
		document.getElementById("Clear").disabled=true;
		}
	}
	function DiscardWI()
	{
		//alert(document.getElementById("ProductType").value);
		if(document.getElementById("ProductType").value!='Balance Transfer' && document.getElementById("ProductType").value!='Credit Card Cheque'    && document.getElementById("ProductType").value!='Blocking of Cards')
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
	alert("Case cannot be discarded for " + document.getElementById("ProductType").value);
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
		//$(#wdesk.input).attr("disabled","disabled");
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var TEMPWINAME=document.getElementById("wdesk:TEMP_WI_NAME").value;

				
		if(WSNAME=="CSO")
			setSubCategory(document.getElementById("wdesk:Product_Category").value, 'Product_Type', document.getElementById("cat_Subcat").value);
		document.getElementById("Product_Type").value=document.getElementById("wdesk:Product_Type").value;
		document.getElementById("ProductType_search").value=document.getElementById("wdesk:Product_Type").value;
		document.getElementById("Product_Category").value=document.getElementById("wdesk:Product_Category").value;
		document.getElementById("Channel").value=document.getElementById("wdesk:Channel").value;
		document.getElementById("Channel").selectedIndex=1;
		//document.getElementById("CifId").value=document.getElementById("wdesk:CIF_ID").value;	
		var ProductCategory = document.getElementById("wdesk:Product_Category").value.split(' ').join('_');
		var ProductType  = document.getElementById("wdesk:Product_Type").value.split(' ').join('_');
		
		var frmData = document.getElementById("frmData");
		var iframeDocument = (frmData.contentDocument) ? frmData.contentDocument : frmData.contentWindow.document;
		document.getElementById("Product_Category").disabled=true;
		document.getElementById("Product_Type").disabled=true;
		document.getElementById("Channel").disabled=true;
		
		
		// making ProductType search field enable when item submitted from omniscan without selecting SubCategry
		if(WSNAME=="CSO" && document.getElementById("ProductType_search").value == "")
		{
			document.getElementById("ProductType_search").disabled=false;
			document.getElementById("ProductType_search").value='';
			setAutocompleteData();
		} else {
			document.getElementById("ProductType_search").disabled=true;
		} 	
		
		//added for making branch delivery and courier awr number disabled on 2nd load on CSO WS 
	
		if(WSNAME=='CSO' && Flag=='Y')
		{
			//alert("disabling ModeOfDelivery Grid on CSO");
			document.getElementById("branchDeliveryMethod").disabled=true;
			document.getElementById("wdesk:CourierAWBNumber").disabled=true;
			document.getElementById("wdesk:CourierCompanyName").disabled=true;
			document.getElementById("doccollectionbranch").disabled=true;
			document.getElementById("wdesk:BranchAWBNumber").disabled=true;
			
			if (document.getElementById("wdesk:Islamic_Or_conventions").value == '' || document.getElementById("wdesk:Islamic_Or_conventions").value == '--Select--')
			{
				document.getElementById("IslamicOrconventions").selectedIndex = 2;
				document.getElementById("wdesk:Islamic_Or_conventions").value = 'Conventional';
			}
		}
		//added for making modeofdelivery grid disabled on other WS except TF_Maker & CSO Reject 
		/*if(WSNAME=='TF_Maker' || WSNAME=='CSO_Reject')
		{
			//alert("enable ModeOfDelivery Grid");
			document.getElementById("branchDeliveryMethod").disabled=false;
			document.getElementById("wdesk:CourierAWBNumber").disabled=false;
			document.getElementById("wdesk:CourierCompName").disabled=false;
			document.getElementById("doccollectionbranch").disabled=false;
		}
		else
		{
			//alert("disabling ModeOfDelivery Grid");
			document.getElementById("branchDeliveryMethod").disabled=true;
			document.getElementById("wdesk:CourierAWBNumber").disabled=true;
			document.getElementById("wdesk:CourierCompName").disabled=true;
			document.getElementById("doccollectionbranch").disabled=true;
		}*/
		
		//Below condition is for when case will be initiated by omniscan in case data will be already saved in database hence callJsp will be called and it fetch data without CIFID provided
		if(document.getElementById("wdesk:CIF_ID").value=='' && WSNAME=="CSO")
		return false;
		//*****************************************************
		
		if(WSNAME=="CSO" && ViewMode!="R")
			document.getElementById("Fetch").disabled=true;
		var WSNAME='<%=WSNAME%>';
		if(WSNAME=="CSO")
		{
			reloadCifGridBySavedCifid();
			// seting values in below field onblur of respective dynamic fields, hence making it blank if already saved
			document.getElementById("wdesk:ReferenceNumber").value=='';
			document.getElementById("wdesk:Currency").value=='';
			document.getElementById("wdesk:Amount").value=='';
			document.getElementById("wdesk:CCY_Amount").value=='';
			document.getElementById("wdesk:Issuance_LinkWorkItem").value=='';
			//***********************************************
		}
		var subCategoryCode  = document.getElementById("wdesk:ServiceRequestCode").value;				
		
		frmData.src = "../TF_Specific/BPM_CommonBlocksDebitCard.jsp?load=SecondLoad&WS="+WSNAME+"&WINAME="+WINAME+"&TEMPWINAME="+TEMPWINAME+"&ProductCategory="+ProductCategory+"&ProductType="+ProductType+"&FlagValue="+Flag+"&ViewMode="+ViewMode+"&subCategoryCode="+subCategoryCode;	
		
		loadChecklistCombo('<%=WSNAME%>',subCategoryCode);
		var CheckListCombo="";
		if(WSNAME=="CSO")
		{
			document.getElementById("wdesk:ChecklistFor").value = 'Branch';
			document.getElementById("Checklist_For").value = 'Branch';
		}if(WSNAME=="TF_Maker")
		{
			document.getElementById("wdesk:ChecklistFor").value = 'Trade Finance Maker';
			document.getElementById("Checklist_For").value = 'Trade Finance Maker';
		}if(WSNAME=="TF_Document_Approver")
		{
			document.getElementById("wdesk:ChecklistFor").value = 'Document checker';
			document.getElementById("Checklist_For").value = 'Document checker';
		}
		if(WSNAME=="TF_Checker")
		{
			var x = document.getElementById("Checklist_For");
			for (var i = 0; i < x.options.length; i++) 
			{
				if(x.options[i].value=='Trade Finance Checker')
				{
					document.getElementById("wdesk:ChecklistFor").value = 'Trade Finance Checker';
					document.getElementById("Checklist_For").value = 'Trade Finance Checker';
					break;
				}
			}
		}
		var CheckListCombo= document.getElementById("wdesk:ChecklistFor").value;	
		//Highlightning the selected CheckListCombo value
		if(CheckListCombo != '')
			selectitemschecklist();
		loadChecklistdropdown(WINAME,'<%=WSNAME%>',CheckListCombo);	
		if (loadDocumentGrid(WINAME,Flag,WSNAME) == false)
			loadDocuments('<%=WSNAME%>',subCategoryCode);
		enableDisable(WSNAME);
		disabledecision(WSNAME);
		disablegridColumn(WSNAME);
		
		disableAllFieldsAtNextWorkstep();
		SelectElement();

		if(document.getElementById("wdesk:Document_Dispatch_Required").value=='Y')
		{
			document.getElementById("dispatchHeader").style.display="block";
		}
		if(document.getElementById("wdesk:UTCDetailsFlag").value=='Y')
		{
			document.getElementById("UTCDetailsHeader").style.display="block";
			document.getElementById("UTCDtlsGrid1").style.display="block"; 	
			document.getElementById("UTCDetailsGrid").style.display="block"; 	
			document.getElementById("UTCDtlsButtonGrid").style.display="block"; 	
			document.getElementById("UTCDtlsGrid2").style.display="block"; 
			document.getElementById("UTCDetailsDivHeader1").style.display="block"; 
			document.getElementById("UTCDetailsDivHeader2").style.display="block"; 
			document.getElementById("UTCDetailsDivHeader3").style.display="block"; 
		}
		// Making deferral weiver field disbale if its selected as NO
		if (document.getElementById("DeferralWaiverHeldCombo").value == 'N')
		{
			document.getElementById("wdesk:ApprovingAuthority").disabled=true;
			document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
			document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
			document.getElementById("DeferralExpiryDateCalImg").disabled=true;
		}
		/*document.getElementById("modeofdelivery").disabled=false;
				document.getElementById("doccollectionbranch").disabled=false;
				document.getElementById("branchDeliveryMethod").disabled=false;
				document.getElementById("wdesk:CourierAWBNumber").disabled=false;
				document.getElementById("wdesk:BranchAWBNumber").disabled=false;
				document.getElementById("ApplicationDate").disabled=true;*/
		//point 58 drop 2
		 if(WSNAME=="Del_Retention_Expire")
		   {
			document.getElementById("RetentionExpDate").disabled=false;
			document.getElementById("HoldtillDate").disabled=false;
			document.getElementById("GenerateAcknowledgement").disabled=false;
			
    	   }

		
		if(WSNAME == 'TF_Maker')
		{
			//commented as view sign validation removed on Maker and checker WS
			/* if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_maker").value = '';
			} */
			
		  document.getElementById("modeofdelivery").disabled=false;
		  var x=document.getElementById("modeofdelivery");
		  var selectedValues="";
		  for (var i = 0; i < x.options.length; i++) 
		  {
			 if(x.options[i].selected ==true)
			 {
					if(selectedValues=="")
					selectedValues=x.options[i].value;
					else                    
					selectedValues=selectedValues+"&"+x.options[i].value;
			 }            
		  }
			if(selectedValues=='Branch' || selectedValues=='Branch&Email' || selectedValues=='Email&Branch')
			{
				document.getElementById("doccollectionbranch").disabled=false;
				document.getElementById("branchDeliveryMethod").disabled = false;
				document.getElementById("wdesk:BranchAWBNumber").disabled=false;
				document.getElementById("wdesk:CourierCompanyName").disabled=true;
				document.getElementById("wdesk:CourierAWBNumber").disabled=true;
			}
			if(selectedValues=='Courier'|| selectedValues=='Courier&Email'|| selectedValues=='Email&Courier')
			{				
				document.getElementById("branchDeliveryMethod").disabled = true;
				document.getElementById("wdesk:CourierAWBNumber").disabled=false;
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("wdesk:BranchAWBNumber").disabled=true;
				document.getElementById("wdesk:CourierCompanyName").disabled=false;
			}			
		}
		else if (WSNAME == 'TF_Checker')
		{
		
			if(document.getElementById("wdesk:OPSMakerRejectFlag").value == 'Y')
			{
				document.getElementById("wdesk:sign_matched_checker").value = '';
			}
		}
		
		else if (WSNAME == 'Print_and_Dispatch')
			{
				document.getElementById("GenerateAcknowledgement").disabled=false;
			}
		
		if(document.getElementById("wdesk:Document_Dispatch_Required").value=='Y')
		{
			checkValueForModOfDelivery(); //added by siva as part of making mode of delivery non mandatory
		}
		if(WSNAME== 'CSO' || WSNAME=='TF_Document_Approver' || WSNAME=='TF_Maker')
		{
			if(document.getElementById("wdesk:DOCUMENT_TYPE").value =='' || document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value =='')
			{
				document.getElementById("wdesk:DOCUMENT_TYPE").value='INVOICE';	
				document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value='INVOICE';							
			}
			
		}

		
		if(WSNAME != "CSO")
			loadEventGrid(WSNAME,WINAME);
		
		return true;
		
		
	}
	
	
	function disableAllFieldsAtNextWorkstep()
	{
		if('<%=WSNAME%>'!="CSO")
		{
			//alert("inside load 2");
			document.getElementById("IslamicOrconventions").disabled=true;
			document.getElementById("wdesk:ApplicationDate").disabled=true;
			document.getElementById("PrefAddress").disabled=true;
			document.getElementById("emiratesid").disabled=true;
			document.getElementById("Cifnumber").disabled=true;
			document.getElementById("accountNo").disabled=true;
			document.getElementById("cardno").disabled=true;
			document.getElementById("loanaggno").disabled=true;
			document.getElementById("Fetch").disabled=true;
			document.getElementById("Channel").disabled=true;
			document.getElementById("Modify").disabled=true;
			document.getElementById("Add").disabled=true;
			document.getElementById("Delete").disabled=true;
			document.getElementById("Addcommn").disabled=true;
			document.getElementById("Modifycommn").disabled=true;
			document.getElementById("Deletecommn").disabled=true;
			document.getElementById("ReadEmiratesID").disabled=true;
			document.getElementById("wdesk:NoOfPagesScanned").disabled=true;
			//document.getElementById("InitiationSource").disabled=true;  
			
		}
			
			if('<%=WSNAME%>'=="CSM_Approval"||'<%=WSNAME%>'=="TF_Document_Approver"||'<%=WSNAME%>'=="TF_Checker"||'<%=WSNAME%>'=="TF_Call_Back"||'<%=WSNAME%>'=="TF_Hold"||'<%=WSNAME%>'=="Returned_Doc_Maker"||'<%=WSNAME%>'=="TF_Archival" ||'<%=WSNAME%>'=="Receive_Doc_Branch" ||'<%=WSNAME%>'=="Branch_Hold"||'<%=WSNAME%>'=="Deferral_Maker"||'<%=WSNAME%>'=="Deferral_Checker")
			{	
				document.getElementById("Clear").disabled=true;
												
				document.getElementById("modeofdelivery").disabled=true;
				document.getElementById("doccollectionbranch").disabled=true;
				document.getElementById("branchDeliveryMethod").disabled=true;
				document.getElementById("wdesk:CourierAWBNumber").disabled=true;
				document.getElementById("wdesk:CourierCompanyName").disabled=true;
				document.getElementById("wdesk:BranchAWBNumber").disabled=true;
				//document.getElementById("ApplicationDate").disabled=true;	
				//document.getElementById("CalApplicationDate").disabled=true;	
				document.getElementById("IslamicOrconventions").disabled=true;	
				
					
				sah();
				//$(frmData).find('input').attr('disabled', 'disabled');
				
				/*var frameEl=parent.frames['frmData'];
				var inputs=frameEl.document.getElementsByTagName('input');
				for(var i=0;i<=inputs.length;i++)
				{
					inputs[i].disabled=true;				
				}*/
			}
			if('<%=WSNAME%>'=="TF_Maker"|| '<%=WSNAME%>'=="CSO_Reject" || '<%=WSNAME%>'=="Print_and_Dispatch")
			{
				document.getElementById("Clear").disabled=true;
				  
				/*if('<%=WSNAME%>'!="Q2")  //added by shamily to make view signatures button enable
				{
					document.getElementById("viewSign").disabled=true;
				}	*/
				/*document.getElementById("modeofdelivery").disabled=false;
				document.getElementById("doccollectionbranch").disabled=false;
				document.getElementById("branchDeliveryMethod").disabled=false;
				document.getElementById("wdesk:CourierAWBNumber").disabled=false;
				document.getElementById("wdesk:BranchAWBNumber").disabled=false;
				document.getElementById("ApplicationDate").disabled=true;*/
				//document.getElementById("CalApplicationDate").disabled=true;
				//document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
				
				sah();
				//checkDuplicateWorkitemsOnLoadAtNextWorkstep();
			}
				
			if('<%=WSNAME%>'=="CSO"|| '<%=WSNAME%>'=="Returned_Doc_Checker" || '<%=WSNAME%>'=="TF_Maker")
			{
				document.getElementById("wdesk:NoOfPagesScanned").disabled=false;
			}
			
			document.getElementById("emiratesid").disabled=true;
			setDateOnly("wdesk:ApplicationDate");
			setDateOnly("HoldtillDate");	
			setDateOnly("wdesk:DeferralExpiryDate");			
		  
			//setDateOnly("wdesk:DeferralExpiryDate");
			//setDateOnly("wdesk:HoldTillDate");
			
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

			var url = "/TF/CustomForms/TF_Specific/getDuplicateWorkitems.jsp";

			var param = "WI_NAME=" + ProcessInstanceId+"&WSNAME="+WSNAME+"&reqType=DuplicateWI";

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
					else
					{
						document.getElementById("duplicateWorkitemsId").innerHTML=ajaxResult;
						alert("Duplicates are identified for this request");
					}
			} 
			else 
			{
				alert("Problem in getting duplicate workitems list."+xhr.status);
				return false;
			}		
	}
	
	
	function getQueueList()
	{	
			var Decision =document.getElementById("wdesk:Decision").value;
			//var WSNAME =document.getElementById("wdesk:WS_NAME").value;
			var xhr;
			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = "/TF/CustomForms/TF_Specific/DropDownLoad.jsp";

			var param = "Decision=" + Decision+"&reqType=GetQueue";

			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
					ajaxResult = "--Select--~"+xhr.responseText;
										
					var select=document.getElementById("selectQueue");
					var a = ajaxResult.split("~");
					$("select#selectQueue").empty();
					

					for (var i = 0; i < a.length; i++) {
					//alert(a[i])
					$("select#selectQueue").append($("<option>").val(a[i]).html(a[i]))	;				
					}
					
			} 
			else 
			{
				alert("Problem in getting queue list."+xhr.status);
				return false;
			}		
	}
	function getUserList()
	{	
			var Decision =document.getElementById("wdesk:Decision").value;
			var QueueName =document.getElementById("wdesk:Queue_Values").value;
			//var WSNAME =document.getElementById("wdesk:WS_NAME").value;
			if(QueueName=='CreditApp_OR_Analyst' && Decision=='Send within Credit')
			{
				var xhr;
				if (window.XMLHttpRequest)
					xhr = new XMLHttpRequest();
				else if (window.ActiveXObject)
					xhr = new ActiveXObject("Microsoft.XMLHTTP");

				var url = "/TF/CustomForms/TF_Specific/DropDownLoad.jsp";
				
				var param = "Decision=" + Decision+"&WSNAME=" + QueueName+"&reqType=GetUsers";

				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);
				
				if (xhr.status == 200 && xhr.readyState == 4) 
				{
						ajaxResult = "--Select--~"+xhr.responseText;
											
						var select=document.getElementById("selectUser");
						var a = ajaxResult.split("~");
						$("select#selectUser").empty();

						for (var i = 0; i < a.length; i++) 
						{
						
							$("select#selectUser").append($("<option>").val(a[i]).html(a[i]))	;				
						}
						
				} 
				else 
				{
					alert("Problem in getting user list."+xhr.status);
					return false;
				}
			}		
	}
	function setBuyerOrSupplier()
	{
		if(document.getElementById('CUSTOMER_BUYER_OR_SUPPLIER').value=='BUYER')
		{
			var BuyerName = document.getElementById('BuyerName');
			BuyerName.value = document.getElementById('wdesk:CUSTOMER_NAME').value;
			document.getElementById('SupplierName').value='';
		}	
		else if(document.getElementById('CUSTOMER_BUYER_OR_SUPPLIER').value=='SUPPLIER')
		{
		    var SupplierName = document.getElementById('SupplierName');
			SupplierName.value = document.getElementById('wdesk:CUSTOMER_NAME').value;
			document.getElementById('BuyerName').value='';
		}
		else
		{
			document.getElementById('BuyerName').value='';
			document.getElementById('SupplierName').value='';
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
		//view sign added on CSO and commented on TF maker and checker WS 12112018
		if(wsname == 'CSO') 
		{
			document.getElementById('wdesk:sign_matched_CSO').value = signMatchStatus;
		}
		/* else if(wsname == 'TF_Maker') 
		{
			document.getElementById('wdesk:sign_matched_maker').value = signMatchStatus;
		}
		else if (wsname == 'TF_Checker') 
		{
			document.getElementById('wdesk:sign_matched_checker').value = signMatchStatus;
		} */
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
		document.getElementById("Channel").disabled=true;
		document.getElementById("branchDeliveryMethod").disabled=true;
		document.getElementById("wdesk:CourierAWBNumber").disabled=true;
		document.getElementById("wdesk:BranchAWBNumber").disabled=true;
		//document.getElementById("wdesk:CourierCompName").disabled=true;
		document.getElementById("doccollectionbranch").disabled=true;

		//document.getElementById("ProductCategory").selectedIndex=1;
		//setSubCategory(document.getElementById("ProductCategory").value,'Product_Type',document.getElementById("cat_Subcat").value.replace(", ", ","));
		document.getElementById("Channel").selectedIndex=1;	
		if (document.getElementById("wdesk:Islamic_Or_conventions").value == '' || document.getElementById("wdesk:Islamic_Or_conventions").value == '--Select--')
		{
			document.getElementById("IslamicOrconventions").selectedIndex = 2;
			document.getElementById("wdesk:Islamic_Or_conventions").value = 'Conventional';
		}
		document.getElementById('wdesk:DeferralWaiverHeld').value='N';//Default value of this field is N
		document.getElementById("wdesk:ApprovingAuthority").disabled=true;
		document.getElementById("wdesk:DocumentTypedeferred").disabled=true;
		document.getElementById("wdesk:DeferralExpiryDate").disabled=true;
		document.getElementById("DeferralExpiryDateCalImg").disabled=true;
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
	
	function selectitemschecklist() 
	{
		  var select = document.getElementById("Checklist_For");
		  var savedValue=document.getElementById('wdesk:ChecklistFor').value;
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
		
		var IslamicOrconventions = document.getElementById('IslamicOrconventions');
		if(document.getElementById('wdesk:Islamic_Or_conventions').value!='')
		IslamicOrconventions.value = document.getElementById('wdesk:Islamic_Or_conventions').value;
		
		var selectDecision = document.getElementById('selectDecision');
		if(document.getElementById('wdesk:Decision').value!='')
		selectDecision.value = document.getElementById('wdesk:Decision').value;
		
		var selectQueue = document.getElementById('selectQueue');
		if((document.getElementById('wdesk:Queue_Values').value!='') || (document.getElementById('wdesk:Queue_Values').value!='--Select--'))
		selectQueue.value = document.getElementById('wdesk:Queue_Values').value;
		
		var selectUser = document.getElementById('selectUser');
		if(document.getElementById('wdesk:User_Values').value!='')
		selectUser.value = document.getElementById('wdesk:User_Values').value;
	
	//CR-26052021--
	    
		var InitiationSource = document.getElementById('InitiationSource');
		if(document.getElementById('wdesk:Initiation_source').value!='')
		InitiationSource.value = document.getElementById('wdesk:Initiation_source').value;
	

		var CUSTOMER_BUYER_OR_SUPPLIER = document.getElementById('CUSTOMER_BUYER_OR_SUPPLIER');
		if((document.getElementById('wdesk:CUSTOMER_BUYER_OR_SUPPLIER').value!='')||(document.getElementById('wdesk:CUSTOMER_BUYER_OR_SUPPLIER').value!='--Select--'))
			CUSTOMER_BUYER_OR_SUPPLIER.value = document.getElementById('wdesk:CUSTOMER_BUYER_OR_SUPPLIER').value;

		var OVERRIDE = document.getElementById('OVERRIDE');
		if((document.getElementById('wdesk:OVERRIDE').value!='')||(document.getElementById('wdesk:OVERRIDE').value!='--Select--'))
			OVERRIDE.value = document.getElementById('wdesk:OVERRIDE').value;   
		/*if(WSNAME=="Q8")//Branch Hold
		{
			//select the decision Submit by default.
			document.getElementById("selectDecision").value='Submit';	
			document.getElementById("wdesk:Decision").value='Submit';	
			document.getElementById("selectDecision").disabled=true;			
		} */
		var elementDeferralWaiverHeldCombo = document.getElementById('DeferralWaiverHeldCombo');
		if(document.getElementById('wdesk:DeferralWaiverHeld').value!='')
		{	if(document.getElementById('wdesk:DeferralWaiverHeld').value=='N')
			elementDeferralWaiverHeldCombo.value ='N';
			if(document.getElementById('wdesk:DeferralWaiverHeld').value=='Y')
			elementDeferralWaiverHeldCombo.value ='Y';
			else
			elementDeferralWaiverHeldCombo.value =document.getElementById('wdesk:DeferralWaiverHeld').value;
		}
	}

	function reloadCifGridBySavedCifid()
	{
		
	   var SavedCIF=document.getElementById("wdesk:CIF_ID").value;
	   var SavedCIFValues = document.getElementById("wdesk:CIF_ID").value+"#"+document.getElementById("wdesk:Name").value+"#"+document.getElementById("wdesk:SubSegment").value+"#"+document.getElementById("wdesk:ARMCode").value+"#"+document.getElementById("wdesk:RakElite").value;
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
	function setDateOnly(id){
		
			document.getElementById(id).value = document.getElementById(id).value.substring(0, 10);
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
		var ws_name = '<%=WSNAME%>';
		//var sOptions = 'width=950px;height=650px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
		
		//fine
		//var sOptions = 'dialogWidth:450px; dialogHeight:450px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
		
		//perfectly fine
		//var sOptions = 'width=950px;height=650px; dialogLeft:450px; dialogTop:100px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:yes; titlebar:no;';
		
		
		var sOptions = 'left=300,top=200,width=850,height=650,scrollbars=1,resizable=1; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;';
		
		var url = "/TF/CustomForms/TF_Specific/OpenImage.jsp?acc_num_new="+AccountnoSig+"&ws_name="+ws_name;
		popupWindow = window.open(url, "_blank", sOptions);
	}
//**********************************************************************************//
	function getEntityDetailsCallAfterCifIdSaved()
	{
			var CIF_ID="";
			var SavedCIF = document.getElementById("wdesk:CIF_ID").value;
			if(SavedCIF!='')
			CIF_ID=SavedCIF;
			else
			CIF_ID = document.getElementById("Cifnumber").value;
		
			//Getting all hidden parameter from database			
			if(!loadAllHiddenParamForServiceRequest())
			return false;
			//*****************************************	
			if(document.getElementById("wdesk:DOCUMENT_TYPE").value =='' || document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value =='')
			{
				document.getElementById("wdesk:DOCUMENT_TYPE").value='INVOICE';	
				document.getElementById("wdesk:DOCUMENT_SUB_TYPE").value='INVOICE';							
			}
			
			// getting decision based on Route ProductCategory
			//setdecision();
			//*****************************************
			
			//*****************************************
			var subCategoryCode  = document.getElementById("wdesk:ServiceRequestCode").value;
			//Load Document Grid on CSO WS based on ServiceRequest
			//loadDocuments('<%=WSNAME%>',subCategoryCode);			
			
			//Load ChecklistCombo Value on CSO WS based on ServiceRequest
			//loadChecklistCombo('<%=WSNAME%>',subCategoryCode);
					
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("emiratesid").value;
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

			var url = "TFIntegration.jsp";

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
				document.getElementById("Cifnumber").disabled =true;
				document.getElementById("accountNo").disabled=true;
				document.getElementById("cardno").disabled=true;
				document.getElementById("loanaggno").disabled=true;	
			} 
			else 
			{
				alert("Problem in getting Entity Details.");
				return false;
			}
	}
	
	function fetchAccountDetails(selectedCifId)
	{
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
			
			//alert("xhr.status "+xhr.status);
			
			if (xhr.status == 200 && xhr.readyState == 4) 
			{
				//alert("Response "+ajaxResult);
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
				var arrayAjaxResult=ajaxResult.split("~");
				//var IsIslamicarray=arrayAjaxResult[2];
				//var IsIslamicsplitvalue = IsIslamicarray.split("`");
				//var IsIslamicsplit=IsIslamicsplitvalue[2];
				//var IsIslamic = IsIslamicsplit.split("|");
				//alert("IsIslamic"+IsIslamic[0]); 
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
					var accountNo=arrayAjaxResult[1];
					if (accountNo.length == 0)
					{
					  alert("No Account Details Found for the Given Data");
					  return;
					}
					
					//added by Siva for view signature
					var accountNosign=arrayAjaxResult[3]; // Fetching Account Number to be shown on View Signature Page - 14082017
					var AccountnoSig=accountNosign+'@';  
					document.getElementById("wdesk:AccountnoSig").value = AccountnoSig.replaceAll1('#','@');
					AccountnoSig = document.getElementById("wdesk:AccountnoSig").value;
					document.getElementById("wdesk:AccountNo").value = document.getElementById("wdesk:AccountnoSig").value;
			} 
			else 
			{
				alert("Problem in Fetching AccountDetails.");
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
            var headerCIF=document.getElementById("wdesk:CIF_ID").value;
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
			
			document.getElementById("wdesk:CIF_ID").value=ResponseData[0];
			document.getElementById("wdesk:Name").value=ResponseData[1];
			document.getElementById("wdesk:CUSTOMER_NAME").value=ResponseData[1];
			document.getElementById("wdesk:SubSegment").value=ResponseData[2];
			document.getElementById("wdesk:ARMCode").value=ResponseData[3];
			document.getElementById("wdesk:RakElite").value=ResponseData[4];	
			document.getElementById("wdesk:PrimaryEmailId").value=ResponseData[5];
			document.getElementById("wdesk:EmiratesIDHeader").value=ResponseData[6];
			document.getElementById("wdesk:EmiratesIdExpDate").value=ResponseData[7];
			document.getElementById("wdesk:CIFTYPE").value=ResponseData[8];
			//alert(document.getElementById("wdesk:CIFTYPE").value);
			document.getElementById("wdesk:TLIDHeader").value=ResponseData[9];
			document.getElementById("wdesk:TLIDExpDate").value=ResponseData[10];
			document.getElementById("wdesk:ResidentCountry").value=ResponseData[11];
			document.getElementById("wdesk:MobileNo").value=ResponseData[12];
			document.getElementById("PrefAddress").value=ResponseData[13];
			
			var ws_name = '<%=WSNAME%>';
			var wi_name = '<%=WINAME%>';
			
			var UserName = '<%=customSession.getUserName()%>';
			ajaxRequest('getMailIdOfRORM','wdesk:RO_Email_Id', UserName);
			ajaxRequest('getMailIdOfRORM','wdesk:RM_Email_Id', ResponseData[3]);
			
		if(ws_name=='CSO')
			{
				if(document.getElementById("wdesk:CIF_ID").value!='')
				{
					fetchAccountDetails(document.getElementById("wdesk:CIF_ID").value); 
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
			if(ws_name=='CSO')
			{
				if(document.getElementById("wdesk:CIF_ID").value!='')
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
				 //alert("ID "+document.getElementById("wdesk:CIF_ID").value);
				 
				 
				 
				 //fetchAccountDetails(document.getElementById("wdesk:CIF_ID").value);
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
		var numbers = '';
		var currency = document.getElementById("wdesk:Currency").value;
		if (currency == 'OMR' || currency == 'KWD' || currency == 'BHD')
			numbers = /^\d+(\.\d{0,3})?$/;
		else
			numbers = /^\d+(\.\d{0,2})?$/;
			
		if(Object.value!='')
		{
			if(!Object.value.match(numbers)) 
			{
			 alert("Please enter a valid amount");
			 Object.value='';
			 Object.focus();
			 return false;
			}
			var CommaSeparated = '';
			if (currency == 'OMR' || currency == 'KWD' || currency == 'BHD')
			{
				CommaSeparated = Number(parseFloat(Object.value).toFixed(3));
			}	
			else
			{
				CommaSeparated = Number(parseFloat(Object.value).toFixed(2));
			}	
			Object.value=CommaSeparated;
		}		
	}
	
	function validateSpecialCharacters(Object)
	{
		if(Object.value!='')
		{
			var newLength=Object.value.length;
			var maxLength=13;
			Object.value=Object.value.replace(/(\r\n|\n|\r)/gm," ");
			Object.value=Object.value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");
			if(newLength>=maxLength){
				Object.value=Object.value.substring(0,maxLength);        
			}
			Object.value=Object.value;
		}
	}
	
	function validateSpecialCharactersForRef(Object)
	{
		if(Object.value!='')
		{
			var newLength=Object.value.length;
			var maxLength=20;
			Object.value=Object.value.replace(/(\r\n|\n|\r)/gm," ");
			Object.value=Object.value.replace(/[^a-zA-Z0-9_.,&: ]/g,"");
			if(newLength>=maxLength){
				Object.value=Object.value.substring(0,maxLength);        
			}
			Object.value=Object.value;
		}
	}
	//Below Function is added for validating WI Number in dynamic service request-Link Workitem Field
	
	
	function validateWINumber(Object)
	{
		if(Object.value!='')
		{
			/*if(newLength<maxLength)
			{
				alert("LinkWI Number should be 21 digits.WI Format should be 'TF-0000000000-Process'");
				return false;
			}*/
			Object.value=Object.value.replace(/(\r\n|\n|\r)/gm," ");
			//Object.value=Object.value.replace(/[^a-zA-Z0-9-]/g,"");//regex accepts alphanumeric and '-' special character
			Object.value=Object.value.replace(/[^0-9]/g,"");//regex accepts numbers
			var newLength=Object.value.length;
			var maxLength=10;
			if(newLength > 10)
			{
				alert("LinkWI Number should be 10 digits.WI Format should be 'TF-0000000000-Process'");
				Object.focus();
				return false;
			}
			if(Object.value != "")
			{
				if(newLength>=maxLength){
					Object.value=Object.value.substring(0,maxLength);        
				}
				Object.value=Object.value;
				var remainingLength=(maxLength-newLength);
				var remainingZERO="";
				for(var i=0;i<remainingLength;i++)	
				{
					if(remainingZERO=="")
						remainingZERO="0";
					else
						remainingZERO=remainingZERO+"0";
				}				
				Object.value="TF-"+remainingZERO+Object.value+"-Process";
				var Length=Object.value.length;
				if(Length != 21)
				{
					alert("Please Enter Numbers only.WI Format should be 'TF-0000000000-Process'");
					Object.value = "";
					Object.focus();
					return false;
				}
			}
			else
			{
				alert("Please Enter Numbers only.WI Format should be 'TF-0000000000-Process'");
				Object.value = "";
				Object.focus();
				return false;
			}
			/*if(Object.value.indexOf("-")!=-1)
			{
				var WINumber=Object.value.split("-");				
				//var characters = /^[a-zA-Z ]*$/;
				if(WINumber[0].length != 2)
				{
					alert("Please Enter 2 digits Alphabets that starts With 'TF'");
					return false;
				}
				if(WINumber[1].length != 10)
				{
					alert("Please Enter 10 digits Numbers inbetween");
					return false;
				}
				if(WINumber[2].length != 7)
				{
					alert("Please Enter 7 digits Alphabets that ends With 'Process'");
					return false;
				}
				
				if (WINumber[0].indexOf("TF")== -1)
				{
					alert("Please Enter Alphabets that starts With 'TF'");
					Object.focus();
					return false;
				}
				
				var numbers = /^[0-9]+$/;
				if (WINumber[1].match(numbers))
					{
					}
				else {
					alert("Please Enter the Numbers With 10 digits after TF-");
					Object.focus();
					return false;
				}
				
				if (WINumber[2].indexOf("Process")== -1)
				{
					alert("Please Enter Alphabets that ends With 'Process'");
					Object.focus();
					return false;
				}			
			}		
			else
			{
				alert("Please Enter Valid WorkItem Number.WI Format should be 'TF-0000000000-Process'");
				//Object.value = "";
				Object.focus();  
				return false;
			}*/
		}
	}

	//below function is added for calculate Exchange Rate
	function calExchangeRate(Object)
	{
		var fieldExistsFlag = false;
		var iframe = document.getElementById("frmData");
		var iframeDocument = (iframe.contentDocument) ? iframe.contentDocument : iframe.contentWindow.document;
		var inputs = iframeDocument.getElementsByTagName("input");
		try 
		{
			for (x = 0; x < inputs.length; x++) 
			{
				var myname = inputs[x].getAttribute("id");
				if (myname == null||myname == '')
				continue;
				
				if(myname.indexOf("Exchange_Rate")!=-1 || myname.indexOf("and_CCY")!=-1 || myname.indexOf("andCCY")!=-1)
				{
					fieldExistsFlag = true;
					break;
				}
			}
		}catch (err) 
		{
			return "exception";
		}	
		
		if(fieldExistsFlag)
		{
			var amount = document.getElementById("wdesk:Amount").value;
			var currency = document.getElementById("wdesk:Currency").value;
			var CifId = document.getElementById("wdesk:CIF_ID").value;
			var Accountno = document.getElementById("wdesk:AccountNo").value;
			
			amount=amount.replaceAll1(',','');
			
			if (Accountno != '')
			{
				Accountno = Accountno.split("@");
				Accountno = Accountno[0];
			}	
			if (amount != '' && currency != '' && currency != 'AED' && currency != '--Select--' && Accountno != '')
			{
				var reqType="EXCHANGE_RATE_DETAILS";
				var wi_name='<%=WINAME%>';
				
				var xhr;
				var ajaxResult;			
				var values = "";
				if(window.XMLHttpRequest)
					 xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)
					 xhr=new ActiveXObject("Microsoft.XMLHTTP");
					 
				var url = 'TFIntegration.jsp';
				var param = "request_type=" + reqType + "&wi_name=" + wi_name +"&amount="+amount+"&currency="+currency+"&Accountno="+Accountno;
				
				xhr.open("POST", url, false);
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
				xhr.send(param);		

				if (xhr.status == 200 && xhr.readyState == 4) 
				{
					ajaxResult = xhr.responseText;
					ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');
					
					if (ajaxResult.indexOf("Exception") == 0) 
					{
						alert("Error in Exchange Rate Call");
						return false;
					}
					ajaxResult = ajaxResult.split("~");
					try 
					{
						for (x = 0; x < inputs.length; x++) 
						{
							var myname = inputs[x].getAttribute("id");
							if (myname == null||myname == '')
							continue;
							
							if(myname.indexOf("Exchange_Rate")!=-1)
							{
								iframeDocument.getElementById(myname).value = ajaxResult[0];
							}
							if(myname.indexOf("and_CCY")!=-1 || myname.indexOf("andCCY")!=-1)
							{
								iframeDocument.getElementById(myname).value = ajaxResult[1];
								document.getElementById("wdesk:CCY_Amount").value = ajaxResult[1];
							}
						}
					}catch (err) 
					{
						return "exception";
					}			
				} 
				else 
				{
					alert("Problem in getting Exchange Rate Details.");
					return false;
				}	 
			} else
			{
				if (currency == 'AED')
				{
					try 
					{
						for (x = 0; x < inputs.length; x++) 
						{
							var myname = inputs[x].getAttribute("id");
							if (myname == null||myname == '')
							continue;
							
							if(myname.indexOf("Exchange_Rate")!=-1)
							{
								iframeDocument.getElementById(myname).value = 1;
							}
							if(myname.indexOf("and_CCY")!=-1 || myname.indexOf("andCCY")!=-1)
							{
								iframeDocument.getElementById(myname).value = amount;
								document.getElementById("wdesk:CCY_Amount").value = amount;
							}
						}
					}catch (err) 
					{
						return "exception";
					}
				}
			}
		}	
	}
	 	
	// below function added only for Service Request - Request to transfer the excess balance/issuance of mangers cheque
	
	//Added by siva for handling the Decimal
	function insertDecimal(Object) 
	{
		Object.value=parseFloat(Object.value).toFixed(4);
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
				if(document.getElementById('selectDecision').value !="Islamic / Conventional ProductCategory changed")
				{
					alert("Please select 'Islamic / Conventional ProductCategory changed' as decision if the value is modified");
				
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
		function sendMail(currWS) {
			var wi_name = '<%=WINAME%>';
			var wsname = "";
			//added by stutee.mishra
			if(currWS == 'RM')
				wsname = 'RM_DocAlert'
			else
				wsname ='<%=WSNAME%>';
			//end
			var decision = document.getElementById("wdesk:Decision").value;
			var processname ='TF';
			
			var xhr;
			var ajaxResult;
			ajaxResult = "";
			var reqType = "SendMail";

			if (window.XMLHttpRequest)
				xhr = new XMLHttpRequest();
			else if (window.ActiveXObject)
				xhr = new ActiveXObject("Microsoft.XMLHTTP");

			var url = '/TF/CustomForms/TF_Specific/HandleAjaxProcedures.jsp';
			var param = 'wi_name='+wi_name+"&reqType="+reqType+"&wsname="+ wsname+"&decision="+decision+"&processname="+processname;
			xhr.open("POST", url, false);
			xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
			xhr.send(param);

			if (xhr.status == 200) {
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm, '');

				if (ajaxResult.indexOf("Exception") == 0) {
					alert("Some problem in sending email.");
					return false;
				}
				//ajaxResult=ajaxResult.replaceall('-','/');
			} else {
				alert("Error while sending email");
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
			var SavedCIF = document.getElementById("wdesk:CIF_ID").value;
			if(SavedCIF!='')
			CIF_ID=SavedCIF;
			else
			CIF_ID = document.getElementById("Cifnumber").value;
			
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("emiratesid").value;
			var wi_name = '<%=WINAME%>';
			var flag=validate('cardno');
			if(!flag)
			return false;
			
			//Getting expiry parameters from database			
			//if(!getExpiryTime())
			//return false;
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

			var url = "TFIntegration.jsp";

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
					//After fetching data from entity details calls disabling all search fields
					document.getElementById("dispatchDtl").style.display ="block";
					document.getElementById("emiratesid").disabled=true;
					document.getElementById("accountNo").disabled=true;
					document.getElementById("loanaggno").disabled=true;
					
					document.getElementById("Cifnumber").disabled=true;
					
					document.getElementById("ProductType_search").disabled=true;
					
			} 
			else 
			{
				alert("Problem in getting Entity Details.");
				document.getElementById("Fetch").disabled=false;
				return false;
			}
			
			//Added by amitabh for searchable text CR
						
			
			//Added  for autopopulating mode of delivery value based on the service request type selected
			var ServiceRequestCode = document.getElementById("wdesk:ServiceRequestCode").value;
			loadModeOfDelivery(ServiceRequestCode);
			
	}
	
	
	function getEntityDetailsOnRadioClick(selectedRadioCIF) 
	{
			
			var CIF_ID=selectedRadioCIF;
			document.getElementById("selectedcifid").value =selectedRadioCIF; //Added By Nikita on 11042018
			var account_number = document.getElementById("accountNo").value;
			var loan_agreement_id =document.getElementById("loanaggno").value;
			var card_number = document.getElementById("cardno").value;
			var emirates_id = document.getElementById("emiratesid").value;
			var wi_name = '<%=WINAME%>';
			
			
			//getwiname(CIF_ID);
			
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

			var url = "TFIntegration.jsp";

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
			var ServiceRequestType=document.getElementById("ProductType_search").value;
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
								document.getElementById("wdesk:CSMApprovalRequire").value=arrayParameters[1];
								document.getElementById("wdesk:CardSettlementProcessingRequired").value=arrayParameters[2];
								document.getElementById("wdesk:OriginalRequiredatOperations").value=arrayParameters[3];
								document.getElementById("DuplicateCheckLogic").value=arrayParameters[4];
								document.getElementById("AccountIndicator").value=arrayParameters[5];
								document.getElementById("FetchClosedAcct").value=arrayParameters[6];
								document.getElementById("wdesk:OriginalRequiredbyTFforProcessing").value=arrayParameters[7];
								var archivalPathInMaster=arrayParameters[8];
								document.getElementById("isSMSMailToBeSend").value=arrayParameters[9];
								document.getElementById("AccToBeFetched").value=arrayParameters[10];
								document.getElementById("wdesk:ServiceRequestCode").value=arrayParameters[11];
								document.getElementById("isEMIDExpiryChkReq").value=arrayParameters[12];
								document.getElementById("wdesk:Call_Back_Required").value=arrayParameters[13];
								document.getElementById("wdesk:Document_Approval_Required").value=arrayParameters[14];
								document.getElementById("wdesk:ROUTECATEGORY").value=arrayParameters[15];
								document.getElementById("wdesk:Document_Dispatch_Required").value=arrayParameters[16];
								document.getElementById("wdesk:UTCDetailsFlag").value=arrayParameters[17];
								//document.getElementById("DocumentTable").style.display="block";
								//document.getElementById("DocumentGRid").style.display="block";
								if(document.getElementById("wdesk:Document_Dispatch_Required").value=='Y')
									document.getElementById("dispatchHeader").style.display="block"; 
								if(document.getElementById("wdesk:UTCDetailsFlag").value=='Y')
								{
									document.getElementById("UTCDetailsHeader").style.display="block";
									document.getElementById("UTCDtlsGrid1").style.display="block"; 	
									document.getElementById("UTCDetailsGrid").style.display="block"; 	
									document.getElementById("UTCDtlsButtonGrid").style.display="block"; 	
									document.getElementById("UTCDtlsGrid2").style.display="block"; 	
									document.getElementById("UTCDetailsDivHeader1").style.display="block"; 	
									document.getElementById("UTCDetailsDivHeader2").style.display="block"; 	
									document.getElementById("UTCDetailsDivHeader3").style.display="block"; 	
								}
														
								
						    	if(archivalPathInMaster=='path1')
								{
									document.getElementById("wdesk:ArchivalPath").value='Omnidocs\\TradeFinance\\&<ReferenceNumber>&\\&<CIF_ID>&\\&<Product_Type>&\\&<WI_NAME>&';
									<!--CR23082017-->
									document.getElementById("wdesk:ArchivalPathRejected").value='Omnidocs\\TradeFinance\\&<ReferenceNumber>&\\&<CIF_ID>&\\Rejected\\&<Product_Type>&\\&<WI_NAME>&';
									<!--CR23082017-->
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
			var ServiceRequestType=document.getElementById("ProductType").value;
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
				document.getElementById("emiratesid").value = fetchEID();
	}
	function attachTemplateCustom(fileString,listData)
	{
		
	}
	
	
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
			
			url = '/TF/CustomForms/TF_Specific/DropDownServiceRequest.jsp';
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

// below function is written to set Dynamic variables in External table	
function setValOnBlur(object,FieldType)
{
	var fieldValue = object.value;
	if (FieldType == 'Reference')
		document.getElementById("wdesk:ReferenceNumber").value=fieldValue;
	if (FieldType == 'Currency')
		document.getElementById("wdesk:Currency").value=fieldValue;
	if (FieldType == 'Amount')
		document.getElementById("wdesk:Amount").value=fieldValue;
	if (FieldType == 'CCYAmount')
		document.getElementById("wdesk:CCY_Amount").value=fieldValue;
	if (FieldType == 'IssuanceWorkItem')
		document.getElementById("wdesk:Issuance_LinkWorkItem").value=fieldValue;
}	

function checkRemarks(id,maxLength)
{
	var value=document.getElementById(id).value;
	var newLength=value.length;
	value=value.replace(/(\r\n|\n|\r)/gm," ");
	value=value.replace(/[^a-zA-Z0-9_.,&:;!@#$%*()={}\/\-\\" ]/g,"");
	if(newLength>=maxLength){
		value=value.substring(0,maxLength);		
	}
	value=value.replace(/&/g,' and ');
	document.getElementById(id).value=value;
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
	//String ProductType="";
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
	WriteLog("tempWIAttrib--"+tempWIAttrib);
	
	String tempWIName=tempWIAttrib==null?"":tempWIAttrib.getAttribValue()==null?"":tempWIAttrib.getAttribValue().toString();
	
	WriteLog("tempWIName--"+tempWIName);
	Query="select count(*) as count from RB_TF_EXTTABLE with (nolock) where WI_NAME=:WI_NAME";
	params = "WI_NAME=="+WINAME;
	WriteLog("Query SRB-->"+Query);
				
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";		
	WriteLog("test inputData--"+inputData);
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	WriteLog("External Table Count Output-->"+outputData);
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
<% if(WSNAME.equals("CSO")&&!FlagValue.equals("Y"))
{
%>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "window.parent.checkIsFormLoaded();setFrameSize();formLoad();loadDropDownValues('<%=WSNAME%>','<%=customSession.getUserName()%>','<%=WINAME%>','<%=FlagValue%>');setAutocompleteData();" onkeydown="whichButton('onkeydown',event)">
<%
}
else
{
WriteLog("Inside Else "+WINAME);
%>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="window.parent.checkIsFormLoaded();setFrameSize();loadDropDownValues('<%=WSNAME%>','<%=customSession.getUserName()%>','<%=WINAME%>','<%=FlagValue%>');setAutocompleteData();CallJSP('<%=WSNAME%>', '<%=FlagValue%>','<%=ViewMode%>');" onkeydown="whichButton('onkeydown',event);" >
<%
}
%>

<applet name="EIDAWebComponent" id="EIDAWebComponent" CODE="emiratesid.ae.webcomponents.EIDAApplet" archive="EIDA_IDCard_Applet.jar" width="0" height="0"></applet>

<form name="wdesk" id="wdesk" method="post" visibility="hidden" >
<div class='formcontainer' style='float:left; border:1px solid gray;overflow-x:auto;overflow-y:auto;'>
<table border='1' id = "TAB_TF" cellspacing='1' cellpadding='0' width=100% >
<tr  id = "TF_Header" width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Trade Finance Request</td>
</tr>
<tr>
<td nowrap='nowrap' id='loggedinuserHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Logged In As</td>
<td nowrap='nowrap' id = 'loggedinuser' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;<%=customSession.getUserName()%></td>
<td nowrap='nowrap' id='WorkstepHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Workstep</td>

<%
	params = "";
	Query="SELECT Logical_Name FROM USR_0_TF_WORKSTEPS WHERE Workstep_Name=:Workstep_Name";
	params = "Workstep_Name=="+WSNAME;
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
			
	WriteLog("Input For Get Logical workstep Name From Table-->"+inputData);		
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	WriteLog("Output For Get Logical workstep Name From Table-->"+outputData);
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputData));
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	
	int recordcountLogical_Name = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
	if(maincode.equals("0"))
	{
		if(recordcountLogical_Name==1)
		{
			logicalWsName=WFCustomXmlResponseData.getVal("Logical_Name");
			WriteLog("logicalWsName--"+logicalWsName);
			//WriteLog("Logical Workstep Name "+WSNAME);
			if(logicalWsName.equalsIgnoreCase("CSO"))
			{
				WSNAME="CSO";
				WriteLog("Logical Workstep Name "+WSNAME);
			}
			WriteLog("Final Workstep Name "+WSNAME);
		}
	}
%>

<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' id="Workstep" width = 25%>&nbsp;<%=logicalWsName%></td>
</tr>
<!-- drop 2 point 71 -->

<tr>
<td nowrap='nowrap' id='WinameHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Workitem Number</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;<%=WINAME%></td>
<td nowrap='nowrap' id='SolIDHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;SOL Id</td>

<%
	if(WSNAME.equals("CSO"))
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
		 <td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Sol_id">&nbsp;<%=WFCustomXmlResponseData.getVal("comment")%></label></td>
		  <%
		}		
	}
	}
	else
	{
%><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><label id="Sol_id">&nbsp;<%=((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SOLID")).getAttribValue().toString()%></label></td>
 <%
	}
 %>
</tr>


<tr>
<td nowrap='nowrap' id='CifIdHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;CIF Number</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" disabled name="wdesk:CIF_ID" id="wdesk:CIF_ID" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CIF_ID")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='CustnameHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Name</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:Name" id="wdesk:Name" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Name")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Name")).getAttribValue().toString()%>'/></td>
</tr>

<tr>
<td nowrap='nowrap' id='SubSegmentHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Sub Segment</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:SubSegment" id="wdesk:SubSegment" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("SubSegment")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SubSegment")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='ARMCodeHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;ARM Code</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:ARMCode" id="wdesk:ARMCode" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("ARMCode")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ARMCode")).getAttribValue().toString()%>'/></td>
</tr>

<tr>
<td nowrap='nowrap' id='SecondaryRMHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Secondary RM Code</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:Secondary_RM_Code" id="wdesk:Secondary_RM_Code" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("Secondary_RM_Code")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Secondary_RM_Code")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='SMHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;SM</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" disabled name="wdesk:SM" id="wdesk:SM" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("SM")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("SM")).getAttribValue().toString()%>'/></td>
</tr>

<tr>
<td nowrap='nowrap' id='RAKEliteHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Rak Elite</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="5" disabled name="wdesk:RakElite" id="wdesk:RakElite" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("RakElite")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RakElite")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='ChannelHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Channel</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><%if(WSNAME.equals("CSO")){%><select width='300' name='Channel' id='Channel' style='width:167px'  >
<option value='--Select--'>--Select--</option>
<%
	params = "";
	Query="select Channel from USR_0_TF_CHANNELMAP with (nolock) where IsActive=:IsActive order by Channel desc";
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
<td nowrap='nowrap' id='EIDHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Emirates ID</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:EmiratesIDHeader" id="wdesk:EmiratesIDHeader" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EmiratesIDHeader")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmiratesIDHeader")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='EIDExpiryDtHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Emirates ID Expiry Date</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateExpiryDate(this.value);" type='text' size="22" maxlength="10" disabled name="wdesk:EmiratesIdExpDate" id="wdesk:EmiratesIdExpDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("EmiratesIdExpDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EmiratesIdExpDate")).getAttribValue().toString()%>'/></td>
</tr>
<tr>
<td nowrap='nowrap' id='TradeLicenseHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Trade License</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" disabled name="wdesk:TLIDHeader" id="wdesk:TLIDHeader" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("TradeLicNumber")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TradeLicNumber")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='TradeLicenseExpDtHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Trade License Expiry Date</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateExpiryDate(this.value);" type='text' size="22" maxlength="10" disabled name="wdesk:TLIDExpDate" id="wdesk:TLIDExpDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("TradeLicExpDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TradeLicExpDate")).getAttribValue().toString()%>'/></td>
</tr>
<tr>
<td nowrap='nowrap' id='PrimaryEmailIdHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Preferred / Primary Email Id</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="wdesk:PrimaryEmailId" id="wdesk:PrimaryEmailId" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("PrimaryEmailId")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PrimaryEmailId")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap' id='MobileNoHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Preferred Contact / Mobile Number</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50" disabled name="wdesk:MobileNo" id="wdesk:MobileNo" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("MobileNo")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("MobileNo")).getAttribValue().toString()%>'/></td>
</tr>

<tr >
<td nowrap='nowrap' id="PrefAddressHeader" class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Preferred Address
		</td>
		<td nowrap='nowrap' colspan='3' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 70%>
		<textarea disabled maxlength="3000" class='EWNormalGreenGeneral1'  style="width:'100%'" rows="3" cols="50" id="PrefAddress" name="PrefAddress"><%=((CustomWorkdeskAttribute)attributeMap.get("PrefAddress")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("PrefAddress")).getAttribValue().toString()%></textarea>
		</td>
</tr>
<tr>
<td nowrap='nowrap' id='LodgementDateHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp; Lodgement Date</td>

<%
	if(WSNAME.equals("CSO"))
	{
	WriteLog("inside lodgement date");	
	
	SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");  
    Date date = new Date();  
    System.out.println("formatter.format(date)"+formatter.format(date)); 
	WriteLog("formatter.format(date)"+formatter.format(date));	
	
	 %>	
	 <td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
	 <input class = 'NGReadOnlyView'  onblur="" type='text' size="22" maxlength="100"   name="LodgementDate" disabled id="LodgementDate" value ='<%=formatter.format(date)%>'/>
<%	}
	else
	{
%><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		 <input class = 'NGReadOnlyView'  onblur="" type='text' size="22" maxlength="100"   name="LodgementDate" disabled id="LodgementDate" value ='<%=((CustomWorkdeskAttribute)attributeMap.get("LodgementDate")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("LodgementDate")).getAttribValue().toString()%>'/>
<%
	}
 %>

<!--<img class = 'NGReadOnlyView' id = 'CalllodgeDate' style="cursor:pointer" src='/TF/webtop/images/cal.gif' style="float:center;" onclick = "initialize('LodgementDate');" width='16' height='16' border='0' alt=''>-->
</td>
<td nowrap='nowrap' id='ApplicationDateHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp; Application Date *</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input class = 'NGReadOnlyView'  onchange="validateAppDate(this.value,'ApplicationDate');" type='text' size="22" maxlength="100" name="wdesk:ApplicationDate" id="wdesk:ApplicationDate" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("ApplicationDate")).getAttribValue().toString()%>'/>
<% 	CustomWorkdeskAttribute ApptempWIAttrib=((CustomWorkdeskAttribute)attributeMap.get("ApplicationDate"));

WriteLog("ApptempWIAttrib--"+ApptempWIAttrib);
String ApptempWIName=((CustomWorkdeskAttribute)attributeMap.get("ApplicationDate")).getAttribValue().toString();
	
	WriteLog("ApptempWIName--"+ApptempWIName);%>
<img class = 'NGReadOnlyView' id = 'CalApplicationDate' style="cursor:pointer" src='/TF/webtop/images/cal.gif' style="float:center;" onclick = "initialize('wdesk:ApplicationDate');" width='16' height='16' border='0' alt=''>
</td>

</tr>

<tr><td nowrap='nowrap' id="IslamicOrConventionalHeader" class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Islamic / Conventional * </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 70%>
		<select  class="NGReadOnlyView" style='width: 170px;' name="IslamicOrconventions" id="IslamicOrconventions" onchange="setComboValueToTextBox(this,'wdesk:Islamic_Or_conventions')" >
						<option value="">--Select--</option>
						<option value="islamic">Islamic</option>
						<option value="conventional">Conventional</option>
						
		</select></td>
		
		<td nowrap='nowrap' id="InitiationSourceHeader" class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Initiation Source* </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 70%>
		<select  class="NGReadOnlyView" style='width: 170px;' name="InitiationSource" id="InitiationSource" onchange="setComboValueToTextBox(this,'wdesk:Initiation_source')">
						<option value="">--Select--</option>
						<option value="Manual">Manual</option>
						<option value="Digital">Digital</option>
						
		</select></td>
</tr>
</table>

<table id = "Req_details" border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr  width=100% width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Request Details</td>
	</tr>
	
<tr>
	<%
	params = "";
	Query="select distinct t.[CategoryName], STUFF((SELECT distinct ', ' + convert(nvarchar(255),t1.subcategoryName) from usr_0_tf_subcategory t1 with (nolock) where t.[CategoryIndex] = t1.[parentCategoryIndex] and t1.isactive=:isactive1 FOR XML PATH(''), TYPE ).value('.', 'NVARCHAR(MAX)'),1,2,'') subcategoryName from usr_0_tf_category t with (nolock) where t.IsActive =:IsActive2";

	params = "isactive1==Y"+"~~"+"IsActive2==Y";
	 inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
	//WriteLog("inputData--->"+inputData);	
	
	outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("outputData Initiate-->"+outputData);
	String subcat_search="";
	String cat_Subcat="";
	String temp[] = null;
	ArrayList<String> ProductCategory = new ArrayList<String>();
	ArrayList<String> ProductType = new ArrayList<String>();
	
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputData));
	maincode = WFCustomXmlResponseData.getVal("MainCode");
	int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
	if(maincode.equals("0"))
	{	
		objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{ 		ProductCategory.add(objWorkList.getVal("CategoryName"));
				subcat_search=  subcat_search+objWorkList.getVal("subcategoryName")+","; // added by shamily to get all subcategories fetched
				temp = objWorkList.getVal("subcategoryName").split(",");
				cat_Subcat+=objWorkList.getVal("CategoryName")+"#"+objWorkList.getVal("subcategoryName")+"~";
				for(int i=0; i<temp.length; i++)
				{
					ProductType.add(temp[i]);
				}	
		}
		cat_Subcat=cat_Subcat.substring(0,(cat_Subcat.lastIndexOf("~")));
	}
	//WriteLog("subcat_search :"+subcat_search);
//WriteLog("sumit :"+cat_Subcat);
%>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Product Category</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><%if(WSNAME.equals("CSO")){%><select disabled="disabled" onchange="javascript:setSubCategory(this.value,'Product_Type','<%=cat_Subcat.replaceAll(", ", ",")%>');" width='300' name='Product_Category' id='Product_Category' style='width:167px'><option value='--Select--'>--Select--</option><%for(int i=0; i<ProductCategory.size(); i++){%><option value='<%=ProductCategory.get(i)%>'><%=ProductCategory.get(i)%></option>
	<%}%>
		</select><%}else{%><input type='text' name="Product_Category" id="Product_Category"  style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Category")).getAttribValue().toString()%>'/><%}%></td>
		<input type=hidden name="cat_Subcat" id="cat_Subcat" style="visibility:hidden" value='<%=cat_Subcat.replaceAll(", ", ",")%>'>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Product Type *</td>
	
		<td nowrap='nowrap' style="display:none" class='EWNormalGreenGeneral1' width = 25%><%if(WSNAME.equals("CSO")){%><select width='300' name='Product_Type' id='Product_Type' style='width:167px' ><option value='--Select--'>--Select--</option><option value='Test'>Test</option><%for(int i=0; i<ProductType.size(); i++){%><option value='<%=ProductType.get(i).trim()%>'><%=ProductType.get(i).trim()%></option><%}%></select><%}else{%><input type='text' name="Product_Type" id="Product_Type" disabled='disabled' style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Type")).getAttribValue().toString()%>'/><%}%>
								</td>
		<td nowrap='nowrap'  class='EWNormalGreenGeneral1' width = 25%><%if(WSNAME.equals("CSO")){ WriteLog("ProductType_search WSNAME :"+WSNAME);%><input type='text' name="ProductType_search" id="ProductType_search" onblur = "validatesubcat('ProductType_search','<%=subcat_search%>'),setcategory(this.value,'<%=cat_Subcat.replaceAll(", ", ",")%>'),setSubCategory(this.value,'Product_Type','');" style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Type")).getAttribValue().toString()%>'/>
		
		<input type=hidden name='AutocompleteValues' id='AutocompleteValues' style='visibility:hidden' value='<%=subcat_search%>'>
		<%
		}
		
		else{  WriteLog("ProductType_search WSNAME else :"+WSNAME);%><input type='text' name="ProductType_search" id="ProductType_search" disabled='disabled' style='width:167px' value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Type")).getAttribValue().toString()%>'/><%}%>
		</td>
		</tr>
</table>


<table id ="CIF_Search" border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">CIF Search</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Emirates ID</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 24%><input type='text' name='emiratesid'  onkeyup="" id='emiratesid' size="20" value = '' maxlength = '21' style='width:167px'><input name='EmiratesID' type='button' id='ReadEmiratesID' value='Read' onclick="" class='EWButtonRB NGReadOnlyView' style='width:35px'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;CIF Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='number' name='Cifnumber'  id='Cifnumber' onkeyup="ValidateNumericMain('Cifnumber','CIF Number');" value = '' maxlength='7' style='width:167px'>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>

<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Account No.</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='text' onkeyup="" name='accountNo'  id='accountNo' value = '' maxlength = '13' style='width:168px' >&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Card Number</td>

		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input type='text' onkeyup="" name='cardno' id='cardno' value = '' maxlength = '16' style='width:167px' >&nbsp;&nbsp;&nbsp;&nbsp;		
		</td>
		
		</td>
		
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Loan Agreement ID</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input type='text' onkeyup="" name='loanaggno'  id='loanaggno' value = '' maxlength = '24' style='width:168px' />&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%></td>
</tr>
<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%></td>		
		<td  nowrap='nowrap' class='EWNormalGreenGeneral1'>
		<input name='Fetch' type='button'  id='Fetch' value='Search' onclick="getEntityDetails();setFrameSize();" class='EWButtonRB NGReadOnlyView' style='width:70px float:right'></td>
		<td  nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;<input name='Clear' id="Clear" type='button' value='Clear' onclick="ClearFields();setAutocompleteData();" class='EWButtonRBSRM NGReadOnlyView' style='width:70px'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22'>
		<input name='viewSign' id="viewSign" type='button' value='View Signature' onclick="getSignature(this);" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>		
		</td>
</tr>
</table>
<div id="divCheckbox">  
	<div class="accordion-inner" id="mainEmiratesId">				
	</div>
</div>
<iframe border=0 src="../TF_Specific/BPM_blank.jsp" id="frmData" name="frmData" width="100%" scrolling = "no" onload='javascript:resizeIframe(this);' onresize='javascript:resizeIframe(this);'></iframe>


<table border='1' cellspacing='1' cellpadding='0' width=100% id ="ChecklistTable" >
	<tr  width=100%  class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Checklist Details</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Check List for </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" onchange="loadChecklistvalue('<%=WSNAME%>','<%=WINAME%>','Checklist_For')" width='300' name='Checklist_For' id='Checklist_For' style='width:170px' >
			<option value=''>--Select--</option>
		</select>
		</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>		
	</tr>
</table>
<br/>

<div id="divchecklistGrid" style="border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="checklistGrid">
		<tr><th  width='10%' class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">SR No</font></b></th><th  width='40%' class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Checklist Description</font></b></th><th  width='20%'class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Option Checklist</font></b></th><th  width='40%' class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Remarks</font></b></th></tr>
	</table>
</div>
<!---Document Details -->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="DocumentTable">
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Document Details</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;No of Pages Scanned </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="3"  name="wdesk:NoOfPagesScanned" id="wdesk:NoOfPagesScanned" onkeyup="ValidateNumeric('wdesk:NoOfPagesScanned')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("NoOfPagesScanned")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("NoOfPagesScanned")).getAttribValue().toString()%>'/></td>
		
	
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
	
</table>
<div id="DocGrid" style="border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="DocumentGRid" >
		<tr><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Case Documents</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">No of Originals</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">No of Copies</font></b></th></tr>
	</table>
</div>

<!---Invoice Details details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="Invoicedtls">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Invoice Details</font></td>
	</tr>
</table>
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="invcdtls">
<tr>
<td nowrap='nowrap'  class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Counter Party</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50"  name="wdesk:CounterParty" id="wdesk:CounterParty" onkeyup="ValidateAlphaNumeric('wdesk:CounterParty')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CounterParty")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CounterParty")).getAttribValue().toString()%>'/></td>
<td nowrap='nowrap'  class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Invoice Number</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="50"  name="invoicenumber" id="invoicenumber" onkeyup="ValidateAlphaNumeric('invoicenumber')" value = ''/></td>
</tr>
</table>
<br/>
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="Invoicegrid">
<tr>
	<td colspan="3"><input type="button" name="Add" id="Add" value="Add" onclick="addrowInvoice()" class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Modify" id="Modify" value="Modify" onclick="modifyInvoicerow()" class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Delete" 	id ="Delete" value="Delete" onclick="deleterowInvoice()" class='EWButtonRBSRM' style='width:100px'/></td></tr>
</table>
<div id ="Invoicegridadd" style="height:50px;border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="InvoiceDetailsGrid">
		<tr><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Select</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Invoice Number</font></b></th></tr>
	</table>
</div>


<!--- UTC Details--->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="UTCDetailsHeader" style="display:none">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033">
	<input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">UTC Details</font></td>
	</tr>
</table>
<div id ="UTCDetailsDivHeader1" style="display:none">

<table border='1' cellspacing='1' cellpadding='0' width=100% id ="UTCDtlsGrid1" style="display:none">
	
	<tr>
		<td nowrap='nowrap' id='BatchNoHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Batch No*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="wdesk:BATCH_NO" id="wdesk:BATCH_NO" value = '<%=WINAME%>'/></td>
		<td nowrap='nowrap' id='DocumentCountHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Document Count*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="4" name="wdesk:DOCUMENT_COUNT" id="wdesk:DOCUMENT_COUNT" onkeyup="ValidateNumericStart('wdesk:DOCUMENT_COUNT','Document Count'),ValidateNumeric('wdesk:DOCUMENT_COUNT')" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("DOCUMENT_COUNT")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DOCUMENT_COUNT")).getAttribValue().toString()%>'/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' id='DocTypeHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Document Type*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="wdesk:DOCUMENT_TYPE" id="wdesk:DOCUMENT_TYPE" value ='<%=((CustomWorkdeskAttribute)attributeMap.get("DOCUMENT_TYPE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DOCUMENT_TYPE")).getAttribValue().toString()%>'/></td>
		<td nowrap='nowrap' id='DocumentCountHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Document Sub Type*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="wdesk:DOCUMENT_SUB_TYPE" id="wdesk:DOCUMENT_SUB_TYPE" value ='<%=((CustomWorkdeskAttribute)attributeMap.get("DOCUMENT_SUB_TYPE")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("DOCUMENT_SUB_TYPE")).getAttribValue().toString()%>'/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' id='CustnameHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Name*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="wdesk:CUSTOMER_NAME" id="wdesk:CUSTOMER_NAME" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_NAME")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_NAME")).getAttribValue().toString()%>' onblur="setBuyerOrSupplier();"/></td>
		<td nowrap='nowrap' id='CustnameHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Tax No</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="wdesk:CUSTOMER_TAX_NO" id="wdesk:CUSTOMER_TAX_NO" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_TAX_NO")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_TAX_NO")).getAttribValue().toString()%>'/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' id='CustBuyerHeader' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Buyer or Supplier*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" onchange="setComboValueToTextBox(this,'wdesk:CUSTOMER_BUYER_OR_SUPPLIER');setBuyerOrSupplier()" width='300' maxlength="10" name='CUSTOMER_BUYER_OR_SUPPLIER' id='CUSTOMER_BUYER_OR_SUPPLIER' style='width:160px'>
			<option value=''>--Select--</option>
			<option value='BUYER'>BUYER</option>
			<option value='SUPPLIER'>SUPPLIER</option>
		</select>
		</td>
					
		<td nowrap='nowrap' id='CustTradeHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Customer Trade License No</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="wdesk:CUSTOMER_TRADE_NO" id="wdesk:CUSTOMER_TRADE_NO" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_TRADE_NO")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_TRADE_NO")).getAttribValue().toString()%>'/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Override*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" onchange="setComboValueToTextBox(this,'wdesk:OVERRIDE')" width='300' maxlength="255" name='OVERRIDE' id='OVERRIDE' style='width:160px'>
			<option value=''>--Select--</option>
			<option value='Y'>Y</option>
			<option value='N'>N</option>
		</select>
	</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
	</tr>
</table>	
</div>
<div id ="UTCDetailsDivHeader2" style="border-style: solid;border-width: thin;border-color: #990033;display:none">
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="UTCDetailsGrid" style="display:none">
		
		<tr><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Select</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Document No</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Document Date</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Currency</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Total Invoice Amount</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Buyer Name</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Supplier Name</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Line Items Count</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Ban Ref Number</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Contract No</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">PO Number</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Amount In Words</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Payment Due Date</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Billing Address</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Discount</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Tax Amount</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Tax No Supplier</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Gross Amount</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Account No</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Address Line 1</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Address Line 2</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Address City</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Address Country</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Address PO Box</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Email Address</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Supplier Website</font></b></th><th class='EWLabelRB2' bgcolor= "#990033"style="display:none"><b><font color="white">Supplier Telephone</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Telephone</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Account No</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Address Line 1</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Address Line 2</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Address City</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Address Country</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Address PO Box</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Email Address</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Buyer Website</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Line Item Description</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">HS Code</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Unit Price</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Subtotal Amount</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Quantity</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">Line No</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="display:none"><b><font color="white">UOM</font></b></th></tr>
	</table>
</div>
<table id="UTCDtlsButtonGrid" style="display:none">
	<td colspan="3"><input type="button" name="Add" id="AddUTC" value="Add" onclick='addrowUTC("<%=WSNAME%>",this.id,"")' class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Modify" id="ModifyUTC" value="Modify" onclick='modifyrowUTC("<%=WSNAME%>")' class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Delete" id ="DeleteUTC" value="Delete" onclick='deleteUTCRow()' class='EWButtonRBSRM' style='width:100px'/><input type="hidden" name="utcSelectedRow" id ="utcSelectedRow"/></td></table>
<div id ="UTCDetailsDivHeader3" style="border-style: solid;border-width: thin;border-color: #990033;display:none">	
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="UTCDtlsGrid2" style="display:none">
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Document No*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="DocumentNo" id="DocumentNo"/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Ban Ref Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="BanRefNumber" id="BanRefNumber"/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Document Date*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" name="DocumentDate" id="DocumentDate" onBlur="validateDate(this.value,'DocumentDate');"/>&nbsp;<img src='/TF/webtop/images/cal.gif' id='TF_calendar' width='16' height='16' border='0' alt='' onclick="initialize('DocumentDate');" /></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Currency*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><select class="NGReadOnlyView" maxlength="100"  width='300'name="UTC_Currency" id="UTC_Currency" style='width:160px' onchange="loadCurrencyMaster();"/><option value=''>--Select--</option>
		</select></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Total Invoice Amount*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength='100' name='TotalInvoiceAmount'  id='TotalInvoiceAmount' value='' onblur="onBlurForDecimal(this);" onkeyup="ValidateNumericWithDot('TotalInvoiceAmount','TotalInvoiceAmount');"/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Contract No</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength='255' name='ContractNo' id='ContractNo' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;PO Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength='255' name='PONumber' id='PONumber' value='' /></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Amount In Words</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength='255' name='AmountInWords' id='AmountInWords' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Payment Due Date</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" name='PaymentDueDate' id='PaymentDueDate' onBlur="validateDate(this.value,'PaymentDueDate');"/>&nbsp;<img src='/TF/webtop/images/cal.gif' id='TF_calendar1' width='16' height='16' border='0' alt='' onclick="initialize('PaymentDueDate');" /></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Terms of Payment</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength='255' name='TermsofPayment' id='TermsofPayment' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Billing Address</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="255" name="BillingAddress" id="BillingAddress"/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Discount</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" name="Discount" id="Discount"value=''  onblur="onBlurForDecimal(this);" onkeyup="ValidateNumericWithDot('Discount','Discount');"/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Tax Amount</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength='100' name='TaxAmount'  id='TaxAmount' value='' onblur="onBlurForDecimal(this);" onkeyup="ValidateNumericWithDot('TaxAmount','TaxAmount');"/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Tax No Supplier</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22"  maxlength='255' name='TaxNoSupplier'  id='TaxNoSupplier' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Gross Amount</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='GrossAmount' size="22" maxlength='100' id='GrossAmount' value='' onblur="onBlurForDecimal(this);" onkeyup="ValidateNumericWithDot('GrossAmount','GrossAmount');" /></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Supplier Name*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierName' size="22" maxlength='255' id='SupplierName' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Supplier Account No</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierAccountNo' size="22" maxlength='255' id='SupplierAccountNo' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Supplier Address Line 1</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierAddressLine1' size="22" maxlength='255' id='SupplierAddressLine1' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Supplier Address Line 2</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierAddressLine2' size="22" maxlength='255' id='SupplierAddressLine2' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Supplier Address City</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierAddressCity' size="22" maxlength='255' id='SupplierAddressCity' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Supplier Address Country</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierAddressCountry' size="22" maxlength='255'id='SupplierAddressCountry' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Supplier Address PO Box</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierAddressPOBox' size="22"  maxlength='255' id='SupplierAddressPOBox' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Supplier Email Address</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierEmailAddress' size="22" maxlength='255' id='SupplierEmailAddress' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Supplier Website</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierWebsite' size="22" maxlength='255' id='SupplierWebsite' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Supplier Telephone</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SupplierTelephone' size="22" maxlength='255' id='SupplierTelephone' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Buyer Name*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerName' size="22"  maxlength='255' id='BuyerName' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Buyer Telephone</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerTelephone' size="22" maxlength='255' id='BuyerTelephone' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Buyer Account No</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerAccountNo' size="22" maxlength='255' id='BuyerAccountNo' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Buyer Address Line 1</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerAddressLine1' size="22" maxlength='255' id='BuyerAddressLine1' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Buyer Address Line 2</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerAddressLine2' size="22" maxlength='255' id='BuyerAddressLine2' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Buyer Address City</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerAddressCity' size="22" maxlength='255' id='BuyerAddressCity' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Buyer Address Country</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerAddressCountry' size="22" maxlength='255' id='BuyerAddressCountry' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Buyer Address PO Box</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerAddressPOBox' size="22" maxlength='255' id='BuyerAddressPOBox' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Buyer Email Address</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerEmailAddress' size="22" maxlength='255' id='BuyerEmailAddress' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Buyer Website</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='BuyerWebsite' size="22" maxlength='255' id='BuyerWebsite' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Line Items Count*</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input  class="NGReadOnlyView" type='text' name='LineItemsCount' size="22" maxlength='10' id='LineItemsCount' value='' onkeyup="ValidateNumericStart('LineItemsCount','Line Items Count'),ValidateNumeric('LineItemsCount')"/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Line Item Description</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='LineItemDescription' size="22" maxlength='255' id='LineItemDescription' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;HS Code</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='HSCode' size="22" maxlength='255' id='HSCode' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Unit Price</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='UnitPrice' size="22" maxlength='100' id='UnitPrice' value='' onblur="onBlurForDecimal(this);" onkeyup="ValidateNumericWithDot('UnitPrice','UnitPrice');"/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Subtotal Amount</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='SubtotalAmount' size="22" maxlength='255' id='SubtotalAmount' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Quantity</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='Quantity' size="22" maxlength='10' id='Quantity' value='' onkeyup="ValidateNumericStart('Quantity','Quantity'),ValidateNumeric('Quantity')"/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;Line No</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='LineNo' size="22" maxlength='255' id='LineNo' value=''/></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;UOM</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input  class="NGReadOnlyView" type='text' name='UOM' size="22" maxlength='255' id='UOM' value=''/></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
	</tr>
</table>
</div>
<!---Dispatch Details details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id = "dispatchHeader" style="display:none">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4"/>Dispatch Details</td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Mode of Delivery *</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" multiple="multiple" width='300' name='modeofdelivery' id='modeofdelivery' onclick="checkValueForModOfDelivery();" style='width:170px'>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Document Collection Branch</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select class="NGReadOnlyView" name='doccollectionbranch'  id='doccollectionbranch' onchange="setComboValueToTextBox(this,'wdesk:DocumentCollectionBranch')" onblur="mandatorycheck('doccollectionbranch')" style='width:170px'>
		<option value='--Select--'>--Select--</option>
			<%
			Query="select BRANCHNAME from RB_BRANCH_MASTER with (nolock) order by BRANCHNAME asc";
			String branch="";	
			inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
					
			WriteLog("Query For BRANCHNAME Input-->"+inputData);		
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
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Branch Delivery Method</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" name='branchDeliveryMethod'  id='branchDeliveryMethod' onchange="setComboValueToTextBox(this,'wdesk:BranchDeliveryMethod')" width = '300' style='width:170px'/>
			<option value='--Select--'>--Select--</option>
			<option value='Internal Mail'>Internal Mail</option>
			<option value='Attachment'>Attachment</option>
			</select>
		</td>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Courier AWB Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input  class="NGReadOnlyView" type='text' disabled name='wdesk:CourierAWBNumber'  id='wdesk:CourierAWBNumber' maxlength='100' style='width:170px' onkeyup="" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CourierAWBNumber")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CourierAWBNumber")).getAttribValue().toString()%>'/></td>
		
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Courier Company Name
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1'><input  class="NGReadOnlyView" type='text' name='wdesk:CourierCompanyName'  id='wdesk:CourierCompanyName' maxlength = '100' style='width:170px' onkeyup="ValidateAlphaNumeric('wdesk:CourierCompanyName')" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CourierCompanyName")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CourierCompanyName")).getAttribValue().toString()%>'/>
		</td>
		
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Branch AWB Number</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%><input  class="NGReadOnlyView" type='text' name='wdesk:BranchAWBNumber'  id='wdesk:BranchAWBNumber' value='' maxlength='100' style='width:170px' onkeyup="ValidateAlphaNumeric('wdesk:BranchAWBNumber')"/></td>		
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='GenerateAcknowledgement' id="GenerateAcknowledgement" type='button' value='GenerateAcknowledgement' disabled onclick="generatePDF('Generate_Acknowledgement');" class='EWButtonRBSRM' style='width:180px'></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%></td>
	</tr>
</table>

<div id="">  
	<div class="accordion-inner" id="duplicateWorkitemsId">				
	</div>
</div>


<table border='1' cellspacing='1' cellpadding='0' width=100% id ="evntDetails">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=7 align=center class='EWLabelRB2'><font color="white" size="4">Event Details</font></td>
	</tr>
	
	<tr>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' width=25% >
	<input name='Event_Button' id="Event_Button" type='button' value='Event Details Check' onclick="loadEventGrid('<%=WSNAME%>','<%=WINAME%>');" class='EWButtonRBSRM' style='width:180px'></td>
	</tr>
	
</table>

<div id ="EventGrid" style="border-style: solid;border-width: thin;border-color: #990033;">

	<table width=100% border='1' cellspacing='1' cellpadding='0' id ="EventDetailsGrid">
		<tr><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Date Of Event</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Application Date</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Product Category</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Product Type</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Username</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Amount</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Currency</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">WI-Name</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Possible Duplicates</font></b></th></tr>
	
	</table>
</div>

<!-- Query Details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="QueryDtls_Header">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033">
	<input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Query Details</font></td>
	</tr>
</table>
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="QueryGrid">
<tr>
	<td colspan="3"><input type="button" name="Add" id="Add_row_Query" value="Add" onclick='addrow_query("<%=WSNAME%>",this.id,"")' class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Delete_row_Query" id ="Delete_row_Query" value="Delete" onclick='Deleterow_Query()' class='EWButtonRBSRM' style='width:100px' style="visibility: hidden;"/></td></tr>
</table>
<div  style="border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="Query_Details_Grid">
		<tr>
		<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Select</font></b></th>
		<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Query</font></b></th>
		<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Credit Remarks</font></b></th>
		<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Business Remarks</font></b></th></tr>
	</table>
</div>


<!-- Firco Details-->
<!-- Hritik 06.02.2024-->

<table border='1' cellspacing='1' cellpadding='0' width=100% id ="FircoDtls_Header">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033">
		<input type='text' name='Header' readOnly size='24' style='display:none'  ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Firco Details</font></td>
	</tr>
</table>

<table border='1' cellspacing='1' cellpadding='0' width=100% id ="FircoGrid">
<tr>
	<td nowrap='nowrap' id='SecondaryRMHeader' class='EWNormalGreenGeneral1' height ='22' width = 30%>&nbsp;&nbsp;&nbsp;&nbsp;Entity Type</td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1'  height ='22' width = 30%>
		<select  class="NGReadOnlyView" width='300' name='Firco_type' id='Firco_type' style='width:170px' >
			<option value=''>--Select--</option>
			<option value='Individual'>Individual</option>
			<option value='Corporate'>Corporate</option>
			<option value='Vessel'>Vessel</option>
			<option value='Others'>Others</option>
		</select>
	</td>
	<td nowrap='nowrap' id='SecondaryRMHeader' class='EWNormalGreenGeneral1' height ='22' width = 30%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Entity Name </td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 30%><input type='text' size="22" maxlength="100" sname="FircoName" id="FircoName"/></td>
	
	<td nowrap='nowrap' id='SecondaryRMHeader' class='EWNormalGreenGeneral1' height ='22' width = 25% style="visibility: hidden;">&nbsp;&nbsp;&nbsp;&nbsp;Fetch Firco Status</td>
	<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="10" sname="FetchFirco" id="FetchFirco" style="visibility: hidden;"/></td>
	
</tr>
	
<tr>	
	<td colspan="3"><input type="button" name="Add" id="Add_row_Firco" value="Add" onclick='addrow_Firco("")' class='EWButtonRBSRM' style='width:100px'/>
	<input type="button" name="Delete" id ="Delete_row_Firco" value="Delete" onclick='Deleterow_Firco()' class='EWButtonRBSRM' style='width:100px'/>
	</td>
</tr>

</table>

<div style="border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="Firco_Details_Grid">
		<tr>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Select</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Entity Type</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Entity Name</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Fetch Firco Status</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Firco Fetch Date</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Reference Number</font></b></th>
		</tr>
	</table>
</div>

<!-- <tr>
		<td colspan="3"><input type="button" name="Fectch Firco" id="Fectch Firco" value="Fectch Firco" onclick='Fectch_Firco()' class='EWButtonRBSRM' style='width:100px'/></td>
	</tr> -->

<div  style="border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="FircoFetch_Details_Grid">
		<tr>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Entity Type</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Entity Name</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Reference Number</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">OFAC ID</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Matching Text</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Name</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Origin</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Designation</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Date of Birth</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">User Data 1</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Nationality</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Passport</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Additional Info</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Remarks</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Match Status</font></b></th>
			<th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white">Status Update Date</font></b></th>
		</tr>
	</table>
</div>


<!---Deferral Details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="DeferralDetails" >
	<tr  width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none'><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Deferral Details</font></td>
	</tr>
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Deferral Held </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<select  class="NGReadOnlyView" onchange="setComboValueToTextBox(this,'wdesk:DeferralWaiverHeld');" width='300' maxlength="1" name='DeferralWaiverHeldCombo' id='DeferralWaiverHeldCombo' style='width:170px'>
			<option value=''>--Select--</option>
			<option value='Y'>Yes</option>
			<option value='N' selected >No</option>
		</select>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Approving Authority (Name)</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' size="22" maxlength="100" name='wdesk:ApprovingAuthority'  id='wdesk:ApprovingAuthority' value='<%=((CustomWorkdeskAttribute)attributeMap.get("ApprovingAuthority")).getAttribValue().toString()%>' onkeyup="ValidateCharacterMain('wdesk:ApprovingAuthority','Approving Authority');"></td>
	</tr>	
	<tr>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Document Type deferred</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input type='text' name='wdesk:DocumentTypedeferred' size="22" maxlength="100" id='wdesk:DocumentTypedeferred' value='<%=((CustomWorkdeskAttribute)attributeMap.get("DocumentTypedeferred")).getAttribValue().toString()%>' onkeyup="ValidateCharacterMain('wdesk:DocumentTypedeferred','Document Type deferred');"></td>
		</td>
					
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Deferral Expiry Date</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
		<%
				if ((request.getHeader("User-Agent")).indexOf("Trident") > -1) {
					 WriteLog("User-Agent: "+request.getHeader("User-Agent"));
				%>
			<input type='date' size="22" name='wdesk:DeferralExpiryDate' id='wdesk:DeferralExpiryDate' onBlur="validatedefexpirydate('wdesk:DeferralExpiryDate');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DeferralExpiryDate")).getAttribValue().toString()%>' />&nbsp;<img src='/TF/webtop/images/cal.gif' id='DeferralExpiryDateCalImg' width='16' height='16' border='0' alt='' onclick="initialize('wdesk:DeferralExpiryDate');" />
			<% }
				else {
					WriteLog("User-Agent: "+request.getHeader("User-Agent"));
				%>
				<input type='text' size="22" name='wdesk:DeferralExpiryDate' id='wdesk:DeferralExpiryDate' onBlur="validatedefexpirydate('wdesk:DeferralExpiryDate');" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DeferralExpiryDate")).getAttribValue().toString()%>' />&nbsp;<img src='/TF/webtop/images/cal.gif' id='DeferralExpiryDateCalImg' width='16' height='16' border='0' alt='' onclick="initialize('wdesk:DeferralExpiryDate');" />
				<% }
				%>
		
		</td>
	</tr>
		
</table>

<!---
Decision Header Start**********************************************************************************************************
-->
<div id="dispatchDtl" style='border-style: solid;border-width: thin;border-color: #990033;display:block'> 
	<table width=100% border='1' cellspacing='1' cellpadding='0' id = "decisiondetails" >
		<tr class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Decision</td>
		</tr>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Decision * </td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
		<select  class="NGReadOnlyView" style='width: 170px;' name="selectDecision" id="selectDecision" onchange="setComboValueToTextBox(this,'wdesk:Decision');getQueueList()">
						<option value="--Select--">--Select--</option>
							<%
							
			//modified by shamily for fetching decision on the basis of ws name and route ProductCategory start
							/* CustomWorkdeskAttribute ROUTE_CATEGORY=((CustomWorkdeskAttribute)attributeMap.get("ROUTECATEGORY"));
							String ROUTECATEGORY=ROUTE_CATEGORY==null?"":ROUTE_CATEGORY.getAttribValue()==null?"":ROUTE_CATEGORY.getAttribValue().toString();
							if(ROUTECATEGORY!=null && ROUTECATEGORY != "")
							{ */
							params = "";
							
							//WriteLog("ROUTECATEGORY  shamily-->"+ROUTECATEGORY);		
							Query="select DECISION from USR_0_TF_DECISION_MASTER with (nolock) WHERE WORKSTEP_NAME=:WORKSTEP_NAME";
							
							params = "WORKSTEP_NAME=="+WSNAME;
														
			//modified by shamily for fetching decision on the basis of ws name and route ProductCategory end			
							
							
							String DECISION="";	
							String maincodeDecision="";
							 inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
									
							WriteLog("Load Decision Input-->"+inputData);		
							outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							WriteLog("Load Decision Output-->"+outputData);
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
		//}							
						%>
		</select></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='history' id="history" type='button' value='Decision History' onclick='HistoryCaller();' class='EWButtonRBSRM' style='width:150px'>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='Exception_History' id="Exception_History" type='button' value='Exception History' onclick="openCustomDialog('Exception History','<%=WSNAME%>')" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'></td>
		</tr>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Queue
		</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
		<select  class="NGReadOnlyView" style='width: 170px;' name="selectQueue" id="selectQueue" onchange="setComboValueToTextBox(this,'wdesk:Queue_Values');getUserList()">
				
													
		</select></td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;User
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>
		<select  class="NGReadOnlyView" style='width: 170px;' name="selectUser" id="selectUser" onchange="setComboValueToTextBox(this,'wdesk:User_Values')">
					
		</select>
		</td>
		<td nowrap='nowrap' style="display:none" class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='PrintReport' id="PrintReport" type='button' value='Print Report' onclick="" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>
		</td>
		</tr>
		<tr><td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Remarks
		</td>
		<td>
		<div>
			<input name='RichText' id="RichText" type='button' style="width:150px" value='Rich Text' onclick="openCustomDialog('Rich Text','<%=WINAME%>','');" class='EWButtonRBSRM NGReadOnlyView' >
		</div>
		</td>
		<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='RejectReason' id="RejectReason" type='button' value='Reject Reason' onclick="openCustomDialog('Reject Reasons','<%=logicalWsName%>');" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>
		</td>
		<td nowrap='nowrap' style="display:none" class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='PrintReport' id="PrintReport" type='button' value='Print Report' onclick="" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'>
		</td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Hold Till Date</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%><input class = 'NGReadOnlyView' disabled type='text' size="22" maxlength="100"  name="HoldtillDate" id="HoldtillDate" onchange="validateAppDate(this.value,'HoldtillDate');" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("HoldtillDate")).getAttribValue().toString()%>' />
			<!--<img class = 'NGReadOnlyView' id = 'HoldtillDate' style="cursor:pointer;" src='/TF/webtop/images/cal.gif' style="float:center;" onclick = "" width='16' height='16' border='0' alt=''>--></td>
			
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Retention Expiry Date</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' height ='22' width = 25%><input class = 'NGReadOnlyView' disabled type='text' size="22" maxlength="100"  name="RetentionExpDate" id="RetentionExpDate" onchange="validateAppDate(this.value,'RetentionExpDate');" value = '' />
			<!--<img class = 'NGReadOnlyView' id = 'RetentionExpDate' style="cursor:pointer;" src='/TF/webtop/images/cal.gif' style="float:center;" onclick = "" width='16' height='16' border='0' alt=''>--></td>
		</tr>
		
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Sign. Verified CSO</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' size="19" name="wdesk:sign_matched_CSO"  id="wdesk:sign_matched_CSO" value = '<%=((CustomWorkdeskAttribute)attributeMap.get("sign_matched_CSO")).getAttribValue().toString()%>' disabled='true'></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%></td>
		</tr>
		<!--
		<tr>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Sign. Verified Ops Maker</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' size="19" name="wdesk:sign_matched_maker"  id="wdesk:sign_matched_maker" value = '' disabled='true'></td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Sign. Verified Ops Checker</td>
			<td nowrap='nowrap' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 25%><input type='text' class='EWNormalGreenGeneral1 NGReadOnlyView' size="20" name="wdesk:sign_matched_checker"  id="wdesk:sign_matched_checker" value = '' disabled='true'></td>
		</tr>
		-->
		
		
	</table>
</div>

<!---Invoice Details details-->
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="CummDetails">
	<tr width=100% class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='Header' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">Communication Details</font></td>
	</tr>
</table>
<table border='1' cellspacing='1' cellpadding='0' width=100% id ="cummunidtls">
<tr>
<td nowrap='nowrap' id='TradeLicenseHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Mode of Communication</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><select  class="NGReadOnlyView" onchange="sendreport();" width='300' name='modeofcommunicationcombo' id='modeofcommunicationcombo' style='width:170px'>
			<option value=''>--Select--</option>
			<option value='Email'>Email</option>
			<option value='Telephone'>Telephone</option>
			<option value='Courier'>Courier</option>
		</select></td>
<td nowrap='nowrap' id='TradeLicenseExpDtHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;<input name='GenerateTemplate' id="GenerateTemplate" type='button' value='GenerateTemplate' disabled onclick="location.href='mailto:demo@demo.com';" class='EWButtonRBSRM NGReadOnlyView' style='width:150px'></td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><select  class="NGReadOnlyView" onchange="" width='300' name='templatecombo' id='templatecombo' style='width:170px'>
			<option value=''>--Select--</option>
			<option value='Report'>Report</option>
		</select></td>
</tr>
<tr>
<td nowrap='nowrap' id='LodgementDateHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp;Date</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input class = 'NGReadOnlyView'  onblur="" type='text' size="22" maxlength="100"  name="communicationDate" id="communicationDate" onchange="validateAppDate(this.value,'communicationDate');" value = ''/>
<!--<img class = 'NGReadOnlyView' id = 'communicationDate' style="cursor:pointer;" src='/TF/webtop/images/cal.gif' style="float:center;" onclick = "initialize('communicationDate');" width='16' height='16' border='0' alt=''>-->
</td>
<td nowrap='nowrap' id='communicationDateHeader' class='EWNormalGreenGeneral1' height ='22' width = 25%>&nbsp;&nbsp;&nbsp;&nbsp; Time (HH:MM:SS 24 Hrs)</td>
<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%><input onblur="validateTime(this.value,'CommunicationTime');" type='text' size="22" maxlength="10"  name="CommunicationTime" id="CommunicationTime" value = ''/></td>
</tr>

<tr >
<td nowrap='nowrap'  class='EWNormalGreenGeneral1' height ='22' width = 26%>&nbsp;&nbsp;&nbsp;&nbsp;Description
		</td>
		<td nowrap='nowrap' colspan='3' class='EWNormalGreenGeneral1 NGReadOnlyView' width = 70%>
		<textarea maxlength="3000" class='EWNormalGreenGeneral1'  style="width:'100%'" rows="3" cols="50" id="description" name="description"></textarea>
		</td>
</tr>
<tr>
<tr>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
</tr>
</table>

<table border='1' cellspacing='1' cellpadding='0' width=100% id ="communicationaddgrid">
<tr>
	<td colspan="3"><input type="button" name="Add" id="Addcommn" value="Add" onclick="addrowCommunication()" class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Modify" id="Modifycommn" value="Modify" onclick="modifyCommunicationrow()" class='EWButtonRBSRM' style='width:100px'/><input type="button" name="Delete" 	id ="Deletecommn" value="Delete" onclick="deleterowCommunication()" class='EWButtonRBSRM' style='width:100px'/></td></tr>
</table>
<div id ="communicationgridheader" style="border-style: solid;border-width: thin;border-color: #990033;">
	<table border='1' cellspacing='1' cellpadding='0' width=100% id ="CommunicationdtlsGrid">
		<tr><th class='EWLabelRB2' bgcolor= "#990033"><b><font color="white" style="text-align:center">Select</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Mode</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Date</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Time</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Description</font></b></th><th class='EWLabelRB2' bgcolor= "#990033" style="text-align:center"><b><font color="white">Logged Date</font></b></th></tr>
		
	</table>
</div>
<!--Hidden Fields in form-->
<input type="hidden" id="DATE" name="DATE" value=''/>
<input type='hidden' name='rowidselected' id='rowidselected' value=''/>
<input type='hidden' name='rowidselectedcommunication' id='rowidselectedcommunication' value=''/>
<input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='<%=WSNAME%>'/>
<input type='hidden' name="wdesk:WI_NAME" id="wdesk:WI_NAME" value='<%=WINAME%>'/>
<input type='hidden' name="wdesk:CURRENT_WS" id="wdesk:CURRENT_WS" value='<%=WSNAME%>'/>
<input type="hidden" id="rejReasonCodes" name="rejReasonCodes"/>
<input type="hidden" id="H_CHECKLIST" name="H_CHECKLIST"/>
<input type="hidden" id="CHECKLIST_WSNAME" name="CHECKLIST_WSNAME" value="" />
<input type="hidden" id="remarks" name="remarks" value="" />

<input type='hidden' name="wdesk:Queue_Values" id="wdesk:Queue_Values" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Queue_Values")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Queue_Values")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:User_Values" id="wdesk:User_Values" value='<%=((CustomWorkdeskAttribute)attributeMap.get("User_Values")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("User_Values")).getAttribValue().toString()%>'/>

<input type="hidden" id="wdesk:UTCDetailsFlag" name="wdesk:UTCDetailsFlag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("UTCDetailsFlag")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:CUSTOMER_BUYER_OR_SUPPLIER" id="wdesk:CUSTOMER_BUYER_OR_SUPPLIER" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CUSTOMER_BUYER_OR_SUPPLIER")).getAttribValue().toString()%>'/> 
<input type='hidden' name="wdesk:OVERRIDE" id="wdesk:OVERRIDE" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OVERRIDE")).getAttribValue().toString()%>'/> 
<input type='hidden' name="wdesk:DeferralWaiverHeld" id="wdesk:DeferralWaiverHeld" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DeferralWaiverHeld")).getAttribValue().toString()%>'/>

<input type="hidden" id="DubplicateWorkitemVisible" name="DubplicateWorkitemVisible"/>
<input type="hidden" id="DuplicateCheckLogic" name="DuplicateCheckLogic"/>
<input type="hidden" id="wdesk:CSMApprovalRequire" name="wdesk:CSMApprovalRequire" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CSMApprovalRequire")).getAttribValue().toString()%>'/>
<input type="hidden" id="wdesk:CardSettlementProcessingRequired" name="wdesk:CardSettlementProcessingRequired"/>
<input type="hidden" id="wdesk:OriginalRequiredatOperations" name="wdesk:OriginalRequiredatOperations" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OriginalRequiredatOperations")).getAttribValue().toString()%>'/>
<input type="hidden" id="AccountIndicator" name="AccountIndicator"/>
<input type="hidden" id="FetchClosedAcct" name="FetchClosedAcct"/>
<input type="hidden" id="wdesk:OriginalRequiredbyTFforProcessing" name="wdesk:OriginalRequiredbyTFforProcessing" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OriginalRequiredbyTFforProcessing")).getAttribValue().toString()%>'/>
<input type="hidden" id="isSMSMailToBeSend" name="isSMSMailToBeSend" value='<%=((CustomWorkdeskAttribute)attributeMap.get("isSMSMailToBeSend")).getAttribValue().toString()%>'/>
<input type="hidden" id="AccToBeFetched" name="AccToBeFetched"/>
<input type="hidden" id="isEMIDExpiryChkReq" name="isEMIDExpiryChkReq"/>
<input type="hidden" id="wdesk:Call_Back_Required" name="wdesk:Call_Back_Required" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Call_Back_Required")).getAttribValue().toString()%>'/>
<input type="hidden" id="wdesk:Document_Approval_Required" name="wdesk:Document_Approval_Required" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Document_Approval_Required")).getAttribValue().toString()%>'/>
<input type="hidden" id="wdesk:Document_Dispatch_Required" name="wdesk:Document_Dispatch_Required" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Document_Dispatch_Required")).getAttribValue().toString()%>'/>
<input type="hidden" id="wdesk:ROUTECATEGORY" name="wdesk:ROUTECATEGORY" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ROUTECATEGORY")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:TEMP_WI_NAME" id="wdesk:TEMP_WI_NAME" value='<%=((CustomWorkdeskAttribute)attributeMap.get("TEMP_WI_NAME")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ModeOfDelivery" id="wdesk:ModeOfDelivery" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ModeOfDelivery")).getAttribValue().toString()%>'/>
<!--<input type='hidden' name="wdesk:HoldtillDate" id="wdesk:HoldtillDate" value=''/>-->
<input type='hidden' name="wdesk:RetentionExpDate" id="wdesk:RetentionExpDate" value=''/>
<input type='hidden' name="wdesk:DocumentCollectionBranch" id="wdesk:DocumentCollectionBranch" value='<%=((CustomWorkdeskAttribute)attributeMap.get("DocumentCollectionBranch")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:BranchDeliveryMethod" id="wdesk:BranchDeliveryMethod" value='<%=((CustomWorkdeskAttribute)attributeMap.get("BranchDeliveryMethod")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Islamic_Or_conventions" id="wdesk:Islamic_Or_conventions" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Islamic_Or_conventions")).getAttribValue().toString()%>'/>
<!-- CR-26052021-->
<input type='hidden' name="wdesk:Initiation_source" id="wdesk:Initiation_source" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Initiation_source")).getAttribValue().toString()%>'/> 

<input type='hidden' name="wdesk:Product_Category" id="wdesk:Product_Category" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Category")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Product_Type" id="wdesk:Product_Type" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Product_Type")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ServiceRequestCode" id="wdesk:ServiceRequestCode" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ServiceRequestCode")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:encryptedkeyid" id="wdesk:encryptedkeyid" value='<%=((CustomWorkdeskAttribute)attributeMap.get("encryptedkeyid")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:mw_errordesc" id="wdesk:mw_errordesc" value='<%=((CustomWorkdeskAttribute)attributeMap.get("mw_errordesc")).getAttribValue().toString()%>' />
<input type='hidden' name="wdesk:CutOffDateTime" id="wdesk:CutOffDateTime" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CutOffDateTime")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:Channel" id="wdesk:Channel" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Channel")).getAttribValue().toString()%>'/>
<input type='hidden' name="CategoryID" id="CategoryID" value=''/>
<input type='hidden' name="SubCategoryID" id="SubCategoryID" value=''/>
<input type='hidden' name="IsSavedFlag" id="IsSavedFlag" value=''/>
<input type='hidden' name="savedFlagFromDB" id="savedFlagFromDB" value='<%=FlagValue%>'/>
<input type='hidden' name="selectedcifid" id="selectedcifid" value = ''/>
<input type='hidden' name="wdesk:CIFTYPE" id="wdesk:CIFTYPE" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CIFTYPE")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ResidentCountry" id="wdesk:ResidentCountry" value=''/>
<input type='hidden' name="wdesk:ECRNumber" id="wdesk:ECRNumber" value=''/>
<input type='hidden' name="wdesk:Decision" id="wdesk:Decision"/>
<input type='hidden' name="wdesk:IntegrationStatus" id="wdesk:IntegrationStatus" value='<%=((CustomWorkdeskAttribute)attributeMap.get("IntegrationStatus")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:IntoducedBy" id="wdesk:IntoducedBy" value='<%=customSession.getUserName()%>'/>
<input type='hidden' name='isTransInSusAccount' id='isTransInSusAccount' value=''/> 
<input type='hidden' name='currencySelected' id='currencySelected' value=''/>
<input type='hidden' name="wdesk:AccountnoSig" id="wdesk:AccountnoSig"/>
<input type='hidden' name="wdesk:AccountNo" id="wdesk:AccountNo" value='<%=((CustomWorkdeskAttribute)attributeMap.get("AccountNo")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("AccountNo")).getAttribValue().toString()%>'/>
<input type='hidden' name="wsname_sign" id="wsname_sign" value=''/>
<input type='hidden' name="wdesk:PreviouslyRejectedBy" id="wdesk:PreviouslyRejectedBy" value='<%=((CustomWorkdeskAttribute)attributeMap.get("PreviouslyRejectedBy")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ChecklistFor" id="wdesk:ChecklistFor" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ChecklistFor")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:HoldBy" id="wdesk:HoldBy" value='<%=((CustomWorkdeskAttribute)attributeMap.get("HoldBy")).getAttribValue().toString()%>'/>
<%if((WSNAME.equals("TF_Maker"))||(WSNAME.equals("TF_Checker"))){%>
<input type='hidden' name="wdesk:OPSMakerRejectFlag" id="wdesk:OPSMakerRejectFlag" value='<%=((CustomWorkdeskAttribute)attributeMap.get("OPSMakerRejectFlag")).getAttribValue().toString()%>'/>
<%}%>

<input type='hidden' name="wdesk:Amount" id="wdesk:Amount" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Amount")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:Currency" id="wdesk:Currency" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Currency")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Currency")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:CCY_Amount" id="wdesk:CCY_Amount" value='<%=((CustomWorkdeskAttribute)attributeMap.get("CCY_Amount")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("CCY_Amount")).getAttribValue().toString()%>'/>

<input type='hidden' name="wdesk:ReferenceNumber" id="wdesk:ReferenceNumber" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ReferenceNumber")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ReferenceNumber")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ArchivalPath" id="wdesk:ArchivalPath" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalPath")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ArchivalPath")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ArchivalPathRejected" id="wdesk:ArchivalPathRejected" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalPathRejected")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ArchivalPathRejected")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:RO_Email_Id" id="wdesk:RO_Email_Id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("RO_Email_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RO_Email_Id")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:RM_Email_Id" id="wdesk:RM_Email_Id" value='<%=((CustomWorkdeskAttribute)attributeMap.get("RM_Email_Id")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("RM_Email_Id")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:EventDetailsCheckGridData" id="wdesk:EventDetailsCheckGridData" value='<%=((CustomWorkdeskAttribute)attributeMap.get("EventDetailsCheckGridData")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("EventDetailsCheckGridData")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:ArchivalDecision" id="wdesk:ArchivalDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ArchivalDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ArchivalDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="wdesk:TFMakerDecision" id="wdesk:TFMakerDecision" value='<%=((CustomWorkdeskAttribute)attributeMap.get("TFMakerDecision")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("TFMakerDecision")).getAttribValue().toString()%>'/>
<input type='hidden' name="EventDetailsFlag" id="EventDetailsFlag" value=''/>
<input type='hidden' name="wdesk:ProcessedDateAtChecker" id="wdesk:ProcessedDateAtChecker" value='<%=((CustomWorkdeskAttribute)attributeMap.get("ProcessedDateAtChecker")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("ProcessedDateAtChecker")).getAttribValue().toString()%>'/>
<input type='hidden' name="DecisionHistoryFlag" id="DecisionHistoryFlag" value=''/>
<input type='hidden' name="wdesk:Issuance_LinkWorkItem" id="wdesk:Issuance_LinkWorkItem" value='<%=((CustomWorkdeskAttribute)attributeMap.get("Issuance_LinkWorkItem")).getAttribValue().toString()==null?"":((CustomWorkdeskAttribute)attributeMap.get("Issuance_LinkWorkItem")).getAttribValue().toString()%>'/>

<%
if(WSNAME=="CSO") {
%>
<input type='hidden' name="wdesk:q_ProductCode" id="wdesk:q_ProductCode" value='<%=((CustomWorkdeskAttribute)attributeMap.get("q_ProductCode")).getAttribValue().toString()%>'/>

<%}%>

</div>
</form>
    </body>
	
	<script language="javascript">
	var today = new Date();
	var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!

	var yyyy = today.getFullYear();
	if(dd<10){
		dd='0'+dd;
	} 
	if(mm<10){
		mm='0'+mm;
	} 
	var today = dd+'/'+mm+'/'+yyyy;
	document.getElementById("DATE").value = today;
	if(document.getElementById("wdesk:ApplicationDate").value == "")
	    document.getElementById("wdesk:ApplicationDate").value = today;
	</script>		
</f:view>
</html>
<%
}
%>

