<%@ include file="Log.process"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>
<%@ include file="/generic/wdcustominit.jsp"%>

<%
	Hashtable DataFormHT=null;
		if(request.getAttribute("DataFormHT")!=null)
		DataFormHT=(Hashtable)request.getAttribute("DataFormHT");		
		%>
<script>
var soth_cs_CS='<%=DataFormHT!=null&&DataFormHT.get("oth_cs_CS")!=null?DataFormHT.get("oth_cs_CS"):""%>';
var soth_cs_CSR='<%=DataFormHT!=null&&DataFormHT.get("oth_cs_CSR")!=null?DataFormHT.get("oth_cs_CSR"):""%>';
</script>
<script>

function enabledisableCS(){
	var dataForm=window.document.forms['dataform'];
	if(dataForm.oth_cs_CSR.checked){
		dataForm.oth_cs_Amount.disabled=false;
		dataForm.oth_cs_Amount.focus();
	} else {
		dataForm.oth_cs_Amount.value="";
		dataForm.oth_cs_Amount.disabled=true;
	}
}
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_OCC_CS.jsp
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

function unableDisable(){
	enabledisableCS();
	var dataForm=window.document.forms['dataform'];
	if(dataForm.oth_cs_CS.options[dataForm.oth_cs_CS.selectedIndex].value=="Un-Enrollement")
	{
		dataForm.oth_cs_CSR.disabled=false;
	}
	else
	{
		dataForm.oth_cs_CSR.checked=false;
		dataForm.oth_cs_CSR.disabled=true;
		dataForm.oth_cs_Amount.disabled=true;
		dataForm.oth_cs_Amount.value="";
	}
}
</script>

<table id="CS" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Credit Shield'>
		<td colspan=5 align=left class="EWLabelRB2"><b>Credit Shield</b></td>
	</tr>
	<TR>
        <td nowrap width="150" height="16" id="C_oth_cs_CS" class="EWLabelRB">Credit Shield</td>
        <td nowrap  width="150">
			<select name="oth_cs_CS"  style='width:150px;' onchange="unableDisable();" type="text">
				<option value="">--Select--</option>
				<option value="Un-Enrollement">Un-Enrollement</option>
				<option value="Re-Enrollement">Re-Enrollement</option>
			</select>
		</td>
		  <td nowrap width="155" height="16" id="C_oth_cs_CSR" class="EWLabelRB"><input type="checkbox" name="oth_cs_CSR" style='width:25px;' disabled onclick=enabledisableCS()> Credit Shield Reversal</td>
  		  <td nowrap width="90" height="16" id="oth_cs_Amount" class="EWLabelRB">Amount</td> 
        <td nowrap width="190">
			<input type="text" name="oth_cs_Amount" value='<%=DataFormHT!=null&&DataFormHT.get("oth_cs_Amount")!=null?DataFormHT.get("oth_cs_Amount"):""%>'   size="8" maxlength=11 style='width:150px;' onkeyup=validateKeys(this,'CSR_OCC_CS') onblur=validateKeys_OnBlur(this,'CSR_OCC_CS') type="text" disabled>
		</td>
	</tr>	
	<TR>	    
        <td nowrap width="155" height="16" id="oth_cs_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=4><textarea name="oth_cs_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_cs_RR")!=null?DataFormHT.get("oth_cs_RR"):""%></textarea></td>
	</tr>	
</table>
