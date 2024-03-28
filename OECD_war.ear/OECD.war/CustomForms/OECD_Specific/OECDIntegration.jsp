<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../OECD_Specific/Log.process"%>
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
		WriteLog("\nInside entity detail.jsp\n");
	try
	{
		WriteLog("\nInside CustomerDetail.jsp\n");
		String sMappOutPutXML="";
		String rowVal="";
		String FirstName= "";
		String LastName= "";
		String Nationality= "";
		String DOB= "";
		String CityOfBirth= "";
		String CountryOfBirth= "";
		String CntryOfTaxRes= "";
		String MiscellaneousID= "";
		String NoTINReason= "";
		String AddrPrefFlag= "";
		String AddressLine1= "";
		String AddressLine2= "";
		String AddressLine3= "";
		String AddressLine4= "";
		String POBox= "";
		String City= "";
		String Country= "";
		String ReturnCode="";
		String requestType = "ENTITY_DETAILS";
		int countwhilchk = 0;
		String params = "";
		String OECD_CityOfBirth = "";
		String OECD_CountryOfBirth = "";
		String val_main="";
		
		if (requestType.equals("ENTITY_DETAILS"))
		{
			String sCabName=customSession.getEngineName();	
			String sSessionId = customSession.getDMSSessionId();
			String sessionId=sSessionId,engineName=sCabName;
			String username= customSession.getUserName();
			String sJtsIp = customSession.getJtsIp();
			int iJtsPort = customSession.getJtsPort();
			
			String CIF_ID=request.getParameter("CIF_ID");
				WriteLog("CIF_ID for ENTITY_DETAILS call"+CIF_ID+"");
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n" +
				"<ProcessName>OECD</ProcessName>\n" +
				"<EE_EAI_HEADER>\n" +
				"<MsgFormat>ENTITY_DETAILS</MsgFormat>\n" +
				"<MsgVersion>0000</MsgVersion>\n" +
				"<RequestorChannelId>BPM</RequestorChannelId>\n" +
				"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
				"<RequestorLanguage>E</RequestorLanguage>\n" +
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
				"<ReturnCode>911</ReturnCode>\n" +
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
				"<MessageId>143282719608815876</MessageId>\n" +
				"<Extra1>REQ||LAXMANRET.LAXMANRET</Extra1>\n" +
				"<Extra2>2015-05-28T21:03:16.088+05:30</Extra2>\n" +
				"</EE_EAI_HEADER><CustomerDetails><BankId>RAK</BankId><CIFID>"+CIF_ID+"</CIFID><InquiryType>CustomerAndAccount</InquiryType><RelCIFDetFlag>Y</RelCIFDetFlag><FreeField1></FreeField1><FreeField2></FreeField2><FreeField3></FreeField3></CustomerDetails></EE_EAI_MESSAGE></RequestMessage>\n" +				
				"</BPM_APMQPutGetMessage_Input>";
				
			WriteLog("\nInput XML For Customer Detail Call"+inputEntityDetailsXML);
			
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			//WriteLog("\nOutput XML For Customer Detail Call:\n"+sMappOutPutXML);	
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"OECDTesting"+File.separator+"Entity_Details.txt");
			WriteLog("\nOutput XML Customer Integration Call:\n"+sMappOutPutXML);	
			
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";	


			try{ 
			
				 
				/*if(sMappOutPutXML.contains("<FName>"))
				 {
					FirstName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FName>")+"<FName>".length(),sMappOutPutXML.indexOf("</FName>"));
					WriteLog("\nFirstName from Customer Detail --->"+FirstName);
				 }
				 
				 
				 if(sMappOutPutXML.contains("<LName>"))
				 {
					LastName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<LName>")+"<LName>".length(),sMappOutPutXML.indexOf("</LName>"));
					WriteLog("\nLastName from Customer Detail --->"+LastName);
				 }
				
				 
				 if(sMappOutPutXML.contains("<Nationality>"))
				 {
					Nationality = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<Nationality>")+"<Nationality>".length(),sMappOutPutXML.indexOf("</Nationality>"));
					WriteLog("\nNationality from Customer Detail --->"+Nationality);
				 }
				
				 if(sMappOutPutXML.contains("<DOB>"))
				 {
					DOB = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<DOB>")+"<DOB>".length(),sMappOutPutXML.indexOf("</DOB>"));
					WriteLog("\nDOB from Customer Detail --->"+DOB);
				 } 
				 
				 
				 
				 if(sMappOutPutXML.contains("<CityOfBirth>"))
				 {
					OECD_CityOfBirth = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CityOfBirth>")+"<CityOfBirth>".length(),sMappOutPutXML.indexOf("</CityOfBirth>"));
					WriteLog("\nOECD_CityOfBirth code in CUSTOMER_DETAILS --->"+OECD_CityOfBirth);
					if (!OECD_CityOfBirth.equalsIgnoreCase("") && OECD_CityOfBirth != null && OECD_CityOfBirth != "")
					{
						String query4 = "select cityName from USR_0_RAO_CityMaster with (nolock) where cityCode=:cityCode";
						params = "cityCode=="+OECD_CityOfBirth;
						String inputXML4 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query4 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
						
						 //WriteLog("\n InputXML CUSTOMER_DETAILS to get OECD_CityOfBirth-->"+inputXML4);
						String outputXML4 = WFCustomCallBroker.execute(inputXML4, sJtsIp, iJtsPort, 1);
						 //WriteLog("\noutputXML CUSTOMER_DETAILS to get OECD_CityOfBirth-->"+outputXML4);
						
						WFCustomXmlResponse xmlParserData4=new WFCustomXmlResponse();
						xmlParserData4.setXmlString((outputXML4));
						String mainCodeValue4 = xmlParserData4.getVal("MainCode");
						
						WFCustomXmlResponse objXmlParser4=null;
						
						if(mainCodeValue4.equals("0"))
						{
							String COfBirth = xmlParserData4.getVal("cityName");
							if (!COfBirth.equalsIgnoreCase("") && COfBirth != null && COfBirth != "")
							{
								OECD_CityOfBirth = COfBirth ;
							}
							WriteLog("\nOECD_CityOfBirth name in CUSTOMER_DETAILS --->"+OECD_CityOfBirth);
						}
					}
				 }
				 
				 
				 if(sMappOutPutXML.contains("<CountryOfBirth>"))
				 {
					OECD_CountryOfBirth = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CountryOfBirth>")+"<CountryOfBirth>".length(),sMappOutPutXML.indexOf("</CountryOfBirth>"));
					WriteLog("\nOECD_CountryOfBirth code in CUSTOMER_DETAILS --->"+OECD_CountryOfBirth);	
					if (!OECD_CountryOfBirth.equalsIgnoreCase("") && OECD_CountryOfBirth != null && OECD_CountryOfBirth != "")
					{
						String query5 = "select countryName from USR_0_RAO_CountryMaster with (nolock) where countrycode=:countrycode";
						params = "countrycode=="+OECD_CountryOfBirth;
						String inputXML5 = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query5 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
						
						 //WriteLog("\n InputXML CUSTOMER_DETAILS to get OECD_CountryOfBirth-->"+inputXML5);
						String outputXML5 = WFCustomCallBroker.execute(inputXML5, sJtsIp, iJtsPort, 1);
						 //WriteLog("\noutputXML CUSTOMER_DETAILS to get OECD_CountryOfBirth-->"+outputXML5);
						
						WFCustomXmlResponse xmlParserData5=new WFCustomXmlResponse();
						xmlParserData5.setXmlString((outputXML5));
						String mainCodeValue5 = xmlParserData5.getVal("MainCode");
						WFCustomXmlResponse objXmlParser5=null;
						
						if(mainCodeValue5.equals("0"))
						{
							OECD_CountryOfBirth = xmlParserData5.getVal("countryName");
							WriteLog("\nOECD_CountryOfBirth name in CUSTOMER_DETAILS --->"+OECD_CountryOfBirth);	
						}
					}
				 }
				 
				 countwhilchk = 0;
				while(sMappOutPutXML.contains("<OECDDet>"))
				{
					rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<OECDDet>"),sMappOutPutXML.indexOf("</OECDDet>")+"</OECDDet>".length());
					
					 CntryOfTaxRes = (rowVal.contains("<CntryOfTaxRes>")) ? rowVal.substring(rowVal.indexOf("<CntryOfTaxRes>")+"</CntryOfTaxRes>".length()-1,rowVal.indexOf("</CntryOfTaxRes>")):"";
					WriteLog("\nCntryOfTaxRes from Customer Detail --->"+CntryOfTaxRes);

					 MiscellaneousID = (rowVal.contains("<MiscellaneousID>")) ? rowVal.substring(rowVal.indexOf("<MiscellaneousID>")+"</MiscellaneousID>".length()-1,rowVal.indexOf("</MiscellaneousID>")):"";
					WriteLog("\nMiscellaneousID from Customer Detail --->"+MiscellaneousID);
						
					 NoTINReason = (rowVal.contains("<NoTINReason>")) ? rowVal.substring(rowVal.indexOf("<NoTINReason>")+"</NoTINReason>".length()-1,rowVal.indexOf("</NoTINReason>")):"";
					WriteLog("\nNoTINReason from Customer Detail --->"+NoTINReason);
					
					sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
					countwhilchk++;
					if(countwhilchk == 50)
					{
						countwhilchk = 0;
						break;
					
					}
				}
			*/	
				
				 countwhilchk = 0;
				while(sMappOutPutXML.contains("<AddrDet>"))
				{
					rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<AddrDet>"),sMappOutPutXML.indexOf("</AddrDet>")+"</AddrDet>".length());
					
					AddrPrefFlag = (rowVal.contains("<AddrPrefFlag>")) ? rowVal.substring(rowVal.indexOf("<AddrPrefFlag>")+"</AddrPrefFlag>".length()-1,rowVal.indexOf("</AddrPrefFlag>")):"";
					WriteLog("\nAddrPrefFlag from Customer Detail --->"+AddrPrefFlag);
					
					if(AddrPrefFlag.equalsIgnoreCase("Y"))
					{
					 AddressLine1 = (rowVal.contains("<AddrLine1>")) ? rowVal.substring(rowVal.indexOf("<AddrLine1>")+"</AddrLine1>".length()-1,rowVal.indexOf("</AddrLine1>")):"";
					WriteLog("\nAddressLine1 from Customer Detail --->"+AddressLine1);

					 AddressLine2 = (rowVal.contains("<AddrLine2>")) ? rowVal.substring(rowVal.indexOf("<AddrLine2>")+"</AddrLine2>".length()-1,rowVal.indexOf("</AddrLine2>")):"";
					WriteLog("\nAddressLine2 from Customer Detail --->"+AddressLine2);
						
					 AddressLine3 = (rowVal.contains("<AddrLine3>")) ? rowVal.substring(rowVal.indexOf("<AddrLine3>")+"</AddrLine3>".length()-1,rowVal.indexOf("</AddrLine3>")):"";
					WriteLog("\nAddressLine3 from Customer Detail --->"+AddressLine3);
					
						
					 AddressLine4 = (rowVal.contains("<AddrLine4>")) ? rowVal.substring(rowVal.indexOf("<AddrLine4>")+"</AddrLine4>".length()-1,rowVal.indexOf("</AddrLine4>")):"";
					WriteLog("\nAddressLine4 from Customer Detail --->"+AddressLine4);
					
						
					 POBox = (rowVal.contains("<POBox>")) ? rowVal.substring(rowVal.indexOf("<POBox>")+"</POBox>".length()-1,rowVal.indexOf("</POBox>")):"";
					WriteLog("\nPOBox from Customer Detail --->"+POBox);
					
						
					 City = (rowVal.contains("<City>")) ? rowVal.substring(rowVal.indexOf("<City>")+"</City>".length()-1,rowVal.indexOf("</City>")):"";  
					WriteLog("\nCity from Customer Detail --->"+City);
					
						
					 Country = (rowVal.contains("<Country>")) ? rowVal.substring(rowVal.indexOf("<Country>")+"</Country>".length()-1,rowVal.indexOf("</Country>")):"";
					WriteLog("\nCountry from Customer Detail --->"+Country);
					
					}
					
					sMappOutPutXML = sMappOutPutXML.substring(0,sMappOutPutXML.indexOf(rowVal))+ sMappOutPutXML.substring(sMappOutPutXML.indexOf(rowVal)+rowVal.length());
				
					countwhilchk++;
					if(countwhilchk == 50)
					{
						countwhilchk = 0;
						break;
					
					}
				}
				
				//val_main = FirstName+"~"+LastName+"~"+Nationality+"~"+DOB+"~"+OECD_CityOfBirth+"~"+OECD_CountryOfBirth+"~"+CntryOfTaxRes+"~"+MiscellaneousID+"~"+NoTINReason+"~"+AddressLine1+"~"+AddressLine2+"~"+AddressLine3+"~"+AddressLine4+"~"+POBox+"~"+City+"~"+Country;
				
				val_main = AddressLine1+"~"+AddressLine2+"~"+AddressLine3+"~"+AddressLine4+"~"+POBox+"~"+City+"~"+Country;
				WriteLog("\nval_main---"+val_main);
			}
			catch(Exception e)
			{
			e.printStackTrace();
			
			WriteLog("in catch block of Customer Details call");
			}
			
		}	
		out.clear();
		out.println(val_main);
		
		
	}
		catch(Exception e){
		e.printStackTrace();
		//sMappOutPutXML="Exception"+e;
		WriteLog("in catch");
		//WriteLog(sMappOutPutXML);
		}
%>