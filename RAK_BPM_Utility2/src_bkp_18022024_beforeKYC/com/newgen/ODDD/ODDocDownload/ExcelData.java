package com.newgen.ODDD.ODDocDownload;

import java.util.ArrayList;
import java.util.List;

//import java.util.List;

public class ExcelData {
	
String vendorName;
String agreementNo;
String crnNumber;
String Cif_No;

public List<String> strDataDefID = new ArrayList<String>();
public List<String> strFieldIndexfID = new ArrayList<String>();
public List<String> strDataclassName = new ArrayList<String>();
public List<String> strFieldType = new ArrayList<String>();

public String getVendorName() {
	return vendorName;
}
public void setVendorName(String vendorName) {
	this.vendorName = vendorName;
}
public String getAgreementNo() {
	return agreementNo;
}
public void setAgreementNo(String agreementNo) {
	this.agreementNo = agreementNo;
}
public String getCrnNumber() {
	return crnNumber;
}
public void setCrnNumber(String crnNumber) {
	this.crnNumber = crnNumber;
}
public String getCif_No() {
	return Cif_No;
}
public void setCif_No(String cif_No) {
	Cif_No = cif_No;
}

public List<String> getStrDataDefID() {
	return strDataDefID;
}
public void setStrDataDefID(String strDataDefID) {
	this.strDataDefID.add(strDataDefID);
}
public List<String> getStrFieldIndexfID() {
	return strFieldIndexfID;
}
public void setStrFieldIndexfID(String strFieldIndexfID) {
	this.strFieldIndexfID.add(strFieldIndexfID);
}
//*******************************************************
public List<String> strDataDefID_OF = new ArrayList<String>();
public List<String> strFieldIndexfID_OF = new ArrayList<String>();
public List<String> strVendor_Name = new ArrayList<String>();
public List<String> strSearchValue = new ArrayList<String>();
public List<String> strSearchType = new ArrayList<String>();

public List<String> striBPSStatus = new ArrayList<String>();
public List<String> strOFStatus = new ArrayList<String>();

public List<String> getStrDataDefID_OF() {
	return strDataDefID_OF;
}
public void setStrDataDefID_OF(String strDataDefID_OF) {
	this.strDataDefID_OF.add(strDataDefID_OF);
}
public List<String> getStrFieldIndexfID_OF() {
	return strFieldIndexfID_OF;
}
public void setStrFieldIndexfID_OF(String strFieldIndexfID_OF) {
	this.strFieldIndexfID_OF.add(strFieldIndexfID_OF);
}
public List<String> getStrDataclassName() {
	return strDataclassName;
}
public void setStrDataclassName(String strDataclassName) {
	this.strDataclassName.add(strDataclassName);
}
public List<String> getStrFieldType() {
	return strFieldType;
}
public void setStrFieldType(String strFieldType) {
	this.strFieldType.add(strFieldType);
}
public List<String> getStrVendor_Name() {
	return strVendor_Name;
}
public void setStrVendor_Name(String strVendor_Name) {
	this.strVendor_Name.add(strVendor_Name);
}
public List<String> getStrSearchValue() {
	return strSearchValue;
}
public void setStrSearchValue(String strSearchValue) {
	this.strSearchValue.add(strSearchValue);
}
public List<String> getStrSearchType() {
	return strSearchType;
}
public void setStrSearchType(String strSearchType) {
	this.strSearchType.add(strSearchType);
}

public List<String> getStriBPSStatus() {
	return striBPSStatus;
}
public void setStriBPSStatus(String striBPSStatus) {
	this.striBPSStatus.add(striBPSStatus);
}

public List<String> getStrOFStatus() {
	return strOFStatus;
}
public void setStrOFStatus(String strOFStatus) {
	this.strOFStatus.add(strOFStatus);
}

//***************************************************
/*
 * public List<String> getVendorName() { return vendorName; } public void
 * setVendorName(String vendorName) { this.vendorName.add(vendorName); } public
 * String getAgreementNo() { return agreementNo; } public void
 * setAgreementNo(String agreementNo) { this.agreementNo = agreementNo; } public
 * String getCrnNumber() { return crnNumber; } public void setCrnNumber(String
 * crnNumber) { this.crnNumber = crnNumber; } public String getCif_No() { return
 * agreementNo; } public void setCif_No(String Cif_No) { this.Cif_No = Cif_No; }
 * 
 * 
 * public List<String> getStrDataDefID() { return strDataDefID; } public void
 * setStrDataDefID(String strDataDefID) { this.strDataDefID.add(strDataDefID); }
 * public List<String> getStrFieldIndexfID() { return strFieldIndexfID; } public
 * void setStrFieldIndexfID(String strFieldIndexfID) {
 * this.strFieldIndexfID.add(strFieldIndexfID); } public List<String>
 * getStrDataclassName() { return strDataclassName; } public void
 * setStrDataclassName(String strDataclassName) {
 * this.strDataclassName.add(strDataclassName); } public static List<String>
 * getStrFieldType() { return strFieldType; } public void setStrFieldType(String
 * strFieldType) { this.strFieldType.add(strFieldType); }
 */
}
