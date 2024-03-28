<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Form Painitng
//File Name					 : Exception_Checklist.jsp            
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : Exception Checklist Screen
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
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>
<%!
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
	
	public String getRow(String itemCode,String raisedExceptions,String relatedWorkstep,String approvalUnit,String WSNAME,String item,HashMap<String,String> canRaiseMap,HashMap<String,String> canClearMap)
	{
		
		String row="";
		String excepVal="";
		
		int indexOfHash=raisedExceptions.indexOf("#",raisedExceptions.indexOf(itemCode+"~"));

		if(indexOfHash<0)
			excepVal=raisedExceptions.substring(raisedExceptions.indexOf(itemCode+"~")+(itemCode+"~").length());			
		else	
			excepVal=raisedExceptions.substring(raisedExceptions.indexOf(itemCode+"~")+(itemCode+"~").length(),indexOfHash);
			
		
		WSNAME = WSNAME.toUpperCase();

		
		if(WSNAME.equalsIgnoreCase("TREASURY") || WSNAME.equalsIgnoreCase("REMITTANCEHELPDESK_CHECKER") || WSNAME.equalsIgnoreCase("REMITTANCEHELPDESK_MAKER") || WSNAME.equalsIgnoreCase("OPS_DATAENTRY") ||WSNAME.equalsIgnoreCase("OPS_INITIATE") || WSNAME.equalsIgnoreCase("CALLBACK") || WSNAME.equalsIgnoreCase("COMP_CHECK") ||  WSNAME.equalsIgnoreCase("OPS_MAKER") ||  WSNAME.equalsIgnoreCase("OPS_MAKER_DB") ||  WSNAME.equalsIgnoreCase("OPS_CHECKER") ||  WSNAME.equalsIgnoreCase("OPS_CHECKER_DB") ||  WSNAME.equalsIgnoreCase("CSO_EXCEPTIONS") || WSNAME.equalsIgnoreCase("QUERY1") || WSNAME.equalsIgnoreCase("EXIT") || WSNAME.equalsIgnoreCase("DISTRIBUTE") || WSNAME.equalsIgnoreCase("COLLECT1") || WSNAME.equalsIgnoreCase("ARCHIVE") || WSNAME.equalsIgnoreCase("ARCHIVE_DISCARD") || WSNAME.equalsIgnoreCase("ARCHIVE_EXIT") || WSNAME.equalsIgnoreCase("DISCARD1") || WSNAME.equalsIgnoreCase("DISTRIBUTE1")|| WSNAME.equalsIgnoreCase("ERROR"))
		{
			
			if(excepVal.indexOf("[Raised")==0)
			{
				if (canClearMap.get(itemCode).equals("Y"))
				{
					
					row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onchange='setDateTime(this.id);' value='true' checked/>&nbsp;&nbsp;&nbsp;</td>";
					
					row+=getExceptionHistory(itemCode,item,excepVal);
				}
				else
				{
					
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
		
		//WriteLog("row: "+row);
		return row;
    }
	
	public String getExceptionHistory(String itemCode,String item,String exceptionDetails){
	
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
				histDec+="<BR>"+strTemp[0];
			
			//History User
			if(histUser.equals(""))	
				histUser=strTemp[1]; 
			else 
				histUser+="<BR>"+strTemp[1];

			//History PAU
			if(histPAU.equals(""))	
				histPAU=strTemp[2]; 
			else
				histPAU+="<BR>"+strTemp[2];
			
			//History DateTime
			if(histDateTime.equals(""))	
				histDateTime=strTemp[3]; 
			else 
				histDateTime+="<BR>"+strTemp[3];
				
			exceptionDetails=exceptionDetails.substring(exceptionDetails.indexOf("]")+1);
		}
		
		html+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>"+histPAU+"</td>";
		html+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>"+histUser+"</td>";
		html+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>"+histDec+"</td>";		
		html+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'>"+histDateTime+"</td></tr>";

		//WriteLog("html: "+html);
		return html;
	}
	String alreadyRaisedExceptions = "";

	public String loadExceptions (String WINAME,String WSNAME,String segment,String H_CHECKLIST,String sessionId,String cabName,String ipAddr,int port,HashMap<String,String> canRaiseMap,HashMap<String,String> canClearMap,String ibmbCase,String userName)
	{
		StringBuilder wsnames = new StringBuilder();
		StringBuilder userNames = new StringBuilder();
		StringBuilder decisions = new StringBuilder();
		StringBuilder actionDateTime = new StringBuilder();		
		String raisedExceptions="";
		
		//map to contain all the raised from the DB
		HashMap<String,ArrayList<String>> raisedMap = new HashMap<String,ArrayList<String>>();
		
		try{
		//Added by Shamily Approve the AutoRaised callback exception at RemittanceHelpDesk_Checker WS
		if(WSNAME.equals("RemittanceHelpDesk_Checker"))
			{
				String inputXML1count = "";
				String outputXML1count="";
				String mainCodeValue1count="";
				XMLParser xmlParserData1count=null;
				XMLParser objXmlParser1count=null;
				String subXML1count ="";
			 
			String Query1count = "SELECT count(winame) as 'Count' FROM usr_0_tt_exception_history WHERE winame='"+WINAME+"'AND decision = 'Approved' AND wsname = 'RemittanceHelpDesk_Checker' AND excpcode = '005'";
		
			inputXML1count = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query1count + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";			
			WriteLog("inputXML1count getting count of approved "+inputXML1count); 
			//outputXML1count = WFCallBroker.execute(inputXML1count, ipAddr, port, 1);
			outputXML1count = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML1count);
			
			WriteLog("outputXML1count getting count of approved-- "+outputXML1count); 
			xmlParserData1count=new XMLParser();
			xmlParserData1count.setInputXML((outputXML1count));
			mainCodeValue1count = xmlParserData1count.getValueOf("MainCode");
			int recordcount1count=0;
			recordcount1count=Integer.parseInt(xmlParserData1count.getValueOf("TotalRetrieved"));
			String Count="";
			
			if(recordcount1count > 0 && mainCodeValue1count.equals("0")) {
			subXML1count = xmlParserData1count.getNextValueOf("Record");
			WriteLog("subXML1count---"+subXML1count);
			objXmlParser1count = new XMLParser(subXML1count);
				Count=objXmlParser1count.getValueOf("count");
				
			}
			String inputXML1 = "";
			String outputXML1="";
			String mainCodeValue1="";
			XMLParser xmlParserData1=null;
			XMLParser objXmlParser1=null;
			String subXML1 ="";
			
			String Query1 = "select authorized_sign,call_back_req from ng_tt_ext_table where wi_name='"+WINAME+"'";
		
			inputXML1 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query1 + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";			
			//outputXML1 = WFCallBroker.execute(inputXML1, ipAddr, port, 1);
			WriteLog("inputXML1 getting count of authorized_sign,call_back_req "+inputXML1);
			outputXML1 = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML1);
			WriteLog("outputXML1 getting count of authorized_sign,call_back_req "+outputXML1);
			xmlParserData1=new XMLParser();
			xmlParserData1.setInputXML((outputXML1));
			mainCodeValue1 = xmlParserData1.getValueOf("MainCode");
			int recordcount1=0;
			recordcount1=Integer.parseInt(xmlParserData1.getValueOf("TotalRetrieved"));
			String authorized_sign="";
			String call_back_req="";
			if(recordcount1 > 0 && mainCodeValue1.equals("0")) {
			subXML1 = xmlParserData1.getNextValueOf("Record");
			objXmlParser1 = new XMLParser(subXML1);
				authorized_sign=objXmlParser1.getValueOf("authorized_sign");
				call_back_req=objXmlParser1.getValueOf("call_back_req");
			}	
				
			 if(call_back_req.equals("Yes") && authorized_sign.equals("Yes") && Count.equals("0")) //[Ankit: Added authorized_sign condition]
			 {	
				WriteLog("Inside if of callback auto approve condition");
				String inputXMLcallautoraise= "";
				String outputXMLcallautoraise="";
				String hist_table="usr_0_TT_exception_history";
			    String columns="WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME";
				
				String decision = "Approved";
				Date date = new java.util.Date();
				DateFormat dateFormat1 = new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss");	
				
				
				String values = "'" + WINAME +"','005','" + WSNAME+"','System','" + decision +"'" + ",'"  + dateFormat1.format(date) + "'";
				String Querycallautoraise = "winame='"+WINAME+"'and ExcpCode='005' and WSName = 'System' and decision = 'Raised'"; //[Ankit:]What is the use of this??
				inputXMLcallautoraise ="<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>" + hist_table + "</TableName>" +
							"<ColName>" + columns + "</ColName>" +
							"<Values>" + values + "</Values>" +
							"<EngineName>" + cabName + "</EngineName>" +
							"<SessionId>" + sessionId + "</SessionId>" +
							"</APInsert_Input>";
				
				//outputXMLcallautoraise = WFCallBroker.execute(inputXMLcallautoraise, ipAddr, port, 1);
				WriteLog("inputXMLcallautoraise: "+inputXMLcallautoraise);
				outputXMLcallautoraise = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXMLcallautoraise);
				WriteLog("outputXMLcallautoraise: "+outputXMLcallautoraise);
				
			}
			}
		
			String inputXML = "";
			String outputXML="";
			String mainCodeValue="";
			XMLParser xmlParserData=null;
			XMLParser objXmlParser=null;
			String subXML ="";
			String Query = "select ExcpCode,WSName,UserName,Decision,ActionDateTime from usr_0_tt_exception_history where winame='"+WINAME+"' order by ExcpCode asc, cast(convert(varchar(24),actiondatetime+':000',113) as datetime) desc";
		
			inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";			
			
			//outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
		
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			int recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

			if(recordcount > 0 && mainCodeValue.equals("0")) {
				String ExcpCode="";
				for(int k=0; k<recordcount; k++)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					
					if(ExcpCode.equals(""))
					{
						ExcpCode=objXmlParser.getValueOf("ExcpCode");
						raisedExceptions=ExcpCode+"~["+objXmlParser.getValueOf("Decision")+"-"+objXmlParser.getValueOf("UserName")+"-"+objXmlParser.getValueOf("WSName")+"-"+objXmlParser.getValueOf("ActionDateTime")+"]";				
					}
					else if(ExcpCode.equals(objXmlParser.getValueOf("ExcpCode")))
					{
						raisedExceptions+="["+objXmlParser.getValueOf("Decision")+"-"+objXmlParser.getValueOf("UserName")+"-"+objXmlParser.getValueOf("WSName")+"-"+objXmlParser.getValueOf("ActionDateTime")+"]";					   
					}
					else
					{
						ExcpCode=objXmlParser.getValueOf("ExcpCode");
						raisedExceptions+="#"+objXmlParser.getValueOf("ExcpCode")+"~["+objXmlParser.getValueOf("Decision")+"-"+objXmlParser.getValueOf("UserName")+"-"+objXmlParser.getValueOf("WSName")+"-"+objXmlParser.getValueOf("ActionDateTime")+"]";
					}
				}
			}
			
			//For checking which exceptions are raised for current workstep
			alreadyRaisedExceptions = raisedExceptions;
			
			//Merge the exceptions
			raisedExceptions=mergeException(raisedExceptions,H_CHECKLIST);
			

			String htmlraised="";
			String htmlunraised="";
			String Initiating_Unit_Column="";

			Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_Rak_Checklist_Master where IsActive='Y' AND wsname='"+WSNAME+"' AND canView= 'Y' and processname='TT' order by id Asc";
			
			
			if (("IB".equals(ibmbCase) || "MB".equals(ibmbCase) || "YAP".equals(ibmbCase) || "DIP".equals(ibmbCase)) && ("REMITTANCEHELPDESK_MAKER".equals(WSNAME.toUpperCase()) || "CSO_EXCEPTIONS".equals(WSNAME.toUpperCase())))
			{
				Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_Rak_Checklist_Master where IsActive='Y' AND wsname='RemittanceHelpDesk_Maker' AND canView= 'Y' and processname='TT'  order by id ASC";

			}
		
			if("QUERY1,EXIT,ERROR,DISTRIBUTE,COLLECT1,ARCHIVE,ARCHIVE_DISCARD,ARCHIVE_EXIT,DISCARD1,DISTRIBUTE1,".indexOf(WSNAME.toUpperCase()+",")>-1)
				Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_Rak_Checklist_Master where IsActive='Y' and wsname = 'CSO_Exceptions' and processname='TT' order by id Asc";
			
			
			inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";
				
			//outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
			
			
			
			if(segment.equalsIgnoreCase("PBN"))
				Initiating_Unit_Column="Routing_Unit_1_Branches";
			else
				Initiating_Unit_Column="Routing_Unit_1_WM_SME";
			
			

			if(mainCodeValue.equals("0"))
			{
				for(int k=0; k<recordcount; k++)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					String item=objXmlParser.getValueOf("Checklist_Item_Desc").replaceAll("\\[|\\]", "").replaceAll("vbcrlf","<BR>");/////
					String itemCode=objXmlParser.getValueOf("Checklist_Item_Code");
					String relatedWorkstep=objXmlParser.getValueOf(Initiating_Unit_Column);
					String approvalUnit=objXmlParser.getValueOf("Approving_Unit");					
					
					if(raisedExceptions.indexOf(itemCode+"~")>-1)
					{
						
						htmlraised+=getRow(itemCode,raisedExceptions,relatedWorkstep,approvalUnit,WSNAME,item,canRaiseMap,canClearMap);	
					}
					//Unraised not to be viewed
					else if("ARCHIVE,".indexOf(WSNAME.toUpperCase()+",")>-1)
					{
						
						htmlunraised="";
					}
					else if("CSO_BRANCH,TREASURY,OPS_DATAENTRY,OPS_INITIATE,REMITTANCEHELPDESK_CHECKER,REMITTANCEHELPDESK_MAKER,CALLBACK,COMP_CHECK,OPS_MAKER,OPS_MAKER_DB,CSO_EXCEPTIONS,OPS_CHECKER,OPS_CHECKER_DB,QUERY1,EXIT,ERROR,DISTRIBUTE,COLLECT1,ARCHIVE,ARCHIVE_DISCARD,ARCHIVE_EXIT,DISCARD1,DISTRIBUTE1,".indexOf(WSNAME.toUpperCase()+",")>-1)
					//Raise New
					{
						String canRaise = canRaiseMap.get(itemCode);
						String canClear = canClearMap.get(itemCode);
						
						if (canRaise.equals("Y"))
							htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onchange='setDateTime(this.id);' value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
						else
							htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' disabled value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
							
						
						htmlunraised+="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
						htmlunraised+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'><BR><BR></td></tr>";
					}
					else
					{
						
						htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' disabled  value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
						htmlunraised+="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
						htmlunraised+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'><BR><BR></td></tr>";
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
%>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepName"), 1000, true) );
			String workstepName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ibmbCase"), 1000, true) );
			String ibmbCase_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("H_CHECKLIST"), 10000, true) );
			String H_CHECKLIST_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			H_CHECKLIST_Esapi = H_CHECKLIST_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
			WriteLog("H_CHECKLIST_Esapi after handling: "+H_CHECKLIST_Esapi);
			
	HashMap<String, String> autocompleteMap = new HashMap<String, String>();
	HashMap<String, String> codeMap = new HashMap<String, String>();
	HashMap<String, String> rejectReasonsMap = new HashMap<String, String>();
	HashMap<String, String> canRaiseMap = new HashMap<String, String>();
	HashMap<String, String> canClearMap = new HashMap<String, String>();
	
	String userName = "";
	String wsname = workstepName_Esapi;
	String winame = wi_name_Esapi;
	//To handle too much unsaved data at one step
	String H_CHECKLIST = H_CHECKLIST_Esapi.replaceAll("ER","Raised").replaceAll("EU","Approved");
	String items="";
	String codes="";
	String ibmbCase = ibmbCase_Esapi;
	String sessionId = wDSession.getM_objUserInfo().getM_strSessionId();
	String cabName = wDSession.getM_objCabinetInfo().getM_strCabinetName();
	String ipAddr = wDSession.getM_objCabinetInfo().getM_strServerIP();
	int port = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
	
	rejectReasonsMap.put("excepChecklistAutoComplete","Checklist_Item_Code");	
	String query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit,canRaise,canClear from USR_0_Rak_Checklist_Master where IsActive='Y' and wsname = '"+wsname+"' and canView= 'Y' and processname='TT' order by id Asc";
	
	if("QUERY1,EXIT,ERROR,DISTRIBUTE,COLLECT1,ARCHIVE,ARCHIVE_DISCARD,ARCHIVE_EXIT,DISCARD1,DISTRIBUTE1,".indexOf(wsname.toUpperCase()+",")>-1)
		query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit,'N','N' from USR_0_Rak_Checklist_Master where IsActive='Y' and wsname = 'CSO_Exceptions' and processname='TT' order by id Asc";
	
	
	String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" +sessionId + "</SessionId></APSelectWithColumnNames_Input>";
		
	//String outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
	String outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
	
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputXML));
	String mainCodeValue = xmlParserData.getValueOf("MainCode");
	String subXML="";
	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	
	if(mainCodeValue.equals("0"))
	{
		for(int k=0; k<recordcount; k++)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			String item=objXmlParser.getValueOf("Checklist_Item_Desc").replaceAll("\\[|\\]", "").replaceAll("vbcrlf","<BR>");
			String itemCode=objXmlParser.getValueOf("Checklist_Item_Code");
			String canRaise = objXmlParser.getValueOf("canRaise");
			String canClear = objXmlParser.getValueOf("canClear");
			
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

<BR/>
<div width="100%" align="right" >
	<th width=90% align=right valign=center><img style="padding-right:20px;" src="\webdesktop\webtop\images\rak-logo.gif"></th>			
</div>
<div class="EWNormalGreenGeneral1"> 
	&nbsp;&nbsp;&nbsp;<b>Exceptions For  Approval: </b>&nbsp;
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
	userName = wfsession.getStrPersonalName()+" "+wfsession.getUserFamilyName();
	userName = userName.trim();
	out.println(loadExceptions(winame,wsname,"PBN",H_CHECKLIST,sessionId,cabName,ipAddr,port,canRaiseMap,canClearMap,ibmbCase,userName));
%>

<BR/>
</table>

			<%
				if("QUERY1,EXIT,ERROR,DISTRIBUTE,COLLECT1,ARCHIVE,ARCHIVE_DISCARD,ARCHIVE_EXIT,DISCARD1,DISTRIBUTE1,".indexOf(wsname.toUpperCase()+",")>-1)
				{
			%>
				<input type="button" width="30" action="" style="margin-left:370px;" value="Close" onclick="CancelClick(2)" class="EWButtonRB">
			<%			
				} else {
			%>
				<BR/>
				<input type="button" style="margin-left:350px;" width="30" action="" value="&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;" onclick="OKClick()" class="EWButtonRB">
				<input type="button" width="30" action="" value="Cancel" onclick="CancelClick(2)" class="EWButtonRB">
			<%
				}	
			%>

<input type="hidden" name='autocompleteValues' id='autocompleteValues' value='<%=autocompleteMap%>' >
<input type="hidden" name='codeValues' id='codeValues' value='<%=codeMap%>'>
<input type="hidden" name='canRaiseMap' id='canRaiseMap' value='<%=canRaiseMap%>'>
<input type="hidden" name='canClearMap' id='canClearMap' value='<%=canClearMap%>'>
<input type="hidden" id="userName" name="userName" value="<%=userName%>">
<input type="hidden" id="alreadyRaisedExceptions" name="alreadyRaisedExceptions" value="<%=alreadyRaisedExceptions%>">

<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/json2.js"></script>	
<script>
var wsname = '<%=wsname%>';
var OKCancelClicked=false;


//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer
//Date Modified                       :  15-Jan-2015
//Author                              :  Mandeep
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
//Project                             : Rakbank - Telegraphic Transfer       
//Date Modified                       : 28-Jan-2016         
//Author                              : Mandeep Singh
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
		
		// added by stutee.mishra for <br> or <BR> split
		var ItemDec=document.getElementById("Item_Dec_"+id).innerHTML;
		var splitVal="<br>";
		if((ItemDec.indexOf("<BR>"))>-1){
			splitVal="<BR>"
		}
		//alert("ItemDec:::"+ItemDec)
		
		//Point number 243-04052016
        if (document.getElementById("Item_Dec_"+id).innerHTML.split(splitVal)[0] == 'Raised') {
            //Populate descriptions of the raised exceptions
			if (raisedExcepDesc=="")
				raisedExcepDesc = raisedExcepDesc + document.getElementById("Item_Desc_"+id).innerHTML.split(splitVal)[0];
			else
				raisedExcepDesc = raisedExcepDesc + " AND " + document.getElementById("Item_Desc_"+id).innerHTML.split(splitVal)[0];
        }
		
		//if(document.getElementById("Item_PAU_"+id).innerHTML.split("<BR>")[0]!=wsname)
			//continue;

		var decision=document.getElementById("Item_Dec_"+id).innerHTML.split(splitVal)[0];
		
		if(exceptionsFromDB !="") {
			var alreadyRaisedExceptions = exceptionsFromDB.split("#");
			var tempExcep = id + "~["+decision+"-"+document.getElementById("Item_User_"+id).innerHTML.split(splitVal)[0]+"-"+document.getElementById("Item_PAU_"+id).innerHTML.split(splitVal)[0]+"-"+document.getElementById("Item_DateTime_"+id).innerHTML.split(splitVal)[0]+"]";
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
					raisedExcepDesc = raisedExcepDesc + document.getElementById("Item_Desc_"+id).innerHTML.split("<BR>")[0];
				else 
					raisedExcepDesc = raisedExcepDesc + " AND " + document.getElementById("Item_Desc_"+id).innerHTML.split("<BR>")[0];*/
			}
		}
		else {
			var tempExcep = id + "~["+decision+"-"+document.getElementById("Item_User_"+id).innerHTML.split(splitVal)[0]+"-"+document.getElementById("Item_PAU_"+id).innerHTML.split(splitVal)[0]+"-"+document.getElementById("Item_DateTime_"+id).innerHTML.split(splitVal)[0]+"]";

			if(returnValue=="")
				returnValue=  tempExcep;
			else
				returnValue+="#"+ tempExcep;
			
			//Populate descriptions of the raised exceptions
			/*if (raisedExcepDesc=="")
				raisedExcepDesc = raisedExcepDesc + document.getElementById("Item_Desc_"+id).innerHTML.split("<BR>")[0];
			else 
				raisedExcepDesc = raisedExcepDesc + " AND " + document.getElementById("Item_Desc_"+id).innerHTML.split("<BR>")[0];*/
		}
	}
	
	//Populate descriptions of the raised exceptions
	returnValue = returnValue + "@" + raisedExcepDesc;
	
	//returnValue = returnValue.replaceAll("<br>","<BR>").replaceAll("&lt;br&gt;","&lt;BR&gt;");
	
	window.returnValue = returnValue;
	//added by stutee
	if(!window.showModalDialog)
	   window.opener.setValue(returnValue);
	OKCancelClicked=true;
	//Addeded by Saquib on 30-08-2017 for loading documnet on ok button
	//window.dialogArguments.reloadDocument();
	//*****************************************************************
	
	window.close();
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 
//Group                               : Application Projects
//Project                             : Rakbank - Telegraphic Transfer       
//Date Modified                       : 28-Jan-2016         
//Author                              : Mandeep Singh
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

	//Addeded by Saquib on 30-08-2017 for loading documnet on ok button
	//window.dialogArguments.reloadDocument();
	//*****************************************************************
	window.close();
}
			
