var DSR_MR_onLoad = document.createElement('script');
	DSR_MR_onLoad.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_onLoad.js';
	document.head.appendChild(DSR_MR_onLoad);
	
var DSR_MR_mandatory = document.createElement('script');
	DSR_MR_mandatory.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_MandatoryFieldValidations.js';
	document.head.appendChild(DSR_MR_mandatory);

	
var DSR_MR_onSaveDone = document.createElement('script');
DSR_MR_onSaveDone.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_onSaveDone.js';
document.head.appendChild(DSR_MR_onSaveDone);

var DSR_MR_Common = document.createElement('script');
DSR_MR_Common.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_Common.js';
document.head.appendChild(DSR_MR_Common);


var DSR_MR_EventHandler = document.createElement('script');
DSR_MR_EventHandler.src = '/DSR_MR/DSR_MR/CustomJS/DSR_MR_EventHandler.js';
document.head.appendChild(DSR_MR_EventHandler);






function setCommonVariables()
{
	Processname = getWorkItemData("ProcessName");
	ActivityName =getWorkItemData("ActivityName");
	WorkitemNo =getWorkItemData("processinstanceid");
	cabName =getWorkItemData("cabinetname");
	user= getWorkItemData("username");	
	////alert("user--"+user);
	viewMode=window.parent.wiViewMode;	
}


function afterFormload()
{	
    ////alert("afterFormload");
	setCommonVariables();
	setValue("wi_name",WorkitemNo);
	setValue("LoggedInUser",user);
	//setControlValue("BU_DateTime",IntroductionDateTime);
	//setValue("USER_BRANCH","Adminstrator");
    ////alert("user"+user);
	setStyle("BU_DateTime","visible","true");
	setStyle("Hidden_Section","visible","false")
	setStyle("Debit_Card_Section","disable","true");
	setStyle("Refresh","visible","false");
	formloadvalidation ();

	//alert("sdsd");
	//setStyle("Top_Section","disable","true");



    visibleAfterFormLoad(ActivityName);
	
	enableDisableAfterFormLoad(ActivityName);
	////alert("after the enabledisable");

	
	
	
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
}


function customValidationsBeforeSaveDone(op)
{	
	//enabledisabledate();
	if(op=="S")
	{
		setCustomControlsValue(op,ActivityName);
		return true;
	}
	else if (op=="I" || op=="D")
	{
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
						setValues({"USR_0_DSR_MR_PENDING_SUB":""},true);
						setStyle("Others_Pending_SubReason","visible","true");
						setStyle("Others_Pending_SubReason","mandatory","true");
						setStyle("USR_0_DSR_MR_PENDING_SUB","visible","false");
					}
					else if(getValue("Pending_Reason")=="Due to non receipt of"){
						setValues({"Others_Pending_SubReason":""},true);
						setStyle("USR_0_DSR_MR_PENDING_SUB","visible","true");
						setStyle("USR_0_DSR_MR_PENDING_SUB","mandatory","true");
						setStyle("Others_Pending_SubReason","visible","false");
					}
					else{
						setStyle("USR_0_DSR_MR_PENDING_SUB","visible","false");
						setStyle("Others_Pending_SubReason","visible","false");
						setValues({"Others_Pending_SubReason":""},true);
						setValues({"USR_0_DSR_MR_PENDING_SUB":""},true);
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
						setValues({"USR_0_DSR_MR_REJECT_SUB_REASON":""},true);
						setStyle("Others_Reject_Reason","visible","true");
						setStyle("Others_Reject_Reason","mandatory","true");
						setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","visible","false");
					}
					else if(getValue("Cards_Reject")=="Due to non receipt of"){
						setValues({"Others_Reject_Reason":""},true);
						setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","visible","true");
						setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","mandatory","true");
						setStyle("Others_Reject_Reason","visible","false");
					}
					else{
						setValues({"Others_Reject_Reason":""},true);
						setValues({"USR_0_DSR_MR_REJECT_SUB_REASON":""},true);
						setStyle("Others_Reject_Reason","visible","false");
						setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","visible","false");
					}
				}
				break;
				
				
		case 'Cards_Decision_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'Pending_Decision_change' :
				SetEventValues(controlId,controlEvent);
				break;
		case 'DCI_DebitCN_change' : //9
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
				
        case 'Clear_click' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		
	}
} 


function customListViewValidation(tableId,flag)
{
	if(tableId = "REJECT_REASON_GRID")
	{		
		var reasonVal = getSelectedItemLabel("table26_Reject Reason");
		////alert('reasonVal'+reasonVal);
		if(reasonVal=="Select")
		{
			showMessage(tableId,'Please Choose Valid Reject Reason',"error");
			return false;
		}

	}
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
				setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","visible","true");
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
				setStyle("USR_0_DSR_MR_PENDING_SUB","visible","true");
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
		if(getValue("USR_0_DSR_MR_REJECT_SUB_REASON") != ""){
			setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","visible","true");
			setStyle("USR_0_DSR_MR_REJECT_SUB_REASON","disable","true");
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
		if(getValue("USR_0_DSR_MR_PENDING_SUB") != ""){
			
			setStyle("USR_0_DSR_MR_PENDING_SUB","visible","true");
			setStyle("USR_0_DSR_MR_PENDING_SUB","disable","true");
		}
		else if (getValue("Others_Pending_SubReason") != ""){
			
			setStyle("Others_Pending_SubReason","visible","true");
			setStyle("Others_Pending_SubReason","disable","true");
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

