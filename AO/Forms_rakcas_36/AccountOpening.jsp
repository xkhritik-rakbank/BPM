<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : InitiatemainFrameset.jsp
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : Initial Header fixed form for Account Opening
//---------------------------------------------------------------------------------------------------->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<%@ include file="../AO_Specific/Log.process"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<HTML>
<f:view>
	<HEAD>
		<TITLE>Account Opening</TITLE>
		<style>
			@import url("\webdesktop\webtop\en_us\css\docstyle.css");
		</style>
		<script language="javascript">
	
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
			window.parent.top.resizeTo(window.screen.availWidth,window.screen.availHeight);
			window.parent.top.moveTo(0,0);
		</script>
	</HEAD>
	
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/aes.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/json2.min.js?123"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/json3.min.js?123"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/populateCustomValue.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/formLoad_AO.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/keyPressValidation.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/AO_constants.js"></script>
	<script language="javascript" src="/webdesktop/webtop/scripts/AO_Scripts/Validation_AO.js"></script>
	
	
	
<script language="javascript">
     
	function setPrimaryField(){
		return true;		
	}
	function formLoad()	{
		
		document.getElementById("wdesk:Category").value="Account Opening";
		document.getElementById("wdesk:SubCategory").value="Account Opening Request";
		
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		var WS=document.getElementById("wdesk:WS_NAME").value;		
		var username = document.getElementById("username").value;			
		var sUrl="../AO_Specific/AO_CommonBlocks.jsp?load=firstLoad&WS="+WS+"&WINAME="+WINAME+"&FlagValue=N&username="+username;		
		document.getElementById("frmData").src = replaceUrlChars(sUrl);
	}	
	
	function HistoryCaller(){
		//For loading history
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		//var openingModalWindow=window.showModalDialog("../AO_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
		var openingModalWindow;
		//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra starts here.
		/***********************************************************/
		var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
		if (window.showModalDialog) {
			openingModalWindow = window.showModalDialog("../AO_Specific/history.jsp?WINAME="+WINAME,"", "dialogWidth:60; dialogHeight:400px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
		} else {
			openingModalWindow = window.open("../AO_Specific/history.jsp?WINAME="+WINAME,"",windowParams);
		}
		/************************************************************/
		//added below to handle window.open/window.showModalDialog according to type of browser by stutee.mishra ends here.
	}
	
	function replaceUrlChars(sUrl){	
		return sUrl.split("+").join("ENCODEDPLUS");	
	}
	
	function CallJSP(WSNAME,Flag){
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		
		document.getElementById("frmData").src = "../AO_Specific/AO_CommonBlocks.jsp?load=SecondLoad&WS="+WSNAME+"&WINAME="+WINAME+"&FlagValue="+Flag;
		resizeIframe(document.getElementById("frmData"));
		
		if (WSNAME == 'OPS_Maker' && document.getElementById("wdesk:Previous_Step").value!='OPS_Checker')
			document.getElementById("H_RejectReasons").value = '';
		if (WSNAME == 'OPS_Checker' && document.getElementById("wdesk:Previous_Step").value!='OPS_Maker')
			document.getElementById("H_RejectReasons").value = '';
			
		return true;
	}
	
	document.MyActiveWindows= new Array;
	
	function openWindow(sUrl,sName,sProps){
		document.MyActiveWindows.push(window.open(sUrl,sName,sProps));
	}

	function closeAllWindows(){
		for(var i = 0;i < document.MyActiveWindows.length; i++)
			document.MyActiveWindows[i].close();
	}
	
	function resizeIframe(obj)	{
		//obj.style.height = obj.contentWindow.document.body.scrollHeight-40 + 'px';
		obj.style.height =obj.contentWindow.document.body.scrollHeight + 260 + 'px';
		//obj.style.width =obj.contentWindow.document.body.scrollWidth + 20 + 'px';
	}
	// Added by sowmya for CPF functionality
	function enableDisable(WSNAME)
	{
		
		var WSNAME=document.getElementById("wdesk:WS_NAME").value;
		//if(WSNAME=='CSO_Rejects')
		if(WSNAME=='CB-WC Maker'|| WSNAME=='CB-WC Checker'|| WSNAME=='OPS_Maker'|| WSNAME=='OPS_Checker'|| WSNAME=='CSO_Rejects')
		{
			document.getElementById("wdesk:eMail").disabled=false;
			document.getElementById("wdesk:Mobile_Country_Code").disabled=false;
			document.getElementById("wdesk:Mobile_Number").disabled=false;
			document.getElementById("wdesk:Retail_or_Corporate").disabled=false;
		}
		
				
	}
	function loadCPFGridValues()
	{
		console.log("inside loadCPFGridValues");
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		//alert("WINAME:"+WINAME);
		var fetchURL = "../AO_Specific/loadCPFGridDetails.jsp?WINAME="+WINAME;
		//alert("url"+fetchURL);
		fetchURL = replaceUrlChars(fetchURL);
		//alert("fetchURL"+fetchURL);
		var xhr;
		var ajaxResult="";
		if(window.XMLHttpRequest)
			 xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 xhr.open("GET",fetchURL,false); 
		 xhr.send(null);
		 if (xhr.status == 200 && xhr.readyState == 4)
			{
				ajaxResult = xhr.responseText;
				ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				//console.log("ajaxResult");
				if(ajaxResult=="-1")
				{
					//alert("Error while loading CPF details ");
					return false;
				}
				else if(ajaxResult=='0')//Means no record found in database
				{
					
				}
				else
				{
					var ajaxResultArr=ajaxResult.split('@@@');
					//alert("ajaxResultArr"+ajaxResultArr);
					
					for(var i=0;i<ajaxResultArr.length;i++)
					{
						//var ajaxResultRow=ajaxResult[i].split('~');
						//alert("ajaxResultRow"+ajaxResultArr[i]);
						
						if(ajaxResultArr[i]!=''){
						loadrowCPFDetails(ajaxResultArr[i]);
						}
						//alert("success");
					}							
					if (ajaxResult.length > 0)
					{
						// below block added to apply tooltip on field added on 07032018
						$(document).ready(function() {
							$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
							$("div.tooltip-wrapper").mouseover(function() {
								$(this).attr('title', $(this).children().val());
							});
						});
					}
				}
			}
			else 
				alert("failure");
	}
	var cpfdetailcount=1;
	function loadrowCPFDetails(arrayCPFRowValues)
	{		
			
		var disabledOption = '';
		var disabledRemarks = '';
		var table = document.getElementById("CPFGridbody");
		//console.log("table  "+table);
		var table_len=table.rows.length;
		//var lastRow = table.rows[table.rows.length];
		//var row = table.insertRow();
		//alert(arrayCPFRowValues)
		var values=arrayCPFRowValues.split("~");
		//console.log ("values"+values);
		
		
		if(values.length>=8){
			var sd=values[2];
			var rd=values[7];
		var tat=autoCalculateTAT(sd,rd);
		//style='min-width: 100px;border:1px solid;'
		var CPFDETAILS = "<td class='EWNormalGreenGeneral1' height ='22'>"+cpfdetailcount+"</td><td style='display: none;'><input name='insertionOrderId' id='insertionOrderId' type='text' style='display: none;' disabled value='"+values[0]+"'></td><td>"+values[1]+"</td><td>"+values[2]+"</td><td>"+values[3]+"</td><td>"+values[4]+"</td><td>"+values[5]+"</td><td>"+values[6]+"</td><td>"+values[7]+"</td><td>"+tat+"</td><td><input type='button' name='"+values[0]+"' id='"+values[0]+"' onclick='opencontentwindow(this.id)' value='Content' /></td>";
		document.getElementById("CPFGridbody").insertRow(table_len).innerHTML =CPFDETAILS;
		}else{
			document.getElementById("CPFGridbody").insertRow(table_len).innerHTML ="";
		}
		//console.log(CPFDETAILS)
			
		cpfdetailcount++;
			
		//document.getElementById("CPF_Details_Grid").style.overflowY="scroll";
		document.getElementById("CPF_Details_Grid").style.height="300px";	
			
	}
	
	function opencontentwindow(sno)
	{
		//alert("opencontentwindow");
		//console.log(sno);
		var WINAME=document.getElementById("wdesk:WI_NAME").value;
		//var srnum=document.getElementById("insertionOrderId").value;
		
		var windowParams="height=600,width=650,toolbar=no,directories=no,status=no,center=yes,scrollbars=no,resizable=no,modal=yes,addressbar=no,menubar=no";
		if (window.showModalDialog) {
			openingModalWindow = window.showModalDialog("../AO_Specific/ContentDetails.jsp?WINAME="+WINAME+"&sno="+sno,"", "dialogWidth:60; dialogHeight:700px; center:yes;edge:raised; help:no; resizable:no; scroll:yes;scrollbar:yes; status:no; statusbar:no; toolbar:no; menubar:no; addressbar:no; titlebar:no;");
		}
			
		else {
			openingModalWindow = window.open("../AO_Specific/ContentDetails.jsp?WINAME="+WINAME+"&sno="+sno,"",windowParams);
		}
		/*var sent_date;
		var response_date;
		autoCalculateTAT(sent_date,response_date);	*/
	}
	function autoCalculateTAT(sent_date,response_date) {
		if (sent_date != '' && response_date != '') 
				{
					var tmp1 = sent_date.split(" ");
					var spiltdate1=tmp1[0].split("-");
					var date1 = spiltdate1[0]+"/"+spiltdate1[1]+"/"+spiltdate1[2];
					var sentdate = new Date(date1);
					//alert(sentdate);


					//var response_date='2022-05-23 16:25:15.71';
					var tmp2 = response_date.split(" ");
					var spiltdate2=tmp2[0].split("-");
					var date2 = spiltdate2[0]+"/"+spiltdate2[1]+"/"+spiltdate2[2];
					var responsedate = new Date(date2);
					//alert(responsedate);
					

					var diffTime = Math.abs(responsedate - sentdate);
					//alert(diffTime);
					var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
					//alert(diffDays);
					return diffDays;
				}
			else
				return 0;

	}
	
	function mandantoryfocus(object, fieldName)
	{
		var val = document.getElementById(object.id).value;
		if(val=="" || val==null){
			alert('Please enter '+fieldName);
			//document.getElementById(object.id).focus();
			return false;
		}
	} 
	
	function ValidateNumeric1(id) {
		var inputtxt = document.getElementById(id);
		if (inputtxt.value == '')
			return;
		var inputtxt = document.getElementById(id);
		var numbers = /^[0-9]+$/;
		var number1 = /^[0-9.]+$/;
		if (inputtxt.value.match(numbers))
			return true;
		else {
			alert("Please input numeric characters only");
			document.getElementById(id).value = "";
			document.getElementById(id).focus();
			return false;
		}
	}
	
	window.onunload = function(){closeAllWindows()};
	
</script>
		
		
 <%
	//String pid=request.getParameter("wdesk:pid");
	//String wid=request.getParameter("wdesk:wid");
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WorkitemId"), 1000, true) );
	String WorkitemId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	String pid = ProcessInstanceId_Esapi;
	String wid = WorkitemId_Esapi;

	//LinkedHashMap workitemMap=(LinkedHashMap)FacesContext.getCurrentInstance().getApplication().createValueBinding("#{workitems.workItems}").getValue(FacesContext.getCurrentInstance());
	 WDWorkitems wDWorkitems = (WDWorkitems) session.getAttribute("wDWorkitems");
   LinkedHashMap workitemMap = (LinkedHashMap) wDWorkitems.getWorkItems();
	WorkdeskModel wdmodel = (WorkdeskModel)workitemMap.get(pid+"_"+wid);//currentworkdesk
	LinkedHashMap attributeMap=wdmodel.getAttributeMap();
	

	
	

 %>
<%
    
	//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+"logging for Accountoppenning.jsp---------------------------------------------------------------------");
	
	String Query="";
	String inputData="";
	String outputData="";
	String maincode="";
	String FlagValue="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String subXML="";
	String channel="";
	int counter=0;
	//Query="select count(*) as count from RB_AO_EXTTABLE with(nolock) where WI_NAME='"+wdmodel.getWorkitem().getProcessInstanceId()+"'";
			
	//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getEngineName() + "</EngineName><SessionId>" + wDSession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	Query="select count(*) as count from RB_AO_EXTTABLE with(nolock) where WI_NAME=:WI_NAME";
	String params="WI_NAME=="+wdmodel.getWorkitem().getProcessInstanceId();		
	inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	 
	 //com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "inputData:"+ inputData);
	//outputData = WFCallBroker.execute(inputData, wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_, true);
	outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
	//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "outputData:"+ outputData);
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	maincode = xmlParserData.getValueOf("MainCode");
	
	if(maincode.equals("0"))
	{	counter = Integer.parseInt(xmlParserData.getValueOf("count"));
		if(counter!=0)
		FlagValue ="Y";		
	}
	if(wdmodel.getWorkitem().getActivityName().equals("CSO")&&!FlagValue.equals("Y"))
	{
		%><BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload = "window.parent.checkIsFormLoaded();formLoad();enableDisable('<%=wdmodel.getWorkitem().getActivityName()%>');loadCPFGridValues();"><%
	}
	else
	{
		%><BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="window.parent.checkIsFormLoaded();CallJSP('<%=wdmodel.getWorkitem().getActivityName()%>', '<%=FlagValue%>');enableDisable('<%=wdmodel.getWorkitem().getActivityName()%>');loadCPFGridValues();" ><%
	}
%>

<form name="wdesk" id="wdesk" method="post" visibility="hidden" >
	<table border='1' id='maintable' cellspacing='1' cellpadding='0'  width="100%">
		<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Account Opening Details'><td colspan=4 align=center class='EWLabelRB2'><b>Account Opening</b></td></tr>
		<tr><td colspan =4 width=100% height=100% align=right valign=center><img src='\webdesktop\webtop\images\rak-logo.gif'></td></tr>
		<tr>
		<td nowrap='nowrap' width="26%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Logged In As</b></td>
		<td nowrap='nowrap' width="25.5%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<%=wDSession.getM_objUserInfo().getM_strUserName()%></td></tr><tr>
		<td nowrap='nowrap' width="25.5%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Workstep</b></td>
		<td nowrap='nowrap' width="24%" class='EWNormalGreenGeneral1' height ='22' ><label id="Workstep">&nbsp;&nbsp;&nbsp;&nbsp;<%=wdmodel.getWorkitem().getActivityName().replace("_"," ")%></label></td>
		</tr>
		
		<tr>
		
		<td colspan =2><iframe border=0 src="../AO_Specific/BPM_blank.jsp" id="frmData" name="frmData" width="100%" height="100%" onload='javascript:resizeIframe(this);'></iframe></td>
		</tr>
	</table>		
		<!--- CPF implementation start-->
		
		<div class='tooltip-wrapper' id = 'CPFDetailsDiv'>
		<table border='1' id = 'CPFDetailsTbl' cellspacing='1' cellpadding='0' width=100% >
		<tr  id = "CPF_Details" width='100%' class='EWLabelRB2' bgcolor= "#990033"><input type='text' name='CPFDetails' readOnly size='24' style='display:none' ><td colspan=4 align=center class='EWLabelRB2'><font color="white" size="4">CPF Details</font></td>
		</tr>
		<tr><td colspan =2 width=50% height=100% align=right valign=center></td></tr>
		<tr>
			<td nowrap='nowrap' width="26%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>eMail</b></td>
			<td nowrap='nowrap' width="25.5%" class='EWNormalGreenGeneral1' height ='22' ><input type='text' name='wdesk:eMail'  id='wdesk:eMail' width="25.5%"  maxlength = '80' disabled onblur="mandantoryfocus(this, 'eMail');" value='<%=((WorkdeskAttribute)attributeMap.get("eMail"))==null?"":((WorkdeskAttribute)attributeMap.get("eMail")).getValue()%>'/></td>
		</tr>
		<tr>
			<td nowrap='nowrap' width="26%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Mobile Country Code</b></td>
			<td nowrap='nowrap' width="25.5%" class='EWNormalGreenGeneral1' height ='22' ><input type='text' name='wdesk:Mobile_Country_Code'  id='wdesk:Mobile_Country_Code' maxlength = '20' disabled onblur="mandantoryfocus(this, 'Mobile Country Code');" onkeyup = "ValidateNumeric1('wdesk:Mobile_Country_Code');" value='<%=((WorkdeskAttribute)attributeMap.get("Mobile_Country_Code"))==null?"":((WorkdeskAttribute)attributeMap.get("Mobile_Country_Code")).getValue()%>'/>
			</td>
		</tr>
		<tr>
			<td nowrap='nowrap' width="26%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Mobile Number</b></td>
			<td nowrap='nowrap' width="25.5%" class='EWNormalGreenGeneral1' height ='22' ><input type='text' name='wdesk:Mobile_Number'  id='wdesk:Mobile_Number' maxlength = '25' disabled onblur="mandantoryfocus(this, 'Mobile Number');" onkeyup = "ValidateNumeric1('wdesk:Mobile_Number');" value='<%=((WorkdeskAttribute)attributeMap.get("Mobile_Number"))==null?"":((WorkdeskAttribute)attributeMap.get("Mobile_Number")).getValue()%>'/>
			</td>
		</tr>
		<tr>
			<td nowrap='nowrap' width="26%" class='EWNormalGreenGeneral1' height ='22' >&nbsp;&nbsp;&nbsp;&nbsp;<b>Retail/Corporate</b></td>
			<td nowrap='nowrap' width="25.5%" class='EWNormalGreenGeneral1' height ='22' >
			<select name='wdesk:Retail_or_Corporate' id='wdesk:Retail_or_Corporate' style='width:155px' onblur="mandantoryfocus(this, 'Retail/Corporate');" disabled>
			<%
			String retorcor=((WorkdeskAttribute)attributeMap.get("Retail_or_Corporate")).getValue();
			if(retorcor.equals("Retail")){%>
				<option value=''>--Select--</option>
				<option value='Retail' selected>Retail</option>
				<option value='Corporate'>Corporate</option>
				<%} else if(retorcor.equals("Corporate")){%>
				<option value=''>--Select--</option>
				<option value='Retail'>Retail</option>
				<option value='Corporate' selected>Corporate</option>
				<%} else {%>
				<option value=''>--Select--</option>
				<option value='Retail'>Retail</option>
				<option value='Corporate'>Corporate</option>
				<%}%>
			</select>	
		
			</td>
		</tr>	
			
		</table>
		</div>
		
		<!--- CPF grid Details-->
<div id='CPF_Details_Grid' class='tooltip-wrapper'>
		<table border='1' cellspacing='1' cellpadding='0'  id ='CPFGridbody' class="CPFGrid">
		<!---<tr id = "CPF_Grid_Header" width='100%' class='EWLabelRB2' bgcolor= "#990033">
			<input type='text' name='Header' readOnly style='display:none' />
		</tr>-->
		<thead>
		<tr bgcolor= "#990033" >
			<td width = '5%' style="width:50px" class='EWNormalGreenGeneral1'><font color="white">S.No</font></td>
			<td width = '5%' style="width:50px;display: none;" class='EWNormalGreenGeneral1'><font color="white">insertionOrderId</font></td>			 
			<td width ='10%' style="width:75px" class='EWNormalGreenGeneral1'><font color="white">eMail/SMS</font></td>
			<td width ='10%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Sent Date</font></td>
			<td width ='20%' style="width:75px" class='EWNormalGreenGeneral1'><font color="white">Recipient</font></td>
			<td width ='20%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Copied IDs</font></td>
			<td width ='20%' style="width:75px" class='EWNormalGreenGeneral1'><font color="white">Delivery Status</font></td>
			<td width ='20%' style="width:80px" class='EWNormalGreenGeneral1'><font color="white">Category</font></td>
			<td width ='20%' style="width:100px" class='EWNormalGreenGeneral1'><font color="white">Response Date</font></td>
			<td width ='20%' style="width:100px" class='EWNormalGreenGeneral1'><font color="white">Response TAT(Days)</font></td>
			<td width ='20%' style="width:177px" class='EWNormalGreenGeneral1'><font color="white">Content</font></td>
			
			<td class='EWNormalGreenGeneral1'></td>
		</tr></thead>
		<tbody>
		</tbody>
	</table>
</div>
	
	
	
	
	<table style="display:none"><tr><td><input type='hidden' name="wdesk:WS_NAME" id="wdesk:WS_NAME" value='<%=wdmodel.getWorkitem().getActivityName()%>'/></td></tr></table>
	<div style="display:none">
	<input type='hidden' name="CheckListViewed" id="CheckListViewed" value=''/>
	<input type='hidden' name="OPSCheckerDecision" id="OPSCheckerDecision" value='<%=((WorkdeskAttribute)attributeMap.get("OPSCheckerDecision"))==null?"":((WorkdeskAttribute)attributeMap.get("OPSCheckerDecision")).getValue()%>'/>
	<input type='hidden' name="ArchivalTeamDecision" id="ArchivalTeamDecision" value='<%=((WorkdeskAttribute)attributeMap.get("ArchivalTeamDecision"))==null?"":((WorkdeskAttribute)attributeMap.get("ArchivalTeamDecision")).getValue()%>'/>
	<input type='hidden' name="OPSMakerDecision" id="OPSMakerDecision" value='<%=((WorkdeskAttribute)attributeMap.get("OPSMakerDecision"))==null?"":((WorkdeskAttribute)attributeMap.get("OPSMakerDecision")).getValue()%>'/>
	
	<input type='hidden' name="OLD_CIF_ID" id="OLD_CIF_ID" value='<%=((WorkdeskAttribute)attributeMap.get("OLD_CIF_ID"))==null?"":((WorkdeskAttribute)attributeMap.get("OLD_CIF_ID")).getValue()%>'/>
	
	<input type='hidden' name="PBCreditRejectReasons" id="PBCreditRejectReasons" value='<%=((WorkdeskAttribute)attributeMap.get("PBCreditRejectReasons"))==null?"":((WorkdeskAttribute)attributeMap.get("PBCreditRejectReasons")).getValue()%>'/>
	<input type='hidden' name="BranchCtrlRejectReasons" id="BranchCtrlRejectReasons" value='<%=((WorkdeskAttribute)attributeMap.get("BranchCtrlRejectReasons"))==null?"":((WorkdeskAttribute)attributeMap.get("BranchCtrlRejectReasons")).getValue()%>'/>
	<input type='hidden' name="SMECtrlRejectReasons" id="SMECtrlRejectReasons" value='<%=((WorkdeskAttribute)attributeMap.get("SMECtrlRejectReasons"))==null?"":((WorkdeskAttribute)attributeMap.get("SMECtrlRejectReasons")).getValue()%>'/>
	<input type='hidden' name="WMCtrlRejectReasons" id="WMCtrlRejectReasons" value='<%=((WorkdeskAttribute)attributeMap.get("WMCtrlRejectReasons"))==null?"":((WorkdeskAttribute)attributeMap.get("WMCtrlRejectReasons")).getValue()%>'/>
	<input type='hidden' name="H_Checklist" id="H_Checklist" value='<%=((WorkdeskAttribute)attributeMap.get("H_Checklist"))==null?"":((WorkdeskAttribute)attributeMap.get("H_Checklist")).getValue()%>'/>
	<input type='hidden' name="H_RejectReasons" id="H_RejectReasons" value='<%=((WorkdeskAttribute)attributeMap.get("RejectReasons"))==null?"":((WorkdeskAttribute)attributeMap.get("RejectReasons")).getValue()%>'/>
	<input type='hidden' name="wdesk:ProcessName" id="wdesk:ProcessName" value='<%=wdmodel.getWorkitem().getRouteName()%>'/>
	<input type='hidden' name="wdesk:Current_WS " id="wdesk:Current_WS " value='<%=wdmodel.getWorkitem().getActivityName()%>'/>
	<input type='hidden' name="wdesk:WI_NAME" id="wdesk:WI_NAME" value='<%=wdmodel.getWorkitem().getProcessInstanceId()%>'/>
	<input type='hidden' name="wdesk:IntoducedBy" id="wdesk:IntoducedBy" value='<%=wDSession.getM_objUserInfo().getM_strUserName()%>'/>
	<input type='hidden' name="CategoryID" id="CategoryID" value=''/>
	<input type='hidden' name="username" id="username" value='<%=wDSession.getM_objUserInfo().getM_strUserName()%>'/>
	<input type='hidden' name="SubCategoryID" id="SubCategoryID" value=''/>
	<input type='hidden' name="savedFlagFromDB" id="savedFlagFromDB" value='<%=FlagValue%>'/>
	<input type='hidden' name="wdesk:SubCategory" id="wdesk:SubCategory" value='Account Opening Request'/>
	<input type='hidden' name="wdesk:Category" id="wdesk:Category" value='Account Opening'/>
	<input type='hidden' name="wdesk:PBODateTime" id="wdesk:PBODateTime" />
	<input type='hidden' name="wdesk:mw_errordesc" id="wdesk:mw_errordesc" value='' />
	<input type='hidden' name="temp_wi_name" id="temp_wi_name" value='<%=pid%>' />
	<input type='hidden' name="alertDisplayed" id="alertDisplayed" value='' />
	<input type='hidden' name="rvc_package" id="rvc_package" value='<%=((WorkdeskAttribute)attributeMap.get("rvc_package"))==null?"":((WorkdeskAttribute)attributeMap.get("rvc_package")).getValue()%>'/>
	<input type='hidden' name="NoOfSignatures" id="NoOfSignatures" value=''/>
	<input type='hidden' name="IsSignatureCropped" id="IsSignatureCropped" value='<%=((WorkdeskAttribute)attributeMap.get("IsSignatureCropped"))==null?"898":((WorkdeskAttribute)attributeMap.get("IsSignatureCropped")).getValue()%>'/>
	<input type='hidden' name="wdesk:Previous_Step" id="wdesk:Previous_Step" value='<%=((WorkdeskAttribute)attributeMap.get("Previous_Step"))==null?"":((WorkdeskAttribute)attributeMap.get("Previous_Step")).getValue()%>'/>
	<input type='hidden' name="wdesk:qPrimaryCustomerName" id="wdesk:qPrimaryCustomerName" value='<%=((WorkdeskAttribute)attributeMap.get("qPrimaryCustomerName"))==null?"":((WorkdeskAttribute)attributeMap.get("qPrimaryCustomerName")).getValue()%>'/>
	<input type='hidden' name="wdesk:qPurposeOfAccount" id="wdesk:qPurposeOfAccount" value='<%=((WorkdeskAttribute)attributeMap.get("qPurposeOfAccount"))==null?"":((WorkdeskAttribute)attributeMap.get("qPurposeOfAccount")).getValue()%>'/>
	</div>
	<div id = "wdesk:divBackground" style="position: fixed; z-index: 999; height: 100%; width: 100%; top: 0; left:0; background-color: Black; filter: alpha(opacity=60); opacity: 0.6; -moz-opacity: 0.8;display:none">
    </div>
	<table style="display:none"><tr><td><input type='hidden' name="wdesk:Decision" id="wdesk:Decision" /></td></tr></table>
</form>

</body>
</f:view>
</html>
