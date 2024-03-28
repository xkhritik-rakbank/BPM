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
%>
<%
		WriteLog("\nInside entity detail.jsp\n");
	try
	{
		WriteLog("\nInside CustomerDetail.jsp\n");
		String sMappOutPutXML="";
		String rowVal="";
		String FirstName= "";
		String MiddleName= "";
		String LastName= "";
		String ReturnCode="";
		String requestType = "CUSTOMER_SUMMARY";
		int countwhilchk = 0;
		String params = "";
		String CIFID= "";
		String Name= "";
		String Relation_Type= "";
		String OECD_CountryOfBirth = "";
		String val_main="";
		
		
		if (requestType.equals("CUSTOMER_SUMMARY"))
		{
			String sCabName=customSession.getEngineName();	
			String sSessionId = customSession.getDMSSessionId();
			String sessionId=sSessionId,engineName=sCabName;
			String username= customSession.getUserName();
			String sJtsIp = customSession.getJtsIp();
			int iJtsPort = customSession.getJtsPort();
			
			String CIF_ID=request.getParameter("CIF_ID");
				WriteLog("CIF_ID for CUSTOMER_DETAILS call"+CIF_ID+"");
			String inputEntityDetailsXML = "<?xml version=\"1.0\"?>"
				+ "<BPM_APMQPutGetMessage_Input>\n"+
				"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+username+"</UserID>\n" +
				"<SessionId>"+sessionId+"</SessionId>\n"+
				"<EngineName>"+engineName+"</EngineName>\n" +
				"<RequestMessage><EE_EAI_MESSAGE>\n" +
				"<ProcessName>OECD</ProcessName>\n" +
				"<EE_EAI_HEADER>\n" +
				"<MsgFormat>CUSTOMER_SUMMARY</MsgFormat>\n" +
				"<MsgVersion>0000</MsgVersion>\n" +
				"<RequestorChannelId>BPM</RequestorChannelId>\n" +
				"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
				"<RequestorLanguage>E</RequestorLanguage>\n" +
				"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
				"<ReturnCode>911</ReturnCode>\n" +
				"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
				"<MessageId>143282709427399867</MessageId>\n" +
				"<Extra1>REQ||RAK_TEMP_USER_3394.RAK_TEMP_USER_3394</Extra1>\n" +
				"<Extra2>2015-05-28T21:01:34.273+05:30</Extra2>\n" +
				"</EE_EAI_HEADER><RelatedPartyDetailsRequest><BankId>RAK</BankId><CIFId>"+CIF_ID+"</CIFId><FetchType>C</FetchType><RelationType>ALL</RelationType></RelatedPartyDetailsRequest></EE_EAI_MESSAGE></RequestMessage>\n" +				
		        "</BPM_APMQPutGetMessage_Input>";
				
			WriteLog("\nInput XML For Customer Detail Call"+inputEntityDetailsXML);
			
			sMappOutPutXML= WFCustomCallBroker.execute(inputEntityDetailsXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			WriteLog("\nOutput XML For Customer Detail Call:\n"+sMappOutPutXML);	
			//String tempDir = System.getProperty("user.dir");
			//sMappOutPutXML = readFileFromServer(tempDir+File.separator+"OECDTesting"+File.separator+"Customer_Details.txt");
			
			ReturnCode =  (sMappOutPutXML.contains("<ReturnCode>")) ? sMappOutPutXML.substring(sMappOutPutXML.indexOf("<ReturnCode>")+"</ReturnCode>".length()-1,sMappOutPutXML.indexOf("</ReturnCode>")):"";	


			try{ 
				
				if(sMappOutPutXML.contains("<FName>"))
				 {
					FirstName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FName>")+"<FName>".length(),sMappOutPutXML.indexOf("</FName>"));
					WriteLog("\nFirstName from Customer Detail --->"+FirstName);
				 }
				 
				 
				 if(sMappOutPutXML.contains("<MName>"))
				 {
					MiddleName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<MName>")+"<MName>".length(),sMappOutPutXML.indexOf("</MName>"));
					WriteLog("\nLastName from Customer Detail --->"+MiddleName);
				 }
				 
				  if(sMappOutPutXML.contains("<LName>"))
				 {
					LastName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<LName>")+"<LName>".length(),sMappOutPutXML.indexOf("</LName>"));
					WriteLog("\nLastName from Customer Detail --->"+LastName);
				 }
				 
				   if(sMappOutPutXML.contains("<RCIFId>"))
				 {
					CIFID = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<RCIFId>")+"<RCIFId>".length(),sMappOutPutXML.indexOf("</RCIFId>"));
					WriteLog("\nLastName from Customer Detail --->"+CIFID);
				 }
				 
				   if(sMappOutPutXML.contains("<RCIFId>"))
				 {
					Relation_Type = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<SubRelationshipStatus>")+"<SubRelationshipStatus>".length(),sMappOutPutXML.indexOf("</SubRelationshipStatus>"));
					WriteLog("\nLastName from Customer Detail --->"+Relation_Type);
				 }
				 
			
				//val_main = FirstName+"~"+LastName+"~"+Nationality+"~"+DOB+"~"+OECD_CityOfBirth+"~"+OECD_CountryOfBirth+"~"+CntryOfTaxRes+"~"+MiscellaneousID+"~"+NoTINReason+"~"+AddressLine1+"~"+AddressLine2+"~"+AddressLine3+"~"+AddressLine4+"~"+POBox+"~"+City+"~"+Country;
				
				String FullName=FirstName+" "+MiddleName+" "+LastName;
				val_main = FullName+"~"+CIFID+"~"+Relation_Type;
				WriteLog("\nval_main---"+val_main);
				WriteLog("\nsMappOutPutXML---"+sMappOutPutXML);
			}
			catch(Exception e)
			{
			e.printStackTrace();
			
			WriteLog("in catch block of Customer Details call");
			}
			
		}	
		out.clear();
		out.println(sMappOutPutXML);
		
		
	}
		catch(Exception e){
		e.printStackTrace();
		//sMappOutPutXML="Exception"+e;
		WriteLog("in catch");
		//WriteLog(sMappOutPutXML);
		}
%>