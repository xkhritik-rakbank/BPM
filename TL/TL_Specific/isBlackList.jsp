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
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<!---<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>--->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%!
	public String getInputXML(String CIFID,String username,String sessionId,String engineName)
	{
		return "<?xml version=\"1.0\"?>"
					+ "<BPM_APMQPutGetMessage_Input>\n"+
					"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+username+"</UserID>\n" +
					"<SessionId>"+sessionId+"</SessionId>\n"+
					"<EngineName>"+engineName+"</EngineName>\n" +
					"<RequestMessage>\n" +
					"<EE_EAI_MESSAGE>\n" +
					"<ProcessName>TL</ProcessName>\n" +
					"<EE_EAI_HEADER>\n" +
					"<MsgFormat>BLACKLIST_DETAILS</MsgFormat>\n" +
					"<MsgVersion>0001</MsgVersion>\n" +
					"<RequestorChannelId>BPM</RequestorChannelId>\n" +
					"<RequestorUserId>TABUSER</RequestorUserId>\n" +       
					"<RequestorLanguage>E</RequestorLanguage>\n" +       
					"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
					"<ReturnCode>0000</ReturnCode>\n" +
					"<ReturnDesc>REQ</ReturnDesc>\n" +       
					"<MessageId>BLACKLIST001</MessageId>\n" +
					"<Extra1>REQ||BPM.123</Extra1>\n" +					
					"<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>\n" +
					"</EE_EAI_HEADER>\n" +
					"<CustomerBlackListRequest>\n" +       
					"<BankId>RAK</BankId>\n" +       
					"<CIFID>"+CIFID+"</CIFID>\n" +       
					"<RetailCorpFlag>C</RetailCorpFlag>\n" +       
					"<Document>\n" +          
					"<DocumentType>PPT</DocumentType>\n" +
					"<DocumentRefNumber>A0334404</DocumentRefNumber>\n" +
					"</Document>\n" +       
					"<Document>\n" +          
					"<DocumentType>VISA</DocumentType>\n" +
					"<DocumentRefNumber>5555</DocumentRefNumber>\n" +       
					"</Document>\n" +
					"<FreeField1/>\n" +       
					"<FreeField2/>\n" +       
					"<FreeField3/>\n" +    
					"</CustomerBlackListRequest>\n" +
					"</EE_EAI_MESSAGE>\n" +
					"</RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";
		
	}
	public String getOutputXML(String inputXML)
	{
		return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"+
			"<EE_EAI_MESSAGE xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">    <EE_EAI_HEADER>       <MsgFormat>BLACKLIST_DETAILS</MsgFormat>       <MsgVersion>0001</MsgVersion>       <RequestorChannelId>BPM</RequestorChannelId>       <RequestorUserId>TABUSER</RequestorUserId>       <RequestorLanguage>E</RequestorLanguage>       <RequestorSecurityInfo>secure</RequestorSecurityInfo>       <ReturnCode>0000</ReturnCode>       <ReturnDesc>Successful</ReturnDesc>       <MessageId>BLACKLIST001</MessageId>       <Extra1>REP||BPM.123</Extra1>       <Extra2>2014-03-25T11:05:30.000+04:00</Extra2>    </EE_EAI_HEADER>    <CustomerBlackListResponse>       <BankId>RAK</BankId>       <Customer>          <CIFID>1362073</CIFID>          <RetailCorpFlag>R</RetailCorpFlag>          <PersonDetails>             <FirstName>FIRST NAME FOR 1362073</FirstName>             <MiddleName>MIDDLE NAME FOR  1362073</MiddleName>             <LastName>LAST NAME FOR 1362073</LastName>             <DateOfBirth>1960-01-05</DateOfBirth>          </PersonDetails>          <OrganizationDetails>             <CorporateName/>             <CountryOfIncorporation/>          </OrganizationDetails>          <CustomerStatus>INACT</CustomerStatus>          <CustDormStatus>N</CustDormStatus>          <Document>             <DocumentType>PPT</DocumentType>             <DocumentRefNumber>A0334404</DocumentRefNumber>             <DocumentDescription>PASSPORT</DocumentDescription>          </Document>          <Document>             <DocumentType>DRILV</DocumentType>             <DocumentRefNumber>35194SHJ</DocumentRefNumber>             <DocumentDescription/>          </Document>          <ContactDetails>             <PhoneFax>                <PhoneType>CELLPH1</PhoneType>                <PhoneValue>00971501362073</PhoneValue>             </PhoneFax>             <PhoneFax>                <PhoneType>HOMEPH1</PhoneType>                <PhoneValue>00971651362073</PhoneValue>             </PhoneFax>             <PhoneFax>                <PhoneType>OFFCPH1</PhoneType>                <PhoneValue>00971461362073</PhoneValue>             </PhoneFax>          </ContactDetails>          <StatusInfo>             <StatusType>Black List</StatusType>             <StatusFlag>N</StatusFlag>             <StatusNotes/>             <StatusReason/>             <StatusCode/>             <StatusOverAllFlag>N</StatusOverAllFlag>             <StatusList/>          </StatusInfo>          <StatusInfo>             <StatusType>Negative List</StatusType>             <StatusFlag>N</StatusFlag>             <StatusNotes>DELINQUENT FOR CREDIT CARD NO: 4581003709405008</StatusNotes>             <StatusReason>MIGRATION DEFAULT</StatusReason>             <StatusCode/>             <StatusOverAllFlag>Y</StatusOverAllFlag>             <StatusList>                <StatusDetails>                   <ProductType>CAPS</ProductType>                   <ReferenceNumber>4581003709405008</ReferenceNumber>                   <Unit>1362073</Unit>                   <ReasonNotes>DELINQUENT FOR CREDIT CARD NO: 4581003709405008</ReasonNotes>                   <ReasonCodeDesc>MIGRATION DEFAULT</ReasonCodeDesc>                   <ReasonCode>MIGR</ReasonCode>                   <CreationDate>2004-12-03</CreationDate>                   <CreatedBy>CARD CENTRE</CreatedBy>                   <Status>Y</Status>                </StatusDetails>             </StatusList>          </StatusInfo>       </Customer>    </CustomerBlackListResponse> </EE_EAI_MESSAGE>";

	}
