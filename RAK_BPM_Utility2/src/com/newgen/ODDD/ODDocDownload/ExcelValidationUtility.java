package com.newgen.ODDD.ODDocDownload;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.format.CellDateFormatter;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellUtil;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;
import com.newgen.ODDD.ODDocDownload.ODDD_DocDownloadLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;

public class ExcelValidationUtility implements Runnable
{	

	private static String sessionID = "";
	private static String cabinetName = "";
	private static String jtsIP = "";
	private static String jtsPort = "";
	private static String queueID = "";
	private static String FileDownloadLoc = "";
	private static StringBuffer filePath, filePath1;
	private static int sleepIntervalInMin=0;
	Map<String,Integer>folderCount=new LinkedHashMap<String,Integer>();
	Map<String,Integer>folderPrefix=new LinkedHashMap<String,Integer>();
	Map<String,Integer>folderSuffix=new LinkedHashMap<String,Integer>();
	
	private static NGEjbClient ngEjbClientODDoc;

	static Map<String, String> ODDocConfigParamMap= new HashMap<String, String>();
	
	@Override
	public void run()
	{
		try
		{
			ODDD_DocDownloadLog.setLogger();
			ngEjbClientODDoc = NGEjbClient.getSharedInstance();

			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.error("Could not Read Config Properties [ODDDStatus]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("JTSPORT: " + jtsPort);			

			FileDownloadLoc = ODDocConfigParamMap.get("FileDownloadLoc");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FileDownloadLoc: " + FileDownloadLoc);

			filePath = new StringBuffer(ODDocConfigParamMap.get("filePath"));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("filePath: " + filePath);

			queueID = ODDocConfigParamMap.get("queueID");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("QueueID: " + queueID);


			sleepIntervalInMin=Integer.parseInt(ODDocConfigParamMap.get("SleepIntervalInMin"));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);


			sessionID = CommonConnection.getSessionID(ODDD_DocDownloadLog.ODDD_DocDownloadLogger, false);

			if(sessionID.trim().equalsIgnoreCase(""))
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Session ID found: " + sessionID);
				//HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,sessionID);
				while(true)
				{
					ODDD_DocDownloadLog.setLogger();
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ODDD Utility...123");
					startODDDDownloadDocUtility(cabinetName, jtsIP, jtsPort,sessionID,
							queueID);
							System.out.println("No More workitems to Process, Sleeping!");
							Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.error("Exception Occurred in ODDD : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.error("Exception Occurred in ODDD : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try 
		{

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "ODDD_DocDownload_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    ODDocConfigParamMap.put(name, p.getProperty(name));
			}										
		}
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}
	
	private void startODDDDownloadDocUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,String queueID)
	{
		final String ws_name="OD_Doc_Download";
		try
		{
			//Validate Session ID
			sessionId  = CommonConnection.getSessionID(ODDD_DocDownloadLog.ODDD_DocDownloadLogger, false);

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}

			//Fetch all Work-Items on given queueID.
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Fetching all Workitems on OD_Doc_Download queue");
			System.out.println("Fetching all Workitems on OD_Doc_Download queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= CommonMethods.WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Number of workitems retrieved on OD_Doc_Download: "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on OD_Doc_Download: "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Current EntryDateTime: "+entryDateTime);

					String ActivityName=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ActivityName: "+ActivityName);

					//Lock Workitem.
					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionId, processInstanceID,WorkItemID);
					String getWorkItemOutputXml = CommonMethods.WFNGExecute(getWorkItemInputXML,sJtsIp,iJtsPort,1);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);
					
					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

