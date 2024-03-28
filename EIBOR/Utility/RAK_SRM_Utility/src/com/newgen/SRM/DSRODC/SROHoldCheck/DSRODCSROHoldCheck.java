package com.newgen.SRM.DSRODC.SROHoldCheck;

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

import com.newgen.SRM.CSRMR.SROHoldCheck.CSRMRSROHoldCheckLog;
import com.newgen.SRM.CSROCC.SROHoldCheck.CSROCCSROHoldCheckLog;
import com.newgen.SRM.DSRODC.SROHoldCheck.DSRODCSROHoldCheckIntegration;
import com.newgen.SRM.DSRODC.SROHoldCheck.DSRODCSROHoldCheckLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class DSRODCSROHoldCheck implements Runnable{
	
	private static NGEjbClient ngEjbClientDSRODCSROHoldCheck;

	static Map<String, String> DSRODCSROHoldCheckConfigParamMap= new HashMap<String, String>();


	@Override
	public void run()
	{
		String sessionID = "";
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		String queueID = "";
		int integrationWaitTime=0;
		int sleepIntervalInMin=0;
		
		try
		{
			DSRODCSROHoldCheckLog.setLogger();
			ngEjbClientDSRODCSROHoldCheck = NGEjbClient.getSharedInstance();

			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.error("Could not Read Config Properties [DSRODCSROHoldCheck]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("JTSPORT: " + jtsPort);

			queueID = DSRODCSROHoldCheckConfigParamMap.get("queueID");
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("QueueID: " + queueID);

			sleepIntervalInMin=Integer.parseInt(DSRODCSROHoldCheckConfigParamMap.get("SleepIntervalInMin"));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);


			sessionID = CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false);

			if(sessionID.trim().equalsIgnoreCase(""))
			{
				DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Session ID found: " + sessionID);
				
				while(true)
				{
					DSRODCSROHoldCheckLog.setLogger();
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_MR SRO Hold Check...123.");
					startDSRODCSROHoldStatusUtility(cabinetName, jtsIP, jtsPort,sessionID,
							queueID, integrationWaitTime);
							System.out.println("No More workitems to Process, Sleeping!");
							Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}

		catch(Exception e)
		{
			e.printStackTrace();
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.error("Exception Occurred in CSR_MR SRO Hold Check : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.error("Exception Occurred in iRBL AO Approval Hold : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "DSRODCSROHoldCheck_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			  {
			    String name = (String) names.nextElement();
			    DSRODCSROHoldCheckConfigParamMap.put(name, p.getProperty(name));
			  }
		    }
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}


	private void startDSRODCSROHoldStatusUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,
			String queueID, int integrationWaitTime)
	{
		String ws_name="";

		try
		{
			//Validate Session ID
			sessionId  = CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false);

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
			{
				DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}

			//Fetch all Work-Items on given queueID.
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Fetching all Workitems on CSR_MR Hold Check queue");
			System.out.println("Fetching all Workitems on CSR_MR Hold Check queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Number of workitems retrieved on CSR_MR Hold Check : "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on CSR_MR Hold Check : "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<=fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Current EntryDateTime: "+entryDateTime);

					ws_name=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Current ws_name: "+ws_name);		
					
					String ActivityID = xmlParserfetchWorkItemData.getValueOf("WorkStageId");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("ActivityID: "+ActivityID);
					String ActivityType = xmlParserfetchWorkItemData.getValueOf("ActivityType");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("ActivityType: "+ActivityType);
					String ProcessDefId = xmlParserfetchWorkItemData.getValueOf("RouteId");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("ProcessDefId: "+ProcessDefId);
					
					String decisionValue="";
					
					if(i == 99){
						String lastProcessInstanceId=processInstanceID;
						String lastWorkItemId=WorkItemID;
						String CreationDateTime=entryDateTime;
						fetchWorkitemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID,CreationDateTime);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("InputXML for fetchWorkList Call next: " + fetchWorkitemListInputXML);

						fetchWorkitemListOutputXML = CommonMethods.WFNGExecute(fetchWorkitemListInputXML, sJtsIp, iJtsPort,1);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WMFetchWorkList OutputXML next: " + fetchWorkitemListOutputXML);

						xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

						fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("FetchWorkItemListMainCode next: " + fetchWorkItemListMainCode);

						fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call next: " + fetchWorkitemListCount);
						System.out.println("Number of workitems retrieved on SRO_Hold queue: " + fetchWorkitemListCount);
						i=0;
					}

					DSRODCSROHoldCheckIntegration objIntegration= new DSRODCSROHoldCheckIntegration();
					String integrationStatus=objIntegration.customIntegration(cabinetName,sessionId, sJtsIp,
							iJtsPort,processInstanceID,ws_name,integrationWaitTime, DSRODCSROHoldCheckConfigParamMap);

					
					String attributesTag="";
					String RemarksForDecHistory = "";
					if(integrationStatus.contains("~"))
					{
						String tmp[] = integrationStatus.split("~");
						if ("Exit".equalsIgnoreCase(tmp[1]))
						{
							decisionValue = "Approve-Exit";
							RemarksForDecHistory="This SRO Workitem "+tmp[2]+" is Approved";
							String ActDateTime = tmp[0];
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Decision-" +decisionValue+", ActDateTime- "+ActDateTime);
							String mailStatus = objIntegration.mailTrigger("Completed", processInstanceID,"");
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mail Status of completion- "+mailStatus);
							String smsStatus = objIntegration.sendSMS("Completed", processInstanceID);
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SMS Status of completion- "+smsStatus);
							//attributesTag="<qDecision>"+decisionValue+"</qDecision>" + "<DECISION>" +decisionValue+ "</DECISION>" + "<ACCOUNT_OPENED_DATE>"+ActDateTime+"</ACCOUNT_OPENED_DATE>";
						}
						else if ("Reject".equalsIgnoreCase(tmp[1]))
						{
							decisionValue = "Reject";
							RemarksForDecHistory="This SRO Workitem "+tmp[3]+" is Rejected";
							String RejectReason = tmp[2];
							RejectReason = "Not as per Bank’s internal policy and requirements";
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Decision" +decisionValue);
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("RejectReason" +RejectReason);
							String mailStatus = objIntegration.mailTrigger("RejectFinalDiscard", processInstanceID,RejectReason);
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mail Status of completion- "+mailStatus);
							String smsStatus = objIntegration.sendSMS("RejectFinalDiscard", processInstanceID);
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SMS Status of completion- "+smsStatus);
							
							//attributesTag="<qDecision>"+decisionValue+"</qDecision>" + "<DECISION>" +decisionValue+ "</DECISION>";
						}
						else
						{
							continue;
						}
					}
					else
					{
						continue;
					}

					//To be modified according to output of Integration Call.

					//Lock Workitem.
					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionId, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,sJtsIp,iJtsPort,1);
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

					if (getWorkItemMainCode.trim().equals("0"))
					{
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WMgetWorkItemCall Successful: "+getWorkItemMainCode);

						//String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionId, processInstanceID,WorkItemID,attributesTag);
						
						String assignWorkitemAttributeInputXML = "<?xml version=\"1.0\"?><WMAssignWorkItemAttributes_Input>"
								+ "<Option>WMAssignWorkItemAttributes</Option>"
								+ "<EngineName>"+cabinetName+"</EngineName>"
								+ "<SessionId>"+sessionId+"</SessionId>"
								+ "<ProcessInstanceId>"+processInstanceID+"</ProcessInstanceId>"
								+ "<WorkItemId>"+WorkItemID+"</WorkItemId>"
								+ "<ActivityId>"+ActivityID+"</ActivityId>"
								+ "<ProcessDefId>"+ProcessDefId+"</ProcessDefId>"
								+ "<LastModifiedTime></LastModifiedTime>"
								+ "<ActivityType>"+ActivityType+"</ActivityType>"
								+ "<complete>D</complete>"
								+ "<AuditStatus></AuditStatus>"
								+ "<Comments></Comments>"
								+ "<UserDefVarFlag>Y</UserDefVarFlag>"
								+ "<Attributes>"+attributesTag+"</Attributes>"
								+ "</WMAssignWorkItemAttributes_Input>";
						
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("InputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,sJtsIp,
								iJtsPort,1);

						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("OutputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
						String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("AssignWorkitemAttribute MainCode: "+assignWorkitemAttributeMainCode);

						if(assignWorkitemAttributeMainCode.trim().equalsIgnoreCase("0"))
						{
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("AssignWorkitemAttribute Successful: "+assignWorkitemAttributeMainCode);

							/*String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionId,
									processInstanceID,WorkItemID);
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,sJtsIp,iJtsPort,1);
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);


							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");

							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);
							*/

							//Move Workitem to next Workstep

							//if (completeWorkitemMaincode.trim().equalsIgnoreCase("0"))
							if ("0".trim().equalsIgnoreCase("0"))
							{
								//DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+decisionValue);

								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WorkItem moved to next Workstep.");

								/*SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								Insert in WIHistory Table.
								
								String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+decisionValue+"','"+formattedEntryDatetime+"','"+RemarksForDecHistory+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_IRBL_WIHISTORY");
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,sJtsIp,iJtsPort,1);
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);

								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Completed On "+ ws_name);


								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("ApInsert successful: "+apInsertMaincode);
									DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("ApInsert failed: "+apInsertMaincode);
								}
								*/
							}
							else
							{
								//completeWorkitemMaincode="";
								//DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WMCompleteWorkItem failed: "+completeWorkitemMaincode);
							}
						}
						else
						{
							assignWorkitemAttributeMainCode="";
							DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("AssignWorkitemAttribute failed: "+assignWorkitemAttributeMainCode);
						}
					}
					else
					{
						getWorkItemMainCode="";
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WmgetWorkItem failed: "+getWorkItemMainCode);
					}
					if(i == 99){
						String lastProcessInstanceId=processInstanceID;
						String lastWorkItemId=WorkItemID;
						String CreationDateTime=entryDateTime;
						fetchWorkitemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID,CreationDateTime);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("InputXML for fetchWorkList Call next: " + fetchWorkitemListInputXML);

						fetchWorkitemListOutputXML = CommonMethods.WFNGExecute(fetchWorkitemListInputXML, sJtsIp, iJtsPort,1);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WMFetchWorkList OutputXML next: " + fetchWorkitemListOutputXML);

						xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

						fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("FetchWorkItemListMainCode next: " + fetchWorkItemListMainCode);

						fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call next: " + fetchWorkitemListCount);
						System.out.println("Number of workitems retrieved on SRO_Hold queue: " + fetchWorkitemListCount);
						i=0;
					}
					

		}
			}
		}
			catch (Exception e)

		{
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Exception: "+e.getMessage());
		}
	}



			private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
					String sessionID)
			{
				HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

				try
				{
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Fetching Socket Connection Details.");
					System.out.println("Fetching Socket Connection Details.");

					String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'iRBL' and CallingSource = 'Utility'";

					String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

					String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

					XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
					String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

					int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

					if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
					{
						String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
						xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

						XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

						String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SocketServerIP: "+socketServerIP);
						socketDetailsMap.put("SocketServerIP", socketServerIP);

						String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SocketServerPort " + socketServerPort);
						socketDetailsMap.put("SocketServerPort", socketServerPort);

						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SocketServer Details found.");
						System.out.println("SocketServer Details found.");

					}
				}
				catch (Exception e)
				{
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Exception in getting Socket Connection Details: "+e.getMessage());
					System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
				}

				return socketDetailsMap;
			}
			protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
					int flag) throws IOException, Exception
			{
				DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("In WF NG Execute : " + serverPort);
				try
				{
					if (serverPort.startsWith("33"))
						return WFCallBroker.execute(ipXML, jtsServerIP,
								Integer.parseInt(serverPort), 1);
					else
						return ngEjbClientDSRODCSROHoldCheck.makeCall(jtsServerIP, serverPort,
								"WebSphere", ipXML);
				}
				catch (Exception e)
				{
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Exception Occured in WF NG Execute : "+ e.getMessage());
					e.printStackTrace();
					return "Error";
				}
			}

}
