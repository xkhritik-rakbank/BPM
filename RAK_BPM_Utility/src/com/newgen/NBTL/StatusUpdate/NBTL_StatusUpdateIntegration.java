package com.newgen.NBTL.StatusUpdate;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.newgen.NBTL.StatusUpdate.CustomerBean;
import com.newgen.NBTL.StatusUpdate.NBTL_StatusUpdate;
import com.newgen.NBTL.StatusUpdate.NBTL_StatusUpdate_Log;
import com.newgen.NBTL.StatusUpdate.ResponseBean;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;

public class NBTL_StatusUpdateIntegration {



	private String NBTL_EXTTABLE = "RB_NBTL_EXTTABLE";
	private String XMLLOG_HISTORY_TABLE = "NG_NBTL_XMLLOG_HISTORY";
	private String ws_name="Status_Update";
	
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

	public ResponseBean NBTL_StatusUpdate_Integration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap) throws Exception
	{
		ResponseBean objResponseBean=new ResponseBean();
		
		String QueryString="SELECT WINAME,CorporateCIF,KYCRefernceNo,ToBeTLNo,IsDeclined,DiscardReason"
				+ " FROM "+NBTL_EXTTABLE+" with (nolock) where WINAME='"+wi_name+"'";


		String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
		NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

		String sOutputXML=NBTL_StatusUpdate.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
		NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Output XML for extranl Table select "+sOutputXML);

		XMLParser sXMLParser= new XMLParser(sOutputXML);
	    String sMainCode = sXMLParser.getValueOf("MainCode");
	    NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
	    NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Inside If block");
			CustomerBean objCustBean=new CustomerBean();
			
			String strWi_name=sXMLParser.getValueOf("winame");
			objCustBean.setWiName(strWi_name);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("strWi_name "+strWi_name);
			
			String ToBeTLNo=sXMLParser.getValueOf("ToBeTLNo");
			objCustBean.setWiName(ToBeTLNo);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("ToBeTLNo "+ToBeTLNo);
			
			String strCorporateCIF=sXMLParser.getValueOf("CorporateCIF");
			objCustBean.setCorporateCIF(strCorporateCIF);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("strCorporateCIF "+strCorporateCIF);
			
			String IsDeclined=sXMLParser.getValueOf("IsDeclined");
			if(IsDeclined == null){
				IsDeclined = "";
			}
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("IsDeclined "+IsDeclined);
			
			String DiscardReason=sXMLParser.getValueOf("DiscardReason");
			if(DiscardReason == null){
				DiscardReason = "";
			}
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("DiscardReason "+DiscardReason);
			
			/*String AccountNo=sXMLParser.getValueOf("AccountNo");
			objCustBean.setAccountNo(AccountNo);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("AccountNo "+AccountNo);*/
			
			String KYCRefernceNo=sXMLParser.getValueOf("KYCRefernceNo");
			objCustBean.setKYCRefernceNo(KYCRefernceNo);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("KYCRefernceNo "+KYCRefernceNo);
			
			SimpleDateFormat outputdateFormat = new SimpleDateFormat("yyyy-MM-dd");
			
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("objCustBean.getWiName() "+objCustBean.getWiName());
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("objCustBean.getCorporate_CIF() "+objCustBean.getCorporateCIF());	
			
				//Date date = new Date();
				//String KYC_ReviewDate  = outputdateFormat.format(date);
				
				String StatusUpdateinputXML = "<EE_EAI_MESSAGE>" +
								//"\n\t<ProcessName>NBTL</ProcessName>"+
								"\n\t<EE_EAI_HEADER>"+
								"\n\t\t<MsgFormat>STATUS_UPDATE_REQ</MsgFormat>"+
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
								"\n\t<StatusUpdateRequest>" +
								"\n\t\t<BankId>RAK</BankId>" + 
								"\n\t\t<ProcessName>NBTL</ProcessName>" + 
								"\n\t\t<SubprocessName>KYC</SubprocessName>" + 
								//"\n\t\t<CIFId>"+strCorporateCIF+"</CIFId>" +
								"\n\t\t<KYCReferenceNo>" + KYCRefernceNo + "</KYCReferenceNo>" +
								"\n\t\t<ChannelId>KYC</ChannelId>" +
								"\n\t\t<WorkitemNumber>" + strWi_name + "</WorkitemNumber>" +
								"\n\t\t<TradeLicenseNo>" + ToBeTLNo + "</TradeLicenseNo>";
				
				String append = "";
				if("Y".equalsIgnoreCase(IsDeclined))
				{
					append += "\n\t\t<WorkItemStatus>REJECTED</WorkItemStatus>";
					append += "\n\t\t<RejectReason>" + DiscardReason + "</RejectReason>";
					append += "\n</StatusUpdateRequest>";
					append += "\n</EE_EAI_MESSAGE>";
				}else
				{
					append += "\n\t\t<WorkItemStatus>APPROVED</WorkItemStatus>";
					append += "\n</StatusUpdateRequest>";
					append += "\n</EE_EAI_MESSAGE>";
				}
				
				StatusUpdateinputXML += append;

				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input XML for NBTL StatusUpdate is "+StatusUpdateinputXML);

				try
				{
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Data output stream is "+dout);
						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(StatusUpdateinputXML));

						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input MQ XML for System Update is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("OutputResponse: "+outputResponse);

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
							objResponseBean.setStatusUpdateReturnCode("Success");
							objResponseBean.setIntegrationDecision("Success");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
							objResponseBean.setNBTLRequestId(sXMLParser.getValueOf("RequestId"));
						}
						else
						{
							objResponseBean.setStatusUpdateReturnCode("Failure");
							objResponseBean.setIntegrationDecision("Failure");
							objResponseBean.setMWErrorCode(return_code);
							objResponseBean.setMWErrorDesc(return_desc);
						}
						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Response XML for StatusUpdate is "+outputResponse);
					}
				}
				catch(Exception e)
				{
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("The Exception in StatusUpdate is "+e.getMessage());
				}
			} 
			else
			{
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Error in APSelect for Existing Customer/Workitem: ");
				
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
		NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("GetRequestXML: "+ strBuff.toString());
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
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=NBTL_StatusUpdate.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("OutputResponseXML: "+outputResponseXML);

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
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
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
