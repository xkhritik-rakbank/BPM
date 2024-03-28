package com.newgen.SAR.CSVWICreation;

import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;


import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;

import com.amazonaws.services.elasticbeanstalk.model.SystemStatus;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.excp.NGException;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;
import com.newgen.wfdesktop.xmlapi.WFInputXml;
import com.newgen.wfdesktop.xmlapi.WFXmlList;
import com.newgen.wfdesktop.xmlapi.WFXmlResponse;

import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;

public class SARWICreation implements Runnable {

	static Map<String, String> SARWICreationConfigParamMap = new HashMap<String, String>();
	static String sessionID = "";
	static String cabinetName = "";
	static String jtsIP ="";
	static String jtsPort ="";
	static String SMSPort ="";
	static String volumeID ="";
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
	public static String BOMailID="";
	public static String FinanceMailID="";
	public static String ProcessDefID="";
	public static String activityId="";
	public static String activityName= "";
	public static String queueId= "";
	public static String deleteSuccessDataBeforeDays;
	public static String histTable="";
	public static String DocName="";
	
	private static char fieldSep = ((char)21); 
	private static char hashChar =((char)35); 
	private static char recordSep =((char)25);
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
			SARWICreationLog.setLogger();

			int configReadStatus = readConfig();

			SARWICreationLog.SARWICreationLogger.debug("configReadStatus " + configReadStatus);
			if (configReadStatus != 0) 
			{
				SARWICreationLog.SARWICreationLogger.error("Could not Read Config Properties [FPU_CreateWIFromTextFile_Config]");
				return;
			}
			else
			{
				
				ProcessDefID= SARWICreationConfigParamMap.get("ProcessDefID");
			    activityId= SARWICreationConfigParamMap.get("ActivityId");
			    activityName= SARWICreationConfigParamMap.get("ActivityName");
			    queueId= SARWICreationConfigParamMap.get("QueueID");
			    deleteSuccessDataBeforeDays= SARWICreationConfigParamMap.get("DeleteSuccessDataBeforeDays");
			    histTable=SARWICreationConfigParamMap.get("HISTORYTABLENAME");
			    DocName=SARWICreationConfigParamMap.get("DocumentName");
			    fromMailID=SARWICreationConfigParamMap.get("FromMailId");
				toMailID=SARWICreationConfigParamMap.get("ToMailId");
				
			}
			cabinetName = CommonConnection.getCabinetName();
			SARWICreationLog.SARWICreationLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			SARWICreationLog.SARWICreationLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			SARWICreationLog.SARWICreationLogger.debug("JTSPORT: " + jtsPort);

			sleepIntervalInMin = Integer.parseInt(SARWICreationConfigParamMap.get("SleepIntervalInMin"));
			SARWICreationLog.SARWICreationLogger.debug("SleepIntervalInMin: " + sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, false);

