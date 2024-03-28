<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ include file="Log.process"%>
<%@ page import="java.sql.Clob"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<HTML>
	<HEAD>
		<TITLE> <%=request.getParameter("Parent_WI")%>: Parent WI UID History</TITLE>
		<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
		<meta http-equiv="Pragma" content="no-cache" />
		<meta http-equiv="Expires" content="0" />
		<style>
			@import url("/TWC/webtop/en_us/css/docstyle.css");
		</style>
	</HEAD>
	<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
		<script>
			function CloseWindow()
			{
				window.parent.close();
			}

		</script>
		<table border='1' cellspacing='1' cellpadding='0' width=100% >
			<tr class='EWHeader' width=100% class='EWLabelRB2'>
				<td colspan=4 align=center class='EWLabelRB2'>
					<b>Parent WI UID History Details</b>
				</td>
			</tr>
		</table>
		<br>
		<div style="height: 300px; overflow: auto;">
			<table border='1' cellspacing='1' cellpadding='0' width=100% >
				<tr class='EWHeader' width=100% class='EWLabelRB2'>
					<td width=8% style="text-align:center" class='EWLabelRB2'>
						<b>&nbsp;S.No&nbsp;</b>
					</td>
					<td width=20% style="text-align:center;min-width: 100px;" class='EWLabelRB2'>
						<b>&nbsp;UID&nbsp;</b>
					</td>
					<td width=28% style="text-align:center" class='EWLabelRB2'>
						<b>Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b>
					</td>
			</tr>
		<%	
			String Parent_WI=request.getParameter("Parent_WI");
			String Parent_Source=request.getParameter("ParentSource");
			if (Parent_WI != null) {Parent_WI=Parent_WI.replace("'","");}
			String UID_hist_table = "USR_0_TWC_UID_DTLS_GRID";
			String colname="";
			String colvalues="'";
			String strQuery="";
			String strInputXML="";
			String strOutputXML="";
			String mainCodeValue="";
			WFCustomXmlResponse xmlParserData=null;
			WFCustomXmlList objWorkList=null;	
			String UID ="";
			String REMARKS ="";
			String UID_SR_NO ="";
			String params = "";
			
			objWorkList=null;
			if(!"OMNIFLOW".equalsIgnoreCase(Parent_Source) && !"omniflow".equalsIgnoreCase(Parent_Source) )
			{
					strQuery="select UID_SR_NO,UID,REMARKS from "+UID_hist_table+" where WINAME=:Parent_WI order by UID_SR_NO asc";		
				params = "Parent_WI=="+Parent_WI;
				
				strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";

				//logger.info("strInputXML hist_table: \n"+strInputXML);
				strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
				
				xmlParserData=new WFCustomXmlResponse();
				xmlParserData.setXmlString((strOutputXML));
				mainCodeValue = xmlParserData.getVal("MainCode");
				//logger.info("strOutputXML hist_table:\n"+strOutputXML);
				
				if(mainCodeValue.equals("0"))
				{
					int recordcount = Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));
					objWorkList = xmlParserData.createList("Records","Record"); 
					for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
					{	
						UID_SR_NO = objWorkList.getVal("UID_SR_NO");
						UID = objWorkList.getVal("UID");
						REMARKS = objWorkList.getVal("REMARKS");
						//logger.info("\nrejectReasons in DecisionHistory.jsp: "+rejectReasons);
						//logger.info("\nusername in DecisionHistory.jsp: "+username);
						
						
						if (REMARKS==null||REMARKS.equalsIgnoreCase("NULL")||REMARKS.equals("")) 
							REMARKS="&nbsp;";
						
						// Replacing CCCOMMAAA with , from Remarks
						if (REMARKS != null && !REMARKS.equalsIgnoreCase("")) 
						{
							REMARKS=REMARKS.replace("CCCOMMAAA",",");
							REMARKS=REMARKS.replace("AMPNDCHAR","&");
							REMARKS=REMARKS.replace("ENSQOUTES","'");
							logger.info("REMARKS "+REMARKS);
						}
			%>
				<tr>
						<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=UID_SR_NO%></b></td>
						<td width=20% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=UID%></b></td>
						<td width=28% style="text-align:center;max-width:200px;word-wrap:break-word;padding:10px 3px 10px 3px;" class='EWNormalGreenGeneral1'>				
								<b ><%=REMARKS%></b>				
						</td>
					</tr>
			<%
					}
				}
				else
				{
					logger.info("Error fetching Parent WI UID History Details. Please contact Administrator for Parent_WI : "+Parent_WI);
				}
			}
			else
			{
				Connection conn = null;
				Statement stmt =null;
				ResultSet result=null;
				String OF_returnValues="";
				String OF_UID_SR_NO="";
				String OF_UID="";
				String OF_REMARKS="";
				
				try{
						
						String strPropFilePath= System.getProperty("user.dir") + File.separator + "CustomConfig" + File.separator + "TWC_Config.properties";
						Properties p =  new Properties();
						p.load(new FileInputStream(strPropFilePath));
						
						String OFcabinetName = p.getProperty("OFCabinetName");
				
						Context aContext = new InitialContext();
						DataSource aDataSource = (DataSource)aContext.lookup("jdbc/"+OFcabinetName);
						conn = (Connection)(aDataSource.getConnection());
						logger.info("got data source");
						stmt = conn.createStatement();
						String OF_Query="select UID_SR_NO,UID,REMARKS from USR_0_TWC_UID_DTLS_GRID where WINAME='"+Parent_WI+"' order by UID_SR_NO asc";
						logger.info("OmniFlow Query..."+OF_Query);
						result = stmt.executeQuery(OF_Query);
						logger.info("OmniFlow,result: "+result);
						
						
						if(result != null)
						{
							while(result.next())
							{
						
								 OF_UID_SR_NO = result.getString("UID_SR_NO");
								 OF_UID = result.getString("UID");
								 OF_REMARKS = result.getString("REMARKS");
								
							
							
								%>
									<tr>
									<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=OF_UID_SR_NO%></b></td>
									<td width=20% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=OF_UID%></b></td>
									<td width=28% style="text-align:center;max-width:200px;word-wrap:break-word;padding:10px 3px 10px 3px;" class='EWNormalGreenGeneral1'>				
											<b ><%=OF_REMARKS%></b>				
									</td>
								</tr>
								<%
							}
						}
						
						if(result != null)
						{
							result.close();
							result=null;
							logger.info("resultset Successfully closed"); 
						}
						if(stmt != null)
						{
							stmt.close();
							stmt=null;						
							logger.info("Stmt Successfully closed"); 
						}
						if(conn != null)
						{
							conn.close();
							conn=null;	
							logger.info("Conn Successfully closed"); 
						}
						
				}
				catch(Exception e){
					
				}
				finally
				{
					if(result != null)
					{
						result.close();
						result=null;
						logger.info("resultset Successfully closed"); 
					}
					if(stmt != null)
					{
						stmt.close();
						stmt=null;						
						logger.info("Stmt Successfully closed"); 
					}
					if(conn != null)
					{
						conn.close();
						conn=null;	
						logger.info("Conn Successfully closed"); 
					}
				}
			}
			
				
			
		%>
		
			</table>
			</div>
			<br>
			<table>
				<tr>
					<td><input name='Close' type='button' value='Close' onclick="CloseWindow()" class='EWButtonRB' style='width:60px' ></td>
				</tr>
			</table>
		
	</BODY>
</HTML>