<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Data Update
//File Name					 : AO.jsp          
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : File to insert/update data in Transaction table
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
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

<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>



<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<!--<link rel="stylesheet" type="text/css" href = "\webdesktop\webtop\en_us\css\docstyle.css">-->
<%!

public String getAPSelectXML(String strEngineName, String strSessionId, String Query) 
	{
		return "<?xml version=\"1.0\"?>"
			+ "<APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option>"
			+ "<Query>" + Query + "</Query>"
			+ "<EngineName>" + strEngineName + "</EngineName>"
			+ "<SessionId>" + strSessionId + "</SessionId>"
			+ "</APSelectWithColumnNames_Input>";
    	}
	
public String getAPUpdateXML(String strEngineName, String strSessionId, String tableName, String columnName, String strValues, String sWhere) 
	{
		return "<?xml version=\"1.0\"?>"
			+ "<APUpdate_Input><Option>APUpdate</Option>"
			+ "<TableName>" + tableName + "</TableName>"
			+ "<ColName>" + columnName + "</ColName>"
			+ "<Values>" + strValues + "</Values>"
			+ "<WhereClause>" + sWhere + "</WhereClause>"
			+ "<EngineName>" + strEngineName + "</EngineName>"
			+ "<SessionId>" + strSessionId + "</SessionId>"
			+ "</APUpdate_Input>";

    }

public String getAPInsertXML(String strEngineName, String strSessionId, String tableName, String columns, String strValues) 
    {
		return "<?xml version=\"1.0\"?>" +
			"<APInsert_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>" + tableName + "</TableName>" +
			"<ColName>" + columns + "</ColName>" +
			"<Values>" + strValues + "</Values>" +
			"<EngineName>" + strEngineName + "</EngineName>" +
			"<SessionId>" + strSessionId + "</SessionId>" +
			"</APInsert_Input>";
	}
public String getAPSelectParamXML(String strEngineName, String strSessionId, String Query,String params) 
	{
		return "<?xml version=\"1.0\"?>"
			+ "<APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option>"
			+ "<Query>" + Query + "</Query>"
			+ "<EngineName>" + strEngineName + "</EngineName>"
			+ "<Params>" + params + "</Params>"
			+ "<SessionId>" + strSessionId + "</SessionId>"
			+ "</APSelectWithNamedParam_Input>";
    	}
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
	
public String getDistributeFlags( String WSNAME, String checklistData,String decision,String cabName,String sessionId,String ipAddr,int port,String WINAME,String segment) 
	{
		String strDistributeFlags="";
		try{
			XMLParser xmlParserData=null;
			XMLParser objXmlParser=null;
			String raisedExceptions="";
			String subXML="";	
			//String Query="select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_AO_Exception_History with(nolock) where winame='"+WINAME+"'  order by ExcpCode asc,convert(datetime,actiondatetime,103) desc";
			//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";

			String Query="select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_AO_Exception_History with(nolock) where winame=:WINAME  order by ExcpCode asc,convert(datetime,actiondatetime,103) desc";
			String params="WINAME=="+WINAME;
			String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
			//String outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			//String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			
			String outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			String mainCodeValue = xmlParserData.getValueOf("MainCode");
			int recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
			String strCreditItems="";
			String strWMCtrlItems="";
			String strSMECtrlItems="";
			String strBranchCtrlItems="";
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
						raisedExceptions+="#"+objXmlParser.getValueOf("ExcpCode")+"~["+objXmlParser.getValueOf("Decision")+"-"+objXmlParser.getValueOf("UserName")+"-"+objXmlParser.getValueOf("WSName")+"-"+objXmlParser.getValueOf("ActionDateTime")+"]";
					}
				}
			}
			raisedExceptions=mergeException(raisedExceptions,checklistData);
			
			//Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive='Y' order by id Asc";
			//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";

			Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive=:IsActive order by id Asc";
			params="IsActive==Y";
			inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
			//outputXML = WFCallBroker.execute(inputXML, ipAddr, port, 1);
			//outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			recordcount=0;
			String Initiating_Unit_Column="";
				
				/* Mapping of Segment and Controls
				Channel			Segment				Routing to Controls Team
				Branch			PBN					Branch Controls Team/WM controls  (depending on the exception type)
				SME				PSL/SME				SME Controls Team
				WM				PAM/PRS				WM Controls Team	
				*/
				
			if(segment.equalsIgnoreCase("PBN")||segment.equalsIgnoreCase("PRS"))//Added by amitabh on 11-16-2017 for AO Change Request
				Initiating_Unit_Column="Routing_Unit_1_Branches";
			else
				Initiating_Unit_Column="Routing_Unit_1_WM_SME";
			if(mainCodeValue.equals("0"))
			{
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
				for(int k=0; k<recordcount; k++)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
										
					String strCode=objXmlParser.getValueOf("Checklist_Item_Code");
					if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("PB_CREDIT"))
					{
						if(strCreditItems.equals(""))
							strCreditItems=strCode;
						else
							strCreditItems+=","+strCode;
					}
					else if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("WM_CONTROLS"))
					{
						if(strWMCtrlItems.equals(""))
							strWMCtrlItems=strCode;
						else
							strWMCtrlItems+=","+strCode;
					}
					else if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("BRANCH_CONTROLS"))
					{
						if(strBranchCtrlItems.equals(""))
							strBranchCtrlItems=strCode;
						else
							strBranchCtrlItems+=","+strCode;
					}
					else if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("WM_CONTROLS/SME_CONTROLS"))
					{
						if(segment.equalsIgnoreCase("PAM")||segment.equalsIgnoreCase("PRS"))//WMControls
						{
							if(strWMCtrlItems.equals(""))
								strWMCtrlItems=strCode;
							else
								strWMCtrlItems+=","+strCode;
						}
						else if(segment.equalsIgnoreCase("PSL")||segment.equalsIgnoreCase("SME"))//SMEControls
						{
							if(strSMECtrlItems.equals(""))
								strSMECtrlItems=strCode;
							else
								strSMECtrlItems+=","+strCode;
						}
						else
						{
							if(strWMCtrlItems.equals(""))
								strWMCtrlItems=strCode;
							else
								strWMCtrlItems+=","+strCode;
						}	
					}					
				}
			}
			//WriteLog("-1:"+Initiating_Unit_Column);
			//WriteLog("0:"+segment);
			//WriteLog("1:"+strCreditItems);
			//WriteLog("2:"+strWMCtrlItems);
			//WriteLog("3:"+strBranchCtrlItems);
			//WriteLog("4:"+strSMECtrlItems);
			
			//Check for WMCtrl flag
			if(strWMCtrlItems.equals(""))
				strDistributeFlags="N";
			else
			{
				boolean excpRaised=false;
				String WMExcps[] =strWMCtrlItems.split(",");
				for (int i=0;i<WMExcps.length;i++)
				{
					//WriteLog("WM1 raisedExceptions:"+raisedExceptions);
					if(raisedExceptions.indexOf(WMExcps[i]+"~")>-1)
					{
						//WriteLog("WM2 raisedExceptions:"+raisedExceptions);
						if(raisedExceptions.substring(raisedExceptions.indexOf(WMExcps[i]+"~")+(WMExcps[i]+"~").length()).indexOf("[Raised")==0)
							{
								excpRaised=true;
								break;
							}
							else if(raisedExceptions.substring(raisedExceptions.indexOf(WMExcps[i]+"~")+(WMExcps[i]+"~").length()).indexOf("[Rejected")==0)
							{
								excpRaised=true;
								break;
							}
					}
				}
				if(excpRaised)
					strDistributeFlags="Y";
				else
					strDistributeFlags="N";
			}
			
			//Check for SMECtrl flag
			if(strSMECtrlItems.equals(""))
				strDistributeFlags+="|N";
			else
			{
				boolean excpRaised=false;
				String SMEExcps[] =strSMECtrlItems.split(",");
				
				for (int i=0;i<SMEExcps.length;i++)
				{
					//WriteLog("SME1 raisedExceptions:"+raisedExceptions);
					if(raisedExceptions.indexOf(SMEExcps[i]+"~")>-1)
					{
						//WriteLog("SME2 raisedExceptions:"+raisedExceptions);
						if(raisedExceptions.substring(raisedExceptions.indexOf(SMEExcps[i]+"~")+(SMEExcps[i]+"~").length()).indexOf("[Raised")==0)
							{
								excpRaised=true;
								break;
							}
							else if(raisedExceptions.substring(raisedExceptions.indexOf(SMEExcps[i]+"~")+(SMEExcps[i]+"~").length()).indexOf("[Rejected")==0)
							{
								excpRaised=true;
								break;
							}
					}
				}
				if(excpRaised)
					strDistributeFlags+="|Y";
				else
					strDistributeFlags+="|N";
			}
			//Check for Branch flag
			if(strBranchCtrlItems.equals(""))
				strDistributeFlags+="|N";
			else
			{
				boolean excpRaised=false;
				String BranchExcps[] =strBranchCtrlItems.split(",");
				for (int i=0;i<BranchExcps.length;i++)
				{
					//WriteLog("BR1 raisedExceptions:"+raisedExceptions);
					if(raisedExceptions.indexOf(BranchExcps[i]+"~")>-1)
					{
						//WriteLog("BR2 raisedExceptions:"+raisedExceptions);
						if(raisedExceptions.substring(raisedExceptions.indexOf(BranchExcps[i]+"~")+(BranchExcps[i]+"~").length()).indexOf("[Raised")==0)
							{
								excpRaised=true;
								break;
							}
							else if(raisedExceptions.substring(raisedExceptions.indexOf(BranchExcps[i]+"~")+(BranchExcps[i]+"~").length()).indexOf("[Rejected")==0)
							{
								excpRaised=true;
								break;
							}
					}
				}
				if(excpRaised)
					strDistributeFlags+="|Y";
				else
					strDistributeFlags+="|N";
			}
			//Check for PBCredit flag
			if(strCreditItems.equals(""))
				strDistributeFlags+="|N";
			else
			{
				boolean excpRaised=false;
				String CreditExcps[] =strCreditItems.split(",");
				for (int i=0;i<CreditExcps.length;i++)
				{
					//WriteLog("CR1 raisedExceptions:"+raisedExceptions);
					if(raisedExceptions.indexOf(CreditExcps[i]+"~")>-1)
					{
						//WriteLog("CR2 raisedExceptions:"+raisedExceptions);
						if(raisedExceptions.substring(raisedExceptions.indexOf(CreditExcps[i]+"~")+(CreditExcps[i]+"~").length()).indexOf("[Raised")==0)
							{
								excpRaised=true;
								break;
							}
							else if(raisedExceptions.substring(raisedExceptions.indexOf(CreditExcps[i]+"~")+(CreditExcps[i]+"~").length()).indexOf("[Rejected")==0)
							{
								excpRaised=true;
								break;
							}
					}
				}
				if(excpRaised)
					strDistributeFlags+="|Y";
				else
					strDistributeFlags+="|N";
			}		
		}catch(Exception e)
		{
			strDistributeFlags="Error";
		}	
		return strDistributeFlags;
    }
