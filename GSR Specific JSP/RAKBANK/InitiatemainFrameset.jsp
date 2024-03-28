<!------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Initiation 
//File Name					 : InitiatemainFrameset.jsp
//Author                     : Manish K. Agrawal
// Date written (DD/MM/YYYY) : 16-Oct-2006
//Description                : Contains frames for ProcessLiasting/initiate_top/Initiate_center/Initiate_bottom.
//---------------------------------------------------------------------------------------------------->


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
<TITLE> RAKBANK--Service Request Initiation Module</TITLE>
</HEAD>

<%
	String strParams=request.getQueryString();
//	String WI_Nmae=request.getParameter("winame");
//	String RPC_Flag=request.getParameter("RPCFlag");

%>

<!--<FRAMESET ROWS="240,*,7%" framespacing=0 border=0>
	<FRAME SRC="Initiate_Top.jsp?<%=strParams%>" NAME="frmData" frameborder=no scrolling="no" noresize>	
	<FRAME SRC="" NAME="frameProcess" frameborder=no noresize scrolling="yes" noresize>	
	<FRAME SRC="" NAME="frameClose" frameborder=no noresize scrolling="no">	
</FRAMESET>
-->

<script language="javascript">

	window.parent.top.resizeTo(window.screen.availWidth,window.screen.availHeight);
	window.parent.top.moveTo(0,0);
</script>

<FRAMESET COLS="20%,80%" framespacing=0 border=0 >
	<FRAME SRC="ProcessListing.jsp" NAME="frmProcessList"  scrolling="yes" >	
	<FRAMESET ROWS="200,*,5%" framespacing=0 border=0 >
		<FRAME SRC="blank_withLogo.jsp" NAME="frmData" frameborder=no scrolling="no"  >	
		<FRAME SRC="blank.jsp" NAME="frameProcess" frameborder=no  scrolling="yes" >	
		<FRAME SRC="blank.jsp" NAME="frameClose" frameborder=no  scrolling="no">	
	</FRAMESET>
</FRAMESET>
	
</html>