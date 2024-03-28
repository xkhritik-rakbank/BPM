<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../BAIS_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
		
	
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();

	String WINAME=request.getParameter("wi_name");
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	
	String colName = "duplicateLogicFlag";
	String value= "YES";
	String whereclause="WI_NAME= '"+WINAME+"'";
		
	try{
	String sInputXML = "<?xml version=\"1.0\"?>" +
			"<APUpdate_Input>" +
			"<Option>APUpdate</Option>" +
			"<TableName>RB_TWC_EXTTABLE</TableName>" +
			"<ColName>" + colName + "</ColName>" +
			"<Values>'" +value+"'</Values>" +
			"<WhereClause>"+whereclause+"</WhereClause>"+
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
			"</APUpdate_Input>";
						
		logger.info("\nsUpdate InputXML For RB_BAIS_EXTTABLE :"+sInputXML);
		
		String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	    logger.info("\nUpdate OutputXML For RB_BAIS_EXTTABLE :"+outputXML);
	}
	catch(Exception e) {
		logger.info("\nException while inserting Duplicate workitem Grid :"+e);
	}

	out.clear();
	out.print("");
%>