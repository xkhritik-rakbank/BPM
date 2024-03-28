function SetEventValues(CtrId,CtrEvent)
{
	//alert("CtrEvent :"+CtrEvent);
	//alert("CtrId :"+CtrId);
	if (CtrEvent =="blur")
	{
		if (CtrId == "CardNo_Text")
		{
			if (getValue("CardNo_Text").indexOf("-") > -1)
				setControlValue("CCI_CrdtCN", getValue("CardNo_Text").replace(/-/gi, ''));
			else
				setControlValue("CCI_CrdtCN", getValue("CardNo_Text"));
		}
		else if (CtrId == "oth_td_Amount_Text")
		{
			if (getValue("oth_td_Amount_Text").indexOf(",") > -1)
				setControlValue("oth_td_Amount", getValue("oth_td_Amount_Text").replace(/,/gi, ''));
			else
				setControlValue("oth_td_Amount", getValue("oth_td_Amount_Text"));
		}
	}
	if (CtrEvent =="change")
	{
		
		if (CtrId == "Cards_Decision"){
			setStyle("Cards_ReWorkReason","visible","false");
			setStyle("Cards_Reject","visible","false");
			setValues({"Cards_ReWorkReason":""},true);
			setValues({"Cards_Reject":""},true);
			setStyle("Others_Reject_Reason","visible","false");
			setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","visible","false");
			setValues({"Others_Reject_Reason":""},true);
			setValues({"USR_0_DSR_ODC_REJECT_SUB_REASON":""},true);
			setStyle("Cards_Reject","mandatory","false");
			setStyle("Cards_ReWorkReason","mandatory","false");
			if(getValue("Cards_Decision") == "CARDS_BR"){
				setStyle("Cards_ReWorkReason","visible","true");
				setStyle("Cards_ReWorkReason","mandatory","true");
			}else if (getValue("Cards_Decision") == "CARDS_D"){
				setStyle("Cards_Reject","visible","true");
				setStyle("Cards_Reject","mandatory","true");
			}
		}
		else if (CtrId == "BR_Decision"){
			setStyle("BR_Reject","visible","true");
			setValues({"BR_Reject":""},true);
			setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","visible","false");
			setStyle("Others_BR","visible","false");
			setValues({"Others_BR":""},true);
			setValues({"USR_0_DSR_ODC_RETURN_SUB_REASON":""},true);
			if(getValue("BR_Decision") == "Discard"){
				setStyle("BR_Reject","visible","true");
				setStyle("BR_Reject","mandatory","true");
			}else{
				setStyle('BR_Reject','visible','false');
				setStyle('BR_Reject','mandatory','false');
			}
		}
		else if (CtrId == "Cards_IsSRO_0"){
			setStyle("Cards_STR","visible","true");
			setStyle("Cards_TeamCode","visible","true");
			setStyle("Cards_SRORemarks","visible","true");
			setStyle("RaiseSRO","visible","true");
			setStyle("Cards_SRONo","visible","true");
			setStyle("Cards_SROStatus","visible","true");
			
			setStyle("Cards_STR","mandatory","true");
			setStyle("Cards_TeamCode","mandatory","true");
			setStyle("Cards_SRORemarks","mandatory","true");
		}
		else if (CtrId == "Cards_IsSRO_1"){
			setStyle("Cards_STR","visible","false");
			setStyle("Cards_TeamCode","visible","false");
			setStyle("Cards_SRORemarks","visible","false");
			setStyle("RaiseSRO","visible","false");
			setStyle("Cards_SRONo","visible","false");
			setStyle("Cards_SROStatus","visible","false");
			
			setStyle("Cards_STR","mandatory","false");
			setStyle("Cards_TeamCode","mandatory","false");
			setStyle("Cards_SRORemarks","mandatory","false");
		}
		else if (CtrId == "Pending_Decision"){
			setStyle("Pending_Reason","visible","false");
			setValues({"Pending_Reason":""},true);
			setStyle("Others_Pending_SubReason","visible","false");
			setStyle("USR_0_DSR_ODC_PENDING_SUB","visible","false");
			setValues({"Others_Pending_SubReason":""},true);
			setValues({"USR_0_DSR_ODC_PENDING_SUB":""},true);
			if(getValue("Pending_Decision") == "P_Discard"){
				setStyle("Pending_Reason","visible","true");
				setStyle("Pending_Reason","mandatory","true");
			}else{
				setStyle('Pending_Reason','visible','false');
				setStyle('Pending_Reason','mandatory','false');
			}
		}
		else if (CtrId == "CardNo_Text")
		{
			if (getValue("CardNo_Text").indexOf("-") > -1)
				setControlValue("DCI_DebitCN", getValue("CardNo_Text").replace(/-/gi, ''));
			else
				setControlValue("DCI_DebitCN", getValue("CardNo_Text"));
		}
		
		else if (CtrId == "oth_td_Amount_Text")
		{
			if (getValue("oth_td_Amount_Text").indexOf(",") > -1)
				setControlValue("oth_td_Amount", getValue("oth_td_Amount_Text").replace(/,/gi, ''));
			else
				setControlValue("oth_td_Amount", getValue("oth_td_Amount_Text"));
		}
		else if (CtrId == "VD_TIN_Check")
		{
			if(getValue("VD_TIN_Check") == true)
			{
				setControlValue("VD_TINCheck","Y");
				//setControlValue("VD_MoMaidN_Check","false");
			}
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
		else if (CtrId == "VD_Oth_Check")
		{
			if(getValue("VD_Oth_Check") == true)
				setControlValue("VD_Oth","Y");
			else
				setControlValue("VD_Oth","N");
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
		
		else if (CtrId == "VD_MRT_Check")
		{
			if(getValue("VD_MRT_Check") == true)
				setControlValue("VD_MRT","Y");
			else
				setControlValue("VD_MRT","N");
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
		else if (CtrId == "RIP_BRANCH")
		{
			setControlValue("oth_rip_BN",getValue("RIP_BRANCH"));
		}
		else if (CtrId == "CR_BRANCH")
		{
			setControlValue("oth_cr_BN",getValue("CR_BRANCH"));
		}
		else if (CtrId == "CDR_BRANCH")
		{
			setControlValue("oth_cdr_BN",getValue("CDR_BRANCH"));
		}
		else if (CtrId == "ECR_BRANCH")
		{
			setControlValue("oth_ecr_bn",getValue("ECR_BRANCH"));
		}
		else if (CtrId == "request_type")
		{
			hideFrames(getValue("request_type"), ActivityName,"OnChange");
		}
		else if (CtrId == "oth_rip_DC")
		{
			if (getValue("oth_rip_DC") == "Branch")
				setStyle("RIP_BRANCH","disable","false");			
			else
			{
				setControlValue("RIP_BRANCH", "");
				setControlValue("oth_rip_BN", "");
				setStyle("RIP_BRANCH","disable","true");
			}
		}
		else if (CtrId == "oth_rip_reason")
		{
			if (getValue("oth_rip_reason") == "Select")
			{
				setStyle("RIP_BRANCH","disable","true");
				setControlValue("oth_rip_DC", "");	
				setControlValue("RIP_BRANCH", "");	
		    }
		}
		else if (CtrId == "oth_cr_reason")
		{
		  if (getValue("oth_cr_reason") == "Others")
			{
				setStyle("oth_cr_OPS","disable","false");
			}
            else 
			{
				setStyle("oth_cr_OPS","disable","true");
				
			}				
		   
		}
		else if (CtrId == "oth_cr_DC")
		{
			if (getValue("oth_cr_DC") == "Branch")
			{
				setStyle("CR_BRANCH","disable","false");			
			}
			else
			{
				setControlValue("CR_BRANCH", "");
				setControlValue("oth_cr_BN", "");
				setStyle("CR_BRANCH","disable","true");
			}
		}
		else if (CtrId == "oth_ecr_dt")
		{
			if (getValue("oth_ecr_dt") == "Branch")
				setStyle("ECR_BRANCH","disable","false");
			else
			{
				setControlValue("ECR_BRANCH", "");
				setControlValue("oth_ecr_bn", "");
				setStyle("ECR_BRANCH","disable","true");
			}
		}
		
		else if (CtrId == "oth_cdr_CDT")
		{
			if (getValue("oth_cdr_CDT") == "Bank")
				setStyle("CDR_BRANCH","disable","false");
			else
			{
				setControlValue("CDR_BRANCH", "");
				setControlValue("oth_cdr_BN", "");
				setStyle("CDR_BRANCH","disable","true");
			}
		}
		
		
		
	}
	
	// For Click Event
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
			
		
            if(Response != "")
			{				
				callPrintJSPDSRODC(Response);
			}	
        }
		else if (CtrId=="Introduce")
	    {
			setControlValue("initiateDecision", "BranchApprover");	
			completeWorkItem();
		}
		else if (CtrId =="Refresh")
		{
			fetchCardData(ActivityName);			
		}
		
		else if (CtrId == "oth_cr_reason")
		{
			if (getValue("oth_cr_reason") == "Others")
				setStyle("oth_cr_OPS","disable","false");			
			else
				setControlValue("oth_cr_OPS", "");
				setStyle("oth_cr_OPS","disable","true");
		}
		
		else if (CtrId == "Clear")
		{
			setControlValue("DCI_ExtNo", "");
			clrCAPSFrm();
                //setValue("VD_Oth_Check","false");    
				setControlValue("VD_MoMaidN_Check", "false");
				setControlValue("VD_TIN_Check", "false");
				setControlValue("VD_MoMaidN", "N");
				//setValue("VD_Oth","N");
				setControlValue("VD_TIN_Check", "N");
				clrValidationFrm();

				setStyle("Credit_Card_Section", "visible", "false");
				setStyle("Verification_Section", "visible", "false");
				//setStyle("RRDFrm", "visible", "false");
				//setStyle("Frame1", "visible", "false");
				//setStyle("Frame2", "visible", "false");
				setStyle("Card_Replace_Section", "visible", "false");
				setStyle("Transaction_Dispute_Section", "visible", "false");
				setStyle("Buttons_Section", "visible", "false");
				setStyle("Early_Card_Section", "visible", "false");
				setStyle("Card_Replace_Section", "visible", "false");
				setStyle("Reissue_Dtls_Section", "visible", "false");
				setStyle("Process_Name_Section", "visible", "false");

				clearAndLockFields(ActivityName);
		}
		else if (CtrId =="RaiseSRO")
		{
			var serviceRequestTypeOnForm = document.getElementById("Cards_STR").value;
			var teamOnForm = document.getElementById("Cards_TeamCode").value;
			var sroRemarksOnForm = document.getElementById("Cards_SRORemarks").value;
			if(serviceRequestTypeOnForm != "" && teamOnForm != "" && sroRemarksOnForm != ""){
				sroRemarksOnForm = sroRemarksOnForm.split('\n').join('');
				var sroWIInfo = executeServerEvent("RaiseSRO", "Click", serviceRequestTypeOnForm+"~"+teamOnForm+"~"+sroRemarksOnForm, true);
			}else
				showAlertDialog('Please provide value of Service Request Type/Team/Remarks.');
			//alert(sroWIInfo);
			if(sroWIInfo.split("~")[0].indexOf("SRO-") > -1)
				setControlValue("Cards_SRONo",sroWIInfo.split("~")[0]);
			setControlValue("Cards_SROStatus",sroWIInfo.split("~")[1]);
			if(sroWIInfo.split("~")[1] == 'WI Created'){
				setStyle("Cards_IsSRO","disable","true");
				setStyle("RaiseSRO","disable","true");
				setStyle("Cards_STR","disable","true");
				setStyle("Cards_TeamCode","disable","true");
				setStyle("Cards_SRORemarks","disable","true");
				setStyle("Cards_SRONo","disable","true");
				setStyle("Cards_SROStatus","disable","true");
				//setControlValue("WORKITEM_STATUS","WIP-Complaints");
				//setControlValue("WorkitemStatus","WIP-Complaints");
			}else{
				setStyle("RaiseSRO","disable","false");
			}		
		}
	}
	
}

function fetchCardData(ActivityName) 
{
	ActivityName=ActivityName.toUpperCase();
	//alert("DSR_DCB fetchCardData");
	
	if (getValue("CardNo_Text") == "")
	{
		showMessage("CardNo_Text", "Enter Debit Card Number!","error");
		setFocus("CardNo_Text");
		return false;
	}
/*	if (!validateCCNo(getValue("CardNo_Text"), "CardNo_Text"))
	{
		setFocus("CardNo_Text");
		return false;
	}   */
	
	var Response1 = executeServerEvent("CAPSMAIN_Query","Click","",true);
	//alert("Response :"+Response1);	
	if (Response1 != "false")
	{
		setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		//setStyle("RRDFrm","visible","true");
		//setStyle("Frame1","visible","true");
		//setStyle("Frame2","visible","true");
		setStyle("Process_Name_Section","visible","true");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Credit_Card_Section","disable","true");
		lockCAPSFrm();

		if (ActivityName == "CRWORK INTRODUCTION")
		{
			setControlValue("request_type", "Card Replacement");
			setStyle("Card_Replace_Section","visible","true");
		}
		else if (ActivityName == "CDRWORK INTRODUCTION")
		{
			setControlValue("request_type", "Card Delivery Request");
			setStyle("Card_Delivery_Section","visible","true");
		}
		else if (ActivityName == "ECRWORK INTRODUCTION")
		{
			setControlValue("request_type", "Early Card Renewal");
			setStyle("Early_Card_Section","visible","true");
		}
		else if (ActivityName == "CUWORK INTRODUCTION")
		{
			setControlValue("request_type", "Card Upgrade");
			setStyle("CCUFrm","visible","true");
		}
		else if (ActivityName == "TDWORK INTRODUCTION")
		{
			setControlValue("request_type", "Transaction Dispute");
			setStyle("Transaction_Dispute_Section","visible","true");
		}
		
		else if (ActivityName == "RIPWORK INTRODUCTION")
		{
			setControlValue("request_type", "Re-Issue of PIN");
			setStyle("Reissue_Dtls_Section","visible","true");
		}
		setStyle("Reissue_Dtls_Section","disable","true");

		if (getValue("request_type") == "Card Replacement")
		{
			if (getValue("OTH_CR_REASON") != "OTHERS")
			{
				setStyle("OTH_CR_OPS","disable","true");
			}
			if (getValue("OTH_CR_DC") != "BRANCH")
			{
				setStyle("CR_BRANCH","disable","true");
			}
			
		}
		else if (getValue("request_type") == "Early Card Renewal")
		{
			if (getValue("oth_ecr_dt") != "BRANCH")
			{
				setStyle("ECR_BRANCH","disable","true");
			}
		}
		else if (getValue("request_type") == "Re-Issue of PIN")
		{
			if (getValue("oth_rip_DC") != "BRANCH")
			{
				setStyle("RIP_BRANCH","disable","true");
			}
		}
		else if (getValue("request_type") == "Card Delivery Request")
		{
			if (getValue("oth_cdr_CDT") != "BANK")
			{
				setStyle("CDR_BRANCH","disable","true");
			}
		}
		else if (getValue("request_type") != "Transaction Dispute")
            setFocus("CCI_ExtNo");
	}
	else if(Response1 == "false")
	{
		showMessage("CardNo_Text", "Invalid Credit Card No. Format","error");
		setFocus("CardNo_Text");
		return false;
	}
	else
	{
		showMessage("CardNo_Text", "Customer Not Found!","error");
		setFocus("CardNo_Text");
		return false;
	}
	
}

function clrValidationFrm()
{
   setControlValue("VD_DOB", "N");
	setControlValue("VD_StaffId", "N");
	setControlValue("VD_POBox", "N");
	//setControlValue("VD_MoMaidN", "N");
	setControlValue("VD_MRT", "N");
	setControlValue("VD_EDC", "N");
	setControlValue("VD_TELNO", "N");
	setControlValue("VD_Oth", "N");

	setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	//setControlValue("VD_MoMaidN_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
	setControlValue("VD_Oth", "false");
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

function clearAndLockFields(paramString)
{
	setControlValue("request_type", "");

	if (paramString == "CRWORK INTRODUCTION")
	{
		clearAndLockCRFrm();
	}
	else if (paramString == "CDRWORK INTRODUCTION")
	{
		clearAndLockCDRFrm();
	}
	else if (paramString == "ECRWORK INTRODUCTION")
	{
		clearAndLockECRFrm();
	}
	else if (paramString == "TDWORK INTRODUCTION")
	{
		clearAndLockTDFrm();
	}
	else if (paramString == "RIPWORK INTRODUCTION")
	{
		clearAndLockRIPFrm();
	}
}


function clearAndLockCRFrm()
{
	setControlValue("oth_cr_dc", "");
	setControlValue("oth_cr_RR", "");
	setControlValue("CR_BRANCH", "");
	setControlValue("oth_cr_BN", "");
	setControlValue("oth_cr_reason", "");
	setStyle("CR_BRANCH","disable","true");
	setControlValue("oth_cr_OPS", "");
	setStyle("oth_cr_OPS","disable","true");
}

function clearAndLockCDRFrm()
{
	setControlValue("oth_cdr_CDT", "");
	setControlValue("oth_cdr_RR", "");
	setControlValue("CDR_BRANCH", "");
	setControlValue("oth_cdr_BN", "");
	setStyle("CDR_BRANCH","disable","true");
}

function clearAndLockECRFrm()
{

	//setControlValue("OTH_ECR_RB", "");
	setControlValue("oth_ecr_dt", "");
	setControlValue("oth_ecr_RR", "");
	setControlValue("ECR_BRANCH", "");
	setControlValue("oth_ecr_bn", "");
	setStyle("ECR_BRANCH","disable","true");
}
function clearAndLockTDFrm()
{
	setControlValue("OTH_TD_AMOUNT_Text", "");
	setControlValue("oth_td_Amount", "");
	setControlValue("oth_td_RR", "");
	setControlValue("oth_td_RNO", "");
}

function clearAndLockRIPFrm()
 {
	setControlValue("oth_rip_RR", "");
	setControlValue("oth_rip_reason", "");
	setControlValue("oth_rip_DC", "");
	setControlValue("RIP_BRANCH", "");
	setControlValue("oth_rip_BN", "");
	setStyle("RIP_BRANCH","disable","true");
}