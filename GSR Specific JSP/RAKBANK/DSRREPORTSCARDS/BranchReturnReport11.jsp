<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : REPORTS
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 16-Mar-2008
//Description                : for cards volume Reports .
//------------------------------------------------------------------------------------------------------------------------------------>
<%@ include file="../../DSRProcessSpecific/Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*,com.newgen.wfdesktop.session.WFSession" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
<%@ page import="java.text.*"%>
<%@ page import= "java.util.Properties" %>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>	
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
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Date: Agent replace "+fnl_Dateto);
	WriteLog("Integration jsp: fnl_date_to: Agent "+fnl_date_to);
	//WriteLog("Integration jsp: fnl_date_to: Agent "+request.getParameter("fnl_date_to"));
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: fnl_date_from agent: hritik "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Date: Agent replace 1 hritik "+fnl_Datefrom);
	if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("reportType", request.getParameter("reportType"), 1000, true) );
	String reportType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: reportType: "+reportType);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestStatus", request.getParameter("requestStatus"), 1000, true) );
	String reportType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("Integration jsp: requestStatus: "+requestStatus);



int count = 0;
int count4sum=0;
boolean bError=false;
try{
sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();
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
/*java.util.Calendar dateCreated1 = java.util.Calendar.getInstance();
java.text.DateFormat df1 = new java.text.SimpleDateFormat("dd-MM-yyyy");
String currentdate = df1.format(dateCreated1.getTime());*/
// getting data from request....

String final_date_to = fnl_Dateto;
String final_date_from = fnl_Datefrom;
String reqType = requestType;
String brCode = branchCode;
/* 
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       BRVolumeReport.jsp
	Purpose         :       Additional selection filter on the basis of workstep to be added on status of request. Also report to be categorized as detailed or summarized
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Variable Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/038	reqStatus,reportType		 Saurabh Arora
*/
String reqStatus = requestStatus;
String repType = reportType;
String tempReqType="";
String processdefID="";
String param="";
String param1="";
String procName="SRM_DSR_CARDS_VOLUME_REPORT";
String procName1="SRM_DSR_CARD_VOL_STATUS_REPORT999";
//String procName="SRM_RLS_REPORT";
ArrayList rows = null;
ArrayList rows1 = null;
ArrayList intrNames = null;
String columnData = "";

int countBT=0;
int countCBR=0;
int countDCB=0;
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
	if(reqType!=null){
		if(reqType.equalsIgnoreCase("DebitCard Service Request-Balance Transfer")){
			tempReqType="CSR_BT";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Cash Back Request")){
			tempReqType="DSR_CBR";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Debit Card Blocking Request")){
			tempReqType="DSR_DCB";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Credit Card Cheque")){
			tempReqType="CSR_CCC";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Miscellaneous Requests")){
			tempReqType="DSR_MR";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Reversals Request")){
			tempReqType="CSR_RR";
		} else if(reqType.equalsIgnoreCase("Re-Issue of PIN")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Card Replacement")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Early Card Renewal")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Credit Limit Increase")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Card Upgrade")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Transaction Dispute")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Change in Standing Instructions")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Card Delivery Request")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Credit Shield")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Setup Suppl. Card Limit")){
			tempReqType="DSR_ODC";
		} else {
			tempReqType="All";
		}
	//out.print("tempReqType"+tempReqType);
		if(!tempReqType.equalsIgnoreCase("All")){
			//query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName='"+tempReqType+"'";
			
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:PROCESS_NAME";
			String params ="PROCESS_NAME==" + tempReqType;
			
			//sInputXML1=	"<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + query1 +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
			
			sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			
			//tolCount1 = Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<TotalRetrieved>")+ 16,sOutputXML1.indexOf("</TotalRetrieved>")));
			//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
			//processdefID  = sOutputXML1.substring(sOutputXML1.indexOf("<td>")+4,sOutputXML1.indexOf("</td>")); 
			//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("</td>")+5);
			
			WFXmlResponse xmlResponse1 = new WFXmlResponse(sOutputXML1);
			WFXmlList RecordList1;
			RecordList1 =  xmlResponse1.createList("Records", "Record");
			processdefID  = RecordList1.getVal("PROCESSDEFID");
			
		}
	}
	WriteLog(final_date_from+final_date_to);
	String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
	String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);

	if((reqType.equalsIgnoreCase("Re-Issue of PIN"))|| (reqType.equalsIgnoreCase("Card Replacement")) ||(reqType.equalsIgnoreCase("Early Card Renewal")) || (reqType.equalsIgnoreCase("Card Upgrade")) || (reqType.equalsIgnoreCase("Transaction Dispute")) || (reqType.equalsIgnoreCase("Change in Standing Instructions")) || (reqType.equalsIgnoreCase("Card Delivery Request")) || (reqType.equalsIgnoreCase("Credit Shield")) || (reqType.equalsIgnoreCase("Setup Suppl. Card Limit")) ||(reqType.equalsIgnoreCase("Credit Limit Increase")))
	{
		param = "'"+brCode+"','"+tempReqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"','"+reqStatus+"'";
		param1 = "'"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"','"+reqStatus+"'";
		//out.print("parametre"+param);
	}
	else if (tempReqType.equalsIgnoreCase("All")){
	//String dfr=tempReqType+"~"+reqType;
	param = "'"+brCode+"','"+tempReqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"','"+reqStatus+"'";
	param1 = "'"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"','"+reqStatus+"'";
	//out.print("paralkljjlre"+param);
	}
	else{
				

			if(reqType.equalsIgnoreCase("DebitCard Service Request-Miscellaneous Requests")){
			tempReqType="DSR_MISC";
			}
		    param = "'"+brCode+"','"+tempReqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"','"+reqStatus+"'";
			param1 = "'"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"','"+reqStatus+"'";
			//out.print("parametre"+param);
	}
	
} catch(Exception ex){
	
}

