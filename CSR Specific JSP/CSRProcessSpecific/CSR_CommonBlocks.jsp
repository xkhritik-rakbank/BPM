
<%@ include file="../CSRProcessSpecific/Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>

<%@page import="com.newgen.wfdesktop.util.AESEncryption"%>
<%@page import="com.newgen.wfdesktop.cabinet.WDCabinetList"%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<script>
function EnableDisablechkbox()
{
var objDataForm=document.forms["dataform"];

var objWI_Obj=window.top.wi_object;
if (objDataForm.VD_MoMaidN.checked==true)
{
	objDataForm.VD_POBox.disabled=false;
	objDataForm.VD_Oth.disabled=false;
	objDataForm.VD_MRT.disabled=false;
    objDataForm.VD_StaffId.disabled=false;
	objDataForm.VD_EDC.disabled=false;
	objDataForm.VD_PassNo.disabled=false;
	objDataForm.VD_NOSC.disabled=false;
	objDataForm.VD_SD.disabled=false;
	objDataForm.VD_TELNO.disabled=false;
	objDataForm.VD_DOB.disabled=false;
	objDataForm.VD_TINCheck.checked=false;
	objDataForm.VD_TINCheck.disabled=true;	
}
else
	{
	objDataForm.VD_POBox.checked=false;
	objDataForm.VD_Oth.checked=false;
	objDataForm.VD_MRT.checked=false;
	objDataForm.VD_StaffId.checked=false;
	objDataForm.VD_EDC.checked=false;
	objDataForm.VD_PassNo.checked=false;
	objDataForm.VD_NOSC.checked=false;
	objDataForm.VD_SD.checked=false;
	objDataForm.VD_TELNO.checked=false;
	objDataForm.VD_DOB.checked=false;
	objDataForm.VD_POBox.disabled=true;
	objDataForm.VD_Oth.disabled=true;
	objDataForm.VD_MRT.disabled=true;
    objDataForm.VD_StaffId.disabled=true;
	objDataForm.VD_EDC.disabled=true;
	objDataForm.VD_PassNo.disabled=true;
	objDataForm.VD_NOSC.disabled=true;
	objDataForm.VD_SD.disabled=true;
	objDataForm.VD_TELNO.disabled=true;
	objDataForm.VD_DOB.disabled=true;
	objDataForm.VD_TINCheck.disabled=false;
	}

}
</script>

