<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Form Painitng
//File Name					 : RejectReasons.jsp          
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : Reject Reasons Screen for steps other than OPS maker/checker
//---------------------------------------------------------------------------------------------------->

<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>

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

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>


<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>
<script language="javascript">
	var OKCancelClicked=false;
	
	/*window.onbeforeunload = function (evt) {
	 var message = 'Have you clicked OK to save the Reject Reasons?';
	if (typeof evt == 'undefined') {
		evt = window.event;
	}
	 if (evt ) {
	   evt.returnValue = message;
	 }
		return message;

	}*/

</script>

<%!
Map<String,String> RejectReasonsMap = new HashMap<String, String>();
%>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME_Esapi: "+WINAME_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: PANnoEsapi: "+WSNAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ReasonCodes"), 1000, true) );
			String ReasonCodes_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: ReasonCodes_Esapi: "+ReasonCodes_Esapi);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("username"), 1000, true) );
			String username_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: username_Esapi: "+username_Esapi);

	String RejectReasons=ReasonCodes_Esapi;	
	String WSNAME=WSNAME_Esapi;	
	String WSNAMER=WSNAME.replace(" ","_");

	
	String WINAME=WINAME_Esapi;
    String username=username_Esapi; 	
%>
<html>
	<head>
		<title>Reject Reasons</title>
		<style>
			@import url("\webdesktop\webtop\en_us\css\docstyle.css");
		
			table {border-collapse:collapse;}
			table, th, td {
				border: none;
				
			}
			body{
				bgcolor:"#FFFBF0";
			}
			select {
				overflow: scroll;
			}

		</style>
		<script language=JavaScript>  
			document.write("<link type='text/css' rel='stylesheet' href='/webdesktop/webtop/en_us/css/jquery.autocomplete.css'>");
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//
			function setAutocompleteData() {
				var data ="";
				var ele=document.getElementById("AutocompleteValues");
				if(ele)
					data=ele.value;
				if(data!=null && data!="" && data!='{}'){
					data = data.replace('{','').replace('}','');
					var arrACTFields = data.split(",");
					
					for(var i=0 ; i< arrACTFields.length ; i++){
						var temp = arrACTFields[i].split("=");
						var values = temp[1].split(";");
						
						$(document).ready(function(){
							$("#"+temp[0]).autocomplete(values,{max:15,minChars:0,matchContains:true});							
						});
					}		
				}
			}
			//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//
			function AddClick()	{
				var Val=document.getElementById('RejectReasons').value;
				var code=getCode(Val);
				if(code!='')
				{
					var bItemAlreadyAdded=false;
					var select = document.getElementById('RejectReasonsList');
					if(select.options==null)
						bItemAlreadyAdded=false;
					else{
						for(var i=0;i<select.options.length;i++){
							if(select.options[i].value==Val){
								alert("Reason already selected.");
								bItemAlreadyAdded=true;	
								break;
							}
						}
					}
					if(!bItemAlreadyAdded){										
						var opt = document.createElement('option');
						opt.value = Val;
						opt.innerHTML = Val;
						opt.className="EWNormalGreenGeneral1";
						select.appendChild(opt);
					}	
					document.getElementById('RejectReasons').value='';							
				}
			}
			
			/*function setValue()
			{
				var char = event.which || event.keyCode;
				if(char==13)
				{	
					var Val=document.getElementById('RejectReasons').value;
					var code=getCode(Val);
					if(code!='')
					{
						var bItemAlreadyAdded=false;
						var select = document.getElementById('RejectReasonsList');
						if(select.options==null)
							bItemAlreadyAdded=false;
						else{
							for(var i=0;i<select.options.length;i++){
								if(select.options[i].value==Val){
									alert("Reason already selected.");
									bItemAlreadyAdded=true;	
									break;
								}
							}
						}
						if(!bItemAlreadyAdded){										
							var opt = document.createElement('option');
							opt.value = Val;
							opt.innerHTML = Val;
							opt.className="EWNormalGreenGeneral1";
							select.appendChild(opt);
						}	
						document.getElementById('RejectReasons').value='';							
					}
					else
					{
						alert('Invalid Reject Reasons');
						document.getElementById('RejectReasons').value='';							
					}
				}
			}*/
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//			
			function populateListbox(codeString) {
				
				if(typeof codeString === "undefined"  ||codeString==null||codeString==""||codeString=="null"||codeString=="undefined")
					return;				
				var codesArr=codeString.split("#");
				
				for (var i=0;i<codesArr.length;i++)	{
					
					var fieldVal=getVal(codesArr[i]);
					
					var select = document.getElementById('RejectReasonsList');
					
					for(var j=0;j<select.options.length;j++){
						if(select.options[j].value==fieldVal){							
							break;
						}
					}
					var opt = document.createElement('option');
					opt.value = fieldVal;
					opt.innerHTML = fieldVal;
					opt.className="EWNormalGreenGeneral1";
					select.appendChild(opt);
				}
			}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//			
			function RemoveSelected(){
				var select = document.getElementById('RejectReasonsList');				
				if(select.options.length==0)
				{
					alert('No reason in the grid.');
					return;	
				}	
				var removed=false;
				for(i = select.options.length-1; i >=0; i--) {
					if (select.options[i].selected) {
						select.remove(i);
						removed=true;
					}
				}
				if(!removed)
					alert('Select some reason(s) to remove.');
			}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//			
			function getCode(Val){	
				var data ="";
				var code ="";
				var desc=document.getElementById("AutocompleteValues");
				if(desc)
					data=desc.value;
				if(data!=null && data!="" && data!='{}') {
					data = data.replace('{','').replace('}','');
					var arrACTFields = data.split("=")[1].split(";");
					var arrACTCodes = document.getElementById("CodeValues").value.replace('{','').replace('}','').split("=")[1].split(";");
					for(var i=0 ; i< arrACTFields.length ; i++)	{	
						if(Val==arrACTFields[i]){
							code=arrACTCodes[i];
							break;
						}
					}
				}
				return code;				
			}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//			
			function getVal(code){					
				var data ="";
				var Val ="";
				var desc=document.getElementById("CodeValues");
				if(desc)
					data=desc.value;
				if(data!=null && data!="" && data!='{}'){
					data = data.replace('{','').replace('}','');
					var arrACTCodes = data.split("=")[1].split(";");
					var  arrACTFields= document.getElementById("AutocompleteValues").value.replace('{','').replace('}','').split("=")[1].split(";");
					for(var i=0 ; i< arrACTCodes.length ; i++){	
						if(code==arrACTCodes[i]){
							Val=arrACTFields[i];
							break;
						}
					}
				}
				return Val;				
			}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :          Amandeep
