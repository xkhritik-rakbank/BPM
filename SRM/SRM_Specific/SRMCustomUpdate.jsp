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

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<%@ include file="SaveHistory.jsp"%>

<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%
	WriteLog("Inside SRMCustomUpdate.jsp");
	boolean blockCardNoInLogs=true;
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	String WINAME=request.getParameter("WINAME");
	String tableName="";
	String columnName="";
	String UpdateFor=request.getParameter("UpdateFor");
	String strValues="";
	String sWhere="";
		
	if(UpdateFor.equalsIgnoreCase("ExternalTable"))
	{
		tableName="rb_srm_exttable";
		columnName="IntegrationStatus";
		strValues="'"+request.getParameter("IntegrationStatus")+"'";
		sWhere=" TEMP_WI_NAME='"+request.getParameter("TEMP_WI_NAME")+"'";
	}
	else if(UpdateFor.equalsIgnoreCase("QueueVariable"))
	{
		tableName="queuedatatable";
		columnName="var_str8";
		strValues="'"+wfsession.getUserName()+"'";
		sWhere=" ProcessInstanceId='"+request.getParameter("WorkitemName")+"'";
	}
	else if(UpdateFor.equalsIgnoreCase("CancelRequestSMS"))
	{
		tableName="rb_srm_exttable";
		columnName="smsid";
		strValues="'13'";
		sWhere=" wi_name='"+request.getParameter("WINAME")+"'";
	}
	else if(UpdateFor.equalsIgnoreCase("UpdateErrorDecision"))
	{
		if(request.getParameter("CategoryID").equals("1") && request.getParameter("SubCategoryID").equals("2"))
			tableName="usr_0_srm_tr_bt";
		else if(request.getParameter("CategoryID").equals("1") && request.getParameter("SubCategoryID").equals("4"))
			tableName="usr_0_srm_tr_ccc";
		else if(request.getParameter("CategoryID").equals("1") && request.getParameter("SubCategoryID").equals("5"))
			tableName="usr_0_srm_tr_sc";
		columnName="decision";
		strValues="'"+request.getParameter("Decision")+"'";
		sWhere=" wi_name='"+request.getParameter("WINAME")+"'";
		try	
		{
		
			 String sInputXML = "<?xml version=\"1.0\"?>"
			+ "<APUpdate_Input><Option>APUpdate</Option>"
			+ "<TableName>" + tableName + "</TableName>"
			+ "<ColName>" + columnName + "</ColName>"
			+ "<Values>" + strValues + "</Values>"
			+ "<WhereClause>" + sWhere + "</WhereClause>"
			+ "<EngineName>" + wfsession.getEngineName() + "</EngineName>"
			+ "<SessionId>" + wfsession.getSessionId() + "</SessionId>"
			+ "</APUpdate_Input>";
		
			WriteLog(sInputXML);
			String sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			WriteLog("sOutputXML :"+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				WriteLog("APUpdate successful in SRMCustomUpdate.jsp");
			}
			else
			{
				WriteLog("Problem during updating in SRMCustomUpdate.jsp");
				mainCodeParser=new XMLParser();
				mainCodeParser.setInputXML(sOutputXML);
				mainCodeCheck = mainCodeParser.getValueOf("MainCode");
			}	
		}
		catch(Exception e) 
		{
			WriteLog("<OutPut>Error during custom update</OutPut>");
		}
		tableName="usr_0_srm_wihistory";
		columnName="decision";
		strValues="'"+request.getParameter("Decision")+"'";
		sWhere=" winame='"+request.getParameter("WINAME")+"' and wsname='Q4'";
	}
	try	
	{
	
		 String sInputXML = "<?xml version=\"1.0\"?>"
		+ "<APUpdate_Input><Option>APUpdate</Option>"
		+ "<TableName>" + tableName + "</TableName>"
		+ "<ColName>" + columnName + "</ColName>"
		+ "<Values>" + strValues + "</Values>"
		+ "<WhereClause>" + sWhere + "</WhereClause>"
		+ "<EngineName>" + wfsession.getEngineName() + "</EngineName>"
		+ "<SessionId>" + wfsession.getSessionId() + "</SessionId>"
		+ "</APUpdate_Input>";
	
		WriteLog(sInputXML);
		String sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
		WriteLog("sOutputXML :"+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			WriteLog("APUpdate successful in SRMCustomUpdate.jsp");
		}
		else
		{
			WriteLog("Problem during updating in SRMCustomUpdate.jsp");
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



