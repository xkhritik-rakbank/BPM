<%@ include file="ajaxlog.process"%>

<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.io.*,java.util.*,java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import ="java.text.DecimalFormat"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>
	
<%@ page import="com.newgen.mvcbeans.model.wfobjects.WFDynamicConstant ,com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*,javax.faces.context.FacesContext,com.newgen.mvcbeans.controller.workdesk.*,java.util.*;"%>

<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<!--<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>-->

<%@page conten	tType="text/html" pageEncoding="UTF-8"%>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%!
	public String getAPDeleteXML(String strEngineName, String strSessionId, String tableName, String whereClause) 
    {
		return "<?xml version=\"1.0\"?>" +
            "<APDelete_Input>" +
            "<Option>APDelete</Option>" +
            "<TableName>" + tableName + "</TableName>" +
            "<WhereClause>" + whereClause + "</WhereClause>" +
            "<EngineName>" + strEngineName + "</EngineName>" +
            "<SessionId>" + strSessionId + "</SessionId>" +
            "</APDelete_Input>";
    }
    public String getAPInsertXML(String strEngineName, String strSessionId, String tableName, String columns, String strValues) 
    {
        return "<?xml version=\"1.0\"?>" +
            "<APInsert_Input>" +
            "<Option>APInsert</Option>" +
            "<TableName>" + tableName + "</TableName>" +
            "<ColName>" + columns + "</ColName>" +
            "<Values>" + strValues + "</Values>" +
            "<EngineName>" + strEngineName + "</EngineName>" +
            "<SessionId>" + strSessionId + "</SessionId>" +
            "</APInsert_Input>";
    }
	public String getAPSelectXML(String strEngineName, String strSessionId, String Query) 
	{
		return "<?xml version=\"1.0\"?>"
			+ "<APSelect_Input><Option>APSelect</Option>"
			+ "<Query>" + Query + "</Query>"
			+ "<EngineName>" + strEngineName + "</EngineName>"
			+ "<SessionId>" + strSessionId + "</SessionId>"
			+ "</APSelect_Input>";
    }
