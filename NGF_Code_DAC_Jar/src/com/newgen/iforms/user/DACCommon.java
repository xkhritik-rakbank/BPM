package com.newgen.iforms.user;

//--------- NEWGEN SOFTWARE TECHNOLOGIES LIMITED ------------------

//Group                                             : Application �Projects
//Product / Project                                	: EcoBank Group Roll Out
//Module                                            :
//File Name                                         : Common_Function.java
//Author                                            : Piyush Bansal
//Date written (DD/MM/YYYY)          				: 01/Jan/2014
//Description                                       : Java For execution of various user commands and XMLs' which are common to all process

//---------------------------------------------------------------------------------

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.io.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.excp.NGException;
import com.newgen.wfdesktop.xmlapi.WFInputXml;

//import com.newgen.iforms.user.*;

public class DACCommon {
	// Map<String,String> constantsHashMap=new HashMap<>();

private static NGEjbClient ngEjbClientStatus;
	
	static
	{
	  try
      {
		  ngEjbClientStatus = NGEjbClient.getSharedInstance();
      }
    catch (NGException e)
      {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
	}
	
	String sLocaleForMessage = java.util.Locale.getDefault().toString();

	public List<List<String>> getDataFromDB(IFormReference iformObj, String query) {
		DAC.mLogger.debug("Inside Done()--->query is: " + query);
		try {
			List<List<String>> result = iformObj.getDataFromDB(query);
			DAC.mLogger.debug("Inside Done()---result:" + result);
			if (!result.isEmpty() && result.get(0) != null) {
				return result;
			}
		} catch (Exception e) {
			DAC.printException(e);
		}
		return null;

	}

	public static String maskXmlTags(String InputXML, String Tag) {
		Pattern p = Pattern.compile("(?<=" + Tag + ")([-\\s\\w]*)((?:[a-zA-Z0-9][-_\\s]*){0})");
		Matcher m = p.matcher(InputXML);
		StringBuffer maskedResult = new StringBuffer();
		while (m.find()) {
			String thisMask = m.group(1).replaceAll("[^-_\\s]", "*");
			m.appendReplacement(maskedResult, thisMask + "$2");
		}
		m.appendTail(maskedResult);
		return maskedResult.toString();
	}

	public String saveDataInDB(IFormReference iformObj, String query) {
		DAC.mLogger.debug("Inside Done()---Exception_Mail_ID->query is: " + query);
		try {
			int mainCode = iformObj.saveDataInDB(query);
			DAC.mLogger.debug("Inside Done()---result:" + mainCode);
			return mainCode + "";
		} catch (Exception e) {
			DAC.printException(e);
		}
		return null;
	}

	// **********************************************************************************//
	// Description :Method to Trim Strings
	// **********************************************************************************//
	public String Trim(String str) {
		if (str == null)
			return str;
		int i = 0, j = 0;
		for (i = 0; i < str.length(); i++) {
			if (str.charAt(i) != ' ')
				break;
		}
		for (j = str.length() - 1; j >= 0; j--) {
			if (str.charAt(j) != ' ')
				break;
		}
		if (j < i)
			j = i - 1;
		str = str.substring(i, j + 1);
		return str;
	}

	public void enableControl(String strFields) {
		String arrFields[] = strFields.split(",");
		for (int idx = 0; idx < arrFields.length; idx++) {
			try {
				EventHandler.iFormOBJECT.getIFormControl(arrFields[idx]).getM_objControlStyle().setM_strEnable("true");
			} catch (Exception ex) {
				DAC.printException(ex);
			}
		}
	}

	public void disableControl(String strFields) {
		String arrFields[] = strFields.split(",");
		for (int idx = 0; idx < arrFields.length; idx++) {
			try {
				EventHandler.iFormOBJECT.getIFormControl(arrFields[idx]).getM_objControlStyle().setM_strEnable("false");
			} catch (Exception ex) {
				DAC.printException(ex);
			}
		}
	}

	public void lockControl(String strFields) {
		String arrFields[] = strFields.split(",");
		for (int idx = 0; idx < arrFields.length; idx++) {
			try {
				EventHandler.iFormOBJECT.getIFormControl(arrFields[idx]).getM_objControlStyle()
						.setM_strReadOnly("true");
			} catch (Exception ex) {
				DAC.printException(ex);
			}
		}
	}

	public void unlockControl(String strFields) {
		String arrFields[] = strFields.split(",");
		for (int idx = 0; idx < arrFields.length; idx++) {
			try {
				EventHandler.iFormOBJECT.getIFormControl(arrFields[idx]).getM_objControlStyle()
						.setM_strReadOnly("false");
			} catch (Exception ex) {
				DAC.printException(ex);
			}
		}
	}

	public String getSessionId() {
		return ((EventHandler.iFormOBJECT).getObjGeneralData()).getM_strDMSSessionId();
	}

	public String getItemIndex() {
		return ((EventHandler.iFormOBJECT).getObjGeneralData()).getM_strFolderId();
	}

	public String getWorkitemName() {
		return ((EventHandler.iFormOBJECT).getObjGeneralData()).getM_strProcessInstanceId();
	}

	public void setControlValue(String controlName, String controlValue) {
		EventHandler.iFormOBJECT.setValue(controlName, controlValue);
	}

	public String getCabinetName() {
		return (String) EventHandler.iFormOBJECT.getCabinetName();
	}

	public String getUserName() {
		return (String) EventHandler.iFormOBJECT.getUserName();
	}

	public String getActivityName() {
		return (String) EventHandler.iFormOBJECT.getActivityName();
	}

	public String getControlValue(String controlName) {
		// return (String)EventHandler.iFormOBJECT.getControlValue(controlName);
		return (String) EventHandler.iFormOBJECT.getValue(controlName);
	}

	public boolean isControValueEmpty(String controlName) {
		String controlValue = getControlValue(controlName);

		if (controlValue == null || controlValue.equals(""))
			return true;
		else
			return false;
	}

	// **********************************************************************************//
	// Description :Method to convert one Date Format into another with Locale
	// **********************************************************************************//
	public String convertDateFormat(String idate, String ipDateFormat, String opDateFormat, Locale... opLocale) {
		Locale defaultLocale = Locale.getDefault();

		DAC.mLogger.debug("defaultLocale : " + defaultLocale);

		assert opLocale.length <= 1;
		Locale opDateFmtLocale = opLocale.length > 0 ? opLocale[0] : defaultLocale;

		DAC.mLogger.debug("Loacle for output Date : " + opDateFmtLocale);
		try {
			if (idate == null) {
				return "";
			}
			if (idate.equalsIgnoreCase("")) {
				return "";
			}
			DAC.mLogger.debug("idate :" + idate);
			String odate = "";
			DateFormat dfinput = new SimpleDateFormat(ipDateFormat);
			DateFormat dfoutput = new SimpleDateFormat(opDateFormat, opDateFmtLocale);

			Date dt = dfinput.parse(idate);
			DAC.mLogger.debug("Indate " + dt);
			odate = dfoutput.format(dt);
			DAC.mLogger.debug("Outdate " + odate);
			return odate;
		} catch (Exception e) {
			return "";
		}
	}

	// ******************************************************
	// Description :Method to get current date
	// ******************************************************
	public String getCurrentDate(String outputFormat) {
		String current_date = "";
		try {
			java.util.Calendar dateCreated1 = java.util.Calendar.getInstance();
			java.text.DateFormat df2 = new java.text.SimpleDateFormat(outputFormat);
			current_date = df2.format(dateCreated1.getTime());
		} catch (Exception e) {
			System.out.println("Exception in getting Current date :" + e);
		}
		return current_date;
	}

	public String ExecuteQueryOnServer(String sInputXML) {
		/*
		 * try { PC.mLogger.debug("Server Ip :"+EventHandler.iFormOBJECT.getServerIp());
		 * PC.mLogger.debug("Server Port :"+EventHandler.iFormOBJECT.getServerPort());
		 * PC.mLogger.debug("Input XML :"+sInputXML);
		 * 
		 * return
		 * NGEjbClient.getSharedInstance().makeCall(EventHandler.iFormOBJECT.getServerIp
		 * (), EventHandler.iFormOBJECT.getServerPort() + "", "WebSphere", sInputXML); }
		 * catch(Exception excp) {
		 * PC.mLogger.debug("Exception occured in executing API on server :\n"+excp);
		 * PC.printException(excp); return null; }
		 */
		return "SaJAN";
	}

	public String ExecuteQuery_APProcedure(String ProcName, String Params) {
		try {

			String sInputXML = "<?xml version=\"1.0\"?>" + "\n" + "<APProcedure_Input>" + "\n"
					+ "<Option>APProcedure</Option>" + "\n" + "<ProcName>" + ProcName + "</ProcName>" + "\n"
					+ "<Params>" + Params + "</Params>" + "\n" + "<EngineName>" + getCabinetName() + "</EngineName>"
					+ "\n" + "<SessionId>" + getSessionId() + "</SessionId>" + "\n" + "</APProcedure_Input>";

			DAC.mLogger.debug("Inside ExecuteQuery_APProcedure() [Input xml] \n: " + sInputXML);

			return ExecuteQueryOnServer(sInputXML);
		} catch (Exception e) {
			DAC.printException(e);
			return "";
		}
	}

	public String ExecuteQuery_APSelect(String sQuery) {
		try {
			WFInputXml wfInputXml = new WFInputXml();

			wfInputXml.appendStartCallName("APSelect", "Input");
			wfInputXml.appendTagAndValue("Query", sQuery);
			wfInputXml.appendTagAndValue("EngineName", getCabinetName());
			wfInputXml.appendTagAndValue("SessionId", getSessionId());
			wfInputXml.appendEndCallName("APSelect", "Input");
			String sInputXML = wfInputXml.toString();

			DAC.mLogger.debug("Inside ExecuteQuery_APSelect [InputXml]:\n " + sInputXML);

			return ExecuteQueryOnServer(sInputXML);
		} catch (Exception e) {
			DAC.printException(e);
			return "";
		}
	}

	public String ExecuteQuery_APSelectWithColumnNames(String sQuery) {
		try {
			WFInputXml wfInputXml = new WFInputXml();
			wfInputXml.appendStartCallName("APSelectWithColumnNames", "Input");
			wfInputXml.appendTagAndValue("Query", sQuery);
			wfInputXml.appendTagAndValue("EngineName", getCabinetName());
			wfInputXml.appendTagAndValue("SessionId", getSessionId());
			wfInputXml.appendEndCallName("APSelectWithColumnNames", "Input");
			String sInputXML = wfInputXml.toString();

			DAC.mLogger.debug("Inside ExecuteQuery_APSelectWithColumnNames [InputXml]:\n " + sInputXML);

			return ExecuteQueryOnServer(sInputXML);
		} catch (Exception e) {
			DAC.printException(e);
			return "";
		}
	}

	public String ExecuteQuery_APUpdate(String tableName, String columnName, String strValues, String sWhere) {
		try {
			WFInputXml wfInputXml = new WFInputXml();
			if (strValues == null) {
				strValues = "''";
			}
			wfInputXml.appendStartCallName("APUpdate", "Input");
			wfInputXml.appendTagAndValue("TableName", tableName);
			wfInputXml.appendTagAndValue("ColName", columnName);
			wfInputXml.appendTagAndValue("Values", strValues);
			wfInputXml.appendTagAndValue("WhereClause", sWhere);
			wfInputXml.appendTagAndValue("EngineName", getCabinetName());
			wfInputXml.appendTagAndValue("SessionId", getSessionId());
			wfInputXml.appendEndCallName("APUpdate", "Input");

			String sInputXML = wfInputXml.toString();

			DAC.mLogger.debug("Inside ExecuteQuery_APUpdate [InputXml]:\n " + sInputXML);

			return ExecuteQueryOnServer(sInputXML);
		} catch (Exception e) {
			DAC.printException(e);
			return "";
		}
	}

	public String ExecuteQuery_APInsert(String tableName, String columnName, String strValues) {
		DAC.mLogger.debug("Inside ExecuteQuery_APInsert()");
		try {
			WFInputXml wfInputXml = new WFInputXml();
			wfInputXml.appendStartCallName("APInsert", "Input");
			wfInputXml.appendTagAndValue("TableName", tableName);
			wfInputXml.appendTagAndValue("ColName", columnName);
			wfInputXml.appendTagAndValue("Values", strValues);
			wfInputXml.appendTagAndValue("EngineName", getCabinetName());
			wfInputXml.appendTagAndValue("SessionId", getSessionId());// added temp till sessionId is not available
			wfInputXml.appendEndCallName("APInsert", "Input");

			String sInputXML = wfInputXml.toString();

			DAC.mLogger.debug("Inside ExecuteQuery_APInsert [InputXml]:\n " + sInputXML);

			return ExecuteQueryOnServer(sInputXML);

		} catch (Exception e) {
			DAC.printException(e);
			return "";
		}

	}

	public String getTagValue(String xml, String tag) {
		try {
			Document doc = getDocument(xml);
			NodeList nodeList = doc.getElementsByTagName(tag);

			int length = nodeList.getLength();

			if (length > 0) {
				Node node = nodeList.item(0);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					NodeList childNodes = node.getChildNodes();
					String value = "";
					int count = childNodes.getLength();
					for (int i = 0; i < count; i++) {
						Node item = childNodes.item(i);
						if (item.getNodeType() == Node.TEXT_NODE) {
							value += item.getNodeValue();
						}
					}
					return value;
				} else if (node.getNodeType() == Node.TEXT_NODE) {
					return node.getNodeValue();
				}
			}
		} catch (Exception e) {
			DAC.printException(e);
		}
		return "";
	}

