package com.newgen.iforms.user;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.net.Socket;
import java.net.SocketException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.itextpdf.text.DocumentException;
import com.newgen.XMLParser.XMLParser;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.xmlapi.IFormXmlResponse;
//import com.newgen.iforms.user.*;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

import com.itextpdf.text.pdf.*;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import com.itextpdf.awt.geom.Rectangle;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfDictionary;
import com.itextpdf.text.pdf.PdfFormField;
import com.itextpdf.text.pdf.PdfName;
import com.itextpdf.text.pdf.PdfNumber;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.TextField;
import com.itextpdf.text.pdf.parser.PdfContentStreamProcessor;
import com.itextpdf.text.Phrase;

import ISPack.CImageServer;
import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;
import Jdts.DataObject.JPDBString;

	public class KYC_Remediation_Common {
		String sLocaleForMessage = java.util.Locale.getDefault().toString();
	
		static Map<String, String> CourtOrder_ConfigProperties = new HashMap<String, String>();
	
		
		protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort, int flag) throws IOException {
			try {
				KYC_Remediation.mLogger.info("WFNGExecute() : " + ipXML + " - " + jtsServerIP + " - " + serverPort + " - " + flag);
				if (serverPort.startsWith("33")) {
					KYC_Remediation.mLogger.info("Inside if WFNGExecute() :");
					return WFCallBroker.execute(ipXML, jtsServerIP, Integer.parseInt(serverPort), 1);
				} else {
					KYC_Remediation.mLogger.info("Inside else WFNGExecute() :");
					return NGEjbClient.getSharedInstance().makeCall(jtsServerIP, serverPort, "WebSphere", ipXML);
				}
				//
			} catch (Exception e) {
				KYC_Remediation.mLogger.info("Exception Occured in WF NG Execute : " + e.getMessage());
				return "Error";
			}
	
		}
	
		public static void waiteloopExecute(long wtime) {
			try {
				for (int i = 0; i < 10; i++) {
					Thread.yield();
					Thread.sleep(wtime / 10);
				}
			} catch (InterruptedException e) {
				KYC_Remediation.mLogger.info(e.toString());
				Thread.currentThread().interrupt();
			}
		}
		
		
		public String RISK_SCORE_DETAILS(IFormReference iform) throws IOException {
			String risk = "";
			String riskCorporate = "";
			try 
			{
				KYC_Remediation.mLogger.debug("Start RISK_SCORE_DETAILS: ");
				String  CaseType = (String)iform.getValue("CaseType");
				if("Individual".equalsIgnoreCase(CaseType)){
					risk = getRisk_XMLIndividual(iform);
					return risk;
				}
				else{
					riskCorporate = getRisk_XMLCorporate(iform);
					return riskCorporate;
				}
				/*String CIF = (String) iform.getValue("CIF_ID");
				String Wi_number = getWorkitemName(iform);
				String middleWi[] = Wi_number.split("-");
				Wi_number = middleWi[1];
				String PEP = (String) iform.getValue("PEP");
				if("NOT PEP".equalsIgnoreCase(PEP)){
					PEP = "N";
				}
				else{
					PEP = "Y";
				}
				
				String Full_name="";
//				String MiddleName = (String)iform.getValue("Middle_Name");
//				if("".equalsIgnoreCase(MiddleName) || MiddleName == null){
//					
//				 Full_name = (String) iform.getValue("Given_Name") + " " + iform.getValue("Surname");}
//				else{
//					
//					 Full_name = (String) iform.getValue("Given_Name") + " "+MiddleName+" " + iform.getValue("Surname");}
				
				Full_name = (String) iform.getValue("FirstName") + " " + iform.getValue("LastName");
				String emp_type = (String) iform.getValue("OfficeEmploymentType");
				String Nationality = (String) iform.getValue("Nationality");
				String Sec_Nationality = (String) iform.getValue("OtherNationality");
				String product_typ = (String) iform.getValue("AccountType");
				String product_curr = (String) iform.getValue("ProductCurrency");
				String Country_Residenece = (String) iform.getValue("ResidenceCountry");
	
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:CIF: " + CIF);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Wi_number: " + Wi_number);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Full_name: " + Full_name);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:PEP: " + PEP);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:emp_type: " + emp_type);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Nationality: " + Nationality);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Sec_Nationality: " + Sec_Nationality);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:product_typ: " + product_typ);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:product_curr: " + product_curr);
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Country_Residenece: " + Country_Residenece);
	
				// Getting the description for product_typ.
				String Product_type_descptn = "";
				//below code commented by vinyak to chnage to display correct account type
				String account_type_query = "select account_type from NG_MASTER_KYC_REM_PRODUCT_NAME with(nolock) where cm_code='" + product_typ + "'";
				List<List<String>> account_type_query_output = iform.getDataFromDB(account_type_query);
				KYC_Remediation.mLogger.debug("account_type_query_output : " + account_type_query_output);
				String account_type_val="";
				if (!account_type_query_output.isEmpty()) {
					KYC_Remediation.mLogger.debug("Inside account_type_query_output: ");
					 account_type_val = account_type_query_output.get(0).get(0);
					KYC_Remediation.mLogger.debug("account_type_val: " + account_type_val);							
				} else {
					KYC_Remediation.mLogger.debug("account_type_query_output is empty!!");
				}
				
				if (account_type_val.equalsIgnoreCase("Current")){
					Product_type_descptn = "Current Account";
				}
				else if(account_type_val.equalsIgnoreCase("Saving")){
					Product_type_descptn = "Savings Account";
				}
				
				
				if (product_typ.equalsIgnoreCase("ACNP1") || (product_typ.equalsIgnoreCase("GBNP1"))) {
					Product_type_descptn = "Current Account";
				} else {
					Product_type_descptn = "Savings Account";
				}
	
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Product_type_descptn:" + Product_type_descptn);
	
				// Getting the description for Nationality.
				String Nationality_descptn = "";
				String Desc_Nationality = "select distinct CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE WITH(NOLOCK) where CM_CODE='"
						+ Nationality + "'";
				KYC_Remediation.mLogger.debug("Desc_Country_Residenece_query: " + Desc_Nationality);
				List<List<String>> output_Nationality_query = iform.getDataFromDB(Desc_Nationality);
				KYC_Remediation.mLogger.debug("output_Desc_Country_Residenece_query: " + output_Nationality_query);
	
				if (!output_Nationality_query.isEmpty()) {
					KYC_Remediation.mLogger.debug("Inside output_Nationality_query: ");
					Nationality_descptn = output_Nationality_query.get(0).get(0);
					KYC_Remediation.mLogger.debug("Product_type_descptn: " + Nationality_descptn);
				} else {
					KYC_Remediation.mLogger.debug("Nationality_descptn is empty!!");
				}
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Nationality_descptn:" + Nationality_descptn);
	
				// Getting the description for Sec_Nationality.
				String Sec_Nationality_descptn = "";
				String Desc_Sec_Nationality = "select DISTINCT CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE WITH(NOLOCK) where CM_CODE='"
						+ Sec_Nationality + "'";
				KYC_Remediation.mLogger.debug("Desc_Country_Residenece_query: " + Desc_Sec_Nationality);
				List<List<String>> output_Sec_Nationality_query = iform.getDataFromDB(Desc_Sec_Nationality);
				KYC_Remediation.mLogger.debug("output_Desc_Country_Residenece_query: " + output_Sec_Nationality_query);
	
				if (!output_Sec_Nationality_query.isEmpty()) {
					KYC_Remediation.mLogger.debug("Inside Sec_Nationality_descptn: ");
					Sec_Nationality_descptn = output_Sec_Nationality_query.get(0).get(0);
					KYC_Remediation.mLogger.debug("Sec_Nationality_descptn: " + Sec_Nationality_descptn);
				} else {
					KYC_Remediation.mLogger.debug("Sec_Nationality_descptn is empty!!");
				}
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Sec_Nationality_descptn:" + Sec_Nationality_descptn);
	
				String Nationality_tag = "";
				if (!"".equalsIgnoreCase(Nationality_descptn)) {
					Nationality_tag += "<Nationality>" + Nationality_descptn + "</Nationality>";
				}
				if (!"".equalsIgnoreCase(Sec_Nationality_descptn)) {
					Nationality_tag += "<Nationality>" + Sec_Nationality_descptn + "</Nationality>";
				}
	
				// Industry Repeating tag
				String industry_tag = "";
				String final_tag_countires_W_business_Conducted = "";
				String Country_Residenece_descptn = "";
				if (emp_type.equalsIgnoreCase("Self employed")) {
					String industry_query_desc = "";
					KYC_Remediation.mLogger.debug("compnay_grid: Self employed");
					int compnay_grid = iform.getDataFromGrid("company_detail").size();
					KYC_Remediation.mLogger.debug("compnay_grid: Self employed: size" + compnay_grid);
					for (int i = 0; i < compnay_grid; i++) {
						String industry_value = iform.getTableCellValue("company_detail", i, 3);
						KYC_Remediation.mLogger.debug("compnay_grid : industry_value Table cell value : " + industry_value);
	
						String industry_query = "select  description from NG_MASTER_KYC_REM_RCC_Industry  WITH(NOLOCK) where code='" + industry_value + "'";
						List<List<String>> industry_query_output = iform.getDataFromDB(industry_query);
						KYC_Remediation.mLogger.debug("compnay_grid : Cont_W_business_out : " + industry_query);
	
						if (!industry_query_output.isEmpty()) {
							KYC_Remediation.mLogger.debug("Inside Cont_W_business_out: ");
							industry_query_desc = industry_query_output.get(0).get(0);
							KYC_Remediation.mLogger.debug("industry_query_desc: " + industry_query_desc);
							industry_tag += "<Industry>" + industry_query_desc + "</Industry>";
						} else {
							KYC_Remediation.mLogger.debug("industry_query_desc is empty!!");
						}
					}
	
					// countries W business conducted logic: self employed case
	
					for (int j = 0; j < compnay_grid; j++) {
						String countries_W_bus = iform.getTableCellValue("company_detail", j, 8);
						String Cont_W_business_out_desc = "";
	
						KYC_Remediation.mLogger.debug("compnay_grid : countries_W_bus Table cell value : " + countries_W_bus);
	
						String[] countries_W_bus_split = countries_W_bus.split(",");
						for (int k = 0; k < countries_W_bus_split.length; k++) {
	
							String Cont_W_business_Qry = "select DISTINCT CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE where CM_CODE='" + countries_W_bus_split[k] + "'";
							List<List<String>> Cont_W_business_output = iform.getDataFromDB(Cont_W_business_Qry);
	
							KYC_Remediation.mLogger.debug("compnay_grid : Cont_W_business_out : " + Cont_W_business_output);
	
							if (!Cont_W_business_output.isEmpty()) {
								KYC_Remediation.mLogger.debug("Inside Cont_W_business_out: ");
								Cont_W_business_out_desc = Cont_W_business_output.get(0).get(0);
								final_tag_countires_W_business_Conducted += "<Demographic>" + Cont_W_business_out_desc + "</Demographic>";
								KYC_Remediation.mLogger.debug("final_tag_countires_W_business_Conducted: " + final_tag_countires_W_business_Conducted);
							} else {
								KYC_Remediation.mLogger.debug("Cont_W_business_out_desc is empty!!");
							}
						}
					}
				}
	
				//else if (emp_type.equalsIgnoreCase("Salaried")) {
					KYC_Remediation.mLogger.debug("compnay_grid: Salaried");
					industry_tag="<Industry>Employed Individual</Industry>";
					
//					String industry_query ="select description from ng_dao_RCC_Industry_master  WITH(NOLOCK) where code='"+ iform.getValue("industry_subsegment") + "'";
//					
//					KYC_Remediation.mLogger.debug(" RISK_SCORE_DETAILS industry_query: " + industry_query);
//					List<List<String>> output_industry_query = iform.getDataFromDB(industry_query);
//					KYC_Remediation.mLogger.debug("industry_query: " + output_industry_query);
//	
//					if (!output_industry_query.isEmpty())
//					{
//						KYC_Remediation.mLogger.debug("Inside RISK_SCORE_DETAILS output_industry_query: ");
//						industry = output_industry_query.get(0).get(0);
//						industry_tag += "<Industry>"+industry+"</Industry>";
//						KYC_Remediation.mLogger.debug("industry: " + industry);
//					}
//					else 
//					{
//						KYC_Remediation.mLogger.debug("industry is empty!!");
//					}
//					KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS : industry:" + industry);
					
					// salaried case : country of residence
	
					String Desc_Country_Residenece_query = "select DISTINCT CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE  WITH(NOLOCK) where CM_CODE='"
							+ Country_Residenece + "'";
					KYC_Remediation.mLogger.debug("Desc_Country_Residenece_query: " + Desc_Country_Residenece_query);
					List<List<String>> output_Desc_Country_Residenece_query = iform.getDataFromDB(Desc_Country_Residenece_query);
					KYC_Remediation.mLogger.debug("output_Desc_Country_Residenece_query: " + output_Desc_Country_Residenece_query);
	
					if (!output_Desc_Country_Residenece_query.isEmpty()) {
						KYC_Remediation.mLogger.debug("Inside output_Desc_Country_Residenece_query FOR DEMOGRAPHIC TAG: ");
						Country_Residenece_descptn = output_Desc_Country_Residenece_query.get(0).get(0);
						Country_Residenece_descptn = "<Demographic>" + Country_Residenece_descptn + "</Demographic>";
						KYC_Remediation.mLogger.debug("Country_Residenece_descptn_descptn: " + Country_Residenece_descptn);
					} else {
						KYC_Remediation.mLogger.debug("Country_Residenece_descptn is empty!!");
					}
	
					KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Country_Residenece_descptn:" + Country_Residenece_descptn);
	
				
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS:Industry: " + industry_tag);
	
				// replacing tags ->
	
				KYC_Remediation.mLogger.debug("sb.string : Risk_score: ");
	
				risk = risk.replace(">cif_id<", ">" + CIF + "<").replace(">Wi_number<", ">" + Wi_number + "<")
						.replace(">PEP<", ">" + PEP + "<").replace(">Full_name<", ">" + Full_name + "<")
						.replace(">emp_type<", ">" + emp_type + "<")
						.replace(">Nationality_tag<", ">" + Nationality_tag + "<")
						.replace(">industry_tag<", ">" + industry_tag + "<")
						.replace(">product_typ<", ">" + Product_type_descptn + "<")
						.replace(">product_curr<", ">" + product_curr + "<");
				// 19 feb change for demographics
				if (emp_type.equalsIgnoreCase("Salaried")) {
					risk = risk.replace(">Country_Residenece<", ">" + Country_Residenece_descptn + "<");
				} else if (emp_type.equalsIgnoreCase("Self employed")) {
					risk = risk.replace(">Country_Residenece<", ">" + final_tag_countires_W_business_Conducted + "<");
				}
				KYC_Remediation.mLogger.debug("Start RISK_SCORE_DETAILS:  Risk_score before :" + risk);*/
			}
			catch (Exception e) {
				KYC_Remediation.mLogger.debug("RISK_SCORE_DETAILS: Exception" + e.getMessage());
			}
			return risk;
		}
		
		private String getRisk_XMLIndividual(IFormReference iform) {
			
			String processInstanceID = getWorkitemName(iform);
			String middleWi[] = processInstanceID.split("-");
			processInstanceID = middleWi[1];
			
			String cif_ID = (String) iform.getValue("CIF_ID");
			String PEP = (String) iform.getValue("PEP");
			if("NOT PEP".equalsIgnoreCase(PEP)){
				PEP = "N";
			}
			else{
				PEP = "Y";
			}
			String Full_name = (String) iform.getValue("FirstName") + " " + iform.getValue("LastName");
			String emp_type = (String) iform.getValue("OfficeEmploymentType");
			
			String demographics = (String) iform.getValue("ResidenceCountry");
			String Desc_demographics = "select distinct CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE WITH(NOLOCK) where CM_CODE='"
					+ demographics + "'";
			KYC_Remediation.mLogger.debug("Desc_Country_Residenece_query: " + Desc_demographics);
			List<List<String>> output_Desc_demographics_query = iform.getDataFromDB(Desc_demographics);
			KYC_Remediation.mLogger.debug("output_Desc_Country_Residenece_query: " + output_Desc_demographics_query);

			if (!output_Desc_demographics_query.isEmpty()) {
				KYC_Remediation.mLogger.debug("Inside output_Nationality_query: ");
				demographics = output_Desc_demographics_query.get(0).get(0);
				KYC_Remediation.mLogger.debug("Product_type_descptn: " + demographics);
			} else {
				KYC_Remediation.mLogger.debug("Nationality_descptn is empty!!");
			}
			String demographicsTag = "\n"+"<Demographic>"+demographics+"</Demographic>"+"\n";
			
			int moneySentCountrysize = iform.getDataFromGrid("table12").size();
			KYC_Remediation.mLogger.debug("size of Country money sent to grid is--"+moneySentCountrysize);
			for (int i = 0;i<moneySentCountrysize;i++){
				String moneySent = iform.getTableCellValue("table12",i,0);
				if(!"".equalsIgnoreCase(moneySent)){
				moneySent = getCountryDesc(iform,moneySent);
				demographicsTag += "\n"+"<Demographic>"+moneySent+"</Demographic>"+"\n";
				}
			}
			
			int moneyReceivedCountrysize = iform.getDataFromGrid("table13").size();
			KYC_Remediation.mLogger.debug("size of Country money from grid is--"+moneyReceivedCountrysize);
			for (int i = 0;i<moneyReceivedCountrysize;i++){
				String moneyReceived = iform.getTableCellValue("table13",i,0);
				if(!"".equalsIgnoreCase(moneyReceived)){
				moneyReceived = getCountryDesc(iform,moneyReceived);
				demographicsTag += "\n"+"<Demographic>"+moneyReceived+"</Demographic>"+"\n";
				}
			}
			
			String Nationality = (String) iform.getValue("Nationality");
			String Desc_Nationality = "select distinct CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE WITH(NOLOCK) where CM_CODE='"
					+ Nationality + "'";
			KYC_Remediation.mLogger.debug("Desc_Country_Residenece_query: " + Desc_Nationality);
			List<List<String>> output_Nationality_query = iform.getDataFromDB(Desc_Nationality);
			KYC_Remediation.mLogger.debug("output_Desc_Country_Residenece_query: " + output_Nationality_query);

			if (!output_Nationality_query.isEmpty()) {
				KYC_Remediation.mLogger.debug("Inside output_Nationality_query: ");
				Nationality = output_Nationality_query.get(0).get(0);
				KYC_Remediation.mLogger.debug("Nationality_descptn: " + Nationality);
			} else {
				KYC_Remediation.mLogger.debug("Nationality_descptn is empty!!");
			}
			String nationalityTag = "\n"+"<Nationality>"+Nationality+"</Nationality>"+"\n";
			
			String additionalNationality = (String) iform.getValue("OtherNationality");
			if(!"".equalsIgnoreCase(additionalNationality)){
			additionalNationality = getCountryDesc(iform,additionalNationality);
			nationalityTag += "\n"+"<Nationality>"+additionalNationality+"</Nationality>"+"\n";
			}
		
			//String IndustrySubSegment = (String) iform.getValue("IndustrySubSegment");
			String industry_tag="";
			int indutryGridSize = iform.getDataFromGrid("IndustrySubSegmentGrid").size();
			KYC_Remediation.mLogger.debug("size of industry grid is--"+indutryGridSize);
			for (int i = 0;i<indutryGridSize;i++){
				String subSegment = iform.getTableCellValue("IndustrySubSegmentGrid",i,0);
				KYC_Remediation.mLogger.debug("subSegment--"+subSegment);
				if(!"".equalsIgnoreCase(subSegment)){
					industry_tag += "\n"+"<Industry>"+subSegment+"</Industry>"+"\n";
				}
			}
			
			String prodinfoTag = "";
			int size = iform.getDataFromGrid("table15").size();
			KYC_Remediation.mLogger.debug("size of product currency grid is--"+size);
			for (int i = 0;i<size;i++){
				String product_typ = iform.getTableCellValue("table15",i,0);
				KYC_Remediation.mLogger.debug("product_typ--"+product_typ);
				if(!"".equalsIgnoreCase(product_typ)){
				/*product_typ = getProductDesc(iform,product_typ);
				KYC_Remediation.mLogger.debug("product_typ--"+product_typ);*/
				String product_curr = iform.getTableCellValue("table15",i,1);
				KYC_Remediation.mLogger.debug("product_curr--"+product_curr);
				if(!"".equalsIgnoreCase(product_curr)){
				prodinfoTag = prodinfoTag+"\n"+"<ProductsInfo>"+"\n" + "<Product>"+product_typ+"</Product>" + "\n"+"<Currency>"+product_curr+"</Currency>"+"\n" + "</ProductsInfo>";
				KYC_Remediation.mLogger.debug("prodinfoTag--"+prodinfoTag);
				}
				}
			}
			
			String segment = (String) iform.getValue("Segment");
			String Sub_Segment = (String) iform.getValue("Sub_Segment");
			String customerCategory = (String) iform.getValue("CustomerCategory");
			return "<EE_EAI_MESSAGE>" + "\n" + "<EE_EAI_HEADER>" + "\n" + "<MsgFormat>RISK_SCORE_DETAILS</MsgFormat>"
					+ "\n" + "<MsgVersion>0001</MsgVersion>" + "\n" + "<RequestorChannelId>CAS</RequestorChannelId>"
					+ "\n" + "<RequestorUserId>RAKUSER</RequestorUserId>" + "\n"
					+ "<RequestorLanguage>E</RequestorLanguage>" + "\n"
					+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo>" + "\n" + "<ReturnCode>911</ReturnCode>"
					+ "\n" + "<ReturnDesc>Issuer Timed Out</ReturnDesc>" + "\n" + "<MessageId>123123453</MessageId>"
					+ "\n" + "<Extra1>REQ||SHELL.JOHN</Extra1>" + "\n"
					+ "<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2>" + "\n" + "</EE_EAI_HEADER>" + "\n"
					+ "<RiskScoreDetailsRequest>" + "\n" + "<RequestInfo>" + "\n"
					+ "<RequestType>Reference Id</RequestType>" + "\n" + "<RequestValue>"+processInstanceID+"</RequestValue>" + "\n"
					+ "</RequestInfo>" + "\n" + "<RequestInfo>" + "\n" + "<RequestType>CIF Id</RequestType>" + "\n"
					+ "<RequestValue>"+cif_ID+"</RequestValue>" + "\n" + "</RequestInfo>" + "\n"
					+ "<CustomerType>Individual</CustomerType>" + "\n"
					+ "<CustomerCategory>"+customerCategory+"</CustomerCategory>" + "\n"
					+ "<IsPoliticallyExposed>"+PEP+"</IsPoliticallyExposed>" + "\n"
					+ "<CustomerName>"+Full_name+"</CustomerName>" + "\n" + "<DSAId>BATDSA1</DSAId>" + "\n"
					+ "<RMCode>AISHSC</RMCode>" + "\n" + "<EmploymentType>"+emp_type+"</EmploymentType>" + "\n"
					+ "<Segment>"+segment+"</Segment>" + "\n" + "<SubSegment>"+Sub_Segment+"</SubSegment>" + "\n"
					+ "<Demographics>"+demographicsTag+"</Demographics>" + "\n"
					+ "<Nationalities>"+nationalityTag+"</Nationalities>" + "\n" + "<Industries>"+industry_tag+"</Industries>"
					+ prodinfoTag+ "\n"
					+ "</RiskScoreDetailsRequest>" + "\n" + "</EE_EAI_MESSAGE>" + "\n";
		}
		private String getRisk_XMLCorporate(IFormReference iform) {
			
			
			String processInstanceID = getWorkitemName(iform);
			String middleWi[] = processInstanceID.split("-");
			processInstanceID = middleWi[1];
			
			String cif_ID = (String) iform.getValue("CIF_ID");
			//String CustomerCategory =(String) iform.getValue("CustomerCategory");
			String PEP = (String) iform.getValue("PEP");
			if("NOT PEP".equalsIgnoreCase(PEP)){
				PEP = "N";
			}
			else{
				PEP = "Y";
			}
			String CustomerName = (String) iform.getValue("NameOfCompany");
			String demographics = "";
			int demographicssize = iform.getDataFromGrid("Top5Suppliers").size();
			KYC_Remediation.mLogger.debug("size of Country money from grid is--"+demographicssize);
			for (int i = 0;i<demographicssize;i++){
				String dealingWith = iform.getTableCellValue("Top5Suppliers",i,1);
				if(!"".equalsIgnoreCase(dealingWith))
				{
				dealingWith = getCountryDesc(iform,dealingWith);
				demographics += "\n"+"<Demographic>"+dealingWith+"</Demographic>"+"\n";
				}
			}
			
			String Nationality = (String) iform.getValue("EntityCountryOfIncorporation");
			String Desc_Nationality = "select distinct CD_DESC from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE WITH(NOLOCK) where CM_CODE='"
					+ Nationality + "'";
			KYC_Remediation.mLogger.debug("Desc_Country_Residenece_query: " + Desc_Nationality);
			List<List<String>> output_Nationality_query = iform.getDataFromDB(Desc_Nationality);
			KYC_Remediation.mLogger.debug("output_Desc_Country_Residenece_query: " + output_Nationality_query);

			if (!output_Nationality_query.isEmpty()) {
				KYC_Remediation.mLogger.debug("Inside output_Nationality_query: ");
				Nationality = output_Nationality_query.get(0).get(0);
				KYC_Remediation.mLogger.debug("Product_type_descptn: " + Nationality);
			} else {
				KYC_Remediation.mLogger.debug("Nationality_descptn is empty!!");
			}
			
			String industry =(String) iform.getValue("EntityIndustrySubSegment");
			
			String prodinfoTag = "";
			int size = iform.getDataFromGrid("table15").size();
			KYC_Remediation.mLogger.debug("size of product currency grid is--"+size);
			for (int i = 0;i<size;i++){
				String product_typ = iform.getTableCellValue("table15",i,0);
				//product_typ = getProductDesc(iform,product_typ);
				KYC_Remediation.mLogger.debug("product_typ--"+product_typ);
				if(!"".equalsIgnoreCase(product_typ)){
				String product_curr = iform.getTableCellValue("table15",i,1);
				KYC_Remediation.mLogger.debug("product_curr--"+product_curr);
				if(!"".equalsIgnoreCase(product_curr)){
				prodinfoTag = prodinfoTag+"\n"+"<ProductsInfo>"+"\n" + "<Product>"+product_typ+"</Product>" + "\n"+"<Currency>"+product_curr+"</Currency>"+"\n" + "</ProductsInfo>";
				KYC_Remediation.mLogger.debug("prodinfoTag--"+prodinfoTag);
				}
				}
			}
		//	String demographicsTag = "\n"+"<Demographic>"+demographics+"</Demographic>"+"\n";
			String nationalityTag = "\n"+"<Nationality>"+Nationality+"</Nationality>"+"\n";
			String industriesTag = "\n"+"<Industry>"+industry+"</Industry>"+"\n";
			String segment = (String) iform.getValue("Segment");
			String Sub_Segment = (String) iform.getValue("Sub_Segment");
			String customerCategory = (String) iform.getValue("CustomerCategory");
			return "<EE_EAI_MESSAGE>" + "\n" + "<EE_EAI_HEADER>" + "\n" + "<MsgFormat>RISK_SCORE_DETAILS</MsgFormat>"
					+ "\n" + "<MsgVersion>0001</MsgVersion>" + "\n" + "<RequestorChannelId>CAS</RequestorChannelId>"
					+ "\n" + "<RequestorUserId>RAKUSER</RequestorUserId>" + "\n"
					+ "<RequestorLanguage>E</RequestorLanguage>" + "\n"
					+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo>" + "\n" + "<ReturnCode>911</ReturnCode>"
					+ "\n" + "<ReturnDesc>Issuer Timed Out</ReturnDesc>" + "\n" + "<MessageId>123123453</MessageId>"
					+ "\n" + "<Extra1>REQ||SHELL.JOHN</Extra1>" + "\n"
					+ "<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2>" + "\n" + "</EE_EAI_HEADER>" + "\n"
					+ "<RiskScoreDetailsRequest>" + "\n" + "<RequestInfo>" + "\n"
					+ "<RequestType>Reference Id</RequestType>" + "\n" + "<RequestValue>"+processInstanceID+"</RequestValue>" + "\n"
					+ "</RequestInfo>" + "\n" + "<RequestInfo>" + "\n" + "<RequestType>CIF Id</RequestType>" + "\n"
					+ "<RequestValue>"+cif_ID+"</RequestValue>" + "\n" + "</RequestInfo>" + "\n"
					+ "<CustomerType>Corporate</CustomerType>" + "\n"
					+ "<CustomerCategory>"+customerCategory+"</CustomerCategory>" + "\n"
					+ "<IsPoliticallyExposed>N</IsPoliticallyExposed>" + "\n"
					+ "<CustomerName>"+CustomerName+"</CustomerName>" + "\n"
					+ "<Segment>"+segment+"</Segment>" + "\n" + "<SubSegment>"+Sub_Segment+"</SubSegment>" + "\n"
					+ "<Demographics>"+demographics+"</Demographics>" + "\n"
					+ "<Nationalities>"+nationalityTag+"</Nationalities>" + "\n" + "<Industries>"+industriesTag+"</Industries>"
					+ prodinfoTag + "\n"
					+ "</RiskScoreDetailsRequest>" + "\n" + "</EE_EAI_MESSAGE>" + "\n";
		}
	
	
	
	
		public static String maskXmlTags(List<List<String>> outputMQXML, String Tag) {
			Pattern p = Pattern.compile("(?<=" + Tag + ")([-\\s\\w]*)((?:[a-zA-Z0-9][-_\\s]*){0})");
			Matcher m = p.matcher((CharSequence) outputMQXML);
			StringBuffer maskedResult = new StringBuffer();
			while (m.find()) {
				String thisMask = m.group(1).replaceAll("[^-_\\s]", "*");
				m.appendReplacement(maskedResult, thisMask + "$2");
			}
			m.appendTail(maskedResult);
			return maskedResult.toString();
		}
	
		
		
		
	
		public static String getSessionId(IFormReference iform) {
			return ((iform).getObjGeneralData()).getM_strDMSSessionId();
		}
	
		public String getItemIndex(IFormReference iform) {
			return ((iform).getObjGeneralData()).getM_strFolderId();
		}
	
		public static String getWorkitemName(IFormReference iform) {
			return ((iform).getObjGeneralData()).getM_strProcessInstanceId();
		}
	
		public void setControlValue(String controlName, String controlValue, IFormReference iform) {
			iform.setValue(controlName, controlValue);
		}
	
		public static String getCabinetName(IFormReference iform) {
			return (String) iform.getCabinetName();
		}
	
		public static String getUserName(IFormReference iform) {
			return (String) iform.getUserName();
		}
	
		public static String getActivityName(IFormReference iform) {
			return (String) iform.getActivityName();
		}
	
		public String getControlValue(String controlName, IFormReference iform) {
			// return (String)EventHandler.iFormOBJECT.getControlValue(controlName);
			return (String) iform.getValue(controlName);
		}
	
	
		// ******************************************************
		// Description :Method to get current date
		// ******************************************************
		public String getCurrentDate(String outputFormat) {
			String current_date = "";
			try {
				java.util.Calendar dateCreated1 = java.util.Calendar.getInstance();
				java.text.DateFormat df2 = new java.text.SimpleDateFormat(outputFormat);
				current_date = df2.format(dateCreated1.getTime());
			} catch (Exception e) {
				System.out.println("Exception in getting Current date :" + e);
			}
			return current_date;
		}
	
		public String ExecuteQueryOnServer(String sInputXML, IFormReference iform) {
			try {
				KYC_Remediation.mLogger.debug("Server Ip :" + iform.getServerIp());
				KYC_Remediation.mLogger.debug("Server Port :" + iform.getServerPort());
				KYC_Remediation.mLogger.debug("Input XML :" + sInputXML);
	
				return NGEjbClient.getSharedInstance().makeCall(iform.getServerIp(), iform.getServerPort() + "",
						"WebSphere", sInputXML);
			} catch (Exception excp) {
				KYC_Remediation.mLogger.debug("Exception occured in executing API on server :\n" + excp);
				KYC_Remediation.printException(excp);
				return "Exception occured in executing API on server :\n" + excp;
			}
		}
	
		public String getTagValue(String xml, String tag) {
			try {
				Document doc = getDocument(xml);
				NodeList nodeList = doc.getElementsByTagName(tag);
				int length = nodeList.getLength();
				if (length > 0) {
					Node node = nodeList.item(0);
					if (node.getNodeType() == Node.ELEMENT_NODE) {
						NodeList childNodes = node.getChildNodes();
						String value = "";
						int count = childNodes.getLength();
						for (int i = 0; i < count; i++) {
							Node item = childNodes.item(i);
							if (item.getNodeType() == Node.TEXT_NODE) {
								value += item.getNodeValue();
							}
						}
						return value;
					} else if (node.getNodeType() == Node.TEXT_NODE) {
						return node.getNodeValue();
					}
				}
			} catch (Exception e) {
				KYC_Remediation.printException(e);
			}
			return "";
		}
	
		public String getTagValue(Node node, String tag) {
			NodeList nodeList = node.getChildNodes();
			int length = nodeList.getLength();
	
			for (int i = 0; i < length; ++i) {
				Node child = nodeList.item(i);
	
				if (child.getNodeType() == Node.ELEMENT_NODE && child.getNodeName().equalsIgnoreCase(tag)) {
					return child.getTextContent();
				}
			}
			return "";
		}
	
		public Document getDocument(String xml) throws ParserConfigurationException, SAXException, IOException {
			// Step 1: create a DocumentBuilderFactory
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			// Step 2: create a DocumentBuilder
			DocumentBuilder db = dbf.newDocumentBuilder();
			// Step 3: parse the input file to get a Document object
			Document doc = db.parse(new InputSource(new StringReader(xml)));
			return doc;
		}
	
		public NodeList getNodeListFromDocument(Document doc, String identifier) {
			NodeList records = doc.getElementsByTagName(identifier);
			return records;
		}
	
		public String generateResponseString(String SaveFormData, String SuccessOrError, String preAlertMessage,
				String alertMessageCode, String postAlertMessage, String call, String data) {
			return "{'SAVEFORMDATA':'" + SaveFormData + "'," + "'SUCCESSORERROR':'" + SuccessOrError + "',"
					+ "'PREALERTMESSAGE':'" + preAlertMessage + "'," + "'ALERTMESSAGECODE':'" + alertMessageCode + "',"
					+ "'POSTALERTMESSAGE':'" + postAlertMessage + "'," + "'CALL':'" + call + "'," + "'DATA':'" + data
					+ "'}";
		}
		
	
		
		
		public int readConfig() {
			Properties properties = null;
			try {
				properties = new Properties();
				properties.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigProps"
						+ File.separator + "Main_Config.properties")));
				KYC_Remediation.mLogger.debug("properties :" + properties);
				Enumeration<?> names = properties.propertyNames();
				KYC_Remediation.mLogger.debug("names :" + names);
	
				while (names.hasMoreElements()) {
					String name = (String) names.nextElement();
					CourtOrder_ConfigProperties.put(name, properties.getProperty(name));
				}
			} catch (Exception e) {
				System.out.println("Exception in Read INI: " + e.getMessage());
				KYC_Remediation.mLogger.error("Exception has occured while loading properties file " + e.getMessage());
				return -1;
			}
			return 0;
		}
		
		
		
		
		public static String getdateCurrentDateInSQLFormat()
		{
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:MM:ss");
			return simpleDateFormat.format(new Date());
		}
		
		
		
		public String createPDF(IFormReference iform,String template,String wi_name,String pdfName) throws FileNotFoundException, IOException, DocumentException
		{
			try
			{
				String pdfTemplatePath="";	
				String generatedPdfPath = "";
				String paramValue="";
				String Product_type_descptn = "";
				String industry="";
				Hashtable<String, String> hashtable = new Hashtable<String, String>();
				//Reading path from property file
				Properties properties = new Properties();
				properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "KYC_Remediation" + System.getProperty("file.separator")+ "KYC_Config.properties"));
				
				//Generating the pdf for RAK_Individual_form********************************************************************************************************** 	
				if(template.equalsIgnoreCase("Risk_Score")) 
				{
						KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \nInside Risk_Score ");
						String caseType = "";
						String caseTypeQuery = "Select CaseType from rb_kyc_rem_exttable where WINAME = '"+wi_name+"'";
						List<List<String>> caseTypeQuery_output = iform.getDataFromDB(caseTypeQuery);
						KYC_Remediation.mLogger.debug("caseTypeQuery_output : " + caseTypeQuery_output);
						if (!caseTypeQuery_output.isEmpty()) {
							KYC_Remediation.mLogger.debug("Inside caseTypeQuery_output: ");
							caseType = caseTypeQuery_output.get(0).get(0);
							KYC_Remediation.mLogger.debug("caseType: " + caseTypeQuery_output);
						}
						Map<String,String> columnvalues = new HashMap<String,String>(); 
						String Wi_number = getWorkitemName(iform);
						String middleWi[] = Wi_number.split("-");
						Wi_number = middleWi[1];
						if("Individual".equalsIgnoreCase(caseType))
						{
						String CIF = (String) iform.getValue("CIF_ID");
						String MiddleName = (String)iform.getValue("Middle_Name");
						String Full_name="";
						if("".equalsIgnoreCase(MiddleName) || MiddleName == null){
						 Full_name = (String) iform.getValue("FirstName") + " " + iform.getValue("LastName");
						}
						else{
							 Full_name = (String) iform.getValue("FirstName") + " "+MiddleName+" " + iform.getValue("LastName");
						}
						String emp_type = (String) iform.getValue("OfficeEmploymentType");
						
						String demographic = (String) iform.getValue("ResidenceCountry");
						demographic = getCountryDesc(iform,demographic);
						
						int moneySentCountrysize = iform.getDataFromGrid("table12").size();
						KYC_Remediation.mLogger.debug("size of Country money sent to grid is--"+moneySentCountrysize);
						for (int i = 0;i<moneySentCountrysize;i++){
							String moneySent = iform.getTableCellValue("table12",i,0);
							moneySent = getCountryDesc(iform,moneySent);
							demographic += ","+moneySent;
						}
						
						int moneyReceivedCountrysize = iform.getDataFromGrid("table13").size();
						KYC_Remediation.mLogger.debug("size of Country money from grid is--"+moneyReceivedCountrysize);
						for (int i = 0;i<moneyReceivedCountrysize;i++){
							String moneyReceived = iform.getTableCellValue("table13",i,0);
							moneyReceived = getCountryDesc(iform,moneyReceived);
							demographic += ","+moneyReceived;
						}
						//industry=(String) iform.getValue("IndustrySubSegment");
						
						int indutryGridSize = iform.getDataFromGrid("IndustrySubSegmentGrid").size();
						KYC_Remediation.mLogger.debug("size of industry grid is--"+indutryGridSize);
						for (int i = 0;i<indutryGridSize;i++){
							String subSegment = iform.getTableCellValue("IndustrySubSegmentGrid",i,0);
							KYC_Remediation.mLogger.debug("subSegment--"+subSegment);
							industry = industry+subSegment+",";
						}
						
						String Nationality = (String) iform.getValue("Nationality");
						Nationality = getCountryDesc(iform,Nationality);
						String additionalNationality = (String) iform.getValue("OtherNationality");
						if(!"".equalsIgnoreCase(additionalNationality)){
						additionalNationality = getCountryDesc(iform,additionalNationality);
						Nationality += ","+additionalNationality;
						}
						
						String acc_curr = "";
						int size = iform.getDataFromGrid("table15").size();
						KYC_Remediation.mLogger.debug("size of product currency grid is--"+size);
						for (int i = 0;i<size;i++){
							String product_typ = iform.getTableCellValue("table15",i,0);
							product_typ = getProductDesc(iform,product_typ);
							KYC_Remediation.mLogger.debug("product_typ--"+product_typ);
							String product_curr = iform.getTableCellValue("table15",i,1);
							KYC_Remediation.mLogger.debug("product_curr--"+product_curr);
							acc_curr += product_typ+"-"+product_curr+",";
							KYC_Remediation.mLogger.debug("prodinfoTag--"+acc_curr);
						}			
						String PEP = (String) iform.getValue("PEP");						
						KYC_Remediation.mLogger.debug("createPDF : Product_type_descptn:" + Product_type_descptn);
					
						String segment = (String) iform.getValue("Segment");
						KYC_Remediation.mLogger.debug("segment--"+segment);
						String Sub_Segment = (String) iform.getValue("Sub_Segment");
						KYC_Remediation.mLogger.debug("Sub_Segment--"+Sub_Segment);
						String customerCategory = (String) iform.getValue("CustomerCategory");
						KYC_Remediation.mLogger.debug("customerCategory--"+customerCategory);
						
						Date date = new Date();
						KYC_Remediation.mLogger.debug("date--"+date);
						/*DateTimeFormatter df =  DateTimeFormatter.ofPattern("dd/mm/yyyy");
						String today = df.format(date);
						KYC_Remediation.mLogger.debug("today--"+today);*/
						SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
						String today = sdf.format(date);
						KYC_Remediation.mLogger.debug("today--"+today);
						
						columnvalues.put("custType","Retail");
						columnvalues.put("CIF_NUMBER", CIF);
						columnvalues.put("P_FullName", Full_name);
						columnvalues.put("EMPLOYMENT_TYPE", emp_type);
						columnvalues.put("CUSTOMER_SEGMENT", segment);
						columnvalues.put("CUSTOMER_SUBSEGMENT", Sub_Segment);
						columnvalues.put("DEMOGRAPHIC",demographic);
						columnvalues.put("INDUSTRY_SUBSEGMENT", industry);
						columnvalues.put("NATIONALITY", Nationality);
						columnvalues.put("CUSTOMER_TYPE", "Individual");
						columnvalues.put("acctype_curr", acc_curr);
						columnvalues.put("oth_custtype", customerCategory);
						columnvalues.put("PEP", PEP);
						columnvalues.put("RISK_SCORE", getControlValue("RiskProfile",iform));
						columnvalues.put("Date", today);
						KYC_Remediation.mLogger.debug("columnvalues put in map--"+columnvalues);
						}
						else {
							String CIF = (String) iform.getValue("CIF_ID");
							String companyName = (String) iform.getValue("NameOfCompany");
							String demographic = "";
							int size = iform.getDataFromGrid("Top5Suppliers").size();
							for (int i = 0;i<size;i++){
							String demg = iform.getTableCellValue("Top5Suppliers",i,1);
							String desc = getCountryDesc(iform,demg);
							demographic += desc+","; 
							}
							industry =(String) iform.getValue("EntityIndustrySubSegment");
							String Nationality = (String) iform.getValue("EntityCountryOfIncorporation");
							Nationality = getCountryDesc(iform,Nationality);
							int size3 = iform.getDataFromGrid("table17").size();
							for (int i = 0;i<size3;i++){
								String nat = iform.getTableCellValue("table17",i,1);
								nat = getCountryDesc(iform,nat);
								Nationality += ","+nat; 
							}
							String acc_curr = "";
							int size2 = iform.getDataFromGrid("table15").size();
							KYC_Remediation.mLogger.debug("size of product currency grid is--"+size);
							for (int i = 0;i<size2;i++){
								String product_typ = iform.getTableCellValue("table15",i,0);
								product_typ = getProductDesc(iform,product_typ);
								KYC_Remediation.mLogger.debug("product_typ--"+product_typ);
								String product_curr = iform.getTableCellValue("table15",i,1);
								KYC_Remediation.mLogger.debug("product_curr--"+product_curr);
								acc_curr += product_typ+"-"+product_curr+",";
								KYC_Remediation.mLogger.debug("prodinfoTag--"+acc_curr);
							}							
							String PEP = (String) iform.getValue("PEP");						
							KYC_Remediation.mLogger.debug("createPDF : Product_type_descptn:" + Product_type_descptn);
							String segment = (String) iform.getValue("Segment");
							String Sub_Segment = (String) iform.getValue("Sub_Segment");
							String customerCategory = (String) iform.getValue("CustomerCategory");
							Date date = new Date();
							KYC_Remediation.mLogger.debug("date--"+date);
							/*DateTimeFormatter df =  DateTimeFormatter.ofPattern("dd/mm/yyyy");
							String today = df.format(date);
							KYC_Remediation.mLogger.debug("today--"+today);*/
							SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
							String today = sdf.format(date);
							KYC_Remediation.mLogger.debug("today--"+today);
							
							columnvalues.put("custType", "Corporate");
							columnvalues.put("CIF_NUMBER", CIF);
							columnvalues.put("P_FullName", companyName);
							columnvalues.put("EMPLOYMENT_TYPE","Not Applicable");
							columnvalues.put("CUSTOMER_SEGMENT", segment);
							columnvalues.put("CUSTOMER_SUBSEGMENT", Sub_Segment);
							columnvalues.put("DEMOGRAPHIC",demographic);
							columnvalues.put("INDUSTRY_SUBSEGMENT", industry);
							columnvalues.put("NATIONALITY", Nationality);
							columnvalues.put("CUSTOMER_TYPE", "Corporate");
							columnvalues.put("acctype_curr", acc_curr);
							columnvalues.put("oth_custtype", customerCategory);
							columnvalues.put("PEP","Not PEP");
							columnvalues.put("RISK_SCORE", getControlValue("RiskProfile",iform));
							columnvalues.put("Date",today);
						}
						if (!getControlValue("RiskProfile",iform).equalsIgnoreCase(""))
						{
							String rscore = getControlValue("RiskProfile",iform);
							if (!rscore.contains("."))
								rscore = rscore+".00";
							double riskscore = Float.parseFloat(rscore);
							String risktype = "";
							if (riskscore >= 1 && riskscore < 2 )
			                {
			                  risktype = "Low";
			                  KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncheck 11: ");
			                }
							else if(riskscore >= 2 && riskscore < 3)
			                {
			                  risktype = "Standard";
			                  KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncheck 22: ");
			                }
							else if(riskscore >= 3 && riskscore < 4)
			                {
			                  risktype = "Medium";
			                  KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncheck 33: ");
			                }
							else if(riskscore >= 4 && riskscore < 5)
			                {
			                  risktype = "High";
			                  KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncheck 44: ");
			                }
							else if(riskscore >= 5)
			                {
			                  risktype = "Elevated";
			                  KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncheck 55: ");
			                }
							columnvalues.put("final_risk_type", risktype);
						}
						KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncheck 2: ");
						//Enumeration<String> paramNames = request.getParameterNames();
						List<String> arrlist = new ArrayList<String>();
						arrlist.add("CIF_NUMBER");
						arrlist.add("EMPLOYMENT_TYPE");
						arrlist.add("CUSTOMER_TYPE");
						arrlist.add("oth_custtype");
						arrlist.add("CUSTOMER_SEGMENT");
						arrlist.add("CUSTOMER_SUBSEGMENT");
						arrlist.add("DEMOGRAPHIC");
						arrlist.add("INDUSTRY_SUBSEGMENT");
						arrlist.add("NATIONALITY");
						arrlist.add("PEP");
						arrlist.add("RISK_SCORE");
						arrlist.add("acctype_curr");
						arrlist.add("P_FullName");
						arrlist.add("final_risk_type");
						arrlist.add("custType");
						arrlist.add("Date");
						KYC_Remediation.mLogger.debug("arrlist: "+arrlist);
						//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncolumnvalues.toString() "+columnvalues.toString() + " : ");
						Enumeration<String> paramNames = Collections.enumeration(arrlist);
						KYC_Remediation.mLogger.debug("paramNames: "+paramNames);
						while(paramNames.hasMoreElements())
						{
							paramValue="";
							String paramName = (String)paramNames.nextElement();
							//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \nparamName "+paramName + " : ");
							//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncolumnvalues.toString() "+columnvalues.toString() + " : ");
							
							//Loading values from master table and mapping with pdf
							Set PDFSet = columnvalues.keySet();
							Iterator PDFIt = PDFSet.iterator();
							KYC_Remediation.mLogger.debug("PDFIt"+PDFIt);
							while(PDFIt.hasNext()) 
							{
								String HT_Key 	= (String)PDFIt.next();
								String HT_Value	= (String)columnvalues.get(HT_Key);
								//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", HT_Key : "+HT_Key + " HT_Value :"+HT_Value);
								if(paramName.toString().equals(HT_Key.toString()))
								{
									paramValue=HT_Value.toString();
									KYC_Remediation.mLogger.debug("HT_Value: "+HT_Value);
								}						
							}
							//********************************************************
							
							//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \nparamValue 1"+paramValue);
							if(paramValue.equals(""))
							{						
								paramValue = getControlValue(paramName,iform);
							}
							
							//paramValue = paramValue.replace("`~`","%");
							//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \nparamValue 2"+paramValue);
							hashtable.put(paramName, paramValue);
						}
						pdfTemplatePath = properties.getProperty("KYC_Remediation_RAK_RiskScore");
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
				generatedPdfPath = properties.getProperty("KYC_Remediation_PDF_PATH");//Get the loaction of the path where generated template will be saved
				generatedPdfPath += dynamicPdfName;
				generatedPdfPath = path + generatedPdfPath;//Complete path of generated PDF
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \n pdfTemplatePath :" + pdfTemplatePath);		
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \n after replace GeneratedPdfPath :" + generatedPdfPath);
				
				String pdfArabtype_Path=properties.getProperty("KYC_ARABTYPE_PATH");		
				pdfArabtype_Path = path + pdfArabtype_Path;//Getting complete path of the arabtype ttf
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \n pdfArabtype_Path :" + pdfArabtype_Path);
				
				PdfReader reader = new PdfReader(pdfTemplatePath);
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", Created reader object from template :");
				PdfStamper stamp = new PdfStamper(reader,new FileOutputStream(generatedPdfPath)); 	
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", Created stamper object from destination :");
				AcroFields form=stamp.getAcroFields();
				BaseFont unicode=BaseFont.createFont(pdfArabtype_Path,BaseFont.IDENTITY_H,BaseFont.EMBEDDED);		
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", Created arabtype font:");
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
					//KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", HT_Key : "+HT_Key + " HT_Value :"+HT_Value);
					form.setField(HT_Key,HT_Value);
				}
				stamp.setFormFlattening(true);
				stamp.close();
				
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \ncreatePDF : Inside service method : end");
				
				return "Successful in createPDF";
			}
			catch(Exception e)
			{
				KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", \nError in createPDF");	
				return "Error in createPDF";
			}
		}
		public String AttachDocumentWithWI(IFormReference iform, String pid, String pdfName) {
			
			String docxml = "";
			String documentindex = "";
			String doctype = "";
	
			try {
				KYC_Remediation.mLogger.debug("inside ODAddDocument");
				KYC_Remediation.mLogger.debug("Proess Instance Id: " + pid);
				KYC_Remediation.mLogger.debug("Integration call: " + pdfName);
	
				String sCabname = getCabinetName(iform);
				KYC_Remediation.mLogger.debug("sCabname" + sCabname);
				String sSessionId = getSessionId(iform);
				KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
				String sJtsIp = iform.getServerIp();
				int iJtsPort_int = Integer.parseInt(iform.getServerPort());
	
				String path = System.getProperty("user.dir");// for path
				KYC_Remediation.mLogger.debug(" \nAbsolute Path :" + path);
				String pdfTemplatePath = "";
				String generatedPdfPath = "";
	
				// Reading path from property file
				Properties properties = new Properties();
				properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")
						+ "CustomConfig" + System.getProperty("file.separator")
						+ "KYC_Remediation" +System.getProperty("file.separator") + "KYC_Config.properties"));
				KYC_Remediation.mLogger.debug("Template Path: " + pdfName);
	
				String dynamicPdfName = pid + pdfName + ".pdf";
				KYC_Remediation.mLogger.debug("\nGeneratedPdfPathCheck :" + generatedPdfPath);
				pdfTemplatePath = path + pdfTemplatePath;// Getting complete path of
															// the pdf tempplate
				generatedPdfPath = properties.getProperty("KYC_Remediation_PDF_PATH");
	
				KYC_Remediation.mLogger.debug("\nGeneratedPdfPathCheck :" + generatedPdfPath);
				generatedPdfPath = generatedPdfPath + System.getProperty("file.separator") + dynamicPdfName;
				KYC_Remediation.mLogger.debug("\nGeneratedPdfPath1 :" + generatedPdfPath);
				generatedPdfPath = path + generatedPdfPath;// Complete path of
															// generated PDF
				KYC_Remediation.mLogger.debug("\nGeneratedPdfPath :" + generatedPdfPath);
				KYC_Remediation.mLogger.debug("\npdfTemplatePath:" + pdfTemplatePath);
	
				docxml = SearchExistingDoc(iform, pid, pdfName, sCabname, sSessionId, sJtsIp, iJtsPort_int, generatedPdfPath);
				KYC_Remediation.mLogger.debug("Final Document Output: " + docxml);
				documentindex = getTagValue(docxml, "DocumentIndex");
	
				doctype = "new";
	
				KYC_Remediation.mLogger.debug(docxml + "~" + documentindex + "~" + doctype + "~" + dynamicPdfName);
				String Output = "0000~" + docxml + "~" + documentindex + "~" + doctype + "~" + dynamicPdfName;
				KYC_Remediation.mLogger.debug(" Output: " + Output);
				return Output;
	
			} catch (Exception e) {
				KYC_Remediation.mLogger.debug("Exception while adding the document: " + e);
				return "Exception while adding the document: " + e;
			}
	
		}
		
