//Dropdown values of Decision
function loadDecisionFromMaster(currWorkstep)
{	
	if((parent.document.title).indexOf("(read only)")>0)
		return;
		
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
		xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		xhr=new ActiveXObject("Microsoft.XMLHTTP");	
	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=selectDecision&WSNAME="+currWorkstep;
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error in Loading Dropdown Values for Decision.");
			return false;
		}
		else
		{
			values = ajaxResult.split("~");
			for(var j=0;j<values.length;j++)
			{
				var opt = document.createElement("option");
				opt.text = values[j];
				opt.value =values[j];
				document.getElementById("selectDecision").options.add(opt);
			}				 
		}
	}
	else 
	{
		alert("Error in Loading Drowdown Decision.");
		return false;
	}	
	
	// getting already raised exceptions from database at onload on required workstep added on 18042018 by Angad
	if(true)
	{
		var currCheckList=document.getElementById('H_CHECKLIST').value;
		var workitemNo = document.getElementById('wdesk:WI_NAME').value;
		currCheckList = alreadyRaised(workitemNo,currCheckList);
		if(currCheckList != "null" && currCheckList != "Error" && currCheckList != "")
		{
			document.getElementById('H_CHECKLIST').value = currCheckList;
			document.getElementById('H_CHECKLIST_TEMP').value = currCheckList;
		}
	}
	//************************************	
	
}
//Added on 17/06/2021 to load values of Channel SubGroup.
function loadPriority(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=Priority";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Priority");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 			 
	}
	else 
	{
		alert("Error while Loading dropdown for Priority.");
		return false;
	}
}
//Added on 17/06/2021 to load values of Channel SubGroup.
function loadChannelSubGroup(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=ChannelSubGroup";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for ChannelSubGroup");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 			 
	}
	else 
	{
		alert("Error while Loading dropdown for ChannelSubGroup.");
		return false;
	}

}
//Added on 17/06/2021 to load values of TWC/ABF.
function loadTWCABF(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=TwcAbf";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for TWCABF");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 			 
	}
	else 
	{
		alert("Error while Loading dropdown for TWCABF.");
		return false;
	}
}
//Dropdown values of Nature of Facility
function loadNatureOfFacility(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=Nature_of_Facility";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Nature of Facility");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for Nature of Facility.");
		return false;
	}

}

//Dropdown values of Tenor Frequency
function loadTenorFrequency(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=Tenor_Frequency";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Tenor Frequency");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for Tenor Frequency.");
		return false;
	}

}

function loadInterestType(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=Interest_Type";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Interest_Type");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for Interest_Type");
		return false;
	}

}

//added for security Document type editable dropdown
function editablesecuritydropdown()
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=SecurityDocType";			
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult.indexOf("Exception")==0)
		 {
			alert("Unknown Exception while working with request type SecurityDocType");
			return false;
		 }							 
		document.getElementById("AutocompleteValuesSecurityDocType").value=ajaxResult;
	}
	else 
	{
		alert("Error while Loading Dropdown security document type");
		return false;
	}
}

function searchableNatureOfFacility()
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=Nature_of_Facility";			
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult.indexOf("Exception")==0)
		 {
			alert("Unknown Exception while working with request type Nature Of Facility");
			return false;
		 }							 
		document.getElementById("AutocompleteValuesNatureOfFacility").value=ajaxResult;
	}
	else 
	{
		alert("Error while Loading Dropdown Nature Of Facility type");
		return false;
	}
}

function searchableInterestDesc()
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=Interest_Description";			
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult.indexOf("Exception")==0)
		 {
			alert("Unknown Exception while working with request type Interest_Description");
			return false;
		 }							 
		document.getElementById("AutocompleteValuesInterestDesc").value=ajaxResult;
	}
	else 
	{
		alert("Error while Loading Dropdown Interest_Description");
		return false;
	}
}


