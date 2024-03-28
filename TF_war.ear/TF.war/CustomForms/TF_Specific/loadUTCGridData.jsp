
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../TF_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WI_NAME"), 1000, true) );
			String WI_NAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("Integration jsp: WI_NAME_Esapi: "+WI_NAME_Esapi);

WriteLog("inside utc ");
		String Query2 = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		WFCustomXmlResponse objWFCustomXmlResponse=null;
		String inputXMLstate="";
		String outputXMLstate= "";
		String subXML="";
		String params="";
		String state_search="";
		String returnValue = "";
		String mainCodeValuestate = "";
		String wiName=WI_NAME_Esapi;
		if (wiName != null) {wiName=wiName.replace("'","''");}
		String[] colNames = {"UTC_SR_NO","WINAME","DOCUMENT_NO","DOCUMENT_DATE","CURRENCY","TOTAL_INVOICE_AMT","BUYER_NAME","SUPPLIER_NAME","LINE_ITEMS_COUNT","BAN_REF_NUM","CONTRACT_NO","PO_NUMBER","AMT_IN_WORDS","PAYMENT_DUE_DATE","TERMS_OF_PAYMENT","BILLING_ADDRESS","DISCOUNT","TAX_AMOUNT","TAX_NO_SUPPLIER","GROSS_AMOUNT","SUPPLIER_ACCOUNT_NO","SUPPLIER_ADDRESS_LINE1","SUPPLIER_ADDRESS_LINE2","SUPPLIER_ADDRESS_CITY","SUPPLIER_ADDRESS_COUNTRY","SUPPLIER_ADDRESS_PO_BOX","SUPPLIER_EMAIL_ADDRESS","SUPPLIER_WEBSITE","SUPPLIER_TELEPHONE","BUYER_TELEPHONE","BUYER_ACCOUNT_NO","BUYER_ADDRESS_LINE1","BUYER_ADDRESS_LINE2","BUYER_ADDRESS_CITY","BUYER_ADDRESS_COUNTRY","BUYER_ADDRESS_PO_BOX","BUYER_EMAIL_ADDRESS","BUYER_WEBSITE","LINE_ITEMS_DESC","HS_CODE","UNIT_PRICE","SUB_TOTAL_AMT","QUANTITY","LINE_NO","UOM"};
		
		Query2 = "SELECT UTC_SR_NO,WINAME,DOCUMENT_NO,DOCUMENT_DATE,CURRENCY,TOTAL_INVOICE_AMT,BUYER_NAME,SUPPLIER_NAME,LINE_ITEMS_COUNT,BAN_REF_NUM,CONTRACT_NO,PO_NUMBER,AMT_IN_WORDS,PAYMENT_DUE_DATE,TERMS_OF_PAYMENT,BILLING_ADDRESS,DISCOUNT,TAX_AMOUNT,TAX_NO_SUPPLIER,GROSS_AMOUNT,SUPPLIER_ACCOUNT_NO,SUPPLIER_ADDRESS_LINE1,SUPPLIER_ADDRESS_LINE2,SUPPLIER_ADDRESS_CITY,SUPPLIER_ADDRESS_COUNTRY,SUPPLIER_ADDRESS_PO_BOX,SUPPLIER_EMAIL_ADDRESS,SUPPLIER_WEBSITE,SUPPLIER_TELEPHONE,BUYER_TELEPHONE,BUYER_ACCOUNT_NO,BUYER_ADDRESS_LINE1,BUYER_ADDRESS_LINE2,BUYER_ADDRESS_CITY,BUYER_ADDRESS_COUNTRY,BUYER_ADDRESS_PO_BOX,BUYER_EMAIL_ADDRESS,BUYER_WEBSITE,LINE_ITEMS_DESC,HS_CODE,UNIT_PRICE,SUB_TOTAL_AMT,QUANTITY,LINE_NO,UOM FROM USR_0_TF_UTC_DTLS_GRID with (nolock) WHERE WINAME=:WI_NAME";
		params = "WI_NAME=="+wiName;
		
		
		
		WriteLog("Input Xml For Get UTC Data-- "+Query2);

		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML For Winame: "+wiName+" Get UTC Data -- "+inputXMLstate);
	
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, sJtsIp, iJtsPort, 1);
		
		WriteLog("Output Xml For Winame: "+wiName+" Get UTC Data---- "+outputXMLstate);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((outputXMLstate));
		mainCodeValuestate = xmlParserData.getVal("MainCode");
		int totalRecord=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		String recordsArray="";
		String tempRowvalues="";
		if(mainCodeValuestate.equals("0")&&totalRecord>0)
		{
			objWorkList = xmlParserData.createList("Records","Record"); 
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{
					if(tempRowvalues!="")
					tempRowvalues=tempRowvalues+"|";
					int newRow=1;
					subXML = objWorkList.getVal("Record");
					objWFCustomXmlResponse = new WFCustomXmlResponse(subXML);
					for(int i=0;i<colNames.length;i++)
					{
						if(tempRowvalues=="")
						{
							tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
						else if(tempRowvalues!="" && newRow==1)
						{
							tempRowvalues=tempRowvalues+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
						else if(tempRowvalues!="" && newRow==0)
						{
							tempRowvalues=tempRowvalues+"~"+objWFCustomXmlResponse.getVal(colNames[i]);
							newRow=0;
						}
					}
			}
			out.clear();
			out.print(tempRowvalues);
			WriteLog("tempRowvalues For Winame: "+wiName+" Get UTC Data -- "+tempRowvalues);
		}
		else if(mainCodeValuestate.equals("0")&&totalRecord==0)
		{
			out.clear();
			out.print("0");
		}
		else
		{
			out.clear();
			out.print("-1");
		}
%>