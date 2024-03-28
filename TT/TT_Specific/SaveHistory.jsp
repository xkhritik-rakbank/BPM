<!----------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Data Update
//File Name					 : SaveHistory.jsp          
//Author                     : Shubham Ruhela
// Date written (DD/MM/YYYY) : 2-Feb-2016
//Description                : File to save data in history table 
//----------------------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------------------
Revision 	Date 			Author 			Description
0.90		05/02/2016		Shubham Ruhela	Initial Draft
0.91		13/02/2016		Mandeep Singh	Added Auto Raise and Unraise, also added Post Cut Off Cases
0.92		16/02/2016		Ankit Arya		
0.93		01/03/2016		Mandeep Singh   Removed Auto Raising of signature mismatch exception and to be handled at UI
0.93		16/03/2016		Mandeep Singh   Updated PostCutOffCases
0.94		31/03/2016		Aishwarya Gupta History saving will be called using procedure
//------------------------------------------------------------------------------------------------------------------>

<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<%!

	//Added by anurag anand - 10 -Feb-2016
	//To update status of WorkItems
	String sJtsIp = null;
	int iJtsPort = 0;
	String sCabName=null;
	//String sSessionId = null;	//commented for issue 66		
	//StringBuilder errortrack = new StringBuilder();
	//commented below 3 lines  for issue 66
	//String WSNAME="" ,WINAME="",WIDATA="",IsDoneClicked="",rejectReasons="",checklistData="",user_name="",workitemId="1";
	//String decision="";
	//String nextWS = "";
	

	
	// Returns constructed XML for APSelectWithColumnNames
//modified for issue 66
	public String apselectXML(String query,String sSessionId,String sCabName){
		String inputXml =  "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>"
		+ query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
		
		//errortrack.append("inputXml :- "+inputXml+"</br>");
		return inputXml;
	}
	
	//modified for issue 66
	String apupdateXML(String table,String columns,String columnsValues,String whereClause,String sSessionId,String sCabName){
		//errortrack.append("table :- "+table+"</br>");
		//errortrack.append("columns :- "+columns+"</br>");
		//errortrack.append("columnsValues :- "+columnsValues+"</br>");
		//errortrack.append("whereClasue :- "+whereClause+"</br>");
		
		String xml = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>" + table + "</TableName>" +
					"<ColName>" + columns + "</ColName>" +
					"<Values>" + columnsValues + "</Values>" +
					"<WhereClause>"+ whereClause +"</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";
				
		//errortrack.append("TTUpdate_Input xml :- "+xml+"</br>");	
		return xml;
	}

	// Returns status for next workstep
	//modified for issue 66
	String getStatus(String WSNAME,String nextWS,String decision,String sSessionId,String sCabName){
	 if("RemittanceHelpDesk_Checker".equalsIgnoreCase(WSNAME) && nextWS.equals("Distribute1") && decision.equals("Exception Found"))
	{
	decision="Submit";
	}
	else if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && decision.equals("Reject"))
	{
	decision="Restricted Nationality";
	}
	 if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && nextWS.equals("Distribute1") && decision.equals("Exception Found"))
	{
	decision="Submit";
	}
	else if("Ops_Maker".equalsIgnoreCase(WSNAME))
	{
	if(decision.equals("Approval Pending in Finacle") || decision.equals("Approved in Finacle"))
	decision="Forward";
	}
	else if("Ops_Maker_DB".equalsIgnoreCase(WSNAME))
	{
	if(decision.equals("Approval Pending in Finacle") || decision.equals("Approved in Finacle"))
	decision="Forward";
	}
	
		//modified for issue 66
		String query = "select status from USR_0_TT_StatusMaster with(nolock) where currQueue = '"+
		WSNAME+"' and decision = '"+decision+"' and toQueue = '"+nextWS+"'";
			
		//errortrack.append("query :- "+query+"</br>");
			
		String inputXML = apselectXML(query,sSessionId,sCabName); //modified for issue 66
		String status = "";	
		
		/*String outputXML = execute(inputXML,sCabName);
		
		//WriteLog("Query for getStatus for queue ......."+query);
		//WriteLog("outputXML getStatus......."+outputXML);
		
		try{
			XMLParser xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputXML);
			String mainCodeValue = xmlParserData.getValueOf("MainCode");
				
		//	WriteLog("mainCodeValue getStatus......."+mainCodeValue);
			//errortrack.append("mainCodeValue :- "+mainCodeValue+"</br>");
				
			int recordcount=0;
				
			//WriteLog("recordcount getStatus......."+recordcount);
			//errortrack.append("recordcount :- "+recordcount+"</br>");
				
			recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));		
				
			// If call is successful and data exists in table
			if(mainCodeValue.equals("0") && recordcount > 0)				
				status = xmlParserData.getValueOf("status");			              			
			else
				status = "";

			//errortrack.append("status :- "+status+"</br>");
		}catch(Exception ex){
			//errortrack.append("Exeption :- "+ex.getMessage()+"</br>");
			//WriteLog("Exeption :- "+ex.getMessage());
		}*/
		return inputXML;
	}
	
//modified for issue 66
	String updateWorkitemStatus(String wi_name,String status,String workitemId,String sSessionId,String sCabName) {		
		String query = "update queuedatatable set status = '"+status+"' where processinstanceid = '"+wi_name+"' and workitemId='"+workitemId+"'" ;
		
		//errortrack.append("query updateWorkitemStatus :- "+query+"</br>");
		
		String inputXML = apupdateXML("queuedatatable","status","'"+status+"'","processinstanceid = '"+wi_name+"' and workitemId='"+workitemId+"'",sSessionId,sCabName);
		
		//errortrack.append("inputXML  updateWorkitemStatus :- "+inputXML +"</br>");
		
		return  inputXML;
		
		//errortrack.append("outputXML  updateWorkitemStatus :- "+outputXML +"</br>");
	}

	

%>

