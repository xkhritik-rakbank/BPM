package com.newgen.KYC.KYCodDownload;

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
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


import com.newgen.ODDD.ODDocDownload.ExcelData;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;

public class KYCodDownload implements Runnable
{
	private static String cifFromExtTable;
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
	
	public void run()
	{
		try
		{
			KYCodDownloadLog.setLogger();
			
			int configReadStatus = readConfig();

			KYCodDownloadLog.KYCodDownloadLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				KYCodDownloadLog.KYCodDownloadLogger.error("Could not Read Config Properties KYC_Od_Download_Config.properties");
				return;
			}
			
			cabinetName = CommonConnection.getCabinetName();
			KYCodDownloadLog.KYCodDownloadLogger.error("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			KYCodDownloadLog.KYCodDownloadLogger.error("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			KYCodDownloadLog.KYCodDownloadLogger.error("JTSPORT: " + jtsPort);						
			
			queueID = ODDocConfigParamMap.get("queueID");
			KYCodDownloadLog.KYCodDownloadLogger.error("QueueID: " + queueID);

			sleepIntervalInMin=Integer.parseInt(ODDocConfigParamMap.get("SleepIntervalInMin"));
			KYCodDownloadLog.KYCodDownloadLogger.error("SleepIntervalInMin: "+sleepIntervalInMin);
			
		sessionID = CommonConnection.getSessionID(KYCodDownloadLog.KYCodDownloadLogger, false);

			if(sessionID.trim().equalsIgnoreCase("")){
				KYCodDownloadLog.KYCodDownloadLogger.error("Could Not Connect to Server!");
			}
			else{
				KYCodDownloadLog.KYCodDownloadLogger.debug("Session ID found: " + sessionID);
				while(true){
					sessionID = CommonConnection.getSessionID(KYCodDownloadLog.KYCodDownloadLogger, false);
					KYCodDownloadLog.setLogger();
					KYCodDownloadLog.KYCodDownloadLogger.debug("KYC Doc Utility...123");				
					startKYCDownloadDocUtility(cabinetName, jtsIP, jtsPort,sessionID,queueID);
					System.out.println("No More workitems to Process at KYC_Download, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e){
			e.printStackTrace();
			KYCodDownloadLog.KYCodDownloadLogger.debug("Exception Occurred in ODDD : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			KYCodDownloadLog.KYCodDownloadLogger.debug("Exception Occurred in ODDD : "+result);
		}
	}
	
	private void startKYCDownloadDocUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,String queueID)
	{
		final String ws_name="Attach_Document";
		try{
			sessionID = CommonConnection.getSessionID(KYCodDownloadLog.KYCodDownloadLogger, false);

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null")){
				KYCodDownloadLog.KYCodDownloadLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}
			//Fetch all Work-Items on given queueID.
			KYCodDownloadLog.KYCodDownloadLogger.debug("Fetching all Workitems on KYC_Download queue");
			System.out.println("Fetching all Workitems on KYC_Download queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			KYCodDownloadLog.KYCodDownloadLogger.debug("InputXML for fetchWorkList Call KYC_Download: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= CommonMethods.WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			KYCodDownloadLog.KYCodDownloadLogger.debug("WMFetchWorkList OutputXML KYC_Download: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			KYCodDownloadLog.KYCodDownloadLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			KYCodDownloadLog.KYCodDownloadLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			KYCodDownloadLog.KYCodDownloadLogger.debug("Number of workitems retrieved on KYC_Download: "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on KYC_Download: "+fetchWorkitemListCount);
			String WI_AddDoc_Status = "";
			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					WI_AddDoc_Status = "";
					String fetchWorkItemlistData = xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData = fetchWorkItemlistData.replaceAll("[ ]+>", ">").replaceAll("<[ ]+", "<");

					KYCodDownloadLog.KYCodDownloadLogger
							.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: " + fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

					String processInstanceID = xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					KYCodDownloadLog.KYCodDownloadLogger.debug("Current ProcessInstanceID: " + processInstanceID);

					KYCodDownloadLog.KYCodDownloadLogger.debug("Processing Workitem: " + processInstanceID);
					System.out.println("\nProcessing Workitem: " + processInstanceID);

					String WorkItemID = xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					KYCodDownloadLog.KYCodDownloadLogger.debug("Current WorkItemID: " + WorkItemID);

					String entryDateTime = xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					KYCodDownloadLog.KYCodDownloadLogger.debug("Current EntryDateTime: " + entryDateTime);

					String ActivityName = xmlParserfetchWorkItemData.getValueOf("ActivityName");
					KYCodDownloadLog.KYCodDownloadLogger.debug("ActivityName: " + ActivityName);

					String ProcessDefID = xmlParserfetchWorkItemData.getValueOf("ProcessDefID");
					String activityId = xmlParserfetchWorkItemData.getValueOf("ActivityId");
					String activityName = xmlParserfetchWorkItemData.getValueOf("ActivityName");
					String queueId = xmlParserfetchWorkItemData.getValueOf("QueueID");

					// Lock Workitem.
					String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionId,
							processInstanceID, WorkItemID);
					String getWorkItemOutputXml = CommonMethods.WFNGExecute(getWorkItemInputXML, sJtsIp, iJtsPort, 1);
					KYCodDownloadLog.KYCodDownloadLogger
							.debug("Output XML For WmgetWorkItemCall: " + getWorkItemOutputXml);

					XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
					KYCodDownloadLog.KYCodDownloadLogger.debug("WmgetWorkItemCall Maincode:  " + getWorkItemMainCode);

					if (getWorkItemMainCode.trim().equals("0")) {
						KYCodDownloadLog.KYCodDownloadLogger
								.debug("WMgetWorkItemCall Successful: " + getWorkItemMainCode);
						
						String Query = "SELECT CIF_ID FROM RB_KYC_REM_EXTTABLE with (nolock) where WINAME = '"
								+ processInstanceID + "'";
						String InputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
						String OutputXML = CommonMethods.WFNGExecute(InputXML, jtsIP, jtsPort, 1);
						XMLParser xmlParserAPSelect = new XMLParser(OutputXML);
						String apSelectMaincode = xmlParserAPSelect.getValueOf("MainCode");
						int TotalRecords = Integer.parseInt(xmlParserAPSelect.getValueOf("TotalRetrieved"));
						if (apSelectMaincode.equals("0") && TotalRecords > 0) {
							cifFromExtTable = xmlParserAPSelect.getValueOf("CIF_ID");
						} else {
							KYCodDownloadLog.KYCodDownloadLogger.debug("Cif id not recieved ");
						}
						// cif extract external table from here
						// search variable
						if (!"".equalsIgnoreCase(cifFromExtTable)) {
							String Query1 = "SELECT * FROM RB_KYC_REM_DATA_CLASS_MASTER ";
							String ApSelectInputXML = CommonMethods.apSelectWithColumnNames(Query1, cabinetName,
									sessionID);
							String ApSelectOutputXML = CommonMethods.WFNGExecute(ApSelectInputXML, jtsIP, jtsPort, 1);
							XMLParser xmlParserAPSelectDataclass = new XMLParser(ApSelectOutputXML);
							String apSelectMaincodeDataclass = xmlParserAPSelectDataclass.getValueOf("MainCode");
							int TotalRecordsDataclassName = Integer
									.parseInt(xmlParserAPSelectDataclass.getValueOf("TotalRetrieved"));
							if (apSelectMaincodeDataclass.equals("0") && TotalRecordsDataclassName > 0) {
								List<Map<String, String>> DataFromDB = new ArrayList<Map<String, String>>();
								DataFromDB = getDataFromDBMap(Query1, cabinetName, sessionID, jtsIP, jtsPort);
								for (Map<String, String> entry : DataFromDB) {
									String dataClassName = entry.get("DATA_CLASS_NAME");
									String dataFieldType = entry.get("FIELD_TYPE");
									String dataClassNameDefId = entry.get("iBPS_DATA_DEF_ID");
									String dataFieldTypeDefId = entry.get("iBPS_FIELD_INDEX_ID");
									String searchDocInputXML = CommonMethods.NGOSearchDocument(dataClassNameDefId,
											dataFieldTypeDefId, cifFromExtTable, cabinetName, sessionId);// cif_no
																											// //4324343
									String searchDocOutputXML = CommonMethods.WFNGExecute(searchDocInputXML, jtsIP,
											jtsPort, 1);
									XMLParser xmlParserAPSearch = new XMLParser(searchDocOutputXML);
									String apSearchMaincode = xmlParserAPSearch.getValueOf("Status");
									System.out.print("Ap Search Main Code" + apSearchMaincode);
									
									int Record = Integer.parseInt(xmlParserAPSearch.getValueOf("TotalNoOfRecords"));
									System.out.print("TotalNoOfRecords" + Record);
									if (apSearchMaincode.equals("0") && Record > 0) {
										KYCodDownloadLog.KYCodDownloadLogger.debug("Documents Found");
										NGXmlList objWorkList = xmlParserAPSearch.createList("SearchResults",
												"SearchResult");
										KYCodDownloadLog.KYCodDownloadLogger.debug("objWorkList " + objWorkList);
										for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) {
											String docDetail = xmlParserAPSearch.getNextValueOf("SearchResult");
											XMLParser xmlDocDetail = new XMLParser(docDetail);
											String ISIndex = xmlDocDetail.getValueOf("ISIndex");
											KYCodDownloadLog.KYCodDownloadLogger.debug("ISIndex" + ISIndex);
											String StrimgIndex = xmlDocDetail.getValueOf("ISIndex").substring(0,
													xmlDocDetail.getValueOf("ISIndex").indexOf("#"));
											
											KYCodDownloadLog.KYCodDownloadLogger
													.debug("ISIndex substring " + StrimgIndex);
											String StrVolId = xmlDocDetail.getValueOf("ISIndex")
													.substring(xmlDocDetail.getValueOf("ISIndex").indexOf("#") + 1);
											KYCodDownloadLog.KYCodDownloadLogger
													.debug("VolId:" + StrVolId + " imgIndex :" + StrimgIndex);
											
											String DocIndex = xmlDocDetail.getValueOf("DocumentIndex");
											KYCodDownloadLog.KYCodDownloadLogger.debug("DocumentIndex" + DocIndex);

											String StrDocumentName = xmlDocDetail.getValueOf("DocumentName");
											if(!"AuditTrail".equalsIgnoreCase(StrDocumentName)){
											String StrCreatedByAppName = xmlDocDetail.getValueOf("CreatedByAppName");
											String lstrDocFileSize = xmlDocDetail.getValueOf("DocumentSize");
											String DocType = xmlDocDetail.getValueOf("DocumentType");
											KYCodDownloadLog.KYCodDownloadLogger.debug("StrDocumentName:"
													+ StrDocumentName + " StrCreatedByAppName :" + StrCreatedByAppName);
											// StrDocumentName+="_"+DocIndex;
											// getting parentFolderIndex of the
											// Workitem
											String query = "Select folderindex from pdbfolder with(nolock) where name = '"
													+ processInstanceID + "'";
											String apSelectInputXML = CommonMethods.apSelectWithColumnNames(query,
													cabinetName, sessionID);
											KYCodDownloadLog.KYCodDownloadLogger
													.debug("apSelectInputXML--- " + apSelectInputXML);
											String apSelectOutXml = CommonMethods.WFNGExecute(apSelectInputXML, jtsIP,
													jtsPort, 1);
											KYCodDownloadLog.KYCodDownloadLogger
													.debug("apSelectOutXml--- " + apSelectOutXml);
											XMLParser xmlParserAPSearchfolderIndex = new XMLParser(apSelectOutXml);
											String apSearchMaincodefolderIndex = xmlParserAPSearchfolderIndex
													.getValueOf("MainCode");
											if (apSearchMaincodefolderIndex.equalsIgnoreCase("0")) {
												String parentFolderIndex = xmlParserAPSearchfolderIndex
														.getValueOf("folderindex");
												String NGOaddDocInputXML = CommonMethods.getNGOAddDocumentKYC(
														parentFolderIndex, "Previous_Doc", DocType, StrCreatedByAppName,
														ISIndex, lstrDocFileSize, StrVolId, cabinetName, sessionId,StrDocumentName);
												KYCodDownloadLog.KYCodDownloadLogger
														.debug("NGOaddDocInputXML--- " + NGOaddDocInputXML);
												String NGOaddDocOutXml = CommonMethods.WFNGExecute(NGOaddDocInputXML,
														jtsIP, jtsPort, 1);
												KYCodDownloadLog.KYCodDownloadLogger
														.debug("NGOaddDocOutXml--- " + NGOaddDocOutXml);

												WI_AddDoc_Status = "Success";

											} else {
												WI_AddDoc_Status = "Error";
												break;
											}
											}
											else {
												KYCodDownloadLog.KYCodDownloadLogger
												.debug("Audit Trail doc not added");
											}
										}
										if ("Error".equalsIgnoreCase(WI_AddDoc_Status)) {
											break;
										}
									}
									else{
										KYCodDownloadLog.KYCodDownloadLogger.debug("No docs available in CIF");
										WI_AddDoc_Status = "Success";
									}
								}
							} else {
								KYCodDownloadLog.KYCodDownloadLogger.debug("Data Class Name no found ");
							}

						}
						else {
							KYCodDownloadLog.KYCodDownloadLogger.debug("CIF not found");
						}
					} else {
						WI_AddDoc_Status = "Error";
					}
					
					String getWorkItemInputXML1 = CommonMethods.getWorkItemInput(cabinetName, sessionId, processInstanceID,WorkItemID);
					String getWorkItemOutputXml1 = CommonMethods.WFNGExecute(getWorkItemInputXML,sJtsIp,iJtsPort,1);
					KYCodDownloadLog.KYCodDownloadLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);
					
					XMLParser xmlParserGetWorkItem1 = new XMLParser(getWorkItemOutputXml);
					String getWorkItemMainCode1 = xmlParserGetWorkItem.getValueOf("MainCode");
					KYCodDownloadLog.KYCodDownloadLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

					String remark = "";
					if (getWorkItemMainCode.trim().equals("0")){
					//completeWI
						String Final_Status ="";
						if("Success".equalsIgnoreCase(WI_AddDoc_Status)){
							Final_Status ="Success";
							remark = "Documents attached successfully";
						}
						else{
							Final_Status="Error";
							remark = "Error in attaching document";
						}
					String assignInputXML = "<?xml version=\"1.0\"?><WMAssignWorkItemAttributes_Input>"
                            + "<Option>WMAssignWorkItemAttributes</Option>"
                            + "<EngineName>"+cabinetName+"</EngineName>"
                            + "<SessionId>"+sessionId+"</SessionId>"
                            + "<ProcessInstanceId>"+processInstanceID+"</ProcessInstanceId>"
                            + "<WorkItemId>"+WorkItemID+"</WorkItemId>"
                            + "<ActivityId>"+activityId+"</ActivityId>"
                            + "<ProcessDefId>"+ProcessDefID+"</ProcessDefId>"
                            + "<LastModifiedTime></LastModifiedTime>"
                            + "<ActivityType></ActivityType>"
                            + "<complete>D</complete>"
                            + "<AuditStatus></AuditStatus>"
                            + "<Comments></Comments>"
                            + "<UserDefVarFlag>Y</UserDefVarFlag>"
                            + "<Attributes><DECISION>"+Final_Status+"</DECISION></Attributes>"
                            + "</WMAssignWorkItemAttributes_Input>";


					KYCodDownloadLog.KYCodDownloadLogger.debug("assignInputXML--- "+assignInputXML);
					String assignOutXml = CommonMethods.WFNGExecute(assignInputXML, jtsIP, jtsPort, 1);
					KYCodDownloadLog.KYCodDownloadLogger.debug("assignOutXml--- "+assignOutXml);
					// PRINT MAINCODE
					XMLParser xmlParserAPSelectFinal = new XMLParser(assignOutXml);
					String xmlParserAPSelectFinalMaincode = xmlParserAPSelectFinal.getValueOf("MainCode");
					if (xmlParserAPSelectFinalMaincode.equalsIgnoreCase("0")){
						
						Date d = new Date();
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String strDate = dateFormat.format(d);
						
						String tableName = "NG_KYC_REM_GR_HISTORY";
						String columnName = "DateTime,Workstep,Decision,UserName,Remarks,WI_Name,Entry_Date_Time";
						String values = "'"+strDate+"','Attach_Document','"+Final_Status+"','rakBPMutility','"+remark+"','"+processInstanceID+"','"+entryDateTime+"'";
						
						String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName,values,tableName);
						KYCodDownloadLog.KYCodDownloadLogger.debug("APInsertInputXML: "+apInsertInputXML);

						String apInsertOutputXML =CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
						KYCodDownloadLog.KYCodDownloadLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

						XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
						String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
						KYCodDownloadLog.KYCodDownloadLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
						if(apInsertMaincode.equalsIgnoreCase("0"))
						{
							KYCodDownloadLog.KYCodDownloadLogger.debug("ApInsert successful: "+apInsertMaincode);
							KYCodDownloadLog.KYCodDownloadLogger.debug("Data Inserted in history table successfully.");
						}
					}
					KYCodDownloadLog.KYCodDownloadLogger.debug("xmlParserAPSelectFinalMaincode :"+xmlParserAPSelectFinalMaincode);
					}
					
				}
			}
		}
		catch (Exception e){
			KYCodDownloadLog.KYCodDownloadLogger.debug("Exception ui: "+e.getMessage());
		}
	}
	
	private int readConfig(){
		Properties p = null;
		try {
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "KYC_Od_Download_Config.properties")));
			Enumeration<?> names = p.propertyNames();
			while (names.hasMoreElements()){
			    String name = (String) names.nextElement();
			    ODDocConfigParamMap.put(name, p.getProperty(name));
			}										
		}
		catch (Exception e){
			return -1 ;
		}
		return 0;
	}
	public boolean StatusUpdateQuery(String cabinetName,String sessionId,String JtsIp,String JtsPort,String processInstanceID,int rowSequence, String dataClassName, String callingEnv) throws IOException, Exception//PASS NECESSARY VALUES HERE //removed String searchValue, String searchType
	{
		boolean flag=false;
		String apUpdateInputXML="";
		//1
		String Query1 = "";
		if ("iBPS".equalsIgnoreCase(callingEnv))
			Query1 = "SELECT a=count(*) FROM KYC_0_ODDD_DOC_DTLS with (nolock) WHERE WINAME='"+processInstanceID+"' AND ID='"+rowSequence+"' AND STATUS='N' AND SERVER='iBPS' AND DATA_CLASS_NAME='"+dataClassName+"'";
		else
			Query1 = "SELECT a=count(*) FROM KYC_0_ODDD_DOC_DTLS with (nolock) WHERE WINAME='"+processInstanceID+"' AND ID='"+rowSequence+"' AND STATUS='N' AND SERVER='OmniFlow' AND DATA_CLASS_NAME='"+dataClassName+"'";
		
		try
		{
			KYCodDownloadLog.KYCodDownloadLogger.debug("Inside StatusUpdateQuery method!");
			
			String FinalStatusInputXML = CommonMethods.apSelectWithColumnNames(Query1, cabinetName, sessionID);
			KYCodDownloadLog.KYCodDownloadLogger.debug("FinalStatusInputXML :"+FinalStatusInputXML);

			String FinalStatusOutputXML = CommonMethods.WFNGExecute(FinalStatusInputXML, JtsIp, JtsPort, 1);
			KYCodDownloadLog.KYCodDownloadLogger.debug("FinalStatusOutputXML :"+FinalStatusOutputXML);

			XMLParser xmlParserAPSelectFinal = new XMLParser(FinalStatusOutputXML);
			String apSelectFinalMaincode = xmlParserAPSelectFinal.getValueOf("MainCode");
			KYCodDownloadLog.KYCodDownloadLogger.debug("apSelectFinalMaincode :"+apSelectFinalMaincode);

			String xmlcountdtls = xmlParserAPSelectFinal.getValueOf("Record");
			XMLParser xmlParsercount = new XMLParser(xmlcountdtls);
			String recordvalue = xmlParsercount.getValueOf("a");
			int statusRecords = Integer.parseInt(recordvalue);
			
			if(apSelectFinalMaincode.equals("0") && statusRecords==0)
			{
				//String whereClause1 = "WINAME = '"+processInstanceID+"' AND ID = '"+rowSequence+"' AND SEARCH_VALUE='"+searchValue+"' AND SEARCH_TYPE='"+searchType+"' AND DATA_CLASS_NAME='"+dataClassName+"'";//ADD QUERY HERE
				
				String whereClause1 = "WINAME = '"+processInstanceID+"' AND ID = '"+rowSequence+"' AND DATA_CLASS_NAME='"+dataClassName+"'";//ADD QUERY HERE
				if ("iBPS".equalsIgnoreCase(callingEnv))
					apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"KYC_0_ODDD_DATACLASS_SEARCH_DTLS", "iBPS_STATUS,iBPS_COMPLETED_DATETIME", "'Y',getdate()", whereClause1);
				else
					apUpdateInputXML = CommonMethods.apUpdateInput(cabinetName, sessionId,"KYC_0_ODDD_DATACLASS_SEARCH_DTLS", "OFSTATUS,OFSTATUS_COMPLETED_DATETIME", "'Y',getdate()", whereClause1);
				
				KYCodDownloadLog.KYCodDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
				String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
				KYCodDownloadLog.KYCodDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
				XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
				String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
				if (apUpdateMaincode.equalsIgnoreCase("0")) 
				{
					KYCodDownloadLog.KYCodDownloadLogger.debug(callingEnv+" updated as Y");
					flag=false;
				}
				else
				{
					KYCodDownloadLog.KYCodDownloadLogger.debug(callingEnv+" update failed");
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
				
				KYCodDownloadLog.KYCodDownloadLogger.debug("apUpdateInputXML: "+apUpdateInputXML);
				String apUpdateOutputXML = CommonMethods.WFNGExecute(apUpdateInputXML, JtsIp, JtsPort, 1);
				KYCodDownloadLog.KYCodDownloadLogger.debug("apUpdateOutputXML: "+apUpdateOutputXML);
				XMLParser xmlParserAPUpdate = new XMLParser(apUpdateOutputXML);
				String apUpdateMaincode = xmlParserAPUpdate.getValueOf("MainCode");
				if (apUpdateMaincode.equalsIgnoreCase("0")) 
				{
					KYCodDownloadLog.KYCodDownloadLogger.debug(callingEnv+" updated as N");
					flag=true;
				}
				else
				{
					KYCodDownloadLog.KYCodDownloadLogger.debug(callingEnv+" update failed");
					flag=true;
				}
			}
		}
		catch(Exception e)
		{
			KYCodDownloadLog.KYCodDownloadLogger.debug("Exception Occurred : "+e.getMessage());
			flag=true;
		}
		return flag;
	}
	public boolean SearchDocument(String cabinetName,String sessionId,String JtsIp,String JtsPort,String tempDataDefId,String tempFieldIndexId,String searchValue, String tempFieldType,String processInstanceID,String vendorName,String tempDataClassName,String tempOFDataDefId,String tempOFFieldIndexId, int count, String callingEnv, String folderName)
	{ 
		boolean flag=false;
		
		try 
		{
			KYCodDownloadLog.KYCodDownloadLogger.debug("Inside SearchDocument method -- for "+callingEnv);
			//String [] env=new String[] {cabinetName,CommonConnection.getOFCabinetName()};
			String env_SessionId="";
			String env_jtsIp="";
			String env_jtsPort="";
			String DataDefID="";
			String FieldIndexID ="";
			String ServerDetails="";
			String cabinetNameForEnv = cabinetName;
			
			
			
			//KYCodDownloadLog.KYCodDownloadLogger.debug("env_chosen: "+env_chosen);
			if(callingEnv.equalsIgnoreCase("iBPS"))//if(env_chosen==0)
			{
				env_SessionId=sessionId;
				env_jtsIp=JtsIp;
				env_jtsPort=JtsPort;
				DataDefID=tempDataDefId;
				FieldIndexID=tempFieldIndexId;
				ServerDetails="iBPS";
				KYCodDownloadLog.KYCodDownloadLogger.debug("rak_bpm credentials: "+env_SessionId+"\n"+env_jtsIp+"\n"+env_jtsPort+"\n"+DataDefID+"\n"+FieldIndexID);
			}
			else
			{
				env_SessionId=CommonConnection.getOFSessionID(KYCodDownloadLog.KYCodDownloadLogger, false);
				env_jtsPort=CommonConnection.getOFJTSPort();
				env_jtsIp=CommonConnection.getOFJTSIP();
				DataDefID=tempOFDataDefId;
				FieldIndexID=tempOFFieldIndexId;
				ServerDetails="OmniFlow";
				cabinetNameForEnv = CommonConnection.getOFCabinetName();
				KYCodDownloadLog.KYCodDownloadLogger.debug("rakcabinet_first credentials: "+env_SessionId+"\n"+env_jtsIp+"\n"+env_jtsPort+"\n"+DataDefID+"\n"+FieldIndexID);
			}
			String searchDocInputXML = CommonMethods.NGOSearchDocument(DataDefID,FieldIndexID,searchValue,cabinetNameForEnv,env_SessionId);//cif_no //4324343
			/*String searchDocInputXML = CommonMethods.NGOSearchDocument("19","4340",searchValue,env[i],env_SessionId);*/
			KYCodDownloadLog.KYCodDownloadLogger.debug("searchDocInputXML: "+searchDocInputXML);
			String searchDocOutputXML=CommonMethods.WFNGExecute(searchDocInputXML,env_jtsIp,env_jtsPort,1);
			KYCodDownloadLog.KYCodDownloadLogger.debug("searchDocOutputXML: "+searchDocOutputXML);
			XMLParser xmlParsersearchDoc = new XMLParser(searchDocOutputXML);
			String searchDocMaincode = xmlParsersearchDoc.getValueOf("Status");
			int Record = Integer.parseInt(xmlParsersearchDoc.getValueOf("TotalNoOfRecords"));
			KYCodDownloadLog.KYCodDownloadLogger.debug("searchDocMaincode: "+searchDocMaincode);                			
			
			if (searchDocMaincode.equalsIgnoreCase("0"))
			{
				KYCodDownloadLog.KYCodDownloadLogger.debug("Document searched successfully");
				if(Record > 0) 
				{
					
					NGXmlList objWorkList = xmlParsersearchDoc.createList("SearchResults", "SearchResult");
					KYCodDownloadLog.KYCodDownloadLogger.debug("objWorkList "+objWorkList);
					for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) 
					{		
						String docDetail = xmlParsersearchDoc.getNextValueOf("SearchResult");
						XMLParser xmlDocDetail = new XMLParser(docDetail);
						String ISIndex = xmlDocDetail.getValueOf("ISIndex");
						KYCodDownloadLog.KYCodDownloadLogger.debug("ISIndex"+ISIndex);
						String StrimgIndex = xmlDocDetail.getValueOf("ISIndex").substring(0, xmlDocDetail.getValueOf("ISIndex").indexOf("#"));
						//String imageIndex = xmlParser.getValueOf("ISIndex").substring(0, xmlParser.getValueOf("ISIndex").indexOf("#"));
						KYCodDownloadLog.KYCodDownloadLogger.debug("ISIndex substring "+StrimgIndex);
						//String StrVolId = xmlParsersearchDoc.getValueOf("ISIndex").substring(xmlParsersearchDoc.getValueOf("ISIndex").indexOf("#")+1,xmlParsersearchDoc.getValueOf("ISIndex").lastIndexOf("#"));
						String StrVolId = xmlDocDetail.getValueOf("ISIndex").substring(xmlDocDetail.getValueOf("ISIndex").indexOf("#")+1);
						KYCodDownloadLog.KYCodDownloadLogger.debug("VolId:"+StrVolId+" imgIndex :"+StrimgIndex);
						/**Same docs download issue -29122021 **/
						String DocIndex = xmlDocDetail.getValueOf("DocumentIndex");
						KYCodDownloadLog.KYCodDownloadLogger.debug("DocumentIndex"+DocIndex);
						
						String StrDocumentName = xmlDocDetail.getValueOf("DocumentName");
						String StrCreatedByAppName = xmlDocDetail.getValueOf("CreatedByAppName");
						KYCodDownloadLog.KYCodDownloadLogger.debug("StrDocumentName:"+StrDocumentName+" StrCreatedByAppName :"+StrCreatedByAppName);
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
						KYCodDownloadLog.KYCodDownloadLogger.debug("apInsertInputXML1: "+apInsertInputXML1);
						String apInsertOutputXML1 = CommonMethods.WFNGExecute(apInsertInputXML1, JtsIp, JtsPort, 1);
						KYCodDownloadLog.KYCodDownloadLogger.debug("apInsertOutputXML1: "+apInsertOutputXML1);
						XMLParser xmlParserAPInsert1 = new XMLParser(apInsertOutputXML1);
						String apInsertMaincode1 = xmlParserAPInsert1.getValueOf("MainCode");
						KYCodDownloadLog.KYCodDownloadLogger.debug("apInsertMaincode1: "+apInsertMaincode1);
					}
				}
				else
				{
					KYCodDownloadLog.KYCodDownloadLogger.debug("Document searched but no docs found");
					boolean outputStatus = StatusUpdateQuery(cabinetName,sessionId,JtsIp,JtsPort,processInstanceID,count,tempDataClassName,callingEnv);//searchValue,tempFieldType
					KYCodDownloadLog.KYCodDownloadLogger.debug("After Setting IBPS_STATUS and OF_STATUS -- returnvalue : "+outputStatus);
				}
			}
			else
			{
				KYCodDownloadLog.KYCodDownloadLogger.debug("Error in Document Search!");                			
				flag=true;
			}
		}
		catch(Exception e)
		{
			KYCodDownloadLog.KYCodDownloadLogger.debug("SearchDocument Exception occurred : "+e.getMessage());
			flag=true;
		}
		return flag;
	}
	
	
	public String DataClassInsertion(int count,String processInstanceID,String vendorName,String tempDataClassName,String tempDataDefId,String tempFieldIndexId,String searchValue,String tempFieldType,String strCurrDateTime,String cabinetName,String sessionId,String columnNames1,String JtsIp,String JtsPort,String tempOFDataDefId,String tempOFFieldIndexId) throws Exception
	{
	    String columnValues1 = "'"+count+"','"+processInstanceID+"','"+vendorName+"','"+tempDataClassName+"','"+tempDataDefId+"','"+tempFieldIndexId+"','"+searchValue+"','"+tempFieldType+"','N','','N','','"+tempOFDataDefId+"','"+tempOFFieldIndexId+"'";
	    String apInsertInputXML1 = CommonMethods.apInsert(cabinetName, sessionId, columnNames1, columnValues1,"KYC_0_ODDD_DATACLASS_SEARCH_DTLS");
	    KYCodDownloadLog.KYCodDownloadLogger.debug("apInsertInputXML1: "+apInsertInputXML1);
	    String apInsertOutputXML1 = CommonMethods.WFNGExecute(apInsertInputXML1, JtsIp, JtsPort, 1);
	    KYCodDownloadLog.KYCodDownloadLogger.debug("apInsertOutputXML1: "+apInsertOutputXML1);
	    XMLParser xmlParserAPInsert1 = new XMLParser(apInsertOutputXML1);
	    String apInsertMaincode1 = xmlParserAPInsert1.getValueOf("MainCode");
	    KYCodDownloadLog.KYCodDownloadLogger.debug("apInsertMaincode1: "+apInsertMaincode1);
	    return apInsertMaincode1;
	}
	
	
	
	public static List<ExcelData> ExtractDataFromDSTable(String CabinetName, String sessionID, String sJtsIp, String iJtsPort, String processInstanceID, String nextRowSequence) throws Exception 
	{
		KYCodDownloadLog.KYCodDownloadLogger.debug("Inside ExtractDataFromDSTable method!");
		List<ExcelData> listRecordList = new ArrayList<ExcelData>();
		String Query = "SELECT DATA_CLASS_NAME,FIELD_TYPE,DataDefName FROM KYC_0_ODDD_DATA_CLASS_MASTER with (nolock) where IsActive='Y'";
		//String Query2 ="SELECT VENDOR_NAME, DATA_CLASS_NAME, iBPS_DATA_DEF_ID, iBPS_FIELD_INDEX_ID, SEARCH_VALUE, SEARCH_TYPE, OF_DATA_DEF_ID, OF_FIELD_INDEX_ID,iBPS_STATUS,OFSTATUS FROM USR_0_ODDD_DATACLASS_SEARCH_DTLS with(nolock) WHERE WINAME ='"+processInstanceID+"' AND ID ='"+nextRowSequence+"' AND (iBPS_STATUS in ('N','I')  OR OFSTATUS  in ('N','I'))";
	    String InputXML = CommonMethods.apSelectWithColumnNames(Query, CabinetName, sessionID);
		KYCodDownloadLog.KYCodDownloadLogger.debug("InputXML :"+InputXML);
		String OutputXML = CommonMethods.WFNGExecute(InputXML, sJtsIp, iJtsPort, 1);
		KYCodDownloadLog.KYCodDownloadLogger.debug("OutputXML :"+OutputXML);
		XMLParser xmlParserAPSelect = new XMLParser(OutputXML);
		String apSelectMaincode = xmlParserAPSelect.getValueOf("MainCode");
		int TotalRecords = Integer.parseInt(xmlParserAPSelect.getValueOf("TotalRetrieved"));
		KYCodDownloadLog.KYCodDownloadLogger.debug("apSelectMaincode :"+apSelectMaincode);
		KYCodDownloadLog.KYCodDownloadLogger.debug("Total No. of records fetched :"+TotalRecords);
		if(apSelectMaincode.equals("0") && TotalRecords>0)
		{
			NGXmlList objWorkList = xmlParserAPSelect.createList("Records", "Record");
			ExcelData RecordList = new ExcelData();
			for (; objWorkList.hasMoreElements(true); objWorkList.skip(true)) 
			{   		
				KYCodDownloadLog.KYCodDownloadLogger.debug("VENDOR_NAME :"+objWorkList.getVal("VENDOR_NAME"));
				RecordList.setStrVendor_Name(objWorkList.getVal("VENDOR_NAME"));

				KYCodDownloadLog.KYCodDownloadLogger.debug("DATA_CLASS_NAME :"+objWorkList.getVal("DATA_CLASS_NAME"));
				RecordList.setStrDataclassName(objWorkList.getVal("DATA_CLASS_NAME"));

				KYCodDownloadLog.KYCodDownloadLogger.debug("iBPS_DATA_DEF_ID :"+objWorkList.getVal("iBPS_DATA_DEF_ID"));
				RecordList.setStrDataDefID(objWorkList.getVal("iBPS_DATA_DEF_ID"));

				KYCodDownloadLog.KYCodDownloadLogger.debug("iBPS_FIELD_INDEX_ID :"+objWorkList.getVal("iBPS_FIELD_INDEX_ID"));
				RecordList.setStrFieldIndexfID(objWorkList.getVal("iBPS_FIELD_INDEX_ID"));

				KYCodDownloadLog.KYCodDownloadLogger.debug("SEARCH_VALUE :"+objWorkList.getVal("SEARCH_VALUE"));
				RecordList.setStrSearchValue(objWorkList.getVal("SEARCH_VALUE"));

				KYCodDownloadLog.KYCodDownloadLogger.debug("SEARCH_TYPE :"+objWorkList.getVal("SEARCH_TYPE"));
				RecordList.setStrSearchType(objWorkList.getVal("SEARCH_TYPE"));
				
				KYCodDownloadLog.KYCodDownloadLogger.debug("OF_DATA_DEF_ID :"+objWorkList.getVal("OF_DATA_DEF_ID"));
				RecordList.setStrDataDefID_OF(objWorkList.getVal("OF_DATA_DEF_ID"));
				
				KYCodDownloadLog.KYCodDownloadLogger.debug("OF_FIELD_INDEX_ID :"+objWorkList.getVal("OF_FIELD_INDEX_ID"));
				RecordList.setStrFieldIndexfID_OF(objWorkList.getVal("OF_FIELD_INDEX_ID"));
				
				KYCodDownloadLog.KYCodDownloadLogger.debug("iBPS_STATUS :"+objWorkList.getVal("iBPS_STATUS"));
				RecordList.setStriBPSStatus(objWorkList.getVal("iBPS_STATUS"));
				
				KYCodDownloadLog.KYCodDownloadLogger.debug("OFSTATUS :"+objWorkList.getVal("OFSTATUS"));
				RecordList.setStrOFStatus(objWorkList.getVal("OFSTATUS"));

				listRecordList.add(RecordList);
			}
		}
		else
		{
			KYCodDownloadLog.KYCodDownloadLogger.debug("Inside else - ExtractDataFromDSTable method -- apSelectMaincode :"+apSelectMaincode);
		}
		return listRecordList;
	}
	private static List<Map<String, String>> getDataFromDBMap(String query, String cabinetName, String sessionID,
			String jtsIP, String jtsPort) {
		List<Map<String, String>> temp = new ArrayList<Map<String, String>>();
		try {
			KYCodDownloadLog.KYCodDownloadLogger.debug("Inside function getDataFromDB");
			KYCodDownloadLog.KYCodDownloadLogger.debug("getDataFromDB query is: " + query);
			String InputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			String OutXml = CommonMethods.WFNGExecute(InputXML, jtsIP, jtsPort, 1);
			OutXml = OutXml.replaceAll("&", "#andsymb#");
			Document recordDoc1 = MapXML.getDocument(OutXml);
			NodeList records1 = recordDoc1.getElementsByTagName("Record");
			if (records1.getLength() > 0) {
				for (int i = 0; i < records1.getLength(); i++) {
					Node n = records1.item(i);
					Map<String, String> t = new HashMap<String, String>();
					if (n.hasChildNodes()) {
						NodeList child = n.getChildNodes();
						for (int j = 0; j < child.getLength(); j++) {
							Node n1 = child.item(j);
							String column = n1.getNodeName();
							String value = n1.getTextContent().replaceAll("#andsymb#", "&");
							if (null != value && !"null".equalsIgnoreCase(value) && !"".equals(value)) {
								KYCodDownloadLog.KYCodDownloadLogger
										.debug("getDataFromDBMap Setting value of " + column + " as " + value);
								t.put(column, value);
							} else {
								KYCodDownloadLog.KYCodDownloadLogger
										.debug("getDataFromDBMap Setting value of " + column + " as blank");
								t.put(column, "");
							}
						}
					}
					temp.add(t);
				}
			}

		} catch (Exception e) {
			KYCodDownloadLog.KYCodDownloadLogger.debug("Exception occured in getDataFromDBMap method" + e.getMessage());
		}
		return temp;

	}
	
}
