package com.newgen.TWC_Copy_Profile;

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
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.io.FileUtils;
import org.xml.sax.SAXException;

import com.newgen.FPUCreateWIFromTextFile.CreateWIFromTextFileLog;
import com.newgen.SAR.CSVWICreation.SARWICreationLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.excp.NGException;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;
import com.newgen.wfdesktop.xmlapi.WFInputXml;
import com.newgen.wfdesktop.xmlapi.WFXmlList;
import com.newgen.wfdesktop.xmlapi.WFXmlResponse;

import ISPack.CImageServer;
import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;
import Jdts.DataObject.JPDBString;

public class TWC_CopyProfile implements Runnable {


	static Map<String, String> TWC_CopyProfileConfigParamMap = new HashMap<String, String>();
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
	public static String ProcessDefID="";
	public static String activityId="";
	public static String activityName= "";
	public static String queueId= "";
	public static String deleteSuccessDataBeforeDays;
	public static String histTable="";
	public static String DocName="";
	private static String downloadDocPath="";
	private static String GridTableName="";
	private static HashMap<String,List<String>> GridTableColumns=new HashMap ();
	
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
			TWC_CP_Logs.setLogger();

			int configReadStatus = readConfig();

			TWC_CP_Logs.TWC_CP_Logger.debug("configReadStatus " + configReadStatus);
			if (configReadStatus != 0) 
			{
				TWC_CP_Logs.TWC_CP_Logger.error("Could not Read Config Properties [TWC_CopyProfile_Config]");
				return;
			}
			else
			{
				
				ProcessDefID= TWC_CopyProfileConfigParamMap.get("ProcessDefID");
			    activityId= TWC_CopyProfileConfigParamMap.get("ActivityId");
			    activityName= TWC_CopyProfileConfigParamMap.get("ActivityName");
			    queueId= TWC_CopyProfileConfigParamMap.get("QueueID");
			    deleteSuccessDataBeforeDays= TWC_CopyProfileConfigParamMap.get("DeleteSuccessDataBeforeDays");
			    histTable=TWC_CopyProfileConfigParamMap.get("HISTORYTABLENAME");
			    DocName=TWC_CopyProfileConfigParamMap.get("DocumentName");
			    fromMailID=TWC_CopyProfileConfigParamMap.get("FromMailId");
				toMailID=TWC_CopyProfileConfigParamMap.get("ToMailId");
				downloadDocPath=TWC_CopyProfileConfigParamMap.get("DownloadDocPath");
				GridTableName=TWC_CopyProfileConfigParamMap.get("GridTableName");
			}
			cabinetName = CommonConnection.getCabinetName();
			TWC_CP_Logs.TWC_CP_Logger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			TWC_CP_Logs.TWC_CP_Logger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			TWC_CP_Logs.TWC_CP_Logger.debug("JTSPORT: " + jtsPort);

