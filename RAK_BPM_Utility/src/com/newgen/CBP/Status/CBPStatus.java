/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: CBP Status
File Name				: CBPStatus.java
Author 					: Sajan Soda
Date (DD/MM/YYYY)		: 16/09/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.CBP.Status;


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

import com.newgen.common.CommonMethods;
import com.newgen.common.CommonConnection;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class CBPStatus implements Runnable{
	
	private static NGEjbClient ngEjbClientCBPStatus;

	static Map<String, String> cbpStatusConfigParamMap= new HashMap<String, String>();
	
	public void run()
	{
		String sessionID = "";
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		String queueID = "";
		int socketConnectionTimeout=0;
		int integrationWaitTime=0;
		int sleepIntervalInMin=0;

		try
		{
			CBPStatusLog.setLogger();
			ngEjbClientCBPStatus = NGEjbClient.getSharedInstance();

			CBPStatusLog.CBPStatusLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CBPStatusLog.CBPStatusLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				CBPStatusLog.CBPStatusLogger.error("Could not Read Config Properties [CBPStatus]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			CBPStatusLog.CBPStatusLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			CBPStatusLog.CBPStatusLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CBPStatusLog.CBPStatusLogger.debug("JTSPORT: " + jtsPort);

			queueID = cbpStatusConfigParamMap.get("queueID");
			CBPStatusLog.CBPStatusLogger.debug("QueueID: " + queueID);

			socketConnectionTimeout=Integer.parseInt(cbpStatusConfigParamMap.get("MQ_SOCKET_CONNECTION_TIMEOUT"));
			CBPStatusLog.CBPStatusLogger.debug("SocketConnectionTimeOut: "+socketConnectionTimeout);

			integrationWaitTime=Integer.parseInt(cbpStatusConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			CBPStatusLog.CBPStatusLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(cbpStatusConfigParamMap.get("SleepIntervalInMin"));
			CBPStatusLog.CBPStatusLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);


			sessionID = CommonConnection.getSessionID(CBPStatusLog.CBPStatusLogger, false);

			if(sessionID.trim().equalsIgnoreCase(""))
			{
				CBPStatusLog.CBPStatusLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				CBPStatusLog.CBPStatusLogger.debug("Session ID found: " + sessionID);
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while(true)
				{
					CBPStatusLog.setLogger();
					CBPStatusLog.CBPStatusLogger.debug("CBP Status...123.");
					startCBPStatusUtility(cabinetName, jtsIP, jtsPort,sessionID,
							queueID,socketConnectionTimeout, integrationWaitTime,socketDetailsMap);
							System.out.println("No More workitems to Process, Sleeping!");
							Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}

		catch(Exception e)
		{
			e.printStackTrace();
			CBPStatusLog.CBPStatusLogger.error("Exception Occurred in CMP CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CBPStatusLog.CBPStatusLogger.error("Exception Occurred in CMP CBS : "+result);
		}
	}
	
	private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
			String sessionID)
	{
		HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

		try
		{
			CBPStatusLog.CBPStatusLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'CBP' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			CBPStatusLog.CBPStatusLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			CBPStatusLog.CBPStatusLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			CBPStatusLog.CBPStatusLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			CBPStatusLog.CBPStatusLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				CBPStatusLog.CBPStatusLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				CBPStatusLog.CBPStatusLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				CBPStatusLog.CBPStatusLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			CBPStatusLog.CBPStatusLogger.debug("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		CBPStatusLog.CBPStatusLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientCBPStatus.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			CBPStatusLog.CBPStatusLogger.debug("Exception Occured in WF NG Execute : "+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "CBP_Status_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			  {
			    String name = (String) names.nextElement();
			    cbpStatusConfigParamMap.put(name, p.getProperty(name));
			  }
		    }
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}
	private void startCBPStatusUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,
			String queueID, int socketConnectionTimeOut, int integrationWaitTime,
			HashMap<String, String> socketDetailsMap)
	{
		final String ws_name="YAP_Status_Update";

		try
		{
			//Validate Session ID
			sessionId  = CommonConnection.getSessionID(CBPStatusLog.CBPStatusLogger, false);

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
			{
				CBPStatusLog.CBPStatusLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}

			//Fetch all Work-Items on given queueID.
			CBPStatusLog.CBPStatusLogger.debug("Fetching all Workitems on CMP_Status_Update queue");
			System.out.println("Fetching all Workitems on CMP_Status_Update queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			CBPStatusLog.CBPStatusLogger.debug("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			CBPStatusLog.CBPStatusLogger.debug("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			CBPStatusLog.CBPStatusLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			CBPStatusLog.CBPStatusLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			CBPStatusLog.CBPStatusLogger.debug("Number of workitems retrieved on CMP_Status_Update: "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on CMP_Status_Update: "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					CBPStatusLog.CBPStatusLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					CBPStatusLog.CBPStatusLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					CBPStatusLog.CBPStatusLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					CBPStatusLog.CBPStatusLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					CBPStatusLog.CBPStatusLogger.debug("Current EntryDateTime: "+entryDateTime);



					//String extTabDBQuery = "SELECT PREV_WS, WINAME, YAP_STATUS, YAP_REJECT_CODE, YAP_REJECT_REASON, DECISION, CURRENT_WS" +
							//" FROM RB_CMP_EXTTABLE A WITH (NOLOCK) , WFINSTRUMENTTABLE B WITH (NOLOCK) " +
							//"WHERE A.WINAME = B.PROCESSINSTANCEID  AND B.WORKITEMID = '1' " +
							//"AND A.WINAME = '"+processInstanceID+"'";
					
					String extTabDBQuery = "SELECT PREV_WS, WI_NAME, DECISION, CURRENT_WS,"
							+ "Dec_OPS_Doc_Checker,Dec_Err_Han_Data_Ent_Chkr,Dec_Error_Handling,MW_ERRORCODE,MW_ERRORDESC, YAP_STATUS, YAP_REJECT_REASON, YAP_REMARKS " +
									" FROM RB_CBP_EXTTABLE A WITH (NOLOCK) , WFINSTRUMENTTABLE B WITH (NOLOCK) " +
									"WHERE A.WI_NAME = B.PROCESSINSTANCEID  AND B.WORKITEMID = '1' " +
									"AND A.WI_NAME = '"+processInstanceID+"'";

					String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(extTabDBQuery,cabinetName, sessionId);
					CBPStatusLog.CBPStatusLogger.debug("extTabDataIPXML: "+ extTabDataIPXML);
					String extTabDataOPXML = WFNGExecute(extTabDataIPXML,sJtsIp,iJtsPort,1);
					CBPStatusLog.CBPStatusLogger.debug("extTabDataOPXML: "+ extTabDataOPXML);

					XMLParser xmlParserextTabData= new XMLParser(extTabDataOPXML);


					if(xmlParserextTabData.getValueOf("MainCode").equalsIgnoreCase("0")&& Integer.parseInt(xmlParserextTabData.getValueOf("TotalRetrieved"))>0)
					{
						String xmlDataExtTab=xmlParserextTabData.getNextValueOf("Record");
						xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");


						XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);

						String CurrWS = xmlParserExtTabDataRecord.getValueOf("CURRENT_WS");
						String winame = xmlParserExtTabDataRecord.getValueOf("WI_NAME");
						String decOPSDocChecker = xmlParserExtTabDataRecord.getValueOf("Dec_OPS_Doc_Checker");
						String decErrHandDataEntChecker= xmlParserExtTabDataRecord.getValueOf("Dec_Err_Han_Data_Ent_Chkr");
						String decErrorHandling = xmlParserExtTabDataRecord.getValueOf("Error_Handling");
					//	String Dec = xmlParserExtTabDataRecord.getValueOf("DECISION");


						HashMap<String, String> ExtTabDataMap = new HashMap<String, String>();
						ExtTabDataMap.put("WINAME", winame);
						ExtTabDataMap.put("DEC_OPS_DOC", decOPSDocChecker);
						ExtTabDataMap.put("DEC_ERR_ENTRY_Checker", decErrHandDataEntChecker);
						ExtTabDataMap.put("DEC_ERR_HANDLING", decErrorHandling);
						ExtTabDataMap.put("Error_Code",xmlParserExtTabDataRecord.getValueOf("MW_ERRORCODE"));
						ExtTabDataMap.put("Error_Desc",xmlParserExtTabDataRecord.getValueOf("MW_ERRORDESC"));
						ExtTabDataMap.put("YAP_STATUS",xmlParserExtTabDataRecord.getValueOf("YAP_STATUS"));
						ExtTabDataMap.put("YAP_REJECT_REASON",xmlParserExtTabDataRecord.getValueOf("YAP_REJECT_REASON"));
						ExtTabDataMap.put("YAP_REMARKS",xmlParserExtTabDataRecord.getValueOf("YAP_REMARKS"));
						

						//CMP Integration Call
						String decisionValue="";

						CBPIntegration objCBPIntegration= new CBPIntegration();
						String integrationStatus=objCBPIntegration.customIntegration(cabinetName,sessionId, sJtsIp,
								iJtsPort,processInstanceID,ws_name,integrationWaitTime,socketConnectionTimeOut,  socketDetailsMap, ExtTabDataMap);

						String[] splitintstatus =integrationStatus.split("~");


						String ErrDesc = "MessageId: "+splitintstatus[2] + ", Return Code: "+splitintstatus[0] +", Return Desc: "+ splitintstatus[1];
						String attributesTag;

						if (splitintstatus[0].equals("0000"))
						{
							decisionValue = "Success";
							CBPStatusLog.CBPStatusLogger.debug("Decision" +decisionValue);
							 attributesTag="<DECISION>"+decisionValue+"</DECISION>" + "<INTEGRATION_ERROR_RECEIVED>" + "" + "</INTEGRATION_ERROR_RECEIVED>";
						}
						else
						{
							decisionValue = "Failure";
							CBPStatusLog.CBPStatusLogger.debug("Decision" +decisionValue);
							attributesTag="<DECISION>"+decisionValue+"</DECISION>" + "<INTEGRATION_ERROR_RECEIVED>" +  ws_name + "</INTEGRATION_ERROR_RECEIVED>"+"<FAILEDINTEGRATIONCALL>NOTIFY_SR_STATUS</FAILEDINTEGRATIONCALL>" + "<MW_ERRORDESC>"
							+ErrDesc+ "</MW_ERRORDESC>" ;

						}


						//To be modified according to output of Integration Call.

					//Lock Workitem.
					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionId, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,sJtsIp,iJtsPort,1);
					CBPStatusLog.CBPStatusLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
					CBPStatusLog.CBPStatusLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

					if (getWorkItemMainCode.trim().equals("0"))
					{
						CBPStatusLog.CBPStatusLogger.debug("WMgetWorkItemCall Successful: "+getWorkItemMainCode);

						String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionId,
								processInstanceID,WorkItemID,attributesTag);
						CBPStatusLog.CBPStatusLogger.debug("InputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,sJtsIp,
								iJtsPort,1);

						CBPStatusLog.CBPStatusLogger.debug("OutputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
						String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
						CBPStatusLog.CBPStatusLogger.debug("AssignWorkitemAttribute MainCode: "+assignWorkitemAttributeMainCode);

						if(assignWorkitemAttributeMainCode.trim().equalsIgnoreCase("0"))
						{
							CBPStatusLog.CBPStatusLogger.debug("AssignWorkitemAttribute Successful: "+assignWorkitemAttributeMainCode);

							String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionId,
									processInstanceID,WorkItemID);
							CBPStatusLog.CBPStatusLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,sJtsIp,iJtsPort,1);
							CBPStatusLog.CBPStatusLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);


							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");

							CBPStatusLog.CBPStatusLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);


							//Move Workitem to next Workstep

							if (completeWorkitemMaincode.trim().equalsIgnoreCase("0"))
							{
								CBPStatusLog.CBPStatusLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+decisionValue);

								CBPStatusLog.CBPStatusLogger.debug("WorkItem moved to next Workstep.");

								SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								CBPStatusLog.CBPStatusLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								CBPStatusLog.CBPStatusLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								//Insert in WIHistory Table.
								String columnNames="WI_NAME,ACTION_DATE_TIME,WS_NAME,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+decisionValue+"','"+formattedEntryDatetime+"','"+ErrDesc+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_CBP_WIHISTORY");
								CBPStatusLog.CBPStatusLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,sJtsIp,iJtsPort,1);
								CBPStatusLog.CBPStatusLogger.debug("APInsertOutputXML: "+ apInsertInputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								CBPStatusLog.CBPStatusLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);

								CBPStatusLog.CBPStatusLogger.debug("Completed On "+ CurrWS);


								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									CBPStatusLog.CBPStatusLogger.debug("ApInsert successful: "+apInsertMaincode);
									CBPStatusLog.CBPStatusLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									CBPStatusLog.CBPStatusLogger.debug("ApInsert failed: "+apInsertMaincode);
								}
							}
							else
							{
								completeWorkitemMaincode="";
								CBPStatusLog.CBPStatusLogger.debug("WMCompleteWorkItem failed: "+completeWorkitemMaincode);
							}
						}
						else
						{
							assignWorkitemAttributeMainCode="";
							CBPStatusLog.CBPStatusLogger.debug("AssignWorkitemAttribute failed: "+assignWorkitemAttributeMainCode);
						}
					}
					else
					{
						getWorkItemMainCode="";
						CBPStatusLog.CBPStatusLogger.debug("WmgetWorkItem failed: "+getWorkItemMainCode);
					}
				}

			else
			{
				CBPStatusLog.CBPStatusLogger.debug("WMFetchWorkList failed: "+fetchWorkItemListMainCode);
			}

		}
			}
		}
			catch (Exception e)

		{
			CBPStatusLog.CBPStatusLogger.debug("Exception: "+e.getMessage());
		}
	}
}
