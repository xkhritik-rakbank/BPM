<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application ?Projects
//Product / Project			 : RAKBank
//File Name					 : FetchEmiratesId.jsp
//Author                     : Shubham Ruhela
//Date written (DD/MM/YYYY)  :  15-01-2016
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------
Revision 	Date 			Author 			Description
0.90		05/02/2016		Shubham Ruhela	Initial Draft

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
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("name"), 1000, true) );
			String name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
	String query = "" ;
	String outputXML ="";
	String InputXml = "";
	//String name = request.getParameter("name");
	String name =name_Esapi;
	WriteLog("name_Esapi:"+name_Esapi );
	if (name != null) {name=name.replace("'","''");}
	String sessionID = customSession.getDMSSessionId();
	String sCabName=customSession.getEngineName();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();

	query = "select top(1) cityname from USR_0_CU_CityMaster with(nolock) where cityname like '"+name+"%'" ;
	outputXML ="";
	InputXml = getAPSelectXML(sCabName,sessionID,query);
	WriteLog("InputXml Fetch City----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	//WriteLog("outputXML Fetch City----"+outputXML);

	String Valid = "";
	if(outputXML.indexOf("<td>")>-1)
	{
		Valid=outputXML.substring(outputXML.indexOf("<td>")+"<td>".length(),outputXML.indexOf("</td>"));
	}
	
	out.clear();
	out.println(Valid);		
%>