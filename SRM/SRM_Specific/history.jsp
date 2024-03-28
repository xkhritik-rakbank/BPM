<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application �Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : History.jsp
//Author                     : Deepti Sharma, Aishwarya Gupta
// Date written (DD/MM/YYYY) : 09-Apr-2014
//Description                : Form to fetch the data from history table on the basis of workitem id
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>


<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>



<HTML>
<HEAD>
<TITLE> <%=request.getParameter("WINAME")%>: Decision History</TITLE>
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<!--<link rel="stylesheet" type="text/css" href = "\webdesktop\webtop\en_us\css\docstyle.css">-->
</HEAD>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<script>
function CloswWindow()
{
	window.parent.close();
}

</script>
<%
	String WINAME=request.getParameter("WINAME");
	//out.println("WINAME "+WINAME);
	String hist_table = request.getParameter("hist_table");
	String Category = request.getParameter("Category");
	String SubCategory = request.getParameter("SubCategory");
	String keyID = request.getParameter("keyID");
	WriteLog("hist_table"+hist_table);
	String sCabName=null;
	String sSessionId = null;
	String params="";
	String sJtsIp = null;
	int iJtsPort = 0;
	
	String colname="";
	String colvalues="'";
	String temp[]=null;
	String Query="";
	String inputData="";
	String outputData="";
	String mainCodeValue="";
	XMLParser xmlParserData=null;
	XMLParser xmlParserData2=null;
	XMLParser objXmlParser=null;
	String subXML="";
	String WI="";
	String catIndex="";
	String subCatIndex = "";
	String wsname ="";
	String actual_wsname="";
	String decision ="";
	String strid ="";
	String actiondatetime ="";
	Date d=null;
	String remarks ="";
	String username ="";
	String Query2 ="";
	String inputData2 ="";
	String outputData2 ="";
	String Approved_CB_Amt ="";
	
	
	/*Query="select id,catIndex,subCatIndex,wsname,actual_wsname,decision,actiondatetime,remarks,username from "+hist_table+" where WINAME='"+WINAME+"' and actiondatetime is not null order by actiondatetime desc";
		WriteLog("history query="+Query);
	inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";*/
	
	params = "WINAME=="+WINAME;
	Query="select id,catIndex,subCatIndex,wsname,actual_wsname,decision,actiondatetime,remarks,username from "+hist_table+" with (nolock) where WINAME=:WINAME and actiondatetime is not null order by actiondatetime desc";
	inputData = "<?xml version='1.0'?>"+
	"<APSelectWithNamedParam_Input>"+
	"<Option>APSelectWithNamedParam</Option>"+
	"<Query>"+ Query + "</Query>"+
	"<Params>"+ params + "</Params>"+
	"<EngineName>"+ wfsession.getEngineName()+ "</EngineName>"+
	"<SessionId>"+ wfsession.getSessionId()+ "</SessionId>"+
	"</APSelectWithNamedParam_Input>";
	
	WriteLog("inputData history-->"+inputData);		
	outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	WriteLog("outputData history-->"+outputData);
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((outputData));
	WriteLog("before maincodevalue");
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	WriteLog("after maincodevalue="+mainCodeValue);
	int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	WriteLog("after recordcount="+recordcount);
	
	if(mainCodeValue.equals("0"))
	{
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		catIndex = objXmlParser.getValueOf("catIndex");
		subCatIndex = objXmlParser.getValueOf("subCatIndex");
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='SRM-Service Request Module Details'><td colspan=4 align=center class='EWLabelRB2'><b>Service Request Module </b></td>
</tr>
</table>
<table width=100% border='1'>
<tr width=100% ><td colspan = 3 align=right valign=center><img src='\webdesktop\webtop\images\rak-logo.gif'></td></tr>

<tr width=100% ><td class='EWNormalGreenGeneral1' width=30%  align=center><b align=center>Category: <%=Category%></b></td><td class='EWNormalGreenGeneral1' width=30% align=center valign=center><b>Sub Category: <%=SubCategory%></b></td><td class='EWNormalGreenGeneral1' width=40% align='center' valign=center><b>Card Number: <%=keyID%></b></td></tr></table>

<table border='1' cellspacing='1' cellpadding='0' width=100% >
<tr class='EWHeader' width=100% class='EWLabelRB2'>
<input type='text' name='Header' readOnly size='24' style='display:none' value=''>
<td width=20% align=left class='EWLabelRB2'><b>DateTime</b></td>
<td width=10% align=left class='EWLabelRB2'><b>Workstep</b></td>
<td width=15% align=left class='EWLabelRB2'><b>Username</b></td>
<td width=18% align=left class='EWLabelRB2'><b>Decision</b></td>
<td width=37% align=left class='EWLabelRB2'><b>Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
</tr>
<%
		SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
		for(int k=0; k<recordcount; k++)
		{	
			if (k!=0) subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			catIndex = objXmlParser.getValueOf("catIndex");
			subCatIndex = objXmlParser.getValueOf("subCatIndex");
			wsname = objXmlParser.getValueOf("wsname");
			if(wsname.equalsIgnoreCase("SRM_Decision")) continue;
			actual_wsname = objXmlParser.getValueOf("actual_wsname");
			decision = objXmlParser.getValueOf("decision");
			strid = objXmlParser.getValueOf("id");
			//actiondatetime = objXmlParser.getValueOf("actiondatetime");
			d = formatter.parse(objXmlParser.getValueOf("actiondatetime"));
			actiondatetime = sdf.format(d);
			remarks = objXmlParser.getValueOf("remarks");
			username = objXmlParser.getValueOf("username");
						
			if (decision==null||decision.equalsIgnoreCase("NULL")||decision.length()==0) decision="&nbsp;";
			if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.length()==0) remarks="&nbsp;";
			
%>
<tr>
<td width=20% align=left class='EWNormalGreenGeneral1'><b><%=actiondatetime%></b></td>
<td width=10% align=left class='EWNormalGreenGeneral1'><b><%=actual_wsname%></b></td>
<td width=15% align=left class='EWNormalGreenGeneral1'><b><%=username%></b></td>
<td width=10% align=left class='EWNormalGreenGeneral1'><b><%=decision%></b></td>
<td width=45% align=left class='EWNormalGreenGeneral1'><b><%=remarks%></b></td>
</tr>
<%
			
		}
	}
	else
	{
		WriteLog("error in history");
	}
%>
</table>
<table><tr><td><input name='Close' type='button' value='Close' onclick="CloswWindow()" class='EWButtonRB' style='width:60px' ></td></tr></table>
</body>
</html>
