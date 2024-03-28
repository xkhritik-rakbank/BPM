function loadDropDownValues(currWorkstep,loggedInUser)
{//Added Mail_Init Workstep for Mail Management Changes
	if (currWorkstep == 'Introduction' || currWorkstep=='Mail_Initiation' || currWorkstep=='Mail_Followup' || currWorkstep == 'Maker' || currWorkstep == 'Initiator_Reject')
	{
		SearchableServiceRequestDropdown(currWorkstep);
		setAutocompleteData();		
		document.getElementById("ServiceRequestType").value = document.getElementById("wdesk:Service_Request_Type").value;
	}
	else {
		document.getElementById("ServiceRequestType").value = document.getElementById("wdesk:Service_Request_Type").value;
	}

	disabledecision(currWorkstep);
	//Added Mail_Init Workstep for Mail Management Changes
	if (currWorkstep == 'Introduction' || currWorkstep=='Mail_Initiation')
	{
		ajaxRequest('InitiatorUserGroup',loggedInUser,'wdesk:IntiatorUserGroup','');
	
	}
	if ( currWorkstep=='Mail_Initiation' ||  currWorkstep=='Mail_Followup')
	{
		document.getElementById("wdesk:Mail_Initiation_User").value=loggedInUser;
	
	}
	//Commented For MailManagement Testing
//	 if( currWorkstep=='Mail_Initiation' || currWorkstep=='Mail_Followup') 
//		/* || currWorkstep=='Maker' || currWorkstep=='Checker'
//	 || currWorkstep=='Initiator_Reject' || currWorkstep=='Introduction' || currWorkstep=='SRO_Hold'  ) */
//	{
//		
//		ajaxRequest('Email_Create_Trigger',loggedInUser,'wdesk:Email_Create_Trigger','');
//		ajaxRequest('Email_Approve_Trigger',loggedInUser,'wdesk:Email_Approve_Trigger','');
//		ajaxRequest('Email_Reject_Trigger',loggedInUser,'wdesk:Email_Reject_Trigger','');
//		ajaxRequest('Email_Cancel_Trigger',loggedInUser,'wdesk:Email_Cancel_Trigger','');
//		ajaxRequest('Email_RequestInfo_Trigger',loggedInUser,'wdesk:Email_RequestInfo_Trigger','');
//		ajaxRequest('Email_FinalReject_Trigger',loggedInUser,'wdesk:Email_FinalReject_Trigger','');
//		ajaxRequest('MailFollowup_expiry_days',loggedInUser,'wdesk:MailFollowup_expiry_days','');
//		ajaxRequest('Email_MailInit_User_Code',loggedInUser,'wdesk:Email_MailInit_User_Code','');
//		
//	}  
	//Added Mail_Init Workstep for Mail Management Changes
	if (currWorkstep == 'Introduction' || currWorkstep=='Mail_Initiation' || currWorkstep=='Mail_Followup' || currWorkstep == 'Hold' || currWorkstep == 'Initiator_Reject' || currWorkstep == 'Checker')
	{
		loadTeamFromMaster(currWorkstep);
		setAutocompleteDataTeam();
		document.getElementById("TeamSearchable").value = document.getElementById("wdesk:Team").value;
	}
	else
		document.getElementById("TeamSearchable").value = document.getElementById("wdesk:Team").value;

}

function loadDecisionFromMaster(currWorkstep)
{//Added Mail_Init Workstep for Mail Management Changes
	if (currWorkstep == 'Introduction' || currWorkstep=='Mail_Initiation' || currWorkstep=='Mail_Followup' || currWorkstep == 'Maker' || currWorkstep == 'Checker' || currWorkstep == 'Hold' || currWorkstep == 'Initiator_Reject')
	{
			var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = "/SRO/CustomForms/SRO_Specific/DropDownLoad.jsp";
			var param='&reqType=selectDecision&WSNAME='+currWorkstep;
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading dropdown values for decision");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					document.getElementById("selectDecision").options.add(opt);
				 }				 
			}
			else 
			{
				alert("Error while Loading Drowdown decision.");
				return false;
			}
		}	
}
function loadServiceRequestFromMaster(currWorkstep,ServiceRequestSelected)
{
	var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			url = '/SRO/CustomForms/SRO_Specific/DropDownLoad.jsp?';
			var param='&reqType=ServiceRequestType&WSNAME='+currWorkstep;
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading drop down values for Service Request");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 
					
					
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					if(values[j]==ServiceRequestSelected)
						opt.selected='selected';
					document.getElementById('wdesk:Service_Request_Type').options.add(opt);
				 }
			}
			else 
			{
				alert("Error while Loading Drop down Service Request Type.");
				return false;
			}

}
function loadTeamFromMaster(currWorkstep)
{
	var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = '/SRO/CustomForms/SRO_Specific/DropDownLoad.jsp?';
			var param = '&reqType=Team&WSNAME='+currWorkstep;
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading drop down values for Team");
					return false;
				 }				 
				 /*values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					if(values[j]==TeamSelected)
						opt.selected='selected';
					document.getElementById('TeamSearchable').options.add(opt);
				 }*/
				 document.getElementById("AutocompleteValuesTeam").value=ajaxResult;
			}
			else 
			{
				alert("Error while Loading Drop down Team.");
				return false;
			}
}
function loadArchivalPathFromMaster(currWorkstep,ArchivalPathSelected)
{
	var url = '';
			var xhr;
			var ajaxResult;		
			if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
			else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		
			url = '/SRO/CustomForms/SRO_Specific/DropDownLoad.jsp?';
			var param='&reqType=ArchivalPath&WSNAME='+currWorkstep;
			xhr.open("POST",url,false);
			xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			xhr.send(param);
			if (xhr.status == 200)
			{
				 ajaxResult = xhr.responseText;
				 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
				 if(ajaxResult=='-1')
				 {
					alert("Error while loading drop down values for Archival Path");
					return false;
				 }				 
				 values = ajaxResult.split("~");
				 for(var j=0;j<values.length;j++)
				 {
					var opt = document.createElement("option");
					opt.text = values[j];
					opt.value =values[j];
					if(values[j]==ArchivalPathSelected)
						opt.selected='selected';
					document.getElementById('wdesk:Archival_Path').options.add(opt);
				 }
			}
			else 
			{
				alert("Error while Loading Drop down Archival Path.");
				return false;
			}
}

