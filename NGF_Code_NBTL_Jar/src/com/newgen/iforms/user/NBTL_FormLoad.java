package com.newgen.iforms.user;

import java.time.LocalDate;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;


public class NBTL_FormLoad {
	
	private String WI_Name = null;
	private String userName = null;
	private String activityName = null;
	private IFormReference giformObj = null;
	
	public String formLoad(IFormReference iformObj, String control, String data)	{
		NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+"Inside FormLoad...info");
		WI_Name = getWorkitemName(iformObj);
		userName = iformObj.getUserName();
		activityName = iformObj.getActivityName();
		NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control);
		NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control +"Data from JS----->"+data);
		String[] arr = data.split("-");
		String rownumber = arr[0];
		String previousTLAttach = arr[1];
		String response = "";
		giformObj = iformObj;
		try {
			if("OPS_Review".equalsIgnoreCase(activityName)) {
				NBTL_CommonMethods.checkboxFieldsValidations(iformObj);
				String ToBeExpiryDate = (String) iformObj.getValue("ToBeExpiryDate");
				String expiryDate[] = ToBeExpiryDate.split(" ");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control +"ToBeExpiryDate--------- "+ToBeExpiryDate);
				
				if("YES".equalsIgnoreCase(previousTLAttach)||"Y".equalsIgnoreCase(previousTLAttach))
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+"-----on formload trying to attach previous year TL------");
					response = NBTL_CommonMethods.getOldTL(iformObj);
				}
				
				LocalDate date = LocalDate.parse(expiryDate[0]);
		        int year = date.getYear();
		        NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+"year--------- "+year);
		        if( year > 2040) {
		        	iformObj.setValue("TLExpiryDatePCReqCheckbox","false");
		        	iformObj.setStyle("TLExpiryDatePCReqCheckbox","disable","true");
		        	NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+"Checkbox disabled");
		        }
			}
			NBTL_CommonMethods.loadDecision(iformObj,rownumber);
			if (response.indexOf("~") != -1)
				return response;
		}
		catch (Exception e){
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WI_Name +" control-->"+control+e);
			}
		return "";
	}
	 public String getWorkitemName(IFormReference iformObj) {
	        return ((iformObj).getObjGeneralData()).getM_strProcessInstanceId();
	    }

}
