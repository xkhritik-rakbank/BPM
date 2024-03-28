<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : DBOperations.jsp
//Author                     : Ankit	
// Date written (DD/MM/YYYY) : 07-Dec-2015
//Description                : Initial Header fixed form for CIF Updates
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../CU_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("FieldName"), 1000, true) );
			String FieldName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	
	String Query="";
	String inputXML="";
	String outputXML="";
	//String FieldName=request.getParameter("FieldName");
	String FieldName=FieldName_Esapi;
	WriteLog("FieldName_Esapi: "+FieldName_Esapi);
	if (FieldName != null) {FieldName=FieldName.replace("'","''");}
	String mainCodeValue="";
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;
	String subXML="";	
	String params = "";
	Query="SELECT documents FROM usr_0_cu_doc_required with(nolock) WHERE fieldname=:fieldname";
	WriteLog("\nQuery:--"+Query);
	params = "fieldname=="+FieldName;
	
	//inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
	
	 inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
	 
	outputXML = WFCustomCallBroker.execute(inputXML, sJtsIp, iJtsPort, 1);
	WriteLog("outputXML exceptions-->"+outputXML);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((outputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	
	int recordcount=0;
	recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
	String document="";
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if(document.equals(""))
			{
				document=objWorkList.getVal("documents");
			}	
			else 
			{
				WriteLog("\nUnsuccessful");
			}		
		}
	}

	out.clear();
	out.print(document);		
%>	