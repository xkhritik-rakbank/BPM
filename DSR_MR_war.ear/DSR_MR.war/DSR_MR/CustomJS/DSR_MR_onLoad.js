var DSR_MR_Common = document.createElement('script');
DSR_MR_Common.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_Common.js';
document.head.appendChild(DSR_MR_Common);

function loadSolId()
{
	
	var solId = executeServerEvent("SolId","FormLoad",user,true).trim();
	setControlValue("Sol_Id",solId);
}


function enableDisableAfterFormLoad(ActivityName)
{
	//alert("inside enableAfterFormLoad");
	if(ActivityName=='Work Introdution')
	{
    //alert("inside work introduction of of enableAfterFormLoad");
    lockCAPSFrm();
    if(getValue("DCI_DebitCN").trim()=="")
    {
        setStyle("Debit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		setStyle("Branch_Section","visible","false");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","true");
    }
			lockValidationFrm(getValue("VD_MoMaidN_Check"));
	//alert("e l ");
	}
	
	if(ActivityName=='CARDS')
	{	
	    setStyle("Debit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Print_Section","visible","true");
		setStyle("Branch_Section","visible","false");
		setStyle("Buttons_Section","visible","false");
		setStyle("Pending_Section","visible","false");
	}
	
	if(ActivityName=='Branch_Approver')
	{		
		setStyle("BA_UserName","visible","false");
		setStyle("BA_DateTime","visible","false");
		
		//setValue("BA_Decision","");
		//setValue("BA_Remarks","");
	}
	
	if(ActivityName=='Pending' || ActivityName=='Branch_Return')
	{	
	    setStyle("BU_UserName","visible","false");
	    setStyle("BU_DateTime","visible","false");
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
 //alert("Clear the fields from CAPS Fragment");
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
	//setControlValue("VD_MoMaidN", "N");
	setControlValue("VD_MRT", "N");
	setControlValue("VD_EDC", "N");
	setControlValue("VD_TELNO", "N");
	setControlValue("VD_Oth", "N");

	setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	//setControlValue("VD_MoMaidN_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
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
		//setStyle("VD_MoMaidN_Check","disable","false");
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
		//setStyle("VD_MoMaidN_Check","disable","true");
		setStyle("VD_MRT_Check","disable","true");
		setStyle("VD_EDC_Check","disable","true");
		setStyle("VD_TELNO_Check","disable","true");
		setStyle("VD_Oth_Check","disable","true");
	}
}

