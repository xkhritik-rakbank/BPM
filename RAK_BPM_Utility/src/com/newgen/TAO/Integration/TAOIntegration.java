package com.newgen.TAO.Integration;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.net.Socket;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.xml.parsers.ParserConfigurationException;

import org.xml.sax.SAXException;

import com.newgen.common.CommonConnection;
import com.newgen.common.CommonMethods;
import com.newgen.omni.jts.cmgr.XMLParser;
import com.newgen.wfdesktop.xmlapi.WFXmlList;
import com.newgen.wfdesktop.xmlapi.WFXmlResponse;

import ISPack.CImageServer;
import ISPack.ISUtil.JPISException;
import Jdts.DataObject.JPDBString;

public class TAOIntegration {
	

	public  int sessionCheckInt=0;
	public  int loopCount=50;
	public  int waitLoop=50;
	Socket socket=null;
	String socketServerIP="";
	int socketServerPort=0;
	OutputStream out = null;
	InputStream socketInputStream = null;
	DataOutputStream dout = null;
	DataInputStream din = null;
	String outputResponse = null;
	String inputRequest = null;
	String ws_name="";
	String histTable="";
	String inputMessageID = null;
	String CIFID="";
	String strDocDownloadPath="";
	String MessageId="";
	String ReturnCode="";
	String Description="";
	String ReturnDesc="";
	String MsgFormat="";
	String jtsPort="";
	String jtsIP="";
	String sCabinetName="";
	String sSessionId="";
	
	
	WFXmlResponse xmlParserData=new WFXmlResponse();
	WFXmlList objWorkList=null;
	

