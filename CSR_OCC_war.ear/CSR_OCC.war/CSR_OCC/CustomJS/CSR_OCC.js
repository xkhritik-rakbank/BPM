var onLoad = document.createElement('script');
onLoad.src = '/CSR_OCC/CSR_OCC/CustomJS/CSR_OCC_onLoad.js';
document.head.appendChild(onLoad);

var mandatory = document.createElement('script');
mandatory.src = '/CSR_OCC/CSR_OCC/CustomJS/CSR_OCC_MandatoryFieldValidations.js';
document.head.appendChild(mandatory);
	
var onSaveDone = document.createElement('script');
onSaveDone.src = '/CSR_OCC/CSR_OCC/CustomJS/CSR_OCC_onSaveDone.js';
document.head.appendChild(onSaveDone);

var EventHandler = document.createElement('script');
EventHandler.src = '/CSR_OCC/CSR_OCC/CustomJS/CSR_OCC_EventHandler.js';
document.head.appendChild(EventHandler);

var Common = document.createElement('script');
Common.src = '/CSR_OCC/CSR_OCC/CustomJS/CSR_OCC_Common.js';
document.head.appendChild(Common);


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
	setCommonVariables();
	//setControlValue("wi_name",WorkitemNo);
	//getDropdownValues(ActivityName);
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
	
	setControlValue("LoggedInUser",user);
	setValue("CardNo_Text",getValue("CCI_CrdtCN"));
	setStyle("Pending_Decision","visible","false");
	setStyle("Refresh_Button","visible","false");
	setStyle("Top_Section","disable","true");
	setStyle("CAPS_Section","disable","true");
	setValue("ServiceType","CreditCard Service Request - Other Credit Card Requests(CSR_OCC)");
	setControlValue("CCI_ExpD","Masked");
	formloadvalidation ();
	var REQUEST_TYPE = getValue("request_type");
	setValue("request_type_label", REQUEST_TYPE);
	//alert("@@REQUEST_TYPE :"+REQUEST_TYPE);
	if (REQUEST_TYPE =="Early Card Renewal" || REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Card Delivery Request" || REQUEST_TYPE == "Re-Issue of PIN" || REQUEST_TYPE == "" || REQUEST_TYPE == null)
	{
		//var BranchName = executeServerEvent("BranchName","FormLoad","",true);
		//alert("@@BranchName :"+BranchName);
	}
	// CHANGES MADE HERE
	if (REQUEST_TYPE =="Early Card Renewal" || REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Card Delivery Request" || REQUEST_TYPE == "Credit Limit Increase" || REQUEST_TYPE == "Card Upgrade" || REQUEST_TYPE == "Setup Suppl. Card Limit")
	{
		setStyle("Cards_IsSRO","visible","true");
		
	}
	
	//setting checkbox values***************************************************
	if(getValue("VD_TINCheck") == "Y")
		setControlValue("VD_TIN_Check","true");
	else
		setControlValue("VD_TIN_Check","false");
	
	if(getValue("VD_DOB") == "Y")
		setControlValue("VD_DOB_Check","true");
	else
		setControlValue("VD_DOB_Check","false");
	
	if(getValue("VD_StaffId") == "Y")
		setControlValue("VD_StaffId_Check","true");
	else
		setControlValue("VD_StaffId_Check","false");
	
	if(getValue("VD_POBox") == "Y")
		setControlValue("VD_POBox_Check","true");
	else
		setControlValue("VD_POBox_Check","false");
	
	if(getValue("VD_PassNo") == "Y")
		setControlValue("VD_PassNo_Check","true");
	else
		setControlValue("VD_PassNo_Check","false");
	
	if(getValue("VD_Oth") == "Y")
		setControlValue("VD_Oth_Check","true");
	else
		setControlValue("VD_Oth_Check","false");
	
	if(getValue("VD_MRT") == "Y")
		setControlValue("VD_MRT_Check","true");
	else
		setControlValue("VD_MRT_Check","false");
	
	if(getValue("VD_EDC") == "Y")
		setControlValue("VD_EDC_Check","true");
	else
		setControlValue("VD_EDC_Check","false");
	
	if(getValue("VD_NOSC") == "Y")
		setControlValue("VD_NOSC_Check","true");
	else
		setControlValue("VD_NOSC_Check","false");
	
	if(getValue("VD_TELNO") == "Y")
		setControlValue("VD_TELNO_Check","true");
	else
		setControlValue("VD_TELNO_Check","false");
	
	if(getValue("VD_SD") == "Y")
		setControlValue("VD_SD_Check","true");
	else
		setControlValue("VD_SD_Check","false");
	
	if(getValue("VD_MoMaidN") == "Y")
		setControlValue("VD_MoMaidN_Check","true");
	else
		setControlValue("VD_MoMaidN_Check","false");
	//***********************************************************

	hideFrames(REQUEST_TYPE,ActivityName,"OnLoad");
	enableDisableAfterFormLoad();
	
	setAmountOnLOad("oth_cs_Amount", "oth_cs_Amount_Text");
	setAmountOnLOad("oth_ssc_Amount", "oth_ssc_Amount_Text");
	setAmountOnLOad("oth_td_Amount", "oth_td_Amount_Text");
	
	
}


function customValidationsBeforeSaveDone(op)
{	
	ActivityName =getWorkItemData("ActivityName");
	//enabledisabledate();
	if(op=="S")
	{
		setCustomControlsValue(op,ActivityName);
		return true;
	}
	else if (op=="I" || op=="D")
	{
		var REQUEST_TYPE = getValue("request_type");
		if(ActivityName == 'CARDS' && (REQUEST_TYPE =="Early Card Renewal" || REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Card Delivery Request" || REQUEST_TYPE == "Credit Limit Increase" || REQUEST_TYPE == "Card Upgrade" || REQUEST_TYPE == "Setup Suppl. Card Limit") && !(document.getElementById('Cards_IsSRO_0').checked==true || document.getElementById('Cards_IsSRO_1').checked==true))
		{
			
			alert("Please fill SRO Section");
			return false;
		}
		var flag = setCustomControlsValue(op,ActivityName);
	
	  /*	if(mandatoryFieldValidation()==false)
		{
			return false;
		}   */
		if(flag != "0")
		{
		var confirmDoneResponse = confirm("You are about to submit the workitem. Do you wish to continue?");
		
		if(confirmDoneResponse ==  true)
		{	
				var rejectReason = "rejectreason";
				var ActivityName =getWorkItemData("ActivityName");
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
						setValues({"USR_0_CSR_OCC_PENDING_SUB":""},true);
						setStyle("Others_Pending_SubReason","visible","true");
						setStyle("Others_Pending_SubReason","mandatory","true");
						setStyle("USR_0_CSR_OCC_PENDING_SUB","visible","false");
					}
					else if(getValue("Pending_Reason")=="Due to non receipt of"){
						setValues({"Others_Pending_SubReason":""},true);
						setStyle("USR_0_CSR_OCC_PENDING_SUB","visible","true");
						setStyle("USR_0_CSR_OCC_PENDING_SUB","mandatory","true");
						setStyle("Others_Pending_SubReason","visible","false");
					}
					else{
						setStyle("USR_0_CSR_OCC_PENDING_SUB","visible","false");
						setStyle("Others_Pending_SubReason","visible","false");
						setValues({"Others_Pending_SubReason":""},true);
						setValues({"USR_0_CSR_OCC_PENDING_SUB":""},true);
					}
				}
				break;
		/*case 'BA_Reject_change' : 
				if(ActivityName=="Branch_Approver"){
					if(getValue("BA_Reject")=="Others"){
						setValue("USR_0_CSR_CCC_BA_SUB_REASON","");
						setStyle("Others_BA","visible","true");
						setStyle("Others_BA","mandatory","true");
						setStyle("USR_0_CSR_CCC_BA_SUB_REASON","visible","false");
					}
					else if(getValue("BA_Reject")=="Due to non receipt of"){
						setValue("Others_BA","");
						setStyle("USR_0_CSR_CCC_BA_SUB_REASON","visible","true");
						setStyle("USR_0_CSR_CCC_BA_SUB_REASON","mandatory","true");
						setStyle("Others_BA","visible","false");
					}
					else{
						setStyle("USR_0_CSR_CCC_BA_SUB_REASON","visible","false");
						setStyle("Others_BA","visible","false");
						setValue("Others_BA","");
						setValue("USR_0_CSR_CCC_BA_SUB_REASON","");
					}
				}
				break;*/
		case 'Cards_Reject_change' : 
				if(ActivityName=="CARDS"){
					if(getValue("Cards_Reject")=="Others"){
						setValues({"USR_0_CSR_OCC_REJECT_SUB_REASON":""},true);
						setStyle("Others_Reject_Reason","visible","true");
						setStyle("Others_Reject_Reason","mandatory","true");
						setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","visible","false");
					}
					else if(getValue("Cards_Reject")=="Due to non receipt of"){
						setValues({"Others_Reject_Reason":""},true);
						setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","visible","true");
						setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","mandatory","true");
						setStyle("Others_Reject_Reason","visible","false");
					}
					else{
						setValues({"Others_Reject_Reason":""},true);
						setValues({"USR_0_CSR_OCC_REJECT_SUB_REASON":""},true);
						setStyle("Others_Reject_Reason","visible","false");
						setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","visible","false");
					}
				}
				break;
		case 'BR_Reject_change' : 
				if(ActivityName=="Branch_Return"){
					if(getValue("BR_Reject")=="Others"){
						setValues({"USR_0_CSR_OCC_BR_SUB_REASONS":""},true);
						setStyle("Others_BR","visible","true");
						setStyle("Others_BR","mandatory","true");
						setStyle("USR_0_CSR_OCC_BR_SUB_REASONS","visible","false");
					}
					else if(getValue("BR_Reject")=="Due to non receipt of"){
						setValues({"Others_BR":""},true);
						setStyle("USR_0_CSR_OCC_BR_SUB_REASONS","visible","true");
						setStyle("USR_0_CSR_OCC_BR_SUB_REASONS","mandatory","true");
						setStyle("Others_BR","visible","false");
					}
					else{
						setValues({"Others_BR":""},true);
						setValues({"USR_0_CSR_OCC_BR_SUB_REASONS":""},true);
						setStyle("Others_BR","visible","false");
						setStyle("USR_0_CSR_OCC_BR_SUB_REASONS","visible","false");
					}
				}
				break;	
		case 'Cards_IsSRO_0_change' :
				SetFieldValues(controlId,controlEvent);
				break;
		case 'Cards_IsSRO_1_change' :
				SetFieldValues(controlId,controlEvent);
				break;
		case 'BR_Decision_change' :
				SetFieldValues(controlId,controlEvent);
				setValues({"USR_0_CSR_OCC_BR_SUB_REASONS":""},true);
				setValues({"Others_BR":""},true);
				setValues({"BR_Reject":""},true);
				break;
		case 'Pending_Decision_change' :
				SetFieldValues(controlId,controlEvent);
				setValues({"USR_0_CSR_OCC_PENDING_SUB":""},true);
				setValues({"Others_Pending_SubReason":""},true);
				setValues({"Pending_Reason":""},true);
				break;
		case 'Cards_Decision_change' :
				SetFieldValues(controlId,controlEvent);
				setValues({"USR_0_CSR_OCC_REJECT_SUB_REASON":""},true);
				setValues({"Others_Reject_Reason":""},true);
				setValues({"Cards_Reject":""},true);
				break;
		case 'CardNo_Text_blur' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_ssc_Amount_Text_blur' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_cs_Amount_Text_blur' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_td_Amount_Text_blur' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'request_type_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_cr_DC_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'RIP_BRANCH_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'CR_BRANCH_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'CDR_BRANCH_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'ECR_BRANCH_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_TIN_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_DOB_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_StaffId_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_POBox_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_PassNo_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_Oth_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_MRT_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_EDC_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_NOSC_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_TELNO_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_SD_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'VD_MoMaidN_Check_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_rip_DC_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_ecr_dt_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_cdr_CDT_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_ssc_SCNo_Combo_change' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'Introduce_Button_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'Pending_Button_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'Print_Button_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'Refresh_Button_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_cs_CS_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_cs_CSR_Check_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_cr_reason_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
		
		case 'oth_cli_type_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_csi_PH_Combo_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_csi_TOH_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_csi_CSIP_Check_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_csi_CSID_Check_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'oth_csi_CDACNO_Check_click' : 
				SetFieldValues(controlId,controlEvent);
				break;
				
		case 'Clear_click' : 
				SetFieldValues(controlId,controlEvent);
				break;				
        case 'RaiseSRO_click' : 
				SetFieldValues(controlId,controlEvent);
				break;				
		
	}
}

function customListViewValidation(tableId,flag)
{
	/*if(tableId = "REJECT_REASON_GRID")
	{		
		var reasonVal = getSelectedItemLabel("table26_Reject Reason");
		//alert('reasonVal'+reasonVal);
		if(reasonVal=="Select")
		{
			showMessage(tableId,'Please Choose Valid Reject Reason',"error");
			return false;
		}

	}*/
	return true;
}
function formloadvalidation (){
	if(ActivityName == "CARDS"){
		if(getValue("Cards_Decision") == "CARDS_D"){
			setStyle("Cards_Reject","visible","true");
					if(getValue("Cards_Reject") == "Others"){
							setStyle("Others_Reject_Reason","visible","true");
							}
					else if (getValue("Cards_Reject") == "Due to non receipt of") {
					setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","visible","true");
					}
		}
	}
	/*else if (ActivityName == "Branch_Approver"){
	if(getValue("BA_Decision") == "BA_D"){
		setStyle("BA_Reject","visible","true");
				if(getValue("BA_Reject") == "Others"){
						setStyle("Others_BA","visible","true");
						}
				else if (getValue("BA_Reject") == "Due to non receipt of") {
				setStyle("USR_0_CSR_CCC_BA_SUB_REASON","visible","true");
				}
	}
	}*/
	else if (ActivityName == "Pending"){
		if(getValue("Pending_Decision") == "P_Discard"){
			setStyle("Pending_Reason","visible","true");
					if(getValue("Pending_Reason") == "Others"){
							setStyle("Others_Pending_SubReason","visible","true");
							}
					else if (getValue("Pending_Reason") == "Due to non receipt of") {
					setStyle("USR_0_CSR_OCC_PENDING_SUB","visible","true");
					}
		}
	}
    if(ActivityName !="CARDS"){
		if(getValue("Cards_Reject") != ""){
			setStyle("Cards_Reject","visible","true");
			setStyle("Cards_Reject","disable","true");
		}
		else if(getValue("Cards_Rework") != ""){
			setStyle("Cards_Rework","visible","true");
			setStyle("Cards_Rework","disable","true");
		}
		if(getValue("USR_0_CSR_OCC_REJECT_SUB_REASON") != ""){
			setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","visible","true");
			setStyle("USR_0_CSR_OCC_REJECT_SUB_REASON","disable","true");
		}
		else if (getValue("Others_Reject_Reason") != ""){
			setStyle("Others_Reject_Reason","visible","true");
			setStyle("Others_Reject_Reason","disable","true");
		}
	}
	 if(ActivityName !="Pending"){
		if(getValue("Pending_Reason") != ""){
			setStyle("Pending_Reason","visible","true");
			setStyle("Pending_Reason","disable","true");
		}
		if(getValue("USR_0_CSR_OCC_PENDING_SUB") != ""){
			setStyle("USR_0_CSR_OCC_PENDING_SUB","visible","true");
			setStyle("USR_0_CSR_OCC_PENDING_SUB","disable","true");
		}
		else if (getValue("Others_Pending_SubReason") != ""){
			setStyle("Others_Pending_SubReason","visible","true");
			setStyle("Others_Pending_SubReason","disable","true");
		}
	}
	else if(ActivityName=="Branch_Return"){
		if(getValue("BR_Reject")!=""){
			setStyle("BR_Reject","visible","true");
		}
		if(getValue("BR_Reject")=="Others"){
			setStyle("Others_BR","visible","true");
		}
		else if(getValue("BR_Reject")=="Due to non receipt of"){
			setStyle("USR_0_CSR_OCC_BR_SUB_REASONS","visible","true");
		}
	}
	 /*if(ActivityName !="Branch_Approver"){
		if(getValue("BA_Reject") != ""){
			setStyle("BA_Reject","visible","true");
			setStyle("BA_Reject","disable","true");
		}
		if(getValue("USR_0_CSR_CCC_BA_SUB_REASON") != ""){
			setStyle("USR_0_CSR_CCC_BA_SUB_REASON","visible","true");
			setStyle("USR_0_CSR_CCC_BA_SUB_REASON","disable","true");
		}
		else if (getValue("Others_BA") != ""){
			setStyle("Others_BA","visible","true");
			setStyle("Others_BA","disable","true");
		}
	}*/
}
