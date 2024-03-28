<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         	 : Application �Projects
//Product / Project	     	 : RAKBank 
//Module                 	 : Update Request
//Author                     : Amandeep
// Date written (DD/MM/YYYY) : 10-Feb-2011
//Description                : for print functionality.
//------------------------------------------------------------------------------------------------------------------------------------>
<%@ include file="Log.process"%>
<%@ page language="java" %>
<%@ page import="java.text.*,java.util.*,java.lang.*,com.newgen.wfdesktop.session.WFSession" %>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ page import= "java.io.*"%>
<%@ page import= "java.util.*"%>
<%@ page import= "java.sql.*"%> 
<%@ page import="java.text.*"%>
<%@ page import= "java.util.Properties" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>

<%@ page import="org.owasp.esapi.ESAPI"%>
<%@ page import="org.owasp.esapi.codecs.OracleCodec"%>
<%@ page import="org.owasp.esapi.User" %>


<!-- esapi4js i18n resources -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/i18n/ESAPI_Standard_en_US.properties.js"></script>
<!-- esapi4js configuration -->
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/esapi-compressed.js"></script>
<script type="text/javascript" language="JavaScript" src="${pageContext.request.contextPath}/CustomForms/esapi4js/resources/Base.esapi.properties.js"></script>
<!-- esapi4js core -->
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>
<head>
<head>

	<link href="/webdesktop/webtop/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>

<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat"%>

