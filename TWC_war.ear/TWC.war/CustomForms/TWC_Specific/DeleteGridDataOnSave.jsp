<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="./Log.process"%>
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
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME = request.getParameter("wi_name");
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	logger.info("\n wi_name: "+WINAME);	
	String strTableName = request.getParameter("table_name");
	if (strTableName != null) {strTableName=strTableName.replace("'","");}
	String sWhere="";
	if(strTableName.equals("USR_0_TWC_DUPLICATEWORKITEMS"))
		sWhere = "WI_NAME='"+WINAME+"'";
	else	
		sWhere = "WINAME='"+WINAME+"'";
	logger.info("\n strTableName: "+strTableName);
	try
	{
		String sInputXML = "";
		String outputXML = ""; 
		
		if(!strTableName.equals(""))
		{	
			sInputXML=createAP_Delete_XML(strTableName,sWhere,sSessionId,sCabName);			
			logger.info("\nDelete InputXML For Delete Data :"+sInputXML);
			outputXML=WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			logger.info("Output Xml For Delete Data-->"+outputXML);
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString((outputXML));
			String maincode = WFCustomXmlResponseData.getVal("MainCode");
			if(!(maincode.equals("0")))
			{
				logger.info("\n Delete Data Fail");
				out.clear();
				out.println("-1");
			}
			else
			{
				logger.info("\n Delete Data Successful");	
				out.clear();
				out.println("0");
			}
		}
		else
		{
			out.clear();
			out.println("-1");
		}
	}
	catch(Exception e) 
	{
		logger.info("\n Exception In Delete Data"+e);
		out.clear();
		out.println("-1");
	}
%>