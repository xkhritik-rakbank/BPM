<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank Telegraphic Transfer
//Module                     : Integration Calls 
//File Name					 : CUIntegration.jsp
//Author                     : Aishwarya Gupta
//Date written (DD/MM/YYYY)  : 01-July-2016
//Description                : File to handle all the integration calls for CU process (Initial Draft)
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
<%@ include file="../CU_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/CU/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>


<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

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
	     	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("request_type"), 1000, true) );
			String request_type_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_type"), 1000, true) );
			String cif_type_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Account_Number"), 1000, true) );
			String Account_Number_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("mobile_number"), 1000, true) );
			String mobile_number_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Emirates_Id"), 1000, true) );
			String Emirates_Id_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("account_type"), 1000, true) );
			String account_type_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIF_ID"), 1000, true) );
			String CIF_ID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("user_name"), 1000, true) );
			String user_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			
			String input10= ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_id"), 1000, true) );
			String cif_id_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			
	int relatedCIFCount=0;
	int countwhilchk=0;
	String sInputXML = "";
	String sMappOutPutXML = "";
	try{
		 //WriteLog( "\nInside CUIntegration.jsp");
			//WriteLog("Inside CUIntegration.jsp-------/");
		String requestType = request_type_Esapi;
		
		if(requestType!=null){	requestType = requestType.replace("'","''");}
		String wi_name = wi_name_Esapi;
		
		if(wi_name!=null){	wi_name = wi_name.replace("'","''");}
		String cif_type = cif_type_Esapi;
		if(cif_type!=null){	cif_type = cif_type.replace("'","''");}
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String SubscriptionFlag="N";
		String MiscellaniousId = "";
		String sFlag = "";
		String ResAddress1 = "";
		String OffcAddress1 = "";
		String ResPobox = "";
		String OffcPobox = "";
		String params = "";
		//WriteLog( "\nInside CUIntegration.jsp ,request Type - "+requestType+" for wi_name "+wi_name);
		WriteLog("Inside CUIntegration.jsp ,request Type - "+requestType+" for wi_name "+wi_name);
		if (requestType.equals("ENTITY_DETAILS"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";		
			String ACCNumber = Account_Number_Esapi;
			
			if(ACCNumber!=null){ ACCNumber = ACCNumber.replace("'","''");}
			String MobileNumber = mobile_number_Esapi;
			
			if(MobileNumber!=null){ MobileNumber = MobileNumber.replace("'","''");}
			String EmiratesID = Emirates_Id_Esapi;
			
			if(EmiratesID!=null){ EmiratesID = EmiratesID.replace("'","''");}
			String ACCType = account_type_Esapi; // Hardcode
			
			if(ACCType!=null){ ACCType = ACCType.replace("'","''");}
			String CIF_ID = CIF_ID_Esapi;
			
			if(CIF_ID!=null){ CIF_ID = CIF_ID.replace("'","''");}
			String username=user_name_Esapi;
			
			if(username!=null){ username = username.replace("'","''");}
			String sessionId=sSessionId,engineName=sCabName;
			String ReturnCode = "";
			
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				"<ProcessName>CU</ProcessName>\n" +
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
			//WriteLog( "\ninputEntityDetailsXML"+inputEntityDetailsXML);
			WriteLog("inputEntityDetailsXML"+inputEntityDetailsXML);
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			//WriteLog( "\nOutputEntityDetailsXML: "+sMappOutPutXML);	
			WriteLog("OutputEntityDetailsXML: "+sMappOutPutXML);
			String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"CUTesting"+File.separator+"Entity_Details.txt");
			
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";			
			
			String rowVal="";
			String individual = "";
			String temp_table="";
			String Mainindividual = "";
			String IsPremium="";
			String ARMName="";
			String CustomerSegment="";
			String MainCIFID ="";
			String CustomerSubSeg="";
			
			if(sMappOutPutXML.contains("<IsPremium>")){
				IsPremium = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsPremium>")+"</IsPremium>".length()-1,sMappOutPutXML.indexOf("</IsPremium>"));
				//WriteLog("\nIsPremium: "+IsPremium);
				 WriteLog("IsPremium: "+IsPremium);
				 if (IsPremium.equalsIgnoreCase("B"))
				 {
					IsPremium = "Y" ;
				 }
			}
			if(sMappOutPutXML.contains("<CustomerSubSeg>")){
			CustomerSubSeg = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,sMappOutPutXML.indexOf("</CustomerSubSeg>"));

				 //WriteLog( "\nCustomerSubSeg: "+CustomerSubSeg);
				 //WriteLog("CustomerSubSeg: "+CustomerSubSeg);
			}
			if(sMappOutPutXML.contains("<ARMName>")){
				ARMName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ARMName>")+"</ARMName>".length()-1,sMappOutPutXML.indexOf("</ARMName>"));

				//WriteLog("\nARMName is:"+ARMName);
				
			}
			if(sMappOutPutXML.contains("<CustomerSegment>")){
				CustomerSegment = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerSegment>")+"</CustomerSegment>".length()-1,sMappOutPutXML.indexOf("</CustomerSegment>"));
				//WriteLog("\nCustomerSegment---"+CustomerSegment);
			}
			if(sMappOutPutXML.contains("<CIFID>")){			
				MainCIFID = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CIFID>")+"</CIFID>".length()-1,sMappOutPutXML.indexOf("</CIFID>"));
				//WriteLog("\nMainCIFID"+MainCIFID);
				//WriteLog("MainCIFID"+MainCIFID);
			}
			String MainCIFType = "";
			String MainFullName="";
			if(sMappOutPutXML.contains("<FullName>")){		
				MainFullName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FullName>")+"</FullName>".length()-1,sMappOutPutXML.indexOf("</FullName>"));
				//WriteLog("\nMainFullName"+MainFullName);
			}
			if(sMappOutPutXML.contains("<IsRetailCust>")){	
				String tempStr=sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
				 //WriteLog( "\ntempStr"+tempStr);
				//WriteLog("tempStr"+tempStr);
				if(tempStr.equalsIgnoreCase("N"))
					Mainindividual = "Non-Individual";
				else
					Mainindividual = "Individual";
			}		
			String MainRadio = "<td><input type='radio' name='"+Mainindividual+"' value="+"'"+MainCIFID+"'"+" id='"+Mainindividual+"' onclick='javascript:showDivForRadio(this);'></td>";
			temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'>"+MainRadio+"<td>"+MainCIFID+"</td><td>"+MainFullName+"</td><td>"+Mainindividual+"</td></tr>";	
			
			val_main = val_main + valRadio+"#"+MainCIFID+"#"+Mainindividual+"~";
			//WriteLog("\nval_main"+val_main);
			//WriteLog("val_main"+val_main);
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
				
				String CIFID = rowVal.substring(rowVal.indexOf("<CIFID>")+"<CIFID>".length(),rowVal.indexOf("</CIFID>"));
				String cust_name = rowVal.substring(rowVal.indexOf("<CustomerName>")+"<CustomerName>".length(),rowVal.indexOf("</CustomerName>"));
				
				String b = "<td><input type='radio' name='"+individual+"' value="+"'"+CIFID+"'"+"  id='"+individual+"' onclick='javascript:showDivForRadio(this);'></td>";
				
				temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'>"+b+"<td>"+CIFID+"</td><td>"+cust_name+"</td><td>"+individual+"</td></tr>";
				
				val_main = val_main + valRadio+"#"+CIFID+"#"+individual+"~";
				
				//sMappOutPutXML = sMappOutPutXML.replaceAll(rowVal, "");
				sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
				 //WriteLog(  "\n RelatedCIF sMappOutPutXML"+sMappOutPutXML);
				//WriteLog(" RelatedCIF sMappOutPutXML"+sMappOutPutXML);
				countwhilchk++;
				if(countwhilchk == 100)
				{
					countwhilchk = 0;
					break;
				}
			}
			
			String appendStr = "<table id='emid' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th><b>Select</b></th><th><b>CIF Number</b></th><th><b>Name</b></th><th><b>CIF Type</b></th></tr>";
			
			if (!ReturnCode.equalsIgnoreCase("0000")){
				//WriteLog("\nReturnCode: "+ ReturnCode);
				 	//WriteLog(" ReturnCode: "+ ReturnCode);
					out.clear();
				out.println("Exception");
			}
			else{
				out.clear();
				out.println(appendStr+temp_table+"</table>"+"^^^"+IsPremium+"^^^"+ARMName+"^^^"+CustomerSegment+"^^^"+CustomerSubSeg+"^^^");

				//WriteLog("\n"+appendStr+temp_table+"</table>");
				//WriteLog(appendStr+temp_table+"</table>");
			}
		}
		else if (requestType.equalsIgnoreCase("ENTITY_DETAILS_2") && cif_type.equalsIgnoreCase("Individual"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";		
			String ACCNumber = Account_Number_Esapi;
			
			if(ACCNumber!=null){ ACCNumber = ACCNumber.replace("'","''");}
			String MobileNumber = mobile_number_Esapi;
			
			if(MobileNumber!=null){ MobileNumber = MobileNumber.replace("'","''");}
			String EmiratesID = Emirates_Id_Esapi;
			
			if(EmiratesID!=null){ EmiratesID = EmiratesID.replace("'","''");}
			String ACCType = account_type_Esapi; // Hardcode
			
			if(ACCType!=null){ ACCType = ACCType.replace("'","''");}
			String CIF_ID = CIF_ID_Esapi;
			
			if(CIF_ID!=null){ CIF_ID = CIF_ID.replace("'","''");}
			String username=user_name_Esapi;
			
			if(username!=null){ username = username.replace("'","''");}
			String sessionId=sSessionId,engineName=sCabName;
			
						
			String inputEntityDetailsXML_2 = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				"<ProcessName>CU</ProcessName>\n" +
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
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><EmiratesID>"+EmiratesID+"</EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
			
			
			//WriteLog("\ninputEntityDetailsXML_2 input: "+inputEntityDetailsXML_2);	
			 WriteLog("inputEntityDetailsXML_2 input: "+inputEntityDetailsXML_2);
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML_2,customSession.getJtsIp(),customSession.getJtsPort(),1);
			String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"CUTesting"+File.separator+"Entity_Details2.txt");	
			//WriteLog( "\ninputEntityDetailsXML_2 Output: "+sMappOutPutXML);
			 WriteLog("inputEntityDetailsXML_2 Output: "+sMappOutPutXML);
			String rowVal="";
			String CustomerDetails="";
			String IsPremium ="";
			String Title="";
			String FirstName ="";
			String MiddleName ="";
			String LastName ="";
			String FullName ="";
			String Gender ="";
			String MothersName ="";
			String Nationality ="";
			String ResidentCountryExis ="";
			String cust_result ="";
			String MaritalStatus="";
			String AECBConsentHeld="";
			String CustomerSubSeg="";
			String ARMName="";
			String US_National="No";
			String USRelation="";
			String IndustrySegment="";
			String IndustrySubSegment="";
			String FatcaReason="";
			String CustomerType="";
			String DocumentsCollected="";
			String SignedDate="";
			String SignedExpiryDate="";
			String NonResidentFlag="";
			String TotEmpYrs="";
			String BusinessDuration="";
			String DOB="";
			String CountryRes="";
			String CityRes="";
			String CountryOffc="";
			String CityOffc="";
			try{
		
				if(sMappOutPutXML.contains("<CustomerDetails>"))
				{
					CustomerDetails = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerDetails>"),sMappOutPutXML.indexOf("</CustomerDetails>")+"</CustomerDetails>".length());
					if(CustomerDetails.contains("<IsPremium>"))
					{
						IsPremium = CustomerDetails.substring(CustomerDetails.indexOf("<IsPremium>")+"</IsPremium>".length()-1,CustomerDetails.indexOf("</IsPremium>"));
						if (IsPremium.equalsIgnoreCase("B"))
						 {
							IsPremium = "Y" ;
						 }
					}
					if(CustomerDetails.contains("<CustomerSubSeg>"))
					{
						CustomerSubSeg = CustomerDetails.substring(CustomerDetails.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,CustomerDetails.indexOf("</CustomerSubSeg>"));
					}
					if(CustomerDetails.contains("<ARMName>"))
					{
						ARMName = CustomerDetails.substring(CustomerDetails.indexOf("<ARMName>")+"</ARMName>".length()-1,CustomerDetails.indexOf("</ARMName>"));
					}
					if(CustomerDetails.contains("<Title>"))
					{
						Title = CustomerDetails.substring(CustomerDetails.indexOf("<Title>")+"</Title>".length()-1,CustomerDetails.indexOf("</Title>"));
					}
					if(CustomerDetails.contains("<FirstName>"))
					{
						FirstName = CustomerDetails.substring(CustomerDetails.indexOf("<FirstName>")+"</FirstName>".length()-1,CustomerDetails.indexOf("</FirstName>"));
					}
					if(CustomerDetails.contains("<MiddleName>"))
					{
						MiddleName = CustomerDetails.substring(CustomerDetails.indexOf("<MiddleName>")+"</MiddleName>".length()-1,CustomerDetails.indexOf("</MiddleName>"));
					}
					if(CustomerDetails.contains("<LastName>"))
					{
						LastName = CustomerDetails.substring(CustomerDetails.indexOf("<LastName>")+"</LastName>".length()-1,CustomerDetails.indexOf("</LastName>"));
					}
					if(CustomerDetails.contains("<FullName>"))
					{
						FullName = CustomerDetails.substring(CustomerDetails.indexOf("<FullName>")+"</FullName>".length()-1,CustomerDetails.indexOf("</FullName>"));
					}
					if(CustomerDetails.contains("<Gender>"))
					{
						Gender = CustomerDetails.substring(CustomerDetails.indexOf("<Gender>")+"</Gender>".length()-1,CustomerDetails.indexOf("</Gender>"));
					}
					if(CustomerDetails.contains("<MothersName>"))
					{
						MothersName = CustomerDetails.substring(CustomerDetails.indexOf("<MothersName>")+"</MothersName>".length()-1,CustomerDetails.indexOf("</MothersName>"));
					}
					if(CustomerDetails.contains("<Nationality>"))
					{
						Nationality = CustomerDetails.substring(CustomerDetails.indexOf("<Nationality>")+"</Nationality>".length()-1,CustomerDetails.indexOf("</Nationality>"));
						if(Nationality.equalsIgnoreCase("US")){
							US_National = "Yes";
						}
					}
					if(CustomerDetails.contains("<ResidentCountry>"))
					{
						ResidentCountryExis = CustomerDetails.substring(CustomerDetails.indexOf("<ResidentCountry>")+"</ResidentCountry>".length()-1,CustomerDetails.indexOf("</ResidentCountry>"));
						
						//WriteLog("ResidentCountryExis "+ResidentCountryExis);
					}
					// ResidentCountryExis = "AE"; //commented by Ankit 28042018 due to production issue
					//extra added
					if(CustomerDetails.contains("<MaritalStatus>"))
					{
						MaritalStatus = CustomerDetails.substring(CustomerDetails.indexOf("<MaritalStatus>")+"</MaritalStatus>".length()-1,CustomerDetails.indexOf("</MaritalStatus>"));
					}
					if(CustomerDetails.contains("<AECBConsentHeld>"))
					{
						AECBConsentHeld = CustomerDetails.substring(CustomerDetails.indexOf("<AECBConsentHeld>")+"</AECBConsentHeld>".length()-1,CustomerDetails.indexOf("</AECBConsentHeld>"));
					}
					
					if(CustomerDetails.contains("<USRelation>"))
					{
						USRelation = CustomerDetails.substring(CustomerDetails.indexOf("<USRelation>")+"</USRelation>".length()-1,CustomerDetails.indexOf("</USRelation>"));
					}
					if(CustomerDetails.contains("<IndustrySegment>"))
					{
						IndustrySegment = CustomerDetails.substring(CustomerDetails.indexOf("<IndustrySegment>")+"</IndustrySegment>".length()-1,CustomerDetails.indexOf("</IndustrySegment>"));
					}
					if(CustomerDetails.contains("<IndustrySubSegment>"))
					{
						IndustrySubSegment = CustomerDetails.substring(CustomerDetails.indexOf("<IndustrySubSegment>")+"</IndustrySubSegment>".length()-1,CustomerDetails.indexOf("</IndustrySubSegment>"));
					}
					if(CustomerDetails.contains("<FatcaReason>"))
					{
						FatcaReason = CustomerDetails.substring(CustomerDetails.indexOf("<FatcaReason>")+"</FatcaReason>".length()-1,CustomerDetails.indexOf("</FatcaReason>"));
					}
					if(CustomerDetails.contains("<CustomerType>"))
					{
						CustomerType = CustomerDetails.substring(CustomerDetails.indexOf("<CustomerType>")+"</CustomerType>".length()-1,CustomerDetails.indexOf("</CustomerType>"));
					}
					if(CustomerDetails.contains("<DocumentsCollected>"))
					{
						DocumentsCollected = CustomerDetails.substring(CustomerDetails.indexOf("<DocumentsCollected>")+"</DocumentsCollected>".length()-1,CustomerDetails.indexOf("</DocumentsCollected>"));
					}
					if(CustomerDetails.contains("<SignedDate>"))
					{
						SignedDate = CustomerDetails.substring(CustomerDetails.indexOf("<SignedDate>")+"</SignedDate>".length()-1,CustomerDetails.indexOf("</SignedDate>"));
						

						try{
							//SignedDate = SignedDate.substring(8,10)+"/"+SignedDate.substring(5,7)+"/"+SignedDate.substring(0,4);
							SignedDate = SignedDate.replaceAll("-","/");
						}catch(Exception ex){
							SignedDate="";
						}	
					}if(CustomerDetails.contains("<SignedExpiryDate>"))
					{
						SignedExpiryDate = CustomerDetails.substring(CustomerDetails.indexOf("<SignedExpiryDate>")+"</SignedExpiryDate>".length()-1,CustomerDetails.indexOf("</SignedExpiryDate>"));

						try{
							//SignedExpiryDate = SignedExpiryDate.substring(8,10)+"/"+SignedExpiryDate.substring(5,7)+"/"+SignedExpiryDate.substring(0,4);
							SignedExpiryDate = SignedExpiryDate.replaceAll("-","/");
						}catch(Exception ex){
							SignedExpiryDate="";
						}	
					}
					if(CustomerDetails.contains("<NonResidentFlag>"))
					{
						NonResidentFlag = CustomerDetails.substring(CustomerDetails.indexOf("<NonResidentFlag>")+"</NonResidentFlag>".length()-1,CustomerDetails.indexOf("</NonResidentFlag>"));
					}
					if(CustomerDetails.contains("<TotEmpYrs>"))
					{
						TotEmpYrs = CustomerDetails.substring(CustomerDetails.indexOf("<TotEmpYrs>")+"</TotEmpYrs>".length()-1,CustomerDetails.indexOf("</TotEmpYrs>"));
					}
					if(CustomerDetails.contains("<BusinessDuration>"))
					{
						BusinessDuration = CustomerDetails.substring(CustomerDetails.indexOf("<BusinessDuration>")+"</BusinessDuration>".length()-1,CustomerDetails.indexOf("</BusinessDuration>"));
					}
					
					if(CustomerDetails.contains("<DOB>"))
					{
						DOB = CustomerDetails.substring(CustomerDetails.indexOf("<DOB>")+"</DOB>".length()-1,CustomerDetails.indexOf("</DOB>"));

						try{
							DOB = DOB.substring(8,10)+"/"+DOB.substring(5,7)+"/"+DOB.substring(0,4);
						}catch(Exception ex){
							DOB="";
						}	
					}
				
					String passportNo="";
					String passportExp="";
					String emiratesId="";
					String emiratesIdExp="";
					String visa="";
					String visaExp="";
					// added by Shamily to fetch MARID,EMREG fields
					String MARID="";
					String MARIDExp="";
					String EMREG="";
					String EMREGExp="";
					String EMREGissdate="";
					String OfficeAddress="";
					String ResidenceAddress="";
					String PrimaryEmail="";
					String SecondaryEmail="";
					String Phone1CountryCode="";
					//Added by Shamily to fetch OECD Details Fields value 
					String CityOfBirth="";
					String CountryOfBirth="";
					String CRSUnDocFlg="";
					String CRSUndocFlgReason="";
					String CntryOfTaxRes="";
					String TINNumber="";
					String NoTINReason="";
					String CntryOfTaxRes1="";
					String TINNumber1="";
					String NoTINReason1="";
					String MiscellaniousId1="";
					String CntryOfTaxRes2="";
					String TINNumber2="";
					String NoTINReason2="";
					String MiscellaniousId2="";
					String CntryOfTaxRes3="";
					String TINNumber3="";
					String NoTINReason3="";
					String MiscellaniousId3="";
					String CntryOfTaxRes4="";
					String TINNumber4="";
					String NoTINReason4="";
					String MiscellaniousId4="";
					String CntryOfTaxRes5="";
					String TINNumber5="";
					String NoTINReason5="";
					String MiscellaniousId5="";
					String CntryOfTaxRes6="";
					String TINNumber6="";
					String NoTINReason6="";
					String MiscellaniousId6="";
					String Phone2CountryCode="";
					String HomePhoneCountryCode="";
					String OfficePhoneCountryCode="";
					String HomeCountryPhoneCountryCode="";
					String Phone1No="";
					String Phone2No="";
					String HomePhoneNo="";
					String OfficePhoneNo="";
					String HomeCountryPhoneNo="";
					String addPrefFlag="";
					String phnPrefFlag="";
					String mailPrefFlag="";
					String EmploymentType="";
					String EmployerID="";
					String Desig="";
					String EmployerName="";
					String DepartmentName="";
					String EmployeeNumber="";
					String Occupation="";
					String EmployeeStatus="";
					String DOJ="";
					String FAX="";
					String mailPrefFlag1="";
					String MailType = "";
					countwhilchk = 0;
					while(CustomerDetails.contains("<DocumentDet>"))
					{
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<DocumentDet>"),CustomerDetails.indexOf("</DocumentDet>")+"</DocumentDet>".length());
						
						String DocType = (rowVal.contains("<DocType>")) ? rowVal.substring(rowVal.indexOf("<DocType>")+"</DocType>".length()-1,rowVal.indexOf("</DocType>")):"";
						//WriteLog("\nDocType: "+DocType);
						//WriteLog("DocType: "+DocType);
						if(DocType.equalsIgnoreCase("Passport"))
						{
							passportNo = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							passportExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							try{
								passportExp = passportExp.substring(8,10)+"/"+passportExp.substring(5,7)+"/"+passportExp.substring(0,4);
							}catch(Exception ex){
								passportExp="";
							}	
							 //WriteLog( "\nwdesk:PassportNumber_Existing~"+passportNo);
								//WriteLog("wdesk:PassportNumber_Existing~"+passportNo);
							//WriteLog( "\nwdesk:passportExpDate_exis~**"+passportExp);
								//WriteLog("wdesk:passportExpDate_exis~"+passportExp);
						}
						else if(DocType.equalsIgnoreCase("EMID"))
						{
							emiratesId = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							
							try{
								emiratesIdExp = rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>"));
								emiratesIdExp = emiratesIdExp.substring(8,10)+"/"+emiratesIdExp.substring(5,7)+"/"+emiratesIdExp.substring(0,4);
							}catch(Exception ex){
								emiratesIdExp="";
							}
							//WriteLog("\nwdesk:emiratesid~"+emiratesId);
								//WriteLog("wdesk:emiratesid~"+emiratesId);
							//WriteLog( "\nwdesk:emiratesidexp_exis~"+emiratesIdExp);
							//WriteLog("wdesk:emiratesidexp_exis~"+emiratesIdExp);
						}
						else if(DocType.equalsIgnoreCase("Visa"))
						{
							visa = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							visaExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							try{
								visaExp = visaExp.substring(8,10)+"/"+visaExp.substring(5,7)+"/"+visaExp.substring(0,4);
							}catch(Exception ex){
								visaExp="";
							}
							//WriteLog("\nwdesk:visa_exis~"+visa);
								
							//WriteLog( "\nwdesk:visaExpDate_exis~"+visaExp);
						}
						
						// added by Shamily to fetch MARID,EMREG fields
						else if(DocType.equalsIgnoreCase("MARID"))
						{
							MARID = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							MARIDExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							try{
								MARIDExp = MARIDExp.substring(8,10)+"/"+MARIDExp.substring(5,7)+"/"+MARIDExp.substring(0,4);
							}catch(Exception ex){
								MARIDExp="";
							}
							//WriteLog("\nwdesk:Marsoon_exis~"+MARID);
								
							//WriteLog( "\nwdesk:marsoonExpDate_exis~"+MARIDExp);
						}
						
					else if(DocType.equalsIgnoreCase("EMREG"))
						{
							EMREG = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							EMREGExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							EMREGissdate = (rowVal.contains("<DocIssDate>")) ? rowVal.substring(rowVal.indexOf("<DocIssDate>")+"</DocIssDate>".length()-1,rowVal.indexOf("</DocIssDate>")):"";
							try{
								EMREGExp = EMREGExp.substring(8,10)+"/"+EMREGExp.substring(5,7)+"/"+EMREGExp.substring(0,4);
							}catch(Exception ex){
								EMREGExp="";
							}try{
								EMREGissdate = EMREGissdate.substring(8,10)+"/"+EMREGissdate.substring(5,7)+"/"+EMREGissdate.substring(0,4);
							}catch(Exception ex){
								EMREGissdate="";
							}
							//WriteLog("\nwdesk:EMREG_exis~"+EMREG);
								
							//WriteLog( "\nwdesk:EMREGIssuedate_new~"+EMREGExp);
							//WriteLog( "\nwdesk:EMREGIssuedate_exis~"+EMREGissdate);
						}
						
						
						//CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
						 CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						countwhilchk++;
						if(countwhilchk == 100)
						{
							countwhilchk = 0;
							break;
						}
					}
					
					countwhilchk = 0;
					while(CustomerDetails.contains("<EmailDet>"))
					{	
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<EmailDet>"),CustomerDetails.indexOf("</EmailDet>")+"</EmailDet>".length());
						
						String MailIdType =  (rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
						mailPrefFlag =   (rowVal.contains("<MailPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<MailPrefFlag>")+"</MailPrefFlag>".length()-1,rowVal.indexOf("</MailPrefFlag>")):"";
						
						if(mailPrefFlag.equalsIgnoreCase("Y"))
						{
							PrimaryEmail =  (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
							mailPrefFlag1="Primary Email ID";
							MailType=(rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
							
							//WriteLog("\nMailType---- "+MailType);
							//WriteLog("\nPrimaryEmail pref Y "+PrimaryEmail);
							//WriteLog("\nPrimaryEmail mailPrefFlag "+mailPrefFlag);
						}
						else if(MailIdType.equalsIgnoreCase("PreferredEmailId1") && PrimaryEmail.equalsIgnoreCase(""))
						{
							MailType=(rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
							PrimaryEmail =  (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
							//WriteLog("\nMailType when ELM1---- "+MailType);
							//WriteLog("\nPrimaryEmail pref N "+PrimaryEmail);
							//WriteLog("\nPrimaryEmail mailPrefFlag "+mailPrefFlag);
						}
						if(MailIdType.equalsIgnoreCase("PreferredEmailId2"))
						{
							SecondaryEmail = (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
							//WriteLog("\nSecondaryEmail pref N "+SecondaryEmail);
						}
						
						//CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						countwhilchk++;
						if(countwhilchk == 100)
						{
							
							countwhilchk = 0;
							break;
						}
					}
					countwhilchk = 0;
					while(CustomerDetails.contains("<SubscriptionDet>"))
					{
						//WriteLog("In SubscriptionDet");
						
						  rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<SubscriptionDet>"),CustomerDetails.indexOf("</SubscriptionDet>")+"</SubscriptionDet>".length());
			
			
					//WriteLog("Subscription Det fetched rowval"+rowVal);
						if(rowVal.indexOf("Account e-Statements") != -1 || rowVal.indexOf("Loan e-Statements") != -1 || rowVal.indexOf("Card e-Statements") != -1 || rowVal.indexOf("Deposits e-Statements") != -1 ||rowVal.indexOf("Investments e-Statements") != -1 || rowVal.indexOf("Remittances e-Statements") != -1 )
						{
							
							SubscriptionFlag =  (rowVal.contains("<SubscriptionFlag>")) ? rowVal.substring(rowVal.indexOf("<SubscriptionFlag>")+"</SubscriptionFlag>".length()-1,rowVal.indexOf("</SubscriptionFlag>")):"";
							
							//WriteLog(SubscriptionFlag + "As fetch from row ");
							if(SubscriptionFlag.equalsIgnoreCase("Y"))
							{
								SubscriptionFlag = "N";
								sFlag="1";
							}
						}	
						if(sFlag=="1")
					{
						SubscriptionFlag = "Y";
						break;
					}
					//WriteLog(sFlag + "sFlag");
					//WriteLog("countwhilchk : " + countwhilchk);
					//WriteLog(SubscriptionFlag + "SubscriptionFlag");
					CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						countwhilchk++;
						if(countwhilchk == 100)
						{
							
							countwhilchk = 0;
							//WriteLog("In Check Subscription");
							break;
						}
					}
					
					
					
			
					countwhilchk = 0; 
					while(CustomerDetails.contains("<EmpDet>"))
					{
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<EmpDet>"),CustomerDetails.indexOf("</EmpDet>")+"</EmpDet>".length());
						
						
						EmployerID =  (rowVal.contains("<EmployerID>")) ? rowVal.substring(rowVal.indexOf("<EmployerID>")+"</EmployerID>".length()-1,rowVal.indexOf("</EmployerID>")):"";
						
						EmploymentType =  (rowVal.contains("<EmploymentType>")) ? rowVal.substring(rowVal.indexOf("<EmploymentType>")+"</EmploymentType>".length()-1,rowVal.indexOf("</EmploymentType>")):"";
						Desig = (rowVal.contains("<Desig>")) ? rowVal.substring(rowVal.indexOf("<Desig>")+"</Desig>".length()-1,rowVal.indexOf("</Desig>")) : "" ;
						EmployerName = (rowVal.contains("<EmployerName>")) ? rowVal.substring(rowVal.indexOf("<EmployerName>")+"</EmployerName>".length()-1,rowVal.indexOf("</EmployerName>")) : "" ;
						EmployerName = EmployerName.replaceAll("&amp;","");
						
						
						DepartmentName = (rowVal.contains("<DepartmentName>")) ? rowVal.substring(rowVal.indexOf("<DepartmentName>")+"</DepartmentName>".length()-1,rowVal.indexOf("</DepartmentName>")) : "" ;
						EmployeeNumber = (rowVal.contains("<EmployeeNumber>")) ? rowVal.substring(rowVal.indexOf("<EmployeeNumber>")+"</EmployeeNumber>".length()-1,rowVal.indexOf("</EmployeeNumber>")) : "" ;
						
						//WriteLog("\nEmployeeNumber--->"+EmployeeNumber);
						Occupation = (rowVal.contains("<Occupation>")) ? rowVal.substring(rowVal.indexOf("<Occupation>")+"</Occupation>".length()-1,rowVal.indexOf("</Occupation>")) : "" ;
						EmployeeStatus = (rowVal.contains("<EmployeeStatus>")) ? rowVal.substring(rowVal.indexOf("<EmployeeStatus>")+"</EmployeeStatus>".length()-1,rowVal.indexOf("</EmployeeStatus>")) : "" ;
						
						String query = "select empstatustypedisplay from usr_0_cu_EmployementStatus with (nolock) where empstatuscode=:empstatuscode";
						params = "empstatuscode=="+EmployeeStatus;
						
						String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
						
						//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
						
						//WriteLog("\nInputXML empstatustypedisplay-->"+inputXML);
						String outputXML = WFCustomCallBroker.execute(inputXML, sJtsIp, iJtsPort, 1);
						//WriteLog("\noutputXML empstatustypedisplay-->"+outputXML);
						
						WFCustomXmlResponse xmlParserData=new WFCustomXmlResponse();
						xmlParserData.setXmlString((outputXML));
						String mainCodeValue = xmlParserData.getVal("MainCode");
						String subXML="";
						WFCustomXmlResponse objXmlParser=null;
						
						if(mainCodeValue.equals("0"))
						{
							EmployeeStatus = xmlParserData.getVal("empstatustypedisplay");
							//WriteLog("\nempstatustypedisplay--->"+EmployeeStatus);	
						}
						
						try{
							DOJ = rowVal.substring(rowVal.indexOf("<DOJ>")+"</DOJ>".length()-1,rowVal.indexOf("</DOJ>"));
							DOJ = DOJ.substring(8,10)+"/"+DOJ.substring(5,7)+"/"+DOJ.substring(0,4);
						}catch(Exception ex){
							DOJ="";
						}
						//CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						countwhilchk++;
						if(countwhilchk == 100)
						{
							
							countwhilchk = 0;
							break;
						}
					}
					//Added by Shamily to fetch OECD Details Fields value
					try{
						countwhilchk = 0;
						while(CustomerDetails.contains("<OECDDet>"))
						{
							rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<OECDDet>"),CustomerDetails.indexOf("</OECDDet>")+"</OECDDet>".length());
							
							
							CityOfBirth =  (rowVal.contains("<CityOfBirth>")) ? rowVal.substring(rowVal.indexOf("<CityOfBirth>")+"</CityOfBirth>".length()-1,rowVal.indexOf("</CityOfBirth>")):"";
							CountryOfBirth = (rowVal.contains("<CountryOfBirth>")) ? rowVal.substring(rowVal.indexOf("<CountryOfBirth>")+"</CountryOfBirth>".length()-1,rowVal.indexOf("</CountryOfBirth>")) : "" ;
							
							String queryCountry = "select countryName from USR_0_CU_CountryMaster with (nolock) where countrycode=:countrycode";
							
							params = "countrycode=="+CountryOfBirth;
							
							String inputXMLCountry = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryCountry + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							//String inputXMLCountry = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + queryCountry + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							 //WriteLog("\nInputXML CUSTOMER_DETAILS 123567-->"+inputXMLCountry);
							String outputXMLCountry = WFCustomCallBroker.execute(inputXMLCountry, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS exceptions-->"+outputXMLCountry);
							
							WFCustomXmlResponse xmlParserData1=new WFCustomXmlResponse();
							xmlParserData1.setXmlString((outputXMLCountry));
							String mainCodeValueCountry = xmlParserData1.getVal("MainCode");
							
							WFCustomXmlResponse objXmlParser1=null;
							
							if(mainCodeValueCountry.equals("0"))
							{
								CountryOfBirth = xmlParserData1.getVal("countryName");
								//WriteLog("\ncountryName CUSTOMER_DETAILS"+CountryOfBirth);	
							}
							
							CRSUnDocFlg = (rowVal.contains("<CRSUnDocFlg>")) ? rowVal.substring(rowVal.indexOf("<CRSUnDocFlg>")+"</CRSUnDocFlg>".length()-1,rowVal.indexOf("</CRSUnDocFlg>")) : "" ;
							CRSUndocFlgReason = (rowVal.contains("<CRSUndocFlgReason>")) ? rowVal.substring(rowVal.indexOf("<CRSUndocFlgReason>")+"</CRSUndocFlgReason>".length()-1,rowVal.indexOf("</CRSUndocFlgReason>")) : "" ;
							String temp="";
			
							String rowVal1= "";
							while(CustomerDetails.contains("<ReporCntryDet>"))
							{    
								rowVal1 = CustomerDetails.substring(CustomerDetails.indexOf("<ReporCntryDet>"),CustomerDetails.indexOf("</ReporCntryDet>")+"</ReporCntryDet>".length());
							
				
								CntryOfTaxRes =(rowVal1.contains("<CntryOfTaxRes>")) ? rowVal1.substring(rowVal1.indexOf("<CntryOfTaxRes>")+"<CntryOfTaxRes>".length(),rowVal1.indexOf("</CntryOfTaxRes>")):"";
								//WriteLog("CntryOfTaxRes--"+CntryOfTaxRes);
								String queryCountryTax = "select countryName from USR_0_CU_CountryMaster with (nolock) where countrycode=:countrycode";
							
								params = "countrycode=="+CntryOfTaxRes;
								String inputXMLCountryTax = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryCountryTax + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							//String inputXMLCountryTax = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + queryCountryTax + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							// WriteLog("\nInputXML CUSTOMER_DETAILS 123567-->"+inputXMLCountryTax);
							String outputXMLCountryTax = WFCustomCallBroker.execute(inputXMLCountryTax, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS exceptions-->"+outputXMLCountryTax);
							
							WFCustomXmlResponse xmlParserData2=new WFCustomXmlResponse();
							xmlParserData2.setXmlString((outputXMLCountryTax));
							String mainCodeValueCountryTax = xmlParserData2.getVal("MainCode");
							
							WFCustomXmlResponse objXmlParser2=null;
							
							if(mainCodeValueCountryTax.equals("0"))
							{
								CntryOfTaxRes = xmlParserData2.getVal("countryName");
								//WriteLog("\ncountryName CUSTOMER_DETAILS"+CntryOfTaxRes);	
							}
								TINNumber = (rowVal1.contains("<TINNumber>")) ? rowVal1.substring(rowVal1.indexOf("<TINNumber>")+"<TINNumber>".length(),rowVal1.indexOf("</TINNumber>")):"";
								//WriteLog("TINNumber--"+TINNumber);
								NoTINReason =(rowVal1.contains("<NoTINReason>")) ? rowVal1.substring(rowVal1.indexOf("<NoTINReason>")+"<NoTINReason>".length(),rowVal1.indexOf("</NoTINReason>")):"";
								MiscellaniousId = (rowVal1.contains("<MiscellaneousID>")) ? rowVal1.substring(rowVal1.indexOf("<MiscellaneousID>")+"<MiscellaneousID>".length(),rowVal1.indexOf("</MiscellaneousID>")):"";
								//WriteLog("NoTINReason--"+NoTINReason);
								if(temp=="")
								temp=CntryOfTaxRes+"@$"+TINNumber+"@$"+NoTINReason+"@$"+MiscellaniousId+"@$";
								else
								temp=temp+CntryOfTaxRes+"@$"+TINNumber+"@$"+NoTINReason+"@$"+MiscellaniousId+"@$";
				
				
								CustomerDetails = CustomerDetails.replaceAll(rowVal1, "");
				
								
								
				
								}
							
							//WriteLog("temp--->"+temp);
							if(!temp.equals(""))
							 {
							 CntryOfTaxRes1 = temp.substring(0,temp.indexOf("$"));

							if(CntryOfTaxRes1.equals("@"))
							{
								CntryOfTaxRes1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes1 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes1Rep=CntryOfTaxRes1+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes1Rep)+CntryOfTaxRes1Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes1+"@$","");
							 }	
							//WriteLog("CntryOfTaxRes1-->"+CntryOfTaxRes1);
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber1 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber1.equals("@"))
							{
								TINNumber1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber1 = temp.substring(0,temp.indexOf("@$"));
								
								temp = temp.replace(TINNumber1+"@$","");
							}	
							//WriteLog("TINNumber1-->"+TINNumber1);
							
							
							//WriteLog("temp after replace TINNumber1 -->"+temp);
							 NoTINReason1 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason1.equals("@"))
							{
								NoTINReason1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason1 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason1Rep=NoTINReason1+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason1Rep)+NoTINReason1Rep.length(),temp.length());
								//temp = temp.replace(NoTINReason1+"@$","");
							}	
							MiscellaniousId1 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId1.equals("@"))
							{
								MiscellaniousId1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId1 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId1+"@$","");
							}	
							//WriteLog("MiscellaniousId1-->"+MiscellaniousId1);
							
							
							
							//WriteLog("temp after replace MiscellaniousId1 -->"+temp);
							}
							if(!temp.equals(""))
							 {
							CntryOfTaxRes2 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes2-->"+CntryOfTaxRes2);
							if(CntryOfTaxRes2.equals("@"))
							{
								CntryOfTaxRes2 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes2 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes2Rep=CntryOfTaxRes2+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes2Rep)+CntryOfTaxRes2Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes2+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber2 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber2.equals("@"))
							{
								TINNumber2 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber2 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber2+"@$","");
							}	
							//WriteLog("TINNumber2-->"+TINNumber2);
							
							
							
							//WriteLog("temp after replace TINNumber2 -->"+temp);
							 NoTINReason2 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason2.equals("@"))
							{
								NoTINReason2 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason2 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason2rep = NoTINReason2+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason2rep)+NoTINReason2rep.length(),temp.length());
							//	temp = temp.replace(NoTINReason2+"@$","");
							}

							MiscellaniousId2 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId2.equals("@"))
							{
								MiscellaniousId2 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId2 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId2+"@$","");
							}	
							//WriteLog("MiscellaniousId1-->"+MiscellaniousId2);
							
							
							
							//WriteLog("temp after replace MiscellaniousId2 -->"+temp);							
								
							}
							if(!temp.equals(""))
							 {						
							CntryOfTaxRes3 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes3-->"+CntryOfTaxRes3);
							if(CntryOfTaxRes3.equals("@"))
							{
								CntryOfTaxRes3 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes3 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes3Rep=CntryOfTaxRes3+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes3Rep)+CntryOfTaxRes3Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes3+"@$","");
							 }
								
							//WriteLog("temp after replace -->"+temp);
							 TINNumber3 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber3.equals("@"))
							{
								TINNumber3 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber3 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber3+"@$","");
							}	
							//WriteLog("TINNumber3-->"+TINNumber3);
							
							
							//WriteLog("temp after replace TINNumber3 -->"+temp);
							 NoTINReason3 = temp.substring(0,temp.indexOf("$"));
							 if(NoTINReason3.equals("@"))
							{
								NoTINReason3 = "";
									temp = temp.substring(2,temp.length());
							}	
							 else
							 {
								NoTINReason3 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason3Rep=NoTINReason3+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason3Rep)+NoTINReason3Rep.length(),temp.length());
								//temp = temp.replace(NoTINReason3+"@$","");
							}	
							
							// WriteLog("temp after replace NoTINReason3 -->"+temp);
							 
							 MiscellaniousId3 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId3.equals("@"))
							{
								MiscellaniousId3 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId3 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId3+"@$","");
							}	
							//WriteLog("MiscellaniousId3-->"+MiscellaniousId3);
							
							
							
							//WriteLog("temp after replace MiscellaniousId3 -->"+temp);	
							}

								if(!temp.equals(""))
							 {
							 CntryOfTaxRes4 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes4-->"+CntryOfTaxRes4);
							if(CntryOfTaxRes4.equals("@"))
							{
								CntryOfTaxRes4 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes4 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes4Rep=CntryOfTaxRes4+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes4Rep)+CntryOfTaxRes4Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes4+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber4 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber4.equals("@"))
							{
								TINNumber4 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber4 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber4+"@$","");
							}	
							//WriteLog("TINNumber4-->"+TINNumber4);
							
							
							//WriteLog("temp after replace TINNumber4 -->"+temp);
							 NoTINReason4 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason4.equals("@"))
							{
								NoTINReason4 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason4 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason4Rep=NoTINReason4+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason4Rep)+NoTINReason4Rep.length(),temp.length());
								//temp = temp.replace(NoTINReason4+"@$","");
							}	
							
							//WriteLog("NoTINReason4-->"+NoTINReason4);
							
							
							//WriteLog("temp after replace NoTINReason4 -->"+temp);
							
							 MiscellaniousId4 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId4.equals("@"))
							{
								MiscellaniousId4 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId4 = temp.substring(0,temp.indexOf("@$"));
								//WriteLog("MiscellaniousId4-->"+MiscellaniousId4);
								temp = temp.replace(MiscellaniousId4+"@$","");
							}	
							//WriteLog("MiscellaniousId4-->"+MiscellaniousId4);
							
							
							
							//WriteLog("temp after replace MiscellaniousId4-->"+temp);	
							 }
							 if(!temp.equals(""))
							 {
							 CntryOfTaxRes5 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes5-->"+CntryOfTaxRes5);
							if(CntryOfTaxRes5.equals("@"))
							{
								CntryOfTaxRes5 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes5 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes5Rep=CntryOfTaxRes5+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes5Rep)+CntryOfTaxRes5Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes5+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber5 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber5.equals("@"))
							{
								TINNumber5 = "";
									temp = temp.substring(2,temp.length());
							}	
							
							else
							 {
								TINNumber5 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber5+"@$","");
							}	
							
							//WriteLog("temp after replace TINNumber5 -->"+temp);
							 NoTINReason5 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason5.equals("@"))
							{
								NoTINReason5 = "";
								temp = temp.substring(2,temp.length());
							}	
							
							else
							 {
								NoTINReason5 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason5Rep=NoTINReason5+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason5Rep)+NoTINReason5Rep.length(),temp.length());
								//temp = temp.replace(TINNumber5+"@$","");
							}
							
							 MiscellaniousId5 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId5.equals("@"))
							{
								MiscellaniousId5 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId5 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId5+"@$","");
							}	
							//WriteLog("MiscellaniousId5-->"+MiscellaniousId5);
							
							
							
							//WriteLog("temp after replace MiscellaniousId5-->"+temp);	
							 }
							 if(!temp.equals(""))
							 {
							 CntryOfTaxRes6 = temp.substring(0,temp.indexOf("$"));
							
							if(CntryOfTaxRes6.equals("@"))
							{
								CntryOfTaxRes6 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							{
								CntryOfTaxRes6 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes6Rep=CntryOfTaxRes6+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes6Rep)+CntryOfTaxRes6Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes6+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 
							 TINNumber6 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber6.equals("@"))
							{
								TINNumber6 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber6 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber6+"@$","");
							}	
							//WriteLog("TINNumber6-->"+TINNumber6);
							
							
							//WriteLog("temp after replace TINNumber6 -->"+temp);
							 NoTINReason6 = temp.substring(0,temp.indexOf("$"));
							
							//WriteLog("NoTINReason6-->"+NoTINReason6);
							if(NoTINReason6.equals("@"))
							{
								NoTINReason6 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason6 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(NoTINReason6+"$","");
							}	
							
							
							//WriteLog("temp after replace NoTINReason6 -->"+temp);
							
								 MiscellaniousId6 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId6.equals("@"))
							{
								MiscellaniousId6 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId6 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId6+"@$","");
							}	
							//WriteLog("MiscellaniousId6-->"+MiscellaniousId6);
							
							
							
							//WriteLog("temp after replace MiscellaniousId6-->"+temp);	
							}
							CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
							countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
						}
					}
					catch(Exception ex){
							WriteLog("in catch");
					}
					countwhilchk = 0;
					while(CustomerDetails.contains("<PhnDet>"))
					{
						
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<PhnDet>"),CustomerDetails.indexOf("</PhnDet>")+"</PhnDet>".length());
						
						String PhnType = (rowVal.contains("<PhnType>")) ? rowVal.substring(rowVal.indexOf("<PhnType>")+"</PhnType>".length()-1,rowVal.indexOf("</PhnType>")):"";
						
						if(PhnType.equalsIgnoreCase("CELLPH1"))
						{
							Phone1CountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							Phone1No = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							phnPrefFlag = (rowVal.contains("<PhnPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<PhnPrefFlag>")+"</PhnPrefFlag>".length()-1,rowVal.indexOf("</PhnPrefFlag>")):"";
							if(phnPrefFlag.equalsIgnoreCase("Y"))
							phnPrefFlag="Mobile Phone";
							//WriteLog("\nwdesk:MobilePhone_Existing~"+Phone1No);
							//WriteLog(Phone1CountryCode);
							//WriteLog("\nphnPrefFlagPhone1~"+phnPrefFlag);
							if (Phone1CountryCode.contains("971"))
								Phone1CountryCode = "00971";
						}
						else if(PhnType.equalsIgnoreCase("CELLPH2"))
						{
							Phone2CountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							Phone2No = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							if(phnPrefFlag.equalsIgnoreCase("N") || phnPrefFlag.equalsIgnoreCase(""))
							phnPrefFlag = (rowVal.contains("<PhnPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<PhnPrefFlag>")+"</PhnPrefFlag>".length()-1,rowVal.indexOf("</PhnPrefFlag>")):"";
							
							if(phnPrefFlag.equalsIgnoreCase("Y"))
							phnPrefFlag="2nd Mobile Phone";
							//WriteLog("\nwdesk:sec_mob_phone_exis~"+Phone2No);
							//WriteLog("\nphnPrefFlagphone2~"+phnPrefFlag);
							if (Phone2CountryCode.contains("971"))
								Phone2CountryCode = "00971";
						}
						else if(PhnType.equalsIgnoreCase("HOMEPH1"))
						{
							HomePhoneCountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							HomePhoneNo =  (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog("\nwdesk:homephone_exis~"+HomePhoneNo);
							if (HomePhoneCountryCode.contains("971"))
								HomePhoneCountryCode = "00971";
						}
						else if(PhnType.equalsIgnoreCase("OFFCPH1"))
						{
							OfficePhoneCountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							OfficePhoneNo =  (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog("\nwdesk:office_phn_exis~"+OfficePhoneNo);
							if (OfficePhoneCountryCode.contains("971"))
								OfficePhoneCountryCode = "00971";
						}
						else if(PhnType.equalsIgnoreCase("OVHOMEPH"))
						{
							HomeCountryPhoneCountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							HomeCountryPhoneNo = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog("\nwdesk:homecntryphone_exis~"+HomeCountryPhoneNo);
							if (HomeCountryPhoneCountryCode.contains("971"))
								HomeCountryPhoneCountryCode = "00971";
						}
						else if(PhnType.equalsIgnoreCase("FAXO1"))
						{
							FAX = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog( "\nwdesk:fax_exis~"+FAX);
						}
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						
						countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
						
						
					}
					
					//WriteLog("\npref_email_exis----->"+mailPrefFlag);

					
					cust_result ="wdesk:title_exis~"+Title+"`"+"wdesk:FirstName_Existing~"+FirstName+"`"+"wdesk:MiddleName_Existing~"+MiddleName+"`"+"wdesk:LastName_Existing~"+LastName+"`"+"wdesk:FullName_Existing~"+FullName+"`"+"wdesk:gender_exit~"+Gender+"`"+"wdesk:mother_maiden_name_exis~"+MothersName+"`"+"wdesk:PassportNumber_Existing~"+passportNo+"`"+"wdesk:passportExpDate_exis~"+passportExp+"`"+"wdesk:emirates_id~"+emiratesId+"`"+"emirates_id~"+emiratesId+"`"+"wdesk:emiratesidexp_exis~"+emiratesIdExp+"`"+"wdesk:visa_exis~"+visa+"`"+"wdesk:visaExpDate_exis~"+visaExp+"`"+"wdesk:prim_email_exis~"+PrimaryEmail+"`"+"wdesk:sec_email_exis~"+SecondaryEmail+"`"+"wdesk:pref_email_exis~"+mailPrefFlag1+"`"+"wdesk:MobilePhone_Existing~"+Phone1No+"`"+"wdesk:sec_mob_phone_exis~"+Phone2No+"`"+"wdesk:homecntryphone_exis~"+HomeCountryPhoneNo+"`"+"wdesk:homephone_exis~"+HomePhoneNo+"`"+"wdesk:office_phn_exis~"+OfficePhoneNo+"`"+"wdesk:pref_add_exis~"+addPrefFlag+"`"+"wdesk:pref_contact_exis~"+phnPrefFlag+"`"+"wdesk:nation_exist~"+Nationality+"`"+"wdesk:marrital_status_exis~"+MaritalStatus+"`"+"wdesk:abcdelig_exis~"+AECBConsentHeld+"`"+"wdesk:emp_type_exis~"+EmploymentType+"`"+"wdesk:EmployerCode_exis~"+EmployerID+"`"+"wdesk:country_of_res_exis~"+ResidentCountryExis+"`"+"wdesk:designation_exis~"+Desig+"`"+"wdesk:emp_name_exis~"+EmployerName+"`"+"wdesk:department_exis~"+DepartmentName+"`"+"wdesk:employee_num_exis~"+EmployeeNumber+"`"+"wdesk:occupation_exist~"+Occupation+"`"+"wdesk:employment_status_exis~"+EmployeeStatus+"`"+"wdesk:date_join_curr_employer_exis~"+DOJ+"`"+"wdesk:fax_exis~"+FAX+"`"+"wdesk:usnatholder_exis~"+US_National+"`"+"wdesk:USrelation~"+USRelation+"`"+"wdesk:IndustrySegment_exis~"+IndustrySegment+"`"+"wdesk:IndustrySubSegment_exis~"+IndustrySubSegment+"`"+"wdesk:FatcaReason~"+FatcaReason+"`"+"wdesk:CustomerType_exis~"+CustomerType+"`"+"wdesk:FatcaDoc~"+DocumentsCollected+"`"+"wdesk:nonResident~"+NonResidentFlag+"`"+"wdesk:DOB_exis~"+DOB+"`"+"wdesk:total_year_of_emp_exis~"+TotEmpYrs+"`"+"wdesk:years_of_business_exis~"+BusinessDuration+"`"+"wdesk:E_Stmnt_regstrd_exis~"+SubscriptionFlag+"`"+"wdesk:MailType~"+MailType+"`"+"wdesk:Oecdcity~"+CityOfBirth+"`"+"wdesk:Oecdcountry~"+CountryOfBirth+"`"+"wdesk:OECDUndoc_Flag~"+CRSUnDocFlg+"`"+"wdesk:OECDUndocreason_exist~"+CRSUndocFlgReason+"`"+"Oecdcountrytax~"+CntryOfTaxRes1+"`"+"wdesk:OecdTin~"+TINNumber1+"`"+"wdesk:OECDtinreason_exist~"+NoTINReason1+"`"+"Phone1CountryCode~"+Phone1CountryCode+"`"+"Phone2CountryCode~"+Phone2CountryCode+"`"+"HomePhoneCountryCode~"+HomePhoneCountryCode+"`"+"OfficePhoneCountryCode~"+OfficePhoneCountryCode+"`"+"HomeCountryPhoneCountryCode~"+HomeCountryPhoneCountryCode+"`"+"Oecdcountrytax2~"+CntryOfTaxRes2+"`"+"wdesk:OecdTin2~"+TINNumber2+"`"+"wdesk:OECDtinreason_exist2~"+NoTINReason2+"`"+"Oecdcountrytax3~"+CntryOfTaxRes3+"`"+"wdesk:OecdTin3~"+TINNumber3+"`"+"wdesk:OECDtinreason_exist3~"+NoTINReason3+"`"+"Oecdcountrytax4~"+CntryOfTaxRes4+"`"+"wdesk:OecdTin4~"+TINNumber4+"`"+"wdesk:OECDtinreason_exist4~"+NoTINReason4+"`"+"Oecdcountrytax5~"+CntryOfTaxRes5+"`"+"wdesk:OecdTin5~"+TINNumber5+"`"+"wdesk:OECDtinreason_exist5~"+NoTINReason5+"`"+"Oecdcountrytax6~"+CntryOfTaxRes6+"`"+"wdesk:OecdTin6~"+TINNumber6+"`"+"wdesk:OECDtinreason_exist6~"+NoTINReason6+"`"+"wdesk:Marsoon_exis~"+MARID+"`"+"wdesk:SignedDate_exis~"+SignedDate+"`"+"wdesk:ExpiryDate_exis~"+SignedExpiryDate+"`"+"wdesk:MiscellaniousId1~"+MiscellaniousId1+"`"+"wdesk:MiscellaniousId2~"+MiscellaniousId2+"`"+"wdesk:MiscellaniousId3~"+MiscellaniousId3+"`"+"wdesk:MiscellaniousId4~"+MiscellaniousId4+"`"+"wdesk:MiscellaniousId5~"+MiscellaniousId5+"`"+"wdesk:MiscellaniousId6~"+MiscellaniousId6;
				}
			}
			catch(Exception e){
				WriteLog("\nException occured in get Customer data:"+e);
			}
			
			out.clear();
			out.println(cust_result);
			WriteLog( "\nOutput : Entity_details---cust_result---"+cust_result);
		}
		else if (requestType.equalsIgnoreCase("CUSTOMER_DETAILS") && cif_type.equalsIgnoreCase("Individual"))
		{
							
			String ACCNumber="";
			String MobileNumber="";
			String EmiratesID="";
			String ACCType="";
			String CIF_ID="";
			String username="",sessionId="",engineName="";
			
			String inputCustomerDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				"<ProcessName>CU</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>CUSTOMER_SUMMARY</MsgFormat>\n"+
				"<MsgVersion>0000</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><ACCType>"+ACCType+"</ACCType><ACCNumber>"+ACCNumber+"</ACCNumber><MobileNumber>"+MobileNumber+"<MobileNumber><EmiratesID>"+EmiratesID+"</EmiratesID><InquiryType>Customer</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
			
				
			sMappOutPutXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
				
			//sMappOutPutXML = "";
			
			// Output Xml From File Customer_Details.txt For Testing Purpose
			String a = System.getProperty("user.dir");
			String stestXML = readFileFromServer(a+File.separator+"CUTesting"+File.separator+"Customer_Details.txt");
			//sMappOutPutXML = stestXML;
			
			//String outputXml = getCustDetails(sMappOutPutXML,sJtsIp,iJtsPort,sCabName,sSessionId);
			
			String rowVal="";
			String CustomerDetails="";
			String IsPremium ="";
			String Title="";
			String FirstName ="";
			String MiddleName ="";
			String LastName ="";
			String FullName ="";
			String Gender ="";
			String MothersName ="";
			String Nationality ="";
			String ResidentCountryExis ="";
			String cust_result ="";
			String MaritalStatus="";
			String AECBConsentHeld="";
			String CustomerSubSeg="";
			String ARMName="";
			String US_National="No";
			String USRelation="";
			String IndustrySegment="";
			String IndustrySubSegment="";
			String FatcaReason="";
			String CustomerType="";
			String DocumentsCollected="";
			String SignedDate="";
			String SignedExpiryDate="";
			String NonResidentFlag="";
			String TotEmpYrs="";
			String BusinessDuration="";
			String DOB="";
			String CountryRes="";
			String CityRes="";
			String CountryOffc="";
			String CityOffc="";
			try{
				if(sMappOutPutXML.contains("<CustomerDetails>"))
				{
					CustomerDetails = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CustomerDetails>"),sMappOutPutXML.indexOf("</CustomerDetails>")+"</CustomerDetails>".length());
					if(CustomerDetails.contains("<IsPremium>"))
					{
						IsPremium = CustomerDetails.substring(CustomerDetails.indexOf("<IsPremium>")+"</IsPremium>".length()-1,CustomerDetails.indexOf("</IsPremium>"));
						if (IsPremium.equalsIgnoreCase("B"))
						{
							IsPremium = "Y";
						}
					}
					if(CustomerDetails.contains("<CustomerSubSeg>"))
					{
						CustomerSubSeg = CustomerDetails.substring(CustomerDetails.indexOf("<CustomerSubSeg>")+"</CustomerSubSeg>".length()-1,CustomerDetails.indexOf("</CustomerSubSeg>"));
					}
					if(CustomerDetails.contains("<ARMName>"))
					{
						ARMName = CustomerDetails.substring(CustomerDetails.indexOf("<ARMName>")+"</ARMName>".length()-1,CustomerDetails.indexOf("</ARMName>"));
					}
					if(CustomerDetails.contains("<Title>"))
					{
						Title = CustomerDetails.substring(CustomerDetails.indexOf("<Title>")+"</Title>".length()-1,CustomerDetails.indexOf("</Title>"));
					}
					if(CustomerDetails.contains("<FirstName>"))
					{
						FirstName = CustomerDetails.substring(CustomerDetails.indexOf("<FirstName>")+"</FirstName>".length()-1,CustomerDetails.indexOf("</FirstName>"));
					}
					if(CustomerDetails.contains("<MiddleName>"))
					{
						MiddleName = CustomerDetails.substring(CustomerDetails.indexOf("<MiddleName>")+"</MiddleName>".length()-1,CustomerDetails.indexOf("</MiddleName>"));
					}
					if(CustomerDetails.contains("<LastName>"))
					{
						LastName = CustomerDetails.substring(CustomerDetails.indexOf("<LastName>")+"</LastName>".length()-1,CustomerDetails.indexOf("</LastName>"));
					}
					if(CustomerDetails.contains("<FullName>"))
					{
						FullName = CustomerDetails.substring(CustomerDetails.indexOf("<FullName>")+"</FullName>".length()-1,CustomerDetails.indexOf("</FullName>"));
					}
					if(CustomerDetails.contains("<Gender>"))
					{
						Gender = CustomerDetails.substring(CustomerDetails.indexOf("<Gender>")+"</Gender>".length()-1,CustomerDetails.indexOf("</Gender>"));
					}
					if(CustomerDetails.contains("<MothersName>"))
					{
						MothersName = CustomerDetails.substring(CustomerDetails.indexOf("<MothersName>")+"</MothersName>".length()-1,CustomerDetails.indexOf("</MothersName>"));
					}
					if(CustomerDetails.contains("<Nationality>"))
					{
						Nationality = CustomerDetails.substring(CustomerDetails.indexOf("<Nationality>")+"</Nationality>".length()-1,CustomerDetails.indexOf("</Nationality>"));
						if(Nationality.equalsIgnoreCase("US")){
							US_National = "Yes";
						}
					}
					if(CustomerDetails.contains("<ResidentCountry>"))
					{
						ResidentCountryExis = CustomerDetails.substring(CustomerDetails.indexOf("<ResidentCountry>")+"</ResidentCountry>".length()-1,CustomerDetails.indexOf("</ResidentCountry>"));
						
						//WriteLog("ResidentCountryExis "+ResidentCountryExis);
					}
					//ResidentCountryExis = "AE"; //commented by Ankit 28042018 due to production issue
					if(CustomerDetails.contains("<MaritalStatus>"))
					{
						MaritalStatus = CustomerDetails.substring(CustomerDetails.indexOf("<MaritalStatus>")+"</MaritalStatus>".length()-1,CustomerDetails.indexOf("</MaritalStatus>"));
					}
					if(CustomerDetails.contains("<AECBConsentHeld>"))
					{
						AECBConsentHeld = CustomerDetails.substring(CustomerDetails.indexOf("<AECBConsentHeld>")+"</AECBConsentHeld>".length()-1,CustomerDetails.indexOf("</AECBConsentHeld>"));
					}
					
					if(CustomerDetails.contains("<USRelation>"))
					{
						USRelation = CustomerDetails.substring(CustomerDetails.indexOf("<USRelation>")+"</USRelation>".length()-1,CustomerDetails.indexOf("</USRelation>"));
					}
					if(CustomerDetails.contains("<IndustrySegment>"))
					{
						IndustrySegment = CustomerDetails.substring(CustomerDetails.indexOf("<IndustrySegment>")+"</IndustrySegment>".length()-1,CustomerDetails.indexOf("</IndustrySegment>"));
					}
					if(CustomerDetails.contains("<IndustrySubSegment>"))
					{
						IndustrySubSegment = CustomerDetails.substring(CustomerDetails.indexOf("<IndustrySubSegment>")+"</IndustrySubSegment>".length()-1,CustomerDetails.indexOf("</IndustrySubSegment>"));
					}
					if(CustomerDetails.contains("<FatcaReason>"))
					{
						FatcaReason = CustomerDetails.substring(CustomerDetails.indexOf("<FatcaReason>")+"</FatcaReason>".length()-1,CustomerDetails.indexOf("</FatcaReason>"));
					}
					if(CustomerDetails.contains("<CustomerType>"))
					{
						CustomerType = CustomerDetails.substring(CustomerDetails.indexOf("<CustomerType>")+"</CustomerType>".length()-1,CustomerDetails.indexOf("</CustomerType>"));
					}
					if(CustomerDetails.contains("<DocumentsCollected>"))
					{
						DocumentsCollected = CustomerDetails.substring(CustomerDetails.indexOf("<DocumentsCollected>")+"</DocumentsCollected>".length()-1,CustomerDetails.indexOf("</DocumentsCollected>"));
					}
					if(CustomerDetails.contains("<SignedDate>"))
					{
						SignedDate = CustomerDetails.substring(CustomerDetails.indexOf("<SignedDate>")+"</SignedDate>".length()-1,CustomerDetails.indexOf("</SignedDate>"));

						try{
							//SignedDate = SignedDate.substring(8,10)+"/"+SignedDate.substring(5,7)+"/"+SignedDate.substring(0,4);
							SignedDate = SignedDate.replaceAll("-","/");
						}catch(Exception ex){
							SignedDate="";
						}	
					}if(CustomerDetails.contains("<SignedExpiryDate>"))
					{
						SignedExpiryDate = CustomerDetails.substring(CustomerDetails.indexOf("<SignedExpiryDate>")+"</SignedExpiryDate>".length()-1,CustomerDetails.indexOf("</SignedExpiryDate>"));

						try{
							//SignedExpiryDate = SignedExpiryDate.substring(8,10)+"/"+SignedExpiryDate.substring(5,7)+"/"+SignedExpiryDate.substring(0,4);
							SignedExpiryDate = SignedExpiryDate.replaceAll("-","/");
						}catch(Exception ex){
							SignedExpiryDate="";
						}	
					}
					if(CustomerDetails.contains("<NonResidentFlag>"))
					{
						NonResidentFlag = CustomerDetails.substring(CustomerDetails.indexOf("<NonResidentFlag>")+"</NonResidentFlag>".length()-1,CustomerDetails.indexOf("</NonResidentFlag>"));
					}
					if(CustomerDetails.contains("<TotEmpYrs>"))
					{
						TotEmpYrs = CustomerDetails.substring(CustomerDetails.indexOf("<TotEmpYrs>")+"</TotEmpYrs>".length()-1,CustomerDetails.indexOf("</TotEmpYrs>"));
					}
					if(CustomerDetails.contains("<BusinessDuration>"))
					{
						BusinessDuration = CustomerDetails.substring(CustomerDetails.indexOf("<BusinessDuration>")+"</BusinessDuration>".length()-1,CustomerDetails.indexOf("</BusinessDuration>"));
					}
					
					if(CustomerDetails.contains("<DOB>"))
					{
						DOB = CustomerDetails.substring(CustomerDetails.indexOf("<DOB>")+"</DOB>".length()-1,CustomerDetails.indexOf("</DOB>"));

						try{
							DOB = DOB.substring(8,10)+"/"+DOB.substring(5,7)+"/"+DOB.substring(0,4);
						}catch(Exception ex){
							DOB="";
						}	
					}
				
					String passportNo="";
					String passportExp="";
					String emiratesId="";
					String emiratesIdExp="";
					String visa="";
					String visaExp="";
					// added by Shamily to fetch MARID,EMREG fields
					String MARID="";
					String MARIDExp="";
					String EMREG="";
					String EMREGExp="";
					String EMREGissdate="";
					String OfficeAddress="";
					String ResidenceAddress="";
					String PrimaryEmail="";
					String SecondaryEmail="";
					String Phone1CountryCode="";
					//Added by Shamily to fetch OECD Details Fields value
					String CityOfBirth="";
					String CountryOfBirth="";
					String CRSUnDocFlg="";
					String CRSUndocFlgReason="";
					String CntryOfTaxRes="";
					String TINNumber="";
					String NoTINReason="";
					String CntryOfTaxRes1="";
					String TINNumber1="";
					String NoTINReason1="";
					String MiscellaniousId1="";
					String CntryOfTaxRes2="";
					String TINNumber2="";
					String NoTINReason2="";
					String MiscellaniousId2="";
					String CntryOfTaxRes3="";
					String TINNumber3="";
					String NoTINReason3="";
					String MiscellaniousId3="";
					String CntryOfTaxRes4="";
					String TINNumber4="";
					String NoTINReason4="";
					String MiscellaniousId4="";
					String CntryOfTaxRes5="";
					String TINNumber5="";
					String NoTINReason5="";
					String MiscellaniousId5="";
					String CntryOfTaxRes6="";
					String TINNumber6="";
					String NoTINReason6="";
					String MiscellaniousId6="";
					String Phone2CountryCode="";
					String HomePhoneCountryCode="";
					String OfficePhoneCountryCode="";
					String HomeCountryPhoneCountryCode="";
					String Phone1No="";
					String Phone2No="";
					String HomePhoneNo="";
					String OfficePhoneNo="";
					String HomeCountryPhoneNo="";
					String addPrefFlag="";
					String phnPrefFlag="";
					String mailPrefFlag="";
					String EmploymentType="";
					String Desig="";
					String EmployerName="";
					String DepartmentName="";
					String EmployeeNumber="";
					String Occupation="";
					String EmployeeStatus="";
					String DOJ="";
					String FAX="";
					String mailPrefFlag1="";
					String MailType = "";
					countwhilchk = 0;
					while(CustomerDetails.contains("<DocumentDet>"))
					{
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<DocumentDet>"),CustomerDetails.indexOf("</DocumentDet>")+"</DocumentDet>".length());
						
						String DocType = (rowVal.contains("<DocType>")) ? rowVal.substring(rowVal.indexOf("<DocType>")+"</DocType>".length()-1,rowVal.indexOf("</DocType>")):"";
						//WriteLog( "\nDocType: "+DocType);
						if(DocType.equalsIgnoreCase("Passport"))
						{
							passportNo = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							passportExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							try{
								passportExp = passportExp.substring(8,10)+"/"+passportExp.substring(5,7)+"/"+passportExp.substring(0,4);
							}catch(Exception ex){
								passportExp="";
							}	
							//WriteLog( "\nwdesk:PassportNumber_Existing~"+passportNo);
							//WriteLog( "\nwdesk:passportExpDate_exis~**"+passportExp);
							
						}
						else if(DocType.equalsIgnoreCase("EMID"))
						{
							emiratesId = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							
							try{
								emiratesIdExp = rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>"));
								emiratesIdExp = emiratesIdExp.substring(8,10)+"/"+emiratesIdExp.substring(5,7)+"/"+emiratesIdExp.substring(0,4);
							}catch(Exception ex){
								emiratesIdExp="";
							}
							//WriteLog( "\nwdesk:emiratesid~"+emiratesId);
							//WriteLog( "\nwdesk:emiratesidexp_exis~"+emiratesIdExp);
						}
						else if(DocType.equalsIgnoreCase("Visa"))
						{
							visa = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							visaExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							try{
								visaExp = visaExp.substring(8,10)+"/"+visaExp.substring(5,7)+"/"+visaExp.substring(0,4);
							}catch(Exception ex){
								visaExp="";
							}
							//WriteLog( "\nwdesk:visa_exis~"+visa);
							//WriteLog( "\nwdesk:visaExpDate_exis~"+visaExp);
						}
							// added by Shamily to fetch MARID,EMREG fields
						else if(DocType.equalsIgnoreCase("MARID"))
						{
							MARID = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							MARIDExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							try{
								MARIDExp = MARIDExp.substring(8,10)+"/"+MARIDExp.substring(5,7)+"/"+MARIDExp.substring(0,4);
							}catch(Exception ex){
								MARIDExp="";
							}
							//WriteLog("\nwdesk:Marsoon_exis~"+MARID);
								
							//WriteLog( "\nwdesk:marsoonExpDate_exis~"+MARIDExp);
						}
						
					else if(DocType.equalsIgnoreCase("EMREG"))
						{
							EMREG = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
							EMREGExp = (rowVal.contains("<DocExpDt>")) ? rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>")):"";
							EMREGissdate = (rowVal.contains("<DocIssDate>")) ? rowVal.substring(rowVal.indexOf("<DocIssDate>")+"</DocIssDate>".length()-1,rowVal.indexOf("</DocIssDate>")):"";
							try{
								EMREGExp = EMREGExp.substring(8,10)+"/"+EMREGExp.substring(5,7)+"/"+EMREGExp.substring(0,4);
							}catch(Exception ex){
								EMREGExp="";
							}try{
								EMREGissdate = EMREGissdate.substring(8,10)+"/"+EMREGissdate.substring(5,7)+"/"+EMREGissdate.substring(0,4);
							}catch(Exception ex){
								EMREGissdate="";
							}
							//WriteLog("\nwdesk:EMREG_exis~"+EMREG);
								
							//WriteLog( "\nwdesk:EMREGIssuedate_new~"+EMREGExp);
							//WriteLog( "\nwdesk:EMREGIssuedate_exis~"+EMREGissdate);
						}
						
						
						
						//CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						
						countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
						
					}
					
					countwhilchk = 0;
					while(CustomerDetails.contains("<EmailDet>"))
					{						
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<EmailDet>"),CustomerDetails.indexOf("</EmailDet>")+"</EmailDet>".length());
						
						String MailIdType =  (rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
						mailPrefFlag =   (rowVal.contains("<MailPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<MailPrefFlag>")+"</MailPrefFlag>".length()-1,rowVal.indexOf("</MailPrefFlag>")):"";
						
						
						if(mailPrefFlag.equalsIgnoreCase("Y"))
						{
							PrimaryEmail =  (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
							mailPrefFlag1="Primary Email ID";
							MailType=(rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
							
							//WriteLog( "\nMailType--entity_details2 "+MailType);
							//WriteLog( "\nPrimaryEmail pref Y "+PrimaryEmail);
							//WriteLog( "\nPrimaryEmail mailPrefFlag "+mailPrefFlag);
						}
						else if(MailIdType.equalsIgnoreCase("PreferredEmailId1"))
						{
							PrimaryEmail =  (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
							MailType=(rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
							//WriteLog( "\nMailType when ELM1---- "+MailType);
							//WriteLog( "\nPrimaryEmail pref N "+PrimaryEmail);
							//WriteLog( "\nPrimaryEmail mailPrefFlag "+mailPrefFlag);
						}
						if(MailIdType.equalsIgnoreCase("PreferredEmailId2"))
						{
							SecondaryEmail = (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";
							//WriteLog( "\nSecondaryEmail pref N "+SecondaryEmail);
						}
						
						//CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						//WriteLog( "\nend of  while mailPrefFlag "+mailPrefFlag);
						
						countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
					}
					
					countwhilchk = 0;
					while(CustomerDetails.contains("<SubscriptionDet>"))
					{
						WriteLog("In SubscriptionDet");
						  rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<SubscriptionDet>"),CustomerDetails.indexOf("</SubscriptionDet>")+"</SubscriptionDet>".length());
			
					//WriteLog("Subscription Det fetched rowval"+rowVal);
			
						if(rowVal.indexOf("Account e-Statements") != -1 || rowVal.indexOf("Loan e-Statements") != -1 || rowVal.indexOf("Card e-Statements") != -1 || rowVal.indexOf("Deposits e-Statements") != -1 ||rowVal.indexOf("Investments e-Statements") != -1 || rowVal.indexOf("Remittances e-Statements") != -1)
						{
							
							SubscriptionFlag =  (rowVal.contains("<SubscriptionFlag>")) ? rowVal.substring(rowVal.indexOf("<SubscriptionFlag>")+"</SubscriptionFlag>".length()-1,rowVal.indexOf("</SubscriptionFlag>")):"";
							
							//WriteLog(SubscriptionFlag + "As fetch from row ");
		
							if(SubscriptionFlag.equalsIgnoreCase("Y"))
							{
								SubscriptionFlag = "N";
								sFlag="1";
							}
						}	
						//WriteLog("\nsFlag-----"+sFlag);
				
				
					if(sFlag=="1")
					{
						SubscriptionFlag = "Y";
						break;
					}
					//WriteLog(sFlag + "sFlag");
					//WriteLog("countwhilchk : " + countwhilchk);
					//WriteLog(SubscriptionFlag + "SubscriptionFlag");
					CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
					
					countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								//WriteLog("In Check Subscription");
								break;
							}
			
					}
					
				
					
					
					//WriteLog("\nafter while mailPrefFlag "+mailPrefFlag);
					countwhilchk = 0;
					while(CustomerDetails.contains("<EmpDet>"))
					{
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<EmpDet>"),CustomerDetails.indexOf("</EmpDet>")+"</EmpDet>".length());					
						EmploymentType =  (rowVal.contains("<EmploymentType>")) ? rowVal.substring(rowVal.indexOf("<EmploymentType>")+"</EmploymentType>".length()-1,rowVal.indexOf("</EmploymentType>")):"";
						Desig = (rowVal.contains("<Desig>")) ? rowVal.substring(rowVal.indexOf("<Desig>")+"</Desig>".length()-1,rowVal.indexOf("</Desig>")) : "" ;
						EmployerName = (rowVal.contains("<EmployerName>")) ? rowVal.substring(rowVal.indexOf("<EmployerName>")+"</EmployerName>".length()-1,rowVal.indexOf("</EmployerName>")) : "" ;
						EmployerName = EmployerName.replaceAll("&amp;","");
						
						DepartmentName = (rowVal.contains("<DepartmentName>")) ? rowVal.substring(rowVal.indexOf("<DepartmentName>")+"</DepartmentName>".length()-1,rowVal.indexOf("</DepartmentName>")) : "" ;
						EmployeeNumber = (rowVal.contains("<EmployeeNumber>")) ? rowVal.substring(rowVal.indexOf("<EmployeeNumber>")+"</EmployeeNumber>".length()-1,rowVal.indexOf("</EmployeeNumber>")) : "" ;					
						//WriteLog("\nEmployeeNumber--->"+EmployeeNumber);
						Occupation = (rowVal.contains("<Occupation>")) ? rowVal.substring(rowVal.indexOf("<Occupation>")+"</Occupation>".length()-1,rowVal.indexOf("</Occupation>")) : "" ;
						EmployeeStatus = (rowVal.contains("<EmployeeStatus>")) ? rowVal.substring(rowVal.indexOf("<EmployeeStatus>")+"</EmployeeStatus>".length()-1,rowVal.indexOf("</EmployeeStatus>")) : "" ;					
						
						
						String query = "select empstatustypedisplay from usr_0_cu_EmployementStatus with (nolock) where empstatuscode=:empstatuscode";
						
						params = "empstatuscode=="+EmployeeStatus;
						
						String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
						
						//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
						
						//WriteLog( "\nInputXML empstatustypedisplay-->"+inputXML);
						String outputXML = WFCustomCallBroker.execute(inputXML, sJtsIp, iJtsPort, 1);
						//WriteLog( "\noutputXML empstatustypedisplay-->"+outputXML);
						
						WFCustomXmlResponse xmlParserData=new WFCustomXmlResponse();
						xmlParserData.setXmlString((outputXML));
						String mainCodeValue = xmlParserData.getVal("MainCode");
						String subXML="";
						WFCustomXmlResponse objXmlParser3=null;
						
						if(mainCodeValue.equals("0"))
						{
							EmployeeStatus=xmlParserData.getVal("empstatustypedisplay");
							//WriteLog( "\nempstatustypedisplay--->"+EmployeeStatus);	
						}
							
						try{
							DOJ = rowVal.substring(rowVal.indexOf("<DOJ>")+"</DOJ>".length()-1,rowVal.indexOf("</DOJ>"));
							DOJ = DOJ.substring(8,10)+"/"+DOJ.substring(5,7)+"/"+DOJ.substring(0,4);
						}catch(Exception ex){
							DOJ="";
						}
						//CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());
						
						countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
					}
					//Added by Shamily to fetch OECD Details Fields value
					try{
						countwhilchk = 0;
						while(CustomerDetails.contains("<OECDDet>"))
						{
							rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<OECDDet>"),CustomerDetails.indexOf("</OECDDet>")+"</OECDDet>".length());
							
							
							CityOfBirth =  (rowVal.contains("<CityOfBirth>")) ? rowVal.substring(rowVal.indexOf("<CityOfBirth>")+"</CityOfBirth>".length()-1,rowVal.indexOf("</CityOfBirth>")):"";
							CountryOfBirth = (rowVal.contains("<CountryOfBirth>")) ? rowVal.substring(rowVal.indexOf("<CountryOfBirth>")+"</CountryOfBirth>".length()-1,rowVal.indexOf("</CountryOfBirth>")) : "" ;
							
							String queryCountry = "select countryName from USR_0_CU_CountryMaster with (nolock) where countrycode=:countrycode";
							
							params = "countrycode=="+CountryOfBirth;
							
							String inputXMLCountry = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryCountry + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							//String inputXMLCountry = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + queryCountry + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							// WriteLog("\nInputXML CUSTOMER_DETAILS 123567-->"+inputXMLCountry);
							String outputXMLCountry = WFCustomCallBroker.execute(inputXMLCountry, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS exceptions-->"+outputXMLCountry);
							
							WFCustomXmlResponse xmlParserData1=new WFCustomXmlResponse();
							xmlParserData1.setXmlString((outputXMLCountry));
							String mainCodeValueCountry = xmlParserData1.getVal("MainCode");
							
							WFCustomXmlResponse objXmlParser1=null;
							
							if(mainCodeValueCountry.equals("0"))
							{
								CountryOfBirth = xmlParserData1.getVal("countryName");
								//WriteLog("\ncountryName CUSTOMER_DETAILS"+CountryOfBirth);	
							}
							
							CRSUnDocFlg = (rowVal.contains("<CRSUnDocFlg>")) ? rowVal.substring(rowVal.indexOf("<CRSUnDocFlg>")+"</CRSUnDocFlg>".length()-1,rowVal.indexOf("</CRSUnDocFlg>")) : "" ;
							CRSUndocFlgReason = (rowVal.contains("<CRSUndocFlgReason>")) ? rowVal.substring(rowVal.indexOf("<CRSUndocFlgReason>")+"</CRSUndocFlgReason>".length()-1,rowVal.indexOf("</CRSUndocFlgReason>")) : "" ;
							String temp="";
			
							String rowVal1= "";
							while(CustomerDetails.contains("<ReporCntryDet>"))
							{    
								rowVal1 = CustomerDetails.substring(CustomerDetails.indexOf("<ReporCntryDet>"),CustomerDetails.indexOf("</ReporCntryDet>")+"</ReporCntryDet>".length());
							
				
								CntryOfTaxRes =(rowVal1.contains("<CntryOfTaxRes>")) ? rowVal1.substring(rowVal1.indexOf("<CntryOfTaxRes>")+"<CntryOfTaxRes>".length(),rowVal1.indexOf("</CntryOfTaxRes>")):"";
								//WriteLog("CntryOfTaxRes--"+CntryOfTaxRes);
								String queryCountryTax = "select countryName from USR_0_CU_CountryMaster with (nolock) where countrycode=:countrycode";
							
								params = "countrycode=="+CntryOfTaxRes;
								String inputXMLCountryTax = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + queryCountryTax + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							//String inputXMLCountryTax = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + queryCountryTax + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							// WriteLog("\nInputXML CUSTOMER_DETAILS 123567-->"+inputXMLCountryTax);
							String outputXMLCountryTax = WFCustomCallBroker.execute(inputXMLCountry, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS exceptions-->"+outputXMLCountryTax);
							
							WFCustomXmlResponse xmlParserData2=new WFCustomXmlResponse();
							xmlParserData2.setXmlString((outputXMLCountry));
							String mainCodeValueCountryTax = xmlParserData2.getVal("MainCode");
							
							WFCustomXmlResponse objXmlParser2=null;
							
							if(mainCodeValueCountryTax.equals("0"))
							{
								CntryOfTaxRes = xmlParserData2.getVal("countryName");
								//WriteLog("\ncountryName CUSTOMER_DETAILS"+CntryOfTaxRes);	
							}
								TINNumber = (rowVal1.contains("<TINNumber>")) ? rowVal1.substring(rowVal1.indexOf("<TINNumber>")+"<TINNumber>".length(),rowVal1.indexOf("</TINNumber>")):"";
								//WriteLog("TINNumber--"+TINNumber);
								NoTINReason =(rowVal1.contains("<NoTINReason>")) ? rowVal1.substring(rowVal1.indexOf("<NoTINReason>")+"<NoTINReason>".length(),rowVal1.indexOf("</NoTINReason>")):"";
								MiscellaniousId = (rowVal1.contains("<MiscellaneousID>")) ? rowVal1.substring(rowVal1.indexOf("<MiscellaneousID>")+"<MiscellaneousID>".length(),rowVal1.indexOf("</MiscellaneousID>")):"";
								//WriteLog("NoTINReason--"+NoTINReason);
								if(temp=="")
								temp=CntryOfTaxRes+"@$"+TINNumber+"@$"+NoTINReason+"@$"+MiscellaniousId+"@$";
								else
								temp=temp+CntryOfTaxRes+"@$"+TINNumber+"@$"+NoTINReason+"@$"+MiscellaniousId+"@$";
				
				
								CustomerDetails = CustomerDetails.replaceAll(rowVal1, "");
				
								
								
				
								}
							
							//WriteLog("temp--->"+temp);
							if(!temp.equals(""))
							 {
							 CntryOfTaxRes1 = temp.substring(0,temp.indexOf("$"));

							if(CntryOfTaxRes1.equals("@"))
							{
								CntryOfTaxRes1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes1 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes1Rep=CntryOfTaxRes1+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes1Rep)+CntryOfTaxRes1Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes1+"@$","");
							 }	
							//WriteLog("CntryOfTaxRes1-->"+CntryOfTaxRes1);
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber1 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber1.equals("@"))
							{
								TINNumber1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber1 = temp.substring(0,temp.indexOf("@$"));
								
								temp = temp.replace(TINNumber1+"@$","");
							}	
							//WriteLog("TINNumber1-->"+TINNumber1);
							
							
							//WriteLog("temp after replace TINNumber1 -->"+temp);
							 NoTINReason1 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason1.equals("@"))
							{
								NoTINReason1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason1 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason1Rep=NoTINReason1+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason1Rep)+NoTINReason1Rep.length(),temp.length());
								//temp = temp.replace(NoTINReason1+"@$","");
							}	
							MiscellaniousId1 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId1.equals("@"))
							{
								MiscellaniousId1 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId1 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId1+"@$","");
							}	
							//WriteLog("MiscellaniousId1-->"+MiscellaniousId1);
							
							
							
							//WriteLog("temp after replace MiscellaniousId1 -->"+temp);
							}
							if(!temp.equals(""))
							 {
							CntryOfTaxRes2 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes2-->"+CntryOfTaxRes2);
							if(CntryOfTaxRes2.equals("@"))
							{
								CntryOfTaxRes2 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes2 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes2Rep=CntryOfTaxRes2+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes2Rep)+CntryOfTaxRes2Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes2+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber2 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber2.equals("@"))
							{
								TINNumber2 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber2 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber2+"@$","");
							}	
							//WriteLog("TINNumber2-->"+TINNumber2);
							
							
							
							//WriteLog("temp after replace TINNumber2 -->"+temp);
							 NoTINReason2 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason2.equals("@"))
							{
								NoTINReason2 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason2 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason2rep = NoTINReason2+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason2rep)+NoTINReason2rep.length(),temp.length());
							//	temp = temp.replace(NoTINReason2+"@$","");
							}

							MiscellaniousId2 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId2.equals("@"))
							{
								MiscellaniousId2 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId2 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId2+"@$","");
							}	
							//WriteLog("MiscellaniousId1-->"+MiscellaniousId2);
							
							
							
							//WriteLog("temp after replace MiscellaniousId2 -->"+temp);							
								
							}
							if(!temp.equals(""))
							 {						
							CntryOfTaxRes3 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes3-->"+CntryOfTaxRes3);
							if(CntryOfTaxRes3.equals("@"))
							{
								CntryOfTaxRes3 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes3 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes3Rep=CntryOfTaxRes3+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes3Rep)+CntryOfTaxRes3Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes3+"@$","");
							 }
								
							//WriteLog("temp after replace -->"+temp);
							 TINNumber3 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber3.equals("@"))
							{
								TINNumber3 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber3 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber3+"@$","");
							}	
							//WriteLog("TINNumber3-->"+TINNumber3);
							
							
							//WriteLog("temp after replace TINNumber3 -->"+temp);
							 NoTINReason3 = temp.substring(0,temp.indexOf("$"));
							 if(NoTINReason3.equals("@"))
							{
								NoTINReason3 = "";
									temp = temp.substring(2,temp.length());
							}	
							 else
							 {
								NoTINReason3 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason3Rep=NoTINReason3+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason3Rep)+NoTINReason3Rep.length(),temp.length());
								//temp = temp.replace(NoTINReason3+"@$","");
							}	
							
							// WriteLog("temp after replace NoTINReason3 -->"+temp);
							 
							 MiscellaniousId3 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId3.equals("@"))
							{
								MiscellaniousId3 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId3 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId3+"@$","");
							}	
							//WriteLog("MiscellaniousId3-->"+MiscellaniousId3);
							
							
							
							//WriteLog("temp after replace MiscellaniousId3 -->"+temp);	
							}

								if(!temp.equals(""))
							 {
							 CntryOfTaxRes4 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes4-->"+CntryOfTaxRes4);
							if(CntryOfTaxRes4.equals("@"))
							{
								CntryOfTaxRes4 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes4 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes4Rep=CntryOfTaxRes4+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes4Rep)+CntryOfTaxRes4Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes4+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber4 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber4.equals("@"))
							{
								TINNumber4 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber4 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber4+"@$","");
							}	
							//WriteLog("TINNumber4-->"+TINNumber4);
							
							
							//WriteLog("temp after replace TINNumber4 -->"+temp);
							 NoTINReason4 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason4.equals("@"))
							{
								NoTINReason4 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason4 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason4Rep=NoTINReason4+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason4Rep)+NoTINReason4Rep.length(),temp.length());
								//temp = temp.replace(NoTINReason4+"@$","");
							}	
							
							//WriteLog("NoTINReason4-->"+NoTINReason4);
							
							
							//WriteLog("temp after replace NoTINReason4 -->"+temp);
							
							 MiscellaniousId4 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId4.equals("@"))
							{
								MiscellaniousId4 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId4 = temp.substring(0,temp.indexOf("@$"));
								//WriteLog("MiscellaniousId4-->"+MiscellaniousId4);
								temp = temp.replace(MiscellaniousId4+"@$","");
							}	
							//WriteLog("MiscellaniousId4-->"+MiscellaniousId4);
							
							
							
							//WriteLog("temp after replace MiscellaniousId4-->"+temp);	
							 }
							 if(!temp.equals(""))
							 {
							 CntryOfTaxRes5 = temp.substring(0,temp.indexOf("$"));
							//WriteLog("CntryOfTaxRes5-->"+CntryOfTaxRes5);
							if(CntryOfTaxRes5.equals("@"))
							{
								CntryOfTaxRes5 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								CntryOfTaxRes5 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes5Rep=CntryOfTaxRes5+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes5Rep)+CntryOfTaxRes5Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes5+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 TINNumber5 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber5.equals("@"))
							{
								TINNumber5 = "";
									temp = temp.substring(2,temp.length());
							}	
							
							else
							 {
								TINNumber5 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber5+"@$","");
							}	
							
							//WriteLog("temp after replace TINNumber5 -->"+temp);
							 NoTINReason5 = temp.substring(0,temp.indexOf("$"));
							if(NoTINReason5.equals("@"))
							{
								NoTINReason5 = "";
								temp = temp.substring(2,temp.length());
							}	
							
							else
							 {
								NoTINReason5 = temp.substring(0,temp.indexOf("@$"));
								String NoTINReason5Rep=NoTINReason5+"@$";
								temp = temp.substring(temp.indexOf(NoTINReason5Rep)+NoTINReason5Rep.length(),temp.length());
								//temp = temp.replace(TINNumber5+"@$","");
							}
							
							 MiscellaniousId5 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId5.equals("@"))
							{
								MiscellaniousId5 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId5 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId5+"@$","");
							}	
							//WriteLog("MiscellaniousId5-->"+MiscellaniousId5);
							
							
							
							//WriteLog("temp after replace MiscellaniousId5-->"+temp);	
							 }
							 if(!temp.equals(""))
							 {
							 CntryOfTaxRes6 = temp.substring(0,temp.indexOf("$"));
							
							if(CntryOfTaxRes6.equals("@"))
							{
								CntryOfTaxRes6 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							{
								CntryOfTaxRes6 = temp.substring(0,temp.indexOf("@$"));
								String CntryOfTaxRes6Rep=CntryOfTaxRes6+"@$";
								temp = temp.substring(temp.indexOf(CntryOfTaxRes6Rep)+CntryOfTaxRes6Rep.length(),temp.length());
								//temp = temp.replace(CntryOfTaxRes6+"@$","");
							}	
							
							//WriteLog("temp after replace -->"+temp);
							 
							 TINNumber6 = temp.substring(0,temp.indexOf("$"));
							if(TINNumber6.equals("@"))
							{
								TINNumber6 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								TINNumber6 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(TINNumber6+"@$","");
							}	
							//WriteLog("TINNumber6-->"+TINNumber6);
							
							
							//WriteLog("temp after replace TINNumber6 -->"+temp);
							 NoTINReason6 = temp.substring(0,temp.indexOf("$"));
							
							//WriteLog("NoTINReason6-->"+NoTINReason6);
							if(NoTINReason6.equals("@"))
							{
								NoTINReason6 = "";
									temp = temp.substring(2,temp.length());
							}	
							else
							 {
								NoTINReason6 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(NoTINReason6+"$","");
							}	
							
							
							//WriteLog("temp after replace NoTINReason6 -->"+temp);
							
								 MiscellaniousId6 = temp.substring(0,temp.indexOf("$"));
							if(MiscellaniousId6.equals("@"))
							{
								MiscellaniousId6 = "";
								temp = temp.substring(2,temp.length());
							}	
							else
							 {
								MiscellaniousId6 = temp.substring(0,temp.indexOf("@$"));
								temp = temp.replace(MiscellaniousId6+"@$","");
							}	
							//WriteLog("MiscellaniousId6-->"+MiscellaniousId6);
							
							
							
							//WriteLog("temp after replace MiscellaniousId6-->"+temp);	
							}
							CustomerDetails = CustomerDetails.replaceAll(rowVal, "");
							countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
						}
					}
					catch(Exception ex){
							WriteLog("in catch");
					}
					countwhilchk = 0;
					while(CustomerDetails.contains("<PhnDet>"))
					{
						
						rowVal = CustomerDetails.substring(CustomerDetails.indexOf("<PhnDet>"),CustomerDetails.indexOf("</PhnDet>")+"</PhnDet>".length());
						
						String PhnType = (rowVal.contains("<PhnType>")) ? rowVal.substring(rowVal.indexOf("<PhnType>")+"</PhnType>".length()-1,rowVal.indexOf("</PhnType>")):"";
						
						if(PhnType.equalsIgnoreCase("CELLPH1"))
						{
							Phone1CountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							Phone1No = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							phnPrefFlag = (rowVal.contains("<PhnPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<PhnPrefFlag>")+"</PhnPrefFlag>".length()-1,rowVal.indexOf("</PhnPrefFlag>")):"";
							if(phnPrefFlag.equalsIgnoreCase("Y"))
								phnPrefFlag="Mobile Phone";
							//WriteLog( "\nwdesk:MobilePhone_Existing~"+Phone1No);
							//WriteLog( "\nPhone1CountryCode"+Phone1CountryCode);
							//WriteLog( "\nphnPrefFlagPhone1~"+phnPrefFlag);
						}
						else if(PhnType.equalsIgnoreCase("CELLPH2"))
						{
							Phone2CountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							Phone2No = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							if(phnPrefFlag.equalsIgnoreCase("N") || phnPrefFlag.equalsIgnoreCase(""))
							phnPrefFlag = (rowVal.contains("<PhnPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<PhnPrefFlag>")+"</PhnPrefFlag>".length()-1,rowVal.indexOf("</PhnPrefFlag>")):"";
							
							if(phnPrefFlag.equalsIgnoreCase("Y"))
								phnPrefFlag="2nd Mobile Phone";
							//WriteLog( "\nwdesk:sec_mob_phone_exis~"+Phone2No);
							//WriteLog( "\nphnPrefFlagphone2~"+phnPrefFlag);
						}
						else if(PhnType.equalsIgnoreCase("HOMEPH1"))
						{
							HomePhoneCountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							HomePhoneNo =  (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog( "\nwdesk:homephone_exis~"+HomePhoneNo);
						}
						else if(PhnType.equalsIgnoreCase("OFFCPH1"))
						{
							OfficePhoneCountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							OfficePhoneNo =  (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog( "\nwdesk:office_phn_exis~"+OfficePhoneNo);
						}
						else if(PhnType.equalsIgnoreCase("OVHOMEPH"))
						{
							HomeCountryPhoneCountryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";
							HomeCountryPhoneNo = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog( "\nwdesk:homecntryphone_exis~"+HomeCountryPhoneNo);
						}
						else if(PhnType.equalsIgnoreCase("FAXO1"))
						{
							FAX = (rowVal.contains("<PhoneNo>")) ? rowVal.substring(rowVal.indexOf("<PhoneNo>")+"</PhoneNo>".length()-1,rowVal.indexOf("</PhoneNo>")):"";
							//WriteLog( "\nwdesk:fax_exis~"+FAX);
						}
						CustomerDetails = CustomerDetails.substring(0,CustomerDetails.indexOf(rowVal))+ CustomerDetails.substring(CustomerDetails.indexOf(rowVal)+rowVal.length());	

						countwhilchk++;
							if(countwhilchk == 100)
							{
							
								countwhilchk = 0;
									break;
							}
						
					}
				//	WriteLog( "\npref_email_exis----->"+mailPrefFlag);
					
					cust_result = "wdesk:title_exis~"+Title+"`"+"wdesk:FirstName_Existing~"+FirstName+"`"+"wdesk:MiddleName_Existing~"+MiddleName+"`"+"wdesk:LastName_Existing~"+LastName+"`"+"wdesk:FullName_Existing~"+FullName+"`"+"wdesk:gender_exit~"+Gender+"`"+"wdesk:mother_maiden_name_exis~"+MothersName+"`"+"wdesk:PassportNumber_Existing~"+passportNo+"`"+"wdesk:passportExpDate_exis~"+passportExp+"`"+"wdesk:emirates_id~"+emiratesId+"`"+"emirates_id~"+emiratesId+"`"+"wdesk:emiratesidexp_exis~"+emiratesIdExp+"`"+"wdesk:visa_exis~"+visa+"`"+"wdesk:visaExpDate_exis~"+visaExp+"`"+"wdesk:prim_email_exis~"+PrimaryEmail+"`"+"wdesk:sec_email_exis~"+SecondaryEmail+"`"+"wdesk:pref_email_exis~"+mailPrefFlag1+"`"+"wdesk:MobilePhone_Existing~"+Phone1No+"`"+"wdesk:sec_mob_phone_exis~"+Phone2No+"`"+"wdesk:homecntryphone_exis~"+HomeCountryPhoneNo+"`"+"wdesk:homephone_exis~"+HomePhoneNo+"`"+"wdesk:office_phn_exis~"+OfficePhoneNo+"`"+"wdesk:pref_add_exis~"+addPrefFlag+"`"+"wdesk:pref_contact_exis~"+phnPrefFlag+"`"+"wdesk:nation_exist~"+Nationality+"`"+"wdesk:marrital_status_exis~"+MaritalStatus+"`"+"wdesk:abcdelig_exis~"+AECBConsentHeld+"`"+"wdesk:emp_type_exis~"+EmploymentType+"`"+"wdesk:country_of_res_exis~"+ResidentCountryExis+"`"+"wdesk:designation_exis~"+Desig+"`"+"wdesk:emp_name_exis~"+EmployerName+"`"+"wdesk:department_exis~"+DepartmentName+"`"+"wdesk:employee_num_exis~"+EmployeeNumber+"`"+"wdesk:occupation_exist~"+Occupation+"`"+"wdesk:employment_status_exis~"+EmployeeStatus+"`"+"wdesk:date_join_curr_employer_exis~"+DOJ+"`"+"wdesk:fax_exis~"+FAX+"`"+"wdesk:usnatholder_exis~"+US_National+"`"+"wdesk:USrelation~"+USRelation+"`"+"wdesk:IndustrySegment_exis~"+IndustrySegment+"`"+"wdesk:IndustrySubSegment_exis~"+IndustrySubSegment+"`"+"wdesk:FatcaReason~"+FatcaReason+"`"+"wdesk:CustomerType_exis~"+CustomerType+"`"+"wdesk:FatcaDoc~"+DocumentsCollected+"`"+"wdesk:nonResident~"+NonResidentFlag+"`"+"wdesk:DOB_exis~"+DOB+"`"+"wdesk:total_year_of_emp_exis~"+TotEmpYrs+"`"+"wdesk:years_of_business_exis~"+BusinessDuration+"`"+"wdesk:E_Stmnt_regstrd_exis~"+SubscriptionFlag+"`"+"wdesk:MailType~"+MailType+"`"+"wdesk:Oecdcity~"+CityOfBirth+"`"+"wdesk:Oecdcountry~"+CountryOfBirth+"`"+"wdesk:OECDUndoc_Flag~"+CRSUnDocFlg+"`"+"wdesk:OECDUndocreason_exist~"+CRSUndocFlgReason+"`"+"Oecdcountrytax~"+CntryOfTaxRes1+"`"+"wdesk:OecdTin~"+TINNumber1+"`"+"wdesk:OECDtinreason_exist~"+NoTINReason1+"`"+"Phone1CountryCode~"+"`"+"Oecdcountrytax2~"+CntryOfTaxRes2+"`"+"wdesk:OecdTin2~"+TINNumber2+"`"+"wdesk:OECDtinreason_exist2~"+NoTINReason2+"`"+"Oecdcountrytax3~"+CntryOfTaxRes3+"`"+"wdesk:OecdTin3~"+TINNumber3+"`"+"wdesk:OECDtinreason_exist3~"+NoTINReason3+"`"+"Oecdcountrytax4~"+CntryOfTaxRes4+"`"+"wdesk:OecdTin4~"+TINNumber4+"`"+"wdesk:OECDtinreason_exist4~"+NoTINReason4+"`"+"Oecdcountrytax5~"+CntryOfTaxRes5+"`"+"wdesk:OecdTin5~"+TINNumber5+"`"+"wdesk:OECDtinreason_exist5~"+NoTINReason5+"`"+"Oecdcountrytax6~"+CntryOfTaxRes6+"`"+"wdesk:OecdTin6~"+TINNumber6+"`"+"wdesk:OECDtinreason_exist6~"+NoTINReason6+"`"+"wdesk:Marsoon_exis~"+MARID+"`"+"wdesk:SignedDate_exis~"+SignedDate+"`"+"wdesk:ExpiryDate_exis~"+SignedExpiryDate+"`"+"wdesk:MiscellaniousId1~"+MiscellaniousId1+"`"+"wdesk:MiscellaniousId2~"+MiscellaniousId2+"`"+"wdesk:MiscellaniousId3~"+MiscellaniousId3+"`"+"wdesk:MiscellaniousId4~"+MiscellaniousId4+"`"+"wdesk:MiscellaniousId5~"+MiscellaniousId5+"`"+"wdesk:MiscellaniousId6~"+MiscellaniousId6;
					
					//WriteLog( "\nrak elite customer: "+cust_result);
					//WriteLog( "\nNationality:"+Nationality);
					//WriteLog( "\nAECBConsentHeld:"+AECBConsentHeld);
				}
			}
			catch(Exception e){
				WriteLog( "\nException occured in get Customer data:"+e);
			}

			out.clear();
			out.println(cust_result);
			WriteLog( "\nOutput : CUSTOMER_DETAILS"+cust_result);
		}
		else if (requestType.equalsIgnoreCase("ACCOUNT_SUMMARY") && cif_type.equalsIgnoreCase("Individual"))
		{
		
			String CIF_ID = cif_id_Esapi;
			
			if(CIF_ID!=null){ CIF_ID = CIF_ID.replace("'","''");}
			WriteLog("\nACCOUNT_SUMMARY CIF_ID: "+CIF_ID);
			String username=user_name_Esapi;
			
			if(username!=null){ username = username.replace("'","''");}
			String sessionId=sSessionId,engineName=sCabName;
			String acc_list_str= "";
						
			String inputAccountSummaryXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				"<ProcessName>CU</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				"<MsgFormat>ACCOUNT_SUMMARY</MsgFormat>\n"+
				"<MsgVersion>0000</MsgVersion>\n"+
				"<RequestorChannelId>BPM</RequestorChannelId>\n"+
				"<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				"<RequestorLanguage>E</RequestorLanguage>\n"+
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				"<ReturnCode>911</ReturnCode>\n"+
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				"<MessageId>143282709427399867</MessageId>\n"+
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n"+
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n"+
				"</EE_EAI_HEADER>\n"+
				"<FetchAccountListReq><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><FetchClosedAcct>Y</FetchClosedAcct><AccountIndicator>O</AccountIndicator></FetchAccountListReq>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
			
			WriteLog("\nACCOUNT_SUMMARY InputXML: "+inputAccountSummaryXML);
			int row =0;
			String col_name = ""; 
			String val_main = "";
					
			sMappOutPutXML = "";
			
			sMappOutPutXML= WFCustomCallBroker.execute(inputAccountSummaryXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"CUTesting"+File.separator+"Account_Summary.txt");
			 
			WriteLog("\nACCOUNT_SUMMARY OutputXML: "+sMappOutPutXML);
			out.println(sMappOutPutXML);
			/*
			String FetchFINAccountListRes ="";
			if(sMappOutPutXML.contains("<FetchFINAccountListRes>")){
				FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"),sMappOutPutXML.indexOf("</FetchFINAccountListRes>")+"</FetchFINAccountListRes>".length());
			}
			
			String rowVal ="";
			String account_num="",account_type="",product_id="",modeofoperation="",account_name="";
			String signatureUpdate="";
			row=0;
			countwhilchk = 0;
			while(FetchFINAccountListRes.contains("<FINAccountDetail>"))
			{
				row++;
				account_num="";account_type="";product_id="";modeofoperation="";account_name="";
				rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"),FetchFINAccountListRes.indexOf("</FINAccountDetail>")+"</FINAccountDetail>".length());
				if(rowVal.contains("<Acid>")) {
				account_num = rowVal.substring(rowVal.indexOf("<Acid>")+"</Acid>".length()-1,rowVal.indexOf("</Acid>"));
				acc_list_str = rowVal.substring(rowVal.indexOf("<Acid>")+"</Acid>".length()-1,rowVal.indexOf("</Acid>"))+"@"+acc_list_str;
				}
				if(rowVal.contains("<AcctType>"))
					account_type = rowVal.substring(rowVal.indexOf("<AcctType>")+"</AcctType>".length()-1,rowVal.indexOf("</AcctType>"));
				if(rowVal.contains("<ProductId>"))
					product_id = rowVal.substring(rowVal.indexOf("<ProductId>")+"</ProductId>".length()-1,rowVal.indexOf("</ProductId>"));
				if(rowVal.contains("<ModeOfOperation>"))
					modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>")+"</ModeOfOperation>".length()-1,rowVal.indexOf("</ModeOfOperation>"));
				if(rowVal.contains("<AccountName>"))
					account_name = rowVal.substring(rowVal.indexOf("<AccountName>")+"</AccountName>".length()-1,rowVal.indexOf("</AccountName>"));
				
				String nameCheckbox="row"+row+"_signatureupdate";
				String checkbox_name = "checkbox_signatureupdate";
				String button_name = " button_signatureupdate";
				String fetch = "Fetch Signature";
				
				String tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)' name="+"'"+checkbox_name+"'"+" value="+"'"+nameCheckbox+"'"+" id="+"'"+nameCheckbox+"'"+"></td>";
				
				String tempButtonBox = "<td><input type='button' name="+"'"+button_name+"'"+" value="+"'"+fetch+"'"+" id="+"'"+nameCheckbox+"'"+"></td>";
				
				signatureUpdate = signatureUpdate +"<tr class='EWNormalGreenGeneral1'>"+tempcheckBox+"<td id='accountNum_"+nameCheckbox+"'>"+account_num+"</td><td>"+account_type+"</td><td>"+modeofoperation+"</td>"+tempButtonBox+"</tr>";
				
				System.out.println(account_num);
				System.out.println(account_type);
				System.out.println(product_id);
				System.out.println(modeofoperation);
				System.out.println(account_name+"\n"+"----------------------------------------------------");
			
				 
				val_main = val_main + nameCheckbox+"#"+account_num+"#"+account_type+"#"+modeofoperation+"~";
				
				//FetchFINAccountListRes = FetchFINAccountListRes.replaceAll(rowVal, "");
				FetchFINAccountListRes = FetchFINAccountListRes.substring(0,FetchFINAccountListRes.indexOf(rowVal))+ FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf(rowVal)+rowVal.length());
				countwhilchk++;
				if(countwhilchk == 100)
				{
					
					countwhilchk = 0;
					break;
				}
			}
				
			val_main = val_main + "$$";				
				
			String appendStr = "<table id='signatureupdate' border=1 width='100%' ><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Account Number</th><th>Name</th><th>Mode of Operation</th><th>Fetch Signature</th></tr>";
			
			System.out.println(appendStr+signatureUpdate+"</table>");
			String outputXml ="";
			outputXml = appendStr+signatureUpdate+"</table>";
			
			
			// Dormancy Activation 			
			String dormancyActivation="";
			if(sMappOutPutXML.contains("<FetchFINAccountListRes>")){
				FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"),sMappOutPutXML.indexOf("</FetchFINAccountListRes>")+"</FetchFINAccountListRes>".length());
			}
			row = 0;
			if(FetchFINAccountListRes.contains("<DormantSince>"))
			{
				countwhilchk = 0;
				while(FetchFINAccountListRes.contains("<FINAccountDetail>"))
				{
					row++;
					String DormantSince="";
					
					account_num="";account_type="";product_id="";modeofoperation="";account_name="";
					rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"),FetchFINAccountListRes.indexOf("</FINAccountDetail>")+"</FINAccountDetail>".length());
					
					if(rowVal.contains("<DormantSince>"))
					{
						if(rowVal.contains("<Acid>"))
							account_num = rowVal.substring(rowVal.indexOf("<Acid>")+"</Acid>".length()-1,rowVal.indexOf("</Acid>"));
						if(rowVal.contains("<AcctType>"))
							account_type = rowVal.substring(rowVal.indexOf("<AcctType>")+"</AcctType>".length()-1,rowVal.indexOf("</AcctType>"));
						if(rowVal.contains("<ProductId>"))
							product_id = rowVal.substring(rowVal.indexOf("<ProductId>")+"</ProductId>".length()-1,rowVal.indexOf("</ProductId>"));
						if(rowVal.contains("<ModeOfOperation>"))
							modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>")+"</ModeOfOperation>".length()-1,rowVal.indexOf("</ModeOfOperation>"));
						if(rowVal.contains("<DormantSince>"))
							DormantSince = rowVal.substring(rowVal.indexOf("<DormantSince>")+"</DormantSince>".length()-1,rowVal.indexOf("</DormantSince>"));
						
						String nameCheckbox="row"+row+"_dormancyactivation";
						String checkbox_name = "checkbox_dormancyactivation";
						String tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)'  name="+"'"+checkbox_name+"'"+" value="+"'"+nameCheckbox+"'"+" id="+"'"+nameCheckbox+"'"+"></td>";
						dormancyActivation = dormancyActivation +"<tr class='EWNormalGreenGeneral1'>"+tempcheckBox+"<td>"+account_num+"</td><td>"+account_type+"</td><td>"+modeofoperation+"</td><td>"+DormantSince+"</td></tr>";
						System.out.println("-----dormancyActivation-----"+dormancyActivation);
						val_main = val_main + nameCheckbox+"#"+account_num+"#"+account_type+"#"+modeofoperation+"~";
					
					}
					
					//FetchFINAccountListRes = FetchFINAccountListRes.replaceAll(rowVal, "");
					FetchFINAccountListRes = FetchFINAccountListRes.substring(0,FetchFINAccountListRes.indexOf(rowVal))+ FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf(rowVal)+rowVal.length());
					countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
				}
				
				val_main = val_main + "$$";
				
				appendStr = "<table id='dormancyactivation' border=1 width='100%'><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Mode of Operation</th><th>Name</th><th>Mode of Operation</th><th>Dormant Since</th></tr>";
				System.out.println(appendStr+dormancyActivation+"</table>");
				
				outputXml = outputXml +"~"+ appendStr+dormancyActivation+"</table>";
			}
					
			// Joint to Sole
			String jointtosole="";
			if(sMappOutPutXML.contains("<FetchFINAccountListRes>")){
				FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"),sMappOutPutXML.indexOf("</FetchFINAccountListRes>")+"</FetchFINAccountListRes>".length());
			}
			
			row=0;
			if(FetchFINAccountListRes.contains("<ModeOfOperation>"))
			{
				countwhilchk = 0;
				while(FetchFINAccountListRes.contains("<FINAccountDetail>"))
				{
					
					String DormantSince="";
					
					account_num="";account_type="";product_id="";modeofoperation="";account_name="";
					rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"),FetchFINAccountListRes.indexOf("</FINAccountDetail>")+"</FINAccountDetail>".length());
					String valmodeOfOperation ="";
					if(rowVal.contains("<ModeOfOperation>"))
					{
						modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>")+"</ModeOfOperation>".length()-1,rowVal.indexOf("</ModeOfOperation>"));
						
						if(modeofoperation.equalsIgnoreCase("JOINT"))
						{
								
							row++;	
							if(rowVal.contains("<Acid>"))
								account_num = rowVal.substring(rowVal.indexOf("<Acid>")+"</Acid>".length()-1,rowVal.indexOf("</Acid>"));
							if(rowVal.contains("<AcctType>"))
								account_type = rowVal.substring(rowVal.indexOf("<AcctType>")+"</AcctType>".length()-1,rowVal.indexOf("</AcctType>"));
							if(rowVal.contains("<ProductId>"))
								product_id = rowVal.substring(rowVal.indexOf("<ProductId>")+"</ProductId>".length()-1,rowVal.indexOf("</ProductId>"));
							
							
							String nameCheckbox="row"+row+"_jointtosole";
							String checkbox_name = "checkbox_jointtosole";
							String tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)' name="+"'"+checkbox_name+"'"+" value="+"'"+nameCheckbox+"'"+" id="+"'"+nameCheckbox+"'"+"></td>";
							jointtosole = jointtosole +"<tr class='EWNormalGreenGeneral1'>"+tempcheckBox+"<td>"+account_num+"</td><td>"+account_type+"</td><td>"+modeofoperation+"</td></tr>";
							System.out.println("-----jointtosole-----"+jointtosole);
							val_main = val_main + nameCheckbox+"#"+account_num+"#"+account_type+"#"+modeofoperation+"~";
						}
					}
					
					//FetchFINAccountListRes = FetchFINAccountListRes.replaceAll(rowVal, "");
					FetchFINAccountListRes = FetchFINAccountListRes.substring(0,FetchFINAccountListRes.indexOf(rowVal))+ FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf(rowVal)+rowVal.length());
					countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
				}
			
				val_main = val_main + "$$";
				
				appendStr = "<table id='jointtosole' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th>Select</th><th>CIF Number</th><th>Name</th><th>Mode of Operation</th></tr>";
				System.out.println(appendStr+jointtosole+"</table>");
				
				outputXml = outputXml +"~"+ appendStr+jointtosole+"</table>";
			}
			
			// Sole to joint		
			String soletojoint="";
			if(sMappOutPutXML.contains("<FetchFINAccountListRes>")){
				FetchFINAccountListRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchFINAccountListRes>"),sMappOutPutXML.indexOf("</FetchFINAccountListRes>")+"</FetchFINAccountListRes>".length());
			}
			
			row=0;
			if(FetchFINAccountListRes.contains("<ModeOfOperation>"))
			{
				countwhilchk = 0;
				while(FetchFINAccountListRes.contains("<FINAccountDetail>"))
				{	
					
					String DormantSince="";
					
					account_num="";account_type="";product_id="";modeofoperation="";account_name="";
					rowVal = FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf("<FINAccountDetail>"),FetchFINAccountListRes.indexOf("</FINAccountDetail>")+"</FINAccountDetail>".length());
					String valmodeOfOperation ="";
					if(rowVal.contains("<ModeOfOperation>"))
					{
						modeofoperation = rowVal.substring(rowVal.indexOf("<ModeOfOperation>")+"</ModeOfOperation>".length()-1,rowVal.indexOf("</ModeOfOperation>"));
						
						if(modeofoperation.equalsIgnoreCase("SINGLY"))
						{
								
							row++;	
							if(rowVal.contains("<Acid>"))
								account_num = rowVal.substring(rowVal.indexOf("<Acid>")+"</Acid>".length()-1,rowVal.indexOf("</Acid>"));
							if(rowVal.contains("<AcctType>"))
								account_type = rowVal.substring(rowVal.indexOf("<AcctType>")+"</AcctType>".length()-1,rowVal.indexOf("</AcctType>"));
							if(rowVal.contains("<ProductId>"))
								product_id = rowVal.substring(rowVal.indexOf("<ProductId>")+"</ProductId>".length()-1,rowVal.indexOf("</ProductId>"));
							
							String nameCheckbox="row"+row+"_soletojoint";
							String checkbox_name = "checkbox_soletojoint";
							String tempcheckBox = "<td><input type='checkbox' onclick='getCheckboxDetails(this)' name="+"'"+checkbox_name+"'"+" value="+"'"+nameCheckbox+"'"+" id="+"'"+nameCheckbox+"'"+"></td>";
							soletojoint = soletojoint +"<tr class='EWNormalGreenGeneral1'>"+tempcheckBox+"<td>"+account_num+"</td><td>"+account_type+"</td><td>"+modeofoperation+"</td></tr>";
							System.out.println("-----soletojoint-----"+soletojoint);
							val_main = val_main + nameCheckbox+"#"+account_num+"#"+account_type+"#"+modeofoperation+"~";
						}
					}
					
					//FetchFINAccountListRes = FetchFINAccountListRes.replaceAll(rowVal, "");
					FetchFINAccountListRes = FetchFINAccountListRes.substring(0,FetchFINAccountListRes.indexOf(rowVal))+ FetchFINAccountListRes.substring(FetchFINAccountListRes.indexOf(rowVal)+rowVal.length());
					countwhilchk++;
							if(countwhilchk == 100)
							{
								
								countwhilchk = 0;
								break;
							}
				}
			
				val_main = val_main + "$$";
				
				appendStr = "<table id='soletojoint' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th>Select</th><th>CIF Number</th><th>Name</th><th>Mode of Operation</th></tr>";
				System.out.println(appendStr+soletojoint+"</table>");
				
				outputXml = outputXml +"~"+ appendStr+soletojoint+"</table>";
			}
			
			//WriteLog( "\nOutput : val_main"+val_main + " acc_list_str: "+acc_list_str);
			out.clear();
			out.println(outputXml+"^^^"+val_main+":;:"+acc_list_str);
			WriteLog( "\nOutput : ACCOUNT_SUMMARY"+outputXml+"^^^"+val_main+":;:"+acc_list_str);
			*/
		}
	}
	catch(Exception e){
		e.printStackTrace();
		sMappOutPutXML="Exception"+e;
		WriteLog( "\nin catch");
		WriteLog( sMappOutPutXML);
	}
%>