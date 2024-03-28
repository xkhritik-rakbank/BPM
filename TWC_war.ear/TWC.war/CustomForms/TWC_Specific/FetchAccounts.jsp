<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : Account Opening
//Module                     : Fetch Account Numbers
//File Name					 : FetchAccounts.jsp
//Author                     : Angad Shah
// Date written (DD/MM/YYYY) : 03-Apr-2019
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
<%@ include file="Log.process"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="javax.xml.parsers.DocumentBuilder"%>
<%@ page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import="org.w3c.dom.CharacterData"%>
<%@ page import="org.w3c.dom.Document"%>
<%@ page import="org.w3c.dom.Element"%>
<%@ page import="org.w3c.dom.Node"%>
<%@ page import="org.w3c.dom.NodeList"%>
<%@ page import="org.xml.sax.InputSource"%>

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
	String cifId = request.getParameter("CIFID");
	if (cifId != null) {cifId=cifId.replace("'","");}
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
				"<ProcessName>RAO</ProcessName>\n" +
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
				"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+cifId+"</CIFID><FetchClosedAcct>N</FetchClosedAcct><AccountIndicator>A</AccountIndicator></FetchAccountListReq>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
	
		WriteLog("InputXML For ACCOUNT_SUMMARY Call"+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
		String outputXMLLog = maskXmlTags(sOutputXML,"<Acid>"); // masking Acid in log
		outputXMLLog = maskXmlTags(outputXMLLog,"<Foracid>"); // masking Foracid in log
		WriteLog("sOutputXML For ACCOUNT_SUMMARY Call :"+outputXMLLog);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString(sOutputXML);
		mainCodeCheck = WFCustomXmlResponseData.getVal("ReturnCode");
		//WriteLog("AccToBeFetched: "+AccToBeFetched);
		if(sOutputXML.indexOf("<ReturnCode>0000</ReturnCode>")>-1)
		{
				WriteLog("Fetch Account Successful");
			    DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();
				InputSource is = new InputSource();
				is.setCharacterStream(new StringReader(sOutputXML));
				Document doc = db.parse(is);
				
				NodeList nodes = doc.getElementsByTagName("FINAccountDetail");
				for (int i = 0; i < nodes.getLength(); i++) 
					{
					  Element element = (Element) nodes.item(i);
					  NodeList name = element.getElementsByTagName("AcctType");
					  Element line = (Element) name.item(0);
					  WriteLog("accType: " + getCharacterDataFromElement(line));
					  String accType = getCharacterDataFromElement(line)+"|";
					  String AccNum = "";
					  String AccTypeCheck = getCharacterDataFromElement(line);	// Fetching Account Number to be shown on View Signature Page - 14082017
					  
					  if (!("LAA".equalsIgnoreCase(AccTypeCheck)) 
							&& !("TDA".equalsIgnoreCase(AccTypeCheck))
							&& !("CCD".equalsIgnoreCase(AccTypeCheck)))
					  {	
						  name = element.getElementsByTagName("Acid");
						  line = (Element) name.item(0);
						  //WriteLog("accountNumbersForSig: " + getCharacterDataFromElement(line));
						  accountNumbersForSig += getCharacterDataFromElement(line)+"@";
					  }
					 
					}
				
				// Fetching Account Number to be shown on View Signature Page - 14082017
				if(accountNumbersForSig.length()>0)
				accountNumbersForSig = accountNumbersForSig.substring(0,accountNumbersForSig.lastIndexOf("@"));
				//WriteLog("accountNumbersForSig fetched:" + accountNumbersForSig);	
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
out.print(mainCodeCheck+"~"+accountNumbersForSig);		
%>



