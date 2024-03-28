<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application ?Projects
//Product / Project			 : RAKBank
//File Name					 : TT.jsp
//Author                     : Shubham Ruhela
//Date written (DD/MM/YYYY) :  15-01-2016
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../CU_Specific/Log.process"%>

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%!
public String getAPInsertXML(String strEngineName, String strSessionId, String tableName, String columns, String strValues) 
{
	return "<?xml version=\"1.0\"?>" +
		"<APInsert_Input>" +
		"<Option>APInsert</Option>" +
		"<TableName>" + tableName + "</TableName>" +
		"<ColName>" + columns + "</ColName>" +
		"<Values>" + strValues + "</Values>" +
		"<EngineName>" + strEngineName + "</EngineName>" +
		"<SessionId>" + strSessionId + "</SessionId>" +
		"</APInsert_Input>";
}
public String getAPSelectXML(String strEngineName, String strSessionId, String Query) 
{
	return "<?xml version=\"1.0\"?>"
		+ "<APSelect_Input><Option>APSelect</Option>"
		+ "<Query>" + Query + "</Query>"
		+ "<EngineName>" + strEngineName + "</EngineName>"
		+ "<SessionId>" + strSessionId + "</SessionId>"
		+ "</APSelect_Input>";
}
public String getAPUpdateXML(String strEngineName, String strSessionId, String tableName, String columns, String strValues,String winame) 
{
	return "<?xml version=\"1.0\"?>" +
		"<APUpdate_Input>" +
			"<Option>APUpdate</Option>" +
			"<TableName>" + tableName + "</TableName>" +
			"<ColName>" + columns + "</ColName>" +
			"<Values>" + strValues + "</Values>" +
			"<WhereClause>" + "winame='"+winame+"'" + "</WhereClause>" +
			"<EngineName>" + strEngineName + "</EngineName>" +
			"<SessionId>" + strSessionId + "</SessionId>" +
		"</APUpdate_Input>";
}
%>
<%			
String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("signature_update"), 1000, true) );
			String signature_update_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("dormancy_activation"), 1000, true) );
			String dormancy_activation_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sole_to_joint"), 1000, true) );
			String sole_to_joint_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("joint_to_sole"), 1000, true) );
			String joint_to_sole_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
try
{
	String inputXML = "";
	String outputXML = "";
//	String WINAME = request.getParameter("WINAME");
String WINAME = WINAME_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	//String signature_update = request.getParameter("signature_update");
	String signature_update = signature_update_Esapi;
	if (signature_update != null) {signature_update=signature_update.replace("'","''");}
	//String dormancy_activation = request.getParameter("dormancy_activation");
	String dormancy_activation = dormancy_activation_Esapi;
	if (dormancy_activation != null) {dormancy_activation=dormancy_activation.replace("'","''");}
	//String sole_to_joint = request.getParameter("sole_to_joint");
	String sole_to_joint = sole_to_joint_Esapi;
	if (sole_to_joint != null) {sole_to_joint=sole_to_joint.replace("'","''");}
	//String joint_to_sole = request.getParameter("joint_to_sole");
	String joint_to_sole = joint_to_sole_Esapi;
	if (joint_to_sole != null) {joint_to_sole=joint_to_sole.replace("'","''");}
	WriteLog("WINAME_Esapi:"+WINAME_Esapi);
	WriteLog("signature_update_Esapi:"+signature_update_Esapi);
	WriteLog("dormancy_activation_Esapi:"+dormancy_activation_Esapi);
	WriteLog("sole_to_joint_Esapi:"+sole_to_joint_Esapi);
	WriteLog("joint_to_sole_Esapi:"+joint_to_sole_Esapi);
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();	
	String sCabName=customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();
	String params = "";
	String table_name = "usr_0_cu_griddata";
	String columns = "winame";  
	String values = "'"+WINAME+"'";	
	String Query = "select id from "+table_name+" where winame=:winame";
	params = "winame=="+values;
	//inputXML = getAPSelectXML( sCabName,  sSessionId,  Query) ;
	
	inputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
	
	outputXML= WFCustomCallBroker.execute(inputXML,sJtsIp,iJtsPort,1);
	WriteLog("inputXML into ACCOUNT_SUMMARY Table: Input"+inputXML);
	WriteLog("outputXML into ACCOUNT_SUMMARY Table: Input"+outputXML);
	
	if(!(outputXML.contains("<id>")))
	{
		inputXML = getAPInsertXML (sCabName,sSessionId,table_name,columns,values);
		WriteLog("Inserting into ACCOUNT_SUMMARY Table: Input"+inputXML);
		outputXML= WFCustomCallBroker.execute(inputXML,sJtsIp,iJtsPort,1);
		WriteLog("Output ACCOUNT_SUMMARY: "+outputXML);
	}
	
	try
	{
		columns = "signature_update,dormancy_activation,sole_to_joint,joint_to_sole"; 
		values = "'"+signature_update+"'" + ","+ "'"+dormancy_activation+"'" + ","+ "'"+sole_to_joint+"'" + ","+ "'"+joint_to_sole+"'";
		
		inputXML = getAPUpdateXML (sCabName,sSessionId,table_name,columns,values,WINAME);
		WriteLog(" InputXML Update"+columns+" into ACCOUNT_SUMMARY Table: Input"+inputXML);
		outputXML= WFCustomCallBroker.execute(inputXML,sJtsIp,iJtsPort,1);
		WriteLog(" outputXML Update "+columns+" ACCOUNT_SUMMARY: "+outputXML);
	}
	catch(Exception e1)
	{
		WriteLog("Error in InsertGrid inner: "+e1);
	}
}catch(Exception e){
	WriteLog("Error in InsertGrid Outer: "+e);
}
%>