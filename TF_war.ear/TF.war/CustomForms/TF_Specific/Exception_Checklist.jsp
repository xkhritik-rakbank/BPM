<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
)//Module                     : TF
//File Name					 : Exception_Checklist.jsp            
//Author                     : Mandeep, Modified by Nikita for RMT
// Date written (DD/MM/YYYY) : 12/01/2018
//Description                : Exception Checklist Screen
//---------------------------------------------------------------------------------------------------->

<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>

<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%!
	String alreadyRaisedExceptions = "";

	public String loadExceptions (String WINAME,String WSNAME,String segment,String H_CHECKLIST,String sessionId,String cabName,String ipAddr,int port,HashMap<String,String> canRaiseMap,HashMap<String,String> canClearMap,String userName)
	{
		WriteLog("Start of load exceptions--"+WSNAME);
		
		StringBuilder wsnames = new StringBuilder();
		StringBuilder userNames = new StringBuilder();
		StringBuilder decisions = new StringBuilder();
		StringBuilder actionDateTime = new StringBuilder();		
		String raisedExceptions="";
		
		//map to contain all the raised from the DB
		HashMap<String,ArrayList<String>> raisedMap = new HashMap<String,ArrayList<String>>();
		
		try{
		
			String inputXML = "";
			String outputXML="";
			String mainCodeValue="";
			
			WFCustomXmlResponse xmlParserData=null;
			WFCustomXmlList objWorkList=null;
			
			String subXML ="";
			String Query = "select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_TF_EXCEPTION_HISTORY where winame='"+WINAME+"' order by ExcpCode asc, cast(convert(varchar(24),actiondatetime+':000',113) as datetime) desc";
		
			inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";			
			
			outputXML = WFCustomCallBroker.execute(inputXML, ipAddr, port, 1);
			WriteLog("outputXML selecting exceptions -- "+outputXML);
			
			xmlParserData=new WFCustomXmlResponse();
			xmlParserData.setXmlString((outputXML));
			
			mainCodeValue = xmlParserData.getVal("MainCode");
			int recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));

			if(recordcount > 0 && mainCodeValue.equals("0")) {
				String ExcpCode="";
				objWorkList = xmlParserData.createList("Records","Record");
				WriteLog("ExcpCode"+ExcpCode);				
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					if(ExcpCode.equals(""))
					{
						ExcpCode=objWorkList.getVal("ExcpCode");
						raisedExceptions=ExcpCode+"~["+objWorkList.getVal("Decision")+"-"+objWorkList.getVal("UserName")+"-"+objWorkList.getVal("WSName")+"-"+objWorkList.getVal("ActionDateTime")+"]";				
					}
					else if(ExcpCode.equals(objWorkList.getVal("ExcpCode")))
					{
						raisedExceptions+="["+objWorkList.getVal("Decision")+"-"+objWorkList.getVal("UserName")+"-"+objWorkList.getVal("WSName")+"-"+objWorkList.getVal("ActionDateTime")+"]";					   
					}
					else
					{
						ExcpCode=objWorkList.getVal("ExcpCode");
						raisedExceptions+="#"+objWorkList.getVal("ExcpCode")+"~["+objWorkList.getVal("Decision")+"-"+objWorkList.getVal("UserName")+"-"+objWorkList.getVal("WSName")+"-"+objWorkList.getVal("ActionDateTime")+"]";
					}
				}
			}
			
			//For checking which exceptions are raised for current workstep
			alreadyRaisedExceptions = raisedExceptions;
			
			WriteLog("raisedExceptions from the DB -- "+raisedExceptions);
			WriteLog("H_CHECKLIST from the front end -- "+H_CHECKLIST);
			//Merge the exceptions
			raisedExceptions=mergeException(raisedExceptions,H_CHECKLIST);
			
			WriteLog("raisedExceptions after merging the updated exceptions -- "+raisedExceptions);

			String htmlraised="";
			String htmlunraised="";
			String Initiating_Unit_Column="";

			Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_TF_EXCEPTION_CHECKLIST_MASTER where IsActive='Y' AND wsname='"+WSNAME+"' AND canView= 'Y' and processname='TF' order by id Asc";
			
			inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";
			
			WriteLog("inputXML ---- "+inputXML);
			outputXML = WFCustomCallBroker.execute(inputXML, ipAddr, port, 1);			
			WriteLog("outputxml ---- "+outputXML);
			xmlParserData=new WFCustomXmlResponse();
			xmlParserData.setXmlString((outputXML));
			mainCodeValue = xmlParserData.getVal("MainCode");
			
			recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
			
			//WriteLog("Query Exception Checklist -- "+Query);
			
			//WriteLog("mainCodeValue -- "+mainCodeValue);
			
			if(mainCodeValue.equals("0"))
			{
				objWorkList = xmlParserData.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					String item=objWorkList.getVal("Checklist_Item_Desc").replaceAll("\\[|\\]", "").replaceAll("vbcrlf","<br>");/////
					String itemCode=objWorkList.getVal("Checklist_Item_Code");
					String relatedWorkstep=objWorkList.getVal(Initiating_Unit_Column);
					String approvalUnit=objWorkList.getVal("Approving_Unit");					
					
					WriteLog("raisedExceptions - "+raisedExceptions);
					WriteLog("raisedExceptions 1- "+raisedExceptions.indexOf(itemCode+"~"));
					WriteLog("raisedExceptions 2- "+("ARCHIVE,".indexOf(WSNAME.toUpperCase()+",")));
					WriteLog("raisedExceptions 3- "+("CSM_Approval,".indexOf(WSNAME.toUpperCase()+",")));
					//WriteLog("item & itemCode- "+item+"	& "+itemCode);
					WriteLog("WSNAME - "+WSNAME);
					
					if(raisedExceptions.indexOf(itemCode+"~")>-1)
					{
						//WriteLog("raisedExceptions.indexOf(itemCode+~)>-1 -"+(raisedExceptions.indexOf(itemCode+"~")>-1));
						htmlraised+=getRow(itemCode,raisedExceptions,relatedWorkstep,approvalUnit,WSNAME,item,canRaiseMap,canClearMap);	
					}
					//Unraised not to be viewed
					else if("ARCHIVE,".indexOf(WSNAME.toUpperCase()+",")>-1)
					{
						//WriteLog("(Archive,indexOf(WSNAME.toUpperCase()+,)>-1) -"+("Archive,".indexOf(WSNAME.toUpperCase()+",")>-1));
						htmlunraised="";
					}
					else if("CSM_APPROVAL,TF_CHECKER,CONTROL".indexOf(WSNAME.toUpperCase()+",")>-1)
					//Raise New
					{
						String canRaise = canRaiseMap.get(itemCode);
						String canClear = canClearMap.get(itemCode);
						WriteLog("canRaise for - "+WSNAME+"	"+canRaise);
						WriteLog("canClear for - "+WSNAME+"	"+canClear);
						
						if (canRaise.equals("Y"))
							htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onchange='setDateTime(this.id);' value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
						else
							htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' disabled value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
							
						
						htmlunraised+="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
						htmlunraised+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'><br><br></td></tr>";
					}
					else
					{
						
						htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' disabled  value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
						htmlunraised+="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
						htmlunraised+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'><br><br></td></tr>";
					}			
				}	
				return (htmlraised + htmlunraised);
			}
			else
			{
				return("Some error at server end. Please contact Administrator.");
			}
		}
		catch (Exception e)
		{
			return("Some error at server end. Please contact Administrator.");
		}
    }

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :  Application Projects
//Project                             :  RMT       
//Date Modified                       :  12-01-2018
//Author                              :  Mandeep, Modified by Nikita for RMT
//Description                		  :  This function merges the exception from already raised with current raised        

