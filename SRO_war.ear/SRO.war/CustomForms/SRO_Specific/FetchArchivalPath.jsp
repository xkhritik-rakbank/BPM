<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
)
//Module                     : SRO
//File Name					 : FetchArchivalPath.jsp            
//Author                     : Sajan
// Date written (DD/MM/YYYY) : 16/10/2018
//Description                : Fetching Archival Path
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

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ArchivalDropDownValue"), 1000, true) );
			String ArchivalDropDownValue_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("ArchivalDropDownValue Request.getparameter---> "+request.getParameter("ArchivalDropDownValue"));
			WriteLog("ArchivalDropDownValue Esapi---> "+ArchivalDropDownValue_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WSNAME Request.getparameter---> "+request.getParameter("WSNAME"));
			WriteLog("WSNAME Esapi---> "+WSNAME_Esapi);

		String strArchiveDropDown = ArchivalDropDownValue_Esapi;	
		if (strArchiveDropDown != null) {strArchiveDropDown=strArchiveDropDown.replace("'","''");}
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
		//String subXML="";
		String params="";
		
		
		
		query = "SELECT SuccessPath,FailurePath,DataClass FROM USR_0_SRO_ArchivalPath with(nolock) WHERE Archive_DropDown=:Archive_DropDown";
		params = "Archive_DropDown=="+strArchiveDropDown;
			
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML for Archival Path Details-- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML for Archival Path Details-- "+sOutputXML);

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
			returnValues = returnValues + objWorkList.getVal("SuccessPath")  + "~";
			returnValues = returnValues + objWorkList.getVal("FailurePath")  + "~";
			returnValues = returnValues + objWorkList.getVal("DataClass")  + "~";			
		}
		WriteLog("returnValues -- "+returnValues);
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