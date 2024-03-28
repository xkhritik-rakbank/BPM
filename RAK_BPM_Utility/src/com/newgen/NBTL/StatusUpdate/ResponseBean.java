package com.newgen.NBTL.StatusUpdate;

public class ResponseBean {

	private String StatusUpdateReturnCode;
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
	
	public String getStatusUpdateReturnCode() {
		return StatusUpdateReturnCode;
	}
	public void setStatusUpdateReturnCode(String StatusUpdateReturnCode) {
		this.StatusUpdateReturnCode = StatusUpdateReturnCode;
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
