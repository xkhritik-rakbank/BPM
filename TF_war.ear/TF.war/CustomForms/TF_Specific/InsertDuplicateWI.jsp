<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TF_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
		
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );
			String gridRow_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: gridRow_Esapi: "+gridRow_Esapi);
			gridRow_Esapi = gridRow_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
		    WriteLog("after replace gridRow_Esapi: "+gridRow_Esapi);
			
	String gridRow = gridRow_Esapi;
	//if (gridRow != null) {gridRow=gridRow.replace("'","''");}
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();

	WriteLog("\n:::::::::::::::: Insert in DUPLICATEWORKITEMS table:::::"+gridRow);
	
	String colNames = "IntoducedAt,Application_Date,Product_Category,Product_Type,intoducedBy,Amount,Currency,DUPLICATEWI_NAME,WINAME,CIF_ID";
	String values = gridRow;
	WriteLog("\nvalues in jsp "+values);
	
	try{
	String sInputXML = "<?xml version=\"1.0\"?>" +
			"<APInsertExtd_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>USR_0_TF_DUPLICATEWORKITEMS</TableName>" +
			"<ColName>" + colNames + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
			"</APInsertExtd_Input>";
			
		WriteLog("\nsInsert InputXML For USR_0_TF_DUPLICATEWORKITEMS :"+sInputXML);
		
		String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	    WriteLog("\nInsert OutputXML For USR_0_TF_DUPLICATEWORKITEMS :"+outputXML);
		
		out.clear();
		out.print("Inserted");
	}
	catch(Exception e) {
		WriteLog("\nException while inserting Duplicate workitem Grid :"+e);
		out.clear();
		out.println("-1");
	}
	
%>