<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       CardSummaryReport.jsp
	Purpose         :       To Display No. of Pending / Approved / Returned back to Branch Requests
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/041
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
  response.setHeader("Cache-Control","no-store");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader ("Expires", 0);
%>
<%
	String sInputXML="";
	String sInputXML1="";
	String sInputXML2="";
	String sOutputXML="";
	String sOutputXML1="";
	String sOutputXML2="";
	String sCabname="";
	String sSessionId="";
	String tempReqType="";
	String sJtsIp="";
	int iJtsPort= 0;
	String query1="";
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("decisionType", request.getParameter("decisionType"), 1000, true) );
	String decisionType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: decisionType: "+decisionType);
		
	
	String reqType = requestType;
	String decType = decisionType;
	String sel_dte_to = "";
	String sel_dte_from = "";
	String tempActivityName1 = "";
	boolean bError=false;
	ArrayList rows = new ArrayList();
	try
	{
		if(reqType!=null && !reqType.equals(""))
		{
			if(reqType.equalsIgnoreCase("Balance Transfer"))
			{
				tempReqType="DSR_BT";
			}
			else if(reqType.equalsIgnoreCase("Cash Back Request"))
			{
				tempReqType="DSR_CBR";
			}
			else if(reqType.equalsIgnoreCase("DebitCard Blocking Request"))
			{
				tempReqType="DSR_DCB";
			}
			else if(reqType.equalsIgnoreCase("Credit Card Cheque"))
			{
				tempReqType="DSR_CCC";
			}
			else if(reqType.equalsIgnoreCase("Miscellaneous Requests"))
			{
				tempReqType="DSR_MR";
			}
			else if(reqType.equalsIgnoreCase("Reversal Request"))
			{
				tempReqType="DSR_RR";
			}
			else if(reqType.equalsIgnoreCase("Other Debit Card Request"))
			{
				tempReqType="DSR_ODC";
			}
			else 
			{
				tempReqType="All";
			}
		}
	}
	catch(Exception ex)
	{
	}
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
	
	String param="";
	String procName2="SRM_CARD_SUMMARY_REPORT_DSR";
	ArrayList report = null;

	String columnData = "";
	String columndata2 = "";
	try
	{
		if (!reqType.equals(""))
		{
			WriteLog("saurabh  decType = "+decType+" reqType = "+reqType + final_date_from + final_date_to);
			String tempfromdate = final_date_from.substring(6,10)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
			String temptodate = final_date_to.substring(6,10)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
			param = "'"+tempfromdate+"','"+temptodate+"','"+decType+"','"+tempReqType+"'";
		}
	}
	catch(Exception e)
	{
		WriteLog("Exception aa: "+e.toString());
	}
