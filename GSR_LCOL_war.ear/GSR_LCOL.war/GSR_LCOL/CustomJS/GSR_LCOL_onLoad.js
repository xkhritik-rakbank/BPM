var Common = document.createElement('script');
Common.src = '/GSR_LCOL/GSR_LCOL/CustomJS/GSR_LCOL_Common.js';
document.head.appendChild(Common);

function enableDisableAfterFormLoad()
{
	if (ActivityName =="Work Introduction")
    {
	   lockLoanDetails();
		
		if(getValue("AGREEMENTNO")=="")
		{
		    setStyle("Loan_Details_Section","visible","false");
			setStyle("Request_Details_Section","visible","false");
			setStyle("Buttons_Section","visible","false");
			
		}
		
	}
	
   else if (ActivityName == "CROPS")
	{
		//setStyle("AGREEMENTNO","disable","false");
	    setStyle("BADecision","disable","true");
	    setStyle("BAREASONFOPDECLINE","disable","true");
	    setValue("CROPSUSERNAME",user);
	    setValue("Crops_Decision","");
	    setValue("Crops_Remarks","");
	    //setControlValue("CROPSDATETIME",getValue("BranchApproverEntryDate"));
		setStyle("BtnOK","visible","false");
		setStyle("Command2","visible","false");
		setStyle("Refresh","visible","true");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Crops_Section","visible","true");
		setStyle("Print","visible","true");
		setStyle("Introduce","visible","false");
		setStyle("ClearAll","visible","false");
		
		lockLoanDetails();
		setErrorCode();
        setDisableFields();
        hideFrames(ActivityName);
		
		setStyle("Error_Code_Section","visible","false"); 

		setStyle("Request_Details_Section","disable","true");
		setStyle("Branch_Approver_Section","disable","true");
		
	}
			
	else if (ActivityName == "Branch_Return")
	{
		//setStyle("AGREEMENTNO","disable","true");
	    setStyle("BADecision","disable","true");
	    setStyle("BAREASONFOPDECLINE","disable","true");
	    setStyle("ACTION","disable","true");
		setStyle("BtnOK","visible","false");
		setStyle("Command2","visible","false");
		setStyle("Buttons_Section","visible","false");
		setStyle("Print_Section","visible","false");
		setStyle("Crops_Section","visible","false");
	    
		lockLoanDetails();
        hideFrames(ActivityName);
		
		setStyle("Error_Code_Section","visible","false"); // error code section
		
		
		setStyle("Crops_Section","disable","true");
		setStyle("Branch_Approver_Section","disable","true");
		
	}
	else if (ActivityName == "Branch_Approver")
	{
		//setStyle("AGREEMENTNO","disable","true");
		setControlValue("BAUserName",user);
		setControlValue("BADecision","");
		setControlValue("BAREASONFOPDECLINE","");
		
	    //setControlValue("BranchApproverDate",getValue("BU_DateTime"));
	    setStyle("BAREASONFOPDECLINE","disable","true");
	    
	  /*  setControlValue("NETSETTLEAMT",getValue("AMOUNTRECEIVED"));
	    setControlValue("SETTLEMENTFEE",getValue("CHARGESRECEIVED"));  */
	   
	    setStyle("NETSETTLEAMT","disable","true");
		setStyle("SETTLEMENTFEE","disable","true");
		
		setStyle("BtnOK","visible","false");
		setStyle("Command2","visible","false");
		
		lockLoanDetails();
		setDisableFields();
		hideFrames(ActivityName);
		
		setStyle("Error_Code_Section","visible","false");
		setStyle("Crops_Section","visible","false");
		setStyle("Buttons_Section","visible","false");
		setStyle("Print_Section","visible","false");
	
		setStyle("Request_Details_Section","disable","true");
		setStyle("Crops_Section","disable","true");
			
	}
	else if ((ActivityName == "Work Exit1") || (ActivityName == "Discard1") || (ActivityName == "Query"))
	{
		//setStyle("AGREEMENTNO","disable","true");
		lockLoanDetails();
		setDisableFields();
		
		setStyle("BtnOK","visible","false");
		setStyle("Command2","visible","false");
   
		setStyle("Request_Details_Section","disable","true");
		setStyle("Crops_Section","disable","true");
		setStyle("Loan_Details_Section","disable","true");
		setStyle("Branch_Approver_Section","disable","true");
		
	}
	setAmountOnLOad("AMOUNTRECEIVED", "NETSETTLEAMT");
    setAmountOnLOad("CHARGESRECEIVED", "SETTLEMENTFEE");
}

