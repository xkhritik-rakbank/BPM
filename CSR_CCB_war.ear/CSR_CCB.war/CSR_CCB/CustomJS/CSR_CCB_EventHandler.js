function SetEventValues(CtrId,CtrEvent)
{
	if (CtrEvent =="change")
	{
		//alert("CtrId :"+CtrId);
		if (CtrId == "VD_TIN_Check")
		{
			if(getValue("VD_TIN_Check") == true)
			  setControlValue("VD_TINCheck","Y");
			else
			  setControlValue("VD_TINCheck","N");

		}
		else if (CtrId == "VD_DOB_Check")
		{
			if(getValue("VD_DOB_Check") == true)
			  setControlValue("VD_DOB","Y");
			else
			  setControlValue("VD_DOB","N");
			
		}
		else if (CtrId == "VD_StaffId_Check")
		{
			if(getValue("VD_StaffId_Check") == true)
			  setControlValue("VD_StaffId","Y");
			else
			  setControlValue("VD_StaffId","N");
			
		}
		else if (CtrId == "VD_POBox_Check")
		{
			if(getValue("VD_POBox_Check") == true)
			  setControlValue("VD_POBox","Y");
			else
			   setControlValue("VD_POBox","N");
			
		}
		else if (CtrId == "VD_PassNo_Check")
		{
			if(getValue("VD_PassNo_Check") == true)
				setControlValue("VD_PassNo","Y");
			else
				setControlValue("VD_PassNo","N");
		}
		else if (CtrId == "VD_Oth_Check")
		{
			if(getValue("VD_Oth_Check") == true)
			  setControlValue("VD_Oth","Y");
			else
			  setControlValue("VD_Oth","N");
			
		}
		else if (CtrId == "VD_MRT_Check")
		{
			if(getValue("VD_MRT_Check") == true)
			 setControlValue("VD_MRT","Y");
			else
			  setControlValue("VD_MRT","N");
			
		}
		else if (CtrId == "VD_NOSC_Check")
		{
			if(getValue("VD_NOSC_Check") == true)
				setControlValue("VD_NOSC","Y");
			else
				setControlValue("VD_NOSC","N");
		}
		else if (CtrId == "VD_EDC_Check")
		{
			if(getValue("VD_EDC_Check") == true)
			   setControlValue("VD_EDC","Y");
			else
		       setControlValue("VD_EDC","N");
			
		}
		else if (CtrId == "VD_TELNO_Check")
		{
			if(getValue("VD_TELNO_Check") == true)
		        setControlValue("VD_TELNO","Y");
			else
				setControlValue("VD_TELNO","N");
			
		}
		else if (CtrId == "VD_SD_Check")
		{
			if(getValue("VD_SD_Check") == true)
				setControlValue("VD_SD","Y");
			else
				setControlValue("VD_SD","N");			
		}
		else if (CtrId == "VD_MoMaidN_Check")
		{
			if (getValue("VD_MoMaidN_Check") == true)
			{
				setControlValue("VD_MoMaidN", "Y");
				setControlValue("VD_TINCheck", "N");
				setControlValue("VD_TIN_Check", "false");
			}
			else 
			{
				setControlValue("VD_MoMaidN", "N");
				clrValidationFrm();
			}
			lockValidationFrm(getValue("VD_MoMaidN_Check"));
		}
		else if (CtrId =="REASON_HOTLIST")
		{
			lockHotlistFrm(getValue("REASON_HOTLIST"));
		}
		else if (CtrId =="ACTION_TAKEN")
		{
			lockReplaceReqFrm(getValue("ACTION_TAKEN"));
		}
		else if (CtrId =="DELIVER_TO")
		{
			if (getValue("DELIVER_TO") == 'Branch')
			{
				setStyle("BRANCH_NAME","disable" ,"false");
				
			}
			else
			{
				
				setControlValue("BRANCH_NAME", "");
				setStyle("BRANCH_NAME","disable","true");
			}			
		}
		
		
	}
	else if (CtrEvent =="click")
	{
		if (CtrId == "Pending")
		{
			setControlValue("initiateDecision","Pending");
			completeWorkItem();
		
		}
        else if (CtrId == "Print")
		{
			//alert("Print");
			// below 1 line change made for JIRA PBU-5394
			var Cards_Decision = getValue("Cards_Decision");
			if (Cards_Decision == ""){
			setControlValue("Cards_Decision","CARDS_UP");
			saveWorkItem();
			}
			var Response = executeServerEvent("PrintButton","Click","",true);
	
			//alert("response "+Response);	
            if(Response != "")
			{				
				callPrintJSPCSRCCB(Response);
			}	
        }

		else if (CtrId=="Introduce")
	    {
			setControlValue("initiateDecision", "BranchApprover");	
			completeWorkItem();
			
	    }
	    else if (CtrId =="Refresh")
		{
			fetchCardData();			
		} 
		else if (CtrId == "Clear")
		{
			setControlValue("CCI_ExtNo", "");
			clrCAPSFrm();
			
			setValue("VD_MoMaidN_Check","false");
			setValue("VD_TIN_Check","false");
			setValue("VD_MoMaidN","N");
			setValue("VD_TINCheck","N");
		
			clrValidationFrm();
			setControlValue("REASON_HOTLIST", "");
			clrHotlistFrm();
			setControlValue("REMARKS", "");
			setControlValue("ACTION_TAKEN", "");
			clrReplaceReqFrm();
			
			//setStyle("Verification_Section", "visible", "false");
			setStyle("Replacement_Section", "visible", "false");
			setStyle("Hostlist_Section", "visible", "false");
			
		} 
	}
}

function fetchCardData()
{
	//alert("DCB fetchCardData");

	if(getValue("CCI_CrdtCN")=='')
	{
		//alert("Please enter Debit card no");
		setFocus("CCI_CrdtCN");
		return false;
	}
	if(getValue("CCI_CrdtCN").length!=16)
	{
		//alert("Please enter Valid Debit card no should be 16 digit");
		setFocus("CCI_CrdtCN"); 
		return false;
	}
	
	var Response = executeServerEvent("CAPSMAIN_Query","Click","",true);
	//alert("Response :"+Response);	
	if (Response!= "false")
	{
		setStyle("Verification_Section","visible","true");
		//setStyle("baseFr3","visible","true");
		setStyle("Branch_Approver_Section","visible","false");
		setStyle("Hostlist_Section","visible","true");
		setStyle("Replacement_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		
		lockCAPSFrm();

		setFocus("CCI_ExtNo");
	}
	else if(Response == "false")
	{
		showMessage("CCI_CrdtCN", "Invalid Debit Card No. Format","error");
		setFocus("CCI_CrdtCN");
		return false;
	}
	else
	{
		showMessage("CCI_CrdtCN", "Customer Not Found!","error");
		setFocus("CCI_CrdtCN"); 
		return false;
	}
	
}
