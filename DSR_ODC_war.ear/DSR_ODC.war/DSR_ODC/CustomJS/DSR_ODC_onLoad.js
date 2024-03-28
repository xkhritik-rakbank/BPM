var Common = document.createElement('script');
Common.src = '/DSR_ODC/DSR_ODC/CustomJS/DSR_ODC_Common.js';
document.head.appendChild(Common);


function lockCAPSFrm() 
{
	setStyle("DCI_CName","disable","false");
	setStyle("DCI_ExpD","disable","false");
	setStyle("DCI_DebitCN","disable","false");
	setStyle("DCI_MONO","disable","false");
	setStyle("DCI_CT","disable","false");
	setStyle("DCI_CAPS_GENSTAT","disable","false");
	setStyle("DCI_ELITECUSTNO","disable","false");
}
function hideFrames(Reqtype,ActivityName)
{
	setStyle("Card_Delivery_Section","visible","false");
	setStyle("Transaction_Dispute_Section","visible","false");
	setStyle("Buttons_Section","visible","false");
	setStyle("Early_Card_Section","visible","false");
	setStyle("Card_Replace_Section","visible","false");
	setStyle("Card_Replace_Section","visible","false");
	setStyle("Reissue_Dtls_Section","visible","false");

	if (ActivityName.toUpperCase().indexOf("INTRODUCTION") > -1)
	{
	 setStyle("Buttons_Section","visible","true");
		
	}
	
	if (Reqtype == "Card Replacement")
	{
	   setStyle("Card_Replace_Section","visible","true");
		 //this.formObject.setNGControlTop("CISFrm", j);
	}
	else if (Reqtype == "Card Delivery Request")
	{
	   setStyle("Card_Delivery_Section","visible","true");
		 //this.formObject.setNGControlTop("CISFrm", j);
	}
	else if (Reqtype == "Early Card Renewal")
	{
	   setStyle("Early_Card_Section","visible","true");
		 //this.formObject.setNGControlTop("CISFrm", j);
	}
	else if (Reqtype == "Transaction Dispute")
	{
	   setStyle("Transaction_Dispute_Section","visible","true");
		 //this.formObject.setNGControlTop("CISFrm", j);
	}
	else if (Reqtype == "Re-Issue of PIN")
	{
	   setStyle("Reissue_Dtls_Section","visible","true");
		 //this.formObject.setNGControlTop("CISFrm", j);
	}


	if (ActivityName.toUpperCase().indexOf("INTRODUCTION") != -1)
	{
	 setStyle("Button_Section","visible","true");
	 setStyle("Branch_Return_Details_Section","visible","false");
	}	
	
	else if (ActivityName == "Pending")
	{
		//this.formObject.setNGControlTop("Pendingfrm", j + 4 + i);
	}
	else if (ActivityName == "CARDS")
	{
		//this.formObject.setNGControlTop("CardsFrm", j + 4 + i);
		if ((getValue("BR_Decision") == null) || (getValue("BR_Decision") == ""))
		{
			//this.formObject.setNGControlTop("PrintFrm", j + 4 + i + 4 + 99);
		}
		else 
		{
			//this.formObject.setNGControlTop("BRFrm", j + 4 + i + 4 + 99);
			//this.formObject.setNGControlTop("PrintFrm", j + 4 + i + 4 + 99 + 4 + 99);
		}
	}
	else if (ActivityName == "Branch_Return")
	{
		//alert("A1");
		//this.formObject.setNGControlTop("CardsFrm", j + 4 + i);
		//this.formObject.setNGControlTop("BRFrm", j + 4 + i + 4 + 99);
		//alert("A2");
	}
	else
	{
		//this.formObject.setNGControlTop("CardsFrm", j + 4 + i);
		if (getValue("BR_Decision") == null || getValue("BR_Decision") == "")
			setStyle("Branch_Dtls_Section","visible","false");
		/*else
			this.formObject.setNGControlTop("BRFrm", j + 4 + i + 4 + 99);*/
	}
}


