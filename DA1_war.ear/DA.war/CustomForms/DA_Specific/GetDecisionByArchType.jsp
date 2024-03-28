<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : Account Opening
//Module                     : Fetch Account Numbers
//File Name					 : FetchAccounts.jsp
//Author                     : Aishwarya Gupta
// Date written (DD/MM/YYYY) : 10-Mar-2015
//Description                : File to fetch accounts from middleware via invoking wfcustom
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../DA_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/DA/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<%
	
	try
	{
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("archType"), 1000, true) );
			String archivalTypeEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: archivalType: "+archivalTypeEsapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAMEEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: WSNAME: "+WSNAMEEsapi);
			
		String params = "";		
		String archivalType=archivalTypeEsapi.replace("'","''");
		String WSNAME=WSNAMEEsapi.replace("'","''");
		String Query="SELECT DECISION FROM USR_0_DA_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME=:WORKSTEP_NAME AND ARCHIVAL_TYPE LIKE '"+"%"+archivalType+"%"+"'";
	    params = "WORKSTEP_NAME=="+WSNAME;
		WFCustomXmlResponse WFCustomXmlResponseData=null;
		WFCustomXmlResponse objWFCustomXmlResponse=null;
		String inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	

		WriteLog("Input For Get Decision For Arch Type-->"+inputData);		
		String outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		WriteLog("Output For Get Decision For Arch Type-->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		WFCustomXmlList objWorkList=null;
		String maincode = WFCustomXmlResponseData.getVal("MainCode");
		String subXML="";
		String arrayVal="";
		if(maincode.equals("0"))
		{
			objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
					if(arrayVal=="")
					arrayVal=objWFCustomXmlResponse.getVal("DECISION");
					else
					arrayVal=arrayVal+"|"+objWFCustomXmlResponse.getVal("DECISION");
			}	
			out.clear();
			out.print(arrayVal);	
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e) 
	{
			out.clear();
			out.print("-1");
	}
%>



