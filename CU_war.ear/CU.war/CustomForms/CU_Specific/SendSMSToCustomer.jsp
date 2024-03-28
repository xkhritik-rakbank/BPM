<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../CU_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("winame"), 1000, true) );
			String winame_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			winame_Esapi = winame_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepname"), 1000, true) );
			String workstepname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			workstepname_Esapi = workstepname_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SelectedCIF"), 1000, true) );
			String SelectedCIF_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			SelectedCIF_Esapi = SelectedCIF_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("csodecision"), 1000, true) );
			String csodecision_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			csodecision_Esapi = csodecision_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
WriteLog("Inside  Call SendEmailToCustomer.jsp");

String mainCodeCheck="0";
//String Winame=request.getParameter("winame");
String Winame=winame_Esapi;

if (Winame != null) {Winame=Winame.replace("'","''");}
//String workstepname=request.getParameter("workstepname");
String workstepname=workstepname_Esapi;		
if (workstepname != null) {workstepname=workstepname.replace("'","''");}
//String SelectedCIF=request.getParameter("SelectedCIF");
String SelectedCIF=SelectedCIF_Esapi;
if (SelectedCIF != null) {SelectedCIF=SelectedCIF.replace("'","''");}
//String csodecision=request.getParameter("csodecision");
String csodecision=csodecision_Esapi;
if (csodecision != null) {csodecision=csodecision.replace("'","''");}

String sInputXML="";
String sOutputXML="";
String EngineName=customSession.getEngineName();
String SessionId=customSession.getDMSSessionId();
String sJtsIp = customSession.getJtsIp();
int iJtsPort = customSession.getJtsPort();
String procName="NG_CU_CUST_SMS_PROC";
String param="";

try	
{	

	
		param="'"+workstepname+"','"+Winame+"','"+SelectedCIF+"','CU','"+csodecision+"'";
	
	WriteLog("\nWinamefor Sending SMS to customer: " +Winame);	
	WriteLog("\nParameters for Sending SMS to customer: " +param);
	sInputXML="<?xml version=\"1.0\"?>" +                                                           
	"<APProcedure2_Input>" +
	"<Option>APProcedure2</Option>" +
	"<ProcName>"+procName+"</ProcName>"+
	"<Params>"+param+"</Params>" +  
	"<NoOfCols>1</NoOfCols>" +
	"<SessionID>"+SessionId+"</SessionID>" +
	"<EngineName>"+EngineName+"</EngineName>" +
	"</APProcedure2_Input>";

	WriteLog("\nsInputXML for Sending SMS to customer: " +sInputXML);
//	WriteLog("sInputXML: "+sInputXML);
	sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	WriteLog("\nsOutputXML for Sending SMS to customer: " +sOutputXML);
//	WriteLog("sOutputXML: "+sOutputXML);
	if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
	{
		if(sOutputXML.indexOf("<Results>")>-1)
			mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));					
		else
			mainCodeCheck="";
	}
	else
	{
		mainCodeCheck="EXCEPTION";
	}
}
catch(Exception e) 
{
//	WriteLog("<OutPut>Error during Sending SMS to Customer.</OutPut>");
	mainCodeCheck="EXCEPTION";
}
out.clear();
out.println(mainCodeCheck);		
%>