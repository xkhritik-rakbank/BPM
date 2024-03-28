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
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
	WriteLog("Inside HandleAjaxRequest.jsp");
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 100000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("reqType_Esapi Request.getparameter---> "+request.getParameter("reqType"));
			WriteLog("reqType_Esapi Esapi---> "+reqType_Esapi);
			reqType_Esapi = reqType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepname"), 100000, true) );
			String workstepname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("workstepname_Esapi Request.getparameter---> "+request.getParameter("workstepname"));
			WriteLog("workstepname_Esapi Esapi---> "+workstepname_Esapi);
			workstepname_Esapi = workstepname_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("solId"), 100000, true) );
			String solId_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("solId_Esapi Request.getparameter---> "+request.getParameter("solId"));
			WriteLog("solId_Esapi Esapi---> "+solId_Esapi);
			solId_Esapi = solId_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("subSeg"), 100000, true) );
			String subSeg_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("subSeg_Esapi Request.getparameter---> "+request.getParameter("subSeg"));
			WriteLog("subSeg_Esapi Esapi---> "+subSeg_Esapi);
			subSeg_Esapi = subSeg_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rejReasonCodes"), 100000, true) );
			String rejReasonCodes_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("rejReasonCodes_Esapi Request.getparameter---> "+request.getParameter("rejReasonCodes"));
			WriteLog("rejReasonCodes_Esapi Esapi---> "+rejReasonCodes_Esapi);
			rejReasonCodes_Esapi = rejReasonCodes_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ").replaceAll("&#x27;","'");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("currCode"), 100000, true) );
			String currCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("currCode_Esapi Request.getparameter---> "+request.getParameter("currCode"));
			WriteLog("currCode_Esapi Esapi---> "+currCode_Esapi);
			currCode_Esapi = currCode_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("countryOfInc"), 100000, true) );
			String countryOfInc_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("countryOfInc_Esapi Request.getparameter---> "+request.getParameter("countryOfInc"));
			WriteLog("countryOfInc_Esapi Esapi---> "+countryOfInc_Esapi);
			countryOfInc_Esapi = countryOfInc_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("winame"), 100000, true) );
			String winame_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			WriteLog("winame_Esapi Request.getparameter---> "+request.getParameter("winame"));
			WriteLog("winame_Esapi Esapi---> "+winame_Esapi);
			winame_Esapi = winame_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("transType"), 100000, true) );
			String transType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			WriteLog("transType_Esapi Request.getparameter---> "+request.getParameter("transType"));
			WriteLog("transType_Esapi Esapi---> "+transType_Esapi);
			transType_Esapi = transType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("isElite"), 100000, true) );
			String isElite_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			WriteLog("isElite_Esapi Request.getparameter---> "+request.getParameter("isElite"));
			WriteLog("isElite_Esapi Esapi---> "+isElite_Esapi);
			isElite_Esapi = isElite_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sol_id"), 100000, true) );
			String sol_id_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
			WriteLog("sol_id_Esapi Request.getparameter---> "+request.getParameter("sol_id"));
			WriteLog("sol_id_Esapi Esapi---> "+sol_id_Esapi);
			sol_id_Esapi = sol_id_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("prevWs"), 100000, true) );
			String prevWs_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
			WriteLog("prevWs_Esapi Request.getparameter---> "+request.getParameter("prevWs"));
			WriteLog("prevWs_Esapi Esapi---> "+prevWs_Esapi);
			prevWs_Esapi = prevWs_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("countryName"), 100000, true) );
			String countryName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
			WriteLog("countryName_Esapi Request.getparameter---> "+request.getParameter("countryName"));
			WriteLog("countryName_Esapi Esapi---> "+countryName_Esapi);
			countryName_Esapi = countryName_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("strCode"), 100000, true) );
			String strCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
			WriteLog("strCode_Esapi Request.getparameter---> "+request.getParameter("strCode"));
			WriteLog("strCode_Esapi Esapi---> "+strCode_Esapi);
			strCode_Esapi = strCode_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("IBAN567Char"), 100000, true) );
			String IBAN567Char_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
			WriteLog("IBAN567Char_Esapi Request.getparameter---> "+request.getParameter("IBAN567Char"));
			WriteLog("IBAN567Char_Esapi Esapi---> "+IBAN567Char_Esapi);
			IBAN567Char_Esapi = IBAN567Char_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("remarksOnForm", request.getParameter("remarksOnForm"), 100000, true) );
			String remarksOnForm_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
			WriteLog("remarksOnForm_Esapi Request.getparameter---> "+request.getParameter("remarksOnForm"));
			WriteLog("remarksOnForm_Esapi Esapi---> "+remarksOnForm_Esapi);
			remarksOnForm_Esapi = remarksOnForm_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			
			String input19 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("isViewSignClicked", request.getParameter("isViewSignClicked"), 100000, true) );
			String isViewSignClickedVal_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
			WriteLog("isViewSignClickedVal_Esapi Request.getparameter---> "+request.getParameter("isViewSignClicked"));
			WriteLog("isViewSignClickedVal_Esapi Esapi---> "+isViewSignClickedVal_Esapi);
			
			
	String reqType = reqType_Esapi;	
	String userName = wDSession.getM_objUserInfo().getM_strUserName();	
	
	String returnValues = "";
	String query = "";
	
	String sCabName= wDSession.getM_objCabinetInfo().getM_strCabinetName();
	String sSessionId = wDSession.getM_objUserInfo().getM_strSessionId();	
	String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	int iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String sInputXML = "";
	String sOutputXML = "";
	String subXML="";
	
	//Extra String declared which can be required according to the request
	String rejReasonCodes = "";
	String solId = "";
	String wsname = "";
	String country = "";
	String currCode = "";	
	String subSeg = "";
	String winame = "";
	String transType = "";
	String isElite = "";
	String sol_id = "";
	String prevWs = "";
	String countryName = "";
	String strCode = "";
	
	//Constants that can be changed for group configuration
	String compGrp = "Compliance team";
    	
	//Getting parameteres according to the reqtype
	if (reqType.equals("DecisionDropDown"))
	{
		wsname = workstepname_Esapi;
	}
	else if (reqType.equals("frontOfficeMail"))
	{
		solId = solId_Esapi;
	}
	else if (reqType.equals("segmentComplianceMail")||reqType.equals("segmentNonComplianceMail") ||reqType.equals("IBMBNonComplianceMail") ||reqType.equals("IBMBComplianceMail"))
	{
		subSeg = subSeg_Esapi;
	}
	else if (reqType.equals("PSLSMEEmailForNonCompliance")||reqType.equals("PSLSMEEmailForCompliance"))
	{
		subSeg = subSeg_Esapi;
		solId = solId_Esapi;
	}
	else if (reqType.equals("rejectReasons"))
	{
		rejReasonCodes = rejReasonCodes_Esapi;
	}
	else if (reqType.equals("ibanValidation"))
	{
		currCode = currCode_Esapi;
		country =  countryOfInc_Esapi;
	}
	else if (reqType.equals("CallBackAutoRaiseCheck") || reqType.equals("ComplainceAutoRaiseCheck") || reqType.equals("SignAutoRaiseCheck") || reqType.equals("getCallBackRemarks"))	
		winame = winame_Esapi;
	else if (reqType.equals("dropDwnTranscode") || reqType.equals("changeTransCodeToRem"))
		transType = transType_Esapi;
	else if (reqType.equals("assignToBusiness"))
	{
		winame = winame_Esapi;
		isElite = isElite_Esapi;
		subSeg = subSeg_Esapi;
		sol_id = sol_id_Esapi;
		prevWs = prevWs_Esapi;
	}
	else if (reqType.equals("getCountryCode") || reqType.equals("getCountryCodeBenfCntry") || reqType.equals("getCountryCodeInterCntry"))
		countryName = countryName_Esapi;
	else if (reqType.equals("ENTITY_DETAILS") || reqType.equals("EXCHANGE_RATE_DETAILS") || reqType.equals("ACCOUNT_DETAILS")|| reqType.equals("MEMOPAD_DETAILS")|| reqType.equals("PAYMENT_DELETION")|| reqType.equals("PAYMENT_DETAILS")|| reqType.equals("EVENT_NOTIFICATION")|| reqType.equals("PAYMENT_REQ")|| reqType.equals("getCustomerType"))
		strCode = strCode_Esapi;
	else if (reqType.equals("decimalPoint"))
		currCode = currCode_Esapi;

	WriteLog("reqType = "+reqType);
	//WriteLog("userName = "+userName);

	//Build query for the request
	//Check the request Type
	if (reqType.equals("DecisionDropDown"))
		query = "SELECT value FROM USR_0_TT_ROUTE_DEC with(nolock) WHERE wsname='"+wsname+"'";
	else if (reqType.equals("frontOfficeMail"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where solId='"+solId+"'";
	else if (reqType.equals("PSLSMEEmailForNonCompliance"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where solId='"+solId+"' and subSegment='"+subSeg+"' and previousWorkstep='Others'";
	else if (reqType.equals("PSLSMEEmailForCompliance"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where solId='"+solId+"' and subSegment='"+subSeg+"' and previousWorkstep='Compliance'";
	else if (reqType.equals("eliteMailComp"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where elite='Y' and previousWorkstep='Compliance'";
	else if (reqType.equals("eliteMailOthers"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where elite='Y' and previousWorkstep='Others'";
	
	else if (reqType.equals("segmentComplianceMail"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where previousWorkstep='Compliance' and subsegment='"+subSeg+"'";
	else if (reqType.equals("segmentNonComplianceMail"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where previousWorkstep='Others' AND subsegment='"+subSeg+"'";
	else if (reqType.equals("IBMBNonComplianceMail"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where solId='NA' and subSegment='"+subSeg+"' and previousWorkstep='Others'";
	else if (reqType.equals("IBMBComplianceMail"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where solId='NA' and subSegment='"+subSeg+"' and previousWorkstep='Compliance'";	
	else if (reqType.equals("LangaugesDropDown"))
		query = "SELECT * FROM USR_0_TT_LanguageMaster";
	else if (reqType.equals("rejectReasons"))
		query = "SELECT item_desc FROM USR_0_TT_Error_Desc_Master WHERE Item_Code IN("+rejReasonCodes+")";
	else if (reqType.equals("ibanValidation"))
		query = "SELECT TOP 1 a.iban_Length,b.country FROM USR_0_TT_CountryMaster a with(nolock), USR_0_TT_IBANReqCountryMaster b with(nolock) WHERE a.countryCode = b.country AND a.countryName = '"+country+"' AND (b.currency = '"+currCode+"' OR b.currency = 'ALL')"; // changed Local to All - Changes done for Cross Border payment CR - 13082017
	else if (reqType.equals("CountryDropDown"))
		query = "SELECT countryname FROM USR_0_TT_CountryMaster with(nolock) order by countryname";
	else if (reqType.equals("CurrencyDropDown"))
		query = "SELECT curr_code FROM usr_0_tt_currencymaster with(nolock) ORDER BY curr_code";
	else if (reqType.equals("CallBackAutoRaiseCheck"))
		query= "SELECT TOP 1 Decision FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+winame+"' AND ExcpCode='005' ORDER BY ActionDateTime desc";
	else if (reqType.equals("ComplainceAutoRaiseCheck"))
		query= "SELECT TOP 1 Decision FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+winame+"' AND ExcpCode='006' ORDER BY ActionDateTime desc";
	else if (reqType.equals("SignAutoRaiseCheck"))
		query= "SELECT TOP 1 Decision FROM usr_0_tt_exception_history with(nolock) WHERE WIName='"+winame+"' AND ExcpCode='003' ORDER BY ActionDateTime desc";

	else if (reqType.equals("dropDownCallBackCustVerf") || reqType.equals("dropDownCallBackFailureReason") || reqType.equals("dropDownBenefBankCode") || reqType.equals("dropDownTranstype"))
		query= "SELECT value FROM USR_0_TT_ComboValues with(nolock) WHERE reqType='"+reqType+"'";
	else if (reqType.equals("dropDwnTranscode"))
		query= "SELECT TransactionTypeCode FROM USR_0_TT_TransactionTypeMaster with(nolock) WHERE TransactionType ='"+transType+"'  order by TransactionTypeCode asc"; // modified - Changes done for Cross Border payment CR - 13082017
	else if (reqType.equals("changeTransCodeToRem"))
		query= "SELECT  TransactionTypeCode FROM USR_0_TT_TransactionTypeMaster with(nolock) WHERE TransactionType ='"+transType+"' AND CrossBorderPayment='Local' order by TransactionTypeCode asc"; // changed All to Local - Changes done for Cross Border payment CR - 13082017
	else if (reqType.equals("handwrittenCases"))
		query= "SELECT formFieldName,labelMessage,type FROM USR_0_TT_HandWrittenCases with(nolock) WHERE mandatoryBefHandwritten='N' AND isHandwrittenField='Y' AND isActive='Y'";
	else if (reqType.equals("assignToCompliance"))
		query="SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+compGrp+"') AND usr.userindex = GRP.userindex";
	else if (reqType.equals("assignToBusiness"))
		query = getCSOExceptionQuery (winame,isElite,subSeg,sol_id,prevWs);
	else if (reqType.equals("getCountryCode") || reqType.equals("getCountryCodeBenfCntry")|| reqType.equals("getCountryCodeInterCntry"))
		query= "SELECT TOP 1 countryCode FROM USR_0_TT_CountryMaster with(nolock) WHERE countryName = '"+countryName+"'";
	else if (reqType.equals("ENTITY_DETAILS") || reqType.equals("EXCHANGE_RATE_DETAILS") || reqType.equals("ACCOUNT_DETAILS") || reqType.equals("MEMOPAD_DETAILS")|| reqType.equals("PAYMENT_DELETION") || reqType.equals("PAYMENT_DETAILS")|| reqType.equals("EVENT_NOTIFICATION")|| reqType.equals("PAYMENT_REQ"))
		query= "SELECT TOP 1 Host_Error_Description,Host_Error_Type FROM USR_0_Integration_Error_Codes with(nolock) WHERE Message_Format_Name = '"+reqType+"' AND Host_Error_Code = '"+strCode+"'";
	else if (reqType.equals("getCustomerType"))
		query = "SELECT top 1 customerType FROM USR_0_TT_CustomerTypeMaster WHERE customerCode='"+strCode+"'";
	else if (reqType.equals("decimalPoint"))
		query = "SELECT TOP 1 decimalPoint FROM USR_0_TT_CurrencyMaster WHERE curr_code = '"+currCode+"'";
	else if (reqType.equals("getCallBackRemarks"))
		query = "SELECT TOP 1 remarks FROM usr_0_tt_wihistory WHERE actiondatetime IS NOT NULL AND winame='"+winame+"' AND wsname='Callback' ORDER BY actiondatetime DESC";
	else if (reqType.equals("YAPSPOCMail"))
		query = "select top(1) emailId from USR_0_TT_EmailId_Master with(nolock) where solId='YAP'";
		
	else if (reqType.equals("BenefValidationBasedOnIBAN"))
	{
		String IBAN567Char = IBAN567Char_Esapi;
		query = "select IBAN567Chars,BenefName,BenefBankCode,BenefActualCode,TransCode,RemitAmtCurr from USR_0_TT_BenefValidationOnIBAN with (nolock) where IBAN567Chars = '"+IBAN567Char+"'";
	}
	else if (reqType.equals("SelectEnterRemarks"))
	{
		query = "select remarks from NG_TT_EXT_TABLE where wi_name = '"+winame_Esapi+"'";
	}
	else if (reqType.equals("SelectViewSignClicked"))
	{
		query = "select isViewSignClicked from NG_TT_EXT_TABLE where wi_name = '"+winame_Esapi+"'";
	}
	else if (reqType.equals("EnterRemarks"))
	{
		WriteLog("Inside enter remarks block");
		String tableName = "NG_TT_EXT_TABLE";
		String colName = "remarks";
		String values ="'"+remarksOnForm_Esapi+"'";
		
		sInputXML = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>" + tableName + "</TableName>" +
					"<ColName>" + colName + "</ColName>" +
					"<Values>" + values + "</Values>" +
					"<WhereClause>" + "wi_name='"+winame_Esapi+"'" + "</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";

		WriteLog("XML for saving remarks by stutee, input "+sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("XML for saving remarks by stutee, output"+sOutputXML);
	}
	else if (reqType.equals("isViewSignClicked"))
	{
		WriteLog("Inside enter isViewSignClicked block");
		String tableName = "NG_TT_EXT_TABLE";
		String colName = "isViewSignClicked";
		String values ="'"+isViewSignClickedVal_Esapi+"'";
		
		sInputXML = "<?xml version=\"1.0\"?>" +
				"<APUpdate_Input>" +
					"<Option>APUpdate</Option>" +
					"<TableName>" + tableName + "</TableName>" +
					"<ColName>" + colName + "</ColName>" +
					"<Values>" + values + "</Values>" +
					"<WhereClause>" + "wi_name='"+winame_Esapi+"'" + "</WhereClause>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
				"</APUpdate_Input>";

		WriteLog("XML for saving viewsign click as yes by stutee, input "+sInputXML);
		sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("XML for saving viewsign click as yes by stutee, output"+sOutputXML);
	}
	else if (reqType.equals("ForIDO_OPS"))
	{
		query ="select cif_id from usr_0_tt_IDO_CIF_Master where cif_id='"+solId_Esapi+"'";
		WriteLog("cif_id in handleajax:-"+solId_Esapi);
	}
	
	WriteLog("query -- "+query);
	
	sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";

	//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
	sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);	
	
	WriteLog("Output XML -- "+sOutputXML);

	xmlParserData=new XMLParser();
	xmlParserData.setInputXML((sOutputXML));
	String mainCodeValue = xmlParserData.getValueOf("MainCode");
	
	int recordcount=0;
	try{
		recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
	}catch(Exception e)	{}
	WriteLog("recordcount -- "+recordcount);
	
	if(mainCodeValue.equals("0"))
	{
		if (( reqType.equals("ibanValidation") || reqType.equals("BenefValidationBasedOnIBAN") ) && recordcount==0)
			returnValues = "NOT_REQUIRED";
		else
		{
			for(int k=0; k<recordcount; k++)
			{
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);

				if (reqType.equals("DecisionDropDown"))
					returnValues = objXmlParser.getValueOf("value");
				else if (reqType.equals("eliteMailComp")||reqType.equals("eliteMailOthers")||reqType.equals("frontOfficeMail")||reqType.equals("PSLSMEEmailForNonCompliance")||reqType.equals("PSLSMEEmailForCompliance")||reqType.equals("segmentComplianceMail")||reqType.equals("segmentNonComplianceMail")||reqType.equals("IBMBNonComplianceMail") || reqType.equals("IBMBComplianceMail") || reqType.equals("YAPSPOCMail"))
				
				
					returnValues = objXmlParser.getValueOf("emailId");
				else if (reqType.equals("CurrencyDropDown"))
					returnValues = returnValues+objXmlParser.getValueOf("curr_code")+",";
				else if (reqType.equals("SelectEnterRemarks")){
					returnValues = objXmlParser.getValueOf("remarks");
					WriteLog("SelectEnterRemarks returnValues -- "+returnValues);
					break;
				}
                else if (reqType.equals("SelectViewSignClicked")){
					returnValues = objXmlParser.getValueOf("isViewSignClicked");
					WriteLog("SelectViewSignClicked returnValues -- "+returnValues);
					break;
				} 				
				else if (reqType.equals("rejectReasons"))
					returnValues = returnValues+objXmlParser.getValueOf("item_desc")+",";
				else if (reqType.equals("LangaugesDropDown"))
					returnValues = returnValues + objXmlParser.getValueOf("language") + ",";
				else if (reqType.equals("ibanValidation"))
				{
					returnValues = objXmlParser.getValueOf("iban_Length");
					returnValues = returnValues + "," +objXmlParser.getValueOf("country");
				}
				else if (reqType.equals("CountryDropDown"))
					returnValues = returnValues + objXmlParser.getValueOf("countryname")  + "~";
				else if (reqType.equals("CallBackAutoRaiseCheck") || reqType.equals("ComplainceAutoRaiseCheck") || reqType.equals("SignAutoRaiseCheck"))
					returnValues = objXmlParser.getValueOf("Decision");
				else if (reqType.equals("dropDownCallBackCustVerf") || reqType.equals("dropDownCallBackFailureReason")|| reqType.equals("dropDownBenefBankCode")|| reqType.equals("dropDownTranstype"))
					returnValues = objXmlParser.getValueOf("value");
				else if (reqType.equals("dropDwnTranscode"))
					returnValues = returnValues + objXmlParser.getValueOf("TransactionTypeCode")  + ",";
				else if (reqType.equals("changeTransCodeToRem")) // added - Changes done for Cross Border payment CR - 13082017
					returnValues = returnValues +  objXmlParser.getValueOf("TransactionTypeCode") + ",";
				else if (reqType.equals("handwrittenCases"))
				{
					returnValues = returnValues + objXmlParser.getValueOf("formFieldName");
					returnValues = returnValues + "," + objXmlParser.getValueOf("labelMessage");
					returnValues = returnValues + "," + objXmlParser.getValueOf("type");
					returnValues = returnValues + "#";
				}
				else if (reqType.equals("assignToCompliance"))
					returnValues = returnValues + objXmlParser.getValueOf("username")  + ",";
				else if (reqType.equals("assignToBusiness"))
					returnValues = returnValues + objXmlParser.getValueOf("username")  + ",";
				else if (reqType.equals("getCountryCode") || reqType.equals("getCountryCodeBenfCntry")|| reqType.equals("getCountryCodeInterCntry"))
					returnValues = objXmlParser.getValueOf("countryCode");
				else if (reqType.equals("ENTITY_DETAILS") || reqType.equals("EXCHANGE_RATE_DETAILS") || reqType.equals("ACCOUNT_DETAILS") || reqType.equals("MEMOPAD_DETAILS")|| reqType.equals("PAYMENT_DELETION")|| reqType.equals("PAYMENT_DETAILS")|| reqType.equals("EVENT_NOTIFICATION")|| reqType.equals("PAYMENT_REQ"))
				{
					returnValues = objXmlParser.getValueOf("Host_Error_Description");
					returnValues = returnValues + "," +objXmlParser.getValueOf("Host_Error_Type");
				}
				else if (reqType.equals("getCustomerType"))
					returnValues = objXmlParser.getValueOf("customerType");
				else if (reqType.equals("decimalPoint"))
					returnValues = objXmlParser.getValueOf("decimalPoint");
				else if (reqType.equals("getCallBackRemarks"))
					returnValues = objXmlParser.getValueOf("remarks");
					
				else if (reqType.equals("BenefValidationBasedOnIBAN"))
				{
					returnValues = returnValues + objXmlParser.getValueOf("IBAN567Chars");
					returnValues = returnValues + "," + objXmlParser.getValueOf("BenefName");
					returnValues = returnValues + "," + objXmlParser.getValueOf("BenefBankCode");
					returnValues = returnValues + "," + objXmlParser.getValueOf("BenefActualCode");
					returnValues = returnValues + "," + objXmlParser.getValueOf("TransCode");
					returnValues = returnValues + "," + objXmlParser.getValueOf("RemitAmtCurr");
				}
				else if(reqType.equals("ForIDO_OPS")){
					WriteLog("inside forido_ops -- ");
					returnValues = returnValues + xmlParserData.getValueOf("TotalRetrieved");
					WriteLog("returnValues -- "+returnValues);
				}
			}
		}
	}

	//WriteLog("returnValues -- "+returnValues);

	if (reqType.equals("LangaugesDropDown") || reqType.equals("CurrencyDropDown") || reqType.equals("dropDwnTranscode") || 
		reqType.equals("assignToCompliance") || reqType.equals("assignToBusiness") || reqType.equals("changeTransCodeToRem"))
		returnValues = returnValues.replaceAll("(,)*$", "");
	else if (reqType.equals("handwrittenCases"))
		returnValues = returnValues.replaceAll("(#)*$", "");	
	else if (reqType.equals("CountryDropDown"))
		returnValues = returnValues.replaceAll("(~)*$", "");
	else if (reqType.equals("rejectReasons") && returnValues!=null && returnValues!="")
		returnValues = returnValues.substring(0,returnValues.length()-1);
		
		
	//WriteLog("sOutputXML -- "+sOutputXML);
	WriteLog("returnValues -- "+returnValues);
	out.clear();
	out.print(returnValues);
%>
<%!
String getCSOExceptionQuery (String winame,String isElite,String subSeg,String sol_id,String prevWs)
{
	String query = "";
	String wmControlsUsrGroups = "TT_WM Controls";
	String smeUsrGroups = "SME";
	String cbdRoUsrGroups = "CBD RO";
	String csoUsrGroups = "TT_CSO_0038";
	String wmCsoUnitUsrGroups = "WM CSO Unit";
	
	if (prevWs.equals("Comp_Check"))
	{
		if (isElite.equals("Y"))
		{
			query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+wmControlsUsrGroups+"') AND usr.userindex = GRP.userindex";
		}
		else
		{
			//Check segment now
			if (subSeg.equals("PBN") || subSeg.equals("PRS") || subSeg.equals("PAM"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+wmControlsUsrGroups+"') AND usr.userindex = GRP.userindex";
			}
			else if (subSeg.equals("PSL") || subSeg.equals("SME"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+smeUsrGroups+"') AND usr.userindex = GRP.userindex";
			}
			else if (subSeg.equals("CBD"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+cbdRoUsrGroups+"') AND usr.userindex = GRP.userindex";
			}
		}
	}
	else
	{
		if (isElite.equals("Y"))
		{
			query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+wmCsoUnitUsrGroups+"') AND usr.userindex = GRP.userindex";
		}
		else
		{
			//Check segment now
			if (subSeg.equals("PRS") || subSeg.equals("PAM"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+wmCsoUnitUsrGroups+"') AND usr.userindex = GRP.userindex";
			}
			else if (subSeg.equals("PSL") || subSeg.equals("SME"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+smeUsrGroups+"') AND usr.userindex = GRP.userindex";
			}
			else if (subSeg.equals("CBD"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+cbdRoUsrGroups+"') AND usr.userindex = GRP.userindex";
			}
			else if (subSeg.equals("PBN"))
			{
				query = "SELECT USR.username FROM PDBGroupMember GRP WITH (nolock), PDBUser USR WITH(nolock) WHERE GroupIndex = (SELECT GroupIndex FROM PDBGroup WITH (nolock) WHERE GroupName = '"+csoUsrGroups+"') AND usr.userindex = GRP.userindex AND USR.comment ='"+sol_id+"'";
			}
		}
	}
	return query;
}

%>