function enableDisableAfterFormLoad()
{
	if (ActivityName.toUpperCase().indexOf("INTRODUCTION") != -1)
    {
	    setStyle("Pending_Section","visible","false");
		setStyle("Card_Dtls_Section","visible","false");
		setStyle("Branch_Dtls_Section","visible","false");
		lockCAPSFrm();
		
		if (getValue("CardNo_Text").trim() == "")
		{
			setStyle("Credit_Card_Section","visible","true");
			setStyle("Verification_Section","visible","true");
			
			setStyle("Process_Name_Section","visible","true");
			setStyle("Button_Section","visible","true");
			
		}
		else
		{
			//str5 = getValue("CCI_CrdtCN");
			//setControlValue("CardNo_Text", str5.substring(0, 4) + "-" + str5.substring(4, 8) + "-" + str5.substring(8, 12) + "-" + str5.substring(12));

			if (ActivityName == "CRWORK INTRODUCTION")
				setControlValue("request_type", "Card Replacement");
			else if (ActivityName == "CDRWORK INTRODUCTION")
				setControlValue("request_type", "Card Delivery Request");
			else if (ActivityName == "ECRWORK INTRODUCTION")
				setControlValue("request_type", "Early Card Renewal");
			else if (ActivityName == "TDWORK INTRODUCTION")
				setControlValue("request_type", "Transaction Dispute");
			else if (ActivityName == "RIPWORK INTRODUCTION")
				setControlValue("request_type", "Re-Issue of PIN");
			
			
			setStyle("request_type","disable","true");

			if (getValue("request_type") == "Card Replacement")
			{
				if (getValue("oth_cr_reason") != "Others")
				{
					setStyle("oth_cr_OPS","disable","true");
				}	
			    if (getValue("oth_cr_DC")!= "Branch")
			    {
                    setControlValue("CR_BRANCH", "");
                    setControlValue("oth_cr_BN", "");
		     		setStyle("CR_BRANCH","disable","true");
				}
				
			}
			else if (getValue("request_type") == "Early Card Renewal")
			{
                if (getValue("oth_ecr_dt") != "Branch")
				{
				    setControlValue("ECR_BRANCH", "");
				    setControlValue("oth_ecr_bn", "");
					setStyle("ECR_BRANCH","disable","true");
				}
			}
			else if (getValue("request_type") == "Card Delivery Request")
			{
				if (getValue("oth_cdr_CDT") != "Bank")
				{
				    setControlValue("CDR_BRANCH", "");
				    setControlValue("oth_cdr_BN", "");
					setStyle("CDR_BRANCH","disable","true");
					
				}
			}
			else if (getValue("request_type") == "Re-Issue of PIN")
			{
				if (getValue("oth_rip_DC") != "Branch")
				{
					setControlValue("RIP_BRANCH", "");
				    setControlValue("oth_rip_BN", "");
					setStyle("RIP_BRANCH","disable","true");
				}
			}
			//else if (getValue("request_type")!= "Transaction Dispute")
			
		}

	     lockValidationFrm(getValue("VD_MoMaidN_Check"));
		 
		 
		 
	}
   else if (ActivityName == "Pending")
	{
		setControlValue("request_type_Label", getValue("request_type"));
		setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		//setStyle("USER_BRANCH","disable","true");
	    setStyle("LoggedInUser","disable","true");
	   // setStyle("BU_DateTime","disable","true");
	    setStyle("wi_name","disable","true");
		
		setStyle("DCI_CName","disable","true");
		setStyle("DCI_ExpD","disable","true");
		setStyle("DCI_ExpD","disable","true");
		//this.formObject.setNGLocked("CCI_CrdtCN", false);
		//setStyle("DCI_DebitCN","readonly","true");
		setStyle("DCI_DebitCN","disable","true");

		//this.formObject.setNGLocked("CCI_MONO", false);
		//setStyle("DCI_MONO","readonly","true");
		setStyle("DCI_MONO","disable","true");
		setStyle("DCI_CT","disable","true");
		setStyle("DCI_CAPS_GENSTAT","disable","true");
		setStyle("DCI_ELITECUSTNO","disable","true");
		setStyle("Refresh","visible","false");
		
		//alert("PENDING-2-");

		setStyle("Logged_Dtls_Section","visible","false");
		setStyle("Pending_Section","visible","true");
		setStyle("Branch_Dtls_Section","visible","false");
		setStyle("Card_Dtls_Section","visible","false");
		setStyle("request_type","disable","true");
		setStyle("Print_Section","visible","false");

		if (getValue("request_type") == "Card Replacement")
		{
			if (getValue("oth_cr_reason") != "Others")
			{
				setStyle("oth_cr_OPS","disable","true");
			}	
			if (getValue("oth_cr_DC") != "Branch")
			{
				setControlValue("RIP_BRANCH", "");
				setControlValue("oth_rip_BN", "");
				setStyle("CR_BRANCH","disable","true");
			}
				
		}
		else if (getValue("request_type")=="Early Card Renewal")
		{
			if (getValue("oth_ecr_dt") != "Branch")
			{
				setControlValue("ECR_BRANCH", "");
				setControlValue("oth_ecr_bn", "");
				setStyle("ECR_BRANCH","disable","true");       
			}
		}	
		else if (getValue("request_type")=="Card Delivery Request")
		{
			if (getValue("oth_cdr_CDT") != "Bank")
			{
				setControlValue("CDR_BRANCH", "");
				setControlValue("oth_cdr_BN", "");
				setStyle("CDR_BRANCH","disable","true");
			}
		}
		else if (getValue("request_type")=="Re-Issue of PIN")
		{
			if (getValue("oth_rip_DC") != "Branch")
			{
	  
				setControlValue("RIP_BRANCH", "");
				setControlValue("oth_rip_BN", "");
				setStyle("RIP_BRANCH","disable","true");
			}
		}
		//else if (getValue("request_type")!= "Transaction Dispute")
			lockValidationFrm(getValue("VD_MoMaidN_Check"));
			
			/*setControlValue("LabelBUUserName", getValue("BU_UserName"));
			setControlValue("LabelBUDatetime", getValue("BU_DateTime"));
			setControlValue("LabelWiName", str3);
			setControlValue("LabelBranch", "Branch: " + getValue("User_Branch"));   */
		   //this.formObject.setNGLocked("ProNameFrm", false);
		  
	}
			
	else if (ActivityName == "CARDS")
	{
	   // alert("CARDS--");
	    setControlValue("request_type_Label", getValue("request_type"));
		setControlValue("Card_UserName",user);
	    setControlValue("Card_DateTime",getTodayDate());
	    //setControlValue("Cards_Decision","");
	    //setControlValue("Cards_Remarks","");
		
		
		setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		//setStyle("USER_BRANCH","disable","true");
	    setStyle("LoggedInUser","disable","true");
	   // setStyle("BU_DateTime","disable","true");
	    setStyle("wi_name","disable","true");
	    setStyle("DCI_CName","disable","true");
		setStyle("DCI_ExpD","disable","true");
		setStyle("DCI_DebitCN","disable","true");
		setStyle("DCI_MONO","disable","true");
		setStyle("DCI_CT","disable","true");
		setStyle("DCI_CAPS_GENSTAT","disable","true");
		setStyle("DCI_ELITECUSTNO","disable","true");
		setStyle("DCI_ExtNo","disable","true");
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("request_type","disable","true");
	/*	setStyle("oth_rip_reason","disable","true");
		setStyle("oth_rip_DC","disable","true");
		setStyle("RIP_BRANCH","disable","true");  */
		
		setStyle("Refresh","visible","false");
		setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Process_Name_Section","visible","true");
		setStyle("Reissue_Dtls_Section","visible","true");
		setStyle("Card_Dtls_Section","visible","true");
		setStyle("Print_Section","visible","true");
		setStyle("Buttons_Section","visible","false");
		setStyle("Pending_Section","visible","false");
		setStyle("Card_Delivery_Section","visible","false");
		setStyle("Branch_Dtls_Section","visible","false");
		setStyle("Early_Card_Section","visible","false");
		setStyle("Card_Replace_Section","visible","false");
		
		lockFields(getValue("request_type"));
		
		
	
	}
	else if (ActivityName == "Branch_Return")
	{
		//alert("Branch_Return--");
	    setControlValue("request_type_Label", getValue("request_type"));
		//setControlValue("Card_UserName",user);
	    //setControlValue("Card_DateTime",getValue("BU_DateTime"));
		setControlValue("BU_UserName",user);
		setControlValue("BranchDateTime",getTodayDate());
	   
	   
	   setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		//setStyle("USER_BRANCH","disable","true");
	    setStyle("LoggedInUser","disable","true");
	    //setStyle("BU_DateTime","disable","true");
	    setStyle("wi_name","disable","true");
		setStyle("DCI_CName","disable","true");
		setStyle("DCI_ExpD","disable","true");
		setStyle("DCI_DebitCN","disable","true");
		setStyle("DCI_MONO","disable","true");
		setStyle("DCI_CT","disable","true");
		setStyle("DCI_CAPS_GENSTAT","disable","true");
		setStyle("DCI_ELITECUSTNO","disable","true");
		setStyle("request_type","disable","true");
	/*	setStyle("oth_rip_reason","disable","true");
		setStyle("oth_rip_DC","disable","true");
		setStyle("RIP_BRANCH","disable","true");  */
		
		setStyle("Refresh","visible","false");
		setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Process_Name_Section","visible","true");
		setStyle("Reissue_Dtls_Section","visible","true");
		setStyle("Card_Dtls_Section","visible","true");
		setStyle("Branch_Dtls_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Buttons_Section","visible","false");
		setStyle("Pending_Section","visible","false");
		setStyle("Card_Delivery_Section","visible","false");
		setStyle("Early_Card_Section","visible","false");
		setStyle("Card_Replace_Section","visible","false");
		setStyle("Card_Dtls_Section","disable","true");

		lockValidationFrm(getValue("VD_MoMaidN_Check"));
        if ((getValue("BR_Decision") == "Re-Submit to CARDS"))
		{
			setControlValue("BR_Decision","Approve");
			
		}

		if (getValue("request_type") == "Card Replacement")
		{
			if (getValue("oth_cr_reason") != "Others")
			{
				setStyle("oth_cr_OPS","disable","true");
				if (getValue("oth_cr_DC") != "Branch")
				{
					setControlValue("CR_BRANCH", "");
					setControlValue("oth_cr_BN", "");
					setStyle("CR_BRANCH","disable","true");
				}
			}
		}	
		else if (getValue("request_type") == "Early Card Renewal")
		{
			if (getValue("oth_ecr_dt") != "Branch")
			{
				setControlValue("ECR_BRANCH", "");
				setControlValue("oth_ecr_bn", "");
				setStyle("ECR_BRANCH","disable","true");
			
			}
		}
		else if (getValue("request_type") == "Card Delivery Request")
		{
			if (getValue("oth_cdr_CDT") != "Bank")
			{
				setControlValue("CDR_BRANCH", "");
				setControlValue("oth_cdr_BN", "");
				setStyle("CDR_BRANCH","disable","true");
			}
		}
		else if (getValue("request_type") == "Re-Issue of PIN")
		{
			if (getValue("oth_rip_DC") != "Branch")
			{
				setControlValue("RIP_BRANCH", "");
				setControlValue("oth_rip_BN", "");
				setStyle("RIP_BRANCH","disable","true");
			}
			setStyle("oth_rip_reason","disable","false");
			setStyle("oth_rip_DC","disable","false");
			
			
		}
		
		
	}
	else if ((ActivityName == "Work Exit1") || (ActivityName == "Discard1") || (ActivityName == "Query"))
	{
		//alert("ActivityName--" + ActivityName);
	    setControlValue("request_type_Label", getValue("request_type"));
	   setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		//setStyle("USER_BRANCH","disable","true");
	    setStyle("LoggedInUser","disable","true");
	   // setStyle("BU_DateTime","disable","true");
	    setStyle("wi_name","disable","true");
		
		setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Card_Dtls_Section","visible","true");
		setStyle("Credit_Card_Section","disable","true");
		setStyle("Verification_Section","disable","true");
        setStyle("Card_Dtls_Section","disable","true");
		setStyle("Branch_Dtls_Section","disable","true");
		lockFields(getValue("request_type"));
		
		setStyle("request_type","disable","true");
		
		
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
		setStyle("VD_Oth_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_Oth_Check","disable","false");
		
		
	}
	else
	{
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
	}
}

