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
int count4sum=0;


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

java.util.Calendar dateCreated = java.util.Calendar.getInstance();
java.text.DateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd");
String formatted_date_to = df.format(dateCreated.getTime());
String formatted_date_from = df.format(dateCreated.getTime());

java.util.Calendar dateCreated1 = java.util.Calendar.getInstance();
java.text.DateFormat df1 = new java.text.SimpleDateFormat("dd-MM-yyyy");
String currentdate = df1.format(dateCreated1.getTime());

String result_date_to = formatted_date_to.substring(0,4) + formatted_date_to.substring(5,7) + formatted_date_to.substring(8,10);
int yr_to = Integer.parseInt(formatted_date_to.substring(0,4));
String mon_to =  formatted_date_to.substring(5,7);
int dta_to = Integer.parseInt(formatted_date_to.substring(8,10));

String result_date_from = formatted_date_from.substring(0,4) + formatted_date_from.substring(5,7) + formatted_date_from.substring(8,10);
int yr_from = Integer.parseInt(formatted_date_from.substring(0,4));
String mon_from =  formatted_date_from.substring(5,7);
int dta_from = Integer.parseInt(formatted_date_from.substring(8,10));

//presuff
String final_date_to = fnl_Dateto;
String final_date_from = fnl_Datefrom;


if(final_date_to==null)
{
	//final_date_to = formatted_date_to;
}
else
{
	 formatted_date_to = final_date_to ; 
	 //out.prinln("formatted_date_to"+formatted_date_to);
	 yr_to = Integer.parseInt(formatted_date_to.substring(0,4));
	 mon_to = formatted_date_to.substring(5,7);
	 dta_to = Integer.parseInt(formatted_date_to.substring(8,formatted_date_to.length()));
	 if(dta_to<9){sel_dte_to = "0"+dta_to;}
	 else{sel_dte_to = dta_to+"";}
	 result_date_to = sel_dte_to+ "-" + mon_to + "-" + yr_to;
	// out.prinln("result_date_to"+result_date_to);
}
if(final_date_from==null)
{
	//final_date_from = formatted_date_from;
}
else
{
	 formatted_date_from = final_date_from ;
	// out.prinln("formatted_date_from"+formatted_date_from);
	 yr_from = Integer.parseInt(final_date_from.substring(0,4));
	 mon_from = final_date_from.substring(5,7);
	 dta_from = Integer.parseInt(final_date_from.substring(8,final_date_from.length()));
	 if(dta_from<9){sel_dte_from = "0"+dta_from;}else{sel_dte_from = dta_from+"";}
	 result_date_from = sel_dte_from + "-" + mon_from + "-" + yr_from;
	// out.prinln("result_date_from"+result_date_from);
}

/*try{
   String strFilePath=request.getRealPath(request.getServletPath()); //Path of current JSP
   strFilePath = strFilePath.substring(0,strFilePath.lastIndexOf("/"));
   //out.println(strFilePath);
   Properties properties = new Properties();
   properties.load(new FileInputStream(strFilePath +"/MashreqUPAReport.properties"));
   groupName = properties.getProperty("FTOGroupName");
   groupName = groupName.toUpperCase();
   //out.println(groupName);
}
catch(IOException e)
{
   out.println(e.toString());
}*/

%>

<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
<title>Cards Volume Report</title>
<script language='javascript'>

