<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="./Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			logger.info("reqType_Esapi. req "+request.getParameter("reqType"));
			logger.info("reqType_Esapi "+reqType_Esapi);
			
					reqType_Esapi = reqType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
					
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
					logger.info("WSNAME. req "+request.getParameter("WSNAME"));
			logger.info("WSNAME_Esapi  "+WSNAME_Esapi);
			
			WSNAME_Esapi = WSNAME_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
		logger.info("inside dropdownlaod2.jsp");
		String reqType = reqType_Esapi;	
		String WSNAME= WSNAME_Esapi;
		logger.info("WSNAME"+WSNAME);
		String returnValues = "";
		String query = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
		
		if(reqType.equals("selectDecision"))
		{
			query = "SELECT Decision FROM USR_0_RBL_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME=:WSNAME and isActive='Y' order by Decision";
			params = "WSNAME=="+WSNAME;
		}
		else if(reqType.equals("LoanType"))
		{
			query = "SELECT Loan_Type FROM USR_0_RBL_LoanType with(nolock) WHERE ISACTIVE=:ISACTIVE order by Loan_Type";
			params = "ISACTIVE==Y";
		}
		else if(reqType.equals("RMCode"))
		{
			query="SELECT RM_Code from usr_0_RBL_RMCodeMaster with(nolock) where ISActive=:ISActive order by RM_Code";
			params="ISActive==Y";
		}
		else if(reqType.equals("ROCode"))
		{
			query="select UserName from pdbuser where UserIndex in (select UserIndex from PDBGroupMember where GroupIndex in (select Userid from QUEUEUSERTABLE where QueueId in (select QueueID from QUEUEDEFTABLE where QueueName = :QueueName))) order by username";
			params="QueueName==RBL_Introduction";
		}
		else if(reqType.equals("performcheckdays_CBRB"))
		{
			query = "SELECT CONST_FIELD_VALUE FROM USR_0_BPM_CONSTANTS with(nolock) WHERE CONST_FIELD_NAME=:CONST_FIELD_NAME";
			params = "CONST_FIELD_NAME==RBL_performcheckdays_CBRB";
		}
		else if(reqType.equals("performcheckdays_AECB"))
		{
			query = "SELECT CONST_FIELD_VALUE FROM USR_0_BPM_CONSTANTS with(nolock) WHERE CONST_FIELD_NAME=:CONST_FIELD_NAME";
			params = "CONST_FIELD_NAME==RBL_performcheckdays_AECB";
		}
		else if(reqType.equals("wdesk:IndustryCode"))  // label renamed as Macro on 19052019
		{
			query = "SELECT IndustryName FROM USR_0_RBL_IndustryCode with(nolock) WHERE isActive=:isActive order by IndustryName";
			params = "isActive==Y";
		}
		else if(reqType.equals("wdesk:Micro"))
		{
			query = "SELECT Micro FROM USR_0_RBL_MicroMaster with(nolock) WHERE isActive=:isActive order by Micro";
			params = "isActive==Y";
		}
		else if(reqType.equals("wdesk:Sector"))
		{
			query = "SELECT Sector FROM USR_0_RBL_SectorMaster with(nolock) WHERE isActive=:isActive order by Sector";
			params = "isActive==Y";
		}
		else if(reqType.equals("wdesk:CEUDone"))
		{
			query = "SELECT CEUDone FROM USR_0_RBL_CEUDoneMaster with(nolock) WHERE isActive=:isActive order by CEUDone";
			params = "isActive==Y";
		}
		else if(reqType.equals("wdesk:DelegationAuthority"))
		{
			query = "SELECT DelegationAuthority FROM USR_0_RBL_DelegationAuthorityMaster with(nolock) WHERE isActive=:isActive order by DelegationAuthority";
			params = "isActive==Y";
		}
		
		
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		logger.info("\nInput XML for Request type "+reqType+" -- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		if(!reqType.equals("ROCode") && !reqType.equals("RMCode") && !reqType.equals("LoanType") && !reqType.equals("wdesk:IndustryCode") && !reqType.equals("wdesk:Micro")) 
			logger.info("Output XML for Request type "+reqType+" ---- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue = xmlParserData.getVal("MainCode");
		logger.info("maincode"+mainCodeValue);
		
		int recordcount=0;
		try
		{
			recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		}
		catch(Exception e)	
		{
		}
		logger.info("recordcount -- "+recordcount);
	if(mainCodeValue.equals("0") && recordcount > 0)
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if (reqType.equals("LoanType"))
				returnValues = returnValues + objWorkList.getVal("Loan_Type")  + "~";			
			else if (reqType.equals("selectDecision"))
				returnValues = returnValues + objWorkList.getVal("Decision")  + "~";
			else if(reqType.equals("RMCode"))
				returnValues = returnValues + objWorkList.getVal("RM_Code")  + "~";
			else if(reqType.equals("ROCode"))
				returnValues = returnValues + objWorkList.getVal("UserName")  + "~";
			else if(reqType.equals("performcheckdays_CBRB"))
				returnValues = returnValues + objWorkList.getVal("CONST_FIELD_VALUE")  + "~";
			else if(reqType.equals("performcheckdays_AECB"))
				returnValues = returnValues + objWorkList.getVal("CONST_FIELD_VALUE")  + "~";
			else if(reqType.equals("wdesk:IndustryCode"))
				returnValues = returnValues + objWorkList.getVal("IndustryName")  + "~";
			else if(reqType.equals("wdesk:Micro"))
				returnValues = returnValues + objWorkList.getVal("Micro")  + "~";	
			else if(reqType.equals("wdesk:Sector"))
				returnValues = returnValues + objWorkList.getVal("Sector")  + "~";
			else if(reqType.equals("wdesk:CEUDone"))
				returnValues = returnValues + objWorkList.getVal("CEUDone")  + "~";
			else if(reqType.equals("wdesk:DelegationAuthority"))
				returnValues = returnValues + objWorkList.getVal("DelegationAuthority")  + "~";	
			
		}	
		returnValues =  returnValues.substring(0,returnValues.length()-1);
		logger.info("returnValues -- "+returnValues);
		out.clear();
		out.print(returnValues);	
	}
	else
	{
		logger.info("Exception in loading dropdown values -- ");
		out.clear();
		out.print("-1");
	}
	
%>