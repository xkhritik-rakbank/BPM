<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<jsp:useBean id="wfsession" class="com.newgen.wfdesktop.session.WFSession" scope="session"/>

<%
	Hashtable DataFormHT=null;
		if(request.getAttribute("DataFormHT")!=null)
		DataFormHT=(Hashtable)request.getAttribute("DataFormHT");		
		%>



<script>
var soth_cr_reason='<%=DataFormHT!=null&&DataFormHT.get("oth_cr_reason")!=null?DataFormHT.get("oth_cr_reason"):""%>';
var soth_cr_DC='<%=DataFormHT!=null&&DataFormHT.get("oth_cr_DC")!=null?DataFormHT.get("oth_cr_DC"):""%>';
var oth_cr_BN='<%=DataFormHT!=null&&DataFormHT.get("oth_cr_BN")!=null?DataFormHT.get("oth_cr_BN"):""%>';
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_OCC_CR.jsp
	Purpose         :       At introduction workstep, length of Remarks/Reason field to be increased to 500 length
	Author			:		Saurabh Arora
	Change History  :
    	                  Problem No        Function Name	changed on	  changed by
    	                  --------------    -------------	-----------	  ------------
						 RBC/CR/1.0.1/073				   Saurabh Arora
*/
function CheckMxLength(data,val)
{
	var issue=data.value;
	if(issue.length>=val+1)
	{
		alert("Remarks/Reasons can't be greater than 500 Characters");
		var lengthRR="";
		lengthRR=issue.substring(0,val);
		data.value=lengthRR;
		
	}
	return true;
}

</script>

<script>
	function onChangeDeliveryChanelCR(){
		var dataForm=window.document.forms['dataform'];
		if(dataForm.oth_cr_DC.value=="Branch"){
			dataForm.oth_cr_BN.disabled=false;
			dataForm.oth_cr_BN.focus();
		} else{
			dataForm.oth_cr_BN.selectedIndex=0;
			dataForm.oth_cr_BN.disabled=true;
		} 

	}

	function onChangeReasonCR(){
		var dataForm=window.document.forms['dataform'];
		if(dataForm.oth_cr_reason.value=="others"){
			dataForm.oth_cr_OPS.disabled=false;
			dataForm.oth_cr_OPS.focus();
		} else{
			dataForm.oth_cr_OPS.value="";
			dataForm.oth_cr_OPS.disabled=true;
		} 

	}
	
</script>


<table id="CR" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
<input type='text' name='Header' readOnly size='24' style='display:none' value='Card Replacement'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Card Replacement</b></td>
	</tr>
	<TR>
        <td nowrap width="155" height="16" id='C_oth_cr_reason' class="EWLabelRB">Reason</td>
        <td nowrap  width="150">
			<select name="oth_cr_reason"  style='width:150px;' onchange=onChangeReasonCR()> 
				<option value="">--Select--</option>
				<option value="Lost/Stolen Card">Lost/Stolen Card</option>
				<option value="Card No. being misused">Card No. being misused</option>
				<option value="others">others</option>
			</select>
		</td>
		  <td nowrap width="190" height="16" id="oth_cr_OPS" class="EWLabelRB">Others Pls Specify</td>
        <td nowrap width="190">
			<input type="text" name="oth_cr_OPS" value='<%=DataFormHT!=null&&DataFormHT.get("oth_cr_OPS")!=null?DataFormHT.get("oth_cr_OPS"):""%>'   size="8" maxlength=50 style='width:150px;' disabled>
		</td>
	</tr>


	<TR>
        <td nowrap width="155" height="16" id="C_oth_cr_DC" class="EWLabelRB">Delivery Channel</td>
        <td nowrap  width="150">
			<select name="oth_cr_DC"  style='width:150px;' onchange=onChangeDeliveryChanelCR() type="text">
				<option value="">--Select--</option>
				<option value="Branch">Branch</option>
				<option value="Courier">Courier</option>
				<!--<option value="Personal Pickup">Personal Pickup</option>				-->
			</select>
		</td>
		  <td nowrap width="100" id="C_oth_cr_BN" height="16" class="EWLabelRB">Branch Name</td>
        <td nowrap width="180">
			<select name="oth_cr_BN"  style='width:150px;'  type="text" disabled>
				<option value="">--select--</option>
				<%=request.getParameter("BranchOptions")%>
			</select>

		</td>        
	</tr>
	<TR>	    
        <td nowrap width="155" height="16" id="oth_cr_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><textarea name="oth_cr_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_cr_RR")!=null?DataFormHT.get("oth_cr_RR"):""%></textarea></td>
	</tr>	
</table>