function searchableCountry()
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=Dealing_With_Country";			
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult.indexOf("Exception")==0)
		 {
			alert("Unknown Exception while working with request type Dealing With country");
			return false;
		 }							 
		document.getElementById("AutocompleteValuesCountry").value=ajaxResult;
	}
	else 
	{
		alert("Error while Loading Dropdown security document type");
		return false;
	}
}

function validatesecuritydoctype(req,securityvalidate)
{
	//alert("inside validate");
	//countryvalidate = countryvalidate.replaceAll1(", ", ",");
	var securityvalidate=securityvalidate.split("~");
	var match ='';
	document.getElementById(req).value = myTrim(document.getElementById(req).value);
	for(var i=0;i<=securityvalidate.length;i++)
	{
			if(document.getElementById(req).value==securityvalidate[i])
			match='matched';
	}
	if(match =='matched')
	{
		return false;
	}
		
}
function onSelectFun(doctypeid,docdescid)
{
	$("#"+comboidForSecurityDocType[0]+rowNo).autocomplete({
			select : function (event,ui){
				var value=ui.item.value
				alert("hello");
			}
			});
}	
function setAutocompleteDataForgridCombo(rowNo) 
{
	var comboidForSecurityDocType=['securityDocumentType'];
	var data = "";
	var ele = document.getElementById("AutocompleteValuesSecurityDocType");
	if (ele)
		data = ele.value;
	if (data != null && data != "") {
		var temp = data.split("=");
		var values = temp[0].split("~");
		$(document).ready(function() {
			$("#"+comboidForSecurityDocType[0]+rowNo).autocomplete({
			source: values
			});
		});
		$("#"+comboidForSecurityDocType[0]+rowNo).autocomplete({
			select : function (event,ui){
				var value=ui.item.value
				//alert("111"+value);
				var elementForId=document.activeElement.id;
				//alert("element is "+elementForId);
				setDocDescription(value,elementForId);
				//alert("222");
			}
		});
	}
	
	//Modified on 02/04/2019
	var comboidForNatureOfFacility=['Nature_of_Facility'];
	data = "";
	var ele = document.getElementById("AutocompleteValuesNatureOfFacility");
	if (ele)
		data = ele.value;
		
	if (data != null && data != "") {
		var temp = data.split("=");
		var values = temp[0].split("~");
		$(document).ready(function() {
			$("#"+comboidForNatureOfFacility[0]+rowNo).autocomplete({
			source: values
			});
		});
		$("#"+comboidForNatureOfFacility[0]+rowNo).autocomplete({
			select : function (event,ui){
				var value=ui.item.value
				//alert(value);
				var elementForId=document.activeElement.id;
				//Auto-populate Commission
				setCommission(value,elementForId);
				//Auto-populate Product Level Conditions
				setProductLevelCondition(value,elementForId);
				//Auto-populate Purpose
				setFacilityPurpose(value,elementForId);
				
				auto_grow(document.getElementById(elementForId)); // auto grow for falicity type
			}
		});
	}

	/*data = "";
	var comboidForFacilityPurpose=['Purpose'];
	ele = document.getElementById("AutocompleteValuesFacilityPurpose");
	if (ele)
	
		data = ele.value;
	if (data != null && data != "") {
		var temp = data.split("=");
		var values = temp[0].split("~");
		$(document).ready(function() {
			$("#"+comboidForFacilityPurpose[0]+rowNo).autocomplete({source: values});
			
		});				
	}*/
	
	data = "";
	var comboidForInterestDesc=['Interest'];
	ele = document.getElementById("AutocompleteValuesInterestDesc");
	if (ele)
	
		data = ele.value;
	if (data != null && data != "") {
		var temp = data.split("=");
		var values = temp[0].split("~");
		$(document).ready(function() {
			$("#"+comboidForInterestDesc[0]+rowNo).autocomplete({source: values});
			
		});				
	}
	
}

