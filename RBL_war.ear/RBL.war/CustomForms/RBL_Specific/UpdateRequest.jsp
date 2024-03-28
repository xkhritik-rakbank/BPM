<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
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

<%
		
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();

	String WINAME=wi_name_Esapi;
	
	String colName = "duplicateLogicFlag";
	String value= "YES";
	String whereclause="WI_NAME= '"+WINAME+"'";
		
	try{
	String sInputXML = "<?xml version=\"1.0\"?>" +
			"<APUpdate_Input>" +
			"<Option>APUpdate</Option>" +
			"<TableName>RB_RBL_EXTTABLE</TableName>" +
			"<ColName>" + colName + "</ColName>" +
			"<Values>'" +value+"'</Values>" +
			"<WhereClause>"+whereclause+"</WhereClause>"+
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
			"</APUpdate_Input>";
						
		logger.info("\nsUpdate InputXML For RB_RBL_EXTTABLE :"+sInputXML);
		
		String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	    logger.info("\nUpdate OutputXML For RB_RBL_EXTTABLE :"+outputXML);
	}
	catch(Exception e) {
		logger.info("\nException while inserting Duplicate workitem Grid :"+e);
	}

	out.clear();
	out.print("");
%>