//***********************************************************************************//	
	public String mergeException(String raisedExcps,String updatedExceptions){ 
	
		if(raisedExcps==null||raisedExcps.equals(""))
			return updatedExceptions;
		if(updatedExceptions==null||updatedExceptions.equals(""))
			return raisedExcps;	
       	 	
		String[] updatedExcps=updatedExceptions.split("#");
		
		for (int i=0;i<updatedExcps.length;i++)
		{
			String[] codeArr=updatedExcps[i].split("~");
			
			if(raisedExcps.indexOf(codeArr[0]+"~")>-1)
			{
				if(raisedExcps.substring(raisedExcps.indexOf(codeArr[0]+"~")+(codeArr[0]+"~").length()).indexOf(codeArr[1]) == -1)
				{
					raisedExcps = raisedExcps.substring(0, raisedExcps.indexOf(codeArr[0]+"~"))+updatedExcps[i]+raisedExcps.substring(raisedExcps.indexOf(codeArr[0]+"~")+(codeArr[0]+"~").length());
				}
			}
			else
			{
				raisedExcps+="#"+updatedExcps[i];
			}
		}
		
		return raisedExcps;
    }
//**************************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank  Account-Opening-Automation//Date Written        
//Date Modified                       :  12-01-2018        
//Author                              :  Mandeep, Modified by Nikita for RMT
//Description                		  :  This function is used to get the row according to the view

