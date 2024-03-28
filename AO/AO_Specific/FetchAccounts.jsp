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
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
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

<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>



<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%   

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIFID"), 1000, true) );
			String CIFID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: CIFID_Esapi: "+CIFID_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SRNo"), 1000, true) );
			String SRNo_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: SRNo_Esapi: "+SRNo_Esapi);
		
     com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "Inside FetchAccounts.jsp", "Start");
	//WriteLog("Inside FetchAccounts.jsp");
	String mainCodeCheck="0";
	XMLParser mainCodeParser=null;
	String cifId = CIFID_Esapi;
	String srNo = SRNo_Esapi;
	String accountDetails="";
	XMLParser xmlParserData = new XMLParser();
	XMLParser xmlParserData2 = new XMLParser();
	String accountNumbers="";
	try	
	{
	
		 String sInputXML = "<?xml version=\"1.0\"?>"
		+ "<AO_APMQPutGetMessage_Input>\n"+
		"<Option>AO_APMQPutGetMessage</Option>\n"+
		"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
		"<CIFID>"+cifId+"</CIFID>\n"+ 
		"<SRNo>"+srNo+"</SRNo>\n"+ 
		"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
		"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
		"<RequestType>FetchAccounts</RequestType>\n" +
		"</AO_APMQPutGetMessage_Input>";
	
		//WriteLog("sInputXML :"+sInputXML);
		com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "sInputXML : ", sInputXML);
		//String sOutputXML= WFCallBroker.execute(sInputXML,wDSession.getM_objCabinetInfo().getM_strServerIP(),wfsession.getJtsPort(),1);
		
		String sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		
		//String sOutputXML  = "<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>FETCH_ACCOUNTS</MsgFormat><MsgVersion>0001</MsgVersion>		<RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER>	<FetchAccountsForSRResponse><BankId>RAK</BankId><CIFID>Fxxxxxx13</CIFID><CustomerName>abcxxxxxxxx</CustomerName>		<RCInd>R</RCInd><IslamicConventionalInd>C</IslamicConventionalInd><IsStaffFlg>N</IsStaffFlg><AccountDetails>			<AccountNumber>12341212121001</AccountNumber><AccountName>abdcxxxxxx</AccountName>         <IBanNo>ABCD123123434413413</IBanNo><AccountOpenDate>2011-05-05</AccountOpenDate><JointAccountFlg>Y</JointAccountFlg>			<SchmType>SBA</SchmType><SchmCode>123</SchmCode><AccountCcy>AED</AccountCcy><AccountStatus>A</AccountStatus>			<RelatedCIFDtls><RelCIFId>123XXXX</RelCIFId><RelCustomerName>ABCXXXXX</RelCustomerName><AdditionalInfo>					<RefType/><RefValue/></AdditionalInfo></RelatedCIFDtls><AdditionalInfo><RefType/><RefValue/></AdditionalInfo>		</AccountDetails><AccountDetails><AccountNumber>56781212121001</AccountNumber><AccountName>abdcxxxxxx</AccountName>          <IBanNo>ABCD123123434413413</IBanNo><AccountOpenDate>2011-05-05</AccountOpenDate><JointAccountFlg>Y</JointAccountFlg>			<SchmType>SBA</SchmType><SchmCode>123</SchmCode><AccountCcy>AED</AccountCcy><AccountStatus>A</AccountStatus>			<RelatedCIFDtls><RelCIFId>123XXXX</RelCIFId><RelCustomerName>ABCXXXXX</RelCustomerName><AdditionalInfo>				<RefType/><RefValue/></AdditionalInfo></RelatedCIFDtls><AdditionalInfo><RefType/><RefValue/></AdditionalInfo></AccountDetails><AdditionalInfo><RefType/><RefValue/></AdditionalInfo></FetchAccountsForSRResponse></EE_EAI_MESSAGE>";
		//WriteLog("sOutputXML :"+sOutputXML);
		com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "sOutputXML :", sOutputXML);
		if(sOutputXML.indexOf("<ReturnCode>0000</ReturnCode>")>-1)
		{
			//WriteLog("Fetch Account Successful");
			xmlParserData.setInputXML(sOutputXML);
			int countAccountDetails = xmlParserData.getNoOfFields("AccountDetails");
			for (int i = 0; i < countAccountDetails; i++) {
				accountDetails = xmlParserData.getNextValueOf("AccountDetails");
				xmlParserData2.setInputXML(accountDetails);
				accountNumbers += xmlParserData2.getValueOf("AccountNumber")+"#";
				//if(i==0) break;
			}
			if(accountNumbers.length()>0)
				accountNumbers = accountNumbers.substring(0,accountNumbers.lastIndexOf("#"));
				//WriteLog("account Numbers fetched:" + accountNumbers);
		}
		else
		{
			//WriteLog("Problem during fetching accounts");
			mainCodeParser=new XMLParser();
			mainCodeParser.setInputXML(sOutputXML);
			mainCodeCheck = mainCodeParser.getValueOf("ReturnCode");
		}	
	}
	catch(Exception e) 
	{
		//WriteLog("<OutPut>Error during Fetching account numbers</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.print(mainCodeCheck+"~"+accountNumbers+"~");		
%>



