<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>

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
			WriteLog("Integration jsp: gridRow_Esapi: "+gridRow_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: wi_name_Esapi: "+wi_name_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: WSNAME_Esapi: "+WSNAME_Esapi);
	WriteLog("\n Inside Insert Account Data Jsp");
	String gridRow = gridRow_Esapi;
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	String WSNAME=WSNAME_Esapi;
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
	String colNames = "SELECT_ID,QUERY_NAME,CREDIT_REMARKS,BUSINESS_REMARKS,WINAME";
	
	if (gridRow != null) {
	gridRow=gridRow.replace("'","");
	
	gridRow=gridRow.replace("AMPNDCHAR","&amp;");
	gridRow=gridRow.replace("PPPERCENTTT","&per;");
	gridRow=gridRow.replace(">","&gt;");
	gridRow=gridRow.replace("<","&lt;");

	}
	
	String values=gridRow;
	WriteLog("values For UID Data for WINAME "+WINAME+" :"+values);
	
	
	try	
	{
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"TF_InsertQueryDetails"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

		WriteLog("sInputXML: TF_InsertQueryDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("sOutputXML: TF_InsertQueryDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			WriteLog("Status: TF_InsertQueryDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}catch(Exception e){
		out.clear();
		out.print("-1");
	}
	
%>