<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@page language="java" session="true" %>

<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!---<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>--->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%!
	public String getInputXML(String CIFID,String username,String sessionId,String engineName)
	{
		return"<?xml version=\"1.0\"?>"
					+ "<BPM_APMQPutGetMessage_Input>\n"+
					"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+username+"</UserID>\n" +
					"<SessionId>"+sessionId+"</SessionId>\n"+
					"<EngineName>"+engineName+"</EngineName>\n" +
					"<RequestMessage><EE_EAI_MESSAGE>\n"+
					"<ProcessName>TL</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>CUSTOMER_SUMMARY</MsgFormat>\n"+
				"<MsgVersion>0000</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<RelatedPartyDetailsRequest>\n"+
					"<BankId>RAK</BankId>\n"+
					  "<CIFId>"+CIFID+"</CIFId>\n"+
					  "<AccNumber></AccNumber>\n"+
					  "<FetchType>C</FetchType>\n"+
					  "<RelationType>ALL</RelationType>\n"+					 
				"</RelatedPartyDetailsRequest>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";		
	}
	
	public String getOutputXML(String InputXML)
	{
		return "<?xml version='1.0'?>\n"+
				"<EE_EAI_MESSAGE>\n"+
				   "<EE_EAI_HEADER>\n"+
					  "<MsgFormat>CUSTOMER_SUMMARY</MsgFormat>\n"+
					  "<MsgVersion>0000</MsgVersion>\n"+
					  "<RequestorChannelId>BPM</RequestorChannelId>\n"+
					  "<RequestorUserId>RAKUSER</RequestorUserId>\n"+
					  "<RequestorLanguage>E</RequestorLanguage>\n"+
					  "<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
					  "<ReturnCode>0000</ReturnCode>\n"+
					  "<ReturnDesc>Successful</ReturnDesc>\n"+
					  "<MessageId>143282709427399867</MessageId>\n"+
					  "<Extra1>REP||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
					  "<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
					"</EE_EAI_HEADER>\n"+
					"<RelatedPartyDetailsResponse>\n"+
						"<BankId>RAK</BankId>\n"+
						"<RCIFDetails>\n"+
						"<RCIFId>2100561</RCIFId>\n"+
						 "<RCIFIdStatus>ACTVE</RCIFIdStatus>\n"+
						 "<IsIBEnabled>Y</IsIBEnabled>\n"+
						 "<FName>Julius</FName>\n"+
						 "<MName>Augustus</MName>\n"+
						 "<LName>Ceasar</LName>\n"+
						 "<MobileNo>00971501512018</MobileNo>\n"+
						 "<EmailId>1234567@RAKBANK.AE</EmailId>\n"+
						 "<DOB>1900-01-01</DOB>\n"+
						 "<PassportNo>DUMMY1512018</PassportNo>\n"+
						 "<SubRelationshipStatus>Authorized Signatory</SubRelationshipStatus>\n"+
						 "</RCIFDetails>\n"+
						 "<RCIFDetails>\n"+
						 "<RCIFId>2100562</RCIFId>\n"+
						 "<RCIFIdStatus>ACTVE</RCIFIdStatus>\n"+
						 "<IsIBEnabled>Y</IsIBEnabled>\n"+
						 "<FName>Mark</FName>\n"+
						 "<MName></MName>\n"+
						 "<LName>Antony</LName>\n"+
						 "<MobileNo>00971501512018</MobileNo>\n"+
						 "<EmailId>1234567@RAKBANK.AE</EmailId>\n"+
						 "<DOB>1900-01-01</DOB>\n"+
						 "<PassportNo>DUMMY1512018</PassportNo>\n"+                "<SubRelationshipStatus>Shareholder</SubRelationshipStatus>\n"+
						 "</RCIFDetails>\n"+
						 "<RCIFDetails>\n"+
						  "<RCIFId>2100563</RCIFId>\n"+
						 "<RCIFIdStatus>ACTVE</RCIFIdStatus>\n"+
						 "<IsIBEnabled>Y</IsIBEnabled>\n"+
						 "<FName>Decius</FName>\n"+
						 "<MName>MIDDLE NAME FOR 1512018</MName>\n"+
						 "<LName>Brutus</LName>\n"+
						 "<MobileNo>00971501512018</MobileNo>\n"+
						 "<EmailId>1234567@RAKBANK.AE</EmailId>\n"+
						 "<DOB>1900-01-01</DOB>\n"+
						 "<PassportNo>DUMMY1512018</PassportNo>\n"+                "<SubRelationshipStatus>Shareholder</SubRelationshipStatus>\n"+
						 "</RCIFDetails>\n"+
						 "<RCIFDetails>\n"+
						 "<RCIFId>2100568</RCIFId>\n"+
						 "<RCIFIdStatus>ACTVE</RCIFIdStatus>\n"+
						 "<IsIBEnabled>Y</IsIBEnabled>\n"+
						 "<FName>Gaius</FName>\n"+
						 "<MName>MIDDLE NAME FOR 1512018</MName>\n"+
						 "<LName>Cassius</LName>\n"+
						 "<MobileNo>00971501512018</MobileNo>\n"+
						 "<EmailId>1234567@RAKBANK.AE</EmailId>\n"+
						 "<DOB>1900-01-01</DOB>\n"+
						 "<PassportNo>DUMMY1512018</PassportNo>\n"+                "<SubRelationshipStatus>Shareholder</SubRelationshipStatus>\n"+
						 "</RCIFDetails>\n"+
						 
				   "</RelatedPartyDetailsResponse>\n"+
				"</EE_EAI_MESSAGE>\n";
	}
%>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_num"), 1000, true) );
			String cif_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("cif_num Request.getparameter---> "+request.getParameter("cif_num"));
			WriteLog("cif_num Esapi---> "+cif_num_Esapi);

	String sOutPutXML = "";
	String sInputXML = "";
	try
	{
		String sJtsIp = null;
		int iJtsPort = 0;
		String CIFID = cif_num_Esapi;
		
	//	sJtsIp = wfsession.getJtsIp();
		sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
		//iJtsPort = wfsession.getJtsPort();
		iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
		//String username=wfsession.getUserName();
		String username= wDSession.getM_objUserInfo().getM_strUserName();
		//String sessionId=wfsession.getSessionId();
		String sessionId= wDSession.getM_objUserInfo().getM_strSessionId();
		//String engineName=wfsession.getEngineName();	
		String engineName= wDSession.getM_objCabinetInfo().getM_strCabinetName();	
		
		sInputXML = getInputXML(CIFID,username,sessionId,engineName);
		WriteLog("Input xml for customer summary"+sInputXML);
		//sOutPutXML=WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1); //To be uncommented on SIT/UAT
		sOutPutXML=NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML); //To be uncommented on SIT/UAT
		//sOutPutXML =getOutputXML(sInputXML); //To be commented on SIT/UAT
		WriteLog("Output xml for customer summary"+sOutPutXML);								
	}
	catch(Exception e)
	{
		e.printStackTrace();
		sOutPutXML="Exception"+((e.getMessage()==null)?"NULL":e.getMessage());
	}

	out.clear();
	out.println(sOutPutXML);
%>