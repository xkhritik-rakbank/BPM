<%@ include file="../DSRProcessSpecific/Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@page import="java.io.DataInputStream"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="com.ibm.mq.MQMessage"%>
<%@page import="java.net.*"%>
<%@page import="java.io.InputStream"%>

<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/DSR_RBCommon.js"></script><script>
function EnableDisablechkbox()
{
var objDataForm=document.forms["dataform"];

var objWI_Obj=window.top.wi_object;
if (objDataForm.VD_MoMaidN.checked==true)
{
	objDataForm.VD_POBox.disabled=false;
	objDataForm.VD_Oth.disabled=false;
	objDataForm.VD_MRT.disabled=false;
    objDataForm.VD_StaffId.disabled=false;
	objDataForm.VD_EDC.disabled=false;
	//objDataForm.VD_PassNo.disabled=false;
	//objDataForm.VD_NOSC.disabled=false;
	//objDataForm.VD_SD.disabled=false;
	objDataForm.VD_TELNO.disabled=false;
	objDataForm.VD_DOB.disabled=false;
	objDataForm.VD_TINCheck.checked=false;
	objDataForm.VD_TINCheck.disabled=true;	
}
else
	{
	objDataForm.VD_POBox.checked=false;
	objDataForm.VD_Oth.checked=false;
	objDataForm.VD_MRT.checked=false;
	objDataForm.VD_StaffId.checked=false;
	objDataForm.VD_EDC.checked=false;
	//objDataForm.VD_PassNo.checked=false;
	//objDataForm.VD_NOSC.checked=false;
	//objDataForm.VD_SD.checked=false;
	objDataForm.VD_TELNO.checked=false;
	objDataForm.VD_DOB.checked=false;
	objDataForm.VD_POBox.disabled=true;
	objDataForm.VD_Oth.disabled=true;
	objDataForm.VD_MRT.disabled=true;
    objDataForm.VD_StaffId.disabled=true;
	objDataForm.VD_EDC.disabled=true;
	//objDataForm.VD_PassNo.disabled=true;
	//objDataForm.VD_NOSC.disabled=true;
	//objDataForm.VD_SD.disabled=true;
	objDataForm.VD_TELNO.disabled=true;
	objDataForm.VD_DOB.disabled=true;
	objDataForm.VD_TINCheck.disabled=false;
	}

}
</script>

