<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
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

<%
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );    
	String gridRow = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");	
	//if (gridRow != null) {gridRow=gridRow.replace("'","''");}
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );    
	String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	//if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	WriteLog("\n:::::::::::::::: Insert :::::"+gridRow);
	
	String colNames = "DUPLICATEWI_NAME,IntroductionDateAndTime,intoducedBy,SOLID,WI_NAME";
	String values = gridRow;
	WriteLog("\nvalues in jsp "+values);
	
	try{
	String sInputXML = "<?xml version=\"1.0\"?>" +
			"<APInsertExtd_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>USR_0_SRB_DUPLICATEWORKITEMS</TableName>" +
			"<ColName>" + colNames + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
			"</APInsertExtd_Input>";
			
		WriteLog("\nsInsert InputXML For USR_0_SRB_DUPLICATEWORKITEMS :"+sInputXML);
		
		String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	    WriteLog("\nInsert OutputXML For USR_0_SRB_DUPLICATEWORKITEMS :"+outputXML);
	}
	catch(Exception e) {
		WriteLog("\nException while inserting Duplicate workitem Grid :"+e);
	}

	out.clear();
	out.print("");
%>