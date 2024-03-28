<%@page contentType="text/html"%>

<%@ page isThreadSafe = "false" isErrorPage="true"%>

<script>
    document.oncontextmenu = new Function ("return false");
</script>
<%
    String logoName ="test.jpg";
    String winName="";
    winName = request.getParameter("wnwd");         
	String strError= null;
	String source  ="";
	String strMainCode="", strErrorCode = "";
	strMainCode=(request.getParameter("maincode")==null)?"":request.getParameter("maincode"); 
    String strEncoding = "";
    String name="",errCode="";
         
	strEncoding = "UTF-8";
	request.setCharacterEncoding(strEncoding);
	response.setContentType("text/html;charset="+strEncoding);

	response.setHeader("Cache-Control","no-store"); //HTTP 1.1
	response.setHeader("Pragma","no-cache"); //HTTP 1.0
	response.setDateHeader ("Expires", 0); //prevents caching at the proxy server

	try
	{
		String maincode =request.getParameter("maincode");
		maincode=(maincode==null)?"":maincode;
		String suberror ="";
		if(maincode.equals("4021"))
		{
			strError="An invalid request is made.";
		}
		else{
			strError = "This operation could not be done because of some error at the server end !!!"; 
		}
	}
	catch(NullPointerException nex) 
	{
		strError = "This operation could not be done because of some error at the server end !!!"; 
	}		
	
%>
<html dir='ltr'>
	<head>
	<title>Error</title>
	<meta HTTP-EQUIV="content-type" CONTENT="text/html;charset=UTF-8">
	<link href="CU/webtop/en_us/css/fixwidth.css" rel="stylesheet" type="text/css"/>
	 </head>
	<body marginheight="0" marginwidth="0" topmargin="0" leftmargin="0" >
		<table width=100% border="0" cellspacing="0" cellpadding="0" style="margin-top:0px;">			
			<tr> 
				<td width="100%" background="CU/webtop/images/white_u.gif" >
					<br>
					<table border="0" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td align="right"  width="100%"><img src="CU/webtop/images/<%=logoName%>" title="OmniFlow Web Client"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td width="100%"><hr  >
							</td>
						</tr>
						<tr>
							<td width="90%">
							</td>
						</tr>
					</table>					
					<p align="center" class="EWLabel3">
						<br>&nbsp; <br>
						This operation could not be done because of following error at the server end !!!<small><small><br>
					</small></small>Please try after some time. If the problem persists, contact your Administrator.&nbsp;&nbsp;</p>
					
					<p>&nbsp;</p>
					<p class="EWErrorMessage"><%=strError%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					</p>
					
				</td>
			</tr>
		</table>
	</body>
</html>		