<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;
	boolean bError=false;
	String suserName=null;
	String sCustomerName="";
	String sUserEmailID="";
	String sExpiryDate="";
	String sCardCRNNo="";
	String sSourceCode="";
	String sExtNo="";
	String sMobileNo="";
	String sAccessedIncome="";		
	String sCardType="";
	String sOutputXMLCustomerInfoList="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	Hashtable ht =new  Hashtable();
	String BranchName ="";
	String sProcessName ="";
	String branchCode="";
	String sInputXML="";
	String sFirstName="";
	String sMiddleName="";
	String sLastName="";
	String sGeneralStat="";
	String sEliteCustomerNo="";
	String sAccountNo="";

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", request.getParameter("ProcessName"), 1000, true) );
	String ProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessName: "+ProcessName);
	WriteLog("Integration jsp: ProcessName 1: "+request.getParameter("ProcessName"));

	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessInstanceId"));

	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DebitCN", request.getParameter("DebitCN"), 1000, true) );
	String DebitCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: DebitCN: "+DebitCN);
	WriteLog("Integration jsp: DebitCN 1: "+request.getParameter("DebitCN"));
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("cards", request.getParameter("cards"), 1000, true) );
	String cards = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: cards: "+cards);
	WriteLog("Integration jsp: cards 1: "+request.getParameter("cards"));
	
	String URLDecoderProcessName=URLDecoder.decode(request.getParameter("ProcessName"));
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderProcessName, 1000, true) );
	String DecoderProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchCodeName", request.getParameter("BranchCodeName"), 1000, true) );
	String BranchCodeName_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("Integration jsp: BranchCodeName: "+BranchCodeName_1);
	WriteLog("Integration jsp: BranchCodeName 1: "+request.getParameter("BranchCodeName"));

	try{
		WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		WriteLog("sCabname :"+sCabname);
        sSessionId    = wDUserInfo.getM_strSessionId();
		WriteLog("sSessionId :"+sSessionId);
		sJtsIp = wDCabinetInfo.getM_strServerIP();
        iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
		WriteLog("iJtsPort :"+iJtsPort);
		suserName = wDUserInfo.getM_strUserName()+"";
		WriteLog("suserName :"+suserName);
	}catch(Exception ignore){
		bError=true;
		WriteLog(ignore.toString());
	}	
	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); 
		out.println("</script>");
	}
	else
	{
		String pName = ProcessName;
		if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))
		{
				
			sGeneralStat="";
			//Added Below by Amandeep General Status
			String strCompCode="",strReasonCode="";	

				sInputXML =	"<?xml version=\"1.0\"?>\n" +
						"<APAPMQPutGetMessage_DSR_Input>\n" +
						"<Option>APMQPutGetMessage_DSR</Option>\n" +
						"<UserID>"+suserName+"</UserID>";	
					sInputXML =	sInputXML + "<RequestType>Cards</RequestType>";
					sInputXML =	sInputXML + "<CardNo>"+DebitCN+"</CardNo>";
					sInputXML =	sInputXML + "<SessionId>"+sSessionId+"</SessionId>\n"+
						"<EngineName>"+sCabname+"</EngineName>\n" +
						"</APAPMQPutGetMessage_DSR_Input>\n";
						
				

				WriteLog("sInputXML Cards: "+sInputXML);
				String responseMsg="";
				try{
					//sInputXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>BPMUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>success</ReturnDesc><MessageId>[B@36fc36fc</MessageId><Extra1>REQ||BPM.123</Extra1><Extra2>2014-06-05T12:45:08.045+04:00</Extra2></EE_EAI_HEADER><CardDetails><BankId>RAK</BankId><CIFID></CIFID><CardCRNNumber></CardCRNNumber><CardNumber>5546370220955089</CardNumber><ResponseReqd></ResponseReqd></CardDetails></EE_EAI_MESSAGE>";
					WriteLog("responseMsg Cards before WFCallBroker");
					//responseMsg= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					responseMsg = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);

					//responseMsg = "<APMQPutGetMessage_DSR_Output><Option>APMQPutGetMessage_DSR</Option><Output><Message><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardDetails><ResponseFor>P</ResponseFor><BankId>RAK</BankId><CustId>FDSGS2313</CustId><CardNumber>5546370220955089</CardNumber><AccountCategory>P</AccountCategory><CardAcctNum>5546370220955089</CardAcctNum><LastStatementDate>1900-01-01</LastStatementDate><PreviousBalance>0.00</PreviousBalance><Purchases>0.00</Purchases><LatePaymentCharges>0.00</LatePaymentCharges><ServiceCharges>0.00</ServiceCharges><CashAdvances>0.00</CashAdvances><Payments>0.00</Payments><TotalAmtDue>0.00</TotalAmtDue><MinAmtDue>0.00</MinAmtDue><PymtDueDate>1900-01-01</PymtDueDate><TotalCreditLimit>0.00</TotalCreditLimit><AuthorizedNotSettled>0.00</AuthorizedNotSettled><AvailableCreditLimit>0.00</AvailableCreditLimit><TotalCashLimit>0.00</TotalCashLimit><AvailableCashLimit>0.00</AvailableCashLimit><RewardAmount>0.00</RewardAmount><OverdueAmount>0.00</OverdueAmount><OutstandingBalance>0.00</OutstandingBalance><PointsOpeningBalance>1212</PointsOpeningBalance><EarnedDuringMonth>1212</EarnedDuringMonth><RedeemedDuringMonth>121</RedeemedDuringMonth><PointsClosingBalance>2303</PointsClosingBalance><ExpiryDate>1900-01-01</ExpiryDate><PrimaryCardHolderName>Vinodh</PrimaryCardHolderName><CardType/><CardSubType>L</CardSubType><CardStatus>001</CardStatus><CardIssuer/><Telephone/><NextStatementDate>1900-01-01</NextStatementDate><IsDisputedTran>Y</IsDisputedTran><IsCashbackForfeited>Y</IsCashbackForfeited><MobileNumber>00971500105301</MobileNumber><DispatchChannel>021</DispatchChannel><DispatchDate>1900-01-01</DispatchDate><CardCRNNumber>021030802</CardCRNNumber><FreeText1/><FreeText2/><FreeText3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardDetails></EE_EAI_MESSAGE></Message><Exception><CompletionCode>0</CompletionCode><ReasonCode>0</ReasonCode><Description>success</Description></Exception></Output></APMQPutGetMessage_DSR_Output>";
	
					WriteLog("responseMsg cards"+responseMsg);
					
					strCompCode	= responseMsg.substring(responseMsg.indexOf("<CompletionCode>")+"<CompletionCode>".length(),responseMsg.indexOf("</CompletionCode>"));
                    WriteLog("strCompCode cards"+strCompCode);					
					strReasonCode= responseMsg.substring(responseMsg.indexOf("<ReasonCode>")+"<ReasonCode>".length(),responseMsg.indexOf("</ReasonCode>"));
					WriteLog("strReasonCode cards"+strReasonCode);
					String strReturnCode= responseMsg.substring(responseMsg.indexOf("<ReturnCode>")+"<ReturnCode>".length(),responseMsg.indexOf("</ReturnCode>"));
					WriteLog("strReturnCode cards"+strReturnCode);
					if(strReturnCode!=null && (strReturnCode.equals("0000")||strReturnCode.equals("000")))
					{
						sGeneralStat = responseMsg.substring(responseMsg.indexOf("<CardStatus>")+"<CardStatus>".length(),responseMsg.indexOf("</CardStatus>"));
						WriteLog("sGeneralStat cards"+sGeneralStat);
						sCardType = sCardType = 
responseMsg.substring(responseMsg.indexOf("<CardSubType>")+"<CardSubType>".length(),responseMsg.indexOf("</CardSubType>"));
						//sMobileNo = responseMsg.substring(responseMsg.indexOf("<MobileNumber>")+"<MobileNumber>".length(),responseMsg.indexOf("</MobileNumber>"));
						sExpiryDate=responseMsg.substring(responseMsg.indexOf("<ExpiryDate>")+"<ExpiryDate>".length(),responseMsg.indexOf("</ExpiryDate>"));
						sExpiryDate=sExpiryDate.substring(5,7)+"/"+sExpiryDate.substring(2,4);
					}
					else{
						WriteLog("Could not find the debit card No.");
						out.println("<script>alert(\"Could Not Retrieve Card Status Please Contact Administrator\")</script>");
						out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
					}	
				}
				catch(Exception e){
					WriteLog("Error:"+e.getMessage());	
				}
				//if((!(sGeneralStat==null||sGeneralStat.equals(""))) && sGeneralStat.equalsIgnoreCase("NORM"))
				if((!(sGeneralStat==null||sGeneralStat.equals(""))) &&  !sGeneralStat.equalsIgnoreCase("CLSB"))
				{
				try{
						String responseMsgCust = "";
							sInputXML =	"<?xml version=\"1.0\"?>\n" +
								"<APAPMQPutGetMessage_DSR_Input>\n" +
								"<Option>APMQPutGetMessage_DSR</Option>\n" +
								"<UserID>"+suserName+"</UserID>";	
							sInputXML =	sInputXML + "<RequestType>Customer</RequestType>";
							sInputXML =	sInputXML + "<CardNo>"+DebitCN+"</CardNo>";
							sInputXML =	sInputXML + "<SessionId>"+sSessionId+"</SessionId>\n"+
								"<EngineName>"+sCabname+"</EngineName>\n" +
								"</APAPMQPutGetMessage_DSR_Input>\n";

						WriteLog("sInputXML Customer: "+sInputXML);
					
						//sInputXML="<EE_EAI_MESSAGE> <EE_EAI_HEADER><MsgFormat>CUSTOMER_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>BPMUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>success</ReturnDesc><MessageId>[B@4fa94fa9</MessageId><Extra1>REQ||BPM.123</Extra1><Extra2>2014-06-05T12:45:09.045+04:00</Extra2></EE_EAI_HEADER><CustomerDetails><BankId>RAK</BankId><CIFID></CIFID><ACCType>CC</ACCType><ACCNumber>5546370220955089</ACCNumber><InquiryType>Customer</InquiryType></CustomerDetails></EE_EAI_MESSAGE>";
						//responseMsgCust= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						responseMsgCust = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);

						WriteLog("Customer Response"+responseMsgCust);	
					
						//responseMsgCust = "<APMQPutGetMessage_DSR_Output><Option>APMQPutGetMessage_DSR</Option><Output><Message><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CUSTOMER_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>OMF</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CustomerDetails><BankId>RAK</BankId><CIFID>123456</CIFID><ACCNumber>1234567</ACCNumber><ECRNumber>123456756</ECRNumber><FirstName>EQN</FirstName><MiddleName>EQ12345</MiddleName><LastName>asjdguj</LastName><FullName>CustomerName</FullName><MothersName>EA-Individual</MothersName><DOB>1964-10-11</DOB><Gender>M</Gender><Nationality>IND</Nationality><AddrDet><AddressType>OFFICE</AddressType><HoldMailFlag>N</HoldMailFlag><HoldMailBCName>bbbbbb</HoldMailBCName><HoldMailReason>xxxxxxx</HoldMailReason><ReturnFlag>N</ReturnFlag><AddrPrefFlag>Y</AddrPrefFlag><AddrLine1>12345</AddrLine1><AddrLine2>PREMISE NAME FOR 0326407</AddrLine2><AddrLine3>STREET NAME FOR 0326407</AddrLine3><AddrLine4>Addr line 4</AddrLine4><POBox>12346</POBox><City>DXB</City><Country>AE</Country></AddrDet><PhnDet><PhnType>OFFCPH1</PhnType><PhnPrefFlag>N</PhnPrefFlag><PhnCountryCode>00971</PhnCountryCode><PhnLocalCode>420326407</PhnLocalCode><PhoneNo>00971420326407</PhoneNo></PhnDet><EmailDet><MailIdType>ELML1</MailIdType><MailPrefFlag>Y</MailPrefFlag><EmailID>abcd@dfg.com</EmailID></EmailDet><DocumentDet><DocType>Passport</DocType><DocId>sf57Y</DocId><DocExpDt>1964-10-11</DocExpDt></DocumentDet><FreeField1/><FreeField2/><FreeField3/><FreeField4/><FreeField5/><FreeField6/><FreeField7/></CustomerDetails></EE_EAI_MESSAGE></Message><Exception><CompletionCode>0</CompletionCode><ReasonCode>0</ReasonCode><Description>success</Description></Exception></Output></APMQPutGetMessage_DSR_Output>";
		
						strCompCode	= responseMsgCust.substring(responseMsgCust.indexOf("<CompletionCode>")+16,responseMsgCust.indexOf("</CompletionCode>"));	
						strReasonCode= responseMsgCust.substring(responseMsgCust.indexOf("<ReasonCode>")+12,responseMsgCust.indexOf("</ReasonCode>"));
						String strReturnCode= responseMsgCust.substring(responseMsgCust.indexOf("<ReturnCode>")+"<ReturnCode>".length(),responseMsgCust.indexOf("</ReturnCode>"));
						if(strReturnCode!=null && (strReturnCode.equals("0000")||strReturnCode.equals("000")))
						{
							if(responseMsgCust.indexOf("<FullName>") != -1)
								sCustomerName= responseMsgCust.substring(responseMsgCust.indexOf("<FullName>")+"<FullName>".length(),responseMsgCust.indexOf("</FullName>"));
							if(responseMsgCust.indexOf("<ECRNumber>") != -1)
								sEliteCustomerNo= responseMsgCust.substring(responseMsgCust.indexOf("<ECRNumber>")+"<ECRNumber>".length(),responseMsgCust.indexOf("</ECRNumber>"));
							if(responseMsgCust.indexOf("<PhnType>MobileNumber1</PhnType>") != -1)
								sMobileNo=responseMsgCust.substring(responseMsgCust.indexOf("<PhoneNo>",responseMsgCust.indexOf("<PhnType>MobileNumber1</PhnType>"))+"<PhoneNo>".length(),responseMsgCust.indexOf("</PhoneNo>",responseMsgCust.indexOf("<PhnType>MobileNumber1</PhnType>")));
							
							WriteLog("Integration call sMobileNo: "+sMobileNo);
							if(responseMsgCust.indexOf("<MailPrefFlag>Y</MailPrefFlag>") != -1)
								sUserEmailID = responseMsgCust.substring(responseMsgCust.indexOf("<MailPrefFlag>Y</MailPrefFlag>") + 39, responseMsgCust.indexOf("<MailPrefFlag>Y</MailPrefFlag>") + 39 + responseMsgCust.substring(responseMsgCust.indexOf("<MailPrefFlag>Y</MailPrefFlag>") + 39 ).indexOf("</EmailID>") );
						}
						else
						{
							WriteLog("Could not find the customer info.");
							out.println("<script>alert(\"Could Not Retrieve Customer Status Please Contact Administrator\")</script>");
							out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
						}
					}
					catch(Exception e){
					WriteLog("Error:"+e.getMessage());	
					}
				}
				else
				{
					
					if(sGeneralStat==null||sGeneralStat.equals("")){
					WriteLog("Could not find the debit card No.2");
					out.println("<script>alert(\"Could Not Retrieve Card Status Please Contact Administrator\")</script>");
					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
					}
					else {
					WriteLog("Card status is CLSB");
					out.println("<script>alert(\"Card status is CLSB. Cannot proceed with the request.\")</script>");
					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
					}
					
				}
			if(sGeneralStat==null||sGeneralStat.equals(""))
			{
				WriteLog("Could not find the debit card No.");
				out.println("<script>alert(\"Could Not Retrieve Card Status Please Contact Administrator\")</script>");
				out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
				
			}
			
			WriteLog("Inside...A "+DecoderProcessName);
			if(DecoderProcessName.equalsIgnoreCase("Debitcard Service Request - Cash Back Request"))
			{
			
				if (sGeneralStat.equals("0001"))
				{
						WriteLog("Inside...");
					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\";alert('The Status of Card is Closed. Request cannot be Processed');</script>");
				}
			}	
		}
		else
		{
			WriteLog("Inside1...");
			String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+ProcessInstanceId+"</ProcessInstanceId></WMFetchProcessInstanceAttributes_Input>";
			WriteLog("Inside2222-"+sInputXML1);
			String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);	
			WriteLog("Inside33-"+strOutputXMLCat1);
			objWorkListXmlResponse = new WFXmlResponse("");
			objWorkListXmlResponse.setXmlString(strOutputXMLCat1);
			objWorkList = objWorkListXmlResponse.createList("Attributes","Attribute"); 			  
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{  
				  DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());
				  WriteLog(objWorkList.getVal("Name").toString()+"--"+objWorkList.getVal("Value").toString());						
			}
			
			sCustomerName=DataFormHT.get("DCI_CName").toString();
			sExpiryDate=DataFormHT.get("DCI_ExpD").toString();
			sSourceCode=DataFormHT.get("DCI_SC").toString();
			sExtNo=DataFormHT.get("DCI_ExtNo").toString();
			sMobileNo=DataFormHT.get("DCI_MONO").toString();
			//sAccessedIncome=DataFormHT.get("DCI_AccInc").toString();
			sCardType=DataFormHT.get("DCI_CT").toString();
			sGeneralStat=DataFormHT.get("DCI_CAPS_GENSTAT").toString();
			sEliteCustomerNo=DataFormHT.get("DCI_ELITECUSTNO").toString();
			
			if(DataFormHT.get("USER_BRANCH")!=null&&!DataFormHT.get("USER_BRANCH").equals(""))
			{
				//Get Branch Name corresponding to branch code
				String sInputXML2 ="<?xml version=\"1.0\"?>" + 				
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>RB_GetBranchName</ProcName>" +						
						"<Params>'"+DataFormHT.get("USER_BRANCH")+"'</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabname+"</EngineName>" +
						"</APProcedure2_Input>";

				
				try
				{
					BranchName= WFCallBroker.execute(sInputXML2,sJtsIp,iJtsPort,1);
					WriteLog(BranchName);
					if(BranchName.equals("") || Integer.parseInt(BranchName.substring(BranchName.indexOf("<MainCode>")+10 , BranchName.indexOf("</MainCode>")))!=0)	{
						bError= true;
					}
				}catch(Exception exp){
					bError=true;
				}
				BranchName = BranchName.substring(BranchName.indexOf("<Results>")+9,BranchName.indexOf("</Results>"));
			}
		}	
	}
		
	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);
	int dd = dt.getDate();
	int mm= dt.getMonth()+1;
	int yy = dt.getYear()+1900;
	int hour= dt.getHours();
	int min= dt.getMinutes();
	String sysDate_CCB = mm+"/"+dd+"/"+yy+" "+hour+":"+min;

	//Processing for ProcessName
	String sDisplayText="";
	if(ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase("")){ 
	  sProcessName=DataFormHT.get("wi_name").toString().substring(DataFormHT.get("wi_name").toString().length()-3,DataFormHT.get("wi_name").toString().length());
	  WriteLog(" sProcessName inn DSR Commonblocks:"+sProcessName);
	  if(sProcessName.equalsIgnoreCase("CBR"))
		  sDisplayText="Cash Back Request";
  	  if(sProcessName.equalsIgnoreCase("DCB"))
		  sDisplayText="Debit Card Blocking Request";
  	  if(sProcessName.equalsIgnoreCase("-MR"))
		  sDisplayText="Miscellaneous Requests";
  	  if(sProcessName.equalsIgnoreCase("ODC"))
		  sDisplayText="Other Debit Card Requests--"+DataFormHT.get("request_type").toString();
	}
