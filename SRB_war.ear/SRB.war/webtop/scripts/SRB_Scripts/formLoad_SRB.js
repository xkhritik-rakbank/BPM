/*------------------------------------------------------------------------------------------------------
                                                NEWGEN SOFTWARE TECHNOLOGIES LIMITED
Group                                       									: Application -Projects
Project/Product                                               					: RAKBANK- SRM
Application                                                      				: Service Request Module 
Module                                                            				: Custom Validations 
File Name                                                       				: Custom_Validations.js		 	
Author                                                             				: Deepti Sharma
Date (DD/MM/YYYY)                         										: 17-Apr-2014
Description                                                      				: This file contains all function definitions
																				  required at form load for every service request
-------------------------------------------------------------------------------------------------------
CHANGE HISTORY
-------------------------------------------------------------------------------------------------------

Problem No/CR No   Change Date   Changed By    Change Description
------------------------------------------------------------------------------------------------------*/

var insurancealertcount=0;
function Trim(val,character)
{
        if(typeof character=='undefined')
		character = ' ';

	val = new String(val);
	var len = val.length;
        if(len != 0)
	{
		while(1)
		{
			if(val.charAt(0) != character)
			{
				break;
			}
			else
			{
				val = val.substr(1);
			}
		}
	}

	len = val.length;
	if(len != 0)
	{
		while(1)
		{
			if(val.charAt(len - 1) != character)
			{
				return val;
			}
			else
			{
				len -= 1;
				val = val.substr(0,len);
			}
		}
	}
        return val;
}