<%
	//Clear the old Error trace
	/*if(errortrack.length() >0 ){
		errortrack.delete(0,errortrack.length()-1);
	}*/

	String mainCodeValue="";
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String subXML="";
	String sInputXML="";
	String sOutputXML="";
	String mainCodeData="";
	String Query="";
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	Date date = new Date();
	String fcy_rate = "";
	String pref_rate = "";
	String bal_sufficient = "";
	String comp_req = "";
	String call_back_req = "";
	String callBackSuccess = "";
	String segment = "";
	String cust_acc_curr = "";
	String postCutOffTimetoDB = "";
	String isSignatureExcepRaised = "";
	String user_name="";  // added for issue 66
	user_name = wDSession.getM_objUserInfo().getM_strPersonalName()+" "+ wDSession.getM_objUserInfo().getM_strFamilyName();
	user_name = user_name.trim();

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WINAME_Esapi: REq"+request.getParameter("WINAME"));
			WriteLog("Integration jsp: WINAME_Esapi: "+WINAME_Esapi);
					WINAME_Esapi = WINAME_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
					
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workitemId"), 1000, true) );
			String workitemId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: workitemId: REq"+request.getParameter("workitemId"));
			WriteLog("Integration jsp: workitemId_Esapi: "+workitemId_Esapi);
			workitemId_Esapi = workitemId_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IsDoneClicked"), 1000, true) );
			String IsDoneClicked_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: IsDoneClicked: REq"+request.getParameter("IsDoneClicked"));
			WriteLog("Integration jsp: IsDoneClicked_Esapi: "+IsDoneClicked_Esapi);
			IsDoneClicked_Esapi = IsDoneClicked_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 100000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("Integration jsp: WSNAME: REq"+request.getParameter("WSNAME"));
			WriteLog("Integration jsp: WSNAME_Esapi: "+WSNAME_Esapi);
			WSNAME_Esapi = WSNAME_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WIDATA"), 100000, true) );
			String WIDATA_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("Integration jsp: WIDATA: REq"+request.getParameter("WIDATA"));
			WriteLog("Integration jsp: WIDATA_Esapi: "+WIDATA_Esapi);
			WIDATA_Esapi = WIDATA_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("checklistData"), 100000, true) );
			String checklistData_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("Integration jsp: checklistData: REq"+request.getParameter("checklistData"));
			WriteLog("Integration jsp: checklistData_Esapi: "+checklistData_Esapi);
			checklistData_Esapi = checklistData_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rejectReasons"), 100000, true) );
			String rejectReasons_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("Integration jsp: rejectReasons: REq"+request.getParameter("rejectReasons"));
			WriteLog("Integration jsp: rejectReasons_Esapi: "+rejectReasons_Esapi);
			rejectReasons_Esapi = rejectReasons_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("nextWS"), 100000, true) );
			String nextWS_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			WriteLog("Integration jsp: nextWS: REq"+request.getParameter("nextWS"));
			WriteLog("Integration jsp: nextWS_Esapi: "+nextWS_Esapi);
			nextWS_Esapi = nextWS_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
	String WSNAME="",WINAME="",WIDATA="",rejectReasons="",checklistData="";//Uncommented  for History Issue 66
	String workitemId="1",decision="",nextWS="",sSessionId="",IsDoneClicked="";//Added  for History Issue 66
	
	try{
		 // String WSNAME="" ,WINAME="",WIDATA="",rejectReasons="",checklistData="",user_name="";
		 WINAME=WINAME_Esapi;
		 workitemId=workitemId_Esapi;
		 IsDoneClicked=IsDoneClicked_Esapi;
		 WSNAME=WSNAME_Esapi;
		 WSNAME = WSNAME.trim();
		 WIDATA=WIDATA_Esapi;
		 checklistData=checklistData_Esapi;
		 rejectReasons=rejectReasons_Esapi;
		 nextWS=nextWS_Esapi;
		  if (rejectReasons.equals("NO_CHANGE"))
			rejectReasons = "";
		 
		WriteLog("-------------------------------------Save History . Jsp---------------------------------------");
		WriteLog("WINAME---------------------------------------"+WINAME);
		WriteLog("workitemId---------------------------------------"+workitemId);
		WriteLog("WSNAME---------------------------------------"+WSNAME);
		WriteLog("WIDATA---------------------------------------"+WIDATA);
		WriteLog("checklistData---------------------------------------"+checklistData);
		WriteLog("rejectReasons---------------------------------------"+rejectReasons);
		WriteLog("nextWS---------------------------------------"+nextWS);
		
		//System.out.println(dateFormat.format(date)); 
		WriteLog("Inside TT_SaveHistory");
		String colname="";
		String colvalues="'";
		String temp[]=null;
		String inputData="";
		String outputData="";
		int count2=0;			
		sCabName=wDSession.getM_objCabinetInfo().getM_strCabinetName();	
		sSessionId = wDSession.getM_objUserInfo().getM_strSessionId();		
		sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
		iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
		
		HashMap<String, String> hmap = new HashMap<String, String>();
		if(true)
		{
			String temp2[]= WIDATA.split("~");
			count2=temp2.length;
			
			String check2[]=null;			
			String hist_table="";
			String colname2="";
			String colvalues2="";
			String remarks="";
			String finaclestatus= "";

			for(int t=0;t<count2;t++)
			{
				check2=temp2[t].split("#");
				colname2=check2[0];
				if((colname2.toUpperCase().equals("wdesk:dec_CSO_Exceptions") && "CSO_Exceptions".equalsIgnoreCase(WSNAME)) || (colname2.toUpperCase().equals("wdesk:decCallBack") && "CallBack".equalsIgnoreCase(WSNAME)))
					decision="Save";
				else if(colname2.toUpperCase().equals("DECISIONROUTE") && !"RemittanceHelpDesk_Checker".equalsIgnoreCase(WSNAME) && !"RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && !"Ops_Maker".equalsIgnoreCase(WSNAME) && !"Ops_Checker".equalsIgnoreCase(WSNAME)  && !"CSO_Exceptions".equalsIgnoreCase(WSNAME) && !"CallBack".equalsIgnoreCase(WSNAME) && !"Ops_Maker_DB".equalsIgnoreCase(WSNAME) && !"Ops_Checker_DB".equalsIgnoreCase(WSNAME))
					decision=check2[1].substring(check2[1].indexOf("$")+1);
				else if(colname2.toUpperCase().equals("WDESK:REMARKS"))				
					remarks=check2[1].substring(check2[1].indexOf("$")+1);				
				else if (colname2.equals("wdesk:bal_sufficient"))			
					bal_sufficient = check2[1];
				else if (colname2.equals("wdesk:fcy_rate"))
					fcy_rate = check2[1];
				else if (colname2.equals("wdesk:pref_rate"))
					pref_rate = check2[1];
				else if (colname2.equals("wdesk:call_back_req"))
					call_back_req = check2[1];
				else if (colname2.equals("wdesk:comp_req"))
					comp_req = check2[1];
				else if (colname2.equals("wdesk:callBackSuccess"))
					callBackSuccess = check2[1];
				else if (colname2.equals("wdesk:cust_acc_curr"))
					cust_acc_curr = check2[1];
				else if (colname2.equals("wdesk:sub_segment"))
					segment = check2[1];
				else if (colname2.equals("postCutOffTimetoDB"))
					postCutOffTimetoDB = check2[1];
				else if (colname2.equals("wdesk:isSignatureExcepRaised"))
					isSignatureExcepRaised = check2[1];
				else if (colname2.equals("wdesk:payment_order_status"))
					finaclestatus = check2[1];
				
				if("RemittanceHelpDesk_Checker".equalsIgnoreCase(WSNAME) && "wdesk:dec_rem_helpdesk".equals(colname2))
					decision=check2[1];
				if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && "wdesk:dec_rem_helpdeskMaker".equals(colname2))
					decision=check2[1];
				if("Ops_Maker".equalsIgnoreCase(WSNAME) && "wdesk:dec_maker".equals(colname2))
					decision=check2[1];
				if("Ops_Checker".equalsIgnoreCase(WSNAME) && "wdesk:dec_checker".equals(colname2))
					decision=check2[1];
				if("Ops_Maker_DB".equalsIgnoreCase(WSNAME) && "wdesk:dec_maker_DB".equals(colname2))
					decision=check2[1];
				if("Ops_Checker_DB".equalsIgnoreCase(WSNAME) && "wdesk:dec_checker_DB".equals(colname2))
					decision=check2[1];
				if("CSO_Exceptions".equalsIgnoreCase(WSNAME) && "wdesk:dec_CSO_Exceptions".equals(colname2) && IsDoneClicked.equalsIgnoreCase("true"))
					decision=check2[1];
				if("CallBack".equalsIgnoreCase(WSNAME) && "wdesk:decCallBack".equals(colname2) && IsDoneClicked.equalsIgnoreCase("true"))
					decision=check2[1];

			}
			
			WriteLog("finaclestatus"+finaclestatus);
			WriteLog("comp_req call_back_req="+comp_req+" , "+call_back_req);
		
			WriteLog("decision="+decision);
			hist_table="usr_0_tt_wihistory";
	
			WriteLog("colvalues2 FromSaveHistory colvalues2="+colvalues2);
			try	{
				if("CSO_Initiate".equals(WSNAME) || "OPS_Initiate".equals(WSNAME) || ("CallBack".equalsIgnoreCase(WSNAME) && IsDoneClicked.equalsIgnoreCase("false")) || ("CSO_Exceptions".equalsIgnoreCase(WSNAME) && IsDoneClicked.equalsIgnoreCase("false")))
				{
					remarks=remarks.replaceAll("'","''");
					if("CallBack".equalsIgnoreCase(WSNAME))
						decision="Save";
					if("CSO_Exceptions".equalsIgnoreCase(WSNAME))
						decision="Save";
					else if(("Ops_Checker".equalsIgnoreCase(WSNAME) || "Ops_Checker_DB".equalsIgnoreCase(WSNAME)) && decision.equals("Send to Remittance HD"))
						decision="Exception Found";
					else if(("Ops_Checker".equalsIgnoreCase(WSNAME) || "Ops_Checker_DB".equalsIgnoreCase(WSNAME)) && nextWS.equals("Archive_Discard"))
						decision="Deleted in Finacle";
					else if("RemittanceHelpDesk_Checker".equalsIgnoreCase(WSNAME) && nextWS.equals("Distribute1"))
						decision="Exception Found";
					else if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && decision.equals("Restricted Nationality"))
						decision="Reject";
					else if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && nextWS.equals("Distribute1"))
						decision="Exception Found";
					else if(("Ops_Checker".equalsIgnoreCase(WSNAME) || "Ops_Checker_DB".equalsIgnoreCase(WSNAME)) && (nextWS.equals("Ops_maker") || nextWS.equals("Ops_maker_DB")) && decision.equals("Forward"))
						decision="Error";
					else if(("Ops_Maker".equalsIgnoreCase(WSNAME) || "Ops_Maker_DB".equalsIgnoreCase(WSNAME)) && (nextWS.equals("Ops_Checker") || nextWS.equals("Ops_Checker_DB")))
					{
						if (finaclestatus.equals("Awaiting Authorization"))
						{
							decision="Approval Pending in Finacle";
						}
						else {
							decision="Approved in Finacle";
						}
					}
					else if("Ops_Maker".equalsIgnoreCase(WSNAME)&& nextWS.equals("Archive_Discard"))
						decision="Deleted in Finacle";
					else if("Ops_Maker_DB".equalsIgnoreCase(WSNAME)&& nextWS.equals("Archive_Discard"))
						decision="Deleted in Finacle";
						
						
					
					sInputXML = "<?xml version=\"1.0\"?>" +
							"<APInsert_Input>" +
								"<Option>APInsert</Option>" +
								"<TableName>"+hist_table+"</TableName>" +
								"<ColName>" + "WINAME,ChecklistData,WSNAME,USERNAME,DECISION,ACTIONDATETIME,entrydatetime,Remarks" + "</ColName>" +
								"<Values>" + "'"+WINAME+"','"+rejectReasons+"','"+WSNAME+"','"+ wDSession.getM_objUserInfo().getM_strUserName()+"','"+decision+"','"+dateFormat.format(date)+"','"+dateFormat.format(date)+"','"+remarks+"'" + "</Values>" +
								"<EngineName>" + sCabName + "</EngineName>" +
								"<SessionId>" + sSessionId + "</SessionId>" +
							"</APInsert_Input>";
				}
				else
				{
	
					if (("Ops_Maker".equals(WSNAME) && decision.equals("Send to Remittance HD")) || ("Ops_Maker_DB".equals(WSNAME) && decision.equals("Send to Remittance HD")) || ("RemittanceHelpDesk_Maker".equals(WSNAME) && decision.equals("Send to Business")) || ("RemittanceHelpDesk_Checker".equals(WSNAME) && decision.equals("Send to Business")))
						decision = "Exception Raised";
					else if(("Ops_Checker".equalsIgnoreCase(WSNAME) || "Ops_Checker_DB".equalsIgnoreCase(WSNAME)) && decision.equals("Send to Remittance HD"))
						decision="Exception Found";
					else if(("Ops_Checker".equalsIgnoreCase(WSNAME) || "Ops_Checker_DB".equalsIgnoreCase(WSNAME)) && nextWS.equals("Archive_Discard"))
						decision="Deleted in Finacle";
					else if("RemittanceHelpDesk_Checker".equalsIgnoreCase(WSNAME) && nextWS.equals("Distribute1"))
						decision="Exception Found";
					else if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && decision.equals("Restricted Nationality"))
						decision="Reject";
					else if("RemittanceHelpDesk_Maker".equalsIgnoreCase(WSNAME) && nextWS.equals("Distribute1"))
						decision="Exception Found";
					else if(("Ops_Checker".equalsIgnoreCase(WSNAME) || "Ops_Checker_DB".equalsIgnoreCase(WSNAME)) && (nextWS.equals("Ops_maker") || nextWS.equals("Ops_maker_DB")) && decision.equals("Forward"))
						decision="Error";
					else if(("Ops_Maker".equalsIgnoreCase(WSNAME) || "Ops_Maker_DB".equalsIgnoreCase(WSNAME)) && (nextWS.equals("Ops_Checker") || nextWS.equals("Ops_Checker_DB")))
					{
						if (finaclestatus.equals("Awaiting Authorization"))
						{
							decision="Approval Pending in Finacle";
						}
						else {
							decision="Approved in Finacle";
						}
					}
					else if("Ops_Maker".equalsIgnoreCase(WSNAME)&& nextWS.equals("Archive_Discard"))
						decision="Deleted in Finacle";
					else if("Ops_Maker_DB".equalsIgnoreCase(WSNAME)&& nextWS.equals("Archive_Discard"))
						decision="Deleted in Finacle";
						
					colname2="decision~actiondatetime~remarks~username~checklistData";
					colvalues2="''"+decision+"''~getdate()~''"+remarks.replaceAll("'","''''")+"''~''"+ wDSession.getM_objUserInfo().getM_strUserName()+"''~''"+rejectReasons+"''";
					
					
					String param = "'"+WINAME+"','"+WSNAME+"','TT','"+colname2+"','"+colvalues2+"'";
					sInputXML="<?xml version=\"1.0\"?>" +                                                           
					"<APProcedure2_Input>" +
					"<Option>APProcedure2</Option>" +
					"<ProcName>RAK_BPM_HISTORY_UPDATE</ProcName>" +                                                                                  
					"<Params>"+param+"</Params>" +  
					"<NoOfCols>1</NoOfCols>" +
					"<SessionID>"+sSessionId+"</SessionID>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"</APProcedure2_Input>";
				}
				
				WriteLog("Updating/Inserting History"+sInputXML);
				//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				 sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("sOutputXML Updating/Inserting History"+sOutputXML);
				
				if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
					WriteLog("Update Successful");
				else
					WriteLog("Update UnSuccessful");
				
				}
			catch(Exception e) 
			{
				WriteLog("<OutPut>Error in getting User Session.</OutPut>");
			}
			
			//Save ChecklistHistory
			
			if(decision.equalsIgnoreCase("Hold"))
			{
				//
			}
			else {
				 // Condition for inserting in usr_0_TT_exception_history
				if(!WSNAME.equalsIgnoreCase("Archive"))
				{
				   WriteLog("checklistData "+checklistData);
				   
				   //changes by stutee.mishra to handle insert in exception table in compatibility view
				    String QueryCheckException="select WSName,ExcpCode,UserName,Decision,ActionDateTime from usr_0_TT_exception_history with(nolock) where WIName = '"+WINAME+"'";
					WriteLog("Query QueryCheckException: "+QueryCheckException);
					sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QueryCheckException + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
					sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					WriteLog("sOutputXML QueryCheckException: "+sOutputXML);
					xmlParserData=new XMLParser();
					xmlParserData.setInputXML((sOutputXML));
					mainCodeValue = xmlParserData.getValueOf("MainCode");
					int recordcount=0;
					recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
					String currentWSName="", currentExcpCode="", currentUserName="", currentDecision="", currentDateTime="";
					if(mainCodeValue.equals("0"))
					{
					  if(recordcount==0 && !checklistData.equals("")){
						String[] updatedExcps=checklistData.split("#");
						WriteLog("When totalretrived is 0");
						WriteLog("updatedExcps.length "+updatedExcps.length);
						for (int i=0;i<updatedExcps.length;i++)
						{
							String[] codeArr=updatedExcps[i].split("~");
								//codeArr[1]=codeArr[1].replace("CB-WC","CB_WC");
								
								sInputXML = "<?xml version=\"1.0\"?>" +
								"<APInsert_Input>" +
									"<Option>APInsert</Option>" +
									"<TableName>usr_0_TT_exception_history</TableName>" +
									"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
									"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2]+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
									"<EngineName>" + sCabName + "</EngineName>" +
									"<SessionId>" + sSessionId + "</SessionId>" +
								"</APInsert_Input>";
								WriteLog("History:updatedExcps "+sInputXML);
								//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
								 sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
								WriteLog("History: "+sOutputXML);
							
						}
					}else if(!checklistData.equals("")){
						for(int k=0; k<recordcount; k++)
						{
						 subXML = xmlParserData.getNextValueOf("Record");
						 objXmlParser = new XMLParser(subXML);
						 currentWSName=objXmlParser.getValueOf("WSName");
						 currentExcpCode=objXmlParser.getValueOf("ExcpCode");
						 currentUserName=objXmlParser.getValueOf("UserName");
						 currentDecision=objXmlParser.getValueOf("Decision");
						 currentDateTime=objXmlParser.getValueOf("ActionDateTime");
						 
						 WriteLog("currentWSName: "+currentWSName);
						 WriteLog("currentExcpCode: "+currentExcpCode);
						 WriteLog("currentUserName: "+currentUserName);
						 WriteLog("currentDecision: "+currentDecision);
						 WriteLog("currentDateTime: "+currentDateTime);
						 
						 if(!checklistData.contains(currentExcpCode) && !checklistData.contains(currentDecision) && !checklistData.contains(currentDateTime) && (currentDecision.equalsIgnoreCase("Raised") || currentDecision.equalsIgnoreCase("Approved"))){
							String[] updatedExcps=checklistData.split("#");
							WriteLog("updatedExcps.length "+updatedExcps.length);
							for (int i=0;i<updatedExcps.length;i++)
							{
								String[] codeArr=updatedExcps[i].split("~");
									//codeArr[1]=codeArr[1].replace("CB-WC","CB_WC");
									
								String QueryCheckExceptionApprovedCase="select ExcpCode from usr_0_TT_exception_history with(nolock) where WIName = '"+WINAME+"' and ExcpCode = '"+ codeArr[0] + "' and WSNAME = '"+codeArr[1].split("-")[2]+"' and USERNAME = '"+codeArr[1].split("-")[1]+"' and DECISION = '"+codeArr[1].split("-")[0].replace("[","")+"' and ACTIONDATETIME = '"+codeArr[1].split("-")[3].replace("]","")+"'";
								WriteLog("Query QueryCheckExceptionApprovedCase: "+QueryCheckExceptionApprovedCase);
								sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + QueryCheckExceptionApprovedCase + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
								sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
								WriteLog("sOutputXML QueryCheckExceptionApprovedCase: "+sOutputXML);
								xmlParserData=new XMLParser();
								xmlParserData.setInputXML((sOutputXML));
								mainCodeValue = xmlParserData.getValueOf("MainCode");
								int recordcountApproved=0;
								recordcountApproved=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
								WriteLog("recordcountApproved: "+recordcountApproved);
								
								if(recordcountApproved == 0){
									sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_TT_exception_history</TableName>" +
										"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2]+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";
									WriteLog("History:updatedExcps "+sInputXML);
									//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
									 sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
									WriteLog("History: "+sOutputXML);
								}	
								
							} 
						  }
					   }
					  
					}
				   //changes by stutee.mishra ends here.			
				    
					
					/*if(!checklistData.equals("") && !checklistData.contains(currentWSName) && !checklistData.contains(currentExcpCode) && !checklistData.contains(currentUserName) && !checklistData.contains(currentDecision) && !checklistData.contains(currentDateTime))
				    {					
						String[] updatedExcps=checklistData.split("#");
						WriteLog("updatedExcps.length "+updatedExcps.length);
						for (int i=0;i<updatedExcps.length;i++)
						{
							String[] codeArr=updatedExcps[i].split("~");
								//codeArr[1]=codeArr[1].replace("CB-WC","CB_WC");
								
								sInputXML = "<?xml version=\"1.0\"?>" +
								"<APInsert_Input>" +
									"<Option>APInsert</Option>" +
									"<TableName>usr_0_TT_exception_history</TableName>" +
									"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
									"<Values>" + "'"+WINAME+"','"+codeArr[0]+"','"+codeArr[1].split("-")[2]+"','"+codeArr[1].split("-")[1]+"','"+codeArr[1].split("-")[0].replace("[","")+"','"+codeArr[1].split("-")[3].replace("]","")+"'" + "</Values>" +
									"<EngineName>" + sCabName + "</EngineName>" +
									"<SessionId>" + sSessionId + "</SessionId>" +
								"</APInsert_Input>";
								WriteLog("History:updatedExcps "+sInputXML);
								//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
								 sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
								WriteLog("History: "+sOutputXML);
							
						}
					}*/
				}
				
		    }
				WriteLog("WSNAME: "+WSNAME);
				
				//check IsDoneClicked & WSNAME
				if(WSNAME.equalsIgnoreCase("CallBack") && IsDoneClicked.equalsIgnoreCase("false"))
				{
					//Do nothing
				}
				else
				{
					
					if(!WSNAME.equalsIgnoreCase("Archive"))
					{
						WriteLog("checklistData Save History"+checklistData);
						if(!checklistData.equals(""))
						{	
							WriteLog("checklistData Save History"+checklistData);
							String decisionVal=checklistData.substring(0,checklistData.indexOf("#"));
							String CodeList=checklistData.substring(checklistData.indexOf("~")+1);
							
							
							if(true)
							{
								String checkL1="",checkL2="";
								String CodeList1=checklistData.replace(",","','");
								WriteLog("decisionVal Save History"+decisionVal);
								WriteLog("CodeList Save History"+CodeList);
								WriteLog("CodeList1 Save History"+CodeList1);
								
							
								String[] checkLcodeArr=checklistData.split("#");
								for (int i=0;i<checkLcodeArr.length;i++) {
									 if((i+1)!=checkLcodeArr.length)
										checkL1=checkL1 + "'"+checkLcodeArr[i].substring(0,checkLcodeArr[i].indexOf("~"))+"'"+",";
									 else
										checkL1=checkL1 + "'"+checkLcodeArr[i].substring(0,checkLcodeArr[i].indexOf("~"))+"'";
								}
								WriteLog("checkL1 Save History"+checkL1);
								
								
								Query="SELECT Checklist_item_code, Approving_Unit FROM USR_0_Rak_Checklist_Master with(nolock) WHERE Checklist_Item_Code IN("+checkL1+")";
								WriteLog("Query check......."+Query);
								sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";
								//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
								 sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
								WriteLog("sOutputXML check......."+sOutputXML);
								xmlParserData=new XMLParser();
								xmlParserData.setInputXML((sOutputXML));
								mainCodeValue = xmlParserData.getValueOf("MainCode");
								int recordcount=0;
								recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
								
								if(mainCodeValue.equals("0"))
								{
								  for(int k=0; k<recordcount; k++)
									{
									 subXML = xmlParserData.getNextValueOf("Record");
									 objXmlParser = new XMLParser(subXML);
									 String Checklist_item_code=objXmlParser.getValueOf("Checklist_item_code");
									 String Approving_Unit=objXmlParser.getValueOf("Approving_Unit");
									 hmap.put(Checklist_item_code,Approving_Unit);
									}
								}			
							}							
						}
					}
				}
			}
			
		}
		
			
		
		
		 	 
		
			
			
			
			
		}

	
	
	
	
		catch (Exception e) {
				WriteLog("Exception while updating the exceptionsCreatorUsrName in the External Table");
		}
	
	
		//check IsDoneClicked & WSNAME
	
	if(WSNAME.equalsIgnoreCase("CallBack") && IsDoneClicked.equalsIgnoreCase("false"))
	{
		//Do nothing
	}
	else
	{
		//Added by anurag anand to update Status - 12-Feb-2016

		//String currWorkStep = WSNAME;//Commented for issue 66
		
		//Next WorkStep
		//String nextQueue = nextWS; //Commented for issue 66
			
		// Get the status from master table, based on currentWorkStep, Next WorkStep and Decision.
		String inputXML1 = getStatus(WSNAME, nextWS, decision, sSessionId, sCabName); // modified for issue 66
		
		String outputXML1 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML1);
		String status = "";	
				
		try{
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(outputXML1);
			String mainCodeValue1 = xmlParserData.getValueOf("MainCode");
				
			WriteLog("mainCodeValue1 getStatus......."+mainCodeValue1);
			//errortrack.append("mainCodeValue1 :- "+mainCodeValue1+"</br>");
				
			int recordcount1=0;
				
			WriteLog("recordcount1 getStatus......."+recordcount1);
			//errortrack.append("recordcount1 :- "+recordcount1+"</br>");
				
			recordcount1=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));		
				
			// If call is successful and data exists in table
			if(mainCodeValue1.equals("0") && recordcount1 > 0)				
				status = xmlParserData.getValueOf("status");			              			
			else
				status = "";

			//errortrack.append("status :- "+status+"</br>");
		}catch(Exception ex){
			//errortrack.append("Exeption :- "+ex.getMessage()+"</br>");
			//WriteLog("Exeption :- "+ex.getMessage());
		}
		
		//Make update API call to update status.
		inputXML1 = updateWorkitemStatus(WINAME,status,workitemId,sSessionId, sCabName); //modified for issue 66
		outputXML1 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputXML1);
		
	//	out.println("errortrack "+errortrack.toString());
			
		//Start of Auto Raise and Auto Clear exceptions
		//Addded by Mandeep Singh 13/Feb/2016
		
		WriteLog("Start of Auto Raise and Auto Clear");
		WriteLog("WSNAME + "+WSNAME+" for "+decision);
		
		//String excpCode = "";
		DateFormat dateFormat1 = new SimpleDateFormat("dd/MMM/yyyy HH:mm:ss");

		if (WSNAME.equalsIgnoreCase("CSO_Initiate") && decision.equalsIgnoreCase("Submit"))
		{
			String excpCode = "001";
			String excpCode1 = "002";
			
			WriteLog("Inside AutoRaise and AutoClear");
		
			if (bal_sufficient.equalsIgnoreCase("No"))
			{
				WriteLog("Balance not sufficient, raising exception");
				sInputXML = "<?xml version=\"1.0\"?>" +
				"<APInsert_Input>" +
					"<Option>APInsert</Option>" +
					"<TableName>usr_0_TT_exception_history</TableName>" +
					"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
					"<Values>" + "'"+WINAME+"','"+excpCode+"','"+WSNAME+"','"+user_name+"','Raised','"+dateFormat1.format(date)+"'" + "</Values>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APInsert_Input>";

				WriteLog("History:AutoRaise Input "+sInputXML);
				//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("History: AutoRaise Output"+sOutputXML);
			}
			
			if (pref_rate!= null && pref_rate!="" && !(pref_rate.equalsIgnoreCase("null")) )
			{
			   float floatFcyRate = Float.parseFloat(fcy_rate);
			   float floatPrefRate = Float.parseFloat(pref_rate);
		  
			   if (floatPrefRate != floatFcyRate)
			   {
				   //Auto raise Exception
					WriteLog("pref_rate "+pref_rate+" and fcy_rate "+fcy_rate);
					WriteLog("Exchange rate not same,raising exception");
					sInputXML = "<?xml version=\"1.0\"?>" +
					"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>usr_0_TT_exception_history</TableName>" +
						"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
						"<Values>" + "'"+WINAME+"','"+excpCode1+"','"+WSNAME+"','"+user_name+"','Raised','"+dateFormat1.format(date)+"'" + "</Values>" +
						"<EngineName>" + sCabName + "</EngineName>" +
						"<SessionId>" + sSessionId + "</SessionId>" +
					"</APInsert_Input>";

					WriteLog("History:AutoRaise Input "+sInputXML);
					//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					WriteLog("History: AutoRaise Output"+sOutputXML);
			   }
			}
			WriteLog("Getting values of bal_sufficient,fcy_rate,pref_rate......."+bal_sufficient+","+fcy_rate+","+pref_rate);
		}
		else if (WSNAME.equalsIgnoreCase("Treasury") && decision.equalsIgnoreCase("Approve"))
		{
			String excpCode = "002";
			boolean alreadyRaised = false;
			
			//First Check it is raised by CSO_Initiate not
			Query = "SELECT * FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+WINAME+"' AND ExcpCode='"+excpCode+"' AND WSName='CSO_Initiate'";
			
			sInputXML = apselectXML(Query,sSessionId,sCabName); //modified for issue 66
			
			WriteLog("Checking exception already raised or not ,input XML- "+sInputXML);
			//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			WriteLog("History: AutoRaise Output"+sOutputXML);
			
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(sOutputXML);
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			if(mainCodeValue.equals("0"))
			{
				int recordcount=0;
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
				
				if (recordcount != 0)
					alreadyRaised = true;		
			}
			
			if (alreadyRaised == true)
			{
				boolean alreadyUnraised = false;
				Query = "SELECT TOP 1 Decision FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+WINAME+"' AND WSName='"+WSNAME+"' AND ExcpCode= '"+excpCode+"' ORDER BY ActionDateTime DESC";
				//modified for issue 66
				sInputXML = apselectXML(Query,sSessionId,sCabName);
				
				WriteLog("History:AutoRaise Input "+sInputXML);
				//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
				sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("History: AutoRaise Output"+sOutputXML);
				
				
				xmlParserData=new XMLParser();
				xmlParserData.setInputXML(sOutputXML);
				mainCodeValue = xmlParserData.getValueOf("MainCode");		
					
					
				if(mainCodeValue.equals("0"))
				{
					int recordcount=0;
					recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
					
					WriteLog("recordcount for-----"+recordcount);
					
					if (recordcount!=0)
						alreadyUnraised = true;				
				}
				
				//Insert into the DB when it is not unraised manually
				if (alreadyUnraised == false)
				{
					sInputXML = "<?xml version=\"1.0\"?>" +
					"<APInsert_Input>" +
						"<Option>APInsert</Option>" +
						"<TableName>usr_0_TT_exception_history</TableName>" +
						"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
						"<Values>" + "'"+WINAME+"','"+excpCode+"','"+WSNAME+"','"+user_name+"','Approved','"+dateFormat1.format(date)+"'" + "</Values>" +
						"<EngineName>" + sCabName + "</EngineName>" +
						"<SessionId>" + sSessionId + "</SessionId>" +
					"</APInsert_Input>";

					WriteLog("History:AutoRaise Input "+sInputXML);
					//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					WriteLog("History: AutoRaise Output"+sOutputXML);
				}
			}	
		}
		else if (WSNAME.equalsIgnoreCase("CallBack") && decision.equalsIgnoreCase("Successful"))
		{
			String excpCode = "005";
			boolean alreadyRaised = false;
			String wsnameTemp = "";
			String decisionTemp = "";

			//First Check it is raised by CSO_Initiate not
			Query = "SELECT TOP 1 Decision,wsname FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+WINAME+"' AND ExcpCode= '"+excpCode+"' ORDER BY ActionDateTime DESC";
		//modified for issue 66
			sInputXML = apselectXML(Query,sSessionId,sCabName);
			
			WriteLog("Checking exception already raised or not ,input XML- "+sInputXML);
			//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			WriteLog("History: AutoRaise Output"+sOutputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(sOutputXML);
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			//Top will be raised or unraised
			if(mainCodeValue.equals("0"))
			{
				int recordcount=0;
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

				if (recordcount != 0)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					decisionTemp = objXmlParser.getValueOf("Decision");
					wsnameTemp = objXmlParser.getValueOf("wsname");
					
					//If raised then unraise it
					if (decisionTemp.equals("Raised"))
					{
						sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_TT_exception_history</TableName>" +
										"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+excpCode+"','"+WSNAME+"','"+user_name+"','Approved','"+dateFormat1.format(date)+"'" + "</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";

						WriteLog("History:AutoRaise Input "+sInputXML);
						//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						WriteLog("History: AutoRaise Output"+sOutputXML);
					}
				}
			}
		}
		else if (WSNAME.equalsIgnoreCase("Comp_Check") && decision.equalsIgnoreCase("Approve"))
		{
			String excpCode = "004";
			boolean alreadyRaised = false;
			String wsnameTemp = "";
			String decisionTemp = "";
			
			//First Check it is raised by CSO_Initiate not
			Query = "SELECT TOP 1 Decision,wsname FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+WINAME+"' AND ExcpCode= '"+excpCode+"' ORDER BY ActionDateTime DESC";
			//modified for issue 66
			sInputXML = apselectXML(Query,sSessionId,sCabName);
			
			WriteLog("Checking exception already raised or not ,input XML- "+sInputXML);
			//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			WriteLog("History: AutoRaise Output"+sOutputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(sOutputXML);
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			//Top will be raised or Approved
			if(mainCodeValue.equals("0"))
			{
				int recordcount=0;
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

				if (recordcount != 0)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					decisionTemp = objXmlParser.getValueOf("Decision");
					wsnameTemp = objXmlParser.getValueOf("wsname");
					
					//If raised then unraise it
					if (decisionTemp.equals("Raised"))
					{
						sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_TT_exception_history</TableName>" +
										"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+excpCode+"','"+WSNAME+"','"+user_name+"','Approved','"+dateFormat1.format(date)+"'" + "</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";

						WriteLog("History:AutoRaise Input "+sInputXML);
						//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						WriteLog("History: AutoRaise Output"+sOutputXML);
					}
				}
			}
			
			//For exception code 006
			excpCode = "006";
			alreadyRaised = false;
			wsnameTemp = "";
			decisionTemp = "";
			//First Check it is raised by CSO_Initiate not
			Query = "SELECT TOP 1 Decision,wsname FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+WINAME+"' AND ExcpCode= '"+excpCode+"' ORDER BY ActionDateTime DESC";
