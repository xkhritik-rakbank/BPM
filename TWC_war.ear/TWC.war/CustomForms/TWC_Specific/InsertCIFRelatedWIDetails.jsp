<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="Log.process"%>
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
	WriteLog("\n Inside Insert CIF Related Data Jsp");
	String gridRow = request.getParameter("gridRow");
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=request.getParameter("wi_name");
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	String WSNAME=request.getParameter("WSNAME");
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
	
	if (gridRow != null) {
	gridRow=gridRow.replace("'","");
	gridRow=gridRow.replace("AMPNDCHAR","&amp;");
	gridRow=gridRow.replace("PPPERCENTTT","&per;");
	gridRow=gridRow.replace(">","&gt;");
	gridRow=gridRow.replace("<","&lt;");
	gridRow=gridRow.replace("PIPECHAR","&pipe;");
	}
	
	String values=gridRow;
	WriteLog("values For Related Parties Data for WINAME "+WINAME+" :"+values);
	
	
	try	
	{
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"TWC_InsertCIFRelatedGridData"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

		WriteLog("sInputXML: InsertCIFRelatedGridData for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("sOutputXML: InsertCIFRelatedGridData for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			WriteLog("Status: InsertCIFRelatedGridData for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
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