<style type="text/css">
td {font-size: 80%;}
</style>
<%
    Calendar c = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MMM/yyyy hh:mm:ss"); 
	String CurrDate=dateFormat.format(c.getTime()); 
	
	String input1 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("wi_name", request.getParameter("wi_name"), 1000, true) );
	String wi_name = ESAPI.encoder().encodeForSQL(new OracleCodec(), input1!=null?input1:"");
	WriteLog("Integration jsp: wi_name: "+wi_name);
	WriteLog("Integration jsp: wi_name 1: "+request.getParameter("wi_name"));
	
	String input2 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("IntroductionDateTime", request.getParameter("IntroductionDateTime"), 1000, true) );
	String IntroductionDateTime = ESAPI.encoder().encodeForSQL(new OracleCodec(), input2!=null?input2:"");
	WriteLog("Integration jsp: wi_name: "+IntroductionDateTime);
	
	String input3 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BU_UserName", request.getParameter("BU_UserName"), 1000, true) );
	String BU_UserName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input3!=null?input3:"");
	WriteLog("Integration jsp: BU_UserName: "+BU_UserName);
	
	String input4 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_DebitCN", request.getParameter("DCI_DebitCN"), 1000, true) );
	String DCI_DebitCN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input4!=null?input4:"");
	WriteLog("Integration jsp: DCI_DebitCN: "+DCI_DebitCN);
	
	String input5 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_ExpD", request.getParameter("DCI_ExpD"), 1000, true) );
	String DCI_ExpD = ESAPI.encoder().encodeForSQL(new OracleCodec(), input5!=null?input5:"");
	WriteLog("Integration jsp: DCI_ExpD: "+DCI_ExpD);
	
	String input6 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_CName", request.getParameter("DCI_CName"), 1000, true) );
	String DCI_CName = ESAPI.encoder().encodeForSQL(new OracleCodec(), input6!=null?input6:"");
	WriteLog("Integration jsp: DCI_CName: "+DCI_CName);
	
	String input7 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_CT", request.getParameter("DCI_CT"), 1000, true) );
	String DCI_CT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input7!=null?input7:"");
	WriteLog("Integration jsp: DCI_CT: "+DCI_CT);
	
	String input8 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_MONO", request.getParameter("DCI_MONO"), 1000, true) );
	String DCI_MONO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input8!=null?input8:"");
	WriteLog("Integration jsp: DCI_MONO: "+DCI_MONO);
	
	String input9 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_CAPS_GENSTAT", request.getParameter("DCI_CAPS_GENSTAT"), 1000, true) );
	String DCI_CAPS_GENSTAT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input9!=null?input9:"");
	WriteLog("Integration jsp: DCI_CAPS_GENSTAT: "+DCI_CAPS_GENSTAT);
	
	String input10 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_ELITECUSTNO", request.getParameter("DCI_ELITECUSTNO"), 1000, true) );
	String DCI_ELITECUSTNO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input10!=null?input10:"");
	WriteLog("Integration jsp: DCI_ELITECUSTNO: "+DCI_ELITECUSTNO);
	
	String input11 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("DCI_ExtNo", request.getParameter("DCI_ExtNo"), 1000, true) );
	String DCI_ExtNo = ESAPI.encoder().encodeForSQL(new OracleCodec(), input11!=null?input11:"");
	WriteLog("Integration jsp: DCI_ExtNo: "+DCI_ExtNo);
	
	String input12 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_TINCheck", request.getParameter("VD_TINCheck"), 1000, true) );
	String VD_TINCheck = ESAPI.encoder().encodeForSQL(new OracleCodec(), input12!=null?input12:"");
	WriteLog("Integration jsp: VD_TINCheck: "+VD_TINCheck);
	
	String input13 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_MoMaidN", request.getParameter("VD_MoMaidN"), 1000, true) );
	String VD_MoMaidN = ESAPI.encoder().encodeForSQL(new OracleCodec(), input13!=null?input13:"");
	WriteLog("Integration jsp: VD_MoMaidN: "+VD_MoMaidN);
	
	String input14 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_POBox", request.getParameter("VD_POBox"), 1000, true) );
	String VD_POBox = ESAPI.encoder().encodeForSQL(new OracleCodec(), input14!=null?input14:"");
	WriteLog("Integration jsp: VD_POBox: "+VD_POBox);
	
	String input15 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_Oth", request.getParameter("VD_Oth"), 1000, true) );
	String VD_Oth = ESAPI.encoder().encodeForSQL(new OracleCodec(), input15!=null?input15:"");
	WriteLog("Integration jsp: VD_Oth: "+VD_Oth);
	
	String input16 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_MRT", request.getParameter("VD_MRT"), 1000, true) );
	String VD_MRT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input16!=null?input16:"");
	WriteLog("Integration jsp: VD_MRT: "+VD_MRT);
	
	String input17 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_StaffId", request.getParameter("VD_StaffId"), 1000, true) );
	String VD_StaffId = ESAPI.encoder().encodeForSQL(new OracleCodec(), input17!=null?input17:"");
	WriteLog("Integration jsp: VD_StaffId: "+VD_StaffId);
	
	String input18 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_EDC", request.getParameter("VD_EDC"), 1000, true) );
	String VD_EDC = ESAPI.encoder().encodeForSQL(new OracleCodec(), input18!=null?input18:"");
	WriteLog("Integration jsp: VD_EDC: "+VD_EDC);
	
	String input19 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_TELNO", request.getParameter("VD_TELNO"), 1000, true) );
	String VD_TELNO = ESAPI.encoder().encodeForSQL(new OracleCodec(), input19!=null?input19:"");
	WriteLog("Integration jsp: VD_TELNO: "+VD_TELNO);
	
	String input20 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("VD_DOB", request.getParameter("VD_DOB"), 1000, true) );
	String VD_DOB = ESAPI.encoder().encodeForSQL(new OracleCodec(), input20!=null?input20:"");
	WriteLog("Integration jsp: VD_DOB: "+VD_DOB);
	
	String input21 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("CASHBACK_TYPE", request.getParameter("CASHBACK_TYPE"), 1000, true) );
	String CASHBACK_TYPE = ESAPI.encoder().encodeForSQL(new OracleCodec(), input21!=null?input21:"");
	WriteLog("Integration jsp: CASHBACK_TYPE: "+CASHBACK_TYPE);
	
	String input22 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("AMOUNT", request.getParameter("AMOUNT"), 1000, true) );
	String AMOUNT = ESAPI.encoder().encodeForSQL(new OracleCodec(), input22!=null?input22:"");
	WriteLog("Integration jsp: AMOUNT: "+AMOUNT);
	
	String input23 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("REMARKS", request.getParameter("REMARKS"), 1000, true) );
	String REMARKS = ESAPI.encoder().encodeForSQL(new OracleCodec(), input23!=null?input23:"");
	WriteLog("Integration jsp: REMARKS: "+REMARKS);
	
	String input24 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("BR_Remarks", request.getParameter("BR_Remarks"), 1000, true) );
	String BR_Remarks = ESAPI.encoder().encodeForSQL(new OracleCodec(), input24!=null?input24:"");
	WriteLog("Integration jsp: BR_Remarks: "+BR_Remarks);
	
	String input25 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Cards_Remarks", request.getParameter("Cards_Remarks"), 1000, true) );
	String Cards_Remarks = ESAPI.encoder().encodeForSQL(new OracleCodec(), input25!=null?input25:"");
	WriteLog("Integration jsp: Cards_Remarks: "+Cards_Remarks);
	
	String input26 = ESAPI.encoder().encodeForHTML( ESAPI.validator().getValidSafeHTML("Cards_Decision", request.getParameter("Cards_Decision"), 1000, true) );
	String Cards_Decision = ESAPI.encoder().encodeForSQL(new OracleCodec(), input26!=null?input26:"");
	WriteLog("Integration jsp: Cards_Decision: "+Cards_Decision);
	
	
	String wi_name=wi_name;	
	String DateTime="";

	try
	{
		String query="select convert(varchar,entrydatetime,120) as entrydatetime  from queueview where processname=:processname and activityname=:activityname and processinstanceid=:processinstanceid";
		String params ="processname==DSR_CBR"+"~~"+"activityname==cards"+"~~"+"processinstanceid=="+wi_name;
		String sInputXML=	"<?xml version=\"1.0\"?><APSelectWithNamedParam_Input><Option>APSelectWithNamedParam</Option><Query>" + query +"</Query><Params>"+params+"</Params><EngineName>"+ wfsession.getEngineName() + "</EngineName><SessionId>"+wfsession.getSessionId()+"</SessionId></APSelectWithNamedParam_Input>";
		WriteLog("Input XML :"+sInputXML);
		String sOutputXML= WFCallBroker.execute(sInputXML,wfsession.getJtsIp(),wfsession.getJtsPort(),1);
		WriteLog("Output XML :"+sOutputXML);
		String GroupIndex = sOutputXML.substring(sOutputXML.indexOf("<entrydatetime>")+15,sOutputXML.indexOf("</entrydatetime>"));
		DateTime="'"+GroupIndex+"'";
		WriteLog(DateTime);
	}
	catch(Exception e)
	{
	}
