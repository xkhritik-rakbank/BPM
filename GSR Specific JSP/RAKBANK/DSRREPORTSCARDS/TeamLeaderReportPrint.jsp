<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : REPORTS
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 16-Mar-2008
//Description                : for cards volume Print & save Functionality Reports .
//------------------------------------------------------------------------------------------------------------------------------------>

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
  response.setHeader("Cache-Control","no-store"); //HTTP 1.1
  response.setHeader("Pragma","no-cache"); //HTTP 1.0
  response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

%>


<%


	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: branchCode: "+branchCode);
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Date: Agent replace "+fnl_Dateto);
	WriteLog("Integration jsp: fnl_date_to: Agent "+fnl_date_to);
	//WriteLog("Integration jsp: fnl_date_to: Agent "+request.getParameter("fnl_date_to"));
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: fnl_date_from agent: hritik "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	WriteLog("Integration jsp: fnl_Date: Agent replace 1 hritik "+fnl_Datefrom);
	if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("reportType", request.getParameter("reportType"), 1000, true) );
	String reportType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: reportType: "+reportType);
	
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: type: "+type);

String type = type;
String reqType = requestType;
String repType = reportType;
String brCode = branchCode;
String final_date_to = fnl_Dateto;
String final_date_from = fnl_Datefrom;

//String reqStatus = request.getParameter("requestStatus");
String reqStatus = "";
String tempReqType="";
String processdefID="";
String param="";
String Query="";
String xml="";
String sInputXML="";
String sInputXML1="";
String sOutputXML="";
String sOutputXML1="";
String sCabname="";
String sSessionId="";
String sJtsIp="";
int iJtsPort= 0;
String sFields="";
int tolCount1 =0;
String groupName = "";
String query="";
String query1="";
String userName="";
int userindex=0;
String actid = "";
String time1 ="";
String actnid="";
String val = "";
String sel_dte_to = "";
String sel_dte_from = "";
String sel_mon = "";
String sel_yr = "";
int index_id=0;
int i=0;
String  profix = "";
String suffix = "";
String processDefId = "";
String prsuffx = "";
int count = 0;
int count4drawingcode=0;
int count4sum=0;
String procName="SRM_DSR_CARDS_TL_DETAIL_REPORT";//"SRMREPORT_DETAILS";
ArrayList rows = null;
String columnData = "";
int countBT=0;
int countCBR=0;
int countCCB=0;
int countCCC=0;
int countMR=0;
int countRR=0;
int countRIP=0;
int countCR=0;
int countECR=0;
int countCLI=0;
int countCU=0;
int countTD=0;
int countODC=0;
int countCSI=0;
int countCDR=0;
int countCS=0;
int countSSC=0;
String tempfromdate="";
String temptodate = "";
String procName1="SRM_DSR_CARDS_TL_SUMMARY_REPORT";
String param1="";
ArrayList rows1 = null;
ArrayList intrNames = null;
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

