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
	WriteLog("Inside FetchAccounts.jsp");
	String mainCodeCheck="0";
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIFID"), 1000, true) );    
	String cifId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");

	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("AccountIndicator"), 1000, true) );    
	String AccountIndicator = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:""); 
	//added by angad to pass AccountIndicator and FetchClosedAcctin call

	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("FetchClosedAcct"), 1000, true) );    
	String FetchClosedAcct = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	//added by angad to pass AccountIndicator and FetchClosedAcctin call

	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("AccToBeFetched"), 1000, true) );    
	String AccToBeFetched = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	//added by angad to pass AccountIndicator and FetchClosedAcctin call
	
	String accountDetails="";
	WFCustomXmlResponse WFCustomXmlResponseData=new WFCustomXmlResponse();
	String accountNumbers="";
	String accountNumbersForSig="";
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
				"<MsgFormat>ACCOUNT_SUMMARY</MsgFormat>\n"+
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
				"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+cifId+"</CIFID><FetchClosedAcct>"+FetchClosedAcct+"</FetchClosedAcct><AccountIndicator>"+AccountIndicator+"</AccountIndicator></FetchAccountListReq>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
	//sInputXML modified by angad 
		WriteLog("InputXML For ACCOUNT_SUMMARY Call"+sInputXML);
		
	//Uncomment below code for ONSHORE - CODE Starts HERE
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
	//ONSHORE CODE ENDS HERE
	
	//Uncomment below code for OFFSHORE - CODE Starts HERE
		//String sOutputXML  = "<?xml version=\"1.0\"?><EE_EAI_MESSAGE xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><EE_EAI_HEADER><MsgFormat>ACCOUNT_SUMMARY</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>[B@fb20fb2</MessageId><Extra1>REP||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1><Extra2>2017-03-22T04:30:29.198+04:00</Extra2></EE_EAI_HEADER><FetchFINAccountListRes><CIFID>0282122</CIFID><BankId>RAK</BankId><ProdProc>FINACLECORE</ProdProc><StatusAsOf>1900-01-01T00:00:00.000+04:00</StatusAsOf><IsIslamic>C</IsIslamic><IsPremium>Y</IsPremium><FINAccountDetail><BranchId>002</BranchId><Acid>0002282122001</Acid><Foracid>AE980400000002282122001</Foracid><AcctType>ODA</AcctType><AccountCategory>ACAP1</AccountCategory><CrnCode>AED</CrnCode><NicName>ST  028212</NicName><AccountName>ACCOUNT NAME FOR           0002282122001</AccountName><AcctBal>2443264.21</AcctBal><LedgerBalance>2443264.21</LedgerBalance><OverdraftLimit>0</OverdraftLimit><LedgerBalanceinAED>2443264.21</LedgerBalanceinAED><EffAvailableBal>2443264.21</EffAvailableBal><JntAcctIndicator>N</JntAcctIndicator><AcctStatus>001</AcctStatus><AcctAccess>N</AcctAccess><AcctOpnDt>2009-12-27</AcctOpnDt><EquivalentAmt>2443264.21</EquivalentAmt><ProductId>CURRENT ACCOUNT- RAKELITE INDIVIDUAL</ProductId><ModeOfOperation>SINGLY</ModeOfOperation></FINAccountDetail></FetchFINAccountListRes></EE_EAI_MESSAGE>";
	//OffSHORE CODE ENDS HERE
		
		String outputXMLLog = maskXmlTags(sOutputXML,"<Acid>"); // masking Acid in log
		outputXMLLog = maskXmlTags(outputXMLLog,"<Foracid>"); // masking Foracid in log
		
		WriteLog("sOutputXML For ACCOUNT_SUMMARY Call :"+outputXMLLog);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString(sOutputXML);
		mainCodeCheck = WFCustomXmlResponseData.getVal("ReturnCode");
		WriteLog("AccToBeFetched: "+AccToBeFetched);
		if(sOutputXML.indexOf("<ReturnCode>0000</ReturnCode>")>-1 || sOutputXML.indexOf("<ReturnCode>CINF362</ReturnCode>")>-1) // CINF362 means no data found in finacle
		{
			String IsIslamic = "";
			if(sOutputXML.indexOf("<ReturnCode>0000</ReturnCode>")>-1)
			{
				WriteLog("Fetch Account Successful");
			    DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
				InputSource is = new InputSource();
				is.setCharacterStream(new StringReader(sOutputXML));
				Document doc = db.parse(is);
				NodeList basenodes = doc.getElementsByTagName("FetchFINAccountListRes");
				for (int i = 0; i < basenodes.getLength(); i++) 
				{
					  Element baseElement = (Element) basenodes.item(i);
					  NodeList basename = baseElement.getElementsByTagName("IsIslamic");
					  Element baseline = (Element) basename.item(0);
					  WriteLog("IsIslamic: " + getCharacterDataFromElement(baseline));
					  IsIslamic = getCharacterDataFromElement(baseline);
					  
					  if (IsIslamic != "")
						break;
				}
				
				NodeList nodes = doc.getElementsByTagName("FINAccountDetail");
				
				if (AccToBeFetched.equals("LOAN ACCOUNT"))
				{
					WriteLog("inside loan account");
					for (int i = 0; i < nodes.getLength(); i++) 
					{
					  Element element = (Element) nodes.item(i);
					  NodeList name = element.getElementsByTagName("AcctType");
					  Element line = (Element) name.item(0);
					  WriteLog("accType: " + getCharacterDataFromElement(line));
					  String accType = getCharacterDataFromElement(line)+"|";
					  String AccNum = "";
					  String AccTypeCheck = getCharacterDataFromElement(line);	// Fetching Account Number to be shown on View Signature Page - 14082017
					  WriteLog("AccTypeCheck: " + getCharacterDataFromElement(line));
					  if ("LAA".equalsIgnoreCase(AccTypeCheck))
					  {	
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("AccountNumber: " + getCharacterDataFromElement(line));
						  accountNumbers += getCharacterDataFromElement(line)+"#";
						  AccNum = getCharacterDataFromElement(line)+"|";
					  }

					  // Start - Fetching Account Number to be shown on View Signature Page - 14082017
					  if (!("LAA".equalsIgnoreCase(AccTypeCheck)) 
							&& !("TDA".equalsIgnoreCase(AccTypeCheck))
							&& !("CCD".equalsIgnoreCase(AccTypeCheck)))
					  {	
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  WriteLog("accountNumbersForSig: " + getCharacterDataFromElement(line));
						  accountNumbersForSig += getCharacterDataFromElement(line)+"#";
					  }
					  // End - Fetching Account Number to be shown on View Signature Page - 14082017	
					  
					  name = element.getElementsByTagName("AccountName");
					  line = (Element) name.item(0);
					  WriteLog("AccountName: " + getCharacterDataFromElement(line));
					  String accountName = getCharacterDataFromElement(line)+"`";
					  WriteLog("AccountName: " + accountName);					  				  
					  WriteLog("AccNum: " + AccNum);					  				  
					  WriteLog("accType: " + accType);					  				  
					  				  
					  accountDetails += AccNum + accType + accountName;
					  WriteLog("accountDetails: " + accountDetails);	
					}
				}
				else if (AccToBeFetched.equals("FD ACCOUNT"))
				{
					WriteLog("inside FD account");
					for (int i = 0; i < nodes.getLength(); i++) 
					{
					  Element element = (Element) nodes.item(i);
					  NodeList name = element.getElementsByTagName("AcctType");
					  Element line = (Element) name.item(0);
					  WriteLog("accType: " + getCharacterDataFromElement(line));
					  String accType = getCharacterDataFromElement(line)+"|";
					  String AccNum = "";
					  String AccTypeCheck = getCharacterDataFromElement(line);	// Fetching Account Number to be shown on View Signature Page - 14082017
					  if ("TDA".equalsIgnoreCase(AccTypeCheck))
					  {
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("AccountNumber: " + getCharacterDataFromElement(line));
						  accountNumbers += getCharacterDataFromElement(line)+"#";
						  AccNum = getCharacterDataFromElement(line)+"|";
					  }
					  
					  // Start - Fetching Account Number to be shown on View Signature Page - 14082017	
					   if (!("LAA".equalsIgnoreCase(AccTypeCheck)) 
							&& !("TDA".equalsIgnoreCase(AccTypeCheck))
							&& !("CCD".equalsIgnoreCase(AccTypeCheck)))
					  {	
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("accountNumbersForSig: " + getCharacterDataFromElement(line));
						  accountNumbersForSig += getCharacterDataFromElement(line)+"#";
					  }
					  // End - Fetching Account Number to be shown on View Signature Page - 14082017
					  			  
					  name = element.getElementsByTagName("AccountName");
					  line = (Element) name.item(0);
					  //WriteLog("AccountName: " + getCharacterDataFromElement(line));
					  String accountName = getCharacterDataFromElement(line)+"`";
					  					  
					  accountDetails += AccNum + accType + accountName;
					}
				}
				else if (AccToBeFetched.equals("CARDS")) // else condition added on 24102017 by Angad for CARDS Services
				{
					WriteLog("inside Cards Account");
					for (int i = 0; i < nodes.getLength(); i++) 
					{
					  Element element = (Element) nodes.item(i);
					  NodeList name = element.getElementsByTagName("AcctType");
					  Element line = (Element) name.item(0);
					  WriteLog("accType: " + getCharacterDataFromElement(line));
					  String accType = getCharacterDataFromElement(line)+"|";
					  String AccNum = "";
					  String AccTypeCheck = getCharacterDataFromElement(line);	// Fetching Account Number to be shown on View Signature Page - 14082017
					  if ("CCD".equalsIgnoreCase(AccTypeCheck))
					  {
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("AccountNumber: " + getCharacterDataFromElement(line));
						  accountNumbers += getCharacterDataFromElement(line)+"#";
						  AccNum = getCharacterDataFromElement(line)+"|";
					  }
					  
					  // Start - Fetching Account Number to be shown on View Signature Page - 14082017	
					   if (!("LAA".equalsIgnoreCase(AccTypeCheck)) 
							&& !("TDA".equalsIgnoreCase(AccTypeCheck))
							&& !("CCD".equalsIgnoreCase(AccTypeCheck)))
					  {	
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("accountNumbersForSig: " + getCharacterDataFromElement(line));
						  accountNumbersForSig += getCharacterDataFromElement(line)+"#";
					  }
					  // End - Fetching Account Number to be shown on View Signature Page - 14082017
					  //change by badri to show CRN number as nickname
					  String accountName = "";
					  try {	
						name = element.getElementsByTagName("NicName");
						line = (Element) name.item(0);
						//WriteLog("NicName: " + getCharacterDataFromElement(line));
						accountName = getCharacterDataFromElement(line)+"`";
					  } catch (Exception e) {}
					  					  
					  accountDetails += AccNum + accType + accountName;
					}
				}
				else {
					for (int i = 0; i < nodes.getLength(); i++) 
					{
					  Element element = (Element) nodes.item(i);
					  NodeList name = element.getElementsByTagName("Acid");
					  Element line = (Element) name.item(0);
					  //WriteLog("AccountNumber: " + getCharacterDataFromElement(line));
					  accountNumbers += getCharacterDataFromElement(line)+"#";
					  String AccNum = getCharacterDataFromElement(line)+"|";
					  
					  name = element.getElementsByTagName("AcctType");
					  line = (Element) name.item(0);
					  WriteLog("accType: " + getCharacterDataFromElement(line));
					  String accType = getCharacterDataFromElement(line)+"|";
					  
					  // Start - Fetching Account Number to be shown on View Signature Page - 14082017	
					  String AccTypeCheck = getCharacterDataFromElement(line);
					  if (!("LAA".equalsIgnoreCase(AccTypeCheck)) 
							&& !("TDA".equalsIgnoreCase(AccTypeCheck))
							&& !("CCD".equalsIgnoreCase(AccTypeCheck)))
					  {	
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("accountNumbersForSig: " + getCharacterDataFromElement(line));
						  accountNumbersForSig += getCharacterDataFromElement(line)+"#";
					  }
					  // End - Fetching Account Number to be shown on View Signature Page - 14082017
					  
					  name = element.getElementsByTagName("AccountName");
					  line = (Element) name.item(0);
					  //WriteLog("AccountName: " + getCharacterDataFromElement(line));
					  String accountName = getCharacterDataFromElement(line)+"`";
					  
					  accountDetails += AccNum + accType + accountName;
					}
				}
			} else 
			{
				IsIslamic="B";
			}			
				// Start - calling Account Summary call from Flexcube when isIslamic is I or B
				if (AccToBeFetched.equals("LOAN ACCOUNT") || AccToBeFetched.equals("FD ACCOUNT"))
				{
					if (IsIslamic.equals("I") || IsIslamic.equals("B"))
					{
						if (AccToBeFetched.equals("LOAN ACCOUNT"))
						{
							AccountIndicator = "F";
						}
						else if (AccToBeFetched.equals("FD ACCOUNT"))
						{
							AccountIndicator = "T";
						}
						
							String sInputXML1 = "<?xml version=\"1.0\"?>"
							+ "<BPM_APMQPutGetMessage_Input>\n"+
							"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
							"<UserID>"+customSession.getUserName()+"</UserID>\n" +
							"<SessionId>"+customSession.getDMSSessionId()+"</SessionId>\n"+
							"<EngineName>"+customSession.getEngineName()+"</EngineName>\n" +
							"<RequestMessage><EE_EAI_MESSAGE>\n"+
							//"<ProcessName>SRB</ProcessName>\n" +
							"<EE_EAI_HEADER>\n"+
							"<MsgFormat>ACCOUNT_SUMMARY</MsgFormat>\n"+
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
							"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+cifId+"</CIFID><FetchClosedAcct>"+FetchClosedAcct+"</FetchClosedAcct><AccountIndicator>"+AccountIndicator+"</AccountIndicator></FetchAccountListReq>\n"+
							"</EE_EAI_MESSAGE></RequestMessage>\n" +				
							"</BPM_APMQPutGetMessage_Input>";
						WriteLog("InputXML1 For ACCOUNT_SUMMARY Call from Flexcube : "+sInputXML1);
						
					//Uncomment below code for ONSHORE - CODE Starts HERE
						String sOutputXML1= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
		
		
					//ONSHORE CODE ENDS HERE
	
					//Uncomment below code for OFFSHORE - CODE Starts HERE
					
					//String sOutputXML1  = "<?xml version=\"1.0\"?><EE_EAI_MESSAGE xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"><EE_EAI_HEADER><MsgFormat>ACCOUNT_SUMMARY</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>[B@fb20fb2</MessageId><Extra1>REP||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1><Extra2>2017-03-22T04:30:29.198+04:00</Extra2></EE_EAI_HEADER><FetchFINAccountListRes><CIFID>0282122</CIFID><BankId>RAK</BankId><ProdProc>FINACLECORE</ProdProc><StatusAsOf>1900-01-01T00:00:00.000+04:00</StatusAsOf><IsIslamic>C</IsIslamic><IsPremium>Y</IsPremium><FINAccountDetail><BranchId>002</BranchId><Acid>0002282122001</Acid><Foracid>AE980400000002282122001</Foracid><AcctType>ODA</AcctType><AccountCategory>ACAP1</AccountCategory><CrnCode>AED</CrnCode><NicName>ST  028212</NicName><AccountName>ACCOUNT NAME FOR           0002282122001</AccountName><AcctBal>2443264.21</AcctBal><LedgerBalance>2443264.21</LedgerBalance><OverdraftLimit>0</OverdraftLimit><LedgerBalanceinAED>2443264.21</LedgerBalanceinAED><EffAvailableBal>2443264.21</EffAvailableBal><JntAcctIndicator>N</JntAcctIndicator><AcctStatus>001</AcctStatus><AcctAccess>N</AcctAccess><AcctOpnDt>2009-12-27</AcctOpnDt><EquivalentAmt>2443264.21</EquivalentAmt><ProductId>CURRENT ACCOUNT- RAKELITE INDIVIDUAL</ProductId><ModeOfOperation>SINGLY</ModeOfOperation></FINAccountDetail></FetchFINAccountListRes></EE_EAI_MESSAGE>";
					//OffSHORE CODE ENDS HERE
						
						String outputXMLLog1 = maskXmlTags(sOutputXML1,"<Acid>"); // masking Acid in log
						outputXMLLog1 = maskXmlTags(outputXMLLog1,"<Foracid>"); // masking Foracid in log
						WriteLog("sOutputXML1 For ACCOUNT_SUMMARY Call from Flexcube : "+outputXMLLog1);
						
						if(sOutputXML1.indexOf("<ReturnCode>0000</ReturnCode>")>-1)
						{
							WriteLog("Fetch Account from Flexcube Successful");
							DocumentBuilder db1 = DocumentBuilderFactory.newInstance().newDocumentBuilder();
							InputSource is1 = new InputSource();
							is1.setCharacterStream(new StringReader(sOutputXML1));
							Document doc1 = db1.parse(is1);
							NodeList nodes1 = doc1.getElementsByTagName("IBSAccountDetail");
							WriteLog("IBSAccountDetail nodes1: "+nodes1);
							for (int i = 0; i < nodes1.getLength(); i++) 
							{
								  Element element1 = (Element) nodes1.item(i);
								  NodeList name1 = element1.getElementsByTagName("Acid");
								  Element line1 = (Element) name1.item(0);
								  //WriteLog("AccountNumber from Flexcube: " + getCharacterDataFromElement(line1));
								  accountNumbers += getCharacterDataFromElement(line1)+"#";
								  String AccNum = getCharacterDataFromElement(line1)+"|";
								  
								  name1 = element1.getElementsByTagName("AcctType");
								  line1 = (Element) name1.item(0);
								  WriteLog("accType from Flexcube: " + getCharacterDataFromElement(line1));
								  String accType = getCharacterDataFromElement(line1)+"|";
								  
								  // Start - Fetching Account Number to be shown on View Signature Page - 14082017
								  String AccTypeCheck = getCharacterDataFromElement(line1);
								  if (!("LAA".equalsIgnoreCase(AccTypeCheck)) 
										&& !("TDA".equalsIgnoreCase(AccTypeCheck))
										&& !("CCD".equalsIgnoreCase(AccTypeCheck)))
								  {	
									  name1 = element1.getElementsByTagName("Acid");
									  line1 = (Element) name1.item(0);
									  //WriteLog("accountNumbersForSig from Flexcube: " + getCharacterDataFromElement(line1));
									  accountNumbersForSig += getCharacterDataFromElement(line1)+"#";
								  }
								  // End - Fetching Account Number to be shown on View Signature Page - 14082017
								  
								  name1 = element1.getElementsByTagName("AccountName");
								  line1 = (Element) name1.item(0);
								  //WriteLog("AccountName from Flexcube: " + getCharacterDataFromElement(line1));
								  String accountName = getCharacterDataFromElement(line1)+"`";
								  
								  accountDetails += AccNum + accType + accountName;
								  mainCodeCheck="0000";
							 }
						}
						else
						{
							WriteLog("Problem during fetching accounts from Flexcube");
							WFCustomXmlResponseData=new WFCustomXmlResponse();
							WFCustomXmlResponseData.setXmlString(sOutputXML1);
							//mainCodeCheck = WFCustomXmlResponseData.getVal("ReturnCode");
						}
					}
				}
				// End - calling Account Summary call from Flexcube when isIslamic is I or B
				
				
				if(accountNumbers.length()>0)
				accountNumbers = accountNumbers.substring(0,accountNumbers.lastIndexOf("#"));
				WriteLog("account Numbers fetched:" + accountNumbers);
				
				// Fetching Account Number to be shown on View Signature Page - 14082017
				if(accountNumbersForSig.length()>0)
				accountNumbersForSig = accountNumbersForSig.substring(0,accountNumbersForSig.lastIndexOf("#"));
				WriteLog("accountNumbersForSig fetched:" + accountNumbersForSig);
				
				if(accountDetails.length()>0)
				accountDetails = accountDetails.substring(0,accountDetails.lastIndexOf("`"));
				WriteLog("account Details fetched:" + accountDetails);
				
		}
		else
		{
			WriteLog("Problem during fetching accounts");
			//WFCustomXmlResponseData=new WFCustomXmlResponse();
			//WFCustomXmlResponseData.setXmlString(sOutputXML);
			//mainCodeCheck = WFCustomXmlResponseData.getVal("ReturnCode");
		}	
	}
	catch(Exception e) 
	{
		WriteLog("<OutPut>Error during Fetching account numbers</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
WriteLog("mainCodeCheck accountNumbers accountDetails accountNumbersForSig"+mainCodeCheck+"~"+accountNumbers+"~"+accountDetails+"~"+accountNumbersForSig);
out.print(mainCodeCheck+"~"+accountNumbers+"~"+accountDetails+"~"+accountNumbersForSig);		
%>



