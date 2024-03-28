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

function enabledisableCSI(){
	var dataForm=window.document.forms['dataform'];
	if(dataForm.oth_csi_PH.checked){
		dataForm.oth_csi_TOH.disabled=false;
		dataForm.oth_csi_TOH.focus();
	} else {
		dataForm.oth_csi_TOH.selectedIndex=0;
		dataForm.oth_csi_TOH.disabled=true;
	}
	if(dataForm.oth_csi_CSIP.checked){
		dataForm.oth_csi_POSTMTB.disabled=false;
		dataForm.oth_csi_POSTMTB.focus();
	} else {
		dataForm.oth_csi_POSTMTB.value="";
		dataForm.oth_csi_POSTMTB.disabled=true;
	} 
	if(dataForm.oth_csi_CSID.checked){
		dataForm.oth_csi_ND.disabled=false;
		dataForm.oth_csi_ND.focus();
	} else {
		dataForm.oth_csi_ND.value="";
		dataForm.oth_csi_ND.disabled=true;
	}  
	if(dataForm.oth_csi_CDACNo.checked){
		dataForm.oth_csi_AccNo.disabled=false;
		dataForm.oth_csi_AccNo.focus();
	} else {
		dataForm.oth_csi_AccNo.value="";
		dataForm.oth_csi_AccNo.disabled=true;
	}
}

