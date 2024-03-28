package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class CBP_FormLoad extends CBPCommon
{
	public String formLoadEvent(IFormReference iform, String controlName, String data)
	{
		String strReturn="";
		if("SolId".equals(controlName))
		{
			try {

				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT comment FROM PDBUser with (nolock) WHERE UserName='"+data+"'");
				for (List<String> row : lstDecision) {
					
						strReturn=row.get(0);
					
					
				}
				CBP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Sol Id on Load: "+strReturn);
				
			} catch (Exception e) {
				CBP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in SolId on load: " + e.getMessage());
			}
		}
		
		//Added by Sajan to check exception rights
		else if("DecisionDropDown".equals(controlName))
		{
			try {
				List lstDecisions = iform
					.getDataFromDB("SELECT DECISION FROM USR_0_CBP_DECISION_MASTER WITH(NOLOCK) WHERE WORKSTEP_NAME='"+iform.getActivityName()+"' and ISACTIVE='Y'");
				
				String value="";
				iform.clearCombo("DECISION");
				for(int i=0;i<lstDecisions.size();i++)
				{
					List<String> arr1=(List)lstDecisions.get(i);
					value=arr1.get(0);
					iform.addItemInCombo("DECISION",value,value);
				}
				
			} catch (Exception e) {
				CBP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Decision drop down load: " + e.getMessage());
			}
		}
		
		else if("on_Load_Entity".equals(controlName))
		{
			return new CBPIntegration().onLoadEvent(iform, controlName, data);
		}
		
		return strReturn;
	}
}