package com.newgen.NBTL.Hold;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.newgen.NBTL.CBS.NBTLCBSIntegration;
import com.newgen.NBTL.CBS.NBTLCBSLog;
import com.newgen.NBTL.CBS.ResponseBean;
import com.newgen.NBTL.CBS.CustomerBean;
import com.newgen.NBTL.CBS.NBTLCBS;
import com.newgen.NBTL.Hold.NBTLHoldLog;
import com.newgen.NBTL.StatusUpdate.NBTL_StatusUpdate_Log;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class NBTLHold implements Runnable{
	private String NBTL_WIHISTORY="USR_0_NBTL_WIHISTORY";
	
	private static NGEjbClient ngEjbClientNBTLHold;
	static Map<String, String> NBTLHoldConfigParamMap= new HashMap<String, String>();
	String count="";
	String emailBody = "";
	String mailFrom = "";
	String mailSubject = "";
	private String strIntegrationErrCode="";
	private String strIntegrationErrRemarks="";
	private String NBTL_EXTTABLE = "RB_NBTL_EXTTABLE";
	private String serviceType="";
	private String requestType="";
	private String activityName = "";
	private String INTEGRATION_WAIT_TIME = "";
	private int ThresholdYear=0;
	private int dayDiffThreshold=0;
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
			NBTLHoldLog.setLogger();
			ngEjbClientNBTLHold = NGEjbClient.getSharedInstance();

			NBTLHoldLog.NBTLHoldLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			NBTLHoldLog.NBTLHoldLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				NBTLHoldLog.NBTLHoldLogger.error("Could not Read Config Properties [NBTL CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			NBTLHoldLog.NBTLHoldLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			NBTLHoldLog.NBTLHoldLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			NBTLHoldLog.NBTLHoldLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			NBTLHoldLog.NBTLHoldLogger.debug("SMSPort: " + smsPort);
			

			queueID = NBTLHoldConfigParamMap.get("QueueID");
			NBTLHoldLog.NBTLHoldLogger.debug("QueueID: " + queueID);
			
			requestType = NBTLHoldConfigParamMap.get("RequestType");
			NBTLHoldLog.NBTLHoldLogger.debug("requestType: " + requestType);
			
			integrationWaitTime = Integer.parseInt(NBTLHoldConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			NBTLHoldLog.NBTLHoldLogger.debug("INTEGRATION_WAIT_TIME: " + integrationWaitTime);
			
			ThresholdYear=Integer.parseInt(NBTLHoldConfigParamMap.get("ThresholdYear"));
			NBTLHoldLog.NBTLHoldLogger.debug("ThresholdYear: "+ThresholdYear);
			
			dayDiffThreshold=Integer.parseInt(NBTLHoldConfigParamMap.get("dayDiffThreshold"));
			NBTLHoldLog.NBTLHoldLogger.debug("dayDiffThreshold: "+dayDiffThreshold);

			sleepIntervalInMin=Integer.parseInt(NBTLHoldConfigParamMap.get("SleepIntervalInMin"));
			NBTLHoldLog.NBTLHoldLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(NBTLHoldLog.NBTLHoldLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				NBTLHoldLog.NBTLHoldLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				
				while (true)
				{
					NBTLHoldLog.setLogger();
					NBTLHoldLog.NBTLHoldLogger.debug("NBTL CBS....");
					startNBTLHoldUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,sleepIntervalInMin,integrationWaitTime,sessionID);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			NBTLHoldLog.NBTLHoldLogger.error("Exception Occurred in NBTL CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTLHoldLog.NBTLHoldLogger.error("Exception Occurred in NBTL CBS : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "NBTL_Hold_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    NBTLHoldConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	
	
	
	private void startNBTLHoldUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID)
	{
		final String ws_name="Sys_Hold";
		try
		{
			sessionID  = CommonConnection.getSessionID(NBTLHoldLog.NBTLHoldLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				NBTLHoldLog.NBTLHoldLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			NBTLHoldLog.NBTLHoldLogger.debug("Fetching all Workitems at System hold queue");
			System.out.println("Fetching all WIs at System hold");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			NBTLHoldLog.NBTLHoldLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			NBTLHoldLog.NBTLHoldLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			NBTLHoldLog.NBTLHoldLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);
			//fetchWorkItemListMainCode="0";
			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			NBTLHoldLog.NBTLHoldLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);
			//fetchWorkitemListCount=1;
			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					NBTLHoldLog.NBTLHoldLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					NBTLHoldLog.NBTLHoldLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					NBTLHoldLog.NBTLHoldLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					NBTLHoldLog.NBTLHoldLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					NBTLHoldLog.NBTLHoldLogger.debug("Current EntryDateTime: "+entryDateTime);
					
					activityName=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					NBTLHoldLog.NBTLHoldLogger.debug("Current ActivityName: "+activityName);

					
					String queryHold="select top 1 * from (select TLE.WI_NAME,q.entryDATETIME as EntryDateTime ,'TL' as ProcessName"
                            + ",'' as serviceType from RB_TL_EXTTABLE TLE with(nolock),QUEUEVIEW Q with(nolock)"
                            + " where TLE.WI_NAME=q.processinstanceid and TLE.TL_Num=(select ExistingTLNo from "
                            + "RB_NBTL_EXTTABLE with(nolock) where WINAME='"+processInstanceID+"') and TLE.Current_WS"
                            + "='Exit' and q.IntroductionDateTime between DATEADD(MONTH,-2,"
                            + "(select EntryAt from RB_NBTL_EXTTABLE with(nolock)where WINAME="
                            + "'"+processInstanceID+"')) and DATEADD(day,90,(select EntryAt from "
                            + "RB_NBTL_EXTTABLE with(nolock) where WINAME='"+processInstanceID+"')) "
                            + " union select WI_NAME,ENTRYAT as EntryDateTime,'PC' as ProcessName,SERVICE_REQUEST_SELECTED as serviceType "
                            + " from RB_PC_EXTTABLE with(nolock) where TRADE_LICENSE=(select ExistingTLNo from RB_NBTL_EXTTABLE with(nolock) "
                            + "where WINAME='"+processInstanceID+"') and Current_WS='Exit' or Current_WS='Archival' and IntoducedAt between DATEADD"
                            + "(MONTH,-2,(select EntryAt from RB_NBTL_EXTTABLE with(nolock) where WINAME='"+processInstanceID+"')) and Dateadd(day,90,"
                            + "(select EntryAt from RB_NBTL_EXTTABLE with(nolock)where WINAME='"+processInstanceID+"'))) as temp order by EntryDateTime";

					String apSelectInputXML =CommonMethods.apSelectWithColumnNames(queryHold, cabinetName, sessionID);
					NBTLHoldLog.NBTLHoldLogger.debug("Socket Details APSelect InputXML: "+apSelectInputXML);

					String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
					NBTLHoldLog.NBTLHoldLogger.debug("Socket Details APSelect OutputXML: "+apSelectOutputXML);

					XMLParser xmlParser= new XMLParser(apSelectOutputXML);
					String MainCode = xmlParser.getValueOf("MainCode");
					NBTLHoldLog.NBTLHoldLogger.debug("SocketDetailsMainCode: "+MainCode);

					int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
					NBTLHoldLog.NBTLHoldLogger.debug("SocketDetailsTotalRecords: "+TotalRecords);
					
					boolean flag = false;
					if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
					{
						if("PC".equalsIgnoreCase(xmlParser.getValueOf("ProcessName")))
						{
							serviceType=xmlParser.getValueOf("serviceType");
	                        NBTLHoldLog.NBTLHoldLogger.debug("serviceType: "+serviceType);
	                        String[] splitServiceType = serviceType.split("\\|");
	                        for(int k = 0; k<splitServiceType.length;k++)
	                        {
	                          if(!requestType.contains(splitServiceType[k]))
	                          {
	                            flag = true;
	                            break;
	                          }
	                        }
						}
						else
							flag =true;
						
					}
						
					SimpleDateFormat Dateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					
					Date entryDatetimeparsed = Dateformat.parse(entryDateTime);
					Date currentDateTime= new Date();
					
					long DayDifferinMilliSec = Math.abs(currentDateTime.getTime() - entryDatetimeparsed.getTime());
					long dayDiffer = TimeUnit.DAYS.convert(DayDifferinMilliSec, TimeUnit.MILLISECONDS);
					
					String attributesTag="";
					if(flag)
					{

						HashMap<String, String> socketDetailsMap= NBTLCBS.socketConnectionDetails(cabinetName, jtsIP, jtsPort,
								sessionID);
						String QueryString="SELECT WINAME,ToBeTLNo,CorporateCIF,ToBeExpiryDate,"
								+ "INTEGRATION_ERROR_RECEIVED,CifUpdateSecondCall,RequestType,PrevOPSReviewDec"
								+ " FROM "+NBTL_EXTTABLE+" with (nolock) where WINAME='"+processInstanceID+"'";


						String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
						NBTLHoldLog.NBTLHoldLogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

						String sOutputXML=NBTLCBS.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
						NBTLHoldLog.NBTLHoldLogger.debug("Output XML for external Table select "+sOutputXML);

						XMLParser sXMLParser= new XMLParser(sOutputXML);
					    String sMainCode = sXMLParser.getValueOf("MainCode");
					    NBTLHoldLog.NBTLHoldLogger.debug("SMainCode: "+sMainCode);

					    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
					    NBTLHoldLog.NBTLHoldLogger.debug("STotalRecords: "+sTotalRecords);

						if (sMainCode.equals("0") && sTotalRecords > 0)
						{
							NBTLHoldLog.NBTLHoldLogger.debug("Inside If block");
							
							String strWi_name=sXMLParser.getValueOf("winame");
							NBTLHoldLog.NBTLHoldLogger.debug("strWi_name "+strWi_name);
							
							String ToBeTLNo=sXMLParser.getValueOf("ToBeTLNo");
							NBTLHoldLog.NBTLHoldLogger.debug("ToBeTLNo "+ToBeTLNo);
							
							String CorporateCIF=sXMLParser.getValueOf("CorporateCIF");
							NBTLHoldLog.NBTLHoldLogger.debug("CorporateCIF "+CorporateCIF);
							
							String RequestType=sXMLParser.getValueOf("RequestType");
							NBTLHoldLog.NBTLHoldLogger.debug("RequestType "+RequestType);
							
							String INTEGRATION_ERROR_RECEIVED=sXMLParser.getValueOf("INTEGRATION_ERROR_RECEIVED");
							if(INTEGRATION_ERROR_RECEIVED == null){
								INTEGRATION_ERROR_RECEIVED = "";
							}
							NBTLHoldLog.NBTLHoldLogger.debug("INTEGRATION_ERROR_RECEIVED "+INTEGRATION_ERROR_RECEIVED);
							
							String PrevOPSReviewDec =sXMLParser.getValueOf("PrevOPSReviewDec");
							if(PrevOPSReviewDec == null)
							{
								PrevOPSReviewDec = "";
							}
							NBTLHoldLog.NBTLHoldLogger.debug("PrevOPSReviewDec "+PrevOPSReviewDec);
							
							String CifUpdateSecondCall=sXMLParser.getValueOf("CifUpdateSecondCall");
							if(CifUpdateSecondCall == null){
								CifUpdateSecondCall = "";
							}
							NBTLHoldLog.NBTLHoldLogger.debug("CifUpdateSecondCall "+CifUpdateSecondCall);
							
							SimpleDateFormat outputdateFormat = new SimpleDateFormat("yyyy-MM-dd");
							Date d = outputdateFormat.parse(sXMLParser.getValueOf("ToBeExpiryDate"));
							String strToBeExpiryDate= outputdateFormat.format(d);
							int year = Integer.parseInt(strToBeExpiryDate.substring(0,4));
							NBTLHoldLog.NBTLHoldLogger.debug("strToBeExpiryDate "+strToBeExpiryDate);
							
							Date date = new Date();
							String KYC_ReviewDate  = outputdateFormat.format(date);
							
							if("Success".equalsIgnoreCase(INTEGRATION_ERROR_RECEIVED) && !"Success".equalsIgnoreCase(CifUpdateSecondCall)){
								ResponseBean objResponseBean=objNBTLCBSIntegration.NBTLCBS_CifUpdateIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime,CorporateCIF,ToBeTLNo,strToBeExpiryDate,KYC_ReviewDate,INTEGRATION_ERROR_RECEIVED,socketDetailsMap,strWi_name,activityName,ThresholdYear,year,PrevOPSReviewDec);
								NBTLHoldLog.NBTLHoldLogger.debug("return code Cif Update Second Call" + objResponseBean.getCifUpdateReturnCode());
								if("Success".equals(objResponseBean.getCifUpdateReturnCode()))
								{
									strIntegrationErrCode="Success";
									strIntegrationErrRemarks="Cif Update Second Call Successfull";
									attributesTag="<Decision>"+"Completed"+"</Decision>"
									+ "<Remarks>"+strIntegrationErrRemarks+"</Remarks>"
									+ "<CifUpdateSecondCall>"+strIntegrationErrCode+"</CifUpdateSecondCall>";
									NBTLHoldLog.NBTLHoldLogger.debug("Success in Cif Update Second Call");
								}else{
									strIntegrationErrCode="Failure";
									strIntegrationErrRemarks="Error in Cif Update Second Call";
									NBTLHoldLog.NBTLHoldLogger.debug("Error in Cif Update Second Call");
									attributesTag="<Decision>"+"Failure"+"</Decision>"
											+ "<Remarks>"+strIntegrationErrRemarks+"</Remarks>"
											+ "<CifUpdateSecondCall>"+strIntegrationErrCode+"</CifUpdateSecondCall>";
								}	
									//
									String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
									String getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);
				
									NBTLHoldLog.NBTLHoldLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);
				
									XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
									String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
				
									if("0".equals(getWorkItemMainCode))
									{
										NBTLHoldLog.NBTLHoldLogger.info("get Workitem call successfull for "+processInstanceID);
										String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
												processInstanceID,WorkItemID,attributesTag);
										NBTLHoldLog.NBTLHoldLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);
				
										String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
												jtsPort,1);
										NBTLHoldLog.NBTLHoldLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);
				
										XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);
				
										String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
										if("0".equals(mainCodeAssignAtt.trim()))
										{
											String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
													processInstanceID,WorkItemID);
				
											NBTLHoldLog.NBTLHoldLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);
				
											NBTLHoldLog.NBTLHoldLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);
				
											String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
											NBTLHoldLog.NBTLHoldLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);
				
											XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
											String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
											NBTLHoldLog.NBTLHoldLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);
				
											if("0".equals(completeWorkitemMaincode))
											{
												//inserting into history table
												NBTLHoldLog.NBTLHoldLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
												System.out.println(processInstanceID + "Routed Back Completed Succesfully ");
				
												NBTLHoldLog.NBTLHoldLogger.debug("WorkItem moved to next Workstep.");
				
												SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
												SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				
												Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
												String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
												NBTLHoldLog.NBTLHoldLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
				
												Date actionDateTime= new Date();
												String formattedActionDateTime=outputDateFormat.format(actionDateTime);
												NBTLHoldLog.NBTLHoldLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);
				
												//Insert in WIHistory Table.
												//String Remarks = "WorkItem Released from hold";
												String columnNames="WINAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
												String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
												+CommonConnection.getUsername()+"','"+strIntegrationErrCode+"','"+formattedEntryDatetime+"','"+strIntegrationErrRemarks+"'";
				
												String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,NBTL_WIHISTORY);
												NBTLHoldLog.NBTLHoldLogger.debug("APInsertInputXML: "+apInsertInputXML);
				
												String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
														jtsPort,1);
												NBTLHoldLog.NBTLHoldLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);
				
												XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
												String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
												NBTLHoldLog.NBTLHoldLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
												if(apInsertMaincode.equalsIgnoreCase("0"))
												{
													NBTLHoldLog.NBTLHoldLogger.debug("ApInsert successful: "+apInsertMaincode);
													NBTLHoldLog.NBTLHoldLogger.debug("Inserted in WiHistory table successfully.");
												}
												else
												{
													NBTLHoldLog.NBTLHoldLogger.error("ApInsert failed: "+apInsertMaincode);
												}
											}
											else
											{
												NBTLHoldLog.NBTLHoldLogger.error("Error in completeWI call for "+processInstanceID);
											}
										}
										else
										{
											NBTLHoldLog.NBTLHoldLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
										}
									}
									else
									{
										NBTLHoldLog.NBTLHoldLogger.error("Error in getWI call for WI "+processInstanceID);
									}
							}
						}
					}
					else
					{
						sendCommunication(processInstanceID,cabinetName, sessionID, jtsIP, jtsPort);
					}
																				
				}
			}

		}
		catch(Exception e)
		{
			NBTLHoldLog.NBTLHoldLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTLHoldLog.NBTLHoldLogger.error("Exception Occurred in NBTL CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}
	
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		NBTLHoldLog.NBTLHoldLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientNBTLHold.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			NBTLHoldLog.NBTLHoldLogger.error("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	
	private String sendCommunication(String processInstanceID, String cabinetName, String sessionID,String jtsIP,String jtsPort)
	{
		try{
		String query = "select datediff(day,LastCommunicationDate,getdate()) as dayDif,EmailAddress,mobileNo from RB_NBTL_EXTTABLE with(nolock) where WINAME = '"+processInstanceID+"'";
		
		String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
		NBTLHoldLog.NBTLHoldLogger.debug("Socket Details APSelect InputXML: "+apSelectInputXML);

		String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
		NBTLHoldLog.NBTLHoldLogger.debug("Socket Details APSelect OutputXML: "+apSelectOutputXML);

		XMLParser xmlParser= new XMLParser(apSelectOutputXML);
		String MainCode = xmlParser.getValueOf("MainCode");
		NBTLHoldLog.NBTLHoldLogger.debug("MainCode: "+MainCode);

		int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
		NBTLHoldLog.NBTLHoldLogger.debug("TotalRecords: "+TotalRecords);
		
		String daydiff = "";
		String mailTo = "";
		String mobileNo = "";
		if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
		{
			daydiff=xmlParser.getValueOf("dayDif");
			NBTLHoldLog.NBTLHoldLogger.debug("daydiff: "+daydiff);
			
			mailTo=xmlParser.getValueOf("EmailAddress");
			NBTLHoldLog.NBTLHoldLogger.debug("mailTo: "+mailTo);
			
			mobileNo=xmlParser.getValueOf("MobileNo");
			NBTLHoldLog.NBTLHoldLogger.debug("mobileNo: "+mobileNo);
			
		}
			int daydifference = Integer.parseInt(daydiff);
			if(daydifference >= dayDiffThreshold)
			{
				String res = sendEmail(processInstanceID,mailTo, cabinetName,  sessionID, jtsIP, jtsPort);
				String SMSres = sendSMS(processInstanceID,mobileNo, cabinetName,  sessionID, jtsIP, jtsPort);
				if ("true".equalsIgnoreCase(res))
				{
					String whereClause = "WINAME = '"+processInstanceID+"'";
					String apUpdateInput =CommonMethods.apUpdateInput(cabinetName, sessionID,"RB_NBTL_EXTTABLE","LastCommunicationDate","getDate()",whereClause);
					NBTLHoldLog.NBTLHoldLogger.debug("APUpdate InputXML: "+apUpdateInput);

					String apUpdateOutputXML=WFNGExecute(apUpdateInput,jtsIP,jtsPort,1);
					NBTLHoldLog.NBTLHoldLogger.debug("APUpdate OutputXML: "+apUpdateOutputXML);

					XMLParser apUpdateOutputXMLxmlParser= new XMLParser(apUpdateOutputXML);
					String apUpdateOutputXMLMainCode = apUpdateOutputXMLxmlParser.getValueOf("MainCode");
					NBTLHoldLog.NBTLHoldLogger.debug("MainCode: "+apUpdateOutputXMLMainCode);

					int apUpdateOutputXMLTotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
					NBTLHoldLog.NBTLHoldLogger.debug("TotalRecords: "+apUpdateOutputXMLTotalRecords);
					
					if(apUpdateOutputXMLMainCode.equalsIgnoreCase("0")&& TotalRecords>0)
					{
						NBTLHoldLog.NBTLHoldLogger.debug("TotalRecords: "+apUpdateOutputXMLTotalRecords);
						NBTLHoldLog.NBTLHoldLogger.debug("Last Communication updated in database");

					}
				}
			}
		
		}
		catch(Exception e){
			NBTLHoldLog.NBTLHoldLogger.debug("Exception occured in sendCommunication: "+e);
		}
		return "";
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
		
		String query = "select * from USR_0_NBTL_TemplateMapping where TemplateType = 'Reminder'";
		
		String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
		NBTLHoldLog.NBTLHoldLogger.debug("Socket Details APSelect InputXML: "+apSelectInputXML);

		String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
		NBTLHoldLog.NBTLHoldLogger.debug("Socket Details APSelect OutputXML: "+apSelectOutputXML);

		XMLParser xmlParser= new XMLParser(apSelectOutputXML);
		String MainCode = xmlParser.getValueOf("MainCode");
		NBTLHoldLog.NBTLHoldLogger.debug("MainCode: "+MainCode);

		int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
		NBTLHoldLog.NBTLHoldLogger.debug("TotalRecords: "+TotalRecords);
		
		if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
		{
			mailSubject=xmlParser.getValueOf("MailSubject");
			NBTLHoldLog.NBTLHoldLogger.debug("mailSubject: "+mailSubject);
			
			mailFrom=xmlParser.getValueOf("FromMail");
			NBTLHoldLog.NBTLHoldLogger.debug("mailFrom: "+mailFrom);
			
			emailBody=xmlParser.getValueOf("MailTemplate");
			NBTLHoldLog.NBTLHoldLogger.debug("emailBody: "+emailBody);
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
		NBTLHoldLog.NBTLHoldLogger.debug("APInsertInputXML: "+apInsertInputXML);

		String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
				jtsPort,1);
		NBTLHoldLog.NBTLHoldLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

		XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
		String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
		NBTLHoldLog.NBTLHoldLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
		if(apInsertMaincode.equalsIgnoreCase("0"))
		{
			NBTLHoldLog.NBTLHoldLogger.debug("ApInsert successful: "+apInsertMaincode);
			NBTLHoldLog.NBTLHoldLogger.debug("Mail sent successfully.");
			return "true";
		}
		}catch(Exception e){
			
		}
		return "false";
	}
	
	private String sendSMS(String processInstanceID,String MobileNumber,String cabinetName, String sessionID,String jtsIP,String jtsPort)
	{
		try{
			
			String AlertName = "Reminder";
			String AlertCode = "NBTL";
			String AlertStatus = "P";
			String AlertSubject = "Communication";
			String txtMessage="";
			
			String query = "select * from USR_0_NBTL_TemplateMapping where TemplateType = 'Reminder'";
			
			String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			NBTLHoldLog.NBTLHoldLogger.debug("SMS APSelect InputXML: "+apSelectInputXML);

			String apSelectOutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
			NBTLHoldLog.NBTLHoldLogger.debug("SMS APSelect OutputXML: "+apSelectOutputXML);

			XMLParser xmlParser= new XMLParser(apSelectOutputXML);
			String MainCode = xmlParser.getValueOf("MainCode");
			NBTLHoldLog.NBTLHoldLogger.debug("MainCode: "+MainCode);

			int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
			NBTLHoldLog.NBTLHoldLogger.debug("TotalRecords: "+TotalRecords);
			
			if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
			{
				txtMessage=xmlParser.getValueOf("SMStxtTemplate");
				NBTLHoldLog.NBTLHoldLogger.debug("txtMessage: "+txtMessage);
				
			}
			txtMessage = txtMessage.replaceAll("#WI_No#", processInstanceID);
			
			String tableName = "USR_0_BPM_SMSQUEUETABLE";
			String columnName = "ALERT_Name,Alert_Code,Alert_Status,Mobile_No,Alert_Text,Alert_Subject,WI_Name,Workstep_Name,Inserted_Date";
			String values =  "'"+AlertName+"','"+AlertCode+"','"+AlertStatus+"','"+MobileNumber+"','"+txtMessage+"','"+AlertSubject+"','"+processInstanceID+"','"+activityName+"',getdate() ";
			
			String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName, values,tableName);
			NBTLHoldLog.NBTLHoldLogger.debug("APInsertInputXML: "+apInsertInputXML);

			String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
					jtsPort,1);
			NBTLHoldLog.NBTLHoldLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

			XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
			String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
			NBTLHoldLog.NBTLHoldLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
			if(apInsertMaincode.equalsIgnoreCase("0"))
			{
				NBTLHoldLog.NBTLHoldLogger.debug("ApInsert successful: "+apInsertMaincode);
				NBTLHoldLog.NBTLHoldLogger.debug("SMS sent successfully.");
				return "true";
			}
		}catch(Exception e){
			NBTLHoldLog.NBTLHoldLogger.debug("Exception in sending SMS----"+e);
		}
		return "false";
		}
	
}
