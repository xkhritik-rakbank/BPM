<%@ include file="Log.process"%>
<%@ include file="/generic/wdcustominit.jsp"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.io.*,java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.net.*"%>
<%@ page import="java.lang.String.*"%>
<%@ page import="java.lang.Object"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*" %>
<%@ page import="com.newgen.wfdesktop.util.*" %>

<%
	Hashtable DataFormHT=null;
		if(request.getAttribute("DataFormHT")!=null)
		DataFormHT=(Hashtable)request.getAttribute("DataFormHT");		
		%>

<script>
	function onChangeCardDeliveryTo(){
		var dataForm=window.document.forms['dataform'];
		if(dataForm.oth_cdr_CDT.value=="Bank"){
			dataForm.oth_cdr_BN.disabled=false;
			dataForm.oth_cdr_BN.focus();
		} else{
			dataForm.oth_cdr_BN.selectedIndex=0;
			dataForm.oth_cdr_BN.disabled=true;
		}

	}
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
	function AddPendingOptionsCDR(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptionsCDR');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelectedCDR');
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
			
			if(selectedValueId=='PendingOptionsSelectedCDR'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelectedCDR');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";

					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					document.getElementById('PendingForCDR').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
			
		}

function RemovePendingOptionsCDR(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelectedCDR');

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
	
	if(selectedValueId=='PODOptionsSelecetedCDR'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelected');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
		document.getElementById('PendingForCDR').value = sDropDownValue;
	 
	}
}
</script>

<script>
var soth_cdr_CDT='<%=DataFormHT!=null&&DataFormHT.get("oth_cdr_CDT")!=null?DataFormHT.get("oth_cdr_CDT"):""%>';
var soth_cdr_BN='<%=DataFormHT!=null&&DataFormHT.get("oth_cdr_BN")!=null?DataFormHT.get("oth_cdr_BN"):""%>';
</script>
<table id="CDR" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Card Delivery Request'>
		<td colspan=4 align=left class="EWLabelRB2"><b>Card Delivery Request</b></td>
	</tr>
	<TR>
        <td nowrap width="155" height="16" id="C_oth_cdr_CDT" class="EWLabelRB">Card Delivery To</td>
        <td nowrap  width="150">
			<select name="oth_cdr_CDT"  style='width:150px;' onchange=onChangeCardDeliveryTo() type="text">
				<option value="">--Select--</option>
				<option value="Bank">Bank</option>
				<option value="Office">Office</option>
			</select>
		</td>
		 <td nowrap width="100" height="16" id="C_oth_cdr_BN" class="EWLabelRB">Branch Name</td>
        <td nowrap width="180">
			<select name="oth_cdr_BN"  style='width:150px;' type="text" disabled>
				<option value="">--Select--</option>
				<%=request.getParameter("BranchOptions")%>
			</select>

		</td>   
	</tr>	
	<TR>	    
        <td nowrap width="155" height="16" id="oth_cdr_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><textarea name="oth_cdr_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_cdr_RR")!=null?DataFormHT.get("oth_cdr_RR"):""%></textarea></td>
	</tr>	
	<TR>
		<td nowrap width="140" height="30" class="EWLabelRB"  id="CSR_RR_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptionsCDR" style="width: 160;" name="PendingOptionsCDR" >
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
						<input type="button" id="addButtonPendingOptionsCDR" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptionsCDR('PendingOptionsCDR','PendingOptionsSelectedCDR');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptionsCDR" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptionsCDR('PendingOptionsCDR','PendingOptionsSelectedCDR');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelectedCDR'  name='PendingOptionsSelectedCDR' multiple='multiple' style="width:150px">
						</select>

					</td>
					
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>
</table>