function lockFields(paramString)
{
	if (paramString == "Card Replacement")
	{
		lockCRFrm();
	}
	else if (paramString == "Card Delivery Request")
	{
		lockCDRFrm();
	}
	else if (paramString == "Early Card Renewal")
	{
		lockECRFrm();
	}
	else if (paramString == "Card Upgrade")
	{
		lockCCUFrm();
	}
	else if (paramString == "Transaction Dispute")
	{
		lockTDFrm();
	}
	else if (paramString == "Re-Issue of PIN")
	{
		lockRIPFrm();
	}
}

function lockCRFrm()
{
	setStyle("oth_cr_DC","disable","true");
	setStyle("oth_cr_RR","disable","true");
	setStyle("CR_BRANCH","disable","true");
	setStyle("oth_cr_reason","disable","true");
	setStyle("oth_cr_OPS","disable","true");
}
function lockCDRFrm()
{
	setStyle("oth_cdr_CDT","disable","true");
	setStyle("oth_cdr_RR","disable","true");
	setStyle("CDR_BRANCH","disable","true");
}

function lockECRFrm()
{
	setStyle("oth_cr_RR","disable","true");
	setStyle("oth_ecr_dt","disable","true");
	setStyle("oth_ecr_RR","disable","true");
	setStyle("ECR_BRANCH","disable","true");
	
}

