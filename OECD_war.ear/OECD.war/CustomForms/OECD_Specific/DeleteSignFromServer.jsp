<!--------------------------------------------------------------------------------------------------------------------------------------

NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                         :           Application –Projects
Project/Product         	  :           RAKBank RAO
Application                   : 
Module                        : 
File Name                     : 		  DeleteSignFromServer.jsp
Author                        :           Ankit
Date (dd/mm/yyyy)             :           01-11-2017
Description                   :           To delete sign from server 
---------------------------------------------------------------------------------------------------------------------------------------

CHANGE HISTORY

---------------------------------------------------------------------------------------------------------------------------------------
Problem No/CR No              Change Date            Changed By             Change Description
-------------------------------------------------------------------------------------------------------------------------------------->

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*,java.math.*"%>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.OutputStreamWriter" %>
<%@ page import="java.util.Properties" %>
<%@ include file="../OECD_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%
	Properties properties = new Properties();
	
	properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
	String filePath = properties.getProperty("OECD_LoadImage");
	String debt_acc_num = request.getParameter("debt_acc_num");
	String debtAccArr[] = debt_acc_num.split("#");
	WriteLog("filePath- " + filePath);
	WriteLog("debt_acc_num- " + debt_acc_num);

	for (int i = 0;i < debtAccArr.length;i++)
	{
		String fileTempName = debtAccArr[i]+"imageCreatedN";
		
		try {
			File dir = new File(filePath);
			File[] directoryListing  = dir.listFiles();
			for (File child : directoryListing) {
				if (child.getName().contains(fileTempName))
				{
					try {
							child.delete();
							WriteLog("Sucessfully deleted file- " + fileTempName);
						}
						catch (Exception e) {
							WriteLog("Error in deleting file- " + fileTempName);
						}
				}
			}
		
		}catch (Exception e)
		{			
			WriteLog("Error in deleting files");
		}
	}
%>