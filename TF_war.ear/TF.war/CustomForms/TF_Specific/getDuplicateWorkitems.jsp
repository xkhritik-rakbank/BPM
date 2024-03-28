<%@ include file="Log.process"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%!
	public static String getStackTrace(final Throwable throwable) {
        final StringWriter sw = new StringWriter();
        final PrintWriter pw = new PrintWriter(sw, true);
        throwable.printStackTrace(pw);
        return sw.getBuffer().toString();
    }
	
	public static String APSelect(String strEngineName, String strSessionId, String Query, String params) 
	{			
		String sInputXML = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ Query + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ strEngineName + "</EngineName>"+
		"<SessionId>"+ strSessionId + "</SessionId>"+
		"</APSelectWithNamedParam_Input>";

		WriteLog("APSelectWithNamedParam_Input sInputXML="+sInputXML);
		return sInputXML;
	}
%>
<%
    String outputData="";
	String inputData="";
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlList objWorkList=null;
	try{
		
			String URLDecoderCIFID=URLDecoder.decode(request.getParameter("CIFID"));
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderCIFID, 1000, true) );
			String URLDecoderCIFID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String URLDecoderServiceRequestCode=URLDecoder.decode(request.getParameter("ServiceRequestCode"));
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderServiceRequestCode, 1000, true) );
			String URLDecoderServiceRequestCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String URLDecoderreqType=URLDecoder.decode(request.getParameter("reqType"));
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderreqType, 1000, true) );
			String URLDecoderreqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String URLDecoderAmount=URLDecoder.decode(request.getParameter("Amount"));
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderAmount, 1000, true) );
			String URLDecoderAmount_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String URLDecoderCurrency=URLDecoder.decode(request.getParameter("Currency"));
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderCurrency, 1000, true) );
			String URLDecoderCurrency_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			String URLDecoderApplicationDate=URLDecoder.decode(request.getParameter("ApplicationDate"));
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderApplicationDate, 1000, true) );
			String URLDecoderApplicationDate_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			String URLDecoderWI_NAME=URLDecoder.decode(request.getParameter("WI_NAME"));
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWI_NAME, 1000, true) );
			String URLDecoderWI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			
		
		/*
		String cif_id=URLDecoder.decode(request.getParameter("CIFID")).replace("&amp;","&");
	 		String SRequestCode=URLDecoder.decode(request.getParameter("ServiceRequestCode")).replace("&amp;","&");
	 		String reqType=URLDecoder.decode(request.getParameter("reqType")).replace("&amp;","&");
			String sAmount=URLDecoder.decode(request.getParameter("Amount")).replace("&amp;","&");
	 		String sCurrency=URLDecoder.decode(request.getParameter("Currency")).replace("&amp;","&");
			String ApplicationDate=URLDecoder.decode(request.getParameter("ApplicationDate")).replace("&amp;","&");
	 		String WI_NAME=URLDecoder.decode(request.getParameter("WI_NAME")).replace("&amp;","&");
		
		*/
		
		WriteLog("\nInside TF GetDuplicateWorkitem.jsp\n");
		String cif_id=URLDecoderCIFID_Esapi.replace("&amp;","&");
		if (cif_id != null) {cif_id=cif_id.replace("'","''");}
		String SRequestCode=URLDecoderServiceRequestCode_Esapi.replace("&amp;","&");
		if (SRequestCode != null) {SRequestCode=SRequestCode.replace("'","''");}
		String reqType=URLDecoderreqType_Esapi.replace("&amp;","&");
		String sAmount=URLDecoderAmount_Esapi.replace("&amp;","&");
		if (sAmount != null) {sAmount=sAmount.replace("'","''");}
		String sCurrency=URLDecoderCurrency_Esapi.replace("&amp;","&");
		if (sCurrency != null) {sCurrency=sCurrency.replace("'","''");}
		String ApplicationDate=URLDecoderApplicationDate.replace("&amp;","&");
		if (ApplicationDate != null) {ApplicationDate=ApplicationDate.replace("'","''");}
		
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String IntroductionDateTime = "";
		String intoducedBy = "";
		String SOLID = "";
		String Query="";
		String WI_NAME=URLDecoderWI_NAME_Esapi.replace("&amp;","&");
		if (WI_NAME != null) {WI_NAME=WI_NAME.replace("'","''");};
		String returnValues="";
		String InputXML="";
		String params = "";	
		String temp_table="";	
		String AppDateFinalStart="";
		String AppDateFinalEnd="";
		String AppDateCondition="";
		if (ApplicationDate!=null && !ApplicationDate.equalsIgnoreCase(""))
		{
			String AppDateTemp [] = ApplicationDate.split("/");
			AppDateFinalStart=AppDateTemp[2]+"-"+AppDateTemp[1]+"-"+AppDateTemp[0]+" 00:00:00.000";
			AppDateFinalEnd=AppDateTemp[2]+"-"+AppDateTemp[1]+"-"+AppDateTemp[0]+" 23:59:00.000";
			AppDateCondition=" and ApplicationDate between '"+AppDateFinalStart+"' and '"+AppDateFinalEnd+"'";
		}		
		
		WriteLog("\nInside TF GetDuplicateWorkitem for reqType :"+reqType+" & CIFID :"+cif_id+" & ServiceRequestCode :"+SRequestCode);
		if(reqType.equalsIgnoreCase("EventDetailsGrid"))
		{
			Query="SELECT q.IntroductionDateTime as DateOfEvent,e.ApplicationDate,e.Product_Category as ProductCategory,e.Product_Type as ProductType,q.Introducedby as UserName,e.Amount,e.Currency,e.WI_NAME from RB_TF_EXTTABLE e with (nolock), QUEUEVIEW q with(nolock) where e.CIF_ID=:CIF_ID and e.ServiceRequestCode=:ServiceRequestCode and Amount=:Amount and Currency=:Currency and e.WI_NAME !=:WI_NAME and q.ActivityName != 'CSO' and e.WI_NAME = q.ProcessInstanceId and q.IntroductionDateTime between getdate()-180 and getdate() "+AppDateCondition+" order by q.IntroductionDateTime";
			
			params="CIF_ID=="+cif_id+"~~ServiceRequestCode=="+SRequestCode+"~~WI_NAME=="+WI_NAME+"~~Amount=="+sAmount+"~~Currency=="+sCurrency;
			
		}
		
	        //temp_table="<table id='duplicateWorkItemID' width='100%' border=1><TBODY><tr width=100% class='EWLabelRB2' bgcolor= '#990033'><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=5 align=center class='EWLabelRB2'><font color='white' size='4'>Duplicate Workitems</font></td></tr>";
			
		    //temp_table=temp_table+"<tr class='EWNormalGreenGeneral1' bgcolor= '#990033'><th class='EWLabelRB2' bgcolor= '#990033'><b><font color='white'>Work-item Number</font></b></th><th class='EWLabelRB2' bgcolor= '#990033'><b><font color='white'>CIF ID</font></b></th><th class='EWLabelRB2' bgcolor= '#990033'><b><font color='white'>Initiated Date</font></b></th><th class='EWLabelRB2' bgcolor= '#990033'><b><font color='white'>Initiated By</font></b></th><th class='EWLabelRB2' bgcolor= '#990033'><b><font color='white'>SOL ID</font></b></th></tr>";
			
		
		//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
				
		InputXML=APSelect(sCabName,sSessionId,Query,params);
			
		WriteLog("Query For GetDuplicateWorkitem Input-->"+InputXML);		
		outputData = WFCustomCallBroker.execute(InputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		WriteLog("GetDuplicateWorkitem Output-->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");	
		int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		int j=0;
		if(maincode.equals("0") && recordcount>0)
		{	
			objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					WriteLog("jj-->"+j);
					if (reqType.equals("EventDetailsGrid"))
					{
						if(j!=0)
						{
							returnValues = returnValues + "|" +objWorkList.getVal("DateOfEvent") + "~" + objWorkList.getVal("ApplicationDate") + "~" + objWorkList.getVal("ProductCategory") + "~" + objWorkList.getVal("ProductType")  + "~" + objWorkList.getVal("UserName")  + "~" + objWorkList.getVal("Amount")  + "~" + objWorkList.getVal("Currency")  + "~" + objWorkList.getVal("WI_NAME"); 
						}
						else
						{
							returnValues = objWorkList.getVal("DateOfEvent") + "~" + objWorkList.getVal("ApplicationDate") + "~" +objWorkList.getVal("ProductCategory") + "~" + objWorkList.getVal("ProductType")  + "~" + objWorkList.getVal("UserName")  + "~" + objWorkList.getVal("Amount")  + "~" + objWorkList.getVal("Currency")  + "~" + objWorkList.getVal("WI_NAME"); 
						}
						//WriteLog("returnValues Is-->"+returnValues);
						
						//out.clear();
						//out.println(temp_table+"~"+"0");
						//out.println(returnValues);
						j=j+1;
					}			
				}
				//temp_table=temp_table+"</TBODY></TABLE>";
				//WriteLog("Final Return Result "+temp_table);
				//returnValues=returnValues+temp_table;				
				WriteLog("Final Return Result returnValues "+returnValues);
				out.clear();
				out.println(returnValues);
		}
		else if(maincode.equals("0") && recordcount==0)
		{
			out.clear();
			out.println("");
		}
		else
		{
			out.clear();
			out.println("-1");
		}
	}
	catch(Exception e)
	{
		WriteLog("Exception in getting duplicate workitem list "+e);
		WriteLog("Exception in getting duplicate workitem list Stack Trace: "+getStackTrace(e));
		out.clear();
		out.println("-1");
	}
%>