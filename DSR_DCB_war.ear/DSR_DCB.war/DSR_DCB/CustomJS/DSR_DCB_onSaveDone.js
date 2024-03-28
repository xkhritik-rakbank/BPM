var DSR_DCB_onLoad = document.createElement('script');
	DSR_DCB_onLoad.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_onLoad.js';
	document.head.appendChild(DSR_DCB_onLoad);
	
function setCustomControlsValue(Flag,ActivityName)
{
	if(Flag == 'S')
	{
		if (!validateForSave(ActivityName))
			return false;
	}
	else if(Flag == 'D')
	{
		if (ActivityName == 'Work Introduction')
		{
		   if (getValue("initiateDecision")== 'Pending')
           {
            if (!validateMandatoryForPending()) 
			{
              return false;
            }

           }
          else if (!validateMandatory(ActivityName)) {
           return false;
          }
        
		}
		else if (ActivityName == 'Pending')
		{
			if (!validateMandatory(ActivityName))
			{
				return false;
			}
			/*if (getValue("Pending_Decision")== 'Approve')
			{
				setValue("Pending_Decision","P_Approve");
			}
			else if (getValue("Pending_Decision")== 'Discard')
			{
				setValue("Pending_Decision","P_Discard");
			}
			else
			{
				setValue("Pending_Decision","P_Discard");
			}  */
		}
		else if (ActivityName == 'Branch_Return')
		{
			if (!validateMandatory(ActivityName))
			{
				return false;
			}
		}
		else if (ActivityName == 'Branch_Approver')
		{
			if (!validateMandatory(ActivityName))
			{
				return false;
			}
		}
		else if (ActivityName == 'CARDS')
		{
			if (!validateMandatory(ActivityName))
			{
				return false;
			}
		}
		
	}  
}



