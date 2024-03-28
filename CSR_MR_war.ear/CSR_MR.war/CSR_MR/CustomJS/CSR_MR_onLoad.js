var CSR_MR_Common = document.createElement('script');
CSR_MR_Common.src = '/CSR_MR/CSR_MR/CustomJS/CSR_MR_Common.js';
document.head.appendChild(CSR_MR_Common);

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
   setValue("VD_DOB","N");
   setValue("VD_StaffId","N");
   setValue("VD_POBox","N");
   setValue("VD_PassNo","N");
   setValue("VD_Oth","N");
   setValue("VD_MRT","N");
   setValue("VD_EDC","N");
   setValue("VD_NOSC","N");
   setValue("VD_TELNO","N");
   setValue("VD_SD","N");
   
   
   setControlValue("VD_DOB_Check", "false");
	setControlValue("VD_StaffId_Check", "false");
	setControlValue("VD_POBox_Check", "false");
	setControlValue("VD_PassNo_Check", "false");
	setControlValue("VD_Oth_Check", "false");
	setControlValue("VD_MRT_Check", "false");
	setControlValue("VD_EDC_Check", "false");
	setControlValue("VD_NOSC_Check", "false");
	setControlValue("VD_TELNO_Check", "false");
	setControlValue("VD_SD_Check", "false");
   
 

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

function enableDisableAfterFormLoad(ActivityName) 
{

  if(ActivityName=='Work Introduction')
  {
    
    lockCAPSFrm();
	
	   setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","false");
		setStyle("Print_Section","visible","false");
		setStyle("Branch_Section","visible","false");
		setStyle("Buttons_Section","visible","true");
	
    if(getValue("CreditCardNo1").trim()=="")
    {
        setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Branch_Section","visible","true");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Pending_Section","visible","false");


    }
	if(getValue("CCI_CrdtCN").trim()=="")
    {
        setStyle("Credit_Card_Section","visible","true");
		setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Branch_Section","visible","true");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Pending_Section","visible","false");


    }