					if (getWorkItemMainCode.trim().equals("0"))
					{
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WMgetWorkItemCall Successful: "+getWorkItemMainCode);
						
						//This will run when any WI is coming to OD_Doc_Download queue.
						//If loop will run for the WI's coming from Error_Handling or Invalid_Excel queues.
						//Checking if there are any existing records for this Workitem. If there are any records, it will go inside if loop orelse will go inside else.
						String attributesTag="";
						String ErrDesc="";
						String decisionValue="";
						String prev_ws="";
						String Query = "SELECT PrevWS FROM RB_ODDD_EXTTABLE with (nolock) WHERE WINAME='"+processInstanceID+"'";
						String FinalInputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalInputXML for checking whether WI returning from Error Handling :"+FinalInputXML);

						String FinalOutputXML = CommonMethods.WFNGExecute(FinalInputXML, sJtsIp, iJtsPort, 1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalOutputXML for checking whether WI returning from Error Handling :"+FinalOutputXML);

						XMLParser xmlParserAPSelect = new XMLParser(FinalOutputXML);
						String apSelectMaincode1 = xmlParserAPSelect.getValueOf("MainCode");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode1);
						String prevWorkstep = xmlParserAPSelect.getValueOf("PrevWS");
						if(apSelectMaincode1.equals("0") && prevWorkstep.equalsIgnoreCase("Error_Handling"))
						{
							prev_ws = "Error_Handling";
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside if loop -- Error Handling condition satisfied");
							downLoadDocsMain(processInstanceID, sJtsIp, iJtsPort, sessionId, WorkItemID, ActivityName, entryDateTime,prev_ws);
						}
						else
						{
							//This will run when WI is coming to this queue for the first time.
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside else loop -- WI enterd this queue for the first time");
							
							String getWorkitemDataExtInputXML = CommonMethods.getWorkitemDataExtInput(cabinetName, sessionId, processInstanceID,WorkItemID);
							String getWorkitemDataExtOutputXML = CommonMethods.WFNGExecute(getWorkitemDataExtInputXML,sJtsIp,iJtsPort,1);
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Output XML For WmgetWorkItemDataExtCall: "+ getWorkitemDataExtOutputXML);
							
							XMLParser xmlParserGetWorkItemDataExt = new XMLParser(getWorkitemDataExtOutputXML);
							getWorkItemMainCode = xmlParserGetWorkItemDataExt.getValueOf("MainCode");
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WmgetWorkItemDataExtCall Maincode:  "+ getWorkItemMainCode);
	
							if (getWorkItemMainCode.trim().equals("0"))
							{
								String DocumentName = xmlParserGetWorkItemDataExt.getValueOf("DocumentName");							
								String DocumentType = xmlParserGetWorkItemDataExt.getValueOf("DocumentType");							
								String CreatedByAppName = xmlParserGetWorkItemDataExt.getValueOf("CreatedByAppName");							
								String ISIndex = xmlParserGetWorkItemDataExt.getValueOf("ISIndex");
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DocumentName: "+DocumentName);									
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DocumentType: "+DocumentType);									
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("CreatedByAppName: "+CreatedByAppName);							
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ISIndex: "+ISIndex);
								String imgIndex = xmlParserGetWorkItemDataExt.getValueOf("ISIndex").substring(0, xmlParserGetWorkItemDataExt.getValueOf("ISIndex").indexOf("#"));
								String VolId = xmlParserGetWorkItemDataExt.getValueOf("ISIndex").substring(xmlParserGetWorkItemDataExt.getValueOf("ISIndex").indexOf("#")+1,xmlParserGetWorkItemDataExt.getValueOf("ISIndex").lastIndexOf("#"));
								
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("imgIndex: "+imgIndex);
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("VolId: "+VolId);
								
								StringBuffer strFilePath = new StringBuffer();
									
								//Download Document in server location which is available in workitem
								strFilePath.append(System.getProperty("user.dir"));
								strFilePath.append(File.separator);
								strFilePath.append(FileDownloadLoc);
								strFilePath.append(File.separatorChar);
								strFilePath.append(processInstanceID);
								strFilePath.append("_");
								strFilePath.append(DocumentName);
								strFilePath.append(".");
								strFilePath.append(CreatedByAppName);
								//downloadDocument needs to be handled for downloading excel sheet in server loc...rowSeq can not be passed
								String DocStatus = DownloadDoc.DownloadExcel(processInstanceID,imgIndex,VolId,DocumentName,strFilePath);
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DocStatus : "+DocStatus);
								String finalAttributesTag="";
								//ODDD_DocDownloadLog
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("strFilePath.toString() : "+strFilePath.toString());
								
								File file = new File(strFilePath.toString());
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("file.exists() : "+file.exists());	
								
								if(DocStatus.equalsIgnoreCase("T"))
								{
									ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Excel downloaded successfully: Docstatus:: "+DocStatus);
									if (file.exists())
									{
										ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("before table :");
										Table<Integer,String,String>table=HashBasedTable.create();
										Boolean is_excelvalid = false;
										List<ExcelData> excelData = new ArrayList<>();
										int res=ValidateExcelHeader(strFilePath.toString(), CommonConnection.getCabinetName(), CommonConnection.getSessionID(ODDD_DocDownloadLog.ODDD_DocDownloadLogger, false), "Sheet1");
										if(res==0)
										{
											table = excel(strFilePath.toString(), CommonConnection.getCabinetName(), CommonConnection.getSessionID(ODDD_DocDownloadLog.ODDD_DocDownloadLogger, false), "Sheet1");
											is_excelvalid=true;
										}
										else if(res==1)
										{
											is_excelvalid=false;
											ErrDesc = "Excel is invalid. Please Correct the Header Column Name.";
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("is_excelvalid: "+is_excelvalid);
										}
										else
										{
											is_excelvalid=false;
											ErrDesc = "Excel is invalid. Please Correct the Sheet Name.";
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("is_excelvalid: "+is_excelvalid);
										}
										if(is_excelvalid==true)
										{
											Map<Integer,Map<String,String>> tableMap = table.rowMap();
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tableMap.toString());
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("tableMap.keySet().size() : "+tableMap.keySet().size());
											for(int key : tableMap.keySet())
											{
												ExcelData e = new ExcelData(); 
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("key : "+key+" value :"+tableMap.get(key));
												Map<String,String> map = tableMap.get(key);
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(map.toString());
												String VendorName="";
												String AgreementNo="";
												String CrnNo="";
												String CifId="";
												//if(map.toString().indexOf("vendor name") != -1)
												if(map.containsKey("vendor name"))
												{
													VendorName=map.get("vendor name".toLowerCase());
													updateMap(VendorName);
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("vendor name : "+map.get("vendor name".toLowerCase()).toUpperCase());
													e.setVendorName(VendorName);
												}
																							
												if(map.containsKey("agreement no"))
												{
													AgreementNo=map.get("agreement no".toLowerCase());
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("agreement no : "+map.get("agreement no".toLowerCase()).toUpperCase());
													e.setAgreementNo(AgreementNo);
												}
												
												if(map.containsKey("ecrn no."))
												{
													CrnNo=map.get("ecrn no.".toLowerCase());
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("crn no : "+map.get("ecrn no.".toLowerCase()).toUpperCase());
													e.setCrnNumber(CrnNo);
												}
												
												if(map.containsKey("cif"))
												{
													CifId=map.get("cif".toLowerCase());
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("cif : "+map.get("cif".toLowerCase()).toUpperCase());
													e.setCif_No(CifId);
												}
												
												excelData.add(e);
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("excelData.size(): "+excelData.size());
												
												if ((VendorName != null && !"".equals(VendorName)) && ((AgreementNo != null && !"".equals(AgreementNo))
														|| (CrnNo != null && !"".equals(CrnNo)) || (CifId != null && !"".equals(CifId))))
												{
													is_excelvalid = true;
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("is_excelvalid: "+is_excelvalid);
												}
												else
												{
													is_excelvalid = false;
													ErrDesc = "Excel is invalid. Please correct the data and upload it again.";
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("is_excelvalid: "+is_excelvalid);
													break;
												}
												
											}
										}
										ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("after table :");
										if (is_excelvalid)
										{
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Excel Validated successfully");									
											//List<ExcelData> excelData = readDataFromExcelFile(workbook); //Storing excel sheet data into the array list
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After reading excel file ");
											List<ExcelData> masterData = ExtractDataFromMaster(cabinetName, sessionId, sJtsIp,iJtsPort);//Storing master table data into the array list
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After extracting data from master ");
											boolean ErrorFlag = insertToDB(excelData, masterData, processInstanceID, cabinetName, sessionId, sJtsIp, iJtsPort);//Maintaining tables
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ErrorFlag : " +ErrorFlag);
											
											if(ErrorFlag == true)
											{
												//TODO
												//Delete excel file from server
												try
												{
													file.delete();
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Excel deleted successfully:: ");
												}
												catch(Exception e)
												{
													ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception in deleting excel file: "+e.getMessage());
												}
												downLoadDocsMain(processInstanceID, sJtsIp, iJtsPort, sessionId, WorkItemID, ActivityName, entryDateTime,"");
											}
											else 
											{
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Insert To DB Failed!");
												ErrDesc = "Insert To DB Failed!";
												decisionValue = "Failure";
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Decision" +decisionValue);
												finalAttributesTag="<DECISION>"+decisionValue+"</DECISION>" +"<IS_EXCEL_FORMAT_CORRECT>Yes</IS_EXCEL_FORMAT_CORRECT>"+ "<MW_ERRORDESC>"+ErrDesc+"</MW_ERRORDESC>" ;									
												
												String completed=completeWorkitem(cabinetName,sessionId,processInstanceID,WorkItemID,finalAttributesTag,sJtsIp,iJtsPort,ActivityName,decisionValue,ErrDesc,entryDateTime);
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("No Excel Found:: "+completed);
											}
											
										}
										else 
										{
											try
											{
												file.delete();
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Excel deleted successfully:: ");
											}
											catch(Exception e)
											{
												ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception in deleting excel file: "+e.getMessage());
											}
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Invalid Excel");
											
											//invalid queue;								
											
											decisionValue = "Failure";
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Decision" +decisionValue);
											finalAttributesTag="<DECISION>"+decisionValue+"</DECISION>" +"<IS_EXCEL_FORMAT_CORRECT>No</IS_EXCEL_FORMAT_CORRECT>"+ "<MW_ERRORDESC>"+ErrDesc+"</MW_ERRORDESC>" ;									
											
											String completed=completeWorkitem(cabinetName,sessionId,processInstanceID,WorkItemID,finalAttributesTag,sJtsIp,iJtsPort,ActivityName,decisionValue,ErrDesc,entryDateTime);
											ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Excel Invalid WI Completed :: "+completed);
										}
									}
								}
								else
								{
									ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Excel does not exist!");
									ErrDesc = "Excel does not exist!";
									decisionValue = "Failure";
									ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Decision" +decisionValue);
									finalAttributesTag="<DECISION>"+decisionValue+"</DECISION>" +"<IS_EXCEL_FORMAT_CORRECT>No</IS_EXCEL_FORMAT_CORRECT>"+ "<MW_ERRORDESC>"+ErrDesc+"</MW_ERRORDESC>" ;									
									
									String completed=completeWorkitem(cabinetName,sessionId,processInstanceID,WorkItemID,finalAttributesTag,sJtsIp,iJtsPort,ActivityName,decisionValue,ErrDesc,entryDateTime);
									ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("No Excel Found:: "+completed);
								}
								//***********
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WI exiting :: ");
							}
						}	
					}
					else
					{
						getWorkItemMainCode="";
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WmgetWorkItem failed: "+getWorkItemMainCode);
					}
					folderCount.clear();
					folderPrefix.clear();
					folderSuffix.clear();
					
				}
			}
		}
		catch (Exception e)
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception ui: "+e.getMessage());
		}
	}
	
	public boolean downLoadDocsMain(String processInstanceID, String sJtsIp, String iJtsPort, String sessionId, String WorkItemID, String ActivityName, String entryDateTime, String prev_ws)
	{
		
		// Get the rows from main table and down laod document
		String attributesTag="";
		String ErrDesc="";
		String decisionValue="";
		//String SearchMainCode="";
		String Query = "SELECT FOLDER_NAME, ROW_SEQUENCE FROM USR_0_ODDD_VENDOR_DATA_DTLS with (nolock) WHERE WI_NAME='"+processInstanceID+"' AND (FINAL_STATUS='' OR FINAL_STATUS='N' OR FINAL_STATUS is null)";
		String FinalInputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalInputXML :"+FinalInputXML);

		String FinalOutputXML = "";
		try {
			FinalOutputXML = CommonMethods.WFNGExecute(FinalInputXML, sJtsIp, iJtsPort, 1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception while fetching data from VENDOR_DTLS table -- IO Exception :"+e.getMessage());
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception while fetching data from VENDOR_DTLS table -- Exception :"+e.getMessage());
			e.printStackTrace();
		}
		
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalOutputXML :"+FinalOutputXML);

		XMLParser xmlParserAPSelect = new XMLParser(FinalOutputXML);
		String apSelectMaincode1 = xmlParserAPSelect.getValueOf("MainCode");
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode1);
		int result = Integer.parseInt(xmlParserAPSelect.getValueOf("TotalRetrieved"));
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Number of records retrieved from Vendor details table :"+result);
		if(apSelectMaincode1.equals("0") && result>0)
		{
			boolean flag=false;
			for(int k=0; k<result; k++)
			{
				String xmlChangeDetails = xmlParserAPSelect.getNextValueOf("Record");
				XMLParser xmlParserChangeRecord = new XMLParser(xmlChangeDetails);
				String nextFolder = xmlParserChangeRecord.getValueOf("FOLDER_NAME");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextFolder :"+nextFolder);
				String nextRowSequence = xmlParserChangeRecord.getValueOf("ROW_SEQUENCE");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextRowSequence :"+nextRowSequence);
				
				List<ExcelData> RecordList = new ArrayList<ExcelData>();
				try {
					RecordList = ExtractDataFromDSTable(cabinetName, sessionID, sJtsIp, iJtsPort, processInstanceID,nextRowSequence);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After fetching data from DATA_SEARCH_DTLS table");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("RecordList :"+RecordList);
				}
				catch (Exception e) {
					// TODO Auto-generated catch block
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception while fetching data from DATA_SEARCH_DTLS table -- Exception :"+e.getMessage());
					e.printStackTrace();
				}
				int rowseq = Integer.parseInt(nextRowSequence);
				for(int j=0;j<RecordList.size();j++)
				{
					String tempVendor_Name=(RecordList.get(j).getStrVendor_Name().get(j));
					String tempDataClassName=(RecordList.get(j).getStrDataclassName().get(j));
					String tempDataDefId=(RecordList.get(j).getStrDataDefID().get(j));
					String tempFieldIndexId=(RecordList.get(j).getStrFieldIndexfID().get(j));
					String tempSearchValue=(RecordList.get(j).getStrSearchValue().get(j));
					String tempSearchType=(RecordList.get(j).getStrSearchType().get(j));
					String tempOFDataDefId=(RecordList.get(j).getStrDataDefID_OF().get(j));
					String tempOFFieldIndexId=(RecordList.get(j).getStrFieldIndexfID_OF().get(j));
					String tempiBPSStatus=(RecordList.get(j).getStriBPSStatus().get(j));
					String tempOFStatus=(RecordList.get(j).getStrOFStatus().get(j));
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Recordlist values: "+tempVendor_Name+","+tempDataClassName+","+tempDataDefId+","+tempFieldIndexId+","+tempSearchValue+","+tempSearchType+","+tempOFDataDefId+","+tempOFFieldIndexId);
					
					if(!prev_ws.equalsIgnoreCase("Error_Handling"))
					{
						boolean SearchCodeIBPS = false;
						if("N".equalsIgnoreCase(tempiBPSStatus)) 
						{
							SearchCodeIBPS=SearchDocument(cabinetName,sessionId,sJtsIp,iJtsPort,tempDataDefId,tempFieldIndexId,tempSearchValue,tempSearchType,processInstanceID,tempVendor_Name,tempDataClassName,tempOFDataDefId,tempOFFieldIndexId,rowseq,"iBPS",nextFolder);
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After search document IBPS : "+SearchCodeIBPS);
						}
						else
						{
							SearchCodeIBPS = true;	
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After search document IBPS (else) : "+SearchCodeIBPS);
						}
						
						boolean SearchCodeOF = false;
						if("N".equalsIgnoreCase(tempOFStatus)) 
						{
							SearchCodeOF=SearchDocument(cabinetName,sessionId,sJtsIp,iJtsPort,tempDataDefId,tempFieldIndexId,tempSearchValue,tempSearchType,processInstanceID,tempVendor_Name,tempDataClassName,tempOFDataDefId,tempOFFieldIndexId,rowseq,"OmniFlow",nextFolder);
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After search document OF : "+SearchCodeOF);
						}
						else
						{
							SearchCodeOF = true;
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After search document OF (else) : "+SearchCodeOF);
						}
					}
					else 
					{
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Prev ws : "+prev_ws);
					}
					//Downloading Document
					boolean callDocDownloadIBPS = false;
					try {
						callDocDownloadIBPS = DownloadDoc.DownloadDocument(processInstanceID,rowseq,cabinetName,sessionId,sJtsIp,iJtsPort, tempVendor_Name, tempDataClassName , tempDataDefId, tempFieldIndexId, tempSearchValue, tempSearchType, tempOFDataDefId, tempOFFieldIndexId, tempiBPSStatus, tempOFStatus, "iBPS");
						
						StatusUpdateQuery(cabinetName,sessionId,sJtsIp,iJtsPort,processInstanceID,rowseq,tempDataClassName,"iBPS");//tempSearchValue,tempSearchType
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After StatusUpdateQuery method -- iBPS");
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After Downloading Document -- returnvalue iBPS download status: "+callDocDownloadIBPS);
					
					
					//Downloading Document
					boolean callDocDownloadOF = false;
					try 
					{
						callDocDownloadOF = DownloadDoc.DownloadDocument(processInstanceID,rowseq,cabinetName,sessionId,sJtsIp,iJtsPort, tempVendor_Name, tempDataClassName , tempDataDefId, tempFieldIndexId, tempSearchValue, tempSearchType, tempOFDataDefId, tempOFFieldIndexId, tempiBPSStatus, tempOFStatus, "OmniFlow");
						
						StatusUpdateQuery(cabinetName,sessionId,sJtsIp,iJtsPort,processInstanceID,rowseq,tempDataClassName,"OmniFlow");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After StatusUpdateQuery method -- OmniFlow");
					}catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After Downloading Document -- returnvalue OF download status: "+callDocDownloadOF);
				}
				//final status update based on row sequence
				try {
					flag = finalStatusUpdate(cabinetName,sessionId,sJtsIp,iJtsPort,processInstanceID,rowseq);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After Final Status update/maincode :"+flag);
			}
			
			boolean flag1 =  finalStatusFlag(processInstanceID, sJtsIp, iJtsPort, sessionId);
			
			String finalAttributesTag=getDecisionAttributesTag(flag1,decisionValue,ErrDesc,attributesTag);
			
			String completed=completeWorkitem(cabinetName,sessionId,processInstanceID,WorkItemID,finalAttributesTag,sJtsIp,iJtsPort,ActivityName,decisionValue,ErrDesc,entryDateTime);
			
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WI exiting IF loop :: "+completed);
			
		}
		else
		{
			return true;
		}
		return true;
	}
	

	private boolean insertToDB(List<ExcelData> excelData,List<ExcelData>masterData, String processInstanceID, String cabinetName, String sessionId, String JtsIp, String JtsPort) throws Exception 
	{
		
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("inside insertToDB: ");
		int count=0;
		boolean APIErrorFlag = true;
		//String SearchMainCode="";
		String callDocDownload="";
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("excelData.size(): "+excelData.size());
		String agreementNo = "";
		String crnNumber = "";
		String vendorName = "";
		String cif_no = "";
		String folderName ="";
		for (int i = 0; i < excelData.size(); i++) 
		{
			/*if(i%100==0)
		    {
				folderName = (i+1)+" to "+(i+100);
		        System.out.println("folderName" + folderName);
		        ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("folderName "+folderName);
		    }*/
			count=i+1;
			try {
				agreementNo = (excelData.get(i).getAgreementNo());
				crnNumber = (excelData.get(i).getCrnNumber());
				vendorName = (excelData.get(i).getVendorName());
				cif_no = (excelData.get(i).getCif_No());
			} 
			catch (Exception e)
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("check 111 "+e.getMessage());
				System.out.println("check 111 "+e.getMessage());
			}
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.0");
			Date date = new Date(System.currentTimeMillis());
			String strCurrDateTime = formatter.format(date);
			
			String columnValues="";
			/*cif_no = splitColumnValue(cif_no);
			crnNumber = splitColumnValue(crnNumber);
			agreementNo = splitColumnValue(agreementNo);*/
			//for searching workitem in the table
			//searchDocument
		    try{
				if("".equalsIgnoreCase(agreementNo.trim()) || "null".equalsIgnoreCase(agreementNo.trim()))
					agreementNo = "";
		    }
		    catch (Exception e)
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("check 1121 "+e.getMessage());
				System.out.println("check agreementNo "+e.getMessage());
				agreementNo = "";
			}
		    
		    try{
				if("".equalsIgnoreCase(crnNumber.trim()) || "null".equalsIgnoreCase(crnNumber.trim()))
					crnNumber = "";
		    }
		    catch (Exception e)
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("check 1121 "+e.getMessage());
				System.out.println("check crnNumber "+e.getMessage());
				crnNumber = "";
			}
		    
		    try{
				
				if("".equalsIgnoreCase(cif_no.trim()) || "null".equalsIgnoreCase(cif_no.trim()))
					cif_no = "";
		    }
		    catch (Exception e)
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("check 1121 "+e.getMessage());
				System.out.println("check cif_no "+e.getMessage());
				cif_no = "";
			}
		  
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("agreementNo: "+agreementNo);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("crnNumber: "+crnNumber);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("cif_no: "+cif_no);
			
			String columnNames = "WI_NAME,VENDOR_NAME,AGREEMENT_NUMBER,CRN_NUMBER,FINAL_STATUS,ROW_SEQUENCE,INSERTED_DATA_TIME,COMPLETED_DATA_TIME,CIF_ID";
			columnValues = "'" + processInstanceID + "','" + vendorName + "','" + agreementNo + "','" + crnNumber + "','N','" + count + "',getdate(),'','" + cif_no + "'";
			String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_ODDD_VENDOR_DATA_DTLS");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertInputXML: "+apInsertInputXML);
			String apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, JtsIp, JtsPort, 1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertOutputXML: "+apInsertOutputXML);
			XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
			String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
			if (apInsertMaincode.equalsIgnoreCase("0")) 
			{
				//print logger for successfully inserting data in vendor data dtls
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Data inserted in vendor data dtls for row"+i);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("masterData.size(): "+masterData.size());
				for(int j=0;j<masterData.size();j++)//masterData.size()
				{
					String tempDataClassName=(masterData.get(j).getStrDataclassName().get(j));
                	String tempFieldType=(masterData.get(j).getStrFieldType().get(j));
                	String tempDataDefId=(masterData.get(j).getStrDataDefID().get(j));
                	String tempFieldIndexId=(masterData.get(j).getStrFieldIndexfID().get(j));
                	String tempOFDataDefId=(masterData.get(j).getStrDataDefID_OF().get(j));
                	String tempOFFieldIndexId=(masterData.get(j).getStrFieldIndexfID_OF().get(j));
                	ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("masterData.tempFieldType: "+tempFieldType);
                	//NEED TO HANDLE FOR OMNIFLOW CASE AS WELL.(of_DATA_DEF_ID,of_FIELD_INDEX_ID)
                	String columnNames1 = "ID,WINAME,VENDOR_NAME,DATA_CLASS_NAME,iBPS_DATA_DEF_ID,iBPS_FIELD_INDEX_ID,SEARCH_VALUE,SEARCH_TYPE,iBPS_STATUS,iBPS_COMPLETED_DATETIME,OFSTATUS,OFSTATUS_COMPLETED_DATETIME,OF_DATA_DEF_ID,OF_FIELD_INDEX_ID";//sanchi (filepath,rowsequence)              	                   
        			try 
        			{
        				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("agreementNo : "+agreementNo);
        				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("crnNumber : "+crnNumber);
        				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("cif_no : "+cif_no);
        				
        				if((agreementNo!=null && !"".equals(agreementNo)) && tempFieldType.equalsIgnoreCase("AgreementNo"))
            			{
        					String mainCode1 = "";
        					mainCode1 = DataClassInsertion(count,processInstanceID,vendorName,tempDataClassName,tempDataDefId,tempFieldIndexId,agreementNo,tempFieldType,strCurrDateTime,cabinetName,sessionId,columnNames1,JtsIp,JtsPort,tempOFDataDefId,tempOFFieldIndexId);//sanchi  (filepath,rowsequence)            			
                			if (mainCode1.equalsIgnoreCase("0")) 
                			{
                				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After DataClassInsertion for Agreement Number");
                			}                			
                			else
                			{
                				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside else : Error in DataClassInsertion Function for Agreement Number");
                			}
            			}
        				else if((crnNumber!=null && !"".equals(crnNumber)) && tempFieldType.equalsIgnoreCase("ELITECRN"))
            			{
        					String mainCode2 = "";
                    		mainCode2 = DataClassInsertion(count,processInstanceID,vendorName,tempDataClassName,tempDataDefId,tempFieldIndexId,crnNumber,tempFieldType,strCurrDateTime,cabinetName,sessionId,columnNames1,JtsIp,JtsPort,tempOFDataDefId,tempOFFieldIndexId);
            				if (mainCode2.equalsIgnoreCase("0")) 
            				{            
            					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After DataClassInsertion for CRN Number");
                			}
                			else
                			{
                				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside else : Error in DataClassInsertion Function for CRN Number");
                			}
            			}
        				else if((cif_no!=null && !"".equals(cif_no)) && (tempFieldType.equalsIgnoreCase("CIFID") || tempFieldType.equalsIgnoreCase("CIFNumber")))
            			{
                    		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("cif_no : "+cif_no);
                    		String mainCode3 = "";
                    		mainCode3=DataClassInsertion(count,processInstanceID,vendorName,tempDataClassName,tempDataDefId,tempFieldIndexId,cif_no,tempFieldType,strCurrDateTime,cabinetName,sessionId,columnNames1,JtsIp,JtsPort,tempOFDataDefId,tempOFFieldIndexId);
            				if (mainCode3.equalsIgnoreCase("0")) 
            				{
            					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After DataClassInsertion for CIF ID");
	            			}
                			else
                			{
                				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside else : Error in DataClassInsertion Function for CIF Number");
                			}
            			}
	                	else
	                	{
	                		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("-- At Final Else loop --");
	                	}
        			}
        			catch (Exception e)
        			{
        				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception in inserttoDB: "+e.getMessage());
        				APIErrorFlag = false;
        			}
				}
			}
			else 
			{
				//apinsert failed for vendor data dtls.
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsert failed for vendor data dtls :");
				APIErrorFlag = false;
			}
		}
		return APIErrorFlag;
	}
	private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,String sessionID)
	{
		HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

		try
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'ODDD' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=CommonMethods.WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");
			}
		}
		catch (Exception e)
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}
		return socketDetailsMap;
	}

	
	public Table<Integer,String,String> excel(String fileName,String cabinetName,String sessionId,String tag)
	{
		FileInputStream fis = null;
		Table<Integer,String,String> table = HashBasedTable.create();
		try
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" excel tag : "+ tag);			
			fis = new FileInputStream(new File(fileName));
			if(FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("xls"))
			{
				HSSFWorkbook workBook = new HSSFWorkbook(fis);
				HSSFSheet sheet = workBook.getSheet(tag);
				System.out.println(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				Iterator<Row> rowIterator = sheet.iterator();
				int flagForNewData = 0 ;
				while(rowIterator.hasNext()) 
				{
					Row row = rowIterator.next();
					Iterator<Cell> cellIterator = row.cellIterator();
					Cell cell = null;
					if(row.getRowNum()==sheet.getFirstRowNum())
					{
						cell = cellIterator.next();
					}
					else
					{
						if(!(row.getCell(row.getLastCellNum()-1,Row.CREATE_NULL_AS_BLANK).toString().equalsIgnoreCase("Y")))
						{
							flagForNewData = 1;
							while(cellIterator.hasNext()) 
							{
								cell = cellIterator.next();
								switch(cell.getCellType()) 
								{
								case Cell.CELL_TYPE_BOOLEAN:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf(cell.getBooleanCellValue()));
									break;
								case Cell.CELL_TYPE_NUMERIC:
									if(HSSFDateUtil.isCellDateFormatted(cell))
									{
										Date date = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
										DateFormat dateReadFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy",Locale.getDefault());
										//										dateReadFormat.setTimeZone(TimeZone.getTimeZone("IST"));
										DateFormat writeFormat = new SimpleDateFormat("yyyy-MM-dd");
										Date mDate = null;
										try 
										{
											mDate = dateReadFormat.parse(date.toString());
										}
										catch ( ParseException e ) 
										{
											e.printStackTrace();
										}

										String formattedDate = "";
										if( mDate != null ) 
										{
											formattedDate = writeFormat.format( mDate );
										}

										//System.out.println(formattedDate);
										table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),new CellDateFormatter(formattedDate).format(date));
									}
									else
									{
										table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf((int)cell.getNumericCellValue()));
									}
									break;
								case Cell.CELL_TYPE_STRING:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),cell.getStringCellValue());
									break;
								case Cell.CELL_TYPE_BLANK:
//									System.out.println("BLANK CELL "+cell.getColumnIndex()+cell.getRowIndex());
									break;
								case Cell.CELL_TYPE_ERROR:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf(cell.getErrorCellValue()));
									break;
								case Cell.CELL_TYPE_FORMULA:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf(cell.getCellFormula()));
									break;
								}
							}
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Table Size  : "+table.size()+", Other Data "+sheet.getRow(sheet.getFirstRowNum()).getPhysicalNumberOfCells());
							/*if(table.size()%(sheet.getRow(sheet.getFirstRowNum()).getPhysicalNumberOfCells()-1)!=0)
							{
								int rowNo = row.getRowNum()+1;
								System.out.println("Incomplete data at row number : "+rowNo+" in sheet "+tag);
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Incomplete data at row number : "+rowNo+" in sheet "+tag);
								Set<String> set = table.columnKeySet();
								Object[] array = set.toArray();
								for(int i=0; i<array.length; i++)
								{
									//table.remove(row.getRowNum(),array[i]);
								}
							}*/
						}
					}
				}
				if(flagForNewData!=1)
				{
					System.out.println("No new Data for "+tag);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("No new Data for "+tag);
					//Log.writeErr(("No new Data for "+tag);
				}
			}
			else if (FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("XLSX"))
			{
				XSSFWorkbook workBook = new XSSFWorkbook(fis);
				XSSFSheet sheet = workBook.getSheet(tag);
				System.out.println(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				Iterator<Row> rowIterator = sheet.iterator();
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" rowIterator : "+ rowIterator);
				
				int flagForNewData = 0 ;
				while(rowIterator.hasNext()) 
				{
					Row row = rowIterator.next();
					Iterator<Cell> cellIterator = row.cellIterator();
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("row.getRowNum()"+row.getRowNum());
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("sheet.getFirstRowNum()"+sheet.getFirstRowNum());
					Cell cell = null;
					if(row.getRowNum()==sheet.getFirstRowNum())
					{
						cell = cellIterator.next();
					}
					else
					{
						if(!(row.getCell(row.getLastCellNum()-1,Row.CREATE_NULL_AS_BLANK).toString().equalsIgnoreCase("Y")))
						{
							flagForNewData = 1;
							while(cellIterator.hasNext()) 
							{
								cell = cellIterator.next();
								switch(cell.getCellType()) 
								{
								case Cell.CELL_TYPE_BOOLEAN:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf(cell.getBooleanCellValue()));
									break;
								case Cell.CELL_TYPE_NUMERIC:
									if(HSSFDateUtil.isCellDateFormatted(cell))
									{
										Date date = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
										DateFormat dateReadFormat = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy",Locale.getDefault());
										//										dateReadFormat.setTimeZone(TimeZone.getTimeZone("IST"));
										DateFormat writeFormat = new SimpleDateFormat("yyyy-MM-dd");
										Date mDate = null;
										try 
										{
											mDate = dateReadFormat.parse(date.toString());
										}
										catch ( ParseException e ) 
										{
											e.printStackTrace();
										}

										String formattedDate = "";
										if( mDate != null ) 
										{
											formattedDate = writeFormat.format( mDate );
										}

										System.out.println(formattedDate);
										table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),new CellDateFormatter(formattedDate).format(date));
									}
									else
									{
										table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf((int)cell.getNumericCellValue()));
									}
									break;
								case Cell.CELL_TYPE_STRING:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),cell.getStringCellValue());
									break;
								case Cell.CELL_TYPE_BLANK:
