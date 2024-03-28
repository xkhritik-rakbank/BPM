<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : SRM.jsp
//Author                     : Deepti Sharma
// Date written (DD/MM/YYYY) : 29-Mar-2014
//Description                : File to insert/update data in Transaction table
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@ page import="com.newgen.wfdesktop.util.*"%>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*"%>
<%@ page import="com.newgen.custom.*"%>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.spec.SecretKeySpec"%>

<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session" />
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%
	WriteLog("Inside SRMIntegration.jsp");
	boolean blockCardNoInLogs=true;
	String CardNumber = request.getParameter("CardNumber");
	String OtherBankCardNumber = request.getParameter("OtherBankCardNumber");
	String CustId = request.getParameter("CustId");
	String ReasonCode = request.getParameter("ReasonCode");
	String CardCRN = request.getParameter("CardCRN");
	String WINAME = request.getParameter("WINAME");
	String WSNAME = request.getParameter("WSNAME");
	String CategoryID = request.getParameter("CategoryID");
	String SubCategoryID = request.getParameter("SubCategoryID");
	String RequestType = request.getParameter("RequestType");
	String AvailableBalance = request.getParameter("AvailableBalance");
	String CardCRNNumber = request.getParameter("CardCRNNumber");
	String TrnType = request.getParameter("TrnType");
	String Amount = request.getParameter("Amount");			
	String CardExpiryDate = request.getParameter("CardExpiryDate");
	String Remarks = request.getParameter("Remarks");
	String CardStatus = request.getParameter("CardStatus");
	String AvailableCashBalance = request.getParameter("AvailableCashBalance");
	String ACCNumber = request.getParameter("ACCNumber");
	
	String RequestAmount = request.getParameter("RequestAmount");
	String OverdueAmount = request.getParameter("OverdueAmount");
	String ServiceType = request.getParameter("ServiceType");
	String ServiceSubType = request.getParameter("ServiceSubType");
	String PaymentType = request.getParameter("PaymentType");
	String RequestFor = request.getParameter("RequestFor");
	String OtherBankCode = request.getParameter("OtherBankCode");
	String OtherBankIBAN = request.getParameter("OtherBankIBAN");
	String BeneficiaryName = request.getParameter("BeneficiaryName");
	String MarketingCode = request.getParameter("MarketingCode");
	String MerchantCode = request.getParameter("MerchantCode");
	String ProcessingCode = "";
	String FreeField1 = "";
	
	XMLParser xmlParserData = new XMLParser();
	XMLParser xmlParserData2 = new XMLParser();
	
	String IS_PRIME_UP="";
	String IS_ONLINE_UP="";
	String sMappOutPutXML = "";
	String inputData = "";
	String outputData = "";
	String mainCodeData = "";
	String cardType = "";
	String sCatname = "";
	String sInputXML = "";
	String balanceDetails = "";
	String balanceType = "";
	String balanceAmt = "";
	String cardEligibility = "";
	String eligibilityStatus = "";
	String nonEligibilityReasons = "";
	String serviceDetails ="";
	String subServiceType = "";
	String salary = "";
	String eligibleAmount = "";
	String DebitAuthId = "";
	String ReturnDesc = "";
	String ApprovalId = "";
	String TrnRqUID = "";
	String fieldName="";
	String record="";
	String availableCashBalance="";
	String validationDetails="";
	String validationStatusCode="";
	String params="";
	if(blockCardNoInLogs)
		WriteLog("inside first" + CardNumber);
		
	WriteLog("inside SRMIntegration CategoryID=" + CategoryID+" SubCategoryID="+SubCategoryID);
	WriteLog("inside SRMIntegration CardStatus=" + CardStatus+" AvailableBalance="+AvailableBalance);
	
			
	//PG0039 start . To update the wi_name in the transaction table after workitem is created
	String TEMPWINAME = request.getParameter("TEMPWINAME"); 
	String tableName=request.getParameter("tr_table");
	String columnName="wi_name";
	String strValues="'"+WINAME+"'";
	String sWhere=" temp_wi_name = '"+TEMPWINAME+"'";
	
	WriteLog("tableName :"+tableName);
	WriteLog("columnName :"+columnName);
	
	if(blockCardNoInLogs)
		WriteLog("strValues :"+strValues);
	WriteLog("sWhere :"+sWhere);
	try
	{
		if(tableName!=null)
		{
			 inputData = "<?xml version=\"1.0\"?>"
						+ "<APUpdate_Input><Option>APUpdate</Option>"
						+ "<TableName>" + tableName + "</TableName>"
						+ "<ColName>" + columnName + "</ColName>"
						+ "<Values>" + strValues + "</Values>"
						+ "<WhereClause>" + sWhere + "</WhereClause>"
						+ "<EngineName>" + wfsession.getEngineName() + "</EngineName>"
						+ "<SessionId>" + wfsession.getSessionId() + "</SessionId>"
						+ "</APUpdate_Input>";
			if(blockCardNoInLogs)
				WriteLog("APUpdate InputXML="+sInputXML);
			
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			if(blockCardNoInLogs)
				WriteLog("APUpdate  Output xml-->" + outputData);
		}
	}
	catch(Exception e)
	{
		WriteLog("Exception occured in APUpdate under SRMIntegration.jsp : "+e);
	}
	//PG0039 end.
	
	if (CategoryID.equals("1") && (SubCategoryID.equals("3") || SubCategoryID.equals("2") || SubCategoryID.equals("4")|| SubCategoryID.equals("5"))) {
		
		/*String qry = "select fieldname,FieldValue from usr_0_srm_DataCenterFlagMaster where fieldname in ('IS_PRIME_UP','IS_ONLINE_UP')";
		inputData = "<?xml version='1.0'?>"+
		"<APSelectWithColumnNames_Input>"+
		"<Option>APSelectWithColumnNames</Option>"+
		"<Query>"+ qry + "</Query>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithColumnNames_Input>";*/
		
		params = "ONE==1";
		String qry = "select fieldname,FieldValue from usr_0_srm_DataCenterFlagMaster with (nolock) where 1=:ONE and fieldname in ('IS_PRIME_UP','IS_ONLINE_UP')";
		inputData = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ qry + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		WriteLog("input  xml -->" + inputData);
		outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		WriteLog("output xml-->" + outputData);
		//outputData=outputData.replaceAll("NULL"," ");
		xmlParserData.setInputXML(outputData);
		mainCodeData = xmlParserData.getValueOf("MainCode");
		if (mainCodeData.equals("0")) {
			int countFieldName = xmlParserData.getNoOfFields("Record");
			WriteLog("countFieldName-->" + countFieldName);
			for (int i = 0; i < countFieldName; i++) {
					record = xmlParserData.getNextValueOf("Record");
					WriteLog("record-->" + record);
					xmlParserData2.setInputXML(record);
					fieldName = xmlParserData2.getValueOf("fieldname");
					if(fieldName.equals("IS_PRIME_UP"))
						IS_PRIME_UP = xmlParserData2.getValueOf("FieldValue");
					if(fieldName.equals("IS_ONLINE_UP"))
						IS_ONLINE_UP = xmlParserData2.getValueOf("FieldValue");
			}
		}
		WriteLog("IS_PRIME_UP-->" + IS_PRIME_UP);
		WriteLog("IS_ONLINE_UP-->" + IS_ONLINE_UP);
	}
	
	if (WSNAME.equals("PBO")) 
	{
		
		if (CategoryID.equals("1") && SubCategoryID.equals("3")) {
			if (RequestType != null && RequestType.equals("CARD_BALENQ")) {
				/*String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN where Parameter = '"+CardNumber.substring(0,6)+"' and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithColumnNames_Input>"+
				"<Option>APSelectWithColumnNames</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithColumnNames_Input>";*/
				
				params = "Parameter=="+CardNumber.substring(0,6);
				String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN  with (nolock) where Parameter = :Parameter and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				
			if(blockCardNoInLogs)
				WriteLog("inputData-->" + inputData);
			outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
			if(blockCardNoInLogs)
				WriteLog("outputData-->" + outputData);
				//outputData=outputData.replaceAll("NULL"," ");
				xmlParserData.setInputXML((outputData));
				mainCodeData = xmlParserData.getValueOf("MainCode");
				if (mainCodeData.equals("0")) {
					cardType = xmlParserData.getValueOf("card_type");
					WriteLog("CARD_BALENQ cardType--->" + cardType);
				}
				sCatname = "BalanceEnq";
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+
				"<CardType>"+ cardType+ "</CardType>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}else if (RequestType != null && RequestType.equals("CARDBLOCK")) {
				sCatname = "CardMaintenance";
				/*String qry = "  select primestatuscode + '|'+onlinestatuscode as reasoncode from usr_0_srm_boc_rsnforblock where primestatuscode ='"+ReasonCode+"'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithColumnNames_Input>"+
				"<Option>APSelectWithColumnNames</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithColumnNames_Input>";*/
				
				params = "PRIMESTATUSCODE=="+ReasonCode;
				String qry = "  select primestatuscode + '|'+onlinestatuscode as reasoncode from usr_0_srm_boc_rsnforblock with (nolock) where primestatuscode =:PRIMESTATUSCODE";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				
				WriteLog("inputData-->" + inputData);
				outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputData-->" + outputData);
				//outputData=outputData.replaceAll("NULL"," ");
				xmlParserData.setInputXML((outputData));
				mainCodeData = xmlParserData.getValueOf("MainCode");
				if (mainCodeData.equals("0")) {
					ReasonCode = xmlParserData.getValueOf("reasoncode");
					WriteLog("CARD BLOCK REASONCODE--->" + ReasonCode);
				}
				
				sInputXML = "<?xml version=\"1.0\"?>\n"	+ "<APAPMQPutGetMessage>\n"	+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+ 
				"<CustId>"+ CustId+ "</CustId>\n"+ 
				"<ReasonCode>"+ ReasonCode+ "</ReasonCode>\n"+
				"<CardCRN>"+ CardCRN+ "</CardCRN>\n"+ 
				"<RequestType>"+sCatname+"</RequestType>\n"+ 
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}

            String FormValue = "";
			if(blockCardNoInLogs)
				WriteLog("BOC InputXML:-    " + sInputXML);
			try{

				//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
				sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				
				if (RequestType != null && RequestType.equals("CARD_BALENQ")) {
					/*sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> "+ "<EE_EAI_MESSAGE>"+ "<EE_EAI_HEADER>"+ "<MsgFormat>CARD_BALENQ</MsgFormat>"	+ "<MsgVersion>0000</MsgVersion>"+ "<RequestorChannelId>BPM</RequestorChannelId>"+ "<RequestorUserId>RAKUSER</RequestorUserId>"	+ "<RequestorLanguage>E</RequestorLanguage>"+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo>"+ "<ReturnCode>0000</ReturnCode>"+ "<ReturnDesc>Success</ReturnDesc>"+ "<MessageId>123123453</MessageId>"+ "<Extra1>REP||SHELL.JOHN</Extra1>"	+ "<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>"+ "</EE_EAI_HEADER>"+ "<CardBalInqResponse>"+ "<BankId>RAK</BankId>"+ "<CardNumber>4581xxxxxxxx2002</CardNumber>"	+ "<CardGroupInformation>"+ "<BalanceDetails>"+ "<BalanceType>TotalLimit</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>TotalOTB</BalanceType>"+ "<BalanceAmt>1000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashLimit</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashOTB</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LedgerOTB</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MaxLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MinLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LastBalance</BalanceType>"	+ "<BalanceAmt>10000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>Bonus</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusCashAmount</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusDeclineAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails><FreeField1>"+ "<FreeField2>"+ "<FreeField3>"+ "</CardGroupInformation>"+ "</CardBalInqResponse>"+ "</EE_EAI_MESSAGE>";*/
				}else if (RequestType != null && RequestType.equals("CARDBLOCK")) {
					/*sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE>   <EE_EAI_HEADER>"
							+ "MsgFormat>CARD_MAINTAINANCE</MsgFormat> "
							+ "<MsgVersion>0001</MsgVersion> "
							+ "<RequestorChannelId>BPM</RequestorChannelId> "
							+ "<RequestorUserId>RAKUSER</RequestorUserId> "
							+ "<RequestorLanguage>E</RequestorLanguage> "
							+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo> "
							+ "<ReturnCode>1111</ReturnCode> "
							+ "<ReturnDesc>Success</ReturnDesc> "
							+ "<MessageId>123123453</MessageId> "
							+ "<Extra1>REP||SHELL.JOHN</Extra1> "
							+ "<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2> "
							+ "</EE_EAI_HEADER>"
							+ "<CardMaintainance>"
							+ "<BankId>RAK</BankId>"
							+ "<CustId>FDSGS2313</CustId>"
							+ "<CardCRN>123456789</CardCRN>"
							+ "<CardNumber>12213421545546</CardNumber>"
							+ "<FreeField1></FreeField1>"
							+ "<FreeField2></FreeField2>"
							+ "</CardMaintainance>"
							+ "</EE_EAI_MESSAGE>";*/
				}
				
            }catch (Exception exp) {
				//bError=true;
			}

            if(blockCardNoInLogs)
				WriteLog("BOC output XML:-" + sMappOutPutXML);
			xmlParserData.setInputXML((sMappOutPutXML));
			String mainCodeValue = xmlParserData.getValueOf("ReturnCode");
			WriteLog("BOC maincode-" + mainCodeValue);
			if (mainCodeValue.equals("0000")) {
				WriteLog("BOC RequestType" + RequestType);
				if (RequestType != null	&& RequestType.equals("CARD_BALENQ")) {
					int countBalanceDetails = xmlParserData.getNoOfFields("BalanceDetails");
					for (int i = 0; i < countBalanceDetails; i++) {
						balanceDetails = xmlParserData.getNextValueOf("BalanceDetails");
						xmlParserData2.setInputXML(balanceDetails);
						balanceType = xmlParserData2.getValueOf("BalanceType");
						if (balanceType.equals("TotalOTB")) {
							balanceAmt = xmlParserData2.getValueOf("BalanceAmt");
						}
					}
					WriteLog("balanceAmt"+balanceAmt);
				}
			} else {
				WriteLog("Inside SRMIntegration.jsp Blocking of Card failed");
			}
			out.clear();
			if (RequestType != null	&& RequestType.equals("CARD_BALENQ"))
				out.println(mainCodeValue + "~" + balanceAmt);
			else
				out.println(mainCodeValue + "~");			
		}else if (CategoryID.equals("1") && SubCategoryID.equals("2")) 
		{
			//CARD_BALENQ - for available balance
			if (RequestType != null && RequestType.equals("CARD_BALENQ")) {
				/*String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN where Parameter = '"+CardNumber.substring(0,6)+"' and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithColumnNames_Input>"+
				"<Option>APSelectWithColumnNames</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithColumnNames_Input>";*/
				
				params = "Parameter=="+CardNumber.substring(0,6);
				String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN  with (nolock) where Parameter = :Parameter and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
		
		
			if(blockCardNoInLogs)
				WriteLog("inputData-->" + inputData);
				outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputData-->" + outputData);
				//outputData=outputData.replaceAll("NULL"," ");
				xmlParserData.setInputXML((outputData));
				mainCodeData = xmlParserData.getValueOf("MainCode");
				if (mainCodeData.equals("0")) {
					cardType = xmlParserData.getValueOf("card_type");
					WriteLog("CARD_BALENQ cardType--->" + cardType);
				}
				sCatname = "BalanceEnq";
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+
				"<CardType>"+ cardType+ "</CardType>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}else if(RequestType != null && RequestType.equals("CardEligibility")){
				sCatname = "CardServiceEligibility";
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<BankId>RAK</BankId>\n"+
				"<CIFID>"+ CustId+ "</CIFID>\n"+
				"<ACCNumber></ACCNumber>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<CardCRNNumber></CardCRNNumber>\n"+
				"<CardStatus>"+CardStatus+"</CardStatus>\n"+
				"<AvailableBalance>"+ AvailableBalance+ "</AvailableBalance>\n"+
				"<AvailableCashBalance>"+AvailableCashBalance+"</AvailableCashBalance>\n"+
				"<RequestAmount></RequestAmount>\n"+
				"<OverdueAmount>"+OverdueAmount+"</OverdueAmount>\n"+
				"<ServiceType>BalanceTransfer</ServiceType>\n"+
				"<ServiceSubType>BT</ServiceSubType>\n"+
				"<PaymentType></PaymentType>\n"+
				"<RequestFor>E</RequestFor>\n"+
				"<OtherBankCode></OtherBankCode>\n"+
				"<OtherBankCard></OtherBankCard>\n"+
				"<OtherBankIBAN></OtherBankIBAN>\n"+
			    "<BeneficiaryName></BeneficiaryName>\n"+
				"<MarketingCode></MarketingCode>\n"+
				"<RequestType>"+sCatname+"</RequestType>\n"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			} else if(RequestType != null && RequestType.equals("BTEligibility")){
				String PaymentMode = request.getParameter("PaymentMode");
				if (PaymentMode.equalsIgnoreCase("MCQ"))
					PaymentMode = "Cheque";
				if (PaymentMode.equalsIgnoreCase("FTS"))
					PaymentMode = "Swift";
					
				sCatname = "CardServiceEligibilityOB";
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<BankId>RAK</BankId>\n"+
				"<CIFID>"+ CustId+ "</CIFID>\n"+
				"<ACCNumber></ACCNumber>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<CardCRNNumber></CardCRNNumber>\n"+
				"<CardStatus></CardStatus>\n"+
				"<AvailableBalance></AvailableBalance>\n"+
				"<AvailableCashBalance></AvailableCashBalance>\n"+
				"<RequestAmount>"+RequestAmount.replaceAll(",","")+"</RequestAmount>\n"+
				"<OverdueAmount></OverdueAmount>\n"+
				"<ServiceType>BalanceTransfer</ServiceType>\n"+
				"<ServiceSubType>BT</ServiceSubType>\n"+
				"<PaymentType></PaymentType>\n"+
				"<PaymentMode>"+PaymentMode+"</PaymentMode>\n"+
				"<RequestFor>V</RequestFor>\n"+
				"<OtherBankCard>"+OtherBankCardNumber+"</OtherBankCard>\n"+
			    "<BeneficiaryName>"+BeneficiaryName+"</BeneficiaryName>\n"+
				"<MarketingCode>"+MarketingCode+"</MarketingCode>\n"+
				"<RequestType>"+sCatname+"</RequestType>\n"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}else if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD") ) {
				sCatname = "FUNDBLOCK";
				sInputXML = "<?xml version=\"1.0\"?>\n"	+ "<APAPMQPutGetMessage>\n"	+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+ 
				"<CardCRNNumber>"+CardCRNNumber+"</CardCRNNumber>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+ 
				"<TrnType>"+TrnType+"</TrnType>\n"+
				"<Amount>"+Amount.replaceAll(",","")+"</Amount>\n"+
				"<Currency>AED</Currency>\n"+
				"<CardExpiryDate>"+CardExpiryDate+"</CardExpiryDate>\n"+
				"<Remarks></Remarks>\n"+
				"<MerchantCode> </MerchantCode>\n"+
				"<ProcessingCode>000000</ProcessingCode>\n"+
				"<FreeField1> </FreeField1>\n"+
				"<RequestType>"+sCatname+"</RequestType>\n"+ 
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}
			String FormValue = "";
			if(blockCardNoInLogs)
				WriteLog("BT InputXML:-    " + sInputXML);
			try {
				//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
				sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
				if (RequestType != null && RequestType.equals("CARD_BALENQ") ) 
				{
					//sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> "+ "<EE_EAI_MESSAGE>"+ "<EE_EAI_HEADER>"+ "<MsgFormat>CARD_BALENQ</MsgFormat>"	+ "<MsgVersion>0000</MsgVersion>"+ "<RequestorChannelId>BPM</RequestorChannelId>"+ "<RequestorUserId>RAKUSER</RequestorUserId>"	+ "<RequestorLanguage>E</RequestorLanguage>"+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo>"+ "<ReturnCode>0000</ReturnCode>"+ "<ReturnDesc>Success</ReturnDesc>"+ "<MessageId>123123453</MessageId>"+ "<Extra1>REP||SHELL.JOHN</Extra1>"	+ "<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>"+ "</EE_EAI_HEADER>"+ "<CardBalInqResponse>"+ "<BankId>RAK</BankId>"+ "<CardNumber>4581xxxxxxxx2002</CardNumber>"	+ "<CardGroupInformation>"+ "<BalanceDetails>"+ "<BalanceType>TotalLimit</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>TotalOTB</BalanceType>"+ "<BalanceAmt>1000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashLimit</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashOTB</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LedgerOTB</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MaxLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MinLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LastBalance</BalanceType>"	+ "<BalanceAmt>10000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>Bonus</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusCashAmount</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusDeclineAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails><FreeField1>"+ "<FreeField2>"+ "<FreeField3>"+ "</CardGroupInformation>"+ "</CardBalInqResponse>"+ "</EE_EAI_MESSAGE>";
				}
				else if(RequestType != null && RequestType.equals("CardEligibility")){
					//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_SVC_ELIG_CHECK</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardServiceEligibilityCheckResponse><BankId>RAK</BankId><CIFID>FDSGS2313</CIFID><ACCNumber>12XXXX635</ACCNumber><CardNumber>1234XXXXXXXX1635</CardNumber><CardCRNNumber>12548556</CardCRNNumber><DeclaredSalary>200000.00</DeclaredSalary><Validations><ValidationType>BlacklistCheck</ValidationType><StatusCode>100</StatusCode><StatusDesc>Y</StatusDesc></Validations><Validations><ValidationType>DeliquencyCheck</ValidationType><StatusCode>101</StatusCode><StatusDesc>Bucket3</StatusDesc></Validations><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>BT</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>100</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>3500.00</EligibleAmount><EligiblePercentage>90</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>CCC</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>00</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>4000.00</EligibleAmount><EligiblePercentage>95</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><FreeField1/><FreeField2/><FreeField3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardServiceEligibilityCheckResponse></EE_EAI_MESSAGE>";
				}else if(RequestType != null && RequestType.equals("BTEligibility")){
					//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_SVC_ELIG_CHECK</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardServiceEligibilityCheckResponse><BankId>RAK</BankId><CIFID>FDSGS2313</CIFID><ACCNumber>12XXXX635</ACCNumber><CardNumber>1234XXXXXXXX1635</CardNumber><CardCRNNumber>12548556</CardCRNNumber><DeclaredSalary>200000.00</DeclaredSalary><Validations><ValidationType>BlacklistCheck</ValidationType><StatusCode>100</StatusCode><StatusDesc>Y</StatusDesc></Validations><Validations><ValidationType>DeliquencyCheck</ValidationType><StatusCode>101</StatusCode><StatusDesc>Bucket3</StatusDesc></Validations><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>BT</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>100</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>3500.00</EligibleAmount><EligiblePercentage>90</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>CCC</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>00</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>4000.00</EligibleAmount><EligiblePercentage>95</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><FreeField1/><FreeField2/><FreeField3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardServiceEligibilityCheckResponse></EE_EAI_MESSAGE>";
				}else if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
					/*sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
										+"<EE_EAI_MESSAGE>"
										+"<EE_EAI_HEADER>"
										+"<MsgFormat>FUND_BLOCK_ON_CREDIT_CARD</MsgFormat> "
										+"<MsgVersion>0001</MsgVersion> "
										+"<RequestorChannelId>INB</RequestorChannelId> "
										+"<RequestorUserId>RAKUSER</RequestorUserId> "
										+"<RequestorLanguage>E</RequestorLanguage> "
										+"<RequestorSecurityInfo>secure</RequestorSecurityInfo> "
										+"<ReturnCode>0000</ReturnCode> "
										+"<ReturnDesc>Success</ReturnDesc> "
										+"<MessageId>123123453</MessageId> "
										+"<Extra1>REP||SHELL.JOHN</Extra1> "
										+"<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2> "
										+"</EE_EAI_HEADER>	"
										+"<CreditCardFundBlock>"
										+"<BankId>RAK</BankId>"
										+"<CustId>Fxxxxx313</CustId>"
										+"<CardNumber>1221xxxxxxxx5546</CardNumber>"
										+"<ApprovalId>ApprovalId132DFS</ApprovalId>"
										+"<DebitAuthId>DebitAuthIddsfsdf43326</DebitAuthId>"
										+"<TrnRqUID>TrnRqUID1234</TrnRqUID>"
										+"<FreeField1/>"
										+"<FreeField2/>"
										+"<FreeAmount1>0.00</FreeAmount1>"
										+"<FreeAmount2>0.00</FreeAmount2>"
										+"<FreeDate1>YYYY-MM-DD</FreeDate1>"
										+"<FreeDate2>YYYY-MM-DD</FreeDate2>"
										+"</CreditCardFundBlock>"
										+"</EE_EAI_MESSAGE>";*/
				}
			}catch (Exception exp) {
					//bError=true;
				}
				WriteLog("BT output XML:-" + sMappOutPutXML);
				xmlParserData.setInputXML((sMappOutPutXML));
				String mainCodeValue = xmlParserData.getValueOf("ReturnCode");
				if (mainCodeValue.equals("0000")){
					if (RequestType != null	&& RequestType.equals("CARD_BALENQ") ) {
						int countBalanceDetails = xmlParserData.getNoOfFields("BalanceDetails");
						for (int i = 0; i < countBalanceDetails; i++) {
							balanceDetails = xmlParserData.getNextValueOf("BalanceDetails");
							xmlParserData2.setInputXML(balanceDetails);
							balanceType = xmlParserData2.getValueOf("BalanceType");
							if (balanceType.equals("TotalOTB")) {
								balanceAmt = xmlParserData2.getValueOf("BalanceAmt");
							}
							else if (balanceType.equals("CashOTB")) {
								availableCashBalance = xmlParserData2.getValueOf("BalanceAmt");
							}
						}
					}else if(RequestType != null && RequestType.equals("CardEligibility")){
						salary = xmlParserData.getValueOf("DeclaredSalary");	
						int countServiceDetails = xmlParserData.getNoOfFields("ServiceDetails");
						for (int i = 0; i < countServiceDetails; i++) {
							serviceDetails = xmlParserData.getNextValueOf("ServiceDetails");
							xmlParserData2.setInputXML(serviceDetails);
							subServiceType = xmlParserData2.getValueOf("ServiceSubType");
							if (subServiceType.equals("BT")) {
								eligibleAmount = xmlParserData2.getValueOf("EligibleAmount");
								eligibilityStatus = xmlParserData2.getValueOf("EligibilityStatus");
								
							}
						}
						//nonEligibilityReasons = xmlParserData2.getValueOf("RejectReason");
						xmlParserData.setInputXML(sMappOutPutXML);
						int countValidations = xmlParserData.getNoOfFields("Validations");
						for (int i = 0; i < countValidations; i++) {
							validationDetails = xmlParserData.getNextValueOf("Validations");
							xmlParserData2.setInputXML(validationDetails);
							validationStatusCode = xmlParserData2.getValueOf("StatusCode");
							if (!validationStatusCode.equals("0000")) {
								nonEligibilityReasons+= xmlParserData2.getValueOf("StatusCode")+"-";
							}
						}
						if(nonEligibilityReasons.length()>0)
							nonEligibilityReasons = nonEligibilityReasons.substring(0,nonEligibilityReasons.lastIndexOf("-"));
					}else if(RequestType != null && RequestType.equals("BTEligibility")){
						int countServiceDetails = xmlParserData.getNoOfFields("ServiceDetails");
						for (int i = 0; i < countServiceDetails; i++) {
							serviceDetails = xmlParserData.getNextValueOf("ServiceDetails");
							xmlParserData2.setInputXML(serviceDetails);
							subServiceType = xmlParserData2.getValueOf("ServiceSubType");
							if (subServiceType.equals("BT")) {
								cardEligibility = xmlParserData2.getValueOf("EligibilityStatus");
							}
						}
						xmlParserData.setInputXML(sMappOutPutXML);
						int countValidations = xmlParserData.getNoOfFields("Validations");
						for (int i = 0; i < countValidations; i++) {
							validationDetails = xmlParserData.getNextValueOf("Validations");
							xmlParserData2.setInputXML(validationDetails);
							validationStatusCode = xmlParserData2.getValueOf("StatusCode");
							if (!validationStatusCode.equals("0000")) {
								nonEligibilityReasons+= xmlParserData2.getValueOf("StatusCode")+"-";
							}
						}
						if(nonEligibilityReasons.length()>0)
							nonEligibilityReasons = nonEligibilityReasons.substring(0,nonEligibilityReasons.lastIndexOf("-"));
					}else if(RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")){
						 DebitAuthId = xmlParserData.getValueOf("DebitAuthId");
						 ReturnDesc = xmlParserData.getValueOf("ReturnDesc");
						 ApprovalId = xmlParserData.getValueOf("ApprovalId");
						 TrnRqUID = xmlParserData.getValueOf("TrnRqUID");
					}
					
				} else {
					
					WriteLog("Inside SRMIntegration.jsp Balance of Transfer failed");
				}
				out.clear();
				if (RequestType != null	&& RequestType.equals("CARD_BALENQ") )
					out.println(mainCodeValue + "~" + balanceAmt+"~"+availableCashBalance);
				else if (RequestType != null	&& RequestType.equals("CardEligibility"))
					out.println(mainCodeValue + "~"+eligibilityStatus+"~"+ eligibleAmount + "~" + salary+ "~" + nonEligibilityReasons+ "~" );
					//out.println(mainCodeValue + "~" + cardEligibility + "~" + eligibleAmount + "~" + nonEligibilityReasons);
				else if (RequestType != null	&& RequestType.equals("BTEligibility"))
					out.println(mainCodeValue + "~" + cardEligibility+ "~" + nonEligibilityReasons+ "~" );
				else if (RequestType != null	&& RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD") )
					out.println(mainCodeValue + "~" + DebitAuthId+ "~" +ReturnDesc + "~"+ApprovalId + "~"+TrnRqUID + "~");
				else
					out.println(mainCodeValue + "~");	
		}else if (CategoryID.equals("1") && SubCategoryID.equals("4")) {
			WriteLog("inside CCCCCCCC RequestType=" +RequestType);
			if (RequestType != null && RequestType.equals("CARD_BALENQ")) {
				/*String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN where Parameter = '"+CardNumber.substring(0,6)+"' and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithColumnNames_Input>"+ 
				"<Option>APSelectWithColumnNames</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithColumnNames_Input>";*/
				
				params = "Parameter=="+CardNumber.substring(0,6);
				String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN  with (nolock) where Parameter = :Parameter and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				
				if(blockCardNoInLogs)
					WriteLog("inputData-->" + inputData);
				outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputData-->" + outputData);
				//outputData=outputData.replaceAll("NULL"," ");
				xmlParserData.setInputXML((outputData));
				mainCodeData = xmlParserData.getValueOf("MainCode");
				if (mainCodeData.equals("0")) {
					cardType = xmlParserData.getValueOf("card_type");
					WriteLog("CARD_BALENQ cardType--->" + cardType);
				}
				sCatname = "BalanceEnq";
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+
				"<CardType>"+ cardType+ "</CardType>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+ 
				"</APAPMQPutGetMessage>\n";
			}else if(RequestType != null && RequestType.equals("CCCCardEligibility")){
				sCatname = "CardServiceEligibility";
				WriteLog("inside CCCCCCCC sCatname=" +sCatname);
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<BankId>RAK</BankId>"+
				"<CIFID>"+ CustId+ "</CIFID>\n"+
				"<CardStatus>"+CardStatus+"</CardStatus>\n"+
				"<AvailableBalance>"+ AvailableBalance+ "</AvailableBalance>\n"+
				"<AvailableCashBalance>"+ AvailableCashBalance+ "</AvailableCashBalance>\n"+
				"<OverdueAmount>"+OverdueAmount+"</OverdueAmount>\n"+
				"<ServiceType>CreditCardCheque</ServiceType>\n"+
				"<ServiceSubType>CCC</ServiceSubType>\n"+
				"<PaymentType>"+PaymentType+"</PaymentType>\n"+
				"<RequestFor>E</RequestFor>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			} else if(RequestType != null && RequestType.equals("CCCEligibility")){
				String PaymentMode = request.getParameter("PaymentMode");
				String RakBankAccNumber = request.getParameter("RakBankAccNumber");
				if (PaymentMode.equalsIgnoreCase("Account Transfer"))
				{
					RakBankAccNumber = "<OtherBankAcctId>"+RakBankAccNumber+"</OtherBankAcctId>\n";
					PaymentMode = "AccountTransfer";
				}
				if (PaymentMode.equalsIgnoreCase("MCQ"))
					PaymentMode = "Cheque";
				if (PaymentMode.equalsIgnoreCase("FTS"))
					PaymentMode = "Swift";
					
				sCatname = "CardServiceEligibilityOB";
				WriteLog("inside CCCCCCCC sCatname=" +sCatname);
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<BankId>RAK</BankId>"+
				"<CIFID>"+ CustId+ "</CIFID>\n"+
				"<CardStatus></CardStatus>\n"+
				"<AvailableBalance></AvailableBalance>\n"+
				"<RequestAmount>"+RequestAmount.replaceAll(",","")+"</RequestAmount>\n"+
				"<ServiceType>CreditCardCheque</ServiceType>\n"+
				"<ServiceSubType>CCC</ServiceSubType>\n"+
				"<PaymentType>"+PaymentType+"</PaymentType>\n"+
				"<PaymentMode>"+PaymentMode+"</PaymentMode>\n"+
				"<RequestFor>V</RequestFor>\n"+
				"<MarketingCode>"+MarketingCode+"</MarketingCode>\n"+
				RakBankAccNumber+
				"<BeneficiaryName>"+BeneficiaryName+"</BeneficiaryName>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}else if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
				sCatname = "FUNDBLOCK";
				if(MerchantCode.equals("0400"))
				{
					ProcessingCode="010000";
					FreeField1="6010";
				}
				else
				{
					ProcessingCode="000000";
					FreeField1="5999";
				}
				sInputXML = "<?xml version=\"1.0\"?>\n"	+ "<APAPMQPutGetMessage>\n"	+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+ 
				"<CardCRNNumber>"+CardCRNNumber+"</CardCRNNumber>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+ 
				"<TrnType>"+TrnType+"</TrnType>\n"+
				"<Amount>"+Amount.replaceAll(",","")+"</Amount>\n"+
				"<Currency>AED</Currency>\n"+
				"<CardExpiryDate>"+CardExpiryDate+"</CardExpiryDate>\n"+
				"<Remarks></Remarks>\n"+
				"<MerchantCode>"+MerchantCode+"</MerchantCode>\n"+
				"<ProcessingCode>"+ProcessingCode+"</ProcessingCode>\n"+
				"<FreeField1>"+FreeField1+"</FreeField1>\n"+
				"<RequestType>"+sCatname+"</RequestType>\n"+ 
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"	+
				"</APAPMQPutGetMessage>\n";
			}
			String FormValue = "";
			if(blockCardNoInLogs)
				WriteLog("CCC InputXML:-    " + sInputXML);
			try {
				//sMappOutPutXML= WFCallBroker.execute(sInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				
				if (RequestType != null && RequestType.equals("CARD_BALENQ") ) {
					//sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> "+ "<EE_EAI_MESSAGE>"+ "<EE_EAI_HEADER>"+ "<MsgFormat>CARD_BALENQ</MsgFormat>"	+ "<MsgVersion>0000</MsgVersion>"+ "<RequestorChannelId>BPM</RequestorChannelId>"+ "<RequestorUserId>RAKUSER</RequestorUserId>"	+ "<RequestorLanguage>E</RequestorLanguage>"+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo>"+ "<ReturnCode>0000</ReturnCode>"+ "<ReturnDesc>Success</ReturnDesc>"+ "<MessageId>123123453</MessageId>"+ "<Extra1>REP||SHELL.JOHN</Extra1>"	+ "<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>"+ "</EE_EAI_HEADER>"+ "<CardBalInqResponse>"+ "<BankId>RAK</BankId>"+ "<CardNumber>4581xxxxxxxx2002</CardNumber>"	+ "<CardGroupInformation>"+ "<BalanceDetails>"+ "<BalanceType>TotalLimit</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>TotalOTB</BalanceType>"+ "<BalanceAmt>1000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashLimit</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashOTB</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LedgerOTB</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MaxLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MinLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LastBalance</BalanceType>"	+ "<BalanceAmt>10000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>Bonus</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusCashAmount</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusDeclineAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails><FreeField1>"+ "<FreeField2>"+ "<FreeField3>"+ "</CardGroupInformation>"+ "</CardBalInqResponse>"+ "</EE_EAI_MESSAGE>";
				}else if(RequestType != null && RequestType.equals("CCCCardEligibility")){
					//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_SVC_ELIG_CHECK</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardServiceEligibilityCheckResponse><BankId>RAK</BankId><CIFID>FDSGS2313</CIFID><ACCNumber>12XXXX635</ACCNumber><CardNumber>1234XXXXXXXX1635</CardNumber><CardCRNNumber>12548556</CardCRNNumber><DeclaredSalary>200000.00</DeclaredSalary><Validations><ValidationType>BlacklistCheck</ValidationType><StatusCode>100</StatusCode><StatusDesc>Y</StatusDesc></Validations><Validations><ValidationType>DeliquencyCheck</ValidationType><StatusCode>101</StatusCode><StatusDesc>Bucket3</StatusDesc></Validations><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>BT</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>100</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>3500.00</EligibleAmount><EligiblePercentage>90</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>CCC</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>00</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>4000.00</EligibleAmount><EligiblePercentage>95</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><FreeField1/><FreeField2/><FreeField3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardServiceEligibilityCheckResponse></EE_EAI_MESSAGE>";
				}else if(RequestType != null && RequestType.equals("CCCEligibility")){
					//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_SVC_ELIG_CHECK</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardServiceEligibilityCheckResponse><BankId>RAK</BankId><CIFID>FDSGS2313</CIFID><ACCNumber>12XXXX635</ACCNumber><CardNumber>1234XXXXXXXX1635</CardNumber><CardCRNNumber>12548556</CardCRNNumber><DeclaredSalary>200000.00</DeclaredSalary><Validations><ValidationType>BlacklistCheck</ValidationType><StatusCode>100</StatusCode><StatusDesc>Y</StatusDesc></Validations><Validations><ValidationType>DeliquencyCheck</ValidationType><StatusCode>101</StatusCode><StatusDesc>Bucket3</StatusDesc></Validations><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>BT</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>100</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>3500.00</EligibleAmount><EligiblePercentage>90</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>CCC</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>00</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>4000.00</EligibleAmount><EligiblePercentage>95</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><FreeField1/><FreeField2/><FreeField3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardServiceEligibilityCheckResponse></EE_EAI_MESSAGE>";
				}else if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
					/*sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
										+"<EE_EAI_MESSAGE>"
										+"<EE_EAI_HEADER>"
										+"<MsgFormat>FUND_BLOCK_ON_CREDIT_CARD</MsgFormat> "
										+"<MsgVersion>0001</MsgVersion> "
										+"<RequestorChannelId>INB</RequestorChannelId> "
										+"<RequestorUserId>RAKUSER</RequestorUserId> "
										+"<RequestorLanguage>E</RequestorLanguage> "
										+"<RequestorSecurityInfo>secure</RequestorSecurityInfo> "
										+"<ReturnCode>1111</ReturnCode> "
										+"<ReturnDesc>Success</ReturnDesc> "
										+"<MessageId>123123453</MessageId> "
										+"<Extra1>REP||SHELL.JOHN</Extra1> "
										+"<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2> "
										+"</EE_EAI_HEADER>	"
										+"<CreditCardFundBlock>"
										+"<BankId>RAK</BankId>"
										+"<CustId>Fxxxxx313</CustId>"
										+"<CardNumber>1221xxxxxxxx5546</CardNumber>"
										+"<ApprovalId>ApprovalId132DFS</ApprovalId>"
										+"<DebitAuthId>DebitAuthIddsfsdf43325</DebitAuthId>"
										+"<TrnRqUID>TrnRqUID1234</TrnRqUID>"
										+"<FreeField1/>"
										+"<FreeField2/>"
										+"<FreeAmount1>0.00</FreeAmount1>"
										+"<FreeAmount2>0.00</FreeAmount2>"
										+"<FreeDate1>YYYY-MM-DD</FreeDate1>"
										+"<FreeDate2>YYYY-MM-DD</FreeDate2>"
										+"</CreditCardFundBlock>"
										+"</EE_EAI_MESSAGE>";*/
				}
			}catch (Exception exp) {
					//bError=true;
				}
				WriteLog("CCC output XML:-" + sMappOutPutXML);
				xmlParserData.setInputXML((sMappOutPutXML));
				String mainCodeValue = xmlParserData.getValueOf("ReturnCode");
				if (mainCodeValue.equals("0000")){
					if (RequestType != null	&& RequestType.equals("CARD_BALENQ") ) {
						int countBalanceDetails = xmlParserData.getNoOfFields("BalanceDetails");
						for (int i = 0; i < countBalanceDetails; i++) {
							balanceDetails = xmlParserData.getNextValueOf("BalanceDetails");
							xmlParserData2.setInputXML(balanceDetails);
							balanceType = xmlParserData2.getValueOf("BalanceType");
							if (balanceType.equals("TotalOTB")) {
								balanceAmt = xmlParserData2.getValueOf("BalanceAmt");
							}
							else if (balanceType.equals("CashOTB")) {
								availableCashBalance = xmlParserData2.getValueOf("BalanceAmt");
							}
						}
					}else if(RequestType != null && RequestType.equals("CCCCardEligibility")){
						salary = xmlParserData.getValueOf("DeclaredSalary");
						int countServiceDetails = xmlParserData.getNoOfFields("ServiceDetails");
						for (int i = 0; i < countServiceDetails; i++) {
							serviceDetails = xmlParserData.getNextValueOf("ServiceDetails");
							xmlParserData2.setInputXML(serviceDetails);
							subServiceType = xmlParserData2.getValueOf("ServiceSubType");
							if (subServiceType.equals("CCC")) {
								eligibleAmount = xmlParserData2.getValueOf("EligibleAmount");
								eligibilityStatus = xmlParserData2.getValueOf("EligibilityStatus");
								
							}
						}
						//nonEligibilityReasons = xmlParserData2.getValueOf("RejectReason");
						xmlParserData.setInputXML(sMappOutPutXML);
						int countValidations = xmlParserData.getNoOfFields("Validations");
						for (int i = 0; i < countValidations; i++) {
							validationDetails = xmlParserData.getNextValueOf("Validations");
							xmlParserData2.setInputXML(validationDetails);
							validationStatusCode = xmlParserData2.getValueOf("StatusCode");
							if (!validationStatusCode.equals("0000")) {
								nonEligibilityReasons+= xmlParserData2.getValueOf("StatusCode")+"-";
							}
						}
						if(nonEligibilityReasons.length()>0)
							nonEligibilityReasons = nonEligibilityReasons.substring(0,nonEligibilityReasons.lastIndexOf("-"));
					}else if(RequestType != null && RequestType.equals("CCCEligibility")){
						int countServiceDetails = xmlParserData.getNoOfFields("ServiceDetails");
						for (int i = 0; i < countServiceDetails; i++) {
							serviceDetails = xmlParserData.getNextValueOf("ServiceDetails");
							xmlParserData2.setInputXML(serviceDetails);
							subServiceType = xmlParserData2.getValueOf("ServiceSubType");
							if (subServiceType.equals("CCC")) {
								cardEligibility = xmlParserData2.getValueOf("EligibilityStatus");
							}
						}
						xmlParserData.setInputXML(sMappOutPutXML);
						int countValidations = xmlParserData.getNoOfFields("Validations");
						for (int i = 0; i < countValidations; i++) {
							validationDetails = xmlParserData.getNextValueOf("Validations");
							xmlParserData2.setInputXML(validationDetails);
							validationStatusCode = xmlParserData2.getValueOf("StatusCode");
							if (!validationStatusCode.equals("0000")) {
								nonEligibilityReasons+= xmlParserData2.getValueOf("StatusCode")+"-";
							}
						}
						if(nonEligibilityReasons.length()>0)
							nonEligibilityReasons = nonEligibilityReasons.substring(0,nonEligibilityReasons.lastIndexOf("-"));
					}else if(RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")){
						 DebitAuthId = xmlParserData.getValueOf("DebitAuthId");
						 ReturnDesc = xmlParserData.getValueOf("ReturnDesc");
						 ApprovalId = xmlParserData.getValueOf("ApprovalId");
						 TrnRqUID = xmlParserData.getValueOf("TrnRqUID");
					}
				} else {
					
					WriteLog("Inside SRMIntegration.jsp Balance of Transfer failed");
				}
				out.clear();
				if (RequestType != null	&& RequestType.equals("CARD_BALENQ") )
					out.println(mainCodeValue + "~" + balanceAmt+"~"+availableCashBalance);
				else if (RequestType != null	&& RequestType.equals("CCCCardEligibility"))
					out.println(mainCodeValue + "~"+eligibilityStatus+"~"+ eligibleAmount + "~" + salary+ "~" + nonEligibilityReasons+ "~" );
					//out.println(mainCodeValue + "~" + cardEligibility + "~" + eligibleAmount + "~" + nonEligibilityReasons);
				else if (RequestType != null	&& RequestType.equals("CCCEligibility"))
					out.println(mainCodeValue + "~" + cardEligibility+ "~" + nonEligibilityReasons+ "~" );
				else if (RequestType != null	&& RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD") )
					out.println(mainCodeValue + "~" + DebitAuthId+ "~" +ReturnDesc + "~"+ApprovalId + "~"+TrnRqUID + "~");
				else
					out.println(mainCodeValue + "~");	
		}else if (CategoryID.equals("1") && SubCategoryID.equals("5")) {
			WriteLog("inside SC RequestType=" +RequestType);
			if (RequestType != null && RequestType.equals("CARD_BALENQ")) {
				/*String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN where Parameter = '"+CardNumber.substring(0,6)+"' and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithColumnNames_Input>"+ 
				"<Option>APSelectWithColumnNames</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithColumnNames_Input>";*/
				
				params = "Parameter=="+CardNumber.substring(0,6);
				String qry = "select case when Card_Type='Credit' or Card_Type='Credit Card' then 'Credit' when  Card_Type='Debit' or Card_Type='Debit Card' then 'Debit' when Card_Type='Prepaid' or Card_Type='Prepaid Card' then 'Prepaid' else Card_Type end as card_type from USR_0_SRM_CARDS_BIN  with (nolock) where Parameter = :Parameter and IsActive = 'Y'";
				inputData = "<?xml version='1.0'?>"+
				"<APSelectWithNamedParam_Input>"+
				"<Option>APSelectWithNamedParam</Option>"+
				"<Query>"+ qry + "</Query>"+
				"<Params>"+ params + "</Params>"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
				"</APSelectWithNamedParam_Input>";
				
				if(blockCardNoInLogs)
					WriteLog("inputData-->" + inputData);
				outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				WriteLog("outputData-->" + outputData);
				//outputData=outputData.replaceAll("NULL"," ");
				xmlParserData.setInputXML((outputData));
				mainCodeData = xmlParserData.getValueOf("MainCode");
				if (mainCodeData.equals("0")) {
					cardType = xmlParserData.getValueOf("card_type");
					WriteLog("CARD_BALENQ cardType--->" + cardType);
				}
				sCatname = "BalanceEnq";
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+
				"<CardType>"+ cardType+ "</CardType>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+ 
				"</APAPMQPutGetMessage>\n";
			}else if(RequestType != null && RequestType.equals("SCCardEligibility")){
				sCatname = "CardServiceEligibility";
				WriteLog("inside SC sCatname=" +sCatname);
				WriteLog("inside SC PaymentType=" +PaymentType);
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<BankId>RAK</BankId>"+
				"<CIFID>"+ CustId+ "</CIFID>\n"+
				"<CardStatus>"+CardStatus+"</CardStatus>\n"+
				"<AvailableBalance>"+ AvailableBalance+ "</AvailableBalance>\n"+
				"<AvailableCashBalance>"+ AvailableCashBalance+ "</AvailableCashBalance>\n"+
				"<OverdueAmount>"+OverdueAmount+"</OverdueAmount>\n"+
				"<ServiceType>BalanceTransfer</ServiceType>\n"+
				"<ServiceSubType>SC</ServiceSubType>\n"+
				"<PaymentType>"+PaymentType+"</PaymentType>\n"+
				"<RequestFor>E</RequestFor>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			} else if(RequestType != null && RequestType.equals("SCEligibility")){
				String PaymentMode = request.getParameter("PaymentMode");
				String RakBankAccNumber = request.getParameter("RakBankAccNumber");
				if (PaymentMode.equalsIgnoreCase("Account Transfer"))
				{
					RakBankAccNumber = "<OtherBankAcctId>"+RakBankAccNumber+"</OtherBankAcctId>\n";
					PaymentMode = "AccountTransfer";
				}
				if (PaymentMode.equalsIgnoreCase("MCQ"))
					PaymentMode = "Cheque";
				if (PaymentMode.equalsIgnoreCase("FTS"))
					PaymentMode = "Swift";
				
				sCatname = "CardServiceEligibilityOB";
				WriteLog("inside SC sCatname=" +sCatname);
				sInputXML = "<?xml version=\"1.0\"?>\n" +
				"<APAPMQPutGetMessage>\n"+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+
				"<BankId>RAK</BankId>"+
				"<CIFID>"+ CustId+ "</CIFID>\n"+
				"<CardStatus></CardStatus>\n"+
				"<AvailableBalance></AvailableBalance>\n"+
				"<RequestAmount>"+RequestAmount.replaceAll(",","")+"</RequestAmount>\n"+
				"<ServiceType>BalanceTransfer</ServiceType>\n"+
				"<ServiceSubType>SC</ServiceSubType>\n"+
				"<PaymentType>"+PaymentType+"</PaymentType>\n"+
				"<PaymentMode>"+PaymentMode+"</PaymentMode>\n"+
				"<RequestFor>V</RequestFor>\n"+
				"<MarketingCode>"+MarketingCode+"</MarketingCode>\n"+
				RakBankAccNumber+
				"<BeneficiaryName>"+BeneficiaryName+"</BeneficiaryName>\n"+
				"<RequestType>"+ sCatname+ "</RequestType>\n"+
				"<SessionId>"	+ wfsession.getSessionId()+ "</SessionId>\n"+ 
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"+
				"</APAPMQPutGetMessage>\n";
			}else if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
				sCatname = "FUNDBLOCK";
				
				sInputXML = "<?xml version=\"1.0\"?>\n"	+ "<APAPMQPutGetMessage>\n"	+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+ 
				"<CardCRNNumber>"+CardCRNNumber+"</CardCRNNumber>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+ 
				"<TrnType>"+TrnType+"</TrnType>\n"+
				"<Amount>"+Amount.replaceAll(",","")+"</Amount>\n"+
				"<Currency>AED</Currency>\n"+
				"<CardExpiryDate>"+CardExpiryDate+"</CardExpiryDate>\n"+
				"<Remarks></Remarks>\n"+
				"<MerchantCode>106</MerchantCode>\n"+
				"<ProcessingCode>003000</ProcessingCode>\n"+
				"<FreeField1>6010</FreeField1>\n"+
				"<RequestType>"+sCatname+"</RequestType>\n"+ 
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"	+
				"</APAPMQPutGetMessage>\n";
			}
			String FormValue = "";
			if(blockCardNoInLogs)
				WriteLog("SC InputXML:-    " + sInputXML);
			try {
				//sMappOutPutXML= WFCallBroker.execute(sInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				if (RequestType != null && RequestType.equals("CARD_BALENQ") ) {
					//sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?> "+ "<EE_EAI_MESSAGE>"+ "<EE_EAI_HEADER>"+ "<MsgFormat>CARD_BALENQ</MsgFormat>"	+ "<MsgVersion>0000</MsgVersion>"+ "<RequestorChannelId>BPM</RequestorChannelId>"+ "<RequestorUserId>RAKUSER</RequestorUserId>"	+ "<RequestorLanguage>E</RequestorLanguage>"+ "<RequestorSecurityInfo>secure</RequestorSecurityInfo>"+ "<ReturnCode>0000</ReturnCode>"+ "<ReturnDesc>Success</ReturnDesc>"+ "<MessageId>123123453</MessageId>"+ "<Extra1>REP||SHELL.JOHN</Extra1>"	+ "<Extra2>2014-03-25T11:05:30.000+04:00</Extra2>"+ "</EE_EAI_HEADER>"+ "<CardBalInqResponse>"+ "<BankId>RAK</BankId>"+ "<CardNumber>4581xxxxxxxx2002</CardNumber>"	+ "<CardGroupInformation>"+ "<BalanceDetails>"+ "<BalanceType>TotalLimit</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>TotalOTB</BalanceType>"+ "<BalanceAmt>1000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashLimit</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>CashOTB</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LedgerOTB</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MaxLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>MinLoanAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>LastBalance</BalanceType>"	+ "<BalanceAmt>10000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>Bonus</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusCashAmount</BalanceType>"	+ "<BalanceAmt>00000000000.00</BalanceAmt>"	+ "</BalanceDetails>"+ "<BalanceDetails>"+ "<BalanceType>BonusDeclineAmount</BalanceType>"+ "<BalanceAmt>00000000000.00</BalanceAmt>"+ "</BalanceDetails><FreeField1>"+ "<FreeField2>"+ "<FreeField3>"+ "</CardGroupInformation>"+ "</CardBalInqResponse>"+ "</EE_EAI_MESSAGE>";
				}else if(RequestType != null && RequestType.equals("SCCardEligibility")){
					//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_SVC_ELIG_CHECK</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardServiceEligibilityCheckResponse><BankId>RAK</BankId><CIFID>FDSGS2313</CIFID><ACCNumber>12XXXX635</ACCNumber><CardNumber>1234XXXXXXXX1635</CardNumber><CardCRNNumber>12548556</CardCRNNumber><DeclaredSalary>200000.00</DeclaredSalary><Validations><ValidationType>BlacklistCheck</ValidationType><StatusCode>100</StatusCode><StatusDesc>Y</StatusDesc></Validations><Validations><ValidationType>DeliquencyCheck</ValidationType><StatusCode>101</StatusCode><StatusDesc>Bucket3</StatusDesc></Validations><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>BT</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>100</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>3500.00</EligibleAmount><EligiblePercentage>90</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>SC</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>00</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>4000.00</EligibleAmount><EligiblePercentage>95</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><FreeField1/><FreeField2/><FreeField3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardServiceEligibilityCheckResponse></EE_EAI_MESSAGE>";
				}else if(RequestType != null && RequestType.equals("SCEligibility")){
					//sMappOutPutXML="<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>CARD_SVC_ELIG_CHECK</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CardServiceEligibilityCheckResponse><BankId>RAK</BankId><CIFID>FDSGS2313</CIFID><ACCNumber>12XXXX635</ACCNumber><CardNumber>1234XXXXXXXX1635</CardNumber><CardCRNNumber>12548556</CardCRNNumber><DeclaredSalary>200000.00</DeclaredSalary><Validations><ValidationType>BlacklistCheck</ValidationType><StatusCode>100</StatusCode><StatusDesc>Y</StatusDesc></Validations><Validations><ValidationType>DeliquencyCheck</ValidationType><StatusCode>101</StatusCode><StatusDesc>Bucket3</StatusDesc></Validations><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>BT</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>100</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>3500.00</EligibleAmount><EligiblePercentage>90</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><ServiceDetails><ServiceType>BalanceTransfer</ServiceType><ServiceSubType>SC</ServiceSubType><EligibilityStatus>Y</EligibilityStatus><StatusCode>00</StatusCode><RejectReason>NA</RejectReason><EligibleAmount>4000.00</EligibleAmount><EligiblePercentage>95</EligiblePercentage><FreeField1/><FreeField2/></ServiceDetails><FreeField1/><FreeField2/><FreeField3/><FreeAmount1>0.00</FreeAmount1><FreeAmount2>0.00</FreeAmount2><FreeDate1>1900-01-01</FreeDate1><FreeDate2>1900-01-01</FreeDate2></CardServiceEligibilityCheckResponse></EE_EAI_MESSAGE>";
				}else if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
					/*sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
										+"<EE_EAI_MESSAGE>"
										+"<EE_EAI_HEADER>"
										+"<MsgFormat>FUND_BLOCK_ON_CREDIT_CARD</MsgFormat> "
										+"<MsgVersion>0001</MsgVersion> "
										+"<RequestorChannelId>INB</RequestorChannelId> "
										+"<RequestorUserId>RAKUSER</RequestorUserId> "
										+"<RequestorLanguage>E</RequestorLanguage> "
										+"<RequestorSecurityInfo>secure</RequestorSecurityInfo> "
										+"<ReturnCode>1111</ReturnCode> "
										+"<ReturnDesc>Success</ReturnDesc> "
										+"<MessageId>123123453</MessageId> "
										+"<Extra1>REP||SHELL.JOHN</Extra1> "
										+"<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2> "
										+"</EE_EAI_HEADER>	"
										+"<CreditCardFundBlock>"
										+"<BankId>RAK</BankId>"
										+"<CustId>Fxxxxx313</CustId>"
										+"<CardNumber>1221xxxxxxxx5546</CardNumber>"
										+"<ApprovalId>ApprovalId132DFS</ApprovalId>"
										+"<DebitAuthId>DebitAuthIddsfsdf43325</DebitAuthId>"
										+"<TrnRqUID>TrnRqUID1234</TrnRqUID>"
										+"<FreeField1/>"
										+"<FreeField2/>"
										+"<FreeAmount1>0.00</FreeAmount1>"
										+"<FreeAmount2>0.00</FreeAmount2>"
										+"<FreeDate1>YYYY-MM-DD</FreeDate1>"
										+"<FreeDate2>YYYY-MM-DD</FreeDate2>"
										+"</CreditCardFundBlock>"
										+"</EE_EAI_MESSAGE>";*/
				}
			}catch (Exception exp) {
					//bError=true;
				}
				WriteLog("SC output XML:-" + sMappOutPutXML);
				xmlParserData.setInputXML((sMappOutPutXML));
				String mainCodeValue = xmlParserData.getValueOf("ReturnCode");
				if (mainCodeValue.equals("0000")){
					if (RequestType != null	&& RequestType.equals("CARD_BALENQ") ) {
						int countBalanceDetails = xmlParserData.getNoOfFields("BalanceDetails");
						for (int i = 0; i < countBalanceDetails; i++) {
							balanceDetails = xmlParserData.getNextValueOf("BalanceDetails");
							xmlParserData2.setInputXML(balanceDetails);
							balanceType = xmlParserData2.getValueOf("BalanceType");
							if (balanceType.equals("TotalOTB")) {
								balanceAmt = xmlParserData2.getValueOf("BalanceAmt");
							}
							else if (balanceType.equals("CashOTB")) {
								availableCashBalance = xmlParserData2.getValueOf("BalanceAmt");
							}
						}
					}else if(RequestType != null && RequestType.equals("SCCardEligibility")){
						salary = xmlParserData.getValueOf("DeclaredSalary");
						int countServiceDetails = xmlParserData.getNoOfFields("ServiceDetails");
						for (int i = 0; i < countServiceDetails; i++) {
							serviceDetails = xmlParserData.getNextValueOf("ServiceDetails");
							xmlParserData2.setInputXML(serviceDetails);
							subServiceType = xmlParserData2.getValueOf("ServiceSubType");
							if (subServiceType.equals("SC")) {
								eligibleAmount = xmlParserData2.getValueOf("EligibleAmount");
								eligibilityStatus = xmlParserData2.getValueOf("EligibilityStatus");
								
							}
						}
						//nonEligibilityReasons = xmlParserData2.getValueOf("RejectReason");
						xmlParserData.setInputXML(sMappOutPutXML);
						int countValidations = xmlParserData.getNoOfFields("Validations");
						for (int i = 0; i < countValidations; i++) {
							validationDetails = xmlParserData.getNextValueOf("Validations");
							xmlParserData2.setInputXML(validationDetails);
							validationStatusCode = xmlParserData2.getValueOf("StatusCode");
							if (!validationStatusCode.equals("0000")) {
								nonEligibilityReasons+= xmlParserData2.getValueOf("StatusCode")+"-";
							}
						}
						if(nonEligibilityReasons.length()>0)
							nonEligibilityReasons = nonEligibilityReasons.substring(0,nonEligibilityReasons.lastIndexOf("-"));
					}else if(RequestType != null && RequestType.equals("SCEligibility")){
						int countServiceDetails = xmlParserData.getNoOfFields("ServiceDetails");
						for (int i = 0; i < countServiceDetails; i++) {
							serviceDetails = xmlParserData.getNextValueOf("ServiceDetails");
							xmlParserData2.setInputXML(serviceDetails);
							subServiceType = xmlParserData2.getValueOf("ServiceSubType");
							if (subServiceType.equals("SC")) {
								cardEligibility = xmlParserData2.getValueOf("EligibilityStatus");
							}
						}
						xmlParserData.setInputXML(sMappOutPutXML);
						int countValidations = xmlParserData.getNoOfFields("Validations");
						for (int i = 0; i < countValidations; i++) {
							validationDetails = xmlParserData.getNextValueOf("Validations");
							xmlParserData2.setInputXML(validationDetails);
							validationStatusCode = xmlParserData2.getValueOf("StatusCode");
							if (!validationStatusCode.equals("0000")) {
								nonEligibilityReasons+= xmlParserData2.getValueOf("StatusCode")+"-";
							}
						}
						if(nonEligibilityReasons.length()>0)
							nonEligibilityReasons = nonEligibilityReasons.substring(0,nonEligibilityReasons.lastIndexOf("-"));
					}else if(RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")){
						 DebitAuthId = xmlParserData.getValueOf("DebitAuthId");
						 ReturnDesc = xmlParserData.getValueOf("ReturnDesc");
						 ApprovalId = xmlParserData.getValueOf("ApprovalId");
						 TrnRqUID = xmlParserData.getValueOf("TrnRqUID");
					}
				} else {
					
					WriteLog("Inside SRMIntegration.jsp Balance of Transfer failed");
				}
				out.clear();
				if (RequestType != null	&& RequestType.equals("CARD_BALENQ") )
					out.println(mainCodeValue + "~" + balanceAmt+"~"+availableCashBalance);
				else if (RequestType != null	&& RequestType.equals("SCCardEligibility"))
					out.println(mainCodeValue + "~"+eligibilityStatus+"~"+ eligibleAmount + "~" + salary+ "~" + nonEligibilityReasons+ "~" );
					//out.println(mainCodeValue + "~" + cardEligibility + "~" + eligibleAmount + "~" + nonEligibilityReasons);
				else if (RequestType != null	&& RequestType.equals("SCEligibility"))
					out.println(mainCodeValue + "~" + cardEligibility+ "~" + nonEligibilityReasons+ "~" );
				else if (RequestType != null	&& RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD") )
					out.println(mainCodeValue + "~" + DebitAuthId+ "~" +ReturnDesc + "~"+ApprovalId + "~"+TrnRqUID + "~");
				else
					out.println(mainCodeValue + "~");	
		}
   		
	}else if (WSNAME.equals("Q1") || WSNAME.equals("Q4")) {
		if (CategoryID.equals("1") && (SubCategoryID.equals("2") || SubCategoryID.equals("4") || SubCategoryID.equals("5"))) {
			if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
				if(SubCategoryID.equals("2"))
				{
					MerchantCode=" ";
					ProcessingCode="000000";
					FreeField1=" ";
				}
				if(SubCategoryID.equals("5"))
				{
					MerchantCode="106";
					ProcessingCode="003000";
					FreeField1="6010";
				}
				else
				{
					if (MerchantCode.equals("0400"))
					{
						ProcessingCode="010000";
						FreeField1="6010";
					}
					else
					{
						ProcessingCode="000000";
						FreeField1="5999";
					}
				}
				DebitAuthId = request.getParameter("DebitAuthId");
				ApprovalId = request.getParameter("ApprovalId");
				TrnRqUID = request.getParameter("TrnRqUID");
				sCatname = "FUNDBLOCK";
				sInputXML = "<?xml version=\"1.0\"?>\n"	+ "<APAPMQPutGetMessage>\n"	+ 
				"<Option>SRM_APMQPutGetMessage</Option>\n"+
				"<UserID>"+ wfsession.getUserName()+ "</UserID>\n"+
				"<CustId>"+ CustId+ "</CustId>\n"+ 
				"<CardCRNNumber>"+CardCRNNumber+"</CardCRNNumber>\n"+
				"<CardNumber>"+ CardNumber+ "</CardNumber>\n"+ 
				"<TrnType>"+TrnType+"</TrnType>\n"+
				"<Amount>"+Amount.replaceAll(",","")+"</Amount>\n"+
				"<Currency>AED</Currency>\n"+
				"<CardExpiryDate>"+CardExpiryDate+"</CardExpiryDate>\n"+
				"<DebitAuthId>"+DebitAuthId+"</DebitAuthId>\n"+
				"<TrnRqUID>"+TrnRqUID+"</TrnRqUID>\n"+
				"<ApprovalId>"+ApprovalId+"</ApprovalId>\n"+
				"<Remarks></Remarks>\n"+
				"<MerchantCode>"+MerchantCode+"</MerchantCode>\n"+
				"<ProcessingCode>"+ProcessingCode+"</ProcessingCode>\n"+
				"<FreeField1>"+FreeField1+"</FreeField1>\n"+
				"<RequestType>"+sCatname+"</RequestType>\n"+ 
				"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>\n"+
				"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>\n"	+
				"</APAPMQPutGetMessage>\n";
			}
			if(blockCardNoInLogs)
				WriteLog("BT/BCC InputXML:-    " + sInputXML);
			try {
				//sMappOutPutXML= WFCallBroker.execute(sInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
				sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
				if (RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")) {
					/*sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
										+"<EE_EAI_MESSAGE>"
										+"<EE_EAI_HEADER>"
										+"<MsgFormat>FUND_BLOCK_ON_CREDIT_CARD</MsgFormat> "
										+"<MsgVersion>0001</MsgVersion> "
										+"<RequestorChannelId>INB</RequestorChannelId> "
										+"<RequestorUserId>RAKUSER</RequestorUserId> "
										+"<RequestorLanguage>E</RequestorLanguage> "
										+"<RequestorSecurityInfo>secure</RequestorSecurityInfo> "
										+"<ReturnCode>1111</ReturnCode> "
										+"<ReturnDesc>Success</ReturnDesc> "
										+"<MessageId>123123453</MessageId> "
										+"<Extra1>REP||SHELL.JOHN</Extra1> "
										+"<Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2> "
										+"</EE_EAI_HEADER>	"
										+"<CreditCardFundBlock>"
										+"<BankId>RAK</BankId>"
										+"<CustId>Fxxxxx313</CustId>"
										+"<CardNumber>1221xxxxxxxx5546</CardNumber>"
										+"<ApprovalId>ApprovalId32DFS</ApprovalId>"
										+"<DebitAuthId>DebitAuthId43324</DebitAuthId>"
										+"<TrnRqUID>TrnRqUID1212</TrnRqUID>"
										+"<FreeField1/>"
										+"<FreeField2/>"
										+"<FreeAmount1>0.00</FreeAmount1>"
										+"<FreeAmount2>0.00</FreeAmount2>"
										+"<FreeDate1>YYYY-MM-DD</FreeDate1>"
										+"<FreeDate2>YYYY-MM-DD</FreeDate2>"
										+"</CreditCardFundBlock>"
										+"</EE_EAI_MESSAGE>";*/
				}
			}catch (Exception exp) {
					//bError=true;
			}
				WriteLog("BT output XML:-" + sMappOutPutXML);
				xmlParserData.setInputXML((sMappOutPutXML));
				String mainCodeValue = xmlParserData.getValueOf("ReturnCode");
				if (mainCodeValue.equals("0000")){
					if(RequestType != null && RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD")){
						 DebitAuthId = xmlParserData.getValueOf("DebitAuthId");
						 ReturnDesc = xmlParserData.getValueOf("ReturnDesc");
						 ApprovalId = xmlParserData.getValueOf("ApprovalId");
						 TrnRqUID = xmlParserData.getValueOf("TrnRqUID");
					}
				}	
				out.clear();				
				if (RequestType != null	&& RequestType.equals("FUND_BLOCK_ON_CREDIT_CARD"))
				{
				out.println(mainCodeValue + "~" + DebitAuthId+ "~" +ReturnDesc + "~"+ApprovalId + "~"+TrnRqUID + "~");
				}
			}					
	}else{
	}
	
%>