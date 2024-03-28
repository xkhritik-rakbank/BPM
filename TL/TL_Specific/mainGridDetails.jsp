<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@page language="java" session="true" %>


<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<!--<jsp:useBean id="wfsession"	class="com.newgen.wfdesktop.session.WFSession" scope="session" />--->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%!
	public String getInputXML(String CIFID,String ACCOUNTNUMBER,String username,String sessionId,String engineName)
	{
		if(!(ACCOUNTNUMBER.equalsIgnoreCase("") || ACCOUNTNUMBER.equalsIgnoreCase("NULL")))
		{
			return"<?xml version=\"1.0\"?>"
					+ "<BPM_APMQPutGetMessage_Input>\n"+
					"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+username+"</UserID>\n" +
					"<SessionId>"+sessionId+"</SessionId>\n"+
					"<EngineName>"+engineName+"</EngineName>\n" +
					"<RequestMessage><EE_EAI_MESSAGE>\n"+
					"<ProcessName>TL</ProcessName>\n" +
				   "<EE_EAI_HEADER>\n"+
				      "<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				      "<MsgVersion>0001</MsgVersion>\n"+
				      "<RequestorChannelId>BPM</RequestorChannelId>\n"+
				      "<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				      "<RequestorLanguage>E</RequestorLanguage>\n"+
				      "<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				      "<ReturnCode>0000</ReturnCode>\n"+
				      "<ReturnDesc>saddd</ReturnDesc>\n"+
				      "<MessageId>A2503006</MessageId>\n"+
				      "<Extra1>REQ||BPM.123</Extra1>\n"+
				      "<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>\n"+
				   "</EE_EAI_HEADER>\n"+
				   "<CustomerDetails>\n"+
				     "<BankId>RAK</BankId>\n"+
				     "<CIFID>"+CIFID+"</CIFID>\n"+
					 "<ACCType>A</ACCType>\n"+
				     "<ACCNumber>"+ACCOUNTNUMBER+"</ACCNumber>\n"+
				     "<InquiryType>CustomerAndAccount</InquiryType>\n"+
				     "<FreeField1/>\n"+
				     "<FreeField2/>\n"+
				     "<FreeField3/>\n"+
				  "</CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";
		}
		else{
				return"<?xml version=\"1.0\"?>"
					+ "<BPM_APMQPutGetMessage_Input>\n"+
					"<Option>BPM_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+username+"</UserID>\n" +
					"<SessionId>"+sessionId+"</SessionId>\n"+
					"<EngineName>"+engineName+"</EngineName>\n" +
					"<RequestMessage><EE_EAI_MESSAGE>\n"+
					"<ProcessName>TL</ProcessName>\n" +
				   "<EE_EAI_HEADER>\n"+
				      "<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				      "<MsgVersion>0001</MsgVersion>\n"+
				      "<RequestorChannelId>BPM</RequestorChannelId>\n"+
				      "<RequestorUserId>BPMUSER</RequestorUserId>\n"+
				      "<RequestorLanguage>E</RequestorLanguage>\n"+
				      "<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				      "<ReturnCode>0000</ReturnCode>\n"+
				      "<ReturnDesc>saddd</ReturnDesc>\n"+
				      "<MessageId>A2503006</MessageId>\n"+
				      "<Extra1>REQ||BPM.123</Extra1>\n"+
				      "<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>\n"+
				   "</EE_EAI_HEADER>\n"+
				   "<CustomerDetails>\n"+
				     "<BankId>RAK</BankId>\n"+
				     "<CIFID>"+CIFID+"</CIFID>\n"+
				     "<ACCNumber>"+ACCOUNTNUMBER+"</ACCNumber>\n"+
				     "<InquiryType>CustomerAndAccount</InquiryType>\n"+
				     "<FreeField1/>\n"+
				     "<FreeField2/>\n"+
				     "<FreeField3/>\n"+
				  "</CustomerDetails>\n"+
				"</EE_EAI_MESSAGE></RequestMessage>\n" +				
			"</BPM_APMQPutGetMessage_Input>";
				
			}
		
	}
	public String getOutputXML(String inputXML)
	{
		return "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>\n"+
			"<EE_EAI_MESSAGE>\n"+
			   "<EE_EAI_HEADER>\n"+
				  "<MsgFormat>ENTITY_DETAILS</MsgFormat>\n"+
				  "<MsgVersion>0001</MsgVersion>\n"+
				  "<RequestorChannelId>BPM</RequestorChannelId>\n"+
				  "<RequestorUserId>RAKUSER</RequestorUserId>\n"+
				  "<RequestorLanguage>E</RequestorLanguage>\n"+
				  "<RequestorSecurityInfo>secure</RequestorSecurityInfo>\n"+
				  "<ReturnCode>000</ReturnCode>\n"+
				  "<ReturnDesc>Success</ReturnDesc>\n"+
				  "<MessageId>123123453</MessageId>\n"+
				  "<Extra1>REP||SHELL.JOHN</Extra1>\n"+
				  "<Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2>\n"+
			   "</EE_EAI_HEADER>\n"+
			   "<CustomerDetails>\n"+
				  "<BankId>RAK</BankId>\n"+
				  "<CIFID>1000001</CIFID>\n"+
				  "<ACCNumber>1234567</ACCNumber>\n"+
				  "<AccountStatus>F</AccountStatus>\n"+
				  "<AccountCategory>SINGLY</AccountCategory>\n"+
				  "<JointAccIndicator>N</JointAccIndicator>\n"+
				  "<SchemeCode>ALAP1</SchemeCode>\n"+
				  "<SchemeType>ODA</SchemeType>\n"+
				  "<PrimaryContactName>XXXX</PrimaryContactName>\n"+
				  "<PrimaryContactNum>098988525</PrimaryContactNum>\n"+
				  "<SecondaryContactName>YYYYY</SecondaryContactName>\n"+
				  "<SecondaryContactNum>09898989</SecondaryContactNum>\n"+
				  "<ECRNumber>1234567dhfggj56</ECRNumber>\n"+
				  "<FirstName>EQN</FirstName>\n"+
				  "<MiddleName>EQ12345</MiddleName>\n"+
				  "<LastName>asjdguj</LastName>\n"+
				  "<FullName>Newgen Software</FullName>\n"+
				  "<MothersName>fsjhjf</MothersName>\n"+
				  "<DOB>1964-10-11</DOB>\n"+
				  "<Gender>M</Gender>\n"+
				  "<Nationality>IND</Nationality>\n"+
				  "<IsPremium>Y</IsPremium>\n"+
				  "<ARMName>PBD</ARMName>\n"+
				  "<ARMPhone>Y</ARMPhone>\n"+
				  "<ARMCode>Y</ARMCode>\n"+
				  "<CustomerType>CFN</CustomerType>\n"+
				  "<CustomerSegment>SME</CustomerSegment>\n"+
				  "<CustomerSubSeg>SME</CustomerSubSeg>\n"+
				  "<AcctCurr>AED</AcctCurr>\n"+
				  "<IBANNumber>AE*****************1</IBANNumber>\n"+
				  "<CustStatus>ACTIVE</CustStatus>\n"+
				  "<IsRetailCust>N</IsRetailCust>\n"+
				  "<AddrDet>\n"+
					 "<AddressType>OFFICE</AddressType>\n"+
					 "<HoldMailFlag>N</HoldMailFlag>\n"+
					 "<HoldMailBCName>bbbbbb</HoldMailBCName>\n"+
					 "<HoldMailReason>xxxxxxx</HoldMailReason>\n"+
					 "<ReturnFlag>N</ReturnFlag>\n"+
					 "<AddrPrefFlag>Y</AddrPrefFlag>\n"+
					 "<AddrLine1>12345</AddrLine1>\n"+
					 "<AddrLine2>PREMISE NAME FOR 0326407</AddrLine2>\n"+
					 "<AddrLine3>STREET NAME FOR 0326407</AddrLine3>\n"+
					 "<AddrLine4>Addr line 4</AddrLine4>\n"+
					 "<POBox>12346</POBox>\n"+
					 "<City>DXB</City>\n"+
					 "<Country>AE</Country>\n"+
				  "</AddrDet>\n"+
				  "<PhnDet>\n"+
					 "<PhnType>OFFCPH1</PhnType>\n"+
					 "<PhnPrefFlag>N</PhnPrefFlag>\n"+
					 "<PhnCountryCode>00971</PhnCountryCode>\n"+
					 "<PhnLocalCode>420326407</PhnLocalCode>\n"+
					 "<PhoneNo>0097XXXX6407</PhoneNo>\n"+
				  "</PhnDet>\n"+
				  "<EmailDet>\n"+
					 "<MailIdType>ELML1</MailIdType>\n"+
					 "<MailPrefFlag>Y</MailPrefFlag>\n"+
					 "<EmailID>abcd@dfg.com</EmailID>\n"+
				  "</EmailDet>\n"+
				  "<DocumentDet>\n"+
					 "<DocType>Passport</DocType>\n"+
					 "<DocId>sf57Y</DocId>\n"+
					 "<DocExpDt>1964-10-11</DocExpDt>\n"+
					 "<DocIssDate>1964-10-11</DocIssDate>\n"+
					 "<IsDocVerified>Y</IsDocVerified>\n"+
					 "<IssuedOrganisation>DU</IssuedOrganisation>\n"+
				  "</DocumentDet>\n"+
				  "<DocumentDet>\n"+
					 "<DocType>TradeLicense</DocType>\n"+
					 "<DocId>TL-1001</DocId>\n"+
					 "<DocExpDt>1964-10-11</DocExpDt>\n"+
					 "<DocIssDate>1964-10-11</DocIssDate>\n"+
					 "<IsDocVerified>Y</IsDocVerified>\n"+
					 "<IssuedOrganisation>DU</IssuedOrganisation>\n"+
				  "</DocumentDet>\n"+
				   "<RelatedCIF>\n"+
						"<CIFID>1170542</CIFID>\n"+
						"<CustomerType>EBY</CustomerType>\n"+
						"<CustomerSegment>PBD</CustomerSegment>\n"+
						"<CustomerSubSeg>PBN</CustomerSubSeg>\n"+
						"<CustomerName>DIANE ELIZABETH GREASLEY</CustomerName>\n"+
						"<CustomerCategory>PBN</CustomerCategory>\n"+
						"<CustomerStatus>ACTVE</CustomerStatus>\n"+
						"<CustomerMobileNumber>00971501170581</CustomerMobileNumber>\n"+
						"<AddressLine1>12345</AddressLine1>\n"+
						"<AddressLine2></AddressLine2>\n"+
						"<AddressLine3></AddressLine3>\n"+
						"<AddressLine4></AddressLine4>\n"+
						"<AddressLine5></AddressLine5>\n"+
						"<BuildingLevel></BuildingLevel>\n"+
						"<StreetNum></StreetNum>\n"+
						"<StreetType></StreetType>\n"+
						"<CityCode></CityCode>\n"+
						"<State>DXB</State>\n"+
						"<CountryCode>AE</CountryCode>\n"+
						 "<IsRetailCust>N</IsRetailCust>\n"+
						"<PrimaryEmailId>1170581.1170581@RAKBANK.AE</PrimaryEmailId>\n"+
						"<Fax></Fax>\n"+
						"<DOB>1960-03-30</DOB>\n"+
						"<Nationality>CA</Nationality>\n"+
						"<PassportNum>H1940785</PassportNum>\n"+
						"<MotherMaidenName>MOTHER</MotherMaidenName>\n"+
						"<LinkedDebitCardNumber>4343253253453245</LinkedDebitCardNumber>\n"+
						"<FinacleRelation>Y</FinacleRelation>\n"+
						"<IsMinor>N</IsMinor>\n"+
						"<IsStaff>N</IsStaff>\n"+
						"<IsNRE></IsNRE>\n"+
				   "</RelatedCIF>\n"+
				  "<FreeField1/>\n"+
				  "<FreeField2/>\n"+
				  "<FreeField3/>\n"+
				  "<FreeField4/>\n"+
				  "<FreeField5/>\n"+
				  "<FreeField6/>\n"+
				  "<FreeField7/>\n"+   
			"</CustomerDetails>\n"+
		"</EE_EAI_MESSAGE>\n";

	}
