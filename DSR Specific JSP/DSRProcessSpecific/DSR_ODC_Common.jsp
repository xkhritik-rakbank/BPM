<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@page import="com.newgen.wfdesktop.baseclasses.WDUserInfo"%>
<%@page import="com.newgen.wfdesktop.baseclasses.WDCabinetInfo"%>
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant, com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*, javax.faces.context.FacesContext"%>
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
<%
	String BranchOptions="";
	String sBranchDetails="";
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	//int iJtsPort = 0;
	String iJtsPort = null;
	String sUserName = null;
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessInstanceId"));
	
	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);

	boolean bError=false;
	try{			
			WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
			WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
			sCabname = wDCabinetInfo.getM_strCabinetName();
			WriteLog("sCabname :"+sCabname);
			sSessionId    = wDUserInfo.getM_strSessionId();
			WriteLog("sSessionId :"+sSessionId);
			sJtsIp = wDCabinetInfo.getM_strServerIP();
			iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
			WriteLog("iJtsPort :"+iJtsPort);
			sUserName = wDUserInfo.getM_strUserName()+"";
			WriteLog("suserName :"+sUserName);
		}catch(Exception ignore){
			bError=true;
			WriteLog(ignore.toString());
		}	
	try{
			String Query="select branchid,branchname from rb_branch_details where 1=:ONE";
			String params ="ONE==1";
			String sInputXML =	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + Query + "</Query><Params>"+params+"</Params><EngineName>" + sCabname + "</EngineName><SessionId>"+sSessionId+"</SessionId></APSelectWithNamedParam_Input>";
			//sBranchDetails= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			sBranchDetails = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
			WriteLog(sBranchDetails);
			if(sBranchDetails.equals("") || Integer.parseInt(sBranchDetails.substring(sBranchDetails.indexOf("<MainCode>")+10 , sBranchDetails.indexOf("</MainCode>")))!=0)
			{
				
			}
			else{
				if(sBranchDetails.indexOf("<Record>")!=-1)
				{
					WFXmlResponse xmlResponse1 = new WFXmlResponse(sBranchDetails);
					WFXmlList RecordList1;
					for (RecordList1 =  xmlResponse1.createList("Records", "Record");RecordList1.hasMoreElements();RecordList1.skip())
					{
						String sBranchId=RecordList1.getVal("branchid");
						String sBranchName=RecordList1.getVal("branchname");
						if(BranchOptions.equals(""))
							BranchOptions="<option value=\""+sBranchId+"\">"+sBranchName+"</option>";
						else
							BranchOptions=BranchOptions+"<option value=\""+sBranchId+"\">"+sBranchName+"</option>";
					}
				}				
			}
		}catch(Exception exp){
			WriteLog(exp.toString());
		}

	if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))
		{	

			Hashtable processName=null;
		if(request.getAttribute("subProcessNames")!=null)
		{
		processName=(Hashtable)request.getAttribute("subProcessNames");
			WriteLog("@@@@data found@@@");
		}
		%>

		<% if(processName.get("RIP")!=null&&processName.get("RIP").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@RIP");%>
		<jsp:include page="../DSRProcessSpecific/DSR_ODC_RIP.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CR")!=null&&processName.get("CR").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CR");%>
		<jsp:include page="../DSRProcessSpecific/DSR_ODC_CR.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%}  if(processName.get("ECR")!=null&&processName.get("ECR").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@ECR");%>
		<jsp:include page="../DSRProcessSpecific/DSR_ODC_ECR.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("TD")!=null&&processName.get("TD").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@TD");%>
		<jsp:include page="../DSRProcessSpecific/DSR_ODC_TD.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%}  if(processName.get("CDR")!=null&&processName.get("CDR").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CDR");%>
		<jsp:include page="../DSRProcessSpecific/DSR_ODC_CDR.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%}%>
	<%
	}
	else
	{
			String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+ProcessInstanceId+"</ProcessInstanceId><WorkitemId>1</WorkitemId><QueueId></QueueId><QueueType></QueueType><DocOrderBy></DocOrderBy><DocSortOrder></DocSortOrder><ObjectPreferenceList>W,D</ObjectPreferenceList><GenerateLog>Y</GenerateLog><ZipBuffer></ZipBuffer></WMFetchProcessInstanceAttributes_Input>";
			WriteLog("MAnish1234567788909---345345345-"+sInputXML1);
			//String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);
			String strOutputXMLCat1 = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML1);			
			WriteLog("strOutputXMLCat1---345345345-"+strOutputXMLCat1);
			objWorkListXmlResponse = new WFXmlResponse("");
			objWorkListXmlResponse.setXmlString(strOutputXMLCat1);
			objWorkList = objWorkListXmlResponse.createList("Attributes","Attribute"); 	
			
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{  				
				  DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());				  		
				  WriteLog(objWorkList.getVal("Name").toString()+"======="+objWorkList.getVal("Value").toString());
			}
			request.setAttribute("DataFormHT",DataFormHT);
			%>
				<input type=text readOnly name="request_type" id="request_type" value='<%=DataFormHT.get("request_type")%>' style='display:none'>
			<%
			if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Re-Issue of PIN"))
			{				
				%>
				<jsp:include page="../DSRProcessSpecific/DSR_ODC_RIP.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Card Replacement"))
			{
				%>
				<jsp:include page="../DSRProcessSpecific/DSR_ODC_CR.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Early Card Renewal"))
			{
				%>
				<jsp:include page="../DSRProcessSpecific/DSR_ODC_ECR.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Transaction Dispute"))
			{
				%>
				<jsp:include page="../DSRProcessSpecific/DSR_ODC_TD.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Card Delivery Request"))
			{
				%>
				<jsp:include page="../DSRProcessSpecific/DSR_ODC_CDR.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}
	}

%>

<%
if(ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase("")){
	if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Pending"))
	{
	%>		
		<table>
			<tr>
				<td nowrap width="100" height="16" class="EWLabelRB" id="Pending_Dec">Pending Decision</td>
				<td nowrap width="180">
					<select name="Pending_Decision">
						<option value="P_Approve">Approve</option>
						<option value="P_Discard">Discard</option>
					</select>
				</td>
			</tr>
		</table>
	<%	
	}
if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("CARDS"))
{%>
		<input type=text readOnly name="Card_UserName" id="Card_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="Card_DateTime" id="Card_DateTime" value='<%=sDate%>' style='display:none'>
<%}
else if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Approver"))
{%>
		<input type=text readOnly name="BA_UserName" id="BA_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BA_DateTime" id="BA_DateTime" value='<%=sDate%>' style='display:none'>
<%}
else if(DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Pending")||DataFormHT.get("ActivityName").toString().equalsIgnoreCase("Branch_Return"))
{%>
		<input type=text readOnly name="BU_UserName" id="BU_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BU_DateTime" id="BU_DateTime" value='<%=sDate%>' style='display:none'>
<%}
 }
 else
 {%>
		<input type=text readOnly name="BU_UserName" id="BU_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BU_DateTime" id="BU_DateTime" value='<%=sDate%>' style='display:none'>
<%}%>