			sleepIntervalInMin = Integer.parseInt(TWC_CopyProfileConfigParamMap.get("SleepIntervalInMin"));
			TWC_CP_Logs.TWC_CP_Logger.debug("SleepIntervalInMin: " + sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(TWC_CP_Logs.TWC_CP_Logger, false);

			if (sessionID.trim().equalsIgnoreCase(""))
			{
				TWC_CP_Logs.TWC_CP_Logger.debug("Could Not Connect to Server!");
			} 
			else
			{
				TWC_CP_Logs.TWC_CP_Logger.debug("Session ID found: " + sessionID);
				getColumnNameForGridTable();

				while (true) 
				{
					TWC_CP_Logs.setLogger();
					TWC_CP_Logs.TWC_CP_Logger.debug("Create Work Item for Copy Profile..123.");
					startUtilityTWC_CopyProfile();
					TWC_CP_Logs.TWC_CP_Logger.debug("No More workitems to Process, Sleeping!");
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin * 60 * 1000);
				}
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			TWC_CP_Logs.TWC_CP_Logger.error("Exception Occurred in CreateWIFromTextFie: " + e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			TWC_CP_Logs.TWC_CP_Logger.error("Exception Occurred in CreateWIFromTextFie: " + result);
		}
	}
	private int readConfig() 
	{
		Properties p = null;
		try 
		{
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigFiles"
					+ File.separator + "TWC_CopyProfile_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements()) 
			{
				String name = (String) names.nextElement();
				TWC_CopyProfileConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1;
		}
		return 0;
	}
	private static void startUtilityTWC_CopyProfile() 
	{
		TWC_CP_Logs.TWC_CP_Logger.info("Inside TWC_CopyProfile..");
		try
		{
			WFXmlList objWorkList=null;
			WFXmlResponse xmlParserData=new WFXmlResponse();
			
			String query="select Reference_No,Sel_WI_No,CIF_Id,TL_Number,Customer_Name,Searched_WI_Stage,Searched_WI_Created_DT,Searched_WI_Actioned_DT,Searched_WI_Init_Channel,Searched_WI_Environment,sub_user_name,isnull((select MailId from PDBUser with(nolock) where USERNAME=sub_user_name ),(select DistinguishedName from PDBDOMAINUSER with(nolock) where USERNAME=sub_user_name) ) as Email,(select comment from pdbuser with(nolock) where UserName=sub_user_name) as Sole_ID  FROM USR_0_TWC_Copy_Profile_Details WITH( Nolock ) WHERE (New_WI_Creation_Flag is null or New_WI_Creation_Flag = '' or New_WI_Creation_Flag != 'Success') ORDER BY Sub_Date_Time";
			String sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			TWC_CP_Logs.TWC_CP_Logger.info("Get row data to create WI "+sInputXML);
			String sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
			xmlParserData.setXmlString(sOutputXML);
			String MaincodeTemp=xmlParserData.getVal("MainCode");
			TWC_CP_Logs.TWC_CP_Logger.info("Get row data MainCode = "+MaincodeTemp);
			String RecordCount=xmlParserData.getVal("TotalRetrieved");
			if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
			{
				objWorkList = xmlParserData.createList("Records", "Record");
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{
					String Sel_WI_No=objWorkList.getVal("Sel_WI_No");
					TWC_CP_Logs.TWC_CP_Logger.info("WI no which need to be copied = "+Sel_WI_No);
					String Sel_WI_Environment=objWorkList.getVal("Searched_WI_Environment");
					TWC_CP_Logs.TWC_CP_Logger.info("WI Environmemt = "+Sel_WI_Environment);
					String referenceNo=objWorkList.getVal("Reference_No");
					TWC_CP_Logs.TWC_CP_Logger.info("Reference_No = "+referenceNo);
					String emailID=objWorkList.getVal("Email");
					TWC_CP_Logs.TWC_CP_Logger.info("Email = "+emailID);
					String Sole_ID=objWorkList.getVal("Sole_ID");
					TWC_CP_Logs.TWC_CP_Logger.info("Sole_ID = "+Sole_ID);
					String sub_user_name=objWorkList.getVal("sub_user_name");
					TWC_CP_Logs.TWC_CP_Logger.info("sub_user_name = "+sub_user_name);
					
					if("IBPS".equalsIgnoreCase(Sel_WI_Environment))
					{
						copyProfileFromIBPS(Sel_WI_No,referenceNo,emailID,Sel_WI_Environment,Sole_ID,sub_user_name);
					}
					else if("BPM-OF".equalsIgnoreCase(Sel_WI_Environment)||"OMNIFLOW".equalsIgnoreCase(Sel_WI_Environment))
					{
						copyProfileFromOF(Sel_WI_No,referenceNo,emailID,Sel_WI_Environment,Sole_ID,sub_user_name);
					}
					else
					{
						TWC_CP_Logs.TWC_CP_Logger.info("Not a valid selected WI environment "+Sel_WI_Environment);
					}
				}
			}
			
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.info("Error in frtching records from DB table "+ e.toString());
		}
		
	}
	private static void copyProfileFromIBPS(String Sel_WI_NO,String refNo,String toemailID,String env,String Sole_ID,String SubUser)
	{
		try
		{
			String DocumentsTag="";//getDocumentTagofIBPS(Sel_WI_NO);
			String attributeTag = getAttributeTag(Sel_WI_NO,cabinetName,jtsIP,jtsPort,env,Sole_ID,SubUser);
			String Status=createSingleWorkItem(attributeTag,DocumentsTag);
			TWC_CP_Logs.TWC_CP_Logger.error("Work Item data received from createSingleWorkItem  -!"+Status);
			String statusArr[] = Status.split("~");
			if(statusArr.length==4)
			{
				if("Success".equalsIgnoreCase(statusArr[0]))
				{
					String WorkItemNumber=statusArr[1];
					String CreationDateTime=statusArr[2];
					String createWIStatus=statusArr[0];
					String createWIremarks=statusArr[3];
					update_TWC_CP_Request_Details(Sel_WI_NO,refNo,createWIStatus,WorkItemNumber,CreationDateTime);
					Status=UpdateWIHistory(cabinetName,sessionID,WorkItemNumber,"Submit",CreationDateTime,createWIremarks);
					if("0".equalsIgnoreCase(Status))
					{
						copyGridData(WorkItemNumber,Sel_WI_NO,cabinetName,jtsIP,jtsPort);
						sendMail(toemailID,WorkItemNumber,refNo);
					}
					
				}
				else
				{
					TWC_CP_Logs.TWC_CP_Logger.error("Error in create work item -!"+statusArr[0]);	
				}
			}
			else
			{
				TWC_CP_Logs.TWC_CP_Logger.error("Error in create work item -!"+Arrays.toString(statusArr));
			}
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.error("Exceptione in copyProfileFromIBPS -!"+e.toString());
		}
		
	}
	private static void copyProfileFromOF(String Sel_WI_NO,String refNo,String toemailID,String env,String Sole_ID,String subUser)
	{
		try
		{
			String ofCabinetName=CommonConnection.getOFCabinetName();
			String ofJTSIP=CommonConnection.getOFJTSIP();
			String ofJTSPort=CommonConnection.getOFJTSPort();
			//String ofSessionID=CommonConnection.getOFSessionID(TWC_CP_Logs.TWC_CP_Logger, true);
			String DocumentsTag="";//getDocumentTagofOF(Sel_WI_NO,ofJTSIP,ofJTSPort,ofCabinetName,ofSessionID);
			String Status="";
			String attributeTag = getAttributeTag(Sel_WI_NO,ofCabinetName,ofJTSIP,ofJTSPort,env,Sole_ID,subUser);
			if(!"".equalsIgnoreCase(attributeTag) && attributeTag!=null)
			Status=createSingleWorkItem(attributeTag,DocumentsTag);
			TWC_CP_Logs.TWC_CP_Logger.error("Work Item data received from createSingleWorkItem  -!"+Status);
			String statusArr[] = Status.split("~");
			if(statusArr.length==4)
			{
				if("Success".equalsIgnoreCase(statusArr[0]))
				{
					String WorkItemNumber=statusArr[1];
					String CreationDateTime=statusArr[2];
					String createWIStatus=statusArr[0];
					String createWIremarks=statusArr[3];
					
					Status=UpdateWIHistory(cabinetName,sessionID,WorkItemNumber,"Submit",CreationDateTime,createWIremarks);
					update_TWC_CP_Request_Details(Sel_WI_NO,refNo,createWIStatus,WorkItemNumber,CreationDateTime);
					if("0".equalsIgnoreCase(Status))
					{
						copyGridData(WorkItemNumber,Sel_WI_NO,ofCabinetName,ofJTSIP,ofJTSPort);
						sendMail(toemailID,WorkItemNumber,refNo);
					}
					
				}
				else
				{
					TWC_CP_Logs.TWC_CP_Logger.error("Error in create work item -!"+statusArr[0]);	
				}
			}
			else
			{
				update_TWC_CP_Request_Details(Sel_WI_NO,refNo,"Error","","");
				TWC_CP_Logs.TWC_CP_Logger.error("Error in create work item -!"+Arrays.toString(statusArr));
			}
		}
		catch(Exception e)
		{
			
		}
		
	}
	private static String getDocumentTagofIBPS(String Sel_WI_NO)
	{
		String Documentstag="";
		try
		{
			

			WFXmlList objWorkList=null;
			WFXmlResponse xmlParserData=new WFXmlResponse();
			
			String query="SELECT DocumentIndex,Name,DocumentType,ImageIndex,VolumeId,NoOfPages,DocumentSize,AppName FROM PDBDocument WITH(nolock) WHERE DocumentIndex IN (\r\n" + 
					"SELECT documentindex FROM PDBDocumentContent WITH(nolock) WHERE ParentFolderIndex = (SELECT itemindex FROM RB_TWC_EXTTABLE WITH(nolock) WHERE WI_NAME='"+Sel_WI_NO+"'))";
			String sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS "+sInputXML);
			String sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
			xmlParserData.setXmlString(sOutputXML);
			String MaincodeTemp=xmlParserData.getVal("MainCode");
			TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS = "+MaincodeTemp);
			String RecordCount=xmlParserData.getVal("TotalRetrieved");
			if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
			{
				objWorkList = xmlParserData.createList("Records", "Record");
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{
					String docIndex=objWorkList.getVal("DocumentIndex");
					TWC_CP_Logs.TWC_CP_Logger.info("DocIndex = "+docIndex);
					String Name=objWorkList.getVal("Name");
					TWC_CP_Logs.TWC_CP_Logger.info("Name = "+Name);
					String DocumentType=objWorkList.getVal("DocumentType");
					TWC_CP_Logs.TWC_CP_Logger.info("DocumentType = "+DocumentType);
					String ImageIndex=objWorkList.getVal("ImageIndex");
					TWC_CP_Logs.TWC_CP_Logger.info("ImageIndex = "+ImageIndex);
					String VolumeId=objWorkList.getVal("VolumeId");
					TWC_CP_Logs.TWC_CP_Logger.info("VolumeId = "+VolumeId);
					String NoOfPages=objWorkList.getVal("NoOfPages");
					TWC_CP_Logs.TWC_CP_Logger.info("NoOfPages = "+NoOfPages);
					String DocumentSize=objWorkList.getVal("DocumentSize");
					TWC_CP_Logs.TWC_CP_Logger.info("DocumentSize = "+DocumentSize);
					String AppName=objWorkList.getVal("AppName");
					TWC_CP_Logs.TWC_CP_Logger.info("AppName = "+AppName);
					
					if(ImageIndex!=null && !"".equalsIgnoreCase(ImageIndex))
						Documentstag+=Name+""+fieldSep+""+ImageIndex+hashChar+VolumeId+fieldSep+NoOfPages+fieldSep+DocumentSize+fieldSep+AppName+recordSep;
					TWC_CP_Logs.TWC_CP_Logger.info(" Documentstag-: "+Documentstag);
					
				}
			}
			
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.info(" Error in creating documnet tag of IBPS "+e.toString());
		}
		TWC_CP_Logs.TWC_CP_Logger.info(" Final Documentstag-: "+Documentstag);
		
		return Documentstag;
	}
	private static String getAttributeTag(String Sel_WI_NO,String CabinetName,String jtsIP,String jtsPort,String env ,String Sole_ID,String subUser)
	{
		String AttributeTag="";
		try
		{
			

			WFXmlList objWorkList=null;
			WFXmlResponse xmlParserData=new WFXmlResponse();
			String query="select WI_NAME, CIF_Id,RAK_Track_Number,Remarks,Sol_Id,Customer_Name,Reference_Number,Address_Line_1,Address_Line_2,Address_Line_3,Address_Line_4,PO_Box,Emirate,Country,Master_Facility_Limit,Non_Refundable_ProcessingFee,Related_Part_Name,FeeDebitedAccount,Notes,Total_Facility_Existing,Total_Facility_Sought,Pattern_of_Funding,Deferral_Held,TL_Number,Dec_Crops_Finalisation_Checker,Dec_Populate,Dec_Business_Approver_1st,Dec_Credit_Approver_1st,Dec_Credit_Analyst,Dec_CBRB_Checker,UIDGridCount,RO_Code,RM_Code,First_Level_Business_Approver,Second_Level_Business_Approver,First_Level_Credit_Approver,Second_Level_Credit_Approver,CBRB_Required,AECB_Required,Dec_CBRB_Maker,Dec_AECB,Price_Change_Approval_Reqd,Review_Date,MRA_Archival_Date,Product_Identifier,Limit_Amount,Mobile_Code,Mobile_Number,Landline_Number,Landline_code,Email_ID,RB5_Checks_Expired,AECB_Checks_Expired,Auto_Expiry_Business_Time,Auto_Expiry_Credit_Time,Dec_CROPS_Admin_Checker,dealingWithCountries,CBRBMaker_Done_On,AECB_Done_On,Sum_FSV,Sum_Value,dispensationSought,dispensationHeld,Clean_Exposure,SubmittedByCredit_Analyst,ARCHIVALPATH,sign_matched_cropsDisbursal_maker,FinalCreditApproverAuth,Islamic_Or_Conventional,sign_matched_cropsDeferral_checker,ReferToCreditWSName,sign_matched_cropsDisbursal_checker,sign_matched_cropsDeferral_maker,Type_Of_LA,Request_Type,Campaign_ID,Partner_Code "+ 
					  "from RB_TWC_EXTTABLE with(nolock) where WI_NAME='"+Sel_WI_NO+"'";
			if("BPM-OF".equalsIgnoreCase(env)||"OMNIFLOW".equalsIgnoreCase(env))
			{
				query="select WI_NAME, CIF_Id,RAK_Track_Number,Remarks,Sol_Id,Customer_Name,Reference_Number,Address_Line_1,Address_Line_2,Address_Line_3,Address_Line_4,PO_Box,Emirate,Country,Master_Facility_Limit,Non_Refundable_ProcessingFee,Related_Part_Name,FeeDebitedAccount,Notes,Total_Facility_Existing,Total_Facility_Sought,Pattern_of_Funding,Deferral_Held,TL_Number,Dec_Crops_Finalisation_Checker,Dec_Populate,Dec_Business_Approver_1st,Dec_Credit_Approver_1st,Dec_Credit_Analyst,Dec_CBRB_Checker,UIDGridCount,RO_Code,RM_Code,First_Level_Business_Approver,Second_Level_Business_Approver,First_Level_Credit_Approver,Second_Level_Credit_Approver,CBRB_Required,AECB_Required,Dec_CBRB_Maker,Dec_AECB,Price_Change_Approval_Reqd,Review_Date,MRA_Archival_Date,Product_Identifier,Limit_Amount,Mobile_Code,Mobile_Number,Landline_Number,Landline_code,Email_ID,RB5_Checks_Expired,AECB_Checks_Expired,Auto_Expiry_Business_Time,Auto_Expiry_Credit_Time,Dec_CROPS_Admin_Checker,dealingWithCountries,CBRBMaker_Done_On,AECB_Done_On,Sum_FSV,Sum_Value,dispensationSought,dispensationHeld,Clean_Exposure,SubmittedByCredit_Analyst,ARCHIVALPATH,sign_matched_cropsDisbursal_maker,FinalCreditApproverAuth,Islamic_Or_Conventional,sign_matched_cropsDeferral_checker,ReferToCreditWSName,sign_matched_cropsDisbursal_checker,sign_matched_cropsDeferral_maker,Type_Of_LA,Request_Type "+ 
						  "from RB_TWC_EXTTABLE with(nolock) where WI_NAME='"+Sel_WI_NO+"'";
			}
			String sInputXML = CommonMethods.apSelectWithColumnNames(query, CabinetName,"");
			TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS "+sInputXML);
			String sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
			xmlParserData.setXmlString(sOutputXML);
			String MaincodeTemp=xmlParserData.getVal("MainCode");
			TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS = "+MaincodeTemp);
			String RecordCount=xmlParserData.getVal("TotalRetrieved");
			if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
			{
				objWorkList = xmlParserData.createList("Records", "Record");
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{
					String CIF_Id = replaceXChars(objWorkList.getVal("CIF_Id"));
					String RAK_Track_Number = replaceXChars(objWorkList.getVal("RAK_Track_Number"));
					String Remarks = replaceXChars(objWorkList.getVal("Remarks"));
					String Sol_Id = replaceXChars(objWorkList.getVal("Sol_Id"));
					String Customer_Name = replaceXChars(objWorkList.getVal("Customer_Name"));
					String Reference_Number = replaceXChars(objWorkList.getVal("Reference_Number"));
					String Address_Line_1 = replaceXChars(objWorkList.getVal("Address_Line_1"));
					String Address_Line_2 = replaceXChars(objWorkList.getVal("Address_Line_2"));
					String Address_Line_3 = replaceXChars(objWorkList.getVal("Address_Line_3"));
					String Address_Line_4 = replaceXChars(objWorkList.getVal("Address_Line_4"));
					String PO_Box = replaceXChars(objWorkList.getVal("PO_Box"));
					String Emirate = replaceXChars(objWorkList.getVal("Emirate"));
					String Country = replaceXChars(objWorkList.getVal("Country"));
					String Master_Facility_Limit = replaceXChars(objWorkList.getVal("Master_Facility_Limit"));
					String Non_Refundable_ProcessingFee = replaceXChars(objWorkList.getVal("Non_Refundable_ProcessingFee"));
					String Related_Part_Name = replaceXChars(objWorkList.getVal("Related_Part_Name"));
					String FeeDebitedAccount = replaceXChars(objWorkList.getVal("FeeDebitedAccount"));
					String Notes = replaceXChars(objWorkList.getVal("Notes"));
					String Total_Facility_Existing = replaceXChars(objWorkList.getVal("Total_Facility_Existing"));
					String Total_Facility_Sought = replaceXChars(objWorkList.getVal("Total_Facility_Sought"));
					String Pattern_of_Funding = replaceXChars(objWorkList.getVal("Pattern_of_Funding"));
					String Deferral_Held = replaceXChars(objWorkList.getVal("Deferral_Held"));
					String TL_Number = replaceXChars(objWorkList.getVal("TL_Number"));
					String Dec_Crops_Finalisation_Checker = replaceXChars(objWorkList.getVal("Dec_Crops_Finalisation_Checker"));
					String Dec_Populate = replaceXChars(objWorkList.getVal("Dec_Populate"));
					String Dec_Business_Approver_1st = replaceXChars(objWorkList.getVal("Dec_Business_Approver_1st"));
					String Dec_Credit_Approver_1st = replaceXChars(objWorkList.getVal("Dec_Credit_Approver_1st"));
					String Dec_Credit_Analyst = replaceXChars(objWorkList.getVal("Dec_Credit_Analyst"));
					String Dec_CBRB_Checker = replaceXChars(objWorkList.getVal("Dec_CBRB_Checker"));
					String UIDGridCount = replaceXChars(objWorkList.getVal("UIDGridCount"));
					String RO_Code = replaceXChars(objWorkList.getVal("RO_Code"));
					String RM_Code = replaceXChars(objWorkList.getVal("RM_Code"));
					String First_Level_Business_Approver = replaceXChars(objWorkList.getVal("First_Level_Business_Approver"));
					String Second_Level_Business_Approver = replaceXChars(objWorkList.getVal("Second_Level_Business_Approver"));
					String First_Level_Credit_Approver = replaceXChars(objWorkList.getVal("First_Level_Credit_Approver"));
					String Second_Level_Credit_Approver = replaceXChars(objWorkList.getVal("Second_Level_Credit_Approver"));
					String CBRB_Required = replaceXChars(objWorkList.getVal("CBRB_Required"));
					String AECB_Required = replaceXChars(objWorkList.getVal("AECB_Required"));
					String Dec_CBRB_Maker = replaceXChars(objWorkList.getVal("Dec_CBRB_Maker"));
					String Dec_AECB = replaceXChars(objWorkList.getVal("Dec_AECB"));
					String Price_Change_Approval_Reqd = replaceXChars(objWorkList.getVal("Price_Change_Approval_Reqd"));
					String Review_Date = replaceXChars(objWorkList.getVal("Review_Date"));
					String MRA_Archival_Date = replaceXChars(objWorkList.getVal("MRA_Archival_Date"));
					String Product_Identifier = replaceXChars(objWorkList.getVal("Product_Identifier"));
					String Limit_Amount = replaceXChars(objWorkList.getVal("Limit_Amount"));
					String Mobile_Code = replaceXChars(objWorkList.getVal("Mobile_Code"));
					String Mobile_Number = replaceXChars(objWorkList.getVal("Mobile_Number"));
					String Landline_Number = replaceXChars(objWorkList.getVal("Landline_Number"));
					String Landline_code = replaceXChars(objWorkList.getVal("Landline_code"));
					String Email_ID = replaceXChars(objWorkList.getVal("Email_ID"));
					String RB5_Checks_Expired = replaceXChars(objWorkList.getVal("RB5_Checks_Expired"));
					String AECB_Checks_Expired = replaceXChars(objWorkList.getVal("AECB_Checks_Expired"));
					String Auto_Expiry_Business_Time = replaceXChars(objWorkList.getVal("Auto_Expiry_Business_Time"));
					String Auto_Expiry_Credit_Time = replaceXChars(objWorkList.getVal("Auto_Expiry_Credit_Time"));
					String Dec_CROPS_Admin_Checker = replaceXChars(objWorkList.getVal("Dec_CROPS_Admin_Checker"));
					String dealingWithCountries = replaceXChars(objWorkList.getVal("dealingWithCountries"));
					String CBRBMaker_Done_On = replaceXChars(objWorkList.getVal("CBRBMaker_Done_On"));
					String AECB_Done_On = replaceXChars(objWorkList.getVal("AECB_Done_On"));
					String Sum_FSV = replaceXChars(objWorkList.getVal("Sum_FSV"));
					String Sum_Value = replaceXChars(objWorkList.getVal("Sum_Value"));
					String dispensationSought = replaceXChars(objWorkList.getVal("dispensationSought"));
					String dispensationHeld = replaceXChars(objWorkList.getVal("dispensationHeld"));
					String Clean_Exposure = replaceXChars(objWorkList.getVal("Clean_Exposure"));
					String SubmittedByCredit_Analyst = replaceXChars(objWorkList.getVal("SubmittedByCredit_Analyst"));
					String ARCHIVALPATH = replaceXChars(objWorkList.getVal("ARCHIVALPATH"));
					String sign_matched_cropsDisbursal_maker = replaceXChars(objWorkList.getVal("sign_matched_cropsDisbursal_maker"));
					String FinalCreditApproverAuth = replaceXChars(objWorkList.getVal("FinalCreditApproverAuth"));
					String Islamic_Or_Conventional = replaceXChars(objWorkList.getVal("Islamic_Or_Conventional"));
					String sign_matched_cropsDeferral_checker = replaceXChars(objWorkList.getVal("sign_matched_cropsDeferral_checker"));
					String ReferToCreditWSName = replaceXChars(objWorkList.getVal("ReferToCreditWSName"));
					String sign_matched_cropsDisbursal_checker = replaceXChars(objWorkList.getVal("sign_matched_cropsDisbursal_checker"));
					String sign_matched_cropsDeferral_maker = replaceXChars(objWorkList.getVal("sign_matched_cropsDeferral_maker"));
					String Type_Of_LA = replaceXChars(objWorkList.getVal("Type_Of_LA"));
					String Request_Type = replaceXChars(objWorkList.getVal("Request_Type"));
					String Campaign_ID = replaceXChars(objWorkList.getVal("Campaign_ID"));
					String Partner_Code = replaceXChars(objWorkList.getVal("Partner_Code"));
					if(CIF_Id!=null && !"".equalsIgnoreCase(CIF_Id))
						AttributeTag="<Parent_WI>"+Sel_WI_NO+"</Parent_WI>"+
								"<Source_Parent_WI>"+env+"</Source_Parent_WI>"+
								"<CIF_Id>"+CIF_Id+"</CIF_Id>"+
								"<RAK_Track_Number>"+RAK_Track_Number+"</RAK_Track_Number>"+
								//"<Remarks>"+Remarks+"</Remarks>"+
								"<Sol_Id>"+Sole_ID+"</Sol_Id>"+
								"<Customer_Name>"+Customer_Name+"</Customer_Name>"+
								"<Reference_Number>"+Reference_Number+"</Reference_Number>"+
								"<Address_Line_1>"+Address_Line_1+"</Address_Line_1>"+
								"<Address_Line_2>"+Address_Line_2+"</Address_Line_2>"+
								"<Address_Line_3>"+Address_Line_3+"</Address_Line_3>"+
								"<Address_Line_4>"+Address_Line_4+"</Address_Line_4>"+
								"<PO_Box>"+PO_Box+"</PO_Box>"+
								"<Emirate>"+Emirate+"</Emirate>"+
								"<Country>"+Country+"</Country>"+
								"<Master_Facility_Limit>"+Master_Facility_Limit+"</Master_Facility_Limit>"+
								"<Total_PF_ParentWI>"+Non_Refundable_ProcessingFee+"</Total_PF_ParentWI>"+
								"<Related_Part_Name>"+Related_Part_Name+"</Related_Part_Name>"+
								"<FeeDebitedAccount>"+FeeDebitedAccount+"</FeeDebitedAccount>"+
								"<Notes>"+Notes+"</Notes>"+
								"<Total_Facility_Existing>"+Total_Facility_Existing+"</Total_Facility_Existing>"+
								"<Total_Facility_Sought>"+Total_Facility_Sought+"</Total_Facility_Sought>"+
								"<Pattern_of_Funding>"+Pattern_of_Funding+"</Pattern_of_Funding>"+
								"<Deferral_Held>"+Deferral_Held+"</Deferral_Held>"+
								"<TL_Number>"+TL_Number+"</TL_Number>"+
								/*"<Dec_Crops_Finalisation_Checker>"+Dec_Crops_Finalisation_Checker+"</Dec_Crops_Finalisation_Checker>"+
								"<Dec_Populate>"+Dec_Populate+"</Dec_Populate>"+
								"<Dec_Business_Approver_1st>"+Dec_Business_Approver_1st+"</Dec_Business_Approver_1st>"+
								"<Dec_Credit_Approver_1st>"+Dec_Credit_Approver_1st+"</Dec_Credit_Approver_1st>"+
								"<Dec_Credit_Analyst>"+Dec_Credit_Analyst+"</Dec_Credit_Analyst>"+
								"<Dec_CBRB_Checker>"+Dec_CBRB_Checker+"</Dec_CBRB_Checker>"+*/
								//"<UIDGridCount>"+UIDGridCount+"</UIDGridCount>"+
								"<RO_Code>"+subUser+"</RO_Code>"+
								//"<RM_Code>"+RM_Code+"</RM_Code>"+
								"<First_Level_Business_Approver>"+First_Level_Business_Approver+"</First_Level_Business_Approver>"+ 
								"<Second_Level_Business_Approver>"+Second_Level_Business_Approver+"</Second_Level_Business_Approver>"+
								//"<First_Level_Credit_Approver>"+First_Level_Credit_Approver+"</First_Level_Credit_Approver>"+ // Not cloning as part of jira PTRP-9
								//"<Second_Level_Credit_Approver>"+Second_Level_Credit_Approver+"</Second_Level_Credit_Approver>"+ // Not cloning as part of jira PTRP-9
								"<CBRB_Required>No</CBRB_Required>"+ // passing default No as part of jira PTRP-10
								"<AECB_Required>No</AECB_Required>"+ // passing default No as part of jira PTRP-10
								//"<Dec_CBRB_Maker>"+Dec_CBRB_Maker+"</Dec_CBRB_Maker>"+
								//"<Dec_AECB>"+Dec_AECB+"</Dec_AECB>"+
								//"<Price_Change_Approval_Reqd>"+Price_Change_Approval_Reqd+"</Price_Change_Approval_Reqd>"+
								"<Review_Date>"+Review_Date+"</Review_Date>"+
								"<MRA_Archival_Date>"+MRA_Archival_Date+"</MRA_Archival_Date>"+
								"<Product_Identifier>"+Product_Identifier+"</Product_Identifier>"+
								"<Limit_Amount>"+Limit_Amount+"</Limit_Amount>"+
								"<Mobile_Code>"+Mobile_Code+"</Mobile_Code>"+
								"<Mobile_Number>"+Mobile_Number+"</Mobile_Number>"+
								"<Landline_Number>"+Landline_Number+"</Landline_Number>"+
								"<Landline_code>"+Landline_code+"</Landline_code>"+
								"<Email_ID>"+Email_ID+"</Email_ID>"+
								/*"<RB5_Checks_Expired>"+RB5_Checks_Expired+"</RB5_Checks_Expired>"+
								"<AECB_Checks_Expired>"+AECB_Checks_Expired+"</AECB_Checks_Expired>"+
								"<Auto_Expiry_Business_Time>"+Auto_Expiry_Business_Time+"</Auto_Expiry_Business_Time>"+
								"<Auto_Expiry_Credit_Time>"+Auto_Expiry_Credit_Time+"</Auto_Expiry_Credit_Time>"+
								"<Dec_CROPS_Admin_Checker>"+Dec_CROPS_Admin_Checker+"</Dec_CROPS_Admin_Checker>"+*/
								"<dealingWithCountries>"+dealingWithCountries+"</dealingWithCountries>"+
								/*"<CBRBMaker_Done_On>"+CBRBMaker_Done_On+"</CBRBMaker_Done_On>"+
								"<AECB_Done_On>"+AECB_Done_On+"</AECB_Done_On>"+*/
								"<Sum_FSV>"+Sum_FSV+"</Sum_FSV>"+
								"<Sum_Value>"+Sum_Value+"</Sum_Value>"+
								"<dispensationSought>"+dispensationSought+"</dispensationSought>"+
								"<dispensationHeld>"+dispensationHeld+"</dispensationHeld>"+
								"<Clean_Exposure>"+Clean_Exposure+"</Clean_Exposure>"+
								//"<SubmittedByCredit_Analyst>"+SubmittedByCredit_Analyst+"</SubmittedByCredit_Analyst>"+
								//"<ARCHIVALPATH>"+ARCHIVALPATH+"</ARCHIVALPATH>"+
								//"<sign_matched_cropsDisbursal_maker>"+sign_matched_cropsDisbursal_maker+"</sign_matched_cropsDisbursal_maker>"+
								//"<FinalCreditApproverAuth>"+FinalCreditApproverAuth+"</FinalCreditApproverAuth>"+
								"<Islamic_Or_Conventional>"+Islamic_Or_Conventional+"</Islamic_Or_Conventional>"+
								//"<sign_matched_cropsDeferral_checker>"+sign_matched_cropsDeferral_checker+"</sign_matched_cropsDeferral_checker>"+
								//"<ReferToCreditWSName>"+ReferToCreditWSName+"</ReferToCreditWSName>"+
								//"<sign_matched_cropsDisbursal_checker>"+sign_matched_cropsDisbursal_checker+"</sign_matched_cropsDisbursal_checker>"+
								//"<sign_matched_cropsDeferral_maker>"+sign_matched_cropsDeferral_maker+"</sign_matched_cropsDeferral_maker>"+
								"<Type_Of_LA>"+Type_Of_LA+"</Type_Of_LA>"+
								"<Campaign_ID>"+Campaign_ID+"</Campaign_ID>"+
								"<Partner_Code>"+Partner_Code+"</Partner_Code>"+
								"<Request_Type>"+Request_Type+"</Request_Type>"+
								"<q_InitiatorCode>"+subUser+"</q_InitiatorCode>"+
								"<q_Sol_Id>"+Sole_ID+"</q_Sol_Id>";
						
								
					TWC_CP_Logs.TWC_CP_Logger.info(" Documentstag-: "+AttributeTag);
					
				}
			}
			
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.info(" Error in creating documnet tag of IBPS "+e.toString());
		}
		TWC_CP_Logs.TWC_CP_Logger.info(" Final Documentstag-: "+AttributeTag);
		
		return AttributeTag;
	}
	
	
	public static String replaceXChars(String value)
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
			if(value.contains("&"))
				value = value.replace("&", "&amp;");
			
			if(value.contains("AAMPRRSNDD"))
				value = value.replace("AAMPRRSNDD", "&amp;");
			if(value.contains("LLSSTNSPX"))
				value = value.replace("LLSSTNSPX", "&lt;");
			if(value.contains("GGRTTNSPX"))
				value = value.replace("GGRTTNSPX", "&gt;");
			
			if(value.contains("<"))
				value = value.replace("<", "&lt;");
			if(value.contains(">"))
				value = value.replace(">", "&gt;");
		}
		return value;
	}
	
	private static String getDocumentTagofOF(String Sel_WI_NO,String ofIP,String ofPort,String OFCabName,String ofSssionID)
	{
		String FinalDocumentstag="";
		try
		{
			WFXmlList objWorkList=null;
			WFXmlResponse xmlParserData=new WFXmlResponse();
			
			String query="SELECT DocumentIndex,Name,DocumentType,ImageIndex,VolumeId,NoOfPages,DocumentSize,AppName FROM PDBDocument WITH(nolock) WHERE DocumentIndex IN (\r\n" + 
					"SELECT documentindex FROM PDBDocumentContent WITH(nolock) WHERE ParentFolderIndex = (SELECT itemindex FROM RB_TWC_EXTTABLE WITH(nolock) WHERE WI_NAME='"+Sel_WI_NO+"'))";
			String sInputXML = CommonMethods.apSelectWithColumnNames(query, OFCabName, ofSssionID);
			TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS "+sInputXML);
			String sOutputXML = WFNGExecute(sInputXML, ofIP, ofPort, 0 );
			xmlParserData.setXmlString(sOutputXML);
			String MaincodeTemp=xmlParserData.getVal("MainCode");
			TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS = "+MaincodeTemp);
			String RecordCount=xmlParserData.getVal("TotalRetrieved");
			if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
			{
				objWorkList = xmlParserData.createList("Records", "Record");
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{
					String docIndex=objWorkList.getVal("DocumentIndex");
					TWC_CP_Logs.TWC_CP_Logger.info("DocIndex = "+docIndex);
					String Name=objWorkList.getVal("Name");
					TWC_CP_Logs.TWC_CP_Logger.info("Name = "+Name);
					String DocumentType=objWorkList.getVal("DocumentType");
					TWC_CP_Logs.TWC_CP_Logger.info("DocumentType = "+DocumentType);
					String ImageIndex=objWorkList.getVal("ImageIndex");
					TWC_CP_Logs.TWC_CP_Logger.info("ImageIndex = "+ImageIndex);
					String VolumeId=objWorkList.getVal("VolumeId");
					TWC_CP_Logs.TWC_CP_Logger.info("VolumeId = "+VolumeId);
					String NoOfPages=objWorkList.getVal("NoOfPages");
					TWC_CP_Logs.TWC_CP_Logger.info("NoOfPages = "+NoOfPages);
					String DocumentSize=objWorkList.getVal("DocumentSize");
					TWC_CP_Logs.TWC_CP_Logger.info("DocumentSize = "+DocumentSize);
					String AppName=objWorkList.getVal("AppName");
					TWC_CP_Logs.TWC_CP_Logger.info("AppName = "+AppName);
					
					
					String docLocation=downloadDocumentFromOF(Sel_WI_NO,Name,ImageIndex,VolumeId,AppName,ofIP,ofPort,OFCabName);
					if(docLocation!=null && !"".equalsIgnoreCase(docLocation))
					{
						long lLngFileSize = 0L;
						File f = new File(docLocation);
						lLngFileSize=f.length();
						String fileName=docLocation.substring(docLocation.lastIndexOf(System.getProperty("file.separator")));
						String DocumentsTag=AddDocInIBPSServer(docLocation,Name,AppName,lLngFileSize);
						TWC_CP_Logs.TWC_CP_Logger.info(" Documentstag-: "+DocumentsTag);
						FinalDocumentstag+=DocumentsTag;
					}
					else
					{
						TWC_CP_Logs.TWC_CP_Logger.info(" Error in downloading the document from of , doc Name:- "+Name);
					}
					
					/*if(ImageIndex!=null && !"".equalsIgnoreCase(ImageIndex))
						Documentstag+=Name+""+fieldSep+""+ImageIndex+hashChar+VolumeId+fieldSep+NoOfPages+fieldSep+DocumentSize+fieldSep+AppName+recordSep;*/
				}
			}
			
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.info(" Error in creating documnet tag of IBPS "+e.toString());
		}
		TWC_CP_Logs.TWC_CP_Logger.info(" Final Documentstag-: "+FinalDocumentstag);
		
		return FinalDocumentstag;
	}
	private static String downloadDocumentFromOF(String processInstanceID,String docname,String imageindex,String volid,String ext,String jtsIP,String jtsPort,String cabinetName)
	{
		try
		{
			
			File file = new File(downloadDocPath+System.getProperty("file.separator")+processInstanceID);
			if (!file.exists()) 
			{
				if (file.mkdir()) 
				{
							
				} 
				else 
				{
										
				}
			}
			
			String pathTodownload=downloadDocPath+System.getProperty("file.separator")+processInstanceID+System.getProperty("file.separator");
			int ivolid=0;
			if(volid!=null && !"".equalsIgnoreCase(volid))
				ivolid=Integer.parseInt(volid);
			TWC_CP_Logs.TWC_CP_Logger.debug("sOutputXml docname : "+docname);
			TWC_CP_Logs.TWC_CP_Logger.debug("sOutputXml imageindex : "+imageindex);
			TWC_CP_Logs.TWC_CP_Logger.debug("sOutputXml volid : "+volid);
			TWC_CP_Logs.TWC_CP_Logger.debug("sOutputXml  ext: "+ext);
			TWC_CP_Logs.TWC_CP_Logger.debug("temppppp"+pathTodownload);
			TWC_CP_Logs.TWC_CP_Logger.debug("temppppp"+jtsPort);
			TWC_CP_Logs.TWC_CP_Logger.debug("IP"+jtsIP);
				try
				{
					CImageServer cImageServer=null;
					try 
					{
						cImageServer = new CImageServer(null,jtsIP, Short.parseShort(jtsPort));
					}
					catch (JPISException e) 
					{
						TWC_CP_Logs.TWC_CP_Logger.debug("inside Catch ");
						TWC_CP_Logs.TWC_CP_Logger.debug(e.toString());
						return null;
		
					}
					TWC_CP_Logs.TWC_CP_Logger.debug("inside tryyyy ");
					try{
						TWC_CP_Logs.TWC_CP_Logger.debug("jtsPort : "+jtsPort);
						TWC_CP_Logs.TWC_CP_Logger.debug("cabinetName  : "+cabinetName);
						TWC_CP_Logs.TWC_CP_Logger.debug("volid volid : "+volid);
						TWC_CP_Logs.TWC_CP_Logger.debug("doc location: "+pathTodownload+docname+"."+ext);
						int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,jtsIP, Short.parseShort(jtsPort), cabinetName, Short.parseShort("1"),Short.parseShort(String.valueOf(volid)), 
						Integer.parseInt(imageindex),"",pathTodownload+docname+"."+ext, new JPDBString());
						TWC_CP_Logs.TWC_CP_Logger.debug("odDownloadCode--"+odDownloadCode);
						if(odDownloadCode==1)
						{
							TWC_CP_Logs.TWC_CP_Logger.debug("DOWNLOAD_CALL_COMPLETE");
							return pathTodownload+docname+"."+ext;
						}
						else
						{
							return null;
						}
					    

					}
					catch(Exception e)
					{
						TWC_CP_Logs.TWC_CP_Logger.debug("Exception-"+e.toString());
						TWC_CP_Logs.TWC_CP_Logger.debug("sOutputXml : sadfdsfsdf");
						return null;
						//e.printStackTrace();
					} 
				}
				catch(Exception e)
				{
					TWC_CP_Logs.TWC_CP_Logger.info("Error in downloading document-: "+e.toString());
					return null;
				}
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.info("Error in downloading document-: "+e.toString());
			return null;
		}
	}
	
	
	public static String createSingleWorkItem(String attributeTag,String DocumentsTag) throws NumberFormatException, Exception
	{
		String strResult="";
		TWC_CP_Logs.TWC_CP_Logger.info("inside createSingleWorkItem");
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
				TWC_CP_Logs.TWC_CP_Logger.info("attributetag 001");
				WIUploadInputXML = getWIUploadInputXML(attributeTag,DocumentsTag);
				TWC_CP_Logs.TWC_CP_Logger.info("WIUploadInputXML:::::::::::: "+WIUploadInputXML);
				WIUploadOutputXML =WFNGExecute(WIUploadInputXML, jtsIP, jtsPort, 0 );
				TWC_CP_Logs.TWC_CP_Logger.info("WIUploadOutputXML:::::::::::: "+WIUploadOutputXML);
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
				TWC_CP_Logs.TWC_CP_Logger.error("Error in createSingleWorkItem :", e);
				continue;
			}
			if ("11".equalsIgnoreCase(mainCodeforWIUpload))
			{
				TWC_CP_Logs.TWC_CP_Logger.info("invalid session createSingleWorkItem");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(TWC_CP_Logs.TWC_CP_Logger, true);
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}

		String decision="";
		if (!"0".equalsIgnoreCase(mainCodeforWIUpload))
		{
			decision="failure";
			TWC_CP_Logs.TWC_CP_Logger.error("Exception in Creating Workitem");
			createWIRemarks = "WFUpload Call Failure: "+createWIRemarks;
		}
		else
		{
			decision="Success";
			createWIRemarks="WorkItem created successfully!";
			TWC_CP_Logs.TWC_CP_Logger.info("Workitem "+workItemName+" created Succesfully.");
		}
		TWC_CP_Logs.TWC_CP_Logger.info("decision "+decision);
		TWC_CP_Logs.TWC_CP_Logger.info("Workitem "+workItemName);
		TWC_CP_Logs.TWC_CP_Logger.info("createdDateTime "+createdDateTime);
		TWC_CP_Logs.TWC_CP_Logger.info("createWIRemarks "+createWIRemarks);
		strResult=decision+"~"+workItemName+"~"+createdDateTime+"~"+createWIRemarks;

		return strResult;
	}
	public static void update_TWC_CP_Request_Details(String sel_Wi_No,String refNo,String createWIStatus, String NewWIName,String createdDateTime)
	{
		
		try
		{
			/*int iRetryCount =0;
			try
			{
				iRetryCount = Integer.parseInt(sRetryCount);
				iRetryCount++;
			}
			catch(Exception e)
			{
				iRetryCount=1;
			}*/
			String colName="New_WI_Number,New_WI_Created_DT,New_WI_Creation_Flag,Case_Status";
			String values="";
			
			if(NewWIName.contains("Process"))
			{
				values="'"+NewWIName+"',CAST(N'"+createdDateTime+"' AS DateTime),'Success','Processed'";
			}
			else
			{
				values="'','','Error','Error in processing the request contact BPM-Support'";
			}
			
			String where = "Reference_No ='"+refNo+"' AND Sel_WI_No='"+sel_Wi_No+"' ";
			ExecuteQuery_APUpdate("USR_0_TWC_Copy_Profile_Details",colName,values,where);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			TWC_CP_Logs.TWC_CP_Logger.info("Exception in updateRecordData "+e);
		}
		return;
	}
	private static void ExecuteQuery_APUpdate(String tablename, String columnname,String colValues, String sWhere) throws ParserConfigurationException, SAXException, IOException
	{
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				XMLParser objXMLParser = new XMLParser();
				String inputXmlcheckAPUpdate =ExecuteQuery_APUpdate(tablename,columnname,colValues,sWhere,cabinetName,sessionID);
				TWC_CP_Logs.TWC_CP_Logger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=WFNGExecute(inputXmlcheckAPUpdate, jtsIP, jtsPort, 0 );
				TWC_CP_Logs.TWC_CP_Logger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					TWC_CP_Logs.TWC_CP_Logger.error("Exception in ExecuteQuery_APUpdate updating the table");
				}
				else
				{
					TWC_CP_Logs.TWC_CP_Logger.error("Successfully updated table");
					
				}
				int mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sessionID=CommonConnection.getSessionID(TWC_CP_Logs.TWC_CP_Logger, false);
				}
				else
				{
					sessionCheckInt++;
					break;
				}
			}
			catch(Exception e)
			{
				TWC_CP_Logs.TWC_CP_Logger.error("Inside create ExecuteQuery_APUpdate exception"+e);
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
	public static String AddDocInIBPSServer(String path,String FileName,String strExtension,long lLngFileSize )
	{

		TWC_CP_Logs.TWC_CP_Logger.info("Adding doc in image server-: "+FileName);
		

		JPISIsIndex ISINDEX = new JPISIsIndex();
		JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
		String Documentstag="";
		sessionCheckInt=0;
		volumeID=CommonConnection.getsVolumeID();
		SMSPort=CommonConnection.getsSMSPort();
		if(lLngFileSize != 0L)
		{
			TWC_CP_Logs.TWC_CP_Logger.info(" The Document address is: "+path);
			String docPath=path;
			int nNoOfPages = 1;

			try
			{
				TWC_CP_Logs.TWC_CP_Logger.info(" before CPISDocumentTxn AddDocument MT: ");
				TWC_CP_Logs.TWC_CP_Logger.info(" jtsIP: "+jtsIP);
				TWC_CP_Logs.TWC_CP_Logger.info(" jtsPort: "+jtsPort);
				TWC_CP_Logs.TWC_CP_Logger.info(" volumeID: "+volumeID);
				if(SMSPort.startsWith("33"))
				{
					CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(SMSPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, "",ISINDEX);
				}
				else
				{
					CPISDocumentTxn.AddDocument_MT(null, jtsIP , Short.parseShort(SMSPort), cabinetName, Short.parseShort(volumeID), docPath, JPISDEC, null,"JNDI", ISINDEX);
				}	

				TWC_CP_Logs.TWC_CP_Logger.info(" after CPISDocumentTxn AddDocument MT: ");

				String sISIndex = ISINDEX.m_nDocIndex + "#" + ISINDEX.m_sVolumeId;
				if(sISIndex!=null && !"".equalsIgnoreCase(sISIndex))
				{
					Documentstag=FileName+""+fieldSep+""+ISINDEX.m_nDocIndex+hashChar+ISINDEX.m_sVolumeId+fieldSep+nNoOfPages+fieldSep+lLngFileSize+fieldSep+"csv"+recordSep;
					File f = new File(docPath);
					if(!f.delete())
					{
						TWC_CP_Logs.TWC_CP_Logger.info(" Error in deleteing file-: "+docPath);
					}
				}
				
				TWC_CP_Logs.TWC_CP_Logger.info(" Documentstag-: "+Documentstag);
				
			}
			catch (NumberFormatException e)
			{
				TWC_CP_Logs.TWC_CP_Logger.info("workItemName1:"+e.getMessage());
				e.printStackTrace();
			}
			catch (JPISException e)
			{
				TWC_CP_Logs.TWC_CP_Logger.info("workItemName2:"+e.getMessage());
				e.printStackTrace();
			}
			catch (Exception e)
			{
				TWC_CP_Logs.TWC_CP_Logger.info("workItemName3:"+e.getMessage());
				e.printStackTrace();
			}
		}
		else
		{
			TWC_CP_Logs.TWC_CP_Logger.info("Invalid File Size"+lLngFileSize);
		}
	
		return Documentstag;
		
	}
	private static String UpdateWIHistory(String cabinetName,String sessionID,String processInstanceID,String decision,String entryDateTime,String createWIremarks)
	{
		try
			{
				sessionCheckInt=0;
				
				SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
				Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
				String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
				TWC_CP_Logs.TWC_CP_Logger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
	
				Date actionDateTime= new Date();
				String formattedActionDateTime=outputDateFormat.format(actionDateTime);
				TWC_CP_Logs.TWC_CP_Logger.debug("FormattedActionDateTime: "+formattedActionDateTime);
	
				//Insert in WIHistory Table.
	
				String columnNames="WINAME,ACTIONDATETIME,wsname,USERNAME,DECISION,ENTRYDATETIME,REMARKS";
				String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+activityName+"','"
				+CommonConnection.getUsername()+"','"+decision+"','"+formattedEntryDatetime+"','"+createWIremarks+"'";
				while(sessionCheckInt<loopCount)
				{
					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,histTable);
					TWC_CP_Logs.TWC_CP_Logger.debug("APInsertInputXML: "+apInsertInputXML);
		
					String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,jtsPort,1);
					TWC_CP_Logs.TWC_CP_Logger.debug("APInsertOutputXML: "+ apInsertOutputXML);
		
					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					TWC_CP_Logs.TWC_CP_Logger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						TWC_CP_Logs.TWC_CP_Logger.debug("ApInsert successful: "+apInsertMaincode);
						TWC_CP_Logs.TWC_CP_Logger.debug("Inserted in WiHistory table successfully.");
						return apInsertMaincode;
					}

					else
					{
						TWC_CP_Logs.TWC_CP_Logger.error("ApInsert failed: "+apInsertMaincode);
					}
					if (apInsertMaincode.equalsIgnoreCase("11")) 
					{
						TWC_CP_Logs.TWC_CP_Logger.info("Invalid session in historyCaller of UpdateExpiryDate");
						sessionCheckInt++;
						sessionID=CommonConnection.getSessionID(TWC_CP_Logs.TWC_CP_Logger, true);
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
			TWC_CP_Logs.TWC_CP_Logger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			TWC_CP_Logs.TWC_CP_Logger.error("Exception Occurred in Updating History  : "+result);
			System.out.println("Exception "+e);
		
		}
		return "";
	}
	private static void copyGridData(String NewWINumber,String Old_WI_NO,String CabName,String IP,String Port)
	{
		try
		{
			String tableArr [] = GridTableName.split(",");
			for(String table: tableArr)
			{
				//XMLParser xmlParserData=new XMLParser();
				WFXmlList objWorkList=null;
				WFXmlResponse xmlParserData=new WFXmlResponse();
				String query="Select * from "+table+" with(nolock) where WINAME='"+Old_WI_NO+"'";
				String sInputXML = CommonMethods.apSelectWithColumnNames(query, CabName, "");
				TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS "+sInputXML);
				String sOutputXML = WFNGExecute(sInputXML,IP,Port, 0 );
				xmlParserData.setXmlString(sOutputXML);
				//xmlParserData.setInputXML(sOutputXML);
				String MaincodeTemp=xmlParserData.getVal("MainCode");
				TWC_CP_Logs.TWC_CP_Logger.info("Get grid data  = "+MaincodeTemp);
				String RecordCount=xmlParserData.getVal("TotalRetrieved");
				if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
				{
					objWorkList = xmlParserData.createList("Records", "Record");
					//String recString=xmlParserData.getValueOf("Records");
					//recString=recString.substring("<Record>".length(), recString.lastIndexOf("</Record>"));
					//String recordArr[] = recString.split("</Record><Record>");
					//TWC_CP_Logs.TWC_CP_Logger.info("No of rows in grid "+recordArr.length);
					List<String> colNameArr = GridTableColumns.get(table);
					for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
					{
						String colNameForInsert="";
						String colValueForInsert="";
						//XMLParser objXMLParser2 = new XMLParser();
						//objXMLParser2.setInputXML(s);
						
						for(int i=0;i<colNameArr.size();i++)
						{
							String colName=colNameArr.get(i);
							String colValue=objWorkList.getVal(colName);
							if("".equalsIgnoreCase(colValue) || colValue == null)
								continue;
							colValue=colValue.replace("'", "''");
							if("WINAME".equalsIgnoreCase(colName))
							{
								colValue=NewWINumber;
							}
							if("".equalsIgnoreCase(colNameForInsert))
							{
								colNameForInsert+=colName;
							}
							else
							{
								colNameForInsert+=","+colName;
							}
							if("".equalsIgnoreCase(colValueForInsert))
							{
								colValueForInsert+="'"+colValue+"'";
							}
							else
							{
								colValueForInsert+=",'"+colValue+"'";
							}
						}
						TWC_CP_Logs.TWC_CP_Logger.info("colNameForInsert-"+colNameForInsert);
						TWC_CP_Logs.TWC_CP_Logger.info("colValueForInsert-"+colValueForInsert);
						insertSingleRowInDB(colNameForInsert,colValueForInsert,table);
						
					}
				}
			}
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.error("Exception in copyGridData "+e);
		}
	}
	private static void getColumnNameForGridTable()
	{
		try
		{//GridTableColumns
			String tableArr [] = GridTableName.split(",");
			for(String table: tableArr)
			{
				WFXmlList objWorkList=null;
				WFXmlResponse xmlParserData=new WFXmlResponse();
				List<String> ls = new ArrayList<String>();
				String query="select COLUMN_NAME from INFORMATION_SCHEMA.COLUMNS with(nolock) where TABLE_NAME = '"+table+"'";
				String sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, "");
				TWC_CP_Logs.TWC_CP_Logger.info("Get document data from IBPS "+sInputXML);
				String sOutputXML = WFNGExecute(sInputXML, jtsIP,jtsPort, 0 );
				xmlParserData.setXmlString(sOutputXML);
				String MaincodeTemp=xmlParserData.getVal("MainCode");
				TWC_CP_Logs.TWC_CP_Logger.info("Get column name from IBPS = "+MaincodeTemp);
				String RecordCount=xmlParserData.getVal("TotalRetrieved");
				if("0".equalsIgnoreCase(MaincodeTemp) && Integer.parseInt(RecordCount)>0)
				{
					objWorkList = xmlParserData.createList("Records", "Record");
					for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
					{
						String colName=objWorkList.getVal("COLUMN_NAME");
						ls.add(colName);
					}
				}
				GridTableColumns.put(table, ls);
			}
		}
		catch(Exception e)
		{
			
		}
		
	}
	private static void insertSingleRowInDB(String colNameForInsert,String colValueForInsert,String tableName)
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
				sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>"+tableName+"</TableName>" +
						"<ColName>" + colNameForInsert + "</ColName>" +
						"<Values>" + colValueForInsert + "</Values>" +
						"<EngineName>" + cabinetName + "</EngineName>" +
						"<SessionId>" + sessionID + "</SessionId>" +
						"</APInsert_Input>";

				TWC_CP_Logs.TWC_CP_Logger.info("Insert InputXml::::::::::\n"+sInputXML);
				sOutputXML =WFNGExecute(sInputXML, jtsIP, jtsPort, 0);
				TWC_CP_Logs.TWC_CP_Logger.info("Insert OutputXml::::::::::\n"+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
			}
			catch(Exception e)
			{
				e.printStackTrace();
				TWC_CP_Logs.TWC_CP_Logger.error("Exception in Inserting row in DB-", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				TWC_CP_Logs.TWC_CP_Logger.info("Invalid session in Inserting row in DB");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(TWC_CP_Logs.TWC_CP_Logger, true);
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
			TWC_CP_Logs.TWC_CP_Logger.info("DB Insert Successful");
		}
		else
		{
			TWC_CP_Logs.TWC_CP_Logger.info("Insert Unsuccessful");
		}
	
	}
	public static void sendMail(String toMailID,String workItemNo,String refNo )throws Exception
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
				
				mailSubject = "TWC copy Profile Request for Reference No "+refNo;
				MailStr = "<html><body>Dear User,<br><br>TWC copy Profile Request for Reference No "+refNo+ " has been processd and Workitem "+workItemNo+" has created in TWC process of IBPS.<br>Kindly verify the item by logging in IBPS System.<br><br>Regards,<br>RAKBANK<br>* This is an automated email, please do not reply.</body></html>";
				
				
				String columnName = "mailFrom,mailTo,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,mailActionType,insertedTime,processDefId,workitemId,activityId,noOfTrials,zipFlag";
				String strValues = "'"+fromMailID+"','"+toMailID+"','"+mailSubject+"','"+MailStr+"','text/html;charset=UTF-8','1','N','TRIGGER','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+ProcessDefID+"','1','"+activityId+"','0','N'";
				
				sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>WFMAILQUEUETABLE</TableName>" +
						"<ColName>" + columnName + "</ColName>" +
						"<Values>" + strValues + "</Values>" +
						"<EngineName>" + cabinetName + "</EngineName>" +
						"<SessionId>" + sessionID + "</SessionId>" +
						"</APInsert_Input>";

				TWC_CP_Logs.TWC_CP_Logger.info("Mail Insert InputXml::::::::::\n"+sInputXML);
				sOutputXML =WFNGExecute(sInputXML, jtsIP, jtsPort, 0);
				TWC_CP_Logs.TWC_CP_Logger.info("Mail Insert OutputXml::::::::::\n"+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
			}
			catch(Exception e)
			{
				e.printStackTrace();
				TWC_CP_Logs.TWC_CP_Logger.error("Exception in Sending mail", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				TWC_CP_Logs.TWC_CP_Logger.info("Invalid session in Sending mail");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(TWC_CP_Logs.TWC_CP_Logger, true);
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
			TWC_CP_Logs.TWC_CP_Logger.info("mail Insert Successful");
		}
		else
		{
			TWC_CP_Logs.TWC_CP_Logger.info("mail Insert Unsuccessful");
		}
	}
	public static String getWIUploadInputXML(String attributetag,String DocumentsTag)
	{
		return "<?xml version=\"1.0\"?>\n"+
				"<WFUploadWorkItem_Input>\n"+
				"<Option>WFUploadWorkItem</Option>\n"+
				"<EngineName>"+cabinetName+"</EngineName>\n"+
				"<SessionId>"+sessionID+"</SessionId>\n"+
				"<ProcessDefId>"+ProcessDefID+"</ProcessDefId>\n"+
				"<QueueId>"+queueId+"</QueueId>"+
				"<InitiateAlso>Y</InitiateAlso>\n"+
				"<Attributes>"+attributetag+"</Attributes>\n"+
				"<IsWorkItemExtInfo>N</IsWorkItemExtInfo>"+
				"<VariantId>0</VariantId>\r\n" +
				"<UserDefVarFlag>Y</UserDefVarFlag>\r\n" + 
				"<Documents>"+DocumentsTag+"</Documents>\n"+
				"<InitiateFromActivityId>"+activityId+"</InitiateFromActivityId>\n"+
				"<InitiateFromActivityName>"+activityName+"</InitiateFromActivityName>\n"+
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
			TWC_CP_Logs.TWC_CP_Logger.info("Delete Older Records InputXML = "+InputXMLTemp);
			String OutputXMLTemp=WFNGExecute(InputXMLTemp, jtsIP, jtsPort, 0);
			TWC_CP_Logs.TWC_CP_Logger.info("Delete Older Records OutputXML = "+OutputXMLTemp);
			XMLParser objXMLParser1 = new XMLParser();
			objXMLParser1.setInputXML(OutputXMLTemp);
			MaincodeTemp=objXMLParser1.getValueOf("MainCode");
			TWC_CP_Logs.TWC_CP_Logger.info("Delete Older Records MainCode = "+MaincodeTemp);
		}
		catch(Exception e)
		{
			TWC_CP_Logs.TWC_CP_Logger.error("Inside create ExecuteQuery_APUpdate exception"+e);
		}
		return MaincodeTemp;
	}
	private static void deleteFolder(File file){
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yy");
		for (File subFile : file.listFiles()) 
		{
			boolean isOld = false;
			String strModifiedDate = dateFormat.format(subFile.lastModified());
			TWC_CP_Logs.TWC_CP_Logger.info("File Name: "+subFile.getName()+", last modified: "+strModifiedDate);
			try {
				Date parsedModifiedDate=new SimpleDateFormat("dd-MMM-yy").parse(strModifiedDate);
				isOld = olderThanDays(parsedModifiedDate, Integer.parseInt(deleteSuccessDataBeforeDays));
			} catch (ParseException e) {
				e.printStackTrace();
			}
			if (isOld)
			{
				TWC_CP_Logs.TWC_CP_Logger.info("Deleting: "+subFile.getName());	
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
		TWC_CP_Logs.TWC_CP_Logger.debug("In WF NG Execute : " + serverPort);
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
			TWC_CP_Logs.TWC_CP_Logger.debug("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	public static String parseDate(String sdate)
    {
		TWC_CP_Logs.TWC_CP_Logger.info("Creating Attribute tag---Parsing the date--"+sdate);
        try
        {
        	DateFormat informat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
			Date date = informat.parse(sdate);
			System.out.println(date);
			DateFormat outdateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
           String strDate = outdateFormat.format(date);
           System.out.println("Date with short name--  "+strDate);
           TWC_CP_Logs.TWC_CP_Logger.info("Creating Attribute tag---Parsing  of date completed with o/p--"+strDate);
           return strDate;
          
        }
        catch(Exception e)
        {
        	System.out.println("Error In Parsing the date --"+e.toString());
        	TWC_CP_Logs.TWC_CP_Logger.info("Creating Attribute tag---Error In Parsing the date--"+e);
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
	    	  TWC_CP_Logs.TWC_CP_Logger.error("Inside CommonFunctions.moveFile--Exception while moving file: -- "+ e.toString());
	    	
	      }
	      if(result != null) 
	      {
	    	  TWC_CP_Logs.TWC_CP_Logger.info("Inside CommonFunctions.moveFile--File moved successfully.");
	    	  return result.toString();
	      }
	      else
	      {
	    	  TWC_CP_Logs.TWC_CP_Logger.info("Inside CommonFunctions.moveFile--File movement failed.");
	    	  return "";
	      }
	   }
	}
