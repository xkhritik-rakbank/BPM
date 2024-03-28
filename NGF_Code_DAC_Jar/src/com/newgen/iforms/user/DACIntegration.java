package com.newgen.iforms.user;

import com.newgen.iforms.*;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import java.awt.print.Printable;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.Socket;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Properties;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.parsers.ParserConfigurationException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.CharacterData;

public class DACIntegration extends DACCommon {
	// private Map executeXMLMapMain=new HashMap();
	LinkedHashMap<String, String> executeXMLMapMain = new LinkedHashMap<String, String>();

	public String onclickevent(IFormReference iformObj, String control, String StringData) {
		String MQ_response = "";
		String MQ_response_Entity = "";
		String MQ_response_Account = "";
		String MQ_response1 = "";
		String MQ_response_Entity1 = "";
		String MQ_response_Account1 = "";
		// String [] opt ;
		String CIFID = "";
		String CustomerName = "";
		String CIFType = "";
		String AccountNumber = "";
		String strAccountCategory = "";
		String strAccountType = "";
		String strProductID = "";
		String strAccountName = "";
		String AccountStatus = "";
		String strIsIslamic = "";
		String AcctType = "";
		String ARMCode = "";
		String RakElite = "";
		String TradeLicense = "";
		String TradeLicenseExpiryDate = "";
		String TLExpiryDate = "";
		String CifId = "";
		String Blacklisted = "";
		String Negated = "";
		String Companyname = "";
		String strIsAECBConsent = "";
		String Sub_Segment = "";
		String Primaryemail = "";
		String CifType = "";
		String selectedcif = "";
		String IsRetailCus = "";
		String Return_Code_Sig = "";
		int returnedSignatures = 0;
		String ReturnCode1 = "";
		String ReturnCode2 = "";
		String ReturnCode3 = "";
		String Error_Cif = "Error";
		String MainCifId = "";
		String MainCustomerName = "";
		String MainCifType = "";
		String IsRetail = "";
		String ReturnDesc = "";

		Map RecordFileMap;

		try {
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", Inside onclickevent function");

			if (control.equals("btn_Populate")) {
				DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
						+ ", inside onclick function for customer detail call 1");
				MQ_response = MQ_connection_response(iformObj, control, StringData);

				MQ_response = MQ_response.substring(MQ_response.indexOf("<?xml v"),
						MQ_response.indexOf("</MQ_RESPONSE_XML>"));
				// DAC.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME:
				// "+getActivityName()+", Inside btn_CIF_Search function "+MQ_response);
				if (MQ_response.indexOf("<ReturnCode>") != -1) {
					ReturnCode1 = MQ_response.substring(
							MQ_response.indexOf("<ReturnCode>") + "</ReturnCode>".length() - 1,
							MQ_response.indexOf("</ReturnCode>"));

				}
				if (MQ_response.indexOf("<ReturnDesc>") != -1) {
					ReturnDesc = MQ_response.substring(
							MQ_response.indexOf("<ReturnDesc>") + "</ReturnDesc>".length() - 1,
							MQ_response.indexOf("</ReturnDesc>"));

				}
				DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
						+ ", Return  code for the Customer Details call" + ReturnCode1);

				if (ReturnCode1.equals("0000")) {

					DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
							+ ", Clicked search button");

					MQ_response_Entity = MQ_response;