%>

<html>
<head>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">

<title>Branch Return Report</title>
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
	var reqStatus = document.FTOReport.requestStatus.value;
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
	/*if(parseInt(date_from.replace("-",""))>parseInt(date_to.replace("-","")))
	{
		alert('From date should be less than To date.');
		return false;
	}*/

	document.FTOReport.action = "Report1BRVolumeAdditionalReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
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
/*

	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       BRVolumeReport.jsp
	Purpose         :       Reports to be on YTD basis 
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/037	Datediff123					 Saurabh Arora
*/	
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
	var reqStatus = document.FTOReport.requestStatus.value;
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
	document.FTOReport.action = "ReportBRVolumeAdditionalReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
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
	var reqStatus = document.FTOReport.requestStatus.value;
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
	document.FTOReport.action = "ReportBRVolumeAdditionalReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BRANCH RETURN REPORT</center></td>
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
			<option  <%if(reqType.equals("DebitCard Service Request-Cash Back Request")){%> value='DebitCard Service Request-Cash Back Request' selected <%}else{%> value='DebitCard Service Request-Cash Back Request' <%}%>  >DebitCard Service Request-Cash Back Request</option>

			<option  <%if(reqType.equals("DebitCard Service Request-Debit Card Blocking Request")){%> value='DebitCard Service Request-Debit Card Blocking Request' selected <%
			}else{%> value='DebitCard Service Request-Debit Card Blocking Request' <%}%>  >DebitCard Service Request-Debit Card Blocking Request</option>

			<!--<option  <%if(reqType.equals("Card Service Request-Credit Card Cheque")){%> value='Card Service Request-Credit Card Cheque' selected <%}else{%> value='Card Service Request-Credit Card Cheque' <%}%>  >Card Service Request-Credit Card Cheque</option>-->
			
			<option  <%if(reqType.equals("DebitCard Service Request-Miscellaneous Requests")){%> value='DebitCard Service Request-Miscellaneous Requests' selected <%}else{%> value='DebitCard Service Request-Miscellaneous Requests' <%}%>  >DebitCard Service Request-Miscellaneous Requests</option>

			<!--<option  <%if(reqType.equals("Card Service Request-Reversals Request")){%> value='Card Service Request-Reversals Request' selected <%}else{%> value='Card Service Request-Reversals Request' <%}%>  >Card Service Request-Reversals Request</option>-->

			
			<option  <%if(reqType.equals("Re-Issue of PIN")){%> value='Re-Issue of PIN' selected <%}else{%> value='Re-Issue of PIN' <%}%>  >Re-Issue of PIN</option> 

			<option  <%if(reqType.equals("Card Replacement")){%> value='Card Replacement' selected <%}else{%> value='Card Replacement' <%}%>  >Card Replacement</option>

			<option  <%if(reqType.equals("Early Card Renewal")){%> value='Early Card Renewal' selected <%}else{%> value='Early Card Renewal' <%}%>  >Early Card Renewal</option>

			<!--<option  <%if(reqType.equals("Credit Limit Increase")){%> value='Credit Limit Increase' selected <%}else{%> value='Credit Limit Increase' <%}%>  >Credit Limit Increase</option>-->
			

			<!--<option  <%if(reqType.equals("Card Upgrade")){%> value='Card Upgrade' selected <%}else{%> value='Card Upgrade' <%}%>  >Card Upgrade</option>-->
			
			<option  <%if(reqType.equals("Transaction Dispute")){%> value='Transaction Dispute' selected <%}else{%> value='Transaction Dispute' <%}%>  >Transaction Dispute</option>

			<!--<option  <%if(reqType.equals("Change in Standing Instructions")){%> value='Change in Standing Instructions' selected <%}else{%> value='Change in Standing Instructions' <%}%>  >Change in Standing Instructions</option>-->

			<option  <%if(reqType.equals("Card Delivery Request")){%> value='Card Delivery Request' selected <%}else{%> value='Card Delivery Request' <%}%>  >Card Delivery Request</option>
		
			<!--<option  <%if(reqType.equals("Credit Shield")){%> value='Credit Shield' selected <%}else{%> value='Credit Shield' <%}%>  >Credit Shield</option>-->
			
			<!--<option  <%if(reqType.equals("Setup Suppl. Card Limit")){%> value='Setup Suppl. Card Limit' selected <%}else{%> value='Setup Suppl. Card Limit' <%}%>  >Setup Suppl. Card Limit</option>-->

			<option <%if(reqType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
			<%} else { %>
				<option  value="DebitCard Service Request-Cash Back Request" >DebitCard Service Request-Cash Back Request</option>
				<option  value="DebitCard Service Request-Debit Card Blocking Request" >DebitCard Service Request-Card Blocking Request</option>
				<!--<option  value="Card Service Request-Credit Card Cheque" >Card Service Request-Credit Card Cheque</option>-->
				<option  value="DebitCard Service Request-Miscellaneous Requests" >DebitCard Service Request-Miscellaneous Requests</option>
				<!--<option  value="Card Service Request-Reversals Request" >Card Service Request-Reversals Request</option>-->
				<option  value="Re-Issue of PIN" >Re-Issue of PIN</option>
				<option  value="Card Replacement" >Card Replacement</option>
				<option  value="Early Card Renewal" >Early Card Renewal</option>
				<!--<option  value="Credit Limit Increase" >Credit Limit Increase</option>-->
				<!--<option  value="Card Upgrade" >Card Upgrade</option>-->
				<option  value="Transaction Dispute" >Transaction Dispute</option>
				<!--<option  value="Change in Standing Instructions" >Change in Standing Instructions</option>-->
				<option  value="Card Delivery Request" >Card Delivery Request</option>
				<!--<option  value="Credit Shield" >Credit Shield</option>-->
				<!--<option  value="Setup Suppl. Card Limit" >Setup Suppl. Card Limit</option>-->
				<option  value="All" >All</option>
			<%}%>
		</select>
	</td>
