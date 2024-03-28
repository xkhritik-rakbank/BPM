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

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
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
		
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("wi_name Request.getparameter---> "+request.getParameter("wi_name"));
			WriteLog("wi_name Esapi---> "+wi_name_Esapi);
			
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	WriteLog("\n wi_name: "+request.getParameter("wi_name"));	
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String sWhere = "WINAME='"+WINAME+"'";
	try
	{
		String sInputXML = "";
		String outputXML = ""; 
		String strTableName = "";
		strTableName="USR_0_SRO_UID_DTLS_GRID";
		if(!strTableName.equals(""))
		{	
			sInputXML=createAP_Delete_XML(strTableName,sWhere,sSessionId,sCabName);			
			WriteLog("\nDelete InputXML For Delete UID Data :"+sInputXML);
			outputXML=WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			WriteLog("Output Xml For Delete UID Data-->"+outputXML);
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString((outputXML));
			String maincode = WFCustomXmlResponseData.getVal("MainCode");
			if(!(maincode.equals("0")))
			{
				WriteLog("\n Delete UID Data Fail");
				out.clear();
				out.println("-1");
			}
			else
			{
				WriteLog("\n Delete UID Data Successfull");	
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
		WriteLog("\n Exception In Delete UID Data"+e);
		out.clear();
		out.println("-1");
	}
%>