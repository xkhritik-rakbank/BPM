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
		<TITLE> <%=request.getParameter("WINAME")%>: Decision History</TITLE>
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
		<%	
			String WINAME=request.getParameter("WINAME");
			if (WINAME != null) {WINAME=WINAME.replace("'","");}
			String hist_table = "USR_0_TWC_WIHISTORY";
			String colname="";
			String colvalues="'";
			String strQuery="";
			String strInputXML="";
			String strOutputXML="";
			String mainCodeValue="";
			WFCustomXmlResponse xmlParserData=null;
			WFCustomXmlList objWorkList=null;	
			String subXML="";
			String wsname ="";
			String OSWsname = "";
			String decision ="";
			Date datetime=null;
			String actiondatetime ="";
			String remarks ="";
			String rejectReasons ="";
			String username ="";
			String params = "";
			
			String strPropFilePath= System.getProperty("user.dir") + File.separator + "CustomConfig" + File.separator + "TWC_Config.properties";
			//WriteLog("Inside strPropFilePath: "+strPropFilePath);
			//com.newgen.omniflow.CustomLogger.printLogLnDt("customlogger", "debug_TWC_CP", "strPropFilePath -->"+strPropFilePath);
			Properties p =  new Properties();
			p.load(new FileInputStream(strPropFilePath));
			
			String OFcabinetName = p.getProperty("OFCabinetName");
			HashMap<String,String> RejectReasonsMap = new HashMap<String, String>();
				
			strQuery="select item_code,Item_Desc from USR_0_TWC_ERROR_DESC_MASTER with(nolock) where isactive=:isactive order by id asc";
			params = "isactive==Y";
			
			strInputXML = "<?xml version='1.0'?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + strQuery + "</Query><Params>"+params+"</Params><EngineName>" + customSession.getEngineName() + "</EngineName><SessionId>" + customSession.getDMSSessionId() + "</SessionId></APSelectWithNamedParam_Input>";
			
			strOutputXML = WFCustomCallBroker.execute(strInputXML, customSession.getJtsIp(), customSession.getJtsPort(), 1);
			//logger.info("outputXML: "+strOutputXML);
			
			xmlParserData=new WFCustomXmlResponse();
			xmlParserData.setXmlString((strOutputXML));
			mainCodeValue = xmlParserData.getVal("MainCode");
			
			int records=0;
			records=Integer.parseInt(xmlParserData.getVal("TotalRetrieved"));

			if(mainCodeValue.equals("0"))
			{
				objWorkList = xmlParserData.createList("Records","Record"); 
				for(objWorkList.reInitialize(true);objWorkList.hasMoreElements(true);objWorkList.skip(true))
				{
					RejectReasonsMap.put(objWorkList.getVal("item_code"),objWorkList.getVal("Item_Desc"));	
					
				}
				/*for (Map.Entry<String,String> entry : RejectReasonsMap.entrySet()) 
				{
					logger.info("Key = " + entry.getKey() +
									 ", Value = " + entry.getValue());
				}*/
			}
		objWorkList=null;
		Connection conn = null;
		Statement stmt =null;
		ResultSet result=null;
			
		try
		{			
			Context aContext = new InitialContext();
			DataSource aDataSource = (DataSource)aContext.lookup("jdbc/"+OFcabinetName);
			conn = (Connection)(aDataSource.getConnection());
			logger.info("got data source");
			stmt = conn.createStatement();
			String OF_Query="select id,wsname,actual_wsname,decision,actiondatetime,remarks,username,rejectreasons from "+hist_table+" where WINAME='"+WINAME+"' and actiondatetime is not null order by actiondatetime desc";
			
			logger.info("OmniFlow Query..."+OF_Query);
			result = stmt.executeQuery(OF_Query);
			logger.info("OmniFlow,result: "+result);
			
			if(result != null)
			{
				SimpleDateFormat sdf=new SimpleDateFormat("dd-MMM-yyyy hh:mm:ss a");
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				%>
				<table border='1' cellspacing='1' cellpadding='0' width=100% >
					<tr class='EWHeader' width=100% class='EWLabelRB2'>
						<td colspan=4 align=center class='EWLabelRB2'>
							<b>Decision History</b>
						</td>
					</tr>
				</table>
				<br>
				<div style="height: 300px; overflow: auto;">
					<table border='1' cellspacing='1' cellpadding='0' width=100% >
						<tr class='EWHeader' width=100% class='EWLabelRB2'>
							<td width=11% style="text-align:center" class='EWLabelRB2'>
								<b>&nbsp;&nbsp;&nbsp;&nbsp;DateTime&nbsp;&nbsp;&nbsp;&nbsp;</b>
							</td>
							<td width=8% style="text-align:center" class='EWLabelRB2'>
								<b>&nbsp;Workstep&nbsp;</b>
							</td>
							<td width=11% style="text-align:center;min-width: 100px;" class='EWLabelRB2'>
								<b>&nbsp;User Name&nbsp;</b>
							</td>
							<td width=8% style="text-align:center" class='EWLabelRB2'>
								<b>&nbsp;Decision&nbsp;</b>
							</td>
							<td width=26% style="text-align:center;min-width: 150px;" class='EWLabelRB2'>
								<b>&nbsp;Reject Reasons&nbsp;</b>
							</td>
							<td width=28% style="text-align:center" class='EWLabelRB2'>
								<b>Remarks&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</b>
							</td>
					</tr>
				<% 
				while(result.next())
				{ 
					datetime = formatter.parse(result.getString("actiondatetime"));
					actiondatetime = sdf.format(datetime);
					wsname =result.getString("wsname");
					//OSWsname = objWorkList.getVal("wsname");
					username = result.getString("username");
					decision = result.getString("decision");
					rejectReasons = result.getString("rejectreasons");
					remarks = result.getString("remarks");
					//logger.info("\nrejectReasons in DecisionHistory.jsp: "+rejectReasons);
					//logger.info("\nusername in DecisionHistory.jsp: "+username);
					String 	rejectReasonsinRow="";
					/*if(OSWsname.equalsIgnoreCase("CSO_Omniscan"))
					{
						wsname = "CSO_Omniscan";
					}*/
					if (rejectReasons==null||rejectReasons.equalsIgnoreCase("NULL")||rejectReasons.trim().equals(""))
						rejectReasonsinRow="&nbsp;";
					else
					{
						String strReasons[] = rejectReasons.split("#");
						for(int count=0;count<strReasons.length;count++)
						{
							//logger.info("strReasons: "+strReasons[count]);
							String desc=strReasons[count].split(":")[0];
							if(count==0)
								rejectReasonsinRow=RejectReasonsMap.get(strReasons[count]);
							else
								rejectReasonsinRow+="<br><br>"+RejectReasonsMap.get(strReasons[count]);						
						
							//logger.info("\nrejectReasonsinRow in for in DecisionHistory.jsp "+rejectReasonsinRow);
						}
					}
					//logger.info("\nrejectReasonsinRow in DecisionHistory.jsp "+rejectReasonsinRow);
					if (rejectReasonsinRow==null||rejectReasonsinRow.equalsIgnoreCase("NULL")||rejectReasonsinRow.equals("")) rejectReasonsinRow="&nbsp;";
					//logger.info("\nrejectReasonsinRow second in DecisionHistory.jsp "+rejectReasonsinRow);
					if (remarks==null||remarks.equalsIgnoreCase("NULL")||remarks.equals("")) 
						remarks="&nbsp;";
					
					// Replacing CCCOMMAAA with , from Remarks
					if (remarks != null && !remarks.equalsIgnoreCase("")) 
					{
						remarks=remarks.replace("CCCOMMAAA",",");
						remarks=remarks.replace("AMPNDCHAR","&");
						remarks=remarks.replace("ENSQOUTES","'");
						logger.info("Remarks "+remarks);
					}
					%>
						<tr>
							<td width=11% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=actiondatetime%></b></td>
							<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=wsname%></b></td>
							<td width=11% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=username%></b></td>
							<td width=8% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=decision%></b></td>
							<td width=26% style="text-align:center" class='EWNormalGreenGeneral1'><b><%=rejectReasonsinRow%></b></td>
							<td width=28% style="text-align:center;max-width:200px;word-wrap:break-word;padding:10px 3px 10px 3px;" class='EWNormalGreenGeneral1'>				
									<b ><%=remarks%></b>				
							</td>
						</tr>
					<%
				}
			}
			else
			{
				logger.info("Error fetching DecisionHistory.Please contact Administrator for WINAME : "+WINAME);
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
		catch (java.sql.SQLException e)
		{
			logger.info("SQLException -->"+e.toString());
		}
		catch(Exception e)
		{
			logger.info("Exception -->"+e.toString());
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