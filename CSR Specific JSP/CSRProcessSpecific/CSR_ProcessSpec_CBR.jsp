<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@page import="com.newgen.wfdesktop.cabinet.WDCabinetList"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>


<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
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
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CSR_ProcessSpec_CBR.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/071				   Saurabh Arora
*/
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
	int iJtsPort = 0;
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
	

	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); //Close the browser
		out.println("</script>");
	}
	else
	{
		if(request.getParameter("ProcessInstanceId")==null)
		{
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CSR_ProcessSpec_CBR.jsp
	Purpose         :       For CBR process all status should be allowed except when status is CLSB and closure date is greater than current date then request should not be accepted
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/078					08/01/2009 	Saurabh Arora
*/
			/*Connection conn = null;
			//Statement stmt =null;
			PreparedStatement stmt=null;
			ResultSet result=null;
			String sTempCardDetails="";
			String generalStat = "";
			String generalStatDate = "";
			String currentDate = "";
			String orgGeneralStatDate="";
			try
			{			
				Context aContext = new InitialContext();
				DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
				conn = (Connection)(aDataSource.getConnection());
				WriteLog("got data source");
				//stmt = conn.createStatement();
				String CreditCardNo=request.getParameter("CrdtCN");

				DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				String sSQL = "";*/
/*

	Product/Project :       Rak Bank
	Module          :       Cash Back Request
	File            :       CSR_ProcessSpec_CBR.jsp
	Purpose         :       In case Card status – CLSB and the current date > 30 days + Date (Status change to CLSB), then the request should not be accepted. If it is less than or equal, then request may be taken.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/083					29/01/2009 	Saurabh Arora
*/				
				
				//Changed by Amandeep for CAPS database change
				//sSQL = "select generalstat, GENERALSTATDATE+30, getdate(), GENERALSTATDATE from capsmain where creditcardno='"+CreditCardNo+"'";
				/*sSQL = "select generalstat, GENERALSTATDATE+30, sysdate, GENERALSTATDATE from CAPSADMIN.capsmain where creditcardno=?";
				
				WriteLog("Execute Query..." + sSQL);
				stmt = conn.prepareStatement(sSQL);
				stmt.setString(1, CreditCardNo);
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
						out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\";alert('The Status of Card is Closed dated "+orgGeneralStatDate.substring(0,11)+". Cash Back Request cannot be Processed');</script>");
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
				out.println("<script>alert(\"Data Source For CAPS System Not Found\")</script>");

				if(e.toString().indexOf("Operation timed out: connect:could be due to invalid address")!=-1)
				out.println("<script>alert(\"Unable to connect to CAPS System\")</script>");
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
			
				String sInputXML =	"<?xml version=\"1.0\"?>" + 				
							"<APProcedure2_Input>" +
							"<Option>APProcedure2</Option>" +
							"<ProcName>RB_GetCustomerRAKCardDetails</ProcName>" +						
							"<Params>'"+request.getParameter("CrdtCN")+"'</Params>" +  //Pass blank. It is necessary.
							"<NoOfCols>15</NoOfCols>" +
							"<SessionID>"+sSessionId+"</SessionID>" +
							"<EngineName>"+sCabname+"</EngineName>" +
							"</APProcedure2_Input>";

				
				try{
					sOutputXMLCustomerInfo= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog("RB_GetCustomerRAKCardDetails"+sOutputXMLCustomerInfo);
					if(sOutputXMLCustomerInfo.equals("") || Integer.parseInt(sOutputXMLCustomerInfo.substring(sOutputXMLCustomerInfo.indexOf("<MainCode>")+10 , sOutputXMLCustomerInfo.indexOf("</MainCode>")))!=0)	{
						bError= true;
					}			
				}catch(Exception exp){
					bError=true;			
				}
				if(sOutputXMLCustomerInfo.indexOf("<Results></Results>")!=-1)
				{
					out.println("<script>alert('Customer Not Found');</script>");
					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"CSR_blank.jsp\";</script>");
				}
				else
				{
				sOutputXMLCustomerInfoList = sOutputXMLCustomerInfo.substring(sOutputXMLCustomerInfo.indexOf("<Results>")+9,sOutputXMLCustomerInfo.indexOf("</Results>"));	
				}
		}
		else
		{			
			String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+request.getParameter("ProcessInstanceId")+"</ProcessInstanceId><WorkitemId>1</WorkitemId><QueueId></QueueId><QueueType></QueueType><DocOrderBy></DocOrderBy><DocSortOrder></DocSortOrder><ObjectPreferenceList>W,D</ObjectPreferenceList><GenerateLog>Y</GenerateLog><ZipBuffer></ZipBuffer></WMFetchProcessInstanceAttributes_Input>";
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
			<select name="CASHBACK_TYPE" onblur=enabledisable() onfocus=chkVerificationDet()>
				<option value="">--select--</option>
				<option value="Un-Enrollment">Un-Enrollment</option>
				<option value="Redemption">Redemption</option>				
			</select>
		</td>
		<td  colspan=1 nowrap width="110" height="16" id="AMOUNT" class="EWLabelRB">Amount</td>
        <td colspan=1 nowrap width="10"><input type="text" disabled name="AMOUNT"   value='<%=DataFormHT.get("AMOUNT")==null?"":DataFormHT.get("AMOUNT")%>' size="11" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_CBR') onblur=validateKeys_OnBlur(this,'CSR_CBR') ></td>

    </tr>
	
	<TR>
        <td nowrap width="100" height="16" class="EWLabelRB" id="REMARKS">Remarks/ Reason</td> 
        <td nowrap  width="140" colspan=3><textarea name="REMARKS"  cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT.get("REMARKS")==null?"":DataFormHT.get("REMARKS")%></textarea></td>
	</tr>

</table>
<%}%>

<%
if(request.getParameter("ProcessInstanceId")!=null){
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