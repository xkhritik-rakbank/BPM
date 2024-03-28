<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : History.jsp
//Author                     : Shubham Ruhela
// Date written (DD/MM/YYYY) : 27-Jan-2016
//Description                : Form to fetch the data from history table on the basis of workitem id
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*"%>
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

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<HTML>
<HEAD>
<TITLE> <%=ESAPI.encoder().encodeForSQL(new OracleCodec(), ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) )!=null?ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) ):"")%>: Decision History</TITLE>
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' onload="document.getElementById('logo').scrollIntoView();">
<script>
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

 

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :           
//Author                              :           Amandeep
//Description                		  :          

//***********************************************************************************//
function CloseWindow()
{
	window.parent.close();
}

</script>
<%
	WriteLog("===========================Inside History.jsp =======================");
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
	String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("History.jsp: WINAME: "+request.getParameter("WINAME"));
	WriteLog("History.jsp: WINAME_Esapi: "+WINAME_Esapi);
	
	String WINAME=WINAME_Esapi;
	WriteLog(WINAME);
	String hist_table = "USR_0_TL_WIHISTORY";
	String colname="";
	String colvalues="'";
	String strQuery="";
	String strInputXML="";
	String strOutputXML="";
	String mainCodeValue="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String subXML="";
	String wsname ="";
	String decision ="";
	Date datetime=null;
	String actiondatetime ="";
	String remarks ="";
	String rejectReasons ="";
	String username ="";
	
	strQuery="select id,wsname,decision,actiondatetime,remarks,username,checklistData from "+hist_table+" where WINAME='"+WINAME+"' and actiondatetime is not null order by id desc";		
	strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	WriteLog(strInputXML);
	//strOutputXML = WFCallBroker.execute(strInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	strOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), strInputXML);
	WriteLog("output xml"+strOutputXML);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((strOutputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	WriteLog(strOutputXML);
	
	if(mainCodeValue.equals("0"))
	{
		int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Trade License Details'><td colspan=4 align=center class='EWLabelRB2'><b>Decision History</b></td>
</tr>
</table>
<br>
<table width=100% border='1'>
	<tr width=100% >
		<td colspan = 3 style="float:right;" valign=center><img id="logo" style="padding-right:30px" src='\webdesktop\webtop\images\rak-logo.gif'></td>
	</tr>
	<tr width=100% >
		<td class='EWNormalGreenGeneral1' width=30% align=center valign=center><b>Trade License Request Number: <%=WINAME%></b></td>
	</tr>
</table>

<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'>
		
		<td width=16% style="text-align:center" class='EWLabelRB2'><b>DateTime</b></td>
		<td width=13% style="text-align:center" class='EWLabelRB2'><b>Workstep</b></td>
		<td width=13% style="text-align:center" class='EWLabelRB2'><b>User Name</b></td>
		<td width=11% style="text-align:center" class='EWLabelRB2'><b>Decision</b></td>
		<td width=15% style="text-align:center" class='EWLabelRB2'><b>Reject Reasons</b></td>
		<td width=32% style="text-align:center" class='EWLabelRB2'><b>Remarks</b></td>
	</tr>
<%

		SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");

		for(int k=0; k<recordcount; k++)
		{	
			if(k!=0)
				subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			datetime = formatter.parse(objXmlParser.getValueOf("actiondatetime"));
			actiondatetime = sdf.format(datetime);
			wsname = objXmlParser.getValueOf("wsname");
			username = objXmlParser.getValueOf("username");
			decision = objXmlParser.getValueOf("decision");
			rejectReasons = objXmlParser.getValueOf("checklistData");
			remarks = objXmlParser.getValueOf("remarks");
			
			/*if(!wsname.equalsIgnoreCase("OPS_Maker") && !wsname.equalsIgnoreCase("OPS_Checker") && !wsname.equalsIgnoreCase("Rejected_TL") && !wsname.equalsIgnoreCase("Error")) {
				username = "System";
			}*/
			
%>
		<tr>
			<td width=16%  style="text-align:center"  class='EWNormalGreenGeneral1'><b><%=actiondatetime%></b></td>
			<td width=13%  style="text-align:center"  class='EWNormalGreenGeneral1'><b><%=wsname%></b></td>
			<td width=13%  style="text-align:center"  class='EWNormalGreenGeneral1'><b><%=username%></b></td>
			<td width=11%  style="text-align:center"  class='EWNormalGreenGeneral1'><b><%=decision%>&nbsp;</b></td>
			<td width=15%  style="text-align:center"  class='EWNormalGreenGeneral1'><b><%=rejectReasons%>&nbsp;</b></td>
			<td width=32%  class='EWNormalGreenGeneral1'><div float=left; style=" height: 50px; word-wrap: break-word; overflow-x: hidden; overflow-y: auto;"><b><%=remarks%></b></div></td>
		</tr>
<%
		}
	}
	else
	{
		WriteLog("Error fetching history. Please contact Administrator.");
	}
%>
	</table>
	<br>
	<table>
		<tr>
			<td><input name='Close' type='button' value='Close' onclick="CloseWindow()" class='EWButtonRB' style='width:60px' ></td>
		</tr>
	</table>
</body>
</html>

