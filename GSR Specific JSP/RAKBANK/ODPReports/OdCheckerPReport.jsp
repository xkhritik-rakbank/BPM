<%
/*------------------------------------------------------------------------------------------------------

                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                                           : Application -Projects

Project/Product                                 : RAKBANK-PRD-13-14

Application                                     : Omnidocs Productivity Report

Module                                          : Report

File Name                                       : ODUserPReport.jsp

Author                                          : Ravi Chaturvedi

Date (DD/MM/YYYY)                         		: 14/08/2013

Description                                     : User Productivity  Report
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
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
<%@ page import="java.text.*"%>
<%@ page import= "java.util.Properties" %>

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
	String procName="SRM_OD_CHECKER_PRODUCTIVITY_REPORT";
	ArrayList rows = null;
	String columnData = "";

	try
	{
		String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
		param = "'"+tempfromdate+"','"+temptodate+"'";

	} 
	catch(Exception ex)
	{
	}
%>

<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
		<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
		<title>User Productivity Report</title>
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
				document.FTOReport.action = "OdCheckerPReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to;
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
				if (Number(dayslimit) > 31)
				{
					alert("Time duration can not be greater than 1 Month / 31 Days"); 
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
				document.FTOReport.action = "OdCheckerReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&type=print";
				document.FTOReport.submit;
			}
			function save_Report()
			{
				
				var dat_from = document.FTOReport.dte_from.value;
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
				document.FTOReport.action = "OdCheckerReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
				+final_dt_to+"&type=save";
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
					<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User Wise Productivity Report-Checker</center></td>
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
			
			WriteLog("Input Xml");
			sInputXML1="<?xml version=\"1.0\"?>" + 				
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>"+procName+"</ProcName>" +						
					"<Params>"+param+"</Params>" +  
					"<NoOfCols>4</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabname+"</EngineName>" +
					"</APProcedure2_Input>";
			WriteLog(sInputXML1);
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
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
					<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>User Name</center></span></td>
					<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>User Role</center></span></td>
					<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>No Of Documents</center></span></td>
					<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>No Of Pages</center></span></td>
				</tr>
<%
			WriteLog("Parsing Data...");
			String gp_name="";
			String userID="";
			String No_doc="";
			String No_pages="";
			for(int j=0;j<rows.size();j++)
			{
					columnData = rows.get(j).toString();
					gp_name = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					userID  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					No_doc= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);				
					No_pages = columnData.substring(0);
%>
				<tr colspan=11>
					<td width="10%" class="EWTableContentsNum" ><center><%=userID==null?"":userID%> </center></td>
					<td width="10%" class="EWTableContentsText" align='left'><%=gp_name==null?"":gp_name%></td>
					<td width="5%" class="EWTableContentsText" ><center><%=No_doc==null?"":No_doc%></td></center>
					<td width="5%" class="EWTableContentsNum" ><center><%=No_pages==null?"":No_pages%></td></center>
				</tr>
<%
			}
			WriteLog("Done Parsing Data...");
		}

		if(rows==null || rows.size()<=0)
		{
%>			<br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Record Found</font></B></center></td>
				</tr></table>
			</table>
			<br>
<%		}
	}
%>

<table align='center' cellspacing="1" cellpadding='1' width="90%">
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>
<tr><td><input  type="HIDDEN"  name="SYS_DATE" id="SYS_DATE" value="<%=CurrDate%>"> </td></tr>
</form>
</body>
</html>

