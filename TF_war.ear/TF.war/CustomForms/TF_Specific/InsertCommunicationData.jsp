<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TF_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: wi_name_Esapi: "+wi_name_Esapi);
			WriteLog("Integration jsp: wi_name_Esapi get: "+request.getParameter("wi_name"));
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );
			String gridRow_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: gridRow_Esapi: "+gridRow_Esapi);
			WriteLog("Integration jsp: gridRow_Esapi  Request.getParameter: "+request.getParameter("gridRow"));
			
			String gridRow_Esapi_Replace = gridRow_Esapi.replace("&#x2f;","/");
			gridRow_Esapi_Replace=gridRow_Esapi_Replace.replace("&#x3a;",":");			
	        WriteLog("Integration jsp: BranchOptions esapi: after replace changes h3"+gridRow_Esapi_Replace);

	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	WriteLog("\n Inside Insert Communication Data Jsp for WINAME: "+WINAME);	
	String gridRow = gridRow_Esapi_Replace;
	gridRow=gridRow.replace("'","''");
	WriteLog("\n Inside Insert Communication Data Jsp for gridRow: before decode "+gridRow);
	gridRow=gridRow.replace("ENCODEDAND","&");
	gridRow=gridRow.replace("ENSQOUTES","'");
	WriteLog("\n Inside Insert Communication Data Jsp for gridRow: after decode "+gridRow);
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	
	String colNames = "COMMUNICATION_ID,WINAME,MODE_OF_COMMUNICATION,COMMUNICATION_DATE,COMMUNICATION_TIME,DESCRIPTION_COMM,CURRENT_DATE_COMM";
	String values=gridRow;
	try
	{
			String sInputXML = "<?xml version=\"1.0\"?>" +
			"<APInsertExtd_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>USR_0_TF_COMMUNICATION_DTLS_GRID</TableName>" +
			"<ColName>" + colNames + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
			"</APInsertExtd_Input>";
			
			WriteLog("\nsInsert InputXML For Communication Data for WINAME "+WINAME+" : \n"+sInputXML);
			
			for (int i=0; i<3; i++)
			{
				String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				WriteLog("\nInsert OutputXML For Communication Data for WINAME "+WINAME+" : \n"+outputXML);
				WFCustomXmlResponseData=new WFCustomXmlResponse();
				WFCustomXmlResponseData.setXmlString(outputXML);
				String maincode = WFCustomXmlResponseData.getVal("MainCode");
				if(!(maincode.equals("0")))
				{
					WriteLog("\n Failed To Insert Communication Data for WINAME "+WINAME);
					out.clear();
					out.println("-1");
				}
				else
				{
					WriteLog("\n Communication Data Inserted Successfully for WINAME "+WINAME);	
					out.clear();
					out.println("0");
					break;
				}
			}
	}
	catch(Exception e) 
	{
		out.clear();
		out.println("-1");
		WriteLog("\nException while inserting Invoice Data for WINAME "+WINAME+" : Exception is : "+e);
	}
%>