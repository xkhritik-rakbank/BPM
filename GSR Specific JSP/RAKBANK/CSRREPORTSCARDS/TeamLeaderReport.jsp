<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : REPORTS
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 16-Mar-2008
//Description                : for cards volume Reports .
//------------------------------------------------------------------------------------------------------------------------------------>
<%@ include file="../../CSRProcessSpecific/Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
<%@ page import="java.text.*"%>
<%@ page import= "java.util.Properties" %>

<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>

<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>	
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


 <%	

DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
java.util.Date date=new java.util.Date();
String CurrDate=dateFormat.format(date);

%>
<%
  response.setHeader("Cache-Control","no-store"); //HTTP 1.1
  response.setHeader("Pragma","no-cache"); //HTTP 1.0
  response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

%>

<%
String Query="";
String xml="";
String sInputXML="";
String sInputXML1="";
String sOutputXML="";
String sOutputXML1="";
String sCabname="";
String sSessionId="";
String sJtsIp="";
int iJtsPort= 0;
String sFields="";
int tolCount1 =0;
String groupName = "";
String query="";
String query1="";
String userName="";
int userindex=0;
String actid = "";
String time1 ="";
String actnid="";
String val = "";
String sel_dte_to = "";
String sel_dte_from = "";
String sel_mon = "";
String sel_yr = "";
int index_id=0;
int i=0;
String  profix = "";
String suffix = "";
String processDefId = "";
String prsuffx = "";

	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: branchCode: "+branchCode);
	
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("reportType", request.getParameter("reportType"), 1000, true) );
	String reportType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: reportType: "+reportType);


int count = 0;
int count4sum=0;
boolean bError=false;
try{
/*sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();*/
WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
sCabname = wDCabinetInfo.getM_strCabinetName();
sSessionId = wDUserInfo.getM_strSessionId();
sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
}
catch(Exception ignore){
		bError=true;
	}	
	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); 
		out.println("</script>");
	}

DateFormat dtFormat = new SimpleDateFormat( "dd-MM-yyyy"+ " hh:mm:ss");
String currentdate = dtFormat.format(new java.util.Date());

// getting data from request....

	String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
	//WriteLog("Integration jsp: fnl_date_to cmpl: "+fnl_date_to);
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Dateto);
	
	String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
	WriteLog("Integration jsp: fnl_date_from tl: "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Datefrom: TL   replace "+fnl_Datefrom);
	
	if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	

String final_date_to = fnl_Dateto;
String final_date_from = fnl_Datefrom ;
String reqType = requestType;
String brCode = branchCode;

//String reqStatus = request.getParameter("requestStatus");
String reqStatus = "";
String repType = reportType;
String tempReqType="";
String processdefID="";
String param="";
String param1="";
String procName="SRM_CSR_CARDS_VOLUME_REPORT";//Detailed
String procName1="SRM_CSR_CARD_VOL_STATUS_REPORT123";//Summary
ArrayList rows = null;
ArrayList rows1 = null;
ArrayList intrNames = null;
String columnData = "";

int countBT=0;
int countCBR=0;
int countCCB=0;
int countCCC=0;
int countMR=0;
int countRR=0;
int countRIP=0;
int countCR=0;
int countECR=0;
int countCLI=0;
int countCU=0;
int countTD=0;
int countODC=0;
int countCSI=0;
int countCDR=0;
int countCS=0;
int countSSC=0;

try{
	if(reqType!=null && !reqType.equalsIgnoreCase("")){
		if(reqType.equalsIgnoreCase("Card Service Request-Credit Card Blocking Request")){
			tempReqType="CSR_CCB";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Credit Card Cheque")){
			tempReqType="CSR_CCC";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Reversals Request")){
			tempReqType="CSR_RR";
		} else {
			tempReqType="All";
		}
		if(!tempReqType.equalsIgnoreCase("All")){
			//query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName='"+tempReqType+"'";
			
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:PROCESS_NAME";
			String params ="PROCESS_NAME==" + tempReqType;
			
			//sInputXML1=	"<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + query1 +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
			
			sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			
			WriteLog(sInputXML1);
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXML1);
			// tolCount1 = Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<TotalRetrieved>")+ 16,sOutputXML1.indexOf("</TotalRetrieved>")));
			// sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
			// processdefID  = sOutputXML1.substring(sOutputXML1.indexOf("<td>")+4,sOutputXML1.indexOf("</td>")); 
			// sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("</td>")+5);
			
			WFXmlResponse xmlResponse1 = new WFXmlResponse(sOutputXML1);
			WFXmlList RecordList1;
			RecordList1 =  xmlResponse1.createList("Records", "Record");
			processdefID  = RecordList1.getVal("PROCESSDEFID");
			
			
		}
	}
	String tempfromdate = final_date_from.substring(6).trim()+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
	String temptodate = final_date_to.substring(6).trim()+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);

	param = "'"+brCode+"','"+tempReqType+"','"+tempfromdate+"','"+temptodate+"'";
	param1 = "'"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"'";
	
} catch(Exception ex){
	
}

