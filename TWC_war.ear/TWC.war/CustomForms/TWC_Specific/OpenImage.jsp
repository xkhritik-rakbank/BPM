<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application Projects
//Product / Project			 : RAKBank
//File Name					 : OpenImage.jsp
//Author                     : Mandeep
//Date written (DD/MM/YYYY) :  29-05-2016
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
<%@ include file="../TWC_Specific/Log.process"%>
<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
	String debt_acc_numArrForJs = "";
	String onloadacc = "";
	String filePath =System.getProperty("user.dir");
	String wsname = request.getParameter("ws_name");
	String acc_num_new = request.getParameter("acc_num_new");
	//String srNumber = request.getParameter("srNumber");
	
	String sInputXML = "";
	String sMappOutPutXML = "";
	StringBuilder html = new StringBuilder();
	
	String sessionId=customSession.getDMSSessionId();
	String engineName=customSession.getEngineName();
	String username=customSession.getUserName();
	
	//WriteLog(" Account no: " +acc_num_new);
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
<link rel="stylesheet" href="\TWC\webtop\en_us\css\docstyle.css">
<style>
.wrap {
	width: 100%;
	overflow:auto;
}

.fleft {
    float:left;
    width: 30%;
	background:#FEFAEF;
    height: 500px;
}

.fright {
	float: right;
    background:white;
    height: 500px;
    width: 70%;
}

</style>
<script>


function onloadclickMe(element) {
	var debtAccNum = element;
	document.getElementById('if').src="/TWC/CustomForms/TWC_Specific/loadImages.jsp?debtAccNum="+debtAccNum;
}

function clickMe(element) {
	var debtAccNum = element.innerHTML;
	document.getElementById('if').src="/TWC/CustomForms/TWC_Specific/loadImages.jsp?debtAccNum="+debtAccNum;
}
</script>

</head>
<body onUnload="deleteImageFromServer ('<%=filePath%>','<%=debt_acc_numArrForJs%>');" onload = "onloadclickMe('<%=onloadacc%>');">

<input type="hidden" id="wsname_sign" value="<%=wsname%>">

<div class="wrap">
    <div class="fleft">
		<%	out.print(html.toString()); %>
	</div>
    <div class="fright">
		<iframe class= 'EWNormalGreenGeneral1' name='if' id="if"  width="550" height="500"></iframe>
	</div>
	<div class="wrap">
	
	    <%if(wsname.equalsIgnoreCase("CROPS_Disbursal_Maker") || wsname.equalsIgnoreCase("CROPS_Disbursal_Checker") || wsname.equalsIgnoreCase("CROPS_Deferral_Maker") || wsname.equalsIgnoreCase("CROPS_Deferral_Checker"))
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

<script>

//**********************************************************************************//

//          NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group                               :  Application Projects
//Project                             :  Rakbank - Telegrahic Transfer           
//Date Modified                       :  15/01/2015     
//Author                              :  Mandeep
//Description                		  :  This function sets the sign_matched value to the parent window 

//***********************************************************************************//	
//Modified sendValues function on 12092018 by siva
function sendValues(status) {
	
	if (status=='Ok')
	{
		var wsname=document.getElementById('wsname_sign').value;
		window.opener.setSignMatchValues(wsname,'Yes');
	}
	else if (status=='Cancel')
	{
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