function setCustomControlsValue(Flag,activityname)
{
	if(Flag == 'S')
	{
		if (activityname.toUpperCase() == "PENDING")
		{
			/*if (getValue("Combo_Pending_Dec") == "Approve")
				setControlValue("Pending_Decision", "P_Approve");
			else 
				setControlValue("Pending_Decision", "P_Discard");*/
		}
		else if (activityname.toUpperCase() == "BRANCH_RETURN")
		{
			/*if (getValue("BR_Dec_Combo") == "Re-Submit to CARDS")
				setControlValue("BR_Decision", "Approve");
			else if (getValue("BR_Dec_Combo") == "Discard")
				setControlValue("BR_Decision", "Discard");
			else 
				setControlValue("BR_Decision", "");*/
		}
		else if (activityname.toUpperCase() == "CARDS")
		{
			/*if (getValue("CA_Dec_Combo") == "Complete")
				setControlValue("Cards_Decision", "CARDS_E");
			else if (getValue("CA_Dec_Combo") == "Discard")
				setControlValue("Cards_Decision", "CARDS_D");
			else if (getValue("CA_Dec_Combo") == "Under Process")
				setControlValue("Cards_Decision", "CARDS_UP");
			else 
				setControlValue("Cards_Decision", "CARDS_BR");*/
		}
		if (!validateForSave())
			return false;
	}
	else if(Flag == 'I' || Flag == 'D')
	{
		//if (activityname.toUpperCase().indexOf("INTRODUCTION") > -1)
			if (activityname.toUpperCase() == "INTRODUCTION")
		{
			if (getValue("initiateDecision") == "Pending")
			{
				if (!validateMandatoryForPending())
					return false;
			}
			else if (!validateMandatory())
				return false;
		}
			
		else if (activityname.toUpperCase() == "PENDING")
		{
			if (!validateMandatory())
				return false;

			/*if (getValue("Combo_Pending_Dec") == "Approve")
				setControlValue("Pending_Decision", "P_Approve");
			else 
				setControlValue("Pending_Decision", "P_Discard");*/
		}
		else if (activityname.toUpperCase() == "BRANCH_RETURN")
		{
			if (!validateMandatory())
				return false;
			
			/*if (getValue("BR_Dec_Combo") == "Re-Submit to CARDS")
				setControlValue("BR_Decision", "Approve");
			else if (getValue("BR_Dec_Combo") == "Discard")
				setControlValue("BR_Decision", "Discard");
			else 
				setControlValue("BR_Decision", "");*/
		}
		else if (activityname.toUpperCase() == "CARDS")
		{
			if (!validateMandatory())
				return false;
			
			/*if (getValue("CA_Dec_Combo") == "Complete")
				setControlValue("Cards_Decision", "CARDS_E");
			else if (getValue("CA_Dec_Combo") == "Discard")
				setControlValue("Cards_Decision", "CARDS_D");
			else if (getValue("CA_Dec_Combo") == "Under Process")
				setControlValue("Cards_Decision", "CARDS_UP");
			else 
				setControlValue("Cards_Decision", "CARDS_BR");*/
		}
	}
	return true;
}

/*function enableDisableRejectReasons()
{
	if((getValue("DECISION").indexOf("Reject")!=-1) || (getValue("DECISION").indexOf("Reject to Initiator")!=-1))
	{
		setStyle("REJECT_REASON_GRID","visible","true");
		
	}
	else
	{
		setStyle("REJECT_REASON_GRID","visible","false");
		clearTable("REJECT_REASON_GRID",true);
	}
	
}*/