//									System.out.println("BLANK CELL "+cell.getColumnIndex()+cell.getRowIndex());
									break;
								case Cell.CELL_TYPE_ERROR:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf(cell.getErrorCellValue()));
									break;
								case Cell.CELL_TYPE_FORMULA:
									table.put(row.getRowNum(),sheet.getRow(sheet.getFirstRowNum()).getCell(cell.getColumnIndex()).toString().toLowerCase(),String.valueOf(cell.getCellFormula()));
									break;
								}
							}
							ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(table.size()%(sheet.getRow(sheet.getFirstRowNum()).getPhysicalNumberOfCells()-1));
							
							/*if(table.size()%(sheet.getRow(sheet.getFirstRowNum()).getPhysicalNumberOfCells()-1)!=0)
							{
								int rowNo = row.getRowNum()+1;
								System.out.println("Incomplete data at row number : "+rowNo+" in sheet "+tag);
								ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Incomplete data at row number : "+rowNo+" in sheet "+tag);
								Set<String> set = table.columnKeySet();
								Object[] array = set.toArray();
								for(int i=0; i<array.length; i++)
								{
									//table.remove(row.getRowNum(),array[i]);
								}
							}*/
						}
						else
						{
							System.out.println("No new Data FOR "+tag);
						}
					}
				}
				if(flagForNewData!=1)
				{
					System.out.println("No new Data for "+tag);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("No new Data for "+tag);
					//Log.writeErr(("No new Data for "+tag);
				}
			}
		}
		catch(IOException e)
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("exception in excel method "+e);
			e.printStackTrace();
		}
		finally
		{
			if(fis!=null)
			{
				try
				{
					fis.close();
				}
				catch(IOException e)
				{
					e.printStackTrace();
				}
			}
		}
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("in excel method - table: "+table);
		return table;
	}


	public static List<ExcelData> ExtractDataFromMaster(String CabinetName, String sessionID, String sJtsIp, String iJtsPort) throws Exception 
	{
		List<ExcelData> listMasterData = new ArrayList<ExcelData>();
		String Query = "SELECT DATA_CLASS_NAME,FIELD_TYPE,iBPS_DATA_DEF_ID,iBPS_FIELD_INDEX_ID,OF_DATA_DEF_ID,OF_FIELD_INDEX_ID FROM USR_0_ODDD_DATA_CLASS_MASTER with (nolock) where IsActive='Y'";
		String InputXML = CommonMethods.apSelectWithColumnNames(Query, CabinetName, sessionID);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("InputXML :"+InputXML);
		String OutputXML = CommonMethods.WFNGExecute(InputXML, sJtsIp, iJtsPort, 1);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OutputXML :"+OutputXML);
		XMLParser xmlParserAPSelect = new XMLParser(OutputXML);
		String apSelectMaincode = xmlParserAPSelect.getValueOf("MainCode");
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode);
		if(apSelectMaincode.equals("0"))
		{
			NGXmlList objWorkList = xmlParserAPSelect.createList("Records", "Record");
			ExcelData MasterData = new ExcelData();
			for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) 
			{    		
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DATA_CLASS_NAME :"+objWorkList.getVal("DATA_CLASS_NAME"));
				MasterData.setStrDataclassName(objWorkList.getVal("DATA_CLASS_NAME"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FIELD_TYPE :"+objWorkList.getVal("FIELD_TYPE"));
				MasterData.setStrFieldType(objWorkList.getVal("FIELD_TYPE"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("iBPS_DATA_DEF_ID :"+objWorkList.getVal("iBPS_DATA_DEF_ID"));
				MasterData.setStrDataDefID(objWorkList.getVal("iBPS_DATA_DEF_ID"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("iBPS_FIELD_INDEX_ID :"+objWorkList.getVal("iBPS_FIELD_INDEX_ID"));
				MasterData.setStrFieldIndexfID(objWorkList.getVal("iBPS_FIELD_INDEX_ID"));
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OF_DATA_DEF_ID :"+objWorkList.getVal("OF_DATA_DEF_ID"));
				MasterData.setStrDataDefID_OF(objWorkList.getVal("OF_DATA_DEF_ID"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OF_FIELD_INDEX_ID :"+objWorkList.getVal("OF_FIELD_INDEX_ID"));
				MasterData.setStrFieldIndexfID_OF(objWorkList.getVal("OF_FIELD_INDEX_ID"));
				
				listMasterData.add(MasterData);
			}
		}
		return listMasterData;
	}

	//Function to Search Documents and Insert them into ODDD_DOC_DTLS table.											
	public boolean SearchDocument(String cabinetName,String sessionId,String JtsIp,String JtsPort,String tempDataDefId,String tempFieldIndexId,String searchValue, String tempFieldType,String processInstanceID,String vendorName,String tempDataClassName,String tempOFDataDefId,String tempOFFieldIndexId, int count, String callingEnv, String folderName)
	{
		boolean flag=false;
		
		try 
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside SearchDocument method -- for "+callingEnv);
			//String [] env=new String[] {cabinetName,CommonConnection.getOFCabinetName()};
			String env_SessionId="";
			String env_jtsIp="";
			String env_jtsPort="";
			String DataDefID="";
			String FieldIndexID ="";
			String ServerDetails="";
			String cabinetNameForEnv = cabinetName;
			
			//ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("env_chosen: "+env_chosen);
			if(callingEnv.equalsIgnoreCase("iBPS"))//if(env_chosen==0)
			{
				env_SessionId=sessionId;
				env_jtsIp=JtsIp;
				env_jtsPort=JtsPort;
				DataDefID=tempDataDefId;
				FieldIndexID=tempFieldIndexId;
				ServerDetails="iBPS";
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("rak_bpm credentials: "+env_SessionId+"\n"+env_jtsIp+"\n"+env_jtsPort+"\n"+DataDefID+"\n"+FieldIndexID);
			}
			else
			{
				env_SessionId=CommonConnection.getOFSessionID(ODDD_DocDownloadLog.ODDD_DocDownloadLogger, false);
				env_jtsPort=CommonConnection.getOFJTSPort();
				env_jtsIp=CommonConnection.getOFJTSIP();
				DataDefID=tempOFDataDefId;
				FieldIndexID=tempOFFieldIndexId;
				ServerDetails="OmniFlow";
				cabinetNameForEnv = CommonConnection.getOFCabinetName();
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("rakcabinet_first credentials: "+env_SessionId+"\n"+env_jtsIp+"\n"+env_jtsPort+"\n"+DataDefID+"\n"+FieldIndexID);
			}
			String searchDocInputXML = CommonMethods.NGOSearchDocument(DataDefID,FieldIndexID,searchValue,cabinetNameForEnv,env_SessionId);//cif_no //4324343
			/*String searchDocInputXML = CommonMethods.NGOSearchDocument("19","4340",searchValue,env[i],env_SessionId);*/
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("searchDocInputXML: "+searchDocInputXML);
			String searchDocOutputXML=CommonMethods.WFNGExecute(searchDocInputXML,env_jtsIp,env_jtsPort,1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("searchDocOutputXML: "+searchDocOutputXML);
			XMLParser xmlParsersearchDoc = new XMLParser(searchDocOutputXML);
			String searchDocMaincode = xmlParsersearchDoc.getValueOf("Status");
			int Record = Integer.parseInt(xmlParsersearchDoc.getValueOf("TotalNoOfRecords"));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("searchDocMaincode: "+searchDocMaincode);                			
			
			if (searchDocMaincode.equalsIgnoreCase("0"))
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Document searched successfully");
				if(Record > 0) 
				{
					
					NGXmlList objWorkList = xmlParsersearchDoc.createList("SearchResults", "SearchResult");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("objWorkList "+objWorkList);
					for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) 
					{
						
						if(folderCount.get(vendorName)<=1000)
						{
							folderCount.replace(vendorName,folderCount.get(vendorName)+1);
						}
						else
						{
							folderPrefix.replace(vendorName,folderPrefix.get(vendorName)+1000);
							folderSuffix.replace(vendorName,folderSuffix.get(vendorName)+1000);
							folderCount.replace(vendorName,1);
						}
						folderName=folderPrefix.get(vendorName)+" to "+folderSuffix.get(vendorName);
						
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Folder Name::"+folderName);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Vendor Name & Folder Count"+folderCount.get(vendorName)+":"+vendorName);
						//Folder creation
						new File(filePath+File.separator+processInstanceID).mkdir();
						new File(filePath+File.separator+processInstanceID+File.separator+vendorName).mkdir();
						new File(filePath+File.separator+processInstanceID+File.separator+vendorName+File.separator+processInstanceID).mkdir();
						new File(filePath+File.separator+processInstanceID+File.separator+vendorName+File.separator+processInstanceID+File.separator+folderName).mkdir();
						new File(filePath+File.separator+processInstanceID+File.separator+vendorName+File.separator+processInstanceID+File.separator+folderName+File.separator+searchValue).mkdir();
						/*new File(filePath+File.separator+vendorName).mkdir();
	                	new File(filePath+File.separator+vendorName+File.separator+processInstanceID).mkdir();
	                	new File(filePath+File.separator+vendorName+File.separator+processInstanceID+File.separator+folderName).mkdir();
	                	new File(filePath+File.separator+vendorName+File.separator+processInstanceID+File.separator+folderName+File.separator+searchValue).mkdir();
	                	*/
	                	ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After Folder Creation");
						
	                	StringBuffer filePath1 = new StringBuffer(filePath+File.separator+processInstanceID+File.separator+vendorName+File.separator+processInstanceID+File.separator+folderName+File.separator+searchValue);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("nextFilePath :"+filePath1);
						
						
						String docDetail = xmlParsersearchDoc.getNextValueOf("SearchResult");
						XMLParser xmlDocDetail = new XMLParser(docDetail);
						String ISIndex = xmlDocDetail.getValueOf("ISIndex");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ISIndex"+ISIndex);
						String StrimgIndex = xmlDocDetail.getValueOf("ISIndex").substring(0, xmlDocDetail.getValueOf("ISIndex").indexOf("#"));
						//String imageIndex = xmlParser.getValueOf("ISIndex").substring(0, xmlParser.getValueOf("ISIndex").indexOf("#"));
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ISIndex substring "+StrimgIndex);
						//String StrVolId = xmlParsersearchDoc.getValueOf("ISIndex").substring(xmlParsersearchDoc.getValueOf("ISIndex").indexOf("#")+1,xmlParsersearchDoc.getValueOf("ISIndex").lastIndexOf("#"));
						String StrVolId = xmlDocDetail.getValueOf("ISIndex").substring(xmlDocDetail.getValueOf("ISIndex").indexOf("#")+1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("VolId:"+StrVolId+" imgIndex :"+StrimgIndex);
						/**Same docs download issue -29122021 **/
						String DocIndex = xmlDocDetail.getValueOf("DocumentIndex");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DocumentIndex"+DocIndex);
						
						String StrDocumentName = xmlDocDetail.getValueOf("DocumentName");
						String StrCreatedByAppName = xmlDocDetail.getValueOf("CreatedByAppName");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("StrDocumentName:"+StrDocumentName+" StrCreatedByAppName :"+StrCreatedByAppName);
						StrDocumentName+="_"+DocIndex;									
						//Download Document in server location 
						StringBuffer filePath2 = new StringBuffer(filePath1);
						filePath2.append(File.separatorChar);
						filePath2.append(StrDocumentName);
						filePath2.append(".");
						filePath2.append(StrCreatedByAppName);
						
						String columnNames1 = "ID,WINAME,DATA_CLASS_NAME,SERVER,DOC_ISINDEX,DOC_NAME,DOC_FILEPATH,STATUS";
						String columnValues1 = "'"+count+"','"+processInstanceID+"','"+tempDataClassName+"','"+ServerDetails+"','"+ISIndex+"','"+StrDocumentName+"','"+filePath2+"','N'";
						String apInsertInputXML1 = CommonMethods.apInsert(cabinetName, sessionId, columnNames1, columnValues1,"USR_0_ODDD_DOC_DTLS");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertInputXML1: "+apInsertInputXML1);
						String apInsertOutputXML1 = CommonMethods.WFNGExecute(apInsertInputXML1, JtsIp, JtsPort, 1);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertOutputXML1: "+apInsertOutputXML1);
						XMLParser xmlParserAPInsert1 = new XMLParser(apInsertOutputXML1);
						String apInsertMaincode1 = xmlParserAPInsert1.getValueOf("MainCode");
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertMaincode1: "+apInsertMaincode1);
					}
				}
				else
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Document searched but no docs found");
					boolean outputStatus = StatusUpdateQuery(cabinetName,sessionId,JtsIp,JtsPort,processInstanceID,count,tempDataClassName,callingEnv);//searchValue,tempFieldType
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("After Setting IBPS_STATUS and OF_STATUS -- returnvalue : "+outputStatus);
				}
			}
			else
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Error in Document Search!");                			
				flag=true;
			}
		}
		catch(Exception e)
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SearchDocument Exception occurred : "+e.getMessage());
			flag=true;
		}
		return flag;
	}
	
	
	public String DataClassInsertion(int count,String processInstanceID,String vendorName,String tempDataClassName,String tempDataDefId,String tempFieldIndexId,String searchValue,String tempFieldType,String strCurrDateTime,String cabinetName,String sessionId,String columnNames1,String JtsIp,String JtsPort,String tempOFDataDefId,String tempOFFieldIndexId) throws Exception
	{
	    String columnValues1 = "'"+count+"','"+processInstanceID+"','"+vendorName+"','"+tempDataClassName+"','"+tempDataDefId+"','"+tempFieldIndexId+"','"+searchValue+"','"+tempFieldType+"','N','','N','','"+tempOFDataDefId+"','"+tempOFFieldIndexId+"'";
	    String apInsertInputXML1 = CommonMethods.apInsert(cabinetName, sessionId, columnNames1, columnValues1,"USR_0_ODDD_DATACLASS_SEARCH_DTLS");
	    ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertInputXML1: "+apInsertInputXML1);
	    String apInsertOutputXML1 = CommonMethods.WFNGExecute(apInsertInputXML1, JtsIp, JtsPort, 1);
	    ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertOutputXML1: "+apInsertOutputXML1);
	    XMLParser xmlParserAPInsert1 = new XMLParser(apInsertOutputXML1);
	    String apInsertMaincode1 = xmlParserAPInsert1.getValueOf("MainCode");
	    ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apInsertMaincode1: "+apInsertMaincode1);
	    return apInsertMaincode1;
	}
	
	
	
	public static List<ExcelData> ExtractDataFromDSTable(String CabinetName, String sessionID, String sJtsIp, String iJtsPort, String processInstanceID, String nextRowSequence) throws Exception 
	{
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside ExtractDataFromDSTable method!");
		List<ExcelData> listRecordList = new ArrayList<ExcelData>();
		//String Query = "SELECT DATA_CLASS_NAME,FIELD_TYPE,iBPS_DATA_DEF_ID,iBPS_FIELD_INDEX_ID,OF_DATA_DEF_ID,OF_FIELD_INDEX_ID FROM USR_0_ODDD_DATA_CLASS_MASTER with (nolock) where IsActive='Y'";
		String Query ="SELECT VENDOR_NAME, DATA_CLASS_NAME, iBPS_DATA_DEF_ID, iBPS_FIELD_INDEX_ID, SEARCH_VALUE, SEARCH_TYPE, OF_DATA_DEF_ID, OF_FIELD_INDEX_ID,iBPS_STATUS,OFSTATUS FROM USR_0_ODDD_DATACLASS_SEARCH_DTLS with(nolock) WHERE WINAME ='"+processInstanceID+"' AND ID ='"+nextRowSequence+"' AND (iBPS_STATUS in ('N','I')  OR OFSTATUS  in ('N','I'))";
	    String InputXML = CommonMethods.apSelectWithColumnNames(Query, CabinetName, sessionID);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("InputXML :"+InputXML);
		String OutputXML = CommonMethods.WFNGExecute(InputXML, sJtsIp, iJtsPort, 1);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OutputXML :"+OutputXML);
		XMLParser xmlParserAPSelect = new XMLParser(OutputXML);
		String apSelectMaincode = xmlParserAPSelect.getValueOf("MainCode");
		int TotalRecords = Integer.parseInt(xmlParserAPSelect.getValueOf("TotalRetrieved"));
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Total No. of records fetched :"+TotalRecords);
		if(apSelectMaincode.equals("0") && TotalRecords>0)
		{
			NGXmlList objWorkList = xmlParserAPSelect.createList("Records", "Record");
			ExcelData RecordList = new ExcelData();
			for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) 
			{   		
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("VENDOR_NAME :"+objWorkList.getVal("VENDOR_NAME"));
				RecordList.setStrVendor_Name(objWorkList.getVal("VENDOR_NAME"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("DATA_CLASS_NAME :"+objWorkList.getVal("DATA_CLASS_NAME"));
				RecordList.setStrDataclassName(objWorkList.getVal("DATA_CLASS_NAME"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("iBPS_DATA_DEF_ID :"+objWorkList.getVal("iBPS_DATA_DEF_ID"));
				RecordList.setStrDataDefID(objWorkList.getVal("iBPS_DATA_DEF_ID"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("iBPS_FIELD_INDEX_ID :"+objWorkList.getVal("iBPS_FIELD_INDEX_ID"));
				RecordList.setStrFieldIndexfID(objWorkList.getVal("iBPS_FIELD_INDEX_ID"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SEARCH_VALUE :"+objWorkList.getVal("SEARCH_VALUE"));
				RecordList.setStrSearchValue(objWorkList.getVal("SEARCH_VALUE"));

				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("SEARCH_TYPE :"+objWorkList.getVal("SEARCH_TYPE"));
				RecordList.setStrSearchType(objWorkList.getVal("SEARCH_TYPE"));
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OF_DATA_DEF_ID :"+objWorkList.getVal("OF_DATA_DEF_ID"));
				RecordList.setStrDataDefID_OF(objWorkList.getVal("OF_DATA_DEF_ID"));
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OF_FIELD_INDEX_ID :"+objWorkList.getVal("OF_FIELD_INDEX_ID"));
				RecordList.setStrFieldIndexfID_OF(objWorkList.getVal("OF_FIELD_INDEX_ID"));
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("iBPS_STATUS :"+objWorkList.getVal("iBPS_STATUS"));
				RecordList.setStriBPSStatus(objWorkList.getVal("iBPS_STATUS"));
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OFSTATUS :"+objWorkList.getVal("OFSTATUS"));
				RecordList.setStrOFStatus(objWorkList.getVal("OFSTATUS"));

				listRecordList.add(RecordList);
			}
		}
		else
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside else - ExtractDataFromDSTable method -- apSelectMaincode :"+apSelectMaincode);
		}
		return listRecordList;
	}
	
	//This is called to get the final attributesTag.
	public String getDecisionAttributesTag(boolean ErrorFlag,String decisionValue,String ErrDesc,String attributesTag)
	{
		if(ErrorFlag)
		{
			decisionValue = "Failure";									
			ErrDesc = "Error while downloading documents";
		}
		else
			decisionValue = "Success";

		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Decision" +decisionValue);
		attributesTag="<DECISION>"+decisionValue+"</DECISION>" +"<IS_EXCEL_FORMAT_CORRECT>Yes</IS_EXCEL_FORMAT_CORRECT>"+ "<MW_ERRORDESC>"+ErrDesc+"</MW_ERRORDESC>";
		
		return attributesTag;
	}
	
	//This is called to move the WI and update the WI History table.
	public String completeWorkitem(String cabinetName, String sessionId,String processInstanceID,String WorkItemID,String attributesTag,String sJtsIp,String iJtsPort,String ActivityName,String decisionValue,String ErrDesc,String entryDateTime)
	{
		String returnValue="";
		try
		{
			String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionId,processInstanceID,WorkItemID,attributesTag);
		
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("InputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeInputXML);
	
			String assignWorkitemAttributeOutputXML=CommonMethods.WFNGExecute(assignWorkitemAttributeInputXML,sJtsIp,
					iJtsPort,1);
	
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("OutputXML for assignWorkitemAttribute Call: "+assignWorkitemAttributeOutputXML);
	
			XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
			String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("AssignWorkitemAttribute MainCode: "+assignWorkitemAttributeMainCode);
	
			if(assignWorkitemAttributeMainCode.trim().equalsIgnoreCase("0"))
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("AssignWorkitemAttribute Successful: "+assignWorkitemAttributeMainCode);
	
				String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionId,
						processInstanceID,WorkItemID);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);
	
				String completeWorkItemOutputXML = CommonMethods.WFNGExecute(completeWorkItemInputXML,sJtsIp,iJtsPort,1);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);
	
	
				XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
				String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
	
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);
	
				//Move Workitem to next Workstep
	
				if (completeWorkitemMaincode.trim().equalsIgnoreCase("0"))
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
					System.out.println(processInstanceID + "Complete Succesfully with status "+decisionValue);
	
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WorkItem moved to next Workstep.");
	
					SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
					SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
					Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
					String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
	
					Date actionDateTime= new Date();
					String formattedActionDateTime=outputDateFormat.format(actionDateTime);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);
	
					//Insert in WIHistory Table.
					String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS";
					String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ActivityName+"','"
					+CommonConnection.getUsername()+"','"+decisionValue+"','"+formattedEntryDatetime+"','"+ErrDesc+"'";
	
					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_ODDD_WIHISTORY");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("APInsertInputXML: "+apInsertInputXML);
	
					String apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML,sJtsIp,iJtsPort,1);
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("APInsertOutputXML: "+ apInsertInputXML);
	
					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
	
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Completed On "+ ActivityName);
	
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ApInsert successful: "+apInsertMaincode);
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inserted in WiHistory table successfully.");
					}
					else
					{
						ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("ApInsert failed: "+apInsertMaincode);
					}
					returnValue=completeWorkitemMaincode;
				}
				else
				{
					completeWorkitemMaincode="";
					returnValue=completeWorkitemMaincode;
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("WMCompleteWorkItem failed: "+completeWorkitemMaincode);
				}
			}
			else
			{
				assignWorkitemAttributeMainCode="";
				returnValue=assignWorkitemAttributeMainCode;
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("AssignWorkitemAttribute failed: "+assignWorkitemAttributeMainCode);
			}
		}
		catch(Exception e)
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside Exception of Complete Workitem : "+e.getMessage());
		}
		return returnValue;
	}
	
	public boolean finalStatusUpdate(String cabinetName,String sessionId,String JtsIp,String JtsPort,String processInstanceID,int rowSequence) throws IOException, Exception
	{
		boolean flag=false;
		String Query = "SELECT a=count(*) FROM USR_0_ODDD_DATACLASS_SEARCH_DTLS with (nolock) WHERE WINAME='"+processInstanceID+"' AND ID='"+rowSequence+"' AND (IBPS_Status in ('N','I') OR OFStatus in ('N','I'))";
		String FinalStatusInputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalStatusInputXML :"+FinalStatusInputXML);

		String FinalStatusOutputXML = CommonMethods.WFNGExecute(FinalStatusInputXML, JtsIp, JtsPort, 1);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalStatusOutputXML :"+FinalStatusOutputXML);

		XMLParser xmlParserAPSelectFinal = new XMLParser(FinalStatusOutputXML);
		String apSelectFinalMaincode = xmlParserAPSelectFinal.getValueOf("MainCode");
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectFinalMaincode :"+apSelectFinalMaincode);

		String xmlcountdtls = xmlParserAPSelectFinal.getValueOf("Record");
		XMLParser xmlParsercount = new XMLParser(xmlcountdtls);
		String recordvalue = xmlParsercount.getValueOf("a");
		int statusRecords = Integer.parseInt(recordvalue);
		
		if(apSelectFinalMaincode.equals("0") && statusRecords==0)
		{
			String whereClause1 = "WI_NAME = '"+processInstanceID+"' AND ROW_SEQUENCE = '"+rowSequence+"'";
			String apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_VENDOR_DATA_DTLS", "FINAL_STATUS,COMPLETED_DATA_TIME", "'Y',getDate()", whereClause1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
			String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
			XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
			String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
			if (apUpdateMaincode.equalsIgnoreCase("0")) 
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Final_Status updated as Y");
				flag=false;
			}
			else
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Final_Status update failed");
				flag=true;
			}
		}
		else
		{
			/*String whereClause1 = "WI_NAME = '"+processInstanceID+"' AND ROW_SEQUENCE = '"+rowSequence+"'";
			String apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_VENDOR_DATA_DTLS", "FINAL_STATUS", "'N'", whereClause1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
			String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
			XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
			String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
			if (apUpdateMaincode.equalsIgnoreCase("0")) 
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Final_Status updated as N");
				flag=true;
			}
			else
			{
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Final_Status update failed");
				flag=true;
			}*/
			flag = true;
		}
		return flag;
	}
	public String splitColumnValue(String searchValue)
	{
		if((searchValue==null || "".equalsIgnoreCase(searchValue)))
		{
			searchValue = "";
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("searchValue: is null");
		}
		else if(searchValue.contains("."))
		{
			String[] parts = searchValue.split("\\.");
			searchValue = parts[0];
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("searchValue: "+searchValue);
		}
		else
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("searchValue: "+searchValue);
		}
		return searchValue;
	}
	public boolean StatusUpdateQuery(String cabinetName,String sessionId,String JtsIp,String JtsPort,String processInstanceID,int rowSequence, String dataClassName, String callingEnv) throws IOException, Exception//PASS NECESSARY VALUES HERE //removed String searchValue, String searchType
	{
		boolean flag=false;
		String apUpdateInputXML="";
		//1
		String Query1 = "";
		if ("iBPS".equalsIgnoreCase(callingEnv))
			Query1 = "SELECT a=count(*) FROM USR_0_ODDD_DOC_DTLS with (nolock) WHERE WINAME='"+processInstanceID+"' AND ID='"+rowSequence+"' AND STATUS='N' AND SERVER='iBPS' AND DATA_CLASS_NAME='"+dataClassName+"'";
		else
			Query1 = "SELECT a=count(*) FROM USR_0_ODDD_DOC_DTLS with (nolock) WHERE WINAME='"+processInstanceID+"' AND ID='"+rowSequence+"' AND STATUS='N' AND SERVER='OmniFlow' AND DATA_CLASS_NAME='"+dataClassName+"'";
		
		try
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Inside StatusUpdateQuery method!");
			
			String FinalStatusInputXML = CommonMethods.apSelectWithColumnNames(Query1, cabinetName, sessionID);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalStatusInputXML :"+FinalStatusInputXML);

			String FinalStatusOutputXML = CommonMethods.WFNGExecute(FinalStatusInputXML, JtsIp, JtsPort, 1);
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalStatusOutputXML :"+FinalStatusOutputXML);

			XMLParser xmlParserAPSelectFinal = new XMLParser(FinalStatusOutputXML);
			String apSelectFinalMaincode = xmlParserAPSelectFinal.getValueOf("MainCode");
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectFinalMaincode :"+apSelectFinalMaincode);

			String xmlcountdtls = xmlParserAPSelectFinal.getValueOf("Record");
			XMLParser xmlParsercount = new XMLParser(xmlcountdtls);
			String recordvalue = xmlParsercount.getValueOf("a");
			int statusRecords = Integer.parseInt(recordvalue);
			
			if(apSelectFinalMaincode.equals("0") && statusRecords==0)
			{
				//String whereClause1 = "WINAME = '"+processInstanceID+"' AND ID = '"+rowSequence+"' AND SEARCH_VALUE='"+searchValue+"' AND SEARCH_TYPE='"+searchType+"' AND DATA_CLASS_NAME='"+dataClassName+"'";//ADD QUERY HERE
				
				String whereClause1 = "WINAME = '"+processInstanceID+"' AND ID = '"+rowSequence+"' AND DATA_CLASS_NAME='"+dataClassName+"'";//ADD QUERY HERE
				if ("iBPS".equalsIgnoreCase(callingEnv))
					apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_DATACLASS_SEARCH_DTLS", "iBPS_STATUS,iBPS_COMPLETED_DATETIME", "'Y',getdate()", whereClause1);
				else
					apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_DATACLASS_SEARCH_DTLS", "OFSTATUS,OFSTATUS_COMPLETED_DATETIME", "'Y',getdate()", whereClause1);
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
				String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
				XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
				String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
				if (apUpdateMaincode.equalsIgnoreCase("0")) 
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(callingEnv+" updated as Y");
					flag=false;
				}
				else
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(callingEnv+" update failed");
					flag=true;
				}
			}
			else
			{
				String whereClause1 = "WINAME = '"+processInstanceID+"' AND ID = '"+rowSequence+"' AND DATA_CLASS_NAME='"+dataClassName+"'";//ADD QUERY HERE
				if ("iBPS".equalsIgnoreCase(callingEnv))
					apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_DATACLASS_SEARCH_DTLS", "iBPS_STATUS,iBPS_COMPLETED_DATETIME", "'I',getdate()", whereClause1);
				else
					apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"USR_0_ODDD_DATACLASS_SEARCH_DTLS", "OFSTATUS,OFSTATUS_COMPLETED_DATETIME", "'I',getdate()", whereClause1);
				
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
				String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
				XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
				String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
				if (apUpdateMaincode.equalsIgnoreCase("0")) 
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(callingEnv+" updated as N");
					flag=true;
				}
				else
				{
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(callingEnv+" update failed");
					flag=true;
				}
			}
		}
		catch(Exception e)
		{
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception Occurred : "+e.getMessage());
			flag=true;
		}
		return flag;
	}
	
	
	public boolean finalStatusFlag(String processInstanceID, String sJtsIp, String iJtsPort, String sessionId)
	{
		boolean flag= false;
		
		String Query = "SELECT a=count(*) FROM USR_0_ODDD_VENDOR_DATA_DTLS with (nolock) WHERE WI_NAME='"+processInstanceID+"' AND (FINAL_STATUS='' OR FINAL_STATUS='N' OR FINAL_STATUS is null)";
		String FinalInputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalInputXML :"+FinalInputXML);

		String FinalOutputXML = "";
		try {
			FinalOutputXML = CommonMethods.WFNGExecute(FinalInputXML, sJtsIp, iJtsPort, 1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception while fetching data from VENDOR_DTLS table -- IO Exception :"+e.getMessage());
			e.printStackTrace();
			flag= true;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Exception while fetching data from VENDOR_DTLS table -- Exception :"+e.getMessage());
			e.printStackTrace();
			flag= true;
		}
		
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("FinalOutputXML :"+FinalOutputXML);

		XMLParser xmlParserAPSelect = new XMLParser(FinalOutputXML);
		String apSelectMaincode1 = xmlParserAPSelect.getValueOf("MainCode");
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode1);
		
		String xmlcountdtls = xmlParserAPSelect.getValueOf("Record");
		XMLParser xmlParsercount = new XMLParser(xmlcountdtls);
		String recordvalue = xmlParsercount.getValueOf("a");
		int statusRecords = Integer.parseInt(recordvalue);
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Value of a :"+statusRecords);
		
		if(apSelectMaincode1.equals("0") && statusRecords==0)
			flag= false;
		else
			flag= true;
	
	return flag;
	}