function validateFacilityType(id)
{
	var match = '';
	var allFacilityData = document.getElementById("AutocompleteValuesNatureOfFacility").value;
	var tempData = allFacilityData.split("=");
	var FacilityData = tempData[0].split("~");
	for(var i=0;i<=FacilityData.length;i++)
	{
		if(document.getElementById(id).value==FacilityData[i])
		{
			match='matched';
			break;
		}	
	}
	if(match !='matched')
	{
		document.getElementById(id).value='';
	}
}

function setDocDescription(value,doctypeid)
{
	var securitydoctypevalue =  value;
	//var integerId=doctypeid.replace("securityDocumentType","");
	var docdescid='securityDocumentDescription'+doctypeid.replace("securityDocumentType","");
	//alert("Integer Id is "+docdescid);
	var url = '';
	var xhr;
	var ajaxResult;
	var temp=securitydoctypevalue.split("%").join("PPPERCCCENTT");
	temp=temp.split("&").join("AMPNDCHAR");
	temp=temp.split(",").join("CCCOMMAAA");
	temp=temp.split("'").join("ENSQOUTES");
	var param="&reqType=SecurityDocDescription&SecurityDocSelected="+temp;
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type SecurityDocType");
			return false;
		}

		if(ajaxResult==-1)
		{
			document.getElementById(docdescid).value="";
			return false;
		}	
		
		if (ajaxResult!='')
			document.getElementById(docdescid).value=ajaxResult;
	}
	else 
	{
		alert("Error while Loading security document description");
		return false;
	}
}	

/*function editablepurposedropdown()
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=facilitypurpose";			
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult.indexOf("Exception")==0)
		 {
			alert("Unknown Exception while working with request type SecurityDocType");
			return false;
		 }							 
		document.getElementById("AutocompleteValuesFacilityPurpose").value=ajaxResult;
	}
	else 
	{
		alert("Error while Loading Dropdown security document type");
		return false;
	}
}*/
/*function validatefacilitypurpose(req,purposevalidate)
{
	purposevalidate=purposevalidate.split("~");
	var match ='';
	document.getElementById(req).value = myTrim(document.getElementById(req).value);
	for(var i=0;i<=purposevalidate.length;i++)
	{
			if(document.getElementById(req).value==purposevalidate[i])
			match='matched';
	}
	
	if(document.getElementById(req).value.indexOf("<&PURPOSE&>")!=-1)
    {
	   var purpose = encodeURIComponent('<&PURPOSE&>');
	   var res = purpose.split('%').join('_');
	   res = res.split('PURPOSE').join('_');
	   res= res.split(/[a-zA-Z]+|[0-9]/g).join('_');
	   document.getElementById(req).value = document.getElementById(req).value.replace('<&PURPOSE&>',res);
	   match='matched';
	}
	  
	if(match =='matched')
	{
		return false;
	}
	
	
		
}*/

//Set Value of ComboBox to TextBox.
function setComboValueToTextBox(dropdown, inputTextBoxId) 
{
	if(dropdown.id=="selectDecision")
	{
		if(dropdown.value.indexOf("Reject")!=-1){
			document.getElementById("Reject_Reason").disabled=false;
		    document.getElementById("Reject_Reason").classList.remove("EWButtonRBSRMRejectReason");
			document.getElementById("Reject_Reason").classList.add("EWButtonRBSRM");
		}else {
			document.getElementById("Reject_Reason").disabled=true;
			document.getElementById("Reject_Reason").classList.remove("EWButtonRBSRM");
			document.getElementById("Reject_Reason").classList.add("EWButtonRBSRMRejectReason");
		}
			
	}
	document.getElementById(inputTextBoxId).value = dropdown.value;
	
	//alert("Value after:--"+document.getElementById(inputTextBoxId).value);
			
}


function myTrim(x) 
{
	return x.replace(/^\s+|\s+$/gm,'');
}

