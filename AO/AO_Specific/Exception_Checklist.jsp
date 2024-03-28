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
static int i = 1;

	

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
				raisedExcps=raisedExcps.substring(0, raisedExcps.indexOf(codeArr[0]+"~"))+updatedExcps[i]+raisedExcps.substring(raisedExcps.indexOf(codeArr[0]+"~")+(codeArr[0]+"~").length());
			}
			else
			{
				raisedExcps+="#"+updatedExcps[i];
			}
		}
		
		return raisedExcps;
    }
	public String getRow(String itemCode,String raisedExceptions,String relatedWorkstep,String approvalUnit,String WSNAME,String item, String branchType){
		String row="";
		
		String excepVal="";
		
		int indexOfHash=raisedExceptions.indexOf("#",raisedExceptions.indexOf(itemCode+"~"));
		if(indexOfHash<0)
			excepVal=raisedExceptions.substring(raisedExceptions.indexOf(itemCode+"~")+(itemCode+"~").length());
			
		else	
			excepVal=raisedExceptions.substring(raisedExceptions.indexOf(itemCode+"~")+(itemCode+"~").length(),indexOfHash);

		   
		
		
		WSNAME=WSNAME.toUpperCase();
		if(WSNAME.equalsIgnoreCase("AML_COMPLIANCE") && approvalUnit.equalsIgnoreCase(WSNAME))
		{	    
			row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='return false' value='true' checked/>&nbsp;&nbsp;&nbsp;</td>";
			row+=getExceptionHistory(itemCode,item,excepVal);
		}
		else if((WSNAME.equalsIgnoreCase("PB_Credit") && relatedWorkstep.equalsIgnoreCase(WSNAME)) || (WSNAME.equalsIgnoreCase("Branch_Controls") && relatedWorkstep.indexOf(WSNAME)>-1) || (WSNAME.equalsIgnoreCase("WM_Controls") && relatedWorkstep.indexOf(WSNAME)>-1) || (WSNAME.equalsIgnoreCase("SME_Controls") && relatedWorkstep.indexOf(WSNAME)>-1) || (WSNAME.equalsIgnoreCase("Branch_Controls")  && branchType.equalsIgnoreCase("North") && relatedWorkstep.indexOf("CONTROLS")>-1))
		{

			String checked="";
			if(excepVal.indexOf("[Raised")==0)
			{	

				checked="checked";
				row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='return false' value='true' "+checked+"/>&nbsp;&nbsp;&nbsp;</td>";
			row+=getExceptionHistory(itemCode,item,excepVal);					
			}

			else if(excepVal.indexOf("[Rejected")==0)
			{





				checked="checked";
				row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='return false' value='true' "+checked+"/>&nbsp;&nbsp;&nbsp;</td>";
				row+=getExceptionHistory(itemCode,item,excepVal);	
				
			}
		}
		else if("CSO,CSM,OPS_CHECKER,OPS_MAKER,CSO_REJECTS,CB-WC MAKER,CB-WC CHECKER,CONTROLS,".indexOf(WSNAME.toUpperCase()+",")>-1)
		{
			String checked="";
			if(excepVal.indexOf("[Raised")==0)
				checked="checked";
			//row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='setDateTime(this.id);' value='true' "+checked+"/>&nbsp;&nbsp;&nbsp;</td>";
			row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='return false' value='true' "+checked+"/>&nbsp;&nbsp;&nbsp;</td>";
			
			row+=getExceptionHistory(itemCode,item,excepVal);
		}
		else if(WSNAME.equalsIgnoreCase("Error") || WSNAME.equalsIgnoreCase("Archival Team"))
		{
			row+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='return false' value='true' />&nbsp;&nbsp;&nbsp;</td>";
			row+=getExceptionHistory(itemCode,item,excepVal);
		}	
		
		return row;
    }
	public String loadExceptions(String WINAME,String WSNAME,String segment,String H_CHECKLIST,String sessionId,String cabName,String ipAddr,int port){
		try{
		    
			String Query="";
			String params="";
			String inputXML="";
			String outputXML="";
			String mainCodeValue="";
			XMLParser xmlParserData=null;
			XMLParser objXmlParser=null;
			String subXML="";	
			String userid="";	
			String username="";	
			String raisedExceptions="";
							
			//Query="select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_AO_Exception_History with(nolock) where winame='"+WINAME+"'  order by ExcpCode asc,cast(convert(varchar(24),actiondatetime+':000',113) as datetime) desc";
			//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";
			
			params="WINAME=="+WINAME;
			Query="select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_AO_Exception_History with(nolock) where winame=:WINAME  order by ExcpCode asc, cast(convert(varchar(24),actiondatetime+':000',113) as datetime) desc";
			inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "AO_debug", "test-inputXML"+ inputXML);
			
			//outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			//outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "AO_debug", "test-outputXML"+ outputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			int recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
			
			if(mainCodeValue.equals("0"))
			{
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
			
			//code to get NorthSouth Branch
			//Query="select northsouthbranch from RB_AO_EXTTABLE with(nolock) where WI_NAME='"+WINAME+"'";
			//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";				
			
			params="WINAME=="+WINAME;
			Query="select northsouthbranch from RB_AO_EXTTABLE with(nolock) where WI_NAME=:WINAME";
			inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "test-inputXML"+ inputXML);
			
			
			//outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			//outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "test-outputXML"+ outputXML);

			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputXML);
			String northSouthBranch = xmlParserData.getValueOf("northsouthbranch");
			//code ends
			
			
			raisedExceptions=mergeException(raisedExceptions,H_CHECKLIST);
			
			//Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive='Y' order by id Asc";
			///////
			//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";
			
			params="IsActive==Y";
			Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive=:IsActive order by id Asc";
			inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "test-inputXML"+ inputXML);

				
			//outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			//outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "test-outputXML"+ outputXML);

			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
			String htmlraised="";
			String htmlunraised="";
			String Initiating_Unit_Column="";
			
			/* Mapping of Segment and Controls
			Channel			Segment				Routing to Controls Team
			Branch			PBN					Branch Controls Team/WM controls  (depending on the exception type)
			SME				PSL/SME				SME Controls Team
			WM				PAM/PRS				WM Controls Team	
			*/
			
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
						
						htmlraised+=getRow(itemCode,raisedExceptions,relatedWorkstep,approvalUnit,WSNAME,item,northSouthBranch);	
					}
					else if("AML_COMPLIANCE,COMPLIANCE,COMPLIANCE_MANAGER,WM_CONTROLS,BRANCH_CONTROLS,SME_CONTROLS,PB_CREDIT,REJECT,ERROR,AUTO,QUERY1,EXIT,DISTRIBUTE,COLLECT,DISTRIBUTE_ARCHIVAL,COLLECT_ARCHIVAL,ARCHIVE,ARCHIVAL TEAM,CSO,CSM,OPS_CHECKER,OPS_MAKER,CSO_REJECTS,CB-WC MAKER,CB-WC CHECKER,".indexOf(WSNAME.toUpperCase()+",")>-1) //Unraised not to be viewed
					{
						
						htmlunraised="";
					}
					/*else if("CSO,CSM,OPS_CHECKER,OPS_MAKER,CSO_REJECTS,CB-WC MAKER,CB-WC CHECKER,".indexOf(WSNAME.toUpperCase()+",")>-1) //Raise New
					{
						htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='setDateTime(this.id);' value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
						htmlunraised+="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
						htmlunraised+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'><BR><BR></td></tr>";
									
					}*/
					else
					{
						htmlunraised+="<tr><td width='25' style='text-align:center'><input type='checkbox' id='Item_Checkbox_"+itemCode+"' onclick='return false' value='true' unchecked/>&nbsp;&nbsp;&nbsp;</td>";
						htmlunraised+="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
						htmlunraised+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>&nbsp;</td>";
						htmlunraised+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'><BR><BR></td></tr>";
					}					
				}
				
				
				return(htmlraised+htmlunraised);
				
			}
			else
			{
				return("Some error at server end. Please contact Administrator.");
			}
		
		}catch(Exception e)	
		{
			return("Some error at server end. Please contact Administrator.");
		}
	}
	public String getExceptionHistory(String itemCode,String item,String exceptionDetails){
		String html="<td id='Item_Desc_"+itemCode+"' width='340' class='EWNormalGreenGeneral1'>"+item+"</td>";
		String histPAU="";
		String histUser="";
		String histDec="";
		String histDateTime="";
		while(exceptionDetails.indexOf("[")>-1)
		{
			String strTemp[]=exceptionDetails.replace("CB-WC","CB_WC").substring(1,exceptionDetails.indexOf("]")).split("-");
			if(histDec.equals(""))	
			{					
					histDec=strTemp[0]; 						
			}else {		
					histDec+="<BR>"+strTemp[0]; 
					
			}	
			if(histUser.equals(""))	histUser=strTemp[1]; else histUser+="<BR>"+strTemp[1];
			if(histPAU.equals(""))	histPAU=strTemp[2].replace("CB_WC","CB-WC"); else histPAU+="<BR>"+strTemp[2].replace("CB_WC","CB-WC");
			if(histDateTime.equals(""))	histDateTime=strTemp[3]; else histDateTime+="<BR>"+strTemp[3];
			
			exceptionDetails=exceptionDetails.substring(exceptionDetails.indexOf("]")+1);
		}	
		html+="<td id='Item_PAU_"+itemCode+"' width='100' class='EWNormalGreenGeneral1'>"+histPAU+"</td>";
		html+="<td id='Item_User_"+itemCode+"' width='90' class='EWNormalGreenGeneral1'>"+histUser+"</td>";
		html+="<td id='Item_Dec_"+itemCode+"' width='125' class='EWNormalGreenGeneral1'>"+histDec+"</td>";		
		html+="<td id='Item_DateTime_"+itemCode+"' width='140' class='EWNormalGreenGeneral1'>"+histDateTime+"</td></tr>";
		return html;
	}
