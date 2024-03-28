<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application Projects
//Product / Project			 : RAKBank
//File Name					 : OpenImage.jsp
//Author                     : Amitabh
//Date written (DD/MM/YYYY) :  23-02-2017
//---------------------------------------------------------------------------------------------------->

<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.custom.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.*" %>
<%@ page import="com.newgen.custom.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.wfdesktop.exception.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="java.math.*"%>
<%@ page import ="org.w3c.dom.*"%>
<%@ include file="Log.process"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>

<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="/SRB/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
	String debt_acc_numArrForJs = "";
	String onloadacc = "";
	String filePath =System.getProperty("user.dir");
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("ws_name"), 1000, true) );    
	String wsname = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("wsname wsname........: " +wsname);
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("htmlInput", request.getParameter("acc_num_new"), 1000, true) );    
	String acc_num_new = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	//String acc_num_new = "458754569005@225600987400";
	String srNumber = "1111232";
	//String srNumber = request.getParameter("srNumber");
	
	if (acc_num_new != null) {acc_num_new=acc_num_new.replace("&#x40;","@");}
	
	String sInputXML = "";
	String sMappOutPutXML = "";
	StringBuilder html = new StringBuilder();
	
	String sessionId=customSession.getDMSSessionId();
	String engineName=customSession.getEngineName();
	String username=customSession.getUserName();
	
	//WriteLog("Account no: " +acc_num_new);
	String[] acc_new = acc_num_new.split("@");
	for (int i = 0; i < acc_new.length; i++) {
		if (debt_acc_numArrForJs == "")
			debt_acc_numArrForJs = debt_acc_numArrForJs + acc_new [i];
		else
			debt_acc_numArrForJs = debt_acc_numArrForJs + "#" + acc_new [i];
		
		onloadacc = acc_new[0];
	}
	
	html.append("<ul style='margin-top:10px;'>");
	for (int i=0;i<acc_new.length;i++)
		html.append("<li style='cursor: pointer; border: 1px solid black; border-color: #FFFFFF; background-color: #990033; color : #FEFAEF ;padding:1px; margin-right:5px;' onclick='clickMe(this)'>"+acc_new[i]+"</li>");
	
	html.append("</ul>");
	out.clear();
%>

<!DOCTYPE html>
<html>
<head>
<title>View Signatures</title>
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />
<link rel="stylesheet" href="\CU\webtop\en_us\css\docstyle.css">
<style>
.wrap {
	width: 100%;
	
}

.fleft {
    float:left;
    width: 20%;
	background:#FEFAEF;
    height: 620px;
}

.fright {
	float: right;
    background:white;
    height: 620px;
    width: 80%;
}

</style>
<script>


function onloadclickMe(element) {
	var debtAccNum = element;
	document.getElementById('if').src="/SRB/CustomForms/SRB_Specific/loadImages.jsp?debtAccNum="+debtAccNum;
}

function clickMe(element) {
	var debtAccNum = element.innerHTML;
	document.getElementById('if').src="/SRB/CustomForms/SRB_Specific/loadImages.jsp?debtAccNum="+debtAccNum;
}
</script>

</head>
<body onUnload="deleteImageFromServer ('<%=filePath%>','<%=debt_acc_numArrForJs%>');" style="overflow: auto" onload = "onloadclickMe('<%=onloadacc%>');">

<input type="hidden" id="wsname_sign" value="<%=wsname%>">

<div class="wrap">
    <div class="fleft">
		<%	out.print(html.toString()); %>
	</div>
    <div class="fright">
		<iframe name='if' id="if"  width="100%" height="100%"></iframe>
	</div>
	<div class="wrap">
	
	    <%if(wsname.equalsIgnoreCase("Q2") || wsname.equalsIgnoreCase("Q4") || wsname.equalsIgnoreCase("Q11") || wsname.equalsIgnoreCase("Q12") || wsname.equalsIgnoreCase("Q17") || wsname.equalsIgnoreCase("Q18") || wsname.equalsIgnoreCase("Q20") || wsname.equalsIgnoreCase("Q21") || wsname.equalsIgnoreCase("Q23") || wsname.equalsIgnoreCase("Q24"))
		{
		%>
		<input type="button" style="margin-left:350px" id="sign_matchedOk" value="Sign Matched" onclick="sendValues('Ok');" class="EWButtonRB" />
		<input type="button" id="sign_matchedCancel" value="Sign Not Matched" onclick="sendValues('Cancel');" class="EWButtonRB" />
		<%
		}else{
		%>
		<input type="button" style="margin-left:350px" id="sign_matchedOk" value="Sign Matched" disabled onclick="sendValues('Ok');" class="EWButtonRB" />
		<input type="button" id="sign_matchedCancel" value="Sign Not Matched" disabled onclick="sendValues('Cancel');" class="EWButtonRB" />
		<%}%>
	</div>	
</div>
<br/>
<br/>
<script>

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer           
//Date Modified                       :  15/01/2015     
//Author                              :  Mandeep
//Description                		  :  This function sets the sign_matched value to the parent window 

//***********************************************************************************//	
function sendValues(status) {
	
	if (status=='Ok')
	{
		//sendObj = {name:"SignMatched",value:"Yes"};
		//window.returnValue = sendObj;
		var wsname=document.getElementById('wsname_sign').value;
		window.opener.setSignMatchValues(wsname,'Yes');
	}
	else if (status=='Cancel')
	{
		//sendObj = {name:"SignMatched",value:"No"};
		//window.returnValue = sendObj;
		var wsname=document.getElementById('wsname_sign').value;
		window.opener.setSignMatchValues(wsname,'No');
	}
	
	window.close();
}
//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer           
//Date Modified                       :  15/01/2015     
//Author                              :  Mandeep
//Description                		  :  This function deleted the images from the server by using file DeleteSignFromServer.jsp

//***********************************************************************************//	
function deleteImageFromServer(filePath,debt_acc_numArrForJs)
{
	var url = 'DeleteSignFromServer.jsp?filePath='+filePath+"&debt_acc_num="+debt_acc_numArrForJs;
	var xhr;
	var ajaxResult;	
	
	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");

	 xhr.open("GET",url,false); 
	 xhr.send(null);

	if (xhr.status == 200) { 
		//Do nothing
	}
	else
	{
		alert("Error while deleting signature files from server");
		return false;
	}
}
</script>
</body>
</html>