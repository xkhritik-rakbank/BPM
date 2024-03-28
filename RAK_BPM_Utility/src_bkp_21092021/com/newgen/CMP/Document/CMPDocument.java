package com.newgen.CMP.Document;


import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.DateFormat;
import java.text.Format;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.CBP.Document.CBPDocumentLog;
import com.newgen.CMP.Document.WorkItem;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class CMPDocument implements Runnable{	
	
	private static  String cabinetName;
	private static  String jtsIP;
	private static  String jtsPort;
	private static  String smsPort;
	private  String [] attributeNames;
	private static String ExternalTable;
	private static String destFilePath;
	private static String ErrorFolder;
	private static String volumeID;
	private static String MaxNoOfTries;
	private static int TimeIntervalBetweenTrialsInMin;
	private  String queueID;
	private  String workItemName;
	private  String parentFolderIndex;
	static String lastWorkItemId = "";
	static String lastProcessInstanceId = "";
	private  int mainCode;
	Date now=null;
	public static String sdate="";
	public static String source=null;
	public static String dest=null;
	public static String TimeStamp="";
	public static String newFilename=null;
	private static String sessionId;
	public static int sessionCheckInt=0;
	public static int waitLoop=50;
	public static int loopCount=50;
	
	static Map<String, String> cmpDocumentCofigParamMap= new HashMap<String, String>();
	private Map <String, String> executeXMLMapMethod = new HashMap<String, String>();
	private static NGEjbClient ngEjbClientCMPDocument;
	
	public void run()
	{
		int sleepIntervalInMin=0;
		try
		{
			CMPDocumentLog.setLogger();
			ngEjbClientCMPDocument = NGEjbClient.getSharedInstance();

			CMPDocumentLog.CMPDocumentLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			CMPDocumentLog.CMPDocumentLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				CMPDocumentLog.CMPDocumentLogger.error("Could not Read Config Properties [CMPDocument]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			CMPDocumentLog.CMPDocumentLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			CMPDocumentLog.CMPDocumentLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			CMPDocumentLog.CMPDocumentLogger.debug("JTSPORT: " + jtsPort);

			smsPort = CommonConnection.getsSMSPort();
			CMPDocumentLog.CMPDocumentLogger.debug("SMSPort: " + smsPort);			

			sleepIntervalInMin=Integer.parseInt(cmpDocumentCofigParamMap.get("SleepIntervalInMin"));
			CMPDocumentLog.CMPDocumentLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);

			attributeNames=cmpDocumentCofigParamMap.get("AttributeNames").split(",");
			CMPDocumentLog.CMPDocumentLogger.debug("AttributeNames: " + attributeNames);

			ExternalTable=cmpDocumentCofigParamMap.get("ExtTableName");
			CMPDocumentLog.CMPDocumentLogger.debug("ExternalTable: " + ExternalTable);

			destFilePath=cmpDocumentCofigParamMap.get("destFilePath");
			CMPDocumentLog.CMPDocumentLogger.debug("destFilePath: " + destFilePath);

			ErrorFolder=cmpDocumentCofigParamMap.get("failDestFilePath");
			CMPDocumentLog.CMPDocumentLogger.debug("ErrorFolder: " + ErrorFolder);

			volumeID=cmpDocumentCofigParamMap.get("VolumeID");
			CMPDocumentLog.CMPDocumentLogger.debug("VolumeID: " + volumeID);

			MaxNoOfTries=cmpDocumentCofigParamMap.get("MaxNoOfTries");
			CMPDocumentLog.CMPDocumentLogger.debug("MaxNoOfTries: " + MaxNoOfTries);

			TimeIntervalBetweenTrialsInMin=Integer.parseInt(cmpDocumentCofigParamMap.get("TimeIntervalBetweenTrialsInMin"));
			CMPDocumentLog.CMPDocumentLogger.debug("TimeIntervalBetweenTrialsInMin: " + TimeIntervalBetweenTrialsInMin);
			
			sessionId = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
			if(sessionId.trim().equalsIgnoreCase(""))
			{
				//System.out.println("SESSION NOT CREATED");
				CMPDocumentLog.CMPDocumentLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				//System.out.println("SESSION CREATED");
				CMPDocumentLog.CMPDocumentLogger.debug("Session ID found: " + sessionId);
				while(true)
				{
					//CMPDocumentLog.setLogger();
					startCMPDocumentUtility();
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
			CMPDocumentLog.CMPDocumentLogger.error("Exception Occurred in CMP Document Thread: "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CMPDocumentLog.CMPDocumentLogger.error("Exception Occurred in PC Thread : "+result);
		}
	}
	
	private int readConfig()
	{
		Properties p = null;
		try {
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "CMP_Document_Config.properties")));
			Enumeration<?> names = p.propertyNames();
			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    cmpDocumentCofigParamMap.put(name, p.getProperty(name));
			}
			//System.out.println("READ Config Completed !");
		}
		catch (Exception e)
		{
			System.out.println("Exception in Read INI: "+ e.getMessage());
			return -1 ;			
		}
		return 0;
	}
	
	private void startCMPDocumentUtility()
	{
		CMPDocumentLog.CMPDocumentLogger.info("ProcessWI function for CMP Utility started");

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

		sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);

		if(sessionId==null || sessionId.equalsIgnoreCase("") || sessionId.equalsIgnoreCase("null"))
		{
			CMPDocumentLog.CMPDocumentLogger.error("Could Not Get Session ID "+sessionId);
			return;
		}

		List<WorkItem> wiList = new ArrayList<WorkItem>();
		try
		{
			queueID = cmpDocumentCofigParamMap.get("QueueID");
			CMPDocumentLog.CMPDocumentLogger.debug("QueueID: " + queueID);
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
				CMPDocumentLog.CMPDocumentLogger.info("The work Item number: " + workItemName);
				CMPDocumentLog.CMPDocumentLogger.info("The parentFolder of work Item: " +workItemName+ " issss " +parentFolderIndex);


				FilePath=cmpDocumentCofigParamMap.get("filePath");
				CMPDocumentLog.CMPDocumentLogger.debug("filePath: " + FilePath);

				File folder = new File(FilePath);  //RAKFolder
				File[] listOfFiles = folder.listFiles();
				CMPDocumentLog.CMPDocumentLogger.info("List of all folders are--"+listOfFiles);

				boolean ErrorFlag = true;
				String PreviousStage = wi.getAttribute("PreviousStage");
				String NoOfTries = wi.getAttribute("ATTACHDOCNOOFTRIES");
				String LastAttachTryTime = wi.getAttribute("LAST_ATTACH_TRY_TIME");


				Date CurrentDateTime= new Date();
				DateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
				String formattedCurrentDateTime = dateFormat.format(CurrentDateTime);
				CMPDocumentLog.CMPDocumentLogger.info("LastAttachTryTime--"+LastAttachTryTime);
				CMPDocumentLog.CMPDocumentLogger.info("formattedCurrentDateTime--"+formattedCurrentDateTime);


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
						CMPDocumentLog.CMPDocumentLogger.info("d2 ----"+d2);

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
				CMPDocumentLog.CMPDocumentLogger.info("work Item number: " + workItemName + " iNoOfTries is: "+iNoOfTries+" ,PreviousStage: "+PreviousStage);
				CMPDocumentLog.CMPDocumentLogger.info("No if tries are ----"+iNoOfTries);
				iMaxNoOfTries = Integer.parseInt(MaxNoOfTries);
				CMPDocumentLog.CMPDocumentLogger.info("MaxNoOfTries are ----"+MaxNoOfTries);
				CMPDocumentLog.CMPDocumentLogger.info("diffMinutes are ----"+diffMinutes);
				CMPDocumentLog.CMPDocumentLogger.info("TimeIntervalBetweenTrialsInMin are ----"+TimeIntervalBetweenTrialsInMin);

				if (iNoOfTries < iMaxNoOfTries)
				{
					if(diffMinutes>TimeIntervalBetweenTrialsInMin)
					{
						CMPDocumentLog.CMPDocumentLogger.info("Inside if loop 100");
						for (File file : listOfFiles)
						{
							CMPDocumentLog.CMPDocumentLogger.info("Inside for loop 101");
							if (file.isDirectory())
							{
								CMPDocumentLog.CMPDocumentLogger.info("Inside if loop 102");
								CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" This is a folder : "+file.getName());

								String foldername = file.getName();
								String path = file.getAbsolutePath();

								if(foldername.equalsIgnoreCase(workItemName))
								{
									CMPDocumentLog.CMPDocumentLogger.info("Inside 103");
									CMPDocumentLog.CMPDocumentLogger.info("Processing Starts for "+workItemName);
									
									// Checking if workitem folder time and execution time is same
									SimpleDateFormat dateFormat1 = new SimpleDateFormat("dd-MMM-yy HH:mm:ss");
									String strModifiedDate = dateFormat1.format(file.lastModified());
									Date d = new Date();
									String strCurrDateTime = dateFormat1.format(d);
									CMPDocumentLog.CMPDocumentLogger.info(file.getName()+", last modified: "+strModifiedDate+", strCurrDateTime: "+strCurrDateTime);
									try {
										Date ModifiedDate=dateFormat1.parse(strModifiedDate);
										Date CurrDateTime=dateFormat1.parse(strCurrDateTime);
										long seconds = (CurrDateTime.getTime()-ModifiedDate.getTime())/1000;
										CMPDocumentLog.CMPDocumentLogger.info("Diff in Secs: "+seconds);
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

											CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" strfullFileName : "+strfullFileName);


											strDocumentName = strfullFileName.substring(0,strfullFileName.lastIndexOf("."));

											strExtension = strfullFileName.substring(strfullFileName.lastIndexOf(".")+1,strfullFileName.length());
											if(strExtension.equalsIgnoreCase("JPG") || strExtension.equalsIgnoreCase("TIF") || strExtension.equalsIgnoreCase("JPEG") || strExtension.equalsIgnoreCase("TIFF"))
											{
												DocumentType = "I";
											}
											else
											{
												DocumentType = "N";
											}

											CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" strDocumentName : "+strDocumentName+" strExtension : "+strExtension);
											String fileExtension= getFileExtension(listOfDoc);

											CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" fileExtension : "+fileExtension);

											/*String[] part = strfullFileName.split("~");

											String DocumentType = part[0];
											String DocumentName = part[1];
											System.out.println("DocumentType "+DocumentType);
											System.out.println("DocumentName "+DocumentName);*/

											//Getting DocName for Addition

											for (int i = 0; i < 3; i++)
											{
												CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" Inside for Loop!");
												//System.out.println("Inside for Loop!");

												JPISIsIndex ISINDEX = new JPISIsIndex();
												JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
												lLngFileSize = listOfDoc.length();
												lstrDocFileSize = Long.toString(lLngFileSize);

												if(lLngFileSize != 0L)
												{
													CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" The Document address is: "+path+System.getProperty("file.separator")+listOfDoc.getName());
													//String docPath=path.concat("/").concat(listOfDoc.getName());
													String docPath=path+System.getProperty("file.separator")+listOfDoc.getName();

													try
													{
														CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" before CPISDocumentTxn AddDocument MT: ");

														if(smsPort.startsWith("33"))
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
														}
														else
														{
															CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(smsPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
														}	

														CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" after CPISDocumentTxn AddDocument MT: ");

														String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
														CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" sISIndex: "+sISIndex);
														sMappedInputXml = CommonMethods.getNGOAddDocument(parentFolderIndex,strDocumentName,DocumentType,strExtension,sISIndex,lstrDocFileSize,volumeID,cabinetName,sessionId);
														CMPDocumentLog.CMPDocumentLogger.debug("workItemName: "+workItemName+" sMappedInputXml "+sMappedInputXml);
														CMPDocumentLog.CMPDocumentLogger.debug("Input xml For NGOAddDocument Call: "+sMappedInputXml);

														sOutputXml=WFNGExecute(sMappedInputXml,jtsIP,Integer.parseInt(jtsPort),1);
														sOutputXml=sOutputXml.replace("<Document>","");
														sOutputXml=sOutputXml.replace("</Document>","");
														CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" Output xml For NGOAddDocument Call: "+sOutputXml);
														CMPDocumentLog.CMPDocumentLogger.debug("Output xml For NGOAddDocument Call: "+sOutputXml);
														statusXML = CommonMethods.getTagValues(sOutputXml,"Status");
														ErrorMsg = CommonMethods.getTagValues(sOutputXml,"Error");
														//statusXML ="0";
														CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" The maincode of the output xml file is " +statusXML);
														//System.out.println("The maincode of the output xml file is " +statusXML);

													}
													catch (NumberFormatException e)
													{
														CMPDocumentLog.CMPDocumentLogger.info("workItemName1:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (JPISException e)
													{
														CMPDocumentLog.CMPDocumentLogger.info("workItemName2:"+e.getMessage());
														e.printStackTrace();
														catchflag=true;
													}
													catch (Exception e)
													{
														CMPDocumentLog.CMPDocumentLogger.info("workItemName3:"+e.getMessage());
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
											CMPDocumentLog.CMPDocumentLogger.info("statusXML maincode is--"+statusXML);
											if("0".equalsIgnoreCase(statusXML))
											{
												CMPDocumentLog.CMPDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
												//source = ""+documentFolder+"/"+strfullFileName+"";
												source = ""+documentFolder+System.getProperty("file.separator")+strfullFileName+"";
												//dest = ""+destFilePath+"/"+sdate+"/"+workItemName;
												dest = ""+destFilePath+System.getProperty("file.separator")+sdate+System.getProperty("file.separator")+workItemName;
												TimeStamp=get_timestamp();
												newFilename = Move(dest,source,TimeStamp);
											}
											CMPDocumentLog.CMPDocumentLogger.info("catch flag is--"+catchflag);
											if(!("0".equalsIgnoreCase(statusXML)) || catchflag==true)
											{
												CMPDocumentLog.CMPDocumentLogger.info("WI Going to the error folder");
												CMPDocumentLog.CMPDocumentLogger.debug("File "+strfullFileName +" destination "+destFilePath);
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
											Integration_error_received="Attach_Cust_Doc";
											ErrorMessageFrmIntegration=ErrorMsg;
										}

										CMPDocumentLog.CMPDocumentLogger.info("Current date time is---"+get_timestamp());
										//System.out.println("ExternalTable 1:"+ExternalTable+" decision :"+decisionToUpdate+" FAILEDINTEGRATIONCALL :"+FailedIntegration+" MW_ERRORDESC :"+ErrorMessageFrmIntegration+" INTEGRATION_ERROR_RECEIVED :"+Integration_error_received+"ITEMINDEX ="+parentFolderIndex);
										updateExternalTable(ExternalTable,"decision,FAILEDINTEGRATIONCALL,MW_ERRORDESC,INTEGRATION_ERROR_RECEIVED,LAST_ATTACH_TRY_TIME","'" + decisionToUpdate + "','"+FailedIntegration+"','"+ErrorMessageFrmIntegration+"','"+Integration_error_received+"','"+formattedCurrentDateTime+"'","ITEMINDEX='"+parentFolderIndex+"'");
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
									CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" Folder name doesn't match the workitem name");
								}
							}
							else
							{
								CMPDocumentLog.CMPDocumentLogger.info("workItemName: "+workItemName+" It is not a folder"+file.getName());
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
						CMPDocumentLog.CMPDocumentLogger.info("updating AttachDocNoOfTries");
						decisionToUpdate = "Failure";
						FailedIntegration= "DocNotAvailable";
						ErrorMessageFrmIntegration = "Document Not Available";
						Integration_error_received="Attach_Cust_Doc";
						iNoOfTries++;
						//System.out.println("ExternalTable 2:"+ExternalTable+" decision :"+decisionToUpdate+" FAILEDINTEGRATIONCALL :"+FailedIntegration+" MW_ERRORDESC :"+ErrorMessageFrmIntegration+" INTEGRATION_ERROR_RECEIVED :"+Integration_error_received+"ITEMINDEX ="+parentFolderIndex);
						updateExternalTable(ExternalTable,"decision,ATTACHDOCNOOFTRIES,LAST_ATTACH_TRY_TIME,INTEGRATION_ERROR_RECEIVED","'" + decisionToUpdate + "','"+iNoOfTries+"','"+formattedCurrentDateTime+"','"+Integration_error_received+"'","ITEMINDEX='"+parentFolderIndex+"'");

						if (iNoOfTries > iMaxNoOfTries)
						{
							historyCaller(workItemName,false);
							doneWorkItem(workItemName, "");
						}
					}
				}
				catch (Exception e)
				{
					CMPDocumentLog.CMPDocumentLogger.info("exception in updating AttachDocNoOfTries");
				}
				//****************************************
			}
		}
		CMPDocumentLog.CMPDocumentLogger.info("exiting ProcessWI function CMP Utility");
	}
	
	private void doneWorkItem(String wi_name,String values,Boolean... compeletFlag)
	{
		assert compeletFlag.length <= 1;
		sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
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
					CMPDocumentLog.CMPDocumentLogger.error("Exception in Execute : " + e);
					sessionCheckInt++;
					waiteloopExecute(waitLoop);
					sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
					continue;
				}

				//System.out.println("getWI call output : "+executeXMLMapMethod.get("getWorkItemOutputXML"));
				sessionCheckInt++;
				if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("getWorkItemOutputXML"),"MainCode").equalsIgnoreCase("11"))
				{
					sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);

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
					CMPDocumentLog.CMPDocumentLogger.info("inputXml1 ---: "+executeXMLMapMethod.get("inputXml1"));
					CMPDocumentLog.CMPDocumentLogger.debug("Output XML APCOMPLETE "+executeXMLMapMethod.get("inputXml1"));
					try
					{
						executeXMLMapMethod.put("outXml1",WFNGExecute((String)executeXMLMapMethod.get("inputXml1"),jtsIP,Integer.parseInt(jtsPort),1));
					}
					catch(Exception e)
					{
						CMPDocumentLog.CMPDocumentLogger.error("Exception in Execute : " + e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);

						continue;
					}

					CMPDocumentLog.CMPDocumentLogger.info("outXml1 "+executeXMLMapMethod.get("outXml1"));
					sessionCheckInt++;
					if (CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);

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
				CMPDocumentLog.CMPDocumentLogger.info("Completed "+wi_name);
				//if(!decision.equalsIgnoreCase("failure"))
				//decision="Success";
				//createHistory(wi_name,"Book Utility","","Book_Transaction","Submit");
			}
			else
			{
				//decision="failure";
				CMPDocumentLog.CMPDocumentLogger.info("Problem in completion of "+wi_name+" ,Maincode :"+CommonMethods.getTagValues((String)executeXMLMapMethod.get("outXml1"),"MainCode"));
			}
		}
		catch(Exception e)
		{
			CMPDocumentLog.CMPDocumentLogger.error("Exception in workitem done = " +e);

			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			CMPDocumentLog.CMPDocumentLogger.error("Exception Occurred in done wi : "+result);
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
	
	private void updateExternalTable(String tablename, String columnname,String sMessage, String sWhere)
	{
		sessionCheckInt=0;

		while(sessionCheckInt<loopCount)
		{
			try
			{
				XMLParser objXMLParser = new XMLParser();
				String inputXmlcheckAPUpdate = CommonMethods.getAPUpdateIpXML(tablename,columnname,sMessage,sWhere,cabinetName,sessionId);
				CMPDocumentLog.CMPDocumentLogger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				//System.out.println("inputXmlcheckAPUpdate :"+inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=WFNGExecute(inputXmlcheckAPUpdate,jtsIP,Integer.parseInt(jtsPort),1);
				CMPDocumentLog.CMPDocumentLogger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				//System.out.println("outXmlCheckAPUpdate :"+outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				//System.out.println("mainCodeforCheckUpdate :"+mainCodeforCheckUpdate);
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					CMPDocumentLog.CMPDocumentLogger.error("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
					System.out.println("Exception in ExecuteQuery_APUpdate updating "+tablename+" table");
				}
				else
				{
					CMPDocumentLog.CMPDocumentLogger.error("Succesfully updated "+tablename+" table");
					System.out.println("Succesfully updated "+tablename+" table");
					//ThreadConnect.addToTextArea("Successfully updated transaction table");
				}
				mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
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
				CMPDocumentLog.CMPDocumentLogger.error("Inside create validateSessionID exception"+e);
			}
		}
	}
	
	private void historyCaller(String workItemName, boolean DocAttached)
	{
		CMPDocumentLog.CMPDocumentLogger.debug("In History Caller method");

		XMLParser objXMLParser = new XMLParser();
		String sOutputXML=null;
		String mainCodeforAPInsert=null;
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try{

				if(workItemName!=null)
				{
					String hist_table="USR_0_CMP_WIHISTORY";
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
					CMPDocumentLog.CMPDocumentLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);

					String entryDatetime=getEntryDatetimefromDB(workItemName);


					String values = "'" + WINAME +"'" + "," + "'" + WSNAME +"'" + "," + "'" + decision +"'" + ","  + "'"+formattedActionDateTime+"'" + "," + "'" + remarks +"'" + "," +  "'" + lusername + "'" +  "," + "'"+entryDatetime+"'";
					CMPDocumentLog.CMPDocumentLogger.debug("Values for history : \n"+values);

					String sInputXMLAPInsert = CommonMethods.apInsert(cabinetName,sessionId,columns,values,hist_table);

					CMPDocumentLog.CMPDocumentLogger.info("History_InputXml::::::::::\n"+sInputXMLAPInsert);
					sOutputXML= WFNGExecute(sInputXMLAPInsert,jtsIP,Integer.parseInt(jtsPort),1);
					CMPDocumentLog.CMPDocumentLogger.info("History_OutputXml::::::::::\n"+sOutputXML);
					objXMLParser.setInputXML(sOutputXML);
					mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");

				}
			}
			catch(Exception e){
				e.printStackTrace();
				CMPDocumentLog.CMPDocumentLogger.error("Exception in historyCaller of UpdateExpiryDate", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
				continue;

			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) {
				sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
			}else{
				sessionCheckInt++;
				break;
			}
		}
		if(mainCodeforAPInsert.equalsIgnoreCase("0")){
			CMPDocumentLog.CMPDocumentLogger.info("Insert Successful");
		}
		else{

			CMPDocumentLog.CMPDocumentLogger.info("Insert Unsuccessful");
		}
		CMPDocumentLog.CMPDocumentLogger.debug("Out History Caller method");
	}
	
	public String getEntryDatetimefromDB(String workItemName)
	{
		CMPDocumentLog.CMPDocumentLogger.info("Start of function getEntryDatetimefromDB ");
		//System.out.println("Start of function getEntryDatetimefromDB  for workItemName :"+workItemName);
		String entryDatetimeAttachCust="";
		String formattedEntryDatetime="";
		String outputXMLEntryDate=null;
		String mainCodeEntryDate=null;

		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try {
				XMLParser objXMLParser = new XMLParser();
				String sqlQuery = "select entryat from RB_CMP_EXTTABLE with(nolock) where WINAME='"+workItemName+"'";
				String InputXMLEntryDate = CommonMethods.apSelectWithColumnNames(sqlQuery,cabinetName, sessionId);
				CMPDocumentLog.CMPDocumentLogger.info("Getting getIntegrationErrorDescription from exttable table "+InputXMLEntryDate);
				outputXMLEntryDate = WFNGExecute(InputXMLEntryDate, jtsIP, Integer.parseInt(jtsPort), 1);
				CMPDocumentLog.CMPDocumentLogger.info("OutputXML for getting getIntegrationErrorDescription from external table "+outputXMLEntryDate);
				objXMLParser.setInputXML(outputXMLEntryDate);
				mainCodeEntryDate=objXMLParser.getValueOf("MainCode");
				} catch (Exception e) {
					sessionCheckInt++;
					waiteloopExecute(waitLoop);
					continue;
				}
			if (!mainCodeEntryDate.equalsIgnoreCase("0"))
			{
				sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);

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
				//System.out.println("entryDatetimeAttachCust :"+entryDatetimeAttachCust);
				Date entryDatetimeFormat = inputDateformat.parse(entryDatetimeAttachCust);
				formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
				CMPDocumentLog.CMPDocumentLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

				CMPDocumentLog.CMPDocumentLogger.info("newentrydatetime "+ formattedEntryDatetime);
			}catch (Exception e) {
				e.printStackTrace();
			}


		}
	return formattedEntryDatetime;
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
	
	private String getFileExtension(File file) {
        String name = file.getName();
        try {
            return name.substring(name.lastIndexOf(".") + 1);
        } catch (Exception e) {
            return "";
        }
    }
	
	 private List loadWorkItems(String queueID,String sessionId) throws NumberFormatException, IOException, Exception
		{
			 	CMPDocumentLog.CMPDocumentLogger.info("Starting loadWorkitem function for queueID -->"+queueID);
				List workItemList = null;
				String workItemListInputXML="";
				sessionCheckInt=0;
				String workItemListOutputXML="";
				CMPDocumentLog.CMPDocumentLogger.info("loopCount aa:" + loopCount);
				CMPDocumentLog.CMPDocumentLogger.info("lastWorkItemId aa:" + lastWorkItemId);
				CMPDocumentLog.CMPDocumentLogger.info("lastProcessInstanceId aa:" + lastProcessInstanceId);
				while(sessionCheckInt<loopCount)
				{
					CMPDocumentLog.CMPDocumentLogger.info("123 cabinet name..."+cabinetName);
					CMPDocumentLog.CMPDocumentLogger.info("123 session id is..."+sessionId);
					workItemListInputXML = CommonMethods.getFetchWorkItemsInputXML(lastProcessInstanceId, lastWorkItemId, sessionId, cabinetName, queueID);
					CMPDocumentLog.CMPDocumentLogger.info("workItemListInputXML aa:" + workItemListInputXML);
					try
					{
						workItemListOutputXML=WFNGExecute(workItemListInputXML,jtsIP,Integer.parseInt(jtsPort),1);
					}
					catch(Exception e)
					{
						CMPDocumentLog.CMPDocumentLogger.error("Exception in Execute : " + e);
						sessionCheckInt++;
						waiteloopExecute(waitLoop);
						sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
						continue;
					}

					CMPDocumentLog.CMPDocumentLogger.info("workItemListOutputXML : " + workItemListOutputXML);
					if (CommonMethods.getTagValues(workItemListOutputXML,"MainCode").equalsIgnoreCase("11"))
					{
						sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);
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
				CMPDocumentLog.CMPDocumentLogger.info("Exiting loadWorkitem function for queueID -->"+queueID);
				return workItemList;
			}
	 
	 private List getWorkItems(String sessionId, String workItemListOutputXML, String[] last) throws NumberFormatException, Exception
	 {
			// TODO Auto-generated method stub
		 CMPDocumentLog.CMPDocumentLogger.info("Starting getWorkitems function ");
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

				CMPDocumentLog.CMPDocumentLogger.info("last[0] : "+last[0]);
			}
			CMPDocumentLog.CMPDocumentLogger.info("Exiting getWorkitems function");
			return workItems;
		}
	 
	 private WorkItem getWI(String sessionId, Node inst) throws NumberFormatException, IOException, Exception
		{
			CMPDocumentLog.CMPDocumentLogger.info("Starting getWI function");
			WorkItem wi = new WorkItem();
			wi.processInstanceId = CommonMethods.getTagValues(inst, "ProcessInstanceId");
			wi.workItemId = CommonMethods.getTagValues(inst, "WorkItemId");
			String fetchAttributeInputXML="";
			String fetchAttributeOutputXML="";
			sessionCheckInt=0;
			while(sessionCheckInt<loopCount)
	        {
				fetchAttributeInputXML = CommonMethods.getFetchWorkItemAttributesXML(cabinetName,sessionId,wi.processInstanceId, wi.workItemId);
				CMPDocumentLog.CMPDocumentLogger.info("FetchAttributeInputXMl "+fetchAttributeInputXML);
				fetchAttributeOutputXML=WFNGExecute(fetchAttributeInputXML,jtsIP,Integer.parseInt(jtsPort),1);
				fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("&","&amp;");
				//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll("<","&lt;");
				//fetchAttributeOutputXML=fetchAttributeOutputXML.replaceAll(">","&gt;");
				CMPDocumentLog.CMPDocumentLogger.info("fetchAttributeOutputXML "+fetchAttributeOutputXML);
				if (CommonMethods.getTagValues(fetchAttributeOutputXML, "MainCode").equalsIgnoreCase("11"))
				{
					sessionId  = CommonConnection.getSessionID(CMPDocumentLog.CMPDocumentLogger, false);

				} else {
						sessionCheckInt++;
						break;
						}

				if (CommonMethods.getMainCode(fetchAttributeOutputXML) != 0)
				{
					CMPDocumentLog.CMPDocumentLogger.debug(" MapXML.getMainCode(fetchAttributeOutputXML) != 0 ");
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
				CMPDocumentLog.CMPDocumentLogger.debug("Inside catch of get wi function with exception.."+e);
			}
			CMPDocumentLog.CMPDocumentLogger.info("Exiting getWI function");
			return wi;
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
	 
	 public static String WFNGExecute(String ipXML, String serverIP,
				int serverPort, int flag) throws IOException, Exception {
		 String jtsPort=""+serverPort;
			if (jtsPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, serverIP, serverPort, flag);
			else
				return ngEjbClientCMPDocument.makeCall(serverIP, serverPort + "", "WebSphere",
						ipXML);
		}
}
