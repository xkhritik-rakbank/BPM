package com.newgen.iforms.user;

import java.util.List;

import com.newgen.iforms.custom.IFormReference;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.omni.wf.util.app.NGEjbClient;

public class NBTL_CommonMethods {
	
	private static String wiName = null;
	private static String activityName = null;
	
	 public static String getWorkitemName(IFormReference iformObj) {
	        return ((iformObj).getObjGeneralData()).getM_strProcessInstanceId();
	    }
	public static String OnDecisionChange(IFormReference ifr,String Decision, String data)
	{
		wiName = NBTL_CommonMethods.getWorkitemName(ifr);
		activityName = ifr.getActivityName();
		NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision+"inside OnDecisionChange");
		try {
		ifr.setStyle("Remarks","visible","false");
		ifr.setValue("Remarks", "");
		ifr.setStyle("DiscardReason","mandatory","false");
		ifr.setStyle("DiscardReason","disable","true");
		ifr.setValue("DiscardReason", "");
		if(Decision.equalsIgnoreCase("Approve with Profile Change"))
		{
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision);
			String remark = "";
			boolean flag = false;
			String companyName = (String) ifr.getValue("CompanyNamePCReqCheckbox");
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision+"companyNamecheckbox"+companyName);
			/*String TLNumber = (String) ifr.getValue("TLNoPCReqCheckbox");
			NBTL.mLogger.info("TLNumbercheckbox"+companyName);*/
			String CompanyLegalStatus = (String) ifr.getValue("CompanyLegalStatusPCReqCheckbox");
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision+"CompanyLegalStatuscheckbox"+CompanyLegalStatus);
			String TLExpiry = (String) ifr.getValue("TLExpiryDatePCReqCheckbox");
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision+"TLExpiryDatePCReqCheckbox"+TLExpiry);
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision+"data"+data);
			int rowCount = Integer.parseInt(data);
			
			for(int i=0;i<rowCount;i++)
			{
				String shareHolderName = ifr.getTableCellValue("ShareholderGrid",i,5);
				if(shareHolderName.equalsIgnoreCase("true"))
				{
					flag = true;
					break;
				}
			}
			ifr.setStyle("Remarks","visible","true");
			if(companyName.equalsIgnoreCase("true"))
			{
				remark = remark.concat("Company Name Changed \n");
			}
			if(TLExpiry.equalsIgnoreCase("true"))
			{
				remark = remark.concat("TL Expiry Date Changed \n");
			}
			if(CompanyLegalStatus.equalsIgnoreCase("true"))
			{
				remark = remark.concat("Company Legal Status Changed \n");
			}
			if(flag == true)
			{
				remark = remark.concat("ShareHolder Name Changed \n");
			}
			ifr.setValue("Remarks", remark);
		}
		else if(Decision.equalsIgnoreCase("Discard"))
		{
			ifr.setStyle("DiscardReason","visible","true");
			ifr.setStyle("DiscardReason","mandatory","true");
			ifr.setStyle("DiscardReason","disable","false");
		}
		}
		catch (Exception e){
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Decision-->"+Decision+ e);
			}
		return "";
	}
	public static String checkboxFieldsValidations(IFormReference ifr)
	{
		ifr.setStyle("CompanyNamePCReqCheckbox","disable","false");
		ifr.setStyle("TLExpiryDatePCReqCheckbox","disable","false");
		ifr.setStyle("CompanyLegalStatusPCReqCheckbox","disable","false");
		try{
		String wiName = getWorkitemName(ifr);
		NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside checkboxFieldsValidations");
		String companyChanged = (String) ifr.getValue("IsCompanyNameChanged");
        String TLNumberChanged = (String) ifr.getValue("IsTLNoChanged");
        String TLExpiryChanged = (String) ifr.getValue("IsExpiryDateChanged");
        String LegalStatusChanged = (String) ifr.getValue("IsLegalStatusChanged");
        String query = "Select IsShareholderNameChanged from USR_0_NBTL_SHAREHOLDER_GRID_DET with(nolock) WHERE WINAME = '"+wiName+"'";
        List<List<String>> dataFromDB = ifr.getDataFromDB(query);
		for (List<String> listValue : dataFromDB) {
			for (String valueIs : listValue) {
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" share holder name changed value is----------" +valueIs);
			ifr.setColumnDisable("ShareholderGrid", "5", false);
			if(valueIs.equalsIgnoreCase("Y"))
			{
				int i = 0;
				NBTL.mLogger.info("inside if , value of i is--->"+i);
				ifr.setTableCellValue("ShareholderGrid",i,5,"true");
				i++;
			}	
		}
		}
        
        if(companyChanged.equalsIgnoreCase("Y"))
        {
        	ifr.setValue("CompanyNamePCReqCheckbox","true");
        	ifr.setStyle("TobeCompanyName","fontcolor","990033");

        }
        if(TLNumberChanged.equalsIgnoreCase("Y"))
        {
        	ifr.setValue("TLNoPCReqCheckbox","true");
        }
        if(TLExpiryChanged.equalsIgnoreCase("Y"))
        {
        	ifr.setValue("TLExpiryDatePCReqCheckbox","true");
        	ifr.setStyle("ToBeExpiryDate","fontcolor","990033");
        }
        if(LegalStatusChanged.equalsIgnoreCase("Y"))
        {
        	ifr.setValue("CompanyLegalStatusPCReqCheckbox","true");
        	ifr.setStyle("ToBeCompanyLegalStatus","fontcolor","990033");
        }
		}
		catch (Exception e){
			NBTL.mLogger.info(e);
			}
        return "";
	}
	public static String loadDecision(IFormReference ifr,String rowCount)
	{
		NBTL.mLogger.info("inside load decision--");
		try 
		{
			ifr.setValue("Decision","");
			String ActivityName = ifr.getActivityName();
			if(!(ActivityName.equalsIgnoreCase("OPS_Review")))
			{
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside other than OPS_Review");
				ifr.clearCombo("Decision");
				String query = "Select Decision from USR_0_NBTL_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME = '"+ActivityName+"'";
				@SuppressWarnings("unchecked")
				List<List<String>> dataFromDB = ifr.getDataFromDB(query);
				for (List<String> listValue : dataFromDB) 
				{
					for (String valueIs : listValue) 
					{
						NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Combo value is    ----------" +valueIs);
						ifr.addItemInCombo("Decision", valueIs);	
					}
				}
			}
			else if(ActivityName.equalsIgnoreCase("OPS_Review"))
			{
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside OPS_Review");
				String shareholderName = null;
				int count = 0;
				Integer introwCount = Integer.parseInt(rowCount);
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" introwCount---->"+introwCount);
				for(int i = 0;i<introwCount;i++)
				{
					shareholderName = ifr.getTableCellValue("ShareholderGrid",i,5);
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" shareholderName---->"+shareholderName);
					if(shareholderName.equalsIgnoreCase("true"))
					{
						count++;
						NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" count---->"+count);
						break;
					}
				}
				if(count>0)
				{
					shareholderName = "true";
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" shareholderName---->"+shareholderName);
				}
				String companyName = (String) ifr.getValue("CompanyNamePCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" companyName--"+companyName);
				String TLExpiryDatePCReqCheckbox = (String) ifr.getValue("TLExpiryDatePCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" TLExpiryDatePCReqCheckbox----"+TLExpiryDatePCReqCheckbox);
				String CompanyLegalStatus = (String) ifr.getValue("CompanyLegalStatusPCReqCheckbox");
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" CompanyLegalStatus-----"+CompanyLegalStatus);
				if(TLExpiryDatePCReqCheckbox.equalsIgnoreCase("true") && !companyName.equalsIgnoreCase("true") && !shareholderName.equalsIgnoreCase("true") &&
						 !CompanyLegalStatus.equalsIgnoreCase("true"))
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside OPS_Review else if 1");
					ifr.clearCombo("Decision");
					ifr.addItemInCombo("Decision","Approve","Approve");
					ifr.addItemInCombo("Decision","Discard","Discard");
				}
				else if(TLExpiryDatePCReqCheckbox.equalsIgnoreCase("true") && (companyName.equalsIgnoreCase("true") || shareholderName.equalsIgnoreCase("true") ||
					     CompanyLegalStatus.equalsIgnoreCase("true"))) 
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside OPS_Review true scenario 2");
					ifr.clearCombo("Decision");
					ifr.addItemInCombo("Decision","Approve with Profile Change","Approve with Profile Change");
					ifr.addItemInCombo("Decision","Discard","Discard");
				}
				else if(companyName.equalsIgnoreCase("true") || shareholderName.equalsIgnoreCase("true") ||
						TLExpiryDatePCReqCheckbox.equalsIgnoreCase("true") || CompanyLegalStatus.equalsIgnoreCase("true")) 
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside OPS_Review true scenario 3");
					ifr.clearCombo("Decision");
					ifr.addItemInCombo("Decision","Approve with Profile Change","Approve with Profile Change");
					ifr.addItemInCombo("Decision","Discard","Discard");
				}
				else 
				{
					NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside OPS_Review else 4");
					ifr.clearCombo("Decision");
					ifr.addItemInCombo("Decision","Approve","Approve");
					ifr.addItemInCombo("Decision","Discard","Discard");
				}
			 }
		}
		catch (Exception e)
		{
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Exception in load decision:- "+e.toString());
		}
		return "";
	}
	
	public static String getOldTL(IFormReference ifr)
	{
		try{
		NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+wiName +" inside getOLdTL---");
		String winame = (ifr.getObjGeneralData()).getM_strProcessInstanceId();
		String cif = (String)ifr.getValue("CorporateCIF");
		NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+wiName +" cif-----"+cif);
		String TLCifFoundStatus = "";
		
			String sJtsIp = null;
			String iJtsPort = null;//check
			XMLParser xmlParser=new XMLParser();
			String status="-1";
			
			sJtsIp = (ifr.getObjGeneralData()).getM_strJTSIP();//check
			iJtsPort = (ifr.getObjGeneralData()).getM_strJTSPORT();//check
			String cabinetName = ifr.getCabinetName();
			String sessionID = (ifr.getObjGeneralData()).getM_strDMSSessionId();
			String extTableName = "RB_NBTL_EXTTABLE";
			String itemIndex = "";
			String folderIndexquery = "Select FolderIndex from pdbfolder with(nolock) where Name = '"+winame+"'";
			NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+wiName +" query-----"+folderIndexquery);
			List<List<String>> folderIndex = ifr.getDataFromDB(folderIndexquery);
			NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+wiName +" dataFromDB for folder index-----"+folderIndex);
			String parentFolderINdex = folderIndex.get(0).get(0);
			//---------------
			String query = "select TOP 1 RTE.cif_num,PDC.parentfolderindex,PDC.documentINDEX,PD.imageINdex,PD.name,PD.appName,PD.volumeID,PD.DocumentSize from pdbdocumentcontent PDC with(nolock) , rb_tl_exttable RTE with(nolock),PDBDOCUMENT PD with(nolock) where PDC.parentfolderindex=RTE.itemINdex and PD.documentIndex=PDC.documentINDEX and RTE.cif_num='"+cif+"' and PD.name=ltrim(rtrim('New_Trade_License')) order by RTE.intoducedAt desc, PD.createddatetime desc";
			NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+wiName +" query-----"+query);
			List<List<String>> dataFromDB = ifr.getDataFromDB(query);
			NBTL.mLogger.debug("ActivityName-->"+activityName+" WI_Name-->"+wiName +" dataFromDB-----"+dataFromDB);
			//String parentFolderINdex = dataFromDB.get(0).get(1);
			String documentINdex = dataFromDB.get(0).get(2);
			String imageINdex = dataFromDB.get(0).get(3);
			String docName = dataFromDB.get(0).get(4);
			String appName = dataFromDB.get(0).get(5).trim();
			String volumeID = dataFromDB.get(0).get(6);
			String documentSize = dataFromDB.get(0).get(7);
			String DocumentType = "";
			String isIndex = imageINdex+"#"+volumeID;
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" isIndex---->"+isIndex);
		
			if(appName.equalsIgnoreCase("JPG") || appName.equalsIgnoreCase("TIF") || appName.equalsIgnoreCase("JPEG") || appName.equalsIgnoreCase("TIFF") || appName.equalsIgnoreCase("PNG"))
			{
				DocumentType = "I";
			}
			else
			{
				DocumentType = "N";
			}
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" DocumentType---->"+DocumentType);
			String getNGOAddDocument_InputputXML = getNGOAddDocument(parentFolderINdex,docName,DocumentType,appName,isIndex,documentSize,volumeID,cabinetName,sessionID);
			String getNGOAddDocument_OutputXML = ExecuteQueryOnServer(ifr,getNGOAddDocument_InputputXML);
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" getNGOAddDocument_OutputXML---->"+getNGOAddDocument_OutputXML);
			xmlParser.setInputXML(getNGOAddDocument_OutputXML);
			if(xmlParser.getValueOf("Status").equalsIgnoreCase("0"))
			{
				status = "0";
				NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +" Document added successfully");
				return "0000~"+getNGOAddDocument_OutputXML;
			}
			NBTL.mLogger.info("ActivityName-->"+activityName+" WI_Name-->"+wiName +"-------------DID NOT RETURN----");
		}catch(Exception e){
			NBTL.mLogger.info(e.getMessage());
		}
		return "false";
	}
	public static String getNGOAddDocument(String parentFolderIndex, String strDocumentName,String DocumentType,String strExtension,
			String sISIndex,String lstrDocFileSize, String volumeID, String cabinetName, String sessionId)
	{
		StringBuffer ipXMLBuffer=new StringBuffer();

		ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
		ipXMLBuffer.append("<NGOAddDocument_Input>\n");
		ipXMLBuffer.append("<Option>NGOAddDocument</Option>");
		ipXMLBuffer.append("<CabinetName>");
		ipXMLBuffer.append(cabinetName);
		ipXMLBuffer.append("</CabinetName>\n");
		ipXMLBuffer.append("<UserDBId>");
		ipXMLBuffer.append(sessionId);
		ipXMLBuffer.append("</UserDBId>\n");
		ipXMLBuffer.append("<GroupIndex>0</GroupIndex>\n");
		ipXMLBuffer.append("<Document>\n");
		ipXMLBuffer.append("<VersionFlag>N</VersionFlag>\n");
		ipXMLBuffer.append("<ParentFolderIndex>");
		ipXMLBuffer.append(parentFolderIndex);
		ipXMLBuffer.append("</ParentFolderIndex>\n");
		ipXMLBuffer.append("<DocumentName>");
		ipXMLBuffer.append("Previous Year TL");
		ipXMLBuffer.append("</DocumentName>\n");
		ipXMLBuffer.append("<VolumeIndex>");
		ipXMLBuffer.append(volumeID);
		ipXMLBuffer.append("</VolumeIndex>\n");
		ipXMLBuffer.append("<ISIndex>");
		ipXMLBuffer.append(sISIndex);
		ipXMLBuffer.append("</ISIndex>\n");
		ipXMLBuffer.append("<NoOfPages>1</NoOfPages>\n");
		ipXMLBuffer.append("<DocumentType>");
		ipXMLBuffer.append(DocumentType);
		ipXMLBuffer.append("</DocumentType>\n");
		ipXMLBuffer.append("<DocumentSize>");
		ipXMLBuffer.append(lstrDocFileSize);
		ipXMLBuffer.append("</DocumentSize>\n");
		ipXMLBuffer.append("<CreatedByAppName>");
		ipXMLBuffer.append(strExtension);
		ipXMLBuffer.append("</CreatedByAppName>\n");
		ipXMLBuffer.append("</Document>\n");
		ipXMLBuffer.append("</NGOAddDocument_Input>\n");
		return ipXMLBuffer.toString();
    }
	
	public String getTagValues(String sXML, String sTagName) 
	{
		String sTagValues = "";
		String sStartTag = "<" + sTagName + ">";
		String sEndTag = "</" + sTagName + ">";
		String tempXML = sXML;
		try {
			for (int i = 0; i < sXML.split(sEndTag).length - 1; i++) {
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += tempXML.substring(tempXML.indexOf(sStartTag)
							+ sStartTag.length(), tempXML.indexOf(sEndTag));
							
					tempXML = tempXML.substring(tempXML.indexOf(sEndTag)
							+ sEndTag.length(), tempXML.length());
				}
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += ",";
				}
			}
		} catch (Exception e) {
			NBTL.mLogger.debug("Exception: " + e.getMessage());
		}
		return sTagValues;
	}
	
	public static String ExecuteQueryOnServer(IFormReference ifr, String inputXML){
		try{
		NBTL.mLogger.debug("Serverr IP----"+ifr.getServerIp());
		NBTL.mLogger.debug("SERVER PORT---"+ifr.getServerPort());
		NBTL.mLogger.debug("inputXML---"+inputXML);
		
		return  NGEjbClient.getSharedInstance().makeCall(ifr.getServerIp(),ifr.getServerPort()+"","WEBSPHERE", inputXML);
		 
		}catch(Exception e){
			return "Exception in executing API on Server--"+e;
		}
	}
}
