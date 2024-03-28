/*
 * Author:Suraj Kumar Verma
 * data-29-08-2021
 */

package com.newgen.DormancyChanges;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class DormancyChanges implements Runnable {

	private static NGEjbClient ngEjbClientDormancyChanges;

	static Map<String, String> DormancyChangesConfigParamMap = new HashMap<String, String>();
	static String dateTime = "";

	@Override
	public void run() 
	{
		String sessionID = "";
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		int sleepIntervalInMin = 0;
		try
		{
			DormancyChangesLog.setLogger();
			ngEjbClientDormancyChanges = NGEjbClient.getSharedInstance();

			DormancyChangesLog.DormancyChangeLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			DormancyChangesLog.DormancyChangeLogger.debug("configReadStatus " + configReadStatus);
			if (configReadStatus != 0) 
			{
				DormancyChangesLog.DormancyChangeLogger.error("Could not Read Config Properties [DormancyChange]");
				return;
			}
			cabinetName = CommonConnection.getCabinetName();
			DormancyChangesLog.DormancyChangeLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			DormancyChangesLog.DormancyChangeLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			DormancyChangesLog.DormancyChangeLogger.debug("JTSPORT: " + jtsPort);

			sleepIntervalInMin = Integer.parseInt(DormancyChangesConfigParamMap.get("SleepIntervalInMin"));
			DormancyChangesLog.DormancyChangeLogger.debug("SleepIntervalInMin: " + sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(DormancyChangesLog.DormancyChangeLogger, false);

			if (sessionID.trim().equalsIgnoreCase(""))
			{
				DormancyChangesLog.DormancyChangeLogger.debug("Could Not Connect to Server!");
			} 
			else
			{
				DormancyChangesLog.DormancyChangeLogger.debug("Session ID found: " + sessionID);

				while (true) 
				{
					DormancyChangesLog.setLogger();
					DormancyChangesLog.DormancyChangeLogger.debug("Dormancy Changes..123.");
					sessionID = CommonConnection.getSessionID(DormancyChangesLog.DormancyChangeLogger, false);
					startUtilityDormancyChanges(cabinetName, sessionID, jtsIP, jtsPort);  //Starting Utility
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin * 60 * 1000);
				}
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in Dormancy Changes: " + e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in Dormancy Changes: " + result);
		}
	}

	private int readConfig() 
	{
		Properties p = null;
		try 
		{
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigFiles"
					+ File.separator + "Dormancy_Changes_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements()) 
			{
				String name = (String) names.nextElement();
				DormancyChangesConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1;
		}
		return 0;
	}
	private static List<String> readTextFile(File file) throws IOException  //Read the text file
	{
		FileReader fr = new FileReader(file);
		BufferedReader br = new BufferedReader(fr);
		String line;
		List<String> CIFs = new ArrayList<String>();      //extracting the data into the list
		DormancyChangesLog.DormancyChangeLogger.info("Reading text file using FileReader");
		while ((line = br.readLine()) != null)
		{
			line=line.trim();
			if(!line.equalsIgnoreCase(""))
			{
				char first_letter=' ';
				try 
				{
					first_letter = line.charAt(0);
				}
				catch(Exception e)
				{
					DormancyChangesLog.DormancyChangeLogger.debug("Exception Occured in file first letter reading  : " + e.getMessage());
				}
				if (first_letter == 'B') 
				{
					String tempCif = line.substring(2);
					DormancyChangesLog.DormancyChangeLogger.info("tempCif while reading from text: "+tempCif);
					if(!"".equalsIgnoreCase(tempCif))
						CIFs.add(tempCif);
				} 
				else if(first_letter == 'H')
				{
					String []tmp = line.split("\\|");
					try {
						dateTime = tmp[1];
					}
					catch(Exception e)
					{
						DormancyChangesLog.DormancyChangeLogger.debug("Exception Occured in file reading : " + e.getMessage());
					}
					
					DormancyChangesLog.DormancyChangeLogger.info("date time from text: "+dateTime);
				}
			}
		}
		//CIFs.stream().forEach(DormancyChangesLog.DormancyChangeLogger::debug);
		br.close();
		fr.close();
		return CIFs;
	}

	/*** Main Utility function ***/
	
	private static void startUtilityDormancyChanges(String cabinetName, String sessionId, String JtsIp,String JtsPort) 
	{
		try 
		{
			String strfullFileName = "";
			String strDocumentName = "";
			String FilePath = DormancyChangesConfigParamMap.get("filePath");
			DormancyChangesLog.DormancyChangeLogger.debug("filePath: " + FilePath);
			String failDestFilePath = DormancyChangesConfigParamMap.get("failDestFilePath");
			DormancyChangesLog.DormancyChangeLogger.debug("filePath: " + failDestFilePath);
			String destFilePath = DormancyChangesConfigParamMap.get("destFilePath");
			DormancyChangesLog.DormancyChangeLogger.debug("filePath: " + destFilePath);
			File folder = new File(FilePath); // RAKFolder
			File[] listOfFiles = folder.listFiles();
			String processTable="";
			String status="";
			for (File file : listOfFiles)
			{
				DormancyChangesLog.DormancyChangeLogger.info("File : " + file);
				if (file.isFile()) 
				{
					strfullFileName = file.getName();
					DormancyChangesLog.DormancyChangeLogger.info(" strfullFileName : " + strfullFileName);
					dateTime = "";
					strDocumentName = strfullFileName.substring(0, strfullFileName.lastIndexOf("."));
					//DormancyChangesLog.DormancyChangeLogger.info("Document type:"+strDocumentName.equalsIgnoreCase("ActiveToDormant"));
					
					if (strDocumentName.contains("ActiveToDormant") || strDocumentName.contains("Active to Dormant") ||strDocumentName.contains("Active_TO_Dormant") || strDocumentName.contains("Active_to_Dormant"))
						strDocumentName = "ActiveToDormant";
					
					if (strDocumentName.contains("DormantToActive") || strDocumentName.contains("Dormant to Active") || strDocumentName.contains("Dormant_TO_Active") || strDocumentName.contains("Dormant_to_Active"))
						strDocumentName = "DormantToActive";
					
					if (strDocumentName.equalsIgnoreCase("ActiveToDormant")) //On the basis of file chosen the table is for storing CIF's Records
					{
						processTable="USR_0_Dorm_ActiveToDormantFileData";
						status="A";
					}
					else if (strDocumentName.equalsIgnoreCase("DormantToActive"))
					{
						processTable="USR_0_Dorm_DormantTOActiveFileData";
						status="D";
					} 
					else 
					{
						//ERROR DETAILS TABLE--
						String columnValues1="'NA','NA','NA','NA',getdate(),'File Name "+strfullFileName+" is not appropriate'";
						String errorRes1=InsertIntoDB.ErrorDetailsInsertion(cabinetName, sessionId, JtsIp, JtsPort,columnValues1);
						if(errorRes1.equalsIgnoreCase("Pass"))
						{
							DormancyChangesLog.DormancyChangeLogger.info("error table updated");
						}
						else
						{
							DormancyChangesLog.DormancyChangeLogger.info("failed to update error table");
						}
						//Mail Trigger
						String mailColumnValue=""+DormancyChangesConfigParamMap.get("FromMailId")+","+DormancyChangesConfigParamMap.get("ToMailId")+",'Dormancy Change Utility has failed',"
								+ "'Dear Team: We are facing issue as text file name "+strfullFileName+" is not appropriate','text/html;charset=UTF-8','1','N','CUSTOM','TRIGGER',getdate(),'5'";
						String mailerrorRes1=InsertIntoDB.mailQueueInsertion(cabinetName, sessionId, JtsIp, JtsPort,mailColumnValue);
						if(mailerrorRes1.equalsIgnoreCase("Pass"))
						{
							DormancyChangesLog.DormancyChangeLogger.info("Mail Inserted in the table");
						}
						else
						{
							DormancyChangesLog.DormancyChangeLogger.info("failed to update mail queue table");
						}
						DormancyChangesLog.DormancyChangeLogger.error("File Name isn't appropriate :" + strDocumentName);
					}
				
					List<String> CifDetails = readTextFile(file);
					String resp=""; 
					if(!CifDetails.isEmpty())
					{
						 resp = InsertIntoDB.insertToDB(CifDetails, strfullFileName, dateTime, cabinetName,
								sessionId, JtsIp, JtsPort,processTable,status); //Inserting the text file records into the database
					}
					else
					{
						resp="Pass"; //Intialize Pass if no CIF in the File
					}
					if(resp.equalsIgnoreCase("Pass"))
					{
						String TimeStamp=get_timestamp();
						DormancyChangesLog.DormancyChangeLogger.info(new File(destFilePath+File.separator+file.getName()+"_"+TimeStamp));
						if (file.renameTo(new File(destFilePath+File.separator+file.getName()+"_"+TimeStamp)))
						{
							file.delete();
							System.out.println("File moved successfully");
							DormancyChangesLog.DormancyChangeLogger.info("File moved successfully");
						} 
						else 
						{
							System.out.println("Failed to move the file");
							DormancyChangesLog.DormancyChangeLogger.info("Failed to move the file");
						}
					}
					else
					{
						//ERROR DETAILS TABLE 
						String columnValues2="'"+processTable+"','NA','NA','iBPS',getdate(),'Utility is not able to processed text file.'";
						String errorRes2=InsertIntoDB.ErrorDetailsInsertion(cabinetName, sessionId, JtsIp, JtsPort,columnValues2);
						if(errorRes2.equalsIgnoreCase("Pass"))
						{
							DormancyChangesLog.DormancyChangeLogger.info("error table updated");
						}
						else
						{
							DormancyChangesLog.DormancyChangeLogger.info("failed to update error table");
						}
						String mailColumnValue2="'"+DormancyChangesConfigParamMap.get("FromMailId")+"','"+DormancyChangesConfigParamMap.get("ToMailId")+"','Dormancy Chnage Utility has failed','Dear Team:"
								+ "we faced issue FOR following:Utility has failed due text file error','text/html;charset=UTF-8','1','N','CUSTOM','TRIGGER',getdate(),'5'";
						String mailerrorRes2=InsertIntoDB.mailQueueInsertion(cabinetName, sessionId, JtsIp, JtsPort,mailColumnValue2);
						if(mailerrorRes2.equalsIgnoreCase("Pass"))
						{
							DormancyChangesLog.DormancyChangeLogger.info("Mail Inserted in the table");
						}
						else
						{
							DormancyChangesLog.DormancyChangeLogger.info("failed to update mail queue table");
						}
						
						String TimeStamp=get_timestamp();
						if (file.renameTo(new File(failDestFilePath+File.separator+file.getName()+"_"+TimeStamp)))
						{
							// if file copied successfully then delete the original file
							file.delete();
							System.out.println("File moved successfully");
							DormancyChangesLog.DormancyChangeLogger.info("File moved successfully");
						}
						else
						{
							System.out.println("Failed to move the file");
							DormancyChangesLog.DormancyChangeLogger.info("Failed to move the file");
						}
					} 
				}
			}
			
			String cifDetailsQuery ="SELECT FILE_NAME,FILE_CREATION_DATETIME,SEARCH_FIELD,DATACLASS_NAME,INDEX_FIELDNAME,"
					+ "iBPS_DATADEF_INDEX,iBPS_INDEX_ID,OF_DATADEF_INDEX,OF_INDEX_ID,DATACLASS_TYPE,iBPS_STATUS,OF_STATUS FROM USR_0_Dorm_SearchFieldDataClassMapping with (nolock) WHERE iBPS_STATUS='N' OR OF_STATUS='N'"; 
			//DormancyChangesLog.DormancyChangeLogger.debug("Table Name: "+USR_0_Dorm_SearchFieldDataClassMapping);
			
			String cifDetailsInputXML =CommonMethods.apSelectWithColumnNames(cifDetailsQuery, cabinetName, sessionId);
			DormancyChangesLog.DormancyChangeLogger.debug("cifDetails details APSelect InputXML: "+cifDetailsInputXML);

			String cifDetailsOutputXML=CommonMethods.WFNGExecute(cifDetailsInputXML,JtsIp,JtsPort,1);
			DormancyChangesLog.DormancyChangeLogger.debug("cifDetails Details APSelect OutputXML: "+cifDetailsOutputXML);

			XMLParser xmlParserCifDetails= new XMLParser(cifDetailsOutputXML);
			String cifDetailsMainCode = xmlParserCifDetails.getValueOf("MainCode");
			DormancyChangesLog.DormancyChangeLogger.debug("MainCode: "+cifDetailsMainCode);

			int cifDataClassRecords = Integer.parseInt(xmlParserCifDetails.getValueOf("TotalRetrieved"));
			DormancyChangesLog.DormancyChangeLogger.debug("cifDataClassRecords: "+cifDataClassRecords);

			if(cifDetailsMainCode.equalsIgnoreCase("0")&& cifDataClassRecords>0)
			{
				for(int i=0;i<cifDataClassRecords;i++)
				{
					
					String xmlCIFDetails=xmlParserCifDetails.getNextValueOf("Record");
					XMLParser xmlParserCifDetailsRecord = new XMLParser(xmlCIFDetails);
					
					String cifID=xmlParserCifDetailsRecord.getValueOf("SEARCH_FIELD");
					DormancyChangesLog.DormancyChangeLogger.debug("CIF: "+cifID);
					
					String UpdateStatus_iBPS=xmlParserCifDetailsRecord.getValueOf("iBPS_STATUS");
					DormancyChangesLog.DormancyChangeLogger.debug("iBPS_STATUS: "+UpdateStatus_iBPS);
					
					String UpdateStatus_OF=xmlParserCifDetailsRecord.getValueOf("OF_STATUS");
					DormancyChangesLog.DormancyChangeLogger.debug("OF_STATUS: "+UpdateStatus_OF);
					
					String FileName = xmlParserCifDetailsRecord.getValueOf("FILE_NAME");
					DormancyChangesLog.DormancyChangeLogger.debug("FILE_NAME: "+FileName);
					
					String fileDateTime = xmlParserCifDetailsRecord.getValueOf("FILE_CREATION_DATETIME");
					DormancyChangesLog.DormancyChangeLogger.debug("iBPS info:");
					String iBPS_dataDefIndex=xmlParserCifDetailsRecord.getValueOf("iBPS_DATADEF_INDEX");
					DormancyChangesLog.DormancyChangeLogger.debug("Data Def Id: "+iBPS_dataDefIndex);
					
	
					String iBPS_indexId=xmlParserCifDetailsRecord.getValueOf("iBPS_INDEX_ID");
					DormancyChangesLog.DormancyChangeLogger.debug("indexId details " +iBPS_indexId);
	
					DormancyChangesLog.DormancyChangeLogger.debug("Omniflow info:");
					
					String oF_dataDefIndex=xmlParserCifDetailsRecord.getValueOf("OF_DATADEF_INDEX");
					DormancyChangesLog.DormancyChangeLogger.debug("Data Def Id: "+oF_dataDefIndex);
					
	
					String oF_indexId=xmlParserCifDetailsRecord.getValueOf("OF_INDEX_ID");
					DormancyChangesLog.DormancyChangeLogger.debug("indexId details " +oF_indexId);
					
					String dataClassType=xmlParserCifDetailsRecord.getValueOf("DATACLASS_TYPE");
					DormancyChangesLog.DormancyChangeLogger.debug("indexId details " +dataClassType);
				
					DormancyChangesLog.DormancyChangeLogger.debug("Fetching data class Details.");
					
					if("N".equalsIgnoreCase(UpdateStatus_iBPS))
					{
						String iBPS_Status=SocketServices.SearchNGOFolder(cabinetName,sessionId,iBPS_dataDefIndex,iBPS_indexId,cifID,JtsIp,JtsPort,dataClassType
								,cabinetName,sessionId,JtsIp,JtsPort,"USR_0_Dorm_SearchFieldDataClassMapping","iBPS",DormancyChangesConfigParamMap);
						DormancyChangesLog.DormancyChangeLogger.info("Search folder Status iBPS" +iBPS_Status);
						
						/* Status updating for iBPS*/
						
						UpdateStatus_iBPS=(iBPS_Status.equalsIgnoreCase("Success"))?"Y":(iBPS_Status.equalsIgnoreCase("E"))?"E":"N";
						//UpdateStatus_iBPS=(iBPS_Status.equalsIgnoreCase("Success"))?"Y":"N";
						String ColNames = "iBPS_STATUS,iBPS_ACT_DATETIME";
						String ColValues = "'"+UpdateStatus_iBPS+"',getdate()";
						String iBPS_Status_InputXML=CommonMethods.apUpdateInput(cabinetName,sessionId,"USR_0_Dorm_SearchFieldDataClassMapping",
								ColNames,ColValues,"SEARCH_FIELD='"+cifID+"' AND FILE_NAME='"+FileName+"' AND FILE_CREATION_DATETIME='"+fileDateTime+"' AND iBPS_DATADEF_INDEX='"+iBPS_dataDefIndex+"' ");
						DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + iBPS_Status_InputXML);
						String iBPS_Status_OutputXML = CommonMethods.WFNGExecute(iBPS_Status_InputXML, JtsIp, JtsPort, 1);
						DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +iBPS_Status_OutputXML);
						XMLParser xmlParserUpdateTable = new XMLParser(iBPS_Status_OutputXML);
						String Main_Code_Status= xmlParserUpdateTable.getValueOf("MainCode");
						if(Main_Code_Status.equalsIgnoreCase("0"))
						{
							DormancyChangesLog.DormancyChangeLogger.debug("iBPS Status Updated:" + Main_Code_Status);
						}
						else
						{
							DormancyChangesLog.DormancyChangeLogger.debug("iBPS Status Update failed:" + Main_Code_Status);
						}
					}
					
				    if("N".equalsIgnoreCase(UpdateStatus_OF))
					{
						String OF_Status=SocketServices.SearchNGOFolder(cabinetName,sessionId,oF_dataDefIndex,oF_indexId,cifID,JtsIp,JtsPort,dataClassType,
								CommonConnection.getOFCabinetName(), CommonConnection.getOFSessionID(DormancyChangesLog.DormancyChangeLogger, false),
								CommonConnection.getOFJTSIP(),CommonConnection.getOFJTSPort(),"USR_0_Dorm_SearchFieldDataClassMapping","OF",DormancyChangesConfigParamMap);
						
						DormancyChangesLog.DormancyChangeLogger.info("Search folder Status OF :" + OF_Status);
						/* Status updating for Omniflow*/
						
						UpdateStatus_OF=(OF_Status.equalsIgnoreCase("Success"))?"Y":(OF_Status.equalsIgnoreCase("E"))?"E":"N";
						
						String ColNames1 = "OF_STATUS,OF_ACT_DATETIME";
						String ColValues1 = "'"+UpdateStatus_OF+"',getdate()";
						String oF_Status_InputXML=CommonMethods.apUpdateInput(cabinetName,sessionId,"USR_0_Dorm_SearchFieldDataClassMapping",
								ColNames1,ColValues1,"SEARCH_FIELD='"+cifID+"' AND FILE_NAME='"+FileName+"' AND FILE_CREATION_DATETIME='"+fileDateTime+"' AND OF_DATADEF_INDEX='"+oF_dataDefIndex+"' ");
						DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + oF_Status_InputXML);
						String oF_Status_OutputXML = CommonMethods.WFNGExecute(oF_Status_InputXML, JtsIp, JtsPort, 1);
						DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +oF_Status_OutputXML);
						XMLParser xmlParserOFStatusTable = new XMLParser(oF_Status_OutputXML);
						String MainCode_Status2= xmlParserOFStatusTable.getValueOf("MainCode");
						if(MainCode_Status2.equalsIgnoreCase("0"))
						{
							DormancyChangesLog.DormancyChangeLogger.debug("OF Status Updated:" + MainCode_Status2);
						}
						else
						{
							DormancyChangesLog.DormancyChangeLogger.debug("OF Status Update failed:" + MainCode_Status2);
						}
					}
				    
				    if(("Y".equalsIgnoreCase(UpdateStatus_iBPS) || "E".equalsIgnoreCase(UpdateStatus_iBPS)) 
							&& ("Y".equalsIgnoreCase(UpdateStatus_OF) || "E".equalsIgnoreCase(UpdateStatus_OF)) )
					{
				    	
				    	UpdateStatus_iBPS = "Y";
				    	UpdateStatus_OF = "Y";
				    	String sQuery ="Select iBPS_STATUS,OF_STATUS FROM USR_0_Dorm_SearchFieldDataClassMapping with (nolock) WHERE SEARCH_FIELD='"+cifID+"' AND FILE_NAME='"+FileName+"' AND FILE_CREATION_DATETIME='"+fileDateTime+"' "; 
						//DormancyChangesLog.DormancyChangeLogger.debug("Table Name: "+USR_0_Dorm_SearchFieldDataClassMapping);
						
						String InputXML =CommonMethods.apSelectWithColumnNames(sQuery, cabinetName, sessionId);
						DormancyChangesLog.DormancyChangeLogger.debug("sQuery APSelect InputXML: "+sQuery);

						String OutputXML=CommonMethods.WFNGExecute(InputXML,JtsIp,JtsPort,1);
						DormancyChangesLog.DormancyChangeLogger.debug("sQuery APSelect OutputXML: "+OutputXML);

						XMLParser xmlParseDetails= new XMLParser(OutputXML);
						String MainCode = xmlParseDetails.getValueOf("MainCode");
						DormancyChangesLog.DormancyChangeLogger.debug("MainCode: "+MainCode);

						int iRecords = Integer.parseInt(xmlParseDetails.getValueOf("TotalRetrieved"));
						DormancyChangesLog.DormancyChangeLogger.debug("iRecords: "+iRecords);

						if(MainCode.equalsIgnoreCase("0")&& iRecords>0)
						{
							for(int j=0;j<iRecords;j++)
							{
								
								String xmlDetails=xmlParseDetails.getNextValueOf("Record");
								XMLParser xmlParserRecord = new XMLParser(xmlDetails);
								
								String iBPSStatus=xmlParserRecord.getValueOf("iBPS_STATUS");
								String OFStatus=xmlParserRecord.getValueOf("OF_STATUS");
								
								if("N".equalsIgnoreCase(iBPSStatus))
								{
									UpdateStatus_iBPS = "";
								}
								
								if("N".equalsIgnoreCase(OFStatus))
								{
									UpdateStatus_OF="";
								}
								if("E".equalsIgnoreCase(iBPSStatus))
								{
									UpdateStatus_iBPS = "E";
								}
								
								if("E".equalsIgnoreCase(OFStatus))
								{
									UpdateStatus_OF = "E";
								}
								
								if("".equalsIgnoreCase(UpdateStatus_iBPS) || "".equalsIgnoreCase(UpdateStatus_OF)) 
									break;
							}
						}	
				    	
						
						//String statusFinal = "E";
						
						if(("Y".equalsIgnoreCase(UpdateStatus_iBPS) && "Y".equalsIgnoreCase(UpdateStatus_OF))
								|| ("E".equalsIgnoreCase(UpdateStatus_iBPS) || "E".equalsIgnoreCase(UpdateStatus_OF))
								)
						{	
							String statusFinal = "Y";
						
							String ColNames2 = "iBPS_STATUS,iBPS_ACT_DATETIME,OF_STATUS,OF_ACT_DATETIME,FINAL_STATUS,FINAL_STATUS_DATETIME";
							String ColValues2 = "'"+UpdateStatus_iBPS+"',getdate(),'"+UpdateStatus_OF+"',getdate(),'"+statusFinal+"',getdate()";
							processTable=(dataClassType.equalsIgnoreCase("A"))?"USR_0_Dorm_ActiveToDormantFileData":"USR_0_Dorm_DormantTOActiveFileData";
							String updateStatusInputXML=CommonMethods.apUpdateInput(cabinetName,sessionId,processTable,
									ColNames2,ColValues2,"SEARCH_FIELD='"+cifID+"' AND FILE_NAME='"+FileName+"' AND FILE_CREATION_DATATIME='"+fileDateTime+"'");
							DormancyChangesLog.DormancyChangeLogger.debug("Input XML created successfully:" + updateStatusInputXML);
							String updateStatusOutputXML = CommonMethods.WFNGExecute(updateStatusInputXML, JtsIp, JtsPort, 1);
							DormancyChangesLog.DormancyChangeLogger.debug("Output XML created successfully:" +updateStatusOutputXML);
							XMLParser xmlParserStatusTable = new XMLParser(updateStatusOutputXML);
							String UpdateStatus1= xmlParserStatusTable.getValueOf("MainCode");
							if(UpdateStatus1.equalsIgnoreCase("0"))
							{
								DormancyChangesLog.DormancyChangeLogger.debug("Status Updated:" +processTable);
							}
							else
							{
								DormancyChangesLog.DormancyChangeLogger.debug("Status Update failed:" + processTable);
							}
						}
					}
				}
			}	
		}
		catch (Exception e)
		{
			e.printStackTrace();
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in Dormancy Changes: " + e.getMessage());
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DormancyChangesLog.DormancyChangeLogger.error("Exception Occurred in Dormancy Changes: " + result);
		}
	}

	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort, int flag)
	{
		DormancyChangesLog.DormancyChangeLogger.debug("In WF NG Execute : " + serverPort);
		try 
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP, Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientDormancyChanges.makeCall(jtsServerIP, serverPort, "WebSphere", ipXML);
		}
		catch (Exception e)
		{
			DormancyChangesLog.DormancyChangeLogger.debug("Exception Occured in WF NG Execute : " + e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	
	public static String get_timestamp()
	{
		Date present = new Date();
		Format pformatter = new SimpleDateFormat("dd-MM-yyyy-hhmmss");
		String TimeStamp=pformatter.format(present);
		return TimeStamp;
	}
	
}