	public String getTagValue(Node node, String tag) {
		// TODO Auto-generated method stub
		String value = "";

		NodeList nodeList = node.getChildNodes();
		int length = nodeList.getLength();

		for (int i = 0; i < length; ++i) {
			Node child = nodeList.item(i);

			if (child.getNodeType() == Node.ELEMENT_NODE && child.getNodeName().equalsIgnoreCase(tag)) {
				return child.getTextContent();
			}

		}
		return value;
	}

	public Document getDocument(String xml) throws ParserConfigurationException, SAXException, IOException {
		// Step 1: create a DocumentBuilderFactory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		// Step 2: create a DocumentBuilder
		DocumentBuilder db = dbf.newDocumentBuilder();

		// Step 3: parse the input file to get a Document object
		Document doc = db.parse(new InputSource(new StringReader(xml)));
		return doc;
	}

	public NodeList getNodeListFromDocument(Document doc, String identifier) {
		NodeList records = doc.getElementsByTagName(identifier);
		return records;
	}

	// **********************************************************************************//
	// Description :Method to Fetch Unique Sequence No from DB
	// **********************************************************************************//
	public String getNextSequenceValue(String seqName) throws ParserConfigurationException, SAXException, IOException {
		String sQuery = "SELECT " + seqName + ".NEXTVAL FROM DUAL";
		String outputXML = ExecuteQuery_APSelect(sQuery);
		String value = "0";
		int count = 0;
		if (outputXML.indexOf("<td>") > -1) {
			value = getTagValue(outputXML, "td");
		}

		if (!value.equals(""))
			count = Integer.parseInt(value) + 1;

		return String.valueOf(count);
	}

