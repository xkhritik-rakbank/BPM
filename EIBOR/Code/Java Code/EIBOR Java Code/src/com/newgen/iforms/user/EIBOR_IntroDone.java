package com.newgen.iforms.user;


import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;


public class EIBOR_IntroDone extends EIBOR_Common
{
	public String onIntroduceDone(IFormReference iform, String controlName,String event, String data)
	{
		String strReturn="";
		EIBOR.mLogger.debug("This is EIBOR_IntroDone_Event");
		if("email".equals(controlName)){
			try{
				EIBOR.mLogger.debug("INSERT EMAIL : Try ");
				String value =email(iform);
				if(value.equalsIgnoreCase("true")){
					return "true-mail SMS triggered successfully";
				}
				return "false some error in triggering mail sms service";
								
			}
			catch(Exception e){
				EIBOR.mLogger.debug("Exception in Email Trigger!" + e.getMessage());
			}
		}
		if("InsertIntoHistory".equals(controlName))
		{
			try {

				EIBOR.mLogger.debug("InsertIntoHistory : Try ");
				
				JSONArray jsonArray=new JSONArray();
				JSONObject obj=new JSONObject();
				
				           
				
				
				Calendar cal = Calendar.getInstance();  
				Date d = new Date();
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String strDate = dateFormat.format(cal.getTime());
			    
			    EIBOR.mLogger.debug("strDate: " +strDate);
			    EIBOR.mLogger.debug("entry_date_time: " +iform.getValue("EntryDateTime"));
			    
			    String entrydatetime = (String) iform.getValue("EntryDateTime");
			    Date d1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(entrydatetime);
			    String entrydatetime_format = dateFormat.format(d1);
			   
			    EIBOR.mLogger.debug("getClass EntryDateTime : " +iform.getValue("EntryDateTime").getClass().getName());
			    
				obj.put("ENTRY DATE TIME",entrydatetime_format);
				obj.put("WORKSTEP",iform.getActivityName());
				obj.put("USER NAME", iform.getUserName());
				obj.put("DECISION",iform.getValue("Decision"));
				obj.put("REMARKS", iform.getValue("Remarks"));
				obj.put("ACTION DATE TIME",strDate);
				
				
				
				EIBOR.mLogger.debug("Decision: " +iform.getValue("Decision"));
				EIBOR.mLogger.debug("Remarks: " +iform.getValue("Remarks"));
				EIBOR.mLogger.debug("rejectReason: " +iform.getValue("rejectReason"));
				
				jsonArray.add(obj);
				iform.addDataToGrid("NG_EIBOR_GRID_DECISION_HIST", jsonArray);
				
				
				EIBOR.mLogger.debug("jsonArray : "+jsonArray);
				strReturn = "INSERTED";
				
				EIBOR.mLogger.debug("WINAME: "+getWorkitemName(iform)+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Added Successfully!");
				iform.setValue("Remarks","");
			} 
			catch (Exception e) {
				EIBOR.mLogger.debug("Exception in inserting WI History!" + e.getMessage());
			}
		}
		
		
		return strReturn;
	}
	
	public static String email(IFormReference iform)
	{
		EIBOR.mLogger.info("--");
		String wiName = null;
		String activityName = null;
		String abc = "abc";
		
		try 
		{	
			Date d = new Date();
			SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MMM-yyyy");
			String currentdate = dateFormat.format(d);
			wiName = ((iform).getObjGeneralData()).getM_strProcessInstanceId();; 
			activityName = iform.getActivityName();
			
			
			
			String arr[][] = new String[10][13];
			String l ="0";
			int p;
			String gridValue ="100";
			int intGridValue;
			String total = abc+l;
			String totalgrid = abc+gridValue;
			
			
			
			String queryEiborSummary = "SELECT * FROM NG_EIBOR_GRID_FINAL_SUMMARY where WINAME ='"+wiName+"'";
			List<List<String>> dataFromDB1 = iform.getDataFromDB(queryEiborSummary);
			if(dataFromDB1.size()>0){
				for(int i=0;i<6;i++){
					for(int j=0;j<11;j++){
						arr[i][j] = iform.getTableCellValue("NG_EIBOR_GRID_FINAL_SUMMARY",i,j);
					}
				}
				
				
				
				String email = "test11@rakbanktst.ae";
				String query = "Select * from NG_EIBOR_TEMPLATEMAPPING";
				List<List<String>> dataFromDB = iform.getDataFromDB(query);
				
				if(dataFromDB.size()>0){
					String emailBody = dataFromDB.get(0).get(1);
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName + "email Body before replace-----"+emailBody);
					emailBody = emailBody.replaceAll("#WI_No.#",wiName);
					emailBody = emailBody.replaceAll("#Date#",currentdate);					
					for(int m=0;m<6;m++){  //m is row number and n is column number
						emailBody = emailBody.replaceFirst("##", arr[m][8]);
						emailBody = emailBody.replaceFirst("###", arr[m][9]);
						emailBody = emailBody.replaceFirst("abc0", arr[m][1]);
						emailBody = emailBody.replaceFirst("abc1", arr[m][2]);
						emailBody = emailBody.replaceFirst("abc2", arr[m][3]);
						emailBody = emailBody.replaceFirst("abc3", arr[m][4]);
						emailBody = emailBody.replaceFirst("abc4", arr[m][5]);
						emailBody = emailBody.replaceFirst("abc5", arr[m][6]);
						emailBody = emailBody.replaceFirst("abc6", arr[m][7]);
						emailBody = emailBody.replaceFirst("abc7", arr[m][8]);
						emailBody = emailBody.replaceFirst("abc8", arr[m][9]);
						emailBody = emailBody.replaceFirst("abc9", arr[m][10]);
						
														
					}
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +"email Body after replace-----"+emailBody);
					String mailFrom = dataFromDB.get(0).get(2);
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName + "mailFrom-----"+mailFrom);
					String mailTo = email;
					String mailSubject = dataFromDB.get(0).get(4);
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName + "mailSubject before replace-----"+mailSubject);
					mailSubject = mailSubject.replaceAll("#Date#", currentdate);
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName + "mailSubject after replace-----"+mailSubject);
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
							+iform.getUserName()+"','"+mailActionType+"','"+wiName+"','"+workitemid+"','"+activityID+"','"+noOfTrials+"')";
					String mailInsertQuery = "Insert into " +tableName+" "+columnName+" values "+values;
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName+ "mailInsertQuery-----"+mailInsertQuery);
					int status = iform.saveDataInDB(mailInsertQuery);
					EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +"status----->"+status);
					if(status==1)
						return "true";
				}
				EIBOR.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName+"EXITING MAILTRIGGER METHOD");
		
			}
			
		}
			
		catch (Exception e)
		{
			
		}
		return "";
	}
}