<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank SRM
//Module                     : Request-Initiation 
//File Name					 : tempWI.jsp
//Author                     : Aishwarya Gupta
// Date written (DD/MM/YYYY) : 25-July-2014
//Description                : Custom server side Validations. Any server side validation can be 
							   added in the file later for subsequent requests
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>

<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>


<%

WriteLog("tempWI jsp starts...");
String userDbId=null;
String sServerIPVal=null;
int   iServerPortVal;
String strVolumeId=null;
String strCabinetName=null;

userDbId=wfsession.getSessionId();
sServerIPVal=wfsession.getJtsIp();
iServerPortVal=wfsession.getJtsPort();
strVolumeId=wfsession.getVolumeId();
strCabinetName=wfsession.getEngineName();

String tmpWI=null;
try
{
tmpWI=getTempWI(userDbId,sServerIPVal,iServerPortVal,strVolumeId,strCabinetName);
}
catch(Exception e)
{
	WriteLog("Exception : "+e);
}
WriteLog("tmpWI : "+tmpWI);


out.clear();
out.println("0000"+"~"+tmpWI+"~"+"");	
%>
<%!
public String getTempWI(String userDbId,String sServerIPVal,int iServerPortVal,String strVolumeId,String strCabinetName)  throws IOException
	{
		WriteLog("getTempWI called....");
		String tempWI=null;
		int startIndex;
		int endIndex;
		String params="";
		/*String sQuery = "select convert(varchar,getdate(),112)+RIGHT(REPLICATE('0', 6) + cast(next value for dbo.usr_0_srm_TEMP_WI as varchar),6)";
		String strInputXML = "<?xml version=\"1.0\"?>" +
		"<APSelect_Input>" +
		"<Option>APSelect</Option>" +
		"<Query>" + sQuery + "</Query>" +
		"<EngineName>" + strCabinetName + "</EngineName>" +
		"<SessionId>" + userDbId + "</SessionId>" +
		"</APSelect_Input>";*/
		
		String sQuery = "select convert(varchar,getdate(),112)+RIGHT(REPLICATE(:ZERO, 6) + cast(next value for dbo.usr_0_srm_TEMP_WI as varchar),6) as td";
		params="ZERO==0";
		String strInputXML = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ sQuery + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ strCabinetName+ "</EngineName>"+
		"<SessionId>"+ userDbId+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
		String strOutputXML = null;
		try {
			strOutputXML = WFCallBroker.execute(strInputXML,sServerIPVal,iServerPortVal,Integer.parseInt(strVolumeId));
		}catch (Exception e) {
			WriteLog("Exception in WFCallBroker.execute call inside getTempWI function :"+e);
			e.printStackTrace();
		}
			
		if(strOutputXML.equals(""))
		{
			WriteLog("Network Error !! Could not connect to server");
		}
		else
		{
			WriteLog("strOutputXML : "+strOutputXML);
			startIndex=strOutputXML.indexOf("<td>",4);	
			endIndex=strOutputXML.indexOf("</td>");	
			tempWI=strOutputXML.substring(startIndex+4,endIndex);
			WriteLog("tempWI : "+tempWI);
		}
		WriteLog("getTempWI ends......");
		return tempWI;
	}
%>

	