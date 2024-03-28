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
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_OCC_TD.jsp
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
<table id="TD" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Transaction Dispute'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Transaction Dispute</b></td>
	</tr>
	<TR>
        <td nowrap width="155" id="oth_td_RNO" height="16" class="EWLabelRB">Reference No.</td>
        <td nowrap  width="150">
			<input type="text" name="oth_td_RNO" value='<%=DataFormHT!=null&&DataFormHT.get("oth_td_RNO")!=null?DataFormHT.get("oth_td_RNO"):""%>'   size="8" maxlength=10 style='width:150px;' onkeyup=validateKeys(this,'CSR_OCC_TD') onblur=validateKeys_OnBlur(this,'CSR_OCC_TD') type="text">
		</td>
		  <td nowrap width="190" id="oth_td_Amount" height="16" class="EWLabelRB">Amount</td>
        <td nowrap width="190">
			<input type="text" name="oth_td_Amount" value='<%=DataFormHT!=null&&DataFormHT.get("oth_td_Amount")!=null?DataFormHT.get("oth_td_Amount"):""%>'   size="8" maxlength=11 style='width:150px;'  onkeyup=validateKeys(this,'CSR_OCC_TD') onblur=validateKeys_OnBlur(this,'CSR_OCC_TD') type="text" >
		</td>
	</tr>	
	<TR>	    
        <td nowrap width="155" height="16" id="oth_td_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><textarea name="oth_td_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_td_RR")!=null?DataFormHT.get("oth_td_RR"):""%></textarea></td>
	</tr>	
</table>
