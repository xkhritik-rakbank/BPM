<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : REPORTS
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 16-Mar-2008
//Description                : for cards Reports .
//------------------------------------------------------------------------------------------------------------------------------------>
<%@ page import="java.io.*"%>
<%@ page  import="java.util.*" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>

<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>

<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
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

int countVolumeRptGrp=0;
int countDeniedRptGrp=0;
int countCompletRptGrp=0;
int countODCRptGrp=0;
int countAgntRptGrp=0;
int countStatusRptGrp=0;
int countConsolRptGrp=0;
int countTeamLeadRptGrp=0;
int countBranchRetRptGrp=0;

String sVolumeRptGrp="";
String sDeniedRptGrp="";
String sCompletRptGrp="";
String sODCRptGrp="";
String sAgentRptGrp="";
String sStatusRptGrp="";
String sConsolRptGrp="";
String sTeamLeadRptGrp="";
String sBranchRetRptGrp="";

String[] sVolumeRptGrps=null;
String[] sDeniedRptGrps=null;
String[] sCompletRptGrps=null;
String[] sODCRptGrps=null;
String[] sAgentRptGrps=null;
String[] sStatusRptGrps=null;
String[] sConsolRptGrps=null;
String[] sTeamLeadRptGrps=null;
String[] sBranchRetRptGrps=null;

String VolUserName = "";
String DeniedUserName = "";
String CompletUserName = "";
String ODCUserName = "";
String AgentUserName = "";
String StatusUserName = "";
String ConsolUserName = "";
String TeamLeadUserName = "";
String BranchRetUserName = "";

try{
	String strFilePath=request.getRealPath(request.getServletPath()); //Path of current JSP
	strFilePath = strFilePath.substring(0,strFilePath.lastIndexOf(System.getProperty("file.separator"))); 
	Properties properties = new Properties();
	properties.load(new FileInputStream(strFilePath +System.getProperty("file.separator")+"RAKReport.properties"));
  
	sVolumeRptGrp=properties.getProperty("DbtVolumeRptGroupName");
	sDeniedRptGrp=properties.getProperty("DbtDeniedRptGroupName");
	sCompletRptGrp=properties.getProperty("DbtCompletionRptGroupName");
	sODCRptGrp=properties.getProperty("DbtODCRptGroupName");
	sAgentRptGrp=properties.getProperty("DbtAgentRptGroupName");
	sStatusRptGrp=properties.getProperty("DbtStatusRptGroupName");
	sConsolRptGrp=properties.getProperty("DbtConsolidatedRptGroupName");
	sTeamLeadRptGrp=properties.getProperty("DbtTeamLeaderRptGroupName");
	sBranchRetRptGrp=properties.getProperty("DbtBranchReturnRptGroupName");
	//out.println(sVolumeRptGrp+sDeniedRptGrp+sCompletRptGrp+sODCRptGrp+sAgentRptGrp+sStatusRptGrp+sConsolRptGrp+sTeamLeadRptGrp+sBranchRetRptGrp);
	sVolumeRptGrps=sVolumeRptGrp.split(",");
	sDeniedRptGrps=sDeniedRptGrp.split(",");
	sCompletRptGrps=sCompletRptGrp.split(",");
	sODCRptGrps=sODCRptGrp.split(",");
	sAgentRptGrps=sAgentRptGrp.split(",");
	sStatusRptGrps=sStatusRptGrp.split(",");
	sConsolRptGrps=sConsolRptGrp.split(",");
	sTeamLeadRptGrps=sTeamLeadRptGrp.split(",");
	sBranchRetRptGrps=sBranchRetRptGrp.split(",");
	//
	sVolumeRptGrp="";
	sDeniedRptGrp="";
	sCompletRptGrp="";
	sODCRptGrp="";
	sAgentRptGrp="";
	sStatusRptGrp="";
	sConsolRptGrp="";
	sTeamLeadRptGrp="";
	sBranchRetRptGrp="";
}
catch(Exception e)
{
   out.println(e.toString());
}
%>

