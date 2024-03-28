<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : CBR_CSU_Fetch.jsp
//Author                     : Aishwarya Gupta
// Date written (DD/MM/YYYY) : 25-July-2014
//Description                : Custom server side Validations. Any server side validation can be 
							   added in the file later for subsequent requests
//---------------------------------------------------------------------------------------------------->

<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>


<%
String cardnumber = request.getParameter("cardnumber").replace("ENCODEDPLUS","+");
out.println(cardnumber);
WriteLog("CSU fetch starts");
String maincode = "0";
XMLParser xmlParser = new XMLParser();
String sJtsIp = wfsession.getJtsIp();
int iJtsPort = wfsession.getJtsPort();
String	sInputXML =	"<?xml version=\"1.0\"?>\n" +
		"<APAPMQPutGetMessage>\n" +
		"<Option>SRM_APMQPutGetMessage</Option>\n" +
		"<UserID>"+wfsession.getUserName()+"</UserID>\n" +
		"<CardNumber>"+cardnumber+"</CardNumber>\n"+ 
		"<SessionId>"+wfsession.getSessionId()+"</SessionId>\n"+
		"<EngineName>"+wfsession.getEngineName()+"</EngineName>\n" +
		"<RequestType>PrimeFetch~FinacleFetch</RequestType>\n" +
		"</APAPMQPutGetMessage>\n";	

WriteLog("Input xml for csu fetch "+sInputXML);

String cardStatus="";
String cbEligibleAmt = "";
String mobileNo = "";

try
{
	
	//String sMappOutPutXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
	String sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
	
	//String sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>12213421545546</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>12213421545546</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>1100</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType>Credit</CardType><CardSubType>Platinum</CardSubType><CardStatus>NORM</CardStatus><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>N</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2><CustomerName>TestUser</CustomerName><MobileNo>00971500101234</MobileNo></CardDetails></EE_EAI_MESSAGE>";
	
	WriteLog("outputxml for CSU fetch "+sMappOutPutXML);
	
	xmlParser.setInputXML(sMappOutPutXML);
	//out.println(xmlParser.getValueOf("CardCRNNumber"));
	cardStatus = xmlParser.getValueOf("CardStatus");
	cbEligibleAmt = xmlParser.getValueOf("RewardAmount");
	mobileNo = xmlParser.getValueOf("MobileNo");
}
catch(Exception e)
{
	WriteLog("Exception occurred at CSU fetch");
	maincode="111";
}	
out.clear();
out.println(cardStatus+"~"+cbEligibleAmt+"~"+mobileNo+"~"+maincode);	
%>

	