<%
	WriteLog("Inside CSR_CommonBlocks");
	String sCabname=null;
	String sSessionId = null;
	String sJtsIp = null;
	int iJtsPort = 0;
	boolean bError=false;
	String sCustomerName="";
	String sExpiryDate="";
	String sCardCRNNo="";
	String sSourceCode="";
	String sExtNo="";
	String sReqType="";
	String sMobileNo="";
	String sAccessedIncome="";		
	String sCardType="";
	String sOutputXMLCustomerInfoList="";
	WFXmlResponse objWorkListXmlResponse;
	WFXmlList objWorkList;
	Hashtable DataFormHT=new Hashtable();
	Hashtable ht =new  Hashtable();
	String BranchName ="";
	String sProcessName ="";
	
	String branchCode="";

	String sFirstName="";
	String sMiddleName="";
	String sLastName="";
	String sGeneralStat="";
	String sEliteCustomerNo="";
	//addded by stutee.mishra for email
	String sEmail="";
 
	WriteLog("Integration jsp: ProcessName RequestValue: "+request.getParameter("ProcessName"));
	String URLDecoderProcessName = URLDecoder.decode(request.getParameter("ProcessName"));
	WriteLog("Integration jsp: URLDecoderProcessName 1: "+URLDecoderProcessName);
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderProcessName, 1000, true) );
	WriteLog("Integration jsp: URLDecoderProcessName 1: "+input1);
	String DecoderProcessName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: ProcessName: "+DecoderProcessName);
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessInstanceId", request.getParameter("ProcessInstanceId"), 1000, true) );
	String ProcessInstanceId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: ProcessInstanceId comm block: "+ProcessInstanceId);
	
	WriteLog("Integration jsp: BranchCodeName RequestValue: "+request.getParameter("BranchCodeName"));
	String URLDecoderBranchCodeName = URLDecoder.decode(request.getParameter("BranchCodeName"));
	WriteLog("Integration jsp: URLDecoderProcessName 1: "+URLDecoderBranchCodeName);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BranchCodeName", URLDecoderBranchCodeName, 1000, true) );
	WriteLog("Integration jsp: URLDecoderBranchCodeName 1: "+input3);
	String DecoderBranchCodeName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: DecoderBranchCodeName: "+DecoderBranchCodeName);
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CrdtCN", request.getParameter("CrdtCN"), 1000, true) );
	String CrdtCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: CrdtCN comm block: "+CrdtCN);
	
	

	try{
	    WDCabinetInfo wDCabinetInfo = wDSession.getM_objCabinetInfo();
		WDUserInfo wDUserInfo = wDSession.getM_objUserInfo();
		sCabname = wDCabinetInfo.getM_strCabinetName();
		sSessionId    = wDUserInfo.getM_strSessionId();
		sJtsIp = wDCabinetInfo.getM_strServerIP();
		iJtsPort = Integer.parseInt(wDCabinetInfo.getM_strServerPort()+"");
		
		
	}catch(Exception ignore){
		bError=true;
		WriteLog(ignore.toString());
	}	
	if (bError){
		out.println("<script>");
		out.println("alert('User session has been expired. Please re-login.');");
		out.println("window.parent.close();"); 
		out.println("</script>");
	}
	else
	{
		String pName = DecoderProcessName;
		WriteLog("Inside CSR_CommonBlocks, pName: "+pName);
		if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))
		{
				String sInputXML ="<?xml version=\"1.0\"?>" + 				
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>rb_get_request_status_mapp</ProcName>" +						
						"<Params>'"+DecoderProcessName+"'</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabname+"</EngineName>" +
						"</APProcedure2_Input>";
				String sMappOutPutXML="";
				WriteLog("Lalit"+sInputXML);
				
				try
				{
					 sMappOutPutXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog("Inside CSR_CommonBlocks, sMappOutPutXML: "+sMappOutPutXML);
					if(sMappOutPutXML.equals("") || Integer.parseInt(sMappOutPutXML.substring(sMappOutPutXML.indexOf("<MainCode>")+10 , BranchName.indexOf("</MainCode>")))!=0)	{
						bError= true;
					}
				}catch(Exception exp){
					bError=true;
				}
				String sMapping = sMappOutPutXML.substring(sMappOutPutXML.indexOf("<Results>")+9,sMappOutPutXML.indexOf("</Results>"));

				WriteLog("Inside CSR_CommonBlocks, sMapping: "+sMapping);
				//out.println("this the data we got ---"+sMapping);

				//String sSQL = "";
				//need to comment below code for Offshore and uncomment for Onshore 
				Connection conn = null;
				Statement stmt =null;
				ResultSet result=null;
				try{			
					Context aContext = new InitialContext();
					DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
					conn = (Connection)(aDataSource.getConnection());
					WriteLog("got data source");
					stmt = conn.createStatement();
					String sSQL = "";
					
/*
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       CSR_CommonBlocks.jsp
	Purpose         :       A table specifying GENSTAT of each card which will specify the only cards respective to each process that can get introduced.
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/010/011				09/09/2008	 Saurabh Arora
*/
					if(!sMapping.equals("")){
						//Changed by Amandeep for CAPS Database change
						//sSQL = "Select ltrim(rtrim(FirstName)) ,ltrim(rtrim(MiddleName)) ,ltrim(rtrim(LastName)),substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3))),CRNNO,MOBILE,ASSESSEDINCOME,CARDTYPE,generalstat,elitecustomerno   from CAPSMAIN where  CREDITCARDNO='"+CrdtCN+"' and generalstat in ("+sMapping+")";
						sSQL = "Select trim(FirstName), trim(MiddleName), trim(LastName), substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy'))), CRNNO, MOBILE,ASSESSEDINCOME,CARDTYPE,generalstat,elitecustomerno,email from CAPSADMIN.CAPSMAIN where  CREDITCARDNO='"+CrdtCN+"' and generalstat in ("+sMapping+")";
						
						//WriteLog("Execute Query..."+sSQL);
					}else{
						//Changed by Amandeep for CAPS Database change
						//sSQL = "Select ltrim(rtrim(FirstName)) ,ltrim(rtrim(MiddleName)) ,ltrim(rtrim(LastName)),substring(convert(char,EXPIRYDATE,3),4,len(convert(char,EXPIRYDATE,3))),CRNNO,MOBILE,ASSESSEDINCOME,CARDTYPE,generalstat,elitecustomerno   from CAPSMAIN where  CREDITCARDNO='"+CrdtCN+"'";
						sSQL = "Select trim(FirstName), trim(MiddleName), trim(LastName), substr(to_char(EXPIRYDATE,'dd/mm/yy'),4,length(to_char(EXPIRYDATE,'dd/mm/yy'))), CRNNO, MOBILE,ASSESSEDINCOME,CARDTYPE,generalstat,elitecustomerno,email from CAPSADMIN.CAPSMAIN where  CREDITCARDNO='"+CrdtCN+"'";
					}
					WriteLog("Inside CSR_CommonBlocks,Execute Query..."+sSQL);
					result = stmt.executeQuery(sSQL);
					WriteLog("Inside CSR_CommonBlocks,result: "+result);
					
					if(result.next())
					{
					sFirstName = result.getString(1);
                    WriteLog("Inside CSR_CommonBlocks,sFirstName: "+sFirstName);					
					sMiddleName = result.getString(2);
					sLastName = result.getString(3);
					sCustomerName=sFirstName+" "+sMiddleName+" "+sLastName;
					sExpiryDate=result.getString(4);
					//sExpiryDate="Masked";
					sCardCRNNo=result.getString(5);
					sMobileNo=result.getString(6);
					sAccessedIncome=new Integer(result.getInt(7)).toString();
					sCardType=result.getString(8);
					sGeneralStat=result.getString(9);
					sEliteCustomerNo=result.getString(10);
					//added by stutee.mishra
					sEmail=result.getString(11);
					WriteLog("Inside CSR_CommonBlocks,sEmail: "+sEmail);
					}	
					else
					{
						out.println("<script>alert('Customer Not Found');</script>");						out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"CSR_blank.jsp\";</script>");		
					}
					
					if (pName.equals("Card Service Request - Balance Transfer")||pName.equals("Card Service Request - Credit Card Cheque")||pName.equals("Card Service Request - Cash Back Request"))
					{
					
						//out.println("<script>alert('"+sCardCRNNo+"');</script>");						
				
						
						if (sCardCRNNo.charAt(7)=='0'&&sCardCRNNo.charAt(8)=='0')
						{	
							
						}
						else
						{
							out.println("<script>alert('Supplementary Cards are not allowed for this request');</script>");				out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"CSR_blank.jsp\";</script>");	
						}						
					}
					if(result != null)
					{
						result.close();
						result=null;
						WriteLog("resultset Successfully closed......1"); 
					}
					if(stmt != null)
					{
						stmt.close();
						stmt=null;						
						WriteLog("Stmt Successfully closed.......1"); 
					}
					if(conn != null)
					{
						conn.close();
						conn=null;	
						WriteLog("Conn Successfully closed.....1"); 
					}
					
				}catch (java.sql.SQLException e)
				{
					WriteLog(e.toString());
					if(e.getClass().toString().equalsIgnoreCase("Class javax.naming.NameNotFoundException"))
					out.println("<script>alert(\"Data Source For CAPS System Not Found\")</script>");

					else if(e.toString().indexOf("Operation timed out: connect:could be due to invalid address")!=-1)
					out.println("<script>alert(\"Unable to connect to CAPS System\")</script>");

					else{
						out.println("<script>alert(\"Unable to connect to CAPS System\")</script>");
					}

					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"CSR_blank.jsp\";</script>");
				}
				catch(Exception e)
				{
					WriteLog(e.toString());
					out.println("<script>alert(\"Some error occured Please Contact Administrator\")</script>");
					out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"CSR_blank.jsp\";</script>");
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
				}

				//Below code used only for Offshore Testing******************************
				/*WriteLog("sMapping :"+sMapping);
				if(!sMapping.equals(""))
				{
					sFirstName = "Manish";					
					sMiddleName = "Kumar";
					sLastName = "Shukla";
					sCustomerName=sFirstName+" "+sMiddleName+" "+sLastName;
					//sExpiryDate="10/10/1900 12:00:00 AM";
					sExpiryDate="10/22";
					sCardCRNNo="664356400";
					sMobileNo="35345345";
					sAccessedIncome="656446";
					sCardType="V";
					sGeneralStat="NORM";
					sEliteCustomerNo="050551249";
					WriteLog("pName :"+pName);
					if (pName.equals("Card Service Request - Balance Transfer")||pName.equals("Card Service Request - Credit Card Cheque")||pName.equals("Card Service Request - Cash Back Request")|| pName.equals("Card Service Request - Reversals Request"))
					{				
						WriteLog("sCardCRNNo charAt 7:"+sCardCRNNo.charAt(7));
						WriteLog("sCardCRNNo charAt 8:"+sCardCRNNo.charAt(8));
						if (sCardCRNNo.charAt(7)=='0'&&sCardCRNNo.charAt(8)=='0')
						{	
							WriteLog("inside if :");
						}
						else
						{
							WriteLog("inside else :");
							out.println("<script>alert('Supplementary Cards are not allowed for this request');</script>");				out.println("<script>window.parent.frames['frameProcess'].document.location.href=\"CSR_blank.jsp\"; window.parent.frames['frameClose'].document.location.href=\"CSR_blank.jsp\";</script>");	
						}						
					}
					WriteLog("resultset Successfully closed");
				}*/
				//************************************************************************
		}
		else
		{
			WriteLog("Piyush...");
			String sInputXML1="<?xml version=\"1.0\"?><WMFetchProcessInstanceAttributes_Input><Option>WMFetchProcessInstanceAttributes</Option><EngineName>"+sCabname+"</EngineName><SessionId>"+sSessionId+"</SessionId><ProcessInstanceId>"+ProcessInstanceId+"</ProcessInstanceId></WMFetchProcessInstanceAttributes_Input>";
			WriteLog("MAnish1234567788909---2222-"+sInputXML1);
			String strOutputXMLCat1 = WFCallBroker.execute(sInputXML1,sJtsIp,iJtsPort,1);	
			WriteLog("strOutputXMLCat1---345345345-"+strOutputXMLCat1);
			objWorkListXmlResponse = new WFXmlResponse("");
			objWorkListXmlResponse.setXmlString(strOutputXMLCat1);
			objWorkList = objWorkListXmlResponse.createList("Attributes","Attribute"); 			  
			for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
			{  
				  DataFormHT.put(objWorkList.getVal("Name").toString(),objWorkList.getVal("Value").toString());
				  WriteLog(objWorkList.getVal("Name").toString()+"--"+objWorkList.getVal("Value").toString());						
			}
			
			sCustomerName=DataFormHT.get("CCI_CName").toString();
			
			sExpiryDate=DataFormHT.get("CCI_ExpD").toString();
			
			sCardCRNNo=DataFormHT.get("CCI_CCRNNo").toString();
			
			sSourceCode=DataFormHT.get("CCI_SC").toString();
			
			sExtNo=DataFormHT.get("CCI_ExtNo").toString();
			
			sReqType=DataFormHT.get("CCI_REQUESTTYPE").toString();
			
			sMobileNo=DataFormHT.get("CCI_MONO").toString();
			
			sAccessedIncome=DataFormHT.get("CCI_AccInc").toString();
			
			sCardType=DataFormHT.get("CCI_CT").toString();

			sGeneralStat=DataFormHT.get("CCI_CAPS_GENSTAT").toString();

			sEliteCustomerNo=DataFormHT.get("CCI_ELITECUSTNO").toString();

			if(DataFormHT.get("USER_BRANCH")!=null&&!DataFormHT.get("USER_BRANCH").equals(""))
			{
				//Get Branch Name corresponding to branch code
				String sInputXML ="<?xml version=\"1.0\"?>" + 				
						"<APProcedure2_Input>" +
						"<Option>APProcedure2</Option>" +
						"<ProcName>RB_GetBranchName</ProcName>" +						
						"<Params>'"+DataFormHT.get("USER_BRANCH")+"'</Params>" +  
						"<NoOfCols>1</NoOfCols>" +
						"<SessionID>"+sSessionId+"</SessionID>" +
						"<EngineName>"+sCabname+"</EngineName>" +
						"</APProcedure2_Input>";

				
				try
				{
					BranchName= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					WriteLog(BranchName);
					if(BranchName.equals("") || Integer.parseInt(BranchName.substring(BranchName.indexOf("<MainCode>")+10 , BranchName.indexOf("</MainCode>")))!=0)	{
						bError= true;
					}
				}catch(Exception exp){
					bError=true;
				}
				BranchName = BranchName.substring(BranchName.indexOf("<Results>")+9,BranchName.indexOf("</Results>"));
			}
			
			
		}	
		
	}

	
		
	Date dt=new Date();
	SimpleDateFormat sdt=new SimpleDateFormat("dd/MM/yyyy");
	String sDate=sdt.format(dt);
	int dd = dt.getDate();
	int mm= dt.getMonth()+1;
	int yy = dt.getYear()+1900;
	int hour= dt.getHours();
	int min= dt.getMinutes();
	String sysDate_CCB = mm+"/"+dd+"/"+yy+" "+hour+":"+min;
	WriteLog("Inside CSR_CommonBlocks.jsp, sysDate_CCB: " + sysDate_CCB);

	//Processing for ProcessName
	String sDisplayText="";
	if(ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase("")){ 
	  sProcessName=DataFormHT.get("wi_name").toString().substring(DataFormHT.get("wi_name").toString().length()-3,DataFormHT.get("wi_name").toString().length());
	  if(sProcessName.equalsIgnoreCase("-BT"))
		  sDisplayText="Balance Transfer Request";
  	  if(sProcessName.equalsIgnoreCase("CBR"))
		  sDisplayText="Cash Back Request";
  	  if(sProcessName.equalsIgnoreCase("CCB"))
		  sDisplayText="Credit Card Blocking Request";
  	  if(sProcessName.equalsIgnoreCase("CCC"))
		  sDisplayText="Credit Card Cheque Request";
  	  if(sProcessName.equalsIgnoreCase("-MR"))
		  sDisplayText="Miscellaneous Requests";
  	  if(sProcessName.equalsIgnoreCase("-RR"))
		  sDisplayText="Reversals Request";
  	  if(sProcessName.equalsIgnoreCase("OCC"))
		  sDisplayText="Other Credit Card Requests--"+DataFormHT.get("request_type").toString();
	  
	  WriteLog("Inside CSR_CommonBlocks.jsp, sDisplayText: " + sDisplayText);
	}