	public String generateResponseString(String SaveFormData, String SuccessOrError, String preAlertMessage,
			String alertMessageCode, String postAlertMessage, String call, String data) {

		return "{'SAVEFORMDATA':'" + SaveFormData + "'," + "'SUCCESSORERROR':'" + SuccessOrError + "',"
				+ "'PREALERTMESSAGE':'" + preAlertMessage + "'," + "'ALERTMESSAGECODE':'" + alertMessageCode + "',"
				+ "'POSTALERTMESSAGE':'" + postAlertMessage + "'," + "'CALL':'" + call + "'," + "'DATA':'" + data
				+ "'}";
	}

	public void setBBAN(String countryCode, String accNum) {
		System.out.println("Inside setBBAN method !! " + countryCode + " ; " + accNum);
		try {
			if (countryCode.equalsIgnoreCase("GM")) {
				long bban = 97 - (Long.parseLong(accNum) * 100) % 97;
				setControlValue("BBAN", accNum + bban + "");
			}
			// EMZ NUIT and ALTACC change
			else if (countryCode.equalsIgnoreCase("MZ")) {
				String accNo = getControlValue("ACCOUNT_NO");
				if (accNo != null && !accNo.equals("")) {
					String bban = accNo.substring(1, 3) + getControlValue("CUSTOMER_ID") + accNo.substring(14);
					setControlValue("BBAN", bban);
				}
			}
			// EMZ NUIT and ALTACC change
		} catch (Exception zz) {
			zz.printStackTrace();
		}
	}

