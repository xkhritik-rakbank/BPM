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


package com.newgen.DAC.Document;

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

public class DACDocument implements Runnable
{
	public static boolean IsUserLoggedIn = false;
	public static boolean srmKeepPolling = true;
	static String lastProcessInstanceId ="";
	static String lastWorkItemId = "";
	private static NGEjbClient ngEjbClientDACDocument;
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

	static Map<String, String> dacDocumentCofigParamMap= new HashMap<String, String>();

	private Map <String, String> executeXMLMapMethod = new HashMap<String, String>();

	@Override
	public void run()
	{
		int sleepIntervalInMin=0;


		try
		{
			DACDocumentLog.setLogger();
			ngEjbClientDACDocument = NGEjbClient.getSharedInstance();

			DACDocumentLog.DACDocumentLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			DACDocumentLog.DACDocumentLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				DACDocumentLog.DACDocumentLogger.error("Could not Read Config Properties [DACDocument]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			DACDocumentLog.DACDocumentLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			DACDocumentLog.DACDocumentLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			DACDocumentLog.DACDocumentLogger.debug("JTSPORT: " + jtsPort);

			smsPort = CommonConnection.getsSMSPort();
			DACDocumentLog.DACDocumentLogger.debug("SMSPort: " + smsPort);
			

			sleepIntervalInMin=Integer.parseInt(dacDocumentCofigParamMap.get("SleepIntervalInMin"));
			DACDocumentLog.DACDocumentLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			attributeNames=dacDocumentCofigParamMap.get("AttributeNames").split(",");
			DACDocumentLog.DACDocumentLogger.debug("AttributeNames: " + attributeNames);

			ExternalTable=dacDocumentCofigParamMap.get("ExtTableName");
			DACDocumentLog.DACDocumentLogger.debug("ExternalTable: " + ExternalTable);

			destFilePath=dacDocumentCofigParamMap.get("destFilePath");
			DACDocumentLog.DACDocumentLogger.debug("destFilePath: " + destFilePath);

			ErrorFolder=dacDocumentCofigParamMap.get("failDestFilePath");
			DACDocumentLog.DACDocumentLogger.debug("ErrorFolder: " + ErrorFolder);

			volumeID=dacDocumentCofigParamMap.get("VolumeID");
			DACDocumentLog.DACDocumentLogger.debug("VolumeID: " + volumeID);

			MaxNoOfTries=dacDocumentCofigParamMap.get("MaxNoOfTries");
			DACDocumentLog.DACDocumentLogger.debug("MaxNoOfTries: " + MaxNoOfTries);

			TimeIntervalBetweenTrialsInMin=Integer.parseInt(dacDocumentCofigParamMap.get("TimeIntervalBetweenTrialsInMin"));
			DACDocumentLog.DACDocumentLogger.debug("TimeIntervalBetweenTrialsInMin: " + TimeIntervalBetweenTrialsInMin);

			sessionId = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
			if(sessionId.trim().equalsIgnoreCase(""))
			{
				DACDocumentLog.DACDocumentLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				DACDocumentLog.DACDocumentLogger.debug("Session ID found: " + sessionId);
				while(true)
				{
					DACDocumentLog.setLogger();
					startDACDocumentUtility();
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			DACDocumentLog.DACDocumentLogger.error("Exception Occurred in DAC Document Thread: "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DACDocumentLog.DACDocumentLogger.error("Exception Occurred in PC Thread : "+result);
		}
	}

	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "DAC_Document_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    dacDocumentCofigParamMap.put(name, p.getProperty(name));
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
//Project                              :           DAC
//Created Date                         :           10-06-2019
//Author                               :           Nikita Singhal
//Description                          :           Function to poll the workitems on a specific queue and process
//***********************************************************************************//
	private void startDACDocumentUtility()
	{
		DACDocumentLog.DACDocumentLogger.info("ProcessWI function for DAC Utility started");

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

		sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);

		if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
		{
			DACDocumentLog.DACDocumentLogger.error("Could Not Get Session ID "+sessionId);
			return;
		}

		List<WorkItem> wiList = new ArrayList<WorkItem>();
		try
		{
			queueID = dacDocumentCofigParamMap.get("QueueID");
			DACDocumentLog.DACDocumentLogger.debug("QueueID: " + queueID);
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
				workItemName = wi.getAttribute("WorkItemName");
				parentFolderIndex = wi.getAttribute("ITEMINDEX");
				DACDocumentLog.DACDocumentLogger.info("The work Item number: " + workItemName);
				DACDocumentLog.DACDocumentLogger.info("The parentFolder of work Item: " +workItemName+ " issss " +parentFolderIndex);


				FilePath=dacDocumentCofigParamMap.get("filePath");
				DACDocumentLog.DACDocumentLogger.debug("filePath: " + FilePath);

				File folder = new File(FilePath);  //RAKFolder
				File[] listOfFiles = folder.listFiles();
				DACDocumentLog.DACDocumentLogger.info("List of all folders are--"+listOfFiles);

				boolean ErrorFlag = true;
				String PreviousStage = wi.getAttribute("PreviousStage");
				String NoOfTries = wi.getAttribute("ATTACHDOCNOOFTRIES");
				String LastAttachTryTime = wi.getAttribute("LAST_ATTACH_TRY_TIME");


				Date CurrentDateTime= new Date();
				DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
				String formattedCurrentDateTime = dateFormat.format(CurrentDateTime);
				DACDocumentLog.DACDocumentLogger.info("LastAttachTryTime--"+LastAttachTryTime);
				DACDocumentLog.DACDocumentLogger.info("formattedCurrentDateTime--"+formattedCurrentDateTime);


				if (NoOfTries.equalsIgnoreCase("") || NoOfTries == null || NoOfTries == "" || (PreviousStage.equalsIgnoreCase("Dec_Error_Handling") && NoOfTries.equalsIgnoreCase("4")) )
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
						DACDocumentLog.DACDocumentLogger.info("d2 ----"+d2);

					}

					catch(Exception e)
					{
						e.printStackTrace();
						catchflag=true;
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
				DACDocumentLog.DACDocumentLogger.info("work Item number: " + workItemName + " iNoOfTries is: "+iNoOfTries+" ,PreviousStage: "+PreviousStage);
				DACDocumentLog.DACDocumentLogger.info("No if tries are ----"+iNoOfTries);
				iMaxNoOfTries = Integer.parseInt(MaxNoOfTries);
				DACDocumentLog.DACDocumentLogger.info("diffMinutes ----"+diffMinutes);
				DACDocumentLog.DACDocumentLogger.info("TimeIntervalBetweenTrialsInMin ----"+TimeIntervalBetweenTrialsInMin);

				if (iNoOfTries < iMaxNoOfTries)
				{
					if(diffMinutes>TimeIntervalBetweenTrialsInMin)
					{
						DACDocumentLog.DACDocumentLogger.info("Inside if loop 100");
						for (File file : listOfFiles)
						{
							DACDocumentLog.DACDocumentLogger.info("Inside for loop 101");
							if (file.isDirectory())
							{
								DACDocumentLog.DACDocumentLogger.info("Inside if loop 102");
								DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" This is a folder : "+file.getName());

								String foldername = file.getName();
								String path = file.getAbsolutePath();

								if(foldername.equalsIgnoreCase(workItemName))
								{
									DACDocumentLog.DACDocumentLogger.info("Inside 103");
									DACDocumentLog.DACDocumentLogger.info("Processing Starts for "+workItemName);
									
									// Checking if workitem folder time and execution time is same
									SimpleDateFormat dateFormat1 = new SimpleDateFormat("dd-MMM-yy HH:mm:ss");
									String strModifiedDate = dateFormat1.format(file.lastModified());
									Date d = new Date();
									String strCurrDateTime = dateFormat1.format(d);
									DACDocumentLog.DACDocumentLogger.info(file.getName()+", last modified: "+strModifiedDate+", strCurrDateTime: "+strCurrDateTime);
									try {
										Date ModifiedDate=dateFormat1.parse(strModifiedDate);
										Date CurrDateTime=dateFormat1.parse(strCurrDateTime);
										long seconds = (CurrDateTime.getTime()-ModifiedDate.getTime())/1000;
										DACDocumentLog.DACDocumentLogger.info("Diff in Secs: "+seconds);
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

											DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" strfullFileName : "+strfullFileName);

											strDocumentName = strfullFileName.substring(0,strfullFileName.lastIndexOf("."));

											String DocNameAsProcess = "";
										
											if (strDocumentName.contains("Emirates_ID_Back"))
												DocNameAsProcess = "Emirates_ID_Back";
											else if (strDocumentName.contains("Emirates_ID"))
												DocNameAsProcess = "Emirates_ID";
											else if (strDocumentName.contains("Passport_Back"))
												DocNameAsProcess = "Passport_Back";
											else if (strDocumentName.contains("Passport"))
												DocNameAsProcess = "Passport";
											else if (strDocumentName.contains("Visa"))
												DocNameAsProcess = "Visa";
											else	
												DocNameAsProcess = "Other";
											
											strExtension = strfullFileName.substring(strfullFileName.lastIndexOf(".")+1,strfullFileName.length());
											if(strExtension.equalsIgnoreCase("JPG") || strExtension.equalsIgnoreCase("TIF") || strExtension.equalsIgnoreCase("JPEG") || strExtension.equalsIgnoreCase("TIFF"))
											{
												DocumentType = "I";
											}
											else
											{
												DocumentType = "N";
											}

											DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" strDocumentName : "+strDocumentName+" strExtension : "+strExtension);
											String fileExtension= getFileExtension(listOfDoc);

											DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" fileExtension : "+fileExtension);

											/*String[] part = strfullFileName.split("~");

											String DocumentType = part[0];
											String DocumentName = part[1];
											System.out.println("DocumentType "+DocumentType);
											System.out.println("DocumentName "+DocumentName);*/

											//Getting DocName for Addition

											for (int i = 0; i < 3; i++)
											{
												DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" Inside for Loop!");
												//System.out.println("Inside for Loop!");

												JPISIsIndex ISINDEX = new JPISIsIndex();
												JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
												lLngFileSize = listOfDoc.length();
												lstrDocFileSize = Long.toString(lLngFileSize);

												if(lLngFileSize != 0L)
												{
													DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" The Document address is: "+path+System.getProperty("file.separator")+listOfDoc.getName());
													//String docPath=path.concat("/").concat(listOfDoc.getName());
													String docPath=path+System.getProperty("file.separator")+listOfDoc.getName();

													try
													{
														DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" before CPISDocumentTxn AddDocument MT: ");

														if(smsPort.startsWith("33"))
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
														}
														else
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
														}	

														DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" after CPISDocumentTxn AddDocument MT: ");

														String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
														DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" sISIndex: "+sISIndex);
														sMappedInputXml = CommonMethods.getNGOAddDocument(parentFolderIndex,DocNameAsProcess,DocumentType,strExtension,sISIndex,lstrDocFileSize,volumeID,cabinetName,sessionId);
														DACDocumentLog.DACDocumentLogger.debug("workItemName: "+workItemName+" sMappedInputXml "+sMappedInputXml);
														DACDocumentLog.DACDocumentLogger.debug("Input xml For NGOAddDocument Call: "+sMappedInputXml);

														sOutputXml=WFNGExecute(sMappedInputXml,jtsIP,Integer.parseInt(jtsPort),1);
														sOutputXml=sOutputXml.replace("<Document>","");
														sOutputXml=sOutputXml.replace("</Document>","");
														DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" Output xml For NGOAddDocument Call: "+sOutputXml);
														DACDocumentLog.DACDocumentLogger.debug("Output xml For NGOAddDocument Call: "+sOutputXml);
														statusXML = CommonMethods.getTagValues(sOutputXml,"Status");
														ErrorMsg = CommonMethods.getTagValues(sOutputXml,"Error");
														//statusXML ="0";
														DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" The maincode of the output xml file is " +statusXML);
														//System.out.println("The maincode of the output xml file is " +statusXML);

													}
													catch (NumberFormatException e)
													{
														DACDocumentLog.DACDocumentLogger.info("workItemName1:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (JPISException e)
													{
														DACDocumentLog.DACDocumentLogger.info("workItemName2:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (Exception e)
													{
														DACDocumentLog.DACDocumentLogger.info("workItemName3:"+e.getMessage());
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
											DACDocumentLog.DACDocumentLogger.info("statusXML maincode is--"+statusXML);
											if("0".equalsIgnoreCase(statusXML))
											{
												DACDocumentLog.DACDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
												//source = ""+documentFolder+"/"+strfullFileName+"";
												source = ""+documentFolder+System.getProperty("file.separator")+strfullFileName+"";
												//dest = ""+destFilePath+"/"+sdate+"/"+workItemName;
												dest = ""+destFilePath+System.getProperty("file.separator")+sdate+System.getProperty("file.separator")+workItemName;
												TimeStamp=get_timestamp();
												newFilename = Move(dest,source,TimeStamp);
											}
											DACDocumentLog.DACDocumentLogger.info("catch flag is--"+catchflag);
											if(!("0".equalsIgnoreCase(statusXML)) || catchflag==true)
											{
												DACDocumentLog.DACDocumentLogger.info("WI Going to the error folder");
												DACDocumentLog.DACDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
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
											Integration_error_received="Attach_Online_Doc";
											if(ErrorMsg.trim().equalsIgnoreCase(""))
												ErrorMsg = "Documents are not available";
											ErrorMessageFrmIntegration=ErrorMsg;
										}

										DACDocumentLog.DACDocumentLogger.info("Current date time is---"+get_timestamp());
										updateExternalTable(ExternalTable,"DECISION,FAILED_INTEGRATION_CALL,MW_ERRORDESC,INTEGRATION_ERROR_RECEIVED,LAST_ATTACH_TRY_TIME","'" + decisionToUpdate + "','"+FailedIntegration+"','"+ErrorMessageFrmIntegration+"','"+Integration_error_received+"','"+formattedCurrentDateTime+"'","ITEMINDEX='"+parentFolderIndex+"'");
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
									DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" Folder name doesn't match the workitem name");
								}
							}
							else
							{
								DACDocumentLog.DACDocumentLogger.info("workItemName: "+workItemName+" It is not a folder"+file.getName());
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
						DACDocumentLog.DACDocumentLogger.info("updating AttachDocNoOfTries");
						decisionToUpdate = "Failure";
						FailedIntegration= "DocNotAvailable";
						ErrorMessageFrmIntegration = "Document Not Available";
						Integration_error_received="Attach_Online_Doc";
						iNoOfTries++;
						updateExternalTable(ExternalTable,"DECISION,ATTACHDOCNOOFTRIES,LAST_ATTACH_TRY_TIME,INTEGRATION_ERROR_RECEIVED","'" + decisionToUpdate + "','"+iNoOfTries+"','"+formattedCurrentDateTime+"','"+Integration_error_received+"'","ITEMINDEX='"+parentFolderIndex+"'");

						if (iNoOfTries > iMaxNoOfTries)
						{
							historyCaller(workItemName,false);
							doneWorkItem(workItemName, "");
						}
					}
				}
				catch (Exception e)
				{
					DACDocumentLog.DACDocumentLogger.info("exception in updating AttachDocNoOfTries");
				}
				//****************************************
			}
		}
		DACDocumentLog.DACDocumentLogger.info("exiting ProcessWI function DAC Utility");
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
				DACDocumentLog.DACDocumentLogger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=WFNGExecute(inputXmlcheckAPUpdate,jtsIP,Integer.parseInt(jtsPort),1);
				DACDocumentLog.DACDocumentLogger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					DACDocumentLog.DACDocumentLogger.error("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
					System.out.println("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
				}
				else
				{
					DACDocumentLog.DACDocumentLogger.error("Succesfully updated "+tablename+" table");
					System.out.println("Succesfully updated "+tablename+" table");
					//ThreadConnect.addToTextArea("Successfully updated transaction table");
				}
				mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
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
				DACDocumentLog.DACDocumentLogger.error("Inside create validateSessionID exception"+e);
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
			 	DACDocumentLog.DACDocumentLogger.info("Starting loadWorkitem function for queueID -->"+queueID);
				List workItemList = null;
				String workItemListInputXML="";
				sessionCheckInt=0;
				String workItemListOutputXML="";
				DACDocumentLog.DACDocumentLogger.info("loopCount aa:" + loopCount);
				DACDocumentLog.DACDocumentLogger.info("lastWorkItemId aa:" + lastWorkItemId);
				DACDocumentLog.DACDocumentLogger.info("lastProcessInstanceId aa:" + lastProcessInstanceId);
				while(sessionCheckInt<loopCount)
				{
					DACDocumentLog.DACDocumentLogger.info("123 cabinet name..."+cabinetName);
					DACDocumentLog.DACDocumentLogger.info("123 session id is..."+sessionId);
					workItemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID);
					DACDocumentLog.DACDocumentLogger.info("workItemListInputXML aa:" + workItemListInputXML);
					try
					{
						workItemListOutputXML=WFNGExecute(workItemListInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					}
					catch(Exception e)
					{
						DACDocumentLog.DACDocumentLogger.error("Exception in Execute : " + e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
						continue;
					}

					DACDocumentLog.DACDocumentLogger.info("workItemListOutputXML : " + workItemListOutputXML);
					if (CommonMethods.getTagValues(workItemListOutputXML,"MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
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
				DACDocumentLog.DACDocumentLogger.info("Exiting loadWorkitem function for queueID -->"+queueID);
				return workItemList;
			}



		 public static String WFNGExecute(String ipXML, String serverIP,
					int serverPort, int flag) throws IOException, Exception {
			 String jtsPort=""+serverPort;
				if (jtsPort.startsWith("33"))
					return WFCallBroker.execute(ipXML, serverIP, serverPort, flag);
				else
					return ngEjbClientDACDocument.makeCall(serverIP, serverPort + "", "WebSphere",
							ipXML);
			}

		 private List getWorkItems(String sessionId, String workItemListOutputXML, String[] last) throws NumberFormatException, Exception
		 {
				// TODO Auto-generated method stub
			 DACDocumentLog.DACDocumentLogger.info("Starting getWorkitems function ");
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

					DACDocumentLog.DACDocumentLogger.info("last[0] : "+last[0]);
				}
				DACDocumentLog.DACDocumentLogger.info("Exiting getWorkitems function");
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
				DACDocumentLog.DACDocumentLogger.debug("In History Caller method");

				XMLParser objXMLParser = new XMLParser();
				String sOutputXML=null;
				String mainCodeforAPInsert=null;
				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
				{
					try{

						if(workItemName!=null)
						{
							String hist_table="USR_0_DAC_WIHISTORY";
							String columns="wi_name,workstep,decision,action_date_time,remarks,user_name,Entry_Date_Time";
							String WI_NAME=workItemName;
							String WSNAME="Attach_Online_Doc";
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
							DACDocumentLog.DACDocumentLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

							String entryDatetime=getEntryDatetimefromDB(workItemName);


							String values = "'" + WI_NAME +"'" + "," + "'" + WSNAME +"'" + "," + "'" + decision +"'" + ","  + "'"+formattedActionDateTime+"'" + "," + "'" + remarks +"'" + "," +  "'" + lusername + "'" +  "," + "'"+entryDatetime+"'";
							DACDocumentLog.DACDocumentLogger.debug("Values for history : \n"+values);

							String sInputXMLAPInsert = CommonMethods.apInsert(cabinetName,sessionId,columns,values,hist_table);

							DACDocumentLog.DACDocumentLogger.info("History_InputXml::::::::::\n"+sInputXMLAPInsert);
							sOutputXML= WFNGExecute(sInputXMLAPInsert,jtsIP,Integer.parseInt(jtsPort),1);
							DACDocumentLog.DACDocumentLogger.info("History_OutputXml::::::::::\n"+sOutputXML);
							objXMLParser.setInputXML(sOutputXML);
							mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");

						}
					}
					catch(Exception e){
						e.printStackTrace();
						DACDocumentLog.DACDocumentLogger.error("Exception in historyCaller of UpdateExpiryDate", e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
						continue;

					}
					if (mainCodeforAPInsert.equalsIgnoreCase("11")) {
						sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
					}else{
						sessionCheckInt++;
						break;
					}
				}
				if(mainCodeforAPInsert.equalsIgnoreCase("0")){
					DACDocumentLog.DACDocumentLogger.info("Insert Successful");
				}
				else{

					DACDocumentLog.DACDocumentLogger.info("Insert Unsuccessful");
				}
				DACDocumentLog.DACDocumentLogger.debug("Out History Caller method");
			}

			public String getEntryDatetimefromDB(String workItemName)
			{
				DACDocumentLog.DACDocumentLogger.info("Start of function getEntryDatetimefromDB ");
				String entryDatetimeAttachCust="";
				String formattedEntryDatetime="";
				String outputXMLEntryDate=null;
				String mainCodeEntryDate=null;

				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
				{
					try {
						XMLParser objXMLParser = new XMLParser();
						String sqlQuery = "select entryat from RB_DAC_EXTTABLE with(nolock) where WI_NAME='"+workItemName+"'";
						String InputXMLEntryDate = CommonMethods.apSelectWithColumnNames(sqlQuery,cabinetName, sessionId);
						DACDocumentLog.DACDocumentLogger.info("Getting getIntegrationErrorDescription from exttable table "+InputXMLEntryDate);
						outputXMLEntryDate = WFNGExecute(InputXMLEntryDate, jtsIP, Integer.parseInt(jtsPort), 1);
						DACDocumentLog.DACDocumentLogger.info("OutputXML for getting getIntegrationErrorDescription from external table "+outputXMLEntryDate);
						objXMLParser.setInputXML(outputXMLEntryDate);
						mainCodeEntryDate=objXMLParser.getValueOf("MainCode");
						} catch (Exception e) {
							sessionCheckInt++;
							waiteloopExecute(waitLoop);
							continue;
						}
					if (!mainCodeEntryDate.equalsIgnoreCase("0"))
					{
						sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);

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
						DACDocumentLog.DACDocumentLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

						DACDocumentLog.DACDocumentLogger.info("newentrydatetime "+ formattedEntryDatetime);
					}catch (Exception e) {
						e.printStackTrace();
					}


				}
			return formattedEntryDatetime;
		}

			private WorkItem getWI(String sessionId, Node inst) throws NumberFormatException, IOException, Exception
			{
				DACDocumentLog.DACDocumentLogger.info("Starting getWI function");
				WorkItem wi = new WorkItem();
				wi.processInstanceId = CommonMethods.getTagValues(inst, "ProcessInstanceId");
				wi.workItemId = CommonMethods.getTagValues(inst, "WorkItemId");
				String fetchAttributeInputXML="";
				String fetchAttributeOutputXML="";
				sessionCheckInt=0;
				while(sessionCheckInt<loopCount)
		        {
					fetchAttributeInputXML = CommonMethods.getFetchWorkItemAttributesXML(cabinetName,sessionId,wi.processInstanceId, wi.workItemId);
					DACDocumentLog.DACDocumentLogger.info("FetchAttributeInputXMl "+fetchAttributeInputXML);
					fetchAttributeOutputXML=WFNGExecute(fetchAttributeInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("&","&amp;");
					//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("<","&lt;");
					//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll(">","&gt;");
					DACDocumentLog.DACDocumentLogger.info("fetchAttributeOutputXML "+fetchAttributeOutputXML);
					if (CommonMethods.getTagValues(fetchAttributeOutputXML, "MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);

					} else {
							sessionCheckInt++;
							break;
							}

					if (CommonMethods.getMainCode(fetchAttributeOutputXML) != 0)
					{
						DACDocumentLog.DACDocumentLogger.debug(" MapXML.getMainCode(fetchAttributeOutputXML) != 0 ");
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
					DACDocumentLog.DACDocumentLogger.debug("Inside catch of get wi function with exception.."+e);
				}
				DACDocumentLog.DACDocumentLogger.info("Exiting getWI function");
				return wi;
			}

			private void doneWorkItem(String wi_name,String values,Boolean... compeletFlag)
			{
				assert compeletFlag.length <= 1;
				sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
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
							DACDocumentLog.DACDocumentLogger.error("Exception in Execute : " + e);
							sessionCheckInt++;
							waiteloopExecute(waitLoop);
							sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);
							continue;
						}

						//System.out.println("getWI call output : "+executeXMLMapMethod.get("getWorkItemOutputXML"));
						sessionCheckInt++;
						if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("getWorkItemOutputXML"),"MainCode").equalsIgnoreCase("11"))
						{
							sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);

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
							DACDocumentLog.DACDocumentLogger.info("inputXml1 ---: "+executeXMLMapMethod.get("inputXml1"));
							DACDocumentLog.DACDocumentLogger.debug("Output XML APCOMPLETE "+executeXMLMapMethod.get("inputXml1"));
							try
							{
								executeXMLMapMethod.put("outXml1",WFNGExecute((String)executeXMLMapMethod.get("inputXml1"),jtsIP,Integer.parseInt(jtsPort),1));
							}
							catch(Exception e)
							{
								DACDocumentLog.DACDocumentLogger.error("Exception in Execute : " + e);
								sessionCheckInt++;
								waiteloopExecute(waitLoop);
								sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);

								continue;
							}

							DACDocumentLog.DACDocumentLogger.info("outXml1 "+executeXMLMapMethod.get("outXml1"));
							sessionCheckInt++;
							if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode").equalsIgnoreCase("11"))
							{
								sessionId  = CommonConnection.getSessionID(DACDocumentLog.DACDocumentLogger, false);

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
						DACDocumentLog.DACDocumentLogger.info("Completed "+wi_name);
						//if(!decision.equalsIgnoreCase("failure"))
						//decision="Success";
						//createHistory(wi_name,"Book Utility","","Book_Transaction","Submit");
					}
					else
					{
						//decision="failure";
						DACDocumentLog.DACDocumentLogger.info("Problem in completion of "+wi_name+" ,Maincode :"+CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode"));
					}
				}
				catch(Exception e)
				{
					DACDocumentLog.DACDocumentLogger.error("Exception in workitem done = " +e);

					final Writer result = new StringWriter();
					final PrintWriter printWriter = new PrintWriter(result);
					e.printStackTrace(printWriter);
					DACDocumentLog.DACDocumentLogger.error("Exception Occurred in done wi : "+result);
				}
			}
}


