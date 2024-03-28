<!----------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Data Update
//File Name					 : SaveHistory.jsp          
//Author                     : Shubham Ruhela
// Date written (DD/MM/YYYY) : 2-Feb-2016
//Description                : File to save data in history table 
//----------------------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------------------
Revision 	Date 			Author 			Description
0.90		10/03/2016		Shubham Ruhela	Initial Draft
//------------------------------------------------------------------------------------------------------------------>

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

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ReasonCodes", request.getParameter("WINAME"), 1000, true) );
			String WINAMEEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME saveHistory: "+WINAMEEsapi);

			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAMEEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: wi_name: "+WSNAMEEsapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Decision"), 1000, true) );
			String DecisionEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: Decision saveHistory: "+DecisionEsapi);
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Remarks"), 1000, true) );
			String RemarksEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: Remarks SaveHistory: "+RemarksEsapi);
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rejectReasons"), 1000, true) );
			String rejectReasonsEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("Integration jsp: rejectReasons SaveHistory: "+rejectReasonsEsapi);
			
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
	String fcy_rate = "";
	String pref_rate = "";
	String bal_sufficient = "";
	String comp_req = "";
	String call_back_req = "";
	String callBackSuccess = "";
	String segment = "";
	String cust_acc_curr = "";
	String scanDate = "";
	String hist_table="";
	
	//user_name = customSession.getStrPersonalName()+" "+customSession.getUserFamilyName();
	user_name = customSession.getUserName();
	user_name = user_name.trim();

	try{
		WINAME=WINAMEEsapi.replace("'","''");		
		WSNAME=WSNAMEEsapi.replace("'","''");
		WSNAME = WSNAME.trim();
		//WIDATA=request.getParameter("WIDATA");//Commented by amitabh on 13/08/2017 not using this variable
		decision=DecisionEsapi.replace("'","''");
		remarks=RemarksEsapi.replace("'","''");
		rejectReasons=rejectReasonsEsapi.replace("'","''");
		if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		
		WriteLog("Inside DA_SaveHistory");
		String colname="";
		String colvalues="'";
		String temp[]=null;
		String inputData="";
		String outputData="";
		int count2=0;			
		rejectReasons=rejectReasons.replace("'","''");
		if(true)
		{
			WriteLog("decision="+decision);
			hist_table="usr_0_da_wihistory";
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
				
				/*if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
					WriteLog("Update Successful");
				else
					WriteLog("Update UnSuccessful");*/

				if(WSNAME.equals("Archival Document Initiation"))// Condition for  inserting in history
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
				} 
			}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
		}
	}catch(Exception e){e.printStackTrace();}
	
%>