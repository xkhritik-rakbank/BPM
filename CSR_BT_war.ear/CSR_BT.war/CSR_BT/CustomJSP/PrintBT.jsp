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

<!-- 
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       PrintBT.jsp
	Purpose         :       Style Tag added for decreasing the font size to make single print page in IE6 
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/026					15/09/2008	 Saurabh Arora
-->
<style type="text/css">
td {font-size: 80%;}
</style>
<%
 WriteLog("Inside PrintBT.jsp :");
    Calendar c = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MMM/yyyy  hh:mm:ss.SSS"); 
	String CurrDate=dateFormat.format(c.getTime());
	%>


<script>

function load()
{
	alert("Print Loaded");
}

</script>
</head>
<body lang=EN-US onload="window.print();">
<BODY topmargin=0 leftmargin=15  onload="load()" >
<table id=tbl width="100%"   cellpadding=0 cellspacing=0>
	<tr width="100%">
		<td colspan=5 align=right width="90%" >
			&nbsp;
		</td>
		<td colspan=1 align=left width="10%" >
			<img src='\CSR_BT\CSR_BT\CustomJSP\rak-logo.gif'>
			
		</td>
	</tr>
</table>
<form name="dataform">

<script language="javascript" src="/CSR_BT/CSR_BT/CustomJSP/CSR_RBCommon.js"></script>
<br>

<table border="0" cellspacing="1" cellpadding="1" width=100% >
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="IntroductionDateTime">Introduction Date & Time :</td>
			<td nowrap  width="800" colspan=1><%=request.getParameter("IntroductionDateTime")==null?"":request.getParameter("IntroductionDateTime")%></td>
		</tr>
		<TR>
			<td nowrap width="200" height="16" class="RBPrint" colspan=1 id="BA_UserName">Introduced By:</td>
<!-- 
	Product/Project :       Rak Bank
	Module          :       Balance Transfer
	File            :       PrintBT.jsp
	Purpose         :       Print out at cards workstep doesn’t display Introduced By username
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/085					04/05/2009	 Saurabh Arora
-->
			<td nowrap  width="800" colspan=1><%=request.getParameter("BU_UserName")==null?"":request.getParameter("BU_UserName")%></td>
		</tr>

</table>

