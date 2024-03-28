<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application ?Projects
//Product / Project			 : RAKBank
//File Name					 : DeleteSignFromServer.jsp
//Author                     : Mandeep
//Date written (DD/MM/YYYY) :  18-01-2016
//---------------------------------------------------------------------------------------------------->
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
<%@ include file="Log.process"%>
<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->

<%

			String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("debt_acc_num"), 1000, true) );
			String debt_acc_num_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
			
			String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("returnedSignatures"), 1000, true) );
			String returnedSignatures_Esapi = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
			
	//String filePath = "installedApps/ANT1OMNIAPPS02Node01Cell/OFWEB.ear/OFWEB.ear/webdesktop.war/CustomForms/TT_Specific";  // Prod
	String filePath = "installedApps/ANT1OMNIAPPS02Node01Cell/OFWEB.ear/webdesktop.war/CustomForms/TT_Specific";  // UAT
	//String filePath = request.getParameter("filePath"); 
	String debt_acc_num = debt_acc_num_Esapi;
	String returnedSignatures = returnedSignatures_Esapi;

	int totalSign =  Integer.parseInt(returnedSignatures);
	
	WriteLog("filePath inside the DeleteSignFromServer.jsp----"+filePath);
	WriteLog("debt_acc_num----"+debt_acc_num);
	WriteLog("returnedSignatures----"+returnedSignatures);
	
	String filePathWithAccNum = filePath + "/" + debt_acc_num;
	
	WriteLog("filePathWithAccNum----"+filePathWithAccNum);
	WriteLog("totalSign----"+totalSign);
	for (int i = 0;i < totalSign;i++)
	{
		String fileTemp = filePathWithAccNum+"imageCreatedN"+i+".jpg";
		WriteLog("Deleting file ----"+fileTemp);
		
		try {
		File f = new File(fileTemp);
		
			if(f.delete())					
				WriteLog("Sucessfully deleted file- " + fileTemp);
			else							
				WriteLog("Error in deleting file- " + fileTemp);
			
		}
		catch (Exception e)
		{			
			WriteLog("Error in deleting file- " + fileTemp);
		}
		
	}
%>