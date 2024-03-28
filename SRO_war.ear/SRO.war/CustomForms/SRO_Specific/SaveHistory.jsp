<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRO
//Module                     : Service Request Other 
//File Name					 : SaveHistory.jsp
//Author                     : Sajan 
// Date written (DD/MM/YYYY) : 12-10-2018
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

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("WSNAME", request.getParameter("WSNAME"), 1000, true) );
	String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("WSNAME Request.getparameter---> "+request.getParameter("WSNAME"));
	WriteLog("WSNAME Esapi---> "+WSNAME_Esapi);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Decision"), 1000, true) );
	String Decision_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Decision Request.getparameter---> "+request.getParameter("Decision"));
	WriteLog("Decision Esapi---> "+Decision_Esapi);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
	String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
	WriteLog("WINAME Esapi---> "+WINAME_Esapi);
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TEAM"), 1000, true) );
	String TEAM_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("TEAM Request.getparameter---> "+request.getParameter("TEAM"));
	WriteLog("TEAM Esapi---> "+TEAM_Esapi);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("InitiatorTeam"), 1000, true) );
	String InitiatorTeam_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("InitiatorTeam Request.getparameter---> "+request.getParameter("InitiatorTeam"));
	WriteLog("InitiatorTeam Esapi---> "+InitiatorTeam_Esapi);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Remarks"), 1000, true) );
	String Remarks_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Remarks Request.getparameter---> "+request.getParameter("Remarks"));
	WriteLog("Remarks Esapi---> "+Remarks_Esapi);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rejectReasons"), 1000, true) );
	String rejectReasons_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("rejectReasons Request.getparameter---> "+request.getParameter("rejectReasons"));
	WriteLog("rejectReasons Esapi---> "+rejectReasons_Esapi);
	
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();		
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	
	String WSNAME="" ,WINAME="",WIDATA="",rejectReasons="",user_name="",decision="",remarks="",entrydatetime="",strTeam="",strInitiatorTeam="";
	
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
		WriteLog("Inside SRO_SaveHistory");
		
		WINAME=request.getParameter("WINAME");
		if (WINAME != null) {WINAME=WINAME.replace("'","''");}
		WSNAME=request.getParameter("WSNAME");
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
		WSNAME = WSNAME.trim();
		//WIDATA=request.getParameter("WIDATA");
		decision=request.getParameter("Decision");
		if (decision != null) {decision=decision.replace("'","''");}
		strTeam=request.getParameter("TEAM");
		if (strTeam != null) {strTeam=strTeam.replace("'","''");}
		strInitiatorTeam=request.getParameter("InitiatorTeam");
		if (strInitiatorTeam != null) {strInitiatorTeam=strInitiatorTeam.replace("'","''");}
		remarks=request.getParameter("Remarks").replaceAll("AMPNDCHAR","&");
		if (remarks != null) {remarks=remarks.replace("'","''");}
		rejectReasons=request.getParameter("rejectReasons");
		if (rejectReasons != null) {rejectReasons=rejectReasons.replace("'","''");}
		 
		if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		
		// Making Assigned Team blank when item is finally rejected
		//Added Mail_Init Workstep for Mail Management Changes
		if (WSNAME.equalsIgnoreCase("Mail_Initiation") || WSNAME.equalsIgnoreCase("Mail_Followup") || WSNAME.equalsIgnoreCase("Initiator_Reject") || WSNAME.equalsIgnoreCase("Hold"))
		{
			if (decision.equalsIgnoreCase("Reject"))
				strTeam="";
		}
		//***********************************************************
		
		
		if(true)
		{
			WriteLog("decision="+decision);
			hist_table="usr_0_SRO_wihistory";
			String colname2="decision,actiondatetime,remarks,username,RejectReasons,team,InitiatorTeam";
			WriteLog("rejectReasons......="+rejectReasons);
			String colvalues2="'"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','"+customSession.getUserName()+"','"+rejectReasons+"','"+strTeam+"','"+strInitiatorTeam+"'" ;
			WriteLog("colvalues2 From SaveHistory colvalues2="+colvalues2);
			try	{
			//Added Mail_Init Workstep for Mail Management Changes
				if(WSNAME.equals("Introduction"))// Condition for  inserting in history	
				{
						WriteLog("ApInsert for WINAME "+WINAME+" , WSNAME: "+WSNAME+" : "+hist_table);
				   
						sInputXML = "<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
								"<Option>APInsert</Option>" +
								"<TableName>"+hist_table+"</TableName>" +
								"<ColName>" + "WINAME,RejectReasons,WSNAME,USERNAME,DECISION,ACTIONDATETIME,Remarks,team,InitiatorTeam" + "</ColName>" +
								"<Values>" + "'"+WINAME+"','"+rejectReasons+"','"+WSNAME+"','"+customSession.getUserName()+"','"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','"+strTeam+"','"+strInitiatorTeam+"'" + "</Values>" +
								"<EngineName>" + sCabName + "</EngineName>" +
								"<SessionId>" + sSessionId + "</SessionId>" +
							"</APInsert_Input>";
						WriteLog("sInputXML History:inserting history for WINAME "+WINAME+" , WSNAME: "+WSNAME+" : "+sInputXML);
						for (int i=0; i<3; i++)
						{
							sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
							WriteLog("sOutputXML History: inserting history for WINAME "+WINAME+" , WSNAME: "+WSNAME+" : "+sOutputXML);
							xmlParserData=new WFCustomXmlResponse();
							xmlParserData.setXmlString(sOutputXML);
							String maincode = xmlParserData.getVal("MainCode");
							if (maincode.equals("0"))
							{
								WriteLog("\n History inserted successful for WINAME "+WINAME+" , WSNAME: "+WSNAME);
								break;
							}
						}	
				}
				else
				{
					
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

					
						/*WriteLog("ApInsert  "+hist_table);
				   
						sInputXML = "<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
								"<Option>APInsert</Option>" +
								"<TableName>"+hist_table+"</TableName>" +
								"<ColName>" + "WINAME,RejectReasons,WSNAME,USERNAME,DECISION,ACTIONDATETIME,Remarks,team" + "</ColName>" +
								"<Values>" + "'"+WINAME+"','"+rejectReasons+"','"+WSNAME+"','"+customSession.getUserName()+"','"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','" +strTeam+ "'</Values>" +
								"<EngineName>" + sCabName + "</EngineName>" +
								"<SessionId>" + sSessionId + "</SessionId>" +
							"</APInsert_Input>";
						WriteLog("History:inserting history "+sInputXML);
						if(WSNAME.equalsIgnoreCase("Introduction"))
						{
							sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
							WriteLog("History: inserting history"+sOutputXML);
						}*/
					
				}
				//Added for mail Management Changes
				//,Email_Approve_Trigger,Email_Reject_Trigger,Email_Cancel_Trigger,Email_RequestInfo_Trigger,Email_FinalReject_Trigger,MailFollowup_expiry_days
						String mainCodeValueMail="";
						WFCustomXmlResponse xmlParserDataMail=null;
						WFCustomXmlResponse objXmlParserMail=null;
						String subXMLMail="";
						String sInputXMLMail="";
						String sOutputXMMail="";
						String mainCodeDataMail="";
						String QueryMail="";
						sInputXMLMail = "<?xml version=\"1.0\"?>" +
					"<APUpdate_Input>" +
						"<Option>APUpdate</Option>" +
						"<TableName>RB_SRO_EXTTABLE</TableName>" +
						"<ColName>Email_Create_Trigger,Email_Approve_Trigger,Email_Reject_Trigger,Email_Cancel_Trigger,Email_RequestInfo_Trigger,Email_FinalReject_Trigger,MailFollowup_expiry_days,Email_Expiry_Reject_Trigger</ColName>" +
						"<Values>(SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_CREATE'),(SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_APPROVED'),(SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_REJECT'),(	SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_CANCEL'),(SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_MOREINFO'),(SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_FINAL_REJECT'),(	SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='MailFollowup_expiry_days'),(	SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name='EMAIL_WI_EXPIRY_REJECT')</Values>"+
						"<WhereClause>WI_NAME='"+WINAME+"' and Current_WS='" +WSNAME+"' and Email_Initiated_WI_Flag='Y' </WhereClause>" +
						"<EngineName>" + sCabName + "</EngineName>" +
						"<SessionId>" + sSessionId + "</SessionId>" +
					"</APUpdate_Input>";

					WriteLog("Updating History"+sInputXMLMail);
					sOutputXMMail= WFCustomCallBroker.execute(sInputXMLMail,sJtsIp,iJtsPort,1);
					WriteLog("sOutputXMMail Updating Mail Parameters"+sOutputXMMail);
					//Condition for Updating MailUserCode from Mail_Initiation WorkStep
// 					if(WSNAME.equals("Mail_Initiation")){
// 					//user_name
// 					String sInputXMLMailUser="";
// 						String sOutputXMMailUser="";
// 						String mainCodeDataMailUser="";
// 						String QueryMailUser="";
// 						sInputXMLMailUser = "<?xml version=\"1.0\"?>" +
// 					"<APUpdate_Input>" +
// 						"<Option>APUpdate</Option>" +
// 						"<TableName>RB_SRO_EXTTABLE</TableName>" +
// 						"<ColName>Email_MailInit_User_Code</ColName>" +
// 						"<Values>(select code from USR_0_SRO_USER_MAIL_MAPPING where UserName='"+user_name+"' and isActive='Y')</Values>"+
// 						"<WhereClause>WI_NAME='"+WINAME+"' and Current_WS='" +WSNAME+"' and Email_Initiated_WI_Flag='Y' </WhereClause>" +
// 						"<EngineName>" + sCabName + "</EngineName>" +
// 						"<SessionId>" + sSessionId + "</SessionId>" +
// 					"</APUpdate_Input>";

// 					WriteLog("Updating History"+sInputXMLMailUser);
// 					sOutputXMMailUser= WFCustomCallBroker.execute(sInputXMLMailUser,sJtsIp,iJtsPort,1);
// 					WriteLog("sOutputXMMail Updating Mail Parameters"+sOutputXMMailUser);
// 					}
			}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
		}
	}catch(Exception e){e.printStackTrace();}

%>