<table border="0" cellspacing="1" cellpadding="1" width=100% >

		 <tr  border="1" width=100% >
			<td  colspan=4 align=center ><b>Request Type: Balance Transfer Request </b></td>
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
		<TR>
			<td nowrap width="100" height="16" class="RBPrint" id="CCI_SC">Source Code:</td>
			<td nowrap width="190"><%=request.getParameter("CCI_SC")==null?"":request.getParameter("CCI_SC")%></td>
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
	Module          :       Balance Transfer
	File            :       PrintBT.jsp
	Purpose         :       Heavy Check Mark Image added to print JSP of each process to make selected options in check boxes more clear
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						RBC/CR/1.0.1/019					15/09/2008	 Saurabh Arora
-->
	<%if(request.getParameter("VD_TINCheck").equalsIgnoreCase("Y")){ %>
        <td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4>&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;TIN Check</td>
		<% } else {%>
		<td nowrap  height="16" class="RBPrint" id="C_VD_TINCheck" colspan=4><input type="checkbox" name="VD_TINCheck" style='width:25px;' disabled>&nbsp;TIN Check</td>
		<%}%>
	</tr>
	<TR>
	<%if(request.getParameter("VD_MoMaidN").equalsIgnoreCase("Y")){ %>
        <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;Any 4 of the following RANDOM Questions</td>
		<% } else {%>
		 <td nowrap  height="16" class="RBPrint" colspan=3 width=29% id="C_VD_MoMaidN"><input type="checkbox" name="VD_MoMaidN"  style='width:25px;'  disabled>&nbsp;Any 4 of the following RANDOM Questions</td>
	<%}%>
	</TR>
	<TR>
		<tr>
		<%if(request.getParameter("VD_POBox").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=53% id="C_VD_POBox">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;P.O Box</td>
		<% } else {%>
		<td class="RBPrint" nowrap width=53% id="C_VD_POBox"><input type="checkbox" name="VD_POBox" disabled style='width:25px;'   disabled >&nbsp;&nbsp;P.O Box</td>
			<%}%>
		<%if(request.getParameter("VD_Oth").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=47% id="C_VD_Oth">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mother's Maiden name</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=47% id="C_VD_Oth"><input type="checkbox" name="VD_Oth" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Mother's Maiden name</td>
				<%}%>
		</tr>
		<tr>
		<%if(request.getParameter("VD_MRT").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_MRT">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
			<% } else {%>
			<td class="RBPrint" nowrap width=33% id="C_VD_MRT"><input type="checkbox" name="VD_MRT" disabled style='width:25px;'  disabled >&nbsp;&nbsp;Most Resent Transaction (Date,Amount in Transaction Currency)</td>
				<%}%>
		<%if(request.getParameter("VD_StaffId").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_StaffId">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Staff ID No./Military ID No.</td>
          <% } else {%>
		  <td class="RBPrint" nowrap width=67% id="C_VD_StaffId"><input type="checkbox" name="VD_StaffId" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Staff ID No./Military ID No.</td>
		  <%}%>

		</tr>
		<tr>
		<%if(request.getParameter("VD_EDC").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_EDC">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Expiry date Of Your Card</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_EDC"><input type="checkbox" name="VD_EDC" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Expiry date Of Your Card</td>
					  <%}%>
				<%if(request.getParameter("VD_PassNo").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_PassNo">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Last Payment Amt</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=67% id="C_VD_PassNo"><input type="checkbox" name="VD_PassNo" disabled style='width:25px;'  disabled>&nbsp;&nbsp;Last Payment Amt</td>
			  <%}%>

        </tr>
		<tr>
		<%if(request.getParameter("VD_NOSC").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_NOSC">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name of Supplementary Card Holder."If Any"</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_NOSC"><input type="checkbox" name="VD_NOSC" disabled style='width:25px;' disabled >&nbsp;&nbsp;Name of Supplementary Card Holder."If Any"</td>
			  <%}%>
			<%if(request.getParameter("VD_SD").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_SD">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Statement Date</td>
			 <% } else {%>
				<td class="RBPrint" nowrap width=67% id="C_VD_SD"><input type="checkbox" name="VD_SD" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Statement Date</td>
					  <%}%>
        </tr>
		<tr>
		<%if(request.getParameter("VD_TELNO").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=33% id="C_VD_TELNO">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us</td>
			 <% } else {%>
			 <td class="RBPrint" nowrap width=33% id="C_VD_TELNO"><input type="checkbox" name="VD_TELNO" disabled style='width:25px;'
	  disabled>&nbsp;&nbsp;Residence,Mobile,Work Tel No.registered with us</td>
			 <%}%>
			<%if(request.getParameter("VD_DOB").equalsIgnoreCase("Y")){ %>
		<td class="RBPrint" nowrap width=67% id="C_VD_DOB">&nbsp;<img src="heavy_check_mark.png" height="12" width="12" allign="bottom">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Of Birth</td>
		 <% } else {%>
		 <td class="RBPrint" nowrap width=67% id="C_VD_DOB"><input type="checkbox" name="VD_DOB" disabled style='width:25px;'   disabled>&nbsp;&nbsp;Date Of Birth</td>
		 	 <%}%>



        </tr>
		</TR>
