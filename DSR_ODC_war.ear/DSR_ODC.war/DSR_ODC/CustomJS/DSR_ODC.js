var onLoad = document.createElement('script');
onLoad.src = '/DSR_ODC/DSR_ODC/CustomJS/DSR_ODC_onLoad.js';
document.head.appendChild(onLoad);

var mandatory = document.createElement('script');
mandatory.src = '/DSR_ODC/DSR_ODC/CustomJS/DSR_ODC_MandatoryFieldValidations.js';
document.head.appendChild(mandatory);
	
var onSaveDone = document.createElement('script');
onSaveDone.src = '/DSR_ODC/DSR_ODC/CustomJS/DSR_ODC_onSaveDone.js';
document.head.appendChild(onSaveDone);

var EventHandler = document.createElement('script');
EventHandler.src = '/DSR_ODC/DSR_ODC/CustomJS/DSR_ODC_EventHandler.js';
document.head.appendChild(EventHandler);

var Common = document.createElement('script');
Common.src = '/DSR_ODC/DSR_ODC/CustomJS/DSR_ODC_Common.js';
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
	getDropdownValues(ActivityName);
	setCommonVariables();
	formloadvalidation ();
	setControlValue("wi_name",WorkitemNo);
	var REQUEST_TYPE = getValue("request_type");
	//alert("@@REQUEST_TYPE :"+REQUEST_TYPE);
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
	
	if (REQUEST_TYPE =="Early Card Renewal" || REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Card Delivery Request")
	{
		setStyle("Cards_IsSRO","visible","true");
	}
	
	if (REQUEST_TYPE =="Early Card Renewal")
		setControlValue("ECR_BRANCH",getValue("oth_ecr_bn"));
	else if(REQUEST_TYPE == "Card Replacement") 
		setControlValue("CR_BRANCH",getValue("oth_cr_BN"));
	else if(REQUEST_TYPE == "Card Delivery Request") 
		setControlValue("CDR_BRANCH",getValue("oth_cdr_BN"));
	else if(REQUEST_TYPE == "Re-Issue of PIN") 
		setControlValue("RIP_BRANCH",getValue("oth_rip_BN"));
	var BranchName = executeServerEvent("BranchName","FormLoad","",true);
		//alert("@@BranchName :"+BranchName);	
	/*if (REQUEST_TYPE =="Early Card Renewal" || REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Card Delivery Request" || REQUEST_TYPE == "Re-Issue of PIN" || REQUEST_TYPE == "" || REQUEST_TYPE == null)
	{
		var BranchName = executeServerEvent("BranchName","FormLoad","",true);
		alert("@@BranchName :"+BranchName);
	}  */
	setControlValue("LoggedInUser",user);
	setControlValue("request_type_Label",REQUEST_TYPE);
	setStyle("Hidden_Section","visible","false");
	enableDisableAfterFormLoad();
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
	
	if(getValue("VD_TELNO") == "Y")
		setControlValue("VD_TELNO_Check","true");
	else
		setControlValue("VD_TELNO_Check","false");
	
	if(getValue("VD_MoMaidN") == "Y")
		setControlValue("VD_MoMaidN_Check","true");
	else
		setControlValue("VD_MoMaidN_Check","false");
	//***********************************************************

	hideFrames(REQUEST_TYPE,ActivityName);
	

	
	
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
		var REQUEST_TYPE = getValue("request_type");
		if(ActivityName == 'CARDS' && (REQUEST_TYPE =="Early Card Renewal" || REQUEST_TYPE == "Card Replacement" || REQUEST_TYPE == "Card Delivery Request") && !(document.getElementById('Cards_IsSRO_0').checked==true || document.getElementById('Cards_IsSRO_1').checked==true))
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
				var cardNo = getValue('DCI_DebitCN');
				var MobileNo = getValue('DCI_MONO');
				if(ActivityName=='CARDS'){
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
						setValues({"USR_0_DSR_ODC_PENDING_SUB":""},true);
						setStyle("Others_Pending_SubReason","visible","true");
						setStyle("Others_Pending_SubReason","mandatory","true");
						setStyle("USR_0_DSR_ODC_PENDING_SUB","visible","false");
					}
					else if(getValue("Pending_Reason")=="Due to non receipt of"){
						setValues({"Others_Pending_SubReason":""},true);
						setStyle("USR_0_DSR_ODC_PENDING_SUB","visible","true");
						setStyle("USR_0_DSR_ODC_PENDING_SUB","mandatory","true");
						setStyle("Others_Pending_SubReason","visible","false");
					}
					else{
						setStyle("USR_0_DSR_ODC_PENDING_SUB","visible","false");
						setStyle("Others_Pending_SubReason","visible","false");
						setValues({"Others_Pending_SubReason":""},true);
						setValues({"USR_0_DSR_ODC_PENDING_SUB":""},true);
					}
				}
				break;
				
		case 'BR_Reject_change' : 
				if(ActivityName=="Branch_Return"){
					if(getValue("BR_Reject")=="Others"){
						setValues({"USR_0_DSR_ODC_RETURN_SUB_REASON":""},true);
						setStyle("Others_BR","visible","true");
						setStyle("Others_BR","mandatory","true");
						setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","visible","false");
					}
					else if(getValue("BR_Reject")=="Due to non receipt of"){
						setValues({"Others_BR":""},true);
						setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","visible","true");
						setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","mandatory","true");
						setStyle("Others_BR","visible","false");
					}
					else{
						setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","visible","false");
						setStyle("Others_BR","visible","false");
						setValues({"Others_BR":""},true);
						setValues({"USR_0_DSR_ODC_RETURN_SUB_REASON":""},true);
					}
				}
				break;
		
		case 'Cards_Reject_change' : 
				if(ActivityName=="CARDS"){
					if(getValue("Cards_Reject")=="Others"){
						setValues({"USR_0_DSR_ODC_REJECT_SUB_REASON":""},true);
						setStyle("Others_Reject_Reason","visible","true");
						setStyle("Others_Reject_Reason","mandatory","true");
						setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","visible","false");
					}
					else if(getValue("Cards_Reject")=="Due to non receipt of"){
						setValues({"Others_Reject_Reason":""},true);
						setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","visible","true");
						setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","mandatory","true");
						setStyle("Others_Reject_Reason","visible","false");
					}
					else{
						setValues({"Others_Reject_Reason":""},true);
						setValues({"USR_0_DSR_ODC_REJECT_SUB_REASON":""},true);
						setStyle("Others_Reject_Reason","visible","false");
						setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","visible","false");
					}
				}
				break;
		case 'Cards_IsSRO_0_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'Cards_IsSRO_1_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'Pending_Decision_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'Cards_Decision_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'BR_Decision_change' :
				SetEventValues(controlId,controlEvent);
				break;
	    case 'CardNo_Text_blur' : 
				SetEventValues(controlId,controlEvent);
				break;
	    
        case 'oth_td_Amount_Text_blur' : 
				SetEventValues(controlId,controlEvent);
				break;

        case 'request_type_change' : 
				SetEventValues(controlId,controlEvent);
				break;

        case 'RIP_BRANCH_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'CR_BRANCH_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'CDR_BRANCH_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'ECR_BRANCH_change' : 
				SetEventValues(controlId,controlEvent);
				break;
		
		
		case 'oth_rip_reason_change' : 
				SetEventValues(controlId,controlEvent);
				break;
		
		case 'oth_cr_reason_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'oth_cr_DC_change' : 
				SetEventValues(controlId,controlEvent);
				break;		
		
		case 'oth_rip_DC_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'oth_ecr_dt_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'oth_cdr_CDT_change' : 
				SetEventValues(controlId,controlEvent);
				break;		
				
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
       
        case 'VD_Oth_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_MRT_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_EDC_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
	   
	    case 'VD_TELNO_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'VD_MoMaidN_Check_change' : 
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

        case 'Clear_click' : 
				SetEventValues(controlId,controlEvent);
				break;
        
       
	    case 'oth_cr_reason_click' : 
				SetEventValues(controlId,controlEvent);
				break;	
				
		case 'RaiseSRO_click' : 
				SetEventValues(controlId,controlEvent);
				break;	
				
	}
}

