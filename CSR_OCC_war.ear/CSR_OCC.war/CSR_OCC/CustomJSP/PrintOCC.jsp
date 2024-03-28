<!----------------------------------------------------------------------------------------------------------------------------------
//           NEWGEN SOFTWARE TECHNOLOGIES LIMITED

//Group			         : Application –Projects
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
	<link href="/CSR_OCC/components/viewer/resources/en_us/css/docstyle.css" rel="stylesheet" type="text/css"/>

<!-- 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       PrintOCC.jsp
	Purpose         :       Style Tag added for decreasing the font size to make single print page in IE6 
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/031					15/09/2008	 Saurabh Arora
-->
<style type="text/css">
td {font-size: 80%;}
</style>
<%
    WriteLog("Inside PrintOCC.jsp :");
	Calendar c = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MMM/yyyy hh:mm:ss"); 
	String CurrDate=dateFormat.format(c.getTime());
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
			<img src='\CSR_OCC\components\viewer\resources\images\rak-logo.gif'>
		</td>
	</tr>
</table>
<form name="dataform">

<script language="javascript" src="/CSR_OCC/CSR_OCC/CustomJS/CSR_RBCommon.js"></script>
<br>
<table border="0" cellspacing="1" cellpadding="1" width=100% >
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="IntroductionDateTime">Introduction Date & Time :</td>
			<td nowrap  width="800" colspan=1><%=request.getParameter("IntroductionDateTime")==null?"":request.getParameter("IntroductionDateTime")%></td>
		</tr>
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="BU_UserName">Introduced By :</td>
			<td nowrap  width="800" colspan=1><%=request.getParameter("BU_UserName")==null?"":request.getParameter("BU_UserName")%></td>
		</tr>
</table>

