<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../RBL_Specific/Log.process"%>
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
	logger.info("\n inside deleteajaxrequest.jsp ");
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	logger.info("\n wi_name: "+request.getParameter("wi_name"));	
	String sWhere = "WI_NAME='"+request.getParameter("wi_name")+"'";
	
	
	logger.info("SWhere is "+sWhere);
	try
	{
		String sInputXML = "";
		String outputXML = ""; 
		String strTableName = "";
		
		strTableName="USR_0_RBL_DUPLICATEWORKITEMS";
		
		if(!strTableName.equals(""))
		{	
			sInputXML=createAP_Delete_XML(strTableName,sWhere,sSessionId,sCabName);			
			logger.info("\nDelete InputXML For USR_0_RBL_DUPLICATEWORKITEMS :"+sInputXML);
		
			outputXML=WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			logger.info("\nDelete OutputXML For USR_0_RBL_DUPLICATEWORKITEMS :"+outputXML);
		}
	}
	catch(Exception e) {
		logger.info("\nException while Duplicate Workitem Grid :"+e);
	}
	out.clear();
	out.print("");
%>