function formloadvalidation (){
	if(ActivityName == "CARDS"){
	if(getValue("Cards_Decision") == "CARDS_D"){
		setStyle("Cards_Reject","visible","true");
				if(getValue("Cards_Reject") == "Others"){
						setStyle("Others_Reject_Reason","visible","true");
						}
				else if (getValue("Cards_Reject") == "Due to non receipt of") {
				setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","visible","true");
				}
	}
	}
	else if (ActivityName == "Branch_Return"){
	if(getValue("BR_Decision") == "Discard"){
		setStyle("BR_Reject","visible","true");
				if(getValue("BR_Reject") == "Others"){
						setStyle("Others_BR","visible","true");
						}
				else if (getValue("BR_Reject") == "Due to non receipt of") {
				setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","visible","true");
				}
	}
	}
	else if (ActivityName == "Pending"){
	if(getValue("Pending_Decision") == "P_Discard"){
		setStyle("Pending_Reason","visible","true");
				if(getValue("Pending_Reason") == "Others"){
						setStyle("Others_Pending_SubReason","visible","true");
						}
				else if (getValue("Pending_Reason") == "Due to non receipt of") {
				setStyle("USR_0_DSR_ODC_PENDING_SUB","visible","true");
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
		if(getValue("USR_0_DSR_ODC_REJECT_SUB_REASON") != ""){
			setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","visible","true");
			setStyle("USR_0_DSR_ODC_REJECT_SUB_REASON","disable","true");
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
		if(getValue("USR_0_DSR_ODC_PENDING_SUB") != ""){
			
			setStyle("USR_0_DSR_ODC_PENDING_SUB","visible","true");
			setStyle("USR_0_DSR_ODC_PENDING_SUB","disable","true");
		}
		else if (getValue("Others_Pending_SubReason") != ""){
			
			setStyle("Others_Pending_SubReason","visible","true");
			setStyle("Others_Pending_SubReason","disable","true");
		}

	}
	
	 if(ActivityName !="Branch_Return"){
		if(getValue("BR_Reject") != ""){
			setStyle("BR_Reject","visible","true");
			setStyle("BR_Reject","disable","true");
		}
		
		if(getValue("USR_0_DSR_ODC_RETURN_SUB_REASON") != ""){
			
			setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","visible","true");
			setStyle("USR_0_DSR_ODC_RETURN_SUB_REASON","disable","true");
		}
		else if (getValue("Others_BR") != ""){
			
			setStyle("Others_BR","visible","true");
			setStyle("Others_BR","disable","true");
		}
	}
	
	
}

