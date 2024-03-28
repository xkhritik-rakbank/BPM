<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : SRO         
//File Name					 : loadUIDDetails.jsp          
//Author                     : Sajan
// Date written (DD/MM/YYYY) : 12-10-2018
//Description                : Populating drop down values
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
<%@ include file="../SRO_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );
			String WI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("WI_NAME Request.getparameter---> "+request.getParameter("WI_NAME"));
			WriteLog("WI_NAME Esapi---> "+WI_NAME_Esapi);		

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
		String wiName=WI_NAME_Esapi;
		if (wiName != null) {wiName=wiName.replace("'","''");}
		
		String[] colNames = {"UID","INITIATOR_REMARKS","MAKER_REMARKS","CHECKER_REMARKS"};
		
		Query2 = "SELECT UID,INITIATOR_REMARKS,MAKER_REMARKS,CHECKER_REMARKS FROM USR_0_SRO_UID_DTLS_GRID with (nolock) WHERE WINAME=:WI_NAME ORDER BY UID_SR_NO";
		params = "WI_NAME=="+wiName;

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput Xml For Get UID Data -- "+inputXMLstate);
	
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		WriteLog("Output Xml For Get UID Data---- "+outputXMLstate);

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
					for(int i=0;i<colNames.length;i++)
					{
						//WriteLog("Sajan "+i+"tempRowvalues "+tempRowvalues+" columns value "+objWFCustomXmlResponse.getVal(colNames[i])+" newRow is "+newRow);
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
			WriteLog("temp UID Rowvalues -- "+tempRowvalues);
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
%>