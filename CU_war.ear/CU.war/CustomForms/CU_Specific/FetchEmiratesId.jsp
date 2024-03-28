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
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("emirates_id"), 1000, true) );
			String emirates_id_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	//String emirates_id = request.getParameter("emirates_id");
	String emirates_id =emirates_id_Esapi;
	WriteLog("emirates_id_Esapi:"+emirates_id_Esapi);
	if (emirates_id != null) {emirates_id=emirates_id.replace("'","''");}
	String sCabName=customSession.getEngineName();	
	String sessionID = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String params = "";
	String query = "SELECT cif_number,name,cif_type FROM USR_0_CU_Main WHERE emiratesid=:emiratesid" ;
	params = "emiratesid=="+emirates_id;
	
	String outputXML ="";
	String individual = "Individual";
	
	String InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	
	//String InputXml = getAPSelectXML(sCabName,sessionID,query);
	WriteLog("InputXml----"+InputXml);
	try{
		outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
		outputXML = outputXML.substring(outputXML.indexOf("<Records>")+"<Records>".length(),outputXML.indexOf("</Records>"));
		if(outputXML.contains("<td>Non-Individual</td>"))
			individual = "Non-Individual";
		else
			individual = "Individual";
			
		String b = "<td><input type='radio' name='individual' value="+"'"+individual+"'"+" id="+"'"+individual+"'"+" onclick='javascript:showDivForRadio(this);'></td>";
		
		StringBuilder str = new StringBuilder(outputXML);
		str.insert(outputXML.indexOf("<tr>")+"<tr>".length(), b);		
		outputXML = str.toString();
		
		WriteLog("outputXML----"+outputXML);
	}catch(Exception e){
		WriteLog("Error----in try block WFCallBroker.execute");
	}
	
	out.clear();
	
	//outputXML="<table><tr><td>Test Acc Num</td><td>Test Creation Date</td><td>Test Expiry Date</td><td>TestCreated By</td><td>Test desc</td></tr><tr><td>Test Acc Num1</td><td>Test Creation Date1</td><td>Test Expiry Date1</td><td>TestCreated By1</td><td>Test desc1</td></tr>";			 
	
	String appendStr = "<table id='emid' border=1><tr><th>Select</th><th>CIF Number</th><th>Name</th><th>CIF Type</th></tr>";
	out.clear();
	out.println(appendStr+outputXML+"</table>");
	WriteLog(appendStr+outputXML+"</table>");
%>