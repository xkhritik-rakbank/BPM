package com.newgen.iforms.user;

import java.util.Date;
import java.util.List;
import java.text.SimpleDateFormat;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.xmlapi.IFormXmlResponse;

public class KYC_Remediation_IntroDone extends KYC_Remediation_Common
{
	@SuppressWarnings("unchecked")
	public String onIntroduceDone(IFormReference iform, String controlName,String event, String data)
	{
		String strReturn="";
		KYC_Remediation.mLogger.debug("This is KYC_IntroDone_Event");
		if("InsertIntoHistory".equals(controlName))
		{
			try {
				String caseType = (String) iform.getValue("CaseType");
				if("Corporate".equalsIgnoreCase(caseType)){
					KYC_Remediation.mLogger.debug("Inside IntroDone , trying to move related party WI...");
					int rowCount = Integer.parseInt(data);
					for(int i=0;i<rowCount;i++ ){
						String sCabname = getCabinetName(iform);
						KYC_Remediation.mLogger.debug("sCabname" + sCabname);
						String sSessionId = getSessionId(iform);
						KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
						String Decision = (String)iform.getValue("DECISION");
						String attTag = "<DECISION>"+Decision+"</DECISION>";
						String WI_ID = "";
						String ProcessDefID = "";
						String ActivityID = "";
						String WIName = iform.getTableCellValue("table4",i,1);
						String query = "select WorkItemId,ProcessDefID,ActivityId from WFINSTRUMENTTABLE where ProcessInstanceID = '"+WIName+"'";
						List<List<String>> dataFromDB = iform.getDataFromDB(query);
						KYC_Remediation.mLogger.debug("dataFromDB: " + dataFromDB);
						if (!dataFromDB.isEmpty()) {
							 WI_ID = dataFromDB.get(0).get(0);
							 ProcessDefID = dataFromDB.get(0).get(1);
							 ActivityID = dataFromDB.get(0).get(2);
							KYC_Remediation.mLogger.debug("WorkItemId: " + WI_ID);
						} else {
							KYC_Remediation.mLogger.debug("Workitem ID not found!!");
						}
						IFormXmlResponse xmlParserData = new IFormXmlResponse();
						StringBuffer ipXMLBuffer=new StringBuffer();

						ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
						ipXMLBuffer.append("<WMGetWorkItem_Input>\n");
						ipXMLBuffer.append("<Option>WMGetWorkItem</Option>\n");
						ipXMLBuffer.append("<EngineName>");
						ipXMLBuffer.append(sCabname);
						ipXMLBuffer.append("</EngineName>\n");
						ipXMLBuffer.append("<SessionId>");
						ipXMLBuffer.append(sSessionId);
						ipXMLBuffer.append("</SessionId>\n");
						ipXMLBuffer.append("<ProcessInstanceId>");
						ipXMLBuffer.append(WIName);
						ipXMLBuffer.append("</ProcessInstanceId>\n");
						ipXMLBuffer.append("<WorkItemId>");
						ipXMLBuffer.append(WI_ID);
						ipXMLBuffer.append("</WorkItemId>\n");
						ipXMLBuffer.append("</WMGetWorkItem_Input>");
						
						String getWIinput = ipXMLBuffer.toString();
						KYC_Remediation.mLogger.debug("getWIinput--->"+getWIinput);
						String OutputXML = ExecuteQueryOnServer(getWIinput, iform);
						KYC_Remediation.mLogger.debug("sOutputXML--->"+OutputXML);
						xmlParserData.setXmlString((OutputXML));
						String status_get = xmlParserData.getVal("MainCode");
						if (status_get.equalsIgnoreCase("0")) {
							KYC_Remediation.mLogger.debug("Related Party WI moved successfullly...");
						String assignInputXML = "<?xml version=\"1.0\"?><WMAssignWorkItemAttributes_Input>"
	                            + "<Option>WMAssignWorkItemAttributes</Option>"
	                            + "<EngineName>"+sCabname+"</EngineName>"
	                            + "<SessionId>"+sSessionId+"</SessionId>"
	                            + "<ProcessInstanceId>"+WIName+"</ProcessInstanceId>"
	                            + "<WorkItemId>"+WI_ID+"</WorkItemId>"
	                            + "<ActivityId>"+ActivityID+"</ActivityId>"
	                            + "<ProcessDefId>"+ProcessDefID+"</ProcessDefId>"
	                            + "<LastModifiedTime></LastModifiedTime>"
	                            + "<ActivityType></ActivityType>"
	                            + "<complete>D</complete>"
	                            + "<AuditStatus></AuditStatus>"
	                            + "<Comments></Comments>"
	                            + "<UserDefVarFlag>Y</UserDefVarFlag>"
	                            + "<Attributes>"+attTag+"</Attributes>"
	                            + "</WMAssignWorkItemAttributes_Input>";
						KYC_Remediation.mLogger.debug("assignInputXML--->"+assignInputXML);
						String sOutputXML = ExecuteQueryOnServer(assignInputXML, iform);
						KYC_Remediation.mLogger.debug("sOutputXML--->"+sOutputXML);
						xmlParserData.setXmlString((sOutputXML));
						String status = xmlParserData.getVal("MainCode");
						if (status.equalsIgnoreCase("0")) {
							KYC_Remediation.mLogger.debug("Related Party WI moved successfullly...");
							}
						}
						else{
							KYC_Remediation.mLogger.debug("Error in get WI CAll...");
						}
					}
				}
				
				KYC_Remediation.mLogger.debug("InsertIntoHistory : Try ");
				
				JSONArray jsonArray=new JSONArray();
				JSONObject obj=new JSONObject();
				
				Date d = new Date();
				SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String strDate = dateFormat.format(d);
			    
			    KYC_Remediation.mLogger.debug("strDate: " +strDate);
			    
			    String EntryDateTime = (String) iform.getValue("EntryAt");
			    Date dt = dateFormat.parse(EntryDateTime);
			    String EntryAt = dateFormat.format(dt);
			    KYC_Remediation.mLogger.debug("EntryAt: " +EntryAt);
			    
				obj.put("Date Time",strDate);
				obj.put("Entry Date Time",EntryAt);
				obj.put("Workstep",iform.getActivityName());
				obj.put("Decision",iform.getValue("DECISION"));
				obj.put("User Name", iform.getUserName());
				obj.put("Remarks", iform.getValue("Remarks"));
				
				KYC_Remediation.mLogger.debug("Decision: " +iform.getValue("Decision"));
				KYC_Remediation.mLogger.debug("Remarks_dec: " +iform.getValue("Remarks_dec"));
				KYC_Remediation.mLogger.debug("Entry Date Time: " +iform.getValue("EntryDateTime"));
				KYC_Remediation.mLogger.debug("Entry At: " +iform.getValue("EntryAt"));
				
				
				jsonArray.add(obj);
				iform.addDataToGrid("DECISION_HISTORY", jsonArray);
				KYC_Remediation.mLogger.debug("jsonArray : "+jsonArray);
				strReturn = "INSERTED";
				
				KYC_Remediation.mLogger.debug("WINAME: "+getWorkitemName(iform)+", WSNAME: "+iform.getActivityName()+", ControlName: "+controlName+", WI Histroy Added Successfully!");
			} 
			catch (Exception e) {
				KYC_Remediation.mLogger.debug("Exception in inserting WI History!" + e.getMessage());
			}
		}
		return strReturn;
	}
}