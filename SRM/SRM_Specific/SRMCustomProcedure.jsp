<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : SRMCustomUpdate.jsp
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
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<%@ include file="SaveHistory.jsp"%>

<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%
	WriteLog("Inside SRMCustomProc.jsp");
	boolean blockCardNoInLogs=true;
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	String WINAME=request.getParameter("WINAME");
	String procName="";
	String param="";
	String CallFor=request.getParameter("CallFor");
		
	if(CallFor.equalsIgnoreCase("AdvanceSearchFields"))
	{
		procName="SRM_UPDATE_ADVANCE_SEARCH_FIELDS";
		param="'"+WINAME+"'";
	}
	try	
	{
	
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>"+procName+"</ProcName>"+
						"<EngineName>"+wfsession.getEngineName()+"</EngineName>" +
						"<SessionID>"+wfsession.getSessionId()+"</SessionID>" +					                                      
						"<Params>"+param+"</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"</APProcedure2_Input>";
	
		WriteLog(sInputXML);
		String sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
		WriteLog("sOutputXML :"+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			WriteLog("Procedure call successful in SRMCustomProc.jsp");
		}
		else
		{
			WriteLog("Problem during calling in SRMCustomProc.jsp");
			mainCodeParser=new XMLParser();
			mainCodeParser.setInputXML(sOutputXML);
			mainCodeCheck = mainCodeParser.getValueOf("MainCode");
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



