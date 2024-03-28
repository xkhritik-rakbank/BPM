function SetEventValues(CtrId,CtrEvent)
{
	
	if (CtrEvent =="change")
	{
		if (CtrId == "Cards_Decision"){
			setStyle("Cards_Rework","visible","false");
			setStyle("Cards_Reject","visible","false");
			setStyle("Cards_Rework","mandatory","false");
			setStyle("Cards_Reject","mandatory","false");
			if(getValue("Cards_Decision") == "CARDS_BR"){
				setStyle("Cards_Rework","visible","true");
				setStyle("Cards_Rework","mandatory","true");
			}else if (getValue("Cards_Decision") == "CARDS_D"){
				setStyle("Cards_Reject","visible","true");
				setStyle("Cards_Reject","mandatory","true");
			}
			//added by stutee.mishra	
			var REQUEST_TYPE = getValue("CCI_REQUESTTYPE");
			if (REQUEST_TYPE =="STATEMENT DATE CHANGE" && getValue("Cards_Decision") == "Deferred"){
				setStyle("StatementDateChange","mandatory","true");
			}else{
				setStyle("StatementDateChange","mandatory","false");
			}
			//end.
		}
		else if (CtrId == "Cards_IsSRO_0"){
			setStyle("Cards_STR","visible","true");
			setStyle("Cards_TeamCode","visible","true");
			setStyle("Cards_SRORemarks","visible","true");
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
			setStyle("Pending_Reason","mandatory","false");
			if(getValue("Pending_Decision") == "P_Discard"){
				setStyle("Pending_Reason","visible","true");
				setStyle("Pending_Reason","mandatory","true");
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
		//alert("CtrId :"+CtrId);
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
			var Cards_Decision = getValue("Cards_Decision");
			if (Cards_Decision == ""){
			setControlValue("Cards_Decision","CARDS_UP");
			saveWorkItem();
			}
		   var Response = executeServerEvent("PrintButton","Click","",true);
			// below 1 line change made for JIRA PBU-5394
			
	
			//alert("response "+Response);	
            if(Response != "")
			{				
				callPrintJSPCSRMR(Response);
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
		else if (CtrId =="Exit")
		{
			completeWorkItem();			
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
			setControlValue("REMARKS", "");
			
			setStyle("Credit_Card_Section", "visible", "true");
			setStyle("Verification_Section", "visible", "true");
			//setStyle("RRDFrm", "visible", "false");
			setStyle("Remarks_Section", "visible", "true");
			//setStyle("Frame2", "visible", "false");
			setStyle("Buttons_Section", "visible", "false");
		    setStyle("Pending_Section", "visible", "false");
			setStyle("Cards_Section", "visible", "false");
			setStyle("Print_Section", "visible", "false");
			setStyle("Branch_Section", "visible", "false");
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
function fetchCardData() 
{
	alert("MR fetchCardData");
	
/*	if (getValue("CCI_CrdtCN") == "")
	{
		showMessage("CardNo", "Enter Credit Card Number!","error");
		setFocus("CardNo");
		return false;
	} 
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
	}  */
	if(getValue("CCI_CrdtCN")=='')
	{
		alert("Please enter credit card no");
		setFocus("CCI_CrdtCN");
		return false;
	}
	if(getValue("CCI_CrdtCN").length!=16)
	{
		alert("Please enter Valid credit card no should be 16 digit");
		setFocus("CCI_CrdtCN");
		return false;
	} 
	
	var Response = executeServerEvent("CAPSMAIN_Query","Click","",true);
	alert("Response :"+Response);	
	if (Response!= "false")
	{
		setStyle("baseFr2","visible","true");
		setStyle("baseFr3","visible","true");
		setStyle("RRDFrm","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("Frame2","visible","true");
		
		lockCAPSFrm();

		setFocus("CCI_ExtNo");
	}
	else if(Response == "false")
	{
		showMessage("CardNo", "Invalid Credit Card No. Format","error");
		setFocus("CardNo");
		return false;
	}
	else
	{
		showMessage("CardNo", "Customer Not Found!","error");
		setFocus("CardNo");
		return false;
	}
	
}