%>


<script>

function load()
{
	
}

</script>
</head>
<body lang=EN-US onload="window.print();">

<BODY topmargin=0 leftmargin=15 class='EWGeneralRB' onload="load()" >
<table id=tbl width="100%"   cellpadding=0 cellspacing=0>
	<tr width="100%">
		<td colspan=5 align=right width="90%" >
			&nbsp;
		</td>
		<td colspan=1 align=left width="10%" >
			<img src='\webdesktop\webtop\images\rak-logo.gif'>
		</td>
	</tr>
</table>
<form name="dataform">

<script language="javascript" src="/webdesktop/webtop/en_us/scripts/DSR_RBCommon.js"></script>
<br>
	<table border="0" cellspacing="1" cellpadding="1" width=100% >
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="IntroductionDateTime">Introduction Date & Time:</td>
			<td nowrap  width="800" colspan=1><%=IntroductionDateTime==null?"":IntroductionDateTime%></td>
		</tr>
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="BU_UserName">Introduced By:</td>
			<td nowrap  width="800" colspan=1><%=BU_UserName==null?"":BU_UserName%></td>
		</tr>
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="BA_UserName">Approval Date Time: </td>
			<td nowrap  width="800" colspan=1><%=DateTime%></td>
		</tr>
	</table>

	<table border="0" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
			<td  colspan=4 align=center ><b>Request Type: Cash Back Request</b></td>
		</tr>
	</table>
	<table border="1" cellspacing="1" cellpadding="1" width=100% >
		<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Debit Card Information &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Registration No: <%=wi_name%></b></td>
		</tr>
	</table>
	<table>
		<TR>
			<td nowrap width="100" height="16" class="RBPrint" colspan=1 id="DCI_DebitCN">Debit Card No:</td>
			<td nowrap  width="200" colspan=1><%=DCI_DebitCN==null?"":DCI_DebitCN%></td>
			<td nowrap  height="16" class="RBPrint" id="DCI_CName">Customer Name:</td>
			<td nowrap  width="150"><%=DCI_CName==null?"":DCI_CName%></td>
		</tr> 
		<TR>
			<td nowrap width="190" height="16" class="RBPrint" id="DCI_ExpD">Expiry Date:</td>
			<td nowrap width="190"><%=DCI_ExpD==null?"":DCI_ExpD%></td>
			<td nowrap width="100" height="16" class="RBPrint" id="DCI_CT">Card Type:</td>
			<td nowrap width="180"><%=DCI_CT==null?"":DCI_CT%></td> 
		</tr>
		<TR>
			<td nowrap width="170" height="16" class="RBPrint" id="DCI_MONO">Mobile No:</td>
			<td nowrap width="190"><%=DCI_MONO==null?"":DCI_MONO%></td>
			<td nowrap width="100" height="16" class="RBPrint" id="DCI_CAPS_GENSTAT">General Status:</td>
			<td nowrap width="180"><%=DCI_CAPS_GENSTAT==null?"":DCI_CAPS_GENSTAT%></td> 
		</tr>
		<TR>
			<td nowrap width="170" height="16" class="RBPrint" id="DCI_ELITECUSTNO">Master No:</td>
			<td nowrap width="190"><%=DCI_ELITECUSTNO==null?"":DCI_ELITECUSTNO%></td>
			<td nowrap width="155" height="16" class="RBPrint" id="DCI_ExtNo">Ext No.:</td> 
			<td nowrap  width="190"><%=DCI_ExtNo==null?"":DCI_ExtNo%></td>
		</tr>	
	</table>


