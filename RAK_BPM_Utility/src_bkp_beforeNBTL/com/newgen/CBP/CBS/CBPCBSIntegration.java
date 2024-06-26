/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: CBP CBS
File Name				: CMPCBSIntegration.java
Author 					: Sajan Soda
Date (DD/MM/YYYY)		: 11/09/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/

package com.newgen.CBP.CBS;

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

public class CBPCBSIntegration {

	private String CBP_EXTTABLE = "RB_CBP_EXTTABLE";
	private String XMLLOG_HISTORY_TABLE = "NG_CBP_XMLLOG_HISTORY";
	private String ws_name = "Core_System_Update";

	Socket socket = null;
	String socketServerIP = "";
	int socketServerPort = 0;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String outputResponse = null;
	String inputRequest = null;
	String inputMessageID = null;
	String CustomerID = "";
	String strDocDownloadPath = "";

	public String CBPCBSCustomerUpdateIntegration(String cabinetName, String sessionID, String sJtsIp,
			String sJtsPort, String smsPort, String wi_name, int socket_connection_timeout, int integrationWaitTime,
			HashMap<String, String> socketDetailsMap, String docDownloadPath, String volumeId, String siteId)
			throws Exception {
		strDocDownloadPath = docDownloadPath;

		String QueryString = "SELECT CIF_ID,PASSPORT_NUMBER,SUBSTRING(PASS_ISSUE_DATE,0,11) as PASS_ISSUE_DATE,SUBSTRING(PASS_EXPIRY_DATE,0,11) as PASS_EXPIRY_DATE,VISA_NUMBER,SUBSTRING(VISA_ISSUE_DATE,0,11) as VISA_ISSUE_DATE,SUBSTRING(VISA_EXPIRY_DATE,0,11) as VISA_EXPIRY_DATE,EMIRATES_ID,SUBSTRING(EMIRATES_EXPIRY_DATE,0,11) as EMIRATES_EXPIRY_DATE FROM "
				+ "RB_CBP_EXTTABLE with (nolock) where WI_NAME='" + wi_name + "'";

		// objResponseBean.setAccountCreationReturnCode("Success");

		String sInputXML = CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
		CBPCBSLog.CBPCBSLogger.debug("Input XML for Apselect from Extrenal Table " + sInputXML);

		String sOutputXML = CBPCBS.WFNGExecute(sInputXML, sJtsIp, sJtsPort, 1);
		CBPCBSLog.CBPCBSLogger.debug("Output XML for extranl Table select " + sOutputXML);

		XMLParser sXMLParser = new XMLParser(sOutputXML);
		String sMainCode = sXMLParser.getValueOf("MainCode");
		CBPCBSLog.CBPCBSLogger.debug("SMainCode: " + sMainCode);

		int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
		CBPCBSLog.CBPCBSLogger.debug("STotalRecords: " + sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0) {
			CBPCBSLog.CBPCBSLogger.debug("Inside If loop");
			CustomerBean objCustBean = new CustomerBean();
			
			CBPCBSLog.CBPCBSLogger.debug("The WI name is "+wi_name);
			objCustBean.setWiName(wi_name);

			objCustBean.setCifNumber(sXMLParser.getValueOf("CIF_ID"));
			CBPCBSLog.CBPCBSLogger.debug("The CIF_ID is "+sXMLParser.getValueOf("CIF_ID"));	
			
			objCustBean.setPassportNumber(sXMLParser.getValueOf("PASSPORT_NUMBER"));
			CBPCBSLog.CBPCBSLogger.debug("The passport number is "+sXMLParser.getValueOf("PASSPORT_NUMBER"));
			
			objCustBean.setPassportIssueDate(sXMLParser.getValueOf("PASS_ISSUE_DATE"));
			CBPCBSLog.CBPCBSLogger.debug("The passport issue date is is "+sXMLParser.getValueOf("PASS_ISSUE_DATE"));
			
			objCustBean.setPassportExpiryDate(sXMLParser.getValueOf("PASS_EXPIRY_DATE"));
			CBPCBSLog.CBPCBSLogger.debug("The passport Expiry date is is "+sXMLParser.getValueOf("PASS_EXPIRY_DATE"));
			
			objCustBean.setVisaNumber(sXMLParser.getValueOf("VISA_NUMBER"));
			
			objCustBean.setVisaIssueDate(sXMLParser.getValueOf("VISA_ISSUE_DATE"));
			
			objCustBean.setVisaExpiryDate(sXMLParser.getValueOf("VISA_EXPIRY_DATE"));

			objCustBean.setEmidNumber(sXMLParser.getValueOf("EMIRATES_ID"));
			
			objCustBean.setEmidExpiryDate(sXMLParser.getValueOf("EMIRATES_EXPIRY_DATE"));
			
			// Start - Customer Update Call
			
			sInputXML =getInputXMLCIFUpdate(objCustBean, objCustBean.getCifNumber(), CommonConnection.getUsername(),sessionID, cabinetName,sJtsIp, sJtsPort);

			CBPCBSLog.CBPCBSLogger.debug("Input XML for Customer creation is " + sInputXML);

			try {
				CBPCBSLog.CBPCBSLogger.debug("Session Id is " + sessionID);

				socketServerIP = socketDetailsMap.get("SocketServerIP");
				CBPCBSLog.CBPCBSLogger.debug("Socket server IP is " + socketServerIP);

				socketServerPort = Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
				CBPCBSLog.CBPCBSLogger.debug("Socket server port is " + socketServerPort);
				CBPCBSLog.CBPCBSLogger.debug("connection_timeout Value:"+ socket_connection_timeout);

				if (!("".equals(socketServerIP)) && socketServerIP != null && !(socketServerPort == 0)) {
					socket = new Socket(socketServerIP, socketServerPort);
					socket.setSoTimeout(socket_connection_timeout * 1000);
					out = socket.getOutputStream();
					socketInputStream = socket.getInputStream();
					dout = new DataOutputStream(out);
					din = new DataInputStream(socketInputStream);

					CBPCBSLog.CBPCBSLogger.debug("Data output stream is " + dout);
					CBPCBSLog.CBPCBSLogger.debug("Data input stream is " + din.toString());
					outputResponse = "";
					inputRequest = getRequestXML(cabinetName, sessionID, wi_name, ws_name,
							CommonConnection.getUsername(), new StringBuilder(sInputXML));

					CBPCBSLog.CBPCBSLogger.debug("Input MQ XML for Customer creation is " + inputRequest);

					if (inputRequest != null && inputRequest.length() > 0) {
						int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
						CBPCBSLog.CBPCBSLogger.debug("RequestLen: " + inputRequestLen + "");
						inputRequest = inputRequestLen + "##8##;" + inputRequest;
						CBPCBSLog.CBPCBSLogger
								.debug("InputRequest" + "Input Request Bytes : " + inputRequest.getBytes("UTF-16LE"));
						dout.write(inputRequest.getBytes("UTF-16LE"));
						dout.flush();
					}
					byte[] readBuffer = new byte[500];
					int num = din.read(readBuffer);

					if (num > 0) {

						byte[] arrayBytes = new byte[num];
						System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
						outputResponse = outputResponse + new String(arrayBytes, "UTF-16LE");
						inputMessageID = outputResponse;
						CBPCBSLog.CBPCBSLogger.debug("OutputResponse: " + outputResponse);

						if (!"".equalsIgnoreCase(outputResponse))
							outputResponse = getResponseXML(cabinetName, sJtsIp, sJtsPort, sessionID, wi_name,
									outputResponse, integrationWaitTime);
						if (outputResponse.contains("&lt;")) {
							outputResponse = outputResponse.replaceAll("&lt;", "<");
							outputResponse = outputResponse.replaceAll("&gt;", ">");
						}
					}
					socket.close();

					outputResponse = outputResponse.replaceAll("</MessageId>",
							"</MessageId>/n<InputMessageId>" + inputMessageID + "</InputMessageId>");

					CBPCBSLog.CBPCBSLogger.debug("Response XML for Customer Update is " + outputResponse);
				}
			} catch (Exception e) {
				System.out.println("Exception in firing the MQ call is "+e.getMessage());
				e.printStackTrace();
				CBPCBSLog.CBPCBSLogger.error("The Exception in Customer Update is " + e.getMessage());
			}
			// End - Customer Update Call

		}
		return outputResponse;
	}

