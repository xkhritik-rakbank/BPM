<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="Log.process"%>
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
WriteLog("inside CIF Related Grid ");
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
		String wiName=request.getParameter("WI_NAME");
		if (wiName != null) {wiName=wiName.replace("'","''");}
		String[] colNames = {"CIF_SR_NO","WINAME","CIF_Related_WINAME","TL_NUMBER","CREATION_DATE_TIME"};

		
		Query2 = "SELECT CIF_SR_NO,WINAME,CIF_Related_WINAME,TL_NUMBER,CREATION_DATE_TIME FROM USR_0_TWC_CIF_RELATED_DTLS_GRID with (nolock) WHERE WINAME=:WI_NAME";
		params = "WI_NAME=="+wiName;

	
		
		WriteLog("Input Xml For Get CIF Related Data-- "+Query2);

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML For Winame: "+wiName+" Get CIF Related Party Data -- "+inputXMLstate);
	
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		
		WriteLog("Output Xml For Winame: "+wiName+" Get CIF Related Party Data---- "+outputXMLstate);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLstate));
		mainCodeValuestate = xmlParserData.getVal("MainCode");
		int totalRecord=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		String recordsArray="";
		String tempRowvalues="";
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
					for(int i=0;i<colNames.length;i++)
					{
						if(tempRowvalues=="")
						{
							tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
						else if(tempRowvalues!="" && newRow==1)
						{
							tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
						else if(tempRowvalues!="" && newRow==0)
						{
							tempRowvalues=tempRowvalues+"~"+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
					}
			}
			out.clear();
			out.print(tempRowvalues);
			WriteLog("tempRowvalues For Winame: "+wiName+" Get CIF Related Party Grid Data -- "+tempRowvalues);
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
%>