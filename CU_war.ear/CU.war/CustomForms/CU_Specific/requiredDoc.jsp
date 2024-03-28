<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application Projects
//Product / Project			 : RAKBank
//File Name					 : CU.jsp
//Author                     : Shubham Ruhela
//Date written (DD/MM/YYYY) :  15-01-2016
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
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
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%!
public String getAPSelectXML(String strEngineName, String strSessionId, String Query) 
{
	return "<?xml version=\"1.0\"?>"
		+ "<APSelect_Input><Option>APSelect</Option>"
		+ "<Query>" + Query + "</Query>"
		+ "<EngineName>" + strEngineName + "</EngineName>"
		+ "<SessionId>" + strSessionId + "</SessionId>"
		+ "</APSelect_Input>";
}
%>
<%			
String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("doc_field"), 1000, true) );
			String doc_field_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			doc_field_Esapi = doc_field_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("field_name"), 1000, true) );
			String field_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			field_name_Esapi = field_name_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");

String params = "";
String doc_field = doc_field_Esapi;
if (doc_field != null) {doc_field=doc_field.replace("'","''");}
String field_name =field_name_Esapi;
if (field_name != null) {field_name=field_name.replace("'","''");}
String query = "SELECT top(1) documentreq FROM usr_0_CU_requiredDoc with(nolock) WHERE field_name=:field_name";
params = "field_name=="+field_name;
String sCabName=customSession.getEngineName();	
String sessionID = customSession.getDMSSessionId();
String sJtsIp = customSession.getJtsIp();
int iJtsPort = customSession.getJtsPort();

//String InputXml = getAPSelectXML(sCabName,sessionID,query);

String InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";

String outputXML ="";
WriteLog("InputXml for usr_0_CU_requiredDoc:"+InputXml);
try{
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);	
	WriteLog("outputXML for usr_0_CU_requiredDoc:"+outputXML);	
	outputXML = outputXML.substring(outputXML.indexOf("<documentreq>")+"<documentreq>".length(),outputXML.indexOf("</documentreq>"));
}catch(Exception e){
}

out.clear();
out.println(outputXML);
%>