function lockTDFrm()
{
	setStyle("oth_td_Amount","disable","true");
	setStyle("oth_td_RR","disable","true");
	setStyle("oth_td_RNO","disable","true");
}

function lockRIPFrm()
{
	
	setStyle("oth_rip_reason","disable","true");
	setStyle("oth_rip_DC","disable","true");
	setStyle("RIP_BRANCH","disable","true");
	setStyle("oth_rip_RR","disable","true");
	
}

function callPrintJSPDSRODC(params)
{
	
	var mobNoClearTxt = getValue('DCI_MONO');
	var cardNoClearTxt = getValue('DCI_DebitCN');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt;
	var strUrl="/DSR_ODC/DSR_ODC/CustomJSP/PrintODC.jsp?"+params;
	//alert("params :"+params+" strUrl :"+strUrl);
	//window.open(strUrl);
	var sOptions = 'dialogWidth:1300px; dialogHeight:600px; dialogLeft:450px; dialogTop:100px; status:no; scroll:yes; scrollbar:yes; help:no; resizable:no';
	var windowParams="height=600px,width=1300px,toolbar=no,directories=no,status=no,scrollbars=yes,resizable=no,modal=yes,addressbar=no,menubar=no";
	var popupWindow="";
	if (window.showModalDialog) {
		popupWindow = window.showModalDialog(strUrl, null, sOptions);
	}else{
		popupWindow = window.open(strUrl, null, windowParams);
	}				
	//var popupWindow = window.open(strUrl, null, sOptions);
	//var popupWindow = window.showModalDialog(strUrl, null, sOptions);
	
}

