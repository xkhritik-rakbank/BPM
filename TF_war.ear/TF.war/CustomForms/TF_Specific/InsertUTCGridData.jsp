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
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("gridRow"), 1000, true) );
			String gridRow_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: gridRow_Esapi: "+gridRow_Esapi);
			gridRow_Esapi = gridRow_Esapi.replaceAll("&#x3b;",";").replaceAll("&#x7e;","~").replaceAll("&#x60;","`").replaceAll("&#x3a;",":").replaceAll("&amp;gt&#x3b;",">").replaceAll("&amp;lt&#x3b;","<").replaceAll("&#x2c;",",").replaceAll("&#x22;","\"").replaceAll("&#x5c;","\\").replaceAll("&#x7c;","|").replaceAll("&#x5d;","]").replaceAll("&#x5b;","[").replaceAll("&#x7d;","}").replaceAll("&#x7b;","{").replaceAll("&#x3d;","=").replaceAll("&#x2b;","+").replaceAll("&#x29;",")").replaceAll("&#x28;","(").replaceAll("&#x2a;","*").replaceAll("&amp;amp&#x3b;","&").replaceAll("&#x5e;","^").replaceAll("&#x25;","%").replaceAll("&#x24;","$").replaceAll("&#x23;","#").replaceAll("&#x3f;","?").replaceAll("&#x21;","!").replaceAll("&#x40;","@").replaceAll("&#x27;","\'").replaceAll("&#x2f;","/");
		    WriteLog("after replace gridRow_Esapi: "+gridRow_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("Integration jsp: wi_name_Esapi: "+wi_name_Esapi);

			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WSNAME"), 1000, true) );
			String WSNAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			WriteLog("Integration jsp: WSNAME_Esapi: "+WSNAME_Esapi);
			
	WriteLog("\n Inside Insert UTC Data Jsp");
	String gridRow = gridRow_Esapi;
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	String WINAME=wi_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","");}
	String WSNAME=WSNAME_Esapi;
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","");}
	String colNames = "UTC_SR_NO,WINAME,DOCUMENT_NO,BAN_REF_NUM,DOCUMENT_DATE,CURRENCY,TOTAL_INVOICE_AMT,CONTRACT_NO,PO_NUMBER,AMT_IN_WORDS,PAYMENT_DUE_DATE,TERMS_OF_PAYMENT,BILLING_ADDRESS,DISCOUNT,TAX_AMOUNT,TAX_NO_SUPPLIER,GROSS_AMOUNT,SUPPLIER_NAME,SUPPLIER_ACCOUNT_NO,SUPPLIER_ADDRESS_LINE1,SUPPLIER_ADDRESS_LINE2,SUPPLIER_ADDRESS_CITY,SUPPLIER_ADDRESS_COUNTRY,SUPPLIER_ADDRESS_PO_BOX,SUPPLIER_EMAIL_ADDRESS,SUPPLIER_TELEPHONE,SUPPLIER_WEBSITE,BUYER_NAME,BUYER_TELEPHONE,BUYER_ACCOUNT_NO,BUYER_ADDRESS_LINE1,BUYER_ADDRESS_LINE2,BUYER_ADDRESS_CITY,BUYER_ADDRESS_COUNTRY,BUYER_ADDRESS_PO_BOX,BUYER_EMAIL_ADDRESS,BUYER_WEBSITE,LINE_ITEMS_COUNT,LINE_ITEMS_DESC,HS_CODE,UNIT_PRICE,SUB_TOTAL_AMT,QUANTITY,LINE_NO,UOM";
	
	if (gridRow != null) {
	gridRow=gridRow.replace("'","");
	gridRow=gridRow.replace("AMPNDCHAR","&amp;");
	gridRow=gridRow.replace("PPPERCENTTT","&per;");
	gridRow=gridRow.replace(">","&gt;");
	gridRow=gridRow.replace("<","&lt;");
	gridRow=gridRow.replace("PIPECHAR","&pipe;");
	}
	
	String values=gridRow;
	WriteLog("values For UTC Data for WINAME "+WINAME+" :"+values);
	
	
	try	
	{
		String sInputXML="<?xml version=\"1.0\"?>" +                                                           
			"<APProcedure2_Input>" +
			"<Option>APProcedure2</Option>" +
			"<ProcName>"+"TF_InsertUTCDetails"+"</ProcName>"+
			"<Params>"+"'"+values+"','"+WINAME+"','"+WSNAME+"'"+"</Params>" +  
			"<NoOfCols>1</NoOfCols>" +
			"<SessionID>"+sSessionId+"</SessionID>" +
			"<EngineName>"+sCabName+"</EngineName>" +
			"</APProcedure2_Input>";

		WriteLog("sInputXML: TF_InsertUTCDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sInputXML);
		String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("sOutputXML: TF_InsertUTCDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
		if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
		{
			sOutputXML = sOutputXML.substring(sOutputXML.indexOf("<Results>")+9,sOutputXML.indexOf("</Results>"));
			WriteLog("Status: TF_InsertUTCDetails for WorkitemName "+WINAME+" , WSNAME "+WSNAME+" : "+sOutputXML);
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
	}catch(Exception e){
		out.clear();
		out.print("-1");
	}
	
%>