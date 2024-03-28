<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.itextpdf.text.Document" %>
<%@page import="com.itextpdf.text.Font" %>
<%@page import="com.itextpdf.text.Font.FontFamily" %>
<%@page import="com.itextpdf.text.Image" %>
<%@page import="com.itextpdf.text.PageSize" %>
<%@page import="com.itextpdf.text.Paragraph" %>
<%@page import="com.itextpdf.text.pdf.PdfPTable" %>
<%@page import="com.itextpdf.text.pdf.PdfWriter" %>
<%@page import="com.itextpdf.text.Element" %>
<%@page import="com.itextpdf.text.Phrase" %>
<%@page import="com.itextpdf.text.pdf.PdfPCell"%>
<%@page import="com.itextpdf.text.BaseColor"%>
<%@page import="com.itextpdf.text.pdf.PdfContentByte"%>
<%@page import="com.itextpdf.text.Rectangle"%>
<%@ include file="../SRB_Specific/Log.process"%>
<%@page import="java.text.*"%>

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>


<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>


<!DOCTYPE html>
<html>
 <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Rak Bank</title>
        <style>td {
                border: 1px solid black;
            }
        </style>
    </head>
	

    <body>
	  <table width="100%">
            <tr>
                <td style="border:0px"> <img src="bank-logo.jpg" alt="ESAF" align="right" height="150" width="200"/> </td></tr>
            <tr>
                <td style="border:0px" align="center" > <h2><p class="HeadingText">Rakbank<p></h2> </td>
            </tr>
        </table> 
		
		<%
		try{
        String Xmlout="";
	//	String WINAME = request.getParameter("WINAME");
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );    
		String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		WriteLog("WINAME--" + WINAME);
		//String SRBFormHeader = request.getParameter("SRBFormHeader");
		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SRBFormHeader"), 1000, true) );    
		String SRBFormHeader = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
		WriteLog("SRBFormHeader--" + SRBFormHeader);
	//	String CategoryName=request.getParameter("CategoryName");
		String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CategoryName"), 1000, true) );    
		String CategoryName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
		WriteLog("CategoryName--" + CategoryName);
		//String SubCategoryName=request.getParameter("SubCategoryName");
		String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCategoryName"), 1000, true) );    
		String SubCategoryName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
		WriteLog("SubCategoryName--" + SubCategoryName);
		//String DecisionValues=request.getParameter("DecisionValues");
		String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("DecisionValues"), 1000, true) );    
		String DecisionValues = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
		WriteLog("DecisionValues--" + DecisionValues);
		//String RemarksValues=request.getParameter("RemarksValues");
		String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("RemarksValues"), 1000, true) );    
		String RemarksValues = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
		WriteLog("RemarksValues--" + RemarksValues);
		//String tempStaticLabels = request.getParameter("tempStaticLabels");
		String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tempStaticLabels"), 1000, true) );    
		String tempStaticLabels = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
		WriteLog("tempStaticLabels--" + tempStaticLabels);
		//String tempStaticValues = request.getParameter("tempStaticValues");
		String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tempStaticValues"), 1000, true) );    
		String tempStaticValues = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
		WriteLog("tempStaticValues--" + tempStaticValues);
		//String StaticRowLength=request.getParameter("StaticRowLength");
		String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("StaticRowLength"), 1000, true) );    
		String StaticRowLength = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
		//WriteLog("StaticRowLength--" + StaticRowLength);
		int StaticLength = Integer.valueOf(StaticRowLength);
		WriteLog("ParseInt StaticLength--" + StaticLength);
		
		//String ServiceRequestName = request.getParameter("ServiceRequestName");
		String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ServiceRequestName"), 1000, true) );    
		String ServiceRequestName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
		WriteLog("ServiceRequestName--" + ServiceRequestName);
		//String ColumnNames = request.getParameter("ColumnNames");
		String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ColumnNames"), 1000, true) );    
		String ColumnNames = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
		WriteLog("ColumnNames--" + ColumnNames);
		//String ColumnValues = request.getParameter("ColumnValues");
		String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ColumnValues"), 1000, true) );    
		String ColumnValues = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
		WriteLog("ColumnValues--" + ColumnValues);
		//String Length=request.getParameter("DynamicRowLength");
		String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("DynamicRowLength"), 1000, true) );    
		String Length = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
		WriteLog("Length--" + Length);
		int DynamicRowLength = Integer.valueOf(Length);
		WriteLog("ParseInt DynamicRowLength--" + DynamicRowLength);
		//String DynamicGridLength=request.getParameter("GridTableLength");
		String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("GridTableLength"), 1000, true) );    
		String DynamicGridLength = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
		WriteLog("DynamicGridLength--" + DynamicGridLength);
		int GridLength = Integer.valueOf(DynamicGridLength);
		WriteLog("GridLength--" + GridLength);
		//String DispatchValues = request.getParameter("DispatchValues");
		String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("DispatchValues"), 1000, true) );    
		String DispatchValues = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
		WriteLog("DispatchValues--" + DispatchValues);
		
		String[] StaticLabelsarray = tempStaticLabels.split("~");
		
            for (int i = 0; i < StaticLabelsarray.length; i++) {
				//WriteLog("tempStaticLabels--" + tempStaticLabels);
                //WriteLog("StaticLabelsarray value" + StaticLabelsarray[i]);
            }
		String[] StaticValuesarray = tempStaticValues.split("~");
            System.out.println("StaticValuesarray split length" + StaticValuesarray.length);
            for (int i = 0; i < StaticValuesarray.length; i++) {
                System.out.println("StaticValuesarray value" + StaticValuesarray[i]);
				//WriteLog("StaticValuesarray--" + StaticValuesarray[i]);
            }
		
		String[] ColumnNamesarray = ColumnNames.split("~");
		
            for (int i = 0; i < ColumnNamesarray.length; i++) {
				//WriteLog("ColumnNames--" + ColumnNames);
                //WriteLog("ColumnNamesarray value" + ColumnNamesarray[i]);
            }
		String[] ColumnValuesarray = ColumnValues.split("~");
            System.out.println("ColumnValuesarray split length" + ColumnValuesarray.length);
            for (int i = 0; i < ColumnValuesarray.length; i++) {
                System.out.println("ColumnValuesarray value" + ColumnValuesarray[i]);
				//WriteLog("ColumnValuesarray--" + ColumnValuesarray);
            }
			
			int DispatchLength;
			String[] DispatchValuesarray = DispatchValues.split("~");
			if(DispatchValues.equals("") || DispatchValues == null)
			{
				DispatchLength=0;
				WriteLog("DispatchValues null " + DispatchValues);
			}
			else
			{			
            WriteLog("DispatchValuesarray split length" + DispatchValuesarray.length);
			DispatchLength=3;
			
			for (int i = 0; i < DispatchLength; i++)
				{
                WriteLog("DispatchValuesarray value" + DispatchValuesarray[i]);
					if(DispatchValuesarray[i].equals("") || DispatchValuesarray[i] == null)
					{
						DispatchValuesarray[i]="";
						//WriteLog("DispatchValuesarray--if loop-" + DispatchValuesarray[i]);
					}
				}
			}
		
			
		String path = System.getProperty("user.dir");
		WriteLog(" \nAbsolute Path :" + path);		
		String pdfTemplatePath = "";
		String generatedPdfPath = "";
		String pdfName = "";
		
		String imgPath = "";
		String generatedimgPath = "";
		


		//Reading path from property file
		Properties properties = new Properties();
		properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
			
		
		pdfName = "Receipt_Acknoledgement_Proof";
                
			String dynamicPdfName =  WINAME+ pdfName + ".pdf";
		
			pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
			generatedPdfPath = properties.getProperty("SRB_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
			generatedPdfPath += dynamicPdfName;
			generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
			WriteLog("\nGeneratedPdfPath :" + generatedPdfPath);
			
				
		FileOutputStream fileOutputStream = new FileOutputStream(generatedPdfPath);
            Document doc = new Document(PageSize.A4);
            PdfWriter writer = PdfWriter.getInstance(doc, fileOutputStream);
            writer.open();
            doc.open();
            Font bold = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
			
			String dynamicimgName = "bank-logo.gif";
			imgPath = path + imgPath;
			generatedimgPath = properties.getProperty("RAO_LoadLogo");
			generatedimgPath += dynamicimgName;
			generatedimgPath = path + generatedimgPath;
			WriteLog("\ngeneratedimgPath :" + generatedimgPath);
			
			
			
            Image img = Image.getInstance(generatedimgPath);
            Paragraph preface = new Paragraph();
            img.setAlignment(Image.ALIGN_RIGHT);  
            img.scaleAbsolute(60f, 40f);
            preface.add(img);			
              
            doc.add(preface);
						
			//SRBFormHeader Table
			PdfPTable pdf1 = new PdfPTable(4);
			pdf1.setHorizontalAlignment(Element.ALIGN_CENTER);
			int[] columnWidths = {2,2,2,2};
			pdf1.setWidths(columnWidths);
			//WriteLog("\ncolumnWidths :");
			pdf1.setSpacingBefore(10f);
            pdf1.setSpacingAfter(12.5f);
         	pdf1.setWidthPercentage(100);
			
		
			Font sbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell a1 = new PdfPCell(new Phrase(SRBFormHeader,sbld1));
            a1.setBackgroundColor(new BaseColor(153, 0, 51));
			a1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
   			a1.setColspan(4);
			pdf1.addCell(a1);
			
			Font sbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
			Font sbold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));
			
            PdfPCell a2 = new PdfPCell(new Phrase("ColumnNamesarray[i]",sbld1));
            a2.setBackgroundColor(new BaseColor(153, 0, 51));
			a2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf1.addCell(h2);
			
            PdfPCell a3 = new PdfPCell(new Phrase("ColumnNamesarray[i]",sbld1));
            a3.setBackgroundColor(new BaseColor(153, 0, 51));
			a3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf1.addCell(h3);
			
            PdfPCell a4 = new PdfPCell(new Phrase("ColumnNamesarray[i]",sbld1));
            a4.setBackgroundColor(new BaseColor(153, 0, 51));
			a4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf1.addCell(h4);
						
			for(int i=0;i<StaticLabelsarray.length;i++)
			{
				a1 = new PdfPCell(new Phrase(StaticLabelsarray[i],sbold2));
				//WriteLog("Aftr StaticLabelsarray "+StaticLabelsarray[i]);
				a1.setBackgroundColor(new BaseColor(255,251,240));
				a1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				pdf1.addCell(a1);			
				
				a2 = new PdfPCell(new Phrase(StaticValuesarray[i],sbold1));
				//WriteLog("Aftr StaticValuesarray "+StaticValuesarray[i]);
				a2.setBackgroundColor(new BaseColor(255, 251, 240));
				a2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
				pdf1.addCell(a2);
				
				i=i+1;

					a3 = new PdfPCell(new Phrase(StaticLabelsarray[i],sbold2));
					//WriteLog("Aftr StaticLabelsarray "+StaticLabelsarray[i]);
					a3.setBackgroundColor(new BaseColor(255, 251, 240));
					a3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf1.addCell(a3);
					
					a4 = new PdfPCell(new Phrase(StaticValuesarray[i],sbold1));  
					//WriteLog("Aftr StaticValuesarray "+StaticValuesarray[i]);				
					a4.setBackgroundColor(new BaseColor(255, 251, 240));
					a4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf1.addCell(a4);
					
			}
			doc.add(pdf1);
			
			//Request Details Table
            PdfPTable pdf3 = new PdfPTable(4);
			pdf3.setHorizontalAlignment(Element.ALIGN_CENTER);
			int[] columnWidths3 = {2,2,2,2};
			pdf3.setWidths(columnWidths3);
			//WriteLog("\ncolumnWidths :");
         	pdf3.setWidthPercentage(100);
			
		
			Font ybld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell c1 = new PdfPCell(new Phrase("Request Details",ybld1));
            c1.setBackgroundColor(new BaseColor(153, 0, 51));
			c1.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
   			c1.setColspan(4);
			pdf3.addCell(c1);
			
            PdfPCell c2 = new PdfPCell(new Phrase("ColumnNamesarray[i]",ybld1));
            c2.setBackgroundColor(new BaseColor(153, 0, 51));
			c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf3.addCell(c2);
			
            PdfPCell c3 = new PdfPCell(new Phrase("ColumnNamesarray[i]",ybld1));
            c3.setBackgroundColor(new BaseColor(153, 0, 51));
			c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf3.addCell(c3);
			
            PdfPCell c4 = new PdfPCell(new Phrase("ColumnNamesarray[i]",ybld1));
            c4.setBackgroundColor(new BaseColor(153, 0, 51));
			c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf3.addCell(c4);
						
			Font ybold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
			
				c1 = new PdfPCell(new Phrase("Service Request Category",ybold1));
				c1.setBackgroundColor(new BaseColor(255,251,240));
				c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				pdf3.addCell(c1);			
				
				c2 = new PdfPCell(new Phrase(CategoryName,ybold1));
				//WriteLog("Aftr CategoryName "+CategoryName);
				c2.setBackgroundColor(new BaseColor(255, 255, 255));
				c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
				pdf3.addCell(c2);				
				
						c3 = new PdfPCell(new Phrase("Service Request Type",ybold1));
						c3.setBackgroundColor(new BaseColor(255, 251, 240));
						c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						pdf3.addCell(c3);
						
						c4 = new PdfPCell(new Phrase(SubCategoryName,ybold1));  
						//WriteLog("Aftr SubCategoryName "+SubCategoryName);				
						c4.setBackgroundColor(new BaseColor(255, 255, 255));
						c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
						pdf3.addCell(c4);
					
			doc.add(pdf3);
			
			//ServiceRequest Table
            PdfPTable pdf = new PdfPTable(4);
			pdf.setHorizontalAlignment(Element.ALIGN_CENTER);
			int[] columnWidths1 = {2,2,2,2};
			pdf.setWidths(columnWidths1);
			//WriteLog("\ncolumnWidths :");
			pdf.setSpacingBefore(40f);
            pdf.setSpacingAfter(22.5f);
         	pdf.setWidthPercentage(100);
			
		
			Font fbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell h1 = new PdfPCell(new Phrase(ServiceRequestName,fbld1));
            h1.setBackgroundColor(new BaseColor(153, 0, 51));
			h1.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
   			h1.setColspan(4);
			pdf.addCell(h1);
			
			Font fbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell h2 = new PdfPCell(new Phrase("ColumnNamesarray[i]",fbold1));
            h2.setBackgroundColor(new BaseColor(153, 0, 51));
			h2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf.addCell(h2);
			
			Font fbold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell h3 = new PdfPCell(new Phrase("ColumnNamesarray[i]",fbold2));
            h3.setBackgroundColor(new BaseColor(153, 0, 51));
			h3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf.addCell(h3);
			
			Font fbold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell h4 = new PdfPCell(new Phrase("ColumnNamesarray[i]",fbold3));
            h4.setBackgroundColor(new BaseColor(153, 0, 51));
			h4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf.addCell(h4);
						
			Font fbold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
			Font fbold5 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
			Font fbold6 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
			Font fbold7 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));	
				
			WriteLog("ColumnNamesarray.length-- "+ColumnNamesarray.length);
			for(int i=0;i<ColumnNamesarray.length;i++)
			{
				WriteLog("iiiiiiiiii "+i);
				h1 = new PdfPCell(new Phrase(ColumnNamesarray[i],fbold4));
				WriteLog("Aftr ColumnNamesarray "+ColumnNamesarray[i]);
				h1.setBackgroundColor(new BaseColor(255,251,240));
				h1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				pdf.addCell(h1);			
				
				if(ColumnNamesarray[i].equalsIgnoreCase("Open WI"))
				{
				h2 = new PdfPCell(new Phrase("",fbold5));
				WriteLog("Aftr ColumnValuesarray "+ColumnValuesarray[i]);
				h2.setBackgroundColor(new BaseColor(255, 251, 240));
				h2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
				pdf.addCell(h2);
				}
				else
				{
				h2 = new PdfPCell(new Phrase(ColumnValuesarray[i],fbold5));
				WriteLog("Aftr ColumnValuesarray "+ColumnValuesarray[i]);
				h2.setBackgroundColor(new BaseColor(255, 255, 255));
				h2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
				pdf.addCell(h2);
				}
				
				WriteLog("Integer.valueOf(ColumnNamesarray.length-1)-- "+Integer.valueOf(ColumnNamesarray.length-1));
				//ServiceRequest Containing One Column
				if(i!=(Integer.valueOf(ColumnNamesarray.length-1)))
				{
				i=i+1;
				WriteLog("Aftr iiiii "+i+" DynamicRowLength+2"+(DynamicRowLength+2));
					if(i==(DynamicRowLength+2))
					{
						WriteLog("if--iiiiiiiiiii"+i);
						h3 = new PdfPCell(new Phrase("",fbold6));
						WriteLog("Aftr ColumnNamesarray ");
						h3.setBackgroundColor(new BaseColor(255, 251, 240));
						h3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						pdf.addCell(h3);
						
						h4 = new PdfPCell(new Phrase("",fbold7));  
						WriteLog("Aftr ColumnValuesarray ");				
						h4.setBackgroundColor(new BaseColor(255, 255, 255));
						h4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
						pdf.addCell(h4);
					}
					
					else if(i==(GridLength+1) && GridLength!=0)
					{
						WriteLog("else if--iiiiiiiiiii"+i);
						h3 = new PdfPCell(new Phrase("",fbold6));
						WriteLog("Aftr ColumnNamesarray ");
						h3.setBackgroundColor(new BaseColor(255, 251, 240));
						h3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						pdf.addCell(h3);
						
						h4 = new PdfPCell(new Phrase("",fbold7));  
						WriteLog("Aftr ColumnValuesarray ");				
						h4.setBackgroundColor(new BaseColor(255, 255, 255));
						h4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
						pdf.addCell(h4);
					}
					
					else
					{
						WriteLog("else--iiiiiiiiiiii"+i);
					h3 = new PdfPCell(new Phrase(ColumnNamesarray[i],fbold6));
					WriteLog("Aftr ColumnNamesarray "+ColumnNamesarray[i]);
					h3.setBackgroundColor(new BaseColor(255, 251, 240));
					h3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf.addCell(h3);
					
					h4 = new PdfPCell(new Phrase(ColumnValuesarray[i],fbold7));  
					WriteLog("Aftr ColumnValuesarray "+ColumnValuesarray[i]);				
					h4.setBackgroundColor(new BaseColor(255, 255, 255));
					h4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf.addCell(h4);
					}
				}
				else
				{
						h3 = new PdfPCell(new Phrase("",fbold6));
						
						h3.setBackgroundColor(new BaseColor(255, 251, 240));
						h3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						pdf.addCell(h3);
						
						h4 = new PdfPCell(new Phrase("",fbold7));  
										
						h4.setBackgroundColor(new BaseColor(255, 255, 255));
						h4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
						pdf.addCell(h4);
				}
			}
			doc.add(pdf);
			 
			//ServiceRequest Table Grid
			if(GridLength>0)
			{				
				PdfContentByte cb = writer.getDirectContent();
				//pdf4.writeSelectedRows(0, 200, 190, pdf4.getTotalHeight()+380, cb);
				// Add a rectangle
				 Rectangle rect = new Rectangle(40, 445, 100, 420);
				 rect.setBorder(Rectangle.BOX);
				 rect.setBorderWidth(1);
				 cb.rectangle(rect);
				 
				 // Add a rectangle
				 Rectangle rect1 = new Rectangle(160, 445, 100, 420);
				 rect1.setBorder(Rectangle.BOX);
				 rect1.setBorderWidth(1);
				 cb.rectangle(rect1);
				 
				 // Add a rectangle
				 Rectangle rect2 = new Rectangle(220, 445, 100, 420);
				 rect2.setBorder(Rectangle.BOX);
				 rect2.setBorderWidth(1);
				 cb.rectangle(rect2);

				 Font bold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD,new BaseColor(0,0,0));
				 preface = new Paragraph("	         Add                	Modify   	        Delete",bold1);
				preface.setAlignment(Element.ALIGN_JUSTIFIED);
				doc.add(preface);
				
				PdfPTable pdf2 = new PdfPTable(4);
				pdf2.setHorizontalAlignment(Element.ALIGN_CENTER);
				int[] columnWidths2 = {2,2,2,2};
				pdf2.setWidths(columnWidths2);
				//WriteLog("\ncolumnWidths :");
				//pdf2.setSpacingBefore(10f);
				//pdf2.setSpacingAfter(12.5f);
				pdf2.setWidthPercentage(100);			
			
					int l=0;
					Font tbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					PdfPCell b1 = new PdfPCell(new Phrase("Select",tbld1));
					b1.setBackgroundColor(new BaseColor(153, 0, 51));
						b1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						pdf2.addCell(b1);	
					
						PdfPCell b2 = new PdfPCell(new Phrase(ColumnNamesarray[l],tbld1));
						b2.setBackgroundColor(new BaseColor(153, 0, 51));
						b2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						pdf2.addCell(b2);
						
					
						PdfPCell b3 = new PdfPCell(new Phrase(ColumnNamesarray[l+1],tbld1));
						b3.setBackgroundColor(new BaseColor(153, 0, 51));
						b3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						
						Font tbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
						
						PdfPCell b4;
						//WriteLog("Integer.valueOf(ColumnNamesarray.length) "+Integer.valueOf(ColumnNamesarray.length));
						if(Integer.valueOf(ColumnNamesarray.length)!=3)
						{
						b3.setColspan(2);
						pdf2.addCell(b3);	
												
							b4 = new PdfPCell(new Phrase("",tbld1));
							b4.setBackgroundColor(new BaseColor(153, 0, 51));
							b4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						}
					//WriteLog("Integer.valueOf(ColumnNamesarray.length) "+Integer.valueOf(ColumnNamesarray.length));
						else
						{
							//WriteLog("Integer.valueOf( inside else");
							pdf2.addCell(b3);
							
							b4 = new PdfPCell(new Phrase(ColumnNamesarray[l+2],tbld1));
							b4.setBackgroundColor(new BaseColor(153, 0, 51));
							b4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							pdf2.addCell(b4);	
						}
					
					//WriteLog("ColumnNamesarray.length-- "+ColumnNamesarray.length);
					String[][] GridValuesarray=new String[GridLength-1][ColumnValuesarray.length];
				for(int i=0;i<GridLength-1;i++)
				{
					l=0;
					//WriteLog("llllllllllll "+l);
					b1 = new PdfPCell(new Phrase(""));
					//WriteLog("Aftr GridValuesarray ");
					b1.setBackgroundColor(new BaseColor(255,251,240));
					b1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf2.addCell(b1);			
					
					GridValuesarray[i][l]=ColumnValuesarray[l];
					b2 = new PdfPCell(new Phrase(GridValuesarray[i][l],tbold1));
					//WriteLog("Aftr GridValuesarray "+GridValuesarray[i][l]);
					b2.setBackgroundColor(new BaseColor(255, 251, 240));
					b2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf2.addCell(b2);	
						
						GridValuesarray[i][l+1]=ColumnValuesarray[l+1];
						b3 = new PdfPCell(new Phrase(GridValuesarray[i][l+1],tbold1));
						//WriteLog("Aftr GridValuesarray "+GridValuesarray[i][l+1]);
						b3.setBackgroundColor(new BaseColor(255, 251, 240));
						b3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						
						//WriteLog("Integer.valueOf(ColumnValuesarray.length) "+Integer.valueOf(ColumnValuesarray.length));						
						if(Integer.valueOf(ColumnValuesarray.length)!=3)
						{
							b3.setColspan(2);
							pdf2.addCell(b3);
						
							b4 = new PdfPCell(new Phrase("",tbold1));  
							//WriteLog("Aftr GridValuesarray ");				
							b4.setBackgroundColor(new BaseColor(255, 251, 240));
							b4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							pdf2.addCell(b4);
						}
						else
						{
							//WriteLog("Integer.valueOf( inside iff");
							pdf2.addCell(b3);
							
						GridValuesarray[i][l+2]=ColumnValuesarray[l+2];
						b4 = new PdfPCell(new Phrase(GridValuesarray[i][l+2],tbold1));  
						//WriteLog("Aftr GridValuesarray "+GridValuesarray[i][l+2]);				
						b4.setBackgroundColor(new BaseColor(255, 251, 240));
						b4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
						pdf2.addCell(b4);
						}
						
				}
				 doc.add(pdf2);
			}
			
			//DispatchGrid Table
			if(DispatchLength>0)
			{
            PdfPTable pdf5 = new PdfPTable(4);
			pdf5.setHorizontalAlignment(Element.ALIGN_CENTER);
			int[] columnWidths5 = {2,2,2,2};
			pdf5.setWidths(columnWidths5);
			//WriteLog("\ncolumnWidths :");
			pdf5.setSpacingBefore(30f);
            pdf5.setSpacingAfter(32.5f);
         	pdf5.setWidthPercentage(100);
			int d=0;
		
			Font ebld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell e1 = new PdfPCell(new Phrase("Dispatch Details",ebld1));
            e1.setBackgroundColor(new BaseColor(153, 0, 51));
			e1.setHorizontalAlignment(PdfPCell.ALIGN_LEFT);
   			e1.setColspan(4);
			pdf5.addCell(e1);
			
			Font ebold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
            PdfPCell e2 = new PdfPCell(new Phrase("ColumnNamesarray[i]",ebold1));
            e2.setBackgroundColor(new BaseColor(153, 0, 51));
			e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			//pdf5.addCell(h2);
			
		 	Font ebold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
						PdfPCell e3 = new PdfPCell(new Phrase("",ebold2));
						e3.setBackgroundColor(new BaseColor(153, 0, 51));
						e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						//pdf5.addCell(d3);
						
			Font ebold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
						PdfPCell e4 = new PdfPCell(new Phrase("",ebold3));
						e4.setBackgroundColor(new BaseColor(153, 0, 51));
						e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
						//pdf5.addCell(d3);
									
				Font ebold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));	
				e1 = new PdfPCell(new Phrase("Mode Of Delivery",ebold4));
				e1.setBackgroundColor(new BaseColor(255,251,240));
				e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				pdf5.addCell(e1);			
				
				Font ebold5 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
				Font ebold6 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));
				Font ebold7 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
				Font ebold8 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));	
				Font ebold9 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
				Font ebold10 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));
				Font ebold11 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));	
				Font ebold12 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));	
				Font ebold13 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));	
				Font ebold14 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));
				Font ebold15 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));	
				
				if(DispatchLength==6)
				{
					WriteLog("Aftr DispatchLength "+DispatchLength);						
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d],ebold5));
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
						
					e3 = new PdfPCell(new Phrase("Document Collection Branch",ebold6));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
						
					e4 = new PdfPCell(new Phrase(DispatchValuesarray[d+1],ebold7));  
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d+1]);				
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);	
					
					
					e1 = new PdfPCell(new Phrase("Branch Delivery Method",ebold8));
					e1.setBackgroundColor(new BaseColor(255,251,240));
					e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e1);
					
						
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d+2],ebold9));
					//WriteLog("Aftr DispatchValuesarray[d+2] "+DispatchValuesarray[d+2]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
						
					e3 = new PdfPCell(new Phrase("Courier AWB Number",ebold10));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					
					e4 = new PdfPCell(new Phrase(DispatchValuesarray[d+3],ebold11));
					//WriteLog("Aftr DispatchValuesarray[d+3] "+DispatchValuesarray[d+3]);
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);
					
					
					e1 = new PdfPCell(new Phrase("Courier Company Name",ebold12));
					e1.setBackgroundColor(new BaseColor(255,251,240));
					e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e1);	
				
					
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d+4],ebold13));
					//WriteLog("Aftr DispatchValuesarray[d+4] "+DispatchValuesarray[d+4]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
						
					e3 = new PdfPCell(new Phrase("Branch AWB Number",ebold14));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					
					e4 = new PdfPCell(new Phrase(DispatchValuesarray[d+5],ebold15));  
					//WriteLog("Aftr DispatchValuesarray[d+5] "+DispatchValuesarray[d+5]);				
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);
					
				}
				else if(DispatchLength==5)
				{
					WriteLog("Aftr DispatchLength "+DispatchLength);
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d],ebold5));
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
						
					e3 = new PdfPCell(new Phrase("Document Collection Branch",ebold6));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
						
					e4 = new PdfPCell(new Phrase(DispatchValuesarray[d+1],ebold7));  
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d+1]);				
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);	
					
					
					e1 = new PdfPCell(new Phrase("Branch Delivery Method",ebold8));
					e1.setBackgroundColor(new BaseColor(255,251,240));
					e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e1);
					
						
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d+2],ebold9));
					//WriteLog("Aftr DispatchValuesarray[d+2] "+DispatchValuesarray[d+2]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
						
					e3 = new PdfPCell(new Phrase("Courier AWB Number",ebold10));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					
					e4 = new PdfPCell(new Phrase(DispatchValuesarray[d+3],ebold11));
					//WriteLog("Aftr DispatchValuesarray[d+3] "+DispatchValuesarray[d+3]);
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);
					
					
					e1 = new PdfPCell(new Phrase("Courier Company Name",ebold12));
					e1.setBackgroundColor(new BaseColor(255,251,240));
					e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e1);	
				
					
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d+4],ebold13));
					//WriteLog("Aftr DispatchValuesarray[d+4] "+DispatchValuesarray[d+4]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
						
					e3 = new PdfPCell(new Phrase("Branch AWB Number",ebold14));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					
					e4 = new PdfPCell(new Phrase("",ebold15));  
					//WriteLog("Aftr DispatchValuesarray[d+5] "+DispatchValuesarray[d+5]);				
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);
					
				}
				else
				{
					WriteLog("Aftr DispatchLength "+DispatchLength);
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d],ebold5));
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
					e3 = new PdfPCell(new Phrase("Document Collection Branch",ebold6));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					e4 = new PdfPCell(new Phrase(DispatchValuesarray[d+1],ebold7));  
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d+1]);				
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);	
					
					e1 = new PdfPCell(new Phrase("Branch Delivery Method",ebold8));
					e1.setBackgroundColor(new BaseColor(255,251,240));
					e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e1);
					
					e2 = new PdfPCell(new Phrase(DispatchValuesarray[d+2],ebold9));
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d+2]);
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
					e3 = new PdfPCell(new Phrase("Courier AWB Number",ebold10));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					e4 = new PdfPCell(new Phrase("",ebold11));
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d+3]);
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);
					
					e1 = new PdfPCell(new Phrase("Courier Company Name",ebold12));
					e1.setBackgroundColor(new BaseColor(255,251,240));
					e1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e1);	
				
					e2 = new PdfPCell(new Phrase("",ebold13));
					e2.setBackgroundColor(new BaseColor(255, 255, 255));
					e2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e2);
					
					e3 = new PdfPCell(new Phrase("Branch AWB Number",ebold14));
					e3.setBackgroundColor(new BaseColor(255, 251, 240));
					e3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					pdf5.addCell(e3);
					
					e4 = new PdfPCell(new Phrase("",ebold15));  
					//WriteLog("Aftr DispatchValuesarray[d] "+DispatchValuesarray[d+4]);				
					e4.setBackgroundColor(new BaseColor(255, 255, 255));
					e4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf5.addCell(e4);
					
				}										
			doc.add(pdf5);
			}
			//DecisionGrid Table
            PdfPTable pdf4 = new PdfPTable(4);
			pdf4.setHorizontalAlignment(Element.ALIGN_CENTER);
			int[] columnWidths4 = {2,2,2,2};
			pdf4.setWidths(columnWidths4);
			//WriteLog("\ncolumnWidths :");
			pdf4.setSpacingBefore(30f);
            pdf4.setSpacingAfter(32.5f);
         	pdf4.setWidthPercentage(100);
			
		
			Font rbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(0,0,0));
            PdfPCell d1 = new PdfPCell(new Phrase("Decision",rbld1));
			d1.setFixedHeight(61f);
            d1.setBackgroundColor(new BaseColor(255, 251, 240));
			d1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
   			//d1.setColspan(2);
			pdf4.addCell(d1);
			
			Font rbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.NORMAL,new BaseColor(0,0,0));
            PdfPCell d2 = new PdfPCell(new Phrase(DecisionValues,rbold1));
			d2.setFixedHeight(61f);
            d2.setBackgroundColor(new BaseColor(255, 255, 255));
			d2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			pdf4.addCell(d2);
			
			PdfPCell d3 = new PdfPCell(new Phrase("CSO Signature",rbld1));
			d3.setFixedHeight(61f);
			d3.setBackgroundColor(new BaseColor(255, 251, 240));
			d3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			pdf4.addCell(d3); 
			
			PdfPCell d4 = new PdfPCell(new Phrase("",rbold1));
			d4.setFixedHeight(61f);
			d4.setBackgroundColor(new BaseColor(255, 255, 255));
			d4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
			pdf4.addCell(d4);
											
				d1 = new PdfPCell(new Phrase("Customer Signature",rbld1));
				d1.setFixedHeight(61f);
				d1.setBackgroundColor(new BaseColor(255,251,240));
				d1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				pdf4.addCell(d1);			
				
				d2 = new PdfPCell(new Phrase("",rbold1));
				d2.setFixedHeight(61f);
				d2.setBackgroundColor(new BaseColor(255, 255, 255));
				d2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
				pdf4.addCell(d2);
				
				d3 = new PdfPCell(new Phrase("CSM Signature",rbld1));
				d3.setFixedHeight(61f);
				d3.setBackgroundColor(new BaseColor(255, 251, 240));
				d3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				pdf4.addCell(d3);
					
					d4 = new PdfPCell(new Phrase("",rbold1));  	
					d4.setFixedHeight(61f);					
					d4.setBackgroundColor(new BaseColor(255, 255, 255));
					d4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);			
					pdf4.addCell(d4);					
			
			doc.add(pdf4);
			 
            doc.close();
		WriteLog("\n PDF Generated Successfully in target location");
		out.println("NG200~"+dynamicPdfName);
		}
		catch(Exception e)
		{
		out.println("NG500~"+e);
		e.printStackTrace();
		//sMappOutPutXML="Exception"+e;
		WriteLog("in catch "+e);		
		//WriteLog(sMappOutPutXML);
		}
 	   %>
   
    </body>
</html>