%>

<html>
<head>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">

<title>TeamLeader Report</title>
<script language="JavaScript" src="/webdesktop/webtop/scripts/calendar1.js"></script>
<script language='javascript'>
var strDateFormat="dd/MM/yyyy";


function initialise(TxtboxInputID)
{	
	document.getElementById(TxtboxInputID).value='';
	var cal1 = new calendar1(document.getElementById(TxtboxInputID));
	cal1.year_scroll = true;
	cal1.time_comp = false;
	cal1.popup();
	return true;
}
function generate_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var dat_to = document.FTOReport.dte_to.value;
	var reqType = document.FTOReport.requestType.value;
	var branchCode = document.FTOReport.branchCode.value;
	//var reqStatus = document.FTOReport.requestStatus.value;
	var reqStatus = "";
	var final_dt_from = dat_from;//dat_from.replaceAll("//","-")
	var final_dt_to =dat_to;// dat_to.replaceAll("//","-")
	
	if(dat_from==null || dat_from=="" || dat_from==" ")
	{
		alert("From Date can not be empty.");
		return false;
	}
	if(dat_to==null || dat_to=="" || dat_to==" ")
	{
		alert("To Date can not be empty.");
		return false;
	}
	if(!Datediff(dat_from))
	{
		return false;
	}

	if(!Datediff(dat_to))
	{
		return false;
	}

	if(!Datediff123())
	{
		document.getElementById("Date_dte_from").value="";
		document.getElementById("Date_dte_to").value="";
		return false;
	}
	

	document.FTOReport.action = "TeamLeaderReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&requestType="+reqType+"&branchCode="+branchCode+"&reqStatus="+reqStatus;
	document.FTOReport.submit;
}

function Datediff(DateField)
{ 
	var depDate=DateField;
	
	if(depDate=="")
	{
		return false;
	}
	var dd1=depDate.substring(0,2);
	
	var mm1=depDate.substring(3,5);
	
	var yy1=depDate.substring(6,10);
	
	var depDate1=yy1+'/'+mm1+'/'+dd1;

	var Cur1Date=document.getElementById("SYS_DATE").value;
	
	var dd2=Cur1Date.substring(0,2);
	
	var mm2=Cur1Date.substring(3,5);
	
	var yy2=Cur1Date.substring(6,10);
	
	var CurDate1=yy2+'/'+mm2+'/'+dd2;
	var CurDate2=new Date(CurDate1);
	var depDate2=new Date(depDate1);
	
	var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	

	if (Number(days) > 0)
	{
		alert(" DATE CAN NOT BE GREATER THAN CURRENT DATE  ");
		document.getElementById("Date_dte_from").value="";
		document.getElementById("Date_dte_to").value="";	  
		return false;
	}

	return true;
}

function Datediff123()
{ 
	var depDate=document.getElementById("Date_dte_from").value;
	
	var dd1=depDate.substring(0,2);
	
	var mm1=depDate.substring(3,5);
	
	var yy1=depDate.substring(6,10);
	
	var depDate1=yy1+'/'+mm1+'/'+dd1;

	var Cur1Date=document.getElementById("Date_dte_to").value;
	
	var dd2=Cur1Date.substring(0,2);
	
	var mm2=Cur1Date.substring(3,5);
	
	var yy2=Cur1Date.substring(6,10);
	var CurDate1=yy2+'/'+mm2+'/'+dd2;
	var CurDate2=new Date(CurDate1);
	var depDate2=new Date(depDate1);
	
	var days = ((depDate2.getTime() - CurDate2.getTime())/(1000*60*60*24));	
	 if (Number(days) > 0)
	{
	  alert(" FROM DATE CANNOT BE GREATER THAN TO DATE."); 
	  return false;
	}
	if(yy2>yy1)
	{
		if(mm2>mm1)
		{
			alert("Date difference cannot be greater than 1 year");
			return false;
		}
		else if (mm2==mm1)
		{
			if ((dd2+1)>dd1)
			{
				alert("Date difference cannot be greater than 1 year");
				return false;
			}
		}
	}

	return true;
}

