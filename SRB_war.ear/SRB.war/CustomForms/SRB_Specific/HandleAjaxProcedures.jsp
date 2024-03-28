<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../SRB_Specific/Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>


<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%	
//WriteLog("In handle ajax procedures");
//String reqType = request.getParameter("reqType");
String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );    
String reqType = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
if (reqType != null) {reqType=reqType.replace("'","''");}
//String WorkitemName = request.getParameter("wi_name");
String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );    
String WorkitemName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
if (WorkitemName != null) {WorkitemName=WorkitemName.replace("'","''");}

	
out.clear();

if (reqType.equals("SendSMS"))
{
	//String wsname = request.getParameter("wsname");
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wsname"), 1000, true) );    
	String wsname = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	if (wsname != null) {wsname=wsname.replace("'","''");}
	//String decision = request.getParameter("decision");
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("decision"), 1000, true) );    
	String decision = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	if (decision != null) {decision=decision.replace("'","''");}
	//String processname = request.getParameter("processname");
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("processname"), 1000, true) );    
	String processname = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	if (processname != null) {processname=processname.replace("'","''");}
	WriteLog("\nSendSMS wsname: "+wsname);
	WriteLog("\nsSendSMS decision: "+decision);
	WriteLog("\nsSendSMS processname"+processname);
	
	String sInputXML="<?xml version=\"1.0\"?>" +                                                           
		"<APProcedure2_Input>" +
		"<Option>APProcedure2</Option>" +
		"<ProcName>"+"NG_SRB_CUST_SMS_PROC"+"</ProcName>"+
		"<Params>"+"'"+wsname+"','"+WorkitemName+"','"+decision+"','"+processname+"'"+"</Params>" +
		"<NoOfCols>1</NoOfCols>" +
		"<SessionID>"+customSession.getDMSSessionId()+"</SessionID>" +
		"<EngineName>"+customSession.getEngineName()+"</EngineName>" +
		"</APProcedure2_Input>";

	WriteLog("\nsInputXML of SendSMS: "+sInputXML);
	
	String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
	WriteLog("\nsOutputXML of SendSMS: "+sOutputXML);
	
	if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
	{
		sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>") + 9, sOutputXML.indexOf("</Results>"));
		sOutputXML = sOutputXML.replace(".", "");
		WriteLog("\n After replacement: Output xml : sOutputXML"+sOutputXML);
		out.print(sOutputXML);
	}
	else
	{
		out.print("Error");
	}	
}		
//added by shamily to fetch subcat code from table 
else if (reqType.equals("fetchSubCatCode"))
{
	String table_name = "USR_0_SRB_SUBCATEGORY";
	String query = "" ;
	String outputXML ="";
	String InputXml = "";
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String sCabName=customSession.getEngineName();	
	String sessionID = customSession.getDMSSessionId();
	//String SubCategoryName = request.getParameter("SubCategoryName");
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("SubCategoryName"), 1000, true) );    
	String SubCategoryName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	if (SubCategoryName != null) {SubCategoryName=SubCategoryName.replace("'","''");}
	String params = "";
	query = "select Application_formCode from "+table_name+" with(nolock) WHERE SubCategoryName=:SubCategoryName" ;
	params = "SubCategoryName=="+SubCategoryName;
	outputXML ="";
	
	
	 InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	WriteLog( "InputXml Fetch Application_formCode----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog( "\noutputXML Fetch sol id----"+outputXML);

	String Valid = "";
	if(outputXML.indexOf("<Application_formCode>")>-1)
	{
		Valid=outputXML.substring(outputXML.indexOf("<Application_formCode>")+"<Application_formCode>".length(),outputXML.indexOf("</Application_formCode>"));
	}

	out.clear();
	out.println(Valid);
}	
// added by shamily to fetch ops maker remarks
else if (reqType.equals("opsmaker_remarks"))
{
	String table_name = "USR_0_SRB_WIHISTORY";
	String query = "" ;
	String outputXML ="";
	String InputXml = "";
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String sCabName=customSession.getEngineName();	
	String sessionID = customSession.getDMSSessionId();
	//String SubCategoryName = request.getParameter("SubCategoryName");
	//String ws_name = request.getParameter("ws_name");
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ws_name"), 1000, true) );    
	String ws_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	if (ws_name != null) {ws_name=ws_name.replace("'","''");}
	String params = "";
	query = "select remarks  from "+table_name+" with(nolock) WHERE winame=:WorkitemName and wsname=:ws_name order by actiondatetime desc" ;
	params = "WorkitemName=="+WorkitemName+"~~"+"ws_name==Q2";
	outputXML ="";
	
	
	 InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	WriteLog( "InputXml Fetch ops maker remarks----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog( "\noutputXML Fetch ops maker remarks---"+outputXML);

	String Valid = "";
	if(outputXML.indexOf("<remarks>")>-1)
	{
		Valid=outputXML.substring(outputXML.indexOf("<remarks>")+"<remarks>".length(),outputXML.indexOf("</remarks>"));
	}

	out.clear();
	out.println(Valid);
}
//opsmaker reject and remarks point 58 drop 2
else if (reqType.equals("GetOpsRejectRemarks"))
{
	WFCustomXmlResponse xmlParserData=null;
	WFCustomXmlList objWorkList=null;	
	String subXML="";
	
	HashMap<String,String> RejectReasonsMap = new HashMap<String, String>();
	String query1="select item_code,Item_Desc from USR_0_SRB_Error_Desc_Master with(nolock) where isactive=:isactive order by id asc";
	String 	params = "isactive==Y";
	
	String strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
	
	
	String strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
	//WriteLog("outputXML exceptions-->"+strOutputXML);
	
	xmlParserData=new WFCustomXmlResponse();
	xmlParserData.setXmlString((strOutputXML));
	String mainCodeValue = xmlParserData.getVal("MainCode");
	
	int records=0;
	records=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));

	if(mainCodeValue.equals("0"))
	{
		objWorkList = xmlParserData.createList("Records","Record"); 
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			RejectReasonsMap.put(objWorkList.getVal("item_code"),objWorkList.getVal("Item_Desc"));	
		}			
	}
	
	String strQuery = "Select top 1 remarks,rejectreasons from usr_0_srb_wihistory where actual_wsname =:actual_wsname and winame=:winame order by entrydatetime desc";
	 params = "actual_wsname==OPS Maker~~winame=="+WorkitemName+"";
	String sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";

	//WriteLog("\nsInputXML: GetOpsRejectRemarks: "+sInputXML);
	
	String sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
	//WriteLog("\nsOutputXML: GetOpsRejectRemarks : "+sOutputXML);
	String 	rejectReasonsinRow="";		
	String remarks = "";
	String rejectReasons="";

	if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
	{
					
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
		rejectReasons = sOutputXML.substring(sOutputXML.indexOf("<rejectreasons>") + 15, sOutputXML.indexOf("</rejectreasons>"));
		WriteLog("Reject reason maker ="+rejectReasons);
		remarks =  sOutputXML.substring(sOutputXML.indexOf("<remarks>") + 9, sOutputXML.indexOf("</remarks>"));
		String strReasons[] = rejectReasons.split("#");
		
		for(int count=0;count<strReasons.length;count++)
		{
			String desc=strReasons[count].split(":")[0];
			if(count==0)
			rejectReasonsinRow=(count+1)+". "+RejectReasonsMap.get(strReasons[count]);
			else
			rejectReasonsinRow+="<br>"+(count+1)+". "+RejectReasonsMap.get(strReasons[count]);						
			//WriteLog("rejectReasonsinRow---"+rejectReasonsinRow);
		}
		}
		
		
		String value=remarks+"~"+rejectReasonsinRow+"~"+rejectReasons;
		out.print(value);
		//WriteLog("value------"+value);
		//WriteLog("Reject Reason after value--"+rejectReasons);
		
		
	}
	else
	{
		out.print("Error");
	}	
}

	//handled by shamily for fetching of decision on the basis of ws name and route category start

