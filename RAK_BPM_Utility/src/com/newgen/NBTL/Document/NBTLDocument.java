/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: DAC Document
File Name				: DACDocument.java
Author 					: Nikita Singhal
Date (DD/MM/YYYY)		: 15/06/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.NBTL.Document;

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

import com.newgen.CMP.Document.CMPDocumentLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.wfdesktop.xmlapi.*;

public class NBTLDocument implements Runnable
{
	public static boolean IsUserLoggedIn = false;
	public static boolean srmKeepPolling = true;
	static String lastProcessInstanceId ="";
	static String lastWorkItemId = "";
	private static NGEjbClient ngEjbClientNBTLDocument;
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

	static Map<String, String> NBTLDocumentCofigParamMap= new HashMap<String, String>();

	private Map <String, String> executeXMLMapMethod = new HashMap<String, String>();

	@Override
	public void run()
	{
		int sleepIntervalInMin=0;


		try
		{
			System.out.println("Inside NBTL");
			NBTLDocumentLog.setLogger();
			ngEjbClientNBTLDocument = NGEjbClient.getSharedInstance();

			NBTLDocumentLog.NBTLDocumentLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			NBTLDocumentLog.NBTLDocumentLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				NBTLDocumentLog.NBTLDocumentLogger.error("Could not Read Config Properties [NBTLDocument]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			NBTLDocumentLog.NBTLDocumentLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			NBTLDocumentLog.NBTLDocumentLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			NBTLDocumentLog.NBTLDocumentLogger.debug("JTSPORT: " + jtsPort);

			smsPort = CommonConnection.getsSMSPort();
			NBTLDocumentLog.NBTLDocumentLogger.debug("SMSPort: " + smsPort);
			

			sleepIntervalInMin=Integer.parseInt(NBTLDocumentCofigParamMap.get("SleepIntervalInMin"));
			NBTLDocumentLog.NBTLDocumentLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			attributeNames=NBTLDocumentCofigParamMap.get("AttributeNames").split(",");
			NBTLDocumentLog.NBTLDocumentLogger.debug("AttributeNames: " + attributeNames);

			ExternalTable=NBTLDocumentCofigParamMap.get("ExtTableName");
			NBTLDocumentLog.NBTLDocumentLogger.debug("ExternalTable: " + ExternalTable);

			destFilePath=NBTLDocumentCofigParamMap.get("destFilePath");
			NBTLDocumentLog.NBTLDocumentLogger.debug("destFilePath: " + destFilePath);

			ErrorFolder=NBTLDocumentCofigParamMap.get("failDestFilePath");
			NBTLDocumentLog.NBTLDocumentLogger.debug("ErrorFolder: " + ErrorFolder);

			volumeID=NBTLDocumentCofigParamMap.get("VolumeID");
			NBTLDocumentLog.NBTLDocumentLogger.debug("VolumeID: " + volumeID);

			MaxNoOfTries=NBTLDocumentCofigParamMap.get("MaxNoOfTries");
			NBTLDocumentLog.NBTLDocumentLogger.debug("MaxNoOfTries: " + MaxNoOfTries);

			TimeIntervalBetweenTrialsInMin=Integer.parseInt(NBTLDocumentCofigParamMap.get("TimeIntervalBetweenTrialsInMin"));
			NBTLDocumentLog.NBTLDocumentLogger.debug("TimeIntervalBetweenTrialsInMin: " + TimeIntervalBetweenTrialsInMin);

			sessionId = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
			if(sessionId.trim().equalsIgnoreCase(""))
			{
				NBTLDocumentLog.NBTLDocumentLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				NBTLDocumentLog.NBTLDocumentLogger.debug("Session ID found: " + sessionId);
				while(true)
				{
					NBTLDocumentLog.setLogger();
					startNBTLDocumentUtility();
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			NBTLDocumentLog.NBTLDocumentLogger.error("Exception Occurred in NBTL Document Thread: "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			NBTLDocumentLog.NBTLDocumentLogger.error("Exception Occurred in PC Thread : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "NBTL_Document_Config.properties")));
			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    NBTLDocumentCofigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1 ;
		}
		return 0;
	}

	private void startNBTLDocumentUtility()
	{
		NBTLDocumentLog.NBTLDocumentLogger.info("ProcessWI function for NBTL Utility started");

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

		sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);

		if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
		{
			NBTLDocumentLog.NBTLDocumentLogger.error("Could Not Get Session ID "+sessionId);
			return;
		}

		List<WorkItem> wiList = new ArrayList<WorkItem>();
		try
		{
			queueID = NBTLDocumentCofigParamMap.get("QueueID");
			NBTLDocumentLog.NBTLDocumentLogger.debug("QueueID: " + queueID);
			wiList = loadWorkItems(queueID,sessionId);
			NBTLDocumentLog.NBTLDocumentLogger.info("wiList: " + wiList);
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
				workItemName = wi.getAttribute("WorkItemName");
				parentFolderIndex = wi.getAttribute("ITEMINDEX");
				NBTLDocumentLog.NBTLDocumentLogger.info("The work Item number: " + workItemName);
				NBTLDocumentLog.NBTLDocumentLogger.info("The parentFolder of work Item: " +workItemName+ " issss " +parentFolderIndex);


				FilePath=NBTLDocumentCofigParamMap.get("filePath");
				NBTLDocumentLog.NBTLDocumentLogger.debug("filePath: " + FilePath);

				File folder = new File(FilePath);  //RAKFolder
				File[] listOfFiles = folder.listFiles();	
				NBTLDocumentLog.NBTLDocumentLogger.info("List of all folders are--"+listOfFiles);

				boolean ErrorFlag = true;
				String PreviousStage = wi.getAttribute("PreviousStage");
				String NoOfTries = wi.getAttribute("ATTACHDOCNOOFTRIES");
				String LastAttachTryTime = wi.getAttribute("LAST_ATTACH_TRY_TIME");


				Date CurrentDateTime= new Date();
				DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
				String formattedCurrentDateTime = dateFormat.format(CurrentDateTime);
				NBTLDocumentLog.NBTLDocumentLogger.info("LastAttachTryTime--"+LastAttachTryTime);
				NBTLDocumentLog.NBTLDocumentLogger.info("formattedCurrentDateTime--"+formattedCurrentDateTime);


				if (NoOfTries.equalsIgnoreCase("") || NoOfTries == null || NoOfTries == "" || (PreviousStage.equalsIgnoreCase("Dec_Doc_Error_Hand") && NoOfTries.equalsIgnoreCase(MaxNoOfTries)))
				{
					NBTLDocumentLog.NBTLDocumentLogger.info("inside NoOfTries after printing --");
					NoOfTries = "0";
					LastAttachTryTime = "";
				}
				
				long diffMinutes=0;
				if(!(LastAttachTryTime==null || LastAttachTryTime.equalsIgnoreCase("")))
				{
					//Date d1 = null;
					NBTLDocumentLog.NBTLDocumentLogger.info("inside LastAttachTryTime after printing --");

					Date d2 = null;

					try
					{
						//d1=dateFormat.parse(formattedCurrentDateTime);
						SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
						SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");

						NBTLDocumentLog.NBTLDocumentLogger.info("inside try after printing --");
						Date LasttrytimeFormat = inputDateformat.parse(LastAttachTryTime);
						String formattedLastTryDatetime=outputDateFormat.format(LasttrytimeFormat);

						d2=dateFormat.parse(formattedLastTryDatetime);
						NBTLDocumentLog.NBTLDocumentLogger.info("d2 ----"+d2);

					}

					catch(Exception e)
					{
						e.printStackTrace();
						catchflag=true;
						NBTLDocumentLog.NBTLDocumentLogger.info("inside catch after printing --" + e.getMessage());
					}
					long diff = CurrentDateTime.getTime() - d2.getTime();
					diffMinutes = diff / (60 * 1000) % 60;
				}
				else
				{
					diffMinutes = 10000;
				}

				File documentFolder = null;
				iNoOfTries = Integer.parseInt(NoOfTries);
				NBTLDocumentLog.NBTLDocumentLogger.info("work Item number: " + workItemName + " iNoOfTries is: "+iNoOfTries+" ,PreviousStage: "+PreviousStage);
				NBTLDocumentLog.NBTLDocumentLogger.info("No if tries are ----"+iNoOfTries);
				iMaxNoOfTries = Integer.parseInt(MaxNoOfTries);
				NBTLDocumentLog.NBTLDocumentLogger.info("iMaxNoOfTries ----"+iMaxNoOfTries);
				NBTLDocumentLog.NBTLDocumentLogger.info("diffMinutes ----"+diffMinutes);
				NBTLDocumentLog.NBTLDocumentLogger.info("TimeIntervalBetweenTrialsInMin ----"+TimeIntervalBetweenTrialsInMin);

				if (iNoOfTries < iMaxNoOfTries)
				{
					if(diffMinutes>TimeIntervalBetweenTrialsInMin)
					{
						NBTLDocumentLog.NBTLDocumentLogger.info("Inside if loop 100");
						for (File file : listOfFiles)
						{
							NBTLDocumentLog.NBTLDocumentLogger.info("Inside for loop 101");
							if (file.isDirectory())
							{
								NBTLDocumentLog.NBTLDocumentLogger.info("Inside if loop 102");
								NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" This is a folder : "+file.getName());

								String foldername = file.getName();
								String path = file.getAbsolutePath();

								if(foldername.equalsIgnoreCase(workItemName))
								{
									NBTLDocumentLog.NBTLDocumentLogger.info("Inside 103");
									NBTLDocumentLog.NBTLDocumentLogger.info("Processing Starts for "+workItemName);
									
									// Checking if workitem folder time and execution time is same
									SimpleDateFormat dateFormat1 = new SimpleDateFormat("dd-MMM-yy HH:mm:ss");
									String strModifiedDate = dateFormat1.format(file.lastModified());
									Date d = new Date();
									String strCurrDateTime = dateFormat1.format(d);
									NBTLDocumentLog.NBTLDocumentLogger.info(file.getName()+", last modified: "+strModifiedDate+", strCurrDateTime: "+strCurrDateTime);
									try {
										Date ModifiedDate=dateFormat1.parse(strModifiedDate);
										Date CurrDateTime=dateFormat1.parse(strCurrDateTime);
										long seconds = (CurrDateTime.getTime()-ModifiedDate.getTime())/1000;
										NBTLDocumentLog.NBTLDocumentLogger.info("Diff in Secs: "+seconds);
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

											NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" strfullFileName : "+strfullFileName);

											strDocumentName = strfullFileName.substring(0,strfullFileName.lastIndexOf("."));

											String DocNameAsProcess = "";
										
											if (strDocumentName.contains("New_Trade_License"))
												DocNameAsProcess = "New_Trade_License";
											else if (strDocumentName.contains("MOA"))
												DocNameAsProcess = "MOA";
											
											else	
												DocNameAsProcess = "Other";
											
											strExtension = strfullFileName.substring(strfullFileName.lastIndexOf(".")+1,strfullFileName.length());
											if(strExtension.equalsIgnoreCase("JPG") || strExtension.equalsIgnoreCase("TIF") || strExtension.equalsIgnoreCase("JPEG") || strExtension.equalsIgnoreCase("TIFF") || strExtension.equalsIgnoreCase("PNG"))
											{
												DocumentType = "I";
											}
											else
											{
												DocumentType = "N";
											}

											NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" strDocumentName : "+strDocumentName+" strExtension : "+strExtension);
											String fileExtension= getFileExtension(listOfDoc);

											NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" fileExtension : "+fileExtension);

											/*String[] part = strfullFileName.split("~");

											String DocumentType = part[0];
											String DocumentName = part[1];
											System.out.println("DocumentType "+DocumentType);
											System.out.println("DocumentName "+DocumentName);*/

											//Getting DocName for Addition

											for (int i = 0; i < 3; i++)
											{
												NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" Inside for Loop!");
												//System.out.println("Inside for Loop!");

												JPISIsIndex ISINDEX = new JPISIsIndex();
												JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
												lLngFileSize = listOfDoc.length();
												lstrDocFileSize = Long.toString(lLngFileSize);

												if(lLngFileSize != 0L)
												{
													NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" The Document address is: "+path+System.getProperty("file.separator")+listOfDoc.getName());
													//String docPath=path.concat("/").concat(listOfDoc.getName());
													String docPath=path+System.getProperty("file.separator")+listOfDoc.getName();

													try
													{
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" before CPISDocumentTxn AddDocument MT: ");

														if(smsPort.startsWith("33"))
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
														}
														else
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
														}	

														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" after CPISDocumentTxn AddDocument MT: ");

														String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" sISIndex: "+sISIndex);
														sMappedInputXml = CommonMethods.getNGOAddDocument(parentFolderIndex,DocNameAsProcess,DocumentType,strExtension,sISIndex,lstrDocFileSize,volumeID,cabinetName,sessionId);
														NBTLDocumentLog.NBTLDocumentLogger.debug("workItemName: "+workItemName+" sMappedInputXml "+sMappedInputXml);
														NBTLDocumentLog.NBTLDocumentLogger.debug("Input xml For NGOAddDocument Call: "+sMappedInputXml);

														sOutputXml=WFNGExecute(sMappedInputXml,jtsIP,Integer.parseInt(jtsPort),1);
														sOutputXml=sOutputXml.replace("<Document>","");
														sOutputXml=sOutputXml.replace("</Document>","");
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" Output xml For NGOAddDocument Call: "+sOutputXml);
														NBTLDocumentLog.NBTLDocumentLogger.debug("Output xml For NGOAddDocument Call: "+sOutputXml);
														statusXML = CommonMethods.getTagValues(sOutputXml,"Status");
														ErrorMsg = CommonMethods.getTagValues(sOutputXml,"Error");
														//statusXML ="0";
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" The maincode of the output xml file is " +statusXML);
														//System.out.println("The maincode of the output xml file is " +statusXML);

													}
													catch (NumberFormatException e)
													{
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName1:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (JPISException e)
													{
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName2:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (Exception e)
													{
														NBTLDocumentLog.NBTLDocumentLogger.info("workItemName3:"+e.getMessage());
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
											NBTLDocumentLog.NBTLDocumentLogger.info("statusXML maincode is--"+statusXML);
											if("0".equalsIgnoreCase(statusXML))
											{
												NBTLDocumentLog.NBTLDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
												//source = ""+documentFolder+"/"+strfullFileName+"";
												source = ""+documentFolder+System.getProperty("file.separator")+strfullFileName+"";
												//dest = ""+destFilePath+"/"+sdate+"/"+workItemName;
												dest = ""+destFilePath+System.getProperty("file.separator")+sdate+System.getProperty("file.separator")+workItemName;
												TimeStamp=get_timestamp();
												newFilename = Move(dest,source,TimeStamp);
											}
											NBTLDocumentLog.NBTLDocumentLogger.info("catch flag is--"+catchflag);
											if(!("0".equalsIgnoreCase(statusXML)) || catchflag==true)
											{
												NBTLDocumentLog.NBTLDocumentLogger.info("WI Going to the error folder");
												NBTLDocumentLog.NBTLDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
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
										if("0".equalsIgnoreCase(statusXML))
										{
											documentFolder.delete();
											historyCaller(workItemName,true);
											decisionToUpdate="Success";
											FailedIntegration=" ";
											ErrorMessageFrmIntegration=" ";
											Integration_error_received= " ";
										}
										else
										{
											documentFolder.delete();
											historyCaller(workItemName,false);
											decisionToUpdate="Failure";
											FailedIntegration="NGOAddDocument";
											Integration_error_received="Attach_Online_Document";
											if(ErrorMsg.trim().equalsIgnoreCase(""))
												ErrorMsg = "Documents are not available";
											ErrorMessageFrmIntegration=ErrorMsg;
										}

										NBTLDocumentLog.NBTLDocumentLogger.info("Current date time is---"+get_timestamp());
										updateExternalTable(ExternalTable,"Decision,FAILED_INTEGRATION_CALL,INTEGRATION_ERROR_RECEIVED,LAST_ATTACH_TRY_TIME","'" + decisionToUpdate + "','"+FailedIntegration+"','"+Integration_error_received+"','"+formattedCurrentDateTime+"'","ITEMINDEX='"+parentFolderIndex+"'");
									}
									catch (Exception e)
									{
										e.printStackTrace();
									}
									//Call done workitem to move the workitem to next step
									ErrorFlag = false;
									doneWorkItem(workItemName, "");
								}
								else
								{
									NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" Folder name doesn't match the workitem name");
								}
							}
							else
							{
								NBTLDocumentLog.NBTLDocumentLogger.info("workItemName: "+workItemName+" It is not a folder"+file.getName());
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
						NBTLDocumentLog.NBTLDocumentLogger.info("updating AttachDocNoOfTries");
						decisionToUpdate = "Failure";
						FailedIntegration= "DocNotAvailable";
						ErrorMessageFrmIntegration = "Document Not Available";
						Integration_error_received="Attach_Online_Document";
						iNoOfTries++;
						updateExternalTable(ExternalTable,"Decision,ATTACHDOCNOOFTRIES,LAST_ATTACH_TRY_TIME,INTEGRATION_ERROR_RECEIVED","'" + decisionToUpdate + "','"+iNoOfTries+"','"+formattedCurrentDateTime+"','"+Integration_error_received+"'","ITEMINDEX='"+parentFolderIndex+"'");

						if (iNoOfTries >= iMaxNoOfTries)
						{
							historyCaller(workItemName,false);
							doneWorkItem(workItemName, "");
						}
					}
				}
				catch (Exception e)
				{
					NBTLDocumentLog.NBTLDocumentLogger.info("exception in updating AttachDocNoOfTries");
				}
				//****************************************
			}
		}
		NBTLDocumentLog.NBTLDocumentLogger.info("exiting ProcessWI function NBTL Utility");
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
				NBTLDocumentLog.NBTLDocumentLogger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=WFNGExecute(inputXmlcheckAPUpdate,jtsIP,Integer.parseInt(jtsPort),1);
				NBTLDocumentLog.NBTLDocumentLogger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					NBTLDocumentLog.NBTLDocumentLogger.error("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
					System.out.println("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
				}
				else
				{
					NBTLDocumentLog.NBTLDocumentLogger.error("Succesfully updated "+tablename+" table");
					System.out.println("Succesfully updated "+tablename+" table");
					//ThreadConnect.addToTextArea("Successfully updated transaction table");
				}
				mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
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
				NBTLDocumentLog.NBTLDocumentLogger.error("Inside create validateSessionID exception"+e);
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
			 	NBTLDocumentLog.NBTLDocumentLogger.info("Starting loadWorkitem function for queueID -->"+queueID);
				List workItemList = null;
				String workItemListInputXML="";
				sessionCheckInt=0;
				String workItemListOutputXML="";
				NBTLDocumentLog.NBTLDocumentLogger.info("loopCount aa:" + loopCount);
				NBTLDocumentLog.NBTLDocumentLogger.info("lastWorkItemId aa:" + lastWorkItemId);
				NBTLDocumentLog.NBTLDocumentLogger.info("lastProcessInstanceId aa:" + lastProcessInstanceId);
				while(sessionCheckInt<loopCount)
				{
					NBTLDocumentLog.NBTLDocumentLogger.info("123 cabinet name..."+cabinetName);
					NBTLDocumentLog.NBTLDocumentLogger.info("123 session id is..."+sessionId);
					workItemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID);
					NBTLDocumentLog.NBTLDocumentLogger.info("workItemListInputXML aa:" + workItemListInputXML);
					try
					{
						workItemListOutputXML=WFNGExecute(workItemListInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					}
					catch(Exception e)
					{
						NBTLDocumentLog.NBTLDocumentLogger.error("Exception in Execute : " + e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
						continue;
					}

					NBTLDocumentLog.NBTLDocumentLogger.info("workItemListOutputXML : " + workItemListOutputXML);
					if (CommonMethods.getTagValues(workItemListOutputXML,"MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
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
				NBTLDocumentLog.NBTLDocumentLogger.info("Exiting loadWorkitem function for queueID -->"+queueID);
				return workItemList;
			}



		 public static String WFNGExecute(String ipXML, String serverIP,
					int serverPort, int flag) throws IOException, Exception {
			 String jtsPort=""+serverPort;
				if (jtsPort.startsWith("33"))
					return WFCallBroker.execute(ipXML, serverIP, serverPort, flag);
				else
					return ngEjbClientNBTLDocument.makeCall(serverIP, serverPort + "", "WebSphere",
							ipXML);
			}

		 private List getWorkItems(String sessionId, String workItemListOutputXML, String[] last) throws NumberFormatException, Exception
		 {
				// TODO Auto-generated method stub
			 NBTLDocumentLog.NBTLDocumentLogger.info("Starting getWorkitems function ");
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

					NBTLDocumentLog.NBTLDocumentLogger.info("last[0] : "+last[0]);
				}
				NBTLDocumentLog.NBTLDocumentLogger.info("Exiting getWorkitems function");
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
				NBTLDocumentLog.NBTLDocumentLogger.debug("In History Caller method");

				XMLParser objXMLParser = new XMLParser();
				String sOutputXML=null;
				String mainCodeforAPInsert=null;
				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
				{
					try{

						if(workItemName!=null)
						{
							String hist_table="USR_0_NBTL_WIHISTORY";
							
							String columns="WINAME,WORKSTEP,DECISION,USER_NAME,ACTION_DATE_TIME,REMARKS,ENTRY_DATE_TIME";
							String WI_NAME=workItemName;
							String WSNAME="Attach_Online_Document";
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

							SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

							Date actionDateTime= new Date();
							String formatteNBTLtionDateTime=outputDateFormat.format(actionDateTime);
							NBTLDocumentLog.NBTLDocumentLogger.debug("FormatteNBTLtionDateTime: "+formatteNBTLtionDateTime);

							String entryDatetime=getEntryDatetimefromDB(workItemName);


							String values = "'" + WI_NAME +"'" + "," + "'" + WSNAME +"'" + "," + "'" + decision +"'" + "," +  "'" + lusername + "'" +  "," + "'"+formatteNBTLtionDateTime+"'" + "," + "'" + remarks +"'" + ","  + "'"+entryDatetime+"'";
							NBTLDocumentLog.NBTLDocumentLogger.debug("Values for history : \n"+values);

							String sInputXMLAPInsert = CommonMethods.apInsert(cabinetName,sessionId,columns,values,hist_table);

							NBTLDocumentLog.NBTLDocumentLogger.info("History_InputXml::::::::::\n"+sInputXMLAPInsert);
							sOutputXML= WFNGExecute(sInputXMLAPInsert,jtsIP,Integer.parseInt(jtsPort),1);
							NBTLDocumentLog.NBTLDocumentLogger.info("History_OutputXml::::::::::\n"+sOutputXML);
							objXMLParser.setInputXML(sOutputXML);
							mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");

						}
					}
					catch(Exception e){
						e.printStackTrace();
						NBTLDocumentLog.NBTLDocumentLogger.error("Exception in historyCaller of UpdateExpiryDate", e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
						continue;

					}
					if (mainCodeforAPInsert.equalsIgnoreCase("11")) {
						sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
					}else{
						sessionCheckInt++;
						break;
					}
				}
				if(mainCodeforAPInsert.equalsIgnoreCase("0")){
					NBTLDocumentLog.NBTLDocumentLogger.info("Insert Successful");
				}
				else{

					NBTLDocumentLog.NBTLDocumentLogger.info("Insert Unsuccessful");
				}
				NBTLDocumentLog.NBTLDocumentLogger.debug("Out History Caller method");
			}

			public String getEntryDatetimefromDB(String workItemName)
			{
				NBTLDocumentLog.NBTLDocumentLogger.info("Start of function getEntryDatetimefromDB ");
				String entryDatetimeAttachCust="";
				String formattedEntryDatetime="";
				String outputXMLEntryDate=null;
				String mainCodeEntryDate=null;

				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
				{
					try {
						XMLParser objXMLParser = new XMLParser();
						String sqlQuery = "select EntryAt from RB_NBTL_EXTTABLE with(nolock) where WINAME='"+workItemName+"'";
						String InputXMLEntryDate = CommonMethods.apSelectWithColumnNames(sqlQuery,cabinetName, sessionId);
						NBTLDocumentLog.NBTLDocumentLogger.info("Getting getIntegrationErrorDescription from exttable table "+InputXMLEntryDate);
						outputXMLEntryDate = WFNGExecute(InputXMLEntryDate, jtsIP, Integer.parseInt(jtsPort), 1);
						NBTLDocumentLog.NBTLDocumentLogger.info("OutputXML for getting getIntegrationErrorDescription from external table "+outputXMLEntryDate);
						objXMLParser.setInputXML(outputXMLEntryDate);
						mainCodeEntryDate=objXMLParser.getValueOf("MainCode");
						} catch (Exception e) {
							sessionCheckInt++;
							waiteloopExecute(waitLoop);
							continue;
						}
					if (!mainCodeEntryDate.equalsIgnoreCase("0"))
					{
						sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);

					}else{
							sessionCheckInt++;
							break;
						}
				}

				if (mainCodeEntryDate.equalsIgnoreCase("0")) {
					try {
						entryDatetimeAttachCust = CommonMethods.getTagValues(outputXMLEntryDate, "EntryAt");

						SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
						SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

						Date entryDatetimeFormat = inputDateformat.parse(entryDatetimeAttachCust);
						formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
						NBTLDocumentLog.NBTLDocumentLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

						NBTLDocumentLog.NBTLDocumentLogger.info("newentrydatetime "+ formattedEntryDatetime);
					}catch (Exception e) {
						e.printStackTrace();
					}


				}
			return formattedEntryDatetime;
		}

			private WorkItem getWI(String sessionId, Node inst) throws NumberFormatException, IOException, Exception
			{
				NBTLDocumentLog.NBTLDocumentLogger.info("Starting getWI function");
				WorkItem wi = new WorkItem();
				wi.processInstanceId = CommonMethods.getTagValues(inst, "ProcessInstanceId");
				wi.workItemId = CommonMethods.getTagValues(inst, "WorkItemId");
				String fetchAttributeInputXML="";
				String fetchAttributeOutputXML="";
				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
		        {
					fetchAttributeInputXML = CommonMethods.getFetchWorkItemAttributesXML(cabinetName,sessionId,wi.processInstanceId, wi.workItemId);
					NBTLDocumentLog.NBTLDocumentLogger.info("FetchAttributeInputXMl "+fetchAttributeInputXML);
					fetchAttributeOutputXML=WFNGExecute(fetchAttributeInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("&","&amp;");
					//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("<","&lt;");
					//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll(">","&gt;");
					NBTLDocumentLog.NBTLDocumentLogger.info("fetchAttributeOutputXML "+fetchAttributeOutputXML);
					if (CommonMethods.getTagValues(fetchAttributeOutputXML, "MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);

					} else {
							sessionCheckInt++;
							break;
							}

					if (CommonMethods.getMainCode(fetchAttributeOutputXML) != 0)
					{
						NBTLDocumentLog.NBTLDocumentLogger.debug(" MapXML.getMainCode(fetchAttributeOutputXML) != 0 ");
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
							if(attributeNames[i].equalsIgnoreCase("ACCOUNT_NUMBER"))
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
					NBTLDocumentLog.NBTLDocumentLogger.debug("Inside catch of get wi function with exception.."+e);
				}
				NBTLDocumentLog.NBTLDocumentLogger.info("Exiting getWI function");
				return wi;
			}

			private void doneWorkItem(String wi_name,String values,Boolean... compeletFlag)
			{
				assert compeletFlag.length <= 1;
				sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
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
							NBTLDocumentLog.NBTLDocumentLogger.error("Exception in Execute : " + e);
							sessionCheckInt++;
							waiteloopExecute(waitLoop);
							sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);
							continue;
						}

						//System.out.println("getWI call output : "+executeXMLMapMethod.get("getWorkItemOutputXML"));
						sessionCheckInt++;
						if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("getWorkItemOutputXML"),"MainCode").equalsIgnoreCase("11"))
						{
							sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);

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
							NBTLDocumentLog.NBTLDocumentLogger.info("inputXml1 ---: "+executeXMLMapMethod.get("inputXml1"));
							NBTLDocumentLog.NBTLDocumentLogger.debug("Output XML APCOMPLETE "+executeXMLMapMethod.get("inputXml1"));
							try
							{
								executeXMLMapMethod.put("outXml1",WFNGExecute((String)executeXMLMapMethod.get("inputXml1"),jtsIP,Integer.parseInt(jtsPort),1));
							}
							catch(Exception e)
							{
								NBTLDocumentLog.NBTLDocumentLogger.error("Exception in Execute : " + e);
								sessionCheckInt++;
								waiteloopExecute(waitLoop);
								sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);

								continue;
							}

							NBTLDocumentLog.NBTLDocumentLogger.info("outXml1 "+executeXMLMapMethod.get("outXml1"));
							sessionCheckInt++;
							if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode").equalsIgnoreCase("11"))
							{
								sessionId  = CommonConnection.getSessionID(NBTLDocumentLog.NBTLDocumentLogger, false);

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
						NBTLDocumentLog.NBTLDocumentLogger.info("Completed "+wi_name);
						//if(!decision.equalsIgnoreCase("failure"))
						//decision="Success";
						//createHistory(wi_name,"Book Utility","","Book_Transaction","Submit");
					}
					else
					{
						//decision="failure";
						NBTLDocumentLog.NBTLDocumentLogger.info("Problem in completion of "+wi_name+" ,Maincode :"+CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode"));
					}
				}
				catch(Exception e)
				{
					NBTLDocumentLog.NBTLDocumentLogger.error("Exception in workitem done = " +e);

					final Writer result = new StringWriter();
					final PrintWriter printWriter = new PrintWriter(result);
					e.printStackTrace(printWriter);
					NBTLDocumentLog.NBTLDocumentLogger.error("Exception Occurred in done wi : "+result);
				}
			}
}


