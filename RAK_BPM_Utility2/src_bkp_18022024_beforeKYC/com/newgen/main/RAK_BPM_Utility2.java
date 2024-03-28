/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: Main
File Name				: RAKBankUtility.java
Author 					: Sakshi Grover
Date (DD/MM/YYYY)		: 30/04/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.main;

import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.net.ServerSocket;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.apache.log4j.PropertyConfigurator;
import com.newgen.DormancyChanges.DormancyChanges;
import com.newgen.FPUCreateWIFromTextFile.CreateWIFromTextFile;
import com.newgen.ODDD.ODDocDownload.ExcelValidationUtility;
import com.newgen.SAR.CSVWICreation.SARWICreation;
import com.newgen.SAR.EmailReminder.SAREmailReminder;
import com.newgen.SMEsoukDocArchival.SMEsoukDocArchival;
import com.newgen.TWC_Copy_Profile.TWC_CopyProfile;
import com.newgen.common.CommonConnection;
import com.newgen.encryption.DataEncryption;

public class RAK_BPM_Utility2
{
	private static Map<String, String> mainPropMap= new HashMap<String, String>();
	private static String loggerName = "MainLogger";
	private static org.apache.log4j.Logger MainLogger = org.apache.log4j.Logger.getLogger(loggerName);

	 static
	 {
			setLogger();
	 }

	public static void main(String[] args)
	{
		System.out.println("Starting utility...");
		MainLogger.info("Starting Utility");
		int mainPropFileReadCode = readMainPropFile();

		if(mainPropFileReadCode!=0)
		{
			System.out.println("Error in Readin Main Property FIle");
			MainLogger.error("Error in Readin Main Property FIle "+mainPropFileReadCode);
			return;
		}

		try
		{
			int socketPort =  Integer.parseInt(mainPropMap.get("Utility_Port"));
			if(socketPort==0)
			{
				System.out.println("Not able to Get Utility Port");
				MainLogger.error("Not able to Get Utility Port "+socketPort);
				return;
			}
			ServerSocket serverSocket = new ServerSocket(socketPort);



			CommonConnection.setUsername(mainPropMap.get("UserName"));
			CommonConnection.setPassword(DataEncryption.decrypt(mainPropMap.get("Password")));
			CommonConnection.setJTSIP(mainPropMap.get("JTSIP"));
			CommonConnection.setJTSPort(mainPropMap.get("JTSPort"));
			CommonConnection.setsSMSPort(mainPropMap.get("SMSPort"));
			CommonConnection.setCabinetName(mainPropMap.get("CabinetName"));
			CommonConnection.setsVolumeID(mainPropMap.get("VolumeID"));
			CommonConnection.setsSiteID(mainPropMap.get("SiteID"));
			
			CommonConnection.setOFCabinetName(mainPropMap.get("OFCabinetName"));
			CommonConnection.setOFBAISProcessDefId(mainPropMap.get("OFBAISProcessDefId"));
			CommonConnection.setOFJTSIP(mainPropMap.get("OFJTSIP"));
			CommonConnection.setOFJTSPort(mainPropMap.get("OFJTSPort"));
			CommonConnection.setOFVOLUMNID(mainPropMap.get("OFVOLUMNID"));
			CommonConnection.setOFUserName(mainPropMap.get("OFUserName"));
			CommonConnection.setOFPassword(mainPropMap.get("OFPassword"));
			
			String sessionID = CommonConnection.getSessionID(MainLogger,false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				MainLogger.info("Could Not Get Session ID "+sessionID);
				return;
			}

			if(mainPropMap.get("ODDD_OD_Doc_Download")!=null && mainPropMap.get("ODDD_OD_Doc_Download").equalsIgnoreCase("Y"))
			{
				Thread ODDD_OD_Doc_DownloadThread = new Thread(new ExcelValidationUtility());
				ODDD_OD_Doc_DownloadThread.start();
				System.out.println("ExcelValidationUtility Started");
				MainLogger.info("ExcelValidationUtility Started");
			}
			if(mainPropMap.get("DormancyChanges")!=null && mainPropMap.get("DormancyChanges").equalsIgnoreCase("Y"))
			{
				Thread DormancyChangesThread = new Thread(new DormancyChanges());
				DormancyChangesThread.start();
				System.out.println("DormancyChanges Started");
				MainLogger.info("DormancyChangesProcess Started");
			}
			/*if(mainPropMap.get("FPU_CreateWIFromTextFile")!=null && mainPropMap.get("FPU_CreateWIFromTextFile").equalsIgnoreCase("Y"))
			{
				System.out.println("Going To start FPU_CreateWIFromTextFileUtility..");
				Thread createWIFromTextFile = new Thread(new CreateWIFromTextFile());
				System.out.println("FPU_CreateWIFromTextFileUtility thread initiallized..");
				createWIFromTextFile.start();
				System.out.println("FPU_CreateWIFromTextFileUtility Started");
				MainLogger.info("FPU_CreateWIFromTextFileUtility Started");
			}*/
			if(mainPropMap.get("SAR_CreateWIAttachCSV")!=null && mainPropMap.get("SAR_CreateWIAttachCSV").equalsIgnoreCase("Y"))
			{
				System.out.println("Going To start SAR_CreateWIAttachCSV Utility..");
				Thread SAR_CreateWIAttachCSV = new Thread(new SARWICreation());
				System.out.println("SAR_CreateWIAttachCSV thread initiallized..");
				SAR_CreateWIAttachCSV.start();
				System.out.println("SAR_CreateWIAttachCSV Utility Started");
				MainLogger.info("SAR_CreateWIAttachCSV Utility Started");
			}
			if(mainPropMap.get("SMEsoukDocArchival")!=null && mainPropMap.get("SMEsoukDocArchival").equalsIgnoreCase("Y"))
			{
				System.out.println("Going To start SMEsoukDocArchival Utility..");
				Thread DocArchival = new Thread(new SMEsoukDocArchival());
				System.out.println("SMEsoukDocArchival thread initiallized..");
				DocArchival.start();
				System.out.println("SMEsoukDocArchival Utility Started");
				MainLogger.info("SMEsoukDocArchival Utility Started");
			}
			if(mainPropMap.get("SAREmailReminder")!=null && mainPropMap.get("SAREmailReminder").equalsIgnoreCase("Y"))
			{
				System.out.println("Going To start SAREmailReminder Utility..");
				Thread EmailReminder = new Thread(new SAREmailReminder());
				System.out.println("SAR_EmailReminder thread initiallized..");
				EmailReminder.start();
				System.out.println("SAR_EmailReminder Utility Started");
				MainLogger.info("SAR_EmailReminder Utility Started");
			}
			
			
			if(mainPropMap.get("TWC_Copy_Profile")!=null && mainPropMap.get("TWC_Copy_Profile").equalsIgnoreCase("Y"))
			{
				System.out.println("Going To start TWC_Copy_Profile Utility..");
				Thread TWC_CopyProfile = new Thread(new TWC_CopyProfile());
				System.out.println("TWC_CopyProfile thread initiallized..");
				TWC_CopyProfile.start();
				System.out.println("TWC_CopyProfile Utility Started");
				MainLogger.info("TWC_CopyProfile Utility Started");
			}
		}
		catch (Exception e)
		{
			if(e.getMessage().toUpperCase().startsWith("Address already in use".toUpperCase()))
			{
				System.out.println("Utility Instance Already Running");
				MainLogger.error("Utility Instance Already Running");
			}
			else
			{
				e.printStackTrace();
				MainLogger.error("Exception Occurred in Main Thread: "+e);
				final Writer result = new StringWriter();
				final PrintWriter printWriter = new PrintWriter(result);
				e.printStackTrace(printWriter);
				MainLogger.error("Exception Occurred in Main Thread : "+result);
			}
			return;
		}
		finally
		{
			System.gc();
		}
	}

