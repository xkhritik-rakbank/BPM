<%--
	
	Product/Project :       Rak Bank
	Module          :       Reports
	File            :       ODCReport.jsp
	Purpose         :       To print ODC Report on the lines of Card Volume Report
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/039	
--%>
<%@ include file="../../CSRProcessSpecific/Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*,com.newgen.wfdesktop.session.WFSession" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
<%@ page import= "java.util.Properties" %>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>	
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
  response.setHeader("Cache-Control","no-store"); //HTTP 1.1
  response.setHeader("Pragma","no-cache"); //HTTP 1.0
  response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

%>


<%

	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type_1= ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: type: "+type_1);
	
		
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
	
	

	String type =type_1;
	String reqType = requestType;
	String final_date_to = fnl_Dateto;
	String final_date_from = fnl_Datefrom;
	
	
	String tempReqType="";
	String processdefID="";
	String param="";
	String Query="";
	String sInputXML1="";
	String sOutputXML1="";
	String sCabname="";
	String sSessionId="";
	String sJtsIp="";
	int iJtsPort= 0;
	String sFields="";
	String query="";
	String query1="";
	int i=0;
	int count = 0;
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

	String tempfromdate="";
	String temptodate = "";

	sCabname=wfsession.getEngineName();
	sSessionId = wfsession.getSessionId();
	sJtsIp = wfsession.getJtsIp();
	iJtsPort = wfsession.getJtsPort();

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

		tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);

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
	if(type.equals("print"))
	{
	}
	else
	{
		response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
		response.setHeader("Content-Disposition","attachment;filename=" + "ODCReport"+".xls");
	}
	sCabname=wfsession.getEngineName();
	sSessionId = wfsession.getSessionId();
	sJtsIp = wfsession.getJtsIp();
	iJtsPort = wfsession.getJtsPort();

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
<%if(type.equals("print")){%>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"><%}else{}%>
<title>Cards Volume Report</title>
<script language='javascript'>
	function forprint()
	{
		window.print();
	}	
</script>
</head>
<%if(type.equals("print")){%><body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0" onload='forprint()'><%}else{%><body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0"><%}%>
	<form name='FTOReport' method='post' >
			<br>
			<table border="0" cellspacing="1" width="740" align="center">
  <tr>  
	<td width="740" colspan='3' > <img src='Logo.gif'></td>
  </tr>
  
  <tr>  
	<td align="center" width="600" class="EWSubHeaderText" > <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RAKBANK </center></td>
	<td align="center" width="80" class="EWSubHeaderText" > <center>Report Date:  </center></td>
	<td align="center" width="75" class="EWSubHeaderText" > <center><%=currentdate%>  </center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>SRM-DEBITCARDS</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>OTHER DEBIT CARD REQUESTS REPORT</center></td>
  </tr>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="70%"> 
	<tr>
		<td width='50%' class="EWLabel" ><font color='blue'><b>Date From : </b>&nbsp;&nbsp;<%=final_date_from%>
		 </font>
		</td>
		<td width='50%' class="EWLabel"><font color='blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date To : </b>&nbsp;&nbsp;<%=final_date_to%>
		</font>
		</td>
	</tr>
	<tr>
		<td width='50%' class="EWLabel" ><font color='blue'><b>Request Type : </b>&nbsp;&nbsp;<%=reqType%>
		 </font>
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
							<!--<td width="15%" class="EWTableContentsText" align='left'><%=CardCRN==null?"":CardCRN%></td>-->
							<td width="15%" class="EWTableContentsText" align='left'><%=EliteCustomerNo==null?"":EliteCustomerNo%></td>
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
				<tr colspan="4"><!--
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
		%><!--
				<tr colspan="4">
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
		%><!--
				<tr colspan="4">
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
		%><!--
				<tr colspan="4">
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
		%><!--
				<tr colspan="4">
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
		%><!--
				<tr colspan="4">
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
	</form>
	</body>
</html>