	// ECD - 23 digit number to be generated based on given logic after account
	// openning
	public String get23DigitAccountNumberRIB(String ibnStr) {
		System.out.println("Inside get23DigitAccountNumber method ...");

		StringBuilder input = new StringBuilder();
		input.append(ibnStr);
		input = input.reverse();

		int val = 0;
		String outputAccNumber = "";

		for (int i = 0; i < input.length(); i++) {
			if (i == 0)
				val += (3) * Character.getNumericValue(input.charAt(i));
			else if (i == 1)
				val += (30) * Character.getNumericValue(input.charAt(i));
			else if (i == 2)
				val += (9) * Character.getNumericValue(input.charAt(i));
			else if (i == 3)
				val += (90) * Character.getNumericValue(input.charAt(i));
			else if (i == 4)
				val += (27) * Character.getNumericValue(input.charAt(i));
			else if (i == 5)
				val += (76) * Character.getNumericValue(input.charAt(i));
			else if (i == 6)
				val += (81) * Character.getNumericValue(input.charAt(i));
			else if (i == 7)
				val += (34) * Character.getNumericValue(input.charAt(i));
			else if (i == 8)
				val += (49) * Character.getNumericValue(input.charAt(i));
			else if (i == 9)
				val += (5) * Character.getNumericValue(input.charAt(i));
			else if (i == 10)
				val += (50) * Character.getNumericValue(input.charAt(i));
			else if (i == 11)
				val += (15) * Character.getNumericValue(input.charAt(i));
			else if (i == 12)
				val += (53) * Character.getNumericValue(input.charAt(i));
			else if (i == 13)
				val += (45) * Character.getNumericValue(input.charAt(i));
			else if (i == 14)
				val += (62) * Character.getNumericValue(input.charAt(i));
			else if (i == 15)
				val += (38) * Character.getNumericValue(input.charAt(i));
			else if (i == 16)
				val += (89) * Character.getNumericValue(input.charAt(i));
			else if (i == 17)
				val += (17) * Character.getNumericValue(input.charAt(i));
			else if (i == 18)
				val += (73) * Character.getNumericValue(input.charAt(i));
		}

		val = val % 97;

		val = 97 - val;

		if (val < 0)
			val = val * (-1);

		if (val < 10)
			outputAccNumber = "0" + val;
		else
			outputAccNumber = val + "";

		System.out.println("outputAccNumber:" + outputAccNumber);
		return outputAccNumber;
	}

