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


package com.newgen.NBTL.CBS;

public class CustomerBean {

	private String wiName;
	private String ToBeTLNo;
	private String CorporateCIF;
	private String ToBeExpiryDate;
	private String Email;
	private String decision;
	private String MemoPadText;
	private String RequestType;
	
	
	public String getWiName() {
		return wiName;
	}
	public void setWiName(String wiName) {
		this.wiName = wiName;
	}
	public String getToBeTLNo() {
		return ToBeTLNo;
	}
	public void setToBeTLNo(String ToBeTLNo) {
		this.ToBeTLNo = ToBeTLNo;
	}
	public String getCorporateCIF() {
		return CorporateCIF;
	}
	public void setCorporateCIF(String CorporateCIF) {
		this.CorporateCIF = CorporateCIF;
	}
	public String getToBeExpiryDate() {
		return ToBeExpiryDate;
	}
	public void setToBeExpiryDate(String ToBeExpiryDate) {
		this.ToBeExpiryDate = ToBeExpiryDate;
	}
	public String getEmail() {
		return Email;
	}
	public void setEmail(String Email) {
		this.Email = Email;
	}
	
	public String getDecision() {
		return decision;
	}
	public void setDecision(String decision) {
		this.decision = decision;
	}
	public String getMemoPadText() {
		return MemoPadText;
	}
	public void setMemoPadText(String MemoPadText) {
		this.MemoPadText = MemoPadText;
	}
	public String getRequestType() {
		return RequestType;
	}
	public void setRequestType(String RequestType) {
		this.RequestType = RequestType;
	}
	
}

