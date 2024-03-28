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

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );
	String gridRow_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	logger.info("SaveDeferralData, gridRow_Esapi: "+gridRow_Esapi);
	gridRow_Esapi = gridRow_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
	logger.info("SaveDeferralData, gridRow_Esapi after handling special char: "+gridRow_Esapi);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
	String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
	logger.info("\n Inside SaveDeferralData Jsp");
	String gridRow = gridRow_Esapi;
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String colNames = "Deferral_SR_No,WINAME,Document_Type,Approving_Authority,Deferral_Exp_Date,Status";
	String values=gridRow;
	if (values.contains("'','','',''"))
	{
		// row is blank, hence not inserting blank row
		out.clear();
		out.println("1");
	}
	else
	{
		try
		{
				String sInputXML = "<?xml version=\"1.0\"?>" +
				"<APInsertExtd_Input>" +
				"<Option>APInsert</Option>" +
				"<TableName>USR_0_RBL_Deferral_Grid</TableName>" +
				"<ColName>" + colNames + "</ColName>" +
				"<Values>" + values + "</Values>" +
				"<EngineName>" + sCabName + "</EngineName>" +
				"<SessionId>" + sSessionId + "</SessionId>" +
				"</APInsertExtd_Input>";
				
				logger.info("\nsInsert InputXML For UID Data for WINAME "+WINAME+" :"+sInputXML);
				
				String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				logger.info("\nInsert OutputXML For UID Data for WINAME "+WINAME+" :"+outputXML);
				WFCustomXmlResponseData=new WFCustomXmlResponse();
				WFCustomXmlResponseData.setXmlString((outputXML));
				String maincode = WFCustomXmlResponseData.getVal("MainCode");
				if(!(maincode.equals("0")))
				{
					logger.info("\n Failed To Insert UID Data");
					out.clear();
					out.println("-1");
				}
				else
				{
					logger.info("\n UID Data Inserted Successfully");	
					out.clear();
					out.println("0");
				}
		}
		catch(Exception e) 
		{
			out.clear();
			out.println("-1");
			logger.info("\nException while inserting UID Data :"+e);
		}
	}
%>