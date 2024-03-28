package com.newgen.SRM.CSROCC.SROHoldCheck;

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
import com.newgen.SRM.CSROCC.SROHoldCheck.CSROCCSROHoldCheckIntegration;
import com.newgen.SRM.CSROCC.SROHoldCheck.CSROCCSROHoldCheckLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class CSROCCSROHoldCheck implements Runnable{
	
	private static NGEjbClient ngEjbClientCSROCCSROHoldCheck;

	static Map<String, String> CSROCCSROHoldCheckConfigParamMap= new HashMap<String, String>();


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
			CSROCCSROHoldCheckLog.setLogger();
			ngEjbClientCSROCCSROHoldCheck = NGEjbClient.getSharedInstance();

			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.error("Could not Read Config Properties [CSROCCSROHoldCheck]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("JTSPORT: " + jtsPort);

			queueID = CSROCCSROHoldCheckConfigParamMap.get("queueID");
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("QueueID: " + queueID);

			sleepIntervalInMin=Integer.parseInt(CSROCCSROHoldCheckConfigParamMap.get("SleepIntervalInMin"));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);


			sessionID = CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false);

			if(sessionID.trim().equalsIgnoreCase(""))
			{
				CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Session ID found: " + sessionID);
				
				while(true)
				{
					CSROCCSROHoldCheckLog.setLogger();
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_MR SRO Hold Check...123.");
					startCSROCCSROHoldStatusUtility(cabinetName, jtsIP, jtsPort,sessionID,
							queueID, integrationWaitTime);
							System.out.println("No More workitems to Process, Sleeping!");
							Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}

		catch(Exception e)
		{
			e.printStackTrace();
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.error("Exception Occurred in CSR_MR SRO Hold Check : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.error("Exception Occurred in iRBL AO Approval Hold : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "CSROCCSROHoldCheck_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			  {
			    String name = (String) names.nextElement();
			    CSROCCSROHoldCheckConfigParamMap.put(name, p.getProperty(name));
			  }
		    }
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}


	private void startCSROCCSROHoldStatusUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,
			String queueID, int integrationWaitTime)
	{
		String ws_name="";

		try
		{
			//Validate Session ID
			sessionId  = CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false);

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
			{
				CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}

			//Fetch all Work-Items on given queueID.
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Fetching all Workitems on CSR_MR Hold Check queue");
			System.out.println("Fetching all Workitems on CSR_MR Hold Check queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Number of workitems retrieved on CSR_MR Hold Check : "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on CSR_MR Hold Check : "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<=fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Current EntryDateTime: "+entryDateTime);

					ws_name=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Current ws_name: "+ws_name);		
					
					String ActivityID = xmlParserfetchWorkItemData.getValueOf("WorkStageId");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("ActivityID: "+ActivityID);
					String ActivityType = xmlParserfetchWorkItemData.getValueOf("ActivityType");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("ActivityType: "+ActivityType);
					String ProcessDefId = xmlParserfetchWorkItemData.getValueOf("RouteId");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("ProcessDefId: "+ProcessDefId);
					
					String decisionValue="";

					CSROCCSROHoldCheckIntegration objIntegration= new CSROCCSROHoldCheckIntegration();
					String integrationStatus=objIntegration.customIntegration(cabinetName,sessionId, sJtsIp,
							iJtsPort,processInstanceID,ws_name,integrationWaitTime, CSROCCSROHoldCheckConfigParamMap);

					
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
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Decision-" +decisionValue+", ActDateTime- "+ActDateTime);
							String mailStatus = objIntegration.mailTrigger("Completed", processInstanceID,"");
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mail Status of completion- "+mailStatus);
							String smsStatus = objIntegration.sendSMS("Completed", processInstanceID);
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SMS Status of completion- "+smsStatus);
							//attributesTag="<qDecision>"+decisionValue+"</qDecision>" + "<DECISION>" +decisionValue+ "</DECISION>" + "<ACCOUNT_OPENED_DATE>"+ActDateTime+"</ACCOUNT_OPENED_DATE>";
						}
						else if ("Reject".equalsIgnoreCase(tmp[1]))
						{
							decisionValue = "Reject";
							RemarksForDecHistory="This SRO Workitem "+tmp[3]+" is Rejected";
							String RejectReason = tmp[2];
							RejectReason = "Not as per Bank’s internal policy and requirements";
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Decision: " +decisionValue);
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("RejectReason: " +RejectReason);
							String mailStatus = objIntegration.mailTrigger("RejectFinalDiscard", processInstanceID,RejectReason);
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mail Status of completion- "+mailStatus);
							String smsStatus = objIntegration.sendSMS("RejectFinalDiscard", processInstanceID);
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SMS Status of completion- "+smsStatus);
							
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
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

					if (getWorkItemMainCode.trim().equals("0"))
					{
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WMgetWorkItemCall Successful: "+getWorkItemMainCode);

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
						
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("InputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,sJtsIp,
								iJtsPort,1);

						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("OutputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
						String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("AssignWorkitemAttribute MainCode: "+assignWorkitemAttributeMainCode);

						if(assignWorkitemAttributeMainCode.trim().equalsIgnoreCase("0"))
						{
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("AssignWorkitemAttribute Successful: "+assignWorkitemAttributeMainCode);

							/*String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionId,
									processInstanceID,WorkItemID);
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,sJtsIp,iJtsPort,1);
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);


							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");

							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);
							*/

							//Move Workitem to next Workstep

							//if (completeWorkitemMaincode.trim().equalsIgnoreCase("0"))
							if ("0".trim().equalsIgnoreCase("0"))
							{
								//CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+decisionValue);

								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WorkItem moved to next Workstep.");

								/*SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								Insert in WIHistory Table.
								
								String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+decisionValue+"','"+formattedEntryDatetime+"','"+RemarksForDecHistory+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_IRBL_WIHISTORY");
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,sJtsIp,iJtsPort,1);
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);

								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Completed On "+ ws_name);


								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("ApInsert successful: "+apInsertMaincode);
									CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("ApInsert failed: "+apInsertMaincode);
								}
								*/
							}
							else
							{
								//completeWorkitemMaincode="";
								//CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WMCompleteWorkItem failed: "+completeWorkitemMaincode);
							}
						}
						else
						{
							assignWorkitemAttributeMainCode="";
							CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("AssignWorkitemAttribute failed: "+assignWorkitemAttributeMainCode);
						}
					}
					else
					{
						getWorkItemMainCode="";
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WmgetWorkItem failed: "+getWorkItemMainCode);
					}
					if(i == 99){
						String lastProcessInstanceId=processInstanceID;
						String lastWorkItemId=WorkItemID;
						String CreationDateTime=entryDateTime;
						fetchWorkitemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID,CreationDateTime);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("InputXML for fetchWorkList Call Next: " + fetchWorkitemListInputXML);

						fetchWorkitemListOutputXML = CommonMethods.WFNGExecute(fetchWorkitemListInputXML, sJtsIp, iJtsPort,1);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WMFetchWorkList OutputXML next: " + fetchWorkitemListOutputXML);

						xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

						fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("FetchWorkItemListMainCode next: " + fetchWorkItemListMainCode);

						fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call next: " + fetchWorkitemListCount);
						System.out.println("Number of workitems retrieved on SRO_Hold Qeue: " + fetchWorkitemListCount);
						i=0;
					}


		}
			}
		}
			catch (Exception e)

		{
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Exception: "+e.getMessage());
		}
	}



			private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
					String sessionID)
			{
				HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

				try
				{
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Fetching Socket Connection Details.");
					System.out.println("Fetching Socket Connection Details.");

					String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'iRBL' and CallingSource = 'Utility'";

					String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

					String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

					XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
					String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

					int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

					if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
					{
						String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
						xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

						XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

						String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SocketServerIP: "+socketServerIP);
						socketDetailsMap.put("SocketServerIP", socketServerIP);

						String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SocketServerPort " + socketServerPort);
						socketDetailsMap.put("SocketServerPort", socketServerPort);

						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SocketServer Details found.");
						System.out.println("SocketServer Details found.");

					}
				}
				catch (Exception e)
				{
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Exception in getting Socket Connection Details: "+e.getMessage());
					System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
				}

				return socketDetailsMap;
			}
			protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
					int flag) throws IOException, Exception
			{
				CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("In WF NG Execute : " + serverPort);
				try
				{
					if (serverPort.startsWith("33"))
						return WFCallBroker.execute(ipXML, jtsServerIP,
								Integer.parseInt(serverPort), 1);
					else
						return ngEjbClientCSROCCSROHoldCheck.makeCall(jtsServerIP, serverPort,
								"WebSphere", ipXML);
				}
				catch (Exception e)
				{
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Exception Occured in WF NG Execute : "+ e.getMessage());
					e.printStackTrace();
					return "Error";
				}
			}

}
