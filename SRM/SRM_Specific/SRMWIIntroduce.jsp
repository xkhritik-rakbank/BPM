<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation          
//File Name					 : WIIntroduce.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Cerates WI.
//------------------------------------------------------------------------------------------------------------------------------------>
<!------------------------------------------------------------------------------------------------------
//			CHANGE HISTORY
//----------------------------------------------------------------------------------------------------
// Date			 Change By				Change Description (Bug No. (If Any))
// 22-02-2006	 Manish K. Agrawal		On session expires, introducing a request resulted in error (RLS-OF_Defect_AL_RTRL_C1_06.xls)

//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>


<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<HTML>
<HEAD><style></style></HEAD>
<body class='EWGeneralRB'>
<%
WriteLog("inside SRMWIIntroduce.jsp = ");
String sInputXML ="";
String sOutputXML = "";
String sCabName="";
String userName=null;
String UserIndex=null;
String sSessionId = null;
String sJtsIp = null;
String sProcessDefId="";
String sMsg="";
String sWorkitemNumber="";
//int iJtsPort = 0;
String iJtsPort = "";
boolean bError=false;
int RecordCount=0;
String WI_DATA = "";
WFXmlResponse objWorkListXmlResponse;
WFXmlList objWorkList;

String a="";
String b="";

try{
	WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
	WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
	sCabName = wDCabinetInfo.getM_strCabinetName();
	sSessionId = wDUserInfo.getM_strSessionId();
	userName = wDUserInfo.getM_strUserName();
	UserIndex = wDUserInfo.getM_strUserIndex();
	WriteLog("userName = "+userName+" : UserIndex = "+UserIndex);
	sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
	WI_DATA = request.getParameter("WIData");
	//WI_DATA = WI_DATA.replaceAll("<CCI_CName></CCI_CName>","").replaceAll("<PBODateTime></PBODateTime>","").replaceAll("<IsSTP></IsSTP>","").replaceAll("<IsError></IsError>","").replaceAll("TEMP_WI_NAME","Temp_WI_NAME").replaceAll("IsRejected","isRejected");
	WI_DATA = WI_DATA.replaceAll("TEMP_WI_NAME","Temp_WI_NAME").replaceAll("IsRejected","isRejected");
	sProcessDefId = request.getParameter("ProcessDefId");
	
	/*sSessionId=wDSession.getDMSSessionId();
	sCabName=wDSession.getEngineName();
	sJtsIp=wDSession.getJtsIp();
	iJtsPort=wDSession.getJtsPort();
	userName = wDUserInfo.getM_strUserName();*/

	WriteLog("cabinetName = "+sCabName+" : sessionId = "+sSessionId+" : jtsip = "+sJtsIp+ " : jtsport "+iJtsPort);
	
	sInputXML =	"<?xml version=\"1.0\"?>\n" +
	"<WFUploadWorkItem_Input>" +
	"<Option>WFUploadWorkItem</Option>" +
	"<EngineName>"+sCabName+"</EngineName>" +
	"<SessionId>"+sSessionId+"</SessionId>" +
	"<ProcessDefId>"+sProcessDefId+"</ProcessDefId>" + 
	"<InitiateAlso>N</InitiateAlso>" +	
	WI_DATA +
	"</WFUploadWorkItem_Input>";
	
    WriteLog(sInputXML);
	//sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,Integer.parseInt(iJtsPort),1);
	sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
	//out.println(sOutputXML);
	WriteLog(sOutputXML);
	if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0)
	{
		bError = true;
		if(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")).equals("2"))
		{
			sMsg="Either Process is Disabled Or User does not has rights to perform this operation.";
		}
		else
		{
			//sMsg="Internal Server Error.";
			sMsg=sOutputXML.substring(sOutputXML.indexOf("<Subject>")+9 , sOutputXML.indexOf("</Subject>"));
		}
	}	
	else
	{
		sMsg=sOutputXML.substring(sOutputXML.indexOf("<ProcessInstanceId>")+19 , sOutputXML.indexOf("</ProcessInstanceId>")) + " Created.";
		sWorkitemNumber = sOutputXML.substring(sOutputXML.indexOf("<ProcessInstanceId>")+19 , sOutputXML.indexOf("</ProcessInstanceId>"));
		WriteLog("sWorkitemNumber obtained = "+sWorkitemNumber);
	}
			
	//Below code is to return generated workitemnumber from this jsp to parent jsp file.
    response.setContentType("text/plain");
	response.getWriter().write(sWorkitemNumber);	
	
}catch(Exception ignore){
	//a=ignore.getMainCode();
	//b=ignore.getSource();
}

		



%>
<script>
//alert("Manish shukla...--"+'<%=sMsg%>');
parent.window.returnValue='<%=sMsg%>';
parent.window.close();
</script>

</body>
</html>


