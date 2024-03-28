<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.Date,java.sql.*,java.util.*"%>
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

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/DSR_RBCommon.js"></script>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource,java.sql.PreparedStatement" %>
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
function enabledisable()
{
	
	if (document.forms[0].CASHBACK_TYPE.options[document.forms[0].CASHBACK_TYPE.selectedIndex].value.toUpperCase()=='REDEMPTION')
	{
		document.forms[0].AMOUNT.disabled=false;
		document.forms[0].AMOUNT.focus();
    }
	else
	{
		document.forms[0].AMOUNT.value="";
		document.forms[0].AMOUNT.disabled=true;
        
	}
} 

</script>

<%
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	String sUserName = null;
	String iJtsPort = null;
	//int iJtsPort = 0;
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
	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessInstanceId: "+ProcessInstanceId);
	WriteLog("Integration jsp: ProcessInstanceId 1: "+request.getParameter("ProcessInstanceId"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DebitCN", request.getParameter("DebitCN"), 1000, true) );
	String DebitCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: DebitCN: "+DebitCN);

	
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

			Connection conn = null;
			//Statement stmt =null;
			PreparedStatement stmt=null;
			ResultSet result=null;
			String sTempCardDetails="";
			String generalStat = "";
			String generalStatDate = "";
			String currentDate = "";
			String orgGeneralStatDate="";
			WriteLog("ABC::"+request.getQueryString());
			if (generalStat.equals("CLSB"))
			{
					WriteLog("Inside...");
				out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\";alert('The Status of Card is Closed. Cash Back Request cannot be Processed');</script>");
			}
			//Amandeep general Status date to be fetched
			/*Commented by Amandeep on 17 jan 2010
			try
			{			
				Context aContext = new InitialContext();
				//DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
				DataSource aDataSource = (DataSource)aContext.lookup("jdbc/rakcabinet");
				conn = (Connection)(aDataSource.getConnection());
				WriteLog("got data source");
				//stmt = conn.createStatement();
				String DebitCardNo=DebitCN;

				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				String sSQL = "";
				
				
				sSQL = "select generalstat, GENERALSTATDATE+30, getdate(), GENERALSTATDATE from DBCARDS_ADDHOLDERS a where a.CARD_NUMBER=?";
				
				WriteLog("Execute Query..." + sSQL);
				stmt = conn.prepareStatement(sSQL);
				stmt.setString(1, DebitCardNo);
				result = stmt.executeQuery();
				Calendar cal = Calendar.getInstance();
				while (result.next())
				{
					generalStat = result.getString(1);
					generalStatDate = result.getString(2);
					currentDate = result.getString(3);
					orgGeneralStatDate = result.getString(4);
				}	
				WriteLog("generalStat : "+generalStat);
				WriteLog("generalStatDate : "+generalStatDate);
				WriteLog("currentDate : "+currentDate);
				if (generalStat.equals("CLSB"))
				{
					WriteLog("Inside...");
					Date d1 = df.parse(generalStatDate);
					Date d2 = df.parse(currentDate);
					WriteLog("Gen Date: "+d1.toString());

					if (d2.after(d1))
					{
						WriteLog("Amnnnn:");		
						//out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\";alert('The Status of Card is Closed dated "+orgGeneralStatDate.substring(0,11)+". Cash Back Request cannot be Processed');</script>");
						
					}

				}
				if(result != null)
				{
					result.close();
					result=null;
					WriteLog("resultset Successfully closed"); 
				}
				if(stmt != null)
				{
					stmt.close();
					stmt=null;						
					WriteLog("Stmt Successfully closed"); 
				}
				if(conn != null)
				{
					conn.close();
					conn=null;	
					WriteLog("Conn Successfully closed"); 
				}
			}
			catch (Exception e)
			{
				WriteLog("Exception : "+e.toString());
				if(e.getClass().toString().equalsIgnoreCase("Class javax.naming.NameNotFoundException"))
				out.println("<script>alert(\"Data Source For RAKCABINET, Not Found\")</script>");

				if(e.toString().indexOf("Operation timed out: connect:could be due to invalid address")!=-1)
				out.println("<script>alert(\"Unable to connect to RAKCABINET\")</script>");
			}
			finally
			{
				if(result != null)
				{
					result.close();
					result=null;
					WriteLog("resultset Successfully closed"); 
				}
				if(stmt != null)
				{
					stmt.close();
					stmt=null;						
					WriteLog("Stmt Successfully closed"); 
				}
				if(conn != null)
				{
					conn.close();
					conn=null;	
					WriteLog("Conn Successfully closed"); 
				}
			}*/
				/*sOutputXMLCustomerInfo="";
				try{			
					Context aContext = new InitialContext();
					DataSource aDataSource = (DataSource)aContext.lookup("jdbc/rakcabinet");
					conn = (Connection)(aDataSource.getConnection());
					WriteLog("got data source");
					CallableStatement proc =conn.prepareCall("{ call RB_GetCustomerRAKCardDetails_Debit(?,?) }");
					proc.setString(1, DebitCN);
					proc.registerOutParameter(2, java.sql.Types.VARCHAR);
					ResultSet rs1=proc.executeQuery();
					sOutputXMLCustomerInfo=proc.getString(2);
					WriteLog("output::"+sOutputXMLCustomerInfo);
					
				}
				catch (SQLException e)
				{
					// ....
				}
				catch (Exception e)
				{
					WriteLog("Exception Occured: "+e.toString());
				}
				
				if(sOutputXMLCustomerInfo.equalsIgnoreCase("null!null!null!null!null!null!null!null!null!null!null!null!null!null!null"))
					sOutputXMLCustomerInfo="<Results></Results>";
				else
					sOutputXMLCustomerInfo="<Results>"+sOutputXMLCustomerInfo+"</Results>";			
				if(sOutputXMLCustomerInfo.indexOf("<Results></Results>")!=-1)
				{
					out.println("<script>alert('Customer Not Found');</script>");
				WriteLog("Aaaaa:");	out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"DSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"DSR_blank.jsp\";</script>");
				
				}
				else
				{
					sOutputXMLCustomerInfoList = sOutputXMLCustomerInfo.substring(sOutputXMLCustomerInfo.indexOf("<Results>")+9,sOutputXMLCustomerInfo.indexOf("</Results>"));
					WriteLog("sOutputXMLCustomerInfoList --ABCD:"+sOutputXMLCustomerInfoList);
					
				}*/
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
			sOutputXMLCustomerInfoList=DataFormHT.get("cardDetails").toString();
		}
	
