/*
---------------------------------------------------------------------------------------------------------
                  NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                   : Application - Projects
Project/Product			: RAK BPM
Application				: RAK BPM Utility
Module					: DAC CBS
File Name				: DACCBS.java
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

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;

public class KYC_CBS implements Runnable
{
	private String NBTL_WIHISTORY="USR_0_NBTL_WIHISTORY";
	
	private static NGEjbClient ngEjbClientKYC_CBS;
	static Map<String, String> KYC_CBSConfigParamMap= new HashMap<String, String>();
	private String KYC_EXTTABLE = "RB_KYC_REM_EXTTABLE";
	private final String ws_name="System_Integration";
	private String entryDateTime="";
	private String strIntegrationErrCode="";
	private String strIntegrationErrRemarks="";
	private String attributesTag = "";
	private String getWorkItemInputXML = "";
	private String getWorkItemOutputXml = "";
	private XMLParser xmlParserGetWorkItem = new XMLParser();
	private String getWorkItemMainCode = "";
	private String emailBody = "";
	private String mailFrom = "";
	private String mailSubject = "";
	private String activityName = "";
	KYC_CBSIntegration objKYC_CBSIntegration=new KYC_CBSIntegration();
	public void run()
	{
		String sessionID = "";
		String cabinetName = "";
		String jtsIP = "";
		String jtsPort = "";
		String smsPort = "";
		String queueID = "";
		int integrationWaitTime=0;
		int sleepIntervalInMin=0;

		try
		{
			KYC_CBSLog.setLogger();
			ngEjbClientKYC_CBS = NGEjbClient.getSharedInstance();

			KYC_CBSLog.KYC_CBSLogger.debug("Connecting to Cabinet.");

			int configReadStatus = readConfig();

			KYC_CBSLog.KYC_CBSLogger.debug("configReadStatus "+configReadStatus);
			if(configReadStatus !=0)
			{
				KYC_CBSLog.KYC_CBSLogger.error("Could not Read Config Properties [NBTL CBS]");
				return;
			}

			cabinetName = CommonConnection.getCabinetName();
			KYC_CBSLog.KYC_CBSLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			KYC_CBSLog.KYC_CBSLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			KYC_CBSLog.KYC_CBSLogger.debug("JTSPORT: " + jtsPort);
			
			smsPort = CommonConnection.getsSMSPort();
			KYC_CBSLog.KYC_CBSLogger.debug("SMSPort: " + smsPort);
			

			queueID = KYC_CBSConfigParamMap.get("queueID");
			KYC_CBSLog.KYC_CBSLogger.debug("QueueID: " + queueID);

			integrationWaitTime=Integer.parseInt(KYC_CBSConfigParamMap.get("INTEGRATION_WAIT_TIME"));
			KYC_CBSLog.KYC_CBSLogger.debug("IntegrationWaitTime: "+integrationWaitTime);

			sleepIntervalInMin=Integer.parseInt(KYC_CBSConfigParamMap.get("SleepIntervalInMin"));
			KYC_CBSLog.KYC_CBSLogger.debug("SleepIntervalInMin: "+sleepIntervalInMin);
			
			sessionID = CommonConnection.getSessionID(KYC_CBSLog.KYC_CBSLogger, false);
			if(sessionID.trim().equalsIgnoreCase(""))
			{
				KYC_CBSLog.KYC_CBSLogger.debug("Could Not Connect to Server!");
			}
			else
			{
				HashMap<String, String> socketDetailsMap= socketConnectionDetails(cabinetName, jtsIP, jtsPort,
						sessionID);
				while (true)
				{
					sessionID = CommonConnection.getSessionID(KYC_CBSLog.KYC_CBSLogger, false);
					KYC_CBSLog.setLogger();
					KYC_CBSLog.KYC_CBSLogger.debug("KYC CBS....");
					startKYC_CBSUtility(cabinetName,jtsIP,jtsPort,smsPort,queueID,sleepIntervalInMin,integrationWaitTime,sessionID,socketDetailsMap);
					Thread.sleep(sleepIntervalInMin*60*1000);
				}
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			KYC_CBSLog.KYC_CBSLogger.error("Exception Occurred in KYC CBS : "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			KYC_CBSLog.KYC_CBSLogger.error("Exception Occurred in KYC CBS : "+result);
		}
	}
	
	
	private int readConfig()
	{
		Properties p = null;
		try {

			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir")+ File.separator + "ConfigFiles"+ File.separator+ "KYC_CBS_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements())
			{
			    String name = (String) names.nextElement();
			    KYC_CBSConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{

			return -1 ;
		}
		return 0;
	}
	
	
	
	private void startKYC_CBSUtility(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID,HashMap<String, String> socketDetailsMap)
	{
		try
		{
			sessionID  = CommonConnection.getSessionID(KYC_CBSLog.KYC_CBSLogger, false);

			if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
			{
				KYC_CBSLog.KYC_CBSLogger.error("Could Not Get Session ID "+sessionID);
				return;
			}

			KYC_CBSLog.KYC_CBSLogger.debug("Fetching all Workitems at system Integration queue");
			System.out.println("Fetching all WIs at system Integration");

			String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, queueId);
			KYC_CBSLog.KYC_CBSLogger.debug("Input XML for fetch WIs "+fetchWorkitemListInputXML);

			String fetchWorkitemListOutputXML=WFNGExecute(fetchWorkitemListInputXML, jtsIP, jtsPort, 1);
			KYC_CBSLog.KYC_CBSLogger.debug("Fetch WIs output XML is "+fetchWorkitemListOutputXML);

			XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

			String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
			KYC_CBSLog.KYC_CBSLogger.debug("Fetch WIs list main code is "+fetchWorkItemListMainCode);

			int fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));

			KYC_CBSLog.KYC_CBSLogger.debug("No of records retreived in fetchWI "+fetchWorkitemListCount);

			if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
			{
				for(int i=0; i<fetchWorkitemListCount; i++)
				{
					String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
					fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

					KYC_CBSLog.KYC_CBSLogger.debug("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
					XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);


					String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
					KYC_CBSLog.KYC_CBSLogger.debug("Current ProcessInstanceID: "+processInstanceID);

					KYC_CBSLog.KYC_CBSLogger.debug("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);

					String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
					KYC_CBSLog.KYC_CBSLogger.debug("Current WorkItemID: "+WorkItemID);
					
					activityName=xmlParserfetchWorkItemData.getValueOf("ActivityName");
					KYC_CBSLog.KYC_CBSLogger.debug("Current ActivityName: "+activityName);

					entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
					KYC_CBSLog.KYC_CBSLogger.debug("Current EntryDateTime: "+entryDateTime);
					
					String QueryString="SELECT WINAME,CIF_ID,FirstName,LastName,Nationality,CIFPersona,CusType,ProductCurrency,NextReviewDate"
							+ " FROM "+KYC_EXTTABLE+" with (nolock) where WINAME='"+processInstanceID+"'";

					String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
					KYC_CBSLog.KYC_CBSLogger.debug("Input XML for Apselect from External Table "+sInputXML);

					String sOutputXML=KYC_CBS.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
					KYC_CBSLog.KYC_CBSLogger.debug("Output XML for external Table select "+sOutputXML);

					XMLParser sXMLParser= new XMLParser(sOutputXML);
				    String sMainCode = sXMLParser.getValueOf("MainCode");
				    KYC_CBSLog.KYC_CBSLogger.debug("SMainCode: "+sMainCode);

				    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
				    KYC_CBSLog.KYC_CBSLogger.debug("STotalRecords: "+sTotalRecords);

					if (sMainCode.equals("0") && sTotalRecords > 0)
					{
						KYC_CBSLog.KYC_CBSLogger.debug("Inside If block");
						CustomerBean objCustBean=new CustomerBean();
						
						String strWi_name=sXMLParser.getValueOf("WINAME");
						objCustBean.setWiName(strWi_name);
						KYC_CBSLog.KYC_CBSLogger.debug("strWi_name "+strWi_name);
						
						
						String CIF_ID=sXMLParser.getValueOf("CIF_ID");
						objCustBean.setCorporateCIF(CIF_ID);
						KYC_CBSLog.KYC_CBSLogger.debug("CIF_ID "+CIF_ID);
						
						
						String FirstName=sXMLParser.getValueOf("FirstName");
						objCustBean.setToBeTLNo(FirstName);
						KYC_CBSLog.KYC_CBSLogger.debug("FirstName "+FirstName);
						
						String LastName=sXMLParser.getValueOf("LastName");
						objCustBean.setCorporateCIF(LastName);
						KYC_CBSLog.KYC_CBSLogger.debug("LastName "+LastName);
						
						String Nationality=sXMLParser.getValueOf("Nationality");
						objCustBean.setEmail(Nationality);
						KYC_CBSLog.KYC_CBSLogger.debug("Nationality "+Nationality);
						
						String CIFPersona=sXMLParser.getValueOf("CIFPersona");
						objCustBean.setMemoPadText(CIFPersona);
						KYC_CBSLog.KYC_CBSLogger.debug("CIFPersona "+CIFPersona);
						
						String CusType=sXMLParser.getValueOf("CusType");
						objCustBean.setRequestType(CusType);
						KYC_CBSLog.KYC_CBSLogger.debug("CusType "+CusType);
						
						
						
						/*SimpleDateFormat outputdateFormat = new SimpleDateFormat("yyyy-MM-dd");
						Date d = outputdateFormat.parse(sXMLParser.getValueOf("NextReviewDate"));
						String strNextReviewDate= outputdateFormat.format(d);
						int year = Integer.parseInt(strNextReviewDate.substring(0,4));
						objCustBean.setToBeExpiryDate(strNextReviewDate);
						KYC_CBSLog.KYC_CBSLogger.debug("strNextReviewDate "+strNextReviewDate);
						KYC_CBSLog.KYC_CBSLogger.debug("year "+year);*/
						
						/*KYC_CBSLog.KYC_CBSLogger.debug("objCustBean.getWiName() "+objCustBean.getWiName());
						KYC_CBSLog.KYC_CBSLogger.debug("objCustBean.getCorporate_CIF() "+objCustBean.getCorporateCIF());	
						
						Date date = new Date();
						String KYC_ReviewDate  = outputdateFormat.format(date);*/
						
							ResponseBean objResponseBean=objKYC_CBSIntegration.KYC_CBS_CifUpdateIntegration(cabinetName,  sessionID, jtsIP, jtsPort, smsPort, processInstanceID,sleepIntervalTime,integrationWaitTime,CIF_ID,socketDetailsMap,strWi_name,activityName);
							KYC_CBSLog.KYC_CBSLogger.error("objResponseBean.getCifUpdateReturnCode() "+objResponseBean.getCifUpdateReturnCode());
								if("Success".equals(objResponseBean.getCifUpdateReturnCode()))
								{
									strIntegrationErrCode="Success";
									strIntegrationErrRemarks="Cif Update Successfull";
								}	
								else
								{
									strIntegrationErrCode="Failure";
									//strIntegrationErrRemarks="Error in Cif Update";
									strIntegrationErrRemarks="Error in Cif Update";
								}
								KYC_CBSLog.KYC_CBSLogger.debug("objResponseBean.getIntegrationDecision() "+objResponseBean.getIntegrationDecision());
								KYC_CBSLog.KYC_CBSLogger.debug("strIntegrationErrCode "+strIntegrationErrCode);
								
								attributesTag="<DECISION>"+strIntegrationErrCode+"</DECISION>"
										+ "<REMARKS>"+strIntegrationErrRemarks+"</REMARKS>";
								
								removeDocs(cabinetName, jtsIP, jtsPort, smsPort,sessionID,processInstanceID);
			
								DoneWI(cabinetName, jtsIP, jtsPort, smsPort, queueId, sleepIntervalTime, integrationWaitTime, sessionID,  processInstanceID,
										 WorkItemID,  strIntegrationErrCode,  strIntegrationErrRemarks ,attributesTag);	
			}
		}

	}
}
		catch(Exception e)
		{
			KYC_CBSLog.KYC_CBSLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			KYC_CBSLog.KYC_CBSLogger.error("Exception Occurred in NBTL CBS Thread : "+result);
			System.out.println("Exception "+e);
			
		}
	}
	
	public static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		KYC_CBSLog.KYC_CBSLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientKYC_CBS.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			KYC_CBSLog.KYC_CBSLogger.error("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}

	public static String removeDocs(String cabinetName, String jtsIP, String jtsPort, String smsPort,String sessionID, String processInstanceID)
	{
		try{
		String query = "select FolderIndex from PDBFolder where name = '"+processInstanceID+"'";
		
		String apSelectInputXMLFolderIndex =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
		KYC_CBSLog.KYC_CBSLogger.debug("apSelectInputXMLFolderIndex: "+apSelectInputXMLFolderIndex);

		String apSelectOutputXML=WFNGExecute(apSelectInputXMLFolderIndex,jtsIP,jtsPort,1);
		KYC_CBSLog.KYC_CBSLogger.debug("APSelect OutputXML: "+apSelectOutputXML);

		XMLParser xmlParserFolderIndex= new XMLParser(apSelectOutputXML);
		String MainCodeFolderIndex = xmlParserFolderIndex.getValueOf("MainCode");
		KYC_CBSLog.KYC_CBSLogger.debug("MainCode: "+MainCodeFolderIndex);

		int TotalRecordsRetrieved = Integer.parseInt(xmlParserFolderIndex.getValueOf("TotalRetrieved"));
		KYC_CBSLog.KYC_CBSLogger.debug("TotalRecords: "+TotalRecordsRetrieved);

		String FolderIndex = "";
		if(MainCodeFolderIndex.equalsIgnoreCase("0")&& TotalRecordsRetrieved>0)
		{
			String xmlData=xmlParserFolderIndex.getNextValueOf("Record");
			xmlData =xmlData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

			XMLParser xmlParserRecord = new XMLParser(xmlData);

			FolderIndex=xmlParserRecord.getValueOf("FolderIndex");
			KYC_CBSLog.KYC_CBSLogger.debug("FolderIndex: "+FolderIndex);
		
		}
		
		
		String query1 = "Select PDBDocument.DocumentIndex "
				+"from PDBDocument "
				+"INNER JOIN PDBDocumentContent ON PDBDocument.DocumentIndex = PDBDocumentContent.DocumentIndex "
				+"INNER JOIN PDBFolder ON PDBDocumentContent.ParentFolderIndex = PDBFolder.FolderIndex "
				+"WHERE PDBDocument.Name = 'Previous_Doc' and PDBFolder.Name = '"+processInstanceID+"'";
		
		String apSelectInputXML =CommonMethods.apSelectWithColumnNames(query1, cabinetName, sessionID);
		KYC_CBSLog.KYC_CBSLogger.debug("APSelect InputXML: "+apSelectInputXML);

		String OutputXML=WFNGExecute(apSelectInputXML,jtsIP,jtsPort,1);
		KYC_CBSLog.KYC_CBSLogger.debug("APSelect OutputXML: "+OutputXML);

		XMLParser xmlParser= new XMLParser(OutputXML);
		String MainCode = xmlParser.getValueOf("MainCode");
		KYC_CBSLog.KYC_CBSLogger.debug("MainCode: "+MainCode);

		int TotalRecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
		KYC_CBSLog.KYC_CBSLogger.debug("TotalRecords: "+TotalRecords);

		
		if(MainCode.equalsIgnoreCase("0")&& TotalRecords>0)
		{
			for(int i=0;i<TotalRecords;i++)
			{
			String xmlData=xmlParser.getNextValueOf("Record");
			xmlData =xmlData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

			XMLParser xmlParserRecord = new XMLParser(xmlData);

			String DocumentIndex=xmlParserRecord.getValueOf("DocumentIndex");
			KYC_CBSLog.KYC_CBSLogger.debug("FolderIndex: "+DocumentIndex);
			System.out.println("FolderIndex: "+DocumentIndex);

			KYC_CBSLog.KYC_CBSLogger.debug("ParentFolderIndex found.");
			System.out.println("ParentFolderIndex found.");
			
			String DocumentsTag = "<Documents>";
			
			DocumentsTag = DocumentsTag+
					"\n\t\t<Document>"
					+"\n\t\t\t<DocumentIndex>"+DocumentIndex+"</DocumentIndex>"
					+"\n\t\t\t<ParentFolderIndex>"+FolderIndex+"</ParentFolderIndex>"
					+"\n\t\t\t<ReferenceFlag>Y</ReferenceFlag>"
					+"\n\t\t</Document>";
			DocumentsTag = DocumentsTag
					+"\n</Documents>\n";
			
			StringBuffer ipXMLBuffer=new StringBuffer();

			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<NGODeleteDocumentExt_Input>\n");
			ipXMLBuffer.append("<Option>NGODeleteDocumentExt</Option>\n");
			ipXMLBuffer.append("<CabinetName>");
			ipXMLBuffer.append(cabinetName);
			ipXMLBuffer.append("</CabinetName>\n");
			ipXMLBuffer.append("<UserDBId>");
			ipXMLBuffer.append(sessionID);
			ipXMLBuffer.append("</UserDBId>\n");
			ipXMLBuffer.append(DocumentsTag);
			ipXMLBuffer.append("</NGODeleteDocument_Input>");
			
			String NGODeleteDocumentInput = ipXMLBuffer.toString();
			KYC_CBSLog.KYC_CBSLogger.debug("NGODeleteDocumentInput----"+NGODeleteDocumentInput);
			
			String NGODeleteDocumentInputOutput=WFNGExecute(NGODeleteDocumentInput,jtsIP,jtsPort,1);
			KYC_CBSLog.KYC_CBSLogger.debug("NGODeleteDocumentInputOutput OutputXML: "+NGODeleteDocumentInputOutput);
			}
		}
		
		}catch (Exception e)
		{
			KYC_CBSLog.KYC_CBSLogger.error("Exception Occured in removeDocs() ---"+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
		return "";
	}
	
	public static HashMap<String,String> socketConnectionDetails(String cabinetName, String sJtsIp, String iJtsPort,
			String sessionID )
	{
		HashMap<String, String> socketDetailsMap = new HashMap<String, String>();

		try
		{
			ngEjbClientKYC_CBS = NGEjbClient.getSharedInstance();
			KYC_CBSLog.KYC_CBSLogger.debug("Fetching Socket Connection Details.");
			System.out.println("Fetching Socket Connection Details.");

			String socketDetailsQuery = "SELECT SocketServerIP,SocketServerPort FROM NG_BPM_MQ_TABLE with (nolock) where ProcessName = 'KYC_Remediation' and CallingSource = 'Utility'";

			String socketDetailsInputXML =CommonMethods.apSelectWithColumnNames(socketDetailsQuery, cabinetName, sessionID);
			KYC_CBSLog.KYC_CBSLogger.debug("Socket Details APSelect InputXML: "+socketDetailsInputXML);

			String socketDetailsOutputXML=WFNGExecute(socketDetailsInputXML,sJtsIp,iJtsPort,1);
			KYC_CBSLog.KYC_CBSLogger.debug("Socket Details APSelect OutputXML: "+socketDetailsOutputXML);

			XMLParser xmlParserSocketDetails= new XMLParser(socketDetailsOutputXML);
			String socketDetailsMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			KYC_CBSLog.KYC_CBSLogger.debug("SocketDetailsMainCode: "+socketDetailsMainCode);

			int socketDetailsTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			KYC_CBSLog.KYC_CBSLogger.debug("SocketDetailsTotalRecords: "+socketDetailsTotalRecords);

			if(socketDetailsMainCode.equalsIgnoreCase("0")&& socketDetailsTotalRecords>0)
			{
				String xmlDataSocketDetails=xmlParserSocketDetails.getNextValueOf("Record");
				xmlDataSocketDetails =xmlDataSocketDetails.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

				XMLParser xmlParserSocketDetailsRecord = new XMLParser(xmlDataSocketDetails);

				String socketServerIP=xmlParserSocketDetailsRecord.getValueOf("SocketServerIP");
				KYC_CBSLog.KYC_CBSLogger.debug("SocketServerIP: "+socketServerIP);
				socketDetailsMap.put("SocketServerIP", socketServerIP);

				String socketServerPort=xmlParserSocketDetailsRecord.getValueOf("SocketServerPort");
				KYC_CBSLog.KYC_CBSLogger.debug("SocketServerPort " + socketServerPort);
				socketDetailsMap.put("SocketServerPort", socketServerPort);

				KYC_CBSLog.KYC_CBSLogger.debug("SocketServer Details found.");
				System.out.println("SocketServer Details found.");

			}
		}
		catch (Exception e)
		{
			KYC_CBSLog.KYC_CBSLogger.error("Exception in getting Socket Connection Details: "+e.getMessage());
			System.out.println("Exception in getting Socket Connection Details: "+e.getMessage());
		}

		return socketDetailsMap;
	}
	
	private void DoneWI(String cabinetName,String jtsIP,String jtsPort, String smsPort, String queueId,int sleepIntervalTime,int integrationWaitTime,String sessionID, String processInstanceID,
			String WorkItemID, String Decision, String Remarks, String attributesTag) throws IOException, Exception{
		getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
		getWorkItemOutputXml = WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);

		KYC_CBSLog.KYC_CBSLogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);

		xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
		getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");

		if("0".equals(getWorkItemMainCode))
		{
			KYC_CBSLog.KYC_CBSLogger.info("get Workitem call successfull for "+processInstanceID);

			String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
					processInstanceID,WorkItemID,attributesTag);
			KYC_CBSLog.KYC_CBSLogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);

			String assignWorkitemAttributeOutputXML=WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,
					jtsPort,1);
			KYC_CBSLog.KYC_CBSLogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);

			XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);

			String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
			if("0".equals(mainCodeAssignAtt.trim()))
			{
				String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
						processInstanceID,WorkItemID);

				KYC_CBSLog.KYC_CBSLogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);

				KYC_CBSLog.KYC_CBSLogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);

				String completeWorkItemOutputXML = WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
				KYC_CBSLog.KYC_CBSLogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);

				XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
				String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
				KYC_CBSLog.KYC_CBSLogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);

				if("0".equals(completeWorkitemMaincode))
				{
					//inserting into history table
					KYC_CBSLog.KYC_CBSLogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
					System.out.println(processInstanceID + "Complete Succesfully with status ");

					KYC_CBSLog.KYC_CBSLogger.debug("WorkItem moved to next Workstep.");

					SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
					SimpleDateFormat outputDateFormat=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");

					Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
					String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
					KYC_CBSLog.KYC_CBSLogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);

					Date d = new Date();
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					String strDate = dateFormat.format(d);
					
					String tableName = "NG_KYC_REM_GR_HISTORY";
					String columnName = "DateTime,Workstep,Decision,UserName,Remarks,WI_Name,Entry_Date_Time";
					String values = "'"+strDate+"','System_Integration','"+Decision+"','rakBPMutility','"+Remarks+"','"+processInstanceID+"','"+formattedEntryDatetime+"'";
					

					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnName, values,tableName);
					KYC_CBSLog.KYC_CBSLogger.debug("APInsertInputXML: "+apInsertInputXML);

					String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,
							jtsPort,1);
					KYC_CBSLog.KYC_CBSLogger.debug("APInsertOutputXML: "+ apInsertOutputXML);

					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					KYC_CBSLog.KYC_CBSLogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						KYC_CBSLog.KYC_CBSLogger.debug("ApInsert successful: "+apInsertMaincode);
						KYC_CBSLog.KYC_CBSLogger.debug("Inserted in WiHistory table successfully.");
					}
					else
					{
						KYC_CBSLog.KYC_CBSLogger.error("ApInsert failed: "+apInsertMaincode);
					}
				}
				else
				{
					KYC_CBSLog.KYC_CBSLogger.error("Error in completeWI call for "+processInstanceID);
				}
			}
			else
			{
				KYC_CBSLog.KYC_CBSLogger.error("Error in Assign Attribute call for WI "+processInstanceID);
			}


		}
		else
		{
			KYC_CBSLog.KYC_CBSLogger.error("Error in getWI call for WI "+processInstanceID);
		}
	}
}
