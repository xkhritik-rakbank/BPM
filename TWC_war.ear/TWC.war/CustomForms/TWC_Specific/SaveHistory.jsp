
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

<%
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();		
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WSNAME="" ,WINAME="",WIDATA="",rejectReasons="",user_name="",decision="",remarks="",entrydatetime="";
	String mainCodeValue="";
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlResponse objXmlParser=null;
	String subXML="";
	String sInputXML="";
	String sOutputXML="";
	String mainCodeData="";
	String Query="";
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	Date date = new Date();
	String hist_table="";
	
	try{
		WINAME=request.getParameter("WINAME");
		if (WINAME != null) {WINAME=WINAME.replace("'","");}
		WSNAME=request.getParameter("WSNAME");
		WSNAME = WSNAME.trim();
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
		WIDATA=request.getParameter("WIDATA");
		decision=request.getParameter("Decision");
		if (decision != null) {decision=decision.replace("'","");}
		remarks=request.getParameter("Remarks");
		if (remarks != null) {remarks=remarks.replace("'","");}
		rejectReasons=request.getParameter("rejectReasons");
		if (rejectReasons != null) {rejectReasons=rejectReasons.replace("'","");}
		 
		if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		
		if (remarks.contains("AMPNDCHAR"))	
			remarks=remarks.replace("AMPNDCHAR","&");
		if (remarks.contains("PPPERCCCENTT"))	
			remarks=remarks.replace("PPPERCCCENTT","%");
		if (remarks.contains("PLUSCHAR"))
			remarks=remarks.replace("PLUSCHAR","+");
		//if (remarks != null) {remarks=remarks.replace("ENSQOUTES","'");} // it will save as it is, replaced when decision history will be viewed
		if (remarks.contains("<br>"))
			remarks=remarks.replace("<br>",(char)(13)+"");
		
		logger.info("Inside SaveHistory.jsp");
		if(true)
		{
			logger.info("decision="+decision);
			hist_table="usr_0_twc_wihistory";
			String colname2="decision,actiondatetime,remarks,username,RejectReasons";
			logger.info("rejectReasons......="+rejectReasons);
			String colvalues2="'"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','"+customSession.getUserName()+"','"+rejectReasons+"'" ;
			logger.info("colvalues2 From SaveHistory colvalues2="+colvalues2);
			
				sInputXML = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>" + hist_table + "</TableName>" +
					"<ColName>" + colname2 + "</ColName>" +
					"<Values>" + colvalues2 + "</Values>" +
					"<WhereClause>" + "WINAME='"+WINAME+"' and wsname='" +WSNAME+"' and actiondatetime is null" + "</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";
				
				logger.info("Updating History for WINAME "+WINAME+" , at Workstep: "+WSNAME+" : "+sInputXML);
				sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				logger.info("sOutputXML Updating History for WINAME "+WINAME+" , at Workstep: "+WSNAME+" : "+sOutputXML);
			
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}

%>