package com.newgen.KYC.KYCreadExcel;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.net.Socket;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.newgen.KYC.KYCodDownload.KYCodDownloadLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.excp.NGException;

public class KYCreadExcel implements Runnable{
	
	private static String sessionID = "";
	private static String cabinetName = "";
	private static String jtsIP = "";
	private static String jtsPort = "";
	private static String queueID = "";
	private static String processDefID = "";
	private static int sleepIntervalInMin=0;
	private static String headers = "";
	private static String columnNames = "";
	private static String table = "";
	private static String errorRowNo = "";
	//private static String coumn_external = "";
	static HashMap<String,String>  headerColumnMap= new HashMap<>();
	//static HashMap<String,String>  dbExtColumnMap= new HashMap<>();
	
	
	private static NGEjbClient ngEjbClientODDoc;

	static Map<String, String> ODDocConfigParamMap= new HashMap<String, String>();
	
	@Override
	public void run()
	{
		try
		{
			KYCreadExcelLog.setLogger();
			ngEjbClientODDoc = NGEjbClient.getSharedInstance();

			KYCreadExcelLog.KYCreadExcelLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			KYCreadExcelLog.KYCreadExcelLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				KYCreadExcelLog.KYCreadExcelLogger.error("Could not Read Config Properties [ODDDStatus]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			KYCreadExcelLog.KYCreadExcelLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			KYCreadExcelLog.KYCreadExcelLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			KYCreadExcelLog.KYCreadExcelLogger.debug("JTSPORT: " + jtsPort);			

			queueID = ODDocConfigParamMap.get("QueueID");
			KYCreadExcelLog.KYCreadExcelLogger.debug("QueueID: " + queueID);

			sleepIntervalInMin=Integer.parseInt(ODDocConfigParamMap.get("SleepIntervalInMin"));
			KYCreadExcelLog.KYCreadExcelLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);
			
			table=ODDocConfigParamMap.get("table");
			KYCreadExcelLog.KYCreadExcelLogger.debug("table: "+table);
			
			processDefID =ODDocConfigParamMap.get("processDefID");
			KYCreadExcelLog.KYCreadExcelLogger.debug("processDefID: "+processDefID);
			
 			sessionID = CommonConnection.getSessionID(KYCreadExcelLog.KYCreadExcelLogger, false);

 			if(sessionID.trim().equalsIgnoreCase(""))
			{
				KYCreadExcelLog.KYCreadExcelLogger.debug("Could Not Connect to Server!");
			}
			else
			{
 				KYCreadExcelLog.KYCreadExcelLogger.debug("Session ID found: " + sessionID);
				//HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,sessionID);
				while(true)
				{
					sessionID = CommonConnection.getSessionID(KYCreadExcelLog.KYCreadExcelLogger, false);
 					KYCreadExcelLog.setLogger();
 					KYCreadExcelLog.KYCreadExcelLogger.debug("ODDD Utility...123");
 					startUtilityKYCreadExcel(cabinetName, sessionID,jtsIP, jtsPort);
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			KYCreadExcelLog.KYCreadExcelLogger.error("Exception Occurred in ODDD : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			KYCreadExcelLog.KYCreadExcelLogger.error("Exception Occurred in ODDD : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try 
		{

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "KYC_ReadExcelFile_Config.properties")));

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

	private static void startUtilityKYCreadExcel(String cabinetName, String sessionId, String JtsIp,String JtsPort) 
	{
 		KYCreadExcelLog.KYCreadExcelLogger.info("Inside startUtilityKYCreadExcel..");
		//ArrayList<String> wiList = new ArrayList<String>();
		/*boolean fileMoved;
		boolean readExcelFileStatus;
		File tmpDir = new File(ExcelPath+"\\"+excelFileName);
 		if(tmpDir.length() == 0)
		{
			boolean exists = tmpDir.exists();
			if(exists){
				fileMoved = moveFile(ExcelPath+"\\"+excelFileName,error+"\\"+excelFileName);
				KYCreadExcelLog.KYCreadExcelLogger.info("File moved to error folder as it is blank..");
			}
			//fileMoved = moveFile(ExcelPath+"\\"+excelFileName,error+"\\"+excelFileName);
			KYCreadExcelLog.KYCreadExcelLogger.info("File not available at location..");
			System.out.println("file not available at location");
		}
		
		else if(!(tmpDir.length() == 0))
		{
			fileMoved = moveFile(ExcelPath+"\\"+excelFileName,inProgress+"\\"+excelFileName);
			KYCreadExcelLog.KYCreadExcelLogger.info("Before Calling Read Excel file");
			if(fileMoved)
			{
			KYCreadExcelLog.KYCreadExcelLogger.info("Before Calling Read excel file");
			readExcelFileStatus=readExcelFile(inProgress+"\\"+excelFileName);
			KYCreadExcelLog.KYCreadExcelLogger.info("After Calling Read excel file with readExcelFileStatus  --"+readExcelFileStatus);
			if(readExcelFileStatus){
			String response = insertInDB(inProgress+"\\"+excelFileName,cabinetName,sessionId,"Sheet1",table);
			if(response == "true"){
				if(errorCount==0){
					moveFile(inProgress+"\\"+excelFileName,success+"\\"+excelFileName);
				}
				else{
					moveFile(inProgress+"\\"+excelFileName,error+"\\"+excelFileName);
					KYCreadExcelLog.KYCreadExcelLogger.info("Error in inserting "+ errorCount +"row(s), so moved to error folder");
					sendEmail(errorRowNo,cabinetName,sessionID,jtsIP,jtsPort);
				}*/
				createIndividualWI(cabinetName,sessionID,jtsIP,jtsPort);
				createCorporateWI(cabinetName,sessionID,jtsIP,jtsPort);
				//createIndividualCorporateWI(cabinetName,sessionID,jtsIP,jtsPort);
			/*}
			}
			else
			{
				KYCreadExcelLog.KYCreadExcelLogger.info("error in readExcelFile Method");
				moveFile(inProgress+"\\"+excelFileName,error+"\\"+excelFileName);
			}
			}
			else if (!fileMoved)
			{
				KYCreadExcelLog.KYCreadExcelLogger.info("Error in moving file in Progress folder");
			}
		}*/
	}
	
	public static boolean moveFile(String sourcePath,String targetPath)
	{
		boolean fileMoved = true;
		try{
			Files.move(Paths.get(sourcePath), Paths.get(targetPath), StandardCopyOption.REPLACE_EXISTING);
		}
		catch(Exception e){
			KYCreadExcelLog.KYCreadExcelLogger.info("exception in moving file"+e.getMessage());
			fileMoved = false;
		}
		return fileMoved;
	}
	public static boolean readExcelFile(String file)
	{
		
		KYCreadExcelLog.KYCreadExcelLogger.info("Inside readExcelFile Method..");
		String ErrDesc = "";
		Boolean is_excelvalid = false;
		int res=ValidateExcelHeader(file.toString(), CommonConnection.getCabinetName(), CommonConnection.getSessionID(KYCreadExcelLog.KYCreadExcelLogger, false), "Sheet1");
		if(res==0)
		{
			is_excelvalid=true;
		}
		else if(res==1)
		{
			is_excelvalid=false;
			ErrDesc = "Excel is invalid. Please Correct the Header Column Name.";
			KYCreadExcelLog.KYCreadExcelLogger.debug("is_excelvalid: "+is_excelvalid);
		}
		else
		{
			is_excelvalid=false;
			ErrDesc = "Excel is invalid. Please Correct the Sheet Name.";
			KYCreadExcelLog.KYCreadExcelLogger.debug("is_excelvalid: "+is_excelvalid);
		}	
		return is_excelvalid;
	}
	
	public static int ValidateExcelHeader(String fileName,String cabinetName,String sessionId,String tag) {
		
		FileInputStream fis = null;
		try
		{
		String[] header_column = headers.split(",");
		for(int i=0;i<header_column.length;i++)
		{
			String[] value = header_column[i].split("@");
			headerColumnMap.put(value[0], value[1]);
		}
		
			KYCreadExcelLog.KYCreadExcelLogger.debug(tag+" excel tag : "+ tag);	
			DataFormatter formatter = new DataFormatter();
			fis = new FileInputStream(new File(fileName));
			if(FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("xls"))
			{
				HSSFWorkbook workBook = new HSSFWorkbook(fis);
				HSSFSheet sheet = workBook.getSheet(tag);
				int cellCount = sheet.getRow(0).getPhysicalNumberOfCells();
				System.out.println(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				KYCreadExcelLog.KYCreadExcelLogger.debug(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				if(workBook.getSheetIndex(sheet)==-1)
				{
				return 2;
				}
				int count = 0;
				for(int i=0;i<cellCount;i++)
				{
					
					Object value = formatter.formatCellValue(sheet.getRow(0).getCell(i));
					String cellValue = (String) value;
					boolean res = headerColumnMap.containsKey(cellValue);
					if(!res)
					{
						KYCreadExcelLog.KYCreadExcelLogger.debug("incorrect data in sheet");
						return 1;
					}
//					if(!(cellValue==header[i]))
//					{
//						count++;
//						KYCreadExcelLog.KYCreadExcelLogger.debug("Invalid header - '"+cellValue+"'.....Header should be - '"+header[i]+"'");
//						return 1;
//					}
				}
				KYCreadExcelLog.KYCreadExcelLogger.debug("valid header in excel");
				return 0;
			}
			else if (FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("XLSX"))
			{
				System.out.println("fileName--->"+fileName);
				XSSFWorkbook workBook = new XSSFWorkbook(fis);
				XSSFSheet sheet = workBook.getSheet(tag);
				int cellCount = sheet.getRow(0).getPhysicalNumberOfCells();
				System.out.println(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				KYCreadExcelLog.KYCreadExcelLogger.debug(tag+" Sheet index : "+ workBook.getSheetIndex(sheet));
				if(workBook.getSheetIndex(sheet)==-1)
				{
					return 2;
				}
				int count = 0;;
				for(int i=0;i<cellCount;i++)
				{
					Object value = formatter.formatCellValue(sheet.getRow(0).getCell(i));
					String cellValue = (String) value;
					boolean res = headerColumnMap.containsKey(cellValue);
					
					if(!res)
					{
						KYCreadExcelLog.KYCreadExcelLogger.debug("incorrect data in sheet");
						return 1;
					}
//					if(!(cellValue==header[i]))
//					{
//						count++;
//						KYCreadExcelLog.KYCreadExcelLogger.debug("Invalid header - '"+cellValue+"'.....Header should be - '"+header[i]+"'");
//						return 1;
//					}
				}
			}
			return 0;
		}
		catch(IOException e)
		{
			KYCreadExcelLog.KYCreadExcelLogger.debug("exception in excel method "+e);
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

	
	/*public static String insertInDB(String fileName,String cabinetName,String sessionId,String tag,String table){
		FileInputStream fis = null;
		try{
		KYCreadExcelLog.KYCreadExcelLogger.debug(tag+" excel tag : "+ tag);	
		DataFormatter formatter = new DataFormatter();
		fis = new FileInputStream(new File(fileName));
		if(FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("xls"))
		{
			HSSFWorkbook workBook = new HSSFWorkbook(fis);
			HSSFSheet sheet = workBook.getSheet(tag);
			int rowCount = sheet.getPhysicalNumberOfRows();
			int cellCount = sheet.getRow(0).getPhysicalNumberOfCells();
			String columnValues = "";
			String WI_Status = "R";
			String[] cellValues = new String[cellCount];
			for(int i=1;i<rowCount;i++){
				for(int k=0;k<cellCount;k++){
					Object value = formatter.formatCellValue(sheet.getRow(i).getCell(k));
					cellValues[k] = (String) value; 
					if(k==0){
						columnValues="'"+cellValues[k] +"'";
					}
					else{
						columnValues = columnValues+",'"+cellValues[k]+"'";
					}
				}
				columnValues = columnValues+",getDate(),'"+WI_Status+"'";
				String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_KYC_ExcelDetails");
				KYCreadExcelLog.KYCreadExcelLogger.debug("apInsertInputXML: "+apInsertInputXML);
				String apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
				KYCreadExcelLog.KYCreadExcelLogger.debug("apInsertOutputXML: "+apInsertOutputXML);
				XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
				String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
				if (apInsertMaincode.equalsIgnoreCase("0")) 
				{
					KYCreadExcelLog.KYCreadExcelLogger.debug("Row NO "+i+" is inserted successfully");
					//WRITE IN EXCEL
					//INSERT A FLAG IN EACH ROW TO IDENTIFY ROW IS PROCESSED OR NOT
					Row row = sheet.getRow(i);
					Cell flagCell = row.createCell(row.getLastCellNum());
					flagCell.setCellValue("Y");
					try(FileOutputStream fos = new FileOutputStream(fileName)){
						workBook.write(fos);
					}
				}
				else{
					errorCount++;
					errorRowNo = errorRowNo+i+",";
					KYCreadExcelLog.KYCreadExcelLogger.debug("Error in inserting row no "+i);
					Row row = sheet.getRow(i);
					Cell flagCell = row.createCell(row.getLastCellNum());
					flagCell.setCellValue("N");
					try(FileOutputStream fos = new FileOutputStream(fileName)){
						workBook.write(fos);	
				}
			  }
			}
			return "true";
		}
		else if(FilenameUtils.getExtension(fileName).trim().equalsIgnoreCase("XLSX")){
			XSSFWorkbook workBook = new XSSFWorkbook(fis);
			XSSFSheet sheet = workBook.getSheet(tag);
			int rowCount = sheet.getPhysicalNumberOfRows();
			int cellCount = sheet.getRow(0).getPhysicalNumberOfCells();
			String WI_Status = "R";
			String columnValues = "";
			
			String[] cellValues = new String[cellCount];
			for(int i=1;i<rowCount;i++){
				for(int k=0;k<cellCount;k++){
					Object value = formatter.formatCellValue(sheet.getRow(i).getCell(k));
					cellValues[k] = (String) value; 
					if(k==0){
						columnValues="'"+cellValues[k] +"'";
					}
					else{
						columnValues = columnValues+",'"+cellValues[k]+"'";
					}
				}
				columnValues = columnValues+",getDate(),'"+WI_Status+"'";
				String apInsertInputXML = CommonMethods.apInsert(cabinetName, sessionId, columnNames, columnValues,"USR_0_KYC_ExcelDetails");
				KYCreadExcelLog.KYCreadExcelLogger.debug("apInsertInputXML: "+apInsertInputXML);
				String apInsertOutputXML = CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
				KYCreadExcelLog.KYCreadExcelLogger.debug("apInsertOutputXML: "+apInsertOutputXML);
				XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
				String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
				if (apInsertMaincode.equalsIgnoreCase("0")) 
				{
					KYCreadExcelLog.KYCreadExcelLogger.debug("Row NO "+i+" is inserted successfully");
					//WRITE IN EXCEL
					//INSERT A FLAG IN EACH ROW TO IDENTIFY ROW IS PROCESSED OR NOT
					Row row = sheet.getRow(i);
					Cell flagCell = row.createCell(row.getLastCellNum());
					flagCell.setCellValue("Y");
					try(FileOutputStream fos = new FileOutputStream(fileName)){
						workBook.write(fos);
					}
				}
				else{
					errorCount++;
					errorRowNo = errorRowNo+i+",";
					KYCreadExcelLog.KYCreadExcelLogger.debug("Error in inserting row no "+i);
					Row row = sheet.getRow(i);
					Cell flagCell = row.createCell(row.getLastCellNum());
					flagCell.setCellValue("N");
					try(FileOutputStream fos = new FileOutputStream(fileName)){
						workBook.write(fos);
					}
				}
			}
			return "true";
		}
		}catch(Exception e){
			KYCreadExcelLog.KYCreadExcelLogger.debug("exception in InsertIn DB Method");
			KYCreadExcelLog.KYCreadExcelLogger.debug("ERROR IN INSERTING DATA IN DB IN VENDOR TABLE"+e);
			return "false";
		}
		
		return "";
	}*/
	
	private static String sendEmail(String rowNo,String cabinetName, String sessionID,String jtsIP,String jtsPort)
	{
		try{
		
		int mailPriority= 1;
		String mailStatus = "N";
		String UserNAme = "rakbpm";
		String mailActionType = "TRIGGER";
		String mailContentType = "text/html;charset=UTF-8";
		//String wiName = processInstanceID;
		int workitemid = 1;
		int activityID = 3;
		int noOfTrials = 0;
		String mailFrom = "test11@rakbanktst.ae";
		String mailTo = "test5@rakbanktst.ae";
		String mailSubject = "Excel error";
		String emailBody = "There is an error in inserting the following rows - "+rowNo;
		String tableName = "WFMAILQUEUETABLE";
		String columnName = "mailFrom,mailTo,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,insertedBy,"
				+ "mailActionType,workitemId,activityId,noOfTrials";
		String values = "'"+mailFrom+"','"+mailTo+"','"+mailSubject+"',N'"+emailBody+"','"+mailContentType+"','"+mailPriority+"','"+mailStatus+"','"+UserNAme+"','"+mailActionType+"','"+workitemid+"','"+activityID+"','"+noOfTrials+"'";
		//String mailInsertQuery = "Insert into " +tableName+" "+columnName+" values "+values;
		
		String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName, values,tableName);
		KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertInputXML: "+apInsertInputXML);

		String apInsertOutputXML =CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
		KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

		XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
		String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
		KYCreadExcelLog.KYCreadExcelLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
		if(apInsertMaincode.equalsIgnoreCase("0"))
		{
			KYCreadExcelLog.KYCreadExcelLogger.debug("ApInsert successful: "+apInsertMaincode);
			KYCreadExcelLog.KYCreadExcelLogger.debug("Mail sent successfully.");
			return "true";
		}
		}catch(Exception e){
			KYCreadExcelLog.KYCreadExcelLogger.debug("Exception in sending mail----"+e);
		}
		return "false";
	}
	
	public static String createIndividualWI(String cabinetName, String sessionID, String jtsIP, String jtsPort) {
		try {
			String CUSTOMER_SUBSEGMENT_CODE = "";
			String coumn_external =ODDocConfigParamMap.get("IndividualDBcolumn&extColumn");
			//KYCreadExcelLog.KYCreadExcelLogger.debug("coumn_external: "+coumn_external);
			
			String query = "select * from NG_KYC_REM_BO_IBPS_TABLE with (nolock) Where (COPR_CIF is null or COPR_CIF = '')"
					+ " and (cif_id is not null or cif_id != '') and (Status = 'R' or Status is null or Status = '')";

//			String[] DBcolumn = columnNames.split(",");
			HashMap<String,String>  dbExtColumnMap= new HashMap<>();
			List<Map<String, String>> DataFromDB = new ArrayList<Map<String, String>>();
			DataFromDB = getDataFromDBMap(query,cabinetName,sessionID,jtsIP, jtsPort);
			String[] DbExtColumn = coumn_external.split(",");
			for(int i=0;i<DbExtColumn.length;i++)
			{
				String[] value = DbExtColumn[i].split("@");
				dbExtColumnMap.put(value[0],value[1]);
			}
			Set<String> keys = dbExtColumnMap.keySet();
			for(Map<String,String> entry : DataFromDB){
				String attributesTag = "";
				for(String key : keys){
					String keyValue = entry.get(key);
					System.out.println(keyValue);
					String ExtColToKey = dbExtColumnMap.get(key);
					attributesTag = attributesTag+"<"+ExtColToKey+">"+replaceXChars(keyValue)+"</"+ExtColToKey+">";
					if("CUSTOMER_SUBSEGMENT_CODE".equalsIgnoreCase(key)){
						CUSTOMER_SUBSEGMENT_CODE = keyValue;
					}
				}
				attributesTag = attributesTag+"<CaseType>Individual</CaseType><CusType>Individual</CusType>";
				if("SME".equalsIgnoreCase(CUSTOMER_SUBSEGMENT_CODE) || "PSL".equalsIgnoreCase(CUSTOMER_SUBSEGMENT_CODE)){
					attributesTag = attributesTag+"<qSubSegment>BBG</qSubSegment>";
				}
				else if("CBD".equalsIgnoreCase(CUSTOMER_SUBSEGMENT_CODE)){
					attributesTag = attributesTag+"<qSubSegment>WBG</qSubSegment>";
				}
				else{
					attributesTag = attributesTag+"<qSubSegment>PBG</qSubSegment>";
				}
				String WFuploadInputXML=getWFUploadWorkItemXML(cabinetName,sessionID,processDefID,attributesTag,queueID);
				//WFuploadInputXML = replaceXChars(WFuploadInputXML);
				KYCreadExcelLog.KYCreadExcelLogger.debug("WFuploadInputXML: "+WFuploadInputXML);
				
				String WFuploadOutputXML =CommonMethods.WFNGExecute(WFuploadInputXML, jtsIP, jtsPort, 1);
				KYCreadExcelLog.KYCreadExcelLogger.debug("WFuploadOutputXML: "+ WFuploadOutputXML);

				XMLParser xmlParserWFupload = new XMLParser(WFuploadOutputXML);
				String Maincode = xmlParserWFupload.getValueOf("MainCode");
				KYCreadExcelLog.KYCreadExcelLogger.debug("Status of Maincode  "+ Maincode);
				String ProcessInstanceId="";
				ProcessInstanceId=xmlParserWFupload.getValueOf("ProcessInstanceId");
				String UserName=xmlParserWFupload.getValueOf("UserName");
				String MsgFormat=xmlParserWFupload.getValueOf("Option");
				String CreationDateTime=xmlParserWFupload.getValueOf("CreationDateTime");
				insertReqRespINDatabase(WFuploadInputXML,WFuploadOutputXML,MsgFormat,ProcessInstanceId,UserName,CreationDateTime);
				if(Maincode.equalsIgnoreCase("0"))
				{
					KYCreadExcelLog.KYCreadExcelLogger.debug("WFupload successful: "+Maincode);
					KYCreadExcelLog.KYCreadExcelLogger.debug("WI Created successfully.");
					
					//going to update status to completed in DB excel table
					String sNO = entry.get("insertionOrderID");
					String columnToUpdate = "Wi_Name,Status";
					String whereClause = "insertionOrderID = "+sNO;
					String values = "'"+ProcessInstanceId+"','C'";
					
					String apUpdateInput=CommonMethods.apUpdateInput(cabinetName,sessionID,table,columnToUpdate,values,whereClause);
					KYCreadExcelLog.KYCreadExcelLogger.debug("apUpdateInput: "+apUpdateInput);

					String apUpdateOutputXML =CommonMethods.WFNGExecute(apUpdateInput, jtsIP, jtsPort, 1);
					KYCreadExcelLog.KYCreadExcelLogger.debug("apUpdateOutputXML: "+ apUpdateOutputXML);

					XMLParser xmlParserapUpdate = new XMLParser(apUpdateOutputXML);
					String MaincodeAPudate = xmlParserapUpdate.getValueOf("MainCode");
					if(MaincodeAPudate.equalsIgnoreCase("0"))
					{
						KYCreadExcelLog.KYCreadExcelLogger.debug("AP Update successful for row no "+sNO);
						Date d = new Date();
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String strDate = dateFormat.format(d);
						
						String tableName = "NG_KYC_REM_GR_HISTORY";
						String columnName = "DateTime,Workstep,Decision,UserName,Remarks,WI_Name,Entry_Date_Time";
						String columnValues = "'"+strDate+"','Introduction','Success','rakBPMutility','Workitem created successfully','"+ProcessInstanceId+"','"+CreationDateTime+"'";
						
						String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName,columnValues,tableName);
						KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertInputXML: "+apInsertInputXML);

						String apInsertOutputXML =CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
						KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

						XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
						String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
						KYCreadExcelLog.KYCreadExcelLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
						if(apInsertMaincode.equalsIgnoreCase("0"))
						{
							KYCreadExcelLog.KYCreadExcelLogger.debug("ApInsert successful: "+apInsertMaincode);
							KYCreadExcelLog.KYCreadExcelLogger.debug("Data Inserted in history table successfully.");
						}
					}	
				}
			}
			dbExtColumnMap.clear();
			DataFromDB.clear();
			return "true";
		} catch (Exception e) {
			KYCreadExcelLog.KYCreadExcelLogger.debug("exception: " + e);
			return "false";
		}
	}
	public static String createCorporateWI(String cabinetName, String sessionID, String jtsIP, String jtsPort) {
		try {
			
			String column_external =ODDocConfigParamMap.get("CorporateDBcolumn&extColumn");
			//KYCreadExcelLog.KYCreadExcelLogger.debug("coumn_external: "+coumn_external);
			
			HashMap<String,String>  CordbExtColumnMap= new HashMap<>();
			
			String query = "select * from NG_KYC_REM_BO_IBPS_TABLE with (nolock) Where (cif_id is null or cif_id = '')"
					+ " and (COPR_CIF is not null or COPR_CIF != '') and (Status = 'R' or Status is null or Status = '')";

//			String[] DBcolumn = columnNames.split(",");
			String COPR_CIF = "";
			String CUSTOMER_SUBSEGMENT_CODE = "";
			List<Map<String, String>> CorDataFromDB = new ArrayList<Map<String, String>>();
			CorDataFromDB = getDataFromDBMap(query,cabinetName,sessionID,jtsIP, jtsPort);
			String[] CorDbExtColumn = column_external.split(",");
			for(int i=0;i<CorDbExtColumn.length;i++)
			{
				String[] value = CorDbExtColumn[i].split("@");
				CordbExtColumnMap.put(value[0],value[1]);
			}
			Set<String> keys = CordbExtColumnMap.keySet();
			for(Map<String,String> entry : CorDataFromDB){
				String attributesTag = "";
				for(String key : keys){
					String keyValue = entry.get(key);
					System.out.println(keyValue);
					String ExtColToKey = CordbExtColumnMap.get(key);
					attributesTag = attributesTag+"<"+ExtColToKey+">"+replaceXChars(keyValue)+"</"+ExtColToKey+">";
					if("COPR_CIF".equalsIgnoreCase(key)){
						COPR_CIF = keyValue;
					}
					if("CUSTOMER_SUBSEGMENT_CODE".equalsIgnoreCase(key)){
						CUSTOMER_SUBSEGMENT_CODE = keyValue;
					}
				}
				attributesTag = attributesTag+"<CaseType>Corporate</CaseType>";
				if("SME".equalsIgnoreCase(CUSTOMER_SUBSEGMENT_CODE) || "PSL".equalsIgnoreCase(CUSTOMER_SUBSEGMENT_CODE)){
					attributesTag = attributesTag+"<qSubSegment>BBG</qSubSegment>";
				}
				else if("CBD".equalsIgnoreCase(CUSTOMER_SUBSEGMENT_CODE)){
					attributesTag = attributesTag+"<qSubSegment>WBG</qSubSegment>";
				}
				else{
					attributesTag = attributesTag+"<qSubSegment>PBG</qSubSegment>";
				}
				//String WFuploadInputXML=getWFUploadWorkItemXML(cabinetName,sessionID,processDefID,attributesTag,queueID);
				String WFuploadInputXML =  "<?xml version=\"1.0\"?>"+
						"<WFUploadWorkItem_Input>"+
						"<Option>WFUploadWorkItem</Option>"+
						"<EngineName>"+cabinetName+"</EngineName>"+
						"<SessionId>"+sessionID+"</SessionId>"+
						"<ProcessDefId>"+processDefID+"</ProcessDefId>"+
						"<QueueId>"+queueID+"</QueueId>"+
						"<DataDefName></DataDefName>"+
						"<Fields></Fields>"+
						"<InitiateAlso>N</InitiateAlso>"+
						"<Documents></Documents>"+
						"<Attributes>"+attributesTag+"</Attributes>"+
						"<UserDefVarFlag>Y</UserDefVarFlag>"+
						"</WFUploadWorkItem_Input>";
				//WFuploadInputXML = replaceXChars(WFuploadInputXML);
				KYCreadExcelLog.KYCreadExcelLogger.debug("WFuploadInputXML: "+WFuploadInputXML);

				String WFuploadOutputXML =CommonMethods.WFNGExecute(WFuploadInputXML, jtsIP, jtsPort, 1);
				KYCreadExcelLog.KYCreadExcelLogger.debug("WFuploadOutputXML: "+ WFuploadOutputXML);

				XMLParser xmlParserWFupload = new XMLParser(WFuploadOutputXML);
				String Maincode = xmlParserWFupload.getValueOf("MainCode");
				KYCreadExcelLog.KYCreadExcelLogger.debug("Status of Maincode  "+ Maincode);
				String ProcessInstanceId="";
				ProcessInstanceId=xmlParserWFupload.getValueOf("ProcessInstanceId");
				String UserName=xmlParserWFupload.getValueOf("UserName");
				String MsgFormat=xmlParserWFupload.getValueOf("Option");
				String CreationDateTime=xmlParserWFupload.getValueOf("CreationDateTime");
				insertReqRespINDatabase(WFuploadInputXML,WFuploadOutputXML,MsgFormat,ProcessInstanceId,UserName,CreationDateTime);
				if(Maincode.equalsIgnoreCase("0"))
				{
					KYCreadExcelLog.KYCreadExcelLogger.debug("WFupload successful: "+Maincode);
					KYCreadExcelLog.KYCreadExcelLogger.debug("WI Created successfully.");
					
					//going to update status to completed in DB excel table
					String sNO = entry.get("insertionOrderID");
					String columnToUpdate = "Wi_Name,Status";
					String whereClause = "insertionOrderID = "+sNO;
					String values = "'"+ProcessInstanceId+"','C'";
					
					String apUpdateInput=CommonMethods.apUpdateInput(cabinetName,sessionID,table,columnToUpdate,values,whereClause);
					KYCreadExcelLog.KYCreadExcelLogger.debug("apUpdateInput: "+apUpdateInput);

					String apUpdateOutputXML =CommonMethods.WFNGExecute(apUpdateInput, jtsIP, jtsPort, 1);
					KYCreadExcelLog.KYCreadExcelLogger.debug("apUpdateOutputXML: "+ apUpdateOutputXML);

					XMLParser xmlParserapUpdate = new XMLParser(apUpdateOutputXML);
					String MaincodeAPudate = xmlParserapUpdate.getValueOf("MainCode");
					if(MaincodeAPudate.equalsIgnoreCase("0"))
					{
						KYCreadExcelLog.KYCreadExcelLogger.debug("AP Update successful for row no "+sNO);
						Date d = new Date();
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String strDate = dateFormat.format(d);
						
						String tableName = "NG_KYC_REM_GR_HISTORY";
						String columnName = "DateTime,Workstep,Decision,UserName,Remarks,WI_Name,Entry_Date_Time";
						String columnValues = "'"+strDate+"','Introduction','Success','rakBPMutility','Workitem created successfully','"+ProcessInstanceId+"','"+CreationDateTime+"'";
						
						String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName,columnValues,tableName);
						KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertInputXML: "+apInsertInputXML);

						String apInsertOutputXML =CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
						KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

						XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
						String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
						KYCreadExcelLog.KYCreadExcelLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
						if(apInsertMaincode.equalsIgnoreCase("0"))
						{
							KYCreadExcelLog.KYCreadExcelLogger.debug("ApInsert successful: "+apInsertMaincode);
							KYCreadExcelLog.KYCreadExcelLogger.debug("Data Inserted in history table successfully.");
							String RP_WI_Status = createIndividualCorporateWI(cabinetName,sessionID,jtsIP,jtsPort,COPR_CIF);
							
							String tagData = "select Workitemid from WFINSTRUMENTTABLE where ProcessInstanceID = '"+ProcessInstanceId+"'";
							String dataInputXML = CommonMethods.apSelectWithColumnNames(tagData, cabinetName, sessionID);
							String dataOutputXML = CommonMethods.WFNGExecute(dataInputXML, jtsIP, jtsPort, 1);
							XMLParser dataxmlParserAPSelect = new XMLParser(dataOutputXML);
							String dataMainCode = dataxmlParserAPSelect.getValueOf("MainCode");
							int dataTotalRecords = Integer.parseInt(dataxmlParserAPSelect.getValueOf("TotalRetrieved"));
							if (dataMainCode.equals("0") && dataTotalRecords > 0) {
								String WorkItemID = dataxmlParserAPSelect.getValueOf("Workitemid");
							
							String WMCompleteWI = CommonMethods.completeWorkItemInput(cabinetName,sessionID,ProcessInstanceId,WorkItemID);
							KYCreadExcelLog.KYCreadExcelLogger.debug("WMCompleteWI input XML: "+WMCompleteWI);
							String WMCompleteOutputXML =CommonMethods.WFNGExecute(WMCompleteWI, jtsIP, jtsPort, 1);
							KYCreadExcelLog.KYCreadExcelLogger.debug("WMCompleteOutputXML: "+ WMCompleteOutputXML);
							XMLParser xmlParserWMComplete = new XMLParser(WMCompleteOutputXML);
							String WMCompleteMaincode = xmlParserWMComplete.getValueOf("MainCode");
							KYCreadExcelLog.KYCreadExcelLogger.debug("Status of WMCompleteMaincode  "+ WMCompleteMaincode);
							}
						}
					}	
				}
			}
			CordbExtColumnMap.clear();
			CorDataFromDB.clear();
			return "true";
		} catch (Exception e) {
			KYCreadExcelLog.KYCreadExcelLogger.debug("exception: " + e);
			return "false";
		}
	}
	
	public static String createIndividualCorporateWI(String cabinetName, String sessionID, String jtsIP, String jtsPort,String CORP_CIF) {
		try {
			
			String coumn_external =ODDocConfigParamMap.get("RPDBcolumn&extColumn");
			//KYCreadExcelLog.KYCreadExcelLogger.debug("coumn_external: "+coumn_external);
			
			String query = "select * from NG_KYC_REM_BO_IBPS_TABLE with (nolock) Where (cif_id is not null or cif_id != '')"
					+ " and (COPR_CIF = "+CORP_CIF+") and (Status = 'R' or Status is null or Status = '')";

//			String[] DBcolumn = columnNames.split(",");
			String RP_CIF_ID = "";
			String RP_Name = "";
			String RP_Type = "";
			HashMap<String,String>  dbExtColumnMap= new HashMap<>();
			List<Map<String, String>> DataFromDB = new ArrayList<Map<String, String>>();
			DataFromDB = getDataFromDBMap(query,cabinetName,sessionID,jtsIP, jtsPort);
			String[] DbExtColumn = coumn_external.split(",");
			for(int i=0;i<DbExtColumn.length;i++)
			{
				String[] value = DbExtColumn[i].split("@");
				dbExtColumnMap.put(value[0],value[1]);
			}
			Set<String> keys = dbExtColumnMap.keySet();
			for(Map<String,String> entry : DataFromDB){
				String attributesTag = "";
				for(String key : keys){
					String keyValue = entry.get(key);
					System.out.println(keyValue);
					String ExtColToKey = dbExtColumnMap.get(key);
					attributesTag = attributesTag+"<"+ExtColToKey+">"+replaceXChars(keyValue)+"</"+ExtColToKey+">";
					if("CIF_ID".equalsIgnoreCase(key)){
						RP_CIF_ID = keyValue;
					}
					if("RP_NAMES".equalsIgnoreCase(key)){
						RP_Name = keyValue;
					}
					if("RP_DETAILS".equalsIgnoreCase(key)){
						RP_Type = keyValue;
					}
					
				}
				attributesTag = attributesTag+"<CaseType>RelatedParty</CaseType>";
				
				String WFuploadInputXML=getWFUploadWorkItemXML(cabinetName,sessionID,processDefID,attributesTag,queueID);
				//WFuploadInputXML = replaceXChars(WFuploadInputXML);
				KYCreadExcelLog.KYCreadExcelLogger.debug("WFuploadInputXML: "+WFuploadInputXML);

				String WFuploadOutputXML =CommonMethods.WFNGExecute(WFuploadInputXML, jtsIP, jtsPort, 1);
				KYCreadExcelLog.KYCreadExcelLogger.debug("WFuploadOutputXML: "+ WFuploadOutputXML);

				XMLParser xmlParserWFupload = new XMLParser(WFuploadOutputXML);
				String Maincode = xmlParserWFupload.getValueOf("MainCode");
				KYCreadExcelLog.KYCreadExcelLogger.debug("Status of Maincode  "+ Maincode);
				String ProcessInstanceId="";
				ProcessInstanceId=xmlParserWFupload.getValueOf("ProcessInstanceId");
				String UserName=xmlParserWFupload.getValueOf("UserName");
				String MsgFormat=xmlParserWFupload.getValueOf("Option");
				String CreationDateTime=xmlParserWFupload.getValueOf("CreationDateTime");
				insertReqRespINDatabase(WFuploadInputXML,WFuploadOutputXML,MsgFormat,ProcessInstanceId,UserName,CreationDateTime);
				if(Maincode.equalsIgnoreCase("0"))
				{
					KYCreadExcelLog.KYCreadExcelLogger.debug("WFupload successful: "+Maincode);
					KYCreadExcelLog.KYCreadExcelLogger.debug("WI Created successfully.");
					
					//going to update status to completed in DB excel table
					String sNO = entry.get("insertionOrderID");
					String columnToUpdate = "Wi_Name,Status";
					String whereClause = "insertionOrderID = "+sNO;
					String values = "'"+ProcessInstanceId+"','C'";
					
					String apUpdateInput=CommonMethods.apUpdateInput(cabinetName,sessionID,table,columnToUpdate,values,whereClause);
					KYCreadExcelLog.KYCreadExcelLogger.debug("apUpdateInput: "+apUpdateInput);

					String apUpdateOutputXML =CommonMethods.WFNGExecute(apUpdateInput, jtsIP, jtsPort, 1);
					KYCreadExcelLog.KYCreadExcelLogger.debug("apUpdateOutputXML: "+ apUpdateOutputXML);

					XMLParser xmlParserapUpdate = new XMLParser(apUpdateOutputXML);
					String MaincodeAPudate = xmlParserapUpdate.getValueOf("MainCode");
					if(MaincodeAPudate.equalsIgnoreCase("0"))
					{
						KYCreadExcelLog.KYCreadExcelLogger.debug("AP Update successful for row no "+sNO);
						Date d = new Date();
						SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						String strDate = dateFormat.format(d);
						
						String tableName = "NG_KYC_REM_GR_HISTORY";
						String columnName = "DateTime,Workstep,Decision,UserName,Remarks,WI_Name,Entry_Date_Time";
						String columnValues = "'"+strDate+"','Introduction','Success','rakBPMutility','Workitem created successfully','"+ProcessInstanceId+"','"+CreationDateTime+"'";
						
						String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName,columnValues,tableName);
						KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertInputXML: "+apInsertInputXML);

						String apInsertOutputXML =CommonMethods.WFNGExecute(apInsertInputXML, jtsIP, jtsPort, 1);
						KYCreadExcelLog.KYCreadExcelLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

						XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
						String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
						KYCreadExcelLog.KYCreadExcelLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
						if(apInsertMaincode.equalsIgnoreCase("0"))
						{
							KYCreadExcelLog.KYCreadExcelLogger.debug("ApInsert successful: "+apInsertMaincode);
							KYCreadExcelLog.KYCreadExcelLogger.debug("Data Inserted in history table successfully.");
							
							String QueryCaseType = "SELECT CompanyCIF FROM RB_KYC_REM_EXTTABLE with (nolock) where WINAME = '"
									+ ProcessInstanceId + "'";
							String CompanyCIF = "";
							String QueryCaseTypeInputXML = CommonMethods.apSelectWithColumnNames(QueryCaseType, cabinetName, sessionID);
							String QueryCaseTypeOutputXML = CommonMethods.WFNGExecute(QueryCaseTypeInputXML, jtsIP, jtsPort, 1);
							XMLParser QueryCaseTypexmlParserAPSelect = new XMLParser(QueryCaseTypeOutputXML);
							String QueryCaseTypeapSelectMaincode = QueryCaseTypexmlParserAPSelect.getValueOf("MainCode");
							int TotalRecords = Integer.parseInt(QueryCaseTypexmlParserAPSelect.getValueOf("TotalRetrieved"));
							if (QueryCaseTypeapSelectMaincode.equals("0") && TotalRecords > 0) {
								CompanyCIF = QueryCaseTypexmlParserAPSelect.getValueOf("CompanyCIF");
								if(!("".equalsIgnoreCase(CompanyCIF))){
									String WINameQuery = "SELECT WINAME FROM RB_KYC_REM_EXTTABLE with (nolock) where CIF_ID = '"
											+ CompanyCIF + "'";
									String WINAME = "";
									String WINAMEInputXML = CommonMethods.apSelectWithColumnNames(WINameQuery, cabinetName, sessionID);
									String OutputXML = CommonMethods.WFNGExecute(WINAMEInputXML, jtsIP, jtsPort, 1);
									XMLParser xmlParserAPSelect = new XMLParser(OutputXML);
									String WINameMaincode = xmlParserAPSelect.getValueOf("MainCode");
									int WINameTotalRecords = Integer.parseInt(QueryCaseTypexmlParserAPSelect.getValueOf("TotalRetrieved"));
									if (WINameMaincode.equals("0") && WINameTotalRecords > 0) {
										String WorkItemID = "";
										String ActivityID = "";
										String ProcessDefID = "";
										WINAME = xmlParserAPSelect.getValueOf("WINAME");
										String tagData = "select Workitemid,ActivityId,ProcessDefID from WFINSTRUMENTTABLE where ProcessInstanceID = '"+WINAME+"'";
										String dataInputXML = CommonMethods.apSelectWithColumnNames(tagData, cabinetName, sessionID);
										String dataOutputXML = CommonMethods.WFNGExecute(dataInputXML, jtsIP, jtsPort, 1);
										XMLParser dataxmlParserAPSelect = new XMLParser(dataOutputXML);
										String dataMainCode = dataxmlParserAPSelect.getValueOf("MainCode");
										int dataTotalRecords = Integer.parseInt(dataxmlParserAPSelect.getValueOf("TotalRetrieved"));
										if (dataMainCode.equals("0") && dataTotalRecords > 0) {
											WorkItemID = dataxmlParserAPSelect.getValueOf("Workitemid");
											ActivityID = dataxmlParserAPSelect.getValueOf("ActivityID");
											ProcessDefID =  dataxmlParserAPSelect.getValueOf("ProcessDefID");
											
											String getWorkItemInputXML1 = CommonMethods.getWorkItemInput(cabinetName, sessionID, WINAME,WorkItemID);
											KYCreadExcelLog.KYCreadExcelLogger.debug("input XML For WmgetWorkItemCall: "+ getWorkItemInputXML1);
											String getWorkItemOutputXml1 = CommonMethods.WFNGExecute(getWorkItemInputXML1,jtsIP, jtsPort,1);
											KYCreadExcelLog.KYCreadExcelLogger.debug("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml1);
											
											XMLParser xmlParserGetWorkItem1 = new XMLParser(getWorkItemOutputXml1);
											String getWorkItemMainCode1 = xmlParserGetWorkItem1.getValueOf("MainCode");
											KYCreadExcelLog.KYCreadExcelLogger.debug("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode1);
											if("0".equalsIgnoreCase(getWorkItemMainCode1)){
											String assignInputXML = "<?xml version=\"1.0\"?><WMAssignWorkItemAttributes_Input>"
						                            + "<Option>WMAssignWorkItemAttributes</Option>"
						                            + "<EngineName>"+cabinetName+"</EngineName>"
						                            + "<SessionId>"+sessionID+"</SessionId>"
						                            + "<ProcessInstanceId>"+WINAME+"</ProcessInstanceId>"
						                            + "<WorkItemId>"+WorkItemID+"</WorkItemId>"
						                            + "<ActivityId>"+ActivityID+"</ActivityId>"
						                            + "<ProcessDefId>"+ProcessDefID+"</ProcessDefId>"
						                            + "<LastModifiedTime></LastModifiedTime>"
						                            + "<ActivityType></ActivityType>"
						                            + "<complete></complete>"
						                            + "<AuditStatus></AuditStatus>"
						                            + "<Comments></Comments>"
						                            + "<UserDefVarFlag>Y</UserDefVarFlag>"
						                            + "<Attributes><Q_NG_KYC_REM_RP_GRID><CIF>"+RP_CIF_ID+"</CIF><RP_WI_Number>"+ProcessInstanceId+"</RP_WI_Number><RP_Name>"+RP_Name+"</RP_Name><RP_Details>"+RP_Type+"</RP_Details></Q_NG_KYC_REM_RP_GRID></Attributes>"
						                            + "</WMAssignWorkItemAttributes_Input>";
											
											KYCreadExcelLog.KYCreadExcelLogger.debug("assignInputXML--- "+assignInputXML);
											String assignOutXml = CommonMethods.WFNGExecute(assignInputXML, jtsIP, jtsPort, 1);
											KYCreadExcelLog.KYCreadExcelLogger.debug("assignOutXml--- "+assignOutXml);
											// PRINT MAINCODE
											XMLParser xmlParserAPSelectFinal = new XMLParser(assignOutXml);
											String xmlParserAPSelectFinalMaincode = xmlParserAPSelectFinal.getValueOf("MainCode");
											if (xmlParserAPSelectFinalMaincode.equalsIgnoreCase("0")){
												KYCreadExcelLog.KYCreadExcelLogger.debug("Related Item added in grid");
												/*String unlockWI_XML = "<?xml version=\"1.0\"?><WMUnlockWorkItem_Input>"
						                            + "<Option>WMUnlockWorkItem</Option>"
						                            + "<EngineName>"+cabinetName+"</EngineName>"
						                            + "<SessionId>"+sessionID+"</SessionId>"
						                            + "<ProcessInstanceID>"+WINAME+"</ProcessInstanceId>"
						                            + "<WorkItemId>"+WorkItemID+"</WorkItemId>"
						                            + "<UnlockOption>U</UnlockOption>"
						                            +"</WMUnlockWorkItem_Input>";
												KYCreadExcelLog.KYCreadExcelLogger.debug("assignInputXML--- "+unlockWI_XML);
												String unlockWIOutXml = CommonMethods.WFNGExecute(unlockWI_XML, jtsIP, jtsPort, 1);
												KYCreadExcelLog.KYCreadExcelLogger.debug("unlockWIOutXml--- "+unlockWIOutXml);*/
											}
										}
										}
									}
									else{
										KYCreadExcelLog.KYCreadExcelLogger.debug("CCorporate WIname not found ");
									}
								}
							} else {
								KYCreadExcelLog.KYCreadExcelLogger.debug("CompanyCIF not recieved ");
							}
						}
					}	
				}
			}
			dbExtColumnMap.clear();
			DataFromDB.clear();
			return "true";
		} catch (Exception e) {
			KYCreadExcelLog.KYCreadExcelLogger.debug("exception: " + e);
			return "false";
		}
	}
	
	private static String replaceXChars(String value)
    {
           // handling of special characters
           if(!"".equalsIgnoreCase(value) && !"null".equalsIgnoreCase(value)  && value != null)
           {
                  if(value.contains("&amp;"))
                        value = value.replace("&amp;", "AAMPRRSNDD");
                  if(value.contains("&lt;"))
                        value = value.replace("&lt;", "LLSSTNSPX");
                  if(value.contains("&gt;"))
                        value = value.replace("&gt;", "GGRTTNSPX");
                  /*if(value.contains("&quote;"))
                        value = value.replace("&quote;", "DOBBULEQOTTS");*/
                  if(value.contains("&"))
                        value = value.replace("&", "&amp;");
                  
                  if(value.contains("AAMPRRSNDD"))
                        value = value.replace("AAMPRRSNDD", "&amp;");
                  if(value.contains("LLSSTNSPX"))
                        value = value.replace("LLSSTNSPX", "&lt;");
                  if(value.contains("GGRTTNSPX"))
                        value = value.replace("GGRTTNSPX", "&gt;");
                  /*if(value.contains("DOBBULEQOTTS"))
                        value = value.replace("DOBBULEQOTTS", "&quote;");*/
                  
                  if(value.contains("<"))
                        value = value.replace("<", "&lt;");
                  if(value.contains(">"))
                        value = value.replace(">", "&gt;");
                  /*if(value.contains("\""))
                        value = value.replace("\"", "&quote;");*/
           }
           return value;
    }
	
	private static List<Map<String, String>> getDataFromDBMap(String query, String cabinetName, String sessionID,
			String jtsIP, String jtsPort) {
		List<Map<String, String>> temp = new ArrayList<Map<String, String>>();
		try {
			KYCreadExcelLog.KYCreadExcelLogger.debug("Inside function getDataFromDB");
			KYCreadExcelLog.KYCreadExcelLogger.debug("getDataFromDB query is: " + query);
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
								KYCreadExcelLog.KYCreadExcelLogger
										.debug("getDataFromDBMap Setting value of " + column + " as " + value);
								t.put(column, value);
							} else {
								KYCreadExcelLog.KYCreadExcelLogger
										.debug("getDataFromDBMap Setting value of " + column + " as blank");
								t.put(column, "");
							}
						}
					}
					temp.add(t);
				}
			}

		} catch (Exception e) {
			KYCreadExcelLog.KYCreadExcelLogger.debug("Exception occured in getDataFromDBMap method" + e.getMessage());
		}
		return temp;

	}
	private static String getAPProcedureInputXML(String engineName,String sSessionId,String procName,String Params)
	{
		StringBuffer bfrInputXML = new StringBuffer();
		bfrInputXML.append("<?xml version=\"1.0\"?>\n");
		bfrInputXML.append("<APProcedure_WithDBO_Input>\n");
		bfrInputXML.append("<Option>APProcedure_WithDBO</Option>\n");
		bfrInputXML.append("<ProcName>");
		bfrInputXML.append(procName);
		bfrInputXML.append("</ProcName>");
		bfrInputXML.append("<Params>");
		bfrInputXML.append(Params);
		bfrInputXML.append("</Params>");
		bfrInputXML.append("<EngineName>");
		bfrInputXML.append(engineName);
		bfrInputXML.append("</EngineName>");
		bfrInputXML.append("<SessionId>");
		bfrInputXML.append(sSessionId);
		bfrInputXML.append("</SessionId>");
		bfrInputXML.append("</APProcedure_WithDBO_Input>");		
		return bfrInputXML.toString();
	}
	private static String executeAPI(String sInputXML){
		String sOutputXML="";
		try{
			 Socket sock = null;
			 sock = new Socket(jtsIP,Integer.parseInt(jtsPort));
			 DataOutputStream oOut = new DataOutputStream(new BufferedOutputStream(sock.getOutputStream()));
			 DataInputStream oIn = new DataInputStream(new BufferedInputStream(sock.getInputStream()));
			 byte[] SendStream = sInputXML.getBytes("8859_1");
			 int strLen = SendStream.length;
	         oOut.writeInt(strLen);
	    	 oOut.write(SendStream, 0, strLen);
			 oOut.flush();
			 int length = 0;
			 length = oIn.readInt();
			 byte[] readStream = new byte[length];
			 oIn.readFully(readStream);
			 sOutputXML= new String(readStream, "8859_1");
			 sock.close(); 
		}
		catch (Exception e){
			KYCreadExcelLog.KYCreadExcelLogger.debug("sOutputXML: XML Log "+sOutputXML);
			KYCreadExcelLog.KYCreadExcelLogger.debug("Exception: "+e.getMessage());
			
		}
		return sOutputXML;
    }
	
	public static boolean insertReqRespINDatabase(String WFuploadInputXML,String WFuploadOutputXML,String MsgFormat,String ProcessInstanceId,String UserName,String requestedDateTime){
		try{
			
			Date localDate = new Date();
			SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.mmm");
			String actionDateTime = localSimpleDateFormat.format(localDate);
			String XMLHISTORY_TABLENAME = "NG_KYC_Remedation_XMLLOG_HISTORY";
			String MsgIDInReq="";
            String params="'"+XMLHISTORY_TABLENAME+"'"
					+",'" +ProcessInstanceId+"'"
					+",'" +MsgFormat+"'"
					+",'" +MsgFormat+"'"
					+",'" +UserName+"'"
					+",'" +MsgIDInReq+"'"
					+",'" +WFuploadInputXML.replaceAll("'", "''")+"'"
					+",'" +WFuploadOutputXML.replaceAll("'", "''")+"'"
					+",'" +requestedDateTime+"'"
					+",'" +actionDateTime+"'";
			String inputXML = getAPProcedureInputXML(cabinetName,sessionID,"NG_XML_INSERT_PROC",params);
			//KYCreadExcelLog.KYCreadExcelLogger.debug("inputXML AP Procedure new params: "+params);
			KYCreadExcelLog.KYCreadExcelLogger.debug("inputXML AP Procedure XML Entry "+inputXML);
			String sOutputXML=executeAPI(inputXML);
			KYCreadExcelLog.KYCreadExcelLogger.debug("outputXML AP Procedure XML Entry "+sOutputXML);			

			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1){
				KYCreadExcelLog.KYCreadExcelLogger.debug("inputXML AP Procedure Insert Successful");	
				return true;
			}	
			else{
				KYCreadExcelLog.KYCreadExcelLogger.debug("inputXML AP Procedure Insert Failed");
				return false;
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return false;
	}
	
	private static String getWFUploadWorkItemXML(String sCabinetName,String sSessionID,String processDefID,String attributeTag,String queueID){	
			return  "<?xml version=\"1.0\"?>"+
					"<WFUploadWorkItem_Input>"+
					"<Option>WFUploadWorkItem</Option>"+
					"<EngineName>"+sCabinetName+"</EngineName>"+
					"<SessionId>"+sSessionID+"</SessionId>"+
					"<ProcessDefId>"+processDefID+"</ProcessDefId>"+
					"<QueueId>"+queueID+"</QueueId>"+
					"<DataDefName></DataDefName>"+
					"<Fields></Fields>"+
					"<InitiateAlso>Y</InitiateAlso>"+
					"<Documents></Documents>"+
					"<Attributes>"+attributeTag+"</Attributes>"+
					"<UserDefVarFlag>Y</UserDefVarFlag>"+
					"</WFUploadWorkItem_Input>";
		}
}
