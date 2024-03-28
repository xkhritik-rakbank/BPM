package com.newgen.iforms.user;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.newgen.iforms.custom.IFormReference;

public class PC_IntroDone extends PCCommon{
	
	@SuppressWarnings("unchecked")
	public String onIntroduceDone(IFormReference iform,String controlName,String data)
	{
		String strReturn="";
		PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", This is PC_IntroDone");
		//This block was added by Sajan to check for memopad after initiation 
		if("checkMemoPad".equals(controlName))
		{
			try {
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is: "+strServiceType);
				strServiceType="'"+strServiceType+"'";
				strServiceType=strServiceType.replace("|", "','");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final strService type is: "+strServiceType);
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT count(MEMOPAD_AFTER_INITIATION) FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE MEMOPAD_AFTER_INITIATION='Y' AND REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'");
				for (List<String> row : lstDecision) {
						strReturn=row.get(0);
				}
				if(Integer.parseInt(strReturn)>0)
				{
					setControlValue("MP_INTG_REQ_INITIATION", "Required");
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in If - MP_INTG_REQ_INITIATION set to Required");
				}	
				else
				{
					setControlValue("MP_INTG_REQ_INITIATION", "No");
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in If - MP_INTG_REQ_INITIATION set to No");
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for check if memopad required for initiation: "+strReturn);
				String MPInitiateCount = strReturn;
				
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Now Memopad Check for OPS");
				lstDecision = iform
						.getDataFromDB("SELECT count(MEMOPAD_REJECT_OPS) FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE MEMOPAD_REJECT_OPS='Y' AND REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y' ");
				
				for (List<String> row : lstDecision) {
					strReturn=row.get(0);
				}
				
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", The output for memo pad for OPS is: "+strReturn);
				if(Integer.parseInt(strReturn)>0)
				{
					setControlValue("MP_INTG_REQ_OPS_REJECT", "Required");
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in If - MP_INTG_REQ_OPS_REJECT set to Required");
				}	
				else
				{
					setControlValue("MP_INTG_REQ_OPS_REJECT", "No");
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in If - MP_INTG_REQ_OPS_REJECT set to No");
				}
				String MPOPSRejectCount = strReturn;
				strReturn = MPInitiateCount +"~"+ MPOPSRejectCount;
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in check if memopad required: " + e.getMessage());
			}
		}
		//Added By Sajan to check if system check are required or not
		else if("isSystemCheckBorrowing".equals(controlName))
		{
			try {
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is: "+strServiceType);
				strServiceType="'"+strServiceType+"'";
				strServiceType=strServiceType.replace("|", "','");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final strService type is: "+strServiceType);
				String strQuery="SELECT count(SYSTEM_CHECK_RQD_BORROWING) FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE SYSTEM_CHECK_RQD_BORROWING='Y' AND REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'";
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Query for sys Check: "+strQuery);
				
				List<List<String>> lstDecision = iform
						.getDataFromDB(strQuery);
				for (List<String> row : lstDecision) {
						strReturn=strReturn+row.get(0);
				}
				if(Integer.parseInt(strReturn)>0)
				{
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in If ISSYSTEMCHECKS set to Required");
					setControlValue("ISSYSTEMCHECKS","Required");
				}
				else
				{
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in Else ISSYSTEMCHECKS set to No");
					setControlValue("ISSYSTEMCHECKS", "No");
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for check if system Check required borrowing: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in check if system Check Required borrowing: " + e.getMessage());
			}
		}
		else if("isAccountFreezeEditNonEdit".equals(controlName))
		{
			try {
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is: "+strServiceType);
				strServiceType="'"+strServiceType+"'";
				strServiceType=strServiceType.replace("|", "','");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final strService type is: "+strServiceType);
				String strQuery="SELECT count(ACC_FREEZE_RQD_EDIT) FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE ACC_FREEZE_RQD_EDIT='Y' AND REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'";
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Query for account Freeze is: "+strQuery);
				
				List<List<String>> lstDecision = iform
						.getDataFromDB(strQuery);
				for (List<String> row : lstDecision) {
						strReturn=strReturn+row.get(0);
				}
				if(Integer.parseInt(strReturn)>0)
				{
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in If Account Freeze IS_ACC_FREEZE_FIELD_EDITABLE set to Yes");
					setControlValue("IS_ACC_FREEZE_FIELD_EDITABLE","Yes");
				}
				else
				{
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", in Else Account Freeze IS_ACC_FREEZE_FIELD_EDITABLE set to No");
					setControlValue("IS_ACC_FREEZE_FIELD_EDITABLE", "No");
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for check if account freeze editable or not: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in if account freeze editable or not: " + e.getMessage());
			}
		}
		// Added By Sajan to check all mandatory memo pad
		else if("MANDATORY_MEMO_PAD".equals(controlName))
		{
			try {
				
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Checking mandatory memo pad");
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is: "+strServiceType);
				strServiceType="'"+strServiceType+"'";
				strServiceType=strServiceType.replace("|", "','");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final strService type is: "+strServiceType);
				String strQuery="";
				if("Introduction".equals(iform.getActivityName()))
					strQuery="SELECT SCENARIO1_MEMOPAD FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'";
				else if("".equals(data))
					strQuery="SELECT SCENARIO2_MEMOPAD_BORROWING FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'";
				else
					strQuery="SELECT SCENARIO2_MEMOPAD_NONBORROWING FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'";
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Query for sys Check "+strQuery);
				
				TreeSet<String> hSet=new TreeSet<>();
				String temp[];
				List<List<String>> lstMandatoryMemo = iform
						.getDataFromDB(strQuery);
				for (List<String> row : lstMandatoryMemo) {
						PC.mLogger.debug(row.get(0));
						if(row.get(0).contains(","))
						{
							temp=row.get(0).split(",");
							for(int p=0;p<temp.length;p++)
							{
								hSet.add(temp[p]);
							}
						}
						else
						{
							if(!(row.get(0).equals("")) && row.get(0)!=null)
								hSet.add(row.get(0));
						}
				}
				//hSet.remove(null);
				if(hSet.size()>0){
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Hash set size is more than zero: "+hSet.size());
					Iterator<String> itr=hSet.iterator();
					int intNumberMemo;
					boolean flag;
					StringBuffer strBuff=null;
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Converting hashset into String: "+hSet.toString());
					strReturn=strReturn+hSet.toString();
				}
				
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Mandatory memopad is: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in check mandatoty memo pad: " + e.getMessage());
			}
		}
		
		//Added by Sajan  to if system check required for non borrowing
		else if("isSystemCheckNonBorrowing".equals(controlName))
		{
			try {
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is "+strServiceType);
				strServiceType="'"+strServiceType+"'";
				strServiceType=strServiceType.replace("|", "','");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final strService type is: "+strServiceType);
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT count(SYSTEM_CHECK_RQD_NONBORROWING) FROM USR_0_PC_SERVICE_REQUEST_MASTER WITH(NOLOCK) WHERE SYSTEM_CHECK_RQD_NONBORROWING='Y' AND REQUEST_TYPE IN ("+strServiceType+") and ACTIVE='Y'");
				for (List<String> row : lstDecision) {
						strReturn=strReturn+row.get(0);
				}
				if(Integer.parseInt(strReturn)>0)
					setControlValue("ISSYSTEMCHECKS", "Required");
				else
					iform.setValue("ISSYSTEMCHECKS", "No");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for check if system Check non required borrowing :"+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in check if system Check Required non borrowing :" + e.getMessage());
			}
		}
		
