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

<%--
		Product         :       OmniFlow
		Application     :       OmniFlow Monitoring Agent
		Module          :       Report
		File            :       FTOReport.jsp
		Purpose         :       This file displays the report of administrator work in the process view.
		Change History  :

		Problem No        Correction Date		Comments
		-----------       ----------------      ----------
--%>




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
int count = 0;
int count4sum=0;
sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();
DateFormat dtFormat = new SimpleDateFormat( "dd-MM-yyyy"+ " hh:mm:ss");
String currentdate = dtFormat.format(new java.util.Date());
/*java.util.Calendar dateCreated1 = java.util.Calendar.getInstance();
java.text.DateFormat df1 = new java.text.SimpleDateFormat("dd-MM-yyyy");
String currentdate = df1.format(dateCreated1.getTime());*/
// getting data from request....
String final_date_to = request.getParameter("fnl_date_to");
String final_date_from = request.getParameter("fnl_date_from");
String reqType = request.getParameter("requestType");
String brCode = request.getParameter("branchCode");

String tempReqType="";
String processdefID="";
String param="";
String procName="SRM_RLS_REPORT";
ArrayList rows = null;
String columnData = "";
int countPD=0;
int countPS=0;
int countES=0;
int countIPDR=0;
int countLCOL=0;
int countEMPADD=0;


try{
	if(reqType!=null){
		if(reqType.equalsIgnoreCase("Personal Loan-Postponement/Deferral")){
			tempReqType="PL_PD";
		} else if(reqType.equalsIgnoreCase("Personal Loan-Part Settlement/Advance Installment Payment")){
			tempReqType="PL_PS";
		} else if(reqType.equalsIgnoreCase("Personal Loan-Early Settlement(TakeOver and Cash and EOSB)")){
			tempReqType="PL_ES";
		} else if(reqType.equalsIgnoreCase("Personal Loan-Instalment Recovery / Past Due Recovery")){
			tempReqType="PL_IPDR";
		} else if(reqType.equalsIgnoreCase("General Service Requests-Liability Certificate/No Liability Certificate")){
			tempReqType="GSR_LCOL";
		} else if(reqType.equalsIgnoreCase("General Service Requests-Change in Employer/Address for Loan Customers")){
			tempReqType="GSR_EMPADD";
		} else {
			tempReqType="All";
		}
	
		if(!tempReqType.equalsIgnoreCase("All")){
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:ProcessName";
			String params ="ProcessName=="+tempReqType";
			sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			tolCount1 = Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<TotalRetrieved>")+ 16,sOutputXML1.indexOf("</TotalRetrieved>")));
			/*
			sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
			processdefID  = sOutputXML1.substring(sOutputXML1.indexOf("<td>")+4,sOutputXML1.indexOf("</td>")); 
			sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("</td>")+5);
			*/
			WFXmlResponse xmlResponse1 = new WFXmlResponse(sBranchDetails);
			WFXmlList RecordList1;
			RecordList1 =  xmlResponse1.createList("Records", "Record");
			processdefID  = RecordList1.getVal("PROCESSDEFID");
		}
	}
	String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
	String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
	param = "'"+brCode+"','"+tempReqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"'";
	
	
} catch(Exception ex){
	
}


%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">

<title>Branch Volume Report</title>
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
	document.FTOReport.action = "BRVolumeReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&requestType="+reqType+"&branchCode="+branchCode;
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
	  alert(" TO DATE CAN NOT BE GREATER THAN CURRENT DATE  "); 
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

	/*if(parseInt(date_from)>parseInt(date_to))
	{
		alert('From date should be less than To date.');
		return false;
	}*/

	document.FTOReport.action = "VolumeReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&requestType="+reqType+"&branchCode="+branchCode;
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
	/*if(parseInt(date_from)>parseInt(date_to))
	{
		alert('From date should be less than To date.');
		return false;
	}*/
	
	document.FTOReport.action = "VolumeReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&requestType="+reqType+"&branchCode="+branchCode;
	document.FTOReport.submit;
}
</script>
</head>
<body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0">
<form name='FTOReport' method='post' >
<br>
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SRM-RLS</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BRANCH VOLUME REPORT</center></td>
  </tr>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