function print_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var reqType = document.FTOReport.requestType.value;
	var branchCode = document.FTOReport.branchCode.value;
	var dat_to = document.FTOReport.dte_to.value;
	var final_dt_from = dat_from;//dat_from.replaceAll("//","-")
	var final_dt_to =dat_to;// dat_to.replaceAll("//","-")
	//var reqStatus = document.FTOReport.requestStatus.value;
	var reqStatus = "";
	if(dat_from==null || dat_from=="" || dat_from==" "){
		alert("From Date can not be empty.");
		return false;
	}
	if(dat_to==null || dat_to=="" || dat_to==" "){
		alert("To Date can not be empty.");
		return false;
	}
	if(!Datediff(dat_from))
	{
		return false;
	}

	if(!Datediff(dat_to))
	{
		return false;
	}
	if(!Datediff123())
	{
		document.getElementById("Date_dte_from").value="";
		document.getElementById("Date_dte_to").value="";
		return false;
	}
	document.FTOReport.action = "TeamLeaderReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&requestType="+reqType+"&branchCode="+branchCode+"&reqStatus="+reqStatus;
	document.FTOReport.submit;
}
function save_Report()
{
	
	var dat_from = document.FTOReport.dte_from.value;
	var dat_to = document.FTOReport.dte_to.value;
	var reqType = document.FTOReport.requestType.value;
	var branchCode = document.FTOReport.branchCode.value;
	var final_dt_from = dat_from;//dat_from.replaceAll("//","-")
	var final_dt_to =dat_to;// dat_to.replaceAll("//","-")
	//var reqStatus = document.FTOReport.requestStatus.value;
	var reqStatus = "";
	if(dat_from==null || dat_from=="" || dat_from==" "){
		alert("From Date can not be empty.");
		return false;
	}
	if(dat_to==null || dat_to=="" || dat_to==" "){
		alert("To Date can not be empty.");
		return false;
	}
	if(!Datediff(dat_from))
	{
		return false;
	}
	if(!Datediff(dat_to))
	{
		return false;
	}
	if(!Datediff123())
	{
		document.getElementById("Date_dte_from").value="";
		document.getElementById("Date_dte_to").value="";
		return false;
	}
	document.FTOReport.action = "TeamLeaderReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&requestType="+reqType+"&branchCode="+branchCode+"&reqStatus="+reqStatus;
	document.FTOReport.submit;
}
</script>
</head>
<body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0">
<form name='FTOReport' method='post' >
<br>
<%
   String Introducedby="";
%>
<table border="0" cellspacing="1" width="90%" align="center">
  <tr>  
	<td width="90%" colspan='3' > <img src='Logo.gif'></td>
  </tr>
  
  <tr>  
	<td align="center" width="600" class="EWSubHeaderText" > <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RAKBANK </center></td>
	<td align="center" width="80" class="EWSubHeaderText" > <center>Report Date:  </center></td>
	<td align="center" width="75" class="EWSubHeaderText" > <center><%=currentdate%>  </center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SRM-CARDS</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TEAMLEADER REPORT</center></td>
  </tr>
</table>
<table cellspacing="1" cellpadding='1' width="90%" align='center'> 
<tr>
	<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date :      </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
		 &nbsp;&nbsp;&nbsp;
	</td>
	<td  align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
	</td>
