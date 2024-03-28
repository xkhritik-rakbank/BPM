<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : DropDownCity.jsp          
//Author                     : Nikita Singhal
// Date written (DD/MM/YYYY) : 07-Nov-2017
//Description                : Populating city values
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../OECD_Specific/Log.process"%>
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
		String Query1 = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String inputXMLcity = "";
		String outputXMLcity = "";
		String subXML="";
		String params="";
		String city_search="";
		String returnValue = "";
		String mainCodeValuecity = "";
		Query1 =  "SELECT cityName FROM USR_0_OECD_CityMaster with (nolock) where 1=:ONE order by cityName";
		params = "ONE==1";
		
		WriteLog("query1 -- "+Query1);

		inputXMLcity = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query1 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML -- "+inputXMLcity);
	
		outputXMLcity = WFCustomCallBroker.execute(inputXMLcity, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML ---- "+outputXMLcity);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLcity));
		mainCodeValuecity = xmlParserData.getVal("MainCode");
		if(mainCodeValuecity.equals("0"))
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
					city_search=city_search+objWorkList.getVal("cityName") + "~";
			}
			city_search =  city_search.substring(0,city_search.length()-1);	
		}
	out.clear();
	out.print(city_search);
%>