//Added on 19/02/2019 to calculate RB5Checks Difference
function RB5Checks()
{
	var diffDays=0;
	var CBRB_Maker_Submit_datetime = document.getElementById("wdesk:CBRBMaker_Done_On").value;
	if(CBRB_Maker_Submit_datetime!="")
	{
		var a = CBRB_Maker_Submit_datetime.split(" ");
		var d = a[0].split("/");
		var t = a[1].split(":");
		var temp=d[1]+ "/"+ d[0] + "/" + d[2] + " " + t[0] + ":" + t[1] + ":"+t[2];
		
		var formatedCBRB_Maker_Submit_datetime = new Date(temp);
		CBRB_Maker_Submit_datetime = new Date(formatedCBRB_Maker_Submit_datetime);
		
		
		var currentdate = new Date();
		
		var utc1 = Date.UTC(CBRB_Maker_Submit_datetime.getFullYear(), CBRB_Maker_Submit_datetime.getMonth(), CBRB_Maker_Submit_datetime.getDate());
		var utc2 = Date.UTC(currentdate.getFullYear(), currentdate.getMonth(), currentdate.getDate());

		var _MS_PER_DAY = 1000 * 60 * 60 * 24;
		diffDays=Math.floor((utc2 - utc1) / _MS_PER_DAY);
	}
	
	return diffDays;
		
}
//Added on 19/02/2019 to calculate AECBChecks Difference
function AECBChecks()
{
	var diffDays=0;
	var AECB_Submit_datetime = document.getElementById("wdesk:AECB_Done_On").value;
	if(AECB_Submit_datetime!="")
	{
		var a = AECB_Submit_datetime.split(" ");
		var d = a[0].split("/");
		var t = a[1].split(":");
		var temp=d[1]+ "/"+ d[0] + "/" + d[2] + " " + t[0] + ":" + t[1] + ":"+t[2];
		var formatedAECB_Submit_datetime = new Date(temp);
		AECB_Submit_datetime = new Date(formatedAECB_Submit_datetime);
		
		var currdate = new Date();
		var datetime =(currdate.getMonth()+1)+ "/"
		+ currdate.getDate() + "/" 
		+ currdate.getFullYear() + " "  
		+ currdate.getHours() + ":"  
		+ currdate.getMinutes() + ":" 
		+ currdate.getSeconds();
		var currentdate = new Date(datetime);
		
		var utc1 = Date.UTC(AECB_Submit_datetime.getFullYear(), AECB_Submit_datetime.getMonth(), AECB_Submit_datetime.getDate());
		var utc2 = Date.UTC(currentdate.getFullYear(), currentdate.getMonth(), currentdate.getDate());

		var _MS_PER_DAY = 1000 * 60 * 60 * 24;
		var diffDays=Math.floor((utc2 - utc1) / _MS_PER_DAY);
	}
	return diffDays;
}
//Added on 19/02/2019 to check difference in days and enableDisable decision.
function differenceOfDays(workstepName)
{
	var CBRB_Maker_Difference=RB5Checks();
	var AECB_Difference=AECBChecks();
	
	var performcheckdays_CBRB = document.getElementById('performcheckdays_CBRB').value;
	var performcheckdays_AECB = document.getElementById('performcheckdays_AECB').value;
	
	if(workstepName=="Quality_Control")
	{
		if(parseInt(CBRB_Maker_Difference) > performcheckdays_CBRB)
		{
			if(document.getElementById("selectDecision").value=="Approve")
			{
				document.getElementById("selectDecision").value="";
				document.getElementById("selectDecision").focus(true);
				alert("Approve decision cannot be selected as it's been "+CBRB_Maker_Difference+" days since CBRB Checker approved the request");
				return false;
			}
		}
	}
	if(workstepName=="Sales_Data_Entry" || workstepName=="Business_Approver_1st" || workstepName=="Business_Approver_2nd" || workstepName=="Business_Approver_3rd" || workstepName=="AU_Officer" || workstepName=="Credit_Hold" || workstepName=="Credit_Document_Checker")
	//if(workstepName=="Credit_Analyst" || workstepName=="AU_Officer" || workstepName=="Sales_Data_Entry")
	{
		if(document.getElementById("selectDecision").value=="Approve" || document.getElementById("selectDecision").value=="Submit" || document.getElementById("selectDecision").value=="Originals Received")
		{
			if(parseInt(CBRB_Maker_Difference) > performcheckdays_CBRB && parseInt(AECB_Difference) > performcheckdays_AECB)
			{
				document.getElementById("selectDecision").value="";
				document.getElementById("selectDecision").focus(true);
				alert(document.getElementById("selectDecision").value+" decision cannot be selected as it's been "+CBRB_Maker_Difference+" days since CBRB Maker Approved the request and "+AECB_Difference+" day since AECB approved the request");
				return false;
			}
			if(parseInt(CBRB_Maker_Difference) > performcheckdays_CBRB)
			{
				document.getElementById("selectDecision").value="";
				document.getElementById("selectDecision").focus(true);
				alert(document.getElementById("selectDecision").value+" decision cannot be selected as it's been "+CBRB_Maker_Difference+" days since CBRB Maker Approved the request");
				return false;
			}
			if(parseInt(AECB_Difference) > performcheckdays_AECB)
			{
				document.getElementById("selectDecision").value="";
				document.getElementById("selectDecision").focus(true);
				alert(document.getElementById("selectDecision").value+" decision cannot be selected as it's been "+AECB_Difference+" days since AECB Approved the request");
				return false;
			}
		}
	}
	//if(workstepName=="Credit_Approver_1st" || workstepName=="Credit_Approver_2nd" || workstepName=="Sales_Validation" || workstepName=="CROPS_Finalization_Maker" || workstepName=="CROPS_Finalization_Checker" || workstepName=="Attach_Final_Document")
	if(workstepName=="Credit_Analyst" || workstepName=="Credit_Approver_1st" || workstepName=="Credit_Approver_2nd" || workstepName=="Sales_Reject")
	{
		if(document.getElementById("selectDecision").value=="Approve" || document.getElementById("selectDecision").value=="Submit")
		{
			if(parseInt(CBRB_Maker_Difference) > performcheckdays_CBRB || parseInt(AECB_Difference) > performcheckdays_AECB)
			{
				if (confirm("CBRB/AECB has expired. Do you wish to continue?") == false)
				{
					document.getElementById("selectDecision").value="";
					document.getElementById("selectDecision").focus(true);
					return false;
				}	
			}
			/*if(parseInt(CBRB_Maker_Difference) > performcheckdays_CBRB)
			{
				if (confirm(document.getElementById("selectDecision").value+" decision cannot be selected as it's been "+CBRB_Maker_Difference+" days since CBRB Maker Approved the request") == false )
				{
					document.getElementById("selectDecision").value="";
					document.getElementById("selectDecision").focus(true);
					return false;
				}
			}
			if(parseInt(AECB_Difference) > performcheckdays_AECB)
			{
				if (confirm(document.getElementById("selectDecision").value+" decision cannot be selected as it's been "+AECB_Difference+" days since AECB Approved the request") == false)
				{
					document.getElementById("selectDecision").value="";
					document.getElementById("selectDecision").focus(true);
					return false;
				}
			}*/
		}
	}
	if(workstepName=="Attach_Final_Document" || workstepName=="Sales_Reject" || workstepName=="Sales_Data_Entry")
	{
		if(document.getElementById('selectDecision').value=='Reperform Checks')
		{
			confirm("Kindly check CBRB/AECB checks are Required or Not Required");
			document.getElementById('CBRB_Required').disabled = false;
			//stutee.mishra
			document.getElementById('CBRB_Required').focus(true);
			document.getElementById('AECB_Required').disabled = false;
		
			if(parseInt(CBRB_Maker_Difference) > performcheckdays_CBRB)
				document.getElementById("wdesk:RB5_Checks_Expired").value='Y';
			else 
				document.getElementById("wdesk:RB5_Checks_Expired").value='N';
			
			
			if(parseInt(AECB_Difference) > performcheckdays_AECB)
				document.getElementById("wdesk:AECB_Checks_Expired").value='Y';
			else 
				document.getElementById("wdesk:AECB_Checks_Expired").value='N';
		}
	}
	
}

