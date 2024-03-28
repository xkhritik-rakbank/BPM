<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : getSOLIDOfUser.jsp          
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
	try
	{
		String Query1 = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		String inputXMLSOLID = "";
		String outputXMLSOLID = "";
		String params="";
		String mainCodeSolID = "";
		String userName=request.getParameter("userName");
		String Usercomment="";
		Query1 =  "SELECT comment FROM PDBUser with (nolock) WHERE UserName=:USERNAME";
		params = "USERNAME=="+userName;
		
		inputXMLSOLID = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query1 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML For Sol ID-- "+inputXMLSOLID);
	
		outputXMLSOLID = WFCustomCallBroker.execute(inputXMLSOLID, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML For SOL ID ---- "+outputXMLSOLID);
		
		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLSOLID));
		mainCodeSolID = xmlParserData.getVal("MainCode");
		int recordcountForSolId = Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		if(mainCodeSolID.equals("0"))
		{
			if(recordcountForSolId>0)
			{
				Usercomment=xmlParserData.getVal("comment");
				WriteLog("\nUsercomment-- "+Usercomment);
				out.clear();
				out.print(Usercomment);
			}
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e)
	{
		out.clear();
		out.print("-1");
	}	
%>