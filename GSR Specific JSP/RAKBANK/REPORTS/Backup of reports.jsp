
<%

response.setHeader("Cache-Control","no-store"); //HTTP 1.1
response.setHeader("Pragma","no-cache"); //HTTP 1.0
response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

String sCabname="";
String sSessionId="";
String sJtsIp="";
int iJtsPort= 0;
String FTOgroupName = "";
String FailedWIgroupName = "";
String FTOUserName = "";
String FailedWIUserName = "";
String AlpUsrName = "";
String SwiftReconGrp = "";
String SwiftReconUsrName = "";
String AlpRptGrp = "";
int countFTOGroup = 0;
int countFailedWIGroup = 0;
int countSwiftRptGroup = 0;
int countAlpRptGroup = 0;
int userindex = 0;


%>

<html>
<head>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
<title>Loan Service Reports</title>

</head>
<body topmargin="0" marginheight="0" marginwidth="2" alink="blue" vlink="blue" leftmargin="0">
<form name='FTOReport' method='post' >
<br>
<table border="0" cellspacing="1" width="97%" align="center">
<tr>  			    
	<td align="center" width="100%" class="EWSubHeaderText" > <center>RAKBANK </center>
	</td>
  </tr>
  <tr>  
	<td align="center" width="100%" class="EWSubHeaderText" colspan='3'> <center>REPORTS--SRM-RLS</center></td>
  </tr>
  <tr>  			    
	<td align="center" width="100%" >&nbsp;</center> 	</td>
  </tr>
  <tr>  			    
	<td align="center" width="100%" >&nbsp;</center> 	</td>
  </tr>
  <tr>
    <td>
		<table border="0" cellspacing="1" width="100%" align="left">
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/REPORTS/BRVolumeReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>Branch Volume Report</li></font></a></td>
			</tr>

			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/REPORTS/PLIPDRStatusReportForPastDue.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>Personal Loan: Status Report For Past Due</li></font></a></td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
	<td align='center'>&nbsp;</td>
  </tr>
  <tr>
	<td align='center'><input type='button' name='Close' value='Close' onclick='javascript:window.close();'>	</td>
  </tr>
</table>
</form>
</body>
</html>