package com.newgen.iforms.user;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.Socket;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.w3c.dom.Node;
import org.w3c.dom.CharacterData;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.Phrase;


public class CMPIntegration extends CMPCommon {

	public String onclickevent(IFormReference iformObj,String control, String StringData) {
		// TODO Auto-generated method stub
		{
			String MQ_response="";
			String MQ_response_Entity ="";
			String MQ_response_Account="";
			String CIFID="";
			String CustomerName="";
			String CIFType="";
			String AccountNumber ="";
			String AccountStatus="";
			String AcctType="";
			String ARMCode="";
			String RakElite="";
			String EmiratesID="";
			String EmiratesIDExpiryDate="";
			String TradeLicense="";
			String TLExpiryDate="";
			String CifId ="";
			String Customer_Name="";
			String Sub_Segment = "";
			String Primaryemail = "";
			String CifType = "";
			String selectedcif="";
			String IsRetailCus="";
			String Return_Code_Sig="";
			int returnedSignatures = 0;
			String ReturnCode1="";
			String ReturnDesc="";
			String ReturnCode2="";
			String ReturnCode3="";
			String Error_Cif = "Error";
			String MainCifId="";
			String MainCustomerSegment="";
			String MainCustomerSubSegment="";
			String MainCustomerName="";
			String MainTotalRiskScore="";
			String MainCifType="";
			String MainDateOfBirth="";
			String MainNationality="";
			String IsRetail="";
			String MainGender="";
			String MainEmiratesID="";
			String MainPassportNo="";
			String MainResAddress="";
			String MainMobileNo="";
			String rowVal="";
			String templateName="";
			String DateOfBirth="";
			String MainCifStatus="";
			String MainBlacklistFlag="";
			String MainNegatedFlag="";
			Map RecordFileMap;
			
				try
				{
				CMP.mLogger.debug("Inside onclickevent function");
				
				 if(control.equals("BtnRetryBlacklist") || control.equals("BlacklistFormLoad"))
					{
						CMP.mLogger.debug("inside onclick function for Black List check call 3");
						iformObj.clearTable("Q_USR_0_CMP_BLACKLIST_DETAILS");  // Change by Ajay
						MQ_response = MQ_connection_response(iformObj,control,StringData);
						
						MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
						CMP.mLogger.debug("Inside Black List check function "+MQ_response);	
						if(MQ_response.indexOf("<ReturnCode>")!=-1)
						{
							ReturnCode1 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
						}
						if(MQ_response.indexOf("<ReturnDesc>")!=-1)
						{
							ReturnDesc = MQ_response.substring(MQ_response.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response.indexOf("</ReturnDesc>"));
						}
						
						CMP.mLogger.debug("Return  code for the Black List  call"+ReturnCode1);
						if(ReturnCode1.equals("0000"))
						{
							JSONArray jsonArray1=new JSONArray();
							while(MQ_response.contains("<Customer>"))
							{
							rowVal = MQ_response.substring(MQ_response.indexOf("<Customer>"),MQ_response.indexOf("</Customer>")+"</Customer>".length());
							CMP.mLogger.debug("rowVal : "+rowVal);
							/*if(rowVal.equalsIgnoreCase("<Customer></Customer>"))
								return ReturnCode1+"!No result";*/
							MainCifId = (rowVal.contains("<CIFID>")) ? rowVal.substring(rowVal.indexOf("<CIFID>")+"</CIFID>".length()-1,rowVal.indexOf("</CIFID>")):"";
							MainCifStatus = (rowVal.contains("<CustomerStatus>")) ? rowVal.substring(rowVal.indexOf("<CustomerStatus>")+"</CustomerStatus>".length()-1,rowVal.indexOf("</CustomerStatus>")):"";
	                        
							// customer full name
							String FirstName = (rowVal.contains("<FirstName>")) ? rowVal.substring(rowVal.indexOf("<FirstName>")+"</FirstName>".length()-1,rowVal.indexOf("</FirstName>")):"";
	                        String LastName = (rowVal.contains("<LastName>")) ? rowVal.substring(rowVal.indexOf("<LastName>")+"</LastName>".length()-1,rowVal.indexOf("</LastName>")):"";
	                        String fullName=FirstName+" "+LastName;
							MainCustomerName = (rowVal.contains("<fullName>")) ? rowVal.substring(rowVal.indexOf("<fullName>")+"</fullName>".length()-1,rowVal.indexOf("</fullName>")):"";
											
							int countwhilchk = 0;
							while(rowVal.contains("<Document>"))
							{							
								String rowData = rowVal.substring(rowVal.indexOf("<Document>"),rowVal.indexOf("</Document>")+"</Document>".length());
								String DocumentType = (rowData.contains("<DocumentType>")) ? rowData.substring(rowData.indexOf("<DocumentType>")+"</DocumentType>".length()-1,rowData.indexOf("</DocumentType>")):"";
								CMP.mLogger.debug("DocumentType "+DocumentType);
								//Emirates ID
								if (DocumentType.equalsIgnoreCase("EMID"))
								{
									MainEmiratesID = rowData.substring(rowData.indexOf("<DocumentRefNumber>")+"<DocumentRefNumber>".length(),rowData.indexOf("</DocumentRefNumber>"));
							
								}							
								//passport number
								if (DocumentType.equalsIgnoreCase("PPT"))
								{
									MainPassportNo = rowData.substring(rowData.indexOf("<DocumentRefNumber>")+"<DocumentRefNumber>".length(),rowData.indexOf("</DocumentRefNumber>"));
									
								}
									rowVal = rowVal.substring(0,rowVal.indexOf(rowData))+ rowVal.substring(rowVal.indexOf(rowData)+rowData.length());
									
									countwhilchk++;
									if(countwhilchk == 50)
									{
										countwhilchk = 0;
										break;
									}
							
							 }
							CMP.mLogger.debug("MainEmiratesID "+MainEmiratesID);
							CMP.mLogger.debug("MainPassportNo "+MainPassportNo);
							
							countwhilchk = 0;
							while(rowVal.contains("<StatusInfo>"))
							{
								String rowData = rowVal.substring(rowVal.indexOf("<StatusInfo>"),rowVal.indexOf("</StatusInfo>")+"</StatusInfo>".length());
								
								String StatusType = (rowData.contains("<StatusType>")) ? rowData.substring(rowData.indexOf("<StatusType>")+"</StatusType>".length()-1,rowData.indexOf("</StatusType>")):"";
								CMP.mLogger.debug("StatusType "+StatusType);
								// Blacklist Flag
								if (StatusType.equalsIgnoreCase("Black List"))
								{
									MainBlacklistFlag = rowData.substring(rowData.indexOf("<StatusFlag>")+"<StatusFlag>".length(),rowData.indexOf("</StatusFlag>"));
									
								}
								
								// Negated Flag
								if (StatusType.equalsIgnoreCase("Negative List"))
								{
									MainNegatedFlag = rowData.substring(rowData.indexOf("<StatusFlag>")+"<StatusFlag>".length(),rowData.indexOf("</StatusFlag>"));
									
								}
								rowVal = rowVal.substring(0,rowVal.indexOf(rowData))+ rowVal.substring(rowVal.indexOf(rowData)+rowData.length());
							
								countwhilchk++;
								if(countwhilchk == 50)
								{
									countwhilchk = 0;
									break;
								}
							}	
							CMP.mLogger.debug("MainBlacklistFlag "+MainBlacklistFlag);
							CMP.mLogger.debug("MainNegatedFlag "+MainNegatedFlag);
							
						
							// mobile number
							/*MainMobileNo=(rowVal.contains("<MOBILE_NUMBER>")) ? rowVal.substring(rowVal.indexOf("<MOBILE_NUMBER>")+"</MOBILE_NUMBER>".length()-1,rowVal.indexOf("</MOBILE_NUMBER>")):"";
							String phonetype = (rowVal.contains("<phonetype>")) ? rowVal.substring(rowVal.indexOf("<phonetype>")+"</phonetype>".length()-1,rowVal.indexOf("</phonetype>")):"";
							CMP.mLogger.debug("phonetype "+phonetype);
							if(phonetype.equalsIgnoreCase("CELLPH1"))
							{
								MainMobileNo = rowVal.substring(rowVal.indexOf("<PhoneValue>")+"<PhoneValue>".length(),rowVal.indexOf("</PhoneValue>"));
							
							}*/
							
							countwhilchk = 0;
							while(rowVal.contains("<PhoneFax>"))
							{							
								String rowData = rowVal.substring(rowVal.indexOf("<PhoneFax>"),rowVal.indexOf("</PhoneFax>")+"</PhoneFax>".length());
								String PhoneType = (rowData.contains("<PhoneType>")) ? rowData.substring(rowData.indexOf("<PhoneType>")+"</PhoneType>".length()-1,rowData.indexOf("</PhoneType>")):"";
								CMP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", PhoneType "+PhoneType);
								
								if (PhoneType.equalsIgnoreCase("CELLPH1"))
								{
									MainMobileNo = (rowData.contains("<PhoneValue>")) ? rowData.substring(rowData.indexOf("<PhoneValue>")+"</PhoneValue>".length()-1,rowData.indexOf("</PhoneValue>")):"";
							
								}							
								
								rowVal = rowVal.substring(0,rowVal.indexOf(rowData))+ rowVal.substring(rowVal.indexOf(rowData)+rowData.length());
									
								countwhilchk++;
								if(countwhilchk == 50)
								{
									countwhilchk = 0;
									break;
								}
							
							 }
							
							JSONObject obj1=new JSONObject();
							//obj1.put("CIF_ID", "1234"); 
							
							CMP.mLogger.debug("MainCifId :"+MainCifId);
							obj1.put("CIF_ID", MainCifId);
							obj1.put("CIF_STATUS", MainCifStatus);
							obj1.put("CUSTOMER_FULLNAME", fullName);
							obj1.put("EMIRATES_ID", MainEmiratesID);
							obj1.put("PASSPORT_NUMBER", MainPassportNo);
							
							//obj1.put("RESIDENTIAL_ADDRESS", "");
							obj1.put("MOBILE_NUMBER", MainMobileNo);
							obj1.put("BLACKLIST_FLAG", MainBlacklistFlag);
							//obj1.put("BLACKLIST_NOTES", "");
							//obj1.put("BLACKLIST_REASON", "");
							//obj1.put("BLACKLIST_CODES", "");
							obj1.put("NEGATED_FLAG", MainNegatedFlag);
							//obj1.put("NEGATED_NOTES", "");
							//obj1.put("NEGATED_REASON", "");
							//obj1.put("NEGATED_CODE", "");
							jsonArray1.add(obj1);
							CMP.mLogger.debug("@@@@@@@@@@ for blacklist call 3 :::"+jsonArray1.toJSONString());							
							MQ_response = MQ_response.substring(0,MQ_response.indexOf("<Customer>"))+ MQ_response.substring(MQ_response.indexOf("</Customer>")+"</Customer>".length());
							}
							iformObj.addDataToGrid("Q_USR_0_CMP_BLACKLIST_DETAILS", jsonArray1);
							
							CMP.mLogger.debug("Size After Adding Blacklist : " + iformObj.getDataFromGrid("Q_USR_0_CMP_BLACKLIST_DETAILS").size());													
							CMP.mLogger.debug("@@@@@@@@@@ : after add of blacklist details");
						}	
						
						else
						{
							//setControlValue("MAIN_CIF_SEARCH","N");
							CMP.mLogger.debug("Error in Response of Black List call"+ReturnCode1);
					//		setControlValue("BlacklistStatus","N");	
							
					//		setControlValue("BLACKLISTED","No Result");
						}	
						return ReturnCode1+"!"+ReturnDesc;	
					
				}
				 else if(control.equalsIgnoreCase("BtnAttachBlacklist"))
				    {
					 CMP.mLogger.debug("inside onclick function for attach Black List click");
					 int Radiocount=0;
					 int acctablesize = iformObj.getDataFromGrid("Q_USR_0_CMP_BLACKLIST_DETAILS").size();
					 CMP.mLogger.debug("acctablesize--" + acctablesize);
					 ArrayList<String> Checkbox=new ArrayList<String>();
					 ArrayList<String> CIF_ID=new ArrayList<String>();
					 ArrayList<String> CIF_STATUS=new ArrayList<String>();
					 ArrayList<String> CUSTOMER_FULLNAME=new ArrayList<String>();
					 ArrayList<String> EMIRATES_ID=new ArrayList<String>();
					 ArrayList<String> PASSPORT_NUMBER=new ArrayList<String>();
					 ArrayList<String> RESIDENTIAL_ADDRESS=new ArrayList<String>();
					 ArrayList<String> MOBILE_NUMBER=new ArrayList<String>();
					 ArrayList<String> BLACKLIST_FLAG=new ArrayList<String>();
					 ArrayList<String> BLACKLIST_NOTES=new ArrayList<String>();
					 ArrayList<String> BLACKLIST_REASON=new ArrayList<String>();
		             ArrayList<String> BLACKLIST_CODES=new ArrayList<String>();
					 ArrayList<String> NEGATED_FLAG=new ArrayList<String>();
					 ArrayList<String> NEGATED_NOTES=new ArrayList<String>();
			         ArrayList<String> NEGATED_REASON=new ArrayList<String>();
					 ArrayList<String> NEGATED_CODE=new ArrayList<String>();
					
						
						JSONArray jsonArray = new JSONArray();
						for (int i = 0; i < acctablesize; i++) {
							Checkbox.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 0));
							CIF_ID.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 1));
							CIF_STATUS.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 2));							
							CUSTOMER_FULLNAME.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 3));
							EMIRATES_ID.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 4));
							PASSPORT_NUMBER.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 5));
							RESIDENTIAL_ADDRESS.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 6));
							MOBILE_NUMBER.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 7));
							BLACKLIST_FLAG.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 8));
							BLACKLIST_NOTES.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 9));
							BLACKLIST_REASON.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 10));
							BLACKLIST_CODES.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 11));
							NEGATED_FLAG.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 12));
							NEGATED_NOTES.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 13));
							NEGATED_REASON.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 14));
							NEGATED_CODE.add(iformObj.getTableCellValue("Q_USR_0_CMP_BLACKLIST_DETAILS", i, 15));
							
							if(Checkbox.get(i).equals("true"))
							{
								Radiocount=i+1;
								CMP.mLogger.debug("Radiocount--" + Radiocount);
							}
								
								

						}		
					 
						for(int j=0;j<acctablesize;j++)
						{
							 CMP.mLogger.debug("Checkbox--"+Checkbox.get(j));
							 CMP.mLogger.debug("CIF_ID--"+CIF_ID.get(j));
							 CMP.mLogger.debug("CIF_STATUS--"+CIF_STATUS.get(j));
							 CMP.mLogger.debug("CUSTOMER_FULLNAME--"+CUSTOMER_FULLNAME.get(j));
							 CMP.mLogger.debug("EMIRATES_ID--"+EMIRATES_ID.get(j));
							 CMP.mLogger.debug("PASSPORT_NUMBER"+PASSPORT_NUMBER.get(j));
							 CMP.mLogger.debug("RESIDENTIAL_ADDRESS--"+RESIDENTIAL_ADDRESS.get(j));
							 CMP.mLogger.debug("MOBILE_NUMBER--"+MOBILE_NUMBER.get(j));
							 CMP.mLogger.debug("BLACKLIST_FLAG--"+BLACKLIST_FLAG.get(j));
							 CMP.mLogger.debug("BLACKLIST_NOTES--"+BLACKLIST_NOTES.get(j));
		                     CMP.mLogger.debug("BLACKLIST_REASON--"+BLACKLIST_REASON.get(j));
							 CMP.mLogger.debug("BLACKLIST_CODES--"+BLACKLIST_CODES.get(j));
							 CMP.mLogger.debug("NEGATED_FLAG--"+NEGATED_FLAG.get(j));
							 CMP.mLogger.debug("NEGATED_NOTES--"+NEGATED_NOTES.get(j));
		                     CMP.mLogger.debug("NEGATED_REASON--"+NEGATED_REASON.get(j));
							 CMP.mLogger.debug("NEGATED_CODE--"+NEGATED_CODE.get(j));
							 
						}
										 			
						//PDF Generation****************************************
						try
						{
					        String Xmlout="";
							String WINAME = getWorkitemName();
							
							
							String Inputcustfirstname = getControlValue("FIRST_NAME");
							String Inputcustlastname = getControlValue("LAST_NAME");
							String Inputcustdob = getControlValue("DOB");
							String Inputcustnationality = getControlValue("NATIONALITY");							
																				
							String path = System.getProperty("user.dir");	
							String pdfTemplatePath = "";
							String generatedPdfPath = "";
							String pdfName = "";
							
							String imgPath = "";
							String generatedimgPath = "";
		  

							//Reading path from property file
							Properties properties = new Properties();
							properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "RakBankConfig.properties"));
								
							pdfName ="Black_List_Check_Result";
							
					        String dynamicPdfName =  WINAME+ pdfName + ".pdf";
						
							pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
							generatedPdfPath = properties.getProperty("CMP_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
							generatedPdfPath += dynamicPdfName;
							generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
							CMP.mLogger.debug("\nBlack List GeneratedPdfPath :" + generatedPdfPath);
						
								
							FileOutputStream fileOutputStream = new FileOutputStream(generatedPdfPath);
							com.itextpdf.text.Document doc = new com.itextpdf.text.Document(PageSize.A4.rotate());
				            PdfWriter writer = PdfWriter.getInstance(doc, fileOutputStream);
				            writer.open();
				            doc.open();
				            Font bold = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
							
							String dynamicimgName = "bank-logo.gif";
							generatedimgPath = properties.getProperty("CMP_LoadLogo");
							generatedimgPath += dynamicimgName;
							generatedimgPath = path + generatedimgPath;
							CMP.mLogger.debug("\nBlack List generatedimgPath :" + generatedimgPath);								
							
				            Paragraph preface = new Paragraph();
							generatedimgPath=generatedimgPath.replace("/","//");
							CMP.mLogger.debug("\nBlack List generatedimgPath after replace:" + generatedimgPath);
							Image img = Image.getInstance(generatedimgPath);
							
				            img.setAlignment(Image.ALIGN_RIGHT);  
				            img.scaleAbsolute(60f, 40f);
							
				            preface.add(img);
				            CMP.mLogger.debug("After image");
				            
				            doc.add(preface);
							preface = new Paragraph("Omniflow Reference No     :   "+WINAME,bold);
							preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
				            doc.add(preface);							
				            CMP.mLogger.debug("After image 1:");
				            
							preface = new Paragraph("Input Parameters",bold);
							preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
				            doc.add(preface);
				            CMP.mLogger.debug("After preface 1:");
				            
			             	preface = new Paragraph("First Name :   "+Inputcustfirstname);
							preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
							doc.add(preface);
							CMP.mLogger.debug("After preface 2:");
							
							preface = new Paragraph("Last Name :   "+Inputcustlastname);
							preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
							doc.add(preface);
							CMP.mLogger.debug("After preface 4:");
							
							preface= new Paragraph("DOB: "+Inputcustdob);
				            preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
				            doc.add(preface);
				            CMP.mLogger.debug("After preface 5:");
				            
		                 	preface= new Paragraph("Nationality:  "+Inputcustnationality);
				            preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
				            doc.add(preface);
				            CMP.mLogger.debug("After preface 6:");
				            
				            preface= new Paragraph("   ",bold);
				            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
				            doc.add(preface);
				            CMP.mLogger.debug("After preface 7:");
				            
				            preface=new Paragraph("Black List CHECK",bold);
				            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
				            doc.add(preface);
				            CMP.mLogger.debug("After preface 8:");
				            
				            preface=new Paragraph("   ",bold);
				            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
				            doc.add(preface);
				            CMP.mLogger.debug("After preface 9:");
				            
				            
				            PdfPTable pdf = new PdfPTable(10);
				            CMP.mLogger.debug("After PdfPTable :");
							pdf.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
							float[] columnWidths = {230,430,380,410,430,400,550,400,320,290};
							pdf.setWidths(columnWidths);
				         	pdf.setWidthPercentage(100);
				         	
							CMP.mLogger.debug("After PdfPTable 1:");
							
							Font fbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell h1 = new PdfPCell(new Phrase("Select",fbld1));
				            
				            h1.setBackgroundColor(new BaseColor(153, 0, 51));
							h1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
				            CMP.mLogger.debug("After PdfPTable 2:");
				            
							Font fbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c1 = new PdfPCell(new Phrase("CIFID",fbold1));
				            c1.setBackgroundColor(new BaseColor(153, 0, 51));
							c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 3:");
							
				        
							Font fbold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c2 = new PdfPCell(new Phrase("CIFStatus",fbold2));
				            c2.setBackgroundColor(new BaseColor(153, 0, 51));
							c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 4:");
							
							Font fbold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c3 = new PdfPCell(new Phrase("FullName",fbold3));
				            c3.setBackgroundColor(new BaseColor(153, 0, 51));
							c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				        
							CMP.mLogger.debug("After PdfPTable 5:");
							
							
							Font fbold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c4 = new PdfPCell(new Phrase("EmiratesID",fbold4));
				            c4.setBackgroundColor(new BaseColor(153, 0, 51));
							c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				        
							CMP.mLogger.debug("After PdfPTable 6:");
							
							Font fbold5 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c5 = new PdfPCell(new Phrase("Passport Number",fbold5));
				            c5.setBackgroundColor(new BaseColor(153, 0, 51));
							c5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 7:");
							
							Font fbold6 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c6 = new PdfPCell(new Phrase("Phone",fbold6));
				            c6.setBackgroundColor(new BaseColor(153, 0, 51));
							c6.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 8:");
							
							
							Font fbold7 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c7 = new PdfPCell(new Phrase("Residential Address",fbold7));
				            c7.setBackgroundColor(new BaseColor(153, 0, 51));
							c7.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 9:"); 
							

							Font fbold8 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c8 = new PdfPCell(new Phrase("Blacklist Flag",fbold8));
				            c8.setBackgroundColor(new BaseColor(153, 0, 51));
							c8.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 10:");  
							

							/*Font fbold9 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c9 = new PdfPCell(new Phrase("Blacklist Notes",fbold9));
				            c9.setBackgroundColor(new BaseColor(153, 0, 51));
							c9.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 11:");  
							

							Font fbold10 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c10 = new PdfPCell(new Phrase("Blacklist Reason",fbold10));
				            c10.setBackgroundColor(new BaseColor(153, 0, 51));
							c10.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 12:");  
							

							Font fbold11 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c11= new PdfPCell(new Phrase("Blacklist Codes",fbold11));
				            c11.setBackgroundColor(new BaseColor(153, 0, 51));
							c11.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 13:");  */
							

							Font fbold12 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c12 = new PdfPCell(new Phrase("Negated Flag",fbold12));
				            c12.setBackgroundColor(new BaseColor(153, 0, 51));
							c12.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 14:");  
							

							/*Font fbold13 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c13 = new PdfPCell(new Phrase("Negated Notes",fbold13));
				            c13.setBackgroundColor(new BaseColor(153, 0, 51));
							c13.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 15:"); 
							

							Font fbold14 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c14 = new PdfPCell(new Phrase("Negated Reason",fbold14));
				            c14.setBackgroundColor(new BaseColor(153, 0, 51));
							c14.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 16:"); 
							

							Font fbold15 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
				            PdfPCell c15 = new PdfPCell(new Phrase("Negated Codes",fbold15));
				            c15.setBackgroundColor(new BaseColor(153, 0, 51));
							c15.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
							
							CMP.mLogger.debug("After PdfPTable 17:"); */
							
							try
							{
								CMP.mLogger.debug("After PdfPTable append:");  
								pdf.addCell(h1);
								CMP.mLogger.debug("After PdfPTable append 1:");  
					            pdf.addCell(c1);
					            CMP.mLogger.debug("After PdfPTable append 2:");  
					            pdf.addCell(c2);
					            CMP.mLogger.debug("After PdfPTable append 3 :");  
					            pdf.addCell(c3);
					            CMP.mLogger.debug("After PdfPTable append 4:");  
					            pdf.addCell(c4);
					            CMP.mLogger.debug("After PdfPTable append 5:");  
								pdf.addCell(c5);
								CMP.mLogger.debug("After PdfPTable append 6:");  
					            pdf.addCell(c6);
					            CMP.mLogger.debug("After PdfPTable append 7:");  
								pdf.addCell(c7);
								CMP.mLogger.debug("After PdfPTable append 8:");  
								pdf.addCell(c8);
								//CMP.mLogger.debug("After PdfPTable append 9:"); 
								//pdf.addCell(c9);	
								CMP.mLogger.debug("After PdfPTable append 9:");  
								pdf.addCell(c12);
								
							}
							catch(Exception e)
							{
								CMP.mLogger.debug("In catch After image : "+getStackTrace(e));
							}
							
							CMP.mLogger.debug("After PdfPTable 10:");
							CMP.mLogger.debug("CIF_ID.size() "+CIF_ID.size());
							for (int j = 0; j < CIF_ID.size(); j++) {
								
								h1 = new PdfPCell(new Phrase());
				                CMP.mLogger.debug("Aftr Select for WINAME "+WINAME);
								h1.setBackgroundColor(new BaseColor(255,251,240));
								//Checkbox is added for selected checkbox on 12/12/2017
								if(Checkbox.get(j).equalsIgnoreCase("true"))
								{
									CMP.mLogger.debug("\n Radiocount value for WINAME "+WINAME+"  inside cell"+Radiocount+"jjj"+(j+1));
														
									String imgFileName = "tick.jpeg";
									String generatedTickimgPath = properties.getProperty("CMP_LoadLogo");
									generatedTickimgPath=generatedTickimgPath.replace("/","//");
									generatedTickimgPath += imgFileName;
									generatedTickimgPath = path + generatedTickimgPath;
									CMP.mLogger.debug("\n Black List generatedTickimgPath"+generatedTickimgPath);
									
									Image tickimg = Image.getInstance(generatedTickimgPath);
									 //Paragraph preface1 = new Paragraph();
									tickimg.setAlignment(Image.ALIGN_CENTER);
									//tickimg.scaleAbsolute(20f, 20f);
									tickimg.setWidthPercentage(40);
									h1.addElement(tickimg);
									//preface1.add(tickimg);
									//doc.add(preface1);					
								}
								pdf.addCell(h1);
								
				                c1 = new PdfPCell(new Phrase(CIF_ID.get(j)));
								CMP.mLogger.debug("Aftr CIFIDarray for WINAME "+WINAME+" : "+CIF_ID.get(j));
								c1.setBackgroundColor(new BaseColor(255,251,240));
								c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c1);
				                
				                c2 = new PdfPCell(new Phrase(CIF_STATUS.get(j)));
								CMP.mLogger.debug("Aftr CIF Statusarray for WINAME "+WINAME+" : "+CIF_STATUS.get(j));
								c2.setBackgroundColor(new BaseColor(255,251,240));
								c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c2);
				                
				                c3 = new PdfPCell(new Phrase(CUSTOMER_FULLNAME.get(j)));
				                CMP.mLogger.debug("Aftr fullNamearray for WINAME "+WINAME+" : "+CUSTOMER_FULLNAME.get(j));
								c3.setBackgroundColor(new BaseColor(255,251,240));
								c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c3);
								
								try {
									c4 = new PdfPCell(new Phrase(EMIRATES_ID.get(j)));
									//System.out.println("Aftr EmiratesIDarray");
									CMP.mLogger.debug("\n EmiratesIDarray value for WINAME "+WINAME+" : "+EMIRATES_ID.get(j));
									c4.setBackgroundColor(new BaseColor(255,251,240));
									c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
									pdf.addCell(c4);
								} 
								catch (Exception e){
									
								}
								
								c5 = new PdfPCell(new Phrase(PASSPORT_NUMBER.get(j)));
				                //System.out.println("Aftr PassportNumberarray");
								CMP.mLogger.debug("\n PassportNumberarray value for WINAME "+WINAME+" : "+PASSPORT_NUMBER.get(j));
								c5.setBackgroundColor(new BaseColor(255,251,240));
								c5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c5);
								
								c6 = new PdfPCell(new Phrase(RESIDENTIAL_ADDRESS.get(j)));
				                //System.out.println("aftr Nationalityarray");
								CMP.mLogger.debug("\n ResidentialAddressarray value for WINAME "+WINAME+" : "+RESIDENTIAL_ADDRESS.get(j));
								c6.setBackgroundColor(new BaseColor(255,251,240));
								c6.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c6);
				             	
				                c7 = new PdfPCell(new Phrase(MOBILE_NUMBER.get(j)));
				                //System.out.println("aftr Phonearray");
								CMP.mLogger.debug("\n Phonearray value for WINAME "+WINAME+" : "+MOBILE_NUMBER.get(j));
								c7.setBackgroundColor(new BaseColor(255,251,240));
								c7.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c7);
				                
				            	
				                c8 = new PdfPCell(new Phrase(BLACKLIST_FLAG.get(j)));
				                CMP.mLogger.debug("\n BlackListFlagarray value for WINAME "+WINAME+" : "+BLACKLIST_FLAG.get(j));
								c8.setBackgroundColor(new BaseColor(255,251,240));
								c8.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c8);
				                
				            	
				                c12 = new PdfPCell(new Phrase(NEGATED_FLAG.get(j)));
				                CMP.mLogger.debug("\n NEGATED_FLAGarray value for WINAME "+WINAME+" : "+NEGATED_FLAG.get(j));
								c12.setBackgroundColor(new BaseColor(255,251,240));
								c12.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
				                pdf.addCell(c12);
				                
				            	 CMP.mLogger.debug("\n PDF Generated check 1 for WINAME "+WINAME);           
								 //doc.add(pdf);
				            }
							
				            doc.add(pdf);								
				            doc.close();
				            
							CMP.mLogger.debug("\n PDF Generated Successfully in target location for WINAME "+WINAME);
							String Req_Type="Black_List_Check_Result"; 
							CMP.mLogger.debug("\n before AttachDocumentWithWI ");
							String Response=AttachDocumentWithWI(iformObj,WINAME,Req_Type);
							return Response;
						}
						catch(Exception e)
						{
							e.printStackTrace();
							//sMappOutPutXML="Exception"+e;
							CMP.mLogger.debug("in catch of BlackListGeneratePDF Exception is: "+e);
							return "in catch of BlackListGeneratePDF Exception is: "+e;
						}
			    
				}
				else if(control.equals("BtnRetryDuplicate") || control.equalsIgnoreCase("DedupeSubFormLoad"))
				{
					CMP.mLogger.debug("inside onclick function for Dedupe check call 3");
					iformObj.clearTable("Q_USR_0_CMP_DEDUPE_DETAILS");  // Change by Ajay
					MQ_response = MQ_connection_response(iformObj,control,StringData);
					
					MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
					CMP.mLogger.debug("Inside Dedupe check function "+MQ_response);	
					if(MQ_response.indexOf("<ReturnCode>")!=-1)
					{
						ReturnCode1 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
					}
					if(MQ_response.indexOf("<ReturnDesc>")!=-1)
					{
						ReturnDesc = MQ_response.substring(MQ_response.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response.indexOf("</ReturnDesc>"));
					}
					
					CMP.mLogger.debug("Return  code for the Dedupe check  call"+ReturnCode1);
					if(ReturnCode1.equals("0000"))
					{
						JSONArray jsonArray1=new JSONArray();
						while(MQ_response.contains("<Customer>"))
						{
						rowVal = MQ_response.substring(MQ_response.indexOf("<Customer>"),MQ_response.indexOf("</Customer>")+"</Customer>".length());
						CMP.mLogger.debug("rowVal : "+rowVal);
						/*if(rowVal.equalsIgnoreCase("<Customer></Customer>"))
							return ReturnCode1+"!No result";*/
						MainCifId = (rowVal.contains("<CIFID>")) ? rowVal.substring(rowVal.indexOf("<CIFID>")+"</CIFID>".length()-1,rowVal.indexOf("</CIFID>")):"";
						MainCustomerName = (rowVal.contains("<FullName>")) ? rowVal.substring(rowVal.indexOf("<FullName>")+"</FullName>".length()-1,rowVal.indexOf("</FullName>")):"";
						DateOfBirth = (rowVal.contains("<DateOfBirth>")) ? rowVal.substring(rowVal.indexOf("<DateOfBirth>")+"</DateOfBirth>".length()-1,rowVal.indexOf("</DateOfBirth>")):"";
						CMP.mLogger.debug("DateOfBirth : "+DateOfBirth);
						MainNationality = (rowVal.contains("<Nationality>")) ? rowVal.substring(rowVal.indexOf("<Nationality>")+"</Nationality>".length()-1,rowVal.indexOf("</Nationality>")):"";
						MainDateOfBirth = ""; // Change by Ajay
						if(!(DateOfBirth==null || DateOfBirth.equalsIgnoreCase("")))  // Change by Ajay
						{
							String DOB[] = DateOfBirth.split("-");
							MainDateOfBirth=DOB[2]+"/"+DOB[1]+"/"+DOB[0];
							CMP.mLogger.debug("MainDateOfBirth : "+MainDateOfBirth);
						}	
						
						int countwhilchk = 0;
						while(rowVal.contains("<Document>"))
						{							
							String rowData = rowVal.substring(rowVal.indexOf("<Document>"),rowVal.indexOf("</Document>")+"</Document>".length());
							String DocumentType = (rowData.contains("<DocumentType>")) ? rowData.substring(rowData.indexOf("<DocumentType>")+"</DocumentType>".length()-1,rowData.indexOf("</DocumentType>")):"";
							CMP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", DocumentType "+DocumentType);
							//Emirates ID
							if (DocumentType.equalsIgnoreCase("EMID"))
							{
								MainEmiratesID = rowData.substring(rowData.indexOf("<DocumentRefNumber>")+"<DocumentRefNumber>".length(),rowData.indexOf("</DocumentRefNumber>"));
						
							}							
							//passport number
							if (DocumentType.equalsIgnoreCase("PPT"))
							{
								MainPassportNo = rowData.substring(rowData.indexOf("<DocumentRefNumber>")+"<DocumentRefNumber>".length(),rowData.indexOf("</DocumentRefNumber>"));
								
							}
							
							rowVal = rowVal.substring(0,rowVal.indexOf(rowData))+ rowVal.substring(rowVal.indexOf(rowData)+rowData.length());
							
							countwhilchk++;
							if(countwhilchk == 50)
							{
								countwhilchk = 0;
								break;
							}
						
						 }
						
						countwhilchk = 0;
						while(rowVal.contains("<PhoneFax>"))
						{							
							String rowData = rowVal.substring(rowVal.indexOf("<PhoneFax>"),rowVal.indexOf("</PhoneFax>")+"</PhoneFax>".length());
							String PhoneType = (rowData.contains("<PhoneType>")) ? rowData.substring(rowData.indexOf("<PhoneType>")+"</PhoneType>".length()-1,rowData.indexOf("</PhoneType>")):"";
							CMP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", PhoneType "+PhoneType);
							
							if (PhoneType.equalsIgnoreCase("CELLPH1"))
							{
								MainMobileNo = (rowData.contains("<PhoneValue>")) ? rowData.substring(rowData.indexOf("<PhoneValue>")+"</PhoneValue>".length()-1,rowData.indexOf("</PhoneValue>")):"";
						
							}							
							
							rowVal = rowVal.substring(0,rowVal.indexOf(rowData))+ rowVal.substring(rowVal.indexOf(rowData)+rowData.length());
								
							countwhilchk++;
							if(countwhilchk == 50)
							{
								countwhilchk = 0;
								break;
							}
						
						 }
												
						JSONObject obj1=new JSONObject();
						//obj1.put("CIF_ID", "1234");
						//obj1.put("SELECT_ID", "");
						
						obj1.put("CIF_ID", MainCifId);
						obj1.put("CUSTOMER_FULLNAME", MainCustomerName);
						// obj1.put("DATE_OF_BIRTH", DateOfBirth);  // Change By Ajay
						obj1.put("DATE_OF_BIRTH", MainDateOfBirth); // Change By Ajay
						obj1.put("GENDER", MainGender);
						obj1.put("EMIRATES_ID", MainEmiratesID);
						obj1.put("PASSPORT_NUMBER", MainPassportNo);
						obj1.put("NATIONALITY", MainNationality);
						obj1.put("RESIDENTIAL_ADDRESS", MainResAddress);
						obj1.put("MOBILE_NUMBER", MainMobileNo);
						jsonArray1.add(obj1);
						CMP.mLogger.debug("@@@@@@@@@@ for dedup detail call 2:::"+jsonArray1.toJSONString());
						
						//setControlValue("DedupeStatus","Y");
						//setControlValue("EXISTING_CUSTOMER","Y");
						//setControlValue("DUPLICATE_CIF_FOUND","Not Duplicate");
												
						
						MQ_response = MQ_response.substring(0,MQ_response.indexOf("<Customer>"))+ MQ_response.substring(MQ_response.indexOf("</Customer>")+"</Customer>".length());
						}
						iformObj.addDataToGrid("Q_USR_0_CMP_DEDUPE_DETAILS", jsonArray1);
						CMP.mLogger.debug("Size After Adding Dup : " + iformObj.getDataFromGrid("Q_USR_0_CMP_DEDUPE_DETAILS").size());
						CMP.mLogger.debug("@@@@@@@@@@ : after add of dedupe details");
					}	
					
					else
					{
						//setControlValue("MAIN_CIF_SEARCH","N");
						CMP.mLogger.debug("Error in Response of dedupe call"+ReturnCode1);
						//setControlValue("DedupeStatus","N");	
						//setControlValue("DUPLICATE_CIF_FOUND","No Result");
					}	
					return ReturnCode1+"!"+ReturnDesc;	
				
				}				 
				
				 else if(control.equalsIgnoreCase("BtnAttachDuplicate"))
				 {
					 CMP.mLogger.debug("inside onclick function for attach Dedupe click");
					 int Radiocount=0;
					 int acctablesize = iformObj.getDataFromGrid("Q_USR_0_CMP_DEDUPE_DETAILS").size();
					 CMP.mLogger.debug("acctablesize--" + acctablesize);
					 ArrayList<String> Checkbox=new ArrayList<String>();
					 ArrayList<String> CIF_ID=new ArrayList<String>();	
					 ArrayList<String> CUSTOMER_FULLNAME=new ArrayList<String>();
					ArrayList<String> DATE_OF_BIRTH=new ArrayList<String>();
					ArrayList<String> GENDER=new ArrayList<String>();
					ArrayList<String> EMIRATES_ID=new ArrayList<String>();
					ArrayList<String> PASSPORT_NUMBER=new ArrayList<String>();
					ArrayList<String> NATIONALITY=new ArrayList<String>();
					ArrayList<String> RESIDENTIAL_ADDRESS=new ArrayList<String>();
					ArrayList<String> MOBILE_NUMBER=new ArrayList<String>();
					
						
						JSONArray jsonArray = new JSONArray();
						for (int i = 0; i < acctablesize; i++) {
							Checkbox.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 0));
							CIF_ID.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 1));
							CUSTOMER_FULLNAME.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 2));							
							DATE_OF_BIRTH.add(iformObj.getTableCellValue("Q _USR_0_CMP_DEDUPE_DETAILS", i, 3));
							GENDER.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 4));
							EMIRATES_ID.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 5));
							PASSPORT_NUMBER.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 6));
							NATIONALITY.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 7));
							RESIDENTIAL_ADDRESS.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 8));
							MOBILE_NUMBER.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 9));
							
							if(Checkbox.get(i).equals("true"))
							{
								Radiocount=i+1;
								CMP.mLogger.debug("Radiocount--" + Radiocount);
							}
								
								

						}		
					 
					 /*JSONArray dedupeDetsArr = iformObj.getDataFromGrid("Q_USR_0_CMP_DEDUPE_DETAILS");
					ArrayList<String> CIF_ID=new ArrayList<String>();	
					
					
					ArrayList<String>[][] outerArray = new ArrayList[dedupeDetsArr.size()][10];
					int i=0;
					int j=0;
					 */					 
						for(int j=0;j<acctablesize;j++)
						{
							 CMP.mLogger.debug("Checkbox--"+Checkbox.get(j));
							 CMP.mLogger.debug("CIF_ID--"+CIF_ID.get(j));
							 CMP.mLogger.debug("CUSTOMER_FULLNAME--"+CUSTOMER_FULLNAME.get(j));
							 CMP.mLogger.debug("DATE_OF_BIRTH--"+DATE_OF_BIRTH.get(j));
							 CMP.mLogger.debug("GENDER--"+GENDER.get(j));
							 CMP.mLogger.debug("EMIRATES_ID"+EMIRATES_ID.get(j));
							 CMP.mLogger.debug("PASSPORT_NUMBER--"+PASSPORT_NUMBER.get(j));
							 CMP.mLogger.debug("NATIONALITY--"+NATIONALITY.get(j));
							 CMP.mLogger.debug("RESIDENTIAL_ADDRESS--"+RESIDENTIAL_ADDRESS.get(j));
							 CMP.mLogger.debug("MOBILE_NUMBER--"+MOBILE_NUMBER.get(j));
						}
										 			
						//PDF Generation****************************************
						try{
					        String Xmlout="";
							String WINAME = getWorkitemName();
							
							
							String Inputcustfirstname = getControlValue("FIRST_NAME");
							String Inputcustlastname = getControlValue("LAST_NAME");
							String Inputcustdob = getControlValue("DOB");
							String Inputcustnationality = getControlValue("NATIONALITY");							
																				
							String path = System.getProperty("user.dir");
							String pdfTemplatePath = "";
							String generatedPdfPath = "";
														
							String imgPath = "";
							String generatedimgPath = "";
							


							//Reading path from property file
							Properties properties = new Properties();
							properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "RakBankConfig.properties"));
								
							
							String pdfName ="Duplicate_Check_Result";
					                
								String dynamicPdfName =  WINAME+ pdfName + ".pdf";
							
								pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
								generatedPdfPath = properties.getProperty("CMP_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
								generatedPdfPath += dynamicPdfName;
								generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
								CMP.mLogger.debug("\nDedup GeneratedPdfPath :" + generatedPdfPath);
								
									
								FileOutputStream fileOutputStream = new FileOutputStream(generatedPdfPath);
								com.itextpdf.text.Document doc = new com.itextpdf.text.Document(PageSize.A4.rotate());
					            PdfWriter writer = PdfWriter.getInstance(doc, fileOutputStream);
					            writer.open();
					            doc.open();
					            Font bold = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
								
								String dynamicimgName = "bank-logo.gif";
								generatedimgPath = properties.getProperty("CMP_LoadLogo");
								generatedimgPath += dynamicimgName;
								generatedimgPath = path + generatedimgPath;
								CMP.mLogger.debug("\nDedup generatedimgPath :" + generatedimgPath);								
								
					            Paragraph preface = new Paragraph();
								generatedimgPath=generatedimgPath.replace("/","//");
								CMP.mLogger.debug("\nDedup generatedimgPath aftr replace:" + generatedimgPath);
								Image img = Image.getInstance(generatedimgPath);
								
					            img.setAlignment(Image.ALIGN_RIGHT);  
					            img.scaleAbsolute(60f, 40f);
								
					            preface.add(img);
					            CMP.mLogger.debug("After image");
					            doc.add(preface);
								preface = new Paragraph("Omniflow Reference No     :   "+WINAME,bold);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);							
					           
					            CMP.mLogger.debug("After preface 1:");
								preface = new Paragraph("Input Parameters",bold);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 2:");
								/*preface = new Paragraph("CIF ID     :   "+CIF_ID);
								preface.setAlignment(Element.ALIGN_JUSTIFIED);
					            doc.add(preface);*/
								
								preface = new Paragraph("First Name     :   "+Inputcustfirstname);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 3:");
								preface = new Paragraph("Last Name     :   "+Inputcustlastname);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 4:");
								preface = new Paragraph("DOB     :   "+Inputcustdob);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 5:");
								preface = new Paragraph("Nationality     :   "+Inputcustnationality);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 6:");
								/*preface = new Paragraph("Bank ID    :   "+BankId);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);
								
								preface = new Paragraph("RetailCorpFlag     :   "+RetailCorpFlag);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);
								
								preface = new Paragraph("Omniflow Reference No     :   "+RetailCorpFlag);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);*/
								
								preface=new Paragraph("   ",bold);
					            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 7:");
					            preface=new Paragraph("DEDUPE CHECK",bold);
					            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 8:");
								preface=new Paragraph("   ",bold);
					            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 9:");
					            PdfPTable pdf = new PdfPTable(8);
					            CMP.mLogger.debug("After PdfPTable :");
								pdf.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
								int[] columnWidths = {35,50,50,55,40,55,75,85};
								pdf.setWidths(columnWidths);
					            
								pdf.setWidthPercentage(100);
								CMP.mLogger.debug("After PdfPTable 1:");
								Font fbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell h1 = new PdfPCell(new Phrase("Select",fbld1));
					            //System.out.println("Prepared");
					            h1.setBackgroundColor(new BaseColor(153, 0, 51));
								h1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					            //PdfPCell c1 = new PdfPCell(new Phrase("CIFID"));
								CMP.mLogger.debug("After PdfPTable 2:");
								Font fbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c1 = new PdfPCell(new Phrase("CIFID",fbold1));
					            //System.out.println("Prepared");
					            c1.setBackgroundColor(new BaseColor(153, 0, 51));
								c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								CMP.mLogger.debug("After PdfPTable 3:");
					            //PdfPCell c1 = new PdfPCell(new Phrase("CIFID"));
								Font fbold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c2 = new PdfPCell(new Phrase("FullName",fbold2));
					            //System.out.println("Prepared");
					            c2.setBackgroundColor(new BaseColor(153, 0, 51));
								c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								//PdfPCell c2 = new PdfPCell(new Phrase("CIFStatus"));
								CMP.mLogger.debug("After PdfPTable 4:");
								Font fbold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c3 = new PdfPCell(new Phrase("DOB",fbold3));
					           //System.out.println("Prepared");
					            c3.setBackgroundColor(new BaseColor(153, 0, 51));
								c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					            //PdfPCell c3 = new PdfPCell(new Phrase("FullName"));
								CMP.mLogger.debug("After PdfPTable 5:");
								
								
								Font fbold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c4 = new PdfPCell(new Phrase("EmiratesID",fbold4));
					            //System.out.println("Prepared");
					            c4.setBackgroundColor(new BaseColor(153, 0, 51));
								c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					            //PdfPCell c4 = new PdfPCell(new Phrase("EmiratesID"));
								CMP.mLogger.debug("After PdfPTable 6:");
								Font fbold5 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c5 = new PdfPCell(new Phrase("PassportNumber",fbold5));
					            //System.out.println("Prepared");
					            c5.setBackgroundColor(new BaseColor(153, 0, 51));
								c5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								CMP.mLogger.debug("After PdfPTable 7:");
								Font fbold6 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c6 = new PdfPCell(new Phrase("Nationality",fbold6));
					            //System.out.println("Prepared");
					            c6.setBackgroundColor(new BaseColor(153, 0, 51));
								c6.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								//PdfPCell c6 = new PdfPCell(new Phrase("Phone"));
								CMP.mLogger.debug("After PdfPTable 8:");
								
								
								Font fbold7 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c7 = new PdfPCell(new Phrase("Phone",fbold7));
					            //System.out.println("Prepared");
					            c7.setBackgroundColor(new BaseColor(153, 0, 51));
								c7.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								//PdfPCell c6 = new PdfPCell(new Phrase("BFlag"));
								CMP.mLogger.debug("After PdfPTable 9:");  
								
								try
								{
									CMP.mLogger.debug("After PdfPTable append:");  
									pdf.addCell(h1);
									CMP.mLogger.debug("After PdfPTable append 1:");  
						            pdf.addCell(c1);
						            CMP.mLogger.debug("After PdfPTable append 2:");  
						            pdf.addCell(c2);
						            CMP.mLogger.debug("After PdfPTable append 3 :");  
						            pdf.addCell(c3);
						            CMP.mLogger.debug("After PdfPTable append 4:");  
						            pdf.addCell(c4);
						            CMP.mLogger.debug("After PdfPTable append 5:");  
									pdf.addCell(c5);
									CMP.mLogger.debug("After PdfPTable append 6:");  
						            pdf.addCell(c6);
						            CMP.mLogger.debug("After PdfPTable append 7:");  
									pdf.addCell(c7);
									CMP.mLogger.debug("After PdfPTable append 8:");  
								}
								catch(Exception e)
								{
									CMP.mLogger.debug("In catch After image : "+getStackTrace(e));
								}
								
								CMP.mLogger.debug("After PdfPTable 10:");
								CMP.mLogger.debug("CIF_ID.size() "+CIF_ID.size());
								for (int j = 0; j < CIF_ID.size(); j++) {
									
									h1 = new PdfPCell(new Phrase());
					                CMP.mLogger.debug("Aftr Select for WINAME "+WINAME);
									h1.setBackgroundColor(new BaseColor(255,251,240));
									//Checkbox is added for selected checkbox on 12/12/2017
									if(Checkbox.get(j).equalsIgnoreCase("true"))
									{
										CMP.mLogger.debug("\n Radiocount value for WINAME "+WINAME+"  inside cell"+Radiocount+"jjj"+(j+1));
															
										String imgFileName = "tick.jpeg";
										String generatedTickimgPath = properties.getProperty("CMP_LoadLogo");
										generatedTickimgPath=generatedTickimgPath.replace("/","//");
										generatedTickimgPath += imgFileName;
										generatedTickimgPath = path + generatedTickimgPath;
										CMP.mLogger.debug("\n dedup generatedTickimgPath"+generatedTickimgPath);
										
										Image tickimg = Image.getInstance(generatedTickimgPath);
										 //Paragraph preface1 = new Paragraph();
										tickimg.setAlignment(Image.ALIGN_CENTER);
										//tickimg.scaleAbsolute(20f, 20f);
										tickimg.setWidthPercentage(40);
										h1.addElement(tickimg);
										//preface1.add(tickimg);
										//doc.add(preface1);					
									}
									pdf.addCell(h1);
									
					                c1 = new PdfPCell(new Phrase(CIF_ID.get(j)));
									CMP.mLogger.debug("Aftr CIFIDarray for WINAME "+WINAME+" : "+CIF_ID.get(j));
									c1.setBackgroundColor(new BaseColor(255,251,240));
									c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c1);
					                
					                
					                
					                c2 = new PdfPCell(new Phrase(CUSTOMER_FULLNAME.get(j)));
					                CMP.mLogger.debug("Aftr fullNamearray for WINAME "+WINAME+" : "+CUSTOMER_FULLNAME.get(j));
									c2.setBackgroundColor(new BaseColor(255,251,240));
									c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c2);
									
									c3 = new PdfPCell(new Phrase(DATE_OF_BIRTH.get(j)));
					                CMP.mLogger.debug("Aftr DOBarray for WINAME "+WINAME+" : "+DATE_OF_BIRTH.get(j));
									c3.setBackgroundColor(new BaseColor(255,251,240));
									c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c3);
									
									try {
										c4 = new PdfPCell(new Phrase(EMIRATES_ID.get(j)));
										//System.out.println("Aftr EmiratesIDarray");
										CMP.mLogger.debug("\n EmiratesIDarray value for WINAME "+WINAME+" : "+EMIRATES_ID.get(j));
										c4.setBackgroundColor(new BaseColor(255,251,240));
										c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
										pdf.addCell(c4);
									} catch (Exception e){
										
									}
									
									c5 = new PdfPCell(new Phrase(PASSPORT_NUMBER.get(j)));
					                //System.out.println("Aftr PassportNumberarray");
									CMP.mLogger.debug("\n PassportNumberarray value for WINAME "+WINAME+" : "+PASSPORT_NUMBER.get(j));
									c5.setBackgroundColor(new BaseColor(255,251,240));
									c5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c5);
									
									c6 = new PdfPCell(new Phrase(NATIONALITY.get(j)));
					                //System.out.println("aftr Nationalityarray");
									CMP.mLogger.debug("\n Nationalityarray value for WINAME "+WINAME+" : "+NATIONALITY.get(j));
									c6.setBackgroundColor(new BaseColor(255,251,240));
									c6.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c6);
					                
									
									
					                c7 = new PdfPCell(new Phrase(MOBILE_NUMBER.get(j)));
					                //System.out.println("aftr Phonearray");
									CMP.mLogger.debug("\n Phonearray value for WINAME "+WINAME+" : "+MOBILE_NUMBER.get(j));
									c7.setBackgroundColor(new BaseColor(255,251,240));
									 CMP.mLogger.debug("\n PDF Generated check for WINAME "+WINAME);
									c7.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c7);				
								     CMP.mLogger.debug("\n PDF Generated check 1 for WINAME "+WINAME);           
									 //doc.add(pdf);
					            }
								
					            doc.add(pdf);								
					            doc.close();
					            
								CMP.mLogger.debug("\n PDF Generated Successfully in target location for WINAME "+WINAME);
								String Response=AttachDocumentWithWI(iformObj,WINAME,pdfName);
								return Response;
							}
							catch(Exception e)
							{
								e.printStackTrace();
								//sMappOutPutXML="Exception"+e;
								CMP.mLogger.debug("in catch of DedupeGeneratePDF Exception is: "+e);
								return "in catch of DedupeGeneratePDF Exception is: "+e;
							}
						//*************************************************************************
				 }
				/* else if(control.equalsIgnoreCase("BtnRetryRiskScore") || control.equalsIgnoreCase("RiskScoreFormLoad"))
				 {
					 	CMP.mLogger.debug("inside "+control+" for Dedupe check call");
					 	String WINAME = getWorkitemName();
						MQ_response = MQ_connection_response(iformObj,control,StringData);
						
						MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
						CMP.mLogger.debug("Inside Dedupe check function "+MQ_response);	
						if(MQ_response.indexOf("<ReturnCode>")!=-1)
						{
							ReturnCode1 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
						}
						if(MQ_response.indexOf("<ReturnDesc>")!=-1)
						{
							ReturnDesc = MQ_response.substring(MQ_response.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response.indexOf("</ReturnDesc>"));
						}
						
						CMP.mLogger.debug("Return  code for the Dedupe check  call"+ReturnCode1);
						if(ReturnCode1.equals("0000"))
						{
							MainTotalRiskScore = (MQ_response.contains("<TotalRiskScore>")) ? MQ_response.substring(MQ_response.indexOf("<TotalRiskScore>")+"</TotalRiskScore>".length()-1,MQ_response.indexOf("</TotalRiskScore>")):"";							
							//rowVal = MQ_response.substring(MQ_response.indexOf("<Customer>"),MQ_response.indexOf("</Customer>")+"</Customer>".length());
														
							//MainCustomerName = (rowVal.contains("<FullName>")) ? rowVal.substring(rowVal.indexOf("<FullName>")+"</FullName>".length()-1,rowVal.indexOf("</FullName>")):"";
							CMP.mLogger.debug("MainTotalRiskScore--"+MainTotalRiskScore);
							CMP.mLogger.debug("getValue(controlName) 1--"+getControlValue("RISK_SCORE"));
							setControlValue("RISK_SCORE",MainTotalRiskScore);		
							CMP.mLogger.debug("getValue(controlName) 2--"+getControlValue("RISK_SCORE"));
							CMP.mLogger.debug("@@@@@@@@@@ : Successful in getting RiskScore details");	
							String PdfName="Risk_Score_Details";
							String Status=createPDF(iformObj,"Risk_Score",WINAME,PdfName);
							CMP.mLogger.debug("@@@@@@@@@@ : Status : "+Status);
							String Response="";
							if(!Status.contains("Error"))
							{
								Response=AttachDocumentWithWI(iformObj,WINAME,PdfName);
								return ReturnCode1+"~"+ReturnDesc+"~"+Response;
							}
							else
							{
								return Response=ReturnCode1+"~"+Status;
							}
							//return ReturnCode1+"~"+ReturnDesc+"~"+Response;	
						}						
						else
						{
							//setControlValue("MAIN_CIF_SEARCH","N");
							CMP.mLogger.debug("Error in Response of RiskScore call"+ReturnCode1+"!"+ReturnDesc);
							return ReturnCode1+"~"+ReturnDesc;									
						}	
						
				 } 	*/		 	 
				 else if(control.equalsIgnoreCase("BtnPopulateDuplicate"))
				 {
					CMP.mLogger.debug("inside onclick function for Populate Dedupe");
					
					 int Radiocount=0;
					 int acctablesize = iformObj.getDataFromGrid("Q_USR_0_CMP_DEDUPE_DETAILS").size();
					 String WINAME = getWorkitemName();
					 CMP.mLogger.debug("acctablesize--" + acctablesize);
					 ArrayList<String> Checkbox=new ArrayList<String>();
					 ArrayList<String> CIF_ID=new ArrayList<String>();	
					 ArrayList<String> CUSTOMER_FULLNAME=new ArrayList<String>();
					ArrayList<String> DATE_OF_BIRTH=new ArrayList<String>();
					ArrayList<String> GENDER=new ArrayList<String>();
					ArrayList<String> EMIRATES_ID=new ArrayList<String>();
					ArrayList<String> PASSPORT_NUMBER=new ArrayList<String>();
					ArrayList<String> NATIONALITY=new ArrayList<String>();
					ArrayList<String> RESIDENTIAL_ADDRESS=new ArrayList<String>();
					ArrayList<String> MOBILE_NUMBER=new ArrayList<String>();
					
						
						JSONArray jsonArray = new JSONArray();
						for (int i = 0; i < acctablesize; i++) {
							Checkbox.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 0));
							CIF_ID.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 1));
							CUSTOMER_FULLNAME.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 2));							
							DATE_OF_BIRTH.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 3));
							GENDER.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 4));
							EMIRATES_ID.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 5));
							PASSPORT_NUMBER.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 6));
							NATIONALITY.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 7));
							RESIDENTIAL_ADDRESS.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 8));
							MOBILE_NUMBER.add(iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS", i, 9));
							
							if(Checkbox.get(i).equals("true"))
							{
								Radiocount=i+1;
								CMP.mLogger.debug("Radiocount--" + Radiocount);
							}
								
								

						}		
					 
					 /*JSONArray dedupeDetsArr = iformObj.getDataFromGrid("Q_USR_0_CMP_DEDUPE_DETAILS");
					ArrayList<String> CIF_ID=new ArrayList<String>();	
					
					
					ArrayList<String>[][] outerArray = new ArrayList[dedupeDetsArr.size()][10];
					int i=0;
					int j=0;
					 */					 
						for(int j=0;j<acctablesize;j++)
						{
							 CMP.mLogger.debug("Checkbox--"+Checkbox.get(j));
							 CMP.mLogger.debug("CIF_ID--"+CIF_ID.get(j));
							 CMP.mLogger.debug("CUSTOMER_FULLNAME--"+CUSTOMER_FULLNAME.get(j));
							 CMP.mLogger.debug("DATE_OF_BIRTH--"+DATE_OF_BIRTH.get(j));
							 CMP.mLogger.debug("GENDER--"+GENDER.get(j));
							 CMP.mLogger.debug("EMIRATES_ID"+EMIRATES_ID.get(j));
							 CMP.mLogger.debug("PASSPORT_NUMBER--"+PASSPORT_NUMBER.get(j));
							 CMP.mLogger.debug("NATIONALITY--"+NATIONALITY.get(j));
							 CMP.mLogger.debug("RESIDENTIAL_ADDRESS--"+RESIDENTIAL_ADDRESS.get(j));
							 CMP.mLogger.debug("MOBILE_NUMBER--"+MOBILE_NUMBER.get(j));
						}
										 			
						//PDF Generation****************************************
						try{
					        String Xmlout="";
							
							
							
							String Inputcustfirstname = getControlValue("FIRST_NAME");
							String Inputcustlastname = getControlValue("LAST_NAME");
							String Inputcustdob = getControlValue("DOB");
							String Inputcustnationality = getControlValue("NATIONALITY");							
																				
							String path = System.getProperty("user.dir");
							String pdfTemplatePath = "";
							String generatedPdfPath = "";
														
							String imgPath = "";
							String generatedimgPath = "";
							


							//Reading path from property file
							Properties properties = new Properties();
							properties.load(new FileInputStream(System.getProperty("user.dir")+ System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "RakBankConfig.properties"));
								
							
							String pdfName ="Duplicate_Check_Result";
					                
								String dynamicPdfName =  WINAME+ pdfName + ".pdf";
							
								pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
								generatedPdfPath = properties.getProperty("CMP_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
								generatedPdfPath += dynamicPdfName;
								generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
								CMP.mLogger.debug("\nDedup GeneratedPdfPath :" + generatedPdfPath);
								
									
								FileOutputStream fileOutputStream = new FileOutputStream(generatedPdfPath);
								com.itextpdf.text.Document doc = new com.itextpdf.text.Document(PageSize.A4.rotate());
					            PdfWriter writer = PdfWriter.getInstance(doc, fileOutputStream);
					            writer.open();
					            doc.open();
					            Font bold = new Font(FontFamily.HELVETICA, 12, Font.BOLD);
								
								String dynamicimgName = "bank-logo.gif";
								generatedimgPath = properties.getProperty("CMP_LoadLogo");
								generatedimgPath += dynamicimgName;
								generatedimgPath = path + generatedimgPath;
								CMP.mLogger.debug("\nDedup generatedimgPath :" + generatedimgPath);								
								
					            Paragraph preface = new Paragraph();
								generatedimgPath=generatedimgPath.replace("/","//");
								CMP.mLogger.debug("\nDedup generatedimgPath aftr replace:" + generatedimgPath);
								Image img = Image.getInstance(generatedimgPath);
								
					            img.setAlignment(Image.ALIGN_RIGHT);  
					            img.scaleAbsolute(60f, 40f);
								
					            preface.add(img);
					            CMP.mLogger.debug("After image");
					            doc.add(preface);
								preface = new Paragraph("Omniflow Reference No     :   "+WINAME,bold);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);							
					           
					            CMP.mLogger.debug("After preface 1:");
								preface = new Paragraph("Input Parameters",bold);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 2:");
								/*preface = new Paragraph("CIF ID     :   "+CIF_ID);
								preface.setAlignment(Element.ALIGN_JUSTIFIED);
					            doc.add(preface);*/
								
								preface = new Paragraph("First Name     :   "+Inputcustfirstname);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 3:");
								preface = new Paragraph("Last Name     :   "+Inputcustlastname);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 4:");
								preface = new Paragraph("DOB     :   "+Inputcustdob);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 5:");
								preface = new Paragraph("Nationality     :   "+Inputcustnationality);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
								doc.add(preface);
								CMP.mLogger.debug("After preface 6:");
								/*preface = new Paragraph("Bank ID    :   "+BankId);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);
								
								preface = new Paragraph("RetailCorpFlag     :   "+RetailCorpFlag);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);
								
								preface = new Paragraph("Omniflow Reference No     :   "+RetailCorpFlag);
								preface.setAlignment(com.itextpdf.text.Element.ALIGN_JUSTIFIED);
					            doc.add(preface);*/
								
								preface=new Paragraph("   ",bold);
					            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 7:");
					            preface=new Paragraph("DEDUPE CHECK",bold);
					            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 8:");
								preface=new Paragraph("   ",bold);
					            preface.setAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
					            doc.add(preface);
					            CMP.mLogger.debug("After preface 9:");
					            PdfPTable pdf = new PdfPTable(8);
					            CMP.mLogger.debug("After PdfPTable :");
								pdf.setHorizontalAlignment(com.itextpdf.text.Element.ALIGN_CENTER);
								int[] columnWidths = {35,50,50,55,40,55,75,85};
								pdf.setWidths(columnWidths);
					            
								pdf.setWidthPercentage(100);
								CMP.mLogger.debug("After PdfPTable 1:");
								Font fbld1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell h1 = new PdfPCell(new Phrase("Select",fbld1));
					            //System.out.println("Prepared");
					            h1.setBackgroundColor(new BaseColor(153, 0, 51));
								h1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					            //PdfPCell c1 = new PdfPCell(new Phrase("CIFID"));
								CMP.mLogger.debug("After PdfPTable 2:");
								Font fbold1 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c1 = new PdfPCell(new Phrase("CIFID",fbold1));
					            //System.out.println("Prepared");
					            c1.setBackgroundColor(new BaseColor(153, 0, 51));
								c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								CMP.mLogger.debug("After PdfPTable 3:");
					            //PdfPCell c1 = new PdfPCell(new Phrase("CIFID"));
								Font fbold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c2 = new PdfPCell(new Phrase("FullName",fbold2));
					            //System.out.println("Prepared");
					            c2.setBackgroundColor(new BaseColor(153, 0, 51));
								c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								//PdfPCell c2 = new PdfPCell(new Phrase("CIFStatus"));
								CMP.mLogger.debug("After PdfPTable 4:");
								Font fbold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c3 = new PdfPCell(new Phrase("DOB",fbold3));
					           //System.out.println("Prepared");
					            c3.setBackgroundColor(new BaseColor(153, 0, 51));
								c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					            //PdfPCell c3 = new PdfPCell(new Phrase("FullName"));
								CMP.mLogger.debug("After PdfPTable 5:");
								
								
								Font fbold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c4 = new PdfPCell(new Phrase("EmiratesID",fbold4));
					            //System.out.println("Prepared");
					            c4.setBackgroundColor(new BaseColor(153, 0, 51));
								c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					            //PdfPCell c4 = new PdfPCell(new Phrase("EmiratesID"));
								CMP.mLogger.debug("After PdfPTable 6:");
								Font fbold5 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c5 = new PdfPCell(new Phrase("PassportNumber",fbold5));
					            //System.out.println("Prepared");
					            c5.setBackgroundColor(new BaseColor(153, 0, 51));
								c5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								CMP.mLogger.debug("After PdfPTable 7:");
								Font fbold6 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c6 = new PdfPCell(new Phrase("Nationality",fbold6));
					            //System.out.println("Prepared");
					            c6.setBackgroundColor(new BaseColor(153, 0, 51));
								c6.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								//PdfPCell c6 = new PdfPCell(new Phrase("Phone"));
								CMP.mLogger.debug("After PdfPTable 8:");
								
								
								Font fbold7 = new Font(Font.FontFamily.TIMES_ROMAN, 10,Font.BOLD,new BaseColor(255,255,255));
					            PdfPCell c7 = new PdfPCell(new Phrase("Phone",fbold7));
					            //System.out.println("Prepared");
					            c7.setBackgroundColor(new BaseColor(153, 0, 51));
								c7.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
								//PdfPCell c6 = new PdfPCell(new Phrase("BFlag"));
								CMP.mLogger.debug("After PdfPTable 9:");  
								
								try
								{
									CMP.mLogger.debug("After PdfPTable append:");  
									pdf.addCell(h1);
									CMP.mLogger.debug("After PdfPTable append 1:");  
						            pdf.addCell(c1);
						            CMP.mLogger.debug("After PdfPTable append 2:");  
						            pdf.addCell(c2);
						            CMP.mLogger.debug("After PdfPTable append 3 :");  
						            pdf.addCell(c3);
						            CMP.mLogger.debug("After PdfPTable append 4:");  
						            pdf.addCell(c4);
						            CMP.mLogger.debug("After PdfPTable append 5:");  
									pdf.addCell(c5);
									CMP.mLogger.debug("After PdfPTable append 6:");  
						            pdf.addCell(c6);
						            CMP.mLogger.debug("After PdfPTable append 7:");  
									pdf.addCell(c7);
									CMP.mLogger.debug("After PdfPTable append 8:");  
								}
								catch(Exception e)
								{
									CMP.mLogger.debug("In catch After image : "+getStackTrace(e));
								}
								
								CMP.mLogger.debug("After PdfPTable 10:");
								CMP.mLogger.debug("CIF_ID.size() "+CIF_ID.size());
								for (int j = 0; j < CIF_ID.size(); j++) {
									
									h1 = new PdfPCell(new Phrase());
					                CMP.mLogger.debug("Aftr Select for WINAME "+WINAME);
									h1.setBackgroundColor(new BaseColor(255,251,240));
									//Checkbox is added for selected checkbox on 12/12/2017
									if(Checkbox.get(j).equalsIgnoreCase("true"))
									{
										CMP.mLogger.debug("\n Radiocount value for WINAME "+WINAME+"  inside cell"+Radiocount+"jjj"+(j+1));
															
										String imgFileName = "tick.jpeg";
										String generatedTickimgPath = properties.getProperty("CMP_LoadLogo");
										generatedTickimgPath=generatedTickimgPath.replace("/","//");
										generatedTickimgPath += imgFileName;
										generatedTickimgPath = path + generatedTickimgPath;
										CMP.mLogger.debug("\n dedup generatedTickimgPath"+generatedTickimgPath);
										
										Image tickimg = Image.getInstance(generatedTickimgPath);
										 //Paragraph preface1 = new Paragraph();
										tickimg.setAlignment(Image.ALIGN_CENTER);
										//tickimg.scaleAbsolute(20f, 20f);
										tickimg.setWidthPercentage(40);
										h1.addElement(tickimg);
										//preface1.add(tickimg);
										//doc.add(preface1);					
									}
									pdf.addCell(h1);
									
					                c1 = new PdfPCell(new Phrase(CIF_ID.get(j)));
									CMP.mLogger.debug("Aftr CIFIDarray for WINAME "+WINAME+" : "+CIF_ID.get(j));
									c1.setBackgroundColor(new BaseColor(255,251,240));
									c1.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c1);
					                
					                
					                
					                c2 = new PdfPCell(new Phrase(CUSTOMER_FULLNAME.get(j)));
					                CMP.mLogger.debug("Aftr fullNamearray for WINAME "+WINAME+" : "+CUSTOMER_FULLNAME.get(j));
									c2.setBackgroundColor(new BaseColor(255,251,240));
									c2.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c2);
									
									c3 = new PdfPCell(new Phrase(DATE_OF_BIRTH.get(j)));
					                CMP.mLogger.debug("Aftr DOBarray for WINAME "+WINAME+" : "+DATE_OF_BIRTH.get(j));
									c3.setBackgroundColor(new BaseColor(255,251,240));
									c3.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c3);
									
									try {
										c4 = new PdfPCell(new Phrase(EMIRATES_ID.get(j)));
										//System.out.println("Aftr EmiratesIDarray");
										CMP.mLogger.debug("\n EmiratesIDarray value for WINAME "+WINAME+" : "+EMIRATES_ID.get(j));
										c4.setBackgroundColor(new BaseColor(255,251,240));
										c4.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
										pdf.addCell(c4);
									} catch (Exception e){
										
									}
									
									c5 = new PdfPCell(new Phrase(PASSPORT_NUMBER.get(j)));
					                //System.out.println("Aftr PassportNumberarray");
									CMP.mLogger.debug("\n PassportNumberarray value for WINAME "+WINAME+" : "+PASSPORT_NUMBER.get(j));
									c5.setBackgroundColor(new BaseColor(255,251,240));
									c5.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c5);
									
									c6 = new PdfPCell(new Phrase(NATIONALITY.get(j)));
					                //System.out.println("aftr Nationalityarray");
									CMP.mLogger.debug("\n Nationalityarray value for WINAME "+WINAME+" : "+NATIONALITY.get(j));
									c6.setBackgroundColor(new BaseColor(255,251,240));
									c6.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c6);
					                
									
									
					                c7 = new PdfPCell(new Phrase(MOBILE_NUMBER.get(j)));
					                //System.out.println("aftr Phonearray");
									CMP.mLogger.debug("\n Phonearray value for WINAME "+WINAME+" : "+MOBILE_NUMBER.get(j));
									c7.setBackgroundColor(new BaseColor(255,251,240));
									 CMP.mLogger.debug("\n PDF Generated check for WINAME "+WINAME);
									c7.setHorizontalAlignment(PdfPCell.ALIGN_CENTER);
					                pdf.addCell(c7);				
								     CMP.mLogger.debug("\n PDF Generated check 1 for WINAME "+WINAME);           
									 //doc.add(pdf);
					            }
								
					            doc.add(pdf);								
					            doc.close();
					            
								CMP.mLogger.debug("\n PDF Generated Successfully in target location for WINAME "+WINAME);
								//Customer Detail Call********************************************************************
								MQ_response = MQ_connection_response(iformObj,control,StringData);
								
								MQ_response=MQ_response.substring(MQ_response.indexOf("<?xml v"),MQ_response.indexOf("</MQ_RESPONSE_XML>"));
								CMP.mLogger.debug("Inside Customer detail check function "+MQ_response);	
								if(MQ_response.indexOf("<ReturnCode>")!=-1)
								{
									ReturnCode1 = MQ_response.substring(MQ_response.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,MQ_response.indexOf("</ReturnCode>"));
								}
								if(MQ_response.indexOf("<ReturnDesc>")!=-1)
								{
									ReturnDesc = MQ_response.substring(MQ_response.indexOf("<ReturnDesc>")+"</ReturnDesc>".length()-1,MQ_response.indexOf("</ReturnDesc>"));
								}
								
								CMP.mLogger.debug("Return  code for the Customer detail call"+ReturnCode1);
								if(ReturnCode1.equals("0000"))
								{												
									MainCifId = (MQ_response.contains("<CIFID>")) ? MQ_response.substring(MQ_response.indexOf("<CIFID>")+"</CIFID>".length()-1,MQ_response.indexOf("</CIFID>")):"";
									CMP.mLogger.debug("MainCifId : "+MainCifId);
									MainCustomerSegment = (MQ_response.contains("<CustomerSegment>")) ? MQ_response.substring(MQ_response.indexOf("<CustomerSegment>")+"</CustomerSegment>".length()-1,MQ_response.indexOf("</CustomerSegment>")):"";
									CMP.mLogger.debug("MainCustomerSegment : "+MainCustomerSegment);
									MainCustomerSubSegment = (MQ_response.contains("<CustomerSubSeg>")) ? MQ_response.substring(MQ_response.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,MQ_response.indexOf("</CustomerSubSeg>")):"";
									CMP.mLogger.debug("MainCustomerSubSegment : "+MainCustomerSubSegment);
									
									String MainIsBlackListed = (MQ_response.contains("<IsBlackListed>")) ? MQ_response.substring(MQ_response.indexOf("<IsBlackListed>")+"</IsBlackListed>".length()-1,MQ_response.indexOf("</IsBlackListed>")):"";
									CMP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MainIsBlackListed : "+MainIsBlackListed);
									
									String MainIsNegativeListed = (MQ_response.contains("<IsNegativeListed>")) ? MQ_response.substring(MQ_response.indexOf("<IsNegativeListed>")+"</IsNegativeListed>".length()-1,MQ_response.indexOf("</IsNegativeListed>")):"";
									CMP.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+getActivityName()+", MainIsNegativeListed : "+MainIsNegativeListed);
																		
									/*setControlValue("CIF_NUMBER",MainCifId);
									setControlValue("CUSTOMER_SEGMENT",MainCustomerSegment);
									setControlValue("CUSTOMER_SUBSEGMENT",MainCustomerSubSegment);*/
									setControlValue("IsBlackListedCustSummary",MainIsBlackListed);
									setControlValue("IsNegativeListedCustSummary",MainIsNegativeListed);
									//setControlValue("EXISTING_CUSTOMER","Y");
									//setControlValue("DUPLICATE_CIF_FOUND","Yes");
									CMP.mLogger.debug("@@@@@@@@@@ : after add from customer details");
									String OutputTxt=MainCifId+"~"+MainCustomerSegment+"~"+MainCustomerSubSegment+"~"+MainIsBlackListed+"~"+MainIsNegativeListed;
									CMP.mLogger.debug("OutputTxt --"+OutputTxt);
									
									String Response=AttachDocumentWithWI(iformObj,WINAME,pdfName);
									return ReturnCode1+"~"+ReturnDesc+"~"+Response+"~"+OutputTxt;
								}							
								else
								{
									CMP.mLogger.debug("Error in Response of customer details"+ReturnCode1);
									return ReturnCode1+"~"+ReturnDesc;
								}
								
							}
							catch(Exception e)
							{
								e.printStackTrace();
								//sMappOutPutXML="Exception"+e;
								CMP.mLogger.debug("in catch of DedupeGeneratePDF Exception is: "+e);
								//return "in catch of DedupeGeneratePDF Exception is: "+e;
							}
						//*************************************************************************						
				 }
			}
				
			
			catch(Exception exc)
			{
				CMP.printException(exc);
				CMP.mLogger.debug( "Exception 2 - "+exc);
			}
		
			return "";
		}
	}	
	public String MQ_connection_response(IFormReference iformObj,String control,String Data) 
	{
		
	CMP.mLogger.debug("Inside MQ_connection_response function");
	final IFormReference iFormOBJECT;
	final WDGeneralData wdgeneralObj;	
	Socket socket = null;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String mqOutputResponse = null;
	String mqOutputResponse_Entity = null;
	String mqOutputResponse_Account = null;
	String mqInputRequest = null;
	String cabinetName = getCabinetName();
	String wi_name = getWorkitemName();
	String ws_name = getActivityName();
	String sessionID = getSessionId();
	String userName = getUserName();
	String socketServerIP;
	int socketServerPort;
	wdgeneralObj = iformObj.getObjGeneralData();
	sessionID = wdgeneralObj.getM_strDMSSessionId();
	String CIFNumber="";
	String EmiratesID ="";
	String AccountNumber="";
	String CardNumber="";
	String LoanAgreementID="";
	String Nikita="";

	if(control.equals("BtnRetryBlacklist") || control.equals("BlacklistFormLoad"))
	{
		String DocDetXml="";
		
		if(!getControlValue("EMIRATES_ID").trim().equals(""))
		{
			DocDetXml = DocDetXml+"<Document>\n" +
				"<DocumentType>EMID</DocumentType>\n" +
				"<DocumentRefNumber>"+getControlValue("EMIRATES_ID").trim()+"</DocumentRefNumber>\n" +
			"</Document>";
		}
		if(!getControlValue("PASSPORT_NUMBER").trim().equals(""))
		{
			DocDetXml = DocDetXml+"<Document>\n" +
				"<DocumentType>PPT</DocumentType>\n" +
				"<DocumentRefNumber>"+getControlValue("PASSPORT_NUMBER").trim()+"</DocumentRefNumber>\n" +
			"</Document>";
		}
		
		
		String DOB = getControlValue("DOB").trim();
		if(!DOB.trim().equalsIgnoreCase(""))
		{
			String tempDOB [] = DOB.split("/");
			DOB = tempDOB[2]+"-"+tempDOB[1]+"-"+tempDOB[0];
		}
		
		CMP.mLogger.debug("Final Doc XML:"+DocDetXml);
		CMP.mLogger.debug("Final DOB:"+DOB);
		
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n" +
			"<EE_EAI_HEADER>\n" +
			"<MsgFormat>BLACKLIST_DETAILS</MsgFormat>\n" +
			"<MsgVersion>0001</MsgVersion>\n" +
			"<RequestorChannelId>BPM</RequestorChannelId>\n" +
			"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
			"<RequestorLanguage>E</RequestorLanguage>\n" +
			"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
			"<ReturnCode>0000</ReturnCode>\n" +
			"<ReturnDesc>REQ</ReturnDesc>\n" +
			"<MessageId>BPM_MARY_02</MessageId>\n" +
			"<Extra1>REQ||BPM.123</Extra1>\n" +
			"<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>\n" +
			"</EE_EAI_HEADER>\n" +	
			"<CustomerBlackListRequest><BankId>RAK</BankId><CIFID></CIFID>" +
			"<CustomerType>R</CustomerType><RetailCorpFlag>R</RetailCorpFlag><EntityType>All</EntityType>" +
			"<PersonDetails><FirstName>"+getControlValue("FIRST_NAME").trim()+"</FirstName><LastName>"+getControlValue("LAST_NAME").trim()+"</LastName>" +
			"<MaritalStatus>"+getControlValue("MARITAL_STATUS").trim()+"</MaritalStatus><Nationality>"+getControlValue("NATIONALITY").trim()+"</Nationality>" +
			"<DateOfBirth>"+DOB+"</DateOfBirth>" +
			"</PersonDetails>"+DocDetXml+"</CustomerBlackListRequest></EE_EAI_MESSAGE>\n");
	
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	CMP.mLogger.debug("$$outputgGridtXML "+"mqInputRequest for Blacklist Check call" + mqInputRequest);
	}
	
	else if(control.equals("BtnRetryDuplicate") || control.equals("DedupeSubFormLoad"))
	{
		String DocDetXml="";
		
		if(!getControlValue("EMIRATES_ID").equals(""))
		{
			DocDetXml = DocDetXml+"<Document>\n" +
				"<DocumentType>EMID</DocumentType>\n" +
				"<DocumentRefNumber>"+getControlValue("EMIRATES_ID")+"</DocumentRefNumber>\n" +
			"</Document>";
		}
		if(!getControlValue("PASSPORT_NUMBER").equals(""))
		{
			DocDetXml = DocDetXml+"<Document>\n" +
				"<DocumentType>PPT</DocumentType>\n" +
				"<DocumentRefNumber>"+getControlValue("PASSPORT_NUMBER")+"</DocumentRefNumber>\n" +
			"</Document>";
		}
				
		String DOB = getControlValue("DOB");
		if(!DOB.trim().equalsIgnoreCase(""))
		{
			String tempDOB [] = DOB.split("/");
			DOB = tempDOB[2]+"-"+tempDOB[1]+"-"+tempDOB[0];
		}
		
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n" +
			"<EE_EAI_HEADER>\n" +
			"<MsgFormat>DEDUP_SUMMARY</MsgFormat>\n" +
			"<MsgVersion>0001</MsgVersion>\n" +
			"<RequestorChannelId>BPM</RequestorChannelId>\n" +
			"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
			"<RequestorLanguage>E</RequestorLanguage>\n" +
			"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
			"<ReturnCode>0000</ReturnCode>\n" +
			"<ReturnDesc>REQ</ReturnDesc>\n" +
			"<MessageId>BPM_MARY_02</MessageId>\n" +
			"<Extra1>REQ||BPM.123</Extra1>\n" +
			"<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>\n" +
			"</EE_EAI_HEADER>\n" +	
			"<CustomerDuplicationListRequest><BankId>RAK</BankId><CIFID></CIFID>" +
			"<CustomerType>R</CustomerType><RetailCorpFlag>R</RetailCorpFlag><EntityType>All</EntityType>" +
			"<PersonDetails><FirstName>"+getControlValue("FIRST_NAME")+"</FirstName><LastName>"+getControlValue("LAST_NAME")+"</LastName>" +
			"<MaritalStatus>"+getControlValue("MARITAL_STATUS")+"</MaritalStatus><Nationality>"+getControlValue("NATIONALITY")+"</Nationality>" +
			"<DateOfBirth>"+DOB+"</DateOfBirth>" +
			"</PersonDetails>"+DocDetXml+"</CustomerDuplicationListRequest></EE_EAI_MESSAGE>\n");
	
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	CMP.mLogger.debug("$$outputgGridtXML "+"mqInputRequest for Dedupe Check call" + mqInputRequest);
	}
		
