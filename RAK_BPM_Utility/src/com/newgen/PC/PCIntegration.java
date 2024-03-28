/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: PC
File Name				: PCIntegration.java
Author 					: Sakshi Grover
Date (DD/MM/YYYY)		: 30/04/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.PC;

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



public class PCIntegration
{
	String customIntegration(String cabinetName, String sessionID,String sJtsIp, String iJtsPort , String wi_name,
		String ws_name, int socket_connection_timeout,int integrationWaitTime,
		HashMap<String, String> socketDetailsMap)
	{
		int call_status_fail_count=0;
		String DesStatus="Success";
		try
		{
			String QueryString = "SELECT UPPER(ACC_NUMBER) AS ACC_NUMBER, UPPER(INTEGRATION_FIELD) AS INTEGRATION_FIELD, " +
			"INSERTIONORDERID FROM USR_0_PC_ERR_HANDLING WITH (nolock) WHERE WI_NAME ='"+wi_name+"' AND " +
			"(CALL_STATUS ='New' OR CALL_STATUS='Failure' OR CALL_STATUS='' OR CALL_STATUS IS NULL)";

			String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);

			PCLog.PCLogger.debug("APSelect Inputxml: "+sInputXML);

			String sOutputXML=PC.WFNGExecute(sInputXML,sJtsIp,iJtsPort,1);
			PCLog.PCLogger.debug("APSelect OutputXML: "+sOutputXML);

		    XMLParser sXMLParser= new XMLParser(sOutputXML);
		    String sMainCode = sXMLParser.getValueOf("MainCode");
		    PCLog.PCLogger.debug("SMainCode: "+sMainCode);

		    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
		    PCLog.PCLogger.debug("STotalRecords: "+sTotalRecords);

			if (sMainCode.equals("0") && sTotalRecords > 0)
			{
				for(int i=0;i<sTotalRecords;i++)
				{

					String sXMLData=sXMLParser.getNextValueOf("Record");
					sXMLData =sXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser subXMLParser = new XMLParser(sXMLData);
	        		String insertionorderid=subXMLParser.getValueOf("insertionorderid");
	        		PCLog.PCLogger.debug("Insertionorderid: "+insertionorderid);

	        		String accountNumber=subXMLParser.getValueOf("ACC_NUMBER");
	        		PCLog.PCLogger.debug("AccountNumber: "+accountNumber);

	        		String integrationField=subXMLParser.getValueOf("INTEGRATION_FIELD");
	        		PCLog.PCLogger.debug("IntegrationField: "+integrationField);


					String responseXML=socketConnection(cabinetName,sessionID,sJtsIp,iJtsPort,wi_name,
							ws_name,accountNumber,integrationField,socket_connection_timeout,integrationWaitTime,
							socketDetailsMap);

					XMLParser xmlParserResponse = new XMLParser(responseXML);
					String call_status=xmlParserResponse.getValueOf("Status");
					PCLog.PCLogger.debug("Call_status: "+call_status);

					String msg_ID=xmlParserResponse.getValueOf("InputMessageId");
					PCLog.PCLogger.debug("Msg_ID: "+msg_ID);

					String return_code=xmlParserResponse.getValueOf("ReturnCode");
					PCLog.PCLogger.debug("Return_code: "+return_code);

					String return_desc=xmlParserResponse.getValueOf("ReturnDesc");
					PCLog.PCLogger.debug("Return_desc: "+return_desc);

					String mq_output_ref=xmlParserResponse.getValueOf("MemoPadSrlNum");
					PCLog.PCLogger.debug("Mq_output_ref: "+mq_output_ref);

					String integrationStatus = "Failure";
					if(return_code.equalsIgnoreCase("0000"))
					{
						integrationStatus  = "Success";
						PCLog.PCLogger.debug("IntegrationStatus: "+integrationStatus);
					}
					String columnName="MSG_ID, RETURN_CODE, RETURN_DESC, MQ_OUTPUT_REF, CALL_STATUS,DATE_TIME";
					String columnValues="'"+msg_ID+"','"+return_code+"','"+return_desc+"','"+mq_output_ref+"','"+integrationStatus+"','"+CommonMethods.getdateCurrentDateInSQLFormat()+"'";


					String whereClause="WI_NAME='"+wi_name+"' AND insertionorderid="+insertionorderid;

					String apUpdateInputXML=CommonMethods.apUpdateInput(cabinetName, sessionID, "USR_0_PC_ERR_HANDLING",
							columnName,columnValues, whereClause);
					PCLog.PCLogger.debug("APUpdateInputXML: "+apUpdateInputXML);

					String apUpdateOutputXML=PC.WFNGExecute(apUpdateInputXML,sJtsIp,iJtsPort,1);
					PCLog.PCLogger.debug("APUpdateOutputXML: "+apUpdateOutputXML);

				    XMLParser apUpdateXMLParser= new XMLParser(apUpdateOutputXML);
				    String apUpdateMainCode = apUpdateXMLParser.getValueOf("MainCode");
				    PCLog.PCLogger.debug("APUpdateMainCode: "+apUpdateMainCode);
				    if(apUpdateMainCode.equalsIgnoreCase("0"))
				    {
				    	PCLog.PCLogger.debug("APUpdate Successful for USR_0_PC_ERR_HANDLING: "+apUpdateMainCode);
				    }
					if(!integrationStatus.equalsIgnoreCase("Success"))
					{
						call_status_fail_count+=1;

					}
				}

				PCLog.PCLogger.debug("Call_status_fail_count: "+call_status_fail_count);
				if(call_status_fail_count > 0)
					DesStatus="Failure";
				else
					DesStatus="Success";

			}
			return DesStatus;
		}
		catch(Exception e)
		{
			return "";
		}

	}

	private String socketConnection(String cabinetName,String sessionID,
			String sJtsIp, String iJtsPort ,String wi_name, String ws_name, String acc_number,String memopad,
			int connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap )
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

		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";

		StringBuilder finalXML = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>MEMOPAD_MAINTENANCE_REQ</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>UniqueMessageId123</MessageId>\n"+
				"<Extra1>REQ||SHELL.JOHN</Extra1>\n"+
				"<Extra2>"+DateExtra2+"</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<MemopadMaintenanceReq>\n"+
				"<BankId>RAK</BankId>\n"+
				"<CIFID></CIFID>\n"+
				"<ACNumber>"+acc_number+"</ACNumber>\n"+
				"<Operation>A</Operation>\n"+
				"<Topic>Profile Change</Topic>\n"+
				"<FuncCode>FT</FuncCode>\n"+
				"<Intent>F</Intent>\n"+
				"<Security>P</Security>\n"+
				"<MemoText>"+memopad.replace("<", "&lt;").replace(">", "&gt;").replace("&", "&amp;")+"</MemoText>\n"+
				"<ExceptionCode></ExceptionCode>\n"+
				"<FreeField1></FreeField1>\n"+
				"<FreeField2></FreeField2>\n"+
				"<FreeField3></FreeField3>\n"+
				"</MemopadMaintenanceReq>\n"+
				"</EE_EAI_MESSAGE>\n");

		try
		{
			PCLog.PCLogger.debug("sessionID "+ sessionID);

			socketServerIP=socketDetailsMap.get("SocketServerIP");
			PCLog.PCLogger.debug("SocketServerIP "+ socketServerIP);
			socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
			PCLog.PCLogger.debug("SocketServerPort "+ socketServerPort);

	   		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0))
	   		{

    			socket = new Socket(socketServerIP, socketServerPort);
    			socket.setSoTimeout(connection_timeout*1000);
    			out = socket.getOutputStream();
    			socketInputStream = socket.getInputStream();
    			dout = new DataOutputStream(out);
    			din = new DataInputStream(socketInputStream);
    			PCLog.PCLogger.debug("Dout " + dout);
    			PCLog.PCLogger.debug("Din " + din);

    			outputResponse = "";
    			inputRequest = getRequestXML( cabinetName,sessionID,wi_name, ws_name, CommonConnection.getUsername(), finalXML);

    			if (inputRequest != null && inputRequest.length() > 0)
    			{
    				int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
    				PCLog.PCLogger.debug("RequestLen: "+inputRequestLen + "");
    				inputRequest = inputRequestLen + "##8##;" + inputRequest;
    				PCLog.PCLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
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
    				PCLog.PCLogger.debug("OutputResponse: "+outputResponse);

    				if(!"".equalsIgnoreCase(outputResponse))
    					outputResponse = getResponseXML(cabinetName,sJtsIp,iJtsPort,sessionID,
    							wi_name,outputResponse,integrationWaitTime );
    				if(outputResponse.contains("&lt;"))
    				{
    					outputResponse=outputResponse.replaceAll("&lt;", "<");
    					outputResponse=outputResponse.replaceAll("&gt;", ">");
    				}
    			}
    			socket.close();

				outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

    			return outputResponse;

    		}
    		else
    		{
    			PCLog.PCLogger.debug("SocketServerIp and SocketServerPort is not maintained "+"");
    			PCLog.PCLogger.debug("SocketServerIp is not maintained "+	socketServerIP);
    			PCLog.PCLogger.debug(" SocketServerPort is not maintained "+	socketServerPort);
    			return "Socket Details not maintained";
    		}
		}
		catch (Exception e)
		{
			PCLog.PCLogger.debug("Exception Occured Mq_connection_CC"+e.getStackTrace());
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
			}catch(Exception e)
			{
				PCLog.PCLogger.debug("Final Exception Occured Mq_connection_CC"+e.getStackTrace());
				//printException(e);
			}
		}
	}
	private String getRequestXML(String cabinetName, String sessionID,
			String wi_name, String ws_name, String userName, StringBuilder final_XML)
	{
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_PC_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_XML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		PCLog.PCLogger.debug("GetRequestXML: "+ strBuff.toString());
		return strBuff.toString();
	}
	private String getResponseXML(String cabinetName,String sJtsIp,String iJtsPort, String
			sessionID, String wi_name,String message_ID, int integrationWaitTime)
	{

		String outputResponseXML="";
		try
		{
			String QueryString = "select OUTPUT_XML from NG_PC_XMLLOG_HISTORY with (nolock) where " +
					"MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";

			String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
			PCLog.PCLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=PC.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				PCLog.PCLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    PCLog.PCLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    PCLog.PCLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		PCLog.PCLogger.debug("OutputResponseXML: "+outputResponseXML);

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
			PCLog.PCLogger.debug("Exception occurred in outputResponseXML" + e.getMessage());
			PCLog.PCLogger.debug("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}
		return outputResponseXML;
	}
}

