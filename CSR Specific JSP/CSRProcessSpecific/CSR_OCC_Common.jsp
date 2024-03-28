<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%
	WriteLog("inside csr_occ_common.jsp");
	String BranchOptions="";
	String sBranchDetails="";
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	String sUserName = null;
	int iJtsPort = 0;
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);

	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);

	boolean bError=false;
	try{
	
	    WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		sSessionId    = wDUserInfo.getM_strSessionId();
		sJtsIp = wDCabinetInfo.getM_strServerIP();
		iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
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
			sBranchDetails= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
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
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_RIP.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("SSC")!=null&&processName.get("SSC").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@SSC");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_SSC.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CR")!=null&&processName.get("CR").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CR");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_CR.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CLI")!=null&&processName.get("CLI").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CLI");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_CLI.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("ECR")!=null&&processName.get("ECR").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@ECR");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_ECR.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CSI")!=null&&processName.get("CSI").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CSI");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_CSI.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("TD")!=null&&processName.get("TD").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@TD");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_TD.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CU")!=null&&processName.get("CU").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CU");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_CU.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CDR")!=null&&processName.get("CDR").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CDR");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_CDR.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		
		<%} if(processName.get("CS")!=null&&processName.get("CS").toString().equalsIgnoreCase("Y")){ WriteLog("@@@@data found@@@CS");%>
		<jsp:include page="../CSRProcessSpecific/CSR_OCC_CS.jsp" >
		<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
		</jsp:include>
		<%}%>
	<%
	}
	else
	{
			String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+ProcessInstanceId+"</ProcessInstanceId><WorkitemId>1</WorkitemId><QueueId></QueueId><QueueType></QueueType><DocOrderBy></DocOrderBy><DocSortOrder></DocSortOrder><ObjectPreferenceList>W,D</ObjectPreferenceList><GenerateLog>Y</GenerateLog><ZipBuffer></ZipBuffer></WMFetchProcessInstanceAttributes_Input>";
			WriteLog("MAnish1234567788909---345345345-"+sInputXML1);
			String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);	
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
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_RIP.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Card Replacement"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_CR.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Early Card Renewal"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_ECR.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Credit Limit Increase"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_CLI.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Card Upgrade"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_CU.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Transaction Dispute"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_TD.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Change in Standing Instructions"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_CSI.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
			<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Card Delivery Request"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_CDR.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Credit Shield"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_CS.jsp" >
				<jsp:param name="BranchOptions" value="<%=BranchOptions%>"/>
				</jsp:include>
				<%
			}else if(DataFormHT.get("request_type").toString().equalsIgnoreCase("Setup Suppl. Card Limit"))
			{
				%>
				<jsp:include page="../CSRProcessSpecific/CSR_OCC_SSC.jsp" >
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