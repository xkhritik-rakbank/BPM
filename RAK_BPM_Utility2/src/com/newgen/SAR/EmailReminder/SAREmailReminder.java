package com.newgen.SAR.EmailReminder;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Calendar;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.TimeZone;

import com.newgen.ODDD.ODDocDownload.ODDD_DocDownloadLog;
import com.newgen.SAR.CSVWICreation.SARWICreationLog;
import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;
import com.newgen.omni.wf.util.excp.NGException;
import com.newgen.wfdesktop.xmlapi.WFCallBroker;
import com.newgen.wfdesktop.xmlapi.WFXmlList;
import com.newgen.wfdesktop.xmlapi.WFXmlResponse;

public class SAREmailReminder implements Runnable{
	
	static Map<String, String> EmailReminderConfigParamMap = new HashMap<String, String>();
	static String sessionID = "";
	static String cabinetName = "";
	static String jtsIP ="";
	static String jtsPort ="";
	static String SMSPort ="";
	static String volumeID ="";
	int sleepIntervalInMin = 0;
	static String tempInputFileName ="";
	static String dateInInputFile ="";
	public static int sessionCheckInt=0;
	public static int loopCount=50;
	public static int waitLoop=50;
	public static String ProcessDefID="";
	public static String activityId="";
	public static String DateOnWhichMailToBeSend;
	public static String WIURL;
	public static String FromMail;
	public static String ToMail;
	public static String BOMailID;
	private static String histTable;
	private static NGEjbClient ngEjbClientConnection;
	private  String[] startTimeEscalationMail;
	private  String[] startTimeLastWorkingDayMail;
	private  String[] QueueIDs;
	
	static
	{
		try
		{
			ngEjbClientConnection = NGEjbClient.getSharedInstance();
		}
		catch (NGException e)
		{
			e.printStackTrace();
		}
	}

