<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../TWC_Specific/Log.process"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
try{
	logger.info("Inside DropDownLoad.jsp");
	String reqType = request.getParameter("reqType");
	if (reqType != null) {reqType=reqType.replace("'","");}	
	String WSNAME= request.getParameter("WSNAME");
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}	
	logger.info("WSNAME"+WSNAME);
		
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
	String mainCodeValue="";
	
		
	if (reqType.equals("selectDecision"))
	{
		query = "SELECT Decision FROM USR_0_TWC_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME=:WSNAME and isActive='Y'";
		params = "WSNAME=="+WSNAME;
	}
	else if(reqType.equals("Nature_of_Facility"))
	{
		query = "SELECT Facility_Type FROM USR_0_TWC_FACILITY_MASTER with(nolock) where 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("Tenor_Frequency"))
	{
		//Modified on 21/02/2019 to add IsActive 
		query = "SELECT Item_Desc FROM USR_0_TWC_TENOR_FREQ_MASTER with(nolock) where IsActive='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("ROCode"))
	{
		query="select UserName from pdbuser where UserIndex in (select UserIndex from PDBGroupMember where GroupIndex in (select Userid from QUEUEUSERTABLE where QueueId in (select QueueID from QUEUEDEFTABLE where QueueName = :QueueName))) order by username";
		params="QueueName==TWC_Initiation";
	}
	
	else if(reqType.equals("Interest_Type"))
	{
		query = "SELECT Interest_Type FROM USR_0_TWC_INTEREST_TYPE with(nolock) where IsActive='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("Interest_Description"))
	{
		query = "SELECT Interest_Desc FROM USR_0_TWC_INTEREST_DESCRIPTION with(nolock) where IsActive='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("ExpiryDays"))
	{
		//Modified on 18/03/2019 by Sajan to get Expiry Days 
		query = "SELECT CONST_FIELD_VALUE FROM USR_0_BPM_CONSTANTS with(nolock) where CONST_FIELD_NAME in ('TWC_PerformCheckDays_AECB','TWC_PerformCheckDays_CBRB') AND 1=:ONE order by CONST_FIELD_NAME";
		params = "ONE==1";
	}
	
	else if(reqType.equals("SecurityDocType"))
	{
		query = "SELECT security_type FROM usr_0_twc_security_master with(nolock) where 1=:ONE"; 
		params = "ONE==1";
	}
	//Added by Sajan 14/03/2019
	else if(reqType.equals("Dealing_With_Country"))
	{
		query = "SELECT countryName FROM USR_0_RAO_CountryMaster with(nolock) where 1=:ONE"; 
		params = "ONE==1";
	}
	
	else if(reqType.equals("SecurityDocDescription"))
	{
		String SecurityDoc_Selected = request.getParameter("SecurityDocSelected");
		if (SecurityDoc_Selected != null) {SecurityDoc_Selected=SecurityDoc_Selected.replace("'","");}	
		logger.info("before replace"+SecurityDoc_Selected);
		String temp=SecurityDoc_Selected.replaceAll("PPPERCCCENTT","%").replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("ENSQOUTES","'");
		query = "SELECT security_description FROM usr_0_twc_security_master with(nolock) where security_type=:SecurityDoc_Selected";
		params = "SecurityDoc_Selected=="+temp;
	}
	
	else if(reqType.equals("facilitypurpose"))
	{
		String natureOfFacility=request.getParameter("NauterofFacilitySelected");
		if (natureOfFacility != null) {
			natureOfFacility=natureOfFacility.replace("'","");
			natureOfFacility=natureOfFacility.replaceAll("PPPERCCCENTT","%").replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("ENSQOUTES","'");
		}
		query = "SELECT DISTINCT replace(PURPOSE,CHAR(13),'<br>') as PURPOSE FROM USR_0_TWC_FACILITY_POPULATE_MASTER with(nolock) where FACILITY_TYPE=:NauterofFacilitySelected";
		params = "NauterofFacilitySelected=="+natureOfFacility;
	}
	//Added on 20/02/2019 to Select Tranche Status from Master
	else if(reqType.equals("tranche_status"))
	{
		query = "SELECT DISTINCT TrancheStatus FROM USR_0_TWC_TRANCHESTATUS with(nolock) where IsActive='Y' AND 1=:ONE ";
		params = "ONE==1";
	}
	//Added on 26/02/2019 to Select Product Identifier from Master
	else if(reqType.equals("ProductIdentifierdropdown"))
	{
		//Modified on 21/02/2019 to add IsActive 
		query = "SELECT Item_Desc FROM USR_0_TWC_Product_Identifier_MASTER with(nolock) where IsActive='Y' AND 1=:ONE order by Item_Desc";
		params = "ONE==1";
	}
	//Added on 02/04/2019 to get value of Commission for corresponding Facility Type.
	else if(reqType.equals("Commission"))
	{
		String natureOfFacility=request.getParameter("NauterofFacilitySelected");
		if (natureOfFacility != null) {
			natureOfFacility=natureOfFacility.replace("'","");
			natureOfFacility=natureOfFacility.replaceAll("PPPERCCCENTT","%").replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("ENSQOUTES","'");
		}	
		logger.info("natureOfFacility: "+natureOfFacility);
		query = "SELECT DISTINCT replace(COMMISSION,CHAR(13),'<br>') as COMMISSION FROM USR_0_TWC_FACILITY_POPULATE_MASTER with(nolock) where FACILITY_TYPE=:NauterofFacilitySelected";
		params = "NauterofFacilitySelected=="+natureOfFacility;
	}
	//Added on 02/04/2019 to get value of Commission for corresponding Facility Type.
	else if(reqType.equals("ProductLevelConditions"))
	{
		String natureOfFacility=request.getParameter("NauterofFacilitySelected");
		if (natureOfFacility != null) {
			natureOfFacility=natureOfFacility.replace("'","");
			natureOfFacility=natureOfFacility.replaceAll("PPPERCCCENTT","%").replaceAll("AMPNDCHAR","&").replaceAll("CCCOMMAAA",",").replaceAll("ENSQOUTES","'");
		}	
		logger.info("natureOfFacility: "+natureOfFacility);
		query = "SELECT DISTINCT replace(PRODUCT_STRUCTURE_LEVEL_CONDITION,CHAR(13),'<br>') as PRODUCT_STRUCTURE_LEVEL_CONDITION FROM USR_0_TWC_FACILITY_POPULATE_MASTER with(nolock) where FACILITY_TYPE=:NauterofFacilitySelected";
		params = "NauterofFacilitySelected=="+natureOfFacility;
	}
	else if(reqType.equals("getTrancheEnabledCount"))
	{
		String natureOfFacility=request.getParameter("natureOfFacilities");
		if (natureOfFacility != null) {natureOfFacility=natureOfFacility.replace("'","");}
		if (natureOfFacility != null) {natureOfFacility=natureOfFacility.replace(",","','");}
		query = "select Count(*) as TrancheEnabledCount from USR_0_TWC_FACILITY_MASTER with(nolock) where FACILITY_TYPE in ('"+natureOfFacility+"') and isTrancheEnabled=:isTrancheEnabled";
		params = "isTrancheEnabled==Yes";
	}
	else if(reqType.equals("wdesk:First_Level_Business_Approver"))
	{
		query = "select distinct UserName from PDBUser with(nolock) where UserIndex in (select distinct UserIndex from PDBGroupMember with(nolock) where GroupIndex in (select GroupIndex from PDBGroup with(nolock) where GroupName in ('TWC_RM','TWC_SM'))) AND 1=:ONE order by UserName";
		params = "ONE==1";
	}
	else if(reqType.equals("wdesk:Second_Level_Business_Approver"))
	{
		query = "select distinct UserName from PDBUser with(nolock) where UserIndex in (select distinct UserIndex from PDBGroupMember with(nolock) where GroupIndex in (select GroupIndex from PDBGroup with(nolock) where GroupName in ('TWC_SM','TWC_UM'))) AND 1=:ONE order by UserName";
		params = "ONE==1";
	}
	else if(reqType.equals("wdesk:First_Level_Credit_Approver"))
	{
		query = "select distinct UserName from PDBUser with(nolock) where UserIndex in (select distinct UserIndex from PDBGroupMember with(nolock) where GroupIndex in (select GroupIndex from PDBGroup with(nolock) where GroupName = 'TWC_CreditApprover1')) AND 1=:ONE order by UserName";
		params = "ONE==1";
	}
	else if(reqType.equals("wdesk:Second_Level_Credit_Approver"))
	{
		query = "select distinct UserName from PDBUser with(nolock) where UserIndex in (select distinct UserIndex from PDBGroupMember with(nolock) where GroupIndex in (select GroupIndex from PDBGroup with(nolock) where GroupName = 'TWC_CreditApprover2')) AND 1=:ONE order by UserName";
		params = "ONE==1";
	}
	else if(reqType.equals("TypeOfLA"))
	{
		query = "SELECT Item_Desc FROM USR_0_TWC_TypeOfLA with(nolock) where IsActive='Y' AND 1=:ONE order by Item_Desc";
		params = "ONE==1";
	}
	else if(reqType.equals("RequestType"))
	{
		query = "SELECT Item_Desc FROM USR_0_TWC_RequestType with(nolock) where IsActive='Y' AND 1=:ONE order by Item_Desc";
		params = "ONE==1";
	}
	else if(reqType.equals("ChannelSubGroup"))
	{
		query = "SELECT CHANNELSG FROM USR_0_TWC_CHANNELSUBGROUP_MASTER with(nolock) where IsActive='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("TwcAbf"))
	{
		query = "SELECT TWCABF FROM USR_0_TWC_ABFTWC_MASTER with(nolock) where IsActive='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("Priority"))
	{
		query = "SELECT PRIORITY FROM USR_0_TWC_PRIORITY_MASTER with(nolock) where IsActive='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	else if(reqType.equals("loadPartnerCode"))
	{
		query = "SELECT Partner_Code FROM USR_0_TWC_PARTNER_CODE_MASTER with(nolock) where ISACTIVE='Y' AND 1=:ONE";
		params = "ONE==1";
	}
	
	sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
	
	logger.info("\nInput XML for reqType: "+reqType+" : "+sInputXML);

	sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);

	if (reqType.equals("selectDecision") || reqType.equals("Tenor_Frequency") || reqType.equals("tranche_status") || reqType.equals("getTrancheEnabledCount") || reqType.equals("Commission"))	
		logger.info("Output XML for reqType: "+reqType+" : "+sOutputXML);

	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((sOutputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	logger.info("Maincode: "+mainCodeValue);
	
	
	
	int recordcount=0;
	try
	{
		recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
	}
	catch(Exception e)	
	{
		logger.info("Error in Loading Dropdown Values for reqType: "+reqType+" : "+e.getMessage());
	}
		logger.info("RecordCount for reqType: "+reqType+" : "+recordcount);
	if(mainCodeValue.equals("0") && recordcount > 0)
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			if (reqType.equals("selectDecision"))
				returnValues = returnValues + objWorkList.getVal("Decision")  + "~";
			else if (reqType.equals("Nature_of_Facility"))
				returnValues = returnValues + objWorkList.getVal("Facility_Type")  + "~";
			else if (reqType.equals("Dealing_With_Country"))
				returnValues = returnValues + objWorkList.getVal("countryName")  + "~";
			else if (reqType.equals("Tenor_Frequency"))
				returnValues = returnValues + objWorkList.getVal("Item_Desc")  + "~";
			
			else if (reqType.equals("Interest_Type"))
				returnValues = returnValues + objWorkList.getVal("Interest_Type")  + "~";
			
			else if (reqType.equals("Interest_Description"))
				returnValues = returnValues + objWorkList.getVal("Interest_Desc")  + "~";
			
			else if(reqType.equals("ROCode"))
				returnValues = returnValues + objWorkList.getVal("UserName")  + "~";
			else if (reqType.equals("SecurityDocType"))
				returnValues = returnValues + objWorkList.getVal("security_type")  + "~";
			else if (reqType.equals("SecurityDocDescription"))
				returnValues = returnValues + objWorkList.getVal("security_description")  + "~";
			else if (reqType.equals("ExpiryDays"))
				returnValues = returnValues + objWorkList.getVal("CONST_FIELD_VALUE")  + "~";
			else if (reqType.equals("facilitypurpose"))
				returnValues = returnValues + objWorkList.getVal("PURPOSE")  + "~";
			
			//Added on 20/02/2019 to Select Tranche Status from Master
			else if (reqType.equals("tranche_status"))
				returnValues = returnValues + objWorkList.getVal("TrancheStatus")  + "~";
			
			//Added on 26/02/2019 to Select Product Identifier from Master
			else if (reqType.equals("ProductIdentifierdropdown"))
				returnValues = returnValues + objWorkList.getVal("Item_Desc")  + "~";
			
			//Added on 02/04/2018 to get value of Commission.
			else if (reqType.equals("Commission"))
				returnValues = returnValues + objWorkList.getVal("COMMISSION")  + "~";
			
			//Added on 02/04/2018 to get value of Commission.
			else if (reqType.equals("ProductLevelConditions"))
				returnValues = returnValues + objWorkList.getVal("PRODUCT_STRUCTURE_LEVEL_CONDITION")  + "~";
			
			else if (reqType.equals("getTrancheEnabledCount"))
				returnValues = returnValues + objWorkList.getVal("TrancheEnabledCount")  + "~";
				
			else if (reqType.equals("wdesk:First_Level_Business_Approver") || reqType.equals("wdesk:Second_Level_Business_Approver") || reqType.equals("wdesk:First_Level_Credit_Approver") || reqType.equals("wdesk:Second_Level_Credit_Approver"))
				returnValues = returnValues + objWorkList.getVal("UserName")  + "~";
			
			else if (reqType.equals("TypeOfLA"))
				returnValues = returnValues + objWorkList.getVal("Item_Desc")  + "~";
			else if (reqType.equals("RequestType"))
				returnValues = returnValues + objWorkList.getVal("Item_Desc")  + "~";	
			
			//Added on 17/06/2021 .
			else if (reqType.equals("Priority"))
				returnValues = returnValues + objWorkList.getVal("PRIORITY")  + "~";
			else if (reqType.equals("ChannelSubGroup"))
				returnValues = returnValues + objWorkList.getVal("CHANNELSG")  + "~";
			else if (reqType.equals("TwcAbf"))
				returnValues = returnValues + objWorkList.getVal("TWCABF")  + "~";
			else if (reqType.equals("loadPartnerCode"))
				returnValues = returnValues + objWorkList.getVal("Partner_Code")  + "~";
		}
		returnValues =  returnValues.substring(0,returnValues.length()-1);
		logger.info("ReturnValues for reqType: "+reqType+" : "+returnValues);
		out.clear();
		out.print(returnValues);	
	}
	else
	{
		logger.info("Error in Loading Dropdown Values for reqType: "+reqType+" . ");
		out.clear();
		out.print("-1");
	}
	
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	
	
%>