function validateForSave(ActivityName)
{

   if(ActivityName == 'Work Introduction' || ActivityName == 'Pending' || ActivityName == 'Branch_Return')
	{
		if(ActivityName=="Work Introduction")
		{
			if(getValue("DCI_CName") == "")
			{
				showMessage("DCI_CName", "Please enter card no and click refresh button to fetch card data!");
				setFocus("DCI_DebitCN");
				return false;
			}
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
		if ((getValue("VD_Oth_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if (getValue("VD_Oth_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_MoMaidN_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if (i < 4)
			{
				showMessage("VD_Oth_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_Oth_Check");
				return false;
			}
		}
		if ((getValue("REASON_HOTLIST")=="") || (getValue("REASON_HOTLIST")=="--select--"))
		{
			showMessage("REASON_HOTLIST","Reason for Hotlisting is Mandatory!","error");
			setFocus("REASON_HOTLIST");
			return false;
		}
		if ((getValue("REASON_HOTLIST") =="Lost") || (getValue("REASON_HOTLIST") =="Stolen") || (getValue("REASON_HOTLIST") =="Captured") || (getValue("REASON_HOTLIST") == "Blocked"))
		{
			if((getValue("CB_DateTime")==""))
			{
				showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
				/*var str1 = getValue("CB_DateTime");
				if (str1.length() < 16)
				{
					showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
					setValue("CB_DateTime","");
					setFocus("CB_DateTime");
					return false;
				}
				if ((str1.charAt(2) != '/') || (str1.charAt(5) != '/') || (str1.charAt(10) != ' ') || (str1.charAt(13) != ':'))
				{
					showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
					setValue("CB_DateTime","");
					setFocus("CB_DateTime");
					return false;
				}
				var str2 = str1.substring(0, str1.indexOf(" "));
				if (!validateDate(str2, "Date & Time Of L/S/C"))
				{
					setValue("CB_DateTime","");
					return false;
				}
				var str3 = str1.substring(str1.indexOf(" ") + 1);
				if (!validateTime(str3, "Date & Time Of L/S/C"))
				{
					setValue("CB_DateTime", "");
					return false;
				}
				if (!validateFutureDateTime(str1, "CB_DateTime"))
				{
					setValue("CB_DateTime", "");
					return false;
				}*/
			}
			if(getValue("PLACE") == "")
			{
				showMessage("PLACE", "Place is Mandatory!","error");
				setFocus("PLACE");
				return false;
			}
		}
		if ((getValue("REASON_HOTLIST") =="Magnetic Strip is damaged") || (getValue("REASON_HOTLIST") =="Misuse"))
		{
			if (getValue("REASON_HOTLIST") =="Email From")
			{
				if(getValue("EMAIL_FROM") == "")
				{
					showMessage("EMAIL_FROM", "Email From is Mandatory!","error");
					setFocus("EMAIL_FROM");
					return false;
				}
			}
		}
		if (getValue("REASON_HOTLIST") =="Wrong Embossing Name")
		{
			if(getValue("EMBOSING_NAME") == "")
			{
				showMessage("EMBOSING_NAME", "Embossing Name is Mandatory!","error");
				setFocus("EMBOSING_NAME");
				return false;
			}
		}
		if (getValue("REASON_HOTLIST") =="Others")
		{
			if(getValue("HOST_OTHER") == "")
			{
				showMessage("HOST_OTHER", "Others is Mandatory!","error");
				setFocus("HOST_OTHER");
				return false;
			}
		}
		if(getValue("AVAILABLE_BALANCE") == "")
		{
			showMessage("AVAILABLE_BALANCE", "Available Balance is Mandatory!","error");
			setFocus("AVAILABLE_BALANCE");
			return false;
		}
		if(getValue("C_STATUS_B_BLOCK")=="" || getValue("C_STATUS_B_BLOCK")==getValue("C_STATUS_A_BLOCK"))
		{
			showMessage('C_STATUS_B_BLOCK',"Card status before block and Card status after block cannot be same!","error");
			setFocus("C_STATUS_B_BLOCK");
			return false;
		}
		if(getValue("C_STATUS_A_BLOCK")=="" || getValue("C_STATUS_A_BLOCK")=="00")
		{
			showMessage('C_STATUS_A_BLOCK',"Card status After Block cannot be 00!","error");
			setFocus("C_STATUS_A_BLOCK");
			return false;
		}
		if ((getValue("ACTION_TAKEN") == "" ) || (getValue("ACTION_TAKEN") =="--select--"))
		{
			showMessage("ACTION_TAKEN", "Action Taken is mandatory!","error");
			setFocus("ACTION_TAKEN");
			return false;
		}
		if (getValue("ACTION_TAKEN") =="Others")
		{
			if (getValue("ACTION_OTHER") == "")
			{
				showMessage("ACTION_OTHER", "Others is Mandatory!","error");
				setFocus("ACTION_OTHER");
				return false;
			}
		}
		if ((getValue("ACTION_TAKEN") =="Issue Replacement"))
		{
			if ((getValue("DELIVER_TO") == "" ) || (getValue("DELIVER_TO") =="--select--"))
			{
				
				showMessage("DELIVER_TO", "Deliver To is mandatory!","error");
				setFocus("DELIVER_TO");
				return false;
			}
			if ((getValue("DELIVER_TO") =="Branch"))
			{
				if(getValue("BRANCH_NAME") == "")
				{
					showMessage("BRANCH_NAME", "Branch Name is Mandatory!","error");
					setFocus("BRANCH_NAME");
					return false;
				}
			}
		}
		if(getValue("REMARKS")=="")
		  {
			showMessage('REMARKS','Remarks/Reasons is Mandatory!',"error");
			setFocus("REMARKS");
			return false;
		  }
		if (getValue("REMARKS").length > 500)
		{
			showMessage("REMARKS", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("REMARKS");
			return false;
		}
		if(ActivityName=="Pending")
			{
			 if(getValue("Pending_Decision")=="" || getValue("Pending_Decision")=="Select")
			  {
			   showMessage('Pending_Decision','Pending Decision is Mandatory!',"error");
			   setFocus("Pending_Decision");
			   return false;
			  }
			  
			}
	} 
	//alert("........");
    return true;
}

function validateMandatory(ActivityName)
{
	if((ActivityName== 'Work Introduction') || (ActivityName == 'Pending') || (ActivityName == 'Branch_Return'))
	{
		if(ActivityName=="Work Introduction")
		{
			if(getValue("DCI_CName") == "")
			{
				showMessage("DCI_CName", "Please enter card no and click refresh button to fetch card data!");
				setFocus("DCI_DebitCN");
				return false;
			}
		}
		if((getValue("DCI_DebitCN") == "") && (getValue("DCI_DebitCN") == null))
		  {
		  setFocus("DCI_DebitCN");
			return false;
		  }
		if(getValue("DCI_CT") == "L")
		{
			showMessage("DCI_CT", "Current Card Type is not allowed for this request!","error");
			setFocus("DCI_CT");
			return false;
		}
		if((getValue("DCI_ExtNo")=="") || (getValue("DCI_ExtNo") == null) || (getValue("DCI_ExtNo").length != 4)) 
	   {
		showMessage("DCI_ExtNo","Ext No. is mandatory and must be of 4 digits!","error");
		setFocus("DCI_ExtNo");
		return false;
	   }
		if((getValue("VD_Oth_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if(getValue("VD_Oth_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_MoMaidN_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if (i < 4)
			{
				showMessage("VD_Oth_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_Oth_Check");
				return false;
			}
		}
		if(getValue("REMARKS")=="") 
		  {
			showMessage('REMARKS','Remarks/Reasons is Mandatory!',"error");
			setFocus("REMARKS");
			return false;
		  }
		 if(getValue("REMARKS").length>500)
		 {
			alert("Remarks/Reasons can't be greater than 500 Characters");
			setFocus("REMARKS");
			return false;
		   } 
		   if ((getValue("REASON_HOTLIST")=="") || (getValue("REASON_HOTLIST")=="--select--"))
		{
			showMessage("REASON_HOTLIST","Reason for Hotlisting is Mandatory!","error");
			setFocus("REASON_HOTLIST");
			return false;
		}
		if ((getValue("REASON_HOTLIST") =="Lost") || (getValue("REASON_HOTLIST") =="Stolen") || (getValue("REASON_HOTLIST") =="Captured") || (getValue("REASON_HOTLIST") == "Blocked"))
		{
			if((getValue("CB_DateTime")==""))
			{
				showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
				/*var str1 = getValue("CB_DateTime");
				if (str1.length() < 16)
				{
					showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
					setValue("CB_DateTime","");
					setFocus("CB_DateTime");
					return false;
				}
				if ((str1.charAt(2) != '/') || (str1.charAt(5) != '/') || (str1.charAt(10) != ' ') || (str1.charAt(13) != ':'))
				{
					showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
					setValue("CB_DateTime","");
					setFocus("CB_DateTime");
					return false;
				}
				var str2 = str1.substring(0, str1.indexOf(" "));
				if (!validateDate(str2, "Date & Time Of L/S/C"))
				{
					setValue("CB_DateTime","");
					return false;
				}
				var str3 = str1.substring(str1.indexOf(" ") + 1);
				if (!validateTime(str3, "Date & Time Of L/S/C"))
				{
					setValue("CB_DateTime", "");
					return false;
				}
				if (!validateFutureDateTime(str1, "CB_DateTime"))
				{
					setValue("CB_DateTime", "");
					return false;
				}*/
			}
			if(getValue("PLACE") == "")
			{
				showMessage("PLACE", "Place is Mandatory!","error");
				setFocus("PLACE");
				return false;
			}
		}
		if ((getValue("REASON_HOTLIST") =="Magnetic Strip is damaged") || (getValue("REASON_HOTLIST") =="Misuse"))
		{
			if (getValue("REASON_HOTLIST") =="Email From")
			{
				if(getValue("EMAIL_FROM") == "")
				{
					showMessage("EMAIL_FROM", "Email From is Mandatory!","error");
					setFocus("EMAIL_FROM");
					return false;
				}
			}
		}
		if (getValue("REASON_HOTLIST") =="Wrong Embossing Name")
		{
			if(getValue("EMBOSING_NAME") == "")
			{
				showMessage("EMBOSING_NAME", "Embossing Name is Mandatory!","error");
				setFocus("EMBOSING_NAME");
				return false;
			}
		}
		if (getValue("REASON_HOTLIST") =="Others")
		{
			if(getValue("HOST_OTHER") == "")
			{
				showMessage("HOST_OTHER", "Others is Mandatory!","error");
				setFocus("HOST_OTHER");
				return false;
			}
		}
		if(getValue("AVAILABLE_BALANCE") == "")
		{
			showMessage("AVAILABLE_BALANCE", "Available Balance is Mandatory!","error");
			setFocus("AVAILABLE_BALANCE");
			return false;
		}
		if(getValue("C_STATUS_B_BLOCK")=="" || getValue("C_STATUS_B_BLOCK")==getValue("C_STATUS_A_BLOCK"))
		{
			showMessage('C_STATUS_B_BLOCK',"Card status before block and Card status after block cannot be same!","error");
			setFocus("C_STATUS_B_BLOCK");
			return false;
		}
		if(getValue("C_STATUS_A_BLOCK")=="" || getValue("C_STATUS_A_BLOCK")=="00")
		{
			showMessage('C_STATUS_A_BLOCK',"Card status After Block cannot be 00!","error");
			setFocus("C_STATUS_A_BLOCK");
			return false;
		}
		if ((getValue("ACTION_TAKEN") == "" ) || (getValue("ACTION_TAKEN") =="--select--"))
		{
			showMessage("ACTION_TAKEN", "Action Taken is mandatory!","error");
			setFocus("ACTION_TAKEN");
			return false;
		}
		if (getValue("ACTION_TAKEN") =="Others")
		{
			if (getValue("ACTION_OTHER") == "")
			{
				showMessage("ACTION_OTHER", "Others is Mandatory!","error");
				setFocus("ACTION_OTHER");
				return false;
			}
		}
		if ((getValue("ACTION_TAKEN") =="Issue Replacement"))
		{
			if ((getValue("DELIVER_TO") == "" ) || (getValue("DELIVER_TO") =="--select--"))
			{
				
				showMessage("DELIVER_TO", "Deliver To is mandatory!","error");
				setFocus("DELIVER_TO");
				return false;
			}
			if ((getValue("DELIVER_TO") =="Branch"))
			{
				if(getValue("BRANCH_NAME") == "")
				{
					showMessage("BRANCH_NAME", "Branch Name is Mandatory!","error");
					setFocus("BRANCH_NAME");
					return false;
				}
			}
		}
		if(getValue("REMARKS")=="") 
		{
			showMessage('REMARKS','Remarks/Reasons is Mandatory!',"error");
			setFocus("REMARKS");
			return false;
		}
		if(getValue("REMARKS").length > 500)
		{
			showMessage("REMARKS", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("REMARKS");
			return false;
		}
		 if(ActivityName=="Pending")
			{
			 if(getValue("Pending_Decision")=="" || getValue("Pending_Decision")=="Select")
			  {
			   showMessage('Pending_Decision','Pending Decision is Mandatory!',"error");
			   setFocus("Pending_Decision");
			   return false;
			  }
			  
			}		
		}
		if(ActivityName=="CARDS")
		{
		 if(getValue("Cards_Decision")=="" || getValue("Cards_Decision")=="Select")
		  {
		   showMessage('Cards_Decision','CARDS Decision is Mandatory!',"error");
		   setFocus("Cards_Decision");
		   return false;
		  }
		 if(getValue("Cards_Decision")=="Re-Submit to Branch")
		  {
		   if(getValue("Cards_Remarks")=="")
		   {
			   showMessage('Cards_Remarks','Remarks/Reasons is Mandatory!',"error");
			   setFocus("Cards_Remarks");
			   return false;
		   }
		  } 
		}
		if(ActivityName=="Branch_Approver")
		{
			if(getValue("BA_Decision")=="" || getValue("BA_Decision")=="Select")
			{
				showMessage("BA_Decision","Branch Approver Decision is Mandatory!","error");
				setFocus("BA_Decision");
				return false;
			}
			if(getValue("BA_Decision")=="Re-Submit to Branch" || getValue("BA_Decision")=="Approve" || getValue("BA_Decision")=="Discard")
			{
				if(getValue("BA_Remarks")=="")
				{
				   showMessage("BA_Remarks","Remarks/Reasons is Mandatory!","error");
				   setFocus("BA_Remarks");
				   return false;
				}
			} 
		}
	return true;		 
}

function validateMandatoryForPending()
	{
		
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
		if ((getValue("VD_Oth_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if(getValue("VD_Oth_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_MoMaidN_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if (i < 4)
			{
				showMessage("VD_Oth_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_Oth_Check");
				return false;
			}
		}
		if ((getValue("REASON_HOTLIST")=="") || (getValue("REASON_HOTLIST")=="--select--"))
		{
			showMessage("REASON_HOTLIST","Reason for Hotlisting is Mandatory!","error");
			setFocus("REASON_HOTLIST");
			return false;
		}
		if ((getValue("REASON_HOTLIST") =="Lost") || (getValue("REASON_HOTLIST") =="Stolen") || (getValue("REASON_HOTLIST") =="Captured") || (getValue("REASON_HOTLIST") == "Blocked"))
		{
			if((getValue("CB_DateTime")==""))
			{
				showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
				/*var str1 = getValue("CB_DateTime");
				if (str1.length() < 16)
				{
					showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
					setValue("CB_DateTime","");
					setFocus("CB_DateTime");
					return false;
				}
				if ((str1.charAt(2) != '/') || (str1.charAt(5) != '/') || (str1.charAt(10) != ' ') || (str1.charAt(13) != ':'))
				{
					showMessage("CB_DateTime","The Date format should be dd/mm/yyyy HH:MM In Date & Time Of L/S/C!","error");
					setValue("CB_DateTime","");
					setFocus("CB_DateTime");
					return false;
				}
				var str2 = str1.substring(0, str1.indexOf(" "));
				if (!validateDate(str2, "Date & Time Of L/S/C"))
				{
					setValue("CB_DateTime","");
					return false;
				}
				var str3 = str1.substring(str1.indexOf(" ") + 1);
				if (!validateTime(str3, "Date & Time Of L/S/C"))
				{
					setValue("CB_DateTime", "");
					return false;
				}
				if (!validateFutureDateTime(str1, "CB_DateTime"))
				{
					setValue("CB_DateTime", "");
					return false;
				}*/
			}
			if(getValue("PLACE") == "")
			{
				showMessage("PLACE", "Place is Mandatory!","error");
				setFocus("PLACE");
				return false;
			}
		}
		if ((getValue("REASON_HOTLIST") =="Magnetic Strip is damaged") || (getValue("REASON_HOTLIST") =="Misuse"))
		{
			if (getValue("REASON_HOTLIST") =="Email From")
			{
				if(getValue("EMAIL_FROM") == "")
				{
					showMessage("EMAIL_FROM", "Email From is Mandatory!","error");
					setFocus("EMAIL_FROM");
					return false;
				}
			}
		}
		if (getValue("REASON_HOTLIST") =="Wrong Embossing Name")
		{
			if(getValue("EMBOSING_NAME") == "")
			{
				showMessage("EMBOSING_NAME", "Embossing Name is Mandatory!","error");
				setFocus("EMBOSING_NAME");
				return false;
			}
		}
		if (getValue("REASON_HOTLIST") =="Others")
		{
			if(getValue("HOST_OTHER") == "")
			{
				showMessage("HOST_OTHER", "Others is Mandatory!","error");
				setFocus("HOST_OTHER");
				return false;
			}
		}
		if(getValue("AVAILABLE_BALANCE") == "")
		{
			showMessage("AVAILABLE_BALANCE", "Available Balance is Mandatory!","error");
			setFocus("AVAILABLE_BALANCE");
			return false;
		}
		if(getValue("C_STATUS_B_BLOCK")=="" || getValue("C_STATUS_B_BLOCK")==getValue("C_STATUS_A_BLOCK"))
		{
			showMessage('C_STATUS_B_BLOCK',"Card status before block and Card status after block cannot be same!","error");
			setFocus("C_STATUS_B_BLOCK");
			return false;
		}
		if(getValue("C_STATUS_A_BLOCK")=="" || getValue("C_STATUS_A_BLOCK")=="00")
		{
			showMessage('C_STATUS_A_BLOCK',"Card status After Block cannot be 00!","error");
			setFocus("C_STATUS_A_BLOCK");
			return false;
		}
		if ((getValue("ACTION_TAKEN") == "" ) || (getValue("ACTION_TAKEN") =="--select--"))
		{
			showMessage("ACTION_TAKEN", "Action Taken is mandatory!","error");
			setFocus("ACTION_TAKEN");
			return false;
		}
		if (getValue("ACTION_TAKEN") =="Others")
		{
			if (getValue("ACTION_OTHER") == "")
			{
				showMessage("ACTION_OTHER", "Others is Mandatory!","error");
				setFocus("ACTION_OTHER");
				return false;
			}
		}
		if ((getValue("ACTION_TAKEN") =="Issue Replacement"))
		{
			if ((getValue("DELIVER_TO") == "" ) || (getValue("DELIVER_TO") =="--select--"))
			{
				
				showMessage("DELIVER_TO", "Deliver To is mandatory!","error");
				setFocus("DELIVER_TO");
				return false;
			}
			if ((getValue("DELIVER_TO") =="Branch"))
			{
				if(getValue("BRANCH_NAME") == "")
				{
					showMessage("BRANCH_NAME", "Branch Name is Mandatory!","error");
					setFocus("BRANCH_NAME");
					return false;
				}
			}
		}
		if(getValue("REMARKS")=="") 
		  {
			showMessage('REMARKS','Remarks/Reasons is Mandatory!',"error");
			setFocus("REMARKS");
			return false;
		  }
		if(getValue("REMARKS").length > 500)
		{
			showMessage("REMARKS", "Remarks/Reasons can't be greater than 500 Characters","error");
			setFocus("REMARKS");
			return false;
		}
		if(getValue("Pending_Decision")=="" || getValue("Pending_Decision")=="Select")
		{
			showMessage('Pending_Decision','Pending Decision is Mandatory!',"error");
			setFocus("Pending_Decision");
			return false;
		}
		return true;
	}
	


	
 