	@Override
	public void run() 
	{

		
		try
		{
			SAREmailReminderLog.setLogger();

			int configReadStatus = readConfig();

			SAREmailReminderLog.EmailReminderLogger.debug("configReadStatus " + configReadStatus);
			if (configReadStatus != 0) 
			{
				SAREmailReminderLog.EmailReminderLogger.error("Could not Read Config Properties!");
				return;
			}
			else
			{
				
				ProcessDefID= EmailReminderConfigParamMap.get("ProcessDefID");
			    activityId= EmailReminderConfigParamMap.get("ActivityId");
			    DateOnWhichMailToBeSend= EmailReminderConfigParamMap.get("NotificationDates");
			    WIURL= EmailReminderConfigParamMap.get("WIURL");
			    FromMail= EmailReminderConfigParamMap.get("FromMailId");
			    ToMail= EmailReminderConfigParamMap.get("ToMailId");
			    //VerifierMailID=EmailReminderConfigParamMap.get("VERIFIEREMAIL");
				histTable=EmailReminderConfigParamMap.get("WIHISTORYTABLE");
			    QueueIDs= EmailReminderConfigParamMap.get("QueueIDs").split(",");
			    startTimeEscalationMail=EmailReminderConfigParamMap.get("StartTimes").split(",");
			    startTimeLastWorkingDayMail=EmailReminderConfigParamMap.get("StartTimesLastWorkingDay").split(",");
			}
			cabinetName = CommonConnection.getCabinetName();
			SAREmailReminderLog.EmailReminderLogger.debug("Cabinet Name: " + cabinetName);

			jtsIP = CommonConnection.getJTSIP();
			SAREmailReminderLog.EmailReminderLogger.debug("JTSIP: " + jtsIP);

			jtsPort = CommonConnection.getJTSPort();
			SAREmailReminderLog.EmailReminderLogger.debug("JTSPORT: " + jtsPort);

			sleepIntervalInMin = Integer.parseInt(EmailReminderConfigParamMap.get("SleepIntervalInMin"));
			SAREmailReminderLog.EmailReminderLogger.debug("SleepIntervalInMin: " + sleepIntervalInMin);

			sessionID = CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, false);
			System.out.println("SESSION NOT CREATED"+sessionID);

			if (sessionID.trim().equalsIgnoreCase(""))
			{
				System.out.println("SESSION NOT CREATED");
				SAREmailReminderLog.EmailReminderLogger.debug("Could Not Connect to Server!");
			} 
			else
			{
				SAREmailReminderLog.EmailReminderLogger.debug("Session ID found: " + sessionID);
				while (true) 
				{
					boolean timeMatch=false;
					timeMatch=isTimeMatch(startTimeEscalationMail);
                    if(timeMatch)
                    {
                    	sessionID = CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, false);
                    	SAREmailReminderLog.setLogger();
    					SAREmailReminderLog.EmailReminderLogger.debug("Suspense Account Email reminder.");
    					startEmailReminder();
    				}
                    if(isTimeMatch(startTimeLastWorkingDayMail) && isLastWorkingDay())
        			{
                    	sessionID = CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, false);
                    	SAREmailReminderLog.setLogger();
                    	SAREmailReminderLog.EmailReminderLogger.debug("Lat Working day mails /activity.");
                    	sendEmailToReportingTeam(true);
        			}
                    SAREmailReminderLog.EmailReminderLogger.debug("No More workitems to Process, Sleeping!");
					System.out.println("No More workitems to Process, Sleeping!");
					Thread.sleep(sleepIntervalInMin * 60 * 1000);
				}
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
			SAREmailReminderLog.EmailReminderLogger.error("Exception Occurred in CreateWIFromTextFie: " + e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			SAREmailReminderLog.EmailReminderLogger.error("Exception Occurred in CreateWIFromTextFie: " + result);
		}
	
	}
	
	private int readConfig() 
	{
		Properties p = null;
		try 
		{
			p = new Properties();
			p.load(new FileInputStream(new File(System.getProperty("user.dir") + File.separator + "ConfigFiles"
					+ File.separator + "SAR_EmailReminder_Config.properties")));

			Enumeration<?> names = p.propertyNames();

			while (names.hasMoreElements()) 
			{
				String name = (String) names.nextElement();
				EmailReminderConfigParamMap.put(name, p.getProperty(name));
			}
		}
		catch (Exception e)
		{
			return -1;
		}
		return 0;
	}
	
	private void startEmailReminder()
	{
		try
		{
			SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");  
			Date date = new Date();  
			String curDate=formatter.format(date);  
			String[] curDay=curDate.split("/");
			System.out.println("curDay:"+curDay);
			String [] dates=DateOnWhichMailToBeSend.split(",");
			
			for(String str:dates)
			{
				System.out.println("str:"+str);
				System.out.println("curDay[0]:"+curDay[0]);
				System.out.println("--"+str+"--");
				System.out.println("--"+curDay[0]+"--");
				if(curDay[0].equals(str))
				{
					System.out.println("Testing");
					sendEmailToReportingTeam(false);
				}
			}
			
		}
		catch (Exception e)
		{
			SAREmailReminderLog.EmailReminderLogger.error("Exception Occurred in startEmailReminder: " + e.toString());
		}
	}
	private void sendEmailToReportingTeam(boolean isLastWorkingDay)
	{
		System.out.println("Escalation emails to SAR users.. ");
		try
		{
			//System.out.println("Getting data from remittance table InputXML = ");
			int intcount=-1;
			String VerifierMailID=getFinanceMailID();
			WFXmlList objWorkList=null;
			WFXmlResponse xmlParserData=new WFXmlResponse();
			XMLParser objXMLParser = new XMLParser();
			String Maincode="";
			String InputXML="";
			String OutputXML="";
			String query="SELECT Reporting_Team,Repo_Team_Group_Email,Ac_owner,Ac_Owner_Group_Email,Department,Department_Group_Email FROM USR_0_SAR_ReconRepHierarchyParam WITH(nolock)";
			
			SAREmailReminderLog.EmailReminderLogger.info("Query to get reprting team,owner,department combinations:- "+query);
			InputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconRepHierarchyParam table InputXML = "+InputXML);
			OutputXML=WFNGExecute(InputXML, jtsIP, jtsPort, 0 );
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconRepHierarchyParam table OutputXML = "+OutputXML);

			xmlParserData.setXmlString(OutputXML);
			Maincode=xmlParserData.getVal("MainCode");
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconRepHierarchyParam table Maincode = "+Maincode);
			if(OutputXML!=null && OutputXML.contains("TotalRetrieved"))
			{
				String count=xmlParserData.getVal("TotalRetrieved");
				if(count!=null && !"".equalsIgnoreCase(count))
					intcount=Integer.parseInt(count);
			}
			SAREmailReminderLog.EmailReminderLogger.info("Retrieved count = "+intcount);
			if(Maincode.equalsIgnoreCase("0") && intcount>0)
			{
				String dataMonth=getSubmissionMonth();
				objWorkList = xmlParserData.createList("Records", "Record");
				//SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconRepHierarchyParam table Maincode = "+objWorkList);
				//System.out.println("Getting data from remittance table objWorkList = "+objWorkList);
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{
					boolean mailFlag=false;
					StringBuilder mailTemplate=new StringBuilder();
					mailTemplate.append("<!DOCTYPE html>\r\n" + 
							"<html>\r\n" + 
							"<head>\r\n" + 
							"<style>\r\n" + 
							"table, th, td {\r\n" + 
							"  border: 1px solid black;\r\n" + 
							"  border-collapse: collapse;\r\n" + 
							"}\r\n"+
							"th {\r\n"+
							"background-color: #96D4D4\r\n"+
							"}\r\n" + 
							"</style>\r\n" + 
							"</head>\r\n" + 
							"<body>\r\n" + 
							"<p>Dear Concerned,</p>\r\n" + 
							"<p>This is an escalation email and following accounts are still pending  for submission in Month "+dataMonth+" :</p>\r\n" );
					
					String repTeam=objWorkList.getVal("Reporting_Team");
					repTeam=repTeam.replace("'", "''");
					String accOwner=objWorkList.getVal("Ac_owner");
					accOwner=accOwner.replace("'", "''");
					String Department=objWorkList.getVal("Department");
					Department=Department.replace("'", "''");
					mailTemplate.append( "<p>Reporting Team :- "+repTeam+" </p>\r\n" +
							"<p>Account Owner :- "+accOwner+" </p>\r\n"+
							"<p>Department :- "+Department+" </p>\r\n");
					String repTeamEmail=objWorkList.getVal("Repo_Team_Group_Email");
					String accOwnerEmail=objWorkList.getVal("Ac_Owner_Group_Email");
					String departmentEmail=objWorkList.getVal("Department_Group_Email");
					String queryForNotInitiated ="SELECT Account_Number,Currency,Sol_ID,Status_Balance,Line_Item,Data_Month,wi_name,status FROM USR_0_SAR_iBPS_Recon_Accounts_Table WITH(nolock) "
							+ "where Reporting_Team='"+repTeam+"' and Account_Owner='"+accOwner+"' and department='"+Department+"' and ((Status!='InProgress-VerificationQueue' and Status !='Verified') or Status is null)";
					SAREmailReminderLog.EmailReminderLogger.info("Query to get Status:- "+queryForNotInitiated);
					InputXML = CommonMethods.apSelectWithColumnNames(queryForNotInitiated, cabinetName, sessionID);
					OutputXML=WFNGExecute(InputXML, jtsIP, jtsPort, 1 );
					SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_iBPS_Recon_Accounts_Table OutputXML = "+OutputXML);
					xmlParserData.setXmlString(OutputXML);
					Maincode=xmlParserData.getVal("MainCode");
					if(OutputXML!=null && OutputXML.contains("TotalRetrieved"))
					{
						String count=xmlParserData.getVal("TotalRetrieved");
						if(count!=null && !"".equalsIgnoreCase(count))
							intcount=Integer.parseInt(count);
					}
					SAREmailReminderLog.EmailReminderLogger.info("Retrieved count = "+intcount);
					StringBuilder notInitiateCase=new StringBuilder();
					StringBuilder zeroBalance=new StringBuilder();
					if("0".equalsIgnoreCase(Maincode) && intcount>0)//
					{
						mailFlag=true;
						WFXmlList objWorkList2=null;
						objWorkList2 = xmlParserData.createList("Records", "Record");
						//SAREmailReminderLog.EmailReminderLogger.info("Getting data in HTML table Maincode = "+objWorkList2);
						int i=1,j=1;
						for (; objWorkList2.hasMoreElements(true); objWorkList2.skip(true))
						{
							String accNumber=objWorkList2.getVal("Account_Number");
							String currency=objWorkList2.getVal("Currency");
							String solID=objWorkList2.getVal("Sol_ID");
							String balance=objWorkList2.getVal("Status_Balance");
							String bsLineItem=objWorkList2.getVal("Line_Item");
							String dateMonth=objWorkList2.getVal("Data_Month");
							String winame=objWorkList2.getVal("wi_name");
							
							//SAREmailReminderLog.EmailReminderLogger.info("status value 2 from objWorkList  = "+objWorkList.getVal("status"));
							//SAREmailReminderLog.EmailReminderLogger.info("WINAME value 1 from objWorkList = "+objWorkList.getVal("WI_Name"));
							//SAREmailReminderLog.EmailReminderLogger.info("WINAME value 2 from objWorkList  = "+objWorkList.getVal("WI_Name"));
							String statusVal=objWorkList2.getVal("status").trim();
							SAREmailReminderLog.EmailReminderLogger.info("status of Account "+accNumber+" is "+statusVal);
							if(statusVal==null||"".equalsIgnoreCase(statusVal)||"NULL".equalsIgnoreCase(statusVal)||"Not Initiated".equalsIgnoreCase(statusVal)) 
							{
								notInitiateCase.append("<tr>");
								notInitiateCase.append("<td>").append(i).append("</td>");
								notInitiateCase.append("<td>").append(accNumber).append("</td>");
								notInitiateCase.append("<td>").append(currency).append("</td>");
								notInitiateCase.append("<td>").append(solID).append("</td>");
								notInitiateCase.append("<td>").append(balance).append("</td>");
								notInitiateCase.append("<td>").append(bsLineItem).append("</td>");
								notInitiateCase.append("<td>").append(dateMonth).append("</td>");
								notInitiateCase.append("<td>Not Initiated</td>");
								notInitiateCase.append("</tr>");
								i++;
							
							}
								/*mailTemplate.append("</table>");
								mailTemplate.append("</div>");*/
							
							if("InProgress-CheckerQueue".equalsIgnoreCase(statusVal)||"InProgress-OwnerQueue".equalsIgnoreCase(statusVal)
									||"InProgress-ClarificationQueue".equalsIgnoreCase(statusVal))
							{
								String WIlink=WIURL.replace("$WINAME$", winame.trim());
								zeroBalance.append("<tr>");
								zeroBalance.append("<td>").append(j).append("</td>");
								zeroBalance.append("<td>").append(winame).append("</td>");
								zeroBalance.append("<td>").append(accNumber).append("</td>");
								zeroBalance.append("<td>").append(currency).append("</td>");
								zeroBalance.append("<td>").append(solID).append("</td>");
								zeroBalance.append("<td>").append(balance).append("</td>");
								zeroBalance.append("<td>").append(bsLineItem).append("</td>");
								zeroBalance.append("<td>").append(dateMonth).append("</td>");
								zeroBalance.append("<td>").append(statusVal).append("</td>");
								zeroBalance.append("<td><a href=\"").append(WIlink).append("\" target=\"_blank\">Click Here To Open WorkItem</a></td>");
								zeroBalance.append("</tr>");
								j++;
							}
						}
						SAREmailReminderLog.EmailReminderLogger.info("Html for not initiating:- "+notInitiateCase);
						SAREmailReminderLog.EmailReminderLogger.info("Html for not zeroBalance:- "+zeroBalance);
						if(i>1)
						{
							mailTemplate.append("<div><p><b>Not Initiated Cases:</b></p>"+
									"\r\n"+
									"<table style=\"width:100%\">\r\n" + 
									"  <tr>\r\n" + 
									"    <th>Sr.No</th>\r\n" + 
									"    <th>Account Number</th> \r\n" + 
									"    <th>Currency</th>\r\n" + 
									"    <th>SolID</th>\r\n" + 
									"    <th>Status Balance</th>\r\n" + 
									"    <th>B/S Line Item</th>\r\n" + 
									"    <th>Month/Year</th>\r\n" + 
									"    <th>Status</th>\r\n" + 
									"  </tr>\r\n" + 
									"");
							mailTemplate.append(notInitiateCase);
							mailTemplate.append("</table>");	
							mailTemplate.append("</div>");
						}
						if(j>1)
						{
							mailTemplate.append("<div>");	
							mailTemplate.append("<p><b>Non-Zero Balance - Manual Created WIs</b></p>");	
						
							mailTemplate.append("<table style=\"width:100%\">\r\n" + 
									"  <tr>\r\n" + 
									"    <th>Sr.No</th>\r\n" + 
									"    <th>WI Number</th>\r\n" + 
									"    <th>Account Number</th> \r\n" + 
									"    <th>Currency</th>\r\n" + 
									"    <th>SolID</th>\r\n" + 
									"    <th>Status Balance</th>\r\n" + 
									"    <th>B/S Line Item</th>\r\n" + 
									"    <th>Month/Year</th>\r\n" + 
									"    <th>Status</th>\r\n" + 
									"    <th>WI Link</th>\r\n" + 
									"  </tr>\r\n" + 
									"");
							mailTemplate.append(zeroBalance);
							mailTemplate.append("</table>");	
							mailTemplate.append("</div>");
						}
						
					}
					dataMonth=getSubmissionMonth();
					String csvQuery="SELECT WI_NAME,CSVName,Status FROM USR_0_SAR_ReconCSVWorkItem WITH(nolock) "
							+ "where ReportingTeam='"+repTeam+"' and AccOwner='"+accOwner+"' and Department='"+Department+"' and  data_month='"+dataMonth+"' and ((Status!='InProgress-VerificationQueue' and Status !='Verified') or Status is null)";
					SAREmailReminderLog.EmailReminderLogger.info("Query to get CSV Status:- "+csvQuery);
					//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem query = "+csvQuery);
					String InputXML1 = CommonMethods.apSelectWithColumnNames(csvQuery, cabinetName, sessionID);
					SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconCSVWorkItem table InputXML = "+InputXML1);
					//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem InputXML = "+InputXML1);
					String OutputXML1=WFNGExecute(InputXML1, jtsIP, jtsPort, 1 );
					SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconCSVWorkItem OutputXML = "+OutputXML1);
					//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem table OutputXML1 = "+OutputXML1);
					xmlParserData.setXmlString(OutputXML1);
					Maincode=xmlParserData.getVal("MainCode");
					SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconCSVWorkItem table Maincode = "+Maincode);
					if(OutputXML1!=null && OutputXML1.contains("TotalRetrieved"))
					{
						String count=xmlParserData.getVal("TotalRetrieved");
						if(count!=null && !"".equalsIgnoreCase(count))
							intcount=Integer.parseInt(count);
					}
					SAREmailReminderLog.EmailReminderLogger.info("Retrieved count = "+intcount);
					//System.out.println("Getting data from USR_0_SAR_ReconCSVWorkItem table Maincode = "+Maincode);
					
					if(Maincode.equalsIgnoreCase("0") && intcount>0)//
					{	
						mailFlag=true;
						//mailTemplate.append("</table>");
						//mailTemplate.append("</div>");
						
						StringBuilder csvCases=new StringBuilder();
						WFXmlList objWorkList3=null;
						objWorkList3 = xmlParserData.createList("Records", "Record");
						//SAREmailReminderLog.EmailReminderLogger.info("Getting data in csvCases table Maincode = "+objWorkList);
						//System.out.println("Getting data in csvCases table  objWorkList = "+objWorkList);
						int k=1;
								
						for (; objWorkList3.hasMoreElements(true); objWorkList3.skip(true))
						{
							String csvName=objWorkList3.getVal("CSVName");
							String WI_NAME=objWorkList3.getVal("WI_NAME");
							String statusVal=objWorkList3.getVal("Status");
							String WIlink=WIURL.replace("$WINAME$", WI_NAME.trim());
							csvCases.append("<tr>");
							csvCases.append("<td>").append(k).append("</td>");
							csvCases.append("<td>").append(WI_NAME).append("</td>");
							csvCases.append("<td>").append(csvName).append("</td>");
							csvCases.append("<td>").append(statusVal).append("</td>");
							csvCases.append("<td><a href=\"").append(WIlink).append("\" target=\"_blank\">Click Here To Open WorkItem</a></td>");
							csvCases.append("</tr>");
							k++;
						}
						if(k>1)
						{
							mailTemplate.append("<div><p><b>CSV Auto Initiated Cases:</b></p>");
							mailTemplate.append("<table style=\"width:100%\">\r\n" + 
									"  <tr>\r\n" + 
									"    <th>Sr.No</th>\r\n" + 
									"    <th>WI Number</th> \r\n" + 
									"    <th>CSV Name</th>\r\n" + 
									"    <th>Status</th>\r\n" +
									"    <th>WI Link</th>\r\n" +
									"  </tr>\r\n" + 
									"");
							mailTemplate.append(csvCases);
							mailTemplate.append("</table>");
							mailTemplate.append("</div>");
						}
						
					}
					mailTemplate.append("<p><br>Regards<br>BPM Team <br> Note : This is a system generated e-mail and please do not reply.</p>");
					mailTemplate.append("</body>");
					mailTemplate.append("</html>");
					SAREmailReminderLog.EmailReminderLogger.info(mailTemplate);
					SAREmailReminderLog.EmailReminderLogger.info("Mail Flag --"+mailFlag);
					if(mailFlag)
					{
						String ccMail="";
						
						if(repTeamEmail!=null && !"".equalsIgnoreCase(repTeamEmail))
							ccMail=repTeamEmail;
						
						if(accOwnerEmail!=null && !"".equalsIgnoreCase(accOwnerEmail))
							ccMail=ccMail+","+accOwnerEmail;
						
						if(VerifierMailID!=null && !"".equalsIgnoreCase(VerifierMailID))
							ccMail=ccMail+","+VerifierMailID;
						SAREmailReminderLog.EmailReminderLogger.info("CC Email ID --"+ccMail);
						SAREmailReminderLog.EmailReminderLogger.info("To Email ID --"+departmentEmail);
						if(!isLastWorkingDay)
							sendMail(cabinetName,sessionID,mailTemplate.toString(),departmentEmail,ccMail);
						
						if(isLastWorkingDay)
						{
							System.out.println("It is the last working day of month.. ");
							SAREmailReminderLog.EmailReminderLogger.error("It is the last working day of month.. ");
							String toMail="";
							if(repTeamEmail!=null && !"".equalsIgnoreCase(repTeamEmail))
								toMail=repTeamEmail;
							if(accOwnerEmail!=null && !"".equalsIgnoreCase(accOwnerEmail))
								toMail=toMail+","+accOwnerEmail;
							SAREmailReminderLog.EmailReminderLogger.info("CC Email ID --"+ccMail);
							SAREmailReminderLog.EmailReminderLogger.info("To Email ID --"+departmentEmail);
							String status = sendMail(cabinetName,sessionID,mailTemplate.toString(),toMail,VerifierMailID);
							if("0".equalsIgnoreCase(status))
							{
								//discardCases();
							}
						}
					}
					
				}
				if(isLastWorkingDay)
				{
					SAREmailReminderLog.EmailReminderLogger.error("It is the last working day of month So Discarding all the pending cases...");
					discardCases();
				}
			} 
			//Combination for mail not in the parameter sheet
			String missingCombinationQuery="select DISTINCT reporting_team,account_owner,department, (select distinct stuff (( select ',' + Account_Number from USR_0_SAR_iBPS_Recon_Accounts_Table with(nolock) where reporting_team=A.reporting_team and account_owner=A.account_owner and department=A.Department for xml path (''),TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) as 'AccountNumber' from USR_0_SAR_iBPS_Recon_Accounts_Table as A with(nolock) where not exists "+
											"( select * from USR_0_SAR_ReconRepHierarchyParam as P with(nolock) where A.reporting_team=P.reporting_team and A.account_owner=P.ac_Owner and A.department=P.department)";
			SAREmailReminderLog.EmailReminderLogger.info("Query to get missingCombination:- "+missingCombinationQuery);
			//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem query = "+csvQuery);
			String missingCombinationIpXML = CommonMethods.apSelectWithColumnNames(missingCombinationQuery, cabinetName, sessionID);
			SAREmailReminderLog.EmailReminderLogger.info("Getting missingCombination data from table InputXML = "+missingCombinationIpXML);
			//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem InputXML = "+InputXML1);
			String missingCombinationOPXML1=WFNGExecute(missingCombinationIpXML, jtsIP, jtsPort, 1 );
			SAREmailReminderLog.EmailReminderLogger.info("Getting dmissingCombination data from OutputXML = "+missingCombinationOPXML1);
			//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem table OutputXML1 = "+OutputXML1);
			xmlParserData.setXmlString(missingCombinationOPXML1);
			String missingCombinationMaincode=xmlParserData.getVal("MainCode");
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_SAR_ReconCSVWorkItem table Maincode = "+missingCombinationMaincode);
			
			if(missingCombinationOPXML1!=null && missingCombinationOPXML1.contains("TotalRetrieved"))
			{ 
				int missingCombinationintcount=-1;
				String count=xmlParserData.getVal("TotalRetrieved");
				if(count!=null && !"".equalsIgnoreCase(count))
					missingCombinationintcount=Integer.parseInt(count);
				if(missingCombinationintcount>0 && "0".equalsIgnoreCase(missingCombinationMaincode))
				{
					SAREmailReminderLog.EmailReminderLogger.info("Retrieved count = "+missingCombinationintcount);
					StringBuilder missingCombinationMailTemp=new StringBuilder();
					missingCombinationMailTemp.append("<!DOCTYPE html>\r\n" + 
							"<html>\r\n" + 
							"<head>\r\n" + 
							"<style>\r\n" + 
							"table, th, td {\r\n" + 
							"  border: 1px solid black;\r\n" + 
							"  border-collapse: collapse;\r\n" + 
							"}\r\n"+
							"th {\r\n"+
							"background-color: #96D4D4\r\n"+
							"}\r\n" + 
							"</style>\r\n" + 
							"</head>\r\n" + 
							"<body>\r\n" + 
							"<p>Dear Concerned,</p>\r\n" + 
							"<p>Accounts associated with following parameters combinations can not be processed as combination is not available in BPM reporting team parameter table.</p>\r\n" );
					missingCombinationMailTemp.append("<div><p><b>Combination of Parameters:</b></p>");
					missingCombinationMailTemp.append("<table style=\"width:100%\">\r\n" + 
							"  <tr>\r\n" + 
							"    <th>Sr.No</th>\r\n" + 
							"    <th>Reporting Team</th> \r\n" + 
							"    <th>Account Owner</th>\r\n" + 
							"    <th>Department</th>\r\n" +
							"    <th>Accounts</th>\r\n" +
							"  </tr>\r\n" + 
							"");
					StringBuilder combination = new StringBuilder();
					WFXmlList objWorkList3=null;
					objWorkList3 = xmlParserData.createList("Records", "Record");
					//SAREmailReminderLog.EmailReminderLogger.info("Getting data in csvCases table Maincode = "+objWorkList);
					//System.out.println("Getting data in csvCases table  objWorkList = "+objWorkList);
					int k=1;
							
					for (; objWorkList3.hasMoreElements(true); objWorkList3.skip(true))
					{
						String reporting_team=objWorkList3.getVal("reporting_team");
						String account_owner=objWorkList3.getVal("account_owner");
						String department=objWorkList3.getVal("department");
						String Accounts=objWorkList3.getVal("AccountNumber");
						combination.append("<tr>");
						combination.append("<td>").append(k).append("</td>");
						combination.append("<td>").append(reporting_team).append("</td>");
						combination.append("<td>").append(account_owner).append("</td>");
						combination.append("<td>").append(department).append("</td>");
						combination.append("<td style=\"word-break:break-all;\">").append(Accounts).append("</td>");
						combination.append("</tr>");
						k++;
					}
					missingCombinationMailTemp.append(combination);
					missingCombinationMailTemp.append("</table>");
					missingCombinationMailTemp.append("</div>");
					missingCombinationMailTemp.append("<p><br>Regards<br>BPM Team <br> Note : This is a system generated e-mail and please do not reply.</p>");
					missingCombinationMailTemp.append("</body>");
					missingCombinationMailTemp.append("</html>");
					SAREmailReminderLog.EmailReminderLogger.info(missingCombinationMailTemp);
					sendMail(cabinetName,sessionID,missingCombinationMailTemp.toString(),BOMailID,VerifierMailID);
				}
			}
		}
		catch(Exception e)
		{
			SAREmailReminderLog.EmailReminderLogger.error("Exception Occurred in sendEmailToReportingTeam: " + e.toString());
			//System.out.println("Getting data from remittance table Exception "+e.getMessage());
		}
	}
	protected static String WFNGExecute(String ipXML, String jtsServerIP, String serverPort,
			int flag) throws IOException, Exception
	{
		
		SAREmailReminderLog.EmailReminderLogger.debug("In WF NG Execute : " + serverPort);
		try
		{
			if (serverPort.startsWith("33"))
				return WFCallBroker.execute(ipXML, jtsServerIP,
						Integer.parseInt(serverPort), 1);
			else
				return ngEjbClientConnection.makeCall(jtsServerIP, serverPort,
						"WebSphere", ipXML);
		}
		catch (Exception e)
		{
			System.out.println("Testing...");
			SAREmailReminderLog.EmailReminderLogger.debug("Exception Occured in WF NG Execute : "
					+ e.getMessage());
			e.printStackTrace();
			return "Error";
		}
	}
	public static String sendMail(String cabinetName, String sessionId,String MailStr,String mailTo,String mailCC)throws Exception
	{
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String mainCodeforAPInsert=null;
		sessionCheckInt=0;
		String retVal="-1";
		while(sessionCheckInt<loopCount)
		{
			try
			{
				String mailSubject = "";
				mailSubject="Suspense Account Reconciliation – Escalation of "+getSubmissionMonth();
				String columnName = "mailFrom,mailTo,mailCC,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,mailActionType,insertedTime,processDefId,workitemId,activityId,noOfTrials,zipFlag";
				String strValues = "'"+FromMail+"','"+mailTo+"','"+mailCC+"','"+mailSubject+"','"+MailStr+"','text/html;charset=UTF-8','1','N','TRIGGER','"+CommonMethods.getdateCurrentDateInSQLFormat()+"','"+ProcessDefID+"','1','"+activityId+"','0','N'";
				
				sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>WFMAILQUEUETABLE</TableName>" +
						"<ColName>" + columnName + "</ColName>" +
						"<Values>" + strValues + "</Values>" +
						"<EngineName>" + cabinetName + "</EngineName>" +
						"<SessionId>" + sessionId + "</SessionId>" +
						"</APInsert_Input>";

				SAREmailReminderLog.EmailReminderLogger.info("Mail Insert InputXml::::::::::\n"+sInputXML);
				sOutputXML =WFNGExecute(sInputXML, jtsIP, jtsPort, 0);
				SAREmailReminderLog.EmailReminderLogger.info("Mail Insert OutputXml::::::::::\n"+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
			}
			catch(Exception e)
			{
				e.printStackTrace();
				SAREmailReminderLog.EmailReminderLogger.error("Exception in Sending mail", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				SAREmailReminderLog.EmailReminderLogger.info("Invalid session in Sending mail");
				sessionCheckInt++;
				sessionID=CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, true);
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}
		if(mainCodeforAPInsert.equalsIgnoreCase("0"))
		{
			SAREmailReminderLog.EmailReminderLogger.info("mail Insert Successful");
			retVal="0";
		}
		else
		{
			SAREmailReminderLog.EmailReminderLogger.info("mail Insert Unsuccessful");
		}
		return retVal;
	}
	public static void waiteloopExecute(long wtime) 
	{
		try 
		{
			for (int i = 0; i < 10; i++) 
			{
				Thread.yield();
				Thread.sleep(wtime / 10);
			}
		} 
		catch (InterruptedException e) 
		{
		}
	}
	public boolean isTimeMatch(String startTime[])
	{
		DateFormat timeFormat = new SimpleDateFormat("hh:mm a");
		Date date = null;
		date = new Date();
		boolean timeMatch = false;
		System.out.println(timeFormat.format(date));
		for(int i=0; i<startTime.length; i++)
		{
			if(startTime[i].equals(timeFormat.format(date)))
			{
				System.out.println("it's time to run.."+startTime[i]);
				timeMatch=true;
				break;
			}
		}
		
		return timeMatch;
		//return true;
	}
	private boolean isLastWorkingDay()
	{
		try
		{
			Calendar Date = Calendar.getInstance();
			int lastWorkingDay=getLastWorkingDayOfMonth();
			SAREmailReminderLog.EmailReminderLogger.info("LastWorking Day of MOnth:- "+lastWorkingDay);
			return Date.get(Calendar.DAY_OF_MONTH)==lastWorkingDay;
			/*Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
			System.out.println("Current Date-"+cal);
			int lastDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			System.out.println("last day of month-"+lastDay);
			//System.out.println(Date.get(cal.DAY_OF_MONTH));
			//System.out.println(cal.get(Calendar.DAY_OF_WEEK));
			cal.set(Calendar.DAY_OF_MONTH, lastDay);
			switch(cal.get(Calendar.DAY_OF_WEEK))
			{
				case Calendar.SUNDAY:
					lastDay--;
				case Calendar.SATURDAY:
					lastDay--;
			}
			System.out.println("last working day of month-"+lastDay);
			System.out.println("Current Day-"+Calendar.DAY_OF_MONTH);*/
			
			//System.out.println(cal.get(Calendar.DAY_OF_WEEK));
			//System.out.println(Calendar.SUNDAY);
			//System.out.println(Calendar.SATURDAY);
		}
		catch (Exception e)
		{
			System.out.print(e.getMessage());
			SAREmailReminderLog.EmailReminderLogger.info("Exception in isLastWorkingDay :- "+e.toString());
			return false;
		}
	}
	private int getLastWorkingDayOfMonth()
	{
		try
		{
			Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
			//System.out.println("Current Date-"+cal);
			int lastDayofMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
			int lastWeekDayofMonth = WeekendCheck(lastDayofMonth);
			int lastWorkingdayofMonth = HolidayCheck(lastWeekDayofMonth);
			
			while(lastWeekDayofMonth!=lastWorkingdayofMonth)
			{
				lastWeekDayofMonth = WeekendCheck(lastWorkingdayofMonth);
				lastWorkingdayofMonth = HolidayCheck(lastWeekDayofMonth);
			}
			return lastWorkingdayofMonth;
		}
		catch(Exception e)
		{
			System.out.print(e.getMessage());
			SAREmailReminderLog.EmailReminderLogger.info("Exception in getLastWorkingDayOfMonth :- "+e.toString());
		}
		return 31;
	}
	@SuppressWarnings("deprecation")
	private int HolidayCheck(int inputDate)
	{
		int outputDate=inputDate;
		try
		{
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Date d = new Date();
			d.setDate(inputDate);
			String date = simpleDateFormat.format(d);
			
			String Query="select count(*) as count from USR_0_CPF_Holiday_Master with(nolock) where HolidayDate='"+date+"' and IsActive='Y'";//2022-08-24
			SAREmailReminderLog.EmailReminderLogger.info("Query to check whether the date is holiday:- "+Query);
			//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem query = "+csvQuery);
			String InputXML1 = CommonMethods.apSelectWithColumnNames(Query, cabinetName, sessionID);
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_CPF_Holiday_Master table InputXML = "+InputXML1);
			//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem InputXML = "+InputXML1);
			String OutputXML1=WFNGExecute(InputXML1, jtsIP, jtsPort, 1 );
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_CPF_Holiday_Master OutputXML = "+OutputXML1);
			//System.out.println("Getting data from CSV USR_0_SAR_ReconCSVWorkItem table OutputXML1 = "+OutputXML1);
			WFXmlResponse xmlParserData=new WFXmlResponse(); 
			xmlParserData.setXmlString(OutputXML1);
			String Maincode=xmlParserData.getVal("MainCode");
			SAREmailReminderLog.EmailReminderLogger.info("Getting data from USR_0_CPF_Holiday_Master table Maincode = "+Maincode);
			if(OutputXML1!=null && OutputXML1.contains("TotalRetrieved"))
			{
				String countOfRecords=xmlParserData.getVal("TotalRetrieved");
				int intrecordcount=-1;
				if(countOfRecords!=null && !"".equalsIgnoreCase(countOfRecords))
					intrecordcount=Integer.parseInt(countOfRecords);
				if(intrecordcount>0)
				{
					String count=xmlParserData.getVal("count");
					if(!"0".contentEquals(count))
					{
						outputDate--;
					}
				}
			}
		}
		catch(Exception e)
		{
			System.out.print(e.getMessage());
			SAREmailReminderLog.EmailReminderLogger.info("Exception in HolidayCheck Check:- "+e.toString());
		}
		
		return outputDate;
	}
	private int WeekendCheck(int inputDate)
	{
		try
		{
			
			Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
			cal.set(Calendar.DAY_OF_MONTH, inputDate);
			switch(cal.get(Calendar.DAY_OF_WEEK))
			{
				case Calendar.SUNDAY:
					inputDate--;
				case Calendar.SATURDAY:
					inputDate--;
			}
			System.out.println("Value of output date post weekend check-"+inputDate);
			return inputDate;
		}
		catch(Exception e)
		{
			System.out.print(e.getMessage());
			SAREmailReminderLog.EmailReminderLogger.info("Exception in weekend Check:- "+e.toString());
		}
		return -1;
	}
	private void discardCases()
	{
		try
		{
			for(String qId :QueueIDs)
			{
				qId=qId.trim();
				sessionID  = CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, false);

				if(sessionID==null || sessionID.equalsIgnoreCase("") || sessionID.equalsIgnoreCase("null"))
				{
					SAREmailReminderLog.EmailReminderLogger.error("Could Not Get Session ID "+sessionID);
					return;
				}

				//Fetch all Work-Items on given queueID.
				SAREmailReminderLog.EmailReminderLogger.info("Fetching all Workitems on SAR queues for QID:- "+qId);
				//System.out.println("Fetching all Workitems on OD_Doc_Download queue");
				String fetchWorkitemListInputXML=CommonMethods.fetchWorkItemsInput(cabinetName, sessionID, qId);
				SAREmailReminderLog.EmailReminderLogger.info("InputXML for fetchWorkList Call: "+fetchWorkitemListInputXML);

				String fetchWorkitemListOutputXML= CommonMethods.WFNGExecute(fetchWorkitemListInputXML,jtsIP,jtsPort,1);

				SAREmailReminderLog.EmailReminderLogger.info("WMFetchWorkList OutputXML: "+fetchWorkitemListOutputXML);

				XMLParser xmlParserFetchWorkItemlist = new XMLParser(fetchWorkitemListOutputXML);

				String fetchWorkItemListMainCode = xmlParserFetchWorkItemlist.getValueOf("MainCode");
				SAREmailReminderLog.EmailReminderLogger.info("FetchWorkItemListMainCode: "+fetchWorkItemListMainCode);
				int fetchWorkitemListCount=0;
				if(fetchWorkitemListOutputXML!=null &&fetchWorkitemListOutputXML.contains("RetrievedCount"))
				fetchWorkitemListCount = Integer.parseInt(xmlParserFetchWorkItemlist.getValueOf("RetrievedCount"));
				SAREmailReminderLog.EmailReminderLogger.info("RetrievedCount for WMFetchWorkList Call: "+fetchWorkitemListCount);

				SAREmailReminderLog.EmailReminderLogger.info("Number of workitems retrieved on Queue: "+fetchWorkitemListCount);

				System.out.println("Number of workitems retrieved on Queue: "+fetchWorkitemListCount);

				if (fetchWorkItemListMainCode.trim().equals("0") && fetchWorkitemListCount > 0)
				{
					for(int i=0; i<fetchWorkitemListCount; i++)
					{
						String attributesTag ="<Decision>Discard</Decision>";
						String fetchWorkItemlistData=xmlParserFetchWorkItemlist.getNextValueOf("Instrument");
						fetchWorkItemlistData =fetchWorkItemlistData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

						SAREmailReminderLog.EmailReminderLogger.info("Parsing <Instrument> in WMFetchWorkList OutputXML: "+fetchWorkItemlistData);
						XMLParser xmlParserfetchWorkItemData = new XMLParser(fetchWorkItemlistData);

						String processInstanceID=xmlParserfetchWorkItemData.getValueOf("ProcessInstanceId");
						SAREmailReminderLog.EmailReminderLogger.info("Current ProcessInstanceID: "+processInstanceID);

						SAREmailReminderLog.EmailReminderLogger.info("Processing Workitem: "+processInstanceID);
						System.out.println("\nProcessing Workitem: "+processInstanceID);

						String WorkItemID=xmlParserfetchWorkItemData.getValueOf("WorkItemId");
						SAREmailReminderLog.EmailReminderLogger.info("Current WorkItemID: "+WorkItemID);

						String entryDateTime=xmlParserfetchWorkItemData.getValueOf("EntryDateTime");
						SAREmailReminderLog.EmailReminderLogger.info("Current EntryDateTime: "+entryDateTime);

						String ActivityName=xmlParserfetchWorkItemData.getValueOf("ActivityName");
						SAREmailReminderLog.EmailReminderLogger.info("ActivityName: "+ActivityName);
						String ActivityID = xmlParserfetchWorkItemData.getValueOf("WorkStageId");
						SAREmailReminderLog.EmailReminderLogger.info("ActivityID: " + ActivityID);
						String ActivityType = xmlParserfetchWorkItemData.getValueOf("ActivityType");
						SAREmailReminderLog.EmailReminderLogger.info("ActivityType: " + ActivityType);
						String ProcessDefId = xmlParserfetchWorkItemData.getValueOf("RouteId");
						SAREmailReminderLog.EmailReminderLogger.info("ProcessDefId: " + ProcessDefId);
						CompleteWorkItem(processInstanceID,WorkItemID,ActivityID,ProcessDefId,ActivityType,attributesTag,entryDateTime,ActivityName);
						//CompleteWorkItem(String processInstanceID,String WorkItemID,String ActivityID, String ProcessDefId ,String ActivityType ,String attributesTag,String entryDateTime,String ActivityName )
						//Lock Workitem.
						/*String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
						String getWorkItemOutputXml = CommonMethods.WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);
						SAREmailReminderLog.EmailReminderLogger.info("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);
						
						XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
						String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
						SAREmailReminderLog.EmailReminderLogger.info("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

						if (getWorkItemMainCode.trim().equals("0"))
						{
							String assignWorkitemAttributeInputXML = "<?xml version=\"1.0\"?><WMAssignWorkItemAttributes_Input>" 
									+ "<Option>WMAssignWorkItemAttributes</Option>" 
									+ "<EngineName>" + cabinetName + "</EngineName>" 
									+ "<SessionId>" + sessionID + "</SessionId>" 
									+ "<ProcessInstanceId>" + processInstanceID + "</ProcessInstanceId>" 
									+ "<WorkItemId>" + WorkItemID + "</WorkItemId>" 
									+ "<ActivityId>" + ActivityID + "</ActivityId>" 
									+ "<ProcessDefId>" + ProcessDefId + "</ProcessDefId>"
									+ "<LastModifiedTime></LastModifiedTime>" 
									+ "<ActivityType>" + ActivityType + "</ActivityType>" 
									+ "<complete>D</complete>" 
									+ "<AuditStatus></AuditStatus>"
									+ "<Comments></Comments>" 
									+ "<UserDefVarFlag>Y</UserDefVarFlag>" 
									+ "<Attributes>" + attributesTag + "</Attributes>" 
									+ "</WMAssignWorkItemAttributes_Input>";

							SAREmailReminderLog.EmailReminderLogger.debug("InputXML for assignWorkitemAttribute Call: " + assignWorkitemAttributeInputXML);

							String assignWorkitemAttributeOutputXML = CommonMethods.WFNGExecute(assignWorkitemAttributeInputXML, jtsIP, jtsPort, 1);

							SAREmailReminderLog.EmailReminderLogger.info("OutputXML for assignWorkitemAttribute Call: " + assignWorkitemAttributeOutputXML);

							XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
							String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
							SAREmailReminderLog.EmailReminderLogger.info("AssignWorkitemAttribute MainCode: " + assignWorkitemAttributeMainCode);
							if("0".equalsIgnoreCase(assignWorkitemAttributeMainCode))
							{
								UpdateWIHistory(cabinetName,processInstanceID,entryDateTime,ActivityName);
							}
						}*/
					}
			
				}
				else
				{
					SAREmailReminderLog.EmailReminderLogger.info("Unable to fetch items from queue:-  Main code:"+ fetchWorkItemListMainCode+ "Retrived Count: "+fetchWorkitemListCount);
				}
			}
			
			discardLockedCases();
			
		}
		catch(Exception e)
		{
			SAREmailReminderLog.EmailReminderLogger.info("Exception occured while discarding the cases..."+e.toString());
		}
	}
	private static void discardLockedCases()
	{
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String RecordCount="";
		String MaincodeTemp="";
		String attributesTag ="<Decision>Discard</Decision>";
		try
		{
			String query="select ProcessInstanceID,workitemid,activityid,ProcessDefId,ActivityType,EntryDATETIME,ActivityName,lockstatus from WFINSTRUMENTTABLE with(nolock) where processdefid=(select ProcessDefId from PROCESSDEFTABLE with(nolock) where ProcessName='SAR') and q_userid > 0 and activityname in ('Initiation','Dept_Owner','Verifier','Dept_Checker','Initiator_Reject')";
			sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
			SAREmailReminderLog.EmailReminderLogger.info("Get locked cases inputXMl = "+sInputXML);
			sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
			SAREmailReminderLog.EmailReminderLogger.info("Get locked cases OpXMl = "+sOutputXML);
			objXMLParser.setInputXML(sOutputXML);
			MaincodeTemp=objXMLParser.getValueOf("MainCode");
			SAREmailReminderLog.EmailReminderLogger.info("Get locked cases MainCode = "+MaincodeTemp);
			RecordCount=objXMLParser.getValueOf("TotalRetrieved");
			if("0".equalsIgnoreCase(MaincodeTemp) && RecordCount!=null && !"".equalsIgnoreCase(RecordCount) && Integer.parseInt(RecordCount)>0)
			{
				for(int i=0;i<Integer.parseInt(RecordCount);i++)
				{
					
					String xmlDataofRecord = objXMLParser.getNextValueOf("Record");
					xmlDataofRecord = xmlDataofRecord.replaceAll("[ ]+>", ">").replaceAll("<[ ]+", "<");
					XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataofRecord);
					
					String processInstanceID=xmlParserExtTabDataRecord.getValueOf("ProcessInstanceID");
					SAREmailReminderLog.EmailReminderLogger.info("Current ProcessInstanceID: "+processInstanceID);

					/*SAREmailReminderLog.EmailReminderLogger.info("Processing Workitem: "+processInstanceID);
					System.out.println("\nProcessing Workitem: "+processInstanceID);*/

					String WorkItemID=xmlParserExtTabDataRecord.getValueOf("workitemid");
					SAREmailReminderLog.EmailReminderLogger.info("Current WorkItemID: "+WorkItemID);

					String entryDateTime=xmlParserExtTabDataRecord.getValueOf("EntryDATETIME");
					SAREmailReminderLog.EmailReminderLogger.info("Current EntryDateTime: "+entryDateTime);

					String ActivityName=xmlParserExtTabDataRecord.getValueOf("ActivityName");
					SAREmailReminderLog.EmailReminderLogger.info("ActivityName: "+ActivityName);
					String ActivityID = xmlParserExtTabDataRecord.getValueOf("activityid");
					SAREmailReminderLog.EmailReminderLogger.info("ActivityID: " + ActivityID);
					String ActivityType = xmlParserExtTabDataRecord.getValueOf("ActivityType");
					SAREmailReminderLog.EmailReminderLogger.info("ActivityType: " + ActivityType);
					String ProcessDefId = xmlParserExtTabDataRecord.getValueOf("ProcessDefId");
					SAREmailReminderLog.EmailReminderLogger.info("ProcessDefId: " + ProcessDefId);
					String lockstatus = xmlParserExtTabDataRecord.getValueOf("lockstatus");
					SAREmailReminderLog.EmailReminderLogger.info("lockstatus: " + lockstatus);
					if("Y".equalsIgnoreCase(lockstatus))
					{
						String ULinputXML="<?xml version=\"1.0\"?><WMUnlockWorkItem_Input>"+
											"<Option>WMUnlockWorkItem</Option>"+
											"<EngineName>"+cabinetName+"</EngineName>"+
											"<SessionId>"+sessionID+"</SessionId>"+
											"<ProcessInstanceID>"+processInstanceID+"</ProcessInstanceID>"+
											"<WorkItemID>"+WorkItemID+"</WorkItemID>"+
											"<ZipBuffer>N</ZipBuffer>"+
											"<RightFlag>010100</RightFlag>"+
											"<Admin>Y</Admin>"+
											"</WMUnlockWorkItem_Input>";
						SAREmailReminderLog.EmailReminderLogger.info("Input XML For WMUnlockWorkItem: "+ ULinputXML);
						String ULWorkItemOutputXml = CommonMethods.WFNGExecute(ULinputXML,jtsIP,jtsPort,1);
						SAREmailReminderLog.EmailReminderLogger.info("Output XML For WMUnlockWorkItem: "+ ULWorkItemOutputXml);
						
						XMLParser xmlParserGetWorkItem = new XMLParser(ULWorkItemOutputXml);
						String ULWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
						SAREmailReminderLog.EmailReminderLogger.info("WMUnlockWorkItem Maincode:  "+ ULWorkItemMainCode);

						if (ULWorkItemMainCode.trim().equals("0"))
						{
							CompleteWorkItem(processInstanceID,WorkItemID,ActivityID,ProcessDefId,ActivityType,attributesTag,entryDateTime,ActivityName);
						}
						
					}
					else
					{
						String ReassinputXML="<?xml version=\"1.0\"?>"+
											"<WMReassignWorkItem_Input>"+
											"<Option>WMReassignWorkItem</Option>"+
											"<EngineName>"+cabinetName+"</EngineName>"+
											"<SessionId>"+sessionID+"</SessionId>"+
											"<ProcessInstanceId>"+processInstanceID+"</ProcessInstanceId>"+
											"<WorkItemId>"+WorkItemID+"</WorkItemId>"+
											"<SourceUser></SourceUser>"+
											"<TargetUser>"+CommonConnection.getUsername()+"</TargetUser>"+
											"<Comments>Self Assign to discard</Comments>"+
											"</WMReassignWorkItem_Input>";
						SAREmailReminderLog.EmailReminderLogger.info("Input XML For WMReassignWorkItem: "+ ReassinputXML);
						String ReassWorkItemOutputXml = CommonMethods.WFNGExecute(ReassinputXML,jtsIP,jtsPort,1);
						SAREmailReminderLog.EmailReminderLogger.info("Output XML For WMReassignWorkItem: "+ ReassWorkItemOutputXml);
						
						XMLParser xmlParserReassWorkItem = new XMLParser(ReassWorkItemOutputXml);
						String ReassWorkItemMainCode = xmlParserReassWorkItem.getValueOf("MainCode");
						SAREmailReminderLog.EmailReminderLogger.info("WMReassignWorkItem Maincode:  "+ ReassWorkItemMainCode);
			
						if (ReassWorkItemMainCode.trim().equals("0"))
						{
							CompleteWorkItem(processInstanceID,WorkItemID,ActivityID,ProcessDefId,ActivityType,attributesTag,entryDateTime,ActivityName);
						}
						
					}
				}
			}
			else
			{
				SAREmailReminderLog.EmailReminderLogger.info("MainCode:-"+MaincodeTemp +" TotalRetrieved:-"+RecordCount);
			}
		}
		catch(Exception e)
		{
			SAREmailReminderLog.EmailReminderLogger.error("Exception in discardLockedCases...");
		}
	}
	private static void CompleteWorkItem(String processInstanceID,String WorkItemID,String ActivityID, String ProcessDefId ,String ActivityType ,String attributesTag,String entryDateTime,String ActivityName )
	{
		try
		{
			String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
			String getWorkItemOutputXml = CommonMethods.WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);
			SAREmailReminderLog.EmailReminderLogger.info("Output XML For WmgetWorkItemCall: "+ getWorkItemOutputXml);
			
			XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
			String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
			SAREmailReminderLog.EmailReminderLogger.info("WmgetWorkItemCall Maincode:  "+ getWorkItemMainCode);

			if (getWorkItemMainCode.trim().equals("0"))
			{
				String assignWorkitemAttributeInputXML = "<?xml version=\"1.0\"?><WMAssignWorkItemAttributes_Input>" 
						+ "<Option>WMAssignWorkItemAttributes</Option>" 
						+ "<EngineName>" + cabinetName + "</EngineName>" 
						+ "<SessionId>" + sessionID + "</SessionId>" 
						+ "<ProcessInstanceId>" + processInstanceID + "</ProcessInstanceId>" 
						+ "<WorkItemId>" + WorkItemID + "</WorkItemId>" 
						+ "<ActivityId>" + ActivityID + "</ActivityId>" 
						+ "<ProcessDefId>" + ProcessDefId + "</ProcessDefId>"
						+ "<LastModifiedTime></LastModifiedTime>" 
						+ "<ActivityType>" + ActivityType + "</ActivityType>" 
						+ "<complete>D</complete>" 
						+ "<AuditStatus></AuditStatus>"
						+ "<Comments></Comments>" 
						+ "<UserDefVarFlag>Y</UserDefVarFlag>" 
						+ "<Attributes>" + attributesTag + "</Attributes>" 
						+ "</WMAssignWorkItemAttributes_Input>";

				SAREmailReminderLog.EmailReminderLogger.debug("InputXML for assignWorkitemAttribute Call: " + assignWorkitemAttributeInputXML);

				String assignWorkitemAttributeOutputXML = CommonMethods.WFNGExecute(assignWorkitemAttributeInputXML, jtsIP, jtsPort, 1);

				SAREmailReminderLog.EmailReminderLogger.info("OutputXML for assignWorkitemAttribute Call: " + assignWorkitemAttributeOutputXML);

				XMLParser xmlParserWorkitemAttribute = new XMLParser(assignWorkitemAttributeOutputXML);
				String assignWorkitemAttributeMainCode = xmlParserWorkitemAttribute.getValueOf("MainCode");
				SAREmailReminderLog.EmailReminderLogger.info("AssignWorkitemAttribute MainCode: " + assignWorkitemAttributeMainCode);
				if("0".equalsIgnoreCase(assignWorkitemAttributeMainCode))
				{
					UpdateWIHistory(cabinetName,processInstanceID,entryDateTime,ActivityName);
				}
			}
		}
		catch(Exception e)
		{
			SAREmailReminderLog.EmailReminderLogger.info("Exception occured while complete workItem ..."+e.toString());
		}
	}
	private static String UpdateWIHistory(String cabinetName,String processInstanceID,String entryDateTime,String activityName)
	{
		try
			{
				sessionCheckInt=0;
				
				SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
				Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
				String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
				SAREmailReminderLog.EmailReminderLogger.info("FormattedEntryDatetime: "+formattedEntryDatetime);
	
				Date actionDateTime= new Date();
				String formattedActionDateTime=outputDateFormat.format(actionDateTime);
				SAREmailReminderLog.EmailReminderLogger.info("FormattedActionDateTime: "+formattedActionDateTime);
	
				//Insert in WIHistory Table.
	
				String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME";
				String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+activityName+"','"
				+CommonConnection.getUsername()+"','Discard','"+formattedEntryDatetime+"'";
				while(sessionCheckInt<loopCount)
				{
					String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,histTable);
					SAREmailReminderLog.EmailReminderLogger.info("APInsertInputXML: "+apInsertInputXML);
		
					String apInsertOutputXML = WFNGExecute(apInsertInputXML,jtsIP,jtsPort,1);
					SAREmailReminderLog.EmailReminderLogger.info("APInsertOutputXML: "+ apInsertOutputXML);
		
					XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
					String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
					SAREmailReminderLog.EmailReminderLogger.info("Status of apInsertMaincode  "+ apInsertMaincode);
					if(apInsertMaincode.equalsIgnoreCase("0"))
					{
						SAREmailReminderLog.EmailReminderLogger.info("ApInsert successful: "+apInsertMaincode);
						SAREmailReminderLog.EmailReminderLogger.info("Inserted in WiHistory table successfully.");
						return apInsertMaincode;
					}

					else
					{
						SAREmailReminderLog.EmailReminderLogger.error("ApInsert failed: "+apInsertMaincode);
					}
					if (apInsertMaincode.equalsIgnoreCase("11")) 
					{
						SAREmailReminderLog.EmailReminderLogger.info("Invalid session in historyCaller of UpdateExpiryDate");
						sessionCheckInt++;
						sessionID=CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, true);
						continue;
					}
					else
					{
						sessionCheckInt++;
						break;
					}
					
				}
				
			}

		catch(Exception e)
		{
			SAREmailReminderLog.EmailReminderLogger.error("Exception "+e);
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			SAREmailReminderLog.EmailReminderLogger.error("Exception Occurred in Updating History  : "+result);
			System.out.println("Exception "+e);
		
		}
		return "";
	}
	private String getFinanceMailID()
	{
		
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String RecordCount="";
		String FinanceMailID="";
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				String query="select usertype,emails from usr_0_sar_verifier_email_master with(nolock)";
				sInputXML = CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
				SAREmailReminderLog.EmailReminderLogger.info("Get email of BO and Finance inputXMl = "+sInputXML);
				sOutputXML = WFNGExecute(sInputXML, jtsIP, jtsPort, 0 );
				SAREmailReminderLog.EmailReminderLogger.info("Get email of BO and Finance OpXMl = "+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				String MaincodeTemp=objXMLParser.getValueOf("MainCode");
				SAREmailReminderLog.EmailReminderLogger.info("Get email of BO and Finance MainCode = "+MaincodeTemp);
				RecordCount=objXMLParser.getValueOf("TotalRetrieved");
				if("0".equalsIgnoreCase(MaincodeTemp) && RecordCount!=null && !"".equalsIgnoreCase(RecordCount) && Integer.parseInt(RecordCount)>0)
				{
					for(int i=0;i<Integer.parseInt(RecordCount);i++)
					{
						String xmlDataofRecord = objXMLParser.getNextValueOf("Record");
						xmlDataofRecord = xmlDataofRecord.replaceAll("[ ]+>", ">").replaceAll("<[ ]+", "<");
						XMLParser xmlParserExtTabDataRecord = new XMLParser(xmlDataofRecord);
						String userType = xmlParserExtTabDataRecord.getValueOf("usertype");
						/*if("BO".equalsIgnoreCase(userType))
							BOMailID=xmlParserExtTabDataRecord.getValueOf("emails");*/
						if("Finance".equalsIgnoreCase(userType))
							FinanceMailID=xmlParserExtTabDataRecord.getValueOf("emails");
						if("BO".equalsIgnoreCase(userType))
							BOMailID=xmlParserExtTabDataRecord.getValueOf("emails");
					}
				}
				if (MaincodeTemp.equalsIgnoreCase("11")) 
				{
					SAREmailReminderLog.EmailReminderLogger.info("Invalid session in getEmail Id");
					sessionCheckInt++;
					sessionID=CommonConnection.getSessionID(SAREmailReminderLog.EmailReminderLogger, true);
					continue;
				}
				else
				{
					sessionCheckInt++;
					break;
				}
			}
			catch(Exception e)
			{
				SAREmailReminderLog.EmailReminderLogger.error("Exception in getBOMailID...");
				return "";
			}
			
		}
		return FinanceMailID;
	}
	private static String getSubmissionMonth()
	{
		String strDate="";
		try
		{
			Calendar calendar = Calendar.getInstance();
			calendar.add(Calendar.MONTH, -1);
			String string = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(calendar.getTime());
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);//yyyy-MM-dd'T'HH:mm:ss.SSS'Z'("dd/MMM/yyyy", Locale.ENGLISH);
			Date date = format.parse(string);
			//System.out.println(date);
			DateFormat dateFormat = new SimpleDateFormat("MMM-yy");//("yyyy-M-d");  
            strDate = dateFormat.format(date);
           // System.out.println(strDate);
		}
		catch(Exception e)
		{
			//SARWICreationLog.SARWICreationLogger.info("Error in getSubmissionMonth..."+e.toString());
		}
		return strDate;
	}
}
	


