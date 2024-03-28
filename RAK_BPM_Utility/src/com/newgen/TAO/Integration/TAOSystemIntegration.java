package com.newgen.TAO.Integration;

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

public class TAOSystemIntegration implements Runnable {
	


	private static NGEjbClient ngEjbClientRAOPCBS;
	
	public String historyTable="";
	public String ws_name="";

	static Map<String, String> TAOSIConfigParamMap= new HashMap<String, String>();
	TAOIntegration objTAOIntegration=new TAOIntegration();
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
			TAOSystemIntegrationLog.setLogger();
			ngEjbClientRAOPCBS = NGEjbClient.getSharedInstance();

			TAOSystemIntegrationLog.TAOSILogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			TAOSystemIntegrationLog.TAOSILogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				TAOSystemIntegrationLog.TAOSILogger.error("Could not Read Config Properties [RAOP CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			TAOSystemIntegrationLog.TAOSILogger.debug("Cabinet Name: " + cabinetName);



			jtsIP = CommonConnection.getJTSIP();
			TAOSystemIntegrationLog.TAOSILogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			TAOSystemIntegrationLog.TAOSILogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			TAOSystemIntegrationLog.TAOSILogger.debug("SMSPort: " + smsPort);
			

			queueID = TAOSIConfigParamMap.get("queueID");
			TAOSystemIntegrationLog.TAOSILogger.debug("QueueID: " + queueID);

			socketConnectionTimeout=Integer.parseInt(TAOSIConfigParamMap.get("MQ_SOCKET_CONNECTION_TIMEOUT"));
			TAOSystemIntegrationLog.TAOSILogger.debug("SocketConnectionTimeOut: "+socketConnectionTimeout);
			
			integrationWaitTime=Integer.parseInt(TAOSIConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			TAOSystemIntegrationLog.TAOSILogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(TAOSIConfigParamMap.get("SleepIntervalInMin"));
			TAOSystemIntegrationLog.TAOSILogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			historyTable=TAOSIConfigParamMap.get("HISTORYTABLE");
			TAOSystemIntegrationLog.TAOSILogger.debug("WorkItem History Table is "+historyTable);
			
			ws_name=TAOSIConfigParamMap.get("WSNAME");
			TAOSystemIntegrationLog.TAOSILogger.debug("Activity Name is "+ws_name);

			sessionID = CommonConnection.getSessionID(TAOSystemIntegrationLog.TAOSILogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				TAOSystemIntegrationLog.TAOSILogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					TAOSystemIntegrationLog.setLogger();
					TAOSystemIntegrationLog.TAOSILogger.debug("TAO System integration....");
					startTAOSIUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,socketConnectionTimeout,integrationWaitTime,sessionID,socketDetailsMap,docDownloadPath,volumeId,siteId,Sig_Remarks);
					TAOSystemIntegrationLog.TAOSILogger.info("No more work item to process.");
					TAOSystemIntegrationLog.TAOSILogger.info("Utility is going to sleep for "+sleepIntervalInMin +" minutes.");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			TAOSystemIntegrationLog.TAOSILogger.error("Exception Occurred in TAO CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			TAOSystemIntegrationLog.TAOSILogger.error("Exception Occurred in TAO CBS : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "TAO_SystemIntegration_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    TAOSIConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	private void startTAOSIUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int socketConnectionTimeout,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId,String Sig_Remarks)
	{
		
		try
		{
			sessionID  = CommonConnection.getSessionID(TAOSystemIntegrationLog.TAOSILogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				TAOSystemIntegrationLog.TAOSILogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			TAOSystemIntegrationLog.TAOSILogger.debug("Fetching all Workitems at System_Integration queue");
			System.out.println("Fetching all WIs at core system update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			TAOSystemIntegrationLog.TAOSILogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			TAOSystemIntegrationLog.TAOSILogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			TAOSystemIntegrationLog.TAOSILogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					TAOSystemIntegrationLog.TAOSILogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID="";
					processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					TAOSystemIntegrationLog.TAOSILogger.debug("Current ProcessInstanceID: "+processInstanceID);

					TAOSystemIntegrationLog.TAOSILogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID="";
					WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					TAOSystemIntegrationLog.TAOSILogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime="";
					entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					TAOSystemIntegrationLog.TAOSILogger.debug("Current EntryDateTime: "+entryDateTime);

					objTAOIntegration.RegUsrProfileIntegration(cabinetName,  sessionID, jtsIP, jtsPort, processInstanceID,WorkItemID,socketConnectionTimeout,integrationWaitTime, socketDetailsMap,entryDateTime,historyTable,ws_name);
					
				}
			}

		}
		catch(Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			TAOSystemIntegrationLog.TAOSILogger.error("Exception Occurred in RAOP CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}

	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		TAOSystemIntegrationLog.TAOSILogger.debug("In WF NG Execute : " + serverPort);
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
			TAOSystemIntegrationLog.TAOSILogger.error("Exception Occured in WF NG Execute : "
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
			TAOSystemIntegrationLog.TAOSILogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'TAO' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			TAOSystemIntegrationLog.TAOSILogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			TAOSystemIntegrationLog.TAOSILogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			TAOSystemIntegrationLog.TAOSILogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			TAOSystemIntegrationLog.TAOSILogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				TAOSystemIntegrationLog.TAOSILogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				TAOSystemIntegrationLog.TAOSILogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				TAOSystemIntegrationLog.TAOSILogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}




}
