var CSR_MR_onLoad = document.createElement('script');
	CSR_MR_onLoad.src = '/CSR_MR/CSR_MR/CustomJS/CSR_MR_onLoad.js';
	document.head.appendChild(CSR_MR_onLoad);
	
var CSR_MR_mandatory = document.createElement('script');
	CSR_MR_mandatory.src = '/CSR_MR/CSR_MR/CustomJS/CSR_MR_MandatoryFieldValidations.js';
	document.head.appendChild(CSR_MR_mandatory);

	
var CSR_MR_onSaveDone = document.createElement('script');
CSR_MR_onSaveDone.src = '/CSR_MR/CSR_MR/CustomJS/CSR_MR_onSaveDone.js';
document.head.appendChild(CSR_MR_onSaveDone);

var CSR_MR_Common = document.createElement('script');
CSR_MR_Common.src = '/CSR_MR/CSR_MR/CustomJS/CSR_MR_Common.js';
document.head.appendChild(CSR_MR_Common);


var CSR_MR_EventHandler = document.createElement('script');
CSR_MR_EventHandler.src = '/CSR_MR/CSR_MR/CustomJS/CSR_MR_EventHandler.js';
document.head.appendChild(CSR_MR_EventHandler);






function setCommonVariables()
{
	Processname = getWorkItemData("ProcessName");
	ActivityName =getWorkItemData("ActivityName");
	WorkitemNo =getWorkItemData("processinstanceid");
	cabName =getWorkItemData("cabinetname");
	user= getWorkItemData("username");	
	//alert("user--"+user);
	viewMode=window.parent.wiViewMode;	
}


function afterFormload()
{	
    if(document.getElementById('Cards_IsSRO_0').checked==true)
	{
		setStyle("Cards_STR","visible","true");
		setStyle("Cards_TeamCode","visible","true");
		setStyle("Cards_SRORemarks","visible","true");
		setStyle("Cards_SRONo","visible","true");
		setStyle("Cards_SROStatus","visible","true");
		setStyle("Cards_STR","mandatory","true");
		setStyle("Cards_TeamCode","mandatory","true");
		setStyle("Cards_SRORemarks","mandatory","true");
		setStyle("RaiseSRO","visible","true");
	}
	if(!(getValue('Cards_SRONo')==''))
	{
		setStyle("Cards_IsSRO","disable","true");
		setStyle("RaiseSRO","disable","true");
		setStyle("Cards_STR","disable","true");
		setStyle("Cards_TeamCode","disable","true");
		setStyle("Cards_SRORemarks","disable","true");
		setStyle("Cards_SRONo","disable","true");
		setStyle("Cards_SROStatus","disable","true");
	}
	setCommonVariables();
	
	//visibleAfterFormLoad(ActivityName);
	getDropdownValues(ActivityName);
	
	enableDisableAfterFormLoad(ActivityName);
	setValue("wi_name",WorkitemNo);
	//setValue("LabelWiName",WorkitemNo);
	setValue("LoggedInUser",user);
	setControlValue("CCI_ExpD","Masked");
	
	//setValuesOnload(user);
	setStyle("Hidden_Section","visible","false");
	//RequestType Change
	var REQUEST_TYPE = getValue("CCI_REQUESTTYPE");
	setValue("CCI_REQUESTTYPE_label", REQUEST_TYPE);
	if (REQUEST_TYPE =="STATEMENT DATE CHANGE")
	{
		var workstep =  getWorkItemData("ActivityName");
		if (workstep == "CARDS")
		{
			setStyle("StatementDateChange","visible","true");
			addItemInCombo('Cards_Decision','Deferred','Deferred');//added by stutee.mishra
		}
	}
	if (REQUEST_TYPE =="LIMIT DECREASE" || REQUEST_TYPE == "BLOCKING/UNBLOCKING OF CARD")
	{
		setStyle("Cards_IsSRO","visible","true");
	}
	if (REQUEST_TYPE =="OUTSTANDING ON CREDIT CARD")
	{
		setStyle("Cards_Outstanding","visible","true");
		setStyle("Cards_Outstanding","mandatory","true");
		
	}
	if( REQUEST_TYPE == "EPP CONVERSION" ) {
		setStyle("Curr_Amount","visible","true");
		setStyle("Curr_Amount","mandatory","true");
		setStyle("Merchant_Name","visible","true");
		setStyle("Merchant_Name","mandatory","true");
	}
	if( REQUEST_TYPE == "EXCESS CREDIT" || REQUEST_TYPE == "TRANSFER" || REQUEST_TYPE == "DUPLICATE PAYMENT" ) {
		setStyle("Curr_Amount","visible","true");
		setStyle("Curr_Amount","mandatory","true");
		
	}
	 
	if(REQUEST_TYPE == "EPP CONVERSION SCHOOL EPP"){
		setStyle("Curr_Amount","visible","true");
		setStyle("Curr_Amount","mandatory","true");
		setStyle("SchoolName","visible","true");
		setStyle("SchoolName","mandatory","true");
	}
	//alert("@@REQUEST_TYPE :"+REQUEST_TYPE);
	/*if (CCI_REQUESTTYPE =="Early Card Renewal" || CCI_REQUESTTYPE == "Card Replacement" || CCI_REQUESTTYPE == "Card Delivery Request" || CCI_REQUESTTYPE == "Re-Issue of PIN" || CCI_REQUESTTYPE == "" || CCI_REQUESTTYPE == null)
	{
		//var BranchName = executeServerEvent("BranchName","FormLoad","",true);
		//alert("@@BranchName :"+BranchName);
	}
	*/
	
	if(getValue("VD_TINCheck") == "Y")
		setValue("VD_TIN_Check","true");
	else
		setValue("VD_TIN_Check","false");
	
	if(getValue("VD_DOB") == "Y")
		setValue("VD_DOB_Check","true");
	else
		setValue("VD_DOB_Check","false");
	
	if(getValue("VD_StaffId") == "Y")
		setValue("VD_StaffId_Check","true");
	else
		setValue("VD_StaffId_Check","false");
	
	if(getValue("VD_POBox") == "Y")
		setValue("VD_POBox_Check","true");
	else
		setValue("VD_POBox_Check","false");
	
	if(getValue("VD_PassNo") == "Y")
		setValue("VD_PassNo_Check","true");
	else
		setValue("VD_PassNo_Check","false");
	
	if(getValue("VD_Oth") == "Y")
		setValue("VD_Oth_Check","true");
	else
		setValue("VD_Oth_Check","false");
	
	if(getValue("VD_MRT") == "Y")
		setValue("VD_MRT_Check","true");
	else
		setValue("VD_MRT_Check","false");
	
	if(getValue("VD_EDC") == "Y")
		setValue("VD_EDC_Check","true");
	else
		setValue("VD_EDC_Check","false");
	
	if(getValue("VD_NOSC") == "Y")
		setValue("VD_NOSC_Check","true");
	else
		setValue("VD_NOSC_Check","false");
	
	if(getValue("VD_TELNO") == "Y")
		setValue("VD_TELNO_Check","true");
	else
		setValue("VD_TELNO_Check","false");
	
	if(getValue("VD_SD") == "Y")
		setValue("VD_SD_Check","true");
	else
		setValue("VD_SD_Check","false");
	
	if(getValue("VD_MoMaidN") == "Y")
		setValue("VD_MoMaidN_Check","true");
	else
		setValue("VD_MoMaidN_Check","false");
}