//Added on 20/02/2019 to set value of Dropdown  CBRB_Required and AECB_Required
function loadDropDownValues()
{
	var dropDownArray=['CBRB_Required','AECB_Required','IslamicOrConventional','PRIORITY','TWCABF','CHANNELSUBGROUP'];
	var textBoxArray=['wdesk:CBRB_Required','wdesk:AECB_Required','wdesk:Islamic_Or_Conventional','wdesk:PRIORITY','wdesk:TWCABF','wdesk:CHANNELSUBGROUP'];
	for(var i=0;i<dropDownArray.length;i++)
	{
		var textBoxValue=document.getElementById(textBoxArray[i]).value;
		if(textBoxValue!='')
			document.getElementById(dropDownArray[i]).value=textBoxValue;
	}
	setAutocompleteData();
	
}

function getExpiryDays()
{
	var url = '';
	var xhr;
	var ajaxResult;
	var param="&reqType=ExpiryDays";			
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		 ajaxResult = xhr.responseText;
		 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult.indexOf("Exception")==0)
		 {
			alert("Unknown Exception while working with request type Expiry days");
			return false;
		 }
		 else{
			var values=ajaxResult.split('~');
			document.getElementById('performcheckdays_AECB').value=values[0];
			document.getElementById('performcheckdays_CBRB').value=values[1];
			
			
		 }
	}
	else 
	{
		alert("Error while getting Expiry days");
		return false;
	}
}
function loadROCodeFromMaster(currWorkstep,ROCodeSelected)
{
	if(currWorkstep=='Sales_Data_Entry'|| currWorkstep=='DigiOnboard_Initial_Doc_review'){
		var url='';
		var xhr;
		var ajaxResult;
		var ifROActive=false; // Changed by Sajan for RO that is not active 03/03/2019
		if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
		url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp?reqType=ROCode&WSNAME='+currWorkstep;
		xhr.open("GET",url,false);
		xhr.send(null);
		if (xhr.status == 200)
		{
			 ajaxResult = xhr.responseText;
			 ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
			 if(ajaxResult=='-1')
			 {
				alert("Error while loading dropdown values for ROCode");
				return false;
			 }				 
			 values = ajaxResult.split("~");
			 for(var j=0;j<values.length;j++)
			 {
				var opt = document.createElement("option");
				opt.text = values[j];
				opt.value =values[j];
				if(values[j]==ROCodeSelected)
				{
					opt.selected='selected';
					ifROActive=true;
				}
				document.getElementById('wdesk:RO_Code').options.add(opt);
			 }
			//If condition added by Sajan for RM that is not active 03/03/2019
			 if(ROCodeSelected !='')
			 {
				 if(ifROActive==false)
				 {
					var opt = document.createElement("option");
					opt.text=ROCodeSelected;
					opt.value=ROCodeSelected;
					opt.selected='selected';
					document.getElementById('wdesk:RO_Code').options.add(opt);
				 }
			 }
			 // Changes end here 03/03/2019		 
		}
		else 
		{
			alert("Error while Loading Drop down ROCode.");
			return false;
		}
	}
	else{
		return true;
	}
	
}
function setAutocompleteData() 
{
		var data = "";
		var ele = document.getElementById("AutocompleteValuesCountry");
		if (ele)
			
			//data = "country_search="+ele.value;
			data = ele.value;
		if (data != null && data != "") {
			//data = data.replace('{', '').replace('}', '');
			var temp = data.split("=");
			var values = temp[0].split("~");

			//added for country field smart search by Nikita 
			$(document).ready(function() { 
				$("#custdealingwithcountry_search").autocomplete({source: values});
			});				
		}
}


