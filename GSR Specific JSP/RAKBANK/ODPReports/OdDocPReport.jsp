<%
/*------------------------------------------------------------------------------------------------------

                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                                           : Application -Projects

Project/Product                                 : RAKBANK-PRD-13-14

Application                                     : Omnidocs Productivity Report

Module                                          : Report

File Name                                       : ODDocReport.jsp

Author                                          : Ravi Chaturvedi

Date (DD/MM/YYYY)                         		: 14/08/2013

Description                                     : Omnidocs Productivity Detailed Report
-------------------------------------------------------------------------------------------------------

CHANGE HISTORY

-------------------------------------------------------------------------------------------------------

Problem No/CR No   Change Date   Changed By    Change Description

------------------------------------------------------------------------------------------------------*/
%>

<%@ include file="../../CSRProcessSpecific/Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.sql.*"%>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>

<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

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
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
%>
<%
	String sInputXML1="";
	String sOutputXML1="";
	String sCabname="";
	String sSessionId="";
	String sJtsIp="";
	String Flag="";
	String recordCheck="0";
	String printBatchIndex="0";
	//String BatchDate="0";
	int iJtsPort= 0;
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
	if (bError)
	{
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); 
		out.println("</script>");
	}
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("B_Date", request.getParameter("B_Date"), 1000, true) );
	String B_Date = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: B_Date: "+B_Date);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("B_Index", request.getParameter("B_Index"), 1000, true) );
	String B_Index = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: B_Index: "+B_Index);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("INTB_Index", request.getParameter("INTB_Index"), 1000, true) );
	String INTB_Index = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("Integration jsp: INTB_Index: "+INTB_Index);
	
	String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("IB_Date", request.getParameter("IB_Date"), 1000, true) );
	String IB_Date = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
	WriteLog("Integration jsp: IB_Date: "+IB_Date);
	
	String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("record_Check", request.getParameter("record_Check"), 1000, true) );
	String record_Check = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
	WriteLog("Integration jsp: record_Check: "+record_Check);
	
	String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("p_flag", request.getParameter("p_flag"), 1000, true) );
	String p_flag = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
	WriteLog("Integration jsp: p_flag: "+p_flag);
	
    String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("B_Index", request.getParameter("B_Index"), 1000, true) );
	String oldBatchIndex_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
	WriteLog("Integration jsp: oldBatchIndex_1: "+oldBatchIndex_1);
	
	String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("B_Date", request.getParameter(B_Date), 1000, true) );
	String B_Date_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
	WriteLog("Integration jsp: B_Date_1: "+B_Date_1);
	
	String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("batchdates", request.getParameter("batchdates"), 1000, true) );
	String batchdates_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
	WriteLog("Integration jsp: batchdates_1: "+batchdates_1);
	
	String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("printBatchIndex", request.getParameter("printBatchIndex"), 1000, true) );
	String printBatchIndex_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
	WriteLog("Integration jsp: printBatchIndex_1: "+printBatchIndex_1);
	
	String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
	//WriteLog("Integration jsp: fnl_date_to cmpl: "+fnl_date_to);
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Dateto);
	
	String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
	//WriteLog("Integration jsp: fnl_date_from cmpl: "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Datefrom);
	
		
		if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	
	
	DateFormat dtFormat = new SimpleDateFormat( "dd-MM-yyyy"+ " hh:mm:ss");
	String currentdate = dtFormat.format(new java.util.Date());
	
	
	String final_date_to = fnl_Dateto;
	String final_date_from = fnl_Datefrom;
	String BatchDate = B_Date;
	String BatchIndex=B_Index;
	String INT_BatchIndex=INTB_Index;
	String oldBatchIndex= oldBatchIndex_1;
	String oldBatchDate = B_Date_1;
	String batchdates= batchdates_1;
	printBatchIndex= printBatchIndex_1;
	String iniBDate=IB_Date;
	 recordCheck=record_Check;
	

	String param="";
	String procName="SRM_OD_DOC_PRODUCTIVITY_REPORT";
	ArrayList rows = null;
	String columnData = "";

	try
	{
		String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
		String sBatchDate="";
		String sBatchIndex="";
		Flag = p_flag;
		if(Flag.equalsIgnoreCase("NEXT"))
		{
			sBatchDate=BatchDate;
			sBatchIndex=BatchIndex;
		}
		else
		{
			sBatchDate=iniBDate;
			sBatchIndex=INT_BatchIndex;
		}
		
		param = "'"+tempfromdate+"','"+temptodate+"','"+sBatchDate+"','"+sBatchIndex+"','"+Flag+"'";

	} 
	catch(Exception ex)
	{
	}