	public String getRibKey(String countryCode, String aff_bankCode, String accNum, String IbanBrCode) {
		System.out.println("Inside get Rib Key");
		System.out.println("countryCode :" + countryCode);
		System.out.println("aff_bankCode :" + aff_bankCode);
		System.out.println("accNum :" + accNum);
		System.out.println("IbanBrCode :" + IbanBrCode);

		String extraZero = "00";
		if (countryCode.equalsIgnoreCase("TG")) {
			int numBankCode = 37055;
			return calucalteRibETG(numBankCode, accNum, IbanBrCode);
		} else if (countryCode.equalsIgnoreCase("GA")) {
			// String substr_acc1=accNum.substring(3,6);
			// String substr_acc2=accNum.substring(8,16);
			String accNumPart = accNum.substring(3, 6) + accNum.substring(8, 16);
			return calucalteRIBModuloLogic(accNum, IbanBrCode, extraZero, accNumPart, countryCode);
		} else if (countryCode.equalsIgnoreCase("GQ")) {
			extraZero = "";
			String accNumPart = accNum.substring(3, 6) + accNum.substring(8, 16);
			return calucalteRIBModuloLogic(accNum, IbanBrCode, extraZero, accNumPart, countryCode);
		} else if (countryCode.equalsIgnoreCase("BF")) {
			String accNumPart = accNum.substring(4, 16);
			return calucalteRIBModuloLogic(accNum, IbanBrCode, extraZero, accNumPart, countryCode);
		} else if (countryCode.equalsIgnoreCase("BJ")) {
			int numBankCode = 21062;
			String accNumPart = accNum.substring(4, 16);
			return calucalteRIBModuloLogic(accNum, IbanBrCode, extraZero, accNumPart, countryCode);
		} else if (countryCode.equalsIgnoreCase("CM") || countryCode.equalsIgnoreCase("CM")) {
			String accNumPart = accNum.substring(3, 6) + accNum.substring(8, 16);
			return calucalteRIBModuloLogic(accNum, IbanBrCode, extraZero, accNumPart, countryCode);
		} else if (countryCode.equalsIgnoreCase("CG")) {
			// Change done for ECG specific for IBAN NO
			System.out.println("inside ECG for iban ");
			String rib = aff_bankCode + extraZero + accNum.substring(0, 3) + accNum.substring(3, 6)
					+ accNum.substring(8, 16) + "00";
			System.out.println("rib affiliate specific" + rib);
			return clerib1(rib);
		}
		// ECV RIB Change
		else if (countryCode.equalsIgnoreCase("CV")) {
			return calucalteRibECV(countryCode, accNum, aff_bankCode);
		} else {
			String ibanAccString = "";
			ibanAccString = accNum.substring(4, 16);
			return ribKeyGenerate(ibanAccString, aff_bankCode, IbanBrCode);
		}
	}

	// ECV RIB Change
	private String calucalteRibECV(String countryCode, String accNum, String aff_bankCode) {
		System.out.println("Inside calucalteRibECV method ...");
		String ibanStr = makeIBANString(countryCode, aff_bankCode, accNum, "");

		System.out.println("ibanStr :" + ibanStr);

		StringBuilder input = new StringBuilder();
		input.append(ibanStr);
		input = input.reverse();

		int val = 0;
		String rib = "";

		for (int i = 0; i < input.length(); i++) {
			if (i == 0)
				val += (3) * Character.getNumericValue(input.charAt(i));
			else if (i == 1)
				val += (30) * Character.getNumericValue(input.charAt(i));
			else if (i == 2)
				val += (9) * Character.getNumericValue(input.charAt(i));
			else if (i == 3)
				val += (90) * Character.getNumericValue(input.charAt(i));
			else if (i == 4)
				val += (27) * Character.getNumericValue(input.charAt(i));
			else if (i == 5)
				val += (76) * Character.getNumericValue(input.charAt(i));
			else if (i == 6)
				val += (81) * Character.getNumericValue(input.charAt(i));
			else if (i == 7)
				val += (34) * Character.getNumericValue(input.charAt(i));
			else if (i == 8)
				val += (49) * Character.getNumericValue(input.charAt(i));
			else if (i == 9)
				val += (5) * Character.getNumericValue(input.charAt(i));
			else if (i == 10)
				val += (50) * Character.getNumericValue(input.charAt(i));
			else if (i == 11)
				val += (15) * Character.getNumericValue(input.charAt(i));
			else if (i == 12)
				val += (53) * Character.getNumericValue(input.charAt(i));
			else if (i == 13)
				val += (45) * Character.getNumericValue(input.charAt(i));
			else if (i == 14)
				val += (62) * Character.getNumericValue(input.charAt(i));
			else if (i == 15)
				val += (38) * Character.getNumericValue(input.charAt(i));
			else if (i == 16)
				val += (89) * Character.getNumericValue(input.charAt(i));
			else if (i == 17)
				val += (17) * Character.getNumericValue(input.charAt(i));
			else if (i == 18)
				val += (73) * Character.getNumericValue(input.charAt(i));
		}

		val = val % 97;

		val = 98 - val;

		if (val < 0)
			val = val * (-1);

		if (val < 10)
			rib = "0" + val;
		else
			rib = val + "";

		System.out.println(rib);
		return rib;
	}

