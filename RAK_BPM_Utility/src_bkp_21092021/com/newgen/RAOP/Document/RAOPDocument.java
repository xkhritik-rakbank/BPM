/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP Document
File Name				: RAOPDocument.java
Author 					: Nikita Singhal
Date (DD/MM/YYYY)		: 15/06/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.RAOP.Document;

import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.io.IOException;
import java.lang.NumberFormatException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;
import java.util.Properties;
import java.text.DateFormat;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import com.newgen.omni.wf.util.app.NGEjbClient;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.management.StringValueExp;
import javax.xml.parsers.ParserConfigurationException;

import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.wfdesktop.xmlapi.*;

public class RAOPDocument implements Runnable
{
	public static boolean IsUserLoggedIn = false;
	public static boolean srmKeepPolling = true;
	static String lastProcessInstanceId ="";
	static String lastWorkItemId = "";
	private static NGEjbClient ngEjbClientRAOPDocument;
	Runtime mobjRuntime = Runtime.getRuntime();
	private static  String cabinetName;
	private static  String jtsIP;
	private  static String jtsPort;
	private  static String smsPort;
	private  String [] attributeNames;
	private  String queueID;
	private String volumeID;
	private String destFilePath;
	private String ErrorFolder;
	private String ExternalTable="";
	private String MaxNoOfTries;
	public String workItemName="";
	public String InputXML="";
	public String outputXML="";
	int mainCode = 0;
	int TimeIntervalBetweenTrialsInMin=0;
	public String returnCode="";
	public String parentFolderIndex ="";
	public String InputXMLEntryDate;
	public String outputXMLEntryDate;
	public String mainCodeEntryDate;

	public static int loopCount=50;
	public static int updatecount=3;
	public static int sessionCheckInt=0;
	public static int waitLoop=50;
	public static String sessionId;
	Date now=null;

	public static String source=null;
	public static String dest=null;
	public static String TimeStamp="";
	public static String newFilename=null;
	public static String sdate="";
	
	private String MAILFROM = "";
	private String MAILTO = "";
	private String MAILSUBJECT = "";
	private String MAILMESSAGE = "";
	private String processName = "";

	static Map<String, String> raopDocumentCofigParamMap= new HashMap<String, String>();

	private Map <String, String> executeXMLMapMethod = new HashMap<String, String>();

