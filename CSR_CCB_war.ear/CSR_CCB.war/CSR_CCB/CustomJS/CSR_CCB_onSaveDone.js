var CSR_CCB_onLoad = document.createElement('script');
	CSR_CCB_onLoad.src = '/CSR_CCB/CSR_CCB/CustomJS/CSR_CCB_onLoad.js';
	document.head.appendChild(CSR_CCB_onLoad);
	
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
			if(getValue("CCI_CName") == "")
			{
				showMessage("CCI_CName", "Please enter card no and click refresh button to fetch card data!");
				setFocus("CCI_CrdtCN");
				return false;
			}
		}
		//alert("CCI_ExtNo : " + getValue("CCI_ExtNo"));
		if((getValue("CCI_ExtNo")=="") || (getValue("CCI_ExtNo") == null) || (getValue("CCI_ExtNo").length != 4)) 
	   {
		showMessage("CCI_ExtNo","Ext No. is mandatory and must be of 4 digits!","error");
		setFocus("CCI_ExtNo");
		return false;
	   }
	    if(getValue("CCI_CT") == "L")
		{
			showMessage("CCI_CT", "Current Card Type is not allowed for this request!","error");
			setFocus("CCI_CT");
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
			if (getValue("VD_PassNo_Check")==true) i++;
			if (getValue("VD_Oth_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_NOSC_Check")==true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if(getValue("VD_SD_Check")==true) i++;
			
			if (i < 4)
			{
				showMessage("VD_MoMaidN_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_MoMaidN_Check");
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
				setFocus("CB_DateTime");
				return false;
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
			if(getValue("CCI_CName") == "")
			{
				showMessage("CCI_CName", "Please enter card no and click refresh button to fetch card data!");
				setFocus("CCI_CrdtCN");
				return false;
			}
		}
		if((getValue("CCI_CrdtCN") == "") && (getValue("CCI_CrdtCN") == null))
		  {
		  setFocus("CCI_CrdtCN");
			return false;
		  }
		if(getValue("CCI_CT") == "L")
		{
			showMessage("CCI_CT", "Current Card Type is not allowed for this request!","error");
			setFocus("CCI_CT");
			return false;
		}
		if((getValue("CCI_ExtNo")=="") || (getValue("CCI_ExtNo") == null) || (getValue("CCI_ExtNo").length != 4)) 
	   {
		showMessage("CCI_ExtNo","Ext No. is mandatory and must be of 4 digits!","error");
		setFocus("CCI_ExtNo");
		return false;
	   }
		if((getValue("VD_MoMaidN_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if(getValue("VD_MoMaidN_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_PassNo_Check")==true) i++;
			if (getValue("VD_Oth_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_NOSC_Check")==true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if(getValue("VD_SD_Check")==true) i++;
			if (i < 4)
			{
				showMessage("VD_MoMaidN_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_MoMaidN_Check");
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
				setFocus("CB_DateTime");
				return false;
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
		if((getValue("CCI_ExtNo")=="") || (getValue("CCI_ExtNo") == null) || (getValue("CCI_ExtNo").length != 4)) 
	   {
		showMessage("CCI_ExtNo","Ext No. is mandatory and must be of 4 digits!","error");
		setFocus("CCI_ExtNo");
		return false;
	   }
		if(getValue("CCI_CT") == "L")
		{
			showMessage("CCI_CT", "Current Card Type is not allowed for this request!","error");
			setFocus("CCI_CT");
			return false;
		}
		if ((getValue("VD_MoMaidN_Check") == false) && (getValue("VD_TIN_Check") == false))
		{
			showMessage("VD_TIN_Check", "Atleast one of Verification Details is Mandatory!","error");
			setFocus("VD_TIN_Check");
			return false;
		}
		var i;
		if(getValue("VD_MoMaidN_Check") == true)
		{
			i = 0;
			if (getValue("VD_DOB_Check") == true) i++;
			if (getValue("VD_StaffId_Check") == true) i++;
			if (getValue("VD_POBox_Check") == true) i++;
			if (getValue("VD_PassNo_Check")==true) i++;
			if (getValue("VD_Oth_Check") == true) i++;
			if (getValue("VD_MRT_Check") == true) i++;
			if (getValue("VD_EDC_Check") == true) i++;
			if (getValue("VD_NOSC_Check")==true) i++;
			if (getValue("VD_TELNO_Check") == true) i++;
			if(getValue("VD_SD_Check")==true) i++;
			if (i < 4)
			{
				showMessage("VD_MoMaidN_Check", "Please select atleast 4 Random Questions!","error");
				setFocus("VD_MoMaidN_Check");
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
				setFocus("CB_DateTime");
				return false;
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
	


	
 