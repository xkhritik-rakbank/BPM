	var CSR_CCC_Common = document.createElement('script');
	CSR_CCC_Common.src = '/CSR_CCC/CSR_CCC/CustomJS/CSR_CCC_Common.js';
	document.head.appendChild(CSR_CCC_Common);
	
	var CSR_CCC_onLoad = document.createElement('script');
	CSR_CCC_onLoad.src = '/CSR_CCC/CSR_CCC/CustomJS/CSR_CCC_onLoad.js';
	document.head.appendChild(CSR_CCC_onLoad);

    function validateForSave() 
	{
		//alert("validateForSave : " + ActivityName);
		if ((ActivityName == "Work Introduction") || (ActivityName == "PENDING") || (ActivityName == "BRANCH_RETURN"))
		{
			//alert("CardNo : " + getValue("CardNo"));
			//if ((getValue("CCI_CrdtCN") != null) && (getValue("CCI_CrdtCN") != "") && (getValue("CCI_CrdtCN") != "    -    -    -    ") && (!validateCCNo(getValue("CCI_CrdtCN"), "CCI_CrdtCN")))
			//{
			//	setFocus("CCI_CrdtCN");
			//	return false;
			//} 
			/*if (!CheckValueForField("CCI_ExtNo", getValue("CCI_ExtNo"), "Ext. No.", "digits"))
				return false;*/
			
			if ((getValue("CCI_ExtNo") != "") && (getValue("CCI_ExtNo").length != 4))
			{
				showMessage("CCI_ExtNo", "Ext No. should be of 4 digits!","error");
				setFocus("CCI_ExtNo");
				return false;
			}	
		
			if ((getValue("CCI_SC") != "") && (getValue("CCI_SC").length != 6) && (getValue("CCI_SC").length != 7))
			{
				showMessage("CCI_SC", "Source Code should be of 6 or 7 Characters!","error");
				setFocus("CCI_SC");
				return false;
			}
			
			if ((getValue("CARD1") != null) && (getValue("CARD2") != null) && (getValue("CARD3") != null) && ((getValue("CARD1") != "") || (getValue("CARD2") != "") || (getValue("CARD3") != "")))	
			{
			   if ((getValue("CARD1")!= "") && (getValue("CARD1") == getValue("CARD2")))
			   {
				   showMessage('CARD2','RAKBANK Card No.s should be unique!',"error");
				   setFocus("CARD2");
				   return false;
			   }	
			   if ((getValue("CARD1")!= "") && (getValue("CARD1") == getValue("CARD3")))
			   {
				   showMessage('CARD3','RAKBANK Card No.s should be unique!',"error");
				   setFocus("CARD3");
				   return false;
			   }
			   if ((getValue("CARD3")!= "") && (getValue("CARD2") == getValue("CARD3")))
			   {
				   showMessage('CARD3','RAKBANK Card No.s should be unique!',"error");
				   setFocus("CARD3");
				   return false;
			   }
			}
			if(getValue("CARD1")!="")
			{
				//if(!validateAmount("CHQ_AMOUNT1", getValue("CHQ_AMOUNT1")))
				//{
				//	return false;
				//}
			   if ((getValue("ApprovalCode1") != "") && (getValue("ApprovalCode1").length != 6))	
			   {
				   showMessage('ApprovalCode1','Approval Code should be of 6 digits!',"error");
				   setFocus("ApprovalCode1");
				   return false;
			   }
			}
			if(getValue("CARD2")!="")
			{
				//if(!validateAmount("CHQ_AMOUNT2", getValue("CHQ_AMOUNT2")))
				//{
				//	return false;
				//}
			   if ((getValue("ApprovalCode2") != "") && (getValue("ApprovalCode2").length != 6))	
			   {
				   showMessage('ApprovalCode2','Approval Code should be of 6 digits!',"error");
				   setFocus("ApprovalCode2");
				   return false;
			   }
			}
			if(getValue("CARD3")!="")
			{
				//if(!validateAmount("CHQ_AMOUNT3", getValue("CHQ_AMOUNT3")))
				//{
				//	return false;
				//}
			   if ((getValue("ApprovalCode3") != "") && (getValue("ApprovalCode3").length != 6))	
			   {
				   showMessage('ApprovalCode3','Approval Code should be of 6 digits!',"error");
				   setFocus("ApprovalCode3");
				   return false;
			   }
			}
			if (getValue("REMARKS").length > 500)
			{
				showMessage("REMARKS", "Remarks/Reasons can't be greater than 500 Characters","error");
				setFocus("REMARKS");
				return false;
			}
		
		}
	    return true;
}

    function validateMandatory()
	{
		if ((ActivityName == "Work_Introduction") || (ActivityName == "Pending") || (ActivityName == "Branch_Return"))
		{
			if (ActivityName == "Work_Introduction")
			{
				if (getValue("CCI_CName") == "")
				{
					showMessage("CCI_CName", "Please enter card no and click refresh button to fetch card data!","error");
					setFocus("CCI_CrdtCN");
					return false;
				}
			}
			
			//if ((getValue("CCI_CrdtCN") != null) && (getValue("CCI_CrdtCN") != "") && (getValue("CCI_CrdtCN") != "    -    -    -    ") && (!validateCCNo(getValue("CCI_CrdtCN"), "CCI_CrdtCN")))
			//{
			//	setFocus("CCI_CrdtCN");
			//	return false;
			//}
			if(getValue('CCI_ExtNo')=="" || getValue('CCI_ExtNo')=='' || getValue('CCI_ExtNo')==null)
			{			
				showMessage('CCI_ExtNo','Ext.No is Mandatory!',"error");
				setFocus("CCI_ExtNo");
				return false;
			}
			/*if (!CheckValueForField("CCI_ExtNo", getValue("CCI_ExtNo"), "Ext. No.", "digits"))
			return false;*/
		    if ((getValue("CCI_ExtNo") != "") && (getValue("CCI_ExtNo").length != 4))
			{
				showMessage("CCI_ExtNo", "Ext No. should be of 4 digits!","error");
				setFocus("CCI_ExtNo");
				return false;
			}
			if(getValue('CCI_SC')=="" || getValue('CCI_SC')=='' || getValue('CCI_SC')==null)
			{			
				showMessage('CCI_SC','Source Code is Mandatory!',"error");
				setFocus("CCI_ExtNo");
				return false;
			}
			if ((getValue("CCI_SC") != "") && (getValue("CCI_SC").length != 6) && (getValue("CCI_SC").length != 7))
			{
				showMessage("CCI_SC", "Source Code should be of 6 or 7 Characters!","error");
				setFocus("CCI_SC");
				return false;
			}
			if ((getValue("VD_MoMaidN_Check") == false) && (getValue("VD_TIN_Check") == false))
			{
				showMessage("VD_TINCHECK", "Atleast one of Verification Details is Mandatory!","error");
				setFocus("VD_TINCHECK");
				return false;
			}
			var i;
			if (getValue("VD_MoMaidN_Check") == true)
			{
				i = 0;
				if(getValue("VD_DOB_Check")==true) i++;
				if(getValue("VD_Oth_Check")==true) i++;
				if(getValue("VD_StaffId_Check")==true) i++;
				if(getValue("VD_POBox_Check")==true) i++;
				if(getValue("VD_PassNo_Check")==true) i++;
				if(getValue("VD_MRT_Check")==true) i++;
				if(getValue("VD_EDC_Check")==true) i++;
				if(getValue("VD_NOSC_Check")==true) i++;
				if(getValue("VD_TELNO_Check")==true) i++;
				if(getValue("VD_SD_Check")==true) i++;
				if (i < 4)
				{
					showMessage("VD_MoMaidN_Check", "Please select atleast 4 Random Questions!","error");
					setFocus("VD_MoMaidN_Check");
					return false;
				}
			}
			if(getValue('BANEFICIARY_NAME')=="" || getValue('BANEFICIARY_NAME')=='' || getValue('BANEFICIARY_NAME')==null)
			{			
				showMessage('BANEFICIARY_NAME','Beneficiary Name is Mandatory!',"error");
				setFocus("BANEFICIARY_NAME");
				return false;
			}
            var x = getValue('DELIVERTO');
		
			if (x == null || x == "" || x=='--Select--')
			{
				showMessage('DELIVERTO','DELIVER TO is Mandatory!',"error");
				setFocus("DELIVERTO");
				return false;
			}
			if(getValue("DELIVERTO")=='Bank' && getValue("BRANCH")=="")			
			{
				showMessage('BRANCH','Branch Name is Mandatory!',"error");
				setFocus("BRANCH");
				return false;
				
			}
			if((getValue("CARD1")=="") && (getValue("CARD2")=="") && (getValue("CARD3")==""))
			{
				showMessage('CARD1','Any one of RAKBANK Card no.s is Mandatory!',"error");
				setFocus("CARD1");
				return false;
			}
			if ((getValue("CARD1")!= "") && (getValue("CARD1") == getValue("CARD2")))
		   {
			   showMessage('CARD2','RAKBANK Card No.s should be unique!',"error");
			   setFocus("CARD2");
			   return false;
		   }	
		   if ((getValue("CARD1")!= "") && (getValue("CARD1") == getValue("CARD3")))
		   {
			   showMessage('CARD3','RAKBANK Card No.s should be unique!',"error");
			   setFocus("CARD3");
			   return false;
		   }
		   if ((getValue("CARD2")!= "") && (getValue("CARD2") == getValue("CARD3")))
		   {
			   showMessage('CARD3','RAKBANK Card No.s should be unique!',"error");
			   setFocus("CARD3");
			   return false;
		   }
		   if(getValue("CARD1")!="")
		   {
			 if(getValue('CHQ_AMOUNT1')=="" || getValue('CHQ_AMOUNT1')=='' || getValue('CHQ_AMOUNT1')==null)
				{			
					showMessage('CHQ_AMOUNT1','Cheque Amount AED is Mandatory!',"error");
					setFocus("CHQ_AMOUNT1");
					return false;
				}  
			if(getValue('ApprovalCode1')=="" || getValue('ApprovalCode1')=='' || getValue('ApprovalCode1')==null)
				{			
					showMessage('ApprovalCode1','Approval Code is Mandatory!',"error");
					setFocus("ApprovalCode1");
					return false;
				}
			if(getValue('ApprovalCode1').length!=6)
				{
					showMessage('ApprovalCode1','Approval Code should be of 6 digits!',"error");
					setFocus("ApprovalCode1");
					return false;
				}
            	
		   }//
            if(getValue("CARD2")!="")
		   {
			 if(getValue('CHQ_AMOUNT2')=="" || getValue('CHQ_AMOUNT2')=='' || getValue('CHQ_AMOUNT2')==null)
				{			
					showMessage('CHQ_AMOUNT2','Cheque Amount AED is Mandatory!',"error");
					setFocus("CHQ_AMOUNT2");
					return false;
				}  
			if(getValue('ApprovalCode2')=="" || getValue('ApprovalCode2')=='' || getValue('ApprovalCode2')==null)
				{			
					showMessage('ApprovalCode1','Approval Code is Mandatory!',"error");
					setFocus("ApprovalCode2");
					return false;
				}
			if(getValue('ApprovalCode2').length!=6)
				{
					showMessage('ApprovalCode2','Approval Code should be of 6 digits!',"error");
					setFocus("ApprovalCode2");
					return false;
				}
            	
		   }
            if(getValue("CARD3")!="")
		   {
			 if(getValue('CHQ_AMOUNT3')=="" || getValue('CHQ_AMOUNT3')=='' || getValue('CHQ_AMOUNT3')==null)
				{			
					showMessage('CHQ_AMOUNT3','Cheque Amount AED is Mandatory!',"error");
					setFocus("CHQ_AMOUNT3");
					return false;
				}  
			if(getValue('ApprovalCode3')=="" || getValue('ApprovalCode3')=='' || getValue('ApprovalCode3')==null)
				{			
					showMessage('ApprovalCode3','Approval Code is Mandatory!',"error");
					setFocus("ApprovalCode3");
					return false;
				}
			if(getValue('ApprovalCode3').length!=6)
				{
					showMessage('ApprovalCode3','Approval Code should be of 6 digits!',"error");
					setFocus("ApprovalCode3");
					return false;
				}
            	
		   }
			if (getValue("REMARKS").length > 500)
				{
					showMessage("REMARKS", "Remarks/Reasons can't be greater than 500 Characters","error");
					setFocus("REMARKS");
					return false;
				}
			if(ActivityName == "Pending")
			{
				if (getValue("Pending_Decision") == "")
				{
					showMessage("Pending_Decision", "Pending Decision is Mandatory!","error");
					setFocus("Pending_Decision");
					return false;
				}
			}				
		   
		} //
		else if (ActivityName == "Branch_Approver")
		{
		    if (getValue("BA_Decision") == "")
			{
				showMessage("BA_Decision", "Branch Approver Decision is Mandatory!","error");
				setFocus("BA_Decision");
				return false;
			}
			if(getValue("BA_Decision")=="BA_BR")
			{
			   if(getValue("BA_Remarks")=="")
			   {
				   showMessage('BA_Remarks','Please provide remarks!',"error");
				   setFocus("BA_Remarks");
				   return false;
			   }
			}
			if (getValue("BA_Remarks").length > 500)
			{
				showMessage("BA_Remarks", "Remarks/Reasons can't be greater than 500 Characters","error");
				setFocus("BA_Remarks");
				return false;
			} 			
		}
		if(ActivityName=="CARDS")
		{
			if (getValue("Cards_Decision") == "")
			{
				showMessage("Cards_Decision", "Decision is Mandatory!","error");
				setFocus("Cards_Decision");
				return false;
			}
			if (getValue("Cards_Decision") == "CARDS_BR")
			{
				if (getValue("Cards_Remarks") == "" || getValue("Cards_Remarks")==null)
				{
					showMessage("Cards_Remarks", "Please provide remarks!","error");
					setFocus("Cards_Remarks");
					return false;
		
				}	
		    }
			if (getValue("Cards_Remarks").length > 500)
			{
				showMessage("Cards_Remarks", "Remarks/Reasons can't be greater than 500 Characters","error");
				setFocus("Cards_Remarks");
				return false;
			} 
		}
		return true;
	}
	
	
	function validateMandatoryForPending() 
	{
		//alert("inside validateMandatoryForPending");
		//alert("CardNo_Text :"+getValue("CCI_CrdtCN"));
		//if ((getValue("CCI_CrdtCN") != null) && (getValue("CCI_CrdtCN") != "") && (getValue("CCI_CrdtCN") != "    -    -    -    ") && (!validateCCNo(getValue("CCI_CrdtCN"), "CCI_CrdtCN")))
		//{
		//	setFocus("CCI_CrdtCN");
		//	return false;
		//}
			
		if (getValue("Remarks") == "" || getValue("Remarks")==null)
		{
			showMessage("Remarks", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("Remarks");
			return false;
		}
		return true;
	}	
	
	
	function validateCCNo(paramString1,paramString2) 
	{
		alert("paramString1 :"+paramString1+" paramString2 :"+paramString2);
		if ((paramString1 != "") && ((paramString1.length != 19) || (!isInteger(paramString1.substring(0, 4))) || (!isInteger(paramString1.substring(5, 9))) || (!isInteger(paramString1.substring(10, 14))) || (!isInteger(paramString1.substring(15, 19)))))
		{
			showMessage("CardNo", "Invalid Credit Card No. Format","error");
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

		showMessage("CardNo", "Invalid Credit Card No. Format","error");
		return false;
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
		
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	