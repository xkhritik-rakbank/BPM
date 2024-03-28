/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: RAOP CBS
File Name				: ResponseBean.java
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

public class ResponseBean {

	private String cifCreationReturnCode;
	private String cifUpdateReturnCode;
	private String accountCreationReturnCode;
	private String ibanNumber;
	private String accNumber;
	private String signUploadReturnCode;
	private String isExistingCustomer;
	private String integrationDecision;
	private String cifNumber;
	private String intCallFailed;
	private String intFailedReason;
	private String intFailedCode;
	private String msgID;
	private String rikScoreReturnCode;

	public String getCifNumber() {
		return cifNumber;
	}
	public void setCifNumber(String cifNumber) {
		this.cifNumber = cifNumber;
	}
	public String getIntegrationDecision() {
		return integrationDecision;
	}
	public void setIntegrationDecision(String integrationDecision) {
		this.integrationDecision = integrationDecision;
	}
	public String getIsExistingCustomer() {
		return isExistingCustomer;
	}
	public void setIsExistingCustomer(String isExistingCustomer) {
		this.isExistingCustomer = isExistingCustomer;
	}
	public String getSignUploadReturnCode() {
		return signUploadReturnCode;
	}
	public void setSignUploadReturnCode(String signUploadReturnCode) {
		this.signUploadReturnCode = signUploadReturnCode;
	}
	public String getIbanNumber() {
		return ibanNumber;
	}
	public void setIbanNumber(String ibanNumber) {
		this.ibanNumber = ibanNumber;
	}
	public String getAccNumber() {
		return accNumber;
	}
	public void setAccNumber(String accNumber) {
		this.accNumber = accNumber;
	}
	public String getCifCreationReturnCode() {
		return cifCreationReturnCode;
	}
	public void setCifCreationReturnCode(String cifCreationReturnCode) {
		this.cifCreationReturnCode = cifCreationReturnCode;
	}
	public String getCifUpdateReturnCode() {
		return cifUpdateReturnCode;
	}
	public void setCifUpdateReturnCode(String cifUpdateReturnCode) {
		this.cifUpdateReturnCode = cifUpdateReturnCode;
	}
	public String getAccountCreationReturnCode() {
		return accountCreationReturnCode;
	}
	public void setAccountCreationReturnCode(String accountCreationReturnCode) {
		this.accountCreationReturnCode = accountCreationReturnCode;
	}
	public String getRiskScoreReturnCode() {
		return rikScoreReturnCode;
	}
	public void setRiskScoreReturnCode(String rikScoreReturnCode) {
		this.rikScoreReturnCode = rikScoreReturnCode;
	}
	public String getIntCallFailed() {
		return intCallFailed;
	}
	public void setIntCallFailed(String intCallFailed) {
		this.intCallFailed = intCallFailed;
	}
	public String getIntFailedReason() {
		return intFailedReason;
	}
	public void setIntFailedReason(String intFailedReason) {
		this.intFailedReason = intFailedReason;
	}
	public String getIntFailedCode() {
		return intFailedCode;
	}
	public void setIntFailedCode(String intFailedCode) {
		this.intFailedCode = intFailedCode;
	}
	
	public String getMsgID() {
		return msgID;
	}
	public void setMsgID(String msgID) {
		this.msgID = msgID;
	}
}