<table border="1" cellspacing="1" cellpadding="1" width=100% >
		
	<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Verification Details</b></td>
	</tr>
</table>
<table>
	<TR>

	<%if(VD_TINCheck.equalsIgnoreCase("true")){ %>
        <td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4>&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;TIN Check</td>
		<% } else {%>
		<td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4><input type="checkbox" name="VD_TINCheck" style='width:25px;' disabled>&nbsp;TIN Check</td>
		<%}%>
	</tr>
	<TR>
	<%if(VD_MoMaidN.equalsIgnoreCase("true")){ %>
        <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;Any 4 of the following RANDOM Questions</td>
		<% } else {%>
		 <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" name="VD_MoMaidN"  style='width:25px;'  disabled>&nbsp;Any 4 of the following RANDOM Questions</td>
	<%}%>
	</TR>
	<TR>
		<tr>
		<%if(VD_POBox.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_POBox">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P.O Box</td>
		<% } else {%>
		<td class="RBPrint" nowrap width=50% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;'   disabled >&nbsp;&nbsp;P.O Box</td>
			<%}%>
		<%if(VD_Oth.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_Oth">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mother's Maiden name</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=50% id="C_VD_Oth"><input type="checkbox" name="VD_Oth" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Mother's Maiden name</td>
				<%}%>
		</tr>
		<tr>
		<%if(VD_MRT.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_MRT">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=50% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;'  disabled >&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
				<%}%>
		<%if(VD_StaffId.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_StaffId">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Staff ID No./Military ID No.</td>
          <% } else {%>
		  <td class="RBPrint" nowrap width=50% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Staff ID No./Military ID No.</td>
		  <%}%>

		</tr>
		<tr>
		<%if(VD_EDC.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_EDC">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiry date Of Your Card</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=50% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Expiry date Of Your Card</td>
					  <%}%>
		<%if(VD_TELNO.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=50% id="C_VD_TELNO">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=50% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;'
	  disabled>&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			 <%}%>
	    </tr>
		<tr>
			<%if(VD_DOB.equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=100% id="C_VD_DOB">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Of Birth</td>
		 <% } else {%>
		 <td class="RBPrint" nowrap width=100% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Date Of Birth</td>
		 	 <%}%>



        </tr>
		</TR>
