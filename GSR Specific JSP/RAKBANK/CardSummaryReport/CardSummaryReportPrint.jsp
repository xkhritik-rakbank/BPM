<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       RequestSummaryReportPrint.jsp
	Purpose         :       To print No. of Pending / Approved / Returned back to Branch Requests
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/041
--%>
<%@ include file="../../CSRProcessSpecific/Log.process"%>
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
	String tempActivityName1 = "";
	String tempReqType="";
	
	//WriteLog("Integration jsp: requestType Hritik: "+request.getParameter("requestType"));
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	//WriteLog("Integration jsp: requestType Hritik: "+requestType);
	
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("decisionType", request.getParameter("decisionType"), 1000, true) );
	String decisionType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	//WriteLog("Integration jsp: decisionType Hritik: "+decisionType);

	//WriteLog("Integration jsp: decisionType Hritik: "+request.getParameter("type"));
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: decisionType Hritik: "+type_1);
	
	String reqType = requestType;
	String decType = decisionType;
	String sel_dte_to = "";
	String sel_dte_from = "";
	boolean bError=false;
	ArrayList rows = new ArrayList();
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
			else if(reqType.equalsIgnoreCase("Reversal Request"))
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
	String final_date_from =fnl_Datefrom;
	String param="";
	String procName2="SRM_CARD_SUMMARY_REPORT";
	ArrayList report = null;
	String columnData = "";
	String columndata2 = "";
	String type = type_1;
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
	try
	{
		String tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		String temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
		param = "'"+tempfromdate+"','"+temptodate+"','"+decType+"','"+tempReqType+"'";
	}
	catch(Exception ex)
	{}
	if(type.equals("print"))
	{
	}
	else
	{
		response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
		response.setHeader("Content-Disposition","attachment;filename=" + "CardStatusReport"+".xls");
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
	<title>Card Status Report</title>
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
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>SRM-CARDS</center></td>
			</tr>
			<tr>  
				<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>REQUEST SUMMARY REPORT</center></td>
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
				<td width='50%' class="EWLabel" ><font color='blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Decision: </b>&nbsp;&nbsp;
				<%
				if (decType.equals("Approve"))
				{
					out.print("Complete");
				}
				else
				{
					out.print(decType);				
				}
				%></font>
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
	File            :       CardSummaryReportPrint.jsp
	Purpose         :       The report does not display the detailed records ,only summary was displayed
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/082				   Saurabh Arora  29/01/2009
*/
			try
			{
				String procName="SRM_CARD_DETAIL_REPORT";
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
				<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardCRN</center></span></td>
				<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Elite CustomerNo.</center></span></td>
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
					if(tempRequestType.equalsIgnoreCase("CSR_BT"))
					{
						tempRequestType = "Balance Transfer";
					} 
					else if(tempRequestType.equalsIgnoreCase("CSR_CBR"))
					{
						tempRequestType = "Cash Back Request";
					}
					else if(tempRequestType.equalsIgnoreCase("CSR_CCB"))
					{
						tempRequestType = "Credit Card Blocking Request";
					} 
					else if(tempRequestType.equalsIgnoreCase("CSR_CCC"))
					{
						tempRequestType = "Credit Card Cheque";
					} 
					else if(tempRequestType.equalsIgnoreCase("CSR_MISC")||tempRequestType.equalsIgnoreCase("CSR_MR"))
					{
						tempRequestType = "Miscellaneous Requests";
					}
					else if(tempRequestType.equalsIgnoreCase("CSR_RR"))
					{
						tempRequestType = "Reversals Request";
					}		
					else if(tempRequestType.equalsIgnoreCase("CSR_OCC"))
					{
						tempRequestType = "Other Credit Card Request";
					}	
		%>
				<tr colspan=10>
					<td width="10%" class="EWTableContentsText" align='left'><%=tempRequestType==null?"":tempRequestType%></td>
					<td width="30%" class="EWTableContentsNum" ><center><%=winame==null?"":winame%> </center></td>
					<td width="30%" class="EWTableContentsText" align='left'><%=CustomerName==null?"":CustomerName%></td>
					<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"":CardNumber%></td>
					<td width="15%" class="EWTableContentsText" align='left'><%=CardCRN==null?"":CardCRN%></td>
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
				WriteLog("Print Request Summary Data: "+sInputXML2);
				sOutputXML2= WFCallBroker.execute(sInputXML2,sJtsIp,iJtsPort,1);
				WriteLog("Print Request Summary Data: "+sOutputXML2);
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
			if(report!=null && report.size()>0)
			{
			%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="20%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Decision Taken</center></span></td>
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
	File            :       CardSummaryReportPrint.jsp
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
	</form>
</body>
</html>