	private String getRequestXML(String cabinetName, String sessionID, String wi_name, String ws_name, String userName,
			StringBuilder final_XML) {
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>" + XMLLOG_HISTORY_TABLE + "</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_XML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		CBPCBSLog.CBPCBSLogger.debug("GetRequestXML: " + strBuff.toString());
		return strBuff.toString();
	}
	
	
	
	public String getInputXMLCIFUpdate(CustomerBean objCustBean,String CIFID,String username,String sessionId,String cabinetName,String jtsIp,String jtsPort)
	{
		String inputXML="";
		String DocDetailsPPT = DocDetailsForUpdateCustomer("PPT",objCustBean);
		String DocDetailsVISA = DocDetailsForUpdateCustomer("VISA",objCustBean);
		String DocDetailsEMID = DocDetailsForUpdateCustomer("EMID",objCustBean);
		
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";
		
		try{
			CBPCBSLog.CBPCBSLogger.debug("Inside getInputXML For CIFUpdate ");
			inputXML = "<EE_EAI_MESSAGE>\n" +
			"<EE_EAI_HEADER>\n" +
				"<MsgFormat>CUSTOMER_UPDATE_REQ</MsgFormat>\n" +
				"<MsgVersion>001</MsgVersion>\n" +
				"<RequestorChannelId>BPM</RequestorChannelId>\n" +
				"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
				"<RequestorLanguage>E</RequestorLanguage>\n" +
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
				"<ReturnCode>911</ReturnCode>\n" +
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
				"<MessageId>cifupdate001</MessageId>\n" +
				"<Extra1>REQ||SHELL.dfgJOHN</Extra1>\n" +
				"<Extra2>"+DateExtra2+"</Extra2>\n" +
			"</EE_EAI_HEADER>\n" +
			"<CustomerDetailsUpdateReq>\n" +
				"<BankId>RAK</BankId>\n" +
				"<CIFId>"+CIFID+"</CIFId>\n" +
				"<RetCorpFlag>R</RetCorpFlag>\n" +
				"<ActionRequired>U</ActionRequired>\n" +
				DocDetailsEMID+
				DocDetailsPPT+
				DocDetailsVISA+
			"</CustomerDetailsUpdateReq>\n" +
			"</EE_EAI_MESSAGE>" ;
		}
		catch(Exception e)
		{
			CBPCBSLog.CBPCBSLogger.error("exception caught in getting inputxml customer update for CIF "+CIFID+" "+ e.getMessage());
			e.printStackTrace();
		}
		return inputXML;
	}
	
	
	public String DocDetailsForUpdateCustomer(String DocType,CustomerBean objCustBean)
	{
		String expdate = "";
		String DocNumber="";
		String docTypeXml="";
		if("VISA".equals(DocType))
		{
			expdate=objCustBean.getVisaExpiryDate();
			DocNumber=objCustBean.getVisaNumber();
		}
		else if("PPT".equals(DocType))
		{
			expdate=objCustBean.getPassportExpiryDate();
			DocNumber=objCustBean.getPassportNumber();
		}else if("EMID".equals(DocType))
		{
			expdate=objCustBean.getEmidExpiryDate();
			DocNumber=objCustBean.getEmidNumber();
		}
		
		if(!"".equalsIgnoreCase(expdate) && !"".equalsIgnoreCase(DocNumber))
		{	
			docTypeXml="<DocDet>\n" +
			"<DocType>"+DocType+"</DocType>\n" +
			"<DocIsVerified>Y</DocIsVerified>\n" +
			"<DocNo>"+DocNumber+"</DocNo>\n" +
			"<DocExpDate>"+expdate+"</DocExpDate>\n" +
			"</DocDet>\n";
		}
		return docTypeXml;
	}
	
	