function changeTypeOfHold(){
	var dataForm=window.document.forms['dataform'];
		if(dataForm.oth_csi_TOH.value=="Temporary"){
			dataForm.oth_csi_NOM.disabled=false;
			dataForm.oth_csi_NOM.focus();
		} else{
			dataForm.oth_csi_NOM.selectedIndex=0;
			dataForm.oth_csi_NOM.disabled=true;
		}
}
function AddPendingOptionsCSI(dropdownfieldId,selectedValueId)	
		{
			var element=document.getElementById('PendingOptionsCSI');
			var a=0;
			if(element.selectedIndex == -1 && element.options.length >0 )
			{
				alert('Please Select a Pending options');
				return false;
			}
			for(var j=0;j<element.options.length;j++)
			{
				var finalist=document.getElementById('PendingOptionsSelectedCSI');
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
			if(selectedValueId=='PendingOptionsSelectedCSI'){
			//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
					try {
					var sDropdown = document.getElementById('PendingOptionsSelectedCSI');
					var sDropDownValue = "";
					var opt = [], tempStr = "";
					var len = sDropdown.options.length;
					for (var i = 0; i < len; i++) {
						opt = sDropdown.options[i];
						sDropDownValue = sDropDownValue + opt.value + "@";
					}
					sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
					document.getElementById('PendingOptionsFinal').value = sDropDownValue;
					document.getElementById('PendingForCSI').value = sDropDownValue;
					}
					catch (e) {
						alert("Exception while saving multi select Data:");
						return false;
					}
					//return true;
					}
		}
function RemovePendingOptionsCSI(dropdownfieldId,selectedValueId)
{
	var element=document.getElementById('PendingOptionsSelectedCSI');
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
	if(selectedValueId=='PendingOptionsSelectedCSI'){
		//saveSelectedMultiValueField('PODOptionsSeleceted','wdesk:PODOptions');
		var sDropdown = document.getElementById('PendingOptionsSelectedCSI');
		var sDropDownValue = "";
		var opt = [], tempStr = "";
		var len = sDropdown.options.length;
		for (var i = 0; i < len; i++) {
			opt = sDropdown.options[i];
			sDropDownValue = sDropDownValue + opt.value + "|";
		}
		sDropDownValue = sDropDownValue.substring(0, sDropDownValue.length - 1);
		document.getElementById('PendingOptionsFinal').value = sDropDownValue;
		document.getElementById('PendingForCSI').value = sDropDownValue;
	}
}
/*

	Product/Project :       Rak Bank
	Module          :       Other Credit Card Requests
	File            :       CSR_OCC_CSI.jsp
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
var soth_csi_PH='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_PH")!=null?DataFormHT.get("oth_csi_PH"):""%>';
var soth_csi_TOH='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_TOH")!=null?DataFormHT.get("oth_csi_TOH"):""%>';
var soth_csi_NOM='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_NOM")!=null?DataFormHT.get("oth_csi_NOM"):""%>';
var soth_csi_CSIP='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_CSIP")!=null?DataFormHT.get("oth_csi_CSIP"):""%>';
var soth_csi_CSID='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_CSID")!=null?DataFormHT.get("oth_csi_CSID"):""%>';
var soth_csi_CDACNo='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_CDACNo")!=null?DataFormHT.get("oth_csi_CDACNo"):""%>';
</script>

<table id="CSI" border="1" cellspacing="1" cellpadding="1" width=100% >
	<tr class="EWHeader" width=100% class="EWLabelRB2">
	<input type='text' name='Header' readOnly size='24' style='display:none' value='Change in Standing Instructions'>
		<td colspan=5 align=left class="EWLabelRB2"><b>Change in Standing Instructions</b></td>
	</tr>
	<TR>
        <td nowrap width="215" height="16" id="C_oth_csi_PH" class="EWLabelRB"><input type="checkbox" name="oth_csi_PH" style='width:25px;' onclick=enabledisableCSI()>  Place Hold </td>
        <td nowrap  width="150" id="C_oth_csi_TOH" class="EWLabelRB">Type of Hold</td>
		  <td nowrap width="190" height="16" class="EWLabelRB">
			<select name="oth_csi_TOH"  style='width:150px;' onchange=changeTypeOfHold() disabled type="text">
				<option value="">--Select--</option>
				<option value="Temporary">Temporary</option>
				<option value="Permanent">Permanent</option>
			</select></td>
        <td nowrap width="150" class="EWLabelRB" id="C_oth_csi_NOM">No. of Months </td>
		<td>
			<select name="oth_csi_NOM"  style='width:90px;' disabled type="text">
				<option value="">--Select--</option>
				<option value="1">1</option>
				<option value="2">2</option>
				<option value="3">3</option>
			</select>
		</td>
	</tr>
	<TR>
	    <td nowrap width="100" height="16" id="C_oth_csi_CSIP" class="EWLabelRB"><input type="checkbox" name="oth_csi_CSIP" style='width:25px;' onclick=enabledisableCSI() > Change SI %</td>
        <td nowrap width="180" class="EWLabelRB" id="oth_csi_POSTMTB">% Of STMT Balance</td>
		<td colspan=3><input type="text" name="oth_csi_POSTMTB" value='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_POSTMTB")!=null?DataFormHT.get("oth_csi_POSTMTB"):""%>'   size="8" maxlength=3 style='width:150px;' onkeyup=validateKeys(this,'CSR_OCC_CSI') onblur=validateKeys_OnBlur(this,'CSR_OCC_CSI') disabled></td>		
	</tr>
	<TR>
	    <td nowrap width="100" height="16" id="C_oth_csi_CSID" class="EWLabelRB"><input type="checkbox" name="oth_csi_CSID" style='width:25px;' onclick=enabledisableCSI()> Change in SI Date</td>
        <td nowrap width="180" id="oth_csi_ND" class="EWLabelRB">New date(DD)</td>
		<td colspan=3><input type="text" name="oth_csi_ND" value='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_ND")!=null?DataFormHT.get("oth_csi_ND"):""%>'   size="8" maxlength=2 style='width:150px;'  onblur=validateKeys_OnBlur(this,'CSR_OCC_CSI') disabled></td>		
	</tr>
	<TR>
	    <td nowrap width="100" height="16" id="C_oth_csi_CDACNo" class="EWLabelRB"><input type="checkbox" name="oth_csi_CDACNo" style='width:25px;' onclick=enabledisableCSI()> Change Debit A/C No.</td>
        <td nowrap width="180" id="oth_csi_AccNo" class="EWLabelRB">Account No.</td> 
		<td colspan=3><input type="text" name="oth_csi_AccNo" value='<%=DataFormHT!=null&&DataFormHT.get("oth_csi_AccNo")!=null?DataFormHT.get("oth_csi_AccNo"):""%>'   size="8" maxlength=13 style='width:150px;' onkeyup=validateKeys(this,'CSR_OCC_CSI') onblur=validateKeys_OnBlur(this,'CSR_OCC_CSI') type="text" disabled></td>		
	</tr>
	<TR>	    
        <td nowrap width="155" height="16" id="oth_csi_RR" class="EWLabelRB">Remarks/Reasons</td>
        <td nowrap  width="150" colspan=4><textarea name="oth_csi_RR" type="text" cols=50 onKeyup="CheckMxLength(this,500);" rows=2><%=DataFormHT!=null&&DataFormHT.get("oth_csi_RR")!=null?DataFormHT.get("oth_csi_RR"):""%></textarea></td>
	</tr>	
	<TR>
		<td nowrap width="160" height="30" class="EWLabelRB"  id="CSR_CCC_PF">Pending For</td>
        <td>
					<table>
					<tr>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
								<select multiple='multiple' class='NGReadOnlyView' id="PendingOptionsCSI" style="width: 160;" name="PendingOptionsCSI" >
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
						<input type="button" id="addButtonPendingOptionsCSI" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto' onclick="AddPendingOptionsCSI('PendingOptionsCSI','PendingOptionsSelectedCSI');" 
							value="Add >>"><br />
						<input type="button" id="removeButtonPendingOptionsCSI" class='EWButtonRB NGReadOnlyView' style='width:100px;display:block;margin:auto'onClick="RemovePendingOptionsCSI('PendingOptionsCSI','PendingOptionsSelectedCSI');"
							value="<< Remove">
					</td>
					<td nowrap='nowrap' class='EWNormalGreenGeneral1' height ='22' width = 25%>
						<select id='PendingOptionsSelectedCSI'  name='PendingOptionsSelectedCSI' multiple='multiple' style="width:150px">
						</select>
					</td>
					</tr>	
					</table>
					</td>
					<input type="text" id="PendingOptionsFinal"name="PendingOptionsFinal" style="visibility:hidden" >
	</tr>
</table>
