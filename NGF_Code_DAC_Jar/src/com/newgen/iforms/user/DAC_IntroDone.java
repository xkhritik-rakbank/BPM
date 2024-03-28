package com.newgen.iforms.user;

import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.json.simple.JSONArray;
import java.util.List;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;

public class DAC_IntroDone extends DACCommon {
	public String onIntroduceDone(IFormReference iform, String controlName, String event, String data) {
		String strReturn = "";
		DAC.mLogger.debug("This is DAC_IntroDone_Event");
		if ("InsertIntoHistory".equals(controlName)) {
			try {
				DAC.mLogger.debug("Reject Reasons Grid Length is " + data);
				String strRejectReasons = "";
				String strRejectCodes = "";
				for (int p = 0; p < Integer.parseInt(data); p++) {
					/*if (strRejectReasons == "")
						strRejectReasons = iform.getTableCellValue("REJECT_REASON_GRID", p, 0);
					else
						strRejectReasons = strRejectReasons + "#" + iform.getTableCellValue("REJECT_REASON_GRID", p, 0);*/
					
					String completeReason = null;
					completeReason = iform.getTableCellValue("REJECT_REASON_GRID", p, 0);
					DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Complete Reject Reasons" + completeReason);
					
					if (strRejectReasons == "")
					{						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=completeReason.substring(completeReason.indexOf("-")+1);
							DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=completeReason;
							DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons else block" + strRejectReasons);
						}
					}	
					else
					{
						DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons 1" + strRejectReasons);						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=strRejectCodes+"#"+completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=strRejectReasons+"#"+completeReason.substring(completeReason.indexOf("-")+1);
							DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=strRejectReasons+"#"+completeReason;
							DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons else block2" + strRejectReasons);
						}
						
						DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons 2" + strRejectReasons);
					}
					
				}

				DAC.mLogger.debug("Final reject reasons are " + strRejectReasons);
				JSONArray jsonArray = new JSONArray();
				JSONObject obj = new JSONObject();
				Calendar cal = Calendar.getInstance();
				// SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String strDate = sdf.format(cal.getTime());

				DAC.mLogger.debug("strDate " + strDate);
				obj.put("Date Time", strDate);
				obj.put("Workstep", iform.getActivityName());
				obj.put("User Name", iform.getUserName());
				obj.put("Decision", iform.getValue("DECISION"));
				obj.put("Reject Reasons", strRejectReasons);
				obj.put("Reject Reason Codes", strRejectCodes);
				obj.put("Remarks", iform.getValue("REMARKS"));

				DAC.mLogger.debug("Decision" + iform.getValue("DECISION"));

				DAC.mLogger.debug("Created Date Time" + iform.getValue("CreatedDateTime"));
				DAC.mLogger.debug("Entry Date Time" + iform.getValue("EntryDateTime"));
				String entryDateTime = ""; 
				if ("Initiation".equalsIgnoreCase(iform.getActivityName()))
				{
					obj.put("Entry Date Time", iform.getValue("CreatedDateTime"));
					entryDateTime = iform.getValue("CreatedDateTime").toString();
				}else
				{
					obj.put("Entry Date Time", iform.getValue("EntryDateTime"));
					entryDateTime = iform.getValue("EntryDateTime").toString();
				}
					jsonArray.add(obj);
				
				iform.addDataToGrid("Q_USR_0_DAC_WIHISTORY", jsonArray);

				//String insertStatus = UpdateWIHistory((String)iform.getValue("DECISION"),(String)iform.getValue("REMARKS"),strRejectReasons,strRejectCodes,entryDateTime,"USR_0_DAC_WIHISTORY",iform);
				//DAC.mLogger.info("WI history ap insert status:-"+insertStatus);
				//if("0".equalsIgnoreCase(insertStatus))
				strReturn = "INSERTED";
				
				DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Added Successfully!");
			} catch (Exception e) {
				DAC.mLogger.debug("Exception in WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Not Added Successfully!" + e.getMessage());
			}
		}
		if("validateDecHitoryGridCountWithDatabase".equalsIgnoreCase(controlName))
		{
			int historyGridFrontendSize = iform.getDataFromGrid("Q_USR_0_DAC_WIHISTORY").size();
			int historyGridBackendSize = 0;
			String query = "SELECT count(*) FROM USR_0_DAC_WIHISTORY WITH(NOLOCK) WHERE WI_NAME = '"+getWorkitemName()+"'";
			DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", query-"+query);
			
			List<List<String>> lstDecision = iform.getDataFromDB(query);
			for (List<String> row : lstDecision) {
				historyGridBackendSize=Integer.parseInt(row.get(0));
			}
			
			DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", historyGridFrontendSize-"+historyGridFrontendSize);
			DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", historyGridBackendSize-"+historyGridBackendSize);
			
			if(historyGridFrontendSize == historyGridBackendSize)
				strReturn="Count Matched";
			else 
				strReturn="Count Not Matched";
			
			DAC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", strReturn-"+strReturn);
		}
		return strReturn;
	}
}