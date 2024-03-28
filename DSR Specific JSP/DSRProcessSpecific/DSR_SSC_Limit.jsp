<%--
	
	Product/Project :       Rak Bank
	Module          :       OCC - SSL
	File            :       DSR_SSC_Limit.jsp
	Purpose         :       To get the CARD Limit for the required card from ... table
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


<%@ page import="java.io.IOException,java.sql.Connection,java.sql.ResultSet,java.sql.Statement,javax.naming.Context,javax.naming.InitialContext,javax.servlet.Servlet,javax.servlet.ServletException,javax.servlet.http.HttpServlet,javax.servlet.http.HttpServletRequest,javax.servlet.http.HttpServletResponse,javax.sql.DataSource,java.sql.PreparedStatement" %>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/CSR_RBCommon.js"></script>
<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<html>
<%	
String amount = "";

	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CreditCardNo", request.getParameter("CreditCardNo"), 1000, true) );
	String CreditCardNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: CreditCardNo: "+CreditCardNo);
try
{	
	WriteLog("Check Supp Card Limit....");
 	Connection conn = null;
	//Statement stmt =null;
	PreparedStatement stmt=null;
	ResultSet result=null;
	Context aContext = new InitialContext();
	//DataSource aDataSource = (DataSource)aContext.lookup("jdbc/cbop");
	DataSource aDataSource = (DataSource)aContext.lookup("jdbc/rakcabinet");
	conn = (Connection)(aDataSource.getConnection());
	WriteLog("got data source");
	//stmt = conn.createStatement();
	String CreditCardNo=CreditCardNo;
	String sSQL = "select CreditLimit from capsmain where creditcardno=?";

	WriteLog("Execute Query..." + sSQL);
	stmt = conn.prepareStatement(sSQL);
	stmt.setString(1, CreditCardNo);
	result = stmt.executeQuery();
	
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