%>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_num"), 1000, true) );
			String cif_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("cif_num Request.getparameter---> "+request.getParameter("cif_num"));
			WriteLog("cif_num Esapi---> "+cif_num_Esapi);

	String sOutPutXML = "";
	String sInputXML = "";
	String outputXML="";
	try
	{
		String sJtsIp = null;
		int iJtsPort = 0;
		String CIFID = cif_num_Esapi;
		sJtsIp = wfsession.getJtsIp();
		iJtsPort = wfsession.getJtsPort();
		String username=wfsession.getUserName();
		String sessionId=wfsession.getSessionId();
		String engineName=wfsession.getEngineName();
				
		sInputXML = getInputXML(CIFID,username,sessionId,engineName);
		WriteLog(sInputXML);
		sOutPutXML=WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1); //To be uncommented on SIT/UAT
		//sOutPutXML =getOutputXML(sInputXML); //To be commented on SIT/UAT
		WriteLog(sOutPutXML);
		String rowVal="";
		
		while(sOutPutXML.contains("<StatusFlag>"))
		{
			rowVal = sOutPutXML.substring(sOutPutXML.indexOf("<StatusFlag>")+"<StatusFlag>".length(),sOutPutXML.indexOf("</StatusFlag>"));
			WriteLog("rowVal2"+rowVal);
			if(rowVal.equals("Y"))
			{
			outputXML = rowVal;
			WriteLog("outputXML Inside"+rowVal);
			break;
			}
			else
			{
				outputXML = "N";
			}
			sOutPutXML = sOutPutXML.substring(sOutPutXML.indexOf("</StatusFlag>")+"</StatusFlag>".length());
			
			
		}
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
		sOutPutXML="Exception in BlackList.jsp"+((e.getMessage()==null)?"NULL":e.getMessage());
	}

	out.clear();
	out.println(outputXML);
%>