//********************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :   Application Projects
//Project                             :   Rakbank - Telegrahic Transfer        
//Date Modified                       :   15-Jan-2015       
//Author                              :   Mandeep
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
//Author                              :  Mandeep
//Description                		  :  This function get the code of the given value

//***********************************************************************************//				
function getCode(Val){	
	var data ="";
	var code ="";
	var desc=document.getElementById("autocompleteValues");
	if(desc)
		data=desc.value;
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
//Author                              :  Mandeep
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
	//alert("1");
	//Converting canClearMap into JSON Object
	canClearMap = canClearMap.replaceAll('=','\":\"');				
	canClearMap = canClearMap.replaceAll(', ','\",\"');				
	canClearMap = canClearMap.replace('{','{\"');			
	canClearMap = canClearMap.replace('}','\"}');
//alert("2");
	//canRaiseMap = JSON.parse(canRaiseMap);
	//canClearMap = JSON.parse(canClearMap);
	//alert("3");
	var checkBoxId = id;
	var isChecked=document.getElementById(id).checked;
	
	//alert("4");
	id = id.split("Item_Checkbox_").join("");
	var blankRow=false;
	var currWS= wsname;
	//alert("5");
	var WSArr=document.getElementById("Item_PAU_"+id).innerHTML.split("<BR>");
	var userName=document.getElementById("userName").value;
	//alert("2");
	////alert(canRaiseMap[id.toString()]);
	////alert(canClearMap[id.toString()]);
		
	//Check if row is blank or have value
	if(document.getElementById("Item_User_"+id).innerHTML=="&nbsp;")
	{
		
		blankRow=true;
	}	
//alert("3");
	if (WSArr[0]!=currWS && isChecked)
	{
		
		if(!blankRow)
		{
			document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
			document.getElementById("Item_User_"+id).innerHTML=userName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
			document.getElementById("Item_Dec_"+id).innerHTML="Raised"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;		
			document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
		}else {				
			document.getElementById("Item_PAU_"+id).innerHTML = currWS;
			document.getElementById("Item_User_"+id).innerHTML = userName;
			document.getElementById("Item_Dec_"+id).innerHTML = "Raised";
			document.getElementById("Item_DateTime_"+id).innerHTML = getDateTime();
			
		}	
		//alert("4");
		
	}
	else if (WSArr[0]!=currWS && !isChecked) {
		if(!blankRow) {
			document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
			document.getElementById("Item_User_"+id).innerHTML=userName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
			document.getElementById("Item_Dec_"+id).innerHTML="Approved"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;		
			document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
		} else {
			document.getElementById("Item_PAU_"+id).innerHTML = currWS;
			document.getElementById("Item_User_"+id).innerHTML = userName;
			document.getElementById("Item_Dec_"+id).innerHTML = "Approved";
			document.getElementById("Item_DateTime_"+id).innerHTML = getDateTime();
		}
		////alert("5");
		
	}
	else if(WSArr[0]==currWS && !isChecked) {
		var exceptionsFromDB = document.getElementById('alreadyRaisedExceptions').value; 
		
		var callbackcheck = document.getElementById('Item_Checkbox_005').checked;

		if (exceptionsFromDB.indexOf(id) != -1) {
			if(blankRow) {

				document.getElementById("Item_PAU_"+id).innerHTML = currWS;
				document.getElementById("Item_User_"+id).innerHTML = userName;
				document.getElementById("Item_Dec_"+id).innerHTML = "Approved";
				document.getElementById("Item_DateTime_"+id).innerHTML = getDateTime();
			}
			
			else if (!callbackcheck && id=='005')
			{
			
			
			var decision1 = document.getElementById("Item_Dec_"+id).innerHTML;
			decision1 = decision1.substring(0,decision1.indexOf("<BR>"));
			
			if(exceptionsFromDB.indexOf("005~[Raised") != -1)
			{
				document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
				document.getElementById("Item_User_"+id).innerHTML=userName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
				document.getElementById("Item_Dec_"+id).innerHTML="Approved"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;		
				document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
			}
			
			else if(decision1 == 'Raised')
			{
			
				var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<BR>");
				var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<BR>");
				var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>");
		
				UserArr.splice(0,1);
				WSArr.splice(0,1);
				DecArr.splice(0,1);
				DTArr.splice(0,1);
			
				document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<BR>");
				document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<BR>");
				document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<BR>");
				document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<BR>");
				}
			}
			else
			{
				
				document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
				document.getElementById("Item_User_"+id).innerHTML=userName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
				document.getElementById("Item_Dec_"+id).innerHTML="Approved"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;		
				document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
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
				var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<BR>");
				var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<BR>");
				var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>");
				
				UserArr.splice(0,1);
				WSArr.splice(0,1);
				DecArr.splice(0,1);
				DTArr.splice(0,1);							
				
				document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<BR>");
				document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<BR>");
				document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<BR>");
				document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<BR>");
			}
		}
		//alert("6");
	}
	else
	{
		
		
		
		
		
		if(document.getElementById('Item_Checkbox_005').checked && id=='005')
		{
			var decision = document.getElementById("Item_Dec_"+id).innerHTML;
			decision = decision.substring(0,decision.indexOf("<BR>"));
			
			var exceptionsFromDB = document.getElementById('alreadyRaisedExceptions').value; 
			if(exceptionsFromDB.indexOf("005~[Raised") != -1)
			{
				var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<BR>");
				var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<BR>");
				var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>");
				
				UserArr.splice(0,1);
				WSArr.splice(0,1);
				DecArr.splice(0,1);
				DTArr.splice(0,1);							
				
				document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<BR>");
				document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<BR>");
				document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<BR>");
				document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<BR>");
			}
			else if(decision == 'Approved')
			{
				
				document.getElementById("Item_PAU_"+id).innerHTML = currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
				document.getElementById("Item_User_"+id).innerHTML=userName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
				document.getElementById("Item_Dec_"+id).innerHTML="Raised"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;		
				document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
			
			
			}
		}
		else
		{ 
		
		
			var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<BR>");
			var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<BR>");
			var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>");
		
			UserArr.splice(0,1);
			WSArr.splice(0,1);
			DecArr.splice(0,1);
			DTArr.splice(0,1);
			
			document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<BR>");
			document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<BR>");
			document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<BR>");
			document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<BR>");
		}
		//alert("7");
	}
}
			
//*************************************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer
//Date Modified                       :  03-Feb-2015
//Author                              :  Mandeep
//Description                		  :  This function replace all the replacement from the search string

//************************************************************************************************//	
String.prototype.replaceAll = function(search, replacement) {
    var target = this;
    return target.replace(new RegExp(search, 'g'), replacement);
};
			
</script>           
</body>             

</html>