function visibleAfterFormLoad(ActivityName) 
{
	//alert("Inside visibleAfterFormLoad");
	if(ActivityName=='Work Introduction')
	{
		//alert("inside work introduction of visibleAfterFormLoad");
		lockCAPSFrm();
		if(getValue("DCI_DebitCN").trim()=="")
		{
		setStyle("Dredit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		setStyle("Branch_Section","visible","false");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","true");
		}
			lockValidationFrm(getValue("VD_MoMaidN_Check"));
	}
	
	if(ActivityName=='Pending')
	{   
	   setStyle("DCI_CName","disable","true");
	   setStyle("DCI_DebitCN","disable","true");
	   setStyle("DCI_ExtNo","disable","true");
	   setStyle("DCI_ExpD","disable","true");
	   setStyle("DCI_CCRNNo","disable","true");
	   setStyle("DCI_MONO","disable","true");
	   setStyle("DCI_ADCInc","disable","true");
	   setStyle("DCI_CT","disable","true");
	   setStyle("DCI_CAPS_GENSTAT","disable","true");
	   setStyle("DCI_ELITECUSTNO","disable","true");
	   
	   setStyle("Debit_Card_Section","visible","true");
	   setStyle("Verification_Section","visible","true");
	   setStyle("Remarks_Section","visible","true");
	   setStyle("Pending_Section","visible","true");
	   setStyle("Branch_Section","visible","false");
	   setStyle("Buttons_Section","visible","false");
	   setStyle("Cards_Section","visible","false");
	   setStyle("Print_Section","visible","false");
	  
			lockValidationFrm(getValue("VD_MoMaidN_Check"));
	   
	   setValue("LabelBUUserName",getValue("BU_UserName"));
	   setValue("LabelBUDateTime",getValue("BU_DateTime"));
	   setValue("LabelWiName",getValue("ProcessInstanceID"));
	   setValue("LabelBranch","Branch: "+getValue("USER_BRANCH"));
	}
	
	if(ActivityName=='CARDS')
	{
		/*setControlValue("LabelBUUserName",getValue("BU_UserName"));
	    setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
	    setControlValue("LabelWiName",getValue("WorkitemNo"));
		setControlValue("LabelBranch","Branch: "+getValue("USER_BRANCH"));
	    setControlValue("Card_UserName","Branch: "+getValue("user"));
		var currentTime = new Date();
	    setControlValue("Card_DateTime","Branch: "+getValue("currentTime")); */
		
		setStyle("Debit_Card_Section","visible","true");
	    setStyle("Verification_Section","visible","true");
	    setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Print_Section","visible","true");
	    setStyle("Pending_Section","visible","false");
	    setStyle("Branch_Section","visible","false");
	    setStyle("Buttons_Section","visible","false");
		
		setStyle("DCI_CName","disable","true");
	    setStyle("DCI_ExpD","disable","true");
	    setStyle("DCI_DebitCN","disable","true");
	    setStyle("DCI_CCRNNo","disable","true");
	    setStyle("DCI_MONO","disable","true");
	    setStyle("DCI_ADCInc","disable","true");
	    setStyle("DCI_CT","disable","true");
	    setStyle("DCI_CAPS_GENSTAT","disable","true");
	    setStyle("DCI_ELITECUSTNO","disable","true");
	    setStyle("DCI_ExtNo","disable","true");
		
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
	
	    setStyle("REMARKS","disable","true");
		
		setValue("Cards_Section","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));    			
	}
	
	if(ActivityName=='Branch_Return')
	{
	    setValue("Cards_Section","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
	    setStyle("Cards_Decision","disable","true");
	    setStyle("Cards_Remarks","disable","true");
	    setStyle("DCI_CName","disable","true");
	    setStyle("DCI_ExpD","disable","true");
	    setStyle("DCI_DebitCN","disable","true");
	    setStyle("DCI_CCRNNo","disable","true");
	    setStyle("DCI_MONO","disable","true");
	    setStyle("DCI_ADCInc","disable","true");
	    setStyle("DCI_CT","disable","true");
	    setStyle("DCI_CAPS_GENSTAT","disable","true");
	    setStyle("DCI_ELITECUSTNO","disable","true");
	    setStyle("DCI_ExtNo","disable","true");
	    /*setStyle("VD_TIN_Check","disable","true");
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
		setStyle("VD_SD_Check","disable","true");*/
	    setStyle("REMARKS","disable","false");
		
		setStyle("Debit_Card_Section","visible","true");
	    setStyle("Verification_Section","visible","true");
	    setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Print_Section","visible","false");
	    setStyle("Pending_Section","visible","false");
	    setStyle("Branch_Section","visible","false");
	    setStyle("Buttons_Section","visible","false");
	   	lockValidationFrm(getValue("VD_MoMaidN_Check"));
	   
	   setValue("LabelBUUserName",getValue("BU_UserName"));
	   setValue("LabelBUDateTime",getValue("BU_DateTime"));
	   setValue("LabelWiName",WorkitemNo);
	   setValue("LabelBranch","Branch: "+getValue("USER_BRANCH"));
	  
	  }
	  
	  if (ActivityName=='Work Exit1' || ActivityName=='Discard1' || ActivityName=='Query' )
	  {
	    setValue("LabelBUUserName",getValue("BU_UserName"));
	    setValue("LabelBUDateTime",getValue("BU_DateTime"));
	    setValue("LabelWiName",WorkitemNo);
	    setValue("LabelBranch","Branch: "+getValue("USER_BRANCH"));
		
		//setControlValue("Cards_Section","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
		setStyle("Debit_Card_Section","visible","true");
	    setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Branch_Section","visible","true");
		setStyle("Buttons_Section","visible","false");
		setStyle("Print_Section","visible","false");
		setStyle("Pending_Section","visible","false");
		
		setStyle("Debit_Card_Section","disable","true");
	    setStyle("Verification_Section","disable","true");
		setStyle("Remarks_Section","disable","true");
		setStyle("Cards_Section","disable","true");
		setStyle("Branch_Section","disable","true");
		setStyle("Buttons_Section","disable","false");
		setStyle("Print_Section","disable","false");
		setStyle("Pending_Section","disable","false");
		
		setValue("BAFrm", "Branch Approver Details " + getValue("BA_UserName") + " " + getValue("BA_DateTime"));
		setValue("CardsFrm", "Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
		}
	  
		
}

function callPrintJSPDSRMR(params)
{
	
	var mobNoClearTxt = getValue('DCI_MONO');
	var cardNoClearTxt = getValue('DCI_DebitCN');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt;
	var strUrl="/DSR_MR/DSR_MR/CustomJSP/PrintMR.jsp?"+params;
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