	public String makeIBANString(String countryCode, String aff_bankCode, String accNum, String ibanBrCode) {
		if (countryCode.equalsIgnoreCase("GA")) {
			return (aff_bankCode + "00" + accNum.substring(0, 3) + accNum.substring(4, 6) + "0"
					+ accNum.substring(10, 16));
		}
		if (countryCode.equalsIgnoreCase("GQ")) {
			return (aff_bankCode + "00" + accNum.substring(0, 3) + accNum.substring(3, 6) + accNum.substring(8, 16));
		} else if (countryCode.equalsIgnoreCase("CM") || countryCode.equalsIgnoreCase("CM")) {
			return (aff_bankCode + ibanBrCode + accNum.substring(3, 6) + accNum.substring(8, 16));
		} else if (countryCode.equalsIgnoreCase("BF")) {
			return (aff_bankCode + "00" + accNum.substring(0, 3) + accNum.substring(4, 16));
		}
		// ECV RIB Change
		else if (countryCode.equalsIgnoreCase("CV")) {
			return (aff_bankCode + "0" + accNum.substring(0, 3) + accNum.substring(3, 6) + accNum.substring(8, 16));
		} else if (countryCode.equalsIgnoreCase("CG")) {
			// Change done for ECG specific for IBAN NO
			System.out.println("inside ECG for makeIBANString ");
			System.out.println("inside ECG for makeIBANString aff_bankCode " + aff_bankCode);
			System.out.println("inside ECG for makeIBANString accNum " + accNum);
			System.out.println("inside ECG for makeIBANString accNum1 " + accNum.substring(0, 3));
			System.out.println("inside ECG for makeIBANString accNum2 " + accNum.substring(3, 6));
			System.out.println("inside ECG for makeIBANString accNum3 " + accNum.substring(8, 16));
			return (aff_bankCode + "00" + accNum.substring(0, 3) + accNum.substring(3, 6) + accNum.substring(8, 16));
		} else {
			return (aff_bankCode + ibanBrCode + accNum.substring(4, 16));
		}
	}

	// **********************************************************************************//
	// Description :Method to Generate RIB Key
	// **********************************************************************************//
	public String ribKeyGenerate(String ibanAccString, String aff_bankCode, String ibanBrCode) {
		String rib = aff_bankCode;

		rib += ibanBrCode + ibanAccString + "00";

		String ribKey = clerib(rib);
		return ribKey;
	}

	// **********************************************************************************//
	// Description :Method to Generate RIB
	// **********************************************************************************//
	public String clerib(String rib) {
		int i;
		Long Reste;
		String s = "", CleRib = "";
		Reste = Long.parseLong("0");
		Reste = ((Reste * 10) + estlettre(rib.charAt(0))) % 97;
		Reste = ((Reste * 10) + estlettre(rib.charAt(1))) % 97;

		// Long Rest1=estlettre(rib.charAt(1));
		for (i = 2; i < rib.length(); i++) {
			if (i == 1) {
				// String rKey = estlettre(rib.substring(i,i+1)).toString();
				Reste = ((Reste * 10) + estlettre(rib.charAt(1))) % 97;
			} else
				Reste = ((Reste * 10) + Long.parseLong(rib.substring(i, i + 1))) % 97;
		}
		s = Long.toString(97 - Reste);
		if (s.length() == 1)
			CleRib = "0" + s;
		else
			CleRib = s;
		return CleRib;
	}

	// **********************************************************************************//
	// Description :Method to Generate RIB for ECG
	// **********************************************************************************//
	public String clerib1(String rib) {
		int i;
		Long Reste;
		String s = "", CleRib = "";
		Reste = Long.parseLong("0");
		for (i = 0; i < rib.length(); i++) {

			Reste = ((Reste * 10) + Long.parseLong(rib.substring(i, i + 1))) % 97;
		}
		s = Long.toString(97 - Reste);
		if (s.length() == 1)
			CleRib = "0" + s;
		else
			CleRib = s;

		System.out.println("CleRib1 aff_speci " + CleRib);
		return CleRib;
	}

	// **********************************************************************************//
	// Description :Method to Generate RIB
	// **********************************************************************************//
	public int estlettre(char e) {
		int letter;

		switch (e) {
		case 'K':
			letter = 2;
			;
			break;
		case 'B':
			letter = 5;
			break;
		case 'C':
			letter = 3;
			break;
		case 'A':
			letter = 1;
			break;
		case 'S':
			letter = 2;
			break;
		case 'D':
			letter = 4;
			break;
		case 'H':
			letter = 8;
			break;
		case 'T':
			letter = 7;
			break;
		case 'N':
			letter = 5;
			break;
		default:
			letter = 2;
			break;
		}
		return letter;
	}

	private String calucalteRibETG(int numBankCode, String accNum, String IbanBrCode) {
		String rib = "";
		String sBranchCode = accNum.substring(0, 3);
		int iBranchCode = Integer.parseInt(sBranchCode);

		int substr_acc1 = Integer.parseInt(accNum.substring(4, 10));
		int substr_acc2 = Integer.parseInt(accNum.substring(10, 16));

		/*
		 * System.out.println("iBranchCode "+iBranchCode);
		 * System.out.println("substr_acc1 "+substr_acc1);
		 * System.out.println("substr_acc2 "+substr_acc2);
		 */

		// long intrRIB= (17*30055+53*(1000+701)+81*111403+3*169801);

		int townCode = 1000;

		try {
			// townCode = Integer.parseInt(IbanBrCode);

			if (sBranchCode.equalsIgnoreCase("713")) {
				townCode = 2000;
			} else if (sBranchCode.equalsIgnoreCase("714")) {
				townCode = 4000;
			} else if (sBranchCode.equalsIgnoreCase("712")) {
				townCode = 5000;
			} else if (sBranchCode.equalsIgnoreCase("707")) {
				townCode = 6000;
			} else if (sBranchCode.equalsIgnoreCase("711")) {
				townCode = 7000;
			} else if (sBranchCode.equalsIgnoreCase("715")) {
				townCode = 10000;
			}
		} catch (Exception e) {
			townCode = 1000;
		}

		long intrRIB = (17 * numBankCode + 53 * (townCode + iBranchCode) + 81 * substr_acc1 + 3 * substr_acc2);

		// System.out.println("intrRIB "+intrRIB);

		long intrRIB2 = 97 - (intrRIB % 97);

		String ribKey = intrRIB2 + "";

		return ribKey;
	}

