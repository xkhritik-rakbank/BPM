package com.newgen.CMP.Status;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.newgen.CBP.Status.CBPStatusLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;

public class CMPIntegration {

	
	public	String customIntegration(String cabinetName,String sessionId,String sJtsIp, String iJtsPort , String processInstanceID,
			String ws_name, int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap, HashMap<String, String> ExtTabDataMap)
	{
		try
		{
			CMPStatusLog.setLogger();


			String w_name = ExtTabDataMap.get("WINAME");
			String remarks = ExtTabDataMap.get ("REJECTREASON");
			String r_reason = ExtTabDataMap.get ("REJECTCODE");
			String stat = ExtTabDataMap.get ("STATUS");
			//String dec = ExtTabDataMap.get ("DECISION");
			String r_code = "";

			try
			{
				if (r_reason.contains("-"))
				{
					String [] rcd = r_reason.split("-");
					r_code = rcd[0].replace("(", "").replace(")", "");
					r_reason = rcd[1];
				}
			}
			catch(Exception e)
			{
				CMPStatusLog.CMPStatusLogger.debug("Exception in getting reject code: "+e.getMessage());
			}
			
			
			if ("".equalsIgnoreCase(r_code))
			{
				String QueryString = "select Item_Code from USR_0_CMP_ERROR_DESC_MASTER with (nolock) where " +
						"Item_Desc ='"+r_reason+"'";
	
				String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionId);
				CMPStatusLog.CMPStatusLogger.debug("Reject Reason APSelect InputXML: "+responseInputXML);
	
				
				String responseOutputXML=CMPStatus.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				CMPStatusLog.CMPStatusLogger.debug("Reject Reason APSelect OutputXML: "+responseOutputXML);
	
				XMLParser xmlParserErrorReason= new XMLParser(responseOutputXML);
				String responseMainCode = xmlParserErrorReason.getValueOf("MainCode");
				CMPStatusLog.CMPStatusLogger.debug("ResponseMainCode: "+responseMainCode);
	
	
				int responseTotalRecords = Integer.parseInt(xmlParserErrorReason.getValueOf("TotalRetrieved"));
				CMPStatusLog.CMPStatusLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
				
				if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
	
					String responseXMLData=xmlParserErrorReason.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
	
					XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);
					CMPStatusLog.CMPStatusLogger.debug("ResponseXMLData: "+responseXMLData);
	
					r_code=xmlParserResponseXMLData.getValueOf("Item_Code");
					CMPStatusLog.CMPStatusLogger.debug("RejectCode: "+r_code);
	
				}
			}
		
			java.util.Date d1 = new Date();
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
			String DateExtra2 = sdf1.format(d1)+"+04:00";
			
			StringBuilder sInputXML = new StringBuilder("<EE_EAI_MESSAGE>\n"+
					"<EE_EAI_HEADER>\n"+
					"<MsgFormat>NOTIFY_SR_STATUS</MsgFormat>\n"+
					"<MsgVersion>0001</MsgVersion>\n"+
					"<RequestorChannelId>BPM</RequestorChannelId>\n"+
					"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
					"<RequestorLanguage>E</RequestorLanguage>\n"+
					"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
					"<ReturnCode>0000</ReturnCode>\n"+
					"<ReturnDesc>REQ</ReturnDesc>\n"+
					"<MessageId>DEDUPLIST001</MessageId>\n"+
					"<Extra1>REQ||BPM.123</Extra1>\n"+
					"<Extra2>"+DateExtra2+"</Extra2>\n"+
					"</EE_EAI_HEADER>\n"+
					"<NotifySRStatusRequest>\n"+
					"<BankId>RAK</BankId>\n"+
					"<ProcessName>CMP</ProcessName>\n"+
					"<ChannelId>YAP</ChannelId>\n"+
					"<WorkitemNumber>"+w_name+"</WorkitemNumber>\n"+
					"<Status>"+stat+"</Status>\n"+
					"<RejectCode>"+r_code+"</RejectCode>\n"+
					"<RejectReason>"+r_reason+"</RejectReason>\n"+
					"<Remarks>"+remarks+"</Remarks>\n"+
					"</NotifySRStatusRequest>\n"+
					"</EE_EAI_MESSAGE>\n");

			CMPStatusLog.CMPStatusLogger.debug("Integration input XML: "+sInputXML);

			String responseXML =socketConnection(cabinetName, CommonConnection.getUsername(), sessionId,sJtsIp,
					 iJtsPort,  processInstanceID,  ws_name, integrationWaitTime, socket_connection_timeout,
					  socketDetailsMap, ExtTabDataMap, sInputXML);

			CMPStatusLog.CMPStatusLogger.debug("responseXML: "+responseXML);

			XMLParser xmlParserSocketDetails= new XMLParser(responseXML);
		    String return_code = xmlParserSocketDetails.getValueOf("ReturnCode");
		    CMPStatusLog.CMPStatusLogger.debug("Return Code: "+return_code);

		    String return_desc = xmlParserSocketDetails.getValueOf("ReturnDesc");
			
			if (return_desc.trim().equalsIgnoreCase(""))
				return_desc = xmlParserSocketDetails.getValueOf("Description");
			
			String MsgId = "";
			if (responseXML.contains("<MessageId>"))
				MsgId = xmlParserSocketDetails.getValueOf("MessageId");
			
		    CMPStatusLog.CMPStatusLogger.debug("Return Desc: "+return_desc);
		    return (return_code + "~" + return_desc +"~" + MsgId + "~End");

		}
		catch(Exception e)
		{
			return "";
		}

	}
	
	String socketConnection(String cabinetName, String username, String sessionId, String sJtsIp,
			String iJtsPort, String processInstanceID, String ws_name,
			int connection_timeout, int integrationWaitTime,HashMap<String, String> socketDetailsMap, HashMap<String, String> ExtTabDataMap, StringBuilder sInputXML)
	{

		String socketServerIP;
		int socketServerPort;
		Socket socket = null;
		OutputStream out = null;
		InputStream socketInputStream = null;
		DataOutputStream dout = null;
		DataInputStream din = null;
		String outputResponse = null;
		String inputRequest = null;
		String inputMessageID = null;



		try
		{

			CMPStatusLog.CMPStatusLogger.debug("userName "+ username);
			CMPStatusLog.CMPStatusLogger.debug("SessionId "+ sessionId);

			socketServerIP=socketDetailsMap.get("SocketServerIP");
			CMPStatusLog.CMPStatusLogger.debug("SocketServerIP "+ socketServerIP);
			socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
			CMPStatusLog.CMPStatusLogger.debug("SocketServerPort "+ socketServerPort);

	   		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0))
	   		{

    			socket = new Socket(socketServerIP, socketServerPort);
    			socket.setSoTimeout(connection_timeout*1000);
    			out = socket.getOutputStream();
    			socketInputStream = socket.getInputStream();
    			dout = new DataOutputStream(out);
    			din = new DataInputStream(socketInputStream);
    			CMPStatusLog.CMPStatusLogger.debug("Dout " + dout);
    			CMPStatusLog.CMPStatusLogger.debug("Din " + din);

    			outputResponse = "";



    			inputRequest = getRequestXML( cabinetName,sessionId ,processInstanceID, ws_name, username, sInputXML);


    			if (inputRequest != null && inputRequest.length() > 0)
    			{
    				int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
    				CMPStatusLog.CMPStatusLogger.debug("RequestLen: "+inputRequestLen + "");
    				inputRequest = inputRequestLen + "##8##;" + inputRequest;
    				CMPStatusLog.CMPStatusLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
    				CMPStatusLog.CMPStatusLogger.debug("OutputResponse: "+outputResponse);

    				if(!"".equalsIgnoreCase(outputResponse))

    					outputResponse = getResponseXML(cabinetName,sJtsIp,iJtsPort,sessionId,
    							processInstanceID,outputResponse,integrationWaitTime );




    				if(outputResponse.contains("&lt;"))
    				{
    					outputResponse=outputResponse.replaceAll("&lt;", "<");
    					outputResponse=outputResponse.replaceAll("&gt;", ">");
    				}
    			}
    			socket.close();

				outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

				CMPStatusLog.CMPStatusLogger.debug("outputResponse "+outputResponse);
				return outputResponse;

    	 		}

    		else
    		{
    			CMPStatusLog.CMPStatusLogger.debug("SocketServerIp and SocketServerPort is not maintained "+"");
    			CMPStatusLog.CMPStatusLogger.debug("SocketServerIp is not maintained "+	socketServerIP);
    			CMPStatusLog.CMPStatusLogger.debug(" SocketServerPort is not maintained "+	socketServerPort);
    			return "Socket Details not maintained";
    		}

		}

		catch (Exception e)
		{
			CMPStatusLog.CMPStatusLogger.debug("Exception Occured Mq_connection_CC"+e.getStackTrace());
			return "";
		}
		finally
		{
			try
			{
				if(out != null)
				{
					out.close();
					out=null;
				}
				if(socketInputStream != null)
				{

					socketInputStream.close();
					socketInputStream=null;
				}
				if(dout != null)
				{

					dout.close();
					dout=null;
				}
				if(din != null)
				{

					din.close();
					din=null;
				}
				if(socket != null)
				{
					if(!socket.isClosed())
						socket.close();
					socket=null;
				}

			}

			catch(Exception e)
			{
				CMPStatusLog.CMPStatusLogger.debug("Final Exception Occured Mq_connection_CC"+e.getStackTrace());
				//printException(e);
			}
		}
	}
	
	private String getRequestXML(String cabinetName, String sessionId,
			String processInstanceID, String ws_name, String userName, StringBuilder sInputXML)
	{
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionId + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_CMP_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + processInstanceID + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(sInputXML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		CMPStatusLog.CMPStatusLogger.debug("GetRequestXML: "+ strBuff.toString());
		return strBuff.toString();
	}
	
	private String getResponseXML(String cabinetName,String sJtsIp,String iJtsPort, String
			sessionId, String processInstanceID,String message_ID, int integrationWaitTime)
	{

		String outputResponseXML="";
		try
		{
			String QueryString = "select OUTPUT_XML from NG_CMP_XMLLOG_HISTORY with (nolock) where " +
					"MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+processInstanceID+"'";

			String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionId);
			CMPStatusLog.CMPStatusLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=CMPStatus.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				CMPStatusLog.CMPStatusLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    CMPStatusLog.CMPStatusLogger.debug("ResponseMainCode: "+responseMainCode);



			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    CMPStatusLog.CMPStatusLogger.debug("ResponseTotalRecords: "+responseTotalRecords);

			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{

					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);
	        		CMPStatusLog.CMPStatusLogger.debug("ResponseXMLData: "+responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		CMPStatusLog.CMPStatusLogger.debug("OutputResponseXML: "+outputResponseXML);

	        		if("".equalsIgnoreCase(outputResponseXML)){
	        			outputResponseXML="Error";
	    			}
	        		break;
				}
			    Loop_count++;
			    Thread.sleep(1000);
			}
			while(Loop_count<integrationWaitTime);
			CMPStatusLog.CMPStatusLogger.debug("integrationWaitTime: "+integrationWaitTime);

		}
		catch(Exception e)
		{
			CMPStatusLog.CMPStatusLogger.debug("Exception occurred in outputResponseXML" + e.getMessage());
			CMPStatusLog.CMPStatusLogger.debug("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}

		return outputResponseXML;

	}
}