<tr>
	<td align='left'><font class='EWLabel3' ><b>From Date :      </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
		 &nbsp;&nbsp;&nbsp;
	</td>
	<td  align='left'><font class='EWLabel3' ><b>To Date : </b>&nbsp;&nbsp;
		<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
	</td>
</tr>
<TR>
	<td align='left' colspan=3><font class='EWLabel3' ><b>Request Type:</b>
		<select name="requestType" >
			<% if(reqType!=null){%>
			<option <%if(reqType.equals("Personal Loan-Postponement/Deferral")){%> value='Personal Loan-Postponement/Deferral' selected <%}else{%> value='Personal Loan-Postponement/Deferral' <%}%> >Personal Loan-Postponement/Deferral</option>
			<option  <%if(reqType.equals("Personal Loan-Part Settlement/Advance Installment Payment")){%> value='Personal Loan-Part Settlement/Advance Installment Payment' selected <%}else{%> value='Personal Loan-Part Settlement/Advance Installment Payment' <%}%>  >Personal Loan-Part Settlement/Advance Installment Payment</option>
			<option  <%if(reqType.equals("Personal Loan-Early Settlement(TakeOver and Cash and EOSB)")){%> value='Personal Loan-Early Settlement(TakeOver and Cash and EOSB)' selected <%}else{%> value='Personal Loan-Early Settlement(TakeOver and Cash and EOSB)' <%}%>  >Personal Loan-Early Settlement(TakeOver and Cash and EOSB)</option>
			<option  <%if(reqType.equals("Personal Loan-Instalment Recovery / Past Due Recovery")){%> value='Personal Loan-Instalment Recovery / Past Due Recovery' selected <%}else{%> value='Personal Loan-Instalment Recovery / Past Due Recovery' <%}%>  >Personal Loan-Instalment Recovery / Past Due Recovery</option>
			<option  <%if(reqType.equals("General Service Requests-Liability Certificate/No Liability Certificate")){%> value='General Service Requests-Liability Certificate/No Liability Certificate' selected <%}else{%> value='General Service Requests-Liability Certificate/No Liability Certificate' <%}%>  >General Service Requests-Liability Certificate/No Liability Certificate</option>
			<option  <%if(reqType.equals("General Service Requests-Change in Employer/Address for Loan Customers")){%> value='General Service Requests-Change in Employer/Address for Loan Customers' selected <%}else{%> value='General Service Requests-Change in Employer/Address for Loan Customers' <%}%>  >General Service Requests-Change in Employer/Address for Loan Customers</option>
			<option <%if(reqType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
			<%} else { %>
				<option  value="Personal Loan-Postponement/Deferral" >Personal Loan-Postponement/Deferral</option>
				<option  value="Personal Loan-Part Settlement/Advance Installment Payment" >Personal Loan-Part Settlement/Advance Installment Payment</option>
				<option  value="Personal Loan-Early Settlement(TakeOver and Cash and EOSB)" >Personal Loan-Early Settlement(TakeOver and Cash and EOSB)</option>
				<option  value="Personal Loan-Instalment Recovery / Past Due Recovery" >Personal Loan-Instalment Recovery / Past Due Recovery</option>
				<option  value="General Service Requests-Liability Certificate/No Liability Certificate" >General Service Requests-Liability Certificate/No Liability Certificate</option>
				<option  value="General Service Requests-Change in Employer/Address for Loan Customers" >General Service Requests-Change in Employer/Address for Loan Customers</option>
				<option  value="All" >All</option>
			<%}%>
		</select>
	</td>
</TR>
<TR>
	<td align='left' ><font class='EWLabel3' ><b>Branch Id:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type="text box" name="branchCode" maxlength=4  value = '<%=brCode==null?"":brCode%>'align = "left">
	</td>
</TR>
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
try{
  //query1="SELECT BRANCH,WI_NAME,AGREEMENTNO,CUSTOMERNAME,BRANCHUSERNAME,Current_Workstep_name  FROM RB_PL_PD_EXTTABLE WHERE Branch='"+brCode+"' order by WI_NAME ";
	/*sInputXML1=	"?xml version=\"1.0\"?>\n" +
	"<APProcedure_Input>\n" +
	"<Option>APProcedure2</Option>\n" +
	"<ProcName>"+procName+"</ProcName>" +
	"<Params>"+param+"</Params>\n" +
	"<SessionId>"+sSessionId+"</SessionId>\n"+
	"<EngineName>"+sCabname+"</EngineName>\n" +
	"</APProcedure_Input>\n";
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	out.println("sOutputXML1"+sOutputXML1);*/
	sInputXML1="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName+"</ProcName>" +						
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>8</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";
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
				//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
				//System.out.println("sachin:1 " + sOutputXML1) ;
				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="10%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Branch</center></span></td>
						<td width="25%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="25%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Registration No</center></span></td>
						<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Agreement ID</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>
					</tr>
			<%

				
				for(int j=0;j<rows.size();j++){
					
					columnData = rows.get(j).toString();
					
					String  winame = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String  branch = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String aggrementNo= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String customername= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String introducedby= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String introducedTime= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String currentsatge= columnData.substring(0);
					
					if(tempRequestType.equalsIgnoreCase("All")){
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("PD")){
							tempRequestType = "PL_PD";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("PS")){
							tempRequestType = "PL_PS";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ES")){
							tempRequestType = "PL_ES";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("IPDR")){
							tempRequestType = "PL_IPDR";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("LCOL")){
							tempRequestType = "GSR_LCOL";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("EmpAdd")){
							tempRequestType = "GSR_EMPADD";
						} 
					}
					if(tempRequestType.equalsIgnoreCase("PL_PD")){
						countPD++;
						tempRequestType = "Personal Loan-Postponement/Deferral";
					} else if(tempRequestType.equalsIgnoreCase("PL_PS")){
						countPS++;
						tempRequestType = "Personal Loan-Part Settlement/Advance Installment Payment";
					} else if(tempRequestType.equalsIgnoreCase("PL_ES")){
						countES++;
						tempRequestType = "Personal Loan-Early Settlement(TakeOver and Cash and EOSB)";
					} else if(tempRequestType.equalsIgnoreCase("PL_IPDR")){
						countIPDR++;
						tempRequestType = "Personal Loan-Instalment Recovery / Past Due Recovery";
					} else if(tempRequestType.equalsIgnoreCase("GSR_LCOL")){
						countLCOL++;
						tempRequestType = "General Service Requests-Liability Certificate/No Liability Certificate";
					} else if(tempRequestType.equalsIgnoreCase("GSR_EMPADD")){
						countEMPADD++;
						tempRequestType = "General Service Requests-Change in Employer/Address for Loan Customers";
					}

						%>
						<tr colspan=8>
		
							<td width="10%" class="EWTableContentsText" align='left'><%=branch==null?"":branch%></td>
							<td width="25%" class="EWTableContentsNum" ><center><%=tempRequestType==null?"":tempRequestType%> </center></td>
							<td width="25%" class="EWTableContentsText" align='left'><%=winame==null?"":winame%></td>
							<td width="10%" class="EWTableContentsNum" ><%=aggrementNo==null?"":aggrementNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=customername==null?"":customername%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=introducedby==null?"":introducedby%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=introducedTime==null?"":introducedTime%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=currentsatge==null?"":currentsatge%></td>
							</tr>
				<%
				//iRecd = iRecd+1;
				
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
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Postponement/Deferral</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countPD%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Part Settlement/Advance Installment Payment</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countPS%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Early Settlement(TakeOver and Cash and EOSB)</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countES%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Instalment Recovery / Past Due Recovery</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countIPDR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>General Service Requests-Liability Certificate/No Liability Certificate</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countLCOL%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>General Service Requests-Change in Employer/Address for Loan Customers</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countEMPADD%></B></center></td>
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

	
%>

<table align='center' cellspacing="1" cellpadding='1' width="90%">
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>
<tr><td><input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>"> </td></tr>
</form>
</body>
</html>