</tr>
<TR>
	<td align='left' ><font class='EWLabel3' > &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <b>Request Type:&nbsp;</b>
		<select name="requestType" >
			<% 
			
			  
			if(reqType!=null){%>
		
			<option  <%if(reqType.equals("Card Service Request-Credit Card Blocking Request")){%> value='Card Service Request-Credit Card Blocking Request' selected <%
			}else{%> value='Card Service Request-Credit Card Blocking Request' <%}%>  >Card Service Request-Credit Card Blocking Request</option>

			<option  <%if(reqType.equals("Card Service Request-Credit Card Cheque")){%> value='Card Service Request-Credit Card Cheque' selected <%}else{%> value='Card Service Request-Credit Card Cheque' <%}%>  >Card Service Request-Credit Card Cheque</option>
		
			<option  <%if(reqType.equals("Card Service Request-Reversals Request")){%> value='Card Service Request-Reversals Request' selected <%}else{%> value='Card Service Request-Reversals Request' <%}%>  >Card Service Request-Reversals Request</option>
	
			<option <%if(reqType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
			<%} else { %>
				<option  value="Card Service Request-Credit Card Blocking Request" >Card Service Request-Credit Card Blocking Request</option>
				<option  value="Card Service Request-Credit Card Cheque" >Card Service Request-Credit Card Cheque</option>
				<option  value="Card Service Request-Reversals Request" >Card Service Request-Reversals Request</option>
				<option  value="All" >All</option>
			<%}%>
		</select>
	</td>

	<td align='left'>
	<font class='EWLabel3'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b>
		<select name="reportType" >
				<% if(repType!=null){%>
				<option <%if(repType.equals("Detailed")){%> value='Detailed' selected <%}else{%> value='Detailed' <%}%> >Detailed</option>

				<option  <%if(repType.equals("Summarized")){%> value='Summarized' selected <%}else{%> value='Summarized' <%}%>  >Summary</option>

				<%} else { %>
					<option  value="Detailed" >Detailed</option>
					<option  value="Summarized" >Summary</option>
				<%}%>
			</select>
		</td>
</TR>
<TR>
	<td align='left' ><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Branch Id:&nbsp;</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="text box" name="branchCode" maxlength=4  value = '<%=brCode==null?"":brCode%>'align = "left">
	</td>
</TR>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="90%">
<tr>
  <td align='center' colspan="2"> <center>&nbsp;&nbsp;&nbsp;
  <input type="submit" name="generate_report" value="Generate Report" onClick="return generate_Report()">
  &nbsp;&nbsp;&nbsp;
 <input type="submit" name="save" value="Save"  onClick="return save_Report()"> &nbsp;&nbsp;&nbsp;
 <input type="submit" name="print" value="Print" onClick="return print_Report()"></center>
</td>
</tr>
</table>
<br>
<%
if(final_date_from==null || final_date_from=="")
{
}
else
{
if (repType.equals("Detailed"))
{
try{
	sInputXML1="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName+"</ProcName>" +						
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>12</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";

				WriteLog(sInputXML1);
   //out.println("Testing.."+sInputXML1);
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	WriteLog(sOutputXML1);

	if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)	{
		//out.println("Testing.."+sOutputXML1);
		String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
		//out.println("Testing..123");
		rows = new ArrayList();
		//Added below by Amandeep on 3 Feb 2011
		result=result.replaceAll("null","0");
		//Added Above by Amandeep on 3 Feb 2011
		StringTokenizer rowStr = new StringTokenizer(result, "~");
		while(rowStr.hasMoreTokens()){
			rows.add(rowStr.nextToken());
			//out.println(rows);
		}
	}					
						
	
}
	catch(Exception e)
	{
		out.println("In Excption: "+e.toString());
	}
	int iRecd=0;
	if(rows!=null && rows.size()>0)
		  {

				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
					<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="10%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Registration No</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> Customer Name </center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Card No</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Elite Customer No</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> Introduced By</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction Date</center></span></td>
						<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>
						<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Last Approver</center></span></td>
						<td width="9%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Approver Decision Time</center></span></td>
						<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>TeamLeader Decision</center></span></td>
					</tr>
					
					
			<%try
			{
			    intrNames = new ArrayList();
				for(int j=0;j<rows.size();j++)
				{
				
					
					columnData = rows.get(j).toString();
					String winame1 = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String winame = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String winame12 = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String winame2 = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType2  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName2= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String TeamLeader  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String TLDecisionTime= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber2= columnData;
					if(tempRequestType.equalsIgnoreCase("All"))
					{
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCB")){

							tempRequestType = "CSR_CCB";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCC")){
							tempRequestType = "CSR_CCC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("RR")){ 
							tempRequestType = "CSR_RR";
						}  
					}

					if(tempRequestType.equalsIgnoreCase("CSR_CCB")){
						countCCB++;
						tempRequestType = "CSR - Credit Card Blocking Request";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCC")){
						countCCC++;
						tempRequestType = "CSR - Credit Card Cheque";
					}else if(tempRequestType.equalsIgnoreCase("CSR_RR")){
						countRR++;
						tempRequestType = "CSR - ReversalsRequest";
					}	%>

						<tr colspan=10>
		                    <td width="8%" class="EWTableContentsText" align='left'><%=winame==null?"":winame%></td>
							<td width="10%" class="EWTableContentsText" align='left'><%=winame1==null?"":winame1%></td>
							<td width="8%" class="EWTableContentsNum" ><center><%=tempRequestType==null?"0":tempRequestType%> </center></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=CustomerName==null?"0":CustomerName%></td>
							<td width="8%" class="EWTableContentsNum" ><%=CardNumber==null?"0":CardNumber%></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=winame2==null?"":winame2%></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=winame12==null?"":winame12%></td>
							<td width="9%" class="EWTableContentsNum" ><center><%=tempRequestType2==null?"0":tempRequestType2%> </center></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=CustomerName2==null?"0":CustomerName2%></td>
							<td width="8%" class="EWTableContentsNum" ><%=TeamLeader==null?"":TeamLeader%></td>
							<td width="9%" class="EWTableContentsNum" ><%=TLDecisionTime==null?"":TLDecisionTime%></td>
							<td width="8%" class="EWTableContentsNum" ><%=CardNumber2==null?"":CardNumber2%></td>
							</tr>
				<%
				}
			}
			catch(Exception e)
			{
			out.println(" "+e);
			}//while
		}

		if(rows!=null && rows.size()>0)
		{%><br>
			
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="4"><td width="20%" class="EWSubHeaderText" ><center><B>Total </B></center></td>
			<td width="60%" class="EWSubHeaderText" ><center><B><%=reqType%></B></center></td>
			<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
			</tr>
		</table>
		</table><br>
		<%}
		if(rows==null || rows.size()<=0)
		{%><br>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Record Found</font></B></center></td>
			</tr></table>
		</table><br>
	<%}
}

