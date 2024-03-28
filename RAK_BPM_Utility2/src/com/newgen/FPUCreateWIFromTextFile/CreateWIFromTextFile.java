package com.newgen.FPUCreateWIFromTextFile;

import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Date;
import java.text.DateFormat;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.excp.NGException;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;
import com.newgen.wfdesktop.xmlapi.WFInputXml;
import com.newgen.wfdesktop.xmlapi.WFXmlList;
import com.newgen.wfdesktop.xmlapi.WFXmlResponse;

public class CreateWIFromTextFile implements Runnable {
	static Map<String, String> CreateWIFromTextFileConfigParamMap = new HashMap<String, String>();
	static String sessionID = "";
	static String cabinetName = "";
	static String jtsIP ="";
	static String jtsPort ="";
	int sleepIntervalInMin = 0;
	static String tempInputFileName ="";
	static String dateInInputFile ="";
	public static int sessionCheckInt=0;
	public static int loopCount=50;
	public static int waitLoop=50;
	public static String sdate="";
	public static String InputFileName;
	public static String InputXML="";
	public static String TimeStamp="";
	public static String newFilename=null;
	public static String masterColumnNames="";
	public static String AttributesXml="";
	public static String efmsTablename="";
	public static String fromMailID="";
	public static String toMailID="";
	public static String ProcessDefID="";
	public static String activityId="";
	public static String activityName= "";
	public static String queueId= "";
	public static String deleteSuccessDataBeforeDays;
	public static String UniqueParameter="";
	
	private static char fieldSep = ((char)21); //Constant
	private static char hashChar =((char)35); //Constant
	private static char recordSep =((char)25);  //Constant
	private static NGEjbClient ngEjbClientConnection;

	static
	{
		try
		{
			ngEjbClientConnection = NGEjbClient.getSharedInstance();
		}
		catch (NGException e)
		{
			e.printStackTrace();
		}
	}

	
	@Override
	public void run() 
	{
		
		try
		{
			CreateWIFromTextFileLog.setLogger();
			//ngEjbClientDormancyChanges = NGEjbClient.getSharedInstance();

			//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("configReadStatus " + configReadStatus);
			if (configReadStatus != 0) 
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Could not Read Config Properties [FPU_CreateWIFromTextFile_Config]");
				return;
			}
			else
			{
				 masterColumnNames=CreateWIFromTextFileConfigParamMap.get("MasterColumnNames");
				 AttributesXml=CreateWIFromTextFileConfigParamMap.get("ATTRIBUTETAG");
				efmsTablename=CreateWIFromTextFileConfigParamMap.get("EFMSTabelName");
				fromMailID=CreateWIFromTextFileConfigParamMap.get("FromMailId");
				toMailID=CreateWIFromTextFileConfigParamMap.get("ToMailId");
				ProcessDefID= CreateWIFromTextFileConfigParamMap.get("ProcessDefID");
			    activityId= CreateWIFromTextFileConfigParamMap.get("ActivityId");
			    activityName= CreateWIFromTextFileConfigParamMap.get("ActivityName");
			    queueId= CreateWIFromTextFileConfigParamMap.get("QueueID");
			    deleteSuccessDataBeforeDays= CreateWIFromTextFileConfigParamMap.get("DeleteSuccessDataBeforeDays");
			    UniqueParameter=CreateWIFromTextFileConfigParamMap.get("MandandUniqueField");
			}
			cabinetName = CommonConnection.getCabinetName();
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("JTSPORT: " + jtsPort);

			sleepIntervalInMin = Integer.parseInt(CreateWIFromTextFileConfigParamMap.get("SleepIntervalInMin"));
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("SleepIntervalInMin: " + sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);

			if (sessionID.trim().equalsIgnoreCase(""))
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("Could Not Connect to Server!");
			} 
			else
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("Session ID found: " + sessionID);

