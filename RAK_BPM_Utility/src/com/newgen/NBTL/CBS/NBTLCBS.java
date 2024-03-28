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


package com.newgen.NBTL.CBS;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.newgen.NBTL.Hold.NBTLHoldLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class NBTLCBS implements Runnable
{
	private String NBTL_WIHISTORY="USR_0_NBTL_WIHISTORY";
	
	private static NGEjbClient ngEjbClientNBTLCBS;
	static Map<String, String> NBTLCBSConfigParamMap= new HashMap<String, String>();
	private String NBTL_EXTTABLE = "RB_NBTL_EXTTABLE";
	private final String ws_name="Core_System_Update";
	private String entryDateTime="";
	private String strIntegrationErrCode="";
	private String strIntegrationErrRemarks="";
	private String attributesTag = "";
	private String getWorkItemInputXML = "";
	private String getWorkItemOutputXml = "";
	private XMLParser xmlParserGetWorkItem = new XMLParser();
	private String getWorkItemMainCode = "";
	private String emailBody = "";
	private String mailFrom = "";
	private String mailSubject = "";
	private String activityName = "";
	private int ThresholdYear=0;
	NBTLCBSIntegration objNBTLCBSIntegration=new NBTLCBSIntegration();
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
			NBTLCBSLog.setLogger();
			ngEjbClientNBTLCBS = NGEjbClient.getSharedInstance();

			NBTLCBSLog.NBTLCBSLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			NBTLCBSLog.NBTLCBSLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				NBTLCBSLog.NBTLCBSLogger.error("Could not Read Config Properties [NBTL CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			NBTLCBSLog.NBTLCBSLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			NBTLCBSLog.NBTLCBSLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			NBTLCBSLog.NBTLCBSLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			NBTLCBSLog.NBTLCBSLogger.debug("SMSPort: " + smsPort);
			

			queueID = NBTLCBSConfigParamMap.get("queueID");
			NBTLCBSLog.NBTLCBSLogger.debug("QueueID: " + queueID);

			integrationWaitTime=Integer.parseInt(NBTLCBSConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			NBTLCBSLog.NBTLCBSLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(NBTLCBSConfigParamMap.get("SleepIntervalInMin"));
			NBTLCBSLog.NBTLCBSLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);
			
			ThresholdYear=Integer.parseInt(NBTLCBSConfigParamMap.get("ThresholdYear"));
			NBTLCBSLog.NBTLCBSLogger.debug("ThresholdYear: "+ThresholdYear);
			

			sessionID = CommonConnection.getSessionID(NBTLCBSLog.NBTLCBSLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				NBTLCBSLog.NBTLCBSLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					NBTLCBSLog.setLogger();
					NBTLCBSLog.NBTLCBSLogger.debug("NBTL CBS....");
					startNBTLCBSUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,sleepIntervalInMin,integrationWaitTime,sessionID,socketDetailsMap);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			NBTLCBSLog.NBTLCBSLogger.error("Exception Occurred in NBTL CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTLCBSLog.NBTLCBSLogger.error("Exception Occurred in NBTL CBS : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "NBTL_CBS_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    NBTLCBSConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	
	
	
	private void startNBTLCBSUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap)
	{
		try
		{
			sessionID  = CommonConnection.getSessionID(NBTLCBSLog.NBTLCBSLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				NBTLCBSLog.NBTLCBSLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			NBTLCBSLog.NBTLCBSLogger.debug("Fetching all Workitems at core system update queue");
			System.out.println("Fetching all WIs at core system update");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			NBTLCBSLog.NBTLCBSLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			NBTLCBSLog.NBTLCBSLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			NBTLCBSLog.NBTLCBSLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			NBTLCBSLog.NBTLCBSLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					NBTLCBSLog.NBTLCBSLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					NBTLCBSLog.NBTLCBSLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					NBTLCBSLog.NBTLCBSLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					NBTLCBSLog.NBTLCBSLogger.debug("Current WorkItemID: "+WorkItemID);
					
					activityName=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					NBTLCBSLog.NBTLCBSLogger.debug("Current ActivityName: "+activityName);

					entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					NBTLCBSLog.NBTLCBSLogger.debug("Current EntryDateTime: "+entryDateTime);
					
					String QueryString="SELECT WINAME,ToBeTLNo,CorporateCIF,ToBeExpiryDate,EmailAddress,Memopad,decision,RequestType,"
							+ "PrevOPSReviewDec,MEMO_INTEGRATION_ERROR_RECEIVED,INTEGRATION_ERROR_RECEIVED,CifUpdateSecondCall,OnlyExpiryDateChange"
							+ " FROM "+NBTL_EXTTABLE+" with (nolock) where WINAME='"+processInstanceID+"'";


					String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
					NBTLCBSLog.NBTLCBSLogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

					String sOutputXML=NBTLCBS.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
					NBTLCBSLog.NBTLCBSLogger.debug("Output XML for external Table select "+sOutputXML);

					XMLParser sXMLParser= new XMLParser(sOutputXML);
				    String sMainCode = sXMLParser.getValueOf("MainCode");
				    NBTLCBSLog.NBTLCBSLogger.debug("SMainCode: "+sMainCode);

				    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
				    NBTLCBSLog.NBTLCBSLogger.debug("STotalRecords: "+sTotalRecords);

					if (sMainCode.equals("0") && sTotalRecords > 0)
					{
						NBTLCBSLog.NBTLCBSLogger.debug("Inside If block");
						CustomerBean objCustBean=new CustomerBean();
						
						String strWi_name=sXMLParser.getValueOf("winame");
						objCustBean.setWiName(strWi_name);
						NBTLCBSLog.NBTLCBSLogger.debug("strWi_name "+strWi_name);
						
						String strToBeTLNo=sXMLParser.getValueOf("ToBeTLNo");
						objCustBean.setToBeTLNo(strToBeTLNo);
						NBTLCBSLog.NBTLCBSLogger.debug("strToBeTLNo "+strToBeTLNo);
						
						String strCorporateCIF=sXMLParser.getValueOf("CorporateCIF");
						objCustBean.setCorporateCIF(strCorporateCIF);
						NBTLCBSLog.NBTLCBSLogger.debug("strCorporateCIF "+strCorporateCIF);
						
						String strEmail=sXMLParser.getValueOf("EmailAddress");
						objCustBean.setEmail(strEmail);
						NBTLCBSLog.NBTLCBSLogger.debug("strEmail "+strEmail);
						
						String MemoPadText=sXMLParser.getValueOf("Memopad");
						objCustBean.setMemoPadText(MemoPadText);
						NBTLCBSLog.NBTLCBSLogger.debug("MemoPadText "+MemoPadText);
						
						String RequestType=sXMLParser.getValueOf("RequestType");
						objCustBean.setRequestType(RequestType);
						NBTLCBSLog.NBTLCBSLogger.debug("RequestType "+RequestType);
						
						String OnlyExpiryDateChange=sXMLParser.getValueOf("OnlyExpiryDateChange");
						if(OnlyExpiryDateChange == null)
						{
							OnlyExpiryDateChange = "";
						}
						NBTLCBSLog.NBTLCBSLogger.debug("OnlyExpiryDateChange "+OnlyExpiryDateChange);
						
						String decision =sXMLParser.getValueOf("decision");
						if(decision == null)
						{
							decision = "";
						}
						NBTLCBSLog.NBTLCBSLogger.debug("decision "+decision);
						
						String PrevOPSReviewDec =sXMLParser.getValueOf("PrevOPSReviewDec");
						if(PrevOPSReviewDec == null)
						{
							PrevOPSReviewDec = "";
						}
						NBTLCBSLog.NBTLCBSLogger.debug("decision "+PrevOPSReviewDec);
						
						String INTEGRATION_ERROR_RECEIVED =sXMLParser.getValueOf("INTEGRATION_ERROR_RECEIVED");
						if(INTEGRATION_ERROR_RECEIVED == null)
						{
							INTEGRATION_ERROR_RECEIVED = "";
						}
						NBTLCBSLog.NBTLCBSLogger.debug("INTEGRATION_ERROR_RECEIVED "+INTEGRATION_ERROR_RECEIVED);
						
						String MEMO_INTEGRATION_ERROR_RECEIVED =sXMLParser.getValueOf("MEMO_INTEGRATION_ERROR_RECEIVED");
						if(MEMO_INTEGRATION_ERROR_RECEIVED == null)
						{
							MEMO_INTEGRATION_ERROR_RECEIVED = "";
						}
						NBTLCBSLog.NBTLCBSLogger.debug("MEMO_INTEGRATION_ERROR_RECEIVED "+MEMO_INTEGRATION_ERROR_RECEIVED);
						
						String CifUpdateSecondCall =sXMLParser.getValueOf("CifUpdateSecondCall");
						if(CifUpdateSecondCall == null)
						{
							CifUpdateSecondCall = "";
						}
						NBTLCBSLog.NBTLCBSLogger.debug("CifUpdateSecondCall "+CifUpdateSecondCall);
						
						SimpleDateFormat outputdateFormat = new SimpleDateFormat("yyyy-MM-dd");
						Date d = outputdateFormat.parse(sXMLParser.getValueOf("ToBeExpiryDate"));
						String strToBeExpiryDate= outputdateFormat.format(d);
						int year = Integer.parseInt(strToBeExpiryDate.substring(0,4));
						objCustBean.setToBeExpiryDate(strToBeExpiryDate);
						NBTLCBSLog.NBTLCBSLogger.debug("strToBeExpiryDate "+strToBeExpiryDate);
						NBTLCBSLog.NBTLCBSLogger.debug("year "+year);
						
						NBTLCBSLog.NBTLCBSLogger.debug("objCustBean.getWiName() "+objCustBean.getWiName());
						NBTLCBSLog.NBTLCBSLogger.debug("objCustBean.getCorporate_CIF() "+objCustBean.getCorporateCIF());	
						
						Date date = new Date();
						String KYC_ReviewDate  = outputdateFormat.format(date);
						
						if(("STP_Approved".equalsIgnoreCase(PrevOPSReviewDec) || "Approve".equalsIgnoreCase(PrevOPSReviewDec)) && !"Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED))
						{
							ResponseBean objResponseBean=objNBTLCBSIntegration.NBTLCBS_CifUpdateIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime,strCorporateCIF,strToBeTLNo,strToBeExpiryDate,KYC_ReviewDate,INTEGRATION_ERROR_RECEIVED,socketDetailsMap,strWi_name,activityName,ThresholdYear,year,RequestType);
							NBTLCBSLog.NBTLCBSLogger.error("objResponseBean.getCifUpdateReturnCode() "+objResponseBean.getCifUpdateReturnCode());
								if("Success".equals(objResponseBean.getCifUpdateReturnCode()))
								{
									strIntegrationErrCode="Success";
									strIntegrationErrRemarks="Cif Update Successfull";
								}	
								else if("CIF_UnderVerification".equals(objResponseBean.getCifUpdateReturnCode()))
								{
									strIntegrationErrCode="Failure";
									strIntegrationErrRemarks="CIF UNDER VERIFICATION";
								}
								else
								{
									strIntegrationErrCode="Failure";
									strIntegrationErrRemarks="Error in Cif Update";
								}
								NBTLCBSLog.NBTLCBSLogger.debug("objResponseBean.getIntegrationDecision() "+objResponseBean.getIntegrationDecision());
								NBTLCBSLog.NBTLCBSLogger.debug("strIntegrationErrCode "+strIntegrationErrCode);
								
								attributesTag="<Decision>"+strIntegrationErrCode+"</Decision>"
										+ "<Remarks>"+strIntegrationErrRemarks+"</Remarks>"
										+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</INTEGRATION_ERROR_RECEIVED>";
			
								DoneWI(cabinetName, jtsIP, jtsPort, smsPort, queueId, sleepIntervalTime, integrationWaitTime, sessionID,  processInstanceID,
										 WorkItemID,  strIntegrationErrCode,  strIntegrationErrRemarks ,attributesTag, RequestType);
			
						}
						else if("Approve with Profile Change".equalsIgnoreCase(PrevOPSReviewDec) && (!"Success".equalsIgnoreCase(MEMO_INTEGRATION_ERROR_RECEIVED) ||  !"Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED)))
						{
							if(!"Success".equalsIgnoreCase(MEMO_INTEGRATION_ERROR_RECEIVED))
							{
								ResponseBean objResponseBean=objNBTLCBSIntegration.NBTL_Memopad_Integration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime,strCorporateCIF,MemoPadText,socketDetailsMap,activityName);
								NBTLCBSLog.NBTLCBSLogger.debug("objResponseBean.getMemopadReturnCode() "+objResponseBean.getMemopadReturnCode());
								if(!"Success".equals(objResponseBean.getMemopadReturnCode()))
								{
									strIntegrationErrCode="Failure";
									strIntegrationErrRemarks = "Error in Memopad Utility";
									attributesTag="<Decision>"+strIntegrationErrCode+"</Decision>"
											+ "<Remarks>"+strIntegrationErrRemarks+"</Remarks>"
											+ "<MEMO_INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</MEMO_INTEGRATION_ERROR_RECEIVED>";
									NBTLCBSLog.NBTLCBSLogger.debug("objResponseBean.getIntegrationDecision() "+objResponseBean.getMemoIntegrationDecision());
									NBTLCBSLog.NBTLCBSLogger.debug("strIntegrationErrCode "+strIntegrationErrCode);
									DoneWI(cabinetName, jtsIP, jtsPort, smsPort, queueId, sleepIntervalTime, integrationWaitTime, sessionID,  processInstanceID,
											 WorkItemID,  strIntegrationErrCode,  strIntegrationErrRemarks ,attributesTag, RequestType);
									continue;
								}	
								else
								{
									strIntegrationErrCode="Success";
									strIntegrationErrRemarks = "Memopad Integration Successfull";
									NBTLCBSLog.NBTLCBSLogger.debug("objResponseBean.getIntegrationDecision() "+objResponseBean.getMemoIntegrationDecision());
									NBTLCBSLog.NBTLCBSLogger.debug("strIntegrationErrCode "+strIntegrationErrCode);
									String columnNames="Decision,Remarks,MEMO_INTEGRATION_ERROR_RECEIVED";
									String columnValues="'"+strIntegrationErrCode+"','"+strIntegrationErrRemarks+"','"+strIntegrationErrCode+"'";
									String sWhereClause ="WINAME ='"+strWi_name+"' ";
									String apUpdateInput = CommonMethods.apUpdateInput(cabinetName,sessionID,NBTL_EXTTABLE,columnNames,columnValues,
											sWhereClause);
									NBTLCBSLog.NBTLCBSLogger.debug("APUpdate InputXML: "+apUpdateInput);
			
									String apUpdateOutputXML=WFNGExecute(apUpdateInput,jtsIP,jtsPort,1);
									NBTLCBSLog.NBTLCBSLogger.debug("APUpdate OutputXML: "+apUpdateOutputXML);
			
									XMLParser apUpdateOutputXMLxmlParser= new XMLParser(apUpdateOutputXML);
									String apUpdateOutputXMLMainCode = apUpdateOutputXMLxmlParser.getValueOf("MainCode");
									NBTLCBSLog.NBTLCBSLogger.debug("MainCode: "+apUpdateOutputXMLMainCode);
			
									
									if(apUpdateOutputXMLMainCode.equalsIgnoreCase("0"))
									{
										NBTLCBSLog.NBTLCBSLogger.debug("Last Memopad status updated in database");
										//inserting into history table
										SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
										SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

										Date actionDateTime= new Date();
										String formattedActionDateTime=outputDateFormat.format(actionDateTime);
										NBTLCBSLog.NBTLCBSLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

										//Insert in WIHistory Table.
										String columnNames1="WINAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,REMARKS";
										String columnValues1="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
										+CommonConnection.getUsername()+"','"+strIntegrationErrCode+"','"+strIntegrationErrRemarks+"'";

										String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames1, columnValues1,NBTL_WIHISTORY);
										NBTLCBSLog.NBTLCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

										String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
												jtsPort,1);
										NBTLCBSLog.NBTLCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

										XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
										String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
										NBTLCBSLog.NBTLCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
										if(apInsertMaincode.equalsIgnoreCase("0"))
										{
											NBTLCBSLog.NBTLCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
											NBTLCBSLog.NBTLCBSLogger.debug("Inserted in WiHistory table successfully.");
										}
										else
										{
											NBTLCBSLog.NBTLCBSLogger.error("ApInsert failed: "+apInsertMaincode);
										}
									}
								}
							}
							if(!"Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED))
							{
								ResponseBean objResponseBean1=objNBTLCBSIntegration.NBTLCBS_CifUpdateIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime,strCorporateCIF,strToBeTLNo,strToBeExpiryDate,KYC_ReviewDate,INTEGRATION_ERROR_RECEIVED,socketDetailsMap,strWi_name,activityName,ThresholdYear,year,PrevOPSReviewDec);
								
								if("Success".equals(objResponseBean1.getCifUpdateReturnCode()))
								{
									strIntegrationErrCode="Success";
									strIntegrationErrRemarks="Cif Update Successfull";
								}	
								else if("CIF_UnderVerification".equals(objResponseBean1.getCifUpdateReturnCode()))
								{
									strIntegrationErrCode="Failure";
									strIntegrationErrRemarks="CIF UNDER VERIFICATION";
								}
								else
								{
									strIntegrationErrCode="Failure";
									strIntegrationErrRemarks="Error in Cif Update";
								}
								NBTLCBSLog.NBTLCBSLogger.debug("objResponseBean.getIntegrationDecision() "+objResponseBean1.getIntegrationDecision());
								NBTLCBSLog.NBTLCBSLogger.debug("strIntegrationErrCode "+strIntegrationErrCode);
								
								attributesTag="<Decision>"+strIntegrationErrCode+"</Decision>"
										+ "<Remarks>"+strIntegrationErrRemarks+"</Remarks>"
										+ "<INTEGRATION_ERROR_RECEIVED>"+strIntegrationErrCode+"</INTEGRATION_ERROR_RECEIVED>";
			
								DoneWI(cabinetName, jtsIP, jtsPort, smsPort, queueId, sleepIntervalTime, integrationWaitTime, sessionID,  processInstanceID,
										 WorkItemID,  strIntegrationErrCode,  strIntegrationErrRemarks ,attributesTag, RequestType);
								
							}
						}
						else // means required calls are success
						{
							strIntegrationErrCode="Success";
							strIntegrationErrRemarks="Cif Update Successfull";
							attributesTag="<Decision>"+strIntegrationErrCode+"</Decision>";
							DoneWI(cabinetName, jtsIP, jtsPort, smsPort, queueId, sleepIntervalTime, integrationWaitTime, sessionID,  processInstanceID,
									 WorkItemID,  strIntegrationErrCode,  strIntegrationErrRemarks ,attributesTag, RequestType);
							
						}
				
			}
		}

	}
}
		catch(Exception e)
		{
			NBTLCBSLog.NBTLCBSLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTLCBSLog.NBTLCBSLogger.error("Exception Occurred in NBTL CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}
	
	public static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		NBTLCBSLog.NBTLCBSLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientNBTLCBS.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			NBTLCBSLog.NBTLCBSLogger.error("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	public static HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
			String sessionID )
	{
		HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

		try
		{
			ngEjbClientNBTLCBS = NGEjbClient.getSharedInstance();
			NBTLCBSLog.NBTLCBSLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'NBTL' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			NBTLCBSLog.NBTLCBSLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			NBTLCBSLog.NBTLCBSLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			NBTLCBSLog.NBTLCBSLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			NBTLCBSLog.NBTLCBSLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				NBTLCBSLog.NBTLCBSLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				NBTLCBSLog.NBTLCBSLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				NBTLCBSLog.NBTLCBSLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			NBTLCBSLog.NBTLCBSLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
	private void DoneWI(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID, String processInstanceID,
			String WorkItemID, String Decision, String Remarks, String attributesTag, String RequestType) throws IOException, Exception{
		getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
		getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

		NBTLCBSLog.NBTLCBSLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

		xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
		getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

		if("0".equals(getWorkItemMainCode))
		{
			NBTLCBSLog.NBTLCBSLogger.info("get Workitem call successfull for "+processInstanceID);

			String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
					processInstanceID,WorkItemID,attributesTag);
			NBTLCBSLog.NBTLCBSLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

			String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
					jtsPort,1);
			NBTLCBSLog.NBTLCBSLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

			XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

			String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
			if("0".equals(mainCodeAssignAtt.trim()))
			{
				String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
						processInstanceID,WorkItemID);

				NBTLCBSLog.NBTLCBSLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

				NBTLCBSLog.NBTLCBSLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

				String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
				NBTLCBSLog.NBTLCBSLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

				XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
				String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
				NBTLCBSLog.NBTLCBSLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

				if("0".equals(completeWorkitemMaincode))
				{
					//inserting into history table
					NBTLCBSLog.NBTLCBSLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
					System.out.println(processInstanceID + "Complete Succesfully with status ");

					NBTLCBSLog.NBTLCBSLogger.debug("WorkItem moved to next Workstep.");

					SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

					Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
					String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
					NBTLCBSLog.NBTLCBSLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

					Date actionDateTime= new Date();
					String formattedActionDateTime=outputDateFormat.format(actionDateTime);
					NBTLCBSLog.NBTLCBSLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

					//Insert in WIHistory Table.
					String columnNames="WINAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
					String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
					+CommonConnection.getUsername()+"','"+Decision+"','"+formattedEntryDatetime+"','"+Remarks+"'";

					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,NBTL_WIHISTORY);
					NBTLCBSLog.NBTLCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

					String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
							jtsPort,1);
					NBTLCBSLog.NBTLCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					NBTLCBSLog.NBTLCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						NBTLCBSLog.NBTLCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
						NBTLCBSLog.NBTLCBSLogger.debug("Inserted in WiHistory table successfully.");
						//call..to do for STP only
						if("STP".equalsIgnoreCase(RequestType)){
							sendCommunication(processInstanceID,cabinetName, sessionID, jtsIP, jtsPort);
						}
					}
					else
					{
						NBTLCBSLog.NBTLCBSLogger.error("ApInsert failed: "+apInsertMaincode);
					}
				}
				else
				{
					NBTLCBSLog.NBTLCBSLogger.error("Error in completeWI call for "+processInstanceID);
				}
			}
			else
			{
				NBTLCBSLog.NBTLCBSLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
			}


		}
		else
		{
			NBTLCBSLog.NBTLCBSLogger.error("Error in getWI call for WI "+processInstanceID);
		}
	}
	private String sendEmail(String processInstanceID,String mailTo,String cabinetName, String sessionID,String jtsIP,String jtsPort)
	{
		try{
		
		int mailPriority= 1;
		String mailStatus = "N";
		String UserNAme = "rakbpm";
		String mailActionType = "TRIGGER";
		String mailContentType = "text/html;charset=UTF-8";
		String wiName = processInstanceID;
		int workitemid = 1;
		int activityID = 3;
		int noOfTrials = 0;
		
		String query = "select * from USR_0_NBTL_TemplateMapping where TemplateType = 'Approved'";
		
		String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
		NBTLCBSLog.NBTLCBSLogger.debug("Socket Details APSelect InputXML: "+apSelectInputXML);

		String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
		NBTLCBSLog.NBTLCBSLogger.debug("Socket Details APSelect OutputXML: "+apSelectOutputXML);

		XMLParser xmlParser= new XMLParser(apSelectOutputXML);
		String MainCode = xmlParser.getValueOf("MainCode");
		NBTLCBSLog.NBTLCBSLogger.debug("MainCode: "+MainCode);

		int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
		NBTLCBSLog.NBTLCBSLogger.debug("TotalRecords: "+TotalRecords);
		
		if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
		{
			mailSubject=xmlParser.getValueOf("MailSubject");
			NBTLCBSLog.NBTLCBSLogger.debug("mailSubject: "+mailSubject);
			
			mailFrom=xmlParser.getValueOf("FromMail");
			NBTLCBSLog.NBTLCBSLogger.debug("mailFrom: "+mailFrom);
			
			emailBody=xmlParser.getValueOf("MailTemplate");
			NBTLCBSLog.NBTLCBSLogger.debug("emailBody: "+emailBody);
		}
		emailBody = emailBody.replaceAll("#WI_No#", wiName);
		mailSubject = mailSubject.replaceAll("#WI_No#", wiName);
		
		String tableName = "WFMAILQUEUETABLE";
		String columnName = "mailFrom,mailTo,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,insertedBy,"
				+ "mailActionType,processInstanceId,workitemId,activityId,noOfTrials";
		String values = "'"+mailFrom+"','"+mailTo+"','"+mailSubject+"',N'"+emailBody+"','"+mailContentType+"','"+mailPriority+"','"+mailStatus+"','"
				+CommonConnection.getUsername()+"','"+mailActionType+"','"+wiName+"','"+workitemid+"','"+activityID+"','"+noOfTrials+"'";
		String mailInsertQuery = "Insert into " +tableName+" "+columnName+" values "+values;
		
		String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName, values,tableName);
		NBTLCBSLog.NBTLCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

		String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
				jtsPort,1);
		NBTLCBSLog.NBTLCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

		XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
		String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
		NBTLCBSLog.NBTLCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
		if(apInsertMaincode.equalsIgnoreCase("0"))
		{
			NBTLCBSLog.NBTLCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
			NBTLCBSLog.NBTLCBSLogger.debug("Mail sent successfully.");
			return "true";
		}
		}catch(Exception e){
			
		}
		return "false";
	}
	
	private String sendSMS(String processInstanceID,String MobileNumber,String cabinetName, String sessionID,String jtsIP,String jtsPort)
	{
		try{
			
			String AlertName = "STP_Approved";
			String AlertCode = "NBTL";
			String AlertStatus = "P";
			String AlertSubject = "Communication";
			String txtMessage="";
			
			String query = "select * from USR_0_NBTL_TemplateMapping where TemplateType = 'Approved'";
			
			String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			NBTLCBSLog.NBTLCBSLogger.debug("SMS APSelect InputXML: "+apSelectInputXML);

			String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
			NBTLCBSLog.NBTLCBSLogger.debug("SMS APSelect OutputXML: "+apSelectOutputXML);

			XMLParser xmlParser= new XMLParser(apSelectOutputXML);
			String MainCode = xmlParser.getValueOf("MainCode");
			NBTLCBSLog.NBTLCBSLogger.debug("MainCode: "+MainCode);

			int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
			NBTLCBSLog.NBTLCBSLogger.debug("TotalRecords: "+TotalRecords);
			
			if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
			{
				txtMessage=xmlParser.getValueOf("SMStxtTemplate");
				NBTLCBSLog.NBTLCBSLogger.debug("txtMessage: "+txtMessage);
				
			}
			txtMessage = txtMessage.replaceAll("#WI_No#", processInstanceID);
			
			String tableName = "USR_0_BPM_SMSQUEUETABLE";
			String columnName = "ALERT_Name,Alert_Code,Alert_Status,Mobile_No,Alert_Text,Alert_Subject,WI_Name,Workstep_Name,Inserted_Date";
			String values =  "'"+AlertName+"','"+AlertCode+"','"+AlertStatus+"','"+MobileNumber+"','"+txtMessage+"','"+AlertSubject+"','"+processInstanceID+"','"+activityName+"',getdate() ";
			
			String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName, values,tableName);
			NBTLCBSLog.NBTLCBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

			String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
					jtsPort,1);
			NBTLCBSLog.NBTLCBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

			XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
			String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
			NBTLCBSLog.NBTLCBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
			if(apInsertMaincode.equalsIgnoreCase("0"))
			{
				NBTLCBSLog.NBTLCBSLogger.debug("ApInsert successful: "+apInsertMaincode);
				NBTLCBSLog.NBTLCBSLogger.debug("SMS sent successfully.");
				return "true";
			}
		}catch(Exception e){
			NBTLCBSLog.NBTLCBSLogger.debug("Exception in sending SMS----"+e);
		}
		return "false";
		}
	private String sendCommunication(String processInstanceID, String cabinetName, String sessionID,String jtsIP,String jtsPort)
	{
		try{
		String query = "select EmailAddress,mobileNo from RB_NBTL_EXTTABLE where WINAME = '"+processInstanceID+"'";
		
		String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
		NBTLCBSLog.NBTLCBSLogger.debug("Socket Details APSelect InputXML: "+apSelectInputXML);

		String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
		NBTLCBSLog.NBTLCBSLogger.debug("Socket Details APSelect OutputXML: "+apSelectOutputXML);

		XMLParser xmlParser= new XMLParser(apSelectOutputXML);
		String MainCode = xmlParser.getValueOf("MainCode");
		NBTLCBSLog.NBTLCBSLogger.debug("MainCode: "+MainCode);

		int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
		NBTLCBSLog.NBTLCBSLogger.debug("TotalRecords: "+TotalRecords);
		
		String mailTo = "";
		String mobileNo = "";
		if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
		{
			mailTo=xmlParser.getValueOf("EmailAddress");
			NBTLCBSLog.NBTLCBSLogger.debug("mailTo: "+mailTo);
			
			mobileNo=xmlParser.getValueOf("MobileNo");
			NBTLCBSLog.NBTLCBSLogger.debug("mobileNo: "+mobileNo);
			
		}
				String res = sendEmail(processInstanceID,mailTo, cabinetName,  sessionID, jtsIP, jtsPort);
				String SMSres = sendSMS(processInstanceID,mobileNo, cabinetName,  sessionID, jtsIP, jtsPort);
				NBTLCBSLog.NBTLCBSLogger.debug("Mail Send Status "+res);
				NBTLCBSLog.NBTLCBSLogger.debug("Sms Send Status: "+SMSres);
		}
		catch(Exception e){
			NBTLCBSLog.NBTLCBSLogger.debug("Exception occured in sendCommunication: "+e);
		}
		return "";
	}
	
}
