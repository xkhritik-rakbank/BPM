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
<%@ include file="../CU_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%!
public String getAPSelectXML(String strEngineName, String strSessionId, String Query) 
{
	return "<?xml version=\"1.0\"?>"
		+ "<APSelect_Input><Option>APSelect</Option>"
		+ "<Query>" + Query + "</Query>"
		+ "<EngineName>" + strEngineName + "</EngineName>"
		+ "<SessionId>" + strSessionId + "</SessionId>"
		+ "</APSelect_Input>";
}
%>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Decision"), 1000, true) );
			String Decision_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Remarks"), 1000, true) );
			String Remarks_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("checklistData"), 1000, true) );
			String checklistData_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rejectReasons"), 1000, true) );
			String rejectReasons_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("isElite"), 1000, true) );
			String isElite_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");

	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();		
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String params = "";
	
	String WSNAME="" ,WINAME="",WIDATA="",rejectReasons="",checklistData="",user_name="",decision="",remarks="",entrydatetime="";
	
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
	String isElite = "";
	
	//user_name = customSession.getStrPersonalName()+" "+customSession.getUserFamilyName();
	user_name = customSession.getUserName();
	user_name = user_name.trim();

	try{
		WINAME=WINAME_Esapi;
		if (WINAME != null) {WINAME=WINAME.replace("'","''");}
		WSNAME=WSNAME_Esapi.replace("'","''");
		WSNAME = WSNAME.trim();
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
		//WIDATA=request.getParameter("WIDATA").replace("'","''");// not in use
		decision=Decision_Esapi.replace("'","''");
		if (decision != null) {decision=decision.replace("'","''");}
		remarks=Remarks_Esapi.replace("'","''");
		if (remarks != null) {remarks=remarks.replace("'","''");}
		checklistData=checklistData_Esapi.replace("'","''");
		if (checklistData != null) {checklistData=checklistData.replace("'","''");}
		rejectReasons=rejectReasons_Esapi.replace("'","''");
		if (rejectReasons != null) {rejectReasons=rejectReasons.replace("'","''");}
		isElite=isElite_Esapi.replace("'","''");
		if (isElite != null) {isElite=isElite.replace("'","''");}
		if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		
		WriteLog("Inside CU_SaveHistory");
		String colname="";
		String colvalues="'";
		String temp[]=null;
		String inputData="";
		String outputData="";
		int count2=0;			
		
		if(true)
		{
			//WriteLog("decision="+decision);
			hist_table="usr_0_cu_wihistory";
			String colname2="decision,actiondatetime,remarks,username,checklistData";
			
			
			/*
			String queryRej = "select Item_Desc from USR_0_CU_Error_Desc_Master with(nolock) where item_code = :item_code" ;
			params = "item_code=="+rejectReasons;
			String outputXMLRej ="";
			String InputXmlRej = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryRej + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
			//String InputXmlRej = getAPSelectXML(sCabName,sSessionId,queryRej);
			WriteLog("InputXml Fetch sol id----"+InputXmlRej);
			outputXMLRej=WFCustomCallBroker.execute(InputXmlRej, sJtsIp, iJtsPort, 1);
			WriteLog("outputXML Fetch sol id----"+outputXMLRej);

			String Valid = "";
			if(outputXMLRej.indexOf("<Item_Desc>")>-1)
			{
				rejectReasons=outputXMLRej.substring(outputXMLRej.indexOf("<Item_Desc>")+"<Item_Desc>".length(),outputXMLRej.indexOf("</Item_Desc>"));
			}

			
			*/
			WriteLog("rejectReasons......123="+rejectReasons);
			WriteLog("rejectReasons......req="+request.getParameter("rejectReasons"));
			String colvalues2="'"+decision+"','"+dateFormat.format(date)+"','"+remarks+"','"+customSession.getUserName()+"','"+rejectReasons+"'" ;
			//WriteLog("colvalues2 FromSaveHistory colvalues2="+colvalues2);
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
				
				if(true)// Condition for  inserting in history
				{
					if (WSNAME.equals("CSO"))
					{
						//WriteLog("ApInsert for cso "+hist_table);
			   
						sInputXML = "<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
								"<Option>APInsert</Option>" +
								"<TableName>"+hist_table+"</TableName>" +
								"<ColName>" + "WINAME,ChecklistData,WSNAME,USERNAME,DECISION,ACTIONDATETIME,Remarks" + "</ColName>" +
								"<Values>" + "'"+WINAME+"','"+rejectReasons+"','"+WSNAME+"','"+customSession.getUserName()+"','"+decision+"','"+	dateFormat.format(date)+"','"+remarks+"'" + "</Values>" +
								"<EngineName>" + sCabName + "</EngineName>" +
								"<SessionId>" + sSessionId + "</SessionId>" +
							"</APInsert_Input>";
						WriteLog("History:inserting history "+sInputXML);
						sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						WriteLog("History: inserting history"+sOutputXML);
					}
				}	
			}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
		}
	}catch(Exception e){e.printStackTrace();}
	
	
	
%>