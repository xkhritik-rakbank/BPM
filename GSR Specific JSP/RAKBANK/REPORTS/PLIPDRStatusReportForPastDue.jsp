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

/*String sCabname=wfsession.getEngineName();
String sSessionId = wfsession.getSessionId();
String sJtsIp = wfsession.getJtsIp();
int iJtsPort = wfsession.getJtsPort();*/
WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
String sCabname = wDCabinetInfo.getM_strCabinetName();
String sSessionId = wDUserInfo.getM_strSessionId();
String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
int iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
DateFormat dtFormat = new SimpleDateFormat( "dd-MM-yyyy"+ " hh:mm:ss");
String currentdate = dtFormat.format(new java.util.Date());

String final_date_to = request.getParameter("fnl_date_to");
String final_date_from = request.getParameter("fnl_date_from");
String brCode = request.getParameter("branchCode");

ArrayList rows = null;
String sInputXML1="";
String sOutputXML1="";

String procName="PL_IPDR_STATUS_REPORT_FOR_PAST_DUE";
String param="";
String columnData = "";

String tempfromdate = "";
String temptodate = "";

try {
if (final_date_from != null && final_date_to != null && brCode != null) {
	tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
	temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
	param = "'"+brCode+"','"+tempfromdate+"','"+temptodate+"'";
}
} catch (Exception e) {
	e.printStackTrace();
}



%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">

<title>Personal Loan - Status Report for Past Due</title>
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
	
	//var reqType = document.FTOReport.requestType.value;
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

	
	document.FTOReport.action = "PLIPDRStatusReportForPastDue.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&branchCode="+branchCode;
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
	//var reqType = document.FTOReport.requestType.value;
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

	

	document.FTOReport.action = "PLIPDRStatusReportForPastDuePrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&branchCode="+branchCode;
	document.FTOReport.submit;
}
function save_Report()
{
	
	var dat_from = document.FTOReport.dte_from.value;
	var dat_to = document.FTOReport.dte_to.value;
	//var reqType = document.FTOReport.requestType.value;
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
	
	
	document.FTOReport.action = "PLIPDRStatusReportForPastDuePrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&branchCode="+branchCode;
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Personal Loan</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;STATUS REPORT FOR PAST DUE</center></td>
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
<%
if(final_date_from==null || final_date_from=="")
{
	
}
else
{
	
try{

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

//int iRecd=0;
	if(rows!=null && rows.size()>0)
		  {
				//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
				//System.out.println("sachin:1 " + sOutputXML1) ;
				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="10%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Registration No</center></span></td>
						<td width="25%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="25%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Agreement No.</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Master No.</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Debit Account</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Branch Approver/Collections Descision</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Branch Approver/Collections Reason</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Recovery Amount</center></span></td>
					</tr>
			<%

				
				for(int j=0;j<rows.size();j++){
					
					columnData = rows.get(j).toString();
					
					String  winame = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String  introducedBy = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String introductionDateTime = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String aggrementNo= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String debitAccountNo= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String baDescision= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String baReason= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String insrecamount = columnData.substring(0);
					
					
					
					
					

						%>
						<tr colspan=9>
		
							<td width="10%" class="EWTableContentsText" align='left'><%=winame==null || winame.trim().equalsIgnoreCase("null") || winame.trim().equalsIgnoreCase("")?"&nbsp;":winame%></td>
							<td width="25%" class="EWTableContentsNum" ><center><%=introducedBy==null || introducedBy.trim().equalsIgnoreCase("null") || introducedBy.trim().equalsIgnoreCase("")?"&nbsp;":introducedBy%> </center></td>
							<td width="25%" class="EWTableContentsText" align='left'><%=introductionDateTime==null || introductionDateTime.trim().equalsIgnoreCase("null") || introductionDateTime.trim().equalsIgnoreCase("")?"&nbsp;":introductionDateTime%></td>
							<td width="10%" class="EWTableContentsNum" ><%=aggrementNo==null || aggrementNo.trim().equalsIgnoreCase("null") || aggrementNo.trim().equalsIgnoreCase("") ?"&nbsp;":aggrementNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'>&nbsp;</td>
							<td width="15%" class="EWTableContentsText" align='left'><%=debitAccountNo==null || debitAccountNo.trim().equalsIgnoreCase("null") || debitAccountNo.trim().equalsIgnoreCase("")?"&nbsp;":debitAccountNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=baDescision==null || baDescision.trim().equalsIgnoreCase("null") || baDescision.trim().equalsIgnoreCase("") ?"&nbsp;":baDescision%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=baReason==null || baReason.trim().equalsIgnoreCase("null") || baReason.trim().equalsIgnoreCase("") ?"&nbsp;":baReason%></td>

							<td width="15%" class="EWTableContentsText" align='left'><%=insrecamount==null || insrecamount.trim().equalsIgnoreCase("null") || insrecamount.trim().equalsIgnoreCase("") ?"&nbsp;":insrecamount%></td>
							
						</tr>
				<%
				//iRecd = iRecd+1;
				
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
%>
<table align='center' cellspacing="1" cellpadding='1' width="90%">
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>
<tr><td><input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>"> </td></tr>
</form>
</body>
</html>