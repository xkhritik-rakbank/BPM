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
<%@ page import="com.newgen.custom.*" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<HTML>
<HEAD>
<%
String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");		
WINAME_Esapi = WINAME_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
%>
<TITLE> <%=WINAME_Esapi%>: Decision History</TITLE>
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
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
	String WINAME=WINAME_Esapi;
	String hist_table = "USR_0_TT_WIHISTORY";
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
	
	//For reject reasons
	HashMap<String,String> RejectReasonsMap = new HashMap<String, String>();
		
	strQuery="select item_code,Item_Desc from USR_0_TT_Error_Desc_Master with(nolock) where isactive='Y' order by id asc";
	strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
	strOutputXML = WFCallBroker.execute(strInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	//WriteLog("outputXML exceptions-->"+strOutputXML);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((strOutputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	
	int records=0;
	records=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

	if(mainCodeValue.equals("0"))
	{
		for(int k=0; k<records; k++)
		{
			subXML = xmlParserData.getNextValueOf("Record");
			objXmlParser = new XMLParser(subXML);
			RejectReasonsMap.put(objXmlParser.getValueOf("item_code"),objXmlParser.getValueOf("Item_Desc"));	
		}			
	}
	//select id,wsname,decision,actiondatetime,remarks,username,checklistData from USR_0_TT_WIHISTORY where wsname='CSO_Branch' order by id desc
	strQuery="select id,wsname,decision,actiondatetime,remarks,username,checklistData from "+hist_table+" with(nolock) where WINAME='"+WINAME+"' and actiondatetime is not null order by actiondatetime desc";
	strInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + strQuery + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		WriteLog("strInputXML hist_table \n"+strInputXML);
	strOutputXML = WFCallBroker.execute(strInputXML, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
	
	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((strOutputXML));
	mainCodeValue = xmlParserData.getValueOf("MainCode");
	WriteLog("strOutputXML\n"+strOutputXML);
	
	if(mainCodeValue.equals("0"))
	{
		int recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		subXML = xmlParserData.getNextValueOf("Record");
		objXmlParser = new XMLParser(subXML);
		
			
%>
<table border='1' cellspacing='1' cellpadding='0' width=100% >
	<tr class='EWHeader' width=100% class='EWLabelRB2'><input type='text' name='Header' readOnly size='24' style='display:none' value='Account Opening Details'><td colspan=4 align=center class='EWLabelRB2'><b>Decision History</b></td>
</tr>
</table>
<br>
<table width=100% border='1'>
	<tr width=100% >
		<td colspan = 3 style="float:right;" valign=center><img style="padding-right:30px" src='\webdesktop\webtop\images\rak-logo.gif'></td>
	</tr>
	<tr width=100% >
		<td class='EWNormalGreenGeneral1' width=30% align=center valign=center><b>Telegraphic Transfer Request Number: <%=WINAME%></b></td>
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
				}
			}
			if (rejectReasonsinRow==null||rejectReasonsinRow.equalsIgnoreCase("NULL")||rejectReasonsinRow.equals("")) rejectReasonsinRow="&nbsp;";
			if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.equals("")) remarks="&nbsp;";
			
%>
		<tr>
			<td width=11% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=actiondatetime%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=wsname%></b></td>
			<td width=11% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=username%></b></td>
			<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=decision%></b></td>
			<td width=26% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=rejectReasonsinRow%></b></td>
			<td width=28% style="text-align:center;max-width:200px;word-wrap:break-word;padding:10px 3px 10px 3px;" class='EWNormalGreenGeneral1'>
				<!--<div float=left; style="width: 400px; height: 50px; word-wrap: break-word; overflow-x: hidden; overflow-y: auto;">-->
					<b ><%=remarks%></b>
				<!--</div>-->
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