//----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//File Name		             : Branch_Approver.jsp
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 01-March-2008
//Description                : validation details in all the process .
//------------------------------------------------------------------------------------------------------------------------------------>

WriteLog("Inside CSR_CommonBlocks.jsp, USR_0_CSR_MISC_REQUESTTYPE code starts here.");
ArrayList aprequesttype = new ArrayList();
	try
	{
		String lstrQuery = "select Request_type from USR_0_CSR_MISC_REQUESTTYPE WITH(NOLOCK) where isActive=:ONE";
		String params ="ONE==Y";
		String sInputXML ="<?xml version=\"1.0\"?>\n"
					+ "<APSelectWithNamedParam_Input>\n"
					+ "<Option>APSelectWithNamedParam</Option>\n" 
					+ "<Query>"+lstrQuery+"</Query>\n" 
					+ "<Params>"+params+"</Params>\n" 
					+ "<EngineName>"+sCabname+"</EngineName>\n"
					+ "<SessionId>"+sSessionId+"</SessionId>\n"
					+ "</APSelectWithNamedParam_Input>\n";
		WriteLog("Inside CSR_CommonBlocks.jsp, REQUESTTYPE, sInputXML: " + sInputXML);
		String sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
		WriteLog("Inside CSR_CommonBlocks.jsp, REQUESTTYPE, sOutputXML: " + sOutputXML);
		if(sOutputXML.equals("") ||	Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10, sOutputXML.indexOf("</MainCode>")))!=0)
		{
			WriteLog("<Exception>" + Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10, sOutputXML.indexOf("</MainCode>"))) + "</Exception>");
		}
		else if(Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10, sOutputXML.indexOf("</MainCode>")))==0) 
		{		
			WFXmlResponse xmlResponse1 = new WFXmlResponse(sOutputXML);
			WFXmlList RecordList1;
			for (RecordList1 =  xmlResponse1.createList("Records", "Record");RecordList1.hasMoreElements();RecordList1.skip())
			{
				String deptName=RecordList1.getVal("Request_type");
				WriteLog(""+deptName);
				aprequesttype.add(deptName);			
			}
			
			 
		}
		else
		{
			WriteLog("<Exception>Exception in fetching request type else condition</Exception>");
		}
	}
	catch(Exception e)
	{
		WriteLog("Exception in fetching request type");
	}