					if (MQ_response_Entity.contains("<IsRetailCust>")) {
						String IsRetailCust = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<IsRetailCust>") + "</IsRetailCust>".length() - 1,
								MQ_response_Entity.indexOf("</IsRetailCust>"));
						if(IsRetailCust.equalsIgnoreCase("Y"))
							setControlValue("IS_RETAIL_CUSTOMER", "Yes");
						else
							setControlValue("IS_RETAIL_CUSTOMER", "No");
					}

					if (MQ_response_Entity.contains("<Title>")) {
						String Title = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<Title>") + "</Title>".length() - 1,
								MQ_response_Entity.indexOf("</Title>"));
						setControlValue("TITLE", Title);
					}

					if (MQ_response_Entity.contains("<Gender>")) {
						String Gender = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<Gender>") + "</Gender>".length() - 1,
								MQ_response_Entity.indexOf("</Gender>"));
						setControlValue("GENDER", Gender);
					}
					
					if (MQ_response_Entity.contains("<FirstName>")) {
						String FirstName = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<FirstName>") + "</FirstName>".length() - 1,
								MQ_response_Entity.indexOf("</FirstName>"));
						setControlValue("FIRST_NAME", FirstName);
					}
					
					if (MQ_response_Entity.contains("<MiddleName>")) {
						String MiddleName = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<MiddleName>") + "</MiddleName>".length() - 1,
								MQ_response_Entity.indexOf("</MiddleName>"));
						setControlValue("MIDDLE_NAME", MiddleName);
					}
					
					if (MQ_response_Entity.contains("<LastName>")) {
						String LastName = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<LastName>") + "</LastName>".length() - 1,
								MQ_response_Entity.indexOf("</LastName>"));
						setControlValue("LAST_NAME", LastName);
					}
					
					if (MQ_response_Entity.contains("<MothersName>")) {
						String MothersName = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<MothersName>") + "</MothersName>".length() - 1,
								MQ_response_Entity.indexOf("</MothersName>"));
						setControlValue("MOTHERS_MAIDEN_NAME", MothersName);
					}
					
					if (MQ_response_Entity.contains("<ResidentCountry>")) {
						String ResidentCountry = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<ResidentCountry>") + "</ResidentCountry>".length() - 1,
								MQ_response_Entity.indexOf("</ResidentCountry>"));
						setControlValue("COUNTRY_OF_RESIDENCE", ResidentCountry);
					}
					
					if (MQ_response_Entity.contains("<Nationality>")) {
						String Nationality = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<Nationality>") + "</Nationality>".length() - 1,
								MQ_response_Entity.indexOf("</Nationality>"));
						setControlValue("NATIONALITY", Nationality);
					}
					
					if (MQ_response_Entity.contains("<CustomerType>")) {
						String CustomerType = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<CustomerType>") + "</CustomerType>".length() - 1,
								MQ_response_Entity.indexOf("</CustomerType>"));
						setControlValue("CUSTOMER_TYPE", CustomerType);
					}
					
					if (MQ_response_Entity.contains("<CustomerSegment>")) {
						String CustomerSegment = MQ_response_Entity.substring(
								MQ_response_Entity.indexOf("<CustomerSegment>") + "</CustomerSegment>".length() - 1,
								MQ_response_Entity.indexOf("</CustomerSegment>"));
						setControlValue("CUSTOMER_SEGMENT", CustomerSegment);
					}

					if (MQ_response_Entity.contains("<DocumentDet>")) {
						Document recordDoc2 = MapXML.getDocument(MQ_response_Entity);
						NodeList records2 = MapXML.getNodeListFromDocument(recordDoc2, "DocumentDet");
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", Total Lines returned for document tag: " + records2.getLength());
						if (records2.getLength() > 0) {
							for (int rec2 = 0; rec2 < records2.getLength(); rec2++) {
								if (MapXML.getTagValueFromNode(records2.item(rec2), "DocType")
										.equalsIgnoreCase("EMID")) {
									String docId = MapXML.getTagValueFromNode(records2.item(rec2), "DocId");
									setControlValue("EMIRATES_ID", docId);
								}
								if (MapXML.getTagValueFromNode(records2.item(rec2), "DocType")
										.equalsIgnoreCase("Passport")) {
									String docId = MapXML.getTagValueFromNode(records2.item(rec2), "DocId");
									setControlValue("PASSPORT_NUMBER", docId);
								}
								if (MapXML.getTagValueFromNode(records2.item(rec2), "DocType")
										.equalsIgnoreCase("Visa")) {
									String docId = MapXML.getTagValueFromNode(records2.item(rec2), "DocId");
									setControlValue("VISA_UID_NUMBER", docId);
								}
							}
						}
					}

					if (MQ_response_Entity.contains("<PhnDet>")) {
						Document recordDoc2 = MapXML.getDocument(MQ_response_Entity);
						NodeList records2 = MapXML.getNodeListFromDocument(recordDoc2, "PhnDet");
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", Total Lines returned for Phone tag: " + records2.getLength());
						if (records2.getLength() > 0) {
							for (int rec2 = 0; rec2 < records2.getLength(); rec2++) {
								if (MapXML.getTagValueFromNode(records2.item(rec2), "PhnPrefFlag").equalsIgnoreCase("Y")) {
									String cntrycode = MapXML.getTagValueFromNode(records2.item(rec2), "PhnCountryCode");
									setControlValue("MOB_NUMBER_COUNTRY_CODE", cntrycode);
									String mobnumber = MapXML.getTagValueFromNode(records2.item(rec2), "PhnLocalCode");
									setControlValue("MOBILE_NUMBER", mobnumber);
									break;
								}
							}
						}
					}
					
					if (MQ_response_Entity.contains("<EmailDet>")) {
						Document recordDoc2 = MapXML.getDocument(MQ_response_Entity);
						NodeList records2 = MapXML.getNodeListFromDocument(recordDoc2, "EmailDet");
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", Total Lines returned for Email tag: " + records2.getLength());
						if (records2.getLength() > 0) {
							for (int rec2 = 0; rec2 < records2.getLength(); rec2++) {
								if (MapXML.getTagValueFromNode(records2.item(rec2), "MailPrefFlag").equalsIgnoreCase("Y")) {
									String cntrycode = MapXML.getTagValueFromNode(records2.item(rec2), "EmailID");
									setControlValue("EMAIL_ID", cntrycode);
									break;
								}
							}
						}
					}

					return ReturnCode1 + "~" + ReturnDesc +"~End";

				}
			}


		}

		catch (Exception exc) {
			DAC.printException(exc);
			DAC.mLogger.debug(
					"WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", Exception 2 - " + exc);
		}

		return "";
	}

	public String MQ_connection_response(IFormReference iformObj, String control, String Data) {

		DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
				+ ", Inside MQ_connection_response function");
		final WDGeneralData wdgeneralObj;
		Socket socket = null;
		OutputStream out = null;
		InputStream socketInputStream = null;
		DataOutputStream dout = null;
		DataInputStream din = null;
		String mqOutputResponse = null;
		String mqOutputResponse1 = null;
		String mqInputRequest = null;
		String cabinetName = getCabinetName();
		String wi_name = getWorkitemName();
		String ws_name = getActivityName();
		String sessionID = getSessionId();
		String userName = getUserName();
		String socketServerIP;
		int socketServerPort;
		wdgeneralObj = iformObj.getObjGeneralData();
		sessionID = wdgeneralObj.getM_strDMSSessionId();
		String CIFNumber = "";
		
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String Extra2CurrentDateTime = sdf1.format(d1)+"+04:00";
		
		if (control.equals("btn_Populate")) {
			CIFNumber = getControlValue("REQUEST_FOR_CIF");
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", CIFNumber for the first entity detail call is --" + CIFNumber);

			StringBuilder finalXml = new StringBuilder("<EE_EAI_MESSAGE>\n"+
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>saddd</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>"+Extra2CurrentDateTime+"</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIFNumber+"</CIFID><ACCType></ACCType>\n"+
				"<ACCNumber></ACCNumber><EmiratesID></EmiratesID><InquiryType>CustomerAndAccount</InquiryType>\n"+
				"<RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2>\n"+
				"<FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE>");

			mqInputRequest = getMQInputXML(sessionID, cabinetName, wi_name, ws_name, userName, finalXml);
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", mqInputRequest for  ENTITY_DETAILS call" + mqInputRequest);

		}

		

		try {

			DAC.mLogger.debug(
					"WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", userName " + userName);
			DAC.mLogger.debug(
					"WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", sessionID " + sessionID);

			String sMQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'DAC' and CallingSource='Form'";
			List<List<String>> outputMQXML = iformObj.getDataFromDB(sMQuery);
			// CreditCard.mLogger.info("$$outputgGridtXML "+ "sMQuery " + sMQuery);
			if (!outputMQXML.isEmpty()) {
				// CreditCard.mLogger.info("$$outputgGridtXML "+ outputMQXML.get(0).get(0) + ","
				// + outputMQXML.get(0).get(1));
				socketServerIP = outputMQXML.get(0).get(0);
				DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
						+ ", socketServerIP " + socketServerIP);
				socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
				DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
						+ ", socketServerPort " + socketServerPort);

				DAC.mLogger.debug(" outside socket" + socket);

				if (!("".equalsIgnoreCase(socketServerIP) && socketServerIP == null && socketServerPort == 0)) {
					socket = new Socket(socketServerIP, socketServerPort);

					int connection_timeout = 60;
					try {
						connection_timeout = 70;
						
					} catch (Exception e) {
						connection_timeout = 60;
					}

					socket.setSoTimeout(connection_timeout * 1000);
					out = socket.getOutputStream();

					DAC.mLogger.debug("connection timeout" + connection_timeout);
					DAC.mLogger.debug(" inside socket" + socket);
					DAC.mLogger.debug("out" + out);

					socketInputStream = socket.getInputStream();

					DAC.mLogger.debug("socketInputStream" + socketInputStream);

					dout = new DataOutputStream(out);
					din = new DataInputStream(socketInputStream);

					DAC.mLogger.debug("dout" + dout);
					DAC.mLogger.debug("din" + din);

					DAC.mLogger.debug(
							"WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", dout " + dout);
					DAC.mLogger
							.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName() + ", din " + din);
					mqOutputResponse = "";
					mqOutputResponse1 = "";

					if (mqInputRequest != null && mqInputRequest.length() > 0) {
						int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", Final XML output len: " + outPut_len + "");
						mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", MqInputRequest" + "Input Request Bytes : " + mqInputRequest.getBytes("UTF-16LE"));
						dout.write(mqInputRequest.getBytes("UTF-16LE"));
						dout.flush();
					}
					byte[] readBuffer = new byte[500];
					int num = din.read(readBuffer);
					if (num > 0) {

						byte[] arrayBytes = new byte[num];
						System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
						mqOutputResponse = mqOutputResponse + new String(arrayBytes, "UTF-16LE");
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", mqOutputResponse/message ID :  " + mqOutputResponse);

						mqOutputResponse1 = mqOutputResponse1 + new String(arrayBytes, "UTF-16LE");
						DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
								+ ", mqOutputResponse1/message ID :  " + mqOutputResponse1);

						if (!"".equalsIgnoreCase(mqOutputResponse) && control.equalsIgnoreCase("btn_Populate")) {
							mqOutputResponse = getOutWtthMessageID("ENTITY_DETAILS", iformObj, mqOutputResponse);
							
						}

						if (mqOutputResponse.contains("&lt;")) {
							mqOutputResponse = mqOutputResponse.replaceAll("&lt;", "<");
							mqOutputResponse = mqOutputResponse.replaceAll("&gt;", ">");
						}
					}
					socket.close();
					DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
							+ ", mqOutputResponse::::::::::::  " + mqOutputResponse);
					return mqOutputResponse;

				} else {
					DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
							+ ", SocketServerIp and SocketServerPort is not maintained " + "");
					DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
							+ ", SocketServerIp is not maintained " + socketServerIP);
					DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
							+ ", SocketServerPort is not maintained " + socketServerPort);
					return "MQ details not maintained";
				}
			} else {
				DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
						+ ", SOcket details are not maintained in NG_BPM_MQ_TABLE table" + "");
				return "MQ details not maintained";
			}

		} catch (Exception e) {
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", Exception Occured Mq_connection_CC" + e.getStackTrace());
			return "";
		} finally {
			try {
				if (out != null) {

					out.close();
					out = null;
				}
				if (socketInputStream != null) {

					socketInputStream.close();
					socketInputStream = null;
				}
				if (dout != null) {

					dout.close();
					dout = null;
				}
				if (din != null) {

					din.close();
					din = null;
				}
				if (socket != null) {
					if (!socket.isClosed()) {
						socket.close();
					}
					socket = null;
				}
			} catch (Exception e) {
				DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
						+ ", Final Exception Occured Mq_connection_CC" + e.getStackTrace());
				// printException(e);
			}
		}
	}

	private static String getMQInputXML(String sessionID, String cabinetName, String wi_name, String ws_name,
			String userName, StringBuilder final_xml) {
		// FormContext.getCurrentInstance().getFormConfig();
		DAC.mLogger.debug("inside getMQInputXML function");
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_DAC_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_xml);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		return strBuff.toString();
	}

	
	public String getOutWtthMessageID(String callName, IFormReference iformObj, String message_ID) {
		String outputxml = "";
		try {
			// String wi_name = iformObj.getWFWorkitemName();
			String wi_name = getWorkitemName();
			String str_query = "select OUTPUT_XML from NG_DAC_XMLLOG_HISTORY with (nolock) where CALLNAME ='" + callName
					+ "' and MESSAGE_ID ='" + message_ID + "' and WI_NAME = '" + wi_name + "'";
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", inside getOutWtthMessageID str_query: " + str_query);
			List<List<String>> result = iformObj.getDataFromDB(str_query);
			// below code added by nikhil 18/10 for Connection timeout
			// String
			// Integration_timeOut=NGFUserResourceMgr_CreditCard.getGlobalVar("Inegration_Wait_Count");
			String Integration_timeOut = "100";
			int Loop_wait_count = 10;
			try {
				Loop_wait_count = Integer.parseInt(Integration_timeOut);
			} catch (Exception ex) {
				Loop_wait_count = 10;
			}

			for (int Loop_count = 0; Loop_count < Loop_wait_count; Loop_count++) {
				if (result.size() > 0) {
					outputxml = result.get(0).get(0);
					break;
				} else {
					Thread.sleep(1000);
					result = iformObj.getDataFromDB(str_query);
				}
			}

			if ("".equalsIgnoreCase(outputxml)) {
				outputxml = "Error";
			}
			DAC.mLogger.debug("This is output xml from DB");
			String outputxmlMasked = outputxml;
			DAC.mLogger.debug("The output XML is " + outputxml);
			outputxmlMasked = maskXmlogBasedOnCallType(outputxmlMasked, callName); // uncomment it at UAT
			DAC.mLogger.debug("Masked output XML is " + outputxmlMasked);
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", getOutWtthMessageID" + outputxmlMasked);
		} catch (Exception e) {
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", Exception occurred in getOutWtthMessageID" + e.getMessage());
			DAC.mLogger.debug("WINAME : " + getWorkitemName() + ", WSNAME: " + getActivityName()
					+ ", Exception occurred in getOutWtthMessageID" + e.getStackTrace());
			outputxml = "Error";
		}
		return outputxml;
	}

	
	public String maskXmlogBasedOnCallType(String outputxmlMasked, String callType) {
		String Tags = "";
		if (callType.equalsIgnoreCase("CUSTOMER_DETAILS")) {
			outputxmlMasked = outputxmlMasked.replace("(", " ").replace(")", " ").replace("@", " ").replace("+", " ")
					.replace("&amp;/", " ").replace("&amp; /", " ").replace(".", " ").replace(",", " ");
			Tags = "<ACCNumber>~,~<AccountName>~,~<ECRNumber>~,~<DOB>~,~<MothersName>~,~<IBANNumber>~,~<DocId>~,~<DocExpDt>~,~<DocIssDate>~,~<PassportNum>~,~<MotherMaidenName>~,~<LinkedDebitCardNumber>~,~<FirstName>~,~<MiddleName>~,~<LastName>~,~<FullName>~,~<ARMCode>~,~<ARMName>~,~<PhnCountryCode>~,~<PhnLocalCode>~,~<PhoneNo>~,~<EmailID>~,~<CustomerName>~,~<CustomerMobileNumber>~,~<PrimaryEmailId>~,~<Fax>~,~<AddressType>~,~<AddrLine1>~,~<AddrLine2>~,~<AddrLine3>~,~<AddrLine4>~,~<POBox>~,~<City>~,~<Country>~,~<AddressLine1>~,~<AddressLine2>~,~<AddressLine3>~,~<AddressLine4>~,~<CityCode>~,~<State>~,~<CountryCode>~,~<Nationality>~,~<ResidentCountry>~,~<PrimaryContactName>~,~<PrimaryContactNum>~,~<SecondaryContactName>~,~<SecondaryContactNum>";

		}

		else if (callType.equalsIgnoreCase("ACCOUNT_SUMMARY")) {
			outputxmlMasked = outputxmlMasked.replace("(", " ").replace(")", " ").replace("@", " ").replace("+", " ")
					.replace("&amp;/", " ").replace("&amp; /", " ").replace(".", " ").replace(",", " ");
			Tags = "<Acid>~,~<Foracid>~,~<NicName>~,~<AccountName>~,~<AcctBal>~,~<LoanAmtAED>~,~<AcctOpnDt>~,~<MaturityAmt>~,~<EffAvailableBal>~,~<EquivalentAmt>~,~<LedgerBalanceinAED>~,~<LedgerBalance>";
		} else if (callType.equalsIgnoreCase("SIGNATURE_DETAILS")) {
			outputxmlMasked = outputxmlMasked.replace("&amp;/", " ").replace("&amp; /", " ").replace(".", " ")
					.replace(",", " ");
			Tags = "<CustomerName>";
		}
		if (!Tags.equalsIgnoreCase("")) {
			String Tag[] = Tags.split("~,~");
			for (int i = 0; i < Tag.length; i++) {
				outputxmlMasked = maskXmlTags(outputxmlMasked, Tag[i]);
			}
		}
		return outputxmlMasked;
	}

}
