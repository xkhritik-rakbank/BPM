<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : Account Opening
//Module                     : Get Expiry Time From Master
//File Name					 : GetExpiryTimeFromMaster.jsp
//Author                     : Ankit Arya
// Date written (DD/MM/YYYY) : 24-Mar-2017
//Description                : File to fetch Expiry Time from Master USR_0_SRB_AUTOEXPIRY
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
		String ServiceRequestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		ServiceRequestType=ServiceRequestType.replaceAll(new String("Â".getBytes("UTF-8"), "UTF-8"), "");
		if (ServiceRequestType != null) {ServiceRequestType=ServiceRequestType.replace("'","''");}
		String params = "";
		WriteLog("ServiceRequestType"+ServiceRequestType);		
		String Query="SELECT UndeliveredDocuments,RectificationPendingBranch,"+
					  "DiscrepantPhysicalDocRejected,ProcessedPhysicalDocPending from usr_0_srb_autoexpiry WHERE upper(ServiceRequestType)=:subCategoryName";
		params = "subCategoryName=="+ServiceRequestType.toUpperCase();			  
		WFCustomXmlResponse WFCustomXmlResponseData=null;
		String UndeliveredDocuments="";
		String RectificationPendingBranch="";
		String DiscrepantPhysicalDocRejected="";
		String ProcesssedPhysicalDocPending="";
		
		
		String inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
		
		WriteLog("Input For Get Expiry Time for Service request-->"+inputData);		
		String outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		WriteLog("Output For Get Logical workstep Name From Table-->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");
		
		int recordcountLogical_Name = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		if(maincode.equals("0"))
		{
			if(recordcountLogical_Name==1)
			{
				UndeliveredDocuments=WFCustomXmlResponseData.getVal("UndeliveredDocuments");
				RectificationPendingBranch=WFCustomXmlResponseData.getVal("RectificationPendingBranch");
				DiscrepantPhysicalDocRejected=WFCustomXmlResponseData.getVal("DiscrepantPhysicalDocRejected");
				ProcesssedPhysicalDocPending=WFCustomXmlResponseData.getVal("ProcessedPhysicalDocPending");
				WriteLog("UndeliveredDocuments "+UndeliveredDocuments);
				WriteLog("RectificationPendingBranch "+RectificationPendingBranch);
				WriteLog("DiscrepantPhysicalDocRejected "+DiscrepantPhysicalDocRejected);
				WriteLog("ProcesssedPhysicalDocPending "+ProcesssedPhysicalDocPending);
				out.clear();
				out.print("0#"+UndeliveredDocuments+"~"+RectificationPendingBranch+"~"+DiscrepantPhysicalDocRejected+"~"+ProcesssedPhysicalDocPending);	
			}
			else
			{
				out.clear();
				out.print("00#00");
			}
		}
		else
		{
			out.clear();
			out.print("-1#-1");
		}
	}
	catch(Exception e) 
	{
			out.clear();
			out.print("-1#-1");
	}
%>



