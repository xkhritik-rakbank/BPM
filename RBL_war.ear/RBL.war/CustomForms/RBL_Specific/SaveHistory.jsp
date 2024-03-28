<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank RMT
//Module                     : Request-Initiation 
//File Name					 : SaveHistory.jsp
//Author                     : Nikita 
// Date written (DD/MM/YYYY) : 12-01-2018
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

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );
			String WI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			logger.info("WI_NAME_Esapi. req "+request.getParameter("WI_NAME"));
			logger.info("WI_NAME_Esapi "+WI_NAME_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			logger.info("WSNAME_Esapi. req "+request.getParameter("WSNAME"));
			logger.info("WSNAME_Esapi "+WSNAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Decision"), 1000, true) );
			String Decision_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			logger.info("Decision_Esapi. req "+request.getParameter("Decision"));
			logger.info("Decision_Esapi "+Decision_Esapi);
			
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Remarks"), 1000, true) );
			String Remarks_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			logger.info("Remarks_Esapi. req "+request.getParameter("Remarks"));
			Remarks_Esapi = Remarks_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@");
			logger.info("Remarks_Esapi "+Remarks_Esapi);
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rejectReasons"), 1000, true) );
			String rejectReasons_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("rejectReasons_Esapi Request.getparameter---> "+request.getParameter("rejectReasons"));
			WriteLog("rejectReasons_Esapi Esapi---> "+rejectReasons_Esapi);
			rejectReasons_Esapi = rejectReasons_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@");
			logger.info("rejectReasons_Esapi "+rejectReasons_Esapi);
			
			
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
		if (WINAME != null) {WINAME=WINAME.replace("'","''");}
		WSNAME=WSNAME_Esapi;
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
		WSNAME = WSNAME.trim();
		decision=Decision_Esapi;
		if (decision != null) {decision=decision.replace("'","''");}
		remarks=Remarks_Esapi;
		if (remarks != null) {remarks=remarks.replace("'","''");}
		remarks=Remarks_Esapi.replaceAll("AMPNDCHAR","&");
		rejectReasons=rejectReasons_Esapi;
		if (rejectReasons != null) {rejectReasons=rejectReasons.replace("'","''");}
		 
		if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		
		logger.info("Inside RMT_SaveHistory");
		
		if(true)
		{
			logger.info("decision="+decision);
			hist_table="usr_0_rbl_wihistory";
			String colname2="decision,actiondatetime,remarks,username,RejectReasons";
			logger.info("rejectReasons......="+rejectReasons);
			String colvalues2="'"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','"+customSession.getUserName()+"','"+rejectReasons+"'" ;
			logger.info("colvalues2 From SaveHistory colvalues2="+colvalues2);
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
				
				logger.info("Updating History for WINAME "+WINAME+" , at Workstep: "+WSNAME+" : "+sInputXML);
				sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				logger.info("sOutputXML Updating History for WINAME "+WINAME+" , at Workstep: "+WSNAME+" : "+sOutputXML);

				
					logger.info("ApInsert  "+hist_table);
			   
					sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>"+hist_table+"</TableName>" +
							"<ColName>" + "WINAME,RejectReasons,WSNAME,USERNAME,DECISION,ACTIONDATETIME,Remarks" + "</ColName>" +
							"<Values>" + "'"+WINAME+"','"+rejectReasons+"','"+WSNAME+"','"+customSession.getUserName()+"','"+decision+"','"+dateFormat.format(date)+"','"+remarks+"'" + "</Values>" +
							"<EngineName>" + sCabName + "</EngineName>" +
							"<SessionId>" + sSessionId + "</SessionId>" +
						"</APInsert_Input>";
					if(WSNAME.equalsIgnoreCase("Introduction"))
					{
						logger.info("History:inserting history "+sInputXML);
						sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						logger.info("History: inserting history"+sOutputXML);
					}
				
			}
			catch(Exception e) 
			{
				logger.info("<OutPut>Error in getting User Session.</OutPut>");
			}
			
		}
	}catch(Exception e){e.printStackTrace();}

%>