<table border="0" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
			<td  colspan=4 align=center ><b>Request Type:Other Credit Card Requests  </b></td>
		</tr>
		</table>
	<table border="1" cellspacing="1" cellpadding="1" width=100% >
		<tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>Credit Card Information &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Registration No: <%=request.getParameter("wi_name")%></b></td>
		</tr>
		</table>
		<table>
		<TR>
			<td nowrap width="100" height="16" class="RBPrint" colspan=1 id="CCI_CrdtCN">Credit Card No:</td>
			<td nowrap  width="200" colspan=1><%=request.getParameter("cardNoClearTxt")==null?"":request.getParameter("cardNoClearTxt")%></td>
			<td nowrap  height="16" class="RBPrint" id="CCI_CName">Customer Name:</td>
			<td nowrap  width="150"><%=request.getParameter("CCI_CName")==null?"":request.getParameter("CCI_CName")%></td>
		</tr> 
		<TR>
			<td nowrap width="190" height="16" class="RBPrint" id="CCI_ExpD">Expiry Date:</td>
			<td nowrap width="190"><%=request.getParameter("CCI_ExpD")==null?"":request.getParameter("CCI_ExpD")%></td>
			<td nowrap width="100" height="16" class="RBPrint" id="CCI_CT">Card Type:</td>
			<td nowrap width="180"><%=request.getParameter("CCI_CT")==null?"":request.getParameter("CCI_CT")%></td> 
		</tr>
		<TR>
	    <td nowrap width="170" height="16" class="RBPrint" id="CCI_MONO">Mobile No:</td>
        <td nowrap width="190"><%=request.getParameter("mobNoClearTxt")==null?"":request.getParameter("mobNoClearTxt")%></td>
		<td nowrap width="100" height="16" class="RBPrint" id="CCI_CAPS_GENSTAT">General Status:</td>
        <td nowrap width="180"><%=request.getParameter("CCI_CAPS_GENSTAT")==null?"":request.getParameter("CCI_CAPS_GENSTAT")%></td> 
		</tr>
		<TR>
	     <td nowrap width="170" height="16" class="RBPrint" id="CCI_ELITECUSTNO">Elite Customer No:</td>
        <td nowrap width="190"><%=request.getParameter("CCI_ELITECUSTNO")==null?"":request.getParameter("CCI_ELITECUSTNO")%></td>
		<td nowrap width="155" height="16" class="RBPrint" id="CCI_AccInc">Accessed Income:</td>
        <td nowrap  width="150"><%=request.getParameter("CCI_AccInc")==null?"":request.getParameter("CCI_AccInc")%></td>
		</tr>
		<TR>
	    <td nowrap width="155" height="16" class="RBPrint" id="CCI_ExtNo">Ext No.:</td> 
        <td nowrap  width="190"><%=request.getParameter("CCI_ExtNo")==null?"":request.getParameter("CCI_ExtNo")%></td>
		<td nowrap width="155" height="16" class="RBPrint" id="CCI_CCRNNo">Card CRN No:</td>
        <td nowrap  width="150"><%=request.getParameter("CCI_CCRNNo")==null?"":request.getParameter("CCI_CCRNNo")%></td>
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
	Module          :       Other Credit Card Requests
	File            :       PrintOCC.jsp
	Purpose         :       Heavy Check Mark Image added to print JSP of each process to make selected options in check boxes more clear
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/024					15/09/2008	 Saurabh Arora
-->
	<%if(request.getParameter("VD_TINCheck").equalsIgnoreCase("true")){ %>
        <td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4>&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;TIN Check</td>
		<% } else {%>
		<td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4><input type="checkbox" name="VD_TINCheck" style='width:25px;' disabled>&nbsp;TIN Check</td>
		<%}%>
	</tr>
	<TR>
	<%if(request.getParameter("VD_MoMaidN").equalsIgnoreCase("true")){ %>
        <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;Any 4 of the following RANDOM Questions</td>
		<% } else {%>
		 <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" name="VD_MoMaidN"  style='width:25px;'  disabled>&nbsp;Any 4 of the following RANDOM Questions</td>
	<%}%>
	</TR>
	<TR>
		<tr>
		<%if(request.getParameter("VD_POBox").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=53% id="C_VD_POBox">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P.O Box</td>
		<% } else {%>
		<td class="RBPrint" nowrap width=53% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;'   disabled >&nbsp;&nbsp;P.O Box</td>
			<%}%>
		<%if(request.getParameter("VD_Oth").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=47% id="C_VD_Oth">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mother's Maiden name</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=47% id="C_VD_Oth"><input type="checkbox" name="VD_Oth" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Mother's Maiden name</td>
				<%}%>
		</tr>
		<tr>
		<%if(request.getParameter("VD_MRT").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_MRT"&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=33% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;'  disabled >&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
				<%}%>
		<%if(request.getParameter("VD_StaffId").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_StaffId">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Staff ID No./Military ID No.</td>
          <% } else {%>
		  <td class="RBPrint" nowrap width=67% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Staff ID No./Military ID No.</td>
		  <%}%>

		</tr>
		<tr>
		<%if(request.getParameter("VD_EDC").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_EDC">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiry date Of Your Card</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Expiry date Of Your Card</td>
					  <%}%>
				<%if(request.getParameter("VD_PassNo").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_PassNo">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last Payment Amt</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=67% id="C_VD_PassNo"><input type="checkbox" name="VD_PassNo" disabled style='width:25px;'  disabled>&nbsp;&nbsp;Last Payment Amt</td>
			  <%}%>

        </tr>
		<tr>
		<%if(request.getParameter("VD_NOSC").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_NOSC">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name of Supplementary Card Holder."If Any"</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_NOSC"><input type="checkbox" name="VD_NOSC" disabled style='width:25px;' disabled >&nbsp;&nbsp;Name of Supplementary Card Holder."If Any"</td>
			  <%}%>
			<%if(request.getParameter("VD_SD").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_SD">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Statement Date</td>
			 <% } else {%>
				<td class="RBPrint" nowrap width=67% id="C_VD_SD"><input type="checkbox" name="VD_SD" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Statement Date</td>
					  <%}%>
        </tr>
		<tr>
		<%if(request.getParameter("VD_TELNO").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_TELNO">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;'
	  disabled>&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us</td>
			 <%}%>
			<%if(request.getParameter("VD_DOB").equalsIgnoreCase("true")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_DOB">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Of Birth</td>
		 <% } else {%>
		 <td class="RBPrint" nowrap width=67% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Date Of Birth</td>
		 	 <%}%>



        </tr>
		</TR>

