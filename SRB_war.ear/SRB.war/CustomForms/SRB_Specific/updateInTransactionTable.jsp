<!----------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Data Update
//File Name					 : updateInTransactionTable.jsp          
//Author                     : Angad Shah
// Date written (DD/MM/YYYY) : 14/05/2018
//Description                : File to update data in SRB transaction table 
//----------------------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------------------
Revision 	Date 			Author 			Description
0.90		14/05/2018		Angad Shah	Initial Draft
//------------------------------------------------------------------------------------------------------------------>

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();		
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String finalUpdateStatus="";
		WFCustomXmlResponse xmlParserData=null;
		String sInputXML="";
		String sOutputXML="";
		String WINAME=request.getParameter("WINAME");
		if (WINAME != null) {WINAME=WINAME.replace("'","''");}
		String RequestType=request.getParameter("RequestType");
		
		if (RequestType.equals("UpdateLoanIslamicConventional"))
		{
			String SRCode=request.getParameter("SRCode");
			String IslamicConventionVal=request.getParameter("IslamicConvention");
			if (IslamicConventionVal != null) {IslamicConventionVal=IslamicConventionVal.replace("'","''");}
			String colname="IslamicOrConventional";
			String columnsVal="'"+IslamicConventionVal+"'" ;
			try{
				sInputXML = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>USR_0_SRB_TR_"+SRCode+"</TableName>" +
					"<ColName>" + colname + "</ColName>" +
					"<Values>" + columnsVal + "</Values>" +
					"<WhereClause>" + "WI_NAME='"+WINAME+"'" + "</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";
				WriteLog("Updating IslamicConvention status in USR_0_SRB_TR_"+SRCode+" for WINAME "+WINAME+" InputXml: "+sInputXML);
				for (int i=0; i<3; i++)
				{
					sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog("Updating IslamicConvention status in USR_0_SRB_TR_"+SRCode+" for WINAME "+WINAME+" sOutputXML: "+sOutputXML);
					xmlParserData=new WFCustomXmlResponse();
					xmlParserData.setXmlString(sOutputXML);
					String mainCode = xmlParserData.getVal("MainCode");
					if(mainCode.equals("0")){
						WriteLog("Update IslamicConvention status in USR_0_SRB_TR_"+SRCode+" successfull for WINAME:"+WINAME);
						out.clear();
						finalUpdateStatus="0";
						out.println(finalUpdateStatus);
						break;
					}
					else{
						WriteLog("Update IslamicConvention status in USR_0_SRB_TR_"+SRCode+" fail for WINAME:"+WINAME);
						out.clear();
						finalUpdateStatus="-1";
						out.println(finalUpdateStatus);
					}
				}
			}
			catch(Exception e)
			{
				WriteLog("Exception IslamicConvention status in USR_0_SRB_TR_"+SRCode+" update for WINAME:"+WINAME);
				out.clear();
				finalUpdateStatus="-1";
				out.println(finalUpdateStatus);				
			}
		}
%>