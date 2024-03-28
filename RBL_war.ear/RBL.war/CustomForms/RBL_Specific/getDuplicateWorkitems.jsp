<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : RBL          
//File Name					 : getDuplicateWorkitems.jsp         
//Author                     : Nikita Singhal
// Date written (DD/MM/YYYY) : 07-Nov-2017
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*"%>
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

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );
			String WI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("CIF_Id"), 1000, true) );
			String CIF_Id_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("Dec_AU_Analyst"), 1000, true) );
			String Dec_AU_Analyst_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("TLNumber"), 1000, true) );
			String TLNumber_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
    String outputData="";
	String inputData="";
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlList objWorkList=null;
	try{
		 logger.info("\nInside RBL GetDuplicateWorkitem.jsp\n");
		String wi_name = WI_NAME_Esapi;
		String WSNAME = WSNAME_Esapi;	
		String CIF_Id=CIF_Id_Esapi;
		if (CIF_Id != null) {CIF_Id=CIF_Id.replace("'","''");}
		String Dec_AU_Analyst=Dec_AU_Analyst_Esapi;
		String strTLNumber=TLNumber_Esapi;
		if (strTLNumber != null) {strTLNumber=strTLNumber.replace("'","''");}
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String IntroductionDateTime = "";
		String intoducedBy = "";
		String SOLID = "";
		String Query="";
		String WI_NAME="";
		String params = "";
		String temp_table="<table id='duplicateWorkItemID' width='100%' border=1><TBODY><tr width=100% class='EWLabelRB2' bgcolor= '#990033'><input type='text' name='Header' readOnly size='24' style='display:none' value='Service Request Module Details'><td colspan=4 align=center class='EWLabelRB2'><font color='white' size='4'>Duplicate Work Items</font></td></tr>";
		
		temp_table=temp_table+"<tr class='EWNormalGreenGeneral1'><th><b>Work-item Number</b></th><th><b>Initiated Date</b></th><th><b>Initiated By</b></th><th><b>SOL ID</b></th></tr>";
		
		logger.info("\nInside RBL GetDuplicateWorkitem for wi_name "+wi_name);
		logger.info("\nWSNAME "+WSNAME);
		logger.info("\n Dec_AU_Analyst "+Dec_AU_Analyst);
		
		if(WSNAME.equals("AU_Officer") || WSNAME.equals("AU_Analyst") || WSNAME.equals("AU_Doc_Checker") || WSNAME.equals("AU_Data_Entry") || WSNAME.equals("AU_Manager"))
		{
			Query="SELECT DISTINCT A.WI_NAME,B.IntroductionDateTime as IntroductionDateAndTime ,B.introducedBy as intoducedBy,A.Sol_Id as SOLID FROM RB_RBL_EXTTABLE A,QUEUEVIEW B WHERE A.WI_NAME=B.processinstanceid AND ((B.activityname='Exit' AND datediff(DAY,B.entrydatetime,getdate())<60) OR (B.activityname='Reject' AND datediff(DAY,B.entrydatetime,getdate())<60) OR (B.activityname!='Exit' AND B.activityname!='Reject')) AND A.WI_NAME!=:WI_NAME AND (A.TLNumber='"+strTLNumber+"' OR A.CIF_Id='"+CIF_Id+"')";
		
		}
		else
			Query="SELECT DUPLICATEWI_NAME AS WI_NAME ,IntroductionDateAndTime,intoducedBy,SOLID from USR_0_RBL_DUPLICATEWORKITEMS WITH (nolock) where WI_NAME=:WI_NAME";

		//inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
		params = "WI_NAME=="+wi_name;
		inputData = "<?xml version='1.0'?>"+
		"<APSelectWithNamedParam_Input>"+
		"<Option>APSelectWithNamedParam</Option>"+
		"<Query>"+ Query + "</Query>"+
		"<Params>"+ params + "</Params>"+
		"<EngineName>"+ customSession.getEngineName()+ "</EngineName>"+
		"<SessionId>"+ customSession.getDMSSessionId()+ "</SessionId>"+
		"</APSelectWithNamedParam_Input>";
				
		logger.info("Query For GetDuplicateWorkitem Input for WINAME "+wi_name+" -->"+inputData);		
		outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
		logger.info("GetDuplicateWorkitem Output for WINAME "+wi_name+" -->"+outputData);
		WFCustomXmlResponseData=new WFCustomXmlResponse();
		WFCustomXmlResponseData.setXmlString((outputData));
		String maincode = WFCustomXmlResponseData.getVal("MainCode");	
		int recordcount = Integer.parseInt(WFCustomXmlResponseData.getVal("TotalRetrieved"));
		if(maincode.equals("0") && recordcount>0)
		{	
			objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{ 
					WI_NAME = objWorkList.getVal("WI_NAME");
					IntroductionDateTime = objWorkList.getVal("IntroductionDateAndTime");
					intoducedBy = objWorkList.getVal("intoducedBy");
					SOLID = objWorkList.getVal("SOLID");
					//logger.info("WI_NAME Is-->"+WI_NAME);
					//logger.info("IntroducedAt	-->"+IntroductionDateTime);
					//logger.info("intoducedBy-->"+intoducedBy);
					//logger.info("SOLID-->"+SOLID);
					temp_table = temp_table + "<tr class='EWNormalGreenGeneral1'><td>"+WI_NAME+"</td><td>"+IntroductionDateTime+"</td><td>"+intoducedBy+"</td><td>"+SOLID+"</td></tr>";
				}
				temp_table=temp_table+"</TBODY></TABLE>";
				logger.info("Final Return Result "+temp_table);
				out.clear();
				//out.println(temp_table+"~"+"0");
				out.println(temp_table);
		}
		else if(maincode.equals("0") && recordcount==0)
		{
			out.clear();
			out.println("");
		}
		else
		{
			out.clear();
			out.println("-1");
		}
					
	}
	catch(Exception e)
	{
		e.printStackTrace();
		logger.info("Exception in getting duplicate workitem list "+e);
		out.clear();
		out.println("-1");
	}
%>