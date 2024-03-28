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

import com.newgen.PC.PC;
import com.newgen.RAOP.CBS.RAOPCBS;
import com.newgen.RAOP.Document.RAOPDocument;
import com.newgen.RAOP.Status.RAOPStatus;
import com.newgen.common.CommonConnection;
import com.newgen.encryption.DataEncryption;
import com.newgen.CMP.CBS.CMPCBS;
import com.newgen.CMP.Document.CMPDocument;
import com.newgen.CMP.Status.CMPStatus;
import com.newgen.CBP.CBS.CBPCBS;
import com.newgen.CBP.Document.CBPDocument;
import com.newgen.CBP.Status.CBPStatus;
import com.newgen.DAC.CBS.DACCBS;
import com.newgen.DAC.Document.DACDocument;

public class RAKBankUtility
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
			
			String sessionID = CommonConnection.getSessionID(MainLogger,true);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				MainLogger.info("Could Not Get Session ID "+sessionID);
				return;
			}

			if(mainPropMap.get("PC_Integration")!=null && mainPropMap.get("PC_Integration").equalsIgnoreCase("Y"))
			{
				Thread pcThread = new Thread(new PC());
				pcThread.start();
				System.out.println("PC Integration Started");
				MainLogger.info("PC Integration Started");
			}

			if(mainPropMap.get("RAOP_CBS")!=null && mainPropMap.get("RAOP_CBS").equalsIgnoreCase("Y"))
			{
				Thread raopCBSThread = new Thread(new RAOPCBS());
				raopCBSThread.start();
				System.out.println("RAOP CBS Started");
				MainLogger.info("RAOP CBS Started");
			}

			if(mainPropMap.get("RAOP_Document")!=null && mainPropMap.get("RAOP_Document").equalsIgnoreCase("Y"))
			{
				Thread raopDocumentThread = new Thread(new RAOPDocument());
				raopDocumentThread.start();
				System.out.println("RAOP Document Started");
				MainLogger.info("RAOP Document Started");
			}

			if(mainPropMap.get("RAOP_Status")!=null && mainPropMap.get("RAOP_Status").equalsIgnoreCase("Y"))
			{
				Thread raopStatusThread = new Thread(new RAOPStatus());
				raopStatusThread.start();
				System.out.println("RAOP Status Started");
				MainLogger.info("RAOP Status Started");
			}
			
			if(mainPropMap.get("CMP_Document")!=null && mainPropMap.get("CMP_Document").equalsIgnoreCase("Y"))
			{
				Thread CMPDocumentThread = new Thread(new CMPDocument());
				CMPDocumentThread.start();
				System.out.println("CMP Document Started");
				MainLogger.info("CMP Document Started");
			}
			
			if(mainPropMap.get("CBP_Document")!=null && mainPropMap.get("CBP_Document").equalsIgnoreCase("Y"))
			{
				Thread CBPDocumentThread = new Thread(new CBPDocument());
				CBPDocumentThread.start();
				System.out.println("CBP Document Started");
				MainLogger.info("CBP Document Started");
			}
			
			if(mainPropMap.get("CBP_CBS")!=null && mainPropMap.get("CBP_CBS").equalsIgnoreCase("Y"))
			{
				Thread cbpCBSThread = new Thread(new CBPCBS());
				cbpCBSThread.start();
				System.out.println("CBP CBS Started");
				MainLogger.info("CBP CBS Started");
			}
			
			if(mainPropMap.get("CBP_Status")!=null && mainPropMap.get("CBP_Status").equalsIgnoreCase("Y"))
			{
				Thread cbpStatusThread = new Thread(new CBPStatus());
				cbpStatusThread.start();
				System.out.println("CBP Status Started");
				MainLogger.info("CBP Status Started");
			}
			
			if(mainPropMap.get("CMP_Status")!=null && mainPropMap.get("CMP_Status").equalsIgnoreCase("Y"))
			{
				Thread cmpStatusThread = new Thread(new CMPStatus());
				cmpStatusThread.start();
				System.out.println("CMP Status Started");
				MainLogger.info("CMP Status Started");
			}
			
			if(mainPropMap.get("CMP_CBS")!=null && mainPropMap.get("CMP_CBS").equalsIgnoreCase("Y"))
			{
				Thread cmpCBSThread = new Thread(new CMPCBS());
				cmpCBSThread.start();
				System.out.println("CMP CBS Started");
				MainLogger.info("CMP CBS Started");
			}
			if(mainPropMap.get("DAC_Document")!=null && mainPropMap.get("DAC_Document").equalsIgnoreCase("Y"))
			{
				Thread dacDocumentThread = new Thread(new DACDocument());
				dacDocumentThread.start();
				System.out.println("DAC Document Started");
				MainLogger.info("DAC Document Started");
			}
			if(mainPropMap.get("DAC_CBS")!=null && mainPropMap.get("DAC_CBS").equalsIgnoreCase("Y"))
			{
				Thread dacCBSThread = new Thread(new DACCBS());
				dacCBSThread.start();
				System.out.println("DAC CBS Started");
				MainLogger.info("DAC CBS Started");
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