function clickFunction(event,labelname)
{
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	var WSNAME = document.getElementById("WS_NAME").value;
	
	if(SubCategoryID=='1' && CategoryID=='1' )
	{
		if(!(WSNAME=='Introduction' ||  WSNAME=='PBO'))
		{
			if(event=='onclick')
			{
				if(labelname=='Decision')
				{
					var decisionElement = document.getElementById("1_Decision");
					var selectedValue = decisionElement.options[decisionElement.selectedIndex].value;
					if(selectedValue=='Reject')
					{
						var declineRElement = document.getElementById("1_Decline_Reason");
						document.getElementById("1_Decline_Reason").disabled=false;
					}
					else
					{
						var declineRElement = document.getElementById("1_Decline_Reason");
						document.getElementById("1_Decline_Reason").value='--Select--';
						document.getElementById("1_Decline_Reason").disabled=true;
					}
				}
			}
			if(event=='onblur')
			{
				if(labelname=='Approved CB Amt')
				{
					if(parseInt(document.getElementById("1_Approved_Cash_Back_Amount").value)>parseInt(document.getElementById("1_Cash_Back_Eligible_Amount").value)||parseInt(document.getElementById("1_Approved_Cash_Back_Amount").value)>parseInt(document.getElementById("1_Requested_Cash_Back_Amount").value))
					{	
						alert("Amount to be approved is more than eligible or requested cash back.");
						document.getElementById("1_Approved_Cash_Back_Amount").focus();
						return false;
					}
				}
				
			}
		}
		else if(WSNAME=='Introduction' ||  WSNAME=='PBO')
		{
			if(labelname=='Requested CB Amt')
			{
				document.getElementById("1_Approved_Cash_Back_Amount").value=document.getElementById("1_Requested_Cash_Back_Amount").value;
			}
		}
		else
		{
		
			/*if(event=='onblur')
			{
				if(labelname=='Requested CB Amt')
				{	
					if(parseInt(document.getElementById("1_Requested_Cash_Back_Amount").value)>parseInt(document.getElementById("1_Cash_Back_Eligible_Amount").value))
					{	
						if(parseInt(document.getElementById("1_Cash_Back_Eligible_Amount").value)>100)
						{	
							//alert("aishwarya");
							document.getElementById("1_Requested_Cash_Back_Amount").value=document.getElementById("1_Cash_Back_Eligible_Amount").value;
							document.getElementById("1_Approved_Cash_Back_Amount").value=document.getElementById("1_Cash_Back_Eligible_Amount").value;
							//alert("Requested Cash Back Amount cannot be greater than "+document.getElementById("1_Cash_Back_Eligible_Amount").value+".");
							document.getElementById("1_Requested_Cash_Back_Amount").focus();
							return false;
						}
					}
					else				
					{	
						if(parseInt(document.getElementById("1_Requested_Cash_Back_Amount").value)<100)
						{	
							if(parseInt(document.getElementById("1_Cash_Back_Eligible_Amount").value)>=100)
							{	alert("Requested Cash Back Amount cannot be less than 100.");
								document.getElementById("1_Requested_Cash_Back_Amount").focus();
							document.getElementById("1_Requested_Cash_Back_Amount").value=document.getElementById("1_Cash_Back_Eligible_Amount").value;
							document.getElementById("1_Approved_Cash_Back_Amount").value=document.getElementById("1_Cash_Back_Eligible_Amount").value;
							}
							return false;
						}
						else
							document.getElementById("1_Approved_Cash_Back_Amount").value=document.getElementById("1_Requested_Cash_Back_Amount").value;
					}
				}
			}
			if(event=='onchange')
			{
					if(labelname=='Requested CB Amt')
				{	
					if(!(parseInt(document.getElementById("1_Requested_Cash_Back_Amount").value)>parseInt(document.getElementById("1_Cash_Back_Eligible_Amount").value)))
					{	
						if(parseInt(document.getElementById("1_Requested_Cash_Back_Amount").value)<100)
						{	
							if(parseInt(document.getElementById("1_Cash_Back_Eligible_Amount").value)<100)
							{	alert("Requested Cash Back Amount cannot be less than 100.");
								document.getElementById("1_Requested_Cash_Back_Amount").focus();
							document.getElementById("1_Requested_Cash_Back_Amount").value=document.getElementById("1_Cash_Back_Eligible_Amount").value;
							document.getElementById("1_Approved_Cash_Back_Amount").value=document.getElementById("1_Cash_Back_Eligible_Amount").value;
							}
							return false;
						}
						else
							document.getElementById("1_Approved_Cash_Back_Amount").value=document.getElementById("1_Requested_Cash_Back_Amount").value;
					}
				} 				
			
			}*/
					
		}


	}
	else if(SubCategoryID=='4' && CategoryID=='1' ) //For CCC
	{
		
		if((WSNAME=='Introduction' ||  WSNAME=='PBO'))
		{
			if(event=='onchange')
			{	
				
				if(labelname=='Payment By')
				{	
					if(document.getElementById("4_payment_by").value=='MCQ')
					{
						document.getElementById("4_delivery_channel").disabled=false;
					}else{
						document.getElementById("4_delivery_channel").value='--Select--';
						document.getElementById("4_delivery_channel").disabled=true;
						document.getElementById("4_branch_name").value='--Select--';
						document.getElementById("4_branch_name").disabled=true;
					}
				}else if(labelname=='Delivery Channel')
				{	
					if(document.getElementById("4_delivery_channel").value=='Branch')
					{
						document.getElementById("4_branch_name").disabled=false;
					}else{
						document.getElementById("4_branch_name").value='--Select--';
						document.getElementById("4_branch_name").disabled=true;
					}
				}else if(labelname=='Rakbank Eligible Card No.')
				{
					if(document.getElementById('4_rakbank_eligible_card_no').value=='--Select--')						{							document.getElementById("4_marketing_code").value ='';							document.getElementById("4_ccc_amt_req").value='';							document.getElementById("4_beneficiary_name").value='';							document.getElementById("4_payment_by").value='--Select--';							document.getElementById("4_delivery_channel").value='--Select--';							document.getElementById("4_delivery_channel").disabled=true;							document.getElementById("4_branch_name").value='--Select--';							document.getElementById("4_branch_name").disabled=true;    							document.getElementById("4_remarks").value='';							return;						}
					document.getElementById("4_eligibility").value='';
					
					var selGridWIData = document.getElementById("CARD DETAILS_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
					var obj = JSON.parse(selGridWIData);
					var valueRakCardNo = obj['card_no'];
					var arrValueRakCardNo = valueRakCardNo.split("@");
					var Purpose = '';
					var valuePurpose = obj['Purpose'];
					var arrValuePurpose = valuePurpose.split("@");
					for(var i=0;i<arrValueRakCardNo.length;i++)

					{
						if(arrValueRakCardNo[i]==document.getElementById('4_rakbank_eligible_card_no').value){
							 Purpose = arrValuePurpose[i];
							continue;
						}
					}
					var marketingCode = '';
					//alert(Purpose);
					/*if(Purpose=='Payment to any third party other than those mentioned above' ){
						marketingCode='TPC';
					}else if(Purpose=='If issued in the name of Cardholder (self)'){
						marketingCode = 'SEC';
					}else{
						marketingCode = 'BCC';
					}*/
					var marketingcoderesp = getSelectResponseAjax('usr_0_srm_ccc_purpose_master',Purpose.split("%").join("CHARPERCENTAGE").split("&").join("CHARAMPERSAND"),'marketingcode');
					var response = marketingcoderesp.split("~");
					if(response[0]=='0')
					{
						marketingCode = response[1];
					}
					else
					{
						alert("Error in getting marketing code");
						return false;
					}
					//alert(marketingCode);
					document.getElementById("4_marketing_code").value =  marketingCode;
					document.getElementById("4_ccc_amt_req").value='';
					document.getElementById("4_beneficiary_name").value='';
					document.getElementById("4_payment_by").value='--Select--';
					document.getElementById("4_delivery_channel").value='--Select--';
					document.getElementById("4_delivery_channel").disabled=true;
					document.getElementById("4_branch_name").value='--Select--';
					document.getElementById("4_branch_name").disabled=true;	
					document.getElementById("4_remarks").value='';
					
				}else if(labelname=='CCC Amt Requested')
				{
					document.getElementById("4_eligibility").value='';
					if(document.getElementById("4_ccc_amt_req").value!='')
					{
						document.getElementById("4_ccc_amt_req").value = getThousandSeparatedValue(document.getElementById("4_ccc_amt_req").value);
					}
					var strJsonCardDetail = document.getElementById('CARD DETAILS_4_gridbundleJSON_WIDATA').value;
					var objCardDetail = JSON.parse(strJsonCardDetail);
					var cardNo = objCardDetail["card_no"];
					var arrCardNo = cardNo.split("@");
					var eligibleAmt = objCardDetail["eligible_amount"];
					var arrEligibleAmt = eligibleAmt.split("@");
					var CCCRequired = objCardDetail["ccc_required"];
					var arrCCCRequired = CCCRequired.split("@");
						
					
					var strJsonCCC = document.getElementById('CREDIT CARD CHEQUE DETAILS_4_gridbundleJSON_WIDATA').value;	
					var objCCC = JSON.parse(strJsonCCC);
					var eligibleCardNo = objCCC["rakbank_eligible_card_no"];
					var arrEligibleCardNo = eligibleCardNo.split("@");
					var CCCAmtReq = objCCC["ccc_amt_req"];
					var arrCCCAmtReq = CCCAmtReq.split("@");
					
								
					var totalCCCAmtReq = 0;
					var totalReqAmount=0;			
					for(var i=0;i<arrCardNo.length;i++)
					{
						if(arrCCCRequired[i]=='Yes')
						{
								
							if(document.getElementById('4_rakbank_eligible_card_no').value==arrCardNo[i])
							{
								
								for(var j=0;j<arrEligibleCardNo.length;j++)
								{
									
									if(document.getElementById('4_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
									{
										totalReqAmount+=parseFloat(arrCCCAmtReq[j].split(',').join(''));
									}
								
								}
								
								var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
								var reqAmmt =parseFloat(document.getElementById('4_ccc_amt_req').value.split(',').join(''));
								totalReqAmount+=reqAmmt;
								
								if(eligAmmt<totalReqAmount)
								{
									alert("Sum of CCC requested amount should not exceed the CCC eligible amount for card no. " + arrCardNo[i]+".");
									document.getElementById('4_ccc_amt_req').focus();
									return false;
								}
							}
						}
					}					
				}else if(labelname=='Beneficiary Name')
				{
					document.getElementById("4_eligibility").value='';
				}else if(labelname=='Marketing Code')
				{
					document.getElementById("4_eligibility").value='';
				}else if(labelname=='Sales Agent ID')
				{
					document.getElementById("4_source_code").value=document.getElementById('4_sales_agent_id').value;
				}else if(labelname=='CCC Required')
				{
					if(document.getElementById("4_ccc_required").checked==true)
					{
						if(document.getElementById("4_card_status").value=="NORI" || document.getElementById("4_card_status").value=="NEWR")
						{
							alert("Card status is "+document.getElementById("4_card_status").value+"- Card Activation is required - cannot proceed with CCC request.");
							document.getElementById("4_ccc_required").checked = false;
							document.getElementById("4_Purpose").value=='--Select--';
							document.getElementById("4_Purpose").disabled = true;
							document.getElementById("Check Card Eligibility").disabled = true;
							return false;	
						}
						document.getElementById("Check Card Eligibility").disabled=false;	
						document.getElementById("4_Purpose").disabled=false;	
					}else
					{
						//added for save on uncheck of ccc required
						var cardDetailsData = JSON.parse(document.getElementById('CARD DETAILS'+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value);
						var CCCCardDetailsData = JSON.parse(document.getElementById('CREDIT CARD CHEQUE DETAILS'+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value);
						
						if(CCCCardDetailsData['rakbank_eligible_card_no'].indexOf(document.getElementById('4_card_no').value)>-1)
						{
							alert("Please remove the card from Credit Card Cheque Details first.");
							document.getElementById("4_ccc_required").checked=true;
							return false;
						}	
						
						document.getElementById("Check Card Eligibility").disabled=true;
						document.getElementById("4_Purpose").disabled=true;
						document.getElementById("4_Purpose").value='--Select--';
						document.getElementById("4_eligible_amount").value='';			
						document.getElementById("4_card_eligibility").value='';							
						document.getElementById("4_non_eligibility_reasons").value='';	

						var colList=document.getElementById('CARD DETAILS_ColumnList').value;
						colList = colList.replace('[','');
						colList = colList.replace(']','');
						var frName="CARD DETAILS";
						//alert('calling');
						if(!ModifyGridValuesOnButtonClick(colList,frName,SubCategoryID))
						{
							return false;
						}						
					}
				}
				else if(labelname=='No Action')
				{
					document.getElementById("4_auth_code").value='';
					document.getElementById("4_auth_code").disabled=true;
				}
				else if(labelname=='Manual Blocking Done')
				{
					document.getElementById("4_auth_code").disabled=false;
				}	
				else if(labelname=='Manual Blocking Not Done')
				{
					document.getElementById("4_auth_code").value='';
					document.getElementById("4_auth_code").disabled=true;
				}	
					
			}
		}else if (WSNAME=='Q1')
		{
			if(event=='onchange')
			{
				
				if(labelname=='Manual Unblocking')
				{
					if(document.getElementById("4_manual_unblock").checked ==true)
					{
						alert("Amount has to be unblocked manually in ONLINE.");
						document.getElementById("Cancel").disabled = true;
					}else{
						document.getElementById("Cancel").disabled = false;
					}
				}
			}
		}
		
		if(event=='onblur')
		{
			if(labelname=='Authorization Code')
			{
				var integrationStatus=parent.document.getElementById("wdesk:IntegrationStatus").value;
				//alert(integrationStatus);
				//code added to enter auth code only on manual blocking done
				var myradio1 = document.getElementsByName('4_manual_blocking_action');
				var y = 0;
				var ManualBlockingActionChecked = false;
				var ManualBlockingActionValue = '';
				for(y = 0; y < myradio1.length; y++)
				{
					if(myradio1[y].checked)
					{
						ManualBlockingActionChecked=true;
						ManualBlockingActionValue=myradio1[y].value;
					}
				}
				//var regex=/^[X0-9]/;
				
				var regex=new RegExp('^[0-9]*$');
				if(!regex.test(document.getElementById("4_auth_code").value) && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done')
				{	
					alert("Only numerics are allowed in Authorization Code.");
					document.getElementById("4_auth_code").value="";
					document.getElementById("4_auth_code").focus();
					return false;
				}
				if((document.getElementById("4_auth_code").value).length!=6 && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done' && document.getElementById("4_auth_code").value!='')
				{
					alert("Length of Authorization Code should be exactly 6 digits.");
					document.getElementById("4_auth_code").focus();
					return false;
				}
				
			}
		}
	}
	else if(SubCategoryID=='2' && CategoryID=='1') 			//for BT
	{
		if((WSNAME=='Introduction' ||  WSNAME=='PBO'))
		{
			if(event=='onchange')
			{				

				if(labelname=='BT Required')
				{	
					if(document.getElementById("2_bt_required").checked==true)
					{
						if(document.getElementById("2_card_status").value=="NORI" || document.getElementById("2_card_status").value=="NEWR")
						{
							alert("Card status is "+document.getElementById("2_card_status").value+"- Card Activation is required - cannot proceed with BT request");
							document.getElementById("2_bt_required").checked = false;
							document.getElementById("Check Card Eligibility").disabled = true;
							return false;	
						}
						document.getElementById("Check Card Eligibility").disabled=false;			
								
					}else
					{
						//added for save on uncheck of ccc required
						var cardDetailsData = JSON.parse(document.getElementById('CARD DETAILS'+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value);
						var BTCardDetailsData = JSON.parse(document.getElementById('BALANCE TRANSFER DETAILS'+"_"+SubCategoryID+'_gridbundleJSON_WIDATA').value);
						
						if(BTCardDetailsData['rakbank_eligible_card_no'].indexOf(document.getElementById('2_rak_card_no').value)>-1)
						{
							alert("Please remove the card from Balance Transfer Details first.");
							document.getElementById("2_bt_required").checked=true;
							return false;
						}	
						
						document.getElementById("Check Card Eligibility").disabled=true;
						document.getElementById("2_eligible_amount").value='';			
						document.getElementById("2_card_eligibility").value='';							
						document.getElementById("2_non_eligibility_reasons").value='';	

						// change for save on this button click
						var colList=document.getElementById('CARD DETAILS_ColumnList').value;
						colList = colList.replace('[','');
						colList = colList.replace(']','');
						var frName="CARD DETAILS";
						if(!ModifyGridValuesOnButtonClick(colList,frName,SubCategoryID))
						{
							return false;
						}							
					}
					
				} 
					
				if(labelname=='Payment By')
				{	
					if(document.getElementById("2_payment_by").value=='MCQ')
					{
						document.getElementById("2_delivery_channel").disabled=false;
					}else{
						document.getElementById("2_delivery_channel").value='--Select--';
						document.getElementById("2_delivery_channel").disabled=true;
						document.getElementById("2_branch_name").value='--Select--';
						document.getElementById("2_branch_name").disabled=true;
					}
				}
				
				if(labelname=='Sales Agent ID')
				{	
					if(document.getElementById("2_delivery_channel").value=='Branch')
					{
						document.getElementById("2_branch_name").disabled=false;
					}else{
						document.getElementById("2_branch_name").value='--Select--';
						document.getElementById("2_branch_name").disabled=true;
					}
				}
				
				if(labelname=='Delivery Channel')
				{	
					if(document.getElementById("2_delivery_channel").value=='Branch')
					{
						document.getElementById("2_branch_name").disabled=false;
					}else{
						document.getElementById("2_branch_name").value='--Select--';
						document.getElementById("2_branch_name").disabled=true;
					}
				}
				
				if(labelname=='Rakbank Eligible Card No.')
				{
					document.getElementById("2_eligibility").value='';
					
						document.getElementById("2_name_on_card").disabled = false;
						var selGridWIData = document.getElementById("CARD DETAILS_"+SubCategoryID+'_gridbundleJSON_WIDATA').value;
						var obj = JSON.parse(selGridWIData);
						var valueRakCardNo = obj['rak_card_no'];
						var arrValueRakCardNo = valueRakCardNo.split("@");
						var cardHolderName = '';
						var valueCardHolderName = obj['card_holder_name'];
						var arrValueCardHolderName = valueCardHolderName.split("@");
						for(var i=0;i<arrValueRakCardNo.length;i++)

						{
							if(arrValueRakCardNo[i]==document.getElementById("2_rakbank_eligible_card_no").value){
								cardHolderName = arrValueCardHolderName[i];
								continue;
							}
						}
						document.getElementById("2_name_on_card").value = cardHolderName;
						document.getElementById("2_bt_amt_req").value='';
						document.getElementById("2_other_bank_card_type").value='--Select--';
						document.getElementById("2_other_bank_card_no").value='';
						document.getElementById("2_type_of_bt").value='--Select--';
						document.getElementById("2_other_bank_name").value='--Select--';
						document.getElementById("2_remarks").value='';
						document.getElementById("2_payment_by").value='--Select--';
						document.getElementById("2_delivery_channel").value='--Select--';
						document.getElementById("2_delivery_channel").disabled=true;
						document.getElementById("2_branch_name").value='--Select--';
						document.getElementById("2_branch_name").disabled=true;		
				}
				if(labelname=='Other Bank Name')
				{
					var frmOtherBankName = document.getElementById('2_other_bank_name').value;
					//document.getElementById("2_eligibility").value='';
					
					var paymentby = document.getElementById('2_payment_by');
					paymentby.options.length = 0;
					var resp=getSelectResponseAjax('usr_0_srm_otherbankcodes_master',frmOtherBankName.split("&").join("CHARAMPERSAND").split("%").join("CHARPERCENTAGE"));
					var ResponseList = resp.split("~");
					if(ResponseList[0]=='0')
					{
						
						var paymenttypes = Trim1(ResponseList[1]).split(",");
						//alert("I am here "+paymenttypes.length);
						if(paymenttypes.length==1 /*&& Trim1(paymenttypes[0])=='MCQ'*/)
						{
							//alert(Trim1(paymenttypes[0]));
							
							paymentby.options[paymentby.options.length] = new Option(Trim1(paymenttypes[0]),Trim1(paymenttypes[0]));
							document.getElementById('2_payment_by').value = Trim1(paymenttypes[0]);
							
							document.getElementById('2_delivery_channel').disabled = false;
							document.getElementById('2_payment_by').disabled = true;
							
						}
						else
						{
							var paymentTypeFound=false;
							document.getElementById('2_payment_by').disabled = false;
							var paymentby = document.getElementById('2_payment_by');
			
							// for (var i = 0; i < paymentby.options.length; i++) 
							// {
								// paymentTypeFound=false;
								// if(paymentby.options[i].text=='--Select--')
									// continue;
								// for(var k=0;k<paymenttypes.length;k++)
								// {
									// if (paymentby.options[i].text== Trim1(paymenttypes[k]))
									// {
										// paymentTypeFound = true;
									// }
								// }
								// if(!paymentTypeFound)
									// paymentby.remove(i);
							// }
							//var select = document.getElementById("DropList");
							//var length = paymentby.options.length;
							//for (i = 0; i < length; i++) {
							//  paymentby.options[i] = null;
							//}
							// for (var i = 0; i < paymentby.options.length; i++) 
							// {
								// paymentby.remove(i);
							// }
							
							paymentby.options[paymentby.options.length] = new Option('--Select--','--Select--');
							for(var k=0;k<paymenttypes.length;k++)
							{
								paymentby.options[paymentby.options.length] = new Option(paymenttypes[k],paymenttypes[k]);
							}
								

							document.getElementById('2_payment_by').value='--Select--';
							document.getElementById('2_delivery_channel').disabled = false;
						}
					}
					else
					{
						alert("Error in getting payment types from masters");
						return false;
					}
					
				}
				else if(labelname=='BT Amount Requested')
				{	
					document.getElementById("2_eligibility").value='';
					if(document.getElementById("2_bt_amt_req").value!='')
					{
						document.getElementById("2_bt_amt_req").value = getThousandSeparatedValue(document.getElementById("2_bt_amt_req").value);
					}
					var strJsonCardDetail = document.getElementById('CARD DETAILS_2_gridbundleJSON_WIDATA').value;
					var objCardDetail = JSON.parse(strJsonCardDetail);
					var cardNo = objCardDetail["rak_card_no"];
					var arrCardNo = cardNo.split("@");
					var eligibleAmt = objCardDetail["eligible_amount"];
					var arrEligibleAmt = eligibleAmt.split("@");
					var bTRequired = objCardDetail["bt_required"];
					var arrBTRequired = bTRequired.split("@");
						
					
					var strJsonBT = document.getElementById('BALANCE TRANSFER DETAILS_2_gridbundleJSON_WIDATA').value;		
					var objBT = JSON.parse(strJsonBT);
					var eligibleCardNo = objBT["rakbank_eligible_card_no"];
					var arrEligibleCardNo = eligibleCardNo.split("@");
					var btAmtReq = objBT["bt_amt_req"];
					var arrBTAmtReq = btAmtReq.split("@");
					
					var btSubRefNo = objBT["sub_ref_no"];
					var arrBTSubRefNo = btSubRefNo.split("@");
					
					var otherBankCardNo = objBT["other_bank_card_no"];
					var arrotherBankCardNo = otherBankCardNo.split("@");
					var amtToBeModified=0;
					
					var totalBTAmtReq = 0;
					var totalReqAmount=0;			
					for(var i=0;i<arrCardNo.length;i++)
					{
						
						if(arrBTRequired[i]=='Yes')
						{
						
							if(document.getElementById('2_rakbank_eligible_card_no').value==arrCardNo[i])
							{
								
								for(var j=0;j<arrEligibleCardNo.length;j++)
								{
									
									if(document.getElementById('2_sub_ref_no').value==arrBTSubRefNo[j])
									{
										amtToBeModified=parseFloat(arrBTAmtReq[j].split(',').join(''));
									}
									
									if(document.getElementById('2_rakbank_eligible_card_no').value==arrEligibleCardNo[j])
									{
										totalReqAmount+=parseFloat(arrBTAmtReq[j].split(',').join(''));
									}
								
								}
								
								var eligAmmt =parseFloat(arrEligibleAmt[i].split(',').join(''));
								var reqAmmt =parseFloat(document.getElementById('2_bt_amt_req').value.split(',').join(''));
								totalReqAmount+=reqAmmt-amtToBeModified;
								
								if(eligAmmt<totalReqAmount)
								{
									alert("Sum of BT requested amount should not exceed the BT eligible amount for card no. " + arrCardNo[i]+".");
									//document.getElementById('2_bt_amt_req').value='';
									document.getElementById('2_bt_amt_req').focus();
									return false;
								}
							}
						}
					}					
				}
				else if(labelname=='Other Bank Card Number')
				{	
					document.getElementById("2_eligibility").value='';
					if(!mod10(document.getElementById('2_other_bank_card_no').value))
					{
						alert("Invalid Other Bank Card No.");
						document.getElementById('2_other_bank_card_no').value="";
						document.getElementById('2_other_bank_card_no').focus();
						return false;		
					}
					
				}
				else if(labelname=='Type of BT')
				{	
					document.getElementById("2_eligibility").value='';
				}
				else if(labelname=='Sales Agent ID')
				{	
					
					document.getElementById("2_source").value=document.getElementById('2_sales_agent_id').value;
				}
				if(labelname=='Other Bank Card Type')
				{
					if(document.getElementById("2_other_bank_card_no").value!='' && document.getElementById("2_other_bank_card_type").value!='--Select--')
					{
						var cardNo = document.getElementById("2_other_bank_card_no").value;
						if(cardNo.length!=16 && document.getElementById("2_other_bank_card_type").value!='AMEX')
						{
							alert("Length of card no. should be exactly 16 digits.");
							document.getElementById("2_other_bank_card_no").value="";
							document.getElementById("2_other_bank_card_no").focus();
							document.getElementById("2_eligibility").value="";
							document.getElementById("2_v_non_eligibility_reasons").value="";
							return false;
						}
						else if(cardNo.length!=15 && document.getElementById("2_other_bank_card_type").value=='AMEX')
						{
							alert("Length of card no. should be exactly 15 digits.");
							document.getElementById("2_other_bank_card_no").value="";
							document.getElementById("2_other_bank_card_no").focus();
							document.getElementById("2_eligibility").value="";
							document.getElementById("2_v_non_eligibility_reasons").value="";
							
							return false;
						}							
						if(document.getElementById("2_other_bank_card_type").value=='VISA' && document.getElementById('2_other_bank_card_no').value.indexOf('4')!=0)
						{
							alert("Invalid Other Bank Card number for VISA card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							document.getElementById("2_eligibility").value="";
							document.getElementById("2_v_non_eligibility_reasons").value="";
							return false;
						}
						if(document.getElementById("2_other_bank_card_type").value=='MASTER' && document.getElementById('2_other_bank_card_no').value.indexOf('5')!=0)
						{
							alert("Invalid Other Bank Card number for MASTER card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							document.getElementById("2_eligibility").value="";
							document.getElementById("2_v_non_eligibility_reasons").value="";
							return false;
						}
						if(document.getElementById("2_other_bank_card_type").value=='AMEX' && !(document.getElementById('2_other_bank_card_no').value.indexOf('37')==0 || document.getElementById('2_other_bank_card_no').value.indexOf('34')==0))
						{
							alert("Invalid Other Bank Card number for AMEX card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							document.getElementById("2_eligibility").value="";
							document.getElementById("2_v_non_eligibility_reasons").value="";
							return false;
						}
						if(document.getElementById("2_other_bank_card_type").value=='JCB' && document.getElementById('2_other_bank_card_no').value.indexOf('35')!=0)
						{
							alert("Invalid Other Bank Card number for JCB card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							document.getElementById("2_eligibility").value="";
							document.getElementById("2_v_non_eligibility_reasons").value="";
							return false;
						}
					}
				}
				if(labelname=='No Action')
				{
					document.getElementById("2_auth_code").value='';
					document.getElementById("2_auth_code").disabled=true;
				}
				else if(labelname=='Manual Blocking Done')
				{
					document.getElementById("2_auth_code").disabled=false;
				}	
				else if(labelname=='Manual Blocking Not Done')
				{
					document.getElementById("2_auth_code").value='';
					document.getElementById("2_auth_code").disabled=true;
				}	
								
				
				
			}
			if(event=='onblur')
			{
				if(labelname=='Other Bank Card no.')
				{	
					
					var regex='';
					var cardNo = document.getElementById("2_other_bank_card_no").value;
					if(cardNo!='' && document.getElementById("2_other_bank_card_type").value!='--Select--')
					{
						regex=/^[X0-9]/;
						if(!regex.test(cardNo))
						{	alert("Only numerics are allowed in Card No.");
							document.getElementById("2_other_bank_card_no").value="";
							document.getElementById("2_other_bank_card_no").focus();
							return false;
						}
						if(cardNo.length!=16 && document.getElementById("2_other_bank_card_type").value!='AMEX')
						{
							alert("Length of card no. should be exactly 16 digits.");
							document.getElementById("2_other_bank_card_no").value="";
							document.getElementById("2_other_bank_card_no").focus();
							
							return false;
						}
						else if(cardNo.length!=15 && document.getElementById("2_other_bank_card_type").value=='AMEX')
						{
							alert("Length of card no. should be exactly 15 digits.");
							document.getElementById("2_other_bank_card_no").value="";
							document.getElementById("2_other_bank_card_no").focus();
							
							return false;
						}							
						if(document.getElementById("2_other_bank_card_type").value=='VISA' && document.getElementById('2_other_bank_card_no').value.indexOf('4')!=0)
						{
							alert("Invalid Other Bank Card number for VISA card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							return false;
						}
						if(document.getElementById("2_other_bank_card_type").value=='MASTER' && document.getElementById('2_other_bank_card_no').value.indexOf('5')!=0)
						{
							alert("Invalid Other Bank Card number for MASTER card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							return false;
						}
						if(document.getElementById("2_other_bank_card_type").value=='AMEX' && !(document.getElementById('2_other_bank_card_no').value.indexOf('37')==0 || document.getElementById('2_other_bank_card_no').value.indexOf('34')==0))
						{
							alert("Invalid Other Bank Card number for AMEX card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							return false;
						}
						if(document.getElementById("2_other_bank_card_type").value=='JCB' && document.getElementById('2_other_bank_card_no').value.indexOf('35')!=0)
						{
							alert("Invalid Other Bank Card number for JCB card type.");
							document.getElementById('2_other_bank_card_no').value="";
							document.getElementById('2_other_bank_card_no').focus();
							return false;
						}
						if(!mod10(cardNo) )
						{
							alert("Invalid Card No.");
							document.getElementById("2_other_bank_card_no").value="";
							document.getElementById("2_other_bank_card_no").focus();
							
							return false;
						}
					}
					else if(document.getElementById("2_other_bank_card_type").value=='--Select--')
					{
						alert('Please select other bank card type first.');
						document.getElementById("2_other_bank_card_type").focus();
					}
					
				}
			}
		}
		else 
		{
			
			if(event=='onchange')
			{
				if(labelname=='Manual Unblocking')
				{
					if(document.getElementById("2_manual_unblock").checked ==true)
					{
						alert("Amount has to be unblocked manually in ONLINE.");
						document.getElementById("Cancel").disabled = true;
					}else{
						document.getElementById("Cancel").disabled = false;
					}
				}
			}
		}
		
		if(event=='onblur')
		{
			
			if(labelname=='Authorization Code')
			{
				var integrationStatus=parent.document.getElementById("wdesk:IntegrationStatus").value;
				
				//code added to enter auth code only on manual blocking done
				var myradio1 = document.getElementsByName('2_manual_blocking_action');
				var y = 0;
				var ManualBlockingActionChecked = false;
				var ManualBlockingActionValue = '';
				for(y = 0; y < myradio1.length; y++)
				{
					if(myradio1[y].checked)
					{
						ManualBlockingActionChecked=true;
						ManualBlockingActionValue=myradio1[y].value;
					}
				}
				
				//var regex=/^[X0-9]/;
				var regex=new RegExp('^[0-9]*$');
				if(!regex.test(document.getElementById("2_auth_code").value) && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done')
				{	
					alert("Only numerics are allowed in Authorization Code.");
					document.getElementById("2_auth_code").value="";
					document.getElementById("2_auth_code").focus();
					return false;
				}
				if((document.getElementById("2_auth_code").value).length!=6 && integrationStatus=='false' && ManualBlockingActionChecked && ManualBlockingActionValue=='Manual Blocking Done' && document.getElementById("2_auth_code").value!='')
				{
					alert("Length of Authorization Code should be exactly 6 digits.");
					document.getElementById("2_auth_code").focus();
					return false;
				}
			}
		}
		
	}	
	else if(SubCategoryID=='3' && CategoryID=='1') //for BOC
	{
		
		if(event=='onchange')
		{	
			if(labelname=='Type of Block')
			{
				var type_of_block= document.getElementById("3_type_of_block").value;
				
				if(document.getElementById("3_type_of_block").value=='--Select--')
				{
					document.getElementById("3_reason_for_block").disabled=true; 
					document.getElementById("3_replacement_required").disabled=true; 
					document.getElementById("3_replacement_required").value='--Select--';
				}
				else 
				{
					document.getElementById("3_reason_for_block").disabled=false; 
				}	
							
				if(document.getElementById("3_card_holder_type").value=='Supplementary')
				{
					if(document.getElementById("3_type_of_block").value == 'Permanent')
					{
						alert("Card Holder is Supplementary - Permanent blocking can be done by primary card holder only.");
						document.getElementById("3_type_of_block").value='Temporary';
						document.getElementById("3_type_of_block").focus;
					}
				}
				if(document.getElementById("3_type_of_block").value == 'Temporary')	
				{
					document.getElementById("3_replacement_required").disabled=true; 
					document.getElementById("3_replacement_required").value='No';
				}
				if(document.getElementById("3_type_of_block").value == 'Permanent')	
				{
					var myradio = document.getElementsByName('3_verification_details');
					var x = 0;
					var veriDetailChecked = false;
					var veriDetailCheckedValue = '';
					for(x = 0; x < myradio.length; x++)
					{
						if(myradio[x].checked==true){
								veriDetailChecked=true;
								veriDetailCheckedValue=myradio[x].value;
						}
					}
					if(veriDetailCheckedValue=='Non - Customer')
					{
						document.getElementById("3_replacement_required").value='No';
						document.getElementById("3_replacement_required").disabled=true; 
						alert("Non-Customer is not allowed to block the card permanently.\nKindly select temporary.");
						document.getElementById("3_type_of_block").value='--Select--';
						window.document.getElementById("3_type_of_block").focus();
						return false;
					}
					else
					{
						document.getElementById("3_replacement_required").value='--Select--';
						document.getElementById("3_replacement_required").disabled=false; 
					}
				}
				
				var ResponseList;	
				var xhr;
				var Card_Status = document.getElementById(SubCategoryID+"_"+"card_status").value;
				
				if(window.XMLHttpRequest)  xhr=new XMLHttpRequest();
				else if(window.ActiveXObject)  xhr=new ActiveXObject("Microsoft.XMLHTTP");
				
				var url="/webdesktop/CustomForms/SRM_Specific/Custom_Validation_BOC.jsp?cardStatus="+Card_Status;
				
				 xhr.open("GET",url,false); 
				 xhr.send(null);
				
				if (xhr.status == 200 && xhr.readyState == 4)
				{
					var ajaxResult=Trim(xhr.responseText);
					ResponseList = ajaxResult.split("~");
					
					var tempblock_allowed=ResponseList[0];
					var permblock_allowed=ResponseList[1];
					var block_status=ResponseList[2];
					if(block_status.replace(/^\s+|\s+$/gm,'')=='Permanent'&& type_of_block.replace(/^\s+|\s+$/gm,'')=='Temporary')
					{	
						alert("Card in Permanent block status cannot be changed to Temporary.");
						document.getElementById("3_type_of_block").value = '--Select--';
						document.getElementById("3_type_of_block").focus;
						document.getElementById("3_reason_for_block").value = '--Select--';
						document.getElementById("3_reason_for_block").disabled = true;
						document.getElementById("3_block_card").checked = false;
						document.getElementById("3_replacement_required").disabled=true; 
					//	return false;
					}
					else if(tempblock_allowed=='N' && permblock_allowed=='N'){
						alert("Card cannot be blocked, Card Status-"+Card_Status+".");
						document.getElementById("3_type_of_block").value = '--Select--';
						document.getElementById("3_type_of_block").disabled = true;
						document.getElementById("3_reason_for_block").value = '--Select--';
						document.getElementById("3_reason_for_block").disabled = true;
						document.getElementById("3_block_card").checked = false;
						document.getElementById("3_replacement_required").disabled=true; 
						document.getElementById("3_replacement_required").value='No';
					}else  if(type_of_block=='Temporary'&&tempblock_allowed=='N')
					{	
						alert("Card cannot be blocked as Temporary, Card Status-"+Card_Status+".");
						document.getElementById("3_type_of_block").value = '--Select--';
						document.getElementById("3_type_of_block").focus;

					//	return false;
					} else if(type_of_block=='Permanent'&&permblock_allowed=='N')
					{
						alert("Card cannot be blocked as Permanent, Card Status-"+Card_Status+".");
						document.getElementById("3_type_of_block").value = '--Select--';
						document.getElementById("3_type_of_block").focus;

						//return false;
					}	
				}
				else
				{
					alert("Error in duplicate workitem validation.");
			
				}
				
				setOptions(document.getElementById("3_type_of_block").value,document.getElementById("3_reason_for_block"));
				
			}
			if(labelname=='Reason for Block')
			{
			
				var block_card= document.getElementById("3_block_card").checked;
				
				if(!block_card)
				{
					document.getElementById("3_reason_for_block").value='--Select--';
					document.getElementById("3_reason_for_block").disabled=true;
					
					document.getElementById("3_type_of_block").value='--Select--';
					document.getElementById("3_type_of_block").disabled=true;
					
					document.getElementById("3_reason_for_block").value='--Select--';
					document.getElementById("3_reason_for_block").disabled=true;
					
					document.getElementById("3_replacement_required").disabled=true;
					
					document.getElementById("3_date_and_time").value='';
					document.getElementById("3_date_and_time").disabled=true;
					alert('Block card should be Yes.');
				}
				if(document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM')
				{
					document.getElementById("3_ATM_LOC").disabled=false;
					document.getElementById("3_branch_collect").disabled=false;
					
				}
				else
				{
					document.getElementById("3_ATM_LOC").disabled=true;
					document.getElementById("3_ATM_LOC").value="";
					document.getElementById("3_branch_collect").disabled=true;
					document.getElementById("3_branch_collect").value="--Select--";
				}
				
				
					
				if((document.getElementById("3_reason_for_block").value=='Lost') 
					||(document.getElementById("3_reason_for_block").value=='Stolen')
					||document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM'
					||document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
					||(document.getElementById("3_reason_for_block").value=='Misuse')
					)
				{
					document.getElementById("3_date_and_time").disabled=false;
				}
				else
				{
					document.getElementById("3_date_and_time").value='';
					document.getElementById("3_date_and_time").disabled=true;
				}
				
				// if(document.getElementById("3_reason_for_block").value=='Lost')
				// {
					// document.getElementById("3_aft_CardStatus").value='LOST';
					
				// }else if(document.getElementById("3_reason_for_block").value=='Stolen')
				// {
					// document.getElementById("3_aft_CardStatus").value='STLC';
					
				// }else if(document.getElementById("3_reason_for_block").value=='Captured at Rak bank ATM')
				// {
					// document.getElementById("3_aft_CardStatus").value='ATMR';
					
				// }else if(
				// document.getElementById("3_reason_for_block").value=='Captured in non-Rak bank ATM'
				// || document.getElementById("3_reason_for_block").value=='Misuse'
				// || document.getElementById("3_reason_for_block").value=='Magnetic Strip Damaged'
				// || document.getElementById("3_reason_for_block").value=='Incorrect name embossed on the card'
				// || document.getElementById("3_reason_for_block").value=='Cxm want to Block the card'
				// )
				// {
					// document.getElementById("3_aft_CardStatus").value='PICK';
					
				// }else if(document.getElementById("3_reason_for_block").value=='Credit Card Closure')
				// {
					// document.getElementById("3_aft_CardStatus").value='BR04';
					
				// }else if(document.getElementById("3_reason_for_block").value=='Misplaced'
				// || document.getElementById("3_reason_for_block").value=='Changed/Left Employment'
				// || document.getElementById("3_reason_for_block").value=='Leaving Country'
				// || document.getElementById("3_reason_for_block").value=='Card found by third party'
				// || document.getElementById("3_reason_for_block").value=='Third party calling to block'
				// || document.getElementById("3_reason_for_block").value=='Customer Passed away'
				// || document.getElementById("3_reason_for_block").value=='Received card in open pack'
				// || document.getElementById("3_reason_for_block").value=='Others')
				// {
					// document.getElementById("3_aft_CardStatus").value='NOAU';
					
				// }
				var aftercardstatus = '';
				var aftercardstatusresp = getSelectResponseAjax('usr_0_srm_boc_rsnforblock',document.getElementById("3_reason_for_block").value);
				var response = aftercardstatusresp.split("~");
				if(response[0]=='0')
				{
					aftercardstatus = response[1];
				}
				else
				{
					alert("Error in getting after card status");
					return false;
				}
				//alert(aftercardstatus);
				document.getElementById("3_aft_CardStatus").value=aftercardstatus;				
				
				if(insurancealertcount==0)
				{
					alert("Please advice customer about insurance.");
					insurancealertcount=insurancealertcount+1;
				}
			}
			if(labelname=='Non - Customer')
			{
				var frameName = 'CARD BLOCKING DETAILS';
				document.getElementById("3_replacement_required").value='No';
				document.getElementById("3_replacement_required").disabled=true;
				
				document.getElementById("3_third_party_name").disabled=false;
				document.getElementById("3_third_party_contact_number").disabled=false;
				
				var selGridWIData = document.getElementById(frameName+'_3_gridbundleJSON_WIDATA').value;
				
				var obj = JSON.parse(selGridWIData);
				
				for(var key in obj){
					temp="";
					var attrName = key;
					var attrValue = obj[key];
					if(key=='replacement_required'){
						
						obj[key]='false@false@false';
					}
				}	
				var modJson =  JSON.stringify(obj);
				document.getElementById(frameName+'_3_gridbundleJSON_WIDATA').value = modJson;
				var gridRowCount = document.getElementById(frameName+'_3_gridrowCount').value
				for(var i = 0 ; i<gridRowCount; i++){
					document.getElementById('grid_3_replacement_required_'+ i).value=false;
				}

			}
			if(labelname=='TIN' || labelname=='Manual'){
				document.getElementById("3_third_party_name").disabled=true;
				document.getElementById("3_third_party_name").value="";
				
				document.getElementById("3_third_party_contact_number").disabled=true;
				document.getElementById("3_third_party_contact_number").value="";
				
				if(document.getElementById("3_type_of_block").value=='Permanent')
				{
					document.getElementById("3_replacement_required").disabled=false;
				}
			}
			if(labelname=='Request status'){
				alert("Request Status Changed");
				//alert("Request Status Changed");
			}
			
			
		}	
		else if(event=='onblur')
		{
			if(labelname=='Reason for Block')
			{
				//
				
			}
			if(labelname=='Date and Time')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("3_date_and_time").value.split(" ");
				if(document.getElementById("3_date_and_time").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("3_date_and_time").value+".");
							document.getElementById("3_date_and_time").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("3_date_and_time").value);
						document.getElementById("3_date_and_time").focus();
						return false;
					}
				}
			}
		}	
		else if(event=='onclick')
		{
			if(labelname=='Block Card')
			{
				var block_card= document.getElementById("3_block_card").checked;
				if(block_card)
				{
					document.getElementById("3_type_of_block").disabled=false;					
				}
				else
				{
					document.getElementById("3_reason_for_block").value='--Select--'; 
					document.getElementById("3_reason_for_block").disabled=true; 
					document.getElementById("3_type_of_block").value='--Select--';
					document.getElementById("3_type_of_block").disabled=true;
					
					document.getElementById("3_replacement_required").disabled=true; 
					document.getElementById("3_replacement_required").value='No';
					
					document.getElementById("3_date_and_time").value='';
					document.getElementById("3_date_and_time").disabled=true;
					document.getElementById("3_sub_ref_no").value='';
					
				}
			}
		}	
	}	
	else if(SubCategoryID=='1' && CategoryID=='3')
	{	
		
		if(event=='onblur')
		{
			if(labelname=='Decision')
			{
				var now = new Date();
				var date= now.getDate();
				var month=now.getMonth();
				var year=now.getFullYear();
				var hours=now.getHours();
				var minutes=now.getMinutes();
				var seconds=now.getSeconds();
				
				if(date<10)
					now="0"+date+"/";
				else 
					now=date+"/";
				
				if(month<10)
					now=now+"0"+month+"/";
				else 
					now=now+month+"/";
				
				now=now+year+" ";
				
				if(hours<10)
					now=now+"0"+hours+":";
				else 
					now=now+hours+":";				
				
				if(minutes<10)
					now=now+"0"+minutes+":";
				else 
					now=now+minutes+":";				
					
				if(seconds<10)
					now=now+"0"+seconds;
				else 
					now=now+seconds;				
					

				document.getElementById("1_P_U_D_T").value=now ;
				document.getElementById("1_P_U_D_T").disabled=true ;
				
				
			}
			if(labelname=='Branch Name')
			{
				var BranchElement = document.getElementById("1_branch_name");
				var selectedValue = BranchElement.options[BranchElement.selectedIndex].value;
				if(selectedValue=='Lagos Branch')
				{
					document.getElementById("1_branch_code").value='LB001';
				}
				if(selectedValue=='Owerri Branch')
				{
					document.getElementById("1_branch_code").value='OW002';
				}
				
			}
		}	
	}
	else if(SubCategoryID=='2' && CategoryID=='3')
	{
		if(event=='onblur')
		{
			if(labelname=='Decision')
			{
				var now = new Date();
				var date= now.getDate();
				var month=now.getMonth();
				var year=now.getFullYear();
				var hours=now.getHours();
				var minutes=now.getMinutes();
				var seconds=now.getSeconds();
				
				if(date<10)
					now="0"+date+"/";
				else 
					now=date+"/";
				
				if(month<10)
					now=now+"0"+month+"/";
				else 
					now=now+month+"/";
				
				now=now+year+" ";
				
				if(hours<10)
					now=now+"0"+hours+":";
				else 
					now=now+hours+":";				
				
				if(minutes<10)
					now=now+"0"+minutes+":";
				else 
					now=now+minutes+":";				
					
				if(seconds<10)
					now=now+"0"+seconds;
				else 
					now=now+seconds;				
					
				document.getElementById("2_D_D_T").value=now ;
				document.getElementById("2_D_D_T").disabled=true ;
				
			}
			if(labelname=='Branch Name')
			{
				var BranchElement = document.getElementById("2_Branch_Name");
				var selectedValue = BranchElement.options[BranchElement.selectedIndex].value;
				if(selectedValue=='Lagos Branch')
				{
					document.getElementById("2_branch_code").value='LB001';
				}
				if(selectedValue=='Owerri Branch')
				{
					document.getElementById("2_branch_code").value='OW002';
				}
				
			}
		}	
		
	}
	else if(SubCategoryID=='1' && CategoryID=='5')
	{
		if(event=='onblur')
		{
			if(labelname=='Decision')
			{
				var now = new Date();
				var date= now.getDate();
				var month=now.getMonth();
				var year=now.getFullYear();
				var hours=now.getHours();
				var minutes=now.getMinutes();
				var seconds=now.getSeconds();
				
				if(date<10)
					now="0"+date+"/";
				else 
					now=date+"/";
				
				if(month<10)
					now=now+"0"+month+"/";
				else 
					now=now+month+"/";
				
				now=now+year+" ";
				
				if(hours<10)
					now=now+"0"+hours+":";
				else 
					now=now+hours+":";				
				
				if(minutes<10)
					now=now+"0"+minutes+":";
				else 
					now=now+minutes+":";				
					
				if(seconds<10)
					now=now+"0"+seconds;
				else 
					now=now+seconds;				
				if( WSNAME=='PBO')	
				{
					document.getElementById("1_DISPATCH_DATE_TIME").value=now ;
					document.getElementById("1_DISPATCH_DATE_TIME").disabled=true ;
				}
				else
				{	
					document.getElementById("1_RECEIVED_DATE_TIME").value=now ;
					document.getElementById("1_RECEIVED_DATE_TIME").disabled=true ;
					document.getElementById("1_DISPATCH_DATE_TIME").disabled=true ;
				}
			}
			if(labelname=='Requested By Branch')
			{
				var BranchElement = document.getElementById("1_Branch_Name");
				var selectedValue = BranchElement.options[BranchElement.selectedIndex].value;
				if(selectedValue=='Lagos')
				{
					document.getElementById("1_BRANCH_CODE").value='LB001';
				}
				if(selectedValue=='ABUJA')
				{
					document.getElementById("1_BRANCH_CODE").value='AB002';
				}
				
			}
		}	
		
	}
	else if(SubCategoryID=='1' && CategoryID=='7')
	{		
		/*if(event=='onclick')
			{
				if(labelname=='Decision')
				{
					var decisionElement = document.getElementById("1_decision");
					var selectedValue = decisionElement.options[decisionElement.selectedIndex].value;
					if(selectedValue=='Reject'||selectedValue=='Cancel')
					{
						var declineRElement = document.getElementById("1_remarks");
						document.getElementById("1_remarks").disabled=false;
					}
					else
					{
						document.getElementById("1_remarks").disabled=true;
					}
				}
			}*/
		
		if(event=='onblur')
		{
			if(labelname=='Is This Request Evaluated As Project?')
			{
				if(document.getElementById("1_is_this_request_evaluated_as_project").value=='Yes' && document.getElementById("1_explanation1").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation1").focus();
					return false;
				}
				
			}
			if(labelname=='Is This Request Related With The Any Other Request?')
			{
				if(document.getElementById("1_is_this_request_related_with_any_other_request").value=='Yes' && document.getElementById("1_explanation2").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation2").focus();
					return false;
				}
				
			}
			if(labelname=='Is There Any IT Risk With This Request?')
			{
				if(document.getElementById("1_is_there_any_itrisk_with_this_request").value=='Yes' && document.getElementById("1_explanation3").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation3").focus();
					return false;
				}
				
			} 
			 if(labelname=='Any Working Process With This Request?')
			{
				if(document.getElementById("1_is_there_any_wrkngproces_relatedsystm_userdocuments_with_this_request").value=='Yes' && document.getElementById("1_explanation4").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation4").focus();
					return false;
				}
				
			}  
			if(labelname=='Is This Request Related With The Any Other Request?')
			{
				if(document.getElementById("1_is_this_request_related_with_any_other_request").value=='Yes' && document.getElementById("1_req_numbers").value=="")
				{
					alert("Please fill Req Number");
					document.getElementById("1_req_numbers").focus();
					return false;
				}
				
			} 			

			if(labelname=='Date Of Legal Obligation')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_date_of_legal_obli").value.split(" ");
				if(document.getElementById("1_date_of_legal_obli").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_date_of_legal_obli").value+".");
							document.getElementById("1_date_of_legal_obli").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_date_of_legal_obli").value);
						document.getElementById("1_date_of_legal_obli").focus();
						return false;
					}
				}
			}
			
			if(labelname=='Evaluation Date')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_evaluation_date").value.split(" ");
				if(document.getElementById("1_evaluation_date").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_evaluation_date").value+".");
							document.getElementById("1_evaluation_date").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_evaluation_date").value);
						document.getElementById("1_evaluation_date").focus();
						return false;
					}
				}
			}
			if(labelname=='Estimated Date To Start')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_estimated_date_to_start").value.split(" ");
				if(document.getElementById("1_estimated_date_to_start").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_estimated_date_to_start").value+".");
							document.getElementById("1_estimated_date_to_start").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_estimated_date_to_start").value);
						document.getElementById("1_estimated_date_to_start").focus();
						return false;
					}
				}
			}
			if(labelname=='Starting Date')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_starting_date").value.split(" ");
				if(document.getElementById("1_starting_date").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_starting_date").value+".");
							document.getElementById("1_starting_date").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_starting_date").value);
						document.getElementById("1_starting_date").focus();
						return false;
					}
				}
			}
			if(labelname=='Ending Date')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_ending_date").value.split(" ");
				if(document.getElementById("1_ending_date").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_ending_date").value+".");
							document.getElementById("1_ending_date").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_ending_date").value);
						document.getElementById("1_ending_date").focus();
						return false;
					}
				}
			}
			if(labelname=='Date Of  Production Phase')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_date_of_production_phase").value.split(" ");
				if(document.getElementById("1_date_of_production_phase").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_date_of_production_phase").value+".");
							document.getElementById("1_date_of_production_phase").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_date_of_production_phase").value);
						document.getElementById("1_date_of_production_phase").focus();
						return false;
					}
				}
			}
		}
		
	}
	else if(SubCategoryID=='1' && CategoryID=='8')
	{
		//alert("inside click function of software");
		
		if(event=='onblur')
		{
			if(labelname=='Is This Request Evaluated As Project?')
			{
				if(document.getElementById("1_is_this_request_evaluated_as_project").value=='Yes' && document.getElementById("1_explanation1").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation1").focus();
					return false;
				}
				
			}
			if(labelname=='Is This Request Related With The Any Other Request?')
			{
				if(document.getElementById("1_is_this_request_related_with_any_other_request").value=='Yes' && document.getElementById("1_explanation2").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation2").focus();
					return false;
				}
				
			}
			if(labelname=='Is There Any IT Risk With This Request?')
			{
				if(document.getElementById("1_is_there_any_itrisk_with_this_request").value=='Yes' && document.getElementById("1_explanation3").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation3").focus();
					return false;
				}
				
			} 
			 if(labelname=='Any Working Process With This Request?')
			{
				if(document.getElementById("1_is_there_any_wrkngproces_relatedsystm_userdocuments_with_this_request").value=='Yes' && document.getElementById("1_explanation4").value=="")
				{
					alert("Please fill explaination");
					document.getElementById("1_explanation4").focus();
					return false;
				}
				
			}
			
			if(labelname=='Is This Request Related With The Any Other Request?')
			{
				if(document.getElementById("1_is_this_request_related_with_any_other_request").value=='Yes' && document.getElementById("1_req_numbers").value=="")
				{
					alert("Please fill Req Number");
					document.getElementById("1_req_numbers").focus();
					return false;
				}
				
			}
		
			if(labelname=='Date Of Legal Obligation')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_date_of_legal_obli").value.split(" ");
				if(document.getElementById("1_date_of_legal_obli").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_date_of_legal_obli").value+".");
							document.getElementById("1_date_of_legal_obli").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_date_of_legal_obli").value);
						document.getElementById("1_date_of_legal_obli").focus();
						return false;
					}
				}
			}
			
			if(labelname=='Evaluation Date')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_evaluation_date").value.split(" ");
				if(document.getElementById("1_evaluation_date").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_evaluation_date").value+".");
							document.getElementById("1_evaluation_date").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_evaluation_date").value);
						document.getElementById("1_evaluation_date").focus();
						return false;
					}
				}
			}
			if(labelname=='Estimated Date To Start')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_estimated_date_to_start").value.split(" ");
				if(document.getElementById("1_estimated_date_to_start").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_estimated_date_to_start").value+".");
							document.getElementById("1_estimated_date_to_start").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_estimated_date_to_start").value);
						document.getElementById("1_estimated_date_to_start").focus();
						return false;
					}
				}
			}
			if(labelname=='Starting Date')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_starting_date").value.split(" ");
				if(document.getElementById("1_starting_date").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_starting_date").value+".");
							document.getElementById("1_starting_date").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_starting_date").value);
						document.getElementById("1_starting_date").focus();
						return false;
					}
				}
			}
			if(labelname=='Ending Date')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_ending_date").value.split(" ");
				if(document.getElementById("1_ending_date").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_ending_date").value+".");
							document.getElementById("1_ending_date").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_ending_date").value);
						document.getElementById("1_ending_date").focus();
						return false;
					}
				}
			}
			if(labelname=='Date Of  Production Phase')
			{
				 var regex = /(\d{1,2})\/(\d{1,2})\/(\d{4})/;
					
				var dateTimeArr = document.getElementById("1_date_of_production_phase").value.split(" ");
				if(document.getElementById("1_date_of_production_phase").value != '')
				{
					if(dateTimeArr.length==2 &&  dateTimeArr[0].match(regex)) 
					{
						regex = /(^([01]\d|2[0-3]):(?:[0-5]\d):(?:[0-5]\d)$)/;
						if(!dateTimeArr[1].match(regex))
						{
							alert("Invalid date : " + document.getElementById("1_date_of_production_phase").value+".");
							document.getElementById("1_date_of_production_phase").focus();
							return false;
						}
					}
					else
					{
						alert("Invalid date : " + document.getElementById("1_date_of_production_phase").value);
						document.getElementById("1_date_of_production_phase").focus();
						return false;
					}
				}
			}
			
		}
	}
	
	//return true;
	return true;
}
function formLoadCheck()
{
	var CategoryID = document.getElementById("CategoryID").value;
	var SubCategoryID = document.getElementById("SubCategoryID").value;
	var WSNAME = document.getElementById("WS_NAME").value;
	if(SubCategoryID=='1' && CategoryID=='1' )
	{
		if(!(WSNAME=='Introduction' ||  WSNAME=='PBO'))
		{	
			var decisionElement = document.getElementById("1_Decision");
			var selectedValue = decisionElement.options[decisionElement.selectedIndex].value;
			try{
				if(selectedValue!='Reject')
				{	var declineRElement = document.getElementById("1_Decline_Reason");
					document.getElementById("1_Decline_Reason").selectedIndex=0;
					document.getElementById("1_Decline_Reason").disabled=true;
				}

				else
				{	var declineRElement = document.getElementById("1_Decline_Reason");
					document.getElementById("1_Decline_Reason").disabled=false;
				}
			}catch(err){}			
		}
		if(WSNAME=='Exit' || WSNAME=='Reject')
		{

			document.getElementById("1_Decline_Reason").disabled=true;
			document.getElementById("1_Remarks").value=document.getElementById("1_Remarks").value.substring(document.getElementById("1_Remarks").value.indexOf("$")+1);
		}
		else if(WSNAME=='Q4')
		{
			var requestedAmount = document.getElementById("1_Requested_Cash_Back_Amount");
			var approvedAmount = document.getElementById("1_Approved_Cash_Back_Amount");

		}

	}
	if(SubCategoryID=='1' && CategoryID=='3')
	{
		document.getElementById("1_Requested_By").value=document.getElementById("username").value;
		document.getElementById("1_Email_ID").value=document.getElementById("username").value;
		
		
		
		if(!block_card)
		{
			document.getElementById("3_type_of_block").value='--Select--';
			document.getElementById("3_reason_for_block").selectedIndex=0;
			document.getElementById("3_type_of_block").disabled=true;
			document.getElementById("3_reason_for_block").disabled=true; 
		}
	}
	if(SubCategoryID=='2' && CategoryID=='3')
	{
		document.getElementById("2_Requested_By").value=document.getElementById("username").value;
		document.getElementById("2_Email_ID").value=document.getElementById("username").value;
	}
	if(SubCategoryID=='1' && CategoryID=='5')
	{
		document.getElementById("1_Initiated_By").value=document.getElementById("username").value;
		document.getElementById("1_Email_ID").value=document.getElementById("username").value;
	}
	
	if(SubCategoryID=='3' && CategoryID=='1')
	{
		//
	}
	if(CategoryID=='8' || CategoryID=='7')
	{
		document.getElementById("1_remarks").value="";
	}
}