//**************************************************************************************************//		
	public String getRow(String itemCode,String raisedExceptions,String relatedWorkstep,String approvalUnit,String WSNAME,String item,HashMap<String,String> canRaiseMap,HashMap<String,String> canClearMap)
	{
		WriteLog("Getting Row Description and the checkbox for the itemCode -- "+itemCode);
		
		String row="";
		String excepVal="";
		
		WriteLog("Value of raisedExceptions in getRow() -- "+raisedExceptions);
		
		int indexOfHash=raisedExceptions.indexOf("#",raisedExceptions.indexOf(itemCode+"~"));

		if(indexOfHash<0)
			excepVal=raisedExceptions.substring(raisedExceptions.indexOf(itemCode+"~")+(itemCode+"~").length());			
		else	
			excepVal=raisedExceptions.substring(raisedExceptions.indexOf(itemCode+"~")+(itemCode+"~").length(),indexOfHash);
			
		WriteLog("excepVal	-- "+excepVal);

		WSNAME = WSNAME.toUpperCase();

		WriteLog("Value of WSNAME - "+WSNAME);
	
		if(WSNAME.equalsIgnoreCase("TF_CHECKER") || WSNAME.equalsIgnoreCase("TF_MAKER"))			
		{
			WriteLog("excepVal.indexOf([Raised"+excepVal.indexOf("[Raised"));
			
			if(excepVal.indexOf("[Raised")==0)
			{
				if (canClearMap.get(itemCode).equals("Y"))
				{
					WriteLog("In history it is raised but "+WSNAME+" can clear - "+canClearMap.get(itemCode));
					
					row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onchange='setDateTime(this.id);' value='true' checked/>&nbsp;&nbsp;&nbsp;</td>";
					
					row+=getExceptionHistory(itemCode,item,excepVal);
				}
				else
				{
					WriteLog("In history it is raised but "+WSNAME+" can clear - "+canClearMap.get(itemCode));
					
					row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' disabled value='true' checked/>&nbsp;&nbsp;&nbsp;</td>";
					row+=getExceptionHistory(itemCode,item,excepVal);
				}
			}
			else if(excepVal.indexOf("[Approved")==0)
			{
				if (canRaiseMap.get(itemCode).equals("Y"))
				{
					row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onchange='setDateTime(this.id);' value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
					row+=getExceptionHistory(itemCode,item,excepVal);
				}
				else
				{
					row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' disabled value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
					row+=getExceptionHistory(itemCode,item,excepVal);
				}
				
			}
		}	
		
		return row;
    }
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :  30-11-2017        
//Author                              :  Mandeep, Modified by Ankit for RAO
//Description                		  :  This function is used to get the exception history        

//***********************************************************************************//		
	public String getExceptionHistory(String itemCode,String item,String exceptionDetails){
	
		WriteLog("Getting Rest of the fields for the itemCode -- "+itemCode);
		WriteLog("exceptionDetails -- "+exceptionDetails);

		String html="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
		String histPAU="";
		String histUser="";
		String histDec="";
		String histDateTime="";
		while(exceptionDetails.indexOf("[")>-1)
		{
			String strTemp[]=exceptionDetails.substring(1,exceptionDetails.indexOf("]")).split("-");
			
			//History Description
			if(histDec.equals(""))			
				histDec=strTemp[0];
			else 
				histDec+="<br>"+strTemp[0];
			
			//History User
			if(histUser.equals(""))	
				histUser=strTemp[1]; 
			else 
				histUser+="<br>"+strTemp[1];

			//History PAU
			if(histPAU.equals(""))	
				histPAU=strTemp[2]; 
			else
				histPAU+="<br>"+strTemp[2];
			
			//History DateTime
			if(histDateTime.equals(""))	
				histDateTime=strTemp[3]; 
			else 
				histDateTime+="<br>"+strTemp[3];
				
			exceptionDetails=exceptionDetails.substring(exceptionDetails.indexOf("]")+1);
		}
		
		WriteLog("Updated exceptionDetails -- "+exceptionDetails);
		
		html+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>"+histPAU+"</td>";
		html+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>"+histUser+"</td>";
		html+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>"+histDec+"</td>";		
		html+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'>"+histDateTime+"</td></tr>";

		return html;
	}
	
