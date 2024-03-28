
<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.WFXmlList" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.WFXmlResponse" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>

<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>


<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>



<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<%

        WriteLog("inside loadcpfgriddetails.jsp");
		
		String query="";
		String params="";
		String inputData="";
		String outputData="";
		//XMLParser xmlParserData=null;
		//XMLParser objXmlParser=null;  
		
		XMLParser parsergetlist = null;
        com.newgen.wfdesktop.xmlapi.WFXmlResponse wfXmlResponse = null;
		WFXmlList wfxmllist = null;
		String mainCodeValuestate="";
		String returnValue="";
		String subXML="";
		String cpfDetails="";
		
		
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
		String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
		WriteLog("WINAME Esapi---> "+WINAME_Esapi);
		String WINAME=WINAME_Esapi;
		
		query = "SELECT insertionOrderId,EMAIL_OR_SMS,SENT_DATE,RECIPIENT,COPIED_IDs,DELIVERY_STATUS,CATEGORY,RESPONSE_DATE,RESPONSE_TAT_IN_DAYS,WSNAME,REMARKS,COMM_SUBJECT,COMM_CONTENT FROM usr_0_CPF_AO_COMM_History_Grid with (nolock) WHERE WI_NAME=:WINAME order by insertionOrderId";
		params="WINAME=="+WINAME;
		WriteLog("query usr_0_CPF_AO_COMM_History_Grid -->"+query);
		
		inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("inputData for usr_0_CPF_AO_COMM_History_Grid -->"+inputData);
		
		//outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
		
		WriteLog("outputData for usr_0_CPF_AO_COMM_History_Grid -->"+outputData);
		
		parsergetlist = new XMLParser(outputData);
		 if (parsergetlist.getValueOf("MainCode").equals("0")) 
		 {
                wfXmlResponse = new com.newgen.wfdesktop.xmlapi.WFXmlResponse(outputData);
				wfxmllist = wfXmlResponse.createList("Records", "Record");
				wfxmllist.reInitialize(true);
				while (wfxmllist.hasMoreElements()) {
                    cpfDetails = cpfDetails + wfxmllist.getVal("insertionOrderId").trim() + "~" + wfxmllist.getVal("EMAIL_OR_SMS").trim() + "~"
                            + wfxmllist.getVal("SENT_DATE").trim() + "~" + wfxmllist.getVal("RECIPIENT").trim() + "~"
                            + wfxmllist.getVal("COPIED_IDs").trim() + "~" + wfxmllist.getVal("DELIVERY_STATUS").trim() + "~"
							+ wfxmllist.getVal("CATEGORY").trim() + "~" + wfxmllist.getVal("RESPONSE_DATE").trim() + "~" + wfxmllist.getVal("RESPONSE_TAT_IN_DAYS").trim() + "@@@";

                    wfxmllist.skip(true);
                }
            
			//return cpfDetails;	
				WriteLog("list for usr_0_CPF_AO_COMM_History_Grid -->"+cpfDetails);
				out.println(cpfDetails);
		 }	
		 
		    
%>
