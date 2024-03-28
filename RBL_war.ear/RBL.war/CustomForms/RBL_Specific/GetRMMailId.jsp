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

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("RMCode"), 1000, true) );
			String RMCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");

		logger.info("inside GetRMMailId.jsp");	
		String WSNAME= WSNAME_Esapi;
		logger.info("WSNAME"+WSNAME);
		String strRMCode=RMCode_Esapi;
		logger.info("RM Code is "+strRMCode);
		String returnValues = "";
		String query = "";
		String params="";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		
		query="SELECT top 1 RM_Email_Id from USR_0_RBL_RMCodeMaster where RM_Code=:RM_Code";
		params="RM_Code=="+strRMCode;
		
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		logger.info("\nInput XML -- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		logger.info("Output XML ---- "+sOutputXML);

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
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			returnValues = returnValues + objWorkList.getVal("RM_Email_Id")  + "~";			
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