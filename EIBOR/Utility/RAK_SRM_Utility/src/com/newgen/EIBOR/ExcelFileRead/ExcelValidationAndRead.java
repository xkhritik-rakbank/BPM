package com.newgen.EIBOR.ExcelFileRead;

import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.newgen.SRM.CSRMR.SROHoldCheck.CSRMRSROHoldCheckLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.file.DirectoryStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

public class ExcelValidationAndRead implements Runnable{
	
	static DataFormatter df = new DataFormatter();
	private static NGEjbClient ngEjbClientEiborReadExcel;
    static Map<String, String> EiborReadExcelConfigParamMap= new HashMap<String, String>();
    private int sheetCount;
    public static String newFilename=null;
    public static String sdate=""; public static boolean catchflag=false;
    public static String TimeStamp="";
    public static String toMailID = "";
    public static String fromMailID = "";
    public  static String smsPort;
    public  static String volumeID = "";
    public  static String sessionID = "";
    
	@Override
	public void run()
	{
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		String queueID = "";
		int integrationWaitTime=0;
		int sleepIntervalInMin=0;
		
		try
		{
			ExcelReadLog.setLogger();
			ngEjbClientEiborReadExcel = NGEjbClient.getSharedInstance();

			ExcelReadLog.ExcelReadLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			ExcelReadLog.ExcelReadLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				ExcelReadLog.ExcelReadLogger.error("Could not Read Config Properties [EiborReadExcel]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			ExcelReadLog.ExcelReadLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			ExcelReadLog.ExcelReadLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			ExcelReadLog.ExcelReadLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			ExcelReadLog.ExcelReadLogger.debug("smsPort: " + smsPort);

			queueID = EiborReadExcelConfigParamMap.get("queueID");
			ExcelReadLog.ExcelReadLogger.debug("QueueID: " + queueID);
			
			volumeID = EiborReadExcelConfigParamMap.get("volumeID");
			ExcelReadLog.ExcelReadLogger.debug("VolumeID: " + volumeID);
			
			fromMailID = EiborReadExcelConfigParamMap.get("fromEmail");
			ExcelReadLog.ExcelReadLogger.debug("fromMailID: " + fromMailID);
			
			toMailID = EiborReadExcelConfigParamMap.get("toEmail");
			ExcelReadLog.ExcelReadLogger.debug("fromMailID: " + fromMailID);
			
			sheetCount = Integer.parseInt(EiborReadExcelConfigParamMap.get("sheetCount"));
			ExcelReadLog.ExcelReadLogger.debug("sheetCount: " + sheetCount);
			Calendar calendarObj = Calendar.getInstance();
			Date date = calendarObj.getTime();
			String todayDayName = new SimpleDateFormat("EEEE", Locale.ENGLISH).format(date.getTime());
			ExcelReadLog.ExcelReadLogger.debug("todayDayName: " + todayDayName);
			if(todayDayName.equalsIgnoreCase("Monday"))
				sheetCount = 8;

			sleepIntervalInMin=Integer.parseInt(EiborReadExcelConfigParamMap.get("SleepIntervalInMin"));
			ExcelReadLog.ExcelReadLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);


			sessionID = CommonConnection.getSessionID(ExcelReadLog.ExcelReadLogger, false);

			if(sessionID.trim().equalsIgnoreCase(""))
			{
				ExcelReadLog.ExcelReadLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				ExcelReadLog.ExcelReadLogger.debug("Session ID found: " + sessionID);
				
				while(true)
				{
					ExcelReadLog.setLogger();
					ExcelReadLog.ExcelReadLogger.debug("EIBOR Read Excel Check...123.");
					startExcelFileReadUtility(cabinetName, jtsIP, jtsPort,sessionID,
							queueID, integrationWaitTime);
				    System.out.println("No More files to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*6000);
				}
			}
		}

		catch(Exception e)
		{
			e.printStackTrace();
			ExcelReadLog.ExcelReadLogger.error("Exception Occurred in CSR_MR SRO Hold Check : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			ExcelReadLog.ExcelReadLogger.error("Exception Occurred in iRBL AO Approval Hold : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "EiborReadExcel_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			  {
			    String name = (String) names.nextElement();
			    EiborReadExcelConfigParamMap.put(name, p.getProperty(name));
			  }
		    }
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}
	
	private void startExcelFileReadUtility(String cabinetName,String sJtsIp,String iJtsPort,String sessionId,
			String queueID, int integrationWaitTime)
	{
		try
		{
			//Validate Session ID
			sessionId  = CommonConnection.getSessionID(ExcelReadLog.ExcelReadLogger, false);
			boolean finalReadStatus = false;

			if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
			{
				ExcelReadLog.ExcelReadLogger.error("Could Not Get Session ID "+sessionId);
				return;
			}
			
			//Fetch all Work-Items on given queueID.
			ExcelReadLog.ExcelReadLogger.debug("Fetching workitems from eibor initiation queue");
			System.out.println("Fetching workitems from eibor initiation queue");
			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionId, queueID);
			ExcelReadLog.ExcelReadLogger.debug("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML= WFNGExecute(fetchWorkitemListInputXML,sJtsIp,iJtsPort,1);

			ExcelReadLog.ExcelReadLogger.debug("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			ExcelReadLog.ExcelReadLogger.debug("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
			ExcelReadLog.ExcelReadLogger.debug("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

			ExcelReadLog.ExcelReadLogger.debug("Number of workitems retrieved on eibor initiation : "+fetchWorkitemListCount);

			System.out.println("Number of workitems retrieved on eibor initiation : "+fetchWorkitemListCount);
			
			DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd"); 
			LocalDateTime now = LocalDateTime.now();
			String todayDate = dtf.format(now);
			ExcelReadLog.ExcelReadLogger.debug("todayDate : "+todayDate);
			
			String fetchAttributeInputXML="";
			String fetchAttributeOutputXML="";
			
			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<=fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					ExcelReadLog.ExcelReadLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser();
					xmlParserfetchWorkItemData.setInputXML(fetchWorkItemlistData);

					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					ExcelReadLog.ExcelReadLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					ExcelReadLog.ExcelReadLogger.debug("Current EntryDateTime: "+entryDateTime);
					
					String workitemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					ExcelReadLog.ExcelReadLogger.debug("Current WorkItemId: "+workitemID);
					
					if(entryDateTime.contains(todayDate)){
						fetchAttributeInputXML = CommonMethods.getFetchWorkItemAttributesXML(cabinetName,sessionId,processInstanceID,workitemID);
						ExcelReadLog.ExcelReadLogger.debug("FetchAttributeInputXMl "+fetchAttributeInputXML);
						fetchAttributeOutputXML=WFNGExecute(fetchAttributeInputXML,sJtsIp,iJtsPort,1);
						fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("&","&amp;");
						ExcelReadLog.ExcelReadLogger.debug("fetchAttributeOutputXML "+fetchAttributeOutputXML);
						String folderIndex = "";
						XMLParser xmlParserFetchWorkItemAttr = new XMLParser(fetchAttributeOutputXML);
						for(int j=0; j<=xmlParserFetchWorkItemAttr.getNoOfFields("Attribute"); j++){
							String fetchWorkItemAttrData=xmlParserFetchWorkItemAttr.getNextValueOf("Attribute");
							fetchWorkItemAttrData =fetchWorkItemAttrData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

							ExcelReadLog.ExcelReadLogger.debug("Parsing <Attribute> in FetchAttributeInputXMl OutputXML: "+fetchWorkItemAttrData);
							XMLParser xmlParserfetchWorkItemAttrData = new XMLParser();
							xmlParserfetchWorkItemAttrData.setInputXML(fetchWorkItemAttrData);

							String nameTag=xmlParserfetchWorkItemAttrData.getValueOf("Name");
							ExcelReadLog.ExcelReadLogger.debug("Current nameTag: "+nameTag);
							
							if(nameTag.equalsIgnoreCase("ITEMINDEX")){
								folderIndex=xmlParserfetchWorkItemAttrData.getValueOf("Value");
								ExcelReadLog.ExcelReadLogger.debug("folderIndex: "+folderIndex);
								break;
							}
						}
						ExcelReadLog.ExcelReadLogger.debug("folderIndex outside loop: "+folderIndex);
						finalReadStatus = readExcel(cabinetName, sessionId,sJtsIp, iJtsPort,processInstanceID,folderIndex);
					}	
					else
						continue;
				}
			}
			      
		}
		catch (Exception e)
		{
			ExcelReadLog.ExcelReadLogger.debug("Exception: "+e.getMessage());
		}
	}

    private boolean readExcel(String cabinetName,String sessionId,String JtsIp,String JtsPort,String processInstanceID,String parentFolder){
    	
    	ExcelReadLog.ExcelReadLogger.debug("Inside readExcelMethod");
    	
    	boolean returnStr = false;
    	int mapKeySize = 0; boolean insertionFlag = false;
    	int emptyMapFlag = 0;
    	int itr = 1;
    	String fileParam = "";
    	// Iterate through each sheet
    	String folderPath = ExcelValidationAndRead.EiborReadExcelConfigParamMap.get("DocumentFolderPath");
		Path folder = Paths.get(folderPath);
		try(DirectoryStream<Path> stream = Files.newDirectoryStream(folder)){
			for(Path file: stream){
				
				System.out.println(file.getFileName());
				if(file.getFileName().toString().contains("DF2"))
					fileParam = "DF2";
				else if(file.getFileName().toString().contains("Finacle"))
					fileParam = "Finacle";
				else if(file.getFileName().toString().contains("Flexcube"))
					fileParam = "Flexcube";
				else if(file.getFileName().toString().contains("MM"))
					fileParam = "MM";
				String workBookData[] = ExcelValidationAndRead.EiborReadExcelConfigParamMap.get(fileParam).split("~"); // Current workBook data
	            String workBookName = file.getFileName().toString();
	            String expectedHeaders[] = workBookData[0].split(",");
	            String DBTableName = workBookData[1];
	            String DBTableHeaders[] = workBookData[2].split(",");

	            ExcelReadLog.ExcelReadLogger.debug("\nWorkBookData is ---->" + Arrays.toString(workBookData) +"\n");

	            try {
	                // Path to the Excel file
	                String filePath = ExcelValidationAndRead.EiborReadExcelConfigParamMap.get("DocumentFolderPath")+workBookName;
	                ExcelReadLog.ExcelReadLogger.debug("\filePath is ---->" + filePath);

	                InputStream fis = new FileInputStream(filePath);
	            	
	                Workbook workbook;
	                if (filePath.toLowerCase().endsWith(".xlsx")) {
	                	workbook = new XSSFWorkbook(fis); // For .xlsx files
	                } else if (filePath.toLowerCase().endsWith(".xls")) {
	                    workbook = new HSSFWorkbook(fis); // For .xls files
	                } else {
	                	fis.close();
	                    throw new IllegalArgumentException("Invalid file format. Supported formats are .xlsx and .xls");
	                }

	                // Get the sheet by name
	                Sheet sheet = workbook.getSheet("Sheet1"); // Current sheet

	                if (sheet == null) {
	                	ExcelReadLog.ExcelReadLogger.debug("Error: Sheet '" + workBookName + "' not found in the Excel file.");
	                    return false;
	                }

	                // Read header row to get column names
	                int headerRowNum = workBookName.contains("Finacle") || workBookName.contains("Flexcube") ? 1 : sheet.getFirstRowNum();
	                
	                Row headerRow = sheet.getRow(headerRowNum); // toDo
	                ExcelReadLog.ExcelReadLogger.debug("Header starts at :" + headerRowNum + "\n");
	                int columnCount = headerRow.getPhysicalNumberOfCells();

	                Set<String> headerRowSet = new LinkedHashSet<>(); 
	                // Validate header count for first row
	                if (!validateHeaders(expectedHeaders, headerRow, headerRowSet,workBookName)) {
	                	ExcelReadLog.ExcelReadLogger.debug("Error: Number of headers/Name of headers for sheet '" + workBookName + "' and Excel file does not match.");
	                    return false;
	                }

	                List<Map<String, String>> dataList = new ArrayList<>(); // Used this in manner to easily insert data into DB

	                // Iterate through each row starting from the second row (data rows)
	                int flag = 0, rowIndex = workBookName.contains("MM Deals") ? headerRowNum+2 : headerRowNum+1 ;
	                ExcelReadLog.ExcelReadLogger.debug("rowIndex: " + rowIndex);
	                
	                for (;rowIndex <= sheet.getLastRowNum(); rowIndex++) { // toDo start and end
	                    Row row = sheet.getRow(rowIndex);

	                    // Create a map for each row
	                    Map<String, String> dataMap = new LinkedHashMap<>();

	                    // Iterate through each cell in the row
	                    boolean dataFound = false;
	                    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
	                    	Cell cell = row.getCell(columnIndex, Row.CREATE_NULL_AS_BLANK);
	                    	String cellValue = "";
	                    	
	                    	//
	                    	if (cell.getCellType() == 0) { // numeric
	                            if (DateUtil.isCellDateFormatted(cell)) {
	                                // Handle date values
	                            	if(workBookName.contains("MM Deals") && columnIndex == 1){
//	                            		convert current string value into --:00 minutes format
	                            		String columnHeader = headerRow.getCell(columnIndex, Row.CREATE_NULL_AS_BLANK).toString().trim();
	                            		ExcelReadLog.ExcelReadLogger.debug("date if columnHeader : "+ columnHeader);
	                            		Date cellDate = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
	                            		ExcelReadLog.ExcelReadLogger.debug("cell data: "+ cellDate.toString());
	                            		DateFormat universalDF = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy", Locale.getDefault());
		                            	DateFormat writeDFMM = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		                            	Date convertedDate = null;
		                            	try {
		                            		convertedDate = universalDF.parse(cellDate.toString());
		                            		
		                            	} catch (Exception e) {
		                            		e.printStackTrace();
		                            	}
		                            	if(convertedDate != null) cellValue = writeDFMM.format(convertedDate);
		                            	ExcelReadLog.ExcelReadLogger.debug("cellValue data: "+ cellValue.toString());
	                            	}else{
	                            		Date cellDate = HSSFDateUtil.getJavaDate(cell.getNumericCellValue());
		                            	DateFormat universalDF = new SimpleDateFormat("EEE MMM dd HH:mm:ss z yyyy", Locale.getDefault());
		                            	DateFormat writeDF = new SimpleDateFormat("yyyy-MM-dd");
		                            	Date convertedDate = null;
		                            	try {
		                            		convertedDate = universalDF.parse(cellDate.toString());
		                            		
		                            	} catch (Exception e) {
		                            		e.printStackTrace();
		                            	}
		                            	if(convertedDate != null) cellValue = writeDF.format(convertedDate);
	                            	}
	                            	
	                            	                                
	                            } else {
	                                // Handle numeric values without decimal places
	                                if (cell.getNumericCellValue() == (int) cell.getNumericCellValue()) {
	                                    cellValue = String.valueOf((int) cell.getNumericCellValue()).trim();
	                                } else {
	                                    // Handle numeric values with decimal places
	                                    cellValue = df.formatCellValue(cell).toString().trim();
	                                }
	                            }
	                            
	                        } else { // non-numeric
	                            cellValue = df.formatCellValue(cell).toString().trim();
	                            //String columnHeader = headerRow.getCell(columnIndex, Row.CREATE_NULL_AS_BLANK).toString().trim();
	                            //ExcelReadLog.ExcelReadLogger.debug("columnHeader else part : "+ columnHeader);
	                            if(headerRowSet.contains(cellValue)) {
	                            	ExcelReadLog.ExcelReadLogger.debug("Duplicate Header value found in sheet data : "+ cellValue);
	                            	return false;
	                            }
	                        }
	                    	                        
	                        // Get the column header from the header row
	                        String columnHeader = headerRow.getCell(columnIndex, Row.CREATE_NULL_AS_BLANK).toString().trim();
	                                                
	                        // Put the column and its corresponding data in the map
	                        if(cellValue.length() > 0) dataFound = true;
	                        dataMap.put(columnHeader, cellValue); // toThink
	                    }
	                    
	                    if((flag == 0 && dataFound) || (flag == 1 && !dataFound)) flag++;
	                    if(flag == 2) break;
	                    
	                    dataList.add(dataMap);
	                }

	                // Printing and checking empty map data
	                for (Map<String, String> dataMap : dataList) {
	                	ExcelReadLog.ExcelReadLogger.debug("Final Data Row:\n" + dataMap.values());
	                	ExcelReadLog.ExcelReadLogger.debug("Yes Map key size: "+dataMap.keySet().size());
	                	mapKeySize = dataMap.keySet().size();
	                	ExcelReadLog.ExcelReadLogger.debug("Yes Map value length: "+dataMap.values().toString().length());
	                	if(dataMap.values().toString().length() == (2*mapKeySize)){
	                		ExcelReadLog.ExcelReadLogger.debug("Yes Map Values are empty");
	                		emptyMapFlag = 1;
	                	}
	                	else{
	                		ExcelReadLog.ExcelReadLogger.debug("Yes Map Values are not empty");
	                		emptyMapFlag = 0;
	                	}	
	                }
	                
			        // INSERT Query for DB Tables
			        if(emptyMapFlag != 1)
			        	insertionFlag = insertDataInDB(cabinetName, sessionId,JtsIp, JtsPort, DBTableName, DBTableHeaders, dataList,workBookName,processInstanceID,parentFolder);
			        else{
			        	attachDocumentToWorkitem(cabinetName,workBookName,JtsIp,JtsPort,processInstanceID,parentFolder);
			        	moveFilesAfterProcessing(workBookName,"DocumentSuccessFolderPath");
			        	sendSuccessEmailToSupport(workBookName,cabinetName,sessionId,JtsIp,JtsPort,processInstanceID);
			        }
			        returnStr = insertionFlag;  
	                
	            }catch (IOException e)
	    		{
	    			ExcelReadLog.ExcelReadLogger.debug("Exception: "+e.getMessage());
	    		}
	            itr++;
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        return returnStr;
    }        
	
	private HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
			String sessionID)
	{
		HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

		try
		{
			ExcelReadLog.ExcelReadLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'iRBL' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			ExcelReadLog.ExcelReadLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			ExcelReadLog.ExcelReadLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			ExcelReadLog.ExcelReadLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			ExcelReadLog.ExcelReadLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				ExcelReadLog.ExcelReadLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				ExcelReadLog.ExcelReadLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				ExcelReadLog.ExcelReadLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			ExcelReadLog.ExcelReadLogger.debug("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		ExcelReadLog.ExcelReadLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientEiborReadExcel.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			ExcelReadLog.ExcelReadLogger.debug("Exception Occured in WF NG Execute : "+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	
	private static boolean validateHeaders(String expectedHeaders[], Row headerRow, Set<String> headerRowSet, String workbookName) {

        if(workbookName.contains("MM Deals")){
        	ExcelReadLog.ExcelReadLogger.debug("Inside if condition of MM");
        	int columnCount = headerRow.getPhysicalNumberOfCells();
            
            // Validate header count
            if(columnCount != expectedHeaders.length) {
            	System.out.println("Header row count mismatch:" + columnCount +" "+ expectedHeaders.length);
            	ExcelReadLog.ExcelReadLogger.debug("Header row count mismatch:" + columnCount +" "+ expectedHeaders.length);
            	return false;
            }

            // Validate header names
            headerRowSet.add("EIBOR_Deposits");
            for (int i = 1; i < columnCount; i++) {
            	
                String expectedHeader = expectedHeaders[i].trim();
                String sheetHeader = df.formatCellValue(headerRow.getCell(i, Row.CREATE_NULL_AS_BLANK)).toString().trim();

                if (!expectedHeader.equals(sheetHeader.toString())) {
                	System.out.println("Headers Mismatch: "+ sheetHeader +" vs "+ expectedHeader);
                	ExcelReadLog.ExcelReadLogger.debug("Headers Mismatch: "+ sheetHeader +" vs "+ expectedHeader);
                	return false;
            	}
                
                if(headerRowSet.contains(sheetHeader)) {
                	System.out.println("Duplicate Headers in Header Column : "+ sheetHeader);
                	ExcelReadLog.ExcelReadLogger.debug("Duplicate Headers in Header Column : "+ sheetHeader);
                	return false;
                }
                headerRowSet.add(sheetHeader);
            }
           
        }else{
        	int columnCount = headerRow.getPhysicalNumberOfCells();
            
            // Validate header count
            if(columnCount != expectedHeaders.length) {
            	System.out.println("Header row count mismatch:" + columnCount +" "+ expectedHeaders.length);
            	ExcelReadLog.ExcelReadLogger.debug("Header row count mismatch:" + columnCount +" "+ expectedHeaders.length);
            	return false;
            }

            // Validate header names
            for (int i = 0; i < columnCount; i++) {
                String expectedHeader = expectedHeaders[i].trim();
                String sheetHeader = df.formatCellValue(headerRow.getCell(i, Row.CREATE_NULL_AS_BLANK)).toString().trim();

                if (!expectedHeader.equals(sheetHeader.toString())) {
                	System.out.println("Headers Mismatch: "+ sheetHeader +" vs "+ expectedHeader);
                	ExcelReadLog.ExcelReadLogger.debug("Headers Mismatch: "+ sheetHeader +" vs "+ expectedHeader);
                	return false;
            	}
                
                if(headerRowSet.contains(sheetHeader)) {
                	System.out.println("Duplicate Headers in Header Column : "+ sheetHeader);
                	ExcelReadLog.ExcelReadLogger.debug("Duplicate Headers in Header Column : "+ sheetHeader);
                	return false;
                }
                headerRowSet.add(sheetHeader);
            }

        }
		
        return true;
    }
    
    private static boolean insertDataInDB(String cabinetName,String sessionId,String JtsIp,String JtsPort,String DBTableName, String DBTableHeaders[], List<Map<String, String>> dataList, String workbookName, String processInstanceID, String parentFolder) {

        StringBuilder columnNames = new StringBuilder(); StringBuilder columnValues;
        boolean insertStatus = false; Date nowDate = null;
        for(String header : DBTableHeaders) {
        	columnNames.append(header +",");
        }
        columnNames.append("Inserted_Date,Received_On,File_Name" +",");
        columnNames.deleteCharAt(columnNames.length()-1);
        ExcelReadLog.ExcelReadLogger.debug("columnNames: "+columnNames);
        
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"); 
		LocalDateTime now = LocalDateTime.now();
		
    	for (int i=0; i<dataList.size(); i++) { // mainData
    		columnValues = new StringBuilder();
    		Map<String, String> dataMap = dataList.get(i);
            //System.out.println("Final Data Row:\n" + dataMap.values());
    		
    		for(String cellValue : dataMap.values()) {
    			columnValues.append("'" + cellValue + "',");
    		}
    		columnValues.append("'" + dtf.format(now) + "',");
    		columnValues.append("'" + dtf.format(now) + "',");
    		columnValues.append("'" + workbookName + "',");
    		columnValues.deleteCharAt(columnValues.length()-1);
    		
    		// INSERT query execution via socket
    		ExcelReadLog.ExcelReadLogger.debug("columnValues: "+columnValues);
    		String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnNames.toString(), columnValues.toString(),DBTableName);
    		ExcelReadLog.ExcelReadLogger.debug("apInsertInputXML: "+apInsertInputXML);
    		String apInsertOutputXML = "";
			try {
				apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, JtsIp, JtsPort, 1);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				catchflag = true;
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				catchflag = true;
				e.printStackTrace();
			}
    		ExcelReadLog.ExcelReadLogger.debug("apInsertOutputXML: "+apInsertOutputXML);
    		XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
    		String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
    		if (apInsertMaincode.equalsIgnoreCase("0")) 
    		{
    			//print logger for successfully inserting data in vendor data dtls
    			ExcelReadLog.ExcelReadLogger.debug("Data inserted in "+ DBTableName +" for row"+i);
    			catchflag = false;
    			insertStatus = true;
    		}else{
    			ExcelReadLog.ExcelReadLogger.debug("Data inserted failed. Maincode: "+ apInsertMaincode);
    			catchflag = true;
    			insertStatus = false;
    			break;
    		}
        }
    	if(catchflag == true){
    		ExcelReadLog.ExcelReadLogger.debug("In case catch flag is true");
    		moveFilesAfterProcessing(workbookName,"DocumentErrorFolderPath");
    		sendFailureEmailToSupport(workbookName,cabinetName,sessionId,JtsIp,JtsPort,processInstanceID);
    	}else{
    		ExcelReadLog.ExcelReadLogger.debug("In case catch flag is false and success insert");
    		attachDocumentToWorkitem(cabinetName,workbookName,JtsIp,JtsPort,processInstanceID,parentFolder);
    		moveFilesAfterProcessing(workbookName,"DocumentSuccessFolderPath");
    		sendSuccessEmailToSupport(workbookName,cabinetName,sessionId,JtsIp,JtsPort,processInstanceID);
    	}
    	return insertStatus;
    }
    
    public static void attachDocumentToWorkitem(String cabinetName,String workbookName,String jtsIP,String JtsPort,String workItemName
    		,String parentFolderIndex) {
    	//boolean moveStatus = true;
    	String DocumentType = "N";
    	JPISIsIndex ISINDEX = new JPISIsIndex();
		JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
		String docPath = ExcelValidationAndRead.EiborReadExcelConfigParamMap.get("DocumentFolderPath")+workbookName;
		String DocNameAsProcess = "";
		if(workbookName.contains("DF2")){
			DocNameAsProcess = "EIBOR DF2 BACKDATED";
		}else if(workbookName.contains("MM")){
			DocNameAsProcess = "EIBOR FAS MM Deals";
		}else if(workbookName.contains("Finacle")){
			DocNameAsProcess = "EIBOR FINACLE";
		}else if(workbookName.contains("Flexcube")){
			DocNameAsProcess = "EIBOR FLEXCUBE";
		}
		File fileName = new File(docPath);
		JPISIsIndex ISINDEXI = new JPISIsIndex();
		JPDBRecoverDocData JPISDECI = new JPDBRecoverDocData();
		long lLngFileSize = fileName.length();
		String lstrDocFileSize = Long.toString(lLngFileSize);
		String strExtension = workbookName.substring(workbookName.lastIndexOf(".")+1,workbookName.length());
		try
		{
			ExcelReadLog.ExcelReadLogger.debug("workItemName: "+workItemName+" before CPISDocumentTxn AddDocument MT: ");

			if(smsPort.startsWith("33"))
			{
				CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
			}
			else
			{
				CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
			}
			
			ExcelReadLog.ExcelReadLogger.debug("workItemName: "+workItemName+" after CPISDocumentTxn AddDocument MT: ");

			String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
			ExcelReadLog.ExcelReadLogger.debug("workItemName: "+workItemName+" sISIndex: "+sISIndex);
			String sMappedInputXml = CommonMethods.getNGOAddDocument(parentFolderIndex,DocNameAsProcess,DocumentType,strExtension,sISIndex,lstrDocFileSize,volumeID,cabinetName,sessionID);
			ExcelReadLog.ExcelReadLogger.debug("workItemName: "+workItemName+" sMappedInputXml "+sMappedInputXml);
			ExcelReadLog.ExcelReadLogger.debug("Input xml For NGOAddDocument Call: "+sMappedInputXml);

			String sOutputXml=WFNGExecute(sMappedInputXml,jtsIP,JtsPort,1);
			sOutputXml=sOutputXml.replace("<Document>","");
			sOutputXml=sOutputXml.replace("</Document>","");
			ExcelReadLog.ExcelReadLogger.debug("workItemName: "+workItemName+" Output xml For NGOAddDocument Call: "+sOutputXml);
			ExcelReadLog.ExcelReadLogger.debug("Output xml For NGOAddDocument Call: "+sOutputXml);
			String statusXML = CommonMethods.getTagValues(sOutputXml,"Status");
			String ErrorMsg = CommonMethods.getTagValues(sOutputXml,"Error");
		}
		catch (NumberFormatException e)
		{
			ExcelReadLog.ExcelReadLogger.debug("workItemName1:"+e.getMessage());
			e.printStackTrace();
			catchflag=true;
		}
		catch (JPISException e)
		{
			ExcelReadLog.ExcelReadLogger.debug("workItemName2:"+e.getMessage());
			e.printStackTrace();
			catchflag=true;
		}
		catch (Exception e)
		{
			ExcelReadLog.ExcelReadLogger.debug("workItemName3:"+e.getMessage());
			e.printStackTrace();
			catchflag=true;
		}
    }
    
    public static void moveFilesAfterProcessing(String workbookName, String path) {
    	//boolean moveStatus = true;
    	Date nowDate = new Date();
		Format formatter = new SimpleDateFormat("dd-MMM-yy");
		sdate = formatter.format(nowDate);
		String sourceFilePath = ExcelValidationAndRead.EiborReadExcelConfigParamMap.get("DocumentFolderPath")+workbookName;
		String destFilePath = ExcelValidationAndRead.EiborReadExcelConfigParamMap.get(path)+sdate;
		TimeStamp=get_timestamp();
		newFilename = Move(destFilePath,sourceFilePath,TimeStamp);
		ExcelReadLog.ExcelReadLogger.debug("moveFilesAfterProcessing,newFilename: "+newFilename);
		//return moveStatus;
    }
    
    public static String Move(String destFolderPath, String srcFolderPath,String append)
	{
		try
		{
			File objDestFolder = new File(destFolderPath);
			if (!objDestFolder.exists())
			{
				objDestFolder.mkdirs();
			}
			File objsrcFolderPath = new File(srcFolderPath);
			newFilename = objsrcFolderPath.getName();
			File lobjFileTemp = new File(destFolderPath + File.separator + newFilename);
			if (lobjFileTemp.exists())
			{
				if (!lobjFileTemp.isDirectory())
				{
					lobjFileTemp.delete();
				}
				else
				{
					deleteDir(lobjFileTemp);
				}
			}
			else
			{
				lobjFileTemp = null;
			}
			File lobjNewFolder = new File(objDestFolder, newFilename +"_"+ append);

			boolean lbSTPuccess = false;
			try
			{
				lbSTPuccess = objsrcFolderPath.renameTo(lobjNewFolder);
			}
			catch (SecurityException lobjExp)
			{
				System.out.println("SecurityException");
			}
			catch (NullPointerException lobjNPExp)
			{
				System.out.println("NullPointerException");
			}
			catch (Exception lobjExp)
			{
				System.out.println("Exception");
			}
			if (!lbSTPuccess)
			{
				System.out.println("lbSTPuccess");
			}
			else
			{
				System.out.println("else");
			}
			objDestFolder = null;
			objsrcFolderPath = null;
			lobjNewFolder = null;
		}
		catch (Exception lobjExp)
		{
		}

		return newFilename;
	}
    
    public static boolean deleteDir(File dir) throws Exception {
		if (dir.isDirectory()) {
			String[] lstrChildren = dir.list();
			for (int i = 0; i < lstrChildren.length; i++) {
				boolean success = deleteDir(new File(dir, lstrChildren[i]));
				if (!success) {
					return false;
				}
			}
		}
		return dir.delete();
	}
    
    public static String get_timestamp()
	{
		Date present = new Date();
		Format pformatter = new SimpleDateFormat("dd-MM-yyyy-hhmmss");
		TimeStamp=pformatter.format(present);
		return TimeStamp;
	}
    
    public static void sendSuccessEmailToSupport(String workbookName,String cabinetName,String sessionId,String JtsIp,String JtsPort,String WIName)
   	{
    	String MailEnd_str = "</body></html>";
    	String strMailSubject = workbookName+" file processed successfully by utility";
    	String MailHeader_str = "<html><body>Dear BPMSupport Team,<br><br>For "+WIName+", all data of "+workbookName+" file has been read and inserted in database successfully.";
    	String MailStr = MailHeader_str+MailEnd_str;
    	ExcelReadLog.ExcelReadLogger.debug("sendSuccessEmailToSupport, MailStr---"+MailStr);
    	String columnName = "mailFrom,mailTo,mailCC,mailSubject,mailMessage,mailContentType,attachmentISINDEX,attachmentNames,attachmentExts,mailPriority,mailStatus,statusComments,lockedBy,successTime,LastLockTime,insertedBy,mailActionType,insertedTime,processDefId,processInstanceId,workitemId,activityId,noOfTrials,zipFlag,zipName,maxZipSize,alternateMessage,mailBCC";
    	String strValues = "'"+fromMailID+"','"+toMailID+"',NULL,'"+strMailSubject+"','"+MailStr+"','text/html;charset=UTF-8',NULL,NULL,NULL,1,'N',NULL,NULL,NULL,NULL,NULL,'TRIGGER',getdate(),NULL,'"+WIName+"',1,NULL,0,'N',NULL,'0','',NULL";
		String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnName, strValues,"WFMAILQUEUETABLE");
		ExcelReadLog.ExcelReadLogger.debug("sendSuccessEmailToSupport, apInsertInputXML: "+apInsertInputXML);
		String apInsertOutputXML = "";
		try {
			apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, JtsIp, JtsPort, 1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			catchflag = true;
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			catchflag = true;
			e.printStackTrace();
		}
		ExcelReadLog.ExcelReadLogger.debug("sendSuccessEmailToSupport, apInsertOutputXML: "+apInsertOutputXML);
   	}
    public static void sendFailureEmailToSupport(String workbookName,String cabinetName,String sessionId,String JtsIp,String JtsPort,String WIName)
   	{
    	String MailEnd_str = "</body></html>";
    	String strMailSubject = workbookName+" file does not processed successfully by utility";
    	String MailHeader_str = "<html><body>Dear BPMSupport Team,<br><br>For "+WIName+", some issue occured while reading and inserting the data of "+workbookName+" file.";
		String MailStr = MailHeader_str+MailEnd_str;
		ExcelReadLog.ExcelReadLogger.debug("sendFailureEmailToSupport, MailStr---"+MailStr);
		String columnName = "mailFrom,mailTo,mailCC,mailSubject,mailMessage,mailContentType,attachmentISINDEX,attachmentNames,attachmentExts,mailPriority,mailStatus,statusComments,lockedBy,successTime,LastLockTime,insertedBy,mailActionType,insertedTime,processDefId,processInstanceId,workitemId,activityId,noOfTrials,zipFlag,zipName,maxZipSize,alternateMessage,mailBCC";
		String strValues = "'"+fromMailID+"','"+toMailID+"',NULL,'"+strMailSubject+"','"+MailStr+"','text/html;charset=UTF-8',NULL,NULL,NULL,1,'N',NULL,NULL,NULL,NULL,NULL,'TRIGGER',getdate(),NULL,'"+WIName+"',1,NULL,0,'N',NULL,'0','',NULL";
		String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnName, strValues,"WFMAILQUEUETABLE");
		ExcelReadLog.ExcelReadLogger.debug("sendFailureEmailToSupport, apInsertInputXML: "+apInsertInputXML);
		String apInsertOutputXML = "";
		try {
			apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, JtsIp, JtsPort, 1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			catchflag = true;
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			catchflag = true;
			e.printStackTrace();
		}
		ExcelReadLog.ExcelReadLogger.debug("sendFailureEmailToSupport, apInsertOutputXML: "+apInsertOutputXML);
   	}

}
