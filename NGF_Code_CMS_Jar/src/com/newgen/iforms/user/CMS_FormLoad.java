package com.newgen.iforms.user;

import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.json.simple.JSONArray;
import java.util.List;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;

public class CMS_FormLoad extends CMSCommon
{
	public String formLoadEvent(IFormReference iform, String controlName,String event, String data)
	{
		String strReturn=""; 
	
		CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", This is CMS_FormLoad_Event");
		
		//CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", SELECT DECISION FROM USR_0_CMS_DECISION_MASTER WHERE WORKSTEP_NAME= '"+iform.getActivityName()"' and ISACTIVE='Y'");
		
		
		if (controlName.equalsIgnoreCase("DecisionDropDown") && event.equalsIgnoreCase("FormLoad") )
		{

		String actname = iform.getActivityName();
		//CMS.mLogger.debug(actname);
		List lstDecisions = iform.getDataFromDB("SELECT DECISION FROM USR_0_CMS_DECISION_MASTER WITH(NOLOCK) WHERE WORKSTEP_NAME= '"+iform.getActivityName()+"' and ISACTIVE='Y'");
		
		String value="";
		
		CMS.mLogger.debug(lstDecisions);
		
		iform.clearCombo("q_Decision");
		for(int i=0;i<lstDecisions.size();i++)
		 {
			List<String> arr1=(List)lstDecisions.get(i);
			value=arr1.get(0);
			iform.addItemInCombo("q_Decision",value,value);
		 }		
		}
		
		if("ServiceRequestdropdown".equals(controlName) && event.equalsIgnoreCase("FormLoad"))
		{
			try {

				List<List<String>> lstDecision = iform.getDataFromDB("SELECT REQUEST_TYPE FROM USR_0_CMS_REQ_TYPE WITH(NOLOCK) where ISACTIVE='Y' order by request_type desc");
				for (List<String> row : lstDecision) {
					if(strReturn.equals(""))
					{
						strReturn=strReturn+row.get(0);
						
					}
					else
					{
						strReturn=strReturn+"~"+row.get(0);
					}
					
				}
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Return for Request on Load "+strReturn);
				
			} catch (Exception e) {
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in Service Request drop down load " + e.getMessage());
			}
		}
		
		
		
		else if("SolId".equals(controlName) && event.equalsIgnoreCase("FormLoad"))
		{
			try {

				List<List<String>> lstDecision = iform.getDataFromDB("SELECT comment FROM PDBUser with (nolock) WHERE UserName='"+iform.getUserName()+"'");
				for (List<String> row : lstDecision) {
					
						strReturn=row.get(0);
					
					
				}
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", return for Sol Id on Load "+strReturn);
				
			} 
			catch (Exception e) {
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in SolId on load " + e.getMessage());
			}
		}
		
			
		else if("DuplicateWI".equals(controlName))
		{
			try {
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Duplicate WIs");
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", WI Name duplicate is "+getWorkitemName());
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", CIF id is "+iform.getValue("CIF_ID"));
				String strQuery="SELECT WI_NAME,CREATED_TIME, CREATED_BY, SOL_ID  FROM RB_CMS_EXTTABLE WHERE CIF_ID='"+iform.getValue("CIF_ID")+"' AND WI_NAME NOT IN ('"+getWorkitemName()+"')";
				List<List<String>> lstDuplicateWIs = iform.getDataFromDB(strQuery);
				
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", strQuery "+strQuery);
				JSONArray jsonArray=new JSONArray();
				String value="";
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", lstDuplicateWIs.size() "+lstDuplicateWIs.size());
				for(int i=0;i<lstDuplicateWIs.size();i++)
				{
					//PC.mLogger.debug(" "+memoPad);
					JSONObject obj=new JSONObject();
					List<String> arr=(List)lstDuplicateWIs.get(i);
					value=arr.get(0);
					CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", WI is "+value);
					obj.put("Work-Item Number", value);
					value=arr.get(1);
					//CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Date format Sajan "+value);
					//Date date1= new SimpleDateFormat("EE dd/MMM/yyyy HH:mm:ss",Locale.ENGLISH).parse(value);
					Date date1= new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss").parse(value);
					CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", date1 "+date1);
					SimpleDateFormat sdf1=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
					CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Initiated date is "+sdf1.format(date1).toString());
					
					value=sdf1.format(date1).toString();
					obj.put("Initiated Date", value);
					value=arr.get(2);
					CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Initiated by is "+value);
					obj.put("Initiated By", value);
					value=arr.get(3);
					CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Sol id is "+value);
					obj.put("Sol Id", value);
					jsonArray.add(obj);
				}
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", JSON array is "+jsonArray.toString());
				iform.addDataToGrid("Q_USR_0_CMS_DUPLICATE_WI", jsonArray);
				strReturn=strReturn+lstDuplicateWIs.size();
			} catch (Exception e) {
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in Duplicate WorkItem" + e.getMessage());
			}
		}
		
		
		
		else if("ServiceRequestdropdownRequestWise".equals(controlName))
		{
			try {
				//String strServiceType=(String)iform.getValue("SERVICE_REQUEST_TYPE");
				//CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Service Request is "+strServiceType);
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT REQUEST_TYPE FROM USR_0_CMS_REQ_TYPE WITH(NOLOCK) WHERE ISACTIVE='Y'");
				for (List<String> row : lstDecision) {
					if(strReturn.equals(""))
					{
						strReturn=strReturn+row.get(0);
					}
					else
					{
						strReturn=strReturn+"~"+row.get(0);
					}
					
				}
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", return for Service Request on Load on basis of request Type "+strReturn);
				
			} catch (Exception e) {
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in Service Request drop down load on basis of request type" + e.getMessage());
			}
		}
		
		else if("Q_USR_0_CMS_CHECKLIST_GRID".equals(controlName))
		{
			try
			{
				List lstMemoPad = iform
						.getDataFromDB("SELECT CHECKLIST_DESCRIPTION FROM USR_0_CMS_CHECKLIST_MASTER WITH(NOLOCK) where IS_ACTIVE='Y'");
				JSONArray jsonArray=new JSONArray();
				
				String value="";
				for(int i=0;i<lstMemoPad.size();i++)
				{
					JSONObject obj=new JSONObject();
					List<String> arr=(List)lstMemoPad.get(i);
					value=arr.get(0);
					obj.put("Checklist Description", value);
					jsonArray.add(obj);
				}
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", return for Checklist "+jsonArray.toJSONString());
				iform.addDataToGrid("Q_USR_0_CMS_CHECKLIST_GRID", jsonArray);
			}
			catch(Exception e)
			{
				CMS.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", Exception in Checklist table populate "+e.getMessage());
			}
		}
		
		return strReturn;
	}
	
}
