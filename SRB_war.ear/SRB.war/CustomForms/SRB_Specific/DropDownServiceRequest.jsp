<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../SRB_Specific/Log.process"%>
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
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
		String subcat_search="";
		String returnValue = "";
		query = "SELECT SubCategoryName FROM USR_0_SRB_SUBCATEGORY with (nolock) where PrintDispatchRequired='Y' order by SubCategoryName";
		params = "ONE==1";
		
		WriteLog("query for searchable service request-- "+query);

		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML for searchable service request-- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML for searchable service request---- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue = xmlParserData.getVal("MainCode");
		if(mainCodeValue.equals("0"))
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
					subcat_search=subcat_search+objWorkList.getVal("SubCategoryName") + "~";
			}
			subcat_search =  subcat_search.substring(0,subcat_search.length()-1);	
		}
	out.clear();
	out.print(subcat_search);
%>