	private String calucalteRIBModuloLogic(String accNum, String IbanBrCode, String extraZero, String accNumPart,
			String countryCode) {
		String rib = "";
		String sBranchCode = accNum.substring(0, 3);

		String account = "00" + sBranchCode;

		if (countryCode.equalsIgnoreCase("BJ")) {
			rib += "21062" + IbanBrCode + accNumPart + extraZero;
		}
		if (countryCode.equalsIgnoreCase("CM") || countryCode.equalsIgnoreCase("CM")) {
			rib += "10029" + IbanBrCode + accNumPart + extraZero;
		} else {
			rib += IbanBrCode + account + accNumPart + extraZero;
		}

		String ribKey = calculateModulus(rib);

		return ribKey;
	}

	public String calculateModulus(String val) {
		String value = "";
		int len = 0;
		int midvalue = 0;
		char temp;
		len = val.length();

		for (int i = 0; i < len; i++) {
			temp = val.charAt(i);
			midvalue = (midvalue * 10) + (Character.getNumericValue(temp));
			if (midvalue > 97)
				midvalue = midvalue % 97;
		}

		midvalue = 97 - midvalue;

		if (midvalue < 0)
			midvalue = midvalue * (-1);

		value = Integer.toString(midvalue);

		if (midvalue < 10) {
			value = "0" + midvalue;
		}
		return value;
	}

	public String getGridDataXMLInOFFormat(JSONArray jsonArray) {
		DAC.mLogger.debug("Inside getGridDataXML method ... ");
		String xmlData = "";

		try {
			Iterator it = jsonArray.iterator();

			List<TreeMap<String, String>> list = new ArrayList<TreeMap<String, String>>();

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();

			Document document = db.newDocument();

			Element root = document.createElement("ListItems");
			document.appendChild(root);

			Element totalRecords = document.createElement("TotalRetrieved");
			totalRecords.appendChild(document.createTextNode(jsonArray.size() + ""));
			root.appendChild(totalRecords);

			int i = 0;
			while (it.hasNext()) {
				DAC.mLogger.debug("Loop ::" + i++);
				TreeMap<String, String> content = new TreeMap<String, String>();
				JSONObject obj = (JSONObject) it.next();
				for (Object e : obj.entrySet()) {
					Map.Entry entry = (Map.Entry) e;
					content.put(String.valueOf(entry.getKey()), entry.getValue().toString());
				}

				DAC.mLogger.debug("Content ::" + content);
				Element listItem = document.createElement("ListItem");

				// Element emptyTag = document.createElement("Tag");
				// listItem.appendChild(emptyTag);

				for (String e : content.keySet()) {
					DAC.mLogger.debug("Map Loop ::" + i + "           Key:" + e + "        Value:" + content.get(e));
					Element tag = document.createElement("SubItem");
					String tagValue = content.get(e);

					if (tagValue == null)
						tagValue = "";
					tag.appendChild(document.createTextNode(tagValue));
					listItem.appendChild(tag);
				}
				root.appendChild(listItem);

			}

			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer;

			transformer = tf.newTransformer();
			StringWriter writer = new StringWriter();
			transformer.transform(new DOMSource(document), new StreamResult(writer));
			xmlData = writer.getBuffer().toString();
			xmlData = xmlData.replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
			DAC.mLogger.debug("Output data :" + xmlData);
		} catch (Exception exc) {
			DAC.printException(exc);
		}

		return xmlData;
	}

