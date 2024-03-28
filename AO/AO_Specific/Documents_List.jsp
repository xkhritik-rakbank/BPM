<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Form Painitng

//File Name					 : Documents_List.jsp          
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : Reject Reasons Screen
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
	
</script>

<%!
Map<String,String> RejectReasonsMap = new HashMap<String, String>();
%>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("docList"), 1000, true) );
			String docList_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: docList_Esapi: "+docList_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: PANnoEsapi: "+WSNAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: WINAME_Esapi: "+WINAME_Esapi);

			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("username"), 1000, true) );
			String username_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: username_Esapi: "+username_Esapi);
			
	String DocumentList=docList_Esapi;
	String WSNAME=WSNAME_Esapi;	
	String WSNAMER=WSNAME.replace(" ","_");

	String WINAME=WINAME_Esapi;
    String username=username_Esapi; 
%>
<html>
	<head>
		<title>Documents List</title>
		<style>
			@import url("\webdesktop\webtop\en_us\css\docstyle.css");
		
			table {border-collapse:collapse;}
			table {
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
							$("#"+temp[0]).autocomplete(values,{max:20,minChars:0,matchContains:true});
							//$("#"+temp[0]).autocomplete(values,{max:20,matchContains:true,mustMatch:true});
							/*.result(function(evt,item){
								if(item!=null && item.length==1){
									var tar=item[0].split("#");
									if(tar!=null && tar!=""){										
									}									
								}

							});*/
						});	
					}		
				}
			}
			function populateListbox(codeString) {
				if(typeof codeString === "undefined"  ||codeString==null||codeString==""||codeString=="null"||codeString=="undefined")
					return;				
				
				var selArr=codeString.split("#");
				for (var i=0;i<selArr.length;i++)	{
					//one row for each loop
					var selArrVals=selArr[i].split(":");
					var selErrCode=selArrVals[0];
					var errorDesc=getErrorVal(selErrCode);
					var selectedDocCodes=selArrVals[1];
					var selectedDocNames="";
					var selectedDocCodesArr=selectedDocCodes.split("|");
					
					for (var j=0;j<selectedDocCodesArr.length;j++)	{
						if(selectedDocNames=="")
							selectedDocNames=getDocName(selectedDocCodesArr[j]);
						else
							selectedDocNames+="<br>"+getDocName(selectedDocCodesArr[j]);
					}
					
					var selErrors=selErrCode+":"+selectedDocCodes;
					var table = document.getElementById('DocErrorTable');
					var index= table.rows.length;						
					
					var cellindex=0;					
					var row = table.insertRow(index);
					
					if(document.getElementById('WSNAME').value!='CSO_Rejects')
					{
						var cell1 = row.insertCell(cellindex);
						cell1.style.width="5%";
						var radio = document.createElement("input");
						radio.type = "radio";
						radio.name="radio";
						radio.id="radio_"+index;
						cell1.appendChild(radio);
						cellindex+=1;
					}	
					
					var cell2 = row.insertCell(cellindex);
					cell2.id="cell2_"+index;
					cell2.style.width="45%";
					cell2.className="EWNormalGreenGeneral1";
					cell2.innerHTML = errorDesc;
					cellindex+=1;
					
					var cell3 = row.insertCell(cellindex);
					cell3.id="cell3_"+index;
					cell3.style.width="55%";
					cell3.innerHTML=selectedDocNames;
					cell3.className="EWNormalGreenGeneral1";
					cellindex+=1;
					
					var cell4 = row.insertCell(cellindex);
					cell4.id="cell4_"+index;
					cell4.style.display="none";
					cell4.style.width="0%";
					cell4.innerHTML=selErrors;
				}
			}
			function getErrorCode(Val){	
				var data ="";
				var code ="";
				var desc=document.getElementById("AutocompleteValues");
				if(desc)
					data=desc.value;
				if(data!=null && data!="" && data!='{}') {
					data = data.replace('{','').replace('}','');
					var arrACTFields = data.split("=")[1].split(";");
					var arrACTCodes = document.getElementById("ErrorCodes").value.replace('{','').replace('}','').split("=")[1].split(";");
					for(var i=0 ; i< arrACTFields.length ; i++)	{	
						if(Val==arrACTFields[i]){
							code=arrACTCodes[i];
							break;
						}
					}
				}
				return code;				
			}
			function getErrorVal(code){					
				var data ="";
				var Val ="";
				var desc=document.getElementById("ErrorCodes");
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
			function getDocName(code){					
				var Val ="";
				
				var namesArr=document.getElementById("DocValues").value.split(",");
				var codesArr=document.getElementById("DocCodes").value.split(",");
				
				for(var i=0 ; i< codesArr.length ; i++){	
					if(code==codesArr[i]){
						Val=namesArr[i];
						break;
					}
				}				
				return Val;
			}
			function OKClick(){
				//function modified for Email CR 08/11/2015
				var table = document.getElementById('DocErrorTable');				
				var rowcount = table.rows.length;	
				
				var Wsname=document.getElementById('WSNAMER').value;
				var Winame=document.getElementById('WINAME').value;
				var username=document.getElementById('username').value;
				var returnValue="";
				var rejectreason="";
				var select = document.getElementById('DocumentCodesList');				
				for (var i=0;i<rowcount;i++)	{
					if(returnValue=="")
						{
						returnValue=document.getElementById("cell4_"+i).innerHTML;
						rejectreason=document.getElementById("cell2_"+i).innerHTML +":" + document.getElementById("cell3_"+i).innerHTML;
						}
					else
                        
						{
						returnValue+="#"+document.getElementById("cell4_"+i).innerHTML;
						rejectreason+=","+document.getElementById("cell2_"+i).innerHTML +":" + document.getElementById("cell3_"+i).innerHTML;
						}
				}
				
				var splCharacter = '&amp;';
				var rep = new RegExp(splCharacter,'g');
				rejectreason=rejectreason.replace(rep,'and');
				
				//alert("Vidushi " +rejectreason );
				
				window.returnValue = encodeURIComponent(returnValue);
				//added by stutee
				if(!window.showModalDialog)
				   window.opener.setValue(encodeURIComponent(returnValue));
				OKCancelClicked=true;
				var ajaxReq;
				if (window.XMLHttpRequest) {
				ajaxReq= new XMLHttpRequest();
			    } else if (window.ActiveXObject) {
				ajaxReq= new ActiveXObject("Microsoft.XMLHTTP");
				}

				var url = "/webdesktop/CustomForms/AO_Specific/RejectReasonsUpdate.jsp?Wsname="+Wsname+"&Winame="+Winame+"&Rejectreason="+rejectreason+"&username="+username;


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
			function AddClick(){
			
				var table = document.getElementById('DocErrorTable');
				for(var j = 0;j<table.rows.length; j++) {
					document.getElementById("radio_"+j).checked=false;					
				}
				
				var errorDesc=document.getElementById('ErrorDescription').value;
				if(errorDesc==null||errorDesc=="")
				{
					alert("Please select Error Description");
					return;					
				}
				var selErrCode=getErrorCode(errorDesc);	
				
				if(selErrCode=="")
				{
					alert("Invalid Error Description");
					document.getElementById('ErrorDescription').focus();
					return;					
				}
				
				var select = document.getElementById('DocumentCodesList');
				var selectedDocCodes="";
				var selectedDocNames="";
				
				for(i = 0;i<select.options.length; i++) {
					if (select.options[i].selected) {
						if(selectedDocCodes=="")
						{
							selectedDocCodes=select.options[i].value;
							selectedDocNames=select.options[i].innerHTML;
						}else{
							selectedDocCodes+="|"+select.options[i].value;
							selectedDocNames+="<br>"+select.options[i].innerHTML;
						}						
					}
				}
				if(selectedDocNames=="")
				{
					alert("Please select Document Codes");
					return;					
				}
				var selErrors=selErrCode+":"+selectedDocCodes;
				var ErrorDocumentAlreadyInGrid=false;
				
				for(i = 0;i<table.rows.length; i++) 
				{
					if(document.getElementById('cell4_'+i).innerHTML==selErrors)
					{
						ErrorDocumentAlreadyInGrid=true;
						break;
					}	
				}
				if(ErrorDocumentAlreadyInGrid)
				{
					alert("Error Description-Document Code combination already present in the grid");
					return;					
				}
				
				var index= table.rows.length;					
				
				var row = table.insertRow(index);
				var cell1 = row.insertCell(0);
				cell1.style.width="5%";
				var radio = document.createElement("input");
				radio.type = "radio";
				radio.name="radio";
				radio.id="radio_"+index;
				cell1.appendChild(radio);
				
				var cell2 = row.insertCell(1);
				cell2.id="cell2_"+index;
				cell2.style.width="45%";
				cell2.className="EWNormalGreenGeneral1";
				cell2.innerHTML = errorDesc;
				
				var cell3 = row.insertCell(2);
				cell3.id="cell3_"+index;
				cell3.style.width="55%";
				cell3.innerHTML=selectedDocNames;
				cell3.className="EWNormalGreenGeneral1";
				
				var cell4 = row.insertCell(3);
				cell4.id="cell4_"+index;
				cell4.style.display="none";
				cell4.style.width="0%";
				cell4.innerHTML=selErrors;
				
				
				document.getElementById('ErrorDescription').value="";
				for(i = 0;i<select.options.length; i++) {
					select.options[i].selected=false;
				}
			}
			function DeleteClick(){
				//clear fields
				document.getElementById('ErrorDescription').value="";
				var select = document.getElementById('DocumentCodesList');
				for(var j = 0;j<select.options.length; j++) {
					select.options[j].selected=false;
				}
				
				var table = document.getElementById('DocErrorTable');
				
				var rowcount = table.rows.length;	
				if(rowcount==0)
				{
					alert("No records to delete");
					return;
				}	
				var flag=false;
				for(var i=0;i<rowcount;i++)
				{
					if(flag)
					{
						var j=i-1;
						document.getElementById("radio_"+i).id="radio_"+j;						
						document.getElementById("cell2_"+i).id="cell2_"+j;						
						document.getElementById("cell3_"+i).id="cell3_"+j;						
						document.getElementById("cell4_"+i).id="cell4_"+j;						
					}	
					else
					{
						if(document.getElementById("radio_"+i).checked)
						{
							table.deleteRow(i);
							flag=true;					
						}
					}					
				}
				if(!flag)
				{
					alert("Please select a record to delete");
				}	
			}
			function ModifyClick(){
				var table = document.getElementById('DocErrorTable');
				
				var rowcount = table.rows.length;	
				if(rowcount==0)
				{
					alert("No records to modify");
					return;
				}
				var errorDesc=document.getElementById('ErrorDescription').value;
				if(errorDesc==null||errorDesc=="")
				{
					alert("Please select Error Description");
					return;					
				}
				var selErrCode=getErrorCode(errorDesc);	
				var select = document.getElementById('DocumentCodesList');
				var selectedDocCodes="";
				var selectedDocNames="";
				
				for(i = 0;i<select.options.length; i++) {
					if (select.options[i].selected) {
						if(selectedDocCodes=="")
						{
							selectedDocCodes=select.options[i].value;
							selectedDocNames=select.options[i].innerHTML;
						}else{
							selectedDocCodes+="|"+select.options[i].value;
							selectedDocNames+="<br>"+select.options[i].innerHTML;
						}						
					}
				}
				if(selectedDocNames=="")
				{
					alert("Please select Document Codes");
					return;					
				}
				var selErrors=selErrCode+":"+selectedDocCodes;
				var flag=false;
				for(var i=0;i<rowcount;i++)
				{
					if(document.getElementById("radio_"+i).checked)
					{
						var ErrorDocumentAlreadyInGrid=false;
						var table = document.getElementById('DocErrorTable');
						for(var j = 0;j<table.rows.length; j++) 
						{
							if(document.getElementById('cell4_'+j).innerHTML==selErrors)
							{
								ErrorDocumentAlreadyInGrid=true;
								break;
							}	
						}
						if(ErrorDocumentAlreadyInGrid)
						{
							alert("Error Description-Document Code combination already present in the grid");
							return;					
						}						
						
						document.getElementById("cell2_"+i).innerHTML=errorDesc;
						document.getElementById("cell3_"+i).innerHTML=selectedDocNames;
						document.getElementById("cell3_"+i).innerHTML=selectedDocNames;
						document.getElementById("cell4_"+i).innerHTML=selErrors;
						
						//Clear values
						document.getElementById('ErrorDescription').value="";
						for(var j = 0;j<select.options.length; j++) {
							select.options[j].selected=false;
						}
						document.getElementById("radio_"+i).checked=false;
						
						flag=true;
						break;						
					}										
				}
				if(!flag)
				{
					alert("Please select a record to modify");
				}	
			}
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
	
	<body class="EWGeneralRB" bgcolor="#FFFBF0" style="border: 2px solid #b20000; border-style:outset;" onload="setAutocompleteData();populateListbox('<%=DocumentList%>');" onUnload="CancelClick(1);">		
		<table width="100%" >
			<tr><td width=100% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif" style="margin-top: 10px;"></td></tr>			
		</table>	
		<input type='hidden' name="WSNAMER" id="WSNAMER" value=<%=WSNAMER%> />
		<input type='hidden' name="WINAME" id="WINAME" value=<%=WINAME%> />
		<input type='hidden' name="username" id="username" value=<%=username%> />
		<hr style=" color: #b20000; height: 3px">
		<%
				if(!WSNAME.equalsIgnoreCase("CSO_Rejects")){
		%>	
		<table width="100%" style="border:none" cellpadding="3">
			<tr class='EWHeader' width=100%>				
				<td width="15%">&nbsp;</td>
				<td width="70%" class='EWLabelRB2' align="center"><b>Error Description</b></td>
				<td width="15%">&nbsp;</td> 
			</tr>
		<%
			}
		%>			
<%
	RejectReasonsMap.put("ErrorDescription","Item_Desc");	
	String Query="";
	String params="";
	String inputXML="";
	String outputXML="";
	String mainCodeValue="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String subXML="";	
	
	//Query="select item_code,item_desc from USR_0_AO_Doc_Desc_Master with(nolock) where isactive='Y' order by cast(display_order as int) asc ";
	
	//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	params="IsActive==Y";
	Query="select item_code,item_desc from USR_0_AO_Doc_Desc_Master with(nolock) where isactive=:IsActive order by cast(display_order as int) asc ";
	inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	
	WriteLog("inputXML exceptions-->"+inputXML);		
	outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
	WriteLog("outputXML exceptions-->"+outputXML);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	
	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	String[] docArr=null; 
	String[] docCodeArr=null; 
	String[] errorArr=null; 
	String DocCodes=""; 
	String DocValues=""; 
	if(mainCodeValue.equals("0"))
	{
		docArr = new String[recordcount];
		docCodeArr = new String[recordcount];
		for(int k=0; k<recordcount; k++)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			docCodeArr[k]=objXmlParser.getValueOf("item_code");
			docArr[k]=objXmlParser.getValueOf("Item_Desc").replaceAll("\\[|\\]", "").replaceAll("vbcrlf","<br>");
			if(DocCodes.equals(""))
			{
				DocCodes=docCodeArr[k];
				DocValues=docArr[k];
			}
			else
			{
				DocCodes+=","+docCodeArr[k];
				DocValues+=","+docArr[k];
			}	
		}		
	}	
	if(WSNAME.equalsIgnoreCase("OPS_Maker")||WSNAME.equalsIgnoreCase("OPS_Checker"))
	{
		//Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master with(nolock) where isactive='Y' and wsname='OPS' order by id asc";
		params="IsActive==Y~~wsname==OPS";
		Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master with(nolock) where isactive=:IsActive and wsname=:wsname order by id asc";
	}
	else
	{
		//Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master with(nolock) where isactive='Y' order by id asc";
		params="IsActive==Y";
		Query="select item_code,Item_Desc from USR_0_AO_Error_Desc_Master with(nolock) where isactive=:IsActive order by id asc";
	}
	//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	

	WriteLog("inputXML errors-->"+inputXML);	
	outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
	WriteLog("outputXML errors-->"+outputXML);	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputXML));

	mainCodeValue = xmlParserData.getValueOf("MainCode");
	

	recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	String items="";
	String codes="";
	if(mainCodeValue.equals("0"))
	{
		errorArr = new String[recordcount];
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
			errorArr[k]=objXmlParser.getValueOf("Item_Desc");
		}
		HashMap<String, String> AutocompleteMap = new HashMap<String, String>();
		HashMap<String, String> ErrorCodeMap = new HashMap<String, String>();
		for(Map.Entry<String, String> entry : RejectReasonsMap.entrySet()) 
		{
		  String key = entry.getKey();
		  String value = entry.getValue();
		  
		  if(outputXML.indexOf(value)>=0)
		  {
			AutocompleteMap.put(key, items);
			ErrorCodeMap.put(key, codes);
		  } 
		}
		%>
		<%
			if(!WSNAME.equalsIgnoreCase("CSO_Rejects")){
		%>
			
			<tr >			
				<td width="15%">&nbsp;</td> 
				<td width='70%' style="text-align: center;vertical-align: top;" align="top"   nowrap='nowrap' >
					<input type='text' style="width:480px;" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value' size = '32' name='ErrorDescription' id="ErrorDescription" value = '' class='EWNormalGreenGeneral1'>
					</td>
				<td width="15%">&nbsp;</td> 	
			</tr>
			<tr style="line-height: 3px;">	
				<td width="15%">&nbsp;</td> 
				<td width="70%">&nbsp;</td>	
				<td width="15%">&nbsp;</td> 						
			</tr>
			<tr class='EWHeader'>	
				<td width="15%">&nbsp;</td> 
				<td width="70%" class='EWLabelRB2' align="center"><b>Document Code</b></td>	
				<td width="15%">&nbsp;</td> 						
			</tr>			
			<tr>	
				<td width="15%">&nbsp;</td> 
				<td  width='70%'  style="text-align: center;vertical-align: top;" nowrap='nowrap' class='EWNormalGreenGeneral1'>
				<select multiple="multiple" style="width:480px;" class="EWNormalGreenGeneral1" id="DocumentCodesList" size=7>
					
					<%
					for(int i=0;i<docCodeArr.length;i++) 
					{
					%>
						<option value="<%=docCodeArr[i]%>" ><%=docArr[i]%></option>
					<%
					}
					%>
				</select>
				</td>
				<td width="15%">&nbsp;</td> 									
		</tr>
		<tr >	
				<td width="15%">&nbsp;</td> 
				<td width="70%">&nbsp;</td>	
				<td width="15%">&nbsp;</td> 						
			</tr>		
		<tr>
			<td style="text-align: center;" width="17%"></td>
			<td style="text-align: center;" width="70%">
				<input type="button" action="" value="&nbsp;&nbsp;&nbsp;Add &nbsp;" onclick="AddClick();" class="EWButtonRB">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" action="" value="&nbsp;&nbsp;&nbsp;Delete &nbsp;" onclick="DeleteClick();" class="EWButtonRB">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" action="" value="&nbsp;&nbsp;&nbsp;Modify &nbsp;" onclick="ModifyClick();" class="EWButtonRB">
			</td>
			<td style="text-align: center;" width="15%"></td>
		</tr>
		<tr style="line-height: 3px;">	
				<td width="15%">&nbsp;</td> 
				<td width="70%">&nbsp;</td>	
				<td width="15%">&nbsp;</td> 						
		</tr>
		</table>
		
	
		<%}%>
		<div style="border:none;">
		<table width="100%" style="border:none" cellpadding="3">
			<tr class='EWHeader' width=100% class='EWLabelRB2'>
				<%if(WSNAME.equalsIgnoreCase("CSO_Rejects"))
				{
					//
				}else{
				%>
				<td width="5%" class="EWLabelRB2"><b></b></td>
				<%
				}	
				%>
				<td width="45%" align="center" class="EWLabelRB2"><b>Error Description</b></td>
				<td width="50%" align="center" class="EWLabelRB2"><b>Document Code</b></td>				
				<td style="display:none;" ></td>				
			</tr>
		</table>
		</div>
		<%
			String height="200";
			if(WSNAME.equalsIgnoreCase("CSO_Rejects"))
			{
				height="400";
			}			
		%>	
		<div style="overflow: auto;width:100%;height: <%=height%>px; border: none;">
			<div>
				<table id="DocErrorTable" style="border:1px solid black" width="100%" border="2" cellpadding="3">
					
				</table>
			</div>
		</div>	
		<input type=hidden name='AutocompleteValues' id='AutocompleteValues' value='<%=AutocompleteMap%>' style='display:none' >
		<input type=hidden name='ErrorCodes' id='ErrorCodes' value='<%=ErrorCodeMap%>' style='display:none' >
		<input type=hidden name='DocCodes' id='DocCodes' value='<%=DocCodes%>' style='display:none' >
		<input type=hidden name='DocValues' id='DocValues' value='<%=DocValues%>' style='display:none' >
		<input type=hidden name='WSNAME' id='WSNAME' value='<%=WSNAME%>' style='display:none' >
		<%
	}
%>		
					
		<div align="center"> 
			<%
				if(!WSNAME.equalsIgnoreCase("CSO_Rejects")){
			%><input type="button" action="" value="&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;" onclick="OKClick();" class="EWButtonRB">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<input type="button" action="" value="Close" onclick="CancelClick(2);" class="EWButtonRB">
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