package com.newgen.iforms.user;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.Socket;
import java.util.LinkedHashMap;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.newgen.iforms.custom.IFormReference;
import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
	
public class KYC_Remediation_Integration extends KYC_Remediation_Common 
{		
		LinkedHashMap<String,String> executeXMLMapMain = new LinkedHashMap<String,String>();
		public static String XMLLOG_HISTORY="NG_DAO_XMLLOG_HISTORY";

	public String onclickevent(IFormReference iform,String control,String StringData) throws FileNotFoundException, IOException, ParserConfigurationException, SAXException 
	{
		
			return "";
		
	}     
	
	public static String readFileFromServer(String filename)
	{
		KYC_Remediation.mLogger.debug("inside readFileFromServer--" + filename);
		String xmlReturn = "";
		try {
			File file = new File(filename);
			FileReader fileReader = new FileReader(file);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
			StringBuffer stringBuffer = new StringBuffer();
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
				stringBuffer.append("\n");
			}
			fileReader.close();
			KYC_Remediation.mLogger.debug("Contents of file:");
			xmlReturn = stringBuffer.toString();
			KYC_Remediation.mLogger.debug("file content" + xmlReturn);

		} catch (IOException e) {
			e.printStackTrace();
		}
		return xmlReturn;
	}
	
	public static String writeFileFromServer(String filename,String oldString)
	{
		 String newString=oldString;	
		KYC_Remediation.mLogger.debug("\n Inside writeFileFromServer function");
		
		try {
			
            FileOutputStream out = new FileOutputStream(filename);
			out.write(newString.getBytes());
			out.close();
		} catch (IOException e) {
			KYC_Remediation.mLogger.debug("The Exception is "+e.getMessage());
			e.printStackTrace();
		}
			return newString;
	}

	public static String MQ_connection_response(IFormReference iform,String control,String Data, String finalXml)  
	{
		
		KYC_Remediation.mLogger.debug("Inside MQ_connection_response function");
		final WDGeneralData wdgeneralObj;
		Socket socket = null;
		OutputStream out = null;
		InputStream socketInputStream = null;
		DataOutputStream dout = null;
		DataInputStream din = null;
		String mqOutputResponse = null;
		String mqInputRequest = null;
		String cabinetName = getCabinetName(iform);
		String wi_name = getWorkitemName(iform);
		String ws_name = getActivityName(iform);
		String sessionID = getSessionId(iform);
		String userName = getUserName(iform);
		String socketServerIP;
		int socketServerPort;
		wdgeneralObj = iform.getObjGeneralData();
		sessionID = wdgeneralObj.getM_strDMSSessionId();

		try {
			KYC_Remediation.mLogger.debug("onclickevent : MQ_connection_response : final_xml :" + finalXml);
			mqInputRequest = getMQInputXML(sessionID, cabinetName, wi_name, ws_name, userName, finalXml);
			KYC_Remediation.mLogger.debug("$$outputgGridtXML " + "mqInputRequest for Signature Details call" + mqInputRequest);

			String sMQuery = "SELECT SocketServerIP, SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'KYC_Remediation' and CallingSource = 'Form'";
			List<List<String>> outputMQXML = iform.getDataFromDB(sMQuery);
			if (!outputMQXML.isEmpty()) {
				socketServerIP = outputMQXML.get(0).get(0);
				socketServerPort = Integer.parseInt(outputMQXML.get(0).get(1));
				KYC_Remediation.mLogger.debug("socketServerIP : " + socketServerIP);
				KYC_Remediation.mLogger.debug("SocketServerPort : " + socketServerPort);
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
					socketInputStream = socket.getInputStream();
					dout = new DataOutputStream(out);
					din = new DataInputStream(socketInputStream);
					KYC_Remediation.mLogger.debug("dout " + dout);
					KYC_Remediation.mLogger.debug("din " + din);
					mqOutputResponse = "";

					if (mqInputRequest != null && mqInputRequest.length() > 0) {
						int outPut_len = mqInputRequest.getBytes("UTF-16LE").length;
						KYC_Remediation.mLogger.debug("Final XML output len: " + outPut_len + "");
						mqInputRequest = outPut_len + "##8##;" + mqInputRequest;
						KYC_Remediation.mLogger.debug("MqInputRequest Input Request Bytes : " + mqInputRequest.getBytes("UTF-16LE"));
						dout.write(mqInputRequest.getBytes("UTF-16LE"));
						dout.flush();
					}

					byte[] readBuffer = new byte[50000];
					int num = din.read(readBuffer);
					if (num > 0) {

						byte[] arrayBytes = new byte[num];
						System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
						mqOutputResponse = mqOutputResponse + new String(arrayBytes, "UTF-16LE");
						KYC_Remediation.mLogger.debug("mqOutputResponse/message ID :  " + mqOutputResponse);
						if (!"".equalsIgnoreCase(mqOutputResponse) && "Risk_score_trigger".equalsIgnoreCase(control)) {
							mqOutputResponse = getOutWtthMessageID("RISK_SCORE_DETAILS", iform, mqOutputResponse);
						} else if (!"".equalsIgnoreCase(mqOutputResponse) && "sign_upload".equalsIgnoreCase(control)) {
							mqOutputResponse = getOutWtthMessageID("SIGNATURE_ADDITION_REQ", iform, mqOutputResponse);
						} else if (!"".equalsIgnoreCase(mqOutputResponse) && "CIF_update".equalsIgnoreCase(control)) {
							mqOutputResponse = getOutWtthMessageID("CUSTOMER_UPDATE_REQ", iform, mqOutputResponse);
						}
						
						if (mqOutputResponse.contains("&lt;")) {
							mqOutputResponse = mqOutputResponse.replaceAll("&lt;", "<");
							mqOutputResponse = mqOutputResponse.replaceAll("&gt;", ">");
						}
					}
					socket.close();
					return mqOutputResponse;

				} else {
					KYC_Remediation.mLogger.debug("SocketServerIp and SocketServerPort is not maintained " + "");
					return "MQ details not maintained";
				}
			} else {
				KYC_Remediation.mLogger.debug("SOcket details are not maintained in NG_RLOS_MQ_TABLE table" + "");
				return "MQ details not maintained";
			}

		} catch (Exception e) {
			KYC_Remediation.mLogger.debug("Exception Occurred Mq_connection_CC" + e.getStackTrace());
			return "Error";
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
				KYC_Remediation.mLogger.debug("Final Exception Occurred Mq_connection_CC" + e.getStackTrace());
			}
		}
	}
	
	
	private static String getMQInputXML(String sessionID, String cabinetName, String wi_name, String ws_name, String userName, String final_xml) {
			StringBuffer strBuff = new StringBuffer();
			strBuff.append("<APMQPUTGET_Input>");
			strBuff.append("<SessionId>" + sessionID + "</SessionId>");
			strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
			strBuff.append("<XMLHISTORY_TABLENAME>NG_KYC_Remedation_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
			strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
			strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
			strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
			strBuff.append("<MQ_REQUEST_XML>");
			strBuff.append(final_xml);
			strBuff.append("</MQ_REQUEST_XML>");
			strBuff.append("</APMQPUTGET_Input>");
			return strBuff.toString();
		}
		
	public static String getOutWtthMessageID(String callName, IFormReference iform, String message_ID) {
		String outputxml = "";
		try {
			KYC_Remediation.mLogger.debug("inside getOutWtthMessageID: ");
			String wi_name = getWorkitemName(iform);
			String str_query = "select OUTPUT_XML from NG_KYC_Remedation_XMLLOG_HISTORY with (nolock) where CALLNAME ='" + callName + "' and MESSAGE_ID ='" + message_ID + "' and WI_NAME = '" + wi_name + "'";
			KYC_Remediation.mLogger.debug("inside getOutWtthMessageID str_query: " + str_query);
			List<List<String>> result = iform.getDataFromDB(str_query);
			String Integration_timeOut = "100";
			int Loop_wait_count = 10;
			try {
				Loop_wait_count = Integer.parseInt(Integration_timeOut);
			} catch (Exception ex) {
				Loop_wait_count = 10;
			}

			for (int Loop_count = 0; Loop_count < Loop_wait_count; Loop_count++) {
				KYC_Remediation.mLogger.debug("result : " + result.size());
				if (result.size() > 0) {
					KYC_Remediation.mLogger.debug("result : " + result.get(0).get(0));
					outputxml = result.get(0).get(0);
					break;
				} else {
					Thread.sleep(1000);
					result = iform.getDataFromDB(str_query);
				}
			}

			if ("".equalsIgnoreCase(outputxml)) {
				outputxml = "Error";
			}
			KYC_Remediation.mLogger.debug("getOutWtthMessageID" + outputxml);
		} catch (Exception e) {
			KYC_Remediation.mLogger.debug("Exception occurred in getOutWtthMessageID" + e.getMessage());
			KYC_Remediation.mLogger.debug("Exception occurred in getOutWtthMessageID" + e.getStackTrace());
			outputxml = "Error";
		}
		return outputxml;
	}
	
	public Document getDocument(String xml) throws ParserConfigurationException, SAXException, IOException {
		// Step 1: create a DocumentBuilderFactory
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

		// Step 2: create a DocumentBuilder
		DocumentBuilder db = dbf.newDocumentBuilder();

		// Step 3: parse the input file to get a Document object
		Document doc = db.parse(new InputSource(new StringReader(xml)));
		KYC_Remediation.mLogger.debug("xml is-" + xml);
		return doc;
	}
	
}