%>







<table border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='CBR (Cash Back Request) Details'>
		<td colspan=4 align=left class="EWLabelRB2"><b>CBR (Cash Back Request) Details </b></td>
	</tr>	

	<TR>

	    <td colspan=1 nowrap width="110" height="16" id="C_CASHBACK_TYPE" class="EWLabelRB">Type</td>
	    <td nowrap width="115">
			<select name="CASHBACK_TYPE" onchange=enabledisable() onblur=enabledisable() onfocus=chkVerificationDet()>
				<option value="">--Select--</option>
				<option value="Un-Enrollment">Un-Enrollment</option>
				<option value="Redemption">Redemption</option>				
			</select>
		</td>
		<td  colspan=1 nowrap width="110" height="16" id="AMOUNT" class="EWLabelRB">Amount</td>
        <td colspan=1 nowrap width="10"><input type="text" disabled name="AMOUNT"   value='<%=DataFormHT.get("AMOUNT")==null?"":DataFormHT.get("AMOUNT")%>' size="11" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'DSR_CBR') onblur=validateKeys_OnBlur(this,'DSR_CBR') ></td>

    </tr>
	
	<TR>
        <td nowrap width="100" height="16" class="EWLabelRB" id="REMARKS">Remarks/ Reason</td> 
        <td nowrap  width="140" colspan=3><textarea name="REMARKS"  cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT.get("REMARKS")==null?"":DataFormHT.get("REMARKS")%></textarea></td>
	</tr>

</table>
<%}%>

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