//Added on 20/02/2019
//Dropdown values of Tranche Status
function loadTrancheStatus(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=tranche_status";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Tenor Frequency");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for Tenor Frequency.");
		return false;
	}

}
//Added on 26/02/2019
//Dropdown values of Product Identifier
function loadProductIdentifier(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=ProductIdentifierdropdown";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Product Identifier");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			if(opt.value!="")
				document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for Interest.");
		return false;
	}

}

function loadTypeOfLA(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=TypeOfLA";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Type Of LA");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			if(opt.value!="")
				document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for type of LA.");
		return false;
	}

}

function loadRequestType(id)
{
	var url = '';
	var xhr;
	var ajaxResult;		
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");

	url = "/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp";
	var param="&reqType=RequestType";
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult=='-1')
		{
			alert("Error while loading dropdown values for Request Type");
			return false;
		}				 
		 
		values = ajaxResult.split("~");
		for(var j=0;j<values.length;j++)
		{
			var opt = document.createElement("option");
			opt.text = values[j];
			opt.value =values[j];
			if(opt.value!="")
				document.getElementById(id).options.add(opt);
		}				 
					 
	}
	else 
	{
		alert("Error while Loading dropdown for Request Type.");
		return false;
	}

}

function loadDealingWithCountries()
{
	var deaingWithCountries=document.getElementById('wdesk:dealingWithCountries').value;
	var values = deaingWithCountries.split("#");
	for(var j=0;j<values.length;j++)
	{
		var opt = document.createElement("option");
		opt.text = values[j];
		opt.value =values[j];
		if(opt.value!="")
			document.getElementById('countryList').options.add(opt);
	}
}