	private String getResponseXML(String cabinetName, String sJtsIp, String iJtsPort, String sessionID, String wi_name,
			String message_ID, int integrationWaitTime) {

		String outputResponseXML = "";
		try {
			String QueryString = "select OUTPUT_XML from " + XMLLOG_HISTORY_TABLE + " with (nolock) where "
					+ "MESSAGE_ID ='" + message_ID + "' and WI_NAME = '" + wi_name + "'";

			String responseInputXML = CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
			CBPCBSLog.CBPCBSLogger.debug("Response APSelect InputXML: " + responseInputXML);

			int Loop_count = 0;
			do {
				String responseOutputXML = CBPCBS.WFNGExecute(responseInputXML, sJtsIp, iJtsPort, 1);
				CBPCBSLog.CBPCBSLogger.debug("Response APSelect OutputXML: " + responseOutputXML);

				XMLParser xmlParserSocketDetails = new XMLParser(responseOutputXML);
				String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
				CBPCBSLog.CBPCBSLogger.debug("ResponseMainCode: " + responseMainCode);

				int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
				CBPCBSLog.CBPCBSLogger.debug("ResponseTotalRecords: " + responseTotalRecords);
				if (responseMainCode.equals("0") && responseTotalRecords > 0) {
					String responseXMLData = xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData = responseXMLData.replaceAll("[ ]+>", ">").replaceAll("<[ ]+", "<");

					XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

					outputResponseXML = xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
					CBPCBSLog.CBPCBSLogger.debug("OutputResponseXML: " + outputResponseXML);

					if ("".equalsIgnoreCase(outputResponseXML)) {
						outputResponseXML = "Error";
					}
					break;
				}
				Loop_count++;
				Thread.sleep(1000);
			} while (Loop_count < integrationWaitTime);

		} catch (Exception e) {
			CBPCBSLog.CBPCBSLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			CBPCBSLog.CBPCBSLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML = "Error";
		}
		return outputResponseXML;
	}

	public String formatDate(String inDate, String fromFormat, String ToFormat) {
		SimpleDateFormat inSDF = new SimpleDateFormat(fromFormat); // "mm/dd/yyyy"
		SimpleDateFormat outSDF = new SimpleDateFormat(ToFormat); // "yyyy-MM-dd"

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