function getTodayDate(){
	var today = new Date();
	var dd = String("0" + (today.getDate())).slice(-2); //Fix for IE
	var mm = String("0" + (today.getMonth() +1)).slice(-2); //January is 0! //Fix for IE
	var yyyy = today.getFullYear();
	today = dd + '/' + mm + '/' + yyyy;
	return today;
}

function getDropdownValues(ActivityName){
	if(ActivityName == "CARDS"){
		var REQUEST_TYPE = getValue("request_type");
		if(REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Early Card Renewal" || REQUEST_TYPE == "Re-Issue of PIN"){
			clearComboOptions("Cards_Reject");
			clearComboOptions("Cards_ReWorkReason");
			
			addItemInCombo("Cards_Reject","Documentation Criteria not met");
			addItemInCombo("Cards_Reject","Eligibility Criteria not met");
			addItemInCombo("Cards_Reject","Duplicate Request");
			addItemInCombo("Cards_Reject","Customer response awaited");
			addItemInCombo("Cards_Reject","Confidential reasons to bank");
			
			addItemInCombo("Cards_ReWorkReason","Documentation Criteria not met");
			addItemInCombo("Cards_ReWorkReason","Eligibility Criteria not met");
			addItemInCombo("Cards_ReWorkReason","Duplicate Request");
			addItemInCombo("Cards_ReWorkReason","Customer response awaited");
			addItemInCombo("Cards_ReWorkReason","Confidential reasons to bank");
		} 
	}
}
		