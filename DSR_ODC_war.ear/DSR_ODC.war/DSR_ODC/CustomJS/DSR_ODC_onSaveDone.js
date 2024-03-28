
function setCustomControlsValue()
{
  //alert("validateForSave : " + ActivityName.toUpperCase());
	if ((ActivityName.toUpperCase().indexOf("INTRODUCTION") > -1) || (ActivityName == "Pending") || (ActivityName == "Branch_Return"))
    {
		//alert("CardNo_Text : " + getValue("CardNo_Text"));
		if ((getValue("CardNo_Text") != null) && (getValue("CardNo_Text") != "") && (getValue("CardNo_Text") !="    -    -    -    "))
		{
			setFocus("CardNo_Text");
			return false;
		} 	
		
		//alert("DCI_ExtNo : " + getValue("DCI_ExtNo"));
		
		if((getValue("DCI_ExtNo")=="") || (getValue("DCI_ExtNo") == null) || (getValue("DCI_ExtNo").length != 4)) 
	    {
			showMessage("DCI_ExtNo","Ext No. is mandatory and must be of 4 digits!","error");
			setFocus("DCI_ExtNo");
			return false;
	    }
		if(getValue("DCI_CT") == "L")
		{
			showMessage("DCI_CT", "Current Card Type is not allowed for this request!","error");
			setFocus("DCI_CT");
			return false;
		}
		if ((getValue("VD_MoMaidN_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if (getValue("VD_MoMaidN_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_Oth_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if (i < 4)
			{
				showMessage("VD_MoMaidN_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_MoMaidN_Check");
				return false;
			}
		}
		if ((getValue("request_type") == "") || (getValue("request_type") == "--select--"))
		{
			showMessage("request_type", "ProcessName is Mandatory!","error");
			setFocus("request_type");
			return false;
		}
		if (getValue("request_type") == "Card Replacement")
		{
			if (getValue("oth_cr_reason") == "")
			{
				showMessage("oth_cr_reason", "Reason is Mandatory!","error");
				setFocus("oth_cr_reason");
				return false;
			}
			if ((getValue("oth_cr_OPS") == "") && (getValue("oth_cr_reason") == "Others"))
			{
				showMessage("oth_cr_OPS", "Others Pls. Specify is Mandatory!","error");
				setFocus("oth_cr_OPS");
				return false;
			}
			if (getValue("oth_cr_DC") == "")
			{
				showMessage("oth_cr_DC", "Delivery Channel is Mandatory!","error");
				setFocus("oth_cr_DC");
				return false;
			}
			if ((getValue("oth_cr_DC") == "Branch") && (getValue("CR_BRANCH") == ""))
			{
				showMessage("CR_BRANCH", "Branch Name is Mandatory!","error");
				setFocus("CR_BRANCH");
				return false;
			}
			if ((getValue("oth_cr_RR") == "") && (getValue("CR_BRANCH") == "Others"))
			{
				showMessage("oth_cr_RR", "Remarks/Reasons is Mandatory!","error");
				setFocus("oth_cr_RR");
				return false;
			}
			if (getValue("oth_cr_RR").length > 500)
			{
				showMessage("oth_cr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
				setFocus("oth_cr_RR");
				return false;
			}
		}
		else if (getValue("request_type") == "Card Delivery Request")
			{
				//alert("oth_cdr_CDT : " + getValue("oth_cdr_CDT"));
				if (getValue("oth_cdr_CDT") == "")
				{
					showMessage("oth_cdr_CDT", "Card Delivery To is Mandatory!","error");
					setFocus("oth_cdr_CDT");
					return false;
				}
				//alert("CDR_BRANCH : " + getValue("CDR_BRANCH"));
				if ((getValue("oth_cdr_CDT") == "Bank") && (getValue("CDR_BRANCH") == ""))
				{
					showMessage("CDR_BRANCH", "Branch Name is Mandatory!","error");
					setFocus("CDR_BRANCH");
					return false;
				}
				//alert("oth_cdr_RR : " + getValue("oth_cdr_RR"));
				if ((getValue("oth_cdr_RR") == "") && (getValue("CDR_BRANCH") == "Others"))
				{
					showMessage("oth_cdr_RR", "Remarks/Reasons is Mandatory!","error");
					setFocus("oth_cdr_RR");
					return false;
				}
				if (getValue("oth_cdr_RR").length > 500)
				{
					showMessage("oth_cdr_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
					setFocus("oth_cdr_RR");
					return false;
				}
			}
			else if (getValue("request_type") == "Early Card Renewal")
			{
				//alert("oth_ecr_RB : " + getValue("oth_ecr_RB"));
				if (getValue("oth_ecr_RB") == "")
				{
					showMessage("oth_ecr_RB", "Required by date is Mandatory!","error");
					setFocus("oth_ecr_RB");
					return false;
				}
				//alert("oth_ecr_dt : " + getValue("oth_ecr_dt"));
				if (getValue("oth_ecr_dt") == "")
				{
					showMessage("oth_ecr_dt", "Deliver To is Mandatory!","error");
					setFocus("oth_ecr_dt");
					return false;
				}
				//alert("ECR_BRANCH : " + getValue("ECR_BRANCH"));
				if ((getValue("oth_ecr_dt") == "Branch") && (getValue("ECR_BRANCH") == ""))
				{
					showMessage("ECR_BRANCH", "Branch Name is Mandatory!","error");
					setFocus("ECR_BRANCH");
					return false;
				}
				//alert("oth_ecr_RR : " + getValue("oth_ecr_RR"));
				if (getValue("oth_ecr_RR") == "")
				{
					showMessage("oth_ecr_RR", "Remarks/Reasons is Mandatory!","error");
					setFocus("oth_ecr_RR");
					return false;
				}
				if (getValue("oth_ecr_RR").length > 500)
				{
					showMessage("oth_ecr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
					setFocus("oth_ecr_RR");
					return false;
				}
			}
			
			else if (getValue("request_type") == "Transaction Dispute")
			{
				//alert("oth_td_RNO : " + getValue("oth_td_RNO"));
				if (getValue("oth_td_RNO") == "")
				{
					showMessage("oth_td_RNO", "Reference Number is Mandatory!","error");
					setFocus("oth_td_RNO");
					return false;
				}
				//alert("oth_td_RNO : " + getValue("oth_td_RNO"));
				if (getValue("oth_td_RNO").length > 10)
				{
					showMessage("oth_td_RNO", "Reference Number Can't be greater than 10 characters!","error");
					setFocus("oth_td_RNO");
					setControlValue("oth_td_RNO", "");
					return false;
				}
				//alert("oth_td_Amount : " + getValue("oth_td_Amount"));
				if (getValue("oth_td_Amount") == "")
				{
					showMessage("oth_td_Amount", "AMOUNT is Mandatory!","error");
					setFocus("oth_td_Amount");
					return false;
				}
				//alert("oth_td_RR : " + getValue("oth_td_RR"));
				if (getValue("oth_td_RR").length > 500)
				{
					showMessage("oth_td_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
					setFocus("oth_td_RR");
					return false;
				}
			}
			else if (getValue("request_type") == "Re-Issue of PIN")
			{
				//alert("oth_rip_reason : " + getValue("oth_rip_reason"));
				if (getValue("oth_rip_reason") == "")
				{
					showMessage("oth_rip_reason", "Reason is Mandatory!","error");
					setFocus("oth_rip_reason");
					return false;
				}
				//alert("oth_rip_DC : " + getValue("oth_rip_DC"));
				if (getValue("oth_rip_DC") == "")
				{
					showMessage("oth_rip_DC", "Delivery Channel is Mandatory!","error");
					setFocus("oth_rip_DC");
					return false;
				}
				//alert("RIP_BRANCH : " + getValue("RIP_BRANCH"));
				if ((getValue("oth_rip_DC") == "Branch") && (getValue("RIP_BRANCH") == ""))
				{
					showMessage("RIP_BRANCH", "Branch Name is Mandatory!","error");
					setFocus("RIP_BRANCH");
					return false;
				}
				//alert("oth_rip_RR : " + getValue("oth_rip_RR"));
				if ((getValue("oth_rip_RR") == "") && (getValue("RIP_BRANCH") == "Others"))
				{
					showMessage("oth_rip_RR", "Remarks/Reasons is Mandatory!","error");
					setFocus("oth_rip_RR");
					return false;
				}
				if (getValue("oth_rip_RR").length > 500)
				{
					showMessage("oth_rip_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
					setFocus("oth_rip_RR");
					return false;
				}
			}
		//alert("oth_cr_RR : " + getValue("oth_cr_RR"));
		if (getValue("oth_cr_RR").length > 500)
		{
			showMessage("oth_cr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_cr_RR");
			return false;
		}
		//alert("oth_cdr_RR : " + getValue("oth_cdr_RR"));
		if (getValue("oth_cdr_RR").length > 500)
		{
			showMessage("oth_cdr_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
			setFocus("oth_cdr_RR");
			return false;
		}
		//alert("oth_ecr_RB : " + getValue("oth_ecr_RB"));
		if (getValue("oth_ecr_RB") != "")
		{
			if (getValue("oth_ecr_RB").length < 5)
			{
				showMessage("oth_ecr_RB", "Required by date should be of 5 characters(MM/YY)!","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			}
          /*
			var i = 0;
			var j = 0;
			var k = 0;
			var m = 0;
			try 
			{
				i = parseInt(getValue("DCI_ExpD").substring(0, 2));
				j = parseInt(getValue("DCI_ExpD").substring(3, 5));

				k = parseInt(getValue("oth_ecr_RB").substring(0, 2));
				m = parseInt(getValue("oth_ecr_RB").substring(3, 5));
			}
			catch (ex)
			{
				showMessage("oth_ecr_RB", "Required by date can only have digits and / in the format MM/YY","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			}
			if ((k <= 0) || (k > 12))
			{
				showMessage("oth_ecr_RB", "Invalid Value for Month!","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			}
			var localBoolean = Boolean.valueOf(false);

			if ((m > j) || ((m == j) && (k - 1 > i - 1)))
			{
				localBoolean = Boolean.valueOf(true);
			}
			if (localBoolean)
			{
				showMessage("oth_ecr_RB", "Required By date can't be greater than expiry date","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			} */

			if (!checkMonthDiff())
			{
				showMessage("oth_ecr_RB", "Difference between Expiry Date and Required by can't be greater than 3 Months","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			}
		}
		//alert("oth_ecr_RB : " + getValue("oth_ecr_RB"));
		if (getValue("oth_ecr_RR").length > 500)
		{
			showMessage("oth_ecr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_ecr_RR");
			return false;
		}

		
		//alert("oth_td_RNO : " + getValue("oth_td_RNO"));
		if (getValue("oth_td_RNO").length > 10)
		{
			showMessage("oth_td_RNO", "Reference Number Can't be greater than 10 characters!","error");
			setFocus("oth_td_RNO");
			setControlValue("oth_td_RNO", "");
			return false;
		}
	    
		if (getValue("oth_cdr_RR").length > 500)
		{
			showMessage("oth_cdr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_cdr_RR");
			return false;
		} 
		if (getValue("oth_td_RR").length > 500)
		{
			showMessage("oth_td_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
			setFocus("oth_td_RR");
			return false;
		}

		if (getValue("oth_rip_RR").length > 500)
		{
			showMessage("oth_rip_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_rip_RR");
			return false;
		}
		if(ActivityName == "Branch_Return")
		{
			if ((getValue("BR_Decision") == "") || (getValue("BR_Decision") == "--select--"))
			{
				showMessage("BR_Decision", "Branch Decision is Mandatory!","error");
				setFocus("BR_Decision");
				return false;
			}
		/*	if (getValue("BR_Remarks") == "")
			{
				showMessage("BR_Remarks", " Branch Remarks/Reasons is Mandatory!","error");
				setFocus("BR_Remarks");
				return false;
			}  */
			if (getValue("BR_Decision") == "Discard")
			{
				//alert("BR_Remarks : " + getValue("BR_Remarks"));
				if (getValue("BR_Remarks") == "")
				{
					showMessage("BR_Remarks", " Branch Remarks/Reasons is Mandatory!","error");
					setFocus("BR_Remarks");
					return false;
				}
			}
		}
		if(ActivityName == "Pending")
		{
			//alert("Combo_Pending_Dec : " + getValue("Pending_Decision"));
			if (getValue("Pending_Decision") == "")
			{
				showMessage("Pending_Decision", "Pending Decision is Mandatory!","error");
				setFocus("Pending_Decision");
				return false;
			}
		}

	}
/*	else if (ActivityName == "Branch_Return")
	{
		alert("BR_Decision : " + getValue("BR_Decision"));
		if ((getValue("BR_Decision") == "") || (getValue("BR_Decision") == "--select--"))
		{
			showMessage("BR_Decision", "Decision is Mandatory!","error");
			setFocus("BR_Decision");
			return false;
		}
		if (getValue("BR_Decision") == "Discard")
		{
			alert("BR_Remarks : " + getValue("BR_Remarks"));
			if (getValue("BR_Remarks") == "")
			{
				showMessage("BR_Remarks", "Remarks/Reasons is Mandatory!","error");
				setFocus("BR_Remarks");
				return false;
			}
		}
	}   */
	else if(ActivityName=="CARDS")
	{	
		if (getValue("Cards_Decision") == "")
		{
			showMessage("Cards_Decision", "Decision is Mandatory!","error");
			setFocus("Cards_Decision");
			return false;
		}
		if (getValue("Cards_Decision") == "Re-Submit to Branch")
		{
			if (getValue("Cards_Remarks") == "")
			{
				showMessage("Cards_Remarks", "Remarks/Reasons is Mandatory!","error");
				setFocus("Cards_Remarks");
				return false;
			}
		}
		if(getValue("Cards_Decision")=="CARDS_BR")
		{
		   if(getValue("Cards_Remarks")=="")
		   {
		   showMessage('Cards_Remarks',' Cards Remarks/Reasons is Mandatory!',"error");
		   setFocus("Cards_Remarks");
		   return false;
		   }
		}
	}



return true;
} 

function checkMonthDiff()
{
	if ((getValue("DCI_ExpD") == "") || (getValue("oth_ecr_RB") == ""))
	{
		return true;
	}
	var i = parseInt(getValue("DCI_ExpD").substring(0, 2));
	var j = parseInt(getValue("DCI_ExpD").substring(3, 5));

	var k = parseInt(getValue("oth_ecr_RB").substring(0, 2));
	var m = parseInt(getValue("oth_ecr_RB").substring(3, 5));

	if (k + 3 > 12)
	{
		m++;
		k -= 10;
	}
	else
	{
		k += 2;
	}

	var localBoolean = false;

	if ((m > j) || ((m == j) && (k - 1 > i - 1)) || ((m == j) && (k - 1 == i - 1))) 
	{
		localBoolean = true;
	}
	return localBoolean;
}