 <!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application �Projects
//Product / Project	     : RAKBank 
//Module                 : Update Request
//Author                     : Lalit Kumar
// Date written (DD/MM/YYYY) : 6-Mar-2008
//Description                : for print functionality.
//------------------------------------------------------------------------------------------------------------------------------------>

<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat"%>
<%@ include file="Log.process"%>

<jsp:useBean id="customSession" class="com.newgen.custom.wfdesktop.session.WFCustomSession" scope="session"/>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<head>
<head>

	<link href="/DSR_DCB/components/viewer/resources/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>

<%@ page import="java.io.*,java.util.*,java.text.SimpleDateFormat"%>

<style type="text/css">
td {font-size: 80%;}
</style>
<%
    Calendar c = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MMM/yyyy hh:mm:ss"); 
	String CurrDate=dateFormat.format(c.getTime());

	
%>


<script>


function load()
{
	//alert("Print Loaded");
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
			<img src='\DSR_DCB\components\viewer\resources\images\rak-logo.gif'>
		</td>
	</tr>
</table>
<form name="dataform">

<script language="javascript" src="/DSR_DCB/DSR_DCB/CustomJS/DSR_RBCommon.js"></script>
<br>
<table border="0" cellspacing="1" cellpadding="1" width=100% >
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="IntroductionDateTime">Introduction Date & Time:</td>
			<td nowrap  width="800" colspan=1><%=request.getParameter("IntroductionDateTime")==null?"":request.getParameter("IntroductionDateTime")%></td>
		</tr>
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="BU_UserName">Introduced By:</td>
			<td nowrap  width="800" colspan=1><%=request.getParameter("BU_UserName")==null?"":request.getParameter("BU_UserName")%></td>
		</tr>
</table>

<table border="0" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
			<td  colspan=4 align=center ><b>Request Type: Other Debit Card Requests   </b></td>
		</tr>
</table>

<table border="1" cellspacing="1" cellpadding="1" width=100% >

		<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Debit Card Information &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Registration No: <%=request.getParameter("wi_name")%></b></td>
		</tr>
</table>
<table>
		<TR>
			<td nowrap width="100" height="16" class="RBPrint" colspan=1 id="DCI_DebitCN">Debit Card No:</td>
			<td nowrap  width="200" colspan=1><%=request.getParameter("cardNoClearTxt")==null?"":request.getParameter("cardNoClearTxt")%></td>
			<td nowrap  height="16" class="RBPrint" id="DCI_CName">Customer Name:</td>
			<td nowrap  width="150"><%=request.getParameter("DCI_CName")==null?"":request.getParameter("DCI_CName")%></td>
		</tr> 
		<TR>
			<td nowrap width="190" height="16" class="RBPrint" id="DCI_ExpD">Expiry Date:</td>
			<td nowrap width="190"><%=request.getParameter("DCI_ExpD")==null?"":request.getParameter("DCI_ExpD")%></td>
			<td nowrap width="100" height="16" class="RBPrint" id="DCI_CT">Card Type:</td>
			<td nowrap width="180"><%=request.getParameter("DCI_CT")==null?"":request.getParameter("DCI_CT")%></td> 
		</tr>
		<TR>
	    <td nowrap width="170" height="16" class="RBPrint" id="DCI_MONO">Mobile No:</td>
        <td nowrap width="190"><%=request.getParameter("mobNoClearTxt")==null?"":request.getParameter("mobNoClearTxt")%></td>
			<td nowrap width="100" height="16" class="RBPrint" id="DCI_CAPS_GENSTAT">General Status:</td>
			<td nowrap width="180"><%=request.getParameter("DCI_CAPS_GENSTAT")==null?"":request.getParameter("DCI_CAPS_GENSTAT")%></td> 
			</tr>
			<TR>
	     <td nowrap width="170" height="16" class="RBPrint" id="DCI_ELITECUSTNO">Master No:</td>
        <td nowrap width="190"><%=request.getParameter("DCI_ELITECUSTNO")==null?"":request.getParameter("DCI_ELITECUSTNO")%></td>
		<!--<td nowrap width="155" height="16" class="RBPrint" id="DCI_ADCInc">Accessed Income:</td>
        <td nowrap  width="150"><%=request.getParameter("DCI_ADCInc")==null?"":request.getParameter("DCI_ADCInc")%></td>
		</tr>
		<TR>-->
	    <td nowrap width="155" height="16" class="RBPrint" id="DCI_ExtNo">Ext No.:</td> 
        <td nowrap  width="190"><%=request.getParameter("DCI_ExtNo")==null?"":request.getParameter("DCI_ExtNo")%></td>
		<!--<td nowrap width="155" height="16" class="RBPrint" id="DCI_CCRNNo">Card CRN No:</td>
        <td nowrap  width="150"><%=request.getParameter("DCI_CCRNNo")==null?"":request.getParameter("DCI_CCRNNo")%></td>
		-->
		</tr>	
	</table>


<table border="1" cellspacing="1" cellpadding="1" width=100% >
		
	<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Verification Details</b></td>
	</tr>
</table>
<table>
	<TR>
<!-- 
	Product/Project :       Rak Bank
	Module          :       Debit Card Blocking Request
	File            :       PrintDCB.jsp
	Purpose         :       Heavy Check Mark Image added to print JSP of each process to make selected options in check boxes more clear
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/022					15/09/2008	 Saurabh Arora
-->
<%if(request.getParameter("VD_TINCheck").equalsIgnoreCase("Y")){ %>
        <td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4>&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;TIN Check</td>
		<% } else {%>
		<td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4><input type="checkbox" name="VD_TINCheck" style='width:25px;' disabled>&nbsp;TIN Check</td>
		<%}%>
	</tr>
	<TR>
	<%if(request.getParameter("VD_MoMaidN").equalsIgnoreCase("Y")){ %>
        <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;Any 4 of the following RANDOM Questions</td>
		<% } else {%>
		 <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" name="VD_Oth"  style='width:25px;'  disabled>&nbsp;Any 4 of the following RANDOM Questions</td>
	<%}%>
	</TR>
	<TR>
		<tr>
		<%if(request.getParameter("VD_POBox").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=53% id="C_VD_POBox">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P.O Box</td>
		<% } else {%>
		<td class="RBPrint" nowrap width=53% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;'   disabled >&nbsp;&nbsp;P.O Box</td>
			<%}%>
		<%if(request.getParameter("VD_Oth").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=47% id="C_VD_Oth">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mother's Maiden name</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=47% id="C_VD_Oth"><input type="checkbox" name="VD_MoMaidN" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Mother's Maiden name</td>
				<%}%>
		</tr>
		<tr>
		<%if(request.getParameter("VD_MRT").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_MRT">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=33% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;'  disabled >&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
				<%}%>
		<%if(request.getParameter("VD_StaffId").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_StaffId">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Staff ID No./Military ID No.</td>
          <% } else {%>
		  <td class="RBPrint" nowrap width=67% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Staff ID No./Military ID No.</td>
		  <%}%>

		</tr>
		<tr>
		<%if(request.getParameter("VD_EDC").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_EDC">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiry date Of Your Card</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Expiry date Of Your Card</td>
					  <%}%>
					  
		<%if(request.getParameter("VD_TELNO").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_TELNO">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;'
	  disabled>&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us</td>
			 <%}%>
		</tr>
		<!--<tr>
		
			<%if(request.getParameter("VD_SD").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_SD">&nbsp;<img src="\DSR_DCB\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Statement Date</td>
			 <% } else {%>
				<td class="RBPrint" nowrap width=67% id="C_VD_SD"><input type="checkbox" name="VD_SD" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Statement Date</td>
					  <%}%>
        </tr>-->
		<tr>
		
			<%if(request.getParameter("VD_DOB").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_DOB">&nbsp;<img src="\DSR_ODC\components\viewer\resources\images\heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Of Birth</td>
		 <% } else {%>
		 <td class="RBPrint" nowrap width=67% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Date Of Birth</td>
		 	 <%}%>


		</TR>
</table>
	

<% if(request.getParameter("Card_Delivery_Request").equalsIgnoreCase("Card Delivery Request")) {%>

<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Card Delivery Request</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_cdr_CDT" class="RBPrint">Card Delivery To</td>
        <td nowrap  width="150"><%=request.getParameter("oth_cdr_CDT")==null?"":request.getParameter("oth_cdr_CDT")%>
		</td>
		 <td nowrap width="100" height="16" id="C_oth_cdr_BN" class="RBPrint">Branch Name</td>
        <td nowrap width="180"><%=request.getParameter("oth_cdr_BN")==null?"":request.getParameter("oth_cdr_BN")%>
		</td>   
	</tr>	
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_cdr_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="450" colspan=3><%=request.getParameter("oth_cdr_RR")==null?"":request.getParameter("oth_cdr_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

<% } else if(request.getParameter("Transaction_Dispute").equalsIgnoreCase("Transaction Dispute")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Transaction Dispute</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" id="oth_td_RNO" height="16" class="RBPrint">Reference No.</td>
        <td nowrap  width="150"><%=request.getParameter("oth_td_RNO")==null?"":request.getParameter("oth_td_RNO")%>
		</td>
		  <td nowrap width="190" id="oth_td_Amount" height="16" class="RBPrint">Amount</td>
        <td nowrap width="190"><%=request.getParameter("oth_td_Amount")==null?"":request.getParameter("oth_td_Amount")%>
		</td>
	</tr>	
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_td_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="450" colspan=3><%=request.getParameter("oth_td_RR")==null?"":request.getParameter("oth_td_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

<% } else if(request.getParameter("Early_Card_Renewal").equalsIgnoreCase("Early Card Renewal")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Early Card Renewal (max. 3 months before the expiry date)</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_RB' class="RBPrint">Required by date </td>
        <td nowrap  width="150"><%=request.getParameter("oth_ecr_RB")==null?"":request.getParameter("oth_ecr_RB")%>
		</td>
		<td nowrap width="190" height="16" class="RBPrint" colspan=2></td>
        
	</tr>

	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_DeliverTo' class="RBPrint">Deliver to </td>
        <td nowrap  width="150"><%=request.getParameter("oth_ecr_dt")==null?"":request.getParameter("oth_ecr_dt")%>
		</td>
		<td nowrap width="190" height="16" class="RBPrint" colspan=2></td>
        
	</tr>


<%
	String Branch_Name = request.getParameter("oth_ecr_bn");

	if (Branch_Name.equals(""))
	{}
	else
	{
	out.print("<TR><td nowrap width=\"155\" height=\"16\" class=\"RBPrint\">Branch name </td>");
	out.print("<td nowrap  width=\"150\">"+Branch_Name);
	out.print("</td><td nowrap width=\"190\" height=\"16\" class=\"RBPrint\" colspan=2></td>");
	}	
%>
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_ecr_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="450" colspan=3><%=request.getParameter("oth_ecr_RR")==null?"":request.getParameter("oth_ecr_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
 
<% } else if(request.getParameter("Card_Replacement").equalsIgnoreCase("Card Replacement")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Card Replacement</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap valign="top" width="155" height="16" id='oth_cr_reason' class="RBPrint">Reason</td>
        <td nowrap  width="250"><%=request.getParameter("oth_cr_reason")==null?"":request.getParameter("oth_cr_reason")%>
		</td>
		  <td nowrap width="190" height="16" id="oth_cr_OPS" class="RBPrint">Others Pls Specify</td>
        <td nowrap width="190"><%=request.getParameter("oth_cr_OPS")==null?"":request.getParameter("oth_cr_OPS")%>
		</td>
	</tr>


	<TR>
        <td nowrap width="155" height="16" id="oth_cr_DC" class="RBPrint">Delivery Channel</td>
        <td nowrap  width="150"><%=request.getParameter("oth_cr_DC")==null?"":request.getParameter("oth_cr_DC")%>
		</td>
		  <td nowrap width="100" id="oth_cr_BN" height="16" class="RBPrint">Branch Name</td>
        <td nowrap width="180"><%=request.getParameter("oth_cr_BN")==null?"":request.getParameter("oth_cr_BN")%>
		</td>        
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap  valign="top" width="155" height="16" id="oth_cr_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="450" colspan=3><%=request.getParameter("oth_cr_RR")==null?"":request.getParameter("oth_cr_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%>
		</td>
	</tr>	
</table>



<% } else if(request.getParameter("Re_Issue_of_PIN").equalsIgnoreCase("Re-Issue of PIN")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Reissue of PIN Details</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_rip_reason" class="RBPrint">Reason</td>
        <td nowrap  width="150"><%=request.getParameter("oth_rip_reason")==null?"":request.getParameter("oth_rip_reason")%>
		</td>
		  <td nowrap width="190" height="16" id="oth_rip_DC" class="RBPrint">Delivery Channel</td>
        <td nowrap width="190"><%=request.getParameter("oth_rip_DC")==null?"":request.getParameter("oth_rip_DC")%>
		</td>
	</tr>
	<TR>
	    <td nowrap width="100" height="16" id="oth_rip_BN" class="RBPrint">Branch Name</td>
        <td nowrap width="180"><%=request.getParameter("oth_rip_BN")==null?"":request.getParameter("oth_rip_BN")%>
		</td>        
		  <td nowrap width="170" height="16" class="RBPrint" colspan=2>&nbsp;&nbsp;</td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_rip_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="450" colspan=3><%=request.getParameter("oth_rip_RR")==null?"":request.getParameter("oth_rip_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

 <%}%>
	
<br>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="BR_Remarks" class="RBPrint">Branch Return Remarks/Reasons</td>
        <td nowrap  width="450" colspan=3><%=request.getParameter("BR_Remarks")==null?"":request.getParameter("BR_Remarks").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table> 

<br>



 
<%
String Cards_Rem = request.getParameter("Cards_Remarks");
Cards_Rem=Cards_Rem.replace("ampersand","&");
Cards_Rem=Cards_Rem.replace("equalsopt","=");
Cards_Rem=Cards_Rem.replace("percentageopt","%");

String cardDecision = request.getParameter("Cards_Decision");
if ((Cards_Rem.equals("")) && (cardDecision.equals("")))
{
}
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
			<td  colspan=4 align="right" class=""><%=customSession.getUserName()%></td>

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