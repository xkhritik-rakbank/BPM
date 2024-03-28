<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank RAO
//Module                     : Request-Initiation 
//File Name					 : SaveHistory.jsp
//Author                     : Ankit 
// Date written (DD/MM/YYYY) : 31-10-2017
//Description                : File to save data in history table on the basis of category and subcategory
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../OECD_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
	WriteLog("Inside SaveException.jsp");
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();		
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();	
	String WSNAME="" ,WINAME="",WIDATA="",user_name="",checklistData="",entrydatetime="";
	
	String mainCodeValue="";
	String subXML="";
	String sInputXML="";
	String sOutputXML="";
	String mainCodeData="";
	String Query="";
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	Date date = new Date();
	user_name = customSession.getUserName();
	user_name = user_name.trim();
	try
	{
		WINAME=request.getParameter("WINAME");
		WriteLog("WINAME"+WINAME);
		WSNAME=request.getParameter("WSNAME");
		WriteLog("WSNAME"+WSNAME);
		checklistData=request.getParameter("checklistData");
		WSNAME = WSNAME.trim();
		WriteLog("Inside RAO_SaveException::"+WSNAME);
		
		if(WSNAME.trim().equalsIgnoreCase("Control")||WSNAME.trim().equalsIgnoreCase("OPS_Checker"))
		{
				   WriteLog("checklistData "+checklistData);
					if(!checklistData.equals(""))
					{					
						String[] updatedExcps=checklistData.split("#");
						for (int i=0;i<updatedExcps.length;i++)
						{
							String[] codeArr=updatedExcps[i].split("~");
							sInputXML = "<?xml version=\"1.0\"?>" +
								"<APInsert_Input>" +
									"<Option>APInsert</Option>" +
									"<TableName>USR_0_OECD_EXCEPTION_HISTORY</TableName>" +
									"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
									"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2].replace("CB_WC","CB-WC")+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
									"<EngineName>" + sCabName + "</EngineName>" +
									"<SessionId>" + sSessionId + "</SessionId>" +
								"</APInsert_Input>";
								WriteLog("Exception Insert Input: "+sInputXML);
								sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
								WriteLog("Exception Insert OutPut:: "+sOutputXML);
						}
					}	
		}
	}
	catch(Exception e)
	{
		out.clear();
		out.println("-1");
		WriteLog("\nException while inserting in Exception history table :"+e);
		
	}
%>