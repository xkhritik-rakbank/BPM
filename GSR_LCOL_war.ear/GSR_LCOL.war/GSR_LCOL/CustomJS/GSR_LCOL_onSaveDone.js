
function setCustomControlsValue()
{
  
	if ((ActivityName == "Work Introduction") || (ActivityName == "Branch_Return"))
    {
		//alert("CardNo_Text : " + getValue("CardNo_Text"));
		if (getValue("AGREEMENTNO") == "")
		{
		    showMessage("AGREEMENTNO","Please fill agreement no. and click ok button to fetch loan details","error");
			setFocus("AGREEMENTNO");
			return false;
		} 	
	
		if(getValue("AGREEMENTNO").length != 8)
	    {
			showMessage("AGREEMENTNO","Agreement No. should be of length 8 digits","error");
			setFocus("AGREEMENTNO");
			return false;
	    }
		if((getValue("CERTIFICATETYPE") == "") || (getValue("CERTIFICATETYPE")== "select"))
		{
			showMessage("CERTIFICATETYPE", "CERTIFICATE TYPE is mandatory field.","error");
			setFocus("CERTIFICATETYPE");
			return false;
		}
		
		if(getValue("ADDRESSEDTONAME") == "")
		{
			showMessage("ADDRESSEDTONAME", "ADDRESSED TO NAME is mandatory field","error");
			setFocus("ADDRESSEDTONAME");
			return false;
		}
		if((getValue("LANGUAGE") == "")|| (getValue("LANGUAGE")== "select"))
		{
			showMessage("LANGUAGE", "LANGUAGE is mandatory field","error");
			setFocus("LANGUAGE");
			return false;
		}
		if((getValue("CHARGESTOBERECFROM") == "")|| (getValue("CHARGESTOBERECFROM")== "select"))
		{
			showMessage("CHARGESTOBERECFROM", "Charges to be recovered from is mandatory field","error");
			setFocus("CHARGESTOBERECFROM");
			return false;
		}
		//if (!validateAmount("CHAMOUNT", getValue("CHAMOUNT"))) 
		//{
		//	return false;
		//}
		if(getValue("CHAMOUNT") == "")
		{
			showMessage("CHAMOUNT", "Charge Amount is mandatory field","error");
			setFocus("CHAMOUNT");
			return false;
		}
		if((getValue("CUSTOMERTYPE") == "")|| (getValue("CUSTOMERTYPE")== "select"))
		{
			showMessage("CUSTOMERTYPE", "Customer Type is mandatory field","error");
			setFocus("CUSTOMERTYPE");
			return false;
		}
	
		if(getValue("CHARGESTOBERECFROM") == "A/C Debit")
		{
		    if(getValue("DEBITACCOUNT") == "")
			{
				showMessage("DEBITACCOUNT", "Debit Account is mandatory field","error");
				setFocus("DEBITACCOUNT");
				return false;
			}	
		}
		
	    if ((getValue("LANDLINENO") == ""))
		{
			showMessage("LANDLINENO", "Land Line No. is mandatory field","error");
			setFocus("LANDLINENO");
			return false;
		}
		if (getValue("MOBILENO") == "")
		{
			showMessage("MOBILENO", "Mobile Number is Mandatory!","error");
			setFocus("MOBILENO");
			return false;
			
		}	
		if(getValue("CERTIFICATETYPE") == "No Liability Certificate")
		{
		    if(getValue("CHARGESTOBERECFROM") == "Accrue Charges")
			{
				showMessage("CHARGESTOBERECFROM", "Accrue Charges is not a valid payment mode for this request type","error");
				setFocus("CHARGESTOBERECFROM");
				return false;
			}	
		}
		if ((getValue("RETENTIONOFPRODUCT") == ""))
		{
			showMessage("RETENTIONOFPRODUCT", "RETENTION OF PRODUCT is mandatory field","error");
			setFocus("RETENTIONOFPRODUCT");
			return false;
		}
		if (getValue("TOBEDELIVEREDTO") == "")
		{
			showMessage("TOBEDELIVEREDTO", "TO BE DELIVERED TO is mandatory field","error");
			setFocus("TOBEDELIVEREDTO");
			return false;
			
		}
	}
	else if(ActivityName=="Branch_Approver")
	{	
		if (getValue("BADecision") == "")
		{
			showMessage("BADecision", "Please select the decision","error");
			setFocus("BADecision");
			return false;
		}
		if (getValue("BADecision") == "Discard")
		{
		    setStyle("BAREASONFOPDECLINE","disable","true");
			if (getValue("BAREASONFOPDECLINE") == "")
			{
				showMessage("BAREASONFOPDECLINE", "Please select the Reason","error");
				setFocus("BAREASONFOPDECLINE");
				return false;
			}
		}
		
	}
	
	if(ActivityName=="CROPS")
		{
			if(getValue("ACTION")=="" || getValue("ACTION")=="Select")
			{
				showMessage('ACTION','Please select the decision',"error");
				setFocus("ACTION");
				return false;
			}
			if(getValue("ACTION")=="Resubmit to Branch")
			{
				if(getValue("EC1")=="")
				{
					showMessage('EC1','First Error Code is mandatory for Selected Action.',"error");
					setFocus("EC1");
					return false;
				}
			} 
		}
	

return true;
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