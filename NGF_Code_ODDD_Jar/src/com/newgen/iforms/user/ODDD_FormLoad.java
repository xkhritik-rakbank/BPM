package com.newgen.iforms.user;

import org.json.simple.JSONArray;
import java.util.List;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public class ODDD_FormLoad extends ODDD_Common
{
	
	public String formLoadEvent(IFormReference iform, String controlName,String event, String data)
	{
		String strReturn=""; 
	
		ODDD.mLogger.debug("This is ODDD_FormLoad_Event"+event+" controlName :"+controlName);
		
		String Workstep=iform.getActivityName();
		ODDD.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Workstep :"+Workstep);
		
		if("DecisionDropDown".equals(controlName))
		{
			try {				
				List lstDecisions = iform
					.getDataFromDB("SELECT DECISION FROM USR_0_ODDD_DECISION_MASTER WITH(NOLOCK) WHERE WORKSTEP_NAME='"+iform.getActivityName()+"' and ISACTIVE='Y' ORDER BY DECISION ASC");
				
				String value="";
				iform.clearCombo("DECISION");
				for(int i=0;i<lstDecisions.size();i++)
				{
					List<String> arr1=(List)lstDecisions.get(i);
					value=arr1.get(0);
					iform.addItemInCombo("DECISION",value,value);
					strReturn="Decision Loaded";
				}
				
			} catch (Exception e) {
				ODDD.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in Decision drop down load " + e.getMessage());
			}
		}
		
		return strReturn;
	}
}
