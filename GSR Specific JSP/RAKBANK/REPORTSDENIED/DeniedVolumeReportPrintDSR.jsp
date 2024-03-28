<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : REPORTS
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 20-Mar-2008
//Description                : for denied volume Print & save Functionality Reports .
//------------------------------------------------------------------------------------------------------------------------------------>

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
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: branchCode: "+branchCode);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: type: "+type);


String type = type;
String reqType = requestType;
String brCode = branchCode;
String final_date_to = fnl_Dateto;
String final_date_from = fnl_Datefrom;

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
String procName="SRM_CARDS_DENIED_REPORT_DSR";//"SRMREPORT_DETAILS";
ArrayList rows = null;
String columnData = "";
int countBT=0;
int countCBR=0;
int countDCB=0;
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
		if(reqType.equalsIgnoreCase("DebitCard Service Request-Balance Transfer")){
			tempReqType="DSR_BT";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Cash Back Request")){
			tempReqType="DSR_CBR";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-DebitCard Blocking Request")){
			tempReqType="DSR_DCB";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Credit Card Cheque")){
			tempReqType="DSR_CCC";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Miscellaneous Requests")){
			tempReqType="DSR_MR";
		} else if(reqType.equalsIgnoreCase("DebitCard Service Request-Reversals Request")){
			tempReqType="DSR_RR";
		} else if(reqType.equalsIgnoreCase("Re-Issue of PIN")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Card Replacement")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Early Card Renewal")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Credit Limit Increase")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Card Upgrade")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Transaction Dispute")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Change in Standing Instructions")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Card Delivery Request")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Credit Shield")){
			tempReqType="DSR_ODC";
		} else if(reqType.equalsIgnoreCase("Setup Suppl. Card Limit")){
			tempReqType="DSR_ODC";
		} else {
			tempReqType="All";
		}
	
		if(!tempReqType.equalsIgnoreCase("All")){
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:ProcessName";
			String params ="ProcessName=="+tempReqType";
			sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			tolCount1 = Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<TotalRetrieved>")+ 16,sOutputXML1.indexOf("</TotalRetrieved>")));
			/*sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
			processdefID  = sOutputXML1.substring(sOutputXML1.indexOf("<td>")+4,sOutputXML1.indexOf("</td>")); 
			sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("</td>")+5);
			*/
			WFXmlResponse xmlResponse1 = new WFXmlResponse(sBranchDetails);
			WFXmlList RecordList1;
			RecordList1 =  xmlResponse1.createList("Records", "Record");
			processdefID  = RecordList1.getVal("PROCESSDEFID");
		}
	}

	tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
	temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);

	if((reqType.equalsIgnoreCase("Re-Issue of PIN"))|| (reqType.equalsIgnoreCase("Card Replacement")) ||(reqType.equalsIgnoreCase("Early Card Renewal")) || (reqType.equalsIgnoreCase("Card Upgrade")) || (reqType.equalsIgnoreCase("Transaction Dispute")) || (reqType.equalsIgnoreCase("Change in Standing Instructions")) || (reqType.equalsIgnoreCase("Card Delivery Request")) || (reqType.equalsIgnoreCase("Credit Shield")) || (reqType.equalsIgnoreCase("Setup Suppl. Card Limit")) ||(reqType.equalsIgnoreCase("Credit Limit Increase")))
	{
		param = "'"+brCode+"','"+reqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"'";

	}
	else{
				
		if(reqType.equalsIgnoreCase("DebitCard Service Request-Miscellaneous Requests")){
			tempReqType="DSR_MISC";
			}
		    param = "'"+brCode+"','"+tempReqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"'";
			//out.print("parametre"+param);
	}
	//out.print("param"+param);
	 
} catch(Exception ex){
	
}
if(type.equals("print"))
{
}
else
{
	response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
    response.setHeader("Content-Disposition","attachment;filename=" + "DeniedVolume"+".xls");
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
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<style type="text/css">
td {mso-number-format:\@ }
</style>
<%if(type.equals("print")){%>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"><%}else{}%>
<title>Debit Cards Denied Report</title>
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
  <!-- changes according to BDB 005 given by Tanuj -->
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>DEBITCARDS DENIED REPORT</center></td>
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
		<td width='50%' align='center' class="EWLabel" ><center><font color='blue'><b>Request Type : </b>&nbsp;&nbsp;<%=reqType%>
		 </font></center>
		</td>
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
				"<NoOfCols>11</NoOfCols>" +
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
				//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
				//System.out.println("sachin:1 " + sOutputXML1) ;
				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>RequestType</center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>RegistrationNo.</center></span></td>
						<td width="16%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CustomerName</center></span></td>
						<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardNumber</center></span></td>
						<!--<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardCRN</center></span></td>-->
						<td width="6%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Master No.</center></span></td>
						<td width="6%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Discarded
						by</center></span></td>
						<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Discard
						Date</center></span></td>
					</tr>
			<%

				for(int j=0;j<rows.size();j++){
					
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
					String Discardedby= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String DiscardDate = columnData.substring(0);
					
					if(tempRequestType.equalsIgnoreCase("All")){
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("BT")){
							tempRequestType = "DSR_BT";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CBR")){
							tempRequestType = "DSR_CBR";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("DCB")){
							tempRequestType = "DSR_DCB";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCC")){
							tempRequestType = "DSR_CCC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("MR")){
							tempRequestType = "DSR_MISC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("RR")){ 
							tempRequestType = "DSR_RR";
						} else
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ODC")){ 
							tempRequestType = "DSR_ODC";
						} 
					}
					if(tempRequestType.equalsIgnoreCase("DSR_BT")){
						countBT++;
						tempRequestType = "DSR-Balance Transfer";
					} else if(tempRequestType.equalsIgnoreCase("DSR_CBR")){
						countCBR++;
						tempRequestType = "DSR-Cash Back Request";
					} else if(tempRequestType.equalsIgnoreCase("DSR_DCB")){
						countDCB++;
						tempRequestType = "DSR-DebitCard Blocking Request";
					} else if(tempRequestType.equalsIgnoreCase("DSR_CCC")){
						countCCC++;
						tempRequestType = "DSR-Credit Card Cheque";
					} else if(tempRequestType.equalsIgnoreCase("DSR_MISC")){
						countMR++;
						tempRequestType = "DSR-Miscellaneous Requests";
					} else if(tempRequestType.equalsIgnoreCase("DSR_RR")){
						countRR++;
						tempRequestType = "DSR-Reversals Request";
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
						tempRequestType = "Change in Standing Instructions";
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
						tempRequestType = "Other Debit Card";
					}
					%>
						<tr colspan=11>
		
							<td width="10%" class="EWTableContentsText" align='left'><%=tempRequestType==null?"":tempRequestType%></td>
							<td width="25%" class="EWTableContentsNum" ><center><%=winame==null?"":winame%> </center></td>
							<td width="25%" class="EWTableContentsText" align='left'><%=CustomerName==null?"":CustomerName%></td>
							<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"":CardNumber%></td>
							<!--<td width="15%" class="EWTableContentsText" align='left'><%=CardCRN==null?"":CardCRN%></td>-->
							<td width="15%" class="EWTableContentsText" align='left'><%=EliteCustomerNo==null?"":EliteCustomerNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=InitiationBranch==null?"":InitiationBranch%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=Introducedby==null?"":Introducedby%></td>
							 <td width="15%" class="EWTableContentsText" align='left'><%=Introductiondate==null?"":Introductiondate%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=Discardedby==null?"":Discardedby%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=DiscardDate==null?"":DiscardDate%></td>


							</tr>
				<%
				//iRecd = iRecd+1;
				
			}//while
			
		}
		if(!reqType.equals("All") && rows!=null && rows.size()>0)
		{%><br>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="1"><td width="100%" class="EWSubHeaderText" ><center><B>Summary</B></center></td>
			</tr>
		</table>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr colspan="4"><td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
			<td width="60%" class="EWSubHeaderText" ><center><B><%=reqType%></B></center></td>
			<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
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
				<!--<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Balance Transfer</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countBT%></B></center></td>
				</tr>-->
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Cash Back Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCBR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-DebitCard Blocking Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countDCB%></B></center></td>
				</tr><!--
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Credit Card Cheque</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCCC%></B></center></td>
				</tr>-->
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Miscellaneous Requests</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countMR%></B></center></td>
				</tr><!--
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>DebitCard Service Request-Reversals Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countRR%></B></center></td>
				</tr>-->
				 
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Other Debit Card Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countODC%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Grand Total </B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>All</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=rows.size()%></B></center></td>
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
}

	%>
	</form>
	</body>
</html>

