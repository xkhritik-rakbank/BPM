package com.newgen.iforms.user;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.List;

import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;

public class CBPIntegration extends CBPCommon{

	public String onLoadEvent(IFormReference iformObj,String control,String StringData)
	{
		String MQ_response="";
		String MQ_response_Entity="";
		String ReturnCode="";
		String ReturnDesc="";
		String CifId="";
		try
		{
			CBP.mLogger.debug("Integration event for "+control+ " Activity is "+getActivityName());
			MQ_response = MQ_connection_response(iformObj,control,StringData);
			
			
			
			MQ_response_Entity=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
			
			if(MQ_response_Entity.indexOf("<ReturnCode>")!=-1)
			{
				ReturnCode = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response_Entity.indexOf("</ReturnCode>"));
				
			}
			ReturnDesc = "";
			if(MQ_response_Entity.indexOf("<ReturnDesc>")!=-1)
			{
				ReturnDesc = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response_Entity.indexOf("</ReturnDesc>"));
				
			}
			
			if(ReturnCode.equals("0000"))
			{
				if(MQ_response_Entity.contains("<CIFID>"))
				{
					CifId = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<CIFID>")+"</CIFID>".length()-1,MQ_response_Entity.indexOf("</CIFID>"));
					setControlValue("CIF_ID", CifId); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Main cif id is--"+CifId);
				}
				
				if (MQ_response_Entity.contains("<PhnDet>"))
				{
					String PrimaryPhone="";
					Document recordDoc3=MapXML.getDocument(MQ_response_Entity);
					NodeList records3= MapXML.getNodeListFromDocument(recordDoc3, "PhnDet");
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records3.getLength());
					if(records3.getLength() > 0)
					{
						for(int rec3=0;rec3<records3.getLength();rec3++)
						{
							if(MapXML.getTagValueFromNode(records3.item(rec3),"PhnPrefFlag").equalsIgnoreCase("Y"))
							{
								PrimaryPhone = MapXML.getTagValueFromNode(records3.item(rec3),"PhoneNo").replace("+", "").replace("()","");
								setControlValue("MOBILE_NUMBER", PrimaryPhone);
								//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", main email id is--"+Primaryemail);
							}
						}
					}
				}
				if (MQ_response_Entity.contains("<EmailDet>"))
				{
					String PrimaryEmail="";
					Document recordDoc3=MapXML.getDocument(MQ_response_Entity);
					NodeList records3= MapXML.getNodeListFromDocument(recordDoc3, "EmailDet");
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records3.getLength());
					if(records3.getLength() > 0)
					{
						for(int rec3=0;rec3<records3.getLength();rec3++)
						{
							if(MapXML.getTagValueFromNode(records3.item(rec3),"MailPrefFlag").equalsIgnoreCase("Y"))
							{
								PrimaryEmail = MapXML.getTagValueFromNode(records3.item(rec3),"EmailID");
								setControlValue("EMAIL_ID", PrimaryEmail);
								//PC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", main email id is--"+Primaryemail);
							}
						}
					}
				}
				if(MQ_response_Entity.contains("<FirstName>"))
				{
					String firstName="";
					firstName = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<FirstName>")+"</FirstName>".length()-1,MQ_response_Entity.indexOf("</FirstName>"));
					setControlValue("FIRST_NAME", firstName); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", First Name is "+firstName);
				}
				if(MQ_response_Entity.contains("<MiddleName>"))
				{
					String middleName="";
					middleName = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<MiddleName>")+"</MiddleName>".length()-1,MQ_response_Entity.indexOf("</MiddleName>"));
					setControlValue("MIDDLE_NAME", middleName); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Middle Name is "+middleName);
				}
				if(MQ_response_Entity.contains("<LastName>"))
				{
					String lastName="";
					lastName = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<LastName>")+"</LastName>".length()-1,MQ_response_Entity.indexOf("</LastName>"));
					setControlValue("LAST_NAME", lastName); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Last Name is "+lastName);
				}
				if(MQ_response_Entity.contains("<Gender>"))
				{
					String gender="";
					gender = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<Gender>")+"</Gender>".length()-1,MQ_response_Entity.indexOf("</Gender>"));
					/*if("M".equals(gender))
						gender="Male";
					else if("F".equals(gender))
						gender="Female";*/
					setControlValue("GENDER", gender); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Gender is "+gender);
				}
				if(MQ_response_Entity.contains("<DOB>"))
				{
					String dateOfBirth="";
					dateOfBirth = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<DOB>")+"</DOB>".length()-1,MQ_response_Entity.indexOf("</DOB>"));
					dateOfBirth = dateOfBirth.substring(8,10)+"/"+dateOfBirth.substring(5,7)+"/"+dateOfBirth.substring(0,4);
					setControlValue("DOB", dateOfBirth); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Date of Birth is "+dateOfBirth);
				
				}
				
				if(MQ_response_Entity.contains("<Nationality>"))
				{
					String nationality="";
					nationality = MQ_response_Entity.substring(MQ_response_Entity.indexOf("<Nationality>")+"</Nationality>".length()-1,MQ_response_Entity.indexOf("</Nationality>"));
					setControlValue("NATIONALITY", nationality); 
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Nationality is "+nationality);
				}
				
				if (MQ_response_Entity.contains("<DocumentDet>"))
				{
					String EmiratesID="";
					String EmiratesIDExpiryDate="";
					Document recordDoc2=MapXML.getDocument(MQ_response_Entity);
					NodeList records2= MapXML.getNodeListFromDocument(recordDoc2, "DocumentDet");
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records2.getLength());
					if(records2.getLength() > 0)
					{
						for(int rec2=0;rec2<records2.getLength();rec2++)
						{
							if(MapXML.getTagValueFromNode(records2.item(rec2),"DocType").equalsIgnoreCase("EMID"))
							{
							    EmiratesID = MapXML.getTagValueFromNode(records2.item(rec2),"DocId");
								setControlValue("EMIRATES_ID", EmiratesID); 
								
							   EmiratesIDExpiryDate = MapXML.getTagValueFromNode(records2.item(rec2),"DocExpDt");
								EmiratesIDExpiryDate = EmiratesIDExpiryDate.substring(8,10)+"/"+EmiratesIDExpiryDate.substring(5,7)+"/"+EmiratesIDExpiryDate.substring(0,4);
								setControlValue("EMIRATES_EXPIRY_DATE", EmiratesIDExpiryDate); 
							}
							
						}
					}
				}
				if (MQ_response_Entity.contains("<AddrDet>"))
				{
					String addrLine1="";
					String addrLine2="";
					String city="";
					String poBox="";
					String country="";
					Document recordDoc2=MapXML.getDocument(MQ_response_Entity);
					NodeList records2= MapXML.getNodeListFromDocument(recordDoc2, "AddrDet");
					CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Total Lines returned for document tag: "+records2.getLength());
					if(records2.getLength() > 0)
					{
						for(int rec2=0;rec2<records2.getLength();rec2++)
						{
							if(MapXML.getTagValueFromNode(records2.item(rec2),"AddressType").equalsIgnoreCase("RESIDENCE"))
							{
							    addrLine1 = MapXML.getTagValueFromNode(records2.item(rec2),"AddrLine1");
								setControlValue("RESIDENCEADDRLINE1", addrLine1); 
								
								addrLine2 = MapXML.getTagValueFromNode(records2.item(rec2),"AddrLine2");
								setControlValue("RESIDENCEADDRLINE2", addrLine2);
							   
								city=MapXML.getTagValueFromNode(records2.item(rec2),"City");
								setControlValue("RESIDENCEADDRCITY", city);
								
								country=MapXML.getTagValueFromNode(records2.item(rec2),"Country");
								setControlValue("RESIDENCEADDRCOUNTRY", country);
								
								poBox=MapXML.getTagValueFromNode(records2.item(rec2),"POBox");
								setControlValue("RESIDENCEADDRPOBOX", country);
								
								
							}
							
						}
					}
				}
				
			}
			
		}
		catch(Exception e)
		{
			CBP.mLogger.debug("Exception with control name "+control);
			CBP.mLogger.debug("Exception in  on Load integration call "+e.getMessage());
		}
		return ReturnCode+"~"+ReturnDesc+"~End";
	}
	
	
	public String MQ_connection_response(IFormReference iformObj,String control,String Data) 
	{
		
	CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Inside MQ_connection_response function");
	final IFormReference iFormOBJECT;
	final WDGeneralData wdgeneralObj;	
	Socket socket = null;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String mqOutputResponse = null;
	String mqOutputResponse_Entity = null;
	String mqOutputResponse_Account = null;
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
	String EmiratesID ="";
	String AccountNumber="";
	
	
	if(control.equals("on_Load_Entity"))
	{
		 CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", CIFNumber for the first entity detail call is --"+CIFNumber);
		 AccountNumber= getControlValue("ACC_NUMBER");

	StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>saddd</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID></CIFID><ACCType>A</ACCType><ACCNumber>"+AccountNumber+"</ACCNumber><EmiratesID>"+EmiratesID+"</EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqInputRequest for first Entity Detail call" + mqInputRequest);
	}
	

	
	
	
	try {
	
	CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", userName "+ userName);
	CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", sessionID "+ sessionID);
	
	String sMQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'CBP' and CallingSource = 'Form'";
	List<List<String>> outputMQXML = iformObj.getDataFromDB(sMQuery);
	//CreditCard.mLogger.info("$$outputgGridtXML "+ "sMQuery " + sMQuery);
	if (!outputMQXML.isEmpty()) {
		//CreditCard.mLogger.info("$$outputgGridtXML "+ outputMQXML.get(0).get(0) + "," + outputMQXML.get(0).get(1));
		socketServerIP = outputMQXML.get(0).get(0);
		CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerIP " + socketServerIP);
		socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
		CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", socketServerPort " + socketServerPort);
		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0)) {
			socket = new Socket(socketServerIP, socketServerPort);
			//new Code added by Deepak to set connection timeout
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
			socketInputStream = socket.getInputStream();
			dout = new DataOutputStream(out);
			din = new DataInputStream(socketInputStream);
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", dout " + dout);
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", din " + din);
			mqOutputResponse = "";
			
	
			if (mqInputRequest != null && mqInputRequest.length() > 0) {
				int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
				CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final XML output len: "+outPut_len + "");
				mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
				CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MqInputRequest"+"Input Request Bytes : "+ mqInputRequest.getBytes("UTF-16LE"));
				dout.write(mqInputRequest.getBytes("UTF-16LE"));dout.flush();
			}
			byte[] readBuffer = new byte[500];
			int num = din.read(readBuffer);
			if (num > 0) {
	
				byte[] arrayBytes = new byte[num];
				System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
				mqOutputResponse = mqOutputResponse+ new String(arrayBytes, "UTF-16LE");
				CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", mqOutputResponse/message ID :  "+mqOutputResponse);
				if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("on_Load_Entity")){
					mqOutputResponse = getOutWtthMessageID("ENTITY_DETAILS",iformObj,mqOutputResponse);
					CBP.mLogger.debug("Coming here after the response");
				}
					
				if(mqOutputResponse.contains("&lt;")){
					mqOutputResponse=mqOutputResponse.replaceAll("&lt;", "<");
					mqOutputResponse=mqOutputResponse.replaceAll("&gt;", ">");
				}
			}
			socket.close();
			return mqOutputResponse;
			
		} else {
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp and SocketServerPort is not maintained "+"");
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerIp is not maintained "+	socketServerIP);
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SocketServerPort is not maintained "+	socketServerPort);
			return "MQ details not maintained";
		}
	} else {
		CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", SOcket details are not maintained in NG_BPM_MQ_TABLE table"+"");
		return "MQ details not maintained";
	}
	
	} catch (Exception e) {
		CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception Occured Mq_connection_CC"+e.getStackTrace());
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
		CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Final Exception Occured Mq_connection_CC"+e.getStackTrace());
		//printException(e);
	}
	}
	}
	private static String getMQInputXML(String sessionID, String cabinetName,
			String wi_name, String ws_name, String userName,
			StringBuilder final_xml) {
		//FormContext.getCurrentInstance().getFormConfig();
		CBP.mLogger.debug("inside getMQInputXML function");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_CBP_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
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
			//String wi_name = iformObj.getWFWorkitemName();
			String wi_name = getWorkitemName();
			String str_query = "select OUTPUT_XML from NG_CBP_XMLLOG_HISTORY with (nolock) where CALLNAME ='"+callName+"' and MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", inside getOutWtthMessageID str_query: "+ str_query);
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
			CBP.mLogger.debug("This is output xml from DB");
			String outputxmlMasked = outputxml;
			CBP.mLogger.debug("The output XML is "+outputxml);
			//outputxmlMasked = maskXmlogBasedOnCallType(outputxmlMasked,callName); commented by Sajan
			CBP.mLogger.debug("Masked output XML is "+outputxmlMasked);
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", getOutWtthMessageID" + outputxmlMasked);				
		}
		catch(Exception e){
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception occurred in getOutWtthMessageID" + e.getMessage());
			CBP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", Exception occurred in getOutWtthMessageID" + e.getStackTrace());
			outputxml="Error";
		}
		return outputxml;
	}
	
	public String maskXmlogBasedOnCallType(String outputxmlMasked, String callType)
	{
		String Tags = "";
		if (callType.equalsIgnoreCase("ENTITY_DETAILS"))
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
