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
	logger.info("Inside check exception raised.jsp");
	
	String sInputXML="";
	String sOutputXML="";
	String reqType = request.getParameter("reqType");
	
	
	//Extra String declared which can be required according to the request
	String WorkitemName = "";
	String remit_amt_curr ="";
	String seg = "";
	String scanDateTime = "";
	logger.info("reqType in handleajaxprocedure: "+reqType);
	if (reqType.equals("TWC_ISExceptionRaised"))
	{
		WorkitemName = request.getParameter("WorkitemName");
		if (WorkitemName != null) {WorkitemName=WorkitemName.replace("'","");}
		String H_Checklist= request.getParameter("H_Checklist");
		if (H_Checklist != null) {H_Checklist=H_Checklist.replace("'","");}
		
		try	
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"TWC_ISExceptionRaised"+"</ProcName>"+
				"<Params>"+"'"+WorkitemName+"','"+H_Checklist+"'"+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+customSession.getDMSSessionId()+"</SessionID>" +
				"<EngineName>"+customSession.getEngineName()+"</EngineName>" +
				"</APProcedure2_Input>";

			logger.info("sInputXML: TWC_IsException for WorkitemName "+WorkitemName+" : "+sInputXML);
			sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			logger.info("sOutputXML: TWC_IsException for WorkitemName "+WorkitemName+" : "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
				sOutputXML=sOutputXML.replace("# ","#");
				out.clear();
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
	
				
%>				
	