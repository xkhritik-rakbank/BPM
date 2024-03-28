<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TWC_Specific/Log.process"%>
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
	String outputXMLLog="";
	try
	{
		logger.info("\nInside TWC Integration.jsp\n");
			
		String requestType = request.getParameter("request_type");
		if (requestType != null) {requestType=requestType.replace("'","");}
		String wi_name = request.getParameter("wi_name");
		if (wi_name != null) {wi_name=wi_name.replace("'","");}
		String cif_type = request.getParameter("cif_type");
		if (cif_type != null) {cif_type=cif_type.replace("'","");}
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String username= customSession.getUserName();
		String SubscriptionFlag="N";
		String subval = "";
		String sFlag = "";
		String ResAddress1 = "";
		String OffcAddress1 = "";
		String ResPobox = "";
		String OffcPobox = "";
		String AddressType = "";
		String Res_FlatNo="";
		String Res_BuildingName="";
		String Res_Street="";
		String Res_Landmark="";
		String Res_ResType="";
		String Res_POBox="";
		String Res_City="";
		String Res_countryName="";
		String Res_FlatNo1="";
		String Res_BuildingName1="";
		String Res_Street1="";
		String Res_Landmark1="";
		String Res_ResType1="";
		String Res_POBox1="";
		String Res_City1="";
		String FirstName="";
		String LastName="";
		String CustomerName="";
		String PrefAddress ="";
		String OfficeAddress ="";
		String Res_countryName1 ="";
		
		String OfficeFlatNo ="";
		String OfficeBuildingName ="";
		String OfficeStreet ="";
		String OfficeLandmark ="";
		String OfficePOBox ="";
		String OfficeCity  ="";
		String OfficeCountryName  ="";
		
		//Added on 22/02/2019 to get value of fields
		String strpreferredPh="";
		String strPhonenumber="";
		String strPhonenumber2="";
		String OfficePhoneDet="";
		String HomePhone="";
		String FaxDet="";
		String ResidencePhone="";
		String strprefemail1="";
		String strEmail1="";
		String strEmail2="";
		String MobileNumber="";
		String MobileCode="";
		String Res_LandlineNumber="";
		String Res_LandlineCode="";
		String Office_LandlineNumber="";
		String Office_LandlineCode="";
		String EmailID="";
		
		logger.info("\nInside TWC Integration.jsp ,request Type - "+requestType+" for wi_name "+wi_name);
		
		if (requestType.equals("ENTITY_DETAILS"))
		{
			int	 row = 1;
			String valRadio="row"+row+"_individual";	
			String val_main = "";		
			String CIF_ID = request.getParameter("CIF_ID");
			if (CIF_ID != null) {CIF_ID=CIF_ID.replace("'","");}
			logger.info("CIF Id in jsp is "+CIF_ID);
			String sessionId=sSessionId,engineName=sCabName;
			String ReturnCode = "";
			String params = "";
			
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				//"<ProcessName>TWC</ProcessName>\n" +
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
				"<CustomerDetails><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><ACCType></ACCType><ACCNumber></ACCNumber><EmiratesID></EmiratesID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			    "</BPM_APMQPutGetMessage_Input>";
			String inputXMLLog = maskXmlTags(inputEntityDetailsXML,"<ACCNumber>"); // masking DateOfBirth in log	
			inputXMLLog = maskXmlTags(inputXMLLog,"<EmiratesID>"); // masking DocumentRefNumber in log
			logger.info("\ninputEntityDetailsXML"+inputXMLLog);
			
			//UnComment on Onshore to Execute Integration Call
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			
		    outputXMLLog = maskXmlTags(sMappOutPutXML,"<ACCNumber>"); // masking ACCNumber in log
			outputXMLLog = outputXMLLog.replace("("," ").replace(")"," ").replace("@"," ").replace("+"," ").replace("&amp;/"," ").replace("&amp; /"," ").replace("."," ").replace(","," ");	
		    outputXMLLog = maskXmlTags(outputXMLLog,"<AccountName>"); // masking AccountName in log	
		    outputXMLLog = maskXmlTags(outputXMLLog,"<ECRNumber>"); // masking ECRNumber in log	
			outputXMLLog = maskXmlTags(outputXMLLog,"<DOB>"); // masking DOB in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MothersName>"); // masking MothersName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<IBANNumber>"); // masking IBANNumber in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<DocId>"); // masking DocId in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<DocExpDt>"); // masking DocExpDt in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<DocIssDate>"); // masking DocIssDate in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PassportNum>"); // masking PassportNum in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MotherMaidenName>"); // masking MotherMaidenName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<LinkedDebitCardNumber>"); // masking LinkedDebitCardNumber in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<FirstName>"); // masking FirstName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<MiddleName>"); // masking MiddleName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<LastName>"); // masking LastName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<FullName>"); // masking FullName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<ARMCode>"); // masking ARMCode in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<ARMName>"); // masking ARMName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PhnCountryCode>"); // masking PhnCountryCode in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PhnLocalCode>"); // masking PhnLocalCode in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PhoneNo>"); // masking PhoneNo in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<EmailID>"); // masking EmailID in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<CustomerName>"); // masking CustomerName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<CustomerMobileNumber>"); // masking CustomerMobileNumber in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PrimaryEmailId>"); // masking PrimaryEmailId in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<Fax>"); // masking Fax in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddressType>"); // masking AddressType in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddrLine1>"); // masking AddrLine1 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddrLine2>"); // masking AddrLine2 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddrLine3>"); // masking AddrLine3 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddrLine4>"); // masking AddrLine4 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<POBox>"); // masking POBox in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<City>"); // masking City in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<Country>"); // masking Country in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddressLine1>"); // masking AddressLine1 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddressLine2>"); // masking AddressLine2 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddressLine3>"); // masking AddressLine3 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<AddressLine4>"); // masking AddressLine4 in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<CityCode>"); // masking CityCode in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<State>"); // masking State in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<CountryCode>"); // masking CountryCode in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<Nationality>"); // masking Nationality in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<ResidentCountry>"); // masking ResidentCountry in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PrimaryContactName>"); // masking PrimaryContactName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<PrimaryContactNum>"); // masking PrimaryContactNum in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<SecondaryContactName>"); // masking SecondaryContactName in log
			outputXMLLog = maskXmlTags(outputXMLLog,"<SecondaryContactNum>"); // masking SecondaryContactNum in log
			
			logger.info("\nOutputEntityDetailsXML:\n"+outputXMLLog);	
			
			/*Comment hardcoded value of OutputEntityDetailsXML on Onshore
			String tempDir = System.getProperty("user.dir");
			sMappOutPutXML = readFileFromServer(tempDir+File.separator+"TWCTesting"+File.separator+"Entity_Details.txt");
			logger.info("\nOutputEntityDetailsXML:\n"+sMappOutPutXML);*/
			
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";

			try
			{	
				String rowVal="";
				String strEmiratesID="";
				int countwhilchk;
				String strTDLICNum="";
				
				//Block for populating Customer Name
				if(sMappOutPutXML.contains("<FirstName>"))
				{
					FirstName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FirstName>")+"<FirstName>".length(),sMappOutPutXML.indexOf("</FirstName>"));
				}
			 
				if(sMappOutPutXML.contains("<LastName>"))
				{
					LastName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<LastName>")+"<LastName>".length(),sMappOutPutXML.indexOf("</LastName>"));
				}
				
				CustomerName = FirstName+" "+LastName;
				
				if (CustomerName.trim().equalsIgnoreCase("") && sMappOutPutXML.contains("<FullName>"))
					CustomerName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FullName>")+"<FullName>".length(),sMappOutPutXML.indexOf("</FullName>"));
			 
				//Block for populating Address Details Start
			 
				countwhilchk = 0;
				while(sMappOutPutXML.contains("<AddrDet>"))
				{
					rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<AddrDet>"),sMappOutPutXML.indexOf("</AddrDet>")+"</AddrDet>".length());
					
					String prefAddress = (rowVal.contains("<AddrPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<AddrPrefFlag>")+"</AddrPrefFlag>".length()-1,rowVal.indexOf("</AddrPrefFlag>")):"";
					logger.info("\nAddrPrefFlag from customer details--->"+prefAddress);	
					
					if(prefAddress.equalsIgnoreCase("Y"))
					{
						Res_FlatNo = (rowVal.contains("<AddrLine1>")) ? rowVal.substring(rowVal.indexOf("<AddrLine1>")+"</AddrLine1>".length()-1,rowVal.indexOf("</AddrLine1>")) : "";
						Res_FlatNo = Res_FlatNo.replaceAll("\\,","");
						Res_BuildingName = (rowVal.contains("<AddrLine2>")) ? rowVal.substring(rowVal.indexOf("<AddrLine2>")+"</AddrLine2>".length()-1,rowVal.indexOf("</AddrLine2>")) : "";
						Res_BuildingName = Res_BuildingName.replaceAll("\\,","");
						Res_Street = (rowVal.contains("<AddrLine3>")) ? rowVal.substring(rowVal.indexOf("<AddrLine3>")+"</AddrLine3>".length()-1,rowVal.indexOf("</AddrLine3>")) : "";
						//logger.info("\nAddress3 Office"+Res_Street);
						Res_Street = Res_Street.replaceAll("\\,","");
						
						Res_Landmark= (rowVal.contains("<AddrLine4>")) ? rowVal.substring(rowVal.indexOf("<AddrLine4>")+"</AddrLine4>".length()-1,rowVal.indexOf("</AddrLine4>")) : "";
						Res_Landmark = Res_Landmark.replaceAll("\\,","");
						
						Res_POBox= (rowVal.contains("<POBox>")) ? rowVal.substring(rowVal.indexOf("<POBox>")+"</POBox>".length()-1,rowVal.indexOf("</POBox>")) : "";
						Res_POBox = Res_POBox.replaceAll("\\,","");
						
						Res_City= (rowVal.contains("<City>")) ? rowVal.substring(rowVal.indexOf("<City>")+"</City>".length()-1,rowVal.indexOf("</City>")) : "";
						Res_City = Res_City.replaceAll("\\,","");
						
						Res_countryName= (rowVal.contains("<Country>")) ? rowVal.substring(rowVal.indexOf("<Country>")+"</Country>".length()-1,rowVal.indexOf("</Country>")) : "";
						Res_countryName = Res_countryName.replaceAll("\\,","");
						logger.info("\nResidence address countryCode --->"+Res_countryName);
						if (!Res_countryName.equalsIgnoreCase("") && Res_countryName != null && Res_countryName != "")
						{
							String query = "select countryName from USR_0_RAO_CountryMaster with (nolock) where countrycode=:countrycode";
							params = "countrycode=="+Res_countryName;
							String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							 //logger.info("\n InputXML Residence address countryName-->"+inputXML);
							String outputXML = WFCustomCallBroker.execute(inputXML, sJtsIp, iJtsPort, 1);
							// logger.info("\noutputXML Residence address countryName-->"+outputXML);
							
							WFCustomXmlResponse xmlParserData=new WFCustomXmlResponse();
							xmlParserData.setXmlString((outputXML));
							String mainCodeValue = xmlParserData.getVal("MainCode");
							String subXML="";
							WFCustomXmlResponse objXmlParser=null;
							
							if(mainCodeValue.equals("0"))
							{
								Res_countryName = xmlParserData.getVal("countryName");
								logger.info("\nResidence address countryName --->"+Res_countryName);	
								
							}
						}
						logger.info("\nResidence address CityCode--->"+Res_City);
						if (!Res_City.equalsIgnoreCase("") && Res_City != null && Res_City != "")
						{
							String query1 = "select cityName from USR_0_RAO_CityMaster with (nolock) where cityCode=:cityCode";
							params = "cityCode=="+Res_City;
							String inputXML1 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							 //logger.info("\n InputXML Residence address CityName-->"+inputXML1);
							String outputXML1 = WFCustomCallBroker.execute(inputXML1, sJtsIp, iJtsPort, 1);
							 //logger.info("\noutputXML Residence address CityName-->"+outputXML1);
							
							WFCustomXmlResponse xmlParserData1=new WFCustomXmlResponse();
							xmlParserData1.setXmlString((outputXML1));
							String mainCodeValue1 = xmlParserData1.getVal("MainCode");
							
							WFCustomXmlResponse objXmlParser1=null;
							
							if(mainCodeValue1.equals("0"))
							{
								Res_City = xmlParserData1.getVal("cityName");
								logger.info("\nResidence address CityName--->"+Res_City);	
							}
						}
						
						String PrefAdd = (rowVal.contains("<AddrPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<AddrPrefFlag>")+"</AddrPrefFlag>".length()-1,rowVal.indexOf("</AddrPrefFlag>")) : "";
						if (PrefAdd.equalsIgnoreCase("Y"))
							PrefAddress = "Residence";
							
						countwhilchk = 0;
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

				
				//Block for populating Mobile Number and Phone Number
				//Added on 22/02/2019 
				
				countwhilchk = 0;
				while(sMappOutPutXML.contains("<PhnDet>"))
				{
					rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<PhnDet>"),sMappOutPutXML.indexOf("</PhnDet>")+"</PhnDet>".length());
				
					String PhnType = (rowVal.contains("<PhnType>")) ? rowVal.substring(rowVal.indexOf("<PhnType>")+"</PhnType>".length()-1,rowVal.indexOf("</PhnType>")):"";
					
					logger.info("\nPhnType--->"+PhnType);	
				
					if(PhnType.equalsIgnoreCase("CELLPH1"))
					{
						String strPhnCntryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";				
						String strPhnLocalCode = (rowVal.contains("<PhnLocalCode>")) ? rowVal.substring(rowVal.indexOf("<PhnLocalCode>")+"</PhnLocalCode>".length()-1,rowVal.indexOf("</PhnLocalCode>")):"";	
						strPhonenumber = strPhnCntryCode +"`"+strPhnLocalCode+"`"+"End";
						//logger.info( "strPhonenumber: "+strPhonenumber);	
						
						String preferredPh = (rowVal.contains("<PhnPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<PhnPrefFlag>")+"</PhnPrefFlag>".length()-1,rowVal.indexOf("</PhnPrefFlag>")):"";				
						if(preferredPh.equalsIgnoreCase("Y"))
						{
							strpreferredPh = "Mobile Phone 1" ;
						}
						MobileCode=strPhnCntryCode;
						MobileNumber=strPhnLocalCode;
					}
					if (PhnType.equalsIgnoreCase("HOMEPH1"))
					{
						String strPhnCntryCode = (rowVal.contains("<PhnCountryCode>")) ? rowVal.substring(rowVal.indexOf("<PhnCountryCode>")+"</PhnCountryCode>".length()-1,rowVal.indexOf("</PhnCountryCode>")):"";				
						String strPhnLocalCode = (rowVal.contains("<PhnLocalCode>")) ? rowVal.substring(rowVal.indexOf("<PhnLocalCode>")+"</PhnLocalCode>".length()-1,rowVal.indexOf("</PhnLocalCode>")):"";	
						ResidencePhone = strPhnCntryCode +"`"+strPhnLocalCode+"`"+"End";
						Res_LandlineCode=strPhnCntryCode;
						//logger.info( "Res_LandlineCode: "+Res_LandlineCode);
						Res_LandlineNumber=strPhnLocalCode;
						//logger.info( "Res_LandlineNumber: "+Res_LandlineNumber);
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
				while(sMappOutPutXML.contains("<DocumentDet>"))
				{
					rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<DocumentDet>"),sMappOutPutXML.indexOf("</DocumentDet>")+"</DocumentDet>".length());
					
					String DocType = (rowVal.contains("<DocType>")) ? rowVal.substring(rowVal.indexOf("<DocType>")+"</DocType>".length()-1,rowVal.indexOf("</DocType>")):"";
					WriteLog( "\nDocType: "+DocType);
					
					if(DocType.equalsIgnoreCase("TradeLicense"))
					{
						strTDLICNum = (rowVal.contains("<DocId>")) ? rowVal.substring(rowVal.indexOf("<DocId>")+"</DocId>".length()-1,rowVal.indexOf("</DocId>")):"";
						
						/*try{
							strTDLICExpDate = rowVal.substring(rowVal.indexOf("<DocExpDt>")+"</DocExpDt>".length()-1,rowVal.indexOf("</DocExpDt>"));
							strTDLICExpDate = strTDLICExpDate.substring(8,10)+"/"+strTDLICExpDate.substring(5,7)+"/"+strTDLICExpDate.substring(0,4);
						}catch(Exception ex){
							strTDLICExpDate="";
						}*/
						countwhilchk = 0;
						break;
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
				
				// Block added for populating EmailID
				//Added on 22/02/2019
				countwhilchk = 0;
				while(sMappOutPutXML.contains("<EmailDet>"))
				{
					rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<EmailDet>"),sMappOutPutXML.indexOf("</EmailDet>")+"</EmailDet>".length());
				
					String EmlType = (rowVal.contains("<MailIdType>")) ? rowVal.substring(rowVal.indexOf("<MailIdType>")+"</MailIdType>".length()-1,rowVal.indexOf("</MailIdType>")):"";
					logger.info("\nEmlType from Customer Details--->"+EmlType);	
				
					if(EmlType.equalsIgnoreCase("ELML1"))
					{
						strEmail1 = (rowVal.contains("<EmailID>")) ? rowVal.substring(rowVal.indexOf("<EmailID>")+"</EmailID>".length()-1,rowVal.indexOf("</EmailID>")):"";				
						//logger.info( "strEmail1: "+strEmail1);

						String prefemail= (rowVal.contains("<MailPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<MailPrefFlag>")+"</MailPrefFlag>".length()-1,rowVal.indexOf("</MailPrefFlag>")):"";				
						logger.info( "prefemail 1: "+prefemail);
						if(prefemail.equalsIgnoreCase("Y"))
						{
							strprefemail1 = "eMail 1" ;
						}
						EmailID=strEmail1;
						//logger.info( "EmailID: "+EmailID);
						countwhilchk = 0;
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
				
				
				//Final Result of Integration Call
				//Modified on 22/01/2019
				String result = CustomerName+"~"+PrefAddress+"~"+Res_FlatNo+"~"+Res_BuildingName+"~"+Res_Street+"~"+Res_Landmark+"~"+Res_POBox+"~"+Res_City+"~"+Res_countryName+"~"+MobileCode+"~"+MobileNumber+"~"+Res_LandlineCode+"~"+Res_LandlineNumber+"~"+EmailID+"~"+strTDLICNum+"~End";
				//logger.info("Final Result String ----"+result);

				if (!ReturnCode.equalsIgnoreCase("0000")){
					 logger.info("\nReturnCode: "+ ReturnCode);
					out.clear();
					out.println("Exception");
				}
				else{
					out.clear();
					out.println(result);
				}
			}
		
			catch(Exception e)
			{
				e.printStackTrace();
				sMappOutPutXML="Exception"+e;
				logger.info("In Catch Block");
				logger.info(sMappOutPutXML);
			
			}
			
		}
	}
	
	catch(Exception e)
	{
		e.printStackTrace();
		sMappOutPutXML="Exception"+e;
		logger.info("In Catch Block");
		logger.info(sMappOutPutXML);
		
	}
%>