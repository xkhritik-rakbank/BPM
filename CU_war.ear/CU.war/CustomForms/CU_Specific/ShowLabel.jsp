<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application ?Projects
//Product / Project			 : RAKBank
//File Name					 : FetchEmiratesId.jsp
//Author                     : Shubham Ruhela
//Date written (DD/MM/YYYY)  :  15-01-2016
//---------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED
-------------------------Revision History---------------------------------------------------------------
Revision 	Date 			Author 			Description
0.90		05/02/2016		Shubham Ruhela	Initial Draft

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

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%!
public String getAPSelectXML(String strEngineName, String strSessionId, String Query) 
{
	return "<?xml version=\"1.0\"?>"
		+ "<APSelect_Input><Option>APSelect</Option>"
		+ "<Query>" + Query + "</Query>"
		+ "<EngineName>" + strEngineName + "</EngineName>"
		+ "<SessionId>" + strSessionId + "</SessionId>"
		+ "</APSelect_Input>";
}
%>
<%
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("req"), 1000, true) );
			String req_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("values"), 1000, true) );
			String values_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	//String reqtype = request.getParameter("req");
	String reqtype =req_Esapi;
	if (reqtype != null) {reqtype=reqtype.replace("'","''");}
	WriteLog("Req In show label: "+reqtype);
	//String values =  request.getParameter("values");
	String values = values_Esapi;
	WriteLog("req_Esapi :"+req_Esapi );
	WriteLog("values_Esapi:"+values_Esapi);
	if (values != null) {values=values.replace("'","''");}
	WriteLog("values In show label:"+values);
	String query = "" ;
	String InputXml = "";
	String outputXML ="";
	String sCabName=customSession.getEngineName();	
	String sessionID = customSession.getDMSSessionId();
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	WFCustomXmlList objWorkList=null;
	String returnValues = "";	
	
	String params = "";
	if(reqtype.equalsIgnoreCase("Occupation")){
		query = "SELECT top(1) occupation_code_desc FROM usr_0_cu_occupationmaster with(nolock) WHERE occupation_code=:occupation_code" ;
		params = "occupation_code=="+values;
		//WriteLog("Occupation in Showlabel"+values);
	}	
	else if(reqtype.equalsIgnoreCase("Employement")){
		query = "select top(1) EmpTypedisplay from usr_0_cu_EmployementType with(nolock) WHERE Empcode=:Empcode" ;
		params = "Empcode=="+values;
		//WriteLog("Empcode in Showlabel"+values);
	}else if(reqtype.equalsIgnoreCase("USRelation")){
		query = "select top(1) reltypedisplay from usr_0_cu_USRelation with(nolock) WHERE relcode=:relcode" ;
		params = "relcode=="+values;
		//WriteLog("relcode in Showlabel"+values);
	}	
	else if(reqtype.equalsIgnoreCase("FatcaDoc")){
		query = "select top(1) fatcadocdisplay from usr_0_cu_USRelation with(nolock) WHERE fatcadoc=:fatcadoc" ;
		params= "fatcadoc=="+values;
		//WriteLog("fatcadoc in Showlabel"+values);
		}
	else if(reqtype.equalsIgnoreCase("IndustrySeg")){
		query = "select top(1) industrySegTypeDisplay from usr_0_cu_IndustrySegment with(nolock) WHERE IndustrySegType=:IndustrySegType" ;
		params ="IndustrySegType=="+values;
		//WriteLog("IndustrySegType in Showlabel"+values);
		}
	else if(reqtype.equalsIgnoreCase("IndustrySubSeg")){
		query = "select top(1) IndustrySubSegType from usr_0_cu_IndustrySubSegment with(nolock) WHERE indsegcode=:indsegcode" ;
		params = "indsegcode=="+values;
		WriteLog("indsegcode in Showlabel"+values);
		}
	else if(reqtype.equalsIgnoreCase("CustomerType")){
		query = "select top(1) custtype from usr_0_cu_customertype with(nolock) WHERE custcode=:custcode" ;
		params = "custcode=="+values;
		//WriteLog("custcode in Showlabel"+values);
		}else if (reqtype.equalsIgnoreCase("marrital")){
		query = "select top(1) MaritalstatusTypedisplay from usr_0_cu_MaritalStatus with(nolock) WHERE MaritalstatusCode=:MaritalstatusCode" ;
		params = "MaritalstatusCode=="+values;
		//WriteLog("MaritalstatusCode in Showlabel"+values);
		}
		else if (reqtype.equalsIgnoreCase("resi_country") || reqtype.equalsIgnoreCase("office_cntrycode") ){
		query = "SELECT countryCode FROM USR_0_CU_CountryMaster with (nolock) WHERE countryname=:countryname" ;
		params = "countryname=="+values;
		WriteLog("countryname in Showlabel"+values);
		}
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	WriteLog("InputXml occupation label----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog("outputXML occupation label----"+outputXML);
	
	WFCustomXmlResponseData=new WFCustomXmlResponse();
	WFCustomXmlResponseData.setXmlString((outputXML));
	String mainCodeValue = WFCustomXmlResponseData.getVal("MainCode");
	
	if(mainCodeValue.equals("0"))
	{
		String getValueOfParam="";
		if (reqtype.equals("Occupation")) {
			getValueOfParam="occupation_code_desc";	
		} else if(reqtype.equals("Employement")) {
			getValueOfParam="EmpTypedisplay";
		} else if(reqtype.equals("USRelation")) {
			getValueOfParam="reltypedisplay";
		} else if(reqtype.equals("FatcaDoc")) {
			getValueOfParam="fatcadocdisplay";				
		} else if(reqtype.equals("IndustrySeg")) {
			getValueOfParam="industrySegTypeDisplay";	} 
		else if(reqtype.equals("IndustrySubSeg")) {
			getValueOfParam="IndustrySubSegType";					
		} else if(reqtype.equals("CustomerType")) {
			getValueOfParam="custtype";				
		} else if(reqtype.equals("marrital")) {
			getValueOfParam="MaritalstatusTypedisplay";				
		}else if(reqtype.equals("resi_country")||reqtype.equals("office_cntrycode")) {
			getValueOfParam="countryCode";				
		} 
		
		//added on 29112016 for getting nationality based on code
		objWorkList = WFCustomXmlResponseData.createList("Records","Record"); 
		
		for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
		{
			returnValues += objWorkList.getVal(getValueOfParam);				
		}	
				
	}
	
	//String Valid = "";
	//if(outputXML.indexOf("<td>")>-1)
	//{
		//Valid=outputXML.substring(outputXML.indexOf("<td>")+"<td>".length(),outputXML.indexOf("</td>"));
	//}	
	WriteLog("returnValues occupation label----"+returnValues);
	out.clear();
	out.println(returnValues);
%>