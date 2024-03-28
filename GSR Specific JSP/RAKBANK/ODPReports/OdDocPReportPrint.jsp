<%
/*------------------------------------------------------------------------------------------------------

                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED

Group                                           : Application -Projects

Project/Product                                 : RAKBANK-PRD-13-14

Application                                     : Omnidocs Productivity Report

Module                                          : Report

File Name                                       : ODDocReportPrint.jsp

Author                                          : Ravi Chaturvedi

Date (DD/MM/YYYY)                         		: 14/08/2013

Description                                     : Omnidocs Productivity Detailed Report Print jsp
-------------------------------------------------------------------------------------------------------

CHANGE HISTORY

-------------------------------------------------------------------------------------------------------

Problem No/CR No   Change Date   Changed By    Change Description

------------------------------------------------------------------------------------------------------*/
%>

<%@ include file="../../CSRProcessSpecific/Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*,com.newgen.wfdesktop.session.WFSession" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.sql.*"%> 
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
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	
	
	String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_to", request.getParameter("fnl_date_to"), 1000, true) );
	String fnl_date_to = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
	//WriteLog("Integration jsp: fnl_date_to cmpl: "+fnl_date_to);
	String fnl_Dateto = fnl_date_to.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Dateto);
	
	String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("fnl_date_from", request.getParameter("fnl_date_from"), 1000, true) );
	String fnl_date_from = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
	//WriteLog("Integration jsp: fnl_date_from cmpl: "+fnl_date_from);
	String fnl_Datefrom = fnl_date_from.replaceAll("&#x2f;","/");
	//WriteLog("Integration jsp: fnl_Date:  replace "+fnl_Datefrom);

		if("".equals(fnl_Datefrom)){
		fnl_Datefrom=null;
	}
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("B_Date", request.getParameter("B_Date"), 1000, true) );
	String B_Date = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: B_Date: "+B_Date);
	
	String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("p_flag", request.getParameter("p_flag"), 1000, true) );
	String p_flag = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
	WriteLog("Integration jsp: p_flag: "+p_flag);
	
	String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("B_Index", request.getParameter("B_Index"), 1000, true) );
	String oldBatchIndex_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
	WriteLog("Integration jsp: oldBatchIndex_1: "+oldBatchIndex_1);
	
	String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("type", request.getParameter("type"), 1000, true) );
	String type_1 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
	WriteLog("Integration jsp: type_1: "+type_1);

	String type = type_1;
	String final_date_to = fnl_Dateto;
	String final_date_from = fnl_Datefrom;
	String BatchDate = B_Date;
	String pFlag = p_flag;
	String bIndex = oldBatchIndex_1;
	

	
	
	String param="";
	String sInputXML1="";
	String sOutputXML1="";
	String sCabname="";
	String sSessionId="";
	String sJtsIp="";
	int iJtsPort= 0;
	String procName="SRM_OD_DOC_PRODUCTIVITY_REPORT";
	ArrayList rows = null;
	String columnData = "";
	String tempfromdate="";
	String temptodate = "";

	sCabname=wfsession.getEngineName();
	sSessionId = wfsession.getSessionId();
	sJtsIp = wfsession.getJtsIp();
	iJtsPort = wfsession.getJtsPort();

	try
	{
		tempfromdate = final_date_from.substring(6)+"-"+final_date_from.substring(3,5)+"-"+final_date_from.substring(0,2);
		temptodate = final_date_to.substring(6)+"-"+final_date_to.substring(3,5)+"-"+final_date_to.substring(0,2);
		//param = "'"+tempfromdate+"','"+temptodate+"'";
		//BatchDate=BatchDate;
		param = "'"+tempfromdate+"','"+temptodate+"','"+BatchDate+"','"+bIndex+"','"+pFlag+"'";
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
		<title>Document Productivity Report</title>
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
			<td align="center" width="740" class="EWSubHeaderText" colspan='3'> <center>Productivity Detailed Report</center></td>
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
	</table>
	<br>
<%
	if(final_date_from==null || final_date_from.equals(""))
	{
	
	}
	else
	{
	
		try
		{
			
			//out.println(param);
			
			
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
			sOutputXML1= WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXML1);
			if(!sOutputXML1.equals("") || Integer.parseInt(sOutputXML1.substring(sOutputXML1.indexOf("<MainCode>")+10 , sOutputXML1.indexOf("</MainCode>")))==0)
			{
				String result = sOutputXML1.substring(sOutputXML1.indexOf("<Results>")+9,sOutputXML1.indexOf("</Results>"));
				rows = new ArrayList();
				StringTokenizer rowStr = new StringTokenizer(result, "~");
				while(rowStr.hasMoreTokens())
				{
					rows.add(rowStr.nextToken());
				}
			}
		}
		catch(Exception e)
		{
			out.println("In Exception: "+e.toString());
		}
		int iRecd=0;
		if(rows!=null && rows.size()>0)
		{
%>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr>
					<td width="1%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>S.No</center></span></td>
					<td width="19%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Created DateTime</center></span></td>
					<td width="5%" height="25" class="EWSubHeaderText"><span class="EWLabel"><center>Created By User</center></span></td>
					<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Document Type</center></span></td>
					<td width="15%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Document Name</center></span></td>
					<td width="1%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>No Of Pages</center></span></td>
					<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>CIFID</center></span></td>
					<td width="19%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Modified DateTime</center></span></td>
					<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Modified By User</center></span></td>
					<td width="19%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Approved DateTime</center></span></td>
					<td width="5%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Approved By User</center></span></td>
					<td width="3%" height="21" class="EWSubHeaderText"><span class="EWLabel"><center>Document Status</center></span></td>
				</tr>
<%
			//WriteLog("Parsing Data...");
			String rowcount="";
			String create_date ="";
			String userID  ="";
			String No_doc="";										
			String No_pages ="";													
			String cifid ="";						
			String mod_date ="";									
			String mod_user="";									
			String app_date ="";						
			String app_user ="";						
			String doc_ststus ="";
			String doc_name="";
			if(!pFlag.equalsIgnoreCase("PREV"))
			{
				for(int j=0;j<rows.size();j++)
				{
						rowcount=Integer.toString(j+1);
						columnData = rows.get(j).toString();
						create_date = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						userID  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						No_doc= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						doc_name= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						No_pages = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);								
						cifid = columnData.substring(0,columnData.indexOf("!"));
						if(cifid.equalsIgnoreCase("null")||cifid.equals(""))
							cifid="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						mod_date = columnData.substring(0,columnData.indexOf("!"));
						if(mod_date.equalsIgnoreCase("null")||mod_date.equals(""))
							mod_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						mod_user=columnData.substring(0,columnData.indexOf("!"));
						if(mod_user.equalsIgnoreCase("null")||mod_user.equals(""))
							mod_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						app_date = columnData.substring(0,columnData.indexOf("!"));
						if(app_date.equalsIgnoreCase("null")||app_date.equals(""))
							app_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						app_user = columnData.substring(0,columnData.indexOf("!"));
						if(app_user.equalsIgnoreCase("null")||app_user.equals(""))
							app_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);	
						//doc_ststus = columnData.substring(0);
						doc_ststus = columnData.substring(0,columnData.indexOf("!"));
						
						
	%>
					<tr colspan=10>
						<td width="1%" class="EWTableContentsText" align='left'><%=rowcount==null?"":rowcount%></td>
						<td width="20%" class="EWTableContentsText" align='left'><%=create_date==null?"":create_date%></td>
						<td width="10%" class="EWTableContentsNum" ><center><%=userID==null?"":userID%> </center></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=No_doc==null?"":No_doc%></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=doc_name==null?"":doc_name%></td>
						<td width="1%" class="EWTableContentsNum" ><%=No_pages==null?"":No_pages%></td>
						<td width="5%" class="EWTableContentsNum" ><%=cifid==null?"":cifid%></td>
						<td width="20%" class="EWTableContentsNum" ><%=mod_date==null?"":mod_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=mod_user==null?"":mod_user%></td>
						<td width="20%" class="EWTableContentsNum" ><%=app_date==null?"":app_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=app_user==null?"":app_user%></td>
						<td width="3%" class="EWTableContentsNum" ><%=doc_ststus==null?"":doc_ststus%></td>
					</tr>
	<% 
				}
			}
			else
			{
				for(int j=rows.size()-1;j>=0;j--)
				{
						rowcount=Integer.toString(rows.size()-j);
						columnData = rows.get(j).toString();
						create_date = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						userID  = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						No_doc= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);
						doc_name= columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						No_pages = columnData.substring(0,columnData.indexOf("!"));
						columnData = columnData.substring(columnData.indexOf("!")+1);								
						cifid = columnData.substring(0,columnData.indexOf("!"));
						if(cifid.equalsIgnoreCase("null")||cifid.equals(""))
							cifid="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						mod_date = columnData.substring(0,columnData.indexOf("!"));
						if(mod_date.equalsIgnoreCase("null")||mod_date.equals(""))
							mod_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						mod_user=columnData.substring(0,columnData.indexOf("!"));
						if(mod_user.equalsIgnoreCase("null")||mod_user.equals(""))
							mod_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);				
						app_date = columnData.substring(0,columnData.indexOf("!"));
						if(app_date.equalsIgnoreCase("null")||app_date.equals(""))
							app_date="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);
						app_user = columnData.substring(0,columnData.indexOf("!"));
						if(app_user.equalsIgnoreCase("null")||app_user.equals(""))
							app_user="&nbsp;";
						columnData = columnData.substring(columnData.indexOf("!")+1);	
						//doc_ststus = columnData.substring(0);
						doc_ststus = columnData.substring(0,columnData.indexOf("!"));
						
						
						
	%>
					<tr colspan=10>
						<td width="1%" class="EWTableContentsText" align='left'><%=rowcount==null?"":rowcount%></td>
						<td width="20%" class="EWTableContentsText" align='left'><%=create_date==null?"":create_date%></td>
						<td width="10%" class="EWTableContentsNum" ><center><%=userID==null?"":userID%> </center></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=No_doc==null?"":No_doc%></td>
						<td width="10%" class="EWTableContentsText" align='left'><%=doc_name==null?"":doc_name%></td>
						<td width="1%" class="EWTableContentsNum" ><%=No_pages==null?"":No_pages%></td>
						<td width="5%" class="EWTableContentsNum" ><%=cifid==null?"":cifid%></td>
						<td width="20%" class="EWTableContentsNum" ><%=mod_date==null?"":mod_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=mod_user==null?"":mod_user%></td>
						<td width="20%" class="EWTableContentsNum" ><%=app_date==null?"":app_date%></td>
						<td width="10%" class="EWTableContentsNum" ><%=app_user==null?"":app_user%></td>
						<td width="3%" class="EWTableContentsNum" ><%=doc_ststus==null?"":doc_ststus%></td>
					</tr>
	<% 
				}
			}
			WriteLog("Done Parsing Data...");
		}

		if(rows==null || rows.size()<=0)
		{
%>			<br>
			<table align='center' cellspacing="1" cellpadding='1' width="90%" border='1'>
				<tr><td width="20%" class="EWTableContentsText" ><center><B><font color='RED'>No Records Found!</font></B></center></td>
				</tr></table>
			</table>
			<br>
<%		}
	}
%>
	</form>
</body>
</html>

