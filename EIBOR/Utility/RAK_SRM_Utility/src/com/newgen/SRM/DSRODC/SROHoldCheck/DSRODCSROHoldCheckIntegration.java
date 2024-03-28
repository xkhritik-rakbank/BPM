package com.newgen.SRM.DSRODC.SROHoldCheck;

import java.util.HashMap;
import java.util.Map;

import com.newgen.SRM.DSRODC.SROHoldCheck.DSRODCSROHoldCheckLog;
import com.newgen.SRM.DSRODC.SROHoldCheck.DSRODCSROHoldCheckLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.pci.util.EncryptionDecryption;

public class DSRODCSROHoldCheckIntegration {
	public	String customIntegration(String cabinetName,String sessionId,String sJtsIp, String iJtsPort , String processInstanceID,
			String ws_name, int integrationWaitTime, Map <String, String> AOApprovalHoldConfigParamMap)
	{
		String ActivityName = "";
		String LatestSRODecision="";
		String ActOpenDate="NA";
		String RejectReason = "";
		String rejectReasonDesc="";
		try
		{
			
			String DBQuery = "SELECT Cards_SRONo FROM RB_DSR_ODC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";

			String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(DBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC SRO Hold Check data input: "+ extTabDataIPXML);
			String extTabDataOPXML = CommonMethods.WFNGExecute(extTabDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC SRO Hold Check data output: "+ extTabDataOPXML);

			XMLParser xmlParserData= new XMLParser(extTabDataOPXML);		
			
			if(xmlParserData.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserData.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserData.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					String SROWIName = objWorkList.getVal("Cards_SRONo").trim();
										
					
					//String OFDBQuery = "select top 1 activityname from QUEUEVIEW with(nolock) where processname='SRO' and processinstanceid = '"+SROWIName+"' order by entryDATETIME desc";
					String OFDBQuery = "select top 1 decision,actiondatetime,(select Current_WS from RB_SRO_EXTTABLE with(nolock) where WI_NAME='"+SROWIName+"') as CurrentWS,RejectReasons from USR_0_SRO_WIHISTORY with(nolock) where winame = '"+SROWIName+"' order by actiondatetime desc";
					String OFDataIPXML = CommonMethods.apSelectWithColumnNames(OFDBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SRO WI Status input: "+ OFDataIPXML);
					String OFDataOPXML = CommonMethods.WFNGExecute(OFDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("SRO WI Status output: "+ OFDataOPXML);

					XMLParser xmlParserData1= new XMLParser(OFDataOPXML);						
					
					if(xmlParserData1.getValueOf("MainCode").equalsIgnoreCase("0"))
					{
						String xmlDataExtTab1=xmlParserData1.getNextValueOf("Record");
						xmlDataExtTab1 =xmlDataExtTab1.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
						
						NGXmlList objWorkList1=xmlParserData1.createList("Records", "Record");

						for (; objWorkList1.hasMoreElements(true); objWorkList1.skip(true))
						{		
							//ActivityName = objWorkList1.getVal("activityname").trim()+"~"+SROWIName;
							LatestSRODecision=objWorkList1.getVal("decision").trim();
							
							ActivityName=objWorkList1.getVal("CurrentWS").trim();

							if("Approve-Exit".equalsIgnoreCase(LatestSRODecision.trim())) //Release the Wi from AO hold once WI approved from the ops dataentrychecker<RE: Items to be prioritized in IBPS-Rachit>
							{	
								ActivityName = "Exit";
								ActOpenDate = objWorkList1.getVal("actiondatetime").trim();
							}
							else if("Reject".equalsIgnoreCase(LatestSRODecision.trim())) //Release the Wi from AO hold once WI approved from the ops dataentrychecker<RE: Items to be prioritized in IBPS-Rachit>
							{	
								ActivityName = "Reject";
								ActOpenDate = objWorkList1.getVal("actiondatetime").trim();
								RejectReason = objWorkList1.getVal("RejectReasons").trim();
								
								//Code to get reject reason desc starts here.
								//String rejectReasonDesc="";
								String query = "select Item_Desc from USR_0_SRO_ERROR_DESC_MASTER where Item_Code = '"+RejectReason+"' and workstename = 'Initiator_Reject'";
								String inputXml = CommonMethods.apSelectWithColumnNames(query,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC Item_Desc data input: "+ inputXml);
								String outputXML = CommonMethods.WFNGExecute(inputXml,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC Item_Desc output: "+ outputXML);

								XMLParser xmlParserData2= new XMLParser(outputXML);		
								
								if(xmlParserData2.getValueOf("MainCode").equalsIgnoreCase("0"))
								{

									String xmlDataExtTab2=xmlParserData2.getNextValueOf("Record");
									xmlDataExtTab2 =xmlDataExtTab2.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
									
									//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
									NGXmlList objWorkList2=xmlParserData2.createList("Records", "Record");
																
									for (; objWorkList2.hasMoreElements(true); objWorkList2.skip(true))
									{		
										rejectReasonDesc = objWorkList2.getVal("Item_Desc").trim();
									}
								}
								DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("rejectReasonDesc----------->" + rejectReasonDesc);
								//end.
							}
							ActivityName = ActOpenDate+"~"+ActivityName+"~"+rejectReasonDesc+"~"+SROWIName;

							break;
						}
					}
					else 
					{
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Error In SRO WI Status");
					}
				}
			}
			else 
			{
				DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Error In main SRO WI Status");
			}

		}
		catch(Exception e)
		{
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("exception In main SRO WI Status"+e.getMessage());
		}
		return ActivityName;
	}
	
	public static String mailTrigger(String stage,String processInstanceID,String rejectReason)
	{
		try{
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Inside mailTrigger method-----------> ");
			//String[] param = data.split("-");
			//declare all variable
			String date = CommonMethods.getDate();
			String tag = "";
			String WI_No = processInstanceID;
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WI_No----------->" + WI_No);
			String split_WI_No = CommonMethods.splitString(WI_No);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("split_WI_No----------->" + split_WI_No);
			//String Card_No = "5239267453816008";//(String)iform.getValue("CCI_CrdtCN");
			//Code to get CARD NO from exttable starts here.
			String Card_No ="";String mailTo = "";String oth_td_Amount = "";
			String sCabName = CommonConnection.getCabinetName();
			String DBQueryCard = "SELECT DCI_DebitCN,userEmailID,oth_td_Amount FROM RB_DSR_ODC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataCardIPXML = CommonMethods.apSelectWithColumnNames(DBQueryCard,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC request_type data input: "+ extTabDataCardIPXML);
			String extTabDataCardOPXML = CommonMethods.WFNGExecute(extTabDataCardIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC card no and mob no output: "+ extTabDataCardOPXML);

			XMLParser xmlParserCardData= new XMLParser(extTabDataCardOPXML);		
			
			if(xmlParserCardData.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserCardData.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserCardData.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					Card_No = objWorkList.getVal("DCI_DebitCN").trim();
					mailTo = objWorkList.getVal("userEmailID").trim();
					oth_td_Amount = objWorkList.getVal("oth_td_Amount").trim();
				}
			}
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Card_No original----------->" + Card_No);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("mailTo----------->" + mailTo);
			//EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();
			//Card_No = ed.decryptFormField(Card_No, sCabName);	
			
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Card_No----------->" + Card_No);
			//end.
			
			String lastDigitCard_No = Card_No.substring(12,16);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("lastDigitCard_No----------->" + lastDigitCard_No);
			
			tag = "<p class=MsoListParagraphCxSpFirst align=left style=\"margin-bottom:0in;padding-left:31%; text-align:left;text-indent:-.25in;line-height:normal\"><span style=\"font-size:10.0pt;font-family:Symbol\">*<span style=\"font:7.0pt \"Times New Roman\"\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span><span style=\"font-size:10.0pt;font-family:\"Verdana\",sans-serif\">"+rejectReason+"</span></p>"+"\n";
			
			//Code to get Request Type from exttable starts here.
			String subProcessName="";
			String DBQuery = "SELECT request_type FROM RB_DSR_ODC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(DBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC request_type data input: "+ extTabDataIPXML);
			String extTabDataOPXML = CommonMethods.WFNGExecute(extTabDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC request_type output: "+ extTabDataOPXML);

			XMLParser xmlParserData= new XMLParser(extTabDataOPXML);		
			
			if(xmlParserData.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserData.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserData.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					subProcessName = objWorkList.getVal("request_type").trim();
				}
			}
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("subProcessName----------->" + subProcessName);
			//end.
			
			
			//Code to get Request Type from exttable starts here.
			String emailBody = "";String mailFrom ="";String mailSubject ="";
			String TemplateQuery = "Select MailTemplate,FromMail,MailSubject From USR_0_CSR_BT_TemplateMapping where ProcessName = 'DSR_ODC' and TemplateType = '"+stage+"' AND SubProcess = '"+subProcessName+"'";
			String templateDataIPXML = CommonMethods.apSelectWithColumnNames(TemplateQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC template data input: "+ templateDataIPXML);
			String templateDataOPXML = CommonMethods.WFNGExecute(templateDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC template output: "+ templateDataOPXML);

			XMLParser xmlParserTemplate= new XMLParser(templateDataOPXML);		
			
			if(xmlParserTemplate.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataTemplate=xmlParserTemplate.getNextValueOf("Record");
				xmlDataTemplate =xmlDataTemplate.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				NGXmlList objWorkListTemplate=xmlParserTemplate.createList("Records", "Record");
											
				for (; objWorkListTemplate.hasMoreElements(true); objWorkListTemplate.skip(true))
				{		
					emailBody = objWorkListTemplate.getVal("MailTemplate").trim();
					mailFrom = objWorkListTemplate.getVal("FromMail").trim();
					mailSubject = objWorkListTemplate.getVal("MailSubject").trim();
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("emailBody----------->" + emailBody);
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("mailFrom----->" + mailFrom);
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mail Subject------>"+mailSubject);
					if (!emailBody.equalsIgnoreCase("NULL"))
					{
						emailBody = emailBody.replaceAll("#WI_No#", split_WI_No);
						emailBody = emailBody.replaceAll("#Card_No#", lastDigitCard_No);
						emailBody = emailBody.replaceAll("'Times", "''Times");
						emailBody = emailBody.replaceAll("Roman'", "Roman''");
						emailBody = emailBody.replaceAll("#reject reason#", tag);
						emailBody = emailBody.replaceAll("#Amount#", oth_td_Amount);
						emailBody = emailBody.replaceAll("#Sub_Process_Name#", subProcessName);
						emailBody = emailBody.replaceAll("#DD/MM/YYYY#", date);
						emailBody = emailBody.replaceAll("#SLA_TAT#", "3");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("emailBody after replace" + emailBody);
						
						//String mailTo = "test11@rakbanktst.ae";//CustMail; 
						
						String mailContentType = "text/html;charset=UTF-8";
						int mailPriority = 1;
						int workitemId = 1;
						int noOfTrials = 1;
						int activityId = 3;
						String mailStatus = "N";
						String mailActionType = "TRIGGER";
						String tableName = "WFMAILQUEUETABLE";
						String userName = "srmutility";
						String columnName = "mailFrom,mailTo,mailSubject,mailMessage, mailContentType, mailPriority,mailStatus,insertedBy,insertedTime,"
								+ "mailActionType,processInstanceId,workitemId,activityId,noOfTrials";
						String values = "'" + mailFrom + "','" + mailTo + "','" + mailSubject + "',N'" + emailBody + "','" + mailContentType
								+ "','" + mailPriority + "','" + mailStatus + "','" + userName + "',getdate(),'" + mailActionType + "','"
								+ processInstanceID + "','" + workitemId + "','" + activityId + "','" 
								+ noOfTrials + "'";
						
						//String mailInsertQuery = "Insert into "+tableName+" "+columnName+" values "+values ;
						String insertIPXml = CommonMethods.apInsert(CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false), columnName, values, tableName);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Query to be inserted in table-----------------: " + insertIPXml);
						String insertOPXml = CommonMethods.WFNGExecute(insertIPXml,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC mail insert output: "+ insertOPXml);
						//DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mail Triggred successfuly if value of status is 1---------STATUS = " + status);
						return "success";
					}
				}
			}
			//end.
		}catch (Exception ex) {
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Some error in mailTrigger " + ex.toString());
			return "false";
		}
		return "false";
	}
	
	public static String sendSMS(String stage, String processInstanceID) {
		try{
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("inside sendSMScall txtMessagessss");
			
			String date = CommonMethods.getDate();
			String tag = "";
			String WI_No = processInstanceID;
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("WI_No----------->" + WI_No);
			String split_WI_No = CommonMethods.splitString(WI_No);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("split_WI_No----------->" + split_WI_No);
			//String Card_No = "5239267453816008";//(String)iform.getValue("CCI_CrdtCN");
			//Code to get CARD NO from exttable starts here.
			String Card_No ="";String Mobile_No ="";String Pending_Reason = "";
			String sCabName = CommonConnection.getCabinetName();
			String DBQueryCard = "SELECT DCI_DebitCN,DCI_MONO,Pending_Reason FROM RB_DSR_ODC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataCardIPXML = CommonMethods.apSelectWithColumnNames(DBQueryCard,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC request_type data input: "+ extTabDataCardIPXML);
			String extTabDataCardOPXML = CommonMethods.WFNGExecute(extTabDataCardIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("CSR_OCC card no and mob no output: "+ extTabDataCardOPXML);

			XMLParser xmlParserCardData= new XMLParser(extTabDataCardOPXML);		
			
			if(xmlParserCardData.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserCardData.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserCardData.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					Card_No = objWorkList.getVal("DCI_DebitCN").trim();
					Mobile_No = objWorkList.getVal("DCI_MONO").trim();
					Pending_Reason = objWorkList.getVal("Pending_Reason").trim();
				}
			}
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Card_No original----------->" + Card_No);
			//EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();
			//Card_No = ed.decryptFormField(Card_No, sCabName);	
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Card_No----------->" + Card_No);
			
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mobile_No original----------->" + Mobile_No);
			//Mobile_No = ed.decryptFormField(Mobile_No, sCabName);	
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mobile_No----------->" + Mobile_No);
			//end.
			
			String lastDigitCard_No = Card_No.substring(12,16);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("lastDigitCard_No----------->" + lastDigitCard_No);
			
			//Code to get Request Type from exttable starts here.
			String subProcessName="";
			String DBQuery = "SELECT request_type FROM RB_DSR_ODC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(DBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC request_type data input: "+ extTabDataIPXML);
			String extTabDataOPXML = CommonMethods.WFNGExecute(extTabDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC request_type output: "+ extTabDataOPXML);

			XMLParser xmlParserData= new XMLParser(extTabDataOPXML);		
			
			if(xmlParserData.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserData.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserData.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					subProcessName = objWorkList.getVal("request_type").trim();
				}
			}
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("subProcessName----------->" + subProcessName);
			//end.
			String smsLang = "EN";
			
			//Code to get Request Type from exttable starts here.
			String txtMessage = "";
			String TemplateQuery = "Select SMStxtTemplate From USR_0_CSR_BT_TemplateMapping where ProcessName = 'DSR_ODC' and TemplateType = '"+stage+"' AND SubProcess = '"+subProcessName+"'";
			String templateDataIPXML = CommonMethods.apSelectWithColumnNames(TemplateQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false));
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC template data input: "+ templateDataIPXML);
			String templateDataOPXML = CommonMethods.WFNGExecute(templateDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC template output: "+ templateDataOPXML);

			XMLParser xmlParserTemplate= new XMLParser(templateDataOPXML);		
			
			if(xmlParserTemplate.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataTemplate=xmlParserTemplate.getNextValueOf("Record");
				xmlDataTemplate =xmlDataTemplate.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				NGXmlList objWorkListTemplate=xmlParserTemplate.createList("Records", "Record");
											
				for (; objWorkListTemplate.hasMoreElements(true); objWorkListTemplate.skip(true))
				{		
					txtMessage = objWorkListTemplate.getVal("SMStxtTemplate").trim();
					DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("txtMessage----------->" + txtMessage);
					
					if (!txtMessage.equalsIgnoreCase("NULL"))
					{
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("txtMessage before replace" + txtMessage);
						txtMessage = txtMessage.replaceAll("#WI_No#", split_WI_No);
						txtMessage = txtMessage.replaceAll("#Card_No#", lastDigitCard_No);
						txtMessage = txtMessage.replaceAll("#CancellationReason#", Pending_Reason);
						txtMessage = txtMessage.replaceAll("#DD/MM/YYYY#", date);
						txtMessage = txtMessage.replaceAll("#Sub_Process_Name#", subProcessName);
						txtMessage = txtMessage.replaceAll("#SLA_TAT#", "3");
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("txtMessage after replace" + txtMessage);
						String tableName = "NG_RLOS_SMSQUEUETABLE";
						String ALERT_Name = stage;
						String Alert_Code = "DSR_ODC";
						String Alert_Status = "P";
						//String Mobile_No = "00971500115769";//(String)iform.getValue("CCI_MONO");
						
						String Workstep_Name = "SRO_Hold";
						String columnName = "ALERT_Name, Alert_Code, Alert_Status, Mobile_No, Alert_Text, WI_Name, Workstep_Name, Inserted_Date_time";
						String values = "'" + ALERT_Name + "','" + Alert_Code + "','" + Alert_Status + "','" + Mobile_No + "','" + txtMessage
								+ "','" + WI_No + "','" + Workstep_Name + "', getdate()";
						String insertIPXml = CommonMethods.apInsert(CommonConnection.getCabinetName(), CommonConnection.getSessionID(DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger, false), columnName, values, tableName);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Query to be inserted in table-----------------: " + insertIPXml);
						String insertOPXml = CommonMethods.WFNGExecute(insertIPXml,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
						DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("DSR_ODC sms insert output: "+ insertOPXml);
						//DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Mail Triggred successfuly if value of status is 1---------STATUS = " + status);
						return "success";
					}
				}
			}
		}catch(Exception ex) {
			DSRODCSROHoldCheckLog.DSRODCSROHoldCheckLogger.debug("Some error in sendSMScall" + ex.toString());
		}
		return "false";
	}

}
