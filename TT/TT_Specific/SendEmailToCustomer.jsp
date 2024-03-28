<%@ include file="ajaxlog.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<HTML>
<head></head>
<BODY>
<%
	WriteLog("Inside  Call SendEmailToCustomer.jsp");
	
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("winame"), 1000, true) );
			String winame_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepname"), 1000, true) );
			String workstepname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("payOrderId"), 1000, true) );
			String payOrderId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	
	String Winame=winame_Esapi;
	String workstepname=workstepname_Esapi;
	String payOrderId= payOrderId_Esapi;
	WriteLog("payOrderId......"+payOrderId);
	String sInputXML="";
	String sOutputXML="";
	String EngineName= wDSession.getM_objCabinetInfo().getM_strCabinetName();
	String SessionId = wDSession.getM_objUserInfo().getM_strSessionId();
	//String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	//int iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
	String procName="NG_TT_CUST_EMAIL_PROC";
	String param="";
	
	try	
	{	
	
	    param="'"+workstepname+"','"+Winame+"','"+payOrderId+"','TT'";
		WriteLog("Parameter " +param);
        sInputXML="<?xml version=\"1.0\"?>" +                                                           
		"<APProcedure2_Input>" +
		"<Option>APProcedure2</Option>" +
		"<ProcName>"+procName+"</ProcName>"+
		"<Params>"+param+"</Params>" +  
		"<NoOfCols>1</NoOfCols>" +
		"<SessionID>"+SessionId+"</SessionID>" +
		"<EngineName>"+EngineName+"</EngineName>" +
		"</APProcedure2_Input>";

		WriteLog("sInputXML: "+sInputXML);
		//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog("sOutputXML: "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));					
		}
		else
		{
			mainCodeCheck="EXCEPTION";
		}
	}
	catch(Exception e) 
	{
		WriteLog("<OutPut>Error during custom call</OutPut>");
		mainCodeCheck="EXCEPTION";
	}
%>
</BODY>
</HTML>
<%
out.clear();
out.println(mainCodeCheck);		
%>