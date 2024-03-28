package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;

public class CMP_FormLoad extends CMPCommon
{
	public String formLoadEvent(IFormReference iform, String controlName,
			String data) {
		// TODO Auto-generated method stub
		String strReturn="";
		CMP.mLogger.debug("formLoadEvent -- controlName :"+controlName);
		String Workstep=iform.getActivityName();
		CMP.mLogger.debug("Workstep :"+Workstep);
	    if("DecisionDropDown".equals(controlName))
		{
			try {				
				String abc="";
				List lstDecisions = iform
					.getDataFromDB("SELECT DECISION FROM USR_0_CMP_DECISION_MASTER WHERE WORKSTEP_NAME='"+iform.getActivityName()+"' and ISACTIVE='Y'");
				
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
				CMP.mLogger.debug("Exception in Decision drop down load " + e.getMessage());
			}
		}
		else if("SolId".equals(controlName))
		{
			try {
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT comment FROM PDBUser with (nolock) WHERE UserName='"+data+"'");
				for (List<String> row : lstDecision) {					
						strReturn=row.get(0);					
				}
				CMP.mLogger.debug("return for Sol Id on Load "+strReturn);
				
			} catch (Exception e) {
				CMP.mLogger.debug("Exception in SolId on load " + e.getMessage());
			}
		}
		return strReturn;
	}
}