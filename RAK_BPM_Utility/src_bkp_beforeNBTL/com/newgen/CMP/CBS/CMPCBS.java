package com.newgen.CMP.CBS;

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

public class CMPCBS implements Runnable
{
	private String CMP_WIHISTORY="USR_0_CMP_WIHISTORY";
	
	private static NGEjbClient ngEjbClientCMPCBS;
	static Map<String, String> CMPCBSConfigParamMap= new HashMap<String, String>();
	CMPCBSIntegration objCMPCBSIntegration=new CMPCBSIntegration();
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
			CMPCBSLog.setLogger();
			ngEjbClientCMPCBS = NGEjbClient.getSharedInstance();

			CMPCBSLog.CMPCBSLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CMPCBSLog.CMPCBSLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				CMPCBSLog.CMPCBSLogger.error("Could not Read Config Properties [CMP CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			CMPCBSLog.CMPCBSLogger.debug("Cabinet Name: " + cabinetName);



			jtsIP = CommonConnection.getJTSIP();
			CMPCBSLog.CMPCBSLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CMPCBSLog.CMPCBSLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			CMPCBSLog.CMPCBSLogger.debug("SMSPort: " + smsPort);
			

			queueID = CMPCBSConfigParamMap.get("queueID");
			CMPCBSLog.CMPCBSLogger.debug("QueueID: " + queueID);

			docDownloadPath=CMPCBSConfigParamMap.get("FileDownloadPath");
			CMPCBSLog.CMPCBSLogger.debug("Doc Download path is "+docDownloadPath);
			
			socketConnectionTimeout=Integer.parseInt(CMPCBSConfigParamMap.get("MQ_SOCKET_CONNECTION_TIMEOUT"));
			CMPCBSLog.CMPCBSLogger.debug("SocketConnectionTimeOut: "+socketConnectionTimeout);
			
			integrationWaitTime=Integer.parseInt(CMPCBSConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			CMPCBSLog.CMPCBSLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(CMPCBSConfigParamMap.get("SleepIntervalInMin"));
			CMPCBSLog.CMPCBSLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			volumeId=CMPCBSConfigParamMap.get("VolumeID");
			CMPCBSLog.CMPCBSLogger.debug("Volume Id from config file is "+volumeId);

			siteId=CMPCBSConfigParamMap.get("SiteID");
			CMPCBSLog.CMPCBSLogger.debug("site Id is "+siteId);

			sessionID = CommonConnection.getSessionID(CMPCBSLog.CMPCBSLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				CMPCBSLog.CMPCBSLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					CMPCBSLog.setLogger();
					CMPCBSLog.CMPCBSLogger.debug("CMP CBS....");
					startCMPCBSUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,socketConnectionTimeout,integrationWaitTime,sessionID,socketDetailsMap,docDownloadPath,volumeId,siteId);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			CMPCBSLog.CMPCBSLogger.error("Exception Occurred in CMP CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CMPCBSLog.CMPCBSLogger.error("Exception Occurred in CMP CBS : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "CMP_CBS_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    CMPCBSConfigParamMap.put(name, p.getProperty(name));
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
			sessionID  = CommonConnection.getSessionID(CMPCBSLog.CMPCBSLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				CMPCBSLog.CMPCBSLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			CMPCBSLog.CMPCBSLogger.debug("Fetching all Workitems at core system update queue");
			System.out.println("Fetching all WIs at core system update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			CMPCBSLog.CMPCBSLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			CMPCBSLog.CMPCBSLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			CMPCBSLog.CMPCBSLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			CMPCBSLog.CMPCBSLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					CMPCBSLog.CMPCBSLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					CMPCBSLog.CMPCBSLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					CMPCBSLog.CMPCBSLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					CMPCBSLog.CMPCBSLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					CMPCBSLog.CMPCBSLogger.debug("Current EntryDateTime: "+entryDateTime);

					ResponseBean objResponseBean=objCMPCBSIntegration.CMPCBSCustomerCreationIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,socketConnectionTimeout,integrationWaitTime, socketDetailsMap,docDownloadPath,volumeId,siteId);

					String strIntegrationErrCode="";

					if("Success".equals(objResponseBean.getCustomerCreationReturnCode()))
						strIntegrationErrCode="";
					else
						strIntegrationErrCode=ws_name;

					//checking if its an existing customer or not
					if("Y".equals(objResponseBean.getIsExistingCustomer()))
					{
						objResponseBean.setCustomerCreationReturnCode("NA");
					}
					String strMWErrorDesc = "MessageID: "+objResponseBean.getMsgID()+", Return Code: "+objResponseBean.getIntFailedCode()+", Return Desc: "+objResponseBean.getIntFailedReason();
					String attributesTag="<DECISION>"+objResponseBean.getIntegrationDecision()+"</DECISION>"
							+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</INTEGRATION_ERROR_RECEIVED>"
							+ "<CREATE_CUSTOMER_STATUS>"+objResponseBean.getCustomerCreationReturnCode()+"</CREATE_CUSTOMER_STATUS>"
							+"<FAILEDINTEGRATIONCALL>NEW_RMT_CUSTOMER_REQ</FAILEDINTEGRATIONCALL>" 
							+ "<MW_ERRORDESC>" +strMWErrorDesc+ "</MW_ERRORDESC>";



					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

					CMPCBSLog.CMPCBSLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

					if("0".equals(getWorkItemMainCode))
					{
						CMPCBSLog.CMPCBSLogger.info("get Workitem call successfull for "+processInstanceID);

						String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
								processInstanceID,WorkItemID,attributesTag);
						CMPCBSLog.CMPCBSLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

						String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
								jtsPort,1);
						CMPCBSLog.CMPCBSLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

						XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

						String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
						if("0".equals(mainCodeAssignAtt.trim()))
						{
							String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
									processInstanceID,WorkItemID);

							CMPCBSLog.CMPCBSLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

							CMPCBSLog.CMPCBSLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

							String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
							CMPCBSLog.CMPCBSLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

							XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
							String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
							CMPCBSLog.CMPCBSLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

							if("0".equals(completeWorkitemMaincode))
							{
								//inserting into history table
								CMPCBSLog.CMPCBSLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
								System.out.println(processInstanceID + "Complete Succesfully with status "+objResponseBean.getIntegrationDecision());

								CMPCBSLog.CMPCBSLogger.debug("WorkItem moved to next Workstep.");

								SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
								SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

								Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
								String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
								CMPCBSLog.CMPCBSLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

								Date actionDateTime= new Date();
								String formattedActionDateTime=outputDateFormat.format(actionDateTime);
								CMPCBSLog.CMPCBSLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

								//Insert in WIHistory Table.

								String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME";
								String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
								+CommonConnection.getUsername()+"','"+objResponseBean.getIntegrationDecision()+"','"+formattedEntryDatetime+"'";

								String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,CMP_WIHISTORY);
								CMPCBSLog.CMPCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

								String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
										jtsPort,1);
								CMPCBSLog.CMPCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

								XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
								String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
								CMPCBSLog.CMPCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
								if(apInsertMaincode.equalsIgnoreCase("0"))
								{
									CMPCBSLog.CMPCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
									CMPCBSLog.CMPCBSLogger.debug("Inserted in WiHistory table successfully.");
								}
								else
								{
									CMPCBSLog.CMPCBSLogger.error("ApInsert failed: "+apInsertMaincode);
								}
							}
							else
							{
								CMPCBSLog.CMPCBSLogger.error("Error in completeWI call for "+processInstanceID);
							}
						}
						else
						{
							CMPCBSLog.CMPCBSLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
						}


					}
					else
					{
						CMPCBSLog.CMPCBSLogger.error("Error in getWI call for WI "+processInstanceID);
					}

				}
			}

		}
		catch(Exception e)
		{
			CMPCBSLog.CMPCBSLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CMPCBSLog.CMPCBSLogger.error("Exception Occurred in CMP CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}

	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		CMPCBSLog.CMPCBSLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientCMPCBS.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			CMPCBSLog.CMPCBSLogger.error("Exception Occured in WF NG Execute : "
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
			CMPCBSLog.CMPCBSLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'CMP' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			CMPCBSLog.CMPCBSLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			CMPCBSLog.CMPCBSLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			CMPCBSLog.CMPCBSLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			CMPCBSLog.CMPCBSLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				CMPCBSLog.CMPCBSLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				CMPCBSLog.CMPCBSLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				CMPCBSLog.CMPCBSLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			CMPCBSLog.CMPCBSLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
}