else if (reqType.equals("fetchdecision") )
{
								
							String params = "";
							String returnValues = "";
							//String WSNAME = request.getParameter("WSNAME");
							String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );    
							String WSNAME = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
							//String ROUTECATEGORY = request.getParameter("ROUTECATEGORY");
							String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ROUTECATEGORY"), 1000, true) );    
							String ROUTECATEGORY = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
							//WriteLog("ROUTECATEGORY  shamily-->"+ROUTECATEGORY);		
							//WriteLog("WSNAME  shamily-->"+WSNAME);		
							String Query="select DECISION from USR_0_SRB_DECISION_MASTER WHERE WORKSTEP_NAME=:WORKSTEP_NAME and ROUTECATEGORY =:ROUTE_CATEGORY and isActive='Y'";
							
							params = "WORKSTEP_NAME=="+WSNAME+"~~"+"ROUTE_CATEGORY=="+ROUTECATEGORY;
							
							//WriteLog("params  shamily-->"+params);	
							String DECISION="";	
							
							String  inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";	
									
							//WriteLog("Query For Workstep Input-->"+inputData);		
							String outputData = WFCustomCallBroker.execute(inputData, customSession.getJtsIp(), customSession.getJtsPort(), 1);
							//WriteLog("Query For Workstep Output-->"+outputData);
							WFCustomXmlResponse xmlParserData=null;
							WFCustomXmlList objWorkList=null;
							xmlParserData=new WFCustomXmlResponse();
							xmlParserData.setXmlString((outputData));
							String maincodeDecision = xmlParserData.getVal("MainCode");
							int records=0;

							int recordcountDecision = Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
							if(maincodeDecision.equals("0"))
							{	
								objWorkList = xmlParserData.createList("Records","Record"); 
								for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
									{ 
										 returnValues = returnValues + objWorkList.getVal("DECISION")  + ",";	
									}
									returnValues =  returnValues.substring(0,returnValues.length()-1);	
									out.print(returnValues);
							} 
							
			
		else
		{
			out.print("Error");
		}

}

