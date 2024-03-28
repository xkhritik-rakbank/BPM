/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: DAC CBS
File Name				: DACCBSIntegration.java
Author 					: Sivakumar P
Date (DD/MM/YYYY)		: 26/11/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.DAC.CBS;

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

public class DACCBSIntegration {

	private String DAC_EXTTABLE = "RB_DAC_EXTTABLE";
	private String XMLLOG_HISTORY_TABLE = "NG_DAC_XMLLOG_HISTORY";
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

	public ResponseBean DACCBSCustomerCreationIntegration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId) throws Exception
	{
		strDocDownloadPath=docDownloadPath;
		ResponseBean objResponseBean=new ResponseBean();

		String QueryString="SELECT SOL_ID,"
				+ "PASSPORT_NUMBER,ACCOUNT_NUMBER,MOBILE_NUMBER,Mobile_Number_Country_Code,"
			 	+ "FIRST_NAME,MIDDLE_NAME,LAST_NAME,SCHEME_TYPE,SCHEME_CODE,EMAIL_ID,REQUEST_FOR_CIF,CARD_EMBOSSING_NAME,"
				+ "CORPORATE_CIF,REQUEST_BY_SIGNATORY_CIF,ITEMINDEX,IS_RETAIL_CUSTOMER,CREATE_CUSTOMER_STATUS,CUSTOMER_TYPE,CUSTOMER_SEGMENT,"
				+ "OPSCHECKERSUBMITTEDBY"
				+ " FROM "+DAC_EXTTABLE+" with (nolock) where WI_NAME='"+wi_name+"'";

		//objResponseBean.setAccountCreationReturnCode("Success");

		String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
		DACCBSLog.DACCBSLogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

		String sOutputXML=DACCBS.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
		DACCBSLog.DACCBSLogger.debug("Output XML for extranl Table select "+sOutputXML);

		XMLParser sXMLParser= new XMLParser(sOutputXML);
	    String sMainCode = sXMLParser.getValueOf("MainCode");
	    DACCBSLog.DACCBSLogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
	    DACCBSLog.DACCBSLogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			DACCBSLog.DACCBSLogger.debug("Inside If loop");
			CustomerBean objCustBean=new CustomerBean();
			String strSolId=sXMLParser.getValueOf("SOL_ID");
			//if(!("".equals(strSolId)))
			objCustBean.setSolId(strSolId);
			DACCBSLog.DACCBSLogger.debug("Sold Id is "+strSolId);
			
			String strFirstName=sXMLParser.getValueOf("FIRST_NAME");
			objCustBean.setFirstName(strFirstName);
			DACCBSLog.DACCBSLogger.debug("strFirstName "+strFirstName);

			String strMiddleName=sXMLParser.getValueOf("MIDDLE_NAME");
			objCustBean.setMiddleName(strMiddleName);
			DACCBSLog.DACCBSLogger.debug("strMiddleName "+strMiddleName);

			String strLastName=sXMLParser.getValueOf("LAST_NAME");
			objCustBean.setLastName(strLastName);
			DACCBSLog.DACCBSLogger.debug("strLastName "+strLastName);
			
			String strEmailId = sXMLParser.getValueOf("EMAIL_ID");
			objCustBean.setEmailID(strEmailId);
			DACCBSLog.DACCBSLogger.debug("strEmailId "+strEmailId);
			
			String strSchemeType = sXMLParser.getValueOf("SCHEME_TYPE");
			objCustBean.setSchemeType(strSchemeType);
			DACCBSLog.DACCBSLogger.debug("strSchemeType "+strSchemeType);
			
			String strSchemeCode = sXMLParser.getValueOf("SCHEME_CODE");
			objCustBean.setSchemeCode(strSchemeCode);
			DACCBSLog.DACCBSLogger.debug("strRequestForCIF "+strSchemeCode);
			
			String strPassportNumber=sXMLParser.getValueOf("PASSPORT_NUMBER");
			objCustBean.setPassportNumber(strPassportNumber);
			DACCBSLog.DACCBSLogger.debug("strPassportNumber "+strPassportNumber);
			
			String strAccountNumber = sXMLParser.getValueOf("ACCOUNT_NUMBER");
			objCustBean.setAccountNumber(strAccountNumber);
			DACCBSLog.DACCBSLogger.debug("strAccountNumber "+strAccountNumber);
			
			String strMobileNo = sXMLParser.getValueOf("MOBILE_NUMBER");
			objCustBean.setMobileNo(strMobileNo);
			DACCBSLog.DACCBSLogger.debug("strMobileNo "+strMobileNo);
			
			String strMobileCntryCode = sXMLParser.getValueOf("Mobile_Number_Country_Code");
			objCustBean.setMobileCntryCode(strMobileCntryCode);
			DACCBSLog.DACCBSLogger.debug("strMobileCntryCode "+strMobileCntryCode);
			
			String strCorporate_CIF = sXMLParser.getValueOf("CORPORATE_CIF");
			objCustBean.setCorporate_CIF(strCorporate_CIF);
			DACCBSLog.DACCBSLogger.debug("strCorporate_CIF "+strCorporate_CIF);
			
			String strCustomer_ID = sXMLParser.getValueOf("REQUEST_BY_SIGNATORY_CIF");
			objCustBean.setRequestBySignatoryCIF(strCustomer_ID);
			DACCBSLog.DACCBSLogger.debug("strCustomer_ID "+strCustomer_ID);
			
			String strIsRetail = sXMLParser.getValueOf("IS_RETAIL_CUSTOMER");
			if (strIsRetail.trim().equalsIgnoreCase("Yes"))
				objCustBean.setIsRetail("Y");
			else
				objCustBean.setIsRetail("N");
			DACCBSLog.DACCBSLogger.debug("strIsRetail "+strIsRetail);
			
			
			String CARD_EMBOSSING_NAME = sXMLParser.getValueOf("CARD_EMBOSSING_NAME");
			objCustBean.setCardEmbName(CARD_EMBOSSING_NAME);
			DACCBSLog.DACCBSLogger.debug("CARD_EMBOSSING_NAME "+CARD_EMBOSSING_NAME);
			
			String strRequestForCIF = sXMLParser.getValueOf("REQUEST_FOR_CIF");
			objCustBean.setRequestForCIF(strRequestForCIF);
			DACCBSLog.DACCBSLogger.debug("strRequestForCIF "+strRequestForCIF);
			
			String strCUSTOMER_TYPE = sXMLParser.getValueOf("CUSTOMER_TYPE");
			objCustBean.setCustomerType(strCUSTOMER_TYPE);
			DACCBSLog.DACCBSLogger.debug("strCUSTOMER_TYPE "+strCUSTOMER_TYPE);
			
			String strCUSTOMER_SEGMENT = sXMLParser.getValueOf("CUSTOMER_SEGMENT");
			objCustBean.setCustomerSegment(strCUSTOMER_SEGMENT);
			DACCBSLog.DACCBSLogger.debug("strCUSTOMER_SEGMENT "+strCUSTOMER_SEGMENT);
			
			String strOPSCHECKERSUBMITTEDBY = sXMLParser.getValueOf("OPSCHECKERSUBMITTEDBY");
			objCustBean.setOpsCheckerSubmittedBy(strOPSCHECKERSUBMITTEDBY);
			DACCBSLog.DACCBSLogger.debug("strOPSCHECKERSUBMITTEDBY "+strOPSCHECKERSUBMITTEDBY);
			
			objCustBean.setWiName(wi_name);
			

			//String strPassportExpDate=sXMLParser.getValueOf("PASSPORT_EXPIRY_DATE");
			//objCustBean.setPassportExpDate(strPassportExpDate);

			
           	//String strEmiratesId=sXMLParser.getValueOf("EMIRATES_ID");
			//objCustBean.setEmiratesId(strEmiratesId);

			//String strEmIdExpDate=sXMLParser.getValueOf("EMIRATES_ID_EXPIRY_DATE");
			//objCustBean.setEmIdExpDate(strEmIdExpDate);
		
			String strCREATECustomerSTATUS=sXMLParser.getValueOf("CREATE_CUSTOMER_STATUS");
			DACCBSLog.DACCBSLogger.debug("strCREATECustomerSTATUS "+strCREATECustomerSTATUS);
			
			// Start - Debit Card Request Call 
			if(!"Success".equalsIgnoreCase(strCREATECustomerSTATUS))
			{
				String DocDetails = "";
				if (!strPassportNumber.equalsIgnoreCase("") && !strPassportNumber.equalsIgnoreCase("null"))
				{
					DocDetails = DocDetails + "<Document>\n" +
						"<DocType>Passport</DocType>\n" +
						"<DocRefNum>"+strPassportNumber+"</DocRefNum>\n" +
					"</Document>\n";
				}
				String DacActID="";
				DACCBSLog.DACCBSLogger.debug("objCustBean.getWiName() "+objCustBean.getWiName());
				DACCBSLog.DACCBSLogger.debug("objCustBean.getCorporate_CIF() "+objCustBean.getCorporate_CIF());
				String d[]= objCustBean.getWiName().split("-");
				if(!objCustBean.getCorporate_CIF().equalsIgnoreCase("")  && !objCustBean.getCorporate_CIF().equalsIgnoreCase("null"))
				{								       
			        /*for(int i=0;i<d.length;i++)
			        {
			             System.out.println("i :"+i+" d :"+d[i]);
			        }*/
			        String b=d[1].substring(d[1].length()-6,d[1].length());
			        DACCBSLog.DACCBSLogger.debug("b :"+b);
			        
					DacActID=b+objCustBean.getCorporate_CIF();
					DACCBSLog.DACCBSLogger.debug("DacActID :"+DacActID);
				}
				
				java.util.Date d1 = new Date();
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
				String ProcessingDate = sdf1.format(d1)+"+04:00";
				
				sInputXML = "<EE_EAI_MESSAGE>\n" +
								"<EE_EAI_HEADER>\n" +
									"<MsgFormat>NEW_DEBITCARD_REQ</MsgFormat>\n" +
									"<MsgVersion>001</MsgVersion>\n"+
									"<RequestorChannelId>BPM</RequestorChannelId>\n" +
									"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
									"<RequestorLanguage>E</RequestorLanguage>\n" +
									"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
									"<ReturnCode>0000</ReturnCode>\n" +
									"<ReturnDesc>REQ</ReturnDesc>\n" +
									"<MessageId>testmsg1002</MessageId>\n" +
									"<Extra1>REQ||SHELL.JOHN</Extra1>\n" +
									"<Extra2>"+ProcessingDate+"</Extra2>\n" +
								"</EE_EAI_HEADER>\n"+									
								"<DebitCardRequest>\n" +
									"<CustomerId>"+objCustBean.getRequestBySignatoryCIF()+"</CustomerId>\n" +
									"<Acid>"+objCustBean.getAccountNumber()+"</Acid>\n" +
									"<SchemeType>"+objCustBean.getSchemeType()+"</SchemeType>\n" +
									"<SchemeCode>"+objCustBean.getSchemeCode()+"</SchemeCode>\n" +
									"<IsRetailCust>"+objCustBean.getsetIsRetail()+"</IsRetailCust>\n" +
									DocDetails +
									"<FirstName>"+objCustBean.getFirstName()+"</FirstName>\n" +
									"<MidName>"+objCustBean.getMiddleName()+"</MidName>\n" +
									"<LastName>"+objCustBean.getLastName()+"</LastName>\n" +
									"<EmbossingName>"+objCustBean.getCardEmbName()+"</EmbossingName>\n" +
									"<DeliveryMode>C</DeliveryMode>\n" +
									"<VIPFlg>N</VIPFlg>\n" +
									"<ProcessingUserId>"+objCustBean.getOpsCheckerSubmittedBy()+"</ProcessingUserId>\n" +
									"<ProcessingDate>"+ProcessingDate+"</ProcessingDate>\n" +
									"<CardType>DAC</CardType>\n" +
									"<DacActID>"+DacActID+"</DacActID>\n" +
									"<CustIDOnBehalfOf>"+objCustBean.getRequestForCIF()+"</CustIDOnBehalfOf>\n" +
									"<CustomerType>"+objCustBean.getCustomerType()+"</CustomerType>\n"+
									"<CustomerSegment>"+objCustBean.getCustomerSegment()+"</CustomerSegment>\n"+
								"</DebitCardRequest>\n" + 
							"</EE_EAI_MESSAGE>";

				DACCBSLog.DACCBSLogger.debug("Input XML for Customer creation is "+sInputXML);

				try
				{
					DACCBSLog.DACCBSLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					DACCBSLog.DACCBSLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					DACCBSLog.DACCBSLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						DACCBSLog.DACCBSLogger.debug("Data output stream is "+dout);
						DACCBSLog.DACCBSLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

						DACCBSLog.DACCBSLogger.debug("Input MQ XML for Customer creation is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							DACCBSLog.DACCBSLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							DACCBSLog.DACCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
							DACCBSLog.DACCBSLogger.debug("OutputResponse: "+outputResponse);

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
						
						String return_code = sXMLParser.getValueOf("ReturnCode");
						String return_desc = sXMLParser.getValueOf("ReturnDesc");
						if (return_desc.trim().equalsIgnoreCase(""))
							return_desc = sXMLParser.getValueOf("Description");
						
						if("0000".equalsIgnoreCase(return_code))
						{
							objResponseBean.setCustomerCreationReturnCode("Success");
							objResponseBean.setIntegrationDecision("Success");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
							objResponseBean.setDACRequestId(sXMLParser.getValueOf("RequestId"));
						}
						else
						{
							objResponseBean.setCustomerCreationReturnCode("Failure");
							objResponseBean.setIntegrationDecision("Failure");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
						}
						DACCBSLog.DACCBSLogger.debug("Response XML for Customer creation is "+outputResponse);
					}
				}
				catch(Exception e)
				{
					DACCBSLog.DACCBSLogger.error("The Exception in Customer creation is "+e.getMessage());
				}
			} 
			else
			{
				DACCBSLog.DACCBSLogger.error("Customer is already created or Existing Customer: ");
				objResponseBean.setCustomerCreationReturnCode("Success");
				
			}
			// End - Customer Creation Call
			
		}
		return objResponseBean;
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
		DACCBSLog.DACCBSLogger.debug("GetRequestXML: "+ strBuff.toString());
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
			DACCBSLog.DACCBSLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=DACCBS.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				DACCBSLog.DACCBSLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    DACCBSLog.DACCBSLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    DACCBSLog.DACCBSLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		DACCBSLog.DACCBSLogger.debug("OutputResponseXML: "+outputResponseXML);

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
			DACCBSLog.DACCBSLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			DACCBSLog.DACCBSLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
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
