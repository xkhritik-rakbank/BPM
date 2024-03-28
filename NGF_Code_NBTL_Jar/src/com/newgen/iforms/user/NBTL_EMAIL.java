package com.newgen.iforms.user;

import java.util.List;

import com.newgen.iforms.custom.IFormReference;

public class NBTL_EMAIL {
	
	private static String wiName = null;
	private static String activityName = null;
	
	public static String EmailTrigger(IFormReference ifr,String stage)
	{
		try{
			wiName = NBTL_CommonMethods.getWorkitemName(ifr);
			activityName = ifr.getActivityName();
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+"inside EmailTrigger Method-----");
			String email = (String)ifr.getValue("EmailAddress");
			String query = "Select * from USR_0_NBTL_TEMPLATEMAPPING WHERE TemplateType = '"+stage+"'";
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+"query-----"+query);
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "dataFromDB-----"+dataFromDB);
			if(dataFromDB.size()>0){
				String emailBody = dataFromDB.get(0).get(2);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "email Body before replace-----"+emailBody);
				emailBody = emailBody.replaceAll("#WI_No#",wiName);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+"email Body after replace-----"+emailBody);
				String mailFrom = dataFromDB.get(0).get(3);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "mailFrom-----"+mailFrom);
				String mailTo = email;//"test11@rakbanktst.ae";
				String mailSubject = dataFromDB.get(0).get(6);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "mailSubject before replace-----"+mailSubject);
				mailSubject = mailSubject.replaceAll("WI_No", wiName);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "mailSubject after replace-----"+mailSubject);
				String mailContentType = "text/html;charset=UTF-8";
				int mailPriority = 1;
				int activityID = 3;
				int workitemid = 1;
				int noOfTrials = 0;
				String mailStatus = "N";
				String mailActionType = "TRIGGER";
				String tableName = "WFMAILQUEUETABLE";
				String columnName = "(mailFrom,mailTo,mailSubject,mailMessage,mailContentType,mailPriority,mailStatus,insertedBy,"
						+ "mailActionType,processInstanceId,workitemId,activityId,noOfTrials)";
				String values = "('"+mailFrom+"','"+mailTo+"','"+mailSubject+"',N'"+emailBody+"','"+mailContentType+"','"+mailPriority+"','"+mailStatus+"','"
						+ifr.getUserName()+"','"+mailActionType+"','"+wiName+"','"+workitemid+"','"+activityID+"','"+noOfTrials+"')";
				String mailInsertQuery = "Insert into " +tableName+" "+columnName+" values "+values;
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "mailInsertQuery-----"+mailInsertQuery);
				int status = ifr.saveDataInDB(mailInsertQuery);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "status----->"+status);
				if(status==1)
					return "true";
			}
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+"EXITING MAILTRIGGER METHOD");
		}catch(Exception e){
			NBTL.mLogger.info(e);
		}
		return "false";
	}
	
	public static String SMSTrigger(IFormReference ifr,String stage)
	{
		try{
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "inside SMSTrigger Method-----");
			String wiName = NBTL_CommonMethods.getWorkitemName(ifr);
			String smsLang = "EN";
			String query = "Select * from USR_0_NBTL_TEMPLATEMAPPING WHERE TemplateType = '"+stage+"'";
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+"query-----"+query);
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "dataFromDB-----"+dataFromDB);
			if(dataFromDB.size()>0){
				String txtMessage = dataFromDB.get(0).get(5);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "txtMessage before replace-----"+txtMessage);
				txtMessage = txtMessage.replaceAll("#WI_No#",wiName);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "txtMessage after replace-----"+txtMessage);
				String AlertName = stage;
				String AlertCode = "NBTL";
				String AlertStatus = "P";
				String AlertSubject = "Communication";
				String mobileNo = (String) ifr.getValue("MobileNo");
				String tableName = "USR_0_BPM_SMSQUEUETABLE";//USR_0_BPM_SMSQUEUETABLE
				String activityName = ifr.getActivityName();
				String columnName = "(ALERT_Name,Alert_Code,Alert_Status,Mobile_No,Alert_Text,Alert_Subject,WI_Name,Workstep_Name,Inserted_Date)";
				String values = "('"+AlertName+"','"+AlertCode+"','"+AlertStatus+"','"+mobileNo+"','"+txtMessage+"','"+AlertSubject+"','"+wiName+"','"+activityName+"',getdate() )";
				String SMSInsertQuery = "Insert into " +tableName+" "+columnName+" values "+values;
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "SMSInsertQuery-----"+SMSInsertQuery);
				int status = ifr.saveDataInDB(SMSInsertQuery);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "status----->"+status);
				if(status==1)
					return "true";
			}
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" stage-->"+stage+ "EXITING SMSTRIGGER METHOD");
		}catch(Exception e){
			NBTL.mLogger.info(e);
		}
		return "false";
	}
}