		//Added By Sajan to insert data into history table
		else if("InsertIntoHistory".equals(controlName))
		{
			try {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons Grid Length is: "+data);
				String strRejectReasons="";
				String strRejectCodes = "";
				for(int p=0;p<Integer.parseInt(data);p++)
				{
					/*if(strRejectReasons=="")
						strRejectReasons=iform.getTableCellValue("REJECT_REASON_GRID",p,0);
					else
						strRejectReasons=strRejectReasons+"#"+iform.getTableCellValue("REJECT_REASON_GRID",p,0);*/
					
					String completeReason = null;
					completeReason = iform.getTableCellValue("REJECT_REASON_GRID", p, 0);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Complete Reject Reasons" + completeReason);
					
					if (strRejectReasons == "")
					{						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=completeReason.substring(completeReason.indexOf("-")+1);
							PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=completeReason;
							PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons else block" + strRejectReasons);
						}
					}	
					else
					{
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons 1" + strRejectReasons);						
						if(completeReason.indexOf("-")>-1)
						{
							strRejectCodes=strRejectCodes+"#"+completeReason.substring(0,completeReason.indexOf("-")).replace("(", "").replace(")", "");
							PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons code" + strRejectCodes);
							strRejectReasons=strRejectReasons+"#"+completeReason.substring(completeReason.indexOf("-")+1);
							PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons" + strRejectReasons);
						}
						else
						{
							strRejectReasons=strRejectReasons+"#"+completeReason;
							PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons else block2" + strRejectReasons);
						}
						
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Reject Reasons 2" + strRejectReasons);
					}
					
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final reject reasons are: "+strRejectReasons);
				JSONArray jsonArray=new JSONArray();
				JSONObject obj=new JSONObject();
				Calendar cal = Calendar.getInstance();
			    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			    String strDate = sdf.format(cal.getTime());
			    PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final date for history is: "+strDate);
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
				iform.addDataToGrid("Q_USR_0_PC_WIHISTORY", jsonArray);
				
				strReturn = "INSERTED";
				
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Added Successfully!");
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Not Added Successfully!: " + e.getMessage());
			}
		}
		else if("InsertIntoErrorHandling".equals(controlName))
		{
			try
			{
				if ("".equals(data)) {
					int acctablesize = iform.getDataFromGrid("tblAccountDetails").size();
					int memopadtablesize = iform.getDataFromGrid("Q_USR_0_PC_MEMOPAD_GRID").size();
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", acctablesize--" + acctablesize);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", memopadtablesize--" + memopadtablesize);

					JSONArray jsonArray = new JSONArray();
					for (int j = 0; j < acctablesize; j++) {
						String Accno = iform.getTableCellValue("tblAccountDetails", j, 0);
						String AccType=iform.getTableCellValue("tblAccountDetails", j, 2);
						
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", This is Sajan logging for CRs 22082019");
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", The Account Type is "+AccType);
						if(AccType.equalsIgnoreCase("ODA") || AccType.equalsIgnoreCase("SBA"))
						{
						
							for (int k = 0; k < memopadtablesize; k++) {
								String memoPadSno = iform.getTableCellValue("Q_USR_0_PC_MEMOPAD_GRID", k, 0);
								String memoPadIsApplicable = iform.getTableCellValue("Q_USR_0_PC_MEMOPAD_GRID", k, 1);
								String memoPadText = iform.getTableCellValue("Q_USR_0_PC_MEMOPAD_GRID", k, 2);
	
								if (memoPadIsApplicable.equalsIgnoreCase("true")) {
									JSONObject obj = new JSONObject();
									obj.put("Date & Time", "");
									obj.put("Call Name", "Memopad_Maintenance_Req");
									obj.put("Account Number", Accno);
									obj.put("Status", "New");
									obj.put("Message Id", "");
									obj.put("Return Code", "");
									obj.put("Return Description", "");
									obj.put("MQ_Output_ref", "");
									obj.put("Memopad text", memoPadText);
									obj.put("Memopad No", memoPadSno);
									jsonArray.add(obj);
									strReturn = "true";
								}
							}
						}
					}
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", @@@@@@@@@@ for memopad error handling grid:::" + jsonArray.toJSONString());
					iform.addDataToGrid("Q_USR_0_PC_ERR_HANDLING", jsonArray);

					//strReturn = "";
				}
				else
				{
					Set<String> hSetSrNo=new HashSet<>();
					if(data.contains(",")){
						String arr[]=data.split(",");
						for(int p=0;p<arr.length;p++)
						{
							hSetSrNo.add(arr[p]);
						}
					}
					else
					{
						hSetSrNo.add(data.trim());
					}
					int acctablesize = iform.getDataFromGrid("tblAccountDetails").size();
					int memopadtablesize = iform.getDataFromGrid("Q_USR_0_PC_MEMOPAD_GRID").size();
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", acctablesize for OPS team--" + acctablesize);
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", memopadtablesize for OPS team: " + memopadtablesize);
					JSONArray jsonArray = new JSONArray();
					for (int j = 0; j < acctablesize; j++) {
						String Accno = iform.getTableCellValue("tblAccountDetails", j, 0);
						String AccType=iform.getTableCellValue("tblAccountDetails", j, 2);
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", This is Sajan logging for CRs 22082019");
						PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", The Account Type is "+AccType);
						if(AccType.equalsIgnoreCase("ODA") || AccType.equalsIgnoreCase("SBA"))
						{
						
							for (int k = 0; k < memopadtablesize; k++) {
								String memoPadSno = iform.getTableCellValue("Q_USR_0_PC_MEMOPAD_GRID", k, 0);
								String memoPadIsApplicable = iform.getTableCellValue("Q_USR_0_PC_MEMOPAD_GRID", k, 1);
								String memoPadText = iform.getTableCellValue("Q_USR_0_PC_MEMOPAD_GRID", k, 2);
								if(hSetSrNo.contains(memoPadSno))
								{
									PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Already Selected memopad s No: "+memoPadSno);
									continue;
								}
								else
								{
									PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Newly selected Memopad SrNo: "+memoPadSno);
									if (memoPadIsApplicable.equalsIgnoreCase("true")) {
										JSONObject obj = new JSONObject();
										obj.put("Date & Time", "");
										obj.put("Call Name", "Memopad_Maintenance_Req");
										obj.put("Account Number", Accno);
										obj.put("Status", "New");
										obj.put("Message Id", "");
										obj.put("Return Code", "");
										obj.put("Return Description", "");
										obj.put("MQ_Output_ref", "");
										obj.put("Memopad text", memoPadText);
										obj.put("Memopad No", memoPadSno);
										jsonArray.add(obj);
										strReturn = "true";
									}
								}
							}
						}
							
					}
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", @@@@@@@@@@ for memopad error handling grid for OPS:::" + jsonArray.toJSONString());
					iform.addDataToGrid("Q_USR_0_PC_ERR_HANDLING", jsonArray);
				}
			}
			 catch (Exception e) {
					PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in InsertIntoErrorHandling: " + e.getMessage());
				}
		}
		else if("isDocAttached".equals(controlName))
		{
			try {
				String EntryDateTime = (String)iform.getValue("EntryDateTime");
				String splitdatetime[] = EntryDateTime.split(" ");
				String Date=splitdatetime[0];
				String splitDate[] = Date.split("/");
				String day =splitDate[0]; 
				String month=splitDate[1];
				String year=splitDate[2];
				String entrydate = year+"-"+month+"-"+day;
				String Entry_DateTime = entrydate+" "+splitdatetime[1];
				String wiName = getWorkitemName();
				
				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT count(*) FROM PDBDocument a WITH (nolock), PDBFolder b WITH (nolock), PDBDocumentContent c WITH (nolock) WHERE a.DocumentIndex = c.DocumentIndex AND b.FolderIndex = c.ParentFolderIndex AND b.Name = '"+wiName+"' AND a.CreatedDateTime > CONVERT(datetime, '"+Entry_DateTime+"', 120)");
				for (List<String> row : lstDecision) {
						strReturn=strReturn+row.get(0);
				}
				if(Integer.parseInt(strReturn)>0)
					setControlValue("ISADDDOCSADDED", "Yes");
				else
					iform.setValue("ISADDDOCSADDED", "No");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for check if documents are attached at Obtain Original and Attach Doc queue: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in check if documents are attached at Obtain Original and Attach Doc queue: " + e.getMessage());
			}
		}
		else if("MandatoryDocListFromMaster".equals(controlName))
		{
			try {
				strReturn = "";
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Getting Mandatory Doc List to be attached at CBWC Maker");
				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Service Request is: "+strServiceType);
				strServiceType="'"+strServiceType+"'";
				strServiceType=strServiceType.replace("|", "','");
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Final strService type is: "+strServiceType);
				String strQuery = "SELECT DISTINCT "+data+" FROM USR_0_PC_MandatoryDocsToAttach WITH (nolock) WHERE REQUEST_TYPE IN ("+strServiceType+") and ISACTIVE='Y'";	
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", strQuery is: "+strQuery);
				List<List<String>> lstDoc = iform.getDataFromDB(strQuery);
				for (List<String> row : lstDoc) {
					if(strReturn.equals(""))
					{
						if(!"".equalsIgnoreCase(row.get(0).trim()))
							strReturn=strReturn+row.get(0);
					}
					else
					{
						if(!"".equalsIgnoreCase(row.get(0).trim()))	
							strReturn=strReturn+","+row.get(0);
					}
				}
				
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for Mandatory Doc list to be attached at CBWC Maker: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in Mandatory Doc list to be attached at CBWC Maker: " + e.getMessage());
			}
		}
		else if("EmailIdFromPDBUser".equals(controlName))
		{
			try {

				List<List<String>> lstDecision = iform
						.getDataFromDB("SELECT MailId FROM PDBUser with (nolock) WHERE UserName='"+data+"'");
				for (List<String> row : lstDecision) {
					strReturn=row.get(0);
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return for MailId on done: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in MailId on done: " + e.getMessage());
			}
		}
		else if("SendMAILSMSAlert".equals(controlName))
		{
			try {

				String strServiceType=(String)iform.getValue("SERVICE_REQUEST_SELECTED");
				String strDecision=(String)iform.getValue("qDecision");
				String strInitiatorMailId=(String)iform.getValue("INITIATOR_MAILID");
				String strRMMailId=(String)iform.getValue("RM_MAILID");
				String strCustName=(String)iform.getValue("CUSTOMER_NAME");
				
				List<String> paramlist =new ArrayList<String>( );
				paramlist.add("Text : "+iform.getActivityName().trim());
				paramlist.add("Text : "+getWorkitemName().trim());
				paramlist.add("Text : "+strDecision.trim());
				paramlist.add("Text : PC");
				paramlist.add("Text : "+strInitiatorMailId.trim());
				paramlist.add("Text : "+strRMMailId.trim());
				paramlist.add("Text : "+strCustName.trim());
				paramlist.add("Text : "+strServiceType.trim());
				List<List<String>> lstDecision = iform.getDataFromStoredProcedure("NG_PC_CUST_MAILSMS_PROC", paramlist);
				for (List<String> row : lstDecision) {
					strReturn=row.get(0);
				}
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", return mailsms status: "+strReturn);
				
			} catch (Exception e) {
				PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Exception in mailsms status: " + e.getMessage());
			}
		}
		
		PC.mLogger.debug("WINAME: "+getWorkitemName()+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", Returning");
		return strReturn;
	}

}
