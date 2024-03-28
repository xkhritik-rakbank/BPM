package com.newgen.CMP.CBS;


public class ResponseBean {

	private String CustomerCreationReturnCode;
	private String ibanNumber;
	private String isExistingCustomer;
	private String integrationDecision;
	private String intFailedReason;
	private String intFailedCode;
	private String msgID;
	
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
	
	public String getIbanNumber() {
		return ibanNumber;
	}
	public void setIbanNumber(String ibanNumber) {
		this.ibanNumber = ibanNumber;
	}
	public String getCustomerCreationReturnCode() {
		return CustomerCreationReturnCode;
	}
	public void setCustomerCreationReturnCode(String CustomerCreationReturnCode) {
		this.CustomerCreationReturnCode = CustomerCreationReturnCode;
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

