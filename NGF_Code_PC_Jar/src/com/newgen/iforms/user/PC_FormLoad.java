package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class PC_FormLoad extends PCCommon
{
	public String formLoadEvent(IFormReference iform, String controlName, String data)
	{
		String strReturn="";
		//Added by Sajan to load Service Requests acc to service request type
		if("ServiceRequestdropdownRequestWise".equals(controlName))
		{
			try {
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_TYPE");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is: "+strServiceType);
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT REQUEST_TYPE FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE SERVICE_REQUEST_TYPE IN ('"+strServiceType+"','Both') AND ACTIVE='Y' ORDER BY REQUEST_TYPE");
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
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Service Request on Load on basis of request Type: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Service Request drop down load on basis of request type: " + e.getMessage());
			}
		}
		
		//Added by Sajan to fetch duplicate WIs
		else if("DuplicateWI".equals(controlName))
		{
			try {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Sajan logging Duplicate WIs");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Name duplicate is: "+getWorkitemName());
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", CIF id is: "+iform.getValue("CIF_ID"));
				String strQuery="SELECT WI_NAME,CREATED_AT,CREATED_BY_USER,SOL_ID FROM RB_PC_EXTTABLE WITH(NOLOCK) WHERE CIF_ID='"+iform.getValue("CIF_ID")+"' AND WI_NAME NOT IN ('"+getWorkitemName()+"')";
				List<List<String>> lstDuplicateWIs = iform.getDataFromDB(strQuery);
				
				JSONArray jsonArray=new JSONArray();
				String value="";
				for(int i=0;i<lstDuplicateWIs.size();i++)
				{
					//PC.mLogger.debug(" "+memoPad);
					JSONObject obj=new JSONObject();
					List<String> arr=(List)lstDuplicateWIs.get(i);
					value=arr.get(0);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI is: "+value);
					obj.put("Work-Item Number", value);
					value=arr.get(1);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Date format Sajan: "+value);
					//Date date1= new SimpleDateFormat("EE dd/MMM/yyyy HH:mm:ss",Locale.ENGLISH).parse(value);
					Date date1= new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss").parse(value);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", date1: "+date1);
					SimpleDateFormat sdf1=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Initiated date is: "+sdf1.format(date1).toString());
					
					value=sdf1.format(date1).toString();
					obj.put("Initiated Date", value);
					value=arr.get(2);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Initiated by is: "+value);
					obj.put("Initiated By", value);
					value=arr.get(3);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Sol id is: "+value);
					obj.put("Sol Id", value);
					jsonArray.add(obj);
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", JSON array Duplicate WI: "+jsonArray.toString());
				iform.addDataToGrid("Q_USR_0_PC_DUPLICATE_WI", jsonArray);
				strReturn=strReturn+lstDuplicateWIs.size();
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Duplicate WI: " + e.getMessage());
			}
		}
		
		//Added By Sajan to check if sampling is required for the WI or not
		else if("ISSAMPLINGREQUIRED".equals(controlName))
		{
			try {
				
				Random r = new Random();
				int low = 1;
				int high = 100;
				int result = r.nextInt(high-low) + low;
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Return for random value is: "+result);
				strReturn=strReturn+result;
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in getting random number: " + e.getMessage());
			}
		}
		
		//Added by Sajan to fetch all the products 
		else if("ProductListdropdown".equals(controlName))
		{
			try {

				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT PRODUCT_NAME FROM USR_0_PC_PRODUCT WITH(NOLOCK) where ISACTIVE='Y'");
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
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Product on Load: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Product drop down load: " + e.getMessage());
			}
		}
		
		//Added by Nikita for populating solid
		
		else if("SolId".equals(controlName))
		{
			try {

				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT comment FROM PDBUser with (nolock) WHERE UserName='"+data+"'");
				for (List<String> row : lstDecision) {
					
						strReturn=row.get(0);
					
					
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Sol Id on Load: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in SolId on load: " + e.getMessage());
			}
		}
		
		// Added by Sajan for Exception grid
		else if("Exception".equals(controlName))
		{
			PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Data Coming in Exceptions is: "+data);
			try {
	
					List<List<String>> lstException = iform
							.getDataFromDB("SELECT ExceptionName,canRaise,canClear,canView FROM USR_0_PC_EXCEPTION_MASTER WITH(NOLOCK) where ISACTIVE='Y' and WORKSTEP_NAME='"+iform.getActivityName()+"'");
					JSONArray jsonArray = new JSONArray();
					String value = "";
					for (int i = 0; i < lstException.size(); i++) {
						// PC.mLogger.debug(" "+memoPad);
						JSONObject obj = new JSONObject();
						List<String> arr = (List) lstException.get(i);
						value = arr.get(0);
						obj.put("Exception", value);
						if ("".equals(strReturn)) {
							strReturn = strReturn + value + ":" + arr.get(1) + ":" + arr.get(2) + ":" + arr.get(3);
						} else {
							strReturn = strReturn + "~" + value + ":" + arr.get(1) + ":" + arr.get(2) + ":"
									+ arr.get(3);
						}
						jsonArray.add(obj);
					}
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for exception master: " + jsonArray.toJSONString());
					// iform.addDataToGrid("table7", jsonArray);
					if(!("Rights".equals(data)))
						iform.addDataToGrid("Q_USR_0_PC_EXCEPTION_HISTORY", jsonArray);
				
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in exception master: " + e.getMessage());
			}
		}
		
		//Added by Sajan to check exception rights
		else if("raiseClearException".equals(controlName))
		{
			try {

				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Data for Clear Raise Exception is: "+data);
				String strCheckUncheck=iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 0);
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception check uncheck is: "+iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 0));
				Calendar cal = Calendar.getInstance();
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    String strDate = sdf.format(cal.getTime());
				String strRaisedCleared="";
				String strNewLine="";
				if("".equals(iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 4)) || iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 4)==null)
					strNewLine="";
				else
					strNewLine="\n";
				if("true".equals(strCheckUncheck))
					strRaisedCleared="Raised";
				else
					strRaisedCleared="Approved";
				iform.setTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data),2,iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 2)+strNewLine+iform.getActivityName());
				iform.setTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data),3,iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 3)+strNewLine+iform.getUserName());
				iform.setTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data),4,iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 4)+strNewLine+strRaisedCleared);
				iform.setTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data),5,iform.getTableCellValue("Q_USR_0_PC_EXCEPTION_HISTORY",Integer.parseInt(data), 5)+strNewLine+strDate);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Exception Raise Clear: " + e.getMessage());
			}
		}
		
		//Added by Sajan to check exception rights
				else if("DecisionDropDown".equals(controlName))
				{
					try {
						List lstDecisions = iform
							.getDataFromDB("SELECT DECISION FROM USR_0_PC_DECISION_MASTER WITH(NOLOCK) WHERE WORKSTEP_NAME='"+iform.getActivityName()+"' and ISACTIVE='Y'");
						
						String value="";
						iform.clearCombo("qDecision");
						for(int i=0;i<lstDecisions.size();i++)
						{
							List<String> arr1=(List)lstDecisions.get(i);
							value=arr1.get(0);
							iform.addItemInCombo("qDecision",value,value);
						}
						
					} catch (Exception e) {
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Decision drop down load: " + e.getMessage());
					}
				}
		
		
		
		//Added by Sajan to fetch all the memopad from master
		else if("Q_USR_0_PC_MEMOPAD_GRID".equals(controlName))
		{
			try
			{
				List lstMemoPad = iform
						.getDataFromDB("SELECT ID,MEMOPAD_TEXT FROM USR_0_PC_MEMOPAD WITH(NOLOCK) where ISACTIVE='Y'");
				JSONArray jsonArray=new JSONArray();
				
				String value="";
				for(int i=0;i<lstMemoPad.size();i++)
				{
					//PC.mLogger.debug(" "+memoPad);
					JSONObject obj=new JSONObject();
					List<String> arr=(List)lstMemoPad.get(i);
					value=arr.get(0);
					obj.put("Sr No", value);
					value=arr.get(1);
					obj.put("Memopad Text", value);
					obj.put("Memotext Hidden", value);
					jsonArray.add(obj);
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for memo pad master: "+jsonArray.toJSONString());
				//iform.addDataToGrid("table7", jsonArray);
				iform.addDataToGrid("Q_USR_0_PC_MEMOPAD_GRID", jsonArray);
			}
			catch(Exception e)
			{
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in memoPad table populate: "+e.getMessage());
			}
		}
		/*else if("Q_USR_0_PC_UID_DTLS".equals(control))
		{
			PC.mLogger.debug("In UID grid validations");
			try
			{
				PC.mLogger.debug("String data for UID grid validation is "+data);
				String strUID="";
				String strName="";
				for(int i=0;i<Integer.parseInt(data);i++)
				{
					strUID=iform.getTableCellValue("Q_USR_0_PC_UID_DTLS", i,0);
					if(!("".equals(strUID)))
					{
						strName=iform.getTableCellValue("Q_USR_0_PC_UID_DTLS", i,1);
					}
				}
			}
			catch(Exception e)
			{
				PC.mLogger.debug("Exception in  UID grid Validation "+e.getMessage());
			}
		}*/
		//Added by Sajan to Fetch checklist Description from master
		else if("Q_USR_0_PC_CHECKLIST_GRID".equals(controlName))
		{
			try
			{
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_TYPE");
				List lstMemoPad = iform
						.getDataFromDB("SELECT CHECKLIST_DESCRIPTION FROM USR_0_PC_CHECKLIST_MASTER WITH(NOLOCK) where REQUEST_TYPE = '"+strServiceType+"' and IS_ACTIVE='Y' order by DisplayOrder");
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
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Checklist: "+jsonArray.toJSONString());
				iform.addDataToGrid("Q_USR_0_PC_CHECKLIST_GRID", jsonArray);
			}
			catch(Exception e)
			{
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Checklist table populate: "+e.getMessage());
			}
		}
		else if("Q_USR_0_PC_OPSDOC_CHECKLIST_GRID".equals(controlName))
		{
			try
			{
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_TYPE");
				List lstMemoPad = iform
						.getDataFromDB("SELECT CHECKLIST_DESCRIPTION FROM USR_0_PC_OPSDOC_CHECKLIST_MASTER WITH(NOLOCK) where REQUEST_TYPE = '"+strServiceType+"' and IS_ACTIVE='Y' order by DisplayOrder");
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
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Checklist: "+jsonArray.toJSONString());
				iform.addDataToGrid("Q_USR_0_PC_OPSDOC_CHECKLIST_GRID", jsonArray);
			}
			catch(Exception e)
			{
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Checklist table populate: "+e.getMessage());
			}
		}
		return strReturn;
	}
}