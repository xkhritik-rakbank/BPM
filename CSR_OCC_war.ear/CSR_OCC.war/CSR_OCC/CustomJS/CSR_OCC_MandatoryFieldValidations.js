function validateForSave() 
{
	//alert("validateForSave : " + ActivityName.toUpperCase());
	if ((ActivityName.toUpperCase().indexOf("INTRODUCTION") > -1) || (ActivityName.toUpperCase() == "PENDING") || (ActivityName.toUpperCase() == "BRANCH_RETURN"))
	{
		//alert("CardNo_Text : " + getValue("CardNo_Text"));
		/*if ((getValue("CardNo_Text") != null) && (getValue("CardNo_Text") != "") && (getValue("CardNo_Text") != "    -    -    -    ") && (!validateCCNo(getValue("CardNo_Text"), "CardNo_Text")))
		{
			setFocus("CardNo_Text");
			return false;
		} */	
		/*if (!CheckValueForField("CCI_ExtNo", getValue("CCI_ExtNo"), "Ext. No.", "digits"))
			return false;*/
		//alert("CCI_ExtNo : " + getValue("CCI_ExtNo"));
		if ((getValue("CCI_ExtNo") != "") && (getValue("CCI_ExtNo").length != 4))
		{
			showMessage("CCI_ExtNo", "Ext No. should be of 4 digits!","error");
			setFocus("CCI_ExtNo");
			return false;
		}
		//alert("oth_cr_RR : " + getValue("oth_cr_RR"));
		if (getValue("oth_cr_RR").length > 500)
		{
			showMessage("oth_cr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_cr_RR");
			return false;
		}
		//alert("oth_ssc_Amount : " + getValue("oth_ssc_Amount"));
		/*if (!validateAmount("oth_ssc_Amount", getValue("oth_ssc_Amount"))) 
		{
			return false;
		}*/
		if ((getValue("oth_ssc_Amount") != "") && (parseInt(getValue("oth_ssc_Amount").substring(0, getValue("oth_ssc_Amount").indexOf("."))) < 500))
		{
			showMessage("oth_ssc_Amount", "Value in amount field cannot be less than 500!","error");
			setFocus("oth_ssc_Amount");
			return false;
		}
		//alert("oth_ssc_RR : " + getValue("oth_ssc_RR"));
		if (getValue("oth_ssc_RR").length > 500)
		{
			showMessage("oth_ssc_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
			setFocus("oth_ssc_RR");
			return false;
		}
		/*if (!validateAmount("oth_cs_Amount", getValue("oth_cs_Amount"))) {
			return false;
		}*/
		//alert("oth_cs_RR : " + getValue("oth_cs_RR"));
		if (getValue("oth_cs_RR").length > 500)
		{
			showMessage("oth_cs_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
			setFocus("oth_cs_RR");
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

			var i = 0;
			var j = 0;
			var k = 0;
			var m = 0;
			try 
			{
				i = parseInt(getValue("CCI_ExpD").substring(0, 2));
				j = parseInt(getValue("CCI_ExpD").substring(3, 5));

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
			}

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
		//alert("REQUEST_TYPE : " + getValue("request_type"));
		//alert("CCI_CT : " + getValue("CCI_CT"));
		if ((getValue("request_type") == "Card Upgrade") && (getValue("CCI_CT") == "T"))
		{
			showMessage("CCI_CT", "Card can't be upgraded as card type is Titanium!","error");
			setFocus("CCI_CT");
			return false;
		}
		//alert("oth_cu_RR : " + getValue("oth_cu_RR"));
		if (getValue("oth_cu_RR").length > 500)
		{
			showMessage("oth_cu_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
			setFocus("oth_cu_RR");
			return false;
		}

		/*if (!CheckValueForField("oth_td_RNO", getValue("oth_td_RNO"), "Reference No.", "digits"))
			return false;*/
		//alert("oth_td_RNO : " + getValue("oth_td_RNO"));
		if (getValue("oth_td_RNO").length > 10)
		{
			showMessage("oth_td_RNO", "Reference Number Can't be greater than 10 characters!","error");
			setFocus("oth_td_RNO");
			setControlValue("oth_td_RNO", "");
			return false;
		}
		/*if (!validateAmount("oth_td_Amount", getValue("oth_td_Amount"))) 
		{
			return false;
		}*/
		if (getValue("oth_td_RR").length > 500)
		{
			showMessage("oth_td_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
			setFocus("oth_td_RR");
			return false;
		}
		if ((getValue("oth_cli_months") != "") && (getValue("oth_cli_months") != "0") && (getValue("oth_cli_months") != "1") && (getValue("oth_cli_months") != "2") && (getValue("oth_cli_months") != "3"))
		{
			setControlValue("oth_cli_months", "");
			setFocus("oth_cli_months");
			showMessage("oth_cli_months", "Invalid data in Months Only 0,1,2,3 are allowed.","error");
			return false;
		}

		if (getValue("oth_cli_RR").length > 500)
		{
			showMessage("oth_cli_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_cli_RR");
			return false;
		}

		if ((getValue("oth_csi_CSIP") == true) && (getValue("oth_csi_POSTMTB") != "") && (!containsOnlyNumbers(getValue("oth_csi_POSTMTB"))))
		{
			showMessage("oth_csi_POSTMTB", "New date Should be Numeric","error");
			setFocus("oth_csi_POSTMTB");
			setControlValue("oth_csi_POSTMTB", "");
			return false;
		}
		if ((getValue("oth_csi_CSIP") == true) && (!getValue("oth_csi_POSTMTB") == "") && ((parseInt(getValue("oth_csi_POSTMTB")) <= 2) || (parseInt(getValue("oth_csi_POSTMTB")) >= 101)))
		{
			showMessage("oth_csi_POSTMTB", "% Of STMT Balance should be between 3 and 100 both inclusive.","error");
			setFocus("oth_csi_POSTMTB");
			setControlValue("oth_csi_POSTMTB", "");
			return false;
		}
		if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") != "") && (!containsOnlyNumbers(getValue("oth_csi_ND"))))
		{
			showMessage("oth_csi_ND", "New date Should be Numeric","error");
			setFocus("oth_csi_ND");
			setControlValue("oth_csi_ND", "");
			return false;
		}
		if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") != "") && (parseInt(getValue("oth_csi_ND")) > 31))
		{
			showMessage("oth_csi_ND", "New date can't be greater than 31","error");
			//setControlValue("oth_csi_ND", "");
			setFocus("oth_csi_ND");
			return false;
		}
		if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") != "") && (parseInt(getValue("oth_csi_ND")) == 0))
		{
			showMessage("oth_csi_ND", "New date can't be zero","error");
			setControlValue("oth_csi_ND", "");
			setFocus("oth_csi_ND");
			return false;
		}

		if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") != "") && (!containsOnlyNumbers(getValue("oth_csi_AccNo"))))
		{
			showMessage("oth_csi_AccNo", "Only Numerics are allowed in Account No.","error");
			setControlValue("oth_csi_AccNo", "");
			setFocus("oth_csi_AccNo");
			return false;
		}
		if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") != "") && (getValue("oth_csi_AccNo").length < 13))
		{
			showMessage("oth_csi_AccNo", "Account No. Should be of length 13","error");
			setFocus("oth_csi_AccNo");
			return false;
		}
		if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") != "") && (Number(getValue("oth_csi_AccNo")) == "0L"))
		{
			showMessage("oth_csi_AccNo", "Account No. can't be Zero","error");
			setControlValue("oth_csi_AccNo", "");
			setFocus("oth_csi_AccNo");
			return false;
		}

		if (getValue("oth_csi_RR").length > 500)
		{
			showMessage("oth_csi_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_csi_RR");
			return false;
		}

		if (getValue("oth_rip_RR").length > 500)
		{
			showMessage("oth_rip_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("oth_rip_RR");
			return false;
		}

	}
	return true;
}

function validateMandatoryForPending() 
{
	//alert("inside validateMandatoryForPending");
	//alert("CardNo_Text :"+getValue("CardNo_Text"));
	/*if ((getValue("CardNo_Text") != null) && (getValue("CardNo_Text") != "") && (getValue("CardNo_Text") != "    -    -    -    ") && (!validateCCNo(getValue("CardNo_Text"), "CardNo_Text")))
	{
		setFocus("CardNo_Text");
		return false;
	}*/
	/*if (!CheckValueForField("CCI_ExtNo", getValue("CCI_ExtNo"), "Ext. No.", "digits"))
		return false;*/
	//alert("CCI_ExtNo :"+getValue("CCI_ExtNo"));
	if ((getValue("CCI_ExtNo") != "") && (getValue("CCI_ExtNo").length != 4))
	{
		showMessage("CCI_ExtNo", "Ext No. should be of 4 digits!","error");
		setFocus("CCI_ExtNo");
		return false;
	}

	//if (!validateAmount("oth_ssc_Amount", getValue("oth_ssc_Amount")))
	//{
	//	return false;
	//}
	//alert("oth_ssc_Amount :"+getValue("oth_ssc_Amount"));
	if ((getValue("oth_ssc_Amount") != "") && (parseInt(getValue("oth_ssc_Amount").substring(0, getValue("oth_ssc_Amount").indexOf("."))) < 500))
	{
		showMessage("oth_ssc_Amount", "Value in amount field cannot be less than 500!","error");
		setFocus("oth_ssc_Amount");
		return false;
	}
	//if (!validateAmount("oth_cs_Amount", getValue("oth_cs_Amount")))
	//{
	//	return false;
	//}
	//alert("oth_ecr_RB :"+getValue("oth_ecr_RB"));
	if (getValue("oth_ecr_RB") != "")
	{
		if (getValue("oth_ecr_RB").length < 5)
		{
			showMessage("oth_ecr_RB", "Required by date should be of 5 characters(MM/YY)!","error");
			setFocus("oth_ecr_RB");
			setControlValue("oth_ecr_RB", "");
			return false;
		}
		var i = 0;
		var j = 0;
		var k = 0;
		var m = 0;
		try 
		{
			if ((getValue("CCI_ExpD") != "") && (getValue("CCI_ExpD") != "Null") && (getValue("CCI_ExpD") != null))
			{
				i = parseInt(getValue("CCI_ExpD").substring(0, 2));
				j = parseInt(getValue("CCI_ExpD").substring(3, 5));
			}
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
		var localBoolean = false;
		if ((getValue("CCI_ExpD") != "") && (getValue("CCI_ExpD") != "Null") && (getValue("CCI_ExpD") != null))
		{
			if ((m > j) || ((m == j) && (k - 1 > i - 1))) 
			{
				localBoolean = true;
			}
			if (localBoolean)
			{
				showMessage("oth_ecr_RB", "Required By date can't be greater than expiry date","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			}

			if (!checkMonthDiff())
			{
				showMessage("oth_ecr_RB", "Difference between Expiry Date and Required by can't be greater than 3 Months","error");
				setFocus("oth_ecr_RB");
				setControlValue("oth_ecr_RB", "");
				return false;
			}
		}
	}
	//alert("REQUEST_TYPE :"+getValue("request_type"));
	//alert("CCI_CT :"+getValue("CCI_CT"));
	if ((getValue("request_type") == "Card Upgrade") && (getValue("CCI_CT") == "T"))
	{
		showMessage("CCI_CT", "Card can't be upgraded as card type is Titanium!","error");
		setFocus("CCI_CT");
		return false;
	}
	/*if (!CheckValueForField("oth_td_RNO", getValue("oth_td_RNO"), "Reference No.", "digits"))
		return false;*/
	if (getValue("oth_td_RNO").length > 10)
	{
		showMessage("oth_td_RNO", "Reference Number Can't be greater than 10 characters!","error");
		setControlValue("oth_td_RNO", "");
		setFocus("oth_td_RNO");
		return false;
	}
	if (!validateAmount("oth_td_Amount", getValue("oth_td_Amount"))) {
		return false;
	}
	if ((getValue("oth_cli_months") != "") && (getValue("oth_cli_months") != "0") && (getValue("oth_cli_months") != "1") && (getValue("oth_cli_months") != "2") && (getValue("oth_cli_months") != "3"))
	{
		setControlValue("oth_cli_months", "");
		setFocus("oth_cli_months");
		showMessage("oth_cli_months", "Invalid data in Months Only 0,1,2,3 are allowed.","error");
		return false;
	}
	if ((getValue("oth_csi_CSIP") == true) && (getValue("oth_csi_POSTMTB") != "") && (!containsOnlyNumbers(getValue("oth_csi_POSTMTB"))))
	{
		showMessage("oth_csi_POSTMTB", "New date Should be Numeric","error");
		setFocus("oth_csi_POSTMTB");
		setControlValue("oth_csi_POSTMTB", "");
		return false;
	}

	if ((getValue("oth_csi_CSIP") == true) && (getValue("oth_csi_POSTMTB") != "") && ((parseInt(getValue("oth_csi_POSTMTB")) <= 2) || (parseInt(getValue("oth_csi_POSTMTB")) >= 101)))
	{
		showMessage("oth_csi_POSTMTB", "% Of STMT Balance should be between 3 and 100 both inclusive.","error");
		setControlValue("oth_csi_POSTMTB", "");
		setFocus("oth_csi_POSTMTB");
		return false;
	}
	if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") != "") && (!containsOnlyNumbers(getValue("oth_csi_ND"))))
	{
		showMessage("oth_csi_ND", "New date Should be Numeric","error");
		setControlValue("oth_csi_ND", "");
		setFocus("oth_csi_ND");
		return false;
	}
	if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") != "") && (parseInt(getValue("oth_csi_ND")) > 31))
	{
		showMessage("oth_csi_ND", "New date can't be greater than 31","error");
		setControlValue("oth_csi_ND", "");
		setFocus("oth_csi_ND");
		return false;
	}
	if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") != "") && (parseInt(getValue("oth_csi_ND")) == 0))
	{
		showMessage("oth_csi_ND", "New date can't be zero","error");
		setControlValue("oth_csi_ND", "");
		setFocus("oth_csi_ND");
		return false;
	}

	if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") != "") && (!containsOnlyNumbers(getValue("oth_csi_AccNo"))))
	{
		showMessage("oth_csi_AccNo", "Only Numerics are allowed in Account No.","error");
		setControlValue("oth_csi_AccNo", "");
		setFocus("oth_csi_AccNo");
		return false;
	}
	if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") != "") && (getValue("oth_csi_AccNo").length < 13))
	{
		showMessage("oth_csi_AccNo", "Account No. Should be of length 13","error");
		setFocus("oth_csi_AccNo");
		return false;
	}
	if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") != "") && (Number(getValue("oth_csi_AccNo")) == "0L"))
	{
		showMessage("oth_csi_AccNo", "Account No. can't be Zero","error");
		setControlValue("oth_csi_AccNo", "");
		setFocus("oth_csi_AccNo");
		return false;
	}

	if (getValue("oth_td_RR").length > 500)
	{
		showMessage("oth_td_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_td_RR");
		return false;
	}
	if (getValue("oth_cu_RR").length > 500)
	{
		showMessage("oth_cu_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_cu_RR");
		return false;
	}
	if (getValue("oth_ssc_RR").length > 500)
	{
		showMessage("oth_ssc_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_ssc_RR");
		return false;
	}
	if (getValue("oth_cdr_RR").length > 500)
	{
		showMessage("oth_cdr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_cdr_RR");
		return false;
	}
	if (getValue("oth_cs_RR").length > 500)
	{
		showMessage("oth_cs_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_cs_RR");
		return false;
	}
	if (getValue("oth_rip_RR").length > 500)
	{
		showMessage("oth_rip_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_rip_RR");
		return false;
	}
	if (getValue("oth_cr_RR").length > 500)
	{
		showMessage("oth_cr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_cr_RR");
		return false;
	}
	if (getValue("oth_cli_RR").length > 500)
	{
		showMessage("oth_cli_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_cli_RR");
		return false;
	}
	if (getValue("oth_ecr_RR").length > 500)
	{
		showMessage("oth_ecr_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_ecr_RR");
		return false;
		}
	if (getValue("oth_csi_RR").length > 500)
	{
		showMessage("oth_csi_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
		setFocus("oth_csi_RR");
		return false;
	}
	return true;
}

function validateMandatory()
{
	if ((ActivityName.toUpperCase().indexOf("INTRODUCTION") > -1) || (ActivityName.toUpperCase() == "PENDING") || (ActivityName.toUpperCase() == "BRANCH_RETURN"))
	{
		if (ActivityName.toUpperCase().indexOf("WORK INTRODUCTION") > -1)
		{
			if (getValue("CCI_CName") == "")
			{
				showMessage("CCI_CName", "Please enter card no and click refresh button to fetch card data!","error");
				setFocus("CardNo_Text");
				return false;
			}
		}
		else if (ActivityName.toUpperCase() != "BRANCH_RETURN")
		{
			//if ((getValue("CardNo_Text") != null) && (getValue("CardNo_Text") != "") && (getValue("CardNo_Text") != "    -    -    -    ") && (!validateCCNo(getValue("CardNo_Text"), "CardNo_Text")))
			//{
			//	setFocus("CardNo_Text");
			//	return false;
			//}
			if (getValue("CCI_ExtNo") == "")
			{
				showMessage("CCI_ExtNo", "Ext No. is Mandatory!","error");
				setFocus("CCI_ExtNo");
				return false;
			}
			/*if (!CheckValueForField("CCI_ExtNo", getValue("CCI_ExtNo"), "Ext. No.", "digits"))
				return false;*/
			if (getValue("CCI_ExtNo").length != 4)
			{
				showMessage("CCI_ExtNo", "Ext No. should be of 4 digits!","error");
				setFocus("CCI_ExtNo");
				return false;
			}
			if ((getValue("VD_MoMaidN") == false) && (getValue("VD_TINCHECK") == false))
			{
				showMessage("VD_TINCHECK", "Atleast one of Verification Details is Mandatory!","error");
				setFocus("VD_TINCHECK");
				return false;
			}
			var i;
			if (getValue("VD_MoMaidN") == true)
			{
				i = 0;
				if (getValue("VD_DOB") == true) i++;
				if (getValue("VD_StaffId") == true) i++;
				if (getValue("VD_POBox") == true) i++;
				if (getValue("VD_PassNo") == true) i++;
				if (getValue("VD_Oth") == true) i++;
				if (getValue("VD_MRT") == true) i++;
				if (getValue("VD_EDC") == true) i++;
				if (getValue("VD_NOSC") == true) i++;
				if (getValue("VD_TELNO") == true) i++;
				if (getValue("VD_SD") == true) i++;
				if (i < 4)
				{
					showMessage("VD_MoMaidN", "Please select atleast 4 Random Questions!","error");
					setFocus("VD_MoMaidN");
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
				if ((getValue("OTH_CR_OPS") == "") && (getValue("oth_cr_reason") == "OTHERS"))
				{
					showMessage("OTH_CR_OPS", "Others Pls. Specify is Mandatory!","error");
					setFocus("OTH_CR_OPS");
					return false;
				}
				if (getValue("oth_cr_DC") == "")
				{
					showMessage("oth_cr_DC", "Delivery Channel is Mandatory!","error");
					setFocus("oth_cr_DC");
					return false;
				}
				if ((getValue("oth_cr_DC") == "BRANCH") && (getValue("CR_BRANCH") == ""))
				{
					showMessage("CR_BRANCH", "Branch Name is Mandatory!","error");
					setFocus("CR_BRANCH");
					return false;
				}
				if ((getValue("oth_cr_RR") == "") && (getValue("CR_BRANCH") == "OTHERS"))
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
			else if (getValue("request_type") == "Setup Suppl. Card Limit")
			{
				if (getValue("oth_ssc_Amount") == "")
				{
					showMessage("oth_ssc_Amount", "AMOUNT is Mandatory!","error");
					setFocus("oth_ssc_Amount");
					return false;
				}
				//if (!validateAmount("oth_ssc_Amount", getValue("oth_ssc_Amount")))
				//	return false;
				if (parseInt(getValue("oth_ssc_Amount").substring(0, getValue("oth_ssc_Amount").indexOf("."))) < 500)
				{
					showMessage("oth_ssc_Amount", "Value in amount field cannot be less than 500!","error");
					setFocus("oth_ssc_Amount");
					return false;
				}
				if ((getValue("oth_ssc_SCNo") == null) || (getValue("oth_ssc_SCNo") == ""))
				{
					showMessage("oth_ssc_SCNo", "Supplementary Card No. is Mandatory!","error");
					setFocus("oth_ssc_SCNo");
					return false;
				}
				if (getValue("oth_ssc_RR") == "")
				{
					showMessage("oth_ssc_RR", "Remarks/Reasons is Mandatory!","error");
					setFocus("oth_ssc_RR");
					return false;
				}
				if (getValue("oth_ssc_RR").length > 500)
				{
					showMessage("oth_ssc_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
					setFocus("oth_ssc_RR");
					return false;
				}
			}
			else if (getValue("request_type") == "Credit Shield")
			{
				//alert("oth_cs_CS : " + getValue("oth_cs_CS"));
				if (getValue("oth_cs_CS") == "")
				{
					showMessage("oth_cs_CS", "Credit Shield is Mandatory!","error");
					setFocus("oth_cs_CS");
					return false;
				}
				//alert("OTH_CS_CSR : " + getValue("OTH_CS_CSR"));
				//alert("oth_cs_Amount : " + getValue("oth_cs_Amount"));
				if ((getValue("OTH_CS_CSR") == true) && (getValue("oth_cs_Amount") == null) || (getValue("oth_cs_Amount") == ""))
				{
					showMessage("oth_cs_Amount", "Amount is Mandatory!","error");
					setFocus("oth_cs_Amount");
					return false;
				}
				//if (!validateAmount("oth_cs_Amount", getValue("oth_cs_Amount")))
				//	return false;
				//alert("oth_cs_RR : " + getValue("oth_cs_RR"));
				if ((getValue("oth_cs_RR") == "") && (getValue("oth_cs_CS") == "UN-ENROLLEMENT"))
				{
					showMessage("oth_cs_RR", "Remarks/Reasons is Mandatory!","error");
					setFocus("oth_cs_RR");
					return false;
				}
				if (getValue("oth_cs_RR").length > 500)
				{
					showMessage("oth_cs_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
					setFocus("oth_cs_RR");
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
				if ((getValue("oth_cdr_CDT") == "BANK") && (getValue("CDR_BRANCH") == ""))
				{
					showMessage("CDR_BRANCH", "Branch Name is Mandatory!","error");
					setFocus("CDR_BRANCH");
					return false;
				}
				//alert("oth_cdr_RR : " + getValue("oth_cdr_RR"));
				if ((getValue("oth_cdr_RR") == "") && (getValue("CDR_BRANCH") == "OTHERS"))
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

				if (getValue("oth_ecr_RB").length < 5)
				{
					showMessage("oth_ecr_RB", "Required by date should be of 5 characters(MM/YY)!","error");
					setFocus("oth_ecr_RB");
					setControlValue("oth_ecr_RB", "");
					return false;
				}
				i = 0;
				var j = 0;
				var k = 0;
				var m = 0;
				try {
					alert("CCI_ExpD : " + getValue("CCI_ExpD"));
					if ((getValue("CCI_ExpD") != "") && (getValue("CCI_ExpD") != "Null") && (getValue("CCI_ExpD") != null))
					{
						i = parseInt(getValue("CCI_ExpD").substring(0, 2));
						j = parseInt(getValue("CCI_ExpD").substring(3, 5));
					}
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
				if ((getValue("CCI_ExpD") != "") && (getValue("CCI_ExpD") != "Null") && (getValue("CCI_ExpD") != null))
				{
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
					}
					if (!checkMonthDiff())
					{
						showMessage("oth_ecr_RB", "Difference between Expiry Date and Required by can't be greater than 3 Months","error");
						setFocus("oth_ecr_RB");
						setControlValue("oth_ecr_RB", "");
						return false;
					}
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
			else if (getValue("request_type") == "Card Upgrade")
			{
				//alert("CCI_CT : " + getValue("CCI_CT"));
				if (getValue("CCI_CT") == "T")
				{
					showMessage("CCI_CT", "Card can't be upgraded as card type is Titanium!","error");
					setFocus("CCI_CT");
					return false;
				}
				//alert("oth_cu_RR : " + getValue("oth_cu_RR"));
				if (getValue("oth_cu_RR") == "")
				{
					showMessage("oth_cu_RR", "Remarks/Reasons is Mandatory!","error");
					setFocus("oth_cu_RR");
					return false;
				}
				if (getValue("oth_cu_RR").length > 500)
				{
					showMessage("oth_cu_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
					setFocus("oth_cu_RR");
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

				/*if (!CheckValueForField("oth_td_RNO", getValue("oth_td_RNO"), "Reference No.", "digits"))
				{
					return false;
				}*/
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
				if (!validateAmount("oth_td_Amount", getValue("oth_td_Amount")))
					return false;
				//alert("oth_td_RR : " + getValue("oth_td_RR"));
				if (getValue("oth_td_RR").length > 500)
				{
					showMessage("oth_td_RR", "Remarks/Reasons can't be greater than 500 Characters!","error");
					setFocus("oth_td_RR");
					return false;
				}
			}
			else if (getValue("request_type") == "Credit Limit Increase")
			{
				//alert("oth_cli_type : " + getValue("oth_cli_type"));
				if (getValue("oth_cli_type") == "")
				{
					showMessage("oth_cli_type", "Type is Mandatory!","error");
					setFocus("oth_cli_type");
					return false;
				}
				//alert("oth_cli_months : " + getValue("oth_cli_months"));
				if ((getValue("oth_cli_type") == "TEMPORARY") && (getValue("oth_cli_months") == ""))
				{
					showMessage("oth_cli_months", "Months is Mandatory!","error");
					setFocus("oth_cli_months");
					return false;
				}
				if ((getValue("oth_cli_months") != "") && (getValue("oth_cli_months") != "0") && (getValue("oth_cli_months") != "1") && (getValue("oth_cli_months") != "2") && (getValue("oth_cli_months") != "3"))
				{
					setControlValue("oth_cli_months", "");
					setFocus("oth_cli_months");
					showMessage("oth_cli_months", "Invalid data in Months Only 0,1,2,3 are allowed.","error");
					return false;
				}
				//alert("oth_cli_RR : " + getValue("oth_cli_RR"));
				if (getValue("oth_cli_RR").length > 500)
				{
					showMessage("oth_cli_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
					setFocus("oth_cli_RR");
					return false;
				}
			}
			else if (getValue("request_type") == "Change in Standing Instructions")
			{
				//alert("oth_csi_PH : " + getValue("oth_csi_PH"));
				if ((getValue("oth_csi_PH") == false) && (getValue("oth_csi_CSIP") == false) && (getValue("oth_csi_CDACNo") == false) && (getValue("oth_csi_CSID") == false))
				{
					showMessage("oth_csi_PH", "At least one Instruction should be checked/selected.!","error");
					setFocus("oth_csi_PH");
					return false;
				}
				//alert("oth_csi_TOH : " + getValue("oth_csi_TOH"));
				//alert("oth_csi_NOM : " + getValue("oth_csi_NOM"));
				if ((getValue("oth_csi_TOH") == "TEMPORARY") && (getValue("oth_csi_NOM") == ""))
				{
					showMessage("oth_csi_NOM", "Months is Mandatory","error");
					setFocus("oth_csi_NOM");
					return false;
				}
				//alert("oth_csi_PH : " + getValue("oth_csi_PH"));
				if ((getValue("oth_csi_PH") == true) && (getValue("oth_csi_TOH") == ""))
				{
					showMessage("oth_csi_TOH", "Type of Hold is Mandatory","error");
					setFocus("oth_csi_TOH");
					return false;
				}
				//alert("oth_csi_CSIP : " + getValue("oth_csi_CSIP"));
				if ((getValue("oth_csi_CSIP") == true) && (getValue("oth_csi_POSTMTB") == ""))
				{
					showMessage("oth_csi_POSTMTB", "% Of STMT Balance is Mandatory.","error");
					setFocus("oth_csi_POSTMTB");
					return false;
				}
				//alert("oth_csi_POSTMTB : " + getValue("oth_csi_POSTMTB"));
				if ((getValue("oth_csi_CSIP") == true) && (getValue("oth_csi_POSTMTB") != "") && (!containsOnlyNumbers(getValue("oth_csi_POSTMTB"))))
				{
					showMessage("oth_csi_POSTMTB", "New date Should be Numeric","error");
					setFocus("oth_csi_POSTMTB");
					setControlValue("oth_csi_POSTMTB", "");
					return false;
				}
				if ((getValue("oth_csi_CSIP") == true) && ((parseInt(getValue("oth_csi_POSTMTB")) <= 2) || (parseInt(getValue("oth_csi_POSTMTB")) >= 101)))
				{
					showMessage("oth_csi_POSTMTB", "% Of STMT Balance should be between 3 and 100 both inclusive.","error");
					setControlValue("oth_csi_POSTMTB", "");
					setFocus("oth_csi_POSTMTB");
					return false;
				}
				//alert("oth_csi_CSID : " + getValue("oth_csi_CSID"));
				if ((getValue("oth_csi_CSID") == true) && (getValue("oth_csi_ND") == ""))
				{
					showMessage("oth_csi_ND", "New date is Mandatory.","error");
					setFocus("oth_csi_ND");
					return false;
				}
				//alert("oth_csi_ND : " + getValue("oth_csi_ND"));
				if ((getValue("oth_csi_CSID") == true) && (!containsOnlyNumbers(getValue("oth_csi_ND"))))
				{
					showMessage("oth_csi_ND", "New date Should be Numeric","error");
					setControlValue("oth_csi_ND", "");
					setFocus("oth_csi_ND");
					return false;
				}

				if ((getValue("oth_csi_CSID") == true) && (parseInt(getValue("oth_csi_ND")) > 31))
				{
					showMessage("oth_csi_ND", "New date can't be greater than 31","error");
					setControlValue("oth_csi_ND", "");
					setFocus("oth_csi_ND");
					return false;
				}
				if ((getValue("oth_csi_CSID") == true) && (parseInt(getValue("oth_csi_ND")) == 0))
				{
					showMessage("oth_csi_ND", "New date can't be zero","error");
					setControlValue("oth_csi_ND", "");
					setFocus("oth_csi_ND");
					return false;
				}
				//alert("oth_csi_CDACNo : " + getValue("oth_csi_CDACNo"));
				//alert("oth_csi_AccNo : " + getValue("oth_csi_AccNo"));
				if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo") == ""))
				{
					showMessage("oth_csi_AccNo", "Account No. is Mandatory","error");
					setFocus("oth_csi_AccNo");
					return false;
				}
				if ((getValue("oth_csi_CDACNo") == true) && (!containsOnlyNumbers(getValue("oth_csi_AccNo"))))
				{
					showMessage("oth_csi_AccNo", "Only Numerics are allowed in Account No.","error");
					setControlValue("oth_csi_AccNo", "");
					setFocus("oth_csi_AccNo");

					return false;
				}
				if ((getValue("oth_csi_CDACNo") == true) && (getValue("oth_csi_AccNo").length < 13))
				{
					showMessage("oth_csi_AccNo", "Account No. Should be of length 13","error");
					setControlValue("oth_csi_AccNo", "");
					setFocus("oth_csi_AccNo");
					return false;
				}
				if ((getValue("oth_csi_CDACNo") == true) && (Number(getValue("oth_csi_AccNo")) == "0L"))
				{
					showMessage("oth_csi_AccNo", "Account No. can't be Zero","error");
					setControlValue("oth_csi_AccNo", "");
					setFocus("oth_csi_AccNo");
					return false;
				}
				//alert("oth_csi_TOH : " + getValue("oth_csi_TOH"));
				//alert("oth_csi_RR : " + getValue("oth_csi_RR"));
				if ((getValue("oth_csi_TOH") == "TEMPORARY") && (getValue("oth_csi_RR") == ""))
				{
					showMessage("oth_csi_RR", "Remarks/Reasons is Mandatory","error");
					setFocus("oth_csi_RR");
					return false;
				}
				//alert("oth_csi_PH : " + getValue("oth_csi_PH"));
				if ((getValue("oth_csi_PH") == true) && (getValue("oth_csi_RR") == ""))
				{
					showMessage("oth_csi_RR", "Remarks/Reasons is Mandatory","error");
					setFocus("oth_csi_RR");
					return false;
				}
				if (getValue("oth_csi_RR").length > 500)
				{
					showMessage("oth_csi_RR", "Remarks/Reasons can't be greater than 500 Characters","error");
					setFocus("oth_csi_RR");
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
				if ((getValue("oth_rip_DC") == "BRANCH") && (getValue("RIP_BRANCH") == ""))
				{
					showMessage("RIP_BRANCH", "Branch Name is Mandatory!","error");
					setFocus("RIP_BRANCH");
					return false;
				}
				//alert("oth_rip_RR : " + getValue("oth_rip_RR"));
				if ((getValue("oth_rip_RR") == "") && (getValue("RIP_BRANCH") == "OTHERS"))
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
			if (ActivityName.toUpperCase() == "PENDING")
			{
				//alert("Combo_Pending_Dec : " + getValue("Combo_Pending_Dec"));
				if (getValue("Pending_Decision") == "")
				{
					showMessage("Pending_Decision", "Pending Decision is Mandatory!","error");
					setFocus("Pending_Decision");
					return false;
				}
			}
		}
		
	}
	if (ActivityName.toUpperCase() == "BRANCH_RETURN")
	{
		//alert("BR_Decision : " + getValue("BR_Decision"));
		if ((getValue("BR_Decision") == "") || (getValue("BR_Decision") == "--select--"))
		{
			showMessage("BR_Decision", "Decision is Mandatory!","error");
			setFocus("BR_Decision");
			return false;
		}
		if (getValue("BR_Decision") == "Discard")
		{
			//alert("BR_REMARKS : " + getValue("BR_REMARKS"));
			if (getValue("BR_Remarks") == "")
			{
				showMessage("BR_Remarks", "Remarks/Reasons is Mandatory!","error");
				setFocus("BR_Remarks");
				return false;
			}
		}
	}
	if(ActivityName.toUpperCase()=="CARDS")
	{	
		if (getValue("Cards_Decision") == "")
		{
			showMessage("Cards_Decision", "Decision is Mandatory!","error");
			setFocus("Cards_Decision");
			return false;
		}
		if (getValue("Cards_Decision") == "CARDS_BR")
		{
			if (getValue("Cards_Remarks") == "")
			{
				showMessage("Cards_Remarks", "Remarks/Reasons is Mandatory!","error");
				setFocus("Cards_Remarks");
				return false;
			}
		}
	}
	return true;
}
function validateCCNo(paramString1,paramString2) 
{
	//alert("paramString1 :"+paramString1+" paramString2 :"+paramString2);
	if ((paramString1 != "") && ((paramString1.length != 19) || (!isInteger(paramString1.substring(0, 4))) || (!isInteger(paramString1.substring(5, 9))) || (!isInteger(paramString1.substring(10, 14))) || (!isInteger(paramString1.substring(15, 19)))))
	{
		showMessage("CardNo_Text", "Invalid Credit Card No. Format","error");
		setControlValue(paramString1, "");
		return false;
	}

	var str = paramString1.replace(/-/gi, '');
	var arrayOfInt = [str.length];
	var i = 0; var j = 0;
	for (i = 0; i < str.length; i++)
	{
		arrayOfInt[i] = parseInt(str.charAt(i) + "");
	}
	for (i = arrayOfInt.length - 2; i >= 0; i -= 2)
	{
		arrayOfInt[i] *= 2;
		if (arrayOfInt[i] > 9)
		{
			arrayOfInt[i] -= 9;
		}
	}
	for (i = 0; i < arrayOfInt.length; i++)
	{
		j += arrayOfInt[i];
	}

	if (j % 10 == 0)
	{
		return true;
	}

	showMessage("CardNo_Text", "Invalid Credit Card No. Format","error");
	return false;
}

function isInteger(paramString)
{
	var bool = false;
	try 
	{
		var i = parseInt(paramString);
		bool = true;
	}		
	catch (ex) 
	{
	}
	return bool;
}
function CheckValueForField(paramString1,paramString2,paramString3,paramString4) 
{
	alert("inside  CheckValueForField ...new 1: " + paramString1);
	var str1 = paramString2;
	var bool = false;
	var str2 = "";
	if (paramString2 == "")
	{
		return Boolean(true);
	}
	if ((paramString4 == "") || (paramString4 == "date"))
	{
		return Boolean(true);
	}
	if (paramString4 == "name")
		str2 = "[a-zA-Z-9 \t]*";
	else if (paramString4 == "digits_alphabets")
		str2 = "[0-9A-Za-z- \t]*";
	else if (paramString4 == "digits_space")
		str2 = "[0-9- \t]*";
	else if (paramString4 == "digits")
		str2 = "[0-9-\t]*";
	else if (paramString4 == "decimal")
		str2 = "[0-9.0-9-\t]*";
	else if (paramString4 == "alpha")
		str2 = "[a-zA-Z-9 \t]*";
	else if (paramString4 == "address")
		str2 = "[0-9A-Za-z- \t(){},.:;/]*";
	else if (paramString4 == "all")
		str2 = "[0-9a-zA-Z -!@#$%^&*'<>?(){},.:;\t/-]*";
	else if (paramString4 == "alphabets")
		str2 = "[a-zA-Z-9\t]*";
	else if (paramString4 == "CardNo_Text")
		str2 = "^([0-9]{0,4}|[0-9]{4}-|[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{0,4}|[0-9]{4}-[0-9]{4}-[0-9]{4}-|[0-9]{4}-[0-9]{4}-[0-9]{4}-[0-9]{0,4})$";
	
	bool = str2.match(str1);
	if (!bool)
	{
		if ((paramString4 == "name") || (paramString4 == "digits_alphabets") || (paramString4 == "digits_space") || (paramString4 == "digits") || (paramString4 == "decimal") || (paramString4 == "address") || (paramString4 == "alpha") || (paramString4 == "all") || (paramString4 == "alphabets"))
		{
			if (paramString4 == "alphanumeric")
			{
				showMessage(paramString1, "Only alphabets,numbers and spaces are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "digits")
			{
				showMessage(paramString1, "Only numbers are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "digits_space")
			{
				showMessage(paramString1, "Only numbers are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "decimal")
			{
				showMessage(paramString1, "Only decimal numbers are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "digits_alphabets")
			{
				showMessage(paramString1, "Only numbers and alphabets spaces are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "account_no")
			{
				showMessage(paramString1, "Only numbers and alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "alpha")
			{
				showMessage(paramString1, "Only alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "name")
			{
				showMessage(paramString1, "Only alphabets and spaces are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "alphabets")
			{
				showMessage(paramString1, "Only alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "pan_no")
			{
				showMessage(paramString1, "Only numbers and alphabets are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "all")
			{
				showMessage(paramString1, "Only numbers and alphabets spaces ,dot,comma !@#$%^&*'<>?(){},.:; and - are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "address")
			{
				showMessage(paramString1, "Only numbers and alphabets spaces ,dot,comma (){},.:; and - are allowed in " + paramString3 + ".","error");
			}
			else if (paramString4 == "email")
			{
				showMessage(paramString1, "Enter valid email id in " + paramString3 + ".","error");
			}

			setFocus(paramString1);
			setControlValue(paramString1, "");
			return Boolean(false);
		}

		return Boolean(false);
	}

	return Boolean(true);
}

function validateAmount(paramString1,paramString2) 
{
	var str1 = ".00";
	var str2;
	if ((paramString2 != "") && (paramString2.indexOf(".") > -1))
	{
		str2 = paramString2.replace(/,/gi, '');
		while ((str2 != null) && (str2.indexOf("0") == 0))
		{
			str2 = str2.substring(1);
			if ((str2 == null) || (str2 == "") || (str2 == ".00") || (str2 == ".0") || (str2 == "."))
			{
				showMessage(paramString1, "Invalid Amount has been entered","error");
				setControlValue(paramString1, "");
				setFocus(paramString1);
				return false;
			}
		}

		if ((!isInteger(str2.substring(0, str2.indexOf(".")))) || (!isInteger(str2.substring(str2.indexOf(".") + 1))))
		{
			showMessage(paramString1, "Invalid Value has entered. the format should be 10,2","error");
			setControlValue(paramString1, "");
			setFocus(paramString1);
			return false;
		}
		if ((paramString2.indexOf(".") < paramString2.length - 3) || (str2.length > 11))
		{
			showMessage(paramString1, "Invalid Value has entered. the format should be 10,2","error");
			setControlValue(paramString1, "");
			setFocus(paramString1);
			return false;
		}
		if (paramString2.indexOf(".") == paramString2.length - 3)
		{
			str1 = str2.substring(str2.length() - 3);
		}
		else if (paramString2.indexOf(".") == paramString2.length - 2)
		{
			str1 = str2.substring(str2.length() - 2);
		}

		str2 = str2.substring(0, str2.indexOf("."));

		if (str2.length > 3)
		{
			if (str2.length == 4)
			{
				str2 = str2.substring(0, 1) + "," + str2.substring(1) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 5)
			{
				str2 = str2.substring(0, 2) + "," + str2.substring(2) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 6)
			{
				str2 = str2.substring(0, 3) + "," + str2.substring(3) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 7)
			{
				str2 = str2.substring(0, 1) + "," + str2.substring(1, 4) + "," + str2.substring(4) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 8)
			{
				str2 = str2.substring(0, 2) + "," + str2.substring(2, 5) + "," + str2.substring(5) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length > 8)
			{
				str2 = "";
				showMessage(paramString1, "Invalid Value has entered. the format should be 10,2","error");
				setControlValue(paramString1, "");
				setFocus(paramString1);
				return false;
			}
		}
		else
		{
			setControlValue(paramString1, str2 + str1);
		}
	}
	else if (!paramString2 == "")
	{
		str2 = paramString2.replace(/,/gi, '');
		while ((str2 != null) && (str2.indexOf("0") == 0))
		{
			str2 = str2.substring(1);
			if ((str2 == null) || (str2 == "") || (str2 == ".00") || (str2 == ".0") || (str2 == "."))
			{
				showMessage(paramString1, "Invalid Amount has been entered","error");
				setControlValue(paramString1, "");
				setFocus(paramString1);
				return false;
			}
		}
		if (!isInteger(str2))
		{
			showMessage(paramString1, "Invalid Value has entered. the format should be 10,2","error");
			setControlValue(paramString1, "");
			setFocus(paramString1);
			return false;
		}

		if (str2.length > 3)
		{
			if (str2.length == 4)
			{
				str2 = str2.substring(0, 1) + "," + str2.substring(1) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 5)
			{
				str2 = str2.substring(0, 2) + "," + str2.substring(2) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 6)
			{
				str2 = str2.substring(0, 3) + "," + str2.substring(3) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 7)
			{
				str2 = str2.substring(0, 1) + "," + str2.substring(1, 4) + "," + str2.substring(4) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length == 8)
			{
				str2 = str2.substring(0, 2) + "," + str2.substring(2, 5) + "," + str2.substring(5) + str1;
				setControlValue(paramString1, str2);
			}
			else if (str2.length > 8)
			{
				str2 = "";
				showMessage(paramString1, "Invalid Value has entered. the format should be 10,2","error");
				setControlValue(paramString1, "");
				setFocus(paramString1);
				return false;
			}
		}
		else
		{
			setControlValue(paramString1, str2 + str1);
		}
	}
	return true;
}
function checkMonthDiff()
{
	if ((getValue("CCI_ExpD") == "") || (getValue("oth_ecr_RB") == ""))
	{
		return true;
	}
	var i = parseInt(getValue("CCI_ExpD").substring(0, 2));
	var j = parseInt(getValue("CCI_ExpD").substring(3, 5));

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

function containsOnlyNumbers(paramString)
{
	if ((paramString == null) || (paramString.length == 0)) 
	{
		return true;
	}
	for (var i = 0; i < paramString.length; i++)
	{
		if (!isDigit(paramString.charAt(i)))
			return false;
	}
	return true;
}
 
function isDigit(ch) 
{
	return parseInt(ch);
}