<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ include file="../TF_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/TF/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<HTML>
<HEAD>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
</HEAD>
</HTML>
<%

			String URLDecoderreqType=URLDecoder.decode(request.getParameter("reqType"));
			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", URLDecoderreqType, 1000, true) );
			String URLDecoderreqType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
		WriteLog("inside dropdownlaod2.jsp");
		String reqType=URLDecoderreqType_Esapi.replace("&amp;","&");
		WriteLog("reqType"+reqType);
		
		String WSNAME="";
		String WINAME="";
		String Checklist_Name="";
		String CIFID="";
		String ApplicationFormCode="";	
		String returnValues = "";
		String query = "";
		String sCabName=customSession.getEngineName();	
		String sSessionId = customSession.getDMSSessionId();
		
		String sJtsIp = customSession.getJtsIp();
		int iJtsPort = customSession.getJtsPort();
		WFCustomXmlResponse xmlParserData=null;
		WFCustomXmlList objWorkList=null;
		String sInputXML = "";
		String sOutputXML = "";
		String subXML="";
		String params="";
		
		if (reqType.equals("selectDecision"))
		{
			
			String URLDecoderWSNAME2=URLDecoder.decode(request.getParameter("WSNAME"));
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWSNAME2, 1000, true) );
			String URLDecoderWSNAME_Esapi2 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			WSNAME=URLDecoderWSNAME_Esapi2.replace("&amp;","&");
			if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
			WriteLog("WSNAME"+WSNAME);
		
			query = "SELECT Decision FROM USR_0_TF_DECISION_MASTER with(nolock) WHERE WORKSTEP_NAME=:WSNAME order by Decision";
			params = "WSNAME=="+WSNAME;
		}
		else if (reqType.equals("Load_ModeOfDelivery"))
		{
			
			String URLDecoderServiceRequestCode=URLDecoder.decode(request.getParameter("ServiceRequestCode"));
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderServiceRequestCode, 1000, true) );
			String URLDecoderServiceRequestCode_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			ApplicationFormCode=URLDecoderServiceRequestCode_Esapi.replace("&amp;","&");
			if (ApplicationFormCode != null) {ApplicationFormCode=ApplicationFormCode.replace("'","''");}
			//WriteLog("Product_Type"+Product_Type);
		
			query = "SELECT Mode_Of_Delivery FROM  USR_0_TF_SUBCATEGORY with(nolock) where Application_FormCode=:Application_FormCode";
			//params = "ONE==1";
			params = "Application_FormCode=="+ApplicationFormCode;
		}
		else if (reqType.equals("loadchecklist"))
		{
			
			String URLDecoderWINAME4=URLDecoder.decode(request.getParameter("WINAME"));
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME4, 1000, true) );
			String URLDecoderWINAME_Esapi4 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String URLDecoderChecklist_Name=URLDecoder.decode(request.getParameter("Checklist_Name"));
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderChecklist_Name, 1000, true) );
			String URLDecoderChecklist_Name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			String URLDecoderServiceRequestCode6=URLDecoder.decode(request.getParameter("ServiceRequestCode"));
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderServiceRequestCode6, 1000, true) );
			String URLDecoderServiceRequestCode_Esapi6 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			WINAME=URLDecoderWINAME_Esapi4.replace("&amp;","&");
			if (WINAME != null) {WINAME=WINAME.replace("'","");}
			Checklist_Name=URLDecoderChecklist_Name_Esapi.replace("&amp;","&");
			if (Checklist_Name != null) {Checklist_Name=Checklist_Name.replace("'","");}
			//WriteLog("WINAME"+WINAME);
			ApplicationFormCode=URLDecoderServiceRequestCode_Esapi6.replace("&amp;","&");
			if (ApplicationFormCode != null) {ApplicationFormCode=ApplicationFormCode.replace("'","");}
			
			query = "SELECT a.Checklist_Description,(select Option_checklist from USR_0_TF_SaveChecklistTable s with(nolock) where s.Checklist_Description=a.Checklist_Description and s.WIName =:WINAME and s.Workstep=a.Workstep) as Option_checklist,(select Remarks from USR_0_TF_SaveChecklistTable s with(nolock) where s.Checklist_Description=a.Checklist_Description and s.WIName =:WINAME and s.Workstep=a.Workstep) as Remarks,a.Workstep FROM USR_0_TF_ChecklistTable a with (nolock) WHERE a.Checklist_Name=:Checklist_Name and (a.SRsIncluded = 'All' or CHARINDEX('"+ApplicationFormCode+"',a.SRsIncluded) > 0) and (a.SRsExcluded is null or a.SRsExcluded ='' or CHARINDEX('"+ApplicationFormCode+"',a.SRsExcluded) = 0)";
			params = "WINAME=="+WINAME+"~~Checklist_Name=="+Checklist_Name;
			
		}
		else if (reqType.equals("loadcommngrid"))
		{
			
			String URLDecoderWINAME7=URLDecoder.decode(request.getParameter("WINAME"));
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME7, 1000, true) );
			String URLDecoderWINAME_Esapi7 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			
			WINAME=URLDecoderWINAME_Esapi7.replace("&amp;","&");
			if (WINAME != null) {WINAME=WINAME.replace("'","''");}
			//WriteLog("WINAME"+WINAME);
			
			query = "SELECT MODE_OF_COMMUNICATION,COMMUNICATION_DATE,COMMUNICATION_TIME,DESCRIPTION_COMM,CURRENT_DATE_COMM FROM USR_0_TF_COMMUNICATION_DTLS_GRID with(nolock) where WINAME=:WINAME";
			params = "WINAME=="+WINAME;
			
		}
		else if (reqType.equals("loadlodgementdate"))
		{
			
			String URLDecoderWINAME8=URLDecoder.decode(request.getParameter("WINAME"));
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME8, 1000, true) );
			String URLDecoderWINAME_Esapi8 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			
			
			WINAME=URLDecoderWINAME_Esapi8.replace("&amp;","&");
			if (WINAME != null) {WINAME=WINAME.replace("'","''");}
			//WriteLog("WINAME"+WINAME);
			
			query = "SELECT IntroductionDateTime FROM QUEUEVIEW WHERE processname='tf' AND processinstanceid=:WINAME";
			params = "WINAME=="+WINAME;			
		} 
		else if (reqType.equals("loadDocumentGrid"))
		{
			
			String URLDecoderWINAME9=URLDecoder.decode(request.getParameter("WINAME"));
			String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME9, 1000, true) );
			String URLDecoderWINAME_Esapi9 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
			
			WINAME=URLDecoderWINAME_Esapi9.replace("&amp;","&");
			if (WINAME != null) {WINAME=WINAME.replace("'","''");}
			//WriteLog("WINAME"+WINAME);
			
			query = "SELECT Case_Documents,No_Of_Copies,No_Of_Originals FROM USR_0_TF_SaveDocGridTable with(nolock) where WIName=:WINAME order by Case_Documents";
			params = "WINAME=="+WINAME;			
		} 
		else if (reqType.equals("loadDocumentGridOnCIFSearch"))
		{
			
			String URLDecoderServiceRequestCode10=URLDecoder.decode(request.getParameter("ServiceRequestCode"));
			String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderServiceRequestCode10, 1000, true) );
			String URLDecoderServiceRequestCode_Esapi10 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
			
			ApplicationFormCode=URLDecoderServiceRequestCode_Esapi10.replace("&amp;","&");
			if (ApplicationFormCode != null) {ApplicationFormCode=ApplicationFormCode.replace("'","''");}
			//WriteLog("Product_Type"+Product_Type);
			
			query = "SELECT DocumentGrid FROM  USR_0_TF_SUBCATEGORY with(nolock) where Application_FormCode=:Application_FormCode";
			params = "Application_FormCode=="+ApplicationFormCode;		
		} 
		else if (reqType.equals("loadChecklistCombo"))
		{
			
			String URLDecoderServiceRequestCode17=URLDecoder.decode(request.getParameter("ServiceRequestCode"));
			String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderServiceRequestCode17, 1000, true) );
			String URLDecoderServiceRequestCode_Esapi17 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
			
			
			ApplicationFormCode=URLDecoderServiceRequestCode_Esapi17.replace("&amp;","&");
			if (ApplicationFormCode != null) {ApplicationFormCode=ApplicationFormCode.replace("'","''");}
			//WriteLog("Product_Type"+Product_Type);
			
			query = "SELECT ChecklistCombo FROM USR_0_TF_SUBCATEGORY with(nolock) where Application_FormCode=:Application_FormCode";
			params = "Application_FormCode=="+ApplicationFormCode;	
			
		}
		else if (reqType.equals("loadEventGrid"))
		{
			
			String URLDecoderCIFID=URLDecoder.decode(request.getParameter("CIFID"));
			String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderCIFID, 1000, true) );
			String URLDecoderCIFID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
			
			CIFID=URLDecoderCIFID_Esapi.replace("&amp;","&");
			if (CIFID != null) {CIFID=CIFID.replace("'","''");}
			//WriteLog("CIFID"+CIFID);
		
			query = "select CIF_ID,IntoducedAt,Product_Category,Product_Type,IntoducedBy,WI_NAME from RB_TF_EXTTABLE with(nolock) where CIF_ID=:CIFID";
			//params = "CIFID=="+CIFID;		
			WriteLog("query="+query);
		}
		else if (reqType.equals("loadInvoiceGrid"))
		{
			
			String URLDecoderWINAME12=URLDecoder.decode(request.getParameter("WINAME"));
			String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWINAME12, 1000, true) );
			String URLDecoderWINAME_Esapi12 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
			
			WINAME=URLDecoderWINAME_Esapi12.replace("&amp;","&");
			if (WINAME != null) {WINAME=WINAME.replace("'","''");}
			//WriteLog("WINAME"+WINAME);
			
			query = "SELECT INVOICE_ID,INVOICE_NUMBER FROM USR_0_TF_INVOICE_DTLS_GRID with (nolock) WHERE WINAME=:WINAME";
			params = "WINAME=="+WINAME;			
			WriteLog("query="+query);
		}
		else if (reqType.equals("getMailIdOfRORM"))
		{
			
			String URLDecoderUserName13=URLDecoder.decode(request.getParameter("UserName"));
			String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderUserName13, 1000, true) );
			String URLDecoderUserName_Esapi13 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
			
			String UserName=URLDecoderUserName_Esapi13.replace("&amp;","&");
			if (UserName != null) {UserName=UserName.replace("'","''");}
			//WriteLog("WINAME"+WINAME);
			
			query = "SELECT MailId from PDBUSER with (nolock) WHERE UserName=:UserName and MailId is not null";
			params = "UserName=="+UserName;			
			//WriteLog("query="+query);
		}
	
		else if (reqType.equals("GetQueue"))
		{
			
			String URLDecoderDecision14=URLDecoder.decode(request.getParameter("Decision"));
			String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderDecision14, 1000, true) );
			String URLDecoderDecision_Esapi14 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
			
			String DECISION=URLDecoderDecision_Esapi14.replace("&amp;","&");
			if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
			if (DECISION != null) {DECISION=DECISION.replace("'","''");}
		
			query = "SELECT WORKSTEPS FROM USR_0_TF_CREDIT_BUSINESS_QUEUE WHERE DECISION =:DECISION";
			params = "DECISION=="+DECISION;			
			//WriteLog("getqueuequery="+query);
			
		}
		else if (reqType.equals("GetUsers"))
		{
			
			String URLDecoderDecision15=URLDecoder.decode(request.getParameter("Decision"));
			String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderDecision15, 1000, true) );
			String URLDecoderDecision_Esapi15 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
			
			String URLDecoderWSNAME16=URLDecoder.decode(request.getParameter("WSNAME"));
			String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("ProcessName", URLDecoderWSNAME16, 1000, true) );
			String URLDecoderWSNAME_Esapi16 = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
			
			String DECISION=URLDecoderDecision_Esapi15.replace("&amp;","&");
			String WORKSTEP_NAME=URLDecoderWSNAME_Esapi16.replace("&amp;","&");
			if (WSNAME != null) {WSNAME=WSNAME.replace("'","''");}
			if (DECISION != null) {DECISION=DECISION.replace("'","''");}
			if (WORKSTEP_NAME != null) {WORKSTEP_NAME=WORKSTEP_NAME.replace("'","''");}
		
			query = "select username from PDBUser with (nolock) where userIndex IN (select UserIndex from PDBGroupMember with (nolock) where GroupIndex in (select Userid from QUEUEUSERTABLE with (nolock) where QueueId IN (select QueueID from QUEUEDEFTABLE with (nolock) where QueueName IN (SELECT 'TF_'+workstep_name FROM USR_0_TF_DECISION_MASTER WHERE DECISION =:DECISION AND WORKSTEP_NAME=:WORKSTEP_NAME)))) order by username";
			params = "DECISION=="+DECISION+"~~WORKSTEP_NAME=="+WORKSTEP_NAME;			
			//WriteLog("getusersquery="+query);
						
		}
		else if (reqType.equals("Load_Currency"))
		{
			query = "SELECT curr_code FROM USR_0_TF_CurrencyMaster with (nolock) where 1=:ONE and isActive='Y' order by curr_code";
			params = "ONE==1";
		}
		sInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query + "</Query><Params>"+params+"</Params><EngineName>" + sCabName + "</EngineName><SessionId>" + sSessionId + "</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("\nInput XML in Drop Down load-- "+sInputXML);
	
		sOutputXML = WFCustomCallBroker.execute(sInputXML, sJtsIp, iJtsPort, 1);
		WriteLog("Output XML in Drop Down Load---- "+sOutputXML);

		xmlParserData=new WFCustomXmlResponse();
		xmlParserData.setXmlString((sOutputXML));
		String mainCodeValue = xmlParserData.getVal("MainCode");
		WriteLog("maincode in Drop Down Load"+mainCodeValue);
		
		int recordcount=0;
		try
		{
			recordcount=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
		}
		catch(Exception e)	
		{
		}
		WriteLog("reqType--"+reqType+"recordcount -- "+recordcount);
		if(reqType.equals("loadchecklist") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else if(reqType.equals("loadDocumentGrid") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else if(reqType.equals("loadInvoiceGrid") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else if(reqType.equals("getMailIdOfRORM") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else if(reqType.equals("GetQueue") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else if(reqType.equals("GetUsers") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else if(reqType.equals("Load_Currency") && recordcount==0)
		{
			returnValues="";
			//WriteLog("returnValues -- "+returnValues);
			out.clear();
			out.print(returnValues);
		}
		else{
			if(mainCodeValue.equals("0"))
			{
			//WriteLog("inside mainCodeValue -- "+mainCodeValue);
					objWorkList = xmlParserData.createList("Records","Record"); 
					for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
					{
					//WriteLog("for loop -- ");
						
						if (reqType.equals("selectDecision"))
							returnValues = returnValues + objWorkList.getVal("Decision")  + "~";
						else if (reqType.equals("Load_ModeOfDelivery"))
							returnValues = returnValues + objWorkList.getVal("Mode_Of_Delivery")  + "~";
						else if (reqType.equals("loadchecklist"))
							returnValues = returnValues + objWorkList.getVal("Checklist_Description") + "~" + objWorkList.getVal("Option_checklist") + "~" + objWorkList.getVal("Remarks")+ "~" + objWorkList.getVal("Workstep") + "|"; 
						else if (reqType.equals("loadcommngrid"))
							returnValues = returnValues + objWorkList.getVal("MODE_OF_COMMUNICATION") + "~" + objWorkList.getVal("COMMUNICATION_DATE") + "~" + objWorkList.getVal("COMMUNICATION_TIME") + "~" + objWorkList.getVal("DESCRIPTION_COMM") + "~" + objWorkList.getVal("CURRENT_DATE_COMM") + "|"; 
						else if (reqType.equals("loadlodgementdate"))
							returnValues = returnValues + objWorkList.getVal("IntroductionDateTime")  + "~";
						else if (reqType.equals("loadDocumentGrid"))
							returnValues = returnValues + objWorkList.getVal("Case_Documents") + "~" + objWorkList.getVal("No_Of_Copies") + "~" + objWorkList.getVal("No_Of_Originals") + "|"; 
						else if (reqType.equals("loadDocumentGridOnCIFSearch"))
							returnValues = returnValues + objWorkList.getVal("DocumentGrid") + "|"; 
						else if (reqType.equals("loadChecklistCombo"))
							returnValues = returnValues + objWorkList.getVal("ChecklistCombo") + "|"; 
						else if (reqType.equals("loadEventGrid"))
							returnValues = returnValues + objWorkList.getVal("CIF_ID") + "~" + objWorkList.getVal("introductionDateAndTime") + "~" + objWorkList.getVal("Product_Category") + "~" + objWorkList.getVal("Product_Type") + "~" + objWorkList.getVal("IntoducedBy") + "~" + objWorkList.getVal("WI_NAME") + "|"; 
						else if (reqType.equals("loadInvoiceGrid"))
							returnValues = returnValues + objWorkList.getVal("INVOICE_ID") + "~" + objWorkList.getVal("INVOICE_NUMBER") + "|"; 
						else if (reqType.equals("getMailIdOfRORM"))
							returnValues = returnValues + objWorkList.getVal("MailId") + "~"; 
						else if (reqType.equals("GetQueue"))
							returnValues = returnValues + objWorkList.getVal("WORKSTEPS")  + "~";	
						
						else if (reqType.equals("GetUsers"))
							returnValues = returnValues + objWorkList.getVal("username")  + "~";
						else if (reqType.equals("Load_Currency"))
							returnValues = returnValues + objWorkList.getVal("curr_code")  + "~";						
					}	
					returnValues =  returnValues.substring(0,returnValues.length()-1);
					WriteLog("returnValues -- "+returnValues);
					out.clear();
					out.print(returnValues);	
				
			}
			else
			{
				WriteLog("Exception in loading dropdown values -- ");
				out.clear();
				out.print("-1");
			}
		}
	
%>