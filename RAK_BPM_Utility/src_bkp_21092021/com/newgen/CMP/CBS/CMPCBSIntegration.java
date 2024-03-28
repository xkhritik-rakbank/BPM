package com.newgen.CMP.CBS;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;

public class CMPCBSIntegration {

	private String CMP_EXTTABLE = "RB_CMP_EXTTABLE";
	private String XMLLOG_HISTORY_TABLE = "NG_CMP_XMLLOG_HISTORY";
	private String ws_name="Core_System_Update";
	
	Socket socket=null;
	String socketServerIP="";
	int socketServerPort=0;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String outputResponse = null;
	String inputRequest = null;	
	String inputMessageID = null;
	String CustomerID="";
	String strDocDownloadPath="";

	public ResponseBean CMPCBSCustomerCreationIntegration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId) throws Exception
	{
		strDocDownloadPath=docDownloadPath;
		ResponseBean objResponseBean=new ResponseBean();

		String QueryString="SELECT SOL_ID,"
		        + "RESIDENCEADDRLINE1,RESIDENCEADDRLINE2,RESIDENCEADDRCITY,RESIDENCEADDRCOUNTRY,RESIDENCEADDRPOBOX,"
				+ "PASSPORT_NUMBER,PASSPORT_EXPIRY_DATE,EMIRATES_ID,EMIRATES_ID_EXPIRY_DATE,"
			 	+ "FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,"
				+ "DOB,NATIONALITY,ITEMINDEX,MOBILE_NO,MOBILE_NO_COUNTRY_CODE,EMAIL_ID,CREATE_CUSTOMER_STATUS FROM "+CMP_EXTTABLE+" with (nolock) where WINAME='"+wi_name+"'";

		//objResponseBean.setAccountCreationReturnCode("Success");

		String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
		CMPCBSLog.CMPCBSLogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

		String sOutputXML=CMPCBS.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
		CMPCBSLog.CMPCBSLogger.debug("Output XML for extranl Table select "+sOutputXML);

		XMLParser sXMLParser= new XMLParser(sOutputXML);
	    String sMainCode = sXMLParser.getValueOf("MainCode");
	    CMPCBSLog.CMPCBSLogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
	    CMPCBSLog.CMPCBSLogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			CMPCBSLog.CMPCBSLogger.debug("Inside If loop");
			CustomerBean objCustBean=new CustomerBean();
			String strSolId=sXMLParser.getValueOf("SOL_ID");
			//if(!("".equals(strSolId)))
			objCustBean.setSolId(strSolId);
			CMPCBSLog.CMPCBSLogger.debug("Sold Id is "+strSolId);

			String strResAddrLine1=sXMLParser.getValueOf("RESIDENCEADDRLINE1");
			objCustBean.setResidenceAddrLine1(strResAddrLine1);
			CMPCBSLog.CMPCBSLogger.debug("Residence Address line 1"+strResAddrLine1);

			String strResAddrLine2=sXMLParser.getValueOf("RESIDENCEADDRLINE2");
			objCustBean.setResidenceAddrLine2(strResAddrLine2);
			CMPCBSLog.CMPCBSLogger.debug("Residence Address line 2"+strResAddrLine2);

			String strResAddrCity=sXMLParser.getValueOf("RESIDENCEADDRCITY");
			objCustBean.setResidenceAddrCity(strResAddrCity);
			CMPCBSLog.CMPCBSLogger.debug("Residence Address City "+strResAddrCity);

			String strResAddrCountry=sXMLParser.getValueOf("RESIDENCEADDRCOUNTRY");
			objCustBean.setResidenceAddrCountry(strResAddrCountry);
			CMPCBSLog.CMPCBSLogger.debug("Residence Address country "+strResAddrCountry);

			String strResAddrPOBox=sXMLParser.getValueOf("RESIDENCEADDRPOBOX");
			objCustBean.setResidenceAddrPOBox(strResAddrPOBox);
			CMPCBSLog.CMPCBSLogger.debug("Residence Address PO box "+strResAddrPOBox);
			
			String strFirstName=sXMLParser.getValueOf("FIRST_NAME");
			objCustBean.setFirstName(strFirstName);

			String strMiddleName=sXMLParser.getValueOf("MIDDLE_NAME");
			objCustBean.setMiddleName(strMiddleName);

			String strLastName=sXMLParser.getValueOf("LAST_NAME");
			objCustBean.setLastName(strLastName);

			String strGender=sXMLParser.getValueOf("GENDER");
			objCustBean.setGender(strGender);

			String strItemIndex=sXMLParser.getValueOf("ITEMINDEX");
			objCustBean.setItemIndex(strItemIndex);

			String strDOB=sXMLParser.getValueOf("DOB");
			objCustBean.setDob(strDOB);

			String strNationality=sXMLParser.getValueOf("NATIONALITY");
			objCustBean.setNationality(strNationality);

			objCustBean.setWiName(wi_name);

			String strPassportNumber=sXMLParser.getValueOf("PASSPORT_NUMBER");
			objCustBean.setPassportNumber(strPassportNumber);

			String strPassportExpDate=sXMLParser.getValueOf("PASSPORT_EXPIRY_DATE");
			objCustBean.setPassportExpDate(strPassportExpDate);

			
           	String strEmiratesId=sXMLParser.getValueOf("EMIRATES_ID");
			objCustBean.setEmiratesId(strEmiratesId);

			String strEmIdExpDate=sXMLParser.getValueOf("EMIRATES_ID_EXPIRY_DATE");
			objCustBean.setEmIdExpDate(strEmIdExpDate);
		
			String strCREATECustomerSTATUS=sXMLParser.getValueOf("CREATE_CUSTOMER_STATUS");
			
			String strIsExistingCustomer=sXMLParser.getValueOf("EXISTING_CUSTOMER");
			objCustBean.setIsExistingCustomer(strIsExistingCustomer);
			objResponseBean.setIsExistingCustomer(strIsExistingCustomer); 
			//if("N".equalsIgnoreCase(strIsExistingCustomer))
			// Start - Customer Creation Call 
			if(!"Y".equalsIgnoreCase(strIsExistingCustomer) && !"Success".equalsIgnoreCase(strCREATECustomerSTATUS))
			{
				String ResAddressForCustomerCreation=addressDetailsForCreateCustomer("RESIDENCE", strResAddrLine1, strResAddrLine2, strResAddrCity, strResAddrCountry, strResAddrPOBox);
						
				String PersonDetails=personDetailsForCreateCustomer(strFirstName, strLastName, strGender, strNationality, strDOB);
				
				String strMobileNo = sXMLParser.getValueOf("MOBILE_NO");
				String strMobileCntryCode = sXMLParser.getValueOf("MOBILE_NO_COUNTRY_CODE");
				String strEmailId = sXMLParser.getValueOf("EMAIL_ID");
				String PhoneDetails = "";
				if (!strMobileNo.equalsIgnoreCase("") && !strMobileNo.equalsIgnoreCase("null") && !strMobileCntryCode.equalsIgnoreCase("") && !strMobileCntryCode.equalsIgnoreCase("null"))
				{
					PhoneDetails = "<PhoneDetails>\n" +
						"<PhoneType>CELLPH1</PhoneType>\n" +
						"<PhoneNumber>"+strMobileCntryCode+strMobileNo+"</PhoneNumber>\n" +
						"<LocalCode>"+strMobileNo+"</LocalCode>\n" +
						"<CountryCode>"+strMobileCntryCode+"</CountryCode>\n" +
						//"<IsPreferred>Y</IsPreferred>\n" +
					"</PhoneDetails>\n";;
				}
				String EmailDetails = "";
				if (!strEmailId.equalsIgnoreCase("") && !strEmailId.equalsIgnoreCase("null"))
				{
					EmailDetails = "<EmailDetails>\n" +
						"<MailIdType>HOMEEML</MailIdType>\n" +
						"<MailIdValue>"+strEmailId+"</MailIdValue>\n" +
						//"<IsPreferred>Y</IsPreferred>\n" +
					"</EmailDetails>\n";
				}
				
				String DocDetails = "";
				if (!strEmiratesId.equalsIgnoreCase("") && !strEmiratesId.equalsIgnoreCase("null") && !strEmIdExpDate.equalsIgnoreCase("") && !strEmIdExpDate.equalsIgnoreCase("null"))
				{
					DocDetails = "<DocDetails>\n" +
						//"<DocType>Emirates ID</DocType>\n" +
						"<DocCode>EMID</DocCode>\n" +
						"<DocExpiryDate>"+strEmIdExpDate+"</DocExpiryDate>\n" +
						//"<ParentDocCode>RETAIL</ParentDocCode>\n" +
						"<DocRefNum>"+strEmiratesId+"</DocRefNum>\n" +
					"</DocDetails>\n";
				}
				if (!strPassportNumber.equalsIgnoreCase("") && !strPassportNumber.equalsIgnoreCase("null") && !strPassportExpDate.equalsIgnoreCase("") && !strPassportExpDate.equalsIgnoreCase("null"))
				{
					DocDetails = DocDetails + "<DocDetails>\n" +
						//"<DocType>Passport</DocType>\n" +
						"<DocCode>PPT</DocCode>\n" +
						"<DocExpiryDate>"+strPassportExpDate+"</DocExpiryDate>\n" +
						//"<ParentDocCode>RETAIL</ParentDocCode>\n" +
						"<DocRefNum>"+strPassportNumber+"</DocRefNum>\n" +
					"</DocDetails>\n";
				}
				/*if (!strVisaNumber.equalsIgnoreCase("") && !strVisaNumber.equalsIgnoreCase("null") && !strVisaExpDate.equalsIgnoreCase("") && !strVisaExpDate.equalsIgnoreCase("null"))
				{
					DocDetails = DocDetails + "<DocDetails>\n" +
						//"<DocType>Visa</DocType>\n" +
						"<DocCode>VISA</DocCode>\n" +
						"<DocExpiryDate>"+strVisaExpDate+"</DocExpiryDate>\n" +
						//"<ParentDocCode>RETAIL</ParentDocCode>\n" +
						"<DocRefNum>"+strVisaNumber+"</DocRefNum>\n" +
					"</DocDetails>\n";
				}
				 */
				
				java.util.Date d1 = new Date();
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
				String DateExtra2 = sdf1.format(d1)+"+04:00";
				
				sInputXML = "<EE_EAI_MESSAGE>\n" +
									"<EE_EAI_HEADER>\n" +
										"<MsgFormat>NEW_RMT_CUSTOMER_REQ</MsgFormat>\n" +
										"<MsgVersion>001</MsgVersion>\n"+
										"<RequestorChannelId>BPM</RequestorChannelId>\n" +
										"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
										"<RequestorLanguage>E</RequestorLanguage>\n" +
										"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
										"<ReturnCode>0000</ReturnCode>\n" +
										"<ReturnDesc>REQ</ReturnDesc>\n" +
										"<MessageId>testmsg1001</MessageId>\n" +
										"<Extra1>REQ||SHELL.dfgJOHN</Extra1>\n" +
										"<Extra2>"+DateExtra2+"</Extra2>\n" +
									"</EE_EAI_HEADER>\n"+
									"<NewRMTCustomerRequest>\n" +
										"<BankId>RAK</BankId>\n" +
										"<InitiatorChannel>YAP</InitiatorChannel>\n"+
										ResAddressForCustomerCreation +"\n" +
										//HomeAddressForCustomerCreation +"\n" +
										PhoneDetails +
										EmailDetails +
										DocDetails +
										PersonDetails + "\n" +
									"</NewRMTCustomerRequest>\n" +
								"</EE_EAI_MESSAGE>";

				CMPCBSLog.CMPCBSLogger.debug("Input XML for Customer creation is "+sInputXML);

				try
				{
					CMPCBSLog.CMPCBSLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					CMPCBSLog.CMPCBSLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					CMPCBSLog.CMPCBSLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						CMPCBSLog.CMPCBSLogger.debug("Data output stream is "+dout);
						CMPCBSLog.CMPCBSLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

						CMPCBSLog.CMPCBSLogger.debug("Input MQ XML for Customer creation is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							CMPCBSLog.CMPCBSLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							CMPCBSLog.CMPCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
							dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
						}
						byte[] readBuffer = new byte[500];
						int num = din.read(readBuffer);

						if (num > 0)
						{

							byte[] arrayBytes = new byte[num];
							System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
							outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
							inputMessageID = outputResponse;
							CMPCBSLog.CMPCBSLogger.debug("OutputResponse: "+outputResponse);

							if(!"".equalsIgnoreCase(outputResponse))
								outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
										wi_name,outputResponse,integrationWaitTime );
							if(outputResponse.contains("&lt;"))
							{
								outputResponse=outputResponse.replaceAll("&lt;", "<");
								outputResponse=outputResponse.replaceAll("&gt;", ">");
							}
						}
						socket.close();

						outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

						sXMLParser=new XMLParser(outputResponse);
						if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
						{
							objResponseBean.setCustomerCreationReturnCode("Success");
							objResponseBean.setIntegrationDecision("Success");
							objResponseBean.setIntFailedReason(" ");
							objResponseBean.setIntFailedCode(" ");
							objResponseBean.setMsgID(" ");
						}
						else
						{
							objResponseBean.setCustomerCreationReturnCode("Failure");
							objResponseBean.setIntegrationDecision("Failure");
							if(outputResponse.contains("<ReturnDesc>"))
								objResponseBean.setIntFailedReason(sXMLParser.getValueOf("ReturnDesc"));
							else if(outputResponse.contains("<Description>"))
								objResponseBean.setIntFailedReason(sXMLParser.getValueOf("Description"));
								
							if(outputResponse.contains("<ReturnCode>"))
								objResponseBean.setIntFailedCode(sXMLParser.getValueOf("ReturnCode"));
							if(outputResponse.contains("<MessageId>"))
								objResponseBean.setMsgID(sXMLParser.getValueOf("MessageId"));
						}
						CMPCBSLog.CMPCBSLogger.debug("Response XML for Customer creation is "+outputResponse);
					}
				}
				catch(Exception e)
				{
					CMPCBSLog.CMPCBSLogger.error("The Exception in Customer creation is "+e.getMessage());
				}
			} else
			{
				CMPCBSLog.CMPCBSLogger.error("Customer is already created or Existing Customer: ");
				objResponseBean.setCustomerCreationReturnCode("Success");
				
			}
			// End - Customer Creation Call
			
		}
		return objResponseBean;
	}
	public String addressDetailsForCreateCustomer(String AddressType,String addr_line1,String addr_line2,String addr_city,String addr_cntry,String addr_pobox)
	{
		String AddressXml = "<AddressDetails><AddressType></AddressType><AddrLine1></AddrLine1><AddrLine2></AddrLine2><City></City><CountryCode></CountryCode><POBox></POBox></AddressDetails>";
		if (addr_line2==null || addr_line2.equals(""))
			addr_line2 = ".";
		if(addr_line1==null || addr_line1.equals("") || addr_city==null || addr_city.equals(""))
			return "";
		else if (addr_cntry==null || addr_cntry.equals("") || addr_cntry.equals("--Select--"))
			return "";

		StringBuffer addressB = new StringBuffer(AddressXml);

		addressB = addressB.insert(addressB.indexOf("<AddressType>")+"<AddressType>".length(),AddressType );

		addressB = addressB.insert(addressB.indexOf("<AddrLine1>")+"<AddrLine1>".length(),addr_line1 );

		addressB = addressB.insert(addressB.indexOf("<AddrLine2>")+"<AddrLine2>".length(),addr_line2 );

		addressB = addressB.insert(addressB.indexOf("<City>")+"<City>".length(),addr_city );

		addressB = addressB.insert(addressB.indexOf("<CountryCode>")+"<CountryCode>".length(),addr_cntry );
		
		if(addr_pobox!=null && !addr_pobox.equals("") )
			addressB = addressB.insert(addressB.indexOf("<POBox>")+"<POBox>".length(),addr_pobox );
		else
			addressB = addressB.delete(addressB.indexOf("<POBox>"), addressB.indexOf("</POBox>")+"</POBox>".length());

		AddressXml =addressB.toString();
		return AddressXml;
	}

	public String personDetailsForCreateCustomer(String FirstName, String LastName, String Gender, String Nationality, String DateOfBirth)
	{
		String PersonalXml = "<PersonDetails><FirstName></FirstName><LastName></LastName><Gender></Gender><Nationality></Nationality><DateOfBirth></DateOfBirth></PersonDetails>";

		StringBuffer PersonalB = new StringBuffer(PersonalXml);
		
		if(!FirstName.equalsIgnoreCase("") && FirstName!=null && !FirstName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<FirstName>")+"<FirstName>".length(),FirstName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<FirstName>"), PersonalB.indexOf("</FirstName>")+"</FirstName>".length());

		if(!LastName.equalsIgnoreCase("") && LastName!=null && !LastName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<LastName>")+"<LastName>".length(),LastName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<LastName>"), PersonalB.indexOf("</LastName>")+"</LastName>".length());

		if(!Gender.equalsIgnoreCase("") && Gender!=null && !Gender.equals("") )
		{
			if (Gender.equalsIgnoreCase("Male"))
				PersonalB = PersonalB.insert(PersonalB.indexOf("<Gender>")+"<Gender>".length(),"M" );
			else
				PersonalB = PersonalB.insert(PersonalB.indexOf("<Gender>")+"<Gender>".length(),"F" );
		}else {
			PersonalB = PersonalB.delete(PersonalB.indexOf("<Gender>"), PersonalB.indexOf("</Gender>")+"</Gender>".length());
		}

		if(!Nationality.equalsIgnoreCase("") && Nationality!=null && !Nationality.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<Nationality>")+"<Nationality>".length(),Nationality );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<Nationality>"), PersonalB.indexOf("</Nationality>")+"</Nationality>".length());

		if(!DateOfBirth.equalsIgnoreCase("") && DateOfBirth!=null && !DateOfBirth.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<DateOfBirth>")+"<DateOfBirth>".length(),DateOfBirth );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<DateOfBirth>"), PersonalB.indexOf("</DateOfBirth>")+"</DateOfBirth>".length());

		PersonalXml =PersonalB.toString();
		return PersonalXml;
	}

	private String getRequestXML(String cabinetName, String sessionID,
			String wi_name, String ws_name, String userName, StringBuilder final_XML)
	{
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>"+XMLLOG_HISTORY_TABLE+"</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_XML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		CMPCBSLog.CMPCBSLogger.debug("GetRequestXML: "+ strBuff.toString());
		return strBuff.toString();
	}

	private String getResponseXML(String cabinetName,String sJtsIp,String iJtsPort, String
			sessionID, String wi_name,String message_ID, int integrationWaitTime)
	{

		String outputResponseXML="";
		try
		{
			String QueryString = "select OUTPUT_XML from "+XMLLOG_HISTORY_TABLE+" with (nolock) where " +
					"MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";

			String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
			CMPCBSLog.CMPCBSLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=CMPCBS.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				CMPCBSLog.CMPCBSLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    CMPCBSLog.CMPCBSLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    CMPCBSLog.CMPCBSLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		CMPCBSLog.CMPCBSLogger.debug("OutputResponseXML: "+outputResponseXML);

	        		if("".equalsIgnoreCase(outputResponseXML)){
	        			outputResponseXML="Error";
	    			}
	        		break;
				}
			    Loop_count++;
			    Thread.sleep(1000);
			}
			while(Loop_count<integrationWaitTime);

		}
		catch(Exception e)
		{
			CMPCBSLog.CMPCBSLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			CMPCBSLog.CMPCBSLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}
		return outputResponseXML;
	}

	public String formatDate(String inDate, String fromFormat, String ToFormat) {
		SimpleDateFormat inSDF = new SimpleDateFormat(fromFormat); //"mm/dd/yyyy"
		SimpleDateFormat outSDF = new SimpleDateFormat(ToFormat); //"yyyy-MM-dd"

		String outDate = "";
		if (inDate != null) {
			try {
				Date date = inSDF.parse(inDate);
				outDate = outSDF.format(date);
			} catch (ParseException e) {
				System.out.println("Unable to format date: " + inDate + e.getMessage());
				e.printStackTrace();
			}
		}
		return outDate;
  }

}