function alreadyRaised(WorkitemName,H_Checklist) {
	var xhr;
	var ajaxResult;
	ajaxResult="";
	var reqType = "TWC_ISExceptionRaised";

	if(window.XMLHttpRequest)
		 xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
		 xhr=new ActiveXObject("Microsoft.XMLHTTP");
		 
	H_Checklist=H_Checklist.replace(/#/g,'`')
	
	var url = "/TWC/CustomForms/TWC_Specific/HandleAjaxProcedures.jsp";
	var param="&WorkitemName="+WorkitemName+"&reqType="+reqType+"&H_Checklist="+H_Checklist;

	 xhr.open("POST",url,false);
	 xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	 xhr.send(param);

	if (xhr.status == 200) {
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
	}
	else {
		alert("Error while getting exception status");
		return "";
	}
	return ajaxResult;
}

//Added on 02/04/2019 to auto populate Commission
function setCommission(value,natureOfFacilityid)
{
	var natureOfFacility =  value;
	var commissionId='Commission'+natureOfFacilityid.replace("Nature_of_Facility","");
	var url = '';
	var xhr;
	var ajaxResult;
	var temp=natureOfFacility.split("%").join("PPPERCCCENTT");
	temp=temp.split("&").join("AMPNDCHAR");
	temp=temp.split(",").join("CCCOMMAAA");
	temp=temp.split("'").join("ENSQOUTES");
	var param="&reqType=Commission&NauterofFacilitySelected="+temp;
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type Commission");
			return false;
		}

		if(ajaxResult==-1)
		{
			document.getElementById(commissionId).value="";
			return false;
		}	
		
		if (ajaxResult!='')
			document.getElementById(commissionId).value=ajaxResult.split("<br>").join('\r');
	}
	else 
	{
		alert("Error while Loading Commission.");
		return false;
	}
}	
//Added on 02/04/2019 to auto populate Product 
function setProductLevelCondition(value,natureOfFacilityid)
{
	var natureOfFacility =  value;
	var ProductLevelConditionsId='Product_Level_Conditions'+natureOfFacilityid.replace("Nature_of_Facility","");
	var url = '';
	var xhr;
	var ajaxResult;
	var temp=natureOfFacility.split("%").join("PPPERCCCENTT");
	temp=temp.split("&").join("AMPNDCHAR");
	temp=temp.split(",").join("CCCOMMAAA");
	temp=temp.split("'").join("ENSQOUTES");
	var param="&reqType=ProductLevelConditions&NauterofFacilitySelected="+temp;
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type Product_Level_Conditions");
			return false;
		}

		if(ajaxResult==-1)
		{
			document.getElementById(ProductLevelConditionsId).value="";
			return false;
		}	
		
		if (ajaxResult!='')
		{
			//alert("AK 101");
			ajaxResult=ajaxResult.split('NEWTAB').join('\t');
			document.getElementById(ProductLevelConditionsId).value=ajaxResult.split("<br>").join('\r');
			if(ajaxResult.indexOf('.*[1-9]+.*'))
			{
				
				ajaxResult=ajaxResult.split(/([0-9]+.)/).join('\n');
				
			}
		}
		
	}
	else 
	{
		alert("Error while Loading Product_Level_Conditions.");
		return false;
	}
}	


