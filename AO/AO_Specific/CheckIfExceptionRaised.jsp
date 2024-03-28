<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : CheckIfExcptionRaised.jsp
//Author                     : Prateek Garg
// Date written (DD/MM/YYYY) : 29-Mar-2014
//Description                : File to update wi_name in External table
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
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

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->


<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WorkitemName"), 1000, true) );
			String WorkitemName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WorkitemName_Esapi: "+WorkitemName_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CheckFor"), 1000, true) );
			String CheckFor_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: CheckFor_Esapi: "+CheckFor_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("H_Checklist"), 1000, true) );
			String H_Checklist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: H_Checklist_Esapi: "+H_Checklist_Esapi);

	WriteLog("Inside check exception raised.jsp");
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	String WorkitemName=WorkitemName_Esapi;
	String CheckFor=CheckFor_Esapi;
	String sInputXML="";
	String sOutputXML="";
	String EngineName=wDSession.getM_objCabinetInfo().getM_strCabinetName();
	String SessionId=wDSession.getM_objUserInfo().getM_strSessionId();
	String procName="AO_ISExceptionRaised";
	String H_Checklist=H_Checklist_Esapi;
	String param="";
	String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	//int iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
	int iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
	
	try	
	{	
		if(CheckFor.equalsIgnoreCase("OPS_Checker"))
		{
			param="'"+WorkitemName+"','"+H_Checklist+"'";
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
				sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("sOutputXML: "+sOutputXML);
				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));
					
				}
				else
				{
					
				}	
		}
		else if(CheckFor.equalsIgnoreCase("OPS_Maker"))
		{
			param="'"+WorkitemName+"','"+H_Checklist+"'";
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
				sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("sOutputXML: "+sOutputXML);
				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));
					
				}
				else
				{
					
				}	
		}
		else if(CheckFor.equalsIgnoreCase("CB-WC Maker"))
		{
			param="'"+WorkitemName+"','"+CheckFor+"','"+H_Checklist+"'";
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>AO_ISExceptionRaisedCurrently</ProcName>"+
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+SessionId+"</SessionID>" +
				"<EngineName>"+EngineName+"</EngineName>" +
				"</APProcedure2_Input>";

				WriteLog("sInputXML: "+sInputXML);
				sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("sOutputXML: "+sOutputXML);
				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));
					
				}
				else
				{
					
				}		
			
		}
		else if(CheckFor.equalsIgnoreCase("CB-WC Checker"))
		{
			param="'"+WorkitemName+"','"+CheckFor+"','"+H_Checklist+"'";
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>AO_ISExceptionRaisedCurrently</ProcName>"+
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+SessionId+"</SessionID>" +
				"<EngineName>"+EngineName+"</EngineName>" +
				"</APProcedure2_Input>";

				WriteLog("sInputXML: "+sInputXML);
				sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("sOutputXML: "+sOutputXML);
				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				{
					mainCodeCheck=sOutputXML.substring(sOutputXML.indexOf("<Results>")+"<Results>".length(),sOutputXML.indexOf("</Results>"));
					
				}
				else
				{
					
				}		
			
		}
	}
	catch(Exception e) 
	{
		WriteLog("<OutPut>Error during custom update</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.println(mainCodeCheck+"~");		
%>



