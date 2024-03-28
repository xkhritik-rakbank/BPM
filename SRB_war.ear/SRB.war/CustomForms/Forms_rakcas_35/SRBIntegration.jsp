<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank Telegraphic Transfer
//Module                     : Integration Calls 
//File Name					 : SRBIntegration.jsp
//Author                     : Amitabh Pandey
//Date written (DD/MM/YYYY)  : 16-01-2017
//Description                : File to handle all the integration calls for SRB process (Initial Draft)
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
<%@ include file="../SRB_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
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
		 WriteLog("\nInside SRB Integration.jsp\n");
		
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("request_type"), 1000, true) );    
		String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");

		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );    
		String wi_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");

		String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_type"), 1000, true) );    
		String cif_type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
		
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
		
		WriteLog("\nInside SRB Integration.jsp ,request Type - "+requestType+" for wi_name "+wi_name);
		
		if (requestType.equals("ENTITY_DETAILS"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";	
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Account_Number"), 1000, true) );    
			String ACCNumber = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");

			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mobile_number"), 1000, true) );    
			String MobileNumber = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");

			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Emirates_Id"), 1000, true) );    
			String EmiratesID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");

			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("account_type"), 1000, true) );    
			String ACCType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");

			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIF_ID"), 1000, true) );    
			String CIF_ID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");

			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("user_name"), 1000, true) );    
			String username = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			
			String sessionId=sSessionId,engineName=sCabName;
			String ReturnCode = "";
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("FatcaReasonNew"), 1000, true) );    
			String FatcaReason = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			String params = "";
			
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				//"<ProcessName>SRB</ProcessName>\n" +
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
			String inputXMLLog = maskXmlTags(inputEntityDetailsXML,"<ACCNumber>"); // masking DateOfBirth in log	
			inputXMLLog = maskXmlTags(inputXMLLog,"<EmiratesID>"); // masking DocumentRefNumber in log
			WriteLog("\ninputEntityDetailsXML"+inputXMLLog);
			
			//UnComment the below code OFFSHORE for Integration - Starts here
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"SRBTesting"+File.separator+"Entity_Details.txt");
			//Comment ends here
			
			//UnComment the below code ONSHORE for Integration - Starts here
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			//Comment ends here
			
			String outputXMLLog = maskXmlTags(sMappOutPutXML,"<ACCNumber>"); // masking ACCNumber in log	
			outputXMLLog = maskXmlTags(outputXMLLog,"<DOB>"); // masking DOB in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MothersName>"); // masking MothersName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<IBANNumber>"); // masking IBANNumber in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<DocId>"); // masking DocId in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PassportNum>"); // masking PassportNum in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MotherMaidenName>"); // masking MotherMaidenName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<LinkedDebitCardNumber>"); // masking LinkedDebitCardNumber in log
			
			WriteLog("\nOutputEntityDetailsXML:\n"+outputXMLLog);	
			
			
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
				//WriteLog("\nPrimaryEmailId For Main CIF: "+PrimaryEmailId);
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
					//WriteLog( "PrimaryEmailId For Main CIF~: "+PrimaryEmailId);
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
				 //WriteLog("\nMainFullName"+MainFullName);
			}
			if(sMappOutPutXML.contains("<IsRetailCust>"))
			{	
				String tempStr=sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
				 WriteLog("\nIsRetailCust: "+tempStr);
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
					 //WriteLog("\nEmiratesID For Related CIF: "+strEmiratesID);
				}
				WriteLog("Related check out ");
				
				String CIFID = rowVal.substring(rowVal.indexOf("<CIFID>")+"<CIFID>".length(),rowVal.indexOf("</CIFID>"));
				WriteLog("Related CIFID "+CIFID);
				String cust_name = rowVal.substring(rowVal.indexOf("<CustomerName>")+"<CustomerName>".length(),rowVal.indexOf("</CustomerName>"));
				//cust_name=cust_name.replaceAll(" ","#");
				//WriteLog("cust_name cust_name "+cust_name);
				//String nameWithSpaceRomove=cust_name.replaceAll(" ","~");
				CustomerSubSeg = rowVal.substring(rowVal.indexOf("<CustomerSubSeg>")+"<CustomerSubSeg>".length(),rowVal.indexOf("</CustomerSubSeg>"));
				WriteLog("Related CustomerSubSeg "+CustomerSubSeg);
				if(rowVal.contains("<PrimaryEmailId>"))
				{
					PrimaryEmailId=rowVal.substring(rowVal.indexOf("<PrimaryEmailId>")+"<PrimaryEmailId>".length(),rowVal.indexOf("</PrimaryEmailId>"));
					
					//WriteLog("\nPrimaryEmailId----"+PrimaryEmailId);
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
			
			
			String appendStr = "<table id='SRBSearch' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th><b>Select</b></th><th><b>CIF Number</b></th><th><b>Name</b></th><th><b>CIF Type</b></th></tr>";
			
			if (!ReturnCode.equalsIgnoreCase("0000")){
				 WriteLog("\nReturnCode: "+ ReturnCode);
					out.clear();
				out.println("Exception");
			}
			else{
				out.clear();
				out.println(appendStr+temp_table+"</table>"+"^^^"+IsPremium+"^^^"+ARMCode+"^^^"+CustomerSegment+"^^^"+CustomerSubSeg+"^^^");

				 //WriteLog(appendStr+temp_table+"</table>");
			}
		}
		
		// Start - Calling Entity Detail on Related CIF Radio Click added on 29052017
		if (requestType.equals("ENTITY_DETAILS_RADIOCLICK"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Account_Number"), 1000, true) );    
			String ACCNumber = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");

			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mobile_number"), 1000, true) );    
			String MobileNumber = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");

			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Emirates_Id"), 1000, true) );    
			String EmiratesID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");

			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("account_type"), 1000, true) );    
			String ACCType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");

			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIF_ID"), 1000, true) );    
			String CIF_ID = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");

			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("user_name"), 1000, true) );    
			String username = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			
			String sessionId=sSessionId,engineName=sCabName;
			String ReturnCode = "";
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("FatcaReasonNew"), 1000, true) );    
			String FatcaReason = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			String params = "";
			
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				//"<ProcessName>SRB</ProcessName>\n" +
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
			String inputXMLLog = maskXmlTags(inputEntityDetailsXML,"<ACCNumber>"); // masking DateOfBirth in log	
			inputXMLLog = maskXmlTags(inputXMLLog,"<EmiratesID>"); // masking DocumentRefNumber in log
			WriteLog("\ninputEntityDetailsXML On Radio Click: "+inputXMLLog);
			
			//UnComment the below code OFFSHORE for Integration - Starts here
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"SRBTesting"+File.separator+"Entity_Details.txt");
			//WriteLog("\nOutputEntityDetailsXML:\n"+sMappOutPutXML);
			//Comment ends here
			
			//UnComment the below code ONSHORE for Integration - Starts here
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			//Comment ends here
			
			String outputXMLLog = maskXmlTags(sMappOutPutXML,"<ACCNumber>"); // masking ACCNumber in log	
			outputXMLLog = maskXmlTags(outputXMLLog,"<DOB>"); // masking DOB in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MothersName>"); // masking MothersName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<IBANNumber>"); // masking IBANNumber in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<DocId>"); // masking DocId in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PassportNum>"); // masking PassportNum in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MotherMaidenName>"); // masking MotherMaidenName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<LinkedDebitCardNumber>"); // masking LinkedDebitCardNumber in log
			
			WriteLog("\nOutputEntityDetailsXML On Radio Click:\n"+outputXMLLog);	
			
				
			
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
			
			String ECRNumber="";
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
					//WriteLog( "PrimaryEmailId For Main CIF~: "+PrimaryEmailId);
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
					//WriteLog( "strTDLICNum~ "+strTDLICNum);
					//WriteLog( "strTDLICExpDate~ "+strTDLICExpDate);
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
				 //WriteLog("\nMainFullName"+MainFullName);
			}
			if(sMappOutPutXML.contains("<IsRetailCust>"))
			{	
				String tempStr=sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
				 WriteLog("\nIsRetailCust: "+tempStr);
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
			
			if(sMappOutPutXML.contains("<ECRNumber>"))
			{
				ECRNumber = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ECRNumber>")+"</ECRNumber>".length()-1,sMappOutPutXML.indexOf("</ECRNumber>"));
				 WriteLog("\nECRNumber---"+ECRNumber);
			}
			
			
			val_main = MainCIFID+"~"+MainFullName+"~"+CustomerSubSeg+"~"+ARMCode+"~"+IsPremium+"~"+PrimaryEmailId+"~"+strEmiratesID+"~"+strEmiratesIDExpDate+"~"+Mainindividual+"~"+strTDLICNum+"~"+strTDLICExpDate+"~"+ResidentCountry+"~"+ECRNumber+"~"+"End";
			
			//WriteLog("\nval_main entity detail on radio click: "+ val_main);									
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
		
	}
	catch(Exception e){
		e.printStackTrace();
		sMappOutPutXML="Exception"+e;
		WriteLog("in catch");
		WriteLog(sMappOutPutXML);
	}
%>