	public String RegUsrProfileIntegration(String cabinetName, String sessionID,String sJtsIp, String sJtsPort ,String wi_name,String WorkItemID,
			int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap, String entryDateTime,String historyTable,String wsName) throws Exception
	{
		jtsIP=sJtsIp;
		jtsPort=sJtsPort;
		ws_name=wsName;
		histTable=historyTable;
		sCabinetName=cabinetName;
		sSessionId=sessionID;
		String finaldecision="";
		String QueryString="SELECT TOP 1 REGISTER_USER_INT_FLAG,ET_USER_INT_FLAG,Req_Det_User_Id,RetailCustomerName,EmailID,CIF_Number,Retail_CIF"
				+" FROM RB_TAO_EXTTABLE with (nolock) where WI_NAME ='"+wi_name+"'";


		String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
		TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

		String sOutputXML=TAOSystemIntegration.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
		TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for extranl Table select "+sOutputXML);

		XMLParser sXMLParser= new XMLParser(sOutputXML);
	    String sMainCode = sXMLParser.getValueOf("MainCode");
	    TAOSystemIntegrationLog.TAOSILogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
	    TAOSystemIntegrationLog.TAOSILogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			
			TAOSystemIntegrationLog.TAOSILogger.debug("Coming in If Sajan");
			
			String REGISTER_USER_INT_FLAG="";
			REGISTER_USER_INT_FLAG=sXMLParser.getValueOf("REGISTER_USER_INT_FLAG");
			if ("".equalsIgnoreCase(REGISTER_USER_INT_FLAG.trim()))
				REGISTER_USER_INT_FLAG = "";
			TAOSystemIntegrationLog.TAOSILogger.debug("REGISTER USER INTEGRATION FLAG is "+REGISTER_USER_INT_FLAG);
			
			String ET_USER_INT_FLAG="";
			ET_USER_INT_FLAG=sXMLParser.getValueOf("ET_USER_INT_FLAG");
			if ("".equalsIgnoreCase(ET_USER_INT_FLAG.trim()))
				ET_USER_INT_FLAG = "";
			TAOSystemIntegrationLog.TAOSILogger.debug("ET USER INTEGRATION FLAG is "+ET_USER_INT_FLAG);
			
			if(!"SUCCESS".equalsIgnoreCase(REGISTER_USER_INT_FLAG))
			{	
					String User_Id="";
					User_Id=sXMLParser.getValueOf("Req_Det_User_Id");
					if ("".equalsIgnoreCase(User_Id.trim()))
						User_Id = "";
					TAOSystemIntegrationLog.TAOSILogger.debug("User Id is "+User_Id);
					
					String RetailCustomerName="";
					RetailCustomerName=sXMLParser.getValueOf("RetailCustomerName").trim();
					TAOSystemIntegrationLog.TAOSILogger.debug("RetailCustomerName is "+RetailCustomerName);
					
					if ("".equalsIgnoreCase(RetailCustomerName.trim()))
						RetailCustomerName = "";
		
					String EmailID="";
					EmailID=sXMLParser.getValueOf("EmailID").trim();
					TAOSystemIntegrationLog.TAOSILogger.debug("EmailID is "+EmailID);
					
					if ("".equalsIgnoreCase(EmailID.trim()))
						EmailID = "";
		
					String CIF_Number="";
					CIF_Number=sXMLParser.getValueOf("CIF_Number").trim();
					TAOSystemIntegrationLog.TAOSILogger.debug("CIF_Number is "+CIF_Number);
		
					String Retail_CIF="";
					Retail_CIF=sXMLParser.getValueOf("Retail_CIF").trim();
					TAOSystemIntegrationLog.TAOSILogger.debug("Retail_CIF --"+Retail_CIF);
					
					String query = "SELECT  Account_Number FROM USR_0_TAO_RequestDetails_GRID with (nolock) where WI_NAME='"+wi_name+"' AND Settlement_Account='Yes'";
					sInputXML =CommonMethods.apSelectWithColumnNames(query, cabinetName, sessionID);
					TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for Apselect from USR_0_TAO_RequestDetails_GRID "+sInputXML);
		
					sOutputXML=TAOSystemIntegration.WFNGExecute(sInputXML, sJtsIp, sJtsPort,1);
					TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for USR_0_TAO_RequestDetails_GRID select "+sOutputXML);
					
					xmlParserData.setXmlString(sOutputXML);
					String Maincode=xmlParserData.getVal("MainCode");
					String accountIds="";
					String RecordCount ="";
					java.util.Date d1 = new Date();
					SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
					String DateExtra2 = sdf1.format(d1)+"+04:00";
					if(Maincode.equalsIgnoreCase("0"))
					{
						RecordCount=xmlParserData.getVal("TotalRetrieved");
						objWorkList = xmlParserData.createList("Records", "Record");
						//TAOSystemIntegrationLog.TAOSILogger.debug("Obj WorkList for getting Account Number from USR_0_TAO_RequestDetails_GRID-- "+objWorkList);
						if(Integer.parseInt(RecordCount)>0)
						{
							for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
							{
								String accNum=objWorkList.getVal("Account_Number");
								accountIds+="<AccountInfo><AccountId>"+accNum+"</AccountId></AccountInfo>\r\n";
							}
							
							
							
							sInputXML = "<EE_EAI_MESSAGE>\r\n" + 
									"	<EE_EAI_HEADER>\r\n" + 
									"		<MsgFormat>REGISTER_USER_PROFILE</MsgFormat>\r\n" + 
									"		<MsgVersion>0001</MsgVersion>\r\n" + 
									"		<RequestorChannelId>BPM</RequestorChannelId>\r\n" + 
									"		<RequestorUserId>RAKUSER</RequestorUserId>\r\n" + 
									"		<RequestorLanguage>E</RequestorLanguage>\r\n" + 
									"		<RequestorSecurityInfo>secure</RequestorSecurityInfo>\r\n" + 
									"		<ReturnCode>911</ReturnCode>\r\n" + 
									"		<ReturnDesc>Issuer Timed Out</ReturnDesc>\r\n" + 
									"		<MessageId>UniqueMessageID123</MessageId>\r\n" + 
									"		<Extra1>REQ||SHELL.JOHN</Extra1>\r\n" + 
									"		<Extra2>"+DateExtra2+"</Extra2>\r\n" + 
									"	</EE_EAI_HEADER>\r\n"
									+ "<RegisterUserProfileReq>\r\n" + 
									"		<UserId>"+User_Id+"</UserId>\r\n" + 
									"		<UserName>"+RetailCustomerName+"</UserName>\r\n" + 
									"		<UserEmailId>"+EmailID+"</UserEmailId>\r\n" + 
									"		<PrimaryCif>"+CIF_Number+"</PrimaryCif>\r\n" + 
									"		<RetailCif>"+Retail_CIF+"</RetailCif>\r\n"  
											+accountIds+ 
									"	</RegisterUserProfileReq\r\n>"
									+ "</EE_EAI_MESSAGE>";
			
							TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for User Registration is "+sInputXML);
			
							try
							{
								TAOSystemIntegrationLog.TAOSILogger.debug("Session Id is "+sessionID);
			
								socketServerIP=socketDetailsMap.get("SocketServerIP");
								TAOSystemIntegrationLog.TAOSILogger.debug("Socket server IP is "+socketServerIP);
			
								socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
								TAOSystemIntegrationLog.TAOSILogger.debug("Socket server port is "+socketServerPort);
			
								if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
								{
									socket=new Socket(socketServerIP,socketServerPort);
									socket.setSoTimeout(socket_connection_timeout*1000);
									out = socket.getOutputStream();
									socketInputStream = socket.getInputStream();
									dout = new DataOutputStream(out);
									din = new DataInputStream(socketInputStream);
			
									TAOSystemIntegrationLog.TAOSILogger.debug("Data output stream is "+dout);
									TAOSystemIntegrationLog.TAOSILogger.debug("Data input stream is "+din);
									outputResponse="";
									inputRequest=getRequestXML(cabinetName, sessionID, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));
			
									TAOSystemIntegrationLog.TAOSILogger.debug("Input MQ XML for Register User is "+inputRequest);
			
									if (inputRequest != null && inputRequest.length() > 0)
									{
										int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
										TAOSystemIntegrationLog.TAOSILogger.debug("RequestLen: "+inputRequestLen + "");
										inputRequest = inputRequestLen + "##8##;" + inputRequest;
										TAOSystemIntegrationLog.TAOSILogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
										dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
									}
									byte[] readBuffer = new byte[500];
									int num = din.read(readBuffer);
			
									if (num > 0)
									{
			
										byte[] arrayBytes = new byte[num];
										System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
										outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
										inputMessageID = outputResponse;
										TAOSystemIntegrationLog.TAOSILogger.debug("OutputResponse: "+outputResponse);
			
										if(!"".equalsIgnoreCase(outputResponse))
											outputResponse = getResponseXML(cabinetName,sJtsIp,sJtsPort,sessionID,
													wi_name,outputResponse,integrationWaitTime );
										if(outputResponse.contains("&lt;"))
										{
											outputResponse=outputResponse.replaceAll("&lt;", "<");
											outputResponse=outputResponse.replaceAll("&gt;", ">");
										}
									}
									socket.close();
			
									outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");
			
									sXMLParser=new XMLParser(outputResponse);
									if(outputResponse.contains("<ReturnDesc>"))
										ReturnDesc=sXMLParser.getValueOf("ReturnDesc");
									if(outputResponse.contains("<Description>"))
										Description=sXMLParser.getValueOf("Description");
									if(outputResponse.contains("<ReturnCode>"))
										ReturnCode=sXMLParser.getValueOf("ReturnCode");
									if(outputResponse.contains("<MessageId>"))
										MessageId=sXMLParser.getValueOf("MessageId");
									if(outputResponse.contains("<MsgFormat>"))
										MsgFormat=sXMLParser.getValueOf("MsgFormat");
									String respDateTime="";
									if(outputResponse.contains("<Extra2>"))
									respDateTime=sXMLParser.getValueOf("Extra2");
									InsertRecordIntoIntegrationTable(wi_name,MsgFormat,DateExtra2,ReturnDesc,MessageId,respDateTime,ReturnCode,Description );
									if("0000".equals(sXMLParser.getValueOf("ReturnCode")))
									{
										
										if(isAllRegistrationSuccess(outputResponse,wi_name))
										{
											UpdateDataInExternalTable(wi_name,"REGISTER_USER_INT_FLAG","SUCCESS");
											REGISTER_USER_INT_FLAG="SUCCESS";
											/*String status=callETUserManagement(wi_name,WorkItemID,socket_connection_timeout,integrationWaitTime,socketDetailsMap);
											
											if("SUCCESS".equalsIgnoreCase(status))
											{
												UpdateDataInExternalTable(wi_name,ET_USER_INT_FLAG,"SUCCESS");
												decision="Success";
											}
											else
											{
												UpdateDataInExternalTable(wi_name,ET_USER_INT_FLAG,"FAIL");
												decision="Failure";
											}*/
										}
										else
										{
											UpdateDataInExternalTable(wi_name,"REGISTER_USER_INT_FLAG","PARTIALSUCCESS");
										}
										//completeWorkItem(cabinetName,sessionID,wi_name,WorkItemID,decision,entryDateTime);
									}
									else
									{
										UpdateDataInExternalTable(wi_name,"REGISTER_USER_INT_FLAG","FAIL");
										
									}
			
									//TAOSystemIntegrationLog.TAOSILogger.debug("Response XML for Register User is "+outputResponse);
			
								}
							}
							catch(Exception e)
							{
								TAOSystemIntegrationLog.TAOSILogger.error("The Exception in CIF creation is "+e.getMessage());
							}
						}
						else if(Integer.parseInt(RecordCount)==0)
						{
							UpdateDataInExternalTable(wi_name,"REGISTER_USER_INT_FLAG","SUCCESS");
							REGISTER_USER_INT_FLAG="SUCCESS";
							InsertRecordIntoIntegrationTable(wi_name,"REGISTER_USER_PROFILE",DateExtra2,"CALL NOT EXECUTED","","","","There is no Account Id to Register!" );
						}
						
					}
					else
					{
						TAOSystemIntegrationLog.TAOSILogger.error("Error in executing Ap_Select API ");
					}
				}
			 if(!"SUCCESS".equalsIgnoreCase(ET_USER_INT_FLAG) && "SUCCESS".equalsIgnoreCase(REGISTER_USER_INT_FLAG))
			{
				String status=callETUserManagement(wi_name,WorkItemID,socket_connection_timeout,integrationWaitTime,socketDetailsMap);
				
				if("SUCCESS".equalsIgnoreCase(status))
				{
					UpdateDataInExternalTable(wi_name,"ET_USER_INT_FLAG","SUCCESS");
					
					ET_USER_INT_FLAG="SUCCESS";
				}
				else
				{
					UpdateDataInExternalTable(wi_name,"ET_USER_INT_FLAG","FAIL");
					
				}
				//completeWorkItem(cabinetName,sessionID,wi_name,WorkItemID,decision,entryDateTime);
			}
			 if("SUCCESS".equalsIgnoreCase(ET_USER_INT_FLAG) && "SUCCESS".equalsIgnoreCase(REGISTER_USER_INT_FLAG))
				{
					 finaldecision="Success";
				}
			 else
				 {
					 finaldecision="Failure";
				 } 
			
