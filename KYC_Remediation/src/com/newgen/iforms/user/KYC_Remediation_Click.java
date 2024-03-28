package com.newgen.iforms.user;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import com.newgen.iforms.custom.IFormReference;
import com.newgen.iforms.xmlapi.IFormXmlResponse;

public class KYC_Remediation_Click extends KYC_Remediation_Common {

	public String clickEvent(IFormReference iform, String controlName, String data) throws FileNotFoundException, IOException, ParserConfigurationException, SAXException 
	{
		KYC_Remediation.mLogger.debug("KYC_Remediation_Clicks");
		KYC_Remediation.mLogger.debug("WINAME : " + getWorkitemName(iform) + ", WSNAME: " + getActivityName(iform) + ", controlName " + controlName + ", data " + data);
		KYC_Remediation.mLogger.debug("controlName" + controlName);
		String response="";
		KYC_Remediation.mLogger.debug("onclickevent : control : " + controlName + " StringData :" + data);
		String MQ_response = "";
		try{
		if(controlName.equalsIgnoreCase("Risk_score_trigger")) {
			KYC_Remediation.mLogger.debug("onclickevent : Risk_score_trigger :");
			String finalXml = "";
		
			finalXml = RISK_SCORE_DETAILS(iform);

			MQ_response = KYC_Remediation_Integration.MQ_connection_response(iform, controlName, data, finalXml);
			KYC_Remediation.mLogger.debug("onclickevent : Risk_score_trigger : MQ_response: " + MQ_response);
			// code to set the risk score
			MQ_response = MQ_response.substring(MQ_response.indexOf("<?xml v"), MQ_response.indexOf("</MQ_RESPONSE_XML>"));

			Document doc = MapXML.getDocument(MQ_response);
			KYC_Remediation.mLogger.debug("onclickevent : Risk_score_trigger :" + MQ_response);
			String strCode = doc.getElementsByTagName("ReturnCode").item(0).getTextContent();
			KYC_Remediation.mLogger.debug("onclickevent : Risk_score_trigger : ReturnCode: " + strCode);
			String strDesc = doc.getElementsByTagName("ReturnDesc").item(0).getTextContent();
			KYC_Remediation.mLogger.debug("onclickevent : Risk_score_trigger : ReturnDesc: " + strDesc);
			String riskScore = doc.getElementsByTagName("TotalRiskScore").item(0).getTextContent();
			KYC_Remediation.mLogger.debug("onclickevent : Risk_score_trigger : ReturnDesc: " + strDesc);
			String  CaseType = (String)iform.getValue("CaseType");
			iform.setValue("RiskProfile",riskScore);
			iform.setValue("EntityRiskProfile",riskScore);
			
			String Res="";
			// risk sheet generation - Start 
			String PdfName="Risk_Score_Details";
			String Status=createPDF(iform,"Risk_Score",getWorkitemName(iform),PdfName);
			KYC_Remediation.mLogger.debug("WINAME : "+getWorkitemName(iform)+", WSNAME: "+getActivityName(iform)+", Status : "+Status);

			if(!Status.contains("Error")){
				Res=AttachDocumentWithWI(iform,getWorkitemName(iform),PdfName);
				KYC_Remediation.mLogger.debug(" No Error in RISK PDF Gen :  Res"+Res);
				KYC_Remediation.mLogger.debug("No Error in RISK PDF Gen :  Res"+strCode+"~"+strDesc+"~"+Res);
				//return strCode+"~"+strDesc+"~"+Res;
				return Res;
			}
			else{
				KYC_Remediation.mLogger.debug("Error in RISK PDF Gen :  Res"+strCode+"~"+Status+"~"+strDesc);
				return Res=strCode+"~"+Status;
			}
		}
		else if (controlName.equalsIgnoreCase("KYC_Download")){
			 String Res = "";
			 String PdfName = "";
			 String caseType = (String)iform.getValue("CaseType");
			 if(caseType.equalsIgnoreCase("Individual")){
				 PdfName="KYC_Form";
			 }
			 if(caseType.equalsIgnoreCase("Corporate")){
				 PdfName="KYC_Form_Corporate";
			}
			 if(caseType.equalsIgnoreCase("RelatedParty")){
				 PdfName="KYC_Form_RP";
			 }
			String output = generateApplicationFrom("KYC_Form",getWorkitemName(iform),getSessionId(iform),iform);
			if(output.contains("Success")){
				Res= AttachKYC_FormWithWI(iform,getWorkitemName(iform),PdfName);
				KYC_Remediation.mLogger.debug(" No Error in RISK PDF Gen :  Res"+Res);
				KYC_Remediation.mLogger.debug("No Error in RISK PDF Gen :  Res");
				//return strCode+"~"+strDesc+"~"+Res;
				return Res;
			}
		 }
		else if (controlName.equalsIgnoreCase("SignedDate"))
		{
			String signedDate = (String)iform.getValue("SignedDate");
			DateTimeFormatter inputformatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
			LocalDate localDate = LocalDate.parse(signedDate,inputformatter);
			LocalDate newDate = localDate.plusYears(3);
			DateTimeFormatter outputformatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
			String outputDate = newDate.format(outputformatter);
			iform.setValue("ExpiryDate",outputDate);	
		}
		else if (controlName.equalsIgnoreCase("PassportIssueDate"))
		{
			String expiryDate = (String)iform.getValue("PassportExpiryDate");
			if(!expiryDate.equalsIgnoreCase("")){
			//LocalDate currentDate = LocalDate.now();
			String issueDate = (String)iform.getValue("PassportIssueDate");
			LocalDate date1 = LocalDate.parse(issueDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			LocalDate date2 = LocalDate.parse(expiryDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			if(date1.isAfter(date2)){
				iform.setValue("PassportIssueDate", "");
				return "IssueDateGreater";
			}
			long yearsBetween = ChronoUnit.DAYS.between(date1,date2);
			//LocalDate tenYearsAgo = LocalDate.now().minusYears(10).minusDays(15);
			if(yearsBetween>(10*365)+15){
				iform.setValue("PassportIssueDate", "");
				return "beforedate";
			}
			}
			return "afterDate";
		}
		else if (controlName.equalsIgnoreCase("PassportExpiryDate"))
		{
			String issueDate = (String)iform.getValue("PassportIssueDate");
			String expiryDate = (String)iform.getValue("PassportExpiryDate");
			LocalDate date1 = LocalDate.parse(issueDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			LocalDate date2 = LocalDate.parse(expiryDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			if(date2.isBefore(date1)){
				iform.setValue("PassportExpiryDate","");
				return "ExpiryDateLess";
			}
			long yearsBetween = ChronoUnit.DAYS.between(date1,date2);
			if(yearsBetween<(10*365)+15){
				return "lessThan10Years";
			}
			iform.setValue("PassportExpiryDate","");
			return "moreThan10Years";
		}
		else if (controlName.equalsIgnoreCase("OwnerPassportIssueDate"))
		{
			String issueDate = (String)iform.getValue("OwnerPassportIssueDate");
			LocalDate date = LocalDate.parse(issueDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			LocalDate tenYearsAgo = LocalDate.now().minusYears(10).minusDays(15);
			if(date.isBefore(tenYearsAgo)){
				iform.setValue("OwnerPassportIssueDate", "");
				return "beforedate";
			}
			return "afterDate";
		}
		else if (controlName.equalsIgnoreCase("OwnerPassportExpiryDate"))
		{
			String issueDate = (String)iform.getValue("OwnerPassportIssueDate");
			String expiryDate = (String)iform.getValue("OwnerPassportExpiryDate");
			LocalDate date1 = LocalDate.parse(issueDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			LocalDate date2 = LocalDate.parse(expiryDate,DateTimeFormatter.ofPattern("dd/MM/yyyy"));
			long yearsBetween = ChronoUnit.DAYS.between(date1,date2);
			if(yearsBetween<(10*365)+15){
				return "lessThan10Years";
			}
			/*Period period = Period.between(date1,date2);
			boolean islessThan10yearsDifference = period.getYears() < 10 || (period.getYears() == 10 && (period.getMonths()>0 || period.getDays()>0));
			if(islessThan10yearsDifference){
				return "lessThan10Years";
			}*/
			iform.setValue("OwnerPassportExpiryDate","");
			return "moreThan10Years";
		}
		else if(controlName.equalsIgnoreCase("WI_Open"))
		{
			IFormXmlResponse xmlParserData = new IFormXmlResponse();
			StringBuffer ipXMLBuffer=new StringBuffer();
			String sCabname = getCabinetName(iform);
			KYC_Remediation.mLogger.debug("sCabname" + sCabname);
			String sSessionId = getSessionId(iform);
			KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
			
			int rowIndex = Integer.parseInt(data);
			String WINAme = iform.getTableCellValue("table4",rowIndex,1);
			//updateWInameInext(iform,WINAme);
			String columnNames="VAR_STR1";
			String columnValues="'ToVisible'";
			String sWhereClause ="ProcessInstanceID ='"+WINAme+"'";
			
			KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
			
			ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
			ipXMLBuffer.append("<APUpdate_Input>\n");
			ipXMLBuffer.append("<Option>APUpdate</Option>\n");
			ipXMLBuffer.append("<TableName>");
			ipXMLBuffer.append("WFINSTRUMENTTABLE");
			ipXMLBuffer.append("</TableName>\n");
			ipXMLBuffer.append("<ColName>");
			ipXMLBuffer.append(columnNames);
			ipXMLBuffer.append("</ColName>\n");
			ipXMLBuffer.append("<Values>");
			ipXMLBuffer.append(columnValues);
			ipXMLBuffer.append("</Values>\n");
			ipXMLBuffer.append("<WhereClause>");
			ipXMLBuffer.append(sWhereClause);
			ipXMLBuffer.append("</WhereClause>\n");
			ipXMLBuffer.append("<EngineName>");
			ipXMLBuffer.append(sCabname);
			ipXMLBuffer.append("</EngineName>\n");
			ipXMLBuffer.append("<SessionId>");
			ipXMLBuffer.append(sSessionId);
			ipXMLBuffer.append("</SessionId>\n");
			ipXMLBuffer.append("</APUpdate_Input>");
			
			String apUpdateinput = ipXMLBuffer.toString();
			KYC_Remediation.mLogger.debug("apUpdateinput--->"+apUpdateinput);
			String OutputXML = ExecuteQueryOnServer(apUpdateinput, iform);
			KYC_Remediation.mLogger.debug("sOutputXML--->"+OutputXML);
			xmlParserData.setXmlString((OutputXML));
			String status_get = xmlParserData.getVal("MainCode");
			KYC_Remediation.mLogger.debug("status for wf table--->"+status_get);
			
			String query = "Select CONST_FIELD_VALUE from USR_0_BPM_CONSTANTS where CONST_FIELD_NAME = 'KYC_Rem_IP_PORT'";
			List<List<String>> query_output = iform.getDataFromDB(query);
			KYC_Remediation.mLogger.debug("query_output--:"+query_output);
			String  IpPort = query_output.get(0).get(0);
			String userName = getUserName(iform);
			String userIndexquery = "Select UserIndex from pdbuser where username = '"+userName+"'";
			List<List<String>> userIndexqueryOutput = iform.getDataFromDB(userIndexquery);
			KYC_Remediation.mLogger.debug("query_output--:"+query_output);
			String  UserIndex = userIndexqueryOutput.get(0).get(0);
			return IpPort+"-"+UserIndex;
			
		}
		}catch(Exception e){
			KYC_Remediation.mLogger.debug("Exception in click event--:"+e);
			return "false";
		}
		return "";
	}
	public String updateWInameInext(IFormReference iform,String WINAme){
		IFormXmlResponse xmlParserData = new IFormXmlResponse();
		StringBuffer ipXMLBuffer=new StringBuffer();
		String sCabname = getCabinetName(iform);
		KYC_Remediation.mLogger.debug("sCabname" + sCabname);
		String sSessionId = getSessionId(iform);
		KYC_Remediation.mLogger.debug("sSessionId" + sSessionId);
		iform.setValue("Mandatory_Field_List", WINAme);
		String columnNames="Mandatory_Field_List";
		String columnValues="'"+WINAme+"'";
		String sWhereClause ="WINAME ='"+WINAme+"'";
		
		ipXMLBuffer.append("<?xml version=\"1.0\"?>\n");
		ipXMLBuffer.append("<APUpdate_Input>\n");
		ipXMLBuffer.append("<Option>APUpdate</Option>\n");
		ipXMLBuffer.append("<TableName>");
		ipXMLBuffer.append("RB_KYC_REM_EXTTABLE");
		ipXMLBuffer.append("</TableName>\n");
		ipXMLBuffer.append("<ColName>");
		ipXMLBuffer.append(columnNames);
		ipXMLBuffer.append("</ColName>\n");
		ipXMLBuffer.append("<Values>");
		ipXMLBuffer.append(columnValues);
		ipXMLBuffer.append("</Values>\n");
		ipXMLBuffer.append("<WhereClause>");
		ipXMLBuffer.append(sWhereClause);
		ipXMLBuffer.append("</WhereClause>\n");
		ipXMLBuffer.append("<EngineName>");
		ipXMLBuffer.append(sCabname);
		ipXMLBuffer.append("</EngineName>\n");
		ipXMLBuffer.append("<SessionId>");
		ipXMLBuffer.append(sSessionId);
		ipXMLBuffer.append("</SessionId>\n");
		ipXMLBuffer.append("</APUpdate_Input>");
		
		String apUpdateinput = ipXMLBuffer.toString();
		KYC_Remediation.mLogger.debug("apUpdateinput--->"+apUpdateinput);
		String OutputXML = ExecuteQueryOnServer(apUpdateinput, iform);
		KYC_Remediation.mLogger.debug("sOutputXML--->"+OutputXML);
		xmlParserData.setXmlString((OutputXML));
		String status_get = xmlParserData.getVal("MainCode");
		KYC_Remediation.mLogger.debug("status for wf table--->"+status_get);
		return "";
		
	}
}