function generate_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var mon_from = document.FTOReport.month_from.value;
	var yrs_from = document.FTOReport.year_from.value;
	var final_dt_from = yrs_from +"-"+ mon_from+"-" + dat_from;

	if(mon_from=='04' || mon_from=='06' || mon_from=='09' || mon_from=='11')
	{
		if(dat_from>30) 
		{
			alert('From Date should not be greater than 30');
			return false;
		}
	}

	if(mon_from=='02' && ((yrs_from%4)!=0))
	{
		if(dat_from>28) 
		{
			alert('From Date should not be greater than 28');
			return false;
		}
	}

	if(mon_from=='02' && ((yrs_from%4)==0))
	{
		if(dat_from>29) 
		{
			alert('From Date should not be greater than 29');
			return false;
		}
	}

	if(dat_from<10){dat_from  = "0"+dat_from;}
	var date_from = yrs_from+mon_from+dat_from;

	var dat_to = document.FTOReport.dte_to.value;
	var mon_to = document.FTOReport.month_to.value;
	var yrs_to = document.FTOReport.year_to.value;
	var final_dt_to = yrs_to +"-"+ mon_to+"-" + dat_to;

	if(mon_to=='04' || mon_to=='06' || mon_to=='09' || mon_to=='11')
	{
		if(dat_to>30) 
		{
			alert('To Date should not be greater than 30');
			return false;
		}
	}

	if(mon_to=='02' && ((yrs_to%4)!=0))
	{
		if(dat_to>28) 
		{
			alert('To Date should not be greater than 28');
			return false;
		}
	}

	if(mon_to=='02' && ((yrs_to%4)==0))
	{
		if(dat_to>29) 
		{
			alert('To Date should not be greater than 29');
			return false;
		}
	}

	if(dat_to<10){dat_to  = "0"+dat_to;}
	var date_to = yrs_to+mon_to+dat_to;

	if(parseInt(date_from)>parseInt(date_to))
	{
		alert('From date should be less than To date.');
		return false;
	}
	
	document.FTOReport.action = "FTOReport.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to;
	document.FTOReport.submit;
}
function print_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var mon_from = document.FTOReport.month_from.value;
	var yrs_from = document.FTOReport.year_from.value;
	var final_dt_from = yrs_from +"-"+ mon_from+"-" + dat_from;

	if(mon_from=='04' || mon_from=='06' || mon_from=='09' || mon_from=='11')
	{
		if(dat_from>30) 
		{
			alert('From Date should not be greater than 30');
			return false;
		}
	}

	if(mon_from=='02' && ((yrs_from%4)!=0))
	{
		if(dat_from>28) 
		{
			alert('From Date should not be greater than 28');
			return false;
		}
	}

	if(mon_from=='02' && ((yrs_from%4)==0))
	{
		if(dat_from>29) 
		{
			alert('From Date should not be greater than 29');
			return false;
		}
	}

	if(dat_from<10){dat_from  = "0"+dat_from;}
	var date_from = yrs_from+mon_from+dat_from;

	var dat_to = document.FTOReport.dte_to.value;
	var mon_to = document.FTOReport.month_to.value;
	var yrs_to = document.FTOReport.year_to.value;
	var final_dt_to = yrs_to +"-"+ mon_to+"-" + dat_to;

	if(mon_to=='04' || mon_to=='06' || mon_to=='09' || mon_to=='11')
	{
		if(dat_to>30) 
		{
			alert('To Date should not be greater than 30');
			return false;
		}
	}

	if(mon_to=='02' && ((yrs_to%4)!=0))
	{
		if(dat_to>28) 
		{
			alert('To Date should not be greater than 28');
			return false;
		}
	}

	if(mon_to=='02' && ((yrs_to%4)==0))
	{
		if(dat_to>29) 
		{
			alert('To Date should not be greater than 29');
			return false;
		}
	}

	if(dat_to<10){dat_to  = "0"+dat_to;}
	var date_to = yrs_to+mon_to+dat_to;

	if(parseInt(date_from)>parseInt(date_to))
	{
		alert('From date should be less than To date.');
		return false;
	}

	document.FTOReport.action = "FTOReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=print";
	document.FTOReport.submit;
}
function save_Report()
{
	var dat_from = document.FTOReport.dte_from.value;
	var mon_from = document.FTOReport.month_from.value;
	var yrs_from = document.FTOReport.year_from.value;
	var final_dt_from = yrs_from +"-"+ mon_from+"-" + dat_from;

	if(mon_from=='04' || mon_from=='06' || mon_from=='09' || mon_from=='11')
	{
		if(dat_from>30) 
		{
			alert('From Date should not be greater than 30');
			return false;
		}
	}

	if(mon_from=='02' && ((yrs_from%4)!=0))
	{
		if(dat_from>28) 
		{
			alert('From Date should not be greater than 28');
			return false;
		}
	}

	if(mon_from=='02' && ((yrs_from%4)==0))
	{
		if(dat_from>29) 
		{
			alert('From Date should not be greater than 29');
			return false;
		}
	}

	if(dat_from<10){dat_from  = "0"+dat_from;}
	var date_from = yrs_from+mon_from+dat_from;

	var dat_to = document.FTOReport.dte_to.value;
	var mon_to = document.FTOReport.month_to.value;
	var yrs_to = document.FTOReport.year_to.value;
	var final_dt_to = yrs_to +"-"+ mon_to+"-" + dat_to;

	if(mon_to=='04' || mon_to=='06' || mon_to=='09' || mon_to=='11')
	{
		if(dat_to>30) 
		{
			alert('To Date should not be greater than 30');
			return false;
		}
	}

	if(mon_to=='02' && ((yrs_to%4)!=0))
	{
		if(dat_to>28) 
		{
			alert('To Date should not be greater than 28');
			return false;
		}
	}

	if(mon_to=='02' && ((yrs_to%4)==0))
	{
		if(dat_to>29) 
		{
			alert('To Date should not be greater than 29');
			return false;
		}
	}

	if(dat_to<10){dat_to  = "0"+dat_to;}
	var date_to = yrs_to+mon_to+dat_to;

	if(parseInt(date_from)>parseInt(date_to))
	{
		alert('From date should be less than To date.');
		return false;
	}
	
	document.FTOReport.action = "FTOReportPrint.jsp?fnl_date_from="+final_dt_from+"&fnl_date_to="
	+final_dt_to+"&type=save";
	document.FTOReport.submit;
}
</script>
</head>
<body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0">
<form name='FTOReport' method='post' >
<br>
<table border="0" cellspacing="1" width="740" align="center">
  <tr>  
	<td width="740" colspan='3' > <img src='Logo.gif'></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>EDMS</center></td>
  </tr>
  <tr>  
	<td align="center" width="600" class="EWSubHeaderText" > <center>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mashreq Bank </center></td>
	<td align="center" width="80" class="EWSubHeaderText" > <center>Report Date:  </center></td>
	<td align="center" width="75" class="EWSubHeaderText" > <center><%=currentdate%>  </center></td>
  </tr>
  <tr>  
	<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>FTO Report</center></td>
  </tr>
