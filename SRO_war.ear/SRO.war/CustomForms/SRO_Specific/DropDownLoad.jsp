<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
)
//Module                     : SRO
//File Name					 : DropDown.jsp            
//Author                     : Sajan
// Date written (DD/MM/YYYY) : 12/10/2018
//Description                : File to load Drop Downs
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../SRO_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRO/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("reqType Request.getparameter---> "+request.getParameter("reqType"));
			WriteLog("reqType Esapi---> "+reqType_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WSNAME Request.getparameter---> "+request.getParameter("WSNAME"));
			WriteLog("WSNAME Esapi---> "+WSNAME_Esapi);
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqValue"), 1000, true) );
			String reqValue_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("reqValue Request.getparameter---> "+request.getParameter("reqValue"));
			WriteLog("reqValue Esapi---> "+reqValue_Esapi);

		String reqType = reqType_Esapi;
		if (reqType != null) {reqType=reqType.replace("'","''");}		
		String WSNAME= WSNAME_Esapi;		
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}		
		WriteLog("WSNAME"+WSNAME);
		String returnValues = "";
		String query = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
		
		
		if(reqType.equals("selectDecision"))
		{
			query = "SELECT Decision FROM USR_0_SRO_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME=:WSNAME order by Decision";
			params = "WSNAME=="+WSNAME;
		}
		else if(reqType.equals("ServiceRequestType"))
		{
			query = "SELECT Request_Name FROM USR_0_SRO_ServiceRequests with(nolock) WHERE ISACTIVE=:ISACTIVE order by Request_Name";
			params = "ISACTIVE==Y";
		}
		else if(reqType.equals("Team"))
		{
			query = "SELECT Team_Name FROM USR_0_SRO_TeamMaster with(nolock) WHERE ISACTIVE=:ISACTIVE order by Team_Name";
			params = "ISACTIVE==Y";
		}
		else if(reqType.equals("ArchivalPath"))
		{
			query = "SELECT Archive_DropDown FROM USR_0_SRO_ArchivalPath with(nolock) WHERE ISACTIVE=:ISACTIVE order by Archive_DropDown desc";
			params = "ISACTIVE==Y";
		}
		else if(reqType.equals("TeamCode"))
		{
			String TeamName= reqValue_Esapi;		
			query = "SELECT top 1 Team_Code FROM USR_0_SRO_TeamMaster with(nolock) WHERE Team_Name=:Team_Name";
			params = "Team_Name=="+TeamName;
		}
		else if(reqType.equals("ServiceRequestCode"))
		{
			String Request_Name= reqValue_Esapi;		
			query = "SELECT top 1 Request_Code FROM usr_0_sro_servicerequests with(nolock) WHERE Request_Name=:Request_Name";
			params = "Request_Name=="+Request_Name;
		}
		else if(reqType.equals("ArchivalCode"))
		{
			String Archival_Name= reqValue_Esapi;		
			query = "SELECT top 1 Archive_Id FROM USR_0_SRO_ArchivalPath with(nolock) WHERE Archive_DropDown=:Archive_DropDown";
			params = "Archive_DropDown=="+Archival_Name;
		}
		else if(reqType.equals("InitiatorUserGroup"))
		{
			String LoggedInUserName= reqValue_Esapi;		
			query = "select top 1 GroupName from PDBGroup with(nolock) where GroupIndex in (select GroupIndex from pdbgroupmember with(nolock) where groupindex in (select Userid from QUEUEUSERTABLE with(nolock) where queueid in (select QueueID from QUEUEDEFTABLE with(nolock) where QueueName in ('SRO_Introduction','SRO_Mail_Initiation')) and userIndex in (select userIndex from PDBUSer with(nolock) where UserName=:UserName))) order by GroupName";
			params = "UserName=="+LoggedInUserName;
		}
		else if(reqType.equals("Email_Create_Trigger"))
		{
			 	
			query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==EMAIL_WI_CREATE";
		}
		else if(reqType.equals("Email_Approve_Trigger"))
		{
			 		
			query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==EMAIL_WI_APPROVED"; 
		}
		else if(reqType.equals("Email_Reject_Trigger"))
		{	 			
			query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==EMAIL_WI_REJECT";
		}
		else if(reqType.equals("Email_Cancel_Trigger"))
		{
			 	
			query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==EMAIL_WI_CANCEL";
		}
		else if(reqType.equals("Email_RequestInfo_Trigger"))
		{
			 		
			 query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==EMAIL_WI_MOREINFO";
		}
		else if(reqType.equals("Email_FinalReject_Trigger"))
		{
			query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==EMAIL_WI_FINAL_REJECT";
		}
		else if(reqType.equals("MailFollowup_expiry_days"))
		{
			 	
			 query = "SELECT top 1 isActive FROM USR_0_SRO_EmailEvents with (nolock) where Trigger_Name=:ISACTIVE";
			params = "ISACTIVE==MailFollowup_expiry_days";
		}
		else if(reqType.equals("Email_MailInit_User_Code"))
		{
			 String LoggedInUserNames= reqValue_Esapi;		
			 query = "select isnull(replace((SELECT CASE WHEN COUNT(1) > 0 THEN 1 ELSE 0 END AS [Value] FROM USR_0_SRO_USER_MAIL_MAPPING WITH (NOLOCK) WHERE  username=:UserId and isActive='Y'),1,(select top 1 code from USR_0_SRO_USER_MAIL_MAPPING WITH (NOLOCK) where username=:UserId and isActive='Y')),'empty') 'Code'";
			params = "UserId=="+LoggedInUserNames;
		}
		
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		
		WriteLog("\nInput XML DropDownLoadss-- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		if(reqType.equals("ArchivalCode") || reqType.equals("ServiceRequestCode") || reqType.equals("TeamCode") || reqType.equals("InitiatorUserGroup") 
		|| reqType.equals("Email_Create_Trigger") || reqType.equals("Email_Approve_Trigger") || reqType.equals("Email_Reject_Trigger") || reqType.equals("Email_Cancel_Trigger") 
		|| reqType.equals("Email_RequestInfo_Trigger") || reqType.equals("Email_FinalReject_Trigger") || reqType.equals("MailFollowup_expiry_days") || reqType.equals("Email_MailInit_User_Code"))
			WriteLog("Output XML DropDownLoad-- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue = xmlParserData.getVal("MainCode");
		WriteLog("maincode"+mainCodeValue);
		
		int recordcount=0;
		try
		{
			recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		}
		catch(Exception e)	
		{
		}
		WriteLog("recordcount -- "+recordcount);
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if (reqType.equals("ServiceRequestType"))
				returnValues = returnValues + objWorkList.getVal("Request_Name")  + "~";		
			else if (reqType.equals("selectDecision"))
				returnValues = returnValues + objWorkList.getVal("Decision")  + "~";
			else if (reqType.equals("Team"))
				returnValues = returnValues + objWorkList.getVal("Team_Name")  + "~";
			else if (reqType.equals("ArchivalPath"))
				returnValues = returnValues + objWorkList.getVal("Archive_DropDown")  + "~";
			else if (reqType.equals("TeamCode"))
				returnValues = returnValues + objWorkList.getVal("Team_Code")  + "~";
			else if (reqType.equals("ServiceRequestCode"))
				returnValues = returnValues + objWorkList.getVal("Request_Code")  + "~";
			else if (reqType.equals("ArchivalCode"))
				returnValues = returnValues + objWorkList.getVal("Archive_Id")  + "~";
			else if (reqType.equals("InitiatorUserGroup"))
				returnValues = returnValues + objWorkList.getVal("GroupName")  + "~";
				else if (reqType.equals("Email_Create_Trigger"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("Email_Approve_Trigger"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("Email_Reject_Trigger"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("Email_Cancel_Trigger"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("Email_RequestInfo_Trigger"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("Email_FinalReject_Trigger"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("MailFollowup_expiry_days"))
				returnValues = returnValues + objWorkList.getVal("isActive")  + "~";
				else if (reqType.equals("Email_MailInit_User_Code"))
				returnValues = returnValues + objWorkList.getVal("Code")  + "~";
		}
		WriteLog("reqType: " +reqType+ " returnValues -- "+returnValues);
		returnValues =  returnValues.substring(0,returnValues.length()-1);
		out.clear();
		out.print(returnValues);	
	}
	else
	{
		WriteLog("Exception in loading dropdown values -- ");
		out.clear();
		out.print("-1");
	}
	
%>