			if (sessionID.trim().equalsIgnoreCase(""))
			{
				SARWICreationLog.SARWICreationLogger.debug("Could Not Connect to Server!");
			} 
			else
			{
				SARWICreationLog.SARWICreationLogger.debug("Session ID found: " + sessionID);
				
				while (true) 
				{
					sessionID = CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, false);
					SARWICreationLog.setLogger();
					getBOMailID();
					SARWICreationLog.SARWICreationLogger.debug("Create Work Item from Text File..123.");
					startUtilityCreateWIAttachCSV(cabinetName, sessionID, jtsIP, jtsPort);
					SARWICreationLog.SARWICreationLogger.debug("No More workitems to Process, Sleeping!");
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin * 60 * 1000);
				}
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			SARWICreationLog.SARWICreationLogger.error("Exception Occurred in CreateWIFromTextFie: " + e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			SARWICreationLog.SARWICreationLogger.error("Exception Occurred in CreateWIFromTextFie: " + result);
		}
	}
	private int readConfig() 
	{
		Properties p = null;
		try 
		{
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigFiles"
					+ File.separator + "SAR_CreateWIAttachCSV_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements()) 
			{
				String name = (String) names.nextElement();
				SARWICreationConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1;
		}
		return 0;
	}
	private static void startUtilityCreateWIAttachCSV(String cabinetName, String sessionId, String JtsIp,String JtsPort) 
	{
		SARWICreationLog.SARWICreationLogger.info("Inside startUtilityCreateWIAttachCSV..");
		String readCSVFilesStatus="";
		SARWICreationLog.SARWICreationLogger.info("Before Calling Read CSV files");
		readCSVFilesStatus=readCSVFiles();
		SARWICreationLog.SARWICreationLogger.info("After Calling Read text file with readTextFileStatus  --"+readCSVFilesStatus);
		
	}
	private static String readCSVFiles(){
		SARWICreationLog.SARWICreationLogger.info("Iterating over CSV files...");
	    String FileStatus="FAIL";
	    String inputFolder = SARWICreationConfigParamMap.get("InputFolder");
	    String outputFolder = SARWICreationConfigParamMap.get("OutputFolder");
	    String errorFolder = SARWICreationConfigParamMap.get("ErrorFolder");
	    String tempFolder = SARWICreationConfigParamMap.get("TempFolder");
	    String FailedEvent="";
	 
	    try {
	    	Date now = new Date();
			Format formatter = new SimpleDateFormat("dd-MMM-yy");
			sdate = formatter.format(now);
	    	SARWICreationLog.SARWICreationLogger.info("inputFolder: "+inputFolder);
	    	File inputFolderforFiles = new File(inputFolder);
	    	String outputFolderWithDate = outputFolder+System.getProperty("file.separator")+sdate;
	    	final String errorFolderWithDate = errorFolder+System.getProperty("file.separator")+sdate;
	    	File fileSuccessPath = new File(outputFolder);
			deleteFolder(fileSuccessPath);
	    	File[] files;
	    	if(inputFolderforFiles.exists())
	    	{
	    		String[] tempfiles=inputFolderforFiles.list();
	    		if(tempfiles.length>0)
	    		{
	    			files = inputFolderforFiles.listFiles(new FilenameFilter() {
	    	    		@Override
	    	    		public boolean accept(File dir, String name) {
	    	    			if(name.toLowerCase().endsWith(".csv")){
	    	    				SARWICreationLog.SARWICreationLogger.info("Extension is correct for file--: "+name);
	    						return true;
	    					} else {
	    						try {
	    							TimeStamp=get_timestamp();
	    							newFilename = Move(errorFolderWithDate,dir+File.separator+name,TimeStamp);
									sendMail(cabinetName,sessionID,"INCORRECT FILE FORMAT",name);
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
	    						SARWICreationLog.SARWICreationLogger.info("Extension is incorrect for file--: "+name);
	    						return false;
	    					}
	    				}
	    	    	});
	    		}
	    		else
	    		{
	    			SARWICreationLog.SARWICreationLogger.info("Input Directory is Empty!.. directory location is- "+inputFolder);
	    			return FileStatus;
	    		}
	    	}
	    	else
    		{
    			SARWICreationLog.SARWICreationLogger.info("Input Directory not Exist.. directory location is- "+inputFolder);
    			return FileStatus;
    		}
	    	
	    	
	    	for(File f: files) {
	    		
	    		String CSV_name= f.getName();
	    		String groupName="";
	    		String ReportingTeam="";
	    		String accOwner="";
	    		String DepartMent="";
	    		String attributeTag="";
	    		String WorkItemNumber="";
	    		String CreationDateTime="";
	    		String currFilePath="";
	    		String subMonth="";
	    		long lLngFileSize = 0L;
	    		volumeID=CommonConnection.getsVolumeID();
	    		SMSPort=CommonConnection.getsSMSPort();
	    		FileStatus="FAIL";
	    		
	    		if(!"".equalsIgnoreCase(CSV_name))
	    		{
	    			lLngFileSize=f.length();
	    			String finaltemp = tempFolder+System.getProperty("file.separator")+sdate;
	    			currFilePath=SimplemoveFile(inputFolder,finaltemp,CSV_name);
	    			SARWICreationLog.SARWICreationLogger.info("Temporary location of file-"+currFilePath);
	    			String CSV_name_without_extn = CSV_name.substring(0,CSV_name.lastIndexOf("."));
	    			String paramArr[] = CSV_name_without_extn.split("~");
	    			
	    			if(paramArr.length==3)
	    			{
	    				
	    				String GroupNameReportingTeam=paramArr[0];
	    				accOwner=paramArr[1];
	    				DepartMent=paramArr[2];
	    				
	    				if(GroupNameReportingTeam.contains("_"))
	    				{
	    					String dataMonth=getSubmissionMonth();
	    					groupName=GroupNameReportingTeam.substring(0,GroupNameReportingTeam.indexOf("_"));
	    					ReportingTeam=GroupNameReportingTeam.substring(GroupNameReportingTeam.indexOf("_")+1);
	    					int isCSVNameDataInDB=Check_isCSVNameDataInDB(ReportingTeam,accOwner,DepartMent);
	    					int isCSVRepeated=Check_ForRepeatedCSV(CSV_name_without_extn,dataMonth);
	    					if(isCSVNameDataInDB>0 && isCSVRepeated==0)
	    					{
	    						attributeTag="<q_SAR_Department>"+DepartMent+"</q_SAR_Department>"+
    							"<q_SAR_Acc_Owner>"+accOwner+"</q_SAR_Acc_Owner>"+
    							"<q_SAR_ReportingTeam>"+ReportingTeam+"</q_SAR_ReportingTeam>"+
    							"<Department>"+DepartMent+"</Department>"+
    							"<Account_Owner>"+accOwner+"</Account_Owner>"+
    							"<Reporting_Team>"+ReportingTeam+"</Reporting_Team>"+
    							"<q_SAR_Channel>"+CSV_name_without_extn+"</q_SAR_Channel>"
    							+ "<InitiatedBy>System</InitiatedBy>"
    									+ "<Submission_Month>"+dataMonth+"</Submission_Month>"
    									+ "<Submission_for>ZB</Submission_for>";
	    						String DocumentsTag=AddCSVWithWorkItem(currFilePath,CSV_name,lLngFileSize);
		    					if(!"".equalsIgnoreCase(DocumentsTag))
		    					{
		    						String Status=createSingleWorkItem(ProcessDefID,activityId,activityName,attributeTag,DocumentsTag);
		    						SARWICreationLog.SARWICreationLogger.error("Work Item data received from createSingleWorkItem  -!"+Status);
		    						String statusArr[] = Status.split("~");
			    					if(statusArr.length==4)
			    					{
			    						if("Success".equalsIgnoreCase(statusArr[0]))
			    						{
			    							WorkItemNumber=statusArr[1];
			    							CreationDateTime=statusArr[2];
			    							//String parentFolderIndex=getFolderIndex(WorkItemNumber);
			    							/*Status=UpdateWIHistory(cabinetName,sessionID,WorkItemNumber,"Submit",CreationDateTime);
											if("0".equalsIgnoreCase(Status))*/
			    							Status=AddDataInCSVTable(cabinetName,sessionID,WorkItemNumber,"Submit",CreationDateTime,CSV_name_without_extn,
													groupName,ReportingTeam,accOwner,DepartMent,statusArr[3]);
			    							changeDocumentProperty(WorkItemNumber,CSV_name_without_extn);
											if("0".equalsIgnoreCase(Status))
												FileStatus="Success";
			    							
			    						}
			    						else
			    						{
			    							FailedEvent="WI CREATION FAILURE";
				    						SARWICreationLog.SARWICreationLogger.error("Error in create work item -!"+statusArr[0]);	
			    						}
			    					}
			    					else
			    					{
			    						FailedEvent="WI CREATION FAILURE";
			    						SARWICreationLog.SARWICreationLogger.error("Error in create work item -!"+Arrays.toString(statusArr));
			    					}
		    					}
		    					else
		    					{
		    						FailedEvent="WI CREATION FAILURE";
		    						SARWICreationLog.SARWICreationLogger.error("Invalid Documnets Tag-!"+DocumentsTag);
		    					}
	    					}
	    					else
	    					{
	    						if(isCSVRepeated>0)
	    						{
	    							FailedEvent="CSVISALREADYFORTHEMONTH";
		    						SARWICreationLog.SARWICreationLogger.error("There is already one item with ths name for this month !"+CSV_name_without_extn);
		    					}
	    						else
	    						{
	    							FailedEvent="INCONSISTENT CSV NAME DATA";
		    						SARWICreationLog.SARWICreationLogger.error("Data Mentioned in CSV file name is invalid !"+CSV_name_without_extn);
		    					}
	    					}
	    					
	    					
	    				}
	    				else
	    				{
	    					FailedEvent="FileNameFormatIncorrect";
	    					SARWICreationLog.SARWICreationLogger.error("Input CSV File Name is not in correct format for the current iteration!"+CSV_name_without_extn);
	    				}
	    			}
	    			else
	    			{
	    				FailedEvent="FileNameFormatIncorrect";
	    				SARWICreationLog.SARWICreationLogger.error("Input CSV File Name is not in correct format for the current iteration!"+CSV_name_without_extn);
	    			}
	    			
	    			
	    		}
	    		else
	    		{
	    			SARWICreationLog.SARWICreationLogger.error("Input File Name is Empty for the current iteration!");
	    		}
	    		
	    		if("FAIL".equalsIgnoreCase(FileStatus))
	    		{
	    			//String inputFolder1 = ""+inputFolder+f.getName()+"";
					TimeStamp=get_timestamp();
					newFilename = Move(errorFolderWithDate,currFilePath,TimeStamp);
					sendMail(cabinetName,sessionID,FailedEvent,CSV_name);
	    		}
	    		else
	    		{
	    			//String inputFolder1 = ""+inputFolder+f.getName()+"";
					TimeStamp=get_timestamp();
					newFilename = Move(outputFolderWithDate,currFilePath,TimeStamp);
	    		}
	    		
	    		}
	    	}
	    	catch(Exception e)
	    	{
	        	
	        	SARWICreationLog.SARWICreationLogger.info("Error in reading CSV files ....With exception."+e.toString());
	        }
	    
		
		return FileStatus;
	}
	public static int  Check_isCSVNameDataInDB(String ReportingTeam,String accOwner,String DepartMent)
	{
		try
		{
			XMLParser objxmlParser = new XMLParser();
			String Query = "SELECT * FROM USR_0_SAR_ReconRepHierarchyParam with(nolock) WHERE Reporting_Team='"+ReportingTeam.replace("'", "''")+"' and Ac_Owner='"+accOwner.replace("'", "''")+"' and Department='"+DepartMent.replace("'", "''")+"' and (Is_Active='Y' or Is_Active='Yes')";
			SARWICreationLog.SARWICreationLogger.info("Query to check is CSV name contain valid data:- "+Query);
			String InputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
			SARWICreationLog.SARWICreationLogger.info("Getting data from USR_0_SAR_ReconRepHierarchyParam table InputXML = "+InputXML);
			String OutputXML=WFNGExecute(InputXML, jtsIP, jtsPort, 0 );
			SARWICreationLog.SARWICreationLogger.info("Getting data from USR_0_SAR_ReconRepHierarchyParam table OutputXML = "+OutputXML);
			objxmlParser.setInputXML(OutputXML);
			String mainCode=objxmlParser.getValueOf("MainCode");
			if("0".equalsIgnoreCase(mainCode) && OutputXML.contains("TotalRetrieved") )
			{
				int noOfrecords=Integer.parseInt(objxmlParser.getValueOf("TotalRetrieved"));
				return noOfrecords;
				
			}
				
		}
		catch(Exception e)
		{
			SARWICreationLog.SARWICreationLogger.info("Error in checking CSV name data in DB table ....With exception."+e.toString());
		}
		return -1;
	}
	public static int  Check_ForRepeatedCSV(String csvName,String dataMonth)
	{
		try
		{
			XMLParser objxmlParser = new XMLParser();
			String Query = "select * from USR_0_SAR_ReconCSVWorkItem with(nolock) where CSVName='"+csvName+"' and Data_Month='"+dataMonth+"'";
			SARWICreationLog.SARWICreationLogger.info("Query to check is csv is repeated or not:- "+Query);
			String InputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
			SARWICreationLog.SARWICreationLogger.info("Getting data from USR_0_SAR_ReconCSVWorkItem table InputXML = "+InputXML);
			String OutputXML=WFNGExecute(InputXML, jtsIP, jtsPort, 0 );
			SARWICreationLog.SARWICreationLogger.info("Getting data from USR_0_SAR_ReconCSVWorkItem table OutputXML = "+OutputXML);
			objxmlParser.setInputXML(OutputXML);
			String mainCode=objxmlParser.getValueOf("MainCode");
			if("0".equalsIgnoreCase(mainCode) && OutputXML.contains("TotalRetrieved") )
			{
				int noOfrecords=Integer.parseInt(objxmlParser.getValueOf("TotalRetrieved"));
				return noOfrecords;
				
			}
				
		}
		catch(Exception e)
		{
			SARWICreationLog.SARWICreationLogger.info("Error in Check_ForRepeatedCSV ....With exception."+e.toString());
		}
		return -1;
	}
	public static String createSingleWorkItem(String processDefID,String activityID,String activityNAME,String attributeTag,String DocumentsTag) throws NumberFormatException, Exception
	{
		String strResult="";
		SARWICreationLog.SARWICreationLogger.info("inside createSingleWorkItem");
		XMLParser objXMLParser = new XMLParser();
		String WIUploadInputXML=null;
		String WIUploadOutputXML = null;
		String mainCodeforWIUpload=null;

		String workItemName = "";
		String createWIRemarks = "";
		String createdDateTime="";
		
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				SARWICreationLog.SARWICreationLogger.info("attributetag 001");
				WIUploadInputXML = getWIUploadInputXML(cabinetName,sessionID,processDefID,activityID,activityNAME,attributeTag,DocumentsTag);
				SARWICreationLog.SARWICreationLogger.info("WIUploadInputXML:::::::::::: "+WIUploadInputXML);
				WIUploadOutputXML =WFNGExecute(WIUploadInputXML, jtsIP, jtsPort, 0 );
				SARWICreationLog.SARWICreationLogger.info("WIUploadOutputXML:::::::::::: "+WIUploadOutputXML);
				objXMLParser.setInputXML(WIUploadOutputXML);
				mainCodeforWIUpload=objXMLParser.getValueOf("MainCode");
				workItemName=objXMLParser.getValueOf("ProcessInstanceId");
				createWIRemarks=objXMLParser.getValueOf("Subject");
				createdDateTime=objXMLParser.getValueOf("CreationDateTime");

			}
			catch(Exception e)
			{
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				SARWICreationLog.SARWICreationLogger.error("Error in createSingleWorkItem :", e);
				continue;
			}
			if (mainCodeforWIUpload.equalsIgnoreCase("11"))
			{
				SARWICreationLog.SARWICreationLogger.info("invalid session createSingleWorkItem");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}

		String decision="";
		if (!mainCodeforWIUpload.equalsIgnoreCase("0"))
		{
			decision="failure";
			SARWICreationLog.SARWICreationLogger.error("Exception in Creating Workitem");
			createWIRemarks = "WFUpload Call Failure: "+createWIRemarks;
		}
		else
		{
			decision="Success";
			createWIRemarks="WorkItem created successfully!";
			SARWICreationLog.SARWICreationLogger.info("Workitem "+workItemName+" created Succesfully.");
			System.out.println("Workitem "+workItemName+" created Succesfully.");
		}
		SARWICreationLog.SARWICreationLogger.info("decision "+decision);
		SARWICreationLog.SARWICreationLogger.info("Workitem "+workItemName);
		SARWICreationLog.SARWICreationLogger.info("createdDateTime "+createdDateTime);
		SARWICreationLog.SARWICreationLogger.info("createWIRemarks "+createWIRemarks);
		strResult=decision+"~"+workItemName+"~"+createdDateTime+"~"+createWIRemarks;

		return strResult;
	}
	public static String getFolderIndex(String WINo)
	{
		String parentFolderIndex="";
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String RecordCount="";
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				String query="SELECT FolderIndex FROM pdbfolder WITH(nolock) WHERE name='"+WINo+"'";
				sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
				SARWICreationLog.SARWICreationLogger.info("Get FolderIndex InputXML = "+sInputXML);
				sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
				SARWICreationLog.SARWICreationLogger.info("Get FolderIndex OutputXML = "+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				String MaincodeTemp=objXMLParser.getValueOf("MainCode");
				SARWICreationLog.SARWICreationLogger.info("Get FolderIndex MainCode = "+MaincodeTemp);
				RecordCount=objXMLParser.getValueOf("TotalRetrieved");
				if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
					parentFolderIndex=objXMLParser.getValueOf("FolderIndex");
				
				if (MaincodeTemp.equalsIgnoreCase("11")) 
				{
					SARWICreationLog.SARWICreationLogger.info("Invalid session in getFolderIndex");
					sessionCheckInt++;
					sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
					continue;
				}
				else
				{
					sessionCheckInt++;
					break;
				}
			}
			catch(Exception e)
			{
				SARWICreationLog.SARWICreationLogger.error("Exception in getFolderIndex...");
			}
			
		}
		
		return parentFolderIndex;
	}
	private void getBOMailID()
	{
		
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String RecordCount="";
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				String query="select usertype,emails from usr_0_sar_verifier_email_master with(nolock)";
				sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
				SARWICreationLog.SARWICreationLogger.info("Get email of BO and Finance inputXMl = "+sInputXML);
				sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
				SARWICreationLog.SARWICreationLogger.info("Get email of BO and Finance OpXMl = "+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				String MaincodeTemp=objXMLParser.getValueOf("MainCode");
				SARWICreationLog.SARWICreationLogger.info("Get email of BO and Finance MainCode = "+MaincodeTemp);
				RecordCount=objXMLParser.getValueOf("TotalRetrieved");
				if("0".equalsIgnoreCase(MaincodeTemp) && RecordCount!=null && !"".equalsIgnoreCase(RecordCount) && Integer.parseInt(RecordCount)>0)
				{
					for(int i=0;i<Integer.parseInt(RecordCount);i++)
					{
						String xmlDataofRecord = objXMLParser.getNextValueOf("Record");
						xmlDataofRecord = xmlDataofRecord.replaceAll("[ ]+>", ">").replaceAll("<[ ]+", "<");
						XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataofRecord);
						String userType = xmlParserExtTabDataRecord.getValueOf("usertype");
						if("BO".equalsIgnoreCase(userType))
							BOMailID=xmlParserExtTabDataRecord.getValueOf("emails");
						if("Finance".equalsIgnoreCase(userType))
							FinanceMailID=xmlParserExtTabDataRecord.getValueOf("emails");
					}
				}
				if (MaincodeTemp.equalsIgnoreCase("11")) 
				{
					SARWICreationLog.SARWICreationLogger.info("Invalid session in getEmail Id");
					sessionCheckInt++;
					sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
					continue;
				}
				else
				{
					sessionCheckInt++;
					break;
				}
			}
			catch(Exception e)
			{
				SARWICreationLog.SARWICreationLogger.error("Exception in getBOMailID...");
			}
			
		}
	}
	public static String AddCSVWithWorkItem(String path,String strfullFileName,long lLngFileSize )
	{

		SARWICreationLog.SARWICreationLogger.info("Adding CSV in image server-: "+strfullFileName+"");
		JPISIsIndex ISINDEX = new JPISIsIndex();
		JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
		String Documentstag="";
		sessionCheckInt=0;

		if(lLngFileSize != 0L)
		{
			SARWICreationLog.SARWICreationLogger.info(" The Document address is: "+path);
			String docPath=path;
			int nNoOfPages = 1;
			int loopCounter=100;
			
			for(int i =0;i<loopCounter;i++)
			{
				
				try
				{
					SARWICreationLog.SARWICreationLogger.info(" before CPISDocumentTxn AddDocument MT: ");
					SARWICreationLog.SARWICreationLogger.info(" jtsIP: "+jtsIP);
					SARWICreationLog.SARWICreationLogger.info(" jtsPort: "+jtsPort);
					SARWICreationLog.SARWICreationLogger.info(" volumeID: "+volumeID);
					if(SMSPort.startsWith("33"))
					{
						CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(SMSPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
					}
					else
					{
						CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(SMSPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
					}	
	
					SARWICreationLog.SARWICreationLogger.info(" after CPISDocumentTxn AddDocument MT: ");
	
					String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
					if(sISIndex!=null && !"".equalsIgnoreCase(sISIndex))
						Documentstag=DocName+""+fieldSep+""+ISINDEX.m_nDocIndex+hashChar+ISINDEX.m_sVolumeId+fieldSep+nNoOfPages+fieldSep+lLngFileSize+fieldSep+"csv"+recordSep;
					
					SARWICreationLog.SARWICreationLogger.info(" Documentstag-: "+Documentstag);
					break;
					
					
				}
				catch (NumberFormatException e)
				{
					SARWICreationLog.SARWICreationLogger.info("workItemName1:"+e.getMessage());
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					e.printStackTrace();
				}
				catch (JPISException e)
				{
					SARWICreationLog.SARWICreationLogger.info("workItemName2:"+e.getMessage());
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					e.printStackTrace();
				}
				catch (Exception e)
				{
					SARWICreationLog.SARWICreationLogger.info("workItemName3:"+e.getMessage());
					try {
						Thread.sleep(1000);
					} catch (InterruptedException e1) {
						// TODO Auto-generated catch block
						e1.printStackTrace();
					}
					e.printStackTrace();
				}
			}
		}
		else
		{
			SARWICreationLog.SARWICreationLogger.info("Invalid File Size"+lLngFileSize);
		}
	
		return Documentstag;
		
	}
	private static void changeDocumentProperty(String WI_name,String csvName)
	{
		try
		{
			XMLParser objxmlParser = new XMLParser();
			String Query = "select top 1 pdd.DocumentIndex,pdf.FolderIndex from PDBFolder pdf with(nolock), PDBDocumentContent pdc with(nolock), PDBDocument pdd with(nolock) "+
                            "where pdf.FolderIndex = pdc.ParentFolderIndex and pdc.DocumentIndex = pdd.DocumentIndex "+
                            "and pdf.name ='"+WI_name+"' and pdd.Name ='"+DocName+"' order by pdd.CreatedDateTime desc ";
			SARWICreationLog.SARWICreationLogger.info("Query to get document index:- "+Query);
			String InputXML = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
			SARWICreationLog.SARWICreationLogger.info("Getting document index InputXML = "+InputXML);
			String OutputXML=WFNGExecute(InputXML, jtsIP, jtsPort, 0 );
			SARWICreationLog.SARWICreationLogger.info("Getting document index OutputXML = "+OutputXML);
			objxmlParser.setInputXML(OutputXML);
			String mainCode=objxmlParser.getValueOf("MainCode");
			if("0".equalsIgnoreCase(mainCode) && OutputXML.contains("TotalRetrieved") )
			{
				int noOfrecords=Integer.parseInt(objxmlParser.getValueOf("TotalRetrieved"));
				if(noOfrecords>0)
				{
					String docIndex=objxmlParser.getValueOf("DocumentIndex");
					
					String changeDocPropInputXML  = "<?xml version=\"1.0\"?>\n"+
													"<NGOChangeDocumentProperty_Input>\n"+
													"<Option>NGOChangeDocumentProperty</Option>\n"+
													"<CabinetName>"+cabinetName+"</CabinetName>\n"+
													"<UserDBId>"+sessionID+"</UserDBId>\n"+
													"<Document>\n"+
													"<DocumentIndex>"+docIndex+"</DocumentIndex>\n"+
													"<Comment>"+csvName+"</Comment>\n"+
													"</Document>\n"+
													"</NGOChangeDocumentProperty_Input>";
					
					SARWICreationLog.SARWICreationLogger.info("Change doc prop of InputXML = "+changeDocPropInputXML);
					String OutputXMLChangeDocProp=WFNGExecute(changeDocPropInputXML, jtsIP, jtsPort, 0 );
					SARWICreationLog.SARWICreationLogger.info("Change doc prop of OutputXML = "+OutputXMLChangeDocProp);
					XMLParser objxmlParserChangeDocProp = new XMLParser();
					objxmlParserChangeDocProp.setInputXML(OutputXMLChangeDocProp);
					String mainCodeChangeDocProp=objxmlParserChangeDocProp.getValueOf("MainCode");
					
					if("11".equalsIgnoreCase(mainCodeChangeDocProp))
					{
						sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
						changeDocumentProperty(WI_name,csvName);
					}
				}
			}
			else if("11".equalsIgnoreCase(mainCode))
			{
				sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
				changeDocumentProperty(WI_name,csvName);
			}
				
		}
		catch(Exception e)
		{
			SARWICreationLog.SARWICreationLogger.info("Error in changing document property ....With exception."+e.toString());
		}
		
	}
	private static String UpdateWIHistory(String cabinetName,String sessionID,String processInstanceID,String decision,String entryDateTime)
	{
		try
			{
				sessionCheckInt=0;
				
				SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
				Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
				String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
				SARWICreationLog.SARWICreationLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
	
				Date actionDateTime= new Date();
				String formattedActionDateTime=outputDateFormat.format(actionDateTime);
				SARWICreationLog.SARWICreationLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);
	
				//Insert in WIHistory Table.
	
				String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME";
				String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+activityName+"','"
				+CommonConnection.getUsername()+"','"+decision+"','"+formattedEntryDatetime+"'";
				while(sessionCheckInt<loopCount)
				{
					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,histTable);
					SARWICreationLog.SARWICreationLogger.debug("APInsertInputXML: "+apInsertInputXML);
		
					String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,jtsPort,1);
					SARWICreationLog.SARWICreationLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);
		
					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					SARWICreationLog.SARWICreationLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						SARWICreationLog.SARWICreationLogger.debug("ApInsert successful: "+apInsertMaincode);
						SARWICreationLog.SARWICreationLogger.debug("Inserted in WiHistory table successfully.");
						return apInsertMaincode;
					}

					else
					{
						SARWICreationLog.SARWICreationLogger.error("ApInsert failed: "+apInsertMaincode);
					}
					if (apInsertMaincode.equalsIgnoreCase("11")) 
					{
						SARWICreationLog.SARWICreationLogger.info("Invalid session in historyCaller of UpdateExpiryDate");
						sessionCheckInt++;
						sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
						continue;
					}
					else
					{
						sessionCheckInt++;
						break;
					}
					
				}
				
			}

		catch(Exception e)
		{
			SARWICreationLog.SARWICreationLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			SARWICreationLog.SARWICreationLogger.error("Exception Occurred in Updating History  : "+result);
			System.out.println("Exception "+e);
		
		}
		return "";
	}
	private static String AddDataInCSVTable(String cabinetName,String sessionID,String processInstanceID,String decision,String entryDateTime,
			String csvName,String groupName,String repTeam,String accOwner,String depName,String remarks)
	{
		try
			{
				String status="Not Initiated";
				SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
				Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
				String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
				SARWICreationLog.SARWICreationLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
	
				Date actionDateTime= new Date();
				String formattedActionDateTime=outputDateFormat.format(actionDateTime);
				SARWICreationLog.SARWICreationLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);
	
				//Insert in CSV TAble Table.
	
				String columnNames="CSVName,GroupName,ReportingTeam,AccOwner,Department,WI_NAME,CreationDate,Status,StatusDate,REMARKS,Documents_Attached,Data_Month"; 

				String columnValues="'"+csvName.replace("'", "''")+"','"+groupName.replace("'", "''")+"','"+repTeam.replace("'", "''")+"','"+accOwner.replace("'", "''")+"','"+depName.replace("'", "''")+"','"+processInstanceID.replace("'", "''")+"','"+formattedEntryDatetime+"','"+status+"','"
				+formattedActionDateTime+"','"+remarks+"','"+csvName.replace("'", "''")+"','"+getSubmissionMonth()+"'";
				
				while(sessionCheckInt<loopCount)
				{
					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,"USR_0_SAR_ReconCSVWorkItem");
					SARWICreationLog.SARWICreationLogger.debug("APInsertInputXML: "+apInsertInputXML);
		
					String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,jtsPort,1);
					SARWICreationLog.SARWICreationLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);
		
					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					SARWICreationLog.SARWICreationLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						SARWICreationLog.SARWICreationLogger.debug("ApInsert successful: "+apInsertMaincode);
						SARWICreationLog.SARWICreationLogger.debug("Inserted in CSV table successfully.");
						return apInsertMaincode;
					}
					else
					{
						SARWICreationLog.SARWICreationLogger.error("ApInsert failed: "+apInsertMaincode);
					}
					if (apInsertMaincode.equalsIgnoreCase("11")) 
					{
						SARWICreationLog.SARWICreationLogger.info("Invalid session in historyCaller of UpdateExpiryDate");
						sessionCheckInt++;
						sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
						continue;
					}
					else
					{
						sessionCheckInt++;
						break;
					}
					
				}
	
				
			}

		catch(Exception e)
		{
			SARWICreationLog.SARWICreationLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			SARWICreationLog.SARWICreationLogger.error("Exception Occurred in Updating History  : "+result);
			System.out.println("Exception "+e);
		
		}
		return "";
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
				
				if ("INCORRECT FILE FORMAT".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "Suspense Account Automatic WI Creation Failed due to incorrect File Format";
					MailStr = "<html><body>Dear BO Team,<br><br>Auto workitem creation in Suspense Account Recon process has failed for CSV "+FileName+" due to incorrect file extension(it should be ''.csv''). Kindly verify the file in Error folder.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				} 
				else if ("FileNameFormatIncorrect".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "Suspense Account Automatic WI Creation Failed due to invalid name";
					MailStr = "<html><body>Dear BO Team,<br><br>Auto workitem creation in Suspense Account Recon process has failed for CSV "+FileName+" due to invalid file name format. Kindly verify the file in Error folder.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				else if ("WI CREATION FAILURE".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "Suspense Account Automatic WI Creation Failed due to technical issue";
					MailStr = "<html><body>Dear BO Support Team,<br><br>Auto workitem creation in Suspense Account Recon process has failed for CSV "+FileName+" due to some technical issue.Kindly connect with BPM support team.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				else if("INCONSISTENT CSV NAME DATA".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "Suspense Account Automatic WI Creation Failed due to inconsistent Data in name";
					MailStr = "<html><body>Dear BPM Support Team,<br><br>Auto workitem creation in Suspense Account Recon process has failed for CSV "+FileName+" due to inconsistent Data in name of the CSV.Kindly verify the file in Error folder.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				
				else if("CSVISALREADYFORTHEMONTH".equalsIgnoreCase(failedEvent))
				{
					mailSubject = "Suspense Account Automatic WI Creation Failed due to Repeated CSV name in the current month";
					MailStr = "<html><body>Dear BPM Support Team,<br><br>Auto workitem creation in Suspense Account Recon process has failed for CSV "+FileName+" due to Repeated CSV name in the current month.Kindly verify the file in Error folder.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				}
				
				String columnName = "mailFrom,mailTo,mailCC,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,mailActionType,insertedTime,processDefId,workitemId,activityId,noOfTrials,zipFlag";
				String strValues = "'"+fromMailID+"','"+BOMailID+"','"+FinanceMailID+"','"+mailSubject+"','"+MailStr+"','text/html;charset=UTF-8','1','N','TRIGGER','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+ProcessDefID+"','1','"+activityId+"','0','N'";
				
				sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>WFMAILQUEUETABLE</TableName>" +
						"<ColName>" + columnName + "</ColName>" +
						"<Values>" + strValues + "</Values>" +
						"<EngineName>" + cabinetName + "</EngineName>" +
						"<SessionId>" + sessionId + "</SessionId>" +
						"</APInsert_Input>";

				SARWICreationLog.SARWICreationLogger.info("Mail Insert InputXml::::::::::\n"+sInputXML);
				sOutputXML =WFNGExecute(sInputXML, jtsIP, jtsPort, 0);
				SARWICreationLog.SARWICreationLogger.info("Mail Insert OutputXml::::::::::\n"+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
			}
			catch(Exception e)
			{
				e.printStackTrace();
				SARWICreationLog.SARWICreationLogger.error("Exception in Sending mail", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				SARWICreationLog.SARWICreationLogger.info("Invalid session in Sending mail");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(SARWICreationLog.SARWICreationLogger, true);
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
			SARWICreationLog.SARWICreationLogger.info("mail Insert Successful");
		}
		else
		{
			SARWICreationLog.SARWICreationLogger.info("mail Insert Unsuccessful");
		}
	}
	public static String getWIUploadInputXML(String cabinetName,String sessionid, String processdefid,String activityid,String activityname,String attributetag,String DocumentsTag)
	{
		return "<?xml version=\"1.0\"?>\n"+
				"<WFUploadWorkItem_Input>\n"+
				"<Option>WFUploadWorkItem</Option>\n"+
				"<EngineName>"+cabinetName+"</EngineName>\n"+
				"<SessionId>"+sessionid+"</SessionId>\n"+
				"<ProcessDefId>"+processdefid+"</ProcessDefId>\n"+
				"<QueueId>"+queueId+"</QueueId>"+
				"<InitiateAlso>N</InitiateAlso>\n"+
				"<Attributes>"+attributetag+"</Attributes>\n"+
				"<IsWorkItemExtInfo>N</IsWorkItemExtInfo>"+
				"<VariantId>0</VariantId>\r\n" + 
				"<UserDefVarFlag>Y</UserDefVarFlag>\r\n" + 
				"<Documents>"+DocumentsTag+"</Documents>"+
				"<InitiateFromActivityId>"+activityid+"</InitiateFromActivityId>\n"+
				"<InitiateFromActivityName>"+activityname+"</InitiateFromActivityName>\n"+
				"</WFUploadWorkItem_Input>";

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
			SARWICreationLog.SARWICreationLogger.info("Delete Older Records InputXML = "+InputXMLTemp);
			String OutputXMLTemp=WFNGExecute(InputXMLTemp, jtsIP, jtsPort, 0);
			SARWICreationLog.SARWICreationLogger.info("Delete Older Records OutputXML = "+OutputXMLTemp);
			XMLParser objXMLParser1 = new XMLParser();
			objXMLParser1.setInputXML(OutputXMLTemp);
			MaincodeTemp=objXMLParser1.getValueOf("MainCode");
			SARWICreationLog.SARWICreationLogger.info("Delete Older Records MainCode = "+MaincodeTemp);
		}
		catch(Exception e)
		{
			SARWICreationLog.SARWICreationLogger.error("Inside create ExecuteQuery_APUpdate exception"+e);
		}
		return MaincodeTemp;
	}
	private static void deleteFolder(File file){
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yy");
		for (File subFile : file.listFiles()) 
		{
			boolean isOld = false;
			String strModifiedDate = dateFormat.format(subFile.lastModified());
			SARWICreationLog.SARWICreationLogger.info("File Name: "+subFile.getName()+", last modified: "+strModifiedDate);
			try {
				Date parsedModifiedDate=new SimpleDateFormat("dd-MMM-yy").parse(strModifiedDate);
				isOld = olderThanDays(parsedModifiedDate, Integer.parseInt(deleteSuccessDataBeforeDays));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			if (isOld)
			{
				SARWICreationLog.SARWICreationLogger.info("Deleting: "+subFile.getName());	
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
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		SARWICreationLog.SARWICreationLogger.debug("In WF NG Execute : " + serverPort);
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
			SARWICreationLog.SARWICreationLogger.debug("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	public static String parseDate(String sdate)
    {
		SARWICreationLog.SARWICreationLogger.info("Creating Attribute tag---Parsing the date--"+sdate);
        try
        {
        	DateFormat informat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
			Date date = informat.parse(sdate);
			//System.out.println(date);
			DateFormat outdateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
           String strDate = outdateFormat.format(date);
           //System.out.println("Date with short name--  "+strDate);
           SARWICreationLog.SARWICreationLogger.info("Creating Attribute tag---Parsing  of date completed with o/p--"+strDate);
           return strDate;
          
        }
        catch(Exception e)
        {
        	System.out.println("Error In Parsing the date --"+e.toString());
        	SARWICreationLog.SARWICreationLogger.info("Creating Attribute tag---Error In Parsing the date--"+e);
        	return null;
        }
        
    }
	public static String SimplemoveFile(String src, String destinationPath,String file) 
	   {
		
			File objDestFolder = new File(destinationPath);
			if (!objDestFolder.exists())
			{
				objDestFolder.mkdirs();
			}
		 
	       File source = new File(src + file); // "H:\\work-temp\\file"
	       File dest = new File(destinationPath +  File.separator + file); 
	      Path result = null;
	      try 
	      {
	         result = Files.move(Paths.get(source.toString()), Paths.get(dest.toString()));
	      } 
	      catch (IOException e) 
	      {
	    	  SARWICreationLog.SARWICreationLogger.error("Inside CommonFunctions.moveFile--Exception while moving file: -- "+ e.toString());
	    	
	      }
	      if(result != null) 
	      {
	    	  SARWICreationLog.SARWICreationLogger.info("Inside CommonFunctions.moveFile--File moved successfully.");
	    	  return result.toString();
	      }
	      else
	      {
	    	  SARWICreationLog.SARWICreationLogger.info("Inside CommonFunctions.moveFile--File movement failed.");
	    	  return "";
	      }
	   }
	
	private static String getSubmissionMonth()
	{
		String strDate="";
		try
		{
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MONTH, -1);
			String string = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(calendar.getTime());
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);//yyyy-MM-dd'T'HH:mm:ss.SSS'Z'("dd/MMM/yyyy", Locale.ENGLISH);
			Date date = format.parse(string);
			//System.out.println(date);
			DateFormat dateFormat = new SimpleDateFormat("MMM-yy");//("yyyy-M-d");  
            strDate = dateFormat.format(date);
           // System.out.println(strDate);
		}
		catch(Exception e)
		{
			//SARWICreationLog.SARWICreationLogger.info("Error in getSubmissionMonth..."+e.toString());
		}
		return strDate;
	}


}
