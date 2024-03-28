/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: DAC CBS
File Name				: CustomerBean.java
Author 					: Sivakumar P
Date (DD/MM/YYYY)		: 26/07/2019

---------------------------------------------------------------------------------------------------------
                 	CHANGE HISTORY
---------------------------------------------------------------------------------------------------------

Problem No/CR No        Change Date           Changed By             Change Description
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
*/


package com.newgen.DAC.CBS;

public class CustomerBean {

	private String solId;
	private String passportNumber;
	private String emiratesId;	
	private String isExistingCustomer;
	private String itemIndex;
	private String iBANNO;
	private String EmailID;
	private String Card_Embossing_Name;
	private String SchemeCode;
	private String SchemeType;
	private String AccountNumber;
	private String MobileCntryCode;
	private String MobileNo;
	private String Corporate_CIF;
	private String strCustomer_ID;
	private String setIsRetail;
	private String RequestForCIF;
	private String customerType;
	private String customerSegment;
	private String opsCheckerSubmittedBy;
	public String getItemIndex() {
		return itemIndex;
	}
	public void setItemIndex(String itemIndex) {
		this.itemIndex = itemIndex;
	}
	
	public String getIsExistingCustomer() {
		return isExistingCustomer;
	}
	public void setIsExistingCustomer(String isExistingCustomer) {
		this.isExistingCustomer = isExistingCustomer;
	}
	public String getPassportNumber() {
		return passportNumber;
	}
	public void setPassportNumber(String passportNumber) {
		this.passportNumber = passportNumber;
	}
		
	public String getEmiratesId() {
		return emiratesId;
	}
	public void setEmiratesId(String emiratesId) {
		this.emiratesId = emiratesId;
	}
	
	private String expiryDate;
	private String wiName;
	public String getWiName() {
		return wiName;
	}
	public void setWiName(String wiName) {
		this.wiName = wiName;
	}
	public String getExpiryDate() {
		return expiryDate;
	}
	public void setExpiryDate(String expiryDate) {
		this.expiryDate = expiryDate;
	}
	
	private String firstName;
	private String middleName;
	private String lastName;
	private String gender;
	private String dob;
	private String nationality;
	public String getSolId() {
		return solId;
	}
	public void setSolId(String solId) {
		this.solId = solId;
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
	public String getIBANNO() {
		return iBANNO;
	}
	public void setIBANNO(String iBANNO) {
		this.iBANNO = iBANNO;
	}
	public String getEmailID() {
		return EmailID;
	}
	public void setEmailID(String EmailID) {
		this.EmailID = EmailID;
	}
	public String getCardEmbName() {
		return Card_Embossing_Name;
	}
	public void setCardEmbName(String Card_Embossing_Name) {
		this.Card_Embossing_Name = Card_Embossing_Name;
	}
	public String getSchemeCode() {
		return SchemeCode;
	}
	public void setSchemeCode(String SchemeCode) {
		this.SchemeCode = SchemeCode;
	}
	public String getSchemeType() {
		return SchemeType;
	}
	public void setSchemeType(String SchemeType) {
		this.SchemeType = SchemeType;
	}
	public String getAccountNumber() {
		return AccountNumber;
	}
	public void setAccountNumber(String AccountNumber) {
		this.AccountNumber = AccountNumber;
	}
	public String getMobileCntryCode() {
		return MobileCntryCode;
	}
	public void setMobileCntryCode(String MobileCntryCode) {
		this.MobileCntryCode = MobileCntryCode;
	}
	public String getMobileNo() {
		return MobileNo;
	}
	public void setMobileNo(String MobileNo) {
		this.MobileNo = MobileNo;
	}
	public String getCorporate_CIF() {
		return Corporate_CIF;
	}
	public void setCorporate_CIF(String Corporate_CIF) {
		this.Corporate_CIF = Corporate_CIF;
	}
	public String getRequestBySignatoryCIF() {
		return strCustomer_ID;
	}
	public void setRequestBySignatoryCIF(String strCustomer_ID) {
		this.strCustomer_ID = strCustomer_ID;
	}
	public String getsetIsRetail() {
		return setIsRetail;
	}
	public void setIsRetail(String setIsRetail) {
		this.setIsRetail = setIsRetail;
	}
	public String getRequestForCIF() {
		return RequestForCIF;
	}
	public void setRequestForCIF(String RequestForCIF) {
		this.RequestForCIF = RequestForCIF;
	}
	public String getCustomerType() {
		return customerType;
	}
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	public String getCustomerSegment() {
		return customerSegment;
	}
	public void setCustomerSegment(String customerSegment) {
		this.customerSegment = customerSegment;
	}
	public String getOpsCheckerSubmittedBy() {
		return opsCheckerSubmittedBy;
	}
	public void setOpsCheckerSubmittedBy(String opsCheckerSubmittedBy) {
		this.opsCheckerSubmittedBy = opsCheckerSubmittedBy;
	}
}

