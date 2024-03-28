package com.newgen.iforms.user;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.xmlapi.IFormXmlResponse;
import com.sun.org.apache.bcel.internal.generic.AALOAD;


public class KYC_Remediation__FormLoad extends KYC_Remediation_Common {

	public String formLoadEvent(IFormReference iform, String controlName, String event, String data) {
		try{
			KYC_Remediation.mLogger.debug("This is KYC_Remediation_Event" + event + " controlName :" + controlName);
			String Workstep = iform.getActivityName();
			String loggedInUser = iform.getUserName();
			iform.setValue("LoggedInUser", loggedInUser);
			KYC_Remediation.mLogger.debug("WINAME : " + getWorkitemName(iform) + ", WSNAME: " + iform.getActivityName()
			+ ", Workstep :" + Workstep);
			String caseType = (String)iform.getValue("CaseType");
			if(("Individual").equalsIgnoreCase(caseType)){
				iform.setValue("label8","KYC Remediation Retail");
				iform.setStyle("frame13","visible","false");
				iform.setStyle("frame11","visible","false");
				iform.setStyle("frame12","visible","false");
				iform.setStyle("frame14","visible","false");
				iform.setStyle("evidenceOnSourceOfFunds","visible","false");
				iform.setStyle("KYC_Review_Date","visible","false");
				iform.setStyle("CountriesDealingWith","visible","false");
				iform.setStyle("Top5Suppliers","visible","false");
				iform.setStyle("Top5Buyers","visible","false");
				iform.setStyle("VAT_RegistrationNo","visible","false");
				iform.setStyle("CorporateTax","visible","false");
				iform.setStyle("DNFBP_Status","visible","false");
				iform.setStyle("NoOfEmployees","visible","false");
				iform.setStyle("AnnualTurnover","visible","false");
				iform.setStyle("Subsidiaries_Name","visible","false");
				iform.setStyle("Subsidiaries_Business","visible","false");
				iform.setStyle("SubsidiaryCountryOfOperation","visible","false");
				iform.setStyle("NetWorth","visible","false");
				iform.setStyle("HawalaActivity","visible","false");
				iform.setStyle("HawalaServiceProvider","visible","false");
				iform.setStyle("CorporateTaxRegDate","visible","false");
				iform.setStyle("DownstreamServiceVASP","visible","false");
				iform.setStyle("ShareholderUSperson","visible","false");
				iform.setStyle("UScitizenship_ResidencyDetails","visible","false");
				iform.setStyle("Certify","visible","false");
				iform.setStyle("NotTaxResident","visible","false");
				iform.setStyle("NoTINreason","visible","false");
				iform.setStyle("EntityOrganisedInUSA","visible","false");
				iform.setStyle("label7","visible","false");
				iform.setStyle("ActiveNFE","visible","false");
				iform.setStyle("PassiveNFE","visible","false");
				iform.setStyle("FinancialInstitution","visible","false");
				iform.setStyle("SecuritiesMarket","visible","false");
				iform.setStyle("RelatedEntity","visible","false");
				iform.setStyle("GIIN","visible","false");	
				iform.setStyle("AccountInformation","visible","false");
				iform.setStyle("DoYouMaintainAccount","visible","false");
				iform.setStyle("LengthOfBusinessRelationship","visible","false");
				iform.setStyle("ShareholderSection","visible","false");
				//bug 92 and 30
				String residenceCountry = (String)iform.getValue("ResidenceCountry");
				if("AE".equalsIgnoreCase(residenceCountry)){
					iform.setStyle("ResidenceEmirateCity","visible","false");
					iform.setStyle("ResidenceEmirate","visible","true");
				}
				else{
					iform.setStyle("ResidenceEmirateCity","visible","true");
					iform.setStyle("ResidenceEmirate","visible","false");
				}
				
				String persona = (String)iform.getValue("CIFPersona");
				KYC_Remediation.mLogger.debug("persona----->"+persona);
				if("Self Employed - Non Resident".equalsIgnoreCase(persona.trim()) || "Self Employed - Resident".equalsIgnoreCase(persona.trim()) || "Ruling Family".equalsIgnoreCase(persona.trim()) || "Loan Only Customers".equalsIgnoreCase(persona.trim()) || "Credit Card Only".equalsIgnoreCase(persona.trim())){
					iform.setStyle("CountryOfOperation","visible","true");
				}
				else{
					iform.setStyle("CountryOfOperation","visible","false");
				}
				if ("Self Employed - Non Resident".equalsIgnoreCase(persona.trim()) || "Self Employed - Resident".equalsIgnoreCase(persona.trim())){
					KYC_Remediation.mLogger.debug("Inside if block ofpersona----->"+persona);
					iform.setStyle("label2","visible","true");
					iform.setStyle("BusinessAddress","visible","true");
					iform.setStyle("BusinessCountry","visible","true");
					iform.setStyle("BusinessFlatVillaNo","visible","true");
					iform.setStyle("BusinessEmirateCity","visible","true");
				}
				else{
					KYC_Remediation.mLogger.debug("Inside else block of persona----->"+persona);
					iform.setStyle("label2","visible","false");
					iform.setStyle("BusinessAddress","visible","false");
					iform.setStyle("BusinessCountry","visible","false");
					iform.setStyle("BusinessFlatVillaNo","visible","false");
					iform.setStyle("BusinessEmirateCity","visible","false");
				}
				
				if("Maker".equalsIgnoreCase(Workstep)){
					String city = (String)iform.getValue("ResidenceEmirateCity");
					KYC_Remediation.mLogger.debug("city----->"+city);
					String Emirate = (String)iform.getValue("ResidenceEmirate");
					KYC_Remediation.mLogger.debug("Emirate----->"+Emirate);
					if("AE".equalsIgnoreCase(residenceCountry) && !("".equalsIgnoreCase(city)) && "".equalsIgnoreCase(Emirate)){
						KYC_Remediation.mLogger.debug("inside if for setting emirate in dropdown");
						iform.setValue("ResidenceEmirate",city);
					}					
				}
			}
			else if(("Corporate").equalsIgnoreCase(caseType)){
				iform.setValue("label8","KYC Remediation Entity");
				iform.setStyle("frame1","visible","false");
				iform.setStyle("frame2","visible","false");
				iform.setStyle("frame3","visible","false");
				iform.setStyle("frame14","visible","false");
				iform.setStyle("table12","visible","false");
				iform.setStyle("table13","visible","false");
				iform.setStyle("MonthlyIncome","visible","false");
				iform.setStyle("OtherSourceOfIncome","visible","false");
				iform.setStyle("OtherIncome","visible","false");
				iform.setStyle("GrossMonthlyIncome","visible","false");
				iform.setStyle("OfficeOccupation","visible","false");
				iform.setStyle("EstimatedWealth","visible","false");
				iform.setStyle("ProfEmpHistoryHekdFlag","visible","false");
				iform.setStyle("ListCountryMoneyToSent","visible","false");
				iform.setStyle("ListCountryMoneyToReceived","visible","false");
				iform.setStyle("CountryOfIncorporation","visible","false");
				//iform.setStyle("PEP","visible","false");
				iform.setStyle("IndustrySegment","visible","false");
				iform.setStyle("IndustrySubSegment","visible","false");
				iform.setStyle("CustomerClassification","visible","false");
				
				//iform.setStyle("DetailsOfPEP","visible","false");
				iform.setStyle("SourceOfWealth","visible","false");
				iform.setStyle("KYC_Review_Date","visible","false");
				//fatca
				
				iform.setStyle("ShareholderUSperson","visible","false");
				iform.setStyle("PlaceOfBirthUSA","visible","false");
				iform.setStyle("CurrentUSmailingOrResidenceAddress","visible","false");
				iform.setStyle("UStelephoneNumber","visible","false");
				
				iform.setStyle("StandingInstructions","visible","false");
				iform.setStyle("PowerOfAttorney","visible","false");
				iform.setStyle("USholdMailAddress","visible","false");
				iform.setStyle("UScitizenship_ResidencyDetails","visible","false");
				
				iform.setStyle("Certify","visible","false");
				iform.setStyle("USpassportHolder_GreencardHolder","visible","false");
				iform.setStyle("TIN_Field","visible","false");
				
				iform.setStyle("NotTaxResident","visible","false");
				iform.setStyle("FormObtained","visible","false");
				
				iform.setStyle("SignedDate","visible","false");
				iform.setStyle("ExpiryDate","visible","false");
				iform.setStyle("NoTINreason","visible","false");
				
			}
			else if(("RelatedParty").equalsIgnoreCase(caseType)){
				iform.setStyle("DECISION","mandatory","false");
				iform.setStyle("Remarks","mandatory","false");
				iform.setValue("label8","KYC Remediation Related Party");
				iform.setStyle("ShareholderSection","visible","false");
				iform.setStyle("frame11","visible","false");
				iform.setStyle("frame12","visible","false");
				iform.setStyle("frame13","visible","false");
				iform.setStyle("frame1","visible","false");
				iform.setStyle("frame2","visible","false");
				iform.setStyle("frame3","visible","false");
				iform.setStyle("frame6","visible","false");
				iform.setStyle("frame7","visible","false");
				iform.setStyle("OfficeOccupation","visible","false");
				iform.setStyle("CountryOfIncorporation","visible","false");
				// fatca
				iform.setStyle("EntityOrganisedInUSA","visible","false");
				iform.setStyle("label7","visible","false");
				iform.setStyle("ActiveNFE","visible","false");
				iform.setStyle("PassiveNFE","visible","false");
				iform.setStyle("FinancialInstitution","visible","false");
				iform.setStyle("SecuritiesMarket","visible","false");
				iform.setStyle("RelatedEntity","visible","false");
				iform.setStyle("GIIN","visible","false");
				iform.setStyle("Risk_score_trigger","visible","false");
				
				iform.setStyle("evidenceOnSourceOfFunds","visible","false");
				iform.setStyle("KYC_Review_Date","visible","false");
				iform.setStyle("CountriesDealingWith","visible","false");
				iform.setStyle("Top5Suppliers","visible","false");
				iform.setStyle("Top5Buyers","visible","false");
				iform.setStyle("VAT_RegistrationNo","visible","false");
				iform.setStyle("CorporateTax","visible","false");
				iform.setStyle("DNFBP_Status","visible","false");
				iform.setStyle("NoOfEmployees","visible","false");
				iform.setStyle("AnnualTurnover","visible","false");
				iform.setStyle("Subsidiaries_Name","visible","false");
				iform.setStyle("Subsidiaries_Business","visible","false");
				iform.setStyle("SubsidiaryCountryOfOperation","visible","false");
				iform.setStyle("NetWorth","visible","false");
				iform.setStyle("HawalaActivity","visible","false");
				iform.setStyle("HawalaServiceProvider","visible","false");
				iform.setStyle("CorporateTaxRegDate","visible","false");
				iform.setStyle("AccountInformation","visible","false");
				iform.setStyle("DoYouMaintainAccount","visible","false");
				iform.setStyle("EstimatedWealth","visible","false");
				iform.setStyle("ExpectedMonthlyCreditTurnover","visible","false");
				
				iform.setStyle("MonthlyCashCRturnover","visible","false");
				iform.setStyle("MonthlyCashNoonCRturnover","visible","false");
				iform.setStyle("HighestCashCRtransaction","visible","false");
				iform.setStyle("HighestNonCashCrTransaction","visible","false");
				iform.setStyle("ProfEmpHistoryHekdFlag","visible","false");
				iform.setStyle("PurposeOfAccount","visible","false");
				iform.setStyle("table12","visible","false");
				iform.setStyle("table13","visible","false");
				iform.setStyle("DownstreamServiceVASP","visible","false");
				iform.setStyle("MonthlyIncome","visible","false");
				iform.setStyle("OtherSourceOfIncome","visible","false");
				iform.setStyle("OtherIncome","visible","false");
				iform.setStyle("GrossMonthlyIncome","visible","false");
				
				//JIRA 200
				iform.setStyle("IndustrySegment","visible","false");
				iform.setStyle("CustomerClassification","visible","false");
				iform.setStyle("IndustrySubSegment","visible","false");
				
				
				
				
				
				
					KYC_Remediation.mLogger.debug("Updating back to RelatedParty");
					IFormXmlResponse xmlParserData = new IFormXmlResponse();
					StringBuffer ipXMLBuffer=new StringBuffer();
					String sCabname = getCabinetName(iform);
					KYC_Remediation.mLogger.debug("sCabname" + sCabname);
					String sSessionId = getSessionId(iform);
					KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
					/*int rowIndex = Integer.parseInt(data);
					String WINAme = iform.getTableCellValue("table4",rowIndex,1);*/
					String WINAME = getWorkitemName(iform);
					
					String columnNames="VAR_STR1";
					String columnValues="'RelatedParty'";
					String sWhereClause ="ProcessInstanceID ='"+WINAME+"' ";
					
					ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
					ipXMLBuffer.append("<APUpdate_Input>\n");
					ipXMLBuffer.append("<Option>APUpdate</Option>\n");
					ipXMLBuffer.append("<TableName>");
					ipXMLBuffer.append("WFINSTRUMENTTABLE");
					ipXMLBuffer.append("</TableName>\n");
					ipXMLBuffer.append("<ColName>");
					ipXMLBuffer.append(columnNames);
					ipXMLBuffer.append("</ColName>\n");
					ipXMLBuffer.append("<Values>");
					ipXMLBuffer.append(columnValues);
					ipXMLBuffer.append("</Values>\n");
					ipXMLBuffer.append("<WhereClause>");
					ipXMLBuffer.append(sWhereClause);
					ipXMLBuffer.append("</WhereClause>\n");
					ipXMLBuffer.append("<EngineName>");
					ipXMLBuffer.append(sCabname);
					ipXMLBuffer.append("</EngineName>\n");
					ipXMLBuffer.append("<SessionId>");
					ipXMLBuffer.append(sSessionId);
					ipXMLBuffer.append("</SessionId>\n");
					ipXMLBuffer.append("</APUpdate_Input>");
					
					String apUpdateinput = ipXMLBuffer.toString();
					KYC_Remediation.mLogger.debug("apUpdateinput--->"+apUpdateinput);
					String OutputXML = ExecuteQueryOnServer(apUpdateinput, iform);
					KYC_Remediation.mLogger.debug("sOutputXML--->"+OutputXML);
			}
			
			//start here
			String CustomerSubsegmentCode = (String)iform.getValue("Customer_Subsegment");
			if("SME".equalsIgnoreCase(CustomerSubsegmentCode) || "PSL".equalsIgnoreCase(CustomerSubsegmentCode)) 
			{
				iform.setValue("subSegment","BBG");
			}
			else if ("CBD".equalsIgnoreCase(CustomerSubsegmentCode))
			{
				iform.setValue("subSegment","WBG");
			}
			else{
				iform.setValue("subSegment","PBG");
			}
			// stop here
			
			if("RM_Vendor".equalsIgnoreCase(Workstep)){
				iform.setValue("RMvendorUser",loggedInUser);
			}
			if("Compliance".equalsIgnoreCase(Workstep)){
				iform.setValue("ComplianceUser",loggedInUser);
			}
			if("Maker".equalsIgnoreCase(Workstep)){
				iform.setValue("MakerUser",loggedInUser);
			}
		iform.setValue("DECISION","");
		iform.setValue("Remarks","");	
		iform.clearCombo("DECISION");
		String query = "Select Decision FROM NG_MASTER_KYC_REM_Decision WHERE WorkstepName = '"+Workstep+"'";
		List<List<String>> dataFromDB = iform.getDataFromDB(query);
		for(List<String> listValue : dataFromDB){
			for(String valueIs : listValue){
				KYC_Remediation.mLogger.debug("Value is --"+valueIs);
				iform.addItemInCombo("DECISION", valueIs);
			}
		}
		KYC_Remediation.mLogger.debug("Disabling frames if workstep not maker");
		if("RM_Vendor".equalsIgnoreCase(Workstep) || "Compliance".equalsIgnoreCase(Workstep) || "Approver".equalsIgnoreCase(Workstep) || "Controls".equalsIgnoreCase(Workstep)){
			iform.setStyle("frame1","disable","true");
			iform.setStyle("frame2","disable","true");
			iform.setStyle("frame3","disable","true");
			iform.setStyle("frame4","disable","true");
			//iform.setStyle("frame13","disable","true");
			iform.setStyle("frame11","disable","true");
			iform.setStyle("frame12","disable","true");
			iform.setStyle("frame9","disable","true");
			iform.setStyle("frame14","disable","true");
			iform.setStyle("ShareholderSection","disable","true");
			iform.setStyle("Risk_score_trigger","disable","true");
		}
		
		if("Corporate".equalsIgnoreCase("caseType"))
		{
			iform.setStyle("frame13","visible","true");
			iform.setStyle("frame11","visible","true");
			iform.setStyle("frame12","visible","true");	
		}
		
		String strReturn = "";
		String persona = (String) iform.getValue("CIFPersona");
		persona = persona.trim();
		persona = persona.replaceAll(" ", "");
		KYC_Remediation.mLogger.debug("persona - "+persona);
		String cusType = (String) iform.getValue("CusType");
		cusType = cusType.trim();
		KYC_Remediation.mLogger.debug("cusType - "+cusType);
		Properties properties = new Properties();
		properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")+ "CustomConfig" + System.getProperty("file.separator")+ "KYC_Remediation" + System.getProperty("file.separator")+ "KYC_Config.properties"));
		String tag = cusType+"_"+persona;
		tag = tag.trim();
		KYC_Remediation.mLogger.debug("tag - "+tag);
		String mandatoryFields = properties.getProperty(tag);
		KYC_Remediation.mLogger.debug("mandatoryFields - "+mandatoryFields);
		String[] mandatoryField = mandatoryFields.split(",");
		for(String field : mandatoryField){
			KYC_Remediation.mLogger.debug("setting mandatory");
			iform.setStyle(field,"backcolor","#ffc1c175");
			//iform.setStyle(field,"mandatory","true");
		}
		return strReturn;
		}catch(Exception e){
			KYC_Remediation.mLogger.debug("Error in formload event");
			KYC_Remediation.mLogger.debug("Exception - "+e.toString());
		}
		return "";
	}
	

}
