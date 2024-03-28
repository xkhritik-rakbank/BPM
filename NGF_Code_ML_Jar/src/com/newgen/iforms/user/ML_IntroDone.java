package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class ML_IntroDone extends MLCommon {
	public String onIntroduceDone(IFormReference iform,String controlName,String data)
	{
		String strRetrun = "";
		if("InsertIntoHistory".equals(controlName))
		{
			try {
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons Grid Length is: "+data);
				String strRejectReasons="";
				String strRejectCodes = "";
				for (int p = 0; p < Integer.parseInt(data); p++) 
				{
					String completeReason = null;
					completeReason = iform.getTableCellValue("REJECT_REASON_GRID", p, 0);
					ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Complete Reject Reasons" + completeReason);
					
					if (strRejectReasons == "")
					{						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=completeReason.substring(completeReason.indexOf("-")+1);
							ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=completeReason;
							ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons else block" + strRejectReasons);
						}
					}	
					else
					{
						ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons 1" + strRejectReasons);						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=strRejectCodes+"#"+completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=strRejectReasons+"#"+completeReason.substring(completeReason.indexOf("-")+1);
							ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=strRejectReasons+"#"+completeReason;
							ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons else block2" + strRejectReasons);
						}
						
						ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons 2" + strRejectReasons);
					}
				}
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final reject reasons are: "+strRejectReasons);
				JSONArray jsonArray=new JSONArray();
				JSONObject obj=new JSONObject();
				Calendar cal = Calendar.getInstance();
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    String strDate = sdf.format(cal.getTime());
			    ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final date for history is: "+strDate);
				obj.put("Date Time",strDate);
				obj.put("Workstep",iform.getActivityName());
				obj.put("User Name", iform.getUserName());
				obj.put("Decision",iform.getValue("qDecision"));
				obj.put("Remarks", iform.getValue("REMARKS"));
				obj.put("Reject Reasons", strRejectReasons);
				obj.put("Reject Reason Codes", strRejectCodes);
				if("Introduction".equals(iform.getActivityName()))
					obj.put("Entry Date Time",iform.getValue("CreatedDateTime"));
				else
					obj.put("Entry Date Time",iform.getValue("EntryDateTime"));
				jsonArray.add(obj);
				iform.addDataToGrid("Q_USR_0_ML_WIHISTORY", jsonArray);
				strRetrun = "INSERTED";
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", WI History grid:::" + jsonArray.toJSONString());
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Added Successfully! "+strRetrun);
				
			} catch (Exception e) {
				ML.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in check if system Check Required non borrowing: " + e.getMessage());
			}
		}
		return strRetrun;
	}
}	