%>
<%!
   Map<String,String> RejectReasonsMap = new HashMap<String, String>();
   HashMap<String, String> AutocompleteMap = new HashMap<String, String>();
   HashMap<String, String> CodeMap = new HashMap<String, String>();
%>

<html>
	<head>
	
	<%
	
	String items="";
	String codes="";
	RejectReasonsMap.put("ExceptionChecklist","Checklist_Item_Code");	
	//String Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive='Y' order by id Asc";
	
	//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	
	String Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive=:IsActive order by id Asc";
	String params="IsActive==Y";
	
	//String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	
	
	String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" +wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId()+ "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "test-inputXML"+ inputXML);
		
	//String outputXML = WFCallBroker.execute(inputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
	com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "test-outputXML"+ outputXML);
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
			String item=objXmlParser.getValueOf("Checklist_Item_Desc").replaceAll("\\[|\\]", "").replaceAll("vbcrlf","<BR>");/////
			String itemCode=objXmlParser.getValueOf("Checklist_Item_Code");

			if(codes==null||codes.equals(""))
			{
				codes=itemCode;
				items=item;//.replaceAll("<BR>","");
			}	
			else
			{
				codes+=";"+itemCode;
				items+=";"+item;//.replaceAll("<BR>","");
			}
		}
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
	}	
	
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME_Esapi: "+WINAME_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: PANnoEsapi: "+WSNAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("segment"), 1000, true) );
			String segment_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: segment_Esapi: "+segment_Esapi);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("H_CHECKLIST"), 1000, true) );
			String H_CHECKLIST_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: H_CHECKLIST_Esapi: "+H_CHECKLIST_Esapi);
	
	String WINAME=WINAME_Esapi;
	String WSNAME=WSNAME_Esapi;
	String segment=segment_Esapi;
	String H_CHECKLIST=H_CHECKLIST_Esapi.replaceAll("ER","Raised").replaceAll("EU","Unraised");//To handle too much unsaved data at one step
	String LoggedInUserPersonalName="";
	%>
		<title>Exceptions  for Approval - <%=WINAME%></title>
		<style>
			@import url("\webdesktop\webtop\en_us\css\docstyle.css");
			
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
		</style>
		<script>
		    document.write("<link type='text/css' rel='stylesheet' href='/webdesktop/webtop/en_us/css/jquery.autocomplete.css'>");
			var OKCancelClicked=false;
			var WorkstepName=window.dialogArguments.WSNAME;
			function OKClick(){
				var inputs = document.getElementsByTagName("input");
				var id="";
				var returnValue="";
				for (x=0;x<inputs.length;x++)
				{	
					if(inputs[x].id.indexOf("Item_Checkbox_")<0)
						continue;
						
					id = inputs[x].id.replace("Item_Checkbox_","");
					
					if(document.getElementById("Item_Dec_"+id).innerHTML==""||document.getElementById("Item_Dec_"+id).innerHTML=="&nbsp;")
						continue;
					
					if(document.getElementById("Item_PAU_"+id).innerHTML.split("<BR>")[0]!=window.dialogArguments.WSNAME)
						continue;
						
					var decision=document.getElementById("Item_Dec_"+id).innerHTML.split("<BR>")[0];					
					
					if(returnValue=="")
						returnValue= id+"~["+decision+"-"+document.getElementById("Item_User_"+id).innerHTML.split("<BR>")[0]+"-"+document.getElementById("Item_PAU_"+id).innerHTML.split("<BR>")[0]+"-"+document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>")[0]+"]";
					else
						returnValue+="#"+id+"~["+decision+"-"+document.getElementById("Item_User_"+id).innerHTML.split("<BR>")[0]+"-"+document.getElementById("Item_PAU_"+id).innerHTML.split("<BR>")[0]+"-"+document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>")[0]+"]";
				}
				
				window.returnValue = encodeURIComponent(returnValue);
				OKCancelClicked=true;
				window.close();
			}
			function CancelClick(opt){
				
				if(opt==2)
				{
					window.returnValue = "NO_CHANGE";
					OKCancelClicked=true;
				}	
				else if(!OKCancelClicked)
					window.returnValue = "NO_CHANGE";
					
				window.close();				
			}
			function setAutocompleteData() {
				var data ="";
				var ele=document.getElementById("AutocompleteValues");
			
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
									if(tar!=null && tar!=""){
										var code=getCode(tar);
										if(WorkstepName=='CSM' || WorkstepName=='CSO_Rejects' || WorkstepName=='OPS_Maker' || WorkstepName=='OPS_Checker' || WorkstepName=='CB-WC Maker' || WorkstepName=='CB-WC Checker')
										{
											if(!document.getElementById("Item_Checkbox_"+code).checked)
											{		
												document.getElementById("Item_Checkbox_"+code).click();
											}	
										}
										if(document.getElementById("Item_Checkbox_"+code)!= null)
										{
											document.getElementById("Item_Checkbox_"+code).focus();
										}
										document.getElementById('ExceptionChecklist').value='';
									}									
								}
							});				
						});	
					}		
				}
			}
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
		</script>
	</head>
	<body class="EWGeneralRB" bgcolor="#FFFBF0" onload="setAutocompleteData();" onUnload="CancelClick(1);">
		<script>
			function setDateTime(id) {
				var isChecked=document.getElementById(id).checked;
				id=id.split("Item_Checkbox_").join("");
				var currWS=window.dialogArguments.WSNAME;
				var WSArr=document.getElementById("Item_PAU_"+id).innerHTML.split("<BR>");
				var loginUserPersonalName=document.getElementById("PersonalName").value;
				var blankRow=false;
				if(document.getElementById("Item_User_"+id).innerHTML=="&nbsp;")
					blankRow=true;
				
				if(WSArr[0]!=window.dialogArguments.WSNAME && isChecked)
				{
					//Different Workstep checked
					if(!blankRow)
					{	
						//alert('a');
						document.getElementById("Item_User_"+id).innerHTML=loginUserPersonalName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
						document.getElementById("Item_PAU_"+id).innerHTML=currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
						document.getElementById("Item_Dec_"+id).innerHTML="Raised"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;
						document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
					}
					else 
					{
						//alert('b');
						document.getElementById("Item_User_"+id).innerHTML=loginUserPersonalName;
						document.getElementById("Item_PAU_"+id).innerHTML=currWS;
						document.getElementById("Item_Dec_"+id).innerHTML="Raised";
						document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime();									
					}
				}
				else if(WSArr[0]!=window.dialogArguments.WSNAME && !isChecked)
				{
					//Different Workstep Unchecked
					if(!blankRow)
					{
						//alert('c');
						document.getElementById("Item_User_"+id).innerHTML=loginUserPersonalName+"<BR>"+document.getElementById("Item_User_"+id).innerHTML;
						document.getElementById("Item_PAU_"+id).innerHTML=currWS+"<BR>"+document.getElementById("Item_PAU_"+id).innerHTML;
						document.getElementById("Item_Dec_"+id).innerHTML="Unraised"+"<BR>"+document.getElementById("Item_Dec_"+id).innerHTML;
					
						document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime()+"<BR>"+document.getElementById("Item_DateTime_"+id).innerHTML;
					}else {
						//alert('d');
						document.getElementById("Item_User_"+id).innerHTML=loginUserPersonalName;
						document.getElementById("Item_PAU_"+id).innerHTML=currWS;
						document.getElementById("Item_Dec_"+id).innerHTML="Unraised";
						document.getElementById("Item_DateTime_"+id).innerHTML=getDateTime();									
					}
				}
				else if(WSArr[0]=window.dialogArguments.WSNAME && !isChecked)
				{
					//same workstep unchecked -overwrite
					/*for(var j=0;j<WSArr.length;j++) 				
						alert(WSArr[j]);*/
					if(WSArr.length==1)
					{
						//alert('e');
						document.getElementById("Item_User_"+id).innerHTML="&nbsp;";
						document.getElementById("Item_PAU_"+id).innerHTML="&nbsp;";
						document.getElementById("Item_Dec_"+id).innerHTML="&nbsp;";
						document.getElementById("Item_DateTime_"+id).innerHTML="&nbsp;";
					}
					else
					{
						var UserArr=document.getElementById("Item_User_"+id).innerHTML.split("<BR>");
						var DecArr=document.getElementById("Item_Dec_"+id).innerHTML.split("<BR>");
						var DTArr=document.getElementById("Item_DateTime_"+id).innerHTML.split("<BR>");
						
						//UserArr[0]=loginUserPersonalName;
						//WSArr[0]=currWS;
						//DecArr[0]="Unraised";
						//DTArr[0]=getDateTime();
						
						UserArr.splice(0,1);
						WSArr.splice(0,1);
						DecArr.splice(0,1);
						DTArr.splice(0,1);
						
						
						document.getElementById("Item_User_"+id).innerHTML=UserArr.join("<BR>");
						document.getElementById("Item_PAU_"+id).innerHTML=WSArr.join("<BR>");
						document.getElementById("Item_Dec_"+id).innerHTML=DecArr.join("<BR>");
						document.getElementById("Item_DateTime_"+id).innerHTML=DTArr.join("<BR>");
						//alert('f');
					}
				}
				else
				{
					//Same Workstep checked-overwrite
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
					//alert('g');
				}	
			}		
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
		</script>
		<BR>
		<div>
		<div width="100%" align="right">
			<th width=100% align=right valign=center><img src="\webdesktop\webtop\images\rak-logo.gif"></th>			
		</div>
		<div class="EWNormalGreenGeneral1"> 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Exceptions For  Approval: </b>&nbsp;	 
			<input type='text' style="width:400;" data-toggle='tooltip' onmousemove='title=this.value' onmouseover='title=this.value' size = '32' name='ExceptionChecklist' id="ExceptionChecklist" value = '' ></td>
		</div>
		
		<BR>
		<div style="border:none;">
		<table width="850" border="0" cellpadding="3">
			<tr class='EWHeader' width=100% class='EWLabelRB2'>
			    <td width="29" class="EWLabelRB2"><b>Items</b></td>
				<td width="339" class="EWLabelRB2"><b>Exception</b></td>
				<td width="96" class="EWLabelRB2"><b>Workstep</b></td>
				<td width="92" class="EWLabelRB2"><b>User Name</b></td>
				<td width="123" class="EWLabelRB2"><b>Decision Taken</b></td>
				<td width="168" colspan=2 class="EWLabelRB2"><b>Date and Time</b></td>				
			</tr>
		</table>
		</div>		
		<div style="overflow: auto;width:845;height: 440px; border: 1px solid;">
		<div>
		<table width="820" border="2" cellpadding="3">
		