%>

<%
	WriteLog("Start of Exception History Checklist");
	
	HashMap<String, String> autocompleteMap = new HashMap<String, String>();
	HashMap<String, String> codeMap = new HashMap<String, String>();
	HashMap<String, String> rejectReasonsMap = new HashMap<String, String>();
	HashMap<String, String> canRaiseMap = new HashMap<String, String>();
	HashMap<String, String> canClearMap = new HashMap<String, String>();
	
	String userName = "";
	String wsname = request.getParameter("workstepName");
	if (wsname != null) {wsname=wsname.replace("'","''");}
	String winame = request.getParameter("wi_name");
	if (winame != null) {winame=winame.replace("'","''");}
	String H_CHECKLIST = request.getParameter("H_CHECKLIST").replaceAll("ER","Raised").replaceAll("EU","Approved");
	//To handle too much unsaved data at one step
	String items="";
	String codes="";
	String ibmbCase = request.getParameter("ibmbCase");

	//WriteLog("Got the H_CHECKLIST form the request "+H_CHECKLIST);
	
	String sessionId = customSession.getDMSSessionId();
	String cabName = customSession.getEngineName();
	String ipAddr = customSession.getJtsIp();
	int port = customSession.getJtsPort();
	
	rejectReasonsMap.put("excepChecklistAutoComplete","Checklist_Item_Code");	
	String query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit,canRaise,canClear from USR_0_TF_EXCEPTION_CHECKLIST_MASTER where IsActive='Y' and wsname = '"+wsname+"' and canView= 'Y' and processname='TF' order by id Asc";
	
	String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" +sessionId + "</SessionId></APSelectWithColumnNames_Input>";
		
	WriteLog("Exception Query 1 - "+query);	
		
	String outputXML = WFCustomCallBroker.execute(inputXML, ipAddr, port, 1);
	
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((outputXML));
	String mainCodeValue = xmlParserData.getVal("MainCode");
	
	String subXML="";
	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
	
	WriteLog("Record Ankit"+recordcount);
	if(mainCodeValue.equals("0"))
	{
		WriteLog("Inside if block 79");
		objWorkList = xmlParserData.createList("Records","Record"); 
		WriteLog("objWorkList"+objWorkList);
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			String item=objWorkList.getVal("Checklist_Item_Desc").replaceAll("\\[|\\]", "").replaceAll("vbcrlf","<br>");
			WriteLog("item"+item);
			String itemCode=objWorkList.getVal("Checklist_Item_Code");
			WriteLog("itemcode"+itemCode);
			String canRaise = objWorkList.getVal("canRaise");
			WriteLog("canRaise"+canRaise);
			String canClear = objWorkList.getVal("canClear");
			WriteLog("canClear"+canClear);
			
			if(codes==null||codes.equals(""))
			{
				codes=itemCode;
				items=item;
				canRaiseMap.put(itemCode,canRaise);
				canClearMap.put(itemCode,canClear);
			}	
			else
			{
				codes+=";"+itemCode;
				items+=";"+item;
				canRaiseMap.put(itemCode,canRaise);
				canClearMap.put(itemCode,canClear);
			}
		}
		for(Map.Entry<String, String> entry : rejectReasonsMap.entrySet()) 
		{
			String key = entry.getKey();
			String value = entry.getValue();

			if(outputXML.indexOf(value)>=0)
			{
				autocompleteMap.put(key, items);
				codeMap.put(key, codes);
			} 
		}
	}
	WriteLog("End of Exception History Checklist");
%>
<!DOCTYPE html>

<head>
<title>Exceptions  for Approval</title>
<link rel="stylesheet" href="\webdesktop\webtop\en_us\css\docstyle.css">
<link rel="stylesheet" href="\webdesktop\webtop\en_us\css\jquery.autocomplete.css">
<style>	
	table {border-collapse:collapse;}
	table {
		border: none;
	}
	td {
		border: 1px solid black;
	}
	body{
		bgcolor:"#FFFBF0";
	}
	br {
		display: block;
		margin-bottom: 2px;
		font-size:2px;
		line-height: 10px;
	}
	
	.EWHeader{
		background-color : rgba(151, 0, 51, 1)
	}
	
