
function enableDisableRejectReasons() // ff
{
	/*if(getValue("DECISION").indexOf("Reject")!=-1 || getValue("DECISION").indexOf("Failure")!=-1)
	{
		setStyle("REJECT_REASON_GRID","visible","true");
	}
	else
	{
		setStyle("REJECT_REASON_GRID","visible","false");
		clearTable("REJECT_REASON_GRID",true);
	}*/
	return true;
	
}

function SetFieldValues(CtrId,CtrEvent)
{
	//alert("CtrEvent :"+CtrEvent);
	//alert("CtrId :"+CtrId);
	
	if (CtrEvent =="change")
	{
		if (CtrId == "CardNo")
		{
			var cardnum=getValue("CardNo");
			var cardnumfinal = cardnum.replace(/-/gi, '');
			setControlValue("CCI_CrdtCN",cardnumfinal);
		}
		else if (CtrId =="CHQ_AMOUNT1")
		{
			setControlValue("CSR_CCC_CHQ_AMOUNT1",CtrId);
		}
		else if (CtrId =="CHQ_AMOUNT2")
		{
			setControlValue("CSR_CCC_CHQ_AMOUNT2",CtrId);
		}
		else if (CtrId =="CHQ_AMOUNT3")
		{
			setControlValue("CSR_CCC_CHQ_AMOUNT3",CtrId);
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
		else if (CtrId == "VD_MoMaidN_Check")
		{
			if(getValue("VD_MoMaidN_Check") == true)
				setControlValue("VD_MoMaidN","Y");
			else
				setControlValue("VD_MoMaidN","N");
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
		else if (CtrId == "VD_Oth_Check")
		{
			if (getValue("VD_Oth_Check") == true)
			{
				setControlValue("VD_Oth", "Y");
				setControlValue("VD_TINCheck", "N");
				setControlValue("VD_TIN_Check", "false");
			}
			else 
			{
				setControlValue("VD_Oth", "N");
				clrValidationFrm();
			}
			lockValidationFrm(getValue("VD_Oth_Check"));
		}	
	}
	
	else if (CtrEvent =="click")
	{
	    if (CtrId == "Introduce")
		{
			setControlValue("initiateDecision", "BranchApprover");
			
			
		}
		else if (CtrId == "Pending")
		{
			setControlValue("initiateDecision", "Pending");
						
		}
		else if (CtrId == "Print")
		{
            /* if (getValue("Cards_Decision") == "")
				setControlValue("Cards_Decision", "Under Process");
			
			if (getValue("Cards_Decision") == "CARDS_E")
				setControlValue("Cards_Decision", "Complete");
			else if (getValue("Combo_CA_Dec") == "CARDS_D")
				setControlValue("Cards_Decision", "Discard");
			else if (getValue("Combo_CA_Dec") == "CARDS_UP")
				setControlValue("Cards_Decision", "Under Process");
			else 
				setControlValue("Cards_Decision", "Return To B");*/	
			
			
			// below 1 line change made for JIRA PBU-5394
			var Cards_Decision = getValue("Cards_Decision");
			if (Cards_Decision == ""){
			setControlValue("Cards_Decision","CARDS_UP");
			saveWorkItem();
			}
			var Response = executeServerEvent("PrintButton","Click","",true);
	
			//alert("Response :"+Response);
			if(Response != "false")
			{				
				callPrintJSPCSRCCC(Response);
			}
        }
		
		else if (CtrId =="Refresh")
		{
			fetchCardData(ActivityName);	
						
		}
		
	}	
	
}


// function refreshBtnClick()
// {
	// var str = getValue("CSR_CCC_CCI_CrdtCN");
	// if(getValue("CSR_CCC_CCI_CrdtCN")=='')
	// {
		// alert("Enter Credit Card Number!");
		// return false;
	// }
	
	// if(getValue("CSR_CCC_CCI_CrdtCN").length!=16)
	// {
		// alert("Invalid Credit Card Number Format");
		// return false;
	// }
	// var response=executeServerEvent("Refresh","CLICK","",true);
	// alert("response "+response);
	// return true;
// }


function enableDisableBranchName()
{
	if(getValue("CSR_CCC_DELIVERTO")!=null && getValue("CSR_CCC_DELIVERTO")=='Bank')
	{
		setStyle("BRANCH","disable","false");
	}
	else 
	{
		setStyle("BRANCH","disable","true");
		
	}
}

function checkAmountApproval1() //ccc
{
	if(getValue("CARD1")!=null && getValue("CARD1")!="")
	{
		setStyle("CHQ_AMOUNT1","disable","false");
		setStyle("ApprovalCode1","disable","false");
		
	}
	else
	{
	    setStyle("CHQ_AMOUNT1","disable","true");
		setStyle("ApprovalCode1","disable","true");
	}
	
}
function checkAmountApproval2()
{
	if(getValue("CARD2")!=null && getValue("CARD2")!="")
	{
		setStyle("CHQ_AMOUNT2","disable","false");
		setStyle("Approvalcode2","disable","false");
		
	}
	else
	{
	    setStyle("CHQ_AMOUNT2","disable","true");
		setStyle("ApprovalCode2","disable","true");
	}
	
}

function checkAmountApproval3()
{
	if(getValue("CARD3")!=null && getValue("CARD3")!="")
	{
		setStyle("CHQ_AMOUNT3","disable","false");
		setStyle("ApprovalCode3","disable","false");
		
	}
	else
	{
	    setStyle("CHQ_AMOUNT2","disable","true");
		setStyle("ApprovalCode2","disable","true");
	}
	
}

function enableDisableCheckBox()
{
	if (getValue("VD_Oth")==true)  
	{
		setStyle("VD_TINCHECK","disable","true");
		setStyle("VD_DOB","disable","false");
		setStyle("VD_StaffId","disable","false");
		setStyle("VD_POBox","disable","false");
		setStyle("VD_PassNo","disable","false");
		setStyle("VD_MoMaidN","disable","false");
		setStyle("VD_MRT","disable","false");
		setStyle("VD_EDC","disable","false");
		setStyle("VD_NOSC","disable","false");
		setStyle("VD_TELNO","disable","false");
		setStyle("VD_SD","disable","false");
			
	}	
	else
	{
		setStyle("VD_TINCHECK","disable","false");
		setStyle("VD_DOB","disable","true");
		setStyle("VD_StaffId","disable","true");
		setStyle("VD_POBox","disable","true");
		setStyle("VD_PassNo","disable","true");
		setStyle("VD_MoMaidN","disable","true");
		setStyle("VD_MRT","disable","true");
		setStyle("VD_EDC","disable","true");
		setStyle("VD_NOSC","disable","true");
		setStyle("VD_TELNO","disable","true");
		setStyle("VD_SD","disable","true");
		
	}
}

function clearfields()
{
	 setValue("CCI_CName", "");
     setValue("CCI_ExpD", "");
     setValue("CCI_CrdtCN", "");
     setValue("CCI_CCRNNo", "");
     setValue("CCI_MONO", "");
     setValue("CCI_AccInc", "");
     setValue("CCI_CT", "");
     setValue("CCI_CAPS_GENSTAT", "");
     setValue("CCI_ELITECUSTNO", "");
	 alert("Clear the fields from CAPS Fragment");
}



function fourRandom()
{
	 if (getValue("VD_Oth")==false)
	{
		setStyle("VD_MoMaidN","disable","true");
		setStyle("VD_POBox","disable","true");
		setStyle("VD_TELNO","disable","true");
		setStyle("VD_PassNo","disable","true");
		setStyle("VD_MRT","disable","true");
		setStyle("VD_TINCheck","disable","false");
		setStyle("VD_SD","disable","true");
		setStyle("VD_EDC","disable","true");
		setStyle("VD_StaffId","disable","true");
		setStyle("VD_DOB","disable","true");
		setStyle("VD_NOSC","disable","true");
	}
	else if(getValue("VD_Oth")==true)
	{
		setStyle("VD_MoMaidN","disable","false");
		setStyle("VD_POBox","disable","false");
		setStyle("VD_TELNO","disable","false");
		setStyle("VD_PassNo","disable","false");
		setStyle("VD_MRT","disable","false");
		setStyle("VD_TINCheck","disable","true");
		setStyle("VD_SD","disable","false");
		setStyle("VD_EDC","disable","false");
		setStyle("VD_StaffId","disable","false");
		setStyle("VD_DOB","disable","false");
		setStyle("VD_NOSC","disable","false");
	}
}
function onDecisionChange(controlName)
{
	var ActivityName = getWorkItemData("activityName");
	if(ActivityName=='CARDS'){
	if (controlName=="Cards_Decision"){
		setStyle('Cards_Reject','visible','false');
		setStyle('Cards_Rework','visible','false');
		setValues({"Cards_Rework":""},true);
		setValues({"Cards_Reject":""},true);
		setStyle("Others_Reject_Reason","visible","false");
		setStyle("USR_0_CSR_CCC_REJECT_SUB_REASON","visible","false");
		setValues({"Others_Reject_Reason":""},true);
		setValues({"USR_0_CSR_CCC_REJECT_SUB_REASON":""},true);
		setStyle('Cards_Reject','mandatory','false');
		setStyle('Cards_Rework','mandatory','false');
		if(getValue("Cards_Decision") == 'CARDS_D'){
		setStyle('Cards_Reject','visible','true');
		setStyle('Cards_Reject','mandatory','true');
	} 	else if(getValue("Cards_Decision") == 'CARDS_BR'){
		setStyle('Cards_Rework','visible','true');
		setStyle('Cards_Rework','mandatory','true');
	}
	}
}
	else if(ActivityName=='Branch_Approver'){
		if (controlName=="BA_Decision"){
		setStyle('BA_Reject','visible','false');
		setValues({"BA_Reject":""},true);
		setStyle("USR_0_CSR_CCC_BA_SUB_REASON","visible","false");
		setStyle("Others_BA","visible","false");
		setValues({"Others_BA":""},true);
		setValues({"USR_0_CSR_CCC_BA_SUB_REASON":""},true);
		if(getValue("BA_Decision") == 'BA_D'){
		setStyle('BA_Reject','visible','true');
		setStyle('BA_Reject','mandatory','true');
	}else{
		setStyle('BA_Reject','visible','false');
		setStyle('BA_Reject','mandatory','false');
		}
	}
	}
	else if(ActivityName=='Pending'){
		if (controlName=="Pending_Decision"){
		setStyle('Pending_Reason','visible','false');
		setValues({"Pending_Reason":""},true);
		setStyle("Others_Pending_SubReason","visible","false");
		setStyle("USR_0_CSR_CCC_PENDING_SUB","visible","false");
		setValues({"Others_Pending_SubReason":""},true);
		setValues({"USR_0_CSR_CCC_PENDING_SUB":""},true);
		if(getValue("Pending_Decision")=='P_Discard'){
		setStyle('Pending_Reason','visible','true');
		setStyle('Pending_Reason','mandatory','true');
		}else{
		setStyle('Pending_Reason','visible','false');
		setStyle('Pending_Reason','mandatory','false');
		}
	}
}
}
