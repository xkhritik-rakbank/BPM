
/*function enableDisableRejectReasons()
{
	if(getValue("DECISION").indexOf("Reject")!=-1 || getValue("DECISION").indexOf("Failure")!=-1)
	{
		setStyle("REJECT_REASON_GRID","visible","true");
	}
	else
	{
		setStyle("REJECT_REASON_GRID","visible","false");
		clearTable("REJECT_REASON_GRID",true);
	}
}*/

/* function CreditCardonchange()
{
	setValue("CCI_CrdtCN", getValue("CreditCardNo1").replaceAll("-", ""));
	alert("oncahnge");
} */

function executeChangeEvent(controlName)
{
	if (controlName=="Cards_Decision"){
		setStyle('Cards_Reject','visible','false');
		setStyle('Cards_Rework','visible','false');
		setValues({"Cards_Rework":""},true);
		setValues({"Cards_Reject":""},true);
		setStyle("Others_Reject_Reasons","visible","false");
		setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","visible","false");
		setValues({"Others_Reject_Reasons":""},true);
		setValues({"USR_0_CSR_BT_CARDS_SUB_REJECT":""},true);
		setStyle('Cards_Rework','mandatory','false');
		setStyle('Cards_Reject','mandatory','false');
	if(getValue("Cards_Decision") == 'CARDS_D'){
		setStyle('Cards_Reject','visible','true');
		setStyle('Cards_Reject','mandatory','true');
	} else if(getValue("Cards_Decision") == 'CARDS_BR'){
		setStyle('Cards_Rework','visible','true');
		setStyle('Cards_Rework','mandatory','true');
	}
	}
	if(controlName=="Pending_Decision"){
		setValues({"Pending_Reason":""},true);
		setStyle("Others_Pending_Reason","visible","false");
		setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","visible","false");
		setValues({"Others_Pending_Reason":""},true);
		setValues({"USR_0_CSR_BT_PENDING_SUB_REJECT":""},true);
		if(getValue("Pending_Decision") == 'P_Discard'){
		setStyle('Pending_Reason','visible','true');
		setStyle('Pending_Reason','mandatory','true');
		}else{
		setStyle('Pending_Reason','visible','false');
		setStyle('Pending_Reason','mandatory','false');
		}
	}
}
function refreshBttn()
{
	alert("CreditCardNo1 :"+getValue("CreditCardNo1"));
	if(getValue("CreditCardNo1")=='')
	{
		alert("Please enter credit card no");
		setFocus("CreditCardNo1");
		return false;
	}
	if(getValue("CreditCardNo1").length!=16)
	{
		alert("Please enter Valid credit card no should be 16 digit");
		setFocus("CreditCardNo1");
		return false;
	}
	/*  if(getValue("CreditCardNo1")!='' && getValue("CCI_CName")!='')
	{
		setValue("CCI_CrdtCN","");
		setValue("CCI_CrdtCN", getValue("CreditCardNo1"));
	}  */
	
	var response=executeServerEvent("Refresh","CLICK","",true);
	alert("response "+response);
	return true;
}

function enableDisableothers()
{
	if(getValue("BTD_OBC_OBN")=='Others')
	{
		setStyle("BTD_OBC_OBNO","disable","false");
	}
	else 
	{
		setStyle("BTD_OBC_OBNO","disable","true");
		setValue("BTD_OBC_OBNO","");
	}	
}

function enableDisablebank()
{
	if(getValue("BTD_OBC_DT")=='Bank')
		{
			setStyle("BTD_OBC_BN","disable","false");
		}
	else 
		{
			setStyle("BTD_OBC_BN","disable","true");
			//setControlValue("BRANCH","");
			setControlValue("BTD_OBC_BN","");
		}
}

function introduceBttn()
{
		setValue("initiateDecision", "BranchApprover");
		
			//this.formObject.RaiseEvent("WFDone");
			completeWorkItem();
}