function customValidationsBeforeSaveDone(op)
{	
	var ActivityName =getWorkItemData("ActivityName");
	if(op=="S")
	{
		setCustomControlsValue();
		return true;
	}
	else if (op=="I" || op=="D")
	{
		var REQUEST_TYPE = getValue("CCI_REQUESTTYPE");
		if(ActivityName == 'CARDS' && (REQUEST_TYPE =="LIMIT DECREASE" || REQUEST_TYPE == "BLOCKING/UNBLOCKING OF CARD") && !(document.getElementById('Cards_IsSRO_0').checked==true || document.getElementById('Cards_IsSRO_1').checked==true))
		{
			alert("Please fill SRO Section");
			return false;
		}
		
		if(setCustomControlsValue()==false)
		{
			return false;
		}
		
		
		var confirmDoneResponse = confirm("You are about to submit the workitem. Do you wish to continue?");
		
		if(confirmDoneResponse ==  true)
		{	
				var rejectReason = "rejectreason";
				var cardNo = getValue('CCI_CrdtCN');
				var MobileNo = getValue('CCI_MONO');
				if(ActivityName=='Branch_Approver'){
					if(getValue("BA_Decision")=="BA_D"){
					rejectReason = getValue("BA_Reject");
					}
				}
				else if(ActivityName=='CARDS'){
					if(getValue("Cards_Decision")=="CARDS_D"){
					rejectReason = getValue('Cards_Reject');
					}
				}
				var data = cardNo+'-'+MobileNo+'-'+rejectReason;
				console.log("data----->"+data)
				var res = executeServerEvent("mailTrigger", "INTRODUCEDONE", data, true);
			//setCustomControlsValue();
			//insertIntoHistoryTable();
			//setArchivalPath(ActivityName);
			saveWorkItem();
			return true;
		}
		else
		{
			return false;
		}
	}
	return true;
}