			completeWorkItem(cabinetName,sessionID,wi_name,WorkItemID,finaldecision,entryDateTime);
			
		}
		return "";
	}
	public String callETUserManagement(String wi_name,String WorkItemID,int socket_connection_timeout,int integrationWaitTime,
			HashMap<String, String> socketDetailsMap) throws Exception
	{
		String QueryString="SELECT TOP 1 Request_Type,Req_Det_User_Id,RetailCustomerName,CIF_Number,Tier_Group_Name"
				+" FROM RB_TAO_EXTTABLE with (nolock) where WI_NAME='"+wi_name+"'";
		
		String sInputXML =CommonMethods.apSelectWithColumnNames(QueryString, sCabinetName, sSessionId);
		TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for Apselect from Extrenal Table "+sInputXML);

		String sOutputXML=TAOSystemIntegration.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
		TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for extranl Table select "+sOutputXML);

		XMLParser sXMLParser= new XMLParser(sOutputXML);
	    String sMainCode = sXMLParser.getValueOf("MainCode");
	    TAOSystemIntegrationLog.TAOSILogger.debug("SMainCode: "+sMainCode);

	    int sTotalRecords = Integer.parseInt(sXMLParser.getValueOf("TotalRetrieved"));
	    TAOSystemIntegrationLog.TAOSILogger.debug("STotalRecords: "+sTotalRecords);

		if (sMainCode.equals("0") && sTotalRecords > 0)
		{
			TAOSystemIntegrationLog.TAOSILogger.debug("Coming in If Sajan");
			String User_Id="";
			User_Id=sXMLParser.getValueOf("Req_Det_User_Id");
			if ("".equalsIgnoreCase(User_Id.trim()))
				User_Id = "";
			TAOSystemIntegrationLog.TAOSILogger.debug("User Id is "+User_Id);
			
			String RetailCustomerName="";
			RetailCustomerName=sXMLParser.getValueOf("RetailCustomerName").trim();
			TAOSystemIntegrationLog.TAOSILogger.debug("RetailCustomerName is "+RetailCustomerName);
			if ("".equalsIgnoreCase(RetailCustomerName.trim()))
				RetailCustomerName = "";

			String CIF_Number="";
			CIF_Number=sXMLParser.getValueOf("CIF_Number").trim();
			TAOSystemIntegrationLog.TAOSILogger.debug("CIF_Number is "+CIF_Number);

			
			String Request_Type="";
			Request_Type=sXMLParser.getValueOf("Request_Type").trim();
			TAOSystemIntegrationLog.TAOSILogger.debug("Request_Type --"+Request_Type);
			
			String GroupName="";
			GroupName=sXMLParser.getValueOf("Tier_Group_Name").trim();
			TAOSystemIntegrationLog.TAOSILogger.debug("Tier_Group_Name --"+GroupName);
			
			String query = "SELECT  Account_Reference,Currency FROM USR_0_TAO_RequestDetails_GRID with (nolock) where WI_NAME='"+wi_name+"' AND Settlement_Account='Yes' AND Account_Reference is not null";
			sInputXML =CommonMethods.apSelectWithColumnNames(query, sCabinetName, sSessionId);
			TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for Apselect from USR_0_TAO_RequestDetails_GRID "+sInputXML);

			sOutputXML=TAOSystemIntegration.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
			TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for USR_0_TAO_RequestDetails_GRID select "+sOutputXML);
			
			xmlParserData.setXmlString(sOutputXML);
			String Maincode=xmlParserData.getVal("MainCode");
			String settlementsIns="";
			if(Maincode.equalsIgnoreCase("0"))
			{
				objWorkList = xmlParserData.createList("Records", "Record");
				//TAOSystemIntegrationLog.TAOSILogger.debug("Obj WorkList for getting Account Number from USR_0_TAO_RequestDetails_GRID-- "+objWorkList);
				
				for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
				{
					String accRef=objWorkList.getVal("Account_Reference"); // Account Reference was passed instead of account number as part of mail subject - 'War Room - customer onboarding'
					String curr=objWorkList.getVal("Currency");
					settlementsIns+="<SettlementInstructions>\r\n" + 
							"<Default>true</Default>\r\n" + 
							"<InstrumentDetailName>FX.CROSS</InstrumentDetailName>\r\n" + 
							"<InstrumentName>"+curr+"</InstrumentName>\r\n" + 
							"<SettlementInstructionName>"+accRef+"</SettlementInstructionName>\r\n" + 
							"</SettlementInstructions>\r\n";
				}
			}
			
				java.util.Date d1 = new Date();
				SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
				String DateExtra2 = sdf1.format(d1)+"+04:00";
				
				String serviceType="";
				String groupInfo="";
				if("Onboard ET User".equalsIgnoreCase(Request_Type))
				{
					serviceType="New";
					groupInfo=	"<GroupInfo>\r\n" + 
								"<GroupName>"+CIF_Number+"</GroupName>\r\n" + 
								"<GroupLongName>"+GroupName+CIF_Number+"</GroupLongName>\r\n" + 
								"<ParentName>"+GroupName+"</ParentName>\r\n" + 
								"</GroupInfo>\r\n";
					
				}
				else if("Update ET User".equalsIgnoreCase(Request_Type))
				{
					serviceType="Update";
				}
				else
				{
					TAOSystemIntegrationLog.TAOSILogger.debug("Input XML ET User management is --- Not A valid request type! ");
					return "error_Not A valid request type!";
				}
				sInputXML = "<EE_EAI_MESSAGE>\r\n" + 
						"	<EE_EAI_HEADER>\r\n" + 
						"		<MsgFormat>ET_USER_MANAGEMENT</MsgFormat>\r\n" + 
						"		<MsgVersion>0001</MsgVersion>\r\n" + 
						"		<RequestorChannelId>BPM</RequestorChannelId>\r\n" + 
						"		<RequestorUserId>RAKUSER</RequestorUserId>\r\n" + 
						"		<RequestorLanguage>E</RequestorLanguage>\r\n" + 
						"		<RequestorSecurityInfo>secure</RequestorSecurityInfo>\r\n" + 
						"		<ReturnCode>911</ReturnCode>\r\n" + 
						"		<ReturnDesc>Issuer Timed Out</ReturnDesc>\r\n" + 
						"		<MessageId>UniqueMessageID123</MessageId>\r\n" + 
						"		<Extra1>REQ||SHELL.JOHN</Extra1>\r\n" + 
						"		<Extra2>"+DateExtra2+"</Extra2>\r\n" + 
						"	</EE_EAI_HEADER>\r\n" + 
						"	<UserManagementReq>\r\n" + 
						"		<ServiceType>"+serviceType+"</ServiceType>\r\n" + 
									groupInfo+ 
						"		<OnboardUserInfo>\r\n" + 
						"			<AccLongName>"+CIF_Number+"</AccLongName>\r\n" + 
						"			<AccountName>"+CIF_Number+"</AccountName>\r\n" + 
						"			<AccountSettlementInstruction>\r\n" + 
						"				<AccountName>"+CIF_Number+"</AccountName>\r\n" + 
										settlementsIns +
						"			</AccountSettlementInstruction>\r\n" + 
						"			<Description>"+CIF_Number+"</Description> \r\n" +
						"			<ExternalId>"+User_Id+"</ExternalId>\r\n" +
						"			<GroupName>"+CIF_Number+"</GroupName>\r\n" + 
						"			<InternalId>"+CIF_Number+"</InternalId>\r\n" + 
						"			<UserLoginID>"+User_Id+"</UserLoginID>\r\n" + 
						"			<UserLongName>"+RetailCustomerName+"</UserLongName>\r\n" + 
						"		</OnboardUserInfo>\r\n" + 
						"	</UserManagementReq>\r\n" + 
						"</EE_EAI_MESSAGE>";

				TAOSystemIntegrationLog.TAOSILogger.debug("Input XML ET User management is "+sInputXML);

				try
				{
					TAOSystemIntegrationLog.TAOSILogger.debug("Session Id is "+sSessionId);

					socketServerIP=socketDetailsMap.get("SocketServerIP");
					TAOSystemIntegrationLog.TAOSILogger.debug("Socket server IP is "+socketServerIP);

					socketServerPort=Integer.parseInt(socketDetailsMap.get("SocketServerPort"));
					TAOSystemIntegrationLog.TAOSILogger.debug("Socket server port is "+socketServerPort);

					if(!("".equals(socketServerIP)) && socketServerIP!=null && !(socketServerPort==0))
					{
						socket=new Socket(socketServerIP,socketServerPort);
						socket.setSoTimeout(socket_connection_timeout*1000);
						out = socket.getOutputStream();
						socketInputStream = socket.getInputStream();
						dout = new DataOutputStream(out);
						din = new DataInputStream(socketInputStream);

						TAOSystemIntegrationLog.TAOSILogger.debug("Data output stream is "+dout);
						TAOSystemIntegrationLog.TAOSILogger.debug("Data input stream is "+din);
						outputResponse="";
						inputRequest=getRequestXML(sCabinetName, sSessionId, wi_name, ws_name, CommonConnection.getUsername(), new StringBuilder(sInputXML));

						TAOSystemIntegrationLog.TAOSILogger.debug("Input MQ XML for ET User management is "+inputRequest);

						if (inputRequest != null && inputRequest.length() > 0)
						{
							int inputRequestLen = inputRequest.getBytes("UTF-16LE").length;
							TAOSystemIntegrationLog.TAOSILogger.debug("RequestLen: "+inputRequestLen + "");
							inputRequest = inputRequestLen + "##8##;" + inputRequest;
							TAOSystemIntegrationLog.TAOSILogger.debug("InputRequest"+"Input Request Bytes : "+ inputRequest.getBytes("UTF-16LE"));
							dout.write(inputRequest.getBytes("UTF-16LE"));dout.flush();
						}
						byte[] readBuffer = new byte[500];
						int num = din.read(readBuffer);

						if (num > 0)
						{

							byte[] arrayBytes = new byte[num];
							System.arraycopy(readBuffer, 0, arrayBytes, 0, num);
							outputResponse = outputResponse+ new String(arrayBytes, "UTF-16LE");
							inputMessageID = outputResponse;
							TAOSystemIntegrationLog.TAOSILogger.debug("OutputResponse: "+outputResponse);

							if(!"".equalsIgnoreCase(outputResponse))
								outputResponse = getResponseXML(sCabinetName,jtsIP,jtsPort,sSessionId,
										wi_name,outputResponse,integrationWaitTime );
							if(outputResponse.contains("&lt;"))
							{
								outputResponse=outputResponse.replaceAll("&lt;", "<");
								outputResponse=outputResponse.replaceAll("&gt;", ">");
							}
						}
						socket.close();

						outputResponse = outputResponse.replaceAll("</MessageId>","</MessageId>/n<InputMessageId>"+inputMessageID+"</InputMessageId>");
						TAOSystemIntegrationLog.TAOSILogger.debug("Response XML for ET USER MANAGEMENT is "+outputResponse);
						sXMLParser=new XMLParser(outputResponse);
						if(outputResponse.contains("<ReturnDesc>"))
							ReturnDesc=sXMLParser.getValueOf("ReturnDesc");
						if(outputResponse.contains("<Description>"))
							Description=sXMLParser.getValueOf("Description");
						if(outputResponse.contains("<ReturnCode>"))
							ReturnCode=sXMLParser.getValueOf("ReturnCode");
						if(outputResponse.contains("<MessageId>"))
							MessageId=sXMLParser.getValueOf("MessageId");
						if(outputResponse.contains("<MsgFormat>"))
							MsgFormat=sXMLParser.getValueOf("MsgFormat");
						String respDateTime="";
						if(outputResponse.contains("<Extra2>"))
						respDateTime=sXMLParser.getValueOf("Extra2");
						boolean is500ErrorReceived = false;
						//if("500".equalsIgnoreCase(ReturnCode) && ReturnDesc!=null && ReturnDesc.contains("already exists"))
						if("500".equalsIgnoreCase(ReturnCode) && ReturnDesc!=null 
								&& (ReturnDesc.toLowerCase().contains("already exists") || ReturnDesc.toLowerCase().contains("already available") || ReturnDesc.toLowerCase().contains("successfully")) )	
							{
								//ReturnDesc="Successful";
								//ReturnCode="0000";
								is500ErrorReceived = true;
							}
						InsertRecordIntoIntegrationTable(wi_name,MsgFormat,DateExtra2,ReturnDesc,MessageId,respDateTime,ReturnCode,Description );
						if("0000".equals(ReturnCode) || is500ErrorReceived)
						{
							if("0000".equals(ReturnCode))
							{	
								String tmppass = sXMLParser.getValueOf("TmpPassword");
								UpdateDataInExternalTable(wi_name,"TmpPassword",tmppass);
							}
							return "SUCCESS";
						}
						else
						{	
							return "FAIL";
						}
					}
				}
				catch(Exception e)
				{
					TAOSystemIntegrationLog.TAOSILogger.error("The Exception in CIF creation is "+e.getMessage());
				}
			}
		else
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Error in getting workitem Data from DB(Error In APSelect)!");
		}
		return "";
	}
	private boolean isAllRegistrationSuccess(String outputResponse,String wi_name)
	{
			xmlParserData.setXmlString(outputResponse);
			boolean flag=true;
			objWorkList = xmlParserData.createList("RegisterUserProfileResp", "AccountInfo");
			TAOSystemIntegrationLog.TAOSILogger.debug("Obj WorkList for getting Account Number from USR_0_TAO_RequestDetails_GRID-- "+objWorkList);
			String colToBeUpdated="";
			for (; objWorkList.hasMoreElements(true); objWorkList.skip(true))
			{
				String RegistrationStatus=objWorkList.getVal("RegistrationStatus");
				String accId=objWorkList.getVal("AccountId");
				String referenceDesc="";
				if(objWorkList.toString().contains("<RegistrationStatusDesc>"))
				referenceDesc=objWorkList.getVal("RegistrationStatusDesc");
				String referenceNo="";
				if(objWorkList.toString().contains("<RegistrationRefId>"))
					referenceNo=objWorkList.getVal("RegistrationRefId");
				if(!"S".equalsIgnoreCase(RegistrationStatus) && "".equalsIgnoreCase(referenceNo) )
				{
					flag = false;
				}
				
				updateRecordData(RegistrationStatus,accId,referenceDesc,wi_name,referenceNo);
			}
			
			return flag;
	
	}
	public void UpdateDataInExternalTable(String wi_name,String colName,String values)
	{
		try
		{
			String where ="WI_NAME ='"+wi_name+"' ";
			values="'"+values+"'";
			ExecuteQuery_APUpdate("RB_TAO_EXTTABLE",colName,values,where);
			
		}
		catch(Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Exception in Updating Integration Flag - "+e.getMessage());
		}
	}
	private String completeWorkItem(String cabinetName,String sessionID,String processInstanceID,String WorkItemID,String decision,String entryDateTime)
	{
		try
			{
			String getWorkItemInputXML = CommonMethods.getWorkItemInput(cabinetName, sessionID, processInstanceID,WorkItemID);
			String getWorkItemOutputXml = TAOSystemIntegration.WFNGExecute(getWorkItemInputXML,jtsIP,jtsPort,1);
	
			TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for getWorkItem is "+getWorkItemOutputXml);
	
			XMLParser xmlParserGetWorkItem = new XMLParser(getWorkItemOutputXml);
			String getWorkItemMainCode = xmlParserGetWorkItem.getValueOf("MainCode");
	
			if("0".equals(getWorkItemMainCode))
			{
				TAOSystemIntegrationLog.TAOSILogger.info("get Workitem call successfull for "+processInstanceID);
				String attrbuteTag="<Decision>"+decision+"</Decision>";
				String assignWorkitemAttributeInputXML=CommonMethods.assignWorkitemAttributeInput(cabinetName, sessionID,
						processInstanceID,WorkItemID,attrbuteTag);
				TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for assign Attribute is "+assignWorkitemAttributeInputXML);
	
				String assignWorkitemAttributeOutputXML=TAOSystemIntegration.WFNGExecute(assignWorkitemAttributeInputXML,jtsIP,jtsPort,1);
				TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for assign Attribues is "+assignWorkitemAttributeOutputXML);
	
				XMLParser xmlParserAssignAtt=new XMLParser(assignWorkitemAttributeOutputXML);
	
				String mainCodeAssignAtt=xmlParserAssignAtt.getValueOf("MainCode");
				if("0".equals(mainCodeAssignAtt.trim()))
				{
					String completeWorkItemInputXML = CommonMethods.completeWorkItemInput(cabinetName, sessionID,
							processInstanceID,WorkItemID);
	
					TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for complete WI is "+completeWorkItemInputXML);
	
					TAOSystemIntegrationLog.TAOSILogger.debug("Input XML for wmcompleteWorkItem: "+ completeWorkItemInputXML);
	
					String completeWorkItemOutputXML = TAOSystemIntegration.WFNGExecute(completeWorkItemInputXML,jtsIP,jtsPort,1);
					TAOSystemIntegrationLog.TAOSILogger.debug("Output XML for wmcompleteWorkItem: "+ completeWorkItemOutputXML);
	
					XMLParser xmlParserCompleteWorkitem = new XMLParser(completeWorkItemOutputXML);
					String completeWorkitemMaincode = xmlParserCompleteWorkitem.getValueOf("MainCode");
					TAOSystemIntegrationLog.TAOSILogger.debug("Status of wmcompleteWorkItem  "+ completeWorkitemMaincode);
	
					if("0".equals(completeWorkitemMaincode))
					{
						//inserting into history table
						TAOSystemIntegrationLog.TAOSILogger.debug("WmCompleteWorkItem successful: "+completeWorkitemMaincode);
						//System.out.println(processInstanceID + "Complete Sussesfully with status "+objResponseBean.getIntegrationDecision());
	
						TAOSystemIntegrationLog.TAOSILogger.debug("WorkItem moved to next Workstep.");
	
						SimpleDateFormat inputDateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
						SimpleDateFormat outputDateFormat=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
	
						Date entryDatetimeFormat = inputDateformat.parse(entryDateTime);
						String formattedEntryDatetime=outputDateFormat.format(entryDatetimeFormat);
						TAOSystemIntegrationLog.TAOSILogger.debug("FormattedEntryDatetime: "+formattedEntryDatetime);
	
						Date actionDateTime= new Date();
						String formattedActionDateTime=outputDateFormat.format(actionDateTime);
						TAOSystemIntegrationLog.TAOSILogger.debug("FormattedActionDateTime: "+formattedActionDateTime);
	
						//Insert in WIHistory Table.
	
						String columnNames="WI_NAME,ACTION_DATE_TIME,WORKSTEP,USER_NAME,DECISION,ENTRY_DATE_TIME";
						String columnValues="'"+processInstanceID+"','"+formattedActionDateTime+"','"+ws_name+"','"
						+CommonConnection.getUsername()+"','"+decision+"','"+formattedEntryDatetime+"'";
	
						String apInsertInputXML=CommonMethods.apInsert(cabinetName, sessionID, columnNames, columnValues,histTable);
						TAOSystemIntegrationLog.TAOSILogger.debug("APInsertInputXML: "+apInsertInputXML);
	
						String apInsertOutputXML = TAOSystemIntegration.WFNGExecute(apInsertInputXML,jtsIP,jtsPort,1);
						TAOSystemIntegrationLog.TAOSILogger.debug("APInsertOutputXML: "+ apInsertOutputXML);
	
						XMLParser xmlParserAPInsert = new XMLParser(apInsertOutputXML);
						String apInsertMaincode = xmlParserAPInsert.getValueOf("MainCode");
						TAOSystemIntegrationLog.TAOSILogger.debug("Status of apInsertMaincode  "+ apInsertMaincode);
						if(apInsertMaincode.equalsIgnoreCase("0"))
						{
							TAOSystemIntegrationLog.TAOSILogger.debug("ApInsert successful: "+apInsertMaincode);
							TAOSystemIntegrationLog.TAOSILogger.debug("Inserted in WiHistory table successfully.");
						}
						else
						{
							TAOSystemIntegrationLog.TAOSILogger.error("ApInsert failed: "+apInsertMaincode);
						}
					}
					else
					{
						TAOSystemIntegrationLog.TAOSILogger.error("Error in completeWI call for "+processInstanceID);
					}
				}
				else
				{
					TAOSystemIntegrationLog.TAOSILogger.error("Error in Assign Attribute call for WI "+processInstanceID);
				}
	
	
			}
			else
			{
				TAOSystemIntegrationLog.TAOSILogger.error("Error in getWI call for WI "+processInstanceID);
			}
	
		}

		catch(Exception e)
		{
		TAOSystemIntegrationLog.TAOSILogger.error("Exception "+e);
		final Writer result = new StringWriter();
		final PrintWriter printWriter = new PrintWriter(result);
		e.printStackTrace(printWriter);
		TAOSystemIntegrationLog.TAOSILogger.error("Exception Occurred in TAO Integration Thread : "+result);
		System.out.println("Exception "+e);
		
		}
		return "";
}
	
	public void updateRecordData(String status, String accId,String referenceDesc, String wiName,String accRefNo)
	{
		try
		{
			String colName="StatusCode,StatusDescription,Account_Reference";
			String values="'"+status+"','"+referenceDesc+"','"+accRefNo+"'";
			String where ="WI_NAME ='"+wiName+"' AND Account_Number='"+accId+"' ";
			ExecuteQuery_APUpdate("USR_0_TAO_RequestDetails_GRID",colName,values,where);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			TAOSystemIntegrationLog.TAOSILogger.info("Exception in updateRecordData "+e);
		}
		return;
	}
	private void ExecuteQuery_APUpdate(String tablename, String columnname,String strValues, String sWhere) throws ParserConfigurationException, SAXException, IOException
	{
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				XMLParser objXMLParser = new XMLParser();
				String inputXmlcheckAPUpdate =CommonMethods.getAPUpdateIpXML(tablename, columnname, strValues, sWhere, sCabinetName, sSessionId);
				TAOSystemIntegrationLog.TAOSILogger.debug("inputXmlcheckAPUpdate : " + inputXmlcheckAPUpdate);
				String outXmlCheckAPUpdate=null;
				outXmlCheckAPUpdate=TAOSystemIntegration.WFNGExecute(inputXmlcheckAPUpdate, jtsIP, jtsPort, 1);
				TAOSystemIntegrationLog.TAOSILogger.info("outXmlCheckAPUpdate : " + outXmlCheckAPUpdate);
				objXMLParser.setInputXML(outXmlCheckAPUpdate);
				String mainCodeforCheckUpdate = null;
				mainCodeforCheckUpdate=objXMLParser.getValueOf("MainCode");
				if (!mainCodeforCheckUpdate.equalsIgnoreCase("0"))
				{
					TAOSystemIntegrationLog.TAOSILogger.error("Exception in ExecuteQuery_APUpdate updating the table");
				}
				else
				{
					TAOSystemIntegrationLog.TAOSILogger.error("Successfully updated table");
					
				}
				int mainCode=Integer.parseInt(mainCodeforCheckUpdate);
				if (mainCode == 11)
				{
					sSessionId=CommonConnection.getSessionID(TAOSystemIntegrationLog.TAOSILogger, true);
				}
				else
				{
					sessionCheckInt++;
					break;
				}
			}
			catch(Exception e)
			{
				TAOSystemIntegrationLog.TAOSILogger.error("Inside create ExecuteQuery_APUpdate exception"+e);
			}
		}
	}
	public void InsertRecordIntoIntegrationTable(String wiName,String CallName,String reqDateTime,String CallStatus,String messageId,String resDateTime,String retCode,String retErr )throws Exception
	{
		XMLParser objXMLParser = new XMLParser();
		String sInputXML="";
		String sOutputXML="";
		String mainCodeforAPInsert=null;
		sessionCheckInt=0;
		while(sessionCheckInt<loopCount)
		{
			try
			{
				String colName="WI_NAME,Call_Name,Request_Date_Time,Call_Status,MessageId,Response_Date_Time,Return_Code,Return_Error";
                String values="'"+wiName+"','"+CallName+"',getdate(),'"+CallStatus+"','"+messageId+"',getdate(),'"+retCode+"','"+retErr+"'";
				
                TAOSystemIntegrationLog.TAOSILogger.info("Inserted record in Integration table for : "+wiName);
                sInputXML = CommonMethods.apInsert(sCabinetName, sSessionId, colName, values, "USR_0_TAO_INTEGRATION_DTLS");

				TAOSystemIntegrationLog.TAOSILogger.info("Integration_InputXml::::::::::\n"+sInputXML);
				sOutputXML=TAOSystemIntegration.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
				TAOSystemIntegrationLog.TAOSILogger.info("Integration_OutputXml::::::::::\n"+sOutputXML);
				objXMLParser.setInputXML(sOutputXML);
				mainCodeforAPInsert=objXMLParser.getValueOf("MainCode");
			}
			catch(Exception e)
			{
				e.printStackTrace();
				TAOSystemIntegrationLog.TAOSILogger.error("Exception in InsertRecordIntoIntegrationTable-", e);
				sessionCheckInt++;
				waiteloopExecute(waitLoop);
				continue;
			}
			if (mainCodeforAPInsert.equalsIgnoreCase("11")) 
			{
				TAOSystemIntegrationLog.TAOSILogger.info("Invalid session in InsertRecordIntoIntegrationTable");
				sessionCheckInt++;
				
				sSessionId=CommonConnection.getSessionID(TAOSystemIntegrationLog.TAOSILogger, true);
				continue;
			}
			else
			{
				sessionCheckInt++;
				break;
			}
		}
		if(mainCodeforAPInsert.equalsIgnoreCase("0"))
		{
			TAOSystemIntegrationLog.TAOSILogger.info("Insert Successful");
		}
		else
		{
			TAOSystemIntegrationLog.TAOSILogger.info("Insert Unsuccessful");
		}
	}
	public static void waiteloopExecute(long wtime) 
	{
		try 
		{
			for (int i = 0; i < 10; i++) 
			{
				Thread.yield();
				Thread.sleep(wtime / 10);
			}
		} 
		catch (InterruptedException e) 
		{
		}
	}
	private String getRequestXML(String cabinetName, String sessionID,
			String wi_name, String ws_name, String userName, StringBuilder final_XML)
	{
		StringBuffer strBuff = new StringBuffer();
		strBuff.append("<APMQPUTGET_Input>");
		strBuff.append("<SessionId>" + sessionID + "</SessionId>");
		strBuff.append("<EngineName>" + cabinetName + "</EngineName>");
		strBuff.append("<XMLHISTORY_TABLENAME>NG_TAO_XMLLOG_HISTORY</XMLHISTORY_TABLENAME>");
		strBuff.append("<WI_NAME>" + wi_name + "</WI_NAME>");
		strBuff.append("<WS_NAME>" + ws_name + "</WS_NAME>");
		strBuff.append("<USER_NAME>" + userName + "</USER_NAME>");
		strBuff.append("<MQ_REQUEST_XML>");
		strBuff.append(final_XML);
		strBuff.append("</MQ_REQUEST_XML>");
		strBuff.append("</APMQPUTGET_Input>");
		//TAOSystemIntegrationLog.TAOSILogger.debug("GetRequestXML: "+ strBuff.toString());
		return strBuff.toString();
	}

	private String getResponseXML(String cabinetName,String sJtsIp,String iJtsPort, String
			sessionID, String wi_name,String message_ID, int integrationWaitTime)
	{

		String outputResponseXML="";
		try
		{
			String QueryString = "select OUTPUT_XML from NG_TAO_XMLLOG_HISTORY with (nolock) where " +
					"MESSAGE_ID ='"+message_ID+"' and WI_NAME = '"+wi_name+"'";

			String responseInputXML =CommonMethods.apSelectWithColumnNames(QueryString, cabinetName, sessionID);
			TAOSystemIntegrationLog.TAOSILogger.debug("Response APSelect InputXML: "+responseInputXML);

			int Loop_count=0;
			do
			{
				String responseOutputXML=TAOSystemIntegration.WFNGExecute(responseInputXML,sJtsIp,iJtsPort,1);
				TAOSystemIntegrationLog.TAOSILogger.debug("Response APSelect OutputXML: "+responseOutputXML);

			    XMLParser xmlParserSocketDetails= new XMLParser(responseOutputXML);
			    String responseMainCode = xmlParserSocketDetails.getValueOf("MainCode");
			    TAOSystemIntegrationLog.TAOSILogger.debug("ResponseMainCode: "+responseMainCode);

			    int responseTotalRecords = Integer.parseInt(xmlParserSocketDetails.getValueOf("TotalRetrieved"));
			    TAOSystemIntegrationLog.TAOSILogger.debug("ResponseTotalRecords: "+responseTotalRecords);
			    if (responseMainCode.equals("0") && responseTotalRecords > 0)
				{
					String responseXMLData=xmlParserSocketDetails.getNextValueOf("Record");
					responseXMLData =responseXMLData.replaceAll("[ ]+>",">").replaceAll("<[ ]+", "<");

	        		XMLParser xmlParserResponseXMLData = new XMLParser(responseXMLData);

	        		outputResponseXML=xmlParserResponseXMLData.getValueOf("OUTPUT_XML");
	        		//TAOSystemIntegrationLog.TAOSILogger.debug("OutputResponseXML: "+outputResponseXML);

	        		if("".equalsIgnoreCase(outputResponseXML)){
	        			outputResponseXML="Error";
	    			}
	        		break;
				}
			    Loop_count++;
			    Thread.sleep(1000);
			}
			while(Loop_count<integrationWaitTime);

		}
		catch(Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Exception occurred in outputResponseXML" + e.getMessage());
			TAOSystemIntegrationLog.TAOSILogger.error("Exception occurred in outputResponseXML" + e.getStackTrace());
			outputResponseXML="Error";
		}
		return outputResponseXML;
	}


	
	public String formatDate(String inDate, String fromFormat, String ToFormat) {
		SimpleDateFormat inSDF = new SimpleDateFormat(fromFormat); //"mm/dd/yyyy"
		SimpleDateFormat outSDF = new SimpleDateFormat(ToFormat); //"yyyy-MM-dd"

		String outDate = "";
		if (inDate != null) {
			try {
				Date date = inSDF.parse(inDate);
				outDate = outSDF.format(date);
			} catch (ParseException e) {
				System.out.println("Unable to format date: " + inDate + e.getMessage());
				e.printStackTrace();
			}
		}
		return outDate;
  }


	/*public String getInputXMLAccountCreation(String userName,String sessionId,String cabinetName,CustomerBean objCustBean, String sJtsIp, String sJtsPort)
	{
		String inputXML="";
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";
		try{
			TAOSystemIntegrationLog.TAOSILogger.info("Inside getInputXMLAccountCreation ");
			
			String sProdType = objCustBean.getProductType().trim();
			String sProdCurr = objCustBean.getProductCurrency().trim();
			
			if ("".equalsIgnoreCase(sProdType) || "".equalsIgnoreCase(sProdCurr))
			{
				if ("YAP".equalsIgnoreCase(objCustBean.getChannel().trim()))
				{
					sProdType = "YP";
					sProdCurr = "AED";
				}	
			}
			
			String SchemeCode = "";
			String SchemeType = "";
			String CustSubSegment = objCustBean.getCustomerSubSegment().trim();
			try {
				if(!"".equalsIgnoreCase(CustSubSegment))
				{
					TAOSystemIntegrationLog.TAOSILogger.info("Fetching CustSubSegment Scheme Type and Code::"+ objCustBean.getWiName());
					String sqlQuery = "SELECT top 1 SCHEME_CODE,SCHEME_TYPE FROM USR_0_RAOP_CUSTOMER_SUBSEGMENT WITH(NOLOCK) WHERE SUBSEGMENT_CODE = '"+CustSubSegment+"' AND ISACTIVE='Y'";
					String InputXML = CommonMethods.apSelectWithColumnNames(sqlQuery, cabinetName, sessionId);
					TAOSystemIntegrationLog.TAOSILogger.info("Workitem "+ objCustBean.getWiName() + "InputXml For CustSubSegment Scheme Type and Code "+InputXML);
					String outputXML = TAOSystemIntegration.WFNGExecute(InputXML, sJtsIp,sJtsPort, 1);
					TAOSystemIntegrationLog.TAOSILogger.info("Workitem "+ objCustBean.getWiName() + "OutputXML for CustSubSegment Scheme Type and Code  "+outputXML);

					XMLParser xmlParser=new XMLParser();
					xmlParser.setInputXML(outputXML);
					String mainCode =xmlParser.getValueOf("MainCode");
					
					if("0".equals(mainCode))
					{
						int countofrecords = Integer.parseInt(xmlParser.getValueOf("TotalRetrieved"));
						TAOSystemIntegrationLog.TAOSILogger.info("Workitem "+ objCustBean.getWiName() + "Total No Of CustSubSegment Scheme Type and Code "+countofrecords);
						for(int j=0; j<countofrecords; j++)
						{
							String subXML = xmlParser.getNextValueOf("Record");
							XMLParser objXmlParser = new XMLParser(subXML);
							SchemeCode = objXmlParser.getValueOf("SCHEME_CODE");
							SchemeType = objXmlParser.getValueOf("SCHEME_TYPE");
						}
					}
					
				}
			}catch(Exception e)
			{
				TAOSystemIntegrationLog.TAOSILogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting CustSubSegment Scheme Type and Code"+ e.getMessage());
				e.printStackTrace();
			}
			
			inputXML = "<EE_EAI_MESSAGE>\n" +
					"<EE_EAI_HEADER>\n"+
						"<MsgFormat>NEW_ACCOUNT_REQ</MsgFormat>\n" +
						"<MsgVersion>001</MsgVersion>\n" +
						"<RequestorChannelId>BPM</RequestorChannelId>\n" +
						"<RequestorUserId>RAKUSER</RequestorUserId>\n" +
						"<RequestorLanguage>E</RequestorLanguage>\n" +
						"<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n" +
						"<ReturnCode>911</ReturnCode>\n" +
						"<ReturnDesc>Issuer Timed Out</ReturnDesc>\n" +
						"<MessageId>testacc001</MessageId>\n" +
						"<Extra1>REQ||SHELL.dfgJOHN</Extra1>\n" +
						"<Extra2>"+DateExtra2+"</Extra2>\n" +
					"</EE_EAI_HEADER>\n"+
					"<AccountRequest>\n"+
						"<BankId>RAK</BankId>\n"+
						"<BranchId>"+objCustBean.getSolId()+"</BranchId>\n"+
						"<CustomerId>"+objCustBean.getCifId()+"</CustomerId>\n"+
						"<IBANNumber>"+objCustBean.getIBANNO()+"</IBANNumber>\n"+
						"<AcRequired>"+sProdType+"</AcRequired>\n"+
						"<CurrencyCode>"+sProdCurr+"</CurrencyCode>\n"+
						"<ChannelId>YAP</ChannelId>\n"+
						"<DebitCardRequired>N</DebitCardRequired>\n"+
						"<JointAccInd>N</JointAccInd>\n"+
						"<ActiveAcctInd>Y</ActiveAcctInd>\n"+
						"<SchemeType>"+SchemeType+"</SchemeType>\n"+
						"<SchemeCode>"+SchemeCode+"</SchemeCode>\n"+
						"<Action>A</Action>\n"+
					"</AccountRequest>\n"+
					"</EE_EAI_MESSAGE>";

		}
		catch(Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.info("workitem "+objCustBean.getWiName()+" exception caught in getting inputxml Account creation"+ e.getMessage());
			e.printStackTrace();
		}
		return inputXML;
	}*/

	
	public String GetDocumentsList(String itemindex , String sessionId,String cabinetName,String jtsIP,String jtsPort)
	{
		TAOSystemIntegrationLog.TAOSILogger.info("Inside GetDocumentsList Method ...");
		XMLParser docXmlParser = new XMLParser();
		String mainCode="";
		String response="F";
		String outputXML ="";
		try
		{

			String sInputXML = getDocumentList(itemindex, sessionId, cabinetName);
			TAOSystemIntegrationLog.TAOSILogger.debug(" Inputxml to get document names for "+itemindex+ " "+sInputXML);

			outputXML = TAOSystemIntegration.WFNGExecute(sInputXML, jtsIP, jtsPort,1);
			TAOSystemIntegrationLog.TAOSILogger.debug(" outputxml to get document names for "+ itemindex+ " "+outputXML);
			docXmlParser.setInputXML(outputXML);
			mainCode = docXmlParser.getValueOf("Status");

			if(mainCode.equals("0"))
			{
				response=outputXML;
			}

		}
		catch (Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Exception occured in GetDocumentsList method : "+e);

			response ="F";
			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
		}
		return response;

	}

	public String getDocumentList(String folderIndex, String sessionId, String cabinetName)
	{

		//folderIndex="26979";   //only for testing

		String xml = "<?xml version=\"1.0\"?><NGOGetDocumentListExt_Input>" +
				"<Option>NGOGetDocumentListExt</Option>" +
				"<CabinetName>"+cabinetName+"</CabinetName>" +
				"<UserDBId>"+sessionId+"</UserDBId>" +
				"<CurrentDateTime></CurrentDateTime>" +
				"<FolderIndex>"+folderIndex+"</FolderIndex>" +
				"<DocumentIndex></DocumentIndex>" +
				"<PreviousIndex>0</PreviousIndex>" +
				"<LastSortField></LastSortField>" +
				"<StartPos>0</StartPos>" +
				"<NoOfRecordsToFetch>1000</NoOfRecordsToFetch>" +
				"<OrderBy>5</OrderBy><SortOrder>A</SortOrder><DataAlsoFlag>N</DataAlsoFlag>" +
				"<AnnotationFlag>Y</AnnotationFlag><LinkDocFlag>Y</LinkDocFlag>" +
				"<PreviousRefIndex>0</PreviousRefIndex><LastRefField></LastRefField>" +
				"<RefOrderBy>2</RefOrderBy><RefSortOrder>A</RefSortOrder>" +
				"<NoOfReferenceToFetch>1000</NoOfReferenceToFetch>" +
				"<DocumentType>B</DocumentType>" +
				"<RecursiveFlag>N</RecursiveFlag><ThumbnailAlsoFlag>N</ThumbnailAlsoFlag>" +
				"</NGOGetDocumentListExt_Input>";

		return xml;
	}

	public String DownloadDocument(XMLParser xmlParser,String winame,String docName,String docExt, String account_no,String cabinetName,String jtsIp,String smsPort,String docDownloadPath,String volumeId,String siteId)
	{
		TAOSystemIntegrationLog.TAOSILogger.debug("Inside DownloadDocument Method...");

		String status="F";
		String msg="Error";
		StringBuffer strFilePath = new StringBuffer();
		try
		{

			String base64String = null;
			String imageIndex = xmlParser.getValueOf("ISIndex").substring(0, xmlParser.getValueOf("ISIndex").indexOf("#"));

			strFilePath.append(System.getProperty("user.dir"));
			strFilePath.append(File.separator);
			strFilePath.append(strDocDownloadPath);
			strFilePath.append(File.separatorChar);
			strFilePath.append(winame);
			strFilePath.append("_");
			strFilePath.append(docName);
			strFilePath.append(".");
			strFilePath.append(docExt);

			CImageServer cImageServer=null;
			try
			{
				cImageServer = new CImageServer(null, jtsIp, Short.parseShort(smsPort));
			}
			catch (JPISException e)
			{
				e.printStackTrace();
				msg = e.getMessage();
				status="F";
			}
			TAOSystemIntegrationLog.TAOSILogger.debug("values passed -> "+ jtsIp+" "+smsPort+" "+cabinetName+" "+volumeId+" "+siteId+" "+imageIndex+" "+strFilePath.toString());
			TAOSystemIntegrationLog.TAOSILogger.debug("signature document name and imageindex for "+winame+" "+docName+","+imageIndex);

			TAOSystemIntegrationLog.TAOSILogger.debug("Fetching OD Download Code ::::::");
			int odDownloadCode=cImageServer.JPISGetDocInFile_MT(null,jtsIp, Short.parseShort(smsPort), cabinetName, Short.parseShort(siteId),Short.parseShort(volumeId), Integer.parseInt(imageIndex),"",strFilePath.toString(),new JPDBString());

			TAOSystemIntegrationLog.TAOSILogger.debug("OD Download Code :"+odDownloadCode);
			TAOSystemIntegrationLog.TAOSILogger.debug("strFilePath.toString() :"+strFilePath.toString());

			if(odDownloadCode==1)
			{
				try
				{
					base64String=ConvertToBase64.convertToBase64((strFilePath.toString()).trim());
					//TAOSystemIntegrationLog.TAOSILogger.debug("base64String -----" +base64String);
					deleteDownloadedSignature(strFilePath.toString().trim());
					status=base64String;

				}
				catch(Exception e)
				{
					TAOSystemIntegrationLog.TAOSILogger.debug("Exception in converting image to Base64 for "+ winame+" "+docName+","+imageIndex);

					msg=e.getMessage();
					status="F";
				}

			}
			else
			{
				TAOSystemIntegrationLog.TAOSILogger.debug("Error in downloading document for "+ winame+" docname "+docName+", imageindex "+imageIndex);

				msg="Error occured while downloading the document :"+docName;
				status="F";
			}
		}
		catch (Exception e)
		{
			TAOSystemIntegrationLog.TAOSILogger.error("Exception occured in DownloadDocument method : "+e);

			final Writer result = new StringWriter();
			final PrintWriter printWriter = new PrintWriter(result);
			e.printStackTrace(printWriter);
			msg=e.getMessage();
			status="F";
		}

		return status;

	}

	public void deleteDownloadedSignature(String path)
	{
		File file = new File(path);
        if(file.delete()){
            TAOSystemIntegrationLog.TAOSILogger.debug("Downloaded Signture file has been deleted");
        }
        else
        {
        	TAOSystemIntegrationLog.TAOSILogger.error("Error in deleting the downloaded signature");
        }

	}

	public String getSignatureUploadXML(String base64String,String ACCNO,String CIFID,String DATE, String CustomerName,String userName, String sessionId, String cabinetName, String Sig_Remarks)
	{
		java.util.Date d1 = new Date();
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.mmm");
		String DateExtra2 = sdf1.format(d1)+"+04:00";
		
		String integrationXML = "<EE_EAI_MESSAGE>" +
			   "<EE_EAI_HEADER>" +
				  "<MsgFormat>SIGNATURE_ADDITION_REQ</MsgFormat>" +
				  "<MsgVersion>0001</MsgVersion>" +
				  "<RequestorChannelId>BPM</RequestorChannelId>" +
				  "<RequestorUserId>RAKUSER</RequestorUserId>" +
				  "<RequestorLanguage>E</RequestorLanguage>" +
				  "<RequestorSecurityInfo>secure</RequestorSecurityInfo>" +
				  "<ReturnCode>911</ReturnCode>" +
				  "<ReturnDesc>Issuer Timed Out</ReturnDesc>" +
				  "<MessageId>UniqueMessageId123</MessageId>" +
				  "<Extra1>REQ||SHELL.JOHN</Extra1>" +
				  "<Extra2>"+DateExtra2+"</Extra2>" +
			   "</EE_EAI_HEADER>" +
			   "<SignatureAddReq>" +
				  "<BankId>RAK</BankId>" +
				  "<AcctId>"+ACCNO+"</AcctId>" +
				  "<AccType>N</AccType>" +
				  "<CustId>"+CIFID+"</CustId>" +
				  "<BankCode></BankCode>" +
				  "<EmpId></EmpId>" +
				  "<CustomerName>"+CustomerName+"</CustomerName>" +
				  "<SignPowerNumber></SignPowerNumber>" +
				  "<ImageAccessCode>1</ImageAccessCode>" +
				  "<SignExpDate>2112-03-06T23:59:59.000</SignExpDate>" +
				  "<SignEffDate>2010-12-31T23:59:59.000</SignEffDate>" +
				  "<SignFile>"+base64String+"</SignFile>" +
				  "<PictureExpDate>2099-12-31T23:59:59.000</PictureExpDate>" +
				  "<PictureEffDate>2010-12-31T23:59:59.000</PictureEffDate>" +
				  "<PictureFile></PictureFile>" +
				  "<SignGroupId>SVSB11</SignGroupId>" +
				  "<Remarks>"+Sig_Remarks+"</Remarks>" +
			   "</SignatureAddReq>" +
			"</EE_EAI_MESSAGE>";


		return integrationXML;
	}

	public String calculateKYCReviewDate(String rscore)
	{
		String ExpDate = "";
		try 
		{
			if (!rscore.contains("."))
				rscore = rscore+".00";
			double riskscore = Float.parseFloat(rscore);
			String risktype = "";
			
			java.util.Date d1 = new Date();
			SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
			String currDate = sdf1.format(d1);
			if (riskscore >= 1 && riskscore < 2 )
	        {
	          risktype = "Low";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(3);
	          ExpDate = addedDate.toString();
	          TAOSystemIntegrationLog.TAOSILogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 2 && riskscore < 3)
	        {
	          risktype = "Standard";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(2);
	          ExpDate = addedDate.toString();
	          TAOSystemIntegrationLog.TAOSILogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 3 && riskscore < 4)
	        {
	          risktype = "Medium";
	          LocalDate addedDate = LocalDate.parse(currDate).plusMonths(18);
	          ExpDate = addedDate.toString();
	          TAOSystemIntegrationLog.TAOSILogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 4 && riskscore < 5)
	        {
	          risktype = "High";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(1);
	          ExpDate = addedDate.toString();
	          TAOSystemIntegrationLog.TAOSILogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
			else if(riskscore >= 5)
	        {
	          risktype = "Elevated";
	          LocalDate addedDate = LocalDate.parse(currDate).plusYears(1);
	          ExpDate = addedDate.toString();
	          TAOSystemIntegrationLog.TAOSILogger.debug("risktype : "+risktype+", WSNAME: "+ExpDate);
	        }
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		return ExpDate;
	}
	


}
