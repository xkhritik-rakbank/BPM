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
	function AddPendingOptionsCR(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptionsCR');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelectedCR');
				if(element.options[j].selected)
				{
					var name = element.options[j].text;
					var value = element.options[j].value;
					if(finalist.options.length!=0)
					{
						for(var i=0;i<finalist.options.length;i++)
						{
							//alert(finalist.options[i].value);
							if(finalist.options[i].value==value)
							{		
								alert(value+'Pending option is already there');
								a=1;
								break;
							}
						}
						if(a!=1)
						{
							var opt = document.createElement("option");
							opt.text = value;
							opt.value =value;
							finalist.options.add(opt);	
						}
					}
					else
					{
						var opt = document.createElement("option");
						opt.text = value;
						opt.value =value;
						finalist.options.add(opt);
					}
				}
			}
			if(selectedValueId=='PendingOptionsSelectedCR'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelectedCR');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";
					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					document.getElementById('PendingForCR').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
		}
function RemovePendingOptionsCR(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelectedCR');
	if(element.options.length==0)
		alert('No Pending Option to Remove');
	else if(element.selectedIndex==-1 && element.options.length!=0)
		alert('Select a Pending option to remove');
	else
	{
		var len=element.options.length;
		for(i=len-1;i>=0;i--)
		{
			if(element.options[i] != null && element.options[i].selected)
			{
				element.options[i]=null;
			}
		}
	}
	if(selectedValueId=='PendingOptionsSelectedCR'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelectedCR');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
		document.getElementById('PendingForCR').value = sDropDownValue;
	}
}

	function onChangeReasonCR(){
		var dataForm=window.document.forms['dataform'];
		if(dataForm.oth_cr_reason.value=="Others"){
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
				<option value="Card No. Being Misused">Card No. being misused</option>
				<option value="Others">others</option>
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
				<!--<option value="Personal Pickup">Personal Pickup</option>-->				
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
	<TR>
		<td nowrap width="160" height="30" class="EWLabelRB"  id="CSR_CCC_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptionsCR" style="width: 160;" name="PendingOptionsCR" >
								<option value="">--select--</option>
								<option value="Travel Document">Travel Document</option>
								<option value="Medical Report">Medical Report</option>
								<option value="TT Swift Copy">TT Swift Copy</option>
								<option value="Payment Receipt">Payment Receipt</option>
								<option value="Application Screenshot">Application Screenshot</option>
								<option value="Tenancy Contract">Tenancy Contract </option>
								<option value="Salary Certificate">Salary Certificate</option>
								<option value="Bank Statement">Bank Statement</option>
								<option value="PaySlip">PaySlip</option>
								<option value="Emirates ID Copy">Emirates ID Copy</option>
								<option value="Passport Copy">Passport Copy</option>
								<option value="Visa Copy">Visa Copy</option>
								<option value="Salary Transfer Letter">Salary Transfer Letter</option>
								<option value="Labour Contract">Labour Contract</option>
								<option value="Transaction Receipt">Transaction Receipt</option>
								<option value="Lifestyle Declaration">Lifestyle Declaration</option>
								<option value="Others">Others</option>
								</select>
					</td>
					<td  nowrap='nowrap' height ='30' width = 180 class='EWNormalGreenGeneral1' valign="middle"> 
						<input type="button" id="addButtonPendingOptionsCR" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptionsCR('PendingOptionsCR','PendingOptionsSelectedCR');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptionsCR" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptionsCR('PendingOptionsCR','PendingOptionsSelectedCR');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelectedCR'  name='PendingOptionsSelectedCR' multiple='multiple' style="width:150px">
						</select>
					</td>
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>
</table>
