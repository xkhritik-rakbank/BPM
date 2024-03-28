<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank RAO
//Module                     : Request-Screen Form Painitng
//File Name					 : RejectReasonsUpdate.jsp          
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 31 oct 2017
//Description                : To update reject reasons in table
//---------------------------------------------------------------------------------------------------->

<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
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

<HTML>
 <head>
	<script> alert("Hello"); </script>
 </head>

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<h1>Hello</h1>

<%

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Winame"), 1000, true) );
			String Winame_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Wsname"), 1000, true) );
			String Wsname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Rejectreason"), 1000, true) );
			String Rejectreason_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("username"), 1000, true) );
			String username_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
	logger.info("Inside  RejectReasonsUpdate.jsp");
	String mainCodeCheck="0";
	
	String Wsname=Wsname_Esapi;
	String Winame=Winame_Esapi;
	
	String Rejectreason=Rejectreason_Esapi;
	String username=username_Esapi;
	String sInputXML="";
	String sOutputXML="";
	String EngineName=customSession.getEngineName();
	String SessionId=customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String procName="RMT_RejectReasonsUpdate";
	String param="";
	String Query="";
	
	logger.info("Wsname " +Wsname);
	logger.info("Winame " +Winame);
	logger.info("Rejectreason " +Rejectreason);
	logger.info("username " +username);
	
	
	try	
	{	
	
	    param="'"+Wsname+"','"+Winame+"','"+Rejectreason+"','"+username+"'";
			logger.info("Parameter " +param);
        sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName+"</ProcName>"+
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+SessionId+"</SessionID>" +
				"<EngineName>"+EngineName+"</EngineName>" +
				"</APProcedure2_Input>";

				logger.info("sInputXML: "+sInputXML);
				sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				logger.info("sOutputXML: "+sOutputXML);
				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));					
				}
				else
				{
					
				}
	}
	catch(Exception e) 
	{
		logger.info("<OutPut>Error during custom call</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.println(mainCodeCheck+"~");		
%>



