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


package com.newgen.KYC.CBS;


public class ResponseBean {

	private String CifUpdateReturnCode;
	private String integrationDecision;
	private String mwErrorCode;
	private String mwErrorDesc;
	private String NBTLRequestId;
	
	public String getIntegrationDecision() {
		return integrationDecision;
	}
	public void setIntegrationDecision(String integrationDecision) {
		this.integrationDecision = integrationDecision;
	}
	
	public String getCifUpdateReturnCode() {
		return CifUpdateReturnCode;
	}
	public void setCifUpdateReturnCode(String CifUpdateReturnCode) {
		this.CifUpdateReturnCode = CifUpdateReturnCode;
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
	public String getNBTLRequestId() {
		return NBTLRequestId;
	}
	public void setNBTLRequestId(String NBTLRequestId) {
		this.NBTLRequestId = NBTLRequestId;
	}
}

