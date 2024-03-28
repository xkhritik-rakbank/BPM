<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                                                                                               : Application –Projects
//Product / Project                                         : RAKBank SRM
//Module                     : Request-Initiation 
//File Name                                                                        : SRMCompleteWI.jsp
//Author                     : Deepti Sharma
// Date written (DD/MM/YYYY) : 29-Mar-2014
//Description                : File to insert/update data in Transaction table
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

<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<%@ include file="SaveHistory.jsp"%>

<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%
	WriteLog("Inside SRM Complete Workitem.jsp");
	boolean blockCardNoInLogs=true;
	
	//out.print("<script>alert('inside complete wi call');</script>");
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	String WINAME=request.getParameter("WINAME");
	String TEMP_WI_NAME=request.getParameter("TEMP_WI_NAME");
	String tableName="";
	String columnName="";
	String strValues="";
	String sWhere="";
	String savedTmpWI="";
	String trTableName="";
	

	try          
	{
		tableName="RB_SRM_EXTTABLE";
		columnName="wi_name";
		strValues="'"+WINAME+"'";
		sWhere=" temp_wi_name = '"+TEMP_WI_NAME+"'";
		String sInputXML = "<?xml version=\"1.0\"?>"
			+ "<APUpdate_Input><Option>APUpdate</Option>"
			+ "<TableName>" + tableName + "</TableName>"
			+ "<ColName>" + columnName + "</ColName>"
			+ "<Values>" + strValues + "</Values>"
			+ "<WhereClause>" + sWhere + "</WhereClause>"
			+ "<EngineName>" + wfsession.getEngineName() + "</EngineName>"
			+ "<SessionId>" + wfsession.getSessionId() + "</SessionId>"
			+ "</APUpdate_Input>";
					
		WriteLog("APUpdate InputXML for external table :"+sInputXML);
		
		String sOutputXML = WFCallBroker.execute(sInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		
		WriteLog("APUpdate  Output xml for external table : " + sOutputXML);
		
		//Changes by stutee.mishra to check tempWI in transaction table after save call.
		
		String query1 = "select SubCategory from RB_SRM_EXTTABLE with (nolock) where Temp_WI_NAME = '"+TEMP_WI_NAME+"'";
		String inputData1 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query1 + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		WriteLog("inputData to get subcategory-->"+inputData1);
		String outputData1 = WFCallBroker.execute(inputData1, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("outputData to get subcategory-->"+outputData1);
		XMLParser xmlParserData1=new XMLParser();
		xmlParserData1.setInputXML(outputData1);
		String mainCodeData1=xmlParserData1.getValueOf("MainCode");
		if(mainCodeData1.equals("0"))
		{
			String subCat = xmlParserData1.getValueOf("SubCategory");
			WriteLog("Subcategory of case-->"+subCat);
			if(subCat.equalsIgnoreCase("Balance Transfer")){
				trTableName = "USR_0_SRM_TR_BT";
			}else if(subCat.equalsIgnoreCase("Credit Card Cheque")){
				trTableName = "USR_0_SRM_TR_CCC";
			}else if(subCat.equalsIgnoreCase("Blocking of Cards")){
				trTableName = "USR_0_SRM_TR_BOC";
			}else if(subCat.equalsIgnoreCase("Smart Cash")){
				trTableName = "USR_0_SRM_TR_SC";
			}else if(subCat.equalsIgnoreCase("Cash Back Redemption")){
				trTableName = "USR_0_SRM_TR_CBR";
			}
		}
		WriteLog("trTableName-->"+trTableName);
		
		String query = "select WI_NAME from "+trTableName+" with (nolock) where Temp_WI_NAME = '"+TEMP_WI_NAME+"'";
		String inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		WriteLog("inputData to check wi number-->"+inputData);
		String outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("outputData to check wi number-->"+outputData);
		XMLParser xmlParserData=new XMLParser();
		xmlParserData.setInputXML(outputData);
		String mainCodeData=xmlParserData.getValueOf("MainCode");
		if(mainCodeData.equals("0"))
		{
			savedTmpWI = xmlParserData.getValueOf("WI_NAME");
			WriteLog("Saved WI of BT-->"+savedTmpWI);
		}
		
		if(savedTmpWI.equalsIgnoreCase("")){
			tableName=trTableName;
			columnName="wi_name";
			strValues="'"+WINAME+"'";
			sWhere=" temp_wi_name = '"+TEMP_WI_NAME+"'";
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<APUpdate_Input><Option>APUpdate</Option>"
				+ "<TableName>" + tableName + "</TableName>"
				+ "<ColName>" + columnName + "</ColName>"
				+ "<Values>" + strValues + "</Values>"
				+ "<WhereClause>" + sWhere + "</WhereClause>"
				+ "<EngineName>" + wfsession.getEngineName() + "</EngineName>"
				+ "<SessionId>" + wfsession.getSessionId() + "</SessionId>"
				+ "</APUpdate_Input>";
						
			WriteLog("APUpdate InputXML for transaction table when wi_name not saved earlier: "+sInputXML);
			
			sOutputXML = WFCallBroker.execute(sInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			
			WriteLog("APUpdate  Output xml for transaction table when wi_name not saved earlier: " + sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				WriteLog("Update is successful for wi_name in transaction table.");
				savedTmpWI = WINAME;
			}else{
				savedTmpWI = "";
			}
		}
		//end.
					
	
		//------------

		if(!savedTmpWI.equalsIgnoreCase("")){
			sInputXML = "<?xml version=\"1.0\"?>" +
			"<WMGetWorkItem_Input>" +
			"<Option>WMGetWorkItem</Option>" +
			"<EngineName>" + wfsession.getEngineName() + "</EngineName>" +
			"<SessionId>" + wfsession.getSessionId() + "</SessionId>" +
			"<ProcessInstanceId>" + WINAME + "</ProcessInstanceId>" +
			"<WorkItemId>1</WorkItemId>" +
			"</WMGetWorkItem_Input>";

		WriteLog(sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
		WriteLog("sOutputXML :"+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
						WriteLog("Workitem "+WINAME+" successfully Locked.");
		}
		else
		{
						WriteLog("Problem during Locking workitem "+WINAME+".");
						mainCodeParser=new XMLParser();
						mainCodeParser.setInputXML(sOutputXML);
						mainCodeCheck = mainCodeParser.getValueOf("MainCode");
		}                                                              
						
		/*  WMComplete is not used , insted            WMStartProcess_Input is used.
		
			sInputXML = "<?xml version=\"1.0\"?>" +
			"<WMCompleteWorkItem_Input>" +
			"<Option>WMCompleteWorkItem</Option>" +
			"<EngineName>" + wfsession.getEngineName() + "</EngineName>" +
			"<SessionId>" + wfsession.getSessionId() + "</SessionId>" +
			"<ProcessInstanceId>" + WINAME + "</ProcessInstanceId>" +
			"<WorkItemId>1</WorkItemId>" +
			"</WMCompleteWorkItem_Input>";
		*/
						
		sInputXML = "<?xml version=\"1.0\"?>" +
		"<WMStartProcess_Input>" +
		"<Option>WMStartProcess</Option>" +
		"<EngineName>" + wfsession.getEngineName() + "</EngineName>" +
		"<SessionId>" + wfsession.getSessionId() + "</SessionId>" +
		"<ProcessInstanceId>" + WINAME + "</ProcessInstanceId>" +
		"<ActivityId>1</ActivityId>" +
		"</WMStartProcess_Input>";                                                                                                                    
																																		
		WriteLog(sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
		WriteLog("sOutputXML :"+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
						WriteLog("Workitem "+WINAME+" successfully introduced.");
		}
		else
		{
			WriteLog("Problem during introducing workitem "+WINAME+".");
			mainCodeParser=new XMLParser();
			mainCodeParser.setInputXML(sOutputXML);
			mainCodeCheck = mainCodeParser.getValueOf("MainCode");
		}
		}else{
			mainCodeCheck = "WIName not saved in transaction table";
		}												
	}
	catch(Exception e) 
	{
			WriteLog("<OutPut>Error during introducing workitem</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.println(mainCodeCheck+"~");                           
%>



