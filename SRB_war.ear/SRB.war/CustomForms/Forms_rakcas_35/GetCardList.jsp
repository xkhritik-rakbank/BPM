<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : Account Opening
//Module                     : Fetch Account Numbers
//File Name					 : GetCardList.jsp
//Author                     : Angad Shah
// Date written (DD/MM/YYYY) : 30-04-2018
//Description                : File to fetch card list from middleware via invoking wfcustom
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../SRB_Specific/Log.process"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="javax.xml.parsers.DocumentBuilder"%>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import="org.w3c.dom.CharacterData"%>
<%@ page import="org.w3c.dom.Document"%>
<%@ page import="org.w3c.dom.Element"%>
<%@ page import="org.w3c.dom.Node"%>
<%@ page import="org.w3c.dom.NodeList"%>
<%@ page import="org.xml.sax.InputSource"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<%!
  public static String getCharacterDataFromElement(Element e) 
  {
    Node child = e.getFirstChild();
    if (child instanceof CharacterData) {
      CharacterData cd = (CharacterData) child;
      return cd.getData();
    }
    return "";
  }
    %>
<%
	WriteLog("Inside getCardList.jsp");
	String mainCodeCheck="0";
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIFID"), 1000, true) );    
	String cifId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");

	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Number"), 1000, true) );    
	String Number = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");

	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CardType"), 1000, true) );    
	String CardType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	
	WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
	String accountNumbers="";
	try	
	{
	
		String sInputXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+customSession.getUserName()+"</UserID>\n" +
				"<SessionId>"+customSession.getDMSSessionId()+"</SessionId>\n"+
				"<EngineName>"+customSession.getEngineName()+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				//"<ProcessName>SRB</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>CARD_LIST</MsgFormat>\n"+
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
					"<CardListRequest>\n"+
					  "<BankId>RAK</BankId>\n"+
					  "<CIFID>"+cifId+"</CIFID>\n"+
					  "<Number>"+Number+"</Number>\n"+
					  "<Entity>Customer</Entity>\n"+
					  "<Reference>66</Reference>\n"+
					  "<CardType>"+CardType+"</CardType>\n"+
					  "<FreeField1/>\n"+
					  "<FreeField2/>\n"+
				    "</CardListRequest>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
	//sInputXML modified by angad 
		WriteLog("InputXML For CARD_LIST Call"+sInputXML);
		
		//Uncomment below code for ONSHORE - CODE Starts HERE
			String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
		//ONSHORE CODE ENDS HERE
	
	//Uncomment below code for OFFSHORE - CODE Starts HERE
		//String sOutputXML  = "<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_LIST</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>[B@7df67df6</MessageId><Extra1>REP||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1><Extra2>2018-06-19T11:58:35.061+04:00</Extra2></EE_EAI_HEADER><CardListResponse><BankId>RAK</BankId><CIFID>0100623</CIFID><CardAccountDetails><AccountNumber>019625500</AccountNumber><Currency>AED</Currency><CurrentMinimumAmount>0.000</CurrentMinimumAmount><CurrentBalance>-2908.110</CurrentBalance><MinAmtDue>0.000</MinAmtDue><ClosingBalance>0.000</ClosingBalance><RewardsBalance>0.000</RewardsBalance><PymtDueDate>0001-01-01</PymtDueDate><LastStatementDate>0001-01-01</LastStatementDate><CurrentOverdueAmt>0.000</CurrentOverdueAmt><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3><CardDetails><CardNumber>4581012981606001</CardNumber><IsPrimaryCard>P</IsPrimaryCard><ProductType>VGOLD-EXPAT</ProductType><CardHolderName>embname_214318</CardHolderName><CardExpiryDate>2008-01-31</CardExpiryDate><CardStatus>NORR</CardStatus><TotalCreditLimit>82000.000</TotalCreditLimit><TotalCashLimit>-80.000</TotalCashLimit><CRNNo>019625500</CRNNo><CustId>0100623</CustId><VIPFlag>0</VIPFlag><DispatchChannel>032</DispatchChannel><DispatchDate>23/01/2006</DispatchDate><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CardDetails><CardDetails><CardNumber>4581012981606100</CardNumber><IsPrimaryCard>S</IsPrimaryCard><ProductType>VGOLD-EXPAT</ProductType><CardHolderName>embname_214327</CardHolderName><CardExpiryDate>2008-01-31</CardExpiryDate><CardStatus>NORR</CardStatus><TotalCreditLimit>82000.000</TotalCreditLimit><TotalCashLimit>-80.000</TotalCashLimit><CRNNo>019625501</CRNNo><CustId>1298045</CustId><VIPFlag>0</VIPFlag><DispatchChannel>032</DispatchChannel><DispatchDate>23/01/2006</DispatchDate><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CardDetails></CardAccountDetails><CardAccountDetails><AccountNumber>019625600</AccountNumber><Currency>AED</Currency><CurrentMinimumAmount>-100.000</CurrentMinimumAmount><CurrentBalance>-2908.110</CurrentBalance><MinAmtDue>-100.000</MinAmtDue><ClosingBalance>-2895.250</ClosingBalance><RewardsBalance>512.000</RewardsBalance><PymtDueDate>2018-05-13</PymtDueDate><LastStatementDate>2018-04-18</LastStatementDate><CurrentOverdueAmt>0.000</CurrentOverdueAmt><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3><CardDetails><CardNumber>5595807124702000</CardNumber><IsPrimaryCard>P</IsPrimaryCard><ProductType>WORLD-PRIORITY</ProductType><CardHolderName>embname_214320</CardHolderName><CardExpiryDate>2020-01-31</CardExpiryDate><CardStatus>NORM</CardStatus><TotalCreditLimit>82000.000</TotalCreditLimit><TotalCashLimit>-80.000</TotalCashLimit><CRNNo>019625600</CRNNo><CustId>0100623</CustId><VIPFlag>0</VIPFlag><DispatchChannel>998</DispatchChannel><DispatchDate>30/03/2016</DispatchDate><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CardDetails><CardDetails><CardNumber>5595807124702109</CardNumber><IsPrimaryCard>S</IsPrimaryCard><ProductType>WORLD-PRIORITY</ProductType><CardHolderName>embname_214328</CardHolderName><CardExpiryDate>2020-01-31</CardExpiryDate><CardStatus>NORM</CardStatus><TotalCreditLimit>82000.000</TotalCreditLimit><TotalCashLimit>-80.000</TotalCashLimit><CRNNo>019625601</CRNNo><CustId>1298045</CustId><VIPFlag>0</VIPFlag><DispatchChannel>998</DispatchChannel><DispatchDate>30/03/2016</DispatchDate><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CardDetails></CardAccountDetails></CardListResponse></EE_EAI_MESSAGE>";
	//OFFSHORE CODE ENDS HERE	
		String outputXMLLog = maskXmlTags(sOutputXML,"<CardNumber>"); // masking Acid in log
		
		WriteLog("sOutputXML For CARD_LIST Call :"+outputXMLLog);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString(sOutputXML);
		mainCodeCheck = WFCustomXmlResponseData.getVal("ReturnCode");
		if(sOutputXML.indexOf("<ReturnCode>0000</ReturnCode>")>-1)
		{
				WriteLog("Fetch CARD_LIST Successful");
			    DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
				InputSource is = new InputSource();
				is.setCharacterStream(new StringReader(sOutputXML));
				Document doc = db.parse(is);
				
				NodeList nodes = doc.getElementsByTagName("CardDetails");
				
				for (int i = 0; i < nodes.getLength(); i++) 
				{
				  Element element = (Element) nodes.item(i);
				  NodeList name = element.getElementsByTagName("CardNumber");
				  Element line = (Element) name.item(0);
				  WriteLog("CardNumber: " + getCharacterDataFromElement(line));
				  accountNumbers += getCharacterDataFromElement(line)+"#";
				  
				}
				
				if(accountNumbers.length()>0)
				accountNumbers = accountNumbers.substring(0,accountNumbers.lastIndexOf("#"));
				WriteLog("CARD_LIST fetched:" + accountNumbers);
		}
		else
		{
			WriteLog("Problem during fetching CARD_LIST");
			//WFCustomXmlResponseData=new WFCustomXmlResponse();
			//WFCustomXmlResponseData.setXmlString(sOutputXML);
			//mainCodeCheck = WFCustomXmlResponseData.getVal("ReturnCode");
		}	
	}
	catch(Exception e) 
	{
		WriteLog("<OutPut>Error during Fetching CARD_LIST </OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.print(mainCodeCheck+"~"+accountNumbers);		
%>