//Description                		  :          

//***********************************************************************************//			
			function OKClick(){
			
			   //funtion modified for email CR
			
			   var Wsname=document.getElementById('WSNAMER').value;
			   var Winame=document.getElementById('WINAME').value;
			   var username=document.getElementById('username').value;
			
				var returnValue="";
				var rejectreason="";
				
				var select = document.getElementById('RejectReasonsList');				
				for (var i=0;i<select.options.length;i++)	{
					if(returnValue=="" )
					{
						returnValue=getCode(select.options[i].value);
						rejectreason=select.options[i].value;
						//alert(select.options[i].value);
						
						}
					else
{					
						returnValue+="#"+getCode(select.options[i].value);
						rejectreason+=","+select.options[i].value;
						//alert(select.options[i].value);
						}
				}				
				window.returnValue = encodeURIComponent(returnValue);
				//added by stutee
				if(!window.showModalDialog)
				   window.opener.setValue(encodeURIComponent(returnValue));
				OKCancelClicked=true;
			 
            
	            var splCharacter = '&';
				var rep = new RegExp(splCharacter,'g');
				rejectreason=rejectreason.replace(rep,'and');		 
                //rejectreason=rejectreason.replace('&','and');
			
				
				var ajaxReq;
				if (window.XMLHttpRequest) {
					ajaxReq= new XMLHttpRequest();
			    } else if (window.ActiveXObject) {
					ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
				}

				var url = "/webdesktop/CustomForms/AO_Specific/RejectReasonsUpdate.jsp?Wsname="+Wsname+"&Winame="+Winame+"&Rejectreason="+rejectreason+"&username="+username;

					//alert("URL is " + url);
					ajaxReq.open("POST",url,false); 
					ajaxReq.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
					ajaxReq.send(null);
				if (ajaxReq.status == 200 && ajaxReq.readyState == 4)
				{
					var result=ajaxReq.responseText.split("~");
				}
				else
				{
					alert("some error occured while fetching exception status");
					return -1;
				}				 
				
				window.close();
			}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :  Application Projects
//Project                             :  Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :          
//Author                              :  Amandeep
//Description                		  :          

//***********************************************************************************//			
			function CancelClick(opt){				
				if(opt==2){
					window.returnValue = "NO_CHANGE";
					OKCancelClicked=true;
					window.close();				
				}	
				else if(!OKCancelClicked)
				{
					window.returnValue = "NO_CHANGE";				
				}	
			}
		</script>
	</head>
	
	<body class="EWGeneralRB" style="border: 2px solid #b20000; border-style:outset;" bgcolor="#FFFBF0" onload="setAutocompleteData();populateListbox('<%=RejectReasons%>');" onUnload="CancelClick(1);">		
		<table width="100%" border="1" >		
			<tr><td width=100% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif" style="margin-top: 15px;"></td></tr>
		</table>
		 
	       
	
		<input type='hidden' name="WSNAMER" id="WSNAMER" value=<%=WSNAMER%> />
		<input type='hidden' name="WINAME" id="WINAME" value=<%=WINAME%> />
		<input type='hidden' name="username" id="username" value=<%=username%> />
		
		<hr style=" color: #b20000; height: 3px">
					
