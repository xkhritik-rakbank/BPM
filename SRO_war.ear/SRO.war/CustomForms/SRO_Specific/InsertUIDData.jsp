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
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );
			String gridRow_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("gridRow Request.getparameter---> "+request.getParameter("gridRow"));
			WriteLog("gridRow Esapi---> "+gridRow_Esapi);
			gridRow_Esapi = gridRow_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WSNAME Request.getparameter---> "+request.getParameter("WSNAME"));
			WriteLog("WSNAME Esapi---> "+WSNAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("wi_name Request.getparameter---> "+request.getParameter("wi_name"));
			WriteLog("wi_name Esapi---> "+wi_name_Esapi);

	WriteLog("\n Inside Insert UID Data Jsp");
	String gridRow = gridRow_Esapi;
	gridRow=gridRow.replace("'","''");
	gridRow=gridRow.replace("ENSQOUTES","'");
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String WSNAME=WSNAME_Esapi;
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
	String colNames = "UID_SR_NO,WINAME,UID,INITIATOR_REMARKS,MAKER_REMARKS,CHECKER_REMARKS";
	if (gridRow != null) {gridRow=gridRow.replace("'","");}
	String values=gridRow;
	try
	{
			String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"SRO_InsertUIDDetails"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

			WriteLog("sInputXML: SRO_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
			String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog("sOutputXML: SRO_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
				WriteLog("Status: SRO_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
				out.clear();
				out.print("0");
			}
	}
	catch(Exception e) 
	{
		out.clear();
		out.println("-1");
		WriteLog("\nException while inserting UID Data :"+e);
	}
%>