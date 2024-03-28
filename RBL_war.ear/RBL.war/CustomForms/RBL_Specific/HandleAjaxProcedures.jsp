<%@ include file="Log.process"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/RBL/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%	

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WorkitemName"), 1000, true) );
			String WorkitemName_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("H_Checklist"), 1000, true) );
			String H_Checklist_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
	logger.info("Inside check exception raised.jsp");
	
	String sInputXML="";
	String sOutputXML="";
	String reqType = reqType_Esapi;
	
	
	//Extra String declared which can be required according to the request
	String WorkitemName = "";
	String remit_amt_curr ="";
	String seg = "";
	String scanDateTime = "";
	logger.info("reqType in handleajaxprocedure: "+reqType);
	if (reqType.equals("RBL_ISExceptionRaised"))
	{
		WorkitemName = WorkitemName_Esapi;
		try	
		{
			sInputXML="<?xml version=\"1.0\"?>" +                                                           
				"<APProcedure2_Input>" +
				"<Option>APProcedure2</Option>" +
				"<ProcName>"+"RBL_ISExceptionRaised"+"</ProcName>"+
				"<Params>"+"'"+WorkitemName+"','"+H_Checklist_Esapi+"'"+"</Params>" +  
				"<NoOfCols>1</NoOfCols>" +
				"<SessionID>"+customSession.getDMSSessionId()+"</SessionID>" +
				"<EngineName>"+customSession.getEngineName()+"</EngineName>" +
				"</APProcedure2_Input>";

			logger.info("sInputXML: RBL_IsException for WINAME "+WorkitemName+" : "+sInputXML);
			sOutputXML= WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			logger.info("sOutputXML: RBL_IsException for WINAME "+WorkitemName+" : "+sOutputXML);
			if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
			{
				sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
				sOutputXML=sOutputXML.replace("# ","#");
				out.clear();
				out.print(sOutputXML);
			}
			else
			{
				out.clear();
				out.print("Error");
			}
		}catch(Exception e){
			out.clear();
			out.print("Exception");
		}
	}
	
				
%>				
	