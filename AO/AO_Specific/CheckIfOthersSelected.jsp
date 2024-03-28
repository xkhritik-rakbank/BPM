
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<HTML>
<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WorkstepName"), 1000, true) );
			String WorkstepName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WorkstepName_Esapi: "+WorkstepName_Esapi);

	WriteLog("Inside  CheckIfOthersSelected.jsp");
	String OthersItemCode="0";
	XMLParser mainCodeParser=null;
	String WorkstepName=WorkstepName_Esapi;
	String sInputXML="";
	String sOutputXML="";
	String EngineName=wDSession.getM_objCabinetInfo().getM_strCabinetName();
	String SessionId= wDSession.getM_objUserInfo().getM_strSessionId();
	String sJtsIp =  wDSession.getM_objCabinetInfo().getM_strServerIP();
	int iJtsPort =  wDSession.getM_objCabinetInfo().getM_strServerPort();
	String Query="";
	
	try	
	{	
			/*Query="select Item_Code from USR_0_AO_Error_Desc_Master with(nolock) where Item_Desc='Others' and WSName='"+WorkstepName+"'";	
			sInputXML="<?xml version=\"1.0\"?>"
			+ "<APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option>"
			+ "<Query>" + Query + "</Query>"
			+ "<EngineName>" + EngineName + "</EngineName>"
			+ "<SessionId>" + SessionId + "</SessionId>"
			+ "</APSelectWithColumnNames_Input>";*/

			String params="Item_Desc==Others~~WSName=="+WorkstepName;
			Query="select Item_Code from USR_0_AO_Error_Desc_Master with(nolock) where Item_Desc=:Item_Desc and WSName=:WSName";	
			sInputXML="<?xml version=\"1.0\"?>"
			+ "<APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option>"
			+ "<Query>" + Query + "</Query>"
			+ "<EngineName>" + EngineName + "</EngineName>"
			+ "<SessionId>" + SessionId + "</SessionId><Params>" + params + "</Params>"
			+ "</APSelectWithNamedParam_Input>";
			
			WriteLog("sInputXML: "+sInputXML);
			sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
            WriteLog("sOutputXML: "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				OthersItemCode=sOutputXML.substring(sOutputXML.indexOf("<Item_Code>")+"<Item_Code>".length(),sOutputXML.indexOf("</Item_Code>"));
				
			}
			else
			{
				
			}	
		
	}
	catch(Exception e) 
	{
		WriteLog("<OutPut>Error during custom call</OutPut>");
	}

%>

</BODY>
</HTML>

<%
out.clear();
out.println(OthersItemCode+"~");		
%>