else if (repType.equals("Summarized"))
{
try{
	sInputXML1="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName1+"</ProcName>" +						
				"<Params>"+param1+"</Params>" +  
				"<NoOfCols>5</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";

	WriteLog(sInputXML1);
   //out.println("Testing.."+sInputXML1);
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	WriteLog(sOutputXML1);

	if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)	{
		//out.println("Testing.."+sOutputXML1);
		String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
		//out.println("Testing..123");
		rows = new ArrayList();
		//Added below by Amandeep on 3 Feb 2011
		result=result.replaceAll("null","0");
		//Added Above by Amandeep on 3 Feb 2011
		StringTokenizer rowStr = new StringTokenizer(result, "~");
		while(rowStr.hasMoreTokens()){
			rows.add(rowStr.nextToken());
			//out.println(rows);
		}
	}					
						
	
}
	catch(Exception e)
	{
		out.println("In Excption: "+e.toString());
	}
	int iRecd=0;
	if(rows!=null && rows.size()>0)
		  {

				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
					<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>UserName</center></span></td>
						<td width="30%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> Approved </center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Discarded</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Resubmitted</center></span></td>
						<!--<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Discarded</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Elite CustomerNo.</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="4%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="3%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>-->
					</tr>
					
					
			<%try
			{
			    intrNames = new ArrayList();
				for(int j=0;j<rows.size();j++)
				{
				
					
					columnData = rows.get(j).toString();
					
                    String winame1 = columnData.substring(0,columnData.indexOf("!"));
					//out.println(winame);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					
					String winame = columnData.substring(0,columnData.indexOf("!"));
					//out.println(winame);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType  = columnData.substring(0,columnData.indexOf("!"));
					//out.println(tempRequestType);
					//Commented Below By Amandeep 3 Feb 2011
					//tempRequestType=tempRequestType.replace("null","0");
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName= columnData.substring(0,columnData.indexOf("!"));
					//out.println(CustomerName);
					//Commented Below By Amandeep 3 Feb 2011
					//CustomerName=CustomerName.replace("null","0");
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber= columnData;
					//Commented Below By Amandeep 3 Feb 2011
					//CardNumber=CardNumber.replace("null","0");
					//out.println(CardNumber);
					
					
					/*columnData = columnData.substring(columnData.indexOf("!")+1);
					//String CardCRN= columnData.substring(0,columnData.indexOf("!"));
					//out.println(CardCRN);
					//columnData = columnData.substring(columnData.indexOf("!")+1);
					//out.println(columnData);
					String EliteCustomerNo= columnData.substring(0,columnData.indexOf("!"));
					//out.println("hjhjh:"+EliteCustomerNo);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String InitiationBranch= columnData.substring(0,columnData.indexOf("!"));
					//out.println(InitiationBranch);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					Introducedby= columnData.substring(0,columnData.indexOf("!"));
					// Adding Data Introduced Names in to Array.
					intrNames.add(Introducedby);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String Introductiondate= columnData.substring(0,columnData.indexOf("!"));
					//out.println(Introductiondate);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String Activityname= columnData.substring(0);
					//out.println(Activityname);*/
					 
						if(tempRequestType.equalsIgnoreCase("All")){

			
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CBR")){
							tempRequestType = "DSR_CBR";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("DCB")){

							tempRequestType = "CSR_CCB";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCC")){
							tempRequestType = "CSR_CCC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("MR")){
							tempRequestType = "DSR_MISC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("RR")){ 
							tempRequestType = "CSR_RR";
						} else
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ODC")){ 
							tempRequestType = "DSR_ODC";
						} 
					}

					if(tempRequestType.equalsIgnoreCase("DSR_CBR")){
						countCBR++;
						tempRequestType = "DSR - CashBackRequest";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCB")){
						countCCB++;

						tempRequestType = "DSR - Credit Card Blocking Request";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCC")){
						countCCC++;
						tempRequestType = "CSR - CreditCardCheque";
					} else if(tempRequestType.equalsIgnoreCase("DSR_MISC")){
						countMR++;
						tempRequestType = "DSR - MiscellaneousRequests";
					} else if(tempRequestType.equalsIgnoreCase("CSR_RR")){
						countRR++;
						tempRequestType = "CSR - ReversalsRequest";
					}else if(tempRequestType.equalsIgnoreCase("Re-Issue of PIN")){
						countRIP++;
						tempRequestType = "Re-Issue of PIN";
					} else if(tempRequestType.equalsIgnoreCase("Card Replacement")){
						countCR++;
						tempRequestType = "Card Replacement";
					} else if(tempRequestType.equalsIgnoreCase("Early Card Renewal")){
						countECR++;
						tempRequestType = "Early Card Renewal";
					} else if(tempRequestType.equalsIgnoreCase("Credit Limit Increase")){
						countCLI++;
						tempRequestType = "Credit Limit Increase";
					} else if(tempRequestType.equalsIgnoreCase("Card Upgrade")){
						countCU++;
						tempRequestType = "Card Upgrade";
					} else if(tempRequestType.equalsIgnoreCase("Transaction Dispute")){
						countTD++;
						tempRequestType = "Transaction Dispute";
					} else if(tempRequestType.equalsIgnoreCase("Change in Standing Instructions")){
						countCSI++;
						tempRequestType = "Change in StandingInstructions";
					} else if(tempRequestType.equalsIgnoreCase("Card Delivery Request")){
						countCDR++;
						tempRequestType = "Card Delivery Request";
					} else if(tempRequestType.equalsIgnoreCase("Credit Shield")){
						countCS++;
						tempRequestType = "Credit Shield";
					} else if(tempRequestType.equalsIgnoreCase("Setup Suppl. Card Limit")){
						countSSC++;
						tempRequestType = "Setup Suppl. Card Limit";
					} else if(tempRequestType.equalsIgnoreCase("DSR_ODC")){
						countODC++;
						tempRequestType = "Other Credit Card";
					}
				    	%>

						<tr colspan=10>
		                    <td width="10%" class="EWTableContentsText" align='left'><%=winame1==null?"":winame1%></td>
							<td width="10%" class="EWTableContentsText" align='left'><%=winame==null?"":winame%></td>
							<td width="30%" class="EWTableContentsNum" ><center><%=tempRequestType==null?"0":tempRequestType%> </center></td>
							<td width="30%" class="EWTableContentsText" align='left'><%=CustomerName==null?"0":CustomerName%></td>
							<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"0":CardNumber%></td>
							</tr>
				<%
				//out.println(CustomerName=="null");
				//iRecd = iRecd+1;
				
			}
			}
			catch(Exception e)
			{
			out.println(" "+e);
			}//while
		}

		if(rows==null || rows.size()<=0)
		{%><br>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Record Found</font></B></center></td>
			</tr></table>
		</table><br>
	<%}
}

}

%></table>
<table align='center' cellspacing="1" cellpadding='1' width="90%">
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>
<tr><td><input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>"> </td></tr>
</form>
</body>
</html>

