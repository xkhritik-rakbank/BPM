package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class CMP_IntroDone extends CMPCommon
{
	public String onIntroduceDone(IFormReference iformObj, String control,String stringdata)
	{
		// TODO Auto-generated method stub
		String strReturn="";
		CMP.mLogger.debug("This is PC_IntroDone of CMP 1");
		if("InsertIntoHistory".equals(control))
		{
			try {
				CMP.mLogger.debug("Reject Reasons Grid Length is "+stringdata);
				String strRejectReasons="";
				String strRejectCodes = "";
				for(int p=0;p<Integer.parseInt(stringdata);p++)
				{
					/*if(strRejectReasons=="")
						strRejectReasons=iformObj.getTableCellValue("REJECT_REASON_GRID",p,0);
					else
						strRejectReasons=strRejectReasons+"#"+iformObj.getTableCellValue("REJECT_REASON_GRID",p,0);*/
					
					String completeReason = null;
					completeReason = iformObj.getTableCellValue("REJECT_REASON_GRID", p, 0);
					CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Complete Reject Reasons" + completeReason);
					
					if (strRejectReasons == "")
					{						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=completeReason.substring(completeReason.indexOf("-")+1);
							CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=completeReason;
							CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons else block" + strRejectReasons);
						}
					}	
					else
					{
						CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons 1" + strRejectReasons);						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=strRejectCodes+"#"+completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=strRejectReasons+"#"+completeReason.substring(completeReason.indexOf("-")+1);
							CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=strRejectReasons+"#"+completeReason;
							CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons else block2" + strRejectReasons);
						}
						
						CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", Reject Reasons 2" + strRejectReasons);
					}
					
				}  
				CMP.mLogger.debug("Final reject reasons are "+strRejectReasons);  
			
				JSONArray jsonArray=new JSONArray();
				JSONObject obj=new JSONObject();
				Calendar cal = Calendar.getInstance();
	
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    String strDate = sdf.format(cal.getTime());
				obj.put("Date Time",strDate);
				obj.put("Decision",iformObj.getValue("DECISION"));
				obj.put("Reject Reasons", strRejectReasons);
				obj.put("Reject Reason Codes", strRejectCodes);
				obj.put("Remarks", iformObj.getValue("REMARKS"));
				obj.put("User Name", iformObj.getUserName());
				obj.put("Workstep",iformObj.getActivityName());
				
				if("Initiation".equals(iformObj.getActivityName()))
					obj.put("Entry Date Time",iformObj.getValue("CreatedDateTime"));
				else
					obj.put("Entry Date Time",iformObj.getValue("EntryDateTime"));
				jsonArray.add(obj);
				iformObj.addDataToGrid("Q_USR_0_CMP_WIHISTORY", jsonArray);
				
				strReturn = "INSERTED";
				CMP.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", WI Histroy Added Successfully!");
			} catch (Exception e) {
				CMP.mLogger.debug("Exception in WINAME: "+getWorkitemName()+", WSNAME: "+iformObj.getActivityName()+", ControlName: "+control+", WI Histroy Not Added Successfully!" + e.getMessage());
			}
		}
		return strReturn;
	}
}
