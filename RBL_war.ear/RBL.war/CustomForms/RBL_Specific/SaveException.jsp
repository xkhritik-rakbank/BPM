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
<%@ include file="../RBL_Specific/Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("checklistData"), 1000, true) );
	String checklistData_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	checklistData_Esapi = checklistData_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
	logger.info("Inside save exception jsp, checklistData_Esapi final: "+checklistData_Esapi);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
	String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
	String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
	logger.info("Inside save exception jsp");
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
		WINAME=WINAME_Esapi;
		logger.info("WINAME"+WINAME);
		WSNAME=WSNAME_Esapi;
		logger.info("WSNAME"+WSNAME);
		checklistData=checklistData_Esapi;
		WSNAME = WSNAME.trim();
		logger.info("Inside RBL_SaveException::"+WSNAME);
		logger.info("checklistData "+checklistData);
		
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
				String[] codeArr=updatedExcps[i].split("~");
				if(codeArr[1].split("-")[2].equalsIgnoreCase(WSNAME.trim()))
				{
					sInputXML = "<?xml version=\"1.0\"?>" +
						"<APInsert_Input>" +
							"<Option>APInsert</Option>" +
							"<TableName>USR_0_RBL_EXCEPTION_HISTORY</TableName>" +
							"<ColName>" + "WINAME,EXCPCODE,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
							"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2].replace("CB_WC","CB-WC")+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
							"<EngineName>" + sCabName + "</EngineName>" +
							"<SessionId>" + sSessionId + "</SessionId>" +
						"</APInsert_Input>";
						logger.info("Exception Insert Input for WINAME "+WINAME+" : "+sInputXML);
						sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						logger.info("Exception Insert OutPut for WINAME "+WINAME+" :: "+sOutputXML);
					
				}
			}
		}	
	}
	catch(Exception e)
	{
		out.clear();
		out.println("-1");
		logger.info("\nException while inserting in Exception history table :"+e);
		
	}
%>
