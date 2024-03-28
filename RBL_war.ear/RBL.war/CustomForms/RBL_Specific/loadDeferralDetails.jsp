<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : RBL         
//File Name					 : LoadDeferralData.jsp
//Author                     : Sajan Soda
// Date written (DD/MM/YYYY) : 17-Jan-2019
//Description                : Loading UID data
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
<%@ include file="../RBL_Specific/Log.process"%>
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

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );
			String WI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
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
		
		String[] colNames = {"Document_Type","Approving_Authority","Deferral_Exp_Date","Status"};
		
		Query2 = "SELECT Document_Type,Approving_Authority,Deferral_Exp_Date,Status FROM USR_0_RBL_Deferral_Grid with (nolock) WHERE WINAME=:WI_NAME";
		params = "WI_NAME=="+wiName;

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		logger.info("\nInput Xml For Get UID Data for WINAME "+wiName+" -- "+inputXMLstate);
	
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		logger.info("Output Xml For Get UID Data for WINAME "+wiName+" ---- "+outputXMLstate);

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
			logger.info("temp Deferral Rowvalues -- "+tempRowvalues);
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