public String getChecklistForHistory( String WSNAME, String checklistData,String decision,String cabName,String sessionId,String ipAddr,int port,String WINAME,String segment, String northSouthBranch) 
	{
		String raisedItems="";
		try{
			
			XMLParser xmlParserData=null;
			XMLParser objXmlParser=null;
			String raisedExceptions="";
			String subXML="";	
			
			//String Query="select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_AO_Exception_History with(nolock) where winame='"+WINAME+"'  order by ExcpCode asc,convert(datetime,actiondatetime,103) desc";
			//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";
			
			String params="WINAME=="+WINAME;
			String Query="select ExcpCode,WSName,UserName,Decision,ActionDateTime from USR_0_AO_Exception_History with(nolock) where winame=:WINAME  order by ExcpCode asc,convert(datetime,actiondatetime,103) desc";
			
			String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
	
			//String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			String outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			
			String mainCodeValue = xmlParserData.getValueOf("MainCode");
			int recordcount=0;
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
			String strAMLComplianceItems="";
			String strCreditItems="";
			String strWMCtrlItems="";
			String strSMECtrlItems="";
			String strBranchCtrlItems="";
			
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
						raisedExceptions+="#"+objXmlParser.getValueOf("ExcpCode")+"~["+objXmlParser.getValueOf("Decision")+"-"+objXmlParser.getValueOf("UserName")+"-"+objXmlParser.getValueOf("WSName")+"-"+objXmlParser.getValueOf("ActionDateTime")+"]";
					}
				}
			}
			raisedExceptions=mergeException(raisedExceptions,checklistData);
			
			//Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive='Y' order by id Asc";
			//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId></APSelectWithColumnNames_Input>";
			
			Query="Select Checklist_Item_Desc,Checklist_Item_Code,Routing_Unit_1_Branches,Routing_Unit_1_WM_SME,Approving_Unit from USR_0_AO_Checklist_Master with(nolock) where IsActive=:IsActive order by id Asc";
			params="IsActive==Y";
			inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + cabName + "</EngineName><SessionId>" + sessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam_Input>";
				
			//outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML((outputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			recordcount=0;
			String Initiating_Unit_Column="";
							
			if(segment.equalsIgnoreCase("PBN")||segment.equalsIgnoreCase("PRS"))//Added by amitabh on 11-16-2017 for AO Change Request
				Initiating_Unit_Column="Routing_Unit_1_Branches";
			else
				Initiating_Unit_Column="Routing_Unit_1_WM_SME";
				
				
			if(mainCodeValue.equals("0"))
			{
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
				for(int k=0; k<recordcount; k++)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
										
					String strCode=objXmlParser.getValueOf("Checklist_Item_Code");
					if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("PB_CREDIT"))
					{
						if(strCreditItems.equals(""))
							strCreditItems=strCode;
						else
							strCreditItems+=","+strCode;
					}
					else if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("WM_CONTROLS"))
					{
						if(strWMCtrlItems.equals(""))
							strWMCtrlItems=strCode;
						else
							strWMCtrlItems+=","+strCode;
					}
					else if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("BRANCH_CONTROLS"))
					{
						if(strBranchCtrlItems.equals(""))
							strBranchCtrlItems=strCode;
						else
							strBranchCtrlItems+=","+strCode;
					}
					else if(objXmlParser.getValueOf(Initiating_Unit_Column).equalsIgnoreCase("WM_CONTROLS/SME_CONTROLS"))
					{
						if(segment.equalsIgnoreCase("PAM")||segment.equalsIgnoreCase("PRS"))//WMControls
						{
							if(strWMCtrlItems.equals(""))
								strWMCtrlItems=strCode;
							else
								strWMCtrlItems+=","+strCode;
						}
						else if(segment.equalsIgnoreCase("PSL")||segment.equalsIgnoreCase("SME"))//SMEControls
						{
							if(strSMECtrlItems.equals(""))
								strSMECtrlItems=strCode;
							else
								strSMECtrlItems+=","+strCode;
						}		
					}
					if(objXmlParser.getValueOf("Approving_Unit").equalsIgnoreCase("AML_COMPLIANCE"))
					{
						if(strAMLComplianceItems.equals(""))
								strAMLComplianceItems=strCode;
						else
							strAMLComplianceItems+=","+strCode;
					}
				}
			}
						
			//Check for WMCtrl flag
			if(WSNAME.equalsIgnoreCase("WM_CONTROLS"))
			{
				if(strWMCtrlItems.equals(""))
					raisedItems="";
				else
				{
					boolean excpRaised=false;
					String WMExcps[] =strWMCtrlItems.split(",");
					for (int i=0;i<WMExcps.length;i++)
					{
						if(raisedExceptions.indexOf(WMExcps[i]+"~")>-1)
						{
							if(raisedExceptions.substring(raisedExceptions.indexOf(WMExcps[i]+"~")+(WMExcps[i]+"~").length()).indexOf("[Raised")==0)
								{
									if(raisedItems.equals(""))
										raisedItems=WMExcps[i];
									else 	
										raisedItems+=","+WMExcps[i];
								}
						}
					}
				}
			}
			else if(WSNAME.equalsIgnoreCase("SME_CONTROLS"))
			{
				if(strSMECtrlItems.equals(""))
					raisedItems="";
				else
				{
					boolean excpRaised=false;
					String SMEExcps[] =strSMECtrlItems.split(",");
					for (int i=0;i<SMEExcps.length;i++)
					{
						if(raisedExceptions.indexOf(SMEExcps[i]+"~")>-1)
						{
							if(raisedExceptions.substring(raisedExceptions.indexOf(SMEExcps[i]+"~")+(SMEExcps[i]+"~").length()).indexOf("[Raised")==0)
								{
									if(raisedItems.equals(""))
										raisedItems=SMEExcps[i];
									else 	
										raisedItems+=","+SMEExcps[i];
								}
						}
					}
				}
			}	
			else if(WSNAME.equalsIgnoreCase("BRANCH_CONTROLS"))
			{
			
				//get north/south branch
				if (northSouthBranch.equalsIgnoreCase("North"))
				{
								if(strBranchCtrlItems.equals(""))
												strBranchCtrlItems=strSMECtrlItems;
								else if(!strSMECtrlItems.equals(""))
												strBranchCtrlItems+=","+strSMECtrlItems;
												
								if(strBranchCtrlItems.equals(""))
												strBranchCtrlItems=strWMCtrlItems;
								else if(!strWMCtrlItems.equals(""))
												strBranchCtrlItems+=","+strWMCtrlItems;
				}
				if(strBranchCtrlItems.equals(""))
					raisedItems="";
				else
				{
					boolean excpRaised=false;
					String BranchExcps[] =strBranchCtrlItems.split(",");
					for (int i=0;i<BranchExcps.length;i++)
					{
						if(raisedExceptions.indexOf(BranchExcps[i]+"~")>-1)
						{
							if(raisedExceptions.substring(raisedExceptions.indexOf(BranchExcps[i]+"~")+(BranchExcps[i]+"~").length()).indexOf("[Raised")==0)
								{
									if(raisedItems.equals(""))
										raisedItems=BranchExcps[i];
									else 	
										raisedItems+=","+BranchExcps[i];
								}
						}
					}
				}
			}	
			else if(WSNAME.equalsIgnoreCase("PB_CREDIT"))
			{
				if(strCreditItems.equals(""))
					raisedItems="";
				else
				{
					boolean excpRaised=false;
					String CreditExcps[] =strCreditItems.split(",");
					for (int i=0;i<CreditExcps.length;i++)
					{
						if(raisedExceptions.indexOf(CreditExcps[i]+"~")>-1)
						{
							if(raisedExceptions.substring(raisedExceptions.indexOf(CreditExcps[i]+"~")+(CreditExcps[i]+"~").length()).indexOf("[Raised")==0)
								{
									if(raisedItems.equals(""))
										raisedItems=CreditExcps[i];
									else 	
										raisedItems+=","+CreditExcps[i];
								}
						}
					}					
				}
			}
			else if(WSNAME.equalsIgnoreCase("AML_COMPLIANCE"))
			{
				if(strAMLComplianceItems.equals(""))
					raisedItems="";
				else
				{
					boolean excpRaised=false;
					String AMLExcps[] =strAMLComplianceItems.split(",");
					for (int i=0;i<AMLExcps.length;i++)
					{
						if(raisedExceptions.indexOf(AMLExcps[i]+"~")>-1)
						{
							if(raisedExceptions.substring(raisedExceptions.indexOf(AMLExcps[i]+"~")+(AMLExcps[i]+"~").length()).indexOf("[Recommended")==0)
								{
									if(raisedItems.equals(""))
										raisedItems=AMLExcps[i];
									else 	
										raisedItems+=","+AMLExcps[i];
								}
						}
					}
				}
			}	
				
		}catch(Exception e)
		{
			raisedItems="Error";
		}
	   //WriteLog("getChecklistForHistory>>"+raisedItems);		
		return raisedItems;
    }
