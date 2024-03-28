package com.newgen.NBTL.StatusUpdate;

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

import com.newgen.NBTL.StatusUpdate.NBTL_StatusUpdateIntegration;
import com.newgen.NBTL.StatusUpdate.NBTL_StatusUpdate_Log;
import com.newgen.NBTL.StatusUpdate.ResponseBean;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class NBTL_StatusUpdate implements Runnable {

	private String NBTL_WIHISTORY="USR_0_NBTL_WIHISTORY";
	
	private static NGEjbClient ngEjbClientNBTLStatusUpdate;
	static Map<String, String> NBTLStatusUpdateConfigParamMap= new HashMap<String, String>();
	NBTL_StatusUpdateIntegration objNBTLStatusUpdateIntegration=new NBTL_StatusUpdateIntegration();
	public void run()
	{
		String sessionID = "";
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		String smsPort = "";
		String queueID = "";
		int integrationWaitTime=0;
		int sleepIntervalInMin=0;

		try
		{
			NBTL_StatusUpdate_Log.setLogger();
			ngEjbClientNBTLStatusUpdate = NGEjbClient.getSharedInstance();

			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Could not Read Config Properties [NBTL StatusUpdate]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SMSPort: " + smsPort);
			

			queueID = NBTLStatusUpdateConfigParamMap.get("queueID");
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("QueueID: " + queueID);

			integrationWaitTime=Integer.parseInt(NBTLStatusUpdateConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(NBTLStatusUpdateConfigParamMap.get("SleepIntervalInMin"));
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					NBTL_StatusUpdate_Log.setLogger();
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("NBTL StatusUpdate....");
					startNBTL_StatusUpdateUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,sleepIntervalInMin,integrationWaitTime,sessionID,socketDetailsMap);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception Occurred in NBTL StatusUpdate : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception Occurred in NBTL StatusUpdate : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "NBTL_StatusUpdate_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    NBTLStatusUpdateConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	
	
	
	private void startNBTL_StatusUpdateUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap)
	{
		final String ws_name="Status_Update";
		try
		{
			sessionID  = CommonConnection.getSessionID(NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Fetching all Workitems at Status_Update queue");
			System.out.println("Fetching all WIs at Status_Update update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Current EntryDateTime: "+entryDateTime);

					ResponseBean objResponseBean=objNBTLStatusUpdateIntegration.NBTL_StatusUpdate_Integration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime, socketDetailsMap);
					String strIntegrationErrCode="";
					String strIntegrationErrRemarks="";

					if("Success".equals(objResponseBean.getStatusUpdateReturnCode()))
					{
						strIntegrationErrCode="Success";
						strIntegrationErrRemarks="Status Update Successfull";
						/*strIntegrationErrCode="Failure";
						strIntegrationErrRemarks="Failure in Status Update Integration";*/
					}	
					else
					{
						strIntegrationErrCode="Failure";
						strIntegrationErrRemarks="Failure in Status Update Integration";
					}
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("objResponseBean.getIntegrationDecision() "+objResponseBean.getIntegrationDecision());
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("strIntegrationErrCode "+strIntegrationErrCode);
					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("strIntegrationErrRemarks "+strIntegrationErrRemarks);
					
					String attributesTag="<Decision>"+strIntegrationErrCode+"</Decision>"
							+ "<Remarks>"+strIntegrationErrRemarks+"</Remarks>"
							+ "<STATUS_UPDATE_INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</STATUS_UPDATE_INTEGRATION_ERROR_RECEIVED>";

					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

					NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

					if("0".equals(getWorkItemMainCode))
					{
						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.info("get Workitem call successfull for "+processInstanceID);

						String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
								processInstanceID,WorkItemID,attributesTag);
						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
								jtsPort,1);
						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

						String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
						if("0".equals(mainCodeAssignAtt.trim()))
						{
							String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
									processInstanceID,WorkItemID);

							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

							if("0".equals(completeWorkitemMaincode))
							{
								//inserting into history table
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+objResponseBean.getIntegrationDecision());

								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("WorkItem moved to next Workstep.");

								SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								//Insert in WIHistory Table.
									
								String columnNames="WINAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+strIntegrationErrCode+"','"+formattedEntryDatetime+"','"+strIntegrationErrRemarks+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,NBTL_WIHISTORY);
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
										jtsPort,1);
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("ApInsert successful: "+apInsertMaincode);
									NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("ApInsert failed: "+apInsertMaincode);
								}
							}
							else
							{
								NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Error in completeWI call for "+processInstanceID);
							}
						}
						else
						{
							NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
						}


					}
					else
					{
						NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Error in getWI call for WI "+processInstanceID);
					}

				}
			}

		}
		catch(Exception e)
		{
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception Occurred in NBTL StatusUpdate Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}
	
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientNBTLStatusUpdate.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception Occured in WF NG Execute : "
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
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'NBTL' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			NBTL_StatusUpdate_Log.NBTLStatusUpdateLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
}
