package com.newgen.iforms.user;

import java.util.Calendar;
import java.util.List;
import java.text.SimpleDateFormat;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;

public class ODDD_IntroDone extends ODDD_Common
{
	public String onIntroduceDone(IFormReference iform, String controlName,String event, String data)
	{
		String strReturn="";
		ODDD.mLogger.debug("This is ODDD_IntroDone_Event");
		if("InsertIntoHistory".equals(controlName))
		{
			try {
				
				/*String EntryDateTime = iform.getValue("EntryDateTime").toString();
				String newEntryDateTime="";
				if(!EntryDateTime.equals(""))
				{
					String[] a = EntryDateTime.split(" ");
					String[] d = a[0].split("-");
					String[] t = a[1].split(":");
					
					//Added for handling month***************
					String[] month_array={"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
					String[] Integer_array={"01","02","03","04","05","06","07","08","09","10","11","12"};
					for (int z=0;z<month_array.length;z++)
					{
						if(d[1].indexOf(month_array[z]) != -1)
							d[1]=Integer_array[z];
					}
					//************************************
					
					newEntryDateTime=d[2]+'/'+d[1]+'/'+d[0]+' '+t[0]+':'+t[1]+':'+t[2];
					
				}*/
				
				//ODDD.mLogger.debug("Final reject reasons are "+strRejectReasons);
				JSONArray jsonArray=new JSONArray();
				JSONObject obj=new JSONObject();
				Calendar cal = Calendar.getInstance();
			   // SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");			   
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    String strDate = sdf.format(cal.getTime());
			    
				obj.put("Date Time",strDate);
				obj.put("Workstep",iform.getActivityName());
				obj.put("User Name", iform.getUserName());
				obj.put("Decision",iform.getValue("DECISION"));
				//obj.put("Reject Reasons", strRejectReasons);
				//obj.put("Reject Reason Codes", strRejectCodes);
				obj.put("Reject Reasons", iform.getValue("REJECT_REASONS"));
				obj.put("Reject Reasons Codes", iform.getValue("REJECT_REASONS_CODES"));
				obj.put("Remarks", iform.getValue("REMARKS"));
				
			
				ODDD.mLogger.debug("Decision" +iform.getValue("DECISION"));
				
				if("Initiation".equalsIgnoreCase(iform.getActivityName()))
					obj.put("Entry Date Time",iform.getValue("CreatedDateTime"));
				else
					obj.put("Entry Date Time", iform.getValue("EntryDateTime"));
				
				ODDD.mLogger.debug("Entry Date Time : "+obj.get("Entry Date Time"));
				jsonArray.add(obj);
				iform.addDataToGrid("Q_USR_0_ODDD_WIHISTORY", jsonArray);
				
				ODDD.mLogger.debug("jsonArray : "+jsonArray);
			
				//strReturn = "INSERTED";
				
				ODDD.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Added Successfully!");
			} 
			catch (Exception e) {
				ODDD.mLogger.debug("Exception in inserting WI History!" + e.getMessage());
			}
		}
		if("setInitiatorMail".equals(controlName))
		{
			try 
			{				
				List lstDecisions = iform
					.getDataFromDB("select top 1 isnull(MailId,'') from PDBUser with(nolock) where UserName = '"+iform.getUserName()+"'");
				ODDD.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", controlName : "+controlName);
				
				String value1 = "";
				for(int i=0;i<lstDecisions.size();i++)
				{
					List<String> arr1=(List)lstDecisions.get(i);
					value1=arr1.get(0);
					iform.setValue("Mail_ID",value1);
				}
			}
			catch (Exception e) 
			{
				ODDD.mLogger.debug("WINAME : "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in setting mail id " + e.getMessage());
			}
		}
		return strReturn;
	}
}