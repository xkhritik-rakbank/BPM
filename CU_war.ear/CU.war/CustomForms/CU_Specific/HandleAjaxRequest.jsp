<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../CU_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>


<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%
	
	String reqType = request.getParameter("reqType");	
	if (reqType != null) {reqType=reqType.replace("'","''");}
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
	
	if (reqType.equals("office_cntrycode"))
	{
		query = "SELECT countryname FROM USR_0_CU_CountryMaster with(nolock) where 1=:ONE order by countryname";
		params = "ONE==1";
	}	
	else if (reqType.equals("TypeOfRelationNew"))
	{
		query = "SELECT RelationTypeDisplay FROM usr_0_cu_RelationType with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("FatcaDocNew"))
	{
		query = "SELECT FatcaDocDisplay FROM usr_0_cu_FatcaDocument with (nolock)  where 1=:ONE";
		params = "ONE==1";
	}
		//Added by nikita to fetch fatca reason data from master
		else if (reqType.equals("FatcaReasonNew"))
		{
			query = "SELECT ReasonDisplay FROM usr_0_cu_fatcareason with (nolock) where 1=:ONE";
			params = "ONE==1";
		}	
	else if (reqType.equals("CustomerType_new"))
	{
		query = "SELECT CustType FROM usr_0_cu_customertype with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("IndustrySubSegment_new"))
	{
		query = "SELECT IndustrySubSegType FROM usr_0_cu_IndustrySubSegment with (nolock)  where 1=:ONE";
		params = "ONE==1";
	}
	else if (reqType.equals("IndustrySegment_new"))
	{
		query = "SELECT industrySegTypeDisplay FROM usr_0_cu_IndustrySegment with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("USrelation_new"))
	{
		query = "SELECT RelTypeDisplay FROM usr_0_cu_usrelation with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("resi_restype"))
	{
		query = "SELECT ResTypeDisplay FROM usr_0_cu_residencetype with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("emp_type_new"))
	{
		query = "SELECT EmpTypeDisplay FROM usr_0_cu_employementtype with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("employment_status_new"))
	{
		query = "SELECT EmpstatusTypeDisplay FROM usr_0_cu_employementstatus with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("marrital_status_new"))
	{
		query = "SELECT maritalstatustypedisplay FROM usr_0_cu_maritalstatus with (nolock) where 1=:ONE";
		params = "ONE==1";
	}	
	else if (reqType.equals("occupation_new"))
	{
		query = "SELECT OCCUPATION_CODE_DESC FROM usr_0_cu_occupationmaster with (nolock) where 1=:ONE order by OCCUPATION_CODE_DESC";
		params = "ONE==1";
	}	
	//Added by Shamily to fetch tin reason and undoc reason from master table 
	else if (reqType.equals("OECDUndocreason_new"))
	{
		query = "SELECT UndocFlagReason FROM USR_0_CU_CRSUndocFlgReason with (nolock) where 1=:ONE order by UndocFlagReason";
		params = "ONE==1";
	}
	else if (reqType.equals("resi_cntrycode"))
	{
		query = "SELECT cityname FROM usr_0_cu_Countrycrossmapping with (nolock) where 1=:ONE order by cityname";
		params = "ONE==1";
	}	
	//Added by Shamily for resi_cntrycodeAE
		else if (reqType.equals("resi_cntrycodeAE"))
		{
			query = "SELECT cityname FROM USR_0_CU_CityMaster with (nolock) where cityname not in (SELECT cityname FROM usr_0_cu_Countrycrossmapping with (nolock)) and  1=:ONE order by cityname";
			params = "ONE==1";
		}
		else if (reqType.equals("OECDtinreason_new")|| reqType.equals("OECDtinreason_new2") || reqType.equals("OECDtinreason_new3") || reqType.equals("OECDtinreason_new4") || reqType.equals("OECDtinreason_new5") ||reqType.equals("OECDtinreason_new6"))
		{
			query = "SELECT Reason FROM usr_0_cu_NoTINReason with (nolock)  where 1=:ONE order by Reason desc";
			params = "ONE==1";
		}	
	
	
	WriteLog("query -- "+query);
	
	//sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";

	 sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
	
	WriteLog("\nInput XML -- "+sInputXML);
	
	sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
	//WriteLog("Output XML ---- "+sOutputXML);

	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((sOutputXML));
	String mainCodeValue = xmlParserData.getVal("MainCode");
	
	int recordcount=0;
	try{
		recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
	}catch(Exception e)	{}
	//WriteLog("recordcount -- "+recordcount);
	
	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if (reqType.equals("office_cntrycode"))
				returnValues = returnValues + objWorkList.getVal("countryname")  + "~";	
			else if (reqType.equals("TypeOfRelationNew"))
				returnValues = returnValues + objWorkList.getVal("RelationTypeDisplay")  + ",";
			else if (reqType.equals("FatcaDocNew"))
				returnValues = returnValues + objWorkList.getVal("FatcaDocDisplay")  + ",";	
				//Added by nikita to fetch fatca reason data from master
				else if (reqType.equals("FatcaReasonNew"))
				returnValues = returnValues + objWorkList.getVal("ReasonDisplay")  + ",";	
			else if (reqType.equals("CustomerType_new"))
				returnValues = returnValues + objWorkList.getVal("CustType")  + ",";	
			else if (reqType.equals("IndustrySubSegment_new"))
				returnValues = returnValues + objWorkList.getVal("IndustrySubSegType")  + ",";	
			else if (reqType.equals("IndustrySegment_new"))
				returnValues = returnValues + objWorkList.getVal("industrySegTypeDisplay")  + ",";
			else if (reqType.equals("USrelation_new"))
				returnValues = returnValues + objWorkList.getVal("RelTypeDisplay")  + ",";	
			else if (reqType.equals("resi_restype"))
				returnValues = returnValues + objWorkList.getVal("ResTypeDisplay")  + ",";	
			else if (reqType.equals("emp_type_new"))
				returnValues = returnValues + objWorkList.getVal("EmpTypeDisplay")  + ",";	
			else if (reqType.equals("employment_status_new"))
				returnValues = returnValues + objWorkList.getVal("EmpstatusTypeDisplay")  + ",";	
			else if (reqType.equals("marrital_status_new"))
				returnValues = returnValues + objWorkList.getVal("maritalstatustypedisplay")  + ",";	
			else if (reqType.equals("occupation_new"))
				returnValues = returnValues + objWorkList.getVal("OCCUPATION_CODE_DESC")  + "~";	
				//Added by Shamily to fetch tin reason and undoc reason from master table  
			else if (reqType.equals("OECDUndocreason_new"))
				returnValues = returnValues + objWorkList.getVal("UndocFlagReason")  + ",";	
				else if (reqType.equals("resi_cntrycode"))
				returnValues = returnValues + objWorkList.getVal("cityname")  + ",";	
				//Added by Shamily for resi_cntrycodeAE
				else if (reqType.equals("resi_cntrycodeAE"))
				returnValues = returnValues + objWorkList.getVal("cityname")  + ",";	
				else if (reqType.equals("OECDtinreason_new")|| reqType.equals("OECDtinreason_new2") || reqType.equals("OECDtinreason_new3") || reqType.equals("OECDtinreason_new4") || reqType.equals("OECDtinreason_new5") ||reqType.equals("OECDtinreason_new6"))
				returnValues = returnValues + objWorkList.getVal("Reason")  + ",";	
		}	
		returnValues =  returnValues.substring(0,returnValues.length()-1);		
	}
	
	//WriteLog("returnValues -- "+returnValues);

	out.clear();
	out.print(returnValues);
%>