function pendingBttn()
{	
		setValue("initiateDecision", "Pending");
		
			//this.formObject.RaiseEvent("WFDone");
			completeWorkItem();
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

function rakbankcardchange()
{
//alert("rakbankcardchange");
	var response=executeServerEvent("BTD_RBC_RBCN11","CLICK","",true);
	
	if(getValue("BTD_RBC_RBCN11")!='')
	{
		setValue("BTD_RBC_RBCN1",getValue("BTD_RBC_RBCN11").replace(/-/gi, ''));
	}
	if(response == "Rakbank Card Type L is not allowed!")
	{
	//alert("response "+response);
	setFocus("BTD_RBC_RBCN11");
	}
}
function rakbankcard22change()
{
	//alert("rakbankcard22change");
	var response=executeServerEvent("BTD_RBC_RBCN22","CLICK","",true);
	
	if(getValue("BTD_RBC_RBCN22")!='')
	{
		setValue("BTD_RBC_RBCN2",getValue("BTD_RBC_RBCN22").replace(/-/gi, ''));
	}
	if(response == "Rakbank Card Type L is not allowed!")
	{
	//alert("response "+response);
	setFocus("BTD_RBC_RBCN22");
	}
}


function rakbankcard33change()
{
	//alert("rakbankcard33change");
	var response=executeServerEvent("BTD_RBC_RBCN33","CLICK","",true);
	
	if(getValue("BTD_RBC_RBCN33")!='')
	{
		setValue("BTD_RBC_RBCN3",getValue("BTD_RBC_RBCN33").replace(/-/gi, ''));
	}
	if(response == "Rakbank Card Type L is not allowed!")
	{
	//alert("response "+response);
	setFocus("BTD_RBC_RBCN22");
	}
}

function otherBankCardValidation()
{
//alert("otherBankCardValidation");
	var response=executeServerEvent("BTD_OBC_OBCNO","CLICK","",true);
	if(response == "Invalid Card Number format")
	{
		setFocus("BTD_OBC_OBCNO");
		//alert("response "+response);	
	}
	

}


function tincheckbox()
{
	//var response=executeServerEvent("VD_TINCheck","CLICK","",true);
	//alert("response "+response);
	
			//alert("inside VD_TINCheck ");
			if ( getValue("VD_TIN_Check") == true) {
				setStyle("VD_Oth_Check", "disable", "true");
				setStyle("VD_POBox_Check", "disable", "true");
				setStyle("VD_TELNO_Check", "disable", "true");
				setStyle("VD_PassNo_Check", "disable", "true");
				setStyle("VD_MRT_Check", "disable", "true");
				setStyle("VD_Oth_Check", "disable", "true");
				setStyle("VD_SD_Check", "disable", "true");
				setStyle("VD_EDC_Check", "disable", "true");
				setStyle("VD_StaffId_Check", "disable", "true");
				setStyle("VD_DOB_Check", "disable", "true");
				setStyle("VD_NOSC_Check", "disable", "true");
				
			} else if (getValue("VD_TIN_Check") == false) {
				//alert("inside VD_TINCheck");
				setStyle("VD_Oth_Check", "disable", "true");
				setStyle("VD_POBox_Check", "disable", "true");
				setStyle("VD_TELNO_Check", "disable", "true");
				setStyle("VD_PassNo_Check", "disable", "true");
				setStyle("VD_MRT_Check", "disable", "true");
				setStyle("VD_Oth_Check", "disable", "false");
				setStyle("VD_SD_Check", "disable", "true");
				setStyle("VD_EDC_Check", "disable", "true");
				setStyle("VD_StaffId_Check", "disable", "true");
				setStyle("VD_DOB_Check", "disable", "true");
				setStyle("VD_NOSC_Check", "disable", "true");
				
			}

}

function fourRandom()
{
	if(getValue("VD_MoMaidN_Check")==true)
	{
		//alert("inside VD_Oth ");
		setStyle("VD_Oth_Check","disable","false");
		setStyle("VD_POBox_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_PassNo_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_SD_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_StaffId_Check","disable","false");
		setStyle("VD_DOB_Check","disable","false");
		setStyle("VD_NOSC_Check","disable","false");
	}
	
	else  if (getValue("VD_MoMaidN_Check")==false)
	{
		//alert("inside VD_Oth ");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_SD_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
	}
}

function bttnPrint()
{
	//alert("BttnPrint");
	// below 1 line change made for JIRA PBU-5394
	var Cards_Decision = getValue("Cards_Decision");
			if (Cards_Decision == "")
			{
			setControlValue("Cards_Decision","CARDS_UP");
			saveWorkItem();
			}
	var response=executeServerEvent("BttnPrint","CLICK","",true);
	
	
	//alert("response "+response);
	
			if(response != "")
			{				
				callPrintJSPCSRBT(response);
			}		
	
}

function SetEventValues(CtrId,CtrEvent)
{
	if (CtrEvent =="change")
	{
		//alert("CtrId :"+CtrId);
		if (CtrId == "VD_TIN_Check")
		{
			if(getValue("VD_TIN_Check") == true)
			{
				setValue("VD_TINCheck","Y");
				//setValue("VD_MoMaidN_Check","false");
			}
			else
				setValue("VD_TINCheck","N");
		}
		else if (CtrId == "VD_DOB_Check")
		{
			if(getValue("VD_DOB_Check") == true)
				setValue("VD_DOB","Y");
			else
				setValue("VD_DOB","N");
		}
		else if (CtrId == "VD_StaffId_Check")
		{
			if(getValue("VD_StaffId_Check") == true)
				setValue("VD_StaffId","Y");
			else
				setValue("VD_StaffId","N");
		}
		else if (CtrId == "VD_POBox_Check")
		{
			if(getValue("VD_POBox_Check") == true)
				setValue("VD_POBox","Y");
			else
				setValue("VD_POBox","N");
		}
		else if (CtrId == "VD_PassNo_Check")
		{
			if(getValue("VD_PassNo_Check") == true)
				setValue("VD_PassNo","Y");
			else
				setValue("VD_PassNo","N");
		}
		else if (CtrId == "VD_Oth_Check")
		{
			if(getValue("VD_Oth_Check") == true)
				setValue("VD_Oth","Y");
			else
				setValue("VD_Oth","N");
		}
		else if (CtrId == "VD_MRT_Check")
		{
			if(getValue("VD_MRT_Check") == true)
				setValue("VD_MRT","Y");
			else
				setValue("VD_MRT","N");
		}
		else if (CtrId == "VD_EDC_Check")
		{
			if(getValue("VD_EDC_Check") == true)
				setValue("VD_EDC","Y");
			else
				setValue("VD_EDC","N");
		}
		else if (CtrId == "VD_NOSC_Check")
		{
			if(getValue("VD_NOSC_Check") == true)
				setValue("VD_NOSC","Y");
			else
				setValue("VD_NOSC","N");
		}
		else if (CtrId == "VD_TELNO_Check")
		{
			if(getValue("VD_TELNO_Check") == true)
				setValue("VD_TELNO","Y");
			else
				setValue("VD_TELNO","N");
		}
		else if (CtrId == "VD_SD_Check")
		{
			if(getValue("VD_SD_Check") == true)
				setValue("VD_SD","Y");
			else
				setValue("VD_SD","N");			
		}
		else if (CtrId == "VD_MoMaidN_Check")
		{
			if (getValue("VD_MoMaidN_Check") == true)
			{
				setValue("VD_MoMaidN", "Y");
				setValue("VD_TINCheck", "N");
				setValue("VD_TIN_Check", "false");
			}
			else 
			{
				setValue("VD_MoMaidN_Check", "N");
				clrValidationFrm();
			}
			lockValidationFrm(getValue("VD_MoMaidN_Check"));
		}
	}
}


function lockValidationFrm(paramString)
{
	if (paramString == true)
	{
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","false");
		setStyle("VD_StaffId_Check","disable","false");
		setStyle("VD_POBox_Check","disable","false");
		setStyle("VD_PassNo_Check","disable","false");
		setStyle("VD_Oth_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_NOSC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_SD_Check","disable","false");
	}
	else
	{
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
	}
}
