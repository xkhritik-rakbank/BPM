var CSR_CCC_onLoad = document.createElement('script');
CSR_CCC_onLoad.src = '/CSR_CCC/CSR_CCC/CustomJS/CSR_CCC_onLoad.js';
document.head.appendChild(CSR_CCC_onLoad);
	
var CSR_CCC_mandatory = document.createElement('script');
CSR_CCC_mandatory.src = '/CSR_CCC/CSR_CCC/CustomJS/CSR_CCC_MandatoryFieldValidations.js';
document.head.appendChild(CSR_CCC_mandatory);

var CSR_CCC_Common = document.createElement('script');
CSR_CCC_Common.src = '/CSR_CCC/CSR_CCC/CustomJS/CSR_CCC_Common.js';
document.head.appendChild(CSR_CCC_Common);
	
function setCustomControlsValue(Flag,activityname) // ccc
{
    if(Flag == 'S')
	{
	  
		if (ActivityName == "Pending")
		{
			//None
		}
		if (ActivityName == "Branch_Approver")
		{
			//None
		}
		if (ActivityName == "CARDS")
		{
			//None
		}
		if (!validateForSave())
		{
			return false;
		}			
	}
	if(Flag == 'D')
	{
        if (ActivityName == "Work_Introduction")
		{
			if (getValue("initiateDecision") == "Pending")
			{
				if (!validateMandatoryForPending())
				{
					return false;
				}
			}
			else if (!validateMandatory())
			{
				return false;
			}
		}
		if	(ActivityName == "Branch_Return")
		{
			if (!validateMandatory())
			{
				return false;
			}
			
		}
        if (ActivityName == "Pending")
		{
			if (!validateMandatory())
			{
				return false;
			}

			/*if (getValue("Pending_Decision") == "Approve")
			{
				setControlValue("Pending_Decision", "P_Approve");
			}
			else 
			{
				setControlValue("Pending_Decision", "P_Discard");
			}*/
		} 
		if (ActivityName == "Branch_Approver")
		{
			if (!validateMandatory())
			{
				return false;
			}
			/*if (getValue("BA_Decision") == "Approve")
			{
				setControlValue("BA_Decision", "BA_CARDS");
			}
			else if (getValue("BA_Decision") == "Discard")
			{
				setControlValue("BA_Decision", "BA_D");
			}
			else 
			{
				setControlValue("BA_Decision", "BA_BR");
			}*/
				
		}			
		if (ActivityName == "CARDS")
		{
			if (!validateMandatory())
			{
				return false;
			}
			/*if (getValue("Cards_Decision") == "Complete")
			{
				setControlValue("Cards_Decision", "CARDS_E");
			}
			else if (getValue("Cards_Decision") == "Discard")
			{
				setControlValue("Cards_Decision", "CARDS_D");
			}
			else if (getValue("Cards_Decision") == "Under Process")
			{
				setControlValue("Cards_Decision", "CARDS_UP");
			}
			else 
			{
				setControlValue("Cards_Decision", "CARDS_BR");
			}*/
		}	
	}
	return true;
}



/*function setArchivalPath(ActivityName)
{
		if(ActivityName=="Introduction")
		{
			setValues({"ARCHIVALPATHSUCCESS":"Omnidocs\\CentralOperations\\&<CIF_ID>&\\DAC\\&<WI_NAME>&"},true);
			setValues({"ARCHIVALPATHREJECT":"Omnidocs\\CentralOperations\\&<CIF_ID>&\\Rejected\\DAC\\&<WI_NAME>&"},true);
		}
	
}*/
//}