function eventDispatched(controlObj,eventObj)
{
	var controlId=controlObj.id;
	var controlEvent=eventObj.type;
	var ControlIdandEvent = controlId+'_'+controlEvent;
	
	switch(ControlIdandEvent)
	{
		case 'Pending_Reason_change' : 
				if(ActivityName=="Pending"){
					if(getValue("Pending_Reason")=="Others"){
						setValues({"USR_0_CSR_MR_PENDING_SUB":""},true);
						setStyle("Others_Pending","visible","true");
						setStyle("Others_Pending","mandatory","true");
						setStyle("USR_0_CSR_MR_PENDING_SUB","visible","false");
					}
					else if(getValue("Pending_Reason")=="Due to non receipt of"){
						setValues({"Others_Pending":""},true);
						setStyle("USR_0_CSR_MR_PENDING_SUB","visible","true");
						setStyle("USR_0_CSR_MR_PENDING_SUB","mandatory","true");
						setStyle("Others_Pending","visible","false");
					}
					else{
						setStyle("USR_0_CSR_MR_PENDING_SUB","visible","false");
						setStyle("Others_Pending","visible","false");
						setValues({"Others_Pending":""},true);
						setValues({"USR_0_CSR_MR_PENDING_SUB":""},true);
					}
				}
				break;
		case 'Cards_Reject_change' : 
				if(ActivityName=="CARDS"){
					if(getValue("Cards_Reject")=="Others"){
						setValues({"USR_0_CSR_MR_SUB_REASONS":""},true);
						setStyle("Others_Cards","visible","true");
						setStyle("Others_Cards","mandatory","true");
						setStyle("USR_0_CSR_MR_SUB_REASONS","visible","false");
					}
					else if(getValue("Cards_Reject")=="Due to non receipt of"){
						setValues({"Others_Cards":""},true);
						setStyle("USR_0_CSR_MR_SUB_REASONS","visible","true");
						setStyle("USR_0_CSR_MR_SUB_REASONS","mandatory","true");
						setStyle("Others_Cards","visible","false");
					}
					else{
						setStyle("USR_0_CSR_MR_SUB_REASONS","visible","false");
						setStyle("Others_Cards","visible","false");
						setValues({"Others_Cards":""},true);
						setValues({"USR_0_CSR_MR_SUB_REASONS":""},true);
					}
				}
				break;		
		case 'Cards_IsSRO_0_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'Cards_IsSRO_1_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'BR_Decision_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'Pending_Decision_change' :
				SetEventValues(controlId,controlEvent);
				setValues({"USR_0_CSR_MR_PENDING_SUB":""},true);
				setValues({"Others_Pending":""},true);
				setValues({"Pending_Reason":""},true)
				break;
		case 'Cards_Decision_change' :
				setValues({"USR_0_CSR_MR_SUB_REASONS":""},true);
				setValues({"Others_Cards":""},true);
				setValues({"Cards_Reject":""},true)
				SetEventValues(controlId,controlEvent);
				break;
		case 'CardNo_change' : 
				SetEventValues(controlId,controlEvent);
				break;
	    case 'Pending_click' : 
				SetEventValues(controlId,controlEvent);
				break;
		case 'Print_click' : 
				SetEventValues(controlId,controlEvent);
				break;
		case 'Exit_click' : 
				SetEventValues(controlId,controlEvent);
				break;	
        case 'Introduce_click' : 
				SetEventValues(controlId,controlEvent);
				break;				
		case 'Refresh_click' : 
				SetEventValues(controlId,controlEvent);
				break;	
			
        /*case 'VD_TINCheck_click' : 
				SetEventValues(controlId,controlEvent);
				break;*/  	
              
		case 'VD_TIN_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_DOB_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_StaffId_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_POBox_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_PassNo_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_Oth_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_MRT_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_EDC_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_NOSC_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_TELNO_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_SD_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_MoMaidN_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
       case 'Clear_click' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'RaiseSRO_click' : 
				SetEventValues(controlId,controlEvent);
				break;		
		
	}
} 


function customListViewValidation(tableId,flag)
{
	if(tableId = "REJECT_REASON_GRID")
	{		
		var reasonVal = getSelectedItemLabel("table26_Reject Reason");
		//alert('reasonVal'+reasonVal);
		if(reasonVal=="Select")
		{
			showMessage(tableId,'Please Choose Valid Reject Reason',"error");
			return false;
		}

	}
	return true;
}
