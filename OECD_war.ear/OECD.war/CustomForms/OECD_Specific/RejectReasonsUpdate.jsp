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

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<HTML>
 <head>
	<script> alert("Hello"); </script>
 </head>

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<h1>Hello</h1>

<%
	WriteLog("Inside  RejectReasonsUpdate.jsp");
	String mainCodeCheck="0";
	
	String Wsname=request.getParameter("Wsname");
	String Winame=request.getParameter("Winame");
	
	String Rejectreason=request.getParameter("Rejectreason");
	String username=request.getParameter("username");
	String sInputXML="";
	String sOutputXML="";
	String EngineName=customSession.getEngineName();
	String SessionId=customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String procName="RAO_RejectReasonsUpdate";
	String param="";
	String Query="";
	
	WriteLog("Wsname " +Wsname);
	WriteLog("Winame " +Winame);
	WriteLog("Rejectreason " +Rejectreason);
	WriteLog("username " +username);
	
	
	try	
	{	
	
	    param="'"+Wsname+"','"+Winame+"','"+Rejectreason+"','"+username+"'";
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
				sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				WriteLog("sOutputXML: "+sOutputXML);
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
		WriteLog("<OutPut>Error during custom call</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.println(mainCodeCheck+"~");		
%>



