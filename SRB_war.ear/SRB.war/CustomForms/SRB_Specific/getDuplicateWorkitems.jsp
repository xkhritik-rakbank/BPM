<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank Telegraphic Transfer
//Module                     : Integration Calls 
//File Name					 : SRBIntegration.jsp
//Author                     : Amitabh Pandey
//Date written (DD/MM/YYYY)  : 16-01-2017
//Description                : File to handle all the integration calls for SRB process (Initial Draft)
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------
Revision 	Date 			Author 			Description
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>



<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%
    String outputData="";
	String inputData="";
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlList objWorkList=null;
	try{
		 //WriteLog("\nInside SRB GetDuplicateWorkitem.jsp\n");
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );    
		String wi_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");

		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_type"), 1000, true) );    
		String cif_type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");

		String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );    
		String WSNAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");

		String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CategoryID"), 1000, true) ); 
		String CategoryID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
		
		String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCategoryID"), 1000, true) );    
		String SubCategoryID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
		
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String IntroductionDateTime = "";
		String intoducedBy = "";
		String SOLID = "";
		String Query="";
		String WI_NAME="";
		String params = "";
		String temp_table="<table id='duplicateWorkItemID' width='100%' border=1><TBODY><tr width=100% class='EWLabelRB2' bgcolor= '#990033'><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=left class='EWLabelRB2'><b>Duplicate Work-items</b></td></tr>";
		
		temp_table=temp_table+"<tr class='EWNormalGreenGeneral1'><th><b>Work-item Number</b></th><th><b>Initiated Date</b></th><th><b>Initiated By</b></th><th><b>SOL ID</b></th></tr>";
		
		WriteLog("\nInside SRB GetDuplicateWorkitem for wi_name "+wi_name);
		WriteLog("\nWSNAME "+WSNAME);
		if(WSNAME.equals("CSO"))
		{
			String test1= request.getParameter("tr_table");
			WriteLog("without ESAPI tr_table"+test1);
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tr_table"), 1000, true) );    
			String tr_table = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			String test2= request.getParameter("condition");
			WriteLog("without ESAPI condition"+test2);
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("condition"), 1000, true) );    
			String condition = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("after ESAPI tr_table"+input6);
			WriteLog("after ESAPI condition"+input7);
			condition=condition.replaceAll("&#x28;","(");
			condition=condition.replaceAll("&#x29;",")");
			condition=condition.replaceAll("&#x27;","\'");
			condition=condition.replaceAll("&#x3d;","=");
			condition=condition.replaceAll("&#x2f;","/");
			condition=condition.replaceAll("PERCENT","%");
			Query="SELECT EXT.WI_NAME,IntroductionDateAndTime,intoducedBy,SOLID from RB_SRB_EXTTABLE EXT,"+tr_table+" TR "+condition+" AND EXT.WI_NAME=TR.WI_NAME AND EXT.WI_NAME!=:WI_NAME";
		}
		else
		Query="SELECT DUPLICATEWI_NAME AS WI_NAME ,IntroductionDateAndTime,intoducedBy,SOLID from USR_0_SRB_DUPLICATEWORKITEMS where WI_NAME=:WI_NAME";
		
		//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		params = "WI_NAME=="+wi_name;
		inputData = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ Query + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
			
		WriteLog("Query For GetDuplicateWorkitem Input-->"+inputData);		
		outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		WriteLog("GetDuplicateWorkitem Output-->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");	
		int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		if(maincode.equals("0") && recordcount>0)
		{	
			objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{ 
					WI_NAME = objWorkList.getVal("WI_NAME");
					IntroductionDateTime = objWorkList.getVal("IntroductionDateAndTime");
					intoducedBy = objWorkList.getVal("intoducedBy");
					SOLID = objWorkList.getVal("SOLID");
					//WriteLog("WI_NAME Is-->"+WI_NAME);
					//WriteLog("IntroductionDateTime-->"+IntroductionDateTime);
					//WriteLog("intoducedBy-->"+intoducedBy);
					//WriteLog("SOLID-->"+SOLID);
					temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'><td>"+WI_NAME+"</td><td>"+IntroductionDateTime+"</td><td>"+intoducedBy+"</td><td>"+SOLID+"</td></tr>";
				}
				temp_table=temp_table+"</TBODY></TABLE>";
				WriteLog("Final Return Result "+temp_table);
				out.clear();
				//out.println(temp_table+"~"+"0");
				out.println(temp_table);
		}
		else if(maincode.equals("0") && recordcount==0)
		{
			out.clear();
			out.println("");
		}
		else
		{
		out.clear();
		out.println("-1");
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
		WriteLog("Exception in getting duplicate workitem list "+e);
		out.clear();
		out.println("-1");
	}
%>