</table>
<table border="1" cellspacing="1" cellpadding="1" width=100% >
	  <tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>CBR (Cash Back Request) Details </b></td>
	 </tr>
 </table>
 <table>

	<TR>
        <td nowrap width="140" height="16" class="RBPrint"  id="CASHBACK_TYPE">Type:</td>
        <td nowrap  width="180"><%=CASHBACK_TYPE==null?"":CASHBACK_TYPE%>
		</td>
		<td nowrap width="100" height="16" class="RBPrint" id="AMOUNT">Amount: </td>
        <td nowrap width="180"><%=AMOUNT==null?"":AMOUNT%>
		</td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>
	    <td nowrap  valign="top" width="140" height="16" class="RBPrint" id="REMARKS">Work Introduction Remarks/ Reason:</td>
        <td nowrap  width="180"><%=REMARKS==null?"":REMARKS.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
        </tr>
	<TR>
	<TR>
	    <td nowrap  valign="top" width="140" height="16" class="RBPrint" id="BR_Remarks">Branch Return Remarks/ Reason:</td>
        <td nowrap  width="180"><%=BR_Remarks==null?"":BR_Remarks.replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
        </tr>
	<TR>
 </table>
 <%

String Cards_Rem = Cards_Remarks;
Cards_Rem=Cards_Rem.replace("ampersand","&");
Cards_Rem=Cards_Rem.replace("equalsopt","=");
Cards_Rem=Cards_Rem.replace("percentageopt","%");
String cardDecision = Cards_Decision;
if ((Cards_Rem.equals("")) && (cardDecision.equals("")))
{}
else
{
out.print("<table border=\"1\" cellspacing=\"1\" cellpadding=\"1\" width=100% >");
out.print("<tr  border=\"1\" width=100% >");
out.print("<td colspan=4 align=center class=\"RBPrint\"><b>CARDS Details</b></td>");
out.print("</tr>");
out.print("</table>");
String cardDecTemp = new String();
if(cardDecision.equals("CARDS_E"))
{cardDecTemp="Complete";}
else if(cardDecision.equals("CARDS_BR"))
{cardDecTemp="Re-Submit to Branch";}
else if(cardDecision.equals("CARDS_UP"))
{cardDecTemp="Under Process";}
else if(cardDecision.equals("CARDS_D"))
{cardDecTemp="Discard";}

out.print("<table>");
out.print("<TR>");
out.print("<td nowrap width=\"140\" height=\"16\" class=\"RBPrint\"  id=\"CardsDecision\">Decision:</td>");
out.print("<td nowrap width=\"180\" >");
out.print(cardDecTemp);
out.print("</td>");
out.print("</tr>");
out.print("<tr>");
out.print("<td valign=\"top\" nowrap width=\"140\" height=\"16\" class=\"RBPrint\" id=\"Cards_Remarks\">Remarks/ Reason:</td>");
out.print("<td wrap width=\"800\" align=\"left\" class=\"RBPrint\">");
out.print(Cards_Rem);
out.print("</td>");
out.print("</TR>");
out.print("</table>");
}	
%>

&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <br><font size="-1">"This is a Computer Generated Document, therefore needs no signature"</font>
<br>
<br>
<br>
<br>
<table border="0" cellspacing="1" cellpadding="1" width=100% >
	  <tr class="" width=100% class="">
			<td  colspan=4 align="right" class="">------------------------</td>
	  </tr>
	  	 <tr class="" width=100% class="">
			<td  colspan=4 align="right" class=""><%=wfsession.getUserName()%></td>

	 </tr>
	 <tr class="" width=100% class="">
			<td  colspan=4 align="right" class=""><%=CurrDate %></td>

	 </tr>
	 </table>
<body topmargin=0 leftmargin=15 class='EWGeneralRB'>
</form>
</body>
<br>
<br>
</form>

<form name="printform" action="../DSRProcessSpecific/Print.jsp"  target="_blank">
</form>
</body>