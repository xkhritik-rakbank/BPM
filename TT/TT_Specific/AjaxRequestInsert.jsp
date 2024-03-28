<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wfsession"	class="com.newgen.wfdesktop.session.WFSession" scope="session" />

<%
	WriteLog("Inside AjaxRequestInsert.jsp");
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepname"), 1000, true) );
			String workstepname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("winame"), 1000, true) );
			String winame_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	
	String wsname = workstepname_Esapi;
	String reqType = reqType_Esapi;
	String winame = winame_Esapi;
	String sCabName= wfsession.getEngineName();	
	String sSessionId = wfsession.getSessionId();	
	String sJtsIp = wfsession.getJtsIp();
	int iJtsPort = wfsession.getJtsPort();
	String userName = wfsession.getStrPersonalName()+" "+wfsession.getUserFamilyName();
	userName = userName.trim();

	
	String sOutputXML = "";
	String sInputXML = "";
	String colName= "";
	String values = "";
	String tableName = "";
	Date date = new Date();
	DateFormat dateFormat1 = new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss");
	
	
	if (reqType.equals("CallBackAutoRaise"))
	{
		WriteLog("Call Back Required ,raising exception");
		String excpCode = "005";
		tableName = "usr_0_TT_exception_history";
		colName = "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME";
		values ="'"+winame+"','"+excpCode+"','System','"+userName+"','Raised','"+dateFormat1.format(date)+"'";
		
		sInputXML = "<?xml version=\"1.0\"?>" +
		"<APInsert_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>"+ tableName +"</TableName>" +
			"<ColName>" + colName + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
		"</APInsert_Input>";

		WriteLog("History:AutoRaise Input "+sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("History: AutoRaise Output"+sOutputXML);
	}
	else if (reqType.equals("ComplainceAutoRaise"))
	{
		WriteLog("Complaince Required ,raising exception");
		String excpCode = "006";
		tableName = "usr_0_TT_exception_history";
		colName = "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME";
		values =  "'"+winame+"','"+excpCode+"','System','"+userName+"','Raised','"+dateFormat1.format(date)+"'";
		
		sInputXML = "<?xml version=\"1.0\"?>" +
		"<APInsert_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>usr_0_TT_exception_history</TableName>" +
			"<ColName>" + colName + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
		"</APInsert_Input>";

		WriteLog("History:AutoRaise Input "+sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("History: AutoRaise Output"+sOutputXML);
	}
	else if (reqType.equals("SignAutoRaise"))
	{
		WriteLog("Call Back Required ,raising exception");
		String excpCode = "003";
		tableName = "usr_0_TT_exception_history";
		colName = "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME";
		values ="'"+winame+"','"+excpCode+"','System','"+userName+"','Raised','"+dateFormat1.format(date)+"'";
		
		sInputXML = "<?xml version=\"1.0\"?>" +
		"<APInsert_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>"+ tableName +"</TableName>" +
			"<ColName>" + colName + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
		"</APInsert_Input>";

		WriteLog("History:AutoRaise checker sign Input "+sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("History: AutoRaise checker sign Output"+sOutputXML);
	}
%>