try{
	
	if(reqType!=null){
		if(reqType.equalsIgnoreCase("DebitCard Service Request-DebitCard Blocking Request")){
			tempReqType="DSR_DCB";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Credit Card Cheque")){
			tempReqType="CSR_CCC";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Reversals Request")){
			tempReqType="CSR_RR";
		} else {
			tempReqType="DSR_DCB";
		}
	
		if(!tempReqType.equalsIgnoreCase("All")){
			//query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName='"+tempReqType+"'";
			
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:PROCESS_NAME";
			String params ="PROCESS_NAME==" + tempReqType;
			
			//sInputXML1=	"<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + query1 +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
			
			sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			
			WriteLog(sInputXML1);
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXML1);
			
			//tolCount1 = Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<TotalRetrieved>")+ 16,sOutputXML1.indexOf("</TotalRetrieved>")));
			//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
			//processdefID  = sOutputXML1.substring(sOutputXML1.indexOf("<td>")+4,sOutputXML1.indexOf("</td>")); 
			//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("</td>")+5);
			
			WFXmlResponse xmlResponse1 = new WFXmlResponse(sOutputXML1);
			WFXmlList RecordList1;
			RecordList1 =  xmlResponse1.createList("Records", "Record");
			processdefID  = RecordList1.getVal("PROCESSDEFID");
			
		}
	}

	tempfromdate = final_date_from.substring(6).trim()+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
	temptodate = final_date_to.substring(6).trim()+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
	WriteLog(param);
	WriteLog(param1);
	
	param = "'"+brCode+"','"+tempReqType+"','"+tempfromdate+"','"+temptodate+"'";
	param1 = "'"+tempfromdate+"','"+temptodate+"','"+tempReqType+"','"+brCode+"'";
	
	 
} catch(Exception ex){
	
}
if(type.equals("print"))
{
}
else
{
	response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
    response.setHeader("Content-Disposition","attachment;filename=" + "TeamLeader"+".xls");
}
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

			java.util.Calendar dateCreated = java.util.Calendar.getInstance();
			java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
			String formatted_date_to = df.format(dateCreated.getTime());
			String formatted_date_from = df.format(dateCreated.getTime());

			/*java.util.Calendar dateCreated1 = java.util.Calendar.getInstance();
			java.text.DateFormat df1 = new java.text.SimpleDateFormat("dd-MM-yyyy");
			String currentdate = df1.format(dateCreated1.getTime());*/
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
<style type="text/css">
td {mso-number-format:\@ }
</style>
<%if(type.equals("print")){%>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"><%}else{}%>
<title>TeamLeader Report</title>
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>TEAMLEADER REPORT</center></td>
  </tr>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="70%"> 
	<tr>
		<td width='60%' class="EWLabel" ><font color='blue'><b>Date From : </b>&nbsp;&nbsp;<%=final_date_from%>
		 </font>
		</td>
		<td width='40%' class="EWLabel"><font color='blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date To : </b>&nbsp;&nbsp;<%=final_date_to%>
		</font>
		</td>
	</tr>
	<tr>
		<td width='60%' class="EWLabel" ><font color='blue'><b>Request Type : </b>&nbsp;&nbsp;<%=reqType%>
		 </font>
		</td>
		<td width='40%' class="EWLabel"><font color='blue'><b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Branch : </b>&nbsp;&nbsp;<%=brCode%>
		</font>
		</td>

	</tr>
	<tr>
		<!--<td width='50%' class="EWLabel"><font color='blue'><b>Request Status : </b>&nbsp;&nbsp;
		<%
		if (reqStatus.equals(""))
		{
			out.print("All");
		}
		else
		{
			out.print(reqStatus);		
		}
		%>
		</font>
		</td>-->
		<td width='50%' class="EWLabel" ><font color='blue'><b>Report Type : </b>&nbsp;&nbsp;<%=repType%>
		 </font>
		</td>
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
if (repType.equals("Detailed"))
{
try{
	sInputXML1="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName+"</ProcName>" +						
				"<Params>"+param+"</Params>" +  
				"<NoOfCols>12</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";

	WriteLog(sInputXML1);
   //out.println("Testing.."+sInputXML1);
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	WriteLog(sOutputXML1);

	if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)	{
		//out.println("Testing.."+sOutputXML1);
		String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
		//out.println("Testing..123");
		rows = new ArrayList();
		//Added below by Amandeep on 3 Feb 2011
		result=result.replaceAll("null","0");
		//Added Above by Amandeep on 3 Feb 2011
		StringTokenizer rowStr = new StringTokenizer(result, "~");
		while(rowStr.hasMoreTokens()){
			rows.add(rowStr.nextToken());
			//out.println(rows);
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
					<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="10%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Registration No</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> Customer Name </center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Card No</center></span></td>
						<!--<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Elite Customer No</center></span></td>-->
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> Introduced By</center></span></td>
						<td width="8%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction Date</center></span></td>
						<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>
						<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Last Approver</center></span></td>
						<td width="9%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Approver Decision Time</center></span></td>
						<td width="8%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>TeamLeader Decision</center></span></td>
					</tr>
					
					
			<%try
			{
			    intrNames = new ArrayList();
				for(int j=0;j<rows.size();j++)
				{
				
					
					columnData = rows.get(j).toString();
					String winame1 = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String winame = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String winame12 = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String winame2 = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType2  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName2= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String TeamLeader  = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String TLDecisionTime= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber2= columnData;
					if(tempRequestType.equalsIgnoreCase("All"))
					{
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCB")){

							tempRequestType = "DSR_DCB";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCC")){
							tempRequestType = "CSR_CCC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("RR")){ 
							tempRequestType = "CSR_RR";
						}  
					}

					if(tempRequestType.equalsIgnoreCase("DSR_DCB")){
						countCCB++;
						tempRequestType = "DSR - DebitCard Blocking Request";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCC")){
						countCCC++;
						tempRequestType = "CSR - Credit Card Cheque";
					}else if(tempRequestType.equalsIgnoreCase("CSR_RR")){
						countRR++;
						tempRequestType = "CSR - ReversalsRequest";
					}	%>

						<tr colspan=10>
		                    <td width="8%" class="EWTableContentsText" align='left'><%=winame==null?"":winame%></td>
							<td width="10%" class="EWTableContentsText" align='left'><%=winame1==null?"":winame1%></td>
							<td width="8%" class="EWTableContentsNum" ><center><%=tempRequestType==null?"0":tempRequestType%> </center></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=CustomerName==null?"0":CustomerName%></td>
							<!--<td width="8%" class="EWTableContentsNum" ><%=CardNumber==null?"0":CardNumber%></td>-->
							<td width="8%" class="EWTableContentsText" align='left'><%=winame2==null?"":winame2%></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=winame12==null?"":winame12%></td>
							<td width="9%" class="EWTableContentsNum" ><center><%=tempRequestType2==null?"0":tempRequestType2%> </center></td>
							<td width="8%" class="EWTableContentsText" align='left'><%=CustomerName2==null?"0":CustomerName2%></td>
							<td width="8%" class="EWTableContentsNum" ><%=TeamLeader==null?"":TeamLeader%></td>
							<td width="9%" class="EWTableContentsNum" ><%=TLDecisionTime==null?"":TLDecisionTime%></td>
							<td width="8%" class="EWTableContentsNum" ><%=CardNumber2==null?"":CardNumber2%></td>
							</tr>
				<%
				}
			}
			catch(Exception e)
			{
			out.println(" "+e);
			}//while
		}

		if(rows!=null && rows.size()>0)
		{%><br>
			
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="4"><td width="20%" class="EWSubHeaderText" ><center><B>Total </B></center></td>
			<td width="60%" class="EWSubHeaderText" ><center><B><%=reqType%></B></center></td>
			<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
			</tr>
		</table>
		</table><br>
		<%}
		if(rows==null || rows.size()<=0)
		{%><br>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Record Found</font></B></center></td>
			</tr></table>
		</table><br>
	<%}
}

else if (repType.equals("Summarized"))
{
try{
	sInputXML1="<?xml version=\"1.0\"?>" + 				
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+procName1+"</ProcName>" +						
				"<Params>"+param1+"</Params>" +  
				"<NoOfCols>5</NoOfCols>" +
				"<SessionID>"+sSessionId+"</SessionID>" +
				"<EngineName>"+sCabname+"</EngineName>" +
				"</APProcedure2_Input>";

	WriteLog(sInputXML1);
   //out.println("Testing.."+sInputXML1);
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	WriteLog(sOutputXML1);

	if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)	{
		//out.println("Testing.."+sOutputXML1);
		String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
		//out.println("Testing..123");
		rows = new ArrayList();
		//Added below by Amandeep on 3 Feb 2011
		result=result.replaceAll("null","0");
		//Added Above by Amandeep on 3 Feb 2011
		StringTokenizer rowStr = new StringTokenizer(result, "~");
		while(rowStr.hasMoreTokens()){
			rows.add(rowStr.nextToken());
			//out.println(rows);
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
					<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>UserName</center></span></td>
						<td width="30%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center> Approved </center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Discarded</center></span></td>
						<td width="9%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Resubmitted</center></span></td>
						<!--<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Discarded</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Elite CustomerNo.</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="4%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="4%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="3%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>-->
					</tr>
					
					
			<%try
			{
			    intrNames = new ArrayList();
				for(int j=0;j<rows.size();j++)
				{
				
					
					columnData = rows.get(j).toString();
					
                    String winame1 = columnData.substring(0,columnData.indexOf("!"));
					//out.println(winame);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					
					String winame = columnData.substring(0,columnData.indexOf("!"));
					//out.println(winame);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType  = columnData.substring(0,columnData.indexOf("!"));
					//out.println(tempRequestType);
					//Commented Below By Amandeep 3 Feb 2011
					//tempRequestType=tempRequestType.replace("null","0");
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CustomerName= columnData.substring(0,columnData.indexOf("!"));
					//out.println(CustomerName);
					//Commented Below By Amandeep 3 Feb 2011
					//CustomerName=CustomerName.replace("null","0");
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CardNumber= columnData;
					//Commented Below By Amandeep 3 Feb 2011
					//CardNumber=CardNumber.replace("null","0");
					//out.println(CardNumber);
					
					
					/*columnData = columnData.substring(columnData.indexOf("!")+1);
					//String CardCRN= columnData.substring(0,columnData.indexOf("!"));
					//out.println(CardCRN);
					//columnData = columnData.substring(columnData.indexOf("!")+1);
					//out.println(columnData);
					String EliteCustomerNo= columnData.substring(0,columnData.indexOf("!"));
					//out.println("hjhjh:"+EliteCustomerNo);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String InitiationBranch= columnData.substring(0,columnData.indexOf("!"));
					//out.println(InitiationBranch);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					Introducedby= columnData.substring(0,columnData.indexOf("!"));
					// Adding Data Introduced Names in to Array.
					intrNames.add(Introducedby);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String Introductiondate= columnData.substring(0,columnData.indexOf("!"));
					//out.println(Introductiondate);
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String Activityname= columnData.substring(0);
					//out.println(Activityname);*/
					 
						if(tempRequestType.equalsIgnoreCase("All")){

			
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CBR")){
							tempRequestType = "DSR_CBR";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("DCB")){

							tempRequestType = "DSR_DCB";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCC")){
							tempRequestType = "CSR_CCC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("MR")){
							tempRequestType = "DSR_MISC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("RR")){ 
							tempRequestType = "CSR_RR";
						} else
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ODC")){ 
							tempRequestType = "DSR_ODC";
						} 
					}

					if(tempRequestType.equalsIgnoreCase("DSR_CBR")){
						countCBR++;
						tempRequestType = "DSR - CashBackRequest";
					} else if(tempRequestType.equalsIgnoreCase("DSR_DCB")){
						countCCB++;

						tempRequestType = "DSR - DebitCard Blocking Request";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCC")){
						countCCC++;
						tempRequestType = "CSR - CreditCardCheque";
					} else if(tempRequestType.equalsIgnoreCase("DSR_MISC")){
						countMR++;
						tempRequestType = "DSR - MiscellaneousRequests";
					} else if(tempRequestType.equalsIgnoreCase("CSR_RR")){
						countRR++;
						tempRequestType = "CSR - ReversalsRequest";
					}else if(tempRequestType.equalsIgnoreCase("Re-Issue of PIN")){
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
						countODC++;
						tempRequestType = "Other Credit Card";
					}
				    	%>

						<tr colspan=10>
		                    <td width="10%" class="EWTableContentsText" align='left'><%=winame1==null?"":winame1%></td>
							<td width="10%" class="EWTableContentsText" align='left'><%=winame==null?"":winame%></td>
							<td width="30%" class="EWTableContentsNum" ><center><%=tempRequestType==null?"0":tempRequestType%> </center></td>
							<td width="30%" class="EWTableContentsText" align='left'><%=CustomerName==null?"0":CustomerName%></td>
							<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"0":CardNumber%></td>
							</tr>
				<%
				//out.println(CustomerName=="null");
				//iRecd = iRecd+1;
				
			}
			}
			catch(Exception e)
			{
			out.println(" "+e);
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

}

	%>
	</form>
	</body>
</html>

