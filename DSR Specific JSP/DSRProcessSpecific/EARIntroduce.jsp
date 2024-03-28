<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<HTML>
<HEAD><style></style></HEAD>
	<body class='EWGeneralRB'>
	<%
		String sInputXML ="";
		String sOutputXML = "";
		String sCabName=null;
		String sSessionId = null;
		String sJtsIp = null;
		String sProcessDefId="";
		String sMsg="";
		int iJtsPort = 0;
		boolean bError=false;
		WFXmlResponse objWorkListXmlResponse;
		WFXmlList objWorkList;

		String a="";
		String b="";

		try
		{
			sCabName=wfsession.getEngineName();
			sSessionId = wfsession.getSessionId();
			sJtsIp = wfsession.getJtsIp();
			iJtsPort = wfsession.getJtsPort();
		}
		catch(WFException ignore)
		{
			a=ignore.getMainCode();
			b=ignore.getSource();
		}
		if (a.equals("-50146") || a.equals("4002") || a.equals("11") || a.equals("4020"))
		{
			bError= true;
			sMsg = "User session has been expired. Please re-login.";
		}
		WriteLog("Process Name : "+request.getParameter("ProcessName"));
		if(!bError)
		{
			sInputXML =	"?xml version=\"1.0\"?>\n" +
				"<WMOpenProcessDefinition_Input>" +
					"<Option>WMFetchProcessDefinitions</Option>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"<SessionId>"+sSessionId+"</SessionId>" +
					"<Filter>" +
						"<Type>256</Type>" +
						"<AttributeName></AttributeName>" +
						"<Comparison>0</Comparison>" +
						"<FilterString>LOWER(RTRIM(CABINETNAME)) = '"+sCabName+"' AND UPPER(RTRIM(PROCESSNAME)) = '"+request.getParameter("ProcessName")+"'</FilterString>" +
						"<Length>0</Length>" +
					"</Filter>" +
				"</WMOpenProcessDefinition_Input>";

			WriteLog(sInputXML);
			sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
			out.println(sOutputXML);
			WriteLog(sOutputXML);
			if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0)
			{
				bError= true;
				sMsg = "Could Not Fetch Process Definition.";
			}
			else
			{
				sProcessDefId=sOutputXML.substring(sOutputXML.indexOf("<ProcessDefinitionId>")+21 , sOutputXML.indexOf("</ProcessDefinitionId>"));
			}
			if(!bError)
			{
					sInputXML =	"?xml version=\"1.0\"?>\n" +
					"<WFUploadWorkItem_Input>" +
					"<Option>WFUploadWorkItem</Option>" +
					"<EngineName>"+sCabName+"</EngineName>" +
					"<SessionId>"+sSessionId+"</SessionId>" +
					"<ProcessDefId>"+sProcessDefId+"</ProcessDefId>" + 			
					"<Attributes>"+WFUtility.Replace(request.getParameter("WIData"),"'","''")+"</Attributes>" +
					"</WFUploadWorkItem_Input>";		

					WriteLog(sInputXML);
					sOutputXML= WFCallBroker.execute(sInputXML,sJtsIp,iJtsPort,1);
					out.println(sOutputXML);
					WriteLog(sOutputXML);
					if(sOutputXML.equals("") || Integer.parseInt(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")))!=0)
					{
						bError = true;
						if(sOutputXML.substring(sOutputXML.indexOf("<MainCode>")+10 , sOutputXML.indexOf("</MainCode>")).equals("2"))
						{
							sMsg="Either Process is Disabled Or Used does not has rights to perform this operation.";
						}
						else
						{
							sMsg=sOutputXML.substring(sOutputXML.indexOf("<Subject>")+9 , sOutputXML.indexOf("</Subject>"));
						}
					}	
					else
					{
						sMsg=sOutputXML.substring(sOutputXML.indexOf("<ProcessInstanceId>")+19 , sOutputXML.indexOf("</ProcessInstanceId>")) + " Created.";
					}
			}
		}
	%>
		<script>
			parent.window.returnValue='<%=sMsg%>';
			parent.window.close();
		</script>
	</body>
</html>
