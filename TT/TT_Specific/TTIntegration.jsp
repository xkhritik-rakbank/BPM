<%@ include file="ajaxlog.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@ page import="com.newgen.wfdesktop.util.*"%>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*"%>
<%@ page import="com.newgen.custom.*"%>
<%@ page import="javax.crypto.Cipher"%>
<%@ page import="javax.crypto.spec.SecretKeySpec"%>
<%@ page import="java.io.UnsupportedEncodingException"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
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
			WriteLog("Inside Esapi---> ");
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("requestType"), 100000, true) );
			String requestType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("requestType_Esapi Request.getparameter---> "+request.getParameter("requestType"));
			WriteLog("requestType_Esapi Esapi---> "+requestType_Esapi);
			requestType_Esapi = requestType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("debt_acc_num"), 100000, true) );
			String debt_acc_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("debt_acc_num_Esapi Request.getparameter---> "+request.getParameter("debt_acc_num"));
			WriteLog("debt_acc_num_Esapi Esapi---> "+debt_acc_num_Esapi);
			debt_acc_num_Esapi = debt_acc_num_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cif"), 100000, true) );
			String cif_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("cif_Esapi Request.getparameter---> "+request.getParameter("cif"));
			WriteLog("cif_Esapi Esapi---> "+cif_Esapi);
			cif_Esapi = cif_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("remitCurrType"), 100000, true) );
			String remitCurrType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			WriteLog("remitCurrType_Esapi Request.getparameter---> "+request.getParameter("remitCurrType"));
			WriteLog("remitCurrType_Esapi Esapi---> "+remitCurrType_Esapi);
			remitCurrType_Esapi = remitCurrType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("transCurrType"), 100000, true) );
			String transCurrType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			WriteLog("transCurrType_Esapi Request.getparameter---> "+request.getParameter("transCurrType"));
			WriteLog("transCurrType_Esapi Esapi---> "+transCurrType_Esapi);
			transCurrType_Esapi = transCurrType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("debitCurrType"), 100000, true) );
			String debitCurrType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			WriteLog("debitCurrType_Esapi Request.getparameter---> "+request.getParameter("debitCurrType"));
			WriteLog("debitCurrType_Esapi Esapi---> "+debitCurrType_Esapi);
			debitCurrType_Esapi = debitCurrType_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tranAmountWithoutComma"), 100000, true) );
			String tranAmountWithoutComma_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			WriteLog("tranAmountWithoutComma_Esapi Request.getparameter---> "+request.getParameter("tranAmountWithoutComma"));
			WriteLog("tranAmountWithoutComma_Esapi Esapi---> "+tranAmountWithoutComma_Esapi);
			tranAmountWithoutComma_Esapi = tranAmountWithoutComma_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("isbankemployee"), 100000, true) );
			String isbankemployee_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			WriteLog("isbankemployee_Esapi Request.getparameter---> "+request.getParameter("isbankemployee"));
			WriteLog("isbankemployee_Esapi Esapi---> "+isbankemployee_Esapi);
			isbankemployee_Esapi = isbankemployee_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("cifid"), 100000, true) );
			String cifid_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			WriteLog("cifid_Esapi Request.getparameter---> "+request.getParameter("cifid"));
			WriteLog("cifid_Esapi Esapi---> "+cifid_Esapi);
			cifid_Esapi = cifid_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ttrefno"), 100000, true) );
			String ttrefno_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			WriteLog("ttrefno_Esapi Request.getparameter---> "+request.getParameter("ttrefno"));
			WriteLog("ttrefno_Esapi Esapi---> "+ttrefno_Esapi);
			ttrefno_Esapi = ttrefno_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("deletionReason"), 100000, true) );
			String deletionReason_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
			WriteLog("deletionReason_Esapi Request.getparameter---> "+request.getParameter("deletionReason"));
			WriteLog("deletionReason_Esapi Esapi---> "+deletionReason_Esapi);
			deletionReason_Esapi = deletionReason_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("callBackSuccessFlag"), 100000, true) );
			String callBackSuccessFlag_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
			WriteLog("callBackSuccessFlag_Esapi Request.getparameter---> "+request.getParameter("callBackSuccessFlag"));
			WriteLog("callBackSuccessFlag_Esapi Esapi---> "+callBackSuccessFlag_Esapi);
			callBackSuccessFlag_Esapi = callBackSuccessFlag_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("refCountrySuccessFlag"), 100000, true) );
			String refCountrySuccessFlag_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
			WriteLog("refCountrySuccessFlag_Esapi Request.getparameter---> "+request.getParameter("refCountrySuccessFlag"));
			WriteLog("refCountrySuccessFlag_Esapi Esapi---> "+refCountrySuccessFlag_Esapi);
			refCountrySuccessFlag_Esapi = refCountrySuccessFlag_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("callBackRemarks"), 100000, true) );
			String callBackRemarks_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
			WriteLog("callBackRemarks_Esapi Request.getparameter---> "+request.getParameter("callBackRemarks"));
			WriteLog("callBackRemarks_Esapi Esapi---> "+callBackRemarks_Esapi);
			callBackRemarks_Esapi = callBackRemarks_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("callbackwaiver"), 100000, true) );
			String callbackwaiver_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
			WriteLog("callbackwaiver_Esapi Request.getparameter---> "+request.getParameter("callbackwaiver"));
			WriteLog("callbackwaiver_Esapi Esapi---> "+callbackwaiver_Esapi);
			callbackwaiver_Esapi = callbackwaiver_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("isrulingfamily"), 100000, true) );
			String isrulingfamily_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
			WriteLog("isrulingfamily_Esapi Request.getparameter---> "+request.getParameter("isrulingfamily"));
			WriteLog("isrulingfamily_Esapi Esapi---> "+isrulingfamily_Esapi);
			isrulingfamily_Esapi = isrulingfamily_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("callbackflagFromFinacle"), 100000, true) );
			String callbackflagFromFinacle_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
			WriteLog("callbackflagFromFinacle_Esapi Request.getparameter---> "+request.getParameter("callbackflagFromFinacle"));
			WriteLog("callbackflagFromFinacle_Esapi Esapi---> "+callbackflagFromFinacle_Esapi);
			callbackflagFromFinacle_Esapi = callbackflagFromFinacle_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("compflagFromFinacle"), 100000, true) );
			String compflagFromFinacle_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
			WriteLog("compflagFromFinacle_Esapi Request.getparameter---> "+request.getParameter("compflagFromFinacle"));
			WriteLog("compflagFromFinacle_Esapi Esapi---> "+compflagFromFinacle_Esapi);
			compflagFromFinacle_Esapi = compflagFromFinacle_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("rateCode"), 100000, true) );
			String rateCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
			WriteLog("rateCode_Esapi Request.getparameter---> "+request.getParameter("rateCode"));
			WriteLog("rateCode_Esapi Esapi---> "+rateCode_Esapi);
			rateCode_Esapi = rateCode_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("tramtWithoutComma"), 100000, true) );
			String tramtWithoutComma_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
			WriteLog("tramtWithoutComma_Esapi Request.getparameter---> "+request.getParameter("tramtWithoutComma"));
			WriteLog("tramtWithoutComma_Esapi Esapi---> "+tramtWithoutComma_Esapi);
			tramtWithoutComma_Esapi = tramtWithoutComma_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input22 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("trcry"), 100000, true) );
			String trcry_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input22!=null?input22:"");
			WriteLog("trcry_Esapi Request.getparameter---> "+request.getParameter("trcry"));
			WriteLog("trcry_Esapi Esapi---> "+trcry_Esapi);
			trcry_Esapi = trcry_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input23 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("crcry"), 100000, true) );
			String crcry_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input23!=null?input23:"");
			WriteLog("crcry_Esapi Request.getparameter---> "+request.getParameter("crcry"));
			WriteLog("crcry_Esapi Esapi---> "+crcry_Esapi);
			crcry_Esapi = crcry_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input24 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("dacry"), 100000, true) );
			String dacry_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input24!=null?input24:"");
			WriteLog("dacry_Esapi Request.getparameter---> "+request.getParameter("dacry"));
			WriteLog("dacry_Esapi Esapi---> "+dacry_Esapi);
			dacry_Esapi = dacry_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input25 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bfNm"), 100000, true) );
			String bfNm_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input25!=null?input25:"");
			WriteLog("bfNm_Esapi Request.getparameter---> "+request.getParameter("bfNm"));
			WriteLog("bfNm_Esapi Esapi---> "+bfNm_Esapi);
			bfNm_Esapi = bfNm_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			//String bfname_url = URLDecoder.decode(request.getParameter("bfname"));
			String input26 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bfname"), 100000, true) );
			String bfname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input26!=null?input26:"");
			WriteLog("bfname_Esapi Request.getparameter---> "+request.getParameter("bfname"));
			WriteLog("bfname_Esapi Esapi---> "+bfname_Esapi);
			bfname_Esapi = bfname_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			//String bfAddress1_url = URLDecoder.decode(request.getParameter("bfAddress1"));
			String input27 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bfAddress1"), 100000, true) );
			String bfAddress1_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input27!=null?input27:"");
			WriteLog("bfAddress1_Esapi Request.getparameter---> "+request.getParameter("bfAddress1"));
			WriteLog("bfAddress1_Esapi Esapi---> "+bfAddress1_Esapi);
			bfAddress1_Esapi = bfAddress1_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			//String bfAddress2_url = URLDecoder.decode(request.getParameter("bfAddress2"));
			String input28 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bfAddress2"), 100000, true) );
			String bfAddress2_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input28!=null?input28:"");
			WriteLog("bfAddress2_Esapi Request.getparameter---> "+request.getParameter("bfAddress2"));
			WriteLog("bfAddress2_Esapi Esapi---> "+bfAddress2_Esapi);
			bfAddress2_Esapi = bfAddress2_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input29 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bfCy"), 100000, true) );
			String bfCy_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input29!=null?input29:"");
			WriteLog("bfCy_Esapi Request.getparameter---> "+request.getParameter("bfCy"));
			WriteLog("bfCy_Esapi Esapi---> "+bfCy_Esapi);
			bfCy_Esapi = bfCy_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input30 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bbbr"), 100000, true) );
			String bbbr_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input30!=null?input30:"");
			WriteLog("bbbr_Esapi Request.getparameter---> "+request.getParameter("bbbr"));
			WriteLog("bbbr_Esapi Esapi---> "+bbbr_Esapi);
			bbbr_Esapi = bbbr_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input31 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bfAc"), 100000, true) );
			String bfAc_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input31!=null?input31:"");
			WriteLog("bfAc_Esapi Request.getparameter---> "+request.getParameter("bfAc"));
			WriteLog("bfAc_Esapi Esapi---> "+bfAc_Esapi);
			bfAc_Esapi = bfAc_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input32 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bbcy"), 100000, true) );
			String bbcy_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input32!=null?input32:"");
			WriteLog("bbcy_Esapi Request.getparameter---> "+request.getParameter("bbcy"));
			WriteLog("bbcy_Esapi Esapi---> "+bbcy_Esapi);
			bbcy_Esapi = bbcy_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input33 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("chg"), 100000, true) );
			String chg_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input33!=null?input33:"");
			WriteLog("chg_Esapi Request.getparameter---> "+request.getParameter("chg"));
			WriteLog("chg_Esapi Esapi---> "+chg_Esapi);
			chg_Esapi = chg_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input34 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bbn"), 100000, true) );
			String bbn_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input34!=null?input34:"");
			WriteLog("bbn_Esapi Request.getparameter---> "+request.getParameter("bbn"));
			WriteLog("bbn_Esapi Esapi---> "+bbn_Esapi);
			bbn_Esapi = bbn_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input35 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("bbcn"), 100000, true) );
			String bbcn_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input35!=null?input35:"");
			WriteLog("bbcn_Esapi Request.getparameter---> "+request.getParameter("bbcn"));
			WriteLog("bbcn_Esapi Esapi---> "+bbcn_Esapi);
			bbcn_Esapi = bbcn_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input36 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wiNo"), 100000, true) );
			String wiNo_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input36!=null?input36:"");
			WriteLog("wiNo_Esapi Request.getparameter---> "+request.getParameter("wiNo"));
			WriteLog("wiNo_Esapi Esapi---> "+wiNo_Esapi);
			wiNo_Esapi = wiNo_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input37 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("org"), 100000, true) );
			String org_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input37!=null?input37:"");
			WriteLog("org_Esapi Request.getparameter---> "+request.getParameter("org"));
			WriteLog("org_Esapi Esapi---> "+org_Esapi);
			org_Esapi = org_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input38 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("exRate"), 100000, true) );
			String exRate_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input38!=null?input38:"");
			WriteLog("exRate_Esapi Request.getparameter---> "+request.getParameter("exRate"));
			WriteLog("exRate_Esapi Esapi---> "+exRate_Esapi);
			exRate_Esapi = exRate_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input39 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("benefcity"), 100000, true) );
			String benefcity_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input39!=null?input39:"");
			WriteLog("benefcity_Esapi Request.getparameter---> "+request.getParameter("benefcity"));
			WriteLog("benefcity_Esapi Esapi---> "+benefcity_Esapi);
			benefcity_Esapi = benefcity_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input40 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("txnTypeCode"), 100000, true) );
			String txnTypeCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input40!=null?input40:"");
			WriteLog("txnTypeCode_Esapi Request.getparameter---> "+request.getParameter("txnTypeCode"));
			WriteLog("txnTypeCode_Esapi Esapi---> "+txnTypeCode_Esapi);
			txnTypeCode_Esapi = txnTypeCode_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input41 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("countryCode"), 100000, true) );
			String countryCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input41!=null?input41:"");
			WriteLog("countryCode_Esapi Request.getparameter---> "+request.getParameter("countryCode"));
			WriteLog("countryCode_Esapi Esapi---> "+countryCode_Esapi);
			countryCode_Esapi = countryCode_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input42 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("interBankName"), 100000, true) );
			String interBankName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input42!=null?input42:"");
			WriteLog("interBankName_Esapi Request.getparameter---> "+request.getParameter("interBankName"));
			WriteLog("interBankName_Esapi Esapi---> "+interBankName_Esapi);
			interBankName_Esapi = interBankName_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input43 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("interBankBranch"), 100000, true) );
			String interBankBranch_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input43!=null?input43:"");
			WriteLog("interBankBranch_Esapi Request.getparameter---> "+request.getParameter("interBankBranch"));
			WriteLog("interBankBranch_Esapi Esapi---> "+interBankBranch_Esapi);
			interBankBranch_Esapi = interBankBranch_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input44 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("interCityState"), 100000, true) );
			String interCityState_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input44!=null?input44:"");
			WriteLog("interCityState_Esapi Request.getparameter---> "+request.getParameter("interCityState"));
			WriteLog("interCityState_Esapi Esapi---> "+interCityState_Esapi);
			interCityState_Esapi = interCityState_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input45 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("interBankCntry"), 100000, true) );
			String interBankCntry_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input45!=null?input45:"");
			WriteLog("interBankCntry_Esapi Request.getparameter---> "+request.getParameter("interBankCntry"));
			WriteLog("interBankCntry_Esapi Esapi---> "+interBankCntry_Esapi);
			interBankCntry_Esapi = interBankCntry_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			//String pop1_url = URLDecoder.decode(request.getParameter("pop1"));
			String input46 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("pop1"), 100000, true) );
			String pop1_url_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input46!=null?input46:"");
			WriteLog("pop1_url_Esapi Request.getparameter---> "+request.getParameter("pop1"));
			WriteLog("pop1_url_Esapi Esapi---> "+pop1_url_Esapi);
			pop1_url_Esapi = pop1_url_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			//String pop2_url = URLDecoder.decode(request.getParameter("pop2"));
			String input47 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("pop2"), 100000, true) );
			String pop2_url_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input47!=null?input47:"");
			WriteLog("pop2_url_Esapi Request.getparameter---> "+request.getParameter("pop2"));
			WriteLog("pop2_url_Esapi Esapi---> "+pop2_url_Esapi);
			pop2_url_Esapi = pop2_url_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			//String pop3_url = URLDecoder.decode(request.getParameter("pop3"));
			String input48 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("pop3"), 100000, true) );
			String pop3_url_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input48!=null?input48:"");
			WriteLog("pop3_url_Esapi Request.getparameter---> "+request.getParameter("pop3"));
			WriteLog("pop3_url_Esapi Esapi---> "+pop3_url_Esapi);
			pop3_url_Esapi = pop3_url_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input49 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("paymentRefNo"), 100000, true) );
			String paymentRefNo_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input49!=null?input49:"");
			WriteLog("paymentRefNo_Esapi Request.getparameter---> "+request.getParameter("paymentRefNo"));
			WriteLog("paymentRefNo_Esapi Esapi---> "+paymentRefNo_Esapi);
			paymentRefNo_Esapi = paymentRefNo_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
			
			String input50 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 100000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input50!=null?input50:"");
			WriteLog("wi_name Request.getparameter---> "+request.getParameter("wi_name"));
			WriteLog("wi_name Esapi---> "+wi_name_Esapi);
			wi_name_Esapi = wi_name_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x2f;","/").replaceAll("&amp;&#x23;x19&#x3b;","").replaceAll("&amp;&#x23;x15&#x3b;"," ");
	
	WriteLog("Inside end.jsp");
	String sInputXML = "";
	String sMappOutPutXML = "";
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	java.util.Date currentDate = new java.util.Date();
	String dateToPass = sdf.format(currentDate);
	try{
		WriteLog("Inside TTIntegration.jsp");
		WriteLog(dateToPass);
		
		String requestType = requestType_Esapi;
		String debt_acc_num = debt_acc_num_Esapi;
		
		WriteLog("request Type - "+requestType+"	debt_acc_num="+debt_acc_num);
		
		if (requestType.equals("ACCOUNT_BALANCE_DETAILS"))
		{
				/*sInputXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessage</Option>\n"+
					"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
					"<AccountNumber>"+debt_acc_num+"</AccountNumber>\n"+ 
					"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
					"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
					"<RequestType>ACCOUNT_DETAILS</RequestType>\n" +
					"</TT_APMQPutGetMessage_Input>";
			*/
			
			sInputXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
					"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
					"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
					"<RequestType>ACCOUNT_DETAILS</RequestType>\n" +
					"<EE_EAI_BODY>\n"+
					"<ProcessName>TT</ProcessName>\n" +
					"<AccountDetails><BankId>RAK</BankId><CustId></CustId><Acid>"+debt_acc_num+"</Acid><BranchId></BranchId><AcType></AcType><BackendName></BackendName></AccountDetails>\n" +
					"</EE_EAI_BODY>\n"+
					"</TT_APMQPutGetMessage_Input>";
				WriteLog("sInputXML  for Account balance details.... "+sInputXML);	
			//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			 sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					
			//sMappOutPutXML = "<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>ACCOUNT_BALANCE_DETAILS</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>accdettest01</MessageId><Extra1>REP||LAXMANRET.LAXMANRET</Extra1><Extra2>2015-05-30T22:30:14.544+05:30</Extra2></EE_EAI_HEADER><AccountBalanceDetails><BankId>RAK</BankId><CustId>0300300</CustId><BankName>RAK</BankName><BranchId>003</BranchId><BranchName>Dragon Mart</BranchName><Acid>0006237614100</Acid><AcctCurr>AED</AcctCurr><SchemeCode>ODA</SchemeCode ><SchemeType>001</SchemeType ><AcctBal><BalType>EFFAVL</BalType><Amount>5456.00</Amount><CurrencyCode>AED</CurrencyCode></AcctBal><Addr1>fdg</Addr1><Addr2>dfgd</Addr2><Addr3>dfg</Addr3><City>DXB</City><StateProv>DXB</StateProv><PostalCode>1555</PostalCode><Country>UAE</Country><AddrType>sadas</AddrType></AccountBalanceDetails></EE_EAI_MESSAGE>";
			
				WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
		else if (requestType.equals("EXCHANGE_RATE_INQUIRY") || requestType.equals("MID_RATE_INQUIRY"))
		{
			WriteLog("Working for "+requestType);
			String cifID = cif_Esapi;
			String remitCurrType = remitCurrType_Esapi;
			String transCurrType = transCurrType_Esapi;
			String debitCurrType = debitCurrType_Esapi;
			String tranAmount = tranAmountWithoutComma_Esapi;
			String isbankemployee = isbankemployee_Esapi;
			String txnType = "";
			if(isbankemployee.equalsIgnoreCase("Y"))
			{ 
				txnType="BPM";
			}
			else
			{
				txnType="";
			}
			String rateCode = "";
			
			
			//Overriding the rateCode for midrate call
            if (requestType.equals("MID_RATE_INQUIRY"))
                rateCode = "MID";
				
			/*sInputXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessage</Option>\n"+
					"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
					"<DbtCurCode>"+remitCurrType+"</DbtCurCode>\n" +
					"<CrdCurCode>"+transCurrType+"</CrdCurCode>\n" +
					"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
					"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
					"<RequestType>EXCHANGE_RATE_DETAILS</RequestType>\n" +
					"</TT_APMQPutGetMessage_Input>";

			*/
			sInputXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
					"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
					"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
					"<RequestType>EXCHANGE_RATE_DETAILS</RequestType>\n" +
					"<EE_EAI_BODY>\n"+
					"<ProcessName>TT</ProcessName>\n" +
					"<ExchangeRateCriteria><BankId>RAK</BankId><CustId>"+debt_acc_num+"</CustId><Ratecode>"+rateCode+"</Ratecode><Currentdate>2016-02-22T18:51:40.664+05:30</Currentdate><DbtCurCode>"+debitCurrType+"</DbtCurCode><CrdCurCode>"+remitCurrType+"</CrdCurCode><TxnAmount>"+tranAmount+"</TxnAmount><TxnCurCode>"+transCurrType+"</TxnCurCode><HomeCurCode>AED</HomeCurCode><TxnType>"+txnType+"</TxnType><TargetSystem>FIN</TargetSystem><DealNumber/></ExchangeRateCriteria>\n" +
					"</EE_EAI_BODY>\n"+
					"</TT_APMQPutGetMessage_Input>";
			
			WriteLog("sInputXML - "+sInputXML);
			//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			 sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			//sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>EXCHANGE_RATE_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>MW_EXCHANGE_RATE_DETAILS_T01</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><ExchangeRate><FxdCurUnits>1</FxdCurUnits><FxdCurCode>AED</FxdCurCode><VarCurUnits>3.67</VarCurUnits><VarCurCode>USD</VarCurCode><RateMode>N</RateMode><OutputAmount>234324323</OutputAmount><RateCode>TTB</RateCode></ExchangeRate></EE_EAI_MESSAGE>";
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
		else if (requestType.equals("SIGNATURE_DETAILS"))
		{
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>SIGNATURE_DETAILS</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<SignatureDetailsReq><BankId>RAK</BankId><CustId></CustId><AcctId>"+debt_acc_num+"</AcctId></SignatureDetailsReq>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
			WriteLog("sInputXML - "+sInputXML);	
			//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			//sMappOutPutXML = "<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>SIGNATURE_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>MDL053169113</MessageId><Extra1>REP||PERCOMER.PERCOMER</Extra1><Extra2>2007-01-01T10:30:30.000Z</Extra2></EE_EAI_HEADER><SignatureDetailsRes><BankId>RAK</BankId><CustId>0300300</CustId><RuleData><RuleDesc>0300300</RuleDesc><RuleName>0300300</RuleName></RuleData><SignatureData><isActive>Y</isActive><isExpired>N</isExpired><isMandatory>Y</isMandatory><isViewRestricted>Y</isViewRestricted><remarks>KYCForm</remarks><returnedSignature>wedsfsdfsdfdfsfsdf</returnedSignature></SignatureData></SignatureDetailsRes></EE_EAI_MESSAGE>";
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
		else if (requestType.equals("MEMOPAD_DETAILS_LIST"))
		{
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>MEMOPAD_DETAILS</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<MemoDetailsReq><BankId>RAK</BankId><CustId></CustId><AcctId>"+debt_acc_num+"</AcctId></MemoDetailsReq>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
			WriteLog("sInputXML - "+sInputXML);	
			//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			
			//sMappOutPutXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>MEMOPAD_DETAILS_LIST</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>MDL053169Pt21111</MessageId><Extra1>REP||PERCOMER.PERCOMER</Extra1><Extra2>2007-01-01T10:30:30.000Z</Extra2></EE_EAI_HEADER><MemoDetailsRes><BankId>RAK</BankId><CustId>0300300</CustId><AcctId>0002112717001</AcctId><AcctNotes><CreatedBy>aaaaaaa</CreatedBy><CreationDt>2014-12-12</CreationDt><ExpiryDt>2015-12-12</ExpiryDt><NoteText>aaaaaaaaaaaaaaaa</NoteText></AcctNotes></MemoDetailsRes></EE_EAI_MESSAGE>";
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);	
		}
		else if (requestType.equals("PAYMENT_DELETION"))
		{
			//payment deletion fields
			String cifid = cifid_Esapi;
			String ttrefno = ttrefno_Esapi;
			String deletionReason = deletionReason_Esapi;
			
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>PAYMENT_DELETION</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<PaymentCancellationReq><BankId>RAK</BankId><CIFId>"+cifid+"</CIFId><PODetails><PONumber>"+ttrefno+"</PONumber><Reason>"+deletionReason+"</Reason></PODetails></PaymentCancellationReq>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
			
			WriteLog("sInputXML - "+sInputXML);
			
			//sMappOutPutXML=WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			
			//sMappOutPutXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>PAYMENT_DELETION</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>EBC.INB</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>UTC_MW_PAYMENT_DELETION_T01</MessageId><Extra1>REP||LAXMANRET.LAXMANRET</Extra1><Extra2>2015-06-25T16:45:16.141+05:30</Extra2></EE_EAI_HEADER><PaymentCancellationRes><BankId>RAK</BankId><CIFId>0300300</CIFId><CancellationStatus><PONumber>123456789012</PONumber><DelIndicator>Y</DelIndicator><POStatus>P</POStatus></CancellationStatus><CancellationStatus><PONumber>1234568</PONumber><DelIndicator>N</DelIndicator><POStatus>N</POStatus></CancellationStatus><CancellationStatus><PONumber>1234569</PONumber><DelIndicator>Y</DelIndicator><POStatus>D</POStatus></CancellationStatus></PaymentCancellationRes></EE_EAI_MESSAGE>";
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
		else if (requestType.equals("EVENT_NOTIFICATION"))
		{
			String callbackflag = callBackSuccessFlag_Esapi;
			String refcountryflag = refCountrySuccessFlag_Esapi;
			String callbackremarks = callBackRemarks_Esapi;
			String callbackwaiver = callbackwaiver_Esapi;
			String isrulingfamily = isrulingfamily_Esapi;
			//if(callbackremarks.equalsIgnoreCase(""))
				//callbackremarks="~";
			

			String callbackflagFromFinacle = callbackflagFromFinacle_Esapi;
			String compflagFromFinacle = compflagFromFinacle_Esapi;
			
			String ttrefno =ttrefno_Esapi;
			
			if(callbackflag.equalsIgnoreCase("") || callbackflag.equalsIgnoreCase("--Select--")) callbackflag="N";
			if(refcountryflag.equalsIgnoreCase("") || refcountryflag.equalsIgnoreCase("--Select--")) refcountryflag="N";
			if(callbackflag.equalsIgnoreCase("No")) callbackflag="N";
			if(refcountryflag.equalsIgnoreCase("Yes")) refcountryflag="Y";
			if(callbackflag.equalsIgnoreCase("Yes")) callbackflag="Y";
			if(refcountryflag.equalsIgnoreCase("No")) refcountryflag="N";
			
			if(callbackflagFromFinacle.equalsIgnoreCase("") || callbackflagFromFinacle.equalsIgnoreCase("--Select--")) callbackflagFromFinacle="N";
			if(compflagFromFinacle.equalsIgnoreCase("") || compflagFromFinacle.equalsIgnoreCase("--Select--")) compflagFromFinacle="N";
			if(callbackflagFromFinacle.equalsIgnoreCase("No")) callbackflagFromFinacle="N";
			if(compflagFromFinacle.equalsIgnoreCase("Yes")) compflagFromFinacle="Y";
			if(callbackflagFromFinacle.equalsIgnoreCase("Yes")) callbackflagFromFinacle="Y";
			if(compflagFromFinacle.equalsIgnoreCase("No")) compflagFromFinacle="N";
			
			WriteLog("callbacksuccessflag.."+callbackflag);	
			WriteLog("callbackflagFromFinacle.."+callbackflagFromFinacle);	
			WriteLog("refcountrysuccessflag.."+refcountryflag);	
			WriteLog("compflagFromFinacle.."+compflagFromFinacle);	
			WriteLog("callbackremarks.."+callbackremarks);	
			WriteLog("ttrefno.."+ttrefno);
	
			if((callbackflagFromFinacle.equalsIgnoreCase("Y") && compflagFromFinacle.equalsIgnoreCase("N")))
			{

				if((callbackflag.equalsIgnoreCase("Y") && isrulingfamily.equalsIgnoreCase("No"))|| callbackwaiver.equalsIgnoreCase("N"))
				{
				WriteLog("for callbackwaiver.."+callbackflag);	
					callbackwaiver="";
				}
				
				sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>EVENT_NOTIFICATION</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<EventNotification><EventType>PaymentOrder</EventType><EventSubType>validationChecks</EventSubType><ReferenceNumber>"+ttrefno+"</ReferenceNumber><EntityField><Name>CallBackSuccessful</Name><Value>"+callbackflag+"</Value></EntityField><EntityField><Name>CallBackRemarks</Name><Value>"+callbackwaiver+"</Value></EntityField></EventNotification>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
			}
			else if((callbackflagFromFinacle.equalsIgnoreCase("N") && compflagFromFinacle.equalsIgnoreCase("Y"))){
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>EVENT_NOTIFICATION</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<EventNotification><EventType>PaymentOrder</EventType><EventSubType>validationChecks</EventSubType><ReferenceNumber>"+ttrefno+"</ReferenceNumber><EntityField><Name>RefcountrySuccess</Name><Value>"+refcountryflag+"</Value></EntityField></EventNotification>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
				}
			else if((callbackflagFromFinacle.equalsIgnoreCase("Y") && compflagFromFinacle.equalsIgnoreCase("Y"))){
				if((callbackflag.equalsIgnoreCase("Y") && isrulingfamily.equalsIgnoreCase("No"))|| callbackwaiver.equalsIgnoreCase("N"))
				{
				WriteLog("for callbackwaiver.."+callbackflag);	
					callbackwaiver="";
				}
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>EVENT_NOTIFICATION</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<EventNotification><EventType>PaymentOrder</EventType><EventSubType>validationChecks</EventSubType><ReferenceNumber>"+ttrefno+"</ReferenceNumber><EntityField><Name>CallBackSuccessful</Name><Value>"+callbackflag+"</Value></EntityField><EntityField><Name>RefcountrySuccess</Name><Value>"+refcountryflag+"</Value></EntityField><EntityField><Name>CallBackRemarks</Name><Value>"+callbackwaiver+"</Value></EntityField></EventNotification>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
				}
				
			WriteLog("sInputXML for event notification- "+sInputXML);	
			
			//sMappOutPutXML=WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			
			WriteLog("sMappOutPutXML for event notification- "+sMappOutPutXML);	
			
			//sMappOutPutXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>EVENT_NOTIFICATION</MsgFormat><MsgVersion>0001</MsgVersion>     <RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage>      <RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc>      <MessageId>UniqueMessageId123</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER>  <EventNotification><SuccFlag>Y</SuccFlag><EntityField><Name>aaa</Name><Value>xxx</Value></EntityField></EventNotification></EE_EAI_MESSAGE>";
			
			WriteLog("sMappOutPutXML for event notification- "+sMappOutPutXML);	
		}
		/*else if (requestType.equals("PAYMENT_DELETION"))
		{
			sInputXML = "<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>PAYMENT_DELETION</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>EBC.INB</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc></ReturnDesc><MessageId>UTC_MW_PAYMENT_DELETION_T01</MessageId><Extra1>REQ||LAXMANRET.LAXMANRET</Extra1><Extra2>2015-06-25T16:45:16.141+05:30</Extra2></EE_EAI_HEADER><PaymentCancellationReq><BankId>RAK</BankId><CIFId>0300300</CIFId><PODetails><PONumber>000002793644</PONumber><Reason>sdfds</Reason></PODetails></PaymentCancellationReq></EE_EAI_MESSAGE>";
			
			//sMappOutPutXML=WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			sMappOutPutXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>PAYMENT_DELETION</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>EBC.INB</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>UTC_MW_PAYMENT_DELETION_T01</MessageId><Extra1>REP||LAXMANRET.LAXMANRET</Extra1><Extra2>2015-06-25T16:45:16.141+05:30</Extra2></EE_EAI_HEADER><PaymentCancellationRes><BankId>RAK</BankId><CIFId>0300300</CIFId><CancellationStatus><PONumber>123456789012</PONumber><DelIndicator>Y</DelIndicator><POStatus>P</POStatus></CancellationStatus><CancellationStatus><PONumber>1234568</PONumber><DelIndicator>N</DelIndicator><POStatus>N</POStatus></CancellationStatus><CancellationStatus><PONumber>1234569</PONumber><DelIndicator>Y</DelIndicator><POStatus>D</POStatus></CancellationStatus></PaymentCancellationRes></EE_EAI_MESSAGE>";
		}*/
		else if (requestType.equals("PAYMENT_REQ"))
		{
			String rateCodeFromXchngRateCall = rateCode_Esapi;
			String tramtWithoutComma = tramtWithoutComma_Esapi;
			String trcry = trcry_Esapi;
			String crcry = crcry_Esapi;
			String dacry = dacry_Esapi;
			if(rateCodeFromXchngRateCall==null ||rateCodeFromXchngRateCall.equals(""))
			{
				rateCodeFromXchngRateCall="TTS";				
			}		
			String bfNm = bfNm_Esapi;
			String bfname = URLDecoder.decode(bfname_Esapi);
			String bfAddress1 = URLDecoder.decode(bfAddress1_Esapi);
			String bfAddress2 = URLDecoder.decode(bfAddress2_Esapi);
			String bfCy = bfCy_Esapi;
			String bbbr = bbbr_Esapi;
			String bfAc = bfAc_Esapi;
			String bbcy = bbcy_Esapi;
			String chg = chg_Esapi;
			String bbn = bbn_Esapi;
			String bbcn = bbcn_Esapi;
			String wiNo = wiNo_Esapi;
			String org = org_Esapi;
			String exRate = exRate_Esapi;
			String encodedpop1 = URLDecoder.decode(pop1_url_Esapi);
			String pop1=encodedpop1.replaceAll("encoded","%");
			WriteLog("pop1....after "+pop1);
			String encodedpop2 = URLDecoder.decode(pop2_url_Esapi);
			String pop2 = encodedpop2.replaceAll("encoded","%");
			String encodedpop3 = URLDecoder.decode(pop3_url_Esapi);
			String pop3 = encodedpop3.replaceAll("encoded","%");
			String benefcity = benefcity_Esapi;
			String txnTypeCode = txnTypeCode_Esapi;
			String countryCode = countryCode_Esapi;
			String interBankName = interBankName_Esapi;
			String interBankBranch = interBankBranch_Esapi;
			String interCityState = interCityState_Esapi;
			String interBankCntry = interBankCntry_Esapi;
			//changed for CR on 21102016
			String strNatureOfPayment="";
			
			if(("INR").equalsIgnoreCase(crcry))
			{
				strNatureOfPayment="C";
			}
			WriteLog("interBankCntry - "+interBankCntry);
			
			if(org!=null)
			{
				org=(org.equalsIgnoreCase("No")||org.equalsIgnoreCase("N"))?"N":"Y";
			}
			/*String pay = request.getParameter("pay");
			WriteLog("pay - "+pay);
			if(pay!=null)
			{
				String tmpPay="";
				int i=0;
				for(;i<3;i++)
				{
					if(pay.length()>35)
					{
						tmpPay+=pay.substring(0,35);
						pay=pay.substring(35,pay.length());
						tmpPay+="|";
					}
					else
					{
						tmpPay+=pay;
						tmpPay+="|";
						break;
					}
						
					//WriteLog("pay2 - "+pay+"pay2 - "+tmpPay);	
				}
				
				if(i==0)	tmpPay+="||";			
				else 	if(i==1)	tmpPay+="|";	
				pay=tmpPay;
			}
			else
			{
				pay="|||";
			}
			WriteLog("pay3 - "+pay);*/
			
			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>PAYMENT_REQ</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<PaymentRequest><FrAcid>"+debt_acc_num+"</FrAcid><TxnAmt>"+tramtWithoutComma+"</TxnAmt><TxnCrn>"+trcry+"</TxnCrn><EffExchangeRate>"+exRate+"</EffExchangeRate><FrActCrn>"+dacry+"</FrActCrn><ToActCrn>"+crcry+"</ToActCrn><ChargeDetail>"+chg+"</ChargeDetail><PayValDate>"+dateToPass+"</PayValDate><RmtrPurpose>"+pop1+"~"+pop2+"~"+pop3+"</RmtrPurpose><BenefName>"+bfname+"</BenefName><BenefAddr1>"+bfAddress1+"</BenefAddr1><BenefAddr2>"+bfAddress2+"</BenefAddr2><BenefAddr3>"+benefcity+"</BenefAddr3><BenefCountry>"+bfCy+"</BenefCountry><BenefAddr></BenefAddr><BenefAccNo>"+bfAc+"</BenefAccNo><BenefBank>"+bbcy+"</BenefBank><BenefBankAddr_1>~</BenefBankAddr_1><BenefBankAddr_2>"+bbbr+"</BenefBankAddr_2><BenefBankCountry>"+countryCode+"</BenefBankCountry><IntInstName>"+interBankName+"</IntInstName><IntInstAddr1></IntInstAddr1><IntInstAddr2>"+interBankBranch+"</IntInstAddr2><IntInstAddr3>"+interCityState+"</IntInstAddr3><IntInstCountry>"+interBankCntry+"</IntInstCountry><TxnType>R</TxnType><PaymPurpose>"+txnTypeCode+"</PaymPurpose><BnfBankName>"+bbn+"</BnfBankName><STPFLG>N</STPFLG><OrderType>CT</OrderType><RateCode>"+rateCodeFromXchngRateCall+"</RateCode><PmtNature>"+strNatureOfPayment+"</PmtNature><TargetSystem>FIN</TargetSystem><workFlowItemNo>"+wiNo+"</workFlowItemNo><OriginalAppRecvd>"+org+"</OriginalAppRecvd></PaymentRequest>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
				
			//sInputXML = "<?xml version=\"1.0\"?><TT_APMQPutGetMessage_Input><Option>TT_APMQPutGetMessageDirect</Option><UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID><SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId><EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName><RequestType>PAYMENT_REQ</RequestType><EE_EAI_BODY><PaymentRequest><FrAcid>0024311287001</FrAcid><TxnAmt>1200.00</TxnAmt><TxnCrn>AED</TxnCrn><FrActCrn>AED</FrActCrn><ToActCrn>AED</ToActCrn><ChargeDetail>SHA</ChargeDetail><PayValDate>2016-03-07</PayValDate><RmtrPurpose>gfdh~dfsds~ghfchg|</RmtrPurpose><BenefName>Beneficiary Name</BenefName><BenefAddr1>Testing</BenefAddr1><BenefAddr2>Testing</BenefAddr2><BenefAddr3>Testing</BenefAddr3><BenefCountry>AE</BenefCountry><BenefAddr>fdsg</BenefAddr><BenefAccNo>IN11111111111111111111111</BenefAccNo><BenefBank>New Delhi</BenefBank><BenefBankAddr_1>Testing</BenefBankAddr_1><BenefBankAddr_2>ghhDXB</BenefBankAddr_2><BenefBankCode></BenefBankCode><BenefBankCountry>IN</BenefBankCountry><TxnType>R</TxnType><BnfBankName>ICICI BankICICI BankICICI BankICICI</BnfBankName><STPFLG>N</STPFLG><OrderType>CT</OrderType><RateCode>TTS</RateCode><TargetSystem>FIN</TargetSystem><workFlowItemNo>TT-0000000048-Process</workFlowItemNo><OriginalAppRecvd>N</OriginalAppRecvd></PaymentRequest></EE_EAI_BODY>";	
			
			WriteLog("sInputXML for PAYMENT_REQ - "+sInputXML);
			//sMappOutPutXML=WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			//sMappOutPutXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>PAYMENT_REQ</MsgFormat><MsgVersion>0000</MsgVersion><RequestorChannelId>EBC.INB</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>UTC_MW_PAYMENT_REQ_01</MessageId><Extra1>REP||LAXMANRET.LAXMANRET</Extra1><Extra2>2015-08-23T18:51:40.664+05:30</Extra2></EE_EAI_HEADER><Payment><HostTxnId>000000004238</HostTxnId><TxnAmtInHomeCrn>1000</TxnAmtInHomeCrn><ValueDate>2014-12-26</ValueDate><BusinessDate>2012-07-12</BusinessDate><CallBackRequired>Y</CallBackRequired><ComplianceCheckRequired>N</ComplianceCheckRequired><ReferredCntryFlg>Y</ReferredCntryFlg></Payment></EE_EAI_MESSAGE>";
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
		else if (requestType.equals("PAYMENT_DETAILS"))
		{
			WriteLog("sInputXML Extract Remittance ");	
			//sInputXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>PAYMENT_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>00500</ReturnCode><ReturnDesc>Issuer Timed Out</ReturnDesc><MessageId>MW_PAYMENT_DETAILS_Advice1</MessageId><Extra1>REQ||SHELL.JOHN</Extra1><Extra2>YYYY-MM-DDThh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><PaymentStatus><XfReqId>23432</XfReqId><HostTxnId>E123123</HostTxnId><TargetSystem>FIN</TargetSystem><Action>A</Action></PaymentStatus></EE_EAI_MESSAGE>";
		
			String paymentRefNo = paymentRefNo_Esapi;

			sInputXML = "<?xml version=\"1.0\"?>"
				+ "<TT_APMQPutGetMessage_Input>\n"+
				"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
				"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
				"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
				"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
				"<RequestType>PAYMENT_DETAILS</RequestType>\n" +
				"<EE_EAI_BODY>\n"+
				"<ProcessName>TT</ProcessName>\n" +
				"<PaymentStatus><XfReqId></XfReqId><HostTxnId>"+paymentRefNo+"</HostTxnId><TargetSystem>FIN</TargetSystem><Action>S</Action></PaymentStatus>\n" +
				"</EE_EAI_BODY>\n"+
				"</TT_APMQPutGetMessage_Input>";
			WriteLog("sInputXML - "+sInputXML);	
			//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			
			//sMappOutPutXML="<EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>PAYMENT_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Successful</ReturnDesc><MessageId>SIT1451835260298</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>YYYY-MM-DDThh:mm: ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><PaymentStatus><XfReqId>100010</XfReqId><HostTxnId>000000000161</HostTxnId><Status>P</Status></PaymentStatus></EE_EAI_MESSAGE>";
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
		else if (requestType.equals("GET_CUSTOMER_DETAILS"))
		{
			String strWIName=wi_name_Esapi;

			/*sInputXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessage</Option>\n"+
					"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
					"<AccountNumber>"+debt_acc_num+"</AccountNumber>\n"+ 
					"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
					"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
					"<RequestType>ENTITY_DETAILS</RequestType>\n" +
					"</TT_APMQPutGetMessage_Input>";*/
					
		sInputXML = "<?xml version=\"1.0\"?>"
					+ "<TT_APMQPutGetMessage_Input>\n"+
					"<Option>TT_APMQPutGetMessageDirect</Option>\n"+
					"<UserID>"+wDSession.getM_objUserInfo().getM_strUserName()+"</UserID>\n" +
					"<SessionId>"+wDSession.getM_objUserInfo().getM_strSessionId()+"</SessionId>\n"+
					"<EngineName>"+wDSession.getM_objCabinetInfo().getM_strCabinetName()+"</EngineName>\n" +
					"<RequestType>ENTITY_DETAILS</RequestType>\n" +
					"<EE_EAI_BODY>\n"+
					"<ProcessName>TT</ProcessName>\n" +
					"<CustomerDetails><BankId>RAK</BankId><CIFID></CIFID><ACCType>A</ACCType><ACCNumber>"+debt_acc_num+"</ACCNumber><InquiryType>CustomerAndAccount</InquiryType></CustomerDetails>\n" +
					"</EE_EAI_BODY>\n"+
					"</TT_APMQPutGetMessage_Input>";
					
			WriteLog("sInputXML Entity_Details--- "+sInputXML);		
			//sMappOutPutXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
			sMappOutPutXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
					
			//sMappOutPutXML = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?><EE_EAI_MESSAGE><EE_EAI_HEADER><MsgFormat>ENTITY_DETAILS</MsgFormat><MsgVersion>0001</MsgVersion><RequestorChannelId>BPM</RequestorChannelId><RequestorUserId>RAKUSER</RequestorUserId><RequestorLanguage>E</RequestorLanguage><RequestorSecurityInfo>secure</RequestorSecurityInfo><ReturnCode>0000</ReturnCode><ReturnDesc>Success</ReturnDesc><MessageId>123123453</MessageId><Extra1>REP||SHELL.JOHN</Extra1><Extra2>1900-01-01Thh:mm:ss.mmm+hh:mm</Extra2></EE_EAI_HEADER><CustomerDetails><BankId>RAK</BankId><CIFID>123456</CIFID><ACCNumber>1234567</ACCNumber><AccountStatus>O</AccountStatus><AccountCategory>SINGLY</AccountCategory><JointAccIndicator>N</JointAccIndicator><SchemeCode>ALAP1</SchemeCode><SchemeType>ODA</SchemeType><PrimaryContactName>XXXX</PrimaryContactName><PrimaryContactNum>098988525</PrimaryContactNum><SecondaryContactName>YYYYY</SecondaryContactName><SecondaryContactNum>09898989</SecondaryContactNum><ECRNumber>1234567dhfggj56</ECRNumber><FirstName>EQN</FirstName><MiddleName>EQ12345</MiddleName><LastName>asjdguj</LastName><FullName>CustomerName</FullName><MothersName>fsjhjf</MothersName><DOB>1964-10-11</DOB><Gender>M</Gender><Nationality>IND</Nationality><IsPremium>N</IsPremium><ARMName>PBD</ARMName><ARMPhone>Y</ARMPhone><CustomerType>EN</CustomerType><CustomerSegment>SME</CustomerSegment><CustomerSubSeg>SME</CustomerSubSeg><AcctCurr>AED</AcctCurr><IBANNumber>AE*****************1</IBANNumber><CustStatus>ACTIVE</CustStatus><AddrDet><AddressType>OFFICE</AddressType><HoldMailFlag>N</HoldMailFlag><HoldMailBCName>bbbbbb</HoldMailBCName><HoldMailReason>xxxxxxx</HoldMailReason><ReturnFlag>N</ReturnFlag><AddrPrefFlag>Y</AddrPrefFlag><AddrLine1>12345</AddrLine1><AddrLine2>PREMISE NAME FOR 0326407</AddrLine2><AddrLine3>STREET NAME FOR 0326407</AddrLine3><AddrLine4>Addr line 4</AddrLine4><POBox>12346</POBox><City>DXB</City><Country>AE</Country></AddrDet><PhnDet><PhnType>OFFCPH1</PhnType><PhnPrefFlag>N</PhnPrefFlag><PhnCountryCode>00971</PhnCountryCode><PhnLocalCode>420326407</PhnLocalCode><PhoneNo>0097XXXX6407</PhoneNo></PhnDet><EmailDet><MailIdType>ELML1</MailIdType><MailPrefFlag>Y</MailPrefFlag><EmailID>abcd@dfg.com</EmailID></EmailDet><DocumentDet><DocType>Passport</DocType><DocId>sf57Y</DocId><DocExpDt>1964-10-11</DocExpDt></DocumentDet><RelatedCIF><CIFID>1170542</CIFID><CustomerType>EBY</CustomerType><CustomerSegment>PBD</CustomerSegment><CustomerSubSeg>PBN</CustomerSubSeg><CustomerName>DIANE ELIZABETH GREASLEY</CustomerName><CustomerCategory>PBN</CustomerCategory><CustomerStatus>ACTVE</CustomerStatus><CustomerMobileNumber>00971501170581</CustomerMobileNumber><AddressLine1>12345</AddressLine1><AddressLine2></AddressLine2><AddressLine3></AddressLine3><AddressLine4></AddressLine4><AddressLine5></AddressLine5><BuildingLevel></BuildingLevel><StreetNum></StreetNum><StreetType></StreetType><CityCode></CityCode><State>DXB</State><CountryCode>AE</CountryCode><PrimaryEmailId>1170581.1170581@RAKBANK.AE</PrimaryEmailId><Fax></Fax><DOB>1960-03-30</DOB><Nationality>CA</Nationality><PassportNum>H1940785</PassportNum><MotherMaidenName>MOTHER</MotherMaidenName><LinkedDebitCardNumber>4343253253453245</LinkedDebitCardNumber><FinacleRelation>Y</FinacleRelation><IsMinor>N</IsMinor><IsStaff>Y</IsStaff><IsNRE></IsNRE></RelatedCIF><FreeField1/><FreeField2/><FreeField3/><FreeField4/><FreeField5/><FreeField6/><FreeField7/></CustomerDetails></EE_EAI_MESSAGE>";
					
			WriteLog("sMappOutPutXML - "+sMappOutPutXML);
		}
	}
	catch(Exception e){
		e.printStackTrace();
		sMappOutPutXML="Exception"+((e.getMessage()==null)?"NULL":e.getMessage());
	}
	
	out.clear();
	out.println(sMappOutPutXML);
%>