<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : DropDownState.jsp          
//Author                     : Nikita Singhal
// Date written (DD/MM/YYYY) : 07-Nov-2017
//Description                : Populating state values
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
<%@ include file="../TF_Specific/Log.process"%>
<%@ page import="java.net.URLDecoder"%>
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

			String URLDecoderchecklistname=URLDecoder.decode(request.getParameter("checklistname"));
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderchecklistname, 1000, true) );
			String URLDecoderchecklistname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		

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
		String checklistname=URLDecoderchecklistname_Esapi.replace("&amp;","&");
		
			String URLDecoderWINAME=URLDecoder.decode(request.getParameter("WINAME"));
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME, 1000, true) );
			String URLDecoderWINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
		String WINAME=URLDecoderWINAME_Esapi.replace("&amp;","&");
		WriteLog("--checklistname--"+checklistname);
		if (checklistname != null) {checklistname=checklistname.replace("'","");}
		if (WINAME != null) {WINAME=WINAME.replace("'","");}
		
			String URLDecoderServiceRequestCode=URLDecoder.decode(request.getParameter("ServiceRequestCode"));
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderServiceRequestCode, 1000, true) );
			String URLDecoderServiceRequestCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
		
		String ApplicationFormCode=URLDecoderServiceRequestCode_Esapi.replace("&amp;","&");
		if (ApplicationFormCode != null) {ApplicationFormCode=ApplicationFormCode.replace("'","");}
		
		String[] colNames = {"Checklist_Description","Option_checklist","Remarks","Workstep"};
		
		//Query2 = "SELECT * FROM USR_0_TF_ChecklistTable with (nolock) WHERE Checklist_Name=:checklistcombo";
		Query2 = "SELECT a.Checklist_Description,(select Option_checklist from USR_0_TF_SaveChecklistTable s with(nolock) where s.Checklist_Description=a.Checklist_Description and s.WIName = '"+WINAME+"' and s.Workstep=a.Workstep) as Option_checklist,(select Remarks from USR_0_TF_SaveChecklistTable s with(nolock) where s.Checklist_Description=a.Checklist_Description and s.WIName = '"+WINAME+"' and s.Workstep=a.Workstep) as Remarks,a.Workstep FROM USR_0_TF_ChecklistTable a with (nolock) WHERE a.Checklist_Name=:checklistcombo and (a.SRsIncluded = 'All' or CHARINDEX('"+ApplicationFormCode+"',a.SRsIncluded) > 0) and (a.SRsExcluded is null or a.SRsExcluded ='' or CHARINDEX('"+ApplicationFormCode+"',a.SRsExcluded) = 0)";
		params = "checklistcombo=="+checklistname;
		
		//WriteLog("Input Xml For Get Customer Data-- "+Query2);

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML For Winame: "+checklistname+" load checklist data -- "+inputXMLstate);
	
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		WriteLog("Output Xml For Winame: "+checklistname+" load checklist data ---- "+outputXMLstate);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLstate));
		mainCodeValuestate = xmlParserData.getVal("MainCode");
		int totalRecord=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		String recordsArray="";
		String tempRowvalues="";
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
					for(int i=0;i<colNames.length;i++)
					{
						if(tempRowvalues=="")
						{
							tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
						else if(tempRowvalues!="" && newRow==1)
						{
							tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
						else if(tempRowvalues!="" && newRow==0)
						{
							tempRowvalues=tempRowvalues+"~"+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
					}
			}
			out.clear();
			out.print(tempRowvalues);
			//WriteLog("tempRowvalues For Winame: "+checklistname+" Get Customer Data -- "+tempRowvalues);
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
%>