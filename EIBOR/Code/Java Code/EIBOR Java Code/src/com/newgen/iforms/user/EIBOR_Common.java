package com.newgen.iforms.user;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Iterator;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.itextpdf.text.DocumentException;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.xmlapi.IFormXmlResponse;
//import com.newgen.iforms.user.*;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

import com.newgen.mvcbeans.model.wfobjects.WDGeneralData;
import com.itextpdf.awt.geom.Rectangle;
import com.itextpdf.text.BaseColor;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.AcroFields;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfStamper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.Phrase;

import ISPack.CImageServer;
import ISPack.CPISDocumentTxn;
import ISPack.ISUtil.JPDBRecoverDocData;
import ISPack.ISUtil.JPISException;
import ISPack.ISUtil.JPISIsIndex;
import Jdts.DataObject.JPDBString;

	public class EIBOR_Common {
		String sLocaleForMessage = java.util.Locale.getDefault().toString();
	
		static Map<String, String> EIBOR_ConfigProperties = new HashMap<String, String>();
	
		
		protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort, int flag) throws IOException {
			try {
				EIBOR.mLogger.info("WFNGExecute() : " + ipXML + " - " + jtsServerIP + " - " + serverPort + " - " + flag);
				if (serverPort.startsWith("33")) {
					EIBOR.mLogger.info("Inside if WFNGExecute() :");
					return WFCallBroker.execute(ipXML, jtsServerIP, Integer.parseInt(serverPort), 1);
				} else {
					EIBOR.mLogger.info("Inside else WFNGExecute() :");
					return NGEjbClient.getSharedInstance().makeCall(jtsServerIP, serverPort, "WebSphere", ipXML);
				}
				//
			} catch (Exception e) {
				EIBOR.mLogger.info("Exception Occured in WF NG Execute : " + e.getMessage());
				return "Error";
			}
	
		}
	
		public static void waiteloopExecute(long wtime) {
			try {
				for (int i = 0; i < 10; i++) {
					Thread.yield();
					Thread.sleep(wtime / 10);
				}
			} catch (InterruptedException e) {
				EIBOR.mLogger.info(e.toString());
				Thread.currentThread().interrupt();
			}
		}
	
	
	
		public static String maskXmlTags(List<List<String>> outputMQXML, String Tag) {
			Pattern p = Pattern.compile("(?<=" + Tag + ")([-\\s\\w]*)((?:[a-zA-Z0-9][-_\\s]*){0})");
			Matcher m = p.matcher((CharSequence) outputMQXML);
			StringBuffer maskedResult = new StringBuffer();
			while (m.find()) {
				String thisMask = m.group(1).replaceAll("[^-_\\s]", "*");
				m.appendReplacement(maskedResult, thisMask + "$2");
			}
			m.appendTail(maskedResult);
			return maskedResult.toString();
		}
	
		
		
		
	
		public String getSessionId(IFormReference iform) {
			return ((iform).getObjGeneralData()).getM_strDMSSessionId();
		}
	
		public String getItemIndex(IFormReference iform) {
			return ((iform).getObjGeneralData()).getM_strFolderId();
		}
	
		public  String getWorkitemName(IFormReference iform) {
			return ((iform).getObjGeneralData()).getM_strProcessInstanceId();
		}
	
		public void setControlValue(String controlName, String controlValue, IFormReference iform) {
			iform.setValue(controlName, controlValue);
		}
	
		public String getCabinetName(IFormReference iform) {
			return (String) iform.getCabinetName();
		}
	
		public String getUserName(IFormReference iform) {
			return (String) iform.getUserName();
		}
	
		public String getActivityName(IFormReference iform) {
			return (String) iform.getActivityName();
		}
	
		public String getControlValue(String controlName, IFormReference iform) {
			// return (String)EventHandler.iFormOBJECT.getControlValue(controlName);
			return (String) iform.getValue(controlName);
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
	
		public String ExecuteQueryOnServer(String sInputXML, IFormReference iform) {
			try {
				EIBOR.mLogger.debug("Server Ip :" + iform.getServerIp());
				EIBOR.mLogger.debug("Server Port :" + iform.getServerPort());
				EIBOR.mLogger.debug("Input XML :" + sInputXML);
	
				return NGEjbClient.getSharedInstance().makeCall(iform.getServerIp(), iform.getServerPort() + "",
						"WebSphere", sInputXML);
			} catch (Exception excp) {
				EIBOR.mLogger.debug("Exception occured in executing API on server :\n" + excp);
				EIBOR.printException(excp);
				return "Exception occured in executing API on server :\n" + excp;
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
				EIBOR.printException(e);
			}
			return "";
		}
	
		public String getTagValue(Node node, String tag) {
			NodeList nodeList = node.getChildNodes();
			int length = nodeList.getLength();
	
			for (int i = 0; i < length; ++i) {
				Node child = nodeList.item(i);
	
				if (child.getNodeType() == Node.ELEMENT_NODE && child.getNodeName().equalsIgnoreCase(tag)) {
					return child.getTextContent();
				}
			}
			return "";
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
	
		public String generateResponseString(String SaveFormData, String SuccessOrError, String preAlertMessage,
				String alertMessageCode, String postAlertMessage, String call, String data) {
			return "{'SAVEFORMDATA':'" + SaveFormData + "'," + "'SUCCESSORERROR':'" + SuccessOrError + "',"
					+ "'PREALERTMESSAGE':'" + preAlertMessage + "'," + "'ALERTMESSAGECODE':'" + alertMessageCode + "',"
					+ "'POSTALERTMESSAGE':'" + postAlertMessage + "'," + "'CALL':'" + call + "'," + "'DATA':'" + data
					+ "'}";
		}
		
	
		
		
		public int readConfig() {
			Properties properties = null;
			try {
				properties = new Properties();
				properties.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigProps"
						+ File.separator + "EIBORConfig.Properties")));
				EIBOR.mLogger.debug("properties :" + properties);
				Enumeration<?> names = properties.propertyNames();
				EIBOR.mLogger.debug("names :" + names);
	
				while (names.hasMoreElements()) {
					String name = (String) names.nextElement();
					EIBOR_ConfigProperties.put(name, properties.getProperty(name));
				}
			} catch (Exception e) {
				System.out.println("Exception in Read INI: " + e.getMessage());
				EIBOR.mLogger.error("Exception has occured while loading properties file " + e.getMessage());
				return -1;
			}
			return 0;
		}
		
		
		
		
		public static String getdateCurrentDateInSQLFormat()
		{
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:MM:ss");
			return simpleDateFormat.format(new Date());
		}
		
		public static String getAPUpdateIpXML(String tableName,String columnName,String strValues,String sWhere,String cabinetName,String sessionId)
		{
			if(strValues==null)
			{
				strValues = "''";
			}

			StringBuffer ipXMLBuffer=new StringBuffer();

			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<APUpdate_Input>\n");
			ipXMLBuffer.append("<Option>APUpdate</Option>");
			ipXMLBuffer.append("<TableName>");
			ipXMLBuffer.append(tableName);
			ipXMLBuffer.append("</TableName>\n");
			ipXMLBuffer.append("<ColName>");
			ipXMLBuffer.append(columnName);
			ipXMLBuffer.append("</ColName>\n");
			ipXMLBuffer.append("<Values>");
			ipXMLBuffer.append(strValues);
			ipXMLBuffer.append("</Values>\n");
			ipXMLBuffer.append("<WhereClause>");
			ipXMLBuffer.append(sWhere);
			ipXMLBuffer.append("</WhereClause>\n");
			ipXMLBuffer.append("<EngineName>");
			ipXMLBuffer.append(cabinetName);
			ipXMLBuffer.append("</EngineName>\n");
			ipXMLBuffer.append("<SessionId>");
			ipXMLBuffer.append(sessionId);
			ipXMLBuffer.append("</SessionId>\n");
			ipXMLBuffer.append("</APUpdate_Input>\n");

			return ipXMLBuffer.toString();
		}
		
		public static String apSelectWithColumnNames(String QueryString, String cabinetName, String sessionID)
		{
			StringBuffer ipXMLBuffer=new StringBuffer();

			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<APSelect_Input>\n");
			ipXMLBuffer.append("<Option>APSelectWithColumnNames</Option>\n");
			ipXMLBuffer.append("<Query>");
			ipXMLBuffer.append(QueryString);
			ipXMLBuffer.append("</Query>\n");
			ipXMLBuffer.append("<EngineName>");
			ipXMLBuffer.append(cabinetName);
			ipXMLBuffer.append("</EngineName>\n");
			ipXMLBuffer.append("<SessionId>");
			ipXMLBuffer.append(sessionID);
			ipXMLBuffer.append("</SessionId>\n");
			ipXMLBuffer.append("</APSelect_Input>");

			return ipXMLBuffer.toString();
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
		
		public static String getAPProcedureInputXML(String engineName,String sSessionId,String procName,String Params)
		{
			StringBuffer bfrInputXML = new StringBuffer();
			bfrInputXML.append("<?xml version=\"1.0\"?>\n");
			bfrInputXML.append("<APProcedure_WithDBO_Input>\n");
			bfrInputXML.append("<Option>APProcedure_WithDBO</Option>\n");
			bfrInputXML.append("<ProcName>");
			bfrInputXML.append(procName);
			bfrInputXML.append("</ProcName>");
			bfrInputXML.append("<Params>");
			bfrInputXML.append(Params);
			bfrInputXML.append("</Params>");
			bfrInputXML.append("<EngineName>");
			bfrInputXML.append(engineName);
			bfrInputXML.append("</EngineName>");
			bfrInputXML.append("<SessionId>");
			bfrInputXML.append(sSessionId);
			bfrInputXML.append("</SessionId>");
			bfrInputXML.append("</APProcedure_WithDBO_Input>");		
			return bfrInputXML.toString();
		}
		

}