public void updateMap(String VendorName)
{
	if(!folderCount.containsKey(VendorName))
	{
		folderCount.put(VendorName, 0);
		folderPrefix.put(VendorName, 1);
		folderSuffix.put(VendorName, 1000);
	}
}
public int ValidateExcelHeader(String fileName,String cabinetName,String sessionId,String tag) {

	FileInputStream fis = null;
	try
	{
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" excel tag : "+ tag);			
		fis = new FileInputStream(new File(fileName));
		if(FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("xls"))
		{
			HSSFWorkbook workBook = new HSSFWorkbook(fis);
			HSSFSheet sheet = workBook.getSheet(tag);
			System.out.println(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
			//Iterator<Row> rowIterator = sheet.iterator();
			if(workBook.getSheetIndex(sheet)==-1)
			{
				return 2;
			}
			int count1=0,count2=0,count3=0,count4=0;
			for(Row row:sheet)
			{
				//Row row = rowIterator.next();
				//Iterator<Cell> cellIterator = row.cellIterator();
				for (Cell cell: row) //iteration over cell using for each loop  
			    {
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" cell : "+ cell);
					if(cell.getStringCellValue().equalsIgnoreCase("Vendor Name") && count1==0)
			        {
			        	count1++;
			        }
			        else if(cell.getStringCellValue().equalsIgnoreCase("Agreement No") && count2==0)
			        {
			        	count2++;
			        }	
			        else if(cell.getStringCellValue().equalsIgnoreCase("ECRN No.") && count3==0)
			        {
			        	count3++;
			        }
			        else if(cell.getStringCellValue().equalsIgnoreCase("CIF") && count4==0)
			        {
			        	count4++;
			        }
			        else
			        {
			        	//String Err_msg="Invalid Header: "+cell.getStringCellValue()+"Present ";
			        	ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("Invalid header in excel");
			        	return 1;
			        }
			    }
				ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("valid header in excel");
				return 0;
			}
		}
		else if (FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("XLSX"))
		{
			XSSFWorkbook workBook = new XSSFWorkbook(fis);
			XSSFSheet sheet = workBook.getSheet(tag);
			System.out.println(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
			ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
			//Iterator<Row> rowIterator = sheet.iterator();
			//ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" rowIterator : "+ rowIterator);
			int count1=0,count2=0,count3=0,count4=0;
		//	int flagForNewData = 0 ;
			if(workBook.getSheetIndex(sheet)==-1)
			{
				return 2;
			}
			for(Row row:sheet)
			{
				//Row row = rowIterator.next();
				//Iterator<Cell> cellIterator = row.cellIterator();
				for (Cell cell: row) //iteration over cell using for each loop  
			    {
					ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug(tag+" cell : "+ cell);
			        if(cell.getStringCellValue().equalsIgnoreCase("Vendor Name") && count1==0)
			        {
			        	count1++;
			        	
			        }
			        else if(cell.getStringCellValue().equalsIgnoreCase("Agreement No") && count2==0)
			        {
			        	count2++;
			        	
			        }	
			        else if(cell.getStringCellValue().equalsIgnoreCase("ECRN No.") && count3==0)
			        {
			        	count3++;
			        	
			        }
			        else if(cell.getStringCellValue().equalsIgnoreCase("CIF") && count4==0)
			        {
			        	count4++;
			        	
			        }
			        else
			        {
			        	//String Err_msg="Invalid Header: "+cell.getStringCellValue()+"Present ";
			        	return 1;
			        }
			    }
				return 0;
			}
		}
	}
	catch(IOException e)
	{
		ODDD_DocDownloadLog.ODDD_DocDownloadLogger.debug("exception in excel method "+e);
		e.printStackTrace();
	}
	finally
	{
		if(fis!=null)
		{
			try
			{
				fis.close();
			}
			catch(IOException e)
			{
				e.printStackTrace();
			}
		}
	}
	return 1;
}
}