</table>
<table align='center' cellspacing="1" cellpadding='1' width="90%"> 
<tr>
	<td align='center'><font class='EWLabel3' ><b>From Date :      </b>&nbsp;&nbsp;
		<select name="dte_from" id="dte_from">
		<%for(int j=1;j<32;j++)
		{%>
			<option 
			 <%if(j==dta_from)
				{%> value="<%=j%>" selected <%}
			 else
				 {%>value="<%=j%>" <%}
			 %>>
			 <%=j%>
			</option>
		<%}%>
		</select>&nbsp;
		<select name="month_from" id="month_from">
		<option <%if(mon_from.equals("01")){%> value='01' selected <%}else{%> value='01' <%}%>>Jan</option>
		<option <%if(mon_from.equals("02")){%> value='02' selected <%}else{%> value='02' <%}%>>Feb</option>
		<option <%if(mon_from.equals("03")){%> value='03' selected <%}else{%> value='03' <%}%>>Mar</option>
		<option <%if(mon_from.equals("04")){%> value='04' selected <%}else{%> value='04' <%}%>>Apr</option>
		<option <%if(mon_from.equals("05")){%> value='05' selected <%}else{%> value='05' <%}%>>May</option>
		<option <%if(mon_from.equals("06")){%> value='06' selected <%}else{%> value='06' <%}%>>Jun</option>
		<option <%if(mon_from.equals("07")){%> value='07' selected <%}else{%> value='07' <%}%>>Jul</option>
		<option <%if(mon_from.equals("08")){%> value='08' selected <%}else{%> value='08' <%}%>>Aug</option>
		<option <%if(mon_from.equals("09")){%> value='09' selected <%}else{%> value='09' <%}%>>Sep</option>
		<option <%if(mon_from.equals("10")){%> value='10' selected <%}else{%> value='10' <%}%>>Oct</option>
		<option <%if(mon_from.equals("11")){%> value='11' selected <%}else{%> value='11' <%}%>>Nov</option>
		<option <%if(mon_from.equals("12")){%> value='12' selected <%}else{%> value='12' <%}%>>Dec</option>
		</select>&nbsp;

		<select name="year_from" id="year_from">
		<%for(int k=2000;k<2010;k++)
		{%>
		<option <%if(k==yr_from){%> value='<%=k%>' selected <%}else{%>  value='<%=k%>' <%}%>><%=k%></option>
		<%}%>
		</select>
		 &nbsp;&nbsp;&nbsp;
	</td>
	<td  align='center'><font class='EWLabel3' ><b>To Date : </b>&nbsp;&nbsp;
		<select name="dte_to" id="dte_to">
		<%for(int j=1;j<32;j++)
		{%>
		<option <%if(j==dta_to){%> value="<%=j%>" selected <%}else{%>value="<%=j%>" <%}%>><%=j%></option>
		<%}%>
		</select>&nbsp;

		<select name="month_to" id="month_to">
		<option <%if(mon_to.equals("01")){%> value='01' selected <%}else{%> value='01' <%}%>>Jan</option>
		<option <%if(mon_to.equals("02")){%> value='02' selected <%}else{%> value='02' <%}%>>Feb</option>
		<option <%if(mon_to.equals("03")){%> value='03' selected <%}else{%> value='03' <%}%>>Mar</option>
		<option <%if(mon_to.equals("04")){%> value='04' selected <%}else{%> value='04' <%}%>>Apr</option>
		<option <%if(mon_to.equals("05")){%> value='05' selected <%}else{%> value='05' <%}%>>May</option>
		<option <%if(mon_to.equals("06")){%> value='06' selected <%}else{%> value='06' <%}%>>Jun</option>
		<option <%if(mon_to.equals("07")){%> value='07' selected <%}else{%> value='07' <%}%>>Jul</option>
		<option <%if(mon_to.equals("08")){%> value='08' selected <%}else{%> value='08' <%}%>>Aug</option>
		<option <%if(mon_to.equals("09")){%> value='09' selected <%}else{%> value='09' <%}%>>Sep</option>
		<option <%if(mon_to.equals("10")){%> value='10' selected <%}else{%> value='10' <%}%>>Oct</option>
		<option <%if(mon_to.equals("11")){%> value='11' selected <%}else{%> value='11' <%}%>>Nov</option>
		<option <%if(mon_to.equals("12")){%> value='12' selected <%}else{%> value='12' <%}%>>Dec</option>
		</select>&nbsp;

		<select name="year_to" id="year_to">
		<%for(int k=2000;k<2010;k++)
		{%>
		<option <%if(k==yr_to){%> value='<%=k%>' selected <%}else{%>  value='<%=k%>' <%}%>><%=k%></option>
		<%}%>
		</select>
	</td>
