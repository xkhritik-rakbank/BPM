<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../SRB_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%!
	public String createAP_Delete_XML(String tableName,String sWhere,String sSessionId,String sCabname)
	{  
	
		String sInputXML = "<?xml version=\"1.0\"?>"
			+ "<APDelete_Input><Option>APDelete</Option>"
			+ "<TableName>" + tableName + "</TableName>"
			+ "<WhereClause>" + sWhere + "</WhereClause>"
			+ "<EngineName>" + sCabname + "</EngineName>"
			+ "<SessionId>" + sSessionId + "</SessionId>"
			+ "</APDelete_Input>";

		return sInputXML;
	}
%>
<%
	WriteLog("\n inside deleteajaxrequest.jsp ");
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	WriteLog("\n wi_name: "+wi_name);	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );    
	String wi_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	String sWhere = "WI_NAME='"+wi_name+"'";
	if (sWhere != null) {sWhere=sWhere.replace("'","''");}
	try
	{
		String sInputXML = "";
		String outputXML = ""; 
		String strTableName = "";
		
		strTableName="USR_0_SRB_DUPLICATEWORKITEMS";
		
		if(!strTableName.equals(""))
		{	
			sInputXML=createAP_Delete_XML(strTableName,sWhere,sSessionId,sCabName);			
			WriteLog("\nDelete InputXML For USR_0_SRB_DUPLICATEWORKITEMS :"+sInputXML);
		
			outputXML=WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			WriteLog("\nDelete OutputXML For USR_0_SRB_DUPLICATEWORKITEMS :"+outputXML);
		}
	}
	catch(Exception e) {
		WriteLog("\nException while Duplicate Workitem Grid :"+e);
	}
	out.clear();
	out.print("");
%>