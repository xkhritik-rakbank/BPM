<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : Account Opening
//Module                     : Fetch Account Numbers
//File Name					 : GetAllHiddenParamsForRequest.jsp
//Author                     : Sivakumar
// Date written (DD/MM/YYYY) : 03-Jul-2018
//Description                : File to fetch values of all hidden fields related to each subcategory type
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TF_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<%
	
	try
	{
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("request_type", request.getParameter("ServiceRequest"), 1000, true) );
		String ServiceRequestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		ServiceRequestType = ServiceRequestType.replace("&#x2f;","/");
		WriteLog("GetAllHiddenParamsForRequest jsp: ServiceRequestType after esapi: "+ServiceRequestType);
	
		//String ServiceRequestType=request.getParameter("ServiceRequest");
		String params = "";
		ServiceRequestType=ServiceRequestType.replaceAll(new String("Â".getBytes("UTF-8"), "UTF-8"), "");
		if (ServiceRequestType != null) {ServiceRequestType=ServiceRequestType.replace("'","''");}
		WriteLog("ProductRequestType: "+ServiceRequestType);		
		String Query="SELECT DubplicateWorkitemVisible,CSMApprovalRequire,CardSettlementProcessingRequired,"+
					  "OriginalRequiredatOperations,DuplicateCheckLogic,AccountIndicator,FetchClosedAcct,OriginalRequiredbyTFforProcessing,ARCHIVALPATH,IsSMSMailSent,AccToBeFetched,Application_FormCode,isEMIDExpiryChkReq,CallBackRequire,DocumentApproverRequire,ROUTECATEGORY,DocumentDispatchRequired,UTCDetailsFlag from USR_0_TF_SUBCATEGORY with(nolock) WHERE upper(subCategoryName)=:subCategoryName";  // changed by angad to fetch accountindicator and fetchclosed account param
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
		String OriginalRequiredbyTFforProcessing="";
		String ARCHIVALPATH="";
		String IsSMSMailSent="";
		String AccToBeFetched="";
		String Application_FormCode="";
		String isEMIDExpiryChkReq="";
		String CallBackRequire="";
		String DocumentApproverRequire="";
		String ROUTECATEGORY="";
		String DocumentDispatchRequired="";
		String UTCDetailsFlag="";
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
				WriteLog("DubplicateWorkitemVisible "+DubplicateWorkitemVisible);
				CSMApprovalRequire=WFCustomXmlResponseData.getVal("CSMApprovalRequire");
				WriteLog("CSMApprovalRequire "+CSMApprovalRequire);
				CardSettlementProcessingRequired=WFCustomXmlResponseData.getVal("CardSettlementProcessingRequired");
				WriteLog("CardSettlementProcessingRequired "+CardSettlementProcessingRequired);
				OriginalRequiredatOperations=WFCustomXmlResponseData.getVal("OriginalRequiredatOperations");
				WriteLog("OriginalRequiredatOperations "+OriginalRequiredatOperations);
				DuplicateCheckLogic=WFCustomXmlResponseData.getVal("DuplicateCheckLogic");
				WriteLog("DuplicateCheckLogic "+DuplicateCheckLogic);
				OriginalRequiredbyTFforProcessing=WFCustomXmlResponseData.getVal("OriginalRequiredbyTFforProcessing");
				WriteLog("OriginalRequiredbyTFforProcessing "+OriginalRequiredbyTFforProcessing);
				AccountIndicator=WFCustomXmlResponseData.getVal("AccountIndicator");  // changed by angad to fetch accountindicator and fetchclosed account param
				WriteLog("AccountIndicator "+AccountIndicator);
				FetchClosedAcct=WFCustomXmlResponseData.getVal("FetchClosedAcct");  // changed by angad to fetch accountindicator and fetchclosed account param
				WriteLog("FetchClosedAcct "+FetchClosedAcct);
				ARCHIVALPATH=WFCustomXmlResponseData.getVal("ARCHIVALPATH");
				WriteLog("ARCHIVALPATH "+ARCHIVALPATH);
				IsSMSMailSent=WFCustomXmlResponseData.getVal("IsSMSMailSent");
				WriteLog("IsSMSMailSent "+IsSMSMailSent);
				AccToBeFetched=WFCustomXmlResponseData.getVal("AccToBeFetched");
				WriteLog("AccToBeFetched "+AccToBeFetched);
				Application_FormCode=WFCustomXmlResponseData.getVal("Application_FormCode");
				WriteLog("Application_FormCode "+Application_FormCode);
				isEMIDExpiryChkReq=WFCustomXmlResponseData.getVal("isEMIDExpiryChkReq");
				WriteLog("isEMIDExpiryChkReq "+isEMIDExpiryChkReq);
				CallBackRequire=WFCustomXmlResponseData.getVal("CallBackRequire");
				WriteLog("CallBackRequire "+CallBackRequire);
				DocumentApproverRequire=WFCustomXmlResponseData.getVal("DocumentApproverRequire");
				WriteLog("DocumentApproverRequire "+DocumentApproverRequire);
				ROUTECATEGORY=WFCustomXmlResponseData.getVal("ROUTECATEGORY");				
				WriteLog("ROUTECATEGORY "+ROUTECATEGORY);
				DocumentDispatchRequired=WFCustomXmlResponseData.getVal("DocumentDispatchRequired");				
				WriteLog("DocumentDispatchRequired "+DocumentDispatchRequired);
				UTCDetailsFlag=WFCustomXmlResponseData.getVal("UTCDetailsFlag");				
				WriteLog("UTCDetailsFlag "+UTCDetailsFlag);
				out.clear();
				out.print("0#"+DubplicateWorkitemVisible+"~"+CSMApprovalRequire+"~"+CardSettlementProcessingRequired+"~"+OriginalRequiredatOperations+"~"+DuplicateCheckLogic+"~"+AccountIndicator+"~"+FetchClosedAcct+"~"+OriginalRequiredbyTFforProcessing+"~"+ARCHIVALPATH+"~"+IsSMSMailSent+"~"+AccToBeFetched+"~"+Application_FormCode+"~"+isEMIDExpiryChkReq+"~"+CallBackRequire+"~"+DocumentApproverRequire+"~"+ROUTECATEGORY+"~"+DocumentDispatchRequired+"~"+UTCDetailsFlag);	 // changed by angad to fetch accountindicator and fetchclosed account param
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



