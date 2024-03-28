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
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>

<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
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

<!---<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>--->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("workstepname"), 1000, true) );
			String workstepname_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("workstepname Request.getparameter---> "+request.getParameter("workstepname"));
			WriteLog("workstepname Esapi---> "+workstepname_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("reqType"), 1000, true) );
			String reqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("reqType Request.getparameter---> "+request.getParameter("reqType"));
			WriteLog("reqType Esapi---> "+reqType_Esapi);
			
			String ID_Issued_Org = URLDecoder.decode(request.getParameter("ID_Issued_Org"));
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", ID_Issued_Org, 1000, true) );
			String DecoderID_Issued_Org = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			

	WriteLog("Inside HandleAjaxRequest.jsp");
	
	String wsname = workstepname_Esapi;
	String reqType = reqType_Esapi;
	//String sCabName= wfsession.getEngineName();	
	String sCabName= wDSession.getM_objUserInfo().getM_strUserName();	
	//String sSessionId = wfsession.getSessionId();	
	String sSessionId = wDSession.getM_objUserInfo().getM_strSessionId();	
	//String sJtsIp = wfsession.getJtsIp();
	String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	//int iJtsPort = wfsession.getJtsPort();
	int iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
	//String userName = wfsession.getUserName();
	String userName = wDSession.getM_objUserInfo().getM_strUserName();
	String agencyName = DecoderID_Issued_Org;


	XMLParser xmlParserData=null;
	XMLParser objXmlParser=null;
	String sOutputXML = "";
	String subXML="";
	String returnValues = "";
	String query = "";
	
	WriteLog("reqType = "+reqType);
	
	//Check the request Type
	if (reqType.equals("getSolId"))
	{
		query= "SELECT TOP 1 comment FROM PDBUser WHERE UserName='"+userName+"'";
	
		WriteLog("query -- "+query);

		
		String sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";

		//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog("Output XML -- "+sOutputXML);

		
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML((sOutputXML));
		String mainCodeValue = xmlParserData.getValueOf("MainCode");

		
		int recordcount=0;
		recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		WriteLog("recordcount -- "+recordcount);

		
		if(mainCodeValue.equals("0"))
		{
			for(int k=0; k<recordcount; k++)
			{


				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);

				if (reqType.equals("getSolId"))
					returnValues = objXmlParser.getValueOf("comment");



				
			}
		}
	}		
	//added by ankit for change request
	else if(reqType.equals("getAgencyName"))
	{

		query= "SELECT count(*) as AgencyCount FROM usr_0_tl_agencymaster WHERE agencyname='"+agencyName+"' and isactive='Y'";
	
		WriteLog("query -- "+query);
		
		String sInputXML = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + query + "</Query><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithColumnNames_Input>";

		//sOutputXML = WFCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
		WriteLog("Output XML -- "+sOutputXML);
		
		xmlParserData=new XMLParser();
		xmlParserData.setInputXML((sOutputXML));
		String mainCodeValue = xmlParserData.getValueOf("MainCode");
		
		int recordcount=0;
		recordcount=Integer.parseInt(xmlParserData.getValueOf("TotalRetrieved"));
		WriteLog("total retrieved -- "+recordcount);
		
		if(mainCodeValue.equals("0"))
		{
			for(int k=0; k<recordcount; k++)
			{
				subXML = xmlParserData.getNextValueOf("Record");
				objXmlParser = new XMLParser(subXML);


				returnValues = objXmlParser.getValueOf("AgencyCount");

				WriteLog("returnValues agencycount -- "+returnValues);
				
			}
		}
	}
	WriteLog("sOutputXML -- "+sOutputXML);
	WriteLog("returnValues -- "+returnValues);

	out.clear();
	out.print(returnValues);
%>
