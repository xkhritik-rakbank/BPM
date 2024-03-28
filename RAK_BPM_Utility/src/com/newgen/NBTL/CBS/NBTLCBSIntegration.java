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


package com.newgen.NBTL.CBS;

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
import com.newgen.NBTL.CBS.NBTLCBS;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class NBTLCBSIntegration {

	
	private String XMLLOG_HISTORY_TABLE = "NG_NBTL_XMLLOG_HISTORY";
	private String NBTL_EXTTABLE = "RB_NBTL_EXTTABLE";
	
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
	
	public ResponseBean NBTL_Memopad_Integration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,String strCorporateCIF,String MemoPadText,
			HashMap<String, String> socketDetailsMap, String activityName) throws Exception
	{
		ResponseBean objResponseBean=new ResponseBean();	
				
		String MemopadinputXML = "<EE_EAI_MESSAGE>" +
								//"\n\t<ProcessName>NBTL</ProcessName>"+
								"\n\t<EE_EAI_HEADER>"+
								"\n\t\t<MsgFormat>MEMOPAD_MAINTENANCE_REQ</MsgFormat>"+
								"\n\t\t<MsgVersion>0001</MsgVersion>"+
								"\n\t\t<RequestorChannelId>BPM</RequestorChannelId>"+
								"\n\t\t<RequestorUserId>RAKUSER</RequestorUserId>" +
								"\n\t\t<RequestorLanguage>E</RequestorLanguage>" +
								"\n\t\t<RequestorSecurityInfo>secure</RequestorSecurityInfo>" +
								"\n\t\t<ReturnCode>911</ReturnCode>" +
								"\n\t\t<ReturnDesc>Issuer Timed Out</ReturnDesc>" +
								"\n\t\t<MessageId>UniqueMessageId123</MessageId>" +
								"\n\t\t<Extra1>REQ||SHELL.JOHN</Extra1>" +
								"\n\t\t<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2>" +
								"\n\t</EE_EAI_HEADER>" +
								"\n\t<MemopadMaintenanceReq>" +
								"\n\t\t<BankId>RAK</BankId>" + 
								"\n\t\t<CIFID>"+strCorporateCIF+"</CIFID>" +
								//"\n\t\t<ACNumber>"+AccountNo+"</ACNumber>" + 
								"\n\t\t<Operation>A</Operation>" +
								"\n\t\t<Topic>TL Expiry</Topic>" +
								"\n\t\t<FuncCode>FT</FuncCode>" +
								"\n\t\t<Intent>F</Intent>" +
								"\n\t\t<Security>P</Security>" +
								"\n\t\t<MemoText>" + MemoPadText + "</MemoText>" +
								"\n\t\t<ExceptionCode></ExceptionCode>" +
								"\n\t\t<FreeField1></FreeField1>" +
								"\n\t\t<FreeField2></FreeField2>" +
								"\n\t\t<FreeField3></FreeField3>" +
								"\n\t</MemopadMaintenanceReq>" +
								"\n</EE_EAI_MESSAGE>";

				NBTLCBSLog.NBTLCBSLogger.debug("Input XML for NBTL Memopad is "+MemopadinputXML);

				try
				{
					NBTLCBSLog.NBTLCBSLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					NBTLCBSLog.NBTLCBSLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					NBTLCBSLog.NBTLCBSLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						NBTLCBSLog.NBTLCBSLogger.debug("Data output stream is "+dout);
						NBTLCBSLog.NBTLCBSLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, activityName, CommonConnection.getUsername(), new StringBuilder(MemopadinputXML));

						NBTLCBSLog.NBTLCBSLogger.debug("Input MQ XML for Customer creation is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							NBTLCBSLog.NBTLCBSLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							NBTLCBSLog.NBTLCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
							NBTLCBSLog.NBTLCBSLogger.debug("OutputResponse: "+outputResponse);

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
						XMLParser sXMLParser=new XMLParser(outputResponse);
						
						String return_code = sXMLParser.getValueOf("ReturnCode");
						String return_desc = sXMLParser.getValueOf("ReturnDesc");
						if (return_desc.trim().equalsIgnoreCase(""))
							return_desc = sXMLParser.getValueOf("Description");
						
						if("0000".equalsIgnoreCase(return_code))
						{
							objResponseBean.setMemopadReturnCode("Success");
							objResponseBean.setMemoIntegrationDecision("Success");
							objResponseBean.setMemoMWErrorCode(return_code);
							objResponseBean.setMemoMWErrorDesc(return_desc);
							objResponseBean.setMemoNBTLRequestId(sXMLParser.getValueOf("RequestId"));
						}
						else
						{
							objResponseBean.setMemopadReturnCode("Failure");
							objResponseBean.setMemoIntegrationDecision("Failure");
							objResponseBean.setMemoMWErrorCode(return_code);
							objResponseBean.setMemoMWErrorDesc(return_desc);
						}
						NBTLCBSLog.NBTLCBSLogger.debug("Response XML for Memopad is "+outputResponse);
					}
				}
				catch(Exception e)
				{
					NBTLCBSLog.NBTLCBSLogger.error("The Exception in Memopad is "+e.getMessage());
				}
		return objResponseBean;	
	}
	
	public ResponseBean NBTLCBS_CifUpdateIntegration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,String strCorporateCIF,String strToBeTLNo,String strToBeExpiryDate,String KYC_ReviewDate,
			String INTEGRATION_ERROR_RECEIVED,HashMap<String, String> socketDetailsMap, String strWi_name,String activityName,int ThresholdYear,int year,String PrevOPSReviewDec) throws Exception
	{
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
								"\n\t\t<RetCorpFlag>C</RetCorpFlag>" + 
								"\n\t\t<ActionRequired>U</ActionRequired>";
								//"\n\t\t<Email>"+strEmail+"</Email>" +
								
				String append = "";
				if(year > ThresholdYear)
				{
					if(!"Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED))
					{
						append +="\n\t\t<RtlAddnlDet>" +
								"\n\t\t\t<KYCDetails>" +
								"\n\t\t\t\t<KYCReviewdate>"+KYC_ReviewDate+"</KYCReviewdate>" +
								"\n\t\t\t</KYCDetails>" +
								"\n\t\t</RtlAddnlDet>";
					}
					append +="\n\t</CustomerDetailsUpdateReq>" +
							"\n</EE_EAI_MESSAGE>";
				}else
				{
					append ="\n\t\t<DocDet>" + 
							"\n\t\t\t<DocType>TDLIC</DocType>" + 
							"\n\t\t\t<DocIsVerified>Y</DocIsVerified>" + 
							"\n\t\t\t<DocNo>"+strToBeTLNo+"</DocNo>"+
							"\n\t\t\t<DocExpDate>"+strToBeExpiryDate+"</DocExpDate>";
					if("Approve with Profile Change".equalsIgnoreCase(PrevOPSReviewDec)){
							if("Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED))
							{
								append +="\n\t\t\t<DocUpdateStatus>APR</DocUpdateStatus>";
							}else
							{
								append +="\n\t\t\t<DocUpdateStatus>HFA</DocUpdateStatus>";
							}
					}
							append +="\n\t\t</DocDet>";
							if(!"Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED))
							{
								append +="\n\t\t<RtlAddnlDet>" +
										"\n\t\t\t<KYCDetails>" +
										"\n\t\t\t\t<KYCReviewdate>"+KYC_ReviewDate+"</KYCReviewdate>" +
										"\n\t\t\t</KYCDetails>" +
										"\n\t\t</RtlAddnlDet>";
							}
							append +="\n\t</CustomerDetailsUpdateReq>" +
							"\n</EE_EAI_MESSAGE>";
				}
				CIFUpdateinputXML += append;
				NBTLCBSLog.NBTLCBSLogger.debug("Input XML for NBTL CIF Update is "+CIFUpdateinputXML);

				try
				{
					NBTLCBSLog.NBTLCBSLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					NBTLCBSLog.NBTLCBSLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					NBTLCBSLog.NBTLCBSLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						NBTLCBSLog.NBTLCBSLogger.debug("Data output stream is "+dout);
						NBTLCBSLog.NBTLCBSLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, activityName, CommonConnection.getUsername(), new StringBuilder(CIFUpdateinputXML));

						NBTLCBSLog.NBTLCBSLogger.debug("Input MQ XML for Customer creation is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							NBTLCBSLog.NBTLCBSLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							NBTLCBSLog.NBTLCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
							NBTLCBSLog.NBTLCBSLogger.debug("OutputResponse: "+outputResponse);

							if(!"".equalsIgnoreCase(outputResponse))
								outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
										wi_name,outputResponse,integrationWaitTime );
							if(outputResponse.contains("&lt;"))
							{
								outputResponse=outputResponse.replaceAll("&lt;", "<");
								outputResponse=outputResponse.replaceAll("&gt;", ">");
							}
							NBTLCBSLog.NBTLCBSLogger.debug("OutputResponse: "+outputResponse);
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
						NBTLCBSLog.NBTLCBSLogger.debug("return_code: "+return_code);
						if(return_desc.trim().contains("CIF UNDER VERIFICATION"))
						{
							String columnNames="CIF_UnderVerification";
							String columnValues="'Y'";
							String sWhereClause ="WINAME ='"+strWi_name+"' ";
							String apUpdateInput = CommonMethods.apUpdateInput(cabinetName,sessionID,NBTL_EXTTABLE,columnNames,columnValues,
									sWhereClause);
							NBTLCBSLog.NBTLCBSLogger.debug("APUpdate InputXML: "+apUpdateInput);

							String apUpdateOutputXML=NBTLCBS.WFNGExecute(apUpdateInput,sJtsIp,sJtsPort,1);
							NBTLCBSLog.NBTLCBSLogger.debug("APUpdate OutputXML: "+apUpdateOutputXML);

							XMLParser apUpdateOutputXMLxmlParser= new XMLParser(apUpdateOutputXML);
							String apUpdateOutputXMLMainCode = apUpdateOutputXMLxmlParser.getValueOf("MainCode");
							NBTLCBSLog.NBTLCBSLogger.debug("MainCode: "+apUpdateOutputXMLMainCode);
							
							if(apUpdateOutputXMLMainCode.equalsIgnoreCase("0"))
							{
								NBTLCBSLog.NBTLCBSLogger.debug("CIF_UnderVerification updated in database");

							}
							objResponseBean.setCifUpdateReturnCode("CIF_UnderVerification");
							objResponseBean.setIntegrationDecision("CIF_UnderVerification");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
						}
						 else if("0000".equalsIgnoreCase(return_code))
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
						NBTLCBSLog.NBTLCBSLogger.debug("Response XML for Cif Update is "+outputResponse);
					}
				}
				catch(Exception e)
				{
					NBTLCBSLog.NBTLCBSLogger.error("The Exception in Cif Update is "+e.getMessage());
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
		NBTLCBSLog.NBTLCBSLogger.debug("GetRequestXML: "+ strBuff.toString());
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
			NBTLCBSLog.NBTLCBSLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=NBTLCBS.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				NBTLCBSLog.NBTLCBSLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    NBTLCBSLog.NBTLCBSLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    NBTLCBSLog.NBTLCBSLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		NBTLCBSLog.NBTLCBSLogger.debug("OutputResponseXML: "+outputResponseXML);

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
			NBTLCBSLog.NBTLCBSLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			NBTLCBSLog.NBTLCBSLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
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
