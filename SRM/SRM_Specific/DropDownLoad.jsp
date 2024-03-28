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
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%
		String reqType = request.getParameter("reqType");
		String channel = request.getParameter("channel");
		String CRN=request.getParameter("selectedCRN");
		String returnValues = "";
		String query = "";
		XMLParser xmlParserData=null;
		XMLParser xmlParserData2=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
		String returnValue="";
		
		if (reqType.equals("othBankName"))
		{
			String PaymentType = request.getParameter("PaymentType");
			query = "SELECT other_bank_name FROM usr_0_srm_otherbankcodes_master with (nolock) where isactive = :is_active and payment_type like '%"+PaymentType+"%'";
			params ="is_active==Y";
		}
		else if (reqType.equals("purposeByChannel"))
		{
			String SubCat=request.getParameter("SubCat");
			if (SubCat.equals("Credit Card Cheque"))
			{
				query = "SELECT PURPOSEDESC FROM usr_0_srm_ccc_purpose_master with (nolock) where channel=:CHANNEL and isactive = :is_active";
				params ="is_active==Y~~CHANNEL=="+channel;
			}
			/*else if (SubCat.equals("Smart Cash"))
			{
				query = "SELECT PURPOSEDESC FROM usr_0_srm_sc_purpose_master with (nolock) where channel=:CHANNEL and isactive = :is_active";
				params ="is_active==Y~~CHANNEL=="+channel;
			}*/
		}
		else if (reqType.equals("PaymentByPurpose"))
		{
			String purposedesc = request.getParameter("purpose");
			if (purposedesc != null) {purposedesc=purposedesc.replace("'","''");}
			if (purposedesc != null) {purposedesc=purposedesc.replace("&amp;","&");}
			if (purposedesc != null) {purposedesc=purposedesc.replace("CHARPERCENTAGE","%");}
			if (purposedesc != null) {purposedesc=purposedesc.replace("CHARAMPERSAND","&");}
			String SubCategoryID = request.getParameter("SubCategoryID");
			if (SubCategoryID.equals("4"))
			{
				query = "SELECT PAYMENTTYPE FROM usr_0_srm_ccc_purpose_master with (nolock) where purposedesc=:purposedesc and channel=:CHANNEL and isactive = :is_active";
				params ="is_active==Y~~purposedesc=="+purposedesc+"~~CHANNEL=="+channel;
			}
			/*else if (SubCategoryID.equals("5"))
			{
				query = "SELECT PAYMENTTYPE FROM usr_0_srm_sc_purpose_master with (nolock) where purposedesc=:purposedesc and channel=:CHANNEL and isactive = :is_active";
				params ="is_active==Y~~purposedesc=="+purposedesc+"~~CHANNEL=="+channel;
			}*/
		}
		else if (reqType.equals("PaymentByUsingTypeOfBTSMC"))  
		{
			String TypeOfBTSMC = request.getParameter("TypeOfBTSMC");
			if (TypeOfBTSMC != null) {TypeOfBTSMC=TypeOfBTSMC.replace("'","''");}
			if (TypeOfBTSMC != null) {TypeOfBTSMC=TypeOfBTSMC.replace("&amp;","&");}
			if (TypeOfBTSMC != null) {TypeOfBTSMC=TypeOfBTSMC.replace("CHARPERCENTAGE","%");}
			if (TypeOfBTSMC != null) {TypeOfBTSMC=TypeOfBTSMC.replace("CHARAMPERSAND","&");}
			String SubCategoryID = request.getParameter("SubCategoryID");
			if (SubCategoryID.equals("2"))
			{
				query = "SELECT PAYMENTTYPE FROM usr_0_srm_bt_marketingcodes with (nolock) where typeofbt=:typeofbt and channel=:CHANNEL and isactive = :is_active";
				params ="is_active==Y~~typeofbt=="+TypeOfBTSMC+"~~CHANNEL=="+channel;
			}
			if (SubCategoryID.equals("5"))
			{
				query = "SELECT PAYMENTTYPE FROM usr_0_srm_sc_marketingcodes with (nolock) where typeofbt=:typeofbt and channel=:CHANNEL and isactive = :is_active";
				params ="is_active==Y~~typeofbt=="+TypeOfBTSMC+"~~CHANNEL=="+channel;
			}
		}
		else if (reqType.equals("TypeOfBTByChannel"))
		{
			query = "SELECT TYPEOFBT FROM usr_0_srm_bt_marketingcodes with (nolock) where CHANNEL=:CHANNEL and isactive = :is_active";
			params = "is_active==Y~~CHANNEL=="+channel;
		}
		else if (reqType.equals("TypeOfSMCByChannel"))
		{
			query = "SELECT TYPEOFBT FROM usr_0_srm_sc_marketingcodes with (nolock) where CHANNEL=:CHANNEL and isactive = :is_active";
			params = "is_active==Y~~CHANNEL=="+channel;
		}
		
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("InputXml-->"+sInputXML);
		sOutputXML = WFCallBroker.execute(sInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("Output Xml-->"+sOutputXML);
		xmlParserData=new XMLParser();
		xmlParserData2=new XMLParser();
		xmlParserData.setInputXML(sOutputXML);
		String mainCodeData=xmlParserData.getValueOf("MainCode");
		int countofrec = xmlParserData.getNoOfFields("Record");
		String record="";
		try
		{
			if(mainCodeData.equals("0"))
			{
				
				if (reqType.equals("othBankName"))
				{
					for (int i = 0; i < countofrec; i++) 
					{
						record = xmlParserData.getNextValueOf("Record");
						xmlParserData2.setInputXML(record);
						returnValue+=xmlParserData2.getValueOf("other_bank_name")+"#";
					}
				}
				else if (reqType.equals("purposeByChannel"))
				{
					for (int i = 0; i < countofrec; i++) 
					{
						record = xmlParserData.getNextValueOf("Record");
						xmlParserData2.setInputXML(record);
						returnValue+=xmlParserData2.getValueOf("PURPOSEDESC")+"#";
					}
				}
				else if (reqType.equals("PaymentByPurpose"))
				{
					for (int i = 0; i < countofrec; i++) 
					{
						record = xmlParserData.getNextValueOf("Record");
						xmlParserData2.setInputXML(record);
						returnValue+=xmlParserData2.getValueOf("PAYMENTTYPE");
					}
				}
				else if (reqType.equals("PaymentByUsingTypeOfBTSMC"))
				{
					for (int i = 0; i < countofrec; i++) 
					{
						record = xmlParserData.getNextValueOf("Record");
						xmlParserData2.setInputXML(record);
						returnValue+=xmlParserData2.getValueOf("PAYMENTTYPE");
					}
				}
				else if (reqType.equals("TypeOfBTByChannel"))
				{
					for (int i = 0; i < countofrec; i++) 
					{
						record = xmlParserData.getNextValueOf("Record");
						xmlParserData2.setInputXML(record);
						if(returnValue.equals(""))
						returnValue=xmlParserData2.getValueOf("TYPEOFBT");
						else
						returnValue+="#"+xmlParserData2.getValueOf("TYPEOFBT");
					}
				}
				else if (reqType.equals("TypeOfSMCByChannel"))
				{
					for (int i = 0; i < countofrec; i++) 
					{
						record = xmlParserData.getNextValueOf("Record");
						xmlParserData2.setInputXML(record);
						if(returnValue.equals(""))
						returnValue=xmlParserData2.getValueOf("TYPEOFBT");
						else
						returnValue+="#"+xmlParserData2.getValueOf("TYPEOFBT");
					}
				}
				
				WriteLog("Getting reasonforblock successful-->"+returnValue);
			}	
			else
			{
				WriteLog("Error in loading dropdown values -- ");
				out.clear();
				out.print("-1");
			}
		}
		catch(Exception e)
		{
			WriteLog("Exception in loading dropdown values -- ");
			out.clear();
			out.print("-1");
		}	
		out.clear();
	    out.print(returnValue);	
%>