<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : REPORTS
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 18-Mar-2008
//Description                : for completion volume Print & save Functionality Reports .
//------------------------------------------------------------------------------------------------------------------------------------>

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


	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("requestType", request.getParameter("requestType"), 1000, true) );
	String requestType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: requestType: "+requestType);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: branchCode: "+branchCode);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: type_1: "+type_1);
	
		String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
	//WriteLog("Integration jsp: fnl_date_to cmpl: "+fnl_date_to);
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Dateto);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	//WriteLog("Integration jsp: fnl_date_from cmpl: "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Datefrom);
	if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	
String type = type_1;
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
String procName="SRM_CARDS_COMPLETED_REPORT";//"SRMREPORT_DETAILS";
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
int countOCC=0;
int countCSI=0;
int countCDR=0;
int countCS=0;
int countSSC=0;
String tempfromdate="";
String temptodate = "";

sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();

try{
	
	if(reqType!=null && !reqType.equals("")){
		if(reqType.equalsIgnoreCase("Card Service Request-Balance Transfer")){
			tempReqType="CSR_BT";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Cash Back Request")){
			tempReqType="CSR_CBR";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Credit Card Blocking Request")){
			tempReqType="CSR_CCB";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Credit Card Cheque")){
			tempReqType="CSR_CCC";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Miscellaneous Requests")){
			tempReqType="CSR_MR";
		} else if(reqType.equalsIgnoreCase("Card Service Request-Reversals Request")){
			tempReqType="CSR_RR";
		} else if(reqType.equalsIgnoreCase("Re-Issue of PIN")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Card Replacement")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Early Card Renewal")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Credit Limit Increase")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Card Upgrade")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Transaction Dispute")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Change in Standing Instructions")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Card Delivery Request")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Credit Shield")){
			tempReqType="CSR_OCC";
		} else if(reqType.equalsIgnoreCase("Setup Suppl. Card Limit")){
			tempReqType="CSR_OCC";
		} else {
			tempReqType="All";
		}
	
		if(!tempReqType.equalsIgnoreCase("All")){
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:ProcessName";
			String params ="ProcessName=="+tempReqType";
			sInputXML1=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 +"</Query><Params>"+params+"</Params><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			tolCount1 = Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<TotalRetrieved>")+ 16,sOutputXML1.indexOf("</TotalRetrieved>")));
			/*
			sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
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
				

			if(reqType.equalsIgnoreCase("Card Service Request-Miscellaneous Requests")){
			tempReqType="CSR_MISC";
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
    response.setHeader("Content-Disposition","attachment;filename=" + "CompletionVolume"+".xls");
}

sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();

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
<title>Cards Completion Report</title>
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>SRM-CARDS</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>CARDS COMPLETION REPORT</center></td>
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
						<td width="21%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp      RequestType&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</center></span></td>
						<td width="40%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Registration No.</center></span></td>
						<td width="39%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
						<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardNumber</center></span></td>
						<td width="6%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CardCRN</center></span></td>
						<td width="6%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Elite Customer No.</center></span></td>
						<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Initiation Branch</center></span></td>
						<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Completed By
						</center></span></td>
						<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Completion Date
						</center></span></td>
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
					String CompletedBy = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String CompletionDate = columnData.substring(0);
					
					if(tempRequestType.equalsIgnoreCase("All")){
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("BT")){
							tempRequestType = "CSR_BT";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CBR")){
							tempRequestType = "CSR_CBR";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCB")){
							tempRequestType = "CSR_CCB";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("CCC")){
							tempRequestType = "CSR_CCC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("MR")){
							tempRequestType = "CSR_MISC";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("RR")){ 
							tempRequestType = "CSR_RR";
						} else
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("OCC")){ 
							tempRequestType = "CSR_OCC";
						} 
					}
					if(tempRequestType.equalsIgnoreCase("CSR_BT")){
						countBT++;
						tempRequestType = "CSR-Balance Transfer";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CBR")){
						countCBR++;
						tempRequestType = "CSR-Cash Back Request";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCB")){
						countCCB++;
						tempRequestType = "CSR-Credit Card Blocking Request";
					} else if(tempRequestType.equalsIgnoreCase("CSR_CCC")){
						countCCC++;
						tempRequestType = "CSR-Credit Card Cheque";
					} else if(tempRequestType.equalsIgnoreCase("CSR_MISC")){
						countMR++;
						tempRequestType = "CSR-Miscellaneous Requests";
					} else if(tempRequestType.equalsIgnoreCase("CSR_RR")){
						countRR++;
						tempRequestType = "CSR-Reversals Request";
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
					} else if(tempRequestType.equalsIgnoreCase("CSR_OCC")){
						countOCC++;
						tempRequestType = "Other Credit Card";
					}
				

						%>
						<tr colspan=11>
		
							<td width="10%" class="EWTableContentsText" align='left'><%=tempRequestType==null?"":tempRequestType%></td>
							<td width="25%" class="EWTableContentsNum" ><center><%=winame==null?"":winame%> </center></td>
							<td width="25%" class="EWTableContentsText" align='left'><%=CustomerName==null?"":CustomerName%></td>
							<td width="10%" class="EWTableContentsNum" ><%=CardNumber==null?"":CardNumber%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=CardCRN==null?"":CardCRN%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=EliteCustomerNo==null?"":EliteCustomerNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=InitiationBranch==null?"":InitiationBranch%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=Introducedby==null?"":Introducedby%></td>
							 <td width="15%" class="EWTableContentsText" align='left'><%=Introductiondate==null?"":Introductiondate%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=CompletedBy==null?"":CompletedBy%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=CompletionDate==null?"":CompletionDate%></td>


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
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Balance Transfer</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countBT%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Cash Back Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCBR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Credit Card Blocking Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCCB%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Credit Card Cheque</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countCCC%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Miscellaneous Requests</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countMR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Card Service Request-Reversals Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countRR%></B></center></td>
				</tr>
				 
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Other Credit Card Request</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countOCC%></B></center></td>
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

