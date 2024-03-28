<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*,com.newgen.wfdesktop.session.WFSession" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
<%@ page import= "java.util.Properties" %>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>	


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


String type = request.getParameter("type");
String brCode = request.getParameter("branchCode");
String final_date_to = request.getParameter("fnl_date_to");
String final_date_from = request.getParameter("fnl_date_from");


String sInputXML1="";
String sOutputXML1="";
String sCabname="";
String sSessionId="";
String sJtsIp="";
int iJtsPort= 0;

String procName="PL_IPDR_STATUS_REPORT_FOR_PAST_DUE";//"SRMREPORT_DETAILS";
String param = "";
ArrayList rows = null;
String columnData = "";

String tempfromdate="";
String temptodate = "";

sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();

try {
	if (final_date_from != null && final_date_to != null && brCode != null) {

		tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
		param = "'"+brCode+"','"+tempfromdate+"','"+temptodate+"'";
	
	}
} catch (Exception e) {
	e.printStackTrace();
}
	

if(type.equals("print"))
{
}
else
{
	response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
    response.setHeader("Content-Disposition","attachment;filename=" + "StatusReportForPastDue"+".xls");
}



sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();
DateFormat dtFormat = new SimpleDateFormat( "dd-MM-yyyy"+ " hh:mm:ss");
			String currentdate = dtFormat.format(new java.util.Date());
%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<style type="text/css">
			td {mso-number-format:\@ }
		</style>
<%if(type.equals("print")){%>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"><%}else{}%>
<title>Personal Loan - Status Report for Past Due</title>
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>Personal Loan</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>Status Report For Past Due</center></td>
  </tr>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
	<tr>
		<td width='50%' align='center' class="EWLabel" ><center><font color='blue'><b>Date From : </b>&nbsp;&nbsp;<%=final_date_from%>
		 </font></center>
		</td>
		<td width='50%' align='center' class="EWLabel"><center><font color='blue'><b>Date To : </b>&nbsp;&nbsp;<%=final_date_to%>
		</font></center>
		</td>
	</tr>
	<tr>
		<td width='50%' align='center' class="EWLabel"><center><font color='blue'><b>Branch : </b>&nbsp;&nbsp;<%=brCode%>
		</font></center>
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
							<td width="15%" class="EWTableContentsText" align='left'><span class="EWLabel"><%=debitAccountNo==null || debitAccountNo.trim().equalsIgnoreCase("null") || debitAccountNo.trim().equalsIgnoreCase("")?"&nbsp;":debitAccountNo%></span></td>
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
	</form>
	</body>
</html>

