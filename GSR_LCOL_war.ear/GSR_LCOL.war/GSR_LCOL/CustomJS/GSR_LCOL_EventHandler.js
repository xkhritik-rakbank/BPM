function SetEventValues(CtrId,CtrEvent)
{
	if (CtrEvent =="change")
	{
		if (CtrId == "MOBILENO")
		{
		    var str = getValue("MOBILENO").replaceAll("\\+", "");
			if (str.length() > 7)
				setControlValue("MOBILENP", str.substring(str3.length() - 7));
			else
				setControlValue("MOBILENP", str);
		}
		else if (CtrId == "LANDLINENO")
		{
		    var str = getValue("LANDLINENO").replaceAll("\\+", "");
			if (str.length() > 7)
				setControlValue("LANDLINENP", str.substring(str3.length() - 7));
			else
				setControlValue("LANDLINENP", str);
		}
	/*	else if (getValue("CHAMOUNT"))
		{
			setControlValue("AMOUNT", getValue("CHAMOUNT").replaceAll(",", ""));
		} */
		else if (CtrId == "BADecision")
		{
			if (getValue("BADecision") == "Discard")
				setStyle("BAREASONFOPDECLINE","disable","false");			
			else
			{
				setControlValue("BAREASONFOPDECLINE", "");
				setStyle("BAREASONFOPDECLINE","disable","true");
			}
		}
		else if (CtrId == "CHARGESTOBERECFROM")
		{
			if (getValue("CHARGESTOBERECFROM") == "A/C Debit")
				setStyle("DEBITACCOUNT","disable","false");			
			else
			{
				setControlValue("DEBITACCOUNT", "");
				setStyle("DEBITACCOUNT","disable","true");
			}
		}
		else if (CtrId == "EC1")
		{
			setControlValue("PL_EC1",getValue("EC1"));
		}
		else if (CtrId == "EC2")
		{
			setControlValue("PL_EC2",getValue("EC2"));
		}
		else if (CtrId == "EC3")
		{
			setControlValue("PL_EC3",getValue("EC3"));
		}
	
		
	}	
	// For Click Event
	else if (CtrEvent =="click")
	{
		if (CtrId == "Print")
		{
		    callPrintJSPGSRLCOL();
				
        }
		else if (CtrId=="Introduce")
	    {
		   completeWorkItem();
		}
		else if (CtrId=="Refresh")
	    {
		   fetchLoanDetails();
		   commandFunctionality(ActivityName);			
		}
		else if (CtrId =="BtnOK")
		{
			fetchLoanDetails();
			commandFunctionality(ActivityName);			
		}
		else if (CtrId =="Command2")
		{
			completeWorkItem();		
		}
		else if (CtrId =="ClearAll")
		{
			clrPLESFrm();		
		}
	
	}
	
}
function commandFunctionality(ActivityName)
{
    setControlValue("PL_EC11","Error during connecting to Queue Manager.");
	setControlValue("PL_EC22","MQRC_Q_MGR_NOT_AVAILABLE :");
	//setControlValue("LoggedInUser","Logged in As: " +   user);
	
	if(ActivityName=="CROPS")
	{
		setControlValue("ACTION", "");
		setControlValue("EC1", "");
		setControlValue("EC2", "");
		setControlValue("EC3", "");
	}
	if(ActivityName=="Branch_Approver")
	{
		setControlValue("BADecision", "");
		setControlValue("BAREASONFOPDECLINE", "");
		
	}
	
}								

function clrPLESFrm()
{
	setControlValue("NETSETTLEAMT", "");
	setControlValue("AMOUNTRECEIVED", "");
	setControlValue("SETTLEMENTFEE", "");
	setControlValue("CHARGESRECEIVED", "");
	setControlValue("MODEOFPAYMENT", "");
	setControlValue("REASON", "");
	setControlValue("TAKEOVERBYOOTHERBANK", "");
	setControlValue("LANDLINENP", "");
	setControlValue("LANDLINENO", "");
	setControlValue("ISSUENOLIABILITYLETTER", "");
	setControlValue("EARLYSETTLEMENTREASON", "");
	setControlValue("MOBILENO", "");
	setControlValue("MOBILENP", "");
	setControlValue("WAIVEROFESFEESAPPBY", "");
	setControlValue("SETTLEMENTFEEPERCENT", "");
	setControlValue("NOTES", "");
	setControlValue("DEBITACCOUNT", "");
}

function setFrameLoanError(activityname)
{
	if (ActivityName=="Work Introduction")
	{
	    setStyle("Loan_Details_Section","visible","true");
		setStyle("Request_Details_Section","visible","true");
		setStyle("Frame2","visible","true");
	}
	else if (ActivityName=="Branch_Approver")
	{
	    setStyle("Loan_Details_Section","visible","true");
		setStyle("Request_Details_Section","visible","true");
		setStyle("Branch_Approver_Section","visible","true");
	}
	else if (ActivityName=="Branch_Return")
	{
	    setStyle("Loan_Details_Section","visible","true");
		setStyle("Request_Details_Section","visible","true");
		setStyle("Branch_Approver_Section","visible","true");
	}
	else if (ActivityName=="CROPS")
	{
	    setStyle("Loan_Details_Section","visible","true");
		setStyle("Request_Details_Section","visible","true");
		setStyle("Crops_Section","visible","true");
	}
}	
function fetchLoanDetails()
{
    if(getValue("AGREEMENTNO")=="")
	{
	    showMessage("AGREEMENTNO", "Enter Agreement Number!","error");
		setFocus("AGREEMENTNO");
		return false;
	}
	if(getValue("AGREEMENTNO").length!=8)
	{
	    showMessage("AGREEMENTNO", "Agreement No. should be of length 8 digits","error");
		setFocus("AGREEMENTNO");
		setControlValue("AGREEMENTNO", "");
		return false;
	}
	var Response = executeServerEvent("AgreementNum","Click","",true);
	if(Response != "false")
	{
	  setStyle("Error_Code_Section","visible","true");
	}
	
}
function callPrintJSPGSRLCOL()
{
	
	var strUrl="/GSR_LCOL/GSR_LCOL/CustomJSP/GSR_LCOL_LC.jsp?";
	//alert("params :"+params+" strUrl :"+strUrl);
	//window.open(strUrl);
	var sOptions = 'dialogWidth:1300px; dialogHeight:600px; dialogLeft:450px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
					
	//var popupWindow = window.open(strUrl, null, sOptions);
	var popupWindow = window.showModalDialog(strUrl, null, sOptions);
	
}
