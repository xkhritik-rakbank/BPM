<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application Projects
//Product / Project			 : RAKBank
//File Name					 : DeleteSignFromServer.jsp
//Author                     : Mandeep
//Date written (DD/MM/YYYY) :  19-05-2016
//Date written (DD/MM/YYYY) :  19-05-2016
//---------------------------------------------------------------------------------------------------->
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
<%@ page import="java.io.*,java.util.*,java.math.*"%>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.OutputStreamWriter" %>
<%@ page import="java.util.Properties" %>
<%@ include file="../TWC_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%
	logger.info("Inside DeleteGeneratedTemplate");
	
	Properties properties = new Properties();
	
	properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
	String filePath = properties.getProperty("TWC_GENERTATED_HTML_PATH");
	filePath = filePath.replace('\\','/');
	
	String pdfname = request.getParameter("pdfname");
	pdfname = pdfname.replace('\\','/');
	
	String usrdir = System.getProperty("user.dir");
	usrdir = usrdir.replace('\\','/');
	
	logger.info("Final path to be deleted- "+usrdir+filePath+pdfname);
	
	File file = new File (usrdir+filePath+pdfname);
	try {
		if (file.delete()){
			logger.info("File deleted");
		}else{
			logger.info("File not deleted");
		}
	} catch(Exception e) {
		logger.info("Error in File not deletion");
	}
%>