</style>
</head>

<body class="EWGeneralRB" bgcolor="#FFFBF0" onload="setAutocompleteData();" onUnload="CancelClick(1);">

<br/>
<div width="100%" align="right" >
	<th width=90% align=right valign=center><img style="padding-right:20px;" src="\webdesktop\webtop\images\rak-logo.gif"></th>			
</div>
<div class="EWNormalGreenGeneral1"> 
	&nbsp;&nbsp;&nbsp;<b>Exceptions For Approval: </b>&nbsp;
	<input type='text' style="width:50%;" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value' size = '32' name='excepChecklistAutoComplete' id="excepChecklistAutoComplete" value = ''>
</div>
<table id="exceptionTable" border='2' width="830" border="0" cellpadding="3" style="margin-left:2px;">
	<tr class='EWHeader' width=100% class='EWLabelRB2'>
		<td width="29" class="EWLabelRB2"><b>Items</b></td>
		<td width="339" class="EWLabelRB2"><b>Exception</b></td>
		<td width="96" class="EWLabelRB2"><b>Workstep</b></td>
		<td width="92" class="EWLabelRB2"><b>User Name</b></td>
		<td width="123" class="EWLabelRB2"><b>Decision Taken</b></td>
		<td width="168" colspan=2 class="EWLabelRB2"><b>Date and Time</b></td>
	</tr>

	<%
	userName = customSession.getUserName();
	userName = userName.trim();
	WriteLog("here is the username " + userName);
	out.println(loadExceptions(winame,wsname,"PBN",H_CHECKLIST,sessionId,cabName,ipAddr,port,canRaiseMap,canClearMap,userName));
	%>

<br/>
</table>
	<br/>
	<input type="button" style="margin-left:350px;" width="30" action="" value="&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;" onclick="OKClick()" class="EWButtonRB">
	<input type="button" width="30" action="" value="Cancel" onclick="CancelClick(2)" class="EWButtonRB">
			
<input type="hidden" name='autocompleteValues' id='autocompleteValues' value='<%=autocompleteMap%>' >
<input type="hidden" name='codeValues' id='codeValues' value='<%=codeMap%>'>
<input type="hidden" name='canRaiseMap' id='canRaiseMap' value=''>
<input type="hidden" name='canClearMap' id='canClearMap' value=''>
<input type="hidden" id="userName" name="userName" value="<%=userName%>">
<input type="hidden" id="alreadyRaisedExceptions" name="alreadyRaisedExceptions" value=''>

<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>
<script>
var wsname = '<%=wsname%>';
var OKCancelClicked=false;

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer
//Date Modified                       :  12-Jan-2018
//Author                              :  Mandeep, Modified by Nikita for RMT
//Description                		  :  This function gets the current date and time

//***********************************************************************************//				
function getDateTime() {
	var monthNames = new Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec");
	now = new Date();
	year = "" + now.getFullYear();
	month = "" + monthNames[now.getMonth()];
	day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
	hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
	minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
	second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
	return day + "/" + month + "/" + year + "  " + hour + ":" + minute + ":" + second;
}
			

//*****************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED


//Group                               : Application Projects
//Project                             : Rak Money Transfer       
//Date Modified                       : 12-Jan-2018         
//Author                              : Mandeep, Modified by Nikita for RMT
//Description                		  : This function handles the event at the Ok button        