function setFacilityPurpose(value,NatureOfFacilityId)
{
	var NauterofFacility =  value;
	var Purposeid='Purpose'+NatureOfFacilityId.replace("Nature_of_Facility","");
	var url = '';
	var xhr;
	var ajaxResult;
	var temp=NauterofFacility.split("%").join("PPPERCCCENTT");
	temp=temp.split("&").join("AMPNDCHAR");
	temp=temp.split(",").join("CCCOMMAAA");
	temp=temp.split("'").join("ENSQOUTES");
	var param="&reqType=facilitypurpose&NauterofFacilitySelected="+temp;
	if(window.XMLHttpRequest)
	xhr=new XMLHttpRequest();
	else if(window.ActiveXObject)
	xhr=new ActiveXObject("Microsoft.XMLHTTP");
	
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	xhr.open("POST",url,false);
	xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
	xhr.send(param);
	if (xhr.status == 200)
	{	
		ajaxResult = xhr.responseText;
		ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		if(ajaxResult.indexOf("Exception")==0)
		{
			alert("Unknown Exception while working with request type Purpose");
			return false;
		}

		if(ajaxResult==-1)
		{
			document.getElementById(Purposeid).value="";
			return false;
		}	
		
		if (ajaxResult!='')
		{
			//alert("AK 101");
			ajaxResult=ajaxResult.split('NEWTAB').join('\t');
			document.getElementById(Purposeid).value=ajaxResult.split("<br>").join('\r');
			if(ajaxResult.indexOf('.*[1-9]+.*'))
			{
				ajaxResult=ajaxResult.split(/([0-9]+.)/).join('\n');
			}
			auto_grow(document.getElementById(Purposeid)); // auto grow for purpose
		}
		
	}
	else 
	{
		alert("Error while Loading Purpose.");
		return false;
	}
}



		
function loadPartnerCodeFromMaster(wsname,id,ReqType,SelectedValue)
{
	
	var url = '';
		var xhr;
	var ajaxResult;		
		if(window.XMLHttpRequest)
			xhr=new XMLHttpRequest();
		else if(window.ActiveXObject)
			xhr=new ActiveXObject("Microsoft.XMLHTTP");
			
	url = '/TWC/CustomForms/TWC_Specific/DropDownLoad.jsp';
	var param="&reqType="+ReqType+ "&WSNAME="+wsname;
		xhr.open("POST",url,false);
		xhr.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		xhr.send(param);
		
		if (xhr.status == 200)
		{
			ajaxResult = xhr.responseText;
			ajaxResult = ajaxResult.replace(/^\s+|\s+$/gm,'');
		 if(ajaxResult=='-1')
			{
			alert("Error while loading dropdown values for "+ReqType);
				return false;
			}
				
		 values = ajaxResult.split("~");
		 for(var j=0;j<values.length;j++)
			{
			//var opt = document.createElement("option");
			
			var opt = document.createElement("option");
				opt.text = values[j];
				opt.value =values[j];
				if(values[j]==SelectedValue)
					opt.selected='selected';
				document.getElementById(id).options.add(opt);
				
					
									
				}
					 
		}
		else 
		{
		alert("Error while Loading for "+ReqType);
			return false;
		}
		

}


			
			
			

					
						
							
		
	
