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
	String Query2 = "";
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;
	WFCustomXmlResponse objWFCustomXmlResponse=null;
	String inputXMLstate="";
	String outputXMLstate= "";
	String subXML="";
	String params="";
	String state_search="";
	String returnValue = "";
	String mainCodeValuestate = "";
	try{
		String wiName=request.getParameter("WI_NAME");
		if (wiName != null) {wiName=wiName.replace("'","");}
		logger.info("\n wiName "+wiName);
		String table_name="USR_0_TWC_SECURITY_DTLS_GRID";
		logger.info("table_name "+table_name);
		
		String col_Names="Security_Document_Type,Security_Document_Desc,TI,Value,FSV,Limit_Covered,Held,Conditions";
		
		logger.info("col_Names "+col_Names);
		
		String[] colNamesArray = col_Names.split(",");
		/*for(int i=0;i<colNamesArray.length;i++)
		{
			logger.info("\n col_Names "+colNamesArray[i]);
		}*/
		Query2 = "SELECT "+col_Names+" FROM "+ table_name+" with (nolock) WHERE WINAME=:WI_NAME order by Security_Sr_No";
		params = "WI_NAME=="+wiName;
		

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		logger.info("\n Input Xml For Get "+table_name+"  Data"+inputXMLstate);

		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		logger.info("Output Xml For Get "+table_name+" Data"+outputXMLstate);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLstate));
		mainCodeValuestate = xmlParserData.getVal("MainCode");
		String recordsArray="";
		String tempRowvalues="";
		int totalRecord=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		if(mainCodeValuestate.equals("0")&&totalRecord>0)
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
				if(tempRowvalues!="")
				tempRowvalues=tempRowvalues+"|";
				int newRow=1;
				subXML = objWorkList.getVal("Record");
				objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
				for(int i=0;i<colNamesArray.length;i++)
				{
					if(tempRowvalues=="")
					{
						tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNamesArray[i]);
						newRow=0;
					}
					else if(tempRowvalues!="" && newRow==1)
					{
						tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNamesArray[i]);
						newRow=0;
					}
					else if(tempRowvalues!="" && newRow==0)
					{
						tempRowvalues=tempRowvalues+"~"+objWFCustomXmlResponse.getVal(colNamesArray[i]);
						newRow=0;
					}
				}
			}
			logger.info("temp "+ table_name+" Rowvalues "+tempRowvalues);
			if (tempRowvalues != null) {tempRowvalues=tempRowvalues.replaceAll("\\r","<br>");}
			out.clear();
			out.print(tempRowvalues);
		}
		else if(mainCodeValuestate.equals("0")&&totalRecord==0)
		{
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
	
%>