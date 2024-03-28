<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       AgentReport.jsp
	Purpose         :       To Display No. of Service requests submitted individually by Agents Names
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/040	
--%>
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
	String sJtsIp="";
	int iJtsPort= 0;
	String query1="";
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("user_name", request.getParameter("user_name"), 1000, true) );
	String user_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: user_name: "+user_name);
	//WriteLog("Integration jsp: user_name 1: "+request.getParameter("user_name"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Date: Agent replace "+fnl_Dateto);
	WriteLog("Integration jsp: fnl_date_to: Agent "+fnl_date_to);
	//WriteLog("Integration jsp: fnl_date_to: Agent "+request.getParameter("fnl_date_to"));
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: fnl_date_from agent: hritik "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Date: Agent replace 1 hritik "+fnl_Datefrom);
	if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	
	//WriteLog("Integration jsp: fnl_Date: Agent replace 1 hritik 2345 "+request.getParameter("fnl_date_from"));
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: branchCode: "+branchCode);
	
	
	String userName=user_name;
	String sel_dte_to = "";
	String sel_dte_from = "";
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
	String final_date_to = fnl_Dateto;
	String final_date_from = fnl_Datefrom;
	String reqType = requestType;
	String brCode = branchCode;
	String param="";
	String tempReqType="";
	String GIparam="";
	String procName="GET_AGENT_LIST";
	String procName2="SRM_AGENT_REPORT";
	ArrayList users = null;
	ArrayList report = null;
	String columnData = "";
	String columndata2 = "";
	try
	{
		if(reqType!=null && !reqType.equalsIgnoreCase(""))
		{
			if(reqType.equalsIgnoreCase("Balance Transfer"))
			{
				tempReqType="CSR_BT";
			}
			else if(reqType.equalsIgnoreCase("Cash Back Request"))
			{
				tempReqType="CSR_CBR";
			}
			else if(reqType.equalsIgnoreCase("Credit Card Blocking Request"))
			{
				tempReqType="CSR_CCB";
			}
			else if(reqType.equalsIgnoreCase("Credit Card Cheque"))
			{
				tempReqType="CSR_CCC";
			}
			else if(reqType.equalsIgnoreCase("Miscellaneous Requests"))
			{
				tempReqType="CSR_MR";
			}
			else if(reqType.equalsIgnoreCase("Reversals Request"))
			{
				tempReqType="CSR_RR";
			}
			else if(reqType.equalsIgnoreCase("Other Credit Card Request"))
			{
				tempReqType="CSR_OCC";
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
		query1="select GroupIndex from pdbgroup with(nolock) where GroupName =:GroupName";
		String params ="GroupName==CardAgents";
		sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("GroupIndex: "+sInputXML1);
		sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
		WriteLog("GroupIndex: "+sOutputXML1);
		String GroupIndex = sOutputXML1.substring(sOutputXML1.indexOf("<GroupIndex>")+12,sOutputXML1.indexOf("</GroupIndex>"));
		GIparam="'"+GroupIndex+"'";
		query1="";
		sInputXML1="";
		sOutputXML1="";
		sInputXML="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName+"</ProcName>" +						
				"<Params>"+GIparam+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";
		WriteLog("Report GET_AGENT_LIST: "+sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("Report GET_AGENT_LIST: "+sOutputXML);
		if(!sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))==0)
		{
			String result = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			users = new ArrayList();
			StringTokenizer rowStr = new StringTokenizer(result, "~");
			while(rowStr.hasMoreTokens())
			{
				users.add(rowStr.nextToken());
			}
		}
		if (userName!=null)
		{
			String tempfromdate = final_date_from.substring(6,10)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
			String temptodate = final_date_to.substring(6,10)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
			param = "'"+userName+"','"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"'";
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
		<title>Agent Wise Report</title>
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
			var userName = document.FTOReport.user_name.value;
			var req_type = document.FTOReport.requestType.value;
			var br_id = document.FTOReport.branchCode.value;
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
			document.FTOReport.action = "AgentReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
			+final_dt_to+"&UserName="+userName+"&reqType="+req_type+"&brCode="+br_id;
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
			var userName = document.FTOReport.user_name.value;
			var final_dt_from = dat_from;
			var final_dt_to =dat_to;
			var req_type = document.FTOReport.requestType.value;
			var br_id = document.FTOReport.branchCode.value;
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
			document.FTOReport.action = "AgentReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print&userName="+userName+"&reqType="+req_type+"&brCode="+br_id;
			document.FTOReport.submit;
		}
		function save_Report()
		{
			var dat_from = document.FTOReport.dte_from.value;
			var dat_to = document.FTOReport.dte_to.value;
			var userName = document.FTOReport.user_name.value;
			var final_dt_from = dat_from;
			var final_dt_to =dat_to;
			var req_type = document.FTOReport.requestType.value;
			var br_id = document.FTOReport.branchCode.value;
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
			document.FTOReport.action = "AgentReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save&userName="+userName+"&reqType="+req_type+"&brCode="+br_id;
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
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AGENT WISE REPORT</center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
			<tr>
				<td><font class='EWLabel3' ><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;From Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="dte_from" id='Date_dte_from' align = "left" maxlength="10" value = '<%=final_date_from==null?"":final_date_from%>' readonly><a href='1' onclick = "initialise('Date_dte_from');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>&nbsp;&nbsp;&nbsp;
				</td>
				<td  align='left'><font class='EWLabel3' ><b>To Date : </b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="dte_to" id='Date_dte_to' align = "left" maxlength="10" value = '<%=final_date_to==null?"":final_date_to%>' readonly><a href='1' onclick = "initialise('Date_dte_to');return false;" target='_parent' ><img src='/webdesktop/webtop/images/images/cal.gif' width='16' height='16' border='0' alt='Click here to pick up the date' ></a>
				</td>
			</tr>
			<TR>
				<td><font class='EWLabel3' >&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>&nbsp;&nbsp;&nbsp;&nbsp;Request Type:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b>
					<select name="requestType" >
						<% if(reqType!=null){%>
						<option <%if(reqType.equals("Balance Transfer")){%> value='Balance Transfer' selected <%}else{%> value='Balance Transfer' <%}%> >Balance Transfer</option>

						<option  <%if(reqType.equals("Cash Back Request")){%> value='Cash Back Request' selected <%}else{%> value='Cash Back Request' <%}%>  >Cash Back Request</option>

						<option  <%if(reqType.equals("Credit Card Blocking Request")){%> value='Credit Card Blocking Request' selected <%}else{%> value='Credit Card Blocking Request' <%}%>  >Credit Card Blocking Request</option>

						<option  <%if(reqType.equals("Credit Card Cheque")){%> value='Credit Card Cheque' selected <%}else{%> value='Credit Card Cheque' <%}%>  >Credit Card Cheque</option>
						
						<option  <%if(reqType.equals("Miscellaneous Requests")){%> value='Miscellaneous Requests' selected <%}else{%> value='Miscellaneous Requests' <%}%>  >Miscellaneous Requests</option>

						<option  <%if(reqType.equals("Reversals Request")){%> value='Reversals Request' selected <%}else{%> value='Reversals Request' <%}%>  >Card Service Request-Reversals Request</option>

						<option  <%if(reqType.equals("Other Credit Card Request")){%> value='Other Credit Card Request' selected <%}else{%> value='Other Credit Card Request' <%}%>  >Other Credit Card Request</option> 

						<option <%if(reqType.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>  >All</option>
						<%} else { %>
							<option  value="Balance Transfer" >Balance Transfer</option>
							<option  value="Cash Back Request" >Cash Back Request</option>
							<option  value="Credit Card Blocking Request" >Credit Card Blocking Request</option>
							<option  value="Credit Card Cheque" >Credit Card Cheque</option>
							<option  value="Miscellaneous Requests" >Miscellaneous Requests</option>
							<option  value="Reversals Request" >Reversals Request</option>
							<option  value="Other Credit Card Request" >Other Credit Card Request</option>
							<option  value="All" >All</option>
						<%}%>
					</select>
				</td>
				<td>
				<font class='EWLabel3' ><b>Branch Id:&nbsp;</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="text box" name="branchCode" maxlength=4  value = '<%=brCode==null?"":brCode%>'>
				</td>
			<TR>
			<%
			if(userName!=null)
			{
				%>
				<td align='left' ><font class='EWLabel3'>&nbsp;&nbsp;&nbsp;<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Select UserName:&nbsp;</b>
				<select name="user_name" >
				<%
				for(int j=0;j<users.size();j++)
				{
					columnData = users.get(j).toString();
					if (columnData.substring(0).equals(userName))
					{
						out.println("<option selected value='"+columnData.substring(0)+"'>"+columnData.substring(0)+"</option>");
					}
					else
					{
						out.println("<option value='"+columnData.substring(0)+"'>"+columnData.substring(0)+"</option>");	
					}
				}
				%>
					<option  <%if(userName.equals("All")){%> value='All' selected <%}else{%> value='All' <%}%>>All</option>
				<%
			
			}
			else
			{
				%>
				<td align='left' ><font class='EWLabel3'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Select UserName:&nbsp;</b>
				<select id="user_name" name="user_name" >

				<%
				for(int j=0;j<users.size();j++)
				{
					columnData = users.get(j).toString();
					out.println("<option value='"+columnData.substring(0)+"'>"+columnData.substring(0)+"</option>");
				}
				%>
					<option value='All'>All</option>
				<%
			}
				%>
					
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
		<%
		if(final_date_from==null || final_date_from=="")
		{
		}
		else
		{
			try
			{
				sInputXML2="<?xml version=\"1.0\"?>" + 				
							"<APProcedure2_Input>" +
							"<Option>APProcedure2</Option>" +
							"<ProcName>"+procName2+"</ProcName>" +						
							"<Params>"+param+"</Params>" +  
							"<NoOfCols>3</NoOfCols>" +
							"<SessionID>"+sSessionId+"</SessionID>" +
							"<EngineName>"+sCabname+"</EngineName>" +
							"</APProcedure2_Input>";
				WriteLog("Report Get Agent Data: "+sInputXML2);
				sOutputXML2= WFCallBroker.execute(sInputXML2,sJtsIp,iJtsPort,1);
				WriteLog("Report Get Agent Data: "+sOutputXML2);
				if(!sOutputXML2.equals("") || Integer.parseInt(sOutputXML2.substring(sOutputXML2.indexOf("<MainCode>")+10, sOutputXML2.indexOf("</MainCode>")))==0)
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
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="20%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Count </center></span></td>
					</tr>
				</table>
			<%
				String tempProcessName = "";
				String tempUser="";
				String tempUser1="";
				int requestCount = 0;
				String columnDataTemp="";
				String userNameTemp="";

				for(int j=0;j<report.size();j++)
				{

					String columnData2 = report.get(j).toString();
					String ProcessName = columnData2.substring(0,columnData2.indexOf("!"));
					columnData2 = columnData2.substring(columnData2.indexOf("!")+1);
					String Count = columnData2.substring(0,columnData2.indexOf("!"));
					columnData2 = columnData2.substring(columnData2.indexOf("!")+1);
					columnData2 = columnData2.substring(columnData2.indexOf("!")+1);
					String User = columnData2.substring(0);
					columnDataTemp=columnData2;
					if (!User.equals(tempUser))
					{
						%>
							<br>
							<table align='center' cellspacing="1" cellpadding='1' width="90%">
								<tr>
									<td height="25" class="EWSubHeaderText"><span class="EWLabel"><%=User%></td>
								</tr>
							</table>							
						<%		
						tempUser=User;	
						requestCount=Integer.parseInt(Count);
					}
					else
					{
						requestCount=requestCount + Integer.parseInt(Count);
					}

					if(ProcessName.equals("CSR_BT"))
					{
						tempProcessName="Balance Transfer";
					}
					if(ProcessName.equals("CSR_CBR"))
					{
						tempProcessName="Cash Back Request";
					}
					if(ProcessName.equals("CSR_CCB"))
					{
						tempProcessName="Credit Card Blocking Request";
					}
					if(ProcessName.equals("CSR_CCC"))
					{
						tempProcessName="Credit Card Cheque";
					}
					if(ProcessName.equals("CSR_MR"))
					{
						tempProcessName="Miscellaneous Request";
					}
					if(ProcessName.equals("CSR_OCC"))
					{
						tempProcessName="Other Credit Card Request";
					}
					if(ProcessName.equals("CSR_RR"))
					{
						tempProcessName="Reversal Request";
					}

			%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr colspan=10>
						<td width="20%" class="EWTableContentsText" align='left'><center><%=ProcessName==null?"":tempProcessName%></center></td>
						<td width="20%" class="EWTableContentsText" align='center'><center><%=Count==null?"":Count%></center></td>
					</tr>
				</table>
			<%
					if (j!=report.size()-1)
					{
						columnDataTemp = report.get(j+1).toString();
						columnDataTemp = columnDataTemp.substring(columnDataTemp.indexOf("!")+1);
						columnDataTemp = columnDataTemp.substring(columnDataTemp.indexOf("!")+1);
						columnDataTemp = columnDataTemp.substring(columnDataTemp.indexOf("!")+1);
						userNameTemp = columnDataTemp.substring(0);
					}
					if (!User.equals(userNameTemp)||j==report.size()-1)
					{
			%>
 				<table align='center' cellspacing="1" cellpadding='1' width="90%">
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Total Requests: </center></span></td>
						<td width="20%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center><%=requestCount%> </center></span></td>
					</tr>
				</table>
			<%
						tempUser1=User;
					}
				}
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