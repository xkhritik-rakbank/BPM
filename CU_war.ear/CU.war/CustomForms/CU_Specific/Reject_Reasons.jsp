<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAK Bank 
//Module                     : Request-Screen Form Painitng
//File Name					 : RejectReasons.jsp          
//Author                     : Mandeep Singh
// Date written (DD/MM/YYYY) : 27-Jan-2016
//Description                : Reject Reasons
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ include file="../CU_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<script language="javascript" src="/CU/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/CU/webtop/scripts/jquery.autocomplete.js"></script>
<script language="javascript">
	var OKCancelClicked=false;
</script>

<%
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ReasonCodes"), 1000, true) );
			String ReasonCodes_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepName"), 1000, true) );
			String workstepName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("username"), 1000, true) );
			String username_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
	Map<String,String> RejectReasonsMap = new HashMap<String, String>();
	//String RejectReasons=request.getParameter("ReasonCodes");	
	String RejectReasons=request.getParameter("ReasonCodes");	
	if (RejectReasons != null) {RejectReasons=RejectReasons.replace("'","''");}
	//String WSNAME=request.getParameter("workstepName");	
	String WSNAME=workstepName_Esapi;	
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
	String WSNAMER=WSNAME.replace(" ","_");
	//String WINAME=request.getParameter("wi_name");
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
   // String username=request.getParameter("username");
	String username=username_Esapi;
	if (username != null) {username=username.replace("'","''");}
	String params = "";
	WriteLog("ReasonCodes_Esapi :"+ReasonCodes_Esapi );
	WriteLog("wi_name_Esapi:"+wi_name_Esapi);
	WriteLog("username_Esapi:"+username_Esapi);
	WriteLog("workstepName_Esapi:"+workstepName_Esapi);
	
%>
<html>
	<head>
		<title>Reject Reasons</title>
		<link rel="stylesheet" href="\CU\webtop\en_us\css\docstyle.css">
		<link rel="stylesheet" href="\CU\webtop\en_us\css\jquery.autocomplete.css">
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="0" />
		<style>
			table {border-collapse:collapse;}
			table, th, td {
				border: none;
				
			}
			body{
				bgcolor:"#FFFBF0";
			}
			
			.scrollable{
			   overflow-x: scroll;
			   overflow-y: auto;
			   width: 400px; 
			   height: 150px; 
			   border: 1px silver solid;
			}
			.scrollable select{
			   border: none;
			}
		
		</style>
		<script language="JavaScript"> 
//***********************************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :   Application Projects
//Project                             :   Rakbank - Cif Update
//Date Modified                       :   11/03/2016      
//Author                              :   Shubham
//Description                		  :   This function sets the autocomplete data form database to the input

//***********************************************************************************************************//
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
//*****************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED                               
//Group                               :    Application Projects   
//Project                             :    Rakbank - Telegraphic Transfer    
//Date Modified                       :    27-Jan-2016                   
//Author                              :    Mandeep
//Description                		  :    This functions handles the event of the Ok button     

//*****************************************************************************************//
			function AddClick()	{
				var Val = document.getElementById('RejectReasons').value;
				
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
						opt.length = Val.length;
						opt.className="EWNormalGreenGeneral1";
						select.appendChild(opt);
					}	
					document.getElementById('RejectReasons').value='';							
				}
			}

//*******************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :    Application Projects
//Project                             :    Rakbank - Telegraphic Transfer           
//Date Modified                       :    27/01/2016                
//Author                              :    Mandeep
//Description                		  :    This function populate the list box with the values    

