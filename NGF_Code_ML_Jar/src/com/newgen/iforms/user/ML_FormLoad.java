package com.newgen.iforms.user;

import java.util.List;

import com.newgen.iforms.custom.IFormReference;

public class ML_FormLoad extends MLCommon{
	
	public String formLoadEvent(IFormReference iform, String controlName, String data)
	{
		String strReturn="";
		if("SolId".equals(controlName))
		{
			try {

				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT comment FROM PDBUser with (nolock) WHERE UserName='"+iform.getUserName()+"'");
				for (List<String> row : lstDecision) {
					
						strReturn=row.get(0);
						ML.mLogger.debug("Sol Id is "+strReturn);
					
				}
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Sol Id on Load: "+strReturn);
				
			} catch (Exception e) {
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in SolId on load: " + e.getMessage());
			}
		}
		
		else if("DecisionDropDown".equals(controlName))
		{
			try {
				List lstDecisions = iform
					.getDataFromDB("SELECT DECISION FROM USR_0_ML_DECISION_MASTER WITH(NOLOCK) WHERE WORKSTEP_NAME='"+iform.getActivityName()+"' and ISACTIVE='Y'");
				
				String value="";
				iform.clearCombo("qDecision");
				for(int i=0;i<lstDecisions.size();i++)
				{
					List<String> arr1=(List)lstDecisions.get(i);
					value=arr1.get(0);
					ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Decsion value is : "+value + "for workstep is"+iform.getActivityName());
					iform.addItemInCombo("qDecision",value,value);
				}
				
			} catch (Exception e) {
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Decision drop down load: " + e.getMessage());
			}
		}
		else if("getActivityNameBasedOnWorkitemId".equals(controlName))
		{
			try {
				if("Credit".equalsIgnoreCase(iform.getActivityName()))
					data = "3";
				if("CPV".equalsIgnoreCase(iform.getActivityName()))
					data = "2";
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT TOP 1 ACTIVITYNAME FROM QUEUEVIEW WITH(NOLOCK) WHERE PROCESSNAME='ML' AND PROCESSINSTANCEID='"+getWorkitemName()+"' AND WORKITEMID='"+data+"' ");
				
				for (List<String> row : lstDecision) {
					strReturn=row.get(0);
					ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Return: "+strReturn);
				
				}
				
			} catch (Exception e) {
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Decision drop down load: " + e.getMessage());
			}
		}
		return strReturn;
	}
}	
