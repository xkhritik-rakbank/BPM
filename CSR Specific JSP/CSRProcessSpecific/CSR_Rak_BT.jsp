<%--

	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_ProcessSpec_BT.jsp
	Purpose         :       RAKBANK card is being accepted for Balance Transfer and should not be allowed for this functionality.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/002					05/09/2008	 
--%>
<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@page import="com.newgen.wfdesktop.util.AESEncryption"%>
<%@page import="com.newgen.wfdesktop.cabinet.WDCabinetList"%>
<%@page import="com.newgen.wfdesktop.xmlapi.WDXMLTAGS"%>
<%@page import="java.io.File"%>
<%@page import="com.newgen.wfdesktop.baseclasses.PMSInfo"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.LinkedHashMap,com.newgen.mvcbeans.controller.helper.*,com.newgen.wfdesktop.util.WDUtility"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>



<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<html>
<%	
	String sCabname="";
	String sSessionId="";
	String sJtsIp="";
	int iJtsPort=0;
	boolean bError=false;
	String card="";
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("rakCard", request.getParameter("rakCard"), 1000, true) );
	String rakCard = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	
	WriteLog("Integration jsp: rakCard: "+rakCard);


	try
	{
	
	WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		sSessionId    = wDUserInfo.getM_strSessionId();
		sJtsIp = wDCabinetInfo.getM_strServerIP();
		iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
		
		if(sSessionId=="")
		{
			out.print("<script>window.close();</script>");		
		}
		
		
		
		card=rakCard;
		card=card.replaceAll("-","");
		card=card.substring(0,6);
	}
	catch(Exception ignore)
	{
		bError=true;
	}
	if (bError)
	{
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); 
	}

	String rakInputXML ="<?xml version=\"1.0\"?>" + 				
			"<AProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>get_rak_card_details</ProcName>" +
			"<Params>'Card Service Request - Balance Transfer'</Params>" +
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabname+"</EngineName>" +
			"</APProcedure2_Input>";

	String rakMappOutPutXML="";
	WriteLog("Rak Card Input XML :"+rakInputXML);			
			
	try
	{
		rakMappOutPutXML= WFCallBroker.execute(rakInputXML,sJtsIp,iJtsPort,1);
		WriteLog("Rak Card Output XML :"+rakMappOutPutXML);
		if(rakMappOutPutXML.equals("") || Integer.parseInt(rakMappOutPutXML.substring(rakMappOutPutXML.indexOf("<MainCode>")+10 , rakMappOutPutXML.indexOf("</MainCode>")))!=0)
		{
			bError= true;
		}
	}
	catch(Exception exp)
	{
		bError=true;
		out.println("Some Exception has occured");
	}

	String rakMapping = rakMappOutPutXML.substring(rakMappOutPutXML.indexOf("<Results>")+9,rakMappOutPutXML.indexOf("</Results>"));


	String [] rakArray = rakMapping.split("~");
	String flag="success";

	for(int i = 0;i<rakArray.length;i++)
	{
		if(rakArray[i].equalsIgnoreCase(card))
		{
			flag="fail";
			break;
		}
	}
%>
<SCRIPT>
	window.returnValue="<%=flag%>";
	window.close();
</SCRIPT>
</html>