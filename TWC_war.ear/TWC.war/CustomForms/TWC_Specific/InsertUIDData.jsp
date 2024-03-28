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
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
	logger.info("\n Inside Insert UID Data Jsp");
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
	String colNames = "UID_SR_NO,WINAME,UID,REMARKS";
	if (gridRow != null) {gridRow=gridRow.replace("'","");}
	if (gridRow != null) {gridRow=gridRow.replace("'","");}
	if (gridRow != null) {gridRow=gridRow.replace("AMPNDCHAR","&");}
	if (gridRow != null) {gridRow=gridRow.replace("CCCOMMAAA",",");}
	if (gridRow != null) {gridRow=gridRow.replace("PPPERCCCENTT","%");}
	if (gridRow != null) {gridRow=gridRow.replace("PLUSCHAR","+");}
	//if (gridRow != null) {gridRow=gridRow.replace("ENSQOUTES","'");} // its replaced in respective procedure
	if (gridRow != null) {gridRow=gridRow.replace("<br>",(char)(13)+"");}
	String values=gridRow;
	try	
	{
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"TWC_InsertUIDDetails"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

		logger.info("sInputXML: TWC_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		logger.info("sOutputXML: TWC_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			logger.info("Status: TWC_InsertUIDDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e) 
	{
		out.clear();
		out.println("-1");
		logger.info("\nException while inserting UID Data for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" :"+e);
	}
%>