function setOptions(chosen,selbox) 
{

	selbox.options.length = 0;
	if (chosen == "Permanent") 
	{
		  selbox.options[selbox.options.length] = new
		Option('--Select--','--Select--');
		  // selbox.options[selbox.options.length] = new
		// Option('Lost','Lost');
		  // selbox.options[selbox.options.length] = new
		// Option('Stolen','Stolen');
			// selbox.options[selbox.options.length] = new
		// Option('Captured in non-Rak bank ATM','Captured in non-Rak bank ATM');		
			// selbox.options[selbox.options.length] = new
		// Option('Magnetic Strip Damaged','Magnetic Strip Damaged');
			// selbox.options[selbox.options.length] = new
		// Option('Incorrect name embossed on the card','Incorrect name embossed on the card');
		  // selbox.options[selbox.options.length] = new
		// Option('Misuse','Misuse');		
		  // selbox.options[selbox.options.length] = new
		// Option('Cxm want to Block the card','Cxm want to Block the card');			
		  //selbox.options[selbox.options.length] = new	Option('Credit Card Closure','Credit Card Closure');		
		var reasonstoadd="";
		var reasons = getSelectResponseAjax('usr_0_srm_boc_rsnforblock',chosen,'blockreason');
		var response = reasons.split("~");
		if(response[0]=='0')
		{
			reasonstoadd = response[1];
		}
		else
		{
			alert("Error in permanent block reasons");
			return false;
		}
		//alert(reasonstoadd);
		var reasonsarray = reasonstoadd.split('#');
		for(var i = 0; i<reasonsarray.length;i++)
		{
			selbox.options[selbox.options.length] = new	Option(reasonsarray[i],reasonsarray[i]);
		}		  
		
	}
	// repeat for entries in first dropdown list

	if (chosen == "Temporary") {
		  selbox.options[selbox.options.length] = new
		Option('--Select--','--Select--');
		  // selbox.options[selbox.options.length] = new
		// Option('Misplaced','Misplaced');
			// selbox.options[selbox.options.length] = new
		// Option('Changed/Left Employment','Changed/Left Employment');
			// selbox.options[selbox.options.length] = new
		// Option('Leaving Country','Leaving Country');
			// selbox.options[selbox.options.length] = new
		// Option('Card found by third party','Card found by third party');
			// selbox.options[selbox.options.length] = new
		// Option('Third party calling to block','Third party calling to block');
			// selbox.options[selbox.options.length] = new
		// Option('Customer Passed away','Customer Passed away');
			// selbox.options[selbox.options.length] = new
		// Option('Received card in open pack','Received card in open pack');
			// selbox.options[selbox.options.length] = new
		// Option('Captured at Rak bank ATM','Captured at Rak bank ATM');
			// selbox.options[selbox.options.length] = new
		// Option('Others','Others');
		var reasonstoadd="";
		var reasons = getSelectResponseAjax('usr_0_srm_boc_rsnforblock',chosen, 'blockreason');
		var response = reasons.split("~");
		if(response[0]=='0')
		{
			reasonstoadd = response[1];
		}
		else
		{
			alert("Error in temporary block reasons");
			return false;
		}
		//alert(reasonstoadd);
		var reasonsarray = reasonstoadd.split('#');
		for(var i = 0; i<reasonsarray.length;i++)
		{
			selbox.options[selbox.options.length] = new	Option(reasonsarray[i],reasonsarray[i]);
		}		
		
	}
	// repeat for all the possible entries in second dropdown list

}
function getThousandSeparatedValue(value)
{
	value = value.split(',').join('');
	var num2 = value.toString().split('.');
	var thousands = num2[0].split('').reverse().join('').match(/.{1,3}/g).join(',');
	var decimals = (num2[1]) ? '.'+num2[1] : '';

	return thousands.split('').reverse().join('')+decimals; 
}
function getSelectResponseAjax(selectFor,columnForDecode,queryfor)
{
	//alert("called");
	var ajaxResult="";
	var xhr="";
	if(window.XMLHttpRequest)  xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)  xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	var url="/webdesktop/CustomForms/SRM_Specific/SRMCustomSelect.jsp?SelectFor="+selectFor+"&columnforselect="+columnForDecode+"&queryfor="+queryfor;
	//window.open(url);
	xhr.open("GET",url,false); 
	xhr.send(null);
	
	if (xhr.status == 200 && xhr.readyState == 4)
	{
		ajaxResult=Trim1(xhr.responseText);
	}
	else
		ajaxResult="Error in getting decoded value";
		
	//alert(ajaxResult);
	return ajaxResult;
}