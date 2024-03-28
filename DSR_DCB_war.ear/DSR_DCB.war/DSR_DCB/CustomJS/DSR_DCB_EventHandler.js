function SetEventValues(CtrId,CtrEvent)
{
	if (CtrEvent =="change")
	{
		//alert("CtrId :"+CtrId);
		if (CtrId == "VD_TIN_Check")
		{
			if(getValue("VD_TIN_Check") == true)
			{
				setControlValue("VD_TINCheck","Y");
				//setControlValue("VD_Oth_Check","false");
			}
			else
			{
				setControlValue("VD_TINCheck","N");
				//setControlValue(VD_Oth_Check);
				//setStyle("VD_Oth_Check","disable","false");
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
		else if (CtrId == "VD_MoMaidN_Check")
		{
			if(getValue("VD_MoMaidN_Check") == true)
			{
				setControlValue("VD_MoMaidN","Y");
			}
			else
			{
				setControlValue("VD_MoMaidN","N");
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
		else if (CtrId =="REASON_HOTLIST")
		{
			//lockHotlistFrm();
			//lockHotlistFrm(ControlValue);
			lockHotlistFrm(getValue("REASON_HOTLIST"));
		}
		else if (CtrId =="ACTION_TAKEN")
		{
			//lockReplaceReqFrm();
			//lockReplaceReqFrm(ControlValue);
			lockReplaceReqFrm(getValue("ACTION_TAKEN"));
		}
		else if (CtrId =="DELIVER_TO")
		{
			if (getValue("DELIVER_TO") == 'Branch')
			{
				setStyle("BRANCH_NAME","disable" ,"false");
				//setControlValue("DELIVER_TO", "Branch");
			}
			else
			{
				//setControlValue("BRANCH", "");
				setControlValue("BRANCH_NAME", "");
				setStyle("BRANCH_NAME","disable","true");
				//setControlValue("DELIVER_TO", getValue("DELIVER_TO"));
			}			
		}
		/*else if (CtrId =="BRANCH_NAME")
		{
			setControlValue("BRANCH_NAME",getValue("BRANCH_NAME"));
		}*/
		
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
			
			var Response = executeServerEvent("PrintButton","Click","",true);
			// below 1 line change made for JIRA PBU-5394
			setControlValue("Cards_Decision","CARDS_UP");
	
			//alert("response "+Response);	
            if(Response != "")
			{				
				callPrintJSPDSRDCB(Response);
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
			
			setValue("VD_Oth_Check","false");
			setValue("VD_TIN_Check","false");
			setValue("VD_Oth","N");
			setValue("VD_TINCheck","N");
		
			clrValidationFrm();
			setControlValue("REASON_HOTLIST", "");
			clrHotlistFrm();
			setControlValue("REMARKS", "");
			setControlValue("ACTION_TAKEN", "");
			clrReplaceReqFrm();
			
			//setStyle("baseFr2", "visible", "false");
			setStyle("Frame2", "visible", "false");
			setStyle("Frame1", "visible", "false");
			
		} 
	}
}

function fetchCardData()
{
	//alert("DCB fetchCardData");

	if(getValue("DCI_DebitCN")=='')//1
	{
		//alert("Please enter Debit card no");
		setFocus("DCI_DebitCN");//2
		return false;
	}
	if(getValue("DCI_DebitCN").length!=16)//3
	{
		//alert("Please enter Valid Debit card no should be 16 digit");
		setFocus("DCI_DebitCN"); //4
		return false;
	}
	
	var Response = executeServerEvent("CAPSMAIN_Query","Click","",true);
	//alert("Response :"+Response);	
	if (Response!= "false")
	{
		setStyle("baseFr2","visible","true");
		setStyle("baseFr3","visible","true");
		setStyle("BAFrm","visible","false");
		setStyle("Frame1","visible","true");
		setStyle("Frame2","visible","true");
		setStyle("CardsFrm","visible","false");
		
		lockCAPSFrm();

		setFocus("DCI_ExtNo");
	}
	else if(Response == "false")
	{
		showMessage("DCI_DebitCN", "Invalid Debit Card No. Format","error");
		setFocus("DCI_DebitCN"); // 5,6
		return false;
	}
	else
	{
		showMessage("DCI_DebitCN", "Customer Not Found!","error");
		setFocus("DCI_DebitCN"); //7,8
		return false;
	}
	
}

/*function tinCheckDisable()
{
			alert(" tincheck response start "+response);
			var response=executeServerEvent("VD_TINCheck","Click","",true);
			alert(" tincheck response "+response);
	
			
			if ( getValue("VD_TINCheck") == true) 
			{
				alert("inside VD_TINCheck if true");
				setStyle("VD_MoMaidN", "disable", "false");
				setStyle("VD_POBox", "disable", "false");
				setStyle("VD_TELNO", "disable", "false");
				setStyle("VD_PassNo", "disable", "false");
				setStyle("VD_MRT", "disable", "false");
				setStyle("VD_Oth", "disable", "false");
				setStyle("VD_SD", "disable", "false");
				setStyle("VD_EDC", "disable", "false");
				setStyle("VD_StaffId", "disable", "false");
				setStyle("VD_DOB", "disable", "false");
				setStyle("VD_NOSC", "disable", "false");
				
			} 
			else if (getValue("VD_TINCheck") == false) {
				alert("inside VD_TINCheck if false");
				setStyle("VD_MoMaidN", "disable", "true");
				setStyle("VD_POBox", "disable", "true");
				setStyle("VD_TELNO", "disable", "true");
				setStyle("VD_PassNo", "disable", "true");
				setStyle("VD_MRT", "disable", "true");
				setStyle("VD_Oth", "disable", "true");
				setStyle("VD_SD", "disable", "true");
				setStyle("VD_EDC", "disable", "true");
				setStyle("VD_StaffId", "disable", "true");
				setStyle("VD_DOB", "disable", "true");
				setStyle("VD_NOSC", "disable", "true");
				
			}  

}*/