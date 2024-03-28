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
<%@ include file="../SRB_Specific/Log.process"%>
<%@page import="java.text.*"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="com.itextpdf.text.pdf.PdfContentByte"%>
<%@page import="com.itextpdf.text.Rectangle"%>


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
		WriteLog("\nInside EIDGeneratePDF.jsp\n");
		//String WINAME = request.getParameter("WINAME");
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );    
		String WINAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		WriteLog("\nInside EIDGeneratePDF WINAME"+WINAME);
		//String EIDA_no = request.getParameter("EIDA_no");
		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("EIDA_no"), 1000, true) );    
		String EIDA_no = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
		//WriteLog("\nInside EIDGeneratePDF EIDA_no"+EIDA_no);
		//String DOB = request.getParameter("DOB");
		String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("DOB"), 1000, true) );    
		String DOB = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
		//WriteLog("\nInside EIDGeneratePDF DOB"+DOB);
		//String sex = request.getParameter("sex");
		String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sex"), 1000, true) );    
		String sex = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
		WriteLog("\nInside EIDGeneratePDF sex"+sex);
		//String full_name = request.getParameter("full_name");
		String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("full_name"), 1000, true) );    
		String full_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
		WriteLog("\nInside EIDGeneratePDF full_name"+full_name);
	//	String EIDA_exp_date = request.getParameter("EIDA_exp_date");
		String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("EIDA_exp_date"), 1000, true) );    
		String EIDA_exp_date = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
		WriteLog("\nInside EIDGeneratePDF EIDA_exp_date"+EIDA_exp_date);
		//String nationality = request.getParameter("EID_Nationality");
		String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("EID_Nationality"), 1000, true) );    
		String nationality = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
		WriteLog("\nInside EIDGeneratePDF nationality"+nationality);
		String photoDataBase64 = request.getParameter("photoDataBase64");
		/*String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("photoDataBase64"), 1000, true) );    
		String photoDataBase64 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");*/
		//WriteLog("\nInside EIDGeneratePDF photoDataBase64"+photoDataBase64);
		
		//Reading path from property file
		String path = System.getProperty("user.dir");
		Properties properties = new Properties();
		properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "RakBankConfig.properties"));
		String pdfTemplatePath = "";
		String generatedPdfPath = "";
		String pdfName ="EmiratesID";
                
		String dynamicPdfName =  WINAME+ pdfName + ".pdf";
	
		pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
		generatedPdfPath = properties.getProperty("SRB_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
		generatedPdfPath += dynamicPdfName;
		generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
		WriteLog("\nEMID Doc GeneratedPdfPath :" + generatedPdfPath);
		
			FileOutputStream fileOutputStream = new FileOutputStream(generatedPdfPath);
            Document doc = new Document(PageSize.A4.rotate());
            PdfWriter writer = PdfWriter.getInstance(doc, fileOutputStream);
            writer.open();
            doc.open();
            Font bold = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
			
			//Getting Image from server path
			
			String generatedimgPath = "";			
			String imgPath = "";
			String dynamicimgName = "bank-logo.gif";
			imgPath = path + imgPath;
			generatedimgPath = properties.getProperty("RAO_LoadLogo");
			generatedimgPath += dynamicimgName;
			generatedimgPath = path + generatedimgPath;
			WriteLog("\nEMID DOC Logo Path :" + generatedimgPath);			
			
            Image img = Image.getInstance(generatedimgPath);
            Paragraph preface = new Paragraph();
            img.setAlignment(Image.ALIGN_RIGHT);  
            img.scaleAbsolute(60f, 40f);
            preface.add(img);			
              
            doc.add(preface);
			preface=new Paragraph("EID CARD DETAILS",bold);
			preface.setAlignment(Element.ALIGN_CENTER);
            doc.add(preface);
					
			PdfPTable pdf = new PdfPTable(3);
            pdf.setSpacingBefore(100);
            pdf.setSpacingAfter(500);
			
			//setting columnWidth for each column
			pdf.setTotalWidth(10);
			int[] columnWidths = {1,3,1};
			pdf.setWidths(columnWidths);			
			pdf.setHorizontalAlignment(1);
			
			WriteLog("\n Reading image from card reader--");		
			String photo = "FFD8FFE000104A46494600010101004800480000FFDB004300140E0F120F0D14121112171614181F33211F1C1C1F3F2D2F25334A414E4D49414846525C766452576F584648668C686F7A7D8485844F63919B8F809A7681847FFFDB0043011617171F1B1F3C21213C7F5448547F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFC0001108009A008203012200021101031101FFC400190001010101010100000000000000000000000103040205FFC400251001010002010500020203010000000000000102110304122131411351226132334291FFC400190101010101010100000000000000000000000102040305FFC4001E11010101010002030101000000000000000001021103210412311341FFDA000C03010002110311003F00D8515C60000000A880A8A000A00000001BFE8048000000A8A022A0288A084500000000001E5514000050010504545000000000004011500511400000005401440140004017FF00040104500000001500151400501005010451004896E959E77CA2BDF72CF2C36D30C8E8D00544932CAEB18F5787964DDC5D1D3C9246FADCDB1DAEDCFC69CF6F9D1E9EFA8C3B72EE9EAB36A5EB9779B9BCAAF5863DF948F0F7C575995AF1666B52574CE9B0D7DDB1E6E1ECF33CC76617BA32E49B9A67BC766FC39B3D4710F5676DD3CB6F9F673D00088CB92796B1E739B89558AE37552F8A20DF1BB8F4C78EB651A7067ABAFD3B267E355F3A5ECCB7F1D985EE8CFE3E978B7F6CCAB9E332967EDC53C78BF1DBE6D72F34D67B84797C9C76763C92EB2950BEB4D572635F5D4AECE3CBD595EF2BBBB61D3E5BC7CB7B187D4ECAE6E79F58BA79B57173B59707C8CF35D0069E0F2B522831CE6ABCB5E49B8C59A2CBE5BE196E39DA617441AD9B8D7A7E4DCD7D65EE2F05ECE6D7ECD3DFC1AE5E3BE71DBEFD3CF2F163961636C72DC79ACBB2FBFD7CEB356CBEE236EA31EDCFBA7AAC5B9EE3E7EF3F5D71EB8B7F9352FB76E184B3CDDD70E3759C776176CDFD76786F7116E124F4E2E5C7B73AEFBE639BA8C3C6D25E54F367ED9738687A381E608A297CC6194D56ECF922519ACBA4106F85DC32FE3665FA658E5A6B6EF15FD8B9BCBD7D0E1E4EEC25FE9EF7B7CFE9FA89C78599DF11B70F2E7CFE67F1C7E3CDF4737B1A73E32E2E4777677FF1B5CFCFC1F8FD7A595E1E6C767639F3BAC77FA76F0E532C7DB8ECDCD36E931964F2BA3E3DF563AFBA32E5CB78D926DD130C74B70C64F119745F6F9BAA3AEF1CDD1AFB397F8382098FD2B6E62E4F395DA65E9E5040101EBB9E7EC3E030EAB7ADF9D5F6FA9D2673B269F3B9FF00D793A3A1B7F1E3E58FF5DBF1F5D8FAD3593C72CCEE3678BB4E36D56BA2C8F9B78B397FC57A7CAF1657BA6A5BF5DB7EB0CFD466EABC73E399BD8DF1E6C6FF00D47BEE97EB9F09357C3D5F475BEB5F1FB188BD4EBFFFD9";
              byte[] bytesB = new byte[photoDataBase64.length() / 2];
			  //WriteLog("\n bytesB++--"+bytesB);	
              for (int i = 0; i < photoDataBase64.length(); i += 2){
				  //WriteLog("\n inside for loop--");	
                bytesB[i / 2] = (byte) (Character.digit(photoDataBase64.charAt(i), 16) * 16 + 
                           Character.digit(photoDataBase64.charAt(i + 1), 16));
              }
			  //WriteLog("\n bytesB--"+bytesB);	
			Image img1 = Image.getInstance(bytesB);
			img1.setAbsolutePosition(60f, 340f);
			img1.scaleAbsolute(100f, 120f);
			//preface.add(img1);
			doc.add(img1);
			WriteLog("\n After Adding EID photo in pdf");
        			
            PdfPCell c1 = new PdfPCell(new Phrase("Name"));
			c1.setBorderWidth(0);
            pdf.addCell(c1);
			PdfPCell c2 = new PdfPCell(new Phrase(full_name));
			//Combining 2 rows
			c2.setColspan(2);
            pdf.addCell(c2);
			PdfPCell c3 = new PdfPCell(new Phrase(""));			
			//pdf.addCell(c3);
            c1 = new PdfPCell(new Phrase("Gender / DOB"));
			c1.setBorderWidth(0);
            pdf.addCell(c1);
             c2 = new PdfPCell(new Phrase(sex));
			 
            pdf.addCell(c2);
			c3 = new PdfPCell(new Phrase(DOB));
			pdf.addCell(c3);
             c1 = new PdfPCell(new Phrase("ID No / Exp Date"));
			 c1.setBorderWidth(0);
            pdf.addCell(c1);
             c2 = new PdfPCell(new Phrase(EIDA_no));
            pdf.addCell(c2);
             c3 = new PdfPCell(new Phrase(EIDA_exp_date));
			pdf.addCell(c3);
			c1 = new PdfPCell(new Phrase("Nationality"));
			c1.setBorderWidth(0);
            pdf.addCell(c1);
			c2 = new PdfPCell(new Phrase(nationality));
			//Combining 2 rows
			c2.setColspan(2);
            pdf.addCell(c2);
			
			WriteLog("\n After Adding values in cell");
			
			//Aligning the pdftable in absolute position
			 pdf.setTotalWidth(600);
            PdfContentByte cb = writer.getDirectContent();
			pdf.writeSelectedRows(0, 200, 190, pdf.getTotalHeight()+380, cb);
            //doc.add(pdf);
			
			// Add a rectangle
			 Rectangle rect = new Rectangle(40, 300, 800, 490);
			 rect.setBorder(Rectangle.BOX);
			 rect.setBorderWidth(2);
			 cb.rectangle(rect);
			 
			 Rectangle rect1 = new Rectangle(40, 300, 800, 510);
			 rect1.setBorder(Rectangle.BOX);
			 rect1.setBorderWidth(2);
			 cb.rectangle(rect1);
		
            doc.close();
		WriteLog("\n PDF Generated Successfully in target location");
		}
		catch(Exception e)
		{
		e.printStackTrace();
		//sMappOutPutXML="Exception"+e;
		WriteLog("in catch "+e);
		//WriteLog(sMappOutPutXML);
		}
 	   %>
   
    </body>
</html>
