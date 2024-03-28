<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank RAO
//Module                     : Request-Initiation 
//File Name					 : SaveHistory.jsp
//Author                     : Ankit 
// Date written (DD/MM/YYYY) : 31-10-2017
//Description                : File to save data in history table on the basis of category and subcategory
//---------------------------------------------------------------------------------------------------->
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
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlResponse objXmlParser=null;
	String subXML="";
	String sInputXML="";
	String sOutputXML="";
	String mainCodeData="";
	String Query="";
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	Date date = new Date();
	String hist_table="";
	
	user_name = customSession.getUserName();
	user_name = user_name.trim();

	try{
		WINAME=request.getParameter("WINAME");
		WSNAME=request.getParameter("WSNAME");
		WSNAME = WSNAME.trim();
		WIDATA=request.getParameter("WIDATA");
		decision=request.getParameter("Decision");
		remarks=request.getParameter("Remarks");
		rejectReasons=request.getParameter("rejectReasons");
		 
		if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		
		WriteLog("Inside OECD_SaveHistory");
		
		if(true)
		{
			WriteLog("decision="+decision);
			hist_table="USR_0_OECD_WIHISTORY";
			String colname2="decision,actiondatetime,remarks,username,RejectReasons";
			WriteLog("rejectReasons......="+rejectReasons);
			String colvalues2="'"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','"+customSession.getUserName()+"','"+rejectReasons+"'" ;
			WriteLog("colvalues2 From SaveHistory colvalues2="+colvalues2);
			try	{
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
				
				WriteLog("Updating History"+sInputXML);
				sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				WriteLog("sOutputXML Updating History"+sOutputXML);

				/*if(WSNAME.equals("Introduction") || WSNAME.equals("Attach_Cust_Doc") || WSNAME.equals("Control") || WSNAME.equals("Error_Handling") || WSNAME.equals("OPS_Maker") || WSNAME.equals("OPS_Checker") || WSNAME.equals("System_Update") || WSNAME.equals("Doc_Archival"))	// Condition for  inserting in history
				{
					WriteLog("ApInsert  "+hist_table);
			   
					sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>"+hist_table+"</TableName>" +
							"<ColName>" + "WINAME,RejectReasons,WSNAME,USERNAME,DECISION,ACTIONDATETIME,Remarks" + "</ColName>" +
							"<Values>" + "'"+WINAME+"','"+rejectReasons+"','"+WSNAME+"','"+customSession.getUserName()+"','"+decision+"','"+dateFormat.format(date)+"','"+remarks+"'" + "</Values>" +
							"<EngineName>" + sCabName + "</EngineName>" +
							"<SessionId>" + sSessionId + "</SessionId>" +
						"</APInsert_Input>";
					WriteLog("History:inserting history "+sInputXML);
					sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog("History: inserting history"+sOutputXML);
				}*/ 
			}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
		}
	}catch(Exception e){e.printStackTrace();}

%>