/*	else if(control.equals("BtnRetryRiskScore") || control.equals("RiskScoreFormLoad"))
	{
		 CMP.mLogger.debug("Inside RiskScore call is --");
		 /*EmiratesID = getControlValue("EMIRATES_ID_SEARCH");
		 AccountNumber= getControlValue("ACCOUNT_NUMBER");
		 CardNumber= getControlValue("CARD_NUMBER");
		 LoanAgreementID = getControlValue("LOAN_AGREEMENT_ID");
		 String account_type="";
		//getAccountType for Card
		 
			if (AccountNumber == "") {
				if (CardNumber != "") {
					AccountNumber = CardNumber;
					account_type = "C";

				}
				//code change for Loan Agreement ID
				else if (LoanAgreementID != "") {
					AccountNumber = LoanAgreementID;
					account_type = "L";
				} else
					account_type = "";
			}*/
		/*	
			String ReferenceCifId = "";
			if(!getControlValue("CIF_NUMBER").equalsIgnoreCase(""))
			{
				ReferenceCifId = "<RequestInfo>\n" +
					"<RequestType>CIF Id</RequestType>\n" +
					"<RequestValue>"+getControlValue("CIF_NUMBER")+"</RequestValue>\n" +
				"</RequestInfo>\n";
			}
			
			String ProductsInfoXml = "";
			if(!(getControlValue("PRODUCTYPE").equalsIgnoreCase("") && getControlValue("PRODUCTCURR").equalsIgnoreCase("")))
			ProductsInfoXml = ProductsInfoXml + "<ProductsInfo>\n" +
					"<Product>"+getControlValue("PRODUCTYPE")+"</Product>\n" +
					"<Currency>"+getControlValue("PRODUCTCURR")+"</Currency>\n" +
				"</ProductsInfo>\n" ;
			
			String FirstName=getControlValue("FIRST_NAME");
			String MidName=getControlValue("MIDDLE_NAME");
			String LstName=getControlValue("LAST_NAME");
			String CustomerName="";
			
			if (MidName.equalsIgnoreCase(""))
				CustomerName = FirstName + ' ' + LstName;
			else	
				CustomerName = FirstName + ' ' + MidName + ' ' + LstName;
			 
			
			String Demographic=getControlValue("CUSTOMER_SUBSEGMENT");			
			String DemographicXml = "";
			if (Demographic.contains("#"))
			{
				String DemoGraphicData [] = Demographic.replace("#","~").split("~");
				for (int i = 0; i < DemoGraphicData.length; i++)
				{
					DemographicXml = DemographicXml + "<Demographic>"+DemoGraphicData[i]+"</Demographic>\n";
				}
			} else {
				DemographicXml = "<Demographic>"+Demographic+"</Demographic>\n";
			}
			
		StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<ProcessName>RAO</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>RISK_SCORE_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>REQ</ReturnDesc>\n"+
				"<MessageId>BPM_MARY_02</MessageId>\n"+
				"<Extra1>REQ||BPM.123</Extra1>\n"+
				"<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<RiskScoreDetailsRequest>\n" + ReferenceCifId +
				"<RequestInfo>\n" +
				"<RequestType>Reference Id</RequestType>\n" +
				"<RequestValue>"+wi_name+"</RequestValue>\n" +
				"</RequestInfo>\n" +
				"<CustomerType>Individual</CustomerType>\n" + 
				"<CustomerCategory>"+getControlValue("CUSTOMER_TYPE")+"</CustomerCategory>\n" + 
				"<IsPoliticallyExposed>"+getControlValue("PEP")+"</IsPoliticallyExposed>\n" + 
				"<CustomerName>"+CustomerName+"</CustomerName>\n" + 
				"<EmploymentType>Salaried</EmploymentType>\n" +  // Passing Salaried default on confirmation of Natesh
				getControlValue("CUSTOMER_SEGMENT") +"\n" +
				getControlValue("CUSTOMER_SUBSEGMENT") +"\n" +
				"<Demographics>\n" +
				DemographicXml + "\n" + 
				"</Demographics>\n" +
				"<Nationalities>\n" +
				"<Nationality>"+getControlValue("NATIONALITY")+"</Nationality>\n" +
				"</Nationalities>\n" +
				"<Industries>\n" +
				"<Industry>"+getControlValue("INDUSTRY_SUBSEGMENT")+"</Industry>\n" + 
				"</Industries>\n" +
				ProductsInfoXml + "\n" +
				"</RiskScoreDetailsRequest>\n" +
				"</EE_EAI_MESSAGE>");
	mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
	CMP.mLogger.debug("$$outputgGridtXML "+"mqInputRequest for Risk Score call" + mqInputRequest);
	} */
	
	else if(control.equals("BtnPopulateDuplicate"))
	{
		CMP.mLogger.debug("Inside BtnPopulateDuplicate control--"+Data);
		String acc_selected = Data;
		String strCheckbox="";
		String CIF_ID="";
		int Dedupetablesize = iformObj.getDataFromGrid("Q_USR_0_CMP_DEDUPE_DETAILS").size();
		CMP.mLogger.debug("$$Dedupetablesize " + Dedupetablesize);
		for (int j = 0; j < Dedupetablesize; j++) {
		strCheckbox=iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS",j,0);
		CIF_ID=iformObj.getTableCellValue("Q_USR_0_CMP_DEDUPE_DETAILS",j,1);
		
			if (strCheckbox.equalsIgnoreCase("true")) {		
				StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
						"<EE_EAI_HEADER>\n"+
						"<MsgFormat>CUSTOMER_DETAILS</MsgFormat>\n"+
						"<MsgVersion>0000</MsgVersion>\n"+
						"<RequestorChannelId>BPM</RequestorChannelId>\n"+
						"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
						"<RequestorLanguage>E</RequestorLanguage>\n"+
						"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
						"<ReturnCode>911</ReturnCode>\n"+
						"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
						"<MessageId>MDL053169111</MessageId>\n"+
						"<Extra1>REQ||PERCOMER.PERCOMER</Extra1>\n"+
						"<Extra2>2007-01-01T10:30:30.000Z</Extra2>\n"+
						"</EE_EAI_HEADER>\n"+
						"<FetchCustomerDetailsReq><BankId>RAK</BankId><CCIFID></CCIFID><RCIFID>"+CIF_ID+"</RCIFID><DealProdType></DealProdType><FetchExpired></FetchExpired></FetchCustomerDetailsReq>\n"+
						"</EE_EAI_MESSAGE>");
			mqInputRequest = getMQInputXML(sessionID, cabinetName,wi_name, ws_name, userName, finalXml);
			CMP.mLogger.debug("$$outputgGridtXML "+"mqInputRequest for Fetch Customer call" + mqInputRequest);
			break;
			}			
		}		
		CMP.mLogger.debug("$$Dedupetablesize " + strCheckbox);
		CMP.mLogger.debug("$$Dedupetablesize " + CIF_ID);
		
	}
	
	try {
	
	CMP.mLogger.debug("userName "+ userName);
	CMP.mLogger.debug("sessionID "+ sessionID);
	
	String sMQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'CMP' and CallingSource = 'Form'";
	List<List<String>> outputMQXML = iformObj.getDataFromDB(sMQuery);
	//CreditCard.mLogger.info("$$outputgGridtXML "+ "sMQuery " + sMQuery);
	if (!outputMQXML.isEmpty()) {
		//CreditCard.mLogger.info("$$outputgGridtXML "+ outputMQXML.get(0).get(0) + "," + outputMQXML.get(0).get(1));
		socketServerIP = outputMQXML.get(0).get(0);
		CMP.mLogger.debug("socketServerIP " + socketServerIP);
		socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
		CMP.mLogger.debug("socketServerPort " + socketServerPort);
		if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort==0)) {
			CMP.mLogger.debug("Inside serverIP Port " + socketServerPort+ "-socketServerIP-"+socketServerIP);
			socket = new Socket(socketServerIP, socketServerPort);
			//new Code added by Deepak to set connection timeout
			int connection_timeout=60;
				try{
					connection_timeout=70;
					//connection_timeout = Integer.parseInt(NGFUserResourceMgr_CreditCard.getGlobalVar("Integration_Connection_Timeout"));
				}
				catch(Exception e){
					connection_timeout=60;
				}
				
			socket.setSoTimeout(connection_timeout*1000);
			out = socket.getOutputStream();
			socketInputStream = socket.getInputStream();
			dout = new DataOutputStream(out);
			din = new DataInputStream(socketInputStream);
			CMP.mLogger.debug("dout " + dout);
			CMP.mLogger.debug("din " + din);
			mqOutputResponse = "";
			
	
			if (mqInputRequest != null && mqInputRequest.length() > 0) {
				int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
				CMP.mLogger.debug("Final XML output len: "+outPut_len + "");
				mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
				CMP.mLogger.debug("MqInputRequest"+"Input Request Bytes : "+ mqInputRequest.getBytes("UTF-16LE"));
				dout.write(mqInputRequest.getBytes("UTF-16LE"));dout.flush();
			}
			byte[] readBuffer = new byte[500];
			int num = din.read(readBuffer);
			if (num > 0) {
	
				byte[] arrayBytes = new byte[num];
				System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
				mqOutputResponse = mqOutputResponse+ new String(arrayBytes, "UTF-16LE");
				CMP.mLogger.debug("mqOutputResponse/message ID :  "+mqOutputResponse);
				if(!"".equalsIgnoreCase(mqOutputResponse) && (control.equalsIgnoreCase("BtnRetryDuplicate") || control.equalsIgnoreCase("DedupeSubFormLoad"))){
					mqOutputResponse = getOutWtthMessageID("DEDUP_SUMMARY",iformObj,mqOutputResponse);
				}
				else if(!"".equalsIgnoreCase(mqOutputResponse) && (control.equalsIgnoreCase("BtnRetryBlacklist") || control.equalsIgnoreCase("BlacklistFormLoad")))
				{
					mqOutputResponse = getOutWtthMessageID("BLACKLIST_DETAILS",iformObj,mqOutputResponse);
				}
				
			/*	else if(!"".equalsIgnoreCase(mqOutputResponse) && (control.equalsIgnoreCase("BtnRetryRiskScore") || control.equalsIgnoreCase("RiskScoreFormLoad")))
				{
					mqOutputResponse = getOutWtthMessageID("RISK_SCORE_DETAILS",iformObj,mqOutputResponse);
				} */
				else if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("BtnPopulateDuplicate"))
				{
					mqOutputResponse = getOutWtthMessageID("CUSTOMER_DETAILS",iformObj,mqOutputResponse);
				}
				
				/*else if(!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_View_Signature"))
				{
					mqOutputResponse = getOutWtthMessageID("SIGNATURE_DETAILS",iformObj,mqOutputResponse);
				}*/
					
				if(mqOutputResponse.contains("&lt;")){
					mqOutputResponse=mqOutputResponse.replaceAll("&lt;", "<");
					mqOutputResponse=mqOutputResponse.replaceAll("&gt;", ">");
				}
			}
			socket.close();
			return mqOutputResponse;
			
		} else {
			CMP.mLogger.debug("SocketServerIp and SocketServerPort is not maintained "+"");
			CMP.mLogger.debug("SocketServerIp is not maintained "+	socketServerIP);
			CMP.mLogger.debug(" SocketServerPort is not maintained "+	socketServerPort);
			return "MQ details not maintained";
		}
	} else {
		CMP.mLogger.debug("SOcket details are not maintained in NG_BPM_MQ_TABLE table"+"");
		return "MQ details not maintained";
	}
	
	} catch (Exception e) {
		CMP.mLogger.debug("Exception Occured Mq_connection_CC"+e.getStackTrace());
	return "";
	}
	finally{
	try{
		if(out != null){
			
			out.close();
			out=null;
			}
		if(socketInputStream != null){
			
			socketInputStream.close();
			socketInputStream=null;
			}
		if(dout != null){
			
			dout.close();
			dout=null;
			}
		if(din != null){
			
			din.close();
			din=null;
			}
		if(socket != null){
			if(!socket.isClosed()){
				socket.close();
			}
			socket=null;
		}
	}catch(Exception e)
	{
		//		RLOS.mLogger.info("Exception occurred while closing socket");
		CMP.mLogger.debug("Final Exception Occured Mq_connection_CC"+e.getStackTrace());
		//printException(e);
	}
	}
	

	}
	public static String getCharacterDataFromElement(org.w3c.dom.Element e) {
		Node child = e.getFirstChild();
		if (child instanceof CharacterData) {
		   CharacterData cd = (CharacterData) child;
		   return cd.getData();
		}
		return "NO_DATA";
	}
	/*public String getImages(String tempImagePath,String debt_acc_num,String[] imageArr,String[] remarksArr)
	{
		
		String strCode =null;
		StringBuilder html = new StringBuilder();
		if(imageArr==null)
			return "";
		for (int i=0;i<imageArr.length;i++)
		{
			try
			{	
				CMP.mLogger.debug( "Inside Get Images 0");
				byte[] btDataFile = new sun.misc.BASE64Decoder().decodeBuffer(imageArr[i]);
				//File of = new File(filePath+debt_acc_num+"imageCreatedN"+i+".jpg");
				String imagePath = System.getProperty("user.dir")+ tempImagePath+System.getProperty("file.separator")+debt_acc_num+"imageCreatedN"+i+".jpg";
				CMP.mLogger.debug( "imagePath"+imagePath);
				File of = new File(imagePath);
				
				FileOutputStream osf = new FileOutputStream(of);
				osf.write(btDataFile);
				osf.flush();
				osf.close();
			}
			catch (Exception e)
			{
				CMP.mLogger.debug( e.getMessage());
				e.printStackTrace();
				CMP.mLogger.debug( "Not able to get the image imageCreated"+e);
			}
		}
		return "";
	}*/
	private static String getMQInputXML(String sessionID, String cabinetName,
			String wi_name, String ws_name, String userName,
			StringBuilder final_xml) {
		//FormContext.getCurrentInstance().getFormConfig();
		CMP.mLogger.debug("inside getMQInputXML function");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_CMP_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_xml);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		CMP.mLogger.debug("inside getOutputXMLValues"+ "getMQInputXML"+ strBuff.toString());
		return strBuff.toString();
	}
	public String getOutWtthMessageID(String callName,IFormReference iformObj,String message_ID){
		String outputxml="";
		try{
			//String wi_name = iformObj.getWFWorkitemName();
			String wi_name = getWorkitemName();
			String str_query = "select OUTPUT_XML from NG_CMP_XMLLOG_HISTORY with (nolock) where CALLNAME ='"+callName+"' and MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";
			CMP.mLogger.debug("inside getOutWtthMessageID str_query: "+ str_query);
			List<List<String>> result=iformObj.getDataFromDB(str_query);
			//below code added by nikhil 18/10 for Connection timeout
			//String Integration_timeOut=NGFUserResourceMgr_CreditCard.getGlobalVar("Inegration_Wait_Count");
			String Integration_timeOut="100";
			int Loop_wait_count=10;
			try
			{
				Loop_wait_count=Integer.parseInt(Integration_timeOut);
			}
			catch(Exception ex)
			{
				Loop_wait_count=10;
			}
		
			for(int Loop_count=0;Loop_count<Loop_wait_count;Loop_count++){
				if(result.size()>0){
					outputxml = result.get(0).get(0);
					break;
				}
				else{
					Thread.sleep(1000);
					result=iformObj.getDataFromDB(str_query);
				}
			}
			
			if("".equalsIgnoreCase(outputxml)){
				outputxml="Error";
			}
			CMP.mLogger.debug("getOutWtthMessageID" + outputxml);				
		}
		catch(Exception e){
			CMP.mLogger.debug("Exception occurred in getOutWtthMessageID" + e.getMessage());
			CMP.mLogger.debug("Exception occurred in getOutWtthMessageID" + e.getStackTrace());
			outputxml="Error";
		}
		return outputxml;
	}
	
	String getStackTrace(final Throwable throwable) {
        final StringWriter sw = new StringWriter();
        final PrintWriter pw = new PrintWriter(sw, true);
        throwable.printStackTrace(pw);
        return sw.getBuffer().toString();
    }
	
	public String createPDF(IFormReference iformObj,String template,String wi_name,String pdfName) throws FileNotFoundException, IOException, DocumentException
	{
		try
		{
		String pdfTemplatePath="";	
		String generatedPdfPath = "";
		String CountryName = "";
		String EmploymentType = "";
		String CustomerType = "";
		String IndustrySubsegment = "";
		String paramValue="";
		Hashtable<String, String> hashtable = new Hashtable<String, String>();
		//Reading path from property file
		Properties properties = new Properties();
		properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "RakBankConfig.properties"));
		
		//Generating the pdf for RAK_Individual_form********************************************************************************************************** 	
		if(template.equalsIgnoreCase("Risk_Score")) 
		{
				CMP.mLogger.debug("\nInside Risk_Score ");
								
				Map<String,String> columnvalues = new HashMap<String,String>(); 
			     
				String strQuery = "SELECT countryName FROM USR_0_BPM_COUNTRY_MASTER with (nolock) WHERE countryCode='"+getControlValue("NATIONALITY")+"'";
				String strQuery1 = "SELECT EmpTypedisplay FROM USR_0_BPM_EMPLOYMENT_TYPE with (nolock) WHERE EmpCode='"+getControlValue("EMPLOYMENT_TYPE")+"'";
				String strQuery2 = "SELECT CustType FROM USR_0_BPM_CUSTOMER_TYPE with (nolock) WHERE CustCode='"+getControlValue("CUSTOMER_TYPE")+"'";
				String strQuery3 = "SELECT IndustrySubSegType FROM USR_0_BPM_INDUSTRY_SUBSEGMENT with (nolock) WHERE IndSubSegCode='"+getControlValue("INDUSTRY_SUBSEGMENT")+"'";
				CMP.mLogger.debug("\nstrQuery"+strQuery);
				CMP.mLogger.debug("\nstrQuery1"+strQuery1);
				CMP.mLogger.debug("\nstrQuery2"+strQuery2);
				CMP.mLogger.debug("\nstrQuery3"+strQuery3);
				List<List<String>> outputMQXML = iformObj.getDataFromDB(strQuery);
				List<List<String>> outputMQXML1 = iformObj.getDataFromDB(strQuery1);
				List<List<String>> outputMQXML2 = iformObj.getDataFromDB(strQuery2);
				List<List<String>> outputMQXML3 = iformObj.getDataFromDB(strQuery3);
				
				CMP.mLogger.debug("\noutputMQXML"+outputMQXML);
				CMP.mLogger.debug("\noutputMQXML1"+outputMQXML1);
				CMP.mLogger.debug("\noutputMQXML2"+outputMQXML2);
				CMP.mLogger.debug("\noutputMQXML3"+outputMQXML3);
				
				if (!outputMQXML.isEmpty()) {
					CountryName = outputMQXML.get(0).get(0);
					CMP.mLogger.debug("\nCountryName"+CountryName);
					columnvalues.put("NATIONALITY", CountryName);
				}
				if (!outputMQXML1.isEmpty()) {
					EmploymentType = outputMQXML1.get(0).get(0);
					CMP.mLogger.debug("\nEmploymentType"+EmploymentType);
					columnvalues.put("EMPLOYMENT_TYPE", EmploymentType);
				}
				if (!outputMQXML2.isEmpty()) {
					CustomerType = outputMQXML2.get(0).get(0);
					CMP.mLogger.debug("\n CustomerType "+CustomerType);
					columnvalues.put("CUSTOMER_TYPE", CustomerType);
				}
				if (!outputMQXML3.isEmpty()) {
					IndustrySubsegment = outputMQXML3.get(0).get(0);
					CMP.mLogger.debug("\nIndustrySubsegment "+IndustrySubsegment);
					columnvalues.put("INDUSTRY_SUBSEGMENT", IndustrySubsegment);
				}
				
				//Enumeration<String> paramNames = request.getParameterNames();
				List<String> arrlist = new ArrayList<String>();
				arrlist.add("CIF_NUMBER");
				arrlist.add("EMPLOYMENT_TYPE");
				arrlist.add("CUSTOMER_TYPE");
				arrlist.add("CUSTOMER_SEGMENT");
				arrlist.add("CUSTOMER_SUBSEGMENT");
				arrlist.add("DEMOGRAPHIC");
				arrlist.add("INDUSTRY_SUBSEGMENT");
				arrlist.add("NATIONALITY");
				arrlist.add("PEP");
				arrlist.add("RISK_SCORE");
				Enumeration<String> paramNames = Collections.enumeration(arrlist);
				while(paramNames.hasMoreElements())
				{
					paramValue="";
					String paramName = (String)paramNames.nextElement();
					CMP.mLogger.debug("\nparamName "+paramName + " : ");
					CMP.mLogger.debug("\ncolumnvalues.toString() "+columnvalues.toString() + " : ");
					
					//Loading values from master table and mapping with pdf
					Set PDFSet = columnvalues.keySet();
					Iterator PDFIt = PDFSet.iterator();
					while(PDFIt.hasNext()) 
					{
						String HT_Key 	= (String)PDFIt.next();
						String HT_Value	= (String)columnvalues.get(HT_Key);
						CMP.mLogger.debug("HT_Key : "+HT_Key + " HT_Value :"+HT_Value);
						if(paramName.toString().equals(HT_Key.toString()))
						{
							paramValue=HT_Value.toString();
						}						
					}
					//********************************************************
					
					CMP.mLogger.debug("\nparamValue 1"+paramValue);
					if(paramValue.equals(""))
					{						
						paramValue = getControlValue(paramName);
					}
					
					//paramValue = paramValue.replace("`~`","%");
					CMP.mLogger.debug("\nparamValue 2"+paramValue);
					hashtable.put(paramName, paramValue);
				}
				pdfTemplatePath = properties.getProperty("CMP_RAK_RiskScore");
		}//*********************************************************************************************************************
		
		String dynamicPdfName = "";
		if(template.equalsIgnoreCase("Risk_Score")){
			dynamicPdfName = wi_name + pdfName + ".pdf"; //Modified by Nikita for risk score pdf on 19042018
		}
		else 
		{
			dynamicPdfName = pdfName + "_" + System.currentTimeMillis()/1000*60 + ".pdf";
		}
		String path = System.getProperty("user.dir");
		pdfTemplatePath = path + pdfTemplatePath;//Getting complete path of the pdf tempplate
		generatedPdfPath = properties.getProperty("CMP_GENERTATED_PDF_PATH");//Get the loaction of the path where generated template will be saved
		generatedPdfPath += dynamicPdfName;
		generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
		CMP.mLogger.debug("\n pdfTemplatePath :" + pdfTemplatePath);		
		CMP.mLogger.debug("\n after replace GeneratedPdfPath :" + generatedPdfPath);

		String pdfArabtype_Path=properties.getProperty("CMP_ARABTYPE_PATH");		
		pdfArabtype_Path = path + pdfArabtype_Path;//Getting complete path of the arabtype ttf
		CMP.mLogger.debug("\n pdfArabtype_Path :" + pdfArabtype_Path);
		
		PdfReader reader = new PdfReader(pdfTemplatePath);
		CMP.mLogger.debug("Created reader object from template :");
		PdfStamper stamp = new PdfStamper(reader,new FileOutputStream(generatedPdfPath)); 	
		CMP.mLogger.debug("Created stamper object from destination :");
		AcroFields form=stamp.getAcroFields();
		BaseFont unicode=BaseFont.createFont(pdfArabtype_Path,BaseFont.IDENTITY_H,BaseFont.EMBEDDED);		
		CMP.mLogger.debug("Created arabtype font:");
		ArrayList al=new ArrayList();
		al.add(unicode);
		form.setSubstitutionFonts(al);
		PdfWriter p= stamp.getWriter();
		p.setRunDirection(p.RUN_DIRECTION_RTL);  
		BaseFont bf1 = BaseFont.createFont (BaseFont.TIMES_ROMAN,BaseFont.CP1252,BaseFont.EMBEDDED);				
		form.addSubstitutionFont(bf1);                 

		// Handling values form Hashtable
		Set PDFSet = hashtable.keySet();
		Iterator PDFIt = PDFSet.iterator();
		while(PDFIt.hasNext()) 
		{
			String HT_Key 	= (String)PDFIt.next();
			String HT_Value	= (String)hashtable.get(HT_Key);
			CMP.mLogger.debug("HT_Key : "+HT_Key + " HT_Value :"+HT_Value);
			form.setField(HT_Key,HT_Value);
		}
		stamp.setFormFlattening(true);
		stamp.close();
		
		CMP.mLogger.debug("\ncreatePDF : Inside service method : end");
		
		return "Successful in createPDF";
	}
	catch(Exception e)
	{
		CMP.mLogger.debug("\nError in createPDF");	
		return "Error in createPDF";
	}	
 }
}