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


package com.newgen.NBTL.CBS;


public class ResponseBean {

	private String CifUpdateReturnCode;
	private String integrationDecision;
	private String mwErrorCode;
	private String mwErrorDesc;
	private String NBTLRequestId;
	
	/*private String SecondCallCifUpdateReturnCode;
	private String SecondCallintegrationDecision;
	private String SecondCallmwErrorCode;
	private String SecondCallmwErrorDesc;
	private String SecondCallNBTLRequestId;*/
	
	private String MemopadReturnCode;
	private String MemoIntegrationDecision;
	private String MemoMWErrorCode;
	private String MemoMWErrorDesc;
	private String MemoNBTLRequestId;
	
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
	
	/*public String getSecondCallCifUpdateReturnCode() {
		return SecondCallCifUpdateReturnCode;
	}
	public void setSecondCallCifUpdateReturnCode(String SecondCallCifUpdateReturnCode) {
		this.SecondCallCifUpdateReturnCode = SecondCallCifUpdateReturnCode;
	}
	public String getSecondCallMWErrorCode() {
		return SecondCallmwErrorCode;
	}
	public void setSecondCallSecondCallMWErrorCode(String SecondCallSecondCallmwErrorCode) {
		this.SecondCallmwErrorCode = SecondCallSecondCallmwErrorCode;
	}
	public String getSecondCallMWErrorDesc() {
		return SecondCallmwErrorDesc;
	}
	public void setSecondCallMWErrorDesc(String SecondCallmwErrorDesc) {
		this.SecondCallmwErrorDesc = SecondCallmwErrorDesc;
	}
	public String getSecondCallNBTLRequestId() {
		return SecondCallNBTLRequestId;
	}
	public void setSecondCallNBTLRequestId(String SecondCallNBTLRequestId) {
		this.SecondCallNBTLRequestId = SecondCallNBTLRequestId;
	}*/
	
	public String getMemopadReturnCode() {
		return MemopadReturnCode;
	}
	public void setMemopadReturnCode(String MemopadReturnCode) {
		this.MemopadReturnCode = MemopadReturnCode;
	}
	public String getMemoIntegrationDecision() {
		return MemoIntegrationDecision;
	}
	public void setMemoIntegrationDecision(String MemoIntegrationDecision) {
		this.NBTLRequestId = MemoIntegrationDecision;
	}
	public String getMemoMWErrorCode() {
		return MemoMWErrorCode;
	}
	public void setMemoMWErrorCode(String MemoMWErrorCode) {
		this.MemoMWErrorCode = MemoMWErrorCode;
	}
	public String getMemoMWErrorDesc() {
		return MemoMWErrorDesc;
	}
	public void setMemoMWErrorDesc(String MemoMWErrorDesc) {
		this.MemoMWErrorDesc = MemoMWErrorDesc;
	}
	public String getMemoNBTLRequestId() {
		return MemoNBTLRequestId;
	}
	public void setMemoNBTLRequestId(String MemoNBTLRequestId) {
		this.MemoNBTLRequestId = MemoNBTLRequestId;
	}
	
}

