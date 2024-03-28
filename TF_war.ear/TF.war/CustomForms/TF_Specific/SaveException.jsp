<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank TF
//Module                     : Request-Initiation 
//File Name					 : SaveException.jsp
//Author                     : Ankit,Modified by Sivakumar P 
// Date written (DD/MM/YYYY) : 31-10-2017
//Description                : File to save data in exception history table 
//---------------------------------------------------------------------------------------------------->
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TF_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%

	WriteLog("Inside save exception.jsp");
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
		
		String URLDecoderWINAME=URLDecoder.decode(request.getParameter("WINAME"));
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME, 1000, true) );
			String URLDecoderWINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		
		WINAME=URLDecoderWINAME_Esapi.replace("&amp;","&");
		if (WINAME != null) {WINAME=WINAME.replace("'","''");}		
		WriteLog("WINAME"+WINAME);
		
		String URLDecoderWSNAME=URLDecoder.decode(request.getParameter("WSNAME"));
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWSNAME, 1000, true) );
			String URLDecoderWSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
		
		WSNAME=URLDecoderWSNAME_Esapi.replace("&amp;","&");
		if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}	
		WriteLog("WSNAME"+WSNAME);	

		String URLDecoderchecklistData=URLDecoder.decode(request.getParameter("checklistData"));
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderchecklistData, 1000, true) );
			String URLDecoderchecklistData_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
		
		checklistData=URLDecoderchecklistData_Esapi.replace("&amp;","&");
		if (checklistData != null) {checklistData=checklistData.replace("'","''");}
		WriteLog("checklistData"+checklistData);
		WSNAME = WSNAME.trim();
		WriteLog("Inside TF_SaveException::"+WSNAME);
		
		if (!WSNAME.trim().equalsIgnoreCase("Error"))
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
									"<TableName>USR_0_TF_EXCEPTION_HISTORY</TableName>" +
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