<!-- 
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       BRVolumeReport.jsp
	Purpose         :       Reports to be on YTD basis 
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/037								 Saurabh Arora

 -->
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
<!-- 
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       BRVolumeReport.jsp
	Purpose         :       Additional selection filter on the basis of workstep to be added on status of request. Also report to be categorized as detailed or summarized 
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/038								 Saurabh Arora
 -->
 <td align='left' ><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Request Status:&nbsp;</b>
		<select name="requestStatus" >
				<% if(reqType!=null){%>
				<option <%if(reqStatus.equals("BranchApprover")){%> value='BranchApprover' selected <%}else{%> value='BranchApprover' <%}%> >Branch Approver</option>

				<option  <%if(reqStatus.equals("CARDS")){%> value='CARDS' selected <%}else{%> value='CARDS' <%}%>  >Cards</option>

				<option  <%if(reqStatus.equals("Work Exit1")){%> value='Work Exit1' selected <%}else{%> value='Work Exit1' <%}%>  >Completed</option>

				<option  <%if(reqStatus.equals("Discard1")){%> value='Discard1' selected <%}else{%> value='Discard1' <%}%>  >Discarded</option>
				
				<option  <%if(reqStatus.equals("Pending")){%> value='Pending' selected <%}else{%> value='Pending' <%}%>  >Pending</option>

				<option <%if(reqStatus.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
				<%} else { %>
					<option  value="BranchApprover" >Branch Approver</option>
					<option  value="CARDS" >Cards</option>
					<option  value="Work Exit1" >Completed</option>
					<option  value="Discard1" >Discarded</option>
					<option  value="Pending" >Pending</option>
					<option  value="All" >All</option>
				<%}%>
			</select>
			
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
				"<ProcName>"+procName1+"</ProcName>" +						
				"<Params>"+param1+"</Params>" +  
				"<NoOfCols>4</NoOfCols>" +
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
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Discard</center></span></td>
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
					String tempRequestType="" ;// = columnData.substring(0,columnData.indexOf("!"));
					//out.println(tempRequestType);
					//columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName= columnData.substring(0,columnData.indexOf("!"));
					//out.println(CustomerName);
					CustomerName=CustomerName.replace("null","0");
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber= columnData;
					CardNumber=CardNumber.replace("null","0");
					//out.println(CardNumber);
					
					
					/*columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardCRN= columnData.substring(0,columnData.indexOf("!"));
					//out.println(CardCRN);
					columnData = columnData.substring(columnData.indexOf("!")+1);
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
							tempRequestType = "DSR_DCB";
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
					} else if(tempRequestType.equalsIgnoreCase("DSR_DCB")){
						countDCB++;
						tempRequestType = "DSR - Debit Card Blocking Request";
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
						tempRequestType = "Other Debit Card";
					}
				    	%>
						<tr colspan=10>
		                   <td width="10%" class="EWTableContentsText" align='left'><%=winame1%></td>
							<td width="10%" class="EWTableContentsText" align='left'><%=winame%></td>
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

		if(!reqType.equals("All") && rows!=null && rows.size()>0)
		{%><br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Summary</B></center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="4"><td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
			<td width="60%" class="EWSubHeaderText" ><center><B><%=reqType%></B></center></td>
			<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
			</tr>
		</table>
		</table><br>
		<%} else if(reqType.equals("All") && rows!=null && rows.size()>0){ %>
			<br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Summary</B></center></td>
				</tr>
			</table>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<!--<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Balance Transfer</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countBT%></B></center></td>
				</tr>-->
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Cash Back Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCBR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Card Blocking Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countDCB%></B></center></td>
				</tr>
				<!--<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Credit Card Cheque</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCCC%></B></center></td>
				</tr>-->
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Miscellaneous Requests</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countMR%></B></center></td>
				</tr>
				<!--<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Reversals Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countRR%></B></center></td>
				</tr>-->
				 
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Other Debit Card Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countODC%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Grand Total </B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>All</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
				</tr>
			
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
/* 
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       BRVolumeReport.jsp
	Purpose         :       Additional selection filter on the basis of workstep to be added on status of request. Also report to be categorized as detailed or summarized
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Variable Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/038	reqStatus,reportType		 Saurabh Arora
*/
else if (repType.equals("Summarized"))
{
	try{
		sInputXML1="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>"+procName1+"</ProcName>" +						
					"<Params>"+param1+"</Params>" +  
					"<NoOfCols>3</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";

		WriteLog(sInputXML1);


		sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);

		if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)	{
			String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
			rows = new ArrayList();
			StringTokenizer rowStr = new StringTokenizer(result, "~");
			while(rowStr.hasMoreTokens()){
				rows.add(rowStr.nextToken());
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
                 try
				 {
					for(int j=0;j<rows.size();j++){
						
						columnData = rows.get(j).toString();

						/*String winame = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String tempRequestType  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CustomerName= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CardNumber= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CardCRN= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String EliteCustomerNo= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String InitiationBranch= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						 Introducedby= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String Introductiondate= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String Activityname= columnData.substring(0);*/
						
						
						
						String 	winame = columnData.substring(0,columnData.indexOf("!"));
						//out.println(winame);
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String tempRequestType ="";// = columnData.substring(0,columnData.indexOf("!"));
						//out.println(tempRequestType);
						//columnData = columnData.substring(columnData.indexOf("!")+1);
						String CustomerName= columnData.substring(0,columnData.indexOf("!"));
						//out.println(CustomerName);
						columnData = columnData.substring(columnData.indexOf("!")+1);
						//out.println("jijij:"+columnData);
						String CardNumber= columnData;
						//out.println(winame);

							if(tempRequestType.equalsIgnoreCase("All")){
				
							if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CBR")){
								tempRequestType = "DSR_CBR";
							} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("DCB")){
								tempRequestType = "DSR_DCB";
							} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("MR")){
								tempRequestType = "DSR_MISC";
							} else
							if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ODC")){ 
								tempRequestType = "DSR_ODC";
							} 
						}

						if(tempRequestType.equalsIgnoreCase("DSR_CBR")){
							countCBR++;
							tempRequestType = "DSR - CashBackRequest";
						} else if(tempRequestType.equalsIgnoreCase("DSR_DCB")){
							countDCB++;
							tempRequestType = "DSR - Debit Card Blocking Request";
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
							tempRequestType = "Other Debit Card";
						}

				}
				}
			catch(Exception e)
			{
			out.println(e)
;			}
		
			}

			if(!reqType.equals("All") && rows!=null && rows.size()>0)
			{%><br>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Summary</B></center></td>
				</tr>
			</table>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr colspan="4"><td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
				<td width="60%" class="EWSubHeaderText" ><center><B><%=reqType%></B></center></td>
				<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
				</tr>
			</table>
			</table><br>
			<%} else if(reqType.equals("All") && rows!=null && rows.size()>0){ %>
				<br>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Summary</B></center></td>
					</tr>
				</table>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<!--<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Balance Transfer</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countBT%></B></center></td>
					</tr>-->
					<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Cash Back Request</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countCBR%></B></center></td>
					</tr>
					<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Debit Card Blocking Request</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countDCB%></B></center></td>
					</tr>
					<!--<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Credit Card Cheque</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countCCC%></B></center></td>
					</tr>-->
					<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Miscellaneous Requests</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countMR%></B></center></td>
					</tr>
					<!--<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Reversals Request</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countRR%></B></center></td>
					</tr>-->
					 
					<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>Other Debit Card Request</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=countODC%></B></center></td>
					</tr>
					<tr colspan="4">
						<td width="20%" class="EWSubHeaderText" ><center><B>Grand Total </B></center></td>
						<td width="60%" class="EWSubHeaderText" ><center><B>All</B></center></td>
						<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
					</tr>
				
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

	if (reqStatus.equals("Branch Approver"))
	{
		try
		{
			sInputXML1="<?xml version=\"1.0\"?>" + 				
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>"+procName1+"</ProcName>" +						
						"<Params>"+param1+"</Params>" +  
						"<NoOfCols>3</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabname+"</EngineName>" +
						"</APProcedure2_Input>";
			WriteLog(sInputXML1);
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXML1);
			if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)
			{
				String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
				rows1 = new ArrayList();
				StringTokenizer rowStr = new StringTokenizer(result, "~");
				while(rowStr.hasMoreTokens())
				{
					rows1.add(rowStr.nextToken());
				}
				
			}					
		}
		catch(Exception e)
		{
			//out.println("In Exception: "+e.toString());
		}

		if(rows1!=null && rows1.size()>0)
		{
			String btInitiated = "0";
			String btDiscard = "0";
			String btExit = "0";
			String btUnderProcess = "0";
			String btRFM = "0";
			String cbrInitiated = "0";
			String cbrDiscard = "0";
			String cbrExit = "0";
			String cbrUnderProcess = "0";
			String cbrRFM = "0";
			String ccbInitiated = "0";
			String ccbDiscard = "0";
			String ccbExit = "0";
			String ccbUnderProcess = "0";
			String ccbRFM = "0";
			String cccInitiated = "0";
			String cccDiscard = "0";
			String cccExit = "0";
			String cccUnderProcess = "0";
			String cccRFM = "0";
			String mrInitiated = "0";
			String mrDiscard = "0";
			String mrExit = "0";
			String mrUnderProcess = "0";
			String mrRFM = "0";
			String rrInitiated = "0";
			String rrDiscard = "0";
			String rrExit = "0";
			String rrUnderProcess = "0";
			String rrRFM = "0";
			String occInitiated = "0";
			String occDiscard = "0";
			String occExit = "0";
			String occUnderProcess = "0";
			String occRFM = "0";
			String ripExit = "0";
			String ripDiscard = "0";
			String ripInitiated = "0";
			String ripUnderProcess = "0";
			String ripRFM = "0";
			String crExit = "0";
			String crDiscard = "0";
			String crInitiated = "0";
			String crUnderProcess = "0";
			String crRFM = "0";
			String cuExit = "0";
			String cuDiscard = "0";
			String cuInitiated = "0";
			String cuUnderProcess = "0";
			String cuRFM = "0";
			String tdExit = "0";
			String tdDiscard = "0";
			String tdInitiated = "0";
			String tdUnderProcess = "0";
			String tdRFM = "0";
			String csiExit = "0";
			String csiDiscard = "0";
			String csiInitiated = "0";
			String csiUnderProcess = "0";
			String csiRFM = "0";
			String cdrExit = "0";
			String cdrDiscard = "0";
			String cdrInitiated = "0";
			String cdrUnderProcess = "0";
			String cdrRFM = "0";
			String ecrExit = "0";
			String ecrDiscard = "0";
			String ecrInitiated = "0";
			String ecrUnderProcess = "0";
			String ecrRFM = "0";
			String csExit = "0";
			String csDiscard = "0";
			String csInitiated = "0";
			String csUnderProcess = "0";
			String csRFM = "0";
			String ssclExit = "0";
			String ssclDiscard = "0";
			String ssclInitiated = "0";
			String ssclUnderProcess = "0";
			String ssclRFM = "0";
			String cliExit = "0";
			String cliDiscard = "0";
			String cliInitiated = "0";
			String cliUnderProcess = "0";
			String cliRFM = "0";

			String requestType1 = "";
			String status1 = "";
			String count1 = "";

			int cdInitiatedTotVol = 0;
			int cdExitTotVol = 0;
			int cdDiscardTotVol = 0;
			int cdUnderProcessTotVol = 0;
			int cdRFMTotVol = 0;

			for(int j=0;j<rows1.size();j++)
			{
				columnData = rows1.get(j).toString();
				
				requestType1 = columnData.substring(0,columnData.indexOf("!"));
				columnData = columnData.substring(columnData.indexOf("!")+1);
				status1  = columnData.substring(0,columnData.indexOf("!"));
				columnData = columnData.substring(columnData.indexOf("!")+1);
				count1 = columnData.substring(0);

				/*if(reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("CSR_BT"))
				{
					if (requestType1.equalsIgnoreCase("CSR_BT"))
					{
						if (status1.equals("Complete"))
						{
							btExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(btExit);
						}
						if (status1.equals("Discard"))
						{
							btDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(btDiscard);
						}
						if (status1.equals("Initiated"))
						{
							btInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(btInitiated);
						}
						if (status1.equals("Under Process"))
						{
							btUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(btUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							btRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(btRFM);
						}
					}
				}*/

				if(reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("DSR_CBR"))
				{
					if (requestType1.equalsIgnoreCase("DSR_CBR"))
					{
						if (status1.equals("Approve"))
						{
							cbrExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(cbrExit);
						}
						if (status1.equals("Discard"))
						{
							cbrDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(cbrDiscard);
						}
						if (status1.equals("Initiated"))
						{
							cbrInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(cbrInitiated);
						}
						if (status1.equals("Under Process"))
						{
							cbrUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(cbrUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							cbrRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(cbrRFM);
						}
					}
				} 
				if(reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("DSR_DCB"))
				{
					if (requestType1.equalsIgnoreCase("DSR_DCB"))
					{
						if (status1.equals("Complete"))
						{
							ccbExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(ccbExit);
						}
						if (status1.equals("Discard"))
						{
							ccbDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(ccbDiscard);
						}
						if (status1.equals("Initiated"))
						{
							ccbInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(ccbInitiated);
						}
						if (status1.equals("Under Process"))
						{
							ccbUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(ccbUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							ccbRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(ccbRFM);
						}
					}
				} 
				/*if(reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("CSR_CCC"))
				{
					if (requestType1.equalsIgnoreCase("CSR_CCC"))
					{
						if (status1.equals("Complete"))
						{
							cccExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(cccExit);
						}
						if (status1.equals("Discard"))
						{
							cccDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(cccDiscard);
						}
						if (status1.equals("Initiated"))
						{
							cccInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(cccInitiated);
						}
						if (status1.equals("Under Process"))
						{
							cccUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(cccUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							cccRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(cccRFM);
						}
					}
				}*/ 
				if(reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("DSR_MISC"))
				{
					if (requestType1.equalsIgnoreCase("DSR_MR"))
					{
						if (status1.equals("Complete"))
						{
							mrExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(mrExit);
						}
						if (status1.equals("Discard"))
						{
							mrDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(mrDiscard);
						}
						if (status1.equals("Initiated"))
						{
							mrInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(mrInitiated);
						}
						if (status1.equals("Under Process"))
						{
							mrUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(mrUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							mrRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(mrRFM);
						}
					}
				} 
				/*if(reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("CSR_RR"))
				{ 
					if (requestType1.equalsIgnoreCase("CSR_RR"))
					{
						if (status1.equals("Complete"))
						{
							rrExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(rrExit);
						}
						if (status1.equals("Discard"))
						{
							rrDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(rrDiscard);
						}
						if (status1.equals("Initiated"))
						{
							rrInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(rrInitiated);
						}
						if (status1.equals("Under Process"))
						{
							rrUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(rrUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							rrRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(rrRFM);
						}
					}
				}*/ 
				if(reqType.equalsIgnoreCase("All"))
				{
					if (requestType1.equalsIgnoreCase("DSR_ODC"))
					{	
						if (status1.equals("Complete"))
						{
							occExit = count1;
							cdExitTotVol = cdExitTotVol + Integer.parseInt(occExit);
						}
						if (status1.equals("Discard"))
						{
							occDiscard = count1;
							cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(occDiscard);
						}
						if (status1.equals("Initiated"))
						{
							occInitiated = count1;
							cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(occInitiated);
						}
						if (status1.equals("Under Process"))
						{
							occUnderProcess = count1;
							cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(occUnderProcess);
						}
						if (status1.equals("Returned From Branch"))
						{
							occRFM = count1;
							cdRFMTotVol = cdRFMTotVol + Integer.parseInt(occRFM);
						}
					}
				} 

				if (reqType.equalsIgnoreCase("Re-Issue of PIN"))
				{
					if (status1.equals("Complete"))
					{
						ripExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(ripExit);
					}
					if (status1.equals("Discard"))
					{
						ripDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(ripDiscard);
					}
					if (status1.equals("Initiated"))
					{
						ripInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(ripInitiated);
					}
					if (status1.equals("Under Process"))
					{
						ripUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(ripUnderProcess);
					}
					if (status1.equals("Returned From Branch"))
					{
						ripRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(ripRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Card Replacement"))
				{
					if (status1.equals("Complete"))
					{
						crExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(crExit);
					}
					if (status1.equals("Discard"))
					{
						crDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(crDiscard);
					}
					if (status1.equals("Initiated"))
					{
						crInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(crInitiated);
					}
					if (status1.equals("Under Process"))
					{
						crUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(crUnderProcess);
					}	
					if (status1.equals("Returned From Branch"))
					{
						crRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(crRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Early Card Renewal"))
				{
					if (status1.equals("Complete"))
					{
						ecrExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(ecrExit);
					}
					if (status1.equals("Discard"))
					{
						ecrDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(ecrDiscard);
					}
					if (status1.equals("Initiated"))
					{
						ecrInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(ecrInitiated);
					}
					if (status1.equals("Under Process"))
					{
						ecrUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(ecrUnderProcess);
					}
					if (status1.equals("Returned From Branch"))
					{
						ecrRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(ecrRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Credit Limit Increase"))
				{
					if (status1.equals("Complete"))
					{
						cliExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(cliExit);
					}
					if (status1.equals("Discard"))
					{
						cliDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(cliDiscard);
					}
					if (status1.equals("Initiated"))
					{
						cliInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(cliInitiated);
					}
					if (status1.equals("Under Process"))
					{
						cliUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(cliUnderProcess);
					}	
					if (status1.equals("Returned From Branch"))
					{
						cliRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(cliRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Card Upgrade"))
				{
					if (status1.equals("Complete"))
					{
						cuExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(cuExit);
					}
					if (status1.equals("Discard"))
					{
						cuDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(cuDiscard);
					}
					if (status1.equals("Initiated"))
					{
						cuInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(cuInitiated);
					}
					if (status1.equals("Under Process"))
					{
						cuUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(cuUnderProcess);
					}
					if (status1.equals("Returned From Branch"))
					{
						cuRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(cuRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Transaction Dispute"))
				{
					if (status1.equals("Complete"))
					{
						tdExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(tdExit);
					}
					if (status1.equals("Discard"))
					{
						tdDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(tdDiscard);
					}
					if (status1.equals("Initiated"))
					{
						tdInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(tdInitiated);
					}
					if (status1.equals("Under Process"))
					{
						tdUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(tdUnderProcess);
					}
					if (status1.equals("Returned From Branch"))
					{
						tdRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(tdRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Change in Standing Instructions"))
				{
					if (status1.equals("Complete"))
					{
						csiExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(csiExit);
					}
					if (status1.equals("Discard"))
					{
						csiDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(csiDiscard);
					}
					if (status1.equals("Initiated"))
					{
						csiInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(csiInitiated);
					}
					if (status1.equals("Under Process"))
					{
						csiUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(csiUnderProcess);
					}
					if (status1.equals("Returned From Branch"))
					{
						csiRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(csiRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Card Delivery Request"))
				{
					if (status1.equals("Complete"))
					{
						cdrExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(cdrExit);
					}
					if (status1.equals("Discard"))
					{
						cdrDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(cdrDiscard);
					}
					if (status1.equals("Initiated"))
					{
						cdrInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(cdrInitiated);
					}
					if (status1.equals("Under Process"))
					{
						cdrUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(cdrUnderProcess);
					}		
					if (status1.equals("Returned From Branch"))
					{
						cdrRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(cdrRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Credit Shield"))
				{
					if (status1.equals("Complete"))
					{
						csExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(csExit);
					}
					if (status1.equals("Discard"))
					{
						csDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(csDiscard);
					}
					if (status1.equals("Initiated"))
					{
						csInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(csInitiated);
					}
					if (status1.equals("Under Process"))
					{
						csUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(csUnderProcess);
					}		
					if (status1.equals("Returned From Branch"))
					{
						csRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(csRFM);
					}					
				}
				else if (reqType.equalsIgnoreCase("Setup Suppl. Card Limit"))
				{
					if (status1.equals("Complete"))
					{
						ssclExit = count1;
						cdExitTotVol = cdExitTotVol + Integer.parseInt(ssclExit);
					}
					if (status1.equals("Discard"))
					{
						ssclDiscard = count1;
						cdDiscardTotVol = cdDiscardTotVol + Integer.parseInt(ssclDiscard);
					}
					if (status1.equals("Initiated"))
					{
						ssclInitiated = count1;
						cdInitiatedTotVol = cdInitiatedTotVol + Integer.parseInt(ssclInitiated);
					}
					if (status1.equals("Under Process"))
					{
						ssclUnderProcess = count1;
						cdUnderProcessTotVol = cdUnderProcessTotVol + Integer.parseInt(ssclUnderProcess);
					}	
					if (status1.equals("Returned From Branch"))
					{
						ssclRFM = count1;
						cdRFMTotVol = cdRFMTotVol + Integer.parseInt(ssclRFM);
					}					
				}
			}

			%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Card Decision Summary</B></center></td>
					</tr>
				</table>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ></td>
						<td width="16%" class="EWSubHeaderText" ><center><B>Introduced By</B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B>Approval</B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B>Discarded</B></center></td>
						<!--<td width="16%" class="EWSubHeaderText" ><center><B>Under Process</B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B>Initiated</B></center></td>-->
						<td width="16%" class="EWSubHeaderText" ><center><B>Returned From Branch</B></center></td>
					</tr>
			<%
			   for(int k=0;k<intrNames.size();k++)
			   {
				if (reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("CSR_BT"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Balance Transfer</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=btExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=btDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=btUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=btInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=btRFM%></B></center></td>
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("DSR_CBR"))
				{
			%>
					<tr colspan="4">
					    
						<td width="16%" class="EWSubHeaderText" ><center><B>Cash Back Request</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cbrExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cbrDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=cbrUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cbrInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=cbrRFM%></B></center></td>
						
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("DSR_DCB"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Debit Cash Back</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ccbExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ccbDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=ccbUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ccbInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=ccbRFM%></B></center></td>
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("CSR_CCC"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Credit Card Cheque</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cccExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cccDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cccUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cccInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cccRFM%></B></center></td>
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("DSR_MISC"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Miscellaneous Request</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=mrExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=mrDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=mrUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=mrInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=mrRFM%></B></center></td>
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("All")||tempReqType.equalsIgnoreCase("CSR_RR"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Reversal Request</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=rrExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=rrDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=rrUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=rrInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=rrRFM%></B></center></td>
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("All"))
				{
			%>				 
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Other Card Requests</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=occExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=occDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=occUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=occInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=occRFM%></B></center></td>
					</tr>
			<%
				}
				if (reqType.equalsIgnoreCase("Re-Issue of PIN"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Re-Issue of PIN</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ripExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ripDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=ripUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ripInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=ripRFM%></B></center></td>
					</tr>
			<%
				}
				else if (reqType.equalsIgnoreCase("Card Replacement"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Card Replacement</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=crExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=crDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=crUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=crInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=crRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Early Card Renewal"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Early Card Renewal</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ecrExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ecrDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=ecrUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ecrInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=ecrRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Credit Limit Increase"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Credit Limit Increase</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cliExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cliDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cliUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cliInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cliRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Card Upgrade"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Card Upgrade</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cuExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cuDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cuUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cuInitiated%></B></center></td>]
						<td width="16%" class="EWTableContentsText" ><center><B><%=cuRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Transaction Dispute"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Transaction Dispute</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=tdExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=tdDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=tdUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=tdInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=tdRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Change in Standing Instructions"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Change in Standing Instructions</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csiExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csiDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csiUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csiInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csiRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Card Delivery Request"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Card Delivery Request</B></center></td>
						<td width="15%" class="EWTableContentsText" align='left'><%=intrNames.get(k)%></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cdrExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cdrDiscard%></B></center></td>
						<!--<td width="16%" class="EWTableContentsText" ><center><B><%=cdrUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=cdrInitiated%></B></center></td>-->
						<td width="16%" class="EWTableContentsText" ><center><B><%=cdrRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Credit Shield"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Credit Shield</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=csRFM%></B></center></td>
					</tr>
			<%		
				}
				else if (reqType.equalsIgnoreCase("Setup Suppl. Card Limit"))
				{
			%>
					<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Setup Suppl. Card Limit</B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ssclExit%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ssclDiscard%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ssclUnderProcess%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ssclInitiated%></B></center></td>
						<td width="16%" class="EWTableContentsText" ><center><B><%=ssclRFM%></B></center></td>
					</tr>
			<%		
				}
			%>
					<!--<tr colspan="4">
						<td width="16%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B><%=cdExitTotVol%></B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B><%=cdDiscardTotVol%></B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B><%=cdUnderProcessTotVol%></B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B><%=cdInitiatedTotVol%></B></center></td>
						<td width="16%" class="EWSubHeaderText" ><center><B><%=cdRFMTotVol%></B></center></td>
					</tr>-->
				
			<%
		}}
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

