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

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../CU_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<TITLE> <%=ESAPI.encoder().encodeForSQL(new OracleCodec(), ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) )!=null?ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) ):"")%>: Decision History</TITLE>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style>
	@import url("/CU/webtop/en_us/css/docstyle.css");
</style>
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
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
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	//String WINAME=request.getParameter("WINAME");
	String WINAME=WINAME_Esapi;
	WriteLog("WINAME_Esapi:"+WINAME_Esapi);
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String hist_table = "USR_0_CU_WIHISTORY";
	String colname="";
	String colvalues="'";
	String strQuery="";
	String strInputXML="";
	String strOutputXML="";
	String mainCodeValue="";
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;	
	String subXML="";
	String wsname ="";
	String decision ="";
	Date datetime=null;
	String actiondatetime ="";
	String remarks ="";
	String rejectReasons ="";
	String username ="";
	String params = "";
	//For reject reasons
	HashMap<String,String> RejectReasonsMap = new HashMap<String, String>();
		
	strQuery="select item_code,Item_Desc from USR_0_CU_Error_Desc_Master with(nolock) where isactive=:isactive order by id asc";
	params = "isactive==Y";
	
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	//strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("outputXML exceptions-->"+strOutputXML);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((strOutputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	
	int records=0;
	records=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));

	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			RejectReasonsMap.put(objWorkList.getVal("item_code"),objWorkList.getVal("Item_Desc"));	
		}			
	}
	objWorkList=null;
	
	strQuery="select id,wsname,decision,actiondatetime,remarks,username,checklistData from "+hist_table+" where WINAME=:WINAME and actiondatetime is not null order by id desc";		
	params = "WINAME=="+WINAME;
	
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	//strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	//WriteLog("strInputXML hist_table \n"+strInputXML);
	strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((strOutputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	//WriteLog("strOutputXML hist_table \n"+strOutputXML);
	
	if(mainCodeValue.equals("0"))
	{
		int recordcount = Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Account Opening Details'><td colspan=4 align=center class='EWLabelRB2'><b>Decision History</b></td>
</tr>
</table>
<br>
<table width=100% border='1'>
	<tr width=100% >
		<td colspan = 3 style="float:right;" valign=center><img style="padding-right:30px" src='\CU\webtop\images\rak-logo.gif'></td>
	</tr>
	<tr width=100% >
		<td class='EWNormalGreenGeneral1' width=30% align=center valign=center><b>CIF Update Request Number: <%=WINAME%></b></td>
	</tr>
</table>

<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'>
		
		<td width=11% style="text-align:center" class='EWLabelRB2'><b>&nbsp;&nbsp;&nbsp;&nbsp;DateTime&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
		<td width=8% style="text-align:center" class='EWLabelRB2'><b>&nbsp;Workstep&nbsp;</b></td>
		<td width=11% style="text-align:center;min-width: 100px;" class='EWLabelRB2'><b>&nbsp;User Name&nbsp;</b></td>
		<td width=8% style="text-align:center" class='EWLabelRB2'><b>&nbsp;Decision&nbsp;</b></td>
		<td width=26% style="text-align:center;min-width: 150px;" class='EWLabelRB2'><b>&nbsp;Reject Reasons&nbsp;</b></td>
		<td width=28% style="text-align:center" class='EWLabelRB2'><b>Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
	</tr>
<%
		SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
		
		
		objWorkList = xmlParserData.createList("Records","Record"); 
		
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{	
			datetime = formatter.parse(objWorkList.getVal("actiondatetime"));
			actiondatetime = sdf.format(datetime);
			wsname = objWorkList.getVal("wsname");
			username = objWorkList.getVal("username");
			decision = objWorkList.getVal("decision");
			rejectReasons = objWorkList.getVal("checklistData");
			remarks = objWorkList.getVal("remarks");
			//WriteLog("\nrejectReasons in history.jsp "+rejectReasons);
			String 	rejectReasonsinRow="";		
			if (rejectReasons==null||rejectReasons.equalsIgnoreCase("NULL")||rejectReasons.equals("")) rejectReasonsinRow="&nbsp;";
			else
			{
				//Reject Reasons in format
				//015#004#018#002
					
				String strReasons[] = rejectReasons.split("#");
				for(int count=0;count<strReasons.length;count++)
				{
					String desc=strReasons[count].split(":")[0];
					if(count==0)
						rejectReasonsinRow=RejectReasonsMap.get(strReasons[count]);
					else
						rejectReasonsinRow+="<br><br>"+RejectReasonsMap.get(strReasons[count]);						
				//WriteLog("\nrejectReasonsinRow in for in history.jsp "+rejectReasonsinRow);
				}
			}
			//WriteLog("\nrejectReasonsinRow in history.jsp "+rejectReasonsinRow);
			if (rejectReasonsinRow==null||rejectReasonsinRow.equalsIgnoreCase("NULL")||rejectReasonsinRow.equals("")) rejectReasonsinRow="&nbsp;";
			//WriteLog("\nrejectReasonsinRow second in history.jsp "+rejectReasonsinRow);
			if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.equals("")) remarks="&nbsp;";
			
%>
		<tr>
			<td width=11% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=actiondatetime%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=wsname%></b></td>
			<td width=11% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=username%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=decision%></b></td>
			<td width=26% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=rejectReasonsinRow%></b></td>
			<td width=28% style="text-align:center;max-width:200px;word-wrap:break-word;padding:10px 3px 10px 3px;" class='EWNormalGreenGeneral1'>				
					<b ><%=remarks%></b>				
			</td>
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