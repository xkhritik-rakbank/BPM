var DSR_MR_onLoad = document.createElement('script');
	DSR_MR_onLoad.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_onLoad.js';
	document.head.appendChild(DSR_MR_onLoad);
	
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
	


	
 