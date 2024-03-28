var DSR_DCB_onLoad = document.createElement('script');
DSR_DCB_onLoad.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_onLoad.js';
document.head.appendChild(DSR_DCB_onLoad);
	
var DSR_DCB_mandatory = document.createElement('script');
DSR_DCB_mandatory.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_MandatoryFieldValidations.js';
document.head.appendChild(DSR_DCB_mandatory);

	
var DSR_DCB_onSaveDone = document.createElement('script');
DSR_DCB_onSaveDone.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_onSaveDone.js';
document.head.appendChild(DSR_DCB_onSaveDone);

var DSR_DCB_Common = document.createElement('script');
DSR_DCB_Common.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_Common.js';
document.head.appendChild(DSR_DCB_Common);


var DSR_DCB_EventHandler = document.createElement('script');
DSR_DCB_EventHandler.src = '/DSR_DCB/DSR_DCB/CustomJS/DSR_DCB_EventHandler.js';
document.head.appendChild(DSR_DCB_EventHandler);



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
    //alert("afterFormload");
	setCommonVariables();
	setControlValue("LoggedInUser",user);
	setControlValue("wi_name",WorkitemNo);
	//alert("WorkitemNo:"+ WorkitemNo);
	//setValue("ServiceType","DebitCard Service Request -(DSR_DCB)");
	var BranchName = executeServerEvent("BranchName","FormLoad","",true);
	//alert("@@BranchName :"+BranchName);
	
	//setting checkbox values***************************************************
	setStyle("Hidden_Section","visible","false");
	setStyle("baseFr1","disable","true");
	enableDisableAfterFormLoad();
	
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
		//alert("VD_TINCheck_click :"+VD_TINCheck_click);
		/*case 'VD_TIN_Check_click' : 
				SetEventValues(controlId,controlEvent);
				break;  */	
            
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
				
        case 'REASON_HOTLIST_change' : 
				SetEventValues(controlId,controlEvent);
				break;				
		
        case 'ACTION_TAKEN_change' : 
				SetEventValues(controlId,controlEvent);
				break;
  
         case 'DELIVER_TO_change' : 
				SetEventValues(controlId,controlEvent);
				break;				
		
        case 'BRANCH_NAME_change' : 
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