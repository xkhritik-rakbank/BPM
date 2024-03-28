<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@page language="java" session="true" %>

<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
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

<!---<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>--->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>



<%

String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("svalue"), 1000, true) );
			String svalue_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			WriteLog("svalue Request.getparameter---> "+request.getParameter("svalue"));
			WriteLog("svalue Esapi---> "+svalue_Esapi);
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("WINAME"), 1000, true) );
			String WINAME_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			WriteLog("WINAME Request.getparameter---> "+request.getParameter("WINAME"));
			WriteLog("WINAME Esapi---> "+WINAME_Esapi);

	String sOutPutXML = "";
	String sInputXML = "";
	try
	{
		String sJtsIp = null;
		int iJtsPort = 0;
		
		String WINAME = WINAME_Esapi;
		String svalue = svalue_Esapi;
		WriteLog("WINAME------------------"+WINAME);
		WriteLog("svalue------------------"+svalue);		
		//sJtsIp = wfsession.getJtsIp();
		sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
	//	iJtsPort = wfsession.getJtsPort();
		iJtsPort = Integer.parseInt(wDSession.getM_objCabinetInfo().getM_strServerPort());
		//String username=wfsession.getUserName();
		String username=wDSession.getM_objUserInfo().getM_strUserName();
	//	String sessionId=wfsession.getSessionId();
		String sessionId= wDSession.getM_objUserInfo().getM_strSessionId();
		//String engineName=wfsession.getEngineName();	
		String engineName=wDSession.getM_objCabinetInfo().getM_strCabinetName();	
		
					String mainGridvalue="";
					String Query="SELECT CIFID,CustomerName,CustomerType FROM usr_0_tl_listofcifs WHERE WI_NAME='"+WINAME+"'";
					
					//String inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wfsession.getEngineName() + "</EngineName><SessionId>" + wfsession.getSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
					String inputData = "<?xml version='1.0'?><APSelectWithColumnNames_Input><Option>APSelectWithColumnNames</Option><Query>" + Query + "</Query><EngineName>" + wDSession.getM_objCabinetInfo().getM_strCabinetName() + "</EngineName><SessionId>" + wDSession.getM_objUserInfo().getM_strSessionId() + "</SessionId></APSelectWithColumnNames_Input>";
					
					//String outputData = WFCallBroker.execute(inputData, wfsession.getJtsIp(), wfsession.getJtsPort(), 1);
					String outputData = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), inputData);

					WriteLog("Output-TL-"+outputData);
					String rowVal="";
					String cif_num="";
					String cus_name="";
					String cif_type="";
					String temp_table="";
					String MainRadio = "";
					String table_name="usr_0_tl_listofcifs";
					String columns="WI_NAME,CIFID,CustomerName,CustomerType";
					String values="";
					
					
					if(outputData.contains("<TotalRetrieved>0</TotalRetrieved>"))
					{
						String[] temp = svalue.split("~");
						String[] temp1;
						
						for(int i=0;i<temp.length;i++)
						{
							temp1 = temp[i].split("#");
							for(int j=0;j<temp1.length;j++)
							{
								cif_num = temp1[1];
								cus_name = temp1[3];
								cif_type = temp1[2];
								WriteLog("temp1[j]"+temp1[j]);
								
							}
							try	{
										values = "'" + WINAME +"'" + "," + "'" + cif_num +"'" + "," + "'" + cus_name +"'" + "," + "'" + cif_type +"'";
										 sInputXML = "<?xml version=\"1.0\"?>" +
												"<APInsert_Input>" +
												"<Option>APInsert</Option>" +
												"<TableName>" + table_name + "</TableName>" +
												"<ColName>" + columns + "</ColName>" +
												"<Values>" + values + "</Values>" +
												"<EngineName>" + engineName + "</EngineName>" +
												"<SessionId>" + sessionId + "</SessionId>" +
												"</APInsert_Input>";
										
										WriteLog("Updating GridDataOnSave :::::::::::: "+sInputXML);
										//String sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
										String sOutputXML= NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
										
										WriteLog("Updating GridDataOnSave sOutputXML : "+sOutputXML);
										if(sOutputXML.indexOf("<MainCode>0</MainCode>")>-1)
										{
											WriteLog("Update Successful GridDataOnSave");
										}
										else
											WriteLog("Update UnSuccessful GridDataOnSave");
									}
									catch(Exception e) 
									{
										WriteLog("<OutPut>Error in getting User Session.</OutPut>");
									}
									
						}
					}
					
					
									
	}
	catch(Exception e)
	{
		e.printStackTrace();
		sOutPutXML="Exception"+((e.getMessage()==null)?"NULL":e.getMessage());
	}

	out.clear();
	out.println(sOutPutXML);
%>