public String getChecklistData( String WINAME,  String checklistData,String cabName,String sessionId,String ipAddr,int port) 
	{
		String Query="";
		String params="";
		String inputXML="";
		String outputXML="";
		String mainCodeValue="";
		XMLParser xmlParserData=null;
		String strChecklistField="H_Checklist";
		//Query="select "+strChecklistField+"  from RB_AO_EXTTABLE with(nolock) where WI_NAME='"+WINAME+"'";					
		//inputXML = getAPSelectXML(cabName,sessionId,Query);
		
		params="WINAME=="+WINAME;
		Query="select "+strChecklistField+"  from RB_AO_EXTTABLE with(nolock) where WI_NAME=:WINAME";					
		inputXML = getAPSelectParamXML(cabName,sessionId,Query,params);
		
		
		
		try{
			//outputXML=NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
			
			outputXML = NGEjbClient.getSharedInstance().makeCall(ipAddr, String.valueOf(port),"WebSphere" , inputXML);
		}catch(Exception e){
		}
		
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML((outputXML));
		mainCodeValue = xmlParserData.getValueOf("MainCode");
		if(mainCodeValue.equals("0"))
		{
			//String decision = xmlParserData.getValueOf("decision");
			return xmlParserData.getValueOf(strChecklistField);
		}
		else
		{
			//WriteLog("<OutPut>Error in getting Checklist Data.</OutPut>");
			return "Error";
		}	
    }
	
	public  void AO_SaveHistory(String WIDATA,String CategoryID,String SubCategoryID,String WSNAME,String WS_LogicalName,String WINAME,String checklistData,String rejectReasons ,String sCabName ,String sSessionId , String sJtsIp ,int iJtsPort,String sUserName,String sPersonalName, String sFamilyName)	
	{
		
		try{
			String colname="";
		String colvalues="'";
		String temp[]=null;
		String inputData="";
		String outputData="";
		String mainCodeValue="";
		XMLParser xmlParserData=null;
		XMLParser objXmlParser=null;
		String subXML="";
		String sInputXML="";
		String sOutputXML="";
		String mainCodeData="";
		int count2=0;			
		//sCabName=wDSession.getM_objCabinetInfo().getM_strCabinetName();
		//sSessionId = wDSession.getM_objUserInfo().getM_strSessionId();		
		//sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
		//iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerIP();
		HashMap<String, String> hmap = new HashMap<String, String>();
		
		if(SubCategoryID.equals("1") )
		{	
			String temp2[]= WIDATA.split("~");
			count2=temp2.length;
			
			String check2[]=null;			
			String hist_table="";
			String colname2="";
			String colvalues2="";
			String decision="";
			String remarks="";
			
			for(int t=0;t<count2;t++)
			{
				check2=temp2[t].split("#");
				colname2=check2[0];
				if(colname2.toUpperCase().equals("DECISION"))
				decision=check2[1].substring(check2[1].indexOf("$")+1);
				else if(colname2.toUpperCase().equals("REMARKS"))
				{
					remarks=check2[1].substring(check2[1].indexOf("$")+1);;
				}
				//WriteLog("colvalues2 FromSaveHistory="+colvalues2);
						
			}
			if(WSNAME.trim().equalsIgnoreCase("CSO"))
			{
				decision="Introduce";
			}
			//WriteLog("decision="+decision);
			hist_table="usr_0_ao_wihistory";
			colname2="decision,actiondatetime,remarks,username,checklistData";
			//colvalues2="'"+decision+"',getdate(),'"+remarks+"','"+wDSession.getM_objUserInfo().getM_strUserName()+"',"+rejectReasons;
			colvalues2="'"+decision+"',getdate(),'"+remarks+"','"+sUserName+"',"+rejectReasons.replaceAll("&#x3a;",":").replaceAll("&#x23;","#");
			try	{
				sInputXML = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>" + hist_table + "</TableName>" +
					"<ColName>" + colname2 + "</ColName>" +
					"<Values>" + colvalues2 + "</Values>" +
					"<WhereClause>" + "WINAME='"+WINAME+"' and wsname='" +WSNAME+"' and actiondatetime is null" + "</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";
				
				//WriteLog("Updating History WINAME: "+WINAME+", WSNAME: "+WSNAME+" sInputXML "+sInputXML);

				for (int chk=0; chk<3; chk++)
				{
					//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					//sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					
					sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);

					
					//WriteLog("Updating History WINAME: "+WINAME+", WSNAME: "+WSNAME+" sOutputXML"+sOutputXML);

					if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
					{
						//WriteLog("Update History WINAME: "+WINAME+", WSNAME: "+WSNAME+" Successful");
						break;
					}
					else{
						//WriteLog("Update History WINAME: "+WINAME+", WSNAME: "+WSNAME+" UnSuccessful");
					}
				}	
			}
			catch(Exception e) 
			{
				//WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
			//Save ChecklistHistory
			if(decision.equalsIgnoreCase("Hold"))
			{
				//
			}
			else
			{
				if(WSNAME.trim().equalsIgnoreCase("CSM")||WSNAME.trim().equalsIgnoreCase("CSO_Rejects")||WSNAME.trim().equalsIgnoreCase("OPS_Checker")||WSNAME.trim().equalsIgnoreCase("OPS_Maker")||WSNAME.trim().equalsIgnoreCase("CB-WC Maker")||WSNAME.trim().equalsIgnoreCase("CB-WC Checker"))
				{
					if(!checklistData.equals(""))
					{
						String[] updatedExcps=checklistData.split("#");
			
						for (int i=0;i<updatedExcps.length;i++)
						{
							String[] codeArr=updatedExcps[i].split("~");
								codeArr[1]=codeArr[1].replace("CB-WC","CB_WC");
								sInputXML = "<?xml version=\"1.0\"?>" +
								"<APInsert_Input>" +
									"<Option>APInsert</Option>" +
									"<TableName>usr_0_ao_exception_history</TableName>" +
									"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
									"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2].replace("CB_WC","CB-WC")+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
									"<EngineName>" + sCabName + "</EngineName>" +
									"<SessionId>" + sSessionId + "</SessionId>" +
								"</APInsert_Input>";
								com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logging for ops:"+ " ");
								com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sInputXML:"+ sInputXML);
								//WriteLog("History: "+sInputXML);
								//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
								//sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
								
								sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);
								com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sOutputXML:"+ sOutputXML);
								

								//WriteLog("History: "+sOutputXML);
							
						}
					}	
				}
				else if(WSNAME.trim().equalsIgnoreCase("PB_Credit")||WSNAME.trim().equalsIgnoreCase("Branch_Controls")||WSNAME.trim().equalsIgnoreCase("SME_Controls")||WSNAME.trim().equalsIgnoreCase("WM_Controls")||WSNAME.trim().equalsIgnoreCase("AML_Compliance"))
					{
					//WriteLog("checklistData "+checklistData);
					if(!checklistData.equals(""))
					{
						String decisionVal=checklistData.substring(0,checklistData.indexOf("|"));
						String CodeList=checklistData.substring(checklistData.indexOf("|")+1);
						
						if(WSNAME.trim().equalsIgnoreCase("WM_Controls") ||WSNAME.trim().equalsIgnoreCase("Branch_Controls") || WSNAME.trim().equalsIgnoreCase("SME_Controls") ) 
						{
						String CodeList1=CodeList.replace(",","','");
						//String Query="SELECT Checklist_item_code, Approving_Unit FROM USR_0_AO_Checklist_Master with(nolock) WHERE Checklist_Item_Code IN('"+CodeList1+"')";
						//sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
						
						String params="CodeList1=="+CodeList1;
						String Query="SELECT Checklist_item_code, Approving_Unit FROM USR_0_AO_Checklist_Master with(nolock) WHERE Checklist_Item_Code IN(:CodeList1)";
						sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam>";
						
						//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
						//sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
						sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);

						xmlParserData=new XMLParser();
						xmlParserData.setInputXML((sOutputXML));
						mainCodeValue = xmlParserData.getValueOf("MainCode");
						int recordcount=0;
						recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
						
						if(mainCodeValue.equals("0"))
						{
			              for(int k=0; k<recordcount; k++)
						{
						 subXML = xmlParserData.getNextValueOf("Record");
						 objXmlParser = new XMLParser(subXML);
						 String Checklist_item_code=objXmlParser.getValueOf("Checklist_item_code");
						 String Approving_Unit=objXmlParser.getValueOf("Approving_Unit");
						 hmap.put(Checklist_item_code,Approving_Unit);
						}
			
						}			
						}	
						
						String[] codeArr=CodeList.split(",");
						decisionVal=decisionVal.trim();
						SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss");
						Date now = new Date();
						String strDate = sdfDate.format(now);
						
						if(!decisionVal.equalsIgnoreCase("Hold"))
						{
							String Dec="";
							if(decisionVal.equalsIgnoreCase("Approved"))
								Dec="Approved";
							else if(decisionVal.equalsIgnoreCase("Recommended"))
								Dec="Recommended";
							else if(decisionVal.equalsIgnoreCase("Rejected"))
								Dec="Rejected";
							
							
							//String LoggedInUserPersonalName=  wDSession.getM_objUserInfo().getM_strPersonalName()+" "+wDSession.getM_objUserInfo().getM_strFamilyName();
							String LoggedInUserPersonalName=   sPersonalName+" "+ sFamilyName;
							LoggedInUserPersonalName=LoggedInUserPersonalName.trim();		
							for (int i=0;i<codeArr.length;i++)
							{
							
							if(WSNAME.trim().equalsIgnoreCase("WM_Controls") ||WSNAME.trim().equalsIgnoreCase("Branch_Controls") || WSNAME.trim().equalsIgnoreCase("SME_Controls") ) 
								{
								
								//WriteLog(codeArr[i]);
								//WriteLog(hmap.get(codeArr[i]));
								String value2=hmap.get(codeArr[i]);
								if(value2.equals("AML_COMPLIANCE"))
								{
								 Dec="Recommended";
								}
								else
								{
								 Dec="Approved";
								}
								}
							
							
									sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_ao_exception_history</TableName>" +
										"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+codeArr[i]+"','"+WSNAME+"','"+LoggedInUserPersonalName+"','"+Dec+"','"+strDate+"'</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";
									//WriteLog("History: "+sInputXML);
									//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
									//sOutputXML=  NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
									sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);

									//WriteLog("History: "+sOutputXML);
								
							}
						}	
					}	
				}	
			}
			
		}
		}	
		
		
		catch(Exception e){
			
		}
		
	}
