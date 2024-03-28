<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       AgentReportPrint.jsp
	Purpose         :       To Print No. of Service requests submitted individually by Agents Names
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/040	
--%>
<%@ include file="../../DSRProcessSpecific/Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
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
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("userName", request.getParameter("userName"), 1000, true) );
	String userName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: userName: "+userName);


	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: branchCode: "+branchCode);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: branchCode: "+type);
	
	
	String reqType = requestType;
	String brCode = branchCode;
	String userName=userName;
	String sel_dte_to = "";
	String sel_dte_from = "";
	String tempReqType="";
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
			else if(reqType.equalsIgnoreCase("Reversals Request"))
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
	String procName2="SRM_AGENT_REPORT_DSR";
	ArrayList users = null;
	ArrayList report = null;
	String columnData = "";
	String columndata2 = "";
	String type = type;
	sCabname=wfsession.getEngineName();
	sSessionId = wfsession.getSessionId();
	sJtsIp = wfsession.getJtsIp();
	iJtsPort = wfsession.getJtsPort();
	try
	{
		String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
		param = "'"+userName+"','"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"'";
	}
	catch(Exception ex)
	{}
	if(type.equals("print"))
	{
	}
	else
	{
		response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
		response.setHeader("Content-Disposition","attachment;filename=" + "AgentReport"+".xls");
	}
	java.util.Calendar dateCreated = java.util.Calendar.getInstance();
	java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
	String formatted_date_to = df.format(dateCreated.getTime());
	String formatted_date_from = df.format(dateCreated.getTime());

	DateFormat dtFormat = new SimpleDateFormat( "dd-MM-yyyy"+ " hh:mm:ss");
	String currentdate = dtFormat.format(new java.util.Date());

	String result_date_to = formatted_date_to.substring(0,4) + formatted_date_to.substring(5,7) + formatted_date_to.substring(8,10);
	int yr_to = Integer.parseInt(formatted_date_to.substring(0,4));
	String mon_to =  formatted_date_to.substring(5,7);
	int dta_to = Integer.parseInt(formatted_date_to.substring(8,10));

	String result_date_from = formatted_date_from.substring(0,4) + formatted_date_from.substring(5,7) + formatted_date_from.substring(8,10);
	int yr_from = Integer.parseInt(formatted_date_from.substring(0,4));
	String mon_from =  formatted_date_from.substring(5,7);
	int dta_from = Integer.parseInt(formatted_date_from.substring(8,10));
%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<style type="text/css">
td {mso-number-format:\@ }
</style>
<%
if(type.equals("print"))
{
	%>
	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
	<%
	}
else
{}
%>
	<title>Agent Wise Report</title>
	<script language='javascript'>
		function forprint()
		{
		window.print();
		}	
	</script>
</head>
<%
	if(type.equals("print"))
	{
		%>
		<body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0" onload='forprint()'>
		<%
	}
else
{
	%>
	<body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0">
	<%
}
	%>
	<form name='FTOReport' method='post' >
		<br>
		<table border="0" cellspacing="1" width="740" align="center">
			<tr>  
				<td width="740" colspan='3' > <img src='Logo.gif'></td>
			</tr>
			<tr>  
				<td align="center" width="600" class="EWSubHeaderText" > <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RAKBANK </center>
				</td>
				<td align="center" width="80" class="EWSubHeaderText" > <center>Report Date:  </center></td>
				<td align="center" width="75" class="EWSubHeaderText" > <center><%=currentdate%>  </center></td>
			</tr>
			<tr>  
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>SRM-DEBITCARDS</center></td>
			</tr>
			<tr>  
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>AGENT WISE REPORT</center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="70%"> 
			<tr>
				<td width='50%' class="EWLabel" ><font color='blue'><b>Date From : </b>&nbsp;&nbsp;<%=final_date_from%></font>
				</td>
				<td width='50%' class="EWLabel"><font color='blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date To : </b>&nbsp;&nbsp;<%=final_date_to%></font>
				</td>
			</tr>
			<tr>
				<td width='50%' class="EWLabel" ><font color='blue'><b>Request Type: </b>&nbsp;&nbsp;<%=reqType%></font>
				</td>
				<td width='50%' class="EWLabel"><font color='blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Branch Id: </b>&nbsp;&nbsp;<%=brCode%></font>
				</td>
			</tr>
			<tr>
				<td width='50%' class="EWLabel" ><font color='blue'><b>Agent Name : </b>&nbsp;&nbsp;<%=userName%></font>
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

					if(ProcessName.equals("DSR_BT"))
					{
						tempProcessName="Balance Transfer";
					}
					if(ProcessName.equals("DSR_CBR"))
					{
						tempProcessName="Cash Back Request";
					}
					if(ProcessName.equals("DSR_DCB"))
					{
						tempProcessName="DebitCard Blocking Request";
					}
					if(ProcessName.equals("DSR_CCC"))
					{
						tempProcessName="Credit Card Cheque";
					}
					if(ProcessName.equals("DSR_MR"))
					{
						tempProcessName="Miscellaneous Request";
					}
					if(ProcessName.equals("DSR_ODC"))
					{
						tempProcessName="Other Debit Card Request";
					}
					if(ProcessName.equals("DSR_RR"))
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
	</form>
</body>
</html>