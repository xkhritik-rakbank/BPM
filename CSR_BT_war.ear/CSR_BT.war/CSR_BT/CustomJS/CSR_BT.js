var CSR_BT_onLoad = document.createElement('script');
	CSR_BT_onLoad.src = '/CSR_BT/CSR_BT/CustomJS/CSR_BT_onLoad.js';
	document.head.appendChild(CSR_BT_onLoad);
	
var CSR_BT_mandatory = document.createElement('script');
	CSR_BT_mandatory.src = '/CSR_BT/CSR_BT/CustomJS/CSR_BT_MandatoryFieldValidations.js';
	document.head.appendChild(CSR_BT_mandatory);

	
var CSR_BT_onSaveDone = document.createElement('script');
CSR_BT_onSaveDone.src = '/CSR_BT/CSR_BT/CustomJS/CSR_BT_onSaveDone.js';
document.head.appendChild(CSR_BT_onSaveDone);

var CSR_BT_Common = document.createElement('script');
CSR_BT_Common.src = '/CSR_BT/CSR_BT/CustomJS/CSR_BT_Common.js';
document.head.appendChild(CSR_BT_Common);

var CSR_BT_EventHandler = document.createElement('script');
CSR_BT_EventHandler.src = '/CSR_BT/CSR_BT/CustomJS/CSR_BT_EventHandler.js';
document.head.appendChild(CSR_BT_EventHandler);

var CSR_BT_IntegrationEvents = document.createElement('script');
CSR_BT_IntegrationEvents.src = '/CSR_BT/CSR_BT/CustomJS/CSR_BT_IntegrationEvents.js';
document.head.appendChild(CSR_BT_IntegrationEvents);


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
    
	//alert("Form Load");
	setCommonVariables();
	setValue("LoggedInUser",user);
	setValue("wi_name",WorkitemNo);
	var currentTime = new Date();
	setControlValue("BA_DateTime",currentTime.toLocaleDateString());
	setValue("ServiceType","Card Service Request - Balance Transfer(CSR_BT)");
	//var BranchName = executeServerEvent("BranchName","FormLoad","",true);
	
		//alert("@@BranchName :"+BranchName);
	setStyle("HiddenFieldsFrame","visible","false");
	setStyle("PrintFrame","visible","false");
	
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
	
	setEnableDisable();
	//user= getWorkItemData("username");
	setValuesOnload(user);
	setControlValue("CCI_ExpD","Masked");
	formloadvalidation();
	//setValue("initiateDecision","Branch_Approver")
	
	//setStyle("D_RR","visible","false");
	/* setValue("LoggedInUser",user);
	setStyle("HIDDEN_SECTION","visible","false");
	setStyle("REJECT_REASON_GRID","visible","false");
	setStyle("CHANNEL","disable","true");
	populateDecisionDropDown();
	setValue("DECISION","");  //setting decision drop down values as Select initially	
	loadSolId(user);
	enableDisableAfterFormLoad();
	loadSolId(user); */	
}