%>
<%
//WriteLog("testinggg---");
//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "Start");
//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+wDSession.getM_objCabinetInfo().getM_strServerIP());
//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+wDSession.getM_objCabinetInfo().getM_strServerPort());
//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+wDSession.getM_objCabinetInfo().getM_strAppServerType());
//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+inputXML);

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WIDATA"), 1000, true) );
			String WIDATA_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WIDATA Request.getparameter---> "+request.getParameter("WIDATA"));
			WriteLog("WIDATA Esapi---> "+WIDATA_Esapi);
			
			String WIDATA_Esapi_Replace = WIDATA_Esapi.replace("&#x23;","#");
			WIDATA_Esapi_Replace=WIDATA_Esapi_Replace.replace("&#x7e;","~");
			WIDATA_Esapi_Replace=WIDATA_Esapi_Replace.replace("&#x24;","$");
	        WriteLog("Integration jsp: BranchOptions esapi: after replace changes h3"+WIDATA_Esapi_Replace);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("WSNAME Request.getparameter---> "+request.getParameter("WSNAME"));
			WriteLog("WSNAME_Esapi Esapi---> "+WSNAME_Esapi);
			
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("OLD_CIF_ID"), 1000, true) );
			String OLD_CIF_ID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("OLD_CIF_ID Request.getparameter---> "+request.getParameter("OLD_CIF_ID"));
			WriteLog("OLD_CIF_ID_Esapi Esapi---> "+OLD_CIF_ID_Esapi);
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rvc_package"), 1000, true) );
			String rvc_package_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("rvc_package Request.getparameter---> "+request.getParameter("rvc_package"));
			WriteLog("rvc_package Esapi---> "+rvc_package_Esapi);
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("H_Checklist"), 1000, true) );
			String H_Checklist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("H_Checklist Request.getparameter---> "+request.getParameter("H_Checklist"));
			WriteLog("H_Checklist_Esapi Esapi---> "+H_Checklist_Esapi);
			
			String H_Checklist_Esapi_Replace = H_Checklist_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
	        WriteLog("Integration jsp: H_Checklist_Esapi_Replace esapi: after replace changes h3--->"+H_Checklist_Esapi_Replace);
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("UIDDetails"), 1000, true) );
			String UIDDetails_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			UIDDetails_Esapi = UIDDetails_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
			WriteLog("UIDDetails Request.getparameter---> "+request.getParameter("UIDDetails"));
			WriteLog("UIDDetails_Esapi Esapi---> "+UIDDetails_Esapi);
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("RemarksDetails"), 1000, true) );
			String RemarksDetails_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			RemarksDetails_Esapi = RemarksDetails_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
			WriteLog("RemarksDetails Request.getparameter---> "+request.getParameter("RemarksDetails"));
			WriteLog("RemarksDetails_Esapi Esapi---> "+RemarksDetails_Esapi);
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WS_LogicalName"), 1000, true) );
			String WS_LogicalName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			WriteLog("WS_LogicalName Request.getparameter---> "+request.getParameter("WS_LogicalName"));
			WriteLog("WS_LogicalName_Esapi Esapi---> "+WS_LogicalName_Esapi);
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsDoneClicked"), 1000, true) );
			String IsDoneClicked_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			WriteLog("IsDoneClicked Request.getparameter---> "+request.getParameter("IsDoneClicked"));
			WriteLog("IsDoneClicked_Esapi Esapi---> "+IsDoneClicked_Esapi);
			
			String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsSignatureCropped"), 1000, true) );
			String IsSignatureCropped_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
