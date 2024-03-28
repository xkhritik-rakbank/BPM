<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application Projects
//Product / Project			 : RAKBank
//File Name					 : createPDF.jsp
//Author                     : Sivakumar P
//Date written (DD/MM/YYYY)  : 02-08-2018
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------
Revision 	Date 			Author 			Description
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
<%@ page import="java.math.*"%>
<%@ page import="java.io.BufferedWriter" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.OutputStreamWriter" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.itextpdf.text.pdf.AcroFields" %>
<%@ page import="com.itextpdf.text.pdf.BaseFont" %>
<%@ page import="com.itextpdf.text.pdf.PdfReader" %>
<%@ page import="com.itextpdf.text.pdf.PdfStamper" %>
<%@ page import="com.itextpdf.text.pdf.PdfWriter" %>
<%@ include file="Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%		
	WriteLog("\ncreatePDF : Inside service method : start");
	String strEncoding="UTF-8";
	try 
	{
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ReasonCodes", request.getParameter("option"), 1000, true) );
			String option = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: option: "+option);

			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sparam"), 1000, true) );
			String sparam = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: sparam: "+sparam);
			
			//String option = request.getParameter("option");
			//String sparam = request.getParameter("sparam");
			
			//WriteLog("\nValues For The Fields-- :- " + sparam);
			//WriteLog("\nName Of The PDF :- " + option);
			
			// creating a hashtable
			Hashtable<String, String> hashtable = new Hashtable<String, String>();
			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			String path = System.getProperty("user.dir");
			
			WriteLog(" \nAbsolute Path :" + path);

			//Getting Unique Date
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf1 = new SimpleDateFormat("ddMMyyyyHmmssSSS");
			String pdfTemplatePath = "";
			String generatedPdfPath = "";
			String pdfName = "";

			//Reading path from property file
			Properties properties = new Properties();
			properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
			
			
				//Generating the pdf for Acknowledgement********************************************************************************************************** 	
			if(option.equalsIgnoreCase("Generate_Acknowledgement")) 
			{
					WriteLog("\nInside Generate_Acknowledgement ");
					Enumeration<String> paramNames = request.getParameterNames();
					while(paramNames.hasMoreElements())
					{
						String paramName = (String)paramNames.nextElement();
						//WriteLog("\nparamName "+paramName + " : ");
						
						String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter(paramName), 1000, true) );
						String paramValue = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
						WriteLog("Integration jsp: Decision saveHistory: "+paramValue);
						
						//String paramValue = request.getParameter(paramName);
						paramValue = paramValue.replace("`~`","%");
						//WriteLog("\nparamValue "+paramValue);
						hashtable.put(paramName, paramValue);
					}
					pdfName = "Template_of_Acknowledgement";
					pdfTemplatePath = properties.getProperty("TF_PDF_Acknowledgement");
			}//*********************************************************************************************************************************************			
			
			String dynamicPdfName = "";
			if(option.equalsIgnoreCase("Generate_Acknowledgement")){
				dynamicPdfName = pdfName + ".pdf"; 
			}
			else 
			{
				dynamicPdfName = pdfName + "_" + System.currentTimeMillis()/1000*60 + ".pdf";
			}
			pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
			generatedPdfPath = properties.getProperty("TF_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
			generatedPdfPath += dynamicPdfName;
			generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
			WriteLog("\nGeneratedPdfPath inside createPDF jsp:" + generatedPdfPath);
			//WriteLog("\nht.size() :"+hashtable.size());
			
			PdfReader reader = new PdfReader(pdfTemplatePath);
			//WriteLog("Created reader object from template :");
			PdfStamper stamp = new PdfStamper(reader,new FileOutputStream(generatedPdfPath)); 	
			//WriteLog("Created stamper object from destination :");
			AcroFields form=stamp.getAcroFields();
			BaseFont unicode=BaseFont.createFont("C:/WINDOWS/Fonts/arabtype.ttf",BaseFont.IDENTITY_H,BaseFont.EMBEDDED);		
			//WriteLog("Created arabtype font:");
			ArrayList al=new ArrayList();
			al.add(unicode);
			form.setSubstitutionFonts(al);
			PdfWriter p= stamp.getWriter();
			p.setRunDirection(p.RUN_DIRECTION_RTL);  
			BaseFont bf1 = BaseFont.createFont (BaseFont.TIMES_ROMAN,BaseFont.CP1252,BaseFont.EMBEDDED);				
			form.addSubstitutionFont(bf1);                 
			//WriteLog("Created writer, set font times roman :");

			// Handling values form Hashtable
			Set PDFSet = hashtable.keySet();
			Iterator PDFIt = PDFSet.iterator();
			//WriteLog("Replacing values from hashtable:");
			while(PDFIt.hasNext()) 
			{
				String HT_Key 	= (String)PDFIt.next();
				String HT_Value	= (String)hashtable.get(HT_Key);
				//WriteLog("HT_Key : "+HT_Key + " HT_Value :"+HT_Value);
				form.setField(HT_Key,HT_Value);
			}
			//WriteLog("Values replaced from hashtable:");
			stamp.setFormFlattening(true);
			stamp.close();
			//WriteLog("Stamper closed:");
			out.clear();			
			out.print(dynamicPdfName);
			out.flush();
			WriteLog("\ncreatePDF : Inside service method : end");
	} 
	catch (IOException iex) 
	{
			WriteLog("\ncreatePDF : iex.getMessage() :" + iex.getMessage());
			iex.printStackTrace();
	} 
	catch (SecurityException se) 
	{
			WriteLog("\ncreatePDF : se.getMessage() :"	+ se.getMessage());
			se.printStackTrace();
	} 
	catch (Exception ex) 
	{
			WriteLog("\ncreatePDF : ex.getMessage() :"	+ ex.getMessage());
			ex.printStackTrace();
	}		
%>