function customValidationsBeforeSaveDone(op)
{	
	//enabledisabledate();
	if(op=="S")
	{
		setCustomControlsValue();
		return true;
	}
	else if (op=="I" || op=="D")
	{
		
		if(setCustomControlsValue()==false)
		{
			return false;
		}
		
		
		var confirmDoneResponse = confirm("You are about to submit the workitem. Do you wish to continue?");
		
		if(confirmDoneResponse ==  true)
		{	
				var rejectReason = "rejectreason";
				var ActivityName =getWorkItemData("ActivityName");
				var cardNo = getValue('CCI_CrdtCN');
				//var finalCardNo = splitCardNumber(cardNo);
				var MobileNo = getValue('CCI_MONO');
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
			//saveWorkItem();
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
	//alert("ControlIdandEvent"+ControlIdandEvent);
	switch(ControlIdandEvent)
	{
		case 'Pending_Reason_change' : 
				if(ActivityName=="Pending"){
					if(getValue("Pending_Reason")=="Others"){
						setValues({"USR_0_CSR_BT_PENDING_SUB_REJECT":""},true);
						setStyle("Others_Pending_Reason","visible","true");
						setStyle("Others_Pending_Reason","mandatory","true");
						setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","visible","false");
					}
					else if(getValue("Pending_Reason")=="Due to non receipt of"){
						setValues({"Others_Pending_Reason":""},true);
						setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","visible","true");
						setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","mandatory","true");
						setStyle("Others_Pending_Reason","visible","false");
					}
					else{
						setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","visible","false");
						setStyle("Others_Pending_Reason","visible","false");
						setValues({"Others_Pending_Reason":""},true);
						setValues({"USR_0_CSR_BT_PENDING_SUB_REJECT":""},true);
					}
				}
				break;
				
		/*case 'Sub_Reasons_Pending_change' : 
				if(ActivityName=="Pending"){
					if(getValue("Sub_Reasons_Pending")=="Others"){
						setValue("Others_Sub_Pending_Reasons","");
						setStyle("Others_Sub_Pending_Reasons","visible","true");
					}
					else{
						setValue("Others_Sub_Pending_Reasons","");
						setStyle("Others_Sub_Pending_Reasons","visible","false");
					}
				}
				break;		*/
		case 'Cards_Reject_change' : 
				if(ActivityName=="CARDS"){
					if(getValue("Cards_Reject")=="Others"){
						setValues({"USR_0_CSR_BT_CARDS_SUB_REJECT":""},true);
						setStyle("Others_Reject_Reasons","visible","true");
						setStyle("Others_Reject_Reasons","mandatory","true");
						setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","visible","false");
					}
					else if(getValue("Cards_Reject")=="Due to non receipt of"){
						setValues({"Others_Reject_Reasons":""},true);
						setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","visible","true");
						setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","mandatory","true");
						setStyle("Others_Reject_Reasons","visible","false");
					}
					else{
						setValues({"Others_Reject_Reasons":""},true);
						setValues({"USR_0_CSR_BT_CARDS_SUB_REJECT":""},true);
						setStyle("Others_Reject_Reasons","visible","false");
						setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","visible","false");
					}
				}
				break;
		/*case 'Cards_Reject_Sub_Reason_change' : 
				if(ActivityName=="CARDS"){
					if(getValue("USR_0_CSR_BT_CARDS_SUB_REJECT")=="Others"){
						setValue("Others_Sub_Reject_reasons","");
						setStyle("Others_Sub_Reject_reasons","visible","true");
					}
					else{
						setValue("Others_Sub_Reject_reasons","");
						setStyle("Others_Sub_Reject_reasons","visible","false");
					}
				}
				break;	*/
		case 'Refresh_click' : 
				refreshBttn();
				break;
		case 'BTD_OBC_OBCNO_blur' : 
				otherBankCardValidation();
				break;
				
		case 'BTD_RBC_RBCN11_change' : 
				rakbankcardchange();
				break;
		case 'BTD_RBC_RBCN22_change' : 
				rakbankcard22change();
				break;
		case 'BTD_RBC_RBCN33_change' : 
				rakbankcard33change();
				break;
		case 'Introduce_click' : 
				introduceBttn();
				break;
		case 'Pending_click' : 
				pendingBttn();
				break;
		case 'Exit_click' : 
				introduceBttn();
				break;
		
		//Verification Details section change events start here
		case 'VD_TIN_Check_change' : 
				SetEventValues(controlId,controlEvent);
				break;
		case 'VD_Oth_Check_change' : 
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
		//Verification Details section change events end here
		
		case 'BTD_OBC_OBN_change' : 
				enableDisableothers();
				break;	
		case 'BTD_OBC_DT_change' : 
				enableDisablebank();
				break;		

		case 'Clear_click':
				clearfields();
				break;
		case 'BttnPrint_click' : 
				bttnPrint();
				break;
				
	}
}


/*function customListViewValidation(tableId,flag)
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
}*/
function customMethod(control, eventType)
{
	executeServerEvent_CSR_BT(control.id, eventType.type);
}
function executeServerEvent_CSR_BT(controlName, eventType) 
{
	switch (eventType) 
	{
		case 'click':
			{
				executeClickEvent(controlName);
				break;
			}
		case 'change':
			{
				executeChangeEvent(controlName);
				break;
			}
		case 'focus':
			{
				executeFocusEvent(controlName);
				break;
			}
		case 'blur':
			{
				executeBlurEvent(controlName);
				break;
			}
		case 'tabclick':
			{
				executeTabClickEvent(controlName);
				break;
			}
		/*	case 'lostFocus': 
			{
				executeLostFocusEvent(controlName);
				break;
			}*/
		default:
			return false;
	}
}
function formloadvalidation (){
    if(ActivityName !="CARDS"){
		if(getValue("Cards_Reject") != ""){
			setStyle("Cards_Reject","visible","true");
			setStyle("Cards_Reject","disable","true");
		}
		else if(getValue("Cards_Rework") != ""){
			setStyle("Cards_Rework","visible","true");
			setStyle("Cards_Rework","disable","true");
		}
		if(getValue("USR_0_CSR_BT_CARDS_SUB_REJECT") != ""){
			setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","visible","true");
			setStyle("USR_0_CSR_BT_CARDS_SUB_REJECT","disable","true");
		}
		else if (getValue("Others_Reject_Reasons") != ""){
			setStyle("Others_Reject_Reasons","visible","true");
			setStyle("Others_Reject_Reasons","disable","true");
		}
	}
	else if(ActivityName !="Pending"){
		if(getValue("Pending_Reason") != ""){
			setStyle("Pending_Reason","visible","true");
			setStyle("Pending_Reason","disable","true");
		}
		if(getValue("USR_0_CSR_BT_PENDING_SUB_REJECT") != ""){
			setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","visible","true");
			setStyle("USR_0_CSR_BT_PENDING_SUB_REJECT","disable","true");
		}
		else if (getValue("Others_Pending_Reason") != ""){
			setStyle("Others_Pending_Reason","visible","true");
			setStyle("Others_Pending_Reason","disable","true");
		}
	}
}