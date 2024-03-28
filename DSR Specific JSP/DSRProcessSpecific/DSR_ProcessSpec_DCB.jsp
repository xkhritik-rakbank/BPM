<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,java.util.Date"%>
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

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->


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

function resetfieldvalue(cntrl)
{
	if(cntrl.value=="dd/MM/yyyy<space>hh:mm")
	{
		cntrl.value="";
		return false;
	}
}

function enabledisable(cntrl)
{
	if(cntrl.name=="DELIVER_TO")
	{
		if (document.forms[0].DELIVER_TO.options[document.forms[0].DELIVER_TO.selectedIndex].value.toUpperCase()=="BANK")
		{
			document.forms[0].BRANCH_NAME.disabled=false;
			document.forms[0].BRANCH_NAME.focus();
		}
		else
		{
			document.forms[0].BRANCH_NAME.selectedIndex=0;
			document.forms[0].BRANCH_NAME.disabled=true;
		}
	}
	var objWI_Obj=window.top.wi_object;
	var objDataForm=window.document.forms["dataform"];
	if(objWI_Obj !="undefined"&&objWI_Obj !=null)
	{
    objWI_Obj.attribute_list['REASON_HOTLIST'].value=objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value;
	objWI_Obj.attribute_list['REASON_HOTLIST'].modified_flag=true;
	objWI_Obj.attribute_list['ACTION_TAKEN'].value=objDataForm.ACTION_TAKEN.options[objDataForm.ACTION_TAKEN.selectedIndex].value;
	objWI_Obj.attribute_list['ACTION_TAKEN'].modified_flag=true;
	objWI_Obj.attribute_list['DELIVER_TO'].value=objDataForm.DELIVER_TO.options[objDataForm.DELIVER_TO.selectedIndex].value;
	objWI_Obj.attribute_list['DELIVER_TO'].modified_flag=true;
	objWI_Obj.attribute_list['BRANCH_NAME'].value=objDataForm.BRANCH_NAME.options[objDataForm.BRANCH_NAME.selectedIndex].value;
	objWI_Obj.attribute_list['BRANCH_NAME'].modified_flag=true;
	objWI_Obj.attribute_list['REMARKS'].value=objDataForm.REMARKS.value;
	objWI_Obj.attribute_list['REMARKS'].modified_flag=true;
	}




	if(cntrl.name=="ACTION_TAKEN")
	{
		if (document.forms[0].ACTION_TAKEN.options[document.forms[0].ACTION_TAKEN.selectedIndex].value.toUpperCase()=="" || document.forms[0].ACTION_TAKEN.options[document.forms[0].ACTION_TAKEN.selectedIndex].value=="Customer will call back" || document.forms[0].ACTION_TAKEN.options[document.forms[0].ACTION_TAKEN.selectedIndex].value=="Customer is overdue" || document.forms[0].ACTION_TAKEN.options[document.forms[0].ACTION_TAKEN.selectedIndex].value=="Customer is Over limit" || document.forms[0].ACTION_TAKEN.options[document.forms[0].ACTION_TAKEN.selectedIndex].value=="Others")
		{
			document.forms[0].DELIVER_TO.selectedIndex=0;
			document.forms[0].BRANCH_NAME.selectedIndex=0;
			document.forms[0].DELIVER_TO.disabled=true;
			document.forms[0].BRANCH_NAME.disabled=true;
		}
		else
		{
			document.forms[0].DELIVER_TO.disabled=false;
		}
		if (document.forms[0].ACTION_TAKEN.options[document.forms[0].ACTION_TAKEN.selectedIndex].value=="Others")
		{
			document.forms[0].ACTION_OTHER.disabled=false;
		}
		else
		{
			document.forms[0].ACTION_OTHER.disabled=true;
			document.forms[0].ACTION_OTHER.value="";
		}
	}

	if(cntrl.name=="REASON_HOTLIST")
	{
		if(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value.toUpperCase()=="OTHERS")
		{
			objDataForm.HOST_OTHER.disabled=false;
			objDataForm.HOST_OTHER.focus();
			//return false;
		}
		else
		{
			objDataForm.HOST_OTHER.value="";
			objDataForm.HOST_OTHER.disabled=true;
			//return false;
		}

		if(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value.toUpperCase()=="WRONG EMBOSSING NAME")
		{
			objDataForm.EMBOSING_NAME.disabled=false;
			objDataForm.EMBOSING_NAME.focus();
			//return false;
		}
		else
		{
			objDataForm.EMBOSING_NAME.value="";
			objDataForm.EMBOSING_NAME.disabled=true;
			//return false;
		}
		if(objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value.toUpperCase()=="EMAIL FROM")
		{
			objDataForm.EMAIL_FROM.disabled=false;
			objDataForm.EMAIL_FROM.focus();
			//return false;
		}
		else
		{
			objDataForm.EMAIL_FROM.value="";
			objDataForm.EMAIL_FROM.disabled=true;
			//return false;
		}
		var REASON_HOTLISTdata=objDataForm.REASON_HOTLIST.options[objDataForm.REASON_HOTLIST.selectedIndex].value.toUpperCase();

		if(REASON_HOTLISTdata=="LOST"||REASON_HOTLISTdata=="STOLEN"||REASON_HOTLISTdata=="CAPTURED")
		{
			objDataForm.CB_DateTime.disabled=false;
			objDataForm.PLACE.disabled=false;
			objDataForm.CB_DateTime.focus();
			//return false;			
		}
		else
		{
			objDataForm.CB_DateTime.value="";
			objDataForm.CB_DateTime.disabled=true;
			objDataForm.PLACE.value="";
			objDataForm.PLACE.disabled=true;
			//return false;
		}
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
	
	Date systemDate = new Date();
	

	
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
			/*sOutputXMLCustomerInfo="";
				
			Connection conn = null;
			Statement stmt =null;
			ResultSet result=null;
				try{			
					Context aContext = new InitialContext();
					DataSource aDataSource = (DataSource)aContext.lookup("jdbc/rakcabinet");
					conn = (Connection)(aDataSource.getConnection());
					WriteLog("got data source");
					CallableStatement proc =conn.prepareCall("{ call RB_GetCustomerRAKCardDetails_Debit(?,?) }");
					proc.setString(1, DebitCN);
					proc.registerOutParameter(2, java.sql.Types.VARCHAR);
					//proc.setString(2,sOutputXMLCustomerInfo);
					ResultSet rs1=proc.executeQuery();
					//proc.execute();
					sOutputXMLCustomerInfo=proc.getString(2);
					WriteLog("output::"+sOutputXMLCustomerInfo);
					
				}
				catch (SQLException e)
				{
					// ....
				}
				catch (Exception e)
				{
					// ....
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
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Details of hotlisting'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Details of hotlisting </b></td>
	</tr>

	<!--<tr class="EWHeader" width=100% class="EWLabelRB2">
		<td colspan=4 align=left class="EWLabelRB3"><b>Other Bank Card Details</b></td>
	</tr>       -->
	
	<TR>
         <td nowrap width="180" height="16" id="C_REASON_HOTLIST" class="EWLabelRB">Reason for hot listing</td>
         <td nowrap width="180">
			<select name="REASON_HOTLIST" onblur="enabledisable(this);">
				<option value="">--Select--</option>
				<option value="Lost">Lost</option>
				<option value="Stolen">Stolen</option>
				<option value="Captured">Captured</option>
				<!--<option value="Blocked">Blocked</option>-->
				<option value="Magnetic Strip is Damaged">Magnetic Strip is Damaged</option>
				<option value="Misuse">Misuse</option>
				<option value="Email From">Email From</option>
				<option value="Wrong Embossing Name">Wrong Embossing Name</option>
				<option value="Others">Others</option>
			</select>
		</td>
		 <td nowrap width="180" height="16" id="HOST_OTHER" class="EWLabelRB">Others (Pls specify)</td>
	 <td nowrap  width="50" colspan=0><input type="text" name="HOST_OTHER" maxlength=50 value='<%=DataFormHT.get("HOST_OTHER")==null?"":DataFormHT.get("HOST_OTHER")%>' size="8" maxlength=100
	 style='width:200px;' disabled></td>
</tr>


<TR>
	 <td nowrap width="180" height="16" id="EMBOSING_NAME" class="EWLabelRB">New Embossing Name(max 19)</td>
	 <td nowrap  width="100" colspan=0><input type="text" name="EMBOSING_NAME" maxlength =19 value='<%=DataFormHT.get("EMBOSING_NAME")==null?"":DataFormHT.get("EMBOSING_NAME")%>' size="8" maxlength=100
	 style='width:200px;' disabled onkeyup=validateKeys(this,'DSR_DCB') ></td>

	  <td nowrap width="180" height="16" id="EMAIL_FROM" class="EWLabelRB">Email From</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="EMAIL_FROM" maxlength=50 value='<%=DataFormHT.get("EMAIL_FROM")==null?"":DataFormHT.get("EMAIL_FROM")%>' size="8" maxlength=100
	 style='width:200px;' disabled></td>
       
	</tr>

<TR>
	 <td nowrap width="180" height="16" id="CB_DateTime" class="EWLabelRB">Date & Time of L/S/C(DD/MM/YYYY(space)hh:mm)</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="CB_DateTime" maxlength =20 value='<%=DataFormHT.get("CB_DateTime")==null?"":DataFormHT.get("CB_DateTime")%>' size="8" maxlength=100
	 style='width:200px;' disabled onkeypress="resetfieldvalue(this);"></td>

	 <td nowrap width="180" height="16" id="PLACE" class="EWLabelRB">Place</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="PLACE" maxlength =30 value='<%=DataFormHT.get("PLACE")==null?"":DataFormHT.get("PLACE")%>' size="8" maxlength=100
	 style='width:200px;' disabled ></td>
        	 
	</tr>
	<TR>
	<td nowrap width="180" height="16" class="EWLabelRB" id="AVAILABLE_BALANCE">Available Balance</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="AVAILABLE_BALANCE" maxlength =11 value='<%=DataFormHT.get("AVAILABLE_BALANCE")==null?"":DataFormHT.get("AVAILABLE_BALANCE")%>' size="8" maxlength=100
	 style='width:200px;' onkeyup=validateKeys(this,'DSR_DCB') onblur=validateKeys_OnBlur(this,'DSR_DCB')></td>

	 <td nowrap width="180" height="16" class="EWLabelRB" id="C_STATUS_B_BLOCK" >Card status before block</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="C_STATUS_B_BLOCK" value='<%=DataFormHT.get("C_STATUS_B_BLOCK")==null?"":DataFormHT.get("C_STATUS_B_BLOCK")%>' size="8" maxlength=2
	 style='width:200px;' onkeyup=validateKeys(this,'DSR_DCB')  ></td>
     
</tr>

<TR>
	 

	 <td nowrap width="180" height="16" class="EWLabelRB" id="C_STATUS_A_BLOCK">Card status after block</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="C_STATUS_A_BLOCK" value='<%=DataFormHT.get("C_STATUS_A_BLOCK")==null?"":DataFormHT.get("C_STATUS_A_BLOCK")%>' size="8" maxlength=2
	 style='width:200px;' onkeyup=validateKeys(this,'DSR_DCB') ></td>
        	 
	</tr>

<tr class="EWHeader" width=100% class="EWLabelRB2">
<input type='text' name='Header' readOnly size='24' style='display:none' value='Replacement Request'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Replacement Request</b></td>
	</tr>

	<TR>
         <td nowrap width="100" height="16" id="C_ACTION_TAKEN" class="EWLabelRB">Action Taken</td>
         <td nowrap width="180">
			<select name="ACTION_TAKEN"  onblur="enabledisable(this);">
				<option value="">--Select--</option>
				<option value="Issue Replacement">Issue Replacement</option>
				<option value="Customer will call back">Customer will call back&nbsp&nbsp&nbsp</option>
				<option value="Customer is overdue">Customer is overdue</option>
				<option value="Customer is Over limit">Customer is Over limit</option>
				<option value="Others">Others</option>
			</select>
		</td>
		<td nowrap width="180" height="16" id="ACTION_OTHER" class="EWLabelRB">Others (Pls specify)</td>
	 <td nowrap  width="180" colspan=0><input type="text" name="ACTION_OTHER" maxlength=50 value='<%=DataFormHT.get("ACTION_OTHER")==null?"":DataFormHT.get("ACTION_OTHER")%>' size="8" maxlength=100
	 style='width:200px;' disabled></td>
 </tr>

<TR>
         <td nowrap width="100" height="16" id="C_DELIVER_TO" class="EWLabelRB">Deliver to</td>
         <td nowrap width="180">
			<select name="DELIVER_TO" onblur= enabledisable(this) disabled>
				<option value="">--Select--</option>
				<option value="Bank">Branch</option>
				<option value="Courier to Work Address">Courier to Work Address</option>
				<option value="Personal Pick Up">Personal Pick Up</option>
				<option value="International Address">International Address</option>
			</select>
		</td>

       <td nowrap width="100" height="16" id="C_BRANCH_NAME" class="EWLabelRB">Branch name</td>
         <td nowrap width="180">
			<select name="BRANCH_NAME" disabled>
			 <option value="">--Select--</option>
		<% if(sBranchDetails.indexOf("<Record>")!=-1)
				{
					WFXmlResponse xmlResponse1 = new WFXmlResponse(sBranchDetails);
					WFXmlList RecordList1;
					for (RecordList1 =  xmlResponse1.createList("Records", "Record");RecordList1.hasMoreElements();RecordList1.skip())
					{
						String sBranchId=RecordList1.getVal("branchid");
						String sBranchName=RecordList1.getVal("branchname");
						/*String t = sBranchName.substring(0,1);
						String t1 = sBranchName.substring(1,sBranchName.length());
						String tot = t.toUpperCase()+t1.toLowerCase();*/
						out.println("<option value=\""+sBranchId+"\">"+sBranchName+"</option>");
//						WriteLog("sBranchId---"+sBranchId+"     sBranchName-----"+sBranchName);
					}
				}%>
		</select>
		</td>
</tr>


<TR>
        <td nowrap width="180" height="16" id="REMARKS" class="EWLabelRB">Remarks/ Reason</td> 
        <td nowrap  width="180" colspan=3><textarea name="REMARKS" rows=2 onKeyup="CheckMxLength(this,500);" value='<%=DataFormHT.get("REMARKS")==null?"":DataFormHT.get("REMARKS")%>' cols=50 rows=2></textarea></td>
	</tr>

</table>
<input type="hidden" name="serverdate" value = <%=systemDate%>>
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
 {%>
		<input type=text readOnly name="BU_UserName" id="BU_UserName" value='<%=sUserName%>' style='display:none'>
		<input type=text readOnly name="BU_DateTime" id="BU_DateTime" value='<%=sDate%>' style='display:none'>
<%}%>