%>
<html>
	<head>
	<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>

		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
		<title>Debit Card Status Report</title>
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
			var final_dt_from = dat_from;
			var final_dt_to =dat_to;
			var reqType = document.FTOReport.requestType.value;	
			var decType = document.FTOReport.decisionType.value;	

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

			document.FTOReport.action = "DebitCardSummaryReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
			+final_dt_to+"&reqType="+reqType+"&decType="+decType;
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
				alert("FROM DATE cannot be greater than TO DATE"); 
				return false;
			}
			return true;
		}
		function print_Report()
		{
			var dat_from = document.FTOReport.dte_from.value;
			var dat_to = document.FTOReport.dte_to.value;
			var reqType = document.FTOReport.requestType.value;	
			var decType = document.FTOReport.decisionType.value;		
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
			document.FTOReport.action = "DebitCardSummaryReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&reqType="+reqType+"&decType="+decType;
			document.FTOReport.submit;
		}
		function save_Report()
		{
			var dat_from = document.FTOReport.dte_from.value;
			var dat_to = document.FTOReport.dte_to.value;
			var reqType = document.FTOReport.requestType.value;	
			var decType = document.FTOReport.decisionType.value;		
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
			document.FTOReport.action = "DebitCardSummaryReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&reqType="+reqType+"&decType="+decType;
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
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DEBIT CARD SUMMARY REPORT</center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
			<tr>
				<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>&nbsp;&nbsp;&nbsp;
				</td>
				<td  align='left'><font class='EWLabel3' ><b>To Date : </b>&nbsp;&nbsp;
				<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
				</td>
			</tr>
		</table>
		<br>
		<table cellspacing="1" cellpadding='1'>
			<TR>
				<td><font class='EWLabel3' >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>&nbsp;&nbsp;&nbsp;&nbsp;Request Type:&nbsp;</b>
					<select name="requestType">
						<% if(reqType!=null && !reqType.equals("")){%>
						<!--<option <%if(reqType.equals("Balance Transfer")){%> value='Balance Transfer' selected <%}else{%> value='Balance Transfer' <%}%> >Balance Transfer</option>-->

						<option  <%if(reqType.equals("Cash Back Request")){%> value='Cash Back Request' selected <%}else{%> value='Cash Back Request' <%}%>  >Cash Back Request</option>

						<option  <%if(reqType.equals("DebitCard Blocking Request")){%> value='DebitCard Blocking Request' selected <%}else{%> value='DebitCard Blocking Request' <%}%>  >DebitCard Blocking Request</option>

						<!--<option  <%if(reqType.equals("Credit Card Cheque")){%> value='Credit Card Cheque' selected <%}else{%> value='Credit Card Cheque' <%}%>  >Credit Card Cheque</option>-->
						
						<option  <%if(reqType.equals("Miscellaneous Requests")){%> value='Miscellaneous Requests' selected <%}else{%> value='Miscellaneous Requests' <%}%>  >Miscellaneous Requests</option>

						<!--<option  <%if(reqType.equals("Reversal Request")){%> value='Reversal Request' selected <%}else{%> value='Reversal Request' <%}%>  >Reversal Request</option>-->

						<option  <%if(reqType.equals("Other Debit Card Request")){%> value='Other Debit Card Request' selected <%}else{%> value='Other Debit Card Request' <%}%>  >Other Debit Card Request</option> 

						<option <%if(reqType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
						<%} else { %>
							<!--<option  value="Balance Transfer" >Balance Transfer</option>-->
							<option  value="Cash Back Request" >Cash Back Request</option>
							<option  value="DebitCard Blocking Request" >DebitCard Blocking Request</option>
							<!--<option  value="Credit Card Cheque" >Credit Card Cheque</option>-->
							<option  value="Miscellaneous Requests" >Miscellaneous Requests</option>
							<!--<option  value="Reversal Request" >Reversal Request</option>-->
							<option  value="Other Debit Card Request" >Other Debit Card Request</option>
							<option  value="All" >All</option>
						<%}%>
					</select>
				</td>
				<td><font class='EWLabel3' >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>Decision:&nbsp;&nbsp;</b>
					<select name="decisionType">
						<% if(decType!=null){%>
						<option <%if(decType.equals("Approve")){%> value='Approve' selected <%}else{%> value='Approve' <%}%> >Complete</option>

						<option  <%if(decType.equals("Discard")){%> value='Discard' selected <%}else{%> value='Discard' <%}%>  >Discarded</option>

						<option  <%if(decType.equals("Resubmit")){%> value='Resubmit' selected <%}else{%> value='Resubmit' <%}%>  >Re-Submit to Branch</option>

						<option  <%if(decType.equals("UnderProcess")){%> value='UnderProcess' selected <%}else{%> value='UnderProcess' <%}%>  >Under Process</option>
						
						<option <%if(decType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
						<%} else { %>
							<option  value="Approve" >Complete</option>
							<option  value="Discard" >Discarded</option>
							<option  value="Resubmit" >Re-Submit to Branch</option>
							<option  value="UnderProcess" >Under Process</option>
							<option  value="All" >All</option>
						<%}%>
					</select>
				</td>
			<TR>
		</table>
		<br>
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
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CardSummaryReport.jsp
	Purpose         :       The report does not display the detailed records ,only summary was displayed
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/082				   Saurabh Arora	29/01/2009
*/
			try
			{
				String procName="SRM_CARD_DETAIL_REPORT_DSR";
				sInputXML1="<?xml version=\"1.0\"?>" + 				
							"<APProcedure2_Input>" +
							"<Option>APProcedure2</Option>" +
							"<ProcName>"+procName+"</ProcName>" +						
							"<Params>"+param+"</Params>" +  
							"<NoOfCols>10</NoOfCols>" +
							"<SessionID>"+sSessionId+"</SessionID>" +
							"<EngineName>"+sCabname+"</EngineName>" +
							"</APProcedure2_Input>";
				WriteLog("Card Detail Report: "+sInputXML1);
				sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
				WriteLog("Card Detail Report: "+sOutputXML1);
				if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)
				{
					String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
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
					if (Activityname.equalsIgnoreCase("Discard1"))
					{
						tempActivityName1="Discarded";
					}
					else if (Activityname.equalsIgnoreCase("Work Exit1"))
					{
						tempActivityName1="Complete";
					}
					else if (Activityname.equalsIgnoreCase("Branch_Return"))
					{
						tempActivityName1="Re-Submit to Branch";
					}
					else if (Activityname.equalsIgnoreCase("CARDS"))
					{
						tempActivityName1="Under Process";
					}
					if(tempRequestType.equalsIgnoreCase("DSR_BT"))
					{
						tempRequestType = "Balance Transfer";
					} 
					else if(tempRequestType.equalsIgnoreCase("DSR_CBR"))
					{
						tempRequestType = "Cash Back Request";
					}
					else if(tempRequestType.equalsIgnoreCase("DSR_DCB"))
					{
						tempRequestType = "DebitCard Blocking Request";
					} 
					else if(tempRequestType.equalsIgnoreCase("DSR_CCC"))
					{
						tempRequestType = "Credit Card Cheque";
					} 
					else if(tempRequestType.equalsIgnoreCase("DSR_MR"))
					{
						tempRequestType = "Miscellaneous Requests";
					}
					else if(tempRequestType.equalsIgnoreCase("DSR_RR"))
					{
						tempRequestType = "Reversals Request";
					}		
					else if(tempRequestType.equalsIgnoreCase("DSR_ODC"))
					{
						tempRequestType = "Other Debit Card Request";
					}	
		%>
				<tr colspan=10>
					<td width="10%" class="EWTableContentsText" align='left'><%=tempRequestType==null?"":tempRequestType%></td>
					<td width="30%" class="EWTableContentsNum" ><center><%=winame==null?"":winame%> </center></td>
					<td width="30%" class="EWTableContentsText" align='left'><%=CustomerName==null?"":CustomerName%></td>
					<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"":CardNumber%></td>
					<!--<td width="15%" class="EWTableContentsText" align='left'><%=CardCRN==null?"":CardCRN%></td>-->
					<td width="15%" class="EWTableContentsText" align='left'><%=EliteCustomerNo==null?"":EliteCustomerNo%></td>
					<td width="15%" class="EWTableContentsText" align='left'><%=InitiationBranch==null?"":InitiationBranch%></td>
					<td width="15%" class="EWTableContentsText" align='left'><%=Introducedby==null?"":Introducedby%></td>
					<td width="15%" class="EWTableContentsText" align='left'><%=Introductiondate==null?"":Introductiondate%></td>
					<td width="15%" class="EWTableContentsText" align='left'><%=Activityname==null?"":tempActivityName1%></td>
				</tr>
		<%
				}
			}
			try
			{
				sInputXML2="<?xml version=\"1.0\"?>" + 				
							"<APProcedure2_Input>" +
							"<Option>APProcedure2</Option>" +
							"<ProcName>"+procName2+"</ProcName>" +						
							"<Params>"+param+"</Params>" +  
							"<NoOfCols>2</NoOfCols>" +
							"<SessionID>"+sSessionId+"</SessionID>" +
							"<EngineName>"+sCabname+"</EngineName>" +
							"</APProcedure2_Input>";
				WriteLog("Report Request Summary Data: "+sInputXML2);
				sOutputXML2= WFCallBroker.execute(sInputXML2,sJtsIp,iJtsPort,1);
				WriteLog("Report Request Summary Data: "+sOutputXML2);
				if(!sOutputXML2.equals("") || Integer.parseInt(sOutputXML2.substring(sOutputXML2.indexOf("<MainCode>")+10 , sOutputXML2.indexOf("</MainCode>")))==0)
				{
					String result1 = sOutputXML2.substring(sOutputXML2.indexOf("<Results>")+9,sOutputXML2.indexOf("</Results>"));
					report = new ArrayList();
					StringTokenizer rowStr1 = new StringTokenizer(result1, "~");
					while(rowStr1.hasMoreTokens())
					{
						report.add(rowStr1.nextToken());
					}
				}
			}
			catch(Exception e)
			{
				out.println("Exception: "+e.toString());
			}
			int iRecd=0;
			if(report!=null && report.size()>0)
			{
			%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Decision Taken </center></span></td>
						<td width="20%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Count </center></span></td>
					</tr>
			<%
				String tempActivityName = "";
				int approveCount = 0;
				int discardCount = 0;
				int underProcessCount = 0;
				int ReSubmitCount=0;
				int totalCount=0;
				int requestCount=0;
/*	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       CardSummaryReport.jsp
	Purpose         :       Count not correct for some selections due to junk data corresponding to some workitems
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/079					21/01/2009	Saurabh Arora
*/
				for(int j=0;j<report.size();j++)
				{
					String columnData2 = report.get(j).toString();
					String ActivityName = columnData2.substring(0,columnData2.indexOf("!"));
					columnData2 = columnData2.substring(columnData2.indexOf("!")+1);
					columnData2 = columnData2.substring(columnData2.indexOf("!")+1);
					String Count= columnData2.substring(0);
					requestCount = Integer.parseInt(Count);

					if(ActivityName.equals("Approve")||ActivityName.equals("Complete"))
					{
						approveCount=approveCount+requestCount;
						totalCount=totalCount+requestCount;
					}
					if(ActivityName.equals("Discard"))
					{
						discardCount=discardCount+requestCount;
						totalCount=totalCount+requestCount;
					}
					if(ActivityName.equals("Re-Submit to Branch")||ActivityName.equals("Resubmit to BRANCH")||ActivityName.equals("Resubmit to Branch"))
					{
						ReSubmitCount=ReSubmitCount+requestCount;
						totalCount=totalCount+requestCount;
					}
					if(ActivityName.equals("Under Process"))
					{
						underProcessCount=underProcessCount+requestCount;
						totalCount=totalCount+requestCount;
					}
				}
//					if (approveCount!=0)
//					{
			%>
					<tr colspan=10>
						<td width="20%" class="EWTableContentsText" align='left'><center>Complete</center></td>
						<td width="20%" class="EWTableContentsText" align='center'><center><%=approveCount%></center></td>
					</tr>
			<%		
//					}
//					if (discardCount!=0)
//					{
			%>
					<tr colspan=10>
						<td width="20%" class="EWTableContentsText" align='left'><center>Discarded</center></td>
						<td width="20%" class="EWTableContentsText" align='center'><center><%=discardCount%></center></td>
					</tr>
			<%			
//					}
//					if (ReSubmitCount!=0)
//					{
			%>
					<tr colspan=10>
						<td width="20%" class="EWTableContentsText" align='left'><center>Re-Submit to Branch</center></td>
						<td width="20%" class="EWTableContentsText" align='center'><center><%=ReSubmitCount%></center></td>
					</tr>
			<%	
//					}
//					if (underProcessCount!=0)
//					{
			%>
					<tr colspan=10>
						<td width="20%" class="EWTableContentsText" align='left'><center>Under Process</center></td>
						<td width="20%" class="EWTableContentsText" align='center'><center><%=underProcessCount%></center></td>
					</tr>
			<%		
//					}
			%>
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Total Requests: </center></span></td>
						<td width="20%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center><%=totalCount%> </center></span></td>
					</tr>
			<%
			}
			if(report==null || report.size()<=0)
			{
				%>
				<br>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
					<td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Record Found</font></B></center></td>
					</tr></table>
				</table><br>
				<%
			}
		}
		%>
			<br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%">
				<tr>
					<td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
				</tr>
			</table>
			<table>
				<tr>
					<td>
						<input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>">
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>