<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="../TF_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%
	String WINAME=request.getParameter("wi_name");
	if (WINAME != null) {WINAME=WINAME.replace("'","''");}
	WriteLog("\n Inside Insert Invoice Data Jsp for WINAME: "+WINAME);
	String gridRow = request.getParameter("gridRow");
	gridRow=gridRow.replace("'","''");
	gridRow=gridRow.replace("ENCODEDAND","&");
	gridRow=gridRow.replace("ENSQOUTES","'");
	WriteLog("gridRow:  "+gridRow);
	
	String reqType = request.getParameter("reqType");
	WriteLog("reqType:  "+reqType);
	String loggedInuser = request.getParameter("loggedInuser");
	WriteLog("loggedInuser:  "+loggedInuser);
			
	WFCustomXmlResponse WFCustomXmlResponseData=null;
	String sCabName= customSession.getEngineName();	
	String sSessionId = customSession.getDMSSessionId();	
	String sJtsIp = customSession.getJtsIp();
	int iJtsPort = customSession.getJtsPort();
	
	    if(reqType.equalsIgnoreCase("InsertDocApproverUser")){
			
			String query1 = "select MailId from PDBUser where UserName=:UserName";
			String params = "UserName=="+loggedInuser;
			String inputData = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query1 + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
            WriteLog("\ninputData of InsertDocApproverUser for WINAME "+WINAME+" : "+inputData);
			
			String outputData = WFCustomCallBroker.execute(inputData, sJtsIp, iJtsPort, 1);
			WriteLog("\noutputData of InsertDocApproverUser for WINAME "+WINAME+" : "+outputData);
			
			WFCustomXmlResponseData=new WFCustomXmlResponse();
			WFCustomXmlResponseData.setXmlString(outputData);
			String maincode = WFCustomXmlResponseData.getVal("MainCode");
			String userEmail = "";
			
			if(maincode.equals("0"))
			{	
		        userEmail = WFCustomXmlResponseData.getVal("MailId");
			}
			WriteLog("userEmail--"+userEmail);
			
			//update this email in external table
			String tableName = "RB_TF_EXTTABLE";
			String colName = "DocApproverUser";
			String values ="'"+userEmail+"'";
			
			String sInputXML = "<?xml version=\"1.0\"?>" +
					"<APUpdate_Input>" +
						"<Option>APUpdate</Option>" +
						"<TableName>" + tableName + "</TableName>" +
						"<ColName>" + colName + "</ColName>" +
						"<Values>" + values + "</Values>" +
						"<WhereClause>" + "wi_name='"+WINAME+"'" + "</WhereClause>" +
						"<EngineName>" + customSession.getEngineName() + "</EngineName>" +
						"<SessionId>" + customSession.getDMSSessionId() + "</SessionId>" +
					"</APUpdate_Input>";

			WriteLog("XML for saving DocApproverUser by stutee, input "+sInputXML);
			String sOutputXML= WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			WriteLog("XML for saving DocApproverUser by stutee, output"+sOutputXML);
			
			
		
		}else{
			String colNames = "INVOICE_ID,INVOICE_NUMBER,WINAME";
			String values=gridRow;
			try
			{
					String sInputXML = "<?xml version=\"1.0\"?>" +
					"<APInsertExtd_Input>" +
					"<Option>APInsert</Option>" +
					"<TableName>USR_0_TF_INVOICE_DTLS_GRID</TableName>" +
					"<ColName>" + colNames + "</ColName>" +
					"<Values>" + values + "</Values>" +
					"<EngineName>" + sCabName + "</EngineName>" +
					"<SessionId>" + sSessionId + "</SessionId>" +
					"</APInsertExtd_Input>";
					
					WriteLog("\nsInsert InputXML For Invoice Data for WINAME "+WINAME+" : \n"+sInputXML);
					
					for (int i=0; i<3; i++)
					{
						String outputXML = WFCustomCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
						WriteLog("\nInsert OutputXML For Invoice Data for WINAME "+WINAME+" : \n"+outputXML);
						WFCustomXmlResponseData=new WFCustomXmlResponse();
						WFCustomXmlResponseData.setXmlString(outputXML);
						String maincode = WFCustomXmlResponseData.getVal("MainCode");
						if(!(maincode.equals("0")))
						{
							WriteLog("\n Failed To Insert Invoice Data for WINAME "+WINAME);
							out.clear();
							out.println("-1");
						}
						else
						{
							WriteLog("\n Invoice Data Inserted Successfully for WINAME "+WINAME);	
							out.clear();
							out.println("0");
							break;
						}
					}
			}
			catch(Exception e) 
			{
				out.clear();
				out.println("-1");
				WriteLog("\nException while inserting Invoice Data for WINAME "+WINAME+" : Exception is : "+e);
			}
		}
	
%>