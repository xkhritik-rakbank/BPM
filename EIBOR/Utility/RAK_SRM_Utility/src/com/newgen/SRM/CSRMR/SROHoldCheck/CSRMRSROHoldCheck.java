/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK iRBL Utility
Module					: AP Approval Hold Status
File Name				: AOApprovalHold.java
Author 					: Angad Shah
Date (DD/MM/YYYY)		: 29/06/2021

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.SRM.CSRMR.SROHoldCheck;

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



public class CSRMRSROHoldCheck implements Runnable
{


	private static NGEjbClient ngEjbClientCSRMRSROHoldCheck;

	static Map<String, String> CSRMRSROHoldCheckConfigParamMap= new HashMap<String, String>();


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
			CSRMRSROHoldCheckLog.setLogger();
			ngEjbClientCSRMRSROHoldCheck = NGEjbClient.getSharedInstance();

			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.error("Could not Read Config Properties [CSRMRSROHoldCheck]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("JTSPORT: " + jtsPort);

			queueID = CSRMRSROHoldCheckConfigParamMap.get("queueID");
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("QueueID: " + queueID);

			sleepIntervalInMin=Integer.parseInt(CSRMRSROHoldCheckConfigParamMap.get("SleepIntervalInMin"));
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);


			sessionID = CommonConnection.getSessionID(CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger, false);

			if(sessionID.trim().equalsIgnoreCase(""))
			{
				CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Session ID found: " + sessionID);
				
				while(true)
				{
					CSRMRSROHoldCheckLog.setLogger();
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("CSR_MR SRO Hold Check...123.");
					startCSRMRSROHoldStatusUtility(cabinetName, jtsIP, jtsPort,sessionID,
							queueID, integrationWaitTime);
							System.out.println("No More workitems to Process, Sleeping!");
							Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}

		catch(Exception e)
		{
			e.printStackTrace();
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.error("Exception Occurred in CSR_MR SRO Hold Check : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.error("Exception Occurred in iRBL AO Approval Hold : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "CSRMRSROHoldCheck_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			  {
			    String name = (String) names.nextElement();
			    CSRMRSROHoldCheckConfigParamMap.put(name, p.getProperty(name));
			  }
		    }
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}


	private void startCSRMRSROHoldStatusUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,
			String queueID, int integrationWaitTime)
	{
		String ws_name="";

		try
		{
			//Validate Session ID
			sessionId  = CommonConnection.getSessionID(CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger, false);

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
			{
				CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}

			//Fetch all Work-Items on given queueID.
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Fetching all Workitems on CSR_MR Hold Check queue");
			System.out.println("Fetching all Workitems on CSR_MR Hold Check queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Number of workitems retrieved on CSR_MR Hold Check : "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on CSR_MR Hold Check : "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<=fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser();
					xmlParserfetchWorkItemData.setInputXML(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Current EntryDateTime: "+entryDateTime);

					ws_name=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Current ws_name: "+ws_name);		
					
					String ActivityID = xmlParserfetchWorkItemData.getValueOf("WorkStageId");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("ActivityID: "+ActivityID);
					String ActivityType = xmlParserfetchWorkItemData.getValueOf("ActivityType");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("ActivityType: "+ActivityType);
					String ProcessDefId = xmlParserfetchWorkItemData.getValueOf("RouteId");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("ProcessDefId: "+ProcessDefId);
					
					String decisionValue="";

					CSRMRSROHoldCheckIntegration objIntegration= new CSRMRSROHoldCheckIntegration();
					String integrationStatus=objIntegration.customIntegration(cabinetName,sessionId, sJtsIp,
							iJtsPort,processInstanceID,ws_name,integrationWaitTime, CSRMRSROHoldCheckConfigParamMap);
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("integrationStatus: "+integrationStatus);
					
					String attributesTag="";
					String RemarksForDecHistory = "";
					
					if(integrationStatus.contains("~"))
					{
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("after integration status: "+integrationStatus);
						String tmp[] = integrationStatus.split("~");
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("tmp: "+tmp);
						if ("Exit".equalsIgnoreCase(tmp[1]))
						{
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("tmp[1]"+tmp[1]);
							decisionValue = "Approve-Exit";
							RemarksForDecHistory="This SRO Workitem "+tmp[2]+" is Approved";
							String ActDateTime = tmp[0];
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Decision-" +decisionValue+", ActDateTime- "+ActDateTime);
							String mailStatus = objIntegration.mailTrigger("Completed", processInstanceID,"");
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Mail Status of completion- "+mailStatus);
							String smsStatus = objIntegration.sendSMS("Completed", processInstanceID);
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SMS Status of completion- "+smsStatus);
							
							//attributesTag="<qDecision>"+decisionValue+"</qDecision>" + "<DECISION>" +decisionValue+ "</DECISION>" + "<ACCOUNT_OPENED_DATE>"+ActDateTime+"</ACCOUNT_OPENED_DATE>";
						}
						else if ("Reject".equalsIgnoreCase(tmp[1]))
						{
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("tmp[1] reject"+tmp[1]);
							decisionValue = "Rejected";
							RemarksForDecHistory="This SRO Workitem "+tmp[3]+" is Rejected";
							String RejectReason = tmp[2];
							RejectReason = "Not as per Bank’s internal policy and requirements";
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Decision: " +decisionValue);
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("RejectReason: " +RejectReason);
							String mailStatus = objIntegration.mailTrigger("RejectFinalDiscard", processInstanceID,RejectReason);
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Mail Status of completion- "+mailStatus);
							String smsStatus = objIntegration.sendSMS("RejectFinalDiscard", processInstanceID);
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SMS Status of completion- "+smsStatus);
							
							
							//attributesTag="<qDecision>"+decisionValue+"</qDecision>" + "<DECISION>" +decisionValue+ "</DECISION>";
						}
						else
						{
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("else continue block");
							continue;
						}
					}
					else
					{
						continue;
					}

					//To be modified according to output of Integration Call.

					//Lock Workitem.
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("getWorkItemInputXML before");
					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionId, processInstanceID,WorkItemID);
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("getWorkItemInputXML[1]:- "+getWorkItemInputXML);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,sJtsIp,iJtsPort,1);
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

					if (getWorkItemMainCode.trim().equals("0"))
					{
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WMgetWorkItemCall Successful: "+getWorkItemMainCode);

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
						
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("InputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,sJtsIp,
								iJtsPort,1);

						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("OutputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
						String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("AssignWorkitemAttribute MainCode: "+assignWorkitemAttributeMainCode);

						if(assignWorkitemAttributeMainCode.trim().equalsIgnoreCase("0"))
						{
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("AssignWorkitemAttribute Successful: "+assignWorkitemAttributeMainCode);

							/*String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionId,
									processInstanceID,WorkItemID);
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,sJtsIp,iJtsPort,1);
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);


							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");

							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);
							*/

							//Move Workitem to next Workstep

							//if (completeWorkitemMaincode.trim().equalsIgnoreCase("0"))
							if ("0".trim().equalsIgnoreCase("0"))
							{
								//CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+decisionValue);

								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WorkItem moved to next Workstep.");

								/*SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								Insert in WIHistory Table.
								
								String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+decisionValue+"','"+formattedEntryDatetime+"','"+RemarksForDecHistory+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_IRBL_WIHISTORY");
								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,sJtsIp,iJtsPort,1);
								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);

								CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Completed On "+ ws_name);


								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("ApInsert successful: "+apInsertMaincode);
									CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("ApInsert failed: "+apInsertMaincode);
								}
								*/
							}
							else
							{
								//completeWorkitemMaincode="";
								//CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WMCompleteWorkItem failed: "+completeWorkitemMaincode);
							}
						}
						else
						{
							assignWorkitemAttributeMainCode="";
							CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("AssignWorkitemAttribute failed: "+assignWorkitemAttributeMainCode);
						}
					}
					else
					{
						getWorkItemMainCode="";
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WmgetWorkItem failed: "+getWorkItemMainCode);
					}
					
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("i value " + i);
					if(i == 99){
						String lastProcessInstanceId=processInstanceID;
						String lastWorkItemId=WorkItemID;
						String CreationDateTime=entryDateTime;
						fetchWorkitemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID,CreationDateTime);
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("fetchWorkitemListInputXML next: " + fetchWorkitemListInputXML);

						fetchWorkitemListOutputXML = CommonMethods.WFNGExecute(fetchWorkitemListInputXML, sJtsIp, iJtsPort,1);
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("WMFetchWorkList OutputXML net: " + fetchWorkitemListOutputXML);

						xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

						fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("FetchWorkItemListMainCode next: " + fetchWorkItemListMainCode);

						fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("RetrievedCount for WMFetchWorkList Call next: " + fetchWorkitemListCount);
						System.out.println("Number of workitems retrieved on SRO_Hold Qeue: " + fetchWorkitemListCount);
						i=0;
					}	


		         }
			}
		}
			catch (Exception e)

		{
			CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Exception: "+e.getMessage());
		}
	}



	
			private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
					String sessionID)
			{
				HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

				try
				{
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Fetching Socket Connection Details.");
					System.out.println("Fetching Socket Connection Details.");

					String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'iRBL' and CallingSource = 'Utility'";

					String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

					String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

					XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
					String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

					int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

					if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
					{
						String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
						xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

						XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

						String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SocketServerIP: "+socketServerIP);
						socketDetailsMap.put("SocketServerIP", socketServerIP);

						String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SocketServerPort " + socketServerPort);
						socketDetailsMap.put("SocketServerPort", socketServerPort);

						CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("SocketServer Details found.");
						System.out.println("SocketServer Details found.");

					}
				}
				catch (Exception e)
				{
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Exception in getting Socket Connection Details: "+e.getMessage());
					System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
				}

				return socketDetailsMap;
			}
			protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
					int flag) throws IOException, Exception
			{
				CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("In WF NG Execute : " + serverPort);
				try
				{
					if (serverPort.startsWith("33"))
						return WFCallBroker.execute(ipXML, jtsServerIP,
								Integer.parseInt(serverPort), 1);
					else
						return ngEjbClientCSRMRSROHoldCheck.makeCall(jtsServerIP, serverPort,
								"WebSphere", ipXML);
				}
				catch (Exception e)
				{
					CSRMRSROHoldCheckLog.CSRMRSROHoldCheckLogger.debug("Exception Occured in WF NG Execute : "+ e.getMessage());
					e.printStackTrace();
					return "Error";
				}
			}

}



