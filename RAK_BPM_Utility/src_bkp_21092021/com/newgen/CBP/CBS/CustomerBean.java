/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: CMP CBS
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


package com.newgen.CBP.CBS;

public class CustomerBean {

	private String visaNumber;
	private String visaExpiryDate;
	private String visaIssueDate;
	private String passportNumber;
	private String passportIssueDate;
	private String passportExpiryDate;
	private String cifNumber;
	private String wiName;
	private String emidNumber;
	private String emidExpDate;
	public String getWiName() {
		return wiName;
	}
	public void setWiName(String wiName) {
		this.wiName = wiName;
	}
	public String getCifNumber() {
		return cifNumber;
	}
	public void setCifNumber(String cifNumber) {
		this.cifNumber = cifNumber;
	}
	public String getVisaNumber() {
		return visaNumber;
	}
	public void setVisaNumber(String visaNumber) {
		this.visaNumber = visaNumber;
	}
	public String getVisaExpiryDate() {
		return visaExpiryDate;
	}
	public void setVisaExpiryDate(String visaExpiryDate) {
		this.visaExpiryDate = visaExpiryDate;
	}
	public String getVisaIssueDate() {
		return visaIssueDate;
	}
	public void setVisaIssueDate(String visaIssueDate) {
		this.visaIssueDate = visaIssueDate;
	}
	public String getPassportNumber() {
		return passportNumber;
	}
	public void setPassportNumber(String passportNumber) {
		this.passportNumber = passportNumber;
	}
	public String getPassportIssueDate() {
		return passportIssueDate;
	}
	public void setPassportIssueDate(String passportIssueDate) {
		this.passportIssueDate = passportIssueDate;
	}
	public String getPassportExpiryDate() {
		return passportExpiryDate;
	}
	public void setPassportExpiryDate(String passportExpiryDate) {
		this.passportExpiryDate = passportExpiryDate;
	}
	public String getEmidNumber() {
		return emidNumber;
	}
	public void setEmidNumber(String emidNumber) {
		this.emidNumber = emidNumber;
	}
	public String getEmidExpiryDate() {
		return emidExpDate;
	}
	public void setEmidExpiryDate(String emidExpDate) {
		this.emidExpDate = emidExpDate;
	}
	
}
