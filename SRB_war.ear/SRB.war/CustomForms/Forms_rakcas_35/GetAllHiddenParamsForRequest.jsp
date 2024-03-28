<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : Account Opening
//Module                     : Fetch Account Numbers
//File Name					 : FetchAccounts.jsp
//Author                     : Aishwarya Gupta
// Date written (DD/MM/YYYY) : 10-Mar-2015
//Description                : File to fetch accounts from middleware via invoking wfcustom
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
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<%
	
	try
	{
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ServiceRequest"), 1000, true) );    
		String ServiceRequest_Type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		//for esapi special character- aditiya.rai
		WriteLog("orignal value without replace - "+ServiceRequest_Type);
		String ServiceRequestType=ServiceRequest_Type.replace("&#x28;","(");
		WriteLog("after replacing &#x28; to (  "+ServiceRequestType);
		ServiceRequestType=ServiceRequestType.replace("&#x29;",")");
		WriteLog("after replacing &#x29; to )  "+ServiceRequestType);
		ServiceRequestType=ServiceRequestType.replace("&#x2f;","/");
		WriteLog("after replacing &#x2f; to / "+ServiceRequestType);
		ServiceRequestType=ServiceRequestType.replace("&#x3a;",":");
		WriteLog("after replacing &#x3a; to / "+ServiceRequestType);
		
		String params = "";
		ServiceRequestType=ServiceRequestType.replaceAll(new String("Â".getBytes("UTF-8"), "UTF-8"), "");
		if (ServiceRequestType != null) {ServiceRequestType=ServiceRequestType.replace("'","''");}
		WriteLog("ServiceRequestType"+ServiceRequestType);		
		String Query="SELECT DubplicateWorkitemVisible,printDispatchRequired,CSMApprovalRequire,CardSettlementProcessingRequired,"+
					  "OriginalRequiredatOperations,DuplicateCheckLogic,AccountIndicator,FetchClosedAcct,OriginalRequiredbyOPSforProcessing,ARCHIVALPATH,IsSMSMailSent,AccToBeFetched,Application_FormCode,isEMIDExpiryChkReq,MANDATE_NONMANDATE,ROUTECATEGORY,StaleDateRestrictionDays,isMultipleApprovalReq from USR_0_SRB_SUBCATEGORY with(nolock) WHERE upper(subCategoryName)=:subCategoryName";  // changed by angad to fetch accountindicator and fetchclosed account param
	    params = "subCategoryName=="+ServiceRequestType.toUpperCase();
		WFCustomXmlResponse WFCustomXmlResponseData=null;
		String printDispatchRequired="";
		String CSMApprovalRequire="";
		String DubplicateWorkitemVisible="";
		String CardSettlementProcessingRequired="";
		String OriginalRequiredatOperations="";
		String DuplicateCheckLogic="";
		String AccountIndicator="";
		String FetchClosedAcct="";
		String OriginalRequiredbyOPSforProcessing="";
		String ARCHIVALPATH="";
		String IsSMSMailSent="";
		String AccToBeFetched="";
		String Application_FormCode="";
		String isEMIDExpiryChkReq="";
		String MANDATE_NONMANDATE="";
		String ROUTECATEGORY="";
		String StaleDateRestrictionDays="";
		String isMultipleApprovalReq="";
		String inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	

		
		WriteLog("Input For Get All hidden params for Service request-->"+inputData);		
		String outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		WriteLog("Output For Get All hidden params for Service request-->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");
		
		int recordcountLogical_Name = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		if(maincode.equals("0"))
		{
			if(recordcountLogical_Name==1)
			{
				DubplicateWorkitemVisible=WFCustomXmlResponseData.getVal("DubplicateWorkitemVisible");
				printDispatchRequired=WFCustomXmlResponseData.getVal("printDispatchRequired");
				CSMApprovalRequire=WFCustomXmlResponseData.getVal("CSMApprovalRequire");
				CardSettlementProcessingRequired=WFCustomXmlResponseData.getVal("CardSettlementProcessingRequired");
				OriginalRequiredatOperations=WFCustomXmlResponseData.getVal("OriginalRequiredatOperations");
				DuplicateCheckLogic=WFCustomXmlResponseData.getVal("DuplicateCheckLogic");
				OriginalRequiredbyOPSforProcessing=WFCustomXmlResponseData.getVal("OriginalRequiredbyOPSforProcessing");
				AccountIndicator=WFCustomXmlResponseData.getVal("AccountIndicator");  // changed by angad to fetch accountindicator and fetchclosed account param
				FetchClosedAcct=WFCustomXmlResponseData.getVal("FetchClosedAcct");  // changed by angad to fetch accountindicator and fetchclosed account param
				ARCHIVALPATH=WFCustomXmlResponseData.getVal("ARCHIVALPATH");
				IsSMSMailSent=WFCustomXmlResponseData.getVal("IsSMSMailSent");
				AccToBeFetched=WFCustomXmlResponseData.getVal("AccToBeFetched");
				Application_FormCode=WFCustomXmlResponseData.getVal("Application_FormCode");
				isEMIDExpiryChkReq=WFCustomXmlResponseData.getVal("isEMIDExpiryChkReq");
				MANDATE_NONMANDATE=WFCustomXmlResponseData.getVal("MANDATE_NONMANDATE");
				ROUTECATEGORY=WFCustomXmlResponseData.getVal("ROUTECATEGORY");
				StaleDateRestrictionDays=WFCustomXmlResponseData.getVal("StaleDateRestrictionDays");
				isMultipleApprovalReq=WFCustomXmlResponseData.getVal("isMultipleApprovalReq");
				WriteLog("printDispatchRequired "+printDispatchRequired);
				WriteLog("CSMApprovalRequire "+CSMApprovalRequire);
				WriteLog("CardSettlementProcessingRequired "+CardSettlementProcessingRequired);
				WriteLog("OriginalRequiredatOperations "+OriginalRequiredatOperations);
				WriteLog("DuplicateCheckLogic "+DuplicateCheckLogic);
				WriteLog("AccountIndicator "+AccountIndicator);
				WriteLog("FetchClosedAcct "+FetchClosedAcct);
				WriteLog("OriginalRequiredbyOPSforProcessing "+OriginalRequiredbyOPSforProcessing);
				WriteLog("ARCHIVALPATH "+ARCHIVALPATH);
				WriteLog("IsSMSMailSent "+IsSMSMailSent);
				WriteLog("AccToBeFetched "+AccToBeFetched);
				WriteLog("Application_FormCode "+Application_FormCode);
				WriteLog("isEMIDExpiryChkReq "+isEMIDExpiryChkReq);
				WriteLog("MANDATE_NONMANDATE "+MANDATE_NONMANDATE);
				WriteLog("ROUTECATEGORY "+ROUTECATEGORY);
				WriteLog("StaleDateRestrictionDays "+StaleDateRestrictionDays);
				WriteLog("isMultipleApprovalReq "+isMultipleApprovalReq);
				out.clear();
				out.print("0#"+DubplicateWorkitemVisible+"~"+printDispatchRequired+"~"+CSMApprovalRequire+"~"+CardSettlementProcessingRequired+"~"+OriginalRequiredatOperations+"~"+DuplicateCheckLogic+"~"+AccountIndicator+"~"+FetchClosedAcct+"~"+OriginalRequiredbyOPSforProcessing+"~"+ARCHIVALPATH+"~"+IsSMSMailSent+"~"+AccToBeFetched+"~"+Application_FormCode+"~"+isEMIDExpiryChkReq+"~"+MANDATE_NONMANDATE+"~"+ROUTECATEGORY+"~"+StaleDateRestrictionDays+"~"+isMultipleApprovalReq);	 // changed by angad to fetch accountindicator and fetchclosed account param
			} 
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}
	catch(Exception e) 
	{
			out.clear();
			out.print("-1");
	}
%>



