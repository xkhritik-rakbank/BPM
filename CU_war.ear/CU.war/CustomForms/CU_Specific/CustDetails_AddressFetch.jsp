<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../CU_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery-latest.js"></script>
<script language="javascript" src="/webdesktop/webtop/scripts/jquery.autocomplete.js"></script>

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
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("user_name"), 1000, true) );
			String user_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_type"), 1000, true) );
			String cif_type_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIF_ID"), 1000, true) );
			String CIF_ID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	int relatedCIFCount=0;
	int countwhilchk=0;
	String sInputXML = "";
	String sMappOutPutXML = "";
	try{
	
		//String requestType = request.getParameter("request_type");
		String requestType = request_type_Esapi;
		if (requestType != null) {requestType=requestType.replace("'","''");}
		//String wi_name = request.getParameter("wi_name").replace("'","''");
		String wi_name = wi_name_Esapi.replace("'","''");
		if (wi_name != null) {wi_name=wi_name.replace("'","''");}
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
		String rowVal="";
		String addPrefFlag="";
		String ResidenceAddress="";
		String cust_result="";
		String CityOffc="";
		String CountryOffc="";
		String CountryRes="";
		String CityRes="";
		String OfficeAddress="";
		String OfficeAddressforfatcaform="";
		String ResidenceAddressforfatcaform="";
		String preferredLang = "";
		String PODOptions = "";
		String PeopleOfDet = "";
		String PODRemarks = "";
		//String username=request.getParameter("user_name").replace("'","''");
		String username=user_name_Esapi.replace("'","''");
		if (username != null) {username=username.replace("'","''");}
		//String cif_type=request.getParameter("cif_type").replace("'","''");
		String cif_type=cif_type_Esapi.replace("'","''");
		if (cif_type != null) {cif_type=cif_type.replace("'","''");}
		//String CIF_ID=request.getParameter("CIF_ID").replace("'","''");
		String CIF_ID=CIF_ID_Esapi.replace("'","''");
		if (CIF_ID != null) {CIF_ID=CIF_ID.replace("'","''");}
		String params = "";
		WriteLog("request_type_Esapi: "+request_type_Esapi);
		WriteLog("wi_name_Esapi: "+wi_name_Esapi);
		WriteLog("cif_type_Esapi: "+cif_type_Esapi);
		WriteLog("CIF_ID_Esapi: "+CIF_ID_Esapi);
		WriteLog("user_name_Esapi: "+user_name_Esapi);
		WriteLog("\nInside CUIntegration.jsp ,request Type - "+requestType+" for wi_name "+wi_name);
		if (requestType.equalsIgnoreCase("CUSTOMER_DETAILS") && cif_type.equalsIgnoreCase("Individual"))
		{
			String inputCustomer_details = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sSessionId+"</SessionId>\n"+
				"<EngineName>"+sCabName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n"+
				"<ProcessName>CU</ProcessName>\n" +
				"<EE_EAI_HEADER>\n"+
				" <MsgFormat>CUSTOMER_DETAILS</MsgFormat>\n"+
				  "<MsgVersion>0000</MsgVersion>\n"+
				  "<RequestorChannelId>BPM</RequestorChannelId>\n"+
				  "<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				  "<RequestorLanguage>E</RequestorLanguage>\n"+
				  "<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				  "<ReturnCode>911</ReturnCode>\n"+
				  "<ReturnDesc>Issuer Timed Out</ReturnDesc>\n"+
				  "<MessageId>CUSTOMER_DETAILS_LOG_CR</MessageId>\n"+
				  "<Extra1>REQ||LAXMANRET.LAXMANRET</Extra1>\n"+
				  "<Extra2>2015-05-28T21:03:16.088+05:30</Extra2>\n"+
			   "</EE_EAI_HEADER>\n"+
			   "<FetchCustomerDetailsReq>"+
				  "<BankId>RAK</BankId>\n"+
				  "<CCIFID></CCIFID>\n"+
				  "<RCIFID>"+CIF_ID+"</RCIFID>\n"+
				  "<DealProdType></DealProdType>\n"+
				  "<FetchExpired></FetchExpired>\n"+
			   "</FetchCustomerDetailsReq>"+
			"</EE_EAI_MESSAGE></RequestMessage>\n"+
			"</BPM_APMQPutGetMessage_Input>";
		
		String tempDir = System.getProperty("user.dir");
		WriteLog("\ninput CUSTOMER_DETAILS inputCustomer_details: "+inputCustomer_details);
		sMappOutPutXML= WFCustomCallBroker.execute(inputCustomer_details,customSession.getJtsIp(),customSession.getJtsPort(),1);
		//	sMappOutPutXML = readFileFromServer(tempDir+File.separator+"CUTesting"+File.separator+"Customer_details1.txt");	
			WriteLog("\n CUSTOMER_DETAILS Output: "+sMappOutPutXML);
			String FetchCustomerDetailsRes = "";
			try{
		
				if(sMappOutPutXML.contains("<FetchCustomerDetailsRes>"))
				{
					FetchCustomerDetailsRes = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FetchCustomerDetailsRes>"),sMappOutPutXML.indexOf("</FetchCustomerDetailsRes>")+"</FetchCustomerDetailsRes>".length());
					
					//added by stutee.mishra fro POL and POD changes.
					
					if(FetchCustomerDetailsRes.contains("<LangPref>")){
						preferredLang = FetchCustomerDetailsRes.substring(FetchCustomerDetailsRes.indexOf("<LangPref>")+"</LangPref>".length()-1,FetchCustomerDetailsRes.indexOf("</LangPref>"));
					}
					WriteLog("CUSTOMER_DETAILS Output, preferredLang: "+preferredLang);
					
					if(FetchCustomerDetailsRes.contains("<SplSupport>")){
						PeopleOfDet = FetchCustomerDetailsRes.substring(FetchCustomerDetailsRes.indexOf("<SplSupport>")+"</SplSupport>".length()-1,FetchCustomerDetailsRes.indexOf("</SplSupport>"));
						if(PeopleOfDet.equalsIgnoreCase("Y"))
							PeopleOfDet = "Yes";
						else if(PeopleOfDet.equalsIgnoreCase("N"))
							PeopleOfDet = "No";
					}
					WriteLog("CUSTOMER_DETAILS Output, PeopleOfDet: "+PeopleOfDet);
					
					if(FetchCustomerDetailsRes.contains("<PeopleOfDet>")){
						String PODOptionsOg = FetchCustomerDetailsRes.substring(FetchCustomerDetailsRes.indexOf("<PeopleOfDet>")+"</PeopleOfDet>".length()-1,FetchCustomerDetailsRes.indexOf("</PeopleOfDet>"));
						WriteLog("CUSTOMER_DETAILS Output, PODOptionsOg: "+PODOptionsOg);
						String optionsArr[] = PODOptionsOg.split(",");
						for(String eachOption : optionsArr){
							if(eachOption.equalsIgnoreCase("HEAR")){
								PODOptions = PODOptions+"Hearing"+",";
							}else if(eachOption.equalsIgnoreCase("COGN")){
								PODOptions = PODOptions+"Cognitive"+",";
							}else if(eachOption.equalsIgnoreCase("NEUR")){
								PODOptions = PODOptions+"Neurological"+",";
							}else if(eachOption.equalsIgnoreCase("PHYS")){
								PODOptions = PODOptions+"Physical"+",";
							}else if(eachOption.equalsIgnoreCase("SPCH")){
								PODOptions = PODOptions+"Speech"+",";
							}else if(eachOption.equalsIgnoreCase("VISL")){
								PODOptions = PODOptions+"Visual"+",";
							}else if(eachOption.equalsIgnoreCase("OTHR")){
								PODOptions = PODOptions+"Others"+",";
							}
						}
						//PeopleOfDet = "Yes";
						PODOptions = PODOptions.substring(0,(PODOptions.length())-1);
					}
					
					WriteLog("CUSTOMER_DETAILS Output, PODOptions: "+PODOptions);
					
					if(FetchCustomerDetailsRes.contains("<DetRmks>")){
						PODRemarks = FetchCustomerDetailsRes.substring(FetchCustomerDetailsRes.indexOf("<DetRmks>")+"</DetRmks>".length()-1,FetchCustomerDetailsRes.indexOf("</DetRmks>"));
					}
					WriteLog("CUSTOMER_DETAILS Output, PODRemarks: "+PODRemarks);
					//end.
					
					while(FetchCustomerDetailsRes.contains("<AddrDet>"))
					{
						String Address1="",Address2="",Address3="",Address4="",Country="",City="",Pobox="",ResType ="";
						rowVal = FetchCustomerDetailsRes.substring(FetchCustomerDetailsRes.indexOf("<AddrDet>"),FetchCustomerDetailsRes.indexOf("</AddrDet>")+"</AddrDet>".length());
						
						String AddressType = rowVal.substring(rowVal.indexOf("<AddressType>")+"</AddressType>".length()-1,rowVal.indexOf("</AddressType>"));
						if(AddressType.equalsIgnoreCase("OFFICE"))
						{
							Address1 = (rowVal.contains("<AddressLine1>")) ? rowVal.substring(rowVal.indexOf("<AddressLine1>")+"</AddressLine1>".length()-1,rowVal.indexOf("</AddressLine1>")) : "";
							Address1 = Address1.replaceAll("\\,","");
							Address2 = (rowVal.contains("<AddressLine2>")) ? rowVal.substring(rowVal.indexOf("<AddressLine2>")+"</AddressLine2>".length()-1,rowVal.indexOf("</AddressLine2>")) : "";
							Address2 = Address2.replaceAll("\\,","");
							Address3 = (rowVal.contains("<AddressLine3>")) ? rowVal.substring(rowVal.indexOf("<AddressLine3>")+"</AddressLine3>".length()-1,rowVal.indexOf("</AddressLine3>")) : "";
							//WriteLog("\nAddress3 Office"+Address3);
							Address3 = Address3.replaceAll("\\,","");
							Address4 = (rowVal.contains("<AddressLine4>")) ? rowVal.substring(rowVal.indexOf("<AddressLine4>")+"</AddressLine4>".length()-1,rowVal.indexOf("</AddressLine4>")) : "";
							Country = (rowVal.contains("<Country>")) ?  rowVal.substring(rowVal.indexOf("<Country>")+"</Country>".length()-1,rowVal.indexOf("</Country>")):"";
							Address4 = Address4.replaceAll("\\,","");
							ResType = (rowVal.contains("<ResType>")) ?  rowVal.substring(rowVal.indexOf("<ResType>")+"</ResType>".length()-1,rowVal.indexOf("</ResType>")):"";
							if(ResType.equalsIgnoreCase("R"))
							{
								ResType = "Rented";
							}
							else if (ResType.equalsIgnoreCase("O"))
							{
								ResType = "Owned";
							}
							// WriteLog("\n CUSTOMER_DETAILS Country-->"+Country);
							City = (rowVal.contains("<City>")) ?  rowVal.substring(rowVal.indexOf("<City>")+"</City>".length()-1,rowVal.indexOf("</City>")):"";
							// WriteLog("\n CUSTOMER_DETAILS City-->"+City);
							Pobox = (rowVal.contains("<POBox>")) ?  rowVal.substring(rowVal.indexOf("<POBox>")+"</POBox>".length()-1,rowVal.indexOf("</POBox>")):"";
							 //WriteLog("\nCUSTOMER_DETAILS POBox-->"+Pobox);
							String query = "select countryName from USR_0_CU_CountryMaster with (nolock) where countrycode=:countrycode";
							params = "countrycode=="+Country;
							
							String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							// WriteLog("\nInputXML CUSTOMER_DETAILS 123567-->"+inputXML);
							String outputXML = WFCustomCallBroker.execute(inputXML, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS exceptions-->"+outputXML);
							
							WFCustomXmlResponse xmlParserData=new WFCustomXmlResponse();
							xmlParserData.setXmlString((outputXML));
							String mainCodeValue = xmlParserData.getVal("MainCode");
							String subXML="";
							WFCustomXmlResponse objXmlParser=null;
							
							if(mainCodeValue.equals("0"))
							{
								Country = xmlParserData.getVal("countryName");
								//WriteLog("\ncountryName CUSTOMER_DETAILS"+Country);	
							}
							
							String query1 = "select cityname from USR_0_CU_CityMaster with (nolock) where citycode=:citycode";
							params = "citycode=="+City;
							String inputXML1 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							//String inputXML1 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query1 + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							//WriteLog("\nInputXML CUSTOMER_DETAILS abcdef-->"+inputXML1);
							String outputXML1 = WFCustomCallBroker.execute(inputXML1, sJtsIp, iJtsPort, 1);
							//WriteLog("\noutputXML CUSTOMER_DETAILS exceptions-->"+outputXML1);
							
							WFCustomXmlResponse xmlParserData1=new WFCustomXmlResponse();
							xmlParserData1.setXmlString((outputXML1));
							String mainCodeValue1 = xmlParserData1.getVal("MainCode");
							String subXML1="";
							WFCustomXmlResponse objXmlParser1=null;
							
							if(mainCodeValue1.equals("0"))
							{
								City = xmlParserData1.getVal("cityname");
								//WriteLog("\ncityname CUSTOMER_DETAILS"+City);
								//WriteLog("\nquery1 CUSTOMER_DETAILS"+query1);
							}
							if(!addPrefFlag.equalsIgnoreCase("Home"))
							addPrefFlag = (rowVal.contains("<AddrPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<AddrPrefFlag>")+"</AddrPrefFlag>".length()-1,rowVal.indexOf("</AddrPrefFlag>")):"";
							if(addPrefFlag.equalsIgnoreCase("Y"))
								addPrefFlag="Office";
							
							OfficeAddress = Address1+" "+Address2+" "+Address3+" "+ResType+""+Address4 +" "+ Pobox +" "+City+" "+ Country;
							OffcAddress1 = Address1;
							OffcPobox = Pobox;
							CountryOffc=Country;
							CityOffc=City;
							OfficeAddressforfatcaform= Address1+" "+Address2+" "+Address3+" "+Address4;
							OfficeAddressforfatcaform = OfficeAddressforfatcaform.replaceAll("&amp;","");
							OfficeAddress = OfficeAddress.replaceAll("&amp;","");
							
							WriteLog("\nwdesk:office_add_exis CUSTOMER_DETAILS~"+OfficeAddressforfatcaform);
							//WriteLog("\nwdesk:office_add_exis CUSTOMER_DETAILS~"+OfficeAddress);
							//WriteLog("\naddPrefFlagOffice CUSTOMER_DETAILS~"+addPrefFlag);
							//WriteLog("\nOffcAddress1 for CUSTOMER_DETAILS details~"+OffcAddress1);
						}
						else if(AddressType.equalsIgnoreCase("Residence"))
						{
							//WriteLog("\nIn address residence CUSTOMER_DETAILS");
							
							//WriteLog("\nwdesk:Address1 CUSTOMER_DETAILS~"+rowVal.toString());
							Address1 = (rowVal.contains("<AddressLine1>")) ? rowVal.substring(rowVal.indexOf("<AddressLine1>")+"</AddressLine1>".length()-1,rowVal.indexOf("</AddressLine1>")):"" ;
							Address1 = Address1.replaceAll("\\,","");
							Address2 = (rowVal.contains("<AddressLine2>")) ?  rowVal.substring(rowVal.indexOf("<AddressLine2>")+"</AddressLine2>".length()-1,rowVal.indexOf("</AddressLine2>")):"";
							Address2 = Address2.replaceAll("\\,","");
							Address3 = (rowVal.contains("<AddressLine3>")) ?  rowVal.substring(rowVal.indexOf("<AddressLine3>")+"</AddressLine3>".length()-1,rowVal.indexOf("</AddressLine3>")):"";
							Address3 = Address3.replaceAll("\\,","");
							Address4 = (rowVal.contains("<AddressLine4>")) ?  rowVal.substring(rowVal.indexOf("<AddressLine4>")+"</AddressLine4>".length()-1,rowVal.indexOf("</AddressLine4>")):"";
							
							Address4 = Address4.replaceAll("\\,","");
							ResType = (rowVal.contains("<ResType>")) ?  rowVal.substring(rowVal.indexOf("<ResType>")+"</ResType>".length()-1,rowVal.indexOf("</ResType>")):"";
							if(ResType.equalsIgnoreCase("R"))
							{
								ResType = "Rented";
							}
							else if (ResType.equalsIgnoreCase("O"))
							{
								ResType = "Owned";
							}
							CountryRes = (rowVal.contains("<Country>")) ?  rowVal.substring(rowVal.indexOf("<Country>")+"</Country>".length()-1,rowVal.indexOf("</Country>")):"";
							
							CityRes = (rowVal.contains("<City>")) ?  rowVal.substring(rowVal.indexOf("<City>")+"</City>".length()-1,rowVal.indexOf("</City>")):"";
							Pobox = (rowVal.contains("<POBox>")) ?  rowVal.substring(rowVal.indexOf("<POBox>")+"</POBox>".length()-1,rowVal.indexOf("</POBox>")):"";
							// WriteLog("\nCountry CUSTOMER_DETAILS--->"+CountryRes);
						
							String query = "select countryName from USR_0_CU_CountryMaster with (nolock) where countrycode=:countrycode";
							params = "countrycode=="+CountryRes;
							String inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							//String inputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
							// WriteLog("\n InputXML CUSTOMER_DETAILS country-->"+inputXML);
							String outputXML = WFCustomCallBroker.execute(inputXML, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS country-->"+outputXML);
							
							WFCustomXmlResponse xmlParserData=new WFCustomXmlResponse();
							xmlParserData.setXmlString((outputXML));
							String mainCodeValue = xmlParserData.getVal("MainCode");
							String subXML="";
							WFCustomXmlResponse objXmlParser=null;
							
							if(mainCodeValue.equals("0"))
							{
								CountryRes = xmlParserData.getVal("countryName");
								//WriteLog("\ncountryName CUSTOMER_DETAILS --->"+CountryRes);	
							}
							
							//String query1 = "select cityname from USR_0_CU_CityMaster with (nolock) where citycode='"+CityRes+"'";
							String query1 = "select cityname from USR_0_CU_CityMaster with (nolock) where citycode=:citycode";
							params = "citycode=="+CityRes;
							/*String inputXML1 = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query1 + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";*/
							
							String inputXML1 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
							
							// WriteLog("\nInputXML CUSTOMER_DETAILS city-->"+inputXML1);
							String outputXML1 = WFCustomCallBroker.execute(inputXML1, sJtsIp, iJtsPort, 1);
							// WriteLog("\noutputXML CUSTOMER_DETAILS city-->"+outputXML1);
							
							WFCustomXmlResponse xmlParserData1=new WFCustomXmlResponse();
							xmlParserData1.setXmlString((outputXML1));
							String mainCodeValue1 = xmlParserData1.getVal("MainCode");
							String subXML1="";
							WFCustomXmlResponse objXmlParser1=null;
							
							if(mainCodeValue1.equals("0"))
							{
								CityRes = xmlParserData1.getVal("cityname");
								//WriteLog("\ncityname CUSTOMER_DETAILS"+CityRes);
								//WriteLog("\nquery1 CUSTOMER_DETAILS"+query1);
							}
							if(addPrefFlag.equalsIgnoreCase("N") || addPrefFlag.equalsIgnoreCase(""))
							addPrefFlag = (rowVal.contains("<AddrPrefFlag>")) ?  rowVal.substring(rowVal.indexOf("<AddrPrefFlag>")+"</AddrPrefFlag>".length()-1,rowVal.indexOf("</AddrPrefFlag>")):"";
							
							if(addPrefFlag.equalsIgnoreCase("Y"))
							addPrefFlag="Home";
							
							
							
							ResidenceAddress = 	Address1.trim()+" "+Address2.trim()+" "+Address3.trim()+" "+ResType.trim()+" "+Address4.trim() +" "+ Pobox.trim() +" "+CityRes.trim()+" "+ CountryRes.trim();
							ResAddress1 = Address1;
							ResPobox = Pobox;
							ResidenceAddress = ResidenceAddress.replaceAll("&amp;","");
							
							ResidenceAddressforfatcaform= Address1.trim()+" "+Address2.trim()+" "+Address3.trim()+" "+Address4.trim();
							ResidenceAddressforfatcaform = ResidenceAddressforfatcaform.replaceAll("&amp;","");
							
							WriteLog("\nwdesk:resiadd_exis CUSTOMER_DETAILS~"+ResidenceAddressforfatcaform);
							//WriteLog("\nwdesk:resiadd_exis CUSTOMER_DETAILS~"+ResidenceAddress);
							//WriteLog("\naddPrefFlagResidence CUSTOMER_DETAILS~"+addPrefFlag);
							//WriteLog("\nResAddress1 for CUSTOMER_DETAILS~"+ResAddress1);
						}
						
						//WriteLog("Above 1 "+addPrefFlag );
						
						FetchCustomerDetailsRes = FetchCustomerDetailsRes.replaceAll(rowVal, "");
						OfficeAddress = OfficeAddress.replaceAll("\\,","");
						
						ResidenceAddress = ResidenceAddress.replaceAll("\\,","");
						
						countwhilchk++;
						if(countwhilchk == 10)
						{
							
							countwhilchk = 0;
							break;
						}
					}
		
					cust_result ="wdesk:pref_add_exis~"+addPrefFlag+"`"+"office_add_exis~"+OfficeAddress+"`"+"OffcAddress1~"+OffcAddress1+"`"+"offc_pobox1~"+OffcPobox+"`"+"offcCountry1~"+CountryOffc+"`"+"offcCity1~"+CityOffc+"`"+"wdesk:resi_countryexis~"+CountryRes+"`"+"wdesk:resi_cityexis~"+CityRes+"`"+"resiadd_exis~"+ResidenceAddress+"`"+"resAddress1~"+ResAddress1+"`"+"resi_pobox1~"+ResPobox+"`"+"resaddress1existing~"+ResidenceAddressforfatcaform+"`"+"offaddress1existing~"+OfficeAddressforfatcaform+"`"+"wdesk:prefOfLanguage_exis~"+preferredLang+"`"+"wdesk:PODOptions_exis~"+PODOptions+"`"+"wdesk:PODRemarks_exis~"+PODRemarks+"`"+"wdesk:peopleOfDeterm_exis~"+PeopleOfDet;
		
		}
	}
	catch(Exception e){
				 WriteLog("\nException occured in get Customer data CUSTOMER_DETAILS:"+e);
			}
			
			out.clear();
			out.println(cust_result);
			WriteLog("\nOutput : CUSTOMER_DETAILS---cust_result---"+cust_result+" for wi_name "+wi_name);
	}
	


		}	
	
	catch(Exception e){
		e.printStackTrace();
		sMappOutPutXML="Exception"+e;
		WriteLog("in catch");
		WriteLog(sMappOutPutXML);
	}
	
	%>