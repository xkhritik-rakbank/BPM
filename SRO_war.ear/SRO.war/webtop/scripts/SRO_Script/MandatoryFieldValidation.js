function OnDoneValidation(flag)
{
	var WSNAME = customform.document.getElementById("wdesk:Current_WS").value;
	if(customform.document.getElementById("selectDecision").value=='' || customform.document.getElementById("selectDecision").value=='--Select--')//Decision will always be mandatory for all workstep
	{
		alert('Decision is mandatory');
		customform.document.getElementById('selectDecision').focus(true);
		return false;
	}
	//Saving the Decision on Maker WS
	if(WSNAME=="Maker")
			customform.document.getElementById("wdesk:Dec_Maker").value =customform.document.getElementById("selectDecision").value;
	
	//Mandatory Validation on Remarks & RejectReason based on selected Decision	
	if(customform.document.getElementById("selectDecision").value=='Reject to Team'||customform.document.getElementById("selectDecision").value=='Reject'|| customform.document.getElementById("selectDecision").value=='Reject to Maker' || customform.document.getElementById("selectDecision").value=='Reject to Initiator' || customform.document.getElementById("selectDecision").value=='Cancel'|| customform.document.getElementById("selectDecision").value=='Additional Information Required'){
		if(customform.document.getElementById("wdesk:Remarks").value.trim()==''){
			alert("Please provide remarks");
			customform.document.getElementById('wdesk:Remarks').focus(true);
			return false;
		}
		if(customform.document.getElementById('rejReasonCodes').value=='' || customform.document.getElementById('rejReasonCodes').value=='NO_CHANGE')
		{
			alert("Please provide reject reason.");
			customform.document.getElementById('RejectReason').focus(true);
			return false;
		}
			
	}
	
	
	//Mandatory Validation on ServiceRequest based on WS
	//Added Mail_Init Workstep for Mail Management Changes
	if(WSNAME=='Introduction' || WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup' || WSNAME=='Initiator_Reject')
	{
		var ServiceRequest=customform.document.getElementById('ServiceRequestType');		
		if(ServiceRequest.value==null || ServiceRequest.value=="" || ServiceRequest.value=="--Select--")
		{
			alert('Service Request is mandatory');
			ServiceRequest.focus();
			return false;
		}
		ajaxRequest('ServiceRequestCode',customform.document.getElementById("ServiceRequestType").value,'wdesk:Service_Request_Code','OnSubmit');
	}
	//Mandatory Validation on ArchivePath based on WS
	//Added Mail_Init Workstep for Mail Management Changes
	if(WSNAME=='Introduction' || WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup' || WSNAME=='Initiator_Reject')
	{
		var ArchivePath=customform.document.getElementById('wdesk:Archival_Path');
		if(ArchivePath.value==null || ArchivePath.value=="" || ArchivePath.value=="--Select--")
		{
			alert('Archival Path is mandatory');
			ArchivePath.focus();
			return false;
		}
		ajaxRequest('ArchivalCode',customform.document.getElementById("wdesk:Archival_Path").value,'wdesk:Archival_Code','OnSubmit');
		
		//Mandatory Validation on CIFID based on Archival Path selected
		var ArchivalCode=customform.document.getElementById("wdesk:Archival_Code");		
		if(ArchivalCode.value == 'AR001' || ArchivalCode.value == 'AR002' || ArchivalCode.value == 'AR003' || ArchivalCode.value == 'AR004' || ArchivalCode.value == 'AR005' || ArchivalCode.value == 'AR006' || ArchivalCode.value == 'AR008' || ArchivalCode.value == 'AR009' || ArchivalCode.value == 'AR010'
			|| ArchivalCode.value == 'AR011' || ArchivalCode.value == 'AR016'|| ArchivalCode.value == 'AR017' || ArchivalCode.value == 'AR018' || ArchivalCode.value == 'AR019' || ArchivalCode.value == 'AR024')
		{
			var CIFID=customform.document.getElementById("wdesk:CIF_Id");
			if(CIFID.value == null || CIFID.value == "")
			{
				alert('CIF ID is mandatory');
				CIFID.focus();
				return false;			
			}		
		}
		
		//Mandatory Validation on ERCN_Number based on Archival Path selected
		if(ArchivalCode.value == 'AR007' || ArchivalCode.value == 'AR012')
		{
			var ERCN_Number=customform.document.getElementById("wdesk:ERCN_Number");	
			if(ERCN_Number.value == null || ERCN_Number.value == "")
			{
				alert('ERCN Number is mandatory');
				ERCN_Number.focus();
				return false;			
			}		
		}
		//Added Mail_Init Workstep for Mail Management Changes
		if( WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup' )
		{
			var ServiceRequest=customform.document.getElementById('ServiceRequestType');		
			if((ServiceRequest.value.indexOf("covid") != -1 || ServiceRequest.value.indexOf("Covid") != -1 || ServiceRequest.value.indexOf("COVID") != -1) &&
					customform.document.getElementById("selectDecision").value=='Recommended'	)
			{
			var agreement_Number=customform.document.getElementById("wdesk:Agreement_Number");	
			if(agreement_Number.value == null || agreement_Number.value == "")
			{
				alert('Agreement Number is mandatory');
				agreement_Number.focus();
				return false;			
			}
			}
		}
		//End of Mail Management Changes Agreement Number mandatory
		//Mandatory Validation on Pre_Paid_Pack_Id based on Archival Path selected
		if(ArchivalCode.value == 'AR013')
		{
			var Pre_Paid_Pack_Id=customform.document.getElementById("wdesk:Pre_Paid_Pack_Id");	
			if(Pre_Paid_Pack_Id.value == null || Pre_Paid_Pack_Id.value == "")
			{
				alert('PrePaidPack Id is mandatory');
				Pre_Paid_Pack_Id.focus();
				return false;			
			}		
		}
	}

	//Mandatory Validation on TeamName based on the decision selected
	if(true)
	{
		
		if(WSNAME == 'Introduction' )
		{	
			if(customform.document.getElementById("TeamSearchable").value=='' || customform.document.getElementById("TeamSearchable").value=='--Select--')
			{
				alert('Team is mandatory');
				customform.document.getElementById('TeamSearchable').focus(true);
				return false;
			}	
		}
		//Added Mail_Init Workstep for Mail Management Changes
		else if(WSNAME == 'Hold' || WSNAME == 'Initiator_Reject' || WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup')
		{	
			if(customform.document.getElementById("selectDecision").value=='Submit to Team' ||
					customform.document.getElementById("selectDecision").value=='Recommended')
			{
				if(customform.document.getElementById("TeamSearchable").value=='' || customform.document.getElementById("TeamSearchable").value=='--Select--')
				{
					alert('Team is mandatory');
					customform.document.getElementById('TeamSearchable').focus(true);
					return false;
				}		
			}
		}
		else if(WSNAME == 'Checker')
		{	
			if(customform.document.getElementById("selectDecision").value=='Approve to Team' || customform.document.getElementById("selectDecision").value=='Reject to Team')
			{
				if(customform.document.getElementById("TeamSearchable").value=='' || customform.document.getElementById("TeamSearchable").value=='--Select--')
				{
					alert('Team is mandatory');
					customform.document.getElementById('TeamSearchable').focus(true);
					return false;
				}		
			}
		}
		//Added by Sadacharan.S on 18.04.2021 to make remarks as mandatory when team in Profile Change/Profile Change 2 - Start
		if(customform.document.getElementById("TeamSearchable").value=='Profile Change' || customform.document.getElementById("TeamSearchable").value=='Profile Change 2')
		{
			if(customform.document.getElementById("wdesk:Remarks").value.trim()=='')
			{
				alert("Please Provide Remarks");
				customform.document.getElementById('wdesk:Remarks').focus(true);
				return false;
			}			
		}
		//Added by Sadacharan.S on 18.04.2021 to make remarks as mandatory when team in Profile Change/Profile Change 2 - End			
		ajaxRequest('TeamCode',customform.document.getElementById("TeamSearchable").value,'wdesk:TeamCode','OnSubmit');
		//Added by Sadacharan.S on 07.04.2021 to validate team code on Submit - Start
		if(WSNAME == 'Introduction' )
		{
			if(customform.document.getElementById("wdesk:TeamCode").value=='')
			{
				customform.document.getElementById('TeamSearchable').value='';
				alert('Team is Mandatory');			
				customform.document.getElementById('TeamSearchable').focus(true);
				return false;
			}
		}
		else if(WSNAME == 'Hold' || WSNAME == 'Initiator_Reject' || WSNAME=='Mail_Initiation' || WSNAME=='Mail_Followup')
		{
			if(customform.document.getElementById("selectDecision").value=='Submit to Team' || customform.document.getElementById("selectDecision").value=='Recommended')
			{
				if(customform.document.getElementById("wdesk:TeamCode").value=='')
				{
					customform.document.getElementById('TeamSearchable').value='';
					alert('Team is Mandatory');			
					customform.document.getElementById('TeamSearchable').focus(true);
					return false;
				}
			}
		}
		else if(WSNAME == 'Checker')
		{
			if(customform.document.getElementById("selectDecision").value=='Approve to Team' || customform.document.getElementById("selectDecision").value=='Reject to Team')
			{
				if(customform.document.getElementById("wdesk:TeamCode").value=='')
				{
					customform.document.getElementById('TeamSearchable').value='';
					alert('Team is Mandatory');
					customform.document.getElementById('TeamSearchable').focus(true);
					return false;
				}
			}
		}		
		//Added by Sadacharan.S on 07.04.2021 to validate team code on Submit - End			
	}
	
	//Saving Archivaldate on Checker,Hold,InitiatorReject WS
	var d = new Date();
	if(WSNAME == 'Checker')
	{
		if(customform.document.getElementById("selectDecision").value == "Approve-Exit")
		{		
			var today = formatDate(d,3);
			customform.document.getElementById("wdesk:ArchivalDate").value = today;
		}
	}
	else if(WSNAME == 'Hold')
	{
		if(customform.document.getElementById("selectDecision").value == "Reject")
		{		
			var today = formatDate(d,3);
			customform.document.getElementById("wdesk:ArchivalDate").value = today;
		}
	}
	else if(WSNAME == 'Initiator_Reject')
	{
		if(customform.document.getElementById("selectDecision").value == "Reject")
		{		
			var today = formatDate(d,3);
			customform.document.getElementById("wdesk:ArchivalDate").value = today;
		}
	}
	
	return true;
}



function ajaxRequest(reqType,reqValue,field,Event)
{
	if (reqValue == '' || reqValue== '--Select--')
		return true;
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");
	url = '/SRO/CustomForms/SRO_Specific/DropDownLoad.jsp?';
	var param = 'reqType='+reqType+'&reqValue='+reqValue;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while Loading AjaxRequest.");
			return false;
		 }
		 
		 values = ajaxResult.split("~");
		 
		 if (Event == 'OnSubmit')
			{ customform.document.getElementById(field).value=values[0]; }
		 else
			{
			if(reqType=='Email_MailInit_User_Code' && values[0] =='empty')
			{
			document.getElementById(field).value='';
			}else
			{
			document.getElementById(field).value=values[0];
			}
			
			}
		 return true;
	}
	else 
	{
	    alert("Exception while Loading AjaxRequest.");
		return false;
	}
}

function formatDate(dateObj,format)
{
    var curr_date = dateObj.getDate();
    var curr_month = dateObj.getMonth();
    curr_month = curr_month + 1;
    var curr_year = dateObj.getFullYear();
    var curr_min = dateObj.getMinutes();
    var curr_hr= dateObj.getHours();
    var curr_sc= dateObj.getSeconds();
    if(curr_month.toString().length == 1)
    curr_month = '0' + curr_month;      
    if(curr_date.toString().length == 1)
    curr_date = '0' + curr_date;
    if(curr_hr.toString().length == 1)
    curr_hr = '0' + curr_hr;
    if(curr_min.toString().length == 1)
    curr_min = '0' + curr_min;
	if(curr_sc.toString().length == 1)
    curr_sc = '0' + curr_sc;
    if(format ==1)//dd-mm-yyyy
    {
        return curr_date + "-"+curr_month+ "-"+curr_year;       
    }
    else if(format ==2)//yyyy-mm-dd
    {
        return curr_year + "-"+curr_month+ "-"+curr_date;       
	}
    else if(format ==3)//dd/mm/yyyy
    {
        return curr_date + "/"+curr_month+ "/"+curr_year;       
    }
    else if(format ==4)// MM/dd/yyyy HH:mm:ss
    {
        return curr_month+"/"+curr_date +"/"+curr_year+ " "+curr_hr+":"+curr_min+":"+curr_sc;       
    }
	else if(format ==5)// dd/MM/yyyy HH:mm:ss
    {
        return curr_date+"/"+curr_month +"/"+curr_year+ " "+curr_hr+":"+curr_min+":"+curr_sc;       
    }
}