				while (true) 
				{
					CreateWIFromTextFileLog.setLogger();
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("Create Work Item from Text File..123.");
					sessionID = CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);
					startUtilityCreateWIFromTextFile(cabinetName, sessionID, jtsIP, jtsPort);
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("No More workitems to Process, Sleeping!");
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin * 60 * 1000);
				}
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception Occurred in CreateWIFromTextFie: " + e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception Occurred in CreateWIFromTextFie: " + result);
		}
	}
	private int readConfig() 
	{
		Properties p = null;
		try 
		{
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigFiles"
					+ File.separator + "FPU_CreateWIFromTextFile_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements()) 
			{
				String name = (String) names.nextElement();
				CreateWIFromTextFileConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1;
		}
		return 0;
	}
	private static void startUtilityCreateWIFromTextFile(String cabinetName, String sessionId, String JtsIp,String JtsPort) 
	{
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Inside startUtilityCreateWIFromTextFile..");
		//ArrayList<String> wiList = new ArrayList<String>();
		String readTextFileStatus="";
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Before Calling Read text file");
		readTextFileStatus=readTextFile();
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("After Calling Read text file with readTextFileStatus  --"+readTextFileStatus);
		createWorkItem();
		
	}
	private static String readTextFile(){
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Reading Text File and insert data in DB table...");
	    ArrayList<String> wiArrayList = new ArrayList<String>();
	    String readTextFileStatus="FAIL";
	    String inputFolder = CreateWIFromTextFileConfigParamMap.get("InputFolder");
	    String outputFolder = CreateWIFromTextFileConfigParamMap.get("OutputFolder");
	    String errorFolder = CreateWIFromTextFileConfigParamMap.get("ErrorFolder");
	 
	    try {
	    	Date now = new Date();
			Format formatter = new SimpleDateFormat("dd-MMM-yy");
			sdate = formatter.format(now);
	    	CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("inputFolder: "+inputFolder);
	    	File inputFolderforFiles = new File(inputFolder);
	    	String outputFolderWithDate = outputFolder+System.getProperty("file.separator")+sdate;
	    	File errorFolderForFiles =new File(errorFolder);
	    	
	    	File[] files;
	    	if(inputFolderforFiles.exists())
	    	{
	    		String[] tempfiles=inputFolderforFiles.list();
	    		if(tempfiles.length>0)
	    		{
	    			files = inputFolderforFiles.listFiles(new FilenameFilter() {
	    	    		@Override
	    	    		public boolean accept(File dir, String name) {
	    	    			if(name.toLowerCase().endsWith(".txt")){
	    	    				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Extension is correct for file--: "+name);
	    						return true;
	    					} else {
	    						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Extension is incorrect for file--: "+name);
	    						return false;
	    					}
	    				}
	    	    	});
	    		}
	    		else
	    		{
	    			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Input Directory is Empty!.. directory location is- "+inputFolder);
	    			return readTextFileStatus;
	    		}
	    	}
	    	else
    		{
    			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Input Directory not Exist.. directory location is- "+inputFolder);
    			return readTextFileStatus;
    		}
	    	
	    	
	    	for(File f: files) {
	    		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("getting file name: "+f.getName());
	    		ArrayList<String> tempwiAttributeList = null;
	    		File inputFile = new File(inputFolder+f.getName());
	    		tempInputFileName =  inputFile.getName();
	    		InputFileName = FilenameUtils.removeExtension(tempInputFileName).trim();
	    		Scanner inputscanner = new Scanner(inputFile);
	    		int flag=0;
				int recordCount=0;
	    		while(inputscanner.hasNextLine()) {
	    			String line = inputscanner.nextLine();
	    			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("line: "+line);
	    			String splitdata[] = line.split("~");
	    			String recordID = splitdata[0];
	    			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("recordID: "+recordID);
	    			if(recordID!=null && recordID.equalsIgnoreCase("H")) {
	    				dateInInputFile = splitdata[1];
	    				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("date : "+dateInInputFile);
	    				String tempfilename=splitdata[2];
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("tempfilename : "+tempfilename);
						String FileNameInData = FilenameUtils.removeExtension(tempfilename).trim();
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("FileName in Data = "+FileNameInData);
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("InputFileName = "+inputFile+"\n  filename  = "+FileNameInData);
						if(!FileNameInData.equalsIgnoreCase(InputFileName))
						{
							flag = 1;
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("File Data mismatch for file : "+tempInputFileName);
							sendMail(cabinetName,sessionID,"FILENAME MISMATCH",tempInputFileName);
							break;
						}
						else
						{
							tempwiAttributeList = new ArrayList<String>();
						}

	    			}
	    			if(recordID!=null && recordID.equalsIgnoreCase("B"))
	    			{
	    				recordCount++;
	    				Map<String, String> bodyFieldMap = new HashMap<String, String>();
	    				String bodyFields = CreateWIFromTextFileConfigParamMap.get("BodyFields");
	    				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Body Field String "+bodyFields);
                         String[] bodyFieldsArray = bodyFields.split(",");
 	    				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Body Fields Array "+bodyFieldsArray);
                         for(int i = 0;i<bodyFieldsArray.length;i++)
                         {
                        	 bodyFieldMap.put(bodyFieldsArray[i], splitdata[i+1]);
     	    				//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("body Fiels key,value "+i+" "+bodyFieldsArray[i]+" "+splitdata[i+1]);
                         }

	    				String tmpValues = "";
	    				for(int i = 0;i<bodyFieldsArray.length;i++)
                         {
	    					tmpValues += bodyFieldMap.get(bodyFieldsArray[i])+"~";
     	    				//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Current Temp Value... "+tmpValues);
                         }
	    				      tmpValues += tempInputFileName+"~"+dateInInputFile;
     	    				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Final tmpValues-- "+tmpValues);
	    				//String tmpValues = customerName+"|"+applicationNumber+"|"+employerName+"|"+CIF+"|"+schemeDescription+"|"+product+"|"+constitution+"|"+creditLimit+"|"+customerSegment+"|"+applodgeddate;
	    			    tmpValues = tmpValues.replace("'", "''");
	    			    tempwiAttributeList.add(tmpValues);
    				
	    			}
	    			
	    			if(recordID!= null && recordID.equalsIgnoreCase("T")){
                       int totalrecord = Integer.parseInt(splitdata[1]);
						
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("totalrecord : "+totalrecord+" recordCount :"+recordCount);
						
						if(totalrecord!=recordCount)
						{
							flag=1;
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("No of records mismatch for file : "+inputFile);
							tempwiAttributeList.clear();
							sendMail(cabinetName,sessionID,"RECORD COUNT MISMATCH",tempInputFileName);
							break;
						}
	    				
	    			}
	    		}
	    		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("record mismatch flag: "+flag);
	    		if(flag == 1)
	    		{
	    			inputscanner.close();
	    			FileUtils.copyFileToDirectory(inputFile, errorFolderForFiles);
	    			inputFile.delete();
	    			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Moved file to Error Folder due to record count mismatch: "+tempInputFileName);
	    		}
	    		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("tempwiAttributeList: "+tempwiAttributeList);
	    		if(tempwiAttributeList !=null && tempwiAttributeList.size()!= 0)
	    		{
	    			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("tempwiAttributeList size: "+tempwiAttributeList.size());
	    			for(String str: tempwiAttributeList)
	    			{
	    				wiArrayList.add(str);
	    			}
	    		}
	    		// Going to insert in table
				String insertStatusFinal = "";
				String insertStatusFailedData = "";
				if(wiArrayList!=null && wiArrayList.size()!=0)
				{
					for (String indRecord : wiArrayList)
					{
						//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("wiList = "+wiAttributeList);
						//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("indRecord = "+indRecord);
						String insertStat = TableInsert(indRecord,dateInInputFile);
						if (insertStat.contains("FAILED~"))
						{
							String [] sInsTemp = insertStat.split("~");
							insertStatusFinal = sInsTemp[0];
							insertStatusFailedData=insertStatusFailedData+insertStat+"$";
						}	
					}
					readTextFileStatus="SUCCESS";
					wiArrayList.clear();
					tempwiAttributeList.clear();
				}
				else
				{
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("No record in files to process");
					//ThreadConnect.addToTextArea(" No record in files to process ");
				}
				//*************************************
				
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("insertStatusFinal : "+insertStatusFinal);
				if(flag!=1)
				{
					if ("FAILED".equalsIgnoreCase(insertStatusFinal))
					{
						inputscanner.close();
						FileUtils.copyFileToDirectory(inputFile, errorFolderForFiles);
						inputFile.delete();
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Moved file to Error Folder due to failure in insert: "+tempInputFileName);
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("failure in insert records are: "+insertStatusFailedData);
						sendMail(cabinetName,sessionID,"INSERT FAILURE",tempInputFileName);
					}
					else
					{
						inputscanner.close();
						String inputFolder1 = ""+inputFolder+f.getName()+"";
						TimeStamp=get_timestamp();
						newFilename = Move(outputFolderWithDate,inputFolder1,TimeStamp);
						//FileUtils.copyFileToDirectory(inputFile, outputFolderForFiles);
						//inputFile.delete();
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Moved file to Success Folder: "+tempInputFileName);
						// Start - Deleting older data in Success Folder added by Angad on 15042020
						//File fileSuccessPath = new File(outputFolder);
						//deleteFolder(fileSuccessPath);
						//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Files deleted........");
						//deleteOlderRecordFromRemittanceTable();// deleting old records from remittance table
						// End - Deleting older data in Success Folder added by Angad on 15042020
					}
				}
	    		
	    	}
		
	        }catch(Exception e) {
	        	
	        	CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Error in reading text file ....With exception."+e.toString());
	        }
		
		return readTextFileStatus;
	}
	
	private static void createWorkItem()
	{
		try
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("createWorkItems function for Create Workitem Utility started");
			
			WFXmlList objWorkList=null;
			WFXmlResponse xmlParserData=new WFXmlResponse();
			XMLParser objXMLParser = new XMLParser();
			String Maincode="";
			String OutputXML="";
		    
		    CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("ProcessDefID = "+ProcessDefID);

			if(!ProcessDefID.equals(""))
			{

				String Query2 = CreateWIFromTextFileConfigParamMap.get("QueryToFetchAttributes");//"SELECT INTERNAL_EXTERNAL,IDENTIFICATION,REFERNCE_NUMBER,CUSTOMER_TYPE,SA_CODE,DATE_TIME,CORPORATE_ID,DEBIT_ACC_NO,DEBIT_CURRENCY,BENEFICIARY_NAME,BENEFICIARY_COUNTRY,ACCOUNTNO_IBAN,BANK_NAME,BANK_ADDRESS,CITY,COUNTRY,SWIFT_CODE,IFSC_CODE,BANK_CODE,CORRESPONDANT_BANK,REMITTING_CURRENCY,EQUIVALENT_AMOUNT,EXCHANGE_RATE,CHARGES,TRANSACTION_TYPE_CODE,STATUS,PURPOSE_OF_PAYMENT,DESCRIPTION,CHANNEL_INDICATOR,ID, RETRY, BUSINESSTRANSACTIONNAME, TEMPFILENAMEINDATA, TEMPFILENAMEINDATA2, CIFID FROM USR_0_TT_REMITTANCE_GRID WITH(NOLOCK) WHERE CREATE_WORKITEM_STATUS='N' OR (CREATE_WORKITEM_STATUS = 'E' AND RETRY <=2 AND DATEDIFF(MINUTE, PROCESSED_DATE,GETDATE())>15)";
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Query to fetch attributes from db = "+Query2);
				InputXML = CommonMethods.apSelectWithColumnNames(Query2, cabinetName, sessionID);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Getting data from remittance table InputXML = "+InputXML);
				OutputXML=WFNGExecute(InputXML, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);//CommonMethods.WFNGExecute(InputXML,jtsIP, jtsPort, 0);//ThreadConnect.WFNGExecutePD(InputXML,jtsIP,Integer.parseInt(jtsPort),1);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Getting data from EFMS table OutputXML = "+OutputXML);

				xmlParserData.setXmlString(OutputXML);
				Maincode=xmlParserData.getVal("MainCode");
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Getting data from EFMS table Maincode = "+Maincode);
				if(Maincode.equalsIgnoreCase("0"))
				{
					objWorkList = xmlParserData.createList("Records", "Record");
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Getting data from EFMS table Maincode = "+objWorkList);
					for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
					{
						String id=objWorkList.getVal("ID");
						String retryCount=objWorkList.getVal("RETRY");
						
						String mandandUniqueFieldValue=objWorkList.getVal(UniqueParameter);
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("objWorkList loop--for id and mandandUniqueFieldValue = "+id+" , "+mandandUniqueFieldValue);
						if(mandandUniqueFieldValue!=null && !mandandUniqueFieldValue.equals(""))
						{
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info(UniqueParameter+" value for which WI going to be created = "+mandandUniqueFieldValue);
							//String attributeTag="";
							String columns[]=masterColumnNames.split(",");
							//String fieldIds=fieldIDs.split(",");
							String attributeTagValue=AttributesXml;
							for(int i=0;i<(columns.length-3);i++)
							{
								String column=columns[i];
								String value=objWorkList.getVal(column);
								//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Creating Attribute tag---Field and coorresponding Value  is--"+column+" , "+value);
								if(column.contains("DATE")&&value!=null)
								{
									value=parseDate(value);
								}
							    String placeHolder="$"+column+"$";
								if(value!=null)
								{
								    //CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Creating Attribute tag---PlaceHolder and coorresponding Value  is--"+placeHolder+" , "+value);
								    attributeTagValue = attributeTagValue.replace(placeHolder, value);	
								}
								else
								{
									attributeTagValue = attributeTagValue.replace(placeHolder, "");
								}
								
								//attributeTag+=fieldIds[i]+fieldSep+objWorkList.getVal(columns[i])+recordSep;
							}
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Creating Attribute tag---Attribute tag value after replacing all the place holders--"+attributeTagValue);
							String Status=createSingleWorkItem(ProcessDefID,activityId,activityName,mandandUniqueFieldValue, attributeTagValue, id, retryCount);
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Status of createSingleWorkItem:"+Status);
							String values[]=Status.split("~");
							if(values[0].equalsIgnoreCase("Success"))
							{
								String wiName = values[1];
								CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Success count: "+values[0]);
								historyCaller(cabinetName,sessionID,wiName,values[0]);
							}
						}
						
					}
				}

				
				
			}
			else
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Process doesn't exists in ProcessDefTable");
			}


		}
		catch (Exception e)
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Error occured in createWorkItem method with exception "+ e.toString());
		}
			
	}
	public static String createSingleWorkItem(String processDefID,String activityID,String activityNAME, String mandFieldValue, String attributeTag, String iD2, String RETRY) throws NumberFormatException, Exception
	{
		String strResult="";
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("attributetag in createSingleWorkItem = "+attributeTag);
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Mandatory & Unique field value in createSingleWorkItem = "+mandFieldValue);
		XMLParser objXMLParser = new XMLParser();
		String WIUploadInputXML=null;
		String WIUploadOutputXML = null;
		String mainCodeforWIUpload=null;

		String workItemName = "";
		String createWIRemarks = "";
		
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				//CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("in ExecuteQuery_APUpdate");
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("attributetag 001");
				WIUploadInputXML = getWIUploadInputXML(cabinetName,sessionID,processDefID,activityID,activityNAME,attributeTag);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("WIUploadInputXML:::::::::::: "+WIUploadInputXML);
				WIUploadOutputXML =WFNGExecute(WIUploadInputXML, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);//CommonMethods.WFNGExecute(WIUploadInputXML,jtsIP, jtsPort, 1);//ThreadConnect.WFNGExecutePD(WIUploadInputXML,jtsIP,Integer.parseInt(jtsPort),1);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("WIUploadOutputXML:::::::::::: "+WIUploadOutputXML);
				objXMLParser.setInputXML(WIUploadOutputXML);
				mainCodeforWIUpload=objXMLParser.getValueOf("MainCode");
				workItemName=objXMLParser.getValueOf("ProcessInstanceId");
				createWIRemarks=objXMLParser.getValueOf("Subject");

			}
			catch(Exception e)
			{
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Error in createSingleWorkItem :", e);
				continue;
			}
			if (mainCodeforWIUpload.equalsIgnoreCase("11"))
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("invalid session createSingleWorkItem");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}

		String createWIStatus = "Y";		
		String decision="Success";
		if (!mainCodeforWIUpload.equalsIgnoreCase("0"))
		{
			createWIStatus = "E";
			decision="failure";
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception in Creating Workitem");
			createWIRemarks = "WFUpload Call Failure: "+createWIRemarks;
			sendMail(cabinetName,sessionID,"WI CREATION FAILURE",attributeTag);
		}
		else
		{
			createWIRemarks="Success";
			//ThreadConnect.addToTextArea("\n" + workItemName+ " created Succesfully.");
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Workitem "+workItemName+" created Succesfully.");
		}

		updateRecordData(mandFieldValue, iD2,createWIStatus, workItemName,RETRY,createWIRemarks);
		//(String refNo, String id,String createWIStatus, String wiName,String sRetryCount,String createWIRemarks)

		strResult=decision+"~"+workItemName;
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info(" after ExecuteQuery_APUpdate USR_0_TT_REMITTANCE_GRID:::::::::::: ");

		return strResult;
	}
	public static String getWIUploadInputXML(String cabinetName,String sessionid, String processdefid,String activityid,String activityname,String attributetag)
	{
		return "<?xml version=\"1.0\"?>\n"+
				"<WFUploadWorkItem_Input>\n"+
				"<Option>WFUploadWorkItem</Option>\n"+
				"<EngineName>"+cabinetName+"</EngineName>\n"+
				"<SessionId>"+sessionid+"</SessionId>\n"+
				"<ProcessDefId>"+processdefid+"</ProcessDefId>\n"+
				"<QueueId>"+queueId+"</QueueId>"+
				"<InitiateAlso>Y</InitiateAlso>\n"+
				"<Attributes>"+attributetag+"</Attributes>\n"+
				"<IsWorkItemExtInfo>N</IsWorkItemExtInfo>"+
				"<VariantId>0</VariantId>\r\n" + 
				"<UserDefVarFlag>Y</UserDefVarFlag>\r\n" + 
				"<Documents></Documents>"+
				"<InitiateFromActivityId>"+activityid+"</InitiateFromActivityId>\n"+
				"<InitiateFromActivityName>"+activityname+"</InitiateFromActivityName>\n"+
				"</WFUploadWorkItem_Input>";

	}
	public static void updateRecordData(String refNo, String id,String createWIStatus, String wiName,String sRetryCount,String createWIRemarks)
	{
		int iRetryCount =0;
		try
		{
			iRetryCount = Integer.parseInt(sRetryCount);
			iRetryCount++;
		}
		catch(Exception e)
		{
			iRetryCount=1;
		}
		String colName="";
		String values="";
		if(wiName.contains("process")) {
		colName="CREATE_WORKITEM_STATUS,WI_NAME,PROCESSED_DATE,RETRY,CREATE_WI_REMARKS";
		values="'"+createWIStatus+"','"+wiName+"','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+iRetryCount+"','"+createWIRemarks+"'";
		}
		else
		{
			colName="CREATE_WORKITEM_STATUS,PROCESSED_DATE,RETRY,CREATE_WI_REMARKS";
			values="'"+createWIStatus+"','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+iRetryCount+"','"+createWIRemarks+"'";
		}
		
		String where = UniqueParameter+" ='"+refNo+"' AND ID='"+id+"' ";
		try
		{
			ExecuteQuery_APUpdate(efmsTablename,colName,values,where);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Exception in updateRecordData "+e);
		}
		return;
	}
	private static void ExecuteQuery_APUpdate(String tablename, String columnname,String sMessage, String sWhere) throws ParserConfigurationException, SAXException, IOException
	{
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				XMLParser objXMLParser = new XMLParser();
				String inputXmlcheckAPUpdate =ExecuteQuery_APUpdate(tablename,columnname,sMessage,sWhere,cabinetName,sessionID);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=WFNGExecute(inputXmlcheckAPUpdate, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);//CommonMethods.WFNGExecute(inputXmlcheckAPUpdate,jtsIP, jtsPort, 1);//ThreadConnect.WFNGExecutePD(inputXmlcheckAPUpdate,jtsIP,Integer.parseInt(jtsPort),1);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception in ExecuteQuery_APUpdate updating the table");
				}
				else
				{
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Successfully updated table");
					
				}
				int mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sessionID=CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);
				}
				else
				{
					sessionCheckInt++;
					break;
				}
			}
			catch(Exception e)
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Inside create ExecuteQuery_APUpdate exception"+e);
			}
		}
	}
	public static String ExecuteQuery_APUpdate(String tableName,String columnName,String strValues,String sWhere,String cabinetName,String sessionId)
	{
		
		System.out.println("inside ExecuteQuery_APUpdate");
		WFInputXml wfInputXml = new WFInputXml();
		if(strValues==null)
		{
			strValues = "''";
		}
		wfInputXml.appendStartCallName("APUpdate", "Input");
		wfInputXml.appendTagAndValue("TableName",tableName);
		wfInputXml.appendTagAndValue("ColName",columnName);
		wfInputXml.appendTagAndValue("Values",strValues);
		wfInputXml.appendTagAndValue("WhereClause",sWhere);
		wfInputXml.appendTagAndValue("EngineName",cabinetName);
		wfInputXml.appendTagAndValue("SessionId",sessionId);
		wfInputXml.appendEndCallName("APUpdate","Input");
		System.out.println("wfInputXml.toString()-------"+wfInputXml.toString());
		return wfInputXml.toString();
	}
	
	
	public static String ExecuteQuery_APDelete(String tableName, String sWhere, String sSessionId, String sCabName) 
	{
		String sInputXML = "<?xml version=\"1.0\"?>"
			+ "<APDelete_Input><Option>APDelete</Option>"
			+ "<TableName>" + tableName + "</TableName>"
			+ "<WhereClause>" + sWhere + "</WhereClause>"
			+ "<EngineName>" + sCabName + "</EngineName>"
			+ "<SessionId>" + sSessionId + "</SessionId>"
			+ "</APDelete_Input>";

		return sInputXML;
	}
	
	public static String TableInsert(String ColumnValues, String dateInInputFile)throws Exception
	{
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("inside TableInsert ColumnValues  :"+ColumnValues);
	    XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String mainCodeforAPInsert="";
		sessionCheckInt=0;
		String insertStatus = "";
		String ColumnValues1="";
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("sessionCheckInt : "+sessionCheckInt+" loopCount :"+loopCount);
		while(sessionCheckInt<loopCount)
		{
			try
			{
				if(ColumnValues!=null)
				{
					//String report_table=EFMSTabelName;//need to be changed

					// Start - Getting Existing PO Details from table added on 06042020	
					String [] rowData = ColumnValues.split("~");	
					String uniquefieldIndex=CreateWIFromTextFileConfigParamMap.get("UNIQUEFIELDINDEX");
					String uniqueFieldValue="";
					if(uniquefieldIndex!=null && !uniquefieldIndex.equalsIgnoreCase(""))
					{
						uniqueFieldValue = rowData[Integer.parseInt(uniquefieldIndex)];
						
						String Query1 = "SELECT COUNT(*) AS RECORDCOUNT FROM "+efmsTablename+" with(nolock) WHERE "+UniqueParameter+"='"+uniqueFieldValue+"' and TIMESTAMP_IN_FILE='"+dateInInputFile+"'";
						String InputXMLTemp = CommonMethods.apSelectWithColumnNames(Query1, cabinetName, sessionID);//threadConnect.sessionId
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Duplicate Check InputXML = "+InputXMLTemp);
						sOutputXML = WFNGExecute(InputXMLTemp, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Duplicate Check OutputXML = "+sOutputXML);
						objXMLParser.setInputXML(sOutputXML);
						String MaincodeTemp=objXMLParser.getValueOf("MainCode");
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Duplicate Check MainCode = "+MaincodeTemp);
						if(MaincodeTemp.equalsIgnoreCase("0"))
						{
							int iTotalCount= Integer.parseInt(objXMLParser.getValueOf("RECORDCOUNT"));
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Duplicate Check iTotalCount = "+iTotalCount);
							// End - Getting Existing PO Details from table added on 06042020		
							
							if (iTotalCount == 0)
							{
								ColumnValues1=ColumnValues.replace("~", "','");
								
								sInputXML = "<?xml version=\"1.0\"?>" +
										"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>" + efmsTablename + "</TableName>" +
										"<ColName>" + masterColumnNames + "</ColName>" +
										"<Values>" +"'"+ColumnValues1 +"'"+ "</Values>" +
										"<EngineName>" + cabinetName + "</EngineName>" +
										"<SessionId>" + sessionID + "</SessionId>" +  
										"</APInsert_Input>";

								CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("EFMS table InputXml::::::::::\n"+sInputXML);
								sOutputXML=WFNGExecute(sInputXML, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger); //replaced
								CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("EFMS table OutputXml::::::::::\n"+sOutputXML);
								objXMLParser.setInputXML(sOutputXML);
								mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
								CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("EFMS table mainCodeforAPInsert::::::::::\n"+mainCodeforAPInsert);
								if(!mainCodeforAPInsert.equalsIgnoreCase("0"))
								{
									insertStatus = "FAILED"+"~"+ColumnValues1;
								}
								else
								{
									insertStatus = "SUCCESS";
									CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Inserted successfully in EFMS table ::::::::::\n"+mainCodeforAPInsert);
								}
							}
							else 
							{
								CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Record already exists in EFMS table.");
							}	
						}
						else
						{
							CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Error in executing apSelectWithColumnNames.");
							insertStatus = "FAILED"+"~"+ColumnValues1;
						}
						
					
					}
					else
					{
						CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Error in executing apSelectWithColumnNames....As Unique Parameter Index Value is not valid");	
					}
				}
				else
				{
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Error in executing apSelectWithColumnNames....As Input Column Data is Empty or Null");	
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception in inserting in EFMS table", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				//ThreadConnect.sessionId = ThreadConnect.getSessionID(cabinetName, jtsIP, jtsPort, userName,password);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("invalid session in inserting in EFMS table");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);
			//	ThreadConnect.sessionId = ThreadConnect.getSessionID(cabinetName, jtsIP, jtsPort, userName,password);
				continue;
			} 
			else 
			{
				sessionCheckInt++;
				break;
			}
		}
		if(mainCodeforAPInsert.equalsIgnoreCase("0")) 
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("EFMS table Insert Successful");
		}
		else 
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("EFMS table Insert Unsuccessful");
		}
		return insertStatus;
	}

	
	
	
	public static void sendMail(String cabinetName, String sessionId,String failedEvent,String FileName )throws Exception
	{
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String mainCodeforAPInsert=null;
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				String mailSubject = "";
				String MailStr = "";
				
				if ("FILENAME MISMATCH".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "EFMS WI Creation from EFMS_Initiation Failed due to Mismatch in File Name";
					MailStr = "<html><body>Dear BPM Support Team,<br><br>EFMS Workitem Creation for FPU process from EFMS_Initiation has been failed for File "+FileName+" due to mismatch in file name. Kindly verify the file in Error folder.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				} 
				else if ("RECORD COUNT MISMATCH".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "EFMS WI Creation from EFMS_Initiation Failed due to Mismatch in Record Count";
					MailStr = "<html><body>Dear BPM Support Team,<br><br>EFMS Workitem Creation for FPU process from EFMS_Initiation has been failed for File "+FileName+" due to mismatch in record count. Kindly verify the record count in file in Error folder.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				else if ("INSERT FAILURE".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "EFMS WI Creation from EFMS_Initiation Failed due to Data issue in record";
					MailStr = "<html><body>Dear BPM Support Team,<br><br>EFMS Workitem Creation for FPU process from EFMS_Initiation has been failed for File "+FileName+" due to Data issue in record. Kindly check the logs.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				else if ("WI CREATION FAILURE".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "EFMS WI Creation from EFMS_Initiation Failed due to technical issue";
					MailStr = "<html><body>Dear BPM Support Team,<br><br>EFMS Workitem Creation for FPU process from EFMS_Initiation has been failed due to some technical issue for this record:("+FileName+"). Kindly check the logs.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				
				String columnName = "mailFrom,mailTo,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,mailActionType,insertedTime,processDefId,workitemId,activityId,noOfTrials,zipFlag";
				String strValues = "'"+fromMailID+"','"+toMailID+"','"+mailSubject+"','"+MailStr+"','text/html;charset=UTF-8','1','N','TRIGGER','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+ProcessDefID+"','1','"+activityId+"','0','N'";
				
				sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>WFMAILQUEUETABLE</TableName>" +
						"<ColName>" + columnName + "</ColName>" +
						"<Values>" + strValues + "</Values>" +
						"<EngineName>" + cabinetName + "</EngineName>" +
						"<SessionId>" + sessionId + "</SessionId>" +
						"</APInsert_Input>";

				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Mail Insert InputXml::::::::::\n"+sInputXML);
				sOutputXML =WFNGExecute(sInputXML, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);//CommonMethods.WFNGExecute(sInputXML,jtsIP, jtsPort, 0);
			//	sOutputXML= ThreadConnect.WFNGExecutePD(sInputXML,jtsIP,Integer.parseInt(jtsPort),1);
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Mail Insert OutputXml::::::::::\n"+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
			}
			catch(Exception e)
			{
				e.printStackTrace();
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception in Sending mail", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Invalid session in Sending mail");
				sessionCheckInt++;
				//ThreadConnect.sessionId = ThreadConnect.getSessionID(cabinetName, jtsIP, jtsPort, userName,password);
				sessionID=CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}
		if(mainCodeforAPInsert.equalsIgnoreCase("0"))
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("mail Insert Successful");
		}
		else
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("mail Insert Unsuccessful");
		}
	}
	public static void waiteloopExecute(long wtime) 
	{
		try 
		{
			for (int i = 0; i < 10; i++) 
			{
				Thread.yield();
				Thread.sleep(wtime / 10);
			}
		} 
		catch (InterruptedException e) 
		{
		}
	}
	public static String get_timestamp()
	{
		Date present = new Date();
		Format pformatter = new SimpleDateFormat("dd-MM-yyyy-hhmmss");
		TimeStamp=pformatter.format(present);
		return TimeStamp;
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
				//System.out.println("else");
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
	public static String deleteOlderRecordFromRemittanceTable()
	{
		String MaincodeTemp = "";
		
		try {
			String sTableName = efmsTablename;
			String sWhereCondition = "PROCESSED_DATE < (GETDATE()-"+deleteSuccessDataBeforeDays+") and CREATE_WORKITEM_STATUS = 'Y'";
			String InputXMLTemp = ExecuteQuery_APDelete(sTableName,sWhereCondition,sessionID,cabinetName);
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Delete Older Records InputXML = "+InputXMLTemp);
			String OutputXMLTemp=WFNGExecute(InputXMLTemp, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);//CommonMethods.WFNGExecute(InputXMLTemp,jtsIP, jtsPort, 1);//ThreadConnect.WFNGExecutePD(InputXMLTemp,jtsIP,Integer.parseInt(jtsPort),1);
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Delete Older Records OutputXML = "+OutputXMLTemp);
			XMLParser objXMLParser1 = new XMLParser();
			objXMLParser1.setInputXML(OutputXMLTemp);
			MaincodeTemp=objXMLParser1.getValueOf("MainCode");
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Delete Older Records MainCode = "+MaincodeTemp);
		}
		catch(Exception e)
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Inside create ExecuteQuery_APUpdate exception"+e);
		}
		return MaincodeTemp;
	}
	private static void deleteFolder(File file){
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yy");
		for (File subFile : file.listFiles()) 
		{
			boolean isOld = false;
			String strModifiedDate = dateFormat.format(subFile.lastModified());
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("File Name: "+subFile.getName()+", last modified: "+strModifiedDate);
			try {
				Date parsedModifiedDate=new SimpleDateFormat("dd-MMM-yy").parse(strModifiedDate);
				isOld = olderThanDays(parsedModifiedDate, Integer.parseInt(deleteSuccessDataBeforeDays));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			if (isOld)
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Deleting: "+subFile.getName());	
				if(subFile.isDirectory()) 
				{
					try {
						FileUtils.deleteDirectory(subFile);
					} catch (IOException e) {
						e.printStackTrace();
					}
				} else {
					subFile.delete();
				}
			}
		}
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
	private static boolean olderThanDays(Date givenDate, int numDays)
	{   
		final long MILLIS_PER_DAY = 24 * 60 * 60 * 1000;
		long currentMillis = new Date().getTime();
	    long millisInDays = numDays * MILLIS_PER_DAY;
	    boolean result = givenDate.getTime() < (currentMillis - millisInDays);
	    return result;
	}
	public static void historyCaller(String cabinetName, String sessionId,String wiName,String decision )throws Exception
	{
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String mainCodeforAPInsert=null;
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				if(wiName!=null)
				{
					String hist_table=CreateWIFromTextFileConfigParamMap.get("WIHISTORYTABLENAME");//"USR_0_FPU_WIHISTORY";
					String WINAME=wiName;
					String WSNAME=CreateWIFromTextFileConfigParamMap.get("ActivityName");;
					String remarks = "";
					//String lusername="System";

					if(decision.equalsIgnoreCase("Success"))
						remarks="WI Successfully Created by Utility";
					else
						remarks="Error in WI Creation by Utility";

					//userName = userName.trim();

					String colName="WI_NAME,WORKSTEP,DECISION,ENTRY_DATE_TIME,ACTION_DATE_TIME,REMARKS,USER_NAME";
					//String colName="WI_NAME,WORKSTEP,DECISION,REMARKS,USER_NAME";
	                String values="'"+WINAME+"','"+WSNAME+"','Submit','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+remarks+"','System'";
					//String values="'"+WINAME+"','"+WSNAME+"','Submit','"+remarks+"','System'";
	                CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("updated  USR_0_FPU_WIHISTORY for : "+wiName);

					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Values for history : \n"+values);

					sInputXML = CommonMethods.apInsert(cabinetName, sessionId, colName, values, hist_table);
					/*sInputXML = "<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>" + hist_table + "</TableName>" +
							"<ColName>" + colName + "</ColName>" +
							"<Values>" +values +"</Values>" +
							"<EngineName>" + cabinetName + "</EngineName>" +
							"<SessionId>" + sessionID + "</SessionId>" +  
							"</APInsert_Input>";
					"<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>" + hist_table + "</TableName>" +
							"<ColName>" + colName + "</ColName>" +
							"<Values>" + values + "</Values>" +
							"<EngineName>" + cabinetName + "</EngineName>" +
							"<SessionId>" + sessionId + "</SessionId>" +
							"</APInsert_Input>";*/

					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("History_InputXml::::::::::\n"+sInputXML);
					sOutputXML=WFNGExecute(sInputXML, jtsIP, jtsPort, 0 , CreateWIFromTextFileLog.CreateWIFromTextFileLogger);// CommonMethods.WFNGExecute(sInputXML,jtsIP, jtsPort, 0);
					CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("History_OutputXml::::::::::\n"+sOutputXML);
					objXMLParser.setInputXML(sOutputXML);
					mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");

				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.error("Exception in historyCaller of UpdateExpiryDate", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Invalid session in historyCaller of UpdateExpiryDate");
				sessionCheckInt++;
				//ThreadConnect.sessionId = ThreadConnect.getSessionID(cabinetName, jtsIP, jtsPort, userName,password);
				sessionID=CommonConnection.getSessionID(CreateWIFromTextFileLog.CreateWIFromTextFileLogger, false);
				sessionId = sessionID;
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}
		if(mainCodeforAPInsert.equalsIgnoreCase("0"))
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Insert Successful");
		}
		else
		{
			CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Insert Unsuccessful");
		}
	}
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag, Logger ConnectionLogger) throws IOException, Exception
	{
		ConnectionLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientConnection.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			ConnectionLogger.debug("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	public static String parseDate(String sdate)
    {
		CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Creating Attribute tag---Parsing the date--"+sdate);
        try
        {
        	DateFormat informat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
			Date date = informat.parse(sdate);
			System.out.println(date);
			DateFormat outdateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
           String strDate = outdateFormat.format(date);
           System.out.println("Date with short name--  "+strDate);
           CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Creating Attribute tag---Parsing  of date completed with o/p--"+strDate);
           return strDate;
          
        }
        catch(Exception e)
        {
        	System.out.println("Error In Parsing the date --"+e.toString());
        	CreateWIFromTextFileLog.CreateWIFromTextFileLogger.info("Creating Attribute tag---Error In Parsing the date--"+e);
        	return null;
        }
        
    }
}
