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
	logger.info("Insert Account Data Jsp,gridRow_Esapi: "+gridRow_Esapi);
	gridRow_Esapi = gridRow_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
	logger.info("Insert Account Data Jsp,gridRow_Esapi after handling: "+gridRow_Esapi);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
	String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
	String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
	logger.info("\n Inside Insert Account Data Jsp");
	String gridRow = gridRow_Esapi;
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String WSNAME=WSNAME_Esapi;
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
	String colNames = "UID_SR_NO,WINAME,UID,REMARKS";
	if (gridRow != null) {gridRow=gridRow.replace("'","");}
	String values=gridRow;
	try	
	{
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"RBL_InsertUIDDetails"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

		logger.info("sInputXML: RBL_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		logger.info("sOutputXML: RBL_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			logger.info("Status: RBL_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e) 
	{
		out.clear();
		out.println("-1");
		logger.info("\nException while inserting UID Data :"+e);
	}
%>