/*	else
	{
       var creditVal=getValue("CCI_CrdtCN");
	  
	  setControlValue("CardNo","(creditVal.substring(0, 4) + "-" + creditVal.substring(4, 8) + "-" + creditVal.substring(8, 12) + "-" + creditVal.substring(12))");   
	}  */
	lockValidationFrm(getValue("VD_MoMaidN_Check"));
	
	}
	if(ActivityName=="Pending")
	{   
	   //setStyle("USER_BRANCH","disable","true");
	   setStyle("LoggedInUser","disable","true");
	   //setStyle("BU_DateTime","disable","true");
	   setStyle("wi_name","disable","true");
	   setValue("LabelUserBranch", getValue("USER_BRANCH"));
	   setStyle("CCI_CName","disable","true");
	   setStyle("CCI_ExpD","disable","true");
	   setStyle("CCI_CrdtCN","disable","true");
	   setStyle("CCI_CCRNNo","disable","true");
	   setStyle("CCI_MONO","disable","true");
	   setStyle("CCI_AccInc","disable","true");
	   setStyle("CCI_CT","disable","true");
	   setStyle("CCI_CAPS_GENSTAT","disable","true");
	   setStyle("CCI_ELITECUSTNO","disable","true");
	   
	   setStyle("Credit_Card_Section","visible","true");
	   setStyle("Verification_Section","visible","true");
	   setStyle("Remarks_Section","visible","true");
	   setStyle("Pending_Section","visible","true");
	   setStyle("Branch_Section","visible","false");
	   setStyle("Buttons_Section","visible","false");
	   setStyle("Cards_Section","visible","false");
	   setStyle("Print_Section","visible","false");
	   setStyle("Refresh","Visible","false");
	 
	   
	   lockValidationFrm(getValue("VD_MoMaidN_Check"));
	   
	  /* setControlValue("LabelBUUserName",getValue("BU_UserName"));
	   setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
	   setControlValue("LabelWiName",getValue("ProcessInstanceID"));
	   setControlValue("LabelBranch","Branch: "+getValue("User_Branch")); */
	   
	  }
	  if(ActivityName=="CARDS")
	  {
         setValue("LabelUserBranch", getValue("USER_BRANCH"));
		  
		  //setStyle("USER_BRANCH","disable","true");
		   setStyle("LoggedInUser","disable","true");
		  // setStyle("BU_DateTime","disable","true");
		   setStyle("wi_name","disable","true");
		 setControlValue("Card_UserName",user);
		 // setControlValue("BR_UserName",user);
		 //var currentTime = new Date();
	     setValue("Card_DateTime", getTodayDate());
	     //setValue("Cards_Decision","");
	     //setValue("Cards_Remarks","");
		 
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
	     setStyle("Refresh","Visible","false");
	     
	     setStyle("REMARKS","disable","true");
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
		 
		 setStyle("Credit_Card_Section","visible","true");
	     setStyle("Verification_Section","visible","true");
	     setStyle("Remarks_Section","visible","true");
		 setStyle("Cards_Section","visible","true");
		 setStyle("Print_Section","visible","true");
	     setStyle("Pending_Section","visible","false");
	     setStyle("Branch_Section","visible","false");
	     setStyle("Buttons_Section","visible","false");
	    
	   
	     setValue("Cards_Section","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
	  
     			
	}
	if(ActivityName=="Branch_Return")
	{
		setValue("LabelUserBranch", getValue("USER_BRANCH"));
	  // setStyle("USER_BRANCH","disable","true");
	   setStyle("LoggedInUser","disable","true");
	  // setStyle("BU_DateTime","disable","true");
	   setStyle("wi_name","disable","true");
	   
	   setValue("Cards_Section","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
	   setStyle("Cards_Decision","disable","true");
	   setStyle("Cards_Remarks","disable","true");
       setStyle("CCI_CName","disable","true");
	   setStyle("CCI_ExpD","disable","true");
	   setStyle("CCI_CrdtCN","disable","true");
	   setStyle("CCI_CCRNNo","disable","true");
	   setStyle("CCI_MONO","disable","true");
	   setStyle("CCI_AccInc","disable","true");
	   setStyle("CCI_CT","disable","true");
	   setStyle("CCI_CAPS_GENSTAT","disable","true");
	   setStyle("CCI_ELITECUSTNO","disable","true");
	   setStyle("Refresh","visible","false");
	   
	   setStyle("Credit_Card_Section","visible","true");
	   setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Branch_Section","visible","false");
		setStyle("Buttons_Section","visible","false");
		setStyle("Print_Section","visible","false");
		setStyle("Pending_Section","visible","false");
	   
	   //lockValidationFrm(getValue("VD_MoMaidN_Check"));
	   
	   
	  }
	  
	  if (ActivityName=="Work Exit1" || ActivityName=="Discard1" || ActivityName=="Query" )
	  {
	   /* setControlValue("LabelBUUserName",getValue("BU_UserName"));
	    setControlValue("LabelBUDateTime",getValue("BU_DateTime"));
	    setControlValue("LabelWiName",WorkitemNo);
	    setControlValue("LabelBranch","Branch: "+getValue("User_Branch"));   */
		
		setValue("LabelUserBranch", getValue("USER_BRANCH"));
		//setStyle("USER_BRANCH","disable","true");
	   setStyle("LoggedInUser","disable","true");
	   //setStyle("BU_DateTime","disable","true");
	   setStyle("wi_name","disable","true");
		
		setValue("Cards_Section","Cards Details " + getValue("Card_UserName") + " " + getValue("Card_DateTime"));
		
		setStyle("Credit_Card_Section","visible","true");
	    setStyle("Verification_Section","visible","true");
		setStyle("Remarks_Section","visible","true");
		setStyle("Cards_Section","visible","true");
		setStyle("Branch_Section","visible","true");
		setStyle("Buttons_Section","visible","true");
		setStyle("Print_Section","visible","false");
		setStyle("Pending_Section","visible","false");
		setStyle("Refresh","Visible","false");
	
		
		
	  }
}


function callPrintJSPCSRMR(params)
{
	
	var mobNoClearTxt = getValue('CCI_MONO');
	var cardNoClearTxt = getValue('CCI_CrdtCN');
	params = params+"&" + "mobNoClearTxt=" + mobNoClearTxt+"&" + "cardNoClearTxt=" + cardNoClearTxt;
	var strUrl="/CSR_MR/CSR_MR/CustomJSP/PrintMR.jsp?"+params;
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
		var REQUEST_TYPE = getValue("CCI_REQUESTTYPE");
		if(REQUEST_TYPE == "OUTSTANDING ON CREDIT CARD"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Incorrect Service Type Selected");*/
			 addItemInCombo("Cards_Rework","Incorrect service Type Selected"); 
		} else if(REQUEST_TYPE == "EPP CONVERSION"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Cash Product Allocation Reason");
			addItemInCombo("Cards_Reject","Invoice Discrepancies");
			addItemInCombo("Cards_Reject","EPP Instruction request details not matching with PRIME Data");
			addItemInCombo("Cards_Reject","Incorrect Service Type Selected");
			addItemInCombo("Cards_Reject","Duplicate Request");*/
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Cash Product Allocation Reason");
			addItemInCombo("Cards_Rework","Invoice Discrepancies");
			addItemInCombo("Cards_Rework","EPP Instruction Request details not matching with PRIME Date");
			addItemInCombo("Cards_Rework","Incorrect Service Type Selected");
			addItemInCombo("Cards_Rework","Duplicate Request");	
		} else if(REQUEST_TYPE == "EPP CONVERSION SCHOOL EPP"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Cash Product Allocation Reason");
			addItemInCombo("Cards_Reject","Invoice Discrepancies");
			addItemInCombo("Cards_Reject","EPP Instruction request details not matching with PRIME Data");
			addItemInCombo("Cards_Reject","Incorrect Service Type Selected");
			addItemInCombo("Cards_Reject","Duplicate Request");*/
			 clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Cash Product Allocation Reason");
			addItemInCombo("Cards_Rework","Invoice Discrepancies");
			addItemInCombo("Cards_Rework","EPP Instruction Request details not matching with PRIME Date");
			addItemInCombo("Cards_Rework","Incorrect Service Type Selected");
			addItemInCombo("Cards_Rework","Duplicate Request");	 
		} 
		else if(REQUEST_TYPE == "EXCESS CREDIT"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Documentation Not Provided");
			addItemInCombo("Cards_Reject","Beneficiary Details not recieved or not correct");
			addItemInCombo("Cards_Reject","Duplicate Request");*/
			 clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Documentation Not Provided");
			addItemInCombo("Cards_Rework","Beneficiary Details not recieved or not correct");
			addItemInCombo("Cards_Rework","Duplicate Request"); 
		}
		else if(REQUEST_TYPE == "BLOCKING/UNBLOCKING OF CARD"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Documentation Criteria not met");
			addItemInCombo("Cards_Reject","Eligibility Criteria not met");
			addItemInCombo("Cards_Reject","Duplicate Request");
			addItemInCombo("Cards_Reject","Customer response awaited");
			addItemInCombo("Cards_Reject","Confidential reasons to bank");*/
			 clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Incomplete Request");
			addItemInCombo("Cards_Rework","Documents Not Provided");
			addItemInCombo("Cards_Rework","Remarks not clear");
			addItemInCombo("Cards_Rework","As per Email/Remark received from contact center");
			addItemInCombo("Cards_Rework","Others"); 
		}
		else if(REQUEST_TYPE == "TRANSFER"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Documentation Not Provided");
			addItemInCombo("Cards_Reject","Beneficiary Details not recieved or not correct");
			addItemInCombo("Cards_Reject","Duplicate Request");*/
			 clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Documentation Not Provided");
			addItemInCombo("Cards_Rework","Beneficiary Details not recieved or not correct");
			addItemInCombo("Cards_Rework","Duplicate Request"); 
		}
		else if(REQUEST_TYPE == "DUPLICATE PAYMENT"){
			/*clearComboOptions("Cards_Reject");
			addItemInCombo("Cards_Reject","Documentation Not Provided");
			addItemInCombo("Cards_Reject","Beneficiary Details not recieved or not correct");
			addItemInCombo("Cards_Reject","Duplicate Request");*/
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Documentation Not Provided");
			addItemInCombo("Cards_Rework","Beneficiary Details not recieved or not correct");
			addItemInCombo("Cards_Rework","Duplicate Request");
		}
		else if(REQUEST_TYPE == "LIMIT DECREASE"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Incomplete Request")
			addItemInCombo("Cards_Rework","Remarks not clear ")
			addItemInCombo("Cards_Rework","Limit is not as per the Card Product")
			addItemInCombo("Cards_Rework","O/S balance > required limit")
			addItemInCombo("Cards_Rework","As per Email/Remark received from contact center")
			addItemInCombo("Cards_Rework","Others")			
		}
		else if(REQUEST_TYPE == "STATEMENT DATE CHANGE"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Incomplete Request")
			addItemInCombo("Cards_Rework","Remarks not clear")
			addItemInCombo("Cards_Rework","Statement Date not as per Bank Defined Date ")
			addItemInCombo("Cards_Rework","SME Card Statement Date is always 21st")
			addItemInCombo("Cards_Rework","Card is in SPCL Status")
			addItemInCombo("Cards_Rework","As per Email/Remark received from Contact Center ")
			addItemInCombo("Cards_Rework","Others")
		}
		else if(REQUEST_TYPE == "CLOSURE OF IM"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Shortfall in Payment")
			addItemInCombo("Cards_Rework","Customer not Contactable for Confirmation")			
		}
		else if(REQUEST_TYPE == "CASHBACK REDEMPTION"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Mentioned amount is not available on the reward box ")
		}
		else if(REQUEST_TYPE == "DUPLICATE STATEMENT"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Documentation not provided")
			addItemInCombo("Cards_Rework","Beneficiary details not received or not correct")
			addItemInCombo("Cards_Rework","Duplicate Request")
		}
		else if(REQUEST_TYPE == "CREDIT CARD CLOSURE/CANCELLATION"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Incomplete Request")
			addItemInCombo("Cards_Rework","Documents Not Provided")
			addItemInCombo("Cards_Rework","PB cannot initiate closure under this status")
			addItemInCombo("Cards_Rework","As per Email/Remark received from contact center")
			addItemInCombo("Cards_Rework","Others")
		}
		else if(REQUEST_TYPE == "AIR ARABIA EMAIL UPDATE"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Incomplete Request")
			addItemInCombo("Cards_Rework","Documents Not Provided")
			addItemInCombo("Cards_Rework","As per Email/Remark received from contact center")
			addItemInCombo("Cards_Rework","Others")
		}
		else if(REQUEST_TYPE == "DUPLICATE STATEMENT REQUEST"){
			clearComboOptions("Cards_Rework");
			addItemInCombo("Cards_Rework","Available balance not available for charge recovery")
			addItemInCombo("Cards_Rework","Card Statement not generated")
			addItemInCombo("Cards_Rework","Card Status Collection / Closure")
		}
	}
}