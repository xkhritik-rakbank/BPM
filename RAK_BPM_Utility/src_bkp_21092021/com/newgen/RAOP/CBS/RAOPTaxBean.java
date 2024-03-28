/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP CBS
File Name				: RAOPCBSLog.java
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

public class RAOPTaxBean {

	private String countryOfTaxResidence;
	private String taxPayerIdNumber;
	private String noTinReason;
	private String remarks;
	public String getCountryOfTaxResidence() {
		return countryOfTaxResidence;
	}
	public void setCountryOfTaxResidence(String countryOfTaxResidence) {
		this.countryOfTaxResidence = countryOfTaxResidence;
	}
	public String getTaxPayerIdNumber() {
		return taxPayerIdNumber;
	}
	public void setTaxPayerIdNumber(String taxPayerIdNumber) {
		this.taxPayerIdNumber = taxPayerIdNumber;
	}
	public String getNoTinReason() {
		return noTinReason;
	}
	public void setNoTinReason(String noTinReason) {
		this.noTinReason = noTinReason;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

}
