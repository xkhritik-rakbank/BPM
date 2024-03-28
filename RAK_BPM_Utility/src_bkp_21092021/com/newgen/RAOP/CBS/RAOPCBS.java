/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP CBS
File Name				: RAOPCBS.java
Author 					: Sajan Soda
Date (DD/MM/YYYY)		: 15/06/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.RAOP.CBS;

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


public class RAOPCBS implements Runnable
{

	private static NGEjbClient ngEjbClientRAOPCBS;

	static Map<String, String> raopCBSConfigParamMap= new HashMap<String, String>();
	RAOPCBSIntegration objRAOPCBSIntegration=new RAOPCBSIntegration();
	@Override
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
		String Sig_Remarks = "";
		int integrationWaitTime=0;
		int socketConnectionTimeout=0;
		int sleepIntervalInMin=0;

		try
		{
			RAOPCBSLog.setLogger();
			ngEjbClientRAOPCBS = NGEjbClient.getSharedInstance();

			RAOPCBSLog.RAOPCBSLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			RAOPCBSLog.RAOPCBSLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				RAOPCBSLog.RAOPCBSLogger.error("Could not Read Config Properties [RAOP CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			RAOPCBSLog.RAOPCBSLogger.debug("Cabinet Name: " + cabinetName);



			jtsIP = CommonConnection.getJTSIP();
			RAOPCBSLog.RAOPCBSLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			RAOPCBSLog.RAOPCBSLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			RAOPCBSLog.RAOPCBSLogger.debug("SMSPort: " + smsPort);
			

			queueID = raopCBSConfigParamMap.get("queueID");
			RAOPCBSLog.RAOPCBSLogger.debug("QueueID: " + queueID);

			docDownloadPath=raopCBSConfigParamMap.get("FileDownloadPath");
			RAOPCBSLog.RAOPCBSLogger.debug("Doc Download path is "+docDownloadPath);

			socketConnectionTimeout=Integer.parseInt(raopCBSConfigParamMap.get("MQ_SOCKET_CONNECTION_TIMEOUT"));
			RAOPCBSLog.RAOPCBSLogger.debug("SocketConnectionTimeOut: "+socketConnectionTimeout);
			
			integrationWaitTime=Integer.parseInt(raopCBSConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			RAOPCBSLog.RAOPCBSLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(raopCBSConfigParamMap.get("SleepIntervalInMin"));
			RAOPCBSLog.RAOPCBSLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			volumeId=raopCBSConfigParamMap.get("VolumeID");
			RAOPCBSLog.RAOPCBSLogger.debug("Volume Id from config file is "+volumeId);

			siteId=raopCBSConfigParamMap.get("SiteID");
			RAOPCBSLog.RAOPCBSLogger.debug("site Id is "+siteId);
			
			Sig_Remarks=raopCBSConfigParamMap.get("DefaultSigntureRemarks");
			RAOPCBSLog.RAOPCBSLogger.debug("DefaultSigntureRemarks is "+Sig_Remarks);

			sessionID = CommonConnection.getSessionID(RAOPCBSLog.RAOPCBSLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				RAOPCBSLog.RAOPCBSLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					RAOPCBSLog.setLogger();
					RAOPCBSLog.RAOPCBSLogger.debug("RAOP CBS....");
					startRAOPCBSUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,socketConnectionTimeout,integrationWaitTime,sessionID,socketDetailsMap,docDownloadPath,volumeId,siteId,Sig_Remarks);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			RAOPCBSLog.RAOPCBSLogger.error("Exception Occurred in RAOP CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			RAOPCBSLog.RAOPCBSLogger.error("Exception Occurred in RAOP CBS : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "RAOP_CBS_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    raopCBSConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	private void startRAOPCBSUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int socketConnectionTimeout,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId,String Sig_Remarks)
	{
		final String ws_name="Core_System_Update";
		try
		{
			sessionID  = CommonConnection.getSessionID(RAOPCBSLog.RAOPCBSLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				RAOPCBSLog.RAOPCBSLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			RAOPCBSLog.RAOPCBSLogger.debug("Fetching all Workitems at core system update queue");
			System.out.println("Fetching all WIs at core system update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			RAOPCBSLog.RAOPCBSLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			RAOPCBSLog.RAOPCBSLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			RAOPCBSLog.RAOPCBSLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			RAOPCBSLog.RAOPCBSLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					RAOPCBSLog.RAOPCBSLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID="";
					processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					RAOPCBSLog.RAOPCBSLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					RAOPCBSLog.RAOPCBSLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID="";
					WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					RAOPCBSLog.RAOPCBSLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime="";
					entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					RAOPCBSLog.RAOPCBSLogger.debug("Current EntryDateTime: "+entryDateTime);

					ResponseBean objResponseBean=objRAOPCBSIntegration.RAOPCBSCifCreationIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,socketConnectionTimeout,integrationWaitTime, socketDetailsMap,docDownloadPath,volumeId,siteId,Sig_Remarks);

					String strIntegrationErrCode="";

					if("Success".equals(objResponseBean.getCifCreationReturnCode()) && "Success".equals(objResponseBean.getCifUpdateReturnCode())
							&& "Success".equals(objResponseBean.getAccountCreationReturnCode()) && "Success".equals(objResponseBean.getSignUploadReturnCode())
							&& "Success".equals(objResponseBean.getRiskScoreReturnCode()))
						strIntegrationErrCode="";
					else
						strIntegrationErrCode=ws_name;

					//checking if its an existing customer or not
					if("Y".equals(objResponseBean.getIsExistingCustomer()))
					{
						objResponseBean.setCifCreationReturnCode("NA");
					}
					String strMWErrorDesc = "MessageID: "+objResponseBean.getMsgID()+", Return Code: "+objResponseBean.getIntFailedCode()+", Return Desc: "+objResponseBean.getIntFailedReason();
					String attributesTag="<DECISION>"+objResponseBean.getIntegrationDecision()+"</DECISION>"
							+ "<CIF_NUMBER>"+objResponseBean.getCifNumber()+"</CIF_NUMBER>"
									+ "<ACCOUNTNO>"+objResponseBean.getAccNumber()+"</ACCOUNTNO>"
											+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</INTEGRATION_ERROR_RECEIVED>"
													//+ "<IBANNO>"+objResponseBean.getIbanNumber()+"</IBANNO>"
							+ "<CREATE_CIF_STATUS>"+objResponseBean.getCifCreationReturnCode()+"</CREATE_CIF_STATUS>"
									+ "<UPDATE_CIF_STATUS>"+objResponseBean.getCifUpdateReturnCode()+"</UPDATE_CIF_STATUS>"
											+ "<CREATE_ACCOUNT_STATUS>"+objResponseBean.getAccountCreationReturnCode()+"</CREATE_ACCOUNT_STATUS>"
													+ "<SIGNATURE_PUSH_STATUS>"+objResponseBean.getSignUploadReturnCode()+"</SIGNATURE_PUSH_STATUS>"
													+ "<RISK_SCORE_STATUSFROMUTIL>"+objResponseBean.getRiskScoreReturnCode()+"</RISK_SCORE_STATUSFROMUTIL>"
													+ "<FAILEDINTEGRATIONCALL>"+objResponseBean.getIntCallFailed()+"</FAILEDINTEGRATIONCALL>"
													+ "<MW_ERRORDESC>"+strMWErrorDesc+"</MW_ERRORDESC>";



					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

					RAOPCBSLog.RAOPCBSLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

					if("0".equals(getWorkItemMainCode))
					{
						RAOPCBSLog.RAOPCBSLogger.info("get Workitem call successfull for "+processInstanceID);

						String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
								processInstanceID,WorkItemID,attributesTag);
						RAOPCBSLog.RAOPCBSLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
								jtsPort,1);
						RAOPCBSLog.RAOPCBSLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

						String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
						if("0".equals(mainCodeAssignAtt.trim()))
						{
							String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
									processInstanceID,WorkItemID);

							RAOPCBSLog.RAOPCBSLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

							RAOPCBSLog.RAOPCBSLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
							RAOPCBSLog.RAOPCBSLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
							RAOPCBSLog.RAOPCBSLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

							if("0".equals(completeWorkitemMaincode))
							{
								//inserting into history table
								RAOPCBSLog.RAOPCBSLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Sussesfully with status "+objResponseBean.getIntegrationDecision());

								RAOPCBSLog.RAOPCBSLogger.debug("WorkItem moved to next Workstep.");

								SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								RAOPCBSLog.RAOPCBSLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								RAOPCBSLog.RAOPCBSLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								//Insert in WIHistory Table.

								String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+objResponseBean.getIntegrationDecision()+"','"+formattedEntryDatetime+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,"USR_0_RAOP_WIHISTORY");
								RAOPCBSLog.RAOPCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
										jtsPort,1);
								RAOPCBSLog.RAOPCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								RAOPCBSLog.RAOPCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									RAOPCBSLog.RAOPCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
									RAOPCBSLog.RAOPCBSLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									RAOPCBSLog.RAOPCBSLogger.error("ApInsert failed: "+apInsertMaincode);
								}
							}
							else
							{
								RAOPCBSLog.RAOPCBSLogger.error("Error in completeWI call for "+processInstanceID);
							}
						}
						else
						{
							RAOPCBSLog.RAOPCBSLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
						}


					}
					else
					{
						RAOPCBSLog.RAOPCBSLogger.error("Error in getWI call for WI "+processInstanceID);
					}

				}
			}

		}
		catch(Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			RAOPCBSLog.RAOPCBSLogger.error("Exception Occurred in RAOP CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}

	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		RAOPCBSLog.RAOPCBSLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientRAOPCBS.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("Exception Occured in WF NG Execute : "
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
			RAOPCBSLog.RAOPCBSLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'RAOP' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			RAOPCBSLog.RAOPCBSLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			RAOPCBSLog.RAOPCBSLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			RAOPCBSLog.RAOPCBSLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			RAOPCBSLog.RAOPCBSLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				RAOPCBSLog.RAOPCBSLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				RAOPCBSLog.RAOPCBSLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				RAOPCBSLog.RAOPCBSLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}


}
