/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP Document
File Name				: RAOPDocumentLog.java
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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;


import org.apache.log4j.*;

public final class RAOPDocumentLog
{
	private static String loggerName = "RAOPDocumentLogger";
    protected static org.apache.log4j.Logger RAOPDocumentLogger = org.apache.log4j.Logger.getLogger(loggerName);


    static
    {
    	setLogger();
    }

    protected static void setLogger()
    {
    	try
		{
			Date date = new Date();
			DateFormat logDateFormat = new SimpleDateFormat("dd-MM-yyyy");
			Properties p = new Properties();
			p.load(new FileInputStream(System.getProperty("user.dir")+ File.separator + "log4jFiles"+ File.separator+ "RAOP_Document_log4j.properties"));
			String dynamicLog = null;
			String orgFileName = null;
			File d = null;
			File fl = null;

			dynamicLog = "Logs/RAOP_Document_Logs/"+logDateFormat.format(date)+"/RAOP_Document_Log.xml";
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
}