//below code added for smart search in Service Request name
function setAutocompleteData() 
{	
		var data = "";
		var ele = document.getElementById("AutocompleteValues");
		if (ele)
		
			data = "ServiceRequestType="+ele.value;
			//alert('in autocomplete '+data);
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split("~");
			
			
			$(document).ready(function() {
				$("#ServiceRequestType").autocomplete({source: values}); 
			});				
		}	
}

function setAutocompleteDataTeam() 
{	
		var data = "";
		var ele = document.getElementById("AutocompleteValuesTeam");
		if (ele)
		
			data = "TeamSearchable="+ele.value;
			//alert('in autocomplete '+data);
		if (data != null && data != "" && data != '{}') {
			data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[1].split("~");
			
			
			$(document).ready(function() {
				$("#TeamSearchable").autocomplete({source: values}); 
			});				
		}	
}

function myTrim(x) 
{
	return x.replace(/^\s+|\s+$/gm,'');
}


//Added for validating ServiceRequestType field 21102018
function validateServiceRequest(req,requestvalidate)
{
	//alert("inside validate");
	//countryvalidate = countryvalidate.replaceAll1(", ", ",");
	requestvalidate=requestvalidate.split("~");
	var match ='';
	document.getElementById(req).value = myTrim(document.getElementById(req).value);
	for(var i=0;i<=requestvalidate.length;i++)
	{
			if(document.getElementById(req).value==requestvalidate[i])
			match='matched';
	}
	if(match !='matched')
	{
		document.getElementById(req).value="";
		return false;
	}
}

function SearchableServiceRequestDropdown(currWorkstep)
{		
	var url = '';
	var reqType='ServiceRequestType';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/SRO/CustomForms/SRO_Specific/DropDownLoad.jsp';
	var param='reqType='+reqType+'&WSNAME='+currWorkstep;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
		 {
			alert("Error while loading drop down values for Service Request");
			return false;
		 }							 
		document.getElementById("AutocompleteValues").value=ajaxResult;
	
	}
	else 
	{
		alert("Error while Loading Drowdown "+reqType+" for the current workstep");
		return false;
	}
		
}

