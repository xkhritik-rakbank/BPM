<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="Log.process"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.FileNotFoundException"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>

<%
		WriteLog("Inside FetchOFCIFRelatedWIDetails: ");
		
		String strPropFilePath= System.getProperty("user.dir") + File.separator + "CustomConfig" + File.separator + "TWC_Config.properties";
		WriteLog("Inside strPropFilePath: "+strPropFilePath);
		
		Properties p =  new Properties();
		
		/*try {
			p.load(new FileInputStream(strPropFilePath));
		}
		catch (FileNotFoundException e)
		{
			
		}
		catch (Exception e)
		{
			
		} */
		
		p.load(new FileInputStream(strPropFilePath));
		
		String cabinetName = p.getProperty("CabinetName");
			WriteLog("cabinetName: "+cabinetName);
		String userName = p.getProperty("userName");
			WriteLog("userName: "+userName);
		String password = p.getProperty("password");
			WriteLog("password: "+password);
		String jtsIP = p.getProperty("jtsIP");
			WriteLog("jtsIP: "+jtsIP);
		String jtsPort = p.getProperty("jtsPort");
			WriteLog("jtsPort: "+jtsPort);
		String AppIP = p.getProperty("AppIP");
			WriteLog("AppIP: "+AppIP);
			
			String sJtsIp = customSession.getJtsIp();
			WriteLog("sJtsIp: "+sJtsIp);
		int iJtsPort = customSession.getJtsPort();
		WriteLog("iJtsPort: "+iJtsPort);
		
			
		String Query2 = "";
		String sSessionId = customSession.getDMSSessionId();
        WriteLog("sSessionId: "+sSessionId);

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
		WriteLog("Inside load CIF Related Details.jsp");
		String CIF_ID=request.getParameter("CIF_ID");
		WriteLog("CIF ID : "+CIF_ID);
		
		String inputConnectXML="<?xml version='1.0'?><WMConnect_Input><Option>WMConnect</Option><EngineName>"+cabinetName+"</EngineName><ApplicationInfo>"+AppIP+"</ApplicationInfo><Participant><Name>"+userName+"</Name><Password>"+password+"</Password><Scope></Scope><UserExist>Y</UserExist><ParticipantType>U</ParticipantType></Particpant></WMConnect_Input>";
		
		WriteLog("\nInput Xml to connect cabinet for CIF_ID: "+inputConnectXML);
		
		String outputConnectXML = WFCustomCallBroker.execute(inputConnectXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output Xml to connect cabinet for CIF_ID: "+CIF_ID+" ---- "+outputConnectXML);
		
		
	/*	String[] colNames = {"WI_NAME","TL_Number","createdat"};
		Query2 = "SELECT WI_NAME,TL_Number,createdat FROM RB_TWC_EXTTABLE with (nolock) WHERE CIF_Id=:CIF_ID order by IntoducedAt asc";
		params="CIF_ID=="+CIF_ID;
		WriteLog("Query2");
		WriteLog("params"+params);
		
		inputXMLstate = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query2 + "</Query><Params>"+params+"</Params><EngineName>" + cabinetName + "</EngineName><SessionId></SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput Xml For Get WI Data for CIF_ID: "+CIF_ID+" -- "+inputXMLstate);
		
		outputXMLstate = WFCustomCallBroker.execute(inputXMLstate, jtsIP, jtsPort, 1);
		WriteLog("Output Xml For Get WI Data for CIF_ID: "+CIF_ID+" ---- "+outputXMLstate); */
		
%>