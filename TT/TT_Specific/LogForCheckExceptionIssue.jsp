<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*,java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import ="java.text.DecimalFormat"%>
<%@ page import ="javax.xml.parsers.DocumentBuilder"%>
<%@ page import ="javax.xml.parsers.DocumentBuilderFactory"%>
<%@ page import ="org.w3c.dom.*"%>
<%@ page import ="org.xml.sax.InputSource"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant ,com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.*;"%>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<%@page conten	tType="text/html" pageEncoding="UTF-8"%>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("winame"), 1000, true) );
			String winame_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("indexofString"), 1000, true) );
			String indexofString_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			

	WriteLog("\n inside LogForCheckException.jsp");
	try
	{
	  String Winame=winame_Esapi;
	  //String outputxml=request.getParameter("responseAlreadyRaised");
	  String indexofvalue=indexofString_Esapi;
	  
	  WriteLog("\n Winame in LogForCheckException.jsp :"+Winame);
	  //WriteLog("\n outputxml in LogForCheckException.jsp :"+outputxml);
	  WriteLog("\n indexofvalue in LogForCheckException.jsp:"+indexofvalue);		
	}
	catch(Exception e) {
		WriteLog("\nException LogForCheckException.jsp :"+e);
	}
	out.clear();
	out.print("");
%>