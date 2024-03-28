<!--------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group						 : Application –Projects
//Product / Project			 : RAKBank 
//Module                     : Request-Screen Data Update
//File Name					 : AO.jsp          
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 2-Feb-2015
//Description                : File to insert/update data in Transaction table
//---------------------------------------------------------------------------------------------------->
<%@ include file="Log.process"%>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import="com.newgen.wfdesktop.util.xmlapi.*" %>
<%@ page import="com.newgen.custom.*" %>
<%@ page import="javax.crypto.Cipher" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="java.io.UnsupportedEncodingException" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>


<%@ page import="java.math.*"%>
<%@ page import="com.newgen.wfdesktop.exception.*" %>
<%@ page import="com.newgen.mvcbeans.model.*,com.newgen.mvcbeans.controller.workdesk.*"%>
<%@ page import="com.newgen.omni.wf.util.app.*"%>
<%@ page import="com.newgen.omni.wf.util.excp.*"%>
<%@ page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@ page import="com.newgen.omni.wf.util.excp.NGException"%>

<!---<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>--->
<jsp:useBean id="wDSession" class="com.newgen.wfdesktop.session.WDSession" scope="session"/>

<%@ include file="SaveHistory.jsp"%>

<HTML>
<HEAD>
<script type="text/javascript">

</script>
</HEAD>


<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' alink='blue' link='#990033' vlink='#990033' >
<style>
			@import url("/webdesktop/webtop/en_us/css/docstyle.css");
</style>
<!--<link rel="stylesheet" type="text/css" href = "\webdesktop\webtop\en_us\css\docstyle.css">-->


</BODY>
</HTML>