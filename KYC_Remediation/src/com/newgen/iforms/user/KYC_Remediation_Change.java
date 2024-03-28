package com.newgen.iforms.user;

import java.io.FileInputStream;
import java.util.List;
import java.util.Properties;

import com.newgen.iforms.custom.IFormReference;

public class KYC_Remediation_Change extends KYC_Remediation_Common {

	public String changeEvent(IFormReference iform, String controlName, String event, String data) {
		String Workstep = iform.getActivityName();
		try{
			if("DECISION".equalsIgnoreCase(controlName)){
				String Decision = (String) iform.getValue("DECISION");
			if("Maker".equalsIgnoreCase(Workstep) && "Submit to Approver".equalsIgnoreCase(Decision)){
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
				iform.setStyle(field,"mandatory","true");
			}
		   }
			else
			{
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
					iform.setStyle(field,"mandatory","false");
				}
			}
		}
			else if("OtherSourceOfIncome".equalsIgnoreCase(controlName)){
				//jira 251
				String sourceOfIncome = (String)iform.getValue("OtherSourceOfIncome");
				KYC_Remediation.mLogger.debug("sourceOfIncome---"+sourceOfIncome);
				if(!sourceOfIncome.equalsIgnoreCase("")){
					KYC_Remediation.mLogger.debug("inside if of source of income");
					iform.setStyle("OtherIncome","mandatory","true");
				}
				else{
					KYC_Remediation.mLogger.debug("inside else of source of income");
					iform.setStyle("OtherIncome","mandatory","false");
					iform.setValue("OtherIncome", "");
				}		
			}
			