%>

<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
		<title>Document Productivity Report</title>
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
			
				var dat_from;
				var dat_to;
				var final_dt_from;
				var final_dt_to;
				var batchdate;
				var recordCheck;
				var batchindex;
			
				dat_from = document.FTOReport.dte_from.value;
				dat_to = document.FTOReport.dte_to.value;
				final_dt_from = dat_from;
				final_dt_to =dat_to;
				batchdate= document.getElementById("B_DATE").value;
				batchindex= document.getElementById("B_Index").value;
				recordCheck=0;			
				//alert("test 1: "+batchdate);
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
				if(!Datediff(dat_from,'From Date'))
				{
					return false;
				}
				if(!Datediff(dat_to,'To Date'))
				{
					return false;
				}
				if(!Datediff123())
				{
					document.getElementById("Date_dte_from").value="";
					document.getElementById("Date_dte_to").value="";
					return false;
				}
				// if(button.id=="generate_report")
				// {
					// BatchDate="0";
				// }
				// else if(button.id=="Next")
				// {
					// BatchDate="0";
				// }
				//alert(batchdate);
				/*if(batchdate==null||batchdate=="null"||batchdate=="")
                {
				   batchdate="0";
				}*/
				batchdate="0";
				batchindex="0";
				document.getElementById("batchdates").value=batchdate;
				document.getElementById("printBatchIndex").value=batchindex;
				document.FTOReport.action = "OdDocPReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&B_Date="+batchdate+"&record_Check="+recordCheck+"&B_Index="+batchindex+"&p_flag=NEXT";
				document.FTOReport.submit;
			}
			function generate_Report_Next()
			{
				
				var dat_from;
				var dat_to;
				var final_dt_from;
				var final_dt_to;
				var batchdate;
				var recordCheck;
				var batchindex;
				dat_from = document.FTOReport.dte_from.value;
				dat_to = document.FTOReport.dte_to.value;
				final_dt_from = dat_from;
				final_dt_to =dat_to;
				batchdate= document.getElementById("B_DATE").value;
				batchindex= document.getElementById("B_Index").value;
				recordCheck= document.getElementById("record_Check").value;
				recordCheck=parseInt(recordCheck)+1;	
				//alert("test 1: "+batchdate);
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
				if(!Datediff(dat_from,'From Date'))
				{
					return false;
				}
				if(!Datediff(dat_to,'To Date'))
				{
					return false;
				}
				if(!Datediff123())
				{
					document.getElementById("Date_dte_from").value="";
					document.getElementById("Date_dte_to").value="";
					return false;
				}
				// if(button.id=="generate_report")
				// {
					// BatchDate="0";
				// }
				// else if(button.id=="Next")
				// {
					// BatchDate="0";
				// }
				//alert(batchdate);
				if(batchdate==null||batchdate=="null"||batchdate=="")
                {
				   batchdate="0";
				}
				document.getElementById("batchdates").value=batchdate;
				document.getElementById("printBatchIndex").value=batchindex;
				document.FTOReport.action = "OdDocPReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&B_Date="+batchdate+"&record_Check="+recordCheck+"&B_Index="+batchindex+"&p_flag=NEXT";
				document.FTOReport.submit;
			}
			function generate_Report_Prev()
			{
				
				var dat_from;
				var dat_to;
				var final_dt_from;
				var final_dt_to;
				var batchdate;
				var recordCheck;
				var batchindex;
				dat_from = document.FTOReport.dte_from.value;
				dat_to = document.FTOReport.dte_to.value;
				final_dt_from = dat_from;
				final_dt_to =dat_to;
				//batchdate= document.getElementById("batchdates").value;
				//batchdate= document.getElementById("B_DATE").value;
				batchdate= document.getElementById("IB_Date").value;
				batchindex= document.getElementById("INTB_Index").value;
				recordCheck= document.getElementById("record_Check").value;
				recordCheck=parseInt(recordCheck)-1;
				//alert("test 1: "+batchdate);
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
				if(!Datediff(dat_from,'From Date'))
				{
					return false;
				}
				if(!Datediff(dat_to,'To Date'))
				{
					return false;
				}
				if(!Datediff123())
				{
					document.getElementById("Date_dte_from").value="";
					document.getElementById("Date_dte_to").value="";
					return false;
				}
				
				if(batchdate==null||batchdate=="null"||batchdate=="")
                {
				   batchdate="0";
				}
				//alert(batchdate);
				document.getElementById("batchdates").value=batchdate;
				document.getElementById("printBatchIndex").value=batchindex;
				document.FTOReport.action = "OdDocPReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&B_Date="+batchdate+"&record_Check="+recordCheck+"&B_Index="+batchindex+"&p_flag=Prev";
		
				document.FTOReport.submit;
			}
			
			function Datediff(DateField,DateFieldValue)
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
					alert(DateFieldValue+" cannot be greater than Current Date"); 
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
					alert("From Date cannot be greater than To Date"); 
					return false;
				}
				var dayslimit = ((CurDate2.getTime()-depDate2.getTime())/(1000*60*60*24));	
				if (Number(dayslimit) > 7)
				{
					alert("Time duration can not be greater than 7 Days"); 
					return false;
				}
				return true;
			}
			function print_Report()
			{
				
				var dat_from = document.FTOReport.dte_from.value;
				var dat_to = document.FTOReport.dte_to.value;
				var final_dt_from = dat_from;
				var final_dt_to =dat_to;
				var flag= document.getElementById("Flag").value;
				var batchindex;
				//alert("as "+document.getElementById("batchdates"));
				var batchdate= document.getElementById("batchdates").value;
							
				batchindex=document.getElementById("printBatchIndex").value;
				
				//alert(batchindex);
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
				if(!Datediff(dat_from,'From Date'))
				{
					return false;
				}
				if(!Datediff(dat_to,'To Date'))
				{
					return false;
				}
				if(!Datediff123())
				{
					document.getElementById("Date_dte_from").value="";
					document.getElementById("Date_dte_to").value="";
					return false;
				}
				//alert("print batchdate=="+batchdate);
				
				document.FTOReport.action = "OdDocPReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&B_Date="+batchdate+"&B_Index="+batchindex+"&p_flag="+flag+"&type=print";
				document.FTOReport.submit;
				
			}
			function save_Report()
			{
				
				var dat_from = document.FTOReport.dte_from.value;
				var dat_to = document.FTOReport.dte_to.value;
				var final_dt_from = dat_from;
				var final_dt_to =dat_to;
				var batchdate= document.getElementById("batchdates").value;
				var flag= document.getElementById("Flag").value;
				var batchindex;
				batchindex=document.getElementById("printBatchIndex").value;
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
				if(!Datediff(dat_from,'From Date'))
				{
					return false;
				}
				if(!Datediff(dat_to,'To Date'))
				{
					return false;
				}
				if(!Datediff123())
				{
					document.getElementById("Date_dte_from").value="";
					document.getElementById("Date_dte_to").value="";
					return false;
				}
				//alert("save batchdate=="+batchdate);
				document.FTOReport.action = "OdDocPReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&B_Date="+batchdate+"&B_Index="+batchindex+"&p_flag="+flag+"&type=save";
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
					<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Productivity Detailed Report</center></td>
				</tr>
			</table>
			<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
				<tr>
					<td align='left'><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date :      </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
					&nbsp;&nbsp;&nbsp;
					</td>
					<td  align='left'><font class='EWLabel3' ><b>To Date : </b>&nbsp;&nbsp;
					<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
					</td>
				</tr>
				<tr>
					<td align='center' colspan="2"> <center>&nbsp;&nbsp;&nbsp;
					<input type="submit" name="generate_report" name="generate_report" value="Generate Report" onClick="return generate_Report()">
					&nbsp;&nbsp;&nbsp;
					<input type="submit" name="save" value="Save"  onClick="return save_Report()"> &nbsp;&nbsp;&nbsp;
					<input type="submit" name="print" value="Print" onClick="return print_Report()"></center>
					</td>
				</tr>
			</table>
			<br>
<%
	if(final_date_from==null || final_date_from.equals(""))
	{
	}
	else
	{
		try
		{
		//out.println("<script>");
		//out.println("alert('111sSessionId "+sSessionId+"');");
		//out.println("</script>");
		
		//out.print("paRAM "+param);
		
			sInputXML1="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>"+procName+"</ProcName>" +						
					"<Params>"+param+"</Params>" +  
					"<NoOfCols>12</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";
			//WriteLog(sInputXML1);
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			//out.println("<script>");
			//out.println("alert('sOutputXML1--- "+sOutputXML1+"');");
			//out.println("</script>");
			WriteLog(sOutputXML1);
			
			if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)
			{
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
			out.println("In Exception: "+e.toString());
		}
		int iRecd=0;
		if(rows!=null && rows.size()>0)
		{
%>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr>
					<td width="1%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>S.No</center></span></td>
					<td width="19%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Created DateTime</center></span></td>
					<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Created By User</center></span></td>
					<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Document Type</center></span></td>
					<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Document Name</center></span></td>
					<td width="1%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>No Of Pages</center></span></td>
					<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CIFID</center></span></td>
					<td width="19%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Modified DateTime</center></span></td>
					<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Modified By User</center></span></td>
					<td width="19%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Approved DateTime</center></span></td>
					<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Approved By User</center></span></td>
					<td width="3%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Document Status</center></span></td>
				</tr>
<%
			//WriteLog("Parsing Data...");
			String rowcount="";
			String create_date ="";
			String userID  ="";
			String No_doc="";										
			String No_pages ="";													
			String cifid ="";						
			String mod_date ="";									
			String mod_user="";									
			String app_date ="";						
			String app_user ="";						
			String doc_ststus ="";
			String doc_name="";
			
			if(!Flag.equalsIgnoreCase("PREV"))
			{
				for(int j=0;j<rows.size();j++)
				{
						rowcount=Integer.toString(j+1);
						columnData = rows.get(j).toString();
						create_date = columnData.substring(0,columnData.indexOf("!"));
						BatchDate=create_date;
						columnData = columnData.substring(columnData.indexOf("!")+1);
						userID  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						No_doc= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						doc_name= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						No_pages = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);								
						cifid = columnData.substring(0,columnData.indexOf("!"));
						if(cifid.equalsIgnoreCase("null")||cifid.equals(""))
							cifid="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						mod_date = columnData.substring(0,columnData.indexOf("!"));
						if(mod_date.equalsIgnoreCase("null")||mod_date.equals(""))
							mod_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						mod_user=columnData.substring(0,columnData.indexOf("!"));
						if(mod_user.equalsIgnoreCase("null")||mod_user.equals(""))
							mod_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						app_date = columnData.substring(0,columnData.indexOf("!"));
						if(app_date.equalsIgnoreCase("null")||app_date.equals(""))
							app_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						app_user = columnData.substring(0,columnData.indexOf("!"));
						if(app_user.equalsIgnoreCase("null")||app_user.equals(""))
							app_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);	
						doc_ststus = columnData.substring(0,columnData.indexOf("!"));
						
						columnData = columnData.substring(columnData.indexOf("!")+1);	
						BatchIndex = columnData.substring(0);
						
						if(j==0)
						INT_BatchIndex=BatchIndex;
						
	%>
					<tr colspan=11>
					<td width="1%" class="EWTableContentsText" align='left'><%=rowcount==null?"":rowcount%></td>
						<td width="20%" class="EWTableContentsText" align='left'><%=create_date==null?"":create_date%></td>
						<td width="10%" class="EWTableContentsNum" ><center><%=userID==null?"":userID%> </center></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=No_doc==null?"":No_doc%></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=doc_name==null?"":doc_name%></td>
						<td width="1%" class="EWTableContentsNum" ><%=No_pages==null?"":No_pages%></td>
						<td width="5%" class="EWTableContentsNum" ><%=cifid==null?"":cifid%></td>
						<td width="20%" class="EWTableContentsNum" ><%=mod_date==null?"":mod_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=mod_user==null?"":mod_user%></td>
						<td width="20%" class="EWTableContentsNum" ><%=app_date==null?"":app_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=app_user==null?"":app_user%></td>
						<td width="3%" class="EWTableContentsNum" ><%=doc_ststus==null?"":doc_ststus%></td>
					</tr>
	<%
				}
				columnData = rows.get(0).toString();
				iniBDate = columnData.substring(0,columnData.indexOf("!"));
			}
			else
			{
				for(int j=rows.size()-1;j>=0;j--)
				{
						rowcount=Integer.toString(rows.size()-j);
						columnData = rows.get(j).toString();
						create_date = columnData.substring(0,columnData.indexOf("!"));
						BatchDate=create_date;
						columnData = columnData.substring(columnData.indexOf("!")+1);
						userID  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						No_doc= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						doc_name= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						No_pages = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);								
						cifid = columnData.substring(0,columnData.indexOf("!"));
						if(cifid.equalsIgnoreCase("null")||cifid.equals(""))
							cifid="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						mod_date = columnData.substring(0,columnData.indexOf("!"));
						if(mod_date.equalsIgnoreCase("null")||mod_date.equals(""))
							mod_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						mod_user=columnData.substring(0,columnData.indexOf("!"));
						if(mod_user.equalsIgnoreCase("null")||mod_user.equals(""))
							mod_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						app_date = columnData.substring(0,columnData.indexOf("!"));
						if(app_date.equalsIgnoreCase("null")||app_date.equals(""))
							app_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						app_user = columnData.substring(0,columnData.indexOf("!"));
						if(app_user.equalsIgnoreCase("null")||app_user.equals(""))
							app_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);	
						doc_ststus = columnData.substring(0,columnData.indexOf("!"));
						
						columnData = columnData.substring(columnData.indexOf("!")+1);	
						BatchIndex = columnData.substring(0);
						if(j==rows.size()-1)
						INT_BatchIndex=BatchIndex;
						
	%>
					<tr colspan=11>
						<td width="1%" class="EWTableContentsText" align='left'><%=rowcount==null?"":rowcount%></td>
						<td width="20%" class="EWTableContentsText" align='left'><%=create_date==null?"":create_date%></td>
						<td width="10%" class="EWTableContentsNum" ><center><%=userID==null?"":userID%> </center></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=No_doc==null?"":No_doc%></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=doc_name==null?"":doc_name%></td>
						<td width="1%" class="EWTableContentsNum" ><%=No_pages==null?"":No_pages%></td>
						<td width="5%" class="EWTableContentsNum" ><%=cifid==null?"":cifid%></td>
						<td width="20%" class="EWTableContentsNum" ><%=mod_date==null?"":mod_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=mod_user==null?"":mod_user%></td>
						<td width="20%" class="EWTableContentsNum" ><%=app_date==null?"":app_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=app_user==null?"":app_user%></td>
						<td width="3%" class="EWTableContentsNum" ><%=doc_ststus==null?"":doc_ststus%></td>
					</tr>
	<%
				}
				columnData = rows.get(rows.size()-1).toString();
				iniBDate = columnData.substring(0,columnData.indexOf("!"));
						

			}
			//WriteLog("Done Parsing Data...");
		}

		if(rows==null || rows.size()<=0)
		{
%>			<br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Records Found!</font></B></center></td>
				</tr>
				</table>
			</table>
			<br>
<%		}
	}