WriteLog("IsSignatureCropped Request.getparameter---> "+request.getParameter("IsSignatureCropped"));
			WriteLog("IsSignatureCropped Esapi---> "+IsSignatureCropped_Esapi);


        String WINAME=WINAME_Esapi;
		String tr_table = "AO_TXN_TABLE";
		String WIDATA=request.getParameter("WIDATA").replace("ENCODEDPLUS","+");
		String WSNAME=WSNAME_Esapi;
		String OLD_CIF_ID=OLD_CIF_ID_Esapi;
		String rvc_package=rvc_package_Esapi;
		String IsSignatureCropped=IsSignatureCropped_Esapi;
		String Extdata=H_Checklist_Esapi_Replace;		
		com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+"Extdata");
		com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "Extdata:"+Extdata);
		String UIDDetails=UIDDetails_Esapi;   
		String RemarksDetails=RemarksDetails_Esapi;
		String checklistData=Extdata.substring(0,Extdata.indexOf("|"));		
		String rejectReasons=Extdata.substring(Extdata.indexOf("|")+1);		
		String checklistDataForHistory=checklistData;
		
		String WS_LogicalName=WS_LogicalName_Esapi;
		String IsDoneClicked=IsDoneClicked_Esapi;  
		String segment="";	
		String RVC_IMD_Req="";
	    String sUserName = wDSession.getM_objUserInfo().getM_strUserName();
		String sPersonalName = wDSession.getM_objUserInfo().getM_strPersonalName();
		String sFamilyName = wDSession.getM_objUserInfo().getM_strFamilyName();
		String sCabName=wDSession.getM_objCabinetInfo().getM_strCabinetName();	
		String sSessionId = wDSession.getM_objUserInfo().getM_strSessionId();
		String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
		int iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
		
		String colname="";//Columns to be updated
		String colvalues="'";//ColumnValues to be updated
		String temp[]=null;
		String Query="";
		String params="";
		String inputXML="";
		String outputXML="";
		XMLParser xmlParserData=null;
		String mainCodeValue="";
		String wiCurrentDecision="";
		int counter=0;
		Boolean bError=false;
		
		//Query to check if row exists for winame in transaction table
		//Query="select count(*) as count from "+tr_table+" with(nolock) where WI_NAME='"+WINAME+"'";
		//inputXML = getAPSelectXML(sCabName,sSessionId,Query);				
		
		params="WINAME=="+WINAME;
		Query="select count(*) as count from "+tr_table+" with(nolock) where WI_NAME=:WINAME";					
		inputXML = getAPSelectParamXML(sCabName,sSessionId,Query,params);
		
		outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
		//WriteLog(outputXML);
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML((outputXML));
		mainCodeValue = xmlParserData.getValueOf("MainCode");
		int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		
		if(mainCodeValue.equals("0"))
		{	
			counter = Integer.parseInt(xmlParserData.getValueOf("count"));
			int WIDataFieldCount=0;
			temp= WIDATA.split("~");
			WIDataFieldCount=temp.length;
			String fieldArr[]=null;
			//WriteLog(WIDATA);
			//Encoding all fields before updating
			for(int k=0;k<WIDataFieldCount;k++)
			{
				
				fieldArr=temp[k].split("#");		
				colname+=fieldArr[0]+",";
				if(fieldArr[0].equalsIgnoreCase("Decision"))
					wiCurrentDecision=fieldArr[1];
				else if(fieldArr[0].equalsIgnoreCase("Segment"))
					segment=fieldArr[1];
				else if(fieldArr[0].equalsIgnoreCase("RVC_IMD_Req"))
					RVC_IMD_Req=fieldArr[1];
				try
				{
					fieldArr[1]=URLEncoder.encode(fieldArr[1], "UTF-8");
				}
				catch (UnsupportedEncodingException ex) 
				{             
					//WriteLog("Error parsing data.");
					//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "Error 1");
					ex.printStackTrace();         
				} 
				colvalues+=fieldArr[1]+"','";
			}	
			
			colvalues=colvalues.substring(0,(colvalues.lastIndexOf(",")));
			colvalues+=",'"+WINAME+"'";
			colname+="WI_NAME";
		}
		
		String sInputXML="";
		String sOutputXML="";
		String mainCodeData="";
		if(counter!=0)
		{	
			try	{				
				String updatedDecision="";
				String sWhere="WI_NAME='"+WINAME+"'";
				String WScolumns="";
				String WScolValues="";
				String checklistField="";
				String rejectReasonField="RejectReasons";
				
				if(wiCurrentDecision==null||wiCurrentDecision.equalsIgnoreCase("NULL"))
					wiCurrentDecision="";
				
				if(wiCurrentDecision.indexOf(WSNAME+"$")==0)
					wiCurrentDecision=wiCurrentDecision.substring(wiCurrentDecision.indexOf(WSNAME+"$")+(WSNAME+"$").length());
				
				String updatedChecklist="";
				// change for northsouth branch
				//Query="select northsouthbranch from RB_AO_EXTTABLE with(nolock) where WI_NAME='"+WINAME+"'";
				//inputXML = getAPSelectXML(sCabName,sSessionId,Query);				
				
				params="WINAME=="+WINAME;
				Query="select northsouthbranch from RB_AO_EXTTABLE with(nolock) where WI_NAME=:WINAME";					
				inputXML = getAPSelectParamXML(sCabName,sSessionId,Query,params);
				
				outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
				xmlParserData=new XMLParser();
				xmlParserData.setInputXML(outputXML);
				String northSouthBranch = xmlParserData.getValueOf("northsouthbranch");
				
				
							
				//WriteLog("northSouthBranch-->"+northSouthBranch);
				//WriteLog("WSNAME-->"+WSNAME);
				if(WSNAME.equalsIgnoreCase("CSM"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",CSMUserId,CSMDoneAt,CSMDecision,WIStatus,H_Segment";
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ " logging for AO");
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ wiCurrentDecision);
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{  com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ "inside hold");
						updatedDecision="'Hold'";
						wistatus="Held by CSM";
					}
					else if(wiCurrentDecision.equalsIgnoreCase("Approved"))
					{com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ "inside Approved");
						updatedDecision="'Approved'";
						wistatus="Approved by CSM";
					}else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
					 {com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ "inside rejected");
						updatedDecision="'Rejected'";
						wistatus="Rejected by CSM";
					}else if(wiCurrentDecision.equalsIgnoreCase("Exception Found"))
					{ com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ "inside Exception Found ");
						updatedDecision="'Exception Found'";
						wistatus="Exception Found by CSM";
					}		
					if(!IsDoneClicked.equalsIgnoreCase("true"))
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','','','"+segment+"'";
					String sChecklistData="";
					
					//WriteLog(sChecklistData);
	
					if(sChecklistData.equals("Error"))
						bError=true;
					else{
						
						//WriteLog(updatedDecision);
						if(!updatedDecision.equalsIgnoreCase("Hold") && !updatedDecision.equalsIgnoreCase("'Hold'"))
						{
							//WriteLog(IsDoneClicked);
							if(IsDoneClicked.equalsIgnoreCase("true"))
							{
								
								updatedChecklist=getDistributeFlags(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment);
								//WriteLog(updatedChecklist);
								String distributedFlags=updatedChecklist;
								
								if(updatedChecklist.equalsIgnoreCase("Error"))
								{
								
								}
								else
								{
									String WMCtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									String 	WScolumnsAdd="";
									String 	WScolValuesAdd="";
									if (WMCtrlflag==null||WMCtrlflag.equals(""))
										WMCtrlflag="N";
									String WMCtrlflagTemp=WMCtrlflag;
									if(northSouthBranch.equalsIgnoreCase("North"))
									{
										WMCtrlflag="N";
										//WriteLog("WMCtrlflag..............");
									}
									WScolumnsAdd+=",DistToWMCtrl";	
									WScolValuesAdd+=",'"+WMCtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String SMECtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									if (SMECtrlflag==null||SMECtrlflag.equals(""))
										SMECtrlflag="N";
									WScolumnsAdd+=",DistToSMECtrl";	
									WScolValuesAdd+=",'"+SMECtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String BranchCtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									if (BranchCtrlflag==null||BranchCtrlflag.equals(""))
										BranchCtrlflag="N";
									if(northSouthBranch.equalsIgnoreCase("North") && WMCtrlflagTemp.equals("Y"))
									{
										BranchCtrlflag="Y";
										//WriteLog("WMCtrlflag..............");
									}
									WScolumnsAdd+=",DistToBranchCtrl";	
									WScolValuesAdd+=",'"+BranchCtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String Creditflag=updatedChecklist;
									if (Creditflag==null||Creditflag.equals(""))
										Creditflag="N";
									
									WScolumnsAdd+=",DistToPB_CreditCtrl";	
									WScolValuesAdd+=",'"+Creditflag+"'";
								
									
									if(distributedFlags.indexOf("Y")>-1)
									{
										if(wiCurrentDecision.equalsIgnoreCase("Hold"))
											wistatus= "Held by CSM";
										/*if(wiCurrentDecision.equalsIgnoreCase("Approved"))
										{
											wiCurrentDecision="Exception Found";
											wistatus= "Exceptions Raised by CSM";													
										}*/	
																					
										WScolumns+=WScolumnsAdd;	
										WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"','"+segment+"'"+WScolValuesAdd;
									}
									else
									{
										WScolumns+=WScolumnsAdd;	
										WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"','"+segment+"'"+WScolValuesAdd;
									}
									//WriteLog("WHy??");
									checklistData="";
									//WriteLog("Flags Set");
									
								}	
							}
							else
							{
								//
							}	
						}
						else
						{
							if(IsDoneClicked.equalsIgnoreCase("true"))
							{
								WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'Hold','Held by CSM'";
							}
						}								
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
					
				}
				else if(WSNAME.equalsIgnoreCase("CSO_Rejects"))
				{
					//WriteLog("Inside CSO_Rejects::::::");
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",CSORejectsUserId,CSORejectsDoneAt,CSORejectsDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by CSO Rejects";
					}	
					
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						if(wiCurrentDecision.equalsIgnoreCase("Resubmit"))//If resubmitting, then the reject reasons will be cleared.
						{
							rejectReasonField="SMECtrlRejectReasons,WMCtrlRejectReasons,BranchCtrlRejectReasons,PBCreditRejectReasons,RejectReasons";
							rejectReasons="','','','','";
							wistatus="Resubmitted by CSO Rejects";
							checklistData="";
						}	
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','',''";
					
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						//WScolumns=","+checklistField+WScolumns;
						//WScolValues=",'"+updatedChecklist+"'"+WScolValues;
					}
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
					
				}
				else if(WSNAME.equalsIgnoreCase("Error"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",ErrorUserId,ErrorDoneAt,ErrorDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by OPS Checker";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						//WScolumns=","+checklistField+WScolumns;
						//WScolValues=",'"+updatedChecklist+"'"+WScolValues;
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("CB-WC Maker"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ "logging 2--");
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ wiCurrentDecision);
					WScolumns=",CBWCMakerUserId,CBWCMakerDoneAt,CBWCMakerDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Submit"))
					{com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ " inside CB-WC Maker");
						updatedDecision="'Submit'";
						wistatus="Submitted by CB-WC Maker";
					}else if(wiCurrentDecision.equalsIgnoreCase("Exception Found"))
					{  com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ " inside Exception Found");
						updatedDecision="'Exception Found'";
						wistatus="Exception Found by CB-WC Maker";
					}else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
					{  com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "queueProcessName:"+ " inside Rejected");
						updatedDecision="'Rejected'";
						wistatus="Rejected by CB-WC Maker";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"','"+wistatus+"'";
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						checklistData="";
					}
				}
				else if(WSNAME.equalsIgnoreCase("CB-WC Checker"))
				{
				  
				    String 	WScolumnsAdd="";
					String 	WScolValuesAdd="";
				    
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",CBWCCheckerUserId,CBWCCheckerDoneAt,CBWCCheckerDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Approved"))
					{
						updatedDecision="'Approved'";
						wistatus="Approved by CB-WC Checker";
					}else if(wiCurrentDecision.equalsIgnoreCase("Exception Found"))
					{
						updatedDecision="'Exception Found'";
						
						wistatus="Exception Found by CB-WC Checker";
						
						if(IsDoneClicked.equalsIgnoreCase("true"))
						{
						   
							if(IsDoneClicked.equalsIgnoreCase("true"))
							{
							updatedChecklist=getDistributeFlags(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment);
								
								String distributedFlags=updatedChecklist;
								if(updatedChecklist.equalsIgnoreCase("Error"))
								{
									//
								}
								else
								{
									String WMCtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									
									if (WMCtrlflag==null||WMCtrlflag.equals(""))
										WMCtrlflag="N";
									
									WScolumnsAdd+=",DistToWMCtrl";	
									WScolValuesAdd+=",'"+WMCtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String SMECtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									if (SMECtrlflag==null||SMECtrlflag.equals(""))
										SMECtrlflag="N";
									
									WScolumnsAdd+=",DistToSMECtrl";	
									WScolValuesAdd+=",'"+SMECtrlflag+"'";
								
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String BranchCtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									if (BranchCtrlflag==null||BranchCtrlflag.equals(""))
										BranchCtrlflag="N";
									
									WScolumnsAdd+=",DistToBranchCtrl";	
									WScolValuesAdd+=",'"+BranchCtrlflag+"'";
									
								
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String Creditflag=updatedChecklist;
									if (Creditflag==null||Creditflag.equals(""))
										Creditflag="N";
									
									WScolumnsAdd+=",DistToPB_CreditCtrl";	
									WScolValuesAdd+=",'"+Creditflag+"'";
									
											
									checklistData="";
									//WriteLog("Flags Set");
									
								}	
							}
							else
							{
								//
							}
						}
						
					}else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
					{
						updatedDecision="'Rejected'";
						wistatus="Rejected by CB-WC Checker";
					}		
					
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						//WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						WScolumns+=WScolumnsAdd;	
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'"+WScolValuesAdd;	
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						checklistData="";
					}
					
				}
				else if(WSNAME.equalsIgnoreCase("OPS_Maker"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",OPSMakerUserId,OPSMakerDoneAt,OPSMakerDecision,WIStatus,rvc_package,IsSignatureCropped";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by OPS Maker";
					}else if(wiCurrentDecision.equalsIgnoreCase("Approved"))
					{
						updatedDecision="'Approved'";
						wistatus="Approved by OPS Maker";
					}else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
					{
						updatedDecision="'Rejected'";
						wistatus="Rejected by OPS Maker";
					}else if(wiCurrentDecision.equalsIgnoreCase("Exception Found"))
					{
						updatedDecision="'Exception Found'";
						wistatus="Exception Found by OPS Maker";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"','"+rvc_package+"','"+IsSignatureCropped+"'";
						//checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"','','"+rvc_package+"','"+IsSignatureCropped+"'";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{





						if(IsDoneClicked.equalsIgnoreCase("true"))
						{
							checklistData="";
						}
					}
					
					// WScolumns+=",OLD_CIF_ID";	
					// WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("OPS_Checker"))
				{
					String 	WScolumnsAdd="";
					String 	WScolValuesAdd="";
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",OPSCheckerUserId,OPSCheckerDoneAt,OPSCheckerDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by OPS Checker";
					}
					else if(wiCurrentDecision.equalsIgnoreCase("Account Opened"))
					{
						wistatus="Account Opened by OPS Checker";
					}
					
					else if(wiCurrentDecision.equalsIgnoreCase("Exception Found"))
					{
						wistatus="Exception Found by OPS Checker";
						
						if(IsDoneClicked.equalsIgnoreCase("true"))
						{
							if(IsDoneClicked.equalsIgnoreCase("true"))
							{
								
								updatedChecklist=getDistributeFlags(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment);
								String distributedFlags=updatedChecklist;
								
								if(updatedChecklist.equalsIgnoreCase("Error"))
								{
									//
								}
								else
								{
									String WMCtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									
									if (WMCtrlflag==null||WMCtrlflag.equals(""))
										WMCtrlflag="N";
									String WMCtrlflagTemp=WMCtrlflag;
									if(northSouthBranch.equalsIgnoreCase("North"))
									{
										WMCtrlflag="N";
									}
									WScolumnsAdd+=",DistToWMCtrl";	
									WScolValuesAdd+=",'"+WMCtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String SMECtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									if (SMECtrlflag==null||SMECtrlflag.equals(""))
										SMECtrlflag="N";
									
									WScolumnsAdd+=",DistToSMECtrl";	
									WScolValuesAdd+=",'"+SMECtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String BranchCtrlflag=updatedChecklist.substring(0,updatedChecklist.indexOf("|"));
									if (BranchCtrlflag==null||BranchCtrlflag.equals(""))
										BranchCtrlflag="N";
									if(northSouthBranch.equalsIgnoreCase("North") && WMCtrlflagTemp.equals("Y"))
									{
										BranchCtrlflag="Y";
									}
									WScolumnsAdd+=",DistToBranchCtrl";	
									WScolValuesAdd+=",'"+BranchCtrlflag+"'";
									
									updatedChecklist=updatedChecklist.substring(updatedChecklist.indexOf("|")+1);
									String Creditflag=updatedChecklist;
									if (Creditflag==null||Creditflag.equals(""))
										Creditflag="N";
									
									WScolumnsAdd+=",DistToPB_CreditCtrl";	
									WScolValuesAdd+=",'"+Creditflag+"'";
									
																			
									checklistData="";
									//WriteLog("Flags Set");
								}	
							}
							else
							{
								//
							}
						}
					}
					else if(wiCurrentDecision.equalsIgnoreCase("Rejected"))
					{
						wistatus="Rejected by OPS Checker";
					}
					else if(wiCurrentDecision.equalsIgnoreCase("RVC/IMD Approved"))
					{
						wistatus="RVC/IMD Approved by OPS Checker";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						//WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						WScolumns+=WScolumnsAdd;	
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'"+WScolValuesAdd;	
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						//WriteLog(WScolumns);
						//WriteLog(WScolValues);
					}
					
					WScolumns+=",OLD_CIF_ID,RVCIMDReqd";	
					WScolValues+=",'"+OLD_CIF_ID+"','"+RVC_IMD_Req+"'";
				}
				else if(WSNAME.equalsIgnoreCase("Archival Team"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",ArchivalTeamUserId,ArchivalTeamDoneAt,ArchivalTeamDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by Archival Team";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						//WScolumns=","+checklistField+WScolumns;  // commented by ankit as problem in update
						//WScolValues=",'"+updatedChecklist+"'"+WScolValues;
					}
					
					WScolumns+=",OLD_CIF_ID";
					//WriteLog("WScolumns inside Archival team"+WScolumns);					
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("AML_Compliance"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",AMLComplianceUserId,AMLComplianceDoneAt,AMLComplianceDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by AML Compliance";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				// Start - added for compliance and manager queue on 10042019
				else if(WSNAME.equalsIgnoreCase("Compliance"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",ComplianceUserId,ComplianceDoneAt,ComplianceDecision,WIStatus";
						
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("Compliance_Manager"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",ComplianceManagerUserId,ComplianceManagerDoneAt,ComplianceManagerDecision,WIStatus";
						
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				// End - added for compliance and manager queue on 10042019
				else if(WSNAME.equalsIgnoreCase("PB_Credit"))
				{
					checklistField="PBCreditChecklist";
					rejectReasonField="PBCreditRejectReasons";
					String wistatus="";//To be updated in queuedatatable
					WScolumns=",PBCreditUserId,PBCreditDoneAt,PB_CreditDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by PB Credit";
					}	
					//WriteLog("checklistDataForHistory "+checklistDataForHistory);
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("SME_Controls"))
				{
					checklistField="SMEControlsChecklist";
					rejectReasonField="SMECtrlRejectReasons";
					String wistatus="";//To be updated in queuedatatable
					WScolumns=",SMEControlsUserId,SMEControlsDoneAt,SMECtrlDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by SME Controls";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("WM_Controls"))
				{
					checklistField="WMControlsChecklist";
					rejectReasonField="WMCtrlRejectReasons";
					String wistatus="";//To be updated in queuedatatable
					WScolumns=",WMControlsUserId,WMControlsDoneAt,WMCtrlDecision";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by WM Controls";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("Branch_Controls"))
				{
					checklistField="BranchControlsChecklist";
					rejectReasonField="BranchCtrlRejectReasons";
					String wistatus="";//To be updated in queuedatatable
					WScolumns=",BranchControlsUserId,BranchControlsDoneAt,BranchCtrlDecision,WIStatus";
					if(wiCurrentDecision.equalsIgnoreCase("Hold"))
					{
						updatedDecision="'Hold'";
						wistatus="Held by Branch Controls";
					}	
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					if(!updatedDecision.equalsIgnoreCase("Hold"))
					{
						
					}
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				else if(WSNAME.equalsIgnoreCase("Controls"))
				{
					checklistField="H_Checklist";
					String wistatus="";
					WScolumns=",ControlsUserId,ControlsDoneAt,ControlsDecision,WIStatus";
						
					if(IsDoneClicked.equalsIgnoreCase("true"))
					{
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"',getdate(),'"+wiCurrentDecision+"','"+wistatus+"'";
						checklistDataForHistory=wiCurrentDecision+"|"+getChecklistForHistory(WSNAME,checklistData,wiCurrentDecision, sCabName, sSessionId, sJtsIp, iJtsPort,WINAME,segment,northSouthBranch);
					}	
					else
						WScolValues=",'"+wDSession.getM_objUserInfo().getM_strUserName()+"','','"+wiCurrentDecision+"',''";
					
					WScolumns+=",OLD_CIF_ID";	
					WScolValues+=",'"+OLD_CIF_ID+"'";
				}
				
				//WriteLog(String.valueOf(bError));
				com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "bError:"+ bError );
				if(!bError)
				{
					//WriteLog("checklistField"+checklistField);
					//WriteLog("checklistData"+checklistData);
					//WriteLog("WScolumns" +WScolumns);
					
					sInputXML = getAPUpdateXML(sCabName,sSessionId,"RB_AO_EXTTABLE",checklistField+","+rejectReasonField+WScolumns,"'"+checklistData+"','"+rejectReasons+"'"+WScolValues,sWhere);
					//WriteLog("Input Xml in External Table update 1st instance for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" is: "+sInputXML);
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sInputXML1234:"+ sInputXML );
					for (int chk=0; chk<5; chk++)
					{
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
						com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sOutputXML:"+ sOutputXML );
						//WriteLog("Output Xml in External Table update 1st instance Seq: "+chk+" for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" is: "+sOutputXML);

						if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
						{
							break;
						}
					}
					
					//WriteLog("sOutputXML"+sOutputXML);
					xmlParserData.setInputXML((sOutputXML));
					mainCodeValue = xmlParserData.getValueOf("MainCode");
					
					if(mainCodeValue.equals("0"))
					{
						//WriteLog("update in External Table update 1st instance for WINAME: "+WINAME+", WSNAME: "+WSNAME+" Successful");
					}
					else
					{
						//WriteLog("update in External Table update 1st instance for WINAME: "+WINAME+", WSNAME: "+WSNAME+" UnSuccessful");
						bError=true;
					}
					//code block added for CBWCUID check
					if(WSNAME.equalsIgnoreCase("Branch_Controls") || WSNAME.equalsIgnoreCase("CB-WC Checker") || WSNAME.equalsIgnoreCase("Controls"))
					{
						
						 
						String procName="AO_InsertUIDDetails";
						String param="'"+UIDDetails+"','"+RemarksDetails+"','"+WINAME+"','"+wDSession.getM_objUserInfo().getM_strUserName
						()+"','"+WSNAME+"'";
						WriteLog("AO_InsertUIDDetails proc param: "+param);
						inputXML="<?xml version=\"1.0\"?>" +                                                           
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>"+procName+"</ProcName>"+
						"<Params>"+param+"</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabName+"</EngineName>" +
						"</APProcedure2_Input>";
						WriteLog("AO_InsertUIDDetails proc inputXML: "+inputXML);
						outputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
						WriteLog("AO_InsertUIDDetails proc outputXML: "+outputXML);
						xmlParserData.setInputXML((outputXML));
						mainCodeValue = xmlParserData.getValueOf("MainCode");
						if(mainCodeValue.equals("0"))
						{
						//WriteLog("Insert Successful");
						}
						else
						{
						//WriteLog("Insert UnSuccessful");
						}
					}
				}
				else
				{
					//WriteLog("Error Saving Data 1.");				
				}
			
				if(!bError)
				{
					sWhere="WI_NAME='"+WINAME+"'";
					sInputXML = getAPUpdateXML(sCabName,sSessionId,tr_table,colname,colvalues,sWhere);
					//WriteLog("Input Xml in Transaction Table update for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" is:"+sInputXML);
					
					for (int chk1=0; chk1<5; chk1++)
					{
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
						//WriteLog("Output Xml in Transaction Table update Seq: "+chk1+" for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" is: "+sOutputXML);

						if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
						{
							break;
						}
					}
					
					xmlParserData.setInputXML((sOutputXML));
					mainCodeValue = xmlParserData.getValueOf("MainCode");
					
					if(mainCodeValue.equals("0"))
					{
						//WriteLog("update in Transaction Table update for WINAME: "+WINAME+", WSNAME: "+WSNAME+" Successful");
					}
					else
					{
						//WriteLog("update in Transaction Table update for WINAME: "+WINAME+", WSNAME: "+WSNAME+" UnSuccessful");
						bError=true;
					}
					
				}else
				{
					//WriteLog("Error Saving Data 2.");
					out.println("Error Saving Data.");
				}				
			}
			catch(Exception e) 
			{
				//WriteLog("<OutPut>Error in getting User Session.</OutPut>"+e.getMessage());
				//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "Error 2");
				out.println("Error Saving Data.");
			}
		}
		else
		{
			//WriteLog("<OutPut>Record not found in transaction table 1.</OutPut>");
			out.println("Error Saving Data.");			
		}
		if(bError)
		{
			//WriteLog("<OutPut>Record not found in transaction table.</OutPut>");
			out.println("Error Saving Data.");			
		}
		else if(IsDoneClicked.equalsIgnoreCase("true"))
		{
		   String Flag="";
		    if((WSNAME.equalsIgnoreCase("OPS_Maker") && (wiCurrentDecision.equalsIgnoreCase("Hold") || wiCurrentDecision.equalsIgnoreCase("Rejected") )) ||(WSNAME.equalsIgnoreCase("OPS_Checker") && (wiCurrentDecision.equalsIgnoreCase("Hold") || wiCurrentDecision.equalsIgnoreCase("Exception Found") )) || (WSNAME.equalsIgnoreCase("CSO_Rejects")))
			{ 
				Flag="N";
			}
			else
			{
				String OPSCheckerDecision="";
				String CBWCCheckerDecision="";
				String DateDifference="";
				//Query="select OPSCheckerDecision,CBWCCheckerDecision,DATEDIFF(day,CBWCCheckerDoneAt,SYSDATETIME()) AS DiffDate from RB_AO_EXTTABLE with(nolock) where WI_NAME='"+WINAME+"'";
				//inputXML = getAPSelectXML(sCabName,sSessionId,Query);				
				
				params="WINAME=="+WINAME;
				Query="select OPSCheckerDecision,CBWCCheckerDecision,DATEDIFF(day,CBWCCheckerDoneAt,SYSDATETIME()) AS DiffDate from RB_AO_EXTTABLE with(nolock) where WI_NAME=:WINAME";					
				inputXML = getAPSelectParamXML(sCabName,sSessionId,Query,params);
				
				outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
				//WriteLog(outputXML);
				xmlParserData=new XMLParser();
				xmlParserData.setInputXML((outputXML));
				mainCodeValue = xmlParserData.getValueOf("MainCode");
				
				if(mainCodeValue.equals("0"))
				{
					OPSCheckerDecision = xmlParserData.getValueOf("OPSCheckerDecision");
					CBWCCheckerDecision = xmlParserData.getValueOf("CBWCCheckerDecision");
					
					DateDifference = xmlParserData.getValueOf("DiffDate");
				}
				//WriteLog("DateDifference "+DateDifference);
				if(!WSNAME.equalsIgnoreCase("CB-WC Maker"))
				{
					if(!OPSCheckerDecision.equalsIgnoreCase("Account Opened"))
					{
						//WriteLog("Inside Account Not Opened Block");
						if(CBWCCheckerDecision.equalsIgnoreCase("Approved") || CBWCCheckerDecision.equalsIgnoreCase("Exception Found") || CBWCCheckerDecision.equalsIgnoreCase("Rejected")  )
						{
							String strNoOfDays="";
							//Query="select configuration_value from usr_0_ao_configuration with(nolock) where configuration_description='Number of days' ";
							//inputXML = getAPSelectXML(sCabName,sSessionId,Query);				
							
							params="NoOfDays==Number of days";
							Query="select configuration_value from usr_0_ao_configuration with(nolock) where configuration_description=:NoOfDays";					
							inputXML = getAPSelectParamXML(sCabName,sSessionId,Query,params);
				
							outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML);
							//WriteLog("APselect for getting configured value from configuration table" +outputXML);
							xmlParserData=new XMLParser();
							xmlParserData.setInputXML((outputXML));
							mainCodeValue = xmlParserData.getValueOf("MainCode");
						
							if(mainCodeValue.equals("0"))
							{
								strNoOfDays = xmlParserData.getValueOf("configuration_value");
							}	
							//WriteLog("Number of Days" +strNoOfDays);			
							if(Integer.parseInt(DateDifference)>Integer.parseInt(strNoOfDays))
							{
								Flag="Y";
								//WriteLog("Setting the flag to Y");
							}		  
						}
					}
				}
			}
			//WriteLog("Value of Flag" + Flag);
			String sWhere1="WI_NAME='"+WINAME+"'";
			String table_name="RB_AO_EXTTABLE";
			colname="IsRouteToCBWCMaker";
			colvalues="'"+Flag+"'";
			sInputXML = getAPUpdateXML(sCabName,sSessionId,table_name,colname,colvalues,sWhere1);
			//WriteLog("Input Xml in External Table update 2nd instance for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" is: "+sInputXML);
			
			for (int chk2=0; chk2<5; chk2++)
			{
				sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				
				//WriteLog("Output Xml in External Table update 2nd instance Seq: "+chk2+" for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" is: "+sOutputXML);

				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					break;
				}
			}
			
			xmlParserData.setInputXML((sOutputXML));
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			 if(mainCodeValue.equals("0"))
			{
				//WriteLog("update in External Table update 2nd instance update for WINAME: "+WINAME+", WSNAME: "+WSNAME+" Successful");
			}
			else
			{
				//WriteLog("update in External Table update 2nd instance update for WINAME: "+WINAME+", WSNAME: "+WSNAME+" UnSuccessful");
			}
				
				
			//WriteLog("Before calling AO_SaveHistory");
			//WriteLog("AO_SaveHistory>>"+checklistDataForHistory);
			if(WSNAME.equalsIgnoreCase("CSO_Rejects"))
				rejectReasons="''";
			else
				rejectReasons="'"+rejectReasons+"'";
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logging for AO Savehistory:"+ " ");
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "WIDATA:"+ WIDATA);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "WSNAME:"+ WSNAME);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "WS_LogicalName:"+ WS_LogicalName);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "WINAME:"+ WINAME);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "checklistDataForHistory:"+ checklistDataForHistory);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "rejectReasons:"+ rejectReasons);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sCabName:"+ sCabName);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sSessionId:"+ sSessionId);com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sJtsIp:"+ sJtsIp);com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "iJtsPort:"+ iJtsPort);com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sUserName:"+ sUserName);com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sPersonalName:"+ sPersonalName);com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sFamilyName:"+ sFamilyName);
			
			try{
			String CategoryID = "5";
			String SubCategoryID ="1";
			 checklistData = checklistDataForHistory;
			colname="";
		 colvalues="'";
		  temp=null;
		 String inputData="";
		String outputData="";
		  mainCodeValue="";
		 xmlParserData=null;
		XMLParser objXmlParser=null;
		String subXML="";
		 sInputXML="";
		 sOutputXML="";
		 mainCodeData="";
		int count2=0;			
		//sCabName=wDSession.getM_objCabinetInfo().getM_strCabinetName();
		//sSessionId = wDSession.getM_objUserInfo().getM_strSessionId();		
		//sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
		//iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerIP();
		HashMap<String, String> hmap = new HashMap<String, String>();
		
		if(SubCategoryID.equals("1") )
		{	com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2061");
			String temp2[]= WIDATA.split("~");
			count2=temp2.length;
			
			String check2[]=null;			
			String hist_table="";
			String colname2="";
			String colvalues2="";
			String decision="";
			String remarks="";
			
			for(int t=0;t<count2;t++)
			{
				check2=temp2[t].split("#");
				colname2=check2[0];
				if(colname2.toUpperCase().equals("DECISION"))
				decision=check2[1].substring(check2[1].indexOf("$")+1);
				else if(colname2.toUpperCase().equals("REMARKS"))
				{
					remarks=check2[1].substring(check2[1].indexOf("$")+1);;
				}
				//WriteLog("colvalues2 FromSaveHistory="+colvalues2);
						
			}
			if(WSNAME.trim().equalsIgnoreCase("CSO"))
			{com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2087");
				decision="Introduce";
			}
			//WriteLog("decision="+decision);
			com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2087- "+decision);
			hist_table="usr_0_ao_wihistory";
			colname2="decision,actiondatetime,remarks,username,checklistData";
			//colvalues2="'"+decision+"',getdate(),'"+remarks+"','"+wDSession.getM_objUserInfo().getM_strUserName()+"',"+rejectReasons;
			colvalues2="'"+decision+"',getdate(),'"+remarks+"','"+sUserName+"',"+rejectReasons.replaceAll("&#x3a;",":").replaceAll("&#x23;","#");
			try	{
				sInputXML = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>" + hist_table + "</TableName>" +
					"<ColName>" + colname2 + "</ColName>" +
					"<Values>" + colvalues2 + "</Values>" +
					"<WhereClause>" + "WINAME='"+WINAME+"' and wsname='" +WSNAME+"' and actiondatetime is null" + "</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";
				
				//WriteLog("Updating History WINAME: "+WINAME+", WSNAME: "+WSNAME+" sInputXML "+sInputXML);
				com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2087- "+sInputXML);

				for (int chk=0; chk<3; chk++)
				{
					//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					//sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					
					sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);

					
					//WriteLog("Updating History WINAME: "+WINAME+", WSNAME: "+WSNAME+" sOutputXML"+sOutputXML);
					com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "Updating History WINAME: "+WINAME+", WSNAME: "+WSNAME+" sOutputXML"+sOutputXML);

					if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
					{
						//WriteLog("Update History WINAME: "+WINAME+", WSNAME: "+WSNAME+" Successful");
						break;
					}
					else{
						//WriteLog("Update History WINAME: "+WINAME+", WSNAME: "+WSNAME+" UnSuccessful");
					}
				}	
			}
			catch(Exception e) 
			{
				//WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
			//Save ChecklistHistory
			if(decision.equalsIgnoreCase("Hold"))
			{
				//
			}
			else
			{ com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2141");
				if(WSNAME.trim().equalsIgnoreCase("CSM")||WSNAME.trim().equalsIgnoreCase("CSO_Rejects")||WSNAME.trim().equalsIgnoreCase("OPS_Checker")||WSNAME.trim().equalsIgnoreCase("OPS_Maker")||WSNAME.trim().equalsIgnoreCase("CB-WC Maker")||WSNAME.trim().equalsIgnoreCase("CB-WC Checker"))
				{  com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2142");
					if(!checklistData.equals(""))
					{
						String[] updatedExcps=checklistData.split("#");
			
						for (int i=0;i<updatedExcps.length;i++)
						{
							String[] codeArr=updatedExcps[i].split("~");
								codeArr[1]=codeArr[1].replace("CB-WC","CB_WC");
								sInputXML = "<?xml version=\"1.0\"?>" +
								"<APInsert_Input>" +
									"<Option>APInsert</Option>" +
									"<TableName>usr_0_ao_exception_history</TableName>" +
									"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
									"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2].replace("CB_WC","CB-WC")+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
									"<EngineName>" + sCabName + "</EngineName>" +
									"<SessionId>" + sSessionId + "</SessionId>" +
								"</APInsert_Input>";
								com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logging for ops:"+ " ");
								com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sInputXML:"+ sInputXML);
								//WriteLog("History: "+sInputXML);
								//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
								//sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
								
								sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);
								com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "sOutputXML:"+ sOutputXML);
								

								//WriteLog("History: "+sOutputXML);
							
						}
					}	
				}
				else if(WSNAME.trim().equalsIgnoreCase("PB_Credit")||WSNAME.trim().equalsIgnoreCase("Branch_Controls")||WSNAME.trim().equalsIgnoreCase("SME_Controls")||WSNAME.trim().equalsIgnoreCase("WM_Controls")||WSNAME.trim().equalsIgnoreCase("AML_Compliance"))
					{
						com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug", "logger:"+ " line 2175");
					//WriteLog("checklistData "+checklistData);
					if(!checklistData.equals(""))
					{
						String decisionVal=checklistData.substring(0,checklistData.indexOf("|"));
						String CodeList=checklistData.substring(checklistData.indexOf("|")+1);
						
						if(WSNAME.trim().equalsIgnoreCase("WM_Controls") ||WSNAME.trim().equalsIgnoreCase("Branch_Controls") || WSNAME.trim().equalsIgnoreCase("SME_Controls") ) 
						{
						String CodeList1=CodeList.replace(",","','");
						//String Query="SELECT Checklist_item_code, Approving_Unit FROM USR_0_AO_Checklist_Master with(nolock) WHERE Checklist_Item_Code IN('"+CodeList1+"')";
						//sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
						
						 params="CodeList1=="+CodeList1;
						 Query="SELECT Checklist_item_code, Approving_Unit FROM USR_0_AO_Checklist_Master with(nolock) WHERE Checklist_Item_Code IN(:CodeList1)";
						sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId><Params>" + params + "</Params></APSelectWithNamedParam>";
						
						//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
						//sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
						sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);

						xmlParserData=new XMLParser();
						xmlParserData.setInputXML((sOutputXML));
						mainCodeValue = xmlParserData.getValueOf("MainCode");
						
						 recordcount=0;
						recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
						
						if(mainCodeValue.equals("0"))
						{
			              for(int k=0; k<recordcount; k++)
						{
						 subXML = xmlParserData.getNextValueOf("Record");
						 objXmlParser = new XMLParser(subXML);
						 String Checklist_item_code=objXmlParser.getValueOf("Checklist_item_code");
						 String Approving_Unit=objXmlParser.getValueOf("Approving_Unit");
						 hmap.put(Checklist_item_code,Approving_Unit);
						}
			
						}			
						}	
						
						String[] codeArr=CodeList.split(",");
						decisionVal=decisionVal.trim();
						SimpleDateFormat sdfDate = new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss");
						Date now = new Date();
						String strDate = sdfDate.format(now);
						
						if(!decisionVal.equalsIgnoreCase("Hold"))
						{
							String Dec="";
							if(decisionVal.equalsIgnoreCase("Approved"))
								Dec="Approved";
							else if(decisionVal.equalsIgnoreCase("Recommended"))
								Dec="Recommended";
							else if(decisionVal.equalsIgnoreCase("Rejected"))
								Dec="Rejected";
							
							
							//String LoggedInUserPersonalName=  wDSession.getM_objUserInfo().getM_strPersonalName()+" "+wDSession.getM_objUserInfo().getM_strFamilyName();
							String LoggedInUserPersonalName=   sPersonalName+" "+ sFamilyName;
							LoggedInUserPersonalName=LoggedInUserPersonalName.trim();		
							for (int i=0;i<codeArr.length;i++)
							{
							
							if(WSNAME.trim().equalsIgnoreCase("WM_Controls") ||WSNAME.trim().equalsIgnoreCase("Branch_Controls") || WSNAME.trim().equalsIgnoreCase("SME_Controls") ) 
								{
								
								//WriteLog(codeArr[i]);
								//WriteLog(hmap.get(codeArr[i]));
								String value2=hmap.get(codeArr[i]);
								if(value2.equals("AML_COMPLIANCE"))
								{
								 Dec="Recommended";
								}
								else
								{
								 Dec="Approved";
								}
								}
							
							
									sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_ao_exception_history</TableName>" +
										"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+codeArr[i]+"','"+WSNAME+"','"+LoggedInUserPersonalName+"','"+Dec+"','"+strDate+"'</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";
									//WriteLog("History: "+sInputXML);
									//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
									//sOutputXML=  NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
									sOutputXML = NGEjbClient.getSharedInstance().makeCall(sJtsIp, String.valueOf(iJtsPort),"WebSphere" , sInputXML);

									//WriteLog("History: "+sOutputXML);
								
							}
						}	
					}		
				}
			}
			
		}
		}	
		
		
		catch(Exception e){
			
		}
			

		}
		
	%>	
	
</BODY>
</HTML>