</table>

  <table border="1" cellspacing="1" cellpadding="1" width=100% >
	  <tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>BT (Balance Transfer) Details </b></td>
	 </tr>
	 </table>
	 <table>

	<TR>
        <td nowrap width="140" height="16" class="RBPrint"  id="C_BTD_OBC_CT">Card Type:</td>
        <td nowrap  width="180"><%=request.getParameter("BTD_OBC_CT")==null?"":request.getParameter("BTD_OBC_CT")%>
		</td>
		<td nowrap width="100" height="16" class="RBPrint" id="C_BTD_OBC_OBN">Other Bank Name:</td>
        <td nowrap width="180"><%=request.getParameter("BTD_OBC_OBN")==null?"":request.getParameter("BTD_OBC_OBN")%>
		</td>
	</tr>
	<TR>
	    <td nowrap width="140" height="16" class="RBPrint" id="BTD_OBC_OBNO">Others (Pls. Specify):</td>
        <td nowrap  width="180"><%=request.getParameter("BTD_OBC_OBNO")==null?"":request.getParameter("BTD_OBC_OBNO")%></td>
        <td nowrap width="100" height="16" class="RBPrint" id="BTD_OBC_OBCNO">Other Bank Card No.:</td>
        <td nowrap width="180"><%=request.getParameter("othCardNoClearTxt")==null?"":request.getParameter("othCardNoClearTxt")%></td>
	</tr>
	<TR>
        <td nowrap width="100" height="16" class="RBPrint" id="BTD_OBC_NOOC">Name on Other Card:</td> 
        <td nowrap  width="180"><%=request.getParameter("BTD_OBC_NOOC")==null?"":request.getParameter("BTD_OBC_NOOC")%></td>
		<td nowrap width="100" height="16" class="RBPrint" id="BTD_OBC_DT">Deliver To:</td>
        <td nowrap width="180"><%=request.getParameter("BTD_OBC_DT")==null?"":request.getParameter("BTD_OBC_DT")%></td>
	</tr>
	<TR>
		<td nowrap width="100" height="16" class="RBPrint" id="C_BTD_OBC_BN">Branch Name:</td>
        <td nowrap  width="180"><%=request.getParameter("BTD_OBC_BN")==null?"":request.getParameter("BTD_OBC_BN")%> </td>
	</tr>
	</table>
	
	<table border="1" cellspacing="1" cellpadding="1" width=100% >
	  <tr  border="1" width=100% >
			<td colspan=4 align=center class="RBPrint"><b>RAKBANK Card Details</b></td>
	 </tr>
	 </table>
	 <table>
	<TR>
       <td nowrap width="140" height="16" class="RBPrint" id="C_BTD_RBC_RBCN1">RAKBANK card no.:</td>		
        <td nowrap  width="180"><%=request.getParameter("BTD_RBC_RBCN1")==null?"":request.getParameter("BTD_RBC_RBCN1")%>
		</td>
		
		<td nowrap  width="180"><%=request.getParameter("BTD_RBC_RBCN2")==null?"":request.getParameter("BTD_RBC_RBCN2")%>
		</td>
		<td nowrap  width="180"><%=request.getParameter("BTD_RBC_RBCN3")==null?"":request.getParameter("BTD_RBC_RBCN3")%>
		</td>
	</tr>
	<TR>
         <td nowrap width="140" height="16" class="RBPrint" id="BTD_RBC_CT1">Card Type:</td>
        <td nowrap width="180"><%=request.getParameter("BTD_RBC_CT1")==null?"":request.getParameter("BTD_RBC_CT1")%></td>
        <td nowrap  width="180"><%=request.getParameter("BTD_RBC_CT2")==null?"":request.getParameter("BTD_RBC_CT2")%></td>
		<td nowrap  width="180"><%=request.getParameter("BTD_RBC_CT3")==null?"":request.getParameter("BTD_RBC_CT3")%></td>		 
	</tr>
	<TR>
        <td nowrap width="140" height="16" class="RBPrint" id="BTD_RBC_ExpD1">Expiry Date:</td>
        <td nowrap width="180"><%=request.getParameter("BTD_RBC_ExpD1")==null?"":request.getParameter("BTD_RBC_ExpD1")%></td>
        <td nowrap  width="180"><%=request.getParameter("BTD_RBC_ExpD2")==null?"":request.getParameter("BTD_RBC_ExpD2")%></td>
		<td nowrap  width="180"><%=request.getParameter("BTD_RBC_ExpD3")==null?"":request.getParameter("BTD_RBC_ExpD3")%></td>		 
	</tr>
	<TR>
        <td nowrap width="140" height="16" class="RBPrint" id="BTD_RBC_BTA1" >BT Amount(AED):</td>
        <td nowrap width="180"><%=request.getParameter("BTD_RBC_BTA1")==null?"":request.getParameter("BTD_RBC_BTA1")%></td>
        <td nowrap  width="180"><%=request.getParameter("BTD_RBC_BTA2")==null?"":request.getParameter("BTD_RBC_BTA2")%></td>
		<td nowrap  width="180"><%=request.getParameter("BTD_RBC_BTA3")==null?"":request.getParameter("BTD_RBC_BTA3")%></td>		 
	</tr>
	<TR>
        <td nowrap width="140" height="16" class="RBPrint" id="BTD_RBC_AppC1">Approval Code:</td>
        <td nowrap width="180"><%=request.getParameter("BTD_RBC_AppC1")==null?"":request.getParameter("BTD_RBC_AppC1")%></td>
        <td nowrap  width="180"><%=request.getParameter("BTD_RBC_AppC2")==null?"":request.getParameter("BTD_RBC_AppC2")%></td>
		<td nowrap  width="180"><%=request.getParameter("BTD_RBC_AppC3")==null?"":request.getParameter("BTD_RBC_AppC3")%></td>		 
	</tr>	

	<table>
	<TR>
        <td nowrap valign="top" width="140" height="16" class="RBPrint" id="BTD_RBC_RR">Work Introduction Remarks/ Reason:</td> 
        <td nowrap  width="180" colspan=3><%=request.getParameter("BTD_RBC_RR")==null?"":request.getParameter("BTD_RBC_RR").replace("ampersand","&").replace("equalsopt","=").replace("percentageopt","%")%></td>
	</tr>
	</table>
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
{cardDecTemp="Underprocess";}

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

<form name="printform" action="../CSRProcessSpecific/Print.jsp"  target="_blank">
</form>
</body>