/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP CBS
File Name				: RAOPCBSIntegration.java
Author 					: Sajan Soda
Date (DD/MM/YYYY)		: 15/06/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.RAOP.CBS;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.net.Socket;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.commons.io.FileUtils;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;

import ISPack.CImageServer;
import ISPack.ISUtil.JPISException;
import Jdts.DataObject.JPDBString;
public class RAOPCBSIntegration {

	Socket socket=null;
	String socketServerIP="";
	int socketServerPort=0;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String outputResponse = null;
	String inputRequest = null;
	String ws_name="Core_System_Update";
	String inputMessageID = null;
	String CIFID="";
	String strDocDownloadPath="";
	

	public ResponseBean RAOPCBSCifCreationIntegration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort , String smsPort, String wi_name,
			int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap,String docDownloadPath,String volumeId,String siteId, String Sig_Remarks) throws Exception
	{
		strDocDownloadPath=docDownloadPath;

		String QueryString="SELECT TOP 1 SOL_ID,CUSTOMER_SEGMENT,CUSTOMER_SUBSEGMENT,INDUSTRY_SEGMENT,"
				+ "INDUSTRY_SUBSEGMENT,EMPLOYMENT_TYPE,"
				+ "RESIDENCEADDRLINE1,RESIDENCEADDRLINE2,RESIDENCEADDRCITY,RESIDENCEADDRCOUNTRY,"
				+ "RESIDENCEADDRPOBOX,OCCUPATION,MAILINGADDRLINE1,MAILINGADDRLINE2,MAILINGADDRCITY,"
				+ "CUSTOMER_TYPE,CUSTOMER_CATEGORY,EMPLOYER_NAME,EMPLOYER_CODE,RISK_SCORE,"
				+ "PASSPORT_NUMBER,PASSPORT_ISSUE_DATE,PASSPORT_EXPIRY_DATE,VISA_UID_NUMBER,VISA_FILE_NUMBER,VISA_ISSUE_DATE,VISA_EXPIRY_DATE,EMIRATES_ID,EMIRATES_ID_EXPIRY_DATE,"
				+ "CITY_OF_BIRTH,COUNTRY_OF_BIRTH,CIF_NUMBER,CRS_UNDOCUMENTED_FLAG,CRS_UNDOCUMENTED_REASON,"
				+ "USRELATION,TINNUMBER,EXISTING_CUSTOMER,FATCAREASON,DOCUMENTSCOLLECTED,SIGNEDDATE,EXPIRYDATE,"
				+ "MAILINGADDRCOUNTRY,MAILINGADDRPOBOX,TITLE,PRODUCTTYPE,PRODUCTCURR,FIRST_NAME,MIDDLE_NAME,LAST_NAME,GENDER,"
				+ "DOB,NATIONALITY,MARITAL_STATUS,ITEMINDEX,MOBILE_NO,MOBILE_COUNTRY_CODE,EMAIL_ID,CREATE_CIF_STATUS,UPDATE_CIF_STATUS,"
				+ "CREATE_ACCOUNT_STATUS,SIGNATURE_PUSH_STATUS,ACCOUNTNO,IBANNO,DEMOGRAPHIC,PEP,RISK_SCORE_STATUSFROMUTIL,"
				+ "EXPECTEDMONTHLYCREDITTURNOVERAED,HIGHESTCASHCREDITTRANSACTIONAED,HIGHESTNONCASHCREDITTRANSACTIONAED,MONTHLYNONCASHCREDITTURNOVERPERCENTAGE,MONTHLYCASHCREDITTURNOVERPERCENTAGE,CHANNEL,SECOND_NATIONALITY,MONTHLY_SALARY"
				+ " FROM RB_RAOP_EXTTABLE with (nolock) where WINAME='"+wi_name+"'";

		ResponseBean objResponseBean=new ResponseBean();			
		objResponseBean.setAccountCreationReturnCode("Success");

		String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
		RAOPCBSLog.RAOPCBSLogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

		String sOutputXML=RAOPCBS.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
		RAOPCBSLog.RAOPCBSLogger.debug("Output XML for extranl Table select "+sOutputXML);

		XMLParser sXMLParser= new XMLParser(sOutputXML);
	    String sMainCode = sXMLParser.getValueOf("MainCode");
	    RAOPCBSLog.RAOPCBSLogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
	    RAOPCBSLog.RAOPCBSLogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			RAOPCBSLog.RAOPCBSLogger.debug("Coming in If Sajan");
			CustomerBean objCustBean=new CustomerBean();
			String strSolId="";
			strSolId=sXMLParser.getValueOf("SOL_ID");
			if ("".equalsIgnoreCase(strSolId.trim()))
				strSolId = "018";
			
			objCustBean.setSolId(strSolId);
			RAOPCBSLog.RAOPCBSLogger.debug("Sold Id is "+strSolId);
			
			String strSegment="";
			strSegment=sXMLParser.getValueOf("CUSTOMER_SEGMENT").trim();
			objCustBean.setCustomerSegment(strSegment);
			RAOPCBSLog.RAOPCBSLogger.debug("Customer Segment is "+strSegment);
			
			if ("".equalsIgnoreCase(strSegment.trim()))
				strSegment = "PBD";

			String strSubSegment="";
			strSubSegment=sXMLParser.getValueOf("CUSTOMER_SUBSEGMENT").trim();
			objCustBean.setCustomerSubSegment(strSubSegment);
			RAOPCBSLog.RAOPCBSLogger.debug("Customer Sub Segment is "+strSubSegment);
			
			if ("".equalsIgnoreCase(strSubSegment.trim()))
				strSubSegment = "PBN";

			String strEmploymentType="";
			strEmploymentType=sXMLParser.getValueOf("EMPLOYMENT_TYPE").trim();
			objCustBean.setEmployeeType(strEmploymentType);
			RAOPCBSLog.RAOPCBSLogger.debug("Employment type is "+strEmploymentType);

			String strResAddrLine1="";
			strResAddrLine1=sXMLParser.getValueOf("RESIDENCEADDRLINE1").trim();
			objCustBean.setResidenceAddrLine1(strResAddrLine1);
			RAOPCBSLog.RAOPCBSLogger.debug("Residence Address line 1"+strResAddrLine1);

			String strResAddrLine2="";
			strResAddrLine2=sXMLParser.getValueOf("RESIDENCEADDRLINE2").trim();
			objCustBean.setResidenceAddrLine2(strResAddrLine2);
			RAOPCBSLog.RAOPCBSLogger.debug("Residence Address line 2"+strResAddrLine2);

			String strResAddrCity="";
			strResAddrCity=sXMLParser.getValueOf("RESIDENCEADDRCITY").trim();
			objCustBean.setResidenceAddrCity(strResAddrCity);
			RAOPCBSLog.RAOPCBSLogger.debug("Residence Address City "+strResAddrCity);

			String strResAddrCountry="";
			strResAddrCountry=sXMLParser.getValueOf("RESIDENCEADDRCOUNTRY").trim();
			objCustBean.setResidenceAddrCountry(strResAddrCountry);
			RAOPCBSLog.RAOPCBSLogger.debug("Residence Address country "+strResAddrCountry);

			String strResAddrPOBox="";
			strResAddrPOBox=sXMLParser.getValueOf("RESIDENCEADDRPOBOX").trim();
			objCustBean.setResidenceAddrPOBox(strResAddrPOBox);
			RAOPCBSLog.RAOPCBSLogger.debug("Residence Address PO box "+strResAddrPOBox);

			String strOccupation="";
			strOccupation=sXMLParser.getValueOf("OCCUPATION").trim();
			objCustBean.setOccupation(strOccupation);
			RAOPCBSLog.RAOPCBSLogger.debug("Occupation is "+strOccupation);

			String strMailingAddrLine1="";
			strMailingAddrLine1=sXMLParser.getValueOf("MAILINGADDRLINE1").trim();
			objCustBean.setMailingAddrLine1(strMailingAddrLine1);
			RAOPCBSLog.RAOPCBSLogger.debug("Mailing Address line 1 "+strMailingAddrLine1);

			String strMailingAddrLine2="";
			strMailingAddrLine2=sXMLParser.getValueOf("MAILINGADDRLINE2").trim();
			objCustBean.setMailingAddrLine2(strMailingAddrLine2);
			RAOPCBSLog.RAOPCBSLogger.debug("Mailing address line 2 "+strMailingAddrLine2);

			String strMailingAddrCity="";
			strMailingAddrCity=sXMLParser.getValueOf("MAILINGADDRCITY").trim();
			objCustBean.setMailingAddrCity(strMailingAddrCity);
			RAOPCBSLog.RAOPCBSLogger.debug("Mailing address city is "+strMailingAddrCity);

			String strMailingAddressCountry="";
			strMailingAddressCountry=sXMLParser.getValueOf("MAILINGADDRCOUNTRY").trim();
			objCustBean.setMailingAddrCountry(strMailingAddressCountry);
			RAOPCBSLog.RAOPCBSLogger.debug("Mailiong Address country "+strMailingAddressCountry);

			String strMailingAddrPOBox="";
			strMailingAddrPOBox=sXMLParser.getValueOf("MAILINGADDRPOBOX").trim();
			objCustBean.setMailingAddrPOBox(strMailingAddrPOBox);
			RAOPCBSLog.RAOPCBSLogger.debug("Mailing address PO box is "+strMailingAddrPOBox);

			String strTitle="";
			strTitle=sXMLParser.getValueOf("TITLE").trim();
			objCustBean.setTitle(strTitle);
			RAOPCBSLog.RAOPCBSLogger.debug("Title is "+strTitle);

			String strFirstName="";
			strFirstName=sXMLParser.getValueOf("FIRST_NAME").trim();
			objCustBean.setFirstName(strFirstName);

			String strIsExistingCustomer="";
			strIsExistingCustomer=sXMLParser.getValueOf("EXISTING_CUSTOMER").trim();
			objCustBean.setIsExistingCustomer(strIsExistingCustomer);
			objResponseBean.setIsExistingCustomer(strIsExistingCustomer);

			String strMiddleName="";
			strMiddleName=sXMLParser.getValueOf("MIDDLE_NAME").trim();
			objCustBean.setMiddleName(strMiddleName);

			String strLastName="";
			strLastName=sXMLParser.getValueOf("LAST_NAME").trim();
			objCustBean.setLastName(strLastName);

			String strGender="";
			strGender=sXMLParser.getValueOf("GENDER").trim();
			objCustBean.setGender(strGender);

			String strCurrency="";
			strCurrency=sXMLParser.getValueOf("PRODUCTCURR").trim();
			objCustBean.setProductCurrency(strCurrency);

			String strItemIndex="";
			strItemIndex=sXMLParser.getValueOf("ITEMINDEX").trim();
			objCustBean.setItemIndex(strItemIndex);

			String strIndustrySegment="";
			strIndustrySegment=sXMLParser.getValueOf("INDUSTRY_SEGMENT").trim();
			objCustBean.setIndustrySegment(strIndustrySegment);

			String strIndustrySubSegment="";
			strIndustrySubSegment=sXMLParser.getValueOf("INDUSTRY_SUBSEGMENT").trim();
			objCustBean.setIndustrySubSegment(strIndustrySubSegment);

			String strDOB="";
			strDOB=sXMLParser.getValueOf("DOB").trim();
			objCustBean.setDob(strDOB);

			String strNationality="";
			strNationality=sXMLParser.getValueOf("NATIONALITY").trim();
			objCustBean.setNationality(strNationality);
			
			String strSecNationality="";
			strSecNationality=sXMLParser.getValueOf("SECOND_NATIONALITY").trim();
			objCustBean.setSecondNationality(strSecNationality);

			String strMaritalStatus="";
			strMaritalStatus=sXMLParser.getValueOf("MARITAL_STATUS").trim();
			objCustBean.setMaritalStatus(strMaritalStatus);

			objCustBean.setWiName(wi_name);


			String strCustomerType="";
			strCustomerType=sXMLParser.getValueOf("CUSTOMER_TYPE").trim();
			objCustBean.setCustomerType(strCustomerType);

			String strCustomerCategory="";
			strCustomerCategory=sXMLParser.getValueOf("CUSTOMER_CATEGORY").trim();
			objCustBean.setCustomerCategory(strCustomerCategory);

			String strEmployerName="";
			strEmployerName=sXMLParser.getValueOf("EMPLOYER_NAME").trim();
			objCustBean.setEmployerName(strEmployerName);	
			
			String strEmployerCode="";
			strEmployerCode=sXMLParser.getValueOf("EMPLOYER_CODE").trim();
			objCustBean.setEmployerCode(strEmployerCode);

			String strRiskScore="";
			strRiskScore=sXMLParser.getValueOf("RISK_SCORE").trim();
			objCustBean.setRiskScore(strRiskScore);

			String strUSRelation="";
			strUSRelation=sXMLParser.getValueOf("USRELATION").trim();
			objCustBean.setUsRelation(strUSRelation);

			String strTinNumber="";
			strTinNumber=sXMLParser.getValueOf("TINNUMBER").trim();
			objCustBean.setTinNumber(strTinNumber);

			String strFatcaReason="";
			strFatcaReason=sXMLParser.getValueOf("FATCAREASON").trim();
			objCustBean.setFatcaReason(strFatcaReason);

			String strDocumentsCollected="";
			strDocumentsCollected=sXMLParser.getValueOf("DOCUMENTSCOLLECTED").trim();
			objCustBean.setDocumentsCollected(strDocumentsCollected);

			String strSignatureDate="";
			strSignatureDate=sXMLParser.getValueOf("SIGNEDDATE").trim();
			objCustBean.setSignedDate(strSignatureDate);

			String strSignatureExpiryDate="";
			strSignatureExpiryDate=sXMLParser.getValueOf("EXPIRYDATE").trim();
			objCustBean.setExpiryDate(strSignatureExpiryDate);

			String strCityOfBirth="";
			strCityOfBirth=sXMLParser.getValueOf("CITY_OF_BIRTH").trim();
			objCustBean.setCityOfBirth(strCityOfBirth);

			String strCountryOfBirth="";
			strCountryOfBirth=sXMLParser.getValueOf("COUNTRY_OF_BIRTH").trim();
			objCustBean.setCountryOfBirth(strCountryOfBirth);

			String strCRSUndocumentedFlag="";
			strCRSUndocumentedFlag=sXMLParser.getValueOf("CRS_UNDOCUMENTED_FLAG").trim();
			objCustBean.setCrsUndocumentedFlag(strCRSUndocumentedFlag);

			String strCRSUndocumentedReason="";
			strCRSUndocumentedReason=sXMLParser.getValueOf("CRS_UNDOCUMENTED_REASON").trim();
			objCustBean.setCrsUndocumentedFlagReason(strCRSUndocumentedReason);

			String strPassportNumber="";
			strPassportNumber=sXMLParser.getValueOf("PASSPORT_NUMBER").trim();
			objCustBean.setPassportNumber(strPassportNumber);

			String strPassportIssDate="";
			strPassportIssDate=sXMLParser.getValueOf("PASSPORT_ISSUE_DATE").trim();
			objCustBean.setPassportIssDate(strPassportIssDate);
			
			String strPassportExpDate="";
			strPassportExpDate=sXMLParser.getValueOf("PASSPORT_EXPIRY_DATE").trim();
			objCustBean.setPassportExpDate(strPassportExpDate);

			String strVisaNumber="";
			strVisaNumber=sXMLParser.getValueOf("VISA_FILE_NUMBER").trim();
			objCustBean.setVisaNumber(strVisaNumber);

			String strVisaIssDate="";
			strVisaIssDate=sXMLParser.getValueOf("VISA_ISSUE_DATE").trim();
			objCustBean.setVisaIssDate(strVisaIssDate);
			
			String strVisaExpDate="";
			strVisaExpDate=sXMLParser.getValueOf("VISA_EXPIRY_DATE").trim();
			objCustBean.setVisaExpDate(strVisaExpDate);

			String strEmiratesId="";
			strEmiratesId=sXMLParser.getValueOf("EMIRATES_ID").trim();
			objCustBean.setEmiratesId(strEmiratesId);

			String strEmIdExpDate="";
			strEmIdExpDate=sXMLParser.getValueOf("EMIRATES_ID_EXPIRY_DATE").trim();
			objCustBean.setEmIdExpDate(strEmIdExpDate);
			
			String strCIFNumber="";
			strCIFNumber=sXMLParser.getValueOf("CIF_NUMBER").trim();
			objCustBean.setCifId(strCIFNumber);
			objResponseBean.setCifNumber(strCIFNumber);

			String strProductType="";
			strProductType=sXMLParser.getValueOf("PRODUCTTYPE").trim();
			objCustBean.setProductType(strProductType);
			
			String strAccountNo="";
			strAccountNo=sXMLParser.getValueOf("ACCOUNTNO").trim();
			objResponseBean.setAccNumber(strAccountNo);
			String strCREATECIFSTATUS="";
			strCREATECIFSTATUS=sXMLParser.getValueOf("CREATE_CIF_STATUS").trim();
			objResponseBean.setCifCreationReturnCode(strCREATECIFSTATUS);
			String strUPDATECIFSTATUS="";
			strUPDATECIFSTATUS=sXMLParser.getValueOf("UPDATE_CIF_STATUS").trim();
			objResponseBean.setCifUpdateReturnCode(strUPDATECIFSTATUS);
			String strCREATEACCOUNTSTATUS="";
			strCREATEACCOUNTSTATUS=sXMLParser.getValueOf("CREATE_ACCOUNT_STATUS").trim();
			objResponseBean.setAccountCreationReturnCode(strCREATEACCOUNTSTATUS);
			String strSIGNATUREPUSHSTATUS="";
			strSIGNATUREPUSHSTATUS=sXMLParser.getValueOf("SIGNATURE_PUSH_STATUS").trim();
			objResponseBean.setSignUploadReturnCode(strSIGNATUREPUSHSTATUS);
			
			String strRiskScoreStatus="";
			strRiskScoreStatus=sXMLParser.getValueOf("RISK_SCORE_STATUSFROMUTIL").trim();
			objResponseBean.setRiskScoreReturnCode(strRiskScoreStatus);
			
			String strIBANNO = "";
			strIBANNO = sXMLParser.getValueOf("IBANNO").trim();
			objCustBean.setIBANNO(strIBANNO);
			objResponseBean.setIbanNumber(strIBANNO);
			
			String strDemographic="";
			strDemographic=sXMLParser.getValueOf("DEMOGRAPHIC").trim();
			objCustBean.setDemographic(strDemographic);
			
			String strPEP="";
			strPEP=sXMLParser.getValueOf("PEP").trim();
			objCustBean.setPEP(strPEP);
			
			
			String strEXPECTEDMONTHLYCREDITTURNOVERAED="";
			strEXPECTEDMONTHLYCREDITTURNOVERAED=sXMLParser.getValueOf("EXPECTEDMONTHLYCREDITTURNOVERAED").trim();
			objCustBean.setMnthyCrTrunOverAmt(strEXPECTEDMONTHLYCREDITTURNOVERAED);
			
			String strHIGHESTCASHCREDITTRANSACTIONAED="";
			strHIGHESTCASHCREDITTRANSACTIONAED=sXMLParser.getValueOf("HIGHESTCASHCREDITTRANSACTIONAED").trim();
			objCustBean.setCashCrTransAmt(strHIGHESTCASHCREDITTRANSACTIONAED);

			String strHIGHESTNONCASHCREDITTRANSACTIONAED="";
			strHIGHESTNONCASHCREDITTRANSACTIONAED=sXMLParser.getValueOf("HIGHESTNONCASHCREDITTRANSACTIONAED").trim();
			objCustBean.setNCashCrTransAmt(strHIGHESTNONCASHCREDITTRANSACTIONAED);

			String strMONTHLYNONCASHCREDITTURNOVERPERCENTAGE="";
			strMONTHLYNONCASHCREDITTURNOVERPERCENTAGE=sXMLParser.getValueOf("MONTHLYNONCASHCREDITTURNOVERPERCENTAGE").trim();
			objCustBean.setNCashCrTurnOvrPer(strMONTHLYNONCASHCREDITTURNOVERPERCENTAGE);

			String strMONTHLYCASHCREDITTURNOVERPERCENTAGE="";
			strMONTHLYCASHCREDITTURNOVERPERCENTAGE=sXMLParser.getValueOf("MONTHLYCASHCREDITTURNOVERPERCENTAGE").trim();
			objCustBean.setCashCrTurnOvrPer(strMONTHLYCASHCREDITTURNOVERPERCENTAGE);
			
			String strCHANNEL="";
			strCHANNEL=sXMLParser.getValueOf("CHANNEL").trim();
			objCustBean.setChannel(strCHANNEL);
			
			String strMONTHLYSALARY="";
			strMONTHLYSALARY=sXMLParser.getValueOf("MONTHLY_SALARY").trim();
			objCustBean.setMonthlySalary(strMONTHLYSALARY);
			
			String ShortName = strFirstName+" "+strLastName;
			if(!"".equalsIgnoreCase(strMiddleName.trim()))
				ShortName = strFirstName+" "+strMiddleName+" "+strLastName;
						
			if(ShortName.length() > 50)
				ShortName = ShortName.substring(0,50);
			
			// Start - CIF Creation Call 
			if(!"Y".equalsIgnoreCase(strIsExistingCustomer) && !"Success".equalsIgnoreCase(strCREATECIFSTATUS) && ("".equalsIgnoreCase(strCIFNumber) || "null".equalsIgnoreCase(strCIFNumber)))
			{
				String ResAddressForCIFCreation=addressDetailsForCreateCustomer("RESIDENCE", strResAddrLine1, strResAddrLine2, "", "", strResAddrCity, strResAddrCountry, "", strResAddrPOBox);
				//String HomeAddressForCIFCreation=addressDetailsForCreateCustomer("Mailing", strMailingAddrLine1, strMailingAddrLine2, "", "", strMailingAddrCity, strMailingAddressCountry, "", strMailingAddrPOBox);
				String PersonDetails=personDetailsForCreateCustomer(strTitle, strFirstName, strMiddleName, strLastName, ShortName, strFirstName+" "+strMiddleName+" "+strLastName, strGender, "N", strResAddrCountry, strMaritalStatus, strNationality, strDOB);
				
				String strMobileNo = sXMLParser.getValueOf("MOBILE_NO").trim();
				String strMobileCntryCode = sXMLParser.getValueOf("MOBILE_COUNTRY_CODE").trim();
				String strEmailId = sXMLParser.getValueOf("EMAIL_ID").trim();
				String PhoneDetails = "";
				if (!strMobileNo.equalsIgnoreCase("") && !strMobileNo.equalsIgnoreCase("null") && !strMobileCntryCode.equalsIgnoreCase("") && !strMobileCntryCode.equalsIgnoreCase("null"))
				{
					PhoneDetails = "<PhoneDetails>\n" +
						"<PhoneType>CELLPH1</PhoneType>\n" +
						"<PhoneNumber>"+strMobileCntryCode+strMobileNo+"</PhoneNumber>\n" +
						"<LocalCode>"+strMobileNo+"</LocalCode>\n" +
						"<CountryCode>"+strMobileCntryCode+"</CountryCode>\n" +
						"<IsPreferred>Y</IsPreferred>\n" +
					"</PhoneDetails>\n";
				}
				String EmailDetails = "";
				if (!strEmailId.equalsIgnoreCase("") && !strEmailId.equalsIgnoreCase("null"))
				{
					EmailDetails = "<EmailAddress>\n" +
						"<MailIdType>HOMEEML</MailIdType>\n" +
						"<MailIdValue>"+strEmailId+"</MailIdValue>\n" +
						"<IsPreferred>Y</IsPreferred>\n" +
					"</EmailAddress>\n";
				}
				
				String DocDetails = "";
				
				if (!strPassportNumber.equalsIgnoreCase("") && !strPassportNumber.equalsIgnoreCase("null") && !strPassportExpDate.equalsIgnoreCase("") && !strPassportExpDate.equalsIgnoreCase("null"))
				{
					String DocIssueDate = "";
					if(!"".equalsIgnoreCase(strPassportIssDate.trim())) 
						DocIssueDate ="<DocIssueDate>"+strPassportIssDate+"</DocIssueDate>\n";
					DocDetails = DocDetails + "<DocDetails>\n" +
						"<DocType>Passport</DocType>\n" +
						"<DocCode>PPT</DocCode>\n" +
						DocIssueDate +
						"<DocExpiryDate>"+strPassportExpDate+"</DocExpiryDate>\n" +
						"<ParentDocCode>RETAIL</ParentDocCode>\n" +
						"<DocRefNum>"+strPassportNumber+"</DocRefNum>\n" +
					"</DocDetails>\n";
				}
				if (!strVisaNumber.equalsIgnoreCase("") && !strVisaNumber.equalsIgnoreCase("null") && !strVisaExpDate.equalsIgnoreCase("") && !strVisaExpDate.equalsIgnoreCase("null"))
				{
					String DocIssueDate = "";
					if(!"".equalsIgnoreCase(strVisaIssDate.trim())) 
						DocIssueDate ="<DocIssueDate>"+strVisaIssDate+"</DocIssueDate>\n";
					DocDetails = DocDetails + "<DocDetails>\n" +
						"<DocType>Visa</DocType>\n" +
						"<DocCode>VISA</DocCode>\n" +
						DocIssueDate +
						"<DocExpiryDate>"+strVisaExpDate+"</DocExpiryDate>\n" +
						"<ParentDocCode>RETAIL</ParentDocCode>\n" +
						"<DocRefNum>"+strVisaNumber+"</DocRefNum>\n" +
					"</DocDetails>\n";
				}
				
				if("Salaried".equalsIgnoreCase(strEmploymentType.trim()) || "Other".equalsIgnoreCase(strEmploymentType.trim()))
					strOccupation = "41"; // code for Other
				else if("Housewife".equalsIgnoreCase(strEmploymentType.trim()))
					strOccupation = "HSEWF"; // code for HOUSEWIFE
				else if("PENSIONER".equalsIgnoreCase(strEmploymentType.trim()) || "Retired".equalsIgnoreCase(strEmploymentType.trim()))
					strOccupation = "33"; // code for RETIRED/SENIOR CITIZEN
				else if("Self employed".equalsIgnoreCase(strEmploymentType.trim()) || "A".equalsIgnoreCase(strEmploymentType.trim()))
					strOccupation = "11"; // code for MANAGER/DIRECTOR/ADMINISTRATOR
				
				java.util.Date d1 = new Date();
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
				String DateExtra2 = sdf1.format(d1)+"+04:00";
				
				sInputXML = "<EE_EAI_MESSAGE>\n" +
									"<EE_EAI_HEADER>\n" +
										"<MsgFormat>NEW_CUSTOMER_REQ</MsgFormat>\n" +
										"<MsgVersion>001</MsgVersion>\n"+
										"<RequestorChannelId>BPM</RequestorChannelId>\n" +
										"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
										"<RequestorLanguage>E</RequestorLanguage>\n" +
										"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
										"<ReturnCode>911</ReturnCode>\n" +
										"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
										"<MessageId>testmsg001</MessageId>\n" +
										"<Extra1>REQ||SHELL.dfgJOHN</Extra1>\n" +
										"<Extra2>"+DateExtra2+"</Extra2>\n" +
									"</EE_EAI_HEADER>\n"+
									"<NewCustomerRequest>\n" +
										"<BankId>RAK</BankId>\n" +
										"<IsRetailCust>Y</IsRetailCust>\n" +
										"<DefaultAddrType>Mailing</DefaultAddrType>\n" +
										"<LangCode>INFENG</LangCode>\n" +
										"<LangDesc>USA (English)</LangDesc>\n" +
										"<DSAId>ZZZ999</DSAId>\n" +
										"<ProductProcessor>FINACLECORE</ProductProcessor>\n" +
										"<AutoVerifyFlag>Y</AutoVerifyFlag>\n" +
										"<CustClassification>C</CustClassification>\n" +

										"<BankRelationshipDetails>\n" +
											"<PrimaryServiceCenter>"+objCustBean.getSolId()+"</PrimaryServiceCenter>\n" +
											"<PrimaryBranchId>"+objCustBean.getSolId()+"</PrimaryBranchId>\n" + 
											/*"<PrimaryServiceCenter>002</PrimaryServiceCenter>\n" +
											"<PrimaryBranchId>002</PrimaryBranchId>\n" +*/
											"<PrimaryRMID>YAP</PrimaryRMID>\n" +
										"</BankRelationshipDetails>\n" +

										"<SegmentDetails>\n" +
											"<Segment>"+strSegment+"</Segment>\n" +
											"<Subsegment>"+strSubSegment+"</Subsegment>\n" + 
											/*"<Segment>PBD</Segment>\n" +
											"<Subsegment>PBN</Subsegment>\n" +*/
										"</SegmentDetails>\n" +
										ResAddressForCIFCreation +"\n" +
										//HomeAddressForCIFCreation +"\n" +
										PhoneDetails +
										EmailDetails +
										DocDetails +
										"<EmploymentDetails>\n" +
											"<EmploymentStatus>"+strEmploymentType+"</EmploymentStatus>\n" +
											"<Occupation>"+strOccupation+"</Occupation>\n" +
										"</EmploymentDetails>\n" +
										PersonDetails + "\n" +
									"</NewCustomerRequest>\n" +
								"</EE_EAI_MESSAGE>";

				RAOPCBSLog.RAOPCBSLogger.debug("Input XML for CIF creation is "+sInputXML);

				try
				{
					RAOPCBSLog.RAOPCBSLogger.debug("Session Id is "+sessionID);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					RAOPCBSLog.RAOPCBSLogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					RAOPCBSLog.RAOPCBSLogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						RAOPCBSLog.RAOPCBSLogger.debug("Data output stream is "+dout);
						RAOPCBSLog.RAOPCBSLogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

						RAOPCBSLog.RAOPCBSLogger.debug("Input MQ XML for CIF creation is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							RAOPCBSLog.RAOPCBSLogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							RAOPCBSLog.RAOPCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
							dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
						}
						byte[] readBuffer = new byte[500];
						int num = din.read(readBuffer);

						if (num > 0)
						{

							byte[] arrayBytes = new byte[num];
							System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
							outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
							inputMessageID = outputResponse;
							RAOPCBSLog.RAOPCBSLogger.debug("OutputResponse: "+outputResponse);

							if(!"".equalsIgnoreCase(outputResponse))
								outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
										wi_name,outputResponse,integrationWaitTime );
							if(outputResponse.contains("&lt;"))
							{
								outputResponse=outputResponse.replaceAll("&lt;", "<");
								outputResponse=outputResponse.replaceAll("&gt;", ">");
							}
						}
						socket.close();

						outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

						sXMLParser=new XMLParser(outputResponse);
						if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
						{
								objResponseBean.setCifCreationReturnCode("Success");
								CIFID=sXMLParser.getValueOf("CIFId");
								objCustBean.setCifId(CIFID);
								objResponseBean.setCifNumber(CIFID);
								strCIFNumber = CIFID;
								objResponseBean.setIntCallFailed(" ");
								objResponseBean.setIntFailedReason(" ");
								objResponseBean.setIntFailedCode(" ");
								objResponseBean.setMsgID(" ");
						}
						else
						{
							objResponseBean.setCifCreationReturnCode("Failure");
							/*objResponseBean.setCifUpdateReturnCode("Failure");
							objResponseBean.setAccountCreationReturnCode("Failure");
							objResponseBean.setSignUploadReturnCode("Failure");*/
							objResponseBean.setIntegrationDecision("Failure");
							objResponseBean.setIntCallFailed("NEW_CUSTOMER_REQ");
							if(outputResponse.contains("<ReturnDesc>"))
								objResponseBean.setIntFailedReason(sXMLParser.getValueOf("ReturnDesc"));
							else if(outputResponse.contains("<Description>"))
								objResponseBean.setIntFailedReason(sXMLParser.getValueOf("Description"));
								
							if(outputResponse.contains("<ReturnCode>"))
								objResponseBean.setIntFailedCode(sXMLParser.getValueOf("ReturnCode"));
							if(outputResponse.contains("<MessageId>"))
								objResponseBean.setMsgID(sXMLParser.getValueOf("MessageId"));
								
							return objResponseBean;
						}

						RAOPCBSLog.RAOPCBSLogger.debug("Response XML for CIF creation is "+outputResponse);

					}
				}
				catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.error("The Exception in CIF creation is "+e.getMessage());
				}
			} else
			{
				RAOPCBSLog.RAOPCBSLogger.error("CIF is already created or Existing Customer: "+strCIFNumber);
				objResponseBean.setCifCreationReturnCode("Success");
				objCustBean.setCifId(strCIFNumber);
				objResponseBean.setCifNumber(strCIFNumber);
				objResponseBean.setIntCallFailed(" ");
				objResponseBean.setIntFailedReason(" ");
				objResponseBean.setIntFailedCode(" ");
				objResponseBean.setMsgID(" ");
			}
			// End - CIF Creation Call
			
			// Start - CIF Update Call
			if("Success".equalsIgnoreCase(objResponseBean.getCifCreationReturnCode()) && !"Success".equalsIgnoreCase(strUPDATECIFSTATUS) && !"Y".equalsIgnoreCase(strIsExistingCustomer))
			{
				Thread.sleep(10000);
				sInputXML=getInputXMLCIFUpdate(objCustBean, strCIFNumber, CommonConnection.getUsername(), sessionID, cabinetName,sJtsIp,sJtsPort);

				RAOPCBSLog.RAOPCBSLogger.debug("Input XML for CIF Update is "+sInputXML);
				
				socketServerIP=socketDetailsMap.get("SocketServerIP");
				RAOPCBSLog.RAOPCBSLogger.debug("Socket server IP is "+socketServerIP);

				socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
				RAOPCBSLog.RAOPCBSLogger.debug("Socket server port is "+socketServerPort);
				
				socket=new Socket(socketServerIP,socketServerPort);
				socket.setSoTimeout(socket_connection_timeout*1000);
				out = socket.getOutputStream();
				socketInputStream = socket.getInputStream();
				dout = new DataOutputStream(out);
				din = new DataInputStream(socketInputStream);

				RAOPCBSLog.RAOPCBSLogger.debug("Data output stream is "+dout);
				RAOPCBSLog.RAOPCBSLogger.debug("Data input stream is "+din);
				outputResponse="";
				inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

				RAOPCBSLog.RAOPCBSLogger.debug("MQ Request XML for CIF update "+inputRequest);

				if (inputRequest != null && inputRequest.length() > 0)
				{
					int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
					RAOPCBSLog.RAOPCBSLogger.debug("RequestLen: "+inputRequestLen + "");
					inputRequest = inputRequestLen + "##8##;" + inputRequest;
					RAOPCBSLog.RAOPCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
					dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
				}
				byte[] readBuffer = new byte[500];
				int num = din.read(readBuffer);

				if (num > 0)
				{

					byte[] arrayBytes = new byte[num];
					System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
					outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
					inputMessageID = outputResponse;
					RAOPCBSLog.RAOPCBSLogger.debug("OutputResponse: "+outputResponse);

					if(!"".equalsIgnoreCase(outputResponse))
						outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
								wi_name,outputResponse,integrationWaitTime);
					if(outputResponse.contains("&lt;"))
					{
						outputResponse=outputResponse.replaceAll("&lt;", "<");
						outputResponse=outputResponse.replaceAll("&gt;", ">");
					}
				}
	    		socket.close();

				outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

				sXMLParser=new XMLParser(outputResponse);
				if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
				{
					objResponseBean.setCifUpdateReturnCode("Success");
					objResponseBean.setIntCallFailed(" ");
					objResponseBean.setIntFailedReason(" ");
					objResponseBean.setIntFailedCode(" ");
					objResponseBean.setMsgID(" ");
				}
				else
				{
					objResponseBean.setCifUpdateReturnCode("Failure");
					/*objResponseBean.setAccountCreationReturnCode("Failure");
					objResponseBean.setSignUploadReturnCode("Failure");*/
					objResponseBean.setIntegrationDecision("Failure");
					objResponseBean.setIntCallFailed("CUSTOMER_UPDATE_REQ");
					if(outputResponse.contains("<ReturnDesc>"))
						objResponseBean.setIntFailedReason(sXMLParser.getValueOf("ReturnDesc"));
					else if(outputResponse.contains("<Description>"))
						objResponseBean.setIntFailedReason(sXMLParser.getValueOf("Description"));
								
					if(outputResponse.contains("<ReturnCode>"))
						objResponseBean.setIntFailedCode(sXMLParser.getValueOf("ReturnCode"));
					if(outputResponse.contains("<MessageId>"))
						objResponseBean.setMsgID(sXMLParser.getValueOf("MessageId"));
					return objResponseBean;
				}
			} else
			{
				RAOPCBSLog.RAOPCBSLogger.error("CIF is already Updated or Existing Customer: "+strCIFNumber);
				objResponseBean.setCifUpdateReturnCode("Success");
				objResponseBean.setIntCallFailed(" ");
				objResponseBean.setIntFailedReason(" ");
				objResponseBean.setIntFailedCode(" ");
				objResponseBean.setMsgID(" ");
			}	
			// End - CIF Update Call
			
			// Start - Account Creation Call
			if("Success".equals(objResponseBean.getCifUpdateReturnCode()) && ("".equalsIgnoreCase(strAccountNo) || "NULL".equalsIgnoreCase(strAccountNo)))
			{
				sInputXML=getInputXMLAccountCreation(CommonConnection.getUsername(), sessionID, cabinetName, objCustBean, sJtsIp, sJtsPort);
	
				socketServerIP=socketDetailsMap.get("SocketServerIP");
				RAOPCBSLog.RAOPCBSLogger.debug("Socket server IP is "+socketServerIP);

				socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
				RAOPCBSLog.RAOPCBSLogger.debug("Socket server port is "+socketServerPort);
				
				socket=new Socket(socketServerIP,socketServerPort);
				socket.setSoTimeout(socket_connection_timeout*1000);
				out = socket.getOutputStream();
				socketInputStream = socket.getInputStream();
				dout = new DataOutputStream(out);
				din = new DataInputStream(socketInputStream);

				RAOPCBSLog.RAOPCBSLogger.debug("Data output stream is "+dout);
				RAOPCBSLog.RAOPCBSLogger.debug("Data input stream is "+din);
				outputResponse="";
				inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

				if (inputRequest != null && inputRequest.length() > 0)
				{
					int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
					RAOPCBSLog.RAOPCBSLogger.debug("RequestLen: "+inputRequestLen + "");
					inputRequest = inputRequestLen + "##8##;" + inputRequest;
					RAOPCBSLog.RAOPCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
					dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
				}
				byte[] readBuffer = new byte[500];
				int num = din.read(readBuffer);


				if (num > 0)
				{

					byte[] arrayBytes = new byte[num];
					System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
					outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
					inputMessageID = outputResponse;
					RAOPCBSLog.RAOPCBSLogger.debug("OutputResponse: "+outputResponse);

					if(!"".equalsIgnoreCase(outputResponse))
						outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
								wi_name,outputResponse,integrationWaitTime );
					if(outputResponse.contains("&lt;"))
					{
						outputResponse=outputResponse.replaceAll("&lt;", "<");
						outputResponse=outputResponse.replaceAll("&gt;", ">");
					}
				}
				socket.close();
				outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

				sXMLParser=new XMLParser(outputResponse);
				if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
				{
					objResponseBean.setAccountCreationReturnCode("Success");
					objResponseBean.setAccNumber(sXMLParser.getValueOf("NewAcid"));
					//objResponseBean.setIbanNumber(sXMLParser.getValueOf("IBANNumber"));
					strAccountNo = sXMLParser.getValueOf("NewAcid");
					objResponseBean.setIntCallFailed(" ");
					objResponseBean.setIntFailedReason(" ");
					objResponseBean.setIntFailedCode(" ");
					objResponseBean.setMsgID(" ");
				}
				else
				{
					objResponseBean.setAccountCreationReturnCode("Failure");
					//objResponseBean.setSignUploadReturnCode("Failure");
					objResponseBean.setIntegrationDecision("Failure");
					objResponseBean.setIntCallFailed("NEW_ACCOUNT_REQ");
					if(outputResponse.contains("<ReturnDesc>"))
						objResponseBean.setIntFailedReason(sXMLParser.getValueOf("ReturnDesc"));
					else if(outputResponse.contains("<Description>"))
						objResponseBean.setIntFailedReason(sXMLParser.getValueOf("Description"));
								
					if(outputResponse.contains("<ReturnCode>"))
						objResponseBean.setIntFailedCode(sXMLParser.getValueOf("ReturnCode"));
					if(outputResponse.contains("<MessageId>"))
						objResponseBean.setMsgID(sXMLParser.getValueOf("MessageId"));
					return objResponseBean;
				}
			} 
			else
			{
				RAOPCBSLog.RAOPCBSLogger.error("Account Number is already created: "+strCIFNumber);
				objResponseBean.setAccountCreationReturnCode("Success");
				objResponseBean.setAccNumber(strAccountNo);
				objResponseBean.setIntCallFailed(" ");
				objResponseBean.setIntFailedReason(" ");
				objResponseBean.setIntFailedCode(" ");
				objResponseBean.setMsgID(" ");
			}
			// End - Account Creation Call
			
			// Start - Signature Push Call
			if("Success".equals(objResponseBean.getAccountCreationReturnCode()) && !"Success".equals(strSIGNATUREPUSHSTATUS) && !"".equals(strAccountNo) && !"NULL".equals(strAccountNo))
			{
				String sigDocAvailFlag = "NotAvailable";
				String docListXML = GetDocumentsList(objCustBean.getItemIndex(), sessionID, cabinetName,sJtsIp,sJtsPort);
				if (!docListXML.trim().equalsIgnoreCase("F"))
				{
					sXMLParser=new XMLParser(docListXML);
					int noOfDocs=sXMLParser.getNoOfFields("Document");

					RAOPCBSLog.RAOPCBSLogger.info("No of docs for "+objCustBean.getWiName()+" is "+noOfDocs);

					for(int i=0;i<noOfDocs;i++)
					{
						XMLParser subXMLParser = null;
						String subXML1 = sXMLParser.getNextValueOf("Document");
						subXMLParser = new XMLParser(subXML1);
						String docName = subXMLParser.getValueOf("DocumentName");
						String docExt = subXMLParser.getValueOf("CreatedByAppName");
						//String tableNameforSigStatus = "";
						//String customer_name1 = "";
						//String customer_seq_no = "1";
						Date date = new Date();
						DateFormat logDateFormat = new SimpleDateFormat("dd-MM-yyyy");
						String trDate = logDateFormat.format(date);

						if("Signature_1".equalsIgnoreCase(docName))  //commented for testing
						// if("ACCOUNT MANDATE".equalsIgnoreCase(docName))   // added for testing
						{
							sigDocAvailFlag = "Available";
							//Commented for some time as download code is not working
							String downloadStatus = DownloadDocument(subXMLParser,objCustBean.getWiName(),docName,docExt,objResponseBean.getAccNumber(),cabinetName,sJtsIp,smsPort,docDownloadPath,volumeId,siteId);

							//Hard Coded value for some time
							//String downloadStatus="S";
							if(!("F".equals(downloadStatus)))
							{
								String sCustomerName = objCustBean.getFirstName().trim()+" "+objCustBean.getLastName().trim();
								if(!"".equalsIgnoreCase(objCustBean.getMiddleName().trim()))
								{
									sCustomerName = objCustBean.getFirstName().trim()+" "+objCustBean.getMiddleName().trim()+" "+objCustBean.getLastName().trim();
								}
								sInputXML =getSignatureUploadXML(downloadStatus,objResponseBean.getAccNumber(),strCIFNumber, trDate, sCustomerName, CommonConnection.getUsername(), sessionID, cabinetName, Sig_Remarks);
								
								// Start - Code for delete Downloaded tiff
								StringBuffer strFilePath = new StringBuffer();
								strFilePath.append(System.getProperty("user.dir"));
								strFilePath.append(File.separator);
								strFilePath.append("DownloadLoc");
									
								File file = new File(strFilePath.toString());
								
								if(file.listFiles()!=null)
								{
									for(File f: file.listFiles()) 
									{
										f.delete(); 
									}
								}
								strFilePath.delete(0,strFilePath.length());
								// End - Code for delete Downloaded tiff
								
								socketServerIP=socketDetailsMap.get("SocketServerIP");
								RAOPCBSLog.RAOPCBSLogger.debug("Socket server IP is "+socketServerIP);

								socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
								RAOPCBSLog.RAOPCBSLogger.debug("Socket server port is "+socketServerPort);
								
								socket=new Socket(socketServerIP,socketServerPort);
								socket.setSoTimeout(socket_connection_timeout*1000);
								out = socket.getOutputStream();
								socketInputStream = socket.getInputStream();
								dout = new DataOutputStream(out);
								din = new DataInputStream(socketInputStream);

								RAOPCBSLog.RAOPCBSLogger.debug("Data output stream is "+dout);
								RAOPCBSLog.RAOPCBSLogger.debug("Data input stream is "+din);
								outputResponse="";
								inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

								if (inputRequest != null && inputRequest.length() > 0)
								{
									int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
									RAOPCBSLog.RAOPCBSLogger.debug("RequestLen: "+inputRequestLen + "");
									inputRequest = inputRequestLen + "##8##;" + inputRequest;
									RAOPCBSLog.RAOPCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
									dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
								}
								byte[] readBuffer = new byte[500];
								int num = din.read(readBuffer);

								if (num > 0)
								{

									byte[] arrayBytes = new byte[num];
									System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
									outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
									inputMessageID = outputResponse;
									RAOPCBSLog.RAOPCBSLogger.debug("OutputResponse: "+outputResponse);

									if(!"".equalsIgnoreCase(outputResponse))
										outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
												wi_name,outputResponse,integrationWaitTime );
									if(outputResponse.contains("&lt;"))
									{
										outputResponse=outputResponse.replaceAll("&lt;", "<");
										outputResponse=outputResponse.replaceAll("&gt;", ">");
									}
								}
								socket.close();
								outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

								sXMLParser=new XMLParser(outputResponse);
								if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
								{
									objResponseBean.setSignUploadReturnCode("Success");
									//objResponseBean.setIntegrationDecision("Success");
									objResponseBean.setIntCallFailed(" ");
									objResponseBean.setIntFailedReason(" ");
									objResponseBean.setIntFailedCode(" ");
									objResponseBean.setMsgID(" ");
									break;
								}
								else
								{
									objResponseBean.setSignUploadReturnCode("Failure");
									objResponseBean.setIntegrationDecision("Failure");
									objResponseBean.setIntCallFailed("SIGNATURE_ADDITION_REQ");
									if(outputResponse.contains("<ReturnDesc>"))
										objResponseBean.setIntFailedReason(sXMLParser.getValueOf("ReturnDesc"));
									else if(outputResponse.contains("<Description>"))
										objResponseBean.setIntFailedReason(sXMLParser.getValueOf("Description"));
								
									if(outputResponse.contains("<ReturnCode>"))
										objResponseBean.setIntFailedCode(sXMLParser.getValueOf("ReturnCode"));
									if(outputResponse.contains("<MessageId>"))
										objResponseBean.setMsgID(sXMLParser.getValueOf("MessageId"));
									return objResponseBean;
								}

							}
							else
							{
								objResponseBean.setSignUploadReturnCode("Failure");
								objResponseBean.setIntegrationDecision("Failure");
								objResponseBean.setIntCallFailed("SIGNATURE_ADDITION_REQ");
								objResponseBean.setIntFailedReason("Signature Document is not Available");
								objResponseBean.setIntFailedCode("SIGNOTAVAIL");
								objResponseBean.setMsgID("SIGNOTAVAIL");
								return objResponseBean;
							}

						}
					}
					if(sigDocAvailFlag.equalsIgnoreCase("NotAvailable"))
					{
						objResponseBean.setSignUploadReturnCode("Failure");
						objResponseBean.setIntegrationDecision("Failure");
						objResponseBean.setIntCallFailed("SIGNATURE_ADDITION_REQ");
						objResponseBean.setIntFailedReason("Signature Document is not Available");
						objResponseBean.setIntFailedCode("SIGNOTAVAIL");
						objResponseBean.setMsgID("SIGNOTAVAIL");
						return objResponseBean;
					}
				}
				else
				{
					objResponseBean.setSignUploadReturnCode("Failure");
					objResponseBean.setIntegrationDecision("Failure");
					objResponseBean.setIntCallFailed("SIGNATURE_ADDITION_REQ");
					objResponseBean.setIntFailedReason("Error in downloading documents");
					objResponseBean.setIntFailedCode("ERRDOC");
					objResponseBean.setMsgID("ERRDOC");
					return objResponseBean;
				}
			}
			else
			{
				objResponseBean.setSignUploadReturnCode("Success");
				//objResponseBean.setIntegrationDecision("Success");
				objResponseBean.setIntCallFailed(" ");
				objResponseBean.setIntFailedReason(" ");
				objResponseBean.setIntFailedCode(" ");
				objResponseBean.setMsgID(" ");
			}
			// End - Signature Push Call
			
			// Start - Risk Score Call for new Customer
			if("Success".equalsIgnoreCase(objResponseBean.getCifCreationReturnCode()) 
					&& "Success".equalsIgnoreCase(objResponseBean.getCifUpdateReturnCode()) 
					&& "Success".equals(objResponseBean.getAccountCreationReturnCode()) 
					&& "Success".equals(objResponseBean.getSignUploadReturnCode()) 
					&& !"Success".equals(objResponseBean.getRiskScoreReturnCode())
					&& !"Y".equalsIgnoreCase(strIsExistingCustomer))
			{
				sInputXML=getInputXMLRiskScore(CommonConnection.getUsername(), sessionID, cabinetName, objCustBean, sJtsIp, sJtsPort);
	
				socketServerIP=socketDetailsMap.get("SocketServerIP");
				RAOPCBSLog.RAOPCBSLogger.debug("Socket server IP is "+socketServerIP);

				socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
				RAOPCBSLog.RAOPCBSLogger.debug("Socket server port is "+socketServerPort);
				
				socket=new Socket(socketServerIP,socketServerPort);
				socket.setSoTimeout(socket_connection_timeout*1000);
				out = socket.getOutputStream();
				socketInputStream = socket.getInputStream();
				dout = new DataOutputStream(out);
				din = new DataInputStream(socketInputStream);

				RAOPCBSLog.RAOPCBSLogger.debug("Data output stream is "+dout);
				RAOPCBSLog.RAOPCBSLogger.debug("Data input stream is "+din);
				outputResponse="";
				inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

				if (inputRequest != null && inputRequest.length() > 0)
				{
					int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
					RAOPCBSLog.RAOPCBSLogger.debug("RequestLen: "+inputRequestLen + "");
					inputRequest = inputRequestLen + "##8##;" + inputRequest;
					RAOPCBSLog.RAOPCBSLogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
					dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
				}
				byte[] readBuffer = new byte[500];
				int num = din.read(readBuffer);


				if (num > 0)
				{

					byte[] arrayBytes = new byte[num];
					System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
					outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
					inputMessageID = outputResponse;
					RAOPCBSLog.RAOPCBSLogger.debug("OutputResponse: "+outputResponse);

					if(!"".equalsIgnoreCase(outputResponse))
						outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
								wi_name,outputResponse,integrationWaitTime );
					if(outputResponse.contains("&lt;"))
					{
						outputResponse=outputResponse.replaceAll("&lt;", "<");
						outputResponse=outputResponse.replaceAll("&gt;", ">");
					}
				}
				socket.close();
				outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");

				sXMLParser=new XMLParser(outputResponse);
				if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
				{
					objResponseBean.setRiskScoreReturnCode("Success");
					objResponseBean.setIntegrationDecision("Success");
					objResponseBean.setIntCallFailed(" ");
					objResponseBean.setIntFailedReason(" ");
					objResponseBean.setIntFailedCode(" ");
					objResponseBean.setMsgID(" ");
				}
				else
				{
					objResponseBean.setRiskScoreReturnCode("Failure");
					objResponseBean.setIntegrationDecision("Failure");
					objResponseBean.setIntCallFailed("RISK_SCORE_DETAILS");
					if(outputResponse.contains("<ReturnDesc>"))
						objResponseBean.setIntFailedReason(sXMLParser.getValueOf("ReturnDesc"));
					else if(outputResponse.contains("<Description>"))
						objResponseBean.setIntFailedReason(sXMLParser.getValueOf("Description"));
								
					if(outputResponse.contains("<ReturnCode>"))
						objResponseBean.setIntFailedCode(sXMLParser.getValueOf("ReturnCode"));
					if(outputResponse.contains("<MessageId>"))
						objResponseBean.setMsgID(sXMLParser.getValueOf("MessageId"));
					return objResponseBean;
				}
			} 
			else
			{
				RAOPCBSLog.RAOPCBSLogger.error("Account Number is already created: "+strCIFNumber);
				objResponseBean.setRiskScoreReturnCode("Success");
				objResponseBean.setIntegrationDecision("Success");
				objResponseBean.setIntCallFailed(" ");
				objResponseBean.setIntFailedReason(" ");
				objResponseBean.setIntFailedCode(" ");
				objResponseBean.setMsgID(" ");
			}
			// End - Risk Score Call for new Customer

			
		}
		return objResponseBean;
	}
	public String addressDetailsForCreateCustomer(String AddressType,String addr_line1,String addr_line2,String addr_line3,String addr_line4,String addr_city,String addr_cntry,String addr_state,String addr_pobox)
	{
		String AddressXml = "<AddressDetails><AddressType></AddressType><AddrPrefFlag></AddrPrefFlag><PrefFormat>STRUCTURED_FORMAT</PrefFormat><AddrLine1></AddrLine1><AddrLine2></AddrLine2><AddrLine3></AddrLine3><AddrLine4></AddrLine4><City></City><CountryCode></CountryCode><State></State><POBox></POBox></AddressDetails>";
		if (addr_line2==null || addr_line2.equals(""))
			addr_line2 = ".";
		if(addr_line1==null || addr_line1.equals("") || addr_city==null || addr_city.equals(""))
			return "";
		else if (addr_cntry==null || addr_cntry.equals("") || addr_cntry.equals("--Select--"))
			return "";

		StringBuffer addressB = new StringBuffer(AddressXml);

		addressB = addressB.insert(addressB.indexOf("<AddressType>")+"<AddressType>".length(),AddressType );

		addressB = addressB.insert(addressB.indexOf("<AddrLine1>")+"<AddrLine1>".length(),addr_line1 );

		addressB = addressB.insert(addressB.indexOf("<AddrLine2>")+"<AddrLine2>".length(),addr_line2 );

		if(addr_line3!=null && !addr_line3.equals("") )
			addressB = addressB.insert(addressB.indexOf("<AddrLine3>")+"<AddrLine3>".length(),addr_line3 );
		else
			addressB = addressB.delete(addressB.indexOf("<AddrLine3>"), addressB.indexOf("</AddrLine3>")+"</AddrLine3>".length());

		if(addr_line4!=null && !addr_line4.equals("") )
			addressB = addressB.insert(addressB.indexOf("<AddrLine4>")+"<AddrLine4>".length(),addr_line4 );
		else
			addressB = addressB.delete(addressB.indexOf("<AddrLine4>"), addressB.indexOf("</AddrLine4>")+"</AddrLine4>".length());

		addressB = addressB.insert(addressB.indexOf("<City>")+"<City>".length(),addr_city );

		addressB = addressB.insert(addressB.indexOf("<CountryCode>")+"<CountryCode>".length(),addr_cntry );
		if("Residence".equalsIgnoreCase(AddressType))
			addressB = addressB.insert(addressB.indexOf("<AddrPrefFlag>")+"<AddrPrefFlag>".length(),"Y" );
		else
			addressB = addressB.insert(addressB.indexOf("<AddrPrefFlag>")+"<AddrPrefFlag>".length(),"N" );
		if(addr_state!=null && !addr_state.equals("") )
			addressB = addressB.insert(addressB.indexOf("<State>")+"<State>".length(),addr_state );
		else
			addressB = addressB.delete(addressB.indexOf("<State>"), addressB.indexOf("</State>")+"</State>".length());

		if(addr_pobox!=null && !addr_pobox.equals("") )
			addressB = addressB.insert(addressB.indexOf("<POBox>")+"<POBox>".length(),addr_pobox );
		else
			addressB = addressB.delete(addressB.indexOf("<POBox>"), addressB.indexOf("</POBox>")+"</POBox>".length());

		AddressXml =addressB.toString();
		return AddressXml;
	}

	public String personDetailsForCreateCustomer(String TitlePrefix, String FirstName, String MiddleName, String LastName, String ShortName, String FullName, String Gender, String NonResidentFlag, String ResCountry, String MaritalStatus, String Nationality, String DateOfBirth)
	{
		String PersonalXml = "<PersonDetails><TitlePrefix></TitlePrefix><FirstName></FirstName><MiddleName></MiddleName><LastName></LastName><ShortName></ShortName><FullName></FullName><Gender></Gender><MinorFlag>N</MinorFlag><NonResidentFlag></NonResidentFlag><ResCountry></ResCountry><MaritalStatus></MaritalStatus><Nationality></Nationality><DateOfBirth></DateOfBirth></PersonDetails>";

		StringBuffer PersonalB = new StringBuffer(PersonalXml);
		if(!TitlePrefix.equalsIgnoreCase("") && TitlePrefix!=null && !TitlePrefix.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<TitlePrefix>")+"<TitlePrefix>".length(),TitlePrefix );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<TitlePrefix>"), PersonalB.indexOf("</TitlePrefix>")+"</TitlePrefix>".length());

		if(!FirstName.equalsIgnoreCase("") && FirstName!=null && !FirstName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<FirstName>")+"<FirstName>".length(),FirstName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<FirstName>"), PersonalB.indexOf("</FirstName>")+"</FirstName>".length());

		if(!MiddleName.equalsIgnoreCase("") && MiddleName!=null && !MiddleName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<MiddleName>")+"<MiddleName>".length(),MiddleName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<MiddleName>"), PersonalB.indexOf("</MiddleName>")+"</MiddleName>".length());

		if(!LastName.equalsIgnoreCase("") && LastName!=null && !LastName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<LastName>")+"<LastName>".length(),LastName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<LastName>"), PersonalB.indexOf("</LastName>")+"</LastName>".length());

		if(!ShortName.equalsIgnoreCase("") && ShortName!=null && !ShortName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<ShortName>")+"<ShortName>".length(),ShortName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<ShortName>"), PersonalB.indexOf("</ShortName>")+"</ShortName>".length());
			
		if(!FullName.equalsIgnoreCase("") && FullName!=null && !FullName.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<FullName>")+"<FullName>".length(),FullName );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<FullName>"), PersonalB.indexOf("</FullName>")+"</FullName>".length());

		if(!Gender.equalsIgnoreCase("") && Gender!=null && !Gender.equals("") )
		{
			if (Gender.equalsIgnoreCase("Male"))
				PersonalB = PersonalB.insert(PersonalB.indexOf("<Gender>")+"<Gender>".length(),"M");
			else if (Gender.equalsIgnoreCase("Female"))
				PersonalB = PersonalB.insert(PersonalB.indexOf("<Gender>")+"<Gender>".length(),"F");
			else
				PersonalB = PersonalB.insert(PersonalB.indexOf("<Gender>")+"<Gender>".length(),Gender.trim());
		}else {
			PersonalB = PersonalB.delete(PersonalB.indexOf("<Gender>"), PersonalB.indexOf("</Gender>")+"</Gender>".length());
		}


		if(!NonResidentFlag.equalsIgnoreCase("") && NonResidentFlag!=null && !NonResidentFlag.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<NonResidentFlag>")+"<NonResidentFlag>".length(),NonResidentFlag );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<NonResidentFlag>"), PersonalB.indexOf("</NonResidentFlag>")+"</NonResidentFlag>".length());

		if(!ResCountry.equalsIgnoreCase("") && ResCountry!=null && !ResCountry.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<ResCountry>")+"<ResCountry>".length(),ResCountry );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<ResCountry>"), PersonalB.indexOf("</ResCountry>")+"</ResCountry>".length());

		if(!MaritalStatus.equalsIgnoreCase("") && MaritalStatus!=null && !MaritalStatus.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<MaritalStatus>")+"<MaritalStatus>".length(),MaritalStatus );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<MaritalStatus>"), PersonalB.indexOf("</MaritalStatus>")+"</MaritalStatus>".length());

		if(!Nationality.equalsIgnoreCase("") && Nationality!=null && !Nationality.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<Nationality>")+"<Nationality>".length(),Nationality );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<Nationality>"), PersonalB.indexOf("</Nationality>")+"</Nationality>".length());

		if(!DateOfBirth.equalsIgnoreCase("") && DateOfBirth!=null && !DateOfBirth.equals("") )
			PersonalB = PersonalB.insert(PersonalB.indexOf("<DateOfBirth>")+"<DateOfBirth>".length(),DateOfBirth );
		else
			PersonalB = PersonalB.delete(PersonalB.indexOf("<DateOfBirth>"), PersonalB.indexOf("</DateOfBirth>")+"</DateOfBirth>".length());

		PersonalXml =PersonalB.toString();
		return PersonalXml;
	}

	private String getRequestXML(String cabinetName, String sessionID,
			String wi_name, String ws_name, String userName, StringBuilder final_XML)
	{
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_RAOP_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_XML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		RAOPCBSLog.RAOPCBSLogger.debug("GetRequestXML: "+ strBuff.toString());
		return strBuff.toString();
	}

	private String getResponseXML(String cabinetName,String sJtsIp,String iJtsPort, String
			sessionID, String wi_name,String message_ID, int integrationWaitTime)
	{

		String outputResponseXML="";
		try
		{
			String QueryString = "select OUTPUT_XML from NG_RAOP_XMLLOG_HISTORY with (nolock) where " +
					"MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";

			String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
			RAOPCBSLog.RAOPCBSLogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=RAOPCBS.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				RAOPCBSLog.RAOPCBSLogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    RAOPCBSLog.RAOPCBSLogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    RAOPCBSLog.RAOPCBSLogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		RAOPCBSLog.RAOPCBSLogger.debug("OutputResponseXML: "+outputResponseXML);

	        		if("".equalsIgnoreCase(outputResponseXML)){
	        			outputResponseXML="Error";
	    			}
	        		break;
				}
			    Loop_count++;
			    Thread.sleep(1000);
			}
			while(Loop_count<integrationWaitTime);

		}
		catch(Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			RAOPCBSLog.RAOPCBSLogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}
		return outputResponseXML;
	}




	public String getInputXMLCIFUpdate(CustomerBean objCustBean,String CIFID,String username,String sessionId,String cabinetName,String jtsIp,String jtsPort)
	{
		String inputXML="";

				
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";
		
		String ResAddressForCIFUpdate=AddressDetailsForUpdateCustomer("RESIDENCE", objCustBean.getResidenceAddrLine1(), objCustBean.getResidenceAddrLine2(), "", "", objCustBean.getResidenceAddrCity(), objCustBean.getResidenceAddrCountry(), "", objCustBean.getResidenceAddrPOBox());
		
		String DocDetails = "";
		if (!objCustBean.getEmiratesId().equalsIgnoreCase("") && !objCustBean.getEmiratesId().equalsIgnoreCase("null") && !objCustBean.getEmIdExpDate().equalsIgnoreCase("") && !objCustBean.getEmIdExpDate().equalsIgnoreCase("null"))
		{
			DocDetails = "<DocDet>\n" +
				"<DocType>EMID</DocType>\n" +
				"<DocIsVerified>Y</DocIsVerified>\n"+
				"<DocNo>"+objCustBean.getEmiratesId().trim()+"</DocNo>\n" +
				"<DocExpDate>"+objCustBean.getEmIdExpDate().trim()+"</DocExpDate>\n" +
			"</DocDet>\n";
		}
		
		String strEmploymentType = objCustBean.getEmployeeType();
		String strEmployerName = objCustBean.getEmployerName();
		
		if("Housewife".equalsIgnoreCase(strEmploymentType.trim()))
			strEmployerName = "Housewife";
		else if("PENSIONER".equalsIgnoreCase(strEmploymentType.trim()) || "Retired".equalsIgnoreCase(strEmploymentType.trim()) || "Other".equalsIgnoreCase(strEmploymentType.trim()))
			strEmployerName = "Others";
				
		try{
			RAOPCBSLog.RAOPCBSLogger.debug("Inside getInputXML For CIFUpdate ");
			inputXML = "<EE_EAI_MESSAGE>\n" +
			"<EE_EAI_HEADER>\n" +
				"<MsgFormat>CUSTOMER_UPDATE_REQ</MsgFormat>\n" +
				"<MsgVersion>001</MsgVersion>\n" +
				"<RequestorChannelId>BPM</RequestorChannelId>\n" +
				"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
				"<RequestorLanguage>E</RequestorLanguage>\n" +
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
				"<ReturnCode>911</ReturnCode>\n" +
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
				"<MessageId>cifupdate001</MessageId>\n" +
				"<Extra1>REQ||SHELL.dfgJOHN</Extra1>\n" +
				"<Extra2>"+DateExtra2+"</Extra2>\n" +
			"</EE_EAI_HEADER>\n" +
			"<CustomerDetailsUpdateReq>\n" +
				"<BankId>RAK</BankId>\n" +
				"<CIFId>"+CIFID+"</CIFId>\n" +
				"<RetCorpFlag>R</RetCorpFlag>\n" +
				"<ActionRequired>U</ActionRequired>\n" +
				IndSegmentforCIFUpdate(objCustBean) + "\n" +
				ResAddressForCIFUpdate+"\n"+
				DocDetails+
				"<RtlAddnlDet>\n" +
					AdditionalDetailsForUpdateCustomer(objCustBean) + "\n"+

					FatcaDetailsForUpdateCustomer(objCustBean) + "\n"+
					
					KYCDetailsForUpdateCustomer(objCustBean) + "\n"+

					OECDDetailsForUpdateCustomer(objCustBean,sessionId,cabinetName,jtsIp,jtsPort)+ "\n" +
					"<EmployerNm>"+strEmployerName+"</EmployerNm>\n"+	
				"</RtlAddnlDet>\n" +
			"</CustomerDetailsUpdateReq>\n" +
			"</EE_EAI_MESSAGE>" ;
		}
		catch(Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("exception caught in getting inputxml customer update for CIF "+CIFID+" "+ e.getMessage());
			e.printStackTrace();
		}
		return inputXML;
	}

	public String AddressDetailsForUpdateCustomer(String AddressType,String addr_line1,String addr_line2,String addr_line3,String addr_line4,String addr_city,String addr_cntry,String addr_state,String addr_pobox)
	{
		Date date1 = new Date();
		DateFormat logDateFormat1 = new SimpleDateFormat("yyyy-MM-dd");
		String AddressXml = "<AddrDet><AddressType></AddressType><EffectiveFrom>"+logDateFormat1.format(date1)+"</EffectiveFrom><EffectiveTo>2099-12-31</EffectiveTo><HoldMailFlag>N</HoldMailFlag><ReturnFlag>N</ReturnFlag><AddrPrefFlag>Y</AddrPrefFlag><AddrLine1></AddrLine1><AddrLine2></AddrLine2><AddrLine3></AddrLine3><AddrLine4></AddrLine4><POBox></POBox><State></State><City></City><CountryCode></CountryCode></AddrDet>";
		if (addr_line2==null || addr_line2.equals(""))
			addr_line2 = ".";
		if(addr_line1==null || addr_line1.equals("") || addr_city==null || addr_city.equals(""))
			return "";
		else if (addr_cntry==null || addr_cntry.equals("") || addr_cntry.equals("--Select--"))
			return "";

		StringBuffer addressB = new StringBuffer(AddressXml);

		addressB = addressB.insert(addressB.indexOf("<AddressType>")+"<AddressType>".length(),AddressType );

		addressB = addressB.insert(addressB.indexOf("<AddrLine1>")+"<AddrLine1>".length(),addr_line1 );

		addressB = addressB.insert(addressB.indexOf("<AddrLine2>")+"<AddrLine2>".length(),addr_line2 );

		if(addr_line3!=null && !addr_line3.equals("") )
			addressB = addressB.insert(addressB.indexOf("<AddrLine3>")+"<AddrLine3>".length(),addr_line3 );
		else
			addressB = addressB.delete(addressB.indexOf("<AddrLine3>"), addressB.indexOf("</AddrLine3>")+"</AddrLine3>".length());

		if(addr_line4!=null && !addr_line4.equals("") )
			addressB = addressB.insert(addressB.indexOf("<AddrLine4>")+"<AddrLine4>".length(),addr_line4 );
		else
			addressB = addressB.delete(addressB.indexOf("<AddrLine4>"), addressB.indexOf("</AddrLine4>")+"</AddrLine4>".length());
		
		if(addr_pobox!=null && !addr_pobox.equals("") )
			addressB = addressB.insert(addressB.indexOf("<POBox>")+"<POBox>".length(),addr_pobox );
		else
			addressB = addressB.delete(addressB.indexOf("<POBox>"), addressB.indexOf("</POBox>")+"</POBox>".length());
		
		if(addr_state!=null && !addr_state.equals("") )
			addressB = addressB.insert(addressB.indexOf("<State>")+"<State>".length(),addr_state );
		else
			addressB = addressB.delete(addressB.indexOf("<State>"), addressB.indexOf("</State>")+"</State>".length());

		addressB = addressB.insert(addressB.indexOf("<City>")+"<City>".length(),addr_city );

		addressB = addressB.insert(addressB.indexOf("<CountryCode>")+"<CountryCode>".length(),addr_cntry );
	
		AddressXml =addressB.toString();
		return AddressXml;
	}

	public String IndSegmentforCIFUpdate(CustomerBean objCustDataBean)
	{
		String IndSegXml = "<IndustryDet><IndustrySegment></IndustrySegment><IndustrySubSegment></IndustrySubSegment></IndustryDet>";

		StringBuffer indSegB = new StringBuffer(IndSegXml);

		String indSeg = objCustDataBean.getIndustrySegment().trim();  
		String indSubSeg = objCustDataBean.getIndustrySubSegment().trim(); 
		
		if(indSeg!=null && !indSeg.equals("") )
			indSegB = indSegB.insert(indSegB.indexOf("<IndustrySegment>")+"<IndustrySegment>".length(),indSeg );
		else
			indSegB = indSegB.delete(indSegB.indexOf("<IndustrySegment>"), indSegB.indexOf("</IndustrySegment>")+"</IndustrySegment>".length());

		
		//if(indSubSeg!=null && !indSubSeg.equals("") )
			indSegB = indSegB.insert(indSegB.indexOf("<IndustrySubSegment>")+"<IndustrySubSegment>".length(),"VC" ); // always defaulting to VC which is employed individual
		/*else
			indSegB = indSegB.delete(indSegB.indexOf("<IndustrySubSegment>"), indSegB.indexOf("</IndustrySubSegment>")+"</IndustrySubSegment>".length());*/
		

		IndSegXml =indSegB.toString();
		return IndSegXml;
	}

	public String AdditionalDetailsForUpdateCustomer(CustomerBean objCustDataBean)
	{
		String AddnlXml = "<CustType></CustType><MaritalStatus></MaritalStatus><EmployerCode></EmployerCode><EmploymentType></EmploymentType><EmployeeStatus>2</EmployeeStatus><GrossSalary></GrossSalary><AECBconsentHeld>Y</AECBconsentHeld><AECBConsentSource></AECBConsentSource><RiskProfile></RiskProfile>";

		StringBuffer AddnlB = new StringBuffer(AddnlXml);

		if(objCustDataBean.getCustomerType()!=null && !objCustDataBean.getCustomerType().equals("") )
			AddnlB = AddnlB.insert(AddnlB.indexOf("<CustType>")+"<CustType>".length(),objCustDataBean.getCustomerType());
		else
			AddnlB = AddnlB.delete(AddnlB.indexOf("<CustType>"), AddnlB.indexOf("</CustType>")+"</CustType>".length());

		if (!("".equals(objCustDataBean.getMaritalStatus())))
			AddnlB = AddnlB.insert(AddnlB.indexOf("<MaritalStatus>")+"<MaritalStatus>".length(),objCustDataBean.getMaritalStatus());
		else
			AddnlB = AddnlB.delete(AddnlB.indexOf("<MaritalStatus>"), AddnlB.indexOf("</MaritalStatus>")+"</MaritalStatus>".length());

		if (!("".equals(objCustDataBean.getEmployerCode().trim())))
			AddnlB = AddnlB.insert(AddnlB.indexOf("<EmployerCode>")+"<EmployerCode>".length(),objCustDataBean.getEmployerCode().trim());
		else
			AddnlB = AddnlB.delete(AddnlB.indexOf("<EmployerCode>"), AddnlB.indexOf("</EmployerCode>")+"</EmployerCode>".length());

		if (!("".equals(objCustDataBean.getEmployeeType())))
			AddnlB = AddnlB.insert(AddnlB.indexOf("<EmploymentType>")+"<EmploymentType>".length(),objCustDataBean.getEmployeeType());
		else
			AddnlB = AddnlB.delete(AddnlB.indexOf("<EmploymentType>"), AddnlB.indexOf("</EmploymentType>")+"</EmploymentType>".length());
		
		if (!("".equals(objCustDataBean.getMonthlySalary())))
			AddnlB = AddnlB.insert(AddnlB.indexOf("<GrossSalary>")+"<GrossSalary>".length(),objCustDataBean.getMonthlySalary());
		else
			AddnlB = AddnlB.delete(AddnlB.indexOf("<GrossSalary>"), AddnlB.indexOf("</GrossSalary>")+"</GrossSalary>".length());

		if (!("".equals(objCustDataBean.getChannel())))
			AddnlB = AddnlB.insert(AddnlB.indexOf("<AECBConsentSource>")+"<AECBConsentSource>".length(),objCustDataBean.getChannel());
		else
			AddnlB = AddnlB.insert(AddnlB.indexOf("<AECBConsentSource>")+"<AECBConsentSource>".length(),"YAP");

		if(objCustDataBean.getRiskScore() !=null && !objCustDataBean.getRiskScore().equals("") )
			AddnlB = AddnlB.insert(AddnlB.indexOf("<RiskProfile>")+"<RiskProfile>".length(),objCustDataBean.getRiskScore());
		else
			AddnlB = AddnlB.delete(AddnlB.indexOf("<RiskProfile>"), AddnlB.indexOf("</RiskProfile>")+"</RiskProfile>".length());

		AddnlXml =AddnlB.toString();
		return AddnlXml;

	}

	public String FatcaDetailsForUpdateCustomer(CustomerBean objCustDataBean)
	{
		String FatcaXml = "<FatcaDetails><USRelation></USRelation><TIN></TIN><FatcaReason></FatcaReason><DocumentsCollected>SELF-ATTEST FORM!ID DOC</DocumentsCollected><SignedDate></SignedDate><SignedExpiryDate></SignedExpiryDate></FatcaDetails>";

		StringBuffer FatcaB = new StringBuffer(FatcaXml);
		
		String USRelation = objCustDataBean.getUsRelation().trim();
		if (!USRelation.equalsIgnoreCase("") && USRelation != null && USRelation != "")
		{
			FatcaB = FatcaB.insert(FatcaB.indexOf("<USRelation>")+"<USRelation>".length(),USRelation);
		}
		else
			FatcaB = FatcaB.delete(FatcaB.indexOf("<USRelation>"), FatcaB.indexOf("</USRelation>")+"</USRelation>".length());
		
		String FatcaTIN = objCustDataBean.getTinNumber();
		if (!FatcaTIN.equalsIgnoreCase("") && FatcaTIN != null && FatcaTIN != "")
		{
			FatcaB = FatcaB.insert(FatcaB.indexOf("<TIN>")+"<TIN>".length(),FatcaTIN);
		}
		else
			FatcaB = FatcaB.delete(FatcaB.indexOf("<TIN>"), FatcaB.indexOf("</TIN>")+"</TIN>".length());

		String FatcaReason = objCustDataBean.getFatcaReason();
		if (!FatcaReason.equalsIgnoreCase("") && FatcaReason != null && FatcaReason != ""){
			FatcaReason = FatcaReason.replace("#","!");
			FatcaReason = FatcaReason.replace("CURRENT US MAILING OR RESIDENCE ADDRESS","CURRENT US ADDR");
			FatcaReason = FatcaReason.replace("CURRENT US TELEPHONE NUMBER","CURRENT US PHONE NO");
			FatcaReason = FatcaReason.replace("POA/SIGNATORY HAS A US ADDRESS","POA/SIGN US ADDR");
			FatcaB = FatcaB.insert(FatcaB.indexOf("<FatcaReason>")+"<FatcaReason>".length(),FatcaReason);
		} else
			FatcaB = FatcaB.delete(FatcaB.indexOf("<FatcaReason>"), FatcaB.indexOf("</FatcaReason>")+"</FatcaReason>".length());

		/*String FatcaDocument = objCustDataBean.getDocumentsCollected();
		if (!FatcaDocument.equalsIgnoreCase("") && FatcaDocument != null && FatcaDocument != ""){
			FatcaDocument = FatcaDocument.replace("#","!");
			FatcaDocument = FatcaDocument.replace("IDENTIFICATION  DOCUMENT","ID DOC");
			FatcaDocument = FatcaDocument.replace("LOSS OF NATIONALITY CERTIFICATE","LOSS OF NAT CERT");
			FatcaDocument = FatcaDocument.replace("DECLARATION FOR INDIVIDUAL/CORPORATE","SELF-ATTEST FORM");
			FatcaDocument = FatcaDocument.replace("W8 FORM","W8");
			FatcaDocument = FatcaDocument.replace("W9 FORM","W9");
			FatcaB = FatcaB.insert(FatcaB.indexOf("<DocumentsCollected>")+"<DocumentsCollected>".length(),FatcaDocument);
		} else
			FatcaB = FatcaB.delete(FatcaB.indexOf("<DocumentsCollected>"), FatcaB.indexOf("</DocumentsCollected>")+"</DocumentsCollected>".length());
		*/
		
		if(objCustDataBean.getSignedDate() !=null && !objCustDataBean.getSignedDate().equals("") )
			FatcaB = FatcaB.insert(FatcaB.indexOf("<SignedDate>")+"<SignedDate>".length(),objCustDataBean.getSignedDate());
		else
			FatcaB = FatcaB.delete(FatcaB.indexOf("<SignedDate>"), FatcaB.indexOf("</SignedDate>")+"</SignedDate>".length());

		if(objCustDataBean.getExpiryDate() !=null && !objCustDataBean.getExpiryDate().equals("") )
			FatcaB = FatcaB.insert(FatcaB.indexOf("<SignedExpiryDate>")+"<SignedExpiryDate>".length(),objCustDataBean.getExpiryDate());
		else
			FatcaB = FatcaB.delete(FatcaB.indexOf("<SignedExpiryDate>"), FatcaB.indexOf("</SignedExpiryDate>")+"</SignedExpiryDate>".length());


		FatcaXml =FatcaB.toString();
		return FatcaXml;

	}

	public String KYCDetailsForUpdateCustomer(CustomerBean objCustDataBean)
	{
		String KYCXml = "<KYCDetails><KYCHeld>Y</KYCHeld><KYCReviewdate></KYCReviewdate><MthlyCrdtTurnOvrCur></MthlyCrdtTurnOvrCur><MthlyCrdtTurnOvrAmt></MthlyCrdtTurnOvrAmt><ExpdCashCrTransCur></ExpdCashCrTransCur><ExpdCashCrTransAmt></ExpdCashCrTransAmt><ExpdNCashCrTransCur></ExpdNCashCrTransCur><ExpdNCashCrTransAmt></ExpdNCashCrTransAmt><MnthNCashCrTurnOvrPer></MnthNCashCrTurnOvrPer><MnthCashCrTurnOvrPer></MnthCashCrTurnOvrPer><PEP></PEP></KYCDetails>";

		StringBuffer KYCB = new StringBuffer(KYCXml);

		String riskScore = objCustDataBean.getRiskScore().trim();
		String KYCReviewdate = calculateKYCReviewDate(riskScore);
		if (!KYCReviewdate.equalsIgnoreCase("") && KYCReviewdate != null && KYCReviewdate != "")
			KYCB = KYCB.insert(KYCB.indexOf("<KYCReviewdate>")+"<KYCReviewdate>".length(),KYCReviewdate);
		else
			KYCB = KYCB.delete(KYCB.indexOf("<KYCReviewdate>"), KYCB.indexOf("</KYCReviewdate>")+"</KYCReviewdate>".length());
		
		String MthlyCrdtTurnOvrAmt = objCustDataBean.getMnthyCrTrunOverAmt().trim().replace(",","");
		if (!MthlyCrdtTurnOvrAmt.equalsIgnoreCase("") && MthlyCrdtTurnOvrAmt != null && MthlyCrdtTurnOvrAmt != ""){
			KYCB = KYCB.insert(KYCB.indexOf("<MthlyCrdtTurnOvrCur>")+"<MthlyCrdtTurnOvrCur>".length(),"AED");
			KYCB = KYCB.insert(KYCB.indexOf("<MthlyCrdtTurnOvrAmt>")+"<MthlyCrdtTurnOvrAmt>".length(),MthlyCrdtTurnOvrAmt);
		}else{
			KYCB = KYCB.delete(KYCB.indexOf("<MthlyCrdtTurnOvrCur>"), KYCB.indexOf("</MthlyCrdtTurnOvrCur>")+"</MthlyCrdtTurnOvrCur>".length());
			KYCB = KYCB.delete(KYCB.indexOf("<MthlyCrdtTurnOvrAmt>"), KYCB.indexOf("</MthlyCrdtTurnOvrAmt>")+"</MthlyCrdtTurnOvrAmt>".length());
		}
		
		String ExpdCashCrTransAmt = objCustDataBean.getCashCrTransAmt().trim().replace(",","");
		if (!ExpdCashCrTransAmt.equalsIgnoreCase("") && ExpdCashCrTransAmt != null && ExpdCashCrTransAmt != "")
		{	
			KYCB = KYCB.insert(KYCB.indexOf("<ExpdCashCrTransCur>")+"<ExpdCashCrTransCur>".length(),"AED");
			KYCB = KYCB.insert(KYCB.indexOf("<ExpdCashCrTransAmt>")+"<ExpdCashCrTransAmt>".length(),ExpdCashCrTransAmt);
		}else {
			KYCB = KYCB.delete(KYCB.indexOf("<ExpdCashCrTransCur>"), KYCB.indexOf("</ExpdCashCrTransCur>")+"</ExpdCashCrTransCur>".length());
			KYCB = KYCB.delete(KYCB.indexOf("<ExpdCashCrTransAmt>"), KYCB.indexOf("</ExpdCashCrTransAmt>")+"</ExpdCashCrTransAmt>".length());
		}
		
		String ExpdNCashCrTransAmt = objCustDataBean.getNCashCrTransAmt().trim().replace(",","");
		if (!ExpdNCashCrTransAmt.equalsIgnoreCase("") && ExpdNCashCrTransAmt != null && ExpdNCashCrTransAmt != ""){
			KYCB = KYCB.insert(KYCB.indexOf("<ExpdNCashCrTransCur>")+"<ExpdNCashCrTransCur>".length(),"AED");
			KYCB = KYCB.insert(KYCB.indexOf("<ExpdNCashCrTransAmt>")+"<ExpdNCashCrTransAmt>".length(),ExpdNCashCrTransAmt);
		}else{
			KYCB = KYCB.delete(KYCB.indexOf("<ExpdNCashCrTransCur>"), KYCB.indexOf("</ExpdNCashCrTransCur>")+"</ExpdNCashCrTransCur>".length());
			KYCB = KYCB.delete(KYCB.indexOf("<ExpdNCashCrTransAmt>"), KYCB.indexOf("</ExpdNCashCrTransAmt>")+"</ExpdNCashCrTransAmt>".length());
		}
		
		String MnthNCashCrTurnOvrPer = objCustDataBean.getNCashCrTurnOvrPer().trim();
		if (!MnthNCashCrTurnOvrPer.equalsIgnoreCase("") && MnthNCashCrTurnOvrPer != null && MnthNCashCrTurnOvrPer != "")
			KYCB = KYCB.insert(KYCB.indexOf("<MnthNCashCrTurnOvrPer>")+"<MnthNCashCrTurnOvrPer>".length(),MnthNCashCrTurnOvrPer);
		else
			KYCB = KYCB.delete(KYCB.indexOf("<MnthNCashCrTurnOvrPer>"), KYCB.indexOf("</MnthNCashCrTurnOvrPer>")+"</MnthNCashCrTurnOvrPer>".length());

		String MnthCashCrTurnOvrPer = objCustDataBean.getCashCrTurnOvrPer().trim();
		if (!MnthCashCrTurnOvrPer.equalsIgnoreCase("") && MnthCashCrTurnOvrPer != null && MnthCashCrTurnOvrPer != "")
			KYCB = KYCB.insert(KYCB.indexOf("<MnthCashCrTurnOvrPer>")+"<MnthCashCrTurnOvrPer>".length(),MnthCashCrTurnOvrPer);
		else
			KYCB = KYCB.delete(KYCB.indexOf("<MnthCashCrTurnOvrPer>"), KYCB.indexOf("</MnthCashCrTurnOvrPer>")+"</MnthCashCrTurnOvrPer>".length());

		String PEP = objCustDataBean.getPEP().trim();
		if (!PEP.equalsIgnoreCase("") && PEP != null && PEP != "")
			KYCB = KYCB.insert(KYCB.indexOf("<PEP>")+"<PEP>".length(),PEP);
		else
			KYCB = KYCB.delete(KYCB.indexOf("<PEP>"), KYCB.indexOf("</PEP>")+"</PEP>".length());
		
		KYCXml =KYCB.toString();
		return KYCXml;

	}
	
	public String formatDate(String inDate, String fromFormat, String ToFormat) {
		SimpleDateFormat inSDF = new SimpleDateFormat(fromFormat); //"mm/dd/yyyy"
		SimpleDateFormat outSDF = new SimpleDateFormat(ToFormat); //"yyyy-MM-dd"

		String outDate = "";
		if (inDate != null) {
			try {
				Date date = inSDF.parse(inDate);
				outDate = outSDF.format(date);
			} catch (ParseException e) {
				System.out.println("Unable to format date: " + inDate + e.getMessage());
				e.printStackTrace();
			}
		}
		return outDate;
  }

	public String OECDDetailsForUpdateCustomer(CustomerBean objCustDataBean,String sessionId,String cabinetName,String jtsIp,String jtsPort)
	{
		String OecdXml = "<OECDDet><CityOfBirth></CityOfBirth><CountryOfBirth></CountryOfBirth><CRSUnDocFlg></CRSUnDocFlg><CRSUndocFlgReason></CRSUndocFlgReason>";

		StringBuffer OecdB = new StringBuffer(OecdXml);

		if(objCustDataBean.getCityOfBirth() !=null && !objCustDataBean.getCityOfBirth().equals("") )
			OecdB = OecdB.insert(OecdB.indexOf("<CityOfBirth>")+"<CityOfBirth>".length(),objCustDataBean.getCityOfBirth());
		else
			OecdB = OecdB.delete(OecdB.indexOf("<CityOfBirth>"), OecdB.indexOf("</CityOfBirth>")+"</CityOfBirth>".length());

		if(objCustDataBean.getCountryOfBirth() !=null && !objCustDataBean.getCountryOfBirth().equals("") )
			OecdB = OecdB.insert(OecdB.indexOf("<CountryOfBirth>")+"<CountryOfBirth>".length(),objCustDataBean.getCountryOfBirth());
		else
			OecdB = OecdB.delete(OecdB.indexOf("<CountryOfBirth>"), OecdB.indexOf("</CountryOfBirth>")+"</CountryOfBirth>".length());

		if(objCustDataBean.getCrsUndocumentedFlag() !=null && !objCustDataBean.getCrsUndocumentedFlag().equals("") )
			OecdB = OecdB.insert(OecdB.indexOf("<CRSUnDocFlg>")+"<CRSUnDocFlg>".length(),objCustDataBean.getCrsUndocumentedFlag());
		else
			OecdB = OecdB.delete(OecdB.indexOf("<CRSUnDocFlg>"), OecdB.indexOf("</CRSUnDocFlg>")+"</CRSUnDocFlg>".length());

		if(objCustDataBean.getCrsUndocumentedFlagReason() !=null && !objCustDataBean.getCrsUndocumentedFlagReason().equals("") )
			OecdB = OecdB.insert(OecdB.indexOf("<CRSUndocFlgReason>")+"<CRSUndocFlgReason>".length(),objCustDataBean.getCrsUndocumentedFlagReason());
		else
			OecdB = OecdB.delete(OecdB.indexOf("<CRSUndocFlgReason>"), OecdB.indexOf("</CRSUndocFlgReason>")+"</CRSUndocFlgReason>".length());


		///////////////////////////////////////////////////////////////////////////////
		ArrayList<RAOPTaxBean> objArrayOecdTaxList=new ArrayList<RAOPTaxBean>();
		try {
			RAOPCBSLog.RAOPCBSLogger.info("Fetching OECD Tax Details For Customer::"+ objCustDataBean.getWiName());
			String sqlQueryDocType = "SELECT * FROM USR_0_RAOP_TAX_DTLS WITH (NOLOCK)" +
			"WHERE WI_NAME ='"+objCustDataBean.getWiName()+"'";
			String InputXMLOecdTax = CommonMethods.apSelectWithColumnNames(sqlQueryDocType, cabinetName, sessionId);
			RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustDataBean.getWiName() + "InputXml For OECD Tax details from transaction table "+InputXMLOecdTax);
			String outputXMLOecdTax = RAOPCBS.WFNGExecute(InputXMLOecdTax, jtsIp,jtsPort, 1);
			RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustDataBean.getWiName() + "OutputXML for OECD Tax details from transaction table  "+outputXMLOecdTax);

			XMLParser xmlParserDataDoc=new XMLParser();
			xmlParserDataDoc.setInputXML(outputXMLOecdTax);
			String mainCodeDocType =xmlParserDataDoc.getValueOf("MainCode");
			if("0".equals(mainCodeDocType))
			{
				int countofrecordsDocType = Integer.parseInt(xmlParserDataDoc.getValueOf("TotalRetrieved"));
				RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustDataBean.getWiName() + "Total No Of Oecd Tax Details Found "+countofrecordsDocType);
				for(int j=0; j<countofrecordsDocType; j++)
				{
					String subXMLOecdTax = xmlParserDataDoc.getNextValueOf("Record");
					XMLParser objXmlParserOecdTax = new XMLParser(subXMLOecdTax);
					RAOPTaxBean objOecdTaxBean=new RAOPTaxBean();
					objOecdTaxBean=getOecdTaxDetails(objOecdTaxBean,objXmlParserOecdTax);
					objArrayOecdTaxList.add(objOecdTaxBean);
				}
			}
		} catch (Exception e) {
			RAOPCBSLog.RAOPCBSLogger.info("Exception in fetching Oecd Tax Details for workitem : "+objCustDataBean.getWiName()+" Exception is: "+e.getMessage());
		}


		String OecdTaxXmlFinal = "";
		for(int i=0;i<objArrayOecdTaxList.size();i++)
		{
			String OecdTaxXml="<ReporCntryDet><CntryOfTaxRes></CntryOfTaxRes><TINNumber></TINNumber><NoTINReason></NoTINReason></ReporCntryDet>";

			StringBuffer OecdTaxB = new StringBuffer(OecdTaxXml);

			if(objArrayOecdTaxList.get(i).getCountryOfTaxResidence() !=null && !objArrayOecdTaxList.get(i).getCountryOfTaxResidence().equals("") )
				OecdTaxB = OecdTaxB.insert(OecdTaxB.indexOf("<CntryOfTaxRes>")+"<CntryOfTaxRes>".length(),objArrayOecdTaxList.get(i).getCountryOfTaxResidence());
			else
				OecdTaxB = OecdTaxB.delete(OecdTaxB.indexOf("<CntryOfTaxRes>"), OecdTaxB.indexOf("</CntryOfTaxRes>")+"</CntryOfTaxRes>".length());

			if(objArrayOecdTaxList.get(i).getTaxPayerIdNumber()!=null && !objArrayOecdTaxList.get(i).getTaxPayerIdNumber().equals("") )
				OecdTaxB = OecdTaxB.insert(OecdTaxB.indexOf("<TINNumber>")+"<TINNumber>".length(),objArrayOecdTaxList.get(i).getTaxPayerIdNumber());
			else
				OecdTaxB = OecdTaxB.delete(OecdTaxB.indexOf("<TINNumber>"), OecdTaxB.indexOf("</TINNumber>")+"</TINNumber>".length());

			if(objArrayOecdTaxList.get(i).getNoTinReason() !=null && !objArrayOecdTaxList.get(i).getNoTinReason().equals("") )
				OecdTaxB = OecdTaxB.insert(OecdTaxB.indexOf("<NoTINReason>")+"<NoTINReason>".length(),objArrayOecdTaxList.get(i).getNoTinReason());
			else
				OecdTaxB = OecdTaxB.delete(OecdTaxB.indexOf("<NoTINReason>"), OecdTaxB.indexOf("</NoTINReason>")+"</NoTINReason>".length());


			OecdTaxXmlFinal = OecdTaxXmlFinal + OecdTaxB.toString();
		}
		//////////////////////////////////////////////////////////////////////////////


		OecdXml =OecdB.toString();
		OecdXml = OecdXml + OecdTaxXmlFinal + "</OECDDet>";
		return OecdXml;

	}

	public RAOPTaxBean getOecdTaxDetails(RAOPTaxBean objRAOPTaxBean,XMLParser objXmlParser)
	{
		objRAOPTaxBean.setCountryOfTaxResidence(objXmlParser.getValueOf("COUNTRY_OF_TAX_RESIDENCE"));
		objRAOPTaxBean.setTaxPayerIdNumber(objXmlParser.getValueOf("TAX_PAYER_IDENTIFICATION_NO"));
		objRAOPTaxBean.setNoTinReason(objXmlParser.getValueOf("NO_TIN_REASON"));
		objRAOPTaxBean.setRemarks(objXmlParser.getValueOf("REMARKS"));
		return objRAOPTaxBean;
	}

	public String DocDetailsForUpdateCustomer(String DocType,CustomerBean objCustBean)
	{
			String expdate = "";
			String DocNumber="";
			if("Visa".equals(DocType))
			{
				expdate=objCustBean.getVisaExpDate();
				DocNumber=objCustBean.getVisaNumber();
			}
			else if("Emirates ID".equals(DocType))
			{
				expdate=objCustBean.getEmIdExpDate();
				DocNumber=objCustBean.getEmiratesId();
			}
			else if("Passport".equals(DocType))
			{
				expdate=objCustBean.getPassportExpDate();
				DocNumber=objCustBean.getPassportNumber();
			}

			String docTypeXml="<DocDet>\n" +
			"<DocType>"+DocType+"</DocType>\n" +
			"<DocIsVerified>Y</DocIsVerified>\n" +
			"<DocNo>"+DocNumber+"</DocNo>\n" +
			"<DocExpDate>"+expdate+"</DocExpDate>\n" +
			"</DocDet>";

		return docTypeXml;
	}

	public String getInputXMLAccountCreation(String userName,String sessionId,String cabinetName,CustomerBean objCustBean, String sJtsIp, String sJtsPort)
	{
		String inputXML="";
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";
		try{
			RAOPCBSLog.RAOPCBSLogger.info("Inside getInputXMLAccountCreation ");
			
			String sProdType = objCustBean.getProductType().trim();
			String sProdCurr = objCustBean.getProductCurrency().trim();
			
			if ("".equalsIgnoreCase(sProdType) || "".equalsIgnoreCase(sProdCurr))
			{
				if ("YAP".equalsIgnoreCase(objCustBean.getChannel().trim()))
				{
					sProdType = "YP";
					sProdCurr = "AED";
				}	
			}
			
			String SchemeCode = "";
			String SchemeType = "";
			String CustSubSegment = objCustBean.getCustomerSubSegment().trim();
			try {
				if(!"".equalsIgnoreCase(CustSubSegment))
				{
					RAOPCBSLog.RAOPCBSLogger.info("Fetching CustSubSegment Scheme Type and Code::"+ objCustBean.getWiName());
					String sqlQuery = "SELECT top 1 SCHEME_CODE,SCHEME_TYPE FROM USR_0_RAOP_CUSTOMER_SUBSEGMENT WITH(NOLOCK) WHERE SUBSEGMENT_CODE = '"+CustSubSegment+"' AND ISACTIVE='Y'";
					String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
					RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For CustSubSegment Scheme Type and Code "+InputXML);
					String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
					RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for CustSubSegment Scheme Type and Code  "+outputXML);

					XMLParser xmlParser=new XMLParser();
					xmlParser.setInputXML(outputXML);
					String mainCode =xmlParser.getValueOf("MainCode");
					
					if("0".equals(mainCode))
					{
						int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of CustSubSegment Scheme Type and Code "+countofrecords);
						for(int j=0; j<countofrecords; j++)
						{
							String subXML = xmlParser.getNextValueOf("Record");
							XMLParser objXmlParser = new XMLParser(subXML);
							SchemeCode = objXmlParser.getValueOf("SCHEME_CODE");
							SchemeType = objXmlParser.getValueOf("SCHEME_TYPE");
						}
					}
					
				}
			}catch(Exception e)
			{
				RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting CustSubSegment Scheme Type and Code"+ e.getMessage());
				e.printStackTrace();
			}
			
			inputXML = "<EE_EAI_MESSAGE>\n" +
					"<EE_EAI_HEADER>\n"+
						"<MsgFormat>NEW_ACCOUNT_REQ</MsgFormat>\n" +
						"<MsgVersion>001</MsgVersion>\n" +
						"<RequestorChannelId>BPM</RequestorChannelId>\n" +
						"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
						"<RequestorLanguage>E</RequestorLanguage>\n" +
						"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
						"<ReturnCode>911</ReturnCode>\n" +
						"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
						"<MessageId>testacc001</MessageId>\n" +
						"<Extra1>REQ||SHELL.dfgJOHN</Extra1>\n" +
						"<Extra2>"+DateExtra2+"</Extra2>\n" +
					"</EE_EAI_HEADER>\n"+
					"<AccountRequest>\n"+
						"<BankId>RAK</BankId>\n"+
						"<BranchId>"+objCustBean.getSolId()+"</BranchId>\n"+
						"<CustomerId>"+objCustBean.getCifId()+"</CustomerId>\n"+
						"<IBANNumber>"+objCustBean.getIBANNO()+"</IBANNumber>\n"+
						"<AcRequired>"+sProdType+"</AcRequired>\n"+
						"<CurrencyCode>"+sProdCurr+"</CurrencyCode>\n"+
						"<ChannelId>YAP</ChannelId>\n"+
						"<DebitCardRequired>N</DebitCardRequired>\n"+
						"<JointAccInd>N</JointAccInd>\n"+
						"<ActiveAcctInd>Y</ActiveAcctInd>\n"+
						"<SchemeType>"+SchemeType+"</SchemeType>\n"+
						"<SchemeCode>"+SchemeCode+"</SchemeCode>\n"+
						"<Action>A</Action>\n"+
					"</AccountRequest>\n"+
					"</EE_EAI_MESSAGE>";

		}
		catch(Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting inputxml Account creation"+ e.getMessage());
			e.printStackTrace();
		}
		return inputXML;
	}
	
	public String getInputXMLRiskScore(String userName,String sessionId,String cabinetName,CustomerBean objCustBean, String sJtsIp, String sJtsPort)
	{
		String finalXml="";
		try{
			
			RAOPCBSLog.RAOPCBSLogger.info("Inside RiskScore call is");
			
				String ReferenceCifId = "";
				if(!"".equalsIgnoreCase(objCustBean.getCifId().trim()))
				{
					ReferenceCifId = "<RequestInfo>\n" +
						"<RequestType>CIF Id</RequestType>\n" +
						"<RequestValue>"+objCustBean.getCifId().trim()+"</RequestValue>\n" +
					"</RequestInfo>\n";
				}
				
				String ProductsInfoXml = "";
				String ProductType = objCustBean.getProductType().trim();
				String ProductCurrency = "";
				try {
					if(!ProductType.equalsIgnoreCase(""))
					{
						String QueryString="SELECT top 1 Product_Type_Display, Product_Currency FROM USR_0_RAOP_PRODUCT_TYPE WITH(NOLOCK) WHERE Product_Code = '"+ProductType+"' AND ISACTIVE='Y'";
	
						String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.debug("Input XML for ProductType "+sInputXML);
	
						String sOutputXML=RAOPCBS.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
						RAOPCBSLog.RAOPCBSLogger.debug("Output XML for ProductType "+sOutputXML);
	
						XMLParser sXMLParser= new XMLParser(sOutputXML);
					    String sMainCode = sXMLParser.getValueOf("MainCode");
					    RAOPCBSLog.RAOPCBSLogger.debug("SMainCode: "+sMainCode);
	
					    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
					    RAOPCBSLog.RAOPCBSLogger.debug("STotalRecords: "+sTotalRecords);
	
						if (sMainCode.equals("0") && sTotalRecords > 0)
						{
							RAOPCBSLog.RAOPCBSLogger.debug("Coming in If Sajan");
							ProductType=sXMLParser.getValueOf("Product_Type_Display");
							ProductCurrency=sXMLParser.getValueOf("Product_Currency");
						}
					
						ProductsInfoXml = ProductsInfoXml + "<ProductsInfo>\n" +
							"<Product>"+ProductType+"</Product>\n" +
							"<Currency>"+ProductCurrency+"</Currency>\n" +
						"</ProductsInfo>" ;
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting ProductType"+ e.getMessage());
					e.printStackTrace();
				}
				
				String FirstName=objCustBean.getFirstName().trim();
				String MidName=objCustBean.getMiddleName().trim();
				String LstName=objCustBean.getLastName().trim();
				String CustomerName="";
				
				if (MidName.equalsIgnoreCase(""))
					CustomerName = FirstName + ' ' + LstName;
				else	
					CustomerName = FirstName + ' ' + MidName + ' ' + LstName;
				 
				
				String Demographic=objCustBean.getDemographic().trim();			
				String DemographicXml = "";
				try {
					if (!Demographic.equalsIgnoreCase(""))
					{
						RAOPCBSLog.RAOPCBSLogger.debug("Demographic value: "+Demographic);
						if (Demographic.contains("|"))
							Demographic = Demographic.replace("|","','");
						
						RAOPCBSLog.RAOPCBSLogger.info("Fetching Demographic::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT countryName FROM USR_0_BPM_COUNTRY_MASTER WITH(NOLOCK) WHERE countryCode in ('"+Demographic+"') AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For Demographic "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for Demographic  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of Demographic "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								String dem = objXmlParser.getValueOf("countryName");
								DemographicXml = DemographicXml + "<Demographic>"+dem.trim()+"</Demographic>\n";
							}
						}
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting Demographic"+ e.getMessage());
					e.printStackTrace();
				}
				
				String Nationality = objCustBean.getNationality().trim();
				String SecNationality = objCustBean.getSecondNationality().trim();
				String NationalityXml = "";
				try {
					if(!Nationality.equalsIgnoreCase(""))
					{
						RAOPCBSLog.RAOPCBSLogger.info("Fetching Nationality::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT countryName FROM USR_0_BPM_COUNTRY_MASTER WITH(NOLOCK) WHERE countryCode in ('"+Nationality+"','"+SecNationality+"') AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For Nationality "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for Nationality  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of Nationality "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								String dem = objXmlParser.getValueOf("countryName");
								NationalityXml = NationalityXml+"<Nationality>"+dem.trim()+"</Nationality>\n";
							}
						}
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting Nationality"+ e.getMessage());
					e.printStackTrace();
				}
				
				String CustCategory = objCustBean.getCustomerCategory().trim();
				try {
					if(!CustCategory.equalsIgnoreCase(""))
					{
						RAOPCBSLog.RAOPCBSLogger.info("Fetching CustCategory::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT top 1 CUSTCATEGORY FROM USR_0_BPM_CUSTOMER_CATEGORY WITH(NOLOCK) WHERE CUSTCODE = '"+CustCategory+"' AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For CustCategory "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for CustCategory  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of CustCategory "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								CustCategory = objXmlParser.getValueOf("CUSTCATEGORY");
							}
						}
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting CustCategory"+ e.getMessage());
					e.printStackTrace();
				}
				
				String CustSegment = objCustBean.getCustomerSegment().trim();
				try {
					if(!CustSegment.equalsIgnoreCase(""))
					{
						
						RAOPCBSLog.RAOPCBSLogger.info("Fetching CustSegment::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT top 1 SEGMENT_DESCRIPTION FROM USR_0_RAOP_CUSTOMER_SEGMENT WITH(NOLOCK) WHERE SEGMENT_CODE = '"+CustSegment+"' AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For CustSegment "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for CustSegment  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of CustSegment "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								CustSegment = objXmlParser.getValueOf("SEGMENT_DESCRIPTION");
							}
						}
						
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting CustSegment"+ e.getMessage());
					e.printStackTrace();
				}
				
				String CustSubSegment = objCustBean.getCustomerSubSegment().trim();
				try {
					if(!CustSubSegment.equalsIgnoreCase(""))
					{
						RAOPCBSLog.RAOPCBSLogger.info("Fetching CustSubSegment::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT top 1 SUBSEGMENT_DESCRIPTION FROM USR_0_RAOP_CUSTOMER_SUBSEGMENT WITH(NOLOCK) WHERE SUBSEGMENT_CODE = '"+CustSubSegment+"' AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For CustSubSegment "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for CustSubSegment  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of CustSubSegment "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								CustSubSegment = objXmlParser.getValueOf("SUBSEGMENT_DESCRIPTION");
							}
						}
						
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting CustSubSegment"+ e.getMessage());
					e.printStackTrace();
				}
				
				String IndSubSegment = objCustBean.getIndustrySubSegment().trim();
				try {
					if(!IndSubSegment.equalsIgnoreCase(""))
					{
						
						RAOPCBSLog.RAOPCBSLogger.info("Fetching IndSubSegment::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT top 1 INDUSTRYSUBSEGTYPE FROM USR_0_BPM_INDUSTRY_SUBSEGMENT WITH(NOLOCK) WHERE INDSUBSEGCODE = '"+IndSubSegment+"' AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For IndSubSegment "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for IndSubSegment  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of IndSubSegment "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								IndSubSegment = objXmlParser.getValueOf("INDUSTRYSUBSEGTYPE");
							}
						}
						
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting IndSubSegment"+ e.getMessage());
					e.printStackTrace();
				}
				
				String employmentType = objCustBean.getEmployeeType().trim();
				try {
					if(!employmentType.equalsIgnoreCase(""))
					{
						RAOPCBSLog.RAOPCBSLogger.info("Fetching employmentType::"+ objCustBean.getWiName());
						String sqlQuery = "SELECT top 1 EmpTypeDisplay FROM USR_0_BPM_EMPLOYMENT_TYPE WITH(NOLOCK) WHERE EmpCode = '"+employmentType+"' AND ISACTIVE='Y'";
						String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For employmentType "+InputXML);
						String outputXML = RAOPCBS.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
						RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for employmentType  "+outputXML);
	
						XMLParser xmlParser=new XMLParser();
						xmlParser.setInputXML(outputXML);
						String mainCode =xmlParser.getValueOf("MainCode");
						
						if("0".equals(mainCode))
						{
							int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
							RAOPCBSLog.RAOPCBSLogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of employmentType "+countofrecords);
							for(int j=0; j<countofrecords; j++)
							{
								String subXML = xmlParser.getNextValueOf("Record");
								XMLParser objXmlParser = new XMLParser(subXML);
								employmentType = objXmlParser.getValueOf("EmpTypeDisplay");
							}
						}
						
					}
				}catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting employmentType"+ e.getMessage());
					e.printStackTrace();
				}
				
				String isPEP = objCustBean.getPEP().trim();
				if (isPEP.equalsIgnoreCase("NPEP") || isPEP.equalsIgnoreCase(""))
					isPEP = "N";
				else
					isPEP = "Y";
				
				java.util.Date d1 = new Date();
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
				String DateExtra2 = sdf1.format(d1)+"+04:00";
				
			finalXml = "<EE_EAI_MESSAGE>\n"+
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
					"<Extra2>"+DateExtra2+"</Extra2>\n"+
					"</EE_EAI_HEADER>\n"+
					"<RiskScoreDetailsRequest>\n" + ReferenceCifId +
					"<RequestInfo>\n" +
						"<RequestType>Reference Id</RequestType>\n" +
						"<RequestValue>"+objCustBean.getWiName()+"</RequestValue>\n" +
					"</RequestInfo>\n" +
					"<ReqSrc>YAP</ReqSrc>\n" +
					"<CustomerType>Individual</CustomerType>\n" + 
					"<CustomerCategory>"+CustCategory+"</CustomerCategory>\n" + 
					"<IsPoliticallyExposed>"+isPEP+"</IsPoliticallyExposed>\n" + 
					"<CustomerName>"+CustomerName+"</CustomerName>\n" + 
					"<EmploymentType>"+employmentType+"</EmploymentType>\n" + 
					"<Segment>"+CustSegment+"</Segment> \n" +
					"<SubSegment>"+CustSubSegment+"</SubSegment> \n" +
					"<Demographics>\n" +
						DemographicXml + 
					"</Demographics>\n" +
					"<Nationalities>\n" +
						NationalityXml +
					"</Nationalities>\n" +
					"<Industries>\n" +
						"<Industry>"+IndSubSegment+"</Industry>\n" +
					"</Industries>\n" +
					ProductsInfoXml + "\n" +
					"</RiskScoreDetailsRequest>\n" +
					"</EE_EAI_MESSAGE>";
		
		}
		catch(Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting inputxml Risk Score"+ e.getMessage());
			e.printStackTrace();
		}
		return finalXml;
	}
	
	public String GetDocumentsList(String itemindex , String sessionId,String cabinetName,String jtsIP,String jtsPort)
	{
		RAOPCBSLog.RAOPCBSLogger.info("Inside GetDocumentsList Method ...");
		XMLParser docXmlParser = new XMLParser();
		String mainCode="";
		String response="F";
		String outputXML ="";
		try
		{

			String sInputXML = getDocumentList(itemindex, sessionId, cabinetName);
			RAOPCBSLog.RAOPCBSLogger.debug(" Inputxml to get document names for "+itemindex+ " "+sInputXML);

			outputXML = RAOPCBS.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
			RAOPCBSLog.RAOPCBSLogger.debug(" outputxml to get document names for "+ itemindex+ " "+outputXML);
			docXmlParser.setInputXML(outputXML);
			mainCode = docXmlParser.getValueOf("Status");

			if(mainCode.equals("0"))
			{
				response=outputXML;
			}

		}
		catch (Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("Exception occured in GetDocumentsList method : "+e);

			response ="F";
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
		}
		return response;

	}

	public String getDocumentList(String folderIndex, String sessionId, String cabinetName)
	{

		//folderIndex="26979";   //only for testing

		String xml = "<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input>" +
				"<Option>NGOGetDocumentListExt</Option>" +
				"<CabinetName>"+cabinetName+"</CabinetName>" +
				"<UserDBId>"+sessionId+"</UserDBId>" +
				"<CurrentDateTime></CurrentDateTime>" +
				"<FolderIndex>"+folderIndex+"</FolderIndex>" +
				"<DocumentIndex></DocumentIndex>" +
				"<PreviousIndex>0</PreviousIndex>" +
				"<LastSortField></LastSortField>" +
				"<StartPos>0</StartPos>" +
				"<NoOfRecordsToFetch>1000</NoOfRecordsToFetch>" +
				"<OrderBy>5</OrderBy><SortOrder>A</SortOrder><DataAlsoFlag>N</DataAlsoFlag>" +
				"<AnnotationFlag>Y</AnnotationFlag><LinkDocFlag>Y</LinkDocFlag>" +
				"<PreviousRefIndex>0</PreviousRefIndex><LastRefField></LastRefField>" +
				"<RefOrderBy>2</RefOrderBy><RefSortOrder>A</RefSortOrder>" +
				"<NoOfReferenceToFetch>1000</NoOfReferenceToFetch>" +
				"<DocumentType>B</DocumentType>" +
				"<RecursiveFlag>N</RecursiveFlag><ThumbnailAlsoFlag>N</ThumbnailAlsoFlag>" +
				"</NGOGetDocumentListExt_Input>";

		return xml;
	}

	public String DownloadDocument(XMLParser xmlParser,String winame,String docName,String docExt, String account_no,String cabinetName,String jtsIp,String smsPort,String docDownloadPath,String volumeId,String siteId)
	{
		RAOPCBSLog.RAOPCBSLogger.debug("Inside DownloadDocument Method...");

		String status="F";
		String msg="Error";
		StringBuffer strFilePath = new StringBuffer();
		try
		{

			String base64String = null;
			String imageIndex = xmlParser.getValueOf("ISIndex").substring(0, xmlParser.getValueOf("ISIndex").indexOf("#"));

			strFilePath.append(System.getProperty("user.dir"));
			strFilePath.append(File.separator);
			strFilePath.append(strDocDownloadPath);
			strFilePath.append(File.separatorChar);
			strFilePath.append(winame);
			strFilePath.append("_");
			strFilePath.append(docName);
			strFilePath.append(".");
			strFilePath.append(docExt);

			CImageServer cImageServer=null;
			try
			{
				cImageServer = new CImageServer(null, jtsIp, Short.parseShort(smsPort));
			}
			catch (JPISException e)
			{
				e.printStackTrace();
				msg = e.getMessage();
				status="F";
			}
			RAOPCBSLog.RAOPCBSLogger.debug("values passed -> "+ jtsIp+" "+smsPort+" "+cabinetName+" "+volumeId+" "+siteId+" "+imageIndex+" "+strFilePath.toString());
			RAOPCBSLog.RAOPCBSLogger.debug("signature document name and imageindex for "+winame+" "+docName+","+imageIndex);

			RAOPCBSLog.RAOPCBSLogger.debug("Fetching OD Download Code ::::::");
			int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,jtsIp, Short.parseShort(smsPort), cabinetName, Short.parseShort(siteId),Short.parseShort(volumeId), Integer.parseInt(imageIndex),"",strFilePath.toString(),new JPDBString());

			RAOPCBSLog.RAOPCBSLogger.debug("OD Download Code :"+odDownloadCode);
			RAOPCBSLog.RAOPCBSLogger.debug("strFilePath.toString() :"+strFilePath.toString());

			if(odDownloadCode==1)
			{
				try
				{
					base64String=ConvertToBase64.convertToBase64((strFilePath.toString()).trim());
					//RAOPCBSLog.RAOPCBSLogger.debug("base64String -----" +base64String);
					deleteDownloadedSignature(strFilePath.toString().trim());
					status=base64String;

				}
				catch(Exception e)
				{
					RAOPCBSLog.RAOPCBSLogger.debug("Exception in converting image to Base64 for "+ winame+" "+docName+","+imageIndex);

					msg=e.getMessage();
					status="F";
				}

			}
			else
			{
				RAOPCBSLog.RAOPCBSLogger.debug("Error in downloading document for "+ winame+" docname "+docName+", imageindex "+imageIndex);

				msg="Error occured while downloading the document :"+docName;
				status="F";
			}
		}
		catch (Exception e)
		{
			RAOPCBSLog.RAOPCBSLogger.error("Exception occured in DownloadDocument method : "+e);

			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			msg=e.getMessage();
			status="F";
		}

		return status;

	}

	public void deleteDownloadedSignature(String path)
	{
		File file = new File(path);
        if(file.delete()){
            RAOPCBSLog.RAOPCBSLogger.debug("Downloaded Signture file has been deleted");
        }
        else
        {
        	RAOPCBSLog.RAOPCBSLogger.error("Error in deleting the downloaded signature");
        }

	}

	public String getSignatureUploadXML(String base64String,String ACCNO,String CIFID,String DATE, String CustomerName,String userName, String sessionId, String cabinetName, String Sig_Remarks)
	{
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";
		
		String integrationXML = "<EE_EAI_MESSAGE>" +
			   "<EE_EAI_HEADER>" +
				  "<MsgFormat>SIGNATURE_ADDITION_REQ</MsgFormat>" +
				  "<MsgVersion>0001</MsgVersion>" +
				  "<RequestorChannelId>BPM</RequestorChannelId>" +
				  "<RequestorUserId>RAKUSER</RequestorUserId>" +
				  "<RequestorLanguage>E</RequestorLanguage>" +
				  "<RequestorSecurityInfo>secure</RequestorSecurityInfo>" +
				  "<ReturnCode>911</ReturnCode>" +
				  "<ReturnDesc>Issuer Timed Out</ReturnDesc>" +
				  "<MessageId>UniqueMessageId123</MessageId>" +
				  "<Extra1>REQ||SHELL.JOHN</Extra1>" +
				  "<Extra2>"+DateExtra2+"</Extra2>" +
			   "</EE_EAI_HEADER>" +
			   "<SignatureAddReq>" +
				  "<BankId>RAK</BankId>" +
				  "<AcctId>"+ACCNO+"</AcctId>" +
				  "<AccType>N</AccType>" +
				  "<CustId>"+CIFID+"</CustId>" +
				  "<BankCode></BankCode>" +
				  "<EmpId></EmpId>" +
				  "<CustomerName>"+CustomerName+"</CustomerName>" +
				  "<SignPowerNumber></SignPowerNumber>" +
				  "<ImageAccessCode>1</ImageAccessCode>" +
				  "<SignExpDate>2112-03-06T23:59:59.000</SignExpDate>" +
				  "<SignEffDate>2010-12-31T23:59:59.000</SignEffDate>" +
				  "<SignFile>"+base64String+"</SignFile>" +
				  "<PictureExpDate>2099-12-31T23:59:59.000</PictureExpDate>" +
				  "<PictureEffDate>2010-12-31T23:59:59.000</PictureEffDate>" +
				  "<PictureFile></PictureFile>" +
				  "<SignGroupId>SVSB11</SignGroupId>" +
				  "<Remarks>"+Sig_Remarks+"</Remarks>" +
			   "</SignatureAddReq>" +
			"</EE_EAI_MESSAGE>";


		return integrationXML;
	}

	public String calculateKYCReviewDate(String rscore)
	{
		String ExpDate = "";
		try 
		{
			if (!rscore.contains("."))
				rscore = rscore+".00";
			double riskscore = Float.parseFloat(rscore);
			String risktype = "";
			
			java.util.Date d1 = new Date();
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			String currDate = sdf1.format(d1);
			if (riskscore >= 1 && riskscore < 2 )
	        {
	          risktype = "Low";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(3);
	          ExpDate = addedDate.toString();
	          RAOPCBSLog.RAOPCBSLogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 2 && riskscore < 3)
	        {
	          risktype = "Standard";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(2);
	          ExpDate = addedDate.toString();
	          RAOPCBSLog.RAOPCBSLogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 3 && riskscore < 4)
	        {
	          risktype = "Medium";
	          LocalDate addedDate = LocalDate.parse(currDate).plusMonths(18);
	          ExpDate = addedDate.toString();
	          RAOPCBSLog.RAOPCBSLogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 4 && riskscore < 5)
	        {
	          risktype = "High";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(1);
	          ExpDate = addedDate.toString();
	          RAOPCBSLog.RAOPCBSLogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 5)
	        {
	          risktype = "Elevated";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(1);
	          ExpDate = addedDate.toString();
	          RAOPCBSLog.RAOPCBSLogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return ExpDate;
	}
}