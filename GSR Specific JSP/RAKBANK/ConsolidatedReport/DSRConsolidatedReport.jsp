<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       ConsolidatedReport.jsp
	Purpose         :       Consolidated Report for Balance Transfer, Cash Back, Credit Card Cheque, Re – issue of Pin, Credit shield
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/092					27/5/2009	Saurabh Arora
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
	//WriteLog("Integration jsp: requestType: "+requestType);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("from_time", request.getParameter("from_time"), 1000, true) );
	String from_time_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: from_time: "+from_time_1);
	String fromt_time_2 = from_time_1.replaceAll("&#x3a;",":");
	WriteLog("Integration jsp: fromt_time_2: "+fromt_time_2);
	
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("to_time", request.getParameter("to_time"), 1000, true) );
	String to_time_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: to_time: "+to_time_1);
	String to_time_2 = to_time_1.replaceAll("&#x3a;",":");
	WriteLog("Integration jsp: to_time_2: "+to_time_2);
	
	String reqType = requestType;
	String from_time = fromt_time_2;
	String to_time = to_time_2;
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
				tempReqType="CSR_BT";
			}
			else if(reqType.equalsIgnoreCase("Cash Back Request"))
			{
				tempReqType="DSR_CBR";
			}
			else if(reqType.equalsIgnoreCase("Credit Card Cheque"))
			{
				tempReqType="CSR_CCC";
			}
			else if(reqType.equalsIgnoreCase("Re-Issue of Pin"))
			{
				tempReqType="DSR_ODC";
			}
			else if(reqType.equalsIgnoreCase("Credit Shield"))
			{
				tempReqType="CSR_OCC";
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
	WriteLog("A1: "+final_date_to);
	String final_date_from = fnl_Datefrom;
	String param="";
	String procNameBT="SRM_CARDS_CONSOLIDATED_REPORT_BT";
	String procNameCBR="SRM_DSR_CARDS_CONSOLIDATED_REPORT_CBR";
	String procNameCCC="SRM_CARDS_CONSOLIDATED_REPORT_CCC";
	String procNameRIP="SRM_DSR_CARDS_CONSOLIDATED_REPORT_RIP";
	String procNameCS="SRM_CARDS_CONSOLIDATED_REPORT_CS";
	ArrayList report = null;

	String columnData = "";
	String columndata2 = "";
	try
	{
		if (!reqType.equals(""))
		{
			WriteLog("saurabh  reqType = "+reqType + final_date_from + final_date_to);
			String tempfromdate = final_date_from.substring(6,10)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
			String temptodate = final_date_to.substring(6,10)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
			param = "'"+tempfromdate+"','"+temptodate+"','"+from_time+"','"+to_time+"'";
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
		<title>Consolidated Report</title>
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
			var time_from = document.FTOReport.fromTime.value;
			var time_to = document.FTOReport.toTime.value;

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
			if (time_from==""||time_from==" ")
			{
				time_from="00:01";
			}
			else
			{
				if(time_from.indexOf(":") == -1)
				{
					alert("Enter correct From Time (24 hour HH:MM format)");
					document.FTOReport.fromTime.focus();
					return false;
				}
				var spl = time_from.split(":");
				if(parseInt(spl[0], 10) < 24 && parseInt(spl[1], 10) < 60)
				{
				}
				else
				{
					alert("Enter correct From Time (24 hour HH:MM format)");
					document.FTOReport.fromTime.focus();
					return false;				
				}
			}
			if (time_to==""||time_to==" ")
			{
				time_to="23:59";
			}
			else
			{
				if(time_to.indexOf(":") == -1)
				{
					alert("Enter correct To Time (24 hour HH:MM format)");
					document.FTOReport.toTime.focus();
					return false;
				}
				var sp2 = time_to.split(":");
				if(parseInt(sp2[0], 10) < 24 && parseInt(sp2[1], 10) < 60)
				{
				}
				else
				{
					alert("Enter correct To Time (24 hour HH:MM format)");
					document.FTOReport.toTime.focus();
					return false;					
				}
			}
			document.FTOReport.action = "DSRConsolidatedReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
			+final_dt_to+"&reqType="+reqType+"&from_time="+time_from+"&to_time="+time_to;
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
			var final_dt_from = dat_from;
			var final_dt_to =dat_to;
			var time_from = document.FTOReport.fromTime.value;
			var time_to = document.FTOReport.toTime.value;
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
			if (time_from==""||time_from==" ")
			{
				time_from="00:01";
			}
			else
			{
				if(time_from.indexOf(":") == -1)
				{
					alert("Enter correct From Time (24 hour HH:MM format)");
					document.FTOReport.fromTime.focus();
					return false;
				}
				var spl = time_from.split(":");
				if(parseInt(spl[0], 10) < 24 && parseInt(spl[1], 10) < 60)
				{
				}
				else
				{
					alert("Enter correct From Time (24 hour HH:MM format)");
					document.FTOReport.fromTime.focus();
					return false;				
				}
			}
			if (time_to==""||time_to==" ")
			{
				time_to="23:59";
			}
			else
			{
				if(time_to.indexOf(":") == -1)
				{
					alert("Enter correct To Time (24 hour HH:MM format)");
					document.FTOReport.toTime.focus();
					return false;
				}
				var sp2 = time_to.split(":");
				if(parseInt(sp2[0], 10) < 24 && parseInt(sp2[1], 10) < 60)
				{
				}
				else
				{
					alert("Enter correct To Time (24 hour HH:MM format)");
					document.FTOReport.toTime.focus();
					return false;					
				}
			}
			document.FTOReport.action = "DSRConsolidatedReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&reqType="+reqType+"&from_time="+time_from+"&to_time="+time_to;
			document.FTOReport.submit;
		}
		function save_Report()
		{
			var dat_from = document.FTOReport.dte_from.value;
			var dat_to = document.FTOReport.dte_to.value;
			var reqType = document.FTOReport.requestType.value;	
			var final_dt_from = dat_from;
			var final_dt_to =dat_to;
			var time_from = document.FTOReport.fromTime.value;
			var time_to = document.FTOReport.toTime.value;
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
			if (time_from==""||time_from==" ")
			{
				time_from="00:01";
			}
			else
			{
				if(time_from.indexOf(":") == -1)
				{
					alert("Enter correct From Time (24 hour HH:MM format)");
					document.FTOReport.fromTime.focus();
					return false;
				}
				var spl = time_from.split(":");
				if(parseInt(spl[0], 10) < 24 && parseInt(spl[1], 10) < 60)
				{
				}
				else
				{
					alert("Enter correct From Time (24 hour HH:MM format)");
					document.FTOReport.fromTime.focus();
					return false;				
				}
			}
			if (time_to==""||time_to==" ")
			{
				time_to="23:59";
			}
			else
			{
				if(time_to.indexOf(":") == -1)
				{
					alert("Enter correct To Time (24 hour HH:MM format)");
					document.FTOReport.toTime.focus();
					return false;
				}
				var sp2 = time_to.split(":");
				if(parseInt(sp2[0], 10) < 24 && parseInt(sp2[1], 10) < 60)
				{
				}
				else
				{
					alert("Enter correct To Time (24 hour HH:MM format)");
					document.FTOReport.toTime.focus();
					return false;					
				}
			}
			document.FTOReport.action = "DSRConsolidatedReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&reqType="+reqType+"&from_time="+time_from+"&to_time="+time_to;
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
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SRM-CARDS</center></td>
			</tr>
			<tr>  
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CONSLIDATED REPORT</center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
			<tr>
				<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>&nbsp;&nbsp;&nbsp;
				</td>
				<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Time (24 hour HH:MM format): </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="fromTime" id='time_f' align = "left" maxlength="5" value = '<%=from_time==null?"":from_time%>' >&nbsp;&nbsp;&nbsp;
				</td>
			</tr>

			<tr><% WriteLog("A: "+final_date_to);%>
				<td  align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date'></a>&nbsp;&nbsp;&nbsp;
				</td>
				<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To Time (24 hour HH:MM format): </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="toTime" id='time_t' align = "left" maxlength="5" value = '<%=to_time==null?"":to_time%>'>&nbsp;&nbsp;&nbsp;
				</td>
			</tr>
		</table>
		<table cellspacing="1" cellpadding='1'>
			<TR>
				<td><font class='EWLabel3' >&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>&nbsp;&nbsp;&nbsp;&nbsp;Request Type:</b>
					<select name="requestType">
						<% 
						WriteLog("saurabh 123 : " + reqType);
						if(reqType!=null && !reqType.equals("")){
							WriteLog("inside");
							%>
						<!--<option <%if(reqType.equals("Balance Transfer")){%> value='Balance Transfer' selected <%}else{%> value='Balance Transfer' <%}%> >Balance Transfer</option>-->

						<option <%if(reqType.equals("Cash Back Request")){%> value='Cash Back Request' selected <%}else{%> value='Cash Back Request' <%}%> >Cash Back Request</option>

						<!--<option <%if(reqType.equals("Credit Card Cheque")){%> value='Credit Card Cheque' selected <%}else{%> value='Credit Card Cheque' <%}%> >Credit Card Cheque</option>-->

						<option <%if(reqType.equals("Re-Issue of Pin")){%> value='Re-Issue of Pin' selected <%}else{%> value='Re-Issue of Pin' <%}%> >Re-Issue of Pin</option>

						<!--<option <%if(reqType.equals("Credit Shield")){%> value='Credit Shield' selected <%}else{%> value='Credit Shield' <%}%> >Credit Shield</option>-->

						<%} else { %>
							<!--<option  value="Balance Transfer" >Balance Transfer</option>-->
							<option  value="Cash Back Request" >Cash Back Request</option>
							<!--<option  value="Credit Card Cheque" >Credit Card Cheque</option>-->
							<option  value="Re-Issue of Pin" >Re-Issue of Pin</option>
							<!--<option  value="Credit Shield" >Credit Shield</option>-->
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
			WriteLog("reqType "+reqType);
			if (reqType.equals("Balance Transfer"))
			{
				try
				{
					sInputXML1="<?xml version=\"1.0\"?>" + 				
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>"+procNameBT+"</ProcName>" +						
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>12</NoOfCols>" +
								"<SessionID>"+sSessionId+"</SessionID>" +
								"<EngineName>"+sCabname+"</EngineName>" +
								"</APProcedure2_Input>";
					WriteLog("Consolidated Report BT: "+sInputXML1);
					sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
					WriteLog("Consolidated Report: "+sOutputXML1);
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
					//out.println("In Excption: "+e.toString());
				}
				if(rows!=null && rows.size()>0)
				{
			%>
					<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
					<td width="6%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>SRM Reference No.</center></span></td>
					<td width="11%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Card Number</center></span></td>
					<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
					<!--<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Gen Stat</center></span></td>-->
					<!--<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Assessed Income</center></span></td>-->
					<td width="7%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Source Code</center></span></td>
					<td width="7%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Other Bank Name</center></span></td>
					<td width="7%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Other (Pls. Specify)</center></span></td>
					<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Other Bank Card Number</center></span></td>
					<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Name on Other Card</center></span></td>
					<td width="7%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Deliver To</center></span></td>
					<td width="4%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Branch Name</center></span></td>
					<td width="7%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>BT Amount (AED)</center></span></td>
					<td width="4%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Approval Code</center></span></td>

					</tr>
			<%
					for(int j=0;j<rows.size();j++)
					{
						columnData = rows.get(j).toString();

						String CardNumber = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CustomerName  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String SourceCode = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String OthBankName = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String OthBankPlzSpecify = columnData.substring(0,columnData.indexOf("!"));
						if (OthBankPlzSpecify.equals("null"))
						{
							OthBankPlzSpecify = "NA";
						}
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String OthBankCardNo = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String NameOnOthCard = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String DeliverTo = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String BranchName = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String BTAmnt1 = columnData.substring(0,columnData.indexOf("!"));
						if (BTAmnt1.equals("null"))
						{
							BTAmnt1 = "NA";
						}					
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String AppCode1 = columnData.substring(0,columnData.indexOf("!"));
						if (AppCode1.equals("null"))
						{
							AppCode1 = "NA";
						}					
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String SRMReferenceNo= columnData.substring(0);
			%>
					<tr colspan=14>
						<td width="6%" class="EWTableContentsText" align='left'><%=SRMReferenceNo==null?"":SRMReferenceNo%></td>
						<td width="11%" class="EWTableContentsText" align='left'><%=CardNumber==null?"":CardNumber%></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=CustomerName==null?"":CustomerName%></td>
						<td width="7%" class="EWTableContentsText" align='left'><%=SourceCode==null?"":SourceCode%></td>
						<td width="7%" class="EWTableContentsText" align='left'><%=OthBankName==null?"":OthBankName%></td>
						<td width="7%" class="EWTableContentsText" align='left'><%=OthBankPlzSpecify==null?"":OthBankPlzSpecify%></td>
						<td width="16%" class="EWTableContentsText" align='left'><%=OthBankCardNo==null?"":OthBankCardNo%></td>
						<td width="8%" class="EWTableContentsText" align='left'><%=NameOnOthCard==null?"":NameOnOthCard%></td>
						<td width="7%" class="EWTableContentsText" align='left'><%=DeliverTo==null?"":DeliverTo%></td>
						<td width="4%" class="EWTableContentsText" align='left'><%=BranchName==null?"":BranchName%></td>
						<td width="7%" class="EWTableContentsText" align='left'><%=BTAmnt1==null?"":BTAmnt1%></td>
						<td width="4%" class="EWTableContentsText" align='left'><%=AppCode1==null?"":AppCode1%></td>
					</tr>
						

			<%
					}
				}
			}
			else if (reqType.equals("Credit Card Cheque"))
			{
				try
				{
					sInputXML1="<?xml version=\"1.0\"?>" + 				
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>"+procNameCCC+"</ProcName>" +						
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>9</NoOfCols>" +
								"<SessionID>"+sSessionId+"</SessionID>" +
								"<EngineName>"+sCabname+"</EngineName>" +
								"</APProcedure2_Input>";
					WriteLog("Consolidated Report BT: "+sInputXML1);
					sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
					WriteLog("Consolidated Report: "+sOutputXML1);
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
					//out.println("In Excption: "+e.toString());
				}
				if(rows!=null && rows.size()>0)
				{
			%>
					<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="6%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>SRM Reference No</center></span></td>
						<td width="16%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Card Number</center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
						<!--<td width="7%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>General Status</center></span></td>-->
						<!--<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Assessed Income</center></span></td>-->
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Source Code</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Beneficiary Name</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Deliver To</center></span></td>
						<td width="7%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Branch Name</center></span></td>
						<td width="9%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Cheque Amount</center></span></td>
						<td width="6%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Approval Code</center></span></td>
					</tr>
			<%
					for(int j=0;j<rows.size();j++)
					{
						columnData = rows.get(j).toString();

						String CardNo = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CustName  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
							String SourceCode = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String BeneficiaryName = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String DeliverTo = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String BranchName = columnData.substring(0,columnData.indexOf("!"));
						if (BranchName.equals("null")||BranchName.equals(""))
						{
							BranchName = "NA";
						}
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String ChequeAmnt1 = columnData.substring(0,columnData.indexOf("!"));
						if (ChequeAmnt1.equals("null"))
						{
							ChequeAmnt1 = "NA";
						}	
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String AppCode1 = columnData.substring(0,columnData.indexOf("!"));
						if (AppCode1.equals("null"))
						{
							AppCode1 = "NA";
						}					
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String SRMReferenceNo= columnData.substring(0);
			%>
					<tr colspan=17>
						<td width="6%" class="EWTableContentsText" align='left'><center><%=SRMReferenceNo==null?"":SRMReferenceNo%></center></td>
						<td width="16%" class="EWTableContentsText" align='left'><center><%=CardNo==null?"":CardNo%></center></td>
						<td width="16%" class="EWTableContentsText" align='left'><center><%=CustName==null?"":CustName%></center></td>
						<td width="8%" class="EWTableContentsText" align='left'><center><%=SourceCode==null?"":SourceCode%></center></td>
						<td width="9%" class="EWTableContentsText" align='left'><center><%=BeneficiaryName==null?"":BeneficiaryName%></center></td>
						<td width="8%" class="EWTableContentsText" align='left'><center><%=DeliverTo==null?"":DeliverTo%></center></td>
						<td width="7%" class="EWTableContentsText" align='left'><center><%=BranchName==null?"":BranchName%></center></td>
						<td width="9%" class="EWTableContentsText" align='left'><%=ChequeAmnt1==null?"":ChequeAmnt1%></td>
						<td width="6%" class="EWTableContentsText" align='left'><%=AppCode1==null?"":AppCode1%></td>
					</tr>

			<%
					}
				}
			}
			else if (reqType.equals("Cash Back Request"))
			{
				try
				{
					sInputXML1="<?xml version=\"1.0\"?>" + 				
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>"+procNameCBR+"</ProcName>" +						
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>6</NoOfCols>" +
								"<SessionID>"+sSessionId+"</SessionID>" +
								"<EngineName>"+sCabname+"</EngineName>" +
								"</APProcedure2_Input>";
					WriteLog("Consolidated Report CBR: "+sInputXML1);
					sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
					WriteLog("Consolidated Report: "+sOutputXML1);
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
					//out.println("In Excption: "+e.toString());
				}
				if(rows!=null && rows.size()>0)
				{
			%>
					<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>SRM Refence No </center></span></td>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Debit Card Number</center></span></td>
						<td width="30%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>General Status</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Type</center></span></td>
						<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Amount</center></span></td>
					</tr>
			<%
					for(int j=0;j<rows.size();j++)
					{
						columnData = rows.get(j).toString();

						String CardNumber = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CustomerName  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String GeneralStatus = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String Type = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String Amount = columnData.substring(0,columnData.indexOf("!"));
						if (Amount.equals("null"))
						{
							Amount = "NA";
						}
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String SRMReferenceNo = columnData.substring(0);
			%>
					<tr colspan=5>
						<td width="20%" class="EWTableContentsText" align='left'><center><%=SRMReferenceNo==null?"":SRMReferenceNo%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=CardNumber==null?"":CardNumber%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=CustomerName==null?"":CustomerName%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=GeneralStatus==null?"":GeneralStatus%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=Type==null?"":Type%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=Amount==null?"":Amount%></center></td>
					</tr>

			<%
					}
				}
			}
			else if (reqType.equals("Re-Issue of Pin"))
			{
				try
				{
					sInputXML1="<?xml version=\"1.0\"?>" + 				
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>"+procNameRIP+"</ProcName>" +						
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>5</NoOfCols>" +
								"<SessionID>"+sSessionId+"</SessionID>" +
								"<EngineName>"+sCabname+"</EngineName>" +
								"</APProcedure2_Input>";
					WriteLog("Consolidated Report CBR: "+sInputXML1);
					sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
					WriteLog("Consolidated Report: "+sOutputXML1);
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
					//out.println("In Excption: "+e.toString());
				}
				if(rows!=null && rows.size()>0)
				{
			%>
					<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>SRM Reference No</center></span></td>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Card Number</center></span></td>
						<td width="30%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Reason</center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Delivery Channel</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Branch Name</center></span></td>
					</tr>
			<%
					for(int j=0;j<rows.size();j++)
					{
						columnData = rows.get(j).toString();

						String CardNo = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String Reason  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String DeliveryChannel = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String BranchName = columnData.substring(0,columnData.indexOf("!"));
						if (BranchName.equals("null"))
						{
							BranchName="NA";
						}
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String SRMReferenceNo = columnData.substring(0);
			%>
					<tr colspan=5>
						<td width="20%" class="EWTableContentsText" align='left'><center><%=SRMReferenceNo==null?"":SRMReferenceNo%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=CardNo==null?"":CardNo%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=Reason==null?"":Reason%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=DeliveryChannel==null?"":DeliveryChannel%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=BranchName==null?"":BranchName%></center></td>
					</tr>

			<%
					}
				}
			}
			else if (reqType.equals("Credit Shield"))
			{
				try
				{
					sInputXML1="<?xml version=\"1.0\"?>" + 				
								"<APProcedure2_Input>" +
								"<Option>APProcedure2</Option>" +
								"<ProcName>"+procNameCS+"</ProcName>" +						
								"<Params>"+param+"</Params>" +  
								"<NoOfCols>5</NoOfCols>" +
								"<SessionID>"+sSessionId+"</SessionID>" +
								"<EngineName>"+sCabname+"</EngineName>" +
								"</APProcedure2_Input>";
					WriteLog("Consolidated Report CBR: "+sInputXML1);
					sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
					WriteLog("Consolidated Report: "+sOutputXML1);
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
					//out.println("In Excption: "+e.toString());
				}
				if(rows!=null && rows.size()>0)
				{
			%>
					<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>SRM Reference No</center></span></td>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Card Number</center></span></td>
						<td width="30%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Credit Shield (Un-enrolment/Reversal)</center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Credit Shield Reversal (Flag)</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Reversal Amount</center></span></td>
					</tr>
			<%
					for(int j=0;j<rows.size();j++)
					{
						columnData = rows.get(j).toString();

						String CardNo = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CreditShield  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String CreditShieldFlag = columnData.substring(0,columnData.indexOf("!"));
						if (CreditShieldFlag.equals("Y"))
						{
							CreditShieldFlag="Checked";
						}
						else
						{
							CreditShieldFlag="Un-Checked";						
						}
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String ReversalAmount = columnData.substring(0,columnData.indexOf("!"));
						if (ReversalAmount.equals("null"))
						{
							ReversalAmount="NA";
						}
						columnData = columnData.substring(columnData.indexOf("!")+1);
						String SRMReferenceNo = columnData.substring(0);
			%>
					<tr colspan=5>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=SRMReferenceNo==null?"":SRMReferenceNo%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=CardNo==null?"":CardNo%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=CreditShield==null?"":CreditShield%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=CreditShieldFlag==null?"":CreditShieldFlag%></center></td>
						<td width="10%" class="EWTableContentsText" align='left'><center><%=ReversalAmount==null?"":ReversalAmount%></center></td>
					</tr>

			<%
					}
				}
			}
			if(rows==null || rows.size()<=0)
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