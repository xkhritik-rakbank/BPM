/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: DAC CBS
File Name				: ResponseBean.java
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


public class ResponseBean {

	private String CustomerCreationReturnCode;
	private String ibanNumber;
	private String isExistingCustomer;
	private String integrationDecision;
	private String mwErrorCode;
	private String mwErrorDesc;
	private String DACRequestId;
	
	public String getIntegrationDecision() {
		return integrationDecision;
	}
	public void setIntegrationDecision(String integrationDecision) {
		this.integrationDecision = integrationDecision;
	}
	
	public String getCustomerCreationReturnCode() {
		return CustomerCreationReturnCode;
	}
	public void setCustomerCreationReturnCode(String CustomerCreationReturnCode) {
		this.CustomerCreationReturnCode = CustomerCreationReturnCode;
	}
	public String getMWErrorCode() {
		return mwErrorCode;
	}
	public void setMWErrorCode(String mwErrorCode) {
		this.mwErrorCode = mwErrorCode;
	}
	public String getMWErrorDesc() {
		return mwErrorDesc;
	}
	public void setMWErrorDesc(String mwErrorDesc) {
		this.mwErrorDesc = mwErrorDesc;
	}
	public String getDACRequestId() {
		return DACRequestId;
	}
	public void setDACRequestId(String DACRequestId) {
		this.DACRequestId = DACRequestId;
	}
	
}