%>

<script>
var sDate='<%=sDate%>';
</script>

<input type="text" name="Header" readOnly size="24" style='display:none' value='Request Type:&nbsp;&nbsp;<%=sDisplayText%>'>

<input type="text" name="Header" readOnly size="24" style='display:none' value='Credit Card Information          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;                 RegistrationNo:<%=DataFormHT.get("wi_name")%>'>

<table border="1" cellspacing="1" cellpadding="1" width=100% >

	
  <%if(ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase("")){ 
	  sProcessName=DataFormHT.get("wi_name").toString().substring(DataFormHT.get("wi_name").toString().length()-3,DataFormHT.get("wi_name").toString().length());%>
		 <tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=4 align=center class="EWLabelRB2"><b><%=sDisplayText%> </b></td>
				
			</tr>
		  <tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=2 align=left class="EWLabelRB2"><b>Credit Card Information from CAPS &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Branch:&nbsp;&nbsp;&nbsp;&nbsp;<%=BranchName==null?"":BranchName%></b></td>
				<td colspan=1 align=left class="EWLabelRB2"><b><%=DataFormHT.get("BU_UserName").toString()%>      <%=sDate%></b></td>
				<td colspan=1 align=left class="EWLabelRB2"><b><%=DataFormHT.get("wi_name")%></b></td>
			</tr>
		 <TR><td nowrap width="155" height="16" class="EWLabelRB" colspan=1 id="CCI_CrdtCN">Credit Card No.</td>
			<td nowrap  width="150" colspan=1><input type="text" name="CCI_CrdtCN" value='<%=DataFormHT.get("CCI_CrdtCN")%>' size="8" maxlength=19 style='width:150px;' disabled ></td>
		</tr> 
	<%}else{%>
			  <tr class="EWHeader" width=100% class="EWLabelRB2">
				<td colspan=4 align=left class="EWLabelRB2"><b>Credit Card Information from CAPS</b></td>
			</tr>
	<%}%>


	<TR>
        <td nowrap width="155" height="16" class="EWLabelRB" id="CCI_CName">Customer Name</td>
        <td nowrap  width="150"><input type="text" name="CCI_CName" value='<%=sCustomerName%>' disabled size="8" maxlength=90 style='width:150px;' ></td>
		  <td nowrap width="190" height="16" class="EWLabelRB" id="CCI_ExpD">Expiry Date</td>