function addrowUID(arrayUIDRowValues, CurrentWS)
{
		if(arrayUIDRowValues!='')
		{
			arrayUIDRowValues=arrayUIDRowValues.split("~");
		}
		
		
		var table = document.getElementById("UIDGrid");
		var table_len=table.rows.length-2;
		var lastRow = table.rows[ table.rows.length-1 ];
		var row = table.insertRow();
		row.style.width=document.getElementById("SRO").offsetWidth;
		
		var cell = row.insertCell(0);
		var srno = 'srno'+table_len;
		cell.innerHTML="<input type='text' size='4' readonly='readonly' maxlength='20' id='srno"+table_len+"'>";
		document.getElementById("srno"+table_len).value=table_len;
		
		var cell = row.insertCell(1);
		var uid = 'uid'+table_len;
		//alert("UId is "+uid);
		cell.innerHTML="<input type='text' maxlength='20' size='15' id='uid"+table_len+"' onkeyup='validateUIDNumber(\""+uid+"\");'>";
		if(arrayUIDRowValues!='')
		document.getElementById("uid"+table_len).value=arrayUIDRowValues[0];
		
		var cell = row.insertCell(2);
		var InitiatorRemarksid = 'InitiatorRemark'+table_len;
		cell.innerHTML="<textarea maxlength='2000' rows='2' cols='25' id='InitiatorRemark"+table_len+"' onkeyup='checkRemarksUID(\""+InitiatorRemarksid+"\");'></textarea>";
		if(arrayUIDRowValues!='')
		document.getElementById("InitiatorRemark"+table_len).value=arrayUIDRowValues[1];
		
		var cell = row.insertCell(3);
		var MakerRemarksid = 'MakerRemark'+table_len;
		cell.innerHTML="<textarea maxlength='2000' rows='2' cols='25' id='MakerRemark"+table_len+"' onkeyup='checkRemarksUID(\""+MakerRemarksid+"\");'></textarea>";
		if(arrayUIDRowValues!='')
		document.getElementById("MakerRemark"+table_len).value=arrayUIDRowValues[2];
	
		var cell = row.insertCell(4);
		var CheckerRemarksid = 'CheckerRemark'+table_len;
		cell.innerHTML="<textarea maxlength='2000' rows='2' cols='25' id='CheckerRemark"+table_len+"' onkeyup='checkRemarksUID(\""+CheckerRemarksid+"\");'></textarea>";
		if(arrayUIDRowValues!='')
		document.getElementById("CheckerRemark"+table_len).value=arrayUIDRowValues[3];
		
		var cell = row.insertCell(5);
		var deleteid='image'+table_len;
		cell.innerHTML = "<img id='image"+table_len+"' src='/SRO/webtop/images/delete.gif' style='width:21px;height:21px;border:0'; onclick='deleteRowsFromUIDGridWithIndex();'>";	
		
		var UIDDisable=document.getElementById("uid"+table_len);
		var InitiatorRemarksDisable=document.getElementById("InitiatorRemark"+table_len);
		var MakerRemarksDisable=document.getElementById("MakerRemark"+table_len);
		var CheckerRemarksDisable=document.getElementById("CheckerRemark"+table_len);
		var deleteDisable=document.getElementById(deleteid);
		var SRNoDisable=document.getElementById("srno"+table_len);
		deleteDisable.disabled=true;
		SRNoDisable.disabled=true;
		//Added Mail_Init Workstep for Mail Management Changes
		if(CurrentWS =='Introduction' || CurrentWS=='Mail_Initiation' || CurrentWS=='Mail_Followup' || CurrentWS=="Initiator_Reject" || CurrentWS=="Maker")
		{
			deleteDisable.disabled=false;
		}
		else
		{
			deleteDisable.disabled=true;
		}
		//Added Mail_Init Workstep for Mail Management Changes
		if(CurrentWS =='Introduction' || CurrentWS=='Mail_Initiation' || CurrentWS=='Mail_Followup' || CurrentWS=="Initiator_Reject" || CurrentWS=="Maker")
		{
			UIDDisable.disabled=false;
		}
		else
		{
			UIDDisable.disabled=true;
		}
		
		if(CurrentWS =='Maker')
		{
			MakerRemarksDisable.disabled=false;
		}
		else
		{
			MakerRemarksDisable.disabled=true;
		}
		
		if(CurrentWS =='Checker')
		{
			CheckerRemarksDisable.disabled=false;
		}
		else
		{
			CheckerRemarksDisable.disabled=true;
		}
		//Added Mail_Init Workstep for Mail Management Changes
		if(CurrentWS == 'Introduction' || CurrentWS=='Mail_Initiation' || CurrentWS=='Mail_Followup' || CurrentWS == 'Initiator_Reject')
		{
			InitiatorRemarksDisable.disabled=false;
		}
		else
		{
			InitiatorRemarksDisable.disabled=true;
		}
		
		// applying tooltip on uid rows	
		$(document).ready(function() {
			$("input:text,select,textarea").wrap("<div class='tooltip-wrapper' style='display:inline'></div>");
			$("div.tooltip-wrapper").mouseover(function() {
				$(this).attr('title', $(this).children().val());
			});
		});
		
}

function disabledecision(wsname)
{
	var x = document.getElementById("selectDecision");
	if(wsname == 'Checker')
	{
		if(document.getElementById("wdesk:Dec_Maker").value == "Reject")
		{
			for (var i = 0; i < x.options.length; i++) 
				{
					if(x.options[i].value=='Approve-Exit' || x.options[i].value=='Approve to Team')
					{
						//x.options[i].disabled = true;
					}
				}		
		}	
		//added for mail management changes May-26 to validate PB collections team
		if(document.getElementById("wdesk:Team").value == "PB Collections")
		{
			for (var i = 0; i < x.options.length; i++) 
				{
					if(x.options[i].value=='Approve-Exit' )
					{
						//x.options[i].disabled = true;
					}
				}		
		}
		//End for mail management changes May-26 to validate PB collections team
	}
	//Nov-15 SRO FATCA -Diable Add Info Requireied in Mail Init WS
	if(wsname == 'Mail_Initiation')
	{
	  if(document.getElementById("wdesk:Email_WI_Init_Flag").value == "FATCA")
		{
	      for (var i = 0; i < x.options.length; i++) 
				{
					if(x.options[i].value=='Additional Information Required')
					{
						x.options[i].disabled = true;
					}
				}
		}
	}
		//End of FATCA -ADDitional INFO Required
}