<%
	RejectReasonsMap.put("RejectReasons","Item_Desc");	
	String Query="";
	String inputXML="";
	String outputXML="";
	String mainCodeValue="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String subXML="";	
	WriteLog(WSNAME);
	if(WSNAME.equalsIgnoreCase("PB_Credit") || WSNAME.equalsIgnoreCase("AML_Compliance")  || WSNAME.equalsIgnoreCase("Compliance")  || WSNAME.equalsIgnoreCase("Compliance_Manager") || WSNAME.equalsIgnoreCase("CB-WC Maker") || WSNAME.equalsIgnoreCase("CB-WC Checker") || WSNAME.equalsIgnoreCase("Archival Team") )	
	{
		Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master where isactive='Y' and wsname='"+WSNAME+"' order by id asc";
	}
	else if(WSNAME.equalsIgnoreCase("CSO_Rejects") )	
	{
		Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master where isactive='Y' order by id asc";
	}
	else if(WSNAME.equalsIgnoreCase("WM_Controls") || WSNAME.equalsIgnoreCase("SME_Controls")|| WSNAME.equalsIgnoreCase("Branch_Controls") || WSNAME.equalsIgnoreCase("CSM") || WSNAME.equalsIgnoreCase("Controls") )	
	{
		Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master where isactive='Y' and wsname='"+WSNAME+"' order by id asc";
	}else 
	{
		Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master where isactive='Y' and wsname ='OPS' order by id asc";
	}
	
	inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	//outputXML = WFCallBroker.execute(inputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	outputXML =NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
	WriteLog("outputXML exceptions-->"+outputXML);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	
	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	String items="";
	String codes="";
	if(mainCodeValue.equals("0"))
	{
		for(int k=0; k<recordcount; k++)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			if(items.equals(""))
			{
				items=objXmlParser.getValueOf("Item_Desc");
				codes=objXmlParser.getValueOf("item_code");
			}	
			else 
			{
				items+=";"+objXmlParser.getValueOf("Item_Desc");
				codes+=";"+objXmlParser.getValueOf("item_code");
			}		
		}
		HashMap<String, String> AutocompleteMap = new HashMap<String, String>();
		HashMap<String, String> CodeMap = new HashMap<String, String>();
		for(Map.Entry<String, String> entry : RejectReasonsMap.entrySet()) 
		{
		  String key = entry.getKey();
		  String value = entry.getValue();
		  
		  if(outputXML.indexOf(value)>=0)
		  {
			AutocompleteMap.put(key, items);
			CodeMap.put(key, codes);
		  } 
		}
		%>
		<div align="center" border="1px" width="100%"> 
		<table cellpadding="2" cellspacing="1" border="1">
			<%
			if(!WSNAME.equalsIgnoreCase("CSO_Rejects")){
			%>
			<tr><td width="100%" class="EWNormalGreenGeneral1"><b>Reject Reasons </b></td></tr>
			<tr><td width='100%'  align="center" nowrap='nowrap' class='EWNormalGreenGeneral1'>
				 <input type='text' style="width:400;" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value' size = '32' name='RejectReasons' id="RejectReasons" value = '' ></td>
			 
			</tr>
			<%}%>
			<tr>
				<td width="100%"  class="EWNormalGreenGeneral1"><b>Selected Reject Reasons</b></td></tr>
				<tr><td width='100%' align="center" nowrap='nowrap' class='EWNormalGreenGeneral1'>
					<select multiple="multiple" style="width:400;" id="RejectReasonsList" size=14></select>
				</td>
				
			</tr>
		</table>
		</div> 
		<input type=hidden name='AutocompleteValues' id='AutocompleteValues' value='<%=AutocompleteMap%>' style='visibility:hidden' >
		<input type=hidden name='CodeValues' id='CodeValues' value='<%=CodeMap%>' style='visibility:hidden' >
		<%
	}
%>		
			
			
		<div align="center"> 
			<%
				if(!WSNAME.equalsIgnoreCase("CSO_Rejects")){
			%><input type="button" action="" value="&nbsp;&nbsp;&nbsp;&nbsp;Add&nbsp;&nbsp;&nbsp;&nbsp;" onclick="AddClick();" class="EWButtonRB" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" action="" value="Remove" onclick="RemoveSelected();" class="EWButtonRB" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" action="" value="Save & Exit" onclick="OKClick();" class="EWButtonRB" >
			<%
				}else{
			%>
			<input type="button" action="" value="Close" onclick="CancelClick(2)" class="EWButtonRB">
			<%
				}
			%>
		</div>
	</body>
	
</html>