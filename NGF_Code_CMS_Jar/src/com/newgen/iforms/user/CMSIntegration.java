package com.newgen.iforms.user;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.File;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.CharacterData;
	
	public class CMSIntegration extends CMSCommon 
	{		
		LinkedHashMap<String,String> executeXMLMapMain = new LinkedHashMap<String,String>();
		public static String XMLLOG_HISTORY="NG_CMS_XMLLOG_HISTORY";

	public String onclickevent(IFormReference iformObj,String control,String StringData)
	{
		String MQ_response="";
		String MQ_response_Entity ="";
		String AccountNumber = "";		
		String TradeLicense="";
		String TradeLicenseExpiryDate="";
		String Blacklisted="";
		String Negated="";
		String Companyname="";
		int returnedSignatures = 0;
		String ReturnCode1="";		
		String ReturnDesc = "";		
		
			try
			{
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside onclickevent function");
			
			
			 if(control.equals("btn_Populate"))
			{
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", inside onclick function for customer detail call 1");
				MQ_response = MQ_connection_response(iformObj,"customer_details",StringData);
				
				MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
				//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_CIF_Search function "+MQ_response);	
				if(MQ_response.indexOf("<ReturnCode>")!=-1)
				{
					ReturnCode1 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
					
				}
				if(MQ_response.indexOf("<ReturnDesc>")!=-1)
				{
					ReturnDesc = MQ_response.substring(MQ_response.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response.indexOf("</ReturnDesc>"));
					
				}
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Return  code for the Customer Details call"+ReturnCode1);
				
				if(ReturnCode1.equals("0000"))
				{
					
					CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Clicked search button");
									
					if(MQ_response.contains("<IsBlackListed>"))
						{
							Blacklisted = MQ_response.substring(MQ_response.indexOf("<IsBlackListed>")+"</IsBlackListed>".length()-1,MQ_response.indexOf("</IsBlackListed>"));
							setControlValue("IS_BLACKLISTED", Blacklisted);
						}
						
					if(MQ_response.contains("<IsNegativeListed>"))
						{
							Negated = MQ_response.substring(MQ_response.indexOf("<IsNegativeListed>")+"</IsNegativeListed>".length()-1,MQ_response.indexOf("</IsNegativeListed>"));
							setControlValue("IS_NEGATED", Negated);
						}
						
					if(MQ_response.contains("<CorpName>"))
						{
							Companyname = MQ_response.substring(MQ_response.indexOf("<CorpName>")+"</CorpName>".length()-1,MQ_response.indexOf("</CorpName>"));
							setControlValue("COMPANY_NAME", Companyname);
						}
					
					if (MQ_response.contains("<DocDet>"))
						{
							Document recordDoc2=MapXML.getDocument(MQ_response);
							NodeList records2= MapXML.getNodeListFromDocument(recordDoc2, "DocDet");
							CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records2.getLength());
							if(records2.getLength() > 0)
							{
								for(int rec2=0;rec2<records2.getLength();rec2++)
								{
									if(MapXML.getTagValueFromNode(records2.item(rec2),"DocType").equalsIgnoreCase("TDLIC"))
									{
									    TradeLicense = MapXML.getTagValueFromNode(records2.item(rec2),"DocNo");
										setControlValue("TL_NUMBER", TradeLicense); 
										
									   TradeLicenseExpiryDate = MapXML.getTagValueFromNode(records2.item(rec2),"DocExpDate");
										TradeLicenseExpiryDate = TradeLicenseExpiryDate.substring(8,10)+"/"+TradeLicenseExpiryDate.substring(5,7)+"/"+TradeLicenseExpiryDate.substring(0,4);
										setControlValue("TL_EXPIRY_DATE", TradeLicenseExpiryDate); 
									}
									
									
								}
							}
						}
						
						
			
			//Start 
			
			MQ_response_Entity = MQ_connection_response(iformObj,"fetch_acc_details",StringData);
			//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_CIF_Search function 1111"+MQ_response_Entity);
				MQ_response_Entity=MQ_response_Entity.substring(MQ_response_Entity.indexOf("<?xml v"),MQ_response_Entity.indexOf("</MQ_RESPONSE_XML>"));
				//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_CIF_Search function3444344 "+MQ_response_Entity);	
				
					
				if(MQ_response_Entity.indexOf("<ReturnCode>")!=-1)
				{
					ReturnCode1 = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response_Entity.indexOf("</ReturnCode>"));
					
				}
				//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_CIF_Search function2222 "+MQ_response_Entity);
				if(MQ_response_Entity.indexOf("<ReturnDesc>")!=-1)
				{
					ReturnDesc = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response_Entity.indexOf("</ReturnDesc>"));
					
				}
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Return  code for the Account Summary call"+ReturnCode1);
				
				if(ReturnCode1.equals("0000"))
				{
					
					CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Fetch Account Details");
										
					if (MQ_response_Entity.contains("<FINAccountDetail>"))
					{
						Document recordDoc=MapXML.getDocument(MQ_response_Entity);
						NodeList records= MapXML.getNodeListFromDocument(recordDoc, "FINAccountDetail");
						CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned : "+records.getLength());
						if((records.getLength()== 0))
						{
							CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", No Records for account detail call...");
							
							//continue;
						}
						if(records.getLength() > 0)
						{
							CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", many records for account detail call..");
							
							for(int rec=0;rec<records.getLength();rec++)
							{
								//JSONArray jsonArray=new JSONArray();
								//AccountNumber =MapXML.getTagValueFromNode(records.item(rec),"Acid");
			
								//opt = AccountNumber[rec];		
								Element element = (Element) records.item(rec);				  
								NodeList name = element.getElementsByTagName("Acid");
								Element line = (Element) name.item(0);
								  //WriteLog("accountNumbersForSig: " + getCharacterDataFromElement(line));
														
								AccountNumber += getCharacterDataFromElement(line)+"@";
		
							}
							//AccountNumber=AccountNumber.substring(0,records.getLength()-1);
							//CMS.mLogger.debug("ACCOUNT_NUMBERs : "+AccountNumber);
							setControlValue("ACCOUNT_NUMBER",AccountNumber);	
								
						}				
						CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", @@@@@@@@@@ : after add 2");
					}
				}
				
			//End
			
			
			return ReturnCode1+"~"+ReturnDesc;
			
			}
			}
			
			
			
				else if(control.equalsIgnoreCase("btn_View_Signature"))
			 {
					String imageArr[] = null;
					String strCode =null;
					String remarksArr[] = null;
					String signGrpNameArr[] = null;
					String customerNameArr[] = null;
					String remarks="";
					String sigGroupName="";
					String CustomerNameSig="";
				    Properties p = new Properties();
					p.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "CustomConfig"+System.getProperty("file.separator")+"RakBankConfig.properties"));
					String filePath = p.getProperty("CMS_LoadImage");
					CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", filePath from OpenImage.jsp- "+filePath);
				 String acc_no = StringData;
				 CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", control is view signature..");
				 MQ_response = MQ_connection_response(iformObj,control,acc_no);
				//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature function "+MQ_response);
				MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
				//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature function "+MQ_response);	
				
				Document doc=MapXML.getDocument(MQ_response);
				NodeList returnCode = doc.getElementsByTagName("ReturnCode");
				Element elementReturnCode = (Element) returnCode.item(0);
				strCode = getCharacterDataFromElement(elementReturnCode);
				
				if (strCode.equals("0000"))
				{
					NodeList nodesReturnedSignature = doc.getElementsByTagName("returnedSignature");
					NodeList nodesRemarksArr = doc.getElementsByTagName("remarks");
					NodeList nodesSignGrpNameArr = doc.getElementsByTagName("SignGrpName");
					NodeList nodesCustomerNameArr = doc.getElementsByTagName("CustomerName");
					
					//First Check if call is success or not
					
					//Initializing the Image Array
					returnedSignatures = nodesReturnedSignature.getLength();
					imageArr = new String [returnedSignatures];
					remarksArr = new String [returnedSignatures];
					signGrpNameArr = new String [returnedSignatures];
					customerNameArr = new String [returnedSignatures];
					
					CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", returnedSignatures - "+returnedSignatures);
					
					// iterate the returnedSignatures and put it in an array
					for (int i = 0; i < returnedSignatures; i++) {
						Element element = (Element) nodesReturnedSignature.item(i);
						Element element1 = (Element) nodesRemarksArr.item(i);
						Element element2 = (Element) nodesSignGrpNameArr.item(i);
						Element element3 = (Element) nodesCustomerNameArr.item(i);
						try{
							imageArr [i] = getCharacterDataFromElement(element);
							//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", image value is --"+imageArr[i]);
							remarksArr [i] = getCharacterDataFromElement(element1);
							if(remarks.equals(""))
							 remarks = remarksArr [i];
							else
								remarks = remarks+","+remarksArr [i];
							CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", remarks value is --"+remarksArr[i]);
							
							String signgrpname = "";
							try {
								signgrpname = getCharacterDataFromElement(element2);
								if("".equalsIgnoreCase(signgrpname) || signgrpname == null || "null".equalsIgnoreCase(signgrpname))
									signgrpname = "-";
							} catch(Exception e)
							{
								signgrpname = "-";
							}
							signGrpNameArr [i] = signgrpname;	
							CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", sig grp name value is --"+signGrpNameArr[i]);
							if(sigGroupName.equals(""))
								sigGroupName = signGrpNameArr [i];
								else
									sigGroupName = sigGroupName+","+signGrpNameArr [i];
							
							customerNameArr [i] = getCharacterDataFromElement(element3);
							//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", customer name value is --"+imageArr[i]);
							if(CustomerNameSig.equals(""))
								CustomerNameSig = customerNameArr [i];
								else
									CustomerNameSig = CustomerNameSig+","+customerNameArr [i];
						}catch(Exception ex){
							CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception 1 - "+ex);
						}
					}
				}
				
				if (strCode.equals("0000"))
				{
					//out.clear();
					 getImages(filePath,acc_no,imageArr,remarksArr);
					
				} else {
					//out.clear();
					//if(acc_no==null || acc_no.equals(""))
						//out.print("No records for the customer.");
					//else
						//out.print("Unable to fetch the signatures for account:"+acc_no);
				}
			 CMS.mLogger.debug("returnedSignatures : "+Integer.toString(returnedSignatures)+", remarks: "+remarks+", sigGroupName - "+sigGroupName+", CustomerNameSig :"+CustomerNameSig);				
			 return Integer.toString(returnedSignatures)+"~"+remarks+"~"+sigGroupName+"~"+CustomerNameSig;
			 }			
			
		}
			
		
		catch(Exception exc)
		{
			CMS.printException(exc);
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception 2 - "+exc);
		}
	
		return "";
	}
	
		
	public String getImages(String tempImagePath,String debt_acc_num,String[] imageArr,String[] remarksArr)
	{

		if(imageArr==null)
			return "";
		for (int i=0;i<imageArr.length;i++)
		{
			try
			{	
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside Get Images 0");
				byte[] btDataFile = new sun.misc.BASE64Decoder().decodeBuffer(imageArr[i]);
				//File of = new File(filePath+debt_acc_num+"imageCreatedN"+i+".jpg");
				String imagePath = System.getProperty("user.dir")+tempImagePath+System.getProperty("file.separator")+debt_acc_num+"imageCreatedN"+i+".jpg";
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", imagePath"+imagePath);
				File of = new File(imagePath);
				
				FileOutputStream osf = new FileOutputStream(of);
				osf.write(btDataFile);
				osf.flush();
				osf.close();
			}
			catch (Exception e)
			{
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Not able to get the image imageCreated"+e);
				CMS.mLogger.debug( e.getMessage());
				e.printStackTrace();				
			}
		}
		//WriteLog( html.toString());
		return "";
	}
	
	public static String getCharacterDataFromElement(Element e) {
		Node child = e.getFirstChild();
		if (child instanceof CharacterData) {
		   CharacterData cd = (CharacterData) child;
		   return cd.getData();
		}
		return "NO_DATA";
	}
	
	public String MQ_connection_response(IFormReference iformObj,String control,String Data) 
	{
		
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside MQ_connection_response function");
	final IFormReference iFormOBJECT;
	final WDGeneralData wdgeneralObj;	
	Socket socket = null;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String mqOutputResponse = null;
	String mqOutputResponse1 = null;
	String mqInputRequest = null;	
	String cabinetName = getCabinetName();
	String wi_name = getWorkitemName();
	String ws_name = getActivityName();
	String sessionID = getSessionId();
	String userName = getUserName();
	String socketServerIP;
	int socketServerPort;
	wdgeneralObj = iformObj.getObjGeneralData();
	sessionID = wdgeneralObj.getM_strDMSSessionId();
	String CIFNumber="";	
	String CallName="";
	
	if(control.equals("customer_details"))
	{
		 CIFNumber=  getControlValue("CIF_ID");
		 CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", CIFNumber for the first entity detail call is --"+CIFNumber);
		 /*TLNUMBER = getControlValue("TL_NUMBER");
		 TLEXPIRYDATE= getControlValue("TL_EXPIRY_DATE");
		 COMPANYNAME= getControlValue("COMPANY_NAME");
		 ISBLACKLISTED = getControlValue("IS_BLACKLISTED");
		 ISNEGATED  = getControlValue("IS_NEGATED");
		 ISNEGATED  = getControlValue("IS_NEGATED");*/
		//getAccountType for Card
		 CallName="CUSTOMER_DETAILS";
		 StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n" +
				"<MsgFormat>CUSTOMER_DETAILS</MsgFormat>\n" +
				"<MsgVersion>0000</MsgVersion>\n" +
				"<RequestorChannelId>BPM</RequestorChannelId>\n" +
				"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
				"<RequestorLanguage>E</RequestorLanguage>\n" +
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
				"<ReturnCode>911</ReturnCode>\n" +
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
				"<MessageId>143282719608815876</MessageId>\n" +
				"<Extra1>REQ||LAXMANRET.LAXMANRET</Extra1>\n" +
				"<Extra2>2015-05-28T21:03:16.088+05:30</Extra2>\n" +
				"</EE_EAI_HEADER><FetchCustomerDetailsReq><BankId>RAK</BankId><CCIFID></CCIFID><RCIFID>"+CIFNumber+"</RCIFID><DealProdType></DealProdType><FetchExpired></FetchExpired></FetchCustomerDetailsReq></EE_EAI_MESSAGE>");
				
			
				mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for  customer_details call" + mqInputRequest);
	}
	
	else if(control.equals("fetch_acc_details"))
	{
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature control--");
		//String acc_selected = Data;
		String selectedCIFNumber = getControlValue("CIF_ID");
		CallName="ACCOUNT_SUMMARY";
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", $$selectedCIFNumber "+selectedCIFNumber);
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ACCOUNT_SUMMARY</MsgFormat>\n"+    //Change ACCOUNT_SUMMARY1 to ACCOUNT_SUMMARY at UAT
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
				"</EE_EAI_HEADER><FetchAccountListReq><BankId>RAK</BankId><CIFID>"+selectedCIFNumber+"</CIFID><FetchClosedAcct>N</FetchClosedAcct><AccountIndicator>O</AccountIndicator></FetchAccountListReq></EE_EAI_MESSAGE>");
		
		mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for Fetch Account details call" + mqInputRequest);
	}
	else if(control.equals("btn_View_Signature"))
	{
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside btn_View_Signature control--");
		String acc_selected = Data;
		CallName="SIGNATURE_DETAILS";
		String selectedCIFNumber = getControlValue("CIF_ID");
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", $$selectedCIFNumber "+selectedCIFNumber);
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>SIGNATURE_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>MDL053169111</MessageId>\n"+
				"<Extra1>REQ||PERCOMER.PERCOMER</Extra1>\n"+
				"<Extra2>2007-01-01T10:30:30.000Z</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<SignatureDetailsReq><BankId>RAK</BankId><CustId></CustId><AcctId>"+acc_selected+"</AcctId></SignatureDetailsReq>\n"+
				"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for Signature Details call" + mqInputRequest);
	}
	
	try {
	
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", userName "+ userName);
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", sessionID "+ sessionID);
	
	String sMQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'CMS' and CallingSource = 'Form'";
	List<List<String>> outputMQXML = iformObj.getDataFromDB(sMQuery);
	//CreditCard.mLogger.info("$$outputgGridtXML "+ "sMQuery " + sMQuery);
	if (!outputMQXML.isEmpty()) {
		//CreditCard.mLogger.info("$$outputgGridtXML "+ outputMQXML.get(0).get(0) + "," + outputMQXML.get(0).get(1));
		socketServerIP = outputMQXML.get(0).get(0);
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerIP " + socketServerIP);
		socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerPort " + socketServerPort);
		
		CMS.mLogger.debug(" outside socket"+socket);
		
		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0)) {
			socket = new Socket(socketServerIP, socketServerPort);
			
			int connection_timeout=60;
				try{
					connection_timeout=70;
					//connection_timeout = Integer.parseInt(NGFUserResourceMgr_CreditCard.getGlobalVar("Integration_Connection_Timeout"));
				}
				catch(Exception e){
					connection_timeout=60;
				}
				
			socket.setSoTimeout(connection_timeout*1000);
			out = socket.getOutputStream();
			
			CMS.mLogger.debug("connection timeout"+connection_timeout);
			CMS.mLogger.debug(" inside socket"+socket);	
			CMS.mLogger.debug("out" +out);
			
			socketInputStream = socket.getInputStream();
			
			CMS.mLogger.debug("socketInputStream"+socketInputStream);
			
			dout = new DataOutputStream(out);
			din = new DataInputStream(socketInputStream);
			
			CMS.mLogger.debug("dout"+dout);
			CMS.mLogger.debug("din"+din);
			
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", dout " + dout);
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", din " + din);
			mqOutputResponse = "";
			mqOutputResponse1 = "";
			
	
			if (mqInputRequest != null && mqInputRequest.length() > 0) {
				int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final XML output len: "+outPut_len + "");
				mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MqInputRequest"+"Input Request Bytes : "+ mqInputRequest.getBytes("UTF-16LE"));
				dout.write(mqInputRequest.getBytes("UTF-16LE"));dout.flush();
			}
			byte[] readBuffer = new byte[500];
			int num = din.read(readBuffer);
			if (num > 0) {
	
				byte[] arrayBytes = new byte[num];
				System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
				mqOutputResponse = mqOutputResponse+ new String(arrayBytes, "UTF-16LE");
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse/message ID :  "+mqOutputResponse);
				
				mqOutputResponse1 = mqOutputResponse1+ new String(arrayBytes, "UTF-16LE");
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse1/message ID :  "+mqOutputResponse1+", CallName :"+CallName);
				
				if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("customer_details"))
				{					
					mqOutputResponse = getOutWtthMessageID("CUSTOMER_DETAILS",iformObj,mqOutputResponse);
				}
				
				if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("fetch_acc_details"))
				{
				 mqOutputResponse = getOutWtthMessageID("ACCOUNT_SUMMARY",iformObj,mqOutputResponse);
				}
				
				if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_View_Signature"))
				{
					mqOutputResponse = getOutWtthMessageID(CallName,iformObj,mqOutputResponse);
				}
				
					
				if(mqOutputResponse.contains("&lt;")){
					mqOutputResponse=mqOutputResponse.replaceAll("&lt;", "<");
					mqOutputResponse=mqOutputResponse.replaceAll("&gt;", ">");
				}
			}
			socket.close();
			//CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse::::::::::::  "+mqOutputResponse);
			return mqOutputResponse;
			
		} else {
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp and SocketServerPort is not maintained "+"");
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp is not maintained "+	socketServerIP);
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerPort is not maintained "+	socketServerPort);
			return "MQ details not maintained";
		}
	} else {
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SOcket details are not maintained in NG_BPM_MQ_TABLE table"+"");
		return "MQ details not maintained";
	}
	
	} catch (Exception e) {
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception Occured Mq_connection_CC"+e.getStackTrace());
	return "";
	}
	finally{
	try{
		if(out != null){
			
			out.close();
			out=null;
			}
		if(socketInputStream != null){
			
			socketInputStream.close();
			socketInputStream=null;
			}
		if(dout != null){
			
			dout.close();
			dout=null;
			}
		if(din != null){
			
			din.close();
			din=null;
			}
		if(socket != null){
			if(!socket.isClosed()){
				socket.close();
			}
			socket=null;
		}
	}catch(Exception e)
	{
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final Exception Occured Mq_connection_CC"+e.getStackTrace());
		//printException(e);
	}
	}
	}
	
	
		/*public String MQ_connection_response1(IFormReference iformObj,String control,String Data) 
	{
		
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside MQ_connection_response1 function");
	final IFormReference iFormOBJECT;
	final WDGeneralData wdgeneralObj;	
	Socket socket = null;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String mqOutputResponse = null;
	String mqOutputResponse1 = null;
	String mqOutputResponse_Entity = null;
	String mqOutputResponse_Account = null;
	String mqInputRequest = null;
	String mqOutputResponse_Entity1 = null;
	String mqOutputResponse_Account1 = null;
	String mqInputRequest1 = null;
	String cabinetName = getCabinetName();
	String wi_name = getWorkitemName();
	String ws_name = getActivityName();
	String sessionID = getSessionId();
	String userName = getUserName();
	String socketServerIP;
	int socketServerPort;
	wdgeneralObj = iformObj.getObjGeneralData();
	sessionID = wdgeneralObj.getM_strDMSSessionId();
	String CIFNumber="";
	String TLNUMBER ="";
	String TLEXPIRYDATE="";
	String COMPANYNAME="";
	String ISBLACKLISTED="";
	String ISNEGATED="";


	
	if(control.equals("btn_Populate"))
	{
		 CIFNumber=  getControlValue("CIF_ID");
		 CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", CIFNumber for the account summary call is --"+CIFNumber);
		 /*TLNUMBER = getControlValue("TL_NUMBER");
		 TLEXPIRYDATE= getControlValue("TL_EXPIRY_DATE");
		 COMPANYNAME= getControlValue("COMPANY_NAME");
		 ISBLACKLISTED = getControlValue("IS_BLACKLISTED");
		 ISNEGATED  = getControlValue("IS_NEGATED");
		 ISNEGATED  = getControlValue("IS_NEGATED");
		//getAccountType for Card

				
	StringBuilder finalXml1 = new StringBuilder("<EE_EAI_MESSAGE>\n"+
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
			"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+CIFNumber+"</CIFID><FetchClosedAcct>N</FetchClosedAcct><AccountIndicator>O</AccountIndicator></FetchAccountListReq>\n"+
			"</EE_EAI_MESSAGE>");
			
	
	mqInputRequest1 = getMQInputXML1(sessionID, cabinetName,wi_name, ws_name, userName, finalXml1);
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest1 for Account Summary call: " + mqInputRequest1);
				

	}
	try {
	
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", userName "+ userName);
	CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", sessionID "+ sessionID);
	
	String sMQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_RLOS_MQ_TABLE with (nolock) where host_name = 'mq'";
	List<List<String>> outputMQXML = iformObj.getDataFromDB(sMQuery);
	//CreditCard.mLogger.info("$$outputgGridtXML "+ "sMQuery " + sMQuery);
	if (!outputMQXML.isEmpty()) {
		//CreditCard.mLogger.info("$$outputgGridtXML "+ outputMQXML.get(0).get(0) + "," + outputMQXML.get(0).get(1));
		socketServerIP = outputMQXML.get(0).get(0);
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerIP " + socketServerIP);
		socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerPort " + socketServerPort);
		
		CMS.mLogger.debug(" outside socket"+socket);
		
		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0)) {
			socket = new Socket(socketServerIP, socketServerPort);
			
			int connection_timeout=60;
				try{
					connection_timeout=70;
					//connection_timeout = Integer.parseInt(NGFUserResourceMgr_CreditCard.getGlobalVar("Integration_Connection_Timeout"));
				}
				catch(Exception e){
					connection_timeout=60;
				}
				
			socket.setSoTimeout(connection_timeout*1000);
			out = socket.getOutputStream();
			
			CMS.mLogger.debug("connection timeout"+connection_timeout);
			CMS.mLogger.debug(" inside socket"+socket);	
			CMS.mLogger.debug("out" +out);
			
			socketInputStream = socket.getInputStream();
			
			CMS.mLogger.debug("socketInputStream"+socketInputStream);
			
			dout = new DataOutputStream(out);
			din = new DataInputStream(socketInputStream);
			
			CMS.mLogger.debug("dout"+dout);
			CMS.mLogger.debug("din"+din);
			
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", dout " + dout);
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", din " + din);
			mqOutputResponse1 = "";
			
	
			if (mqInputRequest != null && mqInputRequest.length() > 0) {
				int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final XML output len: "+outPut_len + "");
				mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MqInputRequest"+"Input Request Bytes : "+ mqInputRequest.getBytes("UTF-16LE"));
				dout.write(mqInputRequest.getBytes("UTF-16LE"));dout.flush();
			}
			byte[] readBuffer = new byte[500];
			int num = din.read(readBuffer);
			if (num > 0) {
	
				byte[] arrayBytes = new byte[num];
				System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
				mqOutputResponse = mqOutputResponse+ new String(arrayBytes, "UTF-16LE");
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse/message ID :  "+mqOutputResponse);
				
				mqOutputResponse1 = mqOutputResponse1+ new String(arrayBytes, "UTF-16LE");
				CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse1/message ID :  "+mqOutputResponse1);
				
				if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_Populate"))
				{
					//mqOutputResponse = getOutWtthMessageID("CUSTOMER_DETAILS",iformObj,mqOutputResponse);
					mqOutputResponse1 = getOutWtthMessageID1("ACCOUNT_SUMMARY",iformObj,mqOutputResponse1);
				}
				
				
				
					
				if(mqOutputResponse1.contains("&lt;")){
					mqOutputResponse1=mqOutputResponse1.replaceAll("&lt;", "<");
					mqOutputResponse1=mqOutputResponse1.replaceAll("&gt;", ">");
				}
			}
			socket.close();
			return mqOutputResponse1;
			
		} else {
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp and SocketServerPort is not maintained "+"");
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp is not maintained "+	socketServerIP);
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerPort is not maintained "+	socketServerPort);
			return "MQ details not maintained";
		}
	} else {
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SOcket details are not maintained in NG_RLOS_MQ_TABLE table"+"");
		return "MQ details not maintained";
	}
	
	} catch (Exception e) {
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception Occured Mq_connection_CC"+e.getStackTrace());
	return "";
	}
	finally{
	try{
		if(out != null){
			
			out.close();
			out=null;
			}
		if(socketInputStream != null){
			
			socketInputStream.close();
			socketInputStream=null;
			}
		if(dout != null){
			
			dout.close();
			dout=null;
			}
		if(din != null){
			
			din.close();
			din=null;
			}
		if(socket != null){
			if(!socket.isClosed()){
				socket.close();
			}
			socket=null;
		}
	}catch(Exception e)
	{
		//		RLOS.mLogger.info("Exception occurred while closing socket");
		CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final Exception Occured Mq_connection_CC"+e.getStackTrace());
		//printException(e);
	}
	}
	}*/
	
	private static String getMQInputXML(String sessionID, String cabinetName,
			String wi_name, String ws_name, String userName,
			StringBuilder final_xml) {
		//FormContext.getCurrentInstance().getFormConfig();
		CMS.mLogger.debug("inside getMQInputXML function");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>"+XMLLOG_HISTORY+"</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_xml);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		return strBuff.toString();
	}
		
	public String getOutWtthMessageID(String callName,IFormReference iformObj,String message_ID){
		String outputxml="";
		try{
			CMS.mLogger.debug("getOutWtthMessageID - callName :"+callName);
			//String wi_name = iformObj.getWFWorkitemName();
			String wi_name = getWorkitemName();
			String str_query = "select OUTPUT_XML from "+ XMLLOG_HISTORY +" with (nolock) where CALLNAME ='"+callName+"' and MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", inside getOutWtthMessageID str_query: "+ str_query);
			List<List<String>> result=iformObj.getDataFromDB(str_query);
			//below code added by nikhil 18/10 for Connection timeout
			//String Integration_timeOut=NGFUserResourceMgr_CreditCard.getGlobalVar("Inegration_Wait_Count");
			String Integration_timeOut="100";
			int Loop_wait_count=10;
			try
			{
				Loop_wait_count=Integer.parseInt(Integration_timeOut);
			}
			catch(Exception ex)
			{
				Loop_wait_count=10;
			}
		
			for(int Loop_count=0;Loop_count<Loop_wait_count;Loop_count++){
				if(result.size()>0){
					outputxml = result.get(0).get(0);
					break;
				}
				else{
					Thread.sleep(1000);
					result=iformObj.getDataFromDB(str_query);
				}
			}
			
			if("".equalsIgnoreCase(outputxml)){
				outputxml="Error";
			}
			CMS.mLogger.debug("This is output xml from DB");
			String outputxmlMasked = outputxml;
			//CMS.mLogger.debug("The output XML is "+outputxml);
			outputxmlMasked = maskXmlogBasedOnCallType(outputxmlMasked,callName);    //uncomment it at UAT
			//CMS.mLogger.debug("Masked output XML is "+outputxmlMasked);
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", getOutWtthMessageID" + outputxmlMasked);				
		}
		catch(Exception e){
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception occurred in getOutWtthMessageID" + e.getMessage());
			CMS.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception occurred in getOutWtthMessageID" + e.getStackTrace());
			outputxml="Error";
		}
		return outputxml;
	}
	
	public String maskXmlogBasedOnCallType(String outputxmlMasked, String callType)
	{
		String Tags = "";
		if (callType.equalsIgnoreCase("CUSTOMER_DETAILS"))
		{
			outputxmlMasked = outputxmlMasked.replace("("," ").replace(")"," ").replace("@"," ").replace("+"," ").replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");
			Tags = "<ACCNumber>~,~<AccountName>~,~<ECRNumber>~,~<DOB>~,~<MothersName>~,~<IBANNumber>~,~<DocId>~,~<DocExpDt>~,~<DocIssDate>~,~<PassportNum>~,~<MotherMaidenName>~,~<LinkedDebitCardNumber>~,~<FirstName>~,~<MiddleName>~,~<LastName>~,~<FullName>~,~<ARMCode>~,~<ARMName>~,~<PhnCountryCode>~,~<PhnLocalCode>~,~<PhoneNo>~,~<EmailID>~,~<CustomerName>~,~<CustomerMobileNumber>~,~<PrimaryEmailId>~,~<Fax>~,~<AddressType>~,~<AddrLine1>~,~<AddrLine2>~,~<AddrLine3>~,~<AddrLine4>~,~<POBox>~,~<City>~,~<Country>~,~<AddressLine1>~,~<AddressLine2>~,~<AddressLine3>~,~<AddressLine4>~,~<CityCode>~,~<State>~,~<CountryCode>~,~<Nationality>~,~<ResidentCountry>~,~<PrimaryContactName>~,~<PrimaryContactNum>~,~<SecondaryContactName>~,~<SecondaryContactNum>";
			
		}

			else if (callType.equalsIgnoreCase("ACCOUNT_SUMMARY"))
		{
			outputxmlMasked = outputxmlMasked.replace("("," ").replace(")"," ").replace("@"," ").replace("+"," ").replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");
			Tags = "<Acid>~,~<Foracid>~,~<NicName>~,~<AccountName>~,~<AcctBal>~,~<LoanAmtAED>~,~<AcctOpnDt>~,~<MaturityAmt>~,~<EffAvailableBal>~,~<EquivalentAmt>~,~<LedgerBalanceinAED>~,~<LedgerBalance>";
		}
		else if (callType.equalsIgnoreCase("SIGNATURE_DETAILS"))
		{
			outputxmlMasked = outputxmlMasked.replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");
			Tags = "<CustomerName>";
		}
		if (!Tags.equalsIgnoreCase(""))
		{
	    	String Tag[] = Tags.split("~,~");
	    	for(int i=0;i<Tag.length;i++)
	    	{
	    		outputxmlMasked = maskXmlTags(outputxmlMasked,Tag[i]);
	    	}
		}
    	return outputxmlMasked;
	}
	
}


