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

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
	WriteLog("\n Inside Insert InsertChecklistData Jsp");
	String gridRow = request.getParameter("gridRow");
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=request.getParameter("WINAME");
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	String WSNAME=request.getParameter("WSNAME");
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
	
	if (gridRow != null) {gridRow=gridRow.replace("'","");}
	if (gridRow != null) {gridRow=gridRow.replace("ENCODEDAND","&");}
	if (gridRow != null) {gridRow=gridRow.replace("ENCPERCENTAGE","%");}
	
	String values=gridRow;
	WriteLog("values For InsertChecklistData for WINAME "+WINAME+" :"+values);
	
	
	try	
	{
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"OECD_InsertChecklistDetails"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

		WriteLog("sInputXML: OECD_InsertChecklistDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("sOutputXML: OECD_InsertChecklistDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			WriteLog("Status: OECD_InsertChecklistDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
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