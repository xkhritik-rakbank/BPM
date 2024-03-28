<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../OECD_Specific/Log.process"%>
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
		WriteLog("reqType------------"+reqType);
		String WSNAME= request.getParameter("WSNAME");
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
		WriteLog("WSNAME-------------"+WSNAME);
		String WINAME= request.getParameter("WINAME");
		if (WINAME != null) {WINAME=WINAME.replace("'","''");}
		WriteLog("WINAME-------------"+WINAME);
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
		
		
		if (reqType.equals("selectDecision"))
		{
			query = "SELECT Decision FROM USR_0_OECD_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME=:WSNAME order by Decision";
			params = "WSNAME=="+WSNAME;
		}			

		else if (reqType.equals("custsegment"))
		{
			query = "SELECT Segment FROM USR_0_OECD_Segment with (nolock) where 1=:ONE order by Segment";
			params = "ONE==1";
		}	
		
		else if (reqType.equals("CrsUndocReason"))
		{
			query = "SELECT UndocFlagReason FROM USR_0_OECD_CRSUndocFlgReason with (nolock) where 1=:ONE order by UndocFlagReason";
			params = "ONE==1";
		}
		
		else if (reqType.equals("CountryCode"))
		{
			query = "select countryName from USR_0_OECD_CountryMaster with (nolock) where countryCode=:CountryOfBirth ";
			params = "CountryOfBirth=="+WSNAME;
		}
		else if (reqType.equals("CityCode") || reqType.equals("StateCode")) 
		{
			/*String Code=URLDecoder.decode(request.getParameter("code")).replace("&amp;","&");
			if (Code != null) {Code=Code.replace("'","");}*/
			query = "select cityName from USR_0_OECD_CityMaster with (nolock) where cityCode=:CityOfBirth";
			params = "CityOfBirth=="+WSNAME;
		}	
		else if (reqType.equals("USRelationDesc")) 
		{
			query = "select USRELATIONDESC from USR_0_OECD_USRELATION with (nolock) where USRELATIONCODE=:USRELATIONCODE and ISACTIVE='Y'";
			params = "USRELATIONCODE=="+WSNAME;
		}
		else if (reqType.equals("ControllingPersonUSRelationDesc")) 
		{
			query = "select USRELATIONDESC from USR_0_OECD_CONTROLLINGPERSONUSRELATION with (nolock) where USRELATIONCODE=:USRELATIONCODE and ISACTIVE='Y'";
			params = "USRELATIONCODE=="+WSNAME;
		}
		else if (reqType.equals("FatcaEntityTypeDesc")) 
		{
			query = "select ENTITYDESC from USR_0_OECD_FATCAENTITYTYPE with (nolock) where ENTITYCODE=:ENTITYCODE and ISACTIVE='Y'";
			params = "ENTITYCODE=="+WSNAME;
		}
		else if (reqType.equals("FinancialEntityDesc")) 
		{
			query = "select FINENTITYDESC from USR_0_OECD_FINANCIAL_ENTITY with (nolock) where FINENTITYCODE=:FINENTITYCODE and ISACTIVE='Y'";
			params = "FINENTITYCODE=="+WSNAME;
		}
		else if (reqType.equals("RELATEDPARTYDETAILS_GRID")) //Added as part of CR 29102020
		{
			query = "select CIFID,NAME,RELATIONSHIPTYPE,CONTROLLINGPERSONTYPE,FINANCIALDETAILID,RESIDENCEADDRLINE1,RESIDENCEADDRLINE2,RESIDENCEADDRCITY,RESIDENCEADDRSTATE,RESIDENCEADDRPOBOX,RESIDENCEADDRCOUNTRY,MAILINGADDRLINE1,MAILINGADDRLINE2,MAILINGADDRCITY,MAILINGADDRSTATE,MAILINGADDRPOBOX,MAILINGADDRCOUNTRY,USRELATION,ReportCountryDetails,CRSUNDOCUMENTEDFLAG,CRSUNDOCUMENTEDREASON from USR_0_OECD_RELATEDPARTYDETAILS_GRID with (nolock) where WINAME=:WI_NAME order by ID";
			params = "WI_NAME=="+WINAME;
		}
		else if (reqType.equals("loadchecklist"))   //added as a part of CR 29102020
		{
			/*String WINAME=URLDecoder.decode(request.getParameter("WINAME")).replace("&amp;","&");
			if (WINAME != null) {WINAME=WINAME.replace("'","");}*/
			String myQuery="SELECT * FROM USR_0_OECD_CHECKLISTDETAILS_GRID WHERE WIName=:WINAME";
			params = "WINAME=="+WINAME;
			String input="<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + myQuery + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML -- "+input);
			
			sOutputXML = WFCustomCallBroker.execute(input, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML ---- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue1 = xmlParserData.getVal("MainCode");
		//WriteLog("maincode"+mainCodeValue1);
		
		int recordcount1=0;
		try
		{
			recordcount1=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		}
		catch(Exception e)	
		{
		}
		WriteLog("recordcount -- "+recordcount1);
	   if(mainCodeValue1.equals("0"))
	   {
			if (recordcount1 > 0)
			{			
				query="SELECT SRId as ID, Checklist_Description, Option_checklist FROM USR_0_OECD_CHECKLISTDETAILS_GRID with(nolock) where WINAME=:WINAME Order by cast(LEFT(SUBSTRING(SRId, PATINDEX('%[0-9.-]%', SRId), 8000),   PATINDEX('%[^0-9.-]%', SUBSTRING(SRId, PATINDEX('%[0-9.-]%', SRId), 8000) + 'X') -1) as int),SRId";
				params = "WINAME=="+WINAME;
			}
			else
			{
				query = "SELECT ID,Checklist_Description ,'' as Option_checklist FROM USR_0_OECD_CHECKLISTDETAILS_MASTER with (nolock) WHERE isActive=:isActive Order by cast(LEFT(SUBSTRING(ID, PATINDEX('%[0-9.-]%', ID), 8000),   PATINDEX('%[^0-9.-]%', SUBSTRING(ID, PATINDEX('%[0-9.-]%', ID), 8000) + 'X') -1) as int),ID";
				params = "isActive==Y";
			}
		}
		else
		{
			
			query = "SELECT ID,Checklist_Description ,'' as Option_checklist FROM USR_0_OECD_CHECKLISTDETAILS_MASTER with (nolock) WHERE isActive=:isActive";
			params = "isActive==Y";
		}
			
	}
		
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML -- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML ---- "+sOutputXML);

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
		if (recordcount >=1)
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{				
				  if (reqType.equals("selectDecision"))
					returnValues = returnValues + objWorkList.getVal("Decision")  + "~";	
				  else if (reqType.equals("custsegment"))
					returnValues = returnValues + objWorkList.getVal("Segment")  + "~";
				  else if (reqType.equals("CrsUndocReason"))
					returnValues = returnValues + objWorkList.getVal("UndocFlagReason")  + "~";	
				  else if (reqType.equals("CountryCode"))
					returnValues = returnValues + objWorkList.getVal("countryName")  + "~";
				  else if (reqType.equals("CityCode") || reqType.equals("StateCode")) 
					returnValues = returnValues + objWorkList.getVal("cityName")  + "~";
				  else if (reqType.equals("USRelationDesc")) 
					returnValues = returnValues + objWorkList.getVal("USRELATIONDESC")  + "~";
				else if (reqType.equals("ControllingPersonUSRelationDesc")) 
					returnValues = returnValues + objWorkList.getVal("USRELATIONDESC")  + "~";
				  else if (reqType.equals("FatcaEntityTypeDesc")) 
					returnValues = returnValues + objWorkList.getVal("ENTITYDESC")  + "~";
				  else if (reqType.equals("FinancialEntityDesc")) 
					returnValues = returnValues + objWorkList.getVal("FINENTITYDESC")  + "~";
       		      else if (reqType.equals("RELATEDPARTYDETAILS_GRID")) //Added as part of CR 29102020
					returnValues = returnValues + objWorkList.getVal("CIFID")  + "`"+ objWorkList.getVal("NAME")  + "`"+ objWorkList.getVal("RELATIONSHIPTYPE")  + "`"+ objWorkList.getVal("CONTROLLINGPERSONTYPE")  + "`"+ objWorkList.getVal("FINANCIALDETAILID")  + "`"+ objWorkList.getVal("RESIDENCEADDRLINE1")  + "`"+ objWorkList.getVal("RESIDENCEADDRLINE2")  + "`"+ objWorkList.getVal("RESIDENCEADDRCITY")  + "`"+ objWorkList.getVal("RESIDENCEADDRSTATE")  + "`"+ objWorkList.getVal("RESIDENCEADDRPOBOX")  + "`"+ objWorkList.getVal("RESIDENCEADDRCOUNTRY")  + "`"+ objWorkList.getVal("MAILINGADDRLINE1")  + "`"+ objWorkList.getVal("MAILINGADDRLINE2")  + "`"+ objWorkList.getVal("MAILINGADDRCITY")  + "`"+ objWorkList.getVal("MAILINGADDRSTATE")  + "`"+ objWorkList.getVal("MAILINGADDRPOBOX")  + "`"+ objWorkList.getVal("MAILINGADDRCOUNTRY")  + "`"+ objWorkList.getVal("USRELATION")  + "`"+ objWorkList.getVal("ReportCountryDetails") + "`"+ objWorkList.getVal("CRSUNDOCUMENTEDFLAG") + "`"+ objWorkList.getVal("CRSUNDOCUMENTEDREASON") +"#";
                  else if (reqType.equals("loadchecklist"))  // added as a part of CR 29102020
					returnValues = returnValues + objWorkList.getVal("ID") + "~" + objWorkList.getVal("Checklist_Description") + "~" + objWorkList.getVal("Option_checklist") + "|" ; 	
             }	
			returnValues =  returnValues.substring(0,returnValues.length()-1);
			WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		} else
		{
			out.clear();
			out.print("");
		}		
	}
	else
	{
		WriteLog("Exception in loading dropdown values -- ");
		out.clear();
		out.print("-1");
	}
	
%>