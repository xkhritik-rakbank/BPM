<%--
	
	Product/Project :       Rak Bank
	Module          :       OCC - SSL
	File            :       CSR_SSC_Limit.jsp
	Purpose         :       To get the CARD Limit for the required card from CAPSMAIN table
	Author			:		Saurabh Arora
	Added On		:		10/02/2009
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/084	
--%>
<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>


<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource" %>

<html>
<%	
String amount = "";
try
{	
	WriteLog("Check Supp Card Limit....");
 	Connection conn = null;
	Statement stmt =null;
	ResultSet result=null;
	Context aContext = new InitialContext();
	DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
	conn = (Connection)(aDataSource.getConnection());
	WriteLog("got data source");
	stmt = conn.createStatement();
	String CreditCardNo=request.getParameter("CreditCardNo");
	String sSQL = "select CreditLimit from CAPSADMIN.capsmain where creditcardno='"+CreditCardNo+"'";

	WriteLog("Execute Query..." + sSQL);
	result = stmt.executeQuery(sSQL);
	
	while (result.next())
	{
		amount = result.getString(1);
		WriteLog("Primary Card Limit : "+amount);
		out.println(amount);
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
catch(Exception exp)
{
	out.println("sa");
	WriteLog("Error in connecting with CAPS system");
}

%>
<SCRIPT>
	window.returnValue="<%=amount%>";
	window.close();
</SCRIPT>
</html>