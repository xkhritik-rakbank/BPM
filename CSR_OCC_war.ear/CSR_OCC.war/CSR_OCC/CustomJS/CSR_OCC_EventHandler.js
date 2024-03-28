function SetFieldValues(CtrId,CtrEvent)
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
		else if (CtrId =="oth_ssc_Amount_Text")
		{
			if (getValue("oth_ssc_Amount_Text").indexOf(",") > -1)
				setControlValue("oth_ssc_Amount", getValue("oth_ssc_Amount_Text").replace(/,/gi, ''));
			else
				setControlValue("oth_ssc_Amount", getValue("oth_ssc_Amount_Text"));
		}
		else if (CtrId =="oth_cs_Amount_Text")
		{
			if (getValue("oth_cs_Amount_Text").indexOf(",") > -1)
				setControlValue("OTH_CS_AMOUNT", getValue("oth_cs_Amount_Text").replace(/,/gi, ''));
			else
				setControlValue("OTH_CS_AMOUNT", getValue("oth_cs_Amount_Text"));
		}
		else if (CtrId == "oth_td_Amount_Text")
		{
			if (getValue("oth_td_Amount_Text").indexOf(",") > -1)
				setControlValue("oth_td_Amount", getValue("oth_td_Amount_Text").replace(/,/gi, ''));
			else
				setControlValue("oth_td_Amount", getValue("oth_td_Amount_Text"));
		}
	}
	else if (CtrEvent =="change")
	{ // CHANGES MADE HERE
		if (CtrId == "Cards_Decision"){
			setStyle("Cards_ReWorkReason","visible","false");
			setStyle("Cards_Reject","visible","false");
			setValues({"Cards_ReWorkReason":""},true);
			setValues({"Cards_Reject":""},true);
			setStyle("Others_Reject_Reason","visible","false");
			setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","visible","false");
			setValues({"Others_Reject_Reason":""},true);
			setValues({"USR_0_CSR_OCC_REJECT_SUB_REASON":""},true);
			setStyle("Cards_ReWorkReason","mandatory","false");
			setStyle("Cards_Reject","mandatory","false");
			if(getValue("Cards_Decision") == "CARDS_BR"){
				var rtype = getValue("request_type");
				if(rtype == "Card Delivery Request" || rtype == "Card Replacement" || rtype == "Card Upgrade" || rtype == "Change in Standing Instructions" || rtype == "Credit Limit Increase" || rtype == "Early Card Renewal" || rtype == "Re-Issue of PIN" || rtype == "Setup Suppl. Card Limit"){
					setStyle("Cards_ReWorkReason","visible","true");
					setStyle("Cards_ReWorkReason","mandatory","true");
				}
			}else if (getValue("Cards_Decision") == "CARDS_D"){
				setStyle("Cards_Reject","visible","true");
				setStyle("Cards_Reject","mandatory","true");
			}
		}
		else if (CtrId == "Cards_IsSRO_0"){
			setStyle("Cards_STR","visible","true");
			setStyle("Cards_TeamCode","visible","true");
			setStyle("Cards_SRORemarks","visible","true");
			setStyle("Cards_SRONo","visible","true");
			setStyle("Cards_SROStatus","visible","true");
			setStyle("Cards_STR","mandatory","true");
			setStyle("Cards_TeamCode","mandatory","true");
			setStyle("Cards_SRORemarks","mandatory","true");
			setStyle("RaiseSRO","visible","true");
		}
		else if (CtrId == "Cards_IsSRO_1"){
			setStyle("Cards_STR","visible","false");
			setStyle("Cards_TeamCode","visible","false");
			setStyle("Cards_SRORemarks","visible","false");
			setStyle("Cards_SRONo","visible","false");
			setStyle("Cards_SROStatus","visible","false");
			setStyle("Cards_STR","mandatory","false");
			setStyle("Cards_TeamCode","mandatory","false");
			setStyle("Cards_SRORemarks","mandatory","false");
			setStyle("RaiseSRO","visible","false");
		}
		else if (CtrId == "Pending_Decision"){
			setStyle("Pending_Reason","visible","false");
			setValues({"Pending_Reason":""},true);
			setStyle("Others_Pending_SubReason","visible","false");
			setStyle("USR_0_CSR_OCC_PENDING_SUB","visible","false");
			setValues({"Others_Pending_SubReason":""},true);
			setValues({"USR_0_CSR_OCC_PENDING_SUB":""},true);
			if(getValue("Pending_Decision") == "P_Discard"){
				setStyle("Pending_Reason","visible","true");
				setStyle("Pending_Reason","mandatory","true");
			}else{
				setStyle('Pending_Reason','visible','false');
				setStyle("Pending_Reason","mandatory","false");
			}
		}
		else if (CtrId == "BR_Decision"){
			setStyle("BR_Reject","visible","false");
			setStyle("BR_Reject","mandatory","false");
			if(getValue("BR_Decision") == "Discard"){
				setStyle("BR_Reject","visible","true");
				setStyle("BR_Reject","mandatory","true");
			}
		}
		else if (CtrId == "VD_TIN_Check")
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
		else if (CtrId == "VD_EDC_Check")
		{
			if(getValue("VD_EDC_Check") == true)
				setControlValue("VD_EDC","Y");
			else
				setControlValue("VD_EDC","N");
		}
		else if (CtrId == "VD_NOSC_Check")
		{
			if(getValue("VD_NOSC_Check") == true)
				setControlValue("VD_NOSC","Y");
			else
				setControlValue("VD_NOSC","N");
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
		else if (CtrId == "oth_cr_DC")
		{
			if (getValue("oth_cr_DC") == "Branch")
				setStyle("CR_BRANCH","disable","false");
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
			setControlValue("OTH_CDR_BN",getValue("CDR_BRANCH"));
		}
		else if (CtrId == "ECR_BRANCH")
		{
			setControlValue("oth_ecr_bn",getValue("ECR_BRANCH"));
		}
		else if (CtrId == "oth_ssc_SCNo_Combo")
		{
			if(getValue("oth_ssc_SCNo_Combo") != "")
			{
				setControlValue("oth_ssc_SCNo", getValue("oth_ssc_SCNo_Combo").replace(/-/gi, ''));
			}
			else
				setControlValue("oth_ssc_SCNo", "");
		}
	}
	else if (CtrEvent =="click")
	{
		if (CtrId == "Introduce_Button")
		{
			setControlValue("initiateDecision", "BranchApprover");
			//this.formObject.RaiseEvent("WFDone");
			completeWorkItem();
		}
		else if (CtrId == "Pending_Button")
		{
			setControlValue("initiateDecision", "Pending");
			//this.formObject.RaiseEvent("WFDone");		
			completeWorkItem();			
		}
		else if (CtrId == "Print_Button")
		{
			/*if (getValue("CA_Dec_Combo") == "")
				setControlValue("CA_Dec_Combo", "Under Process");
			
			if (getValue("CA_Dec_Combo") == "Complete")
				setControlValue("Cards_Decision", "CARDS_E");
			else if (getValue("CA_Dec_Combo") == "Discard")
				setControlValue("Cards_Decision", "CARDS_D");
			else if (getValue("CA_Dec_Combo") == "Under Process")
				setControlValue("Cards_Decision", "CARDS_UP");
			else 
				setControlValue("Cards_Decision", "CARDS_BR");	*/
			// below 1 line change made for JIRA PBU-5394
			var Cards_Decision = getValue("Cards_Decision");
			if (Cards_Decision == ""){
			setControlValue("Cards_Decision","CARDS_UP");
			saveWorkItem();
			}
			var Response = executeServerEvent("Print_Button","Click","",true);
	
			//alert("Response :"+Response);
			if(Response != "false")
			{				
				callPrintJSPCSROCC(Response);
			}
			
		}
		else if (CtrId =="Refresh_Button")
		{
			fetchCardData(ActivityName);			
		}
		else if (CtrId == "oth_cs_CS")
		{
			if (getValue("oth_cs_CS") == "UN-ENROLLEMENT")
				setStyle("oth_cs_CSR_Check","disable","false");			
			else
			{
				setControlValue("oth_cs_Amount_Text", "");
				setStyle("oth_cs_Amount_Text","disable","true");
				setControlValue("oth_cs_CSR_Check", "False");
				setStyle("oth_cs_CSR_Check","disable","true");
				setControlValue("oth_cs_CSR", "N");
			}
		}
		else if (CtrId == "oth_cs_CSR_Check")
		{
			if (getValue("oth_cs_CSR_Check") == true)
			{
				setControlValue("oth_cs_CSR", "Y");
				setStyle("oth_cs_Amount_Text","disable","false");
			}
			else
			{
				setControlValue("oth_cs_Amount_Text", "");
				setStyle("oth_cs_Amount_Text","disable","true");
				setControlValue("oth_cs_CSR", "N");
				setStyle("oth_cs_CSR","disable","true");
			}
		}
		else if (CtrId == "oth_cr_reason")
		{
			if (getValue("oth_cr_reason") == "Others")
				setStyle("oth_cr_OPS","disable","false");			
			else
				setControlValue("oth_cr_OPS", "");
				setStyle("oth_cr_OPS","disable","true");
		}
		else if (CtrId == "oth_cli_type")
		{
			if (getValue("oth_cli_type") == "TEMPORARY")
			{
				setStyle("oth_cli_months","disable","false");
			}
			else
			{
				setControlValue("oth_cli_months", "");
				setStyle("oth_cli_months","disable","true");
			}
		}
		else if (CtrId == "oth_csi_PH_Combo")
		{
			if (getValue("oth_csi_PH_Combo") == true)
			{
				setControlValue("oth_csi_PH", "Y");
				setStyle("oth_csi_TOH","disable","true");
				if (getValue("oth_csi_TOH") == "Temporary")
				{
					setStyle("oth_csi_NOM","disable","true");
				}
				else
				{
					setStyle("oth_csi_NOM","disable","false");
				}
			}
			else
			{
				setControlValue("oth_csi_PH", "N");
				setControlValue("oth_csi_TOH", "");
				setStyle("oth_csi_TOH","disable","false");
				setControlValue("oth_csi_NOM", "");
				setStyle("oth_csi_NOM","disable","false");
			}
		}
		else if (CtrId == "oth_csi_TOH")
		{
			if (getValue("oth_csi_TOH") == "Temporary")
			{
				setStyle("oth_csi_NOM","disable","false");
			}
			else
			{
				setStyle("oth_csi_NOM","disable","true");
			}
		}
		else if (CtrId == "oth_csi_CSIP_Check")
		{
			if (getValue("oth_csi_CSIP_Check") == true)
			{
				setControlValue("oth_csi_CSIP", "Y");
				setStyle("oth_csi_POSTMTB","disable","false");
			}
			else
			{
				setControlValue("oth_csi_CSIP", "N");
				setControlValue("oth_csi_POSTMTB", "");
				setStyle("oth_csi_POSTMTB","disable","true");
			}
		}
		else if (CtrId == "oth_csi_CSID_Check")
		{
			if (getValue("oth_csi_CSID_Check") == true)
			{
				setControlValue("oth_csi_CSID", "Y");
				setStyle("oth_csi_ND","disable","false");
			}
			else
			{
				setControlValue("oth_csi_CSID", "N");
				setControlValue("oth_csi_ND", "");
				setStyle("oth_csi_ND","disable","true");
			}
		}
		else if (CtrId == "oth_csi_CDACNo_Check")
		{
			if (getValue("oth_csi_CDACNo_Check") == true)
			{
				setControlValue("oth_csi_CDACNo", "Y");
				setStyle("oth_csi_AccNo","disable","false");
			}
			else
			{
				setControlValue("oth_csi_CDACNo", "N");
				setControlValue("oth_csi_AccNo", "");
				setStyle("oth_csi_AccNo","disable","true");
			}
		}
		else if (CtrId == "Clear")
		{
			setControlValue("CCI_ExtNo", "");
			clrCAPSFrm();

			setControlValue("VD_MoMaidN_Check", "false");
			setControlValue("VD_TIN_Check", "false");
			setControlValue("VD_MoMaidN", "N");
			setControlValue("VD_TINCheck", "N");
			clrValidationFrm();

			setStyle("baseFr2", "visible", "false");
			setStyle("baseFr3", "visible", "false");
			setStyle("RRDFrm", "visible", "false");
			setStyle("Frame1", "visible", "false");
			setStyle("Frame2", "visible", "false");
			setStyle("SSCFrm", "visible", "false");
			setStyle("CSFrm", "visible", "false");
			setStyle("CDRFrm", "visible", "false");
			setStyle("CCUFrm", "visible", "false");
			setStyle("TDFrm", "visible", "false");
			setStyle("CISFrm", "visible", "false");
			setStyle("BtnFrm", "visible", "false");
			setStyle("ECRFrm", "visible", "false");
			setStyle("CLIFrm", "visible", "false");
			setStyle("CRFrm", "visible", "false");
			setStyle("RIPFrm", "visible", "false");
			setStyle("ProNameFrm", "visible", "false");

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

function fetchCardData(activityname) 
{
	activityname=activityname.toUpperCase();
	alert("OCC fetchCardData");
	
	if (getValue("CCI_CRDTCN") == "")
	{
		showMessage("CardNo_Text", "Enter Credit Card Number!","error");
		setFocus("CardNo_Text");
		return false;
	}
	if (!validateCCNo(getValue("CardNo_Text"), "CardNo_Text"))
	{
		setFocus("CardNo_Text");
		return false;
	}
	
	var Response1 = executeServerEvent("CAPSMAIN_Query1","Click","",true);
	//alert("Response :"+Response1);	
	if (Response1 != "false")
	{
		setStyle("baseFr2","visible","true");
		setStyle("baseFr3","visible","true");
		setStyle("RRDFrm","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("Frame2","visible","true");
		setStyle("ProNameFrm","visible","true");
		setStyle("BtnFrm","visible","true");
		lockCAPSFrm();

		if (activityname == "CRWORK INTRODUCTION")
		{
			setControlValue("request_type", "Card Replacement");
			setStyle("CRFrm","visible","true");
		}
		else if (activityname == "SSCWORK INTRODUCTION")
		{
			//alert("activityname :"+activityname);
			setControlValue("request_type", "Setup Suppl. Card Limit");
			setStyle("SSCFrm","visible","true");
			
			var Response2 = executeServerEvent("CAPSMAIN_Query2","Click","",true);
			//alert("Response :"+Response2);
		}
		else if (activityname == "CSWORK INTRODUCTION")
		{
			setControlValue("request_type", "Credit Shield");
			setStyle("CSFrm","visible","true");
		}
		else if (activityname == "CDRWORK INTRODUCTION")
		{
			setControlValue("request_type", "Card Delivery Request");
			setStyle("CDRFrm","visible","true");
		}
		else if (activityname == "ECRWORK INTRODUCTION")
		{
			setControlValue("request_type", "Early Card Renewal");
			setStyle("ECRFrm","visible","true");
		}
		else if (activityname == "CUWORK INTRODUCTION")
		{
			setControlValue("request_type", "Card Upgrade");
			setStyle("CCUFrm","visible","true");
		}
		else if (activityname == "TDWORK INTRODUCTION")
		{
			setControlValue("request_type", "Transaction Dispute");
			setStyle("TDFrm","visible","true");
		}
		else if (activityname == "CLIWORK INTRODUCTION")
		{
			setControlValue("request_type", "Credit Limit Increase");
			setStyle("CLIFrm","visible","true");
		}
		else if (activityname == "CSIWORK INTRODUCTION")
		{
			setControlValue("request_type", "Change in Standing Instructions");
			setStyle("CISFrm","visible","true");
		}
		else if (activityname == "RIPWORK INTRODUCTION")
		{
			setControlValue("request_type", "Re-Issue of PIN");
			setStyle("RIP_Section","visible","true");
		}
		setStyle("request_type","disable","false");

		if (getValue("request_type") == "Change in Standing Instructions")
		{
			if (getValue("oth_csi_PH") == "Y")
			{
				setControlValue("oth_csi_PH", "True");
				setStyle("OTH_CSI_TOH","disable","true");
				setStyle("OTH_CSI_NOM","disable","true");
			}
			else
			{
				setControlValue("oth_csi_PH", "N");
				setControlValue("OTH_CSI_TOH", "");
				setStyle("OTH_CSI_TOH","disable","false");
				setControlValue("OTH_CSI_NOM", "");
				setStyle("OTH_CSI_NOM","disable","false");
			}

			if (getValue("oth_csi_CSIP") == "Y")
			{
				setControlValue("oth_csi_CSIP", "True");
				setStyle("OTH_CSI_POSTMTB","disable","true");
			}
			else
			{
				setControlValue("oth_csi_CSIP", "N");
				setControlValue("OTH_CSI_POSTMTB", "");
				setStyle("OTH_CSI_POSTMTB","disable","false");
			}
			if (getValue("OTH_CSI_CSID") == "Y")
			{
				setControlValue("OTH_CSI_CSID", "True");
				setStyle("OTH_CSI_ND","disable","true");
			}
			else
			{
				setControlValue("OTH_CSI_CSID", "N");
				setControlValue("OTH_CSI_ND", "");
				setStyle("OTH_CSI_ND","disable","false");
			}
			if (getValue("oth_csi_CDACNo") == "Y")
			{
				setControlValue("oth_csi_CDACNo", "True");
				setStyle("OTH_CSI_ACCNO","disable","true");
			}
			else
			{
				setControlValue("oth_csi_CDACNo", "N");
				setControlValue("OTH_CSI_ACCNO", "");
				setStyle("OTH_CSI_ACCNO","disable","false");
			}
		}
		else if (getValue("request_type") == "Card Replacement")
		{
			if (getValue("OTH_CR_REASON") != "OTHERS")
			{
				setStyle("oth_cr_OPS","disable","false");
			}
			if (getValue("OTH_CR_DC") != "BRANCH")
			{
				setStyle("CR_BRANCH","disable","false");
			}
		}
		else if (getValue("request_type") == "Early Card Renewal")
		{
			if (getValue("OTH_ECR_DT") != "BRANCH")
			{
				setStyle("ECR_BRANCH","disable","false");
			}
		}
		else if (getValue("request_type") == "Re-Issue of PIN")
		{
			if (getValue("OTH_RIP_DC") != "BRANCH")
			{
				setStyle("RIP_BRANCH","disable","false");
			}
		}
		else if (getValue("request_type") == "Credit Limit Increase")
		{
			if (getValue("oth_cli_type") != "TEMPORARY")
			{
				setStyle("oth_cli_months","disable","false");
			}
		}
		else if (getValue("request_type") == "Card Delivery Request")
		{
			if (getValue("OTH_CDR_CDT") != "BANK")
			{
				setStyle("CDR_BRANCH","disable","false");
			}
		}
		else if (getValue("request_type") == "Credit Shield")
		{
			if (getValue("OTH_CDR_CDT") != "UN-ENROLLEMENT")
			{
				setStyle("OTH_CS_CSR","disable","false");
			}
			else
			{
				setStyle("OTH_CS_CSR","disable","true");
			}
		}
		else if (getValue("request_type") != "Card Upgrade")
		{
			if (getValue("request_type") != "Transaction Dispute");
		}
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
	setControlValue("VD_PassNo", "N");
	setControlValue("VD_Oth", "N");
	setControlValue("VD_MRT", "N");
	setControlValue("VD_EDC", "N");
	setControlValue("VD_NOSC", "N");
	setControlValue("VD_TELNO", "N");
	setControlValue("VD_SD", "N");

	setControlValue("VD_DOB_Check", "False");
	setControlValue("VD_StaffId_Check", "False");
	setControlValue("VD_POBox_Check", "False");
	setControlValue("VD_PassNo_Check", "False");
	setControlValue("VD_Oth_Check", "False");
	setControlValue("VD_MRT_Check", "False");
	setControlValue("VD_EDC_Check", "False");
	setControlValue("VD_NOSC_Check", "False");
	setControlValue("VD_TELNO_Check", "False");
	setControlValue("VD_SD_Check", "False");
}

function clrCAPSFrm()
{
	setControlValue("CCI_CName", "");
	setControlValue("CCI_ExpD", "");
	setControlValue("CCI_ExpD", "");
	setControlValue("CCI_CrdtCN", "");
	setControlValue("CCI_CCRNNo", "");
	setControlValue("CCI_MONO", "");
	setControlValue("CCI_AccInc", "");
	setControlValue("CCI_CT", "");
	setControlValue("CCI_CAPS_GENSTAT", "");
	setControlValue("CCI_ELITECUSTNO", "");
}

function clearAndLockFields(paramString)
{
	setControlValue("request_type", "");

	if (paramString == "CRWORK INTRODUCTION")
	{
		clearAndLockCRFrm();
	}
	else if (paramString == "SSCWORK INTRODUCTION")
	{
		clearAndLockSSCFrm();
	}
	else if (paramString == "CSWORK INTRODUCTION")
	{
		clearAndLockCSFrm();
	}
	else if (paramString == "CDRWORK INTRODUCTION")
	{
		clearAndLockCDRFrm();
	}
	else if (paramString == "ECRWORK INTRODUCTION")
	{
		clearAndLockECRFrm();
	}
	else if (paramString == "CUWORK INTRODUCTION")
	{
		clearAndLockCCUFrm();
	}
	else if (paramString == "TDWORK INTRODUCTION")
	{
		clearAndLockTDFrm();
	}
	else if (paramString == "CLIWORK INTRODUCTION")
	{
		clearAndLockCLIFrm();
	}
	else if (paramString == "CSIWORK INTRODUCTION")
	{
		clearAndLockCISFrm();
	}
	else if (paramString == "RIPWORK INTRODUCTION")
	{
		clearAndLockRIPFrm();
	}
}


function clearAndLockCRFrm()
{
	setControlValue("oth_cr_DC", "");
	setControlValue("oth_cr_RR", "");
	setControlValue("CR_BRANCH", "");
	setControlValue("oth_cr_BN", "");
	setControlValue("oth_cr_reason", "");
	setStyle("CR_BRANCH","disable","true");
	setControlValue("oth_cr_OPS", "");
	setStyle("oth_cr_OPS","disable","true");
}
 
function clearAndLockSSCFrm()
{
	setControlValue("oth_ssc_SCNo", "");
	setControlValue("oth_ssc_Amount", "");
	setControlValue("oth_ssc_Amount_Text", "");
	setControlValue("oth_ssc_RR", "");
}

function clearAndLockCSFrm()
{
	setControlValue("oth_cs_CS", "");
	setControlValue("oth_cs_CSR_Check", "False");
	setStyle("oth_cs_CSR_Check","disable","true");
	setControlValue("oth_cs_CSR", "");
	setControlValue("oth_cs_RR", "");
	setControlValue("oth_cs_Amount_Text", "");
	setStyle("oth_cs_Amount_Text","disable","true");
	setControlValue("oth_cs_Amount", "");
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
	setControlValue("oth_ecr_RB", "");
	setControlValue("oth_ecr_DT", "");
	setControlValue("oth_ecr_RR", "");
	setControlValue("ECR_BRANCH", "");
	setControlValue("oth_ecr_bn", "");
	setStyle("ECR_BRANCH","disable","true");
}

function clearAndLockCCUFrm()
{
   setControlValue("oth_cu_RR", "");
}

function clearAndLockTDFrm()
{
	setControlValue("oth_td_Amount_Text", "");
	setControlValue("oth_td_Amount", "");
	setControlValue("oth_td_RR", "");
	setControlValue("oth_td_RNO", "");
}

function clearAndLockCLIFrm()
{
	setControlValue("oth_cli_RR", "");
	setControlValue("oth_cli_type", "");
	setControlValue("oth_cli_months", "");
	setStyle("oth_cli_months","disable","true");
}

function clearAndLockCISFrm()
{
	setControlValue("oth_csi_CSID_Check", "False");
	setControlValue("oth_csi_CSID", "");
	setControlValue("oth_csi_CSIP_Check", "False");
	setControlValue("oth_csi_CSIP", "");
	setControlValue("oth_csi_PH_Check", "False");
	setControlValue("oth_csi_PH", "");
	setControlValue("oth_csi_CDACNo_Check", "False");
	setControlValue("oth_csi_CDACNO", "");
	setControlValue("oth_csi_RR", "");
	setControlValue("oth_csi_ND", "");
	setStyle("oth_csi_ND","disable","true");
	setControlValue("oth_csi_AccNo", "");
	setStyle("oth_csi_AccNo","disable","true");
	setControlValue("oth_csi_POSTMTB", "");
	setStyle("oth_csi_POSTMTB","disable","true");
	setControlValue("oth_csi_NOM", "");
	setStyle("oth_csi_NOM","disable","true");
	setControlValue("oth_csi_TOH", "");
	setStyle("oth_csi_TOH","disable","true");
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