//modified for issue 66
			sInputXML = apselectXML(Query,sSessionId,sCabName);
			
			WriteLog("Checking exception already raised or not ,input XML- "+sInputXML);
			sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
			WriteLog("History: AutoRaise Output"+sOutputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(sOutputXML);
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			//Top will be raised or Approved
			if(mainCodeValue.equals("0"))
			{
				int recordcount=0;
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

				if (recordcount != 0)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					decisionTemp = objXmlParser.getValueOf("Decision");
					wsnameTemp = objXmlParser.getValueOf("wsname");
					
					//If raised then unraise it
					if (decisionTemp.equals("Raised"))
					{
						sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_TT_exception_history</TableName>" +
										"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+excpCode+"','"+WSNAME+"','"+user_name+"','Approved','"+dateFormat1.format(date)+"'" + "</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";

						WriteLog("History:AutoRaise Input "+sInputXML);
						//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						WriteLog("History: AutoRaise Output"+sOutputXML);
					}
				}
			}
			
			//For exception 008
			excpCode = "008";
			alreadyRaised = false;
			wsnameTemp = "";
			decisionTemp = "";
			//First Check it is raised by CSO_Initiate not
			Query = "SELECT TOP 1 Decision,wsname FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+WINAME+"' AND ExcpCode= '"+excpCode+"' ORDER BY ActionDateTime DESC";
	//modified for issue 66
			sInputXML = apselectXML(Query,sSessionId,sCabName);
			
			WriteLog("Checking exception already raised or not ,input XML- "+sInputXML);
			//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
			sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			WriteLog("History: AutoRaise Output"+sOutputXML);
			
			xmlParserData=new XMLParser();
			xmlParserData.setInputXML(sOutputXML);
			mainCodeValue = xmlParserData.getValueOf("MainCode");
			
			//Top will be raised or Approved
			if(mainCodeValue.equals("0"))
			{
				int recordcount=0;
				recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));

				if (recordcount != 0)
				{
					subXML = xmlParserData.getNextValueOf("Record");
					objXmlParser = new XMLParser(subXML);
					decisionTemp = objXmlParser.getValueOf("Decision");
					wsnameTemp = objXmlParser.getValueOf("wsname");
					
					//If raised then unraise it
					if (decisionTemp.equals("Raised"))
					{
						sInputXML = "<?xml version=\"1.0\"?>" +
									"<APInsert_Input>" +
										"<Option>APInsert</Option>" +
										"<TableName>usr_0_TT_exception_history</TableName>" +
										"<ColName>" + "WINAME,ExcpCode,WSNAME,USERNAME,DECISION,ACTIONDATETIME" + "</ColName>" +
										"<Values>" + "'"+WINAME+"','"+excpCode+"','"+WSNAME+"','"+user_name+"','Approved','"+dateFormat1.format(date)+"'" + "</Values>" +
										"<EngineName>" + sCabName + "</EngineName>" +
										"<SessionId>" + sSessionId + "</SessionId>" +
									"</APInsert_Input>";

						WriteLog("History:AutoRaise Input "+sInputXML);
						//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						WriteLog("History: AutoRaise Output"+sOutputXML);
					}
				}
			}
			
		}
		
		WriteLog("End of Auto Raise and Auto Clear");
		WriteLog("postCutOffTimetoDB	"+postCutOffTimetoDB);
		try {
			//Update the postCutOffCases Cases in the last at CSO_Initiate
			if (WSNAME.equalsIgnoreCase("CSO_Initiate") && decision.equalsIgnoreCase("Submit") && postCutOffTimetoDB!="" && !postCutOffTimetoDB.equalsIgnoreCase("null") && postCutOffTimetoDB!= null)
			{
				
				//ApSelect to get the postCutOff Timings	
				Query = "SELECT CAST(substring(convert(varchar(20),'"+postCutOffTimetoDB+"'),0,20)  AS DATETIME) AS postCutOffTimetoDB";
				
				WriteLog ("query : - "+ Query);
				
				sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";

				//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
				sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				
				xmlParserData = new XMLParser();
				xmlParserData.setInputXML(sOutputXML);
				mainCodeValue = xmlParserData.getValueOf("MainCode");
				int recordcount=0;
				recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
				
				if(mainCodeValue.equals("0"))
				{
					 subXML = xmlParserData.getNextValueOf("Record");
					 objXmlParser = new XMLParser(subXML);
					 postCutOffTimetoDB=objXmlParser.getValueOf("postCutOffTimetoDB");
				}			

				WriteLog ("Got postCutOffTimetoDB : - "+ postCutOffTimetoDB);
			
				String colname2 = "postCutOffTime";
				String colvalues2 = "'"+postCutOffTimetoDB+"'";
				
				sInputXML = "<?xml version=\"1.0\"?>" +
						"<APUpdate_Input>" +
							"<Option>APUpdate</Option>" +
							"<TableName>NG_TT_EXT_TABLE</TableName>" +
							"<ColName>" + colname2 + "</ColName>" +
							"<Values>" + colvalues2 + "</Values>" +
							"<WhereClause>" + "wi_name='"+WINAME+"'</WhereClause>" +
							"<EngineName>" + sCabName + "</EngineName>" +
							"<SessionId>" + sSessionId + "</SessionId>" +
						"</APUpdate_Input>";
							
					WriteLog("PostCutOff Cases Input XML - "+sInputXML);
					
					//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					
					WriteLog("PostCutOff Cases Output XML  "+sOutputXML);
						
					if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)			
						WriteLog("Update Successful");			
					else			
						WriteLog("Update UnSuccessful");
			}
		}
		catch (Exception e)
		{
			WriteLog("Error while updating the PostCutOfftime");
		}
		
		try {
		WriteLog("Updating the external table when workitem routed to CSO_Exceptions");
		
		if (nextWS.equalsIgnoreCase("CSO_Exceptions")) {
			String exceptionsCreatorUsrName = "";
			//ApSelect to get the username initiated the wi
			Query = "SELECT TOP 1 username FROM usr_0_tt_wihistory with(nolock) WHERE winame ='"+WINAME+"' ORDER BY entrydatetime";
				
			WriteLog ("query : - "+ Query);
				
			sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";

				//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
				sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					
				xmlParserData = new XMLParser();
				xmlParserData.setInputXML(sOutputXML);
				mainCodeValue = xmlParserData.getValueOf("MainCode");
				int recordcount=0;
				recordcount = Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
					
				if(mainCodeValue.equals("0"))
				{
					 subXML = xmlParserData.getNextValueOf("Record");
					 objXmlParser = new XMLParser(subXML);
					 exceptionsCreatorUsrName = objXmlParser.getValueOf("username");
				}

					WriteLog ("Got exceptionsCreatorUsrName : - "+ exceptionsCreatorUsrName);
				
					String colname2 = "exceptionsCreatorUsrName";
					String colvalues2 = "'"+exceptionsCreatorUsrName+"'";
					
					sInputXML = "<?xml version=\"1.0\"?>" +
							"<APUpdate_Input>" +
								"<Option>APUpdate</Option>" +
								"<TableName>NG_TT_EXT_TABLE</TableName>" +
								"<ColName>" + colname2 + "</ColName>" +
								"<Values>" + colvalues2 + "</Values>" +
								"<WhereClause>" + "wi_name='"+WINAME+"'</WhereClause>" +
								"<EngineName>" + sCabName + "</EngineName>" +
								"<SessionId>" + sSessionId + "</SessionId>" +
							"</APUpdate_Input>";
								
						WriteLog("exceptionsCreatorUsrName Update Input XML - "+sInputXML);
						
						//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
						
						WriteLog("exceptionsCreatorUsrName Update Output XML  "+sOutputXML);
							
						if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)			
							WriteLog("Update Successful");			
						else			
							WriteLog("Update UnSuccessful");
			}
		}
		catch (Exception e) {
				WriteLog("Exception while updating the exceptionsCreatorUsrName in the External Table");
		}
		
		////////
	}
	
	WriteLog("----------------End of SaveHistory.jsp---------------------");
	
%>
