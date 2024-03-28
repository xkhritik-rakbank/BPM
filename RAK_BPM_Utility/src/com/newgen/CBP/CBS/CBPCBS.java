/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: CBP CBS
File Name				: CBPCBS.java
Author 					: Sajan Soda
Date (DD/MM/YYYY)		: 09/09
/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.CBP.CBS;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class CBPCBS implements Runnable
{
	private String CBP_WIHISTORY="USR_0_CBP_WIHISTORY";
	
	private static NGEjbClient ngEjbClientCBPCBS;
	static Map<String, String> CBPCBSConfigParamMap= new HashMap<String, String>();
	CBPCBSIntegration objCBPCBSIntegration=new CBPCBSIntegration();
	public void run()
	{
		String sessionID = "";
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		String smsPort = "";
		String queueID = "";
		String volumeId="";
		String siteId="";
		String docDownloadPath="";
		int integrationWaitTime=0;
		int socketConnectionTimeout=0;
		int sleepIntervalInMin=0;

		try
		{
			CBPCBSLog.setLogger();
			ngEjbClientCBPCBS = NGEjbClient.getSharedInstance();

			CBPCBSLog.CBPCBSLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CBPCBSLog.CBPCBSLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				CBPCBSLog.CBPCBSLogger.error("Could not Read Config Properties [CBP CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			CBPCBSLog.CBPCBSLogger.debug("Cabinet Name: " + cabinetName);



			jtsIP = CommonConnection.getJTSIP();
			CBPCBSLog.CBPCBSLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CBPCBSLog.CBPCBSLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			CBPCBSLog.CBPCBSLogger.debug("SMSPort: " + smsPort);
			

			queueID = CBPCBSConfigParamMap.get("queueID");
			CBPCBSLog.CBPCBSLogger.debug("QueueID: " + queueID);

			docDownloadPath=CBPCBSConfigParamMap.get("FileDownloadPath");
			CBPCBSLog.CBPCBSLogger.debug("Doc Download path is "+docDownloadPath);

			socketConnectionTimeout=Integer.parseInt(CBPCBSConfigParamMap.get("MQ_SOCKET_CONNECTION_TIMEOUT"));
			CBPCBSLog.CBPCBSLogger.debug("SocketConnectionTimeOut: "+socketConnectionTimeout);
			
			integrationWaitTime=Integer.parseInt(CBPCBSConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			CBPCBSLog.CBPCBSLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(CBPCBSConfigParamMap.get("SleepIntervalInMin"));
			CBPCBSLog.CBPCBSLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			volumeId=CBPCBSConfigParamMap.get("VolumeID");
			CBPCBSLog.CBPCBSLogger.debug("Volume Id from config file is "+volumeId);

			siteId=CBPCBSConfigParamMap.get("SiteID");
			CBPCBSLog.CBPCBSLogger.debug("site Id is "+siteId);

			sessionID = CommonConnection.getSessionID(CBPCBSLog.CBPCBSLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				CBPCBSLog.CBPCBSLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					CBPCBSLog.setLogger();
					CBPCBSLog.CBPCBSLogger.debug("CMP CBS....");
					startCMPCBSUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,socketConnectionTimeout,integrationWaitTime,sessionID,socketDetailsMap,docDownloadPath,volumeId,siteId);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			CBPCBSLog.CBPCBSLogger.error("Exception Occurred in CMP CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CBPCBSLog.CBPCBSLogger.error("Exception Occurred in CMP CBS : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "CBP_CBS_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    CBPCBSConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	
	
	
	private void startCMPCBSUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int socketConnectionTimeout,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId)
	{
		final String ws_name="Core_System_Update";
		try
		{
			sessionID  = CommonConnection.getSessionID(CBPCBSLog.CBPCBSLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				CBPCBSLog.CBPCBSLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			CBPCBSLog.CBPCBSLogger.debug("Fetching all Workitems at core system update queue");
			System.out.println("Fetching all WIs at core system update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			CBPCBSLog.CBPCBSLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			CBPCBSLog.CBPCBSLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			CBPCBSLog.CBPCBSLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			CBPCBSLog.CBPCBSLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					CBPCBSLog.CBPCBSLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					CBPCBSLog.CBPCBSLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					CBPCBSLog.CBPCBSLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					CBPCBSLog.CBPCBSLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					CBPCBSLog.CBPCBSLogger.debug("Current EntryDateTime: "+entryDateTime);
					
					CBPCBSIntegration objCBPCBSIntegration=new CBPCBSIntegration();

					String strResponseCustUpdate=objCBPCBSIntegration.CBPCBSCustomerUpdateIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,socketConnectionTimeout,integrationWaitTime, socketDetailsMap,docDownloadPath,volumeId,siteId);

					CBPCBSLog.CBPCBSLogger.debug("The response XML for customer update is "+strResponseCustUpdate);
					
					XMLParser parserForCustUpdate=new XMLParser(strResponseCustUpdate);
					String strDecision="";
					String strErrorDescription="";
					String strErrorCode="";
					String strMessageId="";
					String strFailedIntegrationCall="";
					String strIntegrationErrorReceived="";
					
					if("0000".equals(parserForCustUpdate.getValueOf("ReturnCode")))
						strDecision="Success";
					else{
						strDecision="Failure";
						if(strResponseCustUpdate.contains("<ReturnDesc>"))
							strErrorDescription=parserForCustUpdate.getValueOf("ReturnDesc");
						else if(strResponseCustUpdate.contains("<Description>"))
							strErrorDescription=parserForCustUpdate.getValueOf("Description");
							
						if(strResponseCustUpdate.contains("<ReturnCode>"))
							strErrorCode=parserForCustUpdate.getValueOf("ReturnCode");
						if(strResponseCustUpdate.contains("<MessageId>"))
							strMessageId=parserForCustUpdate.getValueOf("MessageId");
							
						strFailedIntegrationCall="CUSTOMER_UPDATE_REQ";
						strIntegrationErrorReceived="Core_System_Update";
					}
					
					String attributesTag = "";
					if (strDecision.equalsIgnoreCase("Success"))
					{
						attributesTag="<DECISION>"+strDecision+"</DECISION> \n"
							+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrorReceived+"</INTEGRATION_ERROR_RECEIVED> \n"
							+ "<FAILEDINTEGRATIONCALL>"+" "+"</FAILEDINTEGRATIONCALL> \n"
							+ "<MW_ERRORDESC>"+" "+"</MW_ERRORDESC>";
					}
					else
					{
						attributesTag="<DECISION>"+strDecision+"</DECISION> \n"
							+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrorReceived+"</INTEGRATION_ERROR_RECEIVED> \n"
							+ "<FAILEDINTEGRATIONCALL>"+strFailedIntegrationCall+"</FAILEDINTEGRATIONCALL> \n"
							+ "<MW_ERRORDESC>MessageId: "+strMessageId+", Return Code: "+strErrorCode+", Return Desc: "+strErrorDescription+"</MW_ERRORDESC>";
					}
					CBPCBSLog.CBPCBSLogger.debug("The attribute Tags are "+attributesTag);



					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

					CBPCBSLog.CBPCBSLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

					if("0".equals(getWorkItemMainCode))
					{
						CBPCBSLog.CBPCBSLogger.info("get Workitem call successfull for "+processInstanceID);

						String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
								processInstanceID,WorkItemID,attributesTag);
						CBPCBSLog.CBPCBSLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
								jtsPort,1);
						CBPCBSLog.CBPCBSLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

						String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
						if("0".equals(mainCodeAssignAtt.trim()))
						{
							String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
									processInstanceID,WorkItemID);

							CBPCBSLog.CBPCBSLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

							CBPCBSLog.CBPCBSLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
							CBPCBSLog.CBPCBSLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
							CBPCBSLog.CBPCBSLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

							if("0".equals(completeWorkitemMaincode))
							{
								//inserting into history table
								CBPCBSLog.CBPCBSLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								CBPCBSLog.CBPCBSLogger.debug(processInstanceID + "Complete Succesfully with status "+strDecision);

								CBPCBSLog.CBPCBSLogger.debug("WorkItem moved to next Workstep.");

								SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								CBPCBSLog.CBPCBSLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								CBPCBSLog.CBPCBSLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								//Insert in WIHistory Table.

								String columnNames="WI_NAME,ACTION_DATE_TIME,WS_NAME,USER_NAME,DECISION,ENTRY_DATE_TIME";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+strDecision+"','"+formattedEntryDatetime+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,CBP_WIHISTORY);
								CBPCBSLog.CBPCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
										jtsPort,1);
								CBPCBSLog.CBPCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								CBPCBSLog.CBPCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									CBPCBSLog.CBPCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
									CBPCBSLog.CBPCBSLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									CBPCBSLog.CBPCBSLogger.error("ApInsert failed: "+apInsertMaincode);
								}
							}
							else
							{
								CBPCBSLog.CBPCBSLogger.error("Error in completeWI call for "+processInstanceID);
							}
						}
						else
						{
							CBPCBSLog.CBPCBSLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
						}


					}
					else
					{
						CBPCBSLog.CBPCBSLogger.error("Error in getWI call for WI "+processInstanceID);
					}

				}
			}

		}
		catch(Exception e)
		{
			CBPCBSLog.CBPCBSLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CBPCBSLog.CBPCBSLogger.error("Exception Occurred in CMP CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}
	
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		CBPCBSLog.CBPCBSLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientCBPCBS.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			CBPCBSLog.CBPCBSLogger.error("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
			String sessionID )
	{
		HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

		try
		{
			CBPCBSLog.CBPCBSLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'CBP' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			CBPCBSLog.CBPCBSLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			CBPCBSLog.CBPCBSLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			CBPCBSLog.CBPCBSLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			CBPCBSLog.CBPCBSLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				CBPCBSLog.CBPCBSLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				CBPCBSLog.CBPCBSLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				CBPCBSLog.CBPCBSLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			CBPCBSLog.CBPCBSLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
}
