<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank RMT
//Module                     : Request-Introduction 
//File Name					 : History.jsp
//Author                     : Nikita Singhal
// Date written (DD/MM/YYYY) : 12-JAN-2018
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

<HTML>
<HEAD>

<%
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAMEEsapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME: "+WINAMEEsapi);
			
%>

<TITLE> <%=WINAMEEsapi%>: Decision History</TITLE>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<style>
	@import url("/TF/webtop/en_us/css/docstyle.css");
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
	String WINAME=WINAMEEsapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	String hist_table = "USR_0_tf_WIHISTORY";
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
		
	strQuery="select item_code,Item_Desc from usr_0_tf_error_desc_Master with(nolock) where isactive=:isactive order by id asc";
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
	
	strQuery="select id,wsname,actual_wsname,decision,actiondatetime,remarks,username,rejectreasons from "+hist_table+" where WINAME=:WINAME and actiondatetime is not null order by actiondatetime desc";		
	params = "WINAME=="+WINAME;
	//for reject reason null output on from end by aditya.rai
	strQuery=strQuery.replaceAll("&#x23;","#");
	
	strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";

	WriteLog("strInputXML hist_table \n"+strInputXML);
	strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((strOutputXML));
	mainCodeValue = xmlParserData.getVal("MainCode");
	WriteLog("strOutputXML hist_table \n"+strOutputXML);
	
	if(mainCodeValue.equals("0"))
	{
		int recordcount = Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Account Opening Details'><td colspan=4 align=center class='EWLabelRB2'><b>Decision History</b></td>
</tr>
</table>
<br>

<div style="height: 320px; overflow: auto; width: 790px">
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
			//for reject reason null output on from end by aditya.rai
			rejectReasons=rejectReasons.replaceAll("&#x23;","#");
			remarks = objWorkList.getVal("remarks");
			remarks = remarks.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			WriteLog("\nremarks in history.jsp "+remarks);
			WriteLog("\nrejectReasons in history.jsp after change aditya.rai "+rejectReasons);
			WriteLog("\nusername in history.jsp "+username);
			String 	rejectReasonsinRow="";
			/*if(OSWsname.equalsIgnoreCase("CSO_Omniscan"))
			{
				wsname = "CSO_Omniscan";
			}*/
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
				WriteLog("\nrejectReasonsinRow in for in history.jsp "+rejectReasonsinRow);
				}
			}
			WriteLog("\nrejectReasonsinRow in history.jsp "+rejectReasonsinRow);
			if (rejectReasonsinRow==null||rejectReasonsinRow.equalsIgnoreCase("NULL")||rejectReasonsinRow.equals("")) rejectReasonsinRow="&nbsp;";
			WriteLog("\nrejectReasonsinRow second in history.jsp "+rejectReasonsinRow);
			if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.equals("")){ 
				remarks="&nbsp;";
			}else{
				remarks=remarks.replaceAll("lt;", "<");
				remarks=remarks.replaceAll("gt;", ">");
				remarks=remarks.replaceAll("AMPNDCHAR","&");
				remarks=remarks.replaceAll("PPPLUSSS","+");
				remarks=remarks.replaceAll("CCCOMMAAA",",");
				remarks=remarks.replaceAll("PPPERCENTTT","%");
			}
			
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
	</div>
	<br>
	<table>
		<tr>
			<td><input name='Close' type='button' value='Close' onclick="CloseWindow()" class='EWButtonRB' style='width:60px' ></td>
		</tr>
	</table>
</body>
</html>