package com.newgen.iforms.user;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;
//import com.newgen.json.JSONArray;

public  class NBTL_IntroDone {
	
	private String WIName = null;
	private String activityName = null;
	
	public  String onIntroDone(IFormReference ifr, String control,String data)
	{
		try
		{
			WIName = NBTL_CommonMethods.getWorkitemName(ifr);
			activityName = ifr.getActivityName();
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"inside intro done setting decision history");
			String user = ifr.getUserName();
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"user---"+user);
			String remarks = (String)ifr.getValue("Remarks");
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"remarks---"+remarks);
			String decision = (String)ifr.getValue("Decision");
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"decision---"+decision);
			String query = "INSERT INTO USR_0_NBTL_WIHISTORY (WINAME,WORKSTEP,DECISION,USER_NAME,ENTRY_DATE_TIME,ACTION_DATE_TIME,REMARKS) VALUES ('"+WIName+"','"+activityName+"','"+decision+"','"+user+"',GETDATE(),GETDATE(),'"+remarks+"')";
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"query is---"+query);
			ifr.saveDataInDB(query);
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"data added to history grid");
		
			if(ifr.getActivityName().equalsIgnoreCase("OPS_Review"))
			{
				
				//-----for routing--------------
				boolean flag = false;
				String shareHolderName = "false";
				String ToBeExpiryDate = (String) ifr.getValue("ToBeExpiryDate");
				String expiryDate[] = ToBeExpiryDate.split(" ");
				LocalDate date = LocalDate.parse(expiryDate[0]);
		        int year = date.getYear();
				String companyName = (String) ifr.getValue("CompanyNamePCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"companyNamecheckbox"+companyName);
				/*String TLNumber = (String) ifr.getValue("TLNoPCReqCheckbox");
				NBTL.mLogger.info("TLNumbercheckbox"+companyName);*/
				String CompanyLegalStatus = (String) ifr.getValue("CompanyLegalStatusPCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"CompanyLegalStatuscheckbox"+CompanyLegalStatus);
				String TLExpiry = (String) ifr.getValue("TLExpiryDatePCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"TLExpiryDatePCReqCheckbox"+TLExpiry);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"data"+data);
				int rowCount = Integer.parseInt(data);
				
				for(int i=0;i<rowCount;i++)
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"inside ops route loop");
					shareHolderName = ifr.getTableCellValue("ShareholderGrid",i,5);
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"inside  if ops route loop shareholder   ---->"+shareHolderName);
					if(shareHolderName.equalsIgnoreCase("true"))
					{
						NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"inside  if ops route loop");
						ifr.setValue("ShareholderPCChanged","Yes");
						flag = true;
						break;
					}
				}
				
				if("false".equalsIgnoreCase(companyName) && "false".equalsIgnoreCase(CompanyLegalStatus) && "false".equalsIgnoreCase(TLExpiry) && flag == false)
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"satisfying route condition");
					ifr.setValue("OPSRoute", "Y");
				}
			ifr.setValue("PrevOPSReviewDec", decision);
			if(decision.equalsIgnoreCase("Approve with Profile Change"))
			{
				ifr.setValue("Memopad", "Renewed TL updated with Profile Change noted. Supporting documents pending");
			}
			
			if("false".equalsIgnoreCase(companyName) && "false".equalsIgnoreCase(CompanyLegalStatus)  && flag == false && year >= 2040)
			{
				ifr.setValue("OnlyExpiryDateChange", "Y");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"OnlyExpiryDateChange set to <------>Y<--------->");
			}
			}
		
		//------Customer communication starts--------------------------------------------------------//
		NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"--------------Customer communication start--------");
		String stage = "";
		NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"decision---"+decision);
		if(ifr.getActivityName().equalsIgnoreCase("OPS_Review"))
		{
			if(decision.equalsIgnoreCase("Approve"))
			{
				String companyName = (String) ifr.getValue("CompanyNamePCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"companyNamecheckbox"+companyName);
				/*String TLNumber = (String) ifr.getValue("TLNoPCReqCheckbox");
				NBTL.mLogger.info("TLNumbercheckbox"+companyName);*/
				String CompanyLegalStatus = (String) ifr.getValue("CompanyLegalStatusPCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"CompanyLegalStatuscheckbox"+CompanyLegalStatus);
				String TLExpiry = (String) ifr.getValue("TLExpiryDatePCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"TLExpiryDatePCReqCheckbox"+TLExpiry);
				if(companyName.equalsIgnoreCase("false") && CompanyLegalStatus.equalsIgnoreCase("false") && TLExpiry.equalsIgnoreCase("false"))
				{
					stage = "";
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"Stage------> No mail to be sent as no parameter checked");
				}
				else
				{
					stage = "Approved";
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"stage--->"+stage);
				}
			}
			else if(decision.equalsIgnoreCase("Approve with Profile Change"))
			{
				stage = "Approved with Profile Change";
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"stage---"+stage);
			}
			else if(decision.equalsIgnoreCase("Discard"))
			{
				stage = "Discard";
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+"stage---"+stage);
			}
		}
		
		if(!(stage.equalsIgnoreCase("")))
			{
				String mailRes = NBTL_EMAIL.EmailTrigger(ifr, stage);
				String SMSRes = NBTL_EMAIL.SMSTrigger(ifr, stage);
				if(mailRes.equalsIgnoreCase("true") && SMSRes.equalsIgnoreCase("true")){
					return "true-mail SMS triggered successfully";
				}
				return "false some error in triggering mail sms service";
			}
		//--------customer communication ends-----------------------------------------------//
		}
		catch(Exception e)
		{
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+control+ e);
		}
		return "";
	}
}