<%		
		
		LoggedInUserPersonalName=wfsession.getStrPersonalName()+" "+wfsession.getUserFamilyName();
		LoggedInUserPersonalName=LoggedInUserPersonalName.trim();	
		out.println(loadExceptions(WINAME,WSNAME,segment,H_CHECKLIST,wfsession.getSessionId(),wfsession.getEngineName(),wfsession.getJtsIp(),wfsession.getJtsPort()));
%>		
		
		</table>
		<input type=hidden name='AutocompleteValues' id='AutocompleteValues' value='<%=AutocompleteMap%>' style='visibility:hidden' >
		<input type=hidden name='CodeValues' id='CodeValues' value='<%=CodeMap%>' style='visibility:hidden' >
		</div>
		</div>
		</div>
		<div align="center"> 
			<BR>
			<%
			if("AML_COMPLIANCE,COMPLIANCE,COMPLIANCE_MANAGER,WM_CONTROLS,BRANCH_CONTROLS,SME_CONTROLS,PB_CREDIT,REJECT,ERROR,AUTO,QUERY1,EXIT,DISTRIBUTE,COLLECT,DISTRIBUTE_ARCHIVAL,COLLECT_ARCHIVAL,ARCHIVE,ARCHIVAL TEAM,CSO,CSM,OPS_CHECKER,OPS_MAKER,CSO_REJECTS,CB-WC MAKER,CB-WC CHECKER,CONTROLS,".indexOf(WSNAME.toUpperCase()+",")>-1){
			%>
			<input type="button" width="30" action="" value="Close" onclick="CancelClick(2)" class="EWButtonRB">
			<%
			i=1;
			}else{%>
			<input type="button" width="30" action="" value="&nbsp;&nbsp;&nbsp;&nbsp;OK&nbsp;&nbsp;&nbsp;&nbsp;" onclick="OKClick()" class="EWButtonRB">&nbsp;&nbsp;&nbsp;
			<input type="button" width="30" action="" value="Cancel" onclick="CancelClick(2)" class="EWButtonRB">
			<input type="hidden" id="PersonalName" name="PersonalName" value="<%=LoggedInUserPersonalName%>">
			<%}
			i=1;
			%>
		</div>		
	</body>
</html>