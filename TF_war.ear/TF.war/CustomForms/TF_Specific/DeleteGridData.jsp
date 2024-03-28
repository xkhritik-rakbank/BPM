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

<%!
	public String createAP_Delete_XML(String tableName,String sWhere,String sSessionId,String sCabname)
	{  
	
		String sInputXML = "<?xml version=\"1.0\"?>"
			+ "<APDelete_Input><Option>APDelete</Option>"
			+ "<TableName>" + tableName + "</TableName>"
			+ "<WhereClause>" + sWhere + "</WhereClause>"
			+ "<EngineName>" + sCabname + "</EngineName>"
			+ "<SessionId>" + sSessionId + "</SessionId>"
			+ "</APDelete_Input>";

		return sInputXML;
	}
%>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
		
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ws_name"), 1000, true) );
			String ws_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			
	String WINAME = wi_name_Esapi;
	String WSNAME = ws_name_Esapi;
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
	WriteLog("\n Inside DeleteGridData.jsp for WINAME: "+WINAME);
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();		
	String sWhere = "WINAME='"+WINAME+"'";
	String strTableName = "";
	String reqType =reqType_Esapi;
	WriteLog("\n reqType: "+reqType);
	try
	{
		String sInputXML = "";
		String outputXML = "";
		
		if (reqType.equals("checklistData"))
		{			
			/*query = "SELECT countryName FROM USR_0_RMT_CountryMaster with(nolock) WHERE 1=:ONE order by countryName";
			params = "ONE==1";*/
			
			strTableName="USR_0_TF_SaveChecklistTable";		
			sWhere= sWhere+ " and workstep='"+WSNAME+"'";
		}
		else if (reqType.equals("DocGridData"))
		{			
			strTableName="USR_0_TF_SaveDocGridTable";					
		}
		else if (reqType.equals("DuplicateWIData"))
		{			
			strTableName="USR_0_TF_DUPLICATEWORKITEMS";					
		}
		else if (reqType.equals("InvoiceGridData"))
		{			
			strTableName="USR_0_TF_INVOICE_DTLS_GRID";					
		}
		else if (reqType.equals("CommunicationGridData"))
		{			
			strTableName="USR_0_TF_COMMUNICATION_DTLS_GRID";					
		}
		else if (reqType.equals("QueryDetailsGrid"))
		{			
			strTableName="USR_0_TF_QUERY_DTLS_GRID";					
		}
		else if (reqType.equals("UTCDetailsGrid"))
		{			
			strTableName="USR_0_TF_UTC_DTLS_GRID";					
		}
		
		for (int i=0; i<3; i++)
		{
			sInputXML=createAP_Delete_XML(strTableName,sWhere,sSessionId,sCabName);			
			WriteLog("\nDelete InputXML For Delete Data for WINAME "+WINAME+" :\n"+sInputXML);
			outputXML=WFCustomCallBroker.execute(sInputXML,customSession.getJtsIp(),customSession.getJtsPort(),1);
			WriteLog("Output Xml For Delete Data for WINAME "+WINAME+" -->"+outputXML);
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString(outputXML);
			String maincode = WFCustomXmlResponseData.getVal("MainCode");
			if(!(maincode.equals("0")))
			{
				WriteLog("\n Delete Fail for WINAME "+WINAME);
				out.clear();
				out.println("-1");
			}
			else
			{
				WriteLog("\n Delete Successfull for WINAME "+WINAME);	
				out.clear();
				out.println("0");
				break;
			}
		}	
	}
	catch(Exception e) 
	{
		WriteLog("\n Exception In Delete Grid for WINAME "+WINAME+" : Exception is: "+e);
		out.clear();
		out.println("-1");
	}
	
%>