</table>
<%if(request.getParameter("Card_Upgrade").equalsIgnoreCase("Card Upgrade")){ %>

		<table border="1" cellspacing="1" cellpadding="1" width=100% >

				 <tr  border="1" width=100% >
				<td colspan=4 align=center class="RBPrint"><b>Credit card Upgrade Details</b></td>
			</tr>	
			</table>
			<table>
			<TR>	    
				<td nowrap valign="top" width="155" height="16" id="oth_cu_RR" class="RBPrint">Remarks/Reasons</td>
				<td nowrap  width="150" colspan=3><%=request.getParameter("oth_cu_RR")==null?"":request.getParameter("oth_cu_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
			</tr>	
		</table>

<% } else if(request.getParameter("Card_Delivery_Request").equalsIgnoreCase("Card Delivery Request")) {%>

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
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_cdr_RR")==null?"":request.getParameter("oth_cdr_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
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
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_td_RR")==null?"":request.getParameter("oth_td_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
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
<!-- 
	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       PrintOCC.jsp
	Purpose         :       Additional field ‘Card Delivery Option’ needs to be added at the initiation work step
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/057								 Saurabh Arora
-->
	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_DeliverTo' class="RBPrint">Deliver to </td>
        <td nowrap  width="150"><%=request.getParameter("oth_ecr_dt")==null?"":request.getParameter("oth_ecr_dt")%>
		</td>
		<td nowrap width="190" height="16" class="RBPrint" colspan=2></td>
        
	</tr>

<!-- 	<TR>
        <td nowrap width="155" height="16" id='oth_ecr_BranchName' class="RBPrint">Branch name </td>
        <td nowrap  width="150"><%=request.getParameter("oth_ecr_bn")==null?"":request.getParameter("oth_ecr_bn")%>
		</td>
		<td nowrap width="190" height="16" class="RBPrint" colspan=2></td>
        
	</tr>	 -->
<%
	String Branch_Name = request.getParameter("oth_ecr_bn");
	WriteLog("Branch_Name :"+Branch_Name);
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
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_ecr_RR")==null?"":request.getParameter("oth_ecr_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(request.getParameter("Credit_Shield").equalsIgnoreCase("Credit Shield")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=5 align=center class="RBPrint"><b>Credit Shield</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="150" height="16" id="oth_cs_CS" class="RBPrint">Credit Shield</td>
        <td nowrap  width="270"><%=request.getParameter("oth_cs_CS")==null?"":request.getParameter("oth_cs_CS")%>
		</td>
		<%if(request.getParameter("oth_cs_CSR").equalsIgnoreCase("true")){ %>
		  <td nowrap width="180" height="16" id="oth_cs_CSR" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp; Credit Shield Reversal</td>
		  <% } else {%>
			<td nowrap width="180" height="16" id="oth_cs_CSR" class="RBPrint"><input type="checkbox" name="oth_cs_CSR" style='width:25px;' disabled > Credit Shield Reversal</td>
			<%}%>
			</tr>
			<tr>
  		  <td nowrap width="90" height="16" id="oth_cs_Amount" class="RBPrint">Amount</td> 
        <td nowrap width="190"><%=request.getParameter("oth_cs_Amount")==null?"":request.getParameter("oth_cs_Amount")%>
		</td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_cs_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=4><%=request.getParameter("oth_cs_RR")==null?"":request.getParameter("oth_cs_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
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
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_cr_RR")==null?"":request.getParameter("oth_cr_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%>
		</td>
	</tr>	
</table>
<% } else if(request.getParameter("Credit_Limit_Increase").equalsIgnoreCase("Credit Limit Increase")) {%>
 <table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Credit Limit Increase</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_cli_type" class="RBPrint">Type</td>
        <td nowrap  width="150"><%=request.getParameter("oth_cli_type")==null?"":request.getParameter("oth_cli_type")%>
		</td>
		  <td nowrap width="190" height="16" id="oth_cli_months" class="RBPrint">Months</td>
     	<td><%=request.getParameter("oth_cli_months")==null?"":request.getParameter("oth_cli_months")%></td>
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap  valign="top" width="155" height="16" id="oth_cli_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_cli_RR")==null?"":request.getParameter("oth_cli_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(request.getParameter("Change_in_Standing_Instructions").equalsIgnoreCase("Change in Standing Instructions")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=5 align=center class="RBPrint"><b>Change in Standing Instructions</b></td>
	</tr>
	</table>
	<table>
	<TR>
		<%if(request.getParameter("oth_csi_PH").equalsIgnoreCase("true")){ %>
        <td nowrap width="215" height="16" id="oth_csi_PH" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Place Hold </td>
		 <% } else {%>
			<td nowrap width="215" height="16" id="oth_csi_PH" class="RBPrint"><input type="checkbox" name="oth_csi_PH" style='width:25px;' disabled >Place Hold </td>
			<%}%>

        <td nowrap  width="150" id="oth_csi_TOH" class="RBPrint">Type of Hold</td>
		  <td><%=request.getParameter("oth_csi_TOH")==null?"":request.getParameter("oth_csi_TOH")%>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>
		<td nowrap width="150" class="RBPrint" id="oth_csi_NOM">No. of Months </td>
		<td><%=request.getParameter("oth_csi_NOM")==null?"":request.getParameter("oth_csi_NOM")%>
		</td>
	</tr>
	<TR>
		<%if(request.getParameter("oth_csi_CSIP").equalsIgnoreCase("true")){ %>
	    <td nowrap width="100" height="16" id="oth_csi_CSIP" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Change SI %</td>
			<% } else {%>
			<td nowrap width="180" height="16" id="oth_csi_CSIP" class="RBPrint"><input type="checkbox" name="oth_csi_CSIP" style='width:25px;' disabled >Change SI %</td>
			<%}%>
        <td nowrap width="180" class="RBPrint" id="oth_csi_POSTMTB">% Of STMT Balance</td><td><%=request.getParameter("oth_csi_POSTMTB")==null?"":request.getParameter("oth_csi_POSTMTB")%></td>
		</tr>
	<TR>
		<%if(request.getParameter("oth_csi_CSID").equalsIgnoreCase("true")){ %>
	    <td nowrap width="180" height="16" id="oth_csi_CSID" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Change in SI Date</td>
		<% } else {%>
			<td nowrap width="100" height="16" id="oth_csi_CSID" class="RBPrint"><input type="checkbox" name="oth_csi_CSID" style='width:25px;' disabled >Change in SI Date</td>
			<%}%>

        <td nowrap width="180" id="oth_csi_ND" class="RBPrint">New date(DD)</td>
		<td colspan=3><%=request.getParameter("oth_csi_ND")==null?"":request.getParameter("oth_csi_ND")%></td>		
	</tr>
	<TR>
	    <%if(request.getParameter("oth_csi_CDACNo").equalsIgnoreCase("true")){ %>
	    <td nowrap width="200" height="16" id="oth_csi_CDACNo" class="RBPrint">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;Change Debit A/C No.</td>
			<% } else {%>
			   <td nowrap width="200" height="16" id="oth_csi_CDACNo" class="RBPrint"><input type="checkbox" name="oth_csi_CDACNo" style='width:25px;' disabled >Change Debit A/C No.</td>
			   <%}%>

        <td nowrap width="180" id="oth_csi_AccNo" class="RBPrint">Account No.</td> 
		<td colspan=3> <%=request.getParameter("oth_csi_AccNo")==null?"":request.getParameter("oth_csi_AccNo")%></td>		
	</tr>
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="oth_csi_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=4><%=request.getParameter("oth_csi_RR")==null?"":request.getParameter("oth_csi_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<% } else if(request.getParameter("Setup_Suppl_Card_Limit").equalsIgnoreCase("Setup Suppl. Card Limit")) {%>
<table border="1" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
		<td colspan=4 align=center class="RBPrint"><b>Setup Suppl. Card Limit</b></td>
	</tr>
	</table>
	<table>
	<TR>
        <td nowrap width="155" height="16" id="oth_ssc_Amount" class="RBPrint">Amount Field</td>
        <td nowrap  width="150"><%=request.getParameter("oth_ssc_Amount")==null?"":request.getParameter("oth_ssc_Amount")%></td>
		  <td nowrap width="190" id="C_oth_ssc_SCNo" height="16" class="RBPrint">Suplementary Card No.</td>
        <td nowrap width="190"><%=request.getParameter("oth_ssc_SCNo")==null?"":request.getParameter("oth_ssc_SCNo")%>
		</td>
	</tr>	
	</table>
<table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap  valign="top" width="155" height="16" id="oth_ssc_RR" class="RBPrint">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_ssc_RR")==null?"":request.getParameter("oth_ssc_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
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
        <td nowrap  width="150" colspan=3><%=request.getParameter("oth_rip_RR")==null?"":request.getParameter("oth_rip_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>

 <%}%>
  <br>
 <table border="0" cellspacing="0" cellpadding="0" width=100% >
	<TR>	    
        <td nowrap valign="top" width="155" height="16" id="BR_Remarks" class="RBPrint">Branch Return Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><%=request.getParameter("BR_Remarks")==null?"":request.getParameter("BR_Remarks").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>	
</table>
<%

String Cards_Rem = request.getParameter("Cards_Remarks");
Cards_Rem=Cards_Rem.replace("ampersand","&");
Cards_Rem=Cards_Rem.replace("equalsopt","=");
Cards_Rem=Cards_Rem.replace("percentageopt","%");

String cardDecision = request.getParameter("Cards_Decision");
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

WriteLog("cardDecTemp :"+cardDecTemp);
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

&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <br><font size="-1">"This is a Computer Generated Document, therefore needs no signature."</font>
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


</form>
</body>