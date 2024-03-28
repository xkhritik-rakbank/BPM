<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*,java.util.Date,java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>
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
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/DSR_RBCommon.js"></script>

<script>
function chkVerificationDet()
{
	
	if (document.forms[0].VD_MoMaidN.checked==false && document.forms[0].VD_TINCheck.checked==false)
	{
		alert("Enter Verification Details");
        document.forms[0].VD_TINCheck.focus();
    }
}
function CheckMxLength(data,val)
{
	var issue=data.value;
	if(issue.length>=val+1)
	{
		alert("Remarks/Reasons can't be greater than 500 Characters");
		var lengthRR="";
		lengthRR=issue.substring(0,val);
		data.value=lengthRR;
		
	}
	return true;
}
function AddPendingOptions(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptions');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelected');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+'Pending option is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
						
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
			
			if(selectedValueId=='PendingOptionsSelected'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelected');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "|";

					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
			
		}
		
		
function RemovePendingOptions(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelected');

	if(element.options.length==0)
		alert('No Pending Option to Remove');
	else if(element.selectedIndex==-1 && element.options.length!=0)
		alert('Select a Pending option to remove');
	else
	{
		var len=element.options.length;
		for(i=len-1;i>=0;i--)
		{
			if(element.options[i] != null && element.options[i].selected)
			{
				element.options[i]=null;
			}
		}
	}
	
	if(selectedValueId=='PODOptionsSeleceted'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelected');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
	 
	}
}




</script>

<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	//int iJtsPort = 0;
	String iJtsPort = null;
	String sUserName = null;
	boolean bError=false;
	String sRAKBankCard="";
	String sCardType="";
	String sExpDate="";
	String sBTAmt="";
	String sAppCode="";
	Hashtable ht=new Hashtable();
	String sOutputXMLCustomerInfoList ="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	String sBranchDetails="";
	int iCardCount=0;
	String sOutputXMLCustomerInfo ="";

	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessInstanceId"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DebitCN", request.getParameter("DebitCN"), 1000, true) );
	String DebitCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: DebitCN: "+DebitCN);

	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);

	
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
	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); //Close the browser
		out.println("</script>");
	}
	else
	{
		if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))
		{
			/*	sOutputXMLCustomerInfo="";
				
			Connection conn = null;
			Statement stmt =null;
			ResultSet result=null;
				try{			
					Context aContext = new InitialContext();
					DataSource aDataSource = (DataSource)aContext.lookup("jdbc/rakcabinet");
					conn = (Connection)(aDataSource.getConnection());
					WriteLog("got data source");
					CallableStatement proc =conn.prepareCall("{ call RB_GetCustomerRAKCardDetails_Debit(?,?) }");
					proc.setString(1,DebitCN);
					proc.registerOutParameter(2, java.sql.Types.VARCHAR);
					//proc.setString(2,sOutputXMLCustomerInfo);
					ResultSet rs1=proc.executeQuery();
					//proc.execute();
					sOutputXMLCustomerInfo=proc.getString(2);
					WriteLog("output::"+sOutputXMLCustomerInfo);
					
				}
				catch (SQLException e)
				{
					//WriteLog("outputException::"+sOutputXMLCustomerInfo);
				}
				catch (Exception e)
				{
					//WriteLog("outputException::"+sOutputXMLCustomerInfo);
				}
				if(sOutputXMLCustomerInfo.equalsIgnoreCase("null!null!null!null!null!null!null!null!null!null!null!null!null!null!null"))
					sOutputXMLCustomerInfo="<Results></Results>";
				else
					sOutputXMLCustomerInfo="<Results>"+sOutputXMLCustomerInfo+"</Results>";
				if(sOutputXMLCustomerInfo.indexOf("<Results></Results>")!=-1)
				{
					out.println("<script>alert('Customer Not Found');</script>");
					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
				}
				else
				{
				sOutputXMLCustomerInfoList = sOutputXMLCustomerInfo.substring(sOutputXMLCustomerInfo.indexOf("<Results>")+9,sOutputXMLCustomerInfo.indexOf("</Results>"));	
				}*/
		}
	else {
					
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
			sOutputXMLCustomerInfoList=DataFormHT.get("cardDetails").toString();
		
	}
if(sOutputXMLCustomerInfo.indexOf("<Results></Results>")==-1)
{
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
				
			}
		}catch(Exception exp){
			WriteLog(exp.toString());
		}

%>

<table border="1" cellspacing="1" cellpadding="1" width=100% >
	<input type='text' name='Header' readOnly size='24' style='display:none' value=''>
	<!--<tr class="EWHeader" width=100% class="EWLabelRB2">
		<td colspan=4 align=left class="EWLabelRB3"><b>Other Bank Card Details</b></td>
	</tr>       -->
	 

<TR>
        <td nowrap width="180" height="16" id="REMARKS" class="EWLabelRB">Remarks/ Reason</td> 
        <td nowrap  width="180" colspan=3><textarea name="REMARKS"  value='<%=DataFormHT.get("REMARKS")==null?"":DataFormHT.get("REMARKS")%>' cols=50 onKeyup="CheckMxLength(this,500);" rows=2 ></textarea></td>
	</tr>
		<TR>
		<td nowrap width="140" height="30" class="EWLabelRB"  id="CSR_RR_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptions" style="width: 160;" name="PendingOptions" >
								<option value="">--select--</option>
								<option value="Travel Document">Travel Document</option>
								<option value="Medical Report">Medical Report</option>
								<option value="TT Swift Copy">TT Swift Copy</option>
								<option value="Payment Receipt">Payment Receipt</option>
								<option value="Application Screenshot">Application Screenshot</option>
								<option value="Tenancy Contract">Tenancy Contract </option>
								<option value="Salary Certificate">Salary Certificate</option>
								<option value="Bank Statement">Bank Statement</option>
								<option value="PaySlip">PaySlip</option>
								<option value="Emirates ID Copy">Emirates ID Copy</option>
								<option value="Passport Copy">Passport Copy</option>
								<option value="Visa Copy">Visa Copy</option>
								<option value="Salary Transfer Letter">Salary Transfer Letter</option>
								<option value="Labour Contract">Labour Contract</option>
								<option value="Transaction Receipt">Transaction Receipt</option>
								<option value="Lifestyle Declaration">Lifestyle Declaration</option>
								<option value="Others">Others</option>
								</select>
					</td>
					<td  nowrap='nowrap' height ='30' width = 180 class='EWNormalGreenGeneral1' valign="middle"> 
						<input type="button" id="addButtonPendingOptions" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptions('PendingOptions','PendingOptionsSelected');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptions" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptions('PendingOptions','PendingOptionsSelected');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelected'  name='PendingOptionsSelected' multiple='multiple' style="width:150px">
						</select>

					</td>
					
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>

</table>
<%}}%>

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
 {
    
 %>
		<input type=text readOnly name="BU_UserName" id="BU_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BU_DateTime" id="BU_DateTime" value='<%=sDate%>' style='display:none'>
<%}%>