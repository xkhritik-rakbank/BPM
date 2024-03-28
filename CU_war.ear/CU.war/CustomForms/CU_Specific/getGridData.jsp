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
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif_type"), 1000, true) );
			String cif_type_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
	//String cif_type = request.getParameter("cif_type");
	String cif_type = cif_type_Esapi;
	if (cif_type != null) {cif_type=cif_type.replace("'","''");}
	//String wi_name = request.getParameter("wi_name");
	String wi_name = wi_name_Esapi;
	WriteLog("cif_type_Esapi:"+cif_type_Esapi);
	WriteLog("wi_name_Esapi:"+wi_name_Esapi);
	if (wi_name != null) {wi_name=wi_name.replace("'","''");}
	String table_name = "usr_0_cu_griddata";
	String mainStr = "";
	String checkbox_name = "";
	String button_name = "";
	String row ="";
	String mainValue = "";
	String query = "" ;
	String outputXML ="";
	String InputXml = "";
	int i = 0;
	String temp ="";
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String sessionID = customSession.getDMSSessionId();
	String sCabName=customSession.getEngineName();	
	String params = "";
	query = "SELECT signature_update FROM "+table_name+" WHERE winame=:winame" ;
	params = "winame=="+wi_name;
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	
	//WriteLog("InputXml----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	//WriteLog("outputXML----"+outputXML);
	
	row = "<table id='signatureupdate' border=1 width='100%'><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Account Number</th><th>Name</th><th>Mode of Operation</th><th>Fetch Signature</th></tr>";
	if(outputXML.indexOf("<signature_update>")>-1)	
	{
		mainStr = outputXML.substring(outputXML.indexOf("<signature_update>")+"<signature_update>".length(),outputXML.indexOf("</signature_update>") );
	
		String fetch = "Fetch Signature";
		checkbox_name = "checkbox_signatureupdate";
		for (String retval: mainStr.split("~")){
			row = row +"<tr class='EWNormalGreenGeneral1'>";
			i=0;
			for(String retvalInner: retval.split("#"))
			{
				if(i==0)
				{
					temp = retvalInner;
					if(retvalInner.indexOf("CHECKED") != -1)
					{	
						retvalInner = retvalInner.replace("CHECKED", "");//UNCHECK
						temp = retvalInner;
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+" checked >"+"</td>";
					}
					else
					{
						if(retvalInner.indexOf("UNCHECK") != -1)
						{
							retvalInner = retvalInner.replace("UNCHECK", "");
							temp = retvalInner;
						}

						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+">"+"</td>";
					}
				}
				else if(i==1)
					row = row +"<td id='accountNum_"+temp+"'>"+retvalInner+"</td>";
				else
					row = row +"<td >"+retvalInner+"</td>";
				
				i++;
			}
			row = row +"<td>"+"<input type='button' onclick='getSignature(this)' name="+"'"+button_name+"'"+" value="+"'"+fetch+"'"+" id="+"'"+temp+"'"+">"+"</td>";
			row = row +"</tr>";
		}
	}
	row = row +"</table>";
	//WriteLog("row----"+row);
	mainValue = mainValue + row + "`";

	// ---------------------------------Dormancy_Activation -----------------------------
	query = "SELECT dormancy_activation FROM "+table_name+" WHERE winame=:winame" ;
	params = "winame=="+wi_name;
	outputXML ="";
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	WriteLog("\ndormancy_activation InputXml----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog("\ndormancy_activation outputXML----"+outputXML);
	
	row = "<table id='dormancyactivation' border=1 width='100%'><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Account Number</th><th>Name</th><th>Mode of Operation</th></tr>";
	if(outputXML.indexOf("<dormancy_activation>")>-1)	
	{	
		//WriteLog("\ninside dormancy_activation outputXML");
		mainStr = outputXML.substring(outputXML.indexOf("<dormancy_activation>")+"<dormancy_activation>".length(),outputXML.indexOf("</dormancy_activation>") );
		
		//WriteLog("\ndormancy_activation mainStr"+ mainStr);
		checkbox_name = "checkbox_dormancyactivation";
		for (String retval: mainStr.split("~")){
			//WriteLog(retval);
			row = row +"<tr class='EWNormalGreenGeneral1'>";
			i=0;
			for(String retvalInner: retval.split("#"))
			{
				if(i==0)
				{	
					temp = retvalInner;
					if(retvalInner.indexOf("CHECKED") != -1)
					{
						retvalInner = retvalInner.replace("CHECKED", "");//UNCHECK
						temp = retvalInner;
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+" checked>"+"</td>";
					}
					else
					{
						if(retvalInner.indexOf("UNCHECK") != -1)
						{
							retvalInner = retvalInner.replace("UNCHECK", "");
							temp = retvalInner;
						}
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+">"+"</td>";
					}
				}
				else
					row = row +"<td>"+retvalInner+"</td>";
				
				i++;
			}
			row = row +"</tr>";
		}
	}	
	row = row +"</table>";
	//WriteLog("Dormancy_Activation "+ row);
	mainValue = mainValue + row + "`";
	
	// ---------------------------------Sole To Joint -----------------------------
	query = "SELECT sole_to_joint FROM "+table_name+" WHERE winame=:winame" ;
	params = "winame=="+wi_name;
	
	outputXML ="";
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	WriteLog("Sole To Joint InputXml----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog("Sole To Joint outputXML----"+outputXML);
			
	row = "<table id='soletojoint' width='100%' border=1> <tr class='EWNormalGreenGeneral1'><th>Select</th><th>Account Number</th><th>Name</th><th>Mode of Operation</th></tr>";
	if(outputXML.indexOf("<sole_to_joint>")>-1)	
	{	
		mainStr = outputXML.substring(outputXML.indexOf("<sole_to_joint>")+"<sole_to_joint>".length(),outputXML.indexOf("</sole_to_joint>") );
		
		//WriteLog(mainStr);
		checkbox_name = "checkbox_soletojoint";
		for (String retval: mainStr.split("~")){
			//WriteLog(retval);
			row = row +"<tr class='EWNormalGreenGeneral1'>";
			i=0;
			for(String retvalInner: retval.split("#"))
			{
				if(i==0)
				{
					temp = retvalInner;
					if(retvalInner.indexOf("CHECKED") != -1)
					{
						retvalInner = retvalInner.replace("CHECKED", "");//UNCHECK
						temp = retvalInner;
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+" checked>"+"</td>";
					}
					else
					{
						if(retvalInner.indexOf("UNCHECK") != -1)
						{
							retvalInner = retvalInner.replace("UNCHECK", "");
							temp = retvalInner;
						}
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+">"+"</td>";
					}
				}
				else
					row = row +"<td>"+retvalInner+"</td>";
				
				i++;
			}
			row = row +"</tr>";
		}
	}
	row = row +"</table>";
	//WriteLog(row);
	mainValue = mainValue + row + "`";
	
	// ---------------------------------Joint To Sole -----------------------------
	query = "SELECT joint_to_sole FROM "+table_name+" WHERE winame=:winame" ;
	params = "winame=="+wi_name;
	outputXML ="";
	//InputXml = getAPSelectXML(sCabName,sessionID,query);
	
	InputXml = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sessionID + "</SessionId></APSelectWithNamedParam_Input>";
	
	WriteLog("InputXml----"+InputXml);
	outputXML=WFCustomCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
	WriteLog("\noutputXML----"+outputXML);
	
	row = "<table id='jointtosole' width='100%' border=1><tr class='EWNormalGreenGeneral1'><th>Select</th><th>Account Number</th><th>Name</th><th>Mode of Operation</th></tr>";
	
	if(outputXML.indexOf("<joint_to_sole>")>-1)	
	{	
		mainStr = outputXML.substring(outputXML.indexOf("<joint_to_sole>")+"<joint_to_sole>".length(),outputXML.indexOf("</joint_to_sole>"));
		
		//WriteLog("mainstr---"+ mainStr);
		checkbox_name = "checkbox_jointtosole";
		for (String retval: mainStr.split("~")){
			//WriteLog("retval---"+ retval);
			row = row +"<tr class='EWNormalGreenGeneral1'>";
			i=0;
			for(String retvalInner: retval.split("#"))
			{
				if(i==0)
				{
					temp = retvalInner;
					if(retvalInner.indexOf("CHECKED") != -1)
					{
						retvalInner = retvalInner.replace("CHECKED", "");//UNCHECK
						temp = retvalInner;
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+" checked>"+"</td>";
					}
					else
					{
						if(retvalInner.indexOf("UNCHECK") != -1)
						{
							retvalInner = retvalInner.replace("UNCHECK", "");
							temp = retvalInner;
						}
						row = row +"<td>"+"<input type='checkbox' name="+"'"+checkbox_name+"'"+" value="+"'"+retvalInner+"'"+" id="+"'"+retvalInner+"'"+">"+"</td>";
					}
				}
				else
				 row = row +"<td>"+retvalInner+"</td>";
				
				i++;
			}
			row = row +"</tr>";
		}
	}	
	row = row +"</table>";
	//WriteLog("mainValue before row  get grid ----"+row);

	mainValue = mainValue + row + "`";
	out.clear();
	WriteLog("mainValue get grid ----"+mainValue);
	out.println(mainValue);
%>