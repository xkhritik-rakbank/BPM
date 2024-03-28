<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank RBL
//Module                     : Request-Introduction 
//File Name					 : History.jsp
//Author                     : Rahul Agrawal
// Date written (DD/MM/YYYY) : 14-Aug-2018
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
<%@ include file="Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<%
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			logger.info("WINAME_Esapi. req "+request.getParameter("WINAME"));
			logger.info("WINAME_Esapi "+WINAME_Esapi);
			WINAME_Esapi = WINAME_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
%>
<TITLE> <%=WINAME_Esapi%>: Decision History</TITLE>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style>
	@import url("/RBL/webtop/en_us/css/docstyle.css");
</style>
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<script>
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :           Application Projects
//Project                             :           Rakbank  Account-Opening-Automation//Date Written           
//Date Modified                       :           14-08-2018
//Author                              :           Rahul Agrawal
//Description                		  :          

//***********************************************************************************//
function CloseWindow()
{
	window.parent.close();
}

</script>
<%	
	String WINAME=WINAME_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String hist_table = "USR_0_RBL_WIHISTORY";
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
	String OSWsname = "";
	String decision ="";
	Date datetime=null;
	String actiondatetime ="";
	String remarks ="";
	String rejectReasons ="";
	String username ="";
	String params = "";
	//For reject reasons
	HashMap<String,String> RejectReasonsMap = new HashMap<String, String>();
		
	strQuery="select item_code,Item_Desc from USR_0_RBL_ERROR_DESC_MASTER with(nolock) where isactive=:isactive order by id asc";
	params = "isactive==Y";
	
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	//strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//logger.info("outputXML exceptions-->"+strOutputXML);
	
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
	
	strQuery="select id,wsname,actual_wsname,decision,actiondatetime,remarks,username,rejectreasons from "+hist_table+" where WINAME=:WINAME and actiondatetime is not null order by actiondatetime desc";		
	params = "WINAME=="+WINAME;
	
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";

	logger.info("strInputXML hist_table \n"+strInputXML);
	strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((strOutputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	logger.info("strOutputXML hist_table \n"+strOutputXML);
	
	if(mainCodeValue.equals("0"))
	{
		int recordcount = Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Account Opening Details'><td colspan=4 align=center class='EWLabelRB2'><b>Decision History</b></td>
</tr>
</table>
<br>

<div style="height: 300px; overflow: auto;">
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
			//OSWsname = objWorkList.getVal("wsname");
			username = objWorkList.getVal("username");
			decision = objWorkList.getVal("decision");
			rejectReasons = objWorkList.getVal("rejectreasons");
			remarks = objWorkList.getVal("remarks");
			//logger.info("\nrejectReasons in history.jsp "+rejectReasons);
			//logger.info("\nusername in history.jsp "+username);
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
				//logger.info("\nrejectReasonsinRow in for in history.jsp "+rejectReasonsinRow);
				}
			}
			//logger.info("\nrejectReasonsinRow in history.jsp "+rejectReasonsinRow);
			if (rejectReasonsinRow==null||rejectReasonsinRow.equalsIgnoreCase("NULL")||rejectReasonsinRow.equals("")) rejectReasonsinRow="&nbsp;";
			//logger.info("\nrejectReasonsinRow second in history.jsp "+rejectReasonsinRow);
			if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.equals("")) remarks="&nbsp;";
			
			// Replacing CCCOMMAAA with , from Remarks
			if (remarks != null) {remarks=remarks.replace("CCCOMMAAA",",");}
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
		logger.info("Error fetching history. Please contact Administrator.");
	}
%>
	</table>
	</div>
	<br>
	<table>
		<tr>
			<td><input name='Close' type='button' value='Close' onclick="CloseWindow()" class='EWButtonRB' style='width:60px' ></td>
		</tr>
	</table>
</body>
</html>