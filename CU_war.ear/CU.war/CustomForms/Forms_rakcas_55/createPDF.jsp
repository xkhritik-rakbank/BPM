<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application Projects
//Product / Project			 : RAKBank
//File Name					 : createPDF.jsp
//Author                     : Amandeep
//Date written (DD/MM/YYYY)  :  12-07-2016
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

<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%		
		WriteLog("\ncreatePDF : Inside service method : start");
		String strEncoding="UTF-8";

		try {
			String option = request.getParameter("option");
			String sparam = request.getParameter("sparam");
			
			WriteLog("\nsparam createpdf-- :- " + sparam);
			WriteLog("\noption :- " + option);
			
			// creating a hashtable
			Hashtable<String, String> hashtable = new Hashtable<String, String>();

			SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
			String path = System.getProperty("user.dir");
			WriteLog(" \npath :" + path);

			// Getting Unique Date
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf1 = new SimpleDateFormat("ddMMyyyyHmmssSSS");
			WriteLog(" \nsdf :" + sdf);
			String pdfTemplatePath = "";
			String generatedPdfPath = "";

			String pdfName = "";

			// Reading path from property file
			Properties properties = new Properties();
			properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));

			if (option.equalsIgnoreCase("SignatureUpdate")) {

				pdfName = "SignatureUpdate";
				pdfTemplatePath = properties.getProperty("PDF_Signature");

				String dateValue = request.getParameter("Date1");
				String branchName = request.getParameter("Branch_Name");
				String acctNumber = request.getParameter("Account_Number");
				String winame = request.getParameter("wi_name");

				// Adding Key and Value pairs to Hashtable
				hashtable.put("Date1", dateValue);
				hashtable.put("Branch_Name", branchName);
				hashtable.put("Account_Number", acctNumber);
				hashtable.put("wi_name", winame);

			}

			else if (option.equalsIgnoreCase("CIF_Update_form")) {

				WriteLog("\nInside CIF_Update_form ");
				Enumeration<String> paramNames = request.getParameterNames();
				WriteLog("\nsparam :- " + sparam);

				while(paramNames.hasMoreElements()) {
					String paramName = (String)paramNames.nextElement();
					WriteLog("\nparamName "+paramName + " : ");
					String paramValue = request.getParameter(paramName);
					paramValue = paramValue.replace("`~`","%");
					WriteLog("\nparamValue "+paramValue);

					hashtable.put(paramName, paramValue);
				}

				pdfName = "CIF_Update_form";
				pdfTemplatePath = properties.getProperty("CU_PDF_PATH");
			}

			else if (option.equalsIgnoreCase("FATCA_Individual")) {

				WriteLog("\nInside FATCA_Individual ");
				Enumeration<String> paramNames = request.getParameterNames();

				WriteLog("\nsparam :- " + sparam);

				while(paramNames.hasMoreElements()) {
					String paramName = (String)paramNames.nextElement();
					WriteLog("\n paramName "+paramName + " : ");
					String paramValue = request.getParameter(paramName);
					WriteLog("\nparamValue "+paramValue);

					hashtable.put(paramName, paramValue);
				}

				pdfName = "FATCA_Individual";
				pdfTemplatePath = properties.getProperty("CU_PDF_Fatca");
			}
			else if (option.equalsIgnoreCase("SoleToJoint")) {
				pdfName = "SoleToJoint";
				pdfTemplatePath = properties.getProperty("PDF_SoleToJoint");

			}

			WriteLog("\ncreatePDF : pdfName :" + pdfName);
			String dynamicPdfName = pdfName + "_" + System.currentTimeMillis() + ".pdf";
			
			pdfTemplatePath = path + pdfTemplatePath;

			generatedPdfPath = properties.getProperty("CU_GENERTATED_PDF_PATH");
			generatedPdfPath += dynamicPdfName;
			generatedPdfPath = path + generatedPdfPath;

			WriteLog("\ncreatePDF : generatedPdfPath :" + generatedPdfPath);

			
			//createNewPDF(pdfTemplatePath, generatedPdfPath, hashtable);
			
			WriteLog("\nht.size() :"+hashtable.size());
			
			PdfReader reader = new PdfReader(pdfTemplatePath);
			WriteLog("Created reader object from template :");
			
			PdfStamper stamp = new PdfStamper(reader,new FileOutputStream(generatedPdfPath)); 	
			WriteLog("Created stamper object from destination :");
			
			AcroFields form=stamp.getAcroFields();
			BaseFont unicode=BaseFont.createFont("/ibm/IBM/WebSphere/AppServer/profiles/AppSrv01/installedApps/ant1casapps01Node01Cell/CU_war.ear/CU.war/PDFTemplates/template/arabtype.ttf",BaseFont.IDENTITY_H,BaseFont.EMBEDDED);		
			WriteLog("Created arabtype font:");
			
			ArrayList al=new ArrayList();
			al.add(unicode);
			
			form.setSubstitutionFonts(al);
			
			PdfWriter p= stamp.getWriter();
			p.setRunDirection(p.RUN_DIRECTION_RTL);  
			BaseFont bf1 = BaseFont.createFont (BaseFont.TIMES_ROMAN,BaseFont.CP1252,BaseFont.EMBEDDED);				
			form.addSubstitutionFont(bf1);                 
			WriteLog("Created writer, set font times roman :");

			// Handling values form Hashtable
			Set PDFSet = hashtable.keySet();
			Iterator PDFIt = PDFSet.iterator();
			WriteLog("Replacing values from hashtable:");
			while(PDFIt.hasNext()) {
				String HT_Key 	= (String)PDFIt.next();
				String HT_Value	= (String)hashtable.get(HT_Key);
				WriteLog("HT_Key : "+HT_Key + " HT_Value :"+HT_Value);
				form.setField(HT_Key,HT_Value);
			}
			
			WriteLog("Values replaced from hashtable:");
			stamp.setFormFlattening(true);
			stamp.close();
			WriteLog("Stamper closed:");		
			
			
			WriteLog("\ncreatePDF : pdfTemplatePath :"	+ generatedPdfPath);
			out.clear();			
			WriteLog("\ncreatePDF : dynamicPdfName :"	+ dynamicPdfName);
			out.print(dynamicPdfName);
			out.flush();
			
			WriteLog("\ncreatePDF : Inside service method : end");
		} catch (IOException iex) {
			WriteLog("\ncreatePDF : iex.getMessage() :" + iex.getMessage());
			iex.printStackTrace();
		} catch (SecurityException se) {
			WriteLog("\ncreatePDF : se.getMessage() :"	+ se.getMessage());
			se.printStackTrace();
		} catch (Exception ex) {
			WriteLog("\ncreatePDF : ex.getMessage() :"	+ ex.getMessage());
			ex.printStackTrace();
		}		
		%>