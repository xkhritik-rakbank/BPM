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
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%
	WriteLog("Inside SRMCustomSelect.jsp");
	boolean blockCardNoInLogs=true;
	String getValueFrom=request.getParameter("SelectFor");
	String query="";
	String params="";
	String inputData="";
	String outputData="";
	XMLParser xmlParserData=null;
	XMLParser xmlParserData2=null;
	String mainCodeData="";
	String returnValue="";
	
	if(getValueFrom.equalsIgnoreCase("usr_0_srm_otherbankcodes_master"))
	{
		query = "select payment_type from usr_0_srm_otherbankcodes_master with (nolock) where other_bank_name = :other_bank_name and isactive = :is_active";
		params = "other_bank_name=="+request.getParameter("columnforselect").replaceAll("CHARAMPERSAND","&").replaceAll("CHARPERCENTAGE", "%")+"~~"+"is_active==Y";
		inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("inputData for otherbankcode master-->"+inputData);
		outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("outputData for otherbankcode master-->"+outputData);
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML(outputData);
		mainCodeData=xmlParserData.getValueOf("MainCode");
		if(mainCodeData.equals("0"))
		{
			returnValue=xmlParserData.getValueOf("payment_type");
			WriteLog("Getting payment type successful-->"+returnValue);
		}
	}
	else if(getValueFrom.equalsIgnoreCase("usr_0_srm_ccc_purpose_master"))
	{
		if(request.getParameter("queryfor").equals("marketingcode"))
		{
			query = "select marketingcode from usr_0_srm_ccc_purpose_master with (nolock) where purposedesc = :purposedesc and isactive = :is_active";
			params = "purposedesc=="+request.getParameter("columnforselect").replaceAll("CHARPERCENTAGE", "%").replaceAll("CHARAMPERSAND", "&")+"~~"+"is_active==Y";
			inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
			WriteLog("inputData for usr_0_srm_ccc_purpose_master master-->"+inputData);
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("outputData for usr_0_srm_ccc_purpose_master master-->"+outputData);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputData);
			mainCodeData=xmlParserData.getValueOf("MainCode");
			if(mainCodeData.equals("0"))
			{
				returnValue=xmlParserData.getValueOf("marketingcode");
				WriteLog("Getting marketing code successful-->"+returnValue);
			}
		}
		else
		{
			query = "select purposecodeshort from usr_0_srm_ccc_purpose_master with (nolock) where purposedesc = :purposedesc and isactive = :is_active";
			params = "purposedesc=="+request.getParameter("columnforselect").replaceAll("CHARPERCENTAGE", "%").replaceAll("CHARAMPERSAND", "&")+"~~"+"is_active==Y";
			inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
			WriteLog("inputData for usr_0_srm_ccc_purpose_master master-->"+inputData);
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("outputData for usr_0_srm_ccc_purpose_master master-->"+outputData);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputData);
			mainCodeData=xmlParserData.getValueOf("MainCode");
			if(mainCodeData.equals("0"))
			{
				returnValue=xmlParserData.getValueOf("purposecodeshort");
				WriteLog("Getting purposecodeshort successful-->"+returnValue);
			}
		}
	}
	else if(getValueFrom.equalsIgnoreCase("usr_0_srm_sc_marketingcodes"))
	{
		if(request.getParameter("queryfor").equals("marketingcode"))
		{
			query = "select marketingcode from usr_0_srm_sc_marketingcodes with (nolock) where typeofbt = :typeofbt and isactive = :is_active";
			params = "typeofbt=="+request.getParameter("columnforselect").replaceAll("CHARPERCENTAGE", "%").replaceAll("CHARAMPERSAND", "&")+"~~"+"is_active==Y";
			inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
			WriteLog("inputData for usr_0_srm_sc_marketingcodes master-->"+inputData);
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("outputData for usr_0_srm_sc_marketingcodes master-->"+outputData);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputData);
			mainCodeData=xmlParserData.getValueOf("MainCode");
			if(mainCodeData.equals("0"))
			{
				returnValue=xmlParserData.getValueOf("marketingcode");
				WriteLog("Getting marketing code successful-->"+returnValue);
			}
		}
	}
	else if(getValueFrom.equalsIgnoreCase("usr_0_srm_btccc_noneligrsn"))
	{
		query = "select reason from usr_0_srm_btccc_noneligrsn with (nolock) where reasoncode = :reasoncode and isactive = :is_active";
		params = "reasoncode=="+request.getParameter("columnforselect")+"~~"+"is_active==Y";
		inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("inputData for usr_0_srm_btccc_noneligrsn master-->"+inputData);
		outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("outputData for usr_0_srm_btccc_noneligrsn master-->"+outputData);
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML(outputData);
		mainCodeData=xmlParserData.getValueOf("MainCode");
		if(mainCodeData.equals("0"))
		{
			returnValue=xmlParserData.getValueOf("reason");
			WriteLog("Getting reason successful-->"+returnValue);
		}
	}
	else if(getValueFrom.equalsIgnoreCase("usr_0_srm_bt_marketingcodes"))
	{
		query = "select marketingcode from usr_0_srm_bt_marketingcodes with (nolock) where typeofbt = :typeofbt and isactive = :is_active";
		params = "typeofbt=="+request.getParameter("columnforselect").replaceAll("CHARPERCENTAGE", "%")+"~~"+"is_active==Y";
		inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("inputData for usr_0_srm_bt_marketingcodes master-->"+inputData);
		outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("outputData for usr_0_srm_bt_marketingcodes master-->"+outputData);
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML(outputData);
		mainCodeData=xmlParserData.getValueOf("MainCode");
		if(mainCodeData.equals("0"))
		{
			returnValue=xmlParserData.getValueOf("marketingcode");
			WriteLog("Getting marketingcode successful-->"+returnValue);
		}
	}
	else if(getValueFrom.equalsIgnoreCase("usr_0_srm_boc_rsnforblock"))
	{
		if(request.getParameter("queryfor").equals("blockreason"))
		{
			query = "select reasonforblock from usr_0_srm_boc_rsnforblock with (nolock) where typeofblock = :typeofblock and isactive = :is_active";
			params = "typeofblock=="+request.getParameter("columnforselect")+"~~"+"is_active==Y";
			inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
			WriteLog("inputData for usr_0_srm_boc_rsnforblock master-->"+inputData);
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("outputData for usr_0_srm_boc_rsnforblock master-->"+outputData);
			xmlParserData=new XMLParser();
			xmlParserData2=new XMLParser();
			xmlParserData.setInputXML(outputData);
			mainCodeData=xmlParserData.getValueOf("MainCode");
			int countofrec = xmlParserData.getNoOfFields("Record");
			String record="";
			if(mainCodeData.equals("0"))
			{
				for (int i = 0; i < countofrec; i++) 
				{
					record = xmlParserData.getNextValueOf("Record");
					xmlParserData2.setInputXML(record);
					returnValue+=xmlParserData2.getValueOf("reasonforblock")+"#";
				}
				if(returnValue.length()>0)
					returnValue = returnValue.substring(0,returnValue.lastIndexOf("#"));
				//returnValue=xmlParserData.getValueOf("reasonforblock");
				WriteLog("Getting reasonforblock successful-->"+returnValue);
			}
		}
		else
		{
			query = "select primestatuscode from usr_0_srm_boc_rsnforblock with (nolock) where reasonforblock = :reasonforblock and isactive = :is_active";
			params = "reasonforblock=="+request.getParameter("columnforselect")+"~~"+"is_active==Y";
			inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
			WriteLog("inputData for usr_0_srm_boc_rsnforblock master-->"+inputData);
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			WriteLog("outputData for usr_0_srm_boc_rsnforblock master-->"+outputData);
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputData);
			mainCodeData=xmlParserData.getValueOf("MainCode");
			if(mainCodeData.equals("0"))
			{
				returnValue=xmlParserData.getValueOf("primestatuscode");
				WriteLog("Getting usr_0_srm_boc_rsnforblock primestatus code successful-->"+returnValue);
			}
		}
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.println(mainCodeData+"~"+returnValue);		
%>