<!-- 
 	Product/Project :       Rak Bank
	Module          :       
	File            :       CSR_CommonBlocks.jsp
	Purpose         :       As a security measure, the Expiry date of the card appearing on SRM Requests on Credit Cards needs to be removed/masked  
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/096					1/6/2009	 Saurabh Arora
 -->
 
 	<td nowrap width="190">
		<input type="hidden" name="CCI_ExpD" value='<%=sExpiryDate%>'  disabled size="8" maxlength=5 style='width:150px;'>
		<input type="text" name="CCI_ExpDHid" value='Masked'  disabled size="8" maxlength=6 style='width:150px;'>
		<input type="hidden" name="userEmailID" value='<%=sEmail%>'  disabled size="50" maxlength=50 style='width:150px;'>
								</td>
	</tr>
	
	<TR>
	    <td nowrap width="100" height="16" class="EWLabelRB" id="CCI_CT">Card Type</td>
        <td nowrap width="180"><input type="text" name="CCI_CT" value='<%=sCardType%>' disabled size="8" maxlength=30 style='width:150px;' ></td>        
		  <td nowrap width="170" height="16" class="EWLabelRB" id="CCI_MONO">Mobile No.</td>
        <td nowrap width="190"><input type="text" name="CCI_MONO" value='<%=sMobileNo%>' disabled size="8" maxlength=12 style='width:150px;'></td>
	</tr>

	<TR>
	    <td nowrap width="100" height="16" class="EWLabelRB" id="CCI_CAPS_GENSTAT">General Status</td>
        <td nowrap width="180"><input type="text" name="CCI_CAPS_GENSTAT" value='<%=sGeneralStat%>' disabled size="8" maxlength=30 style='width:150px;' ></td>        
		  <td nowrap width="170" height="16" class="EWLabelRB" id="CCI_ELITECUSTNO">Elite Customer No</td>
        <td nowrap width="190"><input type="text" name="CCI_ELITECUSTNO" value='<%=sEliteCustomerNo%>' disabled size="8" maxlength=12 style='width:150px;'></td>
	</tr>

	<TR>
	    
        <td nowrap width="155" height="16" class="EWLabelRB" id="CCI_AccInc">Accessed Income</td>
        <td nowrap  width="150"><input type="text" name="CCI_AccInc" value='<%=sAccessedIncome%>' disabled size="8" maxlength=8 style='width:150px;' ></td>
		<td nowrap width="155" height="16" class="EWLabelRB" id="CCI_ExtNo">Ext No.</td> 
        <td nowrap  width="190"><input type="text" name="CCI_ExtNo" value='<%=sExtNo%>' size="8" maxlength=4 style='width:150px;' onkeyup=validateKeys(this,'CSR_Common') onblur=validateKeys_OnBlur(this,'CSR_Common')  ></td>
		 
	</tr>	

	 <%if(((ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))&&(DecoderProcessName.equalsIgnoreCase("Card Service Request - Balance Transfer")||DecoderProcessName.equalsIgnoreCase("Card Service Request - Credit Card Cheque")))||((ProcessInstanceId!=null && !ProcessInstanceId.equalsIgnoreCase(""))&&(sProcessName.equalsIgnoreCase("CCC")||sProcessName.equalsIgnoreCase("-BT")))){%>

	 <TR>
        <td nowrap width="155" height="16" class="EWLabelRB" id="CCI_CCRNNo">Card CRN No</td>
        <td nowrap  width="150"><input type="text" name="CCI_CCRNNo" Disabled="true" value='<%=sCardCRNNo%>' size="8" maxlength=9 style='width:150px;' onkeyup=validateKeys(this,'CSR_Common') onblur=validateKeys_OnBlur(this,'CSR_Common') ></td>
		
        <td nowrap width="100" height="16" class="EWLabelRB" id="CCI_SC">Source Code</td>
        <td nowrap width="190"><input type="text" name="CCI_SC" value='<%=sSourceCode%>' size="8" maxlength=7 style='width:150px;' onkeyup=validateKeys(this,'CSR_Common') onblur=validateKeys_OnBlur(this,'CSR_Common')  ></td>
		
	</tr>
	<%} else {
		%>
		<TR>
        <td nowrap width="155" height="16" class="EWLabelRB" id="CCI_CCRNNo">Card CRN No</td>
        <td nowrap  width="150"><input type="text" name="CCI_CCRNNo"  disabled="true" value='<%=sCardCRNNo%>' size="8" maxlength=9 style='width:150px;' onkeyup=validateKeys(this,'CSR_Common') onblur=validateKeys_OnBlur(this,'CSR_Common') ></td>
		
          <!-- <td nowrap width="190">&nbsp;</td> -->
		<% 
		if((DecoderProcessName.equalsIgnoreCase("Card Service Request - Miscellaneous Requests"))){
		%>
		<td nowrap width="155" height="16" class="EWLabelRB" id="CCI_REQUESTTYPE">Request Type</td>
        <td nowrap  width="220">
		<select name="CCI_REQUESTTYPE" style='width:290px;'>
						<option selected value="--Select--">--Select--</option>
					<% 	
					  for(int i = 0; i<aprequesttype.size(); i++)
    {
      
					%>
						<option value='<%=aprequesttype.get(i).toString()%>'><%=aprequesttype.get(i).toString()%></option>
						<% 	}
						%>
						 
					</select>
		<!--<input type="text" name="CCI_REQUESTTYPE" value='<%=sReqType%>' size="8" maxlength=4 style='width:150px;' onkeyup=validateKeys(this,'CSR_Common') onblur=validateKeys_OnBlur(this,'CSR_Common')  > -->
		</td>
		<%}  
		else
		{
		%>
		<td nowrap width="100" height="16" class="EWLabelRB" id="CCI_SC" colspan=2>&nbsp;</td>
		<%} %>
	</tr>
	<%}%>
	