%>
<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("sessionID"), 1000, true) );
			String sessionID_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("wi_name"), 1000, true) );
			String wi_name_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
			String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("requestType"), 1000, true) );
			String requestType_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
			
			String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("createdBy"), 1000, true) );
			String createdBy_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
			
			String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("createdDt"), 1000, true) );
			String createdDt_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
			
			String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("expiryDate"), 1000, true) );
			String expiryDate_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
			
			String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("desc"), 1000, true) );
			String desc_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
			
			String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("debt_acc_num"), 1000, true) );
			String debt_acc_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
			

			String sessionID = sessionID_Esapi;
			String wi_name = wi_name_Esapi;
			WriteLog("sessionID----"+sessionID);
			//String sCabName=wfsession.getEngineName();	
			String sCabName=wDSession.getM_objCabinetInfo().getM_strCabinetName();
			String requestType =  requestType_Esapi;
			//String sJtsIp = wfsession.getJtsIp();
			String sJtsIp = wDSession.getM_objCabinetInfo().getM_strServerIP();
			String iJtsPort = wDSession.getM_objCabinetInfo().getM_strServerPort();
			WriteLog("iJtsPort----"+iJtsPort);
			
			if (requestType.equals("SHOW_MEMOPAD"))
			{
				String query = "SELECT row_number() over (order by description) as 'S.No',description FROM usr_0_tt_memopadDetails where WINAME ='"+wi_name+"'";
				String outputXML ="";
				
				//WriteLog("sJtsIp----"+sJtsIp);
				//WriteLog("iJtsPort----"+iJtsPort);
				
				String InputXml = getAPSelectXML(sCabName,sessionID,query);
				WriteLog("InputXml----"+InputXml);
				try{
					//outputXML=WFCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
					 outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), InputXml);
					
					WriteLog("outputXML----"+outputXML);
					
					//outputXML = outputXML.substring(outputXML.indexOf("<Records>")+"<Records>".length(),outputXML.indexOf("</Records>"));
				}catch(Exception e){
				}
				out.clear();
				
				//outputXML="<tr><td>Test Acc Num</td><td>Test Creation Date</td><td>Test Expiry Date</td><td>TestCreated By</td><td>Test desc</td></tr><tr><td>Test Acc Num1</td><td>Test Creation Date1</td><td>Test Expiry Date1</td><td>TestCreated By1</td><td>Test desc1</td></tr>";
				out.println("<output>"+outputXML+"</output>");
				 
			}
			else if (requestType.equals("INSERT_MEMOPAD"))
		{
			/*//First Check if alredy inserted or not
			String query = "SELECT ACC_NUM, CONVERT(varchar,CreatedDate,101) ,CONVERT(varchar,expiry_date,101),created_by,description FROM usr_0_tt_memopadDetails where WINAME = '"+wi_name+"'";
			String InputXml = getAPSelectXML(sCabName,sessionID,query);
			String entryExist = "";
			String outputXML ="";
			
			WriteLog("InputXml----"+InputXml);
		
			//outputXML=WFCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
			outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), InputXml);
			WriteLog("outputXML----"+outputXML);
			
			entryExist = outputXML.substring(outputXML.indexOf("<TotalRetrieved>") + 16, outputXML.indexOf("</TotalRetrieved>"));
			
			//Only insert when there is no entry
			if (!(entryExist.equals("1")))
			{*/
			
			//first delete the existing memopads before inserting
			
			String strWhereClause="WINAME ='"+wi_name+"'";
			String InputXml = getAPDeleteXML(sCabName,sessionID,"usr_0_tt_memopadDetails",strWhereClause );
			WriteLog("Deleting from MemoPad Table: Input"+InputXml);
			//String outputXML=WFCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
			String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), InputXml);
			WriteLog("outputXML----"+outputXML);
			
			
			//WriteLog("reqType = "+requestType);
			String createdBy=createdBy_Esapi;
			String createdDt=createdDt_Esapi;
			String expiryDate=expiryDate_Esapi;
			String desc	= desc_Esapi;
			String debt_acc_num = debt_acc_num_Esapi;

			/*WriteLog("createdBy = "+createdBy);
			WriteLog("createdDt = "+createdDt);
			WriteLog("expiryDate = "+expiryDate);
			WriteLog("desc = "+desc);
			*/
			
			String createdByArr[] = createdBy.replaceAll("(,)*$", "").split(",");
			String createdDtArr[] = createdDt.replaceAll("(,)*$", "").split(",");
			String expiryDateArr[] = expiryDate.replaceAll("(,)*$", "").split(",");
			String descArr[] = desc.replaceAll("(,)*$", "").split("`");
			String columns = "WINAME, ACC_NUM, CreatedDate, EXPIRY_DATE, CREATED_BY, DESCRIPTION";
			String strValues = "";
			for (int i = 0;i<createdByArr.length;i++)
			{
				strValues = "'"+wi_name+"','"+debt_acc_num+"','"+createdDtArr[i]+"','"+expiryDateArr[i]+"','"+createdByArr[i]+"','"+descArr[i].replaceAll("'","''")+"'";
				String sInputXML = getAPInsertXML (sCabName,sessionID,"usr_0_tt_memopadDetails",columns,strValues);

				WriteLog("Inserting into MemoPad Table: Input"+sInputXML);
				//String sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
				String sOutputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), sInputXML);
				WriteLog("Output : "+sOutputXML);
				out.clear();
			}
			//}
		}
		else if (requestType.equals("DELETE_MEMOPAD"))
        {
            String strWhereClause="WINAME ='"+wi_name+"'";
            String InputXml = getAPDeleteXML(sCabName,sessionID,"usr_0_tt_memopadDetails",strWhereClause );
            WriteLog("Deleting from MemoPad Table: Input"+InputXml);
            //String outputXML=WFCallBroker.execute(InputXml, sJtsIp, iJtsPort, 1);
			String outputXML = NGEjbClient.getSharedInstance().makeCall(wDSession.getM_objCabinetInfo().getM_strServerIP(), wDSession.getM_objCabinetInfo().getM_strServerPort(), wDSession.getM_objCabinetInfo().getM_strAppServerType(), InputXml);
            WriteLog("outputXML----"+outputXML);
            
        }
%>			
