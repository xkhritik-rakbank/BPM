package com.newgen.iforms.user;

import com.newgen.iforms.custom.IFormReference;

public class OnChange {
	
	private String WIName = null;
	private String activityName = null;

	public  String OnChangeEvent(IFormReference iformObj, String controlName, String data)
	{
		try {
			WIName = NBTL_CommonMethods.getWorkitemName(iformObj);
			activityName = iformObj.getActivityName();
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+controlName+" Inside OnChangeEvent...info");

		if(controlName.equalsIgnoreCase("Decision")) 
		{
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+controlName+" Inside decision...info");
			String Decision = (String) iformObj.getValue("Decision");
			NBTL_CommonMethods.OnDecisionChange(iformObj, Decision,data);
		}
		else if(controlName.equalsIgnoreCase("PC_Change")) 
		{
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+controlName+" Inside PC_Change...info");
			iformObj.setStyle("Remarks","visible","false");
			iformObj.setValue("Remarks", "");
			iformObj.setStyle("DiscardReason","disable","true");
			iformObj.setValue("DiscardReason", "");
			NBTL_CommonMethods.loadDecision(iformObj,data);
			
		}
		}
		catch (Exception e){
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+WIName +" control-->"+controlName+ e);
			}
		return "";
	}
}
