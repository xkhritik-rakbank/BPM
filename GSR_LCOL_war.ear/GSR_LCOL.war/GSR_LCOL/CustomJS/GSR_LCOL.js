var onLoad = document.createElement('script');
onLoad.src = '/GSR_LCOL/GSR_LCOL/CustomJS/GSR_LCOL_onLoad.js';
document.head.appendChild(onLoad);

var mandatory = document.createElement('script');
mandatory.src = '/GSR_LCOL/GSR_LCOL/CustomJS/GSR_LCOL_MandatoryFieldValidations.js';
document.head.appendChild(mandatory);
	
var onSaveDone = document.createElement('script');
onSaveDone.src = '/GSR_LCOL/GSR_LCOL/CustomJS/GSR_LCOL_onSaveDone.js';
document.head.appendChild(onSaveDone);

var EventHandler = document.createElement('script');
EventHandler.src = '/GSR_LCOL/GSR_LCOL/CustomJS/GSR_LCOL_EventHandler.js';
document.head.appendChild(EventHandler);

var Common = document.createElement('script');
Common.src = '/GSR_LCOL/GSR_LCOL/CustomJS/GSR_LCOL_Common.js';
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
	setControlValue("WI_NAME",WorkitemNo);
	
	setControlValue("ReqType","General Service Requests - Liability Certificate/No Liability Certificate(GSR_LCOL) ");
	
	setControlValue("LoggedInUser", user);
	
	var branchIdValue = executeServerEvent("BranchName","FormLoad","",true);
	//setControlValue("branchIdValue", "Branch Id: "  +    branchIdValue);
	
	setControlValue("CRWORKSTEP", "Current Workstep:  "    +    getValue("Current_Workstep_name"));
    setControlValue("PRWORKSTEP", "Previous Workstep:  "   +   getValue("Previous_Workstep_name"));
	
	setStyle("Hidden_Section","visible","false");
	enableDisableAfterFormLoad();
	
		
}


function customValidationsBeforeSaveDone(op)
{	
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
	    case 'MOBILENO_change' : 
				SetEventValues(controlId,controlEvent);
				break;

        case 'LANDLINENO_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'CHAMOUNT_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'CHARGESTOBERECFROM_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		
		case 'BADecision_change' : 
				SetEventValues(controlId,controlEvent);
				break;
		
		case 'EC1_change' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'EC2_change' : 
				SetEventValues(controlId,controlEvent);
				break;		
		
		case 'EC3_change' : 
				SetEventValues(controlId,controlEvent);
				break;
			
		case 'ClearAll_click' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'BtnOK_click' : 
				SetEventValues(controlId,controlEvent);
				break;
				
		case 'Refresh_click' : 
				SetEventValues(controlId,controlEvent);
				break;		
				
        case 'Introduce_click' : 
				SetEventValues(controlId,controlEvent);
				break;	
				
	
        case 'ClearAll_click' : 
				SetEventValues(controlId,controlEvent);
				break;
        
       
	    case 'Command2_click' : 
				SetEventValues(controlId,controlEvent);
				break;	
				
			
				
	}
}


