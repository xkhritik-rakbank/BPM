package com.newgen.SRM.CSROCC.SROHoldCheck;

import java.util.HashMap;
import java.util.Map;

import com.newgen.SRM.CSRMR.SROHoldCheck.CSRMRSROHoldCheckLog;
import com.newgen.SRM.CSROCC.SROHoldCheck.CSROCCSROHoldCheckLog;
import com.newgen.SRM.CSROCC.SROHoldCheck.CSROCCSROHoldCheckLog;
import com.newgen.SRM.CSROCC.SROHoldCheck.CSROCCSROHoldCheckLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.NGXmlList;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.pci.util.EncryptionDecryption;

public class CSROCCSROHoldCheckIntegration {
	
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
			
			String DBQuery = "SELECT Cards_SRONo FROM RB_CSR_OCC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";

			String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(DBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC SRO Hold Check data input: "+ extTabDataIPXML);
			String extTabDataOPXML = CommonMethods.WFNGExecute(extTabDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC SRO Hold Check data output: "+ extTabDataOPXML);

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
					String OFDataIPXML = CommonMethods.apSelectWithColumnNames(OFDBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SRO WI Status input: "+ OFDataIPXML);
					String OFDataOPXML = CommonMethods.WFNGExecute(OFDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("SRO WI Status output: "+ OFDataOPXML);

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
								String inputXml = CommonMethods.apSelectWithColumnNames(query,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC Item_Desc data input: "+ inputXml);
								String outputXML = CommonMethods.WFNGExecute(inputXml,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC Item_Desc output: "+ outputXML);

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
								CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("rejectReasonDesc----------->" + rejectReasonDesc);
								//end.
								
							}
							ActivityName = ActOpenDate+"~"+ActivityName+"~"+rejectReasonDesc+"~"+SROWIName;

							break;
						}
					}
					else 
					{
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Error In SRO WI Status");
					}
				}
			}
			else 
			{
				CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Error In main SRO WI Status");
			}

		}
		catch(Exception e)
		{
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("exception In main SRO WI Status"+e.getMessage());
		}
		return ActivityName;
	}
	
	public static String mailTrigger(String stage,String processInstanceID,String rejectReason)
	{
		try{
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Inside mailTrigger method-----------> ");
			//String[] param = data.split("-");
			//declare all variable
			String date = CommonMethods.getDate();
			String tag = "";
			String WI_No = processInstanceID;
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WI_No----------->" + WI_No);
			String split_WI_No = CommonMethods.splitString(WI_No);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("split_WI_No----------->" + split_WI_No);
			//String Card_No = "5239267453816008";//(String)iform.getValue("CCI_CrdtCN");
			//CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Card_No----------->" + Card_No);
			//Code to get Card No from exttable starts here.
			String Card_No="";String mailTo = ""; String oth_ssc_Amount = "";
			String sCabName = CommonConnection.getCabinetName();
			String DBQueryCardNo = "SELECT CCI_CrdtCN,userEmailID ,oth_ssc_Amount FROM RB_CSR_OCC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataCardNoIPXML = CommonMethods.apSelectWithColumnNames(DBQueryCardNo,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC CCI_CrdtCN data input: "+ extTabDataCardNoIPXML);
			String extTabDataCardNoOPXML = CommonMethods.WFNGExecute(extTabDataCardNoIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC CCI_CrdtCN output: "+ extTabDataCardNoOPXML);

			XMLParser xmlParserDataCardNo= new XMLParser(extTabDataCardNoOPXML);		
			
			if(xmlParserDataCardNo.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserDataCardNo.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserDataCardNo.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					Card_No = objWorkList.getVal("CCI_CrdtCN").trim();
					mailTo = objWorkList.getVal("userEmailID").trim();
					oth_ssc_Amount = objWorkList.getVal("oth_ssc_Amount").trim();
				}
			}
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Card_No original----------->" + Card_No);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("mailTo----------->" + mailTo);
			EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();
			Card_No = ed.decryptFormField(Card_No, sCabName);	
			
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Card_No----------->" + Card_No);
			//end.
			
			String lastDigitCard_No = Card_No.substring(12,16);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("lastDigitCard_No----------->" + lastDigitCard_No);
			
			//Code to get Request Type from exttable starts here.
			String subProcessName="";
			String DBQuery = "SELECT request_type FROM RB_CSR_OCC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(DBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC request_type data input: "+ extTabDataIPXML);
			String extTabDataOPXML = CommonMethods.WFNGExecute(extTabDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC request_type output: "+ extTabDataOPXML);

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
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("subProcessName----------->" + subProcessName);
			//end.
			
			tag = "<p class=MsoListParagraphCxSpFirst align=left style=\"margin-bottom:0in;padding-left:31%; text-align:left;text-indent:-.25in;line-height:normal\"><span style=\"font-size:10.0pt;font-family:Symbol\">*<span style=\"font:7.0pt \"Times New Roman\"\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span></span><span style=\"font-size:10.0pt;font-family:\"Verdana\",sans-serif\">"+rejectReason+"</span></p>"+"\n";
			
			//Code to get Request Type from exttable starts here.
			String emailBody = "";String mailFrom ="";String mailSubject ="";
			String TemplateQuery = "Select MailTemplate,FromMail,MailSubject From USR_0_CSR_BT_TemplateMapping where ProcessName = 'CSR_OCC' and TemplateType = '"+stage+"' AND SubProcess = '"+subProcessName+"'";
			String templateDataIPXML = CommonMethods.apSelectWithColumnNames(TemplateQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_MR template data input: "+ templateDataIPXML);
			String templateDataOPXML = CommonMethods.WFNGExecute(templateDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_MR template output: "+ templateDataOPXML);

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
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("emailBody----------->" + emailBody);
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("mailFrom----->" + mailFrom);
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mail Subject------>"+mailSubject);
					if (!emailBody.equalsIgnoreCase("NULL"))
					{
						emailBody = emailBody.replaceAll("#WI_No#", split_WI_No);
						emailBody = emailBody.replaceAll("#Card_No#", lastDigitCard_No);
						emailBody = emailBody.replaceAll("'Times", "''Times");
						emailBody = emailBody.replaceAll("Roman'", "Roman''");
						emailBody = emailBody.replaceAll("#reject reason#", tag);
						emailBody = emailBody.replaceAll("#Sub_Process_Name#", subProcessName);
						emailBody = emailBody.replaceAll("#DD/MM/YYYY#", date);
						emailBody = emailBody.replaceAll("#SLA_TAT#", "3");
						emailBody = emailBody.replaceAll("#Amount#", oth_ssc_Amount);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("emailBody after replace" + emailBody);
						
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
						String insertIPXml = CommonMethods.apInsert(CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false), columnName, values, tableName);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Query to be inserted in table-----------------: " + insertIPXml);
						String insertOPXml = CommonMethods.WFNGExecute(insertIPXml,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC mail insert output: "+ insertOPXml);
						//CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mail Triggred successfuly if value of status is 1---------STATUS = " + status);
						return "success";
					}
				}
			}
			//end.
		}catch (Exception ex) {
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Some error in mailTrigger " + ex.toString());
			return "false";
		}
		return "false";
	}
	
	public static String sendSMS(String stage, String processInstanceID) {
		try{
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("inside sendSMScall txtMessagessss");
			
			String date = CommonMethods.getDate();
			String tag = "";
			String WI_No = processInstanceID;
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("WI_No----------->" + WI_No);
			String split_WI_No = CommonMethods.splitString(WI_No);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("split_WI_No----------->" + split_WI_No);
			//String Card_No = "5239267453816008";//(String)iform.getValue("CCI_CrdtCN");
			//CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Card_No----------->" + Card_No);
			//Code to get Card No from exttable starts here.
			String Card_No="";String Mobile_No =""; String oth_ssc_Amount = ""; String Pending_Reason = "";
			String sCabName = CommonConnection.getCabinetName();
			String DBQueryCardNo = "SELECT CCI_CrdtCN,CCI_MONO,oth_ssc_Amount,Pending_Reason FROM RB_CSR_OCC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataCardNoIPXML = CommonMethods.apSelectWithColumnNames(DBQueryCardNo,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC CCI_CrdtCN data input: "+ extTabDataCardNoIPXML);
			String extTabDataCardNoOPXML = CommonMethods.WFNGExecute(extTabDataCardNoIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC CCI_CrdtCN output: "+ extTabDataCardNoOPXML);

			XMLParser xmlParserDataCardNo= new XMLParser(extTabDataCardNoOPXML);		
			
			if(xmlParserDataCardNo.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataExtTab=xmlParserDataCardNo.getNextValueOf("Record");
				xmlDataExtTab =xmlDataExtTab.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				
				//XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataExtTab);
				NGXmlList objWorkList=xmlParserDataCardNo.createList("Records", "Record");
											
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{		
					Card_No = objWorkList.getVal("CCI_CrdtCN").trim();
					Mobile_No = objWorkList.getVal("CCI_MONO").trim();
					oth_ssc_Amount = objWorkList.getVal("oth_ssc_Amount").trim();
					Pending_Reason = objWorkList.getVal("Pending_Reason").trim();
				}
			}
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Card_No original----------->" + Card_No);
			EncryptionDecryption ed=(EncryptionDecryption) Class.forName("com.newgen.pci.util.EncryptionDecryption").newInstance();
			Card_No = ed.decryptFormField(Card_No, sCabName);	
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Card_No----------->" + Card_No);
			
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mobile_No original----------->" + Mobile_No);
			Mobile_No = ed.decryptFormField(Mobile_No, sCabName);	
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mobile_No----------->" + Mobile_No);
			//end.
			
			String lastDigitCard_No = Card_No.substring(12,16);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("lastDigitCard_No----------->" + lastDigitCard_No);
			
			//Code to get Request Type from exttable starts here.
			String subProcessName="";
			String DBQuery = "SELECT request_type FROM RB_CSR_OCC_EXTTABLE WITH(nolock) WHERE wi_name = '"+processInstanceID+"'";
			String extTabDataIPXML = CommonMethods.apSelectWithColumnNames(DBQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC request_type data input: "+ extTabDataIPXML);
			String extTabDataOPXML = CommonMethods.WFNGExecute(extTabDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC request_type output: "+ extTabDataOPXML);

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
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("subProcessName----------->" + subProcessName);
			//end.
			String smsLang = "EN";
			
			//Code to get Request Type from exttable starts here.
			String txtMessage = "";
			String TemplateQuery = "Select SMStxtTemplate From USR_0_CSR_BT_TemplateMapping where ProcessName = 'CSR_OCC' and TemplateType = '"+stage+"' AND SubProcess = '"+subProcessName+"'";
			String templateDataIPXML = CommonMethods.apSelectWithColumnNames(TemplateQuery,CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false));
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC template data input: "+ templateDataIPXML);
			String templateDataOPXML = CommonMethods.WFNGExecute(templateDataIPXML,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC template output: "+ templateDataOPXML);

			XMLParser xmlParserTemplate= new XMLParser(templateDataOPXML);		
			
			if(xmlParserTemplate.getValueOf("MainCode").equalsIgnoreCase("0"))
			{

				String xmlDataTemplate=xmlParserTemplate.getNextValueOf("Record");
				xmlDataTemplate =xmlDataTemplate.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");
				NGXmlList objWorkListTemplate=xmlParserTemplate.createList("Records", "Record");
											
				for (; objWorkListTemplate.hasMoreElements(true); objWorkListTemplate.skip(true))
				{		
					txtMessage = objWorkListTemplate.getVal("SMStxtTemplate").trim();
					CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("txtMessage----------->" + txtMessage);
					
					if (!txtMessage.equalsIgnoreCase("NULL"))
					{
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("txtMessage before replace" + txtMessage);
						txtMessage = txtMessage.replaceAll("#WI_No#", split_WI_No);
						txtMessage = txtMessage.replaceAll("#Card_No#", lastDigitCard_No);
						txtMessage = txtMessage.replaceAll("#CancellationReason#", Pending_Reason);
						txtMessage = txtMessage.replaceAll("#DD/MM/YYYY#", date);
						txtMessage = txtMessage.replaceAll("#Sub_Process_Name#", subProcessName);
						txtMessage = txtMessage.replaceAll("#SLA_TAT#", "3");
						txtMessage = txtMessage.replaceAll("#Amount#", oth_ssc_Amount);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("txtMessage after replace" + txtMessage);
						String tableName = "NG_RLOS_SMSQUEUETABLE";
						String ALERT_Name = stage;
						String Alert_Code = "CSR_OCC";
						String Alert_Status = "P";
						//String Mobile_No = "00971500115769";//(String)iform.getValue("CCI_MONO");
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mobile no--------->" + Mobile_No);
						String Workstep_Name = "SRO_Hold";
						String columnName = "ALERT_Name, Alert_Code, Alert_Status, Mobile_No, Alert_Text, WI_Name, Workstep_Name, Inserted_Date_time";
						String values = "'" + ALERT_Name + "','" + Alert_Code + "','" + Alert_Status + "','" + Mobile_No + "','" + txtMessage
								+ "','" + WI_No + "','" + Workstep_Name + "', getdate()";
						String insertIPXml = CommonMethods.apInsert(CommonConnection.getCabinetName(), CommonConnection.getSessionID(CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger, false), columnName, values, tableName);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Query to be inserted in table-----------------: " + insertIPXml);
						String insertOPXml = CommonMethods.WFNGExecute(insertIPXml,CommonConnection.getJTSIP(),CommonConnection.getJTSPort(),1);
						CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("CSR_OCC sms insert output: "+ insertOPXml);
						//CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Mail Triggred successfuly if value of status is 1---------STATUS = " + status);
						return "success";
					}
				}
			}
		}catch(Exception ex) {
			CSROCCSROHoldCheckLog.CSROCCSROHoldCheckLogger.debug("Some error in sendSMScall" + ex.toString());
		}
		return "false";
	}

}