%>

<script>
var sDate='<%=sDate%>';
</script>

<input type="text" name="Header" readOnly size="24" style='display:none' value='Request Type:&nbsp;&nbsp;<%=sDisplayText%>'>

<input type="text" name="Header" readOnly size="24" style='display:none' value='Credit Card Information          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;                 RegistrationNo:<%=DataFormHT.get("wi_name")%>'>

<% String temp = cards;
%><table border="1" cellspacing="1" cellpadding="1" width=100% >
	
	 
  <%if(ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase("")){ 
       sProcessName=DataFormHT.get("wi_name").toString().substring(DataFormHT.get("wi_name").toString().length()-3,DataFormHT.get("wi_name").toString().length());%>
		 <tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=4 align=center class="EWLabelRB2"><b><%=sDisplayText%> </b></td>
				
			</tr>
		  <tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=2 align=left class="EWLabelRB2"><b>Debit Card Information &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Branch:&nbsp;&nbsp;&nbsp;&nbsp;<%=BranchName==null?"":BranchName%></b></td>
				<td colspan=1 align=left class="EWLabelRB2"><b><%=DataFormHT.get("BU_UserName").toString()%><%=sDate%></b></td>
				<td colspan=1 align=left class="EWLabelRB2"><b><%=DataFormHT.get("wi_name")%></b></td>
			</tr>
			
		 <TR><td nowrap width="155" height="16" class="EWLabelRB" colspan=1 id="DCI_DebitCN">Debit Card No.</td>
			<td nowrap  width="150" colspan=1><input type="text" name="DCI_DebitCN" value='<%=DataFormHT.get("DCI_DebitCN")%>' size="8" maxlength=19 style='width:150px;' disabled ></td>
		</tr> 
	<%}else{%>
				
			  <tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=4 align=left class="EWLabelRB2"><b>Debit Card Information </b></td>
				<!--<input type="text" name="DCI_DebitCN" value='<%=temp%>' size="20" maxlength=19 style='width:150px;' disabled >-->
			</tr>
	<%}%>

		<TR>
			<td nowrap width="155" height="16" class="EWLabelRB" id="DCI_CName">Customer Name</td>
			<td nowrap  width="150"><input type="text" name="DCI_CName" value='<%=sCustomerName%>' disabled size="8" maxlength=90 style='width:150px;' ><input type="text" name="userEmailID" value='<%=sUserEmailID%>' style="visibility:hidden"></td>
			<td nowrap width="190" height="16" class="EWLabelRB" id="DCI_ExpD">Expiry Date</td>
			<td><input type="hidden" name="DCI_ExpD" value='<%=sExpiryDate%>'  disabled size="8" maxlength=6 style='width:150px;'>
			<input type="text" name="DCI_ExpDHid" value='Masked'  disabled size="8" maxlength=5 style='width:150px;'></td>
		</tr>
		<TR>
			<td nowrap width="100" height="16" class="EWLabelRB" id="DCI_CT">Card Type</td>
			<td nowrap width="180"><input type="text" name="DCI_CT" value='<%=sCardType%>' disabled size="8" maxlength=30 style='width:150px;' ></td>        
			<td nowrap width="170" height="16" class="EWLabelRB" id="DCI_MONO">Mobile No.</td>
			<td nowrap width="190"><input type="text" name="DCI_MONO" value='<%=sMobileNo%>' disabled size="8" maxlength=12 style='width:150px;'></td>
		</tr>
		<TR>
			<td nowrap width="100" height="16" class="EWLabelRB" id="DCI_CAPS_GENSTAT">General Status</td>
			<td nowrap width="180"><input type="text" name="DCI_CAPS_GENSTAT" value='<%=sGeneralStat%>' disabled size="8" maxlength=30 style='width:150px;' ></td>        
			<td nowrap width="170" height="16" class="EWLabelRB" id="DCI_ELITECUSTNO">Master No</td>
			<td nowrap width="190"><input type="text" name="DCI_ELITECUSTNO" value='<%=sEliteCustomerNo%>' disabled size="8" maxlength=12 style='width:150px;'></td>
		</tr>
		<tr>
			<td nowrap width="155" height="16" class="EWLabelRB" id="DCI_ExtNo">Ext No.</td> 
			<td nowrap  width="190"><input type="text" name="DCI_ExtNo" value='<%=sExtNo%>' size="8" maxlength=4 style='width:150px;' onkeyup=validateKeys(this,'DSR_Common') onblur=validateKeys_OnBlur(this,'DSR_Common')  ></td>
		</tr>
	</table>


	<table border="1" cellspacing="1" cellpadding="1" width=100% >
		<tr class="EWHeader" width=100% class="EWLabelRB2">
			<input type='text' name='Header' readOnly size='24' style='display:none' value='Verification Details'>
			<td colspan=3 align=left class="EWLabelRB2"><b>Verification Details</b></td>
		</tr>
		<tr>
			<td nowrap  height="16" class="EWLabelRB" id="C_VD_TINCheck" colspan=3><input type="checkbox" name="VD_TINCheck" style='width:25px;' >&nbsp;TIN/PIN</td>
		</tr>
		<table border="1" cellspacing="1" cellpadding="1" width=100% >
			<TR>
				<td nowrap  height="16" class="EWLabelRB" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" onclick=EnableDisablechkbox()  name="VD_MoMaidN"  style='width:25px;' >&nbsp;Any 4 of the following RANDOM Questions</td>
			</TR>
			<TR>
				<tr>
					<td class="EWLabelRB" nowrap width=50% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;' >&nbsp;&nbsp;P.O. Box</td>
					<td class="EWLabelRB" nowrap width=50% id="C_VD_Oth"><input type="checkbox" name="VD_Oth" disabled style='width:25px;' >&nbsp;&nbsp;Mother's Maiden name</td>
					<TD></TD>
				</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=50% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;' >&nbsp;&nbsp;Most Recent Transaction (Date, Amount in Transaction Currency)</td>
					<td class="EWLabelRB" nowrap width=50% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;' >&nbsp;&nbsp;Staff ID No./Military ID No.</td>
				</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=50% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;' >&nbsp;&nbsp;Expiry date Of Your Card</td>
					<td class="EWLabelRB" nowrap width=50% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;' >&nbsp;&nbsp;Residence, Mobile, Work Tel No. registered with us&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=100% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;' >&nbsp;&nbsp;Date Of Birth</td>
				</tr>
			</TR>
		</table>
	</table>
	 
	<%if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase("") && DecoderProcessName.equalsIgnoreCase("Debitcard Service Request - Other Debit Card Requests"))
	{ %>
		<table border="1" cellspacing="1" cellpadding="1" width=100% >		
			<tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=2 align=left class="EWLabelRB2"><b>Other Process Name</b></td>
			</tr>
			<%
				 String sInputXML3="<?xml version=\"1.0\"?>\n" +
				"<WMGetQueueList_Input>\n" +
				"<Option>WMGetQueueList</Option>\n" +
				"<EngineName>"+sCabname+"</EngineName>\n" +
				"<SessionId>" + sSessionId + "</SessionId>\n" +
				"<Filter>\n" +
				"<QueueAssociation>2</QueueAssociation>\n" +
				"<Filter>"+
				"</Filter>\n" +
				"<BatchInfo>\n" +
				"</BatchInfo>\n" +
				"<DataFlag>N</DataFlag>\n" +
				"</WMGetQueueList_Input>";

				String sOutputXMLQueueList="";
				try
				{
					sOutputXMLQueueList = WFCallBroker.execute(sInputXML3,sJtsIp,iJtsPort,1);
					WriteLog(sOutputXMLQueueList);
					
					if(sOutputXMLQueueList.equals("") || Integer.parseInt(sOutputXMLQueueList.substring(sOutputXMLQueueList.indexOf("<MainCode>")+10 , sOutputXMLQueueList.indexOf("</MainCode>")))!=0)
					{
						bError= true;
					}
				}
				catch(Exception exp)
				{
					WriteLog(exp.toString());
				}
				WriteLog(sOutputXMLQueueList);
				if(sOutputXMLQueueList.indexOf("<MainCode>18</MainCode>") != -1)
				{
					WriteLog("No Record Found.");
				}
				else
				{
					try{
						WFXmlResponse xmlResponse = new WFXmlResponse(sOutputXMLQueueList);
						WFXmlList RecordList;
						String sType="";
						for (RecordList =  xmlResponse.createList("QueueList", "QueueInfo");RecordList.hasMoreElements();)
						{			
							if(RecordList.getVal("Name").toUpperCase().indexOf("DSR_ODC")!=-1&&RecordList.getVal("Name").toUpperCase().indexOf("WORK")!=-1&&RecordList.getVal("Name").toUpperCase().indexOf("WORK")!=8)
							{
								WriteLog("inside4444-----"+RecordList.getVal("Name").toUpperCase().substring(8,RecordList.getVal("Name").toUpperCase().indexOf("WORK")));
								String sSubProcessName=RecordList.getVal("Name").toUpperCase().substring(8,RecordList.getVal("Name").toUpperCase().indexOf("WORK"));
								ht.put(sSubProcessName,"Y");
							}
							RecordList.skip();
						}
						request.setAttribute("subProcessNames",ht);
					}catch(Exception ex){
							WriteLog("error--"+ex.toString());
					}
				}
			 %>
			<tr  width=100% class="EWLabelRB">
				 <td nowrap  class="EWLabelRB">Process Name</td>
				<td nowrap >
					<select name="request_type" onchange="showSubProcess(this);">			
						<option value="" selected>--Select--</option>
						<% if(ht.get("RIP")!=null&&ht.get("RIP").toString().equalsIgnoreCase("Y")){%>
						<option value="Re-Issue of PIN">Re-Issue of PIN</option>
						<%} if(ht.get("CR")!=null&&ht.get("CR").toString().equalsIgnoreCase("Y")){%>
						<option value="Card Replacement">Card Replacement</option>
						<%} if(ht.get("ECR")!=null&&ht.get("ECR").toString().equalsIgnoreCase("Y")){%>
						<option value="Early Card Renewal">Early Card Renewal</option>
						<%} if(ht.get("TD")!=null&&ht.get("TD").toString().equalsIgnoreCase("Y")){%>
						<option value="Transaction Dispute">Transaction Dispute</option>
						<%} if(ht.get("CDR")!=null&&ht.get("CDR").toString().equalsIgnoreCase("Y")){%>
						<option value="Card Delivery Request">Card Delivery Request</option>
						<%}%>
					</select>
				</td>
			</tr>
		</table>
		<jsp:include page="../DSRProcessSpecific/DSR_ODC_Common.jsp" />
	<%
	}%>
	
	<input type=text readOnly name="initiateDecision" id="initiateDecision" value='' style='display:none'>
	<input type=text readOnly name="subProcessShortName" id="subProcessShortName" value='' style='display:none'>
	<input type=text readOnly name="sDate" id="sDate" value='<%=sDate%>' style='display:none'>
	<input type=text readOnly name="sysDate_CCB" id="sysDate_CCB" value='<%=sysDate_CCB%>' style='display:none'>
	<%if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase("")){
		String BranchCodeName=BranchCodeName_1;
		if(BranchCodeName.indexOf("+") != -1)
			BranchCodeName=BranchCodeName.substring(0,BranchCodeName.indexOf("+"));
		%>
	<input type=text readOnly name="USER_BRANCH" id="USER_BRANCH" value='<%=BranchCodeName%>' style='display:none'>
	<%}%>
