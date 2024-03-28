/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP CBS
File Name				: CustomerBean.java
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

public class CustomerBean {

	private String solId;
	private String customerSegment;
	private String customerSubSegment;
	private String industrySegment;
	private String industrySubSegment;
	private String passportNumber;
	private String passportIssDate;
	private String passportExpDate;
	private String visaNumber;
	private String visaIssDate;
	private String visaExpDate;
	private String emiratesId;
	private String emIdExpDate;
	private String isExistingCustomer;
	private String productType;
	private String itemIndex;
	private String iBANNO;
	private String demographic;
	private String pep;
	
	public String getItemIndex() {
		return itemIndex;
	}
	public void setItemIndex(String itemIndex) {
		this.itemIndex = itemIndex;
	}
	public String getProductType() {
		return productType;
	}
	public void setProductType(String productType) {
		this.productType = productType;
	}
	public String getIsExistingCustomer() {
		return isExistingCustomer;
	}
	public void setIsExistingCustomer(String isExistingCustomer) {
		this.isExistingCustomer = isExistingCustomer;
	}
	private String cifId;
	private String productCurrency;
	public String getProductCurrency() {
		return productCurrency;
	}
	public void setProductCurrency(String productCurrency) {
		this.productCurrency = productCurrency;
	}
	public String getCifId() {
		return cifId;
	}
	public void setCifId(String cifId) {
		this.cifId = cifId;
	}
	public String getPassportNumber() {
		return passportNumber;
	}
	public void setPassportNumber(String passportNumber) {
		this.passportNumber = passportNumber;
	}
	public String getPassportIssDate() {
		return passportIssDate;
	}
	public void setPassportIssDate(String passportIssDate) {
		this.passportIssDate = passportIssDate;
	}
	public String getPassportExpDate() {
		return passportExpDate;
	}
	public void setPassportExpDate(String passportExpDate) {
		this.passportExpDate = passportExpDate;
	}
	public String getVisaNumber() {
		return visaNumber;
	}
	public void setVisaNumber(String visaNumber) {
		this.visaNumber = visaNumber;
	}
	public String getVisaIssDate() {
		return visaIssDate;
	}
	public void setVisaIssDate(String visaIssDate) {
		this.visaIssDate = visaIssDate;
	}
	public String getVisaExpDate() {
		return visaExpDate;
	}
	public void setVisaExpDate(String visaExpDate) {
		this.visaExpDate = visaExpDate;
	}
	public String getEmiratesId() {
		return emiratesId;
	}
	public void setEmiratesId(String emiratesId) {
		this.emiratesId = emiratesId;
	}
	public String getEmIdExpDate() {
		return emIdExpDate;
	}
	public void setEmIdExpDate(String emIdExpDate) {
		this.emIdExpDate = emIdExpDate;
	}
	public String getIndustrySegment() {
		return industrySegment;
	}
	public void setIndustrySegment(String industrySegment) {
		this.industrySegment = industrySegment;
	}
	public String getIndustrySubSegment() {
		return industrySubSegment;
	}
	public void setIndustrySubSegment(String industrySubSegment) {
		this.industrySubSegment = industrySubSegment;
	}
	private String employeeType;
	private String residenceAddrLine1;
	private String residenceAddrLine2;
	private String residenceAddrCity;
	private String residenceAddrCountry;
	private String residenceAddrPOBox;
	private String occupation;
	private String customerType;
	private String customerCategory;
	private String employerName;
	private String employerCode;
	private String riskScore;
	private String usRelation;
	private String tinNumber;
	private String fatcaReason;
	private String documentsCollected;
	private String signedDate;
	private String expiryDate;
	private String cityOfBirth;
	private String countryOfBirth;
	private String crsUndocumentedFlag;
	private String crsUndocumentedFlagReason;
	private String wiName;
	public String getWiName() {
		return wiName;
	}
	public void setWiName(String wiName) {
		this.wiName = wiName;
	}
	public String getCityOfBirth() {
		return cityOfBirth;
	}
	public void setCityOfBirth(String cityOfBirth) {
		this.cityOfBirth = cityOfBirth;
	}
	public String getCountryOfBirth() {
		return countryOfBirth;
	}
	public void setCountryOfBirth(String countryOfBirth) {
		this.countryOfBirth = countryOfBirth;
	}
	public String getCrsUndocumentedFlag() {
		return crsUndocumentedFlag;
	}
	public void setCrsUndocumentedFlag(String crsUndocumentedFlag) {
		this.crsUndocumentedFlag = crsUndocumentedFlag;
	}
	public String getCrsUndocumentedFlagReason() {
		return crsUndocumentedFlagReason;
	}
	public void setCrsUndocumentedFlagReason(String crsUndocumentedFlagReason) {
		this.crsUndocumentedFlagReason = crsUndocumentedFlagReason;
	}
	public String getUsRelation() {
		return usRelation;
	}
	public void setUsRelation(String usRelation) {
		this.usRelation = usRelation;
	}
	public String getTinNumber() {
		return tinNumber;
	}
	public void setTinNumber(String tinNumber) {
		this.tinNumber = tinNumber;
	}
	public String getFatcaReason() {
		return fatcaReason;
	}
	public void setFatcaReason(String fatcaReason) {
		this.fatcaReason = fatcaReason;
	}
	public String getDocumentsCollected() {
		return documentsCollected;
	}
	public void setDocumentsCollected(String documentsCollected) {
		this.documentsCollected = documentsCollected;
	}
	public String getSignedDate() {
		return signedDate;
	}
	public void setSignedDate(String signedDate) {
		this.signedDate = signedDate;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
	public String getCustomerType() {
		return customerType;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	public String getCustomerCategory() {
		return customerCategory;
	}
	public void setCustomerCategory(String customerCategory) {
		this.customerCategory = customerCategory;
	}
	public String getEmployerName() {
		return employerName;
	}
	public void setEmployerName(String employerName) {
		this.employerName = employerName;
	}
	public String getEmployerCode() {
		return employerCode;
	}
	public void setEmployerCode(String employerCode) {
		this.employerCode = employerCode;
	}
	public String getRiskScore() {
		return riskScore;
	}
	public void setRiskScore(String riskScore) {
		this.riskScore = riskScore;
	}
	private String mailingAddrLine1;
	private String mailingAddrLine2;
	private String mailingAddrCity;
	private String mailingAddrCountry;
	private String mailingAddrPOBox;
	private String title;
	private String firstName;
	private String middleName;
	private String lastName;
	private String gender;
	private String dob;
	private String nationality;
	private String secondnationality;
	private String maritalStatus;
	private String AccNumber;
	private String MonthlySalary;
	public String getSolId() {
		return solId;
	}
	public void setSolId(String solId) {
		this.solId = solId;
	}
	public String getCustomerSegment() {
		return customerSegment;
	}
	public void setCustomerSegment(String customerSegment) {
		this.customerSegment = customerSegment;
	}
	public String getCustomerSubSegment() {
		return customerSubSegment;
	}
	public void setCustomerSubSegment(String customerSubSegment) {
		this.customerSubSegment = customerSubSegment;
	}
	public String getEmployeeType() {
		return employeeType;
	}
	public void setEmployeeType(String employeeType) {
		this.employeeType = employeeType;
	}
	public String getResidenceAddrLine1() {
		return residenceAddrLine1;
	}
	public void setResidenceAddrLine1(String residenceAddrLine1) {
		this.residenceAddrLine1 = residenceAddrLine1;
	}
	public String getResidenceAddrLine2() {
		return residenceAddrLine2;
	}
	public void setResidenceAddrLine2(String residenceAddrLine2) {
		this.residenceAddrLine2 = residenceAddrLine2;
	}
	public String getResidenceAddrCity() {
		return residenceAddrCity;
	}
	public void setResidenceAddrCity(String residenceAddrCity) {
		this.residenceAddrCity = residenceAddrCity;
	}
	public String getResidenceAddrCountry() {
		return residenceAddrCountry;
	}
	public void setResidenceAddrCountry(String residenceAddrCountry) {
		this.residenceAddrCountry = residenceAddrCountry;
	}
	public String getResidenceAddrPOBox() {
		return residenceAddrPOBox;
	}
	public void setResidenceAddrPOBox(String residenceAddrPOBox) {
		this.residenceAddrPOBox = residenceAddrPOBox;
	}
	public String getOccupation() {
		return occupation;
	}
	public void setOccupation(String occupation) {
		this.occupation = occupation;
	}
	public String getMailingAddrLine1() {
		return mailingAddrLine1;
	}
	public void setMailingAddrLine1(String mailingAddrLine1) {
		this.mailingAddrLine1 = mailingAddrLine1;
	}
	public String getMailingAddrLine2() {
		return mailingAddrLine2;
	}
	public void setMailingAddrLine2(String mailingAddrLine2) {
		this.mailingAddrLine2 = mailingAddrLine2;
	}
	public String getMailingAddrCity() {
		return mailingAddrCity;
	}
	public void setMailingAddrCity(String mailingAddrCity) {
		this.mailingAddrCity = mailingAddrCity;
	}
	public String getMailingAddrCountry() {
		return mailingAddrCountry;
	}
	public void setMailingAddrCountry(String mailingAddrCountry) {
		this.mailingAddrCountry = mailingAddrCountry;
	}
	public String getMailingAddrPOBox() {
		return mailingAddrPOBox;
	}
	public void setMailingAddrPOBox(String mailingAddrPOBox) {
		this.mailingAddrPOBox = mailingAddrPOBox;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getMiddleName() {
		return middleName;
	}
	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getDob() {
		return dob;
	}
	public void setDob(String dob) {
		this.dob = dob;
	}
	public String getNationality() {
		return nationality;
	}
	public void setNationality(String nationality) {
		this.nationality = nationality;
	}
	public String getMaritalStatus() {
		return maritalStatus;
	}
	public void setMaritalStatus(String maritalStatus) {
		this.maritalStatus = maritalStatus;
	}
	public String getIBANNO() {
		return iBANNO;
	}
	public void setIBANNO(String iBANNO) {
		this.iBANNO = iBANNO;
	}
	public String getAccNumber() {
		return AccNumber;
	}
	public void setAccNumber(String AccNumber) {
		this.AccNumber = AccNumber;
	}
	public String getDemographic() {
		return demographic;
	}
	public void setDemographic(String demographic) {
		this.demographic = demographic;
	}
	public String getPEP() {
		return pep;
	}
	public void setPEP(String pep) {
		this.pep = pep;
	}
	
	public String getSecondNationality() {
		return secondnationality;
	}
	public void setSecondNationality(String secondnationality) {
		this.secondnationality = secondnationality;
	}
	
	public String getMonthlySalary() {
		return MonthlySalary;
	}
	public void setMonthlySalary(String MonthlySalary) {
		this.MonthlySalary = MonthlySalary;
	}
	
	private String MnthyCrTrunOverAmt;
	private String CashCrTransAmt;
	private String NCashCrTransAmt;
	private String NCashCrTurnOvrPer;
	private String CashCrTurnOvrPer;
	private String Channel;

	public String getMnthyCrTrunOverAmt() {
		return MnthyCrTrunOverAmt;
	}
	public void setMnthyCrTrunOverAmt(String MnthyCrTrunOverAmt) {
		this.MnthyCrTrunOverAmt = MnthyCrTrunOverAmt;
	}

	public String getCashCrTransAmt() {
		return CashCrTransAmt;
	}
	public void setCashCrTransAmt(String CashCrTransAmt) {
		this.CashCrTransAmt = CashCrTransAmt;
	}
	public String getNCashCrTransAmt() {
		return NCashCrTransAmt;
	}
	public void setNCashCrTransAmt(String NCashCrTransAmt) {
		this.NCashCrTransAmt = NCashCrTransAmt;
	}
	public String getNCashCrTurnOvrPer() {
		return NCashCrTurnOvrPer;
	}
	public void setNCashCrTurnOvrPer(String NCashCrTurnOvrPer) {
		this.NCashCrTurnOvrPer = NCashCrTurnOvrPer;
	}
	public String getCashCrTurnOvrPer() {
		return CashCrTurnOvrPer;
	}
	public void setCashCrTurnOvrPer(String CashCrTurnOvrPer) {
		this.CashCrTurnOvrPer = CashCrTurnOvrPer;
	}
	public String getChannel() {
		return Channel;
	}
	public void setChannel(String Channel) {
		this.Channel = Channel;
	}
	
	//Rubi
	public String ChkTitle;
	public String chkFirstName;
	public String chkMiddleName;
	public String chkLastName;
	public String chkEmiratesId;
	public String chkEmiratesExpiryDate;
	public String chkVisaIssueDate;
	public String chkVisaExpiryDate;
	public String chkRiskScore;
	public String chkPassNo;
	public String chkPassExpiryDate;
	
	public String getChkTitle() {
		return ChkTitle;
	}
	public void setChkTitle(String strChkTitle) {
	    this.ChkTitle =strChkTitle;
	}
	
	public String getChkFirstName() {
		return chkFirstName;
	}
	public void setChkFirstName(String strChkFirstName) {
		this.chkFirstName = strChkFirstName;
	}
	
	public String getChkMiddleName() {
		return chkMiddleName;		
	}
	public void setChkMiddleName(String strchkMiddleName) {
		this.chkMiddleName = strchkMiddleName;		
	}
	
	public String getChkLastName() {
		return chkLastName;	
	}
	public void setChkLastName(String strchkLastName) {
		this.chkLastName =strchkLastName;	
	}
	
	public String getChkEmiratesId() {
		return chkEmiratesId;
	}
	public void setChkEmiratesID(String strchkEmiratesId) {
		this.chkEmiratesId = strchkEmiratesId;
	}
	
	public String getChkEmiratesExpiryDate() {
		return chkEmiratesExpiryDate;
	}
	public void setChkEmiratesExpiryDate(String strchkEmiratesExpiryDate) {
		this.chkEmiratesExpiryDate = strchkEmiratesExpiryDate;
	}
	
	public String getChkVisaIssueDate() {
		return chkVisaIssueDate;
	}
	public void setChkVisaIssueDate(String strchkVisaIssueDate) {
		this.chkVisaIssueDate=strchkVisaIssueDate;
	}
	
	public String getChkVisaExpiryDate() {
		return chkVisaExpiryDate;
	}
	public void setChkVisaExpiryDate(String strchkVisaExpiryDate) {
		this.chkVisaExpiryDate = strchkVisaExpiryDate;
	}
	
	public String getChkRiskScore() {
		return chkRiskScore;
	}
	public void setChkRiskScore(String strchkRiskScore) {
		this.chkRiskScore = strchkRiskScore;
	}
	
	public String getChkPassNo() {
		return chkPassNo;
	}
	public void setChkPassNo(String strchkPassNo) {
		this.chkPassNo = strchkPassNo;
	}
	
	public String getChkPassExpiryDate() {
		return chkPassExpiryDate;
	}
	public void setChkPassExpiryDate(String strchkPassExpiryDate) {
		this.chkPassExpiryDate = strchkPassExpiryDate;
	}
	

}
