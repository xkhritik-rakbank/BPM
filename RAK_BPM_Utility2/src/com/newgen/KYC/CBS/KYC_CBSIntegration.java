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


package com.newgen.KYC.CBS;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

//import com.newgen.NBTL.Memopad.CustomerBean;
//import com.newgen.NBTL.Memopad.NBTL_Memopad;
//import com.newgen.NBTL.Memopad.NBTL_MemopadIntegration;
//import com.newgen.NBTL.Memopad.NBTL_Memopad_Log;
import com.newgen.KYC.CBS.KYC_CBS;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class KYC_CBSIntegration {

	
	private String XMLLOG_HISTORY_TABLE = "NG_KYC_Remedation_XMLLOG_HISTORY";
	private String NBTL_EXTTABLE = "RB_KYC_REM_EXTTABLE";
	
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
	
	public ResponseBean KYC_CBS_CifUpdateIntegration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,String strCorporateCIF,HashMap<String, String> socketDetailsMap,
			String strWi_name,String activityName) throws Exception
	{
		String append = "";
		String CorpFlag = "";
		String officeAddress = "";
		String OfficeCityEmirate = "";
		String OfficeCountry = "";
		String ResidenceAddress = "";
		String ResidenceCountry = "";
		String ResidenceEmirateCity = "";
		String Mobile = "";
		String EMailID = "";
		String EmiratedIDcardNumber = "";
		String EmiratesIDexpiryDate = "";
		String PassportNumber = "";
		String PassportIssueDate = "";
		String PassportExpiryDate = "";
		String EffectiveFrom = "";
		
		String query = "Select CaseType,OfficeAddressLine1,OfficeCityEmirate,OfficeCountry,"
				+ "ResidenceAddress,ResidenceCountry,ResidenceEmirateCity,Mobile,EMailID,"
				+ "EmiratedIDcardNumber,EmiratesIDexpiryDate,PassportNumber,PassportIssueDate,PassportExpiryDate"
				+ " FROM RB_KYC_REM_EXTTABLE Where WINAME = '"+wi_name+"'";
		
		String sInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
		KYC_CBSLog.KYC_CBSLogger.debug("Input XML for Apselect from External Table "+sInputXML);

		String sOutputXML=KYC_CBS.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
		KYC_CBSLog.KYC_CBSLogger.debug("Output XML for external Table select "+sOutputXML);

		XMLParser XMLParser= new XMLParser(sOutputXML);
	    String sMainCode = XMLParser.getValueOf("MainCode");
	    KYC_CBSLog.KYC_CBSLogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(XMLParser.getValueOf("TotalRetrieved"));
	    KYC_CBSLog.KYC_CBSLogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			CorpFlag=XMLParser.getValueOf("CaseType");
			if("Individual".equalsIgnoreCase(CorpFlag)){
				 CorpFlag = "R";
				 
				 officeAddress=XMLParser.getValueOf("OfficeAddressLine1");
				 KYC_CBSLog.KYC_CBSLogger.debug("officeAddress: "+officeAddress);
				 
				 OfficeCityEmirate=XMLParser.getValueOf("OfficeCityEmirate");
				 KYC_CBSLog.KYC_CBSLogger.debug("OfficeCityEmirate: "+OfficeCityEmirate);
				 
				 OfficeCountry=XMLParser.getValueOf("OfficeCountry");
				 KYC_CBSLog.KYC_CBSLogger.debug("OfficeCountry: "+OfficeCountry);
				 
				 ResidenceAddress=XMLParser.getValueOf("ResidenceAddress");
				 KYC_CBSLog.KYC_CBSLogger.debug("ResidenceAddress: "+ResidenceAddress);
				 
				 ResidenceEmirateCity=XMLParser.getValueOf("ResidenceEmirateCity");
				 KYC_CBSLog.KYC_CBSLogger.debug("ResidenceEmirateCity: "+ResidenceEmirateCity);
				 
				 ResidenceCountry=XMLParser.getValueOf("ResidenceCountry");
				 KYC_CBSLog.KYC_CBSLogger.debug("ResidencyCountry: "+ResidenceCountry);
				 
				 Mobile=XMLParser.getValueOf("Mobile");
				 KYC_CBSLog.KYC_CBSLogger.debug("Mobile: "+Mobile);
				 
				 EMailID=XMLParser.getValueOf("EMailID");
				 KYC_CBSLog.KYC_CBSLogger.debug("EMailID: "+EMailID);
				 
				 EmiratedIDcardNumber=XMLParser.getValueOf("EmiratedIDcardNumber");
				 KYC_CBSLog.KYC_CBSLogger.debug("EmiratedIDcardNumber: "+EmiratedIDcardNumber);
				 
				 EmiratesIDexpiryDate=XMLParser.getValueOf("EmiratesIDexpiryDate");
				 KYC_CBSLog.KYC_CBSLogger.debug("EmiratesIDexpiryDate: "+EmiratesIDexpiryDate);
				 
				 SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				 SimpleDateFormat outputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
				 try{
					 Date inputDate = inputDateFormat.parse(EmiratesIDexpiryDate);
					 EmiratesIDexpiryDate = outputDateFormat.format(inputDate);
				 }catch(Exception e)
				 {
					 KYC_CBSLog.KYC_CBSLogger.debug("Exception in converting date format");
				 }
				 
				 PassportNumber=XMLParser.getValueOf("PassportNumber");
				 KYC_CBSLog.KYC_CBSLogger.debug("PassportNumber: "+PassportNumber);
				 
				 PassportIssueDate = XMLParser.getValueOf("PassportIssueDate");
				 KYC_CBSLog.KYC_CBSLogger.debug("PassportIssueDate: "+PassportIssueDate);

				 try{
					 Date inputDate = inputDateFormat.parse(PassportIssueDate);
					 PassportIssueDate = outputDateFormat.format(inputDate);
				 }catch(Exception e)
				 {
					 KYC_CBSLog.KYC_CBSLogger.debug("Exception in converting date format");
				 }
				 
				 PassportExpiryDate=XMLParser.getValueOf("PassportExpiryDate");
				 KYC_CBSLog.KYC_CBSLogger.debug("PassportExpiryDate: "+PassportExpiryDate);

				 try{
					 Date inputDate = inputDateFormat.parse(PassportExpiryDate);
					 PassportExpiryDate = outputDateFormat.format(inputDate);
				 }catch(Exception e)
				 {
					 KYC_CBSLog.KYC_CBSLogger.debug("Exception in converting date format");
				 }
				 
				 append +=/*"\n\t\t<AddrDet>" +
						 "\n\t\t\t<AddressType>RESIDENCE</AddressType>"+
						 "\n\t\t<EffectiveFrom>"+EffectiveFrom+"</EffectiveFrom>"+
						 "\n\t\t<EffectiveTo>2099-12-31</EffectiveTo>"+
						 "\n\t\t<HoldMailFlag>N</HoldMailFlag>"+
						 "\n\t\t<ReturnFlag>N</ReturnFlag>"+
						 "\n\t\t<AddrPrefFlag>Y</AddrPrefFlag>"+
						 "\n\t\t<AddrLine1>"+ResidenceAddress+"</AddrLine1>"+
						 "\n\t\t<City>"+ResidenceEmirateCity+"</City>"+
						 "\n\t\t<CountryCode>"+ResidenceCountry+"</CountryCode>"+
						 "\n\t\t</AddrDet>"+
						 "\n\t\t<AddrDet>" +
						 "\n\t\t\t<AddressType>OFFICE</AddressType>"+
						 "\n\t\t<EffectiveFrom>"+EffectiveFrom+"</EffectiveFrom>"+
						 "\n\t\t<EffectiveTo>2099-12-31</EffectiveTo>"+
						 "\n\t\t<HoldMailFlag>N</HoldMailFlag>"+
						 "\n\t\t<ReturnFlag>N</ReturnFlag>"+
						 "\n\t\t<AddrPrefFlag>N</AddrPrefFlag>"+
						 "\n\t\t<AddrLine1>"+officeAddress+"</AddrLine1>"+
						 "\n\t\t<City>"+OfficeCityEmirate+"</City>"+
						 "\n\t\t<CountryCode>"+OfficeCountry+"</CountryCode>"+
						 "\n\t\t</AddrDet>"+
						 "\n\t\t<PhnDetails>"+
						 "\n\t\t<PhnType>OFFCPH1</PhnType>"+
						 "\n\t\t<PhnPrefFlag>N</PhnPrefFlag>"+
						 "\n\t\t<PhnLocalCode>"+Mobile+"</PhnLocalCode>"+
						 "\n\t\t</PhnDetails>"+
						 "\n\t\t<EmlDet>"+
						 "\n\t\t<EmlType>ELML1</EmlType>"+
						 "\n\t\t<EmlPrefFlag>N</EmlPrefFlag>"+
						 "\n\t\t<Email>"+EMailID+"</Email>"+
						 "\n\t\t</EmlDet>"+*/
						 "\n\t\t<DocDet>"+
						 "\n\t\t<DocType>EMID</DocType>"+
						 "\n\t\t<DocIsVerified>Y</DocIsVerified>"+
						 "\n\t\t<DocNo>"+EmiratedIDcardNumber+"</DocNo>"+
						 "\n\t\t<DocExpDate>"+EmiratesIDexpiryDate+"</DocExpDate>"+
						 "\n\t\t</DocDet>"+
						 "\n\t\t<DocDet>"+
						 "\n\t\t<DocType>PPT</DocType>"+
						 "\n\t\t<DocIsVerified>Y</DocIsVerified>"+
						 "\n\t\t<DocNo>"+PassportNumber+"</DocNo>"+
						 "\n\t\t<DocIssDate>"+PassportIssueDate+"</DocIssDate>"+
						 "\n\t\t<DocExpDate>"+PassportExpiryDate+"</DocExpDate>"+
						 "\n\t\t</DocDet>";	 
				}
				else if("Corporate".equalsIgnoreCase(CorpFlag)){
				CorpFlag = "C";
				String TLNumber = "";
				String TLIssueDate = "";
				String TLExpiryDate = "";
				
				String query1 = "Select EntityTLNumber,TradeLicenseDate,TradeLicenseExpiryDate "
						+ "FROM RB_KYC_REM_EXTTABLE Where WINAME = '"+wi_name+"'";
				
				String InputXML =CommonMethods.apSelectWithColumnNames(query1, cabinetName, sessionID);
				KYC_CBSLog.KYC_CBSLogger.debug("Input XML for Apselect from External Table "+InputXML);

				String OutputXML=KYC_CBS.WFNGExecute(InputXML, sJtsIp, sJtsPort,1);
				KYC_CBSLog.KYC_CBSLogger.debug("Output XML for external Table select "+OutputXML);

				XMLParser XMLParsr= new XMLParser(OutputXML);
			    String MainCode = XMLParsr.getValueOf("MainCode");
			    KYC_CBSLog.KYC_CBSLogger.debug("MainCode: "+MainCode);

			    int TotalRecords = Integer.parseInt(XMLParsr.getValueOf("TotalRetrieved"));
			    KYC_CBSLog.KYC_CBSLogger.debug("STotalRecords: "+TotalRecords);
			    
			    if (sMainCode.equals("0") && sTotalRecords > 0)
				{
			    	TLNumber=XMLParsr.getValueOf("EntityTLNumber");
					 KYC_CBSLog.KYC_CBSLogger.debug("TLNumber: "+TLNumber);
					 
					 
					 TLIssueDate=XMLParsr.getValueOf("TradeLicenseDate");
					 KYC_CBSLog.KYC_CBSLogger.debug("TLIssueDate: "+TLIssueDate);
					 
					 TLIssueDate = formatDate(TLIssueDate);
					 
					 TLExpiryDate=XMLParsr.getValueOf("TradeLicenseExpiryDate");
					 KYC_CBSLog.KYC_CBSLogger.debug("TLExpiryDate: "+TLExpiryDate);
					 
					 TLExpiryDate = formatDate(TLExpiryDate);
					 
					 append += "\n\t\t<DocDet>"+
							 "\n\t\t<DocType>TDLIC</DocType>"+
							 "\n\t\t<DocIsVerified>Y</DocIsVerified>"+
							 "\n\t\t<DocNo>"+TLNumber+"</DocNo>"+
							 "\n\t\t<DocIssDate>"+TLIssueDate+"</DocIssDate>"+
							 "\n\t\t<DocExpDate>"+TLExpiryDate+"</DocExpDate>"+
							 "\n\t\t</DocDet>";
				}	
			}
			
			else if("RelatedParty".equalsIgnoreCase(CorpFlag)){
					CorpFlag = "R";
					
					String OwnerPassportNo = "";
					String OwnerPassportIssueDate = "";
					String OwnerPassportExpiryDate = "";
					String OwnerEmiratesID = "";
					String OwnerEmiratesIDExpiryDate = "";
					
					String query2 = "Select " 
							+ "OwnerPassportNo,OwnerPassportIssueDate,OwnerPassportExpiryDate,OwnerEmiratesID,OwnerEmiratesIDExpiryDate"
							+ " FROM RB_KYC_REM_EXTTABLE Where WINAME = '"+wi_name+"'";
					
					String InputXML =CommonMethods.apSelectWithColumnNames(query2, cabinetName, sessionID);
					KYC_CBSLog.KYC_CBSLogger.debug("Input XML for Apselect from External Table "+InputXML);

					String OutputXML=KYC_CBS.WFNGExecute(InputXML, sJtsIp, sJtsPort,1);
					KYC_CBSLog.KYC_CBSLogger.debug("Output XML for external Table select "+OutputXML);

					XMLParser XMLParsr= new XMLParser(OutputXML);
				    String MainCode = XMLParsr.getValueOf("MainCode");
				    KYC_CBSLog.KYC_CBSLogger.debug("MainCode: "+MainCode);

				    int TotalRecords = Integer.parseInt(XMLParsr.getValueOf("TotalRetrieved"));
				    KYC_CBSLog.KYC_CBSLogger.debug("STotalRecords: "+TotalRecords);
				    
				    if (sMainCode.equals("0") && sTotalRecords > 0)
					{
				    	OwnerEmiratesID=XMLParsr.getValueOf("OwnerEmiratesID");
						 KYC_CBSLog.KYC_CBSLogger.debug("OwnerEmiratesID: "+OwnerEmiratesID);
						 
						 OwnerEmiratesIDExpiryDate=XMLParsr.getValueOf("OwnerEmiratesIDExpiryDate");
						 KYC_CBSLog.KYC_CBSLogger.debug("OwnerEmiratesIDExpiryDate: "+OwnerEmiratesIDExpiryDate);
				    	
						 OwnerEmiratesIDExpiryDate = formatDate(OwnerEmiratesIDExpiryDate);
						 
				    	OwnerPassportNo=XMLParsr.getValueOf("OwnerPassportNo");
						 KYC_CBSLog.KYC_CBSLogger.debug("OwnerPassportNo: "+OwnerPassportNo);
						 
						 OwnerPassportIssueDate=XMLParsr.getValueOf("OwnerPassportIssueDate");
						 KYC_CBSLog.KYC_CBSLogger.debug("OwnerPassportIssueDate: "+OwnerPassportIssueDate);
						 
						 OwnerPassportIssueDate = formatDate(OwnerPassportIssueDate);
						 
						 OwnerPassportExpiryDate=XMLParsr.getValueOf("OwnerPassportExpiryDate");
						 KYC_CBSLog.KYC_CBSLogger.debug("OwnerPassportExpiryDate: "+OwnerPassportExpiryDate);
						 
						 OwnerPassportExpiryDate = formatDate(OwnerPassportExpiryDate);
				    	
						 append += "\n\t\t<DocDet>"+
								 "\n\t\t<DocType>EMID</DocType>"+
								 "\n\t\t<DocIsVerified>Y</DocIsVerified>"+
								 "\n\t\t<DocNo>"+OwnerEmiratesID+"</DocNo>"+
								 "\n\t\t<DocExpDate>"+OwnerEmiratesIDExpiryDate+"</DocExpDate>"+
								 "\n\t\t</DocDet>"+
								 "\n\t\t<DocDet>"+
								 "\n\t\t<DocType>PPT</DocType>"+
								 "\n\t\t<DocIsVerified>Y</DocIsVerified>"+
								 "\n\t\t<DocNo>"+OwnerPassportNo+"</DocNo>"+
								 "\n\t\t<DocIssDate>"+OwnerPassportIssueDate+"</DocIssDate>"+
								 "\n\t\t<DocExpDate>"+OwnerPassportExpiryDate+"</DocExpDate>"+
								 "\n\t\t</DocDet>";	
					}
				}
		}

				Date todayDate = new Date();
				SimpleDateFormat outputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
				EffectiveFrom = outputDateFormat.format(todayDate);
		
				ResponseBean objResponseBean=new ResponseBean();
				String CIFUpdateinputXML = "<EE_EAI_MESSAGE>" +
								"\n\t<EE_EAI_HEADER>"+
								"\n\t\t<MsgFormat>CUSTOMER_UPDATE_REQ</MsgFormat>"+
								"\n\t\t<MsgVersion>001</MsgVersion>"+
								"\n\t\t<RequestorChannelId>BPM</RequestorChannelId>"+
								"\n\t\t<RequestorUserId>RAKUSER</RequestorUserId>" +
								"\n\t\t<RequestorLanguage>E</RequestorLanguage>" +
								"\n\t\t<RequestorSecurityInfo>secure</RequestorSecurityInfo>" +
								"\n\t\t<ReturnCode>911</ReturnCode>" +
								"\n\t\t<ReturnDesc>Issuer Timed Out</ReturnDesc>" +
								"\n\t\t<MessageId>Test_CU_0031</MessageId>" +
								"\n\t\t<Extra1>REQ||SHELL.dfgJOHN</Extra1>" +
								"\n\t\t<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2>" +
								"\n\t</EE_EAI_HEADER>" +
								"\n\t<CustomerDetailsUpdateReq>" +
								"\n\t\t<BankId>RAK</BankId>" + 
								"\n\t\t<CIFId>"+strCorporateCIF+"</CIFId>" +
								"\n\t\t<RetCorpFlag>"+CorpFlag+"</RetCorpFlag>" + 
								"\n\t\t<ActionRequired>U</ActionRequired>";
						 
					append +="\n\t</CustomerDetailsUpdateReq>" +
							"\n</EE_EAI_MESSAGE>";
				
				CIFUpdateinputXML += append;
				KYC_CBSLog.KYC_CBSLogger.debug("Input XML for KYC CIF Update is "+CIFUpdateinputXML);

				try
				{
					KYC_CBSLog.KYC_CBSLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					KYC_CBSLog.KYC_CBSLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					KYC_CBSLog.KYC_CBSLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						KYC_CBSLog.KYC_CBSLogger.debug("Data output stream is "+dout);
						KYC_CBSLog.KYC_CBSLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, activityName, CommonConnection.getUsername(), new StringBuilder(CIFUpdateinputXML));

						KYC_CBSLog.KYC_CBSLogger.debug("Input MQ XML for Customer creation is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							KYC_CBSLog.KYC_CBSLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							KYC_CBSLog.KYC_CBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
							KYC_CBSLog.KYC_CBSLogger.debug("OutputResponse: "+outputResponse);

							if(!"".equalsIgnoreCase(outputResponse))
								outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
										wi_name,outputResponse,integrationWaitTime );
							if(outputResponse.contains("&lt;"))
							{
								outputResponse=outputResponse.replaceAll("&lt;", "<");
								outputResponse=outputResponse.replaceAll("&gt;", ">");
							}
							KYC_CBSLog.KYC_CBSLogger.debug("OutputResponse: "+outputResponse);
						}
						socket.close();

						outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");
						XMLParser sXMLParser= new XMLParser(outputResponse);
						
						String return_code = sXMLParser.getValueOf("ReturnCode");
						String return_desc = sXMLParser.getValueOf("ReturnDesc");
						if (return_desc.trim().equalsIgnoreCase(""))
						{
							return_desc = sXMLParser.getValueOf("Description");
						}
						KYC_CBSLog.KYC_CBSLogger.debug("return_code: "+return_code);
						
						if("0000".equalsIgnoreCase(return_code))
						{
							objResponseBean.setCifUpdateReturnCode("Success");
							objResponseBean.setIntegrationDecision("Success");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
							objResponseBean.setNBTLRequestId(sXMLParser.getValueOf("RequestId"));
						}
						else
						{
							objResponseBean.setCifUpdateReturnCode("Failure");
							objResponseBean.setIntegrationDecision("Failure");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
						}
						KYC_CBSLog.KYC_CBSLogger.debug("Response XML for Cif Update is "+outputResponse);
					}
				}
				catch(Exception e)
				{
					KYC_CBSLog.KYC_CBSLogger.error("The Exception in Cif Update is "+e.getMessage());
					System.out.println("The Exception in Cif Update is "+e.getMessage());
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
		KYC_CBSLog.KYC_CBSLogger.debug("GetRequestXML: "+ strBuff.toString());
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
			KYC_CBSLog.KYC_CBSLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=KYC_CBS.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				KYC_CBSLog.KYC_CBSLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    KYC_CBSLog.KYC_CBSLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    KYC_CBSLog.KYC_CBSLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		KYC_CBSLog.KYC_CBSLogger.debug("OutputResponseXML: "+outputResponseXML);

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
			KYC_CBSLog.KYC_CBSLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			KYC_CBSLog.KYC_CBSLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}
		return outputResponseXML;
	}

	public String formatDate(String inDate) {
		 SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		 SimpleDateFormat outputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		 try{
			 Date inputDate = inputDateFormat.parse(inDate);
			 inDate = outputDateFormat.format(inputDate);
		 }catch(Exception e)
		 {
			 KYC_CBSLog.KYC_CBSLogger.debug("Exception in converting date format");
		 }
		return inDate;
  }
	
}
