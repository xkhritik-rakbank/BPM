
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

<%@ page pageEncoding="utf-8"%>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

		
<%

        WriteLog("inside ContentDetails.jsp");
		
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
		String mailDetails="";
		String frommail="";
		String tomail="";
		String mailcc="";
		String mailsubject="";
		String mailmessage="";
		
		
		String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
		String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
		WriteLog("WINAME Esapi---> "+WINAME_Esapi);
		String WINAME=WINAME_Esapi;
		
		String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sno"), 1000, true) );
		String srno_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
		WriteLog("WINAME Request.getparameter---> "+request.getParameter("sno"));
		WriteLog("WINAME Esapi---> "+srno_Esapi);
		String srnum=srno_Esapi;
		
		//query = "SELECT Sr_No,EMAIL_OR_SMS,SENT_DATE,RECIPIENT,COPIED_IDs,FROM_ID,DELIVERY_STATUS,CATEGORY,RESPONSE_DATE,RESPONSE_TAT_IN_DAYS,CONTENT,WSNAME,REMARKS FROM USR_0_CPF_COMM_HISTORY_GRID with (nolock) WHERE WI_NAME=:WINAME order by Sr_No";
		query = "SELECT FROM_ID,RECIPIENT,COPIED_IDs,COMM_SUBJECT,COMM_CONTENT from usr_0_CPF_AO_COMM_History_Grid with(nolock) where WI_NAME=:WINAME and insertionOrderId=:srnum ";
		//params="WINAME=="+WINAME+"&srnum=="+srnum;
		params="WINAME=="+WINAME+"~~srnum=="+srnum;
		
		WriteLog("query WFMAILQUEUETABLE -->"+query);
		
		inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" +  wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("inputData for WFMAILQUEUETABLE -->"+inputData);
		
		//outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
		outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);
		
		WriteLog("outputData for WFMAILQUEUETABLE -->"+outputData);
		
		parsergetlist = new XMLParser(outputData);
		 if (parsergetlist.getValueOf("MainCode").equals("0")) 
		 {
                wfXmlResponse = new com.newgen.wfdesktop.xmlapi.WFXmlResponse(outputData);
				wfxmllist = wfXmlResponse.createList("Records", "Record");
				wfxmllist.reInitialize(true);
				while (wfxmllist.hasMoreElements()) {
                   
					frommail=wfxmllist.getVal("FROM_ID");
					tomail=wfxmllist.getVal("RECIPIENT");
					mailcc=wfxmllist.getVal("COPIED_IDs");
					mailsubject=wfxmllist.getVal("COMM_SUBJECT");
					mailmessage=wfxmllist.getVal("COMM_CONTENT");
					
					
                    wfxmllist.skip(true);
                }
				%>
				
<HTML>
<head>
	<meta http-equiv="content-Type" content="text/html;charset=UTF-8">
	<title>Content Details</title>
	<h2>Content Detail</h2>
</head>
<body scroll="no" style="overflow:hidden">
	
		<tr>
			<td width=15% style="text-align:center" class='EWNormalGreenGeneral1'><font color="Red"><B>From Mail: </B></font><b><%=frommail%></b></td><br></br>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><font color="Red"><B>To Mail:</B></font><b><%=tomail%></b></td><br></br>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><font color="Red"><B>Mail CC:</B></font><b><%=mailcc%></b></td><br></br>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><font color="Red"><B>Mail Subject:</B></font><b><%=mailsubject%></b></td><br></br>
			<td width=30% style="text-align:center" class='EWNormalGreenGeneral1' dir="rtl" lang="ar"><font color="Red"><B>Mail Message:</B></font><b><%=mailmessage%></b></td><br></br>
			
		</tr>
				
		

</body>
</HTML>		
            
	<%		//return cpfDetails;	
			/*	WriteLog("list for WFMAILQUEUETABLE -->"+frommail);
				WriteLog("list for WFMAILQUEUETABLE -->"+tomail);
				WriteLog("list for WFMAILQUEUETABLE -->"+mailcc);
				WriteLog("list for WFMAILQUEUETABLE -->"+mailsubject);
				WriteLog("list for WFMAILQUEUETABLE -->"+mailmessage);
				out.println(frommail);
				out.println(tomail);
				out.println(mailcc);
				out.println(mailsubject);
				out.println(mailmessage);  */
		 }	
		 
		    
%>