%>

<table align='center' cellspacing="1" cellpadding='1' width="90%">
<tr align="right"><td>
<% if(!(rows==null || rows.size()<=0)) 
{
	if((!recordCheck.equals("0"))||(!(oldBatchDate.equals("0")||oldBatchDate.equalsIgnoreCase("null")||oldBatchDate.equalsIgnoreCase(null))))
	{
%>
		<input type="submit" id="Prev" name="Prev" value="Prev" onClick="return generate_Report_Prev()">
<%	
	}
%>
<input type="submit" id="Next" name="Next" value="Next" onClick="return generate_Report_Next()"></td></tr>
<%
}
%>
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>
<tr><td><input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="batchdates" id="batchdates" value="<%=oldBatchDate%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="flag" id="flag" value="<%=Flag%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="B_DATE" id="B_DATE" value="<%=BatchDate%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="IB_Date" id="IB_Date" value="<%=iniBDate%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="record_Check" id="record_Check" value="<%=recordCheck%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="INTB_Index" id="INTB_Index" value="<%=INT_BatchIndex%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="B_Index" id="B_Index" value="<%=BatchIndex%>"> </td></tr>
<tr><td><input  type="HIDDEN"  name="printBatchIndex" id="printBatchIndex" value="<%=oldBatchIndex%>"> </td></tr>



</form>
</body>
</html>

