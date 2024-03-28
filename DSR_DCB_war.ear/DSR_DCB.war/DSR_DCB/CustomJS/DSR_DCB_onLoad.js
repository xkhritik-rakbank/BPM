var DSR_DCB_Common = document.createElement('script');
DSR_DCB_Common.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_Common.js';
document.head.appendChild(DSR_DCB_Common);

function loadSolId()
{
	var solId = executeServerEvent("SolId","FormLoad",user,true).trim();
	setControlValue("Sol_Id",solId);
}

function enableDisableAfterFormLoad()
{
    if(ActivityName=='Work Introduction')
	{
		//alert("enableAfterFormLoad1 ActivityName :"+ActivityName);
		setStyle("baseFr1","disable","false");
		lockCAPSFrm();
		setStyle("DCI_DebitCN","disable","false");
		if(getValue("DCI_DebitCN").trim()=="")
		{
			setStyle("baseFr2","visible","true");
			setStyle("Frame1","visible","true");
			setStyle("CardsFrm","visible","false");
			setStyle("Frame2","visible","true");
			setStyle("Print_Section","visible","false");
			setStyle("BAFrm","visible","false");
			setStyle("PendingFrm","visible","false");
			setStyle("Refresh","visible","true");
		}
		/*if(getValue("DELIVER_TO")=="Branch")
		{
			setStyle("Branch","visible","true");
		}
		else
		{
			setValue("BRANCH","");
			setValue("BRANCH_NAME","");
			setStyle("BRANCH","visible","false");
		}  */
	
		lockValidationFrm();
		
	}
	if(ActivityName=='Pending')
	{   
		//alert(" ActivityName :"+ActivityName);
		setStyle("Refresh","visible","false");
	    setStyle("DCI_CName","disable","true");
	    setStyle("DCI_ExpD","disable","true");
	    setStyle("DCI_DebitCN","disable","true");
		setStyle("DCI_MONO","disable","true");
		setStyle("DCI_CT","disable","true");
		setStyle("DCI_CAPS_GENSTAT","disable","true");
		setStyle("DCI_ELITECUSTNO","disable","true");
		setStyle("DCI_CAPS_GENSTAT","disable","true");
		setStyle("DCI_ExtNo","disable","false");
		
	  
		setStyle("baseFr2","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("CardsFrm","visible","false");
		setStyle("Frame2","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("BAFrm","visible","false");
		setStyle("PendingFrm","visible","true");
		setStyle("Frame3","visible","false");
		
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
		lockValidationFrm(getValue("VD_Oth_Check"));			
		lockHotlistFrm(getValue("REASON_HOTLIST"));
		lockReplaceReqFrm(getValue("ACTION_TAKEN"));
		//setControlValue("LabelBUUserName",getValue("BU_UserName"));
		//setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		//setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		//setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));
		
	}
	if(ActivityName=='Branch_Approver')
	{	
		setStyle("baseFr2","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("CardsFrm","visible","false");
		setStyle("Frame2","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("BAFrm","visible","true");
		setStyle("PendingFrm","visible","false");
		setStyle("Frame3","visible","false");
		setStyle("Refresh","visible","false");
		
		setControlValue("BA_UserName", user);
		//var currentTime = new Date();
		setControlValue("BA_DateTime", getTodayDate());
		setStyle("BA_UserName","visible","true");
		setStyle("BA_DateTime","visible","true");	    
	  
		setStyle("Cards_Decision","disable","true");
		setStyle("Cards_Remarks","disable","true");
		
		setValue("BA_Decision","");
		setValue("BA_Remarks","");
		
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
		
		setControlValue("BAFrm", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		
	/*	setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));  */
	
		setStyle("CardsFrm","disable","true");
		setStyle("Frame1","disable","true");
		setStyle("Frame2","disable","true");
	}
	if(ActivityName=='CARDS')
	{
		setControlValue("Card_UserName", user);
		//var currentTime = new Date();
		setControlValue("Card_DateTime", getTodayDate());
		
		setStyle("Refresh","visible","false");
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
		
		setStyle("baseFr1","visible","true");
		setStyle("BAFrm","visible","true");
		setStyle("CardsFrm","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("Frame2","visible","true");
		setStyle("Print_Section","visible","true");
		setStyle("PendingFrm","visible","false");
		setStyle("AVAILABLE_BALANCE","disable","true");
		setStyle("Frame3","visible","false");
		
		setControlValue("CardsFrm", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
			
	/*	setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));  */
	
		setStyle("BAFrm","disable","true");
		setStyle("Frame1","disable","true");
		setStyle("Frame2","disable","true");
	}
	if(ActivityName=='Branch_Return')
	{	
	   	setStyle("BA_Decision","disable","true");
		setStyle("BA_Remarks","disable","true");
		
		setStyle("Cards_Decision","disable","true");
		setStyle("Cards_Remarks","disable","true");
		
		setStyle("Pending_Decision","disable","true");
		
		setStyle("Refresh","visible","false");
		setStyle("DCI_CName","disable","true");
		setStyle("DCI_ExpD","disable","true");
		setStyle("DCI_DebitCN","disable","true");
		setStyle("DCI_MONO","disable","true");
		setStyle("DCI_CT","disable","true");
		setStyle("DCI_CAPS_GENSTAT","disable","true");
		setStyle("DCI_ELITECUSTNO","disable","true");
		setStyle("DCI_ExtNo","disable","false");
		
		setStyle("baseFr1","visible","true");
		setStyle("BAFrm","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("Frame2","visible","true");
		setStyle("CardsFrm","visible","false");
		setStyle("PendingFrm","visible","false");
		setStyle("Print_Section","visible","false");
		setStyle("Frame3","visible","false");
		
		//setStyle("BRANCH_NAME","disable","true");
			
		lockHotlistFrm(getValue("REASON_HOTLIST"));
		lockReplaceReqFrm(getValue("ACTION_TAKEN"));
		lockValidationFrm(getValue("VD_Oth_Check"));

		/*if (getValue("DELIVER_TO") == "Branch")
		{
			if (getValue("DELIVER_TO")!= "Branch")
			{
				setStyle("BRANCH_NAME","disable","true");
			}
			else
			{
				setControlValue("BRANCH_NAME", "");
				setStyle("BRANCH","disable","true");
			}
		}*/
		if ((getValue("ACTION_TAKEN") =="Issue Replacement"))
		{
			if ((getValue("DELIVER_TO") == "Branch" ))
			{
				setStyle("BRANCH_NAME","disable","false");
			}
			else{setStyle("BRANCH_NAME","disable","true");}
		}
		
		setControlValue("BAFrm", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		setControlValue("CardsFrm", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
	/*	setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));  */
		
	
		setStyle("BAFrm","disable","true");
		setStyle("CardsFrm","disable","true");
	}
	if (ActivityName=='Work Exit' || ActivityName=='Discard' || ActivityName=='Query' )
	{
		
		setStyle("baseFr2","visible","true");
		setStyle("baseFr3","visible","true");
		setStyle("Frame1","visible","true");
		setStyle("CardsFrm","visible","true");
		setStyle("BAFrm","visible","true");
		setStyle("PendingFrm","visible","true");
		setStyle("Frame2","visible","true");
		setStyle("Frame3","visible","false");
		setStyle("Refresh","visible","false");
		
		//setStyle("baseFrame","disable","true");
		setStyle("baseFr2","disable","true");
		setStyle("baseFr3","disable","true");
		setStyle("PendingFrm","disable","true");
		setStyle("BAFrm","disable","true");
		setStyle("CardsFrm","disable","true");
		setStyle("Frame1","disable","true");
		setStyle("Frame2","disable","true");
		setStyle("Frame3","disable","true");
		
		setStyle("AVAILABLE_BALANCE","disable","true");
	
		setControlValue("BAFrm", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		setControlValue("CardsFrm", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
		/*setControlValue("LabelBUUserName",getValue("BU_UserName"));
		setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
		setControlValue("LabelWiName",getValue("ProcessInstanceID"));
		setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));*/				
	}
}

function lockCAPSFrm()
{
    setStyle("DCI_CName","disable","true");
	setStyle("DCI_ExpD","disable","true");
	setStyle("DCI_DebitCN","disable","true");
	setStyle("DCI_MONO","disable","true");
	setStyle("DCI_CT","disable","true");
	setStyle("DCI_CAPS_GENSTAT","disable","true");
	setStyle("DCI_ELITECUSTNO","disable","true");
}

function clrCAPSFrm()
{
     setValue("DCI_CName", "");
     setValue("DCI_ExpD", "");
     setValue("DCI_DebitCN", "");
     setValue("DCI_MONO", "");
     setValue("DCI_CT", "");
     setValue("DCI_CAPS_GENSTAT", "");
     setValue("DCI_ELITECUSTNO", "");
	 showMessage("Cleared the fields from CAPS Fragment");

}

function clrValidationFrm()
{
   setControlValue("VD_DOB", "N");
	setControlValue("VD_StaffId", "N");
	setControlValue("VD_POBox", "N");
	setControlValue("VD_MoMaidN", "N");
	setControlValue("VD_MRT", "N");
	setControlValue("VD_EDC", "N");
	setControlValue("VD_TELNO", "N");
	//setControlValue("VD_Oth", "N");

	setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	setControlValue("VD_MoMaidN_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
	//setControlValue("VD_Oth", "false");
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
		setStyle("VD_MoMaidN_Check","disable","false");
		setStyle("VD_MRT_Check","disable","false");
		setStyle("VD_EDC_Check","disable","false");
		setStyle("VD_TELNO_Check","disable","false");
		//setStyle("VD_Oth_Check","disable","false");
		
		
	}
	else
	{
		setStyle("VD_TIN_Check","disable","false");
		setStyle("VD_DOB_Check","disable","true");
		setStyle("VD_StaffId_Check","disable","true");
		setStyle("VD_POBox_Check","disable","true");
		setStyle("VD_MoMaidN_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		//setStyle("VD_Oth_Check","disable","true");
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
				setStyle("HOST_OTHER","disable","false");
				setStyle("AVAILABLE_BALANCE","disable","false");
				setStyle("C_STATUS_A_BLOCK","disable","false");
				setStyle("C_STATUS_B_BLOCK","disable","false");
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
		
		if ((paramString == "") || (paramString== "--select--") || (paramString== "Customer Will Call Back") || (paramString== "Customer is overdue") || (paramString== "Customer is Over limit"))
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
 

function callPrintJSPDSRDCB(params)
{
	
	var mobNoClearTxt = getValue('DCI_MONO');
	var cardNoClearTxt = getValue('DCI_DebitCN');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt;
	var strUrl="/DSR_DCB/DSR_DCB/CustomJSP/PrintDCB.jsp?"+params;
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
	
	
}

function getTodayDate(){
	var today = new Date();
	var dd = String("0" + (today.getDate())).slice(-2); //Fix for IE
	var mm = String("0" + (today.getMonth() +1)).slice(-2); //January is 0! //Fix for IE
	var yyyy = today.getFullYear();
	today = dd + '/' + mm + '/' + yyyy;
	return today;
}


//setControlValue("BUUsername", getValue("BU_UserName"));
//setControlValue("BUDatetime", getValue("BU_DateTime"));
//setControlValue("wi_Name", str3);
//setControlValue("Branch", "Branch: " + getValue("USER_BRANCH"));