			else if(controlName.equalsIgnoreCase("CIFPersona")){
				String persona = (String)iform.getValue("CIFPersona");
				KYC_Remediation.mLogger.debug("persona----->"+persona);
				// setting mandatory fields
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
				String nonMandatoryFields = properties.getProperty("NonMandatory");
				String nonMandatoryField[] = nonMandatoryFields.split(",");
				for(String field : nonMandatoryField){
					iform.setStyle(field,"backcolor","#fcfcff");
					iform.setStyle(field,"mandatory","false");
					iform.setValue("DECISION","");
				}
				String mandatoryFields = properties.getProperty(tag);
				KYC_Remediation.mLogger.debug("mandatoryFields - "+mandatoryFields);
				String[] mandatoryField = mandatoryFields.split(",");
				for(String field : mandatoryField){
					//KYC_Remediation.mLogger.debug("setting mandatory");
					iform.setStyle(field,"backcolor","#ffc1c175");
				}
				//
				
				
				if("Self Employed - Non Resident".equalsIgnoreCase(persona.trim()) || "Self Employed - Resident".equalsIgnoreCase(persona.trim()) || "Ruling Family".equalsIgnoreCase(persona.trim()) || "Loan Only Customers".equalsIgnoreCase(persona.trim()) || "Credit Card Only".equalsIgnoreCase(persona.trim())){
					iform.setStyle("CountryOfOperation","visible","true");
				}
				else{
					iform.setStyle("CountryOfOperation","visible","false");
				}
				if ("Self Employed - Non Resident".equalsIgnoreCase(persona.trim()) || "Self Employed - Resident".equalsIgnoreCase(persona.trim())){
					KYC_Remediation.mLogger.debug("Inside if block of persona----->"+persona);
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
				if("Housewife - Non Resident".equalsIgnoreCase(persona.trim()) || "Housewife - Resident".equalsIgnoreCase(persona.trim()) || "Minor Account - Non - Resident".equalsIgnoreCase(persona.trim()) || "Minor Account - Resident".equalsIgnoreCase(persona.trim()) || "Students - Resident".equalsIgnoreCase(persona.trim()) || "Students - Non Resident".equalsIgnoreCase(persona.trim())){
					iform.setStyle("OfficeSponsorName", "mandatory", "true");
					iform.setStyle("OfficeSponsorName","backcolor","#ffc1c175");
				}
				else{
					iform.setStyle("OfficeSponsorName", "mandatory", "false");
					iform.setStyle("OfficeSponsorName","backcolor","#fcfcff");
				}
			}
			else if(controlName.equalsIgnoreCase("ResidentCountry")){
				KYC_Remediation.mLogger.debug("Inside ResidentCountry----->"+controlName);
				String residentCountry = (String)iform.getValue("ResidentCountry");
				iform.setValue("ResidenceCountry",residentCountry);
				iform.setValue("OfficeCountry",residentCountry);
				if("AE".equalsIgnoreCase(residentCountry)){
					iform.setStyle("ResidenceEmirateCity","visible","false");
					iform.setValue("ResidenceEmirateCity", "");
					iform.setValue("ResidenceEmirate", "");
					iform.setStyle("ResidenceEmirate","visible","true");
					iform.setValue("CusNonResidentIndicator","No");
					iform.setStyle("CusNonResidentIndicator","disable","true");
				}
				else{
					iform.setStyle("ResidenceEmirate","visible","false");
					iform.setValue("ResidenceEmirate", "");
					iform.setValue("ResidenceEmirateCity", "");
					iform.setStyle("ResidenceEmirateCity","visible","true");
					
					iform.setValue("CusNonResidentIndicator","Yes");
					iform.setStyle("CusNonResidentIndicator","disable","true");
				}
			}
			
			// bug 92 and 30
			else if(controlName.equalsIgnoreCase("ResidenceCountry")){
				KYC_Remediation.mLogger.debug("Inside ResidenceCountry----->"+controlName);
				String residenceCountry = (String)iform.getValue("ResidenceCountry");
				if("AE".equalsIgnoreCase(residenceCountry)){
					iform.setStyle("ResidenceEmirateCity","visible","false");
					iform.setValue("ResidenceEmirate", "");
					iform.setStyle("ResidenceEmirate","visible","true");
					
				}
				else{
					iform.setValue("ResidenceEmirateCity", "");
					iform.setStyle("ResidenceEmirateCity","visible","true");
					iform.setStyle("ResidenceEmirate","visible","false");
				}
				
			}
			
			else if(controlName.equalsIgnoreCase("ResidenceEmirate")){
				String Emirate = (String)iform.getValue("ResidenceEmirate");
				/*String Desc = Emirate;
				String countryDescquery = "Select Distinct E_Desc from NG_KYC_REM_EMIRATE_MASTER where E_Code = '"+Emirate+"'";
				List<List<String>> countryDesc = iform.getDataFromDB(countryDescquery);
				if(!countryDesc.isEmpty()){
				for(List<String> data1 : countryDesc){
					Desc = data1.get(0);
				}
				}*/
				iform.setValue("ResidenceEmirateCity", Emirate);
			}
			
			else if(controlName.equalsIgnoreCase("EmiratedIDcardNumber")){
				String DOB = (String)iform.getValue("DateOfBirth");
				String arrDOB[] = DOB.split("/");
				String year = arrDOB[2];
				String emiratesID = (String)iform.getValue("EmiratedIDcardNumber");
				boolean matchesYear = emiratesID.substring(3,7).equalsIgnoreCase(year);
				if(!matchesYear){
					iform.setValue("EmiratedIDcardNumber","");
					return "incorrectValue";
				}	
			}
			
			else if (controlName.equalsIgnoreCase("GIIN"))
			{
				String GIIN = (String)iform.getValue("GIIN");
				if(!"".equalsIgnoreCase(GIIN)){
					int len = GIIN.length();
					if(len<16){
						iform.setValue("GIIN", "");
						return "GIIN invalid";
					}
				}
			}
		
		}catch(Exception e){
			KYC_Remediation.mLogger.debug("exception in change event -- "+e);
		}
		return "";
	}

}
