<!-- OPS_Initiate View-->
<div class="accordion" id="accordion1" class="accordion-group">
	<div class="accordion-group">
		<div class="accordion-heading">
			<h4 class="panel-title" style="color:white;>
				<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel1"><b>Customer Details</b></a>
			</h4>
		</div>
		<div id="panel1" class="accordion-body collapse">
			<div class="accordion-inner">
				<table border='2' cellspacing='1' cellpadding='0' width=100%>
					<tr class="width100">
						<td class='EWNormalGreenGeneral1 width25'>CIF ID</td>
						<td class='EWNormalGreenGeneral1 width25'>
							<input type="text" <%=strDisableReadOnly%>  name="wdesk:cif_id" id="wdesk:cif_id" value='<%=((WorkdeskAttribute)attributeMap.get("cif_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cif_id")).getValue()%>' maxlength = '7'>
						</td>
						<td class='EWNormalGreenGeneral1 width25'>Debit A/C Number
							<label class="mandatory" id="AccNumberM">&nbsp;*</label>
						</td>
						<td class='EWNormalGreenGeneral1 width25'>
							<input type="text" <%=strDisableReadOnly%>  name="wdesk:debt_acc_num" id="wdesk:debt_acc_num" onblur="onDebitAccountChangeOnOpsInitiate(this);" maxlength="13" value='<%=((WorkdeskAttribute)attributeMap.get("debt_acc_num")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("debt_acc_num")).getValue()%>'>
						</td>
					</tr>
					<tr class="width100">
						<td class='EWNormalGreenGeneral1 width25'>Channel Id
							<label class="mandatory" id="ChannelM">&nbsp;*</label>
						</td>
						<td class='EWNormalGreenGeneral1 width25'>
							<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  class="dropdown148px" name="channel_id" id="channel_id" onchange="setComboValueToTextBox(this,'wdesk:channel_id')">
								<option value="--Select--">--Select--</option>
								<option value="IB">IB</option>
								<option value="MB">MB</option>									
							</select>
							<input type="hidden" <%=strDisableReadOnly%>  name="wdesk:channel_id" id="wdesk:channel_id"  value='<%=((WorkdeskAttribute)attributeMap.get("channel_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("channel_id")).getValue()%>'>
						</td>
						<td class='EWNormalGreenGeneral1 width25'>Payment Order Id</td>
						<td class='EWNormalGreenGeneral1 width25' id="paymentorderidF">
							<input type="text" <%=strDisableReadOnly%>  name="wdesk:payment_order_id" id="wdesk:payment_order_id" value='<%=((WorkdeskAttribute)attributeMap.get("payment_order_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("payment_order_id")).getValue()%>'>
						</td>
					</tr>
					<tr class="width100">
					<td class='EWNormalGreenGeneral1 width25'>Sub-Segment</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:sub_segment" id="wdesk:sub_segment" value='<%=((WorkdeskAttribute)attributeMap.get("sub_segment")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sub_segment")).getValue()%>' maxlength = '10'>
					</td>
					<td class='EWNormalGreenGeneral1 width25'></td>
					<td class='EWNormalGreenGeneral1 width25'></td>
					</tr>
					<tr class="width100">
						<td colspan="4" class='EWNormalGreenGeneral1 width100'>
							<button <%=strDisableReadOnly%>  class='EWButtonRB' onclick="openCustomDialog('Exception History','<%=workstepName%>');" id="view_raise_excep">View/Raise Exceptions</button>
						</td>
						<!--td colspan="3" class='EWNormalGreenGeneral1 width75'>&nbsp;</td-->
					</tr>									
				</table>								
			</div>
		</div>
	</div>
	<input type="hidden" name="wdesk:forNonComplianceEmailID" id="wdesk:forNonComplianceEmailID" value='<%=((WorkdeskAttribute)attributeMap.get("forNonComplianceEmailID")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("forNonComplianceEmailID")).getValue()%>' >
	<input type="hidden" name="wdesk:forComplianceEmailID" id="wdesk:forComplianceEmailID" value='<%=((WorkdeskAttribute)attributeMap.get("forComplianceEmailID")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("forComplianceEmailID")).getValue()%>' >
</div>