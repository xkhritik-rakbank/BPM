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

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );
			String gridRow_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("gridRow Request.getparameter---> "+request.getParameter("gridRow"));
			WriteLog("gridRow Esapi---> "+gridRow_Esapi);
			
			String gridRow_Esapi_Replace = gridRow_Esapi.replace("&#x27;","'");
	        WriteLog("Integration jsp: BranchOptions esapi: after replace changes h3"+gridRow_Esapi_Replace);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("wi_name Request.getparameter---> "+request.getParameter("wi_name"));
			WriteLog("wi_name_Esapi Esapi---> "+wi_name_esapi);
			
	WriteLog("\n Inside save checklist Data Jsp");
	String gridRow = gridRow_Esapi_Replace;
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=wi_name_esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String colNames = "UID_SR_NO,WIName,Checklist_Description,Remarks,Option_checklist,Workstep";
	String values=gridRow;
	try
	{
			String sInputXML = "<?xml version=\"1.0\"?>" +
			"<APInsertExtd_Input>" +
			"<Option>APInsert</Option>" +
			"<TableName>USR_0_TF_SaveChecklistTable</TableName>" +
			"<ColName>" + colNames + "</ColName>" +
			"<Values>" + values + "</Values>" +
			"<EngineName>" + sCabName + "</EngineName>" +
			"<SessionId>" + sSessionId + "</SessionId>" +
			"</APInsertExtd_Input>";
			
			WriteLog("\nsInsert InputXML For checklist Data :"+sInputXML);
			
			String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog("\nInsert OutputXML For checklist Data :"+outputXML);
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString((outputXML));
			String maincode = WFCustomXmlResponseData.getVal("MainCode");
			WriteLog("\nmaincode-- :"+maincode);
			if(!(maincode.equals("0")))
			{
				WriteLog("\n Failed To Insert  Data");
				out.clear();
				out.println("-1");
			}
			else
			{
				WriteLog("\n  Data Inserted Successfully");	
				out.clear();
				out.println("0");
			}
	}
	catch(Exception e) 
	{
		out.clear();
		out.println("-1");
		WriteLog("\nException while inserting  Data :"+e);
	}
%>