	private static void setLogger()
	{
		try
		{
			Date date = new Date();
			DateFormat logDateFormat = new SimpleDateFormat("dd-MM-yyyy");
			Properties p = new Properties();
			p.load(new FileInputStream(System.getProperty("user.dir")+ File.separator + "log4jFiles"+ File.separator+ "Main_log4j.properties"));
			String dynamicLog = null;
			String orgFileName = null;
			File d = null;
			File fl = null;

			dynamicLog = "Logs/Main_Logs/"+logDateFormat.format(date)+"/Main_Log.xml";
			orgFileName = p.getProperty("log4j.appender."+loggerName+".File");
			if(!(orgFileName==null || orgFileName.equalsIgnoreCase("")))
			{
				dynamicLog = orgFileName.substring(0,orgFileName.lastIndexOf("/")+1)+logDateFormat.format(date)+orgFileName.substring(orgFileName.lastIndexOf("/"));
			}
			d = new File(dynamicLog.substring(0,dynamicLog.lastIndexOf("/")));
			d.mkdirs();
			fl = new File(dynamicLog);
			if(!fl.exists())
				fl.createNewFile();
			p.put("log4j.appender."+loggerName+".File", dynamicLog );

			PropertyConfigurator.configure(p);
			//System.out.println("Dynamic Logger Created");
		}
		catch(Exception e)
		{
			System.out.println("Exception in creating dynamic log :"+e);
			e.printStackTrace();
		}
	}

	private static int readMainPropFile()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "Main_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    mainPropMap.put(name, p.getProperty(name));
			}

		} catch (Exception e) {

			return -1 ;
		}
		return 0;
	}
}