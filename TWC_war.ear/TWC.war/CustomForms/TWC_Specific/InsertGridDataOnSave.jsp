<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="./Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
	logger.info("\n Inside Insert Grid Data ");
	String gridRow = request.getParameter("gridRow");
	if (gridRow != null) {gridRow=gridRow.replace("wait","").replace("for","").replace("delay","");}
	if (gridRow != null) {gridRow=gridRow.replace("WAIT","").replace("FOR","").replace("Delay","");}
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=request.getParameter("wi_name");
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	String table_name=request.getParameter("table_name");
	if (table_name != null) {table_name=table_name.replace("'","");}
	String colNames = request.getParameter("column_names");
	if (colNames != null) {colNames=colNames.replace("'","");}
	
	
	try
	{
		String sInputXML = "<?xml version=\"1.0\"?>" +
		"<APInsertExtd_Input>" +
		"<Option>APInsert</Option>" +
		"<TableName>"+table_name+"</TableName>" +
		"<ColName>" + colNames + "</ColName>" +
		"<Values>" + gridRow + "</Values>" +
		"<EngineName>" + sCabName + "</EngineName>" +
		"<SessionId>" + sSessionId + "</SessionId>" +
		"</APInsertExtd_Input>";
		
		logger.info("\nsInsert InputXML For Data :"+sInputXML);
		
		String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		logger.info("\nInsert OutputXML For Data :"+outputXML);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputXML));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");
		if(!(maincode.equals("0")))
		{
			logger.info("\n Failed To Insert Data");
			out.clear();
			out.println("-1");
		}
		else
		{
			logger.info("\n Data Inserted Successfully");	
			out.clear();
			out.println("0");
		}
	}
	catch(Exception e) 
	{
		out.clear();
		out.println("-1");
		logger.info("\nException while inserting Data :"+e);
	}
%>