	@Override
	public void run()
	{
		int sleepIntervalInMin=0;


		try
		{
			RAOPDocumentLog.setLogger();
			ngEjbClientRAOPDocument = NGEjbClient.getSharedInstance();

			RAOPDocumentLog.RAOPDocumentLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			RAOPDocumentLog.RAOPDocumentLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				RAOPDocumentLog.RAOPDocumentLogger.error("Could not Read Config Properties [RaopDocument]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			RAOPDocumentLog.RAOPDocumentLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			RAOPDocumentLog.RAOPDocumentLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			RAOPDocumentLog.RAOPDocumentLogger.debug("JTSPORT: " + jtsPort);

			smsPort = CommonConnection.getsSMSPort();
			RAOPDocumentLog.RAOPDocumentLogger.debug("SMSPort: " + smsPort);
			

			sleepIntervalInMin=Integer.parseInt(raopDocumentCofigParamMap.get("SleepIntervalInMin"));
			RAOPDocumentLog.RAOPDocumentLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			attributeNames=raopDocumentCofigParamMap.get("AttributeNames").split(",");
			RAOPDocumentLog.RAOPDocumentLogger.debug("AttributeNames: " + attributeNames);

			ExternalTable=raopDocumentCofigParamMap.get("ExtTableName");
			RAOPDocumentLog.RAOPDocumentLogger.debug("ExternalTable: " + ExternalTable);

			destFilePath=raopDocumentCofigParamMap.get("destFilePath");
			RAOPDocumentLog.RAOPDocumentLogger.debug("destFilePath: " + destFilePath);

			ErrorFolder=raopDocumentCofigParamMap.get("failDestFilePath");
			RAOPDocumentLog.RAOPDocumentLogger.debug("ErrorFolder: " + ErrorFolder);

			volumeID=raopDocumentCofigParamMap.get("VolumeID");
			RAOPDocumentLog.RAOPDocumentLogger.debug("VolumeID: " + volumeID);

			MaxNoOfTries=raopDocumentCofigParamMap.get("MaxNoOfTries");
			RAOPDocumentLog.RAOPDocumentLogger.debug("MaxNoOfTries: " + MaxNoOfTries);

			TimeIntervalBetweenTrialsInMin=Integer.parseInt(raopDocumentCofigParamMap.get("TimeIntervalBetweenTrialsInMin"));
			RAOPDocumentLog.RAOPDocumentLogger.debug("TimeIntervalBetweenTrialsInMin: " + TimeIntervalBetweenTrialsInMin);

			sessionId = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
			if(sessionId.trim().equalsIgnoreCase(""))
			{
				RAOPDocumentLog.RAOPDocumentLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				RAOPDocumentLog.RAOPDocumentLogger.debug("Session ID found: " + sessionId);
				while(true)
				{
					RAOPDocumentLog.setLogger();
					startRAOPDocumentUtility();
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			RAOPDocumentLog.RAOPDocumentLogger.error("Exception Occurred in RAOP Document Thread: "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			RAOPDocumentLog.RAOPDocumentLogger.error("Exception Occurred in PC Thread : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "RAOP_Document_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    raopDocumentCofigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}

	//**********************************************************************************//
//  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                                :           Application Projects
//Project                              :           RAOP
//Created Date                         :           10-06-2019
//Author                               :           Nikita Singhal
//Description                          :           Function to poll the workitems on a specific queue and process
//***********************************************************************************//
	private void startRAOPDocumentUtility()
	{
		RAOPDocumentLog.RAOPDocumentLogger.info("ProcessWI function for RAOP Utility started");

		String sOutputXml="";
		String sMappedInputXml="";
		long lLngFileSize = 0L;
		String lstrDocFileSize = "";
		String decisionToUpdate="";
		String FailedIntegration="";
		String ErrorMessageFrmIntegration="";
		String Integration_error_received="";
		String statusXML="";
		String ErrorMsg="";
		String strfullFileName="";
		String strDocumentName="";
		String strExtension="";
		String DocumentType="";
		String FilePath="";
		boolean catchflag=false;
		int iNoOfTries=0;
		int iMaxNoOfTries=0;

		sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);

		if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
		{
			RAOPDocumentLog.RAOPDocumentLogger.error("Could Not Get Session ID "+sessionId);
			return;
		}

		List<WorkItem> wiList = new ArrayList<WorkItem>();
		try
		{
			queueID = raopDocumentCofigParamMap.get("QueueID");
			RAOPDocumentLog.RAOPDocumentLogger.debug("QueueID: " + queueID);
			wiList = loadWorkItems(queueID,sessionId);
		}
		catch (NumberFormatException e1)
		{
			catchflag=true;
			e1.printStackTrace();
		}
		catch (IOException e1)
		{
			catchflag=true;
			e1.printStackTrace();
		}
		catch (Exception e1)
		{
			catchflag=true;
			e1.printStackTrace();
		}

		if (wiList != null)
		{
			for (WorkItem wi : wiList)
			{
				boolean mandateDocCheck = false;
				boolean addDocForHighRisk = false;
				
				workItemName = wi.getAttribute("WorkItemName");
				parentFolderIndex = wi.getAttribute("ITEMINDEX");
				RAOPDocumentLog.RAOPDocumentLogger.info("The work Item number: " + workItemName);
				RAOPDocumentLog.RAOPDocumentLogger.info("The parentFolder of work Item: " +workItemName+ " issss " +parentFolderIndex);


				FilePath=raopDocumentCofigParamMap.get("filePath");
				RAOPDocumentLog.RAOPDocumentLogger.debug("filePath: " + FilePath);

				File folder = new File(FilePath);  //RAKFolder
				File[] listOfFiles = folder.listFiles();
				RAOPDocumentLog.RAOPDocumentLogger.info("List of all folders are--"+listOfFiles);

				boolean ErrorFlag = true;
				String PreviousStage = wi.getAttribute("PreviousStage");
				String NoOfTries = wi.getAttribute("ATTACHDOCNOOFTRIES");
				String LastAttachTryTime = wi.getAttribute("LAST_ATTACH_TRY_TIME");


				Date CurrentDateTime= new Date();
				DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
				String formattedCurrentDateTime = dateFormat.format(CurrentDateTime);
				RAOPDocumentLog.RAOPDocumentLogger.info("LastAttachTryTime--"+LastAttachTryTime);
				RAOPDocumentLog.RAOPDocumentLogger.info("formattedCurrentDateTime--"+formattedCurrentDateTime);

				int propNoOfTries = Integer.parseInt(MaxNoOfTries) + 1;
				RAOPDocumentLog.RAOPDocumentLogger.info("NoOfTries from exttable - "+NoOfTries);
				
				if (NoOfTries.equalsIgnoreCase("") || NoOfTries == null || NoOfTries == "" || ((PreviousStage.equalsIgnoreCase("Dec_Error_Handling") || PreviousStage.equalsIgnoreCase("Dec_System_WI_Update")) && Integer.parseInt(NoOfTries) == propNoOfTries))
				{
					NoOfTries = "0";
					LastAttachTryTime = "";
				}
				
				long diffMinutes=0;
				if(!(LastAttachTryTime==null || LastAttachTryTime.equalsIgnoreCase("")))
				{
					//Date d1 = null;
					Date d2 = null;

					try
					{
						//d1=dateFormat.parse(formattedCurrentDateTime);
						SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
						SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

						Date LasttrytimeFormat = inputDateformat.parse(LastAttachTryTime);
						String formattedLastTryDatetime=outputDateFormat.format(LasttrytimeFormat);

						d2=dateFormat.parse(formattedLastTryDatetime);
						RAOPDocumentLog.RAOPDocumentLogger.info("d2 ----"+d2);

					}

					catch(Exception e)
					{
						e.printStackTrace();
						catchflag=true;
					}
					RAOPDocumentLog.RAOPDocumentLogger.info("CurrentDateTime.getTime() ----"+CurrentDateTime.getTime());
					RAOPDocumentLog.RAOPDocumentLogger.info("d2.getTime() ----"+d2.getTime());
					long diff = CurrentDateTime.getTime() - d2.getTime();
					diffMinutes = diff / (60 * 1000) % 60;
				}
				else
				{
					diffMinutes = 10000;
				}

				File documentFolder = null;
				iNoOfTries = Integer.parseInt(NoOfTries);
				RAOPDocumentLog.RAOPDocumentLogger.info("work Item number: " + workItemName + " iNoOfTries is: "+iNoOfTries+" ,PreviousStage: "+PreviousStage);
				RAOPDocumentLog.RAOPDocumentLogger.info("No if tries are ----"+iNoOfTries);
				iMaxNoOfTries = Integer.parseInt(MaxNoOfTries);
				RAOPDocumentLog.RAOPDocumentLogger.info("iMaxNoOfTries are ----"+iMaxNoOfTries);
				RAOPDocumentLog.RAOPDocumentLogger.info("diffMinutes are ----"+diffMinutes);
				RAOPDocumentLog.RAOPDocumentLogger.info("TimeIntervalBetweenTrialsInMin are ----"+TimeIntervalBetweenTrialsInMin);

				if (iNoOfTries < iMaxNoOfTries)
				{
					if(diffMinutes>=TimeIntervalBetweenTrialsInMin)
					{
						RAOPDocumentLog.RAOPDocumentLogger.info("Inside if loop 100");
						for (File file : listOfFiles)
						{
							RAOPDocumentLog.RAOPDocumentLogger.info("Inside for loop 101");
							if (file.isDirectory())
							{
								RAOPDocumentLog.RAOPDocumentLogger.info("Inside if loop 102");
								RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" This is a folder : "+file.getName());

								String foldername = file.getName();
								String path = file.getAbsolutePath();

								if(foldername.equalsIgnoreCase(workItemName))
								{
									RAOPDocumentLog.RAOPDocumentLogger.info("Inside 103");
									RAOPDocumentLog.RAOPDocumentLogger.info("Processing Starts for "+workItemName);
									
									// Checking if workitem folder time and execution time is same
									SimpleDateFormat dateFormat1 = new SimpleDateFormat("dd-MMM-yy HH:mm:ss");
									String strModifiedDate = dateFormat1.format(file.lastModified());
									Date d = new Date();
									String strCurrDateTime = dateFormat1.format(d);
									RAOPDocumentLog.RAOPDocumentLogger.info(file.getName()+", last modified: "+strModifiedDate+", strCurrDateTime: "+strCurrDateTime);
									try {
										Date ModifiedDate=dateFormat1.parse(strModifiedDate);
										Date CurrDateTime=dateFormat1.parse(strCurrDateTime);
										long seconds = (CurrDateTime.getTime()-ModifiedDate.getTime())/1000;
										RAOPDocumentLog.RAOPDocumentLogger.info("Diff in Secs: "+seconds);
										if(seconds < 30)
										{
											try {
												Thread.sleep(30000); // sleeping thread for 30 sec when difference between workitem folder and execution time is less than 30 sec
											} catch (InterruptedException e) {
												// TODO Auto-generated catch block
												e.printStackTrace();
											}
										}
									} catch (ParseException e) {
										e.printStackTrace();
									}
									//***********************************************************
									
									documentFolder = new File(path);
									File[] listOfDocument = documentFolder.listFiles();
									for (File listOfDoc : listOfDocument)
									{
										if (listOfDoc.isFile())
										{
											strfullFileName = listOfDoc.getName();

											RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" strfullFileName : "+strfullFileName);

											try {	
												strDocumentName = strfullFileName.substring(0,strfullFileName.lastIndexOf("."));
											} catch (Exception e)
											{
												RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" Exception in getting Document Name : "+e.getMessage());
											}
											
											String DocNameAsProcess = "";
											if (strDocumentName.contains("Emirates_ID_Front"))
												DocNameAsProcess = "Emirates_ID_Front";
											else if (strDocumentName.contains("Emirates_ID_Back"))
												DocNameAsProcess = "Emirates_ID_Back";
											else if (strDocumentName.contains("VISA"))
												DocNameAsProcess = "VISA";
											else if (strDocumentName.contains("Passport_Front"))
												DocNameAsProcess = "Passport_Front";
											else if (strDocumentName.contains("Passport_Back"))
												DocNameAsProcess = "Passport_Back";
											else if (strDocumentName.contains("Signature"))
												DocNameAsProcess = "Signature_1";
											else if (strDocumentName.contains("OECD"))
												DocNameAsProcess = "OECD";
											else if (strDocumentName.contains("CONSENT_FORM") || strDocumentName.contains("Consent_Form"))
												DocNameAsProcess = "Consent_Form";
											else if (strDocumentName.contains("Bank_Statements"))
												DocNameAsProcess = "Bank_Statements";
											else if (strDocumentName.contains("FATCA-CRS"))
												DocNameAsProcess = "FATCA-CRS";
											else if (strDocumentName.contains("FATCA"))
												DocNameAsProcess = "FATCA";
											else if (strDocumentName.contains("KYC_Form"))
												DocNameAsProcess = "KYC_Form";
											else if (strDocumentName.contains("Proof_of_Income"))
												DocNameAsProcess = "Proof_of_Income";
											else if (strDocumentName.contains("Proof_of_Residence"))
												DocNameAsProcess = "Proof_of_Residence";
											else if (strDocumentName.contains("Salary_Certificate_or_Pay_Slip"))
												DocNameAsProcess = "Salary_Certificate_or_Pay_Slip";
											else	
												DocNameAsProcess = "Other";
											
											try {
												strExtension = strfullFileName.substring(strfullFileName.lastIndexOf(".")+1,strfullFileName.length());
											} catch (Exception e)
											{
												RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" Exception in getting Document Extension : "+e.getMessage());
											}
											
											if(strExtension.equalsIgnoreCase("JPG") || strExtension.equalsIgnoreCase("TIF") || strExtension.equalsIgnoreCase("JPEG") || strExtension.equalsIgnoreCase("TIFF"))
											{
												DocumentType = "I";
											}
											else
											{
												DocumentType = "N";
											}

											RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" strDocumentName : "+strDocumentName+" strExtension : "+strExtension);
											String fileExtension= getFileExtension(listOfDoc);

											RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" fileExtension : "+fileExtension);

											/*String[] part = strfullFileName.split("~");

											String DocumentType = part[0];
											String DocumentName = part[1];
											System.out.println("DocumentType "+DocumentType);
											System.out.println("DocumentName "+DocumentName);*/

											//Getting DocName for Addition

											for (int i = 0; i < 3; i++)
											{
												RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" Inside for Loop!");
												//System.out.println("Inside for Loop!");

												JPISIsIndex ISINDEX = new JPISIsIndex();
												JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
												lLngFileSize = listOfDoc.length();
												lstrDocFileSize = Long.toString(lLngFileSize);

												if(lLngFileSize != 0L)
												{
													RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" The Document address is: "+path+System.getProperty("file.separator")+listOfDoc.getName());
													//String docPath=path.concat("/").concat(listOfDoc.getName());
													String docPath=path+System.getProperty("file.separator")+listOfDoc.getName();

													try
													{
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" before CPISDocumentTxn AddDocument MT: ");

														if(smsPort.startsWith("33"))
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
														}
														else
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
														}	

														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" after CPISDocumentTxn AddDocument MT: ");

														String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" sISIndex: "+sISIndex);
														sMappedInputXml = CommonMethods.getNGOAddDocument(parentFolderIndex,DocNameAsProcess,DocumentType,strExtension,sISIndex,lstrDocFileSize,volumeID,cabinetName,sessionId);
														RAOPDocumentLog.RAOPDocumentLogger.debug("workItemName: "+workItemName+" sMappedInputXml "+sMappedInputXml);
														RAOPDocumentLog.RAOPDocumentLogger.debug("Input xml For NGOAddDocument Call: "+sMappedInputXml);

														sOutputXml=WFNGExecute(sMappedInputXml,jtsIP,Integer.parseInt(jtsPort),1);
														sOutputXml=sOutputXml.replace("<Document>","");
														sOutputXml=sOutputXml.replace("</Document>","");
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" Output xml For NGOAddDocument Call: "+sOutputXml);
														RAOPDocumentLog.RAOPDocumentLogger.debug("Output xml For NGOAddDocument Call: "+sOutputXml);
														statusXML = CommonMethods.getTagValues(sOutputXml,"Status");
														ErrorMsg = CommonMethods.getTagValues(sOutputXml,"Error");
														//statusXML ="0";
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" The maincode of the output xml file is " +statusXML);
														//System.out.println("The maincode of the output xml file is " +statusXML);

													}
													catch (NumberFormatException e)
													{
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName1:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (JPISException e)
													{
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName2:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (Exception e)
													{
														RAOPDocumentLog.RAOPDocumentLogger.info("workItemName3:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
												}
												if(statusXML.equalsIgnoreCase("0"))
													i=3;
											}

											//update historytable external table and doneworkitem
											now = new Date();
											Format formatter = new SimpleDateFormat("dd-MMM-yy");
											sdate = formatter.format(now);
											RAOPDocumentLog.RAOPDocumentLogger.info("statusXML maincode is--"+statusXML);
											if("0".equalsIgnoreCase(statusXML))
											{
												RAOPDocumentLog.RAOPDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
												//source = ""+documentFolder+"/"+strfullFileName+"";
												source = ""+documentFolder+System.getProperty("file.separator")+strfullFileName+"";
												//dest = ""+destFilePath+"/"+sdate+"/"+workItemName;
												dest = ""+destFilePath+System.getProperty("file.separator")+sdate+System.getProperty("file.separator")+workItemName;
												TimeStamp=get_timestamp();
												newFilename = Move(dest,source,TimeStamp);
											}
											RAOPDocumentLog.RAOPDocumentLogger.info("catch flag is--"+catchflag);
											if(!("0".equalsIgnoreCase(statusXML)) || catchflag==true)
											{
												RAOPDocumentLog.RAOPDocumentLogger.info("WI Going to the error folder");
												RAOPDocumentLog.RAOPDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
												//source = ""+documentFolder+"/"+strfullFileName+"";
												source = ""+documentFolder+System.getProperty("file.separator")+strfullFileName+"";
												//dest = ""+ErrorFolder+"/"+sdate+"/"+workItemName;
												dest = ""+ErrorFolder+System.getProperty("file.separator")+sdate+System.getProperty("file.separator")+workItemName;
												TimeStamp=get_timestamp();
												newFilename = Move(dest,source,TimeStamp);
												continue;
											}
										}
									}

									try
									{
										//Added by Vaishvi - start
										RAOPDocumentLog.RAOPDocumentLogger.info("Mandate document check with new changes --- start");
										String employmentType = wi.getAttribute("EMPLOYMENT_TYPE");
										String sMandateDocCheck = checkMandateDoc(employmentType);
										String[] strArr = sMandateDocCheck.split("~");

										if("Y".equalsIgnoreCase(strArr[0])){
											RAOPDocumentLog.RAOPDocumentLogger.info("All mandate docs attached : "+strArr[0]);
											mandateDocCheck = true;
											if("true".equalsIgnoreCase(strArr[1])){
												addDocForHighRisk = true;
											}
											else if("false".equalsIgnoreCase(strArr[1])){
												addDocForHighRisk = false;
											}
										}
										else if("N".equalsIgnoreCase(strArr[0])){
											RAOPDocumentLog.RAOPDocumentLogger.info("All mandate docs not attached : "+strArr[0]);
											mandateDocCheck = false;
											if("true".equalsIgnoreCase(strArr[2])){
												addDocForHighRisk = true;
											}
											else if("false".equalsIgnoreCase(strArr[2])){
												addDocForHighRisk = false;
											}
										}
										RAOPDocumentLog.RAOPDocumentLogger.info("boolean mandateDocCheck :: "+mandateDocCheck+" addDocForHighRisk :: "+addDocForHighRisk);

										if("0".equalsIgnoreCase(statusXML) && mandateDocCheck)	//added flag true condn
										{
											//to check if it is a hgh risk case
											/*if("1".equals(isHighRisk)){
												if(addDocForHighRisk)
												{
													RAOPDocumentLog.RAOPDocumentLogger.info("Inside if - all mandate docs attached for High Risk :: "+addDocForHighRisk);
													documentFolder.delete();
													historyCaller(workItemName,true);
													decisionToUpdate="Success";
													FailedIntegration=" ";
													ErrorMessageFrmIntegration=" ";
													Integration_error_received= " ";
												}
												else if(!addDocForHighRisk)
												{
													RAOPDocumentLog.RAOPDocumentLogger.info("Inside else - all mandate docs attached for High Risk :: "+addDocForHighRisk);
													decisionToUpdate = "RiskDocNotAttach";
													if("N".equals(strArr[0]))
														remarks = strArr[1];
													else if("NA".equalsIgnoreCase(strArr[0])){
														decisionToUpdate="Failure";
														FailedIntegration="NGOAddDocument";
													}
													RAOPDocumentLog.RAOPDocumentLogger.info(strArr[0]+" , "+strArr[1]);
												}
											}
											else
											{*/
											documentFolder.delete();
											historyCaller(workItemName,true);
											decisionToUpdate="Success";
											FailedIntegration=" ";
											ErrorMessageFrmIntegration=" ";
											Integration_error_received= " ";

											RAOPDocumentLog.RAOPDocumentLogger.info("Current date time is---"+get_timestamp());
											updateExternalTable(ExternalTable,"decision,FAILEDINTEGRATIONCALL,MW_ERRORDESC,INTEGRATION_ERROR_RECEIVED,LAST_ATTACH_TRY_TIME,PREV_WS_DECISION,PREVWS_YAP_STATUS_UPDATE,YAP_Status,remarks,Yap_reject_reason","'" + decisionToUpdate + "','"+FailedIntegration+"','"+ErrorMessageFrmIntegration+"','"+Integration_error_received+"','"+formattedCurrentDateTime+"','','','','',''","ITEMINDEX='"+parentFolderIndex+"'");

											//Call done workitem to move the workitem to next step
											ErrorFlag = false;
											doneWorkItem(workItemName, "");
											//}
										}
										else
										{
											RAOPDocumentLog.RAOPDocumentLogger.info("Inside else, setting errorflag as false");
											documentFolder.delete();
											ErrorFlag = true;
										}
										/*else if(!mandateDocCheck){
											RAOPDocumentLog.RAOPDocumentLogger.info("Inside else - all mandate docs attached "+mandateDocCheck+" , "+strArr.length);
											decisionToUpdate = "MandateDocFail";

											if("N".equals(strArr[0]))
												remarks = strArr[1];
											else if("NA".equalsIgnoreCase(strArr[0])){
												decisionToUpdate="Failure";
												FailedIntegration="NGOAddDocument";
											}
											RAOPDocumentLog.RAOPDocumentLogger.info("End "+remarks);
										}
										// added by Vaishvi - end
										else
										{
											documentFolder.delete();
											historyCaller(workItemName,false);
											decisionToUpdate="Failure";
											FailedIntegration="NGOAddDocument";
											Integration_error_received="Attach_Cust_Doc";
											if(ErrorMsg.trim().equalsIgnoreCase(""))
												ErrorMsg = "Documents are not available";
											ErrorMessageFrmIntegration=ErrorMsg;
										}*/


									}
									catch (Exception e)
									{
										RAOPDocumentLog.RAOPDocumentLogger.info("Exception :: "+e);
										e.printStackTrace();
									}
									
								}
								else
								{
									RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" Folder name doesn't match the workitem name");
								}
							}
							else
							{
								RAOPDocumentLog.RAOPDocumentLogger.info("workItemName: "+workItemName+" It is not a folder"+file.getName());
							}
						}
					}
					else
					{
						continue;
					}
				}
				// updating number tries AttachDocNoOfTries in external table
				try
				{
					if (ErrorFlag)
					{
						String remarks = "";
						String employmentType = wi.getAttribute("EMPLOYMENT_TYPE");
						String sMandateDocCheck = checkMandateDoc(employmentType);

						//String isHighRisk = isRiskExceptionRaised(workItemName) ;
						RAOPDocumentLog.RAOPDocumentLogger.info("sMandateDocCheck 22 :: "+sMandateDocCheck);
						String[] strArr = sMandateDocCheck.split("~");
						List<String> listOfAllDocs = new ArrayList<String>();
						
						
						if("Y".equalsIgnoreCase(strArr[0])){
							RAOPDocumentLog.RAOPDocumentLogger.info("All mandate docs attached 22: "+strArr[0]);
							mandateDocCheck = true;
							if("true".equalsIgnoreCase(strArr[1])){
								addDocForHighRisk = true;
							}
							else if("false".equalsIgnoreCase(strArr[1])){
								addDocForHighRisk = false;
							}
						}
						else if("N".equalsIgnoreCase(strArr[0])){
							RAOPDocumentLog.RAOPDocumentLogger.info("All mandate docs not attached 22: "+strArr[0]);
							mandateDocCheck = false;
							if("true".equalsIgnoreCase(strArr[2])){
								addDocForHighRisk = true;
							}
							else if("false".equalsIgnoreCase(strArr[2])){
								addDocForHighRisk = false;
							}
						}
						RAOPDocumentLog.RAOPDocumentLogger.info("boolean mandateDocCheck 22 :: "+mandateDocCheck+" addDocForHighRisk 22 :: "+addDocForHighRisk);

						
						
						
						// first - if no docs are attached on the workitem -as is
						// second - 2 docs attached - Emirated ID front and back - list of docs from intergration call - execute as is
						// third - Mandate doc not attached - //ErrorMessageFrmIntegration = Mandatory doc not available
						// fourth - Success - all docs including mandatory are attached - same as above

						listOfAllDocs = getAllDocOnWI(workItemName);
						RAOPDocumentLog.RAOPDocumentLogger.info("No of documents on WI- "+workItemName+" :: "+listOfAllDocs.size());
						
						//1. No doc attached
						//2. Only 2 doc attached - Emirates front and back
						if((listOfAllDocs.isEmpty() || listOfAllDocs == null) || 
								((listOfAllDocs.size()) <= 2 && (listOfAllDocs.contains("Emirates_ID_Front") || listOfAllDocs.contains("Emirates_ID_Back") || 
										strArr[0].equalsIgnoreCase("NA"))))
						{
							RAOPDocumentLog.RAOPDocumentLogger.info("Inside case 1 or 2, i.e either no document attached or only 2 docs for Emirates attached. Size of list :: "+listOfAllDocs.size());
							RAOPDocumentLog.RAOPDocumentLogger.info("updating AttachDocNoOfTries");
							decisionToUpdate = "Failure";
							FailedIntegration= "DocNotAvailable";
							ErrorMessageFrmIntegration = "Document Not Available";
							Integration_error_received="Attach_Cust_Doc";
							iNoOfTries++;
							updateExternalTable(ExternalTable,"decision,ATTACHDOCNOOFTRIES,LAST_ATTACH_TRY_TIME,FAILEDINTEGRATIONCALL,MW_ERRORDESC,INTEGRATION_ERROR_RECEIVED","'" + decisionToUpdate + "','"+iNoOfTries+"','"+formattedCurrentDateTime+"','"+FailedIntegration+"','"+ErrorMessageFrmIntegration+"','"+Integration_error_received+"'","ITEMINDEX='"+parentFolderIndex+"'");
							//## Mail trigger - added by Vaishvi - start
							if(iNoOfTries == 4 || iNoOfTries == 8 || iNoOfTries == 12)
								sendMailTrigger(workItemName);
							//## Mail trigger - added by Vaishvi - end
							RAOPDocumentLog.RAOPDocumentLogger.info("Case 1 or 2 - iNoOfTries == "+iNoOfTries+" iMaxNoOfTries == "+iMaxNoOfTries);
							if (iNoOfTries > iMaxNoOfTries)
							{
								historyCaller(workItemName,false);
								doneWorkItem(workItemName, "");
							}
						}
						//3. 
						else if(!mandateDocCheck)
						{
							RAOPDocumentLog.RAOPDocumentLogger.info("Inside case 3, i.e Mandatory documents not attached. All common doc attached :: "+mandateDocCheck+". Additional doc for High risk attached :: "+addDocForHighRisk);
							RAOPDocumentLog.RAOPDocumentLogger.info("decisionToUpdate :: "+decisionToUpdate);
							FailedIntegration= " ";
							ErrorMessageFrmIntegration = "Document Not Available";
							Integration_error_received=" ";
							iNoOfTries++;
							updateExternalTable(ExternalTable,"ATTACHDOCNOOFTRIES,LAST_ATTACH_TRY_TIME,FAILEDINTEGRATIONCALL,MW_ERRORDESC,INTEGRATION_ERROR_RECEIVED","'"+iNoOfTries+"','"+formattedCurrentDateTime+"','"+FailedIntegration+"','"+ErrorMessageFrmIntegration+"','"+Integration_error_received+"'","ITEMINDEX='"+parentFolderIndex+"'");
							//## Mail trigger - added by Vaishvi - start
							if(iNoOfTries == 4 || iNoOfTries == 8 || iNoOfTries == 12)
								sendMailTrigger(workItemName);
							//## Mail trigger - added by Vaishvi - end
							RAOPDocumentLog.RAOPDocumentLogger.info("Case 3 - iNoOfTries == "+iNoOfTries+" iMaxNoOfTries == "+iMaxNoOfTries);
							if (iNoOfTries > iMaxNoOfTries)
							{
								//3.send to status notification- update flag in exttable - update exttable - 'PREVWS_DECISION'=ADDIDTIONAL INFORMATION REQ CUSTOMER/YAP','PREVWS_YAP_STATUS_UPDATE'=Attach_Cust_Doc, remarks,'YAP_Status' = ADDITIONAL_COMPLIANCE_INFO_REQ,'Yap_reject_reason' = (B6059)-Document not available
								RAOPDocumentLog.RAOPDocumentLogger.info("Max no of tries reached, updating exttable with required flags and updating remarks");
								if("N".equals(strArr[0]))
									remarks = strArr[1];
								
								ErrorMessageFrmIntegration = "Mandatory doc not available";
								decisionToUpdate = "MandateDocFail";
								updateExternalTable(ExternalTable,"PREV_WS_DECISION,PREVWS_YAP_STATUS_UPDATE,YAP_Status,remarks,Yap_reject_reason,decision","'Additional Information Required Customer/YAP','Attach_Cust_Doc','ADDITIONAL_COMPLIANCE_INFO_REQ','"+remarks+"','(B6059)-Document not available','" + decisionToUpdate + "'","ITEMINDEX='"+parentFolderIndex+"'");

								historyCaller(workItemName,false);
								doneWorkItem(workItemName, "");
							}
						}
						//4. for success case
						else if(mandateDocCheck)
						{
							RAOPDocumentLog.RAOPDocumentLogger.info("Case 4, i.e, Success case, all mandatory documents attached");
							historyCaller(workItemName,true);
							decisionToUpdate="Success";
							FailedIntegration=" ";
							ErrorMessageFrmIntegration=" ";
							Integration_error_received= " ";

							RAOPDocumentLog.RAOPDocumentLogger.info("Current date time is---"+get_timestamp());
							updateExternalTable(ExternalTable,"decision,FAILEDINTEGRATIONCALL,MW_ERRORDESC,INTEGRATION_ERROR_RECEIVED,LAST_ATTACH_TRY_TIME,PREV_WS_DECISION,PREVWS_YAP_STATUS_UPDATE,YAP_Status,remarks,Yap_reject_reason","'" + decisionToUpdate + "','"+FailedIntegration+"','"+ErrorMessageFrmIntegration+"','"+Integration_error_received+"','"+formattedCurrentDateTime+"','','','','',''","ITEMINDEX='"+parentFolderIndex+"'");

							//Call done workitem to move the workitem to next step
							ErrorFlag = false;
							doneWorkItem(workItemName, "");
						}
					}
					RAOPDocumentLog.RAOPDocumentLogger.info("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
				}
				catch (Exception e)
				{
					RAOPDocumentLog.RAOPDocumentLogger.info("exception in updating AttachDocNoOfTries");
				}
				//****************************************
			}
		}
		RAOPDocumentLog.RAOPDocumentLogger.info("exiting ProcessWI function RAOP Utility");
	}

	private void updateExternalTable(String tablename, String columnname,String sMessage, String sWhere)
	{
		sessionCheckInt=0;

		while(sessionCheckInt<loopCount)
		{
			try
			{
				XMLParser objXMLParser = new XMLParser();
				String inputXmlcheckAPUpdate = CommonMethods.getAPUpdateIpXML(tablename,columnname,sMessage,sWhere,cabinetName,sessionId);
				RAOPDocumentLog.RAOPDocumentLogger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=WFNGExecute(inputXmlcheckAPUpdate,jtsIP,Integer.parseInt(jtsPort),1);
				RAOPDocumentLog.RAOPDocumentLogger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					RAOPDocumentLog.RAOPDocumentLogger.error("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
					System.out.println("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
				}
				else
				{
					RAOPDocumentLog.RAOPDocumentLogger.error("Succesfully updated "+tablename+" table");
					System.out.println("Succesfully updated "+tablename+" table");
					//ThreadConnect.addToTextArea("Successfully updated transaction table");
				}
				mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
				}
				else
				{
					sessionCheckInt++;
					break;
				}

				if (outXmlCheckAPUpdate.equalsIgnoreCase("") || outXmlCheckAPUpdate == "" || outXmlCheckAPUpdate == null)
					break;

			}
			catch(Exception e)
			{
				RAOPDocumentLog.RAOPDocumentLogger.error("Inside create validateSessionID exception"+e);
			}
		}
	}

	//Function to make thread sleep
	public static void waiteloop(long wtime)
	{
        try
		{
            for (int i = 0; i < 10; i++)
			{
                Thread.yield();
                Thread.sleep(wtime / 10);
                if (!srmKeepPolling)
				{
                    break;
                }
            }
        }
		catch (InterruptedException e)
		{
        }
    }




	public static void waiteloopExecute(long wtime) {
		try {
			for (int i = 0; i < 10; i++) {
				Thread.yield();
				Thread.sleep(wtime / 10);
			}
		} catch (InterruptedException e) {
		}
	}



		 private List loadWorkItems(String queueID,String sessionId) throws NumberFormatException, IOException, Exception
		{
			 	RAOPDocumentLog.RAOPDocumentLogger.info("Starting loadWorkitem function for queueID -->"+queueID);
				List workItemList = null;
				String workItemListInputXML="";
				sessionCheckInt=0;
				String workItemListOutputXML="";
				RAOPDocumentLog.RAOPDocumentLogger.info("loopCount aa:" + loopCount);
				RAOPDocumentLog.RAOPDocumentLogger.info("lastWorkItemId aa:" + lastWorkItemId);
				RAOPDocumentLog.RAOPDocumentLogger.info("lastProcessInstanceId aa:" + lastProcessInstanceId);
				while(sessionCheckInt<loopCount)
				{
					RAOPDocumentLog.RAOPDocumentLogger.info("123 cabinet name..."+cabinetName);
					RAOPDocumentLog.RAOPDocumentLogger.info("123 session id is..."+sessionId);
					workItemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID);
					RAOPDocumentLog.RAOPDocumentLogger.info("workItemListInputXML aa:" + workItemListInputXML);
					try
					{
						workItemListOutputXML=WFNGExecute(workItemListInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					}
					catch(Exception e)
					{
						RAOPDocumentLog.RAOPDocumentLogger.error("Exception in Execute : " + e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
						continue;
					}

					RAOPDocumentLog.RAOPDocumentLogger.info("workItemListOutputXML : " + workItemListOutputXML);
					if (CommonMethods.getTagValues(workItemListOutputXML,"MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
					}
					else
					{
						sessionCheckInt++;
						break;
					}
				}

				int i = 0;
				while(i <= 3)
				{
					if (CommonMethods.getMainCode(workItemListOutputXML) == 0)
					{
						i = 4;
						String [] last = new String[2];
						workItemList = new ArrayList();
						List workItems = getWorkItems(sessionId,workItemListOutputXML, last);
						workItemList.addAll(workItems);
						lastProcessInstanceId = "";
						lastWorkItemId = "";
					}
					else
					{
						i++;
						lastProcessInstanceId = "";
						lastWorkItemId = "";
					}
				}
				RAOPDocumentLog.RAOPDocumentLogger.info("Exiting loadWorkitem function for queueID -->"+queueID);
				return workItemList;
			}



		 public static String WFNGExecute(String ipXML, String serverIP,
					int serverPort, int flag) throws IOException, Exception {
			 String jtsPort=""+serverPort;
				if (jtsPort.startsWith("33"))
					return WFCallBroker.execute(ipXML, serverIP, serverPort, flag);
				else
					return ngEjbClientRAOPDocument.makeCall(serverIP, serverPort + "", "WebSphere",
							ipXML);
			}

		 private List getWorkItems(String sessionId, String workItemListOutputXML, String[] last) throws NumberFormatException, Exception
		 {
				// TODO Auto-generated method stub
			 RAOPDocumentLog.RAOPDocumentLogger.info("Starting getWorkitems function ");
				Document doc = CommonMethods.getDocument(workItemListOutputXML);

				NodeList instruments = doc.getElementsByTagName("Instrument");
				List workItems = new ArrayList();

				int length = instruments.getLength();

				for (int i =0; i < length; ++i)
				{
					Node inst = instruments.item(i);
					WorkItem wi = getWI(sessionId, inst);
					workItems.add(wi);
				}
				int size = workItems.size();
				if (size > 0)
				{
					WorkItem item = (WorkItem)workItems.get(size -1);
					last[0] = item.processInstanceId;
					last[1] = item.workItemId;

					RAOPDocumentLog.RAOPDocumentLogger.info("last[0] : "+last[0]);
				}
				RAOPDocumentLog.RAOPDocumentLogger.info("Exiting getWorkitems function");
				return workItems;
			}

		 private String getFileExtension(File file) {
		        String name = file.getName();
		        try {
		            return name.substring(name.lastIndexOf(".") + 1);
		        } catch (Exception e) {
		            return "";
		        }
		    }
		 public static String getAttribute(String fetchAttributeOutputXML, String accountNo) throws ParserConfigurationException, SAXException, IOException {
				Document doc = CommonMethods.getDocument(fetchAttributeOutputXML);
				NodeList nodeList = doc.getElementsByTagName("Attribute");
				int length = nodeList.getLength();
				for (int i = 0; i < length; ++i) {
					Node item = nodeList.item(i);
					String name = CommonMethods.getTagValues(item, "Name");
					if (name.trim().equalsIgnoreCase(accountNo.trim())) {
						return CommonMethods.getTagValues(item, "Value");
					}
				}
				return "";
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

			private void historyCaller(String workItemName, boolean DocAttached)
			{
				RAOPDocumentLog.RAOPDocumentLogger.debug("In History Caller method");

				XMLParser objXMLParser = new XMLParser();
				String sOutputXML=null;
				String mainCodeforAPInsert=null;
				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
				{
					try{

						if(workItemName!=null)
						{
							String hist_table="USR_0_RAOP_WIHISTORY";
							String columns="wi_name,workstep,decision,action_date_time,remarks,user_name,Entry_Date_Time";
							String WINAME=workItemName;
							String WSNAME="Attach_Cust_Doc";
							String remarks="";
							String decision = "";
							if(DocAttached)
							{
								remarks = "Documents Attached by Utility";
								decision= "Success";
							}
							else
							{
								remarks = "Error in Attaching Documents by Utility";
								decision= "Failure";
							}

							String lusername="System";


							/*java.util.Date today = new java.util.Date();
							SimpleDateFormat simpleDate = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
							String actionDateTime = simpleDate.format(today).toString();*/

							SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

							Date actionDateTime= new Date();
							String formattedActionDateTime=outputDateFormat.format(actionDateTime);
							RAOPDocumentLog.RAOPDocumentLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

							String entryDatetime=getEntryDatetimefromDB(workItemName);


							String values = "'" + WINAME +"'" + "," + "'" + WSNAME +"'" + "," + "'" + decision +"'" + ","  + "'"+formattedActionDateTime+"'" + "," + "'" + remarks +"'" + "," +  "'" + lusername + "'" +  "," + "'"+entryDatetime+"'";
							RAOPDocumentLog.RAOPDocumentLogger.debug("Values for history : \n"+values);

							String sInputXMLAPInsert = CommonMethods.apInsert(cabinetName,sessionId,columns,values,hist_table);

							RAOPDocumentLog.RAOPDocumentLogger.info("History_InputXml::::::::::\n"+sInputXMLAPInsert);
							sOutputXML= WFNGExecute(sInputXMLAPInsert,jtsIP,Integer.parseInt(jtsPort),1);
							RAOPDocumentLog.RAOPDocumentLogger.info("History_OutputXml::::::::::\n"+sOutputXML);
							objXMLParser.setInputXML(sOutputXML);
							mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");

						}
					}
					catch(Exception e){
						e.printStackTrace();
						RAOPDocumentLog.RAOPDocumentLogger.error("Exception in historyCaller of UpdateExpiryDate", e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
						continue;

					}
					if (mainCodeforAPInsert.equalsIgnoreCase("11")) {
						sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
					}else{
						sessionCheckInt++;
						break;
					}
				}
				if(mainCodeforAPInsert.equalsIgnoreCase("0")){
					RAOPDocumentLog.RAOPDocumentLogger.info("Insert Successful");
				}
				else{

					RAOPDocumentLog.RAOPDocumentLogger.info("Insert Unsuccessful");
				}
				RAOPDocumentLog.RAOPDocumentLogger.debug("Out History Caller method");
			}

			public String getEntryDatetimefromDB(String workItemName)
			{
				RAOPDocumentLog.RAOPDocumentLogger.info("Start of function getEntryDatetimefromDB ");
				String entryDatetimeAttachCust="";
				String formattedEntryDatetime="";
				String outputXMLEntryDate=null;
				String mainCodeEntryDate=null;

				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
				{
					try {
						XMLParser objXMLParser = new XMLParser();
						String sqlQuery = "select entryat from RB_RAOP_EXTTABLE with(nolock) where WINAME='"+workItemName+"'";
						String InputXMLEntryDate = CommonMethods.apSelectWithColumnNames(sqlQuery,cabinetName, sessionId);
						RAOPDocumentLog.RAOPDocumentLogger.info("Getting getIntegrationErrorDescription from exttable table "+InputXMLEntryDate);
						outputXMLEntryDate = WFNGExecute(InputXMLEntryDate, jtsIP, Integer.parseInt(jtsPort), 1);
						RAOPDocumentLog.RAOPDocumentLogger.info("OutputXML for getting getIntegrationErrorDescription from external table "+outputXMLEntryDate);
						objXMLParser.setInputXML(outputXMLEntryDate);
						mainCodeEntryDate=objXMLParser.getValueOf("MainCode");
						} catch (Exception e) {
							sessionCheckInt++;
							waiteloopExecute(waitLoop);
							continue;
						}
					if (!mainCodeEntryDate.equalsIgnoreCase("0"))
					{
						sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);

					}else{
							sessionCheckInt++;
							break;
						}
				}

				if (mainCodeEntryDate.equalsIgnoreCase("0")) {
					try {
						entryDatetimeAttachCust = CommonMethods.getTagValues(outputXMLEntryDate, "entryat");

						SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
						SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

						Date entryDatetimeFormat = inputDateformat.parse(entryDatetimeAttachCust);
						formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
						RAOPDocumentLog.RAOPDocumentLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

						RAOPDocumentLog.RAOPDocumentLogger.info("newentrydatetime "+ formattedEntryDatetime);
					}catch (Exception e) {
						e.printStackTrace();
					}


				}
			return formattedEntryDatetime;
		}

			private WorkItem getWI(String sessionId, Node inst) throws NumberFormatException, IOException, Exception
			{
				RAOPDocumentLog.RAOPDocumentLogger.info("Starting getWI function");
				WorkItem wi = new WorkItem();
				wi.processInstanceId = CommonMethods.getTagValues(inst, "ProcessInstanceId");
				wi.workItemId = CommonMethods.getTagValues(inst, "WorkItemId");
				String fetchAttributeInputXML="";
				String fetchAttributeOutputXML="";
				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
		        {
					fetchAttributeInputXML = CommonMethods.getFetchWorkItemAttributesXML(cabinetName,sessionId,wi.processInstanceId, wi.workItemId);
					RAOPDocumentLog.RAOPDocumentLogger.info("FetchAttributeInputXMl "+fetchAttributeInputXML);
					fetchAttributeOutputXML=WFNGExecute(fetchAttributeInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("&","&amp;");
					//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("<","&lt;");
					//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll(">","&gt;");
					RAOPDocumentLog.RAOPDocumentLogger.info("fetchAttributeOutputXML "+fetchAttributeOutputXML);
					if (CommonMethods.getTagValues(fetchAttributeOutputXML, "MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);

					} else {
							sessionCheckInt++;
							break;
							}

					if (CommonMethods.getMainCode(fetchAttributeOutputXML) != 0)
					{
						RAOPDocumentLog.RAOPDocumentLogger.debug(" MapXML.getMainCode(fetchAttributeOutputXML) != 0 ");
						//throw new RuntimeException();
					}
				}

				try
				{
					for (int i = 0; i < attributeNames.length; ++i)
					{
						String columnValue = getAttribute(fetchAttributeOutputXML, attributeNames[i]);
						if (columnValue != null)
						{
							if(attributeNames[i].equalsIgnoreCase("ACCOUNT_NO"))
								wi.map.put(attributeNames[i], columnValue.replaceAll("-",""));
							else
								wi.map.put(attributeNames[i], columnValue);
						}
						else
						{
							wi.map.put(attributeNames[i], "");
						}
					}

				}
				catch(Exception e)
				{
					e.printStackTrace();
					RAOPDocumentLog.RAOPDocumentLogger.debug("Inside catch of get wi function with exception.."+e);
				}
				RAOPDocumentLog.RAOPDocumentLogger.info("Exiting getWI function");
				return wi;
			}

			private void doneWorkItem(String wi_name,String values,Boolean... compeletFlag)
			{
				assert compeletFlag.length <= 1;
				sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
				try
				{
					executeXMLMapMethod.clear();
					sessionCheckInt=0;
					while(sessionCheckInt<loopCount)
					{
						executeXMLMapMethod.put("getWorkItemInputXML",CommonMethods.getWorkItemInput(cabinetName,sessionId,wi_name, "1"));
						//System.out.println("getWorkItemInputXML ---: "+executeXMLMapMethod.get("getWorkItemInputXML"));
						try
						{
							executeXMLMapMethod.put("getWorkItemOutputXML",WFNGExecute((String)executeXMLMapMethod.get("getWorkItemInputXML"),jtsIP,Integer.parseInt(jtsPort),1));
						}
						catch(Exception e)
						{
							RAOPDocumentLog.RAOPDocumentLogger.error("Exception in Execute : " + e);
							sessionCheckInt++;
							waiteloopExecute(waitLoop);
							sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);
							continue;
						}

						//System.out.println("getWI call output : "+executeXMLMapMethod.get("getWorkItemOutputXML"));
						sessionCheckInt++;
						if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("getWorkItemOutputXML"),"MainCode").equalsIgnoreCase("11"))
						{
							sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);

						}
						else
						{
							sessionCheckInt++;
							break;
						}
					}
					if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("getWorkItemOutputXML"),"MainCode").equalsIgnoreCase("0"))
					{
						sessionCheckInt=0;
						while(sessionCheckInt<loopCount)
						{
							executeXMLMapMethod.put("inputXml1",CommonMethods.completeWorkItemInput(cabinetName,sessionId,wi_name,Integer.toString(1)));
							RAOPDocumentLog.RAOPDocumentLogger.info("inputXml1 ---: "+executeXMLMapMethod.get("inputXml1"));
							RAOPDocumentLog.RAOPDocumentLogger.debug("Output XML APCOMPLETE "+executeXMLMapMethod.get("inputXml1"));
							try
							{
								executeXMLMapMethod.put("outXml1",WFNGExecute((String)executeXMLMapMethod.get("inputXml1"),jtsIP,Integer.parseInt(jtsPort),1));
							}
							catch(Exception e)
							{
								RAOPDocumentLog.RAOPDocumentLogger.error("Exception in Execute : " + e);
								sessionCheckInt++;
								waiteloopExecute(waitLoop);
								sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);

								continue;
							}

							RAOPDocumentLog.RAOPDocumentLogger.info("outXml1 "+executeXMLMapMethod.get("outXml1"));
							sessionCheckInt++;
							if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode").equalsIgnoreCase("11"))
							{
								sessionId  = CommonConnection.getSessionID(RAOPDocumentLog.RAOPDocumentLogger, false);

							}
							else
							{
								sessionCheckInt++;
								break;
							}
						}
					}
					if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode").equalsIgnoreCase("0"))
					{
						RAOPDocumentLog.RAOPDocumentLogger.info("Completed "+wi_name);
						//if(!decision.equalsIgnoreCase("failure"))
						//decision="Success";
						//createHistory(wi_name,"Book Utility","","Book_Transaction","Submit");
					}
					else
					{
						//decision="failure";
						RAOPDocumentLog.RAOPDocumentLogger.info("Problem in completion of "+wi_name+" ,Maincode :"+CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode"));
					}
				}
				catch(Exception e)
				{
					RAOPDocumentLog.RAOPDocumentLogger.error("Exception in workitem done = " +e);

					final Writer result = new StringWriter();
					final PrintWriter printWriter = new PrintWriter(result);
					e.printStackTrace(printWriter);
					RAOPDocumentLog.RAOPDocumentLogger.error("Exception Occurred in done wi : "+result);
				}
			}

			private boolean sendMailTrigger(String WIName)
			{
				RAOPDocumentLog.RAOPDocumentLogger.info("Inside sendMailTrigger function ");
				MAILFROM=raopDocumentCofigParamMap.get("MailFrom");
				RAOPDocumentLog.RAOPDocumentLogger.debug("MailFrom: " + MAILFROM);

				MAILTO=raopDocumentCofigParamMap.get("MailTo");
				RAOPDocumentLog.RAOPDocumentLogger.debug("MailTo: " + MAILTO);

				MAILSUBJECT=raopDocumentCofigParamMap.get("MailSubject").replace("$workItemNumber$", WIName);
				RAOPDocumentLog.RAOPDocumentLogger.debug("MailSubject: " + MAILSUBJECT);

				MAILMESSAGE=raopDocumentCofigParamMap.get("MailMessage");
				RAOPDocumentLog.RAOPDocumentLogger.debug("MailMessage: " + MAILMESSAGE);

				processName = raopDocumentCofigParamMap.get("ProcessName");
				RAOPDocumentLog.RAOPDocumentLogger.debug("processName: " + processName);

				String mainCodeforAPInsert = "";
				try {

					Date CurrentDateTime= new Date();
					DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
					String formattedCurrentDateTime = dateFormat.format(CurrentDateTime);
					RAOPDocumentLog.RAOPDocumentLogger.info("mailtrigger formattedCurrentDateTime--"+formattedCurrentDateTime);

					
					String MAILCONTENTTYPE = "text/html;charset=UTF-8";
					String MAILPRIORITY = "1";
					String MAILSTATUS = "N";
					String INSERTEDTIME = formattedCurrentDateTime;
					String INSERTEDBY = "CUSTOM";
					String MAILACTIONTYPE = "TRIGGER";
					String NOOFTRIALS = "0";
					String STATUSCOMMENTS = "null";
					

					String PROCESSDEFID = raopDocumentCofigParamMap.get("ProcessDefId");

					String columns = "MAILFROM,MAILTO,MAILSUBJECT,MAILMESSAGE,MAILCONTENTTYPE,MAILPRIORITY,MAILSTATUS,STATUSCOMMENTS,INSERTEDTIME,PROCESSDEFID,NOOFTRIALS,INSERTEDBY,MAILACTIONTYPE";
					String values = "'" + MAILFROM +"'" + "," + "'" + MAILTO +"'" + "," + "'" + MAILSUBJECT +"'" + ","  + "'"+MAILMESSAGE+"'" + "," + "'" + MAILCONTENTTYPE +"'" + "," +  "'" + MAILPRIORITY + "'" +  "," + "'"+MAILSTATUS+"'" +  "," + "'"+STATUSCOMMENTS+"'" +  ",getDate()," + "'"+PROCESSDEFID+"'" +  "," + "'"+NOOFTRIALS+"'" +  "," + "'"+INSERTEDBY+"'" +  "," + "'"+MAILACTIONTYPE+"'";
					String wfMailQueueTable = "WFMAILQUEUETABLE";
					String sOutputXML = "";
					XMLParser objXMLParser = new XMLParser();
					String sInputXMLAPInsert = CommonMethods.apInsert(cabinetName,sessionId,columns,values,wfMailQueueTable);
					RAOPDocumentLog.RAOPDocumentLogger.info("Mail_InputXml::::::::::\n"+sInputXMLAPInsert);
					sOutputXML= WFNGExecute(sInputXMLAPInsert,jtsIP,Integer.parseInt(jtsPort),1);
					RAOPDocumentLog.RAOPDocumentLogger.info("Mail_OutputXml::::::::::\n"+sOutputXML);
					objXMLParser.setInputXML(sOutputXML);
					mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
					RAOPDocumentLog.RAOPDocumentLogger.info("mainCodeforAPInsert for mail :: "+mainCodeforAPInsert);
				} catch (Exception e) {
					RAOPDocumentLog.RAOPDocumentLogger.info("Exception while inserting in wfmailqueuetable :: "+e);
				}

				if("0".equals(mainCodeforAPInsert))
					return true;
				else
					return false;
			}
			
			
			public String checkMandateDoc(String employmentType){

				String response = "";
				List<String> listOfAllDocs = new ArrayList<String>();
				String isRiskRaised = isRiskExceptionRaised(workItemName);

				boolean addDocForHighRisk = false; 
				String docListXML = GetDocumentsList(parentFolderIndex, sessionId, cabinetName,jtsIP,jtsPort);
				if (!docListXML.trim().equalsIgnoreCase("F"))
				{
					XMLParser sXMLParser=new XMLParser(docListXML);
					int noOfDocs=sXMLParser.getNoOfFields("Document");
					RAOPDocumentLog.RAOPDocumentLogger.info("No of docs for "+workItemName+" is "+noOfDocs);
					for(int i=0;i<noOfDocs;i++)
					{
						XMLParser subXMLParser = null;
						String subXML1 = sXMLParser.getNextValueOf("Document");
						subXMLParser = new XMLParser(subXML1);
						String docName = subXMLParser.getValueOf("DocumentName");
						listOfAllDocs.add(docName);
					}
					//}
					XMLParser objXMLParser = new XMLParser();
					String sqlQuery = "";
					sqlQuery = "select distinct (DocType) from USR_0_RAOP_MandatoryDocMapping with(nolock) where applicability = 'Common' and IsActive = 'Y'";
					if("1".equals(isRiskRaised) && ("Salaried".equalsIgnoreCase(employmentType) || "Self employed".equalsIgnoreCase(employmentType) || "A".equalsIgnoreCase(employmentType))){
						sqlQuery = "select distinct (DocType) from USR_0_RAOP_MandatoryDocMapping with(nolock) where applicability IN ('Common','EMP-Salaried') and IsActive = 'Y'";
						addDocForHighRisk = true;
					}
					else if("1".equals(isRiskRaised) && "Other".equalsIgnoreCase(employmentType)){
						sqlQuery = "select distinct (DocType) from USR_0_RAOP_MandatoryDocMapping with(nolock) where applicability IN ('Common','EMP-Other') and IsActive = 'Y'";
						addDocForHighRisk = true;
					}

					String OutputXMLMandateDoc = "";
					String mainCodeMandateDoc = "";
					String remarks = "";
					try {

						String InputXMLMandateDoc = CommonMethods.apSelectWithColumnNames(sqlQuery,cabinetName, sessionId);
						RAOPDocumentLog.RAOPDocumentLogger.info("Getting Mandatory documents from master table "+InputXMLMandateDoc);
						OutputXMLMandateDoc = WFNGExecute(InputXMLMandateDoc, jtsIP, Integer.parseInt(jtsPort), 1);
						RAOPDocumentLog.RAOPDocumentLogger.info("OutputXML for getting Mandatory documents from master table "+OutputXMLMandateDoc);
						objXMLParser.setInputXML(OutputXMLMandateDoc);
						mainCodeMandateDoc=objXMLParser.getValueOf("MainCode");
					} catch (Exception e) {
						RAOPDocumentLog.RAOPDocumentLogger.info("Exception in apselect for getting mandateDoc :: "+e);
					}
					if (mainCodeMandateDoc.equalsIgnoreCase("0")){
						StringBuffer strBuffDoc = new StringBuffer();
						int totalNoOfRecors = objXMLParser.getNoOfFields("Record");
						for(int i =0; i< totalNoOfRecors; i++){
							XMLParser innerXml = null;
							String subXML1 = objXMLParser.getNextValueOf("Record");
							innerXml = new XMLParser(subXML1);
							String docType = innerXml.getValueOf("DocType");
							if(!listOfAllDocs.contains(docType)){
								strBuffDoc.append(docType);
								strBuffDoc.append("; ");
							}
						}
						if(strBuffDoc.toString().isEmpty() || strBuffDoc.toString() == null){
							response = "Y";
						}
						else{
							remarks = "Request to provide following documents - "+strBuffDoc.toString();
							response = "N~"+remarks;
						}
					}
					else{
						response = "NA";
					}
					response = response + "~" +addDocForHighRisk;
				}
				RAOPDocumentLog.RAOPDocumentLogger.info("Final response from Mandate doc function = "+response);
				return response;
			}
			
			public String isRiskExceptionRaised(String wrkItemName){

				String isHighRisk = "";
				String mainCodeforAPSelect = "";
				String sOutputXML = "";
				XMLParser objXMLParser = new XMLParser();
				try {
					String queryString = "SELECT count(*) as count FROM USR_0_RAOP_EXCEPTION_HISTORY with(nolock) WHERE WI_NAME = '"+wrkItemName+"' AND EXCEPTIONS = 'High Risk Score' and Is_raised = 'true'";
					String sInputXMLAPSelect = CommonMethods.apSelectWithColumnNames(queryString, cabinetName, sessionId);
					RAOPDocumentLog.RAOPDocumentLogger.info("HighRiskChk_InputXML :: "+sInputXMLAPSelect);
					sOutputXML= WFNGExecute(sInputXMLAPSelect,jtsIP,Integer.parseInt(jtsPort),1);
					RAOPDocumentLog.RAOPDocumentLogger.info("HighRiskChk_OutputXML :: "+sOutputXML);
					objXMLParser.setInputXML(sOutputXML);
					mainCodeforAPSelect=objXMLParser.getValueOf("MainCode");
					RAOPDocumentLog.RAOPDocumentLogger.info("mainCodeforAPSelect for HighRiskChk :: "+mainCodeforAPSelect);
				 
				} catch (Exception e) {
					RAOPDocumentLog.RAOPDocumentLogger.info("Exception while getting HighRiskQuery :: "+e);
				}
				if("0".equals(mainCodeforAPSelect)){
					isHighRisk = objXMLParser.getValueOf("count");

				}
				return isHighRisk;
			}
			
			private List<String> getAllDocOnWI(String workItemName)
			{
				List<String> listOfAllDocs = new ArrayList<String>();
				String docListXML = GetDocumentsList(parentFolderIndex, sessionId, cabinetName,jtsIP,jtsPort);
				if (!docListXML.trim().equalsIgnoreCase("F"))
				{
					XMLParser sXMLParser=new XMLParser(docListXML);
					int noOfDocs=sXMLParser.getNoOfFields("Document");
					RAOPDocumentLog.RAOPDocumentLogger.info("No of docs for "+workItemName+" is "+noOfDocs);
					for(int i=0;i<noOfDocs;i++)
					{
						XMLParser subXMLParser = null;
						String subXML1 = sXMLParser.getNextValueOf("Document");
						subXMLParser = new XMLParser(subXML1);
						String docName = subXMLParser.getValueOf("DocumentName");
						listOfAllDocs.add(docName);
					}
				}
				return listOfAllDocs;
			}
			public String GetDocumentsList(String itemindex , String sessionId,String cabinetName,String jtsIP,String jtsPort)
			{
				RAOPDocumentLog.RAOPDocumentLogger.info("Inside GetDocumentsList Method ...");
				XMLParser docXmlParser = new XMLParser();
				String mainCode="";
				String response="F";
				String outputXML ="";
				try
				{
					String sInputXML = getDocumentList(itemindex, sessionId, cabinetName);
					RAOPDocumentLog.RAOPDocumentLogger.info(" Inputxml to get document names for "+itemindex+ " "+sInputXML);

					outputXML = WFNGExecute(sInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					RAOPDocumentLog.RAOPDocumentLogger.info(" outputxml to get document names for "+ itemindex+ " "+outputXML);
					docXmlParser.setInputXML(outputXML);
					mainCode = docXmlParser.getValueOf("Status");

					if(mainCode.equals("0"))
					{
						response=outputXML;
					}

				}
				catch (Exception e)
				{
					RAOPDocumentLog.RAOPDocumentLogger.info("Exception occured in GetDocumentsList method : "+e);

					response ="F";
					final Writer result = new StringWriter();
					final PrintWriter printWriter = new PrintWriter(result);
					e.printStackTrace(printWriter);
				}
				return response;

			}

			public String getDocumentList(String folderIndex, String sessionId, String cabinetName)
			{

				//folderIndex="26979";   //only for testing

				String xml = "<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input>" +
						"<Option>NGOGetDocumentListExt</Option>" +
						"<CabinetName>"+cabinetName+"</CabinetName>" +
						"<UserDBId>"+sessionId+"</UserDBId>" +
						"<CurrentDateTime></CurrentDateTime>" +
						"<FolderIndex>"+folderIndex+"</FolderIndex>" +
						"<DocumentIndex></DocumentIndex>" +
						"<PreviousIndex>0</PreviousIndex>" +
						"<LastSortField></LastSortField>" +
						"<StartPos>0</StartPos>" +
						"<NoOfRecordsToFetch>1000</NoOfRecordsToFetch>" +
						"<OrderBy>5</OrderBy><SortOrder>A</SortOrder><DataAlsoFlag>N</DataAlsoFlag>" +
						"<AnnotationFlag>Y</AnnotationFlag><LinkDocFlag>Y</LinkDocFlag>" +
						"<PreviousRefIndex>0</PreviousRefIndex><LastRefField></LastRefField>" +
						"<RefOrderBy>2</RefOrderBy><RefSortOrder>A</RefSortOrder>" +
						"<NoOfReferenceToFetch>1000</NoOfReferenceToFetch>" +
						"<DocumentType>B</DocumentType>" +
						"<RecursiveFlag>N</RecursiveFlag><ThumbnailAlsoFlag>N</ThumbnailAlsoFlag>" +
						"</NGOGetDocumentListExt_Input>";

				return xml;
			}

}


