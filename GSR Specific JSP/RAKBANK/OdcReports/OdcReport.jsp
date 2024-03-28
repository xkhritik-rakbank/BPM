<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       ODCReport.jsp
	Purpose         :       ODC Report on the lines of Card Volume Report
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/039	
--%>
<%@ include file="../../DSRProcessSpecific/Log.process"%>
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
	String sInputXML1="";
	String sOutputXML1="";
	String sCabname="";
	String sSessionId="";
	String sJtsIp="";
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	
	
	
	int iJtsPort= 0;
	int tolCount1 =0;
	int i=0;
	boolean bError=false;
	try
	{
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
	catch(Exception ignore)
	{
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
	
		String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
	//WriteLog("Integration jsp: fnl_date_to cmpl: "+fnl_date_to);
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Dateto);
	
	String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
	//WriteLog("Integration jsp: fnl_date_from cmpl: "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Datefrom);
		
	if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}

	
	String final_date_to = fnl_Dateto;
	String final_date_from = fnl_Datefrom;
	String reqType = requestType;
	
	
	String tempReqType="";
	String param="";
	String procName="SRM_ODC_REPORT";
	ArrayList rows = null;
	String columnData = "";

	int countRIP=0;
	int countCR=0;
	int countECR=0;
	int countCLI=0;
	int countCU=0;
	int countTD=0;
	int countOCC=0;
	int countCSI=0;
	int countCDR=0;
	int countCS=0;
	int countSSC=0;

	String procName1="SRM_CARD_ODC_CARD_DECISION_REPORT";
	ArrayList rows1 = null;
	String param1 = "";

	try
	{
		if(reqType!=null && !reqType.equals(""))
		{
			if(reqType.equalsIgnoreCase("Re-Issue of PIN"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Card Replacement"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Early Card Renewal"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Credit Limit Increase"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Card Upgrade"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Transaction Dispute"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Change in Standing Instructions"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Card Delivery Request"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Credit Shield"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Setup Suppl. Card Limit"))
			{
				tempReqType="DSR_ODC";
			}
			else 
			{
				tempReqType="All";
			}
		}

		String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);

		if((reqType.equalsIgnoreCase("Re-Issue of PIN"))|| (reqType.equalsIgnoreCase("Card Replacement")) ||(reqType.equalsIgnoreCase("Early Card Renewal")) || (reqType.equalsIgnoreCase("Card Upgrade")) || (reqType.equalsIgnoreCase("Transaction Dispute")) || (reqType.equalsIgnoreCase("Change in Standing Instructions")) || (reqType.equalsIgnoreCase("Card Delivery Request")) || (reqType.equalsIgnoreCase("Credit Shield")) || (reqType.equalsIgnoreCase("Setup Suppl. Card Limit")) ||(reqType.equalsIgnoreCase("Credit Limit Increase")))
		{
			param = "'"+reqType+"','"+tempfromdate+"','"+temptodate+"'";
			param1 = "'"+tempfromdate+"','"+temptodate+"','"+reqType+"'";
		}
		else
		{
			param = "'"+tempReqType+"','"+tempfromdate+"','"+temptodate+"'";
			param1 = "'"+tempfromdate+"','"+temptodate+"','"+tempReqType+"'";
		}
	}
	catch(Exception ex)
	{
	}
%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">

<title>Other Debit Card Request Report</title>
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
	var final_dt_from = dat_from;
	var final_dt_to =dat_to;
	
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

	document.FTOReport.action = "OdcReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&requestType="+reqType;
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
	return true;
}
function print_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var reqType = document.FTOReport.requestType.value;
	var dat_to = document.FTOReport.dte_to.value;
	var final_dt_from = dat_from;
	var final_dt_to =dat_to;
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
	document.FTOReport.action = "OdcReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&requestType="+reqType;
	document.FTOReport.submit;
}
function save_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var dat_to = document.FTOReport.dte_to.value;
	var reqType = document.FTOReport.requestType.value;
	var final_dt_from = dat_from;
	var final_dt_to =dat_to;
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
	document.FTOReport.action = "OdcReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&requestType="+reqType;
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SRM-DEBITCARDS</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OTHER DEBIT CARD REQUEST REPORT</center></td>
  </tr>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
<tr>
	<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date :      </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
		 &nbsp;&nbsp;&nbsp;
	</td>
	<td  align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
	</td>
