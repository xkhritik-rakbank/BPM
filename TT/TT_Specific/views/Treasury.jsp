<!-- Treasury View-->
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
							<tr width=100%>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'>Customer Name</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:cust_name" id="wdesk:cust_name" value='<%=((WorkdeskAttribute)attributeMap.get("cust_name")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_name")).getValue()%>' maxlength = '100'>
								</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'>Debit A/C Number</td>
								<td nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:debt_acc_num" id="wdesk:debt_acc_num" maxlength="13" value='<%=((WorkdeskAttribute)attributeMap.get("debt_acc_num")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("debt_acc_num")).getValue()%>'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Ruling Family</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:isRulingFamily" id="wdesk:isRulingFamily" value='<%=((WorkdeskAttribute)attributeMap.get("isRulingFamily")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isRulingFamily")).getValue()%>'>
									<input type="hidden" disabled name="wdesk:cust_type" id="wdesk:cust_type" value='<%=((WorkdeskAttribute)attributeMap.get("cust_type")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_type")).getValue()%>' maxlength = '100'>
								</td>										
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Customer A/C Currency
									
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:cust_acc_curr" id="wdesk:cust_acc_curr" value='<%=((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()%>' maxlength = '100'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>CIF ID</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:cif_id" id="wdesk:cif_id" value='<%=((WorkdeskAttribute)attributeMap.get("cif_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cif_id")).getValue()%>' maxlength = '7'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="solidL">SOL ID
									
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="solidF">
									<input type="text" disabled name="wdesk:sol_id" id="wdesk:sol_id" value='<%=((WorkdeskAttribute)attributeMap.get("sol_id")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sol_id")).getValue()%>'
								</td>
							</tr>
							<tr width=100% id="callbackCompliance">
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="subsegmentL">Sub-Segment</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="subsegmentF">
									<input type="text" disabled name="wdesk:sub_segment" id="wdesk:sub_segment" value='<%=((WorkdeskAttribute)attributeMap.get("sub_segment")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("sub_segment")).getValue()%>' maxlength = '10'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Balance Sufficient
									
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:bal_sufficient" id="wdesk:bal_sufficient" value='<%=((WorkdeskAttribute)attributeMap.get("bal_sufficient")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("bal_sufficient")).getValue()%>' maxlength = '100'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1L">Preferred Contact Number 1</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1F">
									<input type="text" disabled name="wdesk:pref_contact1" id="wdesk:pref_contact1" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contact1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contact1")).getValue()%>' maxlength = '100'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact2L">Preferred Contact Number 2</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact2F"> 
									<input type="text" disabled name="wdesk:pref_contact2" id="wdesk:pref_contact2" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contact2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contact2")).getValue()%>' maxlength = '100'>
								</td>
							</tr>
							<tr width=100%>																			
							<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1L">Preferred Contact Name 1</td>
							<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1F">
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:pref_contactname1" id="wdesk:pref_contactname1" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contactname1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contactname1")).getValue()%>' maxlength = '100'>
							</td>
							<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact2L">Preferred Contact Name 2</td>
							<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact2F"> 
								<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:pref_contactname2" id="wdesk:pref_contactname2" value='<%=((WorkdeskAttribute)attributeMap.get("pref_contactname2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_contactname2")).getValue()%>' maxlength = '100'>
							</td>
						</tr>
							<tr width=100%>
																	
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1L">Elite Customer</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact2F"> 
									<input type="text" disabled name="wdesk:isEliteCust" id="wdesk:isEliteCust" value='<%=((WorkdeskAttribute)attributeMap.get("isEliteCust")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isEliteCust")).getValue()%>' maxlength = '10'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1L">Application Received Original</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:isOriginalReceived" id="wdesk:isOriginalReceived" value='<%=((WorkdeskAttribute)attributeMap.get("isOriginalReceived")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("isOriginalReceived")).getValue()%>' maxlength = '10'>
								</td>					
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact1L">Relationship Manager</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1' id="pcontact2F"> 
									<input type="text" disabled name="wdesk:rel_manager" id="wdesk:rel_manager" value='<%=((WorkdeskAttribute)attributeMap.get("rel_manager")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("rel_manager")).getValue()%>' maxlength = '10'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Account Balance</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:acc_bal" id="wdesk:acc_bal" value='<%=((WorkdeskAttribute)attributeMap.get("acc_bal")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("acc_bal")).getValue()%>' maxlength = '100'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>RM Code</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:RMCode" id="wdesk:RMCode" value='<%=((WorkdeskAttribute)attributeMap.get("RMCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("RMCode")).getValue()%>' maxlength = '10'>
								</td>
								<td class='EWNormalGreenGeneral1 width25'>Authorized Signatory Submission</td>
							<td class='EWNormalGreenGeneral1 width25'>
								
								<input type="text" disabled name="wdesk:authorized_sign" id="wdesk:authorized_sign" value='<%=((WorkdeskAttribute)attributeMap.get("authorized_sign")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("authorized_sign")).getValue()%>'> 
							</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Customer Address</td>
								<td width="71%" nowrap='nowrap' colspan="3" class='EWNormalGreenGeneral1'>
									<textarea style="width:100%" disabled name="wdesk:custAddress" rows="3" cols="33" maxlength="1000" onkeypress="if (this.value.length > 1000) { return false; }" maxlength ="1000" id="wdesk:custAddress"><%=customerAddress%></textarea>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<button <%=strDisableReadOnly%>  class='EWButtonRB' onclick="openCustomDialog('Exception History','<%=workstepName%>');" id="view_raise_excep">View/Raise Exceptions</button>
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
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
							<tr width=100%>
								<td width="30%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Transfer Amount</td>
								<td width="60%" colspan="2"  nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled style="width:75%" name="wdesk:trans_amt" id="wdesk:trans_amt" value='<%=((WorkdeskAttribute)attributeMap.get("trans_amt")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("trans_amt")).getValue()%>' maxlength = '100'>							
									<input type="text" disabled  style="width:25%" name="wdesk:transferCurr" id="wdesk:transferCurr" value='<%=((WorkdeskAttribute)attributeMap.get("transferCurr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("transferCurr")).getValue()%>'>		
								</td>
								<td width="10%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Charges&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="text" disabled name="wdesk:charges" id="wdesk:charges" value='<%=((WorkdeskAttribute)attributeMap.get("charges")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("charges")).getValue()%>'>
								</td>		
							</tr>
							<tr width=100%>
								<td width="30%" nowrap='nowrap' class='EWNormalGreenGeneral1'>FX Rate</td>
								<td width="60%" colspan="2" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" style="width:75%" disabled name="wdesk:fcy_rate" id="wdesk:fcy_rate" value='<%=((WorkdeskAttribute)attributeMap.get("fcy_rate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("fcy_rate")).getValue()%>' maxlength = '100'>
								</td>
								<td width="10%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Preferential Rate &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="text" name="wdesk:pref_rate" id="wdesk:pref_rate" disabled onblur="currencyFormatPref(this);" value='<%=((WorkdeskAttribute)attributeMap.get("pref_rate")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("pref_rate")).getValue()%>' maxlength = '13'>
								</td>								
							</tr>
							<tr width=100%>
								<td width="30%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Remittance Amount</td>
								<td width="60%" colspan="2" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled style="width:75%" name="wdesk:remit_amt_new" id="wdesk:remit_amt_new" value='<%=((WorkdeskAttribute)attributeMap.get("remit_amt_new")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remit_amt_new")).getValue()%>' maxlength = '100'>
									<input type="hidden" disabled style="width:75%" name="wdesk:remit_amt" id="wdesk:remit_amt" value='<%=((WorkdeskAttribute)attributeMap.get("remit_amt")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remit_amt")).getValue()%>' maxlength = '100'>
									<input type="text" disabled style="width:25%" name="wdesk:remit_amt_curr" id="wdesk:remit_amt_curr" value='<%=((WorkdeskAttribute)attributeMap.get("remit_amt_curr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("remit_amt_curr")).getValue()%>' maxlength = '10'>
								</td>
								<td width="10%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Deal Reference Code&nbsp;
									<input type="text" disabled name="wdesk:deal_ref_code" id="wdesk:deal_ref_code" value='<%=((WorkdeskAttribute)attributeMap.get("deal_ref_code")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("deal_ref_code")).getValue()%>'  maxlength = '16'>
								</td>
							</tr>
							<tr width=100%>
								<td width="30%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Amount Debited From Account</td>
								<td width="60%" colspan="2" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled style="width: 75%;"  name="wdesk:finalAmtDebitfromAcc_new" id="wdesk:finalAmtDebitfromAcc_new" value='<%=((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc_new")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc_new")).getValue()%>'>
									<input type="hidden" disabled style="width: 75%;"  name="wdesk:finalAmtDebitfromAcc" id="wdesk:finalAmtDebitfromAcc" value='<%=((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("finalAmtDebitfromAcc")).getValue()%>'>
									<input type="text" disabled style="width: 25%;" name="acc_Curr" id="acc_Curr" value='<%=((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("cust_acc_curr")).getValue()%>'>
								</td>
								<td width="10%" nowrap='nowrap' class='EWNormalGreenGeneral1'>&nbsp;</td>
							</tr>
							<tr width=100%>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Transaction Type</td>
								<td width="29%" colspan="2" nowrap='nowrap' class='EWNormalGreenGeneral1'>											
										<input type="text" disabled style="width:75%" name="trans_type" id="trans_type" value='<%=((WorkdeskAttribute)attributeMap.get("trans_type")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("trans_type")).getValue()%>' maxlength = '100'>
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Transaction Code									
									<input type="text"  disabled style="WIDTH: 148px; MARGIN-LEFT: 18%" name="trans_code" id="trans_code" value='<%=((WorkdeskAttribute)attributeMap.get("trans_code")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("trans_code")).getValue()%>' maxlength = '100'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Purpose of Payment</td>
								<td width="71%" nowrap='nowrap' colspan="3" class='EWNormalGreenGeneral1'>
									<input type="text"  disabled style="width: 60%;" name="wdesk:purp_of_payment1" id="wdesk:purp_of_payment1" maxlength="32"
								value='<%=((WorkdeskAttribute)attributeMap.get("purp_of_payment1")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("purp_of_payment1")).getValue()%>'><br/>
								<input type="text" disabled style="width: 60%;" name="wdesk:purp_of_payment2" id="wdesk:purp_of_payment2" maxlength="32"
								value='<%=((WorkdeskAttribute)attributeMap.get("purp_of_payment2")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("purp_of_payment2")).getValue()%>'><br/>
								<input type="text" disabled style="width: 60%;" name="wdesk:purp_of_payment3" id="wdesk:purp_of_payment3" maxlength="32"
								value='<%=((WorkdeskAttribute)attributeMap.get("purp_of_payment3")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("purp_of_payment3")).getValue()%>'><br/>
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
						<table border='1' cellspacing='1' cellpadding='0' width=100%>									
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Name<label class="mandatory">&nbsp;*</label></td>							
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%> disabled name="wdesk:benef_name" id="wdesk:benef_name" value='<%=((WorkdeskAttribute)attributeMap.get("benef_name")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benef_name")).getValue()%>' maxlength = '35'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%> disabled name="wdesk:middleName" id="wdesk:middleName" value='<%=((WorkdeskAttribute)attributeMap.get("middleName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("middleName")).getValue()%>' maxlength = '33'>
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%> disabled name="wdesk:lastName" id="wdesk:lastName" value='<%=((WorkdeskAttribute)attributeMap.get("lastName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("lastName")).getValue()%>' maxlength = '33'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Beneficiary City/State/Address
									<label class="mandatory">&nbsp;*</label>
								</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%> disabled name="wdesk:beneficiaryCity" id="wdesk:beneficiaryCity" value='<%=((WorkdeskAttribute)attributeMap.get("beneficiaryCity")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("beneficiaryCity")).getValue()%>' maxlength = '35'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>A/C Number/IBAN</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:iban" id="wdesk:iban" value='<%=((WorkdeskAttribute)attributeMap.get("iban")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("iban")).getValue()%>' maxlength = '34'>
								</td>
							</tr>
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Country of residence/Incorporation</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'> 
									<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:countryOfRes" id="wdesk:countryOfRes" value='<%=((WorkdeskAttribute)attributeMap.get("countryOfRes")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("countryOfRes")).getValue()%>' maxlength = '100'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>
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
								<tr width=100%>
									<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Name</td>
									<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
										<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:benefBankName" id="wdesk:benefBankName" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankName")).getValue()%>' maxlength = '35'>
										<!--input type="text" disabled name="wdesk:benefBankName" id="wdesk:benefBankName" value=''-->
									</td>
									<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Country
									</td>
									<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>

									<select <%=strHideReadOnly%> <%=strDisableReadOnly%>  style="width:139px;display:none" id="benefBankCntryCombo" name="benefBankCntryCombo" onchange="setComboValueToTextBox(this,'wdesk:benefBankCntry')">
										<option value="--Select--">--Select--</option>													
									</select>
									<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:benefBankCntry" id="wdesk:benefBankCntry" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankCntry")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankCntry")).getValue()%>' maxlength = '100'>
									</td>	
									
									</tr>
								<tr width=100% id="benbankbranch">
									<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Branch
									</td>
									<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
										<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:benefBankBranch" id="wdesk:benefBankBranch" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankBranch")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankBranch")).getValue()%>' maxlength = '35'>
									</td>
									<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank City/State
										</td>
										<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
											<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:benefCityState" id="wdesk:benefCityState" value='<%=((WorkdeskAttribute)attributeMap.get("benefCityState")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefCityState")).getValue()%>' maxlength = '35'>
										</td>
										
								</tr>
								<tr width=100%>
										<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Code
									</td>
									<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
										<input type="text" <%=strDisableReadOnly%>  disabled name="wdesk:benefBankCode" id="wdesk:benefBankCode" value='<%=((WorkdeskAttribute)attributeMap.get("benefBankCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefBankCode")).getValue()%>' maxlength = '30'>
									</td>																											
										<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
											<input type="text" <%=strDisableReadOnly%> disabled name="wdesk:benefActualCode" id="wdesk:benefActualCode" value='<%=((WorkdeskAttribute)attributeMap.get("benefActualCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("benefActualCode")).getValue()%>' maxlength = '100'>
										</td>	
										<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>										
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
							<tr width=100%>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Name</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:interBankName" id="wdesk:interBankName" value='<%=((WorkdeskAttribute)attributeMap.get("interBankName")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankName")).getValue()%>' maxlength = '35'>
								</td>
										<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Country</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:interBankCntry" id="wdesk:interBankCntry" value='<%=((WorkdeskAttribute)attributeMap.get("interBankCntry")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankCntry")).getValue()%>' maxlength = '100'>
								</td>							
							</tr>									
							<tr width=100% id="intbankbranch">
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Branch</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:interBankBranch" id="wdesk:interBankBranch" value='<%=((WorkdeskAttribute)attributeMap.get("interBankBranch")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankBranch")).getValue()%>' maxlength = '35'>
								</td>
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>City/State</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:interCityState" id="wdesk:interCityState" value='<%=((WorkdeskAttribute)attributeMap.get("interCityState")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interCityState")).getValue()%>' maxlength = '35'>
								</td>	
								
							</tr>
							<tr width=100% id="intbankcountry">								
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>Bank Code</td>
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" disabled name="wdesk:interBankCode" id="wdesk:interBankCode" value='<%=((WorkdeskAttribute)attributeMap.get("interBankCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interBankCode")).getValue()%>' maxlength = '35'>
								</td>								
								<td width="29%" nowrap='nowrap' class='EWNormalGreenGeneral1'>
									<input type="text" <%=strDisableReadOnly%> disabled name="wdesk:interActualCode" id="wdesk:interActualCode" value='<%=((WorkdeskAttribute)attributeMap.get("interActualCode")).getValue()==null?"":((WorkdeskAttribute)attributeMap.get("interActualCode")).getValue()%>' maxlength = '100'>
								</td>		
								<td width="21%" nowrap='nowrap' class='EWNormalGreenGeneral1'></td>
							</tr>
						</table>
					</div>
				</div>
</div>