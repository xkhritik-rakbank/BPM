/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP Status
File Name				: RAOPIntegration.java
Author 					: Shubham Gupta
Date (DD/MM/YYYY)		: 15/06/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.RAOP.Status;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;

public class RAOPIntegration
{

	
	public	String customIntegration(String cabinetName,String sessionId,String sJtsIp, String iJtsPort , String processInstanceID,
			String ws_name, int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap, HashMap<String, String> ExtTabDataMap)
	{

		try
		{
			RAOPStatusLog.setLogger();


			String w_name = ExtTabDataMap.get("WINAME");
			String r_reason = ExtTabDataMap.get ("REJECTREASON");
			String r_code = ExtTabDataMap.get ("REJECTCODE");
			String stat = ExtTabDataMap.get ("STATUS");
			String remark = ExtTabDataMap.get ("REMARKS");
			String channel = ExtTabDataMap.get ("CHANNEL");
			//String dec = ExtTabDataMap.get ("DECISION");


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
					"<ProcessName>RAOP</ProcessName>\n"+
					"<ChannelId>"+channel+"</ChannelId>\n"+
					"<WorkitemNumber>"+w_name+"</WorkitemNumber>\n"+
					"<Status>"+stat+"</Status>\n"+
					"<RejectCode>"+r_code+"</RejectCode>\n"+
					"<RejectReason>"+r_reason+"</RejectReason>\n"+
					"<Remarks>"+remark+"</Remarks>\n"+
					"</NotifySRStatusRequest>\n"+
					"</EE_EAI_MESSAGE>\n");

			RAOPStatusLog.RAOPStatusLogger.debug("Integration input XML: "+sInputXML);

			String responseXML =socketConnection(cabinetName, CommonConnection.getUsername(), sessionId,sJtsIp,
					 iJtsPort,  processInstanceID,  ws_name, integrationWaitTime, socket_connection_timeout,
					  socketDetailsMap, ExtTabDataMap, sInputXML);

			RAOPStatusLog.RAOPStatusLogger.debug("responseXML: "+responseXML);

			XMLParser xmlParserSocketDetails= new XMLParser(responseXML);
		    String return_code = xmlParserSocketDetails.getValueOf("ReturnCode");
		    RAOPStatusLog.RAOPStatusLogger.debug("Return Code: "+return_code);

		    String return_desc = xmlParserSocketDetails.getValueOf("ReturnDesc");
			
			if (return_desc.trim().equalsIgnoreCase(""))
				return_desc = xmlParserSocketDetails.getValueOf("Description");
				
			String MsgId = "";
			if (responseXML.contains("<MessageId>"))
				MsgId = xmlParserSocketDetails.getValueOf("MessageId");
			
		    RAOPStatusLog.RAOPStatusLogger.debug("Return Desc: "+return_desc);
		    return (return_code + "~" + return_desc + "~"+ MsgId +"~End");

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

			RAOPStatusLog.RAOPStatusLogger.debug("userName "+ username);
			RAOPStatusLog.RAOPStatusLogger.debug("SessionId "+ sessionId);

			socketServerIP=socketDetailsMap.get("SocketServerIP");
			RAOPStatusLog.RAOPStatusLogger.debug("SocketServerIP "+ socketServerIP);
			socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
			RAOPStatusLog.RAOPStatusLogger.debug("SocketServerPort "+ socketServerPort);

	   		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0))
	   		{

    			socket = new Socket(socketServerIP, socketServerPort);
    			socket.setSoTimeout(connection_timeout*1000);
    			out = socket.getOutputStream();
    			socketInputStream = socket.getInputStream();
    			dout = new DataOutputStream(out);
    			din = new DataInputStream(socketInputStream);
    			RAOPStatusLog.RAOPStatusLogger.debug("Dout " + dout);
    			RAOPStatusLog.RAOPStatusLogger.debug("Din " + din);

    			outputResponse = "";



    			inputRequest = getRequestXML( cabinetName,sessionId ,processInstanceID, ws_name, username, sInputXML);


    			if (inputRequest != null && inputRequest.length() > 0)
    			{
    				int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
    				RAOPStatusLog.RAOPStatusLogger.debug("RequestLen: "+inputRequestLen + "");
    				inputRequest = inputRequestLen + "##8##;" + inputRequest;
    				RAOPStatusLog.RAOPStatusLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
    				RAOPStatusLog.RAOPStatusLogger.debug("OutputResponse: "+outputResponse);

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

				//RAOPStatusLog.RAOPStatusLogger.debug("outputResponse "+outputResponse);
				return outputResponse;

    	 		}

    		else
    		{
    			RAOPStatusLog.RAOPStatusLogger.debug("SocketServerIp and SocketServerPort is not maintained "+"");
    			RAOPStatusLog.RAOPStatusLogger.debug("SocketServerIp is not maintained "+	socketServerIP);
    			RAOPStatusLog.RAOPStatusLogger.debug(" SocketServerPort is not maintained "+	socketServerPort);
    			return "Socket Details not maintained";
    		}

		}

		catch (Exception e)
		{
			RAOPStatusLog.RAOPStatusLogger.debug("Exception Occured Mq_connection_CC"+e.getStackTrace());
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
				RAOPStatusLog.RAOPStatusLogger.debug("Final Exception Occured Mq_connection_CC"+e.getStackTrace());
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
		strBuff.append("<XMLHISTORY_TABLENAME>NG_RAOP_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + processInstanceID + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(sInputXML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		RAOPStatusLog.RAOPStatusLogger.debug("GetRequestXML: "+ strBuff.toString());
		return strBuff.toString();

	}

	private String getResponseXML(String cabinetName,String sJtsIp,String iJtsPort, String
			sessionId, String processInstanceID,String message_ID, int integrationWaitTime)
	{

		String outputResponseXML="";
		try
		{
			String QueryString = "select OUTPUT_XML from NG_RAOP_XMLLOG_HISTORY with (nolock) where " +
					"MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+processInstanceID+"'";

			String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionId);
			RAOPStatusLog.RAOPStatusLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=RAOPStatus.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				RAOPStatusLog.RAOPStatusLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    RAOPStatusLog.RAOPStatusLogger.debug("ResponseMainCode: "+responseMainCode);



			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    RAOPStatusLog.RAOPStatusLogger.debug("ResponseTotalRecords: "+responseTotalRecords);

			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{

					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);
	        		//RAOPStatusLog.RAOPStatusLogger.debug("ResponseXMLData: "+responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		//RAOPStatusLog.RAOPStatusLogger.debug("OutputResponseXML: "+outputResponseXML);

	        		if("".equalsIgnoreCase(outputResponseXML)){
	        			outputResponseXML="Error";
	    			}
	        		break;
				}
			    Loop_count++;
			    Thread.sleep(1000);
			}
			while(Loop_count<integrationWaitTime);
			RAOPStatusLog.RAOPStatusLogger.debug("integrationWaitTime: "+integrationWaitTime);

		}
		catch(Exception e)
		{
			RAOPStatusLog.RAOPStatusLogger.debug("Exception occurred in outputResponseXML" + e.getMessage());
			RAOPStatusLog.RAOPStatusLogger.debug("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}

		return outputResponseXML;

	}
}





