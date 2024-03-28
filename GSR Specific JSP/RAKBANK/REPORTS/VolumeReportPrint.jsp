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
	//WriteLog("Integration jsp: requestType: "+requestType);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("branchCode", request.getParameter("branchCode"), 1000, true) );
	String branchCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	//WriteLog("Integration jsp: branchCode: "+branchCode);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	//WriteLog("Integration jsp: type: "+type);

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


//String type = request.getParameter("type");
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
String procName="SRM_RLS_REPORT";//"SRMREPORT_DETAILS";
ArrayList rows = null;
String columnData = "";
int countPD=0;
int countPS=0;
int countES=0;
int countIPDR=0;
int countLCOL=0;
int countEMPADD=0;
String tempfromdate="";
String temptodate = "";

sCabname=wfsession.getEngineName();
sSessionId = wfsession.getSessionId();
sJtsIp = wfsession.getJtsIp();
iJtsPort = wfsession.getJtsPort();

try{
	if(reqType!=null && !reqType.equals("")){
		if(reqType.equalsIgnoreCase("Personal Loan-Postponement/Deferral")){
			tempReqType="PL_PD";
		} else if(reqType.equalsIgnoreCase("Personal Loan-Part Settlement/Advance Installment Payment")){
			tempReqType="PL_PS";
		} else if(reqType.equalsIgnoreCase("Personal Loan-Early Settlement(TakeOver and Cash and EOSB)")){
			tempReqType="PL_ES";
		} else if(reqType.equalsIgnoreCase("Personal Loan-Instalment Recovery / Past Due Recovery")){
			tempReqType="PL_IPDR";
		} else if(reqType.equalsIgnoreCase("General Service Requests-Liability Certificate/No Liability Certificate")){
			tempReqType="GSR_LCOL";
		} else if(reqType.equalsIgnoreCase("General Service Requests-Change in Employer/Address for Loan Customers")){
			tempReqType="GSR_EMPADD";
		} else {
			tempReqType="All";
		}
	
		if(!tempReqType.equalsIgnoreCase("All")){
			query1="SELECT PROCESSDEFID  FROM PROCESSDEFTABLE WHERE ProcessName=:ProcessName";
			String params ="ProcessName=="+tempReqType;
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
	param = "'"+brCode+"','"+tempReqType+"','"+processdefID+"','"+tempfromdate+"','"+temptodate+"'";
	
	
} catch(Exception ex){
	
}
if(type.equals("print"))
{
}
else
{
	response.setContentType("APPLICATION/MS-EXCEL;charset=shift_jis");
    response.setHeader("Content-Disposition","attachment;filename=" + "volume"+".xls");
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



			//presuff
			
       
	        
			

      

%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<%if(type.equals("print")){%>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"><%}else{}%>
<title>Branch Volume Report</title>
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
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>SRM-RLS</center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>Branch Volume Report</center></td>
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
  //query1="SELECT BRANCH,WI_NAME,AGREEMENTNO,CUSTOMERNAME,BRANCHUSERNAME,Current_Workstep_name  FROM RB_PL_PD_EXTTABLE WHERE Branch='"+brCode+"' order by WI_NAME ";
	/*sInputXML1=	"?xml version=\"1.0\"?>\n" +
	"<APProcedure_Input>\n" +
	"<Option>APProcedure2</Option>\n" +
	"<ProcName>"+procName+"</ProcName>" +
	"<Params>"+param+"</Params>\n" +
	"<SessionId>"+sSessionId+"</SessionId>\n"+
	"<EngineName>"+sCabname+"</EngineName>\n" +
	"</APProcedure_Input>\n";
	sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
	out.println("sOutputXML1"+sOutputXML1);*/
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
	
	
		  int iRecd=0;
	if(rows!=null && rows.size()>0)
		  {
				//sOutputXML1 = sOutputXML1.substring(sOutputXML1.indexOf("<tr>"),sOutputXML1.indexOf("</Records>"));
				//System.out.println("sachin:1 " + sOutputXML1) ;
				%>
				<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
					<tr>
						<td width="10%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Branch</center></span></td>
						<td width="25%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Request Type</center></span></td>
						<td width="25%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Registration No</center></span></td>
						<td width="10%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Agreement ID</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Customer Name</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduced By</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Introduction date</center></span></td>
						<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Current Stage</center></span></td>
					</tr>
			<%

				
				for(int j=0;j<rows.size();j++){
					
					columnData = rows.get(j).toString();
					
				String  winame = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String  branch = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String tempRequestType = columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String aggrementNo= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String customername= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String introducedby= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String introducedTime= columnData.substring(0,columnData.indexOf("!"));
					columnData = columnData.substring(columnData.indexOf("!")+1);
					String currentsatge= columnData.substring(0);
					
					if(tempRequestType.equalsIgnoreCase("All")){
						if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("PD")){
							tempRequestType = "PL_PD";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("PS")){
							tempRequestType = "PL_PS";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("ES")){
							tempRequestType = "PL_ES";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("IPDR")){
							tempRequestType = "PL_IPDR";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("LCOL")){
							tempRequestType = "GSR_LCOL";
						} else if((winame.substring(winame.lastIndexOf("-")+1)).equalsIgnoreCase("EmpAdd")){
							tempRequestType = "GSR_EMPADD";
						} 
					}
					if(tempRequestType.equalsIgnoreCase("PL_PD")){
						countPD++;
						tempRequestType = "Personal Loan-Postponement/Deferral";
					} else if(tempRequestType.equalsIgnoreCase("PL_PS")){
						countPS++;
						tempRequestType = "Personal Loan-Part Settlement/Advance Installment Payment";
					} else if(tempRequestType.equalsIgnoreCase("PL_ES")){
						countES++;
						tempRequestType = "Personal Loan-Early Settlement(TakeOver and Cash and EOSB)";
					} else if(tempRequestType.equalsIgnoreCase("PL_IPDR")){
						countIPDR++;
						tempRequestType = "Personal Loan-Instalment Recovery / Past Due Recovery";
					} else if(tempRequestType.equalsIgnoreCase("GSR_LCOL")){
						countLCOL++;
						tempRequestType = "General Service Requests-Liability Certificate/No Liability Certificate";
					} else if(tempRequestType.equalsIgnoreCase("GSR_EMPADD")){
						countEMPADD++;
						tempRequestType = "General Service Requests-Change in Employer/Address for Loan Customers";
					}

						%>
						<tr colspan=8>
		
							<td width="10%" class="EWTableContentsText" align='left'><%=branch==null?"":branch%></td>
							<td width="25%" class="EWTableContentsNum" ><center><%=tempRequestType==null?"":tempRequestType%> </center></td>
							<td width="25%" class="EWTableContentsText" align='left'><%=winame==null?"":winame%></td>
							<td width="10%" class="EWTableContentsNum" ><%=aggrementNo==null?"":aggrementNo%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=customername==null?"":customername%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=introducedby==null?"":introducedby%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=introducedTime==null?"":introducedTime%></td>
							<td width="15%" class="EWTableContentsText" align='left'><%=currentsatge==null?"":currentsatge%></td>
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
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Postponement/Deferral</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countPD%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Part Settlement/Advance Installment Payment</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countPS%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Early Settlement(TakeOver and Cash and EOSB)</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countES%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>Personal Loan-Instalment Recovery / Past Due Recovery</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countIPDR%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>General Service Requests-Liability Certificate/No Liability Certificate</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countLCOL%></B></center></td>
				</tr>
				<tr colspan="4">
					<td width="20%" class="EWSubHeaderText" ><center><B>Total Volume</B></center></td>
					<td width="60%" class="EWSubHeaderText" ><center><B>General Service Requests-Change in Employer/Address for Loan Customers</B></center></td>
					<td width="20%" class="EWSubHeaderText" ><center><B><%=countEMPADD%></B></center></td>
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

