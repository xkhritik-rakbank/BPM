function SetEventValues(CtrId,CtrEvent)
{		
	if (CtrEvent =="change")
	{
		if (CtrId == "Cards_Decision"){
			setStyle("Cards_Reject","visible","false");
			setStyle("Cards_Rework","visible","false");
			setValues({"Cards_Rework":""},true);
			setValues({"Cards_Reject":""},true);
			setStyle("Others_Reject_Reason","visible","false");
			setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","visible","false");
			setValues({"Others_Reject_Reason":""},true);
			setValues({"USR_0_DSR_MR_REJECT_SUB_REASON":""},true);
			setStyle("Cards_Reject","mandatory","false");
			setStyle("Cards_Rework","mandatory","false");
			if(getValue("Cards_Decision") == "CARDS_D"){
				setStyle("Cards_Reject","visible","true");
				setStyle("Cards_Reject","mandatory","true");
			}
			else if(getValue("Cards_Decision") == "CARDS_BR"){
				setStyle("Cards_Rework","visible","true");
				setStyle("Cards_Rework","mandatory","true");
			}
		}
		if (CtrId == "Pending_Decision"){
			setStyle("Pending_Reason","visible","false");
			setValues({"Pending_Reason":""},true);
			setStyle("Others_Pending_SubReason","visible","false");
			setStyle("USR_0_DSR_MR_PENDING_SUB","visible","false");
			setValues({"Others_Pending_SubReason":""},true);
			setValues({"USR_0_DSR_MR_PENDING_SUB":""},true);
			if(getValue("Pending_Decision") == "P_Discard"){
				setStyle("Pending_Reason","visible","true");
				setStyle("Pending_Reason","mandatory","true");
			}else{
				setStyle('Pending_Reason','visible','false');
				setStyle('Pending_Reason','mandatory','false');
			}
		}
		else if (CtrId == "VD_TIN_Check")
		{
			if(getValue("VD_TIN_Check") == true)
			{
				setControlValue("VD_TINCheck","Y");
			}
			else
			{
				setControlValue("VD_TINCheck","N");

			}
		}
		else if (CtrId == "VD_DOB_Check")
		{
			if(getValue("VD_DOB_Check") == true)
			{
				setControlValue("VD_DOB","Y");
			}
			else
			{
				setControlValue("VD_DOB","N");
			}
		}
		else if (CtrId == "VD_StaffId_Check")
		{
			if(getValue("VD_StaffId_Check") == true)
			{
				setControlValue("VD_StaffId","Y");
			}
			else
			{
				setControlValue("VD_StaffId","N");
			}
		}
		else if (CtrId == "VD_POBox_Check")
		{
			if(getValue("VD_POBox_Check") == true)
			{
				setControlValue("VD_POBox","Y");
			}
			else
			{
				setControlValue("VD_POBox","N");
			}
		}
		else if (CtrId == "VD_Oth_Check")
		{
			if(getValue("VD_Oth_Check") == true)
			{
				setControlValue("VD_Oth","Y");
			}
			else
			{
				setControlValue("VD_Oth","N");
			}
		}
		else if (CtrId == "VD_MRT_Check")
		{
			if(getValue("VD_MRT_Check") == true)
			{
				setControlValue("VD_MRT","Y");
			}
			else
			{
				setControlValue("VD_MRT","N");
			}
		}
		else if (CtrId == "VD_EDC_Check")
		{
			if(getValue("VD_EDC_Check") == true)
			{
				setControlValue("VD_EDC","Y");
			}
			else
			{
				setControlValue("VD_EDC","N");
			}
		}
		else if (CtrId == "VD_TELNO_Check")
		{
			if(getValue("VD_TELNO_Check") == true)
			{
				setControlValue("VD_TELNO","Y");
			}
			else
			{
				setControlValue("VD_TELNO","N");
			}
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
	}
		
	
    else if (CtrEvent =="click")
	 {
		if (CtrId == "Pending")
		{
		   setControlValue("initiateDecision", "Pending");
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
				callPrintJSPDSRMR(Response);
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
			setControlValue("DCI_ExtNo", "");
			clrCAPSFrm();
			
			setValue("VD_MoMaidN_Check","false");
			setValue("VD_TIN_Check","false");
			setValue("VD_MoMaidN","N");
			setValue("VD_TINCheck","N");
		
			clrValidationFrm();
			
			//clrHotlistFrm();
			setControlValue("REMARKS", "");
			//setControlValue("ACTION_TAKEN", "");
			//clrReplaceReqFrm();
			
			setStyle("Debit_Card_Section", "visible", "true");
			setStyle("Verification_Section", "visible", "true");
			setStyle("Remarks_Section", "visible", "true");
			setStyle("Buttons_Section", "visible", "false");
		    setStyle("Pending_Section", "visible", "false");
			setStyle("Cards_Section", "visible", "false");
			setStyle("Print_Section", "visible", "false");
			setStyle("Branch_Section", "visible", "false");
		 } 
     
		 
		
	}
			
		
}  

function fetchCardData() 
{
	//alert("MR fetchCardData");
	
/*	if (getValue("CCI_CRDTCN") == "")
	{
		showMessage("CardNo", "Enter Debit Card Number!","error");
		setFocus("CardNo");
		return false;
	} */
	if(getValue("DCI_DebitCN")=='')
	{
		//alert("Please enter Debit card no");
		setFocus("DCI_DebitCN");
		return false;
	}
	if(getValue("DCI_DebitCN").length!=16)
	{
		//alert("Please enter Valid Debit card no should be 16 digit");
		setFocus("DCI_DebitCN");
		return false;
	}
	
	var Response = executeServerEvent("CAPSMAIN_Query","Click","",true);
	//alert("Response :"+ Response);	
	if (Response!= "false")
	{
		    setStyle("Debit_Card_Section", "visible", "true");
			setStyle("Verification_Section", "visible", "true");
			setStyle("Remarks_Section", "visible", "true");
			setStyle("Buttons_Section", "visible", "true");
		    setStyle("Pending_Section", "visible", "true");
			setStyle("Cards_Section", "visible", "false");
			setStyle("Print_Section", "visible", "true");
			setStyle("Branch_Section", "visible", "false");
		
		lockCAPSFrm();

		setFocus("DCI_ExtNo");
	}
	else if(Response == "false")
	{
		showMessage("DCI_DebitCN", "Invalid Debit Card No. Format","error");
		setFocus("DCI_DebitCN");
		return false;
	}
	else
	{
		showMessage("DCI_DebitCN", "Customer Not Found!","error");
		setFocus("DCI_DebitCN");
		return false;
	}
	
}

function clrValidationFrm()
{	//alert("clear");
	setControlValue("VD_DOB", "N");
	setControlValue("VD_StaffId", "N");
	setControlValue("VD_POBox", "N");
	setControlValue("VD_PassNo", "N");
	setControlValue("VD_Oth", "N");
	setControlValue("VD_MRT", "N");
	setControlValue("VD_EDC", "N");
	setControlValue("VD_NOSC", "N");
	setControlValue("VD_TELNO", "N");
	setControlValue("VD_SD", "N");

	setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	setControlValue("VD_PassNo_Check", "false");
	setControlValue("VD_Oth_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_NOSC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
	setControlValue("VD_SD_Check", "false");
}

function clrCAPSFrm()
{
	setControlValue("DCI_CName", "");
	setControlValue("DCI_ExpD", "");
	setControlValue("DCI_ExpD", "");
	setControlValue("DCI_DebitCN", "");
	setControlValue("DCI_MONO", "");
	setControlValue("DCI_CT", "");
	setControlValue("DCI_CAPS_GENSTAT", "");
	setControlValue("DCI_ELITECUSTNO", "");
}


function lockValidationFrm(paramString)
{
	//alert(paramString+"ok");
	if (paramString == true)
	{	//alert("true in lock E");
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","false");
		setStyle("VD_StaffId_Check","disable","false");
		setStyle("VD_POBox_Check","disable","false");
		setStyle("VD_Oth_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_NOSC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_SD_Check","disable","false");
	}
	else if(paramString == false)
	{	//alert("false in lock E");
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
	}
}

