var CSR_CCB_Common = document.createElement('script');
CSR_CCB_Common.src = '/CSR_CCB/CSR_CCB/CustomJS/CSR_CCB_Common.js';
document.head.appendChild(CSR_CCB_Common);

function enableDisableAfterFormLoad()
{
    if(ActivityName=='Work Introduction')
	{
		//alert("enableAfterFormLoad1 ActivityName :"+ActivityName);
		setStyle("Credit_Card_Section","disable","false");
		lockCAPSFrm();
		if(getValue("CCI_CrdtCN").trim()=="")
		{
			setStyle("Verification_Section","visible","true");
			setStyle("Hostlist_Section","visible","true");
			setStyle("Cards_Section","visible","false");
			setStyle("Replacement_Section","visible","false");
			setStyle("Print_Section","visible","false");
			setStyle("Branch_Approver_Section","visible","false");
			setStyle("Pending_Section","visible","false");
			setStyle("Refresh","visible","true");
		}
		
	
		lockValidationFrm();
		
	}
	if(ActivityName=='Pending')
	{   
		//alert(" ActivityName :"+ActivityName);
		setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		setStyle("LoggedInUser","disable","true");
	    setStyle("wi_name","disable","true");
		setStyle("Refresh","visible","false");
	    setStyle("CCI_CName","disable","true");
	    setStyle("CCI_ExpD","disable","true");
	    setStyle("CCI_CrdtCN","disable","true");
		setStyle("CCI_MONO","disable","true");
		setStyle("CCI_CT","disable","true");
		setStyle("CCI_CAPS_GENSTAT","disable","true");
		setStyle("CCI_ELITECUSTNO","disable","true");
	    setStyle("CCI_CCRNNo","disable","true");
		setStyle("CCI_ExtNo","disable","false");
		setStyle("CCI_AccInc","disable","true");
	
		
		setStyle("Verification_Section","visible","true");
		setStyle("Hostlist_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		setStyle("Replacement_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Branch_Approver_Section","visible","false");
		setStyle("Pending_Section","visible","true");
		setStyle("Buttons_Section","visible","false");
		
		/*if(getValue("DELIVER_TO")=="Branch")
		{
			setStyle("Branch","visible","true");
		}
		else
		{
			setValue("BRANCH","");
			setValue("BRANCH_NAME","");
			setStyle("BRANCH","visible","false");
		}*/
		lockValidationFrm(getValue("VD_MoMaidN_Check"));			
		onLoadlockHotlistFrm(getValue("REASON_HOTLIST"));
		lockReplaceReqFrm(getValue("ACTION_TAKEN"));
		//setControlValue("LabelBUUserName",getValue("BU_UserName"));
		//setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		//setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		//setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
		
	}
	if(ActivityName=='Branch_Approver')
	{	
	    setStyle("LoggedInUser","disable","true");
	    setStyle("wi_name","disable","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Hostlist_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		setStyle("Replacement_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Branch_Approver_Section","visible","true");
		setStyle("Pending_Section","visible","false");
		setStyle("Buttons_Section","visible","false");
		setStyle("Refresh","visible","false");
		
		setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		setControlValue("BA_UserName",user);
		
		//var currentTime = new Date();
		//setControlValue("BA_DateTime","Branch: "+getValue("currentTime"));
		//var BADT = currentTime.toLocaleDateString();
		
		setControlValue("BA_DateTime", getTodayDate());
		//setControlValue("BA_DateTime", "abdsd");test
		setStyle("Cards_Decision","disable","true");
		setStyle("Cards_Remarks","disable","true");
		setValue("BA_Decision","");
		setValue("BA_Remarks","");
		
		 setStyle("CCI_CName","disable","true");
		 setStyle("CCI_ExpD","disable","true");
		 setStyle("CCI_CrdtCN","disable","true");
		 setStyle("CCI_CCRNNo","disable","true");
		 setStyle("CCI_MONO","disable","true");
		 setStyle("CCI_AccInc","disable","true");
		 setStyle("CCI_CT","disable","true");
		 setStyle("CCI_CAPS_GENSTAT","disable","true");
		 setStyle("CCI_ELITECUSTNO","disable","true");
		 setStyle("CCI_ExtNo","disable","true");
		 
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
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
	
		setStyle("HOST_OTHER","disable","true");
		setStyle("EMBOSING_NAME","disable","true");
		setStyle("EMAIL_FROM","disable","true");
		setStyle("CB_DateTime","disable","true");
		setStyle("PLACE","disable","true");
		setStyle("AVAILABLE_BALANCE","disable","true");
		setStyle("C_STATUS_A_BLOCK","disable","true");
		setStyle("C_STATUS_B_BLOCK","disable","true");
		
		setStyle("ACTION_TAKEN","disable","true");
		setStyle("ACTION_OTHER","disable","true");
		setStyle("DELIVER_TO","disable","true");
		setStyle("BRANCH","disable","true");
		setStyle("REMARKS","disable","true");
		setStyle("AVAILABLE_BALANCE","disable","true");
		
		setControlValue("Branch_Approver_Section", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		
	/*	setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));  */
	
		setStyle("Cards_Section","disable","true");
		setStyle("Hostlist_Section","disable","true");
		setStyle("Replacement_Section","disable","true");
	}
	if(ActivityName=='CARDS')
	{
		setStyle("LoggedInUser","disable","true");
	    setStyle("wi_name","disable","true");
		
		//setControlValue("Card_UserName","Branch: "+getValue("user"));
		setControlValue("Card_UserName",user);
		//var currentTime = new Date();
		//setControlValue("Card_DateTime","Branch: "+getValue("currentTime"));
		
		setControlValue("Card_DateTime", getTodayDate());
		//setControlValue("Card_DateTime",currentTime.toLocaleDateString());
		setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		
		setStyle("Refresh","visible","false");
		 setStyle("CCI_CName","disable","true");
		 setStyle("CCI_ExpD","disable","true");
		 setStyle("CCI_CrdtCN","disable","true");
		 setStyle("CCI_CCRNNo","disable","true");
		 setStyle("CCI_MONO","disable","true");
		 setStyle("CCI_AccInc","disable","true");
		 setStyle("CCI_CT","disable","true");
		 setStyle("CCI_CAPS_GENSTAT","disable","true");
		 setStyle("CCI_ELITECUSTNO","disable","true");
		 setStyle("CCI_ExtNo","disable","true");
		 
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
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
		
		setStyle("HOST_OTHER","disable","true");
		setStyle("EMBOSING_NAME","disable","true");
		setStyle("EMAIL_FROM","disable","true");
		setStyle("CB_DateTime","disable","true");
		setStyle("PLACE","disable","true");
		setStyle("AVAILABLE_BALANCE","disable","true");
		setStyle("C_STATUS_A_BLOCK","disable","true");
		setStyle("C_STATUS_B_BLOCK","disable","true");
		
		setStyle("ACTION_TAKEN","disable","true");
		setStyle("ACTION_OTHER","disable","true");
		setStyle("DELIVER_TO","disable","true");
		//setStyle("BRANCH","disable","true");
		setStyle("REMARKS","disable","true");
		
		
		setStyle("BA_Decision","disable","true");
		setStyle("BA_Remarks","disable","true");
		
		setStyle("Cards_Decision","disable","false");
		setStyle("Cards_Remarks","disable","false");
		setValue("Cards_Decision","");
		setValue("Cards_Remarks","");
		
		setStyle("Credit_Card_Section","visible","true");
		setStyle("Branch_Approver_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Hostlist_Section","visible","true");
		setStyle("Replacement_Section","visible","true");
		setStyle("Print_Section","visible","true");
		setStyle("Pending_Section","visible","false");
		setStyle("AVAILABLE_BALANCE","disable","true");
		setStyle("Buttons_Section","visible","false");
		setStyle("Print_Section","visible","true");
		
		setControlValue("Cards_Section", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
			
	/*	setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));  */
	
		setStyle("Branch_Approver_Section","disable","true");
		setStyle("Hostlist_Section","disable","true");
		setStyle("Replacement_Section","disable","true");
	}
	if(ActivityName=='Branch_Return')
	{	
	    setStyle("LoggedInUser","disable","true");
	    setStyle("wi_name","disable","true");
		setControlValue("LabelUserBranch",getValue("USER_BRANCH"));
	   	setStyle("BA_Decision","disable","true");
		setStyle("BA_Remarks","disable","true");
		
		setStyle("Cards_Decision","disable","true");
		setStyle("Cards_Remarks","disable","true");
		
		setStyle("Pending_Decision","disable","true");
		
		setStyle("Refresh","visible","false");
		setStyle("CCI_CName","disable","true");
		 setStyle("CCI_ExpD","disable","true");
		 setStyle("CCI_CrdtCN","disable","true");
		 setStyle("CCI_CCRNNo","disable","true");
		 setStyle("CCI_MONO","disable","true");
		 setStyle("CCI_AccInc","disable","true");
		 setStyle("CCI_CT","disable","true");
		 setStyle("CCI_CAPS_GENSTAT","disable","true");
		 setStyle("CCI_ELITECUSTNO","disable","true");
		 setStyle("CCI_ExtNo","disable","true");
				
		setStyle("Credit_Card_Section","visible","true");
		setStyle("Branch_Approver_Section","visible","true");
		setStyle("Hostlist_Section","visible","true");
		setStyle("Replacement_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		setStyle("Pending_Section","visible","false");
		setStyle("Print_Section","visible","false");
		setStyle("Buttons_Section","visible","false");
		
		//setStyle("BRANCH_NAME","disable","true");
			
		onLoadlockHotlistFrm(getValue("REASON_HOTLIST"));
		lockReplaceReqFrm(getValue("ACTION_TAKEN"));
		lockValidationFrm(getValue("VD_MoMaidN_Check"));

		
		if ((getValue("ACTION_TAKEN") =="Issue Replacement"))
		{
			if ((getValue("DELIVER_TO") == "Branch" ))
			{
				setStyle("BRANCH_NAME","disable","false");
			}
			else{setStyle("BRANCH_NAME","disable","true");}
		}
		
		setControlValue("Branch_Approver_Section", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		setControlValue("Cards_Section", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
	
		setStyle("Branch_Approver_Section","disable","true");
		setStyle("Cards_Section","disable","true");
	}
	if (ActivityName=='Work Exit' || ActivityName=='Discard' || ActivityName=='Query' )
	{
		setControlValue("LabelUserBranch", getValue("USER_BRANCH"));
		setStyle("Verification_Section","visible","true");
		//setStyle("baseFr3","visible","true");
		setStyle("LoggedInUser","disable","true");
	    setStyle("wi_name","disable","true");
		setStyle("Hostlist_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Branch_Approver_Section","visible","true");
		setStyle("PendingFrm","visible","true");
		setStyle("Replacement_Section","visible","true");
		setStyle("Buttons_Section","visible","false");
		setStyle("Refresh","visible","false");
		
		//setStyle("baseFrame","disable","true");
		setStyle("Verification_Section","disable","true");
		//setStyle("baseFr3","disable","true");
		setStyle("PendingFrm","disable","true");
		setStyle("Branch_Approver_Section","disable","true");
		setStyle("Cards_Section","disable","true");
		setStyle("Hostlist_Section","disable","true");
		setStyle("Replacement_Section","disable","true");
		setStyle("Buttons_Section","disable","true");
		
		setStyle("AVAILABLE_BALANCE","disable","true");
	
		setControlValue("Branch_Approver_Section", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		setControlValue("Cards_Section", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
		/*setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));*/				
	}
}

function lockCAPSFrm()
{
    setStyle("CCI_CName","disable","false");
	setStyle("CCI_ExpD","disable","false");
	setStyle("CCI_ExpD","disable","false");
	setStyle("CCI_CrdtCN","disable","false");
	setStyle("CCI_CCRNNo","disable","false");
	setStyle("CCI_MONO","disable","false");
	setStyle("CCI_AccInc","disable","false");
	setStyle("CCI_CT","disable","false");
	setStyle("CCI_CAPS_GENSTAT","disable","false");
	setStyle("CCI_ELITECUSTNO","disable","false");
}

function clrCAPSFrm()
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

function clrValidationFrm()
{
    setControlValue("VD_DOB", "N");
	setControlValue("VD_StaffId", "N");
	setControlValue("VD_POBox", "N");
	setControlValue("VD_PassNo","N");
	//setControlValue("VD_MoMaidN", "N");
	setControlValue("VD_MRT", "N");
	setControlValue("VD_EDC", "N");
	setControlValue("VD_TELNO", "N");
	setControlValue("VD_NOSC","N");
    setControlValue("VD_SD","N");
	setControlValue("VD_Oth", "N");

	setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	setControlValue("VD_PassNo_Check","false");
	//setControlValue("VD_MoMaidN_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
	setControlValue("VD_NOSC_Check","false");
    setControlValue("VD_SD_Check","false");
	setControlValue("VD_Oth", "false");
	

}

function lockValidationFrm(paramString)
{
	//alert(paramString);
	if (paramString == true)
	{
		setStyle("VD_TIN_Check","disable","true");
		setStyle("VD_DOB_Check","disable","false");
		setStyle("VD_StaffId_Check","disable","false");
		setStyle("VD_POBox_Check","disable","false");
		setStyle("VD_PassNo_Check","disable","false");
		//setStyle("VD_MoMaidN_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_NOSC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		setStyle("VD_SD_Check","disable","false");
		setStyle("VD_Oth_Check","disable","false");
		
		
	}
	else
	{
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_PassNo_Check","disable","true");
		//setStyle("VD_MoMaidN_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_NOSC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_SD_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
	}
}
	
	function lockHotlistFrm(paramString)
	{
		//alert("paramString :"+paramString);
		setStyle("HOST_OTHER","disable","true");
		setStyle("EMBOSING_NAME","disable","true");
		setStyle("EMAIL_FROM","disable","true");
		setStyle("CB_DateTime","disable","true");
		setStyle("PLACE","disable","true");
		setStyle("AVAILABLE_BALANCE","disable","true");
		setStyle("C_STATUS_A_BLOCK","disable","true");
		setStyle("C_STATUS_B_BLOCK","disable","true");
		
		if ((paramString!="") && (paramString!="--select--"))
		{
			if ((paramString =="Lost") || (paramString =="Stolen") || (paramString =="Captured") || (paramString== "Blocked"))
			{
				setValue("HOST_OTHER","");
				setValue("EMBOSING_NAME","");
				setValue("EMAIL_FROM","");
		        setValue("AVAILABLE_BALANCE", "");
				setValue("C_STATUS_A_BLOCK", "");
				setValue("C_STATUS_B_BLOCK", "");
				setStyle("CB_DateTime","disable","false");
				setStyle("PLACE","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("HOST_OTHER","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("EMAIL_FROM","disable","true");
			} 
			else if ((paramString== "Magnetic Strip Is Damaged") || (paramString== "Misuse"))
			{
				setValue("HOST_OTHER","");
				setValue("EMAIL_FROM","");
				setValue("EMBOSING_NAME","");
				setValue("CB_DateTime","");
				setValue("PLACE","");
		        setValue("AVAILABLE_BALANCE", "");
				setValue("C_STATUS_A_BLOCK", "");
				setValue("C_STATUS_B_BLOCK", "");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("HOST_OTHER","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("EMAIL_FROM","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
			 else if (paramString== "Email From")
			{
				setValue("HOST_OTHER","");
				setValue("EMBOSING_NAME","");
				setValue("CB_DateTime","");
				setValue("PLACE","");
		        setValue("AVAILABLE_BALANCE", "");
				setValue("C_STATUS_A_BLOCK", "");
				setValue("C_STATUS_B_BLOCK", "");
				setStyle("EMAIL_FROM","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("HOST_OTHER","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
			else if (paramString== "Wrong Embossing Name")
			{
			
				setValue("HOST_OTHER","");
				setValue("EMAIL_FROM","");
				setValue("CB_DateTime","");
				setValue("PLACE","");
		        setValue("AVAILABLE_BALANCE", "");
				setValue("C_STATUS_A_BLOCK", "");
				setValue("C_STATUS_B_BLOCK", "");
				setStyle("EMBOSING_NAME","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("EMAIL_FROM","disable","true");
				setStyle("HOST_OTHER","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
			else if (paramString== "Others")
			{
				setValue("EMBOSING_NAME","");
				setValue("EMAIL_FROM","");
				setValue("CB_DateTime","");
				setValue("PLACE","");
				setValue("AVAILABLE_BALANCE", "");
				setValue("C_STATUS_A_BLOCK", "");
				setValue("C_STATUS_B_BLOCK", "");
				setStyle("HOST_OTHER","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","true");
				setStyle("C_STATUS_B_BLOCK","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("EMAIL_FROM","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
		}
    }
	
	function clrHotlistFrm() 
	{ 
		setValue("HOST_OTHER", "");
		setValue("EMBOSING_NAME", "");
		setValue("EMAIL_FROM", "");
		setValue("CB_DateTime", "");
		setValue("AVAILABLE_BALANCE", "");
		setValue("C_STATUS_A_BLOCK", "");
		setValue("C_STATUS_B_BLOCK", "");
	}
	
	function lockReplaceReqFrm(paramString)
	{
		
		if ((paramString == "") || (paramString== "Select") || (paramString== "Customer Will Call back") || (paramString== "Customer is overdue") || (paramString== "Customer is Over limit"))
		{
			//setValue("ACTION_OTHER","");
			setStyle("ACTION_OTHER","disable","true");
			setStyle("DELIVER_TO","disable","true");
			setStyle("BRANCH_NAME","disable","true");
		}
		else if (paramString== "Issue Replacement")
		{
			//setValue("ACTION_OTHER","");
			setStyle("ACTION_OTHER","disable","true");
			setStyle("BRANCH_NAME","disable","true");
			setStyle("DELIVER_TO","disable","false");
		} 
		else if (paramString=="Others")
		{
			setStyle("ACTION_OTHER","disable","false");
			setStyle("DELIVER_TO","disable","true");
			setStyle("BRANCH_NAME","disable","true");
			//setValue("DELIVER_TO","");
			//setValue("BRANCH_NAME","");
		}
	}
	
	function clrReplaceReqFrm() 
	{
		setValue("ACTION_OTHER","");
		setValue("DELIVER_TO","");
		setValue("BRANCH","");
		setValue("BRANCH_NAME","");
	}
 

function callPrintJSPCSRCCB(params)
{
	
	var mobNoClearTxt = getValue('CCI_MONO');
	var cardNoClearTxt = getValue('CCI_CrdtCN');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt;
	
	var strUrl="/CSR_CCB/CSR_CCB/CustomJSP/PrintCCB.jsp?"+params;
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

function onLoadlockHotlistFrm(paramString)
	{
		//alert("paramString :"+paramString);
		setStyle("HOST_OTHER","disable","true");
		setStyle("EMBOSING_NAME","disable","true");
		setStyle("EMAIL_FROM","disable","true");
		setStyle("CB_DateTime","disable","true");
		setStyle("PLACE","disable","true");
		setStyle("AVAILABLE_BALANCE","disable","true");
		setStyle("C_STATUS_A_BLOCK","disable","true");
		setStyle("C_STATUS_B_BLOCK","disable","true");
		
		if ((paramString!="") && (paramString!="--select--"))
		{
			if ((paramString =="Lost") || (paramString =="Stolen") || (paramString =="Captured") || (paramString== "Blocked"))
			{
				setStyle("CB_DateTime","disable","false");
				setStyle("PLACE","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("HOST_OTHER","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("EMAIL_FROM","disable","true");
			} 
			else if ((paramString== "Magnetic Strip Is Damaged") || (paramString== "Misuse"))
			{
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("HOST_OTHER","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("EMAIL_FROM","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
			 else if (paramString== "Email From")
			{
				setStyle("EMAIL_FROM","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("HOST_OTHER","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
			else if (paramString== "Wrong Embossing Name")
			{
				setStyle("EMBOSING_NAME","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
				setStyle("EMAIL_FROM","disable","true");
				setStyle("HOST_OTHER","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
			else if (paramString== "Others")
			{
				setStyle("HOST_OTHER","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","true");
				setStyle("C_STATUS_B_BLOCK","disable","true");
				setStyle("EMBOSING_NAME","disable","true");
				setStyle("EMAIL_FROM","disable","true");
				setStyle("CB_DateTime","disable","true");
				setStyle("PLACE","disable","true");
			}
		}
    }
	
	function getTodayDate(){
		var today = new Date();
		var dd = String("0" + (today.getDate())).slice(-2); //Fix for IE
		var mm = String("0" + (today.getMonth() +1)).slice(-2); //January is 0! //Fix for IE
		var yyyy = today.getFullYear();
		today = dd + '/' + mm + '/' + yyyy;
		return today;
	}