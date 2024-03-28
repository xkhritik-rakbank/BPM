<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="./Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
	logger.info("SaveException.jsp");
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
	String ResData = "";
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	Date date = new Date();
	user_name = customSession.getUserName();
	user_name = user_name.trim();
	try
	{
		WINAME=request.getParameter("WINAME");
		if (WINAME != null) {WINAME=WINAME.replace("'","");}
		logger.info("WINAME"+WINAME);
		WSNAME=request.getParameter("WSNAME");
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
		logger.info("WSNAME"+WSNAME);
		checklistData=request.getParameter("checklistData");
		if (checklistData != null) {checklistData=checklistData.replace("'","");}
		logger.info("Checklist Data 1"+checklistData);
		WSNAME = WSNAME.trim();
		logger.info("Inside SaveException.jsp"+WSNAME);
		
		// Start - removing # from start and end to string 
		if (!checklistData.equalsIgnoreCase(""))
        {
            String Firstletter = checklistData.substring(0,1);
            if (Firstletter.equalsIgnoreCase("#"))
            {
                checklistData=checklistData.substring(1, checklistData.length());
            }
        }
        if (!checklistData.equalsIgnoreCase(""))
        {
            String Lastletter = checklistData.substring(checklistData.length()-1,checklistData.length());
            if (Lastletter.equalsIgnoreCase("#"))
            {
                checklistData=checklistData.substring(0, checklistData.length()-1);
            }
        }
		logger.info("Checklist Data final: "+checklistData);
		// end - removing # from start and end to string 
		
		if(!checklistData.equals(""))
		{					
			String[] updatedExcps=checklistData.split("#");
			for (int i=0;i<updatedExcps.length;i++)
			{
				//logger.info("in For");
				String[] codeArr=updatedExcps[i].split("~");
				
				if(codeArr[1].split("-")[2].equalsIgnoreCase(WSNAME.trim()))
				{
					sInputXML = "<?xml version=\"1.0\"?>" +
					"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>USR_0_TWC_EXCEPTION_HISTORY</TableName>" +
						"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
						"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2].replace("CB_WC","CB-WC")+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
						"<EngineName>" + sCabName + "</EngineName>" +
						"<SessionId>" + sSessionId + "</SessionId>" +
					"</APInsert_Input>";
					logger.info("Exception Insert for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" Input: "+sInputXML);
					sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					logger.info("Exception Insert for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" OutPut: "+sOutputXML);
				}
			}
			ResData = "1";
		}	
		ResData = "0";
	}
	catch(Exception e)
	{
		out.clear();
		out.println("-1");
		ResData = "-1";
		logger.info("\nException while Inserting in Exception history table for WINAME: "+WINAME+" , WSNAME: "+WSNAME+" :"+e);
	}
	out.clear();
	out.println(ResData);
%>