public String AttachKYC_FormWithWI(IFormReference iform, String pid, String pdfName) {
			
			String docxml = "";
			String documentindex = "";
			String doctype = "";
	
			try {
				KYC_Remediation.mLogger.debug("inside ODAddDocument");
				KYC_Remediation.mLogger.debug("Proess Instance Id: " + pid);
				KYC_Remediation.mLogger.debug("Integration call: " + pdfName);
	
				String sCabname = getCabinetName(iform);
				KYC_Remediation.mLogger.debug("sCabname" + sCabname);
				String sSessionId = getSessionId(iform);
				KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
				String sJtsIp = iform.getServerIp();
				int iJtsPort_int = Integer.parseInt(iform.getServerPort());
				//make this dynamic
				Properties properties = new Properties();
				properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")
						+ "CustomConfig" + System.getProperty("file.separator")
						+ "KYC_Remediation" +System.getProperty("file.separator") + "KYC_Config.properties"));
				String generatedPdfPath = properties.getProperty("KYC_Remediation_PDF_PATH");
				KYC_Remediation.mLogger.debug("Template Path: " + pdfName);
				
				//String generatedPdfPath = "/ibm/IBM/WebSphere/AppServer/profiles/AppSrv01/installedApps/ant1casapps01Node01Cell/KYC_Remediation_war.ear/KYC_Remediation.war/PDFTemplates/KYC_Templates";
	
	
				String dynamicPdfName = pid + pdfName + ".pdf";
				KYC_Remediation.mLogger.debug("dynamicPdfName :" + dynamicPdfName);
	
				generatedPdfPath =System.getProperty("user.dir")+ generatedPdfPath + System.getProperty("file.separator") + dynamicPdfName;
				KYC_Remediation.mLogger.debug("\nGeneratedPdfPath :" + generatedPdfPath);
				
	
				docxml = SearchExistingDoc(iform, pid, pdfName, sCabname, sSessionId, sJtsIp, iJtsPort_int, generatedPdfPath);
				KYC_Remediation.mLogger.debug("Final Document Output: " + docxml);
				documentindex = getTagValue(docxml, "DocumentIndex");
	
				doctype = "new";
	
				KYC_Remediation.mLogger.debug(docxml + "~" + documentindex + "~" + doctype + "~" + dynamicPdfName);
				String Output = "0000~" + docxml + "~" + documentindex + "~" + doctype + "~" + dynamicPdfName;
				KYC_Remediation.mLogger.debug(" Output: " + Output);
				return Output;
	
			} catch (Exception e) {
				KYC_Remediation.mLogger.debug("Exception while adding the document: " + e);
				return "Exception while adding the document: " + e;
			}
	
		}
		
		public String SearchExistingDoc(IFormReference iform, String pid, String FrmType, String sCabname,
				String sSessionId, String sJtsIp, int iJtsPort_int, String sFilepath) {
			try {
				String strFolderIndex = "";
				String strImageIndex = "";
	
				String strInputQry1 = "SELECT FOLDERINDEX,ImageVolumeIndex FROM PDBFOLDER WITH(NOLOCK) WHERE NAME='" + pid
						+ "'";
	
				short iJtsPort = (short) iJtsPort_int;
	
				KYC_Remediation.mLogger.debug("sInputXML: " + strInputQry1);
	
				List<List<String>> dataFromDB = iform.getDataFromDB(strInputQry1);
				for (List<String> tableFrmDB : dataFromDB) {
					strFolderIndex = tableFrmDB.get(0).trim();
					// strImageIndex = tableFrmDB.get(1).trim();
					strImageIndex = Integer.toString(iform.getObjGeneralData().getM_iVolId());
				}
				KYC_Remediation.mLogger.debug("strFolderIndex: " + strFolderIndex);
				KYC_Remediation.mLogger.debug("strImageIndex: " + strImageIndex);
	
				IFormXmlResponse xmlParserData = new IFormXmlResponse();
	
				if (!(strFolderIndex.equalsIgnoreCase("") && strImageIndex.equalsIgnoreCase(""))) {
	
					String strInputQry2 = "SELECT a.documentindex,b.ParentFolderIndex FROM PDBDOCUMENT A WITH (NOLOCK), PDBDOCUMENTCONTENT B WITH (NOLOCK)"
							+ "WHERE A.DOCUMENTINDEX= B.DOCUMENTINDEX AND A.NAME IN ('" + FrmType
							+ "','') AND B.PARENTFOLDERINDEX ='" + strFolderIndex + "'";
					KYC_Remediation.mLogger.debug("sInputXML: " + strInputQry2);
	
					List<List<String>> dataFromDB2 = iform.getDataFromDB(strInputQry2);
					KYC_Remediation.mLogger.debug("dataFromDB2: " + dataFromDB2);
	
					ArrayList<String> strdocumentindex = new ArrayList<String>(dataFromDB2.size());
					KYC_Remediation.mLogger.debug("strdocumentindex: " + strdocumentindex);
					ArrayList<String> strParentFolderIndex = new ArrayList<String>(dataFromDB2.size());
					KYC_Remediation.mLogger.debug("strParentFolderIndex: " + strParentFolderIndex);
	
					for (List<String> tableFrmDB2 : dataFromDB2) {
						KYC_Remediation.mLogger.debug("tableFrmDB2: " + tableFrmDB2);
						strdocumentindex.add(tableFrmDB2.get(0).trim());
						strParentFolderIndex.add(tableFrmDB2.get(1).trim());
					}
					KYC_Remediation.mLogger.debug("strdocumentindex: " + strdocumentindex);
					KYC_Remediation.mLogger.debug("strParentFolderIndex: " + strParentFolderIndex);
	
					KYC_Remediation.mLogger.debug("dataFromDB2.size();: " + dataFromDB2.size());
	
					KYC_Remediation.mLogger.debug("dataFromDB2.isEmpty: " + dataFromDB2.isEmpty());
					try {
						KYC_Remediation.mLogger.debug("Inside Adding PN File: ");
						KYC_Remediation.mLogger.debug("sFilepath: " + sFilepath);
						String filepath = sFilepath;
	
						File newfile = new File(filepath);
						String name = newfile.getName();
						String ext = "";
						String sMappedInputXml = "";
						if (name.contains(".")) {
							ext = name.substring(name.lastIndexOf("."), name.length());
						}
						JPISIsIndex ISINDEX = new JPISIsIndex();
						JPDBRecoverDocData JPISDEC = new JPDBRecoverDocData();
						String strDocumentPath = sFilepath;
						File processFile = null;
						long lLngFileSize = 0L;
						processFile = new File(strDocumentPath);
	
						lLngFileSize = processFile.length();
						String lstrDocFileSize = "";
						lstrDocFileSize = Long.toString(lLngFileSize);
	
						String createdbyappname = "";
						createdbyappname = ext.replaceFirst(".", "");
						Short volIdShort = Short.valueOf(strImageIndex);
	
						KYC_Remediation.mLogger.debug("lLngFileSize: --" + lLngFileSize);
						
						if (lLngFileSize != 0L) {
							KYC_Remediation.mLogger.debug("sJtsIp --" + sJtsIp + " iJtsPort-- " + iJtsPort + " sCabname--" + sCabname
											+ " volIdShort.shortValue() --" + volIdShort.shortValue() + " strDocumentPath--"
											+ strDocumentPath + " JPISDEC --" + JPISDEC + "  ISINDEX-- " + ISINDEX);
							CPISDocumentTxn.AddDocument_MT(null, sJtsIp, iJtsPort, sCabname, volIdShort.shortValue(),
									strDocumentPath, JPISDEC, "", ISINDEX);
	
						}
						KYC_Remediation.mLogger.debug("dataFromDB2.size(): --" + dataFromDB2.size());
						if (dataFromDB2.size() > 0) {
							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.0");
							Date date = new Date(System.currentTimeMillis());
							String strCurrDateTime = formatter.format(date);
							for (int i = 0; i < dataFromDB2.size(); i++) {
								KYC_Remediation.mLogger.debug("NGOChangeDocumentProperty_Input section");
								sMappedInputXml = "<?xml version=\"1.0\"?>" + "<NGOChangeDocumentProperty_Input>"
										+ "<Option>NGOChangeDocumentProperty</Option>" + "<CabinetName>" + sCabname
										+ "</CabinetName>" + "<UserDBId>" + sSessionId
										+ "</UserDBId><Document><DocumentIndex>" + strdocumentindex.get(i)
										+ "</DocumentIndex><NoOfPages>1</NoOfPages>" + "<DocumentName>" + FrmType
										+ "</DocumentName>" + "<AccessDateTime>" + strCurrDateTime + "</AccessDateTime>"
										+ "<ExpiryDateTime>2099-12-12 0:0:0.0</ExpiryDateTime>" + "<CreatedByAppName>"
										+ createdbyappname + "</CreatedByAppName>" + "<VersionFlag>Y</VersionFlag>"
										+ "<AccessType>S</AccessType>" + "<ISIndex>" + ISINDEX.m_nDocIndex + "#"
										+ ISINDEX.m_sVolumeId + "</ISIndex><TextISIndex>0#0#</TextISIndex>"
										+ "<DocumentType>N</DocumentType>" + "<DocumentSize>" + lstrDocFileSize
										+ "</DocumentSize><Comment>" + createdbyappname
										+ "</Comment><RetainAnnotation>N</RetainAnnotation></Document>"
										+ "</NGOChangeDocumentProperty_Input>";
							}
						} else {
	
							sMappedInputXml = "<?xml version=\"1.0\"?>" + "<NGOAddDocument_Input>"
									+ "<Option>NGOAddDocument</Option>" + "<CabinetName>" + sCabname + "</CabinetName>"
									+ "<UserDBId>" + sSessionId + "</UserDBId>" + "<GroupIndex>0</GroupIndex>"
									+ "<VersionFlag>N</VersionFlag>" + "<ParentFolderIndex>" + strFolderIndex
									+ "</ParentFolderIndex>" + "<DocumentName>" + FrmType + "</DocumentName>"
									+ "<CreatedByAppName>" + createdbyappname + "</CreatedByAppName>" + "<Comment>"
									+ FrmType + "</Comment>" + "<VolumeIndex>" + ISINDEX.m_sVolumeId + "</VolumeIndex>"
									+ "<FilePath>" + strDocumentPath + "</FilePath>" + "<ISIndex>" + ISINDEX.m_nDocIndex
									+ "#" + ISINDEX.m_sVolumeId + "</ISIndex>" + "<NoOfPages>1</NoOfPages>"
									+ "<DocumentType>N</DocumentType>" + "<DocumentSize>" + lstrDocFileSize
									+ "</DocumentSize>" + "</NGOAddDocument_Input>";
	
						}
						KYC_Remediation.mLogger.debug("Document Addition sInputXML: " + sMappedInputXml);
						// String sOutputXml =
						// WFCustomCallBroker.execute(sMappedInputXml, sJtsIp,
						// iJtsPort, 1);
						String sOutputXML = ExecuteQueryOnServer(sMappedInputXml, iform);
						xmlParserData.setXmlString((sOutputXML));
						KYC_Remediation.mLogger.debug("Document Addition sOutputXml: " + sOutputXML);
						String status_D = xmlParserData.getVal("Status");
						if (status_D.equalsIgnoreCase("0")) {
							// deleteLocalDocument(sFilepath);
							return sOutputXML;
						} else {
							return "Error in Document Addition";
						}
					}
					
					catch (JPISException e) {
						return "Error in Document Addition at Volume";
					}
					
					catch (Exception e) {
						return "Exception Occurred in Document Addition";
					}
	
				}
				return "Any Error occurred in Addition of Document";
			} catch (Exception e) {
				return "Exception Occurred in SearchDocument";
			}
		}
		
		public static String getAPUpdateIpXML(String tableName,String columnName,String strValues,String sWhere,String cabinetName,String sessionId)
		{
			if(strValues==null)
			{
				strValues = "''";
			}

			StringBuffer ipXMLBuffer=new StringBuffer();

			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<APUpdate_Input>\n");
			ipXMLBuffer.append("<Option>APUpdate</Option>");
			ipXMLBuffer.append("<TableName>");
			ipXMLBuffer.append(tableName);
			ipXMLBuffer.append("</TableName>\n");
			ipXMLBuffer.append("<ColName>");
			ipXMLBuffer.append(columnName);
			ipXMLBuffer.append("</ColName>\n");
			ipXMLBuffer.append("<Values>");
			ipXMLBuffer.append(strValues);
			ipXMLBuffer.append("</Values>\n");
			ipXMLBuffer.append("<WhereClause>");
			ipXMLBuffer.append(sWhere);
			ipXMLBuffer.append("</WhereClause>\n");
			ipXMLBuffer.append("<EngineName>");
			ipXMLBuffer.append(cabinetName);
			ipXMLBuffer.append("</EngineName>\n");
			ipXMLBuffer.append("<SessionId>");
			ipXMLBuffer.append(sessionId);
			ipXMLBuffer.append("</SessionId>\n");
			ipXMLBuffer.append("</APUpdate_Input>\n");

			return ipXMLBuffer.toString();
		}
		
		public static String apSelectWithColumnNames(String QueryString, String cabinetName, String sessionID)
		{
			StringBuffer ipXMLBuffer=new StringBuffer();

			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<APSelect_Input>\n");
			ipXMLBuffer.append("<Option>APSelectWithColumnNames</Option>\n");
			ipXMLBuffer.append("<Query>");
			ipXMLBuffer.append(QueryString);
			ipXMLBuffer.append("</Query>\n");
			ipXMLBuffer.append("<EngineName>");
			ipXMLBuffer.append(cabinetName);
			ipXMLBuffer.append("</EngineName>\n");
			ipXMLBuffer.append("<SessionId>");
			ipXMLBuffer.append(sessionID);
			ipXMLBuffer.append("</SessionId>\n");
			ipXMLBuffer.append("</APSelect_Input>");

			return ipXMLBuffer.toString();
		}
		
		public static String apInsert(String sCabName, String sSessionId, String colNames, String colValues, String tableName)
		{
			StringBuffer ipXMLBuffer=new StringBuffer();

			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<APInsertExtd_Input>\n");
			ipXMLBuffer.append("<Option>APInsert</Option>");
			ipXMLBuffer.append("<TableName>");
			ipXMLBuffer.append(tableName);
			ipXMLBuffer.append("</TableName>");
			ipXMLBuffer.append("<ColName>");
			ipXMLBuffer.append(colNames);
			ipXMLBuffer.append("</ColName>\n");
			ipXMLBuffer.append("<Values>");
			ipXMLBuffer.append(colValues);
			ipXMLBuffer.append("</Values>\n");
			ipXMLBuffer.append("<EngineName>");
			ipXMLBuffer.append(sCabName);
			ipXMLBuffer.append("</EngineName>\n");
			ipXMLBuffer.append("<SessionId>");
			ipXMLBuffer.append(sSessionId);
			ipXMLBuffer.append("</SessionId>\n");
			ipXMLBuffer.append("</APInsertExtd_Input>");

			return ipXMLBuffer.toString();
		}
		
		public static String getAPProcedureInputXML(String engineName,String sSessionId,String procName,String Params)
		{
			StringBuffer bfrInputXML = new StringBuffer();
			bfrInputXML.append("<?xml version=\"1.0\"?>\n");
			bfrInputXML.append("<APProcedure_WithDBO_Input>\n");
			bfrInputXML.append("<Option>APProcedure_WithDBO</Option>\n");
			bfrInputXML.append("<ProcName>");
			bfrInputXML.append(procName);
			bfrInputXML.append("</ProcName>");
			bfrInputXML.append("<Params>");
			bfrInputXML.append(Params);
			bfrInputXML.append("</Params>");
			bfrInputXML.append("<EngineName>");
			bfrInputXML.append(engineName);
			bfrInputXML.append("</EngineName>");
			bfrInputXML.append("<SessionId>");
			bfrInputXML.append(sSessionId);
			bfrInputXML.append("</SessionId>");
			bfrInputXML.append("</APProcedure_WithDBO_Input>");		
			return bfrInputXML.toString();
		}
		
		public String generateApplicationFrom(String pdfName, String processInstanceID, String sessionId, IFormReference iform)
				throws IOException, Exception {
					
					String caseType = (String)iform.getValue("CaseType");
					Map<String, String> ht = new HashMap<String,String>();
					String Output = "";
					KYC_Remediation.mLogger.debug("Inside the generate_template Method: ");
					try {
					
					Date d = new Date();
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					String CurrentDateTime = dateFormat.format(d);
					String[] splitDate = CurrentDateTime.split("-");
					String day = splitDate[2];
					String month = splitDate[1];
					String year = splitDate[0];
					
					SimpleDateFormat dateFormat1 = new SimpleDateFormat("dd-MM-yyyy");
					String wiCreatedDate = dateFormat1.format(d);
					
					if(caseType.equalsIgnoreCase("Individual")){
					String title = (String) iform.getValue("Title");
					String firstName = (String) iform.getValue("FirstName");//"Mirza";
					String secondName = (String) iform.getValue("MiddleName");//"Suhaib";
					String lastName = (String) iform.getValue("LastName");//"Beg";
					String Address = (String) iform.getValue("ResidenceAddress");//"Beg
					String Emirate = (String) iform.getValue("ResidenceEmirateCity");
					
					String Nationality = (String) iform.getValue("Nationality");//"Mirza";
					Nationality = getCountryDesc(iform,Nationality);
					String otherNationality = (String) iform.getValue("OtherNationality");//"Suhaib";
					otherNationality = getCountryDesc(iform,otherNationality);
					String residenceCountry = (String) iform.getValue("ResidenceCountry");//"Beg";
					residenceCountry = getCountryDesc(iform,residenceCountry);
					String PEP = (String) iform.getValue("PEP");//"Beg
					//String residenceAddress = (String) iform.getValue("ResidenceAddress");
					String flatVillaNo = (String) iform.getValue("ResidenceFlatVillaNo");//"Mirza";
					
					
					String OfficeEmploymentType = (String) iform.getValue("OfficeEmploymentType");//"Beg";
					String OfficeOccupation = (String) iform.getValue("OfficeOccupation");//"Beg
					String CountryOfIncorporation = (String) iform.getValue("CountryOfIncorporation");
					CountryOfIncorporation = getCountryDesc(iform,CountryOfIncorporation);
					String OfficeEmployerName = (String) iform.getValue("OfficeEmployerName");//"Mirza";
					String OfficeCityEmirate = (String) iform.getValue("OfficeCityEmirate");//"Suhaib";
					String ProfEmpHistoryHeldFlag = (String) iform.getValue("CustomerBackground_Personal");//"Beg";
					String CountryOfOperation = (String) iform.getValue("CountryOfOperation");//"Beg
					CountryOfOperation = getCountryDesc(iform,CountryOfOperation);
				//	String Emirate = (String) iform.getValue("ResidenceEmirateCity");
					
					
					String MonthlyIncome = (String) iform.getValue("MonthlyIncome");//"Beg";
					String PurposeOfAccount = (String) iform.getValue("PurposeOfAccount");//"Beg
					String SourceOfFunds = (String) iform.getValue("SourceOfFunds");
					String OtherSourceOfIncome = (String) iform.getValue("OtherSourceOfIncome");//"Mirza";
					String OtherIncome = (String) iform.getValue("OtherIncome");//"Suhaib";
					String EstimatedWealth = (String) iform.getValue("EstimatedWealth");//"Beg";
					String SourceOfWealth = (String) iform.getValue("SourceOfWealth");//"Beg
					String ListMoneySent1 = "";
					String ListMoneySent2 = "";
					String ListMoneySent3 = "";
					String ListMoneySent4 = "";
					for(int i=0;i<4;i++){
						if(i==0){
							ListMoneySent1 = iform.getTableCellValue("table12",i,0);
							ListMoneySent1 = getCountryDesc(iform,ListMoneySent1);
						KYC_Remediation.mLogger.debug("ListMoneySent1 :"+ListMoneySent1);
						}
						if(i==1){
							ListMoneySent2 = iform.getTableCellValue("table12",i,0);
							ListMoneySent2 = getCountryDesc(iform,ListMoneySent2);
							KYC_Remediation.mLogger.debug("ListMoneySent1 :"+ListMoneySent2);
							}
						if(i==2){
							ListMoneySent3 = iform.getTableCellValue("table12",i,0);
							ListMoneySent3 = getCountryDesc(iform,ListMoneySent3);
							KYC_Remediation.mLogger.debug("ListMoneySent3 :"+ListMoneySent3);
							}
						if(i==3){
							ListMoneySent4 = iform.getTableCellValue("table12",i,0);
							ListMoneySent4 = getCountryDesc(iform,ListMoneySent4);
							KYC_Remediation.mLogger.debug("ListMoneySent4 :"+ListMoneySent4);
							}
					}
					
					String ListMoneyReceived1 = "";
					String ListMoneyReceived2 = "";
					String ListMoneyReceived3 = "";
					String ListMoneyReceived4 = "";
					for(int i=0;i<4;i++){
						if(i==0){
							ListMoneyReceived1 = iform.getTableCellValue("table13",i,0);
							ListMoneyReceived1 = getCountryDesc(iform,ListMoneyReceived1);
						KYC_Remediation.mLogger.debug("ListMoneyReceived1 :"+ListMoneyReceived1);
						}
						if(i==1){
							ListMoneyReceived2 = iform.getTableCellValue("table13",i,0);
							ListMoneyReceived2 = getCountryDesc(iform,ListMoneyReceived2);
							KYC_Remediation.mLogger.debug("ListMoneyReceived2 :"+ListMoneyReceived2);
							}
						if(i==2){
							ListMoneyReceived3 = iform.getTableCellValue("table13",i,0);
							ListMoneyReceived3 = getCountryDesc(iform,ListMoneyReceived3);
							KYC_Remediation.mLogger.debug("ListMoneyReceived3 :"+ListMoneyReceived3);
							}
						if(i==3){
							ListMoneyReceived4 = iform.getTableCellValue("table13",i,0);
							ListMoneyReceived4 = getCountryDesc(iform,ListMoneyReceived4);
							KYC_Remediation.mLogger.debug("ListMoneyReceived4 :"+ListMoneyReceived4);
							}
					}
					
					/*String ListMoneySent = (String) iform.getValue("ListCountryMoneyToSent");//"Beg";
					ListMoneySent = getCountryDesc(iform,ListMoneySent);
					String ListMoneyReceived = (String) iform.getValue("ListCountryMoneyToReceived");//"Beg
					ListMoneyReceived = getCountryDesc(iform,ListMoneyReceived);*/
					
					String USpassport = (String) iform.getValue("USpassportHolder_GreencardHolder");//"Beg";
					String TIN = (String) iform.getValue("TIN_Field");//"Beg
					String PlaceOfBirthUSA = (String) iform.getValue("PlaceOfBirthUSA");
					String CurrentUSMailing = (String) iform.getValue("CurrentUSmailingOrResidenceAddress");//"Mirza";
					String CurrentUSTel = (String) iform.getValue("UStelephoneNumber");//"Suhaib";
					String StandingInstructionsUS = (String) iform.getValue("StandingInstructions");//"Beg";
					String EffectivePower = (String) iform.getValue("PowerOfAttorney");//"Beg
					String USholdMail = (String) iform.getValue("USholdMailAddress");
					String FormRequired = (String) iform.getValue("FormObtained");	

					ht.put("DD", day);
					ht.put("MM", month);
					ht.put("YYYY", year);
					ht.put("Title", title);
					ht.put("First_Name", firstName);
					ht.put("Middle_Name", secondName);
					ht.put("Last_Name", lastName);
					ht.put("Nationality", Nationality);
					ht.put("Additional_Nationality", otherNationality);
					ht.put("Country_Of_Residence", residenceCountry);
					ht.put("Politically_Exposed_Person", PEP);
					ht.put("Address", Address);
					ht.put("Villa_No", flatVillaNo);
					ht.put("Emirate_City", Emirate);
					ht.put("Country", residenceCountry);
					ht.put("Employment_Type", OfficeEmploymentType);
					ht.put("Occupation", OfficeOccupation);
//					ht.put("Others_Occupation", );				//in above code not extracting value from iform for this field
					ht.put("Country_Of_Employment", CountryOfIncorporation);
					ht.put("Employer_Business_Name", OfficeEmployerName);
					ht.put("City_Emirate", OfficeCityEmirate);
					ht.put("PreofssionalEmp_5years", ProfEmpHistoryHeldFlag);
					ht.put("Operation_Country", CountryOfOperation);
					ht.put("Monthly_Income", MonthlyIncome);
					ht.put("Account_Purpose", PurposeOfAccount);
//					ht.put("Other_Purpose", );					//in above code not extracting value from iform for this field
					ht.put("Source_Of_Funds", SourceOfFunds);
				//	ht.put("Other_SourceFund", );
					ht.put("Identified_Source_of_Income",OtherSourceOfIncome);	//in above code not extracting value from iform for this field
					ht.put("Other_Income_Amount", OtherIncome);
					ht.put("Estimated_Value_Wealth", EstimatedWealth);
					ht.put("Source_Of_Wealth", SourceOfWealth);
//					ht.put("Other_Source_of_Wealth", );			//in above code not extracting value from iform for this field
					ht.put("Expected_Income_Sent1", ListMoneySent1);
					ht.put("Expected_Income_Sent2", ListMoneySent2);
					ht.put("Expected_Income_Sent3", ListMoneySent3);
					ht.put("Expected_Income_Sent4", ListMoneySent4);
					ht.put("Expected_Income_Received1", ListMoneyReceived1);
					ht.put("Expected_Income_Received2", ListMoneyReceived2);
					ht.put("Expected_Income_Received3", ListMoneyReceived3);
					ht.put("Expected_Income_Received4", ListMoneyReceived4);
					ht.put("US_Passport",USpassport);
					ht.put("TIN",TIN);
					ht.put("Place_Of_Birth_USA",PlaceOfBirthUSA);
					ht.put("Current_US_Mailing",CurrentUSMailing);
					ht.put("Current_US_Telephone",CurrentUSTel);
					ht.put("Standing_Instructions_USA",StandingInstructionsUS);
					ht.put("Effective_Power",EffectivePower);
					ht.put("USA_Hold_Mail",USholdMail);
					ht.put("Form_Required",FormRequired);
					
					
					String otherPurpose = (String)iform.getValue("PurposeOthers");
					String otherSourceFund = (String)iform.getValue("Funds_Others");
					String otherWealth = (String)iform.getValue("WealthOthers");
					String otherOccupation = (String)iform.getValue("OccupationOthers");
					
					ht.put("Other_Purpose",otherPurpose);
					ht.put("Other_SourceFund",otherSourceFund);
					ht.put("Other_Source_Of_Wealth",otherWealth);
					ht.put("Others_Occupation",otherOccupation);
					
					Output = generatePDF(iform,ht,"KYC_Form");
					KYC_Remediation.mLogger.debug("status :"+Output);
					}
					
					else if(caseType.equalsIgnoreCase("Corporate")){
						
						String NameOfCompany = (String) iform.getValue("NameOfCompany");//"Beg";
						String DateOfBusinessEstablishment = (String) iform.getValue("DateOfBusinessEstablishment");//"Beg
						String LegalEntity = (String) iform.getValue("LegalEntity");
						String EntityTLNumber = (String) iform.getValue("EntityTLNumber");//"Mirza";
						String TradeLicenseDate = (String) iform.getValue("TradeLicenseDate");//"Suhaib";
						String TradeLicenseExpiryDate = (String) iform.getValue("TradeLicenseExpiryDate");//"Beg";
						String TLIssueAuthority = (String) iform.getValue("TLIssueAuthority");//"Beg
						
						String CompanyEmirateCity = (String) iform.getValue("CompanyEmirateCity");//"Beg";
						//CompanyEmirateCity=getEmirateDesc(iform,CompanyEmirateCity);
						//ListMoneySent = getCountryDesc(iform,ListMoneySent);
						String EntityCountryOfIncorporation = (String) iform.getValue("EntityCountryOfIncorporation");//"Beg
						EntityCountryOfIncorporation = getCountryDesc(iform,EntityCountryOfIncorporation);
						//ListMoneyReceived = getCountryDesc(iform,ListMoneyReceived);
						String LengthOfBusinessRelationship = (String) iform.getValue("LengthOfBusinessRelationship");//"Beg";
						String EntityHeadquarterAddress = (String) iform.getValue("EntityHeadquarterAddress");//"Beg
						String ListedInStockExchange = (String) iform.getValue("ListedInStockExchange");
						String CustomerWebsite = (String) iform.getValue("CustomerWebsite");//"Mirza";
						String Customer_Base = (String) iform.getValue("Customer_Base");//"Suhaib";
						String DownstreamServiceVASP = (String) iform.getValue("DownstreamServiceVASP");//"Beg";
						String HawalaServiceProvider = (String) iform.getValue("HawalaServiceProvider");//"Beg
						String VAT_RegistrationNo = (String) iform.getValue("VAT_RegistrationNo");
						String CorporateTax = (String) iform.getValue("CorporateTax");	
						String CompanyPreferredAddress = (String) iform.getValue("CompanyPreferredAddress");//"Beg
						String CompanyofficeShopNo = (String) iform.getValue("CompanyofficeShopNo");
						String CompanyEmirateCity1 = (String) iform.getValue("CompanyEmirateCity");//"Mirza";
						//CompanyEmirateCity1=getEmirateDesc(iform,CompanyEmirateCity1);
						String CountryOfHQ = (String) iform.getValue("CountryOfHQ");//"Suhaib";
						CountryOfHQ = getCountryDesc(iform,CountryOfHQ);
						String CompanyEmailID = (String) iform.getValue("CompanyEmailID");//"Beg";
						String CompanyMobileOffice = (String) iform.getValue("CompanyMobileOffice");//"Beg
						String RelationshipOfContactPersonWithCompany = (String) iform.getValue("RelationshipOfContactPersonWithCompany");
						String operationCountry1 = "";
						String operationCountry2 = "";
						String operationCountry3 = "";
						for(int i=0;i<3;i++){
							if(i==0){
							 operationCountry1 = iform.getTableCellValue("table10",i,0);
							 operationCountry1 = getCountryDesc(iform,operationCountry1);
							KYC_Remediation.mLogger.debug("operationCountry :"+operationCountry1);
							}
							if(i==1){
								 operationCountry2 = iform.getTableCellValue("table10",i,0);
								 operationCountry2 = getCountryDesc(iform,operationCountry2);
								KYC_Remediation.mLogger.debug("operationCountry :"+operationCountry2);
								}
							if(i==2){
								 operationCountry3 = iform.getTableCellValue("table10",i,0);
								 operationCountry3 = getCountryDesc(iform,operationCountry3);
								KYC_Remediation.mLogger.debug("operationCountry :"+operationCountry3);
								}
						}
						String AnnualTurnover = (String) iform.getValue("AnnualTurnover");
						if(!"".equalsIgnoreCase(AnnualTurnover)){
						AnnualTurnover = NumberFormat(iform,AnnualTurnover);
						}
						String ExpectedMonthlyCreditTurnover = (String) iform.getValue("ExpectedMonthlyCreditTurnover");
						if(!"".equalsIgnoreCase(ExpectedMonthlyCreditTurnover)){
						ExpectedMonthlyCreditTurnover = NumberFormat(iform,ExpectedMonthlyCreditTurnover);
						}
						String MonthlyCashCRturnover = (String) iform.getValue("MonthlyCashCRturnover");
						if(!"".equalsIgnoreCase(MonthlyCashCRturnover)){
						MonthlyCashCRturnover = NumberFormat(iform,MonthlyCashCRturnover);
						}
						String HighestCashCRtransaction = (String) iform.getValue("HighestCashCRtransaction");
						if(!"".equalsIgnoreCase(HighestCashCRtransaction)){
						HighestCashCRtransaction = NumberFormat(iform,HighestCashCRtransaction);
						}
						String HighestNonCashCrTransaction = (String) iform.getValue("HighestNonCashCrTransaction");
						if(!"".equalsIgnoreCase(HighestNonCashCrTransaction)){
						HighestNonCashCrTransaction = NumberFormat(iform,HighestNonCashCrTransaction);
						}
						String NoOfBranches = (String) iform.getValue("NoOfBranches");
						
					
						ht.put("DD", day);
						ht.put("MM", month);
						ht.put("YYYY", year);
						ht.put("Company_Name", NameOfCompany);
						ht.put("DO_BusinessEstablishment", DateOfBusinessEstablishment);
						ht.put("Constitution_Type", LegalEntity);
						ht.put("constitution", LegalEntity);
						ht.put("Trade_License_Number", EntityTLNumber);
						ht.put("TradeLicense_IssueDate", TradeLicenseDate);
						ht.put("TradeLicense_ExpiryDate", TradeLicenseExpiryDate);
						ht.put("Issuing_Authority", TLIssueAuthority);
						ht.put("issuingauth", TLIssueAuthority);
						ht.put("EmiraTe", CompanyEmirateCity);
						ht.put("City", CompanyEmirateCity);
						//String licensedBusinessActivity = (String)iform.getValue("EntityIndustrySubSegment");
						String licensedBusinessActivity1 = "";
						String licensedBusinessActivity2 = "";
						String licensedBusinessActivity3 = "";
						String licensedBusinessActivity4 = "";
						int LBAsize = iform.getDataFromGrid("table16").size();
						KYC_Remediation.mLogger.debug("LBAsize -- "+LBAsize);
						for(int i=0;i<LBAsize;i++){
							if(i==0){
								licensedBusinessActivity1 = iform.getTableCellValue("table16",i,0);
								KYC_Remediation.mLogger.debug("licensedBusinessActivity1 -- "+licensedBusinessActivity1);
							}
							if(i==1){
								licensedBusinessActivity2 = iform.getTableCellValue("table16",i,0);
								KYC_Remediation.mLogger.debug("licensedBusinessActivity2 -- "+licensedBusinessActivity2);
							}
							if(i==2){
								licensedBusinessActivity3 = iform.getTableCellValue("table16",i,0);
								KYC_Remediation.mLogger.debug("licensedBusinessActivity3 -- "+licensedBusinessActivity3);
							}
							if(i==3){
								licensedBusinessActivity4 = iform.getTableCellValue("table16",i,0);
								KYC_Remediation.mLogger.debug("licensedBusinessActivity4 -- "+licensedBusinessActivity4);
							}
						}
						ht.put("Licensed_BusinessActivity1",licensedBusinessActivity1);
						ht.put("Licensed_BusinessActivity2",licensedBusinessActivity2);
						ht.put("Licensed_BusinessActivity3",licensedBusinessActivity3);
						ht.put("Licensed_BusinessActivity4",licensedBusinessActivity4);
						ht.put("Country_Of_Incorporation", EntityCountryOfIncorporation);
						ht.put("CountryofIncorporation-ud", EntityCountryOfIncorporation);
						ht.put("LengthOf_BankingRelationship", LengthOfBusinessRelationship);
						ht.put("Entity_Headquarters", EntityHeadquarterAddress);
						
						
						ht.put("ListedIn_StockExchange", ListedInStockExchange);
						ht.put("Company_Website", CustomerWebsite);
						ht.put("Customer_Base", Customer_Base);
						ht.put("DoesCustomer_Downstream", DownstreamServiceVASP);
						ht.put("Authorized_Hawala", HawalaServiceProvider);
						ht.put("VAT_RegistrationNo", VAT_RegistrationNo);
						ht.put("TIN", CorporateTax);
						ht.put("CountriesOf_Operation1", operationCountry1);
						ht.put("CountriesOf_Operation2", operationCountry2);
						ht.put("CountriesOf_Operation3", operationCountry3);
						ht.put("NumaberOf_Branches", NoOfBranches);
						
						
						String Subsidiaries_Name1 = "";
						String Subsidiaries_Name2 = "";
						String Subsidiaries_Name3 = "";
						String Subsidiaries_Business1 = "";
						String Subsidiaries_Business2 = "";
						String Subsidiaries_Business3 = "";
						String Subsidiaries_CountryOf_Operation1 = "";
						String Subsidiaries_CountryOf_Operation2 = "";
						String Subsidiaries_CountryOf_Operation3 = "";
						
						int size = iform.getDataFromGrid("SubsidiaryCountryOfOperation").size();
						for(int i=0;i<size;i++){
							if(i==0){
								Subsidiaries_Name1 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,0);
								Subsidiaries_Business1 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,2);
								Subsidiaries_CountryOf_Operation1 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,1);
								Subsidiaries_CountryOf_Operation1 = getCountryDesc(iform,Subsidiaries_CountryOf_Operation1);
								}
								if(i==1){
									Subsidiaries_Name2 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,0);
									Subsidiaries_CountryOf_Operation2 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,1);
									Subsidiaries_CountryOf_Operation2 = getCountryDesc(iform,Subsidiaries_CountryOf_Operation2);
									Subsidiaries_Business2 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,2);
									}
								if(i==2){
									Subsidiaries_Name3 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,0);
									Subsidiaries_CountryOf_Operation3 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,1);
									Subsidiaries_CountryOf_Operation3 = getCountryDesc(iform,Subsidiaries_CountryOf_Operation3);
									Subsidiaries_Business3 = iform.getTableCellValue("SubsidiaryCountryOfOperation",i,2);
									}
							}
						
						ht.put("Subsidiaries_Name",Subsidiaries_Name1);
						ht.put("Subsidiaries_Business",Subsidiaries_Business1);
						ht.put("Subsidiaries_CountryOf_Operation",Subsidiaries_CountryOf_Operation1);
						ht.put("Subsidiaries_Name2",Subsidiaries_Name2);
						ht.put("Subsidiaries_Business2",Subsidiaries_Business2);
						ht.put("Subsidiaries_CountryOf_Operation2",Subsidiaries_CountryOf_Operation2);
						ht.put("Subsidiaries_Name3",Subsidiaries_Name3);
						ht.put("Subsidiaries_Business3",Subsidiaries_Business3);
						ht.put("Subsidiaries_CountryOf_Operation3",Subsidiaries_CountryOf_Operation3);
						
						ht.put("Preferred_Address", CompanyPreferredAddress);
						ht.put("Office_No", CompanyofficeShopNo);
						ht.put("Emirate", CompanyEmirateCity1);
						ht.put("City", CompanyEmirateCity1);
						ht.put("CountryOf_HQ", CountryOfHQ);
						ht.put("EmailId", CompanyEmailID);
						ht.put("Mobile_Office", CompanyMobileOffice);
						ht.put("Relationship_WithCompany", RelationshipOfContactPersonWithCompany);
						
						//business model
						
						ht.put("Annual_Turnover", AnnualTurnover);
						ht.put("Monthly_Business", ExpectedMonthlyCreditTurnover);
						ht.put("Percentage_Monthly_Business", MonthlyCashCRturnover);
						ht.put("HighestMonthly_CashTransaction", HighestCashCRtransaction);
						ht.put("HighestMonthly_NonCashTransaction", HighestNonCashCrTransaction);
						
						String SupplierName1 = "";
						String SupplierName2 = "";
						String SupplierName3 = "";
						String SupplierName4 = "";
						String SupplierName5 = "";
						for(int i=0;i<5;i++){
							if(i==0){
								SupplierName1 = iform.getTableCellValue("Top5Suppliers",i,0);
							KYC_Remediation.mLogger.debug("operationCountry :"+SupplierName1);
							}
							if(i==1){
								SupplierName2 = iform.getTableCellValue("Top5Suppliers",i,0);
								KYC_Remediation.mLogger.debug("SupplierName2 :"+SupplierName2);
								}
							if(i==2){
								SupplierName3 = iform.getTableCellValue("Top5Suppliers",i,0);
								KYC_Remediation.mLogger.debug("SupplierName3 :"+SupplierName3);
								}
							if(i==3){
								SupplierName4 = iform.getTableCellValue("Top5Suppliers",i,0);
								KYC_Remediation.mLogger.debug("SupplierName4 :"+SupplierName4);
								}
							if(i==4){
								SupplierName5 = iform.getTableCellValue("Top5Suppliers",i,0);
								KYC_Remediation.mLogger.debug("SupplierName5 :"+SupplierName5);
								}
						}
						
						ht.put("Top5Suppliers - UD", SupplierName1);
						ht.put("Top5Suppliers - UD2", SupplierName2);
						ht.put("Top5Suppliers - UD3", SupplierName3);
						ht.put("Top5Suppliers - UD4", SupplierName4);
						ht.put("Top5Suppliers - UD5", SupplierName5);
						
						String SupplierCountry = "";
						String SupplierCountry2 = "";
						String SupplierCountry3 = "";
						String SupplierCountry4 = "";
						String SupplierCountry5 = "";
						String percent1 = "";
						String percent2 = "";
						String percent3 = "";
						String percent4 = "";
						String percent5 = "";
						for(int i=0;i<5;i++){
							if(i==0){
								SupplierCountry = iform.getTableCellValue("Top5Suppliers",i,1);
								SupplierCountry = getCountryDesc(iform,SupplierCountry);
							KYC_Remediation.mLogger.debug("SupplierCountry :"+SupplierCountry);
							percent1 = iform.getTableCellValue("Top5Suppliers",i,2);
							}
							if(i==1){
								SupplierCountry2 = iform.getTableCellValue("Top5Suppliers",i,1);
								SupplierCountry2 = getCountryDesc(iform,SupplierCountry2);
								KYC_Remediation.mLogger.debug("SupplierCountry2 :"+SupplierCountry2);
								percent2 = iform.getTableCellValue("Top5Suppliers",i,2);
								}
							if(i==2){
								SupplierCountry3 = iform.getTableCellValue("Top5Suppliers",i,1);
								SupplierCountry3 = getCountryDesc(iform,SupplierCountry3);
								KYC_Remediation.mLogger.debug("SupplierCountry3 :"+SupplierCountry3);
								percent3 = iform.getTableCellValue("Top5Suppliers",i,2);
								}
							if(i==3){
								SupplierCountry4 = iform.getTableCellValue("Top5Suppliers",i,1);
								SupplierCountry4 = getCountryDesc(iform,SupplierCountry4);
								KYC_Remediation.mLogger.debug("SupplierCountry4 :"+SupplierCountry4);
								percent4 = iform.getTableCellValue("Top5Suppliers",i,2);
								}
							if(i==4){
								SupplierCountry5 = iform.getTableCellValue("Top5Suppliers",i,1);
								SupplierCountry5 = getCountryDesc(iform,SupplierCountry5);
								KYC_Remediation.mLogger.debug("SupplierName5 :"+SupplierCountry5);
								percent5 = iform.getTableCellValue("Top5Suppliers",i,2);
								}
						}
						
						ht.put("CountriesDealingWith-ud", SupplierCountry);
						ht.put("CountriesDealingWith-ud2", SupplierCountry2);
						ht.put("CountriesDealingWith-ud3", SupplierCountry3);
						ht.put("CountriesDealingWith-ud4", SupplierCountry4);
						ht.put("CountriesDealingWith-ud5", SupplierCountry5);
						
						ht.put("PercentofBusiness-ud",percent1);
						ht.put("PercentofBusiness-ud2",percent2);
						ht.put("PercentofBusiness-ud3",percent3);
						ht.put("PercentofBusiness-ud4",percent4);
						ht.put("PercentofBusiness-ud5",percent5);
						
						String BuyerName1 = "";
						String BuyerName2 = "";
						String BuyerName3 = "";
						String BuyerName4 = "";
						String BuyerName5 = "";
						
						String CountryBuying1 = "";
						String CountryBuying2 = "";
						String CountryBuying3 = "";
						String CountryBuying4 = "";
						String CountryBuying5 = "";
						
						String percentBuying1 = "";
						String percentBuying2 = "";
						String percentBuying3 = "";
						String percentBuying4 = "";
						String percentBuying5 = "";
						for(int i=0;i<5;i++){
							if(i==0){
								BuyerName1 = iform.getTableCellValue("Top5Buyers",i,0);
							KYC_Remediation.mLogger.debug("BuyerName1 :"+BuyerName1);
							CountryBuying1 = iform.getTableCellValue("Top5Buyers",i,1);
							CountryBuying1 = getCountryDesc(iform,CountryBuying1);
							percentBuying1 = iform.getTableCellValue("Top5Buyers",i,2);
							}
							if(i==1){
								BuyerName2 = iform.getTableCellValue("Top5Buyers",i,0);
								KYC_Remediation.mLogger.debug("BuyerName2 :"+BuyerName2);
								CountryBuying2 = iform.getTableCellValue("Top5Buyers",i,1);
								CountryBuying2 = getCountryDesc(iform,CountryBuying2);
								percentBuying2 = iform.getTableCellValue("Top5Buyers",i,2);
								}
							if(i==2){
								BuyerName3 = iform.getTableCellValue("Top5Buyers",i,0);
								KYC_Remediation.mLogger.debug("BuyerName3 :"+BuyerName3);
								CountryBuying3 = iform.getTableCellValue("Top5Buyers",i,1);
								CountryBuying3 = getCountryDesc(iform,CountryBuying3);
								percentBuying3 = iform.getTableCellValue("Top5Buyers",i,2);
								}
							if(i==3){
								BuyerName4 = iform.getTableCellValue("Top5Buyers",i,0);
								KYC_Remediation.mLogger.debug("BuyerName4 :"+BuyerName4);
								CountryBuying4 = iform.getTableCellValue("Top5Buyers",i,1);
								CountryBuying4 = getCountryDesc(iform,CountryBuying4);
								percentBuying4 = iform.getTableCellValue("Top5Buyers",i,2);
								}
							if(i==4){
								BuyerName5 = iform.getTableCellValue("Top5Buyers",i,0);
								KYC_Remediation.mLogger.debug("BuyerName5 :"+BuyerName5);
								CountryBuying5 = iform.getTableCellValue("Top5Buyers",i,1);
								CountryBuying5 = getCountryDesc(iform,CountryBuying5);
								percentBuying5 = iform.getTableCellValue("Top5Buyers",i,2);
								}
						}
						
						String nameOfBank1 = "";
						String nameOfBank2 = "";
						String nameOfBank3 = "";
						String nameOfBank4 = "";
						String Product1 = "";
						String Product2 = "";
						String Product3 = "";
						String Product4 = "";
						String RelationshipYears1 = "";
						String RelationshipYears2 = "";
						String RelationshipYears3 = "";
						String RelationshipYears4 = "";
						
						for(int i=0;i<5;i++){
							if(i==0){
								nameOfBank1 = iform.getTableCellValue("AccountInformation",i,0);
								Product1 = iform.getTableCellValue("AccountInformation",i,1);
								RelationshipYears1 = iform.getTableCellValue("AccountInformation",i,2);
							KYC_Remediation.mLogger.debug("nameOfBank1 :"+nameOfBank1);
							}
							if(i==1){
								nameOfBank2 = iform.getTableCellValue("AccountInformation",i,0);
								Product2 = iform.getTableCellValue("AccountInformation",i,1);
								RelationshipYears2 = iform.getTableCellValue("AccountInformation",i,2);
								KYC_Remediation.mLogger.debug("nameOfBank2 :"+nameOfBank2);
								}
							if(i==2){
								nameOfBank3 = iform.getTableCellValue("AccountInformation",i,0);
								Product3 = iform.getTableCellValue("AccountInformation",i,1);
								RelationshipYears3 = iform.getTableCellValue("AccountInformation",i,2);
								KYC_Remediation.mLogger.debug("nameOfBank3 :"+nameOfBank3);
								}
							if(i==3){
								nameOfBank4 = iform.getTableCellValue("AccountInformation",i,0);
								Product4 = iform.getTableCellValue("AccountInformation",i,1);
								RelationshipYears4 = iform.getTableCellValue("AccountInformation",i,2);
								KYC_Remediation.mLogger.debug("nameOfBank4 :"+nameOfBank4);
								}
							
						}
						
						ht.put("BankName1", nameOfBank1);
						ht.put("BankName2", nameOfBank2);
						ht.put("BankName3", nameOfBank3);
						ht.put("BankName4", nameOfBank4);
						ht.put("ProductType1", Product1);
						ht.put("ProductType2", Product2);
						ht.put("ProductType3", Product3);
						ht.put("ProductType4", Product4);
						ht.put("RelProductType1", RelationshipYears1);
						ht.put("RelProductType2", RelationshipYears2);
						ht.put("RelProductType3", RelationshipYears3);
						ht.put("relProductType4", RelationshipYears4);
						
						
						ht.put("Top5Buyer - UD", BuyerName1);
						ht.put("Top5Buyer - UD2", BuyerName2);
						ht.put("Top5Buyer - UD3", BuyerName3);
						ht.put("Top5Buyer - UD4", BuyerName4);
						ht.put("Top5Buyer - UD5", BuyerName5);
						
						ht.put("Countriesbuying-ud",CountryBuying1);
						ht.put("Countriesbuying-ud2",CountryBuying2);
						ht.put("Countriesbuying-ud3",CountryBuying3);
						ht.put("Countriesbuying-ud4",CountryBuying4);
						ht.put("Countriesbuying-ud5",CountryBuying5);
						
						ht.put("PercentofBuying-ud",percentBuying1);
						ht.put("PercentofBuying-ud2",percentBuying2);
						ht.put("PercentofBuying-ud3",percentBuying3);
						ht.put("PercentofBuying-ud4",percentBuying4);
						ht.put("PercentofBuying-ud5",percentBuying5);
						ht.put("RelationshipCompany-_Others","");


						
						String NoOfEmployees = (String) iform.getValue("NoOfEmployees");
						ht.put("NoOf_Employees", NoOfEmployees);
						
						String maintainRel = (String) iform.getValue("DoYouMaintainAccount");
						ht.put("DoYouMaintainRelationship", maintainRel);
						
						String entityOrganized = (String) iform.getValue("EntityOrganisedInUSA");
						String ActiveNFE = (String) iform.getValue("ActiveNFE");
						String Provide_ActiveNFE = (String) iform.getValue("RelatedEntity");
						String SecuritiesMarket = (String) iform.getValue("SecuritiesMarket");
						String Passive_NFE = (String) iform.getValue("PassiveNFE");
						String FinancialInstitution = (String) iform.getValue("FinancialInstitution");
						String GIIN = (String) iform.getValue("GIIN");
						if(GIIN.length()==16){
						String GIIN1 = GIIN.substring(0,6);
						String GIIN2 = GIIN.substring(6,11);
						String GIIN3 = GIIN.substring(11,13);
						String GIIN4 = GIIN.substring(13);
						ht.put("GIIN1",GIIN1);
						ht.put("GIIN2",GIIN2);
						ht.put("GIIN3",GIIN3);
						ht.put("GIIN4",GIIN4);
						}
						
						ht.put("EntityOrganized",entityOrganized);
						ht.put("Active_NFE",ActiveNFE);
						ht.put("Provide_ActiveNFE",SecuritiesMarket);
						ht.put("IfyouAreRelated",Provide_ActiveNFE);
						ht.put("Passive_NFE",Passive_NFE);
						ht.put("Financial_Institutions",FinancialInstitution);
	
						String NameofShareholder1 = "";
						String NameofShareholder2 = "";
						String NameofShareholder3 = "";
						String NameofShareholder4 = "";
						String NameofShareholder5 = "";
						String NameofShareholder6 = "";
						String NameofShareholder7 = "";
						String NameofShareholder8 = "";
						String POANationality1 = "";
						String POANationality2 = "";
						String POANationality3 = "";
						String POANationality4 = "";
						String POANationality5 = "";
						String POANationality6 = "";
						String POANationality7 = "";
						String POANationality8 = "";
						String POACountryResidence1 = "";
						String POACountryResidence2 = "";
						String POACountryResidence3 = "";
						String POACountryResidence4 = "";
						String POACountryResidence5 = "";
						String POACountryResidence6 = "";
						String POACountryResidence7 = "";
						String POACountryResidence8 = "";
						String DOB1 = "";
						String DOB2 = "";
						String DOB3 = "";
						String DOB4 = "";
						String DOB5 = "";
						String DOB6 = "";
						String DOB7 = "";
						String DOB8 = "";
						String ShareholdingPercentage1 = "";
						String ShareholdingPercentage2 = "";
						String ShareholdingPercentage3 = "";
						String ShareholdingPercentage4 = "";
						String ShareholdingPercentage5 = "";
						String ShareholdingPercentage6 = "";
						String ShareholdingPercentage7 = "";
						String ShareholdingPercentage8 = "";
						
						int shareSize = iform.getDataFromGrid("table17").size();
						for(int i=0;i<shareSize;i++){
							if(i==0)
							{
								NameofShareholder1 = iform.getTableCellValue("table17",i,0);
								POANationality1 = iform.getTableCellValue("table17",i,1);
								POANationality1 = getCountryDesc(iform,POANationality1);
								POACountryResidence1 = iform.getTableCellValue("table17",i,2);
								POACountryResidence1 = getCountryDesc(iform,POACountryResidence1);
								DOB1 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage1 = iform.getTableCellValue("table17",i,4);
								
							}
							if(i==1)
							{
								NameofShareholder2 = iform.getTableCellValue("table17",i,0);
								POANationality2 = iform.getTableCellValue("table17",i,1);
								POANationality2 = getCountryDesc(iform,POANationality2);
								POACountryResidence2 = iform.getTableCellValue("table17",i,2);
								POACountryResidence2 = getCountryDesc(iform,POACountryResidence2);
								DOB2 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage2 = iform.getTableCellValue("table17",i,4);
							}
							if(i==2)
							{
								NameofShareholder3 = iform.getTableCellValue("table17",i,0);
								POANationality3 = iform.getTableCellValue("table17",i,1);
								POANationality3 = getCountryDesc(iform,POANationality3);
								POACountryResidence3 = iform.getTableCellValue("table17",i,2);
								POACountryResidence3 = getCountryDesc(iform,POACountryResidence3);
								DOB3 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage3 = iform.getTableCellValue("table17",i,4);
							}
							if(i==3)
							{
								NameofShareholder4 = iform.getTableCellValue("table17",i,0);
								POANationality4 = iform.getTableCellValue("table17",i,1);
								POANationality4 = getCountryDesc(iform,POANationality4);
								POACountryResidence4 = iform.getTableCellValue("table17",i,2);
								POACountryResidence4 = getCountryDesc(iform,POACountryResidence4);
								DOB4 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage4 = iform.getTableCellValue("table17",i,4);
							}
							if(i==4)
							{
								NameofShareholder5 = iform.getTableCellValue("table17",i,0);
								POANationality5 = iform.getTableCellValue("table17",i,1);
								POANationality5 = getCountryDesc(iform,POANationality5);
								POACountryResidence5 = iform.getTableCellValue("table17",i,2);
								POACountryResidence5 = getCountryDesc(iform,POACountryResidence5);
								DOB5 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage5 = iform.getTableCellValue("table17",i,4);
							}
							if(i==5)
							{
								NameofShareholder6 = iform.getTableCellValue("table17",i,0);
								POANationality6 = iform.getTableCellValue("table17",i,1);
								POANationality6 = getCountryDesc(iform,POANationality6);
								POACountryResidence6 = iform.getTableCellValue("table17",i,2);
								POACountryResidence6 = getCountryDesc(iform,POACountryResidence6);
								DOB6 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage6 = iform.getTableCellValue("table17",i,4);
							}
							if(i==6)
							{
								NameofShareholder7 = iform.getTableCellValue("table17",i,0);
								POANationality7 = iform.getTableCellValue("table17",i,1);
								POANationality7 = getCountryDesc(iform,POANationality7);
								POACountryResidence7 = iform.getTableCellValue("table17",i,2);
								POACountryResidence7 = getCountryDesc(iform,POACountryResidence7);
								DOB7 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage7 = iform.getTableCellValue("table17",i,4);
							}
							if(i==7)
							{
								NameofShareholder8 = iform.getTableCellValue("table17",i,0);
								POANationality8 = iform.getTableCellValue("table17",i,1);
								POANationality8 = getCountryDesc(iform,POANationality8);
								POACountryResidence8 = iform.getTableCellValue("table17",i,2);
								POACountryResidence8 = getCountryDesc(iform,POACountryResidence8);
								DOB8 = iform.getTableCellValue("table17",i,3);
								ShareholdingPercentage8 = iform.getTableCellValue("table17",i,4);
							}
						}
						ht.put("NameofShareholder - UD1",NameofShareholder1);
						ht.put("NameofShareholder - UD2",NameofShareholder2);
						ht.put("NameofShareholder - UD3",NameofShareholder3);
						ht.put("NameofShareholder - UD4",NameofShareholder4);
						ht.put("NameofShareholder - UD5",NameofShareholder5);
						ht.put("NameofShareholder - UD6",NameofShareholder6);
						ht.put("NameofShareholder - UD7",NameofShareholder7);
						ht.put("NameofShareholder - UD8",NameofShareholder8);
						
						ht.put("POANationality-ud1",POANationality1);
						ht.put("POANationality-ud2",POANationality2);
						ht.put("POANationality-ud3",POANationality3);
						ht.put("POANationality-ud4",POANationality4);
						ht.put("POANationality-ud5",POANationality5);
						ht.put("POANationality-ud6",POANationality6);
						ht.put("POANationality-ud7",POANationality7);
						ht.put("POANationality-ud8",POANationality8);
						
						ht.put("POACountryResidence-ud1",POACountryResidence1);
						ht.put("POACountryResidence-ud2",POACountryResidence2);
						ht.put("POACountryResidence-ud3",POACountryResidence3);
						ht.put("POACountryResidence-ud4",POACountryResidence4);
						ht.put("POACountryResidence-ud5",POACountryResidence5);
						ht.put("POACountryResidence-ud6",POACountryResidence6);
						ht.put("POACountryResidence-ud7",POACountryResidence7);
						ht.put("POACountryResidence-ud8",POACountryResidence8);
						
						ht.put("DOBIncorporation-ud1_af_date",DOB1);
						ht.put("DOBIncorporation-ud2_af_date",DOB2);
						ht.put("DOBIncorporation-ud3_af_date",DOB3);
						ht.put("DOBIncorporation-ud4_af_date",DOB4);
						ht.put("DOBIncorporation-ud5_af_date",DOB5);
						ht.put("DOBIncorporation-ud6_af_date",DOB6);
						ht.put("DOBIncorporation-ud7_af_date",DOB7);
						ht.put("DOBIncorporation-ud8_af_date",DOB8);
						
						ht.put("ShareholdingPercentage - UD1",ShareholdingPercentage1);
						ht.put("ShareholdingPercentage - UD2",ShareholdingPercentage2);
						ht.put("ShareholdingPercentage - UD3",ShareholdingPercentage3);
						ht.put("ShareholdingPercentage - UD4",ShareholdingPercentage4);
						ht.put("ShareholdingPercentage - UD5",ShareholdingPercentage5);
						ht.put("ShareholdingPercentage - UD6",ShareholdingPercentage6);
						ht.put("ShareholdingPercentage - UD7",ShareholdingPercentage7);
						ht.put("ShareholdingPercentage - UD8",ShareholdingPercentage8);
						
						String SMS = (String) iform.getValue("SMS");
						String Telephone = (String) iform.getValue("Telephone");
						String Email = (String) iform.getValue("Email");
						ht.put("sms",SMS);
						ht.put("Telephone",Telephone);
						ht.put("Email",Email);
					Output = generatePDF(iform,ht,"KYC_Form_Corporate");
					KYC_Remediation.mLogger.debug("status :"+Output);
					}
					else if("RelatedParty".equalsIgnoreCase(caseType)){
						
						String title = (String) iform.getValue("OwnerTitle");
						String name = (String) iform.getValue("OwnerName");
						String gender = (String) iform.getValue("OwnerGender");
						String nationality = (String) iform.getValue("OwnerNationality");
						nationality = getCountryDesc(iform,nationality);
						String dob = (String) iform.getValue("OwnerDOB");
						String country = (String) iform.getValue("OwnerCountryOfBirth");
						country = getCountryDesc(iform,country);
						String placeOFBirth = (String) iform.getValue("OwnerPlaceOfBirth");
						String ownershipPercentage = (String) iform.getValue("OwnerPercent");
						String PassportNo = (String) iform.getValue("OwnerPassportNo");
						String PassportIssuedate = (String) iform.getValue("OwnerPassportIssueDate");
						String PassportExpiryDate = (String) iform.getValue("OwnerPassportExpiryDate");
						String emiratesID = (String) iform.getValue("OwnerEmiratesID");
						String emiratesIDexpiryDate = (String) iform.getValue("OwnerEmiratesIDExpiryDate");
						String ResidentCountry = (String) iform.getValue("OwnerResidentCountry");
						ResidentCountry = getCountryDesc(iform,ResidentCountry);
						//String additionalNationality = (String) iform.getValue("OwnerAdditionalNationality");
						//additionalNationality = getCountryDesc(iform,additionalNationality);
						String ResidentialAddress = (String) iform.getValue("OwnerResidentialAddress");
						String valueOfWealth = (String) iform.getValue("OwnerEstimatedWealth");
						String RelationshipType = (String) iform.getValue("OwnerRelationshipType");
						String additionalNationality1 = "";
						String additionalNationality2 = "";
						String additionalNationality3 = "";
						int size = iform.getDataFromGrid("AdditionalNationality").size();
						for(int i=0;i<size;i++){
							if(i==0){
								additionalNationality1 = iform.getTableCellValue("AdditionalNationality", i, 0);
								additionalNationality1 = getCountryDesc(iform,additionalNationality1);
							}
							if(i==1){
								additionalNationality2 = iform.getTableCellValue("AdditionalNationality", i, 0);
								additionalNationality2 = getCountryDesc(iform,additionalNationality2);
							}
							if(i==2){
								additionalNationality3 = iform.getTableCellValue("AdditionalNationality", i, 0);
								additionalNationality3 = getCountryDesc(iform,additionalNationality3);
							}
						}
						
						
						ht.put("DD", day);
						ht.put("MM", month);
						ht.put("YYYY", year);
						ht.put("Title", title);
						ht.put("Full_Name", name);
						ht.put("Gender", gender);
						ht.put("Nationality", nationality);
						ht.put("DOB_DOI", dob);
						ht.put("CountryOf_Birth", country);
						ht.put("PlaceOf_Birth", placeOFBirth);
						ht.put("Ownership_Percentage", ownershipPercentage);
						ht.put("PassportNo_TradeLicNo", PassportNo);
						ht.put("PassportIssueDate_TLIssueDate", PassportIssuedate);
						ht.put("PassportIExpiryDate_TLExpiryDate", PassportExpiryDate);
						ht.put("Emirates_IDNumber", emiratesID);
						ht.put("EmiratesID_ExpiryDate", emiratesIDexpiryDate);
						ht.put("Resident_Country", ResidentCountry);
						ht.put("Additional_Nationality1", additionalNationality1);
						ht.put("Additional_Nationality2", additionalNationality2);
						ht.put("Additional_Nationality3", additionalNationality3);
						ht.put("Residential_Address", ResidentialAddress);
						ht.put("NetWorth", valueOfWealth);
						ht.put("Relationship_Type", RelationshipType);
						
						String PlaceOfBirthUSA = (String) iform.getValue("PlaceOfBirthUSA");
						String TIN = (String) iform.getValue("TIN_Field");
						String USA_Passport = (String) iform.getValue("USpassportHolder_GreencardHolder");
						/*String USA_TIN2 = (String) iform.getValue("OwnerEmiratesIDExpiryDate");
						String IsYour_PlaceOfBirthUSA = (String) iform.getValue("OwnerResidentCountry");*/
						String Current_USMailing = (String) iform.getValue("CurrentUSmailingOrResidenceAddress");
						String Current_USTel = (String) iform.getValue("UStelephoneNumber");
						String Standing_InstructionsUS = (String) iform.getValue("StandingInstructions");
						String Effective_Power = (String) iform.getValue("PowerOfAttorney");
						String US_HoldMail = (String) iform.getValue("USholdMailAddress");
						//String Others_Rel = (String) iform.getValue("OwnerRelationshipType");
						
						ht.put("PlaceOfBirthUSA", PlaceOfBirthUSA);
						ht.put("TIN", TIN);
						ht.put("USA_Passport", USA_Passport);
						ht.put("USA_TIN2", TIN);
						ht.put("IsYour_PlaceOfBirthUSA", PlaceOfBirthUSA);
						ht.put("Current_USMailing", Current_USMailing);
						ht.put("Current_USTel", Current_USTel);
						ht.put("Standing_InstructionsUS", Standing_InstructionsUS);
						ht.put("Effective_Power", Effective_Power);
						ht.put("US_HoldMail", US_HoldMail);
						ht.put("Others_Rel", "");
						
						
			
						Output = generatePDF(iform,ht,"KYC_Form_RP");
						KYC_Remediation.mLogger.debug("status :"+Output);	
					}
				}
					catch (Exception e){
						KYC_Remediation.mLogger.debug("Exception: "+e.getMessage());
					}
				return Output;
				}
		
		
		public String generatePDF(IFormReference iform,Map<String, String> ht,String pdfName)
		{
			
			//Reading path from property file
			Properties properties = new Properties();
			try {
				properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "KYC_Remediation" + System.getProperty("file.separator")+ "KYC_Config.properties"));
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			String pdfTemplatePath = properties.getProperty("KYC_Remediation_PDF_PATH");
			KYC_Remediation.mLogger.debug("createPDF : createNewPDF for KYC_Remediation_PDF_PATH "+pdfTemplatePath);
			
			KYC_Remediation.mLogger.debug("createPDF : createNewPDF : start :");
	        KYC_Remediation.mLogger.debug("createPDF : createNewPDF : ht.size() :" + ht.size());
			
	        try {
	        	//String KYCFormPath = "/ibm/IBM/WebSphere/AppServer/profiles/AppSrv01/installedApps/ant1casapps01Node01Cell/KYC_Remediation_war.ear/KYC_Remediation.war/PDFTemplates/KYC_Templates";
	        	/*String KYCFormPath = System.getProperty("user.dir") + System.getProperty("file.separator") + "installedApps"
						+ System.getProperty("file.separator") + "ant1casapps01Node01Cell" + System.getProperty("file.separator") + "installedApps"
						+ System.getProperty("file.separator") + "KYC_Remediation_war.ear" 
						+ System.getProperty("file.separator") + "KYC_Remediation.war"  + System.getProperty("file.separator") + "PDFTemplates"
						+ System.getProperty("file.separator") + "KYC_Templates";*/
	        	
	        	String KYCFormPath = System.getProperty("user.dir") + System.getProperty("file.separator") + pdfTemplatePath;
	        	KYC_Remediation.mLogger.debug("KYC Form Path: " + KYCFormPath);
						
				String sourceName = KYCFormPath  + pdfName + ".pdf";
				String destPath = KYCFormPath  + ((iform).getObjGeneralData()).getM_strProcessInstanceId()+ pdfName + ".pdf";
				
	            PdfReader reader = new PdfReader(sourceName);
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : Created reader object from source template pdf:");

	            PdfStamper stamp = new PdfStamper(reader, new FileOutputStream(destPath));
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : Created stamper object in destination pdf:");

	            AcroFields form = stamp.getAcroFields();
	           
	            
	            //./DOA_Generated_Documents/SinglePagerGeneration/Templates/arabtype.ttf
	            BaseFont unicode = BaseFont.createFont(KYCFormPath+File.separator+"arabtype.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : Created arabtype font:");

	            ArrayList<BaseFont> al = new ArrayList<BaseFont>();
	            al.add(unicode);

	            form.setSubstitutionFonts(al);

	            PdfWriter p = stamp.getWriter();
	            p.setRunDirection(p.RUN_DIRECTION_RTL);
				
	            BaseFont bf1 = BaseFont.createFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, BaseFont.EMBEDDED);
	            form.addSubstitutionFont(bf1);
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF :  Created writer, set font times roman :");
	            
	            Set<String> PDFSet = ht.keySet();
	            Iterator<String> PDFIt = PDFSet.iterator();
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : Replacing values from XMLMap:");
				
	            while (PDFIt.hasNext()) {
	                String HT_Key = (String) PDFIt.next();
	                String HT_Value = (String) ht.get(HT_Key);
	                form.setField(HT_Key, HT_Value);
	               
	                if(!(HT_Key.contains("Top5Suppliers") || HT_Key.contains("CountriesDealingWith") || HT_Key.contains("Top5Buyer") || HT_Key.contains("Countriesbuying") || HT_Key.contains("PercentofBusiness") || HT_Key.contains("PercentofBuying")
	                		|| HT_Key.contains("ShareholdingPercentage") || HT_Key.contains("DOBIncorporation") || HT_Key.contains("POANationality") || HT_Key.contains("NameofShareholder") || HT_Key.contains("POACountryResidence"))){
	                form.setFieldProperty(HT_Key, "setfflags", PdfFormField.FF_READ_ONLY, null); 
	                }
	            }

	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : Values replaced from XMLMap:");
	            stamp.setFormFlattening(false);
				
	            stamp.close();
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : Stamper closed:");
	            return "Success";

	        } 
	        catch (Exception ex) 
	        {
	            KYC_Remediation.mLogger.debug("createPDF : createNewPDF : ex.getMessage() : 2 :" + ex.getMessage());
	            return "Error";
	        }
		}
		
		
		public String NumberFormat(IFormReference iform,String Num){
			long number = Long.parseLong(Num);
			DecimalFormat formatter = new DecimalFormat("#,###");
			String formattedNumber = formatter.format(number);
			return formattedNumber;
		}
		
		public String getCountryDesc(IFormReference iform,String NationalityCode){
			String Desc = "";
			String countryDescquery = "Select Distinct CD_Desc from NG_MASTER_KYC_REM_COUNTRY_OF_RESIDENCE where CM_Code = '"+NationalityCode+"'";
			List<List<String>> countryDesc = iform.getDataFromDB(countryDescquery);
			for(List<String> data : countryDesc){
				Desc = data.get(0);
			}
			return Desc;
		}
		
		public String getEmirateDesc(IFormReference iform,String EmirateCode){
			String Desc = "";
			
			String EmirateDescquery = "Select Distinct E_DESC from NG_KYC_REM_EMIRATE_MASTER where E_CODE = '"+EmirateCode+"'";
			List<List<String>> EmirateDesc = iform.getDataFromDB(EmirateDescquery);
			for(List<String> data : EmirateDesc){
				Desc = data.get(0);
			}
			return Desc;
		}
		
		public String getProductDesc(IFormReference iform,String ProductCode){
			String Product_type_descptn = "";
			String account_type_query = "select account_type from NG_MASTER_KYC_REM_PRODUCT_NAME with(nolock) where CD_DESC='" + ProductCode + "'";

			List<List<String>> account_type_query_output = iform.getDataFromDB(account_type_query);
			KYC_Remediation.mLogger.debug("account_type_query_output : " + account_type_query_output);
			String account_type_val="";
			if (!account_type_query_output.isEmpty()) {
				KYC_Remediation.mLogger.debug("Inside account_type_query_output: ");
				 account_type_val = account_type_query_output.get(0).get(0);
				KYC_Remediation.mLogger.debug("account_type_val: " + account_type_val);							
			} else {
				KYC_Remediation.mLogger.debug("account_type_query_output is empty!!");
			}
			return account_type_val;
		}
		
		
				
				public String makeSocketCall(String argumentString, String wi_name, String docName, String sessionId, String gtIP,
						int gtPort,String prequired, String pvalue,String userEmail,String portal_no) {
					String socketParams = argumentString + "~" + wi_name + "~" + docName + "~" + sessionId+"~"+prequired+"~"+pvalue+"~"+userEmail+"~"+portal_no;

					System.out.println("socketParams -- " + socketParams);
					KYC_Remediation.mLogger.debug("socketParams:-\n" + socketParams);

					Socket template_socket = null;
					DataOutputStream template_dout = null;
					DataInputStream template_in = null;
					String result = "";
					try {
						// Socket write code started
						template_socket = new Socket(gtIP,gtPort);
						KYC_Remediation.mLogger.debug("template_socket" + template_socket);

						template_dout = new DataOutputStream(template_socket.getOutputStream());
						KYC_Remediation.mLogger.debug("template_dout" + template_dout);

						if (socketParams != null && socketParams.length() > 0) {
							int outPut_len = socketParams.getBytes("UTF-8").length;
							KYC_Remediation.mLogger.debug("outPut_len" + outPut_len);
							// CreditCard.mLogger.info("Final XML output len:
							// "+outPut_len +
							// "");
							socketParams = outPut_len + "##8##;" + socketParams;
							KYC_Remediation.mLogger.debug("socketParams--" + socketParams);
							// CreditCard.mLogger.info("MqInputRequest"+"Input Request
							// Bytes : "+
							// mqInputRequest.getBytes("UTF-16LE"));

							template_dout.write(socketParams.getBytes("UTF-8"));
							template_dout.flush();
						} else {
							notify();
						}
						// Socket write code ended and read code started
						template_socket.setSoTimeout(60 * 1000);
						template_in = new DataInputStream(new BufferedInputStream(template_socket.getInputStream()));
						byte[] readBuffer = new byte[50000];
						int num = template_in.read(readBuffer);
						if (num > 0) {
							byte[] arrayBytes = new byte[num];
							System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
							result = new String(arrayBytes, "UTF-8");
							KYC_Remediation.mLogger.debug("result--" + result);
						}
					}

					catch (SocketException se) {
						se.printStackTrace();
					} catch (IOException i) {
						i.printStackTrace();
					} catch (Exception io) {
						io.printStackTrace();
					} finally {
						try {
							if (template_dout != null) {
								template_dout.close();
								template_dout = null;
							}
							if (template_in != null) {
								template_in.close();
								template_in = null;
							}
							if (template_socket != null) {
								if (!template_socket.isClosed()) {
									template_socket.close();
								}
								template_socket = null;
							}
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					return result;
				}
	}