//added to get isSignature verification required value from subcategory table added by Angad on 19032018
else if (reqType.equals("getSignatureVerifyReq"))
{
	String table_name = "USR_0_SRB_SUBCATEGORY";
	String query = "" ;
	String outputXML ="";
	String InputXml = "";
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String sCabName=customSession.getEngineName();	
	String sessionID = customSession.getDMSSessionId();
	//String ServiceRequestCode = request.getParameter("ServiceRequestCode");
	String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ServiceRequestCode"), 1000, true) );    
	String ServiceRequestCode = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
	if (ServiceRequestCode != null) {ServiceRequestCode=ServiceRequestCode.replace("'","''");}
	String params = "";
	query = "select isSignVerifyAtOPSMand from "+table_name+" with(nolock) WHERE Application_FormCode=:Application_FormCode" ;
	params = "Application_FormCode=="+ServiceRequestCode;
	outputXML ="";
	
	
	 InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	WriteLog( "InputXml Fetch isSignVerifyAtOPSMand----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog( "\noutputXML Fetch isSignVerifyAtOPSMand----"+outputXML);

	String Valid = "";
	if(outputXML.indexOf("<isSignVerifyAtOPSMand>")>-1)
	{
		Valid=outputXML.substring(outputXML.indexOf("<isSignVerifyAtOPSMand>")+"<isSignVerifyAtOPSMand>".length(),outputXML.indexOf("</isSignVerifyAtOPSMand>"));
	}

	out.clear();
	out.println(Valid);
}
	//handled by shamily for fetching of decision on the basis of ws name and route category end

	
%>	