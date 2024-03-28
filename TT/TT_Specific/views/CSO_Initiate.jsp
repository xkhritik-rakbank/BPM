<!-- CSO_Initiate View-->
<div class="accordion" id="accordion2" class="accordion-group">
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
							<td class='EWNormalGreenGeneral1 width25'>Customer Name</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:cust_name" id="wdesk:cust_name" value='<%=((WorkdeskAttribute)attributeMap.get("cust_name")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_name")).getValue()%>' maxlength = '100'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Debit A/C Number
								<label class="mandatory" id="BalSuffM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:debt_acc_num" id="wdesk:debt_acc_num" onblur="onDebitAccountChange(this);" maxlength="13" value='<%=((WorkdeskAttribute)attributeMap.get("debt_acc_num")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("debt_acc_num")).getValue()%>'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Ruling Family</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" disabled name="wdesk:isRulingFamily" id="wdesk:isRulingFamily" value='<%=((WorkdeskAttribute)attributeMap.get("isRulingFamily")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isRulingFamily")).getValue()%>'>
								<input type="hidden" disabled name="wdesk:cust_type" id="wdesk:cust_type" value='<%=((WorkdeskAttribute)attributeMap.get("cust_type")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_type")).getValue()%>' maxlength = '100'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Customer A/C Currency</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:cust_acc_curr" id="wdesk:cust_acc_curr" value='<%=((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()%>' maxlength = '100'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>CIF ID</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:cif_id" id="wdesk:cif_id" value='<%=((WorkdeskAttribute)attributeMap.get("cif_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cif_id")).getValue()%>' maxlength = '7'>
							</td>							
							<td class='EWNormalGreenGeneral1 width25'>SOL ID</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:sol_id" id="wdesk:sol_id" value='<%=((WorkdeskAttribute)attributeMap.get("sol_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sol_id")).getValue()%>'
							</td>
						</tr>
						<tr class="width100" id="callbackCompliance">
							<td class='EWNormalGreenGeneral1 width25'>Sub-Segment</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:sub_segment" id="wdesk:sub_segment" value='<%=((WorkdeskAttribute)attributeMap.get("sub_segment")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sub_segment")).getValue()%>' maxlength = '10'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Balance Sufficient</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:bal_sufficient" id="wdesk:bal_sufficient" value='<%=((WorkdeskAttribute)attributeMap.get("bal_sufficient")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("bal_sufficient")).getValue()%>' maxlength = '100'>
							</td>										
						</tr>
						<tr class="width100">																			
							<td class='EWNormalGreenGeneral1 width25'>Preferred Contact Number 1</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:pref_contact1" id="wdesk:pref_contact1" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contact1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contact1")).getValue()%>' maxlength = '100'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Preferred Contact Number 2</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:pref_contact2" id="wdesk:pref_contact2" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contact2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contact2")).getValue()%>' maxlength = '100'>
							</td>
						</tr>
						<tr class="width100">																			
							<td class='EWNormalGreenGeneral1 width25'>Preferred Contact Name 1</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:pref_contactname1" id="wdesk:pref_contactname1" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contactname1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contactname1")).getValue()%>' maxlength = '100'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Preferred Contact Name 2</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:pref_contactname2" id="wdesk:pref_contactname2" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contactname2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contactname2")).getValue()%>' maxlength = '100'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Elite Customer</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:isEliteCust" id="wdesk:isEliteCust" value='<%=((WorkdeskAttribute)attributeMap.get("isEliteCust")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isEliteCust")).getValue()%>' maxlength = '10'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Application Received Original
								<label class="mandatory" id="BalSuffM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  id="app_received"  name="app_received" class="dropdown148px" onchange="setComboValueToTextBox(this,'wdesk:isOriginalReceived')">
									<option value="--Select--">--Select--</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
								<input type="hidden" name="wdesk:isOriginalReceived" id="wdesk:isOriginalReceived" value='<%=((WorkdeskAttribute)attributeMap.get("isOriginalReceived")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isOriginalReceived")).getValue()%>' maxlength = '10'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Relationship Manager</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:rel_manager" id="wdesk:rel_manager" value='<%=((WorkdeskAttribute)attributeMap.get("rel_manager")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("rel_manager")).getValue()%>' maxlength = '10'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Account Balance</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:acc_bal" id="wdesk:acc_bal" value='<%=((WorkdeskAttribute)attributeMap.get("acc_bal")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("acc_bal")).getValue()%>' maxlength = '100'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>RM Code</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:RMCode" id="wdesk:RMCode" value='<%=((WorkdeskAttribute)attributeMap.get("RMCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("RMCode")).getValue()%>' maxlength = '10'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Authorized Signatory Submission
							<label class="mandatory" id="transferamountM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  id="authorized_sign"  name="authorized_sign" class="dropdown148px" onchange="setComboValueToTextBox(this,'wdesk:authorized_sign')">
									<option value="--Select--">--Select--</option>
									<option value="Yes">Yes</option>
									<option value="No">No</option>
								</select>
								<input type="hidden" name="wdesk:authorized_sign" id="wdesk:authorized_sign" value='<%=((WorkdeskAttribute)attributeMap.get("authorized_sign")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("authorized_sign")).getValue()%>'> 
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Customer Address</td>
							<td colspan="3" class='EWNormalGreenGeneral1'>
								<textarea style="width:100%" disabled name="wdesk:custAddress" rows="3" cols="33" maxlength="100" onkeypress="if (this.value.length > 100) { return false; }" id="wdesk:custAddress"><%=customerAddress%></textarea>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>
								<button <%=strDisableReadOnly%> class='EWButtonRB' onclick="onDebitAccountChange(document.getElementById('wdesk:debt_acc_num'))" id="getCustDetails">Retry</button>
							</td>
							<td class='EWNormalGreenGeneral1 width25' id="viewsignatureB">
								<button <%=strDisableReadOnly%>  class='EWButtonRB'  onclick="openCustomDialog('View Sign','<%=workstepName%>');" id="view_sign">View Signatures</button>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<button <%=strDisableReadOnly%> class='EWButtonRB' onclick="getFcyRate('1');"  id="getFxRate">Get FX Rate</button>
							</td>											
							<td class='EWNormalGreenGeneral1 width25'>
								<button <%=strDisableReadOnly%>  class='EWButtonRB' onclick="accountBalanceDetails();" id="getAccBalance">Get Account Balance</button>
							</td>
						</tr>									
					</table>								
				</div>
			</div>
		</div>

		<div class="accordion-group">
			<div class="accordion-heading">
				<h4 class="panel-title" style="color:white;>
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel2">
						<b>Transfer Details</b>
					</a>
				</h4>
			</div>
			<div id="panel2" class="accordion-body collapse">
				<div class="accordion-inner">
					<table border='1' cellspacing='1' cellpadding='0' width=100% >							
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Transfer Amount
								<label class="mandatory" id="transferamountM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width50' colspan="2" nowrap="true">
								<input type="text" <%=strDisableReadOnly%>  style="width:60%" name="wdesk:trans_amt" id="wdesk:trans_amt"  onchange="calculateAmt();"  value='<%=((WorkdeskAttribute)attributeMap.get("trans_amt")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("trans_amt")).getValue()%>' maxlength = '100'>
								
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  id="transamtcurr" name="transamtcurr" style="width:40%" onchange="setComboValueToTextBox(this,'wdesk:transferCurr');">
								
									<option value="--Select--">--Select--</option>													
								</select>
								
								<input type="hidden"  style="width:41%" name="wdesk:transferCurr" id="wdesk:transferCurr" value='<%=((WorkdeskAttribute)attributeMap.get("transferCurr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("transferCurr")).getValue()%>'>		
							</td>
							<td class='EWNormalGreenGeneral1 width25' nowrap='nowrap'>Charges
								<label class="mandatory" id="chargesM">&nbsp;*</label>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%> class="dropdown148px" style="margin-left:91px" name="wdesk:chargesCombo" id="wdesk:chargesCombo" onchange="setComboValueToTextBox(this,'wdesk:charges')">
									<option value="--Select--">--Select--</option>
									<option value="OUR">OUR</option>
									<option value="BEN">BEN</option>
									<option value="SHA">SHA</option>
								</select>
								<input type="hidden" name="wdesk:charges" id="wdesk:charges" value='<%=((WorkdeskAttribute)attributeMap.get("charges")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("charges")).getValue()%>'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>FX Rate</td>
							<td class='EWNormalGreenGeneral1 width50' colspan="2" nowrap="true">
								<input type="text" <%=strDisableReadOnly%>  style="width:60%;" disabled name="wdesk:fcy_rate" id="wdesk:fcy_rate" value='<%=((WorkdeskAttribute)attributeMap.get("fcy_rate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("fcy_rate")).getValue()%>' maxlength = '100'>
							</td>
							<td class='EWNormalGreenGeneral1 width25' nowrap='true'>Preferential Rate
								<input type="text" <%=strDisableReadOnly%> name="wdesk:pref_rate" id="wdesk:pref_rate" style="margin-left:57px" onblur="currencyFormatPref(this);" value='<%=((WorkdeskAttribute)attributeMap.get("pref_rate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_rate")).getValue()%>' maxlength = '13'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Remittance Amount
								<label class="mandatory" id="remitamountM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width50' colspan="2" nowrap="true">
								<input type="text" <%=strDisableReadOnly%> disabled style="width:60%" name="wdesk:remit_amt_new" id="wdesk:remit_amt_new" value='<%=((WorkdeskAttribute)attributeMap.get("remit_amt_new")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remit_amt_new")).getValue()%>' maxlength = '100'>
								<input type="hidden" <%=strDisableReadOnly%> disabled style="width:60%" name="wdesk:remit_amt" id="wdesk:remit_amt" value='<%=((WorkdeskAttribute)attributeMap.get("remit_amt")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remit_amt")).getValue()%>' maxlength = '100'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  id="remitamtcurr" name="remitamtcurr" style="width:40%" onchange="setComboValueToTextBox(this,'wdesk:remit_amt_curr');">
									<option value="--Select--">--Select--</option>
								</select>
								<input type="hidden" style="width:41%" name="wdesk:remit_amt_curr" id="wdesk:remit_amt_curr" value='<%=((WorkdeskAttribute)attributeMap.get("remit_amt_curr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remit_amt_curr")).getValue()%>' maxlength = '10'>
							</td>
							<td class='EWNormalGreenGeneral1 width25' nowrap='true'>Deal Reference Code
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:deal_ref_code" style="margin-left:32px" id="wdesk:deal_ref_code" value='<%=((WorkdeskAttribute)attributeMap.get("deal_ref_code")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("deal_ref_code")).getValue()%>'  maxlength = '16'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Amount Debited From Account</td>
							<td class='EWNormalGreenGeneral1 width50' colspan="2" nowrap="true">
								<input type="text" <%=strDisableReadOnly%>  disabled style="width: 60%;"  name="wdesk:finalAmtDebitfromAcc_new" id="wdesk:finalAmtDebitfromAcc_new" value='<%=((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc_new")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc_new")).getValue()%>'>
								<input type="hidden" <%=strDisableReadOnly%>  disabled style="width: 60%;"  name="wdesk:finalAmtDebitfromAcc" id="wdesk:finalAmtDebitfromAcc" value='<%=((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc")).getValue()%>'>
								<input type="text" <%=strDisableReadOnly%>  disabled style="width: 40%;" name="acc_Curr" id="acc_Curr" value='<%=((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()%>'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<button class='EWButtonRB' id="btnValDealRef">Validate Deal Code</button>
							</td>														
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Transaction Type
								<label class="mandatory" id="transactiontypeM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width50' colspan="2" nowrap="true">
								<select <%=strHideReadOnly%> id="transtype" name="transtype" class="dropdown148px" onchange="setComboValueToTextBox(this,'wdesk:trans_type')">
										<option value="--Select--">--Select--</option>
								</select>
								<input type="hidden" name="wdesk:trans_type" id="wdesk:trans_type" value='<%=((WorkdeskAttribute)attributeMap.get("trans_type")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("trans_type")).getValue()%>' maxlength = '100'>
								<input type="hidden" name="wdesk:IsIDO" id="wdesk:IsIDO" value='<%=((WorkdeskAttribute)attributeMap.get("IsIDO")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("IsIDO")).getValue()%>' maxlength = '100'>
							</td>
							<td class='EWNormalGreenGeneral1 width25' nowrap="true">Transaction Code<label class="mandatory" id="transactioncodeM">&nbsp;*</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<select <%=strDisableReadOnly%>  id="transcode" name="transcode" class="dropdown148px" onchange="setComboValueToTextBox(this,'wdesk:trans_code')">
									<option value="--Select--">--Select--</option>
								</select>									
								<input type="hidden" style="width:51%" name="wdesk:trans_code" id="wdesk:trans_code" value='<%=((WorkdeskAttribute)attributeMap.get("trans_code")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("trans_code")).getValue()%>' maxlength = '100'>
							</td>
						</tr>
						<tr class="width100">
							<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Purpose of Payment
								<label class="mandatory" id="purposeofpaymentM">&nbsp;*</label>
							</td>
							<td width="71%" nowrap='nowrap' colspan="3" class='EWNormalGreenGeneral1'>
								<input type="text" <%=strDisableReadOnly%>  style="width: 60%;" name="wdesk:purp_of_payment1" id="wdesk:purp_of_payment1" value='<%=((WorkdeskAttribute)attributeMap.get("purp_of_payment1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("purp_of_payment1")).getValue()%>' maxlength="32">
								<br/>
								<input type="text" <%=strDisableReadOnly%>  style="width: 60%;" name="wdesk:purp_of_payment2" id="wdesk:purp_of_payment2" value='<%=((WorkdeskAttribute)attributeMap.get("purp_of_payment2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("purp_of_payment2")).getValue()%>' maxlength="32">
								<br/>
								<input type="text" <%=strDisableReadOnly%>  style="width: 60%;" name="wdesk:purp_of_payment3" id="wdesk:purp_of_payment3" value='<%=((WorkdeskAttribute)attributeMap.get("purp_of_payment3")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("purp_of_payment3")).getValue()%>' maxlength="32">
								<br/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
					
		<div class="accordion-group">
			<div class="accordion-heading">
				<h4 class="panel-title" style="color:white;>
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel3">
						<b>Beneficiary Details</b>
					</a>
				</h4>
			</div>
			<div id="panel3" class="accordion-body collapse">
				<div class="accordion-inner">
					<table border='1' cellspacing='1' cellpadding='0' width=100% >									
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Name
								<label class="mandatory">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:benef_name" id="wdesk:benef_name" value='<%=((WorkdeskAttribute)attributeMap.get("benef_name")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benef_name")).getValue()%>' maxlength = '40'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:middleName" id="wdesk:middleName" value='<%=((WorkdeskAttribute)attributeMap.get("middleName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("middleName")).getValue()%>' maxlength = '33'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:lastName" id="wdesk:lastName" value='<%=((WorkdeskAttribute)attributeMap.get("lastName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("lastName")).getValue()%>' maxlength = '33'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Beneficiary City/State/Address
								<label class="mandatory">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:beneficiaryCity" id="wdesk:beneficiaryCity" value='<%=((WorkdeskAttribute)attributeMap.get("beneficiaryCity")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("beneficiaryCity")).getValue()%>' maxlength = '35'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>A/C Number/IBAN
								<label class="mandatory" id="benCredAcM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:iban" id="wdesk:iban" value='<%=((WorkdeskAttribute)attributeMap.get("iban")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("iban")).getValue()%>' maxlength = '34'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Country of residence/Incorporation
								<label class="mandatory" id="BalSuffM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> id="countryOfResCombo" class="dropdown148px" name="countryOfResCombo" onchange="setComboValueToTextBox(this,'wdesk:countryOfRes')">										
									<option value="--Select--">--Select--</option>
								</select>
								<input type="hidden" name="wdesk:countryOfRes" id="wdesk:countryOfRes" maxlength = '100' value='<%=((WorkdeskAttribute)attributeMap.get("countryOfRes")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("countryOfRes")).getValue()%>'>
							</td>	
							<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
							<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
						</tr>
					</table>
				</div>
			</div>
		</div>							
		<div class="accordion-group">
			<div class="accordion-heading">
                <h4 class="panel-title" style="color:white;>
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel8">
						<b>Beneficiary Bank Details</b>
					</a>
                </h4>
			</div>
			<div id="panel8" class="accordion-body collapse">
                <div class="accordion-inner">
                    <table border='1' cellspacing='1' cellpadding='0' width=100% >
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Bank Name
								<label class="mandatory" id="benbanknameM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:benefBankName" id="wdesk:benefBankName" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankName")).getValue()%>' maxlength = '35'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Bank Country
								<label class="mandatory" id="benbankcountryM">&nbsp;*</label>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%> class="dropdown148px" id="benefBankCntryCombo" name="benefBankCntryCombo" onchange="setComboValueToTextBox(this,'wdesk:benefBankCntry');">
									<option value="--Select--">--Select--</option>													
								</select>
								
								<input type="hidden" name="wdesk:benefBankCntry" id="wdesk:benefBankCntry" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankCntry")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankCntry")).getValue()%>' maxlength = '100'>
							</td>																														
						</tr>
						<tr class="width100" id="benbankbranch">
							<td class='EWNormalGreenGeneral1 width25'>Bank Branch</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:benefBankBranch" id="wdesk:benefBankBranch" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankBranch")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankBranch")).getValue()%>' maxlength = '35'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Bank City/State</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:benefCityState" id="wdesk:benefCityState" value='<%=((WorkdeskAttribute)attributeMap.get("benefCityState")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefCityState")).getValue()%>' maxlength = '35'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Bank Code</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  class="dropdown148px" id="dropDownBenefBankCode"  onchange="setComboValueToTextBox(this,'wdesk:benefBankCode')">
									<option value="--Select--">--Select--</option>													
								</select>
								<input type="hidden" <%=strDisableReadOnly%>  name="wdesk:benefBankCode" id="wdesk:benefBankCode" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankCode")).getValue()%>'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:benefActualCode" id="wdesk:benefActualCode" value='<%=((WorkdeskAttribute)attributeMap.get("benefActualCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefActualCode")).getValue()%>' maxlength = '30'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>&nbsp;</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
			
		<div class="accordion-group">
			<div class="accordion-heading">
				<h4 class="panel-title" style="color:white;>
					<a class="accordion-toggle" data-toggle="collapse" data-parent="#accordion" href="#panel4">
						<b>Intermediary Details</b>
					</a>
				</h4>
			</div>
			<div id="panel4" class="accordion-body collapse">
				<div class="accordion-inner">
					<table border='1' cellspacing='1' cellpadding='0' width=100% >									
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Bank Name</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:interBankName" id="wdesk:interBankName" value='<%=((WorkdeskAttribute)attributeMap.get("interBankName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankName")).getValue()%>' maxlength = '35'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>Bank Country</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%> class="dropdown148px" id="wdesk:interBankCntryCombo" name="wdesk:interBankCntryCombo" onchange="setComboValueToTextBox(this,'wdesk:interBankCntry')">
									<option value="--Select--">--Select--</option>													
								</select>
								<input type="hidden"  name="wdesk:interBankCntry" id="wdesk:interBankCntry" value='<%=((WorkdeskAttribute)attributeMap.get("interBankCntry")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankCntry")).getValue()%>' maxlength = '100'>
							</td>									
						</tr>									
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Bank Branch</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:interBankBranch" id="wdesk:interBankBranch" value='<%=((WorkdeskAttribute)attributeMap.get("interBankBranch")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankBranch")).getValue()%>' maxlength = '35'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>City/State</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%> name="wdesk:interCityState" id="wdesk:interCityState" value='<%=((WorkdeskAttribute)attributeMap.get("interCityState")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interCityState")).getValue()%>' maxlength = '35'>
							</td>
						</tr>
						<tr class="width100">
							<td class='EWNormalGreenGeneral1 width25'>Bank Code</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  class="dropdown148px" id="dropDownInterBankCode"  onchange="setComboValueToTextBox(this,'wdesk:interBankCode')">
									<option value="--Select--">--Select--</option>													
								</select>
								<input type="hidden" <%=strDisableReadOnly%> name="wdesk:interBankCode" id="wdesk:interBankCode" value='<%=((WorkdeskAttribute)attributeMap.get("interBankCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankCode")).getValue()%>'>
							</td>
							<td class='EWNormalGreenGeneral1 width25'>
								<input type="text" <%=strDisableReadOnly%>  name="wdesk:interActualCode" id="wdesk:interActualCode" value='<%=((WorkdeskAttribute)attributeMap.get("interActualCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interActualCode")).getValue()%>' maxlength = '30'>
							</td>														
							<td class='EWNormalGreenGeneral1 width25'></td>
						</tr>
					</table>
				</div>
			</div>
			
		<input type="text" style="display:none;" name="wdesk:cut_off_time" id="wdesk:cut_off_time" value='<%=((WorkdeskAttribute)attributeMap.get("cut_off_time")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cut_off_time")).getValue()%>'>
		
		<!--Added following fields for TT_RefNum Call on done button-->
		<input type="text" style="display:none;" name="wdesk:payment_order_id" id="wdesk:payment_order_id" value='<%=((WorkdeskAttribute)attributeMap.get("payment_order_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("payment_order_id")).getValue()%>'>
		<input type="text" style="display:none;" name="wdesk:call_back_req" id="wdesk:call_back_req" value='<%=((WorkdeskAttribute)attributeMap.get("call_back_req")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("call_back_req")).getValue()%>' maxlength = '100'>
		<input type="hidden" name="wdesk:forNonComplianceEmailID" id="wdesk:forNonComplianceEmailID" value='<%=((WorkdeskAttribute)attributeMap.get("forNonComplianceEmailID")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("forNonComplianceEmailID")).getValue()%>' >
		<input type="hidden" name="wdesk:forComplianceEmailID" id="wdesk:forComplianceEmailID" value='<%=((WorkdeskAttribute)attributeMap.get("forComplianceEmailID")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("forComplianceEmailID")).getValue()%>' >
		<input type="hidden" name="wdesk:callbackFlgFinacle" id="wdesk:callbackFlgFinacle" value='<%=((WorkdeskAttribute)attributeMap.get("callbackFlgFinacle")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("callbackFlgFinacle")).getValue()%>' >
		<input type="hidden" name="wdesk:referCtryFlgFinacle" id="wdesk:referCtryFlgFinacle" value='<%=((WorkdeskAttribute)attributeMap.get("referCtryFlgFinacle")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("referCtryFlgFinacle")).getValue()%>' >
		<input type="text" style="display:none;" name="wdesk:comp_req" id="wdesk:comp_req" value='<%=((WorkdeskAttribute)attributeMap.get("comp_req")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("comp_req")).getValue()%>' maxlength = '10'>
		<input type="text" style="display:none;" name="wdesk:payment_order_status" id="wdesk:payment_order_status" value='<%=((WorkdeskAttribute)attributeMap.get("payment_order_status")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("payment_order_status")).getValue()%>'>
</div>