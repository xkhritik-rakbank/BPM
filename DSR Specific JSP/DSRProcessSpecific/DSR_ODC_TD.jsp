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
function AddPendingOptionsTD(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptionsTD');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelectedTD');
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
			
			if(selectedValueId=='PendingOptionsSelectedTD'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelectedTD');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";

					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					document.getElementById('PendingForTD').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
			
		}

function RemovePendingOptionsTD(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelectedTD');

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
	
	if(selectedValueId=='PODOptionsSelecetedTD'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelectedTD');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
		document.getElementById('PendingForTD').value = sDropDownValue;
	 
	}
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
			<input type="text" name="oth_td_RNO" value='<%=DataFormHT!=null&&DataFormHT.get("oth_td_RNO")!=null?DataFormHT.get("oth_td_RNO"):""%>'   size="8" maxlength=10 style='width:150px;' onkeyup=validateKeys(this,'DSR_ODC_TD') onblur=validateKeys_OnBlur(this,'DSR_ODC_TD') type="text">
		</td>
		  <td nowrap width="190" id="oth_td_Amount" height="16" class="EWLabelRB">Amount</td>
        <td nowrap width="190">
			<input type="text" name="oth_td_Amount" value='<%=DataFormHT!=null&&DataFormHT.get("oth_td_Amount")!=null?DataFormHT.get("oth_td_Amount"):""%>'   size="8" maxlength=11 style='width:150px;'  onkeyup=validateKeys(this,'DSR_ODC_TD') onblur=validateKeys_OnBlur(this,'DSR_OCC_TD') type="text" >
		</td>
	</tr>	
	<TR>	    
        <td nowrap width="155" height="16" id="oth_td_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=3><textarea name="oth_td_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_td_RR")!=null?DataFormHT.get("oth_td_RR"):""%></textarea></td>
	</tr>

<TR>
		<td nowrap width="140" height="30" class="EWLabelRB"  id="CSR_RR_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptionsTD" style="width: 160;" name="PendingOptionsTD" >
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
						<input type="button" id="addButtonPendingOptionsTD" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptionsTD('PendingOptionsTD','PendingOptionsSelectedTD');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptionsTD" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptionsTD('PendingOptionsTD','PendingOptionsSelectedTD');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelectedTD'  name='PendingOptionsSelectedTD' multiple='multiple' style="width:150px">
						</select>

					</td>
					
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>
</table>
