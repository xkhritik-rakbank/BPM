/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: DAC CBS
File Name				: DACCBS.java
Author 					: Sivakumar P
Date (DD/MM/YYYY)		: 26/07/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.DAC.CBS;

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

public class DACCBS implements Runnable
{
	private String DAC_WIHISTORY="USR_0_DAC_WIHISTORY";
	
	private static NGEjbClient ngEjbClientDACCBS;
	static Map<String, String> DACCBSConfigParamMap= new HashMap<String, String>();
	DACCBSIntegration objDACCBSIntegration=new DACCBSIntegration();
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
		int sleepIntervalInMin=0;

		try
		{
			DACCBSLog.setLogger();
			ngEjbClientDACCBS = NGEjbClient.getSharedInstance();

			DACCBSLog.DACCBSLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			DACCBSLog.DACCBSLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				DACCBSLog.DACCBSLogger.error("Could not Read Config Properties [DAC CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			DACCBSLog.DACCBSLogger.debug("Cabinet Name: " + cabinetName);



			jtsIP = CommonConnection.getJTSIP();
			DACCBSLog.DACCBSLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			DACCBSLog.DACCBSLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			DACCBSLog.DACCBSLogger.debug("SMSPort: " + smsPort);
			

			queueID = DACCBSConfigParamMap.get("queueID");
			DACCBSLog.DACCBSLogger.debug("QueueID: " + queueID);

			docDownloadPath=DACCBSConfigParamMap.get("FileDownloadPath");
			DACCBSLog.DACCBSLogger.debug("Doc Download path is "+docDownloadPath);

			integrationWaitTime=Integer.parseInt(DACCBSConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			DACCBSLog.DACCBSLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(DACCBSConfigParamMap.get("SleepIntervalInMin"));
			DACCBSLog.DACCBSLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			volumeId=DACCBSConfigParamMap.get("VolumeID");
			DACCBSLog.DACCBSLogger.debug("Volume Id from config file is "+volumeId);

			siteId=DACCBSConfigParamMap.get("SiteID");
			DACCBSLog.DACCBSLogger.debug("site Id is "+siteId);

			sessionID = CommonConnection.getSessionID(DACCBSLog.DACCBSLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				DACCBSLog.DACCBSLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					DACCBSLog.setLogger();
					DACCBSLog.DACCBSLogger.debug("DAC CBS....");
					startDACCBSUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,sleepIntervalInMin,integrationWaitTime,sessionID,socketDetailsMap,docDownloadPath,volumeId,siteId);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			DACCBSLog.DACCBSLogger.error("Exception Occurred in DAC CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DACCBSLog.DACCBSLogger.error("Exception Occurred in DAC CBS : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "DAC_CBS_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    DACCBSConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	
	
	
	private void startDACCBSUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId)
	{
		final String ws_name="Core_System_Update";
		try
		{
			sessionID  = CommonConnection.getSessionID(DACCBSLog.DACCBSLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				DACCBSLog.DACCBSLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			DACCBSLog.DACCBSLogger.debug("Fetching all Workitems at core system update queue");
			System.out.println("Fetching all WIs at core system update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			DACCBSLog.DACCBSLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			DACCBSLog.DACCBSLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			DACCBSLog.DACCBSLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			DACCBSLog.DACCBSLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					DACCBSLog.DACCBSLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					DACCBSLog.DACCBSLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					DACCBSLog.DACCBSLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					DACCBSLog.DACCBSLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					DACCBSLog.DACCBSLogger.debug("Current EntryDateTime: "+entryDateTime);

					ResponseBean objResponseBean=objDACCBSIntegration.DACCBSCustomerCreationIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime, socketDetailsMap,docDownloadPath,volumeId,siteId);

					String strIntegrationErrCode="";

					if("Success".equals(objResponseBean.getCustomerCreationReturnCode()))
						strIntegrationErrCode="";
					else
						strIntegrationErrCode=ws_name;

					//checking if its an existing customer or not
					
					String attributesTag="<DECISION>"+objResponseBean.getIntegrationDecision()+"</DECISION>"
							+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</INTEGRATION_ERROR_RECEIVED>"
							+ "<CREATE_CUSTOMER_STATUS>"+objResponseBean.getCustomerCreationReturnCode()+"</CREATE_CUSTOMER_STATUS>"
							+ "<DCR_REQUEST_ID>"+objResponseBean.getDACRequestId()+"</DCR_REQUEST_ID>";



					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

					DACCBSLog.DACCBSLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

					if("0".equals(getWorkItemMainCode))
					{
						DACCBSLog.DACCBSLogger.info("get Workitem call successfull for "+processInstanceID);

						String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
								processInstanceID,WorkItemID,attributesTag);
						DACCBSLog.DACCBSLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
								jtsPort,1);
						DACCBSLog.DACCBSLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

						String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
						if("0".equals(mainCodeAssignAtt.trim()))
						{
							String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
									processInstanceID,WorkItemID);

							DACCBSLog.DACCBSLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

							DACCBSLog.DACCBSLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
							DACCBSLog.DACCBSLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
							DACCBSLog.DACCBSLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

							if("0".equals(completeWorkitemMaincode))
							{
								//inserting into history table
								DACCBSLog.DACCBSLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+objResponseBean.getIntegrationDecision());

								DACCBSLog.DACCBSLogger.debug("WorkItem moved to next Workstep.");

								SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								DACCBSLog.DACCBSLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								DACCBSLog.DACCBSLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								//Insert in WIHistory Table.
								String Remarks = "ReturnCode: "+objResponseBean.getMWErrorCode()+", ReturnDesc: "+objResponseBean.getMWErrorDesc();
								if (objResponseBean.getMWErrorCode().equalsIgnoreCase("0000"))
									Remarks = Remarks+", DCR Request ID: "+objResponseBean.getDACRequestId();
									
								String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+objResponseBean.getIntegrationDecision()+"','"+formattedEntryDatetime+"','"+Remarks+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,DAC_WIHISTORY);
								DACCBSLog.DACCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
										jtsPort,1);
								DACCBSLog.DACCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								DACCBSLog.DACCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									DACCBSLog.DACCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
									DACCBSLog.DACCBSLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									DACCBSLog.DACCBSLogger.error("ApInsert failed: "+apInsertMaincode);
								}
							}
							else
							{
								DACCBSLog.DACCBSLogger.error("Error in completeWI call for "+processInstanceID);
							}
						}
						else
						{
							DACCBSLog.DACCBSLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
						}


					}
					else
					{
						DACCBSLog.DACCBSLogger.error("Error in getWI call for WI "+processInstanceID);
					}

				}
			}

		}
		catch(Exception e)
		{
			DACCBSLog.DACCBSLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DACCBSLog.DACCBSLogger.error("Exception Occurred in DAC CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}
	
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		DACCBSLog.DACCBSLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientDACCBS.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			DACCBSLog.DACCBSLogger.error("Exception Occured in WF NG Execute : "
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
			DACCBSLog.DACCBSLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'DAC' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			DACCBSLog.DACCBSLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			DACCBSLog.DACCBSLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			DACCBSLog.DACCBSLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			DACCBSLog.DACCBSLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				DACCBSLog.DACCBSLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				DACCBSLog.DACCBSLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				DACCBSLog.DACCBSLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			DACCBSLog.DACCBSLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
}