</table>


<table border="1" cellspacing="1" cellpadding="1" width=100% >
		
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Verification Details'>
		<td colspan=3 align=left class="EWLabelRB2"><b>Verification Details</b></td>
	</tr>
	

	<TR>
        <td nowrap  height="16" class="EWLabelRB" id="C_VD_TINCheck" colspan=3><input type="checkbox" name="VD_TINCheck" style='width:25px;' >&nbsp;TIN/PIN</td>
	</tr>
	<table border="1" cellspacing="1" cellpadding="1" width=100% >
	<TR>
        <td nowrap  height="16" class="EWLabelRB" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" onclick=EnableDisablechkbox()  name="VD_MoMaidN"  style='width:25px;' >&nbsp;Any 4 of the following RANDOM Questions</td>
	</TR>

       <!--  <td nowrap colspan=2 width=79% > -->
		<TR>
			<!-- <table border="1" cellspacing="1" cellpadding="1" width=100% > -->
				<tr>
				    <td class="EWLabelRB" nowrap width=53% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;' >&nbsp;&nbsp;P.O. Box</td>
					<td class="EWLabelRB" nowrap width=47% id="C_VD_Oth"><input type="checkbox" name="VD_Oth" disabled style='width:25px;' >&nbsp;&nbsp;Mother's Maiden name</td>
				</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=33% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;' >&nbsp;&nbsp;Most Recent Transaction (Date, Amount in Transaction Currency)</td>
					<td class="EWLabelRB" nowrap width=67% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;' >&nbsp;&nbsp;Staff ID No./Military ID No.</td>
				</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=33% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;' >&nbsp;&nbsp;Expiry date Of Your Card</td>
					<td class="EWLabelRB" nowrap width=67% id="C_VD_PassNo"><input type="checkbox" name="VD_PassNo" disabled style='width:25px;' >&nbsp;&nbsp;Last Payment Amt</td>
            	</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=33% id="C_VD_NOSC"><input type="checkbox" name="VD_NOSC" disabled style='width:25px;' >&nbsp;&nbsp;Name of Supplementary Card Holder."If Any"</td>
					<td class="EWLabelRB" nowrap width=67% id="C_VD_SD"><input type="checkbox" name="VD_SD" disabled style='width:25px;' >&nbsp;&nbsp;Statement Date</td>
            	</tr>
				<tr>
					<td class="EWLabelRB" nowrap width=33% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;' >&nbsp;&nbsp;Residence, Mobile, Work Tel No. registered with us</td>
					<td class="EWLabelRB" nowrap width=33% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;' >&nbsp;&nbsp;Date Of Birth</td>
            	</tr>

				</TR>
			</table>
			
		<!-- </td> -->
	<!-- </tr>	 -->
	</table>
	 <%if((ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase(""))&&DecoderProcessName.equalsIgnoreCase("Card Service Request - Other Credit Card Requests")){%>
	<table border="1" cellspacing="1" cellpadding="1" width=100% >		
	<tr class="EWHeader" width=100% class="EWLabelRB2">
		<td colspan=2 align=left class="EWLabelRB2"><b>Other Process Name</b></td>
	</tr>
	<%
		 String sInputXML="<?xml version=\"1.0\"?>\n" +
		"<WMGetQueueList_Input>\n" +
		"<Option>WMGetQueueList</Option>\n" +
		"<EngineName>"+sCabname+"</EngineName>\n" +
		"<SessionId>" + sSessionId + "</SessionId>\n" +
		"<Filter>\n" +
		"<QueueAssociation>2</QueueAssociation>\n" +
		"<Filter>"+
	//    "<ProcessDefinitionId>01</ProcessDefinitionId>" +
	//    "<ActivityID>"+sActivityID+"</ActivityID>" +
		"</Filter>\n" +
		"<BatchInfo>\n" +
	//    "<NoOFRecordsToFetch>1</NoOFRecordsToFetch>\n" +
		"</BatchInfo>\n" +
		"<DataFlag>N</DataFlag>\n" +
		"</WMGetQueueList_Input>";

		String sOutputXMLQueueList="";
		try{
			sOutputXMLQueueList = WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog(sOutputXMLQueueList);
			
			if(sOutputXMLQueueList.equals("") || Integer.parseInt(sOutputXMLQueueList.substring(sOutputXMLQueueList.indexOf("<MainCode>")+10 , sOutputXMLQueueList.indexOf("</MainCode>")))!=0){
				bError= true;
			}
		}catch(Exception exp){
			WriteLog(exp.toString());
		}
		WriteLog(sOutputXMLQueueList);
		if(sOutputXMLQueueList.indexOf("<MainCode>18</MainCode>") != -1){
			WriteLog("No Record Found.");
		}
		else
		 {
			//Hashtable ht =new  Hashtable();
			try{
				WFXmlResponse xmlResponse = new WFXmlResponse(sOutputXMLQueueList);
				WFXmlList RecordList;
				String sType="";
				for (RecordList =  xmlResponse.createList("QueueList", "QueueInfo");RecordList.hasMoreElements();){			
						if(RecordList.getVal("Name").toUpperCase().indexOf("CSR_OCC")!=-1&&RecordList.getVal("Name").toUpperCase().indexOf("WORK")!=-1&&RecordList.getVal("Name").toUpperCase().indexOf("WORK")!=8){
							WriteLog("manishzzzzz-----"+RecordList.getVal("Name").toUpperCase().substring(8,RecordList.getVal("Name").toUpperCase().indexOf("WORK")));
							String sSubProcessName=RecordList.getVal("Name").toUpperCase().substring(8,RecordList.getVal("Name").toUpperCase().indexOf("WORK"));
							ht.put(sSubProcessName,"Y");
						}
					RecordList.skip();
				}
				request.setAttribute("subProcessNames",ht);
			}catch(Exception ex){
					WriteLog("error--"+ex.toString());
			}
		 }
	 %>
	<tr  width=100% class="EWLabelRB">
		 <td nowrap  class="EWLabelRB">Process Name</td>
        <td nowrap >
			<select name="request_type" onchange="showSubProcess(this);">			
				<option value="" selected>--Select--</option>
				<% if(ht.get("RIP")!=null&&ht.get("RIP").toString().equalsIgnoreCase("Y")){%>
				<option value="Re-Issue of PIN">Re-Issue of PIN</option>
				<%} if(ht.get("CR")!=null&&ht.get("CR").toString().equalsIgnoreCase("Y")){%>
				<option value="Card Replacement">Card Replacement</option>
				<%} if(ht.get("CLI")!=null&&ht.get("CLI").toString().equalsIgnoreCase("Y")){%>
				<option value="Credit Limit Increase">Credit Limit Increase</option>
				<%} if(ht.get("ECR")!=null&&ht.get("ECR").toString().equalsIgnoreCase("Y")){%>
				<option value="Early Card Renewal">Early Card Renewal</option>
				<%} if(ht.get("CSI")!=null&&ht.get("CSI").toString().equalsIgnoreCase("Y")){%>
				<option value="Change in Standing Instructions">Change in Standing Instructions</option>
				<%} /*if(ht.get("TD")!=null&&ht.get("TD").toString().equalsIgnoreCase("Y")){%>
				<option value="Transaction Dispute">Transaction Dispute</option>
				<%}*/ if(ht.get("CU")!=null&&ht.get("CU").toString().equalsIgnoreCase("Y")){%>
				<option value="Card Upgrade">Card Upgrade</option>
				<%} if(ht.get("CDR")!=null&&ht.get("CDR").toString().equalsIgnoreCase("Y")){%>
				<option value="Card Delivery Request">Card Delivery Request</option>
				<%}/* if(ht.get("CS")!=null&&ht.get("CS").toString().equalsIgnoreCase("Y")){%>
				<option value="Credit Shield">Credit Shield</option>
				<%}*/ if(ht.get("SSC")!=null&&ht.get("SSC").toString().equalsIgnoreCase("Y")){%>
				<option value="Setup Suppl. Card Limit">Setup Suppl. Card Limit</option>							
				<%}%>
			</select>
		</td>
	</tr>
	</table>
	
	<jsp:include page="../CSRProcessSpecific/CSR_OCC_Common.jsp" />
	<%}%>
	
	<%
		WriteLog("Branch_Code 3--"+DecoderBranchCodeName);
		String Branch_Code=DecoderBranchCodeName;		
		
		if(Branch_Code.indexOf("+") != -1)
			Branch_Code=Branch_Code.substring(0,Branch_Code.indexOf("+"));
		
		WriteLog("Branch Code substring --"+Branch_Code);
	%>
	
	<input type=text readOnly name="initiateDecision" id="initiateDecision" value='' style='display:none'>
	<input type=text readOnly name="subProcessShortName" id="subProcessShortName" value='' style='display:none'>
	<input type=text readOnly name="sDate" id="sDate" value='<%=sDate%>' style='display:none'>
	<input type=text readOnly name="sysDate_CCB" id="sysDate_CCB" value='<%=sysDate_CCB%>' style='display:none'>
	<%if(ProcessInstanceId==null || ProcessInstanceId.equalsIgnoreCase("")){%>
	<input type=text readOnly name="USER_BRANCH" id="USER_BRANCH" value='<%=Branch_Code%>' style='display:none'>
	<%}%>