//******************************************************************************************//				
function OKClick() {
	var inputs = document.getElementsByTagName("input");
	var id="";
	var returnValue="";
	var raisedExcepDesc = "";
	for (x=0;x < inputs.length;x++)
	{
		var exceptionsFromDB = document.getElementById('alreadyRaisedExceptions').value; 
		if(inputs[x].id.indexOf("Item_Checkbox_")<0)
			continue;
			
		id = inputs[x].id.replace("Item_Checkbox_","");
		
		
		if (document.getElementById("Item_Dec_"+id).innerHTML==""||document.getElementById("Item_Dec_"+id).innerHTML=="&nbsp;")
			continue;
		
		//Point number 243-04052016
        if (document.getElementById("Item_Dec_"+id).innerHTML.split("<br>")[0] == 'Raised') {
            //Populate descriptions of the raised exceptions
			if (raisedExcepDesc=="")
				raisedExcepDesc = raisedExcepDesc + document.getElementById("Item_Desc_"+id).innerHTML.split("<br>")[0];
			else
				raisedExcepDesc = raisedExcepDesc + " AND " + document.getElementById("Item_Desc_"+id).innerHTML.split("<br>")[0];
        }
		
		//if(document.getElementById("Item_PAU_"+id).innerHTML.split("<br>")[0]!=wsname)
			//continue;

		var decision=document.getElementById("Item_Dec_"+id).innerHTML.split("<br>")[0];
		
		if(exceptionsFromDB !="") {
			var alreadyRaisedExceptions = exceptionsFromDB.split("#");
			var tempExcep = id + "~["+decision+"-"+document.getElementById("Item_User_"+id).innerHTML.split("<br>")[0]+"-"+document.getElementById("Item_PAU_"+id).innerHTML.split("<br>")[0]+"-"+document.getElementById("Item_DateTime_"+id).innerHTML.split("<br>")[0]+"]";
			var alreadyInException = false;
			for (var y=0;y < alreadyRaisedExceptions.length;y++) {
				if (alreadyRaisedExceptions[y].indexOf(tempExcep) == 0) {
					alreadyInException=true;
					break;
				}
			}
			if (alreadyInException==false) {
				if(returnValue=="")
					returnValue=  tempExcep;
				else
					returnValue+="#"+ tempExcep;
				
				//Populate descriptions of the raised exceptions
				/*if (raisedExcepDesc=="")
					raisedExcepDesc = raisedExcepDesc + document.getElementById("Item_Desc_"+id).innerHTML.split("<br>")[0];
				else 
					raisedExcepDesc = raisedExcepDesc + " AND " + document.getElementById("Item_Desc_"+id).innerHTML.split("<br>")[0];*/
			}
		}
		else {
			var tempExcep = id + "~["+decision+"-"+document.getElementById("Item_User_"+id).innerHTML.split("<br>")[0]+"-"+document.getElementById("Item_PAU_"+id).innerHTML.split("<br>")[0]+"-"+document.getElementById("Item_DateTime_"+id).innerHTML.split("<br>")[0]+"]";

			if(returnValue=="")
				returnValue=  tempExcep;
			else
				returnValue+="#"+ tempExcep;
			
			//Populate descriptions of the raised exceptions
			/*if (raisedExcepDesc=="")
				raisedExcepDesc = raisedExcepDesc + document.getElementById("Item_Desc_"+id).innerHTML.split("<br>")[0];
			else 
				raisedExcepDesc = raisedExcepDesc + " AND " + document.getElementById("Item_Desc_"+id).innerHTML.split("<br>")[0];*/
		}
	}
	
	//Populate descriptions of the raised exceptions
	returnValue = returnValue + "@" + raisedExcepDesc;
	
	window.returnValue = returnValue;
	OKCancelClicked=true;
	window.close();
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 
//Group                               : Application Projects
//Project                             : Rakbank - Telegraphic Transfer       
//Date Modified                       : 28-Jan-2016         
//Author                              : Mandeep, Modified by Ankit for RAO
//Description                		  : This function handles the event at the Cancel button  

//***********************************************************************************//				
function CancelClick(opt) {
	
	if(opt==2)
	{
		window.returnValue = "NO_CHANGE";
		OKCancelClicked=true;
	}	
	else if(!OKCancelClicked)
		window.returnValue = "NO_CHANGE";

	window.close();
}
			
//********************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :   Application Projects
//Project                             :   Rakbank - Telegrahic Transfer        
//Date Modified                       :   01-12-2017       
//Author                              :   Mandeep, Modified by Ankit for RAO
//Description                		  :   This function sets the data to the input as autocomplete

//*********************************************************************************************//				
function setAutocompleteData() {
	var data ="";
	var ele=document.getElementById("autocompleteValues");

	if(ele)
		data=ele.value;
	if(data!=null && data!="" && data!='{}'){
		data = data.replace('{','').replace('}','');
		var arrACTFields = data.split("fsjkhgkjdfsghjdh");
		for(var i=0 ; i< arrACTFields.length ; i++){
			var temp = arrACTFields[i].split("=");
			var values = temp[1].split(";");
			
			$(document).ready(function(){
				$("#"+temp[0]).autocomplete(values,{max:10,matchContains:true,mustMatch:true}).result(function(evt,item){
					if(item!=null && item.length==1){
						var tar=item[0].split("#");
						if(tar!=null && tar!="") {
							var code=getCode(tar);
							
							if(!document.getElementById("Item_Checkbox_"+code).checked)
							{
								document.getElementById("Item_Checkbox_"+code).click();
							}
							else if (document.getElementById("Item_Checkbox_"+code).checked)
							{
								document.getElementById("Item_Checkbox_"+code).click();
							}
							document.getElementById("Item_Checkbox_"+code).focus();
							document.getElementById('excepChecklistAutoComplete').value='';
						}
					}
				});				
			});	
		}		
	}
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer
//Date Modified                       :  15-01-2015
//Author                              :  Mandeep, Modified by Ankit for RAO
//Description                		  :  This function get the code of the given value

//***********************************************************************************//				
function getCode(Val){
	var data ="";
	var code ="";
	var desc=document.getElementById("autocompleteValues");
	//alert("desc"+desc);
	if(desc)
	{
		data=desc.value;
	}
	if(data!=null && data!="" && data!='{}') {
		data = data.replace('{','').replace('}','');
		var arrACTFields = data.split("=")[1].split(";");
		var arrACTCodes = document.getElementById("codeValues").value.replace('{','').replace('}','').split("=")[1].split(";");
		for(var i=0 ; i< arrACTFields.length ; i++)	{	
			if(Val==arrACTFields[i]){
				code=arrACTCodes[i];
				break;
			}
		}
	}
	return code;				
}
//*************************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer
//Date Modified                       :  21-Jan-2015        
//Author                              :  Mandeep, Modified by Ankit for RAO
//Description                		  :  This function sets the fields needed at checkbox

//************************************************************************************************//		
function setDateTime(id) {
	
	var canRaiseMap = document.getElementById("canRaiseMap").value;
	var canClearMap = document.getElementById("canClearMap").value;
	
	//Converting canRaiseMap into JSON Object
	canRaiseMap = canRaiseMap.replaceAll('=','\":\"');				
	canRaiseMap = canRaiseMap.replaceAll(', ','\",\"');				
	canRaiseMap = canRaiseMap.replace('{','{\"');			
	canRaiseMap = canRaiseMap.replace('}','\"}');
	
	//Converting canClearMap into JSON Object
	canClearMap = canClearMap.replaceAll('=','\":\"');				
	canClearMap = canClearMap.replaceAll(', ','\",\"');				
	canClearMap = canClearMap.replace('{','{\"');			
	canClearMap = canClearMap.replace('}','\"}');

	//canRaiseMap = JSON.parse(canRaiseMap);
	//canClearMap = JSON.parse(canClearMap);
	
	var checkBoxId = id;
	var isChecked=document.getElementById(id).checked;
	
	
	id = id.split("Item_Checkbox_").join("");
	var blankRow=false;
	var currWS= wsname;
	
	var WSArr=document.getElementById("Item_PAU_"+id).innerHTML.split("<br>");
	var userName=document.getElementById("userName").value;
	
	//alert(canRaiseMap[id.toString()]);
	//alert(canClearMap[id.toString()]);
		
	//Check if row is blank or have value
	if(document.getElementById("Item_User_"+id).innerHTML=="&nbsp;")
	{
		
		blankRow=true;
	}	

	if (WSArr[0]!=currWS && isChecked)
	{
		
		if(!blankRow)
		{
			document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<br>"+document.getElementById("Item_PAU_"+id).innerHTML;
			document.getElementById("Item_User_"+id).innerHTML=userName+"<br>"+document.getElementById("Item_User_"+id).innerHTML;
			document.getElementById("Item_Dec_"+id).innerHTML="Raised"+"<br>"+document.getElementById("Item_Dec_"+id).innerHTML;		
			document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<br>"+document.getElementById("Item_DateTime_"+id).innerHTML;
		}else {				
			document.getElementById("Item_PAU_"+id).innerHTML = currWS;
			document.getElementById("Item_User_"+id).innerHTML = userName;
			document.getElementById("Item_Dec_"+id).innerHTML = "Raised";
			document.getElementById("Item_DateTime_"+id).innerHTML = getDateTime();
		}	
		
		
	}
	else if (WSArr[0]!=currWS && !isChecked) {
		if(!blankRow) {
			document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<br>"+document.getElementById("Item_PAU_"+id).innerHTML;
			document.getElementById("Item_User_"+id).innerHTML=userName+"<br>"+document.getElementById("Item_User_"+id).innerHTML;
			document.getElementById("Item_Dec_"+id).innerHTML="Approved"+"<br>"+document.getElementById("Item_Dec_"+id).innerHTML;		
			document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<br>"+document.getElementById("Item_DateTime_"+id).innerHTML;
		} else {
			document.getElementById("Item_PAU_"+id).innerHTML = currWS;
			document.getElementById("Item_User_"+id).innerHTML = userName;
			document.getElementById("Item_Dec_"+id).innerHTML = "Approved";
			document.getElementById("Item_DateTime_"+id).innerHTML = getDateTime();
		}
		
	}
	else if(WSArr[0]==currWS && !isChecked) {
		var exceptionsFromDB = document.getElementById('alreadyRaisedExceptions').value; 
		
		//var callbackcheck = document.getElementById('Item_Checkbox_005').checked;
		
		//alert('statusofid'+statusofid[0]);
		if (exceptionsFromDB.indexOf(id) != -1) {
			if(blankRow) {

				document.getElementById("Item_PAU_"+id).innerHTML = currWS;
				document.getElementById("Item_User_"+id).innerHTML = userName;
				document.getElementById("Item_Dec_"+id).innerHTML = "Approved";
				document.getElementById("Item_DateTime_"+id).innerHTML = getDateTime();
			}
			
			else
			{
				
				document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<br>"+document.getElementById("Item_PAU_"+id).innerHTML;
				document.getElementById("Item_User_"+id).innerHTML=userName+"<br>"+document.getElementById("Item_User_"+id).innerHTML;
				document.getElementById("Item_Dec_"+id).innerHTML="Approved"+"<br>"+document.getElementById("Item_Dec_"+id).innerHTML;		
				document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<br>"+document.getElementById("Item_DateTime_"+id).innerHTML;
			}
		}
		else {
			if(blankRow) {
				document.getElementById("Item_User_"+id).innerHTML="&nbsp;";
				document.getElementById("Item_PAU_"+id).innerHTML="&nbsp;";
				document.getElementById("Item_Dec_"+id).innerHTML="&nbsp;";
				document.getElementById("Item_DateTime_"+id).innerHTML="&nbsp;";
			}
			else {
				var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<br>");
				var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<br>");
				var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<br>");
				
				UserArr.splice(0,1);
				WSArr.splice(0,1);
				DecArr.splice(0,1);
				DTArr.splice(0,1);							
				
				document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<br>");
				document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<br>");
				document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<br>");
				document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<br>");
			}
		}
	}
	else
	{
		if(document.getElementById('Item_Checkbox_005').checked && id=='005')
		{
			var decision = document.getElementById("Item_Dec_"+id).innerHTML;
			decision = decision.substring(0,decision.indexOf("<br>"));
			var exceptionsFromDB = document.getElementById('alreadyRaisedExceptions').value; 
			if(exceptionsFromDB.indexOf("005~[Raised") != -1)
			{
				var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<br>");
				var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<br>");
				var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<br>");
				
				UserArr.splice(0,1);
				WSArr.splice(0,1);
				DecArr.splice(0,1);
				DTArr.splice(0,1);							
				
				document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<br>");
				document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<br>");
				document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<br>");
				document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<br>");
			}
			else if(decision == 'Approved')
			{
				
				document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<br>"+document.getElementById("Item_PAU_"+id).innerHTML;
				document.getElementById("Item_User_"+id).innerHTML=userName+"<br>"+document.getElementById("Item_User_"+id).innerHTML;
				document.getElementById("Item_Dec_"+id).innerHTML="Raised"+"<br>"+document.getElementById("Item_Dec_"+id).innerHTML;		
				document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<br>"+document.getElementById("Item_DateTime_"+id).innerHTML;
			
			
			}
		}
		else
		{ 
		
		
			var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<br>");
			var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<br>");
			var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<br>");
		
			UserArr.splice(0,1);
			WSArr.splice(0,1);
			DecArr.splice(0,1);
			DTArr.splice(0,1);
			
			document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<br>");
			document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<br>");
			document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<br>");
			document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<br>");
		}
	}
}
			
//*************************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer
//Date Modified                       :  03-Feb-2015
//Author                              :  Mandeep, Modified by Ankit for RAO
//Description                		  :  This function replace all the replacement from the search string

//************************************************************************************************//	
String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
			
</script>           
</body>             

</html>