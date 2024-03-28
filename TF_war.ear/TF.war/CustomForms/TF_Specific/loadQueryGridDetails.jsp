<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
	<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );
	String WI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: WI_NAME_Esapi: "+WI_NAME_Esapi);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Req_type"), 1000, true) );
	String Req_type_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: Req_type_Esapi: "+Req_type_Esapi);

	String Query2 = "";
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;
	WFCustomXmlResponse objWFCustomXmlResponse=null;
	String inputXMLstate="";
	String outputXMLstate= "";
	String subXML="";
	String params="";
	String state_search="";
	String returnValue = "";
	String mainCodeValuestate = "";
	String table_name="";
	String col_Names="";
	String[] colNamesArray;
	
	try {
		String wiName=WI_NAME_Esapi;
		String Req_type=Req_type_Esapi;
		
		if (wiName != null) {wiName=wiName.replace("'","");}
		if (Req_type != null) {Req_type=Req_type.replace("'","");}
		
		WriteLog("\n wiName "+wiName);
		WriteLog("\n Req_type "+Req_type);
		
		/* Hritik 09.02.2024 */
		
		if("FIRCO".equalsIgnoreCase(Req_type)){
			table_name="USR_0_TF_FRICO_DTLS_GRID";
			col_Names="SELECT_ID,Entity_Type,NAME,Fetch_Firco_Status,Fetch_Firco_Date";			
			WriteLog("col_Names "+col_Names);
			colNamesArray = col_Names.split(",");
			for(int i=0;i<colNamesArray.length;i++)
			{
				WriteLog("\n col_Names "+colNamesArray[i]);
			}
			Query2 = "SELECT "+col_Names+" FROM "+ table_name+" with (nolock) WHERE WINAME=:WI_NAME ";
		}
		else if ("FIRCO_UID".equalsIgnoreCase(Req_type)){
			
			table_name="USR_0_TF_GR_FIRCO_UID";
			col_Names="Entity,EntityName,Reference_No,U_ID,Matchingtext,Name,Origin,Designation,Date_of_birth,user_data_1,Nationality,Passport,Additiona_info,Remarks_uid";			
			WriteLog("col_Names "+col_Names);
			colNamesArray = col_Names.split(",");
			/*for(int i=0;i<colNamesArray.length;i++)
			{
				WriteLog("\n col_Names "+colNamesArray[i]);
			}*/
			Query2 = "SELECT "+col_Names+" FROM "+ table_name+" with (nolock) WHERE WINAME=:WI_NAME ";
		}
	
		else{
			table_name="USR_0_TF_QUERY_DTLS_GRID";
			WriteLog("table_name "+table_name);
			
			col_Names="SELECT_ID,QUERY_NAME,CREDIT_REMARKS,BUSINESS_REMARKS";
			
			WriteLog("col_Names "+col_Names);
			
			colNamesArray = col_Names.split(",");
			/*for(int i=0;i<colNamesArray.length;i++)
			{
				WriteLog("\n col_Names "+colNamesArray[i]);
			}*/
			
			Query2 = "SELECT "+col_Names+" FROM "+ table_name+" with (nolock) WHERE WINAME=:WI_NAME order by SELECT_ID ASC";
		}
		params = "WI_NAME=="+wiName;
		

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\n Input Xml For Get "+table_name+"  Data"+inputXMLstate);

		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		WriteLog("Output Xml For Get "+table_name+" Data"+outputXMLstate);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLstate));
		mainCodeValuestate = xmlParserData.getVal("MainCode");
		String recordsArray="";
		String tempRowvalues="";
		int totalRecord=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		if(mainCodeValuestate.equals("0")&&totalRecord>0)
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
				if(tempRowvalues!="")
				tempRowvalues=tempRowvalues+"|";
				int newRow=1;
				subXML = objWorkList.getVal("Record");
				objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
				for(int i=0;i<colNamesArray.length;i++)
				{
					if(tempRowvalues=="")
					{
						tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNamesArray[i]);
						newRow=0;
					}
					else if(tempRowvalues!="" && newRow==1)
					{
						tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNamesArray[i]);
						newRow=0;
					}
					else if(tempRowvalues!="" && newRow==0)
					{
						tempRowvalues=tempRowvalues+"~"+objWFCustomXmlResponse.getVal(colNamesArray[i]);
						newRow=0;
					}
				}
			}
			WriteLog("temp "+ table_name+" Rowvalues "+tempRowvalues);
			if (tempRowvalues != null) {tempRowvalues=tempRowvalues.replaceAll("\\r","<br>");}
			out.clear();
			out.print(tempRowvalues);
		}
		else if(mainCodeValuestate.equals("0")&&totalRecord==0)
		{
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
	
%>