%>

<%

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_num"), 1000, true) );
			String cif_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("cif_num Request.getparameter---> "+request.getParameter("cif_num"));
			WriteLog("cif_num Esapi---> "+cif_num_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("acc_no"), 1000, true) );
			String acc_no_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("acc_no Request.getparameter---> "+request.getParameter("acc_no"));
			WriteLog("acc_no Esapi---> "+acc_no_Esapi);

	String sOutPutXML = "";
	String sInputXML = "";
	String val_main = "";	
	String temp_table="";
	String appendStr = "";
	int	 row = 1;
	try
	{
		String sJtsIp = null;
		int iJtsPort = 0;
		String CIFID = cif_num_Esapi;
		String ACCOUNTNUMBER = acc_no_Esapi;
		
		//sJtsIp = wfsession.getJtsIp();
		sJtsIp =   wDSession.getM_objCabinetInfo().getM_strServerIP();
		//iJtsPort = wfsession.getJtsPort();
		iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
		
		//String username=wfsession.getUserName();
		String username=wDSession.getM_objUserInfo().getM_strUserName();
	//	String sessionId=wfsession.getSessionId();
		String sessionId=wDSession.getM_objUserInfo().getM_strSessionId();
		//String engineName=wfsession.getEngineName();
		String engineName= wDSession.getM_objCabinetInfo().getM_strCabinetName();
				
		sInputXML = getInputXML(CIFID,ACCOUNTNUMBER,username,sessionId,engineName);
		WriteLog(sInputXML);
		//sOutPutXML=WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1); //To be uncommented on SIT/UAT
		sOutPutXML=NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog(sOutPutXML);
		//sOutPutXML =getOutputXML(sInputXML); //To be commented on SIT/UAT
		
		//  Start : Grid
		
		String valRadio="row"+row+"_individual";	
			
					
			String sMappOutPutXML = sOutPutXML;
			
			String rowVal="";
			String individual = "";
			
			String Mainindividual = "";
			String MainCIFID = "";
			if (sMappOutPutXML.contains("<CIFID>"))
				MainCIFID = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<CIFID>")+"</CIFID>".length()-1,sMappOutPutXML.indexOf("</CIFID>"));
			
			String MainCIFType = "";
			
			String MainFullName="";
			if (sMappOutPutXML.contains("<FullName>"))
				MainFullName = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<FullName>")+"</FullName>".length()-1,sMappOutPutXML.indexOf("</FullName>"));
			
			String tempStr = "";
			if (sMappOutPutXML.contains("<IsRetailCust>"))
				tempStr=sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
			
				if("N".equals(tempStr))
					Mainindividual = "Corporate";
				else
					Mainindividual = "Retail";
		
			String MainRadio = "<td><input type='radio' name='individual' value="+"'"+MainCIFID+"'"+" id="+"'"+valRadio+"'"+" onclick='javascript:showDivForGrid(this);'></td>";
			temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'>"+MainRadio+"<td>"+MainCIFID+"</td><td>"+MainFullName+"</td><td>"+Mainindividual+"</td></tr>";
	
			
			val_main = val_main + valRadio+"#"+MainCIFID+"#"+Mainindividual+"#"+MainFullName+"~";
			
			if(sMappOutPutXML.contains("<RelatedCIF>"))
			{
				if (sMappOutPutXML.contains("<IsRetailCust>"))
					MainCIFType = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,sMappOutPutXML.indexOf("</IsRetailCust>"));
				if("N".equals(MainCIFType))
					MainCIFType = "Corporate";
				else
					MainCIFType = "Retail";
			}
			while(sMappOutPutXML.contains("<RelatedCIF>"))
			{	
				row++;
				valRadio="row"+row+"_individual";	
				rowVal = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<RelatedCIF>"),sMappOutPutXML.indexOf("</RelatedCIF>")+"</RelatedCIF>".length());
				
				if (rowVal.contains("<IsRetailCust>"))
					individual = rowVal.substring(rowVal.indexOf("<IsRetailCust>")+"</IsRetailCust>".length()-1,rowVal.indexOf("</IsRetailCust>"));
				if("N".equals(individual))
					individual = "Corporate";
				else
					individual = "Retail";
					
				if (rowVal.contains("<CIFID>"))	
					CIFID = rowVal.substring(rowVal.indexOf("<CIFID>")+"<CIFID>".length(),rowVal.indexOf("</CIFID>"));
				
				String b = "<td><input type='radio' name='individual' value="+"'"+CIFID+"'"+" id="+"'"+valRadio+"'"+" onclick='javascript:showDivForGrid(this);'></td>";
				
				String cust_name = "";
				if (rowVal.contains("<CustomerName>"))	
					cust_name = rowVal.substring(rowVal.indexOf("<CustomerName>")+"<CustomerName>".length(),rowVal.indexOf("</CustomerName>"));

				temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'>"+b+"<td>"+CIFID+"</td><td>"+cust_name+"</td><td>"+individual+"</td></tr>";
				
				val_main = val_main + valRadio+"#"+CIFID+"#"+individual+"#"+cust_name+"~";
				
				sMappOutPutXML = sMappOutPutXML.replaceAll(rowVal, "");
				
				//WriteLog(sMappOutPutXML);
				
			//  Ends : Grid
			WriteLog("Main Value : "+val_main);
			
			
			
			//out.clear();
			//out.println(appendStr+temp_table+"</table>"+"^^^"+val_main);
			WriteLog("Table ______________-----------------"+appendStr+temp_table+"</table>"+val_main);

			}
		appendStr = "<table id='TL_mainGrid' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th>Select</th><th>CIF Number</th><th>Name</th><th>CIF Type</th></tr>";
		WriteLog(sOutPutXML);								
	}
	catch(Exception e)
	{
		e.printStackTrace();
		sOutPutXML="Exception"+((e.getMessage()==null)?"NULL":e.getMessage());
	}
	WriteLog("Final Value : "+appendStr+temp_table+"</table>"+"^^^"+val_main);
	out.clear();
	out.println(appendStr+temp_table+"</table>"+"^^^"+val_main);
%>