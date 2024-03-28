<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../TWC_Specific/Log.process"%>
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
		String query = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String reqType = request.getParameter("reqType");
		if (reqType != null) {reqType=reqType.replace("'","");}
		String facilityValue = request.getParameter("facilityValue");
		if (facilityValue != null) {facilityValue=facilityValue.replace("'","");}
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
		String purpose_search="";
		String returnValue = "";
		if(reqType.equals("Purpose"))
		{
			query = "SELECT Purpose FROM USR_0_TWC_FACILITY_MASTER with (nolock) where Facility_Type=:facilityValue";
			params = "facilityValue=="+facilityValue;
			//logger.info("query: "+query);
		}
		

		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		logger.info("\nInput XML -- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		logger.info("Output XML- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue = xmlParserData.getVal("MainCode");
		if(mainCodeValue.equals("0"))
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
				if(reqType.equals("Purpose"))
				{
					String tempPurpose=objWorkList.getVal("Purpose");
					tempPurpose=tempPurpose.replace("<&Purpose&>","__");
					
					purpose_search=purpose_search+tempPurpose + "~";
				}
					
			}
			purpose_search =  purpose_search.substring(0,purpose_search.length()-1);
		}
	out.clear();
	out.print(purpose_search);
%>