</tr>
</table>
<table cellspacing="1" cellpadding='1'>
<TR>
	<td align='left' ><font class='EWLabel3' > &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; <b>Request Type:&nbsp;</b>
		<select name="requestType" >
			<% if(reqType!=null && !reqType.equals("")){%>
			<option  <%if(reqType.equals("Card Delivery Request")){%> value='Card Delivery Request' selected <%}else{%> value='Card Delivery Request' <%}%>  >Card Delivery Request</option>

			<option  <%if(reqType.equals("Card Replacement")){%> value='Card Replacement' selected <%}else{%> value='Card Replacement' <%}%>  >Card Replacement</option>

			<!--<option  <%if(reqType.equals("Card Upgrade")){%> value='Card Upgrade' selected <%}else{%> value='Card Upgrade' <%}%>  >Card Upgrade</option>-->

			<!--<option  <%if(reqType.equals("Change in Standing Instructions")){%> value='Change in Standing Instructions' selected <%}else{%> value='Change in Standing Instructions' <%}%>  >Change in Standing Instructions</option>-->

			<!--<option  <%if(reqType.equals("Credit Limit Increase")){%> value='Credit Limit Increase' selected <%}else{%> value='Credit Limit Increase' <%}%>  >Credit Limit Increase</option>-->
		
			<!--<option  <%if(reqType.equals("Credit Shield")){%> value='Credit Shield' selected <%}else{%> value='Credit Shield' <%}%>  >Credit Shield</option>-->

			<option  <%if(reqType.equals("Early Card Renewal")){%> value='Early Card Renewal' selected <%}else{%> value='Early Card Renewal' <%}%>  >Early Card Renewal</option>

			<option  <%if(reqType.equals("Re-Issue of PIN")){%> value='Re-Issue of PIN' selected <%}else{%> value='Re-Issue of PIN' <%}%>  >Re-Issue of PIN</option> 

			<!--<option  <%if(reqType.equals("Setup Suppl. Card Limit")){%> value='Setup Suppl. Card Limit' selected <%}else{%> value='Setup Suppl. Card Limit' <%}%>  >Setup Suppl. Card Limit</option>-->
			
			<option  <%if(reqType.equals("Transaction Dispute")){%> value='Transaction Dispute' selected <%}else{%> value='Transaction Dispute' <%}%>  >Transaction Dispute</option>

			<option <%if(reqType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
			<%} else { %>
				<option  value="Card Delivery Request" >Card Delivery Request</option>
				<option  value="Card Replacement" >Card Replacement</option>
				<!--<option  value="Card Upgrade" >Card Upgrade</option>
				<option  value="Change in Standing Instructions" >Change in Standing Instructions</option>
				<option  value="Credit Limit Increase" >Credit Limit Increase</option>
				<option  value="Credit Shield" >Credit Shield</option>-->
				<option  value="Early Card Renewal" >Early Card Renewal</option>
				<option  value="Re-Issue of PIN" >Re-Issue of PIN</option>
				<!--<option  value="Setup Suppl. Card Limit" >Setup Suppl. Card Limit</option>-->
				<option  value="Transaction Dispute" >Transaction Dispute</option>
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
try
{
	sInputXML1="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName+"</ProcName>" +						
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>10</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";

	WriteLog(sInputXML1);
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	WriteLog(sOutputXML1);
	if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)	{
		String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
		rows = new ArrayList();
		StringTokenizer rowStr = new StringTokenizer(result, "~");
		while(rowStr.hasMoreTokens())
		{
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
				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>RequestType</center></span></td>
						<td width="30%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> RegistrationNo. </center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardNumber</center></span></td>
						<!--<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardCRN</center></span></td>-->
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>MasterNo.</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="4%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="3%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>
					</tr>
			<%
				for(int j=0;j<rows.size();j++)
				{
					
					columnData = rows.get(j).toString();

					String winame = columnData.substring(0,columnData.indexOf("!"));
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
					String Introducedby= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String Introductiondate= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String Activityname= columnData.substring(0);
					
					if(tempRequestType.equalsIgnoreCase("All"))
					{
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ODC"))
						{ 
							tempRequestType = "DSR_ODC";
						} 
					}
					if(tempRequestType.equalsIgnoreCase("Re-Issue of PIN")){
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
						countOCC++;
						tempRequestType = "Other Credit Card";
					}
				    	%>
						<tr colspan=10>
		
							<td width="10%" class="EWTableContentsText" align='left'><%=tempRequestType==null?"":tempRequestType%></td>
							<td width="30%" class="EWTableContentsNum" ><center><%=winame==null?"":winame%> </center></td>
							<td width="30%" class="EWTableContentsText" align='left'><%=CustomerName==null?"":CustomerName%></td>
							<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"":CardNumber%></td>
							<!--<td width="15%" class="EWTableContentsText" align='left'><%=CardCRN==null?"":CardCRN%></td>
							--><td width="15%" class="EWTableContentsText" align='left'><%=EliteCustomerNo==null?"":EliteCustomerNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=InitiationBranch==null?"":InitiationBranch%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=Introducedby==null?"":Introducedby%></td>
							 <td width="15%" class="EWTableContentsText" align='left'><%=Introductiondate==null?"":Introductiondate%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=Activityname==null?"":Activityname%></td>
</tr>
				<%
			}
		}
		if(!reqType.equals("All") && rows!=null && rows.size()>0)
		{%><br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Summary</B></center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="4">
			<td width="50%" class="EWSubHeaderText" ><center><B><%=reqType%></B></center></td>
			<td width="50%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
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
					<td width="50%" class="EWSubHeaderText" ><center><B>Card Delivery Request</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countCDR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Card Replacement</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countCR%></B></center></td>
				</tr>
				<!--<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Card Upgrade</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countCU%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Change in Standing Instructions</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countCSI%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Credit Limit Increase</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countCLI%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Credit Shield</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countCS%></B></center></td>
				</tr>-->
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Early Card Renewal</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countECR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Re-Issue of PIN</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countRIP%></B></center></td>
				</tr><!--
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Setup Suppl. Card Limit</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countSSC%></B></center></td>
				</tr>-->
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Transaction Dispute</B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=countTD%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="50%" class="EWSubHeaderText" ><center><B>Grand Total </B></center></td>
					<td width="50%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
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
		out.println("In Exception: "+e.toString());
	}

	if(rows1!=null && rows1.size()>0)
	{
		String ripExit = "0";
		String ripDiscard = "0";
		String ripInitiated = "0";
		String ripUnderProcess = "0";
		String ripRFB = "0";
		String crExit = "0";
		String crDiscard = "0";
		String crInitiated = "0";
		String crUnderProcess = "0";
		String crRFB = "0";
		String cuExit = "0";
		String cuDiscard = "0";
		String cuInitiated = "0";
		String cuUnderProcess = "0";
		String cuRFB = "0";
		String tdExit = "0";
		String tdDiscard = "0";
		String tdInitiated = "0";
		String tdUnderProcess = "0";
		String tdRFB = "0";
		String csiExit = "0";
		String csiDiscard = "0";
		String csiInitiated = "0";
		String csiUnderProcess = "0";
		String csiRFB = "0";
		String cdrExit = "0";
		String cdrDiscard = "0";
		String cdrInitiated = "0";
		String cdrUnderProcess = "0";
		String cdrRFB = "0";
		String ecrExit = "0";
		String ecrDiscard = "0";
		String ecrInitiated = "0";
		String ecrUnderProcess = "0";
		String ecrRFB = "0";
		String csExit = "0";
		String csDiscard = "0";
		String csInitiated = "0";
		String csUnderProcess = "0";
		String csRFB = "0";
		String ssclExit = "0";
		String ssclDiscard = "0";
		String ssclInitiated = "0";
		String ssclUnderProcess = "0";
		String ssclRFB = "0";
		String cliExit = "0";
		String cliDiscard = "0";
		String cliInitiated = "0";
		String cliUnderProcess = "0";
		String cliRFB = "0";

		String requestType1 = "";
		String status1 = "";
		String count1 = "";

		int cdInitiatedTotVol = 0;
		int cdExitTotVol = 0;
		int cdDiscardTotVol = 0;
		int cdUnderProcessTotVol = 0;
		int cdRFBTotVol = 0;

		for(int j=0;j<rows1.size();j++)
		{
			columnData = rows1.get(j).toString();

			requestType1 = columnData.substring(0,columnData.indexOf("!"));
			columnData = columnData.substring(columnData.indexOf("!")+1);
			status1  = columnData.substring(0,columnData.indexOf("!"));
			columnData = columnData.substring(columnData.indexOf("!")+1);
			count1 = columnData.substring(0);

			if (reqType.equalsIgnoreCase("Re-Issue of PIN")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Re-Issue of PIN"))
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
						ripRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(ripRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Card Replacement")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Card Replacement"))
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
						crRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(crRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Early Card Renewal")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Early Card Renewal"))
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
						ecrRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(ecrRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Credit Limit Increase")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Credit Limit Increase"))
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
						cliRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(cliRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Card Upgrade")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Card Upgrade"))
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
						cuRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(cuRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Transaction Dispute")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Transaction Dispute"))
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
						tdRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(tdRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Change in Standing Instructions")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Change in Standing Instructions"))
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
						csiRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(csiRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Card Delivery Request")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Card Delivery Request"))
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
						cdrRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(cdrRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Credit Shield")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Credit Shield"))
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
						csRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(csRFB);
					}	
				}
			}
			if (reqType.equalsIgnoreCase("Setup Suppl. Card Limit")||tempReqType.equalsIgnoreCase("All"))
			{
				if (requestType1.equalsIgnoreCase("Setup Suppl. Card Limit"))
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
						ssclRFB = count1;
						cdRFBTotVol = cdRFBTotVol + Integer.parseInt(ssclRFB);
					}						
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
					<td width="16%" class="EWSubHeaderText" ><center><B>Complete</B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B>Discarded</B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B>Under Process</B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B>Initiated</B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B>Returned From Branch</B></center></td>
				</tr>
		<%
			if (reqType.equalsIgnoreCase("Re-Issue of PIN")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Re-Issue of PIN</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ripExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ripDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ripUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ripInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ripRFB%></B></center></td>
				</tr>
		<%
			}
			if (reqType.equalsIgnoreCase("Card Replacement")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Card Replacement</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=crExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=crDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=crUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=crInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=crRFB%></B></center></td>
				</tr>
		<%		
			}
			if (reqType.equalsIgnoreCase("Early Card Renewal")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Early Card Renewal</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ecrExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ecrDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ecrUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ecrInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ecrRFB%></B></center></td>
				</tr>
		<%		
			}
			if (reqType.equalsIgnoreCase("Credit Limit Increase")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<!--<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Credit Limit Increase</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cliExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cliDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cliUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cliInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cliRFB%></B></center></td>
				</tr>-->
		<%		
			}
			if (reqType.equalsIgnoreCase("Card Upgrade")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<!--<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Card Upgrade</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cuExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cuDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cuUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cuInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cuRFB%></B></center></td>
				</tr>-->
		<%		
			}
			if (reqType.equalsIgnoreCase("Transaction Dispute")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Transaction Dispute</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=tdExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=tdDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=tdUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=tdInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=tdRFB%></B></center></td>
				</tr>
		<%		
			}
			if (reqType.equalsIgnoreCase("Change in Standing Instructions")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<!--<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Change in Standing Instructions</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csiExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csiDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csiUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csiInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csiRFB%></B></center></td>
				</tr>-->
		<%		
			}
			if (reqType.equalsIgnoreCase("Card Delivery Request")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Card Delivery Request</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cdrExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cdrDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cdrUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cdrInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=cdrRFB%></B></center></td>
				</tr>
		<%		
			}
			if (reqType.equalsIgnoreCase("Credit Shield")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<!--<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Credit Shield</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=csRFB%></B></center></td>
				</tr>-->
		<%		
			}
			if (reqType.equalsIgnoreCase("Setup Suppl. Card Limit")||reqType.equalsIgnoreCase("All"))
			{
		%>
				<!--<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Setup Suppl. Card Limit</B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ssclExit%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ssclDiscard%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ssclUnderProcess%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ssclInitiated%></B></center></td>
					<td width="16%" class="EWTableContentsText" ><center><B><%=ssclRFB%></B></center></td>
				</tr>-->
		<%		
			}
		%>
				<tr colspan="4">
					<td width="16%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B><%=cdExitTotVol%></B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B><%=cdDiscardTotVol%></B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B><%=cdUnderProcessTotVol%></B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B><%=cdInitiatedTotVol%></B></center></td>
					<td width="16%" class="EWSubHeaderText" ><center><B><%=cdRFBTotVol%></B></center></td>
				</tr>
			</table>
		<%
	}
}

%>
<table align='center' cellspacing="1" cellpadding='1' width="90%">
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>
<tr><td><input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>"> </td></tr>
</form>
</body>
</html>
