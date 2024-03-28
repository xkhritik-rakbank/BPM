<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank Telegraphic Transfer
//Module                     : Integration Calls 
//File Name					 : TFIntegration.jsp
//Author                     : Sivakumar,Akshaya
//Date written (DD/MM/YYYY)  : 28-06-2018
//Description                : File to handle all the integration calls for TF process (Initial Draft)
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------
Revision 	Date 			Author 			Description
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TF_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%!
	public static String readFileFromServer(String filename)
	{
		String xmlReturn="";
		try {
			File file = new File(filename);
			FileReader fileReader = new FileReader(file);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
			StringBuffer stringBuffer = new StringBuffer();
			String line;
			while ((line = bufferedReader.readLine()) != null) {
				stringBuffer.append(line);
				stringBuffer.append("\n");
			}
			fileReader.close();
			System.out.println("Contents of file:");
			xmlReturn = stringBuffer.toString();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		return xmlReturn;
	}
%>
<%
	int relatedCIFCount=0;
	String sInputXML = "";
	String sMappOutPutXML = "";
	try{
		 WriteLog("\nInside TF Integration.jsp\n");
			
		String requestType = request.getParameter("request_type");
		String wi_name = request.getParameter("wi_name");
		String cif_type = request.getParameter("cif_type");
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String SubscriptionFlag="N";
		String subval = "";
		String sFlag = "";
		String ResAddress1 = "";
		String OffcAddress1 = "";
		String ResPobox = "";
		String OffcPobox = "";
		
		WriteLog("\nInside TF Integration.jsp ,request Type - "+requestType+" for wi_name "+wi_name);
		
		if (requestType.equals("ENTITY_DETAILS"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";		
			String ACCNumber = request.getParameter("Account_Number");;
			String MobileNumber = request.getParameter("mobile_number");
			String EmiratesID = request.getParameter("Emirates_Id");
			String ACCType = request.getParameter("account_type"); // Hardcode
			String CIF_ID = request.getParameter("CIF_ID");
			String username=request.getParameter("user_name");
			String sessionId=sSessionId,engineName=sCabName;
			String ReturnCode = "";
			String FatcaReason = request.getParameter("FatcaReasonNew");
			String params = "";
			
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				//"<ProcessName>TF</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>saddd</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><ACCType>"+ACCType+"</ACCType><ACCNumber>"+ACCNumber+"</ACCNumber><EmiratesID>"+EmiratesID+"</EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";
			String inputXMLLog = maskXmlTags(inputEntityDetailsXML,"<ACCNumber>,<EmiratesID>");
			WriteLog("\ninputEntityDetailsXML on CIF Search for WINAME: "+wi_name+" : "+inputXMLLog);
			
			//UnComment the below code OFFSHORE for Integration - Starts here
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"TFTesting"+File.separator+"Entity_Details.txt");
			//Comment ends here
			
			//UnComment the below code ONSHORE for Integration - Starts here
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			//Comment ends here
			
			String outputXMLLog = maskXmlTags(sMappOutPutXML,"<ACCNumber>,<DOB>,<MothersName>,<IBANNumber>,<DocId>,<PassportNum>,<MotherMaidenName>,<LinkedDebitCardNumber>"); 
			WriteLog("\nOutputEntityDetailsXML on CIF Search for WINAME: "+wi_name+" : "+outputXMLLog);	
			
			
			
			//WriteLog("\nOutputEntityDetailsXML:\n"+sMappOutPutXML);	
			
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";			
			
			String rowVal="";
			String individual = "";
			String temp_table="";
			String Mainindividual = "";
			String IsPremium="";
			String ARMCode="";
			String CustomerSegment="";
			String MainCIFID ="";
			String CustomerSubSeg="";
			String PrimaryEmailId="";
			String strEmiratesID="";
			String strEmiratesIDExpDate="";
			int countwhilchk;
			
			/*if(sMappOutPutXML.contains("<EmailID>"))
			{
				PrimaryEmailId = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<EmailID>")+"</EmailID>".length()-1,sMappOutPutXML.indexOf("</EmailID>"));
				 WriteLog("\nPrimaryEmailId For Main CIF: "+PrimaryEmailId);
			}*/
			
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<EmailDet>"))
			{
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<EmailDet>"),sMappOutPutXML.indexOf("</EmailDet>")+"</EmailDet>".length());
				
				String MailPrefFlag = (rowVal.contains("<MailPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<MailPrefFlag>")+"</MailPrefFlag>".length()-1,rowVal.indexOf("</MailPrefFlag>")):"";
				WriteLog( "\nMailPrefFlag: "+MailPrefFlag);
				
				if(MailPrefFlag.equalsIgnoreCase("Y"))
				{
					PrimaryEmailId = (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
					WriteLog( "PrimaryEmailId For Main CIF~: "+PrimaryEmailId);
					break;
				}
				
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				}
				
			}
			
			
			// Start - block added to get EmirateId and EmirateId Expiry date by angad
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<DocumentDet>"))
			{
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<DocumentDet>"),sMappOutPutXML.indexOf("</DocumentDet>")+"</DocumentDet>".length());
				
				String DocType = (rowVal.contains("<DocType>")) ? rowVal.substring(rowVal.indexOf("<DocType>")+"</DocType>".length()-1,rowVal.indexOf("</DocType>")):"";
				WriteLog( "\nDocType: "+DocType);
				
				if(DocType.equalsIgnoreCase("EMID"))
				{
					strEmiratesID = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
					
					try{
						strEmiratesIDExpDate = rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>"));
						strEmiratesIDExpDate = strEmiratesIDExpDate.substring(8,10)+"/"+strEmiratesIDExpDate.substring(5,7)+"/"+strEmiratesIDExpDate.substring(0,4);
					}catch(Exception ex){
						strEmiratesIDExpDate="";
					}
					//WriteLog( "strEmiratesID~ "+strEmiratesID);
					//WriteLog( "strEmiratesIDExpDate~ "+strEmiratesIDExpDate);
				}
				
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				}
				
			}
				
			// End - block added to get EmirateId and EmirateId Expiry date by angad
						
			if(sMappOutPutXML.contains("<IsPremium>"))
			{
				IsPremium = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsPremium>")+"</IsPremium>".length()-1,sMappOutPutXML.indexOf("</IsPremium>"));
				 WriteLog("\nIsPremium: "+IsPremium);
				 //Start - Considering B as Y, Changes done on 07112017
				 if (IsPremium.equalsIgnoreCase("B"))
				 {
					IsPremium = "Y";
					WriteLog("\nIsPremium changed from B to Y : "+IsPremium);
				 }
				 //End - Considering B as Y, Changes done on 07112017
			}
			
			if(sMappOutPutXML.contains("<CustomerSubSeg>"))
			{
			CustomerSubSeg = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,sMappOutPutXML.indexOf("</CustomerSubSeg>"));

				 WriteLog("\nCustomerSubSeg: "+CustomerSubSeg);
			}
			if(sMappOutPutXML.contains("<ARMCode>"))
			{
				ARMCode = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ARMCode>")+"</ARMCode>".length()-1,sMappOutPutXML.indexOf("</ARMCode>"));

				 WriteLog("\nARMCode is:"+ARMCode);
			}
			if(sMappOutPutXML.contains("<CustomerSegment>"))
			{
				CustomerSegment = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerSegment>")+"</CustomerSegment>".length()-1,sMappOutPutXML.indexOf("</CustomerSegment>"));
				 WriteLog("\nCustomerSegment---"+CustomerSegment);
			}
			if(sMappOutPutXML.contains("<CIFID>"))
			{			
				MainCIFID = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CIFID>")+"</CIFID>".length()-1,sMappOutPutXML.indexOf("</CIFID>"));
				 WriteLog("\nMainCIFID"+MainCIFID);
			}
			String MainCIFType = "";
			String MainFullName="";
			if(sMappOutPutXML.contains("<FullName>"))
			{		
				MainFullName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FullName>")+"</FullName>".length()-1,sMappOutPutXML.indexOf("</FullName>"));
				//MainFullName=MainFullName.replaceAll(" ","#");
				 WriteLog("\nMainFullName"+MainFullName);
			}
			if(sMappOutPutXML.contains("<IsRetailCust>"))
			{	
				String tempStr=sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
				 WriteLog("\ntempStr"+tempStr);
				if(tempStr.equalsIgnoreCase("N"))
					Mainindividual = "Non-Individual";
				else
					Mainindividual = "Individual";
			}		
			String MainRadio = "<td><input type='radio' name='CifData' value="+"'"+MainCIFID+"#"+MainFullName+"#"+CustomerSubSeg+"#"+ARMCode+"#"+IsPremium+"#"+PrimaryEmailId+"#"+strEmiratesID+"#"+strEmiratesIDExpDate+"#"+Mainindividual+"'"+" id='"+Mainindividual+"' onclick='javascript:showDivForRadio(this);'></td>";
			temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'>"+MainRadio+"<td>"+MainCIFID+"</td><td>"+MainFullName+"</td><td>"+Mainindividual+"</td></tr>";	
			
			val_main = val_main + valRadio+"#"+MainCIFID+"#"+Mainindividual+"~";
			 WriteLog("\nval_main"+val_main);
			if(sMappOutPutXML.contains("<RelatedCIF>"))
			{
				MainCIFType = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
			}
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<RelatedCIF>"))
			{	
				row++;
				valRadio="row"+row+"_individual";	
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<RelatedCIF>"),sMappOutPutXML.indexOf("</RelatedCIF>")+"</RelatedCIF>".length());
				
				if(rowVal.contains("<IsRetailCust>N</IsRetailCust>"))
					individual = "Non-Individual";
				else
					individual = "Individual";	
				
				if(sMappOutPutXML.contains("<EmiratesID>"))
				{
					WriteLog("EmiratesId check");
					strEmiratesID = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<EmiratesID>")+"</EmiratesID>".length()-1,sMappOutPutXML.indexOf("</EmiratesID>"));
					// WriteLog("\nEmiratesID For Related CIF: "+EmiratesID);
					 WriteLog("\nEmiratesID For Related CIF: "+strEmiratesID);
				}
				WriteLog("EmiratesId check out ");
				
				String CIFID = rowVal.substring(rowVal.indexOf("<CIFID>")+"<CIFID>".length(),rowVal.indexOf("</CIFID>"));
				WriteLog("EmiratesId CIFID "+CIFID);
				String cust_name = rowVal.substring(rowVal.indexOf("<CustomerName>")+"<CustomerName>".length(),rowVal.indexOf("</CustomerName>"));
				//cust_name=cust_name.replaceAll(" ","#");
				WriteLog("cust_name cust_name "+cust_name);
				//String nameWithSpaceRomove=cust_name.replaceAll(" ","~");
				CustomerSubSeg = rowVal.substring(rowVal.indexOf("<CustomerSubSeg>")+"<CustomerSubSeg>".length(),rowVal.indexOf("</CustomerSubSeg>"));
				WriteLog("CustomerSubSeg "+CustomerSubSeg);
				if(sMappOutPutXML.contains("<PrimaryEmailId>"))
				{
				PrimaryEmailId=rowVal.substring(rowVal.indexOf("<PrimaryEmailId>")+"<PrimaryEmailId>".length(),rowVal.indexOf("</PrimaryEmailId>"));
				
				WriteLog("\nPrimaryEmailId----"+PrimaryEmailId);
				}
				String b = "<td><input type='radio' name='CifData' value="+"'"+CIFID+"#"+cust_name+"#"+CustomerSubSeg+"#"+ARMCode+"#"+IsPremium+"#"+PrimaryEmailId+"#"+strEmiratesID+"#"+strEmiratesIDExpDate+"#"+individual+"'"+"  id='"+individual+"' onclick='javascript:showDivForRadio(this);'></td>";
				
				temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'>"+b+"<td>"+CIFID+"</td><td>"+cust_name+"</td><td>"+individual+"</td></tr>";
				
				val_main = val_main + valRadio+"#"+CIFID+"#"+individual+"~";
				
				//sMappOutPutXML = sMappOutPutXML.replaceAll(rowVal, "");
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				//WriteLog(sMappOutPutXML);
				countwhilchk++;
				if(countwhilchk == 100)
				{
					
					countwhilchk = 0;
					break;
				}
				
			}
			
			
			String appendStr = "<table id='TFSearch' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th><b>Select</b></th><th><b>CIF Number</b></th><th><b>Name</b></th><th><b>CIF Type</b></th></tr>";
			
			if (!ReturnCode.equalsIgnoreCase("0000")){
				 WriteLog("\nReturnCode: "+ ReturnCode);
					out.clear();
				out.println("Exception");
			}
			else{
				out.clear();
				out.println(appendStr+temp_table+"</table>"+"^^^"+IsPremium+"^^^"+ARMCode+"^^^"+CustomerSegment+"^^^"+CustomerSubSeg+"^^^");
				WriteLog("CIF Search Completed");
				 //WriteLog(appendStr+temp_table+"</table>");
			}
		}
		
		// Start - Calling Entity Detail on Related CIF Radio Click added on 29052017
		if (requestType.equals("ENTITY_DETAILS_RADIOCLICK"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";		
			String ACCNumber = request.getParameter("Account_Number");;
			String MobileNumber = request.getParameter("mobile_number");
			String EmiratesID = request.getParameter("Emirates_Id");
			String ACCType = request.getParameter("account_type"); // Hardcode
			String CIF_ID = request.getParameter("CIF_ID");
			String username=request.getParameter("user_name");
			String sessionId=sSessionId,engineName=sCabName;
			String ReturnCode = "";
			String FatcaReason = request.getParameter("FatcaReasonNew");
			String params = "";
			
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				//"<ProcessName>TF</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				"<MsgVersion>0001</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>0000</ReturnCode>\n"+
				"<ReturnDesc>saddd</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><ACCType>"+ACCType+"</ACCType><ACCNumber>"+ACCNumber+"</ACCNumber><EmiratesID>"+EmiratesID+"</EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";
			String inputXMLLog = maskXmlTags(inputEntityDetailsXML,"<ACCNumber>,<EmiratesID>"); 
			WriteLog("\ninputEntityDetailsXML On Radio Click for WINAME: "+wi_name+" : "+inputXMLLog);
			
			//UnComment the below code ONSHORE for Integration - Starts here
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			// ONSHORE Code Ends here
			
			//UnComment the below code OFFSHORE for Integration - Starts here
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"TFTesting"+File.separator+"Entity_Details.txt");
			// OFFSHORE Code Ends here
			
			String outputXMLLog = maskXmlTags(sMappOutPutXML,"<ACCNumber>,<DOB>,<MothersName>,<IBANNumber>,<DocId>,<PassportNum>,<MotherMaidenName>,<LinkedDebitCardNumber>"); 
			WriteLog("\nOutputEntityDetailsXML On Radio Click for WINAME: "+wi_name+" : "+outputXMLLog);	
			
			
			//WriteLog("\nOutputEntityDetailsXML:\n"+sMappOutPutXML);	
			
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";			
			
			String rowVal="";
			String individual = "";
			String temp_table="";
			String Mainindividual = "";
			String IsPremium="";
			String ARMCode="";
			String CustomerSegment="";
			String MainCIFID ="";
			String CustomerSubSeg="";
			String PrimaryEmailId="";
			String strEmiratesID="";
			String strEmiratesIDExpDate="";
			String strTDLICNum="";
			String strTDLICExpDate="";
			String ResidentCountry="";
			
			String strAddress="";
			String strPhonenumber="";
			int countwhilchk;
						
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<EmailDet>"))
			{
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<EmailDet>"),sMappOutPutXML.indexOf("</EmailDet>")+"</EmailDet>".length());
				
				String MailPrefFlag = (rowVal.contains("<MailPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<MailPrefFlag>")+"</MailPrefFlag>".length()-1,rowVal.indexOf("</MailPrefFlag>")):"";
				WriteLog( "\nMailPrefFlag: "+MailPrefFlag);
				
				if(MailPrefFlag.equalsIgnoreCase("Y"))
				{
					PrimaryEmailId = (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
					WriteLog( "PrimaryEmailId For Main CIF~: "+PrimaryEmailId);
					break;
				}
				
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				}
				
			}
			
			
			// Start - block added to get EmirateId and EmirateId Expiry date by angad
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<DocumentDet>"))
			{
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<DocumentDet>"),sMappOutPutXML.indexOf("</DocumentDet>")+"</DocumentDet>".length());
				
				String DocType = (rowVal.contains("<DocType>")) ? rowVal.substring(rowVal.indexOf("<DocType>")+"</DocType>".length()-1,rowVal.indexOf("</DocType>")):"";
				WriteLog( "\nDocType: "+DocType);
				
				if(DocType.equalsIgnoreCase("EMID"))
				{
					strEmiratesID = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
					
					try{
						strEmiratesIDExpDate = rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>"));
						strEmiratesIDExpDate = strEmiratesIDExpDate.substring(8,10)+"/"+strEmiratesIDExpDate.substring(5,7)+"/"+strEmiratesIDExpDate.substring(0,4);
					}catch(Exception ex){
						strEmiratesIDExpDate="";
					}
					//WriteLog( "strEmiratesID~ "+strEmiratesID);
					//WriteLog( "strEmiratesIDExpDate~ "+strEmiratesIDExpDate);
				} else if(DocType.equalsIgnoreCase("TradeLicense"))
				{
					strTDLICNum = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
					
					try{
						strTDLICExpDate = rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>"));
						strTDLICExpDate = strTDLICExpDate.substring(8,10)+"/"+strTDLICExpDate.substring(5,7)+"/"+strTDLICExpDate.substring(0,4);
					}catch(Exception ex){
						strTDLICExpDate="";
					}
					WriteLog( "strTDLICNum~ "+strTDLICNum);
					WriteLog( "strTDLICExpDate~ "+strTDLICExpDate);
				}
				
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				}
				
			}
				
			// End - block added to get EmirateId and EmirateId Expiry date by angad
						
			if(sMappOutPutXML.contains("<IsPremium>"))
			{
				IsPremium = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsPremium>")+"</IsPremium>".length()-1,sMappOutPutXML.indexOf("</IsPremium>"));
				 WriteLog("\nIsPremium: "+IsPremium);
				 //Start - Considering B as Y, Changes done on 07112017
				 if (IsPremium.equalsIgnoreCase("B"))
				 {
					IsPremium = "Y";
					WriteLog("\nIsPremium changed from B to Y : "+IsPremium);
				 }
				 //End - Considering B as Y, Changes done on 07112017
			}
			if(sMappOutPutXML.contains("<CustomerSubSeg>"))
			{
			CustomerSubSeg = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,sMappOutPutXML.indexOf("</CustomerSubSeg>"));

				 WriteLog("\nCustomerSubSeg: "+CustomerSubSeg);
			}
			if(sMappOutPutXML.contains("<ARMCode>"))
			{
				ARMCode = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ARMCode>")+"</ARMCode>".length()-1,sMappOutPutXML.indexOf("</ARMCode>"));

				 WriteLog("\nARMCode is:"+ARMCode);
			}
			if(sMappOutPutXML.contains("<CustomerSegment>"))
			{
				CustomerSegment = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerSegment>")+"</CustomerSegment>".length()-1,sMappOutPutXML.indexOf("</CustomerSegment>"));
				 WriteLog("\nCustomerSegment---"+CustomerSegment);
			}
			if(sMappOutPutXML.contains("<CIFID>"))
			{			
				MainCIFID = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CIFID>")+"</CIFID>".length()-1,sMappOutPutXML.indexOf("</CIFID>"));
				 WriteLog("\nMainCIFID"+MainCIFID);
			}
			String MainCIFType = "";
			String MainFullName="";
			if(sMappOutPutXML.contains("<FullName>"))
			{		
				MainFullName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FullName>")+"</FullName>".length()-1,sMappOutPutXML.indexOf("</FullName>"));
				//MainFullName=MainFullName.replaceAll(" ","#");
				 WriteLog("\nMainFullName"+MainFullName);
			}
			if(sMappOutPutXML.contains("<IsRetailCust>"))
			{	
				String tempStr=sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
				 WriteLog("\ntempStr"+tempStr);
				if(tempStr.equalsIgnoreCase("N"))
					Mainindividual = "Non-Individual";
				else
					Mainindividual = "Individual";
			}

			// taking ResidentCountry
			if(sMappOutPutXML.contains("<ResidentCountry>"))
			{
				ResidentCountry = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ResidentCountry>")+"</ResidentCountry>".length()-1,sMappOutPutXML.indexOf("</ResidentCountry>"));
				 WriteLog("\nResidentCountry---"+ResidentCountry);
			}
			
			
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<PhnDet>"))
			{
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<PhnDet>"),sMappOutPutXML.indexOf("</PhnDet>")+"</PhnDet>".length());
				
				String preferredPh = (rowVal.contains("<PhnPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<PhnPrefFlag>")+"</PhnPrefFlag>".length()-1,rowVal.indexOf("</PhnPrefFlag>")):"";
				WriteLog("\npreferredPh from Customer Details --->"+preferredPh);	
				
				if(preferredPh.equalsIgnoreCase("Y"))
				{
					String strPhnCntryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";				
					String strPhnLocalCode = (rowVal.contains("<PhnLocalCode>")) ? rowVal.substring(rowVal.indexOf("<PhnLocalCode>")+"</PhnLocalCode>".length()-1,rowVal.indexOf("</PhnLocalCode>")):"";	
					strPhonenumber = strPhnCntryCode +"-"+strPhnLocalCode;
					WriteLog( "strPhonenumber: "+strPhonenumber);	
					
				}
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				}
				
			}
			
			
			countwhilchk = 0;
			while(sMappOutPutXML.contains("<AddrDet>"))
			{
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<AddrDet>"),sMappOutPutXML.indexOf("</AddrDet>")+"</AddrDet>".length());
				
				String preferredaddress = (rowVal.contains("<AddrPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<AddrPrefFlag>")+"</AddrPrefFlag>".length()-1,rowVal.indexOf("</AddrPrefFlag>")):"";
				WriteLog("\npreferredPh from Customer Details --->"+preferredaddress);	
				
				if(preferredaddress.equalsIgnoreCase("Y"))
				{
					String straddress1 = (rowVal.contains("<AddrLine1>")) ? rowVal.substring(rowVal.indexOf("<AddrLine1>")+"</AddrLine1>".length()-1,rowVal.indexOf("</AddrLine1>")):"";				
					String straddress2 = (rowVal.contains("<AddrLine2>")) ? rowVal.substring(rowVal.indexOf("<AddrLine2>")+"</AddrLine2>".length()-1,rowVal.indexOf("</AddrLine2>")):"";	
					String straddress3 = (rowVal.contains("<AddrLine3>")) ? rowVal.substring(rowVal.indexOf("<AddrLine3>")+"</AddrLine3>".length()-1,rowVal.indexOf("</AddrLine3>")):"";
					String straddress4 = (rowVal.contains("<AddrLine4>")) ? rowVal.substring(rowVal.indexOf("<AddrLine4>")+"</AddrLine4>".length()-1,rowVal.indexOf("</AddrLine4>")):"";
					String strcity = (rowVal.contains("<City>")) ? rowVal.substring(rowVal.indexOf("<City>")+"</City>".length()-1,rowVal.indexOf("</City>")):"";
					String strCountry = (rowVal.contains("<Country>")) ? rowVal.substring(rowVal.indexOf("<Country>")+"</Country>".length()-1,rowVal.indexOf("</Country>")):"";
					String strPobox = (rowVal.contains("<POBox>")) ? rowVal.substring(rowVal.indexOf("<POBox>")+"</POBox>".length()-1,rowVal.indexOf("</POBox>")):"";
					
					strAddress = straddress1 +","+straddress2+","+straddress3+","+straddress4+","+strcity+","+strCountry+","+strPobox;
					WriteLog( "strAddress: "+strAddress);	
					
				}
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				}
				
			}
			
			
			val_main = MainCIFID+"~"+MainFullName+"~"+CustomerSubSeg+"~"+ARMCode+"~"+IsPremium+"~"+PrimaryEmailId+"~"+strEmiratesID+"~"+strEmiratesIDExpDate+"~"+Mainindividual+"~"+strTDLICNum+"~"+strTDLICExpDate+"~"+ResidentCountry+"~"+strPhonenumber+"~"+strAddress+"~"+"End";
			
			//WriteLog("\nval_main entity detail on radio click: "+ val_main);									
			WriteLog("\nval_main entity detail on radio click");									
			if (!ReturnCode.equalsIgnoreCase("0000")){
				 WriteLog("\nReturnCode: "+ ReturnCode);
				out.clear();
				out.println("Exception");
			}
			else{
				out.clear();
				out.println(val_main);
			}
		}
		// End - Calling Entity Detail on Related CIF Radio Click added on 29052017
		
		if (requestType.equals("EXCHANGE_RATE_DETAILS"))
		{
			String sessionId=sSessionId,engineName=sCabName;
			String sAmount = request.getParameter("amount");
			String sCurrency = request.getParameter("currency");
			String Accountno = request.getParameter("Accountno");
			//WriteLog("inside - EXCHANGE_RATE_DETAILS");
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>Ankit</UserID>\n" +
					"<SessionId>"+sessionId+"</SessionId>\n"+
					"<EngineName>"+engineName+"</EngineName>\n" +
					"<RequestType>EXCHANGE_RATE_DETAILS</RequestType>\n" +
					"<EE_EAI_BODY>\n"+
					"<ProcessName>TF</ProcessName>\n" +
					"<ExchangeRateCriteria><BankId>RAK</BankId><CustId>"+Accountno+"</CustId><Ratecode></Ratecode><Currentdate>2016-02-22T18:51:40.664+05:30</Currentdate><DbtCurCode>AED</DbtCurCode><CrdCurCode>"+sCurrency+"</CrdCurCode><TxnAmount>"+sAmount+"</TxnAmount><TxnCurCode>"+sCurrency+"</TxnCurCode><HomeCurCode>AED</HomeCurCode><TxnType></TxnType><TargetSystem>FIN</TargetSystem><DealNumber/></ExchangeRateCriteria>\n" +
					"</EE_EAI_BODY>\n"+
					"</TT_APMQPutGetMessage_Input>";
			
			WriteLog("sInputXML - Exchange_Rate for WINAME: "+wi_name+" : "+inputEntityDetailsXML);
			
			//UnComment the below code ONSHORE for Integration - Starts here
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			// ONSHORE Code Ends here
			
			//UnComment the below code OFFSHORE for Integration - Starts here
			//sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>EXCHANGE_RATE_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>MW_EXCHANGE_RATE_DETAILS_T01</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><ExchangeRate><FxdCurUnits>1</FxdCurUnits><FxdCurCode>AED</FxdCurCode><VarCurUnits>3.67</VarCurUnits><VarCurCode>USD</VarCurCode><RateMode>N</RateMode><OutputAmount>234324323</OutputAmount><RateCode>TTB</RateCode></ExchangeRate></EE_EAI_MESSAGE>";
			//OFFSHORE Code Ends Here
			
			WriteLog("sMappOutPutXML - Exchange_Rate for WINAME: "+wi_name+" : "+sMappOutPutXML);
			
			String ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";			
			
			String rowVal="";
			String VarCurUnits = "";
			String OutputAmount = "";
								
			if (!ReturnCode.equalsIgnoreCase("0000"))
			{
				WriteLog("Exchange Rate call ReturnCode: "+ ReturnCode);
				out.clear();
				out.println("Exception");
			}
			else
			{
				VarCurUnits = (sMappOutPutXML.contains("<VarCurUnits>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<VarCurUnits>")+"</VarCurUnits>".length()-1,sMappOutPutXML.indexOf("</VarCurUnits>")):"";
				WriteLog( "\nVarCurUnits: "+VarCurUnits);
				
				OutputAmount = (sMappOutPutXML.contains("<OutputAmount>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<OutputAmount>")+"</OutputAmount>".length()-1,sMappOutPutXML.indexOf("</OutputAmount>")):"";
				WriteLog( "OutputAmount: "+OutputAmount);
								
				out.clear();
				out.println(VarCurUnits+"~"+OutputAmount);
				
				/* countwhilchk++;
				if(countwhilchk == 50)
				{
					countwhilchk = 0;
					break;
				} */
				
			}			
		}
		
	}
	catch(Exception e){
		e.printStackTrace();
		sMappOutPutXML="Exception"+e;
		WriteLog("in catch");
		WriteLog(sMappOutPutXML);
	}
%>