	public String getGridDataXML(JSONArray jsonArray) {
		DAC.mLogger.debug("Inside getGridDataXML method ... ");
		String xmlData = "";

		try {
			Iterator it = jsonArray.iterator();

			List<TreeMap<String, String>> list = new ArrayList<TreeMap<String, String>>();

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();

			Document document = db.newDocument();

			Element root = document.createElement("ListItems");
			document.appendChild(root);

			Element totalRecords = document.createElement("TotalRetrieved");
			totalRecords.appendChild(document.createTextNode(jsonArray.size() + ""));
			root.appendChild(totalRecords);

			int i = 0;
			while (it.hasNext()) {
				DAC.mLogger.debug("Loop ::" + i++);
				TreeMap<String, String> content = new TreeMap<String, String>();
				JSONObject obj = (JSONObject) it.next();
				for (Object e : obj.entrySet()) {
					Map.Entry entry = (Map.Entry) e;
					content.put(String.valueOf(entry.getKey()), entry.getValue().toString());
				}

				DAC.mLogger.debug("Content ::" + content);
				Element listItem = document.createElement("ListItem");
				// root.appendChild(listItem);

				for (String e : content.keySet()) {
					DAC.mLogger.debug("Map Loop ::" + i + "           Key:" + e + "        Value:" + content.get(e));
					Element tag = document.createElement(e);
					String tagValue = content.get(e);

					if (tagValue == null)
						tagValue = "";
					tag.appendChild(document.createTextNode(tagValue));
					listItem.appendChild(tag);
				}
				root.appendChild(listItem);

			}

			TransformerFactory tf = TransformerFactory.newInstance();
			Transformer transformer;

			transformer = tf.newTransformer();
			StringWriter writer = new StringWriter();
			transformer.transform(new DOMSource(document), new StreamResult(writer));
			xmlData = writer.getBuffer().toString();
			xmlData = xmlData.replace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>", "");
			DAC.mLogger.debug("Output data :" + xmlData);
		} catch (Exception exc) {
			DAC.printException(exc);
		}

		return xmlData;
	}
	
	
	public  String UpdateWIHistory(String decision,String remarks,String rejectReason,String rejectreasoncodes,String entryDateTime,String histTable,IFormReference iform )
	{
		try
			{
				//SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
				//Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
				String formattedEntryDatetime=convertDateFormat(entryDateTime,"dd/MM/yyyy HH:mm:ss","dd-MMM-yyyy hh:mm:ss a",iform);
				DAC.mLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
	
				Date actionDateTime= new Date();
				String formattedActionDateTime=outputDateFormat.format(actionDateTime);
				DAC.mLogger.debug("FormattedActionDateTime: "+formattedActionDateTime);
	
				//Insert in WIHistory Table.
	
				String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME,REMARKS,REJECT_REASONS,REJECT_REASON_CODES";
				String columnValues="'"+getWorkitemName()+"','"+formattedActionDateTime+"','"+iform.getActivityName()+"','"
				+iform.getUserName()+"','"+decision+"','"+formattedEntryDatetime+"','"+remarks+"','"+rejectReason+"','"+rejectreasoncodes+"'";
				
				String apInsertInputXML=apInsert(iform.getCabinetName(), getSessionId(), columnNames, columnValues,histTable);
				DAC.mLogger.debug("APInsertInputXML: "+apInsertInputXML);
	
				String apInsertOutputXML = WFNGExecute(apInsertInputXML,iform.getServerIp(), iform.getServerPort());
				DAC.mLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);
	
				 if(apInsertOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
				 {
					 DAC.mLogger.info("inputXML AP  Insert Successful");
					 return "0";
				 }
				 else
				 {
					 DAC.mLogger.info("inputXML AP  Insert Failed");
					 return "";
				 }
			}

		catch(Exception e)
		{
			DAC.mLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			DAC.mLogger.error("Exception Occurred in Updating History  : "+result);
			System.out.println("Exception "+e);
		
		}
		return "";
	}
	
	public String convertDateFormat(String idate, String ipDateFormat, String opDateFormat, IFormReference iformObj,Locale...opLocale) {
        Locale defaultLocale = Locale.getDefault();

        DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", defaultLocale : " + defaultLocale);

        assert opLocale.length <= 1;
        Locale opDateFmtLocale = opLocale.length > 0 ? opLocale[0] : defaultLocale;

        DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", Loacle for output Date : " + opDateFmtLocale);
        try {
            if (idate == null) {
                return "";
            }
            if (idate.equalsIgnoreCase("")) {
                return "";
            }
            DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", idate :" + idate);
            String odate = "";
            DateFormat dfinput = new SimpleDateFormat(ipDateFormat);
            DateFormat dfoutput = new SimpleDateFormat(opDateFormat, opDateFmtLocale);

            Date dt = dfinput.parse(idate);
            DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", Indate " + dt);
            odate = dfoutput.format(dt);
            DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", Outdate " + odate);
            return odate;
        } catch (Exception e) {
        	DAC.mLogger.debug("Exception in date conversion:-"+e.toString());
            return "";
        }
    }
	
	public static String apInsert(String sCabName, String sSessionId, String colNames, String colValues, String tableName)
	{
		StringBuffer ipXMLBuffer=new StringBuffer();

		ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
		ipXMLBuffer.append("<APInsertExtd_Input>\n");
		ipXMLBuffer.append("<Option>APInsert</Option>");
		ipXMLBuffer.append("<TableName>");
		ipXMLBuffer.append(tableName);
		ipXMLBuffer.append("</TableName>");
		ipXMLBuffer.append("<ColName>");
		ipXMLBuffer.append(colNames);
		ipXMLBuffer.append("</ColName>\n");
		ipXMLBuffer.append("<Values>");
		ipXMLBuffer.append(colValues);
		ipXMLBuffer.append("</Values>\n");
		ipXMLBuffer.append("<EngineName>");
		ipXMLBuffer.append(sCabName);
		ipXMLBuffer.append("</EngineName>\n");
		ipXMLBuffer.append("<SessionId>");
		ipXMLBuffer.append(sSessionId);
		ipXMLBuffer.append("</SessionId>\n");
		ipXMLBuffer.append("</APInsertExtd_Input>");

		return ipXMLBuffer.toString();
	}
	
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort) throws IOException, Exception
	{
		DAC.mLogger.info("In WF NG Execute : " + serverPort);
		try
		{
			/*if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else*/
				return ngEjbClientStatus.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			DAC.mLogger.info("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	
}