</tr>

<tr>
  <td align='center' colspan="2"> <center>&nbsp;&nbsp;&nbsp;
  <input type="submit" name="generate_report" value="Generate Report" onClick="return generate_Report()">
  &nbsp;&nbsp;&nbsp;
 <input type="submit" name="save" value="Save" onClick="return save_Report()"> &nbsp;&nbsp;&nbsp;
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
try{
  
	/*sCabname=wfsession.getEngineName();
	sSessionId = wfsession.getSessionId();
	sJtsIp = wfsession.getJtsIp();
	iJtsPort = wfsession.getJtsPort();
	userindex = wfsession.getUserIndex();*/
	WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
	WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
	sCabname = wDCabinetInfo.getM_strCabinetName();
	sSessionId = wDUserInfo.getM_strSessionId();
	sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
	userindex = Integer.parseInt(wDUserInfo.getM_strUserIndex());
	 //out.println(formatted_date_from);			 
	 //out.println(formatted_date_to);			 
	 //out.println(groupName);			 
	 //out.println(userindex);			 
	String indexUserAffected ="";

	//String	query4drawingcode="SELECT DISTINCT (DRAWING_CODE) FROM MRQ_CPC_FTO_EXTTABLE WHERE TRUNC(VALUE_DATE) BETWEEN TO_DATE('"+formatted_date_from+"','yyyy-MM-dd') AND TO_DATE('"+formatted_date_to+"','yyyy-MM-dd') AND "
	+userindex+" IN (SELECT USERINDEX FROM PDBGROUPMEMBER WHERE GROUPINDEX IN (SELECT GROUPINDEX FROM PDBGROUP WHERE UPPER(GROUPNAME)=UPPER('"
	+groupName+"'))) ORDER BY DRAWING_CODE asc ";
	
	String	query4drawingcode="SELECT DISTINCT (DRAWING_CODE) FROM MRQ_CPC_FTO_EXTTABLE WHERE TRUNC(VALUE_DATE) BETWEEN TO_DATE('"+formatted_date_from+"','yyyy-MM-dd') AND TO_DATE('"+formatted_date_to+"','yyyy-MM-dd') AND "
	+userindex+" IN (SELECT USERINDEX FROM PDBGROUPMEMBER WHERE GROUPINDEX IN (SELECT GROUPINDEX FROM PDBGROUP WHERE GROUPNAME=:GROUPNAME)) ORDER BY DRAWING_CODE asc ";
	
	String params ="GROUPNAME==" + groupName;
	
	// out.print(query4drawingcode);
	//String testdc="select distinct(drawing_code) from usr_0_drawing_code_master";

	//String	sInputXML4drawingcode="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + query4drawingcode +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
	
	String	sInputXML4drawingcode =	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query4drawingcode + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
		
	
			
	String sOutputXML4drawingcode= WFCallBroker.execute(sInputXML4drawingcode,sJtsIp,iJtsPort,1);
	//out.println(sOutputXML4drawingcode);

	int count4drawingcode = Integer.parseInt(sOutputXML4drawingcode.substring(sOutputXML4drawingcode.indexOf("<TotalRetrieved>")+ 16,sOutputXML4drawingcode.indexOf("</TotalRetrieved>")));
		
	int iRec4drawingcode=0;
	String dcarray[]=new String[count4drawingcode];
	int dcarraycount=0;

	if(count4drawingcode!=0)
	 {
		sOutputXML4drawingcode = sOutputXML4drawingcode.substring(sOutputXML4drawingcode.indexOf("<tr>"),sOutputXML4drawingcode.indexOf("</Records>"));
		%>
	   <table align='center' cellspacing="1"   cellpadding='1' width="90%" border='1'>
		<tr>
			<td width="50%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Drawing Code</center></span>
			</td>
			<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Value Date</center></span>
			</td>
			<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Currency</center></span>
			</td>
			<td width="20%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Amount</center></span></td>
		</tr>
			 <%
	
		while (count4drawingcode>iRec4drawingcode)
		{  
			//System.out.println("By Substracting " + sOutputXML) ;
			dcarray[dcarraycount] = sOutputXML4drawingcode.substring(sOutputXML4drawingcode.indexOf("<td>")+4,sOutputXML4drawingcode.indexOf("</td>")); 
			sOutputXML4drawingcode = sOutputXML4drawingcode.substring(sOutputXML4drawingcode.indexOf("</td>")+5);
			//out.println("hello"+dcarray[dcarraycount]+"<br>");
			dcarraycount++;
			count4drawingcode--;
		}
		
	}
	for(int j=0;j<dcarray.length;j++)   
	{
		/*
		query="SELECT DRAWING_CODE,TO_CHAR(VALUE_DATE,'DD/MM/YYYY'),CURRENCY,AMOUNT FROM MRQ_CPC_FTO_EXTTABLE WHERE TRUNC(VALUE_DATE) BETWEEN TO_DATE('"+formatted_date_from+"','yyyy-MM-dd') AND TO_DATE('"+formatted_date_to+"','yyyy-MM-dd') AND "
		+1+" IN (SELECT USERINDEX FROM PDBGROUPMEMBER WHERE GROUPINDEX IN (SELECT GROUPINDEX FROM PDBGROUP WHERE UPPER(GROUPNAME)=UPPER('"
		+groupName+"'))) AND DRAWING_CODE='"+dcarray[j]+"' ORDER BY DRAWING_CODE ,VALUE_DATE,CURRENCY,AMOUNT";
		*/	 
		query="SELECT DRAWING_CODE,TO_CHAR(VALUE_DATE,'DD/MM/YYYY'),CURRENCY,ROUND(SUM(AMOUNT),3) as SUMAMOUNT FROM MRQ_CPC_FTO_EXTTABLE WHERE TRUNC(VALUE_DATE) BETWEEN TO_DATE('"+formatted_date_from+"','yyyy-MM-dd') AND TO_DATE('"+formatted_date_to+"','yyyy-MM-dd') AND "
		+userindex+" IN (SELECT USERINDEX FROM PDBGROUPMEMBER WHERE GROUPINDEX IN (SELECT GROUPINDEX FROM PDBGROUP WHERE GROUPNAME=:GROUPNAME)) AND DRAWING_CODE=:DRAWING_CODE GROUP BY DRAWING_CODE,VALUE_DATE,CURRENCY ORDER BY DRAWING_CODE,VALUE_DATE,CURRENCY,SUMAMOUNT";	
		
		String params ="GROUPNAME==" + groupName+"~~DRAWING_CODE=="+dcarray[j];
		
		//sInputXML=	"<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + query +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
		
		sInputXML =	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
		
		 sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		 //out.println(sOutputXML);

		 int count1 = Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<TotalRetrieved>")+ 16,sOutputXML.indexOf("</TotalRetrieved>")));
		
		  //out.println("count="+count);
		int iRec=0;
			
		if(count1!=0)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<tr>"),sOutputXML.indexOf("</Records>"));
		  
			while (count1>iRec)
			{
				//System.out.println("By Substracting " + sOutputXML) ;
				String drawingcode = sOutputXML.substring(sOutputXML.indexOf("<td>")+4,sOutputXML.indexOf("</td>")); 
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("</td>")+5);
				
				String valuedate = sOutputXML.substring(sOutputXML.indexOf("<td>")+4,sOutputXML.indexOf("</td>")); 
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("</td>")+5);

				String currency = sOutputXML.substring(sOutputXML.indexOf("<td>")+4,sOutputXML.indexOf("</td>")); 
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("</td>")+5);

				String amount = sOutputXML.substring(sOutputXML.indexOf("<td>")+4,sOutputXML.indexOf("</td>")); 
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("</td>")+5);
				%>

				<%
				 int amountCheck = amount.indexOf(".");
				 if(amountCheck<=-1)
				 {
					  amount = amount + ".000";
				 }
				%>
					<!--table align='center' cellspacing="1" cellpadding='1' width="90%"-->
				<tr >
						<td width="50%" class="EWTableContentsText" ALIGN='LEFT'><font color=''><%=drawingcode%></font>
						</td>
						<td width="15%" class="EWTableContentsText" ALIGN='LEFT'><font color=''><%=valuedate%></font>
						</td>
						<td width="15%" height="21" class="EWTableContentsText"><font color=''><%=currency%></font>
						</td>
						<td width="30%" height="21" class="EWTableContentsNum"><font color=''><%=amount%></font>
						</td>
				</tr>
				<%
				count1--;
		   }%>
		   <tr ><td width="50%" ALIGN='LEFT' colspan='4'>&nbsp;	</td></tr>
		   <%
		}
		   
	} 
	if(dcarray.length<1 && count4drawingcode<1)
		{%><br>
		<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
			<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'> No Record Found</font></B></center></td>
			</tr></table>
		</table><br>
		<%}	
	//out.println(dcarray.length);		
}
	catch(Exception e)
	{
		out.println(e.toString());
	}//out.println(" inside in the for lop"+final_date_from);
}
//if(count<1||count4drawingcode<1||count4sum<1)
//{
	
//}
//out.println(" out side from the fro loop : "+final_date_from);
%>
<table align='center' cellspacing="1" cellpadding='1' width="90%">
	<tr><td width="20%" align='center'><input type='button' name='close' value='Close' onclick='javascript:window.close();'></td>
</tr></table>

</form>
</body>
</html>

