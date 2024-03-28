<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank Telegraphic Transfer
//Module                     : Integration Calls 
//File Name					 : RAOIntegration.jsp
//Author                     : Sivakumar P
//Date written (DD/MM/YYYY)  : 16-01-2017
//Description                : File to handle all the integration calls for SRB process (Initial Draft)
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../RMT_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>


<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<%
String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
%>
<TITLE> <%=wi_name_Esapi%>: Dedupe Check</TITLE>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style>
	@import url("/CU/webtop/en_us/css/docstyle.css");
</style>
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<script>
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :           
//Author                              :           Amandeep
//Description                		  :          

//***********************************************************************************//
</script>
<%!
	public static String readFileFromServer(String filename)
	{
		String xmlReturn="";
		try {
			File file = new File(filename);
			FileReader fileReader = new FileReader(file);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
			StringBuffer stringBuffer = new StringBuffer();
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
				stringBuffer.append("\n");
			}
			fileReader.close();
			System.out.println("Contents of file:");
			xmlReturn = stringBuffer.toString();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return xmlReturn;
	}
%>	
<%
		String sInputXML = "";
		String sMappOutPutXML = "";
	try
	{
			//String wi_name = request.getParameter("wi_name");
			String username="";
			//String ICIF_ID=request.getParameter("CIF_ID");
			String sCabName=customSession.getEngineName();
			logger.info("sCabName"+sCabName);			
			String sSessionId = customSession.getDMSSessionId();
			logger.info("sSessionId"+sSessionId);
			String totalRiskScore="";	
			String sessionId=sSessionId,engineName=sCabName;
			String sOutputXML="";
			String ReturnCode="";
			String inputXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n" + 
				"<EE_EAI_HEADER>\n" + 
				"<MsgFormat> RISK_SCORE_CALCULATION </MsgFormat>\n" + 
				"<MsgVersion>0001</MsgVersion>\n" + 
				"<RequestorChannelId> BPM</RequestorChannelId>\n" + 
				"<RequestorUserId>RAKUSER</RequestorUserId>\n" + 
				"<RequestorLanguage>E</RequestorLanguage>\n" + 
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" + 
				"<ReturnCode>911</ReturnCode>\n" + 
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" + 
				"<MessageId>123123453</MessageId>\n" + 
				"<Extra1>REQ||SHELL.JOHN</Extra1>\n" +
				"<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2>\n" + 
				"</EE_EAI_HEADER>\n" + 
				"<RiskScoreCalculationRequest>\n" + 
					"<CustomerId>1221342</CustomerId >\n" + 
					"<CustomerType>Individual</CustomerType>\n" + 
					"<FirstName>John</FirstName>\n" + 
					"<MidName>Fredrick</MidName>\n" +
					"<LastName>Mathews</LastName>\n" + 
					"<RMName> John</RMName>\n" + 
					"<EmploymentType>Salaried</EmploymentType>\n" + 
					"<Segment>MT001</Segment>\n" + 
					"<SubSegment>ECNT1</SubSegment>\n" + 
					"<Demographics>\n" +
						"<Demographic> </Demographic>\n" + 
						"<Demographic> </Demographic>\n" + 
					"</Demographics>\n" +
					"<Nationalities>\n" +
						"<Nationality> </Nationality>\n" +
						"<Nationality> </Nationality>\n" +
					"</Nationalities>\n" +
					"<CustomerCategory>Test </CustomerCategory>\n" + 
					"<Industries>\n" +
						"<Industry> Test </Industry>\n" + 
						"<Industry> Test </Industry>\n" + 
					"</Industries>\n" +
					"<ProductInfo> \n" +
						"<Product>SBA</Product>\n" +
						"<Currency>AED</Currency>\n" +
					"</ProductInfo>\n" +
					"<ProductInfo>\n" + 
						"<Product>SBA</Product>\n" +
						"<Currency>AED</Currency>\n" +
					"</ProductInfo>\n" +
					"<isPoliticallyExposed>N</isPoliticallyExposed>\n" +
			"</RiskScoreCalculationRequest>\n" + 
			"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";
				
			logger.info("\nInput XML For Risk Score Calculation::"+inputXML);
			sMappOutPutXML= WFCustomCallBroker.execute(inputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			logger.info("\nOutputEntityDetailsXML:\n"+sMappOutPutXML);	
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"RMTTesting"+File.separator+"RiskScore.txt");
			//logger.info("\nOutput XML For Risk Score Calculation::"+sMappOutPutXML);	
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";			
			logger.info("\n ReturnCode:\n"+ReturnCode);
			if(ReturnCode.equalsIgnoreCase("000"))
			{
				totalRiskScore =sMappOutPutXML.substring(sMappOutPutXML.indexOf("<TotalRiskScore>")+"</TotalRiskScore>".length()-1,sMappOutPutXML.indexOf("</TotalRiskScore>"));
				logger.info("\n totalRiskScore:\n"+totalRiskScore);
				out.clear();
				out.print(totalRiskScore);
			}
			else
			{
				out.clear();
				out.print("-1");
				logger.info("Error In Fetching Risk Score Value:"+ReturnCode);
			}
	}
	catch(Exception e)
	{
		out.clear();
		out.print("-1");
		sMappOutPutXML="Exception";
		logger.info("Exception In Calculate Risk Score");
	}
%>