<html>
<head>
<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css">
<title>Debit Card Service Reports</title>
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
	<td align="center" width="100%" class="EWSubHeaderText" colspan='3'> <center>REPORTS--SRM-DEBITCARDS</center></td>
  </tr>
  <tr>  			    
	<td align="center" width="100%" >&nbsp;</center> 	</td>
  </tr>
   <tr>
    <td>
		<table border="0" cellspacing="1" width="100%" align="left">
		<%
			//Session variables
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
				
			}
			catch(Exception e){
			   out.println(e.toString());
			}
			int i=0;
			//Volume Report
			try
			{
				int iRecVolGroup=0;
				for(i=0;i<sVolumeRptGrps.length;i++)
				{
					sVolumeRptGrp=sVolumeRptGrps[i];String queryVolGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sVolumeRptGrp+"'";
					String	sInputXMLVolGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryVolGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLVolGroup= WFCallBroker.execute(sInputXMLVolGroup,sJtsIp,iJtsPort,1);
					countVolumeRptGrp+= Integer.parseInt(sOutputXMLVolGroup.substring(sOutputXMLVolGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLVolGroup.indexOf("</TotalRetrieved>")));
					/*
					if(countVolumeRptGrp!=0)
					{
						sOutputXMLVolGroup = sOutputXMLVolGroup.substring(sOutputXMLVolGroup.indexOf("<tr>"),sOutputXMLVolGroup.indexOf("</Records>"));
						while(countVolumeRptGrp>iRecVolGroup)
						{  
							VolUserName = sOutputXMLVolGroup.substring(sOutputXMLVolGroup.indexOf("<td>")+4,sOutputXMLVolGroup.indexOf("</td>")); 
							sOutputXMLVolGroup = sOutputXMLVolGroup.substring(sOutputXMLVolGroup.indexOf("</td>")+5);
							++iRecVolGroup;
						}
					}*/
				}
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//Denied Report
			try
			{
				int iRecDeniedGroup=0;
				for(i=0;i<sDeniedRptGrps.length;i++)
				{
					sDeniedRptGrp=sDeniedRptGrps[i];
					String queryDeniedGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sDeniedRptGrp+"'";
					String	sInputXMLDeniedGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryDeniedGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLDeniedGroup= WFCallBroker.execute(sInputXMLDeniedGroup,sJtsIp,iJtsPort,1);
					countDeniedRptGrp+= Integer.parseInt(sOutputXMLDeniedGroup.substring(sOutputXMLDeniedGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLDeniedGroup.indexOf("</TotalRetrieved>")));
					/*
					if(countDeniedRptGrp!=0)
					{
						sOutputXMLDeniedGroup = sOutputXMLDeniedGroup.substring(sOutputXMLDeniedGroup.indexOf("<tr>"),sOutputXMLDeniedGroup.indexOf("</Records>"));
						while(countDeniedRptGrp>iRecDeniedGroup)
						{  
							DeniedUserName = sOutputXMLDeniedGroup.substring(sOutputXMLDeniedGroup.indexOf("<td>")+4,sOutputXMLDeniedGroup.indexOf("</td>")); 
							sOutputXMLDeniedGroup = sOutputXMLDeniedGroup.substring(sOutputXMLDeniedGroup.indexOf("</td>")+5);
							++iRecDeniedGroup;
						}
					}*/
				}	
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//Completion Report
			try
			{
				int iRecCompletGroup=0;
				for(i=0;i<sCompletRptGrps.length;i++)
				{
					sCompletRptGrp=sCompletRptGrps[i];
					String queryCompletGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sCompletRptGrp+"'";
					String	sInputXMLCompletGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryCompletGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLCompletGroup= WFCallBroker.execute(sInputXMLCompletGroup,sJtsIp,iJtsPort,1);
					countCompletRptGrp+= Integer.parseInt(sOutputXMLCompletGroup.substring(sOutputXMLCompletGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLCompletGroup.indexOf("</TotalRetrieved>")));
			
			
					/*	if(countCompletRptGrp!=0)
					{
						sOutputXMLCompletGroup = sOutputXMLCompletGroup.substring(sOutputXMLCompletGroup.indexOf("<tr>"),sOutputXMLCompletGroup.indexOf("</Records>"));
						while(countCompletRptGrp>iRecCompletGroup)
						{  
							CompletUserName = sOutputXMLCompletGroup.substring(sOutputXMLCompletGroup.indexOf("<td>")+4,sOutputXMLCompletGroup.indexOf("</td>")); 
							sOutputXMLCompletGroup = sOutputXMLCompletGroup.substring(sOutputXMLCompletGroup.indexOf("</td>")+5);
							++iRecCompletGroup;
						}
					}*/
				}
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//ODC Report
			try
			{
				int iRecODCGroup=0;
				for(i=0;i<sODCRptGrps.length;i++)
				{
					sODCRptGrp=sODCRptGrps[i];
				
					String queryODCGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sODCRptGrp+"'";
					String	sInputXMLODCGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryODCGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLODCGroup= WFCallBroker.execute(sInputXMLODCGroup,sJtsIp,iJtsPort,1);
					countODCRptGrp+= Integer.parseInt(sOutputXMLODCGroup.substring(sOutputXMLODCGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLODCGroup.indexOf("</TotalRetrieved>")));
					/*
					if(countODCRptGrp!=0)
					{
						sOutputXMLODCGroup = sOutputXMLODCGroup.substring(sOutputXMLODCGroup.indexOf("<tr>"),sOutputXMLODCGroup.indexOf("</Records>"));
						while(countODCRptGrp>iRecODCGroup)
						{  
							ODCUserName = sOutputXMLODCGroup.substring(sOutputXMLODCGroup.indexOf("<td>")+4,sOutputXMLODCGroup.indexOf("</td>")); 
							sOutputXMLODCGroup = sOutputXMLODCGroup.substring(sOutputXMLODCGroup.indexOf("</td>")+5);
							++iRecODCGroup;
						}
					}*/
				}
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//Agent Report
			try
			{
				int iRecStatusGroup=0;
				for(i=0;i<sStatusRptGrps.length;i++)
				{
					sStatusRptGrp=sStatusRptGrps[i];
					String queryStatusGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sStatusRptGrp+"'";
					String	sInputXMLStatusGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryStatusGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLStatusGroup= WFCallBroker.execute(sInputXMLStatusGroup,sJtsIp,iJtsPort,1);
					countStatusRptGrp+= Integer.parseInt(sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLStatusGroup.indexOf("</TotalRetrieved>")));
					
					/*if(countStatusRptGrp!=0)
					{
						sOutputXMLStatusGroup = sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("<tr>"),sOutputXMLStatusGroup.indexOf("</Records>"));
						while(countStatusRptGrp>iRecStatusGroup)
						{  
							StatusUserName = sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("<td>")+4,sOutputXMLStatusGroup.indexOf("</td>")); 
							sOutputXMLStatusGroup = sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("</td>")+5);
							++iRecStatusGroup;
						}
					}*/
				}	
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//Status Report
			try
			{
				int iRecStatusGroup=0;
				for(i=0;i<sStatusRptGrps.length;i++)
				{
					sStatusRptGrp=sStatusRptGrps[i];
					String queryStatusGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sStatusRptGrp+"'";
					String	sInputXMLStatusGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryStatusGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLStatusGroup= WFCallBroker.execute(sInputXMLStatusGroup,sJtsIp,iJtsPort,1);
					countStatusRptGrp+= Integer.parseInt(sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLStatusGroup.indexOf("</TotalRetrieved>")));
					
					/*if(countStatusRptGrp!=0)
					{
						sOutputXMLStatusGroup = sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("<tr>"),sOutputXMLStatusGroup.indexOf("</Records>"));
						while(countStatusRptGrp>iRecStatusGroup)
						{  
							StatusUserName = sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("<td>")+4,sOutputXMLStatusGroup.indexOf("</td>")); 
							sOutputXMLStatusGroup = sOutputXMLStatusGroup.substring(sOutputXMLStatusGroup.indexOf("</td>")+5);
							++iRecStatusGroup;
						}
					}*/
				}
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//Consolidated Report
			try
			{
				int iRecConsolGroup=0;
				for(i=0;i<sConsolRptGrps.length;i++)
				{
					sConsolRptGrp=sConsolRptGrps[i];
					String queryConsolGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sConsolRptGrp+"'";
					String	sInputXMLConsolGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryConsolGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLConsolGroup= WFCallBroker.execute(sInputXMLConsolGroup,sJtsIp,iJtsPort,1);
					countConsolRptGrp+= Integer.parseInt(sOutputXMLConsolGroup.substring(sOutputXMLConsolGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLConsolGroup.indexOf("</TotalRetrieved>")));
					/*
					if(countConsolRptGrp!=0)
					{
						sOutputXMLConsolGroup = sOutputXMLConsolGroup.substring(sOutputXMLConsolGroup.indexOf("<tr>"),sOutputXMLConsolGroup.indexOf("</Records>"));
						while(countConsolRptGrp>iRecConsolGroup)
						{  
							ConsolUserName = sOutputXMLConsolGroup.substring(sOutputXMLConsolGroup.indexOf("<td>")+4,sOutputXMLConsolGroup.indexOf("</td>")); 
							sOutputXMLConsolGroup = sOutputXMLConsolGroup.substring(sOutputXMLConsolGroup.indexOf("</td>")+5);
							++iRecConsolGroup;
						}
					}*/
				}
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			//Team Leader
			try
			{
				int iRecTeamLeadGroup=0;
				for(i=0;i<sTeamLeadRptGrps.length;i++)
				{
					sTeamLeadRptGrp=sTeamLeadRptGrps[i];
					String queryTeamLeadGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sTeamLeadRptGrp+"'";
					String	sInputXMLTeamLeadGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryTeamLeadGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLTeamLeadGroup= WFCallBroker.execute(sInputXMLTeamLeadGroup,sJtsIp,iJtsPort,1);
					countTeamLeadRptGrp+= Integer.parseInt(sOutputXMLTeamLeadGroup.substring(sOutputXMLTeamLeadGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLTeamLeadGroup.indexOf("</TotalRetrieved>")));
					
					/*
					if(countTeamLeadRptGrp!=0)
					{
						sOutputXMLTeamLeadGroup = sOutputXMLTeamLeadGroup.substring(sOutputXMLTeamLeadGroup.indexOf("<tr>"),sOutputXMLTeamLeadGroup.indexOf("</Records>"));
						while(countTeamLeadRptGrp>iRecTeamLeadGroup)
						{  
							TeamLeadUserName = sOutputXMLTeamLeadGroup.substring(sOutputXMLTeamLeadGroup.indexOf("<td>")+4,sOutputXMLTeamLeadGroup.indexOf("</td>")); 
							sOutputXMLTeamLeadGroup = sOutputXMLTeamLeadGroup.substring(sOutputXMLTeamLeadGroup.indexOf("</td>")+5);
							++iRecTeamLeadGroup;
						}
					}*/
				}	
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			try
			{
				int iRecBranchRetGroup=0;
				for(i=0;i<sBranchRetRptGrps.length;i++)
				{
					sBranchRetRptGrp=sBranchRetRptGrps[i];
					String queryBranchRetGroup = "SELECT u.USERNAME FROM PDBUSER u,PDBGROUPMEMBER gm,PDBGROUP g WHERE u.USERINDEX=gm.USERINDEX AND g.GROUPINDEX=gm.GROUPINDEX AND u.USERINDEX="+userindex+" AND g.GROUPNAME='"+sBranchRetRptGrp+"'";
					String	sInputXMLBranchRetGroup="<?xml version=\"1.0\"?><APSelect_Input><Option>APSelect</Option><Query>" + queryBranchRetGroup +"</Query><EngineName>"+ sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelect_Input>";
					String sOutputXMLBranchRetGroup= WFCallBroker.execute(sInputXMLBranchRetGroup,sJtsIp,iJtsPort,1);
					countBranchRetRptGrp+= Integer.parseInt(sOutputXMLBranchRetGroup.substring(sOutputXMLBranchRetGroup.indexOf("<TotalRetrieved>")+ 16,sOutputXMLBranchRetGroup.indexOf("</TotalRetrieved>")));
				
					/*if(countBranchRetRptGrp!=0)
					{
						sOutputXMLBranchRetGroup = sOutputXMLBranchRetGroup.substring(sOutputXMLBranchRetGroup.indexOf("<tr>"),sOutputXMLBranchRetGroup.indexOf("</Records>"));
						while(countBranchRetRptGrp>iRecBranchRetGroup)
						{  
							BranchRetUserName = sOutputXMLBranchRetGroup.substring(sOutputXMLBranchRetGroup.indexOf("<td>")+4,sOutputXMLBranchRetGroup.indexOf("</td>")); 
							sOutputXMLBranchRetGroup = sOutputXMLBranchRetGroup.substring(sOutputXMLBranchRetGroup.indexOf("</td>")+5);
							++iRecBranchRetGroup;
						}
					}*/
				}	
			}
			catch(Exception e)
			{
				out.print("Error : "+e.getMessage());
			}
			
			
		
		
		
			if(countVolumeRptGrp>0)
			{
				%><tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/DSRREPORTSCARDS/BRVolumeReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>DebitCard Volume Report</li></font></a></td></tr>
			</tr><%
			}
			if (countDeniedRptGrp>0)
			{
				%>
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/REPORTSDENIED/BRDeniedVolumeReportDSR.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>DebitCard Denied Report</li></font></a></td></tr>
			</tr><%
			}
			if (countCompletRptGrp>0)
			{
				%>
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/CardsCompletionReport/CompletionVolumeReportDSR.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>DebitCard Completion Report</li></font></a></td></tr>
			</tr><%
			}
			if (countODCRptGrp>0)
			{
				%>
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/OdcReports/OdcReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>ODC Requests</li></font></a></td></tr>
			</tr><%
			}
			if (countAgntRptGrp>0)
			{
				%>
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/AGENTREPORTS/AgentReportDSR.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>Agent Wise Report</li></font></a></td></tr>
			</tr><%
			}
			if (countStatusRptGrp>0)
			{
				%>	
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/CardSummaryReport/DebitCardSummaryReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>DebitCards Status Report</li></font></a></td></tr>
			</tr><%
			}
			if (countConsolRptGrp>0)
			{
				%>	
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/ConsolidatedReport/DSRConsolidatedReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>Consolidated Report</li></font></a></td></tr>
			</tr><%
			}
			if (countTeamLeadRptGrp>0)
			{
				%>	
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/DSRREPORTSCARDS/TeamLeaderReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>TeamLeader Report</li></font></a></td></tr>
			</tr><%
			}
			if (countBranchRetRptGrp>0)
			{
				%>
			<tr><td width="50%" class="EWLabel" >
				<a target='_blank' STYLE="{text-decoration: none}; {cursor:hand} " onclick=window.open('/webdesktop/CustomForms/RAKBANK/DSRREPORTSCARDS/BranchReturnReport.jsp',this.target,'resizable=yes,scrollbars=yes,width='+window.screen.availWidth+',height='+window.screen.availHeight+',left=0,top=0');		><font color='green'><li>Branch Returned Report</li></font></a></td></tr>
			</tr><%
			}%>
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