//********************************************************************************************//			
			function populateListbox(codeString) {
				
				if(typeof codeString === "undefined"  ||codeString==null||codeString==""||codeString=="null"||codeString=="undefined")
					return;	
					
				var codesArr=codeString.split("#");
				for (var i=0;i<codesArr.length;i++)	{
					
					var fieldVal=getVal(codesArr[i]);
					
					var select = document.getElementById('RejectReasonsList');
					var found=false;
					for(var i=0;i<select.options.length;i++){
						if(select.options[i].value==fieldVal){							
							found=true;
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
//***************************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :   Application Projects
//Project                             :   Rakbank - Telegraphic Transfer         
//Date Modified                       :   27/01/2016                
//Author                              :   Mandeep
//Description                		  :   This function removes the selected items from the select box       

//***************************************************************************************************//			
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
//*******************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :   Application Projects
//Project                             :   Rakbank - Telegraphic Transfer         
//Date Modified                       :   27/01/2016                
//Author                              :   Mandeep
//Description                		  :   This function returns the code of the given value       

//********************************************************************************************//			
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
//*****************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :   Application Projects
//Project                             :   Rakbank - Telegraphic Transfer           
//Date Modified                       :   27/01/2016                
//Author                              :   Mandeep
//Description                		  :   This function returns the value of a given code       

//******************************************************************************************//			
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

 

//Group                               :   Application Projects
//Project                             :   Rakbank - Telegraphic Transfer          
//Date Modified                       :   27/01/2016                
//Author                              :   Mandeep
//Description                		  :   This function handles the event of Ok button

//***********************************************************************************//			
			function OKClick()
			{			
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
                       // alert(select.options[i].value);						
					}
					else
					{
						returnValue+="#"+getCode(select.options[i].value);
						rejectreason+=","+select.options[i].value;
						//alert(select.options[i].value);	
					}
				}
				
				window.returnValue = returnValue;
				
				OKCancelClicked=true;		 
				//added by stutee
				if(!window.showModalDialog)
				   window.opener.setValue(returnValue);
				window.close();
			}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :  Application Projects
//Project                             :  Rakbank - CIF Update           
//Date Modified                       :  11/03/2016                
//Author                              :  Shubham
//Description                		  :  This function handles the event of Cancel button   

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
		<tr><td width=100% align=right valign=center><img src="\CU\webtop\images\rak-logo.gif" style="margin-top: 15px;"></td></tr>
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
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;
	String subXML="";	
	
	Query="select item_code,Item_Desc from USR_0_CU_Error_Desc_Master with(nolock) where isactive='Y' AND workstename=:workstename order by id ASC";
	params = "workstename=="+WSNAME;
	WriteLog("Query for getting reject reasons"+Query);
	
	inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	//WriteLog("inputXML exceptions-->"+inputXML);
	outputXML = WFCustomCallBroker.execute(inputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("outputXML exceptions-->"+outputXML);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((outputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	
	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
	String items="";
	String codes="";
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if(items.equals(""))
			{
				items=objWorkList.getVal("Item_Desc");
				codes=objWorkList.getVal("item_code");
			}	
			else 
			{
				items+=";"+objWorkList.getVal("Item_Desc");
				codes+=";"+objWorkList.getVal("item_code");
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
				
				<tr><td width="100%" class="EWNormalGreenGeneral1"><b>Reject Reasons </b></td></tr>
				<tr><td width='100%'  align="center" nowrap='nowrap' class='EWNormalGreenGeneral1'>
					 <input type='text' style="width:400;" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value' size = '32' name='RejectReasons' id="RejectReasons" value = '' ></td>
				</tr>
				<tr>
					<td width="100%"  class="EWNormalGreenGeneral1"><b>Selected Reject Reasons</b></td></tr>
					<tr>
						<td width='100%' align="center" nowrap='nowrap' class='EWNormalGreenGeneral1'>
							<div class="scrollable">
								<select multiple="multiple" style="width:630px;" id="RejectReasonsList" size='14'></select>
							</div>
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
			<input type="button" action="" value="Add" onclick="AddClick();" class="EWButtonRB" >
			<input type="button" action="" value="Remove" onclick="RemoveSelected();" class="EWButtonRB" >
			<input type="button" action="" value="Save & Exit" onclick="OKClick();" class="EWButtonRB" >
		</div>
	
	</body>
	
	
</html>