function lockLoanDetails() 
{
	setStyle("EQUATIONLOANACCNO","disable","true");
	setStyle("CUSTOMERNAME","disable","true");
	setStyle("NPASTAGE","disable","true");
	setStyle("OUTSTANDINGLOANAMT","disable","true");
	setStyle("NEXTINSTAMT","disable","true");
	setStyle("TENOR","disable","true");
	setStyle("TOTALPOSTDUES","disable","true");
	setStyle("PRODUCTORSCHEME","disable","true");
	setStyle("APPLOANAMT","disable","true");
	setStyle("INTERESTRATE","disable","true");
	setStyle("CHARGESPOSTDUES","disable","true");
	setStyle("NEXTINSTDATE","disable","true");
	setStyle("REPAYMENTMODE","disable","true");
	setStyle("FUNDINGACNO","disable","true");
	setStyle("LOANMATURITYDATE","disable","true");
	setStyle("BUCKET","disable","true");
	setStyle("DELINQUENCY","disable","true");
	
	
}
function setDisableFields() 
{
	
	setStyle("CERTIFICATETYPE","disable","true");
	setStyle("ADDRESSEDTONAME","disable","true");
	setStyle("LANGUAGE","disable","true");
	setStyle("CHAMOUNT","disable","true");
	setStyle("CUSTOMERTYPE","disable","true");
	setStyle("DEBITACCOUNT","disable","true");
	setStyle("LANDLINENO","disable","true");
	
	setStyle("MOBILENO","disable","true");
	setStyle("CHARGESTOBERECFROM","disable","true");
	setStyle("RETENTIONOFPRODUCT","disable","true");
	setStyle("AMOUNT","disable","true");
	setStyle("NOTES","disable","true");
	setStyle("BAREASONFOPDECLINE","disable","true");
	
}

function hideFrames(ActivityName)
{
	if (ActivityName=="Branch_Return")
	{
	   if (getValue("BADecision")!="")
        {
            setStyle("Branch_Approver_Section","visible","true");
			setStyle("BADecision","disable","true");
			setStyle("BAREASONFOPDECLINE","disable","true");
        }
		else
		{
		    setStyle("Branch_Approver_Section","visible","false");  
		}	
		if (getValue("ACTION")!="")
        {
            setStyle("Crops_Section","visible","true");
			setStyle("ACTION","disable","true");
			//setStyle("Text2","disable","true");
			setStyle("EC1","disable","true");
			setStyle("EC2","disable","true");
			setStyle("EC3","disable","true");
        }
		else
		{ 
		    setStyle("Crops_Section","visible","false");
		}

	}
	if (ActivityName=="Branch_Approver")
	{
	   if (getValue("ACTION")!="")
        {
            setStyle("Crops_Section","visible","true");
			setStyle("ACTION","disable","true");
			//setStyle("Text2","disable","true");
			setStyle("EC1","disable","true");
			setStyle("EC2","disable","true");
			setStyle("EC3","disable","true");
        }
		else
		{
		    setStyle("Crops_Section","visible","false");
		}

	}
	if (ActivityName=="CROPS")
	{
	   if (getValue("BADecision")!="")
        {
            setStyle("Branch_Approver_Section","visible","true");
			setStyle("BADecision","disable","true");
			setStyle("BAREASONFOPDECLINE","disable","true");
			
        }
		else
		{
		    setStyle("Branch_Approver_Section","visible","false");
		}

	}
}
function setAmountOnLOad(paramString1,paramString2) 
{
	var str1 = getValue(paramString1);
	var str2 = ".00";

	if (str1.length > 0)
	{
		if (str1.indexOf(".") > -1)
		{
			str2 = str1.substring(str1.indexOf("."));
			str1 = str1.substring(0, str1.indexOf("."));
		}
		if (str1.length == 4)
		{
			str1 = str1.substring(0, 1) + "," + str1.substring(1) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 5)
		{
			str1 = str1.substring(0, 2) + "," + str1.substring(2) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 6)
		{
			str1 = str1.substring(0, 3) + "," + str1.substring(3) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 7)
		{
			str1 = str1.substring(0, 1) + "," + str1.substring(1, 4) + "," + str1.substring(4) + str2;
			setControlValue(paramString2, str1);
		}
		else if (str1.length == 8)
		{
			str1 = str1.substring(0, 2) + "," + str1.substring(2, 5) + "," + str1.substring(5) + str2;
			setControlValue(paramString2, str1);
		}
		setControlValue(paramString2, str1);
	}
}
function setErrorCode()
{
    setControlValue("PL_EC1", getValue("EC1"));